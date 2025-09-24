Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311FECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E348E0005; Wed, 24 Sep 2025 16:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733E18E0001; Wed, 24 Sep 2025 16:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623048E0005; Wed, 24 Sep 2025 16:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9168E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:24:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E437711731F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:49 +0000 (UTC)
X-FDA: 83925272298.02.8D85EE6
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B72880012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=I577McK8;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745487; a=rsa-sha256;
	cv=none;
	b=deXSslPWoUhNn5295FYi6cmzdASRYLts3yoRdvmm0QV6P+pSFl8XNv2yjyAzi/R+oXPGm6
	PIG7i+dNDrg60h2UgxlDQWFjAwl/dlfWNqrspH50NtZqXbXFINCIc1u3i8g8EyupNFG7pk
	1Ma0JxwDDX90/+fUwyI0dUb7C+9U24s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=I577McK8;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YxqVAstefiwEeBBwXrOji/xXNmlzL5LR2jr+zgZ2zI=;
	b=E66MhKjfOR5uzQA83Bmc1CbPhtuB8DlUeT1foxPzDitGDfQJ42MO0G8AbpyitwK1tqg89O
	iA/TM084aquIs5xR3+MSaw09ALElC9AfBSdTr7MkEUXVBaEFPn6naaIhqN6w3u2cRKcAwL
	Ox4mcMwYhxDU0+SUYHvIhoHBjLy1l+g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745487; x=1790281487;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8YxqVAstefiwEeBBwXrOji/xXNmlzL5LR2jr+zgZ2zI=;
  b=I577McK8/yXhkxGhLtNSBqCnlbiJlPxNnnbH9pTVlKFKUC+hm/GduUs5
   xvE30FfzZ4+vBK28Z7w9BD0rokKFtV3inVtetWqTdc5L+bFE6GiSFyHmn
   9B8DoikkAaWqVobzy9DxLCNk+etTVcrHxLP4mfp9UTDiHvPkFJARewfzP
   PplI78AAWYs8NiAp+bYBX8K4KObuwlmtPBB7z3iakdF6fNijobLv218TO
   bl8uSTNPrdqL8ijnStMZoS8XkYjV6FchCc7t0V/zPNj5zTxMCMz8A/nH3
   XphFRunbHgY0+uwN7CI9PjaNftIZvGikPy1cmWjFtInl4pECbdSq5LGeN
   Q==;
X-CSE-ConnectionGUID: 9AKs/HdNQWKNk5hR/pm0MQ==
X-CSE-MsgGUID: wEFGQccoS+SNl0ASxCSO6Q==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2630729"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:24:37 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:5085]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.71:2525] with esmtp (Farcaster)
 id faa8ed04-2e91-468a-ba97-699cdaebd778; Wed, 24 Sep 2025 20:24:37 +0000 (UTC)
