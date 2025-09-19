Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7124CCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1408E00EA; Fri, 19 Sep 2025 06:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8CB8E006B; Fri, 19 Sep 2025 06:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97FE8E00EA; Fri, 19 Sep 2025 06:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4A598E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:22:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7424D1DFA77
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:22:57 +0000 (UTC)
X-FDA: 83905611594.06.A202A20
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2FDADC0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:22:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OIqQLyeK;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf10.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277375; a=rsa-sha256;
	cv=none;
	b=bd7NNRdx6xoSNOJCrd+41VoalE+gHebcHvJ6dQc2E90Bygm7JjsUnr3osBCfcJe30J6xLN
	IPnK9BZ9FO1da5RpNuYwUfLjVwWR4aH0Ns8WT2qFvEG6B8oP3hmEZ8K2VptsddhStvv1NV
	H74GOHp0JkrqwN/z7W6UnkUyF/4WH3c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OIqQLyeK;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf10.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnBmV/SkhIg5SgTRTNSUlBFA6sgQ2eBqJGsC4N+ceR0=;
	b=3bqkOT0SYbGMAVKVX8qnUXqhJhAKkM1aOsWM/dA3yCnLS7hEd08TvDgJ0jC2/VZpwXWdIL
	32UpBEdT9kmbOkkvjMlva07Ktr4XmbpV+b4lgh23F0Fwdb43ZIkIKTnK1fRA3SnCK3hPYW
	UzvL6Ka0MARX9zarlXrB1mKKtt6Gf+U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277375; x=1789813375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UnBmV/SkhIg5SgTRTNSUlBFA6sgQ2eBqJGsC4N+ceR0=;
  b=OIqQLyeKo9c7IZLnAJ3X4R4Vk6zepQRa8qiYrfyX8M3g9KJwdGHAj2Ul
   Y5le7xahisyUeNgeca9jhtpJrfyaeXDpDfkzoz99m0IQ2aoZFjJFEi1SF
   Pz5vHexg7QBhXVBQ58jakMiHGg+0O2qmzTbXYsmnUAuMkXscPWCg0cBVb
   37kehur5rgYwzI9sXDww/Eg0SV28adqeGuurOy6dpAhsl5kZAge1lZl0Y
   Bd08WttqlRpDvqgVWSp4S9E70SBHP4ffTvDreZAEXKizg72TcU6apgXmo
   VrG3gnQ6Nd9NnkD5kr30eI+SyPRnLt2jib1Wz3NXdZLmq1A03m3MMKZG6
   g==;
