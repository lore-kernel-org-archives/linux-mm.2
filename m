Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B077CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C5F8E005A; Fri, 17 Oct 2025 05:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB368E0016; Fri, 17 Oct 2025 05:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC38C8E005A; Fri, 17 Oct 2025 05:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3FEC8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:07:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 676D01605CA
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:05 +0000 (UTC)
X-FDA: 84007026810.23.5B57EA0
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3C37EA0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ll54v3tK;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGaAvozmIqIzV143yBTS5nQtsGF8X9DZFIMkdv4YYLs=;
	b=PUc8XkjNJ2xlmYeKxbNHhLvEAfbuQCjDPGd8K5gw73l4ByYL9EmmmDbgeQ6jt0gQGMxEW0
	FMT2dMIg2WAIAWS2a/O4wiM84z5E2rJPcV3Xk0qoWeZueDnJ4WcB/RZX4DLwGHYulAkxLV
	rLCtfMVrF3Vl2/bmKU685TcdJEWBppQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ll54v3tK;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692023; a=rsa-sha256;
	cv=none;
	b=V45TskAM9zXzX13+TlsMYv0o0CciKeslz5Uk0zo9PtDmYcf2/nrrLJLE8XLZ4sIkNmPerT
	KmAfo6XbQXW8/kyI4YTXDHJmWPMFnEhrvELaUIEw6OgcJTEhR0MRfpS1H6sReAaLkrrniz
	L7wRjVIk/OiRU0aHRTCVEzdbu5L9QaQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692023; x=1792228023;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=QGaAvozmIqIzV143yBTS5nQtsGF8X9DZFIMkdv4YYLs=;
  b=Ll54v3tKecSVVbFL3dlUcXLtbPVSuSwJp+ROzoW9s3i3bjG6nycIZSv4
   hwRg5hydN29hc2p9xMIMBXo9t0qEvvV4qR0MHCjewR0d+rBdp8wB8gyiG
   N0nTYGQYwV4xOhahMQBAMJ4RuXvsxIwumPBTTar+DDYPdCivrqlLoacd0
   jlmRtSIAVvBC69wKMhGJ9b6+Blip8WtjJzLhP9xTd38ReA1SkMF/gy68o
   UmpjjVceHp4h+50eNBcZfmUftTZI0NPt2DXLMEe1x1d7URtPfvGxscnw5
   7rKcGQsROaoofrgZ6s5TmBLLOAFActkfJ1Mc0loVATBLk0NtM9ofa948C
   Q==;
X-CSE-ConnectionGUID: zWrYvXLbQjiOYymOyGvz5A==
X-CSE-MsgGUID: 76/3AHtyRme5brVPZGOntA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4877962"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:07:02 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:7581]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.167:2525] with esmtp (Farcaster)
 id c402a081-eaf9-4041-86d8-805021e16bf5; Fri, 17 Oct 2025 09:07:01 +0000 (UTC)
