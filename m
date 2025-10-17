Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53050CCD1A2
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3408E005B; Fri, 17 Oct 2025 05:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63AB8E0016; Fri, 17 Oct 2025 05:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92BB88E005B; Fri, 17 Oct 2025 05:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74BF98E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:07:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 268CCBA3B5
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:20 +0000 (UTC)
X-FDA: 84007027440.05.1167FE3
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6B3EA0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XQ+rClRF;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692038; a=rsa-sha256;
	cv=none;
	b=OciE2noWk1p6kX14ImKRsUWslbac6J/rCD8Qtwz1Ucdo/ZeVFuntnfj4CTw7WcHEHNaH5F
	tfB9k/lMV0d/uKdL7B2tTnP3xfU3nzS9U6cCPP4ITv7qagijkJL488Emi5uaWpKEATbaz2
	I2eTmhXs7beGY+Bzq/CRetU2k3qkrbA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XQ+rClRF;
	spf=pass (imf15.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyCE+4rtsA0oj5GYV3ldh81I3wYriob8vp0F6h3lfsk=;
	b=06tTb9f9/Wc2zGDQaDSy532K5y/yq/ifLdrTbxlV7YYbXEpH4YLRJA1PcfnK4W8hIpXnyq
	9gcwoyElhB9UH7wypwCgHwd4C9SWe90E5PKfaxyr0euytQp+wx1DJqTxyaL7S0B/vJZ4Mz
	DJMDuDzIrC7JvQnKPhtmpBnl9qUVxRw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692038; x=1792228038;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=IyCE+4rtsA0oj5GYV3ldh81I3wYriob8vp0F6h3lfsk=;
  b=XQ+rClRFNk/3pbi1wiDZof9ryCs9jwqXFKqSuHuL0H8k7RLZoYE2Mh9u
   Ld+TtGa7KggFol9tPpYPJhe5EzlMPsf985q/OI5LpIMf1uUlgylJfGIzr
   R0SDr5zQW150hSHFBjn8ct6bROmGAFFO31uYLRmR117CBru94PUn7v4SP
   eqXsAN/JjxlAdepS3UFmEN0z/0Ts9wJT7S5TJHTmEXYK/3gDs++kBaTO6
   GJ1tYWcMnhi0vrJqK/NqdNYebBIO6F/WDuwYJW1r8P19sCJa29sd3st40
   9KVdb6nLxwsSFp85CurmEDf44ljj5g2ggkdTYTMBYqWKZS9oVywKkFY/+
   A==;
X-CSE-ConnectionGUID: PBaPil64RkyjQRIyw3fArQ==
X-CSE-MsgGUID: dQOAK5UvTV6Tnygb3yTl7A==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="5073187"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:07:16 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:19756]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.11.52:2525] with esmtp (Farcaster)
 id 06ca39e4-8fe7-498f-b29c-85942ac08926; Fri, 17 Oct 2025 09:07:16 +0000 (UTC)
X-Farcaster-Flow-ID: 06ca39e4-8fe7-498f-b29c-85942ac08926
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:07:16 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:07:01 +0000
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
Subject: [PATCH v2 05/27 5.10.y] minmax: add in_range() macro
Date: Fri, 17 Oct 2025 09:04:57 +0000
Message-ID: <20251017090519.46992-6-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Stat-Signature: 6r3punnnuy6pz41w45narrmg81sa37h1
X-Rspamd-Queue-Id: E6B3EA0008
X-Rspamd-Server: rspam09
X-HE-Tag: 1760692037-861901
X-HE-Meta: U2FsdGVkX1/ThE363xN8VHqkNziDMXq6rGdQ81a1ccHz+CacnNsBFfwUgHDBWMSRK0rI8IfVrZJhvruBMtDgosnUvwPYuzyg0GRhaoHTZuHMgt4SD7rzLyCZVQLq9NBU6c4ZC4UMbzJriS9RCzjPZshR1B+15XH6WX/CWAUzmy/r85I1K9suYAQfxx6pABBG38lzw9rx4PokSN8tVJp7ECr2H9b8rz1JhBxFjooCo45HPRqngUNbpCsZ903J5n6mMTPcrnisw4P7wzUO31LfMCfp2uPzYI5o7KacwdmsP9Dp0jv3m2zk9QhJ6HsszG5XGkQCoGvdbFv01YHI/NJE3lQPaA7sNE8A+Z/rGTPd059e8G1JnBe6lPDBT9jp5Ir1Em2yT98ea1h3qm38bayUu2QnUQpY+BzHShwuZaRrhbjJ0nvO0SP56428Y6gcu/nXar0dhn0vq6+H7E4mxFazKt4VQoEAdD542pUnA6P5WKs8J6e2q8+X5V7RMPAfcnaACWB6AWvtFNBzX6UJFj+2DsFzwQOJWKKTaCa6Y8G9s3dyt01wVDMo41RDQYM67mXMHETA9vdqV5PcG7KYSSpFKo37TKkmzTiNv3T3wFEf2GQ/AdZ7AFFzCxTYuzWDxKQ0q9cMGm+fKEOf/Y6D4pqrrWA/cCfr87lQqdAMFK8QecClaQNBNuQCEHwmr5ZEvxVAdXAIGIJHpJhksRAmwCRYKE1EgXpY+87x9eBHf7sNXYchX0iS6y7hYsQ+jX3CbxnWQnkwlCu0M/GAImJ/TdNiY46dWHoRWPAfLiPwSvzeCS7Ah5VyzyyIc+dSNWCksFyhAMITIkNMFmFPIZqzI3wyIWWd6IkgupOBShmUOxdQI4LOqLig8IagkyFkGIEZA40N4Y0PRwSaJgxTcM0/BdhaWsYuRAQxYx2NC/OqhBx5jS5q8djiqWV0EoFizpDDfchQYaf1o1wdw21Az8TWxAr
 tksq6R8a
 px7yV/VUetPdnXDM8nb+Yq+KqBOum2gvUHrUrCy9kQwoKPbK3jbO80MstbTkoKGZ1YrH/PnpoQUlnrVAf1CMKFcruEp6+QmpUCb1aTTg8EqnyYSvQ7gKHowGsXPs2SFl/fKSK5LLpr09qzLMtUiHPwbeC5it+cut0ll78ZXegKWCWMZCO/zFmYO2ZvUApYEsRbhquVMHJgpn+tilpOy570+Qah4ShBGbne89T6rqdv9R3QqvtCzzcDufeVGymPy1jsfhGyaQ837thZvnH9dQyM3A9uUSdnPZkI92tADSGzc8BcCANAtvci3SvoB6bgvIlDqdPuCkN5wBJtznq6e4F2SZzt/AF5D0NO71RfXvlReJ5t+Qpa1MHbyoInc2OuoLf8isczXpQV6z0oi9eFI9Z1akQxoB5jrqJOqE8MhsMXdbi1LaASUoBO8HnuX7dEA0oJnZKczprCJoaRSdO66YWPZPieqOtHvr6SOrYUr+6T8dj66GKxcNmxcwfgTRtHYqsn+loOCgzRDrS0HctRJzwigLmWX9tj0CY2u6pUku/JsVaKHHOSgEPIrlh3T4d1AfG6V9Tp6ppw7ag4Uzm4losg2MzsmaQ71LkJemTMj/JBe0XV/U5+uSP3KkeUEwgdfVsF/b+pNB7ZZe/OKuSjnIWP551ALLnwuyL+pUl/c2RH/PE8liiaCNcQkrd0wHvSwfXYByT9EfYUZmFAGhHwb4GNG5E27bT9JQPfwvaCOD3cYyMX3asYnsSNwMHOCE7FmuLQ4PcFv++e9pu9iao2GuPRMREiRNj4/1+YXi22PBcYxGgdMnnFh8BDKQuFXItKvMGU9yTjFcDdgIr2QLlRwWlACU40vzxCZUDYvrBdJOyF6koFh5QiYu0fYPjVClPajygoujB74CP9BhbX5ZeFOmjz7PyJx7maw42pQuC/auhsyY6hvqtXvFYWZ+2x1HCZvOQFU6hLKFhD7qEZ4sxvg6l/GyvS37s
 6c1lt48M
 /pNPbPukIyI8fVHjC7YbKW7t543RgueQkv26htYKPYXjtry/Wjrz5ru4D2ApKnSgAU49GbiVAZfhdHVSw7JeLI1LU7WVngzt2kgc3eq2Tl+mDrZwurtV30nPMdd4sguduToNaHXYLm8HuG4D9/57it7gm2/hoxz12GWuuqqo0acKgT0kPYcdYvg2loy8BZvpLeEtt0o5g9tBrm0JV/p8QppqIsU/FgYgblHcHF20E9/vDVT+QdH1BdDBIZAJEj/EKJpvPiNkfvYTKbyPghnpbXMGjyVUK4tbJUXLnk8T2nXRpYcKg4fw+AuR9CQdKBSrhqh/whXVm/io01r3l2DSpQalPfXvwbU5AU5hXEIFEVFRU9UqSC9PT81kEQ6s3TS+l0hOfbjTLj390QGK2q6zg34Ffn8opPpZMYmozIjU6gyBBMEWGJsoZb+dsE2QhSCPi0AqmULUhaQQTjMlMUM6+hNoYLF2MBKVL841Ba0R99/XuwfzAQjEQhlqCBFsf3DNHtR28x6vaAGhQ9Jzn/d9BHO7sJqwipz8ictFOBGOkYnkay14Sp13N0dfkmCqmP0nz8Hn2gL0Dj3l/lUr+bV/OefBNmk6apHAJ0MvJOZyPNj21MzED5plBvzt7m39gpsykp992mitV+rmzsyfpgtOlFXkOb3xXzmvNwOc0StkL/8vdIiDD0GHnrsvqUUtKgxwVch6RRaIqdXsOKU1846/7EioZzVbJoAomIdQmZGg4bRhb6doihk2GBrjoKLs1ohK+yNO0oB4TuiI3uqYTWlRPrVTZiZuT+tZUK3QaDWTMy+JSOxC4zhrBFDuAMpefvKq3DsrcM6JcOF979ZfhKPvQfCh/LQcwOSB7QP60cpKFk5vz4bjz37IsB7K0gZ1MovShNvfilhfAHjh2oLMS81MPIa5ExN0VGaWzjgtDfPH0QAiD3aNREGGugxLUnaJHJJ/YNxQZRGkbR/Trhr4Rn3aB+92Ltkuw
 zt5gD6+q
 Mz1BYpBaO8n53vD2EEIBb0w2WRILMN6yoyCBdMv2vFzEkvp7rL8+hY/5NSXLxIypdW65ZFgimn2RYydUyd/1/fegXV6f+MFrlJWYm4ReatvCe+Lb5WM+b7tWCY5jeJ+d0cxEMAbUYMYgx81q4/MaokWWp4dFw7pLPgvVS0o3F8oapIuOAg66dW6luCZQY4vDXWoKur9U+hlpgzqrXnl7qsdaPQxloQRf2E0+r+LULTlNPVcCYB7jPN+fOmjtR9V1oQ+OH2VRClwQ6L38ngvuL20UqeDPD0KP9rOU0DqrBEJsKYq9qr/ZNThP5JPI1YxzlBJ+y8imA92cncgsNtCk27wbSUFpOquRWB0TNMCCMLioOpN9MZtDToClabWBPDDD1TYO5WH5VvWKthfJuuubHm5JoPd28mY1f/Ff8CCvMINlJDUGq+bFYCkGzLfDQqfl5anGE7lvResWpZRoGcLq+Ut0jAOIJqg0I3KVC9TqB1WRgkWGKkyI5HGkxfGAEdIQ5WoTcLhbX5m+smoU3HqtDLgUGy9mLoG1rTcwNh7wsETZ+nrx7OYkqDJK87cj9Kejc3e8YsQ1Siy82zoJT/5aeY2WL1fKyV/MuQjsBNxgKRc97Dkv1wHNP15w4FtLLb4xq2Vd7BIOPYSvu8LXjJxi+/jnlfEg/4vVVLfBWsZfwA1GziFe7NbSwLnD/lCllJk9po9XbphRpoHuDySJQ8VcMnwImqvOFDOqp7Ht5hrLJ+bWR4l32XHk/GsK+Jxf5g3qAwcLdWLsV9+4qsAnQqpVp5KqV6GmGWfQJu7qgXxsxWx45PVfDJPl3ZIstvG/kcmd0eusw31N0/XuFcm1TUf2FUxqNUKtUI0PpDl0eXnNEmUE40jzSbGM7UztuE6QlRB2vCA/7UH7VmD/ewzrpP1WzqxWfi4u+QjJ/TNWLLI6MZcrUXw6yclKbQv6749j8aALmbhnGrM48DgZwhY9g08NP77/V7YBl
 WmY05owA
 OhaJp6xY0A+mA7LQzRjnGT7sHeTJToKKfK42pRSv9lhvZeugpd01ktOyx6PRQkzSH9uXyaoGxLmqy+JPmeUBHTeESZ+UyBaYm3lYneRa+KBGcsrY7YfrJaFFl6q9iw5OX2uHoejh+lB+yAxyBFC9Yh2/oTOpMtOe1XXcnpSeQ8Eiqs6AEa5PqxvH/NH2QuVo0P91pfgElbMoBUeEZzfB3w1aMC09oEVFeqREVOCyhwrVbCn2lGdejR9+lQ4D6TW0se8g8vQDDs6LrKCn+nQqIx7Mle8+WLyde76Q2Qdtvec0SKo01inM+bMo3OIqxIblEFLh3f555TY+7WaPdDBsFFrSjP/vV3mzcA2E+M0uTGA2KEMZxPpNxyOXZfDJHgW21o3OCLHhEaCOjuBbPPMVl+L8cSxUFKnMoUNwYSGTSAYl6YBRnj3KX1JMEy0iPyNBmrL9ADd/9GJDKx1MT5eqEidHTgozAE2/QCctMNI1mwN0FTh2aQSv8WXBR+ewPznhxss11kzD4YpkR/AFpuPKCVoLyCE4sq8rCjr4hyt9+Y4xWOgwz/qwx60BNn9OeNVq5HERu2MllyYVETZT3WVUv28J3s8hAhHHTDCdM/OFWo5/Vbl7aA8QVlEea+IalPkCtOnajSOFMUocTrFnWzq5uVJyZ3SfgIoriNDPHtCa6sMucWkP3UyHMd1D2Zq9QzOJCYWc/MgSRuTd5XsFzJRktSDC4zUDITTpqvdXtD9L+6ENdDOyunKjOfa8+zjerOZjeo2nwQCAp1MTkXE7Zfwdg00XYSGFN+2xeQ58+IYpKlOlweLlydrSac4casVyB4HpTUGQpjkNkNrM8ZgBdUTj6XXeq8+FB3Flq5MgVilv2DpAVT8A3rZegodLwPkL8CdkjuhncxbFF7rGWRHk1ER20wB9fdDeeRkAnaLx2RKwkkW4xqTFHcWl7D1A2TGNRyiMPsVqHPk4zxpfrPq4tpIt9XTtlNWX2
 QLcm5Yem
 eFvOnbzStdY7JEoSk4eEgx8wjxUvpWhwXDCcP94poGtedo2yY3FsHNjrlfeujh3kHNnkpPZR+Ip4WUyB21jz4cUrR62P0RIcv+8duH0AeQFB8umIusfRNIaNRj0UF3R46DTS31o+F2Nik6w4C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit f9bff0e31881d03badf191d3b0005839391f5f2b ]

