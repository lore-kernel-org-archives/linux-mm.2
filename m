Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99110CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5AB6B0095; Wed, 20 May 2026 04:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55CC6B0096; Wed, 20 May 2026 04:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D936B6B0098; Wed, 20 May 2026 04:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8AE06B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:19:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B9581A01F2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:17 +0000 (UTC)
X-FDA: 84787098354.18.D9315E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9E73140009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqb6SkS5;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tJOszf5ccvQ8Uj34Ns+l0JyEoj1luDQ1JSgscLEUjH8=;
	b=ZdfESmSd0+ck9CJCndAYTwcha3dGPBx1Zm30OC2FghsHhnM+0IZGXtvsLFMGOWxgeavkIo
	KBhgUcoLzQqn8pKdMTjcit0Nn8TePcZwTc2ExpDpEME63X+csCviQZjDbLmfAgjdtmsUjR
	8rYp0WV+nVo39fkC8gvM+kkh7XqAJ0A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqb6SkS5;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265155; a=rsa-sha256;
	cv=none;
	b=ie1bKc+SADWwaPdRlX571zUV7A8Wbj+ReHc1tgYOlJp5YO/DLVaC8WBFqFjFYd/AVuN6IU
	F6UK/C+r9FxDZC9XUu7N996tX605pMzIKTTRhCtL681r9uyln2tA0SZ/vDbZdspdVCCzk1
	4gBRLBpuv50H6ngeq7D59r98UaFhjkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F015643BF8;
	Wed, 20 May 2026 08:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3794C1F000E9;
	Wed, 20 May 2026 08:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265154;
	bh=tJOszf5ccvQ8Uj34Ns+l0JyEoj1luDQ1JSgscLEUjH8=;
	h=From:Subject:Date:To:Cc;
	b=oqb6SkS5YytIpVTUQsjo2xHQ4SS571cAqH37sjtk3n5/2i0pUW5fADVVxvUdkIAgo
	 Ei/YzX4Stje++RmND/Sxw+GgF8GkC2YAKmsKtBKgIidtQ3Lnh/GOV8qbAUxWGtMSXM
	 lArDAXrc0inMaKNgo1ea/d6dZqCLBG03ZFePlkMmRKxUhrbFQqPPJeix9ku4CUhHB0
	 Sb1SCaw6Q9oKG7uzDNy2Bu9C/uFTiFz7SA1od/3QLL1sWK+kuQhsseNWJtZvEY8AeV
	 VAb9otpjpJ9Mf2ht2E7QfZB0sMJDWaA2FxwHg9a7aiS1369hhwS97doRMt9y3pWb2V
	 arJKoZ/lAdSrA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/3] security: replace __get_free_pages() call with
 kmalloc()
Date: Wed, 20 May 2026 11:18:54 +0300
Message-Id: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG5uDWoC/yWM0QrCMAxFf2Xk2WJXtKK/Into0ugiUiXZRBn7d
 1t9PJdz7gLGKmxw6hZQfonJo1ToNx3QmMqVneTKEHyIfh+8M6ZZZfq4SDlHn9OhD0eo+lP5Iu/
 f1Xn4s814Y5pa3wxMxg41FRrbhLvtXRDW9QtMxMJyhQAAAA==
