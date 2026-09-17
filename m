Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10810C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBD56B008A; Thu, 17 Sep 2026 05:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E8D6B0092; Thu, 17 Sep 2026 05:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CAB6B0093; Thu, 17 Sep 2026 05:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E55F6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:17:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52848402A2
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:48 +0000 (UTC)
X-FDA: 85222701816.27.9CE3618
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6EDA740007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:17:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cq830zGn;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789636666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XRXB4eKXDh9tzHWSRw/MZmLlMVEZcS/C30rGMlm+zko=;
	b=ViKHQnSzWp+8XfC1toj3tVWXaZe8e4IJ0PecNeGoP/fety9ReaS+ZCftA75KGHb4ie+Vwo
	/QeDNTstYhI+D5pVl2Ilhzh15V3tvWW9VhUJ8tv4RuOoyEBFt86A/KwKFIrbLJpFENbhbt
	X0v+0D/lJ/jiKg2XJY3gOE4cDE9rRfw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cq830zGn;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789636666;
	b=eDMb5OxALdVxR+5TE4MwTAu1urOJnzQjWZzEY9PpBqWloCac5+T8HRJrJwcrrPqFxDphmn
	WBXgrdM6OwA5IF7e/qfdXTKUuhRrdwQwjsbqxfNInFVCLP8j0uCGzZsmYqtQ+NosuvsO3J
	S2p1/0vswheHTjyA0P4Hw2tXbCMXlIY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A40E442A95;
	Thu, 17 Sep 2026 09:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71891F000FF;
	Thu, 17 Sep 2026 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789636665;
	bh=XRXB4eKXDh9tzHWSRw/MZmLlMVEZcS/C30rGMlm+zko=;
	h=From:Subject:Date:To:Cc;
	b=cq830zGnvva+8bgfDs4bFsp29vmF3yELM6zTGVErjy4IfDyv3qjh4BmGG4ojI9vM4
	 /wU8vg/EJT4NMC0z4SlEnPTTkt8fPGCbCE5RycNqeuxvokp+N3OpU9GPQkgReTYFTW
	 k4QKRb50uMeKC0ESGuG2bpLf+/QVBf2VJBvYIKppGxlkt0Jd56kAQdq097xInQxkpM
	 QoNMj67aKh7T51ysO+g+b2qs+hCJlHb09FbWINJpRXa+61SwiQ580a6sbj+BfIC376
	 VkxDe6K08R4CQL3TQQVstF9QHLXCPZjS7gr0C0LUifzfD/3Fu5jCHH62XynByyDs/R
	 /ROyID7sf5T+A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 0/7] coredump & signals: an impossible affair
Date: Thu, 17 Sep 2026 11:17:27 +0200
Message-Id: <20260917-work-coredump-fixes-v2-0-f3787fcda051@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/32OQQ6CMBBFr0K6tk1BkOLKexgWpUyhoi2ZAmoId
 7fFuHX5Z95/+SvxgAY8OScrQViMN86GkB0SonppO6CmDZlkPDvxKi3o0+FAlUNo58dItXmBp9D
 qSijBNZSChOaIsD9C8Vp/s5+bG6gpqiLRSA+0QWlVH09Ryn5StndZRCLaGz85fO8LlzQq/49ZU
 sqpPha5knlaCq4uA6CFO3PYkXrbtg/kp+FZ9AAAAA==
X-Change-ID: 20260915-work-coredump-fixes-edf98c80fe78
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
 linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org, 
 io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1706; i=brauner@kernel.org;
 h=from:subject:message-id; bh=mmzPQj/v9mvBIwNu+viZvNM5NC3I8C8gJ4ZNeVSEI5M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt3mBsaaDA92pHz8xsg4rvM3+nbZLacGLjO5PvpxvS9
 234nrM9t6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiDYYM/1Qstq7Yu8muYO9r
 Id+y85Mae3KWS7VN/sirqePYwF8yQw2o4rNT2LJ3GscPXOEv6ZJepSwsbP7m/CXPvrao6z3aQZP
 5AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EDA740007
