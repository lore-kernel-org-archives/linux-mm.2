Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA95B606A339
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6fD9mCr
Received: by kanga.kvack.org (Postfix)
	id E1F226B05B6; Sun,  8 Nov 2026 15:15:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6B16B05B7; Sun,  8 Nov 2026 15:15:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C6F6B05B8; Sun,  8 Nov 2026 15:15:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B630D6B05B6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:15:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44D8F1204C9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:10 +0000 (UTC)
X-FDA: 85413055980.13.2E8C1C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0CEFA0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6fD9mCr;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P75XztLr5IL9Ot3tsv1xaB+BM49nfqPilwdmFEEROM0=;
	b=ZcCGWiiN5mipF05J8VUlAH2XfhN4S1PIrCPBLky2h0dtN94ltDNO695C3F9A1pILYEifRX
	G/bLtBAnK+pt/3O46ASiMpzg3EOayGXndShxM0aiRMjlWat/hOmdAbKk07gafxouo/dV2a
	6DFszdk2JIILvlc84NFz/34a8odfRao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168908;
	b=rslSbDJsy2S/FQf18KH/IwEFJQIqe+YVFYq18zxuBfebkl7KJrPzC9RNpGAHE1eAkwT1Wj
	lYW2nn1JfJdGA9yfQLHzFZDwJXFEkc8raPF4zCTOCRh4WjonjSNzEcr3+NcrhaYSJ0yiL9
	25xMd6XR2xJ4GLjv62gL2XfYUshk6mA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6fD9mCr;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55139609F5;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD22F1F0089F;
	Sun,  8 Nov 2026 20:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168908;
	bh=P75XztLr5IL9Ot3tsv1xaB+BM49nfqPilwdmFEEROM0=;
	h=From:To:Cc:Subject:Date;
	b=l6fD9mCrsJ5XYRkRAQHVZUO1675trAEW+KF3H1cCmc/LSK+grgE06c2UvConlo0Wj
	 Bdmd08hoePlpA/3hGQlSCCE6oZU7Y9vklQl7VX8p6Z90KdeW/GL0BDRBdXMAb5+J9v
	 siNuw8mhtAp81z3UMeXPDTYS6puGmIHtx93+rVEd99ITuiIKuE6/S1x/Mmq+G8WujM
	 K69WMhyBq18HVmTxaQWxc4Ly/h6IP8KKdqh1EtNbLSYI74pEfgPKrLCa/bfOvBeOY4
	 /y/PmQni3lqEhg4foZJJ/RqiJrdsImciUta62n2xWNO7Gx96kpakRUH0myv1Dm7bMk
	 3ImyhU2ClPk9Q==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 0/3] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sun,  8 Nov 2026 12:14:52 -0800
Message-ID: <20261108201456.116824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 681qsxuap5acu56dah1sdwf9mio78u8s
X-Rspamd-Queue-Id: D0CEFA0003
X-Rspam-User: 
X-HE-Tag: 1794168908-68450
X-HE-Meta: U2FsdGVkX1+aGEguwl69YDOIXSS/1Jm27Z6M+l+hwOq3X1vDISvKM+MPlQGElR9asxRR/zJWRGibk8DhjuyK5hpTHsN6XmrpSqQjoEjwG9i8MIVh8i13zQIUujX5Z9RG5TvaLD+N6jEU39kQ7kIZuh8voyQa83nQCbV1UKyQht2UREsBn410T6ElGHCtp7BuRZhIu5kPNr2eBGzeZ9ggEbmTsVrYL3LFE/lmi2TcKgY/RvvjoT+9KWH8B0YGvy1UVpxlBDc0M6g5+cruMFAM/TnoryYiEdI49Ql7I/q61DdQZMFK22iGZeknyGfgnPfMmirXtYuRFE/ddsY2FjjGns7NSv7Ls7EUC4WQoaxCbLM0TZxeIY+wA3eOm/L1QkyffexxFlvq0BvfJYbx+zsNJUAfdF1Vqes/nxIayt5ykLBM0NIRtNqxg6M7lwHId0pcq83+4ho13ASnMCNdX2dpw78FJQ3Zi1eAKerrVH/QEHbpORhjGVTwiywpBbGWmUtVrIZ/bkQLeNzAHsZFqyjbL4cxYcKknTy4f3A2ytQnWTWXRHq4WO+2NMcqDlcwlO1ZBPnvDRRghyIgAje/se7Qpi5vRzk57dtpwPdVJy7MMTO5jL1j+6WnR2PF6CLhja881Sw8Znk0iCJJDwBZfw0GQ24jtP+Eqat/r/f+PNBfi91UaamaVpeBSyB3kt4OrGHV5Y7Z5Q3NPFfnuPwPkelYJ7/xDo+emESldoZ48Yc5EkyfUcISHNPDGcBBrpH19pD/jD94zaL796I0Zook1PfLq8r6HtSLLPxmSvCI794X7rEO0H2TCjBEaQJ0Ty+8g3Se0vErFHh+JFSGeL/4KvsTDbsTF9iWUN/J/nJc3AUZqc1rPp5H+6z6yaUxyWeCg0ndwDnmEPAD4Tfb09BF5teIp1KdtInqx5T0tVa7CSxcLZtad6eS7bJam+mMR7wTXrpScDHPhbFL9wOtlXx7zeF
 JFIZ6B8I
 rKwaYoUxMFBX7jNtsuR9e9WOtajWPzjmdC12ngtGVd114wUDxgNHnGadif9fxQCPifOdj+b+ioYXU6BmUkEZ3M+BcW1QDhSMcNTV3EYhFJtjnM4dljHNEoC4KhLZtUwLXqTDHHkTW8sAlVtbS7S8nO1v6vHm922c8x2qBwaQ5cL8EKyeJlnQQQ6E6c/KSk3ildFz0pGXKE6mteNwf0hJHnhtgkFbHsI7MzrlL7Uqp/AxT3oc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port three DAMON fixes that cherry-pick failed [1-3] and turned
out to really need to be picked.  Note that seven patches [4-10] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107053211-failed-6.6-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107053907-failed-6.6-bbeec2d8324d@kernel.org
[3] https://lore.kernel.org/20261107053915-failed-6.6-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[4] https://lore.kernel.org/20261107053348-failed-6.6-6f276422aded@kernel.org
[5] https://lore.kernel.org/20261107053350-failed-6.6-cec08aad3def@kernel.org
[6] https://lore.kernel.org/20261107053353-failed-6.6-409d2ab6d982@kernel.org
[7] https://lore.kernel.org/20261107053355-failed-6.6-1bfb9384ae0e@kernel.org
[8] https://lore.kernel.org/20261107053357-failed-6.6-a1c7fdaf1657@kernel.org
[9] https://lore.kernel.org/20261107053400-failed-6.6-1d2397b2c414@kernel.org
[10] https://lore.kernel.org/20261107053402-failed-6.6-1c3352282063@kernel.org

Changes from RFC
- RFC: https://lore.kernel.org/20261107222202.331476-1-sj@kernel.org
- None.

SJ Park (3):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: filter out damos address filter-split failed region
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core-test.h | 11 +++++-----
 mm/damon/core.c      | 48 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 13 deletions(-)


base-commit: 9990534f18e75bebba6b6a557012d1253980de9e
-- 
2.47.3

