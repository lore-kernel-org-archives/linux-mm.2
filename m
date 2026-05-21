Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC68CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 18:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634406B0088; Thu, 21 May 2026 14:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5046B008A; Thu, 21 May 2026 14:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FACB6B008C; Thu, 21 May 2026 14:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40C146B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:54:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D746E14076A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:54:26 +0000 (UTC)
X-FDA: 84792327732.04.C8566BC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9D3C40010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:54:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVtQaFYg;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779389665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O43uMa51N36nEinrWO9reEuS/JlOyHUwEmdF+rTGNKM=;
	b=SPb6TbheXAeoAw8cnOMWbtcObDSzDgqffE0wFgyDuMARv2m+7aYjmp9pHVs/F7GrMA49k1
	JN6VrtW4KXR8kuqTdtoske5lV0dDdgu26aUnn6KjEx2mT5iw1d4aWn0PkszknNDt9oOO4d
	IBxqis8jcLhObFvNTIhl/twTT5q5W4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779389665; a=rsa-sha256;
	cv=none;
	b=J7M5FtsKXDL+E4tfrIem37W72lP6xDhqqHzORIfGVjdUhJs6duCHXUzbOOUYd63iynRLBN
	4FLDjbmoJ5YtuPaSswwdbN+B4qyqPHX7V4zawOAHDXM8cjJQYDSsLDH3b2YJQAZvqtcJpG
	hb3f0qAoouMPKXEurZUhtJg9bW6vAgI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WVtQaFYg;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-516d43a2cc8so1636251cf.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 11:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779389664; x=1779994464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O43uMa51N36nEinrWO9reEuS/JlOyHUwEmdF+rTGNKM=;
        b=WVtQaFYgvU70UYuqzudt4GnbKv4jqm0xDMVi/q0eUdWG5Ey94z5AwxL+2sknIwJCDC
         X7hI8phZ1NPXopRIu4WngINkcOL92ilFE53qSNo8PFUJxFMx7OEdxGYMlBj9gp4YE3zq
         mMveihIwiSHO2huRDmU7xf89pIAG0dZcRlBtOJF14gjHra7/ssj2tQlF5CPBWXmbkL7n
         fOFcyfTvWdjwN++ZAsT4QhgfOOFbD8K4FjweTzlugpgB+moqgghtWWjtMKaspcMQ2sJO
         RAzAzWAvJ2HIQ3tYQ46H/LLNdXK+UlQKdOib5BLnWGdvoMN2CM+hZieMunaP9IcVyNJi
         Llmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779389664; x=1779994464;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O43uMa51N36nEinrWO9reEuS/JlOyHUwEmdF+rTGNKM=;
        b=TU8+kj8c520dikhMsbV6/0jFKWpYiiLRoAlsLOp1STU6gLteCGECeYB5pLEYB873rA
         ugNf9+9k7rOXbfePPqmHKJA9GV35Jm8P7sbkacDTiGKRmPpbPIA7B37NzvX8JosXBcFB
         JR++/P7+r1CxPWJfXzav8Eoh5SwUwJ4M+5QT88ogQepDiPJwhKAzp2z3qwoK9CXbL/pP
         JTfyspPjTNCC5cGg55QjrkjD2NFFHgoifg7jvg1qdwNZMgo7TZNABauDXomFwg8sc3bE
         jN+jWVlmKBSiRy3EE4hjSlwIDJq83h36xK5o4O9tpSxQgZUI61XvfhJa1iBTG9EZnwGs
         lFHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+AqYste3YfMUR2UY6Ej82DjqDLmCqW9nLSwL8OgOkJ79KxHB8MAKMj/4XqaemsmbFIJoheIwt0nw==@kvack.org
X-Gm-Message-State: AOJu0YyBmPgqPpwdOlZT361S7bmmqSMwmJN4Yh3yVIVpHjvRl7HEGu1L
	nSB7rOwqg/J0U9+UC/5OMmyj2xjHANaLB7xWJbUCZUORSZj50yHrAhl9tmrIIgcMseimHLlDZ0z
	yHopF
X-Gm-Gg: Acq92OGuY5jfKBcy2FYEK7tTwm+zn9N94Xi3QIBhhgTU9A3qGbvrOFGVB1Nw4XWTivz
	l8q9KQkNjx51DcB81pY6AEcA7gDD+iwvc6jtYzpZHoYUXeWZ2z9Pj7ccI0XQQLdATX4LoCgP9BD
	hbsXaBOyZYG9k1woILvlh2C0sMAttMFEs1YgCX2m4OutrF9IXXpBGC8C6cIBaf9BW2GoMx+cb6h
	q2pmXOkZu+mKBhCvnJRykQ0shwwHeXF+L7tGesucejxgUpY5QP369teqlRTwINoDNfvQcMVRhZl
	AbfHV5g6dBf1IKFNwXTMmEDTDx0xxFFCTyd+u66bbYpdolhJjc0DGCGKepOceoP6uwFr/757kLy
	ZlQ+4429JdPDEq/KL5m2vi6WwvT+WNMgBoEjEMml3CG3BuwnU+QniDVgf6CZBQw2XXSJHNgZkvk
	WFDhiSLcT2jIVN9npO/HQrUVM0h5uiL3jcmUDDkO07SXtgAJBPgoVUKn/4hPSk
