Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C6CC88E41
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 03:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28A96B0005; Sun, 25 Jan 2026 22:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC386B0088; Sun, 25 Jan 2026 22:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB526B0089; Sun, 25 Jan 2026 22:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 894D86B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:11:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A8C41B069A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:11:49 +0000 (UTC)
X-FDA: 84372640338.17.D70274E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D8E1100007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:11:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrn0BHm0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769397107; a=rsa-sha256;
	cv=none;
	b=l1FEzg89p4SpSG2JqfMnLcndfBetJwnq2GdmPTGmTpRTQtSmLxv373CL0dC2qFmG2K2tn9
	km4UIXgZRC/C4/CmJYPTricWScpVkXLAndb42aT7+jY2g9xf6kP7cnFCseLRs6sijfb+HI
	SUGqi0FrPP3YGOYlamtWnTtY9kfjYvY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrn0BHm0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769397107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhlapqH4ikiODVcmKIYx08XtjNQj8jB08PiPoS1TveU=;
	b=oUTwseOW48fA9kvZMurSShVzD5k1oZ6L0rVk+UMEhQrG1DeyUF+S4w740fKz2ymCNgG69r
	qi7AW8vlyxzyO+D3tn1Kvr+ox01+A62GxHCTra7JPVr449JDW0uVmNRcOzcp9aHNXb91Ux
	dFdprNgmGCh0pD0+YEe0EccZuHwG6Jc=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81f5381d168so3830847b3a.2
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 19:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769397106; x=1770001906; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zhlapqH4ikiODVcmKIYx08XtjNQj8jB08PiPoS1TveU=;
        b=nrn0BHm0kfY/4SQzHlbZ4Q0eQz8lqxOuys1ZIRd2c4Vst/OkZNcEx3ENgH7ldZ4BT0
         rI2NdWZ59ashg/qNM1UQHgWN+LuC/zzkhAe+GpsDOZ7vm8pmwefWkksDBLsqLF5BOQe3
         9A40k1RvPKBcgNuV1Q8W28g9DkmWJP9pO9ygLmgp0mep0HAL1t2Sg+i8PYgw/SM0Gi4b
         1Z4vn1JAFjxHTFUltulOEja91JhQJ6LFKDyCBcvY8cYSfombBt2dt2aJFZoriiddxJdr
         MaWwBMhiIv+dP4OJ3bDWRA0N7INcjyqrecLFWw+LCelimLMb73KFmF6PdKYjBdSLS1e/
         Ih3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769397106; x=1770001906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhlapqH4ikiODVcmKIYx08XtjNQj8jB08PiPoS1TveU=;
        b=Ppq6GJdkBmpIkO1ww9DpOpJG4jsqsyWHrNLpijiepM/3AUmOVbyaIlp6SaQisH0qaN
         hPbTFW9IY1bvLsTaxVn30QuR9NMS1SkC9LnB2VOrhS5cwxfu+MJpfI2WY4Cqs/ObGONX
         9dQ2hpH0aPlg/lnHWTBkeuUP17xwE2VRU3HGGEk8WwOO3yUr5Bc8BaI4rQhaZJavIJgB
         oVTJfwwr7fbK5fPB9tVKiXUKlK6EXNrYVCopIVpt8BPefqgUGy8ceHliAIqMKj6kdQiN
         gujLjPWa8W5DbsigNwgrg1ZDtYfUwtAl2wB5pNkQJMus3vdxq/1GkKitzcL1PMADH2gB
         kJsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQc8WjpQfgwiAK1HCSpvvuShZJdjLVb+mWQj7iRYpXpbuVebaR9eYvofuTY8aO2kuc4oqhlw2nbw==@kvack.org
X-Gm-Message-State: AOJu0Ywpbe6nj/4C4JCcGZxxyFetmvZ096gjXQncZhL6FMOb8+deSdxX
	nlRqMat6VEFw5JILwb27ID9lsJhl8iuGG1SVFSX8xCQNUlpQ1be1TSUH
