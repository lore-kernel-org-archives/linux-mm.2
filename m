Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF15CCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C348E0065; Fri, 17 Oct 2025 05:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5B88E0016; Fri, 17 Oct 2025 05:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 366568E0065; Fri, 17 Oct 2025 05:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA058E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:10:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D91D61A05C3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:10:09 +0000 (UTC)
X-FDA: 84007034538.02.6556325
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id BF72716000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:10:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=B4Zkai8A;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692207; a=rsa-sha256;
	cv=none;
	b=ym7XCj5LNKQoQJErOAccd58s5+oIy3Q3nlFdAuKIVr8yn2s3OJ8V3pW8+I1UBijWjtVQBY
	+QvKCBzQiM3VJyTo961FYCdMuCo5QuI5+sE+UaihfS5tcO4o4Vd2sbxfFSu6FCvscXyTgb
	4YCajNFb3dgY47quZx8jucM0mmtMYOc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=B4Zkai8A;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf08.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4OUqotVxmJdhB1gbpqxpPI4rqJuz83w3Cv7MkFecSs=;
	b=33ISqiGKhyIVlZGKNkAtQP7XXsZBduEaVOy/3zHwBjS48nS08Jpm+GXue9fUCAHrt5fMD4
	HYDyBvjj0cPlgU/CqiRNZDrLVir+aAxBJ4cn8w2M4lSy11PdIiXZpy0fHbc2JlxxaQNf/L
	BSizckSdMdd7Dc5eD5jjvfi9gtHazrI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692207; x=1792228207;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E4OUqotVxmJdhB1gbpqxpPI4rqJuz83w3Cv7MkFecSs=;
  b=B4Zkai8Ai8J98qsaFwG7PjsyjgkkAz6KtFFCpo4UBcdtbZXycvY9bM4g
   BfHotUzThz6udH/5C/JcdZi+BP3xcekL18wQu/rQ5eSYNXZE3UraqzGeH
   hdJGkCyHnQmWxUUcFhZ9DFCSyxpQvvqfjY57ECmcwFSqSmygcCM77zCor
   SQAXKkRKrKeXok1tPBW0Un6v9Dvxj4bIK4SPU0Jz9g30BAwzNzDDS87/1
   bMJWaeVe1afQkRezm1QWTd0gdn14ZS5Jpm2W0steS43HYxzqIJBvuSzeR
   w4vWdonAI0NcJATyvCGPMCSNZgx8Hb5KikxM1eERq7mTc/C9lhPw4pmWY
   g==;