Patch series "New page table range API", v6.

This patchset changes the API used by the MM to set up page table entries.
The four APIs are:

    set_ptes(mm, addr, ptep, pte, nr)
    update_mmu_cache_range(vma, addr, ptep, nr)
    flush_dcache_folio(folio)
    flush_icache_pages(vma, page, nr)

flush_dcache_folio() isn't technically new, but no architecture
implemented it, so I've done that for them.  The old APIs remain around
but are mostly implemented by calling the new interfaces.

The new APIs are based around setting up N page table entries at once.
The N entries belong to the same PMD, the same folio and the same VMA, so
ptep++ is a legitimate operation, and locking is taken care of for you.
Some architectures can do a better job of it than just a loop, but I have
hesitated to make too deep a change to architectures I don't understand
well.

One thing I have changed in every architecture is that PG_arch_1 is now a
per-folio bit instead of a per-page bit when used for dcache clean/dirty
tracking.  This was something that would have to happen eventually, and it
makes sense to do it now rather than iterate over every page involved in a
cache flush and figure out if it needs to happen.

The point of all this is better performance, and Fengwei Yin has measured
improvement on x86.  I suspect you'll see improvement on your architecture
too.  Try the new will-it-scale test mentioned here:
https://lore.kernel.org/linux-mm/20230206140639.538867-5-fengwei.yin@intel.com/
You'll need to run it on an XFS filesystem and have
CONFIG_TRANSPARENT_HUGEPAGE set.

