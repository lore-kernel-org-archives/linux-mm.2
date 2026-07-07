Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB5AC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 15:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E546B00A3; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B626B00AB; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3AC6B00A7; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D6316B00A5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:30:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 090D61C38E6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:30:25 +0000 (UTC)
X-FDA: 84962367210.07.2E50C8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4532380013
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:30:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gaPhbL6t;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783438223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zNAvQXAe8ls/vgJ3aYvJDY6W5ErRNuyKci4MXk4ZDs=;
	b=eRZ387wgnsn+jGUfsD5Wbsos28ISkcGriB7iN53fQtkY8LgSFd9V/aJeoVOQLNOFr0NOix
	qUv9nGtYlcZbExaSOn5qmba5f2EALTqrjS5kEL8tFLTvTjGGl5P4NaKGM4/hNRVhwQ6KTk
	a8725+67/+oplTo+5GrIU8DmEe0Qmus=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gaPhbL6t;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783438223;
	b=Ku0gXp4l7nXvPl3nqfuRKwOTmYF/wjHSisd7okOo87AWIsd81NnpotJKg54z/fRGu1CTzc
	bulZw5Ez9xzoe4A11t66G4ZELEzQ3vudaDfYtWKcXh+x2MyNX+K1cg3x3QUYJ994o4qGAi
	Apwr8MYFv/OGJqo60uVSf6FeagzS9KU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC2BA60018;
	Tue,  7 Jul 2026 15:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B385E1F00A3A;
	Tue,  7 Jul 2026 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783438222;
	bh=5zNAvQXAe8ls/vgJ3aYvJDY6W5ErRNuyKci4MXk4ZDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gaPhbL6t25/sEwNHAQ8Jy6wjqqMQ3/XZr0GQ9LPMxKKjS4pGqdErRE+c9rUfkrTtW
	 92pJXY2ZAP/Rqkb+a29RM9/y87g2m5f5P8obeyqdJJnvAK2kbPZlelcWD13cfbWLEJ
	 RE3ocbRigecZBv1DEmMVONjbyxbNInaOgXBQj+Fttvk8DbIMc970U1zmycsYnHU3e0
	 /zKw/SznJRo3R/pOyD0legGS/Elx7xNmij7zL1QxL5g+yu16f2FF7m9kuf7KbxIFu0
	 muqxxfB8Q573cUOR7BkD6I+R8o+UuBa0Vg0vmj5pw5BDMOJvC9N0bkA1Xh5+QP343j
	 pUVud4AafvE/w==
Message-ID: <dbf1c4d4-7a7f-4b7f-b830-45be97ac4636@kernel.org>
Date: Tue, 7 Jul 2026 17:30:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 2/4] mm/page_owner: add NUMA node filter
Content-Language: en-US
To: Zhen Ni <zhen.ni@easystack.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
 <20260707115411.1714314-3-zhen.ni@easystack.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260707115411.1714314-3-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4532380013
X-Stat-Signature: p98bt3bq93d75g1izuymy8gbyzygctuq
X-HE-Tag: 1783438223-912562
X-HE-Meta: U2FsdGVkX18m8TaPhxbUITiF4CkdoCoxB/ZVyNqJslfqd+WUVviJR+iGIrIunUdirxHRlB2zHKeQn2/ElYnFmDdeCdJnEua6UBB8vwy2Vb0iAuY7S2u91w2tyU8r52aIdU/3+uXTUPeeVn7P+FVT41lku9EndOhyyMjvrZTan72mv+cbgS7jSZhdqDvnICwZS4ui/Mb9a3iROOPZ+5dfqWmOTqVt0NVXe9t8svHx/CidFhuSIB3hQVtxed6LFOkyyeDFqsotbwjmIccJa0l94k+ZFofWG+DNFK8e+C1WSCG1O1Cf9JD/4J9pjKUJwzB4HxBi0Jsgy62bAnBujiVbJ3BoEbBpKU6DBX6jQ0fLwTbynkltcE2y4agucABVCQdiNma3RO2QDs+jG+gP6HKAS6LFYdyLZosnXXhmisv0GDRlfHT7LCyveVEdW/AROuRACT2h/974KV0YSbNEKMvsX9+ONViy52lmSK4rYT2NX0CQ2coamQptA7lyTUz711CPf6dBf75Im26qH7X6r+Tvv6bVdRcpiT0NFRafsuH+nV+1E2zE61mRs4jMVbGcmlZwMUDAUBRCA2wQLcnkZUpYXTUbEpR7yQJTcXQ93o7vTJbx/zqlukDFIDtezkoSEfYucX4b+ocXEet20hDLsdnkLyN7D9+HeusRbdFYWWR3JN7ao33aeUwzw8vCss2UmubXg0tv7Z4sOLP14secqiKpFSeFwjKDN4GOeZE0Q2PP5eZU5saksjA1bbf2c3XjYBXPK6OazdC87KsfHw2rWaRWuE3H/+LFH2KPrT10a534P47v5ASaqU/O30ISRYhEdYIC4FOQ5ecj7Lr++F0xTYYwvsilzQH3jW6g3f7b9K7UCihKGUSnZtTS5BgN2xC2cTD5WnTcc9582IBlERA/YYNJEJ4UX0UQC2u+HlESTezDRdVea5ohF6jRpdoJNGrSBTj/r7F2tzMCfO7WGAFzNMy
 IAlJgbIJ
 LkWGtFadwHZL+aqXu75q4tSDm5EayE6QaX2Lv1G2VD9ITtgnppVhxGVii7NLdZT1cdsw3+zh9kdg7uUoaqlZmE714KFlmoUGvEFl2MgQG2k5FHfnAcqWE1XgK0zAz+xlums9Nb1TKB4eDnkrCdRoqIak/f9v1AvuTfl1ELDbAvjeeW/R/4mzOYY9xSIHOnQHXwe1LNTXp45xxX72T7+U7slZUvEEX8ybDZ6qv/dYvy5n/FDs0mMoyG4wR5RngArQ4z25og5S6ySYJNNAdjqdIMxTZvefijmnzRKqrGqsIZ/PxQTOI34Tcix6Hg585xAs4/bINWvOB2pKYMhDNIBuOppL2qh6//v3zuCOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/7/26 13:54, Zhen Ni wrote:
> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
> 
> The filter supports flexible input formats:
> - Single node: nid=0
> - Multiple nodes: nid=0,2,3
> - Node range: nid=0-3
> - Mixed format: nid=0,2-4,7
> 
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -n 0-3
>   ./page_owner_filter -m stack_handle -n 0,2-4,7
> 
> The implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration. It uses nodemask_t for efficient multi-node filtering and
> nodelist_parse() for flexible input parsing. Node validity is verified
> using nodes_subset() to reject nodes without memory.
> 
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> Tested-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


