Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE9C5E6B26C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2499E6B0088; Mon, 22 Dec 2025 20:15:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F7C36B0089; Mon, 22 Dec 2025 20:15:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7C86B008A; Mon, 22 Dec 2025 20:15:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED3B26B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:15:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F78E160420
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:15:16 +0000 (UTC)
X-FDA: 84248967432.03.F5DA943
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA72540002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:15:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WEYZtYIU;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766452515; a=rsa-sha256;
	cv=none;
	b=s41xZw6Zgp44ccwqYty3d4TZ+8a1MIm7pKc8cG4pZaY2N383dP4Tku00Eu+kb2dqJcczFX
	sF4kJ8/opqghZLsu+ATpsoRI7OEPNV3yZqyDMm7hVQXkeYuujZmlePlqa4ylZBs5wFcdnu
	CbbK1bcRojXNpzBfOgXRQUFmTsc3qYY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WEYZtYIU;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766452515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dlSRudGxdQdwaR7goWiS6gUCttwissPHK+pbwSe9nU=;
	b=DVqGdsBKwHEdWKwnELujURZYT7C7hCJGgNw14/cJIo6BzLB4HGdD2w28po/7zOz8KhOwYZ
	k+83wV092BVt6U/5j1AyzWTq9mDJdcEhx8vxGkswe+F/XcUCdehtOWfMtqUc7X+UFTs+i2
	uC0ByE7z8i1CJMEJJWjan/7tu3DdsX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7004042B81;
	Tue, 23 Dec 2025 01:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCE0C4CEF1;
	Tue, 23 Dec 2025 01:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766452513;
	bh=MFQWiEhzxXAD6Iigv+jk1Ze/A2AiReFlrbJXNt/mZxE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WEYZtYIUGsoIkaVTqDPKbWrAK9lstxF2JzJqxaCr8Xihvl4mgDHxpPep9VRR2oBHP
	 cLdiOgPax8aSFLcLjYi2a/Os+MVPqUm7MZLsVr8UXg4+RJSTc4xh0Pvt1H8vyF2lyC
	 mxn9Qh+DvlcI2wn/cz/aqw9dEpYN7/1eajSPrdCQ=
Date: Mon, 22 Dec 2025 17:15:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: baolu.lu@linux.intel.com, david@redhat.com, rppt@kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix huge page table not free after memory unplug
Message-Id: <20251222171512.edfb1e839e3f007d89825363@linux-foundation.org>
In-Reply-To: <20251222041117.44865-1-yuan1.liu@intel.com>
References: <20251222041117.44865-1-yuan1.liu@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CA72540002
X-Rspamd-Server: rspam10
X-Stat-Signature: m5kfsyg4pty1gmn35psjr4tmgue933b5
X-HE-Tag: 1766452514-92826
X-HE-Meta: U2FsdGVkX1+QJDnDwJSE3CDWkMTUvfgTNIRY4XUUpEUvvlvjvx8S4NV5b22nVq3IdxM1uouc8284IgfXfF1QUsD+8Pf3wpRdU++7KB0j/EXP4DECSvkko0QvIsHUPIlQqzTZYDdEBKTviU6J5JoxTKZBqSkWR3IitDUO6qyYL5stV5yuhfzVT44HDsknlmEVzFqfjnnPJabvAv7omVl1c8mvX+OgZG/Eo/7KZNTNfpQfnSdawcqWaeVFpCt7ISR9auA6QUOndVZtGbNgMT9QJd339cfdzjLs+fxCx+zkdYWrM1jKAcR7pyyWPbXNiFrode8IEmA7mm/fV9+4TqWKcvnegkB5HbWHqA0+qEiAGYDhRKisfwED33VfywzjEd6Ti646Rx1Gat/upGwWWjRSdQ++faU0XdKiDF1tK1caQX2AIZWmjg89HbpFTTarxHwwbNL08vl0sEwWSWp6u6JJDZ0N4gywJaAGZDmBbe05s8dJMsVEslMsCXHUBysZ8Ryf/ZxuQd6KKGUdEVppYtRDgDYcblavPTawK4IRi1/USkh2xB76db1kAtcz5RbDdf+FR8LednK6y8QoG4uDkU0tQu+37T/yS4KQCBmr6W3zZP6wzs/gWZ9R5Wd7J2ERiMSoUlC79xqTbIhM1hKn9xCwdk1RvucWuk1R0stGwgSDNWuK8Vwk8pjSr3a4RXAjX/CQUWfUuZ6SjIdX/ch0hMFKw4/MPgZhum45hdHaCMoVLnmkFcAQg0Yf+iP+4Dzaue2XRa9AzJUpcbVHAenLMfk/t2Bj0C5FamMKFcuJyPdzwSZRqr7+64zDwX2IdmE7n3V9Pz+3U/tGNAlze5mY2bAKwOPKQzvF2FQi7bVWkz1RM6tPRZgHVarsXAnD23pkHuIE+RzUHcWpr7gR80l1mLy6fZSAsS85RQvB0I8re+jJMyIIw8i8F7zPUtuTl7IknkPMUuiW7gfda3QqQOPTM9K
 lgCYdkeX
 kSRsHTglYp9VSiPP3ar7eHl+OFIc2ezGXGi10NR++9oJzp5mMgSx4ClOiH0lZecs45C31Galw7K+oZPo9PfPw8ykxEX1H6qZnIMTK9KQg5cgFxTgNCUVx5jNHKHgMYphhSFm90PXzXotzuRjAgBzpsdIBko+Sm37oavDW6g6ljJ14bSzU2hxdeFHiKPKy3M3k7z0EgfHJdpZ9FPjIIOPHd+uprvkgZF9b16FWexL/sANWZLh8opn2Ar47+cyVm2OB0h57J0QPRmy5KlA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 21 Dec 2025 23:11:17 -0500 Yuan Liu <yuan1.liu@intel.com> wrote:

> newly plugged memory is marked as prot_sethuge via phys_pmd_init
> without setting PG_head. During memory unplug, free_hugepage_table
> frees the page table as 2M, but pagetable_free handles it as 4K.
> 
> The following test case of memory unplug for a VM [1], tested in
> the environment [2], show that results.
> 
> +-----------------------+------+------+
> |Check System Memory    |Plug  |Unplug|
> |via free -h            |256GB |256GB |
> +-----------------------+------+------+
> | Free 4K page table    |257GB |5.6GB |
> +-----------------------+------+------+
> | Free 2M page table    |257GB |1.7GB |
> +-----------------------+------+------+
> 
> [1] Qemu commands to unhotplug 256G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v6.19-rc1
>     Qemu         : v9.0.0
> 
> Launch VM:
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>    Guest kernel auto-onlines newly added memory blocks:
>    echo online > /sys/devices/system/memory/auto_online_blocks
> 
> ...
>
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  		free_reserved_pages(page, nr_pages);
>  #endif
>  	} else {
> -		pagetable_free(page_ptdesc(page));
> +		__free_pages(page, order);
>  	}
>  }

This reverts half of bf9e4e30f353 ("x86/mm: use pagetable_free()").

What about the other half?  The below change that patch made to
arch/x86/mm/pat/set_memory.c - is that OK?

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }


