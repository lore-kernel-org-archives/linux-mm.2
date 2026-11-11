Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBB0606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Rnl4/wzR
Received: by kanga.kvack.org (Postfix)
	id EEC516B00EF; Wed, 11 Nov 2026 02:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5226B05B0; Wed, 11 Nov 2026 02:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA306B05B1; Wed, 11 Nov 2026 02:52:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF9EF6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:52:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5FD8A6C1E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:52:53 +0000 (UTC)
X-FDA: 85422071826.17.648CF05
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBC691C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:52:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Rnl4/wzR";
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383572;
	b=zXg0RXG/0ZFVLUOkNwqHYLJieCZMQfS7nKZp2hhhFiWTUT8MBeftqEr1C5E381IuAaK5rg
	G4Le7jq/2lkEWx4borcoyZPf8F8esg3NF3lLz3FgUXLaG0rXqnyEmt2s2e/7+Ofn9t2nv/
	qnv0im3buAkOIKNTcsqNwWVjJz+a9j0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="Rnl4/wzR";
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=59sgXJgrAjzlF6lUUIt9hHd7ZlSVCeSH79v3f3zBjaU=;
	b=fn+Kmya9JviauCnnyWevm1+UxPizY25r9ACLUvTMm9sPwqLqYexlKdkgP2+0fXlXNws0/9
	OKiuT9Q1YjVfmvLw8NusfkgRjdqIaXstsAGoZTHzQd+CetXt7dh7/v5w7n//BFW8vANsKq
	ZfuwG3p9dfjqa+69SzmT21OZ427G5cs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e977109392so16909445ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383571; x=1794988371; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=59sgXJgrAjzlF6lUUIt9hHd7ZlSVCeSH79v3f3zBjaU=;
        b=Rnl4/wzRS2DvA6jXtH3lWF5NJVevf5iizceMWcMPOT/QM1bUyM5+sHy+dv7JbHQ0b3
         g1ocStMYqqoL/2Mj3/VYaE8tpvqTyiOQp0P44Hw1cZzqMIO7KbaAQfpTk0+ttwWtU/V2
         aedUUq/gs6VItOlFXsEV5FQIVmo685pwYYVs8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383571; x=1794988371;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=59sgXJgrAjzlF6lUUIt9hHd7ZlSVCeSH79v3f3zBjaU=;
        b=R/JVl/omkP2nnboy/yY8HtVawoaQZEi8nc+3oNtyv0bEHbgm4t9EZorYhn8ryxrtod
         LeyWhs/bK3SsxtU8VDC1qb4QtLOuXuqWaZN6ysca48FC/1EGZAQwHIfYKr+s76NJ7yCi
         2LBNLKyZzeNZqHCvlXzmUoQ6jGf/ESxFy4ZqOxhdO1538OZiNOPA+juodqXXVZrwfzb3
         JEx1FHlzffVlIC8lcIo/vgtm9POXPVRs6Hv4F5bKMCrdlfRFSf8UkW/OZ4z2RNctVv+h
         jdbYTWK5l23L+37GEU+jPmRpZRYYd039PYbJ4z3xyMcuTfyAAPMsbSlo4V22BgB1WXW9
         FZOw==
X-Forwarded-Encrypted: i=1; AL+hErGIOJTxZbWdSJJEEhL2tDQH8BSrJ/+AB5qzfPYj1X6PUibysO6awWZ0zuSCHRp7d6HKI0qrGX1N0A==@kvack.org
X-Gm-Message-State: APuU4Z/OSsMuH1bJ8pjV51W1Tn58aKItKc8/wN9/lKb443OeKnKDhVzi
	FOy1HCaD+AyubKDUkZv7GnSzUS4G3tTRryQwKom2Bq2kpUoLYooSmjnpebIOtII0Mrg=