X-Farcaster-Flow-ID: c402a081-eaf9-4041-86d8-805021e16bf5
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:07:01 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:06:46 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
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
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
Subject: [PATCH v2 04/27 5.10.y] minmax: clamp more efficiently by avoiding extra comparison
Date: Fri, 17 Oct 2025 09:04:56 +0000
Message-ID: <20251017090519.46992-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C37EA0016
X-Stat-Signature: jpujjtt4uffjbmnj95yrici6du496aox
X-Rspam-User: 
X-HE-Tag: 1760692023-138960
X-HE-Meta: U2FsdGVkX1+1rNL+ORPmku3X3iFXcR365rl+M8/m1e0e3Jbf2fGAJh7BP4jsFEE1l7vjR8wXVe/p6UnvKUwlLiWhTKANS3GBzExowJTyj7FTqgaeZMsA554sHcLDKafXYvFrkkDbedOhDetFpmrRgmMT7Ieq6hqG8l5xvDqr48C08qxl3lc3C77aHHNoorygfKIRZcTVuhparMrJnEFw8bAoz6sa7WHxAojdaXVV0RK30hZcnGbAdwKK6chZAhhTCQRyGxnoqI6zpR60Ht/Xf1Glho56qQPxcOnQgcEzwh9jSFedf8WyRh6mO8JTt4nOWYIFdSlJsi9GhSgKkJYLWrFMMP7IKFXzenBXHsYknBwJiJ4gUoNADKRM0qOTNrNzdoERflMT3d3Q0qHm/lESUhgyGPSFM7sZhfrzf4pDTUjEy7HMf3G8zZR/UqBWzgIWupYR6U/6DSBW2wWIQw3ujVTGnrlgRhEZu16mCn8xHNSWuLcrnGoRzOiS8EKE5xJ1OUiNKek3Bt6An/0FqE1GoSXKaHy48vL/RKozQ6JU91k2bh6QU+IfjvBOqlQB8+PW1ONWPj7k6/JwsA5qnjiJgMHl4PMaWECvYC1xXpxHysVdg5LiyckzofQ97noFWtniHrM8vYlhlEYZfDfYtjvOBu1naSOQf4xbe/7P45Q7qU35wFM5w8Z76tdxM1CegWlzZ0vk1ENqkvq3VCqJovV3uJ7tlTFQ/Z/4HYfdWEZLvEr4b0ZBfekpNkDVLqihX6ecyouA+PHBA0eqHsl1DvdRoiDjGdrLiSD9rkKAnIg7z81JnZPZcN0BTKRk4wVnQDD0LSK2vyBzeLCjTHC+Yi+289jkgiqTk2cxoanmm/RPFyNyHix6Am6soLadbTyI2OQyNEcoMeGguddZUz8CSYMio9Gdxh4rk266C+ZOMVlr+Orc/NzjXz6ceuXltSFi3gMzn6g6KakkYHk9Qh01IMF
 McWVoQck
 ymUxEbDaO+mmQz0mPHubmISKav1v4eppBwEHIcw1wRn8hjl3MZ3OM0JC4b4qbAgGrKNNk5DUCoxBZB5e0lBRVN4qgTRCDGmiGd/LjVWoAR7TEut7nUH3Fqrnsop6Z7j82TrQw0VIbclgSoMGq25D/Ti86fmPtnZpOpaKSULCh9hmjRiKWiTKuHbj3mEcl+AUFOMomdadN3Nz4JWir9VNST1HLLZ//W6XTT+wPzeqTO76GCdN/rxJjZutkbCDlFC6PC6/EkE26nrjlG2J4R0lF9jioYvF67/EwSaX8jgxiTpEbI9sfS07AzI98vCGg/8zZ922ApTVfNwRJ9G2olSzMFJbJH6AjAo2iSEFf59FHst42jVnHSbU5bXNueO75G6ZRJHT3l3FZNL6qu9rUBkvjJcgFemv1EtQzIzpPN+IKc3B8g40bqMhjhxbevpxvNDk7KmCRoU7hDZoWQehjljTJsNrE5lV5XgbSANE/lMg05gT0reqrYZMmX0ihhWp3U116ct5RFiuwZWFwSItoij+bdSzqcxLy9SgvrHFr0NetsGHkAlfeiu4W/xoD8O1wugkCSYyF2vsvT6cewUIU50YQj6Lijo0ymJ7nh78rZX7u8FbzQzkPjeDC2FKpolV1geFocf8dkyiNJ0XLa5Qb5Lp7DALD1QhGy+2Amjmd8nL4wltiRm+TPlU7G3yXWbMi9MweIYe3v7QHUtPN18fx7bCaFh1k4dptrL4ZTpxdvhitalH362oAvevyZzkPnJaM/iM5LyFtO46R1/RXyOZDztet+Clw4Axhk/cuEeLSbo64MFRGKklcrZfD+PP9cye4o818fRtqNsb3u8VJFpOa2aPalfdmWIJGRghLiA9HlApRX+5QKJmrCUry68XMnO7rVLuyJBzEothRAhpaOSSvyZJ0bmE/oBzuyhAWu4b7kbdGL1Z2OKcnelYjCJiZOKhHMfiRJiSkqL9OjlwtbdmaYsN+niSMEVuP
 RiJhrOiJ
 rNxcV+RgRmvL3t2V4guvtn20OcL1TOuxufACHVQkzatCx7DUno2EjPxc+W9DzHHH1mIqCkafxo0p04nClmk7WYfuu4CuRllYmY90XtA0lIFZ6tLpow7mlTbzfsbkNphn7tAyD8crtqUcYgOdZln+KUqhZKtgwY4TuD1jiZvzZ5lJFbyC9vUN+GPMlsbBT/Eoqoy4o/ThL25kbP3EUrokQGqtWI/VOMfFqbGv26NoQZ2KKi03lj42IPWRQr3BSzCA7jWx1D3PRnZMDivb8SmVCeGvNY0UPy551rc563PRmPkbX3uXX9PFiN3QKtbBZ6AzRH28umAzidJvOVcGMDwZSBWkC9p1wCM/42G45HwQWFSpZNagKRBnlsb0xK/XyKpG0CHQmTimVQ0C3424/l1C1sDlJH6wtjsp+jsS8dNnKUw1OfE5VcJRqDtv137pnga76psKv+rOk9YheEQuVnyAKzB4dK4nLUaJ3N4u5BtT5kXZot2Iu/gdfdj/+yjtUhdaNhSnpz2D+VvBHJTLhVzTHLaM+qoKBB6mcMy/iBE7h2BueFLTMCnwxFJzEX5HzGY+VNJvhAPHvxIemO48AqPiX1K+B19c7juk58wy3EGHiGX/lDqRQgnKS7Y5vZcfO6BPFPB30kdzr+a+J1ovwnYE1jBJ5hiWgiUmr8BzlboNLMnbGyX37lraWw9orO6T4a+OiAL3a2+bFayDxRVlL98xpeK0J+aCszF02RCsQt56FxWE+KCO6EmiBJWzS2qRhJ9NlnNCQxD+7HGNd7ZeIzjBLj8A+1RJWAJfade3jSedORldqIt2og3uoX4P9Mn0mcjzBVGlSt2+ozdrhNBUgJlV4IoFU4eUMQ4KJ68msyxEccR16h1T0pNU0uu7JCxsW9/1C7q3zCV2rCd85TwLtILOREKure85r0ISh0Lt7AbtcSRq6ttr8G+3tEaiFyk8C60MiqZprI88GB3Mdd6swCbyiuHB8yp/A
 qu+b2ntT
 K0GiWOY5YsBKfohd0A9Z0OXB5hfVnKdcDHK9Uy5ORdM5XtcTF1GF0XO3w2ZJ7iCi0ROcdtzJdEfyGnuqqzhL9dS766PYoCP5D2ZZQ+zVepJJ1g1Gwh/vqLQzHv4Z7zBnHDNiO5mcdXhB9nx+Q9IWHSI/6Pwu3rRiPLpgFeZ4XQrjeBGEL7DJKeC4YWUQrPJBf6iQtUCZBxptrI83ssOoI3GhbBr/WPqReQpJN6OeHkzYfZbwdTnZw5UmX6udnDrAt0wA+aK4XaqnwbF3WoK9v6lzoYMPArcEV1JrpeuoeRK4k5xDCEq6tUF33nZw4LP18vxFW83Jc1XnAz7Jx4mVBBoH429LFZmDbLBlankh99P2aAe/mnkf3E5RR2Gj8KNUeqNKQzFX0umsjJcV1QZt8Miv+PwYZRAtzfx5WBm40OVDeS0RxySL5uLZy0vku0ZJs1wx4x9u/GyboU7st5K03cQF7YoWwWHsH8TBrK6OEjbnJuHPICTSHn8ycin4WFeSYiVJlP4FaVu0n7M5GWf/4ldv0PRDxSFyEPan3UgJv9hYuk5aGQ7uePyr4b1xbbDXhVk1zGx7UlEZLZDFuzTPBMPcBRon8eYX9yf2eewzsxQRRU6ro//NAxC8QsxUAifffKU0I0S++O99jlcRNGkm5mtZlUW6t4/hMJioLlR6Ua7pgIog58fQZidV2pomi0cE051HcLKykFUdUt0lxzRP4W9IIPlKnp1RhiBHSBOz5N3n7IXocWGJL5gKrBq4omkM4sliLtntWIXpFdfvMXlxmoZAWUKoMvrdH/DiNpGN9OlFcePQv6FqK+cbtJ9Te/yKwXbopmldJhN+gi+H0Yw82b76P7V9b0h375BRHmAq2syolUMX5koLSeSh5302bZzJyljPhiFMKJWLxjfVAFdTg84IoQKWMmoACZIOG6Ci5RxW8/d9oZd0U9SoBfmdKCMlnscPMNm4VgPI1zKSYbHmbvHj7wSlC
 YkfOQxX5
 aies3YYmD5WB4yF+8NZ5CMIdkb8aMGX92GiIuJrD9s6apMs6MCow7VHQ9+cPtoXJgMy4pX9ec1mfGDHS8F8lfhvijkkZvo5GYo15N9a17icn53fjcOrP5OsVGEWBBESYqHIjSLTWeG18emRxk1fgVlSwghwr0Mu9E26U5GEJJLU+JbQiPt8UUDfRSXkM9qixV7gdl4R29XPKozOmFl3HnF3OfdBVI/FiLmYkUr8R/W0YxpHwah6r4nf5DiS2+4bLu2zyfeyCJZuCbtVQadPotpccOcFkIRNS4kGzMLM7oSUu21qfme+vikRbuY6tpuywJkh/uXYURIjZCdiNxjx1QSMaXfhrcH6UOnOE4Y/mkArDk2t7MMlOg6wiJYuMgrob6/c1PLFPbpBuMDAUcAwj2VFGjyNJ+wMvSB4d1m/dLpJQUAIQAkBqIIV1LSOs2WxERRLgaRLJ20MWSn3L3R+xwlBQR0Ds5c5xglcZj83oN5oFoCX8aseMvBN6TWCYxljgEshjBWSq98o5E6eKQJgrTN6pymZZIj6bicmtTE/GiqnmoeoPI6yOeSV8lezseSnG4zvZDk7e2IIeNZaSpTDKxNocTtooL7R9wk+vsMypf2tEhAhIgTxYpRlkELMieeJwHF98ZgEHuT2ejjuYikbPy27KJ6zWAqVyChbyXtUeuUm0MTAvCIIUO5pI32eXS6vKRd7PKTDfaKRtLnhke6cntAZr9bASK2nJv2FvwMXXL1K/kmVaDTMYgrbXzslQ0NM79/elyF4HYK32WFgGnv9uLfrnebJbj0ZqDTaOpMxoxlMIutasgMkTSczGNXkrarBzk2ME+SdMF6ttkoNMvbDwCmNe6O+VmdzpJabr2WgHsRZveNEWtAVQ90ZGAYu3/WX/joSrihvIm3OOfcAS6ZevR+naWXAt9mohxdGWT8DPf94QW5NkCRYxDQMedUGa/ZKz4474LObQjWxdezGDWo3i4Ep1ROA7r
 az9B5dTS
 ruo497pttXiC0Wu091fcFMeqzzzGtIaCOg3YZGNs2yHaaW+JUWEhoBBlOy3GxMhOkq9jwx4N32fkxRKpb9Uud5NJIzNZKZ35p+qW3CCM+NRqhBEFl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 2122e2a4efc2cd139474079e11939b6e07adfacd ]

