Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B27C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20D26B009F; Thu,  9 Jul 2026 14:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8B16B00A0; Thu,  9 Jul 2026 14:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9946B00A2; Thu,  9 Jul 2026 14:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 906C56B009F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:58:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3825A1A026C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:58:26 +0000 (UTC)
X-FDA: 84970149012.15.5A74284
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6E44B20002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:58:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N67iw72G;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783623504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7H//saN3HUHN+i+S3SULFCinOHrdn1xh7S62KvKH1s=;
	b=oDPXQw2heO5yBFSn3+pThcdA83L16CkyoJpCHlV6ePVwoUdB0VIQIomHoFHOwUhUwgOZ4Y
	zq0Ty9HDJSCMJ7d5fCH1PNsh/BRYpCzWSjKwO3F2M2w0HtODFLLGBnX8USHLJ0E17MsWXO
	LMg3k9uX1a5Fh43cj0QPt8jnnpkqjcY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N67iw72G;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783623504;
	b=FGh5kfdi0CP8RMDIcC+mriN166a8r6sn07gfchd29a4tbX/hH//JxwOzr5OostYi4N4Mb2
	uJOVtmWN/XF/bIRw4dWiCC+jkmQCud2BO5mJ+8VOD+u8qxNWu5MAhNCNVXpWMCKU3AP9pm
	susY5J25nbscu2dvqJGlBdBEiF7Ixj8=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7eb29ed2bbdso88475a34.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 11:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783623503; x=1784228303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v7H//saN3HUHN+i+S3SULFCinOHrdn1xh7S62KvKH1s=;
        b=N67iw72G75dZDfmJMJSkK3uA1yzDyWWtqohpP1EBPNn75Dg14OoCfd9o9TD1+5yIyk
         mfXiIrU+phkvXr5+FkXw7NNJEC9BQbkacXhKdeDZA0CRuwZemgOf0AYZBJbp7k3EczuP
         Y00OBYjg76sySscG8hUHuH0FUwpzdCQzZn5oO0j5mecRS1Zu/wR8Ps6rdngv5FyOciBJ
         dG2Bk4hXimTxGjWgSwu6bRUkouODE2RL/uHUAfDI2O6cFiXMciAQOgeA1G/wkRHxYKpX
         1wBrWkro4BTByGXBU5yebWaA/nu0DI/Znu0piXXHbEudhrGX1RLnbaE84l5T1ytFYkPF
         EpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783623503; x=1784228303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v7H//saN3HUHN+i+S3SULFCinOHrdn1xh7S62KvKH1s=;
        b=gwJFO8qPHpIE+5YAUtobE6C/vWDIvh9JHrfyO14vQb73cpiaoJqoiEjhpk4cs14e+H
         oEF8hW+6XZwk7kRIZ46oEHls3f6MSAGjzYlnx1HtvOawAbxDIWlSQXenylkAwQXId3mh
         hjyVMnVXQNe+rO9AcPGsAz2gktE9r3/F0HEQaFzlvU++yJkCl8mcMZXqfK58lIC0HMWF
         ONnTuMx2//mLgJN6uoIuyj+FgmDGPnYhg5FeMsePXgSmpGvGqkd7vO0VamcraKQyONSV
         PBGHdChvVbpQXwX3SzfC0ayxI3ihB8nPIceKTWtRYohF9K6wTCzAq+Z4IjL9DhCGiNxD
         F0Ig==
X-Forwarded-Encrypted: i=1; AFNElJ9gFvYGcDD5/T9Ke0Tavj+3ua6YiQAo+CKRQ4cnXjA7CBixxp5exrqMBhRaJX3Egtmn23Wt/5apbA==@kvack.org
X-Gm-Message-State: AOJu0Yz5a5N7mcXInik6qmfoibfbmcXamPnezTGVIUYycViumcAZmDZh
	rjGxGN2z7OHW3vPxswNKEiuQmva9bpe0VNXx8OVZolw/n7DW19imEPyF
