Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 854BEECD6C1
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 16:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E509E6B0005; Wed, 11 Feb 2026 11:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28516B0089; Wed, 11 Feb 2026 11:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D55A36B008A; Wed, 11 Feb 2026 11:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5C736B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:45:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F1731B3C29
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:45:41 +0000 (UTC)
X-FDA: 84432752082.26.AF80F6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C950D8000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:45:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pk4QdTTS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770828339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iN5IMdiagIW6su5kp6dtoWyAVJD+SHgfdwugEL+R9T8=;
	b=hBriNWyNy3TkOpkoijjeqx/dv/XYsJAyChgS43+FHysfMXXYGfqM2nCZdeG5MEzCV8tY3K
	7UE3vCoZ1pWOK86whJI/egqnwQKH35wZJpnCAIjqRqkgeKaRgZhQad0dtV3lqReIYrLjCb
	UQVOE8leC8QrQf+JBBWyXVsb1Ql5/xQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pk4QdTTS;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770828339; a=rsa-sha256;
	cv=none;
	b=UZqvG2KtzZMNncZz4+51rG4CgKWZRBfgxzQ9l6ky8NwZi+vOn3byJ4CiOe6fqvd88j1zxn
	PlRP9glfAnoXFmLtVjoIMyzfXa3b+ue845O/dUQbvZqJsrSRH9ohGB3Sj8I5CToa1c2gRh
	S8gRGrSqcXjczPMEE4NHUo1Lvy6AyVw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38EB5600AD;
	Wed, 11 Feb 2026 16:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437EEC4CEF7;
	Wed, 11 Feb 2026 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770828338;
	bh=ptfH5xoqmieZP4iCxFCvPxbGMO4BUbpqj9XhdYwlR9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pk4QdTTSql2H+vUPzMiVYTA1JaIOQqoGNh7f/wwtMJeYLY90MlFXBFhj46bvXc3bJ
	 YyS21HWNl+M5Ttedla5BcyoN3buJ8CXGRmeKzHAMd+QTACA2dqv4pXQUhWMUGc6Ri3
	 5KNIb8FEztaP2N6IPxdJkByDItclGB4Re/iMJnotgYwN+xYZtex691b9J1vFyKpYPn
	 p2128rlGoXOIabfUi61qyyORkGmGQGCUbwAmNxE2nnR8BYOc5rqYVH8nnVs+R1zNbB
	 AI4ZnVAlfTUh6N4jDMKqV0cErfDgOd1kepVXgmotOCQdtJmu64Q/lWgzfVKpVB44aM
	 Avir8haEx5nQg==
Message-ID: <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org>
Date: Wed, 11 Feb 2026 17:45:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com,
 Fangrui Song <i@maskray.me>
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
 <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org>
 <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org>
 <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: k3jfoopn4cbp4e7193yeh5s7cj6tbpbp
X-Rspam-User: 
X-Rspamd-Queue-Id: C950D8000F
X-HE-Tag: 1770828339-202266
X-HE-Meta: U2FsdGVkX19TWY9JVE1fxO2a+Y3ITHBE1YylRdHYI6iWn3vhu8qAUjtC/BjPcmvZybHhM58Rg6TJeGO3Rlei6Lm3WVaMyrDcoYOD3/xlr4lwG3OjMDlcWXUUVZLBdeEe6rtl2CBW+HMYENdlkT/w4a0QGqiE6czGKr6IYlwedyNqE1fn3eM4Jf53Aqt2e7Zoo0xoSF/bLKZlVuWjEjOSu0bm3an3WJHxNZthlebGl697LH+J8Vb2lRbKZBp/h7pmWsSq0y9to+ZDyni+wqOxZMBrmi9XJBbKvgf49QSLb78mOX2KHZlP8/Fn8t26E9/fJOAGmTGrTzZpXcjlW2Mwituo2sBkbU3bhrP01jfm4mpWRM5rXhXqg3ZD+eLbVkdNGQOfzL/n9zsMyDaiiXK17qVJ8oLUoacexbg8ERm03k+33an26UVUVWm4yWUX5LrKJFklWYSie5+m1sQutW9IzYNcirQfI8cQibe1o2qPPdNX9Ikz6l7qRgRbk2yH9YoIBUZZfaa82MxiXlCFvqqicnIFwhfbzNheYsqlfjqRBp6yNa3mRfSvOyFoqvq48xWStX1XfZOrrWh2N9dAFrxSNil/S0dr/0eF5/Nn7QAmjh/kg7E3mlKz+5cgAgBieCcCoe/dh3L6lorxTjWqhxTVZIHxbbMeHGjf0fblEl+r0Xn70b/Ruatx4d2SBSbGsCo78AMbthHQuhxixdHc1ZgCfRGe+hHRIhVhLz9MowT1J/wdY+msyA4KWeiJuyJPA7pwfh9vEDyvxRttFOhavEyfszTarwgDI2WCUKgl2/3bkceCHz301G+pDDUzYHiuL9rIZ87ZBjGt8zrP/Xqxlg6G/K2t19k7zUW5JIjLwyyXUEccs8aUI1vv70QHnDeA4WsxTOtNAIz7PaVudajEmIJr+/IlfjdPpk2V3Tzirw7Fb6mAf5pHZjWy9LDuVRTGHV1l4aCbDXyECLH7c3zKoNf
 fsGL5IDU
 Y0ggj9E6VLxcPjXmIBC9gpRm0BaFD3nDYolOmZ7VLE6lgfh4ZH+b2c05l7Y73WoQ3fjfZQAED3kZp5flaeRkRVwQ5hVeTVZsaSoiOpy7Bvs9+AZoj6YZmsp+hboHAN7LAU72vfEpQBF9GsO0SAnOMqd7BR34w7Gm+3aFkdffVBsyRDGVaAzjMLgVsCNO2fvbIWexv9CaD6zcKgu3MMOgNLdeOPWybIFNYLtzQdDRA0JKsp2ukGuHtPduNRVhf9E5EIbRWEnnhe9ugsuZs481Yta53j+UMuzxUBw4AM0l0GuKgE42EeePQSGE8TjtnoS8pk0+vdwPM0YbMjkIdDNWxJEGWWTcwXe2av4gyEiY9fUih5zmoFMWqOFle9pXC0uh5inDwSbyzKWgmMeoNOKJ+XR2k2Y433aBkfgsGqpmgjDMxVsI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 16:38, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 2/11/26 00:00, Ackerley Tng wrote:
