Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319FDD74965
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999236B008A; Fri, 19 Dec 2025 03:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918C56B008C; Fri, 19 Dec 2025 03:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844FF6B0092; Fri, 19 Dec 2025 03:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75CEF6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:58:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28ED5590AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:26 +0000 (UTC)
X-FDA: 84235619412.02.CC00D80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5D3074000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:58:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNysq9Ff;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ElIjfM4OkC3QwlfINGdndiEGhEBOFPRnZdGI1qUNxHg=;
	b=zknI8LQr5rzdtXwyzwXFUrxB7io4IcCZPAHy9jqLgqNCZd/NaHpPFYK33Jxr5twifM8+W3
	4CpYkQxhQ8UzdjoP7ehXCRyHqqmDu1zZhgO3Yup4JbnqQHIaGPEbHt/mhe4+Cj2TdtwNyx
	HeD/iFMgDgD4bwFwchBhYt3IfeYRbtI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eNysq9Ff;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134704; a=rsa-sha256;
	cv=none;
	b=y/cbOTkCwE/ZE+z7XxwOLMrSOJjUVgqsA8K8IzR0Fxj1tkKc9uZR40bg4TdKIHBeEl8jC+
	9w46dAEpy/I1g0jmI64pQnfn8zqNtpCJMq/niRKuk0bTRRRZwfnqfgaLZRkhq6bv2DSnTG
	O5k/3Bb2fbnO/CC/n/rj/2jLlzkKW58=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E5CF44368;
	Fri, 19 Dec 2025 08:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209B2C116B1;
	Fri, 19 Dec 2025 08:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766134703;
	bh=pLIFeiiq3O2vmMMKsgYLtNo2XOFyucyfeDVncolteFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eNysq9FfSfXM0V9W6ZR2RjuE5IMhesVigSVImNYmRmtSCr+OGgLT+Cr5r+4yWFS9Y
	 Jn5+9ORuFQly326lUkuzC6c/lgfmhbZUx7MRZ/Ua9okgNrmGFiyCmN9b6zvTo7UPVe
	 XoikXmmJjmjmvqk8qBt1t7aJsgK336e4WyaS4YumatetaIs4umAApkwz2NU0RWx5N6
	 CvGOwq2ogqZoc6ZdM8iYLIFr2TAjFUzAu/39KRFJ17S4G0aoCA/kw7Oskf0b0InKqV
	 fFrK2nNGe8VJlErPKzSCKMl9IxWNqlLsAGWz6iA7wa8Cw+Dp5VTjkIpTuhefy+Kqjk
	 p2g1mG+v20FBw==
Message-ID: <6e8684a5-1f71-4be6-8805-9b047a2bcb78@kernel.org>
Date: Fri, 19 Dec 2025 09:58:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <3c75d915-5d7f-4e80-975f-4479393e7139@kernel.org>
 <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <tnvhnikpfxyjassrdsnqmpxlem3hnoepwxmp4hysfzqzl3wltw@7utx5hxc52th>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D3074000D