X-Gm-Gg: AfdE7cm0/ELGsZDcNd1F4EwJ1ZuMlFtUS4MQSfg37Ymiy3PMcd2bEK69DjWCWaX/fAQ
	DwmsyMMU11JQMq5uG/YGdC0CoWNoOWEbDdbB1msf0t/fYWTLeozY7Dmx3LQ6ASfQrhB0mRkAUSw
	H5QBKyTWePxmaFNCc4C29fTudBIx6phTrSNHooRTEXh0QrMgRZ5wzHZK2vhhADK4qRPTBrrrNs6
	BnDL8ouLrW28cG/Sl1Mg4BLNbqXPOm1o1majjh4TAE8HRAUkx1Oe76cS12Hafob0WDkKatoAsLP
	PqlghZ2P2iIIQUOmz5vkzabwWktpYWd7YUZRkbe3FJin29CKZR/j6xgF+1/nbMbisNUJY9K5SYp
	D4pK3/RsSO7rG/4RvWYBHPAsmhXQuOZTeBknkxJ9RX8FKH7qxqxlg2yCVojwH5ODZq4HoPl+Niv
	4IRWH4Cfe0kB/Lvrz9RdZlhD2YgQguMow6HD9vqJtv6OjM81hWkR8dHQ==
X-Received: by 2002:a05:6830:8388:b0:7e6:c9eb:535a with SMTP id 46e09a7af769-7ebcfe5414bmr6526626a34.6.1783623503381;
        Thu, 09 Jul 2026 11:58:23 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ebcae177c5sm4885829a34.5.2026.07.09.11.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 11:58:23 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
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
Date: Thu,  9 Jul 2026 11:58:21 -0700
Message-ID: <20260709185821.1893061-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260709185456.1854151-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bb34iodn3ha9no9deu6i6e5p5qx1gym8
X-Rspamd-Queue-Id: 6E44B20002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783623504-935967
X-HE-Meta: U2FsdGVkX1/Es0cV1iywxeRyVe3UBzj88OJLDRgmJFSmiSrk8QA1htXofxBrZ6Q1pX5YGRl30zm821SmYtwnAWMXJW8ITv1isEnGFDk/zNWTk3I3g5pOgFenxOS3MgzIGePS34LhuBGlQE/fAiNGIhmEfWSTYf1jxSMxoirzIi5LNNVg520lW/qPKYvmS463pVfXv5c213W57lpAyvKq1ctUaljWN/OPs1qfpsuL2BfjzqloxqtNbGMMDXS1d0KcqwrEUFVMczZQmsiSxdsJVPC7JBBqLDF8HR0zZlcOfYXgjhe4NaJyohxonp4fHsQFbSeDcAfJx7Z9CXrEK9ixXwn9YIDcgDgrFDe3iEcm0PuRYqEmhTvf+rvMcPYjMG4zhwu9Ms87HxOjD0EVWLTE2bGJvP52Z+junO/iGiMR5BHd7zj7tGGmXGHrubpDZHUWLYkv8CsOlyCXxwasFrnlNU3iphZSndKWWwxbSOj0x/nSVnROCn8xI01ypnvfhj/tX+4JwYWebUTTIwbAYqAhDX4VofjWvmSUKqa5v5YgH+0x/KyjNOPMyUZxPJQpVRloVJbbW9IR1T183PHuYqAS4NX2zBRsg0nKNum6vd1VFdmIso5TBjozYaS0OPdzr1sFhoc8WRzxzz/7PQ8Vdb6R0BbGnbtUM9c/oPfFkmhXm2nmRkpKPmNhX9wVYe+MsKi+9x32Hd6o1KLHbB++4fAKYTyW5q+2dkzQv9gr8ITTKgLwz54X/WxWh0NWT6ABfXVd16A81X+iM5uOWPmyQ/PvMORs9R4lYcCpD9wBLNi/Gv3TS6FayTmFitLS2kHJv9xC01e3A+YVUdVYO4Yp4d5DK6k2tFLOlH0mdU9d+YgbUZfRoyOopUz3H6SdnK0YjZpzwy9B+9IhMHF4yb+ZCaHfT4/BCGNhwuEIDS4Z0AMU4J3jdpwoh9TiJgDmRL9SzgcXIZkfL/l7HNDyo5QvzAn
 lGVBi/xG
 fenORBTzO33b91vWgRpY6FBRpLZ63Wp2hxgTY2yBThTyy4jo+BAju/ayKjk1kqdCMaIM1LPNPl7SNWi8yP3Ji3pfgzxNnKmfCA1FsEdevjzsav9mlZr8bJ/0QJiffhfikkG/62HdMXFs/4LeVgCYggnbtrnDKRJrtwRT/RMB82q0jWTG3LnioAuh+B3XuVVbHwAj025e6BRjiN+QR+qynTk9mr53EFPbK9/ZrcbimIO6mYdeVLz+OM5TJRQDmLEPVNkE//TlGIeqxO6coOzdXhIBFsAAfs2zR8oL/Kc4acSrCaQaiLyNSaHBBx0OirVLP8y+RznJrmQCAnYXnTBN6oYJnsV+LRrx+fCUhVprvKjEBpJ9sl6S8+H5z9hbszvcegxBvJsYz9YOd/ZMZRgIqKNTrtcebOc2BXaF/ldIXBlclXzuUoiX6DGYRdyIFR2XYDlNKyZn4ozgPvPlTG1bHcLfmQ+RwRul0B4YiVX6mYcCOGA6GEvGbMEGgpEjgQFvBJZuqZVNYRbH3wRCmMpbhZ7a6MWpM7J0l9dh+XkmRmJKnSL9/R2aIkd+o5+DC7V+gYSaNVvGYigk8xJcomtIh0etakusv8mq6+tOrLq05OErmJ5h7hGZLiDJC9zfsQaBLa3+TXwwBN7NXQmDc5WYOggyAig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 11:54:55 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Wed, 08 Jul 2026 15:12:51 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:
> 
> Hi Ackerley, 
> 
> Thanks again for the fix. Thank you also for adding the reproducers,
> they made testing this really easy for me! : -D
> 
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > When mem_cgroup_charge_hugetlb(folio, gfp) returns -ENOMEM, the folio has
> > its refcount set to 1 via folio_ref_unfreeze(folio, 1).
> > 
> > The error path calls free_huge_folio(folio) directly, which expects a
> > refcount of 0. Hence, VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) is
> > triggered.
> 
> So yeah, I built mm-new (with your hugetlb open code series) and ran
> reproducer #3, and got the following output:
> 
> ...
> [   23.855813] Call Trace:
> [   23.855838]  <TASK>
> [   23.855877]  hugetlb_alloc_folio+0x190/0x360
> [   23.855930]  alloc_hugetlb_folio+0xf9/0x310
> [   23.855972]  hugetlb_no_page+0x590/0xa00
> [   23.856016]  hugetlb_fault+0x194/0x770
> [   23.856060]  handle_mm_fault+0x29b/0x2c0
> [   23.856103]  do_user_addr_fault+0x208/0x6e0
> [   23.856146]  exc_page_fault+0x67/0x140
> [   23.856191]  asm_exc_page_fault+0x22/0x30
> [   23.856234] RIP: 0033:0x401734
> ...
> 
> Running it with your fix, I don't get a kernel crash. So this change
> looks good to me, please feel free to add:
> 
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> But.....
> 
> It seems like fixing this bug actually surfaces a different bug.
> I don't see a kernel crash anymore, but my kernel gets stuck in a 
> different loop:
> 
> ...
> [   42.526726] pagefault_out_of_memory: 120780 callbacks suppressed
> [   42.526732] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.526955] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.527084] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.527192] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.527288] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.527382] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> [   42.527476] Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> ...
> 
> mem_cgroup_charge_hugetlb() fails
> --> hugetlb_alloc_folio() returns ERR_PTR(-ENOMEM)
> --> propagated to alloc_hugetlb_folio()
> --> hugetlb_no_page converts it to vmf_error(PTR_ERROR(folio))
> --> propagates up to the pagefault handler..
> 
> But there's no OOM handler to resolve, I think. So it just keeps retrying
> the fault and cycling over and over and over again... I think we need
> to be returning ENOSPC instead of ENOMEM like the other failure paths
> in alloc_hugetlb_folio (or hugetlb_alloc_folio... I think we should
> change this name, it's a bit confusing).
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 288535838a48b..05214b1cd491a 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2903,7 +2903,7 @@ struct folio *hugetlb_alloc_folio(struct hstate *h,
>                  * were committed to the folio and freeing the folio
>                  * would have cleared those up.
>                  */
> -               return ERR_PTR(ret);
> +               return ERR_PTR(-ENOSPC);
>         }
> 
>         return folio;

Ah, immediately as I sent this out and went to 4/5 to review it, I
see that this is the exact change you have... oops, please disregard
the message : -) I do think we should 3/5 and 4/5 together for
bisectability purposes.

Thanks again. Sorry for the noise!
Joshua

