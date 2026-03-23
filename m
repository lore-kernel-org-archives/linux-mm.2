Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59731F483FB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861DB6B0005; Mon, 23 Mar 2026 16:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812206B0088; Mon, 23 Mar 2026 16:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F876B008A; Mon, 23 Mar 2026 16:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 660886B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:31:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20902C3DAF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:50 +0000 (UTC)
X-FDA: 84578473980.23.D09CB27
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5466A140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:31:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dnXNluV8;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lwhk6av2PkVV2YHn7RPTrkcAgzWJduOS9hmc2v1dRNM=;
	b=gME8aA0k9HpgaYTkp5/0TSIo0zp/OUzECAFyuQUwxY/dCVZWqH4zfZwqPZSSMhAZ75i3Dy
	0BHdXmz1PZy2kLD90yFbKpdZvn2SrPy9KCl0HsLqxqzP82KQGQSr8p20Jx9L0cp0nXSPz3
	CUzdFohu5wKiuc9NPUtpMGzWt68lsO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774297908; a=rsa-sha256;
	cv=none;
	b=hHlXAeXWGQkoFF5W02BuHoqX+5GW3nx87g+OaPpurFANqgtueb1rSOAVQQTxPHe2F9FOTa
	69wW6Fmj1xVKD1M4IyksYkinIZ2av5VjXGi6GrBEFbQfc5NEK5IV6LKS4K3ezo7wAwAXX6
	3xgSly2QHL9Q4FBI48keGQ6JKCqwq5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dnXNluV8;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-797ab169454so33513087b3.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774297907; x=1774902707; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lwhk6av2PkVV2YHn7RPTrkcAgzWJduOS9hmc2v1dRNM=;
        b=dnXNluV8kGFN9zIiV2bEpPuIGDxZBIF6c89QrK+Ttb1MBdNsoqT9suvpmUg2QyINhS
         aMsisH0it78fOTn0otAeS40kEEoCMzVHP9Uv2Ya+1N5NVfNWJyfHCTavP0Gy/P7S66ve
         OG5DZs0kc3lqfNBfZR3HdXssCsHk4GPy+SA5I99bnAgcfHJEYk/oegQufyuoO/nwlxNH
         tpJNifIkoBWwIO4NwxKA9/ETMZkKMMlo5qrn6VN7fRcbJuCMVFR52JWePZTRSDhxhBcX
         JT99B8QEbZeqNyVnQRj2/nfrZrg74fLh4wwqcybqwNwNDEEWCUpatQYrci36TGIQcBTU
         bVPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774297907; x=1774902707;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lwhk6av2PkVV2YHn7RPTrkcAgzWJduOS9hmc2v1dRNM=;
        b=j8oZGmY99TRKaIQZ64MJLQdqHEY9oPByC9JHE/l9CFkOSg0/1vyTPtkdfPATTfTI9i
         gbmXS8dDCHrdaKy6knlcM8jOIq7TK0nsVgexPhKuibQISZKZnYQvAC5K1EWm8T5uKnAJ
         Whagk/XejQOgFpC+yph0tdu+75LIK96rmrmptC6KPtK5wWXmPdvD5rbID7Q4qM9zVgtq
         UfmZDFlPT8Vmhs6r2VMnuciBbPoBM1yFb94WMS7iA7af+ANiLrRARxiNu+w1muFXpcQy
         u/aJlGduN/spMQtwhdfu9FQIkt4+YtD5JVvqw/BrbGJ7ioke/CvcZOi4+U4TshzIr7iv
         vvwg==
X-Forwarded-Encrypted: i=1; AJvYcCWU7mWERpQWVw1YNT/iAn5eraQ9pxdodBbdc2cpVIBDOCCWiNahxvWXrUxixxpuT1Ma+Az5kiVt9A==@kvack.org
X-Gm-Message-State: AOJu0YyVIcbpQPNU8gsoKF0WZg8woVV8IOWCfDmst8YVxhkQTTIh6cZa
	dAdgxneprbzZqyBkl0Q9Dfv/ZMDTHDlmJmV7xt0RjjNsAh0mPrt09AVjqW4kFOIeYOE=
X-Gm-Gg: ATEYQzzTBaBdzYHhusPJDYq08tDGMe9I/WfgAk88Ez/8VhrBGBhKO0dhZHkwtY9ekah
	V0BOqezmU8cjozutIxgj4kPnRRZX0VPfqwKDIybpBdpXQyTPvxCDEmtR/WahRE7Ttz/JZWADVYJ
	WP3IUTLmnhYllajXhxn0aqoTT529pDsnkDe0cFxhG2qShKFeaCa7iUPBoqiScErbQdAuLgik1sQ
	QEcJtHEAxfxjbhMJUvoSO1E5MCBcGfeLR0UUpsVeb3tvoCJIhtwV9RHLCMStUu7u9RlpoDRIXMW
	FcmI60IIlNB7lnHpEbSOH4IL3LMjmZKdEpKUBso+sQAYDf0mNzGsqlb3ozTPbTeYEqyswnr4FcY
	ZRoNw29M8i9dShhFmZCa1oVLJ0PmQHYEIWgtqeVBh4sXCNjyOHj7/mVa3LntTjypen9eihMzFdg
	oGWmEh//J8sXa76hwf7ySOPVEd5iB2M5EYjqGv6AvcAl1fWmXVaFob9tS63Xavivvc4g==
