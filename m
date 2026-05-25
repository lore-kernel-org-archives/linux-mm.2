Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993EFCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359E56B0005; Mon, 25 May 2026 08:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B366B008A; Mon, 25 May 2026 08:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9BD6B0096; Mon, 25 May 2026 08:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 088A76B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:28:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C85001A0220
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:28 +0000 (UTC)
X-FDA: 84805870296.11.90B5A3C
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf19.hostedemail.com (Postfix) with ESMTP id D2AB71A0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:28:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=bN3cGPfM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rpV7gPWX;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uKi13XFYGHxE5H01qGt+OAQFTSmA7QCYSfB1W9P9fPU=;
	b=aSSX5x3xF7OIb8UCP5yMAfbVv50dyPvrgxBxqCbChB51VPoUZOgCG0l/sBJSlmuaYxia9Q
	XYlHEgI75OfRqKgyYE8DmULOQUwZtxaKSpwX7UU12jmXWdpq6PeW8xPbRpfwCnn8v56iI3
	mKUqVGL0sSR1/N6Imhb99x1LOrWQbGU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=bN3cGPfM;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=rpV7gPWX;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712107; a=rsa-sha256;
	cv=none;
	b=X2rvPbOOevAkaJk8FUpHmnTJ2c4kf+ED7CL+9G7uLJEhZxqzkqBo+529mc/vku6zTNeg0k
	oloWIPUAbegkqyP1PPaqHV57npMxULKUbaSrwReDZfWAMtkhrIHxrCE3qwmLiAmr4epVKA
	MzqZFzBbWNe/s2zMaz2OvgNfUlc72zA=
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8125E7A0074;
	Mon, 25 May 2026 08:28:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 25 May 2026 08:28:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm2; t=1779712105; x=1779798505; bh=uKi13XFYGH
	xE5H01qGt+OAQFTSmA7QCYSfB1W9P9fPU=; b=bN3cGPfMZYVES6fAywbY476yJ3
	P9lSXcXeTf5jV2vDe6T1/Eff1SJuI7bCdOjxgBrk/vWXjvixRbEruHow8HxZWM29
	A07G6Lfg6TtaYbuOJ/9FYhQtm2N5UUionAmv8ShTMb4hvqTRS5xgwDth11ZQoyAO
	VbeEwN7bHLBxf/eu5JFPxzWo/KEzMV8rj1nwNvWG5XRstZC/oQJtoHY4mUkoIaSr
	ETBM/q047HBPIDLM9oIhOOnl7je07QukvKdKzu1aXZc7eSCLWyFwmjhG96AirUCo
	1/B6rXBiXGVjj5gYATbvrz4+RW/JKoJhVZAGLW5ScLWSMKVEONs71Br5yqdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779712105; x=1779798505; bh=uKi13XFYGHxE5H01qGt+OAQFTSmA7QCYSfB
	1W9P9fPU=; b=rpV7gPWXKhIe/tzR0Fd7CLquFaDRKVi0mG2JTOLIi+QhHDVrwjg
	TDY/xW2baU0lno7tn8Mjn5YmXFJiELXSFH7HJUv6xB//2ukKhh7cv8aPGs8Z/CkF
	/TOjx7QR/xIhzidqJh+y80cyw2WEfuqqcp24s+NS0k852M4nlMZk5gdkw/WtIgfE
	XQfz5Cb51R6oNuSVfGPCnN8x4veYFu1oKIjD1TdIfLRZa5F3Jo2Kl61XyDUIYccz
	nulifsMRfZY7jX3rjBz5GHhvmZ/WAiCE+tAbNslrzpdXVg2mjuaqTsTMbGxROrqI
	LJBVjM3xjg/4W1VidkhqmSuoL9JYvK3Ox7g==
X-ME-Sender: <xms:aEAUanLmR7l9fx3bIVA_DWAakVKOx3travpYLdNyLgo8I9omOVQ-yQ>
    <xme:aEAUattqc_ydspCM_OFxZPIZUy3PC_optL2aLfcz5W-QfUIYb8xy55xFowFXZvlFB
    tny_k1L5XdD1R8bxvNxNzkaeO6wAtrIVvPkmi-BdGGr9tlfq_g0RIw>
