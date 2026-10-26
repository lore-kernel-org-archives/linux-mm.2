Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B70D606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NxkksvOg
Received: by kanga.kvack.org (Postfix)
	id 8707D6B05B4; Mon, 26 Oct 2026 16:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818E96B05B3; Mon, 26 Oct 2026 16:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD7E6B05B3; Mon, 26 Oct 2026 16:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C99E6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:54:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A78AB80878
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:09 +0000 (UTC)
X-FDA: 85365979818.23.A045C53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DBC42100008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:54:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxkksvOg;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIm3ZS5KbjzsYJ0WSulRKaxitX/G7rtbCDL/MIRA6Dk=;
	b=sugTv43zQMM57Xdx13FLgN4ukPsf/Klu4LQ4KcTtRCFB57M9VB+oKm3znZzJljJCac+PU1
	k79SRes0EEANDaBJ7fT5KkuuOIObBdPtVV39MVNPMjNdBb8eu7UL8wNpunl0wGpShrJbq0
	K3a1UGGpeImtPKXw0kil4KOQdE8uAUk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxkksvOg;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048047;
	b=arUvNgeieCF6GZ47GxOigN6JwdtbZ/XCX6hEIKWvhPOureolpVrEH5fC9PCj5hZxvmcDDy
	avmHvGkqo31sa00ccH62awgxWQbHJdpQcTx13T//hcqZKczPxho8x+LH573gg8CPQFsRRg
	4HUIOiIZi7lOKgMgLNKmueaDV7JUUsk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 433C6601F0;
	Mon, 26 Oct 2026 20:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4966D1F01828;
	Mon, 26 Oct 2026 20:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048047;
	bh=NIm3ZS5KbjzsYJ0WSulRKaxitX/G7rtbCDL/MIRA6Dk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NxkksvOgoUJHDLEYuqZxoDN5w6CVnX11WAHXavjWLJdqMAD7f4eIg6lK7/L6FE42Y
	 mDawIcxsUDXZB96MfiHTVnvxKvW84UxjxKGbhI5jX08pPzNU4+wCJj96guJTzgbhdP
	 ySjO1NE7g4mrWrlDutJuY01uq16Eq0ZXqYGGXp3d3QNxRqtAB8pRMrRKWw8sYSfw1J
	 huEYOB8iz4jSxyI6UgiF1MoW/dw8NSvpcS8jQRYvh4RfJ3ZsxSYxWxV6OFflFgC5Xs
	 cJ/ZxtgWZnDoh1Gtp4Nzd5n3XbpZ8hNW/VPjKJTfL+RUbArRbUnkTGUHJNmzcgHZO1
	 c0M9B2lg17dUg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 26 Oct 2026 21:53:29 +0100
Subject: [PATCH 1/2] userns: don't drop the exec securebits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-work-securebits-userns-v1-1-b35473fa1a34@kernel.org>
References: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
In-Reply-To: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
 Serge Hallyn <serge@hallyn.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Jann Horn <jannh@google.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4204; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yXUxhGjrM0vd95PWJeUZxGZvenzi/6XOwtjTBjMe3FE=;
 b=kA0DAAoWkcYbwGV43KIByyZiAGrfveijG/63VwF2dnEFNKUYyMAEz4cxYRc2NV6OHRsTnZeRt
 Yh0BAAWCgAdFiEEQIc0Vx6nDHizMmkokcYbwGV43KIFAmrfvegACgkQkcYbwGV43KIu2AD4nj3u
 VIkyHvgxybscgEGv//3yG9Ldw5lqqzgdkEbALwD/cz6zk+fUQ9NjW+dckrZYKWtR+NuGsOsh9XU
 g0aP6zQg=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBC42100008
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d7rui1ngcc7s8af14bw8hdd9zxfjj7of
X-HE-Tag: 1793048047-465196
X-HE-Meta: U2FsdGVkX1+EMIr1xY9g/yVgK9rvM+oJjgdfb639VOT3AAIrKyQoooGXY3WLp8pRH2d91fqd8iRZb8PusJbrF+/vzhzsjsIa6z3xxs4PenWlnonSI8QZDf2DzO+htBZKFCCZWGOJ5tQlntTTDTkH8R+rLIbeq9bPpzUGy2JDDt0s1/r11bQJ6oNLsHPTpQ8fRy21oSH2xa5CdPzKk9CThgIVOr5ztQpwT88Jo6A4mh8AYMDbJqOXdyIowguWHZdG6ky7QVLbntOkXmq4k0Sf9u/5CR8Tu0oJDGZ1kdV9EQQxp3PBlWrFQEfrOqdvfRWrGLj4eYH84wci0GJLaftScVGQT2p6buKNSrXEExZrHOxwftdHGe49AkkDolfoR6XCSPyIz3wVR0GWjx2itXZ74lW1GXsMu+g4eum3katZmxQaryHK+CxueyGXl2eekRib7g9sZXZyRDD1bttv2dfjAOVXq6xmgVxjaT+GHnZ1qqIWi7pvBOhcsLjCf0gSu9yBSoK5Z/Pr2RRkdNQvGMvjmaQmJsqAmUy6tCOwU2MUc8+OcoDUCN6qGWChQfwTMhdadB5lxkdkpRni3kjQ8pJt5dlSAd6YyWpKEKYFCHYI86IJXOelsfrt/MEauB1EHrin1d2tY1cqPwXHyifC2p/sd7/Xn2bIE92fFfWCD4qWX4ksU3snVaWvYHxvmuUdr5Ac39Tyv9nsapOd9aSdviYR3v9rlk2B69gU8x8SiBWiZlu+En7sYCqRhKoEALiHsEued4qFVMMVV5HfKMuvDHc6uGJW/isywMXK+jnypqD7RCNuoKTVzOYxsiQAZOXNMUoCACLY/nXk4WgEfAWxGH3k2iDH2TaBxOkS3Yi97mjKlk44IuagpRIyn4+WG9OxhluiuywtDFp1gB67EGbOJ9le3m0DyekdC9vuOFfBEHl17SLmJeylu68AFiFxHeGFnzcX0ALiG6kMHFZzUORrcZ1
 1jjBEABH
 OTxU20LFIbGLzGoFv3/1oL8cwHIxktE7eT0vmGnQRe+VHSVZ8xmNdXfroK9I3pEtHD5SLQ9A3W2MdpUdZ1Pd5Q73y6S3xNWiDD80jA2b9YC1qIUxkfX5fekAq3V/emDOuOhgNeVEEXAhYtHtZdwElsyfyQr8t9xK5EanoFcFfTDEmqjjLnY3Ix1lWtov/BEyETq3DPqXSSg5LJF+Dmkml3ngIJFxxqKxgZInJ58Da+ZmOtbgHiBQvQ0mzuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE tell script
