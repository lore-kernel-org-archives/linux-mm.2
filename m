Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB0ACCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5328E006E; Fri, 17 Oct 2025 05:12:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E928E0016; Fri, 17 Oct 2025 05:12:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456638E006E; Fri, 17 Oct 2025 05:12:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 314E58E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC5AD479E4
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:31 +0000 (UTC)
X-FDA: 84007040502.06.96973C3
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id E88181A000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QE8JOszR;
	spf=pass (imf19.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
	b=0LdqN3WDW8vbymZWFUfaLXzAdPI6M3hIjhy4SKkiWfzZXurzKDnDfWt5dD5nTPJuMf5hGo
	K8aans+1W9mZAYbeVfbx+pwbI06mEqFAzCdVZCkGkok3l2eLN4HJHjw73iLxHnQf1dPXZ+
	DIOWs5/TeEhTuVmen7V9E4WPltUdp4w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=QE8JOszR;
	spf=pass (imf19.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.13.214.179 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692350; a=rsa-sha256;
	cv=none;
	b=nxxxuKdgKvwUbFiClFaFrm9z1T2PcC0hLkjHp2dLEhY6LomZkGQ4wd57I0ShVR2N7GUhqa
	HZEc5FuP39w6y0LPmBy+oZwSwYCdmI0DCLJQ8jOvBuWBXXccSsd6aVqDXZrU1b8bHUtND6
	2aqNEQguEGRQwiaUKHMre/4g7VDbEqU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692350; x=1792228350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AzpApDbX8CFEbC2P7WHNPH2gra+XDIh1eSQ6GUhJZw=;
  b=QE8JOszRb2Ip9FCwEATNmlqlIZ/vqbeQllJBNprnVmQzfxZZ9Qx9WBAH
   X0xIUd0Hzm3f5nzdIqkV9hAzvCBY6wyk3O1hW9CBgIsBkMmp09KnJ2DdL
   3ckg8kTlk5u4O8hNuvoaPNDOLmrfmS4TT/XifxqCw9p1BCvZCz6WYwXnb
   cPVPE5wkzyYIBzQtZRIw1wRFDzVX34GMrdzjFKp0h2pLTTw9A9f5/R1sk
   S60ybatgJEEKbNLGixySbeOuz75RKEojSc0X1eKppf/jRFfJFfJozkC0H
   P3PcDArA1DejFllViajWypBC4i5IO8ADNoqHuBIZA0h3CTWgC/GpTNfjJ
   A==;
X-CSE-ConnectionGUID: bTqjfIDhQrKPx+D5VJtRrg==
X-CSE-MsgGUID: A/3LiItrTFOsBgjb3vL8og==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5072939"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:12:28 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:28556]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.58.51:2525] with esmtp (Farcaster)
 id 143397ca-ae35-4539-a40b-e7fd0de0bac1; Fri, 17 Oct 2025 09:12:28 +0000 (UTC)
X-Farcaster-Flow-ID: 143397ca-ae35-4539-a40b-e7fd0de0bac1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:12:28 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:12:12 +0000
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
CC: Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe <axboe@kernel.dk>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mateusz Guzik
	<mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH v2 22/27 5.10.y] minmax.h: update some comments
Date: Fri, 17 Oct 2025 09:05:14 +0000
Message-ID: <20251017090519.46992-23-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: i3grwudkkgj58un8medmjozg899y3tp5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E88181A000E
X-HE-Tag: 1760692349-164374
X-HE-Meta: U2FsdGVkX1/JgyXNn6VV7P/9TojkZdNGAJylA/6CWdo+MESNsdDnL9Mi2HhbYqYycN8HwFM4Z7U5CZIO2+53DPo2Xsx8S5jVgi1WXEjQBKhiLTUMBwFwYZwEx089CoB4/gkj8WUMpBx0kDnFd8PrxGECD598/NvjEpK1UBTob/c7xDjx8KGUDt5EuSVU12wvAVQbwZb+vLmpeZmad8VTW9E2VPajblMeHo7OkcJRaTggRByclTxcowBksP3PHvmAHHhDR6cSd1n+onUI2hPhIMb6hhAK6lmkc7eDX1HwJb50g0GOKfW+Dh+LDfhmScW3id8rQetpLA8ImJooUIpH9azizX2/IjWA/SQOEzTUJOKK1Vk3yubXa+l9V9KlWDc27ciAJq/H4liJ3vWXNQ/B7Qa331CqROq1xLlmT9E/kCLOvRNk4V9kS+lOsHp2lx1NkCoKfv1TsTj1QNy+QBmGWEPZr5abxfUOCCyKZZjf/kR8bdWXqlTSW6wTgcN5SZKcTmv4CCPfA9RJj8YlWtvYiNOwGAac87XvdXO0hAeeQI2N16rra/EL75c7W0WohMSuumRcE8mFA7DHD+lVBvTlfINzpekJDda8gT71S5uKTibp2lhqV8BHF8lA85hsjvviSfikTMxmiA7Xp61IdHqg9+jcnjzmYv91NwxiWZAfdb0at98gtuwD6vzgy/RpMxN4CEcHymD6vc0R2pIu1J8H4iR7GrjTdj0iQoD0sHYY4EmCl137V808cu7Y4oSeNsdzTpjpGuAlASnXELi+iXkTp8mydyViFjTEN3LA77q/tXVNtVwQ1aLi6EZDn9R+aX1dnwPDZGwGl+k4nhAkQfWbSzXQN0+MRUBq2tqu6xueaBGktEECvo3ktQ90OL1DbYd+k9t1SCvF9C3inPxC2nE58kRz/wALRLw203ZD5T8javVoVf+a8Ezqbuel2aPnv63eQ103K+pbdtt+q/cLAto
 2+lUby/k
 DhDKbHTAM46JIUqJgOt7xUsPw1Sr+V15Qat79XUaj071d1Rwyu7kW/RJizijnlr6Qol5doKd+OY9pnzP8enc2IsZyJsJRfAVSjNG5JWnD9KKXs2WEnbf9Pczpa08WLHry+/AQQhIXYPLFjiPsNTRFVG+h3jUD+iwOWJGpKNcu/4RrvVRB6kwdwWHRr4DnTb48TvhKKEPTig6MaW5zFb6q2N5lO9IWGGjCM21boyAZpjZa3djFtZanClZPIuqsy9dHGVDCLN04U2Utwb0Ur/pRdMjOvWN9SoerokiC+pLqTshQXSOwA2Z3akVKJdEckKnArWY+VWPDT+FNOAwQKm9IfP5SEyBu9UI5i62Nzeue3ArwaStGizcIzxdUMcPYleQFD8fHb1s7g5T3eg5cLMuBO2sMlQQ+lEiRBs4mAqfXNpaDPi0kWDFaWWcP5x1EYMQuBN3+FQ4FUsJ4rwpApa5XKXqqvCsBwiy+RkZNjFvPtij60/vOLaxol6/vK/EK2OKvXajyS5r2YCS+h41g8dBaxs99SRQubkaFZUBIVP2Fky0E4RsKLq/Sis6D8IHLQMuxoXdFILN9FUEq/hw3m3qpglnRTPn0QaHmQ8zah7yakBhGiHI712Wo2P3CH3Lhd2CP9QzvE02IUW4w+Cwjpbwq3FKT0nPwsPsHcsmtBoIJy06Lu14L9cYVgi/ou3BBzPKOuteQ5YCs0+HRtx6d+kb39fcmdo9zanL228wQWzmZ06rOj5E3fKbMFFZ/2sgZzAl5Mzo4xS/u7oZsCtzy1zbYSdd2F9evulIK2TSq5zY3mKhc78+Kdfhe0e/Tqj6pInM/NDA2L+CjQTNT1BPrP3kyKtfk8fOSEeDWxl7SctfN5th1asVdz70uymTel/tvU0eRpesx6Q2tfRFfXj0K581X5zXMKM5VegfYjs9l1zusaUsG21V3GEHUJfFywOFtNxBqnX8STOi6aWj2oFkti0JH653xfBYp
 aGBBVGav
 HP0tZ8YhDKcCgbBeNgx2z/Jyy/0kbvtpPZdcn3v7kXhf7IhQ3txt/yrFQGXB4Onymi+ML/xNiKtX8xhvMZPLFuuovUXoD/4MCrKIL23BkAl2hiweUOmtlVBKZCAParVRriYEj6WoPyQspHVPIgzWdR/NkqBqVONcqrPfd5WyopcfK0/t3h30EnUlPODg03mJcu3jz289HEXTl4gEomGOtRk9H5dE9ZOx6Iui6HO/Bfs0zOnlvX/CaKYcmiTpeVtpaLPKd+k1PU0Y4mNKQgHYXLMuerKHBdzPFs95iN7EAlXvCiMaElYxb7hpdrSMRdsPtEo3IZIp1M+K3E7+Y1lz5LAMhxU4ityjCXXrgFhgqYcWc9yVDCO0aOoXjFRf81ycMiTRiKlwNX0kVh8zJQZ0GwiHlUSllcww5QL59IvIw52s/XSjNur1QZs8eV2zO2xNWBF9+K9nI24hfvox+IlJy3wazzK0xAUwAwZTW0GBrGPIBoWYiGAENFlNKv2EK/C1Q7p1PLrc9lsf5AlGhvbha5BqD7rX6GWms2IntsYVcbBoJ5E05JfQwKO7mVHhWheGw4MA8wYIEWeLnWrtqcWKnNwarfvmKKtmgW9th+BMzfJ32l4q3XxX2R8T5nAsjPxaxa4U8uY/5Qun9DHgCocUEia1KalWolUjYA3aAgLySRgMru5ycELhcGotk3FSQz6gHb+PlLqcrD+cZgZ1vlelJYjLUK0+maY2jjvr/jgtinBAWZU/5pbiLbCJ2qCdX7b/Y4J3RlMXuwLQhhRuEoJn5JDEACRVVQCT3zoURkn0vLR+zMBxl3xCRWyfedN/MJ43ddYyzpHOIeTZXW2vvHDLH2otCRszM0wWA+YgTm5qzTZLyEKAtg1VCqjOgRQSASgsnKul8nFnDVJBGZMkh9A8CiU6TwSqioqcHwFVt6BNawfxop/46fStrf6vkOnskin/TajVNu+ju5KzjyNWS81jMwA0gqNlA
 NLgPwYnE
 xrseVk90YuQ2Birk5rvsOv9RgNuHn4NG3ON0IVnfnDGRdSgZmEv46fFyafygc45VwCSOp3FvnWRr6jPsRMutuGrpjMrNVo6sbBll50ed+n5MH64Nsg8Hm1wAUsdctd8ud4SJozzwsUDVZArm2IDRbWYvXyYp8FlsvXE88IRIl+8A+hBfPzNsq3jQDA3IsyqtbERho3GNZ7fCknCQP8+SFv/QbJ/14qRf7gxP8enuA2h7iGdPzrPwplhQgIFDipQEl49a+VI4uXGPhNhDmHjwC9CMxGFXmqJ2KWSlNKsWgzhg+7HJrcBc4TciPHLrsYmwibot4kHr4EOMg/VOQlQPch2V9Jx1NzLyQuBydi73SEhoG4Zz7CPx2HIadBBPFlgGr/Ae8LBUOKOD0kUVGr5frN+pB2YPBxYn/HAZZyPzCdgdRcs7GtAwrcB6ebeWTshALlJ/fVBbpF6W4jRQhkATb+ifNHJRHYIQjAOr/b54q8gJ9zOb/rF7ifaCxg2yawAv+DN0/q2TQuTLJNp1JE0Yba0O5ESU30ucx4RG49lhXbFPOsHvLgQhuNI8iJL77QKv1Ps2mfXFIMkQ94allHYgTm82Qe8ZquOUwYWzEgDN3kNukzxCpdD3yJmIIl0IU4lbD4yjHhAEHo7aUQdeaOy32PpUZSKGHlfoaDyiVky3aDqzRuDEGIdjyMsSvpVWk+mwhlmVy01Y9q4aSeWKqY7IQdiwaebAnHmRGxU/VfqUHtT4kPCEgHHyHCpaveTkVg+sMmqXGy0zFXMCz1ycWDJXEe6+6qGCD54Ps+ZoF467W1daWH5BTfm4Uqqzo0Mx7skD34+r5N2YsFeUvL69Ik4Y08Rk9/h9XXe4sl9P3Rte92jhgmwOV+p3omtKQ3mytM3JR1exN9yrTZ7IGe20HzbT5EbVH342pTyMVGTNqimkQtpa0i5BGuM57IRe7hyz9eo3vg7eiRy752jN8d13bJnBuzimtxDGN
 q3SNYUl2
 VXiwtvZog6/j6LvR8Xf1v1UyMY04V7Hat28r1HVQQLelV2usHkUn/G9lnCSQiT8gTiCmGg6cI5REV6D83wLEOKXGd7rJ3kheeC1QOoIBb5rczQLhUKQp1aWbYQk0/28mSRuXpLYBmJg/Z8T1MNy0GSFfTDC2t5cbxOMIeHOHu950Wj7JV9eNjc0EjayHfJ1Lj0GZ2uKoK0++5fX5raiwuOJRQrTY4WLnDL7MUf2n6Y9c16yFFbkFX6B+E/cA80148rdTjTR6Zy3CHeulNwTn7lalY6DPmGmQvdOhAqbcEAugf0tuSjvgciENNUFc0vAhJlEu9d2cwZaCttyxqpc+gDnYUPK+ipToae55c/YtRKqEaZwTt0hcw0LF4swRf6dXYU0MzF2GrbD3TWGsz0to6SQd54fF3wHSMiYG4iDYtDHOJ8p3rtng66y/76TrWZnQYlcpEAcgKtROJvZ6QvZXgNcgEef5hoF95A8EmcKE5v8xZ4pI6JSDoko2QIYrz9hNAn2dP/WKP9hFHiUUw1Xyc0XZqa/U1k6ogZ4EJjHxVTmKElHZcdTy/EouGyeVVtSSLLm7msthRGiQ==
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


