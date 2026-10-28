Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72356606A325
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xp27y3Qk
Received: by kanga.kvack.org (Postfix)
	id 888426B05C6; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838036B05C7; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776506B05C8; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DCE66B05C6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C042EC0A4F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:34 +0000 (UTC)
X-FDA: 85372238028.04.5C6AD65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 497DEC000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:17:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp27y3Qk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793197053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J6f7JSuYXknDVja0lBd4MS98hOKm2HMrf95+I/iqXAI=;
	b=UsebVcivFM716rZOqZLPKIWB4k454DrerEvo8SaZI9qazHyylz+Yl+TOjp/isl4A/O/oeW
	wPmxJ1sU1s+mf5Hhv0EwqCHRRKW4mPMxZk5svfgpOqKelpbXFAF5iGSgjm89tkTfnasEMD
	26Bezj81zmbfj0alyXicyffkjt/iqvc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xp27y3Qk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793197053;
	b=LMnNT5qI6ivkNURJeRnYZPHU0egXq+BRRTDKdrMQuvojLFExEPazaqFpP7XVRSlXFH7BdV
	Pp8pqDfQ1zQctep/pkPhKKos3ZzJsqWGr2YaNRskfVWvQCm6nzSF9clcJ+UTPDM5zbd+eI
	IoemvxaKovgFPAB6cENDBx4RpkKD40w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0D89601FA;
	Wed, 28 Oct 2026 14:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5999A1F031EE;
	Wed, 28 Oct 2026 14:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793197052;
	bh=J6f7JSuYXknDVja0lBd4MS98hOKm2HMrf95+I/iqXAI=;
	h=From:To:Cc:Subject:Date;
	b=Xp27y3Qk0/PcLRDFNJOilMflz/3QlpWLyj9/vbuUvfYRpFHjWc6PrYiqmDoRdMdKH
	 m+WGfcoGVYmZL4m8HawHgUSPWrrmeMDWWOMWy3X3PcXfNO6QZ4VaxebIZdvByTji0r
	 aeFDjWXZI5BllWJ7C1wBFtdDfhzNWXkxZGdArLp5+etlqxbfBtXxCyXY8sI6Hjt2mG
	 sfFOicrqrd2+N7MjWs7QzSh4U8Iwy9TCBf+U8QuItwC9OA2xc7IEka7Ssr7Zz+qL9d
	 jqYBhr2bnSnkb9N/DAbYOIjbIP7bvFv4Y73r5Z43z8XswxkbMMmSKiqPILclwVhy5s
	 XfJ8aUbb1iACg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.1.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Wed, 28 Oct 2026 07:17:20 -0700
Message-ID: <20261028141723.161776-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 497DEC000D
X-Rspam-User: 
X-Stat-Signature: qfdmmr473u3zae5jrkoniqddbdjcj5zy
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793197053-780344
X-HE-Meta: U2FsdGVkX1+Gue5UYgx+TOxnSccQ4N7H+5xXSU+q1Fi/vW2CmVMrP42urcHXwesP6q7Osn2U25jIGgJof79OwBR85sARVg7TD+siflVVik3nlBGlDX8iOQdI+h+dBeH/hE5fb18/SWU5+91pCV5W5OyT8LyQ6cKBUduY4MXOASENwsBUKQqJJNsjPQBJRNAWKlqQt876PIJ6r8bEHXHAi9yPBFNj2SB0J7DJWBMIMATbVq9lozzMP4/Lst5F9+doWQkpO75Z03bFyKrB+b7RtCTVjAoG400+ux4+uNgeC4Vva9LO8RAkveK09J1SqwRX8Y2PrsXobrv8xkgr7ovsejQYGt34GXXxtIoIzPwmOL35sSqJ+l7jr67sXjvtWfQvjgjjJrao3/D1akdeDZXdW4x2JaO8ia8xXRo0ILnCmyRyM/VM5ycN6JzFYxb4hT/cdvu6CcRYLt1/FbNtMH98B1ksPjsyLNc0Bo8JYme0eWyxnZVzEXE10nbVhrfH1ZxvKDFN9w/fqWOv7Wl6xrN9nAD+9vEq82QpsX8Q1RXIb/tsKfN6Zek6pkK3Psb+tyrGFus3B9gXlH/z2gJpOOdGpYN9Ee1XTOZNoLa5VtFfi/LxBPjuSjjYKTY6O2p4veKvK+07PMrdx1MEYAWWJ/UNQV24iELJo0EQxHKEM3s3d5Y+SoQ91+n7FZMJ0zubkupTDiML0GpnQsAVeb+UoSBY55zvaEjki9fzY8wQwIXfcWnta+SqsqP+FtH3+VM81EuX2Ka8sGn3yyUxuiUUOOpXh06CTAPpxC5blq3DZ3rKKvMdc2pDG+7FeZrUcoEdPDXh1yuGVI6bk3o+PWilMoo1GgGy26DuhE7VHKIi+RTvuO+8OSmXk88ADU95acRBy8uOaB7DmIl2QWexxKhaQH4g7a4saOWFguEL68js/DjzBYRCN1P/Ubw1PnQlWTQTlThViIii/Xmh4MlfFXMZyKO
 ts76pl6i
 svp2BictlnotLc2t3FCFtKHZkw7+cVn2JCiDQEWm55xd1drEDN5bY8HY5V6mVgZMwJ2jRgEEiFydL7RRkGGXWKyD35K81XHr4xW/70M3Wa7KVIfv1RxuRnou3R41zt0/TS+o1rGB1MHJa/E4k3yxlaiMN1hj5EHFOaendkg2OXDuUn9b5ESaxYH6dhUTRwciyFFoH4tmsQs3BfvldN+sOZ7kGjnhzJ3mg3HDw/yOQcgDVk/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

Changes from RFC
- RFC: https://lore.kernel.org/20261028051104.154232-1-sj@kernel.org
- Drop RFC tag.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: 2d552c13645b4174829d2e131c6f6483a5111b6f
-- 
2.47.3

