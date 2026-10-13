Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2AF9CC6B15
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 22:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31B66B0088; Tue, 13 Oct 2026 18:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2D46B008A; Tue, 13 Oct 2026 18:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1C86B008C; Tue, 13 Oct 2026 18:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 818A26B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:56:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C362C8020C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:56:21 +0000 (UTC)
X-FDA: 85319113362.02.35C9B54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E487C20008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:56:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hjiGyi2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+BouziguesAlexis.JohnDeere.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+BouziguesAlexis.JohnDeere.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791932180;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=koSd3yYUVWQC7odBOuCpRX4lIyRxBct+NZBWQJm27+o=;
	b=12nIN8kBshl/VDffqhN7pCoCO4B+9g1/Q2qJnxtP78yxMmXwdsnLoM6v/WpsFo51Pg0tZn
	WmqrXpOXA/OTMxxxqWrLMz5AGAb8acbx+GQBdRfmYtqb9eWxKgoJuSOVgYNRd1MG4TkQeN
	qyTSKGxidPlFVShnFyHa9BXLTt/CsDY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="hjiGyi2/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+BouziguesAlexis.JohnDeere.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+BouziguesAlexis.JohnDeere.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791932180;
	b=PdMMsbGr9dyqKaqlnvXoedGYyFHg43wPLGWUZB2WmGA/M/R2OUrv/1jxOQyHubkrhy9G7i
	tT0BjhD8jvdgEfTx6RqbFPsvOtwUAc2gpa7Mx1NOHfeiqAJ2bsizkqFk8G5NqPSaRdikDb
	+AZtYN4faepuYfT7aDbEZF/IpVcpsmo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A52A400C4;
	Tue, 13 Oct 2026 22:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04174C2BCF4;
	Tue, 13 Oct 2026 22:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791932179;
	bh=RsU+ZCZtZcs7B0IzQi38/te1fsHGikwxT7Hdf7V9Egk=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=hjiGyi2/DvAkEmLZblH5iWWZy/b7eXxnYrVZVI08q+X/bXroz3lr9nOGMLhZ9uqqX
	 n8Jvla3YzTzONpFwO1PWSZFcNL/eVnElFp9CYw+M/J+lA1y2B1XFZYDFWmufH1AyCz
	 qbd3Mwz8WtzQWnqlZbWk41Z4HeslQPHbIswmSO4FfiJ5TRer7oMbsQLggNTItjlkHN
	 M+qZH93/lISOHXPJI5ggT4Ha9vUdTnAUbV5YwjfoMaeAGVXiqbdFvmk3THQBPNZA5L
	 ehsPabwbf4kMv9R6HTqhreusI1Ly0ECj5PD4ED6ioyJq0KBcTeZbMkPiXuJe+kWYdU
	 UoTMSJnK3ar1w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C4FCC6B15;
	Tue, 13 Oct 2026 22:56:18 +0000 (UTC)
From: Alexis Bouzigues via B4 Relay <devnull+BouziguesAlexis.JohnDeere.com@kernel.org>
Date: Tue, 13 Oct 2026 17:56:19 -0500
Subject: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
X-B4-Tracking: v=1; b=H4sIABK3zmoC/x3M0QqDMAxA0V+RPC/M6iiyXxl7aDVqGGlL4oYg/
 vu6PR643AOMlMng3hyg9GHjnCrcpYFxDWkh5KkaurbzrnU9zrxjyiJvpJ03FAkFcxa0FxeMA/k
 hzv0t+gnqoijV/r9/PKtjMMKoIY3rb5qVF05XCbaRwnl+Ab86sxaOAAAA
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, 
 Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791932178; l=1299;
 i=BouziguesAlexis@JohnDeere.com; s=20260527; h=from:subject:message-id;
 bh=hVmRWa/BeiGIHAxsid1KBCGZvcLmOYCtQjDsyT49U1Q=;
 b=j/+/Nm1eIrvkAXqIYV10l74NOMUNM9pNumM9DwYrXfv8vOfeIwzsbiovirVM036T7KgOoK0N7
 afOWB8waOp/Bdr5mYF9JJc3//T0l4KQzImC2s6ilcNMo4yoYzbz2reU
X-Developer-Key: i=BouziguesAlexis@JohnDeere.com; a=ed25519;
 pk=5KJ7ArL00x5flpPhi9zRLC2p88V1rZXDQ5SXhpRvTDk=
X-Endpoint-Received: by B4 Relay for BouziguesAlexis@JohnDeere.com/20260527
 with auth_id=797
