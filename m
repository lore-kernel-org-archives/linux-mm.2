Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4FBF589C9
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23C396B008C; Thu, 23 Apr 2026 08:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213D16B0092; Thu, 23 Apr 2026 08:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB416B0093; Thu, 23 Apr 2026 08:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEAE16B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:56:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB4A412013A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:56:57 +0000 (UTC)
X-FDA: 84689820474.29.3D47D41
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id C361520003
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:56:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XERgPkIw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949015; a=rsa-sha256;
	cv=none;
	b=GUQez9uHcMjzaRCU5oCd0xKhq9bT0VZZmZAs/aK4jMaOMMRe65tAP2xZtWOxY1wjKwU+jB
	9ej2iELAZHrvtwXw/MvlzpDnIdYBcRwX2tajjnD1SdzPvT2vGI2OWD0GCGlXqJ2CIgE3QN
	Q98V3leL/eJPj5ZjdCOgyMZOF/6HKO0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XERgPkIw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJW0byvMLamYAxiKwRCqLs+XElTdPsa1lYRy91tdi1g=;
	b=altP4o+wMrsce8uVwWz8nhSsb5GIvhFMQck3SP4uBg7ZmhWiJPh0Z+UulHyFMv9XmecCd3
	z7UTtuJd1YGEmZTEULaX0ZJBakKvOLeUhuW85l6hor1w7YW8gxl9UPLbr+Bw6PfBTeeGCp
	R/Iq/SrtoyTvHKjkngSvqZ8nThP4gBI=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43d70c30767so4452769f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776949014; x=1777553814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJW0byvMLamYAxiKwRCqLs+XElTdPsa1lYRy91tdi1g=;
        b=XERgPkIwqc5BUGyBEllk0fr+i4pTuctxC9M2fazs9/2rDrEFcf0hB+BrxD+z6Etckz
         Gpa/DYtpGoQ94+lRLqMyatASia+aoblEw+ZkESEaoznL+W4ls/QC35iqv2E8nviP6YWM
         BqGmYwlCB22NHaEh4iRLMdq4/ZLAxhujf/nq6B22cmNwtnmY86zM6TBlV0Fy/OK3dj1V
         G5XOS1W6odrlG3M8eSAm/ANvR+rhJUrzm6qsnPMesGV7YEuhp6IdQwsNziU+YewVk3ss
         Hhg7Uh4FtsBH5NSAUqvzOrZhIhsUBFxPZPtAKtDsj3ylCnN1M9NhuJmT0IQo6gTiNaQW
         OwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776949014; x=1777553814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yJW0byvMLamYAxiKwRCqLs+XElTdPsa1lYRy91tdi1g=;
        b=ZDaBexxqqS8TxYtbmvQT5iP2L8kzIPH107XKVbXWqbvlUbprO/xtJjNym0G3dPHjdy
         5Yl06PKBJMP1fa3ilGiR2E+k/t9ginZZ0oRtGKLfUp9kpliCCT9KhJS7HhZSdQJiwFHt
         F/ogM/bPgoLgwPcd0iGPU0Ua9bxshuTQWR4J6bukHM3jklIZtkh5rf7ZziGTTCjxQkO/
         bVdcen8AdksCrwmIdx5t1lIA7N0X2+kG1IWCl4o/u+z6rg04yRfg7q7LYwj3aaYAKYlm
         LcIMv1LXtHpgtSmcWsHnHFggy0oCu2JngK5BSdFZgIAWa59Bfg7e2pPaOR+fF8zXac0s
         3v4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/us2rzlXnmTkFTGQFuByRrakaAntxTvYEs61IDWNnzRJc3p8plvhvPH2s2g1dYhCMUn5PXKmWRRQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4z3lBNY77ksUROGDwM+IXk511ilr6zOyin9jr5EHkLAGNhYq0
	ctzHbAaXOheYhJ9blCwwDo+e+aKdOJgyjBJRHoa3BW8Xr/bI+804MvPb
X-Gm-Gg: AeBDieu9D3uSaWBk5HFSiXjXZC/9I+19VuWIUTsv45z3H/SO4+OD3Hw5+MqP1V7BBko
	Rdv3Ymvxo/FtjfTn0yruulQcnGvc0zfJcyhj9aqZJhePzR3pk6wglwQbESGivfJ5if0UPr7+51p
	N6Pq7Vg6wC4NLU1wTDYDNM6PPAJz1JiPfWyve5WSMO9T1r9FeN+UU2vvSfx6RWbqTgi12X82QE3
	VK7G2cS+n3cY1hhUWdbw6l2EOHqH+B3nwhp0xc1TISYnLGOu11Tkz0i0x9dcgq+XbbucjxmYz2Y
	eWH1E1hL+uNqDACTex5uPT7aATHa6x7fQBtllbFAIH+mWQTsop17Giq3/oELGE5M3k20uSiSJnz
	99Hdp+SBwgmUVjdVdhGeVi2eopc4VHO6OL+i6LiL/AalOPPyE8EUho4U46psb7CXlIOiDNk8wVE
	GZKR/Zti0FXH2o/a4f9zvKdbqykGOEnQXWsZZqwBku3nWwrcGEDy5EVnirZreBjpaBvQtr0iGXR
	wxgwWHkmX+fPN5muTF72IJ+C8HmCBob
