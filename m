Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2FDCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87DD8E0061; Fri, 17 Oct 2025 05:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38538E0016; Fri, 17 Oct 2025 05:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00778E0061; Fri, 17 Oct 2025 05:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA5EC8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:08:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 741F213B5C5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:55 +0000 (UTC)
X-FDA: 84007031430.27.31C45F1
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 494DB10000D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:08:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DTW6K81C;
	spf=pass (imf14.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbgnO9UxPmlnTs9ErmugBQ9uOmZYt7P0wc2omnh3GaU=;
	b=B1xpXTZBnA9GJq10Zbh8Kt5lmGnB/42gDN2UoRhB69xHH6BCpRslmmygml0CPdqdLuZ+HR
	8N+l0nBPMtmvAN8PSDpEaVjDEF2Docu07SeRAQPCNzCL91DFh7PDw2hxBiLcOVnrPBtIql
	35qVVTTAz20zXRaI++d1EaZOsl0w25o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DTW6K81C;
	spf=pass (imf14.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692133; a=rsa-sha256;
	cv=none;
	b=Kq1xbXXASj53o37Nz+Iv8x6m/o83TK8IVo2cZP2ywVTtX3dEPRIqEegNHeWccQC0tbs5tF
	zdkISuhKG4wd1gyuu3kK0TxJjN9PV7EDknhdJC0/fo68GYlDFdopB82ckkLy1dEwlxXE8s
	qrICHM0T6ybs6Z9meJLl+SLwUiXmRtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692133; x=1792228133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QbgnO9UxPmlnTs9ErmugBQ9uOmZYt7P0wc2omnh3GaU=;
  b=DTW6K81CPcZY79cwkw6w6/KfiOrwmF6tiTCAWE7pX+eKQALa5vcg14iQ
   f1nP3bKcQuxXCow0yI+h9NJW+1oJQoaXI55bAMshbYIDXcfj0QxRUfgsL
   93OMqETtt2NukhBZyd/NR2e+ecB5idRFQADTha42fBtVA+jeIc9hyXLou
   I0NEW+ryPoLjEV88drcBBpcuKPndajdP3ppEuuMG/06cacCvzqZDWyDkw
   NmhnesYQRe4iPbcnCVoH534zxMoQW21AJbjZ+m/3sE89uONvw9rgc+2VW
   XrvH77UVnjMXsC/YoHCvWFaT/9QqmshvR06QLwvDSzHO9PcdKOMP7V97O
   Q==;
X-CSE-ConnectionGUID: +qrr4EQUTu6uSN98n3eTsA==
X-CSE-MsgGUID: DQE/LhBuQnWf7FbnAZc/3Q==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4861309"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:08:52 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:2744]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 04ecd8d6-bcb7-49ae-a819-1fc0bd26a0a7; Fri, 17 Oct 2025 09:08:51 +0000 (UTC)
X-Farcaster-Flow-ID: 04ecd8d6-bcb7-49ae-a819-1fc0bd26a0a7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:08:39 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:08:24 +0000
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
CC: Christoph Hellwig <hch@infradead.org>, Linus Torvalds
	<torvalds@linux-foundation.org>
Subject: [PATCH v2 10/27 5.10.y] minmax: fix indentation of __cmp_once() and __clamp_once()
Date: Fri, 17 Oct 2025 09:05:02 +0000
Message-ID: <20251017090519.46992-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 494DB10000D
X-Stat-Signature: okocnup9tca4ezc9q7sakhu6b1bi45e6
X-Rspam-User: 
X-HE-Tag: 1760692133-206212
X-HE-Meta: U2FsdGVkX1/Dm3WM80or6OOh4JhUEntqpnbvxJ+OFV0ZBU6Dje05rbTFpDHWts74E93PpMCzq9HM+N2tCWCVgOhXjps9CCKVyT87k+Xf+iODB61okea6DaY7JiR1Luh2wa5Bk0vGCI4DdqiK69NIoRIcqZAaPiqrl/tyzEotEVDNyIftQo+XlEAUEIn5KFMLxvC/44urRjkfka1BK0XQDwZ8M5mkLWXRuCFtwBK5G20M+GgKXA6g66mNKlEb1J3bJoQSb67NcNUj62rqfMpmDOOjdLY/yp787Fmi+b2qBYU/ScFE9AXaZwv/iov7jUI7fpqJ9xGITzrsecb/cSQneehy3WQCzLvsqsI8wRqDCCDSPl/6DAZfa1Rf4b/vDvfgSQReIzwjEcX2ZdMeLGy6SW5mxDZVh5TpcBm2Nbp2MYzSWy+aYiVKl1MBh7/ZaClVsto/8VfYqwNNjG+K9AU4ejyn6DEA9amWFkBSXOyYYejBJV1V9866TFx8NAbyXexN4byTicX+mOhf4yp1c728tHeo9N4kOdQ3iRqcL3EV2qZcC+4BS2eLP5t23ZCWbigjXQxBfgxxv0e4ipOzeNWs5F+/yXv77gRGVLptiqfy4Gcxn7tceDq6/8mr9rI7O57NwX5ZG2j0qIQexAMqX89SNfZR3EMU6PTsI7AAvbVtbFYri83lCC7tIqd+/5IcXMOGBS3tCiF+/BWvBzDd46elmd7m63reox50n82pMAZSeoPAeaSFQQTtQhOeBPziSyfRWnhYZP/OaDE7NQEr5owsDZjvwbqd06PdWHxb7joHFbTr1iqwsvpGbT9EGp/AXIjPnV9EdC1wBSJzCHuHXSRkZ6K6YVGyP9kVezbM77ifKOlDNPHa57lI/wEh1dS5JiOfLp8YMZqzPTSO8lwCB/bZnJHBbIBHaswgLdYl29/sOEngGB4M29zQZXYyXOKKTEqC6b4LV3HHbX0wY6dyu93
 nf1BL5Ha
 3QwiRLJ1egdxsvI5zpGC87LhMZoU7FDTeyaNbOB6BGknCjSiPo98+qcxIebHDLR1oufR+HrKlRCTds/3Pvc4KnBQqiNgKkO6tB8/RivewqcLaYbLUmXuFLHlchYcncf9dU6kpdDOm7RrrXa9FiQz1npEckXc1KxWOlHbJBzwQhcKR51ticguixVoOcSn8TdOZNSXG/pcZ6HcjdypM8l8BdQ3zGH6tzx8B3lmhxY7tQOL7qDnoy1B96tTlhlnFq+0pW/P3MIHU4F1IrlpROTE9Y1Laoa64vkv9ZK4YOienIg9C64lTcThVhcFtOjPbFFd/id8pqPZq5hVUXUokkNa4ubLwzYfc7JCsnUbAiXZJic3R2jwqvoO8jbH3jpo/gRBCdDhU/KVC6AHC+svRrgh45MfZBZKfy5lmo6FyASmkheAwpqc3nNE07yEljDtfkZHxQpwNApS5Kbb4XK0JRFOszhpJMHtfsZ4WTw4P+2k4JQxyhy+Bowvddv7FNcgpy71xfUNUPlD9WxNX256N1MzK1u7H0aNxGWyPAXbSX04fUfsMi85+uzKmufRMCyk+Ipn5Q8ke12/u5K0vd9KUQ2aUun9fNoBcUBEcmcNp+vn9Eugxke3Y9Df0vKAgbs3+HMJQmBnDy0iaGEAskdG0Lz2cWg/eAZ1quwgW41jQaGuK6nG5qfylYPHxlVGaKQYdFcrYtF5B7tz1/LGsR1Zwn/TYhgE+BHD61y9ncg3RjYZYKRGxAUqJ6E/MmCCkl0Nhv464XTlcshZ53HirNExI3cXKHQigc9i2gLm0hyDa/ZRmuESDBR2U5WXnfZBz3wsFb7YhTodbtvD3xaTC9lNrhTY7TyWb4mtE20FpmuXIRg0KCqRxE4L5ARb3php59hr4p5ZfbjsPcKXsVKAhiOEoyyUZItSHJORRZqdBvTlmOHvi/B++lEi2htBNananLWWBzXxxu2tJaSiursioHKDXftFCse6n4d9E
 4ZR+moUq
 e2RMksVNOCD++1kMoGolBGnQXcXNLb2NhorJyZvzPInf/nHjr/QFLCWEGGgqo1jBQiFcE12ofzfbZXvGkiQ+KLwBkthf02AZMUDSjylFF8JSdCmv0fXuGM/rIzWSD6XJywio0/KycrCA4einF1mhvKcDr+sXF9RZc8WQrhp04dNOiLVNDyuTeYw+pEWko0aJeLvWK5y+3NH/n2glS2M4i1Ve8zCiWFUaooh7OSHXBjSdO8lXy2/eb2pHcIfe+tvvxIHdGV77iLrhqYbqKG+FRbdV2swoV8X0R4gLPg1sTbt6U8FjuWIHm64ydm3BHyaa/EiKINSRo/5rEfgBJFW+1vOYZ/+YOJCsZgRq6fYyma1KRPYT3LlH4kq+h1LjmXJuqZAhaYeBf70oE0wiVQwvS4Yoxc8UMIIy4A8xAyVuvw0ZuWzLJ8h+eRjVWxQ5xaxwJoHkx9AWquIYPyLoqIENpNVutPTWY2kG8MvHqxq9xtusab6klh9luvgPFPw+49IlSbjJoqITdADHcY+lJ9uPrrPZGHGkM35hMf5ChzPVrBFRhds60QLDnhfLwPm9unDNP820bttfDbjDAh/qr9xr7czsDxsm2rZxDnlLIZCF8iAM3+Nlr2AxRfSI9kRj8FTUadg6we4xD9MIx9Szbvvg+6ZQQDFGmFFMucyUWlWk4R73d9s6dIPceGUDjGgfP/s7e9ieAwaKh+u6BLpMtbaprsKA7pEWJpFZTtfAAC04cvhIVmXo39Bu2b1ddrNrwdKS1boV3vr1Z6wZE4MnTeIVyUElHxhsutLYdggyBn1amLWLNJdwKnlcTwPxy6ygw43BAUQf2w87PRaIMdesW28GVFHd4yGPtBwCVOM7dx1WU/fVDLBFYvZYUqJDfplfSIzuJzbEtHoveWfu17wmAgq2KhzfxARupoxOCedS57ylHmW019iWqDVgLXUhv8NGClwb+qvKK5eYb64qomZARS5hd5+DDdO7Q
 ifpbQNyh
 vPPe3aQR/rOqPpmMASGc+Zn6XXDnxrxdDpXOXYhcWQNsRtHUOPbeRMPuQkqqCWmEoWl7D5B8LEzw02zEnLibcPDnFR8FVIY/lPkUVQAUAvAAxaz943K6YuG0e2gWQrYY2oISLJrvl4bDL9JGR93sJ4OyBclGLKn/pzClCerzm6nJyGY9MxMXG4KsIS6EsXSMksGyrNNPiNKhpO37YaaFiE5325RWhdd6R9eZgjMG2gLmoz03bwT5GFO9tO6fbFV/iM7qQvkZOZIlKCurMb9YbMjq0iSKVfjesco7LsEctRxkxkJB6RxGNfzm+AthHyhdHk+vmeQW+nDiFwKdwgypP/hH78cgt8aWUKNX9iEHPfity6oKXxoOjFldles9c6x3Pf8Fkt21lf9XjpfSLUqT5YjBdLKGzdIrtRIRvGX2ArVZqDAV+0HhlEtSwhf8X0OdDGfuS2M82rSGwKUGyYOi9bfZvSv2wDaXJG1Pw8C5np7bKz0iHOWifQxctvJTVOUZZpLRNnfxVda6iKaKAgwhDhXlU5Cp0rBMVqAzk3j/6SIuZP/FvoWxK9DC4iFK7edF/A/1yHpRxL+k7R4WOlu1DkOOZrulLTckbUL2nvs9j5EXqvo0orZRo2eSwjWiVFe10tfnOK0lXnCHTSGx1Qx+KLwsSvQ0vLci52wXa13EyphDCYLW0vGWOMHzqmq2IMoFjSgxNMfPXEltrhTWbGLvfdUa8b+MSNsldnQfQO04Xd+Q5yRRcw+q4ZajuHiLAWuQC41k8uQZTbdGXJVA0+GOMdU7qb9GTapQ1bNeZ6WX/ibcVNOMb6LlRiYY1xBsvtC+2XQ3pzb9szxDXFAI6QTpbezg5AbHO+rJ2vYv8ROS5xjDQZ4nAu+pibYcYhUPmSpwMsK1TPkjM6AWwAb/WwAGv/WES2CaIMR+JEu3GyFLUmx07KDAbiBqJE2wrc6XU92kFjmnwmNWEvVudpHYKsABs2E+kxSze
 xrGMorPi
 gkAiuxrIgbuZ0MP5jvBX5E4GCwtw/x0LBIwsdIcrkuyT1AmfT/glWuuClDPHIaOYZg61VbHYZwqIJwnJRjPTP/BX5N1U/0haC0BcgfxfgtmoZLIyoR0g/e9hsdTQpc/gmOzlMDFGG+aw5a2LQppikNIiY1pSI1aI8ydOdRYfaTNNvHtqtaDd+BoY45oIuG61MgPlJbBMaToeuzonosW1FyGllAAS7X7T9fHdbUoDrKF92l3RHXYjl7u1oJT7/cnnX4LNhDVAu6AcQbC8Z+brqaWalPTpTaEp/7lJDb6OJdONa0qLOMpHdAtwKMZF77vJ06Mmcy9pEvlrxBAXzpAgkFFWGXArT8oEKUdhcgZePVWhYCuF92jphfBSWyOB4XAmj34shyx9RVIiCAB2OZcv25cwCkPVp+FG6I487AgvmDP3pjI4aL0Vi3WDwd9RTSn8nZOFHDtuzeT7hfStJ+psmlrgMkMQkLrb4bucZk9Ff5kmaZC5r5/g+4bGqkKdGaYLT3lOYIiHCVkAVTFpmMVcoYbRPBB3hyDMM15FRVuCP+wXZJve7rMwzCCzIMWUa3eqYtBKPwsYWbGuu8MVZbLvqiv2xh9tzu2bB7hfBeZf+vbf5q75dN7J4d95jl2E3Tes7iSbYdzB1b2Ej0Y6bZxwPyzAddYFT9R3yYvF08KtY5oEPLtOFYessU/t+JpAS7meGH+QU0/t/37tL7a4psR0fKlryRfd42JA0xquW1BdvPwSd2NXSLe0ZPKjYWIP66GrquzfH4fYFC1xS5YV3nKz9A25KpkmT4fX42sfsspWcOpnktYwv0xi8F6jscyPRKXpn2x6DyAne4uOjy5PPX7Ig0ntL9cEvRHI+vgSclYGej+NHUQZxT5Ln63A8iV7kGaF5PCfdLy03Cnh0LSrl5eh2SdpVUNkj0uN49R1NM/VoDaLCAfvmW8evxn4Vebt+9H93vH8zMHlwsa3mWsICsBMp8teim5xO
 Eo5m5q3H
 rddNOwCbU+0/shDcEDVfE02y3SSxlEUMaR/z02hIOtWbjtpbg6kQ8kkQJfQUrD9UjgTXtv1dMTDWdEebOSQTgZuQe+ZwvswL4+6D4TzvQSUdw7ovWFcS2iJ35BPTCTOzYuiaZ46FM7DXSBlgU5qMRxhikGKqCdxUqZbVomd/ghS2rVgJFQ7cgz0QPBEf0Nbc6LGlTfYCkmu8RvnIDh5sH9oF7r8n3psLMn25t8iFoCadEkEtc8kUSBj05uNK7EA4cGfo8Aw==
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
index 8718fd71a793..c0e738eacefa 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -35,11 +35,11 @@
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
@@ -49,16 +49,16 @@
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


