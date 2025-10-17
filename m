Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9109BCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97228E0058; Fri, 17 Oct 2025 05:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46D98E0016; Fri, 17 Oct 2025 05:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE87A8E0058; Fri, 17 Oct 2025 05:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A5F808E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:06:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 393FD1405D7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:06:15 +0000 (UTC)
X-FDA: 84007024710.08.9630E55
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1719E80012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:06:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NOxCyy5c;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691973; a=rsa-sha256;
	cv=none;
	b=PZLlVJIz0/E3A8I7VOe9RWZYYfK/4m1DnO3bFCyzePgydtWfbS/go+E0GZ6gFu0KiDLCmd
	EW3AYjf6GeegjjQvfB7OdZM31hxlpusj8bwtPASnHFp5/msiuBA47q+EJT8o8TG89ibg8J
	Kj6cN4twJUTNVFHqh1T8rXKTJXq8fwk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NOxCyy5c;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf02.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUfhSEtyrzlTvFjtMARdG8e1ebgK9JT+esac/DH/XMI=;
	b=1h6PmPEC6PlFgCUrJy53/q6CdpPkmjB+CIZ8JdyLuH4j4gZanJ5Q+mijtJKLW/Y9IZRjix
	4azh2J9PgDzH8PAWyQpUS9k/bupjvgwIPnZa2yXt2unbA4jeD91zf08t3Jw5LHo1iZnQow
	PiPRHXSx2rLGUmW1kIPaOodvZNNmhHY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760691973; x=1792227973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LUfhSEtyrzlTvFjtMARdG8e1ebgK9JT+esac/DH/XMI=;
  b=NOxCyy5ciPbmpC+Nyjv8TEiMbWoED3iFf7i91kC45FQCswPVxMfGhKtK
   e6AzE8+SXqH1Mi9QHZ/qwq6DSIIkOaYTQ2DQxXflj47EAN8zu7ieOrAow
   azXWRemg81oDK+JGHABN+06WXtwuFICyIsW6JKSxv5qATn+5/Z9AdisSj
   +E+tnjMlcZYH7/RCbEPzmlUePdsypL9uCeansbPDE3BED9628od+K09ej
   Kzv9Cet4s3bfigaKI0GjglJU6ZU3/QgIzSpTJxmdMUrEnsTJnq21vdYiR
   xgymogfanmgr0qQF49Q2rzGTYelLJVsdfpUBd3JCaDbIR9CgfH3xdZaZU
   A==;
X-CSE-ConnectionGUID: 81vXbaCaRnGCbaxjqgyfrw==
X-CSE-MsgGUID: HnF/i6jVSpy9xn0uhETRhA==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="5073896"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:06:10 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:20862]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.50:2525] with esmtp (Farcaster)
 id 7be30397-534c-444c-a389-19ecfbe849c7; Fri, 17 Oct 2025 09:06:10 +0000 (UTC)