This patchset is the basis for much of the anonymous large folio work
being done by Ryan, so it's received quite a lot of testing over the last
few months.

This patch (of 38):

Determine if a value lies within a range more efficiently (subtraction +
comparison vs two comparisons and an AND).  It also has useful (under some
circumstances) behaviour if the range exceeds the maximum value of the
type.  Convert all the conflicting definitions of in_range() within the
kernel; some can use the generic definition while others need their own
definition.

Link: https://lkml.kernel.org/r/20230802151406.3735276-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230802151406.3735276-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 arch/arm/mm/pageattr.c                        |  6 ++---
 .../drm/arm/display/include/malidp_utils.h    |  2 +-
 .../display/komeda/komeda_pipeline_state.c    | 24 ++++++++---------
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |  6 -----
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 18 ++++++-------
 fs/btrfs/misc.h                               |  2 --
 fs/ext2/balloc.c                              |  2 --
 fs/ext4/ext4.h                                |  2 --
 fs/ufs/util.h                                 |  6 -----
 include/linux/minmax.h                        | 27 +++++++++++++++++++
 lib/logic_pio.c                               |  3 ---
 net/netfilter/nf_nat_core.c                   |  6 ++---
 net/tipc/core.h                               |  2 +-
 net/tipc/link.c                               | 10 +++----
 14 files changed, 61 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mm/pageattr.c b/arch/arm/mm/pageattr.c
