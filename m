Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8106EB2703
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 19:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398016B0088; Tue, 10 Feb 2026 14:27:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B806B0089; Tue, 10 Feb 2026 14:27:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227456B008A; Tue, 10 Feb 2026 14:27:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEC56B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:27:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91CA5B9C4B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:27:49 +0000 (UTC)
X-FDA: 84429531858.01.FF4809D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 368911A0002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:27:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KemG4Sqs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of andrii@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andrii@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770751668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ALiS/IiSgpF/DLNddGZoClZWoRJivrQGn3myAjSUyiI=;
	b=NuDRSZ/OXV+ERe8aDgE3Uesmbxv264oDsqlhjVRs7DgRIVGxZJUCvMDhTVCmFHidisMeQE
	w62Rm78k7yvEAJwUnd/FXoy0Tyv13Fgyo9R6TS/8sSO9BMgLISBg6NWAySm6AAfvklbLv7
	6DP+2TRLzKqPYubPuF26gOQOR4J0p/Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770751668; a=rsa-sha256;
	cv=none;
	b=HRyjSS4XgQwU7itg8K963YRqzT8C9gd/54b49FpqCYWRdsYsIy7VCCKvntju4k1eZ3jwqn
	HPb3FHOzGCqHjuBwbxAfrLQpbWXGyOlNU3epz69+aWb19StIDkuz3D7up+Vr10x/4sW/Tf
	2dIkAONRIb5tMIFIAaDVJkkAuww0P00=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KemG4Sqs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of andrii@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=andrii@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 367CF43226;
	Tue, 10 Feb 2026 19:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E616FC116C6;
	Tue, 10 Feb 2026 19:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770751667;
	bh=wkqp2wPWayOvVJQZcLiwtChcNMqp6C7A1Am7bm/3V5A=;
	h=From:To:Cc:Subject:Date:From;
	b=KemG4Sqs9ukBU7zErKNReg/06R20qHNXnHuts5awsxDwSLOSqe1UJ602jx6hliW9u
	 uPtIQdehjo9AmefRsQfYrt6UxMeAtj1BxTACwhy08dirC7zI5KeRUknrnTCwLZoGAM
	 oV0U5Tf4N4X08iogIIMektrIIotXCJtpecFdjabCUzbYlUeSNaOU3dv5IU43B2mMjS
	 YATifKGsI6gUi/ydRvS/l4toXejdgu6L3Vg2eh0+mNok7PkMpwRS9l1amRKlBS5+LX
	 jhb05mcmwWbwKIUMxuOCiShc4/f5Wv9r4QcUUIJHqokoCuuh+ufw9VkxWdGhzDTATS
	 i2ntxMitxqqmQ==
From: Andrii Nakryiko <andrii@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org,
	surenb@google.com,
	shakeel.butt@linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Ruikai Peng <ruikai@pwno.io>,
	Thomas Gleixner <tglx@kernel.org>,
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Subject: [PATCH mm-hotfixes-stable] procfs: fix possible double mmput() in do_procmap_query()
Date: Tue, 10 Feb 2026 11:27:38 -0800
Message-ID: <20260210192738.3041609-1-andrii@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 368911A0002
X-Stat-Signature: wq6rh1e83ru9ikmnwz9zddo6ocgegfb3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770751668-63517
X-HE-Meta: U2FsdGVkX1+ajUMob7SkNw0SH62BkkpN138s97togosXUoL6nCWzkehlCWaCOGakUMgXptT49LmsHB1COfEmw82EsauKZfWRzY71hT7J2zMkMkDiwZ5zW994xRhb5m98ysDgtTmjP7Nl/PHzcQoXZKUGeN410H76cP9RsPqGVBJ0i5dPa1mZ27PZ5fYH7NVi4X1Z9OCyTMm1RO9s/DgmYI3iiEqzjWxvDqDEXb8/Ns1KM24DOGk1UxXdfhfU6Rdas1GjtY8BKiao633AoyfDntzijFs4FltKhvcGlo3aEzh+CcWSy8c2l3bz0vpEUwmf508aX3dvh60p1g1VBmC0ZkLSiI7M1OpqChDYJW/tXcG66oIacSOtNeSBmLzoCIJtqGwI3+vWee7ehW6GJk10XAxH0OL2cbgrEr1D3bkQE2I98A7R3HPUKDh74gOJ38AUYrrlnyNltfx+79f1pKdkJvXpF1VXrXaUEKv9tpR+iinydnLF7pIGR33TTix59vbtoIVU1CB3X2RFRJq6+8ldlocc4Bl9M/Pk6rhwpz7tpe8Wl44+yEU4d7uDAoIURZZJ3UXorbwRXI+mmnLJUHBhq5KV5/GfQHFJa6uer9R1mxlfnOfZjGyUImdKGz0YAtvW9c0RyaQ5ZznFlWRrsqTHmltcBttbfhj0MdqBiE8/nC3zvJdTNr7DVhUtTXA55lgVeN7gzCXZo0C4E0EWJijav9OKCvt301fIcb+PIB81V1qF3wXKAQBfkD6HuJnODkRSEQ/6rRVy+X/r6mVioUVwc5VJNpgjnnIkou7TXUTwYZ0UMw7bxR0LjXwrdac9WE2Pdi1Y7mJNqB3p4R6jgthw3zvYNIM+KC7y8kJ3XcYmBtbf6V1iW6fAB6AsU1JTMOpIVSWz/0nJ+sqzFDEkWMRwOspWI1wPG1stMmFl52Ko0KjAlJ9grjEFVtzWGLDCg0tofz6/QIAoZFLIelK/NKr
 QRdnAms/
 dJnGa+cvO09z1qDjC5A7MIlA/x7kM6apByeelb1y5JfS8Jq3YKqg884WGiNHDmIjQjFBjcUOAPejmDnHr7rSQ84stttxhVAIuVmAmHIlu8q0D+80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY we
return with -ENAMETOOLONG error. After recent changes this condition happens
later, after we unlocked mmap_lock/per-VMA lock and did mmput(), so original
goto out is now wrong and will double-mmput() mm_struct. Fix by jumping
further to clean up only vm_file and name_buf.

Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
Reported-by: Ruikai Peng <ruikai@pwno.io>
Reported-by: Thomas Gleixner <tglx@kernel.org>
Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 26188a4ad1ab..2f55efc36816 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -780,7 +780,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		} else {
 			if (karg.build_id_size < build_id_sz) {
 				err = -ENAMETOOLONG;
-				goto out;
+				goto out_file;
 			}
 			karg.build_id_size = build_id_sz;
 		}
@@ -808,6 +808,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 out:
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
+out_file:
 	if (vm_file)
 		fput(vm_file);
 	kfree(name_buf);
-- 
2.47.3