X-CSE-ConnectionGUID: mhNxtiATSFaNQF5p9yxMNw==
X-CSE-MsgGUID: v25n3sAITvu7P3edO5vr3Q==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2370736"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:22:44 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:28724]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id a93198f1-1106-4301-b601-52214bd42f8b; Fri, 19 Sep 2025 10:22:44 +0000 (UTC)
X-Farcaster-Flow-ID: a93198f1-1106-4301-b601-52214bd42f8b
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:22:39 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:22:10 +0000
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
Subject: [PATCH 08/27 5.10.y] minmax: allow min()/max()/clamp() if the arguments have the same signedness.
Date: Fri, 19 Sep 2025 10:17:08 +0000
Message-ID: <20250919101727.16152-9-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FDADC0008
X-Stat-Signature: eod34fpjtb6314ze4c8uktpwnqeyyidq
X-Rspam-User: 
X-HE-Tag: 1758277374-354879
X-HE-Meta: U2FsdGVkX1/P4a5af1T27WeJc0tdEy4vxPntEdwXkQ1LaOYJd1EWEHGkqZFkhyI+XCIG+9BHP2GcBivuu4y03RK3UuKC5yMf7UXLbeCVrFvc+oAmc+pXxW9j/oEwYnA8RfMYxucwDWFnj2f4GITfICDvLQbSeI0dm9v2+jGZRxmoqnJaImifuI3sSihLgznDl9u4EBVcK9Aomm09ALvY5fwab/F7kVRXtPrLIbYGrokYuRknWsq1lTWpD8HZry9VOSv3b+jQIP9SIb/5uvlxBdXzJZum3ypdyF89ezncnFBocld4Y06ZSJmm8KPYDFiWMYxqMrhMiqN1e1Dhr811FK+pI5aO9Gf2En6+KJ8K6GNJwjS9DWwbBxzuJszo37t/QXeXBsTUoMt3ruo3pcAEZCuhj6rE03V2zFYLHRb/YMRXkI8mqCblcMMS0OR9XMlNEx2ReSMSiREgrmPsxzQpvQvkxfbEFT8GP6n75OEUfy7PfmWdEavL7Y6CvGg+89xKwZJX8ppMqpYFTI/G3Jaw7sat+dx79iqMDufFS18xWi3PZUZ9Ui0BeDvcTAKJKrOcW56pZApUSY6jT4wo1szN+7n9tQCM8xI2mIUMTDc1Eokl2HIdc0CTVT6lVlovanlNF6Ju0xCiks6Y+VRSek6x0XQ0UY2nZn7hogroAY6KJRuQ7OIhnxlSeySETatOo0vTsoPTG0kC1lOylE6w6NpJVc9QCSmmYgUJ9RVneLnkKDF9/QWwCA3hhMnosRn0wtRaM2pKVEBv5kGFz2T5zenO52MXR/Ji4RHOrAIwGv0DYrIn/kcISjchrxSRGYokWFvHmxwK4QfVgWQhrGGU9Nomg4Yzv2azbcnqQ0Ml1JsCMh7n3lTFRhP/fp9EQIixwrIJv3cHP1SoM+xJyGPllH2ZYpZxz7Nyd9vl4l8JH8u4HpG6cLhaAANY5clxcy5e9JhCsc5VwkhnQzfucDz/uNP
 j9vRmJal
 aIMvA39CZy04RZRtjClBmKjgAa7cy1LZy7LdPysl+ei7M+US4cr+oedph3FTUqwZMCnAnhpvb/4e8I7IDIE9OAxKXBG1cJwRPpzsLvqIeoTqyYJyxLZAopBJfyqB+YJTKQBsw51ra46lRYhtd6VmhgGtyvHUGDUm1sI0tmYdxnV277ZyePyoypEamZKpHoYv2M6boPtGuffln8npz2Vl0+Wd9VsDAwZBBpowVE9s9eGjvX/wWenCPyRqEyHuxs+0hvWE+3hctaHsjAJSCkS07ZdQBtZnFp4YmlH8G3oAjtL3hwwZpn+iapc/PlZ0tEy3juGljEWGC030yGRVRsluqvWbNXK88SLrrYwEyHGuHk8N+guduGU0s7ZEXHZn+UNZshDRMPpf+KplsJQyWNo1HRbt+BhdSga9ODJQpQzDXcassdCt4pmgBuma4PhnkVNnuvRER9GB4t++6N2HDn9MxEcAumuXxKhYLUoKSbDD7JwyYSCQk6ZNhIHNMrrERqjkPjc/S7DrqzwlqCCC3lpp2L8MfjJQeMJksqHwqkRid6E42cls3a0LVCzA/8cng6r5gxseKpy/2+D31aGdtLTeFGjz/Wz7G8rkMgqbOFIG3UY3GGksMZiy5V8JvkYOLE/OjGS4ljwjplUKTHxmVWRr+7WlAkUASofn+wiJb7Vv9oysd8l0Qcg/3eFfuQB+2qIlebxqLSphi2yB00lf1SOLx3WNO9mA3i2e4RKWXJiVTeh0y61w6QzTVvZJKevv0iCcvuMMnkS0lf+sAu1s4apzhOshKTKSjXWxcNwVic+QuUMdi2WqcWiu7p7I11kBnj0ZsMnjfKMG1FKJMjm+9NmH8bX+qQNUkSpolnI9jJR2o28Ua/NRuw6Nmc8T++d9Y2OKq4DkZX6K7ZqIXwWPYpFY8ZQY3l4/4FwrzGt0C8krvqAUTXq1PvI8FozituEyb3Ux3qikI8U91BlOQLZpXo4DuSUai6HOL
 dEJRMYWM
 SoGK2dU6DIdZHs/WR3VuDAEwihJ4t8A50htKav83ZsRseARrzipGKcdn4Mtfuc+IfehMe8Uff6eOLXE9vqP+Hd3nrOeHydNdxpio101LmGCDcQQd5owDAahoOH8zO7gUivvQ0F0HZe0WhKQlLcb6hbIiAmse5ceuSc9DUuNGd7CWX6ymlAvvjgHhbfYyzVeNGndXXHU07HQO1rDhM0Ey7b8DACEzWAuJGtskEcc1Af2ehsJJCDxXJs2ZTY134+RdV39chh7251l/0g4yhf/pyQkeTMrgSg4ozdSL4mDOfxP+gZLcd4aEaKIKZvsmm66pKpPzC/1VCCetVuwgwHUZFXa6KhJSzE/s6Wsf88gj37RuHoaUkkmOLIOa7xFu17+jtFuUT1cEDErz2+uCj5YRyjZlXqQE065j3j9fsEGB8pII5Mdvw8lJqavzU3FQi8Hk7Gk5GriDJ61ng5UBzyY9l1W7h2y/RS9ILQbT59O8ATl/ZvM2f28OTPmk4kFNgcezbpXGBpoQkOggiQC9ZheKyyopBYEvl2nLjG6KX5ZXbmdgI9O4UNMPJ6ciy7YHP7MbJea80rjUPuXW/0qp2EUo2MBFDgKN9F1q7S5j6fRFg7f3MuKFXRmoNDba5NksZ0hWc5vdjoTQWctufXjiCuUMnKiMIuYB2JDofwEGpismn97/RfRclWaQqXd4h4PkkurbFmNWXk0rv2tDhWc2iphEfwL65Z1sjNSHnPu5MfsACa0mu48f8FmrU/unuOaADE25khYbDEFL9ByH6sdSj3STP/mOH0uJpH2gbroxVQfOsL1cEPUXKTwtrh8fTBsW6WPsudA1l9EwJTSGtOvYOxlag+6xOFEEXyTkBbLu93UHRLy6Repk7yHVI83V5DK6TV5DQ/83+5nxzlnRET6Bb4lhvNigjg24YGrl4o/177Xehx/rBsaZjvPCSivU686hwObt82RtBxJkM7GzfPoivm6aLdpcgOWaL
 glQZEkOj
 alCUDh+RrJt5J23wnJgkmQTnH6xnOQ3kWSjSbx/f/pJ7SJ/TBLUtNLpE+QNKo7wbktkL9+2al2xlP9twDcNXUD9ca1ztoZAU4R63bXznSqBzrDhppItf4lHq3S0BUZxvOj5tpmAR3Z+mgVZPgVFIGEo5cC2spO+YB3ktrL6lD23f4YgHvsuV2guvMMlUj/PHLwOdjHCkmdQbxYYSPnV+DrS5UEQc+LZxfjrhKQZE9OhlixKrKw/PP/ht1oDqNZKPj+JD6+8ohUvEVKzmLA5pzoElfj9HckJU2eG4x7VNYjKv/6W2kmj5XWY2W7YJCv/HRiYJRZJwSZwO3lWskSvc0p/nXCpqAOXIpCvJJJbu9cMOkWlkEuUOonRZRbEutBqToqZP5nQCBfSD8FNLV7X06ZKpuLiVRxlR4x3cKTBXuQQMsKAw6nVGLwjJbm/Ob6x9EPlRNYyYUuY4A52lA8coN3CtvOyialCqDBv17APruozf6gvAmf9itRsEIZ3YN4Q1EolTJWyG+dehFoUhgudy51ueaZtEV2aof5QJ71HD3LDmItnNVyKbibGVz3/FHRZ8flqAUP7Un1t0UeT+/f0ILja46aOsg0YzNMoTmRfypeNNpxv4H2i5RCB+lyrfnEkQuAdTmMVjtyjzlk2o1/QCG3xFgV6nuPemZyKeq4uNkiBnKemLqBmNP2UiE2ABA+6GqCIEIZcVzSKPl+dUtX+haKcKDhQd6Gc/I+nyWXwEmQrFY49E5dnBN0OENp/JdvBMjLIBELLcLgSEz3G9nL1uow578I5jm7T33/j1+SE7636Ou4eJsQUJI5pg5TJ4J/7YlGAbYmul1/TEk3eEl5bYjBpLg4XtzdZAtsZCRzY1Z2jltIjOx7r+J60MgGvYipFvzZfYIp23t69FcMooQm9YFqqfSktiSy7xBpwMgkpY6CUIFpxZ2FKp+1Wzg36f16urmiokdhKacqlpET0bAqwDKj1rc5d+b
 P5bgzvYm
 vwfSM0ykqVrFs6aXnzEro1wGx0RxeS6bZZeJ3nsXQgD29UT3ejgK4NmoNlKsxAWDAQS3BoEuYGoOYAbrlyVIRwdXpFS4Tqhq81w3Kon4alCExwjvxxgv+Y1AXJgevZELCEjSPEcEeoWNliua+0JvymaEWtv10Whh0xHEqhyouqjZX1K9TXT+eTBoFgy2EQRfeJxaDfjxoafm7YzouaEVPydXujJhRY9iA2hiWEB3BzHxzVvunA6G8M8o4o3eRTBTyDUEZnOTTEsXYTk7yDyUs4U+nlZc4Awd9At9S5KTwdMJJMCih+NId7EfghmyQZMJm2x6KS5P9cx39tYx3G+t0MZ+QhjI5UNbGJojTQAytGwqf65Uvy3yNunNgulHDNo4ZOtzOQMzCg/lJj8qTkx2NaVjC+DkP1a2MuUO0PSDgy7ZdduvkxLTyZtMM4f+t6RintqMcvm2YPUW5FrVcryngVE7btnqTUaL04iBJms9SZoLnDnVcDVJ+5dqOHsVVltrdSTccimmySYPQN7DNcFDbopf6bOts9J+UvqJSjOmHOLUp2+HezSJxsvO8nj1Vf89jlbXlW/wkPGMXKn78dF8TBwe/Ea1bQLtfn4y9iqMJ3aA2TcKurm+tXQ9EK57zVbAa0HUBUf58kHHGOg6WTyFlTqH2s405iVPK3JYvVu8jkszw87IfqXTNAVANiFHysDOTBTfnsCBEh8U04UKLScFyPAaXuXsY2N0BFE1sQSqgbAsdWRPk553KMryEWaGVJR9tL2zTbDW409Rt8hQfJJKlP2KVrhcWHijQmlMT0srMIg0xj+pvYPLECpPTrmDFJecvctsWdWgPtdB/2e9+vwwJcknZ7Tbl924c/L62ML7Qwhe8JsDecj0MVkPBlZJlHCcUlUR+bal4GomA+RHB1KUyR0In6xLOzS8iLf6utCU5CCbUWNBXqfXOdsU9x21AEVSAuqDvgd1dq9rQ9VZGTyyp425D5bGL
 /NDVaeZh
 6OSt5apdV8Fa1vGw3MRRZBUYs7iC7bb4r2Ie9wpm4BWYh7FfQKQW4Sk4aDx7bsEinvJ5clhk9yvemo7GPsWWU1IjQ+BEI904p8R/iJihUhwFj3k79HvoZD9RyO9fyOhC28iiI8rMXi3yfbuer00KpeC4g6mHzYKlwfCnDRMrzZ5uk7uw/uxSGWFK7iv176TemNDjAcDhZKfHMKknLiAOc5P6A8kLZLP6LhVZfZIptMBalBCplWJDmD9DegsLLlfwob6HgY1KvYoAhmS45solC5AMZeLHWJMSQz+7rRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit d03eba99f5bf7cbc6e2fdde3b6fa36954ad58e09 ]

