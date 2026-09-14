Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD07C88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152A36B0088; Mon, 14 Sep 2026 12:03:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD5D6B0093; Mon, 14 Sep 2026 12:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF206B0096; Mon, 14 Sep 2026 12:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE3886B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:03:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 55E50801CA
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:03:54 +0000 (UTC)
X-FDA: 85212838788.21.2F32155
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0E93720015
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:03:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BktPHSnp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789401832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lykhn1ziLcNrm34dqlEZxk1CMrWoLDAjyXD14b56Sf8=;
	b=QkdY0TPdzFkAG0iyZvU3Dzm8Vbl927Laj+x8n29D/En+BeftHO6odELsQKkmItUszVda0U
	TWhjS+yYi0q59QdGk+yysdzE99+Y70/MxxSjjBpc8Hw6Kp5LnAymLK8XlAU/iEXZG+T5z5
	+UtHATqgxsDU4N8Bud7jyfKYfhFaxlQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789401832;
	b=Q0AR3YEgZ12RB+rFSBEeKqMQQnfuenVlk0RWWkv9Xe5mI7nCAOEfQc5YXJAiWkAOOTHyvG
	IuDpeCeotrq4wUiuYk4Rkyy+QOleij8jNjaamMH1hrP0mTNDY3IJnnJR/jDfFwQUqYKKPN
	uWwQhhzzjrsZ1LrxVVYhDqbyNVC8NuQ=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BktPHSnp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-91058dd77a2so34900076d6.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789401831; cv=none;
        d=google.com; s=arc-20260327;
        b=h5h1i6sh3l0G3JUnphRBc/F5+pOnsD+2geyyvyYSDqAU4wdfgmpa0hywABPF+RnIM2
         qpnG/HsVDEGIYNrAsUTQi/wZjIRYQwCfEs2phd2aR0dsOTDNcPm1ZpVneckJ3irYdwc6
         9sVaBN+TeP01VMp93s4iyIcG1h8fpJk9150QdeA8Cb0earyJX8e9FFEJwY/INtulX+75
         Q1XoxuevsfCFzo7mIjGVz3Hq6afE0Ek7ZgjFhUhtj/3qdaV6PpZ+/T5CwdccLBgqAwYN
         Rp4ptHFym2qzuwo/WatfBPYcb2uzAEGJZKfJ2EUPbxTt4T5eNkBwYWNd/xSX5lbeOz31
         q1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Lykhn1ziLcNrm34dqlEZxk1CMrWoLDAjyXD14b56Sf8=;
        fh=tskKSt/0oK/CBgKiAQ8I+WbClwCB9zqLVlkPu9DINeI=;
        b=imDgt9NEw2e9PVFq6J31zoWVC/EusRzpjasK353tRxYrhFXGcHGRiMKPsajtqF30Kx
         JhRFryCsGexN9aV67RFeaCZyVOk/GW5FoEGs50EXCxmHN4tPEG26eErMGtMKpylPL4P+
         avjJlQnLdJZWXaB1TqoSvAgytR6eEiE1Lskj2giOqPepiJamqwo/CqHAmH4bBK3iOqgn
         4hA1xUiF2pRm0kJHbdqB/v7WNydT3aNPAVUWFMkenLTw16wXTAMQMyoBhaoX2/Trhcrr
         J6xGKFaEzpW+1ndrQllOder7qpJX9g0J33bGcTFFFO2uvewz1u30W8bYrB7RAAJA3cEI
         JRyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789401831; x=1790006631; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lykhn1ziLcNrm34dqlEZxk1CMrWoLDAjyXD14b56Sf8=;
        b=BktPHSnpBYfJRpG39eeG6t1DYSNgQkYwn4uEozzCIGcEiMFRUasJhvG460/I5vrkO5
         3qnJlGUEUX0tBW5Dz8gJD3rjx5ai+VXYBgPs/u56YqrLmw38+pQSqY/LOT66DS6z4M8Z
         Np76D64MHAxrlF9imGUTZK51nxjrv5gwOwL/Rk+8/jilooSuNH9kFUtYBXaBJS9r5QMc
         eUW5T/YN1YOkrlW7+iqYLnOzz8VL6jsV3YAqQEO9A9w3IM/D63u51kOH2xtPuNKmECu5
         qhJqxb34rc/uPz3xzN1QgPIrS2Fab7gcTaqwBMR7+WBQnRFuWf/HB8In65mhgDk7osP4
         oBxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401831; x=1790006631;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lykhn1ziLcNrm34dqlEZxk1CMrWoLDAjyXD14b56Sf8=;
        b=QtrFOmsoYtQ6nfelhmhJZ+miluvmaGr/+czZyPoJIi/smqqlrQ/dSjKqBu1zuqb3/C
         qEoWehPn+6qJeXAO9aDfG4QDUjtPqhlbCb6zNtT0/cj9zG0BcbQ9+BwehgpChogYFtYT
         jfYLP97XLM3txuTiqenPYwha3eY/3Ri98k8LU1dukdAwfgm0iG9cWz5jmJPcW4LrmvLu
         ZH7QTaMQmm6plRsFWInMlbkNZWcjbxSzHl69yOM+qylzbXQ2v3IFmoFgf3JmMiTxxpXV
         qlj66L+qHHilLeLA0fBp+0Ecsj74mfgx+jfHCF7XxZL6dkyeK3X67lkZH/+GImFtonp1
         KFNw==
