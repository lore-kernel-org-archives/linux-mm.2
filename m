Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B3EC44506
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7116B00AB; Thu,  9 Jul 2026 14:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E896B00AD; Thu,  9 Jul 2026 14:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB49F6B00AF; Thu,  9 Jul 2026 14:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1E66B00AB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:55:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25DDC401F1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:55:01 +0000 (UTC)
X-FDA: 84970140402.18.5FB7516
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 526EF4000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:54:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ogWj94rg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783623299;
	b=o0Rs4ScOGMkY9/p58mPyWKYkIr4ygGSsyiI67DspYkq5mydlSy/zm4IaCoTVsmrZp03sZS
	eqfe66T1pvLk8PavtVEOJPzuIRW+jvazbyqQXgi6opwPbQ3mNS5ajr7AZLe4y4n00IBbfZ
	aUtDUdjKKQpkEwxz1M5tzSzP+RL9jLE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ogWj94rg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783623299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wf2mCygj2V3MtxPOIjhT5RGqf+/9JXlGVheo76S1fao=;
	b=7xEjmhHuDzwLpGfl/Cwhc0IaChZUiG+KCgryWjdNXR0leuaKun76Lsv8H+tDJc46B1yed/
	A9CVXwuGwh7l7MAVxkKGfVit8MOAX94aYSsDex04QDPJfXXdxMyYGBfBWimrC3STBZgw6p
	0Q6i4/HyQRSOSuO8L6tNj5PzJHnUczs=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7ea9c6ea7deso175252a34.3
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 11:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783623298; x=1784228098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wf2mCygj2V3MtxPOIjhT5RGqf+/9JXlGVheo76S1fao=;
        b=ogWj94rgS13ODqBO5MFlytznfFR4Ud9Qk20IVer/b2eeakXm7FD/Ike4Z1TWQqn3gO
         4pklxmQbdmwV2O1v5MtQFB4xdu4gqD/LTdwO0S5Vmn3RYkYkJhXQsnnrFKNcEczDUGHo
         aV3r4tiqBR8mAvPsUheaHrBaog2nXBDzeUcq+xGoOyGGth2e8CR4YA0leZkeYAZ62/QP
         OlLO6av3zBgoxm1Th/hjBaemeLh9SlQk1PdiwVBd/mw0sGguoOr9YwrqDcSpgF2UT4kz
         IwCIkuqP1kndEBgmOkOhoUHni61geatk3qqC2RHTE8rmflb+lWlLTKM56Fcx0blu41m1
         Okhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783623298; x=1784228098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wf2mCygj2V3MtxPOIjhT5RGqf+/9JXlGVheo76S1fao=;
        b=d7GMH/1KAURJ+QKQWE8d26W4rBbXgjL0E1SeM10NAVIDDCGOrCcHVrKcW6uQqBCbA5
         J0Viuqsvh6EExMGBh6cRDO2y55hEk6Kb8gk7j/pbOdWJ86hRxdJU01qFFYUFS1skaGuJ
         lsFTWwK8a+ecTLjX069qhHMzq0YhY/3bIcs4kjCMBnt/YLLMJPhmkt4zdF19W/2VfL11
         lcZS1WAbnUV5WOG+UgmSth3beq6Vl5S2SqYDWBan02O9To+gldi0996Qd7nnCQ7LA4tz
         VfiQgz4w1Pm7EOnxtuAAVbqugvEf0gTq/hM1nA64YP0Btk241FvgyI3bSBvCT7NtTOoq
         2/gQ==
X-Forwarded-Encrypted: i=1; AFNElJ9rbiI25kHPQaNrMHNBycZ8Cy3cXSZG+J8lT6nCTUwQHCmcGLgbN9C7u5pBhx9JLc44fBml9f9VeA==@kvack.org
X-Gm-Message-State: AOJu0YzgcbFCsqmw5SmBwlDPu6XxAaOfkGKKzjvm/kXRSdyERej3dX/2
	x6eExa3F5tgcqWuAzha93c5MLg0+w96gUxU5vKo8vTYyEfv8UaEO3UD9
