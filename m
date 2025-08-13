Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7BC8CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4606B90008B; Wed, 13 Aug 2025 09:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410BB900088; Wed, 13 Aug 2025 09:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B14190008B; Wed, 13 Aug 2025 09:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE66900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC9FFB76D4
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:35 +0000 (UTC)
X-FDA: 83771886870.23.FFA8B60
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id E894C10000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BngOwByh;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093454; a=rsa-sha256;
	cv=none;
	b=4wxhmnt4z4ramqTnV2MYDGhxVXsv+Ft/0Jf67DyykCBl6obedhk43xhL2b79bz1utEsnwB
	II15aBGenZDtweuBuQrrgBIZd4iSnP30AOKwRieAouVXWnnI5ymHR0axpagLsGKLjv3z2H
	eqOmzlvIM8uk6NpvuUDZSYuQLB/y3p4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BngOwByh;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8KvrPpvE8O7r2ITHiw0xMgvWGn8Fo8lwPzPF7CGMas=;
	b=SMcNpapB376ikewZLsrLAZlJhIUQ8OK+1ctBzcu+M7AqvtxZZKZiRI18g/sFKfulWIVL7N
	labDnZnJvNpyC+TL8s5afJyxqeYb4+Xz0vjQLUejTFf8u2CRTpVyy1+3GFbxWznPSu23Ta
	bKEdnfDyjnOHcHAIeqCakgIst3W64uw=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b070e57254so76878181cf.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093453; x=1755698253; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8KvrPpvE8O7r2ITHiw0xMgvWGn8Fo8lwPzPF7CGMas=;
        b=BngOwByhvmDIbMZfbNEkm/RQ0t4IjXDMckGbrgE4TtSnJzsZzqkneRXsw7aZTwojxm
         +b9zRbdszXTP6S5Y+qo7ClRj9g4lb7JHUY1I7l2QWKKbFTdol9cLupgRtQpP441zH3Ey
         O/zN/UaF42DBIcuJ4jMqjFHvz6TCLtYxjLULofEM56G/T8UdGOEI54MBUsmtE3TZOm4r
         C8tR6825NuMc6IjbpIISP/rqZczIN9cmvDOcy5Bq/1uXWZ98rpaXp3z/qhyO2PPG6EQY
         nqSPHTIJ9ncl1tI/kyC/wBqbp5oNH4Sjtzk0EBxZHJ4fkGtXxJfbXHkWZUsJyzaKyD59
         fqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093453; x=1755698253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F8KvrPpvE8O7r2ITHiw0xMgvWGn8Fo8lwPzPF7CGMas=;
        b=Bj++ZHNdEtWosfMLjLvHrfUwP9WZVOsseEIyxBKvjsnft/sp3B4F+vyah4Gny1tA3m
         5o1fUqa6porjysaCyPvq2H4goqRk9ckiRnB3Z9fL+RFiBHWc/gDWseoFhAaPEYWcI7Lh
         mKoOB1/XrEiBmmyeogkQSCHPAOli6jo9RJNzxxmvmEUcAchO1+hMwEz2Bo9rjMZ3zbDA
         xNnFKkjiRjLikffIw2qMCtyglKyWYK3SlLFvFyzV0DA46xqpMwkJgbJiOOAKYhzs7Zwl
         rKxDp8Xh1jir4qpySi/EE+rtOKBeZG4CKtH5VVLx99OKqj7l975dAWhwqQWmzXVnQ3Fg
         kuhw==
X-Forwarded-Encrypted: i=1; AJvYcCWhfTZoelqo5g7mjiBlDrJ9bDMQFdfzFn9jY2ygmOXco405BdnYOObEfgBqAMr2wkIBnvlmCUUZHQ==@kvack.org
X-Gm-Message-State: AOJu0YwBbfHoWBHj5/BPrl6fug+CEVv5GNLu4ggbDX+qrW58K5Za3u2m
	0TI3Fa/4lLMNukl65AcukAaQgK04LUp+BTIcyzDcuVDHepbphgJsSpfv3E6r65zr
