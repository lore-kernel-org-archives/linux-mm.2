Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D8DE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 23:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9D8A6B008A; Sun, 21 Dec 2025 18:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AE86B0095; Sun, 21 Dec 2025 18:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FFED6B0096; Sun, 21 Dec 2025 18:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA546B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 18:29:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D8171A0954
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:50 +0000 (UTC)
X-FDA: 84245072940.11.5D4C251
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id BEC201C0003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 23:29:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=PgvMIKuY;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766359788; a=rsa-sha256;
	cv=none;
	b=rdL0b9Tv8Aos5FvevxvCE+GiRKInnKmmodlifNW4clm3R78fzgSSoDSYweNXdVartfWVAE
	YrTs6w15k1ncfdS5cPmu3Q8jYnv2IBrRcDGpbdk1JHJATguXVc/Ij7T7jbYJ1RZBAISwdB
	dl4D0gP8012RtO2mENGh99AUZFNksf8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=PgvMIKuY;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766359788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MzIdp3++EW9jR4viQGn26PxJ/MrNC9X0AWB2R5jbVg=;
	b=3y0dDNJZOeiqTrQAQ44Qou0tOk81Lq0bBogrzNETXP/jOY5B+tM1yMOVw8M4h+oFa6qYnR
	GGKaeBEza7SRqb0cKfC416kk4lp+uO2fO7fVVk8OihY2gZlITQZ4ZptOLfWUoPJBu1cRcc
	2V0X3t04NdhVafh0vxjOAiI1SERGUOE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766359786;
	bh=1MzIdp3++EW9jR4viQGn26PxJ/MrNC9X0AWB2R5jbVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgvMIKuYdwYykqjiye99wCEJvGuExeaBUNDMjDguc7hFesZEMFSdm/2nW/1SSChe9
	 5Z0i342gnbxzO16o5nyWloqRENbS7jfJHEwdlgrSDwoFr0d2+QsnyHMAuyOAlIVeJA
	 ROintfIlZR7cXHH9Za4jX7CklcshWfGwMBQaftb35GItWNVX/Du0sgbktalF5yc1UV
	 6X6WJu8UdmobHf62Yx4cPbBZtN6hQN6PUkgaZZHj1AtsleHeLj5atxEG9RJiML6BPp
	 X3wm9zUK9kRTDTNiWGr7bQILaBg6IBHRL8Wls0hLCFV8FqVPrazBcNIJ7bjdaha2qd
	 gdI8ZqE/DqG7A==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:6450:b8a1:16cf:5ecf])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dZHYQ43gczcBx;
	Sun, 21 Dec 2025 18:29:46 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Brown <broonie@kernel.org>,
	linux-mm@kvack.org
Subject: [PATCH v1 5/5] tsacct: Skip all kernel threads
Date: Sun, 21 Dec 2025 18:29:26 -0500
Message-Id: <20251221232926.450602-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
References: <20251221232926.450602-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BEC201C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: sw63erso9d5qww96p45rgcbzsehxe3hr
X-HE-Tag: 1766359788-775840
X-HE-Meta: U2FsdGVkX1943CfzIBfPzkgqqut75kq+mITVHxxYsp37sQMhK9ONhf/AVWbyN3iujCiDLkoy4fu/NvC8DslIxSbPNVfp5ClcMMaNZLEJ/iJeBDPaWu0rqNND56RQxxPgY0iWk+cKeqUUcJvW08CsfxwVSE3ACTW3o75x1ckI8kXfRje4xOsBK4P0FPDPTslcToKIiYZqXhAl1xas6UQwzd6MFvx+qa/2nMc2u7owCcpvTUYHvyBMuVN3rEXRhHB1MsgTe0BhWnTA9O2znpQe/gsljt86tvQbfIThto3YIoxTkZHYyb5c8PM/wMXe9P++W2neFxcxxnBLrysIJo4OAEwES8NdwdEiAr8ULcjwfFFLIyLerJHLd87nrktzXt8RfryuwxHaTZcOSoR6o3o5ky4lcC6p7zADPZ0ekC12eydlB/x2qbO76J3CRBaOR5IgGh9asH/71OatPcD+5G39SlMI7v7waSye/6xWIm8iW9KbXftWxa57RsIUnWXilfRyrUJAVb3CecBUhFhJs4ZOhjSmxkvu5Oh2v6SZTeSkUlawrwvthjWipXFmnQnx4DTTDBI4tMy1VHf9a2Y6QYvuZ8r0ohi2ft5t4seeXzAEPZPuynXooaDCJXmd/EVQaU4W7DF/kQSttGzzUqMsYfJk+aK5eC/z8IruJvq6OpPF3DN6hXWhqliFWSUtC9rtz5kr039ouA10/btZrwKxIW5zyX0MKW6c9OJIuRlCBYK/kYrzlbFin920lWdVCui2jxjCST+7YXEg4B+BUdYdxXZusrVmjwuUD5ihW11YG7efQPy2Z+RpDrdkzRQfS1loAR7aQEgxbrRcIlflpJq+P4CpDv4YY2nRVSTraizwRXRQSazBo5CUc/TsiG+gEb61o6CjK0ulHseLnW4Nm33oYrRFkVcQ4ucuqYDrS7BCTNN9bBZVcgsSmgrKxDpAKz7jBO0OBrcYnsfEC24pOA2ZY1R
 jLwE7XMb
 YelQcqPeU14E9+IPjK5p/SJQIkWmQ++y/9kbvrHH9JUMRHB45aA507A6zBTzU9fACt3q91O0KI2OLkBAV599Nwcz9xCmFsV0UiGktfqyCbFwpRzKDwbsBiQgrSl/8saC+tIm/0lAoGyVhFaqBQ9PU88VBKRYVJnWlZusThH2luHVk/IOcAYIcVVOv6ot2ZH5vpykzYx6vM6ZeIv2rkT55gD8Qw7ctnW1vbJRq6J69nJUgF/qIhvguqbNUQVN14Kc4PioQX5PsP+KxkyQFLdZlAYdgjeTNrQA6+2jFwOr79cHZBX1whxp2dil4e/d2l5PvTfxsScDkhi1oOFGc2Epish8DEPsNoJuddszx3RV1Vz59ZlovIlNYmTdg2+EEkpbYm5VWdL+Ftu4IPwGbwgFphjPE/6K6VSz0UAfUoHgV3iY/WYhEgHO0exjdSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we hit acct_account_cputime within a irq handler over a kthread
that happens to use a userspace mm, we end up summing up the mm's RSS
into the tsk acct_rss_mem1, which eventually decays.

I don't see a good rationale behind tracking the mm's rss in that way
when a kthread use a userspace mm temporarily through use_mm.

It causes issues with init_mm and efi_mm which only partially initialize
their mm_struct.

Skip all kernel threads in acct_account_cputime(), not just those that
happen to have a NULL mm.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org
---
 kernel/tsacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 6ea2f6363b90..3ef149b1245d 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -125,7 +125,7 @@ static void __acct_update_integrals(struct task_struct *tsk,
 {
 	u64 time, delta;
 
-	if (!likely(tsk->mm))
+	if (!tsk->mm || (tsk->flags & PF_KTHREAD))
 		return;
 
 	time = stime + utime;
-- 
2.39.5


