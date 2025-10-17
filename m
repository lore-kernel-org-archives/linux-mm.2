Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4828CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B7A8E0059; Fri, 17 Oct 2025 05:06:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECFE8E0016; Fri, 17 Oct 2025 05:06:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF5D68E0059; Fri, 17 Oct 2025 05:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D773B8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:06:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C5648842D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:06:29 +0000 (UTC)
X-FDA: 84007025298.21.55CCA9D
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48797A0009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:06:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GaMgLo9d;
	spf=pass (imf25.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760691987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LF9YnUdrpKxMSkc+LEc4zqlPhsgbROXsY4bZTz/lajY=;
	b=FxgpYF6Lnq+9azsUCcHgszJWxV4xPF0+KpkQ/GNlye7jDWVnnGhfhWJP3ofnMQej/93KLr
	Cfx/8oxmqSnDAC5crcjh0hPVcNqP4Jf9WBjXCJar1JAgpmPKLzLhNfHJ83otGeyj7k5dqz
	cJC6s6Kbqe4qMmy5CI/af0FpZiU9YGk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=GaMgLo9d;
	spf=pass (imf25.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760691987; a=rsa-sha256;
	cv=none;
	b=ofdDyUTCXNlWdfYlTWTs3LHovV3z1mrAkEFUkguIug+Izx4QI5hW4dMG7VvNSU57JHPoVi
	JAO1V40hStyOA7FXdn1dYDZXt1DAwGm52bZ5bdfiS6AqHEyI7yG6IziBDO7bsD+Cgqg1JE
	nJApr3ZYFhwirvS+cHg5x+KX9hwy6IM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760691987; x=1792227987;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=LF9YnUdrpKxMSkc+LEc4zqlPhsgbROXsY4bZTz/lajY=;
  b=GaMgLo9dfLYH/j3Zun7L1RjrT1/OkT31tp+/CcPtPXt0qbsE9aKNV1eq
   SxPQMdPTuz/PbqWDh3th5oQIapdnre9Bz9U9+AXbNRSDxPxceXxrzJGBJ
   JEwG4OKASlg1+9ryP4zudhuFYYnvN2gK1BB2q83XFyM2r4TH6bni8BBtx
   Ts+5xC1zk9q86bj1vzSgZC8ttwRMIps5VI2KtbtaL9uw7W1ZsmtVZJFXa
   0f9eFfjzQF9m/Z1C1X68MYRkcx8SVo8Up9DUGw6ksWpDaXqhvgGVOmjLM
   /NbCHpMSEmcyP6QEmRxrctxGma4eUIaYNNu8R78N3+zLr7KPhL8nGqlsB
   w==;
X-CSE-ConnectionGUID: 5Ag1YOJ9QUe3HoWK3ykUZw==
X-CSE-MsgGUID: SCV5PFljR42xA+XpgG/CcA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5072643"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:06:24 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:13608]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.42.150:2525] with esmtp (Farcaster)
 id c710c685-0588-4c81-b341-b34011b0873c; Fri, 17 Oct 2025 09:06:24 +0000 (UTC)
X-Farcaster-Flow-ID: c710c685-0588-4c81-b341-b34011b0873c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:06:23 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:06:09 +0000
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
Subject: [PATCH v2 03/27 5.10.y] minmax: sanity check constant bounds when clamping
Date: Fri, 17 Oct 2025 09:04:55 +0000
Message-ID: <20251017090519.46992-4-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: qb9yopn19woxbpztgr1oxx5u86k4eyoa
X-Rspamd-Queue-Id: 48797A0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760691987-785869
X-HE-Meta: U2FsdGVkX18HDGtttW3YiHi45MvpR8XucrrHU6qOV6MY0Muo9TZcCG4q8d9JHjjtmt63IkLSAVzsU35B1ukFrtksgbYMSfqczqAiq62KNuSMDCwfdwZZ5RPO7Evc2za/HZk+ViSCsJ3snuXSNSb5j3BJyebSVV2D+DDclDxFmWsRbOIEIlBUjx7lm6C7CdWDvWgWQzAxF41MpmBWmsqX/n71B8TCBP5ydybkjvNzYQRC00r7sdk28akDFTAkZByetRD3oU0t1AZkAqEyet6X9T2WtdSZhIGQjInjAirBUJm5J0/cjZ+RN+x6jukYDxDnu9IWjqtCmHLaN0tzmlhqGyQTExSIxb6ttpOTQdYzGq/6aKsX9Mn+McSEnzcag8uiozWcIVmpGnW89+3t94aBFi4WfGyJ8bKjnRdVU9SZmkpgvysPn4wXuVFSovyN7LQOb+un3jLKDjlHMjLIrmldep6hKnO3zMFNo6U7mXkVH2c8Qj3yGhk+Q0bISwZlTcdR7wuzGQcWDI2hQelSSSeeVnOohnLihfldW0+BrNaDS3S2t1GjD+UmRbRClscZ42SoANQybyEo0LZk8e/NAFGawZT9tRENjFS6kHDTO3QEysLNCs5Fjy2QVXb5qvOQ952NcBNN3Yk7p/UD4dL1FwN4HAzge8HQsYdpmdUAKjMUkjF0wJ50DCmLD+LI5dVAK93GMGbZ+3nPAIbUO1V7U635FlmoNKuqm4KRMx955fLAQHPEo5VnkAKnevXSSwVUQTKcwytcPVyMEO8iY145i1aoxZHIvCUgFsbuFbqcGcNcpB9rg4vsP40J0erscDlElNVBB+n3r5TKUhRfYOVSd6/L9nYw8lGyvAmD/trL+9Ns5qHQsrhReDXsD4fr8qXni3WYEsY2M+kQCO1LrOZV92TbxCvDpTEHWOELxg4NpnwIIF2g7RqYkilIugjE1LqteILEBprkDe61rWMCft1OOvU
 eof+i+UX
 9q6WiOiIWnD1gFlQNUwxRs8BLfz/XSIhfiZoIamfMXMWbKY0AwgNvsoYwLoa/HJwe5aiIahNoSiNRuJExDurVwOKhYDmm4m37Srwaz5MsUE33qhWWNw1lMicasrUtVKUlpJ9NxK36ADzXegY6j6nkLHGDDyE6C4Re7gvPktM3oAQQg3Hx9FpnBG1TeUP7e0B+FcesET6OaC++3Gz8XS8glftdWMsy6koAhY5o/Nm9Tztuzi2YY9IcdQ07dvJ+C7594VKv3/PjBMG3WXhjoyi8sfsFxnhdcy2KL5lGeYKTSGKLHkME878XtbUH7d3xNwjKp/5O/D7PzuGMybcJMSnqVKthiIFfJQ8D9Jk78Z1+MopEQ2QHjyTapSeZMQX2u+nAoUEMtAfoPjgKRlJ5g+ALWQRuUpVqsf+FjHTSqcGxSH/y2ke6dap9xNdRdM5SM0jCsuEcdz66VakvdS9niZS/W5UNpSYX5ZO7G/DuyoT2DhMHSgFm+QL4t4LelXxcVqueKMILDncsUPPPifh9Cggf+DwTkeRpKCDs5aE9PDdD4YOSW6cmdjK99A/8Gbl7XvqE47wce67930XC0vznIq8LIUFd/Lii5ZkO6PE5QhZkqVcjjDsZf8SodSXtkf/jLYkMYnItU/1MvcAVuab1oZCmoevH090FMnqGotVhG0tpzzpRuB5Ahh7Pt4BC2GKp0Nb4HTJi/4isrZUezKV9wQ2OQIbpQ/7VawTZzKaZOxT9iIEaodEZQeTxYd/EQIBCuYc+kTy4K69J7jzRJ/fdNuKrRypKcS44rmNJWgurElZk6J8Guaa5MKAqVds0Jo7CCGcZL3CdwgMbrVooGfAlOk4CJXYZKtOXgOiwL/2bjwjy08WCP4YIyJvX/qwX1F6V3qdrOc5xOWBT5AWEfucdI9nA6MpjH9xTVxRc7JFLV0W1ZVu7cog6xichl8R2RSf6V/n0PXZaEDdM2nUvGXrxECAiZx0XKfow
 BOzeCAw2
 eomwBO8+RVut9AjpE+XATg7Y0i9kGlGtDvpDbnEH5v9+cEYj6s55554ca2LJyKGXqVHTIXGKZ+nJkFIAspHp8GjCfW3QjC+aT5HSme1JsfRdoQ+KaQrAvPgEJcqACdmijZoljJcWwlRiXfPtTutz722zr2LntnyOFudhn8A/6txUCJUhBZxpPUc/ih1gnDjvh3ptJtjOMT85GKvEmvrfJCjk7qwwVnT9kHQjJrnN1cDqVO7NRokdZ5yVChie0V2ZPL3zJJPSd13+nb40dBJIAMBVJR7ZRe/fkqbGLnuNXvG+Fu1yyUGdaJMRiDKvcpw1OXw+3CZKhvLwVeg2D5pbN7xUK4hy+XM+exS9WogvhdXUQFZ8ZefxnYNB83vAp3nM4u2IL2oPxJRPFlnNQldQFAt+hz1FB0T7dPiVQ0UACQZ05ML2EyjwNCLRzXLmLP71YcBHbZ1COmJt7mAGIG7AqnQ2d0oeHNeIqs/IAU/g39lVD84niCwSwywXgYtzQi5vRt5P10LLV8r8+YEB9ypUUiUlstabxDqVqiPyYkTU+cxd9JSorvsRaLwsRqysPU4T4LhioT+rzc4AkbXKFVTrZCWoL1nDezkj5fPg9n4H7nV0QNjm/tImpjSAZJlFK+clLy7WjKP02jHJjhIHDDDPQbxgoaGjFHSIlInF6CyZq42kDcxtKlBQ2/9aBtaz2c8nqvpLIj52c1Dnsp+W/lIUx45uhUKEFh2RTZA2zxkejuJVNnGEig0N/lm/QsLYRdh+WEgm9mlunzVxkNulfxkcLLdGr4Dgqqyke5krXgo/doWAPgoT8LhSleV1f4N+TA2qC/MtKFd+G2vdz3maP1M7cuqOzht84mBJ3sjOnNQfm57Cc+wR0cBKpavJDoRCQXF2gqGollUDyrihB81vE/jWEX8TP9r2gBB8vBUSv9mpqisLPwVFGc9JTj01wlaMK774hQ20lQAGSo3kUYLHTnRUh8GSxMcwR
 Rq7TTflf
 UBnUKzs1yZ3otQlFS/rLmAh2nxCmhMxeN8JWQqOVdCPZtIb5asVHiqfydU3XT4thUFFIDhquaOCw/AS1gR2WOFaZpNPY+wrjVJYGh3S/s8AqLvz/QN5bku3IRoZ5No+gqf/GzHLgf9R8lNPcS94Hcgo4YFJ9d9Fn0DRP7Hpfexa9BRBN1xHRfqYeaX0d5fw/KXDDKT6AtlGas33vZcaYrEZLsbLxFLSPceNz6LrlhMumJS9PYEmPLQH2W6H3UD2ZPxgyopxAKgwyEglhv2v8YZ/D3ZWybiRgis0ed48nb2lW8janmKenIbpNSyF2xA9h9NeCxZ9pEB5nC8H0csoz/wTeB+FsAHiTrb3QtQmLY3qk5kRvseT3eVIMkWjoUV8tEZqhQAFzlfn7D51cw54ho0E2iOVdv2cmehXpYVp6t/YgyvyJrn7p+IPfiy1GAzQKoAJPRQxM67hg53DXlRWfBI3ONaPWTI0EaJH6+Ll+LQQ9aldR9bgOaiuRAzgJTdlhR7AjnYNoj4jv0nimmNKEqRt4QmHWtuzDC6HQi41ApRlleoL+4sy8+t1dD+6hygWgNbOZ2kcfiROzGhy/ftT1Z31zh1txN+C5NcbPToJg6COsoNruyCIUE26/pjYULuC9ZHdyJmNvN2CnH7D0Uh77aSAmDzuOYjLOtL3T5jxAyxox0GZSIdBXpbGbONwcw+mnGojHYZAAnp4BDi5knPqi8p/2OaglM22YBKtPpWLkCKi7Tx07e2fRILl2nMkpOG24ugFp6DC784WCGFFEwFyvyqeqre66/WKi+j2Y/z3rdUmLJRhbzJ+Fq8eeBqQr9L7sCc9FaYoiEAExF/q31mcRmme2YyOun0ZNyAL1K0PmdNbAdcMR1zRn1tmw6jj5WcmPu3G7zsG+//xn6uveI0EmPv/v5J4WH5E6/7le9l5htwvpPt7QJOY6NuzHXr77gVvzULDvxI98Wx7dOee/MuzIqUYH2Gn6t
 50oco2yN
 GWQJ11PBQOtzPO1Rac47ul5tq4dnpsIZnxMpMt98OUPhstpzb6niMA2TB2goYGIN8IxMColwqiOXb9ChsTiBtgyWdnAvYf0AoLZrOq4cYBevB/8xJe7QRo/0EHIWM7ejaWln5kDzdocSv8g9dfBS/daQoiHTKk5oFdGQdoJEs1Y1mSxgJ48JXNENuQsOetkeg22I1PaW9r9xkJqsb6EsWdyIs3nnm/8HCJnrNiN/JkCxvBR7OqzUKBbq5uD7zzfZn9OffPv3CVSYMofhPMObO1VqNCeak8ZQ5CtiYI01HwrhfSYjGT61Od3wvyqI4rtrwRkTsn8fFEkZs4pHM9pD9dvl91mn6o5WmGUgIXkY1CQ5QYlP+9B1ytZntZwfq1iTvSsT04TBb7pkwn2diiEuoVJEUXZUaAHLOhbc+1Jtsmg35EliyVGWm4Pihwl4WwpK89dfqaGo8r5kWfEIldcoM66KN28qYDqUz0s7OhT5e//0XO2kcQOVoO4pEnwzZMe+xFqvm3IpBa/llNX9hnHdXgXTdNsmwR2yJVqkkh1JUtgz2AcE6PX3+zkZQmqlHUbj2vUBeiz8NDs0gWDsQFB8w4VlwvLKf8zoazwnOkczKZUrkrVg4tzzXtJiC5NrOuIN6rQ+kQsxfp4xucABBMZoA3BdtE+DLnJcfI5EtlqW9/UmOHj9gm7w/24aJdM3QQfxpO/r3DWwspj0umO3Jl1m451oL9p21qq0eWANo11zJUeKyyNVg2yXJpjmay/kRA+DrrWuchgOWabcwnZiFT6C4DMqLQjdIzTLlhDnSVBsdbyt2zSK/xyPQUcB2nNNsss1CLsj32En1lf1Zx7HK2JOr2By0lgrsgs5RhpgZSssiJgea7kgFqz4LLibOWNFylZeniVNnhGad6VykDjX6+dfwdGLzTm1uNbiRFXDGcLg0UC1jaZEnhwyD2fdrGzzxBq5NVUL23haNIFBGMLQUa01KzEUStnU5
 0Hikj3K/
 joZkftrn8BbINMgHAjVXFgMynE+3vyThypHxnwPuOeJtvDg8lEd+X4UYoviNahFSbVLIpzhNIAi1j6X70jpp496Agk5+98UF8Q2oSbHojLgRDGmg2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit 5efcecd9a3b18078d3398b359a84c83f549e22cf ]

The clamp family of functions only makes sense if hi>=lo.  If hi and lo
are compile-time constants, then raise a build error.  Doing so has
already caught buggy code.  This also introduces the infrastructure to
improve the clamping function in subsequent commits.

[akpm@linux-foundation.org: coding-style cleanups]
[akpm@linux-foundation.org: s@&&\@&& \@]
Link: https://lkml.kernel.org/r/20220926133435.1333846-1-Jason@zx2c4.com
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 1aea34b8f19b..8b092c66c5aa 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -37,6 +37,28 @@
 		__cmp(x, y, op), \
 		__cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
 
+#define __clamp(val, lo, hi)	\
+	__cmp(__cmp(val, lo, >), hi, <)
+
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
+		typeof(val) unique_val = (val);				\
+		typeof(lo) unique_lo = (lo);				\
+		typeof(hi) unique_hi = (hi);				\
+		__clamp(unique_val, unique_lo, unique_hi); })
+
+#define __clamp_input_check(lo, hi)					\
+        (BUILD_BUG_ON_ZERO(__builtin_choose_expr(			\
+                __is_constexpr((lo) > (hi)), (lo) > (hi), false)))
+
+#define __careful_clamp(val, lo, hi) ({					\
+	__clamp_input_check(lo, hi) +					\
+	__builtin_choose_expr(__typecheck(val, lo) && __typecheck(val, hi) && \
+			      __typecheck(hi, lo) && __is_constexpr(val) && \
+			      __is_constexpr(lo) && __is_constexpr(hi),	\
+		__clamp(val, lo, hi),					\
+		__clamp_once(val, lo, hi, __UNIQUE_ID(__val),		\
+			     __UNIQUE_ID(__lo), __UNIQUE_ID(__hi))); })
+
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -103,7 +125,7 @@
  * This macro does strict typechecking of @lo/@hi to make sure they are of the
  * same type as @val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
+#define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
 /*
  * ..and if you can't take the strict
@@ -138,7 +160,7 @@
  * This macro does no typechecking and uses temporary variables of type
  * @type to make all the comparisons.
  */
-#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
-- 
2.47.3