Currently the clamp algorithm does:

    if (val > hi)
        val = hi;
    if (val < lo)
        val = lo;

But since hi > lo by definition, this can be made more efficient with:

    if (val > hi)
        val = hi;
    else if (val < lo)
        val = lo;

So fix up the clamp and clamp_t functions to do this, adding the same
argument checking as for min and min_t.

For simple cases, code generation on x86_64 and aarch64 stay about the
same:

    before:
            cmp     edi, edx
            mov     eax, esi
            cmova   edi, edx
            cmp     edi, esi
            cmovnb  eax, edi
            ret
    after:
            cmp     edi, esi
            mov     eax, edx
            cmovnb  esi, edi
            cmp     edi, edx
            cmovb   eax, esi
            ret

    before:
            cmp     w0, w2
            csel    w8, w0, w2, lo
            cmp     w8, w1
            csel    w0, w8, w1, hi
            ret
    after:
            cmp     w0, w1
            csel    w8, w0, w1, hi
            cmp     w0, w2
            csel    w0, w8, w2, lo
            ret

On MIPS64, however, code generation improves, by removing arithmetic in
the second branch:

    before:
            sltu    $3,$6,$4
            bne     $3,$0,.L2
            move    $2,$6

            move    $2,$4
    .L2:
            sltu    $3,$2,$5
            bnel    $3,$0,.L7
            move    $2,$5

    .L7:
            jr      $31
            nop
    after:
            sltu    $3,$4,$6
            beq     $3,$0,.L13
            move    $2,$6

            sltu    $3,$4,$5
            bne     $3,$0,.L12
            move    $2,$4

    .L13:
            jr      $31
            nop

    .L12:
            jr      $31
            move    $2,$5