X-Gm-Gg: AfdE7ckx1hGhMOp87Bzv/Wb2Ed51BiRrFmDoT8y+c/bg/GPUS/DhHZ1Eq0eUEwRRY54
	B4nfAWH0Qefx6kFxLc3X6bHvGEmTzW0IucL/6/pkQcO+eHprR43SVxOn+KF52+yFChChi5Zo/gz
	KwpBCgOMjIllugdLk5o8yj6OZJShjNkl8unheXQbYFeIQHKVjJzif0FP5bvWW4SOh4UIEoF9/Jk
	fZap89QB6Au4A0Pb24vESFxXGSa8NVn0tKt7CeVcy7f5Mje5Bmd+ps+Lfdy0YD00ZAu87f/sRSG
	Q3TaLtrMG091XszDoYh8gu+S9blJSbYzXzyUC6Y7djr3l3V+hskK/G7pjA5i/Iwo9slIYCaPhaj
	xOpkqtUkKY3TJlaSnKf2fECQgRhvBEinCBLqPdRzgR5ALSYqzGZu6vYb4NA7ahiGWD1/tiXwpmN
	yHND1D0goJ+n8OkcqfrSwpflcuY90ouOT3D/7A9FsRnuk=
X-Received: by 2002:a05:6830:2b08:b0:7e9:b537:102e with SMTP id 46e09a7af769-7ebcff9e14cmr5905427a34.27.1783623298042;
        Thu, 09 Jul 2026 11:54:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:40::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcb2630casm5108633a34.18.2026.07.09.11.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 11:54:57 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Wupeng Ma <mawupeng1@huawei.com>,
	fvdl@google.com,
	rientjes@google.com,
	jthoughton@google.com,
	vannapurve@google.com,
	erdemaktas@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ackerley Tng <ackerleytng@google.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mm: hugetlb: Fix folio refcount mismatch on memcg charge failure
Date: Thu,  9 Jul 2026 11:54:55 -0700
Message-ID: <20260709185456.1854151-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-3-c7f27cbb462b@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 526EF4000D
X-Rspam-User: 
X-Stat-Signature: jfauma4nnu7aea714qajxdomsjsg5wbn
X-Rspamd-Server: rspam03
X-HE-Tag: 1783623299-590715
X-HE-Meta: U2FsdGVkX19CwIPJrgM+siDHIFOihPScc6yYszoNhAlwoeF6Gmo+w9W4crbXfFxv7/JPS9DbsZVJo7dqJi9TuTRbBUX08rWkuv6tqB1cMIS7nZXNw6Pokj23XsnMjKhvyFksh5ERkVTUfaqfIr8pHrr0V96Fec35xxYLD/+fcdfKPxXk88WSTVR3W2uPW2u32Ckrpxohcrxa4VUwtnoVTnZlkwIOJW7jU98BPXiN6DxJIIymDxYCN4mXFdegW57DE+t/h2O5bsgMex3nQ05AmgouPDVLRe0oktXsesKJ9QRExI9Oay24MOqnMKYd0Qng8FCraFRjufJiYMX+0FHj4t/qRZk4n7m6Ph/yUjHQRUd6HKoac3JumQ9Y8b/vYP3pI0xkZJoynK/uf2QXM0iPtjIf3Y97mT0XC99s/lvxtA8OR2Yq7e3srGoLaVXpU4dpaGvz3Jk6NgIzSxlfGVMceaDGbchJvEEUxPhTJUUVPWMPraE70w3A7F4n0VjhG5jVwuVhdhRSWO24XchT1EBGas2pv7I0LThzSKezaGZQw8W/UCn0rRREH7r1P8jgphSeRubBW8oAWKChfPIz+/3mdFMdOXivTA24RwVtTGbpS40P0k/z4LU3HT1JEKgQwOJoXRg/yK1QptrORylTGcLuIdbyFRqXja5Vm7lLn6GYtSJpclmYaaMPm+spHKrGR3vZOHjDg4VjWCxLv5nWQqqBS/DrNsbfhtzSY7Ys2cnqBIqdz05H68C6N72hdiUaX5yDpQPS8EkMvyNpnO95b+rDZzFX33tpj9OkkSgEU7Cv2G2yFrphyt5UZp1aQIWVeZUdfmViooWPyUEXdO1S/QHJ5mi4L5YCex1hE6Happb6xFwZ9wpnTK4WNfzlDImkNccMkN1mliJWO3dXb+nlyd4RDabT65QjsrSIax88rrpmUixlHe/2Z42bJ7Uh6L6v5k2mi0RUmWf8GKMsVOsk9rl
 ph/lP6aS
 kR5gE8dYz08NArqNIkdQoekc4xu8veTyb+ucKS4WMHplGVcKMrFzXakw3qSsxTUMMXraQsIrj/vR4MBZMIixVxFU1SWNj8OIiHhKQAaUIebRe+mTsEvXqgaXXSsrMPpfzrv6J+d6rxONKyjDaZK1Mzjc1dZxCRR3kd9jo8BJGy+Nx0AHrnqYdKYgY4KnHlMFmB/2qkz/ZCnu5K23ObDcdJCg50zbKpUlD/o3yMklGZO8k6namNyop4k3YbxEGaR9ix7a4mmtilZ09D5tVUNWxdGh7IQuVWjHBXcX96SSWcz8xConJ7gCHF1R8oaqxZ+nY8cWQ4gu4tp8+LxNVTiiAeA+t/mHT5ZKpbqkliWeiO4ZaQmlQpJxpdeHd5sX59tuVMLmpekBE3JMTRMITr6tzYIhuLgzFCUt+MlJIxKBgYaSf6ZjyGLiLfIZuvIGnBdTEisF0ZcKRiajYwBVCUpo/yEuaW3ps6cRjCT789NCIyp3oHO9eDj9TJ5O3i+pZsiDYhmxRUB7i6FeQzVFDLZ8sq2h90cby/UjYExmcGfgLJTPRgr/MsL1bpHv2HQb07Lc8kvMMkrm19Q+1gBXZ2jiiViKXDzbmO8jBE3ifsdiM/te2KcX8IhS//tIFpVwOHR87BMnNR5RndutBck7XeLpWgO+4ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 08 Jul 2026 15:12:51 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

Hi Ackerley, 

Thanks again for the fix. Thank you also for adding the reproducers,
they made testing this really easy for me! : -D

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
> its refcount set to 1 via folio_ref_unfreeze(folio, 1).
> 
> The error path calls free_huge_folio(folio) directly, which expects a
> refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
> triggered.

So yeah, I built mm-new (with your hugetlb open code series) and ran
reproducer #3, and got the following output:

...
[   23.855813] Call Trace:
[   23.855838]  <TASK>
[   23.855877]  hugetlb_alloc_folio+0x190/0x360
[   23.855930]  alloc_hugetlb_folio+0xf9/0x310
[   23.855972]  hugetlb_no_page+0x590/0xa00
[   23.856016]  hugetlb_fault+0x194/0x770
[   23.856060]  handle_mm_fault+0x29b/0x2c0
[   23.856103]  do_user_addr_fault+0x208/0x6e0
[   23.856146]  exc_page_fault+0x67/0x140
[   23.856191]  asm_exc_page_fault+0x22/0x30
[   23.856234] RIP: 0033:0x401734
...

Running it with your fix, I don't get a kernel crash. So this change
looks good to me, please feel free to add:

Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

But.....

It seems like fixing this bug actually surfaces a different bug.
I don't see a kernel crash anymore, but my kernel gets stuck in a 
different loop:

...
[   42.526726] pagefault_out_of_memory: 120780 callbacks suppressed
[   42.526732] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.526955] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.527084] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.527192] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.527288] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.527382] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
[   42.527476] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
...

mem_cgroup_charge_hugetlb() fails
--> hugetlb_alloc_folio() returns ERR_PTR(-ENOMEM)
--> propagated to alloc_hugetlb_folio()
--> hugetlb_no_page converts it to vmf_error(PTR_ERROR(folio))
--> propagates up to the pagefault handler..

But there's no OOM handler to resolve, I think. So it just keeps retrying
the fault and cycling over and over and over again... I think we need
to be returning ENOSPC instead of ENOMEM like the other failure paths
in alloc_hugetlb_folio (or hugetlb_alloc_folio... I think we should
change this name, it's a bit confusing).

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 288535838a48b..05214b1cd491a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2903,7 +2903,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
                 * were committed to the folio and freeing the folio
                 * would have cleared those up.
                 */
-               return ERR_PTR(ret);
+               return ERR_PTR(-ENOSPC);
        }

        return folio;

This gives me the following result from your reproducer, which I think
is the expected behavior:

attempting to remount cgroup2 with memory_hugetlb_accounting...
Successfully enabled memory_hugetlb_accounting
Child: Attempting to allocate and touch 2MB hugepage...
Child: mmap succeeded at 0x7f0023600000, touching it now (should trigger fault)...
Parent: Child exited. Cleaning up.
Parent: Child killed by signal 7 (Bus error)
Parent: Child got SIGBUS as expected (if kernel didn't crash).

What do you think? Happy to send it out as a separate fix or feel free
to fold it into your series / fix, whatever you prefer.

Thanks Ackerley!

> Even with CONFIG_DEBUG_VM disabled, returning a folio with refcount 1 to
> the freelist can corrupt allocator state later.
> 
> Use folio_put(folio) instead of free_huge_folio(folio) to properly drop the
> reference before freeing it.
> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce mem_cgroup_charge_hugetlb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  mm/hugetlb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4093c1c0a4a1d..1f3f4b964b153 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2990,7 +2990,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
>  
>  	if (ret == -ENOMEM) {
> -		free_huge_folio(folio);
> +		folio_put(folio);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> 
> -- 
> 2.55.0.795.g602f6c329a-goog


