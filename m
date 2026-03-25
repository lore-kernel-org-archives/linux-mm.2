Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B08109C055
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1A06B0005; Wed, 25 Mar 2026 14:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 652D36B0089; Wed, 25 Mar 2026 14:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 541396B008A; Wed, 25 Mar 2026 14:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 404D76B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:20:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E117E5B867
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:31 +0000 (UTC)
X-FDA: 84585400662.11.257E2D8
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 21D42140002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:20:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bmDIgGzI;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774462830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pqftG1ACYGHV/eDENSIw/7Bl2OYrvdNvfOznXOuZm8E=;
	b=iq7t9HzB921BOXeyK3CU93PeonmunVupBwWZFcxHy8WEpckdNj9nCfsqOUv/VuVFpOWBPb
	h24pKlMw8mwv9HBx/XDRV4Jt00nb67Yur5rAWvmIzjZF1HOkniEapNnVuk5tiW9LYnqNlS
	PDNxSX75g2NCsn9PHPTvOWvH2UEZWpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774462830; a=rsa-sha256;
	cv=none;
	b=L3Z8mwGGUdKB+y0t6f1dSY02DO7n9nRBVYqrAho9u3myDSLWTmyEnMiyjX7zx22w5OGWep
	NJSYnfzSq/ZbU8pQTdc+qLb5wjllouc84NFRgmvX+o1QfN0mW+G8crwfVjiXF6YbL/P1SG
	5QahIIe7X6ifOrF/d9KxB1tHjzQFBs8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=bmDIgGzI;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cfd44fa075so29940285a.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774462829; x=1775067629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=pqftG1ACYGHV/eDENSIw/7Bl2OYrvdNvfOznXOuZm8E=;
        b=bmDIgGzIrp3gbq5Gm1gRubWJjVOZywllhxl5E+RO2Djs30jju4Gd6mHGZNR9CpBfDl
         SA6dmyI/7qglL1FivE7i1PhQfKyCWwdV8uEBqPLLa3vgC3IqA/L5dfg0Nsgp8LS7FBwk
         3J4rXOPuof/TuZaVIkg+1gnMM9fyunPWhw5JYxAXYnStZXPzWg2t551Koy4J3j+o4j6l
         /mBeeF9X2/bNeZ+YIwm81qdTHbOQkXQPpKcQsgyN5kb7+z1eTgOKa8+FiJblnhv7QTMS
         jiPcFBwFONfAKGrKaDh55+ItSNctCAD2DBYeNaD+OmXKPmTpVLu4HKyY3iozGoJHDbaA
         gyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774462829; x=1775067629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pqftG1ACYGHV/eDENSIw/7Bl2OYrvdNvfOznXOuZm8E=;
        b=BXe+obh0ZB0lsPmBVfsUaUvWHYgbF+hEUHuXGY6xIB2pmY6pvLzhfFiF9mpqPPLhjU
         bIRwSTXWsEtGpcahjbSUnd7uVa6bRR3ZHlgHsMYhfvw5shANMLzoonlu4hcrtpzSe754
         XKa69y6pdqP+hmoYF+yIkShuoealb1nr2dQC2dpUBNmuJyTtG4oKd6B9Sg8rRGK4wn+4
         Z7X5pdy7hFFfK8M3ubkBJeEATo+sin8LC7fo5V/jZx9/IaU13+6U5smWFPCSbvfsDvDJ
         iuxHQz42HxdqDr4O80nhA8nYrzCyRwlYs8zTT8NWajWEhEj3Vy0D3Bfq610Xo4OrVDeb
         DmGw==
X-Forwarded-Encrypted: i=1; AJvYcCUCz5rzR1toGUnU6v2y9T+gsNqA1Ks/az9Z3Ax0uCikIixsjs24aAr3XSYW8iTqhI1yG2IM1YBPQA==@kvack.org
X-Gm-Message-State: AOJu0Ywj060TfLjUZHrD6J773xEUmj1lJYq8Q1QdKIH2GkD5RsvR+ktW
	fqZmkoX20MxxSAUB4gOJb6exNNfrQdycO3uLfwC+Zrj68Z+AA0mlhd2VIhMxYzmmbNw=
X-Gm-Gg: ATEYQzyXIdDfrhn0/bW4xDnHcKJESA/WT5w1oVIipqhhLefLtj3uPP4sOuHH4YqvMSz
	qHEs9sZ3UjBOp4+cRObO5AnOAHL8qgm8gW3Ps1SaW2u8C2JaaqDtOiiU3QZ1GnnW073Vma25ROB
	5tjvoKROF++CzEaRTY7m10wtiUfjj6nx1CpJroxdI+jNMR5ctqvmTvvRn/XbmqjuOkpSczYj+UY
	JcVFbR5B4yrK4LnGNesIxI9tWpaupQVIpWWggxmh4S5pLvu05Vj5jutatF2E9xDTAQR1ot9HGgS
	MZQ2J/KkCHNYGsVpoJdzSNI8H+e6kBb/j/JzGpLVB77jvlvLPeGxWpv9IrGHz0ReA8DvlEdkgbn
	5UjjzRzvoCSMQoka92pQ/tN0TvhA9QD9i5qFNLQ3a9UPWb8L834HSez2imzTX9zt5WHrm474w6P
	b8vluhdFx9tYIuV+qIcBSldWGJ45ik09QHI6ObuLlP5+4+zOP1TYlG04rTs7QS9hGn5Q==
