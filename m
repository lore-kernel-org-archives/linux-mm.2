Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E14CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ECE88E006A; Fri, 17 Oct 2025 05:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D0D8E0016; Fri, 17 Oct 2025 05:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565848E006A; Fri, 17 Oct 2025 05:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4071E8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:11:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D85DBC05BD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:21 +0000 (UTC)
X-FDA: 84007037562.02.E0733B6
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5E1C180003
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hkuEvxoL;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=LJHe48qDmXHO9OorQYTKkQglQAvfgf5iDQ7aLDkAhD43OjrDPLReS1IuAFoFTj9mP0hMrI
	Iu1aotdi7+Y0A5arFH+Xrt87bT6FLqoi/gCVP13IeS9AsFpR3Hgnt1pRmi5QQTT9qaBrAT
	mSUKZt9NVBc92MLIBr+7NNbshHeDOQc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hkuEvxoL;
	spf=pass (imf24.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692279; a=rsa-sha256;
	cv=none;
	b=h/jNUWfzqp54T7XKEnNflnQSO08ALwa1YtE7YsmRPtusuo0O0SVSHB2sezdHSHFCyYGzTE
	soNKsTW+3dNfUB1CDKavOBDUWm4nCpTRW4ZtV5HpXzFMKbuRxbHcy4lbgZ6v2Xl5glMKsq
	8Z9lHvCos+ybVV0esLkbzRG6CNIqekQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692279; x=1792228279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=hkuEvxoLBBO9KQ7ywvYUBbtE2zbtdfRgl3ud9EdWApjlfjIlxP3hRv+Z
   UdkQUhPvc6In1aBckjJ9M5DyG9VsX79NEa29P7CubPSEH4JOwtDzqK+Te
   MwvrpnYDOoGe41rDMNl1h7D7jk2wQ9VPgokcibejFQ+VG/+FK5Vg9RVmu
   7gdEmn2ZwqbWJ8F68J0f63MJHH1B442KIfNF2IHDMQVcB6U+Jdae364iS
   YL3BBHF7WB0sqATolfMyD7ofkoHTaZ1/ng/iI/uGD2dwYe991dfj6FQm3
   ddXYem7kblGH53UT6U8TRzk3iHSyZx0Xwh3twxCPYEGtA5XEznoacjS/f
   w==;
X-CSE-ConnectionGUID: bvFDhyT9SLmGlFgexAA0bw==
X-CSE-MsgGUID: raSAdX1vQBmjH3RIvo7BgA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5070433"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:11:18 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:21760]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.52:2525] with esmtp (Farcaster)
 id 89e4dff0-39b2-414b-b1d7-2bc6c99d0f3d; Fri, 17 Oct 2025 09:11:18 +0000 (UTC)
X-Farcaster-Flow-ID: 89e4dff0-39b2-414b-b1d7-2bc6c99d0f3d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:11:17 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:11:02 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 18/27 5.10.y] minmax: simplify min()/max()/clamp() implementation
Date: Fri, 17 Oct 2025 09:05:10 +0000
Message-ID: <20251017090519.46992-19-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: gyk3fhy84zquo6fssaqgmg67rxwud4pf
X-Rspamd-Queue-Id: A5E1C180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760692279-83063
X-HE-Meta: U2FsdGVkX192M1uYYwg+tRAnBqU9c1a/TuEqrGMAR1JmR1iE9tL2+m/bT8uf7ARTu4ca05eMQDhi+8wCcMOEZsv60m93N6mCxNZJHF1OSIskcTklSlQcPdOHvwDo6HTbq2llUuA6Sp4NUtKAN0PngFFgY1FbDqAMbwE+XNd7Qk9I7YyqV/JtL1LfYEXOyQSPUYomZ98+hAWT6SxJkaVB1E7h0abY74WEMzk/1SbGm5bQoHJKwHB8otpZHFMNWX+g+yGYAyYSTDNQKoCOb85I9Jg7lfg8O9CJXQa7QPZ2zOtqNCbY3hhVKnbcyp2765CRDGBa6zggaVTLpuPJrJomgdFtr92r/P3Q3RxPLqeN/RUsHnrHjE+qVHie8lSexASVMoEUZot3lbOKlp8nZGfVXkj/YQNC8OcHq+geYBFXoHsvzkIX1MuUbS25Oo+S18JzjZX3cJEUZRTPoHgaj1uZG1mmRLGFUVU0d3VZxqQq38P3mHQ62Nf8aZKl2VVvrDjbjDuv/ne/Tkq9+mlj+uQRSimbIQKKr5/pr0IKsJAJzYh7u/13Z0RWI7P/hQlSZGGb/NzSsY0ruRCENaE32KCLoME4nhNhp73VrUmnAtwIJw/T8SzaSyrPQ+N0dIzhyZkSNDqgj8hDqHwOtUNoNYsGvc+Ik1PLuHSckABqFw/IuJLmIgitLoCezHp4O8rI3tLx0maQkr1+j2H1dTVNQObPn1Lcc3gM8bYGKgHug1yer8lTcuAPYtzsy2Hy0WaMdVUzre8n0ri9xuF2sTU6Os24Gv3UE+SRMVAXLDW9mvRQ+afkoDmF+ebGSX8OLB4Kwn2kvrKoR7ATh1AX30y22ZCsVVhXszN/Ec4vkXmXHJlwIQiKqCVj7Zbr4TxQ13Hn0MUyneEYGix5DsA/rLotyKD8BpqogOfG2cyO5CgobRKTFToymOOmRz5/HHTeeHNMebvalXT2SGQU/gXjxtkqmla
 ihe8gvb8
 ZydDTMNFA7J9Ugrxy13IqetQdjgHa8oki/lBDnjZ36dQPoQEZASusBmuJDCLUY2kltf8ZesbskEnBkCviYslL19XVI1/32CegYeq22VSO1ZI4oUveVhCa6QaGMUfEcJ+Nbzq0yCx6nEsUfrPcxOpHEBXP+GajruVjevLEH1IETdHlzpvTD8znkx0XN4hiSZ/RJ4V5iBAjOKCwyHflLerHIiPZnfAsbgSiEkSXQzXMYwvsnlxLQMU+fUWrgMafzcBcWl1niaOJg2IeycZNF0f/W04aAeuj9bwIyxX2VgnT2UDrzAkWyD1C0/8ahHtvNWkuZCsBiIJUL9y9b/kauw53RbF1SYD/bAQ/6yZD+PjUR0zd7opkMZ5G45OuP3OGWTpCg9jlClBWN9KYF0YocIMCZPRJfwgrkrAyxKkpburg2jI44kdOJrBSsJyApZ0hZdVDZ6OMzxe5oQN/Sdrz3eLZbW8HAQOmpEh/Do7mJJ0vZAW9TH/FUwG9lTbEuJdJxsnqMobHsw/Eu2c4V/RP+APQPbXrvdmd9DNzFpWP9lwMKhzX8Nuwc7Jjdof7odNgzNo2CylKl122Mkw8lr6swZu5Bs0CbaQF6fKtj3gqR2PmDiKjdGLAijsr62KuBZEUsGjEcnGuO5EL1uQsooUgbF0vWN76iwQ+BpzeMqxBANuErz/oq7GWpwJdNazlcRBenNNVaKfoHEDUndSVJ7zVSQcrfNwwiYtNAU36O/BQMTRkaBLUKMeQOyEYiOT420gykrJ4bgdfDxpDxDrekBamS7VJ3Zr1jNbNXeiwoZn9Sv9eBtBSpaFildvkj0FUeEDM+/vGx/gBiGuizVh4adm7aMz0DNIKwImxZ/2GcYcJpY64CFYKvBUZiZ8EIHE7vhEcGzTnWRMDXu8GZZA+Ep5rAf1DvRPrbwKW9j3vmjr3iiwoaQb6W8JLGK/pTWTNaO1rvWRAt4b/iYzMon48shLA1DX4SrS4EenX
 GMsfgeDt
 pi01hCOYD63tg7/m8Srbax2OKOLiU70JPZdYdsMX4AYawCyGdG2Syb/Pdh0dwRwR2aGvyFAB6vQbniS9hLYjhf73dgVCDG0YLnPmdPJ2B9zim6m7CI4uTbBE74S28lR0QGVytRlbNdxbHu5rsUsBvItlPah1N9tjOaSLuSaQDDj7DiDC1MfKB4FvijMLD5DJer//m8IOksdV157MuPji24+yC0YU2CctKwU2nOWGczeK8ppdN9UwvzudHXZU8Qa4xhLEhUHWHlNU8e+ybAGOYLfMOyVwLZiIBsA65VcTlybxKV5BszVhl+iUufx/bGE8DZ+QvLo1FMCErFVmd0K/S98uYAcEPMkiSJafQxJnpWgjDQaRCg229PfR3H2fGw83lAStj5bwz0+8oRYtCLwd5S5TK1+d0CDmWKb0KH0c12yZsBM8YC72lfodjhoCONZ9Yvt6bc+FNYJR/WZEp/4t0UUxF/UdO6tTuVb4+92QfvTlfFS44GR4toMG0zpQp113WP2wCcTadsEvSoHJdizz0oLZXcp3uTV+SPZkM0trlbBQFanPzZFb7fjOSUNS9uDAaqU1Ceuc1uMqh7BzxBUaIK8njKgg1SflPsD0sDQesxl6gZ8cciO8pu3FnOf8L4hcYTwARrdeho+i6h4sQgaw0rep2hAwGTm0DzBXUJcabNhC9GEOOVbLn6AwSkWx/2+/4P7rBYbjQgy3QPLHyfhVerjxgztr0lrQJ86fz+X3K0Br1TEDlWDEW9+Q5P6TzkTxDw0FODCowkIR9DyJB/m8/DEqx9loV7fW819mXsSPyGoMyGuy6LigOUYdRhb3me05OsTD7oABPyU8CA3UUBDcEuUAYoxr6FuXxBKdYNF09gdpteoxlCNCp56S4VBez147cqYsCSfE1oQ6OiOClBgsFrMxfHmF55hUeQfg83C2+B9ShkPy8uZgTwPqAmf01me01VvOieGb0dfypNK1diSCE7vcSmQCc
 OcZYFUAu
 d3ZTFXLSOmNtFjKu5t1RxRy91JT85Vzw9ExY2ptlbyuUg0wtaUvy8vS/YHXvRBE4BGDSNZ8sfsCE68l9ZQxT4DnGIWGPDsrgUuf/Wo/c1hZMgOCBilAuYQ3feNOlQZgmwOkRp5uUjDhGWrXy7Aj4xyl/NQ0pWBHxDGd+kOLPuSDl47H3n5YJBQAVC1jIg70y9HzH57e0d3RsufkHmjA6uK6plEnPCSlrqXbIDlVs2h1rRGDaMS64gNxaGrogR0YIgOc4ZxRkqAvza3MYTwUov1U4Nyp7R0P4K+lnEMaar6hpeFLTyGjbOTuXD3m3df0ECh3qgYngBGZCaCoB6CH1PyttePQ9ULHhKXvaSfw9AF1ZF2KMyNZcJUkXj0BIEyEIhGkFsAGL1SZ0IxWXhtQAOv5dvJkmeMmepXkepoYFghL/SQppLmQLB1Aixwn8Epqc6kPiRLnfSKxPrF4GO1vn1w9ZAfQvYhTqJYQZOtamx/drMqSDh7uypX0RgoBvrc2fr6GYj7niFSPJPxg6f63Hl39Yk++yxZ1az/nJ3j7MrqChgymYnnrAeLMsGSxUUxPjjW9JhHD4VjSnOpWSo4Mq928/xP9aD+amFNDXI5xpf/PZ/Wx0+vDK/EBYOeYxExJPhZFRGYGtNBxUxXMcKF9kJjrR+XuxVOUJfBJyJBEcsdGjm1/wbfphf2js/Qff0tP3L4ZY6CbPI7VxNmguK93OrsVRaCuqSEHxJXfOg/9+MyHDNvebKGGEwb4lGQdo1hFkglHxTYypEG/l0TlowWomau4R++9w9ubEuTa4K5CCJvUBs4dX2C7xixh61o70KD49hAxfHGQ2yKh6v0ZDYB5yPr/TxXiqCbSm1gSp1GrzIgjZL7e5XtCyYESbgVbopRdtJha3yvStzehf8AX9qftPgCPMDRUSD1kkMrKwt7V8YJEzKrLZ94Y55eethqaeWVPLKSy0FdKfhfVde9meCcUOqCVVTS1hw
 gdH1JC7+
 ltBZrRRTXXPUqwOt4HhhRYG65YvYElTJ27rSA4F92i5pHHROujhPbS9xWnqF8C5PEmEcD4JliJ7MiZWE3qNp4v+ZNmjPqrFxiPSqzRR4XAjhN6q5llPGc7FyWUIlizxYwLE3EAgeZHzP99DJw1uJVVdX93nHv6TyTcSQJjxY2zuSVYFwc+DsOjAtrBO+cB5iDF4ET4Z0p/949j/D+EIKacQJOT/WeVdFv2GZcif/zKhPFBuCSR3oQS5KAOJsPcM8jnEnxh2IIsDkIpiaWInG6G2lcxkrY9EL9jiz7G0k0awv2GHpB4rHmyWS/OEqib/SpBESTljT97jM5HKTM6lzwWXTevyamrU1XoI1ukdQR7xMQVn3xdqDpJywk/BYpONq5zEHgyU4Y6spT72ujuYpPkuQ4rJLGz6Wqw8y0jK5F8KKVfKenLFf/sdPTIe3JUaIMD0Ygn+8AuK2ATmXHf//uWPAS8FZdqtcHiznvM1UJPFUssQuRT3PYxiH6ev2x9HDKQkYiZi+GA3eaJKojWy0X9UfECUCaKUI6YXGzbfRPVCDFIsWwaUe1Ffpu4qIdCLAK7ylNglnrtqiM7bQaHreWXnfZJbJpXzVyjRo5AUtetb20VXd7BUhOKijs+IadWuHaMVZ2hZ8BqEIXgG0V8qXTCLPsLezV5YFHWlNClFONDsDojJEiS2c0aiQDcsZ6afkA2Amy8dP5DKcrB8iQBY006uGi9LujbHEDi+0C8CboPa5RCkFC99voPTevSA7iUi9bZVJlIgKHmiOxW5G2t9cnT82bCzvEvuPggQlbwtm/mznr7GInNx7QP4LyQjA6rBwmdvgD55z/q6Y7QKTuFQz50dwWlFKrRqXPUzVlZMrlUhEkew86H3GgtbFyo5pg7GQw2agWmONFgrJZ605QWmH0fzBcKxof2efUDJnTBeUo1WZgyyEDwvljVwtI+RdaAZZm5C4J5uCUCse2enHSa/rgXVNvWqn6
 8cIBve6K
 i7Lr6B9M5X0FYog84xA5n/F8xtbNmIQ94G/x36bBmjGnd0omghUMxJ6qWFmMhy1u/sIgTGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dc1c8034e31b14a2e5e212104ec508aec44ce1b9 ]