X-Received: by 2002:a05:690c:e3c6:b0:798:2629:85d7 with SMTP id 00721157ae682-79a90aae42emr128303507b3.9.1774297907010;
        Mon, 23 Mar 2026 13:31:47 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc8fb9c10sm1014271785a.19.2026.03.23.13.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 13:31:46 -0700 (PDT)
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
Subject: [PATCH v2 0/2] liveupdate: prevent double preservation
Date: Mon, 23 Mar 2026 20:31:43 +0000
Message-ID: <20260323203145.148057-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5466A140003
X-Stat-Signature: 6yzytwwjxj36hchpsw5e95c9443rkscz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774297908-773695
X-HE-Meta: U2FsdGVkX1+ysaX0dPjUK8dhnnlxJ6kyHMZr7SL1Mmq7XO7ZL0rxxYGC6uZ7SxTfyToWyJ8HVgOiUjw+/q22b6DSt4xeVDdk7NmPEXM2441s1gwOFyrWv1RH/vzE/l1+nFLdkVctQhnq8TON1sUlBqRzPVGIIEMnvgMfgUZ7BAbDHesrPzqfKBW00TjZxfUmXmnqTJpPpvdw8e3HwDpl2mraq3lwzmIkauleQcAtlQZxwzTlQgNpuR4hror441FrlJvlL6luHa+ad355qTWGhcQ0BaZlqEpCV1XiR50mLF3BXABOD8NEGdWNlVCqIROzNc7oCXbtoaV7Qz7QtYLARosryu+R28vcMxKOqd0CGPTKN5bmdZ9j5uj7ZAxU9MbiG/tlMpJ/3A7MUFx6y108+mYRH4bTU4xPH9SPXK4yX2r2CMRA3eiHno3sce9XvyX8n90HRGYib6nbVBysvfaIoQPs/sfr3ZwG24wdby6uMOd0GG87im0eYyTzE6kDk8PfmVWGlZQYGHKogfjinBjusb5cxDGXVD39WXugshKmQiK830cT8SUOwN07E4M4AHlwNY+hjnjn/4J/bb/nJyZkgPJhQ8Tb0n7hv+fQhSmp4YDw2fqKR2GQmjfy4W812HNRLpNXNDmiVoxA98CIab08pbgW2875/S6K8aU6WL7zRUJ6lRGCwSuWivC3D7BLpQaGOSsLG7DXsu9+YP5BH7uRqPU1Q9aRcsO0eW1r1lYC8psaWt7WpdF4uQ48n3uNAsU1Usp4FcilKHlnEuVaO9b4GVV2lIoes8F6CFOChb67vgPUxrWjDMne64SgyrlY0JTQzV8ZLrqKr5t2YJ+uBkycnWI9ab0cRdsfWXH7RluZUe+eS9IKim58qKGWYx7kexT2LLjU7iqhCQU5PDi6Bk+PWRNfYK4BfV0O0cKpjQetanTgooPnwOOzDyXBTCSWWufpolpgX4t91xEfGsDwS9k
 GFb2+S//
 pYjNe0TsmZOGxjU1bJY3repqjCD03b8xd7/Sx7VdeFYMd+xlHBJhLCVlYvF7HICRJhg1M+02g0qNcG1TjyUKhJ+2rTZv/ezckGCqDi4eMe+6qQ3ErT7qe86aiJW2WDDy0j+ex69MjmTxXhB1dX1XLAjWFOuGq2IMmqXVVftEOn9kIj+GkwcrdIa7Wj00iroTsYDnvTA9MYNMDIFPazP8R1OlGxTPAeVyhiDVCXJSUDLz2gQO8NC6RJH6sHz5BdBTF5vy2zynHbj6wfV0ToeJBpU/UrFfqsgG64ihn55zFgQ3Hzr/OCpReNw8vTjs7P7dihZ5C
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
v2:
 - Because inodes of preserved files can be shared, we cannot rely on a
   flag in the inode. Therefore, use an xarray to prevent preserving
   duplicated files.

Pasha Tatashin (2):
  liveupdate: prevent double management of files
  selftests: liveupdate: add test for double preservation

 kernel/liveupdate/luo_file.c                  | 17 +++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 2 files changed, 56 insertions(+), 2 deletions(-)

-- 
2.43.0

