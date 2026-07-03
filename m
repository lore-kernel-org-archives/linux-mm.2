Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612E1C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 15:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338F06B00D0; Fri,  3 Jul 2026 11:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C65C6B00D6; Fri,  3 Jul 2026 11:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1DB6B00D7; Fri,  3 Jul 2026 11:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3DA26B00D0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:24:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A81A4017D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:24:19 +0000 (UTC)
X-FDA: 84947836638.17.34CC527
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id C0FCE40002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 15:24:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q8Aih6AY;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783092257;
	b=2qRRqP+AX22in2QiUYbffKdIg1KmW25QWqcfX5k27KVGo6hmrbSvOHRb9RIlOjk4gcwEHk
	zsHG2EcnDIvyKsW12z0q98FxLhtHNS3Ff9DGvgS7sD9JILxGI00AvIVg0H5nZmHC8qsHvT
	7QFSEX9DjTplnL0AZBuoOdSh8gD1VmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783092257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2osf34xTIrbXNjSX6meB3wb3DJ/HNiHPpxtcmn5q1zA=;
	b=pYikl3lq1DkTU8hi5NlZC46bW53lGLCJLaXIal9+v2mHLXEX8n8w1x6rPmpb5M62OZxc9w
	EAQ+YEpe/rxmLa48NeRA2hy8nD8CU1tQxIhSUOCilEp8qxO2PpZhQ/X/sVDamv9O5XNbrc
	sSETZ1BHKWS1Lik1memYRWzUEAd/2wU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q8Aih6AY;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2osf34xTIrbXNjSX6meB3wb3DJ/HNiHPpxtcmn5q1zA=; b=Q8Aih6AY6Sz7z7RVwjGmox87mH
	Ng2rRHQG/prv6AL4r1pPZRXJ+psCD8/2zyIbZfZOWLGJCvJAKrfc9PsKMyMDlQz41IBeYlxAR2ML8
	2P9XOssci1hpi3HIyQAGf6J/heJOrBLK1ZUwVVkd4Jpibt/b9oPffpgpKkIwsuqIhJ0OmDj/DgWe5
	h2VsnJBHk6SVjKc1KB98wc/nMu0r/SqgiNyzNf62+Y3S3RhgRBDAdyftwHwD6wafSIpy6VCOAzUwx
	yWmQjpLS65yEVv8yTPdqwbs9tivltqsttkzdHoNhtMuPUQTjEP/QQoJOJQ2ACKZxnLdE8awc98oAg
	2a+yQoyg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wffkH-009Ue3-1p;
	Fri, 03 Jul 2026 15:24:02 +0000
Date: Fri, 3 Jul 2026 08:23:57 -0700
From: Breno Leitao <leitao@debian.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 242/252] radix-tree.c:459:17: error: implicit
 declaration of function 'kmemleak_transient_leak'
Message-ID: <akfT1s9f-3HgxGlD@gmail.com>
References: <202607031019.AffpLUyg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607031019.AffpLUyg-lkp@intel.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0FCE40002
X-Stat-Signature: gy5azshttifsuhn153grgyd961ojk5ya
X-Rspam-User: 
X-HE-Tag: 1783092257-236235
X-HE-Meta: U2FsdGVkX1/shxmLpTSUlkaPh3NeC12fUZ1KedGH7R45RyLVd9+k4n3fgp9iUDISr28s/HLKp9puPTLqOTaIfA9KU0opDx/6/XXt+9967gnhgB+AUw7OdvjO3POQ2O1znkm2jySqwv4teO0MyOUyOw1+4dSZVgNcLhsmclpiRiqz9BR5QHDW08CiTibE9wB/cpiO+mltGhpdUHsrAfLINHGXdg7pARpUYpf+JH70amquLvzvpJ+4mfTedg9GoYKefaK5D7YGMKc/jkaKTzkaJBJTgrWr0D3keMAhxn54sQMhXPcUko/HDihdjkL7Y6M41zZkL99NnVBDwIfel8YRz/QasxyHr6D/Ss1WDjo712T0Q0/qrwzyM8BffgAD8fpb05dz3K8Wb8Vz3yFBLITqCL7y3LqYesL9QUyjtMEsoyJtpDb4RuW/OEH/VNGenpFkoCaCNA1nZ762sdAzoRact9vKTQ1TDRsCGj91qYlZwd7VQKEKLi3tzxaYNzSMu9sYhm0DItVJc9cMHOmBLxhs7I46fEDor6vDgqxc0MHU4GQ5kgRCj67w0lgcyTX9LoFW9zAWS/i662rOL5+tPojrLbrzkEyU6dvbrjWLfxQKl+2ybB+kEwAHDzPihYQy5VO5YLwTSY6OirRM+tjTPS094BIUqz1YWFms4BNgn2g3jNp9jIcnhmUh2MLNFlVGlLwkArDP/NdoejPvSmm5I7U9+luLTjrXCAixAKEptS5Pr3BOwgRqmxBYDAGtTANaZM04PSZ/j9CJI2y4ThM8vCZiqKFJzaHk0Kl06RSwkV2iugAVzQKO1DgqiTlPpr1vjKP/p+DrZBoJayH6tUnp/8sP77BDrkr/VX1B1TD+bZZ/G/Rrm7lZ68L/mGMRRDL9/Fuai+GjRITvPZWK15Gr1Ker9BiTz8Rd5TGArfX+EW+Rp7wi88+AISKU2E0CaZGhsQ5G8Wm9IlemsQ7YVFfrnmA
 HCE66h3d
 L3EaEkLrQjSLzaXD5Eh9P1Ew9FOcvMpV2zX0K0jOmPYmwHXiPEQlZJzazFiGx3zY8gPs5mjw7uVodWb//0hxYo/+/ifLoA8H85SbJ7ItgdIk0hIoS7DMeP3SUOO+oC7JOhQY8GD1m9UFW3JhHXVC0GgHuTclwaixY+qOSv4sjv+MWgXHy9gL5Tyu5srvFA7vbKSWAlyEOfl3d8+D4KiGHwMgu6IydXwdshNlyNhxGlKFCNZ+g1CWhwlGimWTYewBoE92IMo+xJqV8NFGSuvgr9vLtnNNdM+BQr67G+jNcL5K6AWJiC54jLh7lAV/io1QAOrC7VB8U+D5tzPewi/m3dkHJ3RLz6eF51Uai+sBa5vM058eETROM8ZcI/Z/M83EfN2pkuJWCCdUQiJie8LD8qqVAHCUjKVZL/06nmAHDleqPbKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:30:59AM +0200, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e031e55776cf9193b4720a253e92539ca536d224
> commit: 58b5601b28c144be1905eef7964bfa8457f58292 [242/252] radix-tree: fix kmemleak false positives on tree head reassignment
> config: powerpc64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/config)
> compiler: powerpc64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260703/202607031019.AffpLUyg-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607031019.AffpLUyg-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    radix-tree.c: In function 'radix_tree_extend':
> >> radix-tree.c:459:17: error: implicit declaration of function 'kmemleak_transient_leak' [-Wimplicit-function-declaration]
>      459 |                 kmemleak_transient_leak(node);
>          |                 ^~~~~~~~~~~~~~~~~~~~~~~

Ack. This seems to be used by userspace tool that compile radix-tree in 
userspace, and it doesn't understand kmemleak_transient_leak().

V2 should have a fix for this:

https://lore.kernel.org/all/20260703-radix-tree-v2-1-38bb6efb5f6e@debian.org/