X-Received: by 2002:a05:6000:1ac5:b0:43d:73d4:b1a with SMTP id ffacd0b85a97d-43fe407c0d8mr42929332f8f.19.1776949013988;
        Thu, 23 Apr 2026 05:56:53 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1405sm52887714f8f.4.2026.04.23.05.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 05:56:53 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org
Cc: pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH 2/2] mm/memfd_luo: document preservation of file seals
Date: Thu, 23 Apr 2026 13:56:48 +0100
Message-ID: <20260423125648.152113-2-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423125648.152113-1-devnexen@gmail.com>
References: <20260423125648.152113-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: natjs59zemn3xcwo5csbcykbp4r9xdm5
X-Rspam-User: 
X-Rspamd-Queue-Id: C361520003
X-HE-Tag: 1776949015-247203
X-HE-Meta: U2FsdGVkX182V5m6G8AhCl9L3K0YjGyrTSk5ffHB20nVhLWIwcFrf7b0Xkggz2JF+odj1wE1PE0E21Q887W/PIjiLzC1ErOhnTdPhN3tFnxYbcCZL0DZrNozf2REO5ljUkTBJ8pflI9KH+pytSq3CnTJHLZNyT5gXsuXzaZKYLt/XC+O8vF2MxsFD7UIo0tt42N+6flJXI6lsH+GAN/Wusu9IZ9FhZGeZH/9DWe5UA6E7nAzh73TUrvffdCz7XW8w5OqWK567nJTL1onY2w+anglGz1WX6BC9rRKF/W76Us4H7+Nzvd4VOo5At0EdeMUhegYkHGVZ3Rwa4IpqZJckWrLUIRNaoDVBzEGBpklFrqjroySbxRP6DOjxcOgJ6PBOe64sloxnLuFs4DbeldVun/zhF+92axS+NB+THuRY25ZU5SsDyimRgQXQKBsNuVNc24I2wLHwFJo2Hszyy7bL7tDMXLjhAYfiFMbC0RCxQ7g+1m2T/4YFEIxDZwO4uWokPXajOj6kEg0gZ3MyRUdtZ+vrKJ2P/eFs8/vi3a0mxPpUWlnJr8Wq28mWtu28rATPjhytE3eSfBIAdbymW4MbpMSoFFiXQKu4Oc59CgqE1DBLSliWTPezjjI6Bwr8YuW3N6IjHCnKttLJqdG0sk7IIzjjt06UZvirufK5rQBsImnwWJ/mDdMH/TpxpA6XyXF7d5NOr1CQEq/0Id9lh28hao3kkD294FRExVKBAZxDic6YA/Wc+Vj6O78Abu0s+uPgMpqrljLZ3jUTSBKHHi32RBN8e+i9jmp8vPufchw6pLk6fSChYX6GDk9AAN6+MBWK3CQ0TACgELjv+LMHDuEFbd4RvdkVQVjuyhPvvN1blPJbXuezrccuLUvLBGGYyby3Xq+h5M5sseUuB19crEBUo9v48jYo6fnzrCM6YeCkYQKC6lRMWNluYXbnW211J5jatKcsliaHmu4GZJDqKg
 oq/MThcr
 jYcU29UKvrntWI8fQQQnrW2XIPmriv3/ccINhNYaWuttZNYtmmSZZxwmNbWcqzKwk/nmsLY/bGz/s4r7dZCMoKzJbu6aAHHN0n82F9Picr3FeVGcMvbDqKNjNIZoZPiQwFmKOTyUJOdbMorxLHFzCl/IO13MjIsDiVzy1ZHMwKq6Kh6QQrdZ+trl8xWCalqzL53nGFykEmifsXjm+wjzAXPmxRety86+Xg03DyT9YP7BjIVRNRrTqFT2iunvdeKwIphpoj1auuie+SurdINs1txOHqT38cDD3M/TTBc/8UdENBwN2Fx7QJn3rBeBxHzrx1WjNXPN1AHlRPHDFJQfGExsn7OqmT18CekwokS06R5aCgLKRPB4SibnpO6F2NJO7gG+7JPBMwRaTX8uu3vS0D4WS4Kxnm5C61avoilV+Xxmr02/yR6dI4+9E7r96wVqYBOk6wYJVFnookEg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 8a552d68a86e ("mm: memfd_luo: preserve file seals") started
preserving file seals across live update and restoring them via
memfd_add_seals() on retrieve, but the DOC header was not updated and
still listed seals under "Non-Preserved Properties" as being unsealed
on restore.

Move the Seals entry to the "Preserved Properties" section and describe
the actual behavior, including the MEMFD_LUO_ALL_SEALS restriction that
both preserve and retrieve enforce.

Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 mm/memfd_luo.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index f41d11053b7d..c5250f68c096 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -50,6 +50,11 @@
  *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
  *   is maintained.
  *
+ * Seals
+ *   File seals set on the memfd are preserved and re-applied on restore.
+ *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
+ *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
+ *
  * Non-Preserved Properties
  * ========================
  *
@@ -61,10 +66,6 @@
  *   A memfd can be created with the ``MFD_CLOEXEC`` flag that sets the
  *   ``FD_CLOEXEC`` on the file. This flag is not preserved and must be set
  *   again after restore via ``fcntl()``.
- *
- * Seals
- *   File seals are not preserved. The file is unsealed on restore and if
- *   needed, must be sealed again via ``fcntl()``.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.53.0