Now that we no longer have any C constant expression contexts (ie array
size declarations or static initializers) that use min() or max(), we
can simpify the implementation by not having to worry about the result
staying as a C constant expression.

So now we can unconditionally just use temporary variables of the right
type, and get rid of the excessive expansion that used to come from the
use of

   __builtin_choose_expr(__is_constexpr(...), ..

to pick the specialized code for constant expressions.

Another expansion simplification is to pass the temporary variables (in
addition to the original expression) to our __types_ok() macro.  That
may superficially look like it complicates the macro, but when we only
want the type of the expression, expanding the temporary variable names
is much simpler and smaller than expanding the potentially complicated
original expression.

As a result, on my machine, doing a

  $ time make drivers/staging/media/atomisp/pci/isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.i

goes from

	real	0m16.621s
	user	0m15.360s
	sys	0m1.221s

to

	real	0m2.532s
	user	0m2.091s
	sys	0m0.452s

because the token expansion goes down dramatically.

In particular, the longest line expansion (which was line 71 of that
'ia_css_ynr.host.c' file) shrinks from 23,338kB (yes, 23MB for one
single line) to "just" 1,444kB (now "only" 1.4MB).

And yes, that line is still the line from hell, because it's doing
multiple levels of "min()/max()" expansion thanks to some of them being
hidden inside the uDIGIT_FITTING() macro.

Lorenzo has a nice cleanup patch that makes that driver use inline
functions instead of macros for sDIGIT_FITTING() and uDIGIT_FITTING(),
which will fix that line once and for all, but the 16-fold reduction in
this case does show why we need to simplify these helpers.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 43 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index fc384714da45..e3e4353df983 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,10 +35,10 @@
 #define __is_noneg_int(x)	\
 	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
 
-#define __types_ok(x, y) 					\
-	(__is_signed(x) == __is_signed(y) ||			\
-		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
-		__is_noneg_int(x) || __is_noneg_int(y))
+#define __types_ok(x, y, ux, uy) 				\
+	(__is_signed(ux) == __is_signed(uy) ||			\
+	 __is_signed((ux) + 0) == __is_signed((uy) + 0) ||	\
+	 __is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -51,34 +51,31 @@
 #define __cmp_once(op, type, x, y) \
 	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __careful_cmp_once(op, x, y) ({			\
-	static_assert(__types_ok(x, y),			\
+#define __careful_cmp_once(op, x, y, ux, uy) ({		\
+	__auto_type ux = (x); __auto_type uy = (y);	\
+	static_assert(__types_ok(x, y, ux, uy),		\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp_once(op, __auto_type, x, y); })
+	__cmp(op, ux, uy); })
 
-#define __careful_cmp(op, x, y)					\
-	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y), __careful_cmp_once(op, x, y))
+#define __careful_cmp(op, x, y) \
+	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
-	typeof(val) unique_val = (val);						\
-	typeof(lo) unique_lo = (lo);						\
-	typeof(hi) unique_hi = (hi);						\
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-	__clamp(unique_val, unique_lo, unique_hi); })
-
-#define __careful_clamp(val, lo, hi) ({					\
-	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-		__clamp(val, lo, hi),					\
-		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
-			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+	static_assert(__types_ok(uval, lo, uval, ulo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(uval, hi, uval, uhi), "clamp() 'hi' signedness error");	\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
 
 /**
  * min - return minimum of two values of the same or compatible types
-- 
2.47.3


