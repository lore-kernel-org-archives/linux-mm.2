Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC56CCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CBE8E0149; Fri, 19 Sep 2025 06:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126058E0053; Fri, 19 Sep 2025 06:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FDD8E0149; Fri, 19 Sep 2025 06:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8E9D8E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:32:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F8AF13B5FF
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:32:34 +0000 (UTC)
X-FDA: 83905635828.03.64FBE8D
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 639C9C000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:32:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hwJhngjP;
	spf=pass (imf22.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=4ykOv0vijp4Tc2DR5U0oDf8Y5/lARHUl872oPTfxqMyOvrb1jt1VSMWCFcP/lkd5uDfXxa
	1oAGFiwXMyoXZHudOGQvjfBPdEB2PXI4sfzsyVsissP6Hj2P6UwFbbqUNKZWe8tSImN1+A
	Mic2g+3jTyEI21BThfV+/bhZFwsS70Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277952; a=rsa-sha256;
	cv=none;
	b=3VyYzHaaJNXXQE1B4UjXXLdvamkoRipgaimUvezTsL2aewuTv5MxbNmYpqSLZgGBJdt/IJ
	1aEYrxprkDzmAmSPrDALiyNyYPz/W0cSSw322ZTE6abXo7u05jlDptzzcn6Naps2Ss8NNL
	t1LX/7K7oz8XW7du+vZfeNs8PxI0kWo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hwJhngjP;
	spf=pass (imf22.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277952; x=1789813952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=hwJhngjPQomwsUHHvllXDP51nndkhJ49cPaaErxtR1ht7igG5zfqOKw+
   FuXd7V54dELgBZTTrVuEBJb7CpetWANu4Oy43nrLNpa4X3PO4Gz6oXVAs
   sk7hiNNQVLKTQ18mtrXeIOSx1x8H/qLUNJlt3bK3M154rc6Li6q8esQVq
   waPrbAesR+YOyUvPHx14PI4Voy5ZLj3Mxz2WK+SyHWGnoXMB51x5OHl8U
   3TI49BNymHlhrAFLfvC1zmEW10Tkmg+1M0ic79sNOnj8n3QDOfHzzobAt
   4NQQU57RxLlPzR3y6nCrANPc3zsqV4uMAY9ERwO5SVMODHZMnKG0umAYt
   w==;
X-CSE-ConnectionGUID: vdA2C0QkSVWjh2y4pmmbHQ==
X-CSE-MsgGUID: VWm2OCqVTx+ZhWd1vE2i8A==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2268151"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:32:31 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:12485]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id 0bda78a6-26df-4d94-af87-ffa8e1eddac5; Fri, 19 Sep 2025 10:32:30 +0000 (UTC)
X-Farcaster-Flow-ID: 0bda78a6-26df-4d94-af87-ffa8e1eddac5
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:32:30 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:32:00 +0000
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
CC: <jonnyc@amazon.com>, Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, Dan Carpenter <dan.carpenter@linaro.org>, Jens Axboe
	<axboe@kernel.dk>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Mateusz
 Guzik" <mjguzik@gmail.com>, Pedro Falcato <pedro.falcato@gmail.com>
Subject: [PATCH 25/27 5.10.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Fri, 19 Sep 2025 10:17:25 +0000
Message-ID: <20250919101727.16152-26-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 639C9C000A
X-Stat-Signature: nh7amfxuo15t9ukk95or8x5kmegf3q5f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758277952-439283
X-HE-Meta: U2FsdGVkX19ZvcupRkco2kZq4Zx/u+AmnreN0rHwra67Vnwzy5qiQCVrOYup4NJKZwaVYur+8wGlAXNPY8IxxXPmc2tp/tejN5aECbMpATx6d0XPjpYxZ3WIPebeW29528IyrkvZUMRFKkb/vUIROvYeLx2VN1vTCMTogVYGh44CTZ/tuCgBK5cmTrEa9zpbuf+Q5lSfqcq6NXZYXJVHxvgBYizHi/Tbqjs5ZhY9kjpyeQQKOamWuVziJRbzhOdBVhOdi/lz/PU0CbneQh4JdwLjtoriLFpJIgRAobC48bknT+GUTrQda9SeWmez+Nfvr9h2W10PJjxD77dTbcc50NPqNh5i2tUzuL5L7MRrK9GPZmR4Xa0bSYCOpywLj06ryFN9BaaK78ou7OlxvUqayLt4eE88NWrtN2hZ2U6USu0nj3NelgnJ6P6MkrthzyrDWYlKgH2OG3gQV6c0WtS69e+rum1mz98NCZ18r0dvciQwtIt7BTkoPcVA9lWYiJB6UFIJUvkhLMp1f338hSqkN6CH83sOqYi+YWRBN6cmUFJnozWbgYv8rD0JZwaRaUfUeewN0YvS3VsUiBJEocS3S4rdkfyIL/SHEWXoCxXK8TCMrWFFALrN/Kz0+kYLBicgGCY549TmWWqJ/Uz93Ghjml8Kb4RueO2YoSfAFN06AA7OLxYCU8oBE+n4VOO/adxx4wee1TG7vJhMwj1rMShrrkhqkFz47Wq7L66CQSTaKADK3P4JbOq/VyU2R910TYITCILEVVGEp6RgQ1KAgA2QJDxzogLgcFs7+t5v7NMWsE4FT6NAtsDWcOmk5rupD/CNYkxIDhOdzXdxRydzJJozpWFtU8LcnYTwekH/gkF03tOhZ4NUelzuOHhZ+MPE1fdJc7S+7R0vOK1LVU+2B8XDdaN1Si9eu1kWJRlgAiF6ZOMW8i6XkVepRnzGS4fQOm8q75P46gGzFUF+G1Eim5N
 PM1xyyFI
 +OOMDM5Ass6oXPqJt99JycaZcQ7zIde40OnY9mGruYEPrFMUBml/+my9588zsLmV1EOJvsKX9gPCIp5mKXpAJEtmcugTuCCqS0F/lFkR9d0T9NXuaOIYPMfW2EJnRhHc6JuBpswIRP8sPxK4GjSbkrlqHjylOFPxnt0sg1PM7eAB2frjIsIQ0AJ8SyihwhBBrQy85sgfZJuROapwnshNCe0G/2bpq3y2Zu5Dvwdt22AZzdqrwIw8Jfc46RaEE5TdDXNQ2cjm8ndR1FfJrvOI/zz/ZLJBYV1q/0Eo1+WTI9co8P0EsEkJ8gSleDos+g4uX/2pU8eGC+Jl66lGv0h5Y1YqYwUH8jzRfNYVmsUoqR1tN7VMgr640tiITsHj6wnB+2aJ6looXzZZ/Nd0yevzex4XUzHvpcg5BGjRHA6ou/gMwnLedFvMjDWacdztWMi/KtlHTe4QoOS6TVsH4TxmL/CSck0iZm8rurYXrUUFxv1b7Qm1tlRS/Bkr5qKnTV5y1f7jXDX/55dERXFka62qq5+wYeiWCovsyKPqOMMBFhAUYig/xDVoYkhunJY/9ygl3rfvGNIHADiNXo/rlR8MeQ4V6+F/eHTCYHLLu1jCoWcWQil+cTYPnkB7fDFIYNEkwkIUAxz8jZK/KnpAhhE4rzl+BkRvokNYjwxD1lN/Kl0Vhi2bvSRy4r/a2gAtUDlcY/bu0jla0smhFFqLgJr2lQf1fv7k37j5D9VvgYXF/gwiAwwFbmf8iwYeUtGbZgHXN1kckYC/w8rbYjWq4MnTFMLHEx8hy/5EvSIiYuYYFiz8RS59xIFX5fnapBTo7/WYzpwGRY3llps+3HWxhTkiOBdrRr58iPWcoUAogCLH4fxYAbDys0QzTApli3kj6ZBuvgcKpTa/+5t6w/MHS+Vs1nHYxC9m1x1di5+RpAkDzpuaZfAdMwKrs60bQ9Me3kk2cMq5zazuFM8OUefzApjW6yOHAKdm0
 uzqcgjrv
 Y3n+oZyjk7OcU4fjjXzyhF5zf4pHxyIkaOyeCNzhpagTqOC0rYS8KAdJrohLEF3BSALuplt/niayAq6Iq9QjR+EIBy9UCrIWZL1LJKy9cy4UzY1y9Fzmtwg6M9hDb6U7A0VgBNh8t4/oJKjeAk6lwwHIVB3AFGxK0m0+8NkFgxXgeGl05+0+HUlqXW9Y4hrD8GeZntVPLP/MRCoIwZom9h7wQ/z8TfC0P9N8eEi1dwyJyocX5vlgD1TmQeObHcmC2HBpem2NMNZPH/gi/fJaHbsoCgXB6fOCGI62roKuXEgb7lwO80rDJ/C5mHkOLyrBucw7/9boXc7SQPRPC/sXgksJjl7bHRxbgNfM4Cay/qrDAbyNHEgq3gCgF4OW1dwoGQ0G8K1ozuwrCio1pabDJev2FKDpPZ2LwKKzXoHVafklwShIyzGNlsZZytYtbWk9ArS/J46otXiC+4eGvb02ehfrX4CwuN8RMabQGtv4A2yBgyAE5/ErYpI5KqxEKinlUPfV3QgiQzFXehxF0QWJBFF8aLW6FQKvqeoZY7WasBENMs48oRumOy+XPpf3PSu/Zot/ESA/1imCOHIppOLiiNtafQC+KriV/KF0kIBZPEicXAs/btKhX2UbZcWABSXm8Mk477exAWv7JQ4fbCC9jOSJ1Qqrzx7HedzBROaEAIlKhHzKakliHlcfibQSWmqrB42fV4fcS+AYyinSSXuA0L5vyKYIpqRCVeLalFkBXwr6V0SsNXq+tv7pz5H+uuvrjtmHdO6MFwofLe+GocOA0I6BsM16P4nY8vVLxCtW+A3bnKWTLimJgoItd5s0eqWMWk2LacKBLKYhgAWKZQQ2jimu6axeG/YGw5IkmPKOLqSyu71N5ieMN/QH037o5Qn+i66JCT06ACMCgqwMLkwtDydjsZy637pqrQbnrGjPbCh/0twPohW86vPNdqylBkr9uuMU5Ao32WxEH9bOIpuTUnYNcOUNM
 7OkyDdP6
 sfHURWA8cHVw+0Qo48k2GSFZ2DEr7WdSS3SgPJ/t9y0bgPL14vnq4US8rzDr1RPS8Vle80FIHI7YoP7E3CMo16xu/iAmlpZkUrM9/XzM14Rf4i43xCBKivQoOqFvPK7pn1FINBMXKJses5uXtNvQf3aCndx7B/j0kBMeixI/h/eAzoFDlhGk/fVGzidq1tEatet4zACg+Dgu5B/zWTn4qrvpQdlk3SLy4dagDVKaXQCPIZMDjWaUWBpd/LzYC1jqT0ujoJpi9sESJojh3UjU6qt1RQ8hrhjJg6/TU1wWGpfyuBRCiozOA5EsCuijiGY+QqtMdoySoKSpTwdWHN6sPZiNhcsz4tO4MGNkpTXtoLwZLLWt/nE4ku+K2ZRUV3nyT9p1giNYQ4hvzpO+HAfnjjxDgZ1YgdRHZd0GJFGLn7gcfzMvqz6HegN6gGImEI41azS3fDrhCqwr1VujIo04h/znUzl0ff32TR1MG3pDN1005phfHLyrpQvFt8i8Gm4DPWif1Ytw/omTHUZ3uiP/K2G38qwJqQBsm7g1udyrLFECcay8XMK5cpXWIQjdyIfqUqsZwwLHqn2oa9NDtknVQ9qTSGp/O0MfqSQVTDiNKEetky/+I87FoQyjm6/vCQlxniT4E0IK80y7f+FoAOUCeZkJH2x7bCjPV6u5sxa1S0OogmOGL7De+CJs6eRz8m1OfyiMcRvJWTUZBrdOgDsbILfDVeOyEywOzH+TGI6ND/9bHpE5Xts9JJVq4uL9QXp6UEKpXW41A4Q0LOabjgF+B8s+X/J/qQKAKNqWbRtI2Ecj7N593dinzuiPsiKvWkouDq4sYgP/ol1qhSl913XFoG8RbPYV5dN5hg/zijrACvxtK66rD7VtaJE+KSyhDzE5M6dj+jYptmi2Y67A1uPveexLDwyi8VgSjh//a+qyQE7Thn6Pw0AlVhHuHyOKFdFKtgfq8ghyY2s3zuERuO7SaEO5n1EQC
 NJTKRc/Q
 DIn3AL9msDZR3L8tWFlj2z1sl/uupksSYLSCqiI80qfE+X0D0I8Cuoyv67yjB4jvTUPlguSjMBBTG/8gyPl4GItYrbrXwnlN97iJTnBQjQqIoRQVrSybbeb17jpcyy0Og2ocmuxLWcthcO+m+WI4b8jSD03ZCb27cNdUydo7b0WHRqNqclNV54SeOyc4UzErPaWaW/CJmdaFs3qfSVoK1OJEiFtlPtv+VAfIYodRuzyFJWWAX5WG/hzN19lBqNSpef55zrL7aHxP7gcksnMjND39pp8wb5duATY8S4cnU5HHcWU6VznGW/LG5qtqKkxHT0mqLN/+Gyrl65WU2ATfckp+wzgtLCkfK7MsjjmWTpe5W3jnGV8vs34BVMERTA6tQ3VqbJZ45WYEFx6tYX0T+mZAijPQnDjZ5FmSdAhQ3gkkgO9aD0SgXgZ5NZWQjjAoe2jynCjCeFnAa8Yalqoum0QF3S/4/yxr0UuzPe25hXX+nMAaVj77N0fIEotsPEPhe9xOaqzWH+mU0ZYlQ7QOeR48HaXvJOnBVQZij1vHbZF3oF6+BcQ54WXthzunOrHGlmPj32YYC2+G+VymptlsAhon4INcYAKB7Dz4IS72hqa7TCvH1ZaFhOlHWXZ2V++5r3mW/hLgGCBRnREmv+pfImYqHmDvW1B0sbZcwAxVeqcBibPtaYG0jxxuL7Fqf7n8IWG29DoGwiHs0AfEqBFG60U8Cj/qVlMaELcojlCeQ1fQztGL+TZTHV6lO5Vmj5E9Kw4hBzftitJYLGN0l4TtYg8LRWUH3PHvNoCx7qIYZSNse5I7yPkKw/jtliMhOd8ME5j6pNEx1wK0zkhHDOg/qWbMnnMUaw54AX54fvA4p/GjK6Wwltewek3DwUISKBGJTeriRj93BpeLf1lsLZYKhpxtalNxLc9yRVOuh8ZGUgTAf2bFT6nS5AAzQCn3lFx2XT98lOOjFpFdLv+Dme04eRNXxT3qa
 HwkEiJrd
 wZMK3CkEp9ywdE70/rHQ2FJIxjXtX8ZRzzwtlrpmaqjVtrF5a6EVcPr/teTCp1dQRP1haxYFbn6tQd63zOsOhpig1lDlp7URpPogWz2vTc3VStp3l+nxOzrk8j672objBGeahIhrNcjJthSed3bvWB4LocIVKZrpqgOI7PnTalpdGA2Ax70KL2gzFBfmaJrDft1kb8lV5YIteidfgjNzZ1v824gAAsywDkCuONfn7/hF6Bwj1wAufv0oi0FrpMmKZ97u3WlF9DL2fazOc289kTYeqK+I/e2WIzMJfae/UbvLJOb2vQLa9fdZEUa3boTTnUrh4AWgiv7Zn68tnTTWJcmLsBbTl5QPMAeukDGIoAAqY0c7YkXzp+7nbWjHJMBb+wvcZOdCNtAB8mX6L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit c3939872ee4a6b8bdcd0e813c66823b31e6e26f7 ]

At some point the definitions for clamp() got added in the middle of the
ones for min() and max().  Re-order the definitions so they are more
sensibly grouped.

Link: https://lkml.kernel.org/r/8bb285818e4846469121c8abc3dfb6e2@AcuMS.aculab.com
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
 include/linux/minmax.h | 109 +++++++++++++++++++----------------------
 1 file changed, 51 insertions(+), 58 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 91aa1b90c1bb..75fb7a6ad4c6 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -99,22 +99,6 @@
 #define __careful_cmp(op, x, y) \
 	__careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
 
-#define __clamp(val, lo, hi)	\
-	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
-
-#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
-	__auto_type uval = (val);						\
-	__auto_type ulo = (lo);							\
-	__auto_type uhi = (hi);							\
-	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
-		"clamp() low limit " #lo " greater than high limit " #hi);	\
-	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
-		"clamp("#val", "#lo", "#hi") signedness error");		\
-	__clamp(uval, ulo, uhi); })
-
-#define __careful_clamp(val, lo, hi) \
-	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
-
 /**
  * min - return minimum of two values of the same or compatible types
  * @x: first value
@@ -170,6 +154,22 @@
 #define max3(x, y, z) \
 	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
+/**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
+
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
+
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
  * @x: value1
@@ -180,6 +180,22 @@
 	typeof(y) __y = (y);			\
 	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
 
+#define __clamp(val, lo, hi)	\
+	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
+
+#define __clamp_once(val, lo, hi, uval, ulo, uhi) ({				\
+	__auto_type uval = (val);						\
+	__auto_type ulo = (lo);							\
+	__auto_type uhi = (hi);							\
+	BUILD_BUG_ON_MSG(statically_true(ulo > uhi),				\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	BUILD_BUG_ON_MSG(!__types_ok3(uval, ulo, uhi),				\
+		"clamp("#val", "#lo", "#hi") signedness error");		\
+	__clamp(uval, ulo, uhi); })
+
+#define __careful_clamp(val, lo, hi) \
+	__clamp_once(val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_), __UNIQUE_ID(h_))
+
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
@@ -191,28 +207,30 @@
  */
 #define clamp(val, lo, hi) __careful_clamp(val, lo, hi)
 
