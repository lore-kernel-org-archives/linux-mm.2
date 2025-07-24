Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B15C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8E06B02C6; Thu, 24 Jul 2025 09:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE9B6B02CA; Thu, 24 Jul 2025 09:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0926B02C9; Thu, 24 Jul 2025 09:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE6F6B02C6
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D09E916033C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:28 +0000 (UTC)
X-FDA: 83699308056.06.C17DD0D
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id DFB2580011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=kpDPM7Px;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6vaDGqz93WFfpGOQ4UOrak1EBQhkmEoatVxlVsxTPs=;
	b=rV5P9GkDG1lYEw5VupCThB5n64SZW49sjUW7rvA3WEFtSq/mxVdhbeMGqmAerrz9yvxhP4
	RcAIegsD3Uy6EcK/XHv5iwIjKENE/FL20zDzQ4PxDLHf6Z+UXoUhkLW3KVybaubew5ed7V
	2YCly/aOz8clOiTEXSEz60KImIqCrCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365387; a=rsa-sha256;
	cv=none;
	b=QR0V+l6/RUWQPh9ZSv4Xs1WT6roYgWFp9eMnEN5SeorymtBpNY+pi25WrFkSjRC+LHaw7S
	+0SKyxxzAF6aiyjD1KYzfFWZm6dOhHeGjRJ+qlx8vqsszE+ecSqc3mIIz4H8mSLR8BZeBq
	NirQ19biu+4R1fZ1QvpHjIHyGeo1W2o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=kpDPM7Px;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.50 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-455b002833bso4613065e9.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365385; x=1753970185; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6vaDGqz93WFfpGOQ4UOrak1EBQhkmEoatVxlVsxTPs=;
        b=kpDPM7PxapHb4jgRLxlHd0MAY3gStpE1yPfbJjr8E1ounE/JR4LnzhCsQ0DmTf3Ekj
         qnqxobjh1fFETrGFsKFMi0DiEnrWl35Gq6qp35lj135m5AVSvoXx4215dzcApeuqSjH4
         h3yL+QUEKmpURcpnBOmSgmyU/wVWrbTvJRmBba0CFq9lI4SOxvt0VqHEDfJkNi2qiBnd
         hXsu/gQ+JCiIeH/wVhPobiEmhK++HgeOGRzV90hJ9M4BqzE7WTH6bW7yzCryhIRIZnDM
         1gxVCprf12llo/VJv1McCCHcL/XjqxEvSyLqo0QoeFmbQTz6Pi9tyIKdcwMT0/xyw/WH
         duNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365385; x=1753970185;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6vaDGqz93WFfpGOQ4UOrak1EBQhkmEoatVxlVsxTPs=;
        b=Y+Sc+RmNtttezINMayOFGLQBriKeRoOT6z7sHAP87u7L+IFGiTLjh5xYpOTpa+sLpB
         OssEUp+LMqwF0XE5sfiZnyd2S2+/oUg7ljc+/xZ8m0E4aXB7KI/ldRNmKTf7akZylmDW
         9flK0JpOMCg02o7v2eOymH8GCNZkJxNgcH7/ZBRQRJFmuilqeTwY7OscpyzjWibioaxV
         cikr7By5xuUcIZrjtMh0brgSXllxlIky2Q2Hkf0LM+yPgz6tNnpWq4SDO7w2TJvUbtZj
         OPJ0vgfJ+4Og1doGDF7OFBkCX+q+/lZkRDtENLcP0YWcqoFrTGIY6rDdzr04g+ledQKn
         HdKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvuoUw/10uZB4d4OML8CqQd1l/M8l0Ro2p9C2EAUIoUzGMnRyOFjF70WMBwTBaTjsreWU5pjVK+w==@kvack.org
X-Gm-Message-State: AOJu0YyRN7ns4Bc94GTYNqZ1HXJ7lQReiU7fQqgKzukk6dVAa8m5YqTu
	TAnnulTMwHWFhhI4+LIiREXjdBQwngBwmr5b3h0Valz6jslUPMKLa7HNwv2KcyQf6As=
X-Gm-Gg: ASbGncvT8CjO10QLai+fxOe/zLhrzMhsgKyAStrgOmF8RAIcxfwRKhuM6SuEmIFXD2G
	ThgkYsD6g1afArzBuyjFloYOcmJKPDKdM6lsO7AfHWUfxViyd9zkZgchx4oqlaKz8mjBQ7kGE97
	KGA0ZB3v1T5CtpXvVuI287T8Whr0HNqUzLdtet4bMGf/yfpYarbcDM3PvjVKDFaItpJ9iC+VZc+
	bT3p1yahtEAVV5s5U4kaJvHrQ35YlcPdEkHTw51ivBlV8Zs+434B+6SXeJ1/1Gjzwzbr6Hg8f/W
	YFJAAAG0CZdYeaJ7GDn+B3Ax7YXIK+Gie8lSbXFt0pkdLt9UQBQ6xWRcacxoMAdxaxpBWW52E7P
	3J4wIwOAOFQx6PtpqNmKryTvQvlFPb9bt0g8aOdYJK9uKO5r/1MSwebTXnlm6GXIs79SBElKZnh
	KTHdf6ewFC7vRA
