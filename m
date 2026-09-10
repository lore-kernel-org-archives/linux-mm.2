Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F31C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D0DE6B0092; Thu, 10 Sep 2026 12:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587BE6B0093; Thu, 10 Sep 2026 12:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448FE6B0095; Thu, 10 Sep 2026 12:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8E86B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B29CC1C1CF4
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:01:59 +0000 (UTC)
X-FDA: 85198318758.01.7234858
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D5A454000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:01:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6Ecc6Mc;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789056117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpSB5Z1kR5NpKp4iKQtUtXAW2RtPNgSVe46ufvS2ECQ=;
	b=7rmbSI8ezsbzF1U/Lfb6/v32QNrCZuECN3xsNVDv5ozJtlbawM2vVqbMG/a78K7aIVvW2r
	Z5oxcZKqeXGwz6asvXmagND5cWVvy8OA2mQpCA4XeNciwJQa+O8meQ0cDZFY0bYdjw22zf
	oQesg5ZL0ocAexEXcEZMuALzfQJ/0XA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789056117;
	b=GtGH4dsHpOasIPmDje/LBOk6TqflWVHDqHYDRPkWe9s1ZF9iLK+O6CF1c+AsOCUFnRlIfx
	uYDHQY8XAARdhI612l0c3+2MveshJHB0mWq/onTv+pR0jspLtRa3AlRRftuGpejAl4mxaD
	2TtChXpFSBA53DG4B7kYjoAXdIRkb1w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6Ecc6Mc;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35C98600E2;
	Thu, 10 Sep 2026 16:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D331F000FF;
	Thu, 10 Sep 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789056116;
	bh=EpSB5Z1kR5NpKp4iKQtUtXAW2RtPNgSVe46ufvS2ECQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=c6Ecc6Mcv8m2/ntjf2/l/Fky9mr+wmCM8u6WjqrBOg4hgiDn7a81zNcI1KMnX6236
	 bH9po7PNAZa3CrecPxcBpcy89c0FGLOkq7/3E7Px3tOqLgOa/IDtotdqH9V4KoN2Nt
	 KBvC2v9Ys4fcBFtK3qXrCbX2gthXhS8vBS8E0MXRt4BM9zsYBKhRBvzfgGIqriafA8
	 rjxk1/4v21CbYlqr7/kEerrtDjZwoPdDag5Rr/8QAKTnMgYcP1EAryRDdK0HXp6FvD
	 JaQeFCl6rFERZaM45McKvC2t1U7TeS8JlyQ7IC/ccSFw6e0GzmyFIr5PckztK8kxGs
	 fjicH5VRgM6Ag==
Message-ID: <9e48cf7b-1700-4a85-af83-8883789ba87b@kernel.org>
Date: Thu, 10 Sep 2026 18:01:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, willy@infradead.org, jannh@google.com,
 paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
 <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
 <CAJuCfpEYdj=u0wczKRrsB8uDkbSzPy+hrsCo9TW9-3J3r3p0xQ@mail.gmail.com>
 <2336140f-c993-467a-b2eb-e99dc9427a59@kernel.org>
 <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJuCfpEL40p+vk6-km6_BBuE3+YY0WqkpbvQnQGFEo_73MAomQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: j4ew7cs1tkzg6m5p3c173yq68fehns9s
X-Rspamd-Queue-Id: D5A454000E
X-HE-Tag: 1789056117-682109
X-HE-Meta: U2FsdGVkX1+ItbmsGZBzcJ8Zeph9mLoS+V3SOY/tCWsscTby+rIxkXW63ICaaQYzzN+dTtrWMX0Tp9P3baYE0RfMzAZODMHz2x8RGUUm/5SfYbDJ9cAOxRCGO5tVlbyN2XPZhJMLAk1AmjINVaDpP1xCP91vpiV+18GDc+k2ZyfW5sWT0LYmC7W5xcJonWm8bnfQNxmgfc3qP2S2O+Vgq1l4oQpDL31+AOm1hL+S1s5UWYPHSlCR+BgafA+3kB+Z0P3MF2ZpFHt7Sm7lJkEAfn1ca9Flb96Rim7E+V41f47KvKDXx/+TKGqaoQj52usGSgC47S1jtOmuxKkt3/LD4TIKxG1bAuKO2kmTtWpTckAWXS8EZVii5GoLu4Y4gPLqgDZp5vR8ElDzlxTlSj0bLe/pjGJuEBdh8Qa4NAwSEp6oW1WQ0saSbjQPykvcy3DkaSzM16y5S1rW0txUO7zLlVBKEex+yPgJY0bcBDHN+9NvP58c+dCmxYBEXkLcAAphFlYas17n8WcVjvX4xhVvqSyUb6jkJbQxJlRbcfUSQ+oD4szwxSAlzc3hJwTXiVg1qGdspBEYGA50C6n8oqnW9b2W1RYNvaDVmrm8TAKh3GUTYfPVKJUYXlyxeY3A8q0Op8bwYjMyIR0jvP9TWendOFlOggXGkJD8HcUtu+fyTPVM/HNesk/81i7+wEc2IysUy2SI95KElzmxxKhRL0Mq1jlDzn/HDMPaOu69Lqj2PzEIRGb4puGvRyR+jsadGnx3dxin2ZHMSN1HdUHj9/Cp4zDe4k6D36VbM3Azl626XSrDdGAvbGx09/zCQx1UUSe4YyXeAV1qGVTUFjp9MZ2sqzQZqROuLltasJEWvFhPHpomHlY/TiGOG79BqSHk5WZ+f2bX4Cg/6uNGP2HfcwXQaKLn09C8KN2E4CK3RHSkp/ctTsSNzGFc2+DQ2Jq1EOJzBjolEwvw4fcJQqp+61h
 649W22Cq
 d9MCL2k7PFZ3xjwVUPS9SJqIMPiOoBhZNeekdIU34W4KNgqktBC3XF8KktCBTHKM+PauBrhK1cvNGQHE8OJzmb8hRE89Wwrn2bo8QSJ9u5XhmAl9tEfvSon3PnjiNOZoTBIg57GrP2dYzqKpMoG9/AlVtdMo3Gu1ByCivH0OnP496dMFTYAXfl9SNaeG9Y4hqcczCEBvvwreYlrxqsk6Tn7BSF9KjWSgvweC8FkwPSKb2VGBSOFdbBWhMHnTvA+5rJsYp1VriDCOpLtoFvnol0gASDHExhJr5/oUGqHwcjfkT42Mggzq9b+9y1kQMqajP40zpTcA5F2PZPFnEuUPbq6GVdc05UZfVCTOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 17:45, Suren Baghdasaryan wrote:
> On Thu, Sep 10, 2026 at 12:41 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 9/9/26 23:51, Suren Baghdasaryan wrote:
>>> On Wed, Sep 9, 2026 at 12:16 PM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Ok, just want to make sure I'm not missing something subtle.
>>>
>>>
>>> Ah, good to know.
>>>
>>>
>>> I see.
>>>
>>>
>>> I was obviously overthinking this :)
>>>
>>>
>>> Sounds good. Will update.
>>
>> Likely worth putting that into a prior cleanup patch, so there is less noise in
>> this patch.
> 
> Well, this is a cleanup specific for smap_gather_stats() funciton, so
> I would prefer to keep all the pieces in one place.

I meant as part of this series of course.

-- 
Cheers,

David

