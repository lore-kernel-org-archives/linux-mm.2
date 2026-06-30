Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E98FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6004D6B00A7; Tue, 30 Jun 2026 06:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0CB6B00A8; Tue, 30 Jun 2026 06:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F5A6B00A9; Tue, 30 Jun 2026 06:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2579F6B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:15:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E77D120440
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:15:32 +0000 (UTC)
X-FDA: 84936172104.05.B3CBAC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id EFF9440002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:15:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/XVErlH";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782814531;
	b=6tID+9IFRBWJGmNy269j+L4BboIlyqpRQAwsWTOyzF0yACtENlWMZEGR4wCbyk9q+Ei8lQ
	adETb0AW6PQLHElTV6hpr8LdAHoO+zSET5jSM0heBMXFVkNUJ1R6X1sH5eCVdfVOTto7rB
	9KtZ5gY4ny2IKdDcqVLdbJOgsQcmCsg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782814531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lI3NPkDDbaOtWN0AagWeM0hopceUDy8AbC/aW08cank=;
	b=6tiN34k+VF0ewDnWOWby4DwAoSBOhlMu/g5JldMmaMQWdG8+9pE0iTs314dXUDls5u2WGb
	/NNPBJ7nYWxS9jwu/YnXzmKT6EXeEOJulRwu6gGx1V0AnudARX/zmZURdYrSzAy/XrTesX
	GvQcVbnwiCPJbpGILNbbnhK+rr/edFI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="l/XVErlH";
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F04560008;
	Tue, 30 Jun 2026 10:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3631F000E9;
	Tue, 30 Jun 2026 10:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782814530;
	bh=lI3NPkDDbaOtWN0AagWeM0hopceUDy8AbC/aW08cank=;
	h=From:Date:Subject:To:Cc;
	b=l/XVErlH88YHdtfHcc78riCZQuDZj2CApRlflyee2XodqHkXoiIDMdoQUkS1S5eGl
	 uyj36gRnqTtrjcrTP4N8lCyFa85YB8QuzW8p5/Rj4CK9W0huMjYOUm9Gri25tzTGh1
	 dZjTDb3Ou/C0xjPDleCfCOu1p2H/0qkUhfA1xrf2ywR1qYHlpo2U24iH3FhfpOOTlF
	 HNxjgrrrJYiiJE/+TfPzUwrmP3FEEnsb9SHe+0oaeHcXN93RxE5TAJh6i87/LT4LuO
	 6sTmXS3Tk9pLS0q8oCzxkUZDSzJRHkPD9ppMUds33nUS27ofwQauVj9d1kNZ3eZbnD
	 JkpwyjiADTnLg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:15:24 +0300
Subject: [PATCH v2] selinux: hooks: use kmalloc() to allocate path buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-security-v2-1-560d33c13ee6@kernel.org>
X-B4-Tracking: v=1; b=H4sIADuXQ2oC/22OTQ6CMBCFr0JmbU1bI6Ir72FYtJ0RqqaYGSASw
 t2luHX5vby/GYQ4ksClmIFpjBK7tILdFRBalxpSEVcGq22pj1YroTBw7CdVBsRSozsZe4bV/ma
 6x89Wdat/LIN/UOhzPju8E1KeXQptljJmuY3SdzxtF0aT43/WRqO0qg7GY0XWIOrrkzjRa99xA
 /WyLF/3zrrWygAAAA==
X-Change-ID: 20260520-security-6cdd60da7129
To: Paul Moore <paul@paul-moore.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
 Mike Rapoport <rppt@kernel.org>, Ondrej Mosnacek <omosnace@redhat.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, selinux@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: 7h4n643wu6podh1kg9zoum19gs1z4mi6