X-Farcaster-Flow-ID: faa8ed04-2e91-468a-ba97-699cdaebd778
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:24:34 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:24:00 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: [PATCH 01/19 v6.1.y] minmax: add in_range() macro
Date: Wed, 24 Sep 2025 20:23:02 +0000
Message-ID: <20250924202320.32333-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B72880012
X-Stat-Signature: tg81hudu6zirmg3xkw8iyhf3farm8pr6
X-Rspam-User: 
X-HE-Tag: 1758745487-41349
X-HE-Meta: U2FsdGVkX19Uir7RYMmgcy82YEgTwoxRsIkqx6KNENd/syYuEVFWVaLlbjQxnMjceX4IjrCJ+aOvBkqNpCchlhuYIZhYK36lqaUc4qnNAxnX1fe5fSs60H1QcVjaERjFqMEhdLItT5G+8HKc+z1phpj5B4B+QV0MmZtb966qxKrXLGhw7lUxrx8NRmiCJ81CKr972LQNHQdcnFM5S2JXvwBKkNobyHhFEWZkUrx+stWa3jKdRAyfyricnWojRhQZ8myx2/qT5WkJvkXvfux1iZRjNIWItZR1sEXNXRexCVCoZFy4RLz81oqRbJW9+uc02wMXHb4Mxlb/gkauidqzIxjvHPLGHixj6THgLd8oXybJkbm8d/gbFDDJSzti9QcLOfjv0iMI3MBZeuHr1VgaAbJqn7lCq8YvnaR9oBg8I4NzMejqieFQa+Oxg9EUmLU944qbrwUAwQfYgYVlDTZlU+zrarwwsVPZQi1WfNxh561bR2ymdOx1ozMcs+A9S31b7cq48vXRZmIIh37Mni6xlQoipqJ4eBF9dIUFl5AKV6c+ofF+qRXf3gjd4Kv/opDZ9hQjgcMftjc6XbvvB3nwjc5KFOZOTFIDMZSwUQIxPK7NHgjFa6bwRxXRnTZuJR6zh0y1yLprd32XYkKe/Ni6GcbQ+TycEzsORRI89dICHTFwPpr2bUD4b94vlM+gaJWopeDYWZGnZS01IWHSGB/KOW72UcIFKIHJXqXI3Z7beNyWS7wLNyRCzBXLD3bTrHUtUtQWTkHhB8r4ddXw0wsVLv14Xuvq4nvqohSmwb9zObD3oXOWytQarfgCnHl+rszbWIRXU9ZIUx9V7ICrcKEKDlp/p3rbw09DZRAcoSUoAZEvTt70fPwgO93inBriBEGMmbHVBPqVpwWpVX4AkvQXsA+PCSI0YvdrviE84W+jUZOlW4iehDY1Kc4ZIFJ7cpmrwcu/GNP4IeX8sG+UX3/
 /2DhtKDR
 lLrKgqrL49/EXArxqyvR+biiPYdpwSsYIB1NEItaqU6gZ3jdHDDOZsgzBkxJhCDX+UY2z9A7tmqq1Bw9BRL4yhRZPKmsPfhuNZUsIDEnVd1yhlMSAUbUtGmHsdJgzHVJ1+tTZRbigErMU5PgDsCk6EjmBesigc9UIyHMtlXFD9J+6Ry7gbQMjtdMaThW5BD1nxVDwl3FXeh2L5b9CJ/lHDJsy1y/DQ1hlmZFkPZzpUu15lRKGZCCl3soJhxDAcDAzMImoIiCCljPE9etk/gU4JNrzXEV5m2Duow5wlpFzSFZnizv8pGOoAgCF/BG4/M57FKeWqeoc+AYCPmaqp0pjO0F6wXffgCQwoonB2dtQr9OTspV9A7Z5jG6XeJcE9Pi9rUHdr/L1W+rLvviOGwWD2SntyzmcKV2KPlAcvEdOUFNQMSo1WEWzQDA0dXQhm683j9vhO8z/OPR2JV65WZ4UoRrY4fWuhdXGqUFb9Xl1MU9EhjsgYjl7hyyCj4pIKidFqcYJFTBTkYDngulKGLXtHjFJQz4kgMz99eYndaqBF7ZJwWsNicvcrEM6aPBYdJVc9HwiGkCp2f1hoQ/qO6ODfgDUZGPj6D8zoyDNDJurLOTaIdc4S3RgJ7E/4dMG/GokuDw4Wvj/YE5m7M9sXupYnj0F9linAAYZBBFQ2Il2RgUAi2OczQAC3HpopWs8leeTb3dfaohEIXf3zEhLV7aHEK8m472pez2S/r6xC0uqZ3ovXFDp10dk7k1+b0CL0zRvkX9fX5KCCMxCRWPMktRAey0pWK1yJdYbYClaTQ7e/FZkq8rr0WZ8QyY2+S2pxAeYwoTKcG5oDSfBFBE4k33CYeOq8A7nDZnjESg4t2vfceoGYzpEynzghS2mgRsVMSnsKG5XuzlIuDUpBhWp4WahQcUdGDhHJoXaM8m5r+XF2emw+cplFk1ZSWmLw+TGEm/VyyuLNDXeuwPxAQIxcahe5uWceK/s
 FVVgUZ+q
 //USGvNzyO6NNunCms4efbIvFbN1IETaraR8CaI66jdRViDywWGdDUG0c3gen64qLrTCB2EVcR16DB2H5+4WEcqh+qXAu9ATpXFDbimZaDyQwgn8XO67qpYiABfLzWcmJMXfiz/k12ph17hOTvFS8ng6f9Fd0SLnVTeIUbLvEomnstUfrVWTV77TN6fEQ08VH8z47MPnd+0u/vypStJaEuFctQwc9NP7CS0VgGRAiPTTNvrc/jbtoHB2OJYlF1SDX9mNwHHWRDgEtHW51aiceIaRkIXav/P8GSghT4N9fyfnGQcIMP2jjaRVUqV1M1rCWjJA6WrKOmJNaNTUXE6EzfrDjf9PRE0/rf7nurF0Pu7LORbZyjTHEpbWpx1JRKjiL/40nkYSf7dnBxv3IleqEcRHRHktTg5MPwC/jhCyWFydHEHgQWvItx2RiS8mQDBQdkQo93R0MrMpCM+HjCYwGaWbS/RUNcMZPFL3U64TwOYRqJNsqk4/r3cJKtYC634umY/zQ+P/t/9UIltIub07EKfAehVQ3uYBp7/e3nUTlAGhDnjJ5RZh7FPIYd01J5JLjUT8spmnGJ9n+S7nIgywiY4q1Ja2YQiAlezo2POjokwrj5OO8ZxCbsl3XPwiiC0tqoHMlZ7FCBHXB6n+iZAv6MCKFY+tEavCxRmsqiaZ0rUrbygGVPw5hFm2ZqdFhs7p15dn3IeYQ9WGI45znLwlaKOC75IVf32ex7n+Hdhzap8GPhY/REqcmgKoswR/OpRoi+qhrD9Tvmrw0J0KxjEzCeXlKmf4ioIJRTBWdBBuocpUcnz2hC5ogknK42FYf8ajXy7gjGGpauSLnezYZkLMDuepnteo2oqME06TvnWFvg4qnS2IfQGUUgboPe3t5n+DV3RbxGUjri0YqKJnKGkJRiuDxLaakvIJxHLiz68jlShG4j9B3smnJWtEHrlcJU0MAbpa6JPTAb+Avm/fkaNrAmnhQQ0e9
 nWHymiv6
 sDOHrJpoKuhw4pgkwV/nSNaXhJhoBfnHvsFusN6z9Ae/jaUynhzLr82Jc9y+4SrGFTTMMaRRNQWZ7hbQkjyCkwY6R8G96Gf33R/twC6hpjj87839Xsj6Es3Bxn1CHdZV77HLGCJ8+7wP/uS0+3kQiQxbxe7sLsGqOfmNAfuRYZ5MEPagCFNf33p/orX4bUPza/FVpkjV6qOt/PnyTd5zJiOLiRmakxcG5fVYN89kOqr4jZw2HHxG1gs+S5Q6Av3GYs7zZG27RWBvT6ibTD+/mTHji4MImxlkTGsCSNUHKfGpmZNV3B18Zm58BB9AFVedmsRvm+/DuNqrzp2wA3t6rR5YuSR5O4PfMj6xzzEQHoDFBlDrzvy5sxUoM/7VLWAkqXKrpNOSHptb7viQw4PzI/jEZFOEIgqMHRJYoK5xaFLbrEJvrMBGsNz+latcKG7b2Vsle3I8QCqhGRpUNkmPByoXZ8xFmJzKhG1aBr95h0RzAyTcCkPIA1RaA1uXIKyBJaw/ZpoVXLZ2YRiA+PJPu4jJqnn+3YlXVg63PIu+lpjDAJqwOFhv0585VccaX8OeePmG22VS8Hwi4iMd/H6BF7qteWKezMDbm4IF6Cc7cKKckN5ByhZunN5QF02caNV9Of2KWt6mQ3o1pXo5TA4Y4DAb35ung7pRZ9EeJH5iTz541M1ScOGcmeeJkiDMcMVBgGMx4gT16IgBrFaDrOyAzSlj3/r73PNz1M0IrMDoFkVSbvPf9wzOEsIWJ8yG5oT11X9smgddqFktV2vU6sGYdJ+duBxE+OgIUHKzQExULSNYEDUVJanjqVx2BnDETRQSH7JHBTU9YyeSEzlCjNHAhUTD2imyqbXBOshR3NUs4GiA6BKiuxt/MLzK6Lw1l+G7PlAW0AdAwYgGft1FE39apb98pOZzRDsUDxBn/KyOv2N33MmFZN4puOMfm8w0x0AzK9d5EplsG74Hsfjaq08PQOIRU88IQ
 hvHpVJh1
 cU2u73oKC41kCb5bLumElIqKlakK/eaNkj1lhdCHaCnzhKY+zOFaGK70dS+c405zlKSjdxgIay/IVnh+USOeZpjS0owf6sJXbloaz89wmp6lcNnvbq8u3rT6cKHBHgefP6p6buLyEW/5tVu7Y6BchmFMi0rmje0FjSd9m4xb1FlvqcGdLlnyNP+z1KEoTu4VpY0pI9VpUZWgGVEsEfs9V6xOQ4PT69W7wxw0iA6folihPCKduYn7zDwYFrgeguRNuNCg7ktUPlIjtaGueQYsy0UABe17M0VbSvHysrU3UF1aGdqaHTQcKMj65ErcS3ctqNAy/s+B3go2RIDfoDPmuIiQ6cpI4yLAsm15fWcB+0r2dxGiG4e43HWyU7Ux0SheNhKKCSCJVKQNZjTNuQU2GLHj6bZEl0N9bhWKxxR9l95DmeHVWh88bKT3rXi5XmbxVNtIDx+hAOqs+rr5ixYcVAoGIOOgHTH8Q+7A+p31bjrtRjN+RupDrORE2D1M4qeD44RIBYfxV+klPxM3yDxIOcktcJeXSNA4g2LEF6YR9zo4Hfy/vUK/HCQzyhw9SBTi6tW544GoVfKHBtLz6xasL/ucUQigOaRDQPeOZ3fJEmkfger3QiRvB0fJIltqK+dmsMJDCciCvSz/J+M4uNi/b9rf3y8LnEIZLzeywp66jgieG+rOzQ3jYRK0MnkkQc86bfC+zyFPA4PdL6+6rraa/1XTcJPSbbdHjF5jk9vC8T77XcBrfucllHMUpwQakPdlM4IAh8wUFprr6I3KjejEJKiVUmqfqoothhk+yRQh1AxMYQyf59Qm2bKcp3vmng32LDP57SjE8SvCZ/apkjQpGhymok3rL0EBRpPCKdkGgD1FLOq0LH1sBI1COPVAo6bHLvKYNIq/EzS2uswTJqFhQ6+fDecVzjCn/2ftOPeQaciTolSDMsTCGqICUr/9A6yR/MqO/SgdNpYDr0lAXXHmQWl8WtR4m
 WhfC0Nnr
 TGP0WEWqsSDcwq/c569AL13oBGjUfabVRySH5El5nBFsfRV0IVjDw0uha97F38L/pVaadZWgxc4m81D1z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit f9bff0e31881d03badf191d3b0005839391f5f2b ]

