Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6024CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F788E0062; Fri, 19 Sep 2025 06:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107288E0008; Fri, 19 Sep 2025 06:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CE48E0062; Fri, 19 Sep 2025 06:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E102B8E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:18:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89FBBC05DE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:18:50 +0000 (UTC)
X-FDA: 83905601220.02.CD49ABE
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45406C0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:18:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UO01m2YI;
	spf=pass (imf10.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dClZpnB1PEMO1e9oEgVIbE6SUTXtf3TPYMR6goef6rc=;
	b=5vsglSHfZAFJn3+ztlH/Xj++q0larYCNBxkQl7qb71slO5go93dbhMOECe0lOsNV2KPQjj
	9yI3r1c5K0pGFJ3LxHL0KgWs6l/SJQleUI65P/3+1DEPv1Dxr+EonSZXcJBbgYtPrv7XG8
	lIu/qBEih0a98innhLhAiqqFWIWBNZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277128; a=rsa-sha256;
	cv=none;
	b=lvXsE9Jj5pJ6ngyM98UjIQkNjiKzks22gQzEREfI8MryNECQDizVYnFDnTWpo08I14Tv6m
	/WK6BgBSDFuEBzUdc3w2x+ip706W0abedj31eDnDI/hU/TLzONDpF8Dzlx0F/Rz+rILB/N
	EYb/eNhUKpKDb5UlspDd0GHNDHtq+mg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=UO01m2YI;
	spf=pass (imf10.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277128; x=1789813128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dClZpnB1PEMO1e9oEgVIbE6SUTXtf3TPYMR6goef6rc=;
  b=UO01m2YINBp0hiTBJFjPoDmzUHkfsWggcMHDvE8l85Jsu/Cw2LfEix/U
   9EM+GgxEhZbNQJv+zt0Ow4LWpvBNtcWjQu13JJmSsEKoG7kYXkCrdxtod
   Rabb7KBnwp9VRKKYDXt0H+hAdsCl4oYCbZK9frijdcf3/eTfoKhc8Poth
   UpSUzKT33PstorqB1DJOFB81SbT4R9CQ/qX885ZiuNmNj69ZQLhR1s0Uh
   mC+Fgqv40wyuHlurY31phNXbBbgVofiR2cOhNfHIuzM4G/DHEHFDt3qtv
   dVEckejSrHrp+oId9mybn8EeMEZSwEJN0vjE7os2pjasUBBckgcGPKxt1
   g==;
X-CSE-ConnectionGUID: 1U4uivwMQ+qfOicgIHY5uw==
X-CSE-MsgGUID: miXeaWb0R5qy139vgnHFaQ==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2368193"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:18:38 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:11040]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.64:2525] with esmtp (Farcaster)
 id 656dee14-f997-4a69-b551-7fa05fbc8427; Fri, 19 Sep 2025 10:18:37 +0000 (UTC)
X-Farcaster-Flow-ID: 656dee14-f997-4a69-b551-7fa05fbc8427
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:18:33 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:18:02 +0000
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
CC: <jonnyc@amazon.com>, Arnd Bergmann <arnd@arndb.de>, Dan Williams
	<dan.j.williams@intel.com>, Eric Dumazet <edumazet@google.com>, "Isabella
 Basso" <isabbasso@riseup.net>, Josh Poimboeuf <jpoimboe@kernel.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
	Sander Vanheule <sander@svanheule.net>, Vlastimil Babka <vbabka@suse.cz>,
	Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 01/27 5.10.y] overflow, tracing: Define the is_signed_type() macro once
Date: Fri, 19 Sep 2025 10:17:01 +0000
Message-ID: <20250919101727.16152-2-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC001.ant.amazon.com (10.13.139.202) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 45406C0002
X-Stat-Signature: y3g91nb1jmsa65dbmaj7hhxhamabxn17
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758277128-516728
X-HE-Meta: U2FsdGVkX1+FFzx8tlEikWS8roPMjaaVpovhqU0bb9AXgg06CwEKKy20hIMui+LGrZ8vuRM8QuxVolrmQ1oBMbBWrMbAn+zM7VOtxLuTcKbTi1XL8nUQjecgbHSVr0qQML+VkjarAmEulR6CA7/WB3poGX1Gpc4D+74i6dkbS6DjL1H9Vl1R2cuKmWSZjaEemiJQymtdFKUiPr19kZR0sFLCPcVqO4k4shG3XkjnN6uC6fF1A70Ht9KNvDJdcUP5zcT7B1EjP8MtKHcOjoJHaMZGKlejOgzeJxufAsVAxr/q275A67spHnrDPYrsAT18jkg1CouwyXohjbyozgUOTMHOhE5BMdOptJn/Q8XjjOXBQ2e3OGYoE1W1oZlKnTpT2QwD6B96jT5elxx+MdmmdMmyb9UuT5b7ZOpzhWMlVsI/2zpDUh/0jncYKc0rzezMvRAyJ2Wj+IKQszAoCa6VFKamQVYZz06UtaKk889xFqeIoOUFy3xnPwDKI/mKfOHAgzG8JBjcBMHyMVlYPp7/MNmQJCZActONBgBrG3p2rXquaIiZ3l3gGs10AXEKNFNPRgd+dZwSjOvf38jbz2KxZdiZ3nQ7KUhY7LsSCaxh8SQtvCu/69tiZ+7AoBppyqhkBc//7e9gnA/SiA8FpNWMKYzpUrGwh/I7lYXI3G4d42X+nmhWHn+S1GhvchoiqrIVO4O98BvGGLxloGPTliysQwDQ60fnWX3Fp6wTT8N9+X+rFrFKTr3dEmShcVAR/vpvabfeW0sDRWV6oxT1u5V2hrUsjK4m1o7Fe4fxlADoD6pwFLBrTQxY1JjmoblKQwpDqrpbQBEYThSgynFBxVD3AptPw/xoGQUz5rz/BklRbTlaAjnkc6j0o85aBhERhzAu0NPWtqkb+FaRrfmak5ZBwC+qxHj3b8cOEbiTgg2vEJPDg2mylSBVBqtYH3N8QTqM+ECXjdPuoEnptIt21MS
 /WxIVGMK
 cnepXLyXvmt9rQVTVkCdrKSurd7pYzvNyV6q4SEnjp/spSG04xDVqw7p2Vb0fxjMbWX18nbTuePQJt+b9TT5ZwBBz3K1Py22hoUH+UDeY1qok07bXjw9yzbDzfNKPiTw/nDTgob0LyMg1dRF8L7yPYKEUpFStZ4cC76y+hLXbbTXqHW6ZhBu72hb9cKY+6A4uFAWJ+SUwyKZo0MR59RkKlFYHQcoYSmdWp8vAERkueYQFRl8xy72AhP5dc23sh35E9rPnYyGtFdVHutBNR1IHiOtgItMeehMNmGV2kDzChL8YVOmMe+MESeycvl72u7BX0vGLwIL/xBN53pKf7dZrr2wes3sqxGxb8hXaLWa/l7gQkrwNzqyZRp/NM1u25XJMxgTH3shNCHq993LYXJhc1/zxTR4Y2tzkiK1Dg4Rnu8AzvkhiMiDf7NHYD7VjHXWw+wzmHSU3/CHE5EiLiPv1V17wVN4iacyjTmWxBrEEzFkEsj5nEuudYAEKVDCgaJI8pKEHB4hHiY2XLe0l0R2nhJFnYbTO6RlaZJU7CXklbD6RClUlmZ/N2BWpm7Jth+nH/RqIPGtrGs7IzbdcnVEqKuXIkH5hQzXeMVTv3Uz4Zq41eLtiZhJjDQwqCbNGzc9fftwaBFThK8TcvVP453ePBl4MM4x4N3WgKtayEz+M4B+Xty0erze+eYpnSsIcvl7dpvHRAb1S2QX4Irxv5zK6XcmrTGtYA8tEJAKDRjF4xeiOCk6SB+ge7zuGTwsmhVU/Wnfc19kIaiU7/OTgKR97K/k6HaW5oqYfZHWogE9ODxvnJ+LLjwhtbXNJH1jzzN/+bjqEe+b+FWOtCvBiWIcXBKs65E0//coN6ayIhWXh1hSIJ898MnkALwuHo8FMFbqiiOOWLhAMcxFIh0LMaNUu9FKhOGr9OV0JjgHCpn1s4YQ5MTdF6DjNthQToiXCxo3wdwB01vGYhTTv40Q9R1t8Ksw0n5KE
 7yFdo35i
 SBd3c73I8CxzDdc3whAAllK9TKUIBxt3dt/H8eP5ZsI4nzWtb5Pa2N5oQbc0gJIQLg6C2P2EGDW2H6eX7AXG64IsdRKDU6QEpvamyyMClGk5FXxO/iI1xHQ6uAOZs/8Q+0AIfVbelFBHI74pQbmwJl1vHOPXQbSF0QWmmQ5Gvr7YR2BDR5+pkX9FgQ8BJoeSsM37JdAzZoNj9r6soMODg12WwAjALCX74PjFKy3E+9PbLVysVuCYxDsI6QrYsthdIa3NOQ1OnfyblpSefMgpexBQ5n2iv630Hyw5HXUAuq7IgbXanJFnFKw0WgmcXbzOhP6pSTdGyjCFhSqF5LvsA16Y6OzjYTPhHjDm/IQpbJbXfJ54CUkCppr3Nj3fx28Sb1+jQM7v0YMfr1tIGqMuik9m29mDc50QHbO3SXncbhGVBbKG02SlVsDC00lhZ5RotTsBjapFIdrJ0S6llw3fF9Q5Fh7PpOtXuJ9OhBfo06b9/fpEthx5idsps3ilkrU1I0bKZKoOlAeTcxfftVUaIOPr+YUd7DsK/EMh3R0TCASK/THnQZ158hifreKEk/9dfNFB40akTuS/G3owIGDo2fu7ZldUEEXsrD8h1z+6Rd0bvaTC9r2lQquHz3BA5ZTuQ3MLAYttvu6/g9Zx/WhFbvzW665Ol1yCrjHLuj1tZTU+VeG1HnY8qmPGUzoCuiGzRTm0PXbvMlSXjaADFKHvpuEcJypXspEXmyOn8+DJiNeBJXS+PFO11fFDmBx3i+hEbdE+rrDO0C1r9Go/YWx9x/VDrn4vz309hlW3EKvsTvHKCSgrHSbnxHHKkZZVRZ11arzLGIrlRQ56+aj9dG5vZn4rNv6IvI2I0AcaYOcmWMNDNH9WRJkYRW1yZ0NAO00EYf7vW/4MXeRZGtW081dCeloXgqi69DVyffyLUXX3fX9cq/bCSepOjjQ7YDknDcdau9IJEvORG08yPYhQ9DmFvCMM847aj
 4KEWViRs
 q1d6WvgImRCIIPbrETPeCcISZysxJaKBEYC5o1P+veCDLEtwNAm2Kmgba9Cz2ukXsth/9cR66CaaIrkcNdMiC1+BDzg0ULabtb/WRO4943ojMbHcwhaPxzRxj+l5Kt4WvBFb5mg9ONWhP0OAXwzs2c2N0jf/WkM0VcksSm6b2S078ma4agDaTyv1KPrn5XkTQjUKPfAI4b5R7GekH/n9PNydE79YPZh89YFKNIf9J+mWK1imYdJum20CiYdnkb3TQ0ag1AuwPRuh1xGxXg4rPMbOi6omaPGB62UVEErYW07OGcA1NI+2lRxdVr3Ax0BRspOSHyW3mqud6Y+f0FhAw+dLTU4QR5oe8hR4AVZIZZqfYRwlJ0+h+i30YIxV2O4GAuFOt3XnCjT6jtuS51JOlpJkD0aWyR+GRgomMH791R83/Vk9xdzvs7XQp2u4jbcVuvLplm/wWRNkoKXywdsRRjv0wP0QbhQVB72zxp8pXp201Srn7qA5wBuc8QkGCz1Rx/nfOjNP45+dfema3KXDGq37fbOj25DrE+2Gfdl577g2Jg+lrP2OFspug0NTr/QyYoYU1CPy75whab9Jh3dNDXQJK3K/2mRTuebhBPXvS3WlAWlc8BtgOdxoODEZRaDQBk/rmHaM7WvTEC50K4v5/BoyA2KjM2tGIKx4aVY5U5KfGU05lQTkTgDqSYEo7CQ+HFiGuVHjxp+MP6EmFTC9SyO+hqPcdDlzGxAbTX3sdqksJ/n9iYp/PZxusU9Lr0O65kIKHjXeOK7CBalwuP8RXrBQzYFueDeqeZrg9KDyH8/UdJGLGmEkkLlPNYfCRmjntKFfaVyhcJ5G4m3TswjDhw9O93LJIXJZgmfaO/zS8BUoBkMseGjCndfQfRd088RFxACDPn30llpwJhmufWO9M/egb/grH0+IVzh2ZuRO+TjbZv1DNaLlhWQHm7pkpaGhug6Wg7LRIoBxytf5eiPdk9utOiqDb
 VQcnqX0D
 24dFXmQroLCgmtcpzG4X8Xr3Aaci73+o1aIyel8OlNCD5/KIf4FdGmLcavlAm+1hnkP7/XVm87XymxeSXjg61DUvwuHjIIXZkKF7Uz1QCgExxIKyKeY6B2cT46tW4pJJhxZxLa+kwdb0xXctxK7VISb9c1HWajzaXF5tM1GsfCnf8SXlJ6X2sydLFq6R+UXl60q8jPr/wy6GsvPkbgTdaFp7opTf1gRse2iGoHqh6ce1KV7eJq13PhikWUkH05Aem9YiiqrRSk9oV4QIq1OmQYFeP0GePALtSRMRPXvBloHyckz5hoS/6AyJeuaGoudTTbIR+4iizPu6DOy7fNDxrpeOMP221uiCif1+6+ZfVVnBB2iWvN9Kjt+qK935YGIYvvsyBPdKLlFN95yTQzckwcaLalhsmDr+2uBy3VYnXCgntxzpn1TjAqofKxKVTC2mPT6XHpi9uOsrT9FzCqdz3I2vzK0exYdpWm3PmByZKCQ5H7368lAaiU7eTkqG3PZPVm2rTxS0XpyB5Frf7TK3iSsYV8OogB86fRG566oPrFD2Md5bt2WLX3Q4VzI+ey9qHMs0rh/njFKj+uDFf0ZxDGSx1bcKkTf+lJsVCTSvSfYikpgnHdKqDt0MBFAgEr3OtA7BFJBpZ5QLHqgOqlCg6EKN7IZSBJHRvxzydfh3Ped9FNnkQntnevLsFigx2fomko8Ue5b3/9wgu6RoDLpA7XGRRzWsefIxnasEUAW4xTmE5EeuYFS+J19lLjOl3z+QTJxTfEcFwYTLQNvYTbXUgvw9qZ0Wj/E+HdGj8241tliH0hXVkGS9A6QPXZvjSwiXRN1KSwbUi+2Kwqn6sVnDhc5P5+tj3wKb7Tyq+Rxllg8VRzFpBqhYUlDtAFC+IYy673T0BCKlBFnH28dYU4zN0id7cEfJw3KM2RKaxpeSz7v1LTL+qDVv1aiMY/7BOlrJvoc2XnLgIJeQLWc8JOp1ZPLWHUYJb
 koI5R+Yh
 WU/dUpnxyoMOpqUxk2FKv/Nr+QRIFeOJzgvSCK3dI67cNaT7f1EFhzkyQEXn8ryYjzDRNRP++Tz57ncnpc2Zt8sPzElXahFHfdRY+QE/hbus4MvouaApAd4AlF7/Qd8+wfYrVLohUX10AYHOVftN7+vKOHkh0TEJwSz1IHu04UhECbC+nHM+7X20dFOg6THElc3r1kd/6iERc2TAZ2r+UiMLIyw0xxgWfdlGUPaEQVpfnTrdue4uIJnKm5+CQzAFZDE/y9gggwjycoO2JgaC349ttTAENUxLZzXw0WKevHD5kzyph9t+zWgEPZcFhKULs99YaCkMzFHe4uUvhGyHwiAfSvCHJmClL93UlNthDDwReVpmgrxms8wNrzdJWXOTUK9FzSsdxz5L9vn2fKELTSe/kb0ieKuSQGO3nEo+3vUltllZm6TQ5g5k3ssfHz3mm5WravXuHc5yrUAfbFyRxG7knWyarRMyNdz0uLzD+XDA/I7FUnu2EvqWtDh3dTy+Im6gHwwOyNVKc4pp8t5lwm+r5K/6szJPYaWh1o/k4OuZ0zcEXh0N8HU6DoY0acvbRYOkhWyXcfP4MXe0B2HoPZTR2TsFNkJCewLEqShGftfehutiQfyTXaM1/LRHnfXvW/3UoS4FK0l94j+idfSrNlY/Y9Oc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]