X-Gm-Gg: AZuq6aIhLP0WyDL35jTkB5DDdWeQ+Rz25ww/+ITYCbzFRiqytYh6qW9C/mWmQJ5z9lJ
	VpHWC7jI2AnjVm2vbwN6AUIzbo+C/6lUljVmszJlgar8chQj5WnstyFLCFd+0Lepb/TQVF7w/wK
	h+URIDZLyvYp8zh/s7AbCke5KAwTX+nUMVZuadbdB62+7rHIJhZ+Ab5agVzrO5Eda1MfJTVqyL/
	IVuWMT8MaAf0JIo1djQIqhuQsB1G5B6fdhqsFTOQagvCNyvv3wUtsx9unY3M/PLCYiW8JmtQ4a3
	6gdd6D8PeXqm/38q6UFtBje8HiUqE9Aia9AMRJrz2sTwdgsFC6jU4+PjT8SESvZltBsuz2H47Nh
	DTLB1icok/1tlSFNddRCfTrBdEHq72Z2OzEUM3WOfVlFO0kHqNCvaYQbEuY6cHnY3DLK0ZOSKV2
	JqdBFo2D45p7uqq5bI9De2mzD03ucFlNyZzObTB6drlkrza4dCoQDwTfEA
X-Received: by 2002:aa7:888b:0:b0:81f:52d9:5f5 with SMTP id d2e1a72fcca58-823411b7b78mr3026632b3a.10.1769397106186;
        Sun, 25 Jan 2026 19:11:46 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e5d0sm7996541b3a.61.2026.01.25.19.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 19:11:45 -0800 (PST)
Date: Mon, 26 Jan 2026 11:11:37 +0800
From: Kairui Song <ryncsn@gmail.com>
To: syzbot ci <syzbot+cie25b4769e5d96875@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, baohua@kernel.org, bhe@redhat.com, 
	chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm, swap: swap table phase III: remove swap_map
Message-ID: <aXbbCQ3Pibj-T_fN@KASONG-MC4>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
 <69769595.a00a0220.33ccc7.002b.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69769595.a00a0220.33ccc7.002b.GAE@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D8E1100007
X-Stat-Signature: jxa4uwux3phbkz9z99scx16g74mkk6u9
X-HE-Tag: 1769397107-41561
X-HE-Meta: U2FsdGVkX1/RE3/1+1Tk48WLFa0+i3zqFaRV4yFi4QqJJorf62DdO4mfZK4P79XB6CNmrm+Nynij4B7zoVLw367J5AqoYHyg0M+ZwVkRg/BFTeIWSkW2ArNy2zLbTo6KIsa9k9PpKzdZdEpD2DGsX193BMTryZyDqDBe9P2xKsxAr0NOppWavNP4oNzCNoq39DBCfL0ZApQsAtaDxSfndp9rW/F148DQobeQw/bYyrAVhmi5JbGY/qi6CT4FJKeJCpXJuLlX1xirJT6AdXXa1nyejZTJ7Pf5fmSH4CSjA73CGwdlllwqPo3bLdDHRsBoWJnxDrjH2Prv3QJ1J+j3t8aX0qqxGpb/Lhi+6faVX3aBz90T1Jc03Ug/Bk5YWrNiPRyp0C4PREH9WkJqtGC2jjikSMM/UV3RQpDAXErJX7VPiI8cmJpX8DUjglFdSWzagwN8TKaYudNxG1O4pl7u3Xk0y9vm0C+93c09c7WfZplbx+pgIacDgp0Xu0StlnKy/8oEw4t6WaX0TwEbXsA2XYmMgnQX9a5YJl8HKs6X3/oLUEkIGPTdIK+Ix4M79p+jcKLfzi/iCB3b4FqC9DZw3pwtCpd5i9rMP5v9FRr2O5/laoPLLvjiX4Rnu7ecofsmCGbTVSlnDEqUEq3VDAk1N+/Vm7hWb263CwBa86pDN5Aal7i5uqfHZeJDdTsDvvrd7H6pEYNo4GGaCGY1+2PcxPKDtaEglfFIbE2xMqLe5yVEj2imFPClLRK7U+JuXXHM9UMP/O/4WvUrFbFh8eTkZiZ/HWLfuE7cCJUx4d7jXps+ghHLVtjFn3nbIAA7OJbeDaMsKL0GFKQ/M7uJgFMVlBoQdvJ4BKKGmAAeMjPlrXyPQ3ApNgmcPU8MwK7WY1u/1WEgi3yypkPg7lY2vo8wJF/2j2WU6AUG7zP24N+nwqM/O77vsPqaEWjA9Ul39ddepujhyl7/puMNNM9M70J
 jqgYd/Ct
 B7l6lzCdj32ydj/5Gw4taMVTAp/TccHtodXVIwoVnIPnMHs/cCvsYpCSTnKJQ1MOd7bRBiEat5+R2L636vtO8CRpieZTsoU2go4v16I5HxjGxu05eO2qHgaAuUeApVtrUQ0zg7bcc5+xVXLEeGcoxQldecIO4BIIYadvJnlb+u5kqPV9P7uNPOP6O9vJP8/V5U7yLbqn3OnonFW3SDu7nQzU+3KbPyMFKbpDnQyrGDi9zIFlP+8DRMAlNnbepvtfMnyaBFSKu5TuNsk9qtrIuHjxRecidQJGWbcH82GQ80zQilvvQcf0elJKqdVAKm65ctOVcyWxv/CqxbvD1ZjsaVwPUoP1F/fGa7a9m69d0QUUIODm+vUwB1sW2AcWjFwCl+AK77d6Kc58RzhUcJDkD3DVR7lC2s9qlVhPDjg+HMCw4gQP1842oYKyuJAr+imVnbFJ2C2TGr9Qxp2+VlNRzz2TRHSXT0gaUgUdN8wyIPSpUGhVfgJJSHJBmBqDyAyPctabPPcB5XGn7vG9oFnnYF7/XnbWasV8eNZhHdYe1RWPfk6hxOMn0xxaJVHuBCG/t9Gju3xee146q2Hxji7k5ubXzv0XP6X4vMlB1jPi5tFXTueMcUT6mUOLwKqwF4I7T5u2Ik8zy49pxcf506XAtnevyEejJF/lBMpSPrA/7NvDXz0sHi5xcw05MauwfTz3m4BUyWxUERyEivVoqpc3b1nJFotNV3SqmMcWCFxnXk7zew/v2KAUt7K2gZ2/H7/4rtzRtGJIGgnRa3UIVRCcMmxQh38g93Fhj/2UiLTF6vK89pykDq47YMfNWU01o5D04ElpAW/fFmKQpjYQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 25, 2026 at 02:13:41PM +0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] mm, swap: swap table phase III: remove swap_map
