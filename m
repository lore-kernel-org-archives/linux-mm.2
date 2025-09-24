Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E8CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6089C8E0011; Wed, 24 Sep 2025 16:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592AA8E0001; Wed, 24 Sep 2025 16:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432438E0011; Wed, 24 Sep 2025 16:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2168E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:30:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3A641DBEC8
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:30:04 +0000 (UTC)
X-FDA: 83925285528.04.6820EEB
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf13.hostedemail.com (Postfix) with ESMTP id A597D2000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WxpUB53A;
	spf=pass (imf13.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
	b=QX9CP1fKFBCYrNarB2Z9XoHA0bTB5vFOZ8L8pjJ1PZLp/DrI7loWC2GJ24GQ9eBb2gnLp9
	wA4adUEkK6d2/SSdCJpr0YZ+69O2Emm1AxeZJlV/H/UClW9aEUA1jg+7MQFk9UKkW3ttHq
	Vw7aIB3owBEhJuOw1A3Kx6lozQzoR0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745803; a=rsa-sha256;
	cv=none;
	b=TEjiWRpyj2ntxlrV45gmVQOqxxdmKcTG9EwPasddpslvhVk7nQWa+FaXVhnilPxfE69CKw
	TN7GgZUFA42CoTweABZbMiecZ56JNqK4czW02xeVUbTyy5flRa2AnREHWUVw4e/ovh8Wgq
	x5yQBbBTHXyQKSQ5sBX5DA/uDzHD1vk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WxpUB53A;
	spf=pass (imf13.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745802; x=1790281802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xkEPvUKyQPfYOtTnd+JXsEAKoNLEM/0U49oHM5nqIDU=;
  b=WxpUB53AgUftBZhJoza6ebEyYdiDTnbjQd+UW2F/sGWLPdfdtHrv0Nuo
   DL0sjyXPj4jGNkgC5iaH5EtL1DIhEzLGlKwJT4+TAjcwWXdOl6avnDfJf
   Y+J53pwvU3V3smml0uqxn2tnYABxoLNgITuWW17ngMM3zgYwJZHHBxpU6
   OlwhSke/7/dumXQLaj+Tos3YXwo7MXtc0PA7qoQCsbvnFzHZXZcxDd3pv
   P5jv98Nsjkw54OOMLznWm8ilsOjebZuBuk3P4hS7GiRfscidXYVb8HX06
   GS0b9LoaMxw0jPUTvhTKBVdScwOKIzRDIhEHxdCA9KntVVT3LPEVNShq2
   g==;
X-CSE-ConnectionGUID: OWQgjqe0Tey+2wpOyu+v+Q==
X-CSE-MsgGUID: a27kEkJCTkmqTzUlsk6I/w==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2527427"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:30:01 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:13910]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.254:2525] with esmtp (Farcaster)
 id 25476354-055d-4b75-9ff9-00d994d9a122; Wed, 24 Sep 2025 20:30:01 +0000 (UTC)
X-Farcaster-Flow-ID: 25476354-055d-4b75-9ff9-00d994d9a122
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:29:48 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:29:13 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 09/19 v6.1.y] minmax: simplify min()/max()/clamp() implementation
Date: Wed, 24 Sep 2025 20:23:10 +0000
Message-ID: <20250924202320.32333-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A597D2000B
X-Stat-Signature: 3emrccpsuytx3ceophqdpq5q9888h8a8
X-Rspam-User: 
X-HE-Tag: 1758745802-895183
X-HE-Meta: U2FsdGVkX19gGeysUgxiDxwboioKTFMpmysbHgRmkoHXsXNilE/t0Wk0r9jrIOXLIee84qz3gG934441ntxpU1voEwPBcSYRrPXb5kLIRVEBvBDtOGD19CU/LixQLH8QF97rBpfzDlUtURVUvcQHiCxHss9f0E3amt2wr4ZyUQ2p50yyPNAphYsSzk4dv0EyzKsnTUQjQ2jtNpcNLJBLEq0S0IBPeXozVdLqfSSaD171J8wWIHafR4TrBsP8xKxedROZfGPPp5P539rz/dk5MedXmV9XQ93qa8TdVHP4am4xUSdxqtx1TDEIoIy1MBmG/b6RVP3kKLqhvhwjF+AUH0iaENj+ZIGOXK6Mbo2LrivZpRie9xz3IDt8FcVEUNJDW4Je1OYD7Pt+aroKzVzZDnrZ4uFFUBg3pCGRqKKq9AKMLU2tmz0AR2fkEG+JqGJi/C0bLKXkdvJj+O6OVCqpQYdH05bUtjkK8BNEQTfD2TJA0McEVZYOPyYbAYN+E9iTbIXHjBTQwwXYSgjkTetg6ywj4f88x1YzkZLqYaUt1GtxthX8i5BQtGi1B4lDEXwvFDp47cSLexXjnZXHfqw/ZZDZmfjwlwM90zcQ2+NelceS3PGJoebEjQMQhdp76/adF1rHFlSfPqQBdSJ/GAI7kvZ6o3e9wJ8qZ92PwR9QjqEQb/vQSom8P5c5paIEQmKSdOtH9WGR+BqMhFQaJGMZT2nhYbVtkovoaMp6iMDkvGVp3ZVWKDrKvZtWS+9nDxR/Px0muN5sCdCemDUOBPr/VGjLgHpfALvSgb3CkuP3QS6900IN4bHLBrjBVpiFk8u5WMVkAItUlU68j18H+gFvmfJQZdMzRE9cTNubGxPKx1dVDDHzv8QX/j8OJeUC5wWmv14pZSvQ54Aj+H9HBCep677b6KqyhFrp/P2xUrkRVVSZQ8LWretq7F+Jx3LHEIHwcRx+kkXYAgNBUu/Kq0u
 T5UW9te/
 whEBNGYGFWucb+tEYKwuwNaKd1ogTYqPe+fh8YKUP0HPNwgllbIzn1FHoloCxLLPYuUQ3gb2utwvL+xE8N448nGXy7HHlVnn4CI6Iw6BSOn8GDQtFdY9HOd/xxu8SRHYeEbiZqLiYzbCCeL87qFiYo9YohvJQXWDWsI5O2NAEPJWXdFkXEi0qcz1gN8TrROmEn4uWQ6zbT25R2/UVnYUPsy/Cde61BtlqGUrSyx6q9TbDVOI3dVKFkqt6ECMu1w7Ew/zWx9lpB4z5c3/ry7r/rMmRoJTMxUWr9PFN28U86ELldHiQWco9jiL+CvMSHkQMhx7Up5xQKVur7+3pmEvSgQgzAk/B+1XCrp06+z1KTKwibijnRIMQp1H0cTEDTrF5a7QJ6LoB15S7UM6jGBktPLaeWVa1gZ+/ajWQZb8b+L0lOkZs6Ey+rlFbjfaTeF51wV8GAtAuIk46+5HeFKPcAfQ1rFv9iNHao0K6u2WQq7W2pf9Qmo85JguuTmM4EEf7kjHWiKKwHatigDaa7Mrz5LHJpseRLSnSkPltVue2e191V8sfEEXVTj9UCgOGwDKYsnnZo3hfhGqmg4S1O5zt6Xie3GMdKFP7xBZZq8595KmaRNYwHLxrxLpEaNoDN46wIqh3qM6dWbWRsLm3LKTdqCwCsvxvEmFCtey1BsvN58kbVkOkzgl2TL5ILq6ksZCe34g49WNaqRTWqCx00RcXyKtmB3K2AnVM2PUUDDzKdH6CUk5SKDxR5cDPm6BJzb5s2hqnkCAI65eodbf38USkS9PSxZPj1LbN02IuGyly7hu0CTx7jAnXYp3Y1kQ8ngcgo/QWjInl3+MvOxFARsnQ2HtXlIXsXcoS7cvJ8V9ZVbaXtAWW/6+/x8Ofji0vENYnSFG98byRf856pcuIzONvc7atfjE9axUQR3jurXHZqJoXK/eAHDWoq5uEwkUb/WwVgLjgrdQDJ7zTuWXxgXHsUiCeMDVL
 v0RSRTQ4
 BOPT+SgImEc0mekol6EcY/bcLND7FgNxw/xCdZc9YwmUq46vbECaLBbkcJ8l086DwBtOnL1sshML7hfkoFMH9Pc0vccX1XF/UT3ebtIXDRzIC3blDYg6VZ7pZNcaSHYuXmwKamnxz0Pxp/4JH2MCwdpk1d3iHyFitfJ+W92etkjS+K977XQUHueuMbPtbS3rNOZI50AVuQpG2iF8X/bJzBtpj1+x1OsgJBaPX45cckrroSEJXuzzqrX45OVr/2oH/y63ibVHFv5tnA+MXkVSwoeLYxVHFI+j85kQKvs8pVZn7tAmGNya5NxQn0/vHNgRNnEzWB+87voaajh7ri68+0d2SI/pkJ8b2En2YdbLHUIZEbCOhND9mbjKcbzHV4rat/qM1OXddAwqpJ3KZOwfDwt0M1VGbpsee71XwAATNYqC642dCWyA8GOM0dhKK15NKeGouUEOEy+C8Vm1TE3ARUui6t5FJs/kzm19JXJCfcVx7Tp4vGMWCYpcXGG4YN+n1JuDTHSi5ljYIeXt7DRM3+gx8cgpoFuzZdazFOrJbJuaVBJVyGpRcAhsZISSqRAuy5SbE0H4af2ejJVSLnzMNSQI81TD9EfWKoTPTBfu28A3erK7wVf0+7bzJIP5qfMWNXwfWF2puMxtEBUJ1ZD7nDyo6owAi6pMA0OhDn2yp5x8ZdbLAI9DO136xAm0HM0WI4hmCH/DcHbvR7MPDrbeLTTJEpgm4cojuJh874qo1rw21J+Mgh8BQpK+dbsQ44uIsDHgP94LO+fBPAcEF7tFTDqx6p1xg7gN23gTnKtPXzuMTYoWn2Fdg0T1o2iKeTinAhFmz7MGkwEhe/MMcrOompGZ//gdVjNIkts/4Ug/Cy+Isa3yr81WcvY9TVyRFcD8yHSwyTKhIh/unPyNvw+9ZTh7J0gUWk3hZXj58v4F/xYdkvfDabL85JKE5JMWrGK7crFOkyCV8+hiZuK1VutW2nI6tWwIl
 zfgKVf9k
 7L6dc0hmGwGd+iOuhrOlJX6eZeKBGOCInhtub5Gjn1eFNKSd2s8edPPr3FGAdKKHZojlS7OVlro8U/fZ5CR3HRcVwAC+DMEWeKyhzlELja+YpzJ7hzmmf9bj6WtsPcfPDUqJTqVmawEqJNFFnNtYGmRf5n/kAmQvTonzLR7cMkcEGEBpP4xA5bRVBsIf1DzOUTo6c87afbSFIgBqAnxK8zWmh4gTjnqdBjD1L6dWtZq0p69gZkNSHZR6kOHBZK94+XyccuLJhuytagTkI/fWqawMbRsXaS1f5kR0BeFtQAEv9smKbmETEUgLkAhAQgsb9aWuiu/S6sTKPx+v2PzQSlvuB5MSt2dOqwVvONR7n3dnCQBB/a61D0sMTvxk8OZw4yEHvSwNMy1EXLkn4IVDtchgxrEFeQ/XOZRBKUPez3cX6ul9/ImmFmqo5vctSc+twKBXo/yT/WfKW39zekd0Ex2Hb1X5qWQ4zvyp/T8FFSKpWmISEpPkHWiz5SqzcWuBeENTgJDJQBdYBA91ZxvC31Y/vz77gVXxyFY0JaMItYiSTZIdz24IUt9Yf32u/Mhe94rZwk0hN3U8ckfgJCmT7qnMMvaydRcf7nKWcLB37cEVBqCigyzfpoWNbNE/7a/W7giGOLRSUNkscpoPkR6eWbq59OvGlqqN9GW/50tWkh02oJimoQIdt8G3nHEOOP+8g27e1UYsfdFSBHlWeHaEtlFt6txQbAT7Jp7ROR25vdQWKsqosCdgpE4rPE18vcChqZ3u89el6rSgMGHDFtvf/ikB507yJJcFUEyxp4q86Ne5JgR+tURqRV1Oef7gJC2xEqECikdPV/7MwT7XWKIR68eSXBAzNLsWpxLYS2lvmY3rdXuyNSsc6kLNFtcTypU+hzz9nHP54gHTxoNtClFW2yfBcV5GgZc2yDKI0sclI4xN9fUHaApw2GdS585MgkMZmFzfNud1BK5FSLpIQOq5c8s86/loL
 9z0s60eS
 vNP8PNQeZCBG7Dc1vqfmjLKLXiac22OR4NnwI8IcqOuJ+T7AvbAV58BO3TwUa4/EDk0Z9Du/EzDMJz0E+3rTdqw36QobHrbC+AbE5gr53BAVXAYUa6EUkhTJ1UK8oKFE1mSS/ADAWrn1+gWGWoPKoLRh1SPCPx16sBdRjRQ3U1DGSaRdNBNntJIDKVbWVZmMLbskxwq67Xcf7RW4u7y9XPtqBzVLFekr38zByl8IB8fUNJswOV828EDUW24ks/HFG+yuPzOZOH49bauZ8piAhrbVWMEa8SOIFchIVe5iLTTF2lAZe0XQBvjgIgqyzaOUgFo/OX3thx/ZGZFfHUHj7PdmZpsLxA8fwl4roCMZtBtOJTAf9rLFYEeJYr14ZgTd+oi85Xa1GQVpJnJVUtqVJvZqepAGdO1GMFC1WwlaCFRhcr/oFhKSKA/Kd6ZYcvhxxt7IjhgYCMOUVpcB/lQLzDIYUOdOv6Cx3ufbTPmw2lrV+wPhtCZbwUxsq6TfkwGD2BOXQlgESM0A==
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


