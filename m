Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0292F433CD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 00:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D356B008A; Wed, 15 Apr 2026 20:22:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DF36B008C; Wed, 15 Apr 2026 20:22:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546DA6B0092; Wed, 15 Apr 2026 20:22:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A5A6B008A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 20:22:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7FE913B587
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:02 +0000 (UTC)
X-FDA: 84662516484.23.5B5E8F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4BE8D1C0006
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:22:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M+HxnG/P";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776298921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DT7v+ZBeibD1+dU+3tKC5Zd3lQbqve/+9li1RJa/8A=;
	b=kDLPbxHKzd7/YBquBXKXgILJpylzwTmodbLJFjU6mq3cKBLWmZxHZdoARgOaEbfgjkPUwP
	xxUHSCfC47oSCL4TQfgRVo9ILuppt2ZRAhlZpzhnxu0p77gjmplTqwgsTWthXaZWISbcvq
	7O+s6eP5avOJETp5yH1rK9sqRoP0WvI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M+HxnG/P";
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776298921; a=rsa-sha256;
	cv=none;
	b=XldchjgXmk+Yye6HEOoAqifpu/CV67mmWYxrvcMQPDhfRJeKovMk830TijufVxRxzheO94
	+r4zeiaGgc06+W9E0iH+SnDo1oZ+a8muHxHHkpe4P1x02200g3oz0VEiXZIr/88+44kl4E
	qCoesmTLrCr9+DFMoASGfp1lv7fEkfk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 743F840847;
	Thu, 16 Apr 2026 00:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C66C2BCB5;
	Thu, 16 Apr 2026 00:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776298920;
	bh=Te4GL7YI2bga7ObPIqHKNdIOFUrcsNxgo3oTxgGUtEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+HxnG/PtziS2/OQojQdij7ltmNZtbdZLFwU1yyphF1qknRPa+InwTfljzaqUKi4Z
	 st7rbLbvE+0Il3LawKY9RMouLrU2brG8I/lyMJrH6sfxYIxlfJb3nmWArHrkiibc8U
	 6GqvXU2B/Kf1yoTbw4g1plUrKH5ZTIRmULaeGpRjmkJFxXK8ijYiHV/If+LCAZ2Knn
	 mjGmtm2YIQWrWhiqvwEN3u0bxiBJuQgC3p/hO6uRwewmOKbTHjN0xCeXahv6iQLPHd
	 UJJgBxniDJgXxy2yj/mE1f78YLgSCQ9DjU5MLUTH0RwEE13qkmdeCnJHCUecGQvKZB
	 aBUz+SFj8alZA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 2/2] Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter
Date: Wed, 15 Apr 2026 17:21:47 -0700
Message-ID: <20260416002149.87090-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416002149.87090-1-sj@kernel.org>
References: <20260416002149.87090-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4BE8D1C0006
X-Stat-Signature: 8zf58hp15aok5t3ke9i3347jk5x9uabq
X-Rspam-User: 
X-HE-Tag: 1776298921-745657
X-HE-Meta: U2FsdGVkX1+9qulGUukgqLk3a62WXb4tX3BWgkc4yHaQ6Y2qUpPfaJK84lISTjrmfLmfl/0GCTKvsTpdReZMgqKCmj44kr6b+W2t69Q6Z6NKLj8S0a9AgGiF/w79wwBSbdTRrWWBdRjzqMhFi73yvlb+f8cTj3CkD9SuUTrcHww7CeOXlKLA738W8Jc8SAFtQW5ekx8gDu079vCDEhznoe73xFmsREmjGTa+2+RD81y7rrniTI9C6QI1dqTgheBbY6bHNHhNg4aPgI15fJSnCy5r/9MGg0L56Z2VurhR9PrHzoV0zxCDS0GhZJqBUTuG5vAsy5uu6zH8zhywKOqMM1CUUvhN2g6zosvY8BovmNhpIG9JlXiaYXl0Ig4spbA0YdJqm+UsidVaslnEhIHdYW2BkpMmRcESWbeBd7dzgy7hm/bbyOy/HvduW1MuLiuEv00EiKl+syzPG4R1avEdG8DqXD7k7Opp0TQNh8CGutTCa/vrfShevzRGMF7oGyQ2LgwRlGAg9qk5Gy9e4DKA465tkx1I16cfMGPkS0iMsn2DHSv+0dqKHh3pUH3jjarIB2YJL1ResS0gqNbq+gT1pHYJLlSL+qkMq5CsV+d+xXOdznFXqF9zbwv748eFWF1xhsH5z292WZGIqe2yek/2Eh0Qy1TV6ogOeB7jLs98/CDjkrg3wttMF9IE77JmkUr3/mWnxqr+g4tP6s3w2Vi2K95ww1IBdi8VS2aK47KZba6Ewg/MNXqfxytNb/gIq9KSwgwxku4xVUCdXhXW6zer5AXoevAHyprVBmEVVCb3/9uzJoYoIaHEzh0e5BcGLjkNcPTDWE1umaqNms5lkGhILN0Ji7Mmbt5RyMZ6cl+DLoMXU8ZCx90MaiCflv/UidwssbuI7HAcfiTYqwUr2Kwjl6lORoj0IGYhyJV3GQV6eELi0I0apoBrWad2H/bLIIJjKjA+Hb7ImIH9dufDMTG
 df8DKhXy
 p8kxeERY4WgBNfQys7xX4S2a3aXdupfhhpxCorHs8nEt0hPyJP7AZVJ05Sn4wHjcZi9LTo4RxgKHwA3ECxnxGEMHTkfG+1ry4EHfDccOwCrlOezgLUquhqqJHVN0AmW8YWgyuHoGqYCyx6fX9c5YCAFk+Ui9fNkllHfvwuDcwzs1oUhXPe1WsMgIWZzkHrVU5Ozv/rIjmr2kLL/6PBfawHeOvuMXUGamhoKnanL8pyJnEyBMes0WeG70gowDA+t5BDcEkXDaY6z9EDJd16hy55esv8oh9mLKXDh1O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON_STAT usage document for newly added kdamond_pid parameter.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index c4b14daeb2dd6..46c5dd96aa2ed 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -89,3 +89,10 @@ percentiles of the idle time values via this read-only parameter.  Reading the
 parameter returns 101 idle time values in milliseconds, separated by comma.
 Each value represents 0-th, 1st, 2nd, 3rd, ..., 99th and 100th percentile idle
 times.
+
+kdamond_pid
+-----------
+
+PID of the DAMON thread.
+
+If DAMON_STAT is enabled, this becomes the PID of the worker thread.  Else, -1.
-- 
2.47.3