X-Change-ID: 20260520-security-6cdd60da7129
To: James Morris <jmorris@namei.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, Paul Moore <paul@paul-moore.com>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, 
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=818; i=rppt@kernel.org;
 h=from:subject:message-id; bh=8sDsVcUg45SCDAbOd4Qy+nlWe7vZVoKzJPYWNem4zG4=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW5yZa7B7j3ohKSc2JgmRG/bo7d/2fltrRWB+
 SeIMUzfGumJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1ucgAKCRA5A4Ymyw79
 kfc/B/4uBqwgyaoh4EWczWSCvk4YvrDw+P5GIcZkmNuCZQCZgn2Hx05kpDcm+rYUwU39QhN7JvA
 tgMGPGR88/BwX8R27raP67u6j1ETp4W+lZ1idGU+icFaOpOgkAUJhNMnoaD/AYaSMcNJIZk5CIr
 dg5H160CUyvtcCaHO7sCSGKOxTBqqG1Qb8w0Dw+ZWEDuplwxznqiP/VegbHSKV8nw60H6hitxX/
 +WYSMij90yhsivt8xYrlLro5YpMLv+Emy4CxwBnYAAtGzmsSjY2kRashqG5odUQ+sRifrYPPbgs
 qiubvcrUP21lk5w02frOGk4LnKpN/uDysCVOPUN4MSQ1pdt1
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Stat-Signature: i7d48c8dahx7kemtxqhom3hyw6rz13px
X-Rspamd-Queue-Id: D9E73140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779265155-420621
X-HE-Meta: U2FsdGVkX1+9cORplei/+SH0ay+ctmCoEIyHDh2DgJX19RVhl/NNS0wXbuTOK6hKXCX/JkWw8gffeDorX4BLyDeVxZ6Dk+itl4riTqDtJvqk3dpKmEXIss8AijeAKB+WPJn8vC8khdlPI+1VyP5ZjYPdc9s7taJkdOXnLn/Z4iFTS+JbEL8hDJ1x2iXJh5Aor9yylfETCBxL7LX4xhVCmVW+FfEa0Di/PL+1tdMuvReH5eEa0DWZRpeKf+NqFxDBeRTTvY9wdvzBmz70BmlLv1nPd0i66y/GaDcrXR2vihJ7SuOlgwMXZosrPIXkvCqSOz9Oa01V5qHARXanvKyUolvbgkE4HnuB0c/AFWXScf2kjKhirdsrwvD7VV+q1yzCQhBxcA6DFaXzHbhYxRLekrVJ7aEpGK+arCFMiEQFHPm9k2GzZod+PDwFzHk2TG1bitnO0QkZ9Z+m5TFgij0T5C3imY52CT1Pm2FSPrac3ugSs3G3tHFdwWTG6e1kQfGOLY3RvyFBETpcC8wvpjvt2yA64s6DWDdaVsWedXROqU4Jz1JzQGroJvtNdCkZZLQUff2X4ErvHhQ22vNSrHwXv716kKuqA5XHb7MI1WrQh0aVWG9y4x3VucvwQD1xR09tBby5/UWNXLCc+GrEOqade3G8YLQ6VKh48FOFJD7v+hisJSQqENZ874Oa1ybV4eQODc5a++613pBGVwoKP1jbUFMnSIkaO9EaMgkoFcXDEXB9V+PevO9mQjqDXmtQZe38LKwNC0Pl0IrQ2F8jjwZWU2qhzZmeMx5142mhTfO65iqYe8o2goN78aLw7BRUXWJOp+d8Y5b9aSt76M8hyi/xTE4ZlDL3vVAPjovWQZzXwqIBsRZV6lifNVtW7a51C8sdQ5zlp8YrIHWkxBgyGN1VkgwiTDmRDcbtFKA8Fs0hsZNFS3Q59/cPiRzpaoqTx9rfz+UIrm7zDvQS6CaduOB
 S6MYvTLS
 pyRjFcrut4YBv+1kv3U9LT0yNlboJ2w57Fb8Qno9+70UFTzQXJBj8txdHz2oEg+vMwisqcnvZxOvw4q94pxiFORwMxadvxBoRzPSwMNMOzybWGz1NsB8rD9t2VG7GKvN7xiYmduDGePwL4QzdBGJWG5uvQhA3r2gxWeH13XcAIjYcTIIf5SvfyerpIYb/Vw1XoXD20r4FEk43+5H0vYOJBqUrRbOTbxXlYzJ3nnErCgPVz6teFK147qwaPI+mgYrRfyrGTidz6WnAlxg7t6umVPb+FYENfBQ/XayalkuoPOPEMdKwFBFFnlJ2+FTB+jJJR0wItgUuk89H/UV3fCmYhHchWdwgegKgEIlY1/Xwrl4mPCVCmTTIcHEtSJZhWMTmZxAO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/security

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (3):
      selinux: use k[mz]alloc() to allocate temporary buffers
      selinux: hooks: use __getname() to allocate path buffer
      apparmor: replace get_zeroed_page() with kzalloc()

 security/apparmor/apparmorfs.c |  5 +++--
 security/selinux/hooks.c       |  4 ++--
 security/selinux/selinuxfs.c   | 12 ++++++------
 3 files changed, 11 insertions(+), 10 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-security-6cdd60da7129

Best regards,
--  
Sincerely yours,
Mike.