-/*
- * ..and if you can't take the strict
- * types, you can specify one yourself.
- *
- * Or not use min/max/clamp at all, of course.
- */
-
 /**
- * min_t - return minimum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_t - return a value clamped to a given range using a given type
+ * @type: the type of variable to use
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of type
+ * @type to make all the comparisons.
  */
-#define min_t(type, x, y) __cmp_once(min, type, x, y)
+#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
 
 /**
- * max_t - return maximum of two values, using the specified type
- * @type: data type to use
- * @x: first value
- * @y: second value
+ * clamp_val - return a value clamped to a given range using val's type
+ * @val: current value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
+ *
+ * This macro does no typechecking and uses temporary variables of whatever
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
+ * integer type.
  */
-#define max_t(type, x, y) __cmp_once(max, type, x, y)
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 /*
  * Do not check the array parameter using __must_be_array().
@@ -257,31 +275,6 @@
  */
 #define max_array(array, len) __minmax_array(max, array, len)
 
-/**
- * clamp_t - return a value clamped to a given range using a given type
- * @type: the type of variable to use
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of type
- * @type to make all the comparisons.
- */
-#define clamp_t(type, val, lo, hi) __careful_clamp((type)(val), (type)(lo), (type)(hi))
-
-/**
- * clamp_val - return a value clamped to a given range using val's type
- * @val: current value
- * @lo: minimum allowable value
- * @hi: maximum allowable value
- *
- * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument @val is.  This is useful when @val is an unsigned
- * type and @lo and @hi are literals that will otherwise be assigned a signed
- * integer type.
- */
-#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
-
 static inline bool in_range64(u64 val, u64 start, u64 len)
 {
 	return (val - start) < len;
-- 
2.47.3


