Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012491076365
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 05:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5BC6B0089; Wed,  1 Apr 2026 01:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2871D6B008A; Wed,  1 Apr 2026 01:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175476B0092; Wed,  1 Apr 2026 01:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06BBA6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:18:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FF9814067E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:18:36 +0000 (UTC)
X-FDA: 84608831832.26.0C439AD
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id D1A4540002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:18:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cWi5Rc5N;
	spf=pass (imf04.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cWi5Rc5N;
	spf=pass (imf04.hostedemail.com: domain of lenohou@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=lenohou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775020714; a=rsa-sha256;
	cv=none;
	b=d7kb5Kk+LRjJuxyCAaJknB6251ieQr2nDMFzaMXfMH/gWMOqm9iu4xMSefpVYNXORXinXB
	3Fa/dTbuDKNjQb1/kNrXbUHWsa6ba9pyiyvLEPl+65qnqzCFm/SgxIsnZAAL4WdM4ySd9a
	yzEgGaKS9U2L2Z72ch4YMiEAnhEQkcs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775020714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM65xfyErKlO8E5KE2B54YuSdaeCzwbRtKfW7tFxcqg=;
	b=H2szBsqRi8j2MGD/opknVrVQ3Nq7IyDKQELgQfOMAFT03jYmmbQqxM6viJzRkdtGjDnlRB
	Za4FvMpCTvz4YupcXRJS29ApMYBpsPqFwSiUSLsBCDS+7H/airUYCCjxZRLFT8jwlo5asL
	eUD3Z7CmMqJ3CJ6pfLL0vC5oHjNjKbs=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b23fcf90b2so41689335ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775020714; x=1775625514; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iM65xfyErKlO8E5KE2B54YuSdaeCzwbRtKfW7tFxcqg=;
        b=cWi5Rc5NM/rsVi7gQjaDt59w9RPIOXgPefz596jJfvb9PBQtqQ/+sGGPvjAOY4AF60
         Qpplj5N7TlLRkBU+HNeH6/OcuObRqcUdCRAlKC/yNwg13vA7AmXE0OmdRpEKbaEPi2QW
         mDDam+FUTZES5479+ohcAHVofBSDnBgBqwTMvVLCioGr4FQ1KQbmANCN4jqUMg6dH0BJ
         t1PPnEM6Kjq6bEbyK3kSFsMzgBpwdUpG6HKDqpyPZd97Cp905xLNJzDd0d8AOz0CtZ1Q
         9ZJHAywfl4wSD82RP0pNUI00akXJAqBT4X7A0hGOJWDOsbFFAoarwqaX/f/+8oGvu75C
         J+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775020714; x=1775625514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iM65xfyErKlO8E5KE2B54YuSdaeCzwbRtKfW7tFxcqg=;
        b=PYbq3PgP8GkT7AyHmfD+++9GgIBVxScCK9FTtUPvwceN9DgJJO4lyHJnNA5v1NGTQ9
         /COVLXs9Zy6lc6WV1iJkaT49ER7HowWKkgjEW83QgKS52+tyANZL5ev9uInvjmBgRR4D
         NfLnGO6N29i29rM9WHGDuq1FS5Lc3p627mKjS/fWpHZGCzU4eIkviSaK+UfRQA0GkY64
         1+kdy47kgUOakfPC1RWD+jFQ9GbjQp6lj1UyXsq3NXeU4tiZu9B+CAwEIJK2Qsa4SG17
         74V7oHKCtXQi0AOBEYdh+5g1NhAAtPn/Zrc4tii68vbaPI2TumR1ETd40WWWsPhBi+Kw
         G8yA==
X-Forwarded-Encrypted: i=1; AJvYcCVg9+EWmh6ftFuZw9/1SPg/8D4vrETNBaj+zyoDj6en0OIxRqOgU9EOoMRqxhE9X1x6jlT9CjysVA==@kvack.org
X-Gm-Message-State: AOJu0Yxa0a+Fc+HhEVcpyBCYV0XrkOfr9usaXkugrXmTIDfjVYrJWHem
	6y0kFAsAJOk6pXQq7BQi/ZSC7O0eWeXjx0KcFQZHRyTxB8xcV0E6D3YB
X-Gm-Gg: ATEYQzyJ7KYTIHdCYfLArVzC/qc3VtBD9jWpK5YyTSZZrR/ot3TAzvHO0aoPhLOwXgD
	VjhaAEjhfevmXfnH7DMbW7yNLGeSb6EOuvcL8BEVamoeQXpFFBn7TD/9hQQRoaebcmw8AZ0C2W6
	jHbsEPr1YZ4MHbVFT+LXjh8PpIfXfMNKrVtKlw5uVbAnMTWRapSjU5/peTp4px5/S0ghlYqmREB
	iPVOH9doo1RdG0GnfdHyPCeigGkndzUF348L7njWXH5CU5t9rbsS+oW9iLpK1G/ZF0Qsykitm5I
	b1Q+ql4wBVpp6tiv2mBDwW4vMaV9l1oC9HVg1SooqZSzf7U8OVDD8AIyNRE9p0Yvd6v4yk7SZnI
	4HdpP4aSPmBmHaGvLMFhsmH0n0oz/4d8U0WbooYCjUmfJbVSfZbBVmJ6XB924Bv3IxluNv4H8B4
	/RF2ANybCmR82kK40NPCj/6rx552j9pPNGMsCG6DmuOKQn39weCaY5X0HeGunHa3wGV3l6LAKEA
	cljJkazwkYMurnfWknwhZ7umvCKKtikouzs3Y/lX0UW
X-Received: by 2002:a17:902:8647:b0:2b0:ccc9:dc2f with SMTP id d9443c01a7336-2b269ce0852mr17746005ad.47.1775020713278;
        Tue, 31 Mar 2026 22:18:33 -0700 (PDT)
Received: from ?IPV6:2408:840d:2000:afa:a06d:889c:87b5:c739? ([2408:840d:2000:afa:a06d:889c:87b5:c739])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242643381sm142480725ad.5.2026.03.31.22.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 22:18:32 -0700 (PDT)
Message-ID: <856f3172-96aa-4cd6-9d40-857bc59b0c35@gmail.com>
Date: Wed, 1 Apr 2026 13:18:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] mm/mglru: improve reclaim loop and dirty folio
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Yafang Shao
 <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
Content-Language: en-US
From: Leno Hou <lenohou@gmail.com>
In-Reply-To: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1A4540002
X-Stat-Signature: ycoedfm139dzb5xiee6tu7pgd4kcwxca
X-Rspam-User: 
X-HE-Tag: 1775020714-318072
X-HE-Meta: U2FsdGVkX1/BHwP8yzR4V0cfTng+9wMDaOgfbsXQSuXo/btdKvqZ4ItaahFfntxRf1c/esFAt/AzkTq1ynoMJ7LloK3Rhqira6wm65motqZsJhsvDpiZyqxlrDdhij38KhW/1xf0TbKXhqDlLGbqr91MJWFG8dc6dtXmkIP2PUtlLVkyHPEKiV/xAjVsbgDjZbxl34ZsB11irN78Vb7gYf+6pGAVR5pMqcMmKyMYKIInhQIEmI7d2euLKqf/P53zUfPBOP8e+4x3WrL1dgTfh6N1oHxzMZDPuRYVlN3dXgCWR0sZa2z1OqnX+YY44LbNy+NL4Xx7iuYk3mfia2hVhfbiuzNjkjk/KTNwEmJegctaT2j9k7ZX85AhTVZapefFW3X5tNyvgXJdz1KUbfetkDgOmbDHEBZi0HwAjlYPmPC4pmzmxPUjTOLCdPyyKsuNjE12fUJNhfbD5nbkAgNWv3fn4XY62MMjICUkfFT2id5j4XPCvQVbsnJM/rnjxQE4dP1c8JkkDa+TD7HQBktCBMl8bIAeVkvKhMnn7JycDqGsiQRBcOT/2alT59l2U+xfzMI4mkeNZQRN6D7alLxCSD9NYmFAbD++kLc76aClxKdx9PwaDh+r1UJvNMIwiWGsBO5fQWqd/NZ9pBarlpHaDEjMUkoyk2YDhcfUBtU1rHjusMrElvc34NXPtqOSHEnIpkisn1n6SxEzLple+nvMh84o9RrD92GxzjTdnEDspSVRGqvLECZjZ35WvTzA6Tc52Ax80mLwMVZ0SjY8To6aErgtKu/ohAv2LOZeABT6rozmoTRSJSqqNy7XQPhMF59Hdd6SGD3Cznk+i+sgTi9MFS5OCMgfn71NCF4aNtyzjy9nuhhguyQXhm4ffKLHTvK5RqMHvWfKM7kEodq1zQMQkJPk8OJ9PCtQurY0VzQB3QAHt0DnmJM5jzc8Di627PQteBIharzrMnetSCVXxhC
 wq/XE1fR
 8ew4Kor+nVh9IK5Gl66CUvcwvrAoh9cziU8X6B0EoAJSGROSGpxj0xR5I/B5ALKj4T7ZDY1yMekb50+u29QXieC4lKIYPvxwU1fmQ2g9lO0y6AoMDjDsXW4WTVqXCdHMfXvZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> The aging OOM is a bit tricky, a specific reproducer can be used to
> simulate what we encountered in production environment [4]: Spawns
> multiple workers that keep reading the given file using mmap, and pauses
> for 120ms after one file read batch. It also spawns another set of
> workers that keep allocating and freeing a given size of anonymous memory.
> The total memory size exceeds the memory limit (eg. 44G anon + 8G file,
> which is 52G vs 48G memcg limit).
> 
> - MGLRU disabled:
>    Finished 128 iterations.
> 
> - MGLRU enabled:
>    OOM with following info after about ~10-20 iterations:
>      [  154.365634] file_anon_mix_p invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
>      [  154.366456] memory: usage 50331648kB, limit 50331648kB, failcnt 354207
>      [  154.378941] swap: usage 0kB, limit 9007199254740988kB, failcnt 0
>      [  154.379408] Memory cgroup stats for /demo:
>      [  154.379544] anon 44352327680
>      [  154.380079] file 7187271680
> 
>    OOM occurs despite there being still evictable file folios.
> 
> - MGLRU enabled after this series:
>    Finished 128 iterations.

Hi Kairui,

I've tested on v6.1.163 and unable to reproduce the OOM issue by your 
test script [4], Could you point the kernel version in your environment 
or more information?


Link: 
https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure 
[4]


--
Best Regards,
Leno Hou