X-Original-From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
Reply-To: BouziguesAlexis@JohnDeere.com
X-Rspamd-Queue-Id: E487C20008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 784t1uy5pcgr1cq4p3t8km9kxirpxqih
X-HE-Tag: 1791932179-215229
X-HE-Meta: U2FsdGVkX19iVSw8GNW4D8uZjBECiT4zAhhwc9JUASawtL/99KsyGr6i7qQEVBpTeduh0w0lWyWluOu5Vlw3sYpsULFQCNKTDdh87TTaB2Vfpy5gaxs11VcrIKPsesJWHHsD6Uyew7e93WaHqfydjl0d7fpGTVrmXfbRIBLJBaYxgsQJ+F2GGYRcAmDh6yNy1Kxg1dYDsWowTSlnECMkki7o+LfJnTPYzreQD8qvn2aELPNEMa7EkTof3ahy2Px3RbW+F99ONBnpnkvggZfkMiQtrAh7KHWhLS55i5A8KRV54FmXtL++o4iVn7QR2eFSHh+/OSS5bzMHXQPCVSTRxepSjDYf3mABjcchsUsOsyEuP9Ed2v6B4EqTGUGa1R2FxUYqfIGkEWZcdopWjACqq9wW1leJm1cTNAFRxWsqfKY90NGuLyJQEuD5r2sQc8lFmy8z+gF1yxU4ajd+ZUNZ8i0JpvJf82FUkQvY6l9LeZkoZPG0aom8BQtT+3PTdPGDAyzcriOo7FWYIP4RXcCKTVx0MBxmiIbq9xXgJYKUw+04l646ki2EgJ0uVx7OS0SuKr0MYXlMmi7Rayqg38zZNOOc8xHCMCY7Y0iZYpuBiddb0+FKzRsRMSaHOH/G3XdAd2Yub0mRMjiAOVG6a3DlByduXBKu562Es91XbvutFhiXE81N4geoxwvLfZvvafif4bnE3WfcH8KRVYCwXxmiSvGXrKIx+yyyOvkqj8zhMA81awZwQZk9nuQS+FSxWBXhrJp0w1CViwB0JAMIbGzbiwEUL/bo3fLrM9vYBP5vjRwDIgTm9AUO33TjmXdRQP8d6YXtrlkwZeRUw1Tl9gvhLdfUF5m8JCarzeTL7K1c1Y0Y62+LwOyZVR474cLWPmHF1b9TomO6E8S8vGAiO6/EJKAJtWO4fHIFXTN4wApN3QSNMgQoAtcCdqZZe5Hfd6O+SLueTEXWafDpyX0Qhw5
 /IT32Ybr
 W51PSvzWla+rA0pf1mUjJPHv8Q7bZE+cSMlF+VYN1PIFUdS0kURwHSwQD7wqyueT8W2O0mqwtchG8fH4q3RACawJyZXJJQVDHf6ZR8kGNJeEZVwrQHo/WA7t/SL7vOnKhZQQottK2upMu5hlDeiz9E2/hjLQmzXgO8jyi3CqBTSekduhWI5z/quOE6KI5X3/5F/FzCAcYaWXuAMp7m4YaRGETIaYXJwpk4Ph3Iy5F23JwZ32yGGNuKKVR34vuVyDBV7fF9TkWxvElj9nwQj1NlTpqBDBIat/Y5k5xRTLzvMD1loiDgcl8FkbllDFAiT5ky2LsNwESOHzJHBwASEouSMFTnprh8wSN357DpF1p+MjJ3oHkSbS4m9RA+SOE91TfCpFum08U6xucHLm9jgNe2oyDgBA9+4aVhNVi/SJ3qyqss5d2tfkjNy9Wcgd3vPAjQvD1O/MbYpILrWoMrpIwmjSO1zMvRFxGZgAxp42LnmZ1VSCm3ULyxhSNRvaL8wsGuu4dj5a4FP7XQqwo5n5mQzevk/l8dBRIhIhCBAY0efDIO5Xz81QPMOmL/jHbEAYYZbhVuPHoqEleYt7bfx4745VHwUkHGFXV7Ormb0pQA/cRjqruEFb3iueJIbsP9KUVXm/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>

Commit 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run
concurrently") moved setting MMF_OOM_SKIP from __mmput() into the MMU
exit_mmap(), so it is no longer set when a NOMMU mm is torn down.

As a result, a NOMMU OOM victim that has exited and freed its memory
keeps the OOM killer from selecting another victim until it is reaped.

Set MMF_OOM_SKIP in the NOMMU exit_mmap() once the VMAs are freed, as
the MMU version does.

Fixes: 212925802454 ("mm: oom: let oom_reap_task and exit_mmap run concurrently")
Assisted-by: LLM
Signed-off-by: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
---
Restore MMF_OOM_SKIP on NOMMU mm teardown, which was lost when it moved
into the MMU-only exit_mmap().
---
 mm/nommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/nommu.c b/mm/nommu.c
index 498e01ee40b0..913b2a1b5b3b 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1555,6 +1555,7 @@ void exit_mmap(struct mm_struct *mm)
 		delete_vma(mm, vma);
 		cond_resched();
 	}
+	mm_flags_set(MMF_OOM_SKIP, mm);
 	__mt_destroy(&mm->mm_mt);
 	mmap_write_unlock(mm);
 }

---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20261013-fix-nommu-exit-mmap-oom-skip-b8e68bf34b6d

Best regards,
-- 
Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>



