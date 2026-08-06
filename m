Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AA4FC55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4526B6B008A; Thu,  6 Aug 2026 10:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42AA16B0092; Thu,  6 Aug 2026 10:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FF06B009D; Thu,  6 Aug 2026 10:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02F626B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:11:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 900D2A25A1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:11:33 +0000 (UTC)
X-FDA: 85071032466.26.7C11D8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD53F40009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:11:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y24iLrIS;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65i6FrR9vhea/DAYh2XexXtxpmMYsDeJ8g7jw1MIgIw=;
	b=P2EHU4RaepYsvK8b7YBgaBfHeC/Y2Spg0u477uhS5iXqJeXnxbLkWgIe8/VBAP9gOjocFw
	HhM/CsMyWvAplGsPCdLrEC9kKUm9pGWVYRoPWowFeDUZ/WRcR/xLS0KHC07eBih5RCm+9j
	SeRo3R53VZy1eYIm8jB4tglCzp7JaqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025491;
	b=Uv8svDMXQq7nkF/XPvSa9SrIz0RR8tgLL3h2baF9V6sURaqBnlH5m29lonGcPOO0wKKLTd
	6W2UJzTOQDp7gY0rPK45baUt9lRfk+jScEU1chQz1NSKJsFgWCFzK13vh1DzMXIzw08Vdo
	pMCQArbS6IV0mfh6Ta1JOSzDKsogjkE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y24iLrIS;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4366C60A69;
	Thu,  6 Aug 2026 14:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86BB1F000E9;
	Thu,  6 Aug 2026 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025491;
	bh=65i6FrR9vhea/DAYh2XexXtxpmMYsDeJ8g7jw1MIgIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y24iLrISIRCxqBy09WsFAtvLEaKG6le4hUJgBLkg4y/DYrgWr6N6Ei/HxjnURUs3t
	 T4M4rspvFEOWnkkrwF2e9DsvwykqFjeEKwZaJYimS2AzBKTOzDARvlZoNyIbMVNsIi
	 262yr/Os9fyYOTcmj/QJohN5MjUch00k0S3WV7IZ79VSv2TpedqPjrs3sl7/tYZOTR
	 zSDAF+vAqhTG5Sxn7t4957as4SrjDqPUafo08znQOIL+LGNmSjCi2tFkKJ7DKXAWCz
	 FDZ/aNtW0Qe0lAB3EzfJ9orSGzFOiOTScw17mUHw+0TelN3m/+Bdm3z3ufvknNZtIE
	 NWE0r0B1CZmFg==
Message-ID: <0c90b9ae-48ac-407f-9d73-4c501c82cf40@kernel.org>
Date: Thu, 6 Aug 2026 16:11:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing
 folios
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 sj@kernel.org, akpm@linux-foundation.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org,
 jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-5-gourry@gourry.net>
 <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org> <anSNk7zgoGj62CWk@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anSNk7zgoGj62CWk@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD53F40009
X-Stat-Signature: eey8wgtja84mrxou3zyei8wm1bwsmnt7
X-HE-Tag: 1786025491-487077
X-HE-Meta: U2FsdGVkX1+zbZIZI77KuiYY3TBXr93RsogoHTOv3bCTxToqayJEO5KQVTpDe74/Egn1uddhXMTEtw9mJuOTXNuxx+ikYzadnadHeGL2f12KpLEeHCXJbarsVbRFryF6XJoFWbqihHDmf0COESWS/RyzBCINd3EWBF4m7RSTsJCu4lk42Xu1iw9adN0qCuQYt2kM8jpAqh6ow4uWTCf8KgzQBzbMXcWz8lYspwuQNYlkeL9z9T6o4huZz8rC77D/6ACt5QwOsr0qX314cs2Dnb6jix79fxnO5oiDKl041fRMPsj411re7/F/hAW7EH2Wtw+/nkKwgPqqBuWakBjkBkT8IOpgwE0zAwxdTyHuUrdjIjgJY9UIWTm4mq6KzMX5swfXUdso01Dhkv+ARCppOLcgSYm55ih/mhfo+ZV7wp3u2RE1xPcuoT4pgDCB4FSPlNsnHv+Y1x5kO9eqHdh8iKQVMMDavqDo+Mz3/BF3z98bvApb7JljVoA26FO+EYwg5Lbcd3q7ZulrxyH84AVr/0FaH5v+K6yXoc/H/aUtKl6og4IwcNtTeDCtIKPAVHlqxgM99un8sARBNErlbuOfU/dA+0kGhtlxbl8HUwKRE9mIFVArIJomKTfB4LlUmdLiLq91L6HT2ZrgBTAcdYtttClR711vo6dNzsJMGpZQD78nW4mUILPTIkDIwB9Fcv3GnzVZauSJhpG0nwdrY9QTf1EIxdFs2aQk/mad/K2OhdClS8vdB26sYqz9V9Q2SgcLoui/OPRWWzjf9dgFGf2Y/Rk445nPlegP5Yarjer/TlbJh0sVhFr1dM4xr6wtWrjn1KTtt9A47HTfi5c9uLXl41Pl9+LvUWldoyLqJ0ANp5QigftDHke5KfbOi9czeGOLyfeLQ7Kr0i2JDnoe39xW0PCNRAgrrRgAqmtf8q+TDp2dpem2hpcHGN90T1iuoKdAHxoMx+SJaDcHoMz9y+i
 Lf5wyEyK
 mrnudqRjNaIt/MZc3e9YPN/vtpx0IV3wJisu34eKAQe0g62OC4/X9LlA2/LhbErfC5mhWgXZF35OggChrvRJGlfPcELqcI35d65H1j98uy78d+7OqZdOEOdpYU8Ugr8xJmp+O6ytm8jMTrYbv6NQAf/AYHfX8Riz7oCHHM7SgMxbiIADb08yWgw10UurZuOH1tkLjHfJukI/DEvIjXIxWqkkmP+x+8EnDUTWPKOjpVvYrhijFkso1LMT5DbwtVl05UWrGoIjOknsddUR5cQdevz2+RXcGmkVn0JTKqKbreMlpM+nfyZXMaybaycc5zb9rlvMQcrNlZoSl/Do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 15:36, Lorenzo Stoakes (ARM) wrote:
> On Thu, Aug 06, 2026 at 03:25:50PM +0200, David Hildenbrand (Arm) wrote:
>> On 7/28/26 21:47, Gregory Price wrote:
>>>  mm/mempolicy.c | 4 ++++
>>> @@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
>>>  	folio = pfn_folio(pte_pfn(ptep));
>>>  	if (!queue_folio_required(folio, qp))
>>>  		goto unlock;
>>> +	if (folio_is_zone_device(folio))
>>> +		goto unlock;
>>
>> Leave the hugetlb part alone. hugetlb folios will never be ZONE_DEVICE.
> 
> <Insert leave Britney alone meme here> :P
> 
> But dear God we have got to find ways to stop hugetlb being this big stupid
> nightmare that every single path of mm has to put an asterix next to itself
> about!

Yeah, possibly unifying the code (possibly, because it's a mess) but not
replicating checks that don't make any sense for hugetlb.

-- 
Cheers,

David

