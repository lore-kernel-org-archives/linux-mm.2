Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70EE5D11195
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 20:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88FB6B0024; Wed, 26 Nov 2025 15:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60026B0026; Wed, 26 Nov 2025 15:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CF96B0027; Wed, 26 Nov 2025 15:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9FF96B0024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:42:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C19A160617
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:42:11 +0000 (UTC)
X-FDA: 84153930462.13.CBCC9BA
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 835CE40012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:42:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="o3Wo/gJc";
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764189729;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3LhDg+yUIEO9+/SIuMeJHAc2uhx3ggEtkG8ys37ptk=;
	b=v64atp6LOnL6r/MtsSNzdcR2sbG/MCWF/mf95dKe5KDJ3Ux5vIQWzFBG5PQWmxMCc6ebMU
	Hr4jxgxLLs0W8PQexwT5tnU3ukA5Vbsn/cwCOek/6NcD+BS72xL6yTcwzE8ujrEikJKFbo
	cArlXo2jDXE8kEUy/ymSsSLWBAyFumg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="o3Wo/gJc";
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764189729; a=rsa-sha256;
	cv=none;
	b=6Cz3nztWf4C9iSvm59nwFgSlc/NZa7ZSs526sf85qMMa3ndwIab0zF9NXaRGUFnkNtD89C
	0Pi4EybgmVT4FoosJUUKimvoLUt5h8zinpeHFPfNNf5dGwNb3A71UcyXdgGSpyQCsPwgmH
	5CjM7/PNRrtZRuA6RhBdbWOko9ij6A4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F3LhDg+yUIEO9+/SIuMeJHAc2uhx3ggEtkG8ys37ptk=; b=o3Wo/gJcdx6jF9yp+Moy+3zJBK
	4/xo3hGwpRQOjUuSnpVFd4+9RcmyDDSe6UMmetucmLae8BVJHjzLIu50qRgqYbk/odASxIUgSaAfn
	OZll8+aYjj1NWsWeY+RlkEcZ7SZ/UylVJW9S6ufdik3v9+fqhi1LOYdieImh4RVPP/pxDkPD633KB
	QFmjjdoW0GrmEG9tEjsTOgB0CoqhLB114KiR2psKlxll9g3YD462/AiRggY3TIECco1FGKJJaTLU8
	3V99sW3+lW6A28AxFj7hwSILErX3NPG2gXJopcYvlOTjOLtKShmxzpjPZ2/n6NgWW5TbZUWcR+T5p
	JvbpCgZw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vOMKw-00000002Jft-096S;
	Wed, 26 Nov 2025 20:42:02 +0000
Date: Wed, 26 Nov 2025 20:42:01 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: brauner@kernel.org, jack@suse.cz, linux@armlinux.org.uk,
	will@kernel.org, nico@fluxnic.net, akpm@linux-foundation.org,
	hch@lst.de, jack@suse.com, wozizhi@huaweicloud.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	lilinjie8@huawei.com, liaohua4@huawei.com,
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com
Subject: Re: [RFC PATCH] vfs: Fix might sleep in load_unaligned_zeropad()
 with rcu read lock held
