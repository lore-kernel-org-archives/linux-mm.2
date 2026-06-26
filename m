Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E6B9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 20:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846DA6B0088; Fri, 26 Jun 2026 16:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7AA6B008A; Fri, 26 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7C86B0092; Fri, 26 Jun 2026 16:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 319F56B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:33:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FB381C65F4
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:33:28 +0000 (UTC)
X-FDA: 84923214096.11.F67EBF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id C73FD140005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:33:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OW/VYPnB";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782506006;
	b=eioto7urQpyEsPsMt0uiXyMDgx++QLqSMequUyWfj7nOxrqyoOxBHy57+RNIimtWS/YEk0
	oXA4Tw+Ps56lht+3KckVFfkAHfs8jsSRQ7x0/FO53fKMinR0nOje7psRvmt+cl9ZHCfgXI
	mSMWhzgnAR0JWgTZEmFTvy8mxGicMik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782506006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=so7ATgFGu/s7mYNzZJ+5Ol8L7q0igIYtf2J+vvbHPLo=;
	b=InFn67jKfWym5xYgh8itIvbwMVCLIbXDPn7CtDMs6A2XgJHPzAwJuZCc/ONE0ebrYbOm/D
	yZXQAeufxwTb0ahWeuaM3mtA/IM3YTyHdpysEPjN3b/YjGZEdanBcrJONxn3kLib5Dk9E1
	ye0JJ21dtuscuHluWrfNhz8YLO+VTDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OW/VYPnB";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB6D641E5E;
	Fri, 26 Jun 2026 20:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EED1F000E9;
	Fri, 26 Jun 2026 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782506005;
	bh=so7ATgFGu/s7mYNzZJ+5Ol8L7q0igIYtf2J+vvbHPLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OW/VYPnBPxPaW41CLCOBkDGD9vSstX/l5cZ+CC5yWBti3j3hRxBdzcSY42pP1k9nC
	 feLz+ls9IAVRZ1NZDntQw1xJ7ndrwY/Px84uSmBeRF+QTTR4gXkDIh5s3ETXvySBMp
	 s8lnG9pu2R6JR1W1v5B4qztvFVFxRncg8Y4QQGwpVSe1DYUtHsWPTySCGd9Pi5rK5E
	 xm+I/Ky1RGS7Q2j/4Vfx64uOoLC5EpPrwlYc3C9SOIVxuPSjpTGlzNjp3wbwIIWl+u
	 R5CDaKvIvRlvPV77kesQUg7XrxMw23lg4b8lmijRUncxrOBjvFzO9U/wrgaMuI5pFa
	 HaT6KaZL/04jg==
Message-ID: <05538f68-c3ec-422d-babb-7427068f79f4@kernel.org>
Date: Fri, 26 Jun 2026 22:33:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: __access_remote_vm with per-VMA lock
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-mm@kvack.org, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, kernel-team@meta.com
References: <20260625015053.2445008-1-riel@surriel.com>
 <b0d9ce70-ebb7-4b79-9a35-257b69daff7a@kernel.org>
 <5a4ff628c1b947f9cd4da53e1e64b3934a1f2d9a.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5a4ff628c1b947f9cd4da53e1e64b3934a1f2d9a.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C73FD140005
