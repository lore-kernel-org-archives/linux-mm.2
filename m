Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EC22CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC6C8E0030; Fri, 19 Sep 2025 06:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683B88E0008; Fri, 19 Sep 2025 06:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599578E0030; Fri, 19 Sep 2025 06:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0638E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:18:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8D8659C91
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:18:15 +0000 (UTC)
X-FDA: 83905599750.24.1D9BDCB
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id B773520003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:18:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ifs04hOC;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758277094; a=rsa-sha256;
	cv=none;
	b=D7qqcZDG8qOSDQ1Y1Pv5Pe+jwwcoTQaLH+gUQzbJgBKgjGpAhO1HS9l6fY8S7ssufyacN5
	JSohfc2Y208vZdsT/6EmcWFOpvQRg/C/gbUDdYtbZnTz2AvD5qaxahhibP5Zgop2T++tI/
	8qTlgBbaYd+kY0vlavp6n8KocIGrSA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ifs04hOC;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf13.hostedemail.com: domain of "prvs=35013cc75=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35013cc75=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758277094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BxXd7aLvDai7evuJPWIvJpLyCQkjko3tn6jQCrrWhJk=;
	b=R2yMi9yvBYYnkvMu/ho5wt+bC0LzTHXJl7co65GUJkEg8ZHorYk/F9m9OFUvr74eo2gx31
	G1R3Es2xcMzqrXipiMO4CMpz2Q2g0FrQZLEJCzF4l169nkt8BVwkcEp0lhQ5xi/11WxMFP
	lQOBQK2pBmdP6qCiSa5afpV3iBk0FEY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758277093; x=1789813093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BxXd7aLvDai7evuJPWIvJpLyCQkjko3tn6jQCrrWhJk=;
  b=ifs04hOCFTDYSHs/LVVlvmnfUCejDeSTZGO/sM637yffX3prYNZd2nit
   RlTSV87FA4Z7zwg2U0VFI6PlbqRC3NvgJCU3YJYx67tMhunvKw8ZnQ5f2
   Mf4Udai5vJaVUoMJwgKS/+Vir3ln1dYLIf38uMyKqmVeZn+yC9VZ/ao1G
   MmwAmE9Dh1aowpLPyhbDOVFmF/XulEITk4UnlOG6qJWiOVhxdhwrF83jp
   6wlQJT4ZZf0HEgdcn48TK6DX0T0VjVD0McpJDf/W0ipn1CsGRUtrvTB4x
   sg/PHn/JM3H2MTlQ5sWWZ32Rj4quZbgxQiMeUZZu45eJnBxbatMnS+g2r
   Q==;
