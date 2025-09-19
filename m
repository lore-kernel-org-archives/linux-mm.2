Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F070CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EBC8E006B; Fri, 19 Sep 2025 06:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7464E8E0053; Fri, 19 Sep 2025 06:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608158E006B; Fri, 19 Sep 2025 06:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B80A8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:32:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A4AE140649
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:32:06 +0000 (UTC)
X-FDA: 83905634652.14.7A9D636
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE0C5A0015
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:32:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hsf8BFLa;
	spf=pass (imf25.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
	b=lFrxZIzQ1lATiT0l4pK9xO211IWgMKscPMgwbgICeBM84u+6MI38tA0k8DlVYYsS0LQR5q
	okyhvU0GPOfKXdJnV5wbZcD3FmWdfClhncc8nQR4V80OsSx3l43XjZgB/etLOvRuOP0x66
	EMZPi8BBshTHl7s5ibV+ZnNX5y3f2Zo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277924; a=rsa-sha256;
	cv=none;
	b=5tOarNmfeHA2yjSJUUeStd0Sp9Q47vwzrG7PZDGJAr7Cxd9sIbRvVB1WnatnOaSEaqhybz
	mi/EHjzj1zIkDKNc/Qm/ArSC6DHO68RqBo5SDxKsYfD5wlDad3KAHsU7zsSKRFp/ejiZR/
	0F1BicPjF5dYsRSMrtHUrUGnokcYJec=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hsf8BFLa;
	spf=pass (imf25.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277923; x=1789813923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U4cCFbpHvYq8yWCMIbT6T5sZXi6GGX+iNVIOVWCWFxY=;
  b=hsf8BFLacJgTAHyD52c+5Sdx6Cv01plvvNWbr+JZwrkfhLIYk+2WA+Do
   KTnRlrN7D6bxRV01t0djZ8g5L6L2pCwnM6gRmPfdYON3kKiP++cA+VE1I
   /4tAzNweCH29FEgMJLJKsXnMvOivak6b2ReSfTYPhvcC+2AmvzY+kEgkZ
   gbgWlHRQu+IHFZNbbyoeB39TAm9HzcUe8mc0Glna9e3HFM2sqOJoSz14e
   bbWLvo65Ia2w3bLrlcOA73HR2JiOBRGk1jkFUY9DtN8rQdQ1p2IezHux9
   w1lcOMmtwjYKcF/jqExcIa+EkCuD1FLGSFHZkjcvjI1V5r2B00VuyiRga
   Q==;
X-CSE-ConnectionGUID: quwTzkzJROGYhcrM+53Few==
X-CSE-MsgGUID: 1EL6kEutQc+IuqNFDpLwLQ==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2371334"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:32:01 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:5712]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.197:2525] with esmtp (Farcaster)
 id be283435-235b-4e3d-b812-a92e660027ab; Fri, 19 Sep 2025 10:32:01 +0000 (UTC)
X-Farcaster-Flow-ID: be283435-235b-4e3d-b812-a92e660027ab
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:32:00 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:31:31 +0000
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
CC: <jonnyc@amazon.com>, Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe
	<axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Mateusz
 Guzik" <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH 24/27 5.10.y] minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
Date: Fri, 19 Sep 2025 10:17:24 +0000
Message-ID: <20250919101727.16152-25-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: qzaeoctexiwpyjkfry4bce4okfkusm4b
X-Rspamd-Queue-Id: BE0C5A0015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758277923-338223
X-HE-Meta: U2FsdGVkX19R/y79wyUIfZn93BUKzC+XReUmwdvivKDDyqOzFSlMKnM9vjly5ikF07QVkOxgzXZ1U4ZNJK3/EhEIuVaJ5w33QH0pk8VRMc51AdoT5BQPhcoL3ZJblTWiBaOewIVlPXS4hDeyMdx7E+xU50GcDc9QAInAmiMr2V99moqCVEpDBS1Ll36ZbmxZParKi9JlJrEAYc5KTwvaSJv0um0ND2cXziFYC035PGhXWG1WLCMq+llpzkgk3+2mxCwXF58Gs20qz1yY37ID0cW8jsX5nd7iE9rJI/P7XkdVYpUpyK32nWYYGsHe98KV+2e+7t+qAqTAmlfQwcscB1UvT5kzviAVH9r1zQ9nCrPeI0AxgqgXslfXJ+UhIfeILiO6aRo+TpVyjLa8GfLbGB0yRzUja9NWNghgXdMufI/h0NtiN9NLtOY4whBUo4Id9R791G7/Rkyzv2XVPbl7HL7hAyi7GGc8xZMKhubAkRSUvGsj5rowBlQ+/ut+BcxMPwpQixei1Umga3WlFe5eRw/lXYp7w/ytbt9ghkNPRH5N6qohdRSxIy1a5OC7Cpewe3qxKeCZWRivLWq9JQEomCfUV3U1ns/YENDFqMO1fuX5j5ibwcU6Nvq0vKofP7mQYSyTIMatAxjdT8uTNE3AUiVzxxa5RVs3/qyKZBuE4nSpup+F77W52DotFMU9pQltGOt3jekhPbTuPyvWCoIqe0sV1OddB8y4fR6i4dn4Eaqb0OB+NLZ4Fz6Uk9ZH/59bT28/FDYpsHYLuDbmTERL1sUCZKaVndO+Ep/5LqqzbzLZUc2PqfLrqcI1QIuJvslJ0F96kMOU/h5NuNBlE5TXf1dfDV0IUOPhmp2RYjkhLTb1BBKo9fhYVBtkHqQfPJrrR4NI/TH6jG8QcUIBAI/QBehvLUb4NS5SN+H+O/YRlTnKeiqU3s/Vq5nznZdEuCuSaBkJYfC6Y1tg/XvfTqY
 BlWlfHtR
 uC49VX9ST6Ujpz/wLGTBaMfBKgLFZ0dhD96WNbhW9EvlCibPw1l8Wxsuk3+VJyL0B+nqyKLIJsLap1fe0OYPKExwP2UPZ513+LHawdssf9dVsYpSVUs6S6U+l2CnLTUnw9nG2n9Fn6/JVGXw86VbTYK8GJy0YLeQvts8/00oF76CN2dMJYqsboZ0DvYD0q9rPN8lBBPgdwVpgoqNHVRmdu2Mdkfw1H5vAWhWb3fv2OIjz4d0A40IkUrV2cFkFHrIL0/bZiBGjluaMm3PHNBDUeyOyLgmRMoSGhJzr1+wVqz4IBf6hf47V9wQH8Tzvc8fSzHpOXdaIiPQS1X8320tVmoNRummDiErlm6iRyOuqqjhrb6BPn22xDXveH09kLyATmcJrk8e4ohtGliNj4JUv/xFrYYJeLblMczYsu2Ctqn1/GXeuoTu4S7X7r4DuLZeXSD4uQpoPhCZLJSkNI5sPIG0Ga27H9nU32Nk4DReRV2OXkJGfP9lLlND8F8vVTZBY92PJ8fJ2AkItMPRJDZLJzTV47BHRezEa33rysappvl6Cpj1Z33syPHnCyIse9wrewfUlmd4wNAZc4bcYISVLGHHH9JwVKefuKFHE51GPxSOvroDTaVeQaAemkvhwAEj0xhPbJyTJEnyH5Rf8c8sG13m5Qa+9IcYGPT/52034Pn9k31AJf9UJR1l734nZ2zWGVzF+YJbfOn2CTdB7ig4b0HCXvTIK2C7ioYMBDRER2agjm3O11ZbyicWjkkfHluVFmsxhqtD3UoqJP/Aki3GEmMHFrPeXKcbqZCL4HdowyZGt2XMCNDNFj21nhFTuwOjdRv4ClUzKOMm+YL4sDJcNWNlLx6E18M7kTqN82Q/wt8M3n9Xqh2aa48AshHhaKbFccwgj1vmxeIFlJhes9or75Uqni/fXT+I/haLKpgclvNIkEdu+a/LhNWNdtkiiATa9AjVk+/su+T4AkBHInXbNMrsoq7pC
 YWflenU4
 867InY6nSZw5zFR8N6iDb/I9JZPLAxySDeLwfkyvj8h+Yu4L03VWoQNxgvLafFrRGHn2nr1CEmaDSZIBsVQu0YsHCuha4PkTZ35VVRi4H5xEFbxvTZ1MHoxfJwA71qF6z7CiUmidKNLSj6pccPHT0/wyrZfERKmOL09vhiemS6/TnOAU+Xb2iJVDShdnrr2d9n4+/YvUWo4x1ff72KYR8ehxCCh61zzxhmpz2Z8u1En67bYYDsqaH+lKwrIK8ez8OKxPENNW7txzqlMU9Kd1lI01Qs2bUM/2YyT/92ZsIgtJB/o/xsapJ7+BZEwmMEQCRL//WFi+OZxgsee5I5Wnh03peXJGHfAOFXq+Z6HvNIyUI2yp/SDAabTmBOcobeQ3GOUia9wrQ0/G8ZLXBK12cryEC2aBUcQ22NPtE8pcM8HwpiOyDyVktJaQDw8mEyd7XLGeVfXhqqkcILpgBUYsLV37QjsVkpgziVXjeDsHEUGj0Y7hGCfzzXV18c6Dm/G09HE3xBy77V8isXyL3klmcASyzKT8yEJEVgXKY2stKASBqNIsqJhmZWtzWQD/TLWntoH2kcG83Zg9P8LO3qcfnwPR+qaH9KLf4NjgdPh5qqAKksQVIJG3s0KtR1JX/zq74W1+vhUpoYrx9JLF1Pc7hb7kyokE+/jO7S5TQ3lJrxBPDaVVxSrr6HpH4Egb7+48yu4iGHat35OPHJUqa6SbIOXP4DmTZDP27s8YZTHUQS+BCI9IXYilURqeHMLqShcVrJ61J2GaTQFfsEsxkTjCzIHSHr4pEr4s5sBSFRnYVC7vC4x+gp8dS2xn5Mf2yqqNhYmbgFalDHDpjRUt99gNI/E7fc/BZVpmvQu9Ezs6S9aMEFbW3gFui1xsdobE0mYOQmTCyGX7dHHj2pBprmExITire0s56S3+mqyrq1p6WuI0QMroEO125j8bLZO+zOFKkolEtzq5WquS7pETOwL2NlN7x4Jms
 7skckXth
 JWLMcUMrg3zxo3+22BtK4SYpZkYZX5yu7/z9NVrlxus4MVJnl4Kj4vmTVCL2ssDjiUSIpIQeh2RVxihQZdAUzSf1obhUVYQZ3p0HQDqpKrlXNT3RMNqI5yy4VRESaV8K+KlHwWIqXEjTvGcN0mlkLYJlBaWgT68khS/ncOlQ+wUS29wZk7TmYS/6lZQbhVALf5xVSm4xL/v0kB9tBe8E7plX0MSIC0Wiylmglvvg90NoZ1M97H1/Xc586/PVw2EmhIlM/PV9VyILozAV3DreCVxLTITy4Gm1NpPcbjyqTIYiGDyVU3B71rhd+7VQjOgBCmtf9Ztj4IQP4lTPS9WDL3jPWVltk5hgJQYq78vpM1nPBO8yBgFDbqG7/V40cnQCSHo7URdheQxjCyoDXBGeUabN8NHMf12eropTjyEPrU7It6YRvWBKFH6QPnU+Ty9TV9ZlV6LKBv4Nb6s/7cXQ4BGA8j3B8H04d77SfrfxejZ7i6xztqUrhg06hz3we4wy3IqnoHTWMwKqegfUQnCJrM/blgAeqM6ZbYk5W4xnXv21q3jkQ8Zpf1sb9MFSWNIgvk253YC5N+BcMISC1bwthYZbHktkz2rY+jwKDz+b0tpLL7IL0v8314CTV2HpEoM2ntmEUKeEYrhEccF5RkWDdjo/mHPbAZ8tbe+aL1wjjyngaGkJWOQ1GuZarZucBfrcG7DMCYOjkTXKxMAyRLsAntoPnJEdfeASaNc3De9XPB0jq3NgUW/i7LSXK0fj/opff4pzzFXMY+XtMtnRLOf4QLDc140JAddC3NyqsnbsBocqEsLvD+PYxO7bEwUneazQ/c+aSRXAJGx9hZj5CbwMBX76YGtPY2NGiowhZ7gSMx2Rvr+HSJL3H4qXyWOvet2DEIR2L+P0myTCIMEFuajMUDDOXrnxY/J06nFhaKlaALJZ4TALP5vH8CEazZyowmTG7hkE/TMzk51B64UeRyDSxjfe0GGYx
 Nr5VSsD+
 Q5WtI+KPT/XhKznqFDWLk0TUHAcRgDO2m45zFTqEYIIoviyL+K8J0ggjNaefDl+yCLIFQ8Glvv8Wc9i25hsVcfZDUAYwHzo1TMQgcPRz0zd7w2OyGJojj1Oy43DxFT7pt8caljH8mW1j+lBSswac12eFulK8JuYS4HN2DqVstuZOgX+dYobVGd/JqrnbCuazzw6W3X+21pj59qH2ThhQWt1bWk/+TVlp3pBqgxF9tvcuXlNnJ28AUup4tyj9t/Ix08punFd28rilZZIowfe/sz/sLuIlhCSUZ5/AqosX6niV4XZBQSG8wK4itIp/TVfyV7Qlbx3T3nXdJxJUalIEi45bVF1GVmBkWe7qkFOhVHK7a5ms8uJFdPOgE49z2AumrR2Ez48br0giEj5Q36Han8DAa3n6bqCYfb9adhvfgwxjh0AVcpAa1IhwKPpyqDGSU+BbzbzSngcvDQpAY0zRZUsErhBD0bev14fgs9+zHgNWu26+BAFwri7mhEPICBtf0AO3lBit+ByGbhKHNGU/XVoUp0IytjEYPfYwvlGhrZECn3f+z7irnEMf6PpnRkBFIbagNgV8XWJgRkhKHbkdEb379Shf3/hYnLPF11sEY805misgWz63pzxaonJqXWmlrtovP1mwgE8jca9ndaazCGteFj7igkIgKgWmZfSpHp5Mp0v1EJKHQssZtJwPRbiJx/34EVQaoYRXC43Va/cNhOPmuhnfSDViy4J2afHhb8M6jwX4puncoZnhrqKTIavRJDF8JsghZ4R4vKK6u3Ezap7/FHx0tkIXShC4p+Vww/lGfJS3C73u5SlCqZmT+I2kDN4wrS+1GambUYmdPoBjbr04YHPOlHt7xglpBFlxNMfrsnINrG7Su53qGoA3GXipQcEWq14ItbHjfaUl3EAUGJimaq3EA4dP2EQoOtis+444rmJxZN0CUgSXPN8PliNfDPibNj1AL+TsqY0yS6ZulHx55qVGc
 CKpgS94y
 ND3Wjw92jAl3y1raFajSzuwz2fs6sm4T5eU+3jadJBBftLhdeu24cvkF68sXeWJf6c2QnzDTWVq6LnR7TnIwZzeQ1LE73QV7MxEAhSItrbc3feVcnymdgttJTUS1yl2kB5FUXuA10F+UU3dBEWf9/F6eYtEO+iGthANAPsSGOFlr1eYCqC7E2+ku2lNP5mNEOS7WZgar+SXTuhqfpoa85Y6iam2u7CnG6YMt++cDit1Q5j6JpR7LQ9JMCIZuGSA7UiAAhlfThjhgUREQ8ZbCsC6nkvzQs+IUKejLDeRdourPdvMZSEsYf7NQzM57rdELm/7cwNKbOLZt1+d7utOasgrVw8VHdmgOdfAatZVb04ahqPyw5zRHgBE4Duv0yVZsmVn8wWuEDdpz2IuWy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit a5743f32baec4728711bbc01d6ac2b33d4c67040 ]

Use BUILD_BUG_ON_MSG(statically_true(ulo > uhi), ...) for the sanity check
of the bounds in clamp().  Gives better error coverage and one less
expansion of the arguments.

Link: https://lkml.kernel.org/r/34d53778977747f19cce2abb287bb3e6@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 6f7ea669d305..91aa1b90c1bb 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -106,8 +106,7 @@
 	__auto_type uval = (val);						\
 	__auto_type ulo = (lo);							\
 	__auto_type uhi = (hi);							\
-	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-			(lo) <= (hi), true),					\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
 	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
-- 
2.47.3