X-Forwarded-Encrypted: i=1; AKwUvBw6AF/vRz15XBhQ70hW35kGA92Q5v7MP3o3728TwN4PMN7PM6jsDAr2sismBmiAjQ+3tBYXymU9aQ==@kvack.org
X-Gm-Message-State: AFuF++lDXpsqna7jF/uP23pDCDsB/bQTRWh+MaJAc4OYYufsZ5HCBGU0
	w/h/pt1kCWKm3H5w/GTdK1L6zxdW9Q5IkqfCr7sKntQLOa4maF1ZNyHbRhxeXnBFUL0E/H2/nVY
	FRzgCkMcu/aH9W3blJYl8g87eMHbh9yLak4NU8stl
X-Gm-Gg: AYBFou2z6uUwAoutaI6PTSRjLFzxcmeiDmA5TZ18vCvJdso/nYcCZZoshmXksGu1mnp
	dQlqH0t03hBHS4ArwOtIayeI93gDFY4bbxbUWgGPyZk6iE+IYB2qGJ8BIXdDjpkyt2RN0SkRDlX
	zyz2ba9r6LfwU+Nny6zaFPbq/aJ4ksr2xS4w661BjWskDb+DtjTWkLl4m2JIiIL6q4Zdyj7Mur3
	ZgrzBN7t3W7FGGB11MSStHKRSNcCM8BjJnTD43NdDJw7g5uZiPRx4UbCPI+vPaGBI3PWOCobsc7
	umMDS5/IWzS2MIINa9nKUgpEzy++b95wX6SIF31OWdZd8w+0vP2PIY+GiaoQhA/yCKxiSVV2nlq
	9IxF97gaXtf3WWW8WBHGD
X-Received: by 2002:a05:6214:e88:b0:912:1fca:531d with SMTP id
 6a1803df08f44-9122e4cf515mr54297366d6.2.1789401828963; Mon, 14 Sep 2026
 09:03:48 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:03:48 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:03:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260911145000.3881046-1-joshua.hahnjy@gmail.com>
References: <20260911145000.3881046-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 09:03:47 -0700
X-Gm-Features: AcwNN1WkNy6DDp-4PGpy28TjQCRTCMJrc6530qqWtllOnWQcoumOeBgfLZrmLZs
Message-ID: <CAEvNRgF7-zY5CRaUHfswRW-31v147SbTHRzMKGdV4e+Gd3Uy8Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: hugetlb: Avoid re-allocating global
 reservations on region add failure
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E93720015
X-Stat-Signature: 9de348zerk678zoaxknhg7x91zk43zgt
X-HE-Tag: 1789401831-233654
X-HE-Meta: U2FsdGVkX18lYhNYXslJCZn0gchrdA6EPQ0Spcc/PvLNiw0B3OSYKr6AngNoOqSHuTz+bQ4aglyisvNqRxcVvil+0+jKdRmwclKxyou7IDHX63InNsB4WyQgmwk1PMdMLPbageHhWHpH/5fwiGkTnT/1NBPz7lY60+ch/xFlByaEQImDSc4kgXUBjl9puMslHJAVDD01PldRSSyGzSnnSmM8oXsHjD8y+8ryVH8xDJN1tsZcWtTFV2ZLEAQO0IYZuWwn8QbLs2a/mMm/jHcn/lz5uNPDrrOmbkWNmvw4gKD5o3NH7LzyDIMkUPDWJuxa1ShMytLhyJlB/PI8f/GK/ZCeVNiKJW8nXBS8yzgbRMatxCGCNRsccs3N/xzkrpqTJwLUzvK4//YC99iWAgjzbHU2qfAB3C2RbXwQ/0RN8n0At/hjkDuQ8j5zlJEIXcUiZg+sHbIg40skR956qHuDarFDjg87+Uxj4wLmRTL/YEVAK7gjtXbo+ji9g5vbR6h4VmPqGv+6TrA/X1WcHLFFtnuMdZI54/QA3HZUXJICmvE48ZvBzkno0QKDQR2Ia4igiY8sLn23UkvNdG9DQvZjD9117ge0p5CuV/Qgsu+PbM1DLr3kQClR2S1O0Si/+ShHQCm7Q9/5BLDDGKOKOshVpTQKo+qTA/Rvyyz/4dzUkARR8XGCbqwjH2XzoiW4G2pN9Bk1WCBB4NdV4k+LILPwZPCvGyhwQbFR9DEeQmFtZ8JsPolfFCnzDJ6TXk7HE/sAwVjU5MezHNW4PNeVcz15cDPNx33pC3DdG0imM3XAzk2zZftIaBolRQqdY9xq3jKHWor9kr0ZctQpZS9WuQuialFVzIuGU8G3RXUsCMzLUsbf94VuP4OxLDv7vQaXSZUy1++fKz9YdS9BncxK9I58a1CerDC0+wfqAfpjFj+ZKrfAtev4vrsoXUHdICY2yrkRjJBZT2Xu0MrNhoMgn9Z
 TYSoEE05
 lpjJ0+XFsW8GcQ+2+nr+MAEt7zHB4ezGUx7C7RiPQLoWHa9RAZJ5xvb8fQL1v99j+m99bQXGRWlUtlbeBAJW2US63X0z/AEElXwRuItz9UvILpc3usOE3obdMvWPAim5FNRIV/gvNb5DiSsVzek00cQtYAnw75dsnKdWbRArOv/bSIkCoCNFQqbO4zGxdkg6SbhstddpVblUB34ozqGuSHOWKK8Ya66ffWcUT5ElacyGSZAa6RFSWzIoVxZVOO78UxSTrLIjY7cNgjaTOSwjibEX6gAasADcIBsKVo8RW4x7tnuOBrskFe5U/4Fko2lt8lCez6EVAXAvXTl1CJEKT+wyTwFl7qm3ZJ4yTj9qjD7ufQDVaDtIwHZ61EJwRFBe2v+cps1YqDozk+wYH5dxFEe9UNtmpqGYLnTjPSMm4svMHjcVghqekGr2w4kyCB2wgrAlD6LmzOirenh0tKHlLeZAEbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 09 Sep 2026 14:49:29 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