Patch series "New page table range API", v6.

This patchset changes the API used by the MM to set up page table entries.
The four APIs are:

    set_ptes(mm, addr, ptep, pte, nr)
    update_mmu_cache_range(vma, addr, ptep, nr)
    flush_dcache_folio(folio)
    flush_icache_pages(vma, page, nr)

flush_dcache_folio() isn't technically new, but no architecture
implemented it, so I've done that for them.  The old APIs remain around
but are mostly implemented by calling the new interfaces.

The new APIs are based around setting up N page table entries at once.
The N entries belong to the same PMD, the same folio and the same VMA, so
ptep++ is a legitimate operation, and locking is taken care of for you.
Some architectures can do a better job of it than just a loop, but I have
hesitated to make too deep a change to architectures I don't understand
well.

One thing I have changed in every architecture is that PG_arch_1 is now a
per-folio bit instead of a per-page bit when used for dcache clean/dirty
tracking.  This was something that would have to happen eventually, and it
makes sense to do it now rather than iterate over every page involved in a
cache flush and figure out if it needs to happen.

The point of all this is better performance, and Fengwei Yin has measured
improvement on x86.  I suspect you'll see improvement on your architecture
too.  Try the new will-it-scale test mentioned here:
https://lore.kernel.org/linux-mm/20230206140639.538867-5-fengwei.yin@intel.com/
You'll need to run it on an XFS filesystem and have
CONFIG_TRANSPARENT_HUGEPAGE set.

