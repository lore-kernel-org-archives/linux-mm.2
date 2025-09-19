Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFBECAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C548E00FB; Fri, 19 Sep 2025 06:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72EF8E006B; Fri, 19 Sep 2025 06:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88AB8E00FB; Fri, 19 Sep 2025 06:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9913B8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:24:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4264B5990B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:24:04 +0000 (UTC)
X-FDA: 83905614408.13.540A4B4
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 105AD180003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:24:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MeQwI73A;
	spf=pass (imf24.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M14+Hrw3+0xfvL7LtAKdftp5KA5xdtXGebEkX3FEMMU=;
	b=axv/6iB5OKeVz78q0xt/blhcxQ4Ur8IuurHyygWUeiEinyhlhjfLvsKaFgO/Nkk2JyhxQ/
	4mJV9c4nQloQQjgrVGAxpkxiYdkt8qY+viU7B6radiXM263Qqw1+t/McvvwXeQGwNxbyVM
	qFgnwXS+phxezCW7ro+ajB5PGgiyy80=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MeQwI73A;
	spf=pass (imf24.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277442; a=rsa-sha256;
	cv=none;
	b=fGJ6Tud+JZVWbssT30dE07GYnz1HKZmhdN4NtmZhzes69C1KMnVzr5fwl7uK9k+mG2SmfS
	KujP5CzfMTlTHLrzUuzQlxfW5w7jPisfLkQbPMAH8jvH6KOI1A59YXrpiTiYv1EAGvyDtS
	5YWzQcKe2NguydFl4t9t10sjal8JZK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277442; x=1789813442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M14+Hrw3+0xfvL7LtAKdftp5KA5xdtXGebEkX3FEMMU=;
  b=MeQwI73AiOIbUvgGPa0ZqnvRfgCaXKZ2hoJ95v5u89hVBfU2510yUo7H
   jahEBSTJo2kPtMxngOihFeN/E/lYLyNejefzlvDL0iRZ/2WEi6Fk1CvWA
   iBcEllajMl/wJon87/nIwdu64Lxt0qefMT7iPKa87OOd0K2AoQbnsJeDU
   b3RFZo//cQu76D7Fv7BEPAJIrcDqakGaqebrIpcCz/K4HqDfpM3C76Z9D
   NUqS0aA6e7USHHS8KY/nXDGUkmtbbG8mYsbZ8fHrVAvWnq6OTWVGndrc6
   pHNn1eXbIK2gxr9G/j2cVyOZjvaw55fec4ioAgXh/vlWuF86nS7LEPb67
   g==;
X-CSE-ConnectionGUID: gHgvYdjXRTax5TTgqwvVCA==
X-CSE-MsgGUID: iesenUiQRpylNXhD7czqOA==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2367500"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:24:00 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:14526]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.64:2525] with esmtp (Farcaster)
 id bc83dc44-d894-4589-a6a6-e547befad49a; Fri, 19 Sep 2025 10:24:00 +0000 (UTC)
X-Farcaster-Flow-ID: bc83dc44-d894-4589-a6a6-e547befad49a
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:23:50 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:23:22 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <bvanassche@acm.org>,
	<keescook@chromium.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<stable@vger.kernel.org>
CC: <jonnyc@amazon.com>, Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH 10/27 5.10.y] minmax: allow comparisons of 'int' against 'unsigned char/short'
Date: Fri, 19 Sep 2025 10:17:10 +0000
Message-ID: <20250919101727.16152-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 105AD180003
X-Stat-Signature: 71h8fxy3s7fj4eboiyfaqp47djtbmowm
X-HE-Tag: 1758277441-124353
X-HE-Meta: U2FsdGVkX1+ZiGyp6VpPbIU8XDf000KLXh+N0v0SlhuW8xIQKyj3FRT28yFw7Ee69UQk3IbcYMPtH1bC99FqpoHuDjuZJblMlxS4glqivaocmqaj/1io/uUz59oTueTKZTY5Iv3Z8aC7VQqeo3a5mKm8EceHcn+GovwB41h7HqDANybp1VH5qAv6r3MAp4JqusP7pWl/yI5KTbNayDF4uz/LxQQEM3pWf8e8XO7mmnDt4H/oTFXkZ4MCWz80i+kK4sjpfIrtztGbzr6DzkhBG93U7zpV0pYTmwewSm3WOqA/l8HtlNQ2++PqMQwiXHWjTHnKxu8vzfEkXtwLF6JQ0FJAdyk2SqrQeu2aL4LfgiuZCnqupY2IrrvvU1BVu8xZRTH+TfvyobYo2++cwLszrSmp/SI5v6ZFLOx+w1FohqPwPjKlP2xlv9RoCwK9+8K/4xNDkVD4FsIlVcp2ih526vwmV+umAISdc1ONNb3R0+8SI2CFlnwB3G2Z2iuJNjnzuzMeFwpIYE2I/Jx4hcsrU4w3VSztIJ7xmcSrd3AsGwF9W0JH3CADUR3JawvtHtDDxlyWZ3j/e6MqQU0umkqpxrSn6LRFMrhv1266x3Hz13xpf4XJbVhTKaA29r2WQ9bZVNMaLVilhtDXjkNyj9e9VJrmhax3SMpFBuCNKOu8vR6p4ZnIk78ENb04hJzGd0oEHx2GWzg2gLenLwfZzSwxV4xXOQIUEeWpVfjARK9WPJ2tkjJYh8s/Q2k4zytFxULEruW49My/nYnLV0iTfNIMn6mlNTAXX7rKA96oacFwWUxhYqZSKi745qyFJusgqNHBzC0RhlnKoE5X4jRu3i8Gab++2ipGJhpRUYB7sxLhi4uj2YFYeeAYcIjyMKzk5Zaz/Uppbm1nl/ZOxHsxTxR7YbtxtvDl1EAjrHGEVpirUlQyHba4QOyXoyR8tYv/n7ApbpSXlPBAM0otywgW603
 jCRv7Cy4
 zT9WWNiStsd8vH2wg88qg2S2pn9jEDaJKC7QSJJRaQW2K+Ns+gQWpyNEjoTy4TBUkXm+0IXU7vUuhc9sYSNSk3cSNteRcgGyq1UMP4oSk9sk/RWvq2p2DOTD718mtJ9S050YsauEUd/F8VAUNzJzgE4oxz8gsj9nzDpHFR1LHXWgjnWAcq6KMVu1HX5AX149+A0Azf/4iP1cpoQjZgtQsfJdpAeRreh+3zDIY75FgaGRdmX2AR/BVDXgTssKsEaHqCIUs9ChhBZujv3Bs0OziPQB3SqHAFMsRYvNhUopZlpdorS+4zH8jk0W7lcsVu85XyrfppbMTMrijxNuBPaExuuTTm4sx8VQ4FBrErr2bnaYuPt3bb/D3UldbhPtRv7rDRw37ksrwZaHze0R+pL4SBdz57duY2J+j1HQcNszWt08P/+mlokkV0getERjBhgW+djg/yZ+ZH/0yc2fErw6eG2fjVRY3gpNoRZ8lWHMMHI/YCB6sW6FXFSCkeAkAO5WLke/z0d0j5HZVR3wFKvwxC9HWDIAiJF5wY1ioaAqYqvh20yTefdqPMLduZEqJrK8llkO7id4hLM//vKUDd52Sqt490BUm6YLCdQX53B14cGi9f/arCtik+P0zZfDm4zejlzYuVzQpj1AD5YGOhNWM9tPigb7KZg3eK/COWNkQAf7fTxkJoj9RacDZEiCyKTYSGiXJlgo5k4Br6Xnp3B/0C9p/ACmm4Ww62vgyOE/6/4fsou9UDdzwEJ/JtQwQnPtLF9WXFwgnY2JnFXaski7dO6GBqcT0UduqjNmzUqwKkYh9qbmeAes4nqlEY3CNG8u7pmQkQImQJqIDCuWzXq7qkCgIe1LyGTEUCCI+v2HKY35vthiF+4h9AEmugit2LEbXmvpZ3iakSUnA1WRewyptZsnWRNYLCiY0mgVW1LVfnlEK7l7IqGKoQX6mYuhbQDmVjkCjtI94LIqhtmJb1CiFdDGWEN3C
 kv54J2MK
 F73vRQQZf9Tn2QhaLOIqIEqbIihS3LNVkUus4LGvz1vLyFgQJwSxPymE7EA4SqLLy5oO85nV9u0Vx+OfDbd+ixFzMsqwzsWncDDeoofrq6gG9C0qw+vbhAf1uNQ80w3aI1rVCMP/hXF0yiIrv1uwDMgbgujf4uEV5sHSyI+uI/inSGv2e4YcNVb8KLjr1MEwhkTFIzig4nrR19WpKlUiKulBA0Su4lesYhYkCIQUNklteUOaq05HzWjpEbsetR2YsvQ5jA6SztK7GiWbCILBKVFaVbrVSGf0UHsRwNIADZXKsgF0w6m1diDS5uipnJMPGC5n2zEawRqzalUIqJrDGMF5YajBegdGf+K86XPBEG7Nvzsyc4Z01tU6s2gkpyPP/x/Q8jqMk7HcGtoi3JRcCu9Y7y5SQGQlvdE26L5rdmrJF1Dg5yxBIAPIBuzdsIyaSGM0iC92Lf9nDzbN64dcjUmZpMwAZA3kDCTuUWCbqjAwVJyZP2fM5KfpNqzkZAAqS4liyNbAuwN7GfHkfLanvnq5H/mYE+qPN9+lhJi1+Asn3DSyBRxHbT3WRz2p06NfuJvRPfzcHhv852NkmjzrT72iVAJBKiSr8twzX3znSu5Jz/5/6xo6ameznH+2QfEfXa/i7Heg12CEYVkDwZJW25taUMzWiBz/BwCOZ3MHPEji7N++7YEIJtdXcSwkYhSzC9XClBbFlRHWzLRLRA8EX9+lX/b4sI0PR5S+z803itd7ka3vXA9icUhbdZmzy6/S6lr3NTn16JycQDmJwgH3TCTDO7R3FOD8GnYqaezn7iwEiLUDPFGPzFGHwW2u9DqrcpY0Z2XT2t8I5Fr+jq34wswSWbkHVrh7L8MeE3oYHA8iA1PbNSZ9E0AxvUpT34ippSkeGziEoW4JPjvUNGdbFTwtT2BIXZUZjHCHNo/wlo+PX3q/R9xqmlfvhMj5TW8RSK8yN7ln5vIEdqFCHW2w1nRWdjP1Z
 IWnnXk+Y
 D1eIbo0rNFteghZ+OtMSZ3PIygEo4Qz4PxVZgIXqw6y4qiOqi9o/Lqr0wgNBt8EHMR1NWZzzYjZWUtaY93QmNmteIDJNQaeJ2N5Ov6VlGMAlw03lbd14Y4DD4KFJDkREW95lZvmFmLgfFeiwY9yrI6Kj8EqXt6PT3vJUdrrMCGfSKV02UK6/FH+mWm6ieoNzCXVgX1OydYahNY1Cf9yNGujYnQjUau9PGNBc5luEwq1pLaZd10GanslqBZbWAZDibyBt7mxJGTUj57kIV6b1z//zuSjhK0n1kpyhWkVg2+kUIbvMteiBJdr6Fp3P/9z9g42KAlQ3B5s4Nmb8STeo1xnJ/UeknIlIwjNQSXx/HbfmsQy+r5IRqgpu8Yl4HicFqP2MDhOJC63O3ovmn5A0wxrYp5fzHzV/MbT+sICWOZnRMyqq4Am7eq4bSwu1zVGX9g54kb4tEHL4D9D9gIRI+lX1fAhHZavXKji2lblGUdg6M21vOtDE2trTFvROCjR06+AlBCNnX7cf24M6tW1okcx2LTG7vcyEf4V97k1Erfxb4e6g4mLATmgO5warBp4T6hDz3BsaYiYUtxhsmIhgDfr8xN+a3RpLoiZwIaoI6UBhIl1P7pMvbe0/DU9M7RAq0JCqWlj30dKq4VmMRj0F+FLe7EiPLmZmbuRw/uYW3TTnikWMqOyo2dosZPBHJNW7AusVGsFKydHpauUQ82OTkZIC5mB3//nSDnrEmqUYE4iPg6ijfNDKWhSndw8EVP3NGM9Um5qsVOdE44TYU4jYhA6zFXUt8d6a46r/I3+ahHJ11PHwIwnLX+WUJyP45Rjgke7k5aUYaQwqcVCFLYSxNRIEDLXuSyA8PoLr7Exuut10xmpn/9eRMgV99KlHJFVgaxUowNpF3VGxsO4Bck4e5Xf8PjIgg7Ki0w953i+xMatGZ22PUF9pGDMsyzqW7kxv/9mIfnvF177cBUBQXzeJtCuYioLkj
 nwwuAvWw
 tllXAFhhAukWgx4Kw6p1KS77FyNcGUT9jbd/+B7FwKWKKqE1EC5WRUzPdUpZMXyrq6I/GtBouun4jdLBwhqR/tB+9uKF2aKy9unqUV5v5TiHiyeh03Abq7+6Zi1XKSYsgISRZA+IWciXTNAbifB7NlpBLsghrYiq3AU3rAEFxxP/1KnSKXUtPSkx2Tk6KX+OjhKIxlk0zuujrmFwAHQFpExaQAgZ7PP/2ciguQNvR/9yFP1hh0xdwb913mEsdqtvipKB3cgaCbd3nXVrEYpxDBCIkzqRTQRKiJYQQwxsnN1yyfRCbHaKW0KWtrmeI9TvoO8M7qB1k4MihTva+rgnqpay/VGlvLMMl6s5/bvUqBisnAzYrztBuNXwBO5LJ4byWunoldqp0JubVrhVCa6csxEL2qLRJaukJ1Ngcpuo27Na5v9S7uS6rdr3l36UJzdavPa9dTcOFK82gGeoyOi79FM9gm9zEN8HJYtcJPMCV/IiP6ty26r1KR8wkEi+jkkew/SXM/d32lUzKI+00t5z3K6+C7tjQS+7DRd6sCt7KFUJoklg/iGYCGkOJAMcuZ0DQvziVzBSCXOS0OuRquvNacNmjOedB8y0Pom+ruV2jmjDvAPAHaTaLZ35ajQfFY28dIZSpeTN0CFbvlMhzgUG+dgU0zVXP/mCYIO59aPzXiXt1SuUWEiLpensP+Ox9JOIGk7OMOysdzp0DN8jzikrWvpizTWL4Jv1w4M93mC/qUnUFGRBOIo4ujncdF+FGWaN7beEF6HOjH0Z6vGp/OOKNNwN4zGMiqGPBnyPVD1lJPtgqHjyT7dNRRA+4BsPl6utJOdfeO5ekXqNh1Ug0VfYnsVFfi2v+UYehodSwt8Y9BltHTjCzIGI8a99vRYy6drJetk1QYMwGqCjNCNW0MJKLKe3CokQMp7Os/BZOsejlzmonAKt6zX+j+mA0iaWYfKKxHRSZCwV4oUoGHiu+M5nwCpbtbQzw
 41bNN7gD
 Uf2WQ9jrOvPtaGAggdq2+LSWfa+2+YshJgZscfhQEt8t/KbMfVXDe2BZTVW2l98DGEN29z3KchmJaoBazgk1QEZFrBN0DswtbPc8m2LDf1gKfOGKbAT9aqF9TgofC1V4rKEIuLUPMiu0AkThmMzMgtY50kkC158GMRpBnCkzwsk31OuFvTds57nH5B75gBTvmkCSKvHtsIlWNMAiiQb3Da0duS0ctKpv6s1tHcTF5DhNZqnOfR1MM6AOGqMJNHr6/OaIEmq0gwI0plpstKomsjdG9FSSKlyzTyJ7B7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 4ead534fba42fc4fd41163297528d2aa731cd121 ]

Since 'unsigned char/short' get promoted to 'signed int' it is safe to
compare them against an 'int' value.

Link: https://lkml.kernel.org/r/8732ef5f809c47c28a7be47c938b28d4@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index c0e738eacefa..842c1db62ffe 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -26,8 +26,9 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) \
-	(__is_signed(x) == __is_signed(y))
+#define __types_ok(x, y) 			\
+	(__is_signed(x) == __is_signed(y) ||	\
+		__is_signed((x) + 0) == __is_signed((y) + 0))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
-- 
2.47.3


