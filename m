Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ECCFCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB77C8E012F; Fri, 19 Sep 2025 06:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67668E006B; Fri, 19 Sep 2025 06:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F368E012F; Fri, 19 Sep 2025 06:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74E768E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:26:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B3DA13B5ED
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:26:51 +0000 (UTC)
X-FDA: 83905621422.09.8CAFDF4
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9BA418000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:26:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jBHlTIIl;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277609; a=rsa-sha256;
	cv=none;
	b=6yhs2VNT0G7S6I7RdPx99mQBD8wWAtq3HF9R/aQ8jcQPK6uYybguiI9vdLNFH0mwlRxzY0
	PucLMsYf0q7adsy/Ox3BkisbMfqxbfhLBYv3+6w3NBvhBwyDfmd0Ea3Sr//tnOxKCsAcUq
	Rof+AgUIcUghyY9DtpSZ73c0YyYCf2c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=jBHlTIIl;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf30.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3tB3MVnb5Sy0ootiHUhWzPUwXkEpU95FPChw/pDapE=;
	b=UZX8SWjIF2Dv3IdbDCQ8Rh0ovx4RFqUS0tQcOCzSI9h/KOksACfcVqTMjvsNRiiy5ykLhF
	ea+T24Kce0ViJEqXDIpWmvuiiAAsOfahrOGcvKwvvw7Ktat8r154kDqZ9rNi7MJ0cuJxJ3
	W24CGCBK7GkzPfD9Rbtg0PE7nxU5czg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277608; x=1789813608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o3tB3MVnb5Sy0ootiHUhWzPUwXkEpU95FPChw/pDapE=;
  b=jBHlTIIlNMXrnA9EPqGFNV3tTgR0AOfGokEYQ0StUslRUR6GwKwScgYO
   Lhr+XxIF6cCShcm2w8uq5dSVzNSaA1zElbXr+l0/62Aoa3+iX0UNqhm9M
   42Fft5o6EXqJ4Bg8qqGVgxLoy4cPHFQbahcKYXTNYCRXdHDCaNOi8fg4C
   g3EXmXESHHy6hOijCYgHgiZBJMNELhjlVZ0+F+i2RXFB2Xgpac5+70BTP
   5rk+wnwwWBWPSjmtom7XRa9DAHdGDrRgbYl2TN6xii7TxNGu8e0vKH+UU
   ouEfYgU/ZYsInib8y1ivpAFna5UURl6uzkxPrfOOYVwjuB0anb5xQPz/Y
   w==;
X-CSE-ConnectionGUID: 3NJ3iKzhQcqE1iv4wNCQKg==
X-CSE-MsgGUID: MgfbvPMVSna+ZthcAskKCw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2264536"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:26:47 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:3862]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.238:2525] with esmtp (Farcaster)
 id e16480e3-8a51-46ed-b80c-9e8f4a6d15fa; Fri, 19 Sep 2025 10:26:46 +0000 (UTC)
