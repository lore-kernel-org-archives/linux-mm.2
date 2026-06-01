Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 519EECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A856B029F; Mon,  1 Jun 2026 03:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B966B02A1; Mon,  1 Jun 2026 03:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB026B02A2; Mon,  1 Jun 2026 03:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8596B029F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:37:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32D7540530
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:37:10 +0000 (UTC)
X-FDA: 84830537820.06.43601CF
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6659F4000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:37:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=P7Ebjget;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780299428; a=rsa-sha256;
	cv=none;
	b=T+mPYknVEFDVIOz3Vvq35vhQ+zPVVeQu5vhijcyvD7D24RvPYGBNzkA/+9xVwofDI0Gqrf
	gp7on7Ko93Vb6vOnwV/VoHLH2x+mB00DE2CNrEidHhgTF2OUsUigTmqgqdzaV/2/JclcPV
	K40M4Sx/wkulHjpYjNutKG3GWlLZL1U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=P7Ebjget;
	spf=pass (imf12.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780299428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uH0zhOPDX9cTobLGcddQPX+eW4noEIYY0qYKS33IGqI=;
	b=uLB5u9Cp3ztmccUOfEW3i558kFDLl3xjkWKdpm9Oa8sDpg+Xts6aRDEZ8Na8zmXGHgcFSc
	o2LyPLZOfs6753aepCqrO7ScP7ypgf1q3ZLdnzs8geI+Ndg1cbsOTYqhk69O3R/V/VMll5
	fWH9zq1eyq8K3bojyEjbtiJhrwHziHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780299406;
	bh=uH0zhOPDX9cTobLGcddQPX+eW4noEIYY0qYKS33IGqI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=P7EbjgetcYJ8lxf8/rwelB6wbQ7f49xIa/gLuKtCyE8CLoy+zFe0+asCxuwsj5mq1
	 rQsprf5gMLNjcAI9jJj8MSXwxW46YZGVBp6xU/U6DTIluZ0vQHbmZR0YS9vmDbdpFr
	 d4xf2rsEp3KE6NrAYF8xHHE7eZD3kmY4oajgrFAM=
X-QQ-mid: esmtpgz10t1780299400t9453c59d
X-QQ-Originating-IP: KmpJ7xKXL7U5Srup1auzkXsFPcKbcVshfHQAinW5GIc=
Received: from PEN1097 ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:36:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4375497483461457750
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	niecheng1@uniontech.com
Subject: [PATCH v3 0/2] selftests/damon: fix memcg_path staging handling
Date: Mon,  1 Jun 2026 15:36:35 +0800
Message-ID: <D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: M8JnMGwRo1mQwuulEozvWLQ23ukuXx8pXrx1GlqIhTuKO2PJ/0OePTpa
	nUwUHBsPCF6JglQ/2d1Eoxu7YKsFfyVyjloUPNG2Id/AUmS81SuM7ylXZJPcr6/ICkcswDx
	CLLf4gDq0AjA+sNt4orqd227+n5nfp5Pq+A13qFb1LsMreR5U0ZLL+hwENDGPp2MhzfbdO2
	4XUn0UoIWGyYcxVII3q6TU8dPbtFTZZL3e0FPWNMBQS1RcHeBPRWInnIUX5DfSG4F0ycTIJ
	YGk1gWttLzoEmacZm6DQOnL4/j5C2EXIQLQGm8TszHjYnbTQFpYcWK5ZuMzJyyl2XDGO5Kq
	+zNf1lw03awTAJaCH42U9m3/75ECztK4ytE1gQilaERYDeW2yW864ynjCBaSjKKR/RgKbJW
	a6k6VzbC313tksA8iEfCHU3C0Syv+VHl1JNP/DScygidXlP3D89nu0qknpFAv1SONxwNFNV
	fGfOrB2Yv1vY0/ueABRE1PxwP+Mm2xFt2g6QW/ZAP6/wpFXPodB/aoOyJkhRytWYzpd8KC8
	SgkJvKnZI5yPYHeUNB7PBkrP+zgv4K2x+4iv4Ikyk6zxz9BF0Jq7ZNXv2OZabJsddXFqoLq
	nLppWhCxCz1a8dSMqm9YDuznWzjX0VusnufChaTtiNqINd0zJ8N4U6tL7PGT8ZHhxcPEuwW
	k+0Vh5lReggJbqc2Ly5YqlAN9Y6n2/2XCF+0ZRXE1fPGyqEOvpaUxVrdgKlMU/Qh3PzWmNS
	AUEo+oh03MOrPJqGyYaTgcqEcEvw2qDJvgDxVoY8VMOMxMxCbIoEjcnGOIKl6zGdvZPG2dl
	oxfBqsbF5QngFidyG2utNKhAVW+PQzMemo/7HGg59olQhoRl1/AHPg71tjlQof1OoQ5XTBQ
	NU5hC/oBVaEIWvhXcLVCux8m0Jyo1/EFEk4peKLERcTuHo8LrvDsVo7ckb6B1K/aIMo28Xn
	0EjlsSY9Zvtaa5OaB2lOa1ekku5hKIE/ITcDb3Tx+UeRYKBR7GffKbhnzYCFEEgWUQHjT95
	4TsoPPOIqR8B4wZXFvlYDhc0Z/AnDje89sZ7o/MX7BoCz4EtsOgnmuVFonjBkmTQOZ7lmCZ
	A==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6659F4000B
X-Stat-Signature: wrsf5rou6fd1ifnpqjhy856mf6gr4s3t
X-HE-Tag: 1780299425-943318
X-HE-Meta: U2FsdGVkX1+zjr8Q26Y0PztztrQFA8+R/2exd/h/eAK9xL4+wI8Uf1OnBkm1mPv0XcLenZt8r0h80gYx4TgVtFSUgUXBTuq9yhE1pz/38sZ4WYNoChjoQUtIjoyI8WiZZycgOY8JnuVZkdl3KcakjU89VfAdx6UoIXxsTCst8FmZnimfBY1RCr8fmLUunm4HU8/ifxW91DjQC6TH4tgARldxsbqssBvOk3/Io48Cj2HUwh/4rS3uyY7vgS2KG1LCtIgyROckMZyNnXg0RkYQTHWbQhC02u1iW1n8iHnYnTGlZnmRBv0xUMsCI4WKnbskniiYLdkkajD0XtqJ2RVCQ7W7svSs5x0OdfoxXgQDfWvYW6ZJN62SDA/2/to/bG74Q6/tkT5yymS3+IAAiUTggo2ZYxLQyS4SF1FtHH/dykDBzEo8ENvFsJItMRb+e+drKzbRcyuR0tJifNVd1HvjKn0AZQkjM4cPF7fi2VpL5+rudq+ilYKNco0nNbGoKI36WLuv2R1uJntV+vPGSEbOkmE3b9JQB6bZQOUFmLLbNK6mTCN9yFlz1bWK6Bkxj2FB6osXIUWhXiM63qZGS0FGDI8aB7lRzqoTAlbcjEoyIKy+wqQFhWXDnbZ4KAeaBAvY9SoSc/IyCcp+w+8pDVVrx2ydOwCFMVHzVCMS+Nupb7GR2pqXL6Iv2v0K1vLrWq6S01fMErRWWDDdDdNHNX3NIWfDKVPkXTRwLE0Ax4mwFYLAgqTiQfK6llAUiOJKhFVJvNyx+keH2T5Ts5C6kh+IAXaS6/AM5fQGlaQcyiX5in19mw1H7R8UKmuQibK1gRJbKZJCE7iW/lahRYTnCOu6Nm00Ii+YzRaYdV+mdhDadCuob2FfJtI3UJvp4TozflWdbfISi+Wu0zYcLUPgwJTN5m4PZZuPignbh2kN2CUAXhEEPM0qkKNnFXRnGWnqIoPquU3chZMcfiyKkvpqY5L
 J54+Z3tf
 BUK9jvAfzrBg6Iopfr2C047u2SHn5bv0X+pLsY8r0YmbI3bLH8sC+poeK8Cy6Zc1CXqjcm302N10hCxi383bX6U72+SZhHg9QnU4oXwv1aW2KKrdbp0la4DOQU6pmHDzwyikf/T3ZyFn554zPABVUOznjzj78eRbJmuBpVOLlE0koaOOABSeaIYi/1oIF3okar5Ng01HPeOgZnlsuhrMmEujFGYSLPLcXzmRIZZ7lJIjZz/F5uFXZn9L3X1gHm1Y8bxKQNdHC88bvRAX0MPhyaR5tBu0ntM7DySKOGbXlIYvcVu1/9OrEsq/BzIT3AEBH0GHS0JEKWem8+bT+uqMvspWMkSG2QdREAGmLWN8Tcw53Br8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes from v2:
- updated memcg_path staging test to configure the memcg filter before
  start()
- removed commit() from the staging test
- ignored start() failure and checked memcg_path readback only
- adjusted the failure messages to follow the requested style

Cheng Nie (2):
  selftests/damon/_damon_sysfs.py: fix memcg_path assignment
  selftests/damon/sysfs.py: validate memcg_path staging readback

 tools/testing/selftests/damon/_damon_sysfs.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        | 34 +++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

-- 
2.51.0