index 9790ae3a8c68..3b3bfa825fad 100644
--- a/arch/arm/mm/pageattr.c
+++ b/arch/arm/mm/pageattr.c
@@ -25,7 +25,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
 	return 0;
 }
 
-static bool in_range(unsigned long start, unsigned long size,
+static bool range_in_range(unsigned long start, unsigned long size,
 	unsigned long range_start, unsigned long range_end)
 {
 	return start >= range_start && start < range_end &&
@@ -46,8 +46,8 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!size)
 		return 0;
 
-	if (!in_range(start, size, MODULES_VADDR, MODULES_END) &&
-	    !in_range(start, size, VMALLOC_START, VMALLOC_END))
+	if (!range_in_range(start, size, MODULES_VADDR, MODULES_END) &&
+	    !range_in_range(start, size, VMALLOC_START, VMALLOC_END))
 		return -EINVAL;
 
 	data.set_mask = set_mask;
diff --git a/drivers/gpu/drm/arm/display/include/malidp_utils.h b/drivers/gpu/drm/arm/display/include/malidp_utils.h
index 49a1d7f3539c..9f83baac6ed8 100644
--- a/drivers/gpu/drm/arm/display/include/malidp_utils.h
+++ b/drivers/gpu/drm/arm/display/include/malidp_utils.h
@@ -35,7 +35,7 @@ static inline void set_range(struct malidp_range *rg, u32 start, u32 end)
 	rg->end   = end;
 }
 
