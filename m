Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F13DDC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1237A6B00A1; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4926B00A2; Tue,  1 Sep 2026 01:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F07216B00A3; Tue,  1 Sep 2026 01:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF2B56B00A1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:22:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AC1580305
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:56 +0000 (UTC)
X-FDA: 85164049152.29.A088D25
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id 75B7D180002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:22:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNXC8Qgg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pSEvj+MC1crqw1bkvOqmX0QxnYX53YLokZZ2psek5FY=;
	b=JqeUd47ZW2cjdE1YFx93x9+/DHo8oy7ADsYP6BStAh3wFFI10LmG++66cmsy2woMtTEv8T
	pmaOB2OieGav3942Jk2XlEOoBCYpOJ7302o5u4oharMcycTQ62QH4q54yt31yMLEHUqBGC
	94/33i0a9ZyMKXvjtW/FEg8bw2HpksY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240174;
	b=StTSq//6NMmmuUrAG1LXSRPnNmJLCZLcPzrLKl06D8daMvsQXhonydmRORy0QQ7hehxvr1
	ekjIv74qtu1dQLyJKNLcrsER98rU9sWwSSkZJAmNSaKwz+lyhMsMdG1cGOm/oAjauITnBS
	3CQ3DJF9XL/fuuT1I736jrhPrjJxaZY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QNXC8Qgg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LWGWagcKCKQaJIPMTIKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--wfelipe.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d6f75c1219so10335485ad.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788240173; x=1788844973; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pSEvj+MC1crqw1bkvOqmX0QxnYX53YLokZZ2psek5FY=;
        b=QNXC8QggGPKn3TsLsAUcjFXNfA/9MvDjdd5TX9Qxh3nNG6Z/5xxrUqL7SiU5kHXBL6
         uSs8LHXGFYwzmSQZnqGAh5u3GpgtNnsExjrAXJq8EFM/mQqVB2ZjFYOHZpGbLIANcRZ4
         89YxXMdE2UjNTSHm4GXey6DPsLqw1xgiD6aJIKRy/+5i+1X1OTC9EWF0A0YzkGq+6kGU
         3tuHIzUDAUUGFmvvIa0ZjqArOm29JLQdhTNdKq3fkbpe3T+WWllg3/WGvjKUYHL/QodO
         lHXpuYLzbNg6Z4R2W5jjY5XuhcDc13yIUENXp9Bjd7lRUUgRwV6L9nsuy2jaWgyN/2te
         Z4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788240173; x=1788844973;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pSEvj+MC1crqw1bkvOqmX0QxnYX53YLokZZ2psek5FY=;
        b=PKdLCznUNvmoLEXURIe3C2Io56en/ndlC7EUq0Vox+Ad3Mw9eFb/A8LWbwDX6bFCLD
         BEzSADmzEkmLvEw9dqdlaKGVpSqZJobla+eZperJebIZgBD70V2x920Q7NvI/eQRqfVn
         q5+TbgSb3sRA1LiLPM/fkuDcr6uO2JIQi7m8eERqEs9eA2hALvktmnxI3ygmx0msH0zf
         X/cOGq3oeDhekfq8vkjRZ22npe3RmFlJcTlzvoK2GGksyxyNGdfVNrrwl2/ptIGS9urV
         QRyDwsXLMsyWWnIRPh42/sp53yXmRCBu0aPWSMTu6qVrENOUj71R3ikqnO/iSbRsW6pZ
         MHLA==
X-Gm-Message-State: AFuF++lW49IGy29E4ZYUTn3QJBW0eB5+MxHs8SFtWuKy56MSUKe412jJ
	0jNJgt76xjQGzHbAjRbxi3kmHnlh66Ox7ou/91RlnNzYwdT+EJEXWpgDck/Bb1ZkWTo3xeV13vM
	vJ/0kLaBOvQ==
X-Received: from plbjy16.prod.google.com ([2002:a17:903:42d0:b0:2d9:1541:2cac])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef52:b0:2d9:383a:30f1
 with SMTP id d9443c01a7336-2d9383a326bmr129023445ad.4.1788240173018; Mon, 31
 Aug 2026 22:22:53 -0700 (PDT)
