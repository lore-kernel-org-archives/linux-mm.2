Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1242EC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C086B0088; Sat, 19 Sep 2026 03:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC736B00A6; Sat, 19 Sep 2026 03:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB3A6B00A7; Sat, 19 Sep 2026 03:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FBEB6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:21:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73EC6A41A8
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:21:52 +0000 (UTC)
X-FDA: 85229667264.26.068C48D
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8ADFF4000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:21:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BGZlIDwc;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789802510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ji22rS31Wtsj6DidSjKjGSzzURIi+KmCray6A2YY64U=;
	b=B/+jN3gpsT0qSWD5IE9SwQHMMlMLtsTFFbNvzdFB6k6GRJGOCUwkSio4MLftlYJ2C9LXRh
	I/I0IJ0BrcsT1uJThwzqR5s0Bnwb4r5nTtvWv7kphQjMKoNVukcKnDH/NF8bGTKAViAT5l
	CHy5Iyu+ivxc9HtW/aUxsELXHdxA+EE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789802510;
	b=Yx4Qu81sdV7H1J///ngueZFzVz3luVqTAbRgcDQYSnO+I9yGiukaczAZE9Lyk5c1kHGKFG
	7L/rPhm6PHM7ctlLKIfrJNul+BkW/IoJn1BpJWennjKdhc8VqeVdMY31C1bOuNtduTn9Nc
	ipyDIObuiqG0Fegm7SVYVSShY5JX+DM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BGZlIDwc;
	spf=pass (imf12.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469e2254dso231710b3a.1
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789802509; x=1790407309; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ji22rS31Wtsj6DidSjKjGSzzURIi+KmCray6A2YY64U=;
        b=BGZlIDwcmpGlODUqzn7KCBeEqMLcy/kXms2NE4STUcko6kEDrlPVQVaS/MG9TWCynF
         LgroWBsgldotcK+47RPg6R8dWdQGHFrbuYc8l7+m2IDm2Wy5Mryof04UUoTyL9y5cR8P
         f+FTrRJ2yVOLTqReTVw0rje0rC5PCAdZQ90nlq2rNkyZoUCZnLZ81GUYJW8cyevDsSNu
         YRflxVViX1OYQHmwg3G7sthRZp/QQ6PxpWl6vkROf9KmZ1X0mgRM6ok+zz2QuMs94vHk
         JansfUmDlZbhJcuRVT4t13O1H71WZ93TpT0Ilu+WRWsjXXsDcgksXBVpiOEJlvrJscaT
         0j6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789802509; x=1790407309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ji22rS31Wtsj6DidSjKjGSzzURIi+KmCray6A2YY64U=;
        b=kuMvlHdQPIjLu2CYz8MzRxD2s5MBMC1YgEhlVrxQHtbYagUEznlQsyYRlLI13nUMtl
         IW9n3FSzOhDq1DPZTVuTophgwEnFbRjlfhB5WUqDgxQDIV9DU8XGByD77DK/b9aFeUuq
         P5c64BDQN3LYf1G7KXnVT+DeURsJ/v6HkjKZwAtoFENYcI8cL8K3oaXOl93JptbFXrtc
         RgPOP+Gg97uCzHIQ4JApFcOIFHo3cEyVZ4No836xv4pEzDMQyxuNYyiV9LuxewV/05j1
         5N0xAargRGYcCCBHMHUFLSs7Vwf8R3xGpMUfa+/ywOAeE6SJFDhfoK+e44i3j4c+1gN4
         FKjw==
X-Gm-Message-State: AFuF++mbQGOBeuwWLC83alOb9J9vJe3M9+fZ3rGzApR+py0Qe/X4l5wF
	+wKkfYrYU8z/3f1Ae8x6hiEwB+LVkoZD+yifN9MN9faN6Q2Qaf4dk124
X-Gm-Gg: AYBFou0CZ5WfmbWgD01xoH1onXlaAoAOOKrAwxGXGTZ5pzrAnuCFS2MSaOp99O5Fy30
	NtAow9BUsL6YhzR6/tICH+OqF96VQkWRcmJwyYING53WmAx70y15vSkxEwftoFMGmOjin4SMwyU
	GsBp6gXkOxgOj1jSvQ1UP9U4CFvRS/aCrnW6I4duDrfkLI+8dYO8bJLqw6hGAsnzsK7gW4V4Rri
	XEwRXxEUtX4CJGDZ7abCtCeWaEzhYlpCDB/ssW4Gj20MdWAdlWhyCvTl7BcxQuRuXChar/nxnPT
	YhIfBH73ucMe1jcExraGQagShp8Qpci+J0xe0Pvh13WcXR9t5JMiBDQp838a/DQhye3J+izg3rQ
	Ka2R16A0kDQ3+jGWSt3wsir42EAFS68ksZZoW0pfVp6QB2aE5EPcMBmqPxl7SMGVdWulnTubgBt
	Mhn27MT1lpy+hBXpjN1+mTzW6OnoLV5C7ihSYf9o1fGNg//gHgVhWnOhoqImjJx3limjTvOpAxy
	x3FWKN6oCL+JXo=
X-Received: by 2002:a05:6a00:b94:b0:874:705d:f636 with SMTP id d2e1a72fcca58-874d5e29565mr5203732b3a.16.1789802508998;
        Sat, 19 Sep 2026 00:21:48 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a6ae905fsm742901b3a.3.2026.09.19.00.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:21:48 -0700 (PDT)
Date: Sat, 19 Sep 2026 15:21:41 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Ritesh Harjani <riteshh@linux.ibm.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Liam.Howlett@oracle.com
Subject: Re: [linux-next20260917] BUG: Bad page map in process
Message-ID: <b9d78e0b-c301-4910-9b3c-3cace29cced8@gmail.com>
References: <d0d04df2-8d69-4155-81b1-3d3ea2fca14e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d0d04df2-8d69-4155-81b1-3d3ea2fca14e@linux.ibm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8ADFF4000A
X-Stat-Signature: ztc6w89i939qrmxbx67f9hwnp1xuxbab
X-Rspam-User: 
X-HE-Tag: 1789802510-374519
X-HE-Meta: U2FsdGVkX1+RUksLQwx1/fyJ7wX79Cqxg758TMehUsUXDrNfccKs1F/HyukLrinMlW19Vt5aCzO3tz8AC26zgvqmstTPy+kGCmi734rl0938UoyUpfCgkUKXnA2/wkV+35rCQH3/vEoKH1Zifm5EiQ3QO8qn17zoAggFYqDqEjH0s+hKz/hvUpS/nLn9f5KUe0RMXHefY+wT8AlypW+vy8MC8gwEdv75po07rzu/zNV3pzz582Us+ezjzcMzAvUi70qoORTGnqlCyqdVFAAig7qGRJiSD9m0ToepSyUteJPHOUiA8dVmP7TsBFuNUjWphlEAhHkJsKm1N7BehF+bQwpuWecVNsufvdM0LdRwwFi9RISyIIohraYR0EEKmFDmGYF3/dQLsELBr9h2+A6FTGOUMYiyDzP68+7AKxdD0/fMqb0tv2UAZAKcQyuOtZPgzvpUmW0ZWn96CA0VfjYlsAWRGweeOedI4XYLJYn9IwS+91BC+wS5v9VLp9ytelnRA+lEAAj5OdbM59Ms3LeLJ94RjjLgzVVx7SoiShIX0RQnNrFYlIeMAF9t0YQPL/hxL50bGsXEunXmzVg6s9Z2FcD8pUsLZkRQNnCVon41dgFbIbj71QZAF2wP5ct/3/Z29G8ljwGxuUyAT1z29zZY8OmNo1yuGiU0B7k4jNvw46rKZPcz4PVG8mqLp2hORFYIENp2mbGHnzqKqH95KuChVK9byzYabTcfvF2zL9gpEbIzn3N7jaH+8RKX7qtpj8gzVba5DAMqVU1VDKCZoHYxhRlyPK+0LSNwsHy7Vpj26qzVNyq6B7wvMhRmaP74CNdv49Etgwxa+LLZsEJQuXLXomMvdchojyP7+Ln3mKXur7k/CYVzwJVfHONwZuAlMdygpxqLelk63aUqd6Y7XijAGxaBM76bbSq7EgnILmUghL4wGQZurjlEFclIc2t0NnB6vS9btlce8TTftTo2FVc
 stos4VYR
 5K7dNq4jEsB7Ls5+QoekqimU6YrXflShgy/odrmgn8GyLNReojcNZ4Ck41naXu1ab5YxrzDvxp4OTSP1IGWuQaM9Sq6MzIHgWsgAczfsX6KKubPn7hj2k/CFhTWV6Bu4lhOjMu2kDpwKBcnuPYZ1j3sXQPGHQuCaJMOdBGFxlC83Rwlpyg5V1LZ69sMWIR3Vinq25ONxLje9U2wld65ehRWHexOEV1ZIuknRTtmod8MKkqmGhQBdt5zJllzVhaVZ7NVKag9NLlcoN2RvjJ6Fn3STYeY59DOvvhCQeAeCtu8pZTfuyobJFCxxGyslsIQZ+FZdcqwq+5E9TWi3AqD1Aeh4D2dzPOZRB+KstMVRMZ9JNbMfWUh4K0geIubv+tCpPdqGWL3xAgj0FgfESNbPtDaqpx+bv09Z/Mtq/yPkC0U9BNGxfvo+7rkjVmSMyK+gOgJ731BFfy+klbOQW53z9iINS1il6t2qQosCj0iJaXv71qToSxHEcFQtb9HgFEmji/5ahfgv1WD+ONI8lKmKWmXEHYNOV3VbbBpD8vuA/NByMHbt2CFy3cUoL4nNnlcO2cq/v9HUwYlNEDWTEjegF28ngQbcN6oW91HzZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:38:29PM +0530, Venkat Rao Bagalkote wrote:
> Greetings!!!
>
> IBM CI has reported following boot warning on Power11 pseries machine
> running linux-next 7.3.0-rc3-next-20260917.
>
>
> Traces:
>
> [    4.944846] BUG: Bad page map in process rtas_errd pte:c00000001fff0786
> [    4.944850] pgd:8000000064e76009 p4d:8000000064e76009
> pud:8000000064013009 pmd:8000000064011009
> [    4.944858] addr:00003fffa9382000 vm_flags:080000fb
> anon_vma:0000000000000000 mapping:c0000000054443a0 index:1fff0
> [    4.944865] file:mem fault:0x0 mmap:0x0 mmap_prepare: mmap_mem_prepare
> read_folio:0x0
> [    4.944875] CPU: 17 UID: 0 PID: 773 Comm: rtas_errd Not tainted
> 7.3.0-rc3-next-20260917 #1 PREEMPT(lazy)
> [    4.944877] Hardware name: IBM,9080-HEX Power11 (architected) 0x820200
> 0xf000007 of:IBM,FW1110.01 (NH1110_069) hv:phyp pSeries
> [    4.944879] Call Trace:
> [    4.944879] [c00000001791b4e0] [c00000000135a92c]
> dump_stack_lvl+0x8c/0xf0 (unreliable)
> [    4.944885] [c00000001791b510] [c0000000006708c0]
> print_bad_page_map.part.0.constprop.0+0x18c/0x260
> [    4.944887] [c00000001791b5f0] [c000000000674fa4]
> vm_normal_page+0x140/0x17c
> [    4.944890] [c00000001791b630] [c00000000067648c]
> zap_present_ptes.constprop.0+0x9c/0x9ac
> [    4.944893] [c00000001791b700] [c000000000677038]
> zap_pte_range+0x29c/0x5f4
> [    4.944895] [c00000001791b840] [c000000000677500]
> zap_pmd_range.isra.0+0x170/0x310
> [    4.944898] [c00000001791b8d0] [c000000000677a00]
> __zap_vma_range+0x360/0x4cc
> [    4.944900] [c00000001791b980] [c0000000006780e0] unmap_vmas+0x98/0x1a0
> [    4.944903] [c00000001791ba10] [c0000000006b0f68] unmap_region+0x94/0x108
> [    4.944905] [c00000001791bad0] [c0000000006b1c7c]
> vms_complete_munmap_vmas+0x11c/0x2c8
> [    4.944907] [c00000001791bb60] [c0000000006b273c]
> do_vmi_align_munmap+0x1ac/0x1f8
> [    4.944909] [c00000001791bca0] [c0000000006b52c0] __vm_munmap+0xdc/0x1fc
> [    4.944911] [c00000001791bd60] [c00000000068b154] sys_munmap+0x28/0x3c
> [    4.944913] [c00000001791bd80] [c000000000032150]
> system_call_exception+0x190/0x4b0
> [    4.944916] [c00000001791be50] [c00000000000d05c]
> system_call_vectored_common+0x15c/0x2ec
> [    4.944919] ---- interrupt: 3000 at 0x3fffa9143754
> [    4.944920] NIP:  00003fffa9143754 LR: 00003fffa9143754 CTR:
> 0000000000000000
> [    4.944922] REGS: c00000001791be80 TRAP: 3000   Not tainted
> (7.3.0-rc3-next-20260917)
> [    4.944923] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE> 
> CR: 44002408  XER: 00000000
> [    4.944928] IRQMASK: 0
> [    4.944928] GPR00: 000000000000005b 00003fffc0a69a20 00003fffa9237d00
> 00003fffa9382000
> [    4.944928] GPR04: 0000000000001000 0000000000000002 0000000000000000
> 0000000000000001
> [    4.944928] GPR08: 000000000000001b 0000000000000000 0000000000000000
> 0000000000000000
> [    4.944928] GPR12: 0000000000000000 00003fffa937f860 0000000000000000
> 00003fffa9383550
> [    4.944928] GPR16: 0000000000000000 00003fffc0a69cd8 00003fffc0a69ca0
> 68746150706d7544
> [    4.944928] GPR20: 00003fffc0a69c10 0068746150706d75 636170614364656c
> 747365526f747541
> [    4.944928] GPR24: 000000013ad9e130 00003fffc0a6a0d8 6d726f6674616c50
> 00003fffa92f5ee0
> [    4.944928] GPR28: 00003fffa9382000 000000001fff0000 0000000000000009
> 0000000000100000
> [    4.944945] NIP [00003fffa9143754] 0x3fffa9143754
> [    4.944946] LR [00003fffa9143754] 0x3fffa9143754
> [    4.944947] ---- interrupt: 3000

Hi Venkat,

Thanks for reporting this bug. I also reproduced this phenomenon on my
local machine and found that Lorenzo[1] has already fixed the bug, and
Mike[2] also provided a detailed analysis.

[1] https://lore.kernel.org/linux-mm/aq06hcheI4OGi_3A@gremlin/
[2] https://lore.kernel.org/linux-mm/aquz9Z9JrK_H_E0g@kernel.org/

--
Cheers,
Vernon

