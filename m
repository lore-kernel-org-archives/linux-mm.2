Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BA9C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C6C6B0093; Tue, 11 Aug 2026 11:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954516B0095; Tue, 11 Aug 2026 11:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A366B0096; Tue, 11 Aug 2026 11:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 598B26B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:27:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CFD8F404A7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:40 +0000 (UTC)
X-FDA: 85089368280.28.FEF9BCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id F32DC18000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:27:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mC4py+uv;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTiS8U5K7y3D0Dlv9kThq0rqgw/f8AQWtxw0lGe/Dc4=;
	b=u2blt7tn618a5QhSb8SWb++XYKAw03W74RZl/eujf3jliNK5+oageiSeOgoRTPc95q3zjt
	xv3kT2nPm+U6WGQjHts4qEfHp5jQLVVmwEjYNj90czWsI2B9Y5DsOt7gETWjng52dayI15
	WQJcW1BsoMK9joBTl/clXXdCQOWkF94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462059;
	b=IexaCDKeVHiFqOM2zfoidkFQnB3yZs5yoqGoS4HSBlDfGp79Jjj6QOxcH1s8CXwluYwi/l
	/V3OWgnrYp1/ZthWz/f5Q41LiElP3vgx9aIGlQGPR2vkI8xUZF2TAEmMezx3aSCUBvdfmF
	4RzgL7Nh34XErfNmza0WnAOyRMN412w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mC4py+uv;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41CFC43C6C;
	Tue, 11 Aug 2026 15:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065F41F000E9;
	Tue, 11 Aug 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462058;
	bh=CTiS8U5K7y3D0Dlv9kThq0rqgw/f8AQWtxw0lGe/Dc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mC4py+uvPpGye50ncXW6tN5UwwBurfR2YI6g2akn5SfoyucoN96Iuhu+NxGTOrH3o
	 MkqTLLRiH2AM9KlPjaR2x0/fyxoEibIafXOO4O/yk+7kseDcfoaIkc5ywjS76KIh58
	 uTZGsjBx58J2PC81zMZyAa3QR4lsnnkWNkaeafOqjDnExeGsfDgFeg0O0m2o91+zjy
	 TB1TdF8O5kIbuCnLqub754cG/W44hcDiRBfFXlySYmvNGiETfFDzTm3//KQOSCridE
	 jgNVU4iczl3HxAAwk/QzeZhQD+wpVjBU0+izdycJrar7GDIr9osZh/vZGtrcxKAzJR
	 Hkb2FHgVGGr3A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:22 +0200
Subject: [PATCH 01/11] selftests/coredump: discard the right amount after
 the coredump request
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-1-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2068; i=brauner@kernel.org;
 h=from:subject:message-id; bh=9qfTBP7vyCivJLvwjV8igaT+fa50Nmgpl18ZhB0KXys=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2ydMf7Yj5mq10YbIOXkbJ95a9/zScZZbVZry5XOvO
 yzzO73VuqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiArMYGW7aJ8lq/vFdKsUS
 29T9edfMloBLLCp5ugHMK56ferXk0nFGhubEiY8Kd3sz7VsW2vO1z4dNb8lS6azWlYGrFy32vBp
 iygsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: n1ygwa8ih8n78smt3eg9jenrb57p5xt1
