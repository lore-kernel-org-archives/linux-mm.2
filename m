Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E8FCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E377E8E005E; Fri, 17 Oct 2025 05:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7C48E0016; Fri, 17 Oct 2025 05:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE078E005E; Fri, 17 Oct 2025 05:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2E2D8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:07:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71EBF11A5EE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:52 +0000 (UTC)
X-FDA: 84007028784.08.A027096
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4FD8DA0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Lt56+MzT;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Axggb3gQ9gMod1E1Yl366ABHVZrqad4JWTadzq2JQtY=;
	b=75WzLUjR6eBjxt1SqAYvD5d5hM+69BJF1NqHxN4qdLYmi7nAIPiMZNvolQAi4J7aQRVeqY
	Ds3a4tNvkzzVclOL1PK0VwsBx2QnUyTJRVRDyqorrMGhUsupoC4DBUQxk0PnBBoIWMo7fm
	K+KJecsSoB48jlBK+Iqtv0BFCIJUSO4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Lt56+MzT;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692070; a=rsa-sha256;
	cv=none;
	b=l4rd8ZNP6MaDx/ntnQGAri99biFm4qHIgWnEjJBS4vVNaqoD9Ze4RsnDfNiOpXRi2ywBb4
	dyXBUFLKbTweggVD4EMmwNoYT+W1vkvBh7xLfK9Ms7Xal7cCZWcGIP2AT71ToZa+84nO1D
	ClPd/J6AXUZ/+LPIJ1kKOMGtCzoR8x4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692070; x=1792228070;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Axggb3gQ9gMod1E1Yl366ABHVZrqad4JWTadzq2JQtY=;
  b=Lt56+MzTPm7JVj7+pJKndDpIXgus8Fr4uJhtPFBs/eR1Q+IQoPC/y2qu
   8B9rBYXVB/AxOKyPmS/g86wRBCQemnbYwHW8eNeaFoGsUbGneRNqR76BF
   07XdmGpM3zww5A89d0Ro6IVvTCsfk101clPlTvJ5HvVX1/9211+/75Gxl
   kEhMetNBqLkxawoICwCuTiLpD6jAVUalGM5+MxayS27WoXJpA9M3FHavY
   RLHhByLoEVrxIYsAhc8rtSm6qXfiNV2f5SgXywot69JdKBmD150QoGQn6
   hdYZMhl3L4Vh3Gq1P3S9Di5mL4I/9uNyJztZua0oIjazbLhIjBXVzrjyY
   g==;
X-CSE-ConnectionGUID: plDg+TL0RJuYnIuIvzyxwg==
X-CSE-MsgGUID: 8TFf8viySyudMMaCnxenXg==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4872727"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:07:49 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:5394]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.52:2525] with esmtp (Farcaster)
 id d86868d2-96ac-429e-9410-ceea5e8bf28e; Fri, 17 Oct 2025 09:07:48 +0000 (UTC)
