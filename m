Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E416071430
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fvEEO7Pb
Received: by kanga.kvack.org (Postfix)
	id E05FF6B05C5; Fri, 13 Nov 2026 12:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7176B05C6; Fri, 13 Nov 2026 12:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF246B05C7; Fri, 13 Nov 2026 12:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9BADE6B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:30:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16063160232
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:30:30 +0000 (UTC)
X-FDA: 85430785020.10.51B7CFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5135F8000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:30:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvEEO7Pb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794591028;
	b=bwGBZzRhUWXdQDTIKapGMdi/L2ip0yyiAXZ76cF5FHJafzUyJ+d0WHaL/o6IoEpD7eeobt
	a2XEzR+AcPI98denr0L6HXTO8Z/mhlVoEWgsu8xTXDSZL1utKi1fiv4zA9Ia4416bnt8v6
	0KPP6ttIwXxWTHc2HNODs7wED68WFGk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fvEEO7Pb;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794591028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uYIVrWzPo//3ycnzcjtC3NLTlGbn7jlYXamYf2N1qeo=;
	b=QEEpBn1paEtxGbYfpyRsIZo+ZPJtUWVYt/J1CV/RsS5v4xS/1zPz57uuntkJ/RHESqDfR7
	fIKtc3MX+MAK0qQ4Fk+MC7r3ZQLBddsSF8bsewvFJxtuLwSDDziwGL6dqyHSQEuK92ePZm
	SzIzudLu982K5d1kOxZZ2e/9CN9tlng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E4B2438B7;
	Fri, 13 Nov 2026 17:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9F71F000C6;
	Fri, 13 Nov 2026 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794591027;
	bh=uYIVrWzPo//3ycnzcjtC3NLTlGbn7jlYXamYf2N1qeo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fvEEO7PbZX9RLJuOyvqtICyI15grRVBoP5Vhqwy1TrZnWTnC6cmLty3RtNesmATOj
	 UoUxxUsunpASPnCoG8OhQJk5AQqxizkfaW15CHhKM2wgBXjxBC1k9Hw7kSaJq3Lh8m
	 oWZx38rtsy1yHFNP18MvSjlImV/d1/hBRUSekkSKsAjL4cyCeWweNTtF5j61d02/X5
	 14xMsfnen96iZsK9kAL4IPwUo+PgIV/4LoUwv0LrpgerkQ9RPbJqTep1wZB8Vp2UP6
	 77ijmJKWWl7EobHqPziUXXPCyBsCikKYBXOqm6WSP+H5uSg5lTNcAWBYzEYDVLUm9m
	 8WuCOuRVIqQ2A==