X-ME-Received: <xmr:aEAUajUWJyKfE0SX8Lx-4WIOi3LGBx0svI4qzTG9WFf6ifd4M_48iL6vylDRsg>
X-ME-Proxy-Cause: dmFkZTFacEodU23Pdk0BrnjDah+ui/4xWTzU7ZxIne5t6QnObMgxeWaw1jpBdqHrH65bvR
    3j2OVmpM3Co9VT1jokivW+hApewY27NRKKOCJJR23Y7KCp2dD+9tPbfRhPauWWiWZqS3Ds
    b4d+pJyAVvn2CdrJ/DUlt4t447KLZ7Qx9jMHlYiOIUwZBdB9PPCNFwiMilY85HI7F1Ya7s
    bcgtGIeFuD1OTIXGwfw5FW/E61wF5KVcoHQQLepDDOAIA68QFZr/qXas46Q4yHJ2fucxxe
    Ued3s/g8RbDmu68B1/JZYbG9qSdFfTzGoYgiTF4jjgMh1BXcuRf26gpPRMhnEiejxA01cu
    ahVscEMGAW0rR1pQdtj12epYG/aLHDWsROIY05NW5rj/0zOMKVE4C/4SLNSnDV/VsFNDwy
    7xUk6JB2hLDtbBEchHzzjqnSpV8VOm6e7CheKmqVjzlgw/ZkKV6SAU0f18gCBtrJ/6NZfP
    RES8K3KievCDkS/gbf4TYKPlLRRZkrduXacQ5UbSm6rwW3KQJkESV8pJ/Hn0Cf9wAtDHvx
    fz7XnxR/X16RJWJOvk5yFT+9ecAHoHW3g/nscZb3InvY8XQw9J7vVHaMlty/D8jqSXGnSQ
    9s7OoqwGh8tazmnXmg0EdY1Osn4QqYURaib5FQNJjJzoaBYgRscQZNVHbo6w
X-ME-Proxy: <xmx:aEAUagjIACXzwYVHcbntxgARd8CJgEsjLnOlfIivIncmTjYUH7g6sQ>
    <xmx:aEAUajqL7E2AVLp1rrs4AuyShZAdWEBrY_TW7V_jfSisE4dkclHSIA>
    <xmx:aEAUauEZ52kmLobnx1ivGNl6BqwZ7oOE6dqc6bDnDeQ0MJ7eZP0NYA>
    <xmx:aEAUag4nGXu5etLIlSrDsJHRV3MeVO7SrPabzQkXlT2LnPS9a5ixFQ>
    <xmx:aUAUaoA7CSwEOcgIKdu481Xp83_7IauGPTKzuPvd_Yww7o3DFFbP03Yz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 08:28:24 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: alx@kernel.org
Cc: linux-man@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org,
	kernel-team@meta.com,
	Kiryl Shutsemau <kirill@shutemov.name>
Subject: [PATCH man-pages v1 0/6] userfaultfd: document read-write protect mode
Date: Mon, 25 May 2026 13:28:10 +0100
Message-ID: <20260525122816.1956804-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D2AB71A0007
X-Stat-Signature: 1d6eskhbbercx1wqmkdfbkzqs1rbtugi
X-HE-Tag: 1779712106-730620
X-HE-Meta: U2FsdGVkX1/TWPzd7iusCBX11wABDMi2WUayQUYDr6c+151FPbpMpfTdhvdRawOyiW3DVYtHABH+6TUOX3m1THX8KjGvmjeVlmLWd/N490biqQWw/xVfm+Spp3Ex9MVJUQi7NSuXjMO0bLUr9iYjhS5IiLWUNaG885zWAczQQoLb+Kr6uJd3YX594Or8quWhP/AF1vT4QuEeHukBC4qUY+TjEDDdYv5qBPafp6StMdLm4P8tqQyxCUJJWAdFbFyHoWfdgBS0wBo0xp4uV5soIARhoHxiWkazZjn/EESFOGWQBJr7TiJ8YTF8n932j4Qf/nLmsn7RAMz920+zETbQxKpl/18GOT4vkkWQKvsftIcvHUVxHIva+y20u1uR1obOjRtzhWxCuy4Yh28Nu/wxeFgEMNrl3i3AsIWH8Vgg0NdLiVixz+jPXkykfMOMVSkH3zSxr715IM0ytvOqrAeaivoXMOT0MQzdhEq2hSyCFeTLiz1VisueQLnpD4tsFJCgqiDHNML68ssrIMpRK2d1HYxOkZXBk1h1P5JDBxvViSqtzoWx86WbyXAcF8Kni7odOl1Zjt/6Y5ZJe5N6DVQMWnnCo8cPcnEsfeEFVsUqSvbzCf6ELloRkowuMGOIm/txIMGEcX1EMYtpx57Q/1P5orfnMPBkD0jUgXR76lG3uTslG7hMtoUewPe7QwsLzz5o5yER7wU4KM+vEaYevMkDe6plS9PKWtUBQfi5Fztth6luwc84BYtCsbr7fPAyTj2QgdrfvGygfEYXaLaWkwy5kkk9wcgaGeaJWK3IDUfxhfD6mPz0EVqi/o8iznqVx62QXEKOXc92TDCl4yEErDVgfYofF84NO/4o+nzkSwF6w13EBDNkwtOlUG82Ll92+S4oML3Y/fisMwzxqXkBdgNsu2Egwr6R/4+h7OWC6V/nc2ylbEQht4wc391b3vCZZRk6PIIKZSBS11qMp7gk4qq
 nnG86Zh8
 rUTFj1kUz4XbUWcyqDbJSOm76IsR27z6IK2dR1udmUCEi7MBH+qyIMLlaIDgBBsHpQEmqNpEF2FdsREVqz4ed4m/ZpMPDnJcGTtsmLqVj+qDG8QNskLyOuo+/uFvXcgIhegM72vBE4daXwbFOgZmEK3o8FLH/+K/x/HRAgnGrFum3jJg2G2jhRbTtzX5nkCT6oM6RnpfRGM7dQZ7cgOPf79SaFC7wzKKah2JQDAeOW2vzu+i2a1ewb8Gmu2JxRJMG1sZiGhBlsD7VOpbwwpoXyU2yh2DUH2DZu2IUkZQe7/sQ2Dw4cIIevTkwgwX+mjqMcuaVjkkQkWEKBlIWHGUMZMZQS0SfxDXS3pIMAsvC4LGfHTLA7lNxbpj2TuKN8w633kDI/mUjjrxp1rIKY9sJgi2BPf50la1f5qB2ErX4j3qD0A6eUGTLHnTOxZp0OMFmVxRO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series documents userfaultfd read-write protection tracking
