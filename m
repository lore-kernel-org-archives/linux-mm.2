Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA55CCD1A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CF78E0064; Fri, 17 Oct 2025 05:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6DE8E0016; Fri, 17 Oct 2025 05:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49EC28E0064; Fri, 17 Oct 2025 05:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 328DA8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:09:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0391F477A9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:58 +0000 (UTC)
X-FDA: 84007034118.22.71167E1
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4F7DC18000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AQeMSXZZ;
	spf=pass (imf06.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Up26bfkjgG7bBpXTUDNOne3Gaz9xL27H6G5Ic5zP1jo=;
	b=j14Bgmkvwxh24/xJIpS7jqjiLfDMNghq6BOvl07LfiO+6gn2BA2upZMQG39/TIAepK6OtY
	8xSUXilmHUcB+L+oV7semXfhOAqMYxAXyrmoLFOD4JtGIad/gUD8+Nqev0qOLEjvh34OeE
	eqPqXyfM3LBNd4FZ+EnakwSr5TcTUyY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=AQeMSXZZ;
	spf=pass (imf06.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692196; a=rsa-sha256;
	cv=none;
	b=HcCbJuL7+zWL/COq40nk5A5POJryPc258SJRssyIvdt0Ux6Oq5/h12PuC6mL0iM7qAri1t
	4RF6Zf0pCtsPr2n5Pku+/etoaro2hk9781MHrWQAVVLXkcoBQGPp9Vlbtf4VvKni0gvtQU
	UqAJ6Z0V6XOnsvvIQMtTghrj01LqRsU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692196; x=1792228196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Up26bfkjgG7bBpXTUDNOne3Gaz9xL27H6G5Ic5zP1jo=;
  b=AQeMSXZZ0EPjhZZ1ERVx3G3JZ4aA1KhNBGt+ih+s39VZyUljlCJlT47o
   VzhpsDXo8G8bpyZKrpRxLZXXlveYWKnOJBNpvgt4ZNhbAEd1kYkTkXyDk
   WQ0zxax0IIdyPwpQJ0ahgd1ML8+K//fMd+oBbhaIwWJCd/RKaz89Iz4+P
   63cp1B+BRnwytoUH5vsk3ekaLdC8SywBc4bqIS1A4pKfcWEA6L9gHwj/V
   9TYlwsSo45UwCtHOc9lLQxZZKgpppU3A5TroEvk6nTB5vCYEalT8os3fV
   7XT0t6s+ce549Y9lIxEg6gk3fwq+k/jNwVE5JPgaHSAGhFyYPxnIQIrAx
   A==;
X-CSE-ConnectionGUID: pM8WHE1nRvKgwn/rOnJAWg==
X-CSE-MsgGUID: YGz+lVfQQYmjOS9lVJ+cjQ==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="4861413"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:09:55 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:2949]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.191:2525] with esmtp (Farcaster)
 id c5c8bfd9-8a04-4ce3-815c-bb9754b4108b; Fri, 17 Oct 2025 09:09:54 +0000 (UTC)
