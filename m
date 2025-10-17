Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E28CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8698E0069; Fri, 17 Oct 2025 05:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C689C8E0016; Fri, 17 Oct 2025 05:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30CF8E0069; Fri, 17 Oct 2025 05:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED648E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:11:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50DC111A76D
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:06 +0000 (UTC)
X-FDA: 84007036932.26.0BCF396
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf22.hostedemail.com (Postfix) with ESMTP id 396A6C0012
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=N9BM7bXL;
	spf=pass (imf22.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7swfVbslESxQg74V4Pet/sTVI7N58Kfpf4qGaJIy9fE=;
	b=I+LsYMX+Kk8j7Z476x49PUhohwbDGCzGqfiRVsLOjRBJcqZxs6Eiiolsn9yPIsDUAbaS4B
	XNzoNuZ7NdpXAfiPuNl+ZeVgdCIHKERwOjo3f7NLVfkP+zUvvaj6L8frkCl42i6/lcyLal
	fcC/QmDgz/YJJxtZK2wy/C2Yym4KJ8k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=N9BM7bXL;
	spf=pass (imf22.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692264; a=rsa-sha256;
	cv=none;
	b=z5+EpkFk9cwHwH4BMctfqxG49Kns/JklSIKd8Spraz06ZBImi5WRNbOrKjX6XlbxRRwWnZ
	W4BhOOyqy5wLeMCSWiummBI34nJcEF88fvdYy3mVRYKeKHMYq8fSQdp3svo9h6w1Uue96h
	g0GhUSfJ6Ce0K7BLeMLOz8dN+wDZp78=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692264; x=1792228264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7swfVbslESxQg74V4Pet/sTVI7N58Kfpf4qGaJIy9fE=;
  b=N9BM7bXLgKood1SSu5ss9YYoaLltK6EeNNK/M2Vcw3A508PgNZbmh58M
   2ifHDdDy7+jp84+lKuJoxtaA1EO39QNV6pJx2/dc/9hXhgYNnEXO2h3cO
   K025NaVW4UVWpq3k5GQXaHnb+NeBKHLQbRSWNSb05uH+xuBV/byessSGV
   6jxr3ewiJvdFjV6tsaAkFNhV4apbZCsS12b3pn9IkyZfARYreOu6OVAu0
   2kbzySwT+gKcwb6t1AZ6lpFYsSGCf3zelkqODqcrT7cW//dc9mmbRUg1s
   ZSJG+4pEMPaW2aT63i/IWKToJji9KoR3Jocb5r8PRD1gMPW0sBatFsojj
   A==;
X-CSE-ConnectionGUID: Q5MoDO3uRIu7RKOhofxO9w==
X-CSE-MsgGUID: 0ZVv2KswS5q2HkEJPsaUgg==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="5073427"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:11:03 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:31840]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.18.50:2525] with esmtp (Farcaster)
 id 8605e8df-aafc-4858-9c90-42564ba4b59d; Fri, 17 Oct 2025 09:11:02 +0000 (UTC)
