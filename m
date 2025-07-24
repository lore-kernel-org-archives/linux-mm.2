Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99AEC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730E88E0084; Thu, 24 Jul 2025 09:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E27E8E007C; Thu, 24 Jul 2025 09:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2A78E0084; Thu, 24 Jul 2025 09:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48C1D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1911910FAB0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:49 +0000 (UTC)
X-FDA: 83699308938.11.D1AF343
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2ECBE20009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=z5bLAHic;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrjIGy29vhQmG8TWG3X2445EHE3hkTtQk53xAku5ZzY=;
	b=6FdyCLoqOeD64e+iqn2nTs7TgShGzZoKSyL01XvlWBRGm7rBvI5Sq+keNj3tNwbK6ZDwe8
	pd5ysKym5D5L4WZ+OvI5733q0UwrWE9EIVw598efLxtYuwtk/EFl2tkY/4nwf7s19DsjW7
	c3CpALI6xlv80eSo2+GordDOAEFWyxE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=z5bLAHic;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365407; a=rsa-sha256;
	cv=none;
	b=zcTz11DSMVkgJDjvTYi/cvGPvC4Vz2dPGQgQCBWVi+I7tlYWT121YSQuu8kDXrz77Mlp8S
	qmHRyC2NIfUlxqbkv4MO2vQNz5VEOjqnIlOGVtb+tyAMOi6AeI61J9H0nR6IoQlkE5ZaEs
	/zJbf42W14GSt3aerSSheNkZ186awD8=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451d7b50815so6724135e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365406; x=1753970206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrjIGy29vhQmG8TWG3X2445EHE3hkTtQk53xAku5ZzY=;
        b=z5bLAHicmyISc6WGIGvOsd4l+Z5/3VSAj+IemgZc0KssKDLhX03XvNHYHsoHo19YfT
         eNxN6h7nKlsUVAldNEnd3yErUU49oC1IGZ6YGFBBrt16tx+UYnoB7IUyNjk/7c0yWPUt
         TA/67r90TJWPXjxnD1D6ZWWw34QAJjCOMfyipqZ1Y/dXyY1rdGcbLZIbmPkcsc9UUODR
         qhJqE4P5GRWYhl3zuineELL1CpRdEsX76Jk0kmqdN9Hm6+m96u0A1ixzgBinsVhmdV18
         ImWx/GDv77ru+AzWUssEhNQezAMH+hKOzgL7+xjyOWR9oXnPcU1aU0/yc2KZIgfeamVE
         FdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365406; x=1753970206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrjIGy29vhQmG8TWG3X2445EHE3hkTtQk53xAku5ZzY=;
        b=QW6hzW7W1uvuJ2l8aLllwcz1oP/Lwldhq9e/+e4qFrSIFxXPLtTk35mjyIDjYGSJQC
         1S0P3dNaBjaT4fsLGlWATVZRud8nN0aOnfwgUZOpObRPf1jMaRM9uF2o+Y019vrARMwJ
         tAIRR1IHt21pulLb4uxKMAIGmB3atnWLOvU/5/r/WlXIUtwEiZ9080KJRWvRH+MfsQCO
         I4Pd51BP178DOT8PDS/A5yITAooXJ6Sd3bJkbBKLven/Neprru2+TtEJ9ipfMXA6NkGD
         nITZZrnHu6HzTYvp846JGkIS9+5HeUsa0KKCOuliSoAubp4d5I0SqDRwdt43wgSLpTrK
         hI9g==
X-Forwarded-Encrypted: i=1; AJvYcCVcikxAfBTTJCB80JS6BujK5yVSNqKsafxhypxtwXieZwPw1ig3onWMpfrelD1NyFrkN1A57CG3Zg==@kvack.org
X-Gm-Message-State: AOJu0YxIDqZd9xD/MBWCjaDtX9PT+9LnYcX6K+1BzQKDFVu/sLJTauaC
	fLEnT/kVNg8ffoqR8Gjk9O0nYK/vnwXIWFWj5Be+ot/sxqlKDgpaOsBxMgfIzfBFFMo=
X-Gm-Gg: ASbGncuv0QtcpMYky4iR8FnA3g1pSqkB7tZSgGnXyWzARDlRpiVft35fB0lJCAFpIoI
	WC58L5IL20r412iNotzkRZ2+jqnRsxlFNsRGFaWmUxIXW8UHueDTMtTxnEZPCk2HUKZF7w44/AI
	4NH6C0SIgJlzp8rKUQwEC47L3uIiAII6U2VyE6wTMsOoNKg+G+M1TAgVwYP3aIYSn5J5Og0YEq7
	etpLSTgjqeGEfq0zSv3x/VmbRlBSVacCSXaXXb1WSiPMMQTPah7Rud8eY/QMtq7hkZOLs/iGELh
	c6OtpUY/ZKaLQzYXGTNhGpP9JqNt8tV2XUAEi4MjHBd+aY/4EGCA8pcndy95HZZEpMcBrtP3h7+
	Mu2Vtxa7ASx+pwctTMoIY736wJp1aL8JGBjuXu6OY4TMRV+IZev2izRyF6q1PZ+4uIraRqqlM5f
	ZCkGb742bgbCxV
