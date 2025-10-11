Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0635FCCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 22:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B1C8E000C; Sat, 11 Oct 2025 18:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C288E0002; Sat, 11 Oct 2025 18:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031448E000C; Sat, 11 Oct 2025 18:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8ED58E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:04:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99ECE13B9F6
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 22:04:12 +0000 (UTC)
X-FDA: 83987212344.09.856E2F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B76841C0013
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 22:04:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qSKUSl/e";
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760220251; a=rsa-sha256;
	cv=none;
	b=yH8V62CPZbhBTOPBfQVelOwtC1kxSahXwvQReGQVev2rEz6VBbPHzv2+1MXWr6M/6Z4yn8
	cAD9Qqk62fnwoM9UmATwGvmihQnFXilX8oHbu4ihimR9Vi+7iTAazdp5VdaIiPV0h6MhC0
	sGKaBTIeJiblMDbGg+2FfPg9GWy2yqI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="qSKUSl/e";
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760220251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sC57DeSdoulcbAA81+rCcFtw1hbEA+GeV9/vRAxQ8FE=;
	b=pNTQ18JubFtHxEINPR2hiYKuvREy/5aHDrvKiWtdc1tb5vc16TwsbwdXGUQaaxbmhgvEas
	IWiZVyjGA8oYBt5nThSHFgllFxg8CWk4Rh3g9VsmZsN8LTb76zt7O7JbXG93GIIG5r8kmi
	xftkQQOVBUMBR5Os17iD3NCHeKdnFSQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C49B43A82;
	Sat, 11 Oct 2025 22:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DEEC4CEF4;
	Sat, 11 Oct 2025 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760220249;
	bh=i7Jgr7fdDvNL25cRTpbIZFz0XW9pXyGITE2m+CfhP+E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qSKUSl/eTQ5ivoH4pFV14ujJlqK3eYh+4YOokcp1S7cm1Rp7lv43wi6ZYOWFbteLe
	 VrhxyCQkLIsQE0OC2h1dsVmZsWGddu8XTj6XEnn06IPYYXrb01tc7d966oKhkCMSzP
	 cFIoobUGLuElwOxs39Pe9rnX/3QG2bgtiHA4TC1E=
Date: Sat, 11 Oct 2025 15:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org,
 oe-kbuild-all@lists.linux.dev, chrisl@kernel.org, kasong@tencent.com,
 youngjun.park@lge.com, baohua@kernel.org, shikemeng@huaweicloud.com,
 nphamcs@gmail.com
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
Message-Id: <20251011150408.b865cffc3a8fb8bf834067f7@linux-foundation.org>
In-Reply-To: <202510120456.vTSygUXV-lkp@intel.com>
References: <20251011081624.224202-2-bhe@redhat.com>
	<202510120456.vTSygUXV-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: n4aoggp37x4todrg84jz9f3csets1wn4