>
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> When reserving huge pages for a shared mapping, reservations are first
>> requested from the subpool, and any remainder is accounted in global
>> reservations. When adding the file region entries fails later in the
>> process, the reservation attempt must be rolled back.
>>
>> Previously, this error path explicitly dropped the global reservations
>> that were just acquired before jumping to the cleanup label. The cleanup
>> label then returned the pages to the subpool. If concurrent activity in
>> the subpool allowed the subpool to absorb more reservations upon return
>> than it supplied initially, the cleanup label calculated a positive
>> difference and attempted to allocate new global reservations from scratch.
>>
>> This premature release was completely unnecessary because all requested
>> pages were already backed globally: partly by the mount guarantee and
>> partly by the global reservations just acquired. Prematurely dissolving
>> those reservations forced the cleanup path to attempt fresh buddy
>> allocations that could fail under memory pressure.
>>
>> Instead, track the number of global reservations actually accounted so
>> far. In the cleanup label, subtract the already-accounted amount from the
>> difference between requested and returned reservations. This ensures
>> that when global reservations were already acquired, the adjustment is
>> purely non-positive, dropping excess reservations without ever attempting
>> fresh allocations.
>>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>  mm/hugetlb.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 652cfb55c6e6e..1151ad959ffd5 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -6678,6 +6678,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>>  	struct hugepage_subpool *spool = subpool_inode(inode);
>>  	struct resv_map *resv_map;
>>  	struct hugetlb_cgroup *h_cg = NULL;
>> +	long gbl_resv_accted = 0;
>
> Sorry, I think I have a hard time with this variable name ;p (I know,
> even though the function is called huetlb_acct_memory) I get a little
> bit confused because I can't tell if it's meant to be "accepted"
> or "accounted".
>

Haha, didn't make the link between accted and accepted! In the next
revision I'll use gbl_resv_accounted instead.

> I know it puts the line below at 81 columns :p but maybe we can just
> split it across 2 lines?
>

I think this counts as an exception (more readable) so 1 line is okay?
Either way line wrapping shouldn't be a reason for using accted. I just
didn't make the connection between accted and accepted.

Thanks for reviewing!

>>  	long regions_needed = 0;
>>  	long gbl_resv_get;
>>  	long gbl_resv_put;
>> @@ -6768,6 +6769,7 @@ long hugetlb_reserve_pages(struct inode *inode,
>>  	err = hugetlb_acct_memory(h, gbl_resv_get);
>>  	if (err < 0)
>>  		goto out_put_pages;
>> +	gbl_resv_accted = gbl_resv_get;
>>
>>  	/*
>>  	 * Account for the reservations made. Shared mappings record regions
>> @@ -6784,7 +6786,6 @@ long hugetlb_reserve_pages(struct inode *inode,
>>  		add = region_add(resv_map, from, to, regions_needed, h, h_cg);
>>
>>  		if (unlikely(add < 0)) {
>> -			hugetlb_acct_memory(h, -gbl_resv_get);
>>  			err = add;
>>  			goto out_put_pages;
>>  		} else if (unlikely(chg > add)) {
>> @@ -6831,9 +6832,10 @@ long hugetlb_reserve_pages(struct inode *inode,
>>  	 * There may be a difference between the number of
>>  	 * reservations to consume and the number to restore now if
>>  	 * there are multiple threads interacting with the subpool -
>> -	 * restore the difference.
>> +	 * restore the difference, taking into account any global
>> +	 * reservations already acquired.
>>  	 */
>> -	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put - gbl_resv_accted);
>>
>>  out_uncharge_cgroup:
>>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>>
>> --
>> 2.55.0.1007.g17ff1f9808-goog

