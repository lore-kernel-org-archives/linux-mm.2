Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BB5CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DB68E006C; Fri, 17 Oct 2025 05:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE378E0016; Fri, 17 Oct 2025 05:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985A78E006C; Fri, 17 Oct 2025 05:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFF18E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50545C05C9
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:12:01 +0000 (UTC)
X-FDA: 84007039242.24.B796AB2
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49D54180006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:11:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZnehQiHS;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf06.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=3moXzLJSyQ/dZz2jGfKpnuZtYo1rEoSVLmNMtLt8u7pDukyOcGY8fgLu6++0B8BMi60/0S
	HarNYr0cCcbNkHs2Fy5dEll9r2BAcSBTJSJTNUYChmn+cxe4CGJhM9reLXup+XlXmNtWFf
	DS0wCmiQihSKs1BMry4yJRh6SEzANjA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZnehQiHS;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf06.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692319; a=rsa-sha256;
	cv=none;
	b=8Mlf6Jm2yJ0mFiUI03xxUjy+DNswegrWQ47a5Ozmber3rYGkbeXsAcJjHAliWrhos/w3xG
	FeORS2f4c92nB/SS5IzGBadXbmBTUoFYC/AfIOB7XiUjfk/vZd2lr8K7xVEyeBAkPitFDH
	EG4pTvJssBR780/bhJa8QaNsc5iXrm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692319; x=1792228319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=ZnehQiHSGzVpAHZ2fhW6ww0FuckxCG+8mM36B8SaIH17/t6swrvT/H/+
   0Pf6QO6ayy8dEbpgtsFiVUVho7tKffmD/U+UAQ0Gj+qv0stxwiTBelpSM
   jRvdWU/56z+qC8IZfRRsI03sb48L2ZP4Xc/BDVllxnarVdwswQxTxMjdH
   gSKSEOZ7FieG8R0oiIRzpNRnB2sjemHsX926tS/vz0VVExNftqpeF37TC
   ZdGeAOGKLOSgyMB+cw1ngtNyGDtifz2chYX1PRPO0tCU6dUqcY1ZlMyie
   LVNXxGeVn9rj++4ztxLo3vw341c2gHjDAK2krF6dalGqhmok9W/8xpTHY
   A==;
X-CSE-ConnectionGUID: qMLkkpbwSXiJYW/k24lLIQ==
X-CSE-MsgGUID: 6+Ot3sKfRcmDJhoUWJQSSg==
X-IronPort-AV: E=Sophos;i="6.18,263,1751241600"; 
   d="scan'208";a="5073508"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:11:58 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:26055]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.196:2525] with esmtp (Farcaster)
 id 1b11fa41-3c34-464f-a82b-488498e167de; Fri, 17 Oct 2025 09:11:58 +0000 (UTC)
X-Farcaster-Flow-ID: 1b11fa41-3c34-464f-a82b-488498e167de
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:11:57 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:11:42 +0000
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
	<David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH v2 20/27 5.10.y] minmax: fix up min3() and max3() too