X-Farcaster-Flow-ID: e16480e3-8a51-46ed-b80c-9e8f4a6d15fa
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:26:46 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:26:17 +0000
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
CC: <jonnyc@amazon.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	"David Laight" <David.Laight@aculab.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>
Subject: [PATCH 15/27 5.10.y] minmax: make generic MIN() and MAX() macros available everywhere
Date: Fri, 19 Sep 2025 10:17:15 +0000
Message-ID: <20250919101727.16152-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BA418000D
X-Stat-Signature: 43q1qaac1d1k4sr5aguym7grsdmsqcwn
X-Rspam-User: 
X-HE-Tag: 1758277608-99503
X-HE-Meta: U2FsdGVkX1+dJ0voRzeAxJg10Y5AzhSAM5TxJMlY6G9gMvkPAs7g0/Ime8zfYGn+cBF7RaU94NKSpmivl7sliW8Y9wfPrdhXDwzH2VnTULoEA8/rjTw9iK9Wljft772aJIsr1kM/iK/CDSoXUHCRUi+WEXPOo4pYsA/KpGPnO28RCoDvOuoF6WPYQJj+i3qjvDZaHIlfLr71o68tr+Y04D8Un49G5VipsxeamwJFMCauulM6uwneDdCX//bllVkf4y33Wnze5c7YwP+lCby/HbO+3C/EYbMs3ISZaJS/VReJQwYG/f5sw4abbvupmgTvWu6yO/WdvhV4oIxG8kks1QhBcEAZiUU9APEgyAZfHYFdEQnZyLGJnr8p1NEIjjwq5qVjXbnzURfhkzvLT+iKYvDCaEqVe+38rkhwPEykwZN58rQ/mmPlzV7KcGbTYWKlr9BY8XFiftRBDBielhvLWQ4fdd8NG/QlN0J/VjjJuicFYU5clr13iGr2l7VMlML4+jV2+0zjLbRZB+QkSAzMEmsg8jb6jN5pFWIy6irhBXpegj1mL3GQ5OjJAwFiEvYfcqVsPcMkKfDXGvbaSuKXrjhqMGcCALVsNXcYro6wfkjeI2Bv1sIHP1cjEr8Kr980YI/twOtv9MfpWgAeTeO11xlSs/AcVhUSVpU6VhRRMG9DiEytlIDqLkqeqa1W9OEW5P8V491BBuixYzxELblik5WXPTT4xYrJR5gG+VYPGfFzI1NIwEoKhWqCmmvuAqyQ7iC0KLAkn+rIk5aVfR0nQr+BFV5B3OZ3pn7a6TDSJ+aV8Pfjrvgq5YEj4WlLzWn6lB4Udk+rNJEK23fHGsT4QeKQER62KF5rNSB6H/ZnnL70BkCo5qmOqM5mWlgkR68/iZHk+ECVeq1rONZD61ZGuuL5I9uM0pJ01F7XMum7DU12SgCwKdFIQifGfzPcswqaH40czCU34Y52wofTerQ
 oJUtbn6P
 V5g4sI8puELl6Z9v7lvMxY3xSxf8zkCO7YgiFXJvw6/BgU5YucZ+za1fFpWLAnzlYfsN+qOgM72bndle4LIYES/QaL8Pg6rHTxzpPwD3iS5P8D6P4qyaDvyqQgoNzJZPNErchVSfSVSpt4uZ5rikLDWT19gMj4J63vF/+p7OFFLQGvuSljzx35w1W/hGlpBlN0v2Jv8aMPc7RcwzkKLsiZK88749yJXmemb5nHT5CfwySM7BYzn7pxJ1e2FN/fbu/kkZRBwa7cOE95K7kG8fYsAvNLuzdHlxWc5IQ2G+l+k6gR3oOv+FfD8SgCWlEQ5vFS1xGzWyEBEudoM/vwdzI8NYSNWD/KfHuSucdkZHZv6lagAwV4Qeh/rOdoT2coBVZjKOo6zT0/JIGkITcEkwzFgC3l5qiMisiuGdY/sAyMU69cVquaxjfFswHGavwMtSOXRvNRTJU2oOg+62LjohrD87KlMUtFbyNaWe+hDMIGxj/wuNUn92rMAivat7xFrPPqTOCXXdZqQ3sXAR3q2OZYkKgnoLbdIONUHbBsp/bI9zQq7V5gYDMO7x+TapAxr6nEWMpktNkvmBOTuC9kf8IBvKezywIgFdm02i0iFdcnBjJE5AxXzxNnNykLcDhDh3tQATqgtZFusMkr2GOVvr0M3kRHmzaY2OgRWv4g0E4faLaQCYwpDMZ/NWS8mGjFm66ZMHERHXJNAJCv//QtbDf0xZ+yDNjzKKDj1AJGwYYVd3L6jGeoT4mqhkOnBPmDzCfrPEJ9ldW7VtR5uDcNZWc/CMxg5ANp1KYbVu0Il41zCLzJdlgAA1r84rF7XdwBGLURqLhrqWezQFxjk5jmXd72e8moNINHC5/rLJeJbsSjMsba4zfX9w+ZCspLNTnc7OeopzkchCFA7o014NJJOIzorSHtMfDQidQqMm/luzL2hrkZSMKnehH95ETrw+RMWePjdAWhVbmLH89yzX6znp6bmh8tQLK
 VIdU6hY5
 NYcpSWZW+1LcRur3MpQ4BhosEVVt3wxCASELTTQeeca3FtmQHWIxFNwLDl761E9qCMKeSflxn+91NpD+S34aPTdEdCOnSAnGv1NP8sHPAztXV4dP26Z8+QB9nrWpkguGIQ+yWpy4/O3+aEGQZSAwXM9Bu9IpJr+2NJhyxA6Bt/kJbBB0nGhqK75DecSw80xNOxawSQiV4GGtCd0LqIlYex0pVuvXsZqnvqmBNemiZv/Qgc9aCI8YO021WMld/57IdqDPkNE1ruTHWqscWTAj1v30Yzb+HLhGEu71mCTFibvuyIGl+RcwhKUY3BMea2y28k/BrZRyjVniHEDN93cmOHXSKrheOacw0v0kem/VJNknnpeXNAQ/uM73cfT+st1CLl6L4BIddA4OWmu/oIhnxzCYb7oXrb+Ba6g+vkwkhBX//54VeA78ejbfIBo02IQaackoHJDWwdOoPE6t3CWMoWBe74hiIudmjPN82PupLXdQZLva0IgYJdA4HnrrTEAmRN/kUHIK4Xl/BKxquSrW0klc8kaidpXf4kfcVdtpNX6YNS7YpVVFA+GY+q/F4ZI0Y65W4dpYk+3QmvlSukxWXCeHw5oFMbvp6fsIoFZRS/1JfnIT0S1kvFELP5MH7mj5jxpq4AxDdf8hNCe5L6bHeeqSfP7ROMgd1mkNbQl6/IxJCWxbrDTyxiKVpBMXiF9iD7/i/QY0Ahl4eu1kDJIYVJZ4ipKc8c4r4slZqwCzSccu4/9wRPgXyUvlxxt3esLXXBusXXmJN/lFcbhsAAMRVACVj7C+e/WzKKlORL/544rxBN6JbynEpTq4eCBZrhbQ5NddCX5bHtn2WqzFf8xz9oWBmSp6HvC+azJriX/3yE0ARqK7Runv7wM27F/ukyVAaTeF/i2I8h7PgwpqSVzNEY5z8UdrL+s1Dx1Fopb0lS2cjcz+XA4B25bkBAMN+gEW7b3ZdupQrZ90PTRrxS0ntbdvSgas2
 ooaQGOKh
 ErlMsFEpWYMjWWas4Qn684XlLh2uw39GJqoHRjSYwtXSGapgy+AyN/Qsfqnuw8F6jaRjLF02Z5+tNTSm9j8isfUhoxnfLo0ndPLtQM6y7KoiZjNU1rlrtXWf9ogo1UidfBlLUsLMpVA0SUg3riqaeUMx00i/uxorArJ6EsM+bn27O1K/L0EHgGPjKqqzuOp89E4NqpwcQPt2s/SoKY+F1B1uVCNhF0WGr7Oxx+Xgu2VTUzO20uXTqKhjLZ17L3zKm5l5ObPr0cTYqsToxkFAamv/9L9xAXu0nsq3Du8aLS1Zvw1YeOopcIHtlzbwaGEw/R0ZHzFQJzOv2XveZjs3xDH6Qh4lOJBO+RM6OcuganTq6rerqMoS24BOowM/xZYP9l0a2Iglz/iSfVF16fwL1AuYivHekGx8KXvuLOjoVBGUW9Nkje+TasZGms2Mlz9x36GwAPUwdpyhNR/+RAwIAUK+WckTf75qAXe8iHysGGBJJPyMIcWVeSd5il3HQ+MFNkEwsEiLFc9eqL/oUhjzVNNty+rgFZLtjIfiusqWowA9fZOYPbxxoeiVzTv9W0gxF/JKE7aqlaAPGGZ7d/Pt4pyToLjM/pdMcpl9tRBnKOs3wWP3HXJMn3GIlgKeczHPR8pLVQjk/CBhtZLoyy6dTrFG/xz5TNrVjxF/T6IdO7f4Q8B0N3dgWAvA0pn945YJ22oE0X35ZAUJeB3ZhUEXYiofMNs1OMoPerwcOb6nOvStwJyQ1zfjJpxmkji+ZenZVhxB2GMG9LXc2+P1E3jwCHHate3qERdKDbhR7ma+62/pjSahs2ixNyXzNd7gkmPQ8d1A7f4kNoa7fvS0P/B7AkvbU6x3eQesyAUjFhcYr9CQF10VCtqfafwUz49ACDd6evrV81riE1ob+DQhumBNtJ0inVZ9mCMu9AG86Hfn5c9NgbhHxxObY+D3ZcM/WZIfMG7OCeYiszTQUxh4vXKAz5/yCnZTn
 32TceOxx
 LdEM3Z/FVbTG0UmR0LbFBX63Qj+jTnmx6YNXANrSthJj6xDd2v1DH6V75oiBYoS0MfeWh7Z7frkosH87r6g+VYIeMBb0XOdRdn4GhuPAY1yorpDK7UdF0pVEMwJkJe116F1SLZa5CfkLs5l7WUXNMLm7emyJrkqVLLpJxYqbW0+JBq/yZRZG7de4UAmrbDFnMn20H8cCwLRMLzW+KIS67DYYkR9FKxT6ppxXwY6avzpnc1I85INeWXAKwHIIYnfEa4ACE9tyXq9M1iZa8czdChJkgkFXNjiZFIJeEac8VQdSORkM8jutjHSAa0GIl0C5yfXHfRUoYEBpSulXbnEI9gOdlWflp1Nj4ncwROQzKcGPPlgYJrf+QrXkaoI3jjsOud9lRGTWIsGpIZO7LaeYEmEXsGMaU4VK3c7Dxe1N0kBJBrDsXEq/4+cc1QJ9IL12hXNDgD9ntbe+dRkPlqpKBd+5qA9MYwg2c0siD1bPVnPmShT9Ic31qqD18453o914wsbJurwUTg0uDeYnVE1lx9JNhvv3kq4EKshtMAg2oeJg7TZJix2FFgZP9DfbFzyDqzGEnbF6CD60SpcfKH9ioF6+nxdlB6az0zuGCN7W/qa32ySlEbmi/uSfqe2n6ROXAsEFThctEZMd937oyuBp5vcjUYe6JFjLbjTckN1fG18IyiPvLCCi3K5P7Mxkprm8y+v3rjV5vIR2GvTFehIZXIO6dPrWTjfirL4WKWKMaTl6soupiuq1pIPRF+JW/1d/qE5uOerC2XNYLxD+MxxnPfO7o4Mn4ORAnODJdK9eVTOAAFLMgXSeYe9Ns98h4LEJWVPW4lYtRqKOpNP9KY1s3zZq6Mnq3ZX+/4LWeTvU8bT/dtmCMmYgtnlJNEm92C0KOjCQ7Kxat55CY9KWt4RzDTBU9vL+22F/5w8hChpZ+pY/2wJR2IfGxuWQQziJJBvKSCPQb5fMHbLeD1W3/hGz5AlcJpemh
 tCAy2yeI
 tjTPOZ6fjhHsWIkZY7TYCyKXrN4OD5V5Kat4RUtrI3lyDrQ42CpmnOgRyP52bxLe8fr5o4BOORZdjluP1imoerktGT5TJ8ajUteZFuAiMCvh9085xmH4xbjXdpDnqeFaZbDYyu2NbzsVWVgTuPiqBsoIwcTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]

