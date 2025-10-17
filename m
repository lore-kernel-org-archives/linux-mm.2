Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66AD4CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C608E0056; Fri, 17 Oct 2025 05:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBE28E0016; Fri, 17 Oct 2025 05:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D0E8E0056; Fri, 17 Oct 2025 05:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7C98E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:05:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27ECC47A2E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:49 +0000 (UTC)
X-FDA: 84007023618.16.54CB27E
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf11.hostedemail.com (Postfix) with ESMTP id 036D040019
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:05:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EjBsmE5g;
	spf=pass (imf11.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691947; a=rsa-sha256;
	cv=none;
	b=oBPjObeG4IkRhEvLV/7qj1E4g48tvwblhJGqmgid0g0l7mF1XyIRnIPNINppnS1J6VN+U/
	fSFGEYTTQwZmFyV157tiuI7BF58Hyx5cAIyTo/QpN9RoIsb4MI5/D7XE0dSZT8NGozQrvG
	wSOGn9/qdkPK0PYOUg/wQCx1effVOzo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=EjBsmE5g;
	spf=pass (imf11.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zbj2mTisKzioKQVYABevmwS3PD+KbTl4NbCfwfEx+Qc=;
	b=5yIcTPl1BzjAgy1ttStFXptMoNJUiobUQ5WiOdXeoIaFNKMO1JLspxpMadW62yoePHPM4P
	xEvImeh3lvLisetAMJfS9ORg6Pytyr8lTPCgr7aWdsBVL8PlgOKjmPFbkKk9kkOEPZtdNK
	w2oP+N3VOnIZYNx8DeYPH4t4sHfGlvI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760691947; x=1792227947;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zbj2mTisKzioKQVYABevmwS3PD+KbTl4NbCfwfEx+Qc=;
  b=EjBsmE5g6IuhonnEMc+OYI0irLxBBm2s0TuOvzSfeuJaGp3ju+bgXSmY
   KqCh07lY8Z8+NYuq9EdleuFTW8FSHIrx7hFMtf5WBroi9GFK/G8FwRmZ2
   L9wevuKrwnl9qEyUVWA8XA+T1XYUNNYFegKuxjglftEZWEC9qQ1e05ZnB
   qTFtos9PhbA/tSIcHCLZUQwDU3xNWTr0CQNe6G2+K/nyMn8tdy5Yyt9tm
   wqPzIeOt6vN2H3Ub46H0cC9PecPnbR5SmLybb6AVr9MAOSA+cZJRFRo2g
   GPitFWIpiiROalmWVj6NpDSNLqlQK29pBHHFVn3LdTL/si/iQ7Suhrh+W
   A==;
X-CSE-ConnectionGUID: sSNJqLpZTHKHoAwfMM8Y6A==
X-CSE-MsgGUID: BK1WnszkRHiFffu8t9LkpA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4877932"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:05:44 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:26941]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.17.61:2525] with esmtp (Farcaster)
 id 74f44794-e502-4348-a685-c94d2b887051; Fri, 17 Oct 2025 09:05:44 +0000 (UTC)
X-Farcaster-Flow-ID: 74f44794-e502-4348-a685-c94d2b887051
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:05:38 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:05:23 +0000
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
Subject: [PATCH v2 00/27 5.10.y] Backport minmax.h updates from v6.17-rc7
Date: Fri, 17 Oct 2025 09:04:52 +0000
Message-ID: <20251017090519.46992-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: i7daq83w7y6zbu4gikgkad7umq3n7e8o
X-Rspamd-Queue-Id: 036D040019
X-Rspamd-Server: rspam09
X-HE-Tag: 1760691946-985090
X-HE-Meta: U2FsdGVkX1+qvc+z9+RIWCMoWlIJFKagItEYuh5YKIzzN5wOY3lkjEapKjPrelWhbQi/b530mNSIhUlVdXwLI2e0lC7iH8ndxkRdI32w48dPekWoyW3TzL1wXX/9ghJuKjqDbRHUxuKjcuCP+I3WZH1NHkkS6pMbGems5LFWX9ks/lbxrVQxSmNCHlK6PhPaTelQdSSO9U/eF6Ch6vW54hjTyRwuvH3ALvUi26EIpKeQxMfRTvQu20j1myoS7DWx3OhN2IS0N/c7rjiiUqeXNxOCKWDjLsRvq5uJ35kaHKkm1rkALL/Y6DVYTo150RUi053r9kxz57P/O1VOArFiCtFIkp82qFqDLVeNfYXvgq1qgNqkHvQEEwsHlzj1n41798lzfjK4VOYvI864/QRm9uJ4a0lyB9bkLKJAsGbscjPmU4hFx4QECpSybthmvoNP4iySa4XBrRYM40jBy2zimslw1N3G8fbwW5Tcsdt1VgGaCJJ8i7AodkX8ruvcmvMLX2mUhSAUYF90TauWZ8eDHbcLHuZHsoqUgnFzkA1L34jslUYnXSLtNRX1PCRjnpnstG1DFCivkWxuoq+krMkwRvjIjHNHsoTTv+lR29HVtjNFJVD+D8jQzdyRRvpZUoZGg05BS/jd2AHm377/u8Xpqoh3dLImhgVw2xBz+Mv0SG9IrT/DA2PS14H0sWS79/M6flBMCQ2p3NnsB/sc/DHjoZHhubXnUXTiN8aFk2BGBSRPnp1n5YcIKHdQVYIBrxgv1XeOgCe0VZkJsJK5gwiRdlzwKuJvxUXvNwmB+oaaHbqaR9wzhUpjAaPg0dDWjn2i8uooIeihDiHdkuBLOXUu3Jr+cFv1PSRLFNY9LA+kxNuTIuax5ap4CXhMb02ByKDriSBgls39L4mjvU4AD9p0T/kV3MRjo6N4hl30IUuhSenJZDzk/9RLGnwMZ6RHFoFtR5sU9ifisf+0lOi3Dal
 AVf4CshW
 X38aYglHQZSTCpCkbT2WA9rVxAHJDTTeS5cPQCbOI04/aQIaWvzFvM8PAngutIy32dA1Sm3x7ydMKLyC5KdlIWhD3VcneqFgV0U3nRO7QHRe3Mk22tiSweW85F7WS5fPcUTgEWUAa7Ctb1V1PsIqWCTEDyH0PAEC8f32OkhWUqJ+TKVEIXkr9eXiC9m8WXxJclMNhKLFRmWPR6V2MXteUHjHtPTMU3upv5PdOsZ9u6I/SsPoWXoXdrgUIgzBICs9LQQ2hst+1IdFaGj/qsTORdtfd1CIpN9DSn9gB8YLAOxOpj5O3+Uby0nKd8C52c6L2DUWOjARUI8gTm/4n4KfWjUNVhpYHFgrotfjwgSFxXJ2uIcG/51u9+Rc3xC0FGHD6bgj78pKaF7CPIJUtz2xPnHYi/0VctLhIzR1V8qqjkSQ2lZgskwQ9+V712DXCrhBjnI8Zh9GPk9y46zYAY+y8FxC7eoLgbHMmzYzyyzd43oKBDjRpYfBNoVZL6WECdaunEMvkGrk1jXGbAlggI4N5I2sI6HH3Uwlhh1zO9EY+RqVYy1qtk1P1L9+EV3EeacMgFvaKbIvzIJaC9Iz+l+s4cxnZtm5+PJu8tZb0tNdSzkil6fgSVzJq4639WAOLbLV1pakKNk8DAhmmRQxI8Pz/I0BQawq6RccHwrezmYBcdqpDkknCHP9AwahRxWWRW/i56gFlfDKJQdAhx7xYSEP1KvPEMO1txqbc88lAlV/j6Bq9108TSNpn4a1/jy4b3NDvetRR47DVpzU6WcD38chj7unuUAKuAWXE2sFFq2FNFpOne6Z9+MTEAP717ALfgqsDbvi4FaM5tGVI4D0CIH4/1jcI4k/kMdXsRTrmN9NQpm77VmUoy8MIYylPjEXKtSIxHwUeo3k6vAOuQcutv5CSt2cz7s20mvkiZeJYGW5tUikTDbtqpS32mecNjmfMkkHQ3OfJ3UPUS14zOoWo8Q9WuK+ulY9X
 6dtOmDZB
 NJGsfoqxTTsFJ7nlO2UuR6odJsf4ZSFuwgtsy3KhoZwItGhd9M9EikxXcTtiR9z8wdM9aQbcYbu8I7qNZQ1PuwtMhJaQ5o6Y6uF2c2y7qWq2AYlYt0dps5kFBGrnv5Bnz2x2MXgRH45nQeCmjsNCUAbIbEhskalqCpYaHf7L1ba6HQ78pQgWSED8MTIjvtdYA64LDDO290nL7e0xCk3lpDuFa/Dcf0vIm5S69ZkKfQGjeV6AjI9G+e0WkAvm+xPfPg0N3Q7LK6qp1WAYu0ZvnAyCHEPuTq+BtUo5uXoFYjrCQUrdy4sNA9I7Hmikv/VglxLflXOXg3Jx3crBJTbHQWNYIFXw65zHzDeiMlaMVWsOSODweOrTKRp+14CUCPzBAWLOi1YWNk98F+4bClEZk9KtSdgjWtw4cHlhzirM20d9rL9hdno9DntsjZDifsGvZ5cVIXCybinkEN8wt6iFf9LIl8LFFLdQcMkiFMmVeUfs0lMo2lYbWNRaZVNzXIVKx1VBGrF9YjJ+rC1QbS4MmZEPIn69BWxEwyRsYaHSCFjHCaOMctMdqHU2809dyxgH9FQ3iS37GT4SUdBTusCVsmC8a0l6bafTs299leQlJEWqiMXXOAhRrMMq8KNFu2CmnEUZwXXpw8vq69z6nVJEWwCE9R4B9vJMjKyABiKbgCIsxiWnuGba4kEG2UTfY8GvArDXjG25d6FuKYhFc9tRASTJevRnSWBCbqp3LX0qpGK4mwMZMs8k9W+JcPPWNZW/EtgRnDe0N54pv+XZAOa2JRgAXwY2Cs/WDVLbCa3bds047pQDY962vcuDhaFRBd5IxLw35R0YXtOxxllMyWr30KdPUcUJtLwxWg6oFmehz7wHbnK5TDWe59+dhKCewhPYzpBy6/wVkjemj86hhEPLhbPc5oLIm6/0L7RD4z27Wu2vnogYEqY+gmsQktIaq1iPR+U2mnadGHGCj+4oAqCjoCsmNe54f
 whlkqBGk
 AG9NKxhlQ9DOhZnwraP5QDnQSLcAiD82XDqx6oMyPl11tDV9IsCSeRVgISpDsrhZMrW1bK3+Fi5afYc7YKBHGRqrkuQTA1XjtlZI7zKFmPOgcR4iZoicbQWYWTCSHRc+4wDTsevQL72UP0oPsaLODK4PtBPmmPaO5qKVYflUG5D7DmlYw792iEtp9UBn9Ec/r0jL4D5+PYq5Ox8r51cNmyPRfIN42mRmJDvKtfS8lDzcAFVzA9Eei8WzsyqvUW6MwE2iDwy1wnyB7sbn1L7Koi+/1GWd2RFLwNKA8XRtfu7WDkzVsJKzgG3Nha02ge7ESy2OOj5c8NuQUR9p8Zn2dCQdfwEzB7RTCPXc2E1lF7BD7ADBVwj9QWqf7yRnIZsvSp9KZYFn/kiPXThSI+jDC3+rVeXwghdh8Y85EuBPgeN6L94dv5xNFjNknWWCw4J0EHz0kejo8ZgtUpHofPuSwYP8ES0GnSqUFXWCnjhmRjSsMwKKmP7bI11b87tJ63CNOjguHbJvG61/n6Q4awjFDzoTadbywUyp6wQYAVea/mVLneo6b2LdRvMBewuzRdg9MS4nU/ZAVaQpG73QegS8xan6UvOJcZVz6790MoZmfWg0/NF3T+z+lJ1J1wp3jvuDkhlsIW2NO0DhnRk2uiree3uZ/unuZSdGyakf2OT3fi5EuZPw1Ecr5wTO0DrGX2Md38vqohA7uKZJ+RDA6U8+srlio5TjTwZpp76Rl6BiheIZNwN3RNp+wnp54IY9rtyH54nf8rvumgtyFRwK0ttaXP/lGe6UnzVhbKbp7SijTjGAddfa7Y4B64hFttFGvlEl4bEsmNBVDeNvRmHd9izPhzTTVHFxorz5hsN+0FbdKmAHV37M3g/if87LljsY2sl4wYCeayu6+YZFReurXfoQLXCn6qRtVpWYz7SVRKLXrHJWDhSESWozJMvC6JsiyHKlqYE+iDLPcvzWfanH3gOnQeYr9FZgY
 Y7r+5C+O
 AZbHv3gz8QtcVg3J72OB+Jv9OlDLFrU5YHyIw885HOm9i37umA6Ji8rrDmFIN/nVpBW60yaGubBMnlqadDJoe+fbdbjP0yJVsU5KdIg+QNmjnULJvEQQt3RCntjoRqzoHeHpMtb/GBy4kNgVbimaSjzV6eAKDs+oBGvDiL5wXBdoCssqvMuQG3uPA8v3BjqPHwGHkYC/yXrqv1Ud+EPKbMf83e6lVUCxjTYd+VnOV89V8wLSQD4kSyD2yE3kzzw0ysddeWJYOnlzq1uP2I0cIZjbEIHp1aUPS+0Je7se/rJCNxQi+daPwQpwBkfy+gWJdGbFj4ziyg/89tJQ2Kyima03FxQOg/vKqyEpOmk/yyuMisRU5ygsbu61O/nfNuybpsy1ew2fATpy1DleK3fR50iiDaQf058Utw8uuarPjC76kKxrF50N+ElfYeDOv3e0VxiEFb5gBiqfUNufG4jV6MhVt9fxzpJseF7OWD2/O9XIiR+lRfEWirpd8xLkZaVjv42tQxIIYrBMCWuIU7OytlICd5ZfuS6HO2u9lFJOWyE/tD0z8wlMVk80jnB5DliSIsYwXoYQag8RJMshdOLwhp7zqXwNwEVyzCAFi6/FSUbvh24M2sH3L61OkKl2V5Hp/wS2Gk/WnIXgvbNBmQBAHmsQ0oiMnohi2Z9u4pTD27ycsEOyenXQdHo9XzkbCE3N15VEvQZn/fMTWghFTq/Qo6zCmwVdFkKAKeRbFDMMYlPFeqYvqShuaHiXN2aL3DfzkUQu9txvU9SgCw0hOvGWsOGRPDJVU83VGmDVhpGzyBMSqXLP9w4tjo1FD98gT3V7W3VMiSG/EgCfGQAKjlRbPXNZyb5AD61LNTonC/eQoOV4G26XLLT9KBibmR1NS7msk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports 27 patches to update minmax.h in the 5.10.y
branch, aligning it with v6.17-rc7.

The ultimate goal is to synchronize all long-term branches so that they
include the full set of minmax.h changes.

- 6.12.y has already been backported; the changes are included in
  v6.12.49.
- 6.6.y has already been backported; the changes are included in
  v6.6.109.
- 6.1.y has already been backported; the changes are currently in the
  6.1-stable tree.
- 5.15.y has already been backported; the changes are currently in the
  5.15-stable tree.

The key motivation is to bring in commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness"), which
is missing in kernel 5.10.y.

In mainline, this change enables min()/max()/clamp() to accept mixed
argument types, provided both have the same signedness. Without it,
backported patches that use these forms may trigger compiler warnings,
which escalate to build failures when -Werror is enabled.

The first two patches in this series were added to prevent build
failures caused by changes introduced later in minmax.h.

 - Commit 92d23c6e9415 ("overflow, tracing: Define the is_signed_type()
   macro once") is needed for commit 75ca38c1960f ("minmax: allow
   min()/max()/clamp()").

 - Commit cea628008fc8 ("btrfs: remove duplicated in_range() macro") is
   needed for commit f9bff0e31881 ("minmax: add in_range() macro").

The changes were tested using `make allyesconfig` and
`make allmodconfig` for arm64, arm, x86_64 and i386 architectures.

Changes in v2:
The series was updated after initially backporting and approving the
newer long-term branches.

Andy Shevchenko (2):
  minmax: deduplicate __unconst_integer_typeof()
  minmax: fix header inclusions

Bart Van Assche (1):
  overflow, tracing: Define the is_signed_type() macro once

David Laight (11):
  minmax: allow min()/max()/clamp() if the arguments have the same
    signedness.
  minmax: fix indentation of __cmp_once() and __clamp_once()
  minmax: allow comparisons of 'int' against 'unsigned char/short'
  minmax: relax check to allow comparison between unsigned arguments and
    signed constants
  minmax.h: add whitespace around operators and after commas
  minmax.h: update some comments
  minmax.h: reduce the #define expansion of min(), max() and clamp()
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
  minmax.h: move all the clamp() definitions after the min/max() ones
  minmax.h: simplify the variants of clamp()
  minmax.h: remove some #defines that are only expanded once

Herve Codina (1):
  minmax: Introduce {min,max}_array()

Jason A. Donenfeld (2):
  minmax: sanity check constant bounds when clamping
  minmax: clamp more efficiently by avoiding extra comparison

Johannes Thumshirn (1):
  btrfs: remove duplicated in_range() macro

Linus Torvalds (8):
  minmax: avoid overly complicated constant expressions in VM code
  minmax: add a few more MIN_T/MAX_T users
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: don't use max() in situations that want a C constant
    expression
  minmax: simplify min()/max()/clamp() implementation
  minmax: improve macro expansion and type checking
  minmax: fix up min3() and max3() too

Matthew Wilcox (Oracle) (1):
  minmax: add in_range() macro

 arch/arm/mm/pageattr.c                        |   6 +-
 arch/um/drivers/mconsole_user.c               |   2 +
 arch/x86/mm/pgtable.c                         |   2 +-
 drivers/edac/sb_edac.c                        |   4 +-
 drivers/edac/skx_common.h                     |   1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
 .../drm/arm/display/include/malidp_utils.h    |   2 +-
 .../display/komeda/komeda_pipeline_state.c    |  24 +-
 drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |   6 -
 drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
 drivers/hwmon/adt7475.c                       |  24 +-
 drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
 drivers/md/dm-integrity.c                     |   6 +-
 drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/fjes/fjes_main.c                  |   4 +-
 drivers/nfc/pn544/i2c.c                       |   2 -
 drivers/platform/x86/sony-laptop.c            |   1 -
 drivers/scsi/isci/init.c                      |   6 +-
 .../pci/hive_isp_css_include/math_support.h   |   5 -
 fs/btrfs/ctree.h                              |   2 -
 fs/btrfs/extent_io.c                          |   1 +
 fs/btrfs/file-item.c                          |   1 +
 fs/btrfs/misc.h                               |   2 -
 fs/btrfs/raid56.c                             |   1 +
 fs/btrfs/tree-checker.c                       |   2 +-
 fs/erofs/zdata.h                              |   2 +-
 fs/ext2/balloc.c                              |   2 -
 fs/ext4/ext4.h                                |   2 -
 fs/ufs/util.h                                 |   6 -
 include/linux/compiler.h                      |  15 +
 include/linux/minmax.h                        | 267 ++++++++++++++----
 include/linux/overflow.h                      |   1 -
 include/linux/trace_events.h                  |   2 -
 kernel/trace/preemptirq_delay_test.c          |   2 -
 lib/btree.c                                   |   1 -
 lib/decompress_unlzma.c                       |   2 +
 lib/logic_pio.c                               |   3 -
 lib/vsprintf.c                                |   2 +-
 lib/zstd/zstd_internal.h                      |   2 -
 mm/zsmalloc.c                                 |   1 -
 net/ipv4/proc.c                               |   2 +-
 net/ipv6/proc.c                               |   2 +-
 net/netfilter/nf_nat_core.c                   |   6 +-
 net/tipc/core.h                               |   2 +-
 net/tipc/link.c                               |  10 +-
 49 files changed, 312 insertions(+), 169 deletions(-)

-- 
2.47.3


