Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68D4CCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E86448E005F; Fri, 17 Oct 2025 05:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37078E0016; Fri, 17 Oct 2025 05:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14D78E005F; Fri, 17 Oct 2025 05:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB0078E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:08:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 766CBBA3B5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:13 +0000 (UTC)
X-FDA: 84007029666.08.453EDC3
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72CE54000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="q/jkKglr";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692091; a=rsa-sha256;
	cv=none;
	b=utGBnf4RqEFzvdDFqqtjSd5GGHOH4OSt4kd2c4jz+tHxwpHcWZg8vH70zzQeVfs05G9CJS
	ZHpMnLB3qkgyyad6vgUsiiyk5CDmh4tVkZfFM28YSatlqZzWSTiUSqeCpRPJRc8UCFTGnR
	FQdetTMF/sGQnxyXZpgZMT7PkkCil4Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="q/jkKglr";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP5j8meArLlOtMy+CXHkrmjueNHJCB535+/rQW1z7Js=;
	b=gv7ruEadjgOkI14fg1D7w/zu3rVEuX8JKOdv5/4qaE76k/qziypo120w9P4VPwWDB7sAxC
	X0NueYsbh6h48STYOZAGkZ8pGOjTM89BaBBg1j3DRj+AuoDFWG06MYMTQk/Udv5cGPSV1y
	D/PaSfFYKep42T79hOzQ/XloWsrHhfU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692091; x=1792228091;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=fP5j8meArLlOtMy+CXHkrmjueNHJCB535+/rQW1z7Js=;
  b=q/jkKglrp5BQnYwmbPIV+siRwxlPNEm8fWMV7XbP4t98GZMUoWLKstQz
   ZnwyW9JwJwhxP/YUo3MHuctJs1fwO/AioUj1KVXDK2YiR9d0lnh/NJQxz
   jD+d4u03DGXTpN6ZtzeeING9V5Np9xBlE0XQD6JV4twcPskCN3XruklHt
   L7zt7s++Pm7gfsYF2RaQrEZpEZdagc5HuSWwDQhNrobX8VQpdTOj+cSAM
   Uuco/B3qjS23U4q/vwav0ZgfuL4J7RGZXpcAW0uqL+fc4Lh419wWu1y8i
   kLKBJTp944KfLF4Aeu7dYoWGlUAhEEvhcYlcrdIYxl1atC2YFqxjxYZ9C
   w==;