X-CSE-ConnectionGUID: E0EQLukvR4SYU4ZAtwJLtA==
X-CSE-MsgGUID: i+l0khFwRMCO3AdeHQ73Ww==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5072790"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:10:06 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:28011]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 6c985282-f5b8-4cce-b936-660441151234; Fri, 17 Oct 2025 09:10:06 +0000 (UTC)
X-Farcaster-Flow-ID: 6c985282-f5b8-4cce-b936-660441151234
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:10:05 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:09:50 +0000
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
Subject: [PATCH v2 14/27 5.10.y] minmax: add a few more MIN_T/MAX_T users
Date: Fri, 17 Oct 2025 09:05:06 +0000
Message-ID: <20251017090519.46992-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: ph4xaeobk7bf3hgfnuutgk7r49a3zky1
X-Rspamd-Queue-Id: BF72716000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760692207-117388
X-HE-Meta: U2FsdGVkX1/NqpVFnDkpvxuz5h6hXg1m1PKSXdHJ51hlmQSZNBWmnHdl+ognJLsZldpZPyZxYGFEnETipGiVynNJl5Rfn5ZmqMTR29R3ZC35K+9LvCyTHxOCG4+NGFClwTaD0mTh7X3rVJuAlg9Ft0y4UNd5CR7Y1sAB82djY66nyBv+KEJompnDZAjfc0/l/zrwOqPBix1UXXpChUdJ3r23XbntfaRjoPxLnh+kNCquNPgKjYtlmw622YoN69f4sb9H4HAcFfp5az+FaUyHD+/ylCuVYGq6rjQTvQrNReG1u4efaIOnEMAqJ73jaKL0rZl40AjPV4hGpsCttHL6ZIHEILVB7Tzdk8Po+UGQ0mqPzeFkyHWem20pxmVBCG4fsCQq5K3VUEEn6MD9dSg5Ed33VljtkTykBNGv+53+o3YGvnlZCEEasZfClXRKX71oN9JUY8bucz/DTxx/RMk+xvImNFq4LHPm/TgS/isjUXwkKl+mel5bn4iThYq8dxavMhi9yFH63oNxoD+WM0KthKCdPNgpQDzT7zq+6UaDImlNrqIoTGAnsUpkpqxfHeK4Bcws/f1QToWbF5wt++ybawbmqbY44G9tLiGWF0Hrs676HhGpljVA691tjGTXmd7hx6c2XzF3E5NNc17naHMObODdxoATzSlKm5M4gocriRPKMX5w9dWvnRY6lzoxPoTLJV9iLyf6k51J+TNNf0uI7Sj0bJxn3aZA0q5xo3l2Cu1vWP69BV7Anvjko3nq5GUz0tALXgrJhfKb4M6v+XUZR8/9rTshaYWga6i7EtUHZDssouiRdx8i8ym+88mXUmYz+qOtRViwN7DRd48OyI/NKj6MQR964ZhcEghlVX66Frt0T5sD/jwnrLCuUQ6dQcm5RSXrh0bTISKK3Gw6NXMGSJGn+4CD0weexJP162nk6LgB+yXaKQ1cnL4Yik5lIlIeSFZjQWNmBPFYWw6EcLG
 S5CkzB2j
 SrDPJQtxLroyH5NfAh1q1nircsNaxzFCE7Kmxq0LzyAKzVAskvisHmG4B8+/FxdHpiTBFZG8vP8Bw4wUsWyq3KX4TPdU4nbOs7BSuHh99Zj0aL1wot4JNp89VXMIjGqS2ggAOWHT7UN2CbijglIjBkiD5+TJ67z3gMHNuCKjgXDjIrCxLkFGLM3bpJ3BX3WERtziBoonoQSw73wErhvVh2xi5CNhb/VRtGRTmefxQsp07WV8mPiL5xM3BvhGb4IN6NlaEvJevncuF0osuZESmTrEa25X94GLi/xO3NwIzZdBuGkqtv6StGFn3QX70HslpOp5GLEGu9EgImtvWrgQsrjP/FBwFDaPAHv3dmruNPVa03KG/8wkFuQXdKQhG7NuIOGPiN5Li9zW5RzAe49djjaAOFYyKkpU+IcP+PSk08aevyebeZGIZFD22mQCOVeOsRuHHslDWgqhEy0nHWDeOO35UZs6vnGjVCHCY50MGZhvImtPAi9iORq1jl2KPu12ic9zhUFGX+UhQskLPnD/uQP/r9EMgJNPqZZLAla6lvFAdarKPgXmV+ujwBZUa1mPMRA+FNZEwEGrY/qF1tVkWFuT6MCRDfkX3y+WAvpQfYGsqEP/s4QWc0n/KczhmEt4piMYRKVqfTUWyDI6030a4Xo/JL0JQZfb3mVplIPf2wqexESeiPcbm7gHPn4yYFmGpODnHNKPk5hGMNjmG105yTWdnyTWU2KU8MsBnxGr/cn5+M3hHdPzt1tNeGvZSjJHvk5s20r8YexaumVrucoDUkfMK8S0sskfqaxc6tqDDLI3kmqfEQkuF05N9C9+i0kgRZ7RFRtOOetmxjK6Lmiqz/1XFrOR9PctevJG8dJgoMZiBeDgixsf/R5wknpGZ2++bvolkdz51t3sp77uLhp5yNEHlMhtdl2AIukWwhFG8ZHfn/huE0G8VKqVyjIloaICoCI+X2/4ZokZa/vXbPzPKGWnazYiL
 roc7zRC+
 qsh6AwKDdGAnel36m79q2rqDcCJghnnrQvMqf4jIn2Nf2dIzY1kmcUKr9Jc+hcszlN+cmjqIOczIh2Qei985Pzs+e8KhanD7zjurA52KawSlvS4ZA2tEs5+3voS0xvjo3B46F+8uazBzVIwrGKuCxFku6i3FZFbyzVs7YmrI8kvM3+dx+GrrNHFOxsGH3Lb9t5RNGeLbrkKgkN0eULW5gqQUEkpz3GabaPm79bZPpbh9H4LAkn35Reg1HOkKFqPXS+qhVXBuJCaAEMHGTbT+PWQw6aWx7DOZSsaAS7+1W1U9yw2XEIQGWwZecmzs4n+OP9I90Jcg7hQ+t7otxL7NAwn80gWl/NhtzCppHpFKG8p7GiwSdGp06lspvsblj37Mkb0BqTAaJpV7t0CPFkwDpIVb4WoE0DBcekfu66bkb0nE9gRbuyCpojjX3PFXcczpv35bN4U5ZpEVoagVr8sb3C3XjekqDzqdJpdmkFaAzgP3yzZURMFNCEKPzjnuaN4wxm3WCxzQG7lTtNWoWIhm6JBR7/YZ6gXT/AOROq8fsQyqKa8e4WzCqfZ75C1C1dL63sA1qFeEj0Nz6ASY3UsX2d5TYGTIFUhVGDiDHAPj07tpjZNjoMy7s+egF37KGUDMWe8M1xqxGYxxz+lgy7ioEQu0p27lhItjQWn/xr/DDtMjaS0lSnFxgs27ZyvUYtsv3ymGBKNZarM15wZggJZZb9Awv0BTdaQ5sOxH9uSfqOm0KRQzHjYkocc7fJgqhkFRnjhcEbOAFnSjj6I+05410er31IczngFLTNk562gqTZ6FwJCjLA+jF6EtpjZl97FVve+8gBg4V1RHEjXzhCG2NfACQ0fYn/1eF65EixbrKy6913bysCi0JA+qpzhA0Bas725qYi7D7iaazVaw/S2h9Mw2ubowKiuXR1TzegbWTTWldu/C1tt02/exD8Gu74OWGc+ESy1YRwLwtLPt5YZzLSbNAlu8m
 Or6vZ9p3
 yxWniLEUjD8qa3IM7VUa1NYwUVNqA6hI1x+TWqz4y+FGL54vKDdOSAuoneadFoh9TRYgyvNrqlE9lMlYojzVcMz9nwB5Ug3jFsHWIJxU565xMsAR17GNvrgoJtmS4dJnklZ9Lx6OGcktnXtflLUgoKmQy+06L5F49I90braMMvqbya6JrA1OS45ulWXi7fjiT3kXO2pPShzMwYZT4WCJaWnTEo6WgCatlRx64ulKMeHu4DYOu3NzH6dB8qXpN+yl8uxbPyFF/mUEebBV8rW+pEAHTbT7cacpI4IpNo3Reck5AO/FBd+XROSGc+We+14YA6qyUb7IR5PAOSfT6yyCgkBeg+GrUrl/yZVPJxbZ1OCJybJqhlS4g9K1XzB5cmWr+iAMQpcA56hdZspMModBz0S+fZETFGFTl/4JaQoCo/8zvmPInjGK4Bheogfu6FaMAX2P+GHtrUMXBy7HbFELLqdxX1eSkxSi1BYc+lyoiYsaG+XDRVogvevQ07ytU9iNz37SDQVpc6teOgrVtcsgXEWVFlyV7WZsgDcYLClPlphbtvJRVtai4ePYyx4+xBMZX0oN45bXYQjHGJS6ITgITeearw35u/XJc+Yhug+MNRw2S4EOb1hOrf0ydA0sb+17hqheYhz26sULDFJ6YlCP+7ozblGg4imsqDXh9gD0HN5VMNn52ufO15xZTlevSCINgG8W6lFoCVUtBsx1UHlxWPneYg+kXO23lKU2FjfMUzJ7qtENWJZpaNrJKnCBnriZbe1DczyoO3rKilOmHHxEzbWxQEwFG0LqlVVUFtlY7ka2uxZaRvVrf/h6tdsT/Pb2u+iriOFACC4Q5zUDZyyE44pQuOsU6BqXOIP5y7ZdCSicaSQSDdVD0uCFRxv21jmGTF42v+KaD187dVe4HvD8wmYLt0rDK+x4K7v9pdi9+in1g+G8q4pd6NznWj0dPC7EsxGz5rTZmGrpEMK9vj9lo2p8UIVGu
 3/vGRJkF
 pQ9H09v+dZm8lWEleCpyJnvzKg9sO/eLmFYJf9g//2In0msHNxkrck6Q4I6p7OZm6d5btS7bXO4J6xfhgjwpTn78QuFpT1vY3pX+Tf9AHvxG5L6bWiZW0eIZkNb9U04tA+KOqsii5oo6HKdeh3cK7RmwLb31R/shyD7Q7HequO1umQCwjaajFK9F+tmmUOg2Gi6GLr1fEZm9LVluGN9Y+sOgbAlU1cgR+0+IAfobwfurqaALDboRtWOvwnwKE6EfZvzwhIOTLivn/EciLI4gHvW0RJP/1ycWW2XkNiA3C3S94mVtecBb3fjqKXHwbHIrjUDoB4OhKKwWfU3emdZFaNv1gl9pQvZFiI4fha1pnuI/pPF4POKXUQHSdRQNIOz2jcIsPg82TzNLsICrVIjImMKoQ7bxVjB3Y+b6LsKJA4y8Wm5O++3k7E3Q79NZKB5dgnvvHgGo1mMkl8Xnxs2rvbwVh1IGvJU4N4wSySBgcOGqLttaavS0FcQaj/W3NxHk79gw5Qp8YBh5uPawAHMADEDtjKXkHxA5r970gys61NYcLQGFJHYwxYTwZZ9UzS8QryDEcd/gwB5MnzlRA9YQA3wrxxhOld59G7cEk2Ru9h/3mYOvuVcZCg4c7V9pc1y46zgmQdElhvK4sYt2fcE+/SE4HDCvhb22mYFFOyt+3IZzsAAxogKz7wafPLxZolzYLPRqsW1STur/341Y33vSrdkWLfG/9LuvUSSltRfM/Uw+YsXSL5qb2NtglG1T1pqRZ0GRkNDnMGAO9NLnc82M2Dt6G5YbyIAZhG1syO5TmSr/ioh7uKWBKelfn8fMbHVOt1BdUsr/tUkw+qFSOioy4gLfBpFM5m2/1mqXaZyIsNMe+X1K6EDJH5QlrfENGIpy/XZpuujxUthIOiGKE+5hJF7I8zTQ6VwZbdJZyHTNM7T85GMSUbDurrbAqAz5u8MGtuFXe1A7+mulpry1rDm4Vke/yhfH+
 foJ/yQo+
 5tM5twGSH9qmPI5zjB5/ZoqXUx7jEDk7RN9rEhM0IfpV4umti779YOkxVaSH1tl5Ao/BohuWX/iLo/m5ha9MHNC4iMpBJaBycniyXJzyjSEikWAqxMbS9HsL8QA5LeIF+83Gjo2riocAXcZVX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/x86/mm/pgtable.c                             | 2 +-
 drivers/edac/sb_edac.c                            | 4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  | 2 +-
 drivers/md/dm-integrity.c                         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 fs/erofs/zdata.h                                  | 2 +-
 net/ipv4/proc.c                                   | 2 +-
 net/ipv6/proc.c                                   | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 204b25ee26f0..27e8e3d6be48 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 1522d4aa2ca6..714020e7405a 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] = {
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index 138ff34b31db..4bc671484c05 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -421,7 +421,7 @@ int drm_plane_create_color_properties(struct drm_plane *plane,
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 07a7b4e51f0e..7fa3bf74747d 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2431,7 +2431,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b8581a711514..e6fa2782d28f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2267,7 +2267,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
diff --git a/fs/erofs/zdata.h b/fs/erofs/zdata.h
index 68c9b29fc0ca..d10df3f6c700 100644
--- a/fs/erofs/zdata.h
+++ b/fs/erofs/zdata.h
@@ -182,7 +182,7 @@ static inline void z_erofs_onlinepage_endio(struct page *page)
 }
 
 #define Z_EROFS_VMAP_ONSTACK_PAGES	\
-	min_t(unsigned int, THREAD_SIZE / 8 / sizeof(struct page *), 96U)
+	MIN_T(unsigned int, THREAD_SIZE / 8 / sizeof(struct page *), 96U)
 #define Z_EROFS_VMAP_GLOBAL_PAGES	2048
 
 #endif
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 80d13d8f982d..94fbba052b49 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index bbff3e02e302..929981a8fe98 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 
-- 
2.47.3


