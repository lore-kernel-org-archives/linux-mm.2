Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 672FBCAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30118E00A6; Fri, 19 Sep 2025 06:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07738E006B; Fri, 19 Sep 2025 06:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D9D8E00A6; Fri, 19 Sep 2025 06:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 984E28E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:20:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B13B115338
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:20:50 +0000 (UTC)
X-FDA: 83905606260.10.C2200EF
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10BC340004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:20:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SfnmCu3s;
	spf=pass (imf01.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyCE+4rtsA0oj5GYV3ldh81I3wYriob8vp0F6h3lfsk=;
	b=OMYGbZa5XI+5+MNBzvp0RPrEd2/dt3fekBSBZ0gPR6fsFugHidD9vROoc8MRsHA3Ul/Jyr
	tmxRJQhHHAI8yh2ymIIQJ19x/Vf/8aHh3grinsfzgkfjc6ClM1ks1hSkqFbgzjqr/np8jN
	ddfMIBA+set7rqfq3wMznpSjWO/mGH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277248; a=rsa-sha256;
	cv=none;
	b=Z8sPTZqe4fIWEILT5uoC1J57FlIuWlF+nNC8uI6unPnkEqhhAKwP6oVAIKyImLU8PmXQnK
	OvmOxc7uyfEUxcPKuZLH+GkUuofb7D7Pp+MTxdQQWO4i0IIGn9XD98ROaojWqWM+dh8AU7
	m1amigKK8ElzZu53/AM4msEom6y5SRY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=SfnmCu3s;
	spf=pass (imf01.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277248; x=1789813248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IyCE+4rtsA0oj5GYV3ldh81I3wYriob8vp0F6h3lfsk=;
  b=SfnmCu3sWwoJIDyAvE6/E4G8702X9oPhE4YwzFzFgPfSwCfb9VwRPv0z
   Z1Qg9/uiXgY5OvemWEO44TbFwTshvkRF1LXpWvULe7JmXFYs3MEjEvm2m
   dyXdUtV094CAuZS5R/26gPYbJlc7ShbEiT0jury+qczGQbJIUmYD+tkyV
   t0Dt4h6z9s+zzzIl36a1lh06tkRXdY/7TmAlPaq4s+QqwD6mZhdiJkEOE
   gUE40WKuupDd8lkhXNiHrTbNUJpIIW3K9Ji8+ZJLswbTGaM/nAEjyLhm3
   sTHPXYha/iPiBkoTyA/Q5+LXwplIP3DjlZL6OmAZqTA0raT7OYxdTwo6y
   g==;
X-CSE-ConnectionGUID: 2NTTeskOQuuxB/A/UJq2/g==
X-CSE-MsgGUID: q4vwbqUOQjizEFKUumVqDA==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2264240"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:20:38 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:31345]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.26:2525] with esmtp (Farcaster)
 id 95ca1925-2a1e-40b6-85b6-7989154ddbfd; Fri, 19 Sep 2025 10:20:37 +0000 (UTC)
X-Farcaster-Flow-ID: 95ca1925-2a1e-40b6-85b6-7989154ddbfd
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:20:32 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:20:04 +0000
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
CC: <jonnyc@amazon.com>
Subject: [PATCH 04/27 5.10.y] minmax: add in_range() macro
Date: Fri, 19 Sep 2025 10:17:04 +0000
Message-ID: <20250919101727.16152-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA004.ant.amazon.com (10.13.139.91) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 10BC340004
X-Stat-Signature: b7hdc7qkfmgnnyjc7x6ic169mgr1dz6o
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758277247-639042
X-HE-Meta: U2FsdGVkX1+RbCUVwugN7YMkJqR4UY7cYRwb0aERqHOYGgb3pQ6aaz20kLqp0OJdhRClIaoPqdrPPheZgHh/wGoVgArZfZCOlVJyb98LT24vu/rpwz2rz9n1J7zgnaDHSX5pKhQDdXwveRleSFUY7Xai8UvmsKN4LFU82xhtXo30s4tkOxrtQW2qMCWySyPcaeKV5c7ucFaTYJa/fE7YOnrpfdXR+OIWfvQEIftUUSX/RstC52XEmkOHZkGPQ4+8pwvyu6RaW9QMjrVS1rT2DyGWwgKgCTMJfbhNXUbPsVQURR9ly8JluLOeysnqfuRej7bdmnrwzJUX4nvPSOxp7Ca6yDTEOQkK5Ipxi1cxlUcek+BhIDYXzTaTnm2o/MpwahDFy2tlq8UwQ7/iEcA5AT1JGISCQIeoAFyBJLb7uqrhKXFgCs/zHsh9q5UazarjvrRn4jNfT35JUefO3970c8aNeJ7iKaT5fe9jDSwuB1tLtXhUNJqkRvu8cFvxgj2gDE9hzggKqSKX/Xyo+btGT7AiR3gYOajfoMf1w41471Q4KMiw1bV9g2t913kKI22OIGoWjI47g+ILXdbY+1wWArraSw6mHH4C7n6b03XtgUT06NC3ZcQqepLB+y9tHRvgXXz+Od1XSZV9WxiPyb8aY1ptZW3E0rdDjgECvkyP284mbOjodOknvDdWSLFKyodyBeBiiAKHy6+Fy7JNpQclZRVCgwcvzeGjo2Mq/CAHSrGcMcEnZkov6lvqUzqUBF7FWI3YhhwmTvu5CLlJLaqA8FdhNF9bpPlBlKTfOZUH9Lw8Z/tUO3GRypuRO7KKk5WKFEqlorLcyLTpwV/QhvV81Y1F/wvEQ1ibYaXABDfO9Tuqjj7gJXusGmjYQ73c4Ix55saLynl4sH2q52sS7txJpEyNcOr0IPVFaJI8SoZtF/f/6rw3B079nao9eXba0W9B0kJ0dSo3/LQlOiaTKmM
 bHJeY1Sz
 BAXbEZuwilAKs/Kxpt9CrXGVCvQHcx8OPMeja6pbtModMAvjK/rpvesigO1eamAHZkYdw6ANSWwxG6gbVBLNI9DQ9b/g8EMGX460KRhrXsf11GLHX/F42RmbNGu7/vN0/MSfCOxrUhIMzbVOZH8UQdN+ZV/nHzSK8ThOGBkXMRRypyhVvgew04qyGAQttD85VDRQVsNffO4BqggUHDm7yhu0O6zWcDEbO9Uec/BOUTN9Fwz8rj3kTmLOi3j62KgJD+uX4ka825LARQjgfV/NXIUOIKi2pvpRarQzWRB9P02sPoDpcVOv356jdu42Dgtia3K6EKjU8f2c5NIa2uP0moskJlHs7hOt5CnGKzBD9lyy/ic/C7W91NhXCJphyrpsNgqNNfNjUsX8XiNrykemaKxrqangfkDfwr5cldoTZAWAGuIZtLkldg37nd8s0qmSzTWzf8oGVVuZlFcdahrglXQHX0dWt9A2Rx4NfmqwfavwBTHb1la4b2kJVW6XD0TizTF8Lo1hu8MKKBdDmkfOSWc4gYffDDXsMqiQmM/IcRAZweC0LzNJUsVfd33t45vPp8qthwFzWL09RFKTzF1XRcVSting0eDGbNCcj+Jq+CH6tkMKhMlfl0C7ox9XwizxCyXhczG6ftUB01ME3vKGzBeFRn6+PZrRbtqLiqAlUdwL834Oa0zvzEh4dbaGUuyUtPM5HZBd/YcfEj2TLHAT7HOyHnkxsPNjpqYUgJ65eWKIrc9ZbELEmF17jqyFHOPj8106N2J5u5YlyadkT5UNs0f/hzNUm/of7FCOfxzZ6y/ksXFFq3uIKmDpebC+UTbCFflL1dB00cOZ1fRXowl5zFyJXJgnoh/hxlF5co6bFpQLpr0a0/SXUp3763hLwJHFiyyjkcF3LteKA4EsfPm9bzVOhwquaafvu77IS37eG4DUAVuZ/FIEduJ51GYB4i9825dFtQ16peyuxThs5K9X2bElwNE8t
 D29cuVLj
 A3YV6w2yn4CagqspbKe6QtVV+J9h8F0+dM/8PPdCLTnaNmZ198ouLqzOjZR+8FqCB7SatERTBymCBfi24wsTowlI+LcFmxHJVJj1WkpigQrJfmFB+niOzX3E4PP+OEMnAzcsenY6Ed6T9731MToXg4HKLJiceAuHiCUQpnquW7OEjw1YHd2JQvyhOfeNkj7UheVcggydcCWsWj/9yzouBhMkecW6nksb5wKmGvLhCzVUuGQEkhP5uqIrYlyfNBzo3XsIyd+cTBaF5Lao7KXzfBS715fp2kW0VIbKU2dksw1H1DIps02GPNypXpDJ+X3INVANdJjD6vzPaUneYU5dwCMeGPGSlsjNJf5r96XKHNqsADj00bi6J3Fa4wgxyxdScjUE+/olBKFbPLMT/TESBabFaY8N4Sa+M93pfqRnWansBbt96d0S3YsUcBjMAanY2iwSxZN2dgFXrEaCOXWKFAkm1Pdc0LkRaC1gHG8jVN0Yvzkl3dzK9KkrADGWEDXR1fFpUHKhkaGKI1ibO4/pAaXZpheQNg2/QmmrcgntTWy7p5d4GZ6augfA+A+LIpXednYZAtis8XxtnWN75a1uQ3qgtr5qifDRJXeuKZpSrY2TAjsQAr6niSpSmqyYbj9Qdr9S6RV4JoFeQgrOqkErOyso0/CcYeEepEiUr7DY8+uxH7+AOCI3YbhamVwfnw5ieY4MCm8oURwtxIlZOOUlAzswZ6Gtii2tRBx91IHAyl03bx3ijLN+v4SFTGyedeanKwK4CCmxkAJ9rmUeu5WMGGKvxUwOCFYIpoN2gzazP4hgCPt1XpRbys2i0RAMa0gr7x7nBHTsK0bfiRVi81lJn8f6cvrLU8GTCM5gd/Kh4D0tUrZ+Mz+tJ9VhO0uZpPspkMLtmjPvm3tHdzVatXd1PZQcwCfoACBsSEIqnvImOi38pUzlwntZhk51okxfX9sqKZCPTKjzy+XCFWwEdhP1iSPJzfxQI
 koe0fUcE
 w1dSC6d8UI294teQLH0pKb67X7Q3TLuy9N5dZ5gdDDW2OzG2ffwYR5Kez705xDcOYZJPb57H1DuDwXs0Ltw3mjcj9mjt2afpD7Hg+ePT1574KO5V+obp/TpktYztuW6305pgwmfME//Yakn7wNFl3ehSZovjID+GdQZX16aGFF0Tt/kOg/B3gbzMLcqcM6RHHgBzj02onhqBN5LkWm0lmUjTmh2jEwdcw/TfDSkiDl9XMArvGLWdpFNiME+U43SSp+H1GAsN65cFQYOZTPO7FPyEVFORF5fHFp6h4n3l1MOmbNQCJtH+bVdNHOZR5Ei+85QXPqWiWxGBCjVTW78N/OirZqrQ7qwaxwTb4rSoqm253UdWHrEQZp6WtpAbZl3QPgxu17HaKLDa/naoerKkfVChoJ2JHJ9U6lZ6RF86LWjkHSqFt0/Xi9sixpVzwWLSfSoxb/EojCjMBjnR3yBkzW5v+jhbtN5wdSsrkN7DHS4lvats5IxD2YCT9uC+IuAyoFaTTps0VLA8vHzgHtw1SPFdBLRWGTp/YXeZSIshepLAUP75cQ8pdl/knmJFBIYjpEJPjio5VFnRCT8PBzWRr6qQJKH1RkHKT73F/tl3IMsoTTIZ25li0ZS6lwHzDq0j+gPLEALhN9tnVYJdV7FSDWFzqKiFIcOZXhzcOYPl3H+uSbvcQxurI1tevhmgZh55rl/w+XIeB+gsxh/MuTV6ba4hAmQzVJhHDUJvqcXKhbrYzkey2wEa/DlWYUPXSwXUQn/1v4QNLy6O0F+VfGzasoSKOGIuUYU7i4WQZORE0DQKJdH+K+wK6rCOF4whYU5xlPEnGB80fox9tdW6lPC0Niy45TqShoSJBJz8CZOBXWmtnIfkuKs2FqWnYWIPazOsYsD2JkJs9fJfjifit/wWiyF3fo1nvDXRGID6EnfEoqg3la2PTl6BTyZVIzDoqW6SxWvaiZiAn4oE3u2qJ8sJEmBQFLV7w
 EvwlEqXp
 r2kqXnFz/lw/qXwzX/65RcWYVcYG/OZJ34PY6nQayam8UUJ+BHdzcLWOVXMoN0KAqzGqvW+jZrrwpuHKGZtDNaYWK21giC3Zf8zgKYc2pCQFhUdiPabWsFr5uzw0odjk5NUcV/6C2eaUvg2S97r3QZmobybV3qIAzV5rKDcTyoqBuCTYFORdSsiMx4mhSs/GgWX8B31g3rUdv3gXPdyZ5QjtyYd0XNB6bR62TqasdMHgki7oCZpw3YVK81Hm62+hKao42mtc8+JmOYRmWKiwDy5XTM0GzF4RlO9fUf0eSFfd5Fz2rd3OzzM6ljDLpmxT+X+VtN0NMwoRG8znENvuxz3PR7EjjMYBlE9l7BY57Cg5MQr0POVAWr4dHNTbEBI9sozDkv8B+xv+JhzyD0esPe8QnSsDxKcOVythNLyyS+B4VOLxE4fIQhuZgUoVbkFwdaSCfMciCqNwkUjfN/raXmBcsqSGZNOb2oZ2xMhGANHNJsGzE0/9OAuxTeRl5eO2QEvLkKSe5AaCZDzO/opsvbGk16wyqXKi23vPAzgpornfN+kX179Ai2BD2yKCZ9xzfYNmr+AZSSjeu9Dv79Yv9rcVwekVRH3BlZ/0GVegZ/o7VTDGXg4eHFTtnxnWKSwIWsNOHOoCk5eYIZZVQCApEOmp9BXokLIwGrc+ZjxajYc57F0ZDqRJzKOJRxSQzQjGCmEnV6cOOU9RYZTYtoAF/c2kKDEWXEYxZGO09sOzTk6YCtA0zFb58p4oVQ7Uc8gKGlCwoGAQpHDystwHpuSOmRL8CQHIa/cJvVnSbwVxl5s0swvbE75HGo2RznODt7nGDjXsg96hZJIt5buagUt4TdiZPbjnHsKkWau7gEq+I63z4b4bkZ7qwhRN3V9c1ZnWbP5N2wPWY/Iv9mH0SpSD3n3FKAz/JEFqd46OvPoal13+BZLFVZBmvjbKcSbpExKkbDcbP3RdYWuFwOjeuZPxArqkQoQEX
 UdFDY/fk
 uOyyaH2H+740CPP5B2/vwbCqxXq5XXC86zfqkrSvTFZxeIqVJoh7DFh1b1gIfyLkMdPp2mMliTdB2dTVqwsj/vuhKpd3LCKEHtyTR+heBp550O6bWX2Y4n1kSnhOK3apG+ZaFGVGYPiGej2vcSW2lHxRaSm+WqDqBlJbuXP4WsEZ56e5R6v0Jnc9oYFVMVbK27lUvDpZKWqBTSDvjJ9j4v3CKJD0=
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
 fs/btrfs/misc.h                               |  2 --
 fs/ext2/balloc.c                              |  2 --
 fs/ext4/ext4.h                                |  2 --
 fs/ufs/util.h                                 |  6 -----
 include/linux/minmax.h                        | 27 +++++++++++++++++++
 lib/logic_pio.c                               |  3 ---
 net/netfilter/nf_nat_core.c                   |  6 ++---
 net/tipc/core.h                               |  2 +-
 net/tipc/link.c                               | 10 +++----
 14 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mm/pageattr.c b/arch/arm/mm/pageattr.c
index 9790ae3a8c68..3b3bfa825fad 100644
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
@@ -46,8 +46,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!size)
 		return 0;
 
-	if (!in_range(start, size, MODULES_VADDR, MODULES_END) &&
-	    !in_range(start, size, VMALLOC_START, VMALLOC_END))
+	if (!range_in_range(start, size, MODULES_VADDR, MODULES_END) &&
+	    !range_in_range(start, size, VMALLOC_START, VMALLOC_END))
 		return -EINVAL;
 
 	data.set_mask = set_mask;
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
index 7cc891c091f8..3e414d2fbdda 100644
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
index 655938df4531..f11da95566da 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -657,12 +657,6 @@ struct block_header {
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
index 8a167eea288c..10790a370f22 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2131,7 +2131,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.set_link_ksettings = set_link_ksettings,
 };
 
-static int in_range(int val, int lo, int hi)
+static int cxgb_in_range(int val, int lo, int hi)
 {
 	return val < 0 || (val <= hi && val >= lo);
 }
@@ -2162,19 +2162,19 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)
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
 
diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index 6461ebc3a1c1..40ad75511435 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -8,8 +8,6 @@
 #include <asm/div64.h>
 #include <linux/rbtree.h>
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
 	/*
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9bf086821eb3..1d9380c5523b 100644
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
index 1dc1292d8977..4adaf97d7435 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3659,8 +3659,6 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
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
index abdeae409dad..7affadcb2a29 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -3,6 +3,7 @@
 #define _LINUX_MINMAX_H
 
 #include <linux/const.h>
+#include <linux/types.h>
 
 /*
  * min()/max()/clamp() macros must accomplish three things:
@@ -175,6 +176,32 @@
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
index b7c3c902290f..96b61f0658c8 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -262,7 +262,7 @@ static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_conntrack_tuple *tuple,
+static int nf_in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -311,7 +311,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (nf_in_range(result, range))
 				return 1;
 		}
 	}
@@ -543,7 +543,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(orig_tuple, range)) {
+		if (nf_in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 73a26b0b9ca1..7c86fa4bb967 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -199,7 +199,7 @@ static inline int less(u16 left, u16 right)
 	return less_eq(left, right) && (mod(right) != mod(left));
 }
 
-static inline int in_range(u16 val, u16 min, u16 max)
+static inline int tipc_in_range(u16 val, u16 min, u16 max)
 {
 	return !less(val, min) && !more(val, max);
 }
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 336d1bb2cf6a..ca96bdb77190 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1588,7 +1588,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 					  last_ga->bgack_cnt);
 			}
 			/* Check against the last Gap ACK block */
-			if (in_range(seqno, start, end))
+			if (tipc_in_range(seqno, start, end))
 				continue;
 			/* Update/release the packet peer is acking */
 			bc_has_acked = true;
@@ -2216,12 +2216,12 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
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
@@ -2264,13 +2264,13 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
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
-- 
2.47.3