X-Rspamd-Queue-Id: F32DC18000F
X-HE-Tag: 1786462058-103469
X-HE-Meta: U2FsdGVkX19tmu0t+W65wE/nROIezGULD2RZx+2nHhkxoDlk/0raILb6swHjudvBVmx62uclO9zGXeHsNyWSMNNImPFn8OQRV0mVDCjAI/Mi6i/QpHxpfRlBdqLtYFBjfnv5wzl7Rs6+r+kCQTU2JfjlKt4DZpkDKXbCbWRsun4PTSCLuHOSKlCck+0mNc2gcnFISyZKT1Zf1HmS/2+MRnMI0ENYdUT7+aMP5GACjtSgFjTHyFPytjTaHv9zLVmkNKOvRrYMMuk4oxbuzXGiroj5YHcc/4nz8VVOGZOmLkS6mBzeq6gvZAhsRPT+6SZ1DmFcR8wN6N4YL6Nf7yVPCq9jW4ww5rHRMUz7ceicLOvgloCfIh2YEWN6EMxqK2/B+enxSdIjXqT7pl2KLGk84keUVATEojzO18vaJoy4NrM5N8iQmDGL5KwK39HL7RXBibtYLbw+kfNKTB08osxD/peGh/0f05JG7aslDm9DpP3Xw5rpmBd9mwAo/eycbiee5fTtJcZPkK9i/pszfqtX5uD2nepezN/bdVvCZKvMA2rHBH2/vHb63h3FEhrqO5OzsTMZN0GgPUFth257Up/WLHuGLDzf5bUQKvNH01z5eufSPvEVzEZlicBS2jYwcoTUxUEdR9UBnqvuCOZAJ9n9sqwcWNnIYwxWqbXxUpEK/CBNJ+ciwW9NaBrYqCVFTwdCPt8Vk2eKH0+ChuSFYpzFpdpksraxdJdBu1tgqnDWxuNQxX8NTMPUvHdQm/eVFmRD6mXGTsEd5GDoNBalkDI81YVDP6tRQz6mh9oBZvEpEE7+x8kw8UkNLKeJBQz/Ra+EQWOC5zEp3bqX+3TwyJ2TqaKp9HxOTsU2NzYFlHRyw+cXPzIsnD9MqlyAG2kEHB8sBWePIPBwEkX+IAWu1WrhMA3CNWMq+JQ4f+4uSuOF9B5ap0Bbz30MarJoESRVDKkNffw8QUW3WdQzj4rAM4v
 7qB3sQiY
 hdwoHhAHcrjR8vUQkfURprgOQjDg737Bhr26+GD0ZpP3ZWRngGMMvuBDWOkEz/GktW0eWaPqISWsY8l+IYyEkNmplsV/ALaasLsZk4E1Ll44OMLzTjbBjb15yPCPgpmN27lxMLQM8oEwKLC4+LTElDXgtNcrqXpS66bEqjG/Q0tFNwqsX1mOBbbqNF0ngRdihETnIDZyHM1po3zHF3ljcPSqmo4zBjyj4235ItEnOODQVNC75XD/6tYIvQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

read_coredump_req() gets the leftover wrong twice.

It takes the absolute difference of the two sizes, so a test binary that
knows a larger struct coredump_req than the kernel sends tries to discard
bytes that were never sent. And it hands recv() sizeof(buffer) instead of
the number of bytes it wants. So MSG_WAITALL waits for a whole page.
Either one blocks until the kernel closes the socket. Which it won't
because it is waiting for the coredump ack...

Its benign today because struct coredump_req hasn't grown. But let's fix
it for the future. Compute the leftover as what the kernel sent beyond
what was consumed.

Fixes: 59cd658eaf40 ("selftests/coredump: add coredump server selftests")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/coredump_test_helpers.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 2a20faf9cb0a..524fa5370593 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -235,10 +235,10 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	fprintf(stderr, "Read coredump request with size %u and mask 0x%llx\n",
 		req->size, (unsigned long long)req->mask);
 
-	if (user_size > kernel_size)
-		remaining_size = user_size - kernel_size;
-	else
+	if (kernel_size > user_size)
 		remaining_size = kernel_size - user_size;
+	else
+		remaining_size = 0;
 
 	if (PAGE_SIZE <= remaining_size)
 		return false;
@@ -250,7 +250,7 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	if (remaining_size) {
 		char buffer[PAGE_SIZE];
 
-		ret = recv(fd, buffer, sizeof(buffer), MSG_WAITALL);
+		ret = recv(fd, buffer, remaining_size, MSG_WAITALL);
 		if (ret != remaining_size)
 			return false;
 		fprintf(stderr, "Discarded %zu bytes of data after coredump request\n", remaining_size);

-- 
2.53.0