X-Gm-Gg: AYBFou0JzrmYjU6BlSaNKb4I5R2nydFUm2qk44L6lY5sM/CyRyu7R+9f0wQUmfx4YtD
	gg8Re6U6zwXh2z+OmaFwNV1Xjc553PYqhZXuLoZGTnwT93se6ccQBopmtduV1IOGLGQm9mzLzlv
	rKtauf/tB6jLp5fGaoTbzY9P4nQYMo5ecKsRvUiYqpvh8TJHAaIZMX+mx1jqkMVNBvbVxr3NWCK
	RvO7+WIPBiqrNXas2FK/FqilWbcZxo19VOxJKrMjZ7jg0Z3OkmQ2ZfB+dCZnTtLbHLiZJpHZ0Kl
	Xv/YGlBrLu0PO/OJjxB8bYHP/YrjN4lYAs9ObrrT+oxVtjqkZyV7SoHuYkuumfJ1HgGvlhOH/4O
	bMoWhHZKamhUjVe8dnCfjiC0ZRWR9gruFsVUaJVnqDZXMUuBeG+R1pHEr7FUJzR5sQtfWI4mpuo
	sPaYL8vIvS5UE6TfC5x9309BhlXGLu61Gcjffvc/+7sp0Ns4j4ptuZXw7XegdTeeCzLrjMPSCy1
	pv1fwkccoOf7tjoQp5RSvh9juxFNKo1Fm6lGZcLvzH51sNLKKFspSBSgqf+R+TTIdaAKv3x+fig
	DoM9YHLOMszbUEHY+P8ElbEV4VH+71CagHK7t1+7ytAnGWJ0jQDo98EV+CVGe9FKvVR/Vm/Gwkt
	jm12+8E81AEDWto2GwOTYORV68nbGrWAk+XkMopbrH9EwqAktSgFmSiRf1c89ey3t+HICcmWJXE
	KFOUgdreVPnGy1PRspN8wv4DUTIMAwDf7gN4dMWoSy5IQldwFfmC55
X-Received: by 2002:a17:902:ce83:b0:2ed:205e:eac3 with SMTP id d9443c01a7336-2edd7673ee3mr20690885ad.12.1794383570630;
        Tue, 10 Nov 2026 23:52:50 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6e0d5c0sm17541865ad.71.2026.11.10.23.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:52:50 -0800 (PST)
Date: Tue, 10 Nov 2026 23:52:46 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/9] kho, liveupdate: KHO/LUO observability
Message-ID: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EBC691C0006
X-Stat-Signature: cnnyszdizgwyuzegyds7pm3n4a37qffh
X-Rspam-User: 
X-HE-Tag: 1794383571-29955
X-HE-Meta: U2FsdGVkX19UINggptgjU3nStJNSuqwHzDitEnLHRW2hbhsLw/CRamplYtlEN1RDAxhJrwqFDUuA3toz4X2LOEbH0qNa+RQixaKvDxppSjuua+3aOfzmTkVvmUXrr1K4OT3z/XoA5oiFzWKQYz6h3fYgAuq1J618Pd1NJn6PHyjksVhLamjaR2bpN//Crdmb/yZYfmA1uNx+8vf3Bq+kJ5+9KTIXf3EuFUEm2Xy9E/tc7BrcRX9LKVheni16d3fygTnoGabFtVMASOX4LkBLjSas+icsGtHbp67dV7HdC/P9G7AOTFr9hu1oBtSr2/62qiFcYBRy3Kvr6SOPNL1K/DF+OzgoZ0gmOiACnBJtOuMZvfSnUXvRh9xNLDM+OXN4PdEO32uu16YD9UBaDQgRovl4jreeIEk+/cSXVTivgeOFIFEC6UtWPjPWBSOMHkC5NrWQEPCT62VYJMglK5QDlz09bjPIVzxkZJmG6HwSVjJq6qxwX12c6GLkzCIAcb8ccyfBoLGxPplzsfKuKhomZ2ayv5+UZiRYYHa3XWL/tfcGCtq0VcsvtLPvv/lm7jgSZCqjBe8NEekmLFxpjWdzSiQWwxf+uP11d89cOEdHtsBJV28c/gpVWXZ2E71xhun1u3TYq8e4S7sp75XNDdyGjLcG5W515pC520k/q8DEd7LfKSWGu0oOm5Er2nhddtnH95i0xPgFMD9t1trVV1975FpdnGRGF6o9zvADuP6vNe51nbxw8o/AYLWbln8KRvdgojxN2iMJgvYvb5tEAFcQuXjUaQZts6kf1/rFaektgvfJx2T9DC3Jk5oxD9SNo8Isdpw20fxuSjE0XgmJqexmZ3MmjkuoloY75wBWpKVh20+qfwbxbCXAK2D5H+NsFd1ZgXtIelwVpwgcAjuNEvvmvVJNacYCrNO7iWhnZ10PVQyQVyAXhyYHEQLyF1/7wyXWIyRYdMcSSaNTz46JzMy
 4f2YfHCM
 urO4rhx44uQStsZpsy1PlGl4+Bq59Uf9sQDZIKvll8r4k7kig+Cewhw2QumNfldQpKOjpxz6qjD0aJnoKvDNj1Fv0IdiwFLJv5qLfFrwbZD4tJjr38svkDMAJ4KxNkmmQcMICcNbkganXwKUeAPDe8htu36XkENwrF0WKnc06w93T8MbE6Fcc1CiWJ3rdc8Kkm/VpCqwgI6j8F+80GaQKzRvL1MQc/M3IYIROabQ+NcYe8mLAlcHbLG96wqzHzEBZ9msTN8Uv1LN6yHpzpPCxmLN2O4yM+QeZ5eYIN8Ro+9Evku7PisSK/SH5zi2huq8TAgiTWa6pos/Gcfb7DeZamogjPPHib2DPOPSugbxry8pa29hT9kJzGQq169bjxoQQ+CkLPw3CMLv1yiDBZQQtLMC6aUv9ncENkEUzw2vZP9xijIlHQ2mR4109ZTTSKD2S+hvICBDNHR050S8ItxQkIcwT7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At Meta, we are moving towards using live update on hypervisors whose
