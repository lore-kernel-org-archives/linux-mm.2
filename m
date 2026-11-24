Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427D2606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nN+bXffD
Received: by kanga.kvack.org (Postfix)
	id B85B96B0882; Tue, 24 Nov 2026 17:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0B16B0883; Tue, 24 Nov 2026 17:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989986B0884; Tue, 24 Nov 2026 17:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3676B0882
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B91381A0CC5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:51 +0000 (UTC)
X-FDA: 85471531782.08.C8F07D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 040311C0008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nN+bXffD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561190;
	b=ep8IPh1dXe4OVeEtthUMD0Ee7CvpEzPQRpMYJs4ZULWlT66lmMPBHcoXrmq/rOMp4eldu7
	FSZqiR+zu5DnswfuTtAIgeviFTQTBdlFQzm8SePEkmJdxkh+30ugCVniBIyxhAQjSSOmYD
	ABkvPqY5QdwPchq0d8T55XwFFSF/JQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmxU8jlcQAoOmz9SVXAVr4svm8Xhliz6+CM8YIPXeGA=;
	b=ETAKUOdOUuZMFT5TVv7WSfxoY4oiqsUMmrUIZr/O5cJv8z/p7GhyRTydEAith/x5GWFWn8
	rYFd3Eti4tJykkf7CnA24IlejCnBYE+XgRexo+YC/EbtTZ0wOsCnMP7Qv7O+PLtZw+0pYx
	tu+owrmU+HgPpXMRtJ5rNAQwDQS3ENk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nN+bXffD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3CAE62478;
	Tue, 24 Nov 2026 22:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7E11F000E6;
	Tue, 24 Nov 2026 22:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561189;
	bh=zmxU8jlcQAoOmz9SVXAVr4svm8Xhliz6+CM8YIPXeGA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nN+bXffDCKcamcRSHOh5LpKsvzSpQ4Oz6YaZpVhZycBqOy4qNra1dIBQPQVbRwKse
	 gyrbI74wweoIfmrfNK8rnMlkMEfh8lf22IdjZwG41fENFIJiGE0/NmlfZ0Q02U1eaS
	 G2/wrQNK232sNjP0Efb3USghHe7mRkOAlVzuvorzInur9xifSP3mrUTUAH6pjk8Sci
	 l0g+ssPoT6SVPzdqWZu00+5IDx7U0H3GOa+aQY/QCTbI8Xox1hOxxpD6YgmVMS44dA
	 bXG0qdWyrE301cHq8lu657MvuUMAGKO9+EAhtOhmZIpmEJ5a5sVegWi7/mcwa2PnJ7
	 D0dqKukkyizSQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:28 +0100
Subject: [PATCH RFC 05/19] selinux: close inherited files that can't be
 replaced
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-5-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=1883; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TCu0Afse6zxwaqsM5MKt1enhe1sRx5apMR0b/GxRpJo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzie02NNi+8c483o4E8+/B6jW3rr7Trn3++k+o6Eeju
 nal15laHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABP5kcvwh59P//HztS8EZL3+
 G55I/Wl6JehfoE2aCLcsy5rbUk/YjRh+MQend/Fkpq3bFT2vPFTqyqk45/D5E4PvFHVs9tt1e3s
 xMwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: zipnu88pknmf55ut3ee8bfkgmrnzwzsj
