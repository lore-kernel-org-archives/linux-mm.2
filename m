Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA75AC5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 12:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F346B009D; Sat, 22 Aug 2026 08:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37456B009F; Sat, 22 Aug 2026 08:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D0C6B00A0; Sat, 22 Aug 2026 08:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70BA96B009D
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:17:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F19028011E
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:17:11 +0000 (UTC)
X-FDA: 85128805062.06.BB353F0
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D6151A0003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:17:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e73ogwsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787401030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8zamBZylGLfyBrf2U8aA1K+M4CwgpdMHKvZaU2DV3CY=;
	b=IRRORTK2JLHPtdpj2yMdpfIdrnjvMqIvvkd/KckpnPEl4Nszan7+WeluM6mhJHXUe9mWY8
	IWCbFkOG94Mxy9AvlnMGijpyj6bKIa+qa6u9uuQp5tpRnGlWb5yfCVFZgGBhatSL/ogVX+
	PpxCRQPvcyf3B7TuvDTncK2vgtFE60k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e73ogwsY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787401030;
	b=ov8F3VlJOe7MqUDqiZYjL44v4TGkaRuDJtmh99JuXJJ6uv0IhRpjoF8kiVcLl7WGXgpnB9
	Frbu9wlblNmsqW8m7pIIszSg8i3hGY8LfAXowienGRPHrokHZuqoRcmEn6gZzmEE/3NKpa
	ATtojE3IBKc3aWTvN6PeUPyQsk5QmWU=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a20319d030so3040558a12.2
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 05:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787401029; x=1788005829; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8zamBZylGLfyBrf2U8aA1K+M4CwgpdMHKvZaU2DV3CY=;
        b=e73ogwsYNNJ/6khzj4eRhedI98fwtxAjww0gbV2zUHJjrW1Uqt1g6QPIM7jSOBD1pu
         VZHx7lwCW8LQNa1AzgM/mkKz89K1sgv8Z7uSyf4FQ6TZiaqaAWcc3UrEEk5RhSt0WZTZ
         XjL3+89mtORQSlIk2cR0NSRznG+rZiL1StjpwVvKNaS0qwRBCyXbzjJVXAkrY3PcRcVv
         DUxxoVPWVADJ/WCDL39pHobHBXiVhGGhA89EusHJi6Nw0YOV5eQiLvROGvsmqdmakf6x
         G4c8QyFCQI+6uBoQj0xVcVV2NVgPLG6ebXZE/lBvVOQfC9e37CY87Ne56BQ6RGY9n0Ej
         JqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787401029; x=1788005829;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8zamBZylGLfyBrf2U8aA1K+M4CwgpdMHKvZaU2DV3CY=;
        b=iYTLVvzEM84LqP12yaM/1yFF44MrOmJ8GZe4uOjlKuu42is2LPADERJ9lJ6Opa4T23
         /psDnnHxWOoxUAYvxgIfb60ukcEa0S80ArfhvPhIsz0AGgNCZne6N/vzwPQ9dmlqwlxw
         vMRScUTUflwtTDJFno6hApLnmQYmxHJTclmwNz3mGKE5v0wcwZa43dTGJFui6TW/j30/
         YMfZOqvWiUEup1RLAjjiqPhBoFf7TusK6/5paceOP+Or6b/jG5pJW4vqIVjZVR3fXDse
         /SNnqnlyweTv77F46anZUQLyGJUCGnTlsq62rlQcENiVosXjouLPB0dAnVAA0wbQj3a/
         6i2w==
X-Forwarded-Encrypted: i=1; AHgh+RpXehfaJf17yvckOrdSQHbwjNz6ekbJh2dXIiNvp91idrfns2oF0NdbKFbwbzDtokSAawCOVfhVqw==@kvack.org
X-Gm-Message-State: AFuF++lz71IkAfa3Xm4CZyYtEx7Pxc3PT3MtUtaXDhJCpVBMSi277BV1
	LZbvQRmZvXVNdrhL+rqPQMcyNoX5hC7U0mY0+gzeWTnGd0MUm3AfhfuL
X-Gm-Gg: AR+sD11BxWjWBN/dbj40j8T5xeonnu9N9nE+IWPPgWvgANHkUjbe46KSsZKySMTrrQA
	VzR4CWW+OaNRcOCKFbLEBJ1MZB6NAcX9/0dsbgrJh0kaReVHpumvKaHOyFid52t0hDYo+YYR7bk
	r2FG1eFmoiMrfpgJqt7/ZYrWz1TQWo5z6I+WiUv88UluUz4MoVj9gyV7jj8J3giSJvGUvjGF3AD
	vJTZAg+pDWORp0jK6PUuVrih0NfWb9cEPe1RFlsRzwwPDuI3K5r4PhOiZVU18hMurBJOX++hSrC
	7IL+KEWs5jcZvo+KU8w6tlDHSUkrdAUzib5BhyjygmxSLaYW6BX4AOyAq1LKqiUfVCcSJZOLvSw
	1aQ4nIcQNsIYkbf5pKDoYd1mjqtZc+UQ1CgZaq5Lyv+YrKWF5YG2XCoaS92rMiN//AgO9VdVeq1
	eiEO13TW4LGte5qjYyClTGmQJojIxMlJ2/9luNcjRXfEyaGktgfXjj2h+kjq77O/44tAjsNNOsH
	v6EapfGpXiM6btlk7SOG4SV+MHV8kCtUPurH3OdItgvLtGWuPt6lCxvvPcsKms+JtKiP5nogryR
	TKmBYbojB4Y6S3KCgJ9EVR2ZyJzF+6zmt2q2ccZa+KCpo3eIS67XUWGWmJ9v+3CM4HSa