X-Received: by 2002:ac8:5912:0:b0:50f:c1d4:d9e1 with SMTP id d75a77b69052e-516d4376f6cmr8327631cf.38.1779389663980;
        Thu, 21 May 2026 11:54:23 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516ccf4c8d2sm13751251cf.29.2026.05.21.11.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 11:54:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Changyuan Lyu <changyuanl@google.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260519160554.2713361-1-pratyush@kernel.org>
References: <20260519160554.2713361-1-pratyush@kernel.org>
Subject: Re: [PATCH] kho: make sure scratch size is always aligned by
 CMA_MIN_ALIGNMENT_BYTES
Message-Id: <177938966317.1212271.16034923918291092372.b4-ty@soleen.com>
Date: Thu, 21 May 2026 18:54:23 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: E9D3C40010
X-Stat-Signature: g8iorkq4y3ixajfryntt38dpnkqiwqai
X-Rspamd-Server: rspam06
X-HE-Tag: 1779389664-499855
X-HE-Meta: U2FsdGVkX1/q/SpKiNsWRD09SxuhgbwyTo7DFKlwzHnDki/lZzT8t2AnfRxK/L6OFFBQiSpsv8aWMa5dTmL8OrkMAFPs3miONsNNjn4glZSvAN/ccaUceskDC39RbnSoFH+IfIdvqhTiL+SBRq+n3PBbYf4c2y2XFCxc3mqFMtP+4eYgwiL9AMFhg89uhU/HBMesZrkp5yszjpP1ceM/bErY5P3QWH8p/03RzxzyWhiqF1SpE4f42amIotc19FihVf3DZ70XawjWaYvb6D7a/gqdmTSe+ViPCjoKb52GhcwSSxZLEP7nNxFh2QNZ+ICwxMr5F2KlVCXB8gA5Q56S/Ebe78jZXWHi5EHwyOCvL/DNziBogUPZ7UybIQYXY9oRMFmeR1qKEe5GM7l8atXm2t3SK0fzahVgMDzQ4QQr0HZI/UtVZUvaLLZ/3pTShkJ52dG0xRLTpZI8chgqZGpPyYk+ZYXYtczaaN09dtKRz/rbg/zHIQc61mfDpAD/rAxWHWX5E2EnGmyUTIFmcPtOi1btPQMH2yYeBdAY0v8YAqi47NMmB6dQUtZi3ebFXkGHH1qUlSuL0lnj6aagp1+B4baOjX6t+y/Bfh4Tc5x7JYla7EOrKrs2AI6l8/9ChYzmFVQfgm0COWNnTIYUMQXtIQHICYDlThhtSXAh6O+vt8Fr925CtmSSG8Kfrq62vME96QaWcu8h5HPHC4XUV0A5HWTUBawYUhwRbAIMkQYirXRESOgovZn0D9YTDfq4d0J48Jgqy9MHw9tq4WefGtnfB/WaWvQq1yZdPSQt2iVa6J1PtxHQthwYfshleOnTarmSs9nBhS0W7CSgRsjQriDIEXmFigkflFFkUBVMKA930Ge9KNc3EiwxtwLM76EoDrx2h2dAzk0DQGKsKajciDPCu0y7Lb64sVWCzIR1zf9OtP6Qs2xyp9FN4GqTwNlWXPmanj9+509+8UQYk+rbnAa
 NqBIi0Sv
 dAWN+gHyOF0BGLKmnSA/SDDvEABPtXVyh6z2gRbehta0cUIynCu9Yng+GvOZRFZPljwq5yHHAQbmm/c4AF1g9V4A+YWwqlu2dYT51xD+ryHY5UmwkigAFCanpH4k6ZvXuBjA+9b1qQDU8yh2vJ3iO1l2jBWn0ScBhdTyZ8zMqOJoW1Hel1sGQ3FE/LMcnU9+ajZDbfqdI+xYjQlagHgtOZyUCSUneDonrymsVTTiO8RgmJ7pNmsGL8M9/5ne4H+kabRmgdiuB2wmmbbyYdkYoqRGhPp2raU+/AByYkvE12wy/ZZvWolFDQDEQZhQXprJq0BrGSuUN/BWgxVUC5Jq6V18gY2EcZjcvkGMbfsaeaLeIOIGtcvqDpX3US0BINgokUoH7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 19 May 2026 18:05:49 +0200, Pratyush Yadav wrote:
> When using scratch_scale, the scratch sizes are rounded up to
> CMA_MIN_ALIGNMENT_BYTES since they will be released as MIGRATE_CMA. This
> is not done when using fixed scratch sizes via command line. This can
> result in user specifying a size which is not aligned, and thus kernel
> releasing a pageblock that is only partially scratch.
> 
> Do the rounding up for both cases in scratch_size_update().
> 
> [...]

Applied, thanks!

[1/1] kho: make sure scratch size is always aligned by CMA_MIN_ALIGNMENT_BYTES
      commit: 4129715f7ac5b71183350f1983023caf0464cb9b

Best regards,
-- 
Pasha Tatashin <pasha.tatashin@soleen.com>