X-Rspamd-Queue-Id: 040311C0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795561189-567579
X-HE-Meta: U2FsdGVkX1941RPDlujbBfn+aIyPmQ7Z3vvtcrdoFxaIIEig33tQ9BVV35uAHxnwhAHTXL7H/V7P6x/8kqELkE5qVElP7+RDWKsSPAyi+CusrQvdB+j459C7hOp2GEpJJbfPrHYyPuENwTQ0tQqlSMmV9kH7m0vIuSd2A5r0UbEcW5FH10BzZ5omXj1wTxCRr+QgTQbhsZYClY8rffYJLfgRpy/SNPO0f3eOHAjLjbhjNV5TGCd+GpdpgzP4YKGrGeHv8HgGFDV4JRX+FujyQudJskz7xUid6PAD02csxtfxfSfQOCZWQxxxOv9KV0uNtsP2mTZxppb/2xlv1XxyQXHxYLdn7UbhdyV9dm6BhQ3pefj/ttyczbS/KpCcfVd1zxniBoRxkb6KQgVHu7BMHkOOelEcgx2G6To4+p9I8sUyi5J9+trF/DPH0mJKovelbYta07S3W0qLkOPMY3camNG9EqI4oIDd1v1U5GWhKcmPzo8sDfEjLBOjvq9kEZuJ9r6Ht6Z/+kJfg0/0cC8FZUfV8YGf46cGL45xsgBSgUf5+v1p3e19j7v7NeaJ5Ar2S9vU+edyw01tVKeEwZc1TK8kQiZadfM2royoZLJLGYr5laPB9PuuZFQUgMilHMVR3ohHxvu7i9rm8oohKJmu4meuVEjhXUQ8MYaP+NG3kjW7A2332QLSOcCRs8oMjpO7uwrTnwePaLiq1MmJaCnQduvSII2Xuvy3vumGglDI1G9tJtucGENJAjglUhBumdUWmm6LVBF+HCdJnxsM5Ov0xOXlyeQ7QyJcA/zYya2XRm109BUN0doBq356MuEc9F3NjYloGyR7gLSVPVMkANO4l8bBv3o6XmT9TQPVRZgsknDN+7z9eU1KRHFTlTOj8o0keVhdBS49L8OGDKsCO73ISC3ukKADQCvrTE8Hrd5uwOCDK6c2sL17Kk2m4SFInmJlu0p2HUJFQ5DGlJZ0LfP
 aJqUCa8B
 +2rQy0+wz5WOv2S0MHUkQGQhHP3uqcukE1Nycn+HZ2uI14nWj34CMMXQdMLg9M6ZmudzEe3BGOoo1KWuQwUIYJq04S2Ugj//FWDTI6WHUv/oq2TvXgwaQdVzo0ETHsA0TV+bzrTrYPH2nNfXskO7YeXKnZBkRCjtdMSVL0qsmebXHNMa3Z2frZYm5H7P7LLNDevGW1JSDo3eSnrBWngwfBhifYld+iDbIUCZrPe/mpyfiZG0Uw5VIlZdSW4wxlfeUMYRwI4tNTBn6b0Ku8vquGEXrk+FDSDH/WOFvUIOGcQe1C6yyuRrLExz8TFpbkX+8bzH0YcrfQ+WPxdVxYrJ6WDOGn9TbY0nqloJgsovYUFSeMBZoVbZBAou1iu5l4skxxysCw+rjz8uy09gAk1wHt1OiRYr51bov5QPqSWJUVkDiC0EFszGxCv25Dhk827yafyj4l5QY424CppkqRHxDnZ4XLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an exec transitions to a new SID flush_unauthorized_files()
replaces the inherited files the new SID isn't allowed to use with the
null device. It uses replace_fd() for that and ignores the return value.

replace_fd() refuses a file descriptor at or above RLIMIT_NOFILE. And a
task can lower its own soft limit as it likes. So a task that sets
RLIMIT_NOFILE to the number of a file descriptor right before the exec
keeps that file open in the new image:

	fd = open(path, O_RDONLY);	/* 3 */
	getrlimit(RLIMIT_NOFILE, &rl);
	rl.rlim_cur = fd;
	setrlimit(RLIMIT_NOFILE, &rl);
	execve(...);

The new SID still can't read from the file as that is checked again on
every use. But it holds on to the file and what isn't checked on use
like lseek() works.

Before commit ee97cd872d08 ("switch flush_unauthorized_files() to
replace_fd()") the file was closed first and stayed closed if its file
descriptor couldn't be allocated again. So close the file if it can't be
replaced.

Fixes: ee97cd872d08 ("switch flush_unauthorized_files() to replace_fd()")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/selinux/hooks.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9950f89dfaa23..4ec9ec723cacc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2521,7 +2521,9 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 		devnull = NULL;
 	/* replace all the matching ones with this */
 	do {
-		replace_fd(n - 1, devnull, 0);
+		/* replace_fd() fails for an fd at or above RLIMIT_NOFILE. */
+		if (replace_fd(n - 1, devnull, 0) < 0)
+			close_fd(n - 1);
 	} while ((n = iterate_fd(files, n, match_file, cred)) != 0);
 	if (devnull)
 		fput(devnull);

-- 
2.53.0


