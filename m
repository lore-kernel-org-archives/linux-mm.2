Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FC3C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182776B009E; Mon,  7 Sep 2026 02:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15A4D6B00A0; Mon,  7 Sep 2026 02:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0978F6B00A1; Mon,  7 Sep 2026 02:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB7EB6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:37:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74BBF80694
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:37:04 +0000 (UTC)
X-FDA: 85186008768.11.0DA99CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F40EEC0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:37:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFT32ivH;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788763023;
	b=KalK3p84rkCECMYBKwGan60nRS+Ecs1ABOWPqX1BxaHIp/N/k4PPAxDbiIrtgEsgLqGbqC
	b/tiS0yGac5brMDmeGweS5nTAiIrCLB4VOTCsz+sKy4GtIn01ThIEYmUHdlhS6jVESWs1h
	Lihij+erTmTB2GS2JQCH5RXZcd6axxU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFT32ivH;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788763023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mF0fvVIFm9TJ4XBgHK9DNtihxrTbpRaoDt8xcwKRZQU=;
	b=a1Kz+qgv0Pm82VXhoBQrgtMrZ2S62CZn7/kvWSpTOREs98CK8J3OZX3EhNLA4m74zygMQJ
	WJ+GP7Os1UfH6La6u4PUQPn6KSlxiyPWMoTFzOyfBEjkWVLVCxRtF0LU4HU7Hf1j6L1rNQ
	vXqzIbCZFxa1FkNqiIezdPgzv+O2wTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7036060052;
	Mon,  7 Sep 2026 06:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798071F00A3A;
	Mon,  7 Sep 2026 06:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788763022;
	bh=mF0fvVIFm9TJ4XBgHK9DNtihxrTbpRaoDt8xcwKRZQU=;
	h=From:To:Cc:Subject:Date;
	b=QFT32ivH6l59iIEOyI7y5QXhvovuN8DAeBum5PH3gR/zWRTBFZhGs5BBkVX7xlGJW
	 HOM/w46lvm6n8/iIeCAniimrq0n43jPygMATu0jEP/qduQnNI+cSim0yhUt6xgcLHg
	 f9BZJjXJtwhzhIvwLI7+Oew58ya95lX5zawqIhB3ZTMbXrJfoy8jG5/+rDqWbsZ1/n
	 nQzETlocgkM0IDjVXFu+yssJ/axp7HCcDwECRojprvhXAueeSp/baPB6BSpsxNpiOX
	 lQESHRSG4tGLEdR1YDNWhUwK3TofDdg/RnF1+x9zOcqjWxsOk0TtlMDgs614AvtJPi
	 X+h2VlyIBh5MA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] docs/core-api: memory-allocation: clarify when to use kzalloc_obj and kzalloc
Date: Mon,  7 Sep 2026 09:36:54 +0300
Message-ID: <20260907063654.2248617-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F40EEC0002
X-Stat-Signature: zhyoec8yz8yaf533s4kadeaoersn1k4n
X-Rspam-User: 
X-HE-Tag: 1788763022-47795
X-HE-Meta: U2FsdGVkX18gxchplj67N5csY+b02Kyc8S9k13srSbQfjcsM3Y2IdkBXI2zVwwliatQ7ahlkl4LfKNLdFhbY2NGT8EZHcVF6YP4suftk/CPRzmXL+eUJDenjeRu3e7WWQQQ/WOb4uQoI+yel94sZkJWJPdBLuPiuCJNEdZRsw6zQZeJsp0n2aChblspLnUtq+ryWXYt3zcdd7ZbM+5eGCRsc5BdNJ/SNR1lEtDt/V9a0m//rsdnMSYQzPJ9A6jDdirBkBMnw/vQ8nwxYivXKnTEY2I35PWT6Uz9Zyd+lFYKf7SGQ8BgQkMYAjWYbdU92T+xJrAr/zVeAndzqMpB2aWukQT78SrGX9NmQv2cqUZv8JfB6vccxsquGP9N6sufjnZnEVFAivebSVXClqR5XeiK+1HrMq3jyLTSwetqkVB5RXJIbppaKFn5CPmqJ6LaZJmewP2tN/XODHx8KOmSwEpMUKy/lLDyJHW5uxwuvptZS5VSEwg8tJVtW2JP2Y1+ApDIRggW+GyDy9avUGRSIcnPPXsNhXnf0Vb2RF36cJY5B+Y+rbEV7Vj4uXpjBU9p1vCspWYy51ohcpSaWQ4E2ty11MrVvtPEX5sPU2q1/pNwU7oLQDt0v/AJOfl1nQDka1QY+0GezOnmeVYD6MUcpOAIiq8zSmMNfYVtoJpH3FMbovLlL7z/cvM/vghLqFJbXY7dwhApA3qIsO90h0lfLUX8fgfmrA6bStI7kBLmPF3Nq9zSm2bvfitYwF8M3+V8bPXZ49zkve7IJVdWdEwta2jbzcZ3JqVOoX8THhj7PSwNRmBq/5Gg9BlNbshzqLexW3JatRycozfxCMr6tcvShOfuUZaGvE5v8eLIH+Gqo8cPC/mu+bnapYHES86GZ8isMqolx0zRELlk+MImBxP7sCq13YYjzXgK0FfYwRj2y2fFivb/Ft1uHIAut8nRvie4I5gHsOLCAIAF0wkMLNsE
 e0rWkuZn
 LxCqOx6KLbYktNfzz13t6YKZJTD5qix5L3toVtbGWk2LhTxdz0FfAKCS0IBBdiuKQFuXGwJtp8oT0SIXtNJmBo7+UO1RSaZ0teGktNt0AN6rH4PHFF6qPr/YUQi8ZM9Xm9jYf6xzaXDIi0KdZLeESFxrHkFy4PfwnQ9HJ3g0Y7lDjiVkUQmwihBpN9FYiTAMR4gr7Em0tEcKrOhfkoFHagDQGkBjutQhqUN9Of3Q+Gw7KpGukNpxX5zJoNaixR7v/G72oWQ3TIt0k1t3Arf0EA2zOhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Make it abundantly clear that in the most cases objects should be
allocated with kzalloc_obj() and buffers should be allocated with
kzalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

This applies on top of "docs/core-api: memory-allocation: add
k[mz]alloc_obj() and clarify kmalloc" series

https://lore.kernel.org/all/20260902-docs-memalloc-guide-v2-0-218c1a4dcb80@kernel.org

 Documentation/core-api/memory-allocation.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
index 823f7fa57429b..648222b6c8576 100644
--- a/Documentation/core-api/memory-allocation.rst
+++ b/Documentation/core-api/memory-allocation.rst
@@ -23,12 +23,14 @@ answer, although very likely you should use
 
   kzalloc_obj(<VAR_OR_TYPE>);
 
-or
+if you need memory for an object and
 
 ::
 
   kzalloc(<size>, GFP_KERNEL);
 
+if you need memory for a buffer.
+
 Of course there are cases when other allocation APIs and different GFP
 flags must be used.
 

base-commit: d7dd88ed029164fe0a959e126d0ce18dd3719f89
-- 
2.53.0


