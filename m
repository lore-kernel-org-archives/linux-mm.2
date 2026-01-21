Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AA3C44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 21:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0F176B0095; Wed, 21 Jan 2026 16:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A926C6B0096; Wed, 21 Jan 2026 16:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C8AD6B0098; Wed, 21 Jan 2026 16:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1396B0095
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:04:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38A6EC4362
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:04:38 +0000 (UTC)
X-FDA: 84357199836.05.D57061C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71BC320016
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:04:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I5bRxiWn;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769029476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1PRO3Boh8Hc4xavhVa5kA8UgGTSMaI6DS11l0HSnwY=;
	b=UHj6RsiE6nNBCY1Tj5p32L718gha4wBud5Fdwnzow7uEmyUXrZIIzRnabb8q6wraBlRXjI
	UpIOW9AwcPUNvQb8mxrCrMlal8Qw3I06ui1TcTUFPanlOR51gO8XBO6bAL8DyRsVfoNWo1
	Ha9f/UtZ1zh4dfUNXwx5JnR9sXK6M0w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I5bRxiWn;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769029476; a=rsa-sha256;
	cv=none;
	b=ltU61QM0RMC8iLjAdpDfLw5RFsVd1lBX2Wq+gzf1uTD1wbs7TCPhXksonaB4rkNV+v9Njw
	A2pJMuG/LMP148CwaxSpKKJwg/iF4/Lghyx0QyfQoF6/rN93XPhDSU6kE7nCBLxeTL9Mos
	PONport8632o7pYZe+eQgG69Ovgds5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6272A43256;
	Wed, 21 Jan 2026 21:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121E7C4CEF1;
	Wed, 21 Jan 2026 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769029475;
	bh=XqPSo2qYJf+IM8qIZYWHCUSgyZyv4XBXXJSAz69WzIY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=I5bRxiWnPPbDS5UooeiebkHj2C9Wr0HfuLqxuj6LdfoYJvX+CylLeqozD04rrsY6X
	 ypWlsq35EnQN0dBjTTnh7hdi7DNMfpTdVAeZbghrQG6fhjdgD0dWmji/XQJnH8qR4y
	 Jtsuud/8lBn6YgFsccic5dGF6y09gN3NhWrjYXx8=
Date: Wed, 21 Jan 2026 13:04:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Andrey Konovalov <andreyknvl@gmail.com>
Subject: Re: [linux-next:master 7687/8302] ERROR: modpost:
 "vrealloc_node_align_noprof" [mm/kasan/kasan_test.ko] undefined!
Message-Id: <20260121130434.1ab5355bb6ef31feabf4c4f3@linux-foundation.org>
In-Reply-To: <8d5cea70-0e1d-4442-b761-e6589346d654@gmail.com>
References: <202601211250.6uQzZrQp-lkp@intel.com>
	<8d5cea70-0e1d-4442-b761-e6589346d654@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hjufpuk3hexippwne38tqzw4q9m5j3uy