Message-ID: <20251126204201.GF3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126101952.174467-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126101952.174467-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: 835CE40012
X-Rspamd-Server: rspam02
X-Stat-Signature: ez4q3xcrbp4y4gzox859ywawx3f61rqg
X-Rspam-User: 
X-HE-Tag: 1764189729-290372
X-HE-Meta: U2FsdGVkX18czhZDuOzr2W1R//sZ2FizVOTYSeRUtgmGLFwB0b7eH0yGMvCRzywAC4VFMykqr1VVCERV+jRu5a9IBhd2Pat8tb9aRX5ZpylDPtNOzmjDneczVO8yrbz7Z/okXp0IZhSSN7C+mXh7iHMjrsIpBZ1ig/kETWkx2dmivX9qNjUBHSOHdLJ/uSI0P41UgBs4hbBhjjRzSKkGgToL228fhuWdndedoIn4V7j3TfsuU/iOSspbztMF+h05pgF+e5KEFxS4a78/Uc4Ikx49OoRjtATisXpysjtrezMl2h3ailk03Apz9AFn6YjTAk8Md2wx1iq00rXLNT/G772H+N8VbJ31MTUPNrTY29s/Eq5IWNIwoRmT+kpMm+4T7hh7nI6ZXyGGIWAnhN74RYezcRxeO2tzsIL8/vsOwGIXKZkuLngD9ceCWCdcw8JiUZl4BT2DLIinDgknKKNl/ZP7oPFrFl8iliajuYf08Qx8yzNzUz/KVj+kBzfqR65lpXKbVMm4mgi7uC1/lsqfrsu0IBH1o1XfN1WaVRHpVy6AB0Nf+amKMgtlH9inTXMrMGPJmk9rYnv8PL836hwT8+6BdJoElf6WtNMzAykB3mgvJiIspGNItvCAZM1hIivUgkSPqHw+Dp0ORHtMtS7N8Y0tFsb1Teo5P7y6ntccFBNIJ85ok4UYyXXMu88Ej4Z6dQzsfxPdwysohw5pAjvGMU9p/JMUhH8a2dtIk36RuDtDABlxoac64m7U3bzC/5NphMbP21SnjTVzfPMLowTFZuGtGSl0IVTWVSvigoLeXs/ZRryhZSu27Z5lAma3WoVtIdVp1Fyu8RVKdt08SzYyoqYnYjnczCwzPDl7FjxizheGMnnjw1JDmwRfuCawMZjYuB/2iJP0nSpcgD87ALVUiVcQ30I1fKYjQllh7F95lBxzcLxEwiv4+dD/tg+wMipavT7yLL2d44ht6iNX770
 CBdBo6xb
 mq9RqGPvxVlm5u0ERZ0SEnSzdz1w0atxvYqiEaTg2vlbpsjHM6zIUFju5rM5sfttZDccHn5t1zWiKt2qe55I5Cm2LNp6cuJkc97EuHYy+iCimooMwmcmPXJAzKMbyJJxPnnCL3hbn1gyD2XUGJkTzAzisK6CM/kFSq0M9iMbbGWm5YC9MigbrKyAdrqCHD5FckdL/oxA3hCIjg6zjnkA8Xg6PoCCh1yU3bvoa6O1S9mjGggTbQsm6AgcE8eSWSdZWrQJk1ETTk0N/WiXDUsI3xmaI0hg4MBa2wsVi1ixce0LpVKJRB51i2RJWea1NSSTucNWCG25HdGQ1XRc608o+R4GlP3MMApsLqmTS/dTfrEQTcjwJPBTlbRzuR9Uhx8BPD4N9LtDj7PSGAV+gQ5stPFkC6GE9b+LMJSVbLFGNbiX1AviYMwfgKAIZoa/qH0wxvZ5HJjceNoyJVlxFu3O2wsiaFcen4krwWdTpTXIIFCQFX+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:19:52PM +0800, Xie Yuanbin wrote:

> On latest linux-next source, using arm32's multi_v7_defconfig, and
> setting CONFIG_PREEMPT=y, CONFIG_DEBUG_ATOMIC_SLEEP=y, CONFIG_KFENCE=y,
> CONFIG_ARM_PAN=n, then run the following testcase:
> ```c
> static void *thread(void *arg)
> {
> 	while (1) {
> 		void *p = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, -1, 0);
> 
> 		assert(p != (void *)-1);
> 		__asm__ volatile ("":"+r"(p)::"memory");
> 
> 		munmap(p, 4096);
> 	}
> }
> 
> int main()
> {
> 	pthread_t th;
> 	int ret;
> 	char path[4096] = "/tmp";
> 
> 	for (size_t i = 0; i < 2044; ++i) {
> 		strcat(path, "/x");
> 		ret = mkdir(path, 0755);
> 		assert(ret == 0 || errno == EEXIST);
> 	}
> 	strcat(path, "/xx");
> 
> 	assert(strlen(path) == 4095);
> 
> 	assert(pthread_create(&th, NULL, thread, NULL) == 0);
> 
> 	while (1) {
> 		FILE *fp = fopen(path, "wb+");
> 
> 		assert(fp);
> 		fclose(fp);
> 	}
> 	return 0;
> }
> ```
> The might sleep warning will be triggered immediately.

"Immediately" part is interesting - presumably KFENCE is playing silly
buggers with PTEs in there.

Anyway, the underlying bug is that fault in this scenario should not
even look at VMAs - it should get to fixup_exception() and be done
with that, with minimal overhead for all other cause of faults.

We have an unaligned 32bit fetch from kernel address, spanning the
page boundary, with the second page unmapped or unreadable.  Access
comes from kernel mode.  All we want is to fail the fault without
an oops, blocking, etc.

AFAICS, on arm32 looks for VMA at address > TASK_SIZE won't find
a damn thing anyway, so skipping these attempts and going to
bad_area looks safe enough, if we do that after all early cases...