X-Gm-Gg: ASbGncv1vvTMV1k1su2CoTJfLeEpHzEWkb/za5arMooNR8E6mXbTveJLFL0nk/YZXh7
	w2+KG2nrzunRA0XRMukc1S8Wwz2Vz+K4ROKncDoLIyDvwDjhR1XpIEj6dRdWFyjfhaJDQAAknm3
	PISIQBDvAXX/ul4lY2UE7O793hPKkm7J35LXQg7eJyyjNgHEqwLoosXtVRjztm2/rMelAynW8iV
	BufOtbqjT2lMKia2RCeLKFRq2j3WtxamrXuiPnH0jGNMmiBnGsaRhb3YvibnVuMXV/hZ00GVHY4
	Njmd90VQMHls3F7hKGDBKXAI3HiaBKdtqMlv+0SwerWG3jQ9Hk/nqwOOWQVQzPBOFa1LQQv8G1g
	rRNHxphknw2rlsZn8l7Y=
X-Google-Smtp-Source: AGHT+IFO7mefK+rYFXL42NudjKdK6tfjHKCVAgyJ/AZ4W5tZA9XVk00/ibsX1hVezDTws24ZfpzPCA==
X-Received: by 2002:a05:622a:1184:b0:4b0:742c:e8e0 with SMTP id d75a77b69052e-4b0fc896084mr37283731cf.47.1755093452947;
        Wed, 13 Aug 2025 06:57:32 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b081827cd7sm120357531cf.7.2025.08.13.06.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:32 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v4 4/7] docs: transhuge: document process level THP controls
Date: Wed, 13 Aug 2025 14:55:39 +0100
Message-ID: <20250813135642.1986480-5-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E894C10000E
X-Stat-Signature: 19b1f6sf1tkbwubub7tf1p1mg8if9o3c
X-Rspam-User: 
X-HE-Tag: 1755093453-692291
X-HE-Meta: U2FsdGVkX1/gvW9+AIlmQk/yYGsuxQ02ukkob+6hwa9OHyBf/8evVUXKJgpr1hIyKVqjfYJzDIJKr0lHtsTM57QeWEHYe93UkHPIb51CPMTetIxlNTG4sYLPFvE7Ew0/nrD5p8Y2oLyIFFO1fFq3YymKjgn2v2rs2NiYJvuNfwiGSUJ2HBNrqw5DEc5hl+11JCqqRJ2soUI7Vic3IqnW1GrGTSD1HkFcbnrgqkhBFHg3j9WYZnING9b3vNmkqu28jT7tDtpQ+pjRSkeZ0VBuIXFZB8uAntE2Flkd5rhJCqp5CJjtCGf7iw3QIx6Th7Nab70n1HgwmUsmdJxmO5YPtALwz4TU1BN7WMULht5e2MkV3CccxhPFZLu7Y7BXXyPs7/EdpSASsmyuK+bvQaLFLNBsG/wuJwQkzbsfyhrxPOVCEiRMifCOktlPpJwHAbOrHLrHQOlE9gU91Of2bNx7Ac8eySgcxotXJ2l4/37JAoLpTlZdf0UlyXKPpQwpBWhox62eO2mte5Nz0i3dcq+VCUfxKgrM9lB+tGZSSZ/FCJcz7RlrQDrrF3eZTJxD/HHCAwrcW8MpOgbVH0FRCR7g0DtfsrtbbZ/CSLms+0OqrZa2Dd9BC/BHZT3jd43EIzsA+1CLpSgCCSRc6tlFclfzhiuEIlg8M1BUBIv7Qg1nKMqugVZgKgYVQVWFhCfJuCwrC8ffIXzmfuqCXBqqa8MwZmkWIdeLb6JSxjzPGGv3PTuB7zQf9riR9yOjHXPqO7LN81jWD11cNuJwbEqdmFfjrk477LGBst/h9LnHbQKLkqYSELqhLbFu2oZrzULl16tL8JHGdIF2GsFIFqR8tCF1nXBNeO8XJ7COU5/XNXwF65LOCghk8+uJijC0ZfK70g/N/HjIb0rjKPW9+Hkkm5EwlIrAqnlzSrvsuKFT/fHA6/dcSYGo4V9QQG2YvHIc8Uy3cHRvp5RxkBW0BBbGIRX
 0S2FI0bp
 MB3vsoMPioSGoOXO1xmqI8OqacQ/EGDGp13jI/DM+vjJrnFJ1k8UGv5xEaIDTZvubREM8hhkfp4a6wlegqP6Zdl9+3FSP02YH1ze3tzOkDyYkVAT64p7TzbillM2Q95k9fyZVD+BBOswBpy5JbFfWVCrL1QXvXvCA0D6fa9zGhxC/kjnp/6z25cpNrGrLsy7TcAi0WCMfsjAQ6B3XVMkxsOwt0RVDkAdgavzIGZVS2z994DbNg40PdFKQmt2CKAyy1djHCcbfS62uMsLUP2Tdr7sSmn0kc+hJEVZaLah+dt0KWRTfnvQAqOqaxCYLIqOnY9zczioqw4b6laRe6qy5emyqnfZJxS7VzxxWpyeZh51oAKggGF8ZPzmuwTdO4HRKhAFrxLTo8l6ZZGiae73CPuwu5oJrogQZ+Eqfo+gpzOw6hK+O5WjaqOMJE3yWp2U7kRpz5mnx+4jFa1r/fYUHK26LvB6//n7iy7Mmuk9a4Gt41tFRu6hwzZBnSqamMTPORdZG4idliQS+jpdq7tOaeOzWQacTzxpmau965Xk2PF8gdphPDOZIfP5RTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
