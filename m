Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E338C606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c6oYfokP
Received: by kanga.kvack.org (Postfix)
	id C37D16B05BA; Fri,  6 Nov 2026 07:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F796B05BB; Fri,  6 Nov 2026 07:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D496B05BC; Fri,  6 Nov 2026 07:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80E986B05BA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:36:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBD94C0D46
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:36 +0000 (UTC)
X-FDA: 85404642792.17.CCA9692
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B37B80003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:36:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6oYfokP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793968595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hx7cpP7lpaGh7AkuWcK+sQJGurQzMQvP0gaLMaol2VI=;
	b=3sZi7bzlcry+oIbohoRth0D0S5gpqlU/187QDoJWJuBbAhfIgub/w5VOg+hzwMiSk4DcRw
	BySatHx9tDLe7gRqoec3pJzCmHzy7GRrMLtIT8bX9oOd8Sx8lqP7b96fnPfbOK4W/PsOZL
	vYYzszevDb8DvON+WwNg7F1OxlC3Exc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c6oYfokP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793968595;
	b=5si6aClFsEusT4YHptN4YqHLj2yHVoeUJkm5mD/KRWl+pjOzNvv0Vb0KanBo19ysMl7at4
	jsIYI6T/Z742dlXl9Ku7TIygKrUyvptPnYrMIFN9uUtkA5LIhz5kD3HeoQQ8dfb9ud1LIO
	FLz60WLP7Fs6nrUYkSmhGks49pVoLzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C24D3601BF;
	Fri,  6 Nov 2026 12:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A3A1F0089F;
	Fri,  6 Nov 2026 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793968594;
	bh=Hx7cpP7lpaGh7AkuWcK+sQJGurQzMQvP0gaLMaol2VI=;
	h=From:Subject:Date:To:Cc;
	b=c6oYfokPli5HnMjDqiK9hQc1gt/5/2rgTk2N+PdsEogF5Rb0xC4EkwKKSJdzoc9K8
	 HS1XTD3nLraUpK8VowFt9JqOWw2mOuq5pvzIYhtQZTSycqJgjprckLu+K75x2XZ7wh
	 gwTUfzewIpkbk6W/WyvJbVYR2+ygkHdCfxilGV438DT5X7DVGxkr7ALB+/4cLXV93T
	 SS2tiUQPMwleiF/8oAU5p7Xu8bFYaZF1oi9QtcuYHUtKGYNkWCiCwysrt8KxbQRiBE
	 Gx9IK5fWfjXxwY7je/WymljXri9BgQhnfcD7NSslt74Ve/0wXDa7bYeyS8AFFMG/XZ
	 FxSyu0e3fnlCg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH v2 0/2] mm: free unused page table allocated by
 do_set_pmd()
Date: Fri, 06 Nov 2026 13:36:11 +0100
Message-Id: <20261106-khugepaged_set_pmd-v2-0-d2457b5e377a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALvJ7WoC/32Nyw6CMBBFf4XM2ppOoyCu/A9DSB9DqSiQFoiG9
 N+luHd5knPPXSGQdxTgmq3gaXHBDf0G4pCBbmVviTmzMQguckR+Zl07WxqlJVMHmurxZVjOJRd
 NgRfKT7ANR0+Ne+/Re/XjMKsH6SmVktG6MA3+s78umLy/BwsyZFoVpVSIBZblrSPf0/M4eAtVj
 PEL+WSAHccAAAA=
X-Change-ID: 20261105-khugepaged_set_pmd-60a02f718e64
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=833; i=david@kernel.org;
 h=from:subject:message-id; bh=rnCuDIVL0uS0OJkHISNSKHBKcslE0lMw5D+UBBh9Sj4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLenjw8rfl0Ged9i0xbRk6FjPMLN5wT9PqmG7s9LtDZd
 YpXUeTPjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZyUZGRYf9izc7zz+8tLarw
 1GP2O32cYSXfgT+xeySf3y2b4zKf4TUjQ+/CU/zTy97d/OZ/ujqIiSfUiKdV+ZuQ4bfDHxM+7VI
 W4AYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B37B80003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: o9hueejkpbgnkuu9ktq7x15eczop3e5j
