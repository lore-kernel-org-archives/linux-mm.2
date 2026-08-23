Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6396FC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 12:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ECF56B00A2; Sun, 23 Aug 2026 08:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C45C6B00A3; Sun, 23 Aug 2026 08:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA3C6B00A4; Sun, 23 Aug 2026 08:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 398156B00A2
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 08:18:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7D651C0405
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:07 +0000 (UTC)
X-FDA: 85132436214.21.397FC69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 250C9160002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:18:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hh4r+QK2;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787487486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kndwtv5Cm5Svk82exojGXyoNLdRzxaTi6Z5eoExMZW8=;
	b=yKR7cWtQ6hd1VXoYPT6KXATiYOfC5ZEiXeqnfYjLQo9jXuJEDKIKmgS/Yhaj89ZdeVNPVb
	e4c//OcQl1J9znZpJVCSAIYR9xg2JNlQXI4ea1pKu5Rilr7tpIztKWNj0cwEV+XER5CxQG
	S+iNxJ43xwDfrO683mVjqQaJrBnEN+Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hh4r+QK2;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787487486;
	b=LoQlSFMXkbZpAwDceaqu8IoZaCRixaN99PIgTZxFzy+OZcVfDQ3oSZoBrldQcK1+1B4QYR
	EKwz1ZwzNRRy7qO7j0AIl1UEb4C56pL26KtnI9YSLpPbZTPlJWvVR5sc6p/wfYzh7hOwut
	pWTcpu4ZNveQdE5JO5CHnox8fZE4Wt8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67F6540517;
	Sun, 23 Aug 2026 12:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DCB1F000E9;
	Sun, 23 Aug 2026 12:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787487485;
	bh=kndwtv5Cm5Svk82exojGXyoNLdRzxaTi6Z5eoExMZW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hh4r+QK2GdpFEuv6ihYd8/+0ZW1NQU+UeKZdTxUMtpnRo78N4CPidoNDY5bHIHEh7
	 R2QKLcipnEJbDJbbS/Dryi1+nkvs1RVC1oV64SnN7k2nbxm32zx8oGLesqLons5Z1x
	 2N743kbgL182hjg41CyjOn542aZh8zZCGbLPjXBGPpUuHth2xsSL+YIvT3nZoXK0qB
	 nyoOjCJERvpXxA2wQcf5+ArmjXQXhaDd1jr/iBCUxiuFkUuo6Bany7IjY+sHLJobD7
	 kWXhJOkJCu06p9sKN9b9omMLEuVZzBXGdQqUa6awxh/fuEgRLWRTd6XAExltaipQcH
	 DRctSy1CvIbDw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 15:17:39 +0300
Subject: [PATCH 2/6] userfaultfd: constify VMA parameter of userfaultfd_*()
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-uffd-vm-flags-v1-v1-2-3086981b33cf@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: n67x4ao9skwi9stfqmghc9sd1fzi6iuy
X-Rspamd-Queue-Id: 250C9160002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787487486-455129
X-HE-Meta: U2FsdGVkX1/GQOR18mVAyqxfCDLhBPjQw7YWP7IOpSSEt0/YrNXyuCnO4c+Dp9CUcKw4i0yBXHFNrivul+A2kJDxLBlckvuptkNiD1mfcFwO34hkoOkEqywS5CtD5SSQOurkspMxIu4sBhcSbSg1nqJWfTlxzN8H9MPhCg97oqRG+4IgMQZeZIimKUUxyeORkZkWx5LpHRn/5CBGmNN1hcBio+gQZK2KTmJH2VKpvQYMEeLIUvmPTvro//CBtm1cOgc0JKZWlbcStl7MXoWaa7KPIV2Ilf/DrCwCxsZG6Sj0Qw4H2mUeATAjrtY6940iJYTd4IlSVtxg7+/Vr0KPwH7XXxi64VbvdxfJ143MEipocdeEcMQ4lCs9DgAGOb7sFVojWX+RNb962FfLM7z3kXSbOt1jNjPaHdorbVZ02dE1Ngt6565TACE6NMWJrMXrsX/QrQAiKhrZnP9idrZT7WZPRIQRLLCtLktWvnvDM+6KH7iqGFq2XriK5WiykzjvBBJKGD2SJZGqz+q2hLkkCmGxuuYz5bE6GBul2poyMj7UtRLXle0atKbWSDQRfaYDIaVAnilKiTLErse9yG2t2CKh/y2fAodbAhOO+1wD/gCa24IjRROlIN3EPPc28zLwWh9jcpWchumL8zu/nVSl/ZkEUiT8N4P1XPHAMMz7i4Kf6DqxtdYE8+8ji/HrkvOyn4a23KrhcSd1FduvKFvp4iU7NZIf4ijPCAk5WdgTGTDExtx0iLN/EWkn+0NfdHn5wDTu6wQPQsz8h7ZCHrWGEpDsDpwNwkxElZogtBfxyZTSARmgd35p3B3VVRliVbgXKfYEhpjX4aPK0HKCqcpe0Bfak5F8vABYPvmLGJYM3OlCrk6nwK4LSGNWwpEF++E8ZiJCb/eclOXAD3wtYDQmo92+B4r/Lni+ajO4dl36r772JgCsP4V/1O4eabSuNvH2PqK7/gZHPxF3ReEqd4i
 ZSPK0k6z
 nPAHccdwUvnGPwwLLhxKdhYduCVbjPM8N5+jzI+qtGsPQNt1XdlGjR5SeBDaPWoDqQgCG4VwY8X+9bnO9Nq0dPg4rqHqwKK/PJ0vmqRHOKSE/GTeZFpiMGq+wcpI6BkcEDa2Nna1OuMthCuTSfjlWp631sFQb0ygZG58iXftbVzw8BSngbFAyZOYBrji/tKqPYH49ZOU93FC0bMMVFBYOSKlxhfyCLw6EHrVluZE+oIx0j6IpxsU57s04OuG+NkPCmDwFrqtueausoHwuCPbypUU3JGnRxk58qcKOa6AdUuK3hRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected() only
read the VMA.

Make their vma parameter const.

No functional change.

Assisted-by: copilot:claude-opus-5
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/userfaultfd_k.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index a4351cffc60c..3396d270b159 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -204,22 +204,22 @@ static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 					VMA_UFFD_MINOR));
 }
 
-static inline bool userfaultfd_missing(struct vm_area_struct *vma)
+static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
 }
 
-static inline bool userfaultfd_wp(struct vm_area_struct *vma)
+static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, VMA_UFFD_WP);
 }
 
-static inline bool userfaultfd_minor(struct vm_area_struct *vma)
+static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
-static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
 {
 	/*
 	 * Callers gate PAGE_NONE usage on this; PAGE_NONE is a BUILD_BUG()
@@ -230,7 +230,7 @@ static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
 	return vma_test_single_mask(vma, VMA_UFFD_RWP);
 }
 
-static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
 {
 	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
 }
@@ -353,27 +353,27 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 	return true;
 }
 
-static inline bool userfaultfd_missing(struct vm_area_struct *vma)
+static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_wp(struct vm_area_struct *vma)
+static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_minor(struct vm_area_struct *vma)
+static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
 {
 	return false;
 }
 
-static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
 {
 	return false;
 }

-- 
2.53.0