X-CSE-ConnectionGUID: jIqyC7qOQMmU/YsQW+R8ug==
X-CSE-MsgGUID: YteI4yn4Q++iTijrRm1r6A==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2367150"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 10:18:03 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:23074]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id 74144341-cb99-482b-a66c-2682d68c7588; Fri, 19 Sep 2025 10:18:03 +0000 (UTC)
X-Farcaster-Flow-ID: 74144341-cb99-482b-a66c-2682d68c7588
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 10:18:02 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 19 Sep 2025
 10:17:34 +0000
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
Subject: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Date: Fri, 19 Sep 2025 10:17:00 +0000
Message-ID: <20250919101727.16152-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC001.ant.amazon.com (10.13.139.202) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B773520003
X-Stat-Signature: urmu7h5uxtan6jn8araytuxdijif9h4f
X-Rspam-User: 
X-HE-Tag: 1758277093-291763
X-HE-Meta: U2FsdGVkX1/SZaRuNu/Bck5ui2PhtsvI5Cpt7uUNc8JAoc3+4cJ9UXSjOVF9V1mRcAFNrfeH0QtqlcxgGP0RfhYVwTQOr9oc8QoWa7+KxQey5BZhcRDedMb0fnjygNnpbOYX3z7R7NUfKiFYKWY/VUsBCirpvdUDnNC8jVUHTWjibgSj9PoK85DuMHyJFbY8Bcx9e74kyDmvyWXsjj+Sw0EYkifYbMcW3Zz5T+tBX76OSwgGSrr8qc/DURJ3jTMTGT2VSCXIUMgSZJyVSnE1KPfarhaBrBLUVAWR3a2PQrGVWcNkDe/LwM/aPdpN5BnfpNoXLoYPx82IrRXVualEBLcwzQAwdWLp59IqaAnXbLqte78hlLEOzYoqMQZ0ulsCHE5LfBNvtPZOaMCa/qUNrV+Ko9alzlplaZAayc1jcTIS4wdb+CuG9C1Lg44pTRJsbZ1VWj8yWxylrA/cpXwfeBbRq8pwrz3mE0vrdQKc+9ntUbzSU/1/rKnsMWWRl6S5xhTqCA3sMcmMBlOmKPr4UH9c4VTkOSd8KrQI7OIYEia4nFm8bkBQUsCwhgai0RdkNIOeszGRx/4LB32EdVSLGsyZXf6kV6gt4rrAihpVOuswVlVC9zy37qdghC82+aBp22AHNRdF/cDK+P6KzXqz1SvZPykcGohUNrAyOh93iFqMBfc6HxsvljT+m6tt8OSmlhxCFoo1Hf3QCezbzkijAkPZmO+sG/t8ZcMNbvH1OABiMIPuus5oXBSkLKVGE6M/skTBzrTzLW5h99NZMI+r+gnWf64xZAib2cpXABC2byonhiQvQV7VymkKpwXZmkVKdczcqyeFnvKm2UZr+rNChWjFF5WaiZyQEmIoydEWQ5DeewOozL67q/1EUw6t36OTjnCth8Wy3gXLGTDwsTxKWgDawEH1x7ldPXmubakyhOKWBOOJ40pFxsnUFUduPwW7y2uz8oYwCAazLfEu4g4
 OpBC98m5
 lk2sYQppb+/hlfo3c2UNl7OZ61UJZURgr9+Z58FVQzR/WSWHZFLjlQwxs/WTP5xQjO66EXlJPHusdG9zeNvCOnQrBNCf2GRoX8mlnGuvG0GoVV+73AhdbLOzbxMEmDNfRufyAkVnG97Vv4/K3BgkuIdOVMy5DCG8uLIZSlsooWFZP4ersFVMtLyd74R52FHdW9JdSOVoZ7wIobrGrHXOpNdHmFtPrbXUAM0y6P93myqSs6ngyEFaQFAA99fMPy3mRC2yrJFapcXqoGPJ+eknyM4nLVaw6QgCpX2D74SiuwFozCEM6/JwJhtxS3M7ydOgTVT8g+xUhMf+yEuyI1lLutx/Yj/1bFkIm6+RpoIRvWkz9rWBsiSm1iBOwutQZEI9PB+MU1YN+R5+uPXglKbDcqAJmXEncTlHzUsyvb3z348kd4urvHRdMDX0L9WbKR5x0x2JuhDlF8VPCkvyHXZnt9xd9jGuBtXnQ+/qN0BE2AFk6QJERmTs1fOwdlJ5cloDMY1trziE/nTxYYg48d+yIhk/NnNQZAx4pRof/J4KNBaTtHlWr8rDVGDqoBAXKp4ADPxv8P6CjAgO8BaospkviWrWiPvnwYQMtkuUOZxxKrhkTmtfLjjIhlqMxswdhtVTCKEA1qwPRKDaY22E0/J+S63O/fjd9FiAvTDvbkRfAUp3X4EYiNak2m8dQ58BDCiMIw5GsoyCgX7sS7Bcne0oByhOP7k2Pi4c1STGOan0VbhxACZ5vyhtvcHbcW9tcsMiI8OJZ2qb0tMKU5lRM1O6TA2wIjwWI2XVnCAiJRjdIL6zXjt1uWNQjuMdV5gecE2EbEF8tBLSnMcal3n75oev2YL8zw8S2vjLy9RYK9ztgac/vetPkV6Hl0y4xsKQwf3I46yT4FOh9HbXKxkKO10MKHlDNf1ivo5ULSeZTC7/0USRciSVH96OaMMAjITD+QMgWAaKiiiIJm271Flk+pJCeAiZkqVW+
 SUOv5B4n
 wGZOcXw3u3D6GmS98a0FzOZDkxBJ0zC4Vm9tIfRo7xUhqN/eM55CxmtZrInr3s9bI36c+gmv9yIPcXBkysiSjL28NASGinLK1mVoYqZcn6nol8s2ZQZosNSOFLtUjQg1byOuEfzwObELOkv6jzVvO2Md5eT5J1DO0fjhXrmZyDc24l+FidM9p0090wDRfUjD577nQPcRmY6kvBMsl9SF9EDa3cQvFKtnVHbZ9POa6pMHkhf+Hp0wFjyqWAZShE6viBdrazSnKVHdkcFUnBeC/wIFT1nDZH3f30eklpeQY/MR2OwCYDJW6cJrMJXNvJhDpr8CsWWQ/2dZxKnDiFj+BXjKBtpeWbKix57UNOjLdlxSfPb68t3I3bg4PBJq/jR6h6mAUlLKnoaBE1I2JBgdaM989aS0UdSvspvWkwrpeRfJaj6H2a+IglPJQhtBH+pXJFjoNA/2po89Jd1SVnZACjhcIETgSuPlywCUcqBd3B+qdPUIXh+1LywsSOD/a396oPFwOzIhFU8bZqJr8uT4lLbFCm/hACQ1Im0yDFop4/uGEeaZ2xDwHEoDbCVVjVt/NodS5i60AIxmeNrcgkhUQXw3QFRpuQD1NJPk+yN1Kikhj/Y5rl47wjxFJgXi4D0CHPeKfaT0uAedExG4DSr3JV0jHm8PWoU+KEa2ek9xI7lAGobZKbPLle4d7ZDIOqaZjpaLWvD8l8y3vX3XnqIrIRWwwNMdzix6vIp72VUTw/KjhL/SeFzEgtHcfEU4x2jmxE1Rm/qyW43q85B1KoewLjs0ee9jlfswE3kwXpuDaLfvEM3MhyWGdWgQuyiP8nIGx2LYOn4XHJ62k0+38i09pDvJ9VoEot1Q/AnzzOjHLB5+jaIwG4M+KDEn29TZMAxdoXaz16Bd1Y3dsYH2sVkCMkD1gczn894xjF/LuxHOxc1vyS39fE0UqCYVmmXCUq4PrEn1FZneZ8bTFij4LhUGuPvoMQ5kL
 ZjjwuNLT
 IouU0723oXY7zuKnTLuv3kA8kKKQCKVWkm3poYcPVIL+DfAWyImos8QgB47Sycg141uf9YOIhbJXIZUQcU0YNnoyvZcH9ltPiZUh+fXvoqX8uEipEsfzR7ZHdNDtsGUF1GHEPWJOdvvyVctEAoL1gqjpBm/kBqTMzs4Ar4b0QLuCkQafXaVxfMseAQsaWmW7NMbCZtyXERKeeEY1Fygm7676HqjFSVTgStInjAjsD59BJR0pzZeN/wIxxiu5wMOSHgCRBCvyP3q9J/xve9pyHS6oVRcf01ObEoj1Ht9jOnTjKL008znZirLU3K61msnZKQ4BqSwFWVlnED5N44V8q6ZkgheiqiNisUpUlGh2XYMWMqB1iUfJc7S2AvAGeVuW21Z+sEzS6t2PH9qL5xC5R/wJsjacXSabB2fbkaPD4apK5+IUbq5cfSdrTRWHUVHwu+R6KlAjVcqDNye3UUXcEF1biJ2/285T3/+9/NH7OsSWQb/k/ooqOq9FvzuyqN6vRXrquGoR013wmkAuugHW1v/DKbWmY1CqobhRpB70ygp9Dex+7UIN0U3fePkInF1dsU2KlumU7xUaes/j4XAPDJrnKK99sEXtZIUNYeLLvJUGhuQ8FOy4CMK+eXggZjJMSbLiuL2dt7GlqpmKIPjI34wHPReloo5MJORCDJOoplcG5Aw8VZytp8mYNGNg3sHAHsfpetxZm+EeiiqRODx+YD7xVv5+yYx772SHEWnddkPshSt4BrTZgtel1Ygd9qKuaRfmX3o5wJxdYiU7v+GJ4KdkghiC7b2FpJXWjIgMNYKS/5jui9nb4s43Up9TGmyGNLcNI8MWAKQlhd3FM1cZxDoPnoM3/xDvNYknmGpDW99kJT+8ntX5pm+ZR27X2WHFbR+/UaR0wvVEjd6OJgwbDAAdau/uxslSoXlBNmhxSPQaABrN7k3iVUbZU0Ki9mDNLnAXk1c4AgHSZP/8bPplOF5mUKFWh
 3UCCzxYE
 zNlK5ny7qQgieRoft1E3Wny0fQPy0MN9fy9Y0elcdZ4YDFuKB2ZHQfz/yzixZHouPTnds+FuCxSNUzlPH/WOHGQCtMADtKeLBd70yW+ZmVZreLzgwmWMeTvQQKlfJO5cOYPdNGA+iPlP3igQ0/6cUgKNdC+YsAvpYh1o1m/lVIUR5Zp4nedynkg27HUTqJB1mQF5WQmG1XGN8BI5u4XhRjLe7iaTUPAs88UoIgWLlDDQ1++xmE7SHWEIXLXzPbeAQQquXnuTLgvmmshBHTzEOU1qqLTjhzc3IhpHkJl+8X8pO3M3AeVySphftsSZKvz14+feyx4YK03dBtxckxTDWVe5xW9MWsDyAiCwJjCeowQi2/dgcu26vIX8W9o8+fh9JF/Sb2haMOvH9uYYDoePuXz3t6K+qPjs+ukUNhpoTdB7MTsQcYRJnAoxK1a/gZ6vIcAlJtrIcL0uL7WF52W/Aln1VDfV+bnNLdauqIpPHm5NdALymPnegM3uNqO95bvJMfo4GSUqeZZLnLo3eGQlbWRvjiY+DhkEiQ1ObqeTDetAEvJuk4llMYOdoZLqRj3h4WWQcESLiXURxhPrJL7SB2mJaIq33Ab4yHpByjKsWDPOH8MujQWDLjqdBPgmKvrEYLeO3cN6tWZBOifEAwSy6gGfcIJmIYoYT3jnjBRMeormBd7IO9DNxoqUgAnh6Obhrn0l7+IczpgYrkW9CzH5Ra/sK2BO6CTVGsc7yi+bJElVKrB79MUxGZgPVPzqSKVeppYHjT1XtckeXyogOvLiwBKBhloULYPQJnZgk3QWmnv0KT4J2CnseXBNhAIG+JR6xzwVzKHnh6XR1XLwIkLr59aPzQZHRc0iKtAVFf+18PVc38A0oNV3ar0ITN9/m2G/SvHqKmqePUVI5/uA3rG4SDZIYZfP4lxZi7Xa1fFFoPAiMI4ig9NRWUg6tAuFGlwkbJTelGUepfFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series includes a total of 27 patches, to align minmax.h of
