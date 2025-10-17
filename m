Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7C8CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53B328E0063; Fri, 17 Oct 2025 05:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC308E0016; Fri, 17 Oct 2025 05:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4898E0063; Fri, 17 Oct 2025 05:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 269FC8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:09:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2DD411A6E8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:55 +0000 (UTC)
X-FDA: 84007033950.02.096F1B0
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf13.hostedemail.com (Postfix) with ESMTP id BCBBA20006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:09:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tUeuE655;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
	b=mqy6I4fD0BoMlcqSJSg6cB2fEA+P3ltvgg65fnfT4IestvnBQxwixftmhhOqo2PM4mpAKy
	uK6FgX2PDBLvDDh4asPaCCuml141PcIDUo/KodsN/DoB9iSwEx2YYLeebumvF8HAyq9aoP
	/8H7T0w1wBmHmRwiylvrqDUg2k7ts/U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=tUeuE655;
	spf=pass (imf13.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692194; a=rsa-sha256;
	cv=none;
	b=GjIfH43lZAfDJI9Gp2eTOvqb2gO+aONBaOnKElvj449GkI2dfcmCL62flbRNEcpwF8R8/U
	xEnT7d55NIBUOb0zl2Q1ib9fIz7AepGvDL/7JDJoar2Sfdmpp4lW0zvP+3i5y4ZCA2VTJK
	f8UuIvxZJ82ZxgJijsX1HB5NWuOFoX4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692193; x=1792228193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jvk2RBzXwrA99Hwxay/jSQlk3gLjsVti9lJHvH/pTPQ=;
  b=tUeuE655DnO2BvvljolDMutzwHyXrzK56nmeqoSHn6nMgYSCTgl+M3Ms
   eD9w3RY61Cdu7KBgrGlr1MAsR7Hm7sb0mRxhJpp5HF25RTA6pit18ng7p
   Xm+I5+ymBA5T/KZeA7KoapmQppflfoitvIp03pZKIA8NYNFkg3ylv/fKJ
   vAVi3OxBGin6Avl55RtfS4UaBxhff/NTUHroIPoW2VMnf8cSGzQYke9k5
   P8W4CWagO7w7/jkMjynMaxA7FR5g0XUWTWkel4nFWWw29YF9Rk+9C9dlQ
   A81k2B6ONLPFo9KIvOBiK/1DCbPgHx94SaqSUnsiqWRNfQSZ16kD+KvvX
   Q==;
X-CSE-ConnectionGUID: a+NhYey6RlObFrKw5WjAwg==
X-CSE-MsgGUID: oQoxSvvuRJaorqC4IO71Bg==
X-IronPort-AV: E=Sophos;i="6.18,281,1751241600"; 
   d="scan'208";a="5073542"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:09:50 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.51:6698]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.191:2525] with esmtp (Farcaster)
 id 86cb7d91-ec0e-46ce-a7ab-81f9e379a950; Fri, 17 Oct 2025 09:09:50 +0000 (UTC)
