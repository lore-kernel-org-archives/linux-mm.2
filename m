Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41AFEC5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158096B0088; Fri, 31 Jul 2026 11:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1084B6B008A; Fri, 31 Jul 2026 11:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E8E6B008C; Fri, 31 Jul 2026 11:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCDA96B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:46:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 244F312047C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:20 +0000 (UTC)
X-FDA: 85049498520.26.D9E9C8C
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf24.hostedemail.com (Postfix) with ESMTP id 121AC180006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=RFHLUSG3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="bG9/6JxO";
	spf=pass (imf24.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785512778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AkDiARroLHl6KyOSQsFmxb3G2BExRBvYjwZc5Dx3u/U=;
	b=y4viAx3AMdqKCqvKnUjB/CmQkV4+gffaQGxW+PJUrjuvpcqRXogp2q9Lu8dvfM4NOeSKxl
	i2LatNly58yKhPptzbaMeWds6bJm3aMaE6fGbHBUFFh7Q6LHqcgoM741aCj7HG7T2Xqlc5
	KYLt/l2dCThLgfh5yE4n9Q7cirphxwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785512778;
	b=J5dvWl0gc6jTh59lr49mU5mLJb+pDl5BOFR1FenXDqAcUBbyS30DlI9ur+el91osh7z4QA
	YQZJsC1WRBOXXw1jZjgbnkMxdLlhbwjxUE61Co41ggEVwb5FD2oYnvfycNAc7ujxjxruu+
	jBWD1P4/v+zZHiGsPGTD8l7dWPY8HoI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=RFHLUSG3;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="bG9/6JxO";
	spf=pass (imf24.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id 9142413000F5;
	Fri, 31 Jul 2026 11:46:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 31 Jul 2026 11:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1785512776; x=1785519976; bh=Ak
	DiARroLHl6KyOSQsFmxb3G2BExRBvYjwZc5Dx3u/U=; b=RFHLUSG3nAz7pj5m0v
	XylVJk8tkjr1hoaxgQ0mFWufJPzx0p2SWADqULSGFO5HoobWJA0SPtGAk6x9z0gq
	3uIF8VaxfVWrtTwzObvRNbZ9hmQ6DZ2c7EPmHIfZZY9zGXYTwlWCckSuB164GKDm
	rTsMkCH6xMoNiZ6RHwZ23PnRW8EFxvoOXHxYVvFtsnaxFcng9OyCgvr4tqjtwVqF
	aHyOU1WJdRwo8PyThMZkQ7zeaOlzZ3D/JRa62ESZJxGBZ4el1vpWCGnjCVaBxkQf
	YHECaf0q0fEhuuhKyaLqOIHOCXNvws7mwKQmVqhCpMRhJOGlSaND8vX41gkM0BF4
	n7+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1785512776; x=1785519976; bh=AkDiARroLHl6KyOSQsFmxb3G2BEx
	RBvYjwZc5Dx3u/U=; b=bG9/6JxOSRZJDY2cChKzPa9ZeiM48rnRor5t3NrsCMb8
	h5kRgJOiPdoOJ52BoMWs6XsGB+sPg/75PXOr/kzeMCm/gPrHoJvQ0gaa/BmR/5kC
	MfzkbzeYzQGowCoYr2RyDXLEi29H22Aqp1DZ35j2cOgj0rZyCMonc2YGex+3QQI7
	Obj609QZWbSt2aCn3o54boWpub77yFXlsfRwJPQHUsR3jSsZOhFQt84KIWZA+UpX
	SdstF33yUU2NfNdU+f5BLJzF96alHJ60wFFwtGzOfLmlxfomq0cz6r1Mwpa3qRGk
	6yKRq16FYut9op21eCkHjRAC6A981TCdfQ1vYKlMqg==
X-ME-Sender: <xms:R8NsauG14PDiF0y91EAowugIv_p_5gfG011VB8hQGYlqhrrgjzAocw>
    <xme:R8NsarfFI5UwgKpSRhlkN2BFhQL12ypLEB-_Ls2mEHzDdvE7Z2oCTY0y8iuU4hWhg
    MPrW6OAUsSXw2MNrOyeUbXFfU-8iUZV5lGTrqAif9ihDunyl_aW8EY>
X-ME-Received: <xmr:R8Nsaj_l28J-pbiIZvIq1EqyPW6hbtStWf4noHPWYSebRNwdU1Bv9uOiEpfo98LaUvHEKznXrJVvuuFc3Q>
X-ME-Proxy-Cause: dmFkZTErir1uwCraLLx+asa9zdG1qwL2Ml1O7UA5T9QivlHensOslXjFt8JSOUiAwpktmy
    VFSmVpuJOSFXYJopWtMWRNOMl5jSELFlcHxyT4rlywsBSeC2VFxk4Cn+kaY841TwDEzXb8
    px7AlsoeZrekS5MB8qAz74j8vdnqw4NzWFYwngvmGJIY7BNKRggtYtOI21279XSse6PVdT
    r/6Lq1OfRKHkKuJQG0RneI5XqLVMQwt93YPhCPmyU1+sZpEJVj9WBPTDscuZ7vIF8O98PI
    sVDIkK1S8/MPQiQrzCKk3qqSw9jWPieQwS0n2cc20s89BbP6bkJ/H2uVMavWpSuSNedbhP
    Z+Sr9bMEnWdPL7gg/rJqlcMn5wjJOvSifZbgAQN/M/pCKI7s9NnN4JMa8H02Dsc/p12nc3
    yhrY6s/3dpv1RcFyEz+Bz3ovG3OOeNh8vtPYJmFTU7mv4jXb44aKhOw5SehIowOKK1pOGw
    oYd2MDVMeyuAJlOD2YBZy7TFQfNHyJJTjQMfPgo8TckyOg/wH2tHt9DuAaDMsauisoyoen
    s0AjwcFGF1sGDYq7OkG22m2bT6lKKuQm9wBBZwK1TkQoKOVq0i5DdKz82siVwBRpkdILs+
    HiCb5e8v5+jUQ9o3TqtU4HrOLD19EeN66z2dd33MsKaH1SDF5TV91RO1qUGA
X-ME-Proxy: <xmx:R8NsahbRBxPEGr9aK_5y1jfKNVx8BPoNLPZX3mdyevDAHz0i2EfzHQ>
    <xmx:R8Nsakd7dPE2YwbVZhIICktfRMDSu4wm_LCyz3GCoYdOgi5us0GJuQ>
    <xmx:R8NsavQ8PQYqxpwTYiy_V9wnN-WpJDSYjrJOGa70DpB1kYLpkthx2g>
    <xmx:R8NsaumIMnrmh5xZZjny_dao9LD4GzJkOos3hAySSiSnKHln3kDylw>
    <xmx:SMNsajhHNLCl53VxKStEiVH41dP3Wm4w5aGr0fLkYjgDHJM0QvxbqsJO>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 11:46:12 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
Date: Fri, 31 Jul 2026 17:46:04 +0200
Message-ID: <20260731154608.153258-1-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 121AC180006
X-Stat-Signature: fk61icgmcpa1b18dhjwdb5fwq3frh7sw
X-HE-Tag: 1785512777-94277
X-HE-Meta: U2FsdGVkX1/MLQK0xYilONRIv1iqNrusMxKL9MyZUGyFoS9aYAv9qbL7i091KXCllaoMk3a6wN/GQzhOo/fYZIzIq4MddFt0G5TN5ocUf4X1iK/LOjHxRqGljsT3z+cLoZL/zSL0Iu1mTJMCre7wkS5AHuNQWT6eP4KYWwiU8REPplvyz37gDQIDnosB7vQQwuDgpVokBXfZ3+uDYb20JPiP/41ln2tEzOCmT/lIjqMrL3QMTZvA9HNm05MeHQ1cpMklzeR/ZYNXggX40Iu302wEa8dDwWon9ptpIWOcsTjjY8j9bitmX9WBVp/HlFYFYAflRhE0YO+SWhjxYUehedsdaSkkjQMhq5OPtiRg7awnofG9vFK4EK4iz8lnuyBKq10Bu4nc6VEMXBX+UE69pb4YNheBV2IA9R4/iL1yiNWAEqq4+IXzCFYtkWOiom4YZeb2lSJ2nCqFXbov+UFbzu4U7AsA238TvpU+EzHh/pdIJeAj45FxFlRyr54364BAYaJZGBBqO4dE9Ryer8saGVJlYNVgHBMc+L6lzQlnnrSBffgiBpNj5fEeAdB5oAjR/s7RjGE8jvqnRGUX3HUiNoRgvIJ8FAwk8dfvtW7oDGXmsIwxugqMlTvuwtg6VGjGJNqYBN977PrBqcdgO8WOJGPCCQoK8H1LlXeHd+S5qulqwc6lTZVdIpr965c5bawqCFQj+HXbhBLsL9N7WFisio0RkLO+UeX9CwqYmZstc6ToIhWjisgG9zscm9fYf2bOatNWqC7TlIqPR27A/I5kcxZ6alUxaaQ4XZ5lBH3f1EK4fkz8zQSWl/s5H66QNgr3mxx9DbadD8BX75MzoCmJX6ANo3R/PN9xRPJdF5ATFAtp+RehdRWqA9ttRz1aF9X0BAUXFQb+HhwJLbd1gITrgunvLVjU63NNRF8buL1fPn+fbSscYNd05j15ont7cvkkB3lgF3GOR9IayoowtbR
 eY2jhH1H
 UYyEhITnOWxeMgLtIE9Hsgzx410xYS1G6u6ja2VCODlZRIZ1bnYLRJE22uHewee3s+F3nqAlzT4mDlDdJTwuBp8d+nWpxOJOPvgxmg/h72yr+fPX4rmmTKSpyDPAeUkwLzD28IR3YP5iJfYsDxMdUiOgVP6O+l63xtesvYOAr5l5gPE9YIkVogfnS3TZP8J09PS3q60x1ppYtPXQLzceM19LTQbbKVOF3EFiLwDJxiZ7AxN/i8TnFXmXP37I6rUPf6PgsuxbWoZi+6aeJk4VQXbbqlH/suWug2V/8fKUTP9qvBhLXgcBjj6tz2fUL2WBvA75dPWA2s+IV25wur/UpWE1IaCPcoPIT1eM07YZH90b/ocEMwX/kLJHgiMoFXA+Q1XSHuyj4n4tJ+QSyiUumTAED9GZpImKv6t4ufYdXzMrzo0F3kcPnIpIPMQwSxVH2dDnMbwx0wJqpgREPR8Hbsv5gPaWhxfzGy1QHeBdOR0bd7L6jAH/Z0QHe87ho33GH2hGYO+l3Lxhi5rTjXSBhF3rPD98SONl69GjXL8JXIyTvila6Uy3RRTG9Gdb/TG5UrlkuIDICgnoVZ0siebHfVI1RSaMNDOyRIn2AmFdu/Z0MJGAWRcq9zCzwUQt1CjHQxU8Ur6RGHyk4TpmW4XS461K3dIDQ6TYhy5mxoymmwHwEilc8WVHeYKKFndd77tK27bHDI/FriHKbfarT9QIw18uhKXDlUAnAFg6QSIhTh5xO3tX9uKi90WJCrfWxq5x4yrIFckOohaz19BfqXV+QyqGTi9P8apQYxp8ksC22bh2UvU0IB9lKrMvnLNrqVnp3EFTtdOE0DPbnr+9oi0hBfCHepgD8QpaGV3RrrL4QYe3UtFxIK+i3gBASWvtu+qGpfFMsWPYV7CzeipJBSnuIonz0FZJQUF1Id9amV61CUYp/z2q7NNZh0M0KzepxeWKwLYMdVjHnj5V+EgD7R0uDWzikwVJX
 7xMmd8RJ
 J7tCMoSQVoN4xJKNDBDLAXvtpuNWCMo2uLTh7ppxxwIE52S5/+awYbIMB+1WjPu4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm using linux on an embedded target in a Hardware Security Module-like
application. One requirement is that I want the system to be able to
quickly erase its memory when it detects physical tampering. I'm
approaching that by using kdump to load into a small payload that
instead of dumping RAM, erases RAM from start to end. However, writing
all of RAM, especially on an embedded target, is rather slow. For this
reason, I propose the mechanism in this patch series:

Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
subsystems handling secret data do a quick, targeted wipe of these
secrets before kdump. This behavior might also be interesting in cases
where you run a normal kdump kernel but you still want to keep things
like fde crypto keys out of these dumps.

CONFIG_CRASH_ZEROIZE is a best effort, defense in depth solution. There
are circumstances, such as when a panic is triggered after memory
corruption, or when a panic interrupts some operation that mutates data
structures under locks, when the kernel cannot safely wipe some memory
areas. The handlers proposed in this series will just print a warning
and skip the affected areas in this case.

This series introduces two handlers as a starting point: One for kernel
keyrings, and one for secretmem. Future places where such handlers could
be added would be for example drivers for crypto accelerators. 

The patch series applies on top of linux-next but should work on 7.0.0,
too. I've tested the patches on a Arduino uno Q (Qualcomm QRB2210)
embedded target.

Jan Sebastian Götte (4):
  of/kexec: fix typo in comment (usable-memory-range)
  kexec: add CRASH_ZEROIZE to wipe secrets before kdump
  mm/secretmem: zeroize secret pages before kdump
  security/keys: zeroize key payloads before kdump

 drivers/of/kexec.c                        |  2 +-
 include/linux/crash_core.h                |  5 +++
 include/linux/key-type.h                  |  9 ++++
 kernel/Kconfig.kexec                      |  8 ++++
 kernel/crash_core.c                       | 18 ++++++++
 mm/secretmem.c                            | 50 +++++++++++++++++++++++
 security/keys/big_key.c                   | 15 +++++++
 security/keys/encrypted-keys/encrypted.c  | 12 ++++++
 security/keys/key.c                       | 44 ++++++++++++++++++++
 security/keys/trusted-keys/trusted_core.c | 14 +++++++
 security/keys/user_defined.c              | 11 +++++
 11 files changed, 187 insertions(+), 1 deletion(-)

-- 
2.53.0