VMs can't be migrated away first. We also want to preserve service fd
stores across systemctl kexec.

Our kernel rollout is driven by health checks from each host. For
example, an increase in rejected handovers or retrieval failures may be
a reason to stop a rollout, and the bootmem size and sequence number
help us understand what is happening on which hosts. The series exposes:

- how much memory KHO set aside
- whether the new kernel accepted the incoming handover
- whether LUO could give back the state that userspace handed over

We expose these in sysfs so the collector can read them without opening
/dev/liveupdate, which starts deserialisation, or depending on debugfs
or the kernel log.

I also noticed that the incoming kexec metadata page stays reserved
after boot, so free it once its contents have been copied.

Chris Down (9):
  kho: Reclaim the metadata page left reserved after kexec
  kho: Make bootmem reservations visible to fleet monitoring
  liveupdate: Make failed retrieves distinguishable from dropped files
  selftests/liveupdate: Catch incorrect file accounting across kexec
  selftests/kho: Catch missing or zero bootmem reports before kexec
  kho: Expose rejected handovers that look like cold boots
  kho: Report how much handover memory is preserved and restored
  liveupdate: Expose the sequence number for consecutive live updates
  selftests/liveupdate: Check handover revival, sequence and memory
    stats

 .../ABI/testing/sysfs-class-misc-liveupdate   |  56 ++++
 .../ABI/testing/sysfs-kernel-kexec-kdump      |  30 ++
 Documentation/admin-guide/mm/kho.rst          |  19 +-
 Documentation/userspace-api/liveupdate.rst    |   8 +
 MAINTAINERS                                   |   1 +
 include/linux/kexec_handover.h                |   3 +
 kernel/kexec_core.c                           |  26 +-
 kernel/liveupdate/kexec_handover.c            |  82 +++++-
 kernel/liveupdate/luo_core.c                  |  58 ++++
 kernel/liveupdate/luo_file.c                  |  16 +-
 kernel/liveupdate/luo_internal.h              |  34 +++
 kernel/liveupdate/luo_session.c               |   6 +
 tools/testing/selftests/kho/init.c            |  24 ++
 tools/testing/selftests/kho/vmtest.sh         |   1 +
 tools/testing/selftests/liveupdate/Makefile   |   1 +
 tools/testing/selftests/liveupdate/init.c     |   5 +
 .../selftests/liveupdate/luo_handover_stats.c | 258 ++++++++++++++++++
 .../selftests/liveupdate/run-vmtests.sh       |   1 +
 tools/testing/selftests/liveupdate/vmtest.sh  |   2 +
 19 files changed, 624 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-misc-liveupdate
 create mode 100644 tools/testing/selftests/liveupdate/luo_handover_stats.c


base-commit: a0dc8eddbfdb6dd9c5c2b70eb66ab49cb1978425
-- 
2.54.0