flag for the PR_SET_THP_DISABLE prctl call.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 Documentation/admin-guide/mm/transhuge.rst | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
index 370fba1134606..fa8242766e430 100644
--- a/Documentation/admin-guide/mm/transhuge.rst
+++ b/Documentation/admin-guide/mm/transhuge.rst
@@ -225,6 +225,43 @@ to "always" or "madvise"), and it'll be automatically shutdown when
 PMD-sized THP is disabled (when both the per-size anon control and the
 top-level control are "never")
 
+process THP controls
+--------------------
+
+A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
+and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. The THP behaviour set using
+``PR_SET_THP_DISABLE`` is inherited across fork(2) and execve(2). These calls
+support the following arguments::
+
+	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
+		This will disable THPs completely for the process, irrespective
+		of global THP controls or MADV_COLLAPSE.
+
+	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
+		This will disable THPs for the process except when the usage of THPs is
+		advised. Consequently, THPs will only be used when:
+		- Global THP controls are set to "always" or "madvise" and
+		  the area either has VM_HUGEPAGE set (e.g., due do MADV_HUGEPAGE) or
+		  MADV_COLLAPSE is used.
+		- Global THP controls are set to "never" and MADV_COLLAPSE is used. This
+		  is the same behavior as if THPs would not be disabled on a process
+		  level.
+		Note that MADV_COLLAPSE is currently always rejected if VM_NOHUGEPAGE is
+		set on an area.
+
+	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
+		This will re-enabled THPs for the process, as if they would never have
+		been disabled. Whether THPs will actually be used depends on global THP
+		controls.
+
+	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
+		This returns a value whose bit indicate how THP-disable is configured:
+		Bits
+		 1 0  Value  Description
+		|0|0|   0    No THP-disable behaviour specified.
+		|0|1|   1    THP is entirely disabled for this process.
+		|1|1|   3    THP-except-advised mode is set for this process.
+
 Khugepaged controls
 -------------------
 
-- 
2.47.3


