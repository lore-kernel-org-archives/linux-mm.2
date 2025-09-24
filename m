Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156DCCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7498E8E0017; Wed, 24 Sep 2025 16:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA188E0001; Wed, 24 Sep 2025 16:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1EF8E0017; Wed, 24 Sep 2025 16:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 488338E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:34:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20C68B6E24
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:34:11 +0000 (UTC)
X-FDA: 83925295902.03.F977AA4
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf06.hostedemail.com (Postfix) with ESMTP id D598218000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:34:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qYDjSADv;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758746049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
	b=BViMvCvDuAtgF4PoOKYIqcSmyAZjGmiM6wlr4Z4oWJzO7569eWDuy/3lTEbkx0b6AGyNSA
	clagZv2eKzTzVGr+UxZUP7zXIYoayunJE184gfBHA5YzQ16bJJhvYobkVpheUjMx59KNqc
	n7l5qEXXIyJnZR2Pjh1CbDHzr+a/hhI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qYDjSADv;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758746049; a=rsa-sha256;
	cv=none;
	b=P3oRHdw9fX2qG8Ub0FNXwNn47ByrlWtAKI849PXggk84VrRImO3mKW9HFFtaJzXjvdDWKM
	wCr29t+hp8nS8ovPFRdgjDT9y3TtAgd8o74NGV73NsKYYfmqIl0D5TNEA9l/WIAazGZD0g
	H+aHdyCGYYZ+wvP3sHbIUG9Cry7c/uc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758746049; x=1790282049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhepguEQ0VZAS3etCeAAj5D/xXUqupnQ1wf0VPifqWY=;
  b=qYDjSADvD5c5IfIJp9iB3o5zjzMCY6GbyUYJym25adfAMBR9lky+iAwm
   XXQjG1YMw0k7iuVdYDXv5+g6Iz7dZWGqtcut1Hq7enmPq8M85JkAc6rKf
   ewF3OWq4UizVNf+lyzfKi9+Tse9BZlcwIXOkG+oWYrCjZ4o5PuNgNhzIg
   1RwEP93uhaNhM2sZuorXsyUX1RD2DN5ffcj8bRgV1eu+VnGaoqaqRKDGA
   wPwBppONTDbjC7RdXa9Ae+nUsaiMyOMuD3CMALiSZfbhviDoR8trhyAMu
   SdZVbv45bso5QvsEy4UWb5Fl5Ko3CGpfDBceWHyGMcwJ3OCgp49bQ9JK0
   g==;
X-CSE-ConnectionGUID: YGf9Am7xQk2XvOfZrvwtbw==
X-CSE-MsgGUID: NWPOfOyeT26z0LmdgMPoIw==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2628136"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:34:07 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:11631]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.16:2525] with esmtp (Farcaster)
 id 3b363725-ae78-481e-a8d1-9ab93c9db65a; Wed, 24 Sep 2025 20:34:07 +0000 (UTC)