This just standardizes the use of MIN() and MAX() macros, with the very
traditional semantics.  The goal is to use these for C constant
expressions and for top-level / static initializers, and so be able to
simplify the min()/max() macros.

These macro names were used by various kernel code - they are very
traditional, after all - and all such users have been fixed up, with a
few different approaches:

 - trivial duplicated macro definitions have been removed

   Note that 'trivial' here means that it's obviously kernel code that
   already included all the major kernel headers, and thus gets the new
   generic MIN/MAX macros automatically.

 - non-trivial duplicated macro definitions are guarded with #ifndef

   This is the "yes, they define their own versions, but no, the include
   situation is not entirely obvious, and maybe they don't get the
   generic version automatically" case.

 - strange use case #1

   A couple of drivers decided that the way they want to describe their
   versioning is with

	#define MAJ 1
	#define MIN 2
	#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)

   which adds zero value and I just did my Alexander the Great
   impersonation, and rewrote that pointless Gordian knot as

	#define DRV_VERSION "1.2"

   instead.

 - strange use case #2

   A couple of drivers thought that it's a good idea to have a random
   'MIN' or 'MAX' define for a value or index into a table, rather than
   the traditional macro that takes arguments.

   These values were re-written as C enum's instead. The new
   function-line macros only expand when followed by an open
   parenthesis, and thus don't clash with enum use.