X-Farcaster-Flow-ID: c5c8bfd9-8a04-4ce3-815c-bb9754b4108b
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:09:35 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:09:20 +0000
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
Subject: [PATCH v2 12/27 5.10.y] minmax: relax check to allow comparison between unsigned arguments and signed constants
Date: Fri, 17 Oct 2025 09:05:04 +0000
Message-ID: <20251017090519.46992-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F7DC18000C
X-Stat-Signature: 9hiuf7aju9a4j6pkdcrq3yngjygzhpkx
X-Rspam-User: 
X-HE-Tag: 1760692196-160523
X-HE-Meta: U2FsdGVkX1/RuZ1HW2cG5yo3D6ZSrNcpL95xR1dKlfZsTxg/NrHCY65ZfD33Hdru0QaPHFr8RzhGvoLdL93cNU4hpi5TQXtJuldziUVxNSMixx101W3mBIPIJ/dqqeFuyik5cRD99fXyJR0KHkqT5O2lLv7Nas/cnOHZQf26g0Xh5gXLEhqi93O7sF7sCqw01AAxT2pIeP4P3IE5bRa22bhfuwdGi+TNf9g1QIF41ztOdGd5MBC5Ocb33mGUUS/ooIM7SYWspeGpkwUvk5sSf83ZaQNKnHC85uTQdoG2xfkhQRy2uMkb7bCNB6rmi1SNDOM9SHoduk8hAorOyudDpSH45kHsBjQ2AJUT0/xIbUKz2CpncOgBjsi5Vl0l8Gm7JHCgAbF8zt7LvW6Ba8wsevamBbco32sW8BJ89oIh+HuZVZ/E/KBZZH8FosqbSW4rqzHOcW7spAPU/ve//OEedC7ibSKG3W0SOvNCVSVqCr9HIpLgHr3aQvUs7EzgeT0QnHhuKTymcOLqLxzLrwGi5/bUsf3dgsUwJCSYAahoQ/SeSyKngj1kPLTfbGr/8e3kEkkOPe/hirPNIdP2iLIW9LcznZBri9SMMrQnXCLnKJvSyBQ5t2+sj5zr6IdQ98soCo5hbzXZ+da/7HGwrypn3MaKi+m1so4Nv/+ilWf16kAYVuE0hYDsGpPHHT/4LkkVh0+dk9YGgs2tZS4ys2SS2/5rx4/z35OewaGPqtvW04PsmVB627cxot+VEKZXppNG/G+myPlUFiogT7ORtFBMxbeaVTcNWQattWeeL+q64Al0gslF8VgR1aNRDsU3Yrx8AuhvZEUrnUaQFoBhnrDx3aY/s58W44IHdZKX9jBjfv7Mo7z/gWeWZX+0CIrXRhS+ji3hSLoHNP93XIgV05Ddn6x7M3GK0zCTjsNhIwnwE16Q4dYKDYyfQL5AtNo2WYJ8X0jsbo1iUeBH7Ng9/nc
 lG5QiX2s
 VLPpkFJzErQJoFl44XKrar0weso0oW3BZ8q7r2X0hmzgELTfHCUE81EXWlsNy7910I2MRWzP8AepSjX57BR3Kk6WzmY/qiqqOFdiJN1RQmQVKiC0KwzF84qL7S7mRo5Uy+3LNZ/cm+bftDT08C/wZiCejlCH7E0OvLgafNYbBl1B7WZnMgqeCld5AKfdaJ+KDh9Mmvst0R37LD+P/1PSD+ZjtaDbPs7lpKrA9IYW3wCB+dXRigWVf+HWU9vARVOirn2i8AzfR7GO5gcAY4+ZqC0F9w0uMpATh2rQ9x7AxKlvMrBBMRAnPzdAjlK4Cu0ouxqY4qCWKYWBpU9hjeCmEsF2gBgFryqbVxpG/kueiKkefYtC8JwSozIeGU9g0opaxhBPJqjBz1rifmQl3No2Ox4FfashsbrilSB9W+SgY+1Y7yV6ki57WxHYsHkYCGiWc4aEJ8oimB79HNfOsGgF9LbKL07Lu56Anrr/3Z5zQ9E1xmV+e3HnZVZqhWkrb6PFcf3CZCgf6b7ALVbAFDYmJ0hRHdjwtf02pgokGkfBABhYMFLs4zoDYLNfthx1Nxy3Q+boI3rMPmuyYEq38HZJtO1M/lWRJtvvi24KeQo3VJmCIr2U6b/yj/+Sbaa2RLHePjI+ZFharaT7Ce6uzKlyv0ZlleDIFnrWYntbHhW5Yzu8aTxpkTpqRVfGkmloapdqXx7mP5K7WkJXwVrdr5/ehdggnMqWCY6mJ8Er2yNKPGznIF+tAjemwNgvWCObN9v6wn9EiHBWSCfzYhuhD9XH4c8Q4Dzpo1mOL2ijclVcArIcNNIO7U+GTvOnioI8IOJe/DC0K2h2YQ7svopLV3+CvzIJsCmIWTJilm4el00VTStjhMx7VB/0MzJy2DIQncI8aDa2i4HRRZU25zcgEdLRbOyKoTmCTL+K2HtaPkfd4Jk1NC1NmJ0w7BS/mkwwfiLKX7woKzyEE6oTpiLRacUFI4+xKrPrF
 FAWEH8L8
 KezXqOdEh91W+AeXuCGmr3DI3emwTru1VFHLfCfW4/xKOUv5/oqfhBwcu+MyNhyvH/XmXyld/IVS7Pop9ZHLlkdt0gWZaEoyF2FfzOUj7ViThbOQPrxVqajTvdbmte8usvh42g4AsYvDqZ5FxejTYmdbLUOoffBmp57YeWBb59lvlxcp9cWXGYDh1Eo7FULApRoeyf7KoDHXzNkGD8cOTYoSgKdYIjoZnwxwHjpjNusgjYNWSsEg+wC1zU8l7ngBpqdpBRd8431YmsHVZE21Na3M9gxd/862RR5m6oakRmuT8AIyowDrj46dGCRgdEb30PY0aPZet87NL/LsTaMNdvafy5tl1ahs9QDouQ3udLJa/rgpvmDyBRLSS7oUDLx461Qp56v+0xO1c0ZnYXxuu6u5WQQg+9dLYRHzIbV2i0IOa4+rGlsQYxgchgioRvAgbofYhl2t2tAh3O225JcMb7k+1CsqtgHLF73fQNlAPYCXd9lRSX703dgSk+cs9HdvLF+aI9AkEmkP4KOeDcH8O/6AhzzdyLTjYyKMX7gRHzNK25hPX6ZkicuxFL3AUWBDvVR3GbgcWTrB0d861uD3XovIL1eNwhc2nOVqDNE5HRkkDcp2sawvAF4R5ra4zO8pb0c20OSQiPUhaQ05uakGO9hQM/c8NKodRme0BVm33wekT/Y86bthHm9xcEpfO+c09FMIDqUedXBcHstjbwEo/u5z1Zjcu6L1lRG5JZBIm1zirX6q+darX3L+ZfZqLa4bGcUV7HA60ARik90u5diG5SveqVaWvl0DLSG1zZ7Gfg1oDk4OqZE4Ym/5aKKzs5CH9PB3PJoeuuxqoCWfnc03AqIG013rA/c/mHuIZYUVoojGG6c+5neiGGdQb1kJLSt9sgcujFjyGR9cdYYELO+Hf0X6YbtiNugIHhfzpK1kOtjv/QQjBN3HR2q4jBioVAfhTHtAG9COaMVNSKld6njqVgDjIHB8o
 atYocbYf
 9SBzm4/y5O/tWxSMDlZZxyH7npbCqUD+/8EhrpnarG5Z7EHgp041Q2WotbEou1EnRQQ4PmXD/LXKZ4pQPeW7MW3e4m7TD1tRU0FrNfO589s/jTJ1HfuVUED69k1P0Dcqx2LLCxGFsL2SIC1krBpbvJQ6wtOiLGhq2bJA793lMz3hWDRyqwumEhGlYuqEyEExF/szJuLkeQva6PFQRMGPGUc1g9cdOjp/3OKN6JVDbWeDIsrH9S9d0dLmRUMgRVrY+Z9iuxcCwLsd/V98p92dWivzqSXsTh5F7uQUC1nDXWiXHuDNxK6yNEUzYqY98/DQ3u8Fy2UsppP8ZVl3EsJkHK6+iObEx3DCpW5e5uR02g6FAY0hS7Wqyus64H2kZXuXyS4dJgwkVTSPZlM1koKfjQOstXwzQ128cazd3q3+PvvOcHHsIGvfUPDZfrhqcQCQY5mi7rcVaSzrQEv1D4y4z/G9Qvu9asrYBER77Hth5ohRJTW1TUSXl41Q9qWD3zFwf7hE27MDt02aBmjRloW9hLkQG3zKf62rlz4hkQdfaNKwGHHFUBXGRahOOBpPazvCYqAptTAUwYIbXLMEY29Gpi/FWAdscHASKQ+//LGvhTDccjr/hs5ue3IfiufYeuCMr2UlfbXlAq6Do9KLja7RGkbPKFFBw8YeLpRJnMQIB/EGdCmIMdU/o10+hiGPVYP9GsnKTBe/K8Xew36tydiES9JOQJdKSlaPdG/W+CvcBkxgy7PArD+GLzAlRSZa/DwEXRrJu8i9QjsH6RaYDEHfIh2mCAN9XfJSWVra2RbYfP4FWCofwMLDzNmWILiaH9Vr/7OdpElgMGPIh1QnY0l0N5IcxUqi4YGBL10khhzZZ+j4AW/7p9PLjs/I+8C+G4BL72vldCKaX7727Ii2FJB5UpBDUAUilwmbgpDmC0+tiyoiOJyru+ewpXmzPw/BS0fbFCTL4qvUZ0mufkDwzn+llv4lR02IL
 WLY6L4Rj
 vGRRejr5n2ElFjX7D9KzoZiJCv4E+EeQhvx915BdDbOWXHR7gI733euwQNSJ/t3fxhupoqLfwUvA0QYDTlZoIGnwJQAUdRXFwgIpcX6Jn/V5hSXHRcgFGUGJeMAvr0o7U/zpzfjcUyRBsiXNutzDNfKrV9df0/39sdwongurN39Qun/mzaVPRV/DHZUJojSxK3hLkar5OlggQHWvw+LR7aSKDO2JXKYHcL09OJbb1GbjZStMwY26M0RkuVTzfWFcsbhfi6g1LF93zSpg5mlChOgvfGYpfSOM6YRFaBXMsjimB2swKMLFUK8G2+w2tQtEhuAxnhbtGT5/KJUTk9kuAjOlrem7A2TCRsH6FGq1LOrcrCOBQyFl7lXBrPrUMDaDuxTyYujNE6mgbafOW2ATpfpJkXN034KZyt3wuyKy8vvbpIvlirvfYBZ+IuY60IEMYgtF844XbpOBj0fmbZiJVcuiUprGoB4Wt7lJ9xxWE/Mh8A2A6slEz3jKj95FhEWCqqcd1dMU4bL4Q6exHjV4NgOnFdD/oJrP5sIdnBxjNrQs3lM1nSNawuFYPMbSv+e/JlJpZpXM3dTKZa5xWlTGoZdGtv0ZkQcuqG1AZx0ypW5DhrTZk+fHcFJeOZ8rgkRYK2Hkyk6aAnE++Cp9kWlQ15c44U6nCeCeQZ64YJLpwXXRIwc8YpvNJghlow29BXHz+QeRPV9U77eLT6V3w/TkjNzLBq9Q0ppkWbRxECUA06+Rq4kB/qy9+GMclfJb5kW3JA033iDTjXr29Fwuc2fapQTqz6wU8KhUdIBBXl5n9TAF8fwDSdTnu2hA+vwpS2m304dJ6wyFKrJ4H0bcUO/dZa+5EuzAu6FlwsEneI/7FNW8c8oOKuSZSF7zpzWp3jmUd1kCFieWzyH2Dm6WBi1tA7URnZpdCwuLCCMriuoHIR1vYzGYaZKOKs8m3hB+2excsYUlC3cczJzQk9TI9QV9aKdOTmhvP
 YeGM18el
 F+Eq0HJkhm9JaSdBLLM19uacJJyzCG+G8nBLR9BkdhFAuPzNfwVpnZoGDTsw6eiJw/2v5sc+2OQGX64U5u/uwxVIBdW6QmZKuVMhcSXu0OapVykUQuR3VAcrBWgrX0grQM5wV0F82To/HcWADa+89VDerhKg9yJy+7K2FCofzghD7/r/pauiKi9iab9vb2oLH1DRDs1mEoDaZu88O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 867046cc7027703f60a46339ffde91a1970f2901 ]

