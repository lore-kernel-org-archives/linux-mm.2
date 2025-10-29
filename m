Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D4FCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1AA8E010D; Wed, 29 Oct 2025 18:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C9D48E0106; Wed, 29 Oct 2025 18:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF958E010D; Wed, 29 Oct 2025 18:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6804C8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:08:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E8C25B8FA
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:08:13 +0000 (UTC)
X-FDA: 84052540866.07.8928F2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 350E520007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:08:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lhbf5xPG;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761775691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExTQZGDiDmJbpXrA+01Zvu38e8DCkOuUbSd3zuP3MfA=;
	b=ieV8E17nDL7AoFtkLxXgUU/2XaL/KxE9OFdubk91/ohvGIT1mBLZReqwzguPjuRdfJ/dw8
	eAIRFB3uH266g9MTs9ugLDiAqc1zUvlGe48E+Z2mnYWPW2B5TEAEzX0yTO1T0dZDYtEgJO
	RyOEW18Ycqp0BNHsrK0kmTlBq4ZDrXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761775691; a=rsa-sha256;
	cv=none;
	b=RqKwGuqN8JWeGVAFWCagN8wuBPxGpPJtp52bU2TqwS9rFNQBprRLss3z1fY1+k3u6flFgv
	86JwKPQqDeM2n8OMAKf0RMzqk9bFk4oCEo/nKVgB1SXj7pBPB35ngrTmIFQ60RvGeIt7pX
	OEsMPZNRqFewd2aJhxBZM7OJQ9vkoR8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lhbf5xPG;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 24C9544786;
	Wed, 29 Oct 2025 22:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3B9C4CEF7;
	Wed, 29 Oct 2025 22:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761775690;
	bh=PCMUQE0BW2QoEo1rc9q0qVRgJ7LwUgidps/XqX0NgMs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lhbf5xPG+TbHCIl7DykXGj8gTac6GbCqNpXa1cRwVKEwgahz2Xm/rL9q7pwxoGeN2
	 1+wl3Z2jRhboHibxncTbneKp8ycFKVUwsFckuGoRJXy20OgJHVd2/6hhEFlSIa5KAz
	 7Pt61sgYPDT+ud4PyWxwBjwCBaxoEAqXXSB8nXj0=
Date: Wed, 29 Oct 2025 15:08:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com,
 kbingham@kernel.org, nathan@kernel.org, ryabinin.a.a@gmail.com,
 dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com,
 jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org,
 baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com,
 wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com,
 fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com,
 ubizjak@gmail.com, ada.coupriediaz@arm.com,
 nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com,
 elver@google.com, pankaj.gupta@amd.com, glider@google.com,
 mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org,
 thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com,
 jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com,
 mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com,
 vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
 ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev,
 ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com,
 broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com,
 maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org,
 rppt@kernel.org, will@kernel.org, luto@kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 00/18] kasan: x86: arm64: KASAN tag-based mode for
 x86
Message-Id: <20251029150806.e001a669d9dad6ff9167c1f0@linux-foundation.org>
In-Reply-To: <cover.1761763681.git.m.wieczorretman@pm.me>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 513okq7by4mna1kk1hdsn3u44zeksh39
X-Rspam-User: 
X-Rspamd-Queue-Id: 350E520007
X-HE-Tag: 1761775691-651787
X-HE-Meta: U2FsdGVkX1/v2xC8A2dM21RSp9EeqlVo61TPKOoonxWDof7Jftffc7kEZQDZ6cIeF1JfjhuRqB0ceePFUzsUQzGN+rigNp6YQZ/t61Cr037AUQ2l6Lp/08SZXmj0wBMZw6l6okSrUiVUCoz1p6IOLFBx557Q7v6jJ2ndXne235VyTKnluV1C1+TkKZeUY41neoPZDPt+q2yuxG5ESJ2urDdWkdCd9IV6OcajyVndVaoOkcAEkaJbYZKIRCjvhoPDRXzJuACi2mnruQTPUHE+JF4PcKgHB8r7tFahHckGU1W30JDGjHjx76EcvKmND+8mLW1MrppWF9cKUj23hc5/a79RVDXi6PQ2V4JMe9iWwc9cKvjUc1PBXC5KmrzsEAaNwT6yvOHA88IdlWoPNJL/W1nEDnok1913p9KqlNFcV1Vrrl1dKzqzxsJxZJaHqi/2MZYBNxcGgJrFxqBCuuFsPRMXRnQ5F5xIRSgMMP3quamAy6vp/sJm1ZTRxA4IChabMNUR1ySu/FuU/+GbDBLn2QzLfivRkYQwrjyr7jtrKpL5sdg89slscLzG/bGlj0FtbC8D5YnirwTQUAaRT/X7zInNPusOvhb857XilRE5p2su/Zoi3Odenub++GCjSCMlARHVXD55RbbtbmFfhtVqrtVmQwi23j6Vt+8kp19gmZ6ZoTFH8U+KzsxsjCBhSdCfafsAHAyGwqv0YaCkcdSARjwsQn7I6zNijxFWqcZvBK/nqHjxUdKdlD6bYGwWn6l3/vtKi6WEem8pWPGw5vz25XGfDyYFTF5yqPlJ1aMzlz5H6aR3VOeNerDkYz9oLCIBrgCUJJX1YlNzlhDUUDZgbDOvp+1agL51N6+gIVygYRBPZ3r35vcWvKqaESfk41trFovRpTIlykPoYQMk3EmC22hwbUbMAdOm9KMmryVM00plabc973QtS46LbURivcYiJpsWRnFAk5eDCuVAAQz
 nTVpu0X9
 IOps7PJkxyUPqq2MgoZWqG/mst7V4R5LbjCzKcqpArTdxZvyZ0/k+6/Sl+3rNXCOTSUjep+zz+rajkarl9V3jrFNioq4l9vC2rsD3c3K4M9PEFknktdaHwz90wQbsJRrUlunAhUSeDkmyXXVmMloqpS7vi0IgWlJEcdIkRRKLogTK2nvWDyfcF6xEDJUIhfUAXH5/6C4oVNsI2Y+EJO3Abp766dXX0ziyw+qUGycOsUEYrfX1DSfwNumUMKaBE7Tc7ldx9b5zEG14R0I5AIVAMdXZJTFD6HFZXpNtaa5tDwT0gFr//cMG2bf0+lXVjKZj1+udc/VpCBnhYCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 19:05:27 +0000 Maciej Wieczor-Retman <m.wieczorretman@pm.me> wrote:

> The patchset aims to add a KASAN tag-based mode for the x86 architecture
> with the help of the new CPU feature called Linear Address Masking
> (LAM). Main improvement introduced by the series is 2x lower memory
> usage compared to KASAN's generic mode, the only currently available
> mode on x86. The tag based mode may also find errors that the generic
> mode couldn't because of differences in how these modes operate.

Thanks.  Quite a lot of these patches aren't showing signs of review at
this time, so I'll skip v6 for now.

However patches 1&2 are fixes that have cc:stable.  It's best to
separate these out from the overall add-a-feature series please - their
path-to-mainline will be quite different.

I grabbed just those two patches for some testing, however their
changelogging isn't fully appropriate.  Can I ask that you resend these
as a two-patch series after updating the changelogs to clearly describe
the userspace-visible effects of the flaws which the patches fix?

This is to help -stable maintainers understand why we're proposing the
backports and it is to help people to predict whether these fixes might
address an issue which they or their customers are experiencing.