v5.15.y with v6.17-rc6.

The set consists of 24 commits that directly update minmax.h:
1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() macro
   once")
2) 5efcecd9a3b1 ("minmax: sanity check constant bounds when clamping")
3) 2122e2a4efc2 ("minmax: clamp more efficiently by avoiding extra
   comparison")
4) f9bff0e31881 ("minmax: add in_range() macro")
5) c952c748c7a9 ("minmax: Introduce {min,max}_array()")
6) 5e57418a2031 ("minmax: deduplicate __unconst_integer_typeof()")
7) f6e9d38f8eb0 ("minmax: fix header inclusions")
8) d03eba99f5bf ("minmax: allow min()/max()/clamp() if the arguments
   have the same signedness.")
9) f4b84b2ff851 ("minmax: fix indentation of __cmp_once() and
   __clamp_once()")
10) 4ead534fba42 ("minmax: allow comparisons of 'int' against 'unsigned
    char/short'")
11) 867046cc7027 ("minmax: relax check to allow comparison between
    unsigned arguments and signed constants")
12) 3a7e02c040b1 ("minmax: avoid overly complicated constant
    expressions in VM code")
14) 017fa3e89187 ("minmax: simplify and clarify min_t()/max_t()
    implementation")
15) 1a251f52cfdc ("minmax: make generic MIN() and MAX() macros
    available everywhere")
18) dc1c8034e31b ("minmax: simplify min()/max()/clamp()
    implementation")
19) 22f546873149 ("minmax: improve macro expansion and type
    checking")
20) 21b136cc63d2 ("minmax: fix up min3() and max3() too")
21) 71ee9b16251e ("minmax.h: add whitespace around operators and after
    commas")
22) 10666e992048 ("minmax.h: update some comments")
23) b280bb27a9f7 ("minmax.h: reduce the #define expansion of min(),
    max() and clamp()")
24) a5743f32baec ("minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi
    test in clamp()")
25) c3939872ee4a ("minmax.h: move all the clamp() definitions after the
    min/max() ones")
26) 495bba17cdf9 ("minmax.h: simplify the variants of clamp()")
27) 2b97aaf74ed5 ("minmax.h: remove some #defines that are only
    expanded once")

2 prerequisite commits that adjust users of MIN and MAX macros (to
prevent compilation issues):
13) 4477b39c32fd ("minmax: add a few more MIN_T/MAX_T users")
17) cb04e8b1d2f2 ("minmax: don't use max() in situations that want a C
    constant expression")

1 additional commit introduced to resolve a build failures during the
backport:
16) lib: zstd: drop local MIN/MAX macros in favor of generic ones

