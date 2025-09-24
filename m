Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56377CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B19288E0016; Wed, 24 Sep 2025 16:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9768E0001; Wed, 24 Sep 2025 16:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96AE08E0016; Wed, 24 Sep 2025 16:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD328E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:33:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4BB1D1601A6
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:33:50 +0000 (UTC)
X-FDA: 83925295020.09.21F4B36
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf13.hostedemail.com (Postfix) with ESMTP id E72D12000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:33:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="rR7/vxtc";
	spf=pass (imf13.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=gRi+3VF1Yqe4rhZ1mi/j3fQCr4Z+RTipeJm0CDUeq9Pe26Fa6ltkuNWQVm0W+A+9iJnnyP
	LBqu7sToWbxV1bMI/DVEQmjz7GG4wYNvA6ng2pc0LMt4bh1IUp6nRenoih3M0206uHE5V8
	uLoKvMiE8g/o8Di329T6Nwjw7+jYjOg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="rR7/vxtc";
	spf=pass (imf13.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746028; a=rsa-sha256;
	cv=none;
	b=Hjn/v15G7yxZBXQQJK7CDSQzNH+CD+Nyw6VxciHVD9xf2OKbCPH4qFMLkQqzdn+VMCB0pS
	uW6JDF7X0mkU4jGK9mNo97fxTVddaYgH2RXkNP6bRHgdTjZxuo2jsbgn/zrQkQ6doub3NS
	G6SoumpKmDcLtHjKPvzzzP6xIfNewvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746028; x=1790282028;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=rR7/vxtcLedPhboNNEYF/X2tz3hEbuuoXwO1K5Cc/MYdRpzS2dpP5xr/
   a3RRGbCOB+BgahVxPzW4HFhxAyh1NvA4gJNbvIdZXHg3pzKUskIj44UsG
   2+MFZKSOts3yHnYIQnfRZ+4B9EjiSaORVh4PFBAbpwR35Pv7aO8JPi8ZJ
   anauqLNN7z2o3blDb6kRz1+1TF2rcGf3rQwHv2EbL4molGkCVVIA9IWwO
   RJqwJYQGz1HHeweWtRvApQgqc1gsb5MsibDKYRTwbrJhGNAAN0NjefGkR
   /xICpF+f3vppTxGvvyRxfb1S4Dt16CYnoTG9Wv0vs6OXyw7yV2AygHyrm
   w==;
X-CSE-ConnectionGUID: NW4hijkfRxucxyZDXD7Jdg==
X-CSE-MsgGUID: py0FnotbSm+nXduHAvC5FQ==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2628113"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:33:38 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:9053]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.61:2525] with esmtp (Farcaster)
 id 38e96aa0-b2c3-49cb-9cdc-e9f990847ddb; Wed, 24 Sep 2025 20:33:37 +0000 (UTC)
X-Farcaster-Flow-ID: 38e96aa0-b2c3-49cb-9cdc-e9f990847ddb
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:33:14 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:32:37 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, "Jason A. Donenfeld"
	<Jason@zx2c4.com>, Jens Axboe <axboe@kernel.dk>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>, "Pedro
 Falcato" <pedro.falcato@gmail.com>
Subject: [PATCH 14/19 v6.1.y] minmax.h: update some comments
Date: Wed, 24 Sep 2025 20:23:15 +0000
Message-ID: <20250924202320.32333-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: E72D12000C
X-Rspamd-Server: rspam05
X-Stat-Signature: 13q1w3btrs5j55cjoz718dt9jp8rxm7j
X-Rspam-User: 
X-HE-Tag: 1758746027-35085
X-HE-Meta: U2FsdGVkX1/y7UuuE5j03tnRSDdSlDkDOQlJ8Omy1EGlraIiO0VtyAmXwPMhPr/LG6vpMNiRjSSsiUSK3BUg4RdBrabC2B1uHqi1YiKeCnjB7UffkTI6GRtGPH7qRRFiwVAWFiMUl681H/kDYtBNVm+fiwnDtoN/dJ3m8BYwQn6mI2XzRkHYEBh7lgroKcCRXIddZeVgIBC8AQThG8fXTb4+SpbS8IFF2glCEZm8zlbpXdqc18VMND4C9tjEQu1dr6qLHCDe0K4bozORWN9o+JQWaiRm7iwTRp/PhcRkCvj/tgSYW/ip3pWXqe4SdKg+rtO5fwDT4r11dOKNE/QuE6yIkxXjYW4aTHuo2dQ0t3AiMXPMcTKx4qmRyfEWspgBNZlylgTQCIKJif1M+Lyt6cxykKylCJIec3tDqfuO5NlQvEySSwP1F4J9jlf0cmJ8Ge/Pm5r0DRjPGgLh5s7HXPnrPHZRtwQjE/QNyFpwUrnd0jYHErMr16FwZHRjggDbcqL+rNd3gJr+C3TsipnMQtxktCa4RX8Jnm92wpFlrwY6hhIM4f5Q79E63D8Wsy7mnLISip6KO4KUq2OkSBTQk4SEI1ybJF+KtTosNuPrCe1LottoMRSMn3rzBzwLLezkLaoAjdXSXRxY2gv109yikOMhB/knaajnyoax60Zj0W6Fa5zpAJ1o0ufVMQM4CTipDG7ycOdIDGGixNCBBGhK+zrLkUMQiJ15772g82DLFKZ9VonV+p7Jloddva56QjcM71ehSoy4vcicP1Uybdg9aYArkF+9n1UBIpIpJ6ssWrAvdNOG2dJZYLh2zW5bV9lo7iv8tU1MKNX/lvfoK/x2chdi/70nVpT2sVt9AJS5q6CpjtV+DOSotCMdfd1Ce5vwmwlp0Lpixj8Mro32KKWhavQUgOfOpRlicG2UXgYaNR4ndIw9yJytwWFnQqiogZqD7t5XN5dN3PN3w+FT5bX
 Q8+fT+sK
 BUkiVPxvHnju47/sHYYXvYIsFYbP2taAaR9rUltfNCwdj7xKHbGwUFYsoo+4vYr/PXeqlwQPAAY6R4Z9uH5cf6fUhCXQoSff+L5OYnzNqJThgLyqO7u4Gz09ZH7RTqLVl77EarVPDqdy2I+zqdwdUuujXlyFJxyyee8p7dlnBmpyzvyVFSeyfN84A3roTirda8YLAylOyrLyxZhpRQjHu3S8Mpnl2WkJnR5kF8VezC7wdrccORkVdEcdcgci4rclsJhhle7rMhdFZKn0uBSmwqlIZd3YMaOYnCv/OOg+g4JyMJc1ogJVS7CAlfftjS3ZT5xcrkfrfHrWqiSJIcUfhoQ1/0U9MGhcB+68rciC3IM6eVSEp2dS3emdHZwGKzasIUE4jljw+/d90I4iDsCM5drwLgww7uGK0A6GJJypoIema4l1EL1yIbDRZXtKHm4wiHYNWf2RjWXD9n7kFHvsu8urtyH/Wyp8dDO8VvuME41gvrFcldfw008meSwrolKdh4Mhzfh80dppUx1vID6/aV5COHf/7ejSTC+1oeGfjC3sguVUtMzApPGLrxjchQiPvv/Tne9Z3TbDX45dp8L6R4It3mFBjKZ8MB+G8VO26zELcFc1LyRRGLEfWwTF8YrDlVdrRuc9nkwIb8yq+aHIQCqMSb9UCxwXaRE09e/a2Suh2R2dCbE0E8u+tEAjx98QCWAu4XDORd3AepQ6rPXhybCBqtBQZwTNXgphLTtha62qSUB7upJbt9HSztn6e71MSJ2E26aizmBr+QrxLtpfq9ag75SxJUZfdl20v3EiJxcbfYArH7lrBM/jt4oVYNnu77+L/28rYan0KuQuu/c9rhIBZGRZo0XbXjH2nxUmDzOMeF9oatmZANnfvNSn0Fl5HFUZ13mGd/TDNJdQX+QQeOIBlnNCGbzJ22Pkmy2OiNrnzQKisAC1rnIm6r28rIOMLbYnpazu30GAgO0vOWPLzsXPEngAP
 y/DqrbRD
 eB2QjUErKKFLjufOkmOVdlOPVv482UbYaKEbZOuichrPAfesScBWHaKWa52j7nyn536tgSbGRQ2lgHqbY0zLtDETE5jIu3lush5rKDrXYeKKpOJTRz8l3rMa6wPIbjfYFKnWmSsJAXL8zDr1830LixRklwAY1ORO/sTU++ua2J2xU/+IfxUmCOw/49kvecWRLrXAfZ09AQQHfSKNz8BtxLX9IAiMIXjQSKnPP/3yFheqA1jGargWVk7cBNoA7gNJlNKjjb24t2LBBYvOgntWpHL7Dx6UTAkRumunOSgGNbIj13bHyhyyL2bhCZEC4LykOWf5xY7Oo1qIOIIqXBzgvEykDEGQ+98o5DoLswZCEv5+7uEofd0uI5UwG46qshtXdC/ol21K9gB/4DFng6QzcBLwT9VyIA2D0KDry2X4rZIOrlI7FI4JUvYcleg/to4t4gQD6ERXya1wMPToMcnWTQ5osFd6dPwwbJHSsSbiriFyFHv989lPDBS2tAtl3lLi//+QLl/WVtK5S4UhUSTjWu4Wa8WU8e//yRyu8AybwGWwY6GKzso7DVLFT6as7sZJV8HKXz8AQiuRF6u0walHXT4Eew0YeI8tIKrJH5CPvqjZuzCyMtvbrb/BbWTrYZTyp1VQR9GrHJr9IWjXy4yfp1MR4WZZGX7sokt8dt73XnheJZF6vaccHUeJn5LYH+djhe+Mzn6B7xSvtn34IYYY5LA7bS2DTZDlDK3dVlfsbLAkPjJ3SY0+fc7+QjrboPyDReIzyR/8s+skh+23Aupj7/feJ9/SHaR5skBdan7DIBJqnHmC4umS3gRhq6Mxyr+USOFSFwxUqFzhHGWXJ6dx0FAqeRRAwWRZddvYJ9sn7Nbx48hsqdtazE1Yz/t3EkFaurzx5oQTDVm91d7R4ERD0QaGw6X86d+gg0XAtr0v4Uoxv8rRZ0SgV3V6KxieljHxlz4XXYYxQpYFCWi36j1EQUedHgOUD
 YIHjjvtk
 gLH/vzS/Cvk52iT+lBJLp1x2kAY38PBJahrzVkc4fcZ25jPDNYp1zwg4ysSyzGjAb4WfZ2D2E5544nZPgUSfUJ8Q/gSeRdZikyuSpw6fu+L8iLeppCQtZbd3D6+AC56ohjWvmB2x4+bk33FOn2i029AvUYc8fOwmqVZN2ntcNKyI4nlLAq0Rjm23+CQ1lIqpA51LSL29jb0JGQdEN7d7hk+h0IuG80Y8med+tVLrT0n02qYzvVKdHuxlqbFAhebeh3PYb2peS+z5BImnB+GKWJhOyuW7MEQdr0f3XySb3nKIBWaP5+z83xGeHp3RY/lqGJTQL62dySYFDRNqH9dvJIH86HE8bO6dqxzePA3qyvRnvwI3pW+vaN2pTVHN9vBf2mApByFv4DEo6OMlCp9WGCMH0JS20kHnxNC8oT+maW1QtK7RihNge1pE0hLwkt5I8wZGp1dXqu0ub5iO7hwdSjWaqRgMa9WNdT2GsnLWzpSHDtquoo6PlAUDGz551FI46w5P8bRjNk4MttzcPUOqy6+pwbt6JCwUSx4D+xsQO4VlBssIeDILecB58W09msKxT9EtnQ3EcVo6YQ7knsW6ZBfNeUnlWzTL1gOSfet+g7IYcd1dO2zVv6CafNGxgxA/kqFOKpgtJvJgSdxOyqpN4Z01QjXnZu0SfWqBaAYBIQGEXx6jIl7f3FMh/5diwHajfBOtj/clzk/6+EChZHezWrcEWDFZezUlJzNa+VKXHRT43kTKDSpXlwVFLZnoMmrKMI0JvuT00n6dWAMYE1iTDukJs3IYQkCrketry4iAO0Y3lrkb5A2UitPGjQKZvgOXcgULOurdP4HvrjdzIMug0pkM29/k6NkOP27jxjmOoPmWFUFE1b+JtJ2PD3cLSndPO8r/eeDeDpo0mMvhdLXryCHLk7bnKMT35aGcgWAVyn7YH37aMAzwVXwYhsDJJxvGYXnVjXltNzXnS6l3dPcjyTtzfKkLk
 A5KvJ0fm
 U0fZmRzZ2UncK3pKtTm1AeDcC4ROxO6ITguVTEVylPump8lVb+Y2z3K6FXXUqEmNkRTQ07dDmVtLYqWA5qCpyrlVo6BmMY4+93VbHSoMgB2JC3rr8/kqi93HiZxSVpwqGqdTR1Qwdbkff+O0SegBVQvrzu61ZHty41QRQTfzzXco0gEBIDV08UJzQhc+fk1ARFDlz78H1aEPMEu8NY0gq5/dun2jAaHzY8krmzACOlwKpVUVDQX1XzAekV7Bvw2w28TcJwsJvO+IlAfCk9Gd4QdUfoijqoX6Z0bKtGqtijsk2+9khtwMhykH3ONe4dzrHiQ6cH/94db5QmvMc7UFhL7gu5JmSi1ySU5BFa/CqNT8OTCsaozmsKskbHdZzv7Z7cj0YUPe75qrPIj3yUjEsi1bglGaWQkLwXQgApXz1EMMfq8MrGfCFZ2QCeflvYveWetzZ1sGhnjWy03HRGG/KpLxZt12LEM+0rmzThAhTcU9PdblXT7dQBd8Io/kt0J/XQcZATXLGO0VQZa/a59w+Ocf3Dre6m4u7xg8mSm7UnhQBAJNNFD3v0ugvdWLUrL35BLkLUoJ7YSbtC0QsuOLb9A6MZWu1q5tdMCGbKO39oo9NBdCL/oLXVP7FWt/Yd4JpPKQU+152VOfzHfpUd9RDZ5dEz4pPLS8f1OXDLauUbqKqH1R9TTa6QxFnaks4+QI4nk+9ZmiAniQ4SYUq8gqU3Ycoz8Le1Ij1dvR6IWfZOUBj6SRFB29EkfnQ8fxGIwpXLbBa7sDMN248kv25SIOh6y2B5ufc76rRwwIy5dTg5BGM+0nuDGdxtAavYqer24v4sNAHthakmrtyf3P3J96UQ/QCagu2CCOFbFwP7zQXHElLaLMi/7UsAgKOj35axBTQ2ajKAbjXsAxsDuaZ5+4mN/PFcKNJaMzaNbHnZAe8cpnJOhqH/HCVBfclApU09Dob1V9HiVKxBSmTaeqOiwZz2hZJogzb
 HlGuOTVK
 KUC9+jIqTjtZegBK5bhN4jYbROlGKZ6N/0DrxND2CfmUlfpAuoPLw/kuXN4njXioO0GZEMPkoTMwAcnamo1/mAQYYVBZsxno5ots7BSuQNMVtbKwp/mVH8wUWeiUEWiMyBuamLXyJEKOQQjkZQirupdMzg7w1zsFk6uiIjsGCPgpUfsmsdiiK4g/RXksTwVnofjykPniJh1mrtsy7hScWAjZtZCU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit 10666e99204818ef45c702469488353b5bb09ec7 ]

- Change three to several.
- Remove the comment about retaining constant expressions, no longer true.
- Realign to nearer 80 columns and break on major punctiation.
- Add a leading comment to the block before __signed_type() and __is_nonneg()
  Otherwise the block explaining the cast is a bit 'floating'.
  Reword the rest of that comment to improve readability.

Link: https://lkml.kernel.org/r/85b050c81c1d4076aeb91a6cded45fee@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pedro.falcato@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 53 +++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 29 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 51b0d988e322..24e4b372649a 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -8,13 +8,10 @@
 #include <linux/types.h>
 
 /*
- * min()/max()/clamp() macros must accomplish three things:
+ * min()/max()/clamp() macros must accomplish several things:
  *
  * - Avoid multiple evaluations of the arguments (so side-effects like
  *   "x++" happen only once) when non-constant.
- * - Retain result as a constant expressions when called with only
- *   constant expressions (to avoid tripping VLA warnings in stack
- *   allocation usage).
  * - Perform signed v unsigned type-checking (to generate compile
  *   errors instead of nasty runtime surprises).
  * - Unsigned char/short are always promoted to signed int and can be
@@ -31,25 +28,23 @@
  *   bit #0 set if ok for unsigned comparisons
  *   bit #1 set if ok for signed comparisons
  *
- * In particular, statically non-negative signed integer
- * expressions are ok for both.
+ * In particular, statically non-negative signed integer expressions
+ * are ok for both.
  *
- * NOTE! Unsigned types smaller than 'int' are implicitly
- * converted to 'int' in expressions, and are accepted for
- * signed conversions for now. This is debatable.
+ * NOTE! Unsigned types smaller than 'int' are implicitly converted to 'int'
+ * in expressions, and are accepted for signed conversions for now.
+ * This is debatable.
  *
- * Note that 'x' is the original expression, and 'ux' is
- * the unique variable that contains the value.
+ * Note that 'x' is the original expression, and 'ux' is the unique variable
+ * that contains the value.
  *
- * We use 'ux' for pure type checking, and 'x' for when
- * we need to look at the value (but without evaluating
- * it for side effects! Careful to only ever evaluate it
- * with sizeof() or __builtin_constant_p() etc).
+ * We use 'ux' for pure type checking, and 'x' for when we need to look at the
+ * value (but without evaluating it for side effects!
+ * Careful to only ever evaluate it with sizeof() or __builtin_constant_p() etc).
  *
- * Pointers end up being checked by the normal C type
- * rules at the actual comparison, and these expressions
- * only need to be careful to not cause warnings for
- * pointer use.
+ * Pointers end up being checked by the normal C type rules at the actual
+ * comparison, and these expressions only need to be careful to not cause
+ * warnings for pointer use.
  */
 #define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
 #define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
@@ -57,19 +52,19 @@
 	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
 
 /*
- * To avoid warnings about casting pointers to integers
- * of different sizes, we need that special sign type.
+ * Check whether a signed value is always non-negative.
  *
- * On 64-bit we can just always use 'long', since any
- * integer or pointer type can just be cast to that.
+ * A cast is needed to avoid any warnings from values that aren't signed
+ * integer types (in which case the result doesn't matter).
  *
- * This does not work for 128-bit signed integers since
- * the cast would truncate them, but we do not use s128
- * types in the kernel (we do use 'u128', but they will
- * be handled by the !is_signed_type() case).
+ * On 64-bit any integer or pointer type can safely be cast to 'long'.
+ * But on 32-bit we need to avoid warnings about casting pointers to integers
+ * of different sizes without truncating 64-bit values so 'long' or 'long long'
+ * must be used depending on the size of the value.
  *
- * NOTE! The cast is there only to avoid any warnings
- * from when values that aren't signed integer types.
+ * This does not work for 128-bit signed integers since the cast would truncate
+ * them, but we do not use s128 types in the kernel (we do use 'u128',
+ * but they are handled by the !is_signed_type() case).
  */
 #ifdef CONFIG_64BIT
   #define __signed_type(ux) long
-- 
2.47.3


