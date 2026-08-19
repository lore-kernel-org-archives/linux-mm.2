Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F97C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D80C6B00A4; Wed, 19 Aug 2026 19:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0086B00A5; Wed, 19 Aug 2026 19:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5D86B00A6; Wed, 19 Aug 2026 19:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5057D6B00A4
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBD8280379
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:36 +0000 (UTC)
X-FDA: 85119565272.23.C933922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEEE24000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aheTWAgb;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fv8QyTU4RY8EKIZbQbAauqSD2AILso9hb2wl7UK1viQ=;
	b=ut4R/PkYXlO7xm2P0D9f2amWuW2w4xqLWKR4i8M5mMyEkkzHuuMoI/BDD1sOSDzfZt2gDR
	pS5PaCk3Pz1IikutNpoAGnWfyTX6VHVsSI6eIZ+ksHPDYYSes+/0bfNa2llR9/J1KBz1nB
	BdeohNByCaxw5fXxX7F/cs6tqXgPYWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181035;
	b=UApTmKAWKfVRnd5E6brQW7E3DwenH+Io4Sk1IUGTXIIYmJERgT6yOT9c4VLF4jujnVZVvR
	c4afSgIiBdP4q8SQwRlQbVEMu91+QXFMMFmJ+WTNSKaVuYhja8/kwNFkbChCJAybJ8zike
	MD6xTlgjONCQVbT06a1qeSNAaI8sc0k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aheTWAgb;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B34C43628;
	Wed, 19 Aug 2026 23:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781B71F00A3A;
	Wed, 19 Aug 2026 23:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181034;
	bh=fv8QyTU4RY8EKIZbQbAauqSD2AILso9hb2wl7UK1viQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aheTWAgbYI11sVETqvJK2lIN/QCtKk+jUTksr8d38BZ1G7LXn5ciJU2kV1FMfrtmE
	 x5Nnq5XYF01D52VOCaFlhDDagPSgLf9ydeEXG3GKOAegFGirsAEQjyZMqmBVaqlSwI
	 pMwAwjK2lfA2z4C2jvG+KW1viiMGa5Sao32Hs3etES+osbUfbaYKUfkHjbsNwJnxAi
	 i3AtybIxeJJE8yvuUcmJNRePJL+PQ7fBmXoSEKynClLfVT3MSCErW7T8lCghlChbMP
	 tXhBq+ZxGanb0v3pCy6LWkCR8ljc2M14p/psUqtZ+tN63jM9P5d7T7xF9Alu0yONal
	 4itgWc3EmpRiQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:24 +0200
