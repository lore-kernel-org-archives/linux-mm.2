Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B146CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935718E000C; Wed, 24 Sep 2025 16:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C648E0001; Wed, 24 Sep 2025 16:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822F88E000C; Wed, 24 Sep 2025 16:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 707C68E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:26:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4175F84BBA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:26:46 +0000 (UTC)
X-FDA: 83925277212.11.7F159E0
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf01.hostedemail.com (Postfix) with ESMTP id 01FE14000D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:26:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MjRxgw44;
	spf=pass (imf01.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
	b=216wqapE/giSpCb5JzpfUAVhTElTagB9bA3k+RCqxhMPWuSUZmi6g8i3PhOBSxDE+wzAKK
	/bjehZiyoKnIyxN2JIsSpNisxkCVipKBASzFqDm4XZW6Y3rReW3Iv6Zib0SmqF0z0hMZGM
	8ksxhuNJRiZAKRlx/TUjZNdvxz7shqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745604; a=rsa-sha256;
	cv=none;
	b=TQQuD0I9DeNqDEURs6QALLyILULhkUs50vBq5Hgob4dv21W8rTAIU+oxdOEHYRoflb2bVP
	7jULdYeNa2NH8wETtITv8+7rXlBUDdtZVHK08vt/wUfW+JOmZup5JVU8PTumomYw6Z5hOF
	rV27xnK5VplbuSZBFQMRcsty1stLV7w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MjRxgw44;
	spf=pass (imf01.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745604; x=1790281604;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4vb6NSqQR6ex3kWRbhDvcIC1XoiVTA7hMRv6Rl9gJRM=;
  b=MjRxgw44ncx+jS+mloiSncqxwwzanjRIb9G0z5U+X1YCtLEal2GcZ6dF
   ndRLIJFfBrWlgdEIUsQ9wWiQXonu9rHEqo1Hiqq5DQQTPhOX6VkcnrOBP
   83SX1/HUVhY+MNq986vUKemBn+CrHRuB7WBN1PEJXasDrSDLntcZFc2fp
   26oulrXi2gNNZYZLo84se6O8EmlMWV9+Q9I2znfMFDoUEPJAZx1Qx5NS+
   yfhGpmWplWcOHDe7XFHvsItktVD7KAoMZESDyz/GTK9scCatF5KEGoQST
   Qf5MzVj6NAgdQOq4qeTpAVH0SZ/Wqqr4llHx8HJmQLNilz8JxQEA6Rmxg
   A==;
X-CSE-ConnectionGUID: KSlroWQQSc+ihUiRUBJ+3g==
X-CSE-MsgGUID: gfCEb1glRTqGoP173mso+w==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2630045"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:26:42 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:14599]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id c9fcc3bd-0233-4b5f-b450-8b9bff97bf11; Wed, 24 Sep 2025 20:26:42 +0000 (UTC)
X-Farcaster-Flow-ID: c9fcc3bd-0233-4b5f-b450-8b9bff97bf11
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:26:34 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:25:59 +0000
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
CC: Christoph Hellwig <hch@infradead.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/19 v6.1.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Wed, 24 Sep 2025 20:23:05 +0000
Message-ID: <20250924202320.32333-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB002.ant.amazon.com (10.13.138.121) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: qq3a77zeukey18zrhktnaj4yn5dp3tac
X-Rspam-User: 
X-Rspamd-Queue-Id: 01FE14000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1758745603-931867
X-HE-Meta: U2FsdGVkX18yuJeonOQ0DCXBbMxdD9maOSgRuJqCv4KvlDfWvGm1ZESfsNBd0+i2o/Ega067ksKLfj7kWztxUAjmyzOLJWAC+ZfzE6V23KCszpL0uikiFYTS4bVML8pJOCenatyBlI0xGrgZqU9oaIGts7Utj3bPWfU+vTRPT1ofCLggR8OlzDn1EjY8OycBbtwG444owyRrqG0C1aMGaL7AjIuvsmL7/01W7uktIDAHwfa/VxMgwbG++lO9AzpXY/BKVVaXz1ljfzx8qnNa5uhKckt7fooLWWbpS5D+i94xi5QTlNtFTCS8XoT4b1svmQcyecdhklo4zWE/T+3zqITcvA1FJfmgqH+9m2YhQrCxPItCTKb6CVAkM4cGzBbxYsLuAF83/3f2g48WSnCujM4n6quegtmznDi5pa4Xz4x0CD3xBcOA8RTslP41t1ZTpjMCQBR2tj2FFaMHN6Uu2CqMGzUpgQa6efefox0f6/sugzbh8ZLCCs/wu0LJ8Fw7McCMYI80CvzcHJIJHjPgBd9tRfL4voO1CpIm1KkXHxk7QI/r4e9FzilpXx5FA7yVpqGKbNtyf5dSvKR8f0QxO2B1tkh+VZPNjkfVGTkoEgHMeOpIPdw+dF7RdXfHC+HP09/n50Zy00Tk5T/o1CRCGUg7R0vbrD7g/bNpTJnAxyxs+mscHo0GEwYBnp/zeEuqgNvp2U7W50OBcbwO3q5rfT91NVzLriCuVPIL0cI1gpF0NWcWZJrRJpNi2D53zFOgpEn9pcuUHIgGwBhEFFrDPDvjS8zICXsnq/xIMt3i+8zaUp8Ne+QmzZsYA4UCqEsWFoSuKLZyV0grXsIUfzIS9ZHLlG+xVMmC0MaQEF8F9ifI1XfzXE/6r9NA1aMlFOpQHniOYgPDjmVww30W5fEyxjGcP4o7sKA9y5vrv3bzoWARo/5j9K9ILZRoZjSnRA6ytZA3fgqihP236zMKgUu
 1kgLApHx
 LZja0i87N9e5/caCjPwTYyNzCKzVif22mhyBuUbS8w8BM90aD60L5qXrhVL199jWSLkV7oeH4C/iR26/IN9tL+Xu/QeedA6DfD14m8W8Aa6RW5/HytPozpuoYcEJS7lRSx2NQP6ghEl10HNhhpt6EAL4gPOthAzv6WEjbxqFrz+OyQptOA7r4bd5l+DN/cA81d0rXYm9W2uKH013G4xc4SSOCmtA6K6SLCoBW5UvJw24kISC0XydV+u5j3fE5yt/R+fvzQEFp6tYa/NAmQTlWrwF+9xd6RJkb0jdymXULj+R2WDo+/m0MkTcqNc8k9MK/YyZKQp87Rg8WIq9/r9MwtWplivL/bb01WegmpCNe7GTGUxjeOB7ZclvIMxyyo0CIwtm+47fhNxJ/a2SZxlHtKpX3Dead+I/OOdgtyRTh/rvWjWTlZBciQtrullgbnsCoKCDkiS/1w7nRNxTzl1VBLwsuKGCabP3One3omwazIBOz0dejwtTWwAng0UxWR7t3k1bUp2RZAdEXRlIl9gOD0YRSyeFEuZedbZFGzX/kLd2QUCOCbslHcuqmGJdyt3dlAPExRdiri9+Wwy6saxs+IR6XjV1OK5HJ8uQHoUZMPeWpI+2VykA0Y+9oNUZVLeOCH1Rhtt5HAmX3LvfVv9hQoUO8cvY/MoMNOxliYxEd41d4llnVISNdcdF1q/O+ykefrB5AscdtY5kfWGLzL0ggv2tGyeTXInP0ZPP/Nsc585tYQpUEklF8IM6wlPLJv+DxrpiWemZvJ9QXHvOQmrrn/J5kZ64Y1fHj6wcHlSB386Ki7rQArsCf5cZIDAB9w5lC9vVU1ChcE60bOyjg5+3/5+WG/h3pt2TK+8iMmH4tIqSysExxxBA4/uIoROzkIFwTUUEMSz5v/vCQ8OZQ8aSourqUxAVtZ7ce2vRn7A6Iev+JbPAjKJcV2RsDgBc23SbbTL5RW8Q2dAK5Js8hfC3f3p/eBLVQ
 6qZ/b/YU
 91oTS6It5pbWKo1aRI4k6iZbD82swokwMoz33IgGcmVk1qdyuaFdK6TwVnzuoshHIGgtE5wgfjqbnlgYHK85PZisXklYfpe+qcV18XIy7o4rGbG8W1fvRW9eHls7r6awGun+6jGHIkXbibnZc1F2E3brglcAlfnMD5Z/eUfO8uQAmuO/KuSu8o7l1f44USsGgkLo92LSzy+UmTJ55R1bkzvNSzyt6Fu2c30YJERM1fExeVbEvjE29GMoKPaVRmjLkANrKnXFtU/zj7UAyiJuKMKKblRZ1pflMzijgrwfdAXXdfMbluUs85UTPlBpYsHaYokPtT2RuVGuNOiwdKbu8A+q68F/frVlVpt3rBW6ABT+OTIwZHWHt89z6GysYh0S+HnIjcaIFfxGGiE82H+EcovhpsdEoM/iUc69S33yWzYJYizolA9oR4+Jamd06odBcXAqvsUnvh/OUKl/R5Yv/JTDRRBazZAiBjuQ7oDI4Tf/oy+B9StwRXtiLzpVcGyts/maxoXiFzGes9uTHjx5fvB4XpUlFaxYXaeV6wemIVUTLuglvotP06TCXmxVR6fQ9phY5GVZVMeHDtdjpJVy3I8nBDQ7/wu6jyRU4pIOmuslo2d/qa78WwLQkF2+P9JsVVry/EQaEcQV00q3TpdlUMVtHRy1VLQ74DDEXUd/vWvhvWfElBBWSD2bwgA0eq/StXqT+4Xhlg8ldv0Nc7nF7ia2e5JOv0+GXPAiZ1hxtIjfqG0cEBW/rF8knuwBlMUe6oiL+2D4oXLSEOH3EV11tM9rpS82Bqklx/SeJUWAMiAffRPrAx1okuXWcIF/vMAevaK74tFhSHx2j3APTEMWQkeClB8UsP2p7jhEGSQHamxCRIY2mD0LslBJ/D+CzUr5FJAz0g6JA4X56nvCr2k60lRwxTWxZO4+5LbvFwjSznh8WMsg/YvmZQDppyxjFtS1ZzT0iGlqdTXgZ3Th8ZtgZTnx333rb
 9q0NVh8r
 3y/1PQ2XXcdLTtNLW6GScljplZkkCoaut7Nrb91XC/j3DOOQ7v1uYELgwFKTOKrPJac2ozeojm4AgCwRFoyxgGp54nkwMtLyFx77hfFoC8sIvWAk4WqXztgm0pkgbo2iHmwKIVoQuyB3A8LUqO0PS1FyIpKKkZL6W8EMNgD2XTPuyTrD7Xjy5bqqrEwcye6ddGkaQ0H6wNOryenQlw1Dts+wQsFlCXH33PLY0aKK9qMT+GOVDZVF/0W3jMdVVsniPyjRCNNdde/CwBnXjmtqEe3MHt66vzjUfxEAW9MNdAVlDVBNEd1hAhuzAUQd7/NcCj4mvyx6UCS+x53geBxMSf0wq4pWFL0ow3j557ekzUy9Dyf2R3nJfHz01GHuBsRYo6MB5y/+vvhwn074+BNfKNEEsWRegAR/a1lSdbX4H23Rwm9n1nfC1mXM3KCb+bVatUbRyE6saOpBECoc4EaqrfhM5cVica3c95F+QTZKO7A6XyZKlOUEmvnwgSa6qx2Qa0FrBHT2J5nm2T8JklhvW3UEg14qpksDmDuAToCpPpFJdu3wQrBA+EIcOKadsy2OAM0q6z0gkYlTs1Opg4rj578OZ2YRGn+VfJP31i5Lz0Q/Vzl4g/k5nF9flgj5+jMHR2Rs+rBlqWyDG0NqGy8v2eaJuSvBUK1GrEg1q+2lDIxKmQD9diLnnnXPturm4f7DdV+CWH54j1rochXMECkVKmM7r5xMGLA3XlqOgQKpQtNkd+dtcPpxv/w3cJ+vEPmUIb9IxrTPsEj6xhCqvX+OddUR6ZFnCo4XqchN9BQm/OFBsNhCqI7vLYwLwSNc6mUt1Jq+Xrm+tpMz53vKI8tjxF/xewH/ZNaSifmZE3mhbcbmHMXTuZvmXJpy5SG7aEsroH2HZvbCl5K2epM6cKPNxNVXxreRUGxNugzFJjar/ZgHm/iHcCfhxhyZMUeIS70yTpStX2i6PMhJ29UHmxlb84o5EaV+t
 YurzuqC1
 YDxUSFcZuw0M21S/GgNCIkn97D0gVmcVM4iL6JUUh0A5LCJJ5NIINfR0JZOH4foftmjqwDnCu8YxsUuXhYiuXWejm7HsAzTKkB3vV4SxjVZUFWxlcIuW/m2A7mKXB5HVnZTiHIr1WJMfy3g6Z2EwNgAPPvOktH7eBTGPaRJgQdkEjcaNJj+p23ypbG5IiQvKqhexdJ8AnD1Hp4/v0rK7aLhF4YLzk6ExYmPe8jmioyMyD6or/qCscopDFdIhpgZEGBqANikCMLtX0fy+zksg6WZ0f0qtKCbkC6h3yJHsAnMcOGrTZmcypEN7f1dUovC8I6FzOp7PTZpxD3meNtQBbIKBcqcPCona/v6/d65wvKADhZAm9e5zhj1hzMVyEjTlljJCKrifyZHrGibx904X0fm+ju4Lz8qWBlPBfMwFCZbiMeh0DMMRyUpLdWgOfvPoPdLIxadG/7HdYHD4GAFqSRkJxu6g6YIjFbzgmTfZds/3KWuRWDsVIdhdEOH0zQ/M79wCVP3WSJaxMdcJp/oJIRFUgNTKPeCQMoly3qGuI0LVJBK5/a5ytqOKjOpaKR4tCq2FUcXdVUmWvIEXPLhPP00/G3K+ZYblGpihAYDGUZUVLx93mvUUFnDxiri9vEd5ETIC/ZyHszKj3elLk5O2vDwOwtob1Cocj03l70PYoexyjcbyy6hjVT3UpUAZ/hyycM3cvTeCw/60mNv6iRSChqDRG3ltd3KF2X8G9cOCz9/JouG3l74MQ6BpS+7yPYXM/V1AlwzTWK57veFySXt34e1VR7MRZbhTzOFr8sW4tc0Ry21xbP8oV4pINR2EGL12AkfNxdkIyWqYMmaS83JPVowE3Dj7lAr/EqovmSH2IAMv60mJ1t7/JFK3rbtpmoy4oUfiDVr3II1RluCyr8E4GTnWMVsjjoksgmHL00fmpD6433LwebG4SSRcaM1pHTjo+ubRa8Ep0KIh2ng+FkrI3SEDxQCG7
 n5P51I9Q
 nT87DqaHF2R9Lg3O0pOumFVe3cxNbVpFLH7fXqrbDtIXefd06/0HhJNrDh/SgfPRPFFuICovzuqG1yvLbR4Hglrfvd7nFRfxOR1P8tE0vNgRD/DO3bKO56C3DTLeABN4kpqSjHsQlxNCsIU5rgdNhrKr/YlVI+iwdFnHfoJT18LgFCBD4yFXEK6RtGEiCXOf6oIO5PG9NxTHEIU0KAL0/nNIJpcDyODHwN0tIxHDnYYVSIA5/xGLmUbnQNKWKLTrm5/mOIUvFWkeFzVdCDEuJfQ26lGyA9vMzteRtsMByGySOxJnjVwBrADQyous=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 62b0c0a3cf30..2ec559284a9f 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,11 +46,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -60,16 +60,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\
-- 
2.47.3