The type-check in min()/max() is there to stop unexpected results if a
negative value gets converted to a large unsigned value.  However it also
rejects 'unsigned int' v 'unsigned long' compares which are common and
never problematc.

Replace the 'same type' check with a 'same signedness' check.

The new test isn't itself a compile time error, so use static_assert() to
report the error and give a meaningful error message.

Due to the way builtin_choose_expr() works detecting the error in the
'non-constant' side (where static_assert() can be used) also detects
errors when the arguments are constant.

Link: https://lkml.kernel.org/r/fe7e6c542e094bfca655abcd323c1c98@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 60 ++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2a197f54fe05..8718fd71a793 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -12,9 +12,8 @@
  *
  * - avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform strict type-checking (to generate warnings instead of
- *   nasty runtime surprises). See the "unnecessary" pointer comparison
- *   in __typecheck().
+ * - perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
  * - retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
@@ -22,23 +21,30 @@
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
 
-#define __no_side_effects(x, y) \
-		(__is_constexpr(x) && __is_constexpr(y))
+/* is_signed_type() isn't a constexpr for pointer types */
+#define __is_signed(x) 								\
+	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
+		is_signed_type(typeof(x)), 0)
 
-#define __safe_cmp(x, y) \
-		(__typecheck(x, y) && __no_side_effects(x, y))
+#define __types_ok(x, y) \
+	(__is_signed(x) == __is_signed(y))
 