X-Farcaster-Flow-ID: 7be30397-534c-444c-a389-19ecfbe849c7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:06:09 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:05:54 +0000
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
CC: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 02/27 5.10.y] btrfs: remove duplicated in_range() macro
Date: Fri, 17 Oct 2025 09:04:54 +0000
Message-ID: <20251017090519.46992-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: oaqzmrrgjcrwfy1arf6xnrn8z8mzdqqj
X-Rspamd-Queue-Id: 1719E80012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760691972-265737
X-HE-Meta: U2FsdGVkX18njWXRyv1bGNm3Ugy3JKnZmrQ6vKaHPgiHjmplA8+1q5T2FbCMWWyRZHHbJmWt148SevZ2Qk9h5JWaxm0uSZUL+6Dj3f8iPJ0JXvTp1b/HfHlUDJGDTu8rpgrTHm24uqtzgu1QS0fA4aMK1zTJAAYd5PrhvJKgBLFNIick0LN+GBwjdpjFRNPzgt/P0/kkgt3hctk8MFadhXRvpsWD9pRkVkUMuFTIv4a6x6yJQXrQL48dUhxX0z0hBVdWZ1vmc8XrrwzSsbJDENSOjXhiWKWe3LB0pxa+1ZBmQvFKoLGJ04k+Opof56/THKRfVZqANH3yoJV4xBtNUYscdwMZLibwHgDuKthJzCN2GL7b1zwMjVtgZCvpRoDKqaQ8EgEtlkD+YpA9Kp2x/YLiRmq0EHJDFdk+r9AwBKZGlIK8umuij+C9kLwiAmR7Z/qj0UcTz85KyY9Y+pI0JAb+vlpvMRDhtyVCy88eEr1YJQ2KBMO0z7N6lzzMM1tRaMeYDsWQEvM6xuaeoKxIrjOG2fdHI6A2/FNBWkhZlT6831oMLgw9u4l91v2b7eu5eIBvEzs4eG3DCeu9eGRXZOoyevsURRFQWvxf0j1zQ2g+ODSC3Ch9RVLdlzLCL1em8rh41MJNts3rugU4lKWZ87AN588Dx44m5434SFILAGZgzfjJUlKlUXzdx1DgDRphP6ybmoBJHFI9JKz3sRU1fUA1tJTyx2c/Y3OTIBZ93BckPr9izIbMRDPQEdVIkzjSzQhjcy7hyepGVDgLNaEAAURlFrV8yXph5deKDqAtZd1gepVhacb4TBw8ACfVNSS6Ng68gsOYGicPLG1dXipHrWPdudF+GSRCVGnLM4bqmiNAIWbqJXmsn3X1qlnGZud3rwJ651Ja+3YKE957bRo7tZsLuhO7nD7H/Esr9R9WYEBSBjCHI1y+Rimbj8/9FagE41RuesSoJdnidhlr7pE
 O30DAzmS
 G44Gjlk6Js/1rsXb46qkYHnfNEkOLBNV4vEKhUGdPkOK7TmheIsm1OUtE875lnAWO6Idq1yAyYFFBVFDY6qA3vUeGiUyTxxFWb3NxYBzs25lLHAJqNmdmucNw/tbG3cEAMSGzxMvugdVztpNRl/gIaNqELcogTsmQfLSiDQCQf06QFH1Q2gw0Wzyt8++mtlqClRxJXy+jcGAxQBVJoCbc3xnhwaJ6fwEt6vskBXIE9+N97LymmkQXIQmjz+emzotrbgnQr0AVKU6sUW2ya2HSBfFVGc1kDUo93eL5aC/zff5WV5dlJEexOHvbzbCZtsyHvgNEY35vWP352H6xiWWdhWOJAdEXSqcayIEpE8sN2YSyPuBWzPpL15ioI5DwcITGU/MFFL1r/Ig1SmUgXBZvpi2sZ1QyMI5JIpT8QHzbodx7duQktOVsl1nhs3/hTLFDMEnsXQiifFy6Nm4iVILdt9RhN4BcIVq9yRq7+OPyP7sI1UB/HFm1+ybmxKPZphbnwDtx38WVbaghcga23xZGNJuy4rRhhzTh/ZnkM6Mfo5LRSZ8LA55IZl73fKDuh/43icMFF9kwJ4p0sovbrxM1n4bXcnPuld7y3YpMmOborI2kE61DLt+qlmJFlMWBDMu7SNZRVUSyZB1vd7JMlOGKB6+wp1N10r99dlUvWjZeHii+l6+ditJOU1rpuMcBCGw2NZlZaWVtlRV6o67WwW1oY2m4S8VGk1nue3nkfm/ZY+uNkBJbHytb3TwxyPYc5kKkISSjBKmhV/FOWQwj2L/Y8AdYtV/OAo/Ibc1fiZrSDJOoy6LX9gkb0qkZnr1fa3USI+Iy+2y2Au3de3iSl7hG67+ovtCoUULm9MTZJFtI2Cq03FiqpNeZiHiesObY0AKGbmEypEw4DkEp52httns3FNr7wyqeDVFDkMbcaUH+AlJjqJOmBxi+3yboSBIhnnMnN2F/7m7xohRZa++Z8s5D0ri29Mzo
 4SBg+Qxs
 Eyi7jVfoctmddwGYSkSAQMwnIJ5cd0n65PeeU02jveBJ0DQgOuJSYbyPScuzGeHSKXIJeET5fWyo0lrU/19w5bMxghy399W9sajJvwsnyRn8utHIZPltmXfhHgzdYSqAY8mJ1HwJVF0oRbZcfJpQBtHDSd7P5notWRVwNYqXqNr3vDWBb4eM+T8L6UcO1em+sTCrrimltLkzQirV8feDXe4oxZ6W3QHXIijz4d2zpFQExbqm6242oTyITCVwZceT0/MRSz+4ytLNSaKq8Bgo8zO4jmXXd5EGt544nBPheRcuI//oH9mfzimJoZYRjOq4iYukumfEjpuiXqV+HIINbeXqlM97QVtNBhY9qsiiFY3T7bIRvPxkCjI2W8KDsijC5nlcW+ftM97au9tPkvjirWy6fG/gWEh7fordf4dJ5wSVBXcOKMETHpjLQtmFT10zYXQ8X4lJDu4P+LvQb1uOkySMzDjsOp1wx2iOO19WOEONQYK5yQAhFwXcufu1ftQIlTWQdI8kyCQUXdlQQCg/3VkA6rHyVWCeWiwLYtUxoUf9q2xIwGDOiwOWWOt4HC8u/ELonC201IZGrMG8dUM2SGMTmS6xUjuvQxKpjpRTWgWDQ2R8Y1Y/qUnbyTPGrWULNchb4BFvUGfTk/8nwVETsX3vLVruafr+XraxU7rujK2tK71xsD9ZxNk2RoZk6Ker9Swdq0YUum+U5AfqS4fRNUnwcaYAc1SCymQ7YDMJjV3v458tGFbO1QmXDFy7OcUEZg9mh+evHIygQY8t6L6d1g06kOAUZW3tDyGpYdovqkXD3wSFIPOFvqnHuYzbF1YqkP4GLE3FQqLBt/WYTsuK37jiCO76DJuznl8sNSppwRWeEIImC8wqo9JCpmVRArqdwzGDVjS52/+1joJ46Qkl/3XKhvZikevUEh8jPf8UKQy+j/w0tPzE6eUeXX0v0BbHYEBXlEw/bppAz5wXeHuBV5EdgqXz4
 kvJ2y/+w
 OlFmIr3XKLc+Eloif6scsK/2P3kKvNIY3aC7qQM0hlUxttas3N+RKVDZTZZfRbe593o1aDzBdDCoS5JA1HXvFGNYCzkJMXJdOMEydIj4JQjrsHegWyrV4zCxH1j8j72U8F1gYYCWxp9bTO3bqgyI9aQbxa4HM1IMKlc2GNqDvKitcXVOSaYWXkGItUN9AEK9Rv5zudM59nhQxPp7v9HrXkeU9yq7vgy61eIBqWPgzwnL1ax3Dz2Grl59O+OoKm2eIs99A78qNrS36xIAzuNupUmKjkMblxEg+TFJKQKkYZ+acICmK7bVjvoAp+sqJO7jTKjvdTWHZM/v1pKebA7fH31B2oGkrCh0dZ+SSSq0XK30Q9Fek6BoX9HWv86iTqShTEDhNlOcnX6pQhyZw706SWQRabP/+/CD8ZhHaeuWJXK8Gd/OIBQQ0SBV5yf7rZ2DiyKNzt/mUegV10ISlWkMJ1BcYX92wO1QzjQlrPWI52E3Jmnjc0UivG0S2yvKwZXgNhY+MvKJ4NCDvW7xyTKb1WXDFgmx7gHmygSLvwmgG0zTEgP4+uzEC0C1B5HIyFALH5LEcfFao2jvoBNJ9ui9m8SwGBE8/PAuJbLs9MOPxFXU09bkP7hCESisUvBPilb9T8pRXHdB5MpI95GMHK14g6ij3sIVWzPXzokGYF7gJWVQ8t9zy5ehZcF5iA2oZ9SzB0PVPNSsnEdYTD8Rdut/zn1lwBovMqDqzxvicvVRGGLR4yDK9BMWmWt2XiSECxQ21WCbR+uzx44Ov6g3Sf+0DD9q+5Ehnv+t7mW/rhTNAAyy5IRbNydqzmxpJlwaIbVe8iblp2imjq/398lz2YOu7D50jULC8z+350vu5BFbSuY2MMci32HlwL1eGEsvnhYK1yoa6ib1XfnWef6Q3Qe2LCrvEd7KeoEyJAxsUJ1Qtyj4tQHqmD431YsXj0To+PjKp/c0kymUJvaRaavjHCocyyvL/vQ2T
 DAtidoYQ
 zVbd2WqVAmnzzra8S4/xjOYiM3x/dy1Ig2R0u7SJwGHm219swdRoXvZS9KlcL7mt3UfgNCO+PsZ9GIPu33d4vXzOwQ5fRagW/pDfRVlRwcEwdpqj0hHvytdWEWGy4YoApsxth0bnzHkjv0u6JK85RM7l3koGdD5N/0vmE+M0777bxy7XT2bYlzo3S2x9iyfcnIJq8ahAVTNiIc8Pvq/fYZ0S9UyLhRujgap2wIAoBtF8c3QANUYjOJcGGXS4MIaFeaa5rtipVKkN0XZg6VT/fq7bUs5JmuM/cXa0eVtOXcDbmqDagRRN1XqS8OjmfN220Zy/oE2Sdr/4KK0RNKJTnht4tVnfXov2csynpl6HtvkqtqKKLr6FJI61yZWggaFR7lM7vTZH8RKM6Ex28uwER8bcvUB4vYkQZP59gQqdfsvEg3AibSAIA41d4dcHAAHiLgiKLYs7FpRnwLXVu/DSwLKkRFeCFSxoQDQ1cRxBi6m9/WYja2aYxixqj2PNZwqptQKB+SyAkjrj38kLPxeHAto7v3oW+slYNuQAEuxLl7JXGpBsIO3hsoEgHbTrMUhgd6XxGbaxPW412d+24Esw120dMokmyYldHgBkMhuJShwb1m3/1iQKPyRlwWBztU9dH8idk18s84YaLkYkWRAcvr0tFdEUfRYJDftME9F2i9CmI/DNKuOWsYvTy7Jmxz9o2md9dBi7+1z+2LndFbZSO72E2cdCdA8g/+srvCW06J+a02dWWV1BBz3cGsP/KFOoPYE5XgxirZDHZlhti7cptKkMuqN7fFBBeddESuho168LEjfj2Y+lS1za4KigaOChd9jCfQR3Pk9ziGg84IMJlvDB0RdBbQN8AVyVJ6zgO8Tz/6vtO9/h7C16Cc5O+fHCRzHuPAvlQn3v4aZcxKgdeDKYaai+QZX2zAvBBTrV8k0OGEEMQntnvEsXxFhwS/CjOinPPulE83yvJzClChLluSIm4Ce1u
 Qbq22mlb
 MVOY+kYnJovLI86eDZimHbhHnC1B/+kd10HVxTuq8GKi497Xe3RIp+d9YzHBCQthePds/vDiJsk5G6DJB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit cea628008fc8c6c9c7b53902f6659e040f33c790 ]