X-Rspam-User: 
X-Stat-Signature: 3sd5fjs8qfi5hixgq873mwjuqq6iyzsp
X-HE-Tag: 1782506006-997263
X-HE-Meta: U2FsdGVkX18GaGZ+glm00SZ2xa58hc3/PUYCTeYN9ttdhH1str5EMNqdQoWWosmjqC7lWkDov1oG/a49TY9Gkg5k6ZxT1dKqKJUTVEO793SMBWrG2qcAXaSxOWqnXBLz02n5Av2akdyts6D5cRXcjzFDf7aMgjkbImNuXFJvyD+kQKEpzEtrHUPr6BKfNFedFsjoN+ol+6FMcJ35ReujIAc4MbkMosQ9D3wd0epYV5WWPxm3StWhvJswf43+LgVGV6TIqsFtL8nKDRk3V3hgce8v/bmsVxPlVlpQU/J7OI5Tw9k8ftxRwT4J77wRkwlo9Puhz+5vKd4GAzJXrJlXuCY2PRsXvrhS3ar6hKtMpUFmQRXbxyu15SzkzFCHKn0RWEDY72UdOaI9/eHTXx3TfggrXJ84TaXWscJK2AsRJcbC/jbj4rNE+qie1En/J5tsnoJ+LbH0FjeF871/siJw4FZG3yqOVI9MNGIHoekmd57g5Zo1nY9tzp6c6DtgsURcktDPi2iEsWos2GRsMPVcMMyegJhqZ75t0bB+v1WLWHfXvy4suz//U621453FyPe4B69wb9+NNsmze690DS28ncUGImw0PgldPwjxGElopkfsMu62CFaOHj4WFdoH6+PFYf83y5TjIPKzZCwfr9oTVYiQ2/JL+/oaD0H6l2Dc/GIxZ3DkkfauQZYGfMhTX9aV6ntSQA4YiZM8Q9ps1uiKdBe33jovW4ocAfOeV+I4QU7UQiO1ejBQWB/ilkFjFLAT+yFSqDtHpOLmNPL4n3q5JICShvfhXUPL9gzvJYLUHmCxxClzvMTtCTwWPlnDGsMkyDyxxuwa4R4oHyZBk+0mNVgpGLrYR8WoXCaBCEPC7k9vSQbb71wTFevGDWYmyAlh00VBP8Rh1EhIxEDWpwOBU54ycUMm7Rzw1d5uYnRRuehFhqsUS5Lt0pjCER7zOr7RPmKU2MkjUYUEO9GlPOZ
 YFvbFqfV
 jNte5HTycSrihPTfpDSFpUk3ABkrSc2LU8R7yXvIoJTj2gNa+bRbh3KC0ScGSxEImd1uzbCPdA8IlXcuF8gsw0btHuQw1i7Ex0CxG1mlNXju4p9s3WCrCcYreWePhJwRmalDVCip98AU0K5Q5F3XG8apXtEMWu4yC2xZmdDUC/2pC8sYBNcEUSK3MX18OktM2wQ8P/QMIzYcDQ5Mkp62ay94kj9JY4I9M6lZOuck20Y5QTfLH3xsfcmaOH+8j65KNtU3cT1n9zWwZXhYVdC0+YIy3gQLyaqn4gqzdmxk+Q+4iyt0esLQF1Mx+yFjhAxYLjgmuxJiEhahaDSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 13:22, Rik van Riel wrote:
> On Thu, 2026-06-25 at 08:32 +0200, David Hildenbrand (Arm) wrote:
>> On 6/25/26 03:50, Rik van Riel wrote:
>>>
>>> v2:
>>>  - simplify the code, which should be ok because these copies are <
>>> PAGE_SIZE
>>>  - clean up the code
>>>  - fix locking wrt tlb_remove_table_sync_one()
>>>  - hopefully address all the other comments
>>
>> You mean, ignoring my comments about not reiplementing GUP entirely?
>>
>> NAK
> 
> Do we actually have a path to doing that?

Well, I know what we do not want to reimplement GUP in some GUP users unless
really unavoidable. And I want that explored first before moving further into
this growing complexity in a GUP users.

> 
> I misread that as more of a wish list thing, not
> as something we could realistically do today.

I really don't know how you concluded that.

I mean, I know, my English is bad, but it's hard for me to get how

	"Yeah, we're not doing that unless inevitable."

is a wish list.

Yeah, well, ok, my kids treat also a "no" as a wish list ;)

> 
> How would I go about making that mmap_lock-less
> GUP a reality?
> 
> What are the prerequisites?

Did you actually read at least some of the stuff I wrote in my mails? You know,
the ones where you didn't reply to? :)

Seeing a v2 with some weird gup-fast-like looking reimplementatiom (eww) is not
something I enjoyed at this point. We don't need another set of special page
table walkers.

We really need someone to look into this with some GUP experience or the
willingness to properly think the GUP lookup+fault path through, instead of
adding some creative workarounds to selective GUP user.

I will try to find some time to think it through, but my time would be better
spent guiding someone (and definitely not someones LLM) to understand

(1) which interface we could start with (as I said, a GUP interface where we
pass a VMA-lcoked / mm-read-lcoked VMA instead of the MM)

(2) which faults we could automatically resolve under VMA lock (I mentioned
userfaultfd is tricky but the existing GUP call already doesn't trigger uffd)

(3) whether gup-fast could be reused to some degree, or what it would take in
order to do that.

-- 
Cheers,

David