interpreters to only run what AT_EXECVE_CHECK allows and to refuse
interactive input. A service manager sets them together with their lock
bits so that nothing below it can turn them off again.

But set_cred_user_ns() resets all securebits to SECUREBITS_DEFAULT. So
any task that can create a user namespace sheds the locked exec bits
with a single unshare(CLONE_NEWUSER) and joining one with setns() does
the same. The lock is pointless if anyone who may create a user
namespace can drop it, and that is pretty much everyone.

Resetting the other bits is fine. They are about how capabilities are
computed and a new user namespace starts out with a full set of
capabilities anyway. The exec bits grant nothing though. They are
restrictions a task placed on itself, just like no_new_privs which a
user namespace doesn't touch either. So keep them and their locks.

Reproducer:

  // SPDX-License-Identifier: GPL-2.0
  /* Lock the exec securebits, then create a user namespace and look at them again. */
  #define _GNU_SOURCE
  #include <sched.h>
  #include <stdio.h>
  #include <sys/prctl.h>

  #define SECBIT_EXEC_RESTRICT_FILE		(1 << 8)
  #define SECBIT_EXEC_RESTRICT_FILE_LOCKED	(1 << 9)
  #define SECBIT_EXEC_DENY_INTERACTIVE		(1 << 10)
  #define SECBIT_EXEC_DENY_INTERACTIVE_LOCKED	(1 << 11)

  int main(void)
  {
  	int bits = SECBIT_EXEC_RESTRICT_FILE | SECBIT_EXEC_RESTRICT_FILE_LOCKED |
  		   SECBIT_EXEC_DENY_INTERACTIVE | SECBIT_EXEC_DENY_INTERACTIVE_LOCKED;

  	if (prctl(PR_SET_SECUREBITS, bits, 0, 0, 0)) {
  		perror("PR_SET_SECUREBITS");
  		return 1;
  	}
  	printf("before: 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
  	printf("clear locked bits: %s\n", prctl(PR_SET_SECUREBITS, 0, 0, 0, 0) ? "refused" : "ALLOWED");

  	if (unshare(CLONE_NEWUSER)) {
  		perror("unshare(CLONE_NEWUSER)");
  		return 1;
  	}
  	printf("after unshare(CLONE_NEWUSER): 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
  	return 0;
  }

On v7.1 this prints "before: 0xf00", "clear locked bits: refused" and
"after unshare(CLONE_NEWUSER): 0x0". With this patch the last line
reads 0xf00 as well.

Fixes: a0623b2a1d59 ("security: Add EXEC_RESTRICT_FILE and EXEC_DENY_INTERACTIVE securebits")
Cc: stable@vger.kernel.org # v6.14+
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/userspace-api/check_exec.rst | 4 ++++
 kernel/user_namespace.c                    | 5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation/userspace-api/check_exec.rst
index 05dfe3b56f71..0904810e1d8d 100644
--- a/Documentation/userspace-api/check_exec.rst
+++ b/Documentation/userspace-api/check_exec.rst
@@ -99,6 +99,10 @@ This secure bit may be set by user session managers, service managers,
 container runtimes, sandboxer tools...  Except for test environments, the
 related ``SECBIT_EXEC_DENY_INTERACTIVE_LOCKED`` bit should also be set.
 
+Both secure bits and their locks are inherited across :manpage:`fork(2)` and
+:manpage:`execve(2)`, and they are kept when a task creates or joins a user
+namespace.
+
 Here is the expected behavior for a script interpreter according to combination
 of any exec securebits:
 
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 50c374ed4687..cd748e1cbace 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -46,8 +46,11 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
 {
 	/* Start with the same capabilities as init but useless for doing
 	 * anything as the capabilities are bound to the new user namespace.
+	 * The exec securebits grant nothing, they are restrictions the task
+	 * placed on itself. Keep them and their locks.
 	 */
-	cred->securebits = SECUREBITS_DEFAULT;
+	cred->securebits = SECUREBITS_DEFAULT |
+		(cred->securebits & (SECURE_ALL_UNPRIVILEGED | SECURE_ALL_UNPRIVILEGED << 1));
 	cred->cap_inheritable = CAP_EMPTY_SET;
 	cred->cap_permitted = CAP_FULL_SET;
 	cred->cap_effective = CAP_FULL_SET;

-- 
2.53.0