Message-ID: <79c3445e-623e-46ac-a09a-0a5d21f117c9@kernel.org>
Date: Fri, 13 Nov 2026 18:30:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: reject shmem collapse ranges beyond i_size
To: Roman Gushchin <roman@kernel.org>
Cc: sashiko-reviews@lists.linux.dev,
 =?UTF-8?B?SsOpcsOpbXkgSmVhbg==?= <Jeremy.Jean@oss.cyber.gouv.fr>,
 Zi Yan <ziy@nvidia.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20261112142335.2749597-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <sashiko-outbox-212974@kernel.org>
 <5f3dec4f-0416-4550-a980-b464a90aeb11@kernel.org> <87y0aw8x7y.fsf@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87y0aw8x7y.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: om8z4s5apmm73fh9b8ciegt1jkwssqu4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5135F8000F
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794591028-111729
X-HE-Meta: U2FsdGVkX190FNfWd2Wrg2BbD7JBU+vZYjAItvvcspaB1EcAMYYqwcCxmkBQ4dpr02QRDGLgpmJwvXzUyI3y9bYTZFXSYW5uDCXFicrLdIyGYTIaPtNTgJevC9I0/12b8Z5gnpNTZ6o4YwoxFXZAQnz0DR3OU4t3xh9SyG/xuQQ8wxuNjD/sgZBFUnko7bzS63HlzJYCt3uescG+lLrmxD74+SLCNf6EQl0doY3dj1yd0u5TbKHeAJR58jP1sc/ppCv9VArGxBfZBnCpzzok+PW4x8T3UDvT+j+VAnoJm7UKonasGvbEjANjy+lPpDrU+8bzL7VkorOP6IBSgJZ/T+DjGjEQzmdMHOdujb7JXbn5l25QQBZ9tTTRC2YPVpbnHbXncnI/S4dvlu0Y1SXSDwZi6SI2HIygwK1thaFZ8o47WUtrLmEVAEeIfmf2t3ic8n2LebLsFvjl/Mc5B6Nh/HZf28w57eWO/ZNE+DO6EVAoCrqYfDYrcyjGwH3Xn1rxWD8UTAwdsq6IDSpwbM6OjcoQcjmJJut3n3PgTM+gsvccKQm3lnt+cQJu+HtSF4LwOVPsUad8sYp5gUbpmoJ/zMmvK5wf33Xyo5IPC4WKCNIJKGuGMvSeNEQuQEdegFX6h1svy7kSChBSUpPezwaRh5AWwWUP5ZVa8Artz9GDR6GahR1kjsowmfkmUxMoAjUoribG0yLSEbglClbDmAqkiNQ7pM1zlm7BfhCUApDv43cqiN/xFBklQVPWh9ZDqX+InaXRT7qVEqcJMRHQtViy8nP91U6xMh4ThXxTSyGGkjNrWvLzf5Fd7p6byL2A/zmt3ssrUlLrW9xGT/N63eufJjzMgRIOL9jc4E4BwTLRfbC0TGxboEUnJmI1Z+4Ge6Fylz+LHzepG311iYBg52nBj8/o7b1EOhSvMqmrcxCkJRzGVmkQoc0qCQUKiMGLtNCDxpwusrsyGrwSRhySI54
 fsxr06fL
 waqC5/TflLh5fpogeGSCC2unLFL0VjSkuBeBjc86H9hzpRFwPqpOvpK+ZIr2FQW3p/+Kosr1m/STS1W3GCRl1uCsP04cmR/Dg4NwSnVv5O7G2uDuX6eroOPGBPVlsaUicFWL42e9OXsZOLkpikzgbv2jfbMIlyrmkCBftSctmmkLvT3K0HP/zQqdlFC5qdU9XYCTwOZUm57ul147KDnzbeiuybUhGczf6Cts3pRQzzEsNuuVkiS7+JdjR3FQS3grcLXAP4OPVWE7+Pia7Wcy7Bd28qRhpdpP+Gg2r/owk1vFN8OyR7YriiCR/O7dVxc3pMt/FZozYKe/eii7ZTiJqdgMaF7Np8kvvfimDBsk/zS1uHRutvqkfY/kRMzyNC0mf6KG/3gF/UT+RvifXYtDgbd0dag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 18:20, Roman Gushchin wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 11/13/26 15:25, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found no new issues
>>> in this patch, but noticed 1 related pre-existing issue it does not
>>> introduce:
>>> - [Medium] mm: xarray node memory leak in collapse_file() [1]
>> Ignore this shit from Sashiko.
>>
>> Roman, make it stop.
> 
> David, will do.
> 
> But also it's not how I want to interact on mailing lists tbh.

Roman, just to be clear, I am talking about preexisting issues. We get bombarded
with preexisting issue reports. Having more duplicate reports posted to the
mailing list does not help anybody.

It creates more work for everybody. And the least I need right now is more work,
believe me.

> I understand everybody is stressed and overwhelmed by llms etc. Including
> myself. If sashiko is not appreciated in mm lands, I can turn it off,
> no problems from me.

Sashiko is great. The embargoed sending of mails to the list is great. I
appreciate all of that.

Posting preexisting stuff to the mailing list is not great, at least not right now.

We were very happy that preexisting issues went into the private bugtracker. I
want to delegate stuff to people in my team to screen them and see if it needs
fixing. Well controlled.

Now either:

(a) it was never really gone, and we were in disbelieve that preexisting issues
    are no longer posted publicly.

(b) Sashiko maintainer decided to re-enable it without consulting us.


I'm sorry if I made you angry, but I hope you can see how I suspect (b) and why
it would make me angry.

-- 
Cheers,

David

