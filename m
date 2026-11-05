Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2384606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qqAZkFbF
Received: by kanga.kvack.org (Postfix)
	id CB04D6B05BC; Thu,  5 Nov 2026 04:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61C56B05BF; Thu,  5 Nov 2026 04:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4FCB6B05C0; Thu,  5 Nov 2026 04:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EAD46B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:36:25 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11771A09B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:25 +0000 (UTC)
X-FDA: 85400559930.14.2F3AC39
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EF50180007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:36:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qqAZkFbF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bUmMuvID2ld5jATMeQfYWENf+3/lY3puiHjow/VO3i0=;
	b=MUgvXb7xmShBalNVND39kWafLJObFgZhUXDSHmf9riTXdLfN8XhYjoSLtu/6ahJu5D/8BB
	O8pbFLey8jmjmQT2zxKj0CuLCHnA0WDba+xiMBMpY6o0kTgPRmPdeCJUzk8mWfNMp/y5GY
	xqF3O0eJaM5TdeUc/P5HYr2gsjHtqPI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=qqAZkFbF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871383;
	b=yXe9tc/dK/niNOXxhygXKqqhE7fxQW7yJYUtSIeLuKosgbXxZ+19lxMxLyILuccG/8kexq
	xHXIamqDQ/q0oDAv06+6TbvLtYAziIEPrFSNdvCqZYP9mL3c7xgceZU1F0eqC4G3dAsQji
	tSBa4nH0HQLdp9kbwctv/oJoSyYm1gM=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-36d6765756fso1843050eec.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793871382; x=1794476182; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bUmMuvID2ld5jATMeQfYWENf+3/lY3puiHjow/VO3i0=;
        b=qqAZkFbFCPemFAgTNx5whYI5HXhRIo79crHO9uewjc8mz91sh09LJSpFapj4dE7wDu
         xt3wA7cbtYiGoij+rePlSoXv16OLbsmqrAMgX3bv3gZjmJiYz4VB4FVgRzteCgNYUwJ1
         4RdRju+7aj282RjmsmTP7KpgphATGTQYYBKV504CMN2U/RSUMTUTCpbG5Uhj14oIueQ3
         Hort3+noHv8S+7AZBbwvHDLTijG5ZyKvuYITH2LREoS+G4odPfddANEQHnVzEK/lJtpz
         DCrKibyut6Plvsgp5s3ILKMRJQdiU07PLzlTjpyfg4xHxU21hpr0u1hKcI6rESGuT7mV
         D+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793871382; x=1794476182;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bUmMuvID2ld5jATMeQfYWENf+3/lY3puiHjow/VO3i0=;
        b=XPcDlLjrJDam/JC9bv46T7gyaU65kJthZZkpLKWyaKcvWV/5R/yAoTbK/Ml8o8NI+Q
         9ZRdZCcnamfJwQBXbSkOTzFl8iW9JggHzVEeL2SM/8pFRlru9wFPGBF+Auw4YprXbTUK
         3713VPNox5CDKEepIohWYMx4Ilf9AB7K4kum5R8y35OB/JJdWcFprByFWSskcU6YseLz
         8rtSeWlswDmXQWFKvGEyv3el2v1EYvI+RmOvGydZdE3qs5AR7YpuVzV8KYSpsdEeupNt
         8pW7oGU7iZhmmCxfjG8JWuSmkSS8m/xLFqWnLuGHYBysieQR4jpvk3nC8hsUx5DKO4ls
         aenw==
X-Gm-Message-State: APuU4Z+5FVo6aMlTglaY7EgExjaoZh/kIorvQINACvcgi3u1MQPUST7D
	gMabgXr7z1/PX1+GLuHJHOZ7gg5o7WBjc1NKJlR543inmap+ynxOuNeA
