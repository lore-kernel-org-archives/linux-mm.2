Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECD5109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68966B00ED; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC5D6B00EB; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB406B00EB; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0D176B00E8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:54:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60C7EBA3B4
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:38 +0000 (UTC)
X-FDA: 84570820236.03.EB2A11E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C637A1C0003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:54:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wn8hxWdj;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CLeZPhiJ8ygtluFXU42mvqc/iX77PFsduRfgHayTOjE=;
	b=xeNQEfIQoLkE7WVE82VB3MMYT43mNbMoPWX0f6QJQuneL+Y6FswRfXvcuzhi1lAvSzcina
	XEVzePmn9um7tHAUutiJjHCUSMIYtjhiFT76/VOP/D8Fvf4lr5Mg2VoxFf4KNBIOaSyMMx
	NPd93vQHHYm2lqrgq4osEaUcXZyabt8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wn8hxWdj;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115676; a=rsa-sha256;
	cv=none;
	b=YSBQ0hhabvAuIFCok0tthJ652eZECsAjKfFt2AA5kc+JDplbjEgk+XyQOG9Mk8aS3GHyXn
	+La3Iixi4zS8ScDZf89ZiXgA2j7AqeH8UrCEHWymneIbd7XcRTIpHKB7jt6VL25LGOxjkP
	8/8umefJat+kopgjYiVHVjDi8f/Y8j8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B924C4051F;
	Sat, 21 Mar 2026 17:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F0EC2BCAF;
	Sat, 21 Mar 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774115675;
	bh=YoReG2ITY2y0HZje9C+bQfiynbTvb6Sk5IqZjXN4jgA=;
	h=From:To:Cc:Subject:Date:From;
	b=Wn8hxWdjY8nwvWguSRylu6QdUeIm950qxeCvN+XJLKNCFiGT1rvu2S3BS5RXw2cxt
	 Esz/AQ9kDq9aoqZS2gvlm/exy7gvh/sPZQYJmZLwErh98XF2l1RsLHDkI0Am6AeDtV
	 JF79+nbLaPdKFb+mn1AH21nzU/DA/fPW4L0XALHGz/6vJxNMRkCE7RaNZ6tyS1CxOY
	 fe4GrcRbccmK+BX5mC2TDQiN1yAcXHtY6AtKZM7AOe6ofrFZl07nsuJrlM4M2fc/Nt
	 pX3SCOAdu21ChF8POhoezaza/gcja1Matw0PGMPkd0Ez9SaxagAGL0AlFW4Ar+RSOk
	 cUCw7yXoHy9bw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] mm/damon/sysfs: fix memory leak and NULL dereference issues
Date: Sat, 21 Mar 2026 10:54:23 -0700
Message-ID: <20260321175427.86000-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C637A1C0003
X-Stat-Signature: cssurfszzjeebcqirqpy3c5s89s61xu8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774115676-135309
X-HE-Meta: U2FsdGVkX19oNHfL3J00uL60PatOtAgGkPypR6Q02jf4pSGortIi1Iszefwkq9RpDj6DWvRaqQaWhRiIIo/bU+scjsim5DDGOPzG9+huIXD2YlPgqqxReqByUIKd8nQl7pLAH1FKucya0et75INeEwm1rcc6j4gtAYGXvbMFK+lrK578Yzru7+5/8gLR4CCM3tgpR43BP7ynPUjGW/3n70//oA1WvhgNRTPzeYMk4PRNhn4YHKPAJsrpJeBnyU6LnUS4uKGvtHBqDz0cvst/sVfAPd6eWZGMHzdp36zRNtRjHCHM94ZHwQpcw+RiYgiJzsqtHzqh8BGjzKrUg+D7f6ThJQkfIdXFG3+nFlqsl/3b1xo13s0WuAwYC8b7leRgbBPDS4YhUOFPuHnlWaR2RyvW0Xp53bEdBYvJvIYtXcJAO5SCh5gZ6EN1nxyQDg5fC1mZP7Hq6GZiE820U9aPoMmZet1ok882OR84WmFgZVaniiyXNnnn8CEV1kq+jU/kROKnSJ4+/22kRQif67dhJCEmhBqsfrzxRyvjuYTGrMel2p71u39uKJ4sEoeJWvNdoI9StAcJPwCbPVump1K0qy54+2XAPveXJ9dQXSmCVFFF26DtJJjNHR7LVTw3BVu6BNyUgVPhOqEvQ6tdx4b6pzRSjufNFxw6gJaEq0oPiUnWg9IRwKb+yBsCpSSR6KQvHaIgn+QRqDrl33wvpTuiP535JhmO838ePaRst9u9N4I6zArZp5ChmOmgeiLFwZfsi+/sv8T5YEtnz4w4ffyXHW4T+qqVc/X3gPQ85Y4rS/sEqwe3QGhZlUXdW8+GEf4k/VLYi7/ie14kpyILhKmIQJxalMcHs3romY3m7XKx0H0lF8RLwv9/tdbcV8LAoSAm2li6jXofuQ4IpLqTRxSoB86UYAfoW42+GVtJk/BAALvZyRkEwOLmhsWRALIPm1i4zJGotKj2jgrt2aIfIbc
 UbU+OziS
 LsF8hx20Yel1X8CbbDiaI17rQgJGAcqaEq43y9ddGJnVEP+hW75D2vL6KFdHgJ4ggYsiW9ZA0zmLlwg2ie26uqm/rA0XanqvKje6R+rLjK+8cmKbzKHtIxAfIlhv9l3fzdratbUL869NmuPi4d5+cpU0Mg0+CyJeaFKfcuOKSSRWwD5I2v6g+zyKyB9P/2dcX6x9TWp7pS7C/zQzgsdw0dYBLWqoXpF7VMqJKuTBexkvT76UN332hqX1op4SmwRyeayOzspMPy3jjSfZPLQzvGwmp8MaEO5+YdeCC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SYSFS can leak memory under allocation failure, and do NULL
pointer dereference when a privileged user make wrong sequences of
control.  Fix those.

Changes from v2
(https://lore.kernel.org/20260320163559.178101-1-objecting@objecting.org)
- Wordsmith second patch commit message.
- Add NULL dereference trigger steps on the commit messages.
- Collect the valid Reviewed-by: from SJ for the second patch.
- Rebased to latest mm-new.
Changes from v1
(https://lore.kernel.org/20260319155742.186627-1-objecting@objecting.org)
- Check kdamond->contexts->nr from damon_sysfs_handle_cmd()
- Collect Reviewed-by: from SJ for the first and the third patch.

Josh Law (3):
  mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx()
    failure
  mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
  mm/damon/sysfs: check contexts->nr in repeat_call_fn

 mm/damon/sysfs.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


base-commit: 42bc5b563370622d688719aa248a4c861839373a
-- 
2.47.3

