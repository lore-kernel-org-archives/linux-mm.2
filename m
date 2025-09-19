Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558CDCAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A404F8E012D; Fri, 19 Sep 2025 06:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0FB8E006B; Fri, 19 Sep 2025 06:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8848E012D; Fri, 19 Sep 2025 06:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7276D8E006B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:26:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34D6A160441
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:26:04 +0000 (UTC)
X-FDA: 83905619448.17.5D0EE07
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf07.hostedemail.com (Postfix) with ESMTP id E44EB40005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:26:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dTSW2+az;
	spf=pass (imf07.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
	b=UE0cp4ZP5CtBT1r85hwZ+g9XU1rhyXMltQlMfmS39gsvdkk4wB8e//3wUT8UjF5VKqz+1Q
	qdbqlW7V2lfo2voG3DB57F09kwSZ85ZGi3AQmCQb8f7mnyA/kSs+v9Oi45HO8zL/ndSX+3
	RQ28PkmhSOc7A9rd3hw47IFOtlcb2pg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277562; a=rsa-sha256;
	cv=none;
	b=zxJwKzja+cV7okJ0TikiJrBA0D78y1cdsdHQGtCfqXV/UCYWGjsfyeu5d/mcVjuNVYCwLW
	TOLc1Zqp3H7dgX02klF7kfUydhP3xqTaFjKndhxJrzYg8U6OoIFgN5W+FwYkJI6gcpgYul
	EVdjPTmXK2cF7IDl25+PsS0IdDHpVRo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=dTSW2+az;
	spf=pass (imf07.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277562; x=1789813562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
  b=dTSW2+azVKtkDe8atMGZl8SI7ZPWKVXluVH1aHZTKCWPcBsZmoGZo5W3
   UDOfJyy/zNgai8SILqQqlt+6Ydk4JmN2He6p8rv4VKyrl1mFpvicz7yUt
   hF/ZGMTk03iu9T3pwEKN1QThsHs6KzTGMktsiBVb2Ce6vTXhnsz48nEVN
   FhftbCOAHZwfEanwW47idY5ssAy6SJWSFHXX5bHsY1qi2Vm1ELSr0FQvA
   3yLWcQtOKzI7No+RVcaoWqvBNw4x95J488z34k0wU0C5mH3xV7Ynkbv24
   A0R/24zw6UxfyZnSw4LfNCy1vqJTOJ375tY8T2OOkw3WzL43VLZNWAvRu
   A==;
X-CSE-ConnectionGUID: qNcQLpyOQc2AraTNrsl+eA==
X-CSE-MsgGUID: dlKiNEf6TymZnD/i2VYzWg==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2264438"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:26:00 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:7660]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.47.2:2525] with esmtp (Farcaster)
 id a189cda0-c60b-47da-9f08-ff06b9cb4616; Fri, 19 Sep 2025 10:26:00 +0000 (UTC)
X-Farcaster-Flow-ID: a189cda0-c60b-47da-9f08-ff06b9cb4616
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:25:59 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:25:30 +0000
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
Subject: [PATCH 14/27 5.10.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Fri, 19 Sep 2025 10:17:14 +0000
Message-ID: <20250919101727.16152-15-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919101727.16152-1-farbere@amazon.com>
References: <20250919101727.16152-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWB004.ant.amazon.com (10.13.138.104) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E44EB40005
X-Stat-Signature: tkwwxtb8d9o5nmwrja5okd5jrfat4nu9
X-Rspam-User: 
X-HE-Tag: 1758277561-256310
X-HE-Meta: U2FsdGVkX18fY2FtF+i/AxhVzM6PxBQxWEl7rSXqs7YOsTixvOjpnGAMeFThIZGUcCUOQwNvGUETd8OWwPga4zbeRa+zO7uKL6dn7YgpHg5IvTWxPbVW28mkdEA/6/o9t8Fe7JLj0Z/DLGuyPbWlkiR9J97Rq/axlTUL2lsDimrCtX6kSgQt5Bv1f+Mbw9MsXeLqAvZdWZNBuEZv1cdzHtR3flez0BodCdhSO7LrXJVZX9Jd2BTmpSJ2HWD3HxtVOg+VlTu8jDyoq0D4J8ocx75h4ciKMVXPFsZ7PHyFvQH2mPpv2aCXH2lOlRdSF31mUJndCq1BoRCU3DHMo232/VSpfV5xfHxWyWq54IoMrdh7RHfitzyLo0QhYUiet1Jts7lta1Y63l5PGxIM38ys1Epv5SmKoGGcDHAKNQcs2PVncLwzAxtKA7uR4XmQFfHVyP3U3c+peWqYPl23NoX6d4+RiMue8VtZoG37lwA7IFpOo5Ra9GpR5SktEE41C70ByFZa3k/44bUGq7anCw29Vk/NOyCraCb0cJRs87SxNiC+Sgv7spVEqZy/UYO4ZCC469Vku1qfSE5FEXX6pIjXInmLgAm9Nlzo0L5kuhSjtXBMSiAOIAlZCmeItbyBKkJ2neyXv6rPezxndkeaeL9YOLYnxSDR9VvJEJQQiDJ5oop1I+qpvDWLCmVghKQhAOzPzhtxw1hh6+ulHotI59R1xNRC7Y7m2X+rsXya1QJbVCz0WxGV1IuMcpsyHlmqKSiv67vm95IH99M3OAQ1ibIfoF3KBu8XaRx3KrRDTCj8CsZx8CODhytur9gZBDZMfJDuOSHOi/8b0DMGsIYtjbWHkIqUBuWWX4Ldh9Y0FZbqymEiIYOPfAfVZrGe9b+KavZ5y0LpReoOAS/CfVmtCamv2j8aIQ5cWQC5yfkkwI9aw7GuO2a6Znjgm8WkkPe+U8V+kog+HEY9i2ALTIl3pZd
 LdHdwRCR
 cSAGH+ueEdscoiiA7qx1AH724QYxB+2yh/7zPJrwAt7eToa6uqpcgxvkqe5HS7ef00ZZ5P0srEPcUM5hzJEIO5r93F4dB7sPLlHQH0C0y1SZR9DxjWtVxzjV8xSLIsT40ICBLX2XWQxrsYoE/QbOkWVd1jMCpb9k966EGb5tDoIJJJa71xl/tBASmBJOhs26feqpRY0VvjMinFuRvn2M4ApNpusR+LOUKxUJV/1IYF/NOWufXeNJtVrRIOk8AtxrhFqdCuInacnVk+uWPlC28qqAeGU6kQxYxot2jYlN+17BVrKfjwt2GPhcUNCjXeDi4O/wq4NMUZx20Pz0M4vtHB1m8KDK7wTOcRanYSHz3K2LpqAwjICKiOl6128+z2qak5Wy0nHtyIX/uLDfULhUrn2uUNPyo3xpj8OmghDRnPoOED4oGnrZgPzsJfr7WbZ3MppYKqPNw2RQ3GwPSXwDk3m5hQR1fjr6IslmocPCWIkt2s7o2n+hFA8n36eCMpS5AqlDiw+VmVeDBunPOeXCdkZTyvjYy9Tbzp8DvbrCaA1C9IzNxrfKUS8aEHNI/d0cHqjdXJDZs9BJYfRbcZ1Co+CAkxsHC/zzXwCgnIPxX58ydtuHT2I87jZwkHGuP2Z/zusFiS4dHr+Fq4vZXP+xTcirq1Pp/eqlCrOYmmRsJwuTZe4Jhx2P1YcY157KN4pdL73uDiD0a2lzrkzQ1NYBnTeYaKhI+GzIskvdX8LJDm4qWE3BFe/EroGHXdTlGLifO6jd34igHfK9dptHIxT/2Y7tZhnpZJOVEGzXIQ/G/+4h0UO8xWkHApWv5R/QUKQi8mERbmwnJrrfGRE5Y4LR1/9k0J1shmQM/sIgG8s7yfL0+h8d+pIaPxpDAtp7msKMnk1KsX0ydajz014HtS+SGykBMtxutt3owcdypb7IvIHAvO6HBqalv0kh4boyYghU/htu6JGPAzPdaG/e7628Udm+hgKA+
 gymyPytM
 sKtQeAUrCYVOMMPPXWaccUtQAsPzvIa0lmWiE1gKgD6JhMTsWuxMkVSDm0myNf6Akqqhheq2PJKH+3dk37sJPqQvawOEvqUXHcvKG+cT0ihzkhOcWJPsIyeB/UHNXYivJOIHHVHIEf0/uFvmhnvtoAub1+rRMqQZOAN5E6vpkhVr2N/NRaF4Zb0GnL7zlzY7ZKtKto9RJ1rlYI0DKP6DWZvguBxSWrNpa83YfeyohLSQJ/P9YybHMSHceGxk2I6XeyaVUk9DhC+Q2es5FsbyBpvBHuZZyI5kp4DHiafPSDg+RbA3wbQE0bye2Q0rIEtl2nkNUlo1mf8XGVENKuxkjNUJybdByjvJES/zGa5lV8gFQArJiE4kwEHgROt3XMYqKZ8FSQfXvnkrWqAdkDF8XE98HgRf38xTBzTdpwHHdZC0Go6Nw4yNWZ6uqLJZaiXgoa2taempDuuKY7nxVcAvONyLSIaeaGebuHlPVM+IwCC4YbNAA8LXUKmqaPfsImTQaFnZvuqDYLOwr/wN+KzCz7pBn4ZbGHMmXg/YIpG+CcqAen9MtE4Z+8Xc2fWnAAnTkMSzSUJfjIruaWwzUI8ZGcg2RJUm9GNCJISUJPWPeIYhAZ/VEpLMPWHK6UTihFqNMWfisb/9U8YLDBOXAT/9HQyqU1RE8/RVoRZ0eW0xRjZrm7Pe3aoMA+1SO8QqnMVo5hSxwWG2pQygAwWCAVkRKmTFlzJApk1QS+0iWqInEhnAVqXEvdNR1jw1ya/crDlSa9UrS0y2F5JoROrjcUgPxhVlON2Iynnd2th3kgXxc6eF0F/BtWfPORHKL2TsVjHkMeXvW1LiK2VOx03z0CoSGFqeagULblXi/bZhfYnTjR9gyhyQ9TAK0FZ0LI6HVAc8LOYV6QR7+L6MJwwCJgiXxm7hKrZZxRblXXa25jUVYWGhr2gE9bsmvD/Vghwk4qdaZg4ku7lVIjU18u96VIzod6LFU+/8T
 UMPKt+U6
 9h3Bwh7QKUFd7H6Q8YJUhG6Ja5L++qT0RkmVt3QJM4xarMP1odVtjBCO9ySVahD9+6H3qZYGcxGsCCcXssCkFrEF51fGUk3e8kjUkrZU4YfxWzMy1mBWL9tDKHnX/s+2BpYAX2zseOKrHUOn4HBsnA0a1rQC6MXy329XcdIr05VHeI6un5uxP7gVtEPq70vxPDYBx7L13kz6GVriYUAHiCbqMQsQPBYeAc78b78yRgOG427RKj6VNnxEd6KDJdjYAZ/443wKYJAIFtZ6zMoDugmbNAOy48BphFujY3FLYCxC3pHMABJhjuw2ahR84wL/AWQV4bs2osESgVJft/5h2SWJ3VsWVz2dOWQCPUMJADabSiPA/UFZq/M/iN3qV/sgGhKNp/u9GBeou82kPuC5jZKMgF1D59kHw6j/a1qEPrS0eIWbFRY7/LwbWXs8rSdY7AqraJjBoXNBYukOqx3GLQgaFC/ZAu5qpX09VEUhKRG3gBI7JGTJtNqp8Dfa6J9wgW/7IqmU5cukvGr5jlSF8O0FtCp+6h4aDTaT4qJfez1jwNpWNxBx0KUnj3ccgt447lBBlpcU4oWDwBjH6K8dzJM7J5EBeMWUZuEsd8rP8xXZyAba93YvCpbJ+cGkxDyqFAYVZ2rAX6zDJmtepTZa158yg641x6AJ0F3HOCpwfTdpy5mrwyH+o3Ja0N3Gu9IYT95WCw47U29O7K9k47Eaqrrtkp1MlB+UZ/t5K9JWVb6/QkiYDqu2AP7+j3hBh6vAm1ZbN6GYg20NJFMJh6uKdZ48DPjtvxHkfrlibt2U10UxwKidOzU4kYvkogwVMLaD+oIneKNYCB5Drbf4+K+2LmU7d+WMb38xWgdBWyjqFY8KMCWyau61WNrmN8pYXqBbNQET62DA4UhffhtFzQEeeqM85XsWDUvyXSkklX6hTHYhgMkMUrddbJMtTb1BUV9dHE2NQjhFB6PLVHOXRFtJvT+q/uMh3
 NIAaDgw3
 OU8zg+j7TgGgfTLll6ZaEl3Alsa4EmQOxA8rZxenjQRmDc68VwsMOUqRJlZowMXE1aZ4IPRdxXhfrUnsXQLlgJYWASCgQSdb+Y7gNcKFAerj1jz9b0YAWe7lmB/ykYGuUjhgKyYNhLPDdsNrYJBCv2BuXRk20EnTIerqqNQhwMgtyicaL9iE5dQ7iumYYpWB/cX4KRtrqMPgQD8HQLaKGbQnvlpXx/39CFGc3Ox3YRXz47azHOgyDLJ6IY4nzhb3wlGzwCgLBzBQy0qnZX9Rn4vC/MC0rLtGshwsJoOx3bcPFI5JrpboQ/X9uCRWdcRC3vrMoK8PvoVVIzrMIgAsvzF6/tOE7k4VBT7Zz/sRsuPuZIb9gywj5kTY45njLydGowDHKg218uqV3k6xxCKLvQgBx45jr0aVzYAFv9vWmQjFMcGWAgC76P+EWNZPnkfdjQNrpmhbV8nEB+w9DFMCmAPtFb1OuLDQi0Elbohh3fKy0nze6UPSySNPoMLlhwEs1lNHzcA4LPnWIEuxoOau4GnUusqXt2xXAjE/HNeZ10P8Zo4kvEu+o9oW9b9zXapAijHt2SuqYa/fgFZUtElrgj+DpGqM7fW4DRohW9afKWrqJZfrqihlYWklg0zjECi8Jd8+zdYjOuyr2Odd+iN81Q9Ktpux3AKx16EhgAdDDhCy8sjpc8HQSba1d7C8Fn6qFj0MhxAwOuYkN1kmVGb8XHuiYQ13wVYg0CuS8OKvwB4Npp+NF/Sm++u1tY9PGJoilTZgIss6/oMRAY2gy9g9ouI54RkwMxISpDXqEJj20lF8FAP4gpXufMEnwAGnt1GGSo9SwJFaEh7BOEY6NobayhLb0tckVw0WgD9vB2YmJ+9afTtMLacuhONMC7yjZXylkF5RGt4+q2KxnVB0Xnqpesc61lu/ipUie3PjnXonTvo6OJgXAAkhv4Oo+5WKy/KYBKxP8yUo4JhDmkZKrnEkoJ5bslsan
 jWn//TRm
 8B7DWHmsHZFRGev2/h/AjckZy59/8rTXTnNu9jnr6t8f7X6vtdSCgw0tKwalvIt7zVqxvZ+1V4bap+VSe7DuIPKR1kc/pD22nhwitd+JEV0afY3fj6XL7hdM7PJfZXXV0cth/FF6ZhNynosG3po4DapTfTkM2wsodgNNkCcvBe7R4QuO6u1wCV1clBm3sm00M/2e7pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index a7ef65f78933..9c2848abc804 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