>>> "David Hildenbrand (Arm)" <david@kernel.org> writes:
>>>
>>>
>>> Seems like on 5.15.199 there's a hugepage_vma_check(), which will return
>>> false since secretmem has vma->vm_ops defined [1], so secretmem VMAs are
>>> skipped.
>>
>> Are you sure? We check for CONFIG_READ_ONLY_THP_FOR_FS before that:
>>
> 
> Ah... I was working on a reproducer then I realized 5.15 doesn't have
> MADV_COLLAPSE, then I tried to hack in an ioctl to trigger
> khugepaged. That turned out to be awkward but it got me to look at
> hugepage_vma_check(), and then I went down the rabbit hole to keep
> looking for the similar check function throughout the other stable
> kernels... and amongst all of that forgot that
> CONFIG_READ_ONLY_THP_FOR_FS was unset :(
> 
> You're probably right about VM_EXEC.
> 
> Here's the reproducer for 6.12, I put this in
> tools/testing/selftests/mm/memfd_secret.c and called repro() from
> main(). This time I enabled CONFIG_READ_ONLY_THP_FOR_FS :).
> 
> void repro(void)
> {
> 	uint8_t *mem;
> 	int ret;
> 	int fd;
> 	int i;
> 
> 	printf("%d triggering secretmem\n", __LINE__);
> 
> 	fd = memfd_secret(0);
> 	if (fd < 0) {
> 		if (errno == ENOSYS)
> 			ksft_exit_skip("memfd_secret is not supported\n");
> 		else
> 			ksft_exit_fail_msg("memfd_secret failed: %s\n",
> 					   strerror(errno));
> 	}
> 
> 	if (ftruncate(fd, SZ_2M))
> 		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
> 
> #define ALIGNED_ADDRESS ((void*)0x400000000UL)
> 
> 	mem = mmap(ALIGNED_ADDRESS, SZ_2M, PROT_READ | PROT_WRITE, MAP_FIXED
> | MAP_SHARED, fd, 0);
> 	if (mem != ALIGNED_ADDRESS)
> 		ksft_exit_fail_msg("Couldn't allocate memory\n");
> 
> 	ret = madvise(mem, SZ_2M, MADV_HUGEPAGE);
> 	if (ret)
> 		ksft_exit_fail_msg("MADV_HUGEPAGE failed mem=%p ret=%d errno=%d\n",
> mem, ret, errno);
> 
> #define READ_ONCE(x) (*(volatile typeof(x) *) &(x))
> 	for (i = 0; i < SZ_2M; i += getpagesize())
> 		READ_ONCE(mem[i]);
> 
> 	ret = madvise(mem, SZ_2M, MADV_COLLAPSE);
> 	if (ret)
> 		ksft_exit_fail_msg("MADV_COLLAPSE failed ret=%d errno=%d\n", ret, errno);
> 
> 	munmap(mem, SZ_2M);
> 	close(fd);
> }
> 
> This reproducer gets us to madvise_collapse() ->
> hpage_collapse_scan_file() -> collapse_file(), and copy_mc_highpage()
> fails because copy_mc_to_kernel() returns 4096.
> 
> memory_failure_queue() causes this to be printed on the console
> 
> [ 1068.322578] Memory failure: 0x106d96f: recovery action for clean
> unevictable LRU page: Recovered
> 
> No crash :) Is a crash the requirement for a backport to stable kernels?
I'd say being able to trigger that is sufficient. There is no real 
memory failure :)

-- 
Cheers,

David