X-CSE-ConnectionGUID: XVnMRMIzR62z7f3Q3W5kiA==
X-CSE-MsgGUID: wBLf1+1hT+q/+BqR65aCqA==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="5073997"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:08:10 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:20995]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 36a5d8d2-a407-4db7-b7a0-d2f0b2ce4eaf; Fri, 17 Oct 2025 09:08:10 +0000 (UTC)
X-Farcaster-Flow-ID: 36a5d8d2-a407-4db7-b7a0-d2f0b2ce4eaf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:08:09 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:07:55 +0000
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
Subject: [PATCH v2 08/27 5.10.y] minmax: fix header inclusions
Date: Fri, 17 Oct 2025 09:05:00 +0000
Message-ID: <20251017090519.46992-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72CE54000E
X-Stat-Signature: 9tgerraxssjibdrgi3so8jhrft1qg16x
X-HE-Tag: 1760692091-26091
X-HE-Meta: U2FsdGVkX18Sv5IE7rfdwJ01+SgHW2ghcuza7SoufABAs7d1C5oEo7jC92A3a7ZBYFEya+t17dgTsVfDSAWTWu5S1NRA+SNOAs1EL3tpi3LMYXHc3lVHH9Pj+rwOmoQ8PrA3U0uPKkp34YLSA+Prt0R7bCGgSnHx8VTDZMlAtGmjggpto2a+uKbMAh55ABfhibCpS1qE/ON79uvdR1NrR3itcrKLyPuE3sUpck7Mty4v3udHpDcmxDicWhL3qREF7p0EFu5425a0xjxDi4sO5Crcw/3g9U3PX6KwnqC8hKhFpgJ6AHerm9pIQjjS7YyvZHoLzPPsl2nDN6C9Up3SXSYNrKc0hvroz2EbBAy/BEZtPR6t7JDBvbLVdndMT3UMmi1x1uIgVwTHTts+WJEwGdbgdQKtCjXJcMMEs0/+MsoTEG4GxhhDE4MhmypB3d8lsqseNHFN/pXID1f6pznlRzc19gWLkhArhFyHt2FE4NwWK58LCu6sSMKH68T764htbdiBR7pzxiAwXIxJPDYfxmxOK+9TvWXAhnU4XHWP0MMwJrwmUnhggNuwJhwUl90pxzJZ8rETZxKrmY7exB7BSNcgrVW9HV7QeDzpnNOc0KEOkKBPmXwVV3f7iDkEX178mOMMauJUPb7x+OKHiWaJBPdmtUmvU0uEWWmYwL5Caua3ksJomAeZFTTZzzHU6p6qoWSSFX56b0XzYzASCzwMnLlYw7xJFfCgycOD8F+azCgmpXNA/5bS01uCliOE95OmZKLoptjFrcEtZpvD0FCw/nQ34wsWpI72qNKjOGCg6G9JZr2kkEy7Dhkg/WwEJHXbra9eR69MSz4L7FLV6eJrAs4At/dJzgEXSyY/lG24RcNTpnV108SLC1JE86VYaxSYZvvfItKhAjbIkvAR3PeitdHeC9GVcnbzstuF7ZqN58CroZZbSOxp+vj9wIHJ+50Tqd7eROaTdZir5legVMk
 7V3I92Uy
 YTr6cfs4NmUgBjjwgvW5ItaEgaKkN51VJIg0ZTJV6GkKWavwdUEB2/md7Snom4pFwd5S6nJhFM6ArSisJ5SyeCYDDdR0UgZQ7S32+Fb6XEb9jJuZ9td6v8klWxunE+lwxnVVCdWpsgreZ4z6z9sJmZbp+u0t6ljxUxZlHoUR7T+1Uztmb9leM4K5+PheimukRcoiCR4tt1Rb7HYQD+EDJkrZt/my/bxtAMvjiFmKVS0g898dYIglMTjIjw8bI7cSzebXExGR96B0ypI+nGwq4tUy4hx/zlpyTVS395Tnlv9RrHFmde2wFVZmMgLf1JU/pamILSG8dWr8X1Nxvy9HdCGLJ1gd90R5w/rTg0VlwrIRQdxKKQ1DDTC/mw0S+G90TVUsxdKxqL9Z2eXI+b//BfPB3p9qeP53rW5GE3SL1a0J80P2wEvtGHihwyH4TAurbep+WXNNBOns9ZuqlbvehHJjaN1f+ehibYDZtD/obBiz4Q5mwlJDWlT+/DrtbzbhfuelK+ShcO/NqayglluleGIUti/626cLmQGDpYDHriVxIZkDNWrKU8RXJWNGzPFlDDABvB0ZSTV7ZnENhCb2dJeVuaXwEeAA25BlLw/Yl45hhUEsw0saFRMacj7lDgrP0clImDhCt2eacS8ii7tzSO5W0qr7HqesjI9oyFg2upn4tmGQRaBrV/w+XVsRcTLrRZK7uYnaoWHC1PzfaYiCWgPZ7UzEZXSitm9N/da+dDOuZihtOACsJimdHhDmGr0yve/oOfklmths/z+FTt7RxNYw1tjmdBKi5SltMGStT49yOMgsCyF0pMkbW1jDIbceCJxiAe0DWQVwRC3/PW2clzkPPy7Z+SqxwLK1xNDD2C806tl0gxvTL1Q6JP152f92CT9+XO1FnRdYYCWESsLApPPXlXFh9Z9XC9Yz5AqhQksJSc/bCOGKURo614kdv5nQejigsPoDrLbbLgcvQ9nkJOef0aNnH
 F83bERJ5
 /3+RTPGr9orZSzx+3NbJMckRiZjPcd5AgQkXf2lFcl7SPg35A5mfltQIk/4G1nmHnLRVlb/WWCyGWX21iSPaj6y0ijfNySpIA5nG39YIWmsVvwDbVBUc3KDf7hTLdNYCl5EvFanQ4NWmNze6qr2s7car8LelxxXDATPrm/YtJPbLg5mIxPBGj70UbZqNgepzDte5vIz33yg0W8g3YvHtj8wy+Vj4MMm7GhN8jaMznPZGOoftGJCXXdxo70Mn2CQmlApA+scLkwaBAHKxtguMm3uUx/NaSZDxprkkvxnimqLoXAOHgYFPrIEcklSHrm59iQkD1Hh0FgFouUOEjNiMqM5dpwKRPiiuhxIaZ0p6KDFFI0MjVidqz4+oWqzT6tHQddsnenfWW4ajVOEgCcUshHYrSKqOVwJJjhB7/aqdTPBOPdmnqz78I/aTyyR29Zcy5MWFBlcBhk4xWxWucgoMvQwqe7myCNlxI6I4wGJpl7OTb5lTmzwYFfrVmyGJTIMroH5jmCP06VOZ4dTEr2gJU7fLjFcUdzoFbk4oyREc0wrIqx0ABKHBL5xzMTWuNXKG+VnSdEF2IldFSto9gOq3FyNxZ8N3mMD2CAtZNaFIMbXJ0DL8GOPyjRqrqxAbamBvsKIlzxFVahnZN1e1vSZb2SjkwaqYVvRfZ2euLoFPSOBbBsfG6xBWrJG3Bl27lu4hulGN7LQNUBOlEKKPDCPr8uLrOArxUytb+xTw0Wy7Z5fTYZDPvzpx3GjhkqgfrI2UYxKGysAbV5cADNT+kJ2/1aweC8/mBGua0q5n+lBDJ2dXe3sbW9lB4mu2gkLiVEd4UT/WqI15ZVNqFQSldb/Qef6GHP3bs/eDUrK+7yEK1qMK4WFF4yM3TP3Mo6kWjFKmeMr8dqqvfP8/J6hQrr0AWg6rEko6B4/dQJVYPl5yjj66xTWVq5SE+XyilottqetEfT91NS/Oz2/RZnMREEmXiWUl6f47y
 A4IolRcL
 uj+lbscn7Uy4WoYYTPWlz90ezTprdMRBERKJmPMfRw+Pw+wTFT5usYNeLdSQ4Stj8limV/qq3gCZUimjjPB+XzL1uQQDrWegkw6rLARzxvxfdEdAYQ/Jr57GEE77AxuG3F857s3tc8NoKZVPP/CsUh7y+ICRNAIi+ZBSax3PP34FVdUHlj/NLtlb2NiCuG/JqjAHMpPRUAqiXWeZNT9c1T2PBaoiX2MFPjTu19Kt6VoiXJFCUzqC+Bth2w8poDix9eAf4ra3gxMDQKyax75daN3s1+LprtLy1OxGYGLc/gd0n7T0fjQd1M2cC75KJtvjoDUgPjSu9nMaEUf0DD+MvE0UTu6wWnya+CXmH72jxR+ZmuoxDmj5stXSSI7M81j6g5hrCUJBd30RQaaF7evmxZJmSotkWVNUejdr7E93K56YyXvlAluNCmn2QJR+FqR1H6NBWnbWDSHgGZeZovWOHajhspYHMGi343RWB1xaTSHqqXd3TAvHq+3T4AvOmxphl5JuF5Ll4VM8E+qz17SPBJH3SZdfXuLWma/MgqFDFruh+6rEsMCdkSvYdjVqTnglkFeMUFrTMXusee9AyZ1m8v0uKLoqPj+Ko0FciALU3kkb8NbvYpAcWZVr/Oz2OV0pndtxwzLeAggZBaCgpUnwx9Nf0bUEmsVwsxp9+wjVsahGMxTk5gBe8EcHdiFJucJhrX7yo7p13YRfj1M/qlOww979w0n9UJUiQlCQwQ6/K35xJaLCbXJF+Nt+TKZnLQVllndxePDmXJucPmTnpvMhNgA/4BCK6GWRjxHIib/OrHezP5FJqj1saG7lKTvSANSpqEozqkD+FWid1ZIX+2dnLjrcwFxlrM9Q2a6dCOgxNZ050zjuzKBG0XpGV9V8UR9p32BYUmeBTqASmrZQyySi/lP1BCb//8FMlAINLkZzd67Hjm3QAIsNH9We/po16DPFtVmx4Eascmo0Zd/c1mGanVIhm774Z
 KVUbcFnU
 Rr1Ef4k8e83XjZeW8z/AHL3dVXShozWzD9lRgFkLI9pWc2XhOrPOLrklXQ0xqpYOkbeRKiwgu5mg/52bivAoAUpGYfO+sciy18/Mpvgps0EgT/f25fXWP4J9UqoDXCyVZ5GdXCEwy5v0AO2C9GzwVQhPhomUlkZPCqpVHHsfzvmK0/8k+KCEQY6Xn14Fq7R1kB5QdWe0+yjy6AyNryIJgR6xEPw1Qv7Ov2GvFF2r1GQm9Y1Ym9u1g9k/460hnwH5j5DuUky6/q8JGWAa2tL8OqXIzH3ZMrOCVVcfoXBZSPLtQuBaMzLdFLYattJbyPGrIBdhrXmzzDP9OWimT424cZpltpU5tC1BOxiZE7lS2TvubL40v3/nTYWRfycfumfTVrCVUR76Wsl+gBqE+gITbaByWKaG8vJgAImHmCvynZdATiozfte4EmfjFs42gfXIvvaMjmVhOesAFX+4VxGtwq0tT82oqP1QPIWPHIa95pj/N5Jb8NkkJkJfqJt5gPMwQsHqTJXZhIlQ/Jr5JJgAr1Oo3/F0fW3emqcPj6EFVwd7+rVJV82rhbhepjPMO2q/jxu4VUs7GcwycunDuQbtrwgqdelMLn05b/9DUTaL90jtGOXXFlz1mOE4M9Re2VrOJ3aQMZdSGLboTL/Y+PF6reyxc3jZumxk4PNTwhXHX3f0UeKMoK/vOwJ7LFZLVYFEsWbLYyYdV15L8VOQFixsKq/dXFgdylEtA3zxNpmqPy/8VqsdjxUnxd0qBv1/BkY3QAgG8XS2m5wQdWPd6HF0Lq8aJySNNlnFBHSFu5t2Rz8OcWeEt0p8/388/bhYjYAxyKy7fUa7Rir/gcz2CrDSsqCU1rx/+qmJBePKrXcNeAoEtoeUeEVJAHixgCax7A7nOAH/xkxdJSixakd7xrb7idDiU3XaYhwkSRFr1ly21AhjH7umU36Z/35LBS84NSXQSEEIsGJKGRT6SPsZvricbK7RrmLjB
 1VS+v4+H
 XAiU8LPxUFFBzFUIYG3sLXAALDzw9qCpZ7X/7M1gsxIPumOOQqD5QS0Zlh68VNrSK/ZX3gNcKMWBDUJCG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b ]

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index c813c1187510..2a197f54fe05 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,7 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
-#include <linux/compiler_types.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
-- 
2.47.3