Happily, there weren't really all that many of these cases, and a lot of
users already had the pattern of using '#ifndef' guarding (or in one
case just using '#undef MIN') before defining their own private version
that does the same thing. I left such cases alone.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/um/drivers/mconsole_user.c               |  2 ++
 drivers/edac/skx_common.h                     |  1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |  2 ++
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    | 14 +++++++----
 drivers/gpu/drm/radeon/evergreen_cs.c         |  2 ++
 drivers/hwmon/adt7475.c                       | 24 +++++++++----------
 drivers/media/dvb-frontends/stv0367_priv.h    |  3 +++
 drivers/net/fjes/fjes_main.c                  |  4 +---
 drivers/nfc/pn544/i2c.c                       |  2 --
 drivers/platform/x86/sony-laptop.c            |  1 -
 drivers/scsi/isci/init.c                      |  6 +----
 .../pci/hive_isp_css_include/math_support.h   |  5 ----
 include/linux/minmax.h                        |  2 ++
 kernel/trace/preemptirq_delay_test.c          |  2 --
 lib/btree.c                                   |  1 -
 lib/decompress_unlzma.c                       |  2 ++
 mm/zsmalloc.c                                 |  1 -
 17 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index e24298a734be..a04cd13c6315 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -71,7 +71,9 @@ static struct mconsole_command *mconsole_parse(struct mc_request *req)
 	return NULL;
 }
 
+#ifndef MIN
 #define MIN(a,b) ((a)<(b) ? (a):(b))
+#endif
 
 #define STRINGX(x) #x
 #define STRING(x) STRINGX(x)
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index b93c33ac8e60..5adba76c3f4d 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -36,7 +36,6 @@
 #define I10NM_NUM_CHANNELS	2
 #define I10NM_NUM_DIMMS		2
 
-#define MAX(a, b)	((a) > (b) ? (a) : (b))
 #define NUM_IMC		MAX(SKX_NUM_IMC, I10NM_NUM_IMC)
 #define NUM_CHANNELS	MAX(SKX_NUM_CHANNELS, I10NM_NUM_CHANNELS)
 #define NUM_DIMMS	MAX(SKX_NUM_DIMMS, I10NM_NUM_DIMMS)
diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
index 1b2df97226a3..40286e8dd4e1 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_ddc.c
@@ -25,7 +25,9 @@
 
 #include "hdcp.h"
 
+#ifndef MIN
 #define MIN(a, b) ((a) < (b) ? (a) : (b))
+#endif
 #define HDCP_I2C_ADDR 0x3a	/* 0x74 >> 1*/
 #define KSV_READ_SIZE 0xf	/* 0x6803b - 0x6802c */
 #define HDCP_MAX_AUX_TRANSACTION_SIZE 16
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
index 8f50a038396c..96b03a342f38 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppevvmath.h
@@ -22,12 +22,18 @@
  */
 #include <asm/div64.h>
 
-#define SHIFT_AMOUNT 16 /* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+enum ppevvmath_constants {
+	/* We multiply all original integers with 2^SHIFT_AMOUNT to get the fInt representation */
+	SHIFT_AMOUNT	= 16,
 
-#define PRECISION 5 /* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	/* Change this value to change the number of decimal places in the final output - 5 is a good default */
+	PRECISION	=  5,
 
-#define SHIFTED_2 (2 << SHIFT_AMOUNT)
-#define MAX (1 << (SHIFT_AMOUNT - 1)) - 1 /* 32767 - Might change in the future */
+	SHIFTED_2	= (2 << SHIFT_AMOUNT),
+
+	/* 32767 - Might change in the future */
+	MAX		= (1 << (SHIFT_AMOUNT - 1)) - 1,
+};
 
 /* -------------------------------------------------------------------------------
  * NEW TYPE - fINT
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index 468efa5ac8fc..3ce87e5f90f7 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -32,8 +32,10 @@
 #include "evergreen_reg_safe.h"
 #include "cayman_reg_safe.h"
 
+#ifndef MIN
 #define MAX(a,b)                   (((a)>(b))?(a):(b))
 #define MIN(a,b)                   (((a)<(b))?(a):(b))
+#endif
 
 #define REG_SAFE_BM_SIZE ARRAY_SIZE(evergreen_reg_safe_bm)
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index b4c0f01f52c4..1e0678eb0077 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -23,23 +23,23 @@
 #include <linux/util_macros.h>
 
 /* Indexes for the sysfs hooks */
-
-#define INPUT		0
-#define MIN		1
-#define MAX		2
-#define CONTROL		3
-#define OFFSET		3
-#define AUTOMIN		4
-#define THERM		5
-#define HYSTERSIS	6
-
+enum adt_sysfs_id {
+	INPUT		= 0,
+	MIN		= 1,
+	MAX		= 2,
+	CONTROL		= 3,
+	OFFSET		= 3,	// Dup
+	AUTOMIN		= 4,
+	THERM		= 5,
+	HYSTERSIS	= 6,
 /*
  * These are unique identifiers for the sysfs functions - unlike the
  * numbers above, these are not also indexes into an array
  */
+	ALARM		= 9,
+	FAULT		= 10,
+};
 
-#define ALARM		9
-#define FAULT		10
 
 /* 7475 Common Registers */
 
diff --git a/drivers/media/dvb-frontends/stv0367_priv.h b/drivers/media/dvb-frontends/stv0367_priv.h
index 617f605947b2..7f056d1cce82 100644
--- a/drivers/media/dvb-frontends/stv0367_priv.h
+++ b/drivers/media/dvb-frontends/stv0367_priv.h
@@ -25,8 +25,11 @@
 #endif
 
 /* MACRO definitions */
+#ifndef MIN
 #define MAX(X, Y) ((X) >= (Y) ? (X) : (Y))
 #define MIN(X, Y) ((X) <= (Y) ? (X) : (Y))
+#endif
+
 #define INRANGE(X, Y, Z) \
 	((((X) <= (Y)) && ((Y) <= (Z))) || \
 	(((Z) <= (Y)) && ((Y) <= (X))) ? 1 : 0)
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 2a569eea4ee8..9a9ca5a8918e 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -14,9 +14,7 @@
 #include "fjes.h"
 #include "fjes_trace.h"
 
-#define MAJ 1
-#define MIN 2
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN)
+#define DRV_VERSION "1.2"
 #define DRV_NAME	"fjes"
 char fjes_driver_name[] = DRV_NAME;
 char fjes_driver_version[] = DRV_VERSION;