X-Farcaster-Flow-ID: 8605e8df-aafc-4858-9c90-42564ba4b59d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:11:02 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:10:47 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 17/27 5.10.y] minmax: don't use max() in situations that want a C constant expression
Date: Fri, 17 Oct 2025 09:05:09 +0000
Message-ID: <20251017090519.46992-18-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: y99yapwaypobyg8do7cpw89m331nitmt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 396A6C0012
X-HE-Tag: 1760692264-606971
X-HE-Meta: U2FsdGVkX19Uvagug6+j0Y6Y+aNBC1cfJYvDyEk+IcSj28KDUy3P5tbL9RIOfOL/36OnYg13S/9TDfELxCKpEGA3sn7by6Vq1BzscQH9XTwsPtgyMjaaj3rjrjqUFWhToNfiNUJf76rGA9R5vEyMLzT/RznTQcOxUoeXrt8xrL9Fxy4K0LGuROV1YK0xl3f2//QTLtkIznzH2lK0VzVPkOiqxsOrEayyKYGihP13+5uSCo/KUdzxRPZfUqW2eMMoNWNjR5dWvcIs4Rg/DCf2CDIg1bB/Y0KuUErEifdTuaflu5JakXdX4ryETeU7wkC1Xh9YpmGt1DgFBEdgFIEwNnhgC6xGfgW0cdQEtEC8lppYuQj2qQ4PdWaGJwzCrEQOS4USL5s6vjlZU2dA9MWTVCRawgeWWmdlwPbgHRl0QjxP4a/ubLEkChjnuyXwBmlLFL0avt292HsQuQclLJ+g7DriNJCI9cm/cHEWektEet+cilsXjzxBiSJQhsNX/Wa+2YHpxG9w/iKfS4RGd4dqucFPAqEGO+DEeMyOcZqnr9ZTGUc6WCogzrFmFCZMz1A+YeyYOM/xtc3efLP1WJoj7xDsKMS+JAV0CbV2ev9+JK1/niafhxtWFKkP8ZJ5WL07zPWaHOPuy4PhGUFlmWtsZ7dVBkeDWzu5Uj6HHdg5OH+NYgkh2hLs3ch4VIPpm4nPhUyNm4XbvGlQ0c1Q4q8Ls6+VmHOtoG/pqZnYCMal/4PnlzUdAuvttd9XqMb9FdCxZTzBkG3Ai0LN4MfxX73wbu9rw8+rGAisex/pJIBFLIJl1TCnGGfGeORGZfR58537ahDx6JQICtGofoJaWP9tfc3YTjX3QK3vn2llK88mSwBsnjaJkW0LlcpY6p9JBPBjeP2iWs9CEXL4opErooqV1NbZR0hIgyj+lqVAAHLdG454/RUtMBJZo0YIVtGWYNZ1Eeuj2G/D+CrkHP/XtoA
 /k1s/WUk
 BCeYByJMxHtWBlL1BVSKH1RfI/Rpv704MN/9zhZgLYyGO8nlIcUtkm4DOYk6NuMVsOltNgyPGGsiGVyStUQjsZXCcWcZx2Ar7UFfACGXA/7W/wmpEmswOIf4AwZ+50JUMnmZOIx7bkUOcYB/M/ZAm4H8r3Vq3fBLGWRxS3sfQ6lt+AFCGO2OyLV5jgKag8aAAge5W5jg1jTAC8Kq2P+jiIVqkwH5V0rFfT6Vx7gL2sh1t1/h+wXlSWdDhKxay2QFHn9C/NST+cPb1QOzcoLqYwer34JuCBnWyZJvgCB0Ev3uX34pxERUnMB4SByZuvSfRBrRJjLy0Hfhdf1Qi+j5/rWeZ+46LbYZ1W9/BzRCZ/C4xPH84oGaK8mfiPnEIUSHmYzQXoTKop2GEAnokxzW6vFepViV1d8KKRIEB/cFRGN5xAKXImI5ARDBwaBL66IVVJqH0csQMiR6cYXmJwNeCyr8XDdSLYujI6GZeNqBWEqU0I3TH9bbKBIFNju/rVmZgYHYvGdMqf8PNI7PimD9b+5Wat946eOoLkXOvOKOoC/WryX3wkDLuXGZ0aLjbDuZ12sDtLehcM6QnmxnhN9iG0C5XfU1bN9mQbA3lKhAr325inkeUr4nQ4c+rXKsqQ1Ix0UgGGusmS+Jua6ac0mmpAWa4vYXaXRbUMOVL2/SFg5wK0pP1H8yeyD1LMU9juAle0Z4iFUZppUt/hCI/yE0av/VKKysv+n/TbEBiNQM2XXe7zoLLeDf/HVBDz7Ap6sOGFmA/ZsJEC075OrGc5nwk53VCFx2Ilqzkmh5nHwvJpGWjUE5RUUqHkLz0kURWJrEiSYn0xouVqVyih/+x4Rwun0UdZHcv+b5iF2URXoRnEZapoi9vxFaL8+gLG4iOScB25Ma01owOD8vt5Msw+T+JTcNZ0L0xIF9en5DXb6Qd/Z0i7LN340OMe2AYfSKDUJc7GlCOqwSerOvLyQ5zv1CeUR7muBHS
 CuiKY1tp
 ex0mqh5Kvh7R8hByyunW0T+igYu5I0q/X1HDZG1Zu7ZSvGwkrac8+xghPxd7AgTa9mKck7M47DaJpSgAaIVtYwbupcTxRpcf18cCPB4abtbw7Jk0BvSmZiKP2iMtx6OhgNsJgljvOFtKL3OQ6cQl8uDtR9iXcAWAZO+CBxRGrCAwhgmNpzT9kiyAnvm9PV22WDVgyGos/PAFQIxeMO7NaOw8aZdss9GOE11XPr84duDZoNKoI5QeJzMiovoKBfLqiTTj0iWHoUK6S+2IJajDa/fVih6utlZqSrfznpczGNqti5eGZgHLEwNR1Iu+QCiRznoxivy0yaFdcHZNuQKc7A3Vv1LVwLpihroVvv9FTdFWIFkYVvYLkfhLwqR7bQtXtAhFghWgUK4lz/uwcbBN+ClxVF/wAi58EnRAMpwE6Ku4TCSoJaTL1nTKptB0LN8X7qRAVH3mEZ85zLxhrr9I6I8VTXu1UhIMT4/YvVjMHVmXHQrHckJa+qxUrnopVaU8WfCuz9QIHobqYYRdFgNpk6es/B/FICEIzZx2p09sHpaUoeF7dLawFDtnFnCvREW7QbeEXLl9wz4IRYSeWaNiUOUWjVQ2n+Rl5CP03vtJVh83yGE437eq6XMlhD1DQxi+EbR7PNgCCpU6nnjrHyNS+5/ChgfrcVLFr6+SlactzVGIt8HBl6FFts8uBsWULXxeVNT/MXN6d7lFacEv4spiMJlQqHCzX3V2q+MiQPR9hTTFsXamkohQKmY3RhFpzmWtI7mfM//46rFvoapAow5fjOrxuy6YWYtLE3wV2EfRSortzHsN/W6r/i/xDtuQ2uBmleUQuHfbzUMKDtxWZu/mzpJVTfU3ZvrskHkSsUvgQDVSY21XLUWtRY+4ww2UaxavvmivlanJq1FLRnIqECopLDbya7PA1YXOsG9TdpLvW8lCejGNZX+m7heINBqQiDwdWyd6XTt5HJagRiZbmhfS3MlhoGbe/
 wcCbQ/oy
 5NjLzcsvoK8eY+WE5OyJpyEGW7ZK6/ZnQvxXRl7VkkMlcXNFSudIxdG4C2cnsSnWtHZ8LajFYCnYTEtUyevsDCEKifNz2yY4Mw9NvPRHGA7VsMD/HKMoNF61LXIrrgQa7HRJuYxWFMil3dFBtmjAEzisFYNjmV51KGKZX0Xbjm/6tjd6J3BuZzcWzCiOk6poM62bkALuGO06xyWadQABp860LdEteksehomCMirCFnW5U6gGEV6htERl1lBQeeWJVAruXxXdmbOVfesunvoBuaPiaIafeR3BDXu3CNhCGlG+iO9OPA2Ortasmn43G0svK/YEHDxh2t0u8bjdT5wPHlXVtJCfSEdXNTawRoVccn01Spr4qRMwqUo3xmV6D6buEpJ9rww4AMLf/wiyHecyuI7gSi4mTUFggc9D/I3zMnau3VmeCVhdYDPd9mtgAkFhjR1iG503AzRf4buw+tHmsuhTY5PWzqdP05+IyLEmUSitaeiGz3Uda7DMLmXgT0LK/1cvDqYg+NVgtAV+NClX73JM9caDVVzd4M7F3ZBEX7FoQ2mIpJoVbSjx8Bx0kn8/KHtjdYPy/Nd6wge0TSixtV1yjBs1v8iDzqx0qe53NfWRW99CPqmKeARBkCziJn1nxZFCCm4fUTArbrLYqN7CV5gMRfYKLVDgpxNmHO8zLZGAXOqqgCUVIui2PhrgzhQUX/IxHAsYJzF6lt2GD/MLeznRil6hvvNElaTqvmewMCQxACshTBsanyjPUcWVnvT8FqgpJSYuYeDi+yb8LSFcTTj9+XVNttEryoopjoW1rMChYaXj7ZM4jl8PdBdkAH245AgYJL0lm40HbvfBd6+rpbs4Xdb5vvaFwqc3r+lgxposY3c6a90ervecopQ3JUx3sALWErS/V/LxxG7plQSc+vmMURsMo8F3u6IJJZt6mSRFzm5uXqtakG5jivLSnnuAX4cGfq7E9BTAG6hq2absVRzYjJr1T
 a8HD/lZV
 dmQPOpa3c8My91+UBNDXtlZ2CjhkBfaQeYCHZt1f7r3y4NN3VDmJywDvGoBrheJzfRtS7XTbFnGqkwUjviQpFQ162pTMOvq4qIvQlSJR8nUOJrLHfwE48zXRbDexRNzRquWuMtSgV76a0+Orfx92ymJwugvw1gxPDIje3u4+i+lUbAp/MN98LG4JtIlKE+wUV/9Ptfm9v7FigBLYJvvBVsQLE7K23wHxXKsKeV/AGQ+uvORiUotkNyHRJITRHvZPxtTpXQFKPu0VAsY/ziDNWvMAbkDLP3HHbj5DSm4L+n7SZ1HKn27UOYv7xsmv2S4nTV8tZMNS1o+JVotFXZNLiEyT8HIMDf2jvsFUIDPFZgmzb7P4NMRUsqeyohXGTWXlSEnz3gLIhJd2a9EKMHW/hCcUstTfBtEO2OruyG9SKbGDAz3gr1RudtDkWSvY152sZPcaS7xNsF35Q4gIiZQH98KS5uB9tERfkwHVD2is5xZfVd5MzHCscXxdir8j4TTMtLar64RpdeQcBxN7v3mEZftOBnF7OlP0/UrNTtCbwY0x+xAklirx8zECENmv4BO6kXL+2y7BLBdpsZiKToKDF0vyTcgZNehD1Qlp1viosky5JElr5XlTJifmQtI47nRj4CqDHBfV+Ej6Y0nr9IacKz+DX7hWC04fCd8C+azMbFH1cZhK3Vy1UVtSyLfLVSLpJWYwykKD0dJSyQhJHlijOmQQB6i1UyHaPKeIH4niu9KDX6Fr/jrQKQjKUBaLVWnuv628lgt0Y68M5IqGBfVpeomn8utUP2F0aOrbzkkaYIyBYJBwBl/C3M3QYnGZkwEXDEs2rP1yYIEoyEWlwxkn6oE6tkfhjGbIGdX/8kqd7vNNSCiyrErkCR5thrmRTy1OYhCLoBPt2V2deCdCEKiohBP7fUvVf0iTIZ0VxRBxKqgbRcWY9JY2h4sbHqeAX3+0P5b+TJ3xefxuq3MilA0QH2vi/EDnF
 +aggYCJh
 ge4BQNwga/3zeKvPC3ZFIRzNo4wSNjWDVKPJl6/W0C8/ij8wE6b8PdBzwR7JEutNh7NDUW5G7UEKKyzLipvjR7Yv9rVz/B1TAB7YXYg==
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
 drivers/input/touchscreen/cyttsp4_core.c | 2 +-
 drivers/md/dm-integrity.c                | 4 ++--
 fs/btrfs/tree-checker.c                  | 2 +-
 lib/vsprintf.c                           | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index 02a73d9a4def..c10140c9aafa 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -857,7 +857,7 @@ static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 7fa3bf74747d..917ba18be77f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1600,7 +1600,7 @@ static void integrity_metadata(struct work_struct *w)
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[MAX(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned sectors_to_process;
 
@@ -1882,7 +1882,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char checksums_onstack[MAX(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c28bb37688c6..fd4768c5e439 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -587,7 +587,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index b08b8ee1bbc0..90372391ce90 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1078,7 +1078,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-- 
2.47.3