X-Received: by 2002:a05:6402:5042:b0:6a3:eb58:dcfb with SMTP id 4fb4d7f45d1cf-6a42f1ddad2mr14242382a12.10.1787401028842;
        Sat, 22 Aug 2026 05:17:08 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c30casm10998322a12.7.2026.08.22.05.17.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 05:17:07 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] docs: xarray: Fix xas_try_split() name
Date: Sat, 22 Aug 2026 14:16:50 +0200
Message-Id: <20260822121651.1559-7-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260822121651.1559-1-kmehltretter@gmail.com>
References: <20260822121651.1559-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qccqwf4bffeg3fycbh57ts45gpjanpnr
X-Rspamd-Queue-Id: 3D6151A0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787401030-111146
X-HE-Meta: U2FsdGVkX1+k30UFMi6HI0iFxslbT2l73EFT47capFfOCG0QW4Cc2mDjwrOyQEAAix/5o6wV/VZ9084k0CTpSAqBGNdqCJ/2UK8A9B4OXF9H+IB/6CJii5H6VJQZqdzpI/D6a7M4CAn7DF5sJ5p1ob+GjsKXh8QGXDrHfUZfKQDxCgvyis203o6t62NLsx8JLdwlk5EWWKulKXqJ2JS7NS6JSbWMMSopWobMUNr1XqTuT+psSMFbhT9dYr+yWxcL7jWS153mdd/S3tJcmloRmttz+jYuJcikFRx9xF7q4ywUhNgHQWKRp81XDLABUC+/JVIrpSdUX9KbeZ04B0okVAb8F/FLdPn94qnIYqqQcz+O5lWZY4f3RCjR5GtnLLGMu637l0dit6JgQwrk846Svj152z7vSAQmV5FoqWG3kmIBCyvJB+fD3+Xg8xz9V0g5AYM+qFqA/qufClTLL5UT5XmRfIfA/wpUvoSMNBqc+ngYhj7hZdJWZIbsdVxue+sC3UD6bcovlaLobW76DcOM6NLDlhCAplEUyQRdT/0Mlo0nekhwkWAkmSSpLcs6mwf+9U9AgLU3xtDccjlDeLp97NInukRcKQr0mYr1pPOsupbD8x1LlTLpeGKn2YL6PjQrrNaPJa1d3Fo4Q0g8olr/OJ4PrKisBMCrBqwHgj/jGVQX4b3qZBhtyqVQ62P/8dweKHAyiNwFfKB77ItD54l8D3Wp50+C994KMFk2bBesc3JohZ/gU7e6EBRaLy41mEzkEaUZ0iGrkXhHs0/mqRptfGTHsf8pX1m7ZdJ36i+eY1gNrBJ4hTh3hHUlp0FsuU1yXPMnShrK6/NRfOwmxGp2GcQWRtVOsEQXTVALLhAjSTunqz7QHHbvF9uwGnUymqbjdUb24J39F/CszOXIeUwwYlgX1g9bSFNWmO+JbQbPT+4xKHGMp7plijZoLsosLgD6qjofDKfcJL//gOaO/xa
 NI2G2wY6
 +4mYnvnqD6mAoTkJnxwMVcwxI9rIMj3iwm3peqUGcGmlWw7dgpZ1QyEfK522yNu28JU7W+4Q19uyyyR6b/IrssXwbb9CStD4lR97R4U2PfRfd/lokEbwCjxsHofEycFzk6itF01pqR8c0e4vugNc9Rglt3MK2ImZbNx55XmV4xLVIhVNTkWcMPNVHdSzg/BiDaiDHzgIcAKYE1DXlj0JXS/wowXCoUIe0WjLhy8rXPC2x8eZhmOyz4njdqZ6WUqdXMgjvRo/fAWoNYryLZQTmpwItX2OhpZW5JI3UoFB7PCjQU6Fd63ahdXi9cWvac4KOzh3odvdnao/URgIJk1D10PhsJYmYg4H3RdaEiGofcjMzvPSRyqdR8EnQphfrgrAqk+BAmV69wZFrQ3bdK7MTr3Kkd8kWDCQmEl2568gdh0qXpHnXQnijtpE0bOY5sKTzDtSWlLU4GKcrvuReAkl3KsaNUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The iterative split helper is xas_try_split(), not
xas_try_alloc().

Fixes: 3fec86f8aa8c ("xarray: add xas_try_split() to split a multi-index entry")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/core-api/xarray.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
index c6c91cbd0c3ce..3d2b20c05a937 100644
--- a/Documentation/core-api/xarray.rst
+++ b/Documentation/core-api/xarray.rst
@@ -490,7 +490,7 @@ entry at every index to ``NULL`` and dissolve the tie.  A multi-index
 entry can be split into entries occupying smaller ranges by calling
 xas_split_alloc() without the xa_lock held, followed by taking the lock
 and calling xas_split() or calling xas_try_split() with xa_lock. The
-difference between xas_split_alloc()+xas_split() and xas_try_alloc() is
+difference between xas_split_alloc()+xas_split() and xas_try_split() is
 that xas_split_alloc() + xas_split() split the entry from the original
 order to the new order in one shot uniformly, whereas xas_try_split()
 iteratively splits the entry containing the index non-uniformly.
-- 
2.53.0