The in_range() macro is defined twice in btrfs' source, once in ctree.h
and once in misc.h.

Remove the definition in ctree.h and include misc.h in the files depending
on it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 fs/btrfs/ctree.h     | 2 --
 fs/btrfs/extent_io.c | 1 +
 fs/btrfs/file-item.c | 1 +
 fs/btrfs/raid56.c    | 1 +
 4 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index d9d6a57acafe..a9926fb10c49 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3597,8 +3597,6 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 	return signal_pending(current);
 }
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 /* Sanity test specific functions */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 void btrfs_test_destroy_inode(struct inode *inode);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8498994ef5c6..489d370ddd60 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -13,6 +13,7 @@
 #include <linux/pagevec.h>
 #include <linux/prefetch.h>
 #include <linux/cleancache.h>
+#include "misc.h"
 #include "extent_io.h"
 #include "extent-io-tree.h"
 #include "extent_map.h"
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index cbea4f572155..6e46da3ee433 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -9,6 +9,7 @@
 #include <linux/highmem.h>
 #include <linux/sched/mm.h>
 #include <crypto/hash.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9678d7fa4dcc..ed3e40a4a3cb 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -13,6 +13,7 @@
 #include <linux/list_sort.h>
 #include <linux/raid/xor.h>
 #include <linux/mm.h>
+#include "misc.h"
 #include "ctree.h"
 #include "disk-io.h"
 #include "volumes.h"
-- 
2.47.3