The primary motivation is to bring in commit (8).
In mainline, this change allows min()/max()/clamp() to accept mixed
argument types when both share the same signedness.
Backported patches to v5.10.y that use such forms trigger compiler
warnings, which in turn cause build failures when -Werror is enabled.

Originaly I aligned 5.10.y to 5.15.y, but David Laight commented that I
need to pick up the later changes (from Linus) as well.

Andy Shevchenko (2):
  minmax: deduplicate __unconst_integer_typeof()
  minmax: fix header inclusions

Bart Van Assche (1):
  overflow, tracing: Define the is_signed_type() macro once

David Laight (11):
  minmax: allow min()/max()/clamp() if the arguments have the same
    signedness.
  minmax: fix indentation of __cmp_once() and __clamp_once()
  minmax: allow comparisons of 'int' against 'unsigned char/short'
  minmax: relax check to allow comparison between unsigned arguments and
    signed constants
  minmax.h: add whitespace around operators and after commas
  minmax.h: update some comments
  minmax.h: reduce the #define expansion of min(), max() and clamp()
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
  minmax.h: move all the clamp() definitions after the min/max() ones
  minmax.h: simplify the variants of clamp()
  minmax.h: remove some #defines that are only expanded once

Eliav Farber (1):
  lib: zstd: drop local MIN/MAX macros in favor of generic ones