diff --git a/drivers/nfc/pn544/i2c.c b/drivers/nfc/pn544/i2c.c
index 4ac8cb262559..b9a58a424933 100644
--- a/drivers/nfc/pn544/i2c.c
+++ b/drivers/nfc/pn544/i2c.c
@@ -126,8 +126,6 @@ struct pn544_i2c_fw_secure_blob {
 #define PN544_FW_CMD_RESULT_COMMAND_REJECTED 0xE0
 #define PN544_FW_CMD_RESULT_CHUNK_ERROR 0xE6
 
-#define MIN(X, Y) ((X) < (Y) ? (X) : (Y))
-
 #define PN544_FW_WRITE_BUFFER_MAX_LEN 0x9f7
 #define PN544_FW_I2C_MAX_PAYLOAD PN544_HCI_I2C_LLC_MAX_SIZE
 #define PN544_FW_I2C_WRITE_FRAME_HEADER_LEN 8
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index f070e4eb74f4..a66a2ee3a9ed 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -757,7 +757,6 @@ static union acpi_object *__call_snc_method(acpi_handle handle, char *method,
 	return result;
 }
 
-#define MIN(a, b)	(a > b ? b : a)
 static int sony_nc_buffer_call(acpi_handle handle, char *name, u64 *value,
 		void *buffer, size_t buflen)
 {
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 9d7cc62ace2e..8c7594720ef3 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -65,11 +65,7 @@
 #include "task.h"
 #include "probe_roms.h"
 
-#define MAJ 1
-#define MIN 2
-#define BUILD 0
-#define DRV_VERSION __stringify(MAJ) "." __stringify(MIN) "." \
-	__stringify(BUILD)
+#define DRV_VERSION "1.2.0"
 
 MODULE_VERSION(DRV_VERSION);
 
diff --git a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
index a444ec14ff9d..1c17a87a8572 100644
--- a/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
+++ b/drivers/staging/media/atomisp/pci/hive_isp_css_include/math_support.h
@@ -31,11 +31,6 @@
 /* A => B */
 #define IMPLIES(a, b)        (!(a) || (b))
 
-/* for preprocessor and array sizing use MIN and MAX
-   otherwise use min and max */
-#define MAX(a, b)            (((a) > (b)) ? (a) : (b))
-#define MIN(a, b)            (((a) < (b)) ? (a) : (b))
-
 #define ROUND_DIV(a, b)      (((b) != 0) ? ((a) + ((b) >> 1)) / (b) : 0)
 #define CEIL_DIV(a, b)       (((b) != 0) ? ((a) + (b) - 1) / (b) : 0)
 #define CEIL_MUL(a, b)       (CEIL_DIV(a, b) * (b))
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 9c2848abc804..fc384714da45 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -277,6 +277,8 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
  * Use these carefully: no type checking, and uses the arguments
  * multiple times. Use for obvious constants only.
  */
+#define MIN(a,b) __cmp(min,a,b)
+#define MAX(a,b) __cmp(max,a,b)
 #define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
 #define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
 
diff --git a/kernel/trace/preemptirq_delay_test.c b/kernel/trace/preemptirq_delay_test.c
index 1a4f2f424996..91a3f4006ae6 100644
--- a/kernel/trace/preemptirq_delay_test.c
+++ b/kernel/trace/preemptirq_delay_test.c
@@ -31,8 +31,6 @@ MODULE_PARM_DESC(burst_size, "The size of a burst (default 1)");
 
 static struct completion done;
 
-#define MIN(x, y) ((x) < (y) ? (x) : (y))
-
 static void busy_wait(ulong time)
 {
 	u64 start, end;
diff --git a/lib/btree.c b/lib/btree.c
index b4cf08a5c267..b12f99d4c45c 100644
--- a/lib/btree.c
+++ b/lib/btree.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#define MAX(a, b) ((a) > (b) ? (a) : (b))
 #define NODESIZE MAX(L1_CACHE_BYTES, 128)
 
 struct btree_geo {
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 1cf409ef8d04..5b9c7a1bfaf4 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -37,7 +37,9 @@
 
 #include <linux/decompress/mm.h>
 
+#ifndef MIN
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
+#endif
 
 static long long INIT read_int(unsigned char *ptr, int size)
 {
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index f5f80981ac98..bd66c28afb5c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -126,7 +126,6 @@
 #define ISOLATED_BITS	3
 #define MAGIC_VAL_BITS	8
 
-#define MAX(a, b) ((a) >= (b) ? (a) : (b))
 /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
 #define ZS_MIN_ALLOC_SIZE \
 	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
-- 
2.47.3