X-Farcaster-Flow-ID: 3b363725-ae78-481e-a8d1-9ab93c9db65a
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:33:50 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:33:14 +0000
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
Subject: [PATCH 15/19 v6.1.y] minmax.h: reduce the #define expansion of min(), max() and clamp()
Date: Wed, 24 Sep 2025 20:23:16 +0000
Message-ID: <20250924202320.32333-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: ij8xmsp9n96kxo46bcycruoysy19pxq9
X-Rspam-User: 
X-Rspamd-Queue-Id: D598218000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758746048-772465
X-HE-Meta: U2FsdGVkX1+4j0iaAykPZ/DY41a3EaUmkBESpL+iufeEcAm06dhaCLTFJGEbdg+SX9/mtPDlAlRdJl9Knt3okjaWvEgcM+63tIR5YBzxl9FHkmd6CfiCTPIH1qMPhI7eMyA9v+D5TMeY+DXbdyNEXOse0ZTTIz3u/7/Jb3ziHQIYN+albqBpfWAl+gBVde/LUHwpB7CefbwL5936uW9Ol3MMfFIrZuCUEMf7kqlSDA3zjDjntxGzx3/4MqQb2n0wakP4Zi6x1dA7HfRSlE4cof8QxSKTP/pyyGFBKFlfu15/MTuDJHQd/xL8GODWe3bbgHt2vEmc8ihblc5Y6HUYdg3aycn734J8B6FYlJt8v2qs5tPaFlXH6bDIUQW/QimFwOPRUkFub6Td7Co+AWRA3PMeQKfmalfB+cHcapMqjGIm1t0nVbh+Vvra+FACcPVZn+x0hZekD88Dk8iJ5X8a9GURRd8mciqoowMa6iIx4Fl+UvAyqAPMVN1q9nnFVTRMkiAaw8RRpcWm0W6cOV4AV+17wM+xPsHSiJA6VuKOcZ3oUGLIeh+NrW0+AmvRy3THdUVgu0om7/M+Tn5ams22IeQzAH0PJlP5pB7taoEx5UW4P1HSagauuapLYULg5lkhtSVHCWfdD6+QkkLiXWjVwJYBc4Eu6cBHPut1rKbRMGBmvF9MHtGhjlPDvfhvD9xXLU+qD+zfoHd3E+GNwJGfDNeC1MmtFGYYqO/X1Lhmu3hkZ0EhdjHsHqQyGvrlJCkZn5Etje1k8QAZ7ZMG4/gnQKLbYNb7rOnA5GMRJ2Y4Hecv1rF68TmrStCbJNnewkS6Bi1f7VKWyEZ4SNXgQzOsoz8ELo97AkFtnAxvukmHx9AlpUgYV5mAICPv9AbpmnWde2oPCsjgpCM/aVwD2hEw1ydGXNstRl76Eul2y7fGR60pyN+K17oYHmGxH9nll437EpjBDt2JyvooJfL0RXZ
 kyA+qPx9
 HMwiKqEXtOqF9mHx2qTpGMiE4CaL6CajC4ds120ZfJAAB3ASIliFqAmUXZjRXDytRf7+d4fxxrZmQNjHd6f1CFfCbMT6tuxYVJuXwQZD/FoGML8KLBcsY2SiLv0/8ZdZsto1rBMra6EDR4P1YwoxoHh7QUFilHRekf0RHXrM9f+QB8WHr52vfksW7gy+p/SiO4fmEOUG5vgOkFY/jEQAp1f2598ospUGLgMnZH0UVCIn29U9X3VyMREOH+j58hSrxsIcLj9qmavJbkazTLNlmzjEWyi9l8FlemgX6gZt/5TLIDtEz4VSNzLNuMO5IABweYJ0jvJ21HPHjBxQduDmILdxgPMy7qct/G6VyKwrtNmlJ26LV4BqjzUkaqmOTX78OZfJKdg9ste/qt5oUW+gIsNwKtGzyfGH5AUJpe5zwznbKjCQ9xNFb3arQzeeBCgCEL7qKiKWHryX2E6t/MPuOt6nq2jeZsAKJFhU21c0ldREFSsikehTolizipot0X83Rpla4aAWiE5ytRC6+7uYv6fIROZ0TFtzRACmAmNFfz5oWmM9IEh5kNfRq4nqZG3tU0QA9+vhlWF/de9VbLoUD5iRMoS6+2MZmR3C38SWlNSOUywi4wvwmBWxUVhfvzsq2ODJ3gXmwrwgWDi11pLGf4ozO4vceRjMCCyxEYDnbohTBjuPo8KMqRhAxIEEO+6W69J12NpfehF84tTrjhfYz7mIIL8eN5KQmo2jWS/2x7Mg8HO7Suui+FpIPXAgLzh8/ZErax0sqLd2lnKlUiIyH+pEwfD+eijH9HR86C1z2d3/HVcZIiCmr7YlRvmbSKgBvI4K8Li34HsvumqsCawle5ZpXc+ka05juDOZi1dggdYOmATYNyHmwUepAj1DLnNC+dpX2VdYrYWCO1S+XgHuNRe1QerVgU19cPbkxMM5RofQpt2Poa4Bz0KmevXYGMkyxkW7Q0w79Djq2XufM/a9/8lfILo54
 M7Lsc7Tb
 v886eZ9wb+PAA+cS3d9flY3hHB/Lqhv4SyOIXRj8RRddjw7MQRIH8O81V6nL7vxNXoA6AgzP1GoPDvyhf0s3G0RYp7l9l1ikHeSjpoEP2Urxl0C4wuj3OPbOlzAVkwH7MRjPWjbflXYFcqClKjU+g/u0StGrTC9vqEoNL/thvXsymm01adyGcKDhxzHrEwyVSWvbtSztnvrji9BLL0qvxIyepo9OjrPnV7GdomyZncBAJbZaBQ+gKz1ED5g/4RYqVS7ZllYxVg/V3Nfcn952JeoSy0A9YMfO/uzHFUq+uT0U0jMNVKfW4FzMuWB+f9pdngtRw+zozVPn/ko6YrG3dTDjI7pfKxyQnT41JeL7QSsNc/3EghcbllOmChLiwbMN2sem9ymwMmQX5gmqRQMbdQr6VWi/XQ8XRu00ooQdY6tjilFwbnW56748nl1qydE0ujzmizpEEmNa3NnUM0zwxIbKi/pRei7xOv12FIkOAm2nTaqnjvK6FJXlhjJtcrmKuxbMoJ4eX4B38+n0HFMy5kxLp0YQnZSQcK8nyI4mRcA9+O+Azy1UvwVhTeiKamgvOSG02qzGkjknzsbI7VWu4UgOpOffcB5s7t1RbPfqcWe7ZUpoQxdCbYlqycOw1kYW6AHWujPOj19GRvBnYolSqvdx0y2PiK29MQj8nftFnRGyHjiON1dmdGBs7wapj/49tzc7Q5tt+mJHVoiX5iCpKowAVZrG9jJjNXSZ9RtfcpnbWUtpR20yxi6NAhtmbj2vkGJQIHipCbvVJrOPwGQSAg2yThuFF0SZ7LLHBWlOfhrXsjROEVktRzioBLD66rrJP++G3YZ5dTeY8oKyLlZ+pzoz+7O3XINXRzDCoxyI0sCXusH+hAboqMWx2uyEFurDFyRaVNPcMlfl4IYQjsd3dQ5JkHq/o3ucnQRAZsAxiVUZgvHf05wTcRFb40WPk1HEKsnrksHeTh2iuKfbO56I27AZ6bwOg
 rWUXHS3U
 r0lxwR3xpi8I9/J+Rj4A3kRhI11XoESvc1Z1XolGVoXGis5IPgS4KnZjwmiHZHFDIfKUbFUBlsXtUHwSCxn8qILM5KQ58f8X6s/qNgtUGXETmOVlNsuVethwSGvVlTEzvNply2WnNOnW9+Nffmdxmn1fNTqwgTi6kSRN9fHI3eFgf/1aIVDcw7YqNLgOifWSi/V90NS28QI42eA+q4DPwa21wwG9aLyef1RNwByMDcDzjuNeyY9GegIacusRtEJT3+wn1FMFsbK/4Qpkh5vtDM2AMM5sz31pS0w8JndNiktLNV4OUnSaQ90R+25lvqbNcI+6JPKtWEjK3Sy58CqPlMcv18dWeFx9Fz3tbSYO+NKtRB/HPyf3/2WIpLDdIUQTLswa9+Mg2yEx2OL/9H3aXpEoc+Fo0fWhSklHbk/MUcFEI7Fr/eXvtVodtOv7vnjc8Sy/s8AR5mbKkMzWZTrVvJ5vd0ErNAKdsc9FEG2i/MaYZbXJDHF/7YQkWtSKAe1o1m32Cob3EHheRm/zA6Qd+8SFSftx0jK2e9UF5A0fgyEwr/4qG/a2hHrb4ANQLHCpmUEKUhqLZickBYW0HlYm6jfOS1XvAxaMFNaCebPMh2kq8UjW81A2ovNE8XvDF9tsyQ9CTwIV2naOfKX/ukzHO/AZPpLU1GpT4H2QUCgi7P1IoiAZ4gDvbkIK+LfAaOpzG0U1WvMM9i/8QEI6nuIEtVKdFfuHPaUYdp1u4p7V5KtzfcmJE88Lrh+VWW1fSJEF4DGLu3fIH2HPUsRcI4THBi10ZW0CoRLM9BN8P21TH4EBQt7svGOQex3znxDOHe4cKRRTEI6zof4Ulfb9A9Eg5D0c1ViItimGlsAENpnMhz6vy3kz5va3wILdfWSEzToaIjEeXKhZYRVOkOeYESeubpgQLYt+3s/aZ4BSfMCCXRb3d8rRaSZ3ANSOg0NQcQlL6/UDoxU3TK+ls0aLNeMsPs1FuEhT6
 2cesXyoK
 kb06KK1EBthlsFZavjz8btTS1FwjKCqdCyxMhuQ5nNMQF7xCuAELE5cb5n12iQPChacnU10MUWCF1JVZYK1qe7Lh1VMAHoSQblkORN4oHOvTiQxgYJuq+/b+L1KjVMnkB6I+k0Tew2/3NtubPHPOdo0vpDd2MH6ZX3ZuOH8nLk6Vq4wtUJtS/Nm0c07AyvSRO1Dg5SYPoNDvmzzhAWUX5XWS6fpmSHi+/2gJfkBZ+21MOLqk5bCTUzkyqmv4zrHji27d4lvTDoeA9A6Xko55ByTMlI5z49Bs6WmJvGvNTSTiy/iHLzrthZp66L5qiKpnwzPL6Bv/G3fUfJLTX60iR1insZpffs1hjUxrgOGYML2ljiAv2jNvzV9YsebwUquf/hq43Fnugel30fdZwzl9JLmesal+X4+E2nhQQm1FPMj2PrzPZG4rMDd0zsA1ayDANekwIjU+ypyRzkZslR6ISHKnOvlB/UqVC7VFPe3+79CrhknU1LsM9aXgyNes3wJFBpNlwad2bTmeIpDp4KzvWffJGlX23braTNwBGIarlJTWIJX/pJ+VIbwu3pdUWjUHos5ksT/rC3iSG/kLGxf0p8aqGZFb5kOQ+sa96GhAp4NHosd/7WQUPo1c+suMpRDi+YUNwY9AdYsnNFQcpqZ/RR6ay3FpCaWPPlY6yDwEwqx9ssbzv3Dir6qDu+Lgcz+06uSbtu2mIeZGbrF23BqpQ2wkgXnBaelNNxiEDGbdQW5l9xFSSbZgBm/SrPHydHNwDWXQcQlN5COTV9WoLyuhsQe/H1GmO2IbRDqwT/78Fd6B1G+IuhJNYa/OD+lSeMAhWkNd9ghklueUnDgLyHvk3r0Y88PIAra4zSfJSZK5PCXP+BQ4s6NnxmUEKt+GUqxfFcxO4WsBsZSnx5iP6JwndKylcDUDQ7xTEHqbSC7nSHmlO/txZVNKeEeu4C855/xBv3V6dnpkl3NtOUSowdNsUhd/5YEhm
 ErtH6aX3
 RRr1xEc6MtwvfOV38spAx+HL5m6GdaB8YVKSKfJ9UNuzTuk84Jp00ngeyeo4XIcjZEYhaihhuaTr7FixQ072W9mb9YAhtnVfKYkqDZtWZw6nUm5k5mWlZSdxy0VdHfetRKzBl3E+1mvJmmSnHjIepMiJzU2geaD71teoKBYblYW2zXG9hWs7fPPrVdoYEysNs/2Ny9eQ4+JDBGM1+h8UyFLNutF0UlChvi3yO3JOyIxYhWm0zGlFqsXj90Zc40SZPaSUdvnF9Rt76Nnl2SzVNqXyV7Sw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit b280bb27a9f7c91ddab730e1ad91a9c18a051f41 ]

