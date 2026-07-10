Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D8CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B72D6B0093; Fri, 10 Jul 2026 05:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48F296B0095; Fri, 10 Jul 2026 05:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1996B0096; Fri, 10 Jul 2026 05:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0916B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93F568DCB8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:28 +0000 (UTC)
X-FDA: 84972354096.05.34C63C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C4E39160003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q+4J0Pd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=677B5n0kvLgyERJskeE3rTX4vg8H2agSafboCd79Yqo=;
	b=RRBUmMW3PQDPZ/+3nnNPKUqvMXZnEyrk8OudB/0CI5Om3ATQanves6j4xdEmtY58dl9q4K
	eiLUmuiP0AfynuTnzLaA8EHOm8B1Hmp6wPgXfJtiCbQhP94FFCq0zpgNtyHFBMmKxIMYEC
	bVBQyWY+VhhldUNMF8bB3rC2g4shxtM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q+4J0Pd6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676006;
	b=gqFBiuIw1a4fEELUti8PG9VS5Je5Uz6sq+9Tpu7Rx6yW6L5pa+jtREpGNCV7BN/4NRwFIQ
	QNcg3ZHF15AyaNFGcuIXNErWpDiDT82eH9mZ47idytrdc4+2o12oZi0L2dn/7X4gn/HZQu
	QfwGu5pXm9OFSOn70eLneYy6DOSF0iY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E4DB43EEF;
	Fri, 10 Jul 2026 09:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE32E1F000E9;
	Fri, 10 Jul 2026 09:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676005;
	bh=677B5n0kvLgyERJskeE3rTX4vg8H2agSafboCd79Yqo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q+4J0Pd6ng6ubEjGKldN+ZwnNlaXTHRBG4JDGidI/IFXx3AiPc5GYSSB8dqilObCI
	 DeHusH9lngPlqGDv761pwm/nPtfB6CWlhryRuw+077asKZRErtQv6fvHr72V2kTk/v
	 lTp5Rds+eFiZylc4Mm5T/eVoIyIZ6FvpDf/HPEq6cFC3j6XmOpsVvitO0Xh1aCcVyi
	 dNY2OgZ5fNVud9Ry28m7d2TiJU99WLMgTPI1U4w6/yGfodxj0ugFp1XCfFTc9I3xbl
	 R2ZPBJJcG5inqt1O082blA2cwCARQCitjSa1VN+rwp47B0vFqeEj0x+EPMoKVTHsZG
	 3dScYBrQpxFQA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:03 +0200
Subject: [PATCH v3 02/24] binfmt_misc: use exe_file_deny_write_access() for
 the interpreter clone
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-2-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2087; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AYPobXhR7tlhSW9eVD0N+FrhRjSI1w+57SYynhHowac=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7InL7jz/42a2SStPxL6X2XHSW85+ePiljGFT9Txrg
 bv3P65N6ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIyS1GhrfvXG0CXqa2Pbya
 Yz0xyGbdMT9D3hi3XalnlC5MimI3sGdkuJ7Zb3wooV30yU21FsXU91d4//5jvvooLC1mWnLtg56
 r7AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C4E39160003