-#define __cmp(x, y, op)	((x) op (y) ? (x) : (y))
+#define __cmp_op_min <
+#define __cmp_op_max >
 
-#define __cmp_once(x, y, unique_x, unique_y, op) ({	\
+#define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
+
+#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
 		typeof(x) unique_x = (x);		\
 		typeof(y) unique_y = (y);		\
-		__cmp(unique_x, unique_y, op); })
+		static_assert(__types_ok(x, y),		\
+			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+		__cmp(op, unique_x, unique_y); })
 
-#define __careful_cmp(x, y, op) \
-	__builtin_choose_expr(__safe_cmp(x, y), \
-		__cmp(x, y, op), \
-		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
+#define __careful_cmp(op, x, y)					\
+	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
+		__cmp(op, x, y),				\
+		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -47,17 +53,15 @@
 		typeof(val) unique_val = (val);				\
 		typeof(lo) unique_lo = (lo);				\
 		typeof(hi) unique_hi = (hi);				\
+		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+				(lo) <= (hi), true),					\
+			"clamp() low limit " #lo " greater than high limit " #hi);	\
+		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
 		__clamp(unique_val, unique_lo, unique_hi); })
 
-#define __clamp_input_check(lo, hi)					\
-        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
-                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
-
 #define __careful_clamp(val, lo, hi) ({					\
-	__clamp_input_check(lo, hi) +					\
-	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
-			      __typecheck(hi, lo) && __is_constexpr(val) && \
-			      __is_constexpr(lo) && __is_constexpr(hi),	\
+	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
 		__clamp(val, lo, hi),					\
 		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
 			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
@@ -67,14 +71,14 @@
  * @x: first value
  * @y: second value
  */
-#define min(x, y)	__careful_cmp(x, y, <)
+#define min(x, y)	__careful_cmp(min, x, y)
 
 /**
  * max - return maximum of two values of the same or compatible types
  * @x: first value
  * @y: second value
  */
-#define max(x, y)	__careful_cmp(x, y, >)
+#define max(x, y)	__careful_cmp(max, x, y)
 
 /**
  * umin - return minimum of two non-negative values
@@ -83,7 +87,7 @@
  * @y: second value
  */
 #define umin(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, <)
+	__careful_cmp(min, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * umax - return maximum of two non-negative values
@@ -91,7 +95,7 @@
  * @y: second value
  */
 #define umax(x, y)	\
-	__careful_cmp((x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull, >)
+	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
 /**
  * min3 - return minimum of three values
@@ -143,7 +147,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp((type)(x), (type)(y), <)
+#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -151,7 +155,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
+#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


