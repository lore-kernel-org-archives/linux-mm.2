Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C65CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D00E8E0006; Thu,  4 Sep 2025 02:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A78D8E0002; Thu,  4 Sep 2025 02:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4318E0006; Thu,  4 Sep 2025 02:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3468E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:23:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 167F2140A3E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:34 +0000 (UTC)
X-FDA: 83850576348.27.E362EED
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7CC69100005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=duCVIiLa;
	spf=pass (imf14.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iD9qXxSucOp/PG/eqVieT3odEBQZyOB1iznXz0xHs5E=;
	b=X33I77Bwq/VL5fjsIYVACtphPq7K2ZzLKjtEYJlb/xfptd7Yx21fyv+HiujL9f/hbhwhwr
	o2uU1mjFbKOFfjWRXtAlFrcD1zzKA8b+l8htfngELOS+rv3DoyDtR7WyYJbs+Wyvjp5VTL
	e8BLqoChV11Jq+DK97Y83iXe2hqGHZE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967012; a=rsa-sha256;
	cv=none;
	b=fWe0J/7gxA4RnSDsv8sYvU6sOmAwNw2ZR4SFA8UlErK3dEg7n9TfkKiSUgSsfO/49tq/Di
	Nc95DmlrkVgDOjmBK7V5PtSSMv4BfXsQUurlZ8yasBqZ3T2n4kK5baSoe+OA9WNtqntwaJ
	bqPjj/FvMAx8BQJx7f1SxiBQW1uYrV8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=duCVIiLa;
	spf=pass (imf14.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7723e5018d6so69832b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756967011; x=1757571811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iD9qXxSucOp/PG/eqVieT3odEBQZyOB1iznXz0xHs5E=;
        b=duCVIiLa19f+2TAYrvFUr74N21mxrU48CLRezNdOqGTKgKSGQ0sqZYRZbnUssJU2H0
         g2di3gH1o+kbJ/8usZ7cQJ7wdZq23151Wtv84jwlBYkpMKyYDBfUkBqe51K05mjb0xE/
         JP4PBd5MC2ZUy+EWsW/XjA3wWCtSJ+kbjQlkSPvDH2+ZgMLoIhfug5NNTnLp7FpHZpa0
         aGWrIXD0AjyQsawGd91lq/HlQLZz+xVBwfVzb5P01h5J5VBkNtEg7a+xV6qWItooJ/i/
         Ui15ejfp1oW2UeeYHRBCB04A2O20oWi+sJNUGNYi4LHfkOedu13BBGPpk6yoYWVFycrr
         TPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967011; x=1757571811;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iD9qXxSucOp/PG/eqVieT3odEBQZyOB1iznXz0xHs5E=;
        b=E8RJWVctCNritLaeLyecBaGjY5eCMDc4HE851pRkF7AD68gKUqyDl8eMMUKmDM4gUT
         IO3nMJS9Bm6DkvaBDNQSnf45/1sTIE5HOIdjTAGO/PdCvQkFvrYwWsj75ZRF/nc08yYa
         1dja3xRmqG/FHGwCTPi9/heURX+9MveSQkmuaQE9OdrK+Ldzz4gRfJANi8erEGon4iw8
         2KId0tB9jDIrVK953iEJuQM7DH0D/O853FoeIrhPF448UH5MoQMzjugKhQ4ixtiX4P3/
         gkzuOLO+IZYWY3BympP8DTcO6RJOW3VodDN71KqTHlHn/yF5YT0tVudCSvnF/2XaVYTa
         qePA==
X-Forwarded-Encrypted: i=1; AJvYcCWFXieXdA7m/wTituEUcNd/nWoVV4SJPHyqoYflcE5AxE4OELB5Ud5tlLw+0KJrgby1pwtB3FPvtg==@kvack.org
X-Gm-Message-State: AOJu0YyZiGNqg6VbjcICn4czuZBkroGGGpgxjp9n9FX6+ZmH+WJ+2h8/
	BrmtDq/nUPcTfI2Eitz4j0rSbLGrVcgYuzUVwQ4lPaUJtY7rKXTZr/Y6egQZHeb2
X-Gm-Gg: ASbGncsbPHIqqxmIds/Ei/YGTDWjmp9mLci5PTr8CU7nj7tc6G0S8Pt39W9il6Y4ULu
	X3FaKDzfl4YfBMnVf64gNwxTSPhdAl7YimovlEWcEr1oQaWTWlfPxVLee0Wucjil5PYQZ3yKJ3G
	Y087XzdJxCmHUtVme5XWlPeLv2hLNMxUeDtXbOwSGCWm9q2r6rDdXNixNliqz+J/onOrmounLw/
	Mq5UpWWa87f1XcjSa+G9zEGr+ZESPb5cEpeERxple86fIKcNyfzeX9B8Y7KofZsqA6yMKM/soCu
	PvcwkjHcTuyVC77tKB1jSSuEOEYhoi4W9Pl7GftbdR8AhdMC/2uZNMRFRK80RifLjTIgifubvsv
	olFG2kdXhnuOSETuGOHAPNHMOh16FB2tX5BKlzw==
X-Google-Smtp-Source: AGHT+IGMQlpjlHcvnMvknLAgcjlNDxqZvomUwOkb55yXc59yTQ6MZCBiaASIEV/7XtM6qZ3h75IdOQ==
X-Received: by 2002:a05:6a00:10c7:b0:772:db8:9de5 with SMTP id d2e1a72fcca58-7723299b526mr15406179b3a.7.1756967010841;
        Wed, 03 Sep 2025 23:23:30 -0700 (PDT)
Received: from hobbes.T-mobile.com ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7725f0c4008sm10198397b3a.35.2025.09.03.23.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:23:29 -0700 (PDT)
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-hexagon@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Cain <bcain@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH 0/2] change "a mm_struct" to "an mm_struct" in comment
Date: Wed,  3 Sep 2025 20:23:24 -1000
Message-ID: <cover.1756966290.git.joeypabalinas@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CC69100005
X-Stat-Signature: mboq8wir4qf6exjdjqtes4t1rrz9djrc
X-HE-Tag: 1756967012-535099
X-HE-Meta: U2FsdGVkX19TEIfSdYwOnGjBC/LV3ky4MLb33sGQxmrDwpjW7E6/lqE8AdpGyH1QvWXVCZJ4jEZ30oc6SV6XqU1h7AoLB/l255AiELZHw+zJndsehFckyo4Wws+5fdAS9rgb3pnQ/7YyqI6u03q+LKYfaP/7uEX089m4tFt0uQkojTzGLSFKR/SLrSkzGZdtPMyS4nShCIBla2n+rcOkFy5Ikf/3LOEQ7g5ucQMI2CH9gxnXvxyEToiAM9cAXv6NK9J2+ihw3bGKvwM0TM56jXTKPWDb/Gm3FZyOY1oWvVdKYAst4cWSoVxJWO926YbGr6Xx6hTi0fItotzZ3eMiWhoYt4IjFmhYEeNLmaiCt9SEEO9ZXFJ18u9UdjqNtDCgqdhv7B0fmbcedjq4ruSkXTayC/9l8PRbX4iqCBf7RSIIQ7+DO4rm3RJ9HvidbAbyKycMHI6YwBFLoLeZKng1VlpBEbroyTTCv2wC07D0ycyKYSK0yWjUnANCfPv4inY+H/k4zSlGv9fk1pyxr3bWu3ZsfJZARGHhaghvTPEMw6fOZM88e6TqB1GmjhCsGDsJ6Eqca5kLKSUxQt5aTXln2QJUAOrM3xJnOaVOmJ30A82Ay6MOHt07a+sNNS709afleVt+0Y21lcCmB6yNBJoOtzVN/wNN7Vg0FvLBoij47b885YO1QV25EOSyO2u/VLWgzAi1KlVsZcqJff1yP1fVCb0Z7RPh+3k5QLJ1dzD0SgtF1FiXXSMfEak1sz5lCeWVPIK4pNq9HqunzNmoWOIDr/Kpv3nXG0lVYkHkzpfUrxCFfACn8EqbFDHGaoPMSMcEde44tfx0bIKQrBu2wumttun3QSt531zQlZHeSKmJkVbnvS3ubLiC8igyd+INVJ0GzWlaOJDKOGpBBOj1pcA/VEd6K7uCGZgTCo4kqHuNPFe0q4l7yB3ePkHUDC9nPRX/YZlM07jYfhhwZNsfVnA
 3EYucsl4
 lD6pomtacXcDhD96S3JMFjOOK/1XoNOfRWjEhg1Tv+RHpjo6T4+MzRYaRsroQbcSpWfmNghXe95BgdKjYfhBezMzi10t/nN83ZRTv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000021, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The correct english is "an mm_struct" which is used everywhere else
in the kernel.

Joey Pabalinas (2):
  Hexagon: change "a mm_struct" to "an mm_struct" in comment
  fork: change "a mm_struct" to "an mm_struct" in comment

 arch/hexagon/include/asm/mmu.h | 2 +-
 kernel/fork.c                  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
Cheers,
Joey Pabalinas