X-Stat-Signature: rqigzpwim7d5e5zr1q8tph3kcqrz8eyf
X-Rspam-User: 
X-HE-Tag: 1789636666-543679
X-HE-Meta: U2FsdGVkX1+9RADcJbxFG6dtVoGKc+OEoxCLljxrr99aFp5xSOhADENTyD4pBHMgJBonqz8TA7Lvsm4MlfhPVHyuQGIKnUg/BJvzbwLG6qm3Tm2XqVf1fGJJSD4bg9b9N9YK4ZZISXLPEfgKlPApPTowPGEBrjfr3XucRUqVklJGQVEHQw5Ew4Cugs9fDr8oxevltjgzJAcJ1g3iL8Q+s+OoNa4RDsYbP07ZbgfuPhedMSaApKG/52waxv1LwNWh/iR5zVboBpFTEaX7k6Xd4YgdKp/ZP3bazLoz0BMHS45dlfszfczyIfPX8ZwojHgi66Ys2mKl70VpvL1HxdnTt1Lb5fgFLecsoEVQ2JCoiCkilvXEM2cK/bbYIWlVfUEJaKIp3QfBCJvyu1s4T0+A2qdWyS9FqMcCXefWPWMz15+cijIqw0Bt6uW4uKX5bQ6xlYfSnUBiB09IG+AZ8wH3ulrlZYxdUqFWmSuXrYVi9Z6oxTpOBe9LAAxcjT7jWB03Qx6kr4LU3v62nNJoAQEC4ECPBeos5RDx6+hHTBjH6FGfWsR7tS9vQGe7sX7mychfX6GTHDORRkxgKbI4H9vsyf9PKfqDfaxCEQV6RVhJdYL32M+xE+u9z4NFVAmmBS65Iit2E0sOuhKN8EEpA6gFbhHeXQN/BtdjsspaZpQfLAJ3aKjeUDKBgcJpHYrCc/nYZjZflcKPt8tpdPCiUJ7SFa8ixDnagfZNL15hjGpR1/WkzysreLjOZO/hAHQ+MPcfeQYWE8nnQuf4OwKliZh8Y0ODIpWNc/9G48R7McHJabut3xULYZ93F4Mu5dwji/iV+C3hph86WYfcSlwREcVWl/AwLJjL9sSi1O/xmuk/WXwSH2pUz3b/3aLiEroVYssjOZtIHSm4PZml+qR0a2Rjmd3WxcwzoKsOvy1+F3USEjaH9D8RRKIrmrqMegizcUJtTNQdx5tsUCwc/S8cwaV
 EvNv/CKk
 FqcGHnZLfUU15rrtKZ69fzpbqM0k43YVJJRq4UBGXsmig/fGDEr3vvPv/yRbXqy7vT/YnWkdxWER681x+bkKqUMed9G2GqicWwqqtqreLdbz/HtW7ZVIblvdFV2mPIaw0x1AqxwxSZ7Qd2RE6V8StfsgjDYODM6H2KMFlhSas4CG4vPuUnIujzJ4iBCCkzEjWDlyGrt/WQAVrCMQBIk/TszgBNp03TsUCKNhSkMVQCEqpWLGfHTBGfC7zMgX87H8ujkEFGH4Sf+7NidqnVyv6tatABF5/FuqMabVl2vJOYXLC5j013McLzYONsVRRRureIjwwTwn0i11G0Hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

I asked Chris (Mason) to look at some of the coredump code with kres and
he found a couple of things. Some of them I had already found and fixed
but there's some good stuff in here.

Other parts should be more straightforward (hopefully...).

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Add fixes for retarget_shared_signal().
- Expand fixes for signal_pending().
- Link to v1: https://patch.msgid.link/20260915-work-coredump-fixes-v1-0-f354ca41780c@kernel.org

---
Christian Brauner (7):
      fork: refuse new threads while a coredump or an exec is in progress
      coredump: hold RCU while releasing parked threads
      signal: only SIGKILL and the freezers interrupt a coredumping task
      coredump: parse a snapshot of core_pattern
      io-wq: order the exit bit against worker creation task work
      signal: don't retarget shared signals in a dying thread group
      selftests/coredump: test shared signal retargeting during a dump

 fs/coredump.c                                      |  72 ++++---
 include/linux/sched/signal.h                       |  19 +-
 io_uring/io-wq.c                                   |   2 +
 kernel/fork.c                                      |   6 +-
 kernel/signal.c                                    |  12 ++
 tools/testing/selftests/coredump/.gitignore        |   1 +
 tools/testing/selftests/coredump/Makefile          |   4 +-
 .../selftests/coredump/coredump_signal_test.c      | 238 +++++++++++++++++++++
 8 files changed, 318 insertions(+), 36 deletions(-)
---
base-commit: b813a7ec026ca59a444ba0a36c2e17ac823eeed0
change-id: 20260915-work-coredump-fixes-edf98c80fe78