Herve Codina (1):
  minmax: Introduce {min,max}_array()

Jason A. Donenfeld (2):
  minmax: sanity check constant bounds when clamping
  minmax: clamp more efficiently by avoiding extra comparison

Linus Torvalds (8):
  minmax: avoid overly complicated constant expressions in VM code
  minmax: add a few more MIN_T/MAX_T users
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: don't use max() in situations that want a C constant
    expression
  minmax: simplify min()/max()/clamp() implementation
  minmax: improve macro expansion and type checking
  minmax: fix up min3() and max3() too

Matthew Wilcox (Oracle) (1):
  minmax: add in_range() macro

 arch/arm/mm/pageattr.c                        |   6 +-
 arch/um/drivers/mconsole_user.c               |   2 +
 arch/x86/mm/pgtable.c                         |   2 +-
 drivers/edac/sb_edac.c                        |   4 +-
 drivers/edac/skx_common.h                     |   1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
 .../drm/arm/display/include/malidp_utils.h    |   2 +-
 .../display/komeda/komeda_pipeline_state.c    |  24 +-
 drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |   6 -
 drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
 drivers/hwmon/adt7475.c                       |  24 +-
 drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
 drivers/md/dm-integrity.c                     |   2 +-
 drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/fjes/fjes_main.c                  |   4 +-
 drivers/nfc/pn544/i2c.c                       |   2 -
 drivers/platform/x86/sony-laptop.c            |   1 -
 drivers/scsi/isci/init.c                      |   6 +-
 .../pci/hive_isp_css_include/math_support.h   |   5 -
 fs/btrfs/misc.h                               |   2 -
 fs/btrfs/tree-checker.c                       |   2 +-
 fs/ext2/balloc.c                              |   2 -
 fs/ext4/ext4.h                                |   2 -
 fs/ufs/util.h                                 |   6 -
 include/linux/compiler.h                      |  15 +
 include/linux/minmax.h                        | 267 ++++++++++++++----
 include/linux/overflow.h                      |   1 -
 include/linux/trace_events.h                  |   2 -
 kernel/trace/preemptirq_delay_test.c          |   2 -
 lib/btree.c                                   |   1 -
 lib/decompress_unlzma.c                       |   2 +
 lib/logic_pio.c                               |   3 -
 lib/vsprintf.c                                |   2 +-
 lib/zstd/zstd_internal.h                      |   2 -
 mm/zsmalloc.c                                 |   1 -
 net/ipv4/proc.c                               |   2 +-
 net/ipv6/proc.c                               |   2 +-
 net/netfilter/nf_nat_core.c                   |   6 +-
 net/tipc/core.h                               |   2 +-
 net/tipc/link.c                               |  10 +-
 44 files changed, 306 insertions(+), 164 deletions(-)

-- 
2.47.3