X-Rspamd-Queue-Id: 71BC320016
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769029476-730324
X-HE-Meta: U2FsdGVkX18hEpiTmY2VZ1kDPSot0sopEfmEyLvXdmlte20b+1/8hE8sDi+9LFnEWG9y4GMvOTQZXkudiPkdMx1GvgNe5TimW8CZvPeQ5EEeuTWnaSjIHZwx0LKIJNvQX8wte+QvJ6fl5bxhnW1rIlN0qhg0Cnq+yYCsM4JTjvPOUyWK1SdEyc4njrkfQFDBA431xgdXIAXyjtdw/6QGUpjJzr3+YZh3qgSPDB0yLAR0uvltjU83NZIFZNf+Nj17S62EukO7gf7iyudYBo1vSxPBREDJhBOMP6VOfOHlFYMsY6ZGT9qCEGFkqCMx+9IOXdScULj/Pdq1SRN1UAqM4Psdb1LVir5fKqLbcvS7svXSf0KsKeDcErrDQVMXs2rsAEPHOpXrt3K6UHjSMsygM1hw+72RnBaiwtxoo/KLW4J1sw40hVjYKlHagCkxfjle6Ci4WNg/GUF8ZH5Q3zEjx14+So7UWxiF1U3mcI7V/wf4k3C76ffg3i6XLbXIjtdzq56ccPZMcHlP1MT2iGFG0ot7HcZ1rlg40Mi47iCHj12+/GWX4XZSlokaMisKvKHpb2Pm2+X0EnPmAynfXd21lk+oAH1hErg2LE5Z+CkTn4nHXaCm61r13OJQTQ24Yy+zpYfp56931fZ4t1+Jtt4zrV0o52NQdvPj81CxD4Vn6WmS6jPB1ARNGj4dwtaZKWJGLLJlgWf0iLMzyuANvQcYyR/K5fkP9Lcs9b2Yzqy05I82fJ7b2R0H7BAr+JlXUKrTCCJy/BAxVaO8W/oujvqzFH15n+g7JBJjYaWIHtnZ3PCtVsSv4odQR2oCs7SrZUll1qWBbSki6hACwnKzZyDnrKhbS8WOdeJVTBQjZf34J2JeuLlDYLvPMr0LIfHGq9g34kKbKOOqFwOcJqrD83j0e2demveRqsxC5+1+LVmR6iFjeUVo14fJN6VXvzsRN+WYbunD5Fdtjlxq+yiwJtG
 xXAID/6T
 9TPtTEUZe59X8G03KrfT9bwuOX4tSclReAtppvGfMRgDjUB0bB4fjeEiHR6vaO3a4l9kUMrx68lfr/4bWf6iO5AjaGTeatglPdlmXNf2DvEkMCPWfRTE7xJ/YsWZdbGhPtNpOm63NIzPJ/VTdqXE0PRKoqo6csUNvmC0EWkW/cxr155YZBlCWUppJJaLUV6UXUUG4lxjYZyHP2PNoqOFik+Alzwg97VFDunpvvDiKhCTwIYZ3bK721psj1grt9SDpH093py4ai/IWtOq9zqUEFwn7y/WiyjAYiZ2ZU4hH8oWCfxciCPXa4qPwVFuKmlkCbUj0o2UmPcWpt03+9r6sDStaO1TLzwFWZUqCm/r23r71OiiuhPbHquWkql6/+08QYNbpDg4EetZazfyhKLGMhZzTtqBggNM5GnAZdtN6KlvD8M3c537S9pXIEmWLDCYcRUe+nzkSnZqi4fmBhsDzKr1NY8VcBmByNGbMmuGnkvH/mTI28s/h4q15eIITyT92qNdSLYol+FDPlP5ZvvMf8rmOMADXG13/lLVIhIz/66nr4Wg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 18:04:36 +0100 Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:

> 
> On 1/21/26 5:57 AM, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   053966c344dbd346e71305f530e91ea77916189f
> > commit: 22228c860d2633a22656cc506022c657fec15194 [7687/8302] mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
> > config: x86_64-randconfig-121-20260120 (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/config)
> > compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> > rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601211250.6uQzZrQp-lkp@intel.com/
> > 
> > Note: the linux-next/master HEAD 053966c344dbd346e71305f530e91ea77916189f builds fine.
> >       It may have been fixed somewhere.
> > 
> 
> Yep, this has been fixed independently by https://lkml.kernel.org/r/20260107-export-vrealloc_node_align_noprof-v1-1-a581bec13054@google.com
> It would be nice to reorder the patches so that the fix is applied before the kunit patch.

No probs, I reordered the application order:

: vmalloc-export-vrealloc_node_align_noprof.patch
: #
: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc.patch
: mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix.patch

(from https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series)
(not pushed out yet)

