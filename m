Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49482C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DB36B00AB; Fri, 31 Jul 2026 03:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5259B6B00AD; Fri, 31 Jul 2026 03:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462CB6B00AE; Fri, 31 Jul 2026 03:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2210F6B00AB
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:03:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFF481A0383
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:03:53 +0000 (UTC)
X-FDA: 85048181946.14.3F77A1F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3BF16140004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:03:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ljw7EUrP;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785481432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3b41HIRQg0eE6YbzbQ4NGUUdPVrRSzptktaemvAyobA=;
	b=N2vsiFR61nORhT/hMSi2OVx4aAYGqbZ/KSMAtgLjBVmsF33F5lAuHudk93IVkmODKggsy5
	MhdDvm8VKNyzwWRMLvewzLmgqtfuWxZfo0aJ71Tc8FFjU2U7XcLjE6W09gzAy+e5L11NhE
	UpYs57eyeuBWQToCyGEygXtmDmbdwTc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ljw7EUrP;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785481432;
	b=z+jGpGZdDXgXUpdJ4utasXisAeWShg/0k5dNb9zO74kwnpugi4dVCIb5mybSMUOVKTkbVP
	Uw6AciWhzUNUZ2X6+GhvZl/MPvUJ6tKfRv36RKEEd4uMZEEFkK0ap7BIJYc/R1UN2gzWqx
	vsLnvaRK5OUm/m6hcb/rJQP+ns3YHeE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FA9222C8;
	Fri, 31 Jul 2026 00:03:47 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E59F03F7B4;
	Fri, 31 Jul 2026 00:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785481431; bh=Z2oWdrw1FV6V9X2m0SUAt6i6MEK7O8y/i9sTV7EdzyM=;
	h=From:To:Cc:Subject:Date:From;
	b=Ljw7EUrPWgOzkpTOq7GogBK08q5s3oTtp6+XhjbRJQ2O1E30blvq9rhg48QKrt92Q
	 vJMMd9E4lXwNCnWl6u5Jk8f9hOzbp+mkEmaksWGwcd+f2mHhv0d62/n+2u/c0jC+PR
	 DLnNiT/BNKw5bZN7VnlopLEuQ5kR/fJi5DLUmQvc=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v2] tools/mm: add thp_swap_allocator_test to .gitignore
Date: Fri, 31 Jul 2026 12:33:43 +0530
Message-ID: <20260731070343.83837-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BF16140004
X-Stat-Signature: 7ic5drbchydzzt6ap8efwt56tos4fsh8
X-HE-Tag: 1785481432-630528
X-HE-Meta: U2FsdGVkX1+VlaQ+8xmZ0lRELRNPohmGIHH1FIB6fM0VCsy0KcV56JuVPZ8DEkmV4wU8HBkJ19hIBd8THPpHZPrd2XI4DaVE09i9wXI+71/C1CPiIQupy6jF0qvNw0b+JdO1SBQrZR3k6J8xDwkrYgxXlqsyb5/p9nw8k04RRgDxU1FdksJ4g+MZZWeGsBc1KFWJ0GrM6TJbsgIt93so8qQxCK+CKZMoWwd5MzVESaUzL1XznQAag7odBgGL2S8OoKvVBjDE/K1bn+p5iOiF4KdDrI3Y3Pml4eexz95WKtGP6BpTTA+DfJLuF6mCA6OAXFzzK6U5VZYqcXT01we5MxmGN89Dbnq7u5hI/ByNn6D5bMqKGyPJC88ol4I/mDXV7PXeN9vcOMr7C5lT6mIcXO/s8OjHnPyVpPXkuLCaqCNbzmvkEAhRyKKRlp8KEOusF4dE1UlH3/yEod3RGfUY9Pdjq33uKcpfRV2nUcUT1BF3RfTFWR5f4POMo43xm2EnLeEzp6625M+O/X4bYkvtQTOSs0yRn3sIr2jjiC6aNaCDUNAbAFdqMlkFFknGsW3YQoFy0/ZMmxmzGvFgUY0fOKAOHGZze3aL3v2WNwmQKuK7AKR0oBh62qaU6bLgCIOMq+lr6IQAHBwRfMetOAD0XE9qBHCkce+El79X7MFAhIOsxYIXx2e5lNpkjG7IwLusccOK6OAvJCziAvWz6NzZ/EZh2S/bplY6JZWonAzCHQ42IhpWa/dHjw5ai05JCxLsT6CcVIIMjXF17XhWUN87ITvVLFyH2D71TGLpwK2cS0iJtU04G3ZpywkI8i4eM159wdPTq9qld56woGZoFEt2sUCRlIcIx//tElpVJ/FIkZeFLbss4fokQKh9lxhYkBOYcmvwT51XgrOdzQazC7hmi0jp4VuXSiPgCXOaJTfrLvhYmFNK9Xf7pKkkHuoocBsEo61Va2q5nVlxtVNvTro
 9gSqsGeO
 NrlKBuO9DkHoJesRi6QnatKcXJD3SKYoKES08Z3AALh5KaZarMHKmhW/J5VU2zXRxtnkRjtmexAUY4Dt4laQv5TjRxZupWTcRWKtUn68EntWEKdDnZSEQ9QZP61WJvFlu/82ogJTwHlgHLsq1NRrKS+hL4TZBap/FnPVwwyLdM/U0xuSkzuAuO8J/NLPyb9ZDKplnAXAH4l/ROODHDVWT6e3OCf9LFesWk5doH8VxXKY1uygWbquo4hWu1QeUZCYLO1bO3aAIYPORsJm7/JVUEroCKoAUXLwgrmi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

.gitignore currently does not include the binary
thp_swap_allocator_test. Add it to .gitignore.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
Changes in v2:
- Correct the binary name in the subject and commit message

---
 tools/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 922879f93fc8..1446a659e540 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -2,3 +2,4 @@
 slabinfo
 page-types
 page_owner_sort
+thp_swap_allocator_test
-- 
2.39.5