X-Rspam-User: 
X-Rspamd-Queue-Id: EFF9440002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782814530-981011
X-HE-Meta: U2FsdGVkX1+0oxOJf5MIkmzuZv+RyiVsbTItHfFoWiCkDQSE5ZKyjs2TeKUbTRztUXNZ2MJ6kVudu+3M5oM1AQ1l8+A5H8XhvM2eAcO8o3p3+Cv9NZ4B/S3XJWesFrFQ95/MnCLgDm06IAch2wWSskHAcYEps5zgHdMwY2Wwg4zcUraiFYin+NDcIAXRIJHiJIgDbjhBy8RbJ0DFPyHtYSua/WyxqAA/A1gGm/iu0YR1Q9ECRmKzmhFq9GXTh26cBh02W2IT11yBLz6z3xJLdRTku6zR4ivTQEHTqKbYXCMZaa0DbuYy+yJonI7pgv3jnMmLXQ/k4NtLmrryYNSm5bzVuWqz9zOl02/HJhJxGJiFoyxErBlFA/F61Fc0oQyeq2cF2jnj2wGXjaPbHAuVJwrhaQx1Rpg3vUhKHD3RZIGgKk+QQvv0EyO4JlHTnSBr/9w+fhZBRUevDseQw4/vNNAnsaDXsJpZmbmUVLNNtOT8Ogq08LVfSZCaTUQckRTKpkSjl/FXPdBhfOEcmEh3T0S8r4i9aex5miPFPsJffzhzj9EaIDz89wQuYfMt9ASiYlvrXpqaM5C1EXyGMp8fWmQiztAQSyS4X/hD7uRm/FPQnk0YLUebcNE1WEyhbWhYFe7UzfIIMvAoS6jNWfA9Vou0qGfuW8ufCwCHIA4VcZtXX+gfUKUoHxCsJf2I/q3BUkKxQEIZ9dqxe7/sQllWsYzXzLaoAVz/BSloPGPk/tMWEqe6iVCFvNs0uLpXb99Vitnz+UE4acwR9H7jOo5l4xa6rbwIDgBY52J4WtP7z26Wqcp3CSIUBwq7NQOnn5i6izmXbeLn/JWcI/NRh/lF6bMLbZ7pslx4QqUl2i/J/x9TZEMpVDotzYQMEiGkhKzwgHiORWG3L+zqA3NV6KW2aKRjuewaFV+ZzIjldWQWTR+i3QR4Abka6zjmXLkOGCLq937WzYtaW0g4YrXWjPk
 +UTwTSwc
 RvGWXCYno786sPI8pNNpT+fSflil5xW1fc/9/cURogFU0L26arKV1HGyt0C9QEjB45EN3gMHoFgiu01W+1t5SZp/O2+BqKIm/i7veMNsQ6ac8reqFEhErbSv7W6SlsbGCRfCN1N1vuNZ4Rzt283Fyb/NK2Ryo7SG6suGTmHeaJTChePz7BafUed/mQj8+YtybqNEXC9Sw5wTrcC0UYGAT3dLqz0888SpfbG7d3n/YecLfPJfGmOrzCMU3Y3jk/Au2ubFdhNMs6sL2Jf3s6sVeuCGetTsSPl8qchpB1iRHAqECZ1Xcw+D6wUeC8VRV2lwH3a5DNKx2WoZpgwqwnMfqXLMbAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

selinux_genfs_get_sid() allocates memory for a path with __get_free_page().

Such usage does not require a "page" and the size of the buffer should
actually be PATH_MAX which may be less than PAGE_SIZE on some
architectures.

Replace __get_free_page() for allocation of a path buffer with kmalloc()
and make it explicit that the buffer size is PATH_MAX.

Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/security
---
v4 changes:
* rebase on v7.2-rc1

v3: https://lore.kernel.org/all/20260531165852.1478916-1-rppt@kernel.org
* get the args in the right order

v2: https://lore.kernel.org/all/20260531151502.1467515-1-rppt@kernel.org
* explicitly use kmalloc() with PATH_MAX
---
 security/selinux/hooks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1a713d96206f..d1f089917a82 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1336,11 +1336,11 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 	struct super_block *sb = dentry->d_sb;
 	char *buffer, *path;
 
-	buffer = (char *)__get_free_page(GFP_KERNEL);
+	buffer = kmalloc(PATH_MAX, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-	path = dentry_path_raw(dentry, buffer, PAGE_SIZE);
+	path = dentry_path_raw(dentry, buffer, PATH_MAX);
 	if (IS_ERR(path))
 		rc = PTR_ERR(path);
 	else {
@@ -1361,7 +1361,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
 			rc = 0;
 		}
 	}
-	free_page((unsigned long)buffer);
+	kfree(buffer);
 	return rc;
 }
 

---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260520-security-6cdd60da7129

Best regards,
--  
Sincerely yours,
Mike.


