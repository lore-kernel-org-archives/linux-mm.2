Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58634C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086286B0096; Mon, 13 Jul 2026 07:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0104A6B009D; Mon, 13 Jul 2026 07:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DE56B009F; Mon, 13 Jul 2026 07:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC266B0096
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:48:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3CD434010B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:48 +0000 (UTC)
X-FDA: 84983581536.27.F89A744
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 70B281C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:48:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b8FGLVCJ;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783943326;
	b=XYxxcky97DkAq+ifDVJotkzMv9VARCOyO5mwi0uy+l0qhPky4Kczd+cBHZTjvQz87J1nqN
	JN7PZQw5AXDaNtN4Wn+TjXRcHc19i8DbNawe8joNYjYHlsbhg7Qkk4YuTxIbB66dS/vFg4
	0gaVr6Y/1/T1gluYBCvzY7p2rcElfSE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=b8FGLVCJ;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783943326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XFSQUx8TCZyAA/EWJdMDpeVC+kFXZt9qXST9blJikws=;
	b=CU1j2hD1y2P3z1R9ul+b6QfEmsMNua5NZB4GQ+jPUsU5WVmbpmwKELUojazgldAyqhfdJA
	Q4xw8pHfjaESGiv18bHnbHQCb0+TRh+CRpReIte9cDTvXtcRzJs9spDaWa3yEAV1CBELmE
	dymEdPymN90X25RB3QF15juoLdNNr4A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=XFSQUx8TCZyAA/EWJdMDpeVC+kFXZt9qXST9blJikws=; b=b8FGLVCJ2eKvCoKVZHHQKvWQHF
	MVLYqoWxGVp02+HcmJfS3idd/2A0b3yUUxp0ooxKtpVaQRe4nCXBBBFeQHuWUVqRaMYEvOizMDxG9
	2J+USEj/5SZNlDUZAfYY44XDdPOHEV/U38/WfYN9xVCpRJgl8BQP2RmdNqt3YohAS/hBSy5YwSMl2
	zKzQtn2VLd+RWtzTDKl1ITOqUUPmEL87SuUwMhrB0XKcixNSp6Bc7OBDDnEyt5YAXcy8DCimL9NlB
	VnCxT8dNVkenBHebr5dLp7nvTNFJxt8NO/qAdVVp3oP8bUknz7ACwL7jmIJc+VN1rI2vquQJ93ihb
	Y6QC6xaw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wjF9M-001TjD-0n;
	Mon, 13 Jul 2026 11:48:40 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Jul 2026 04:48:06 -0700
Subject: [PATCH 3/4] mm: kmemleak: factor leak confirmation into a helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-catalin_pto-v1-3-5b93b1131089@debian.org>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
In-Reply-To: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2095; i=leitao@debian.org;
 h=from:subject:message-id; bh=k5syoIA9ysnV4wrEyuCwDG5+YSh/+ARvdAvSvQ1nHGE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqVNCDS3n2w9ikiBluKn3vjF/Zn4wkchKX7fc89
 7Nrft+gaBSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalTQgwAKCRA1o5Of/Hh3
 bbCID/wKUKccUQxdsMVZO1R4Q7HhjfNs9AH2FcscwKsWjIPGbXxfqVrrLXVMlYkLmFnxT5C8wLp
 EvwBeNeklecRZlmsQEAG4SvVFaTUIYFbpOpW0rRrFfhCU5K6w3FWOsb6TGBKAxA6FFyLf+7LbGe
 gBjdJZlYQt14eBFnTWqofAttBeVdQvUzOkbJ4wqSlvRgUWnL1zpSFdNHSImQF/zaMbNwmYwG8Vb
 Lvi3FcYhlwkjH0lI+Y/z31xmqQmNd2R/Ci8ddMtfu/kxgseY8cLbeM6WzAo2pQ4Ga5T0gr3bJo3
 o4BieTxQdMSHE6YYDnGpns5aNHshdebQyRatmVq9WTz62xsvEVrQ5oxUPTGcIIgNpn61ijsyH8d
 n78QcKFX/elGtBxP0bYjQxiynlpb8pwXI6i4IlU5B69Y3PKQi27na84Su57z/BSnOqCQgRi0zsF
 YRzOWBQCrvNG6NoQjHZ3LFoeDZgE6Dfz/O2K1kqDJMBmvvuggpULbNjjSwb+79+2V3u+YOIb3Oh
 fUcW7n3ULWCZL7NWyg8YoxQ5ewc95SfJjI8neE17OsSBB9Tq59FXfEFk4Z43+QYF8+rWqk90OiQ
 tiuXyJ95Chv+1WhyyT246ylon36UWQy+w6/wI33/53rpYpnnkrKoVtuAp8od2HKQcF7kPjFO1rK
 XKTq4QzgpdQCq7Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 70B281C0005
