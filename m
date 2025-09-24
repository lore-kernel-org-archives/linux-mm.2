Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93006CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC5B8E0012; Wed, 24 Sep 2025 16:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45D88E0001; Wed, 24 Sep 2025 16:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE66C8E0012; Wed, 24 Sep 2025 16:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B7D718E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:30:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6616C1601B1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:30:38 +0000 (UTC)
X-FDA: 83925286956.18.03E2644
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5646140005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:30:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="EShhk/R1";
	spf=pass (imf11.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ToVPFfAmijgFkPXuC9UXKvHeG3XAoNk6zHMcSv2Lxjo=;
	b=alU7NzE682t34slaQ1HihGIObJ0T6c5TCBA/o70rmiLMr4ypPnl5osUy7NabWw7s71HfO/
	5ZpwaXFqOvV1RaOp5VO/BXzKRzOTLCssWAipBdmN5BZo8xnVHYNFlzmSUWM2kMkCJgKb3+
	+R+qmAKbthJyO+aFilJ/6kLK9AfBVuQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="EShhk/R1";
	spf=pass (imf11.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745836; a=rsa-sha256;
	cv=none;
	b=y49pJ8DTjUKFL3BX6gQCzJO9kODXw3uLzk/Zbq3t5inQFfCyeMj6NuiPqFW4erx7SEjjXP
	myKwjS+YpjVLaq6c+tdhayhlmtE7bsP6PSmgX/YoddR8unNAWs8VuZ+o80O6yLgBQJ1b+N
	MK2aSHNwxhkAu+R4PwYtNrXE4yb9+So=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745836; x=1790281836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ToVPFfAmijgFkPXuC9UXKvHeG3XAoNk6zHMcSv2Lxjo=;
  b=EShhk/R1aoOf0UEqEOKNgHsHTTybKrcit2UFmc3TLb6faQGLO22lCIfh
   U4VOx/W75mZQZ2W28eJWXPtMWuPeVrXK3iZdFggn5uYrDbdE6z20SIuMK
   Jm9+np+81RtD8UMVIjf16LMLIz9mx6gNicbuKkn+ZN1BFbDf5Hgjd2PcM
   wAX97tTNmmQ+EeEzhPTg3ki0hZtGHP3j2QIUoTqPsoo6fcZPgEkWXhU4O
   vdoJzWUhAedLHsqftzK7O2GrultiqBPB/17kZfFNHqZXIWu2at8Sucw5R
   cXjwjoi5xTIt9Q7mMyEFhjn/lGBOAeOdDoFXAEPuXYLd0IgAy7/enpdUp
   A==;
X-CSE-ConnectionGUID: whQs5I+6RPuEkQo+yiylwg==
X-CSE-MsgGUID: zAkb8LYyRg601Cbp7tJfdw==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2631986"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:30:25 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:8635]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.61:2525] with esmtp (Farcaster)
 id c1f88da4-53d2-47a7-88a6-131beb406856; Wed, 24 Sep 2025 20:30:25 +0000 (UTC)
X-Farcaster-Flow-ID: c1f88da4-53d2-47a7-88a6-131beb406856
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:30:22 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:29:47 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 10/19 v6.1.y] minmax: don't use max() in situations that want a C constant expression
Date: Wed, 24 Sep 2025 20:23:11 +0000
Message-ID: <20250924202320.32333-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA004.ant.amazon.com (10.13.139.85) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5646140005
X-Stat-Signature: 1mwgiek6qsh7tuynba58p4t73pqsdtra
X-HE-Tag: 1758745836-51651
X-HE-Meta: U2FsdGVkX19S+hfB8VL1QpdEjhtJoffyuHe1SQBoAsqkgf4vt8QZL+7/h//Ns0hkjKpwLvpDbMVig6aYD6w3Dw7L+R4dTRJ4s4OF3tJMLWi0ZNKT4YaHy2pOJqZvoC0o6puMkL/XYZ5pU9Libre/Z8wEHLOojbBLP9SYZ9mrIvOwMd85PtEDA6Uw6MBl/hJBuUI0otd+cHD/nThxE7oQQZ2Y6cGy5lWZ9Xs+3pLFLadpwuFa4hXKnqT8s0hm6j4kKvpoEdWfJdU7qKA+XeFDlZ0UGqyRAHflCQc1pNAVLrFMcvQ+4C3SnnQkNEk+hTbaDfcdplycyzisr19/iuS9Fe2YPD3yZLDT8afB1OL+glkUJFvQth6rSmvO5pvsQK0+BlSYsUz2+5ykj4PwQkaMvvrYdoRKCzkWAL+lDD/UL3mcrzbqNYxjazUsc2SUcb5PjR2IaKV06JCiy2s1p7/3Q6GNwx0vTn2PXeJVqIMJ9IHUkuF2b85E2eeih2EUBIZsFXnks3C/UBH+3ohCbOADN52Z4zwNl6HYGyeMa02P8+FSOBZdScBQNU/gITfAi+MIELAiRD7sti/PhuxX36W40HB9CcROytXc0/++4mDD957GVXMhV3xV99SeehvkcEXveHkdjrOPDdK3U11EHNlNk6RMNiB6pInpb4y0o7/cEAortIsFnEKEAZbnvpejEz+s9/7M88N/DJqq+stP599g6iHZcJ4guxb+Eenq90MyqKTILz5IJom0pcSw/exLSPaJX0CRt2R6980nBeegtwTJTL9i71N2DGb96usSwPkUNN9mpkfRsOxjV4TZv2/v0BNEq5k4KyYGNm/mlGF8M/RYFznkMKqPTfM1KrBOh06qRvuI8CBFaTIhzV+wXF/sBOHLWyEDTgRrHDsScpdCtP4UQg4USRG8fuVXnCf0gxgJDfAv9tYvuZj1CkiFpvs7QoEbT4tqVVNSLHKJNqdJmhz
 NUCYblLP
 kFvCQnDMa477QFOYPB6mfEOs8IsZNRO6ijv7Btt5VLP+uW/ovSZhJiVg86m3blJ3cE6Ob53z/AvTd9LmUKk4iZjYwZZaH0EOlCf4LS5q7TIGxHiB+5O3DL4JrH/kO4zjoksCcc6pd4k4BFwF1lMsCg6GSRUCnoVtHPJKnI9Cd1IqME7F3gox489RQmKHZrqiFYRjKquCoNjSkPP+rzJZGEVLQBAxHupRmj4Xu/D1cgFGYwjTREihjqA98akbmFYLQ8lMkCpvSEtnBUFQ6vT6TOYReeYIQd+VXX2y4FhTZV2dTRz/6262UPMGg180IYCQjWCGJJ+vXTet8e8nKmtta9ExymwBhwdaPLsuP8uNUdpvUAdcJmqcFOFcxMQAL8+BfAV3WY+/Yuyd73wYaz7iWA2yfOMsXYLeQ27XKD+YoYJZFOLQCvFPY4rOdXoSo+1FVKvmvay95uk2SPPgYPG0NaX5I+YarpeYyfx581eKY3rfXijARnV5F855ZVZWII0/8fPZYgsysYDIHWONbihuKZ1nMCJM4M81EMVKtDUd9JRLiD8NlflTHDsWWUkLpLzgG2N0ByhQVYCIdYA6G0yVE6XC00hlKf/uRJMUlVmYY/SCh+PhE08ZYpouM9KX9bG61eCPeBVrflUK4yLQ9eut0Te7jClRhWttpFJngnGueew6Ou3i6kew6ff7A5jE6Fbip9l53joO/EBv2A+mVQBwZVn6YE3cs03sGq0nc1r9gQBmnocREWB/tIPkrR/qS/Kvp6W72ayHGGLM9DqhYBoqOlYff8oPfL11B2pCtv0dmpPkGDskZwF1uwgMuJDX1xZaYJsfoHhjvyUeMq4CZMUt9Fq7zlqjbvbAU6fcuyz+34TOTqMkCWcXZwRT1rNV3sjaMvVGBzitDtuUMZqKJWZzZwbaX7gRK8aWdvzUllS4Y9ll/vBY3RY5q+AN9JYFo5lMWe4M4CHNbFTF0d8fp5DRJiFNFT6+w
 XXPnG3iT
 1/DWWWjN4b1xkYiyKARNDnQeKFMBS0B4Y1CEpZS8/KZlzlnWoZo1OXayyKiByBd+TMVWwEwlrU1qr5NqHVtwehWtVcbipGQ6UVMHiR+nrMgBLUHIi9pxvdc9k6vt4jsMLBKiEDYbR+iUO5pzpPA6ukeRWT0m2U6aGMYyw9GB/xtrjm+80fvZJB7n3/EJki8O887Aj8JwlN3Zlu5pAbBaNLjsVlgyySepoCSfo+w1jwpPZuVaN4ACFXyn/vANzrc9xnaBVyWayLUuGKNeQXj/pprtARdYLsPEvL7nzQxsStlRftnu34NCqMeDPlZsnqt9O7VZ6urcUNx5WwNlFWi03Rr/aoLqxagb3j4k8BpspKhEqN8iGbWFYJhKN+K+QH04hB2tcFaWFNdyCe3SM3hX4CplVnNnZiKliug9Y520zHZZVcuwGX9TPiSa9WeIc52wiB+Low+0YTA/uynohkvpgK8sl8ElmQ+vhYDaV2MON9SX2fXuqNFW5Cen+rcCX2zRAEUiSQIvGB/UJQ6OgcWpN16PWnRTQ5CS2Ac7SbMQyl5W5SLAfTfI4ihwGJOEPVVAlwqrtZyYo9zOEfj3IzwDnaH85Ujm0G7sq8MxGFLdsz/iSxlGavN9HH/C5PrjbIsw8KPLA7AlCNyWHHfNeNSxy8mT7Se/1brUmrRiDXnGzmWF3avTS3QKRl+AxOx8TOQyQI0S+t+60tjTnDYNvUtE0z5BfnddGnoNkURqwn0xB86VDQZ744yj30BMPUj9NqCZC9e1DEbNYJt+rrOq+48ued80L39PWpyMaZUEe2u5gtk4flX+II1Uca6sleIbSO+nBlfDpHSJSsUAS/aCIqXUUnY5PrOQ8GcmShCe80f6zfXr+jiAzaeu25Sd3D8L71qPBV4kHur8ltv+k87u9FTgav2V2Z2/klxkM1hIj2tQBwDwuX4VRgoJA8jdE2DJcYCkyLQ820HgKhRAf8c00qja/69om/31m
 a+8lLwfR
 hH5Sm+OZ13djf/ST4wvi/thU7yCEkQJElQGW/JrJn2IJr93jPJJ8Meb5u05Yu7N9nGkTqaxDwPCxtXAv6bb+LE8g3JAXRCrU4glUdefTDGhIh7Pu6wz4kUDGEgAMvHR41nBJR6iG+m+/pBxPWdwY+Zsi8MvHV2Z6fwU6ZHYhRxGv/G7xcMXwSG94CAENAlXfDizgZczz0XKhDrs+RXrjlUSxZmIiRpapug7nMXwBBuVj0jpR2u3gH9r+2IRORgAQNoxIbISi3mvGvwXyuJ8Rdb20WipuXtegK7XvuCM8r9gv/QKOj1Pa51pjnICE/kw6zWYkrtVDnIIKuO8USM52JcHrrn1nG9kVbscW4iEpVKrNmV7oWG/h9IE/dEYBPiS2l5h+snxpImALF0gXPELMmbEJ1yLzp4K3/VLzmoTByUL+GaChQ2zRHTy2sOr3kA/+IUIRNAs7OQGKUJ6E/s205AriAfUpR7RCt515Oxi94oXxEJrK1/4j7bcvOzErCB9iG3Ay1FmzpUutNtjnrRrNqGtzCK9FcMFOTx5z3/ZLR+nURXY8fK60YCS3d/wiqzNa60YEmBwz632kshtcv7+8aOcGmAkJkgVXJXXFjaTW1kJddxTS+H8/uZDiYU2NmVMOIjut653AuJ7yVpP+AKoDYV7jH3yQ35zAQFsVa1JD67CjLinEtrKitik02LayMmlnM5MTBMBRm8rmPsR8hClXaW9kD8vug9e/yBaucokv1FNRoVo8v99zyTzVo5cNwfv9Mg+O2wVG9BqtY757gZy1F6HBagQpOLh/rSbIROZHSOUfUiEUnBxyjL3WVLEt+k0xYjmOiKGrJ3EKDJ8P/8dIghktwGgTvItY6exwV4fcjAyqPo8BWO/f1pcmAMloRK+BL+Hepx0/kKNm86uVgl3RercJtPP7qEBY4UuJesGG1AIn10Mr8uOu12ZxefQZGE93RHMJGUw5p9M+R0RPRRsfc17SjHfIX
 kVprNGmJ
 r+EuK6oR3dmkH9otCghCyK+ROePMkTaRo5leWhuUwGq7Bdu2Rj+ibuMhy/PCGpIzPJ+2Lu0gFIKFNy+WCk0pAZhnZIMI4DTS01h2bfjUXQ/XbIsGMNduHndcXXsp/ic7WwwFbennr4cAGY1ApzP0xTWTT1v1Higx5mPr+7r04rx5I2S2WO+fey0IgLJ3rO2dee5RdUTAl50gxp1cIvRdjsSJ95QERhP13iSrxXh7sEOfDyENp2hDgm+bT28CpbZbXxPZ8KcAR0h1Hptxs7LItR58aPw4yseMUejus7daI+i1gk6LSx4d23N1HlgPnMKARDJnBupvtgjNGu0nktaoaHK0j0fgkfn5vPJ8fGJjoCbMmEbqTd8az/DRqpSE4mDdDRYiTyk2fNbvrhmdoD1dtGPw2mcmsjapVDfxFqqeHKaqrLxfi7X3Dkcl90hWTm1Y3KWBsdQ7lt7lM0CcEpFvI3+uX7Kc40b7vObrnEDZXuy+x2LdBhyohLgSwR4pQ8K2qsTyYsBkN/Vg==
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
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c   | 2 +-
 drivers/input/touchscreen/cyttsp4_core.c | 2 +-
 drivers/irqchip/irq-sun6i-r.c            | 2 +-
 fs/btrfs/tree-checker.c                  | 2 +-
 lib/vsprintf.c                           | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 768b6e7dbd77..fd1faa840ec0 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -700,7 +700,7 @@ static const char *smu_get_feature_name(struct smu_context *smu,
 size_t smu_cmn_get_pp_feature_mask(struct smu_context *smu,
 				   char *buf)
 {
-	int8_t sort_feature[max(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
+	int8_t sort_feature[MAX(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
 	uint64_t feature_mask;
 	int i, feature_index;
 	uint32_t count = 0;
diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index dccbcb942fe5..936d69da3bda 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -871,7 +871,7 @@ static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
diff --git a/drivers/irqchip/irq-sun6i-r.c b/drivers/irqchip/irq-sun6i-r.c
index a01e44049415..99958d470d62 100644
--- a/drivers/irqchip/irq-sun6i-r.c
+++ b/drivers/irqchip/irq-sun6i-r.c
@@ -270,7 +270,7 @@ static const struct irq_domain_ops sun6i_r_intc_domain_ops = {
 
 static int sun6i_r_intc_suspend(void)
 {
-	u32 buf[BITS_TO_U32(max(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
+	u32 buf[BITS_TO_U32(MAX(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
 	int i;
 
 	/* Wake IRQs are enabled during system sleep and shutdown. */
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index bf3822b25c58..cb76feac94a4 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -608,7 +608,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fa1c19701855..2b0b5f08b8fc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1082,7 +1082,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-- 
2.47.3


