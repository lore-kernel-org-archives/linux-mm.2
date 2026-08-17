Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347AFC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 180CA6B08FC; Mon, 17 Aug 2026 00:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131EC6B08FD; Mon, 17 Aug 2026 00:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047A26B08FE; Mon, 17 Aug 2026 00:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDD746B08FC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:27:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 637831C19DD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:27:33 +0000 (UTC)
X-FDA: 85109477586.21.F120F67
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	by imf02.hostedemail.com (Postfix) with ESMTP id C9DAB80004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:27:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DrlesKlW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786940851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HWFUU58mOoXliMuCOB3IzwmcyXlQjORLkTJKZ0Rz0Ow=;
	b=ej2Y+S0giE7syhOWhui/6+jj0qh51+WkXkkUEErxCRiyUq05W06teLy45NH3b/GLmQduB7
	Uuenexmfbkugbjci5cJqmg8MsZfHWNN8EMquNkC4FIx+iQi7pSeplZsA0XOmn7FcYNWJzC
	su0qxV56mzY9XQT/KQTLUFVMnPNOhHM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DrlesKlW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786940851;
	b=xvvRl3DmrZYxWathhQ/d4vf28UFcXc6NkqHtIpOyno/GWK0qWZPgazQlW5Va2QTGic5/qK
	qEKQh5eDwyPAB6LaZNz/wSCxITtmJ0q/ql5vPzPz1ELX8PLcIb8y+U9vw++3xGD3pcBdZT
	EC/x8xJTKMC2mQgopicPZDyQK8zgwaI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jb1gQEt9X3ic1kv0Ym8M4A7fGjG8QJ0gQBiay9KXRsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786940846; v=1; x=1787545646;
 b=DrlesKlWTJdz66uT5qCLV+umr6CCWKrqlPhCzjxNd6ZMFXMoUWfO1XWKGWLIqpnPD7iot4SC
 +hucySY074tupXTuA62CwJXxfJ7WQb9n5/fo0d4QOR2XuEomNxYdwLOUxgcvCGD7Xv7Ktg5sQzG
 74m8S2ID9e856MYiFQ2l9I/E=
X-Envelope-To: linux-mm@kvack.org
Received: from ctao-book.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 0453194cf996fbf3;
	Mon, 17 Aug 2026 04:27:25 +0000
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] mm: page_counter: reject empty string in page_counter_memparse()
Date: Mon, 17 Aug 2026 12:26:52 +0800
Message-ID: <20260817042652.74136-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9DAB80004
X-Stat-Signature: czq6wn17fq8ps3dmxrwn7cxcjokrn7pg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786940849-292487
X-HE-Meta: U2FsdGVkX1+rstQ3nrvIG4IiymRlkssiOwJnWv7XzaHH/ZaqMW5b3HBxFhStLi2PyLKwqFlV6I9dOznnKwNGAfuTRX+ziJ+k3SszLcdULIW24B0vIT9C0zqhoxM0HG7fZn6VJy1FvjgIAZxmjAnkiUH+2/Dp5OTGDjVOjuywsGRN74QAQ8+UTEqLA2/P1T/n4Ajb1mgJESY0H2vdumZopcd+j+4nkHv3gHwRop2i4qIBmq1W9BekeNQK+lv3lBxcPmR+W3w/YycBdyGcui2/ztTnaIluxhmX0imBXHLVcZ7DwmqjRIrXZh07cm3WS5kG0LKrzOnCTlj1sW8ZBIdH4qvEagZJ7mO/Lm75svaIGJ7EY/rmNMEu6/15uu9VW2qAvFmrAzEn38XZzNsfCnqYm+JQ+6bz31eAv1ODX1kQ/1GM7DBCcnZ4cSq7OS+i4YAN1nLyix2Dse0pkxd7JsDH0wg083kG0DJu/xEaiVOcu4FivoYjgR16Fm7MElrXmvVw/nEOiE+sBkE/8uV9UZAa8ivhETQmjZN9WjeW0a2CAzABG0LYCnsD4hJUUh8wbGYF2RbXzIUIQrc9YddFClujViFsHzCcZQWJplLahRHKm39J302VlKFKs1rK/EzZ26q7mNt15na5APod9a3wQtT05cHv88v2Doyw4CfaC+LCG1hdbYLA6Qd2pDj2khIC3QCZffoIKY7LeHqlGjTYPGM2aKDv2yhh/cihe2eHeFtvhOe+QOlrAqUXSSGEqGjIr1Giuopcn5F1QWW10oYBy6MKpmu3GGw5CCkNnWr6jj1uftE7UZbV3Vnzm97UrWECsG3+sUWaqQm94FwBnSJ965ARH3+N/NnFzzhb7OpZQISfsgIWPVrJ528Udw9oIBQuimBLHbp6k0OeUivBezLhE63d7pUADM3zwYv/hH7WWr/abNGW0f9RNoeyee92u1eBN+a/73JgXdLH/l+CgJTC8W1
 2jPbB+UJ
 HiMWWMfFPKaY9IAQf96YMER5O/RghiDdlWlkyYvp8uQeemr6UpN/3+bF3m6Rsax1jCj0/XqJMVjELVwfCEfnBmDyt8QCX1oSBMcGGnFnHg4WN4yXCWLzT866xfAcHPFjvUqIEVQJtmlOROhigLVlVeqpZDpDgk0a7j8a/xtZ1S4FFQ0n2AGBT8ga0vQM3o/NmWPHB4hSM6laSadKa3qVdB8DIrA4r5kY6g8PbJxKutNyUQKz/Lm0djd++nC7ztuJqiQfww0EuqL4g2/TWMO4GQEFAJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

memparse() consumes no characters on an empty input and leaves the
end pointer at the terminating NUL.  The only validation in
page_counter_memparse() checks for trailing characters, so an empty
input slips through and the limit becomes 0.

All limit write callbacks of the memory controller strstrip() the
input before calling this helper, so a script that writes an unset
variable hits this path:

  LIMIT=
  echo "$LIMIT" > $CG/memory.max
  echo $?
  0
  cat $CG/memory.max
  0

Nothing reports the mistake: the limit is now 0 and the OOM killer
goes after every task in the cgroup.  The same happens for
memory.min, memory.low, memory.high, memory.swap.high,
memory.swap.max and memory.zswap.max, where 0 silently removes the
protection or disables swap and zswap.

Reject the input when no characters were consumed, which is the one
case the trailing-character check cannot catch.

Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 mm/page_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 661e0f2a5127..d14db705b04f 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
 	}
 
 	bytes = memparse(buf, &end);
-	if (*end != '\0')
+	if (*end != '\0' || end == buf)
 		return -EINVAL;
 
 	*nr_pages = min(bytes / PAGE_SIZE, (u64)PAGE_COUNTER_MAX);
-- 
2.43.0