For more complex cases with surrounding code, the effects are a bit
more complicated. For example, consider this simplified version of
timestamp_truncate() from fs/inode.c on x86_64:

    struct timespec64 timestamp_truncate(struct timespec64 t, struct inode *inode)
    {
        struct super_block *sb = inode->i_sb;
        unsigned int gran = sb->s_time_gran;

        t.tv_sec = clamp(t.tv_sec, sb->s_time_min, sb->s_time_max);
        if (t.tv_sec == sb->s_time_max || t.tv_sec == sb->s_time_min)
            t.tv_nsec = 0;
        return t;
    }

    before:
            mov     r8, rdx
            mov     rdx, rsi
            mov     rcx, QWORD PTR [r8]
            mov     rax, QWORD PTR [rcx+8]
            mov     rcx, QWORD PTR [rcx+16]
            cmp     rax, rdi
            mov     r8, rcx
            cmovge  rdi, rax
            cmp     rdi, rcx
            cmovle  r8, rdi
            cmp     rax, r8
            je      .L4
            cmp     rdi, rcx
            jge     .L4
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            mov     rax, r8
            ret

    after:
            mov     rax, QWORD PTR [rdx]
            mov     rdx, QWORD PTR [rax+8]
            mov     rax, QWORD PTR [rax+16]
            cmp     rax, rdi
            jg      .L6
            mov     r8, rax
            xor     edx, edx
    .L2:
            mov     rax, r8
            ret
    .L6:
            cmp     rdx, rdi
            mov     r8, rdi
            cmovge  r8, rdx
            cmp     rax, r8
            je      .L4
            xor     eax, eax
            cmp     rdx, rdi
            cmovl   rax, rsi
            mov     rdx, rax
            mov     rax, r8
            ret
    .L4:
            xor     edx, edx
            jmp     .L2

In this case, we actually gain a branch, unfortunately, because the
compiler's replacement axioms no longer as cleanly apply.

So all and all, this change is a bit of a mixed bag.

Link: https://lkml.kernel.org/r/20220926133435.1333846-2-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 8b092c66c5aa..abdeae409dad 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -38,7 +38,7 @@
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
 #define __clamp(val, lo, hi)	\
-	__cmp(__cmp(val, lo, >), hi, <)
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
 #define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
 		typeof(val) unique_val = (val);				\
-- 
2.47.3