(UFFDIO_REGISTER_MODE_RWP), a working-set tracking mechanism for VM
guest memory landing in Linux 7.2.

The matching kernel series ("userfaultfd: working set tracking for VM
guest memory") was sent against the mm tree:
https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/

== New UAPI documented ==

  UFFDIO_REGISTER_MODE_RWP    registration-mode bit (UFFDIO_REGISTER.2const)
  UFFD_FEATURE_RWP            capability bit          (UFFDIO_API.2const)
  UFFD_FEATURE_RWP_ASYNC      async resolution        (UFFDIO_API.2const)
  UFFDIO_RWPROTECT            install/remove RWP      (new page)
  UFFDIO_SET_MODE             runtime mode toggle     (new page)
  UFFD_PAGEFAULT_FLAG_RWP     new pagefault.flags bit (userfaultfd.2)
  PAGE_IS_ACCESSED            PAGEMAP_SCAN bit        (kernel docs only)

== Series layout ==

  1. userfaultfd.2: overview, registration mode entry, new pagefault
     flag, VERSIONS line, and an "Userfaultfd read-write protect mode"
     section.
  2-3. New UFFDIO_RWPROTECT.2const and UFFDIO_SET_MODE.2const pages.
  4. UFFDIO_API.2const: UFFD_FEATURE_RWP, UFFD_FEATURE_RWP_ASYNC,
     and 1 << _UFFDIO_SET_MODE.
  5. UFFDIO_REGISTER.2const: UFFDIO_REGISTER_MODE_RWP and
     1 << _UFFDIO_RWPROTECT.
  6. ioctl_userfaultfd.2: reference the two new ioctls.

Order: new pages first so the cross-references in patches 4-6 link
to pages that already exist.

Kiryl Shutsemau (5):
  UFFDIO_RWPROTECT.2const: New page
  UFFDIO_SET_MODE.2const: New page
  UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 <<
    _UFFDIO_SET_MODE
  UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 <<
    _UFFDIO_RWPROTECT
  ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE

Kiryl Shutsemau (Meta) (1):
  userfaultfd.2: Add read-write protect mode

 man/man2/ioctl_userfaultfd.2          |   4 +
 man/man2/userfaultfd.2                | 152 +++++++++++++++++++++++++-
 man/man2const/UFFDIO_API.2const       |  29 +++++
 man/man2const/UFFDIO_REGISTER.2const  |  21 ++++
 man/man2const/UFFDIO_RWPROTECT.2const | 117 ++++++++++++++++++++
 man/man2const/UFFDIO_SET_MODE.2const  |  95 ++++++++++++++++
 6 files changed, 414 insertions(+), 4 deletions(-)
 create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const
 create mode 100644 man/man2const/UFFDIO_SET_MODE.2const


base-commit: 9a4bfd0e50745c2649b6291db40b58e37c9c1c6b
-- 
2.54.0