This patchset is the basis for much of the anonymous large folio work
being done by Ryan, so it's received quite a lot of testing over the last
few months.

This patch (of 38):

Determine if a value lies within a range more efficiently (subtraction +
comparison vs two comparisons and an AND).  It also has useful (under some
circumstances) behaviour if the range exceeds the maximum value of the
type.  Convert all the conflicting definitions of in_range() within the
kernel; some can use the generic definition while others need their own
definition.

Link: https://lkml.kernel.org/r/20230802151406.3735276-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230802151406.3735276-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/arm/mm/pageattr.c                        |  6 ++---
 .../drm/arm/display/include/malidp_utils.h    |  2 +-
 .../display/komeda/komeda_pipeline_state.c    | 24 ++++++++---------
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |  6 -----
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 18 ++++++-------
 drivers/virt/acrn/ioreq.c                     |  4 +--
 fs/btrfs/misc.h                               |  2 --
 fs/ext2/balloc.c                              |  2 --
 fs/ext4/ext4.h                                |  2 --
 fs/ufs/util.h                                 |  6 -----
 include/linux/minmax.h                        | 27 +++++++++++++++++++
 lib/logic_pio.c                               |  3 ---
 net/netfilter/nf_nat_core.c                   |  6 ++---
 net/tipc/core.h                               |  2 +-
 net/tipc/link.c                               | 10 +++----
 .../selftests/bpf/progs/get_branch_snapshot.c |  4 +--
 16 files changed, 65 insertions(+), 59 deletions(-)