X-Gm-Gg: AYBFou1jLo1M1KdQIB+kDfkkrHpfEp1PoXGh9EVeUlgW6/n9eXKKINs5qUVIHrp1Ty4
	BE8ezNTvuKPCKmJkJl+WT0C19FuCqtUWq4ffN+pDOuJe+nEWI3qaBt6T9xt5n0ThS1RvNCv4agJ
	LDMG3yAp2e8WY77ikbIcF3USflyW3liZX914jCcReJP4ACwDgc2w7lkllTYzY+d3s+NA0ahc0HO
	v9fQeIDHA9YA+w4FncfAlhfLQcNZ0VWKvENCc7+jbdEfRI/XrJ5vLU41UHEQu9e+mAB2hkbmkrG
	Q2wA7NxRY7hfX9Js0XlyifUx8lDHUCsw5erJ5RegfVDDQaw/FtTslzllDjlDkRSxrMnR9D+IhIV
	RkIzH2Qv3UD0ftWctX2CVBKtAeVUFWtYxFEtzRjmle/RUKSjM2//G+tI8rXf5L8qHQe6LjKqtRO
	gJZIdse4Ep7XBk7ablGq/jjAIOXKzntKoDhjPtHZcNTo6Opz41xcBvGf+4PuZof3KPdFirTOkWD
	PpSyh8NXkKfXAIuITvJPOuvf9tjZQLD8oFJll/9s1vAms/m0KN2oFYZMynBbQhdy3ZEJntV8INF
	Egv8pqSpCXHABI8o/rzkZNFQ
X-Received: by 2002:a05:7300:fa0d:b0:36d:7feb:8bd3 with SMTP id 5a478bee46e88-36d7feb8e1amr4402969eec.11.1793871381617;
        Thu, 05 Nov 2026 01:36:21 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38fa273sm17363207eec.16.2026.11.05.01.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:36:21 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH v2 0/2] mm/ksm: keep smart scan from losing duplicate pages