> https://lore.kernel.org/all/20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com
> * [PATCH 01/12] mm, swap: protect si->swap_file properly and use as a mount indicator
> * [PATCH 02/12] mm, swap: clean up swapon process and locking
> * [PATCH 03/12] mm, swap: remove redundant arguments and locking for enabling a device
> * [PATCH 04/12] mm, swap: consolidate bad slots setup and make it more robust
> * [PATCH 05/12] mm/workingset: leave highest bits empty for anon shadow
> * [PATCH 06/12] mm, swap: implement helpers for reserving data in the swap table
> * [PATCH 07/12] mm, swap: mark bad slots in swap table directly
> * [PATCH 08/12] mm, swap: simplify swap table sanity range check
> * [PATCH 09/12] mm, swap: use the swap table to track the swap count
> * [PATCH 10/12] mm, swap: no need to truncate the scan border
> * [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
> * [PATCH 12/12] mm, swap: no need to clear the shadow explicitly
> 
> and found the following issue:
> WARNING in swap_cluster_lock
> 
> Full report is available here:
> https://ci.syzbot.org/series/3f6169fc-e24a-4a19-ba56-e5907b448edc
> 
> ***
> 
> WARNING in swap_cluster_lock
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0eabd97a-86d8-4606-9d94-dbe4e7fd7c07/config
> C repro:   https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/c_repro
> syz repro: https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c684/syz_repro
> 
> ------------[ cut here ]------------
> offset >= si->max
> WARNING: mm/swap.h:88 at __swap_offset_to_cluster mm/swap.h:88 [inline], CPU#1: syz.0.548/6508
> WARNING: mm/swap.h:88 at __swap_cluster_lock mm/swap.h:101 [inline], CPU#1: syz.0.548/6508
> WARNING: mm/swap.h:88 at swap_cluster_lock+0xef/0x130 mm/swap.h:132, CPU#1: syz.0.548/6508

This is a good catch from the bot. It's caused by the patch "[PATCH 10/12] mm, swap: no need to truncate the scan border", however that patch is not wrong, it just have to update the debug check too:

diff --git a/mm/swap.h b/mm/swap.h
index 087cef49cf69..386a289ef8e7 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -85,7 +85,7 @@ static inline struct swap_cluster_info *__swap_offset_to_cluster(
                struct swap_info_struct *si, pgoff_t offset)
 {
        VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-       VM_WARN_ON_ONCE(offset >= si->max);
+       VM_WARN_ON_ONCE(offset >= roundup(si->max, SWAPFILE_CLUSTER));
        return &si->cluster_info[offset / SWAPFILE_CLUSTER];
 }

I'll update this in V2.

