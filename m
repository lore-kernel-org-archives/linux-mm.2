Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C309C98338
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 20:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1120F6B008A; Sun, 27 Sep 2026 16:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2876B008C; Sun, 27 Sep 2026 16:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBEE6B0092; Sun, 27 Sep 2026 16:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C890A6B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:31:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F4D640A71
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:31:03 +0000 (UTC)
X-FDA: 85260686406.17.0163B2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 936D6C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 20:31:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bZCFoArE;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790541061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eO1GbP2uuZa4hrp2kTCOpYiuFc7Q8kusK/y74limaec=;
	b=1orj6w+QytFQTx2OwG2XIodYpj61zqdGRkBsu7nzQgyoFoMl95nMuhWPlOY0/0b5mEz0mF
	ipchExVcjb2wKOd6as8RsgIgga25IJM/4uu+NbU6OWcr2DqVYDO3my6viMYhDZh+wO8dPe
	HuO+FcJmOGyfkwLR1E8Y0u/0923NE9s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bZCFoArE;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790541061;
	b=teLkN+mk/Wud7ifAF3dHTXCUregYth6d4vkzNuOvMLb+YXzksbzxnZuIPZDkFyvCjnpBqV
	jsRmaTZ4yACT2Uvii9VVBuSncRdFDj4bwZQ4V6GCQpaAu5xKEATLRQr69DdIP4bujcyUPX
	T9BhwsNylHWVVDIqAszjjyI0801uUWo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05B7460052;
	Sun, 27 Sep 2026 20:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B591F000FF;
	Sun, 27 Sep 2026 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790541060;
	bh=eO1GbP2uuZa4hrp2kTCOpYiuFc7Q8kusK/y74limaec=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bZCFoArExGIZS0u/zlqwhpNYP3EhjQ6VjHC3TDViHMWIi14nyx1LJjiqOzHBWx+/f
	 kkKiUa9YyEqhCSs+ddVuXJpQLrknpYA5av9fRlCWCjHW4ecvys5Zl2f8S8OM46Ji2m
	 MkmUEqR6W5oGGtF8GihVH2w+zfJh7emXltzcHys8=
Date: Sun, 27 Sep 2026 13:31:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
Message-Id: <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
In-Reply-To: <202609270030.Y0QVBPmK-lkp@intel.com>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3oqr5gqgaujhy3gywrtwg83m3yru8ad7
X-Rspamd-Queue-Id: 936D6C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790541061-968743
X-HE-Meta: U2FsdGVkX1+bLbFMAqysmsEJ6jZYfs5NktTpxc6euX3VmO9SyHZvSzk1yMg1chk4jGSYc14DfCPcv2OU5NRX4aleNN7m1dNePltLncPGD0YS/fLHdzMhNrzZQjf0i7b8LrvE4ModzWJXn1FGZzbqTcu3+mu9W4SdzJuRBk+Y3Hk2/khSIIFiO0/o80vGp3fJ1Quk7Ya6DMbPVtEf0piZ0i82aNn1uPik6wga7sQ3PGN63hFeVqqwNmXql0IxY/+xvJQ34h17iHzgMKicyuqkkHa+E6/rqSjfWaLjfvGUDcfm7Lt0PiCMETYUi4QhKcdxmxueIr9qRpePdntOcLl5+qFrxJWd9WAhvxYO0y1eYUel7eOcbGqE7Hes6lESU0oCZvSbiL/7I9uq69RVzYT8a4SSmQ7OQ8swyzPgvVdUig698PLBY95BgyaJZal1B220XiMmkPOOaF0WSIdoCC3hsRa5Ct7F8P7BhRZl36AfbNY4cWIDp/0WhWLS0XZ5GBsGnxykFUwxy+5xwGSdql4u5E1xOfogAELKKB/4GbG2Bofn9Gc7caNeltH29U3tce/fZa5zwEdwBZ+1kOzl4NN1EcFYuSAiwSzjE3Gh38KvUpS7F2ioxEz+EybtNpH5MqErF0cqcgFgMOEvGM+wIp/lY4axgZaylhy0dcVKMyydJATVPLjymlo2Sniqc3bmilOrA/FhGE4N7kp99Xn5JMguaA5XMxJYnHl8Xyr8qffJKxQYCP/U/5ktNXUdqufA9w1Is8n3+5bMbKstlHTj4/z2M4CfD1V9O8tedJsI6TfqEpfzGnSNOuaI6SNiFcoLI+fP1nwaJS5I9hoUWJIA6IIYD+pmUnktWSfda+Ch3einT6UlxvznOG20yxeqGu/M5oPx2vIa1LWOcUQ5B5CgOdtSjbK1E4fCGd/WHv8v+3VkNVjJX/fGW4arCaU+x6aPgBLhhmS02TKsJ4eSl5X49NO
 +TevNXK3
 3tG+1kDK1xn7YZElapDnSM11+73xj/g5+1QgruaVd/kGe3k1cJFbm3aZ3gQ5NVbCGOMAXPW1GKno6v4KySHuvdRqCzypPFGshAdokUMItMdTEFi0EnTzRwB6NGl0qUs6cU+tcLbxy0awJeW/IjipCUIHlLG7IEhiAEkx8S6jGuNTNtBo8I9K76/6HKbW7joPKfimhKTWb/peRBgbpxtf6fv2OBwMQMiEZMtkMoGMF+1WnWwG8iVKGGoYBsKuB/w/Ml2WGeo8O/t97lqHJPV3qwcM4B0VYdif7oyN+twHjp/lp6DWbuO7bL5byv2Xnct0C/59ueQrpNHXEhxZULtDxLToASQ0ace+MLecHRu6SChPTCJkNPAwprhnUSzia52n2F9N7X4nGJ+aMtNTSA/YV1CC8eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   b4fc90c82982d98959af08b4320420bcfc01303b
> commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
> config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 8.5.0

Thanks.  It works for me, but I'm using gcc-15.2.0.

> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> >> aarch64-linux-ld: Unexpected run-time procedure linkages detected!
>    aarch64-linux-ld: arch/arm64/mm/mmu.o: in function `__set_ptes_anysz.isra.40.constprop.47':
> >> mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: arch/arm64/mm/hugetlbpage.o: in function `__set_ptes_anysz.isra.32':
> >> hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: kernel/bpf/arena.o: in function `apply_range_set_cb':
> >> arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/gup.o: in function `follow_page_pte':
> >> gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/memory.o: in function `__set_ptes.isra.207':
> >> memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_update'
>    aarch64-linux-ld: mm/mprotect.o:mprotect.c:(.text+0x1080): more undefined references to `__check_safe_pte_update' follow
> 


