Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACFE0C88E40
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 01:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8846B0088; Sun, 25 Jan 2026 20:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70446B0089; Sun, 25 Jan 2026 20:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D721F6B008A; Sun, 25 Jan 2026 20:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C4B476B0088
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 20:57:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78C281605EE
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:57:25 +0000 (UTC)
X-FDA: 84372452850.25.D17040F
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 833841C0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:57:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QvsRFG3v;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769392643; a=rsa-sha256;
	cv=pass;
	b=j/o8wyPPXDhCqLXwymysHjOuJfuXgewXiwb9+JbC4HgCrQJro7+Kgz858rCW1XCGGyZNeH
	oDO3OWlCSkSAGxsWsU+QPZQGi1O2Q4RIGpMYMlx4lktsWZavQSrreVrM/jZbSwnVFZF28b
	vLOegY4fSnLcdyRcYKM/8Iegg8xntEM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QvsRFG3v;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769392643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WYlc3ruNgp5Obb3ckJRQ2VEzINlkVk7lmxzq0b9R3U=;
	b=RG+OwE1hp1r9DY/SUDQx+eNEMvbFHA+uKi+fI/Y0w4LekIYcRKeyNTecG5q68FjEf3Kfw9
	2iO7GfaU+MWs1R8YKhc5K6TqOEeZxFFrQkMX3JZRNCcq3GkVU3gzkf7W5MO9PJ8Yoo8nqp
	M/nW4UxdFNQ8XuSKpOG7wX3MdIltrro=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-894723da7dfso66878516d6.1
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:57:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769392642; cv=none;
        d=google.com; s=arc-20240605;
        b=QzLO7zgAbn2ZsysfqxELNTFr3Aglh/q0XAG2zXAtiH0OkKJeVJAvrLCplrKoE47xGz
         l+Kz8aMkE/dPgncydykWGDD+RbfVI0YRBqN2DbtQMvtzjnemmYgNqSLuniTN5r4Enx4T
         KIXE1ImyTeqe06ELm7VZBVSuJyBMzCXB4Vw+KlrH+h5Z0UEtXl2gXhi9SNhUqpUHdoCz
         PVZ8vw9zgX9o6BFfxRfINzJ7Q7+nIELNf6XFPv0J9+nlXD9kgJcD0frM20rmeKcgD8Mo
         y5DjSzjF2l6OninR3mgE2syKgYm3KIYlBzuscvIIVNDqC3j37KjkJkiUxSVesITWn9SA
         w7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7WYlc3ruNgp5Obb3ckJRQ2VEzINlkVk7lmxzq0b9R3U=;
        fh=IBpabRQYBDkEmc6/Gu7WFjN3no03ZGbp0YxJKnVfm24=;
        b=KqrQz3I312VIDgWwU3oj5EE4um1d1ifGN6RARg0ilA87+LMUXzYAiKHvSVaEZ0WJR+
         jq1+bqhBOcEcGaZmw3LIvhanRrM3SbfKzVfG7hoGR6hfjtA+avhVzfK9CRcnt9UDgDhH
         FlPcmnG37jR6SRFL5uOOd4aZ6hAVfsW1q1X+TerLhnlFN4bOx27+hsf6Lc1BPNtICX7J
         zenDKuxwi4pKax5t3CKDWqpq9W7y/sGsYTn4D7UBWx6vIe9gFvsjP4H291GKa0KbnJsW
         wSxktxWaMkQMwVbsv3LszZdwIWk+3ho2OLmyLB1HwUsPr7ziBCrlzTVsU8IJgmsTFJAj
         qgDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769392642; x=1769997442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WYlc3ruNgp5Obb3ckJRQ2VEzINlkVk7lmxzq0b9R3U=;
        b=QvsRFG3v6hl4EG9tcsIi2WClytQw3qQk78lAeUk3Rebwb2IzE+yOWzYKbPlGlb9ilp
         eW32r78niog1cX91nTUCNIywuJkwXaqU+rmhWOu4Dz+m3IDNBHFmhanIN/zJ1gMXWp1g
         +28G+UlNM5wttKxxmsXMG93vWIFiwON3B7TCMT1xjLsx+sfH8gUqKY/TCVrs5/SdWa70
         UiLxFw7CO/tfRJOwe7gbzA+48UeQQJMh+Z2SlYmM0PxNtp3qDCset0csN/MHx1t/23SQ
         719mfwa64CaA9G5I6MiC4ReswurVyJ1TPrzBkw9qkuEYs6AFP20INhQ5AMC2O1dP5gjS
         ZZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769392642; x=1769997442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7WYlc3ruNgp5Obb3ckJRQ2VEzINlkVk7lmxzq0b9R3U=;
        b=omX9eOo0zbO3uzbKtw/A0JNZdo4r6Wsapf6m/v/xe/F/VVnMDHKJqkPusA2h798gI2
         gSkG1at5e/EMhw4r9MPqHS4QpvyPT1I2nxPwo8SuS8nnJo4nxkebHKO+bppOe0ODrCw6
         Xuhu4J9ysqt4UdQs+oj0kTyO/21HJ2JQNPX7VbwckQDeC4yExGYOD8xZeBpdMkG0YQ6X
         o9zABvAF6cizg83yzTJrlKR/yFCFeiHAm73GxckiOJ0GxiqhwEu3x/3tGqIHlnxUdEHi
         N7f6/HO0tKRBWN/qwnktoQRGdVtq4n0GZRtD45m82E1GpSOEWelDKbXYrzWRtKVWHhLa
         +fMg==