X-Farcaster-Flow-ID: d86868d2-96ac-429e-9410-ceea5e8bf28e
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:07:45 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:07:31 +0000
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
Subject: [PATCH v2 07/27 5.10.y] minmax: deduplicate __unconst_integer_typeof()
Date: Fri, 17 Oct 2025 09:04:59 +0000
Message-ID: <20251017090519.46992-8-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FD8DA0002
X-Stat-Signature: mpf5isdh79ayp9rtxaerdi9cuyaw3ccw
X-Rspam-User: 
X-HE-Tag: 1760692070-917055
X-HE-Meta: U2FsdGVkX18FwIhRieC3CTxcZyO3jhdddzCiKXEkxiS6hbVlfcjnR9VEV+JVJtFmIl8SPNAQD37ZPgxD9mY/hhytbN4tqqqRV19UDdz7tD0RKk0M96rBNYfOI2tFE1gNdu+/q1lMGSLxmCRWM9oWsKUwTvjlqp4OjxO1MP7yXSOLLP/ugFPLtLhQ0DaYmnrWHL3dQzF6Lzs4MvbQTykJwz+Zmnqht4sNy54pXn8Tg7sn/fIJJlvOyjGEzsgOZ5oDv5SkOxaKRbpLmEPG2Ta4b7JY1ZxgNa8dg4K7gKiapflYZ14mqO09MShz4ZmT0o2jowc5njFeoan91OhAGN9hA9xicMfqA2wwfbL2JyQEkgx0UQnYViH0r5p29tcBrRadjAsW5PcGbu1EP4vVVeQRo3XEFoByBhG5OOepXpJ1e4siMKA43Bvu5+wwArMpvZWf/NHywDweAhpiCIp9kPbvplyzNbt5vImfxUFA2QYJefp7ZVt4dBjP6xDkyR+ZSoIvtkeoLdS5tZdPSm5G8EP51bHYyW3OOEGw3i8l3p4MWkWLXCayF+1NTss2isBbsRqJB+k+OUki8PcUv0Y82j/MtGcUBfJafNywouG0QEgrq5FfmkX8viUe2mUjzjU5cS5tRUi/rI3ug60LetodAHK128h7l9oVB8esp5dezSsYVY69nSXmQfiVtpQKxUp6XvIGN3IOlIkkSguUmVJ/DpOXewDq15Ckoi/VU2VBvXV/duT7Gk3PfcBNXdpbPUGD8+TAx5NmGMNubeI+UDUaC/QQYFDe0cK4gmTLQcm56/jhtSHqSHgEmtv8jB+1UbiLRRjL9sDq9obRzR6uXUwxv2FhnGYVsv6jHNxqcYlV5NkJ+h45oNKDk3yAl7b8AWL3e2UzYRRsAZPsnxRG+fO38Uabg8pfbKGAVV2hAeJ2Ve3+Iz4cVQHUQ4fnFoLP6vYgeA9v/0tRS20Uo+HsauBYoL5
 x6USLeYv
 ++yky2cgH9ITRmLz3CpMFxErYGqQxUbja0FJm908EbWwkLkOm2irZ8KvihJBKVo7jGCOhFNV5TSWczmyidbVkkL/vx5HReDrzHsobhxacAPDTRqi5Zxc9GOYsmaNxZGAPwkk4HNmSGKQVG0zuzIkbdXUV+z2DdPMsmDUKwwDde25b4JDIYn8c31XHA7ehVGRza9aSuH90G3imXB5kZZ08aUzzEmKkFTdTidiETgr3tl7y7ADakL/99k9zA50hsf8xXJuL9hdpId2RMPCEh4ZIw4L9Gd4fAaN7WWYqwR0TKWV7OGf4H9595wMncEid3oQNyxMtVELJXNagfkYYXFmSqJuulaUBl9XwTq+XwOG+iJyeITyvnDE83YIxtYgBuk2i8n79tGcrLQiXXwvjkkoPG7DJMknZUPOZy7NWL4hAZCKhI8fljLz1hQ9A7BiV8cdpQz3p+X3tNDp21qIkyvQ2tVAGuIR7013S14fwTCLalKqE7MgV9V2HNvghP9vnNLgal0mBa7qPSdJua1jaPB3N+/6cAHYgJe9bMatZfh+TpEcqFOVvZouUXNv8fPawtowJ/c1/jxiMsukF6OmG0wPRROVMBVjSSH00qNUkbwPCUvNUf9jBfq2T3kcCka9KE5XCIJpna5DgKFdlzVbC8fg7X+8DPG6WQaM1DRuG6aPKuIz7spLLnF3f7wL8cem3tX+QMUdDcS0V9Bu2Fm64QkKXMur7/WhIgNK9Wo9+iVviYBKAw48vtfNaeeoKwi6PJOYUlgof+/6PpxinMtspZPTcUrxmYD5Vqr85F41TTJUzkLiKAkktcXKGpbCxZbwZfWSvJjpJYUazdShvia1PrAqJD3xaZHPd1glGrY+AnUomnJ6GBYufZdUw9QPOEB2+uz76b8mYGW21m+t3WzKkzjwzb76uBo3bp7ji1t5BJm2OL88K79ZpEMwzKoyNNS6N60No/B+M6Vqvbw3tcFIr4OQrrg2bkhcJ
 BWn0mrOt
 RBZ5bWlQ1ZKflxHY/E5o4EQCsTKfRvXJQrzZ2loZYEY5+uuSbxCmnqIYfEBYz1V1/pOsEi0tw7clmessz0r+5Iyi556B/9JO5MxquhNI6N5nT/cAudqTZ0XCH2x2V4l/VikzJFntA0UA7paZ0Q0FmNUyp+hqrpm4QBg8gkarcht3A3lCMiAvZ5TTq1P4UvXHTmkBVXi4Tl+JbVKfoq9ei/08RCpIUvdzQne1ZYorPBIFA9ycbTpAbRN+uo0rOzR8hNC2+67x2d2uZHvHgtvG8EV4RITKPxBWsVeb3NHvKZRHHYBk3WNa6+lapyzM+M8ajAALY2/DiK977Ha+pvpkmYyBZaD3+V3O+kR0zzEaZRdyRUKf6BHqxrpcShcWcn64oIqFlqQMl9CtBr9/Rmo9BqAfAc2xflrso7bpCbw8tImnwaRR3w0PVWCYA/HHErvSPsg0mgh6vX3v0cl8pQIDwalwna/jBhoyXvDic5semdjKDg+VwPYpxv1msbqxuIySVhut39PAHF4S9c0nlEbpQ8XfvCltItif3FI5R/77qvj5jvpGrvbOVs3aWwKOW77fgvLTxC8srGTos/8Qg6+RoHhEILRZ8NbQpFNyjNtP3o48FiWd1oj9dICA7WsnpWn/QflkbtNrIYia/nl510o5rzrY06aFBDaGKMiHUOQ9ZynGvra28d4GSmMPQSqivN0I3P0N6aNqqDyWoQUhcaxUsDWyQmTIXJH3/MLuIYnWzKgHMqkkQxIZ332eDYCDK9zEaxmrkxRiYRXHg0ARe2h1soErdMPmCTEQ3Ps3aVD191SgzdEsALzVAH8UtgIKPgbP42UGHah2FDjNh2fn0J9kQFM9/k4LuzONJsixbJM+nuwk17RbYsyPso9GbJty3jEMf4bwbRgguPAkD4AdCw5u29EO2IA0VcB3rB9QGLMJk1tcOjtlRCcoxp8n2qnctTc671INN8spkQ0U3UEUpgulMlMs16tk2
 faBVvuKR
 u9KkBTSm8ctm1lMurvkipPeW7nfB3qU5zYmGuC6J9UuC5rUwXBdpUnw8WqAvToz9yal2SEsZ2EywdzaZ4xW9/PPEsJ6kOQwWTMW3+D1lhpv6Fe3LqvfmVafY2Xt3Y/7mF5ciNTct51MfS36RZLKhaZsGyVVZQtmOLSEvVOU7T7ZvKYBnxpF12cS7D0eBC2QApNj5cZ/V4Hq6a9WDlEu/q36m2VRvoZiCV5UoXlzCnJyDjK/rP/XZGQc/DiHbcRVz8rkChW3mF45v96JpI7TasJsZVIzGGTBaGevjH1FJ11VUE/JgZ9HpVguPJOX8mptO5aKAFOAjDluYoKGt8Toy7U47Pe+dzTbtPE7UkkhHnl3zoQKy4KS7o/rh7DMTpzYWa/OZMraF+31aEcKAXZmKh7wzUmprWvmtQRqjebPywzFaah6z/IBPGMqW+qLCJWOQ161Yc+z+YRQ44/ar76+k7QUeuRPvqRfXpDlostpwlRvnGtAWEEehJRzro+GG4z8A0TV2Tv3rMFRWke1AZQ5Pb+OAWctfWpaTm92ho42cOP7kIcY3NbcCkJybR4d2Vd2ZIinu/V6HT77JFtX6A+xCUJk+IlfkQVXZW2XllzcJaQspTOo8xarD9dX9hvUwyCZ/OynTZjyUvkzN5lNqg82bR5TaLQjL4UCb0fAJoeVjOokZR6FANZs+bLC5K52L+7tbPNVpE2RnArznRPPwAfPAqX3TMhLQS53OvaUfdfyjateWBYAZEV1bFiUNmh9/G7P2UP3mWNKsbmrXMQV1RUNDWtvy1kPKBQY3HGMPlvtJ9qjhwKKVxB04yG2DQoKRN4MVhxpFoTHOPmHzWGughpvChn2Bvpv5Ob8d3vWaxi//OwRsEgB6GvXC+U688FYlYQ7ifqPhVNRnziwWl83q0RjsZfeFylr+fj0g314dxFoOxwtXmgzV+A0M7y2kN6UfKr4YADfYqKO1Dn9XwR0D5UL37ApnbE2TQ
 Dt+Jt3L9
 TK/o+9ob6ypaF1UNPtcBkOSKyQ7kzoqeYrNdNZm7XSpZbcDm0jorjfNuOshx8tu3BgX8XT4s9YjH8uCIrtdkvc4wfJmqYMJXIrl3mBTcb6jD7WQBKEHwi1c5zhl9YTJmcfL56G2CIR5ElLqopl0OQvSeYkljQVipwREEHO2KXLkvuIn9eOK53nhGwtsn88NpVf2Fy+i1row5BesMPevYSYnCDIGNW3p2SlGEXHyrva69Hf7faAiAgSDGLQ3B7kAh/0ZvVNk50J8BnFwt1wT8LYJc/CCr+8CvD4GKBMOtRAaqz4dxyxn+nhdxPKPL716anJZqtVMabxIfxPwtK/DYfCOWTCLGdhGe5dyzGHE8jS0A0dogZLw0vSvmAFUaJ1/JtKQ28xmZqrPymsfp4cIJl7PEoAqb3HvkbN99K2mLWPnGhjYb00VrM7Sie3T9ayo4Mga6gw8+sh3A0rZlayjxtt2Py1CvNXUI4SocVYjXJUB0iFt3m8PLTAlJ49evIWxv4tavN/SFQE54XBzjiWaWWSKW09dXnA1RpyG4eM8zmgEAsF+kMgwurFQOX+DRkXZs2PPBmCxqkTXVQYiuvv1ObetppTYigUG6TOkoEzS6Re7eyTW609dbtNIdBjpPKzLitC/XZevCnZObuG2hcgIpNnC/JoleIr2a+FDs+3jRxLNqNXNoNpKCZf0HtZcvBXpqeQW1pl/pwflHjM2lvsxyvqh2UOaviSbIIPnXTCtsFxbgg0/YBvKtczcq659OhbxbvtDM7U0He/h+A3Ka26uwikh4KhgDexrm5a7UXM1Ga5mY2PB4d8zGkRshf7g5LIxV+lt9wpP4pxWtyRYQaWktaqXtMRRl9m9d5sT8l27mtfQGguydnZveayXMEO7IKON+RSrEArWi2lT5MN4KLC6mDvg3W7l9QaRGGfrLS4FSDIo3XzEv48EGFJjutH7TlTLx5R8+ho+1m6ozN0yk1iAcbUJ79G5zW
 tUi4hSin
 Zip7zaOpZ/gzxSbv0ahIIvZFRbLr1yGYumjp4czILrAy/ayV8uumwUaag3EQCx5hk7on8hVLgI3wxKqumRFulFSTMlryhSm9bVSVbFCKxkoo5wmKy7QUJPKAqhDd57QtsGfwy5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 26 +++-----------------------
 1 file changed, 3 insertions(+), 23 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 0e89c78810f6..c813c1187510 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
+#include <linux/compiler_types.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
@@ -151,27 +152,6 @@
  */
 #define max_t(type, x, y)	__careful_cmp((type)(x), (type)(y), >)
 
-/*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
 /*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
@@ -186,13 +166,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })
-- 
2.47.3


