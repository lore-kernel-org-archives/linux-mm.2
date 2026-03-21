Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B1701099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766186B00A4; Fri, 20 Mar 2026 22:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DCC6B00B1; Fri, 20 Mar 2026 22:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A7A6B00B2; Fri, 20 Mar 2026 22:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53DC76B00A4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:50:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00A031603A3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:50:21 +0000 (UTC)
X-FDA: 84568541484.17.3E97213
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4BF2F40006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:50:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EgMGfG2y;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774061420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPLwRt8GW3Tx1uEsb+LJSZ/pWELbr+azIztyTt5/YPU=;
	b=zGe8KuvxbcdoTLCSyKowXBYBDy5jixIxIUwKjcPb5Yhq3NmG5QCZW0aomUuFnYZS+Uk0Vq
	w5sOCelQILNxo7PCrWLYKz29DcH5ucLKnePoa3SNOl54lDDOuWlYX+PZTG0sDfWMdGTH/K
	62sdohsth8rJb3KTonU6L66vaqfX/UI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EgMGfG2y;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774061420; a=rsa-sha256;
	cv=none;
	b=16KR6QWgnzQwtclMgvj6xx0SvsZI+AC8S1GDKJ+XW0FlSUSlkY3Z941VkYxfhd5wQUQSVE
	Frmw/kj+XZ3W386g8cUXLMO6GGDtP5maiUIh4GnrdHI+/z4zPEj6kaXQuasDhEDEqCUXr4
	2QFryV+aeV78voMARncJ4kEDCtKlRio=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93D5860130;
	Sat, 21 Mar 2026 02:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062ABC4CEF7;
	Sat, 21 Mar 2026 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774061419;
	bh=O+OkwXd8UL3ecSwMqbmLNFLX9edjRPGHm4/MrzxvS/0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EgMGfG2yQqnlQGWlnDkxYCT8xwSC7Pm4D+yV5NBIjHvi81+xIme3Igu7ACd2BSgH6
	 NviQmnBfMlw3Tpyce5eKOGOocRTtXh0jNX004ryMhul7CcOIhS98h1fqExNjPEmjO+
	 Qk89cNsiIuEFJLo/2AaqqRSQ+ojksdf6ccwl/l0s=
Date: Fri, 20 Mar 2026 19:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
 <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
 <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
Subject: Re: [PATCH v2] mm/hugetlb: fix memory offline failure due to
 hwpoisoned file hugetlb
Message-Id: <20260320195018.57ca65463029852cfea4ddb5@linux-foundation.org>
In-Reply-To: <20260321021031.2240780-1-tujinjiang@huawei.com>
References: <20260321021031.2240780-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i1tdksj9hdcqi6aiq5o91sr671bywzpx
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BF2F40006
X-HE-Tag: 1774061420-365515
X-HE-Meta: U2FsdGVkX1+gzgE5/uCIkeTwiR+XZhEl2FykWZXGAz3cmfVrfGx6CXvX9EKstilrv37N2gMXL0uh4W6M2Hq6ygnCUH2nhkm1uj9DMtUIT9kmVuihjtszzGlSIvi3V8h+zzeAEBHpYmjQt2A8Kz7iil8lADYuGZoDpDmdZkdavD/eRMR0FBRJ2x+i/WP8XPHQXP55/3B7kpMSMipmjjbHVFit79bXzgBsUWAE5B5n6Jfoic6MD/m3ga/bjOfTAserGsIzmaivLdX65jWFW41S0s+86MrMKb3nNcXAZlOO95fwOel0wsh9EeAsZD9yvWwwXEgDGhjn1gr1eE9TXmB128OF3ajs5IV5qADktyH9mz6y3KtDrCixbtfWixQvSfGAJdY3x2YxpjcmZDjTPlFiH19UIlq9MreLwKcXgvelXL0CeVkb3a49EBZoFhT5vh67zF4CBsfwES6F5XAu3D1DEf3nO4ojXyog7adErTDrZYDzdo07tsdaG9b1qth1qTmAVGtZN6bMZxzTo5Bk0R4vhJ//ya+OTKMZlmMAZh4OVAHc+o6fSiqkyKmR23pc7FMDTE/DtNtOdUxV2oNZiDo3ISMlSOYq823ac58ThyFrib3CLccg/gLIpUr+YLhL7RA1A8q074A+vaJ9JNeQYnoqDWwxroaARskOrbOWUtDvo6XA5aaurrV09REiRU95FkGZjwRcIf/bMYuYqtmgYKQUBBBf0HAdIz8pvqbbN6LHJXIaMwlr5K4Qviw1FR6t2Ue286gdePEWhSlQHANBnWPSA7ehrUGG3i8YxqsgFRJ6bHIk/Ie/Rkr/fbt6ORKN+EG7wZYAQklPJEVtzSpzq7CWv5M9fxAD0m6Qxz9ETjXyK2lULiO59eqN8X9rtmC9wz6sCkJ2aY8zlcsPH2fjXtFhB9wty5OoWo/P4S52T01urITfFN9JXGWl+xRdXOA8NfDzlyVVxzNlrimbUk3XSZI
 2h0gFzDm
 TY3dit0XJZbV1c9QNFLlwj5SnFF24PT0vJvVTRcjwIngEGgmc4yvJH1w9kKzwp2YTEfZSO0XNstZOkD+YLhcMIkZ7bxfEBUIGgy/4ReBjsFTt5mmtXgYX0jY2YGekIyAL2h90GdD5aXywqqxFzSybp+I2mJWC7RUSbNGe/Hdt2AiHvGYrXkp78gTWMRqxJdjCnH7gT2errJkhjN6ehkYoy9qKFDkdn6IqyKiqPmFmBQM5igpAUM7vPCF1VCgS5HG6JKKWgMKmKnVGlURukxaZH20gyXhWjxS3zEQLgva+UL1oItS7aXLBuYZpn+jQ4ESTJagpCGgIIA/cW+tUkqYAI1WmI6WJCVwv4NorewMWJw8E7EBcCY1BNYw+gTcDl6Ajgdd/4u5ERfnGHna6Q6AqOkaOwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 10:10:31 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
> after the hugetlb file is deleted, the hugetlb folio is still leaked.
> 
> If we want to offline the memory block that the hwpoisoned hugetlb folio
> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
> hwpoisoned hugetlb folio isn't free.
> 
> I can reproduce this issue with the following steps in qemu:
>  1) echo offline >/sys/devices/system/memory/auto_online_blocks
>  2) in qemu monitor:
>        object_add memory-backend-ram,id=mem10,size=1G
>        device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>  3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>  4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>  5) run ./hugetlb_file. This process will receive SIGBUS.
>  6) remove the hugetlbfs file.
>  7) echo offline > /sys/devices/system/node/node2/memory136/state
> 
> hugetlb_file.c:
>   fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>   fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>   addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>   memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>   madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
> 
> To fix it, force to put ref of hwpoisoned hugetlb in memory offline, the
> hwpoisoned hugetlb will be freed and succeeds to be dissolved. We couldn't
> avoid races here, just like commit b023f46813cd ("memory-hotplug: skip
> HWPoisoned page when offlining pages"), which force to skip hwpoisoned
> page regardless of refcount.
> 

It would be nice to know what changed since v1 and why, although the
patch is super-tiny so I guess that doesn't matter much.

AI review has a question regarding the v1 patch:
	https://sashiko.dev/#/patchset/20260318020711.3596947-1-tujinjiang@huawei.com