X-Forwarded-Encrypted: i=1; AJvYcCXZ9kvGu4Es7dnD7VTJAPeclGYM+b68p/vP8F1+R1vLGwEOjHLnZ8H+pfRufbDfzeiuPgeNU9fRsA==@kvack.org
X-Gm-Message-State: AOJu0YzbXA3ldjRhWI+28HGV5X1HY4fgp0MYvhcXLUnORmqwlysLt3af
	M7iaya1IVXsFkScGPuO25Rx9Q6ODhV7ZCHuVtjNml9aOPre19l24YDI56TEkLPTrzKS8s358M1K
	OOOtektZFkKnwNF5kZNUBGsGCnhxbkNg=
X-Gm-Gg: AZuq6aJN1j609X9okWdjemzsF6sWLka06N2kpBN4NQB0f90vN2+GEoBWRWPC5cWcIBJ
	WN4q+nr5Gz7CNilzdrwGl9CMNaMkZXqTm55aCHq++vwuP07ID6eW8+pDS/THspQV2XS737k+rX+
	SqP3LFnOyc77sbFC/s7DV1JRDdxMfVqYJtllbRYySD+OpIix/PeNF1sfZ1rSD9J/NtWHyehJoTG
	cpVxdDtUxTqWGk6bUfm27+Ed0VbL9qCep7Y80IZBizZ/adx43fkwctWFug5Q0Lgib1NM3pSoEPH
	BvEJlJGbMFQHUyyq4y3pu1uR5sBoYiiJpQ==
X-Received: by 2002:a05:6214:dae:b0:890:19d1:532c with SMTP id
 6a1803df08f44-894b075f89amr37498396d6.34.1769392642478; Sun, 25 Jan 2026
 17:57:22 -0800 (PST)
MIME-Version: 1.0
References: <20260113081453.8293-1-akinobu.mita@gmail.com> <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka> <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F> <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
 <CAC5umyjOgZE0Qpa3W3qZ=sSkwkuf_md47jctXgi5UKWuG49o1Q@mail.gmail.com> <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F>