-static inline bool in_range(struct malidp_range *rg, u32 v)
+static inline bool malidp_in_range(struct malidp_range *rg, u32 v)
 {
 	return (v >= rg->start) && (v <= rg->end);
 }
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
index 7cc891c091f8..3e414d2fbdda 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_pipeline_state.c
@@ -305,12 +305,12 @@ komeda_layer_check_cfg(struct komeda_layer *layer,
 	if (komeda_fb_check_src_coords(kfb, src_x, src_y, src_w, src_h))
 		return -EINVAL;
 
-	if (!in_range(&layer->hsize_in, src_w)) {
+	if (!malidp_in_range(&layer->hsize_in, src_w)) {
 		DRM_DEBUG_ATOMIC("invalidate src_w %d.\n", src_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&layer->vsize_in, src_h)) {
+	if (!malidp_in_range(&layer->vsize_in, src_h)) {
 		DRM_DEBUG_ATOMIC("invalidate src_h %d.\n", src_h);
 		return -EINVAL;
 	}
@@ -452,14 +452,14 @@ komeda_scaler_check_cfg(struct komeda_scaler *scaler,
 	hsize_out = dflow->out_w;
 	vsize_out = dflow->out_h;
 
-	if (!in_range(&scaler->hsize, hsize_in) ||
-	    !in_range(&scaler->hsize, hsize_out)) {
+	if (!malidp_in_range(&scaler->hsize, hsize_in) ||
+	    !malidp_in_range(&scaler->hsize, hsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid horizontal sizes");
 		return -EINVAL;
 	}
 
-	if (!in_range(&scaler->vsize, vsize_in) ||
-	    !in_range(&scaler->vsize, vsize_out)) {
+	if (!malidp_in_range(&scaler->vsize, vsize_in) ||
+	    !malidp_in_range(&scaler->vsize, vsize_out)) {
 		DRM_DEBUG_ATOMIC("Invalid vertical sizes");
 		return -EINVAL;
 	}
@@ -574,13 +574,13 @@ komeda_splitter_validate(struct komeda_splitter *splitter,
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->hsize, dflow->in_w)) {
+	if (!malidp_in_range(&splitter->hsize, dflow->in_w)) {
 		DRM_DEBUG_ATOMIC("split in_w:%d is out of the acceptable range.\n",
 				 dflow->in_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&splitter->vsize, dflow->in_h)) {
+	if (!malidp_in_range(&splitter->vsize, dflow->in_h)) {
 		DRM_DEBUG_ATOMIC("split in_h: %d exceeds the acceptable range.\n",
 				 dflow->in_h);
 		return -EINVAL;
@@ -624,13 +624,13 @@ komeda_merger_validate(struct komeda_merger *merger,
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->hsize_merged, output->out_w)) {
+	if (!malidp_in_range(&merger->hsize_merged, output->out_w)) {
 		DRM_DEBUG_ATOMIC("merged_w: %d is out of the accepted range.\n",
 				 output->out_w);
 		return -EINVAL;
 	}
 
-	if (!in_range(&merger->vsize_merged, output->out_h)) {
+	if (!malidp_in_range(&merger->vsize_merged, output->out_h)) {
 		DRM_DEBUG_ATOMIC("merged_h: %d is out of the accepted range.\n",
 				 output->out_h);
 		return -EINVAL;
@@ -866,8 +866,8 @@ void komeda_complete_data_flow_cfg(struct komeda_layer *layer,
 	 * input/output range.
 	 */
 	if (dflow->en_scaling && scaler)
-		dflow->en_split = !in_range(&scaler->hsize, dflow->in_w) ||
-				  !in_range(&scaler->hsize, dflow->out_w);
+		dflow->en_split = !malidp_in_range(&scaler->hsize, dflow->in_w) ||
+				  !malidp_in_range(&scaler->hsize, dflow->out_w);
 }
 
 static bool merger_is_available(struct komeda_pipeline *pipe,
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 655938df4531..f11da95566da 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -657,12 +657,6 @@ struct block_header {
 	u32 data[];
 };
 
-/* this should be a general kernel helper */
-static int in_range(u32 addr, u32 start, u32 size)
-{
-	return addr >= start && addr < start + size;
-}
-
 static bool fw_block_mem(struct a6xx_gmu_bo *bo, const struct block_header *blk)
 {
 	if (!in_range(blk->addr, bo->iova, bo->size))
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 8a167eea288c..10790a370f22 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2131,7 +2131,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.set_link_ksettings = set_link_ksettings,
 };
 
-static int in_range(int val, int lo, int hi)
+static int cxgb_in_range(int val, int lo, int hi)
 {
 	return val < 0 || (val <= hi && val >= lo);
 }
@@ -2162,19 +2162,19 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)
 			return -EINVAL;
 		if (t.qset_idx >= SGE_QSETS)
 			return -EINVAL;
-		if (!in_range(t.intr_lat, 0, M_NEWTIMER) ||
-		    !in_range(t.cong_thres, 0, 255) ||
-		    !in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
+		if (!cxgb_in_range(t.intr_lat, 0, M_NEWTIMER) ||
+		    !cxgb_in_range(t.cong_thres, 0, 255) ||
+		    !cxgb_in_range(t.txq_size[0], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[1], MIN_TXQ_ENTRIES,
 			      MAX_TXQ_ENTRIES) ||
-		    !in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
+		    !cxgb_in_range(t.txq_size[2], MIN_CTRL_TXQ_ENTRIES,
 			      MAX_CTRL_TXQ_ENTRIES) ||
-		    !in_range(t.fl_size[0], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[0], MIN_FL_ENTRIES,
 			      MAX_RX_BUFFERS) ||
-		    !in_range(t.fl_size[1], MIN_FL_ENTRIES,
+		    !cxgb_in_range(t.fl_size[1], MIN_FL_ENTRIES,
 			      MAX_RX_JUMBO_BUFFERS) ||
-		    !in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
+		    !cxgb_in_range(t.rspq_size, MIN_RSPQ_ENTRIES,
 			      MAX_RSPQ_ENTRIES))
 			return -EINVAL;
 
diff --git a/fs/btrfs/misc.h b/fs/btrfs/misc.h
index 6461ebc3a1c1..40ad75511435 100644
--- a/fs/btrfs/misc.h
+++ b/fs/btrfs/misc.h
@@ -8,8 +8,6 @@
 #include <asm/div64.h>
 #include <linux/rbtree.h>
 
-#define in_range(b, first, len) ((b) >= (first) && (b) < (first) + (len))
-
 static inline void cond_wake_up(struct wait_queue_head *wq)
 {
 	/*
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 9bf086821eb3..1d9380c5523b 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -36,8 +36,6 @@
  */
 
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 					     unsigned int block_group,
 					     struct buffer_head ** bh)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1dc1292d8977..4adaf97d7435 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3659,8 +3659,6 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
-#define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
-
 /* For ioend & aio unwritten conversion wait queues */
 #define EXT4_WQ_HASH_SZ		37
 #define ext4_ioend_wq(v)   (&ext4__ioend_wq[((unsigned long)(v)) %\
diff --git a/fs/ufs/util.h b/fs/ufs/util.h
index 4931bec1a01c..89247193d96d 100644
--- a/fs/ufs/util.h
+++ b/fs/ufs/util.h
@@ -11,12 +11,6 @@
 #include <linux/fs.h>
 #include "swab.h"
 
-
-/*
- * some useful macros
- */
-#define in_range(b,first,len)	((b)>=(first)&&(b)<(first)+(len))
-
 /*
  * functions used for retyping
  */
diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index abdeae409dad..7affadcb2a29 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -3,6 +3,7 @@
 #define _LINUX_MINMAX_H
 
 #include <linux/const.h>
+#include <linux/types.h>
 
 /*
  * min()/max()/clamp() macros must accomplish three things:
@@ -175,6 +176,32 @@
  */
 #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
+static inline bool in_range64(u64 val, u64 start, u64 len)
+{
+	return (val - start) < len;
+}
+
+static inline bool in_range32(u32 val, u32 start, u32 len)
+{
+	return (val - start) < len;
+}
+
+/**
+ * in_range - Determine if a value lies within a range.
+ * @val: Value to test.
+ * @start: First value in range.
+ * @len: Number of values in range.
+ *
+ * This is more efficient than "if (start <= val && val < (start + len))".
+ * It also gives a different answer if @start + @len overflows the size of
+ * the type by a sufficient amount to encompass @val.  Decide for yourself
+ * which behaviour you want, or prove that start + len never overflow.
+ * Do not blindly replace one form with the other.
+ */
+#define in_range(val, start, len)					\
+	((sizeof(start) | sizeof(len) | sizeof(val)) <= sizeof(u32) ?	\
+		in_range32(val, start, len) : in_range64(val, start, len))
+
 /**
  * swap - swap values of @a and @b
  * @a: first value
diff --git a/lib/logic_pio.c b/lib/logic_pio.c
index 07b4b9a1f54b..2ea564a40064 100644
--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -20,9 +20,6 @@
 static LIST_HEAD(io_range_list);
 static DEFINE_MUTEX(io_range_mutex);
 
-/* Consider a kernel general helper for this */
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
-
 /**
  * logic_pio_register_range - register logical PIO range for a host
  * @new_range: pointer to the IO range to be registered.
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index b7c3c902290f..96b61f0658c8 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -262,7 +262,7 @@ static bool l4proto_in_range(const struct nf_conntrack_tuple *tuple,
 /* If we source map this tuple so reply looks like reply_tuple, will
  * that meet the constraints of range.
  */
-static int in_range(const struct nf_conntrack_tuple *tuple,
+static int nf_in_range(const struct nf_conntrack_tuple *tuple,
 		    const struct nf_nat_range2 *range)
 {
 	/* If we are supposed to map IPs, then we must be in the
@@ -311,7 +311,7 @@ find_appropriate_src(struct net *net,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(result, range))
+			if (nf_in_range(result, range))
 				return 1;
 		}
 	}
@@ -543,7 +543,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	if (maniptype == NF_NAT_MANIP_SRC &&
 	    !(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL)) {
 		/* try the original tuple first */
-		if (in_range(orig_tuple, range)) {
+		if (nf_in_range(orig_tuple, range)) {
 			if (!nf_nat_used_tuple(orig_tuple, ct)) {
 				*tuple = *orig_tuple;
 				return;
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 73a26b0b9ca1..7c86fa4bb967 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -199,7 +199,7 @@ static inline int less(u16 left, u16 right)
 	return less_eq(left, right) && (mod(right) != mod(left));
 }
 
-static inline int in_range(u16 val, u16 min, u16 max)
+static inline int tipc_in_range(u16 val, u16 min, u16 max)
 {
 	return !less(val, min) && !more(val, max);
 }
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 336d1bb2cf6a..ca96bdb77190 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1588,7 +1588,7 @@ static int tipc_link_advance_transmq(struct tipc_link *l, struct tipc_link *r,
 					  last_ga->bgack_cnt);
 			}
 			/* Check against the last Gap ACK block */
-			if (in_range(seqno, start, end))
+			if (tipc_in_range(seqno, start, end))
 				continue;
 			/* Update/release the packet peer is acking */
 			bc_has_acked = true;
@@ -2216,12 +2216,12 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		strncpy(if_name, data, TIPC_MAX_IF_NAME);
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own priority if peer's priority is higher */
-		if (in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
+		if (tipc_in_range(peers_prio, l->priority + 1, TIPC_MAX_LINK_PRI))
 			l->priority = peers_prio;
 
 		/* If peer is going down we want full re-establish cycle */
@@ -2264,13 +2264,13 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		l->rcv_nxt_state = msg_seqno(hdr) + 1;
 
 		/* Update own tolerance if peer indicates a non-zero value */
-		if (in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
+		if (tipc_in_range(peers_tol, TIPC_MIN_LINK_TOL, TIPC_MAX_LINK_TOL)) {
 			l->tolerance = peers_tol;
 			l->bc_rcvlink->tolerance = peers_tol;
 		}
 		/* Update own prio if peer indicates a different value */
 		if ((peers_prio != l->priority) &&
-		    in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
+		    tipc_in_range(peers_prio, 1, TIPC_MAX_LINK_PRI)) {
 			l->priority = peers_prio;
 			rc = tipc_link_fsm_evt(l, LINK_FAILURE_EVT);
 		}
-- 
2.47.3