Subject: [PATCH v2 07/22] coredump: pin the protocol struct sizes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-7-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; i=brauner@kernel.org;
 h=from:subject:message-id; bh=hNfZLj4wkqR4WNDayaZ8RfIqHIoYlqBK8NeplKQdya8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+ruPdQcu/KV3delZuzLP6zVCXY77RHyZG1qzuUp
 7bbKjst6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI6nWMDKdaPMNPTbgbYhLi
 tExpbXfZXqfH7+b3BPyeeS3zD8esc7cZ/rvKPeP89C9O42WYhdi3Scq7956uZNLizXY+om1dYc9
 Swg4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: 4ujw7unmsmtkpggsb8qfqsnjfdhf7aiz
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEEE24000A
X-HE-Tag: 1787181034-495191
X-HE-Meta: U2FsdGVkX1+pJA/9U2paeRyFdS5Ld72JiMz9g6VwbDo+gI/YsJvemnQzSC9Wg9h3N2Y47Q0Od9yvjC2u/Pe27cojPZNQSPXBaCP49391ePfVKx/HVmaVBicULg9Jd+KqwOJxGHuDwhlQFReJP0Yl2UzaddbcBkPDyLUFYGUF2BgxTdjZ+ldmLpjOjT5Pb+dzMLfYcjgdGYU1zbVFoh7NZxXA7rTjaaeMxD3H8fpjk/gAjbjp2fZwHbKhs9T8jXPtZFs5GKd8YW5wgdYJztIDrgwiy+XUEopOpthTidjfY058xGbdTkskR6csANhfL/xnIhEhW+eijFGw1ExpROj+xxdwdkc7pZc7vjv6+C7Xcbd7O/xcahxyTCSV53p0ZdGJiOslSXjQ9bCk9YavTCKSb9ZCJsWf0oRcmgicXAVcKHRKRSuLGhnWaPuzygrS2mkMVoD7xIl0U6Jmn2eUrkx5/S1IOCnRuesUHQKqEFSKNal1Eq38eZsTBbYjkDEV/fyb8wWBAJlTu9ywQFD8iY1SR7SL9dXWGc1LHqrxhN3aYKbzZgXdJRoEvd3kEOUJPK28Co8GXbfliAhv+AHWJeast5QF84CL3NRn0Snyp05jkiNAAJ80iG4UgKMAIrbbktEcMS3WVZ3XtolabM7+FPAqURPUQxpyoZIfhBjBcBTr855e6VEh5cvIsF7aVhG4VVJb8WG3egqRnEqoma9AAYH+ygRvrt9Xj+tU8sLUZz/d0sbJFqz/25K95D42EkcVdnsq3ZLjrd+pQIk0DfGdWE/o0jaWgbbnlGJ7ll/MmVRpMChX9oBctljihCCGbtCbXyxzkp+Ih0q9riAJwEn0Y9FAAUKIh2m8p6AB3P1VlbgXUvmCK4e0EKjvhTrFKw0ESetgmzqlNU7n/ZBiItTUvkBTcXSv7+3z3MPzWEJymVQGPM8FIxxuDz9zrsY5EjRWfS86HX5sde6Hzh4zQ8luwKO
 aGMqkH1V
 aB4CkNcWWqcpX4C6vhOxvyUSroODS9gkFCLOavTRKriLPf5pcmwqlgt8HWpj6QoUjB8BNKGicyUVcQ0hztkWFF5tx3O4/vOg/naiy6zjqm+a3l4SGRGC1iUy7X/IOsOr4V3/FxP/WvKhNrHglazR6vz3vQAsqtguEDUOkHQpWpkd4RRvJphgGHidpBQvRfwEJrGYcUaBEZVnF4gli8AbTCyytytVI7Uk57snuGHeuM2ljJu6nc5k74kzsMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

COREDUMP_REQ_SIZE_VER0 and COREDUMP_ACK_SIZE_VER0 define the initial
struct sizes.

Assert that both published sizes still match their structs. While at it
fix some issues with docs.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c                 | 2 ++
 include/uapi/linux/coredump.h | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 24a6405ea242..c696b46c97ff 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -759,6 +759,8 @@ static inline bool coredump_sock_send(struct file *file, struct coredump_req *re
 	return ret == sizeof(*req);
 }
 
+static_assert(sizeof(struct coredump_req) == COREDUMP_REQ_SIZE_VER0);
+static_assert(sizeof(struct coredump_ack) == COREDUMP_ACK_SIZE_VER0);
 static_assert(sizeof(enum coredump_mark) == sizeof(__u32));
 
 static inline bool coredump_sock_mark(struct file *file, enum coredump_mark mark)
diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index dc3789b78af0..662e0468da6e 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -30,11 +30,11 @@ enum {
  * member is set to the size of struct coredump_req and provides a hint
  * to userspace how much data can be read. Userspace may use MSG_PEEK to
  * peek the size of struct coredump_req and then choose to consume it in
- * one go. Userspace may also simply read a COREDUMP_ACK_SIZE_VER0
+ * one go. Userspace may also simply read a COREDUMP_REQ_SIZE_VER0
  * request. If the size the kernel sends is larger userspace simply
  * discards any remaining data.
  *
- * The coredump_req->mask member is set to the currently know features.
+ * The coredump_req->mask member is set to the currently known features.
  * Userspace may only set coredump_ack->mask to the bits raised by the
  * kernel in coredump_req->mask.
  *

-- 
2.53.0