X-Farcaster-Flow-ID: 86cb7d91-ec0e-46ce-a7ab-81f9e379a950
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:09:50 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:09:35 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Subject: [PATCH v2 13/27 5.10.y] minmax: avoid overly complicated constant expressions in VM code
Date: Fri, 17 Oct 2025 09:05:05 +0000
Message-ID: <20251017090519.46992-14-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCBBA20006
X-Stat-Signature: pshx5ejzxfmide88umanfs6jc97dh41f
X-Rspam-User: 
X-HE-Tag: 1760692193-946182
X-HE-Meta: U2FsdGVkX18UpDrhYuzE02iz4WCRvC91sGoLzxq0bo4HUMkB4W5MJig38Rl65BEiJeNpMqI8qkpTYakp7+6Fw/zYi+feV4pB7Wf3je2JHZCsH6yfCYzRR08Jht0+8lcjlQvuz+hkezS7HZSo74iT8N0ysmdscgjh1GYn1TKmKa206kH88qQkGRV05BsH5O1oDYIs2w/fLLgbcPpJCNzhQ6RkBe1+LGpPO8ORI01dPfV/SQJBYI+Uk7DICToEYuAf1+coJG11mm7Px9fnvn4sM/2OfHV2jXRTeHI0Wbh5mL+Fh7Fzu2aFYXEiCvIyZXeY7hH92UGiBBufBK6GS4zBkoiqjHQlJjf4MP3uQcluZC/zGaVSxOyEfoPGvbz4A5qp6lL97EWKOUxE5qRmEgayZAauo0xzJQsITbZPlBlWmA07jztFMSlX/bdY9p+vK7Nw/LADsk33jhaSMQqzbGMNEGA+4BjhTut91aN1MJEd3f8VPbKMvOlJaBWOsBTlPT/n0GQQJID7o1f3Fq1MEO71zzBn7lVz81yHzjNqg9ou7DvJFMJKRx81yPDLFYptoAKaQtvcDR1VMRlafK9FSPhEjudMzixyCp4q9lJ1rNe4gpj/5aYL/XW7P5OC90nbeb7PtcC4zUBeC5WZWxtltN9y8pZIlkVOs5S/RWyv3g8JUr3e/n2jLc47uiwSWoFFc7dZtay9482R+7iqeaCNeiEvb/AQZ+wqPUDmys+BA3yJ9Crr/UGkmgIGuPaUQjWJbMaO9tEbawwxvTDKnj7qRa06Do0VWCdtDJpjmuEEKGoiZ+TWbox6uZcLy7bu9++JknLmmQTicN7HYF9pils6dnIA4Cs/pHMH+9yBx0KPezGnEC3yyhCrl2fyclmRpuJVSWDKU3ofNulZ35Djo2kj4FOsQfDT0DQ6iNlUl7VzqR+E0mxaXMT565q94ETAa3BkgiUByxKztJpjIPuDdeZVZpC
 0YOv1reB
 1IyPGEw+oti7fkfPM7jnBx5jwX7+z9zpn+xGSIg1lnoLylWdiqyLvKyRdt7zOYQdAJeKwhZIvzytNYGYqHc/dhyZ7tsc8MeCCrXTyqDIjIgcOiKl2TZ7xa3/P5CXMV15TL5BJNz9teaoKS/xyIOx3lzWz40dGQxE6dSPOjOpOjH7IoWCY7ckFvExEz0iXeA5MXdMCyzDMJ+lCL138Uj3gVmmwB3rKrnOlBK361jAI8MdI4SKJ1cBO9RAClnfPApCmrjyK5g0fzxhNORjVwW3MYAv8Tl0MP2xPwCwCmeRYCuPhh7yRN9cui4LP+WuEKYQXSa5suBu+KOAByQHvQ5nLmum/NxJq6ZFVLkYu4Sg1D8ka49rglJzEonrnGdP7M/PX8dB7MuKt/5cBG8E0mqCgI5GcFCDx55USA3O7WUYFHmM9EmFiQp1ZSQTKuGf618ssNNCRnYSvY45Mf67w0t97fAL6MeFwY8ZoPXs143hoJQMlt488baQBS+gVYXehb8HCClgJNnt7R3BvLMCJ9IpFxtKDbNfXF+ZlUoo83kU1JjzrdjfxTHpl/Sb32+2iBcx9hGbThVPWPRU8hnEkIYFapMgE7mi+qRKzNYhXucf2fjLoee/nOGCFJKEw19nknaslVmjnqD1mAtHpZUPAN6Tq5ixLaxFt1Pj1763mkvv6SJVN3njc1oPI/H6u9Ot/CFEw1ZVQ4j5IsZ7ovpMey3rYx+WbIRIWvHOeGimY54UVyVIl/Ps2tMaqEG1rtpofYYuztGtBEjYzri9OGIQtVhV1RWg0vni18TKY50ke2cQajXGSzDsf/exL9ViaRT1x+gK6wgAh5lZastmEMJGWu+3hhYnjyhSlc33XP6/DclNgveL26ZBch4ksKrrNZLbcPf1eNrDNrGW8tzEpuW+iWf7SLmwpKxVk++XGbTYN43eToEicIB8wFzvCZUJ+/SSSutw1AalVyiGQv1wcqn0AWaoM/kVPV6tC
 ddYM9Tt1
 aWERtn629mskDH9A4DkpPA3Wl7RybidnaSyOpHZEr+Y5d4EjB67bDHSMqor9DU+lrorMde8ZCw6fUe9MaItvS1TOvslEk0ysXrhkFayeXUs8KnyUBCEVZN4i+8Oh0q7NXwi42zLcFLuav7A4w8V9Ddoh6m3txNheevomJpes3sXVv3r66OJwyD7hbcaszTPG4yyIy85kpPbZRH1MVxtNCFofYcKgdmUNRP2r4GFdA39gHpIl3EmFiWpGr6CTWIEzq1wV0stdwtm5fVPdYjl3tQ+hU2O7DbZ2d4mJyqsiz6XUIAlqQyJqkjvy+AMQprVqCj7ojRxYvWApjOSyy40AtNojWdWuljjkE3oWcVCRYmvXHpuyFInimCVjeZBCj96yl7a7jKVfm7dAfwYnLwOw2xzFxAnl7O4hWjq8tB/INS/qNijSXmjD8IL61+xploKt3IYlLwTHgJm/8Ru8AeViH+aRI4xCBHQJT0STyoTlRB2tlB3GJ4QtQeNDiYOGmHPdURLvZJlHh/j/9d7MKBrjKNNg7u7VETSyldgRCIASWVfCA5N4u+wG8YsjzZvyqiUhbhWNHkMyhJUqpRuU80wsDUh938sNsuOHLhJTB78b77gU/z2uXBpOu8rtHFgIHfPOwBYZ6sXhL+4Gtz8jI+aXS7iFFqe40+P7HcVPgduAMWo2rcnm9Grn9Onp8wo1Igdng1DKzrdL1ZZpKCtDMOARdW2l3fHYcSGWQDLTSFuEodx937+DuwqEEx7p5tCQyKTlgohJdrkG5b85K0vIvq/Gz6zNp5qDyGkpjh20uf1AisIaL130rV+8ILKmMnQHynggnc99G8haeLuk+JZzd+MHNIMwyUaGxnIbQURebvV3BWzkH96xGV4B+ylk2WgqnnhusGjgXfy+ixRUYIyWYZSNSilxqCONLaqsBhsTnevzlCesOGTQAz5L9cNa+DaClH5arzPcInnJM5C49887T05eleS3AaX0s
 qBOkkyNn
 UDHrHJwVmMy2MVt4Y5/IezFDnbyZwdUlDMxcQ/TjWMAov61dvnxtis7SF1SuoMon2dPqPZ6gdCkZh7h4I91U9wX/WSd8wBj4PjQGhLorFKM1AdAT7bSoBylwHNWNPT7m043QEgNUwg9lnDpBHTtdQ48ci4qohmfWvOI2GcnbLT5bS+v3qNKDOXpLNTqq7/DnlQWjuTF0fNUOxDGN+QF9YEdq6bBM0v4apwghtjQVqGrrdr+vEwwz6zubB7Y4C+qgr7eG4iWhG14Kwr3wPJ/lVCZzmhwqnqu0Hor+r9sc3za9fwYd8DgT0ZZX8SqIujS9WQGwKk0Mqh4DWa2f2GZVs/esC2ul3JzkMqZJ1EFpyjlR/z9l5gPNVlaKXUC96OqQ/hUyTr0sz3+Zdd2jTZHrIloxCccKPcZnjjZIB5VjbpHYH+KNpbU4ho0k3eBRi/foHh+IjKRbi8qlaTHcseQCqxaOUnRWztxWqR4X1DfxW2iBXcIZc4k9h8jZXwhDxmh9Vz9nCtnEZmffP5/hUqLe/aoUCNA8bU173foXXbZfMUoJXx2NJRbkUdu9XSSy9uEPQsBVXLzBsO6KtSEkIozuMZGAlhvHI3TxsQmqNg7kERyClaxEvZ4JLAuYUUwbzQ7WUraZJ5mQYWpqVppb6b0vi1k6IF3czRFtKHFjsfUvn7HuQiJ/VhGu2z/A7ddkrKXS4a8tTqKlvs2Opdi6Q6hGqjpFK618umvYXMY9kxIki21EMp/az8f3ccsvZmM4gWITThfkgKmkz2P7xCN30VKNsdqrEbJhGZ6G1L+hZ8hlNX+qpSq7fGMdlsT57hqAIASmoBXYVMurM1rY8QltRlGfXa7fl9U6xt42YBfoK/fzq4BVdjATSiKag641623IKjUpN5JT662KQz1zMWZJvZXGIXi2OH3OKcdwF4L9FADp7lioRZOJBhuaGKwGEaxG6X+M2H/6y+mGT+eCxccktX/u0WR/Uqrfl
 4mqIDZ39
 o8ahL1RtwEw8poaqIqeA2vOIOeBj0cKN6kZhMQQcxVVtjMW8WwV0gjd0oU19bPbSPlIIMaYNcHSWpR+LtVCeUJ9mCzkaWqs+J7wZ9Afws61y9O0v8pyj+Ic2SpTOmMDh43bYOJ5RNc2EWKOyNBJNVHn1JABhqPuiYGX4ravcnFtGSIu2g9Phx3wcSbHC5NmlG5xQhoKZda6zqiuYAEh9b+qNcOqUTWWaHMLFDUfIbJTeDwIdi0XkqFX8uZY7eaEATaFNw73dQf+CWKDH5UGxkhImFFjppsUNTXyNi+giPWp/1Ph/S2DTNnQT+5iYvhuzY/yYCRRzXAEJism+MuEwI536cRyKo0zG62UgC2Y4ffC+sjpl9omLgNeFjCtGccW+FckzP8ph/KN0oH2GMEBeGA5Asp64TjogCL/sL0hEYXyza+f1zWIaZi16a37fRJqONVdfkLDX1V2tAq4qn7CG/BiMTMkEidZckA5kv3x+3Y9yCme4ZFtvxrffWeJyeLCsFhc5PWM5phuAiPK97FoQTap3kUFIgtBAx39Hasbej1l6o9sUt6y1o2lO/Zi407iy5z4a5ooMYy7/bCfYFSTJ6Mm7CVPXNZG/7HlHclDtNVQQtZfq8xexY5lfkMZSGb3Fj3RcnS5MhffM6FqaW6QAKm71rS/FGSnS0YGaQIY8JimQUd5YjUJuTG7Btl97oN3tYlWrArlpR4q94l4X5xDGGWclCJT2DeZd4gWMCFkapwz/s5UXDsdf6QoxFhkYbacdIw/2vKflRXlbiVLSQ/rYVINQWOGoIrDxa764F2vXf1FcdaqvF+cWLG0y/v4QpjJO6vw9tr4cJBwcSLnEn2u2FHnXVYi+/Qp1ZyQERiXdpZ5ZnnIwHoed9zzhTI7rfxaV+RvbN1Ou6k09zTh3jo9oK0Ft2ewcHkTjidvEPmIxibadVymmJgW3OyWyPoxEFhZ7+CnvnKKnjateaopannGQK9N52oDbw
 yEXxCGgS
 mN9KNeIw/AmTZxDiHN++SDCsO1USD1hlUIDghQa61ACTnXfypalTDRNFG8zoCp4dy8/CjDiTgMk0EWl/TbWlweVH5PNI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 2ec559284a9f..a7ef65f78933 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u32 start, u32 len)
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */
-- 
2.47.3