X-Google-Smtp-Source: AGHT+IEVcqWnuyhtVrHKBupbieg0QvSQq5CXC89YW4ucbe/Xkxqrak9r8AlJ1/jdx+SIbeQvU+walA==
X-Received: by 2002:a05:600c:8b70:b0:456:2b4d:d752 with SMTP id 5b1f17b1804b1-45868d2c4cfmr54619365e9.20.1753365405757;
        Thu, 24 Jul 2025 06:56:45 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:45 -0700 (PDT)
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
Subject: [RFC][PATCH v2 26/29] init/version: Annotate init uts name separately into Kmemdump
Date: Thu, 24 Jul 2025 16:55:09 +0300
Message-ID: <20250724135512.518487-27-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g7g57h755u37ts68qg37wsioxmujt8w5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2ECBE20009
X-Rspam-User: 
X-HE-Tag: 1753365406-7647
X-HE-Meta: U2FsdGVkX19cX5ssv7HjoPYcrsJdUFvUfmniujER+x54H2OLCfT1ik8zcWiH4QVdA0z5JbHGvL2CyiB3V9vUKFPp2szUi5WOl8eU5ioAB75y9t2Mp4DQ7iP4qw4JwOdldC5o0zWjBeg/m3NntZcw+FUDA56xZBSoOet8d/ISblV2lXeiS6KYGjxK5QWX8ABL/njyXuBfXjkuCKh0NwoDTDleYfwn249OYs8bM5nuSWZn57sGUaQultKprO+4InStg5Hm+BPqFcuxtHzCWNZNyx7nUjIXOXslCDsitJeIf4Yl+/yVwaHC5a0iR4HssqyP+WbQ1J4O4ehl6TMhmX+t3QdUq1/5aEIoAunHypISCzAa4hSq+1PndNtkdDhgfAFbXF3BgibYC8pdyymNrCUd6wupLBpti61xf196HsC2MkBBzujW5lGGdtcbLo5jrRNKPxWVJiYlUPFffsNmdNdQSbyrblE7BEvM7rPhJv2z00ReNQgRbTkpy/MmNrlKppvb8R/K5LKGSrvbSebts0J475auwRvvfBLdD4cdbRR04LOhOXIyhaZZsigcnL8vE2fMkPRDlv5IY9y2EeZY7sw2jun4/D9GrlefFmDWrSLlCRRBReS5GlsZp3RUx9gjMVdpcaF6P6Poe8xz3bJtuuRy754aHfOK3VdJ7QPcMgpF2zXyWHestTIQgTOKqpG38QFK+9skdDzzx8b1nikKo7KfMK3PhiZduC+N+vRyJvgc+pJX+t/4iibevjLrnAjoY89Z5uBhVjGRc9mC+qC15ovZZU6celXF2hnpEQP+onrGUtcRfe7CPNE7vhRy4bVfXA1W51WN7huaNyO0hv4C5HNPfqFPxgmWdFzqkN30KdWXXPPlLvWWb8259buuyJwtx3nsBxmI+g7mkuBuhxQsL9a6cElBEBtmo79rp5PolPzjq3tOAlwt9JbsIKBn4OMY8QUKnd9PSKPWw6eGGJDBluU
 U3YSgQYS
 5X9EfKXNfekazG/7tR5B28T5bcwlNmL5Js2b1m4hOy55mCMu7ds4pE8m42hp6xxAHB+ogFCZJ18PGZyRgWC0wMH780I5kNJaRWGthIQu8yuDfTWA8J7AH/jqkJati90FNUqQv+wHfw5y3bKB+RI/+JEWjMZl1YTF71it9X/lXFsvoICyOhM7hBZsJIxfjbMpGbpAB3IZ2PApjOH9djcArgsG/m6h7+nw0Uf+j2KYlSOlw2ra2UeVgrER2FtCzR0lCI6cqyXl5BgXFPvhcyOtkIGdSwYPXUdkj9WuHiPsrdCoi47kKkig/AZOX/t5s86Ro0SkbVa4hoL+lzRU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some specific firmware is looking for the init uts name region.
In consequence this has to be registered as a dedicated region into
kmemdump.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 init/version.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/version.c b/init/version.c
index f5910c027948..364e7768da68 100644
--- a/init/version.c
+++ b/init/version.c
@@ -53,6 +53,8 @@ const char linux_banner[] __weak;
 #include "version-timestamp.c"
 
 KMEMDUMP_VAR_CORE(init_uts_ns, sizeof(init_uts_ns));
+KMEMDUMP_VAR_CORE_NAMED(init_uts_ns_name, init_uts_ns.name,
+			sizeof(init_uts_ns.name));
 KMEMDUMP_VAR_CORE(linux_banner, sizeof(linux_banner));
 
 EXPORT_SYMBOL_GPL(init_uts_ns);
-- 
2.43.0