In-Reply-To: <aXJSlv1_K1uQCN16@gourry-fedora-PF4VCD3F>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Mon, 26 Jan 2026 10:57:11 +0900
X-Gm-Features: AZwV_QjosyM2EJ8-Qax2rQykQyrVBkjvCFZ66dDhYcvtgAhH-bSxND_z972-w6s
Message-ID: <CAC5umyhrcb963mA9dUaZswJKq2MF_OVaipNmy=L4J7u6rPjfqA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 833841C0007
X-Stat-Signature: c4i18ezrreaj3fsora4yoo7qjqp7q1uj
X-HE-Tag: 1769392643-997324
X-HE-Meta: U2FsdGVkX19j7roKlvQgEL0HzBmLiq7wtPM5l+BtB7F0PelOgf/rwYAnFfGJMVTsq8zt//xpRHjg93yeCDJTyBGFfmKz/YPcIF0m7qEd1KDjs6+kMdzH5hbeZ2m1ppArvABgkJf4rC/RJ/2Ib8fp3klEilCPGxXv8kVterLaMJvphUGyL2E7bduTrmfrik+3Rj6GxKIt/fLEsurI1CpGAfzNa5ZJUZHhnmvgC8pTVGkljrugv3kC1SDIz3EVEo1zqRenJGSze9B7Xzx87AnKeZuPza24JWUV1gQpl+zMuXI62A65+4YhYzz8BJ/fJNpezP//vpDuBw/H3HoyVW87C2DHgRQkar7y3481bJ9lkQC7+PSiJS/gyyWF19zYhqr68AOR06QO1VLjAjRrvluSORUMrC/JM0eka6HEF6tg4Y9L17z98bLbxEJZiyAsKu1gTPUgvTHrAPEK0W0rOycL/zatzh8nQXVT0Y+E5G5JNpBWI7yA52PGCe7u0GxtqRhdXdE2gG1MGI57spQzAjCMNMsTulu9U/nelByQwfjn/yDEWG/CzuewB2eKIy1VCenzWeK+HEOQe3gwG0PoNRac5xzsqW5A7VY0bNz3s5fxnX8gFKR/vHCzGv+E1f49vOjB4WsfM1PBe80UAIhAw3Csz+n2ieRFTWJvrALtRB3yl/H7FVJXQlgF9Q4tDWEcOYXFRmu3eo1IUdztP8dtKVXrHyEIDbzo8S6EZs8MlazaGLUho2O7sQngQKv93Sk/GSM3sc+7hFuxzJZUcQLKjgiCpNmsQOd7rH6fZCdeIszakO3OyBojjPPSbRqWXdPG4S8mUVZfllRMtuufYESOJ9/8CTzHwaVj+aIem9BgyOMKKS94AtYw8js2xS31Ch0+wIq0dpzMYynzrshAyNcJqz5BEK4t2OmUTHiCRe2uN9qd73yiHMUL5dKcXj6eP3nCHbM5uO5NoNjpWK7N38l7BFR
 mnVXSFQU
 iFvEr2iGktmJAEyOAmTZlIAtQq/LQ/+O7cwPrL1CKw62G9RjmfesLTvzVeS+FC/sF+iQkjgBZTUtj+IIxp6zwKyX9bS7jzjMJN6eLKl1dMqHCbt5pPfLG4Dwqf2Q054TN8I/QjkWNzX6886X9NZTXGZ5hQuip7eLpv4FEPmSbU47EsEfOnWua6KvIeayFUtT7UkY0nPamodsVqMB7Mp8B/gfm8tfte0trNZLReH80GWwi2O0bEsL7v4ryQdmfD5SUuPZyRNdqHUS8xKnkGXm3yBsVBSEKJo8nXlFa/PdJCHGtEbegxnaPtzCOYKFEXceMa+uvfK4WOi6f0GESoMDbvl6zzHjktc9yNF38zq/YsnQIjUZfEMb1jkxiEmW5MoAZBBTteU9fbze7zO73RxRFEG5OIfLNN1kq+PIuq4lFmTEFR14cRipt9VP+frjf8iaTediDer8Btts24YLS9BjZw2tjTeW3Dgmq8S3kzvf8g5yWffV4K81rNH0165fNXjmNAASIPdSEV+S0I1K3YdRDVJH1vbqb8MELe0k18eXkUMqQWSL9eFaTnJKfXkptW6IOMejxPhAZov5g440vhn1Ub9REvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8823=E6=97=A5(=E9=87=91) 1:39 Gregory Price <gourry@go=
urry.net>:
>
> On Thu, Jan 22, 2026 at 09:32:51AM +0900, Akinobu Mita wrote:
> > Almost all of the execution time is consumed by folio_alloc_swap(),
> > and analysis using Flame Graph reveals that spinlock contention is
> > occurring in the call path __mem_cgroup_try_charge_swap ->
> > __memcg_memory_event -> cgroup_file_notify.
> >
> > In this reproduction procedure, no swap is configured, and calls to
> > folio_alloc_swap() always fail. To avoid spinlock contention, I tried
> > modifying the source code to return -ENOMEM without calling
> > folio_alloc_swap(), but this caused other lock contention
> > (lruvec->lru_lock in evict_folios()) in several other places, so it
> > did not work around the problem.
>
> Doesn't this suggest what I mentioned earlier?  If you don't demote when
> the target node is full, then you're removing a memory pressure signal
> from the lower node and reclaim won't ever clean up the lower node to
> make room for future demotions.

Thank you for your analysis.
Now I finally understand the concerns (though I'll need to learn more
to find a solution...)

> I might be missing something here, though, is your system completely out
> of memory at this point?
>
> Presumably you're hitting direct reclaim and not just waking up kswapd
> because things are locking up.
>
> If there's no swap and no where to demote, then this all sounds like
> normal OOM behavior.
>
> Does this whole thing go away if you configure some swap space?

I tried it and found that the same issue occurred when I ran a
stress-ng-memrate workload that exceeded the combined memory and swap
capacity using the same repro steps.

To be more precise, for over an hour, I was unable to do anything and
of course I couldn't manually terminate the workload, so the only
option was to reset the power.

It may be a bit inconvenient that if something similar to this workload
were to happen due to a mistake or a runaway program, it would not
cause an OOM and would be inoperable for hours.

> > When demotion_enabled is true, if there is no free memory on the target
> > node during memory allocation, even if there is no swap device, demotio=
n
> > may be able to move anonymous pages to a lower node and free up memory,
> > so more anonymous pages become candidates for eviction.
> > However, if free memory on the target node for demotion runs out,
> > various processes will perform similar operations in search of free
> > memory, wasting time on lock contention.
> >
> > Reducing lock contention or changing the eviction process is also an
> > interesting solution, but at present I have not come up with any workar=
ound
> > other than disabling demotion when free memory on lower-level nodes is
> > exhausted.
>
> The lock contention seems like a symptom, not the cause.  The cause
> appears to be that you're out of memory with no swap configured.

I understand that there are issues with the current patch, but I would
like to resolve the above issues even when swap is configured with
a better solution.