diff --git a/arch/arm/mm/pageattr.c b/arch/arm/mm/pageattr.c
index c3c34fe714b0..064ad508c149 100644
--- a/arch/arm/mm/pageattr.c
+++ b/arch/arm/mm/pageattr.c
@@ -25,7 +25,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
 	return 0;
 }
 
-static bool in_range(unsigned long start, unsigned long size,
+static bool range_in_range(unsigned long start, unsigned long size,
 	unsigned long range_start, unsigned long range_end)
 {
 	return start >= range_start && start < range_end &&
@@ -63,8 +63,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!size)
 		return 0;
 
-	if (!in_range(start, size, MODULES_VADDR, MODULES_END) &&
-	    !in_range(start, size, VMALLOC_START, VMALLOC_END))
+	if (!range_in_range(start, size, MODULES_VADDR, MODULES_END) &&
+	    !range_in_range(start, size, VMALLOC_START, VMALLOC_END))
 		return -EINVAL;
 
 	return __change_memory_common(start, size, set_mask, clear_mask);
diff --git a/drivers/gpu/drm/arm/display/include/malidp_utils.h b/drivers/gpu/drm/arm/display/include/malidp_utils.h
index 49a1d7f3539c..9f83baac6ed8 100644
--- a/drivers/gpu/drm/arm/display/include/malidp_utils.h
+++ b/drivers/gpu/drm/arm/display/include/malidp_utils.h
@@ -35,7 +35,7 @@ static inline void set_range(struct malidp_range *rg, u32 start, u32 end)
 	rg->end   = end;
 }
 