Date: Fri, 17 Oct 2025 09:05:12 +0000
Message-ID: <20251017090519.46992-21-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Queue-Id: 49D54180006
X-Rspamd-Server: rspam03
X-Stat-Signature: bed3sfc6keehm9yqkqnogco1n1nma3oc
X-HE-Tag: 1760692319-222104
X-HE-Meta: U2FsdGVkX18f6TlGTcOfj3XmSdTZ4hRR8J2f8MyaxOmdLrVfgAxl1EGn1Y5a84I+G0Sp3XiY7GfeTzMwhXxFd4o77UFBUzMnSJoYvrqcFk7F+BjoHEETLju/F1OHRzqGmBoDN52sKZ5Rqdxgnd3uLIVWoP0+bzAVzH/RzVUgC4kFmRAEOheygIBZZoeULYHdrFkYuyzwFep2qufNETYBSgfdkaeekKSbByXA4o1+sqC9NMWBhPOBo8uuVC64rg07R/32M6DoDqRvl8qoU3PVJNULyOQf9BuOsEFFHWDo/jTfaTFR3Uaqd+QV7Y6mJOhH+0G+qmKA3V0Nerma9TNtU+0G2C3h9/nFC1KQl2ajqjMs0B5oFjIQQ1S3IFE/I91Ao/z/q74fuTJ2rIFZ2kplyVxJS6k2BduA4YQHnTV+LdX5+7aclQsyV0vSjQi7tkEUB2jmif0xq/yUZGMhTQm0UbEATenX9WAtyO9SGD+tevgvuW2iQaSPOPBtO3NIP4zTVoLhHapiBlWIR6TaMm0lQb5pyl7fdJAZj0aiMKESPvPOBVPBhUapPpNPsBtxNFHMY8Xko/3yvM3j4zi2tg8mcK3qLw52BwIp0tGsUT4n+dQl+8eIFSlabvV4vWwmeO+P/vlPlgKh+yEgkFpfAKCLLG7SdQlSTf9xD0zii+k+YCtVlpHQAVcDKewax87dmCDWZZec29Apbbi7jJmdLIa3gxUUWid0NxqkNNThQMLH+8sqHbjbGMiA56w0iG2QA0CwWbMsKqUVtfC/gLG2UgVUIV2T5wI0ve9lZRDStY52E2syWst7fGvyjjlDnIvdWMQLsX3UTmevlzYj5xb8bSzGkom/jK+HY08+/J7isbgnZ6q4jNu+/MDXEHUKK5tyDhscWslrgp6RpV6PZ91+1dQDP+7wh7SqLU1spDlDxel52U2HIv00O+iU24awssVWawgWaVbkRWnP+OeIzTNmLEQ
 JO/H87eK
 JHwWrFrV4kfT9KvLh4SQOeEOQ1iw9Pw8CsWt7TV4eCkNF3GerywiASiwRolVeRdU/lgV7+TMpw9rAvbhRkvNyGeaknRhTBoka8K/AHXxvVEFcV4Z0+7TcZ/9jpzbsC/Lp4XKciy4SMzt1b4vUoBUAreu9AU7tAlRpP6TUpc4wfPnB+eHkU/24B2Uc6kyyRQPmAtQ6cSYMt2wj1uHTO0rKEr1fKIQyug73AhC4AUWqDn7I65Lbwv31S7QQULe2x3J2GR/KtLYVMIP3pW364k8mCjvIdvLV1Vg5BU7VoRcl2+LxJ2t2JxN8mtzdKv40IwHB55FYE+y5aR5NfnQHa2kGwT5nMKSYX0pGxgko7Y5VmCOiP4eWkRViE2u4apKvLKc6DMXZBDhn7cJ6LgaftblS4tbI4PqIQKeK7z5SnVnw32vEtZAlEwqOxg6h80fBtWpDWoYKmNvOh5ENDp/TuOKrcdXBr58QjYVQEpFrg45UZ7oGOvQuGTFCjRm1kO2WHhT7677YnmNKiIu3GV03+Q0AcRnjVRpVXjG/HLFKtlOjbeByvKtFgEfWbMXgceyc3kG+0+QMei7+JG650Am/nB06mtcoanm6C0iUeLXHW8vovFsUD9QqSaWH2zTif+f7Mrf5fjl9jBk4U3Ca9VChZaMIlTZJy/muKql4ZxmKmY17AAK3w6/oLQa40+Q/fps1R8zZeAVDMCAbTBXmOz+Fa0PPHhBgPIrmdYuPR8ZUL50fn+4rzp7loy8GH09aA68ywF0d0EL5U1wyWOlqDfM779omD/BMCBF6Dmtyn7R+9E3v78i5MPhoznmx5z8Ex6PVdaHXN7vTfofPugaugHQVCnnY3XUFDPjdWdu1v42FVlVXfAC1e2G396WJDFMfIWqG4XFA+NcLx1bNzd75tlfEsxS+wY2ZwqTUh544wmBEF5vgfBPopuQ3QE0lWOAG/NqG5lgGZPde1wjL9f8ZXa+GWf7lZ43irR1Z
 pYlFGx+r
 /Sfo7y4Ut1bT8qOw1NOA9od3+7rJUXzfSxUlImR0szl4bICEEO8PKwJtWNu5dzglH05e0PXE38He7NyfT15/3NbgMkdwSPCu3mkRvosOhRgGXyR/GSZHRLiPKx9ac/ogFy8YTEViI1IYLAwkNLQK7eYq6OEtAzXyNlmQrrDyq/mCCpzTL3q47IvNPs8fOZSJBDrYiYQTcukRTYEC2tfzySGiqIovIhY2d+5VWOGOqyzM+/hbsOkrZ7uT4YQe23V0fZ2sELT4EAoatQKkP09AP8Ar2tkrkDppZZfHlBblNNvy9q8khWod1WBvqL08trCy+aEMLs0T+3SUfzRW51fT6zU7OD1sSS6h+WWIna/+CVKxdNjV/TZMy+SvFoEsuD3MjT8JLMe/iUa4yBkpWMUUndibzEz2eksHZV5mNzfjwJ5jFtEQtjQEEacZfpoNaiA8OjzfarDFsd+HbDq5i+umJUkqwYugEuTHFGzxWaLWQ0u3jm/fzJtOnc6trD+fERu+9v450U8fdVvTd4AoIw6aclwXTxf3XuGvqikabYTSSxCi1HjPG5aI7rB9lbl+lwMLgOkwrHX8OMPGhDpfVe7hW85QAT/KLA/2ql0oBuzXnfZmFamXC+CL0eWUs6IR5PryR9sF3I2RyPQkkosxilETfS7C0EwNT8IJsNKDs16LZDD9cDc+L5LcefPkQC4v7YczEueV1b2uVJi/pk0wTjJ7urwuVOkA8SE9+CCVzp5KMN6FPB7b3O6eIql5enmIdS6P7ZKn/M0r6xBzq8Cl+ZQj01CN79OswPpPWs6Lem8dnSLqgWr8g/dB6LmsV2Y60vy6F0fEnRMgd0uMGkERxz2jzGWQ16K9RbAKZEAV4xJhP/4UrH0nKRD3OO/JPVEUquf6SXZkdBtepMDnLnP7nSW1f/hYpo2z0iP0LLv6JEDSuy7ldJakFcO3GbtsBMMGDpwSojOpv00tB1NQipsIS5vAuCiOwqgu6
 jBo14wG9
 xxG6meMIlrHoCqciUWPuIFNjBnf9tKhjj4aMyzXMDQv+ju6vCY9OH9TCrOyCMu4R/SWdsllONyHdLNjKhyKyb90h0XJkSbCUBAxJD4cpWQugf5fXm5WpUtFitzvqkjyxprjA1UuZZ4f61qHWIY9X7bKNAAafJz70x7Q/Rkf1/crBKIQJLgqnsn181Vy3AXYG6rMzpCQa0Xvzpq/91Jv7MGXF3N5//vHUeYb7uKiqL0fJEvzaEyuEIbIOqqRSt/PiNMfqnrReBscuJe598x9i1UP3VqWW8KYu95O72Qw2frG7cMWArQvuAo5m487loGXqNVi0olYCtWLUlqq3H5X9hkDK/rqomngG/DOhX4NT+Q7PQx43fC11njj7lpnVNfsX000m3QCqdECqyYS+u4jOdGyPs3u+/n8v4R7jASqW7PnwV4UiXGqQu3MZP3mtwFsRdaKmx/7Tr7+XFsg84QY4cXWEZym4GdbQvJn1zFIl4Tiy1aRJuHcVR6Yyi4u7lQUE53+4smifu+sPcaYA+I3YsXqqpZs9hMFPjJk8Onh4nwLuZNztuuOsJ6IsQY2kgcX2yfnVAN70g7vdjOzLVVgGPW6rW9g/Wsjn3F0gejT7Lr3lxIKHUj33OgoIHEBow10TREkeBDiMp6RyvAPP9YNJfkoraHXtMxBM5KhhXOvaOkFAkrSz5VwdIB3a2luO1fC+wu7gBIurNE8+9WTF8vSBg/n1ipMZwSgWgHvwh21+Bons1Ys743s1X+q0q6S+igXgvLaGi5BvTKhc6uMypgi/Xq+vF/ZrJOoO28IuOQiRFhy5sx3CRKQjJIQ9e9Z4yajcMki6Rp5sjzQ6SZRnvaYX/HhgIX9eeLnYysXQmOjAiQSXktkMeicL3AbbpNP/OXDAdp99UllTZzKQeLYQ4ZlkFTIT2upIv3SM3JUq2oHaQBUPw+ziKKY2dY8DR61ugOmTLxrYoZINigE45rPEwdkgjpqaN/vWz
 vRdvOHSe
 K+LyMqYtgudai3ivCGn2dUHZIsOoPcasPbeZPHrysmOuxWuUY9yvxS+6YqyFWwnpGGWxm8Hfi7nvp4iK7fkv336m5XsosuerzfYl4/dPQkqHNELCdtXGfS1nFRHvBaae3tkJY0dZeM+HIfqeFgFJNmb4lK/tSyAUOXKmiRt+oFOMS3XyfFVFS9G+RpVH4L7oPrmGX8scQYdWK47JDq7TkihtMfX4LjBCJWru91F5c1otn+u+JyigBpVqZUuRG0UL+rGvSUr5HG4JPh9EVZ8BLzZ1LFFg23nklZIp20QUjJ2KSjo49DMVfWsdLmOGkXh3oKEy1mjswZCkF/Q2awcsJWpkElgKflSXWtoVy7xwN3SgFTyIxqfUvZjP7fSd01bSePfMHDvT5P45rBT4rIctYOynWlBcK2YyB+02Bz+AgNMGh4v7tkuW7Fa1xATTdlvFIS8qzHw5EkQsbNjtZuq4okgaZO/ui6P8Att7q5SN3KpPtAguhMlvbJpozpszQco9B2zeLiw1ye/MDWIJsKHYtYszo2Y/YDSVf8ntMtTQCNKEr11Z3x3bSZlMXyCyWL3l0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 41da6f85a407..98008dd92153 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
2.47.3