Since the test for signed values being non-negative only relies on
__builtion_constant_p() (not is_constexpr()) it can use the 'ux' variable
instead of the caller supplied expression.  This means that the #define
parameters are only expanded twice.  Once in the code and once quoted in
the error message.

Link: https://lkml.kernel.org/r/051afc171806425da991908ed8688a98@AcuMS.aculab.com
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
 include/linux/minmax.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 24e4b372649a..6f7ea669d305 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,10 +46,10 @@
  * comparison, and these expressions only need to be careful to not cause
  * warnings for pointer use.
  */
-#define __signed_type_use(x, ux) (2 + __is_nonneg(x, ux))
-#define __unsigned_type_use(x, ux) (1 + 2 * (sizeof(ux) < 4))
-#define __sign_use(x, ux) (is_signed_type(typeof(ux)) ? \
-	__signed_type_use(x, ux) : __unsigned_type_use(x, ux))
+#define __signed_type_use(ux) (2 + __is_nonneg(ux))
+#define __unsigned_type_use(ux) (1 + 2 * (sizeof(ux) < 4))
+#define __sign_use(ux) (is_signed_type(typeof(ux)) ? \
+	__signed_type_use(ux) : __unsigned_type_use(ux))
 
 /*
  * Check whether a signed value is always non-negative.
@@ -71,13 +71,13 @@
 #else
   #define __signed_type(ux) typeof(__builtin_choose_expr(sizeof(ux) > 4, 1LL, 1L))
 #endif
-#define __is_nonneg(x, ux) statically_true((__signed_type(ux))(x) >= 0)
+#define __is_nonneg(ux) statically_true((__signed_type(ux))(ux) >= 0)
 
-#define __types_ok(x, y, ux, uy) \
-	(__sign_use(x, ux) & __sign_use(y, uy))
+#define __types_ok(ux, uy) \
+	(__sign_use(ux) & __sign_use(uy))
 
-#define __types_ok3(x, y, z, ux, uy, uz) \
-	(__sign_use(x, ux) & __sign_use(y, uy) & __sign_use(z, uz))
+#define __types_ok3(ux, uy, uz) \
+	(__sign_use(ux) & __sign_use(uy) & __sign_use(uz))
 
 #define __cmp_op_min <
 #define __cmp_op_max >
@@ -92,7 +92,7 @@
 
 #define __careful_cmp_once(op, x, y, ux, uy) ({		\
 	__auto_type ux = (x); __auto_type uy = (y);	\
-	BUILD_BUG_ON_MSG(!__types_ok(x, y, ux, uy),	\
+	BUILD_BUG_ON_MSG(!__types_ok(ux, uy),		\
 		#op"("#x", "#y") signedness error");	\
 	__cmp(op, ux, uy); })
 
@@ -109,7 +109,7 @@
 	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
 			(lo) <= (hi), true),					\
 		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(val, lo, hi, uval, ulo, uhi),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
 		"clamp("#val", "#lo", "#hi") signedness error");		\
 	__clamp(uval, ulo, uhi); })
 
@@ -149,7 +149,7 @@
 
 #define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
 	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
-	BUILD_BUG_ON_MSG(!__types_ok3(x, y, z, ux, uy, uz),		\
+	BUILD_BUG_ON_MSG(!__types_ok3(ux, uy, uz),			\
 		#op"3("#x", "#y", "#z") signedness error");		\
 	__cmp(op, ux, __cmp(op, uy, uz)); })
 
-- 
2.47.3