-static inline bool in_range(struct malidp_range *rg, u32 v)
+static inline bool malidp_in_range(struct malidp_range *rg, u32 v)
 {
 	return (v >= rg->start) && (v <= rg->end);
 }
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
index e200decd00c6..f4e76b46ca32 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -305,12 +305,12 @@ komeda_layer_check_cfg(struct komeda_layer *layer,
 	if (komeda_fb_check_src_coords(kfb, src_x, src_y, src_w, src_h))
 		return -EINVAL;
 
-	if (!in_range(&layer->hsize_in, src_w)) {
+	if (!malidp_in_range(&layer->hsize_in, src_w)) {
 		DRM_DEBUG_ATOMIC("invalidate src_w %d.\n", src_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&layer->vsize_in, src_h)) {
+	if (!malidp_in_range(&layer->vsize_in, src_h)) {
 		DRM_DEBUG_ATOMIC("invalidate src_h %d.\n", src_h);
 		return -EINVAL;
 	}
@@ -452,14 +452,14 @@ komeda_scaler_check_cfg(struct komeda_scaler *scaler,
 	hsize_out = dflow->out_w;
 	vsize_out = dflow->out_h;
 
-	if (!in_range(&scaler->hsize, hsize_in) ||
-	    !in_range(&scaler->hsize, hsize_out)) {
+	if (!malidp_in_range(&scaler->hsize, hsize_in) ||
+	    !malidp_in_range(&scaler->hsize, hsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid horizontal sizes");
 		return -EINVAL;
 	}
 
-	if (!in_range(&scaler->vsize, vsize_in) ||
-	    !in_range(&scaler->vsize, vsize_out)) {
+	if (!malidp_in_range(&scaler->vsize, vsize_in) ||
+	    !malidp_in_range(&scaler->vsize, vsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid vertical sizes");
 		return -EINVAL;
 	}
@@ -574,13 +574,13 @@ komeda_splitter_validate(struct komeda_splitter *splitter,
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->hsize, dflow->in_w)) {
+	if (!malidp_in_range(&splitter->hsize, dflow->in_w)) {
 		DRM_DEBUG_ATOMIC("split in_w:%d is out of the acceptable range.\n",
 				 dflow->in_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->vsize, dflow->in_h)) {
+	if (!malidp_in_range(&splitter->vsize, dflow->in_h)) {
 		DRM_DEBUG_ATOMIC("split in_h: %d exceeds the acceptable range.\n",
 				 dflow->in_h);
 		return -EINVAL;
@@ -624,13 +624,13 @@ komeda_merger_validate(struct komeda_merger *merger,
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->hsize_merged, output->out_w)) {
+	if (!malidp_in_range(&merger->hsize_merged, output->out_w)) {
 		DRM_DEBUG_ATOMIC("merged_w: %d is out of the accepted range.\n",
 				 output->out_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->vsize_merged, output->out_h)) {
+	if (!malidp_in_range(&merger->vsize_merged, output->out_h)) {
 		DRM_DEBUG_ATOMIC("merged_h: %d is out of the accepted range.\n",
 				 output->out_h);
 		return -EINVAL;
@@ -866,8 +866,8 @@ void komeda_complete_data_flow_cfg(struct komeda_layer *layer,
 	 * input/output range.
 	 */
 	if (dflow->en_scaling && scaler)
-		dflow->en_split = !in_range(&scaler->hsize, dflow->in_w) ||
-				  !in_range(&scaler->hsize, dflow->out_w);
+		dflow->en_split = !malidp_in_range(&scaler->hsize, dflow->in_w) ||
+				  !malidp_in_range(&scaler->hsize, dflow->out_w);
 }
 
 static bool merger_is_available(struct komeda_pipeline *pipe,
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 9156e673d360..cd1d11104607 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -680,12 +680,6 @@ struct block_header {
 	u32 data[];
 };
 
-/* this should be a general kernel helper */
-static int in_range(u32 addr, u32 start, u32 size)
-{
-	return addr >= start && addr < start + size;
-}
-
 static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 {
 	if (!in_range(blk->addr, bo->iova, bo->size))
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 9b84c8d8d309..d117022d15d7 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2126,7 +2126,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.set_link_ksettings = set_link_ksettings,
 };
 
-static int in_range(int val, int lo, int hi)
+static int cxgb_in_range(int val, int lo, int hi)
 {
 	return val < 0 || (val <= hi && val >= lo);
 }
@@ -2162,19 +2162,19 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 			return -EINVAL;
 		if (t.qset_idx >= SGE_QSETS)
 			return -EINVAL;
-		if (!in_range(t.intr_lat, 0, M_NEWTIMER) ||
-		    !in_range(t.cong_thres, 0, 255) ||
-		    !in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
+		if (!cxgb_in_range(t.intr_lat, 0, M_NEWTIMER) ||
+		    !cxgb_in_range(t.cong_thres, 0, 255) ||
+		    !cxgb_in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
 			      MAX_CTRL_TXQ_ENTRIES) ||
-		    !in_range(t.fl_size[0], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[0], MIN_FL_ENTRIES,
 			      MAX_RX_BUFFERS) ||
-		    !in_range(t.fl_size[1], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[1], MIN_FL_ENTRIES,
 			      MAX_RX_JUMBO_BUFFERS) ||
-		    !in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
+		    !cxgb_in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
 			      MAX_RSPQ_ENTRIES))
 			return -EINVAL;
 
diff --git a/drivers/virt/acrn/ioreq.c b/drivers/virt/acrn/ioreq.c
index d75ab3f66da4..d3d800a5cbe1 100644
--- a/drivers/virt/acrn/ioreq.c
+++ b/drivers/virt/acrn/ioreq.c
@@ -351,7 +351,7 @@ static bool handle_cf8cfc(struct acrn_vm *vm,
 	return is_handled;
 }
 
-static bool in_range(struct acrn_ioreq_range *range,
+static bool acrn_in_range(struct acrn_ioreq_range *range,
 		     struct acrn_io_request *req)
 {
 	bool ret = false;
@@ -389,7 +389,7 @@ static struct acrn_ioreq_client *find_ioreq_client(struct acrn_vm *vm,
 	list_for_each_entry(client, &vm->ioreq_clients, list) {
 		read_lock_bh(&client->range_lock);
 		list_for_each_entry(range, &client->range_list, list) {
-			if (in_range(range, req)) {
+			if (acrn_in_range(range, req)) {
 				found = client;
 				break;
 			}
diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index f9850edfd726..cadd3fb48769 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -8,8 +8,6 @@
 #include <linux/math64.h>
 #include <linux/rbtree.h>
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
 	/*
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index d2eb4d291985..e8d5869682b2 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -36,8 +36,6 @@
  */
 
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 					     unsigned int block_group,
 					     struct buffer_head ** bh)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 903bb01e6dd2..87e223fa4ebd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3804,8 +3804,6 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /* For ioend & aio unwritten conversion wait queues */
 #define EXT4_WQ_HASH_SZ		37
 #define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 4931bec1a01c..89247193d96d 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -11,12 +11,6 @@
 #include <linux/fs.h>
 #include "swab.h"
 
-
-/*
- * some useful macros
- */
-#define in_range(b,first,len)	((b)>=(first)&&(b)<(first)+(len))
-
 /*
  * functions used for retyping
  */
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index dd52969698f7..d4bc394b449e 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -5,6 +5,7 @@
 #include <linux/build_bug.h>
 #include <linux/compiler.h>
 #include <linux/const.h>
+#include <linux/types.h>
 
 /*
  * min()/max()/clamp() macros must accomplish three things:
@@ -192,6 +193,32 @@
  */
 #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
+static inline bool in_range64(u64 val, u64 start, u64 len)
+{
+	return (val - start) < len;
+}
+
+static inline bool in_range32(u32 val, u32 start, u32 len)
+{
+	return (val - start) < len;
+}
+
+/**
+ * in_range - Determine if a value lies within a range.
+ * @val: Value to test.
+ * @start: First value in range.
+ * @len: Number of values in range.
+ *
+ * This is more efficient than "if (start <= val && val < (start + len))".
+ * It also gives a different answer if @start + @len overflows the size of
+ * the type by a sufficient amount to encompass @val.  Decide for yourself
+ * which behaviour you want, or prove that start + len never overflow.
+ * Do not blindly replace one form with the other.
+ */
+#define in_range(val, start, len)					\
+	((sizeof(start) | sizeof(len) | sizeof(val)) <= sizeof(u32) ?	\
+		in_range32(val, start, len) : in_range64(val, start, len))
+
 /**
  * swap - swap values of @a and @b
  * @a: first value
diff --git a/lib/logic_pio.c b/lib/logic_pio.c
index 07b4b9a1f54b..2ea564a40064 100644
--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -20,9 +20,6 @@
 static LIST_HEAD(io_range_list);
 static DEFINE_MUTEX(io_range_mutex);
 
-/* Consider a kernel general helper for this */
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
-
 /**
  * logic_pio_register_range - register logical PIO range for a host
  * @new_range: pointer to the IO range to be registered.
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index e29e4ccb5c5a..6b683ff015b9 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -242,7 +242,7 @@ static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_conntrack_tuple *tuple,
+static int nf_in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -291,7 +291,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (nf_in_range(result, range))
 				return 1;
 		}
 	}
@@ -523,7 +523,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(orig_tuple, range)) {
+		if (nf_in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 0a3f7a70a50a..7eccd97e0609 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -197,7 +197,7 @@ static inline int less(u16 left, u16 right)
 	return less_eq(left, right) && (mod(right) != mod(left));
 }
 
-static inline int in_range(u16 val, u16 min, u16 max)
+static inline int tipc_in_range(u16 val, u16 min, u16 max)
 {
 	return !less(val, min) && !more(val, max);
 }
diff --git a/net/tipc/link.c b/net/tipc/link.c
index d6a8f0aa531b..6c6d8546c578 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1624,7 +1624,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 					  last_ga->bgack_cnt);
 			}
 			/* Check against the last Gap ACK block */
-			if (in_range(seqno, start, end))
+			if (tipc_in_range(seqno, start, end))
 				continue;
 			/* Update/release the packet peer is acking */
 			bc_has_acked = true;
@@ -2252,12 +2252,12 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		strncpy(if_name, data, TIPC_MAX_IF_NAME);
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own priority if peer's priority is higher */
-		if (in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
+		if (tipc_in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
 			l->priority = peers_prio;
 
 		/* If peer is going down we want full re-establish cycle */
@@ -2300,13 +2300,13 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own prio if peer indicates a different value */
 		if ((peers_prio != l->priority) &&
-		    in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
+		    tipc_in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
 			l->priority = peers_prio;
 			rc = tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
 		}
diff --git a/tools/testing/selftests/bpf/progs/get_branch_snapshot.c b/tools/testing/selftests/bpf/progs/get_branch_snapshot.c
index a1b139888048..511ac634eef0 100644
--- a/tools/testing/selftests/bpf/progs/get_branch_snapshot.c
+++ b/tools/testing/selftests/bpf/progs/get_branch_snapshot.c
@@ -15,7 +15,7 @@ long total_entries = 0;
 #define ENTRY_CNT 32
 struct perf_branch_entry entries[ENTRY_CNT] = {};
 
-static inline bool in_range(__u64 val)
+static inline bool gbs_in_range(__u64 val)
 {
 	return (val >= address_low) && (val < address_high);
 }
@@ -31,7 +31,7 @@ int BPF_PROG(test1, int n, int ret)
 	for (i = 0; i < ENTRY_CNT; i++) {
 		if (i >= total_entries)
 			break;
-		if (in_range(entries[i].from) && in_range(entries[i].to))
+		if (gbs_in_range(entries[i].from) && gbs_in_range(entries[i].to))
 			test1_hits++;
 		else if (!test1_hits)
 			wasted_entries++;
-- 
2.47.3