Date: Thu, 05 Nov 2026 04:36:13 -0500
Message-Id: <20261105-bug-mm-ksm-smart-scan-align-skips-v2-0-8a9780b6844e@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA1O7GoC/5WNQQ6CMBAAv0J6dk3baAVP/sNwKGUpG2ghXSQaw
 t+t/MDjzGFmE4yJkMW92ETClZimmEGfCuF6Gz0CtZmFltooqQw0Lw8hwMABONi0ADsbwY7kI/B
 AM4NrpcKrrcqysiJ35oQdvY/Hs87cEy9T+hzLVf3sP/VVgQTdVaq9mYsyDT58sDSe3RREve/7F
 /QtIFfSAAAA
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EF50180007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tcwtyby3zjma5m47sf9dsw3gfgb7xrq5
X-HE-Tag: 1793871383-864432
X-HE-Meta: U2FsdGVkX18sy+06AhndD7dhGGab6s9Hr+pGzITDarfVn0bTGizzuvojfvHPA4VXGi9g+pSJ3axVyvwxc3/w25dnC74YeR9flPhSEXdVL5kq9Cm4WnpT26b1CNKSwM+ADmUJMGHDtUVih5AeiD9S9jkZSix+I7JS+P99FktaIpB6gtPJGSFdxs9MsqYH2BR8vrtubyXsSyG04e608GS3TdJVO1mkVJnqdtXJ5n3c+jRQ37MGM6MaJoTVKAAV5iwwOY/Z9nAVGKCsSBzR55noXSZ976CfSbSAZUaFxlyWpKAThgHCafZfw5TOpPWg4ifO1VuFFw3hyi7tn6li6wnOWCILSrnPYoA2KwWJGzCERo/bomG7Ho5Ta+Jy1r3m9n6gOURyIaG1QxXYVGcL2HWbctC6O4VPqMuf2mQwrZv/GlXeKXK64kiBZxFgX9u/uDNs69D5vsvdNiUpWI2o5lVuBebDub9Ea/8cjBOS/2BKAlBlOburgC+JtWsozpZS7XDuTYouvfWjLDj+pjXz0KVc93fya7zhmAZ4CMluiiClGNF5/rBtvzWQ1v6zY9RM7/ssC6bP5nnL/QB7oMvJRQqv5o7mBMJreJdvyF127jCZFdNPSOcic68SkkvN3ggjPlV+onOjhpfW9K2ZQIDQGTIE8dJk/CdIWKosmRgdXKLqyeqpLijZmMoh5Sf1zMckMnfWu4dsi4wlTaVfpFgy9hl8sxDpS0yV6BY37pH/ngT6wHnyRMpYJfnVdYTA4i9jWXBUjQXzGEtlfULrP8qf7DmOL17CyCDRA/3QdfIckZmhc927w/ccL9tcBnlxlHSfKqwTEwlzytERU/6TdYFAX/7oI+R/t90M2cEBlrAnJ/93p6BZ3bQOu3MiA9D5hdrZhxuHoP4ydp5WCaAElTAIjLm0yyrJZYGXTeIx3NTek00khdjjaZv2BVj3J4hBiymPI48D0UzmcgxJIpI53mMJGC/
 KkoP1Tyq
 6pt2SoJiz3dMI0Vu4LuCl7r+d1apk6iRH8UC6APgk5zjXVFR4OzSkLIuIduds50RI8o3BcRVeq5UO9flmw4CjHeMdDjhPKzmwir1552IdKU412YqXd/g+arHsiaHeUjdtXiZPlCAUd4b7QnxUvv8qkN4eC7o3QtoQEWXzrLd/TgKZJCPYreRTUBFUN5aAF9botYYT9aqQ8UreAVtudhFSYEOxJSKgx1fol1G5NRLoH1DEPAjeetTPm8rZWkxQRt7Iih0DRYGQLOyKdtXt7yh4vpzWX+DZTuj0uYFVxOdHbZKk/VNlf2HhqvY30uBDSAdbMKFqTalXsLL3gju3IpmKFaDBQzWXTJ4HGOFo5SojCwm+11w99OENgNDilA0c6Us7uCSPa+3MD8bf31nJD9YvBzOqVCMXiEYfrbfrdYAes3uh4XQhTdMhYfXRQJDjNRt9yokYiYZ7wV+XINbhQpRv3aZbJG58tTfY5DKKWpPtBrUYuklMvdqMtu7QHCxwi0Hc/f4iSkLWSXSjBnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With smart scan, which is on by default, two identical pages that become
mergeable some scans apart can stay unmerged for as long as they live:
each page times its skipped scans on its own, and once both are old they
may never be looked at in the same scan, which merging through the
unstable tree requires. This was first noticed as intermittent failures
of ksm_tests "KSM NUMA merging" in run_vmtests.sh.

Patch 1 picks the skipped scans by the global scan number, so all old
pages are looked at together every eighth scan. Over 420 pairs made
mergeable 0 to 20 scans apart, 329 and 317 merged before on two boots
and all of them after, at the cost of 10-12% more ksmd time on memory
that never merges.

Patch 2 adds a ksm_functional_tests case that fails 20/20 without patch
1 and 0/20 with it, on both boots.

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
V1 -> V2:
- Rebase onto v7.4-rc1-132-g05441d697f7f and retest there
- Drop the ksm_tests -N -m 1 numbers, as it no longer fails on this base
  without the fix
- Update the ksmd cost to 10-12%, measured on this base

v1: https://lore.kernel.org/r/20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com

---
Qiliang Yuan (2):
      mm/ksm: align smart scan skips with the scan number
      selftests/mm: cover merging KSM pages aged by smart scan

 mm/ksm.c                                          |  24 ++---
 tools/testing/selftests/mm/ksm_functional_tests.c | 108 +++++++++++++++++++++-
 2 files changed, 117 insertions(+), 15 deletions(-)
---
base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
change-id: 20261016-bug-mm-ksm-smart-scan-align-skips-cd01e5a9889a

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