X-Stat-Signature: wpz6dpjk1pwfdzyafdwypjyjzyd9y3sg
X-HE-Tag: 1783943326-218009
X-HE-Meta: U2FsdGVkX1/0PWfN2g+iCwd3JSaGiAzSOvMwa36tGMrQ+ze+nzmBY0jrMcGjXY+F6lYGBiigNR9GMxnlNJjZAlRg3AEzFHjz26/bPcPUa3v7vPofYHAufKvLoTjTdjXPza33M/rjzqgzjhoJ7n6PAO22IMMtPPk0q3YgRrsWK0iGI+yps1fX6Y4Yp5iu9TzpgYi/garkGbFXKXDC6dpPuTv+2g+tIUy1eJJJTA+QsBRfgWaMjqHFQ6T11T3w3WjTTjQ1ZCLwg6qsMpjqquRNbkFodtVES8PsG6Oz5MefGmaf4JYIEdhlyxI+DZ+OhHqSEojJ8cA8GQHDBNgykWMdOpm79mWCAiUg+QOgoDia3xu+jOfoJNcGezT5qkJ/8y5A1ESi03SHQVRxVCWnxZNQg6OiIUKiA+frV/p9SpBR+7mabx1trMBjqtGwwQaxx38HPBcfdh0Gw72CkEtWPVsZnf8lQXk6IE6cWfzrpiAyZx7Mo29yIurlaU9vglyqiYRY3j7gA9ApI3qRUBMoHGgGa7k8IK0O+1Pa5iZaZQ8v6rMie50+NJ+jFy9sI2rRX4BPg+8H0cKQJQQo0NFQdq9ZlTtEYD9waj+EEgEjWEdm3Wh1KPjxcCYWN6xCbTccaSGZE451eyRF28RH5CGKZ0awIr5gs+0YYPI+NQMqK93ya+MUSkb7ue5QCjik6kYohFl4WOSWt7V+713qZzkWAxWRPch5nZwhaxb+nrB1ICC9suvvJ/rQXxFkaz2r7ER7QFWDChGW3RWAzzaYkG1fyiobBQlLeiHaUwHQSWsZ8tnz9mbXAgKXfyc99wB7Jj4vuq69jkKY7BJtnW4+kqh2LKhJo9bIuaOR/mezuyBdd5ZdlhLfDHlpXc8HoP3eFEwHvSCY2LGod7TMiqgFXJWMy984vt8ILRlgdI0/SAGY/w9Qvr8sz4n59nbzBK2OZdt7j2apL6ECm0vovmxr8xSYd/R
 l196JPwH
 GEUoVBPaoWU9UOK8MHysKNSpAVUSWZmj973Vb+E+vOBr3O4Y9XnT9mAwgWacjNKxQWBIrr1vf2LfNc+UaodcaENpAQze6+CMUfyGCWN9AqTcwMrySePeu1O0F2OvEMNyCD3oVe5kFr1lCsKbGqZLmbbpJI6+ZXQ6EdWpwApoQpgAj7asMcQoVn5oCqCcVz3R7m4ngs3t6v9WzwkquGio2rf30l83J4F93rAf+jIaQhrL7Le2mRNpgLk0/ms6tzlXaS7r3dj5RNLwUQo7Y+53bdMmquc0uAiCBgPp2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The reporting loop in kmemleak_scan() decided whether to tag an object as
a reported leak with a four-term compound condition whose last operand
also had a side effect (++object->unref_scans). Mixing the candidate
tests with the counter update made the check hard to read.

Move the state transition into confirm_leak(): it returns true when a
still-unreferenced suspect crosses min_unref_scans consecutive scans and
is newly flagged OBJECT_REPORTED, leaving only the reporting bookkeeping
in the caller. No functional change.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2fff11637e490..85f18b17e79c4 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -2014,6 +2014,26 @@ static int __kmemleak_scan(bool full)
 	return nr_suspects;
 }
 
+/*
+ * Promote a suspected object to a reported leak once it has stayed
+ * unreferenced for min_unref_scans consecutive scans. Called with
+ * object->lock held; returns true when the object is newly reported.
+ */
+static bool confirm_leak(struct kmemleak_object *object)
+{
+	if (!unreferenced_object(object) ||
+	    !(object->flags & OBJECT_SUSPECT) ||
+	    (object->flags & OBJECT_REPORTED))
+		return false;
+
+	object->unref_scans += 1;
+	if (object->unref_scans < min_unref_scans)
+		return false;
+
+	object->flags |= OBJECT_REPORTED;
+	return true;
+}
+
 /*
  * Scan the memory and report the unreferenced objects as leaks. Must be
  * called with the scan_mutex held.
@@ -2074,11 +2094,7 @@ static void kmemleak_scan(void)
 		trace_handle = 0;
 		dedup_print = false;
 
-		if (unreferenced_object(object) &&
-		    (object->flags & OBJECT_SUSPECT) &&
-		    !(object->flags & OBJECT_REPORTED) &&
-		    ++object->unref_scans >= min_unref_scans) {
-			object->flags |= OBJECT_REPORTED;
+		if (confirm_leak(object)) {
 			if (kmemleak_verbose) {
 				trace_handle = object->trace_handle;
 				dedup_print = true;

-- 
2.53.0-Meta