Allow (for example) min(unsigned_var, 20).

The opposite min(signed_var, 20u) is still errored.

Since a comparison between signed and unsigned never makes the unsigned
value negative it is only necessary to adjust the __types_ok() test.

Link: https://lkml.kernel.org/r/633b64e2f39e46bb8234809c5595b8c7@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 842c1db62ffe..2ec559284a9f 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -10,13 +10,18 @@
 /*
  * min()/max()/clamp() macros must accomplish three things:
  *
- * - avoid multiple evaluations of the arguments (so side-effects like
+ * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - perform signed v unsigned type-checking (to generate compile
- *   errors instead of nasty runtime surprises).
- * - retain result as a constant expressions when called with only
+ * - Retain result as a constant expressions when called with only
  *   constant expressions (to avoid tripping VLA warnings in stack
  *   allocation usage).
+ * - Perform signed v unsigned type-checking (to generate compile
+ *   errors instead of nasty runtime surprises).
+ * - Unsigned char/short are always promoted to signed int and can be
+ *   compared against signed or unsigned arguments.
+ * - Unsigned arguments can be compared against non-negative signed constants.
+ * - Comparison of a signed argument against an unsigned constant fails
+ *   even if the constant is below __INT_MAX__ and could be cast to int.
  */
 #define __typecheck(x, y) \
 	(!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
@@ -26,9 +31,14 @@
 	__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),	\
 		is_signed_type(typeof(x)), 0)
 
-#define __types_ok(x, y) 			\
-	(__is_signed(x) == __is_signed(y) ||	\
-		__is_signed((x) + 0) == __is_signed((y) + 0))
+/* True for a non-negative signed int constant */
+#define __is_noneg_int(x)	\
+	(__builtin_choose_expr(__is_constexpr(x) && __is_signed(x), x, -1) >= 0)
+
+#define __types_ok(x, y) 					\
+	(__is_signed(x) == __is_signed(y) ||			\
+		__is_signed((x) + 0) == __is_signed((y) + 0) ||	\
+		__is_noneg_int(x) || __is_noneg_int(y))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
-- 
2.47.3