X-Stat-Signature: ticm5unzbce815x7zcdjxtt3fxmyafsq
X-HE-Tag: 1766134704-501287
X-HE-Meta: U2FsdGVkX1+XeTuSPxGTx15Ba/WAVdjpsw5Eej35tcDN98rZa0f8VueNBvLKpcrrPBbAvoqEV0AwEF6oT3QFRaYKTuhIGCBvCOXFsktUR3rZksZhBs8krYih/E+dIE6TYY6wQbhlAB0e4mtbK/viYyQQJ8u45mrTE8ZUHgh6wipzU1alwlq9zOqVrc1slJBhJBAgyrhuvur5giRqtGr7Ld/NctpeRiCJCBMyzcRhJ0KnZ0ZswfVVmHtif3E0jgRMM0RgOnaPlnuL6bmgxdXo6q1vzWMOi2cS40EaPcUcknnWo7AHtSDtkr45m9l1jw9gt/ScmIdrb/eYKoTqW7eRCn39ZS7QmQMpjGljumVZEm7pQRi4Jt4cda9OK8HX8J2mFYMkyaVWg1odSz6z7VilsyQZxYvbBagRpAO4rhkvDBGftt1Qn50a1OdmABgR9Af68WiRaP8zwHhXDjAqLizP/pE0LAJxZz3DjYinOPKkurBPfmgW0STSwtd8AFhAH5ecjYlqxNi/Dg/013snWom+Ch7V5kAAxJQo4phKalifrLWm0QqmODqoM0M/wc74GqIyiavBh6a9GEPmZfReK16rM5J0wh4cadegggXZBzKVOWu5glXupfocdPPY13gZoTvrdBQpDG2cyEzGX6b+xreDEEvO+E3R3xC9Naul3O1wGzM1iykH3vXT7/TCoqjVryqOuKrRCMhJv12iMrRshZfFxdiianC9Hk91dDJh/EQbHjYizpDkluPT/QazcYqNRMqV/bBTyhb4ZKN/2dLb773hDvjzXxdiw+/UHf4EfkLoHQOa8okXPFwKFa2GuvlwdRo3oVqHBbhu9bH0M0wMjH3Du7IC3bilq3+dqvDITiaOrtjjAgpExXPZlxPfHyKmGKTU/Tl0cITuSi9zaEEckyRdXi9gAx+jzUjhVtbhvEpEzdrFTNLmKYNylSpldgJ/YNqOZzkXdKygWV3r4ufpysW
 C9rOpgsP
 0eOXaNdBoHm9sti07vssry57oDBw0NrSobp5dtAgTVYmfxDiZobWXhb3aFWKsQAdhJGPRvL6LZBQXE4EAXhdVzAMgXxal7ok7+1qjmlPfY7NdWMMB5qsCW2NngiJ+D6SomzRXwAP5MEcFJzyhbNX7ba3rD2tm9IX3tb8DP2R9NnUzjJUL5wf7UeJwpJxEWS46TuSgIllVyQ5e86VUk6s/nl/I0/g5CIakJl87S5opM6ZdeM7koNA4AQtWvSW/RhTvdOG+hLr24CjhnKg+4aVBgpY2oAXoDDet7CjigFfdc8onnLrpIDo6sdG6Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 06:29, Vernon Yang wrote:
> On Thu, Dec 18, 2025 at 10:31:58AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/15/25 10:04, Vernon Yang wrote:
>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>> continuously access 128 MB memory, while the cold task only accesses
>>> its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
>>> still prioritizes scanning the cold task and only scans the hot2 task
>>> after completing the scan of the cold task.
>>>
>>> So if the user has explicitly informed us via MADV_COLD/FREE that this
>>> memory is cold or will be freed, it is appropriate for khugepaged to
>>> scan it only at the latest possible moment, thereby avoiding unnecessary
>>> scan and collapse operations to reducing CPU wastage.
>>>
>>> Here are the performance test results:
>>> (Throughput bigger is better, other smaller is better)
>>>
>>> Testing on x86_64 machine:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.14 sec     |  2.92 sec     | -7.01%  |
>>> | cycles per access   |  4.91         |  2.07         | -57.84% |
>>> | Throughput          |  104.38 M/sec |  112.12 M/sec | +7.42%  |
>>> | dTLB-load-misses    |  288966432    |  1292908      | -99.55% |
>>>
>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>> | cycles per access   |  7.23         |  2.12         | -70.68% |
>>> | Throughput          |  97.88 M/sec  |  110.76 M/sec | +13.16% |
>>> | dTLB-load-misses    |  237406497    |  3189194      | -98.66% |
>>
>> Again, I also don't like that because you make assumptions on a full process
>> based on some part of it's address space.
>>
>> E.g., if a library issues a MADV_COLD on some part of the memory the library
>> manages, why should the remaining part of the process suffer as well?
> 
> Yes, you make a good point, thanks!
> 
>> This seems to be an heuristic focused on some specific workloads, no?
> 
> Right.
> 
> Could we use the VM_NOHUGEPAGE flag to indicate that this region should
> not be collapsed, so that khugepaged can simply skip this VMA during
> scanning? This way, it won't affect the remaining part of the task's
> memory regions.

I thought we would skip these regions already properly in khugeapged, or 
maybe I misunderstood your question.

-- 
Cheers

David