Date: Tue,  1 Sep 2026 05:22:26 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260901052250.154532-1-wfelipe@google.com>
Subject: [PATCH v5 0/2] selftests/cgroup: fixes for test_zswap on single core VM
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 75B7D180002
X-Stat-Signature: nuhc4as8w377ycx1spa131pgrbz13qqw
X-Rspam-User: 
X-HE-Tag: 1788240174-713950
X-HE-Meta: U2FsdGVkX1/hGzCBgg+gj57wcJUB492efOSmTEuX94PA8C4NouV1ivIiCwzSJxd3x00pnMGkEH0R9dINU9WyO2PoB9sZEh+9v98YvxXFufIL6dQYXdjNMWbw5S9c0Z4NvkwMkng6nj+KRWGsn0Ee8VCgCeFlRgkUIEwXClhxhtWbtvTOyUXPig4zLSielTQP5Y4+bq/An2mp0SgAmFbri5kMSYOl0D31YyTu24zvR5FHFavMGV/SEYgr8OnGF563TA7VfuFI0XJNkEvbBPyFkSu7cDXbkPIkcZI4X3mC6pE6BWPLFZqhXIuNiak34fX8kGIbSfzwF+vcNWXSNGVDHakDLzuQR+aYR4rK6OoyRWZga9by6rgc3ISv+n2mVQolxj23QqxTqy/gh8sqGgBCCP0VeX7NgDSOJaxGdv3EkXhbH2dgDqXySwMtojpcSSWRistyj9wVoKj85o/lgUru8lvMPtio4tD4lbSAk4YWXWdti+eEBYRPqzA4ycm59yjURVC1inTt1eW9p5VSXC1k9UPB+5QnGrqVaP+1b/0PIF1SEM/VBzVR5I/A+OV9W6e3NtE1KzkvYOIINO6N9z3eh/s0r+anFwb1RiRU8nxW8qTIx2Tj21mWF4l1xjYUXE47YuWUblqhn65ExdxMHkeE9h50+fEUTZEb+exkurQgb5am7vYEpbkWjLGII14myRb0j3NB9VzT4TtwhX2LhUaq50Ti+1Mi43w0L2wAO41wgaoaXkPgLNxD1jc4MuPIWbRLM4ZkY0Ep698BYW0BSyyBdwUIIn8yCF3BY1ISeLlGtEE3fUZlQgM8AuaqGtXf/Y0mONEEg9gTVZ5Y7PVklu+UUWQchfyMb9YMjNJqzgqaXZMyFZw96RONmNy/CRvS6a5sYDUcDVQDbkkrxRxuBcT8DnL0vEJXl/yIHeeRsDgMYN8+qVg/q/JZoXK1G+J4V3zyPRH182x/lFzuuc3gyEg
 KPBs54Q0
 zxmwSqg2t70qOrc3r12tKTmTXqWnRGL937yFVNh33B9BU19UgYDDntkzLBVY0jQz7GchPit2jcaFNwZZiU5HRDkfRZYB8ccyfXH9eu1/sG3V23fzwMR2KYbKtj3MHlkJc73Fbuk4tJQV6SIjv///cIuRgsvTi8N5icZJ3Z1gQn14HDDtaL8KEg0aHSvbOi53nNdu9op2p3l8IiaRR4yGW7qy/AZo2bYuXjY9Juxp4mDnSiEJ7H4VzRJPQN4qGg0qkyrJBLBO5Yt3eVt4ptLMNCSrWhkJ+NjY8MKOfsizFfeZr+sSW2zxLGRVueOW/Dmg6FQA+NCg9hfxQxFKiJwDetG0lnyiFwXop4dimH5jBXaO0iq7IlfIp7xs/s6s9VSuCPYr8lR3BiYfgpGvuNTe0F7DE/6dhQ6Qb6db3PF0NDZmZCsfiXvkQ73AYoL5+9DsErCwuu/OY71TS85mW0gmX7erLWSRTHqFmIyBLOX26SI3p0S2sWUifcnJRFl/K+OLaotAX+2NzjYVk9v+vt9pAkxenyC7WflhhrGu+4wg3C+/pwWUWEktyTAeD81Yu6AaFNPPosmTQs5Y4tGHGTHARLD1+W/pgECBTu8Lmr1g3flGcUUXYeyIVHrRayUrzWTrNQ3ofYzaRwcIZeSGiA9Al92HlzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes two test failures in test_zswap observed when running on
a single-core VM (-smp 1) with 4GB of RAM.

Patch 1 addresses a race condition in test_zswap_writeback() where
waitpid() returns before the exiting child process is switched away by the
kernel, causing an immediate write of "+memory" to cgroup.subtree_control
to fail with -EBUSY. We fix this by waiting for cgroup.events to report
"populated 0".

Patch 2 fixes an implicit unsigned conversion bug in test_no_kmem_bypass()
where small negative timing differences between debugfs stored_pages and
cgroup zswapped bytes caused the comparison to falsely fail due to
unsigned promotion.

v4 -> v5:
- Patch 2: Introduce `cg_read_key_long_long()` to return a `long long`
  value, and have `cg_read_key_long` use it and convert to `long`.
- Patch 2: Make `zswapped` a `long long`. This prevents a overflow on
  32-bit platforms (Andrew Morton, Sashiko).

v3 -> v4:
- Patch 2: Use `long long` for `delta` and `max_delta` and explicitly cast
  `stored_pages` to avoid integer overflow and implicit unsigned promotion
  warnings on 32-bit platforms (Andrew Morton, Sashiko).

v2 -> v3:
- Patch 1: Collect Acked-by from Michal Koutn=C3=BD.
- Patch 2: Explicitly cast stored_pages to (long) in delta calculation and
  inline the return comparison (Michal Koutn=C3=BD).

v1 -> v2:
- Patch 1: Replace EBUSY retry loop with cg_read_strcmp_wait() waiting for
  cgroup.events "populated 0" (Michal Koutn=C3=BD).
- Patch 1: Clarify task lifecycle in commit description (Yosry Ahmed).
- Patch 2: Remove abs() and declare delta/zswapped as signed longs with a
  signed threshold comparison (Michal Koutn=C3=BD).
- Patch 2: Add Fixes tag (Michal Koutn=C3=BD).

v4: https://lore.kernel.org/all/20260828033741.2184560-1-wfelipe@google.com=
/
v3: https://lore.kernel.org/all/20260827034807.2822234-1-wfelipe@google.com=
/
v2: https://lore.kernel.org/all/20260824033533.2147900-1-wfelipe@google.com=
/
v1: https://lore.kernel.org/all/20260804042053.56940-1-wfelipe@google.com/

Wilson Felipe Pereira (2):
  selftests/cgroup: test_zswap: wait for cgroup to unpopulate in
    test_zswap_writeback
  selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in
    test_no_kmem_bypass

 tools/testing/selftests/cgroup/lib/cgroup_util.c       | 17 ++++++++++++--=
---
 tools/testing/selftests/cgroup/lib/include/cgroup_util.h |  1 +
 tools/testing/selftests/cgroup/test_zswap.c            | 13 ++++++++-----
 3 files changed, 21 insertions(+), 10 deletions(-)

--