X-HE-Tag: 1793968595-133284
X-HE-Meta: U2FsdGVkX1/PryzYkIFber9EW0RE3GspFa5omXwc86iKg1C7vIZXyQL8ybH090AsPkLM8xIbEDJ7Rbb9yWK/1okWy3lTa5q+TQ7QTeKzuJiBTsgeBf0iHdiKzf+2bJU+TNSh+m4E1mEAk9kiL+bXzHGpcMh2hd3A4CC/Y2f0RefJjqwMGwxXup41N8Icw8YNPahwrAAH0HdURdCMHTFd3jOQK/NW95B1fIqR3JY0x+wdKLQU8spdqLNeXIexdj+oWuX5eBdUxMGVcbIvO2VHQjAjQiAfdAckCNXKgduOLCiyvJWx7kRQGCAVgjBzJAOFWe9/QAIBfMFj8ZpnSbp0P3YIDHFAUFYQzzEQ6MwQVV4Jbqoh/XFrcr1asqnrNojQJCwzPoxhsnbw88/LONAQnHKh0KqlpOO78VL1hvStpypT7nXg2aYXQzsFwHIHRMmrdFJNJOfFU35N8sjNcD0xNi60cqWuKVxzlLZfm0Suk7LRgsvXQ+BWiFkJkh2RBlY23Hx+DtLFA3geCFpLDwobttqch7NH+YyGWWVqy4T541qrmBREf3agO9Mf3WIkqnPT3beVrxW5W0IDtNyzYeD5mCS6ztd9c+sFStn/ufraVd/tmNoloExE+ZTEdalVl5n0qmXjzw3D6CP788zU2ADhmlMwGvf8fXM3mv9jjz8SuHOytVGgiFjXGqynB3gc9gidYOS5FA8eh0dV6FZ0581HgwrMaOpE0aLQvaRHdCRU4pBcfER3xzCrnhG3tevFyxO5LWEiFrf8TGf14zn3bHsIqmPJkqLQIIORTEmH4d4DYDEaDFaj1szFeRz6vPcrXj1vRA8ZMCYyXS8k39qD6oeRtu/BpwhwS28A8xVr42bgqyjg3JK2cTo70HFHkX0MkzLcAxT3mmXrnbwzx94a7K65cUDLCfIlNjwMWIkhovLDh5Y+wMpfQrhzH+vcUr6ofetSr+umLAcriXGLzYu00ss
 yI7QxtXu
 zFD7u3T+tv0HwS7i7Egnkb3PhCGjkdlLkMRDJgpzrQQjxLwPd0Tvp2D1otN2Q7d8//gk1PqU3YdSaCiLVw5I6dnCIyCOe4KMNkKWAkzEDTnOXc68gBnY11jZ5R1gVfuTr7xFxA3X5gS2vYz80HE13cHCOKmiiH9XQ6dUhJprg7LgOEY5kvt/u2HIJHVukuTmSeHsON2Z7iKuSjx69r4F0pPVSdbvYzEH+8++okm+MKRTvG+qwyPvPPkphIATQd29XV+x1kEjh/WbNuXP34QRRehakCUMX0Q+JIrgUh9zYL7zkXgerYhI2bXZULgq5sE7grCVLsFLeCs4QYiPgblLEbx1FWDJQYJfNj/DBGkRZqxPbqqa4KTI5FzBSWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This isn't super urgent, so it can wait for 7.5.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Free the table in do_set_pmd() instead.
- Add "mm: don't allocate a page table under RCU in do_set_pmd()"
- Link to v1: https://patch.msgid.link/20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org

---

David Hildenbrand (Arm) (2):
      mm: free unused page table allocated by do_set_pmd()
      mm: don't allocate a page table under RCU in do_set_pmd()

 include/linux/mm.h |  3 ++-
 mm/filemap.c       |  2 +-
 mm/khugepaged.c    |  2 +-
 mm/memory.c        | 16 +++++++++++++---
 4 files changed, 17 insertions(+), 6 deletions(-)

---

base-commit: f44fd601f72e09e44c667b9234c9cd469856679c

change-id: 20261105-khugepaged_set_pmd-60a02f718e64

--

Cheers,

David