X-Rspamd-Queue-Id: B76841C0013
X-Rspamd-Server: rspam09
X-HE-Tag: 1760220250-294239
X-HE-Meta: U2FsdGVkX1/CD51hcKMoEoj9YO65G0YLsELp0RuRQDAG6O9epn8Zyf/9DLs0Ag2/lTT2zR12WiRH8F5Zn2x5Qx18CTEtrzjQe3O95B25tQEypkWQmCu3ULzC63LHEhi7k3BPCiUWG3rIabKjKDSP2eB2CnPEGcs5vp1h6qWt5jhQkOEORJzH5/fjxtyUrj3Xl/AUUAqJl45F8I0wWmXOAiDgdl/5FumIAnRqLcjcYXJOca8e8TtluFjJhql/+On30n9y2cv9V5gveEfGwigc9QWA3i/kyrkJT4PueoUtWC24je7U1P+EXM9FEIc3lxyabLuV63gCzaRvqiHa42e/rKuYB6h5SqsWc9m2v/TCFLEE758ldCCwbXzJ9N3ZQ2QuEA/0XSevuOk+XHsKTRZLCAsRYSP+jtqvJwtv5ktMUZiC0zjWzWmcudhKhuFkWPftG7zN8w/RmNKi9/vwAPod6i2qBXlBj438XGZVra9ChgFGYaV7iDZbnU1LcXSUqEH7E1z1EAWHQZRiiV2E8HdCwl4gPb/F0lrN+5mqSUh4BOFEvOvEXHCivyGdgy26YmhrZsuEtTRk1pxZ5/fPureSfsAYy+T7LufG0ybtEs/0XUI2ZRS3Fkst9YChxHJBN7+SSz19Ouxwd2DTLPeSBDdb3AqkAyJpcc0D2EQWGxkjuowlYObrlWeXIWNLuSS0F52dB629ESewguLm7BehauMUPBtsoI+tYz2lvokcTAZoRONr2pajjurl86BHHvt0KWKDF9SjqGBiSEqgLeEjUJjlvJKm8VDC5Fy/0PPQsrVQ4HlkNtxB3e5JW0neyqEUQWPvBf8WHLS3+S+AEY9r7FirC5gTM94vAAKrS6uTzNPhlgV5d9pWYXkPY8XOVkyyLXhMLu+v3m/j5arQaeQNbWBCLbwRMNARlLVlLOts4vxOFpvQkOlpNM5s/c+DW/Ce03VhCGr3sffSs3qR6qV6mIS
 XwPItJYJ
 e0fg+38BJLaXsHhplf53QwqfnyTRJ2MYPKAQh7z4dZyYg+Saf8M/Uy9G9qhVmcUBpB60SCJAkYs/Mdn06a2ieKZBtdyELyfpLx0bvXv51wnuoZ/BL66lc/Ra4+Tb248wz0nrguUijwBe2h2qQcf9CvLEEsoftQwYhsHJGooooU7DaNrcKq4u4ZJj8YYEw0WyCl2FoKckCQFtUDXrwL5R+/ZytAT4nrByqkNS+BZBVoe3rHV5rENQ3mHQKM79sIep1YUtspGcjtxyxKgdIJCjrJ5EV0rMQhtnXlN+XRnc5kDq/lwb2MoBqyOMQSgx6s8VMTu/ffMOzmsyGuBOmf0zijNTF3BHhmIrp+qe9Dw3s/QthG9cv1kxWgY3JnFKz3p4M3NqaCRDhDfwxc3pgvMhz1FzMDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Oct 2025 04:45:07 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Baoquan,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Baoquan-He/mm-swap-do-not-choose-swap-device-according-to-numa-node/20251011-161743
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251011081624.224202-2-bhe%40redhat.com
> patch subject: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device according to numa node
> config: i386-buildonly-randconfig-003-20251012 (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251012/202510120456.vTSygUXV-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510120456.vTSygUXV-lkp@intel.com/
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from include/linux/list.h:5,
>                     from include/linux/wait.h:7,
>                     from include/linux/wait_bit.h:8,
>                     from include/linux/fs.h:7,
>                     from include/linux/highmem.h:5,
>                     from include/linux/bvec.h:10,
>                     from include/linux/blk_types.h:10,
>                     from include/linux/blkdev.h:9,
>                     from mm/swapfile.c:9:

Thanks.  I did this.  Baoquan, please review and retest?


--- a/mm/swapfile.c~mm-swap-do-not-choose-swap-device-according-to-numa-node-fix
+++ a/mm/swapfile.c
@@ -1388,11 +1388,10 @@ start_over:
 static bool swap_sync_discard(void)
 {
 	bool ret = false;
-	int nid = numa_node_id();
 	struct swap_info_struct *si, *next;
 
 	spin_lock(&swap_avail_lock);
-	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
 		spin_unlock(&swap_avail_lock);
 		if (get_swap_device_info(si)) {
 			if (si->flags & SWP_PAGE_DISCARD)
@@ -2890,7 +2889,6 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	del_from_avail_list(p, true);
 	if (p->prio < 0) {
 		struct swap_info_struct *si = p;
-		int nid;
 
 		plist_for_each_entry_continue(si, &swap_active_head, list) {
 			si->prio++;
_