There are two definitions of the is_signed_type() macro: one in
<linux/overflow.h> and a second definition in <linux/trace_events.h>.

As suggested by Linus Torvalds, move the definition of the
is_signed_type() macro into the <linux/compiler.h> header file. Change
the definition of the is_signed_type() macro to make sure that it does
not trigger any sparse warnings with future versions of sparse for
bitwise types. See also:
https://lore.kernel.org/all/CAHk-=whjH6p+qzwUdx5SOVVHjS3WvzJQr6mDUwhEyTf6pJWzaQ@mail.gmail.com/
https://lore.kernel.org/all/CAHk-=wjQGnVfb4jehFR0XyZikdQvCZouE96xR_nnf5kqaM5qqQ@mail.gmail.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220826162116.1050972-3-bvanassche@acm.org
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/compiler.h     | 6 ++++++
 include/linux/overflow.h     | 1 -
 include/linux/trace_events.h | 2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index bbd74420fa21..004a030d5ad2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -245,6 +245,12 @@ static inline void *offset_to_ptr(const int *off)
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 
+/*
+ * Whether 'type' is a signed type or an unsigned type. Supports scalar types,
+ * bool and also pointer types.
+ */
+#define is_signed_type(type) (((type)(-1)) < (__force type)1)
+
 /*
  * This is needed in functions which generate the stack canary, see
  * arch/x86/kernel/smpboot.c::start_secondary() for an example.
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index 35af574d006f..66dd311ad8eb 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -32,7 +32,6 @@
  * https://mail-index.netbsd.org/tech-misc/2007/02/05/0000.html -
  * credit to Christian Biere.
  */
-#define is_signed_type(type)       (((type)(-1)) < (type)1)
 #define __type_half_max(type) ((type)1 << (8*sizeof(type) - 1 - is_signed_type(type)))
 #define type_max(T) ((T)((__type_half_max(T) - 1) + __type_half_max(T)))
 #define type_min(T) ((T)((T)-type_max(T)-(T)1))
diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 5af2acb9fb7d..0c8c3cf36f96 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -700,8 +700,6 @@ extern int trace_add_event_call(struct trace_event_call *call);
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < (type)1)
-
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
 int trace_array_set_clr_event(struct trace_array *tr, const char *system,
-- 
2.47.3