X-Google-Smtp-Source: AGHT+IHYnD8d7A8aBh+5tnrqY0LYzarTFZbBZJYJd44Ilh6yiLc/UVbK9j+FmYRR9VqOWZQpLWbc7Q==
X-Received: by 2002:a05:600c:500d:b0:441:a715:664a with SMTP id 5b1f17b1804b1-45868d3289cmr52540145e9.20.1753365385393;
        Thu, 24 Jul 2025 06:56:25 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:25 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 04/29] Documentation: kmemdump: add section for coreimage ELF
Date: Thu, 24 Jul 2025 16:54:47 +0300
Message-ID: <20250724135512.518487-5-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFB2580011
X-Stat-Signature: rjg1zpp8wsawztz1c8ndob48mkpykq53
X-Rspam-User: 
X-HE-Tag: 1753365386-637541
X-HE-Meta: U2FsdGVkX18CNoWg2m1mAJYOLE3EtWKdTxN34gyl72p2jM7rLLomYKR/Ah2gnGceOZhsXEK9NWSSSdZ1dPuxvQZ7+P8pbTuPeBrVqp2PS/BJlfJwy/Wvj0SxMVnQgH/3PnyPSkvt/dXwGNLF0JQUHaMMT4iGCrDqa8ZYj0WH7J9AntWt35CG/uleFVxC53n7El9+EnCKHur0fbNzQBURyIkYVxuaPbAUSRiZGM0vmQez1Hse161BvC1z5KBtujOG4UG/P1hv8qm1tZaYc6dME4NZbKj+JkIHdUIwjKhlgpkPYp9MHFZ2PFGWFVOeSJi+V6+mFbu9MnPv1r3axF5dq+x/RImV81fdHU4uQvvnpHf2dPiEJoRtmaTqSX2rBCCFutzlkfJhOJyC/fEtgkLbKAj2p0gwxat9flkyL3f7jwX99zuVQoPDO38URHYI7FyPIZHbUT6h9Dp+CKeORHwQXMNGjKZpxhIkQVK5czQZw7nS4hNTlsN5RI55P4LmpguO8G4DRLLqcxPoJ5JJwUQtfMaIjcZFjE8YEkvp+SuVGhkTE0NFGSe+T551TAili3u2Xx7oPI213jyX7aYpsILFvKSDyExwhNQA80qtAzG9CjWMJv8O0CPAtNaabG8IxpMOcCK9gjIDUMtFJf8xAfEmoFEVi1z2xNSU453CLy8jMdCPepF0PovOZwRpt7uiOexfH9Gjk5NoKX2sJzhO++5pktA8Hubt1EyTw46M5OuxUZMPqCTWanOzBnfLfRd0YhMCa5ZQIU/F/1Qf9S1KSG7GVTS3YU0JMyK8vxXXnQRbtuFW5yk4f1uB5BBI74MkwNfqOHkmWAm6+w7Y9kL4mOGWPzQR1dnjR546O87FjE+u8yPP6WMVwfOKaesYDKOGAIuILA4nc8OAdeq8+bRlnGqLB+6z0bRdxticJZxpivx4uEwR26k89wi4IWs/juCiRYfH1HCF0aEfB1TigsR6UpP
 miaT8nNb
 CMYBXfUcmw/D9U2wgQbEs1Czd/DQHWyBYKKeSXL5TiRiusVgtQGj0W99VpgMt1UjNbbQ/YNCjIGsWmrwSgpBg/cBCF35UYyf6CQK7Gy9f8gY0+kQXFywtpXjWftezbSrwwhlGblBI7jOwArBHImhtqD+L5JU8jjX/jVVcK4S+PnKFpcqEv3upu9mj2/dVkNg+jtdyJr5qgcv5cKhivPYfln0pP5Rg2KiArC5JVE2JcmxzOJzmKKOif2pSTd5Tq2dl3PVPAXbixoHZ/1iuibx5JOi1XF6t2x9N/B+22Xtbv2J6cYglfFoAz2hNScrU5uKOatacWoslPVtaLMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add section describing the utility of coreimage ELF generation for
kmemdump.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 Documentation/debug/kmemdump.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/debug/kmemdump.rst b/Documentation/debug/kmemdump.rst
index 3301abcaed7e..9c2c23911242 100644
--- a/Documentation/debug/kmemdump.rst
+++ b/Documentation/debug/kmemdump.rst
@@ -17,6 +17,12 @@ kmemdump allows a backend to be connected, this backend interfaces a
 specific hardware that can debug or dump the memory registered into
 kmemdump.
 
+kmemdump can also prepare specific regions of the kernel that can be
+put together to form a minimal core image file. To achieve this, the first
+region is an ELF header with program headers for each region, and specific
+ELF NOTE section with vmcoreinfo. To enable this feature, use
+`CONFIG_KMEMDUMP_COREIMAGE`.
+
 kmemdump Internals
 =============
 
-- 
2.43.0


