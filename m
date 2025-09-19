Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD17CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619578E00E7; Fri, 19 Sep 2025 06:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9A08E006B; Fri, 19 Sep 2025 06:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491508E00E7; Fri, 19 Sep 2025 06:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3308A8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:22:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03C69B6B6A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:22:25 +0000 (UTC)
X-FDA: 83905610292.14.C6F89CA
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf20.hostedemail.com (Postfix) with ESMTP id CF2B41C0013
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:22:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OT19JXNY;
	spf=pass (imf20.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP5j8meArLlOtMy+CXHkrmjueNHJCB535+/rQW1z7Js=;
	b=waA3WtYGageqfTMjaWMW3WbK0uFzTtKuzl7zQpuDgUtTohlsDmeMTSTIwGXWpuRzHIwHSI
	VtzpZs6PUYNdOGs38pKwQmy/5UlojNdcy8vUkMOKtiLkgTfiHYhN8eUUr6iaRZ+ekburAN
	JtkUXDZnVx/BgsdjQgQWvdGiDpQZoCM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=OT19JXNY;
	spf=pass (imf20.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277344; a=rsa-sha256;
	cv=none;
	b=kUWH2bQMdoPR+QtrM7zZyE09Uiv4SG0S6LLCyqO0pBaLAJhqC+2luZeS/OUZhYGZY27OaY
	JforocbQaIB6jwyibFUjOdOrLYjbYB1H5z4E4BiCQvXbOdYhIre+9gr5D66kFo/muJJlX+
	FiXMztllvfZ7udLOb0Jk5hClAXXFHEU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277343; x=1789813343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fP5j8meArLlOtMy+CXHkrmjueNHJCB535+/rQW1z7Js=;
  b=OT19JXNYnvZYV5+zZ5Vr8l8BjHfll0WsrsnZ3/1dPLtbWCOJNwULf1LF
   Evdw+23mNmkqO4SmafLF99zqEczGoSTTFhM0yz7LZ67Khb7QEnifnKDdm
   bsveFUdiPXKZYMd823NsdE1z/jc5Epd7GFS1bdJ+4OVLhc2tRpr6cjdDn
   8TuclwwMZlpf0a49WIvo9QDsajN1uv4vo4CPjuqmDmziRFBXIqefctdJW
   n3L7mqFvDjbmElBNc7zd7B9PYoQb3hg/DHRjF7KunOaPWKZup+t5sTBOw
   nLTxEqDkWzo2XiVf5oS7cly6czUp89C4tfmS4JQqhcRZfel3BDIhJalUP
   g==;
X-CSE-ConnectionGUID: fywnw4uhQ3qXDmc/pxhOZw==
X-CSE-MsgGUID: 3rPOHmyGSb2jdBsFpJRyZA==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2255987"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:22:13 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:25060]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.64:2525] with esmtp (Farcaster)
 id 15c6af21-346e-4d76-8153-2696f1ba5d14; Fri, 19 Sep 2025 10:22:13 +0000 (UTC)
X-Farcaster-Flow-ID: 15c6af21-346e-4d76-8153-2696f1ba5d14
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:22:10 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:21:42 +0000
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
Subject: [PATCH 07/27 5.10.y] minmax: fix header inclusions
Date: Fri, 19 Sep 2025 10:17:07 +0000
Message-ID: <20250919101727.16152-8-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CF2B41C0013
X-Stat-Signature: z9cz5zdrs48ntqw9y74n818i9szfkbfi
X-HE-Tag: 1758277343-428684
X-HE-Meta: U2FsdGVkX192yw0YR//sUmxiwsBUqUNSZ7Jo56fRHRXgxHDhRMC/cpZPuJKRkK8mga4PudKRi7ZLZpziY7fHyq0kqmjPe6TuW1RrZZIGKfYW6ePbNOgEcUtTCRVKaiiwi8N7FcAnZguhBXawp6L9CvpVwaV4GtU3BNk8xqM6O6fpcVmNq21BDkv1dE3RqdbJx454h1ixZVlvfESUKde8WZo6dnA64YYZu+3LJY7Gk26TADO09AoAU/xOeNulP+ginGyFcLB5v285ZVmBzmBm+cluaNR/KCSJL2U3CuXmxKemn55AHPqmqDiHhEAQervPc8/N39q5CSwzU3sObxTSAAxOSdoySwaitJjufth0cjMg09ii2JUF36Li2C+laGUm6/cOGWzwtXoURG5zuDm/+W3jEQLiDcZRcOC6E+E89+A/c1PPFt8a5osrhT1LkCZTiT7l6Eesgp4Su53Y5iscppnPppkWVwZl3aryeRToPquh3TWVcOZkvlu9htJtQcrE96kyKWvrLlltpAK5PRlKJotYOO9vaBHoIPLlpFX/PD/pkLPvDD+oWaCJ8fRiPSeKhuHpE5pyXPj4MAHeRmKuMzAc4qOZL9AoLFEqbFYlFAM8euCy7p+qSHHRxCRpboWVqjVsSucdH1dbjYnrcQ7W/62VPyqKMnHEpMNpn99h9YKr8li6I6KmgOsUNxxk4XKLAK0vLBEnIwoKjD+ocCk+bx2Zs6hkv7qISxmth6roi5zyjDzm8PvBYQB2ctnXM+ineZOi5J5kXe+zrwJPIZevAVt7Vlodz7+uUupDGdjEbS7RFiJMHQeKTCiFiAE/kj2RKBw7h5NEgaAgzs9rTRG7qS/h+rFwI7YG3w57OEi5uwtdZ17oKwanHBRlN+g6eL+Q138pS7rRgGCFS7ST2iCeF2zUcpXhoC1zBAPIlB/sTYNytEIxctA8Swcl+0+oD70gpJLWm6qy5U7KE8qUj1x
 Q/U04LaA
 FgLECJnqM3rZz0vw6g+1qz/PhjCsjucFq6v1tMXBCxbu4a5xULmMumV7jm6eQUcMd0B7lLASYGvcWSAlId14FgPzilEfb663Gtjb37Zfi31FtQhXsehN63YD/AreA2skEmCtQ8NDAZaPVtc0Mdz7X5sBK0ryqMWJAASw1yoS8u9m5lkAgET6+KX4qyS2sKPhOoFHayXVhSKXSRu6nE4M8+iKj8bicjwMX8CFBewcyW/wOzxcbJ3Jhp5sKerZYpCHKEF351LKpZU5Napg0tLuky7b8gUusqPYaPjscJy/cgeY9qVkkEqRICYqzg9BscaWYmrx4/lrxo3q4gvd5NLiUJDQx/BrJxaeQLmSrfrGZ4OQeiWnOkf0ng+PCCB9i3kFoxGMNKc0Rs+Cn679E0k0Xpkn319MEVsOp1mZJtNn/59MtocL7sbk4wtpVTx5CSBJU06Aa0IXoSNaZjo+BbnMX1YT3M3An/M9GBitCwXg0wyGTK9n1QLMHbc9FFszdkyt9mdX3gYnlCY4RbFhQqacuWjgrmuf9+sK9i74iqDiRx2ws3j9u3k3F1EkczmZf8Z/CWyaz7jzNUWJw+/jO+YV7BgSWZ2YY5NUDyzWTDOV2VQSdFlMEMeqHgTBu7ttgkqDmFUVzKhLoTMuWIgInK5/3s4OkMDmR97nUAiTgLIx0MQP5mYVEFv9k4CtzN3d+y8xWz2/zKz9CYQLw8/TJ2xjd+gFVj4VLv6WSbEsE4fUnwFHmixgO+FxFlSxPzpAKhkdm309JanzSWR6Ndo/jiHMgIWPx8jAYk+ruFZCPWhg3bcXI2bbie8VkIs7qQRZEWhIcmMJsj6XbjQJRbw+M0zT8cnQldjONLOsxsAEWprSLsd6ih3SwWqQVYjejB3RxkB7qa93wgCUZmZYWSInw3sNCagPIfXoGzjS9RxE7V394Z2v22fJRGmddSbFQ5YOu3ZYKTSJOcCMqAeAIQ2/l7TbJ/ilbdnZ2
 5aNIeGjR
 PnBYi2FE8ATE66kNJuh46QSVEl+u+J1hhEgz8VSQ9HMyvCNIObXgW6rAydPP9PmGzY+1g1EdoaYZXZmVaFZAyGFZ4JSwkMdRJRuIO9DM76Eh1mGwzxZG3dQYA0UCaHQBc8dYX1mcuCMUd2PW+MSHNI5wmEsp4EfMKloujfS/RTbWXZq17NUpiPHk5AFWFyGYMG8UyFtmVeZOI5SdCipS6VzsNoKnkrBXaWoc+4Sc8uGMomBJj8pY5CK+llT+NiAFoidVdZahMUzgPWEtbu+LQnFVTYhL2SWmE3CokGMu/uKrJB7/NBHEcO5rVflJZC2kiPKeowY0nqlUYhsbjhL6wshTbCBHnfNowum5qSYk9746oaPPQxBJ7VelB/CiKCBj3uY99QSuLiWV0hgmAyLIMdfEe6iuYFarKxhAyB9NxNbK08LnbfXckr5Wef8YGVwanqyeDmtWQ9oSGkSTCAheMSWZ6FhsDZsaxth0G2BmD4LqBHCiccSsan3+XowsD7cQyz6GiPMyguPMi/oMGZ/WdiR2w7e+N9ItsSMBfI4+W75gF9slLSPf1eMlVr4LtOHcT+/XZanLyvyWQLBCGEpyV1VpAUTIBkTPy8Tzmoh1ut1W6to+6yePImyg1td3wTx5bva3SIxWDuNKKjsK2N78x4diWFCz8z/sxnfUs8k2/6bIu4AT5wV8zYeNui1Z87WzVK5nzJqKax7V3qClkkC9VnLkimWpPyHS2Lnd0SzsKrgmgn8HIQOoCascNGByJFIs0fKtiiuUgUGDM0pritATC+ZYoNm1AJmsb/kApu3vwgEKyUKzlonLQtzGVOaFnRbAs8Ks62Ao6/d8SO0HFHwkk+P9nwt5YO4F8crIQRl/UNLDmBecPtVMS7uhcWBzdK8dlAwcQEcGBYHdEyt8L/VgC1xeOweP31Qb4TrAud55cYYKwvIq/IeWyyVN9zurLLZFlrThAhj23+WwwOb+wDZUS4XjVk0gJ
 q/d/i9My
 TyTtsb3FCZsd3sUOjZNGVwNEOB/y8bSjFK7J7gZVZlFZmh1rb6N337GrmJA46DIDzgD9QtMiDvgvAFLYpukzhM6MsCBkht0B3uUjQ4MyL0UGRQEh1ViHKwZchdzDyicESjEi/TpwC/K8eWiiS83LcbPd8abNS5ylejziHbUUrs+ZhPv4IMzJTdiYX9nWWDTymjf8rF7hHTmyPsNCozGXEj8GGNv2nwPEpesAJA/5qTwOwRniwiqooSU/XlIkBQHkCfodmmgIxNwMTpWrhSUVqBWhPw3uGUDvfTwqsOxI7hMOgcUuiWpNyGettTj3WCNMkOJlb104MsVTMSkqcSuQXxj81ghecO3HdM/XZjiuxgudbmDPMAwguodFF5e37zzHJm2LcpYjxGspabOti9HzFxElY/nqBoVCHctzuYVdSIZqnSvYhgdvWgdwAIM8kAzMACGfK65IzV5GETZq+3C++11ca0m1Ha1yBF88bhyVHO9DqgHzxou1OmPhQCsw1lmgGT9tfClj2q8qGIBuNNNCCRF9aj8g0PiW6nSzoFDJH/zymyaUP7hwdl0eyomGmCIyRL0Yl8122J/0mISqW39doAfY6lfdJJeTl6knwUfEiEbmJEMjgRIx9LCekZdaKr7OkirW/FoSPXxMNEgOoV8UiedcBWQQMY8u/54hWHSujWsjc3+PWd3RFrblPSgfVLMvFkyhED16h0YJNBF7UKXNF/doAHGzyuvSMwpJjtwF3HmhpjJTNp/UfpDpkEFbQf+5xUndmYSknTrV0uybr/a3rzHkKyP8VURPQda8b0gpStziGkzeD5Gh2L3IDfck9ijyIZ7GfnFjoxJDTdaZfGxtuW31n7qsNjRDBj/2ndgOYPnszg7H5Hyi4VN7tv77bkZgT//XcwwhZRlC1Sa45B2EnF7N1e9i/20FS/8DQIUCzpRSW9wL5u/Os+ycXwKmg0/1nMJ22J963x4JFsAsPhM2Z88oWXTRH
 h3zFxm91
 /Hp/fu4pzOQDwnHSD3IrxhIYNkCEV7Hblgo+77K/roKA4tT++c59Dviq7+Ob2KHLxGAVS0GVh4EOmaE1ZhYuwpX0kFdcY44dYNJEqRmr/p9oViil5mm2wgdXGbJGsvyzv0CQihqTrEJSnLIYmVbi9rma+B3bYfo+XWg2gKKugKwrajwaFZttbdNY6yydYbq1t9OFc2TsgkUfAE/6AJ9i1mnF1vTZnwhnpfz67aZ+g6oVlcmW2jeFCuQ87Kf33SOu7yCBr6sn4nvZDiZGsjsA6GimbjPowvwAQhnf/ZDnLH8lQdte+3AtfXfGBWUen5yJZaxeWE5CmEyo9ss/a0M4IK0qlJwbSaTQ/P2ht112H7u6cUgU5nO1WbeKlKYeQIw+0i9eZrV5ad/hx9mC/mkjbNHjnnIQ0eAFWn3njm/7J7svefiosiucMnQwYAsikm+riixOAspWzv8VRNKaFC233fYjvW9e3K/LQKsDDNiHpLZmRFyW5qot1Mc3wb9TmUZBMQn83cyukJ+TONqLKfyuKisuwk53BBXuFPRKiIqKEihWvUhi64qLfcAJhSFnPaCsHWVplu+tkvoz97CLarVCJdv2QZUzi30VMAapYQs87k2yJNOdIe0ImAEs/l8GXPeAyd0k9xcK42/zqElVQMD1PlWA+3njCP0GR6EhMBUs0AjjMyBpcUPpnmye1MOmpl4nVLkN0qEbVyJbPUeZjO//jq7Lfw1XrCfxrshYB466vHoYTgcVkIscZtoqpvg/rk4czz2rGeQAaCw7CYpai1G0Yf8xA+NHs1ndJpez4VjMMS/l5Sb9lxM7hzqHNKiYIVmMayGxsSDWTH0SrASNe9x9CjNDx9v97dpzOn5z38QCOQ1JHI+9nVvFYV88Iha6bZMXjp58M9SVncUhQLb9QBtoYQG4krWgEL/RLycfsYVKwkVCtkKO7V+6U1R2AGov1b9y1I1Ymxz4vJhOJ6ozbFWE3EjJ9/Uuk
 3jpbIsxZ
 bOerfg/dOgff7jKRoFCjSp43ciq+X9EkPJ2toOmEuVYokNmPvmY0jnPSUu0wejOQKc24S/mVoaFp28x0aP3/Y3aNPYqGnHOFwDteHOWEJX1oNODl1ASVclW037Uq7pcUSWKSK8/6FAXIvvgJnLTtzatgkPEAxAO7FRLvfGvwLEKVkOnod
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f6e9d38f8eb00ac8b52e6d15f6aa9bcecacb081b ]

BUILD_BUG_ON*() macros are defined in build_bug.h.  Include it.  Replace
compiler_types.h by compiler.h, which provides the former, to have a
definition of the __UNIQUE_ID().

Link: https://lkml.kernel.org/r/20230912092355.79280-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index c813c1187510..2a197f54fe05 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -2,7 +2,8 @@
 #ifndef _LINUX_MINMAX_H
 #define _LINUX_MINMAX_H
 
-#include <linux/compiler_types.h>
+#include <linux/build_bug.h>
+#include <linux/compiler.h>
 #include <linux/const.h>
 #include <linux/types.h>
 
-- 
2.47.3


