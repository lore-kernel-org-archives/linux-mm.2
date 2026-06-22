Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9BA3CDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C888A6B0088; Mon, 22 Jun 2026 00:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A1C6B008A; Mon, 22 Jun 2026 00:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27B56B008C; Mon, 22 Jun 2026 00:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C22E6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:39:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 08EDC1A056B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:44 +0000 (UTC)
X-FDA: 84906295488.28.CD66852
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id 059E316000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:39:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8tlJarj;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782103182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LWLk8vwBsRQV/8chPVVuiTE+2TLYOW07i2z27bitdoE=;
	b=jhMWLYAdpF+/YuHBqMsXo8+glYBb24n9ujGckBoDHhXflcYX+i+HMYBjHmPF+EHUS3yc6K
	jPW+M5a0q5B+/6cJVpH7eGtoeF3zhLvI8CH0Xnv7CD7SbQD1s4enaib+zxwbohoB5kTm8C
	+66ZNZdJXh+YC9HNYoGhBgnPkHRf/fk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782103182;
	b=jtFJ/l29i1zaIry3l6QPQIGPlLLxfO79rwHaa58/5U/Ed60MziFnE1hNXHZQOS3Izi+nRZ
	6D2VY5qGkaZTKFSeZLhkug+uCfNldAGOSMUZJYRx+jRpE4AmnQmVczsaPi7Z66KqkrRlHd
	MfS3JnLX4eKHtrCZnlzVpT79l+yyAZ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G8tlJarj;
	spf=pass (imf08.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6e21c47e6so2252652a34.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782103181; x=1782707981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LWLk8vwBsRQV/8chPVVuiTE+2TLYOW07i2z27bitdoE=;
        b=G8tlJarjRsaez6j8CqpIYdSkzcbjMSMEQo7AX3n4iIEiJQKBlj3OwnsGAItUyJ4jj9
         pJBbQl8l08m/HcMVuHKshYczp1JeUwllzNl0OU83Bm60ZEAPTi3LL3bfAZh5CRYOIHO4
         55vaATnvCU9RG1cEuZNVFamBuRie6gwpUoGWmpp/TOtt0mWE4wtBqrhOnBS+WcVpsRqh
         WJLy5MNK02gL96Vp7vCNvukN2tx010Nvl2RpagSHijcI6t0MkGXU9HuXNt1uq+qRa9LX
         tLq1bFa9I1I+8Timi5skuLdV5u7JOWeGBAVP940oGiO7BJbZMN6EF5rDw4Yj1CqNXzvr
         jLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782103181; x=1782707981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWLk8vwBsRQV/8chPVVuiTE+2TLYOW07i2z27bitdoE=;
        b=frPSEhOqmTYhbCw7ud44JFMIIY1OiU1nq++rnWwXXI2m3Mc2tpHyRuOSa1ymlyHbKY
         gNiiK8RrkcqQj+RikqTKBWCKA4z14I6Xh6ayBA/KhbiWryWmTB4iHfdt/kqgNilQHyH1
         eCpnexOVjJn2VYRoDANH2SHVuBbcfQpzkupjxMmFDGvKipeQftW1W/jV7FxxsqTN7cnw
         SJVisEt5Ka4E/m6iUKz08lR/NlIS0CWNFKJrtR/ZbSOD84PbLzQKAHrjKZb7J+EUMPjS
         9shWOqf+X6Tz7TWGnG8+9k7kgy1joiY0YHv312zIOFHoSAUdrPvllOyQnGN4LuwsaNj+
         GPZQ==
X-Forwarded-Encrypted: i=1; AFNElJ9AbG+C1++8TJGdJTB4IKxumE2zz0JyJQ9iDl78/qJAve0AWxXfR8oRI2X9yBqRdvWjQmVT23QSRg==@kvack.org
X-Gm-Message-State: AOJu0YzNB88mzzulIBlAzblLHAxDiS2ipEuCEQjTLpzCxmNhuJAO9MF7
	zN+IUVwYeRebpKFjuKwKYkJrKuZUOznLprLTiVsDNiAKgXbYNbIVUnWe
X-Gm-Gg: AfdE7cnJeZblglyY3gPXVogoOAi2RNDR+GBilstCXr6WWzlAC2mqkFxZ4tWkrSVdhGC
	mRyUgayIM7FRbp3sjFCSLHkVWXnaMKyYNN/Brdc8da0jamIAKoCx2jauUKBtCZxXoxqO3lEdKd3
	xZwlEamAFJh5Z7QDERr63Py2Lb9PLAXHuCWBW3PfP8cMXOrslZZhUGJ6nxZ5x0Iyn+lEvulhmQE
	Y7FCLTPQjHUPBE0XymJbYbphKnuXI3iojNjhwd716hrDQJdxA43eTwApzbkW9H9NuRuxGgZBYGn
	sQB/josQPYMJcrNPAfkpdro1iFm28bZLGpLwuE4JUpASRCS/VD1xjOdY2q7OCYy1iM8nLX1qS/t
	hqyN8Ye13YwyI3ZFctAfsxTtMaW9gzHodHCF3r1uw6zk9feVshaqhs8HMRHoSylIAS8d9cTRdnC
	4a8sjxqtKxtrs/ng2wuN3eqkaGy/DjSztW7rTgd4qgrk39
X-Received: by 2002:a05:6830:83aa:b0:7e6:f5bc:496 with SMTP id 46e09a7af769-7e92d8eedc8mr11244425a34.16.1782103180884;
        Sun, 21 Jun 2026 21:39:40 -0700 (PDT)
Received: from nyx.tail25a6.ts.net ([2605:59c8:74db:6e0c:3a80:a3f:f9f0:1b3c])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9442ea144sm5428453a34.27.2026.06.21.21.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 21:39:40 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: kees@kernel.org,
	brauner@kernel.org,
	viro@zeniv.linux.org.uk
Cc: jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
Date: Sun, 21 Jun 2026 21:39:32 -0700
Message-ID: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwi9zo953anjajx8hy34axfu45d4px45
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 059E316000B
X-HE-Tag: 1782103181-92294
X-HE-Meta: U2FsdGVkX19cp+Nk9ahiQQ2/ZEDdw1vit1n9BN4Ms3F5IOoiwDrblgbK3X1+tGSM7IPnUK+GRJXQU0w42+3MwDg2orUyr78fqKyNeq/lxS99sy/o5ShRFH5pxYIYq7DmpazJriBrPcaC054EAgh/9gKplE2fOElszK8rCDQpiq8FqXwctVpJ6mtw47ioXyetYR3wxT5Id02kpUtZBihkRR7ni0xK5fb3vQJ5xWeL4Q33bC3I53LAV/1RxbmiPjqjgAqjD8rVMo4+y6B/pAiJGbEXT2mwqvChO29io4vLg+qLxYblI4mG0/9dnaysSu5EalzYUJcPmpnvM2mjLDfY5n0E9/Jjsp32unKYfbSuZdAFHIny+MSO2ICWRVXYTh7cAxr7sDmfFomJdyR0UpUIfc0eAmuVDizWl8MP1vY4WEPexPU9cm+4iulnKYE3s81eGzua4bbPTnQJipFmDnvxH2VUsvYRok+fkzuK+R9qksAHu7zS0Yf4bb5k4dK9mDiBjmwGGImZBDLFtVL77SHbkafKrrNaRomONT03rJIil68fBztLNw4vGH4sTnvrIjwFTHjdsGLIi27iY7Wq9IwR2I8VJjMmkXLiCIXse738xcs5sndXuTqWfoHv90oMVl0dbO94TA7Aa4do9MJninumblqMcvlMiKF6HvjLV1RruFtaF3MT9ErPETi/amE7m+CSRszJahaVgJ/osjKMEQeeQ1vH9h+xx3SZtwVlpdZrAwXhv80fGaaO3/nJ95smNXAtgqHc4IBlMvMuH5FogiBijTA2HiMtWdekVJAumVRqzhbD7F9+3QTgEWhPh2/p4pLXG1Dp0bFQfYdbjXKn3oLw+J9Ec+VKEP4Hg1tg81MEdVHGqXuK1gc9CwNw9yG9khiEJDEMfsoi0ODLIKB8/xel1HjfL+OSa50nHCfO5r4kY/RfN+OzpviJcTI6FaGpqy7m7dFbjRp7RwNml9fTiBF
 XlK83iey
 eN3EJW9HJaxtXzDAOYOXr8oJBE+E84Jb0vQblje07c9sJERHvtHyDnwCth/B12F+rBk5Ulu6umM5E85f47dLcBDe9zX1k7X0I+X4M8tejpYFT3BVNgopbnjRiPG7FQpKc/3xD1OEOXg3j/Gws5cnzx6WoKJaGyIX8qO2MeuevPwRBt9Mqz3CB2c2uz+Iur0Y5Z+CdbtsKy5nTDuxtEUsBTO/EqpavrUgQAW1e3Ad+K9Zu4I118a9XLCrZEFcF2SQ8kHdndmGuWw/LElP+22+OwrjFeE8WEz4jssOtjEx+SickaFgp4gL02OIGRrpZ0/eMB5EtNs7Mk3aFELmDH278NgdYylnidTSyVeudH/zDWexEE9sHF1Ilq86Uosc+kvNslvnLUJ4id4aS/xHNC2qyiuz/B/OKKa+lOztVO23VVkFXX8Eir869s/tW0pnBPbXzXsd7YIt0FlGOuXx3mlJQaVxuGuMV+4VlvWng+ZTcdKIW95DxmOJ1QTuZGRWaXc1XVhFeuLG3L88aAVVhWTsUZ1WNttnc7QhOrg9CsaYdFH86+P3ixuJERunpE5/l72c4a+9UvqBbLnQi8T16FB0hCVrTMn8quUu28ABPsHEeCDtccE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, standard ELF and ELF FDPIC loaders require a fixed, absolute
path to the dynamic linker/interpreter (specified via PT_INTERP). This
creates significant inflexibility for relocatable dynamic interpreters,
where binaries are packaged independent of global system paths.

The primary goal of this patch series is to support relocatable binaries
in Nix, where packages are stored in a read-only store (typically /nix/store).
Allowing the ELF interpreter path to be resolved dynamically relative to
the binary's location via $ORIGIN enables Nix packages to be relocated
without needing patchelf or wrapper scripts.

For details on the design and motivation for this in Nix, see:
https://fzakaria.com/2026/06/21/nix-needs-relocatable-binaries

This series introduces support for resolving the $ORIGIN placeholder in 
the ELF interpreter path, bringing the kernel's binary loading behavior
in line with user-space dynamic linker origin resolution. 

To achieve this cleanly:
- We introduce a shared 'resolve_elf_interpreter()' helper in the VFS
  exec subsystem to avoid code duplication across loader implementations.
- For security, we restrict detection strictly to the prefix string
  "$ORIGIN" to prevent complex parsing exploits in kernel space.

Testing & Verification:
- Added a KUnit test case verifying path resolution logic.
- Added a kselftests integration test checking that a dynamically
  linked binary with its interpreter set to '$ORIGIN/mock_interp' successfully
  loads the mock interpreter (built statically using nolibc to avoid
  glibc TLS setup constraints during interpreter load-time).
- Verified end-to-end correct execution (PASS) using a minimal initramfs
  under QEMU.

Farid Zakaria (2):
  fs: support $ORIGIN in ELF interpreter paths
  selftests/exec: add test suites for $ORIGIN interpreter resolution

 fs/binfmt_elf.c                               | 11 ++++-
 fs/binfmt_elf_fdpic.c                         | 15 ++++++-
 fs/exec.c                                     | 42 +++++++++++++++++++
 fs/tests/exec_kunit.c                         | 26 ++++++++++++
 include/linux/binfmts.h                       |  2 +
 tools/testing/selftests/exec/Makefile         | 12 ++++--
 tools/testing/selftests/exec/mock_interp.c    |  6 +++
 tools/testing/selftests/exec/origin_interp.sh | 16 +++++++
 tools/testing/selftests/exec/test_prog.c      |  5 +++
 9 files changed, 128 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/exec/mock_interp.c
 create mode 100755 tools/testing/selftests/exec/origin_interp.sh
 create mode 100644 tools/testing/selftests/exec/test_prog.c

-- 
2.51.2