X-Received: by 2002:a05:620a:2584:b0:8cd:94a5:2f32 with SMTP id af79cd13be357-8d000f55d0fmr631636185a.27.1774462828756;
        Wed, 25 Mar 2026 11:20:28 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e250556sm64225385a.0.2026.03.25.11.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 11:20:28 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 0/2] liveupdate: prevent double preservation
Date: Wed, 25 Mar 2026 18:20:24 +0000
Message-ID: <20260325182026.467307-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 21D42140002
X-Stat-Signature: nhyrxrhp9364fscfinhunk6na5h9zt96
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774462829-135519
X-HE-Meta: U2FsdGVkX1+6Wc8BU6ceN2wOqY2ULN9aHD+MayjehI4V/3qTk+3YXJjaxwtE6XfZUlDWkvLydjC8m/1fccuHYZ5gds2Wxu/s+55wuwQT6qHZsbArbOXd914X/FyftBaoxIydzJ9QAdKiHUGoS2PJ72f01j1x3ozha0U1uIQJ+cS9glD5J2f2QCu+j+Afs3U7GVH4Yl+M0JhwkfmfFkMYuJUtx0qfJQ3k/r3/k55DAnk32y/rN4pkyx2QQN5h1P5HPmxQ4SmHmNSs1xn4bzl8jwzhgZ75xqkEbsG7GtoFF5dMXRN4vquUl/RqSQ+/D5ruKODvokrFFJL+HNP2zTW26Lb18u46wv/TuY9uEpJP96maGGsTgmTHKXc+e1uozIgr3YWOt9zYx9uiPsxE/73t32RtlRBo3chd21dKk6eaMiss74i3bXxarKAd76YYFT52f1LCPIqSZxe+5fAlUEez0j02QZzdHiD+J9ssF7zB3JEcFMiNEFulUt/TEWWSoSZVgOgPwdAKov0K2BqrGRfYeCdoOPY0xBFolfF+SYcrTyj0qS0SqCJhBShaitJaZbRar79h86iTWaccqNlU5nfAgNMY7inkmYgrBaKjS+G0JT4OarlIArehkfJe4ZLCLff3PiuWV9YWdB0k3W6oK6XfWqMYr+W5vXBAO7h3StLZKsSTR+0kjgRr2COHhTcWzbaS+q96E0F3VFSCivLa39bBJgHScu4uCEdTpcVmsqInsXM1yod3vlMAr21W089qJPIrgNpvcOzWE6iAYH51f43Qwm3oWuzrnYd5p59ZmTPYKHw5Vv3U/9rdAX5hI6k/nxQjVYwKm3ocODsGFVzZhv80ikENepvNrzvkXrkaM2L++FYgKeAHeXd2ZqJ7XxesvAadWznGeDrKPdcAWPDnRrlypU79MtVWBrlAPRbyj5bPy/k9Vks7662hHucwevmvfEDws18jQZ1dl1SbF3elaXb
 OtAqJgLb
 SAjQc91OjzyzPAWyNg2CYvzcMVhkUcc7liC13dF8u8PX5MlbDzd4xkB6Lhl2kCpEDZyue1fKncAyb1FsdOIVIiwN5qB/spTa43+WgyfWjg1rs9Gs7joEdx32mfm4kbvcU21mnVl70BQzCf1n63pnfp0WMmCNW/6ZVDVVNnWwrfFRE8VrGbPhzoIGH2CZIme/XD2gKije6LOA8yX1kynnFBU0aYDd1Psu7m4ihZVmZZKD+by5HhhjcpOkcq3QFhkKaw88eW8fn38a9IKKbpZwDyZvKGm1sLe05bB0RONrY/+g1n/f1UPx4E/pP9GfOuMludwQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being preserved twice
across different active sessions.

Because LUO preserves files of absolutely different types: memfd, and
upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.

[1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com
[2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com

Changelog:
v3:
 - Renamed luo_preserved_files_xa to luo_preserved_files (Mike)
 - Added xa inserts during restoration, so a file that is not yet finished is
   not preserved at the same time. (Sashiko)
v2:
 - Because inodes of preserved files can be shared, we cannot rely on a
   flag in the inode. Therefore, use an xarray to prevent preserving
   duplicated files.

Pasha Tatashin (2):
  liveupdate: prevent double management of files
  selftests: liveupdate: add test for double preservation

 kernel/liveupdate/luo_file.c                  | 26 ++++++++++--
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 2 files changed, 64 insertions(+), 3 deletions(-)


base-commit: 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
-- 
2.43.0