X-Stat-Signature: m9yf9beyxdaziubhthhstq7idhtpkdxu
X-Rspam-User: 
X-HE-Tag: 1783676006-484026
X-HE-Meta: U2FsdGVkX19Sno02qi9y3GgtuQyCSLd9VY7hxsZbYaDuhO1xm1+aO6w6u0ohYlWphq0wiA+UCuIhX3Kd22kv9C64NzU1GZxwB0cnc5oIv5LHNbzBwoaaZRt8bwui0PknMLIpLq83Lk2Bubfc/DPK7/XxUHshUSJKxb+rpL5C3X4YZojXoTvEqAsjBSphhV0fPjD2On5OKIxsxK/wWasxMQUfKAlBzuSr3LvEIfwIBfACAcfK1d9tevctGivRi4Pil3y4e150yuKLOkAZPhBu9VrjoGO3+buFU34eJSEVn/rU7eT68q+FxMvgg0+XVGnkBzsEoxjh5kK6wBnJt95OONiSCBa86C89/+eJ6wCM1jPBZskBh9N5+6EMpD3VUDmYF6Gk4/CTjWqhFJv/w6uF7/xPFM89OwKrsby7mPjBhuN8ABs1yw/Guhk7ezkRrrjF5MmPxpMjdH/vxu4PMFuHPcr155hQkTdi5dSdetI+Ru0SPEpx35gYr+KdQAfL9qUcizrkw19o/3EQSG/we3nde4pEgf4oMCQFg8sKgVrGVSZvybi0rDdewrtUvPNMvWptzd1A6V4ialAiIbfVDRd+TiH9HOdb4Ze0+QyzIBcOX0fYE81SSYXXFva+eQT/sNANXyKdfpBplSj3vsWpwnrWm4H+aIParxQ97x3zbU3KRI/tbic8aFQJQE4xOsH5x4RmXVvty7Pog64OFkH07s3XRSh2LHeW+7K4ym2rVXaTILpllxILuG01olWcZIW7EHdiLBbZhhpiaaJM8cCRMtwIrsNGQwXX34r8ZRs39DKHmShggVMzGTjUz1A0apZjj8GDtlnLzVMkazU/p1Sn6QKy7x0oZJ+LM/hWc+t+w4+qvLZU4mVdsv6aMCNWseqD9yJTEEUzR/+dwjQ02wiHaJLaOEIHtf7NfBRcyEEN3g/Eh2wb5X3VD+3RT9rBN8ZdxT7qNSWCo7+RcUM7hPSkvvY
 AGLXcEEQ
 j37pRqYfZM61OEyj0qM5IStrdQhgSuHcvCt6pyXRBwZdaXg7NozPqnHg16afK+PMpTjp4eJrClNcbrO6MfjraxO+vGB0kjlwio+8+5R8bJwS9wmqrpxftJgkLkAB7Gor7yuU6EdCymgRaeBBOymvEF7e05WBLghCwZuDgyCGReAj1Hjh9JRfb0kuD9rgUaWoZBNxjfM+JZGoxFS+fK6msuYSzedq1u2HRuZh3lrObRHY2GoahLuUxjqHTERcsgceuXUTATWIRPEHLj/nMHFPGyRymHF3qRTHg+r+0RVYy8rHjJfIFUnO+K8bs9Gn2964MnyD99qsEFrK2/0K5VHdDXuiRPnaG1j7iV3ehJ3+2XSEUMxbigy1wPzaGjOlB3NdJyWBqmKFljbih9jk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For MISC_FMT_OPEN_FILE entries load_misc_binary() clones the
registered interpreter file and denies write access to the clone via
plain deny_write_access(). The clone is installed as
bprm->interpreter and later released by the exec machinery through
exe_file_allow_write_access() which skips the i_writecount increment
for files with FMODE_FSNOTIFY_HSM set.

The deny and allow side can therefore come to different conclusions
when pre-content watches are in play: if a pre-content watch is added
to the interpreter after registration every subsequent exec through
that entry takes a write denial on the clone that is never paired
with a write allowance, driving the interpreter inode's i_writecount
further down with each exec and leaving the interpreter unwritable
even after the entry and all its users are gone.

Take the write denial via exe_file_deny_write_access() so both sides
of the pairing base their decision on the same file mode, and
propagate failure instead of silently ignoring it: an interpreter
that is concurrently open for writing now fails the exec with
ETXTBSY, exactly like an interpreter freshly opened via open_exec()
would.

Fixes: 0357ef03c94e ("fs: don't block write during exec on pre-content watched files")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index de50a7468b07..24142859658c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -252,8 +252,14 @@ static int load_misc_binary(struct linux_binprm *bprm)
 
 	if (fmt->flags & MISC_FMT_OPEN_FILE) {
 		interp_file = file_clone_open(fmt->interp_file);
-		if (!IS_ERR(interp_file))
-			deny_write_access(interp_file);
+		if (!IS_ERR(interp_file)) {
+			int err = exe_file_deny_write_access(interp_file);
+
+			if (err) {
+				fput(interp_file);
+				interp_file = ERR_PTR(err);
+			}
+		}
 	} else {
 		interp_file = open_exec(fmt->interpreter);
 	}

-- 
2.53.0


