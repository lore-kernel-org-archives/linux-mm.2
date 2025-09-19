Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21094CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3C68E013A; Fri, 19 Sep 2025 06:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7842F8E006B; Fri, 19 Sep 2025 06:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625A08E013A; Fri, 19 Sep 2025 06:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBF68E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:28:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BD4B13B659
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:28:16 +0000 (UTC)
X-FDA: 83905624992.23.E6A6F19
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF76E1A0009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:28:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Otl2E9aJ;
	spf=pass (imf19.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRUlUXU3Dk+icKuiOL9Xs0c0wDaZV6bPawHQ91OSf6I=;
	b=o7ZZgtAmXzB3/rwwbopQ/0QyrGij4xtzkTT/YZuHfGJIDT4CN5lS/0jzeTZpdtiTNEGEz8
	jLI0hjOgdrAGZkmOmI7i/muJ/Cic/murgPuufuoQ5TCFzEbRhefxWrWjWEIlD43jxnm7YB
	33m9ric7WEEpxyevgZ3bSZL1+F/ZwN4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Otl2E9aJ;
	spf=pass (imf19.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277694; a=rsa-sha256;
	cv=none;
	b=yaFOnmejHP1ngzG518svsyxxD//K2v7298ijXJVixdiIPcgKchvebkNOnT8el1vTmwZq67
	mUPjj4OKehkmqoy+qtnQ8S83TvJ9+2IH1HnZXYKq8bYqFyCyRfVP5lRFhvMELcdgtkbtgI
	Zqc5AoIyXyjDafZApnZodZ9TeB9P9Xc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277693; x=1789813693;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JRUlUXU3Dk+icKuiOL9Xs0c0wDaZV6bPawHQ91OSf6I=;
  b=Otl2E9aJ7DdxrmpTVEJf45QY99YqTnWIVx/WKUMbp6a74DAveXIf9JIR
   p294cVONQOQ4m58y2iTamYGl08mAFhEQwQ4/26iSRxOdgQyGz2i2T+FTh
   ZxCHLOKVfbO/0HUGf4iPkearggVnyjevnIR1zHySE4rNkqRfad7Ar4G2/
   eM+KVY5ZVrRskWiLwQKhVmTjgcNJYFtG0AIC4FpknH3gV8aWm04X+lQXb
   DiTIjTI2VI2o4vQFnmXgiq+oyfJGSoSwZDlab5+yEnSuhQ1yRt2P4cnCp
   PYYPfkdzylAMRBYWpSulCht+cFxTTZPxAIgyR+C/jLly9ASNXf8XpXJOh
   w==;
X-CSE-ConnectionGUID: UcFSLBkOR5Oo9QbMRTSXmQ==
X-CSE-MsgGUID: Av/QSezCTNCVwrFMnuqwdw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2367764"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:28:12 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:22508]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.39.25:2525] with esmtp (Farcaster)
 id e109433a-1eb9-4ee5-baaa-f7ffb97f033c; Fri, 19 Sep 2025 10:28:12 +0000 (UTC)
X-Farcaster-Flow-ID: e109433a-1eb9-4ee5-baaa-f7ffb97f033c
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:27:42 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:27:13 +0000
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
Subject: [PATCH 17/27 5.10.y] minmax: don't use max() in situations that want a C constant expression
Date: Fri, 19 Sep 2025 10:17:17 +0000
Message-ID: <20250919101727.16152-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: CF76E1A0009
X-Stat-Signature: nr81ghjq3cdzsiyd8wbne5yeruhqr39p
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758277693-983678
X-HE-Meta: U2FsdGVkX19GPmCP2fprzy0bu5iQo/n5U8GjbErpfOyXb2IswMpHOUlKxqO7Kn5YdN79cigI2nYvl8m6wRw9vANkc2CvXPXAIwrVeap8gXwG1MhzGaEexexyCmwnXIR8II+qx/IX+EyFRSckNBeQOMBr0i+/mOTMhbudBrqGqMRjEKTLOkByY1aIa83p5O8410s26jJplam3VxVUpX9V57cchFZm+Va9onwJyRG71YrhI0r4t2BoGPdj661vP4fvciRyThhN30uwGIktXUcSeJvV1HkKenndiRpqmMeVv0R4j9pW+tInFXY3DNoc3/k5lrNMFEA8M2WzI9ofi41w7VpMmUH3e2zIlLAEc5upyiu5DunM+2+C2x+VhmNkyPo4EPq6TIuBFx6O233pckVPRqGg+Mv60pQG6JZTd3NJqeiB+bNKYc7pQ4SUDVpJn5KrmAa1J+NZyjVaEZYzbbPoI4z1FN5KtnfvCQF+oks6cO89not07bXjxcYyup5XGTTVFkS9uJtFACBwXfGSTU6twyZnu3oIbcZBbItMA6V0SA3ZQ/nbpQITZnFPDDEVbJWSKVVx+pHSQPRwNdtQTQuJgKDgxHvPzSRHFx0X5GdolWOo5yB9ANAEXz3XJqfeCX7mZ4TZq/y69tVC0gOSKmRhTJw5egrQWWhRRsd37J2rcQ2Yw0AvjOL6i3UtZElagpEsQghStpVts7DsETXveU9poeSr9CvQkSdy3JY/yjCKsDCOdyoJz1VFSX4cdS56JJmtf+0PjL/15tmTA/aVxJqClAxLeGDJom6+0xOa2Cmf9DIVFlXdJ3kbeUghm45D28JkmRaQIiiYOYw0pDOaz2nUmBQ2qkWocXja/z04YX4G/pbRsZOjCN2iXHFKGZHGG+SQS2CN8ChG3Khrj2caW/GZwUMhmfHyz8LPIPoKLiyQY0IWh+LqA1L8PgQInrMi6JzFbvrul56PUiL+Vl81fJN
 5ozLPXBT
 9adH+bLN1SWt/qJ1zD0cgg3t2oxOKKragdYuhYwY1qB8m8Pb/SwmpUKKyl+f7H2hPt2Unfe9qC4ORaMiiblOUShm71WXqjD+5SDVPu5k4SrUF9YVfqagvlpl4G1CXBWyC4ZbvivFShsibuAa96wyhKkcUQw03IPcNjn6t4mkTLRV5z9Ko7OFx1ePu/NYYPoLKyl/7h4ZSDvz6uqwuFjjyi3KfBvuw/LOR4+j78jy0LqPSlTNaE2ZWedYRn+B1SUnkXVGM+nLyEwab7465OuV5ohXvG095Gz2ZAINBqdHfwYcNMmlSbPlISN9MG6DQAjsz7fZp9tt4QQ3RtYF3iHAMts7+gOBlBUBFW6qQ4RQcXjEVbOkAqyxl1OPHxBsevRlB0eTi3XspgZrrne+lXygKu8mHTP7k33zsHpyGViASCKjpRKFYTprWFaktJYCehAzW/F/53Ek+Ff8N9Y2Dutax6jng74mlPpL3Pi1Lkcqm5zt5cNnbs2pxxoWRQ//RRkAzImoHalpQ6u0GuKLMAY04j1KIeld8mlhfXDaQpRRJnEHjmioZc8OLFttMvwnes8gkI3AcdIIMwGEWxZGZc2DyS1D05KkwPva9N/GHyA2MfwexvXkzn4t+Xqg+viXj5DhZM4tkRzwHWcOKHLgzLLxFnhvcItH47FNYpbI2jpKeAKYeaeHZCNEHflgeWfv8h5vru36I0FBDj8KOoK3DS4U3XOhqV9JuBlXqTNL12ApcOR9ONYgdONtX8dByW/3ZQBnRvMrlZIgTcmksErF+QOmHlAM1PTZ0K71Az+BvBaeqj+l9rtOw3dex+1YBJUuF/VBsuBzHsHGamiw0zS+mtYLpF7EyOt2YIgwkf7Ualoby1D+eeuHuxgHS/8A+hvPUmRK4wWALCuz8KfbloqB6uZHSIjuV8qBZ2fWHKjyaDoNJa0NOS0+9Zn9i7Vqsmwye7Te1EMGPNcgptQIrYwWXOqRVP6jTgTaC
 pcuauUB0
 MyCyyaC26QbMjS5NhBEEaSi4swxAZfoQbJW8GIzHCxYfEv4mNBwBqKn4kQ4TVeDgCkgMfIboe+cH+7dXQN/jTWNgWPEGUpxqHSs+BASWl+4tEdN26fpu0NnVBPzgmjgbRJRXxYtIcHi31h/Kb11OBXfEwQFZClejufCbNGpmcxZEJ+r3vDBCl40C+bdfHjSbaSazjQ34AlZElNVpZnPhdEjuEPyPBjM3StgKhnvEAfQ+1qTYeSel9hkzJBrbP5YLkjpf65jjhhnuqWieMglw3jg0U15iaubYBRR9q+ZUPlOI2GVQsO55ImJ9aFaxqUpTa5W6fU2r329jZCP7hIor1WNF+aOnPul7UPwvo+cz7vLmQHPQ8y8mZInQJbvRAIbqhfcOI9MXS5a6mz6ypdgUCyBcCYQmtHwaKqlw19sqmK0T0pn6vmIPQTnyvIKkgxm4PmzixRmIjt9KlArem3e0BqO/yptguMQt5xbKYar/QgGgHNvoAyfSdjN3MV5FlwlyJ3g8X5ExCpVMuueKOHeJM6aZgc4MxSteb3XJJGKt3FTTHv66mJN65Gi1E200Deg+9r8hHVJhE0JxNnoU60fP3oe0pqRMpQk49w0bHBBiXKnClnaLrdB8lbz8bc+WnQo488kMfvTDzh2kjOU72Z3wdFEu66viHAWjo3qU7N2JI3lzmr+ntNEgtoHbtrATzj8o/8ND9gGxCie5vYSBKvvLk7K3Masfv8fJfKZ9ewNQ7HI3IWEHyuD/Kh8HDB1Qz/piXLdvt4SW0/jcjCFS7QmPe4XdT7Ey56KbwuJ2ATstJa8f4R1LDjCv+EeEORytBc4x8ks5J7w66FuCzXa12HcC2TZzi8frqMNAWHe8aXOIaLA4p1TfTD5OnedtTKNCez/zsQn/wJrhSzrCtnA5T6IG9iUO5h98kUnz9z+LusJ42wkK9ZPfyuivNMnal0P6j+5STYnMk4J/z4K1FP7bmawYwTXJ1JtBO
 JBVDgbml
 U+VEFUaR9RdoPnaALDAv2chTCTIOGeTRHNTDF0cTPiNTk/fa0syfxWag52wMG+3O2AywaBMAjcYFttUEjK5uwrAQvbvy6eHaAhi+m9J0ap0mhHc3CvYcS3fDo0XJwpe/WPdiHx4QuBJZvIrn+SyAaCNa7cJYw0wz1wuBsf2d2Te7e2GSVeIOF9R2UOksP4BmcXKeZvMCL43OleE0kmVOST/ZTCQ5wdKZfnvsYtbExqu8cb7m7F15M8V+BgyAazya4KdzxMxuj5MG4hjyBQzu7TjOQe7kbxFjwupbzTa8rb+vd0d4H/Mlk/7mQBBUMFPt0il5wWP8WW9ydd4YWFxX4jZ0ttf4q49+5GmUctoC6SUE0qic3TM8L/1oBJH2W5pClSrLkl5tbUl8rbGiAhgQBbNlkutUAdqib1l3pJZ/uxCWei0bUULdXTCWNYAAL+n8NurvhA/VbSL5/5AKAj1KiCPedtrUx19nv1Ty5cDQPeHL3lkSF30H200Dra3MFaasmYKIJYueOLSDOpcbb4fIor6gorcmxhRvC8zZTARuU9a8pDNzPqXnH46Lot9LMM3gDJIxgleLqtCvLtoUAmDMKPkMBhYQ6Uyj/zBzomS4dzvrpZ96f8/GmYIGyOvzwhv0EiHM+kX05l6taiRcZTDFxHgdjCY4Vt8XpVU4jNAa6MCyePwYc3dRhBE5/3MDf9MAP5h5B26S+9NxuoODv+2gz65oWVwhZ+/VT4b11hjg0nLEJ3cE5Yv0lVBh+PYfFxuisVwn89j04gAOx5rGmNN066xzc/280FEQ17oo7Hs1o8CurgFu/ObRm/AH9UNiQ/PE2PkRJyRi+K8zIf/S7gecq8yLzP6UB0cE5mrEvZeIWhmDVKQs1tHMKdM9EluFrtEjDjWWTaR4+TRzHN3Pdx0ZjWiW4u+nFc5WYvNb4DNSt3yyG9TQTV0bz4n3uBu702l7IsotPCIpF4bdo2AX3MI5itlahsTv3
 NQoquMD4
 kJL2sDOamMj+LYd9Be2LjXMUlSPimhF1C05AcBOE7Ot/AnH1q2aFVgTekIcruNwpQlB2AOwMjBgaj54oM8gA0ntgdEdBzUTKeCg4EIOJIE329kTIHtRxqLo2YsSHwi9iOYPjEigBJ3FozxRhwX+jGnsvMcB1AWNhgb+zOxMzVNnHQL3iSRl5UnkotYfCcmqvrOW0cX5QoRkWNAnaaHaM4nYeRzE9Sk5HeIvH6Tu0Gkui+G2/PydHV2EqoCsAAaNGS4Pa6c0kAlo4nY1DthrdU6r8BQY4SmrGZKlpTU3RTyzcXifRBYiXN0/9aCUjAwtk0njugJvS232HNgk7IsIUmId+KEGe5ldpPNimMT+3p/FjpXlUXdHZQV/FGQbbNMrsNhV0FWxv9qL8Ib7zbICXhbSnTDGmmah7KykzUraabbatre45vhHnzLLR81n3Un3RrRMuAfPcMS+E6gUZTNsf6PScorrBSn22FsMxNw1ZTVvmlGQKMStON6cQh4wuLxE/vxnt4RWi+9fJU9PxlEYoinUHoPb9tc7td4XAnk4lnrtRQspt4n4mrz2xZqAmJVEaKUCqOeM5TcEEFsuin/2EEohTYGPc9ljm+iP080u6IHF4q9ARi/B/yos0HcnKleVQujPXnA/5qxYtxblJSjZhTmfca3hk4b71boDzXZk6ArSG4lVQkd7fPxIhWe8R4IZ+8kCQB/PKIbZDrACHts6PZ9OmbOX/xiNYwHUpHMBocFpS1phE0KG0JX+V+niRPXUF3ePKQZK3EaLOdhvrXpk85wdZvXlCUbh28Ox9q7eMpJbSnzfHC5MwbwMPM/sfW7z1fZvyd7tqpBe6mp7DJm3hU92VobT9Abj9f+sMnoUCN9r0WBhKl7QwyWVqrbLTmqRXwJ6czr+HZascOwcI2O2y9KU/v8w/vfxu+Swp29UuKgpEKL24v6yFWdGVyeakQTakcrKAc5Lxwi30q71CopsNREcmww689
 +rozmM9T
 gAUzq7jVrdnrwuq2IxXibIOmIm7w68DdPeiZgXY3w43oaWbL+PFqIDQZidVt6wauFd/MZEiYkuizKUwBlnCc6+LogaiaCUrRlH4qaChp3bXss4rY/KkRyUJ9JMmIc7EEYovvLG6QeKedxq0W3KgA2Gpf5wbGcjlyCKZto008curHe2cCr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb04e8b1d2f24c4c2c92f7b7529031fc35a16fed ]

We only had a couple of array[] declarations, and changing them to just
use 'MAX()' instead of 'max()' fixes the issue.

This will allow us to simplify our min/max macros enormously, since they
can now unconditionally use temporary variables to avoid using the
argument values multiple times.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 drivers/input/touchscreen/cyttsp4_core.c | 2 +-
 fs/btrfs/tree-checker.c                  | 2 +-
 lib/vsprintf.c                           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index 02a73d9a4def..c10140c9aafa 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -857,7 +857,7 @@ static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 35b94fe5e78e..cba6293d5574 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -587,7 +587,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b08b8ee1bbc0..90372391ce90 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1078,7 +1078,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-- 
2.47.3


