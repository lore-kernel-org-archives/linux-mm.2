Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32B24C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 17:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C626B008A; Fri, 31 Jul 2026 13:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD9A6B008C; Fri, 31 Jul 2026 13:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5476B0095; Fri, 31 Jul 2026 13:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95446B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:44:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4842AA19AD
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:50 +0000 (UTC)
X-FDA: 85049603100.24.8C14473
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf08.hostedemail.com (Postfix) with ESMTP id 432A316000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:27:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=hjt7qbI8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kIog68RB;
	spf=pass (imf08.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785515268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AkDiARroLHl6KyOSQsFmxb3G2BExRBvYjwZc5Dx3u/U=;
	b=aIM/euMm0XoIR+ibRNQSJE0QSnhkrpCnIaVjIWsAszmeYrBa+H6fJWk4FSdu4aXZ0NqxD5
	d66SPXCT+c7uyW/0+B9MHIq7im2Q+D5O/gWfl7STbCdLHxyxK9J4ihwEd/04y132mDt2Sa
	s2sbm6wmMoE3SHzZTBMQGWxR18Wk7H0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785515268;
	b=TpjMRoXzG7OIm1qPtGLeltDx36uv/w+phTRM8FZK3Sf2GhMPRjQiIXu1cxzAumqBSwRvuI
	i77CoPhGbFa8dt6XBm8iRVCP+cyZxcVmmtRDEpdURgfTQPrV/+7ErlH+FpfILkWoiVuFgR
	dGAdbNU/mOCRE8Tu+5UxA1HAAb9yFqY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=hjt7qbI8;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=kIog68RB;
	spf=pass (imf08.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 489707A012A;
	Fri, 31 Jul 2026 12:27:47 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 31 Jul 2026 12:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm2; t=1785515267; x=1785601667; bh=Ak
	DiARroLHl6KyOSQsFmxb3G2BExRBvYjwZc5Dx3u/U=; b=hjt7qbI8FvJ4RGjJdD
	r+b04gl7p1QRerLb0BU6Qjqhzsbe98Z9KzJqYf/dtm64O+FQPX83r8MVn85oNcty
	z0X4fZFhTfhtlnL9GJEb/+a7flBMG+vfdR1Z8OGNRSs9860DQe3FP3lGxPOBJdfn
	iljIDSVMfNMBuLzwSLjP1Dv6039KS+wRlPW3+67Dz/H/kriDQB19uCIYmaO1xgRV
	go5hJxjKfkxsRV77vUCZTtsB+3ZTzJyQotrho3ngrN10KtKDaBm2Jef43UPC5BrU
	5pb2ZAfkXZ4pNWPHtue5rCUStMagoYlbfT96d7YzpzdYcYncJSC3IXGTp/FglyPo
	9d+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1785515267; x=1785601667; bh=AkDiARroLHl6KyOSQsFmxb3G2BEx
	RBvYjwZc5Dx3u/U=; b=kIog68RBao2r7bX5vkaWRkHXGnVWOrTvgIXKQuXYAo4z
	kFPTuTcql3TbCIEkT+M7cimQQ9oojLJ5yf8UfEABGVee1sfju96P87ZjZhnMfNmQ
	zz2mVGb38+bzWQhHbnN1ygw6LZDVhJjmctGkbeoSQWqhrpCJDXB2K707Q31UveL8
	Yhoq54BDIOgjwqH5Q0l5bSJO+DwUcNzEgbssWj66zFDgCd1Vpq8rKZGfqyaxiuWV
	KK9ZBvVEGWFNVf6MxO/J9vKG0oMJ2PiJLhN7uF0RjWn38b0IJ7LdRcrVl8X6D3oe
	w1eNj6FEIxQXooALj7DM9C0QOjBgz6KjQqB4+Hb3EQ==
X-ME-Sender: <xms:As1saiP_jfhX6GxIfUz0AEi6cQqX8LkLsBfks7M8Z8n7vSlCurwPXw>
    <xme:As1sahbKlAdCSupSrwigUrcTeai2C4AYFIMLY53SqrdDcTFC3DIaE7D9_C_WDbvOz
    zjakWFmFq_RZuHbL-Nf74z24lx09sjzy5B1FGyhMQRyC4Fin1e5Yg>
X-ME-Received: <xmr:As1sap_LOBHM-lQwmoMck9ftRnlGzUdL8mXA8NrTqsaDkaskAxgErhFqyqka3WYT6DgqSjX-mtGemuL2Fg>
X-ME-Proxy-Cause: dmFkZTERcFVP8HLW6lWAJcoFMNKyac4KI1WLdSW5Cwyv5Q1y5Mf4zQwvfs5MLKguSB69WD
    9WWeywtKpWZQupz8iqlVwAqXwfVPcIpA0zWAnoln2vFRMsZ5/0NyILUu8khRqxHSc+porj
    sEXnf9R/frKCLFuO4k5EcgxmebF1dFZDTkmYpB+ZAE5NcAqEp3I4Y3cayAywGXcJ60CYux
    wuFhlPiLKYPaRlGZg0yinrrIvHHDYX1E/rLPP65YNds5yJbzqICjaYNfhvUiefT9If22bU
    f7VjNiBbYA+da5ag1FbGIeOOmrseEOyOe8lOF/5OW7GKqFFgn78JwI4GwuDa0h1/tS+0In
    xKVxvjXkh6CkzfdyxZiM5OOVn0agfJYkWpqT6pE8JQII6BKhMdou4AjkmEHEb2BTkUnZzB
    NkpZb57BBGM+hRziXHB//LM/E+laIWVcdxlNrnssRcml3jAmjx5JQY+s/+BKxfzbU7FDXq
    6GHNqUAWLZWoW7/Nn1FFbqNIAqPGsJSPbn6lPot1Tu3108NWr/O0vU03IHdZ+xcLjc+t3W
    NcXQMmR1IZc3AYP+fNT+QWVFv+G0GdyzVBSTTl8DK45xcmmN4q9adVeLyiZFJv8kIme3ig
    97wsh6m3BzxC7g4Doe/g+fe9tu9zcKtl+74wrHDhGd+ST7cG6x7V1AhPjzjg
X-ME-Proxy: <xmx:As1saqRzf2z8nikH8v8Fgk7vE5ReXwTwewxy_kYa4GDi7drpBd2y8Q>
    <xmx:As1sarfN__oFApAvj1SGHFP3MrJMtgNiDb8ydhAAWqEKr_0CFdeS5g>
    <xmx:As1sakQC5jgRbzn602PtIDau365wCeo8O_PAZLpKdY79c-n97kTf_A>
    <xmx:As1savLmxUrf-42QUT7-WpWLe0rwf8vAz7bAQS3G9pxat6ux61-LmA>
    <xmx:A81sahcUa2-2m8h52Tj7OKAHdnM6S6QDlKncYBV6WH5ku6rJfAlLYW43>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 12:27:45 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	keyrings@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org
Subject: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
Date: Fri, 31 Jul 2026 18:27:35 +0200
Message-ID: <20260731162739.158320-1-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 432A316000B
X-Stat-Signature: g9kobq6a69p5pwnnf3wci7spanjxnqfp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785515268-48954
X-HE-Meta: U2FsdGVkX1/VTVlL5DVBoHD4uVDFUWF0SNIO6ePD026WGCcfYQvKU1tZOUF2d8fNzRwA4hNhSnxC4NNpkXzZ5y9zBTRfA+ACd434qug0HVKStxkY1VC5s1K6ZBFut1CzfCpU3lBFeME37FTi83noylP35D7wQ5FrnMOGlxDz3zOcfPOII4Fxfe26ZqvL5VTJTXtpG6wzhcSS1WJlH6iUq+lSBBz0zTr//B7HP2JiV8HSXeEPoh7MhdNAL8tLcJq16DbPWxfs6C7UJI/9aoOfqjvpFzn8ISO1HhJg54x6AuARIpBn1uA1SzT/5teNerOWqCPX4OKjqqPziHagcwZY4VzQhTLPrwASJ+3WAc/mlRxXiE1nGHjoPXhOOjm4epr59xFufxMfC7OSLgiHG6WTX3KCgsihdnkRJIL8CLZ/CsDTiRGok/Cq8bzm/PwgvzVV8TanzQX7ZbL2MlgdYfaM06hljW+GOKPlPj7bcHLIk9MKiyQLpvhQCt9A9txVMKiR24J1Lt8iss8Fzwh0/mJ0PdRlbuiJAXUDrcCQlrCbbaYJgOWIo4GzR5fiSby8hYQcL0RB+w/xE+P/GUiD7xsBqj2ujHg54tyBT/qmW2UOg1KLIuNzJuMppYt704ARLVcl5nn+u3e7WJcEklpZ1vuVwwV1RozQfR7Jw+aLhaxFmud3hbDK4rxPalBohPBGXHEvxmlka72fIz7PPyP2GY0st0xnC2Br3NExrIqj4jz3XIQEvkbQzYbuoPOoy7xGYnhBCNZC8bKL/m2E2NlY8IzoEry41bfSDwmOlwOCW1SItAONPOz0TvEf7vwvbsNRRQjkthEyrB4YTTwgnbgVPfgIASfFeWnivPQpnQ0BBo9JKMpFpGeUjkBXieOEMU1AyupSDsmAFTgmhLtNOCO0FS3kI9XM2mEN1vL2AR7mleM48xWBPD1rNqe1GzeGnpGicmm27drp2BzvbAk9SyvXAcY
 7BixOaQi
 aGK+JP0XmTyxpAHbUBhdcP14bayvkYSxBnNJ9XwJAYb95GWVF9Y48XxLY0fib3KC5SStYVfjAYOYK2KVtX5VXQxC1fKLcZ6hJlXTrfAXZyGcn29P5Rd7xwYnncVF9VDh6CMKD/osZK6p0f6E+OaXqFWIWz51uvrT/DcoISbiTT6dhBiQ9vgPnx4qow9Udz9Nd2ryGCDb0yHO+LyJKGmrJxBp5E8haox7MtBcz2PICNwNy3wHOMgwK5uH6ESr8E3lQHZ00D4ZrtWi9j2bs0brmECCm1SGKlZ4sASxxg6irIvPtK6Az6QdrjQsMtn/yGuLMdvfPTh4BRMhmgjdy7MHFWj98abH9pRwB8bvxtmUovRbg/5RjBlMmUyyAXnzCU0cu7k8odnTv/5vrISQ=
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


