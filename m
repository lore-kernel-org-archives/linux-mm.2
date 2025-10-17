Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE63CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14CB38E0071; Fri, 17 Oct 2025 05:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDD18E0016; Fri, 17 Oct 2025 05:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07C78E0071; Fri, 17 Oct 2025 05:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB0AA8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:13:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B75CD11A740
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:29 +0000 (UTC)
X-FDA: 84007042938.09.E4D8C0E
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf02.hostedemail.com (Postfix) with ESMTP id 973E38000C
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:13:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FC9DE6P9;
	spf=pass (imf02.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
	b=rfrvMUqqGMvFmuJIVGOat1tP4QfyhPLfVpPFDK0atGTAk2YX8H9czrYSWhq2TJ31M29F5G
	r9vxwD9beEK8gtdh/nGHhzgTBueouXsIWW3OpoOz1kmQLPtB4ACZK9Zk78pF4hhJ+nCZx2
	Ig30VaYdhuZHPykpxYiOjNSCJ02WvXw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FC9DE6P9;
	spf=pass (imf02.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692407; a=rsa-sha256;
	cv=none;
	b=gHO8hpnf0eN25Fbcn4ndpnJbQBXurrmxiQZuIzr81sGtCvE+qqlyu7ldF8EAVWbq2viAgN
	J+CPJ/pTusWUSmQdvDCwYY19auSrfYxGqHGWtZO8Sdad48Cn4zcllsqkPmTVZXk/4/6y4U
	6Qf/gAe8LrTaPHAeZThbiEkfA0C2CrM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692407; x=1792228407;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLjmOO9Imra/tK5RPFIsLXDdpmNXUJwWiKD0++d4PGI=;
  b=FC9DE6P9USGnueXbjn6JflQXRdsQ0e6WDEJeJ2GiN+iHAEU2W0P9Vt2U
   1tXLACLwaGKhZgkcAWfYQ6hFnpsyTnDzPzlkc2IZp6QeJkFDkiuab8E5j
   GfUse6ILITwscf08Z8R1oNBCIgU181g7jym5E/Q0MOAbVXCQ4gVcsZDmS
   k76zzsNljRYrIyQmYYCZW6/QMU6+0aY1pkknjQDm6s2yLClPHKERgUa05
   raEhSlkbG8qecVRTzCRvqInBgOo9Q9ad43sV7hkvY1osaU/10vUCFvV9O
   7K3eCfStJucTn6qC+9rAkGtS503H/CxhkrGEQCvk2AxJAjehoH/xx7hKT
   Q==;
X-CSE-ConnectionGUID: 34WEiD14RdejLw+OSOCw6w==
X-CSE-MsgGUID: 7s81/vdTRg+YX02aAeosIg==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5073530"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:13:26 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:6686]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.52:2525] with esmtp (Farcaster)
 id f7639e01-04a5-46cf-be4e-056cd9a79411; Fri, 17 Oct 2025 09:13:26 +0000 (UTC)
X-Farcaster-Flow-ID: f7639e01-04a5-46cf-be4e-056cd9a79411
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:13:25 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:13:10 +0000
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
Subject: [PATCH v2 25/27 5.10.y] minmax.h: move all the clamp() definitions after the min/max() ones
Date: Fri, 17 Oct 2025 09:05:17 +0000
Message-ID: <20251017090519.46992-26-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWA001.ant.amazon.com (10.13.139.22) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 973E38000C
X-Stat-Signature: 9fbcf7yftnn481nyz9qkcedrxd8bfd13
X-Rspam-User: 
X-HE-Tag: 1760692407-40619
X-HE-Meta: U2FsdGVkX18KFfB4OUhgDXol1jCHUEiRvJ5Tlu57FWHZvRtO4/PZG9ccJfqZq3zSgoHKLK/95bb4Hs1J17UDf/06z/KPlw+IuGC6/yT8E4oXwTh3hql45B9q/9uJzOroqu3deitt76FK8XbvXFtJWWKue6NhnHtm09O4uHcb8spbDwv5rkcO0naNtCO2OyWni6LgoiAC177eb2Sb8jtIHYrxrkE1vjqJjX2Xx4ueNNt230wgExB9ygnZ31B2LxOchLjyjzyzvZuFRz7cvsSi5G65kYCUGM5qlyDiEAUAfeEpFSKm6E2yiFAAe06GjRMcDukF/nGzQqPqzaH/HCYyA0zCuojonC58R5lcuOq4BzUhz/5g4S2aCNtDNHJiQrgOsqLfhUfEbetuuKDcIMbFK2CgWN7f5rBGwPDhklKfAKHo1rhTKyP5vhfn/6RYbyKYaHmSNZPVNCNd/NhXTdqalzYad1Q7+dqRMSu4ZMthIlCygmeFATskU1yufIHX4tIEidf93MVkVOl7SxtFghd00tHri/rdTteAvhWOLygkzkM3VwLpBJC1SvLn85elH42IBZD8oaR0qZcr3EtqB2CNz+0+Z44gCQ6mPSW+N5NR7Td3gZ+maMSxW2oL11fIQC5PuawIfWrVcWHwF/+MdP9nMN+NWl18a/kFP58YQWFzk0j7EP2iSnDPIZbHyEE2c8XpIxpNZr6CRbcP8wHV+dtlvMg0goHS0LasUPrF/DByzACJwWsTU2TkAvRBV/5L6A8AoGt/tpIBL/eN3C6L2/LGsz/OSMsm+poqkHNngD4rOt8UmMs/8o7fC6t7a9MVgTJ0W/5yeZHRSybQ1XvUFIw79WpSDesK4t7DFES4e0NwLJNbT4fbPRIiFjMtCetHz+YJS1HrFlba8HhcSRB7bTHK6TvbRgX6W0wQCqH6vjw/ki+kLFwnT14K7lvr10S11a0/Fflneog+1Gbru2Ctuyf
 238RmVIb
 PsqnwKRYXHmlrWy8/k3uMvw/9WUX3nEsHFsEpeiJz0LIVmnnaGPPuyIaoyNBIt4VZYlH0fagEkgIyPE8lfqN7PzKepSNjVfDM9i7SYamJi4lsikDkgnPqPyZXplcD5OBNh6NDCbDdINY09Ws5AIXYLnQPQP2hQnfjkMIqHsvFO6NxO7aq06Z9BdNDAzS+xKYjXxlAbKft9a1VEYaS+lyLicOLWAZkPtwKJwHWCACkVtxB45LsPM8gu+gHu3/at3K7sAudhRoPdWgJQu01Qs+hVWO/eKnNBCux/6+FUJia0uKXAPSoWn9cezn9vhSsm7L08ThlprPJnbsgkYtCQ4CI9mvPs8h7yl/ImbcQqJLNzAlRZz/8vdf6g0KsX2NXXXoo4/GElkbelTsRPIh/lDtSZTSkmE+DPRlWa/WNWMiio2FYBchU7wAZdNC4mpRUyT9N5NvYnMzH7VkfelAw51BBmqCBwzhyoEXiiBTXQRlYR1iaEr/4MJRq4vrMkWtikIf68yX1nrn+LhTc2PA4R8kFkjlKInj9o6BrV1Uzk1CaTo6F9I4e326FbaBlScziF3xHMjpeifeJzY7KrEtXGaZdKB6xuxoXnrdfGNl/e3aHlqjYtdHO4W66I4fJQxW+87f81PNXFn8gf5DCHxq8nxNWUBd3AA2Kb17QJENQKlt0/GBfNRseRyeJyDJBxDfzHLPFGfaL2EuoKEq4uDkWlqBx8B3uEdEuBY6Ji/YiBRxYcS/ud+DNRMBiJXEJ6fexpm5QCwuayfVf7TJN9elbrMM1JYCJUapSNZHTRZvSmqDvjcflZLIbsprWGh8qlAMvqeqW8D4vY0uHeu6/z/PPWMky0RvyJVG9BdEG++X365tdhw2QW6Mz9vk5eOs796Wj9tfcQM14VFnJY1mnQ52j2SSIUiJo7q8RnsHKI9HYtxXG8ZK20tRZ6X4KYTJ7NgQbfwCYYKIDZsf48Qmcci9pS0QoPgpIqFIR
 5Mif+h1N
 m5+NbBqJ9Gzri8VSJOUT/+RoerEp5mFsL4HjA7HCR1Y+AuNMC3JuztUI3AqUoNSfvKZLZYswGKgDZoKz5MLxT0jFI4jfrWq3xpB1u4jhzH/+eC8kncnpK2avpdHViw+LEhIjCgfbBsSFoU0yZZMh8WlmGxVF4m3SWyduyWGAdB+FWoXn9LtevpApnnO3h3adDdrXTlJMLQ1N208DOf4c4EA7JoEsvDaTLVp84HBcjxgdh8cCOria8fTNy2bKjeKiJYKv4pOP4spIbb4wGqBTtjupPGweiTD2Ws6GzmuX2hcOipi+IwEaiKRKrQzemILZA2m/rLD1jVll9lDv5TwJj3QGFXTQyr1tK48B3Yk7+xwFA7H5JOavb/2RdjKLj7oVYhM0uX4w6JlF9mYdvPSqaymq2/84Ydc542pMn2D2WLhFLYnf4M7IYgkDjdACRUs0U7z7arxt7z4uXN4OpIN8uUJ5Cn6lHkx6N2wGaClf/LI5bDnlpcMKFs56Hp1xrRpoY+fvxHdISvjxfq3W/lN3uaYi6gKs2P8Tc1EkyAjtR69Sta7q7+ugtD8zfOtLxeqR3w1+LrB11P8CUUOEI31dXi7+nQH1soYCUh+8umUWpFbMnjVLl65jYi1i/25zqDu/9yxVFQuQ/TiSywdrbvUaAgec8ZV/DQqdIB6E0HKgVrLms3khqg6TA5guTbzpqMPrDf9C6hmeJ9g9Dpregl6eSYnRkuFduRSnvVOWhx3ddvJMUEde8H+/J2PLRceaZlzk9Ef38CO5aFDkCsaKD1NMhRMm3d/AadVUOB95RD4/WIKffHm847bbHcg33Pzc1/+Za3Wuj7HwQzqU8oyMm3H5Ot6QxIeDbnm819T43HV8iBcRFuwcgMURYPUapIlYK0cl8gTw3VrGYH5RP2HSiC5zdPc9g15Xg9gH/mvmsNgJqai8nHLlg+vyzn1JZirEacuMsk6E+8szLVrqVPWWDFaGRJOd2Yi1x
 qB8Ubz4Z
 pyJDy1C4nAsQPb4BR87WSVmJDFvb2K/kBSdG3oyOOsc8e98uZ/DSZjoruzmf4rcoUPNdTiwf22hjOLxzFc7vcM41UYxVYV2ftrIMlM9x+SAeLOsNT66PteATtwp9NaG1DwlMQ/BKvVK3n6IoSJns8RsL3IRAKRhfxp0iAPJKbakhtPoAJvq+GAFFknsbMi8cTZdeXu3crdPClW7hVM+HW0wDJDF1w95WSSgPrUSJt75jU8F357LkwjUqf/5P3lbDHuhyLEvTiA5EpYsyaO4zH7Ym4h3aGI98Ss8CZTVMas0cXWD39L8gG08qWhoBvbh7ipcGMF6V5Rn3/DmvMYSJv3xI4iIL+Ye+mqxjonn5K7XQT+w1GFoT5aQM5BWmkfgcR0t7isJxjC2HGqaTMx8Wgf6yzMNc5+y6ANffkrOG3AFmbYspJ5HUjPtBHNPt8Jc6hoXmcvy5eW/qg07zUTW5f7wEd80JdkX8ObOotce5n6Rz7phAkrLrlHAnfXUrhHIskIKnj86O3XeErA92QMmKlcxltIm7w+LBnQXvoLC3FBtZcBjyiHRVD3Pu8LxwLX1rdXNJBMWuLEzdETdqhkV5HPu6jz4W68dJ5qmrUzERSW+26UY8xHlo/wadt0tG7/qHth3/9k10sofKnkZwcmhV67rTw0xPFw4csV1ogSrTISIP69ZMEG5tjJiqq34rZrqJB2jlbIuVS7YcJmdhsFucF+us8T56M2vT+y/lfoqDDiB5Kvj5QlKkBfKPp+9xk0VHlk1jqHTY1FLga/w1xdzcYBjE3w/z1iV/zkchq+JeyhGZA7b0fjSFpk7mnREyWVG1fC9mVn6HX7Yhtem2CqzsQkXjxaudzPcdeIa8+gaMnzqf6zZNE3fUH5Y2fANNT2aO8yGRN0saeRo3RNJmSQLxNU6117MDROkeiWW7uPB7rbeWQ4+kdumQzIdgh55RI4LPfm4N68IypYGie7uGfJ47fJK79xpui
 zZ9NP52h
 t+2DPd8ha290vOVRulzjl6AVEoYXdFaiwzUSoPtYsMXeElgW8zNW33QQIfQ9UiMWr6YpoUi+6fA3MB0MIP+S6sxZv+LJUUEqpQCZwjCzopYAGuErjwIefI1UGuOXGuSF5H+Ia/1OP1km4EJc5FGqxjSz8FphGU+UX8vYcvqJxYCAJUDMBHNjyIVu1tv/35iUX71SJCC1/dzNfQZ655ZeE0PUcIyg+jiEzol2DyJ/jr3/Huilf3PVfhIlDpslU6/4voT6VBWNn7TzRTJ68GDZfUsL/veIBgFZ7k78kLi3A36KWkzvNyOGjCg/JmQsGVM4E3CoodMXswI8IGPaG1t5KUaFvstSu3kIAIBfD2dg+oBA+4G0/LE176FruqVKRYVMWbqauN7kWDMC2YAQUE9g54RpqWI0kcXccYR2Ye1DVo6pcMWfpjm65v96rJ9PvNtwoPpxRmwiu1T9VOxCURBMshhvCSjPlqFirTlfxv9dFBscubdnNM9swq0VzhvSAd4dp8PD7cmF18bzaox4PWdr8ntvohzAR0g97dk6coWFECoVLyy3QRBfT8izb5UNRMkzMF2JQ77QEnNEFMPHYm9DF1R9Xw1oA0gNlwAL6K4NXlitIkFffdq4zZI3n1U7a4KIdb0UmP61MtqVhVJHgdtKQgpAInzEkBuhBFa5DXcazJzA9a4lnON/wEHLaXtlvwoRRJCsph6CFwkP4jsgDtWO6q3kwhYq90hDKE6pNTGjmbPwk4Ewp+CF+JwdEnGtSRNoCAq27sql2SAESdYPzoHpHlP9LpjCv1PEsiEZg4/vOIJVKi8eHYStNpP6jvFpDXIIK+MDIehT3Xz98UHcMEbdRUvNB+vw88dFE6605StXedLBH5EbtrUwjjKWlpDLCvuKCE1RM6XWoJHb4kb/BXhY/MxPeSikd4XCziMxbCgrcDP6G7FP381HC65wwdzWoMvF882YGDOhpG9BXfwiirWjFepVlEx6m
 RmuRYaAu
 I8QyQhUWTj1ouED/MnUIHuxxOozvNuCGvrixdW0sishkx3xorXWkc1kuH7Rd/6/zeiLOaATZojtRKhWzgc3dyo0fuU+JHBEr8IGSe/zX05oMPCG6LEaNd+U80+W395u5M5JYSm2MLrx/5QX12YTGr5nsiQWiNBeKI8w13rxrD+l8YOgCcNjRsbf4hOaFpkWtZ/CUQHspcic7qAL+nup+OGkjoFXKHJHaJT9eJ5cJ+UskPl+CqkYKKlCxR9hBecAFV2SBm162BhQUkuo14jiH8SeE91jQlW+x/+tVUrrYZa/vF7pYY6o0LqLjcQnQ41qkiKvH6Zg==
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


