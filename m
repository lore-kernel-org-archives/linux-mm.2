Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D73610987A2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7E16B0114; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5B766B0117; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948026B0118; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 827EA6B0114
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:06:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EAB71402BA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:21 +0000 (UTC)
X-FDA: 84566918562.06.E438018
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B7E81A0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:06:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hit2PAW4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ombbguqSvsfcR5OKrmWvTSB0hfi9HSgAPvcR9juCuJM=;
	b=8IsDYsyRwJNDLUGkd4XI/b9y8wi5b1ASqzLSK2++8NF9P1OIXMYCeDXjFTJ9JBiB3/wf33
	4U1v/8jkH96njZaV1Qqfg+cl8vnLnQ2hiw8US8CPPsLwux4DtXuUTMbR5izMayIIt5MeVV
	fPY5o5gZoyH66/P2PJdL20NURtvyJ1k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Hit2PAW4;
	spf=none (imf19.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022779; a=rsa-sha256;
	cv=none;
	b=qfdvAl90OGbVfjFXyl5CCnTrsyCGJB9pYh7Dzyxx6GNAE66PYRUzK6tIiEkaK+rQWajqpY
	49lI1wcnJQaT+6brSEFGgwDzVM1VhtTGiBospQjEJKeRXB3G+9+yVEPsvpKA+G5II2Bk63
	LULr67Q4cnLGK0iji7SR2jToRgyn5gg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ombbguqSvsfcR5OKrmWvTSB0hfi9HSgAPvcR9juCuJM=; b=Hit2PAW4bWRcnfyMj+KBd3J3Y7
	cBS0JPcI5wvp9SPveLc2jS2h+qtQmoUwJ+B0sSq5zcH0Bf1pTZM8bYZ4Ug2qrVQaGR4SV6cvxokHB
	6KlLnqQ7TawSCxu8vEcY89wVI1CUvTFkDhfP2W7UjqJv+XptTOw22WPkOG7xy1e5v9ZlH6ZIEIhMz
	d6jfXC2QB9GfesOM/PJGbHHX87WoEnrRBIpF1g8NAb1EIjtNISnO7T7EzpbABghfg+Vggsy1TGY+Q
	5s5fkr9bZZ+U2oFRbYdlGk/jSsiqRlYal9ZQOrmzeac3mlDP9m1lQI3oINMRUc7a93wYn4DvCwS2x
	OK6e18tg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w3cMV-005Jzr-Kg; Fri, 20 Mar 2026 16:06:10 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 20 Mar 2026 09:05:25 -0700
Subject: [PATCH 2/2] mm: huge_memory: refactor defrag_show() to use
 defrag_flags[]
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-thp_defrag-v1-2-6ab15d0d26eb@debian.org>
References: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
In-Reply-To: <20260320-thp_defrag-v1-0-6ab15d0d26eb@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2220; i=leitao@debian.org;
 h=from:subject:message-id; bh=aX2KZFfA6pIuDllYR3DsQuJaEqcSVBTbVhZiGsWJiI4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpvXBk9E2fUD00Vce2QBU6GuX4J62Eq6BFDDOHL
 5X6QDyvdKCJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCab1wZAAKCRA1o5Of/Hh3
 bV8QD/91JXc3u4ePzddbbBYgTnNz4d2VOubxMgFrQPPs35sD9wLqLd/bsAAJoZ6zR9dMBwsK+9n
 ruvuym3dnoNNM5uqrIDKKpfglnJadueJzo7VGP+uN9dw6GEXSOnOHk7YTGjqLcUlgOeH6cjxo0z
 LGKU8kUO/Jdcg5iOXUzHfOy4tWGCM69PWwlb624I/8WhUat1sYLM99fM6HsvpHdjmp8zmi4rCPT
 zsED7jXvc44bm7K+pwTjVtX7E97Dcbxcgrh1yMMa6/KgGHbbgR10V92km8+RySKV6zTGeqZwvOX
 WAs9GG/umKvpTdecpRiYX/n2fguJz9kc3nUkcabw27ge/YDsLLj0ADoXTtqOJq4E7hLDuUEVWg3
 2sn4zF2yFDh/FP7ZCcMA24OPtAOyLD+VJNQNpTN5pPCFduluxQ9bs/0eXOf3fVt8hXUQmbwxXZ6
 EPF3PIU0WqpLGRU4eK42CpdmSDZxyxI1aalXaf4CZuKAB2tqWp3tOPAeIhywYZvt2rY6QVG2jmd
 Ad4SiYa7OFzxyRlYQjqsEYbSFyo9LekbA05HOgREQncWhL1qSd3P24kx6gobC7oJYK2J7SMBwYd
 GaGUPo65wZsgtht2QlkNTnjqwhCwwDORC2hQUusyLkE3sGAYuUzspu1i5qOu60djzhGlzJFGTPR
 Pr696ULtNhxyO+A==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: maq5dotnc85an4sf33dm4g5u7rb5uy68
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B7E81A0010
X-HE-Tag: 1774022779-452209
X-HE-Meta: U2FsdGVkX1+Z1Bzjgjdu4pW1+a+gvfRZqwozMoR2tAaZFWVXBgqBwKdmN1TCcqQkj9jha8Qx77CWxrSy+i/xsYQBkRVnnSob9cvN0raM0zCoMO6rHA+om/avvkOTR19z4W0VFRcURS5WVP/oMAbnWFuWiWE2fXxc9e1XjQuHszg5n9NYlFE8qDtlRBgtis7GbP7Z3rENYuouYv1BTQ2V/e5jwwA+5mG/H/HtCr9C+YiEWtc/C49MSCuQaBkjVeZdLI99ctyt6W3X2BSasXJy9FER8ZA7rHg5viKGSDHr7t6GDd4J22DvI0Qi0DZ1+GsYY6u9QTPSZrPWoPqiVVRKf0/plQTkxHY5w5VumMt2rL2LBo+2vjTJlOgZO9vM0xC7JOQk2N1otD4/3EH0yDzgJDMymKI0RlhXIZZNOMRi+55pluPggudNe+3IHzEDSTuFiLOJB7Fn0G+CV2uQ7SXPQ6yIq9SkrQHtJsSYep9R8bVOY1bwMUxKCOF4GP+9fsLbRlou0bDqjRaZ0Rhh2XY+wQJBTG6PRXIcSS2TUYuTzcR4GA8r7R4T3JU308Ch5dE+LRQZ2J3bIAbnecH8/hlj0BWysHpiWo9RsgMX/9q5/e8zfJ/SoLzSxU30FIW1lSNspvOIi9ebjAUP+6C0GU+Nu5wteIGsAjUgOH8Kg9QKFUfOEX+XQ73uYe8EdlXCjM5TJNKQOzQbEU0SxjrLemKxEJ+n4k+rbQKonrT2LsKdUi2QpruEFe0Jc3BPKLPwYBPM27QYxpMWLXxFBgVp+CzMq9Ho/SmCBICJii+gTRwmrJvOrBERzJXFpqyipoqkpcT0iLBQ/vF9KMynn9yNonyLgVL1eO5Ir+Ocyf99tdHbTzQNL7z9kMPkS8YLjU3i9AlFq9EFMfzTpeR6QFi1GP9wOOefnFzdy4KoJ/ysy2mhbVdWQYLYYJ1u72wzoKkpitIXviPGFBpPf3qh50HhVu3
 jTWe0GXW
 evStupmb0z60oa52rV/NuzK3L7Xj/TfrVdajtgpkT6bgtz4l6oMP3MMn2EsqURH358RyTOcdLQRwt1U8LgmggeMxMZK3Z3Ouay2Uny9aV00o+gypZEfd8Wv67KXST4T+zznd2lNCeAbEPy4yP0IxAG0O1PqCecjXFxtnAhsZUMqhpoH8u9UyW6X6PCRc7ikx2Nf7k6VqeB1vXPwY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the hardcoded if/else chain of test_bit() calls and string
literals in defrag_show() with a loop over defrag_flags[] and
defrag_mode_strings[] arrays introduced in the previous commit.

This makes defrag_show() consistent with defrag_store() and eliminates
the duplicated mode name strings.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4843e2154038f..eaa6623fa49e2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -447,24 +447,30 @@ static const enum transparent_hugepage_flag defrag_flags[] = {
 static ssize_t defrag_show(struct kobject *kobj,
 			   struct kobj_attribute *attr, char *buf)
 {
-	const char *output;
+	int active = DEFRAG_NEVER;
+	int len = 0;
+	int i;
 
-	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG,
-		     &transparent_hugepage_flags))
-		output = "[always] defer defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always [defer] defer+madvise madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer [defer+madvise] madvise never";
-	else if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
-			  &transparent_hugepage_flags))
-		output = "always defer defer+madvise [madvise] never";
-	else
-		output = "always defer defer+madvise madvise [never]";
+	for (i = 0; i < ARRAY_SIZE(defrag_flags); i++) {
+		if (test_bit(defrag_flags[i], &transparent_hugepage_flags)) {
+			active = i;
+			break;
+		}
+	}
 
-	return sysfs_emit(buf, "%s\n", output);
+	for (i = 0; i < ARRAY_SIZE(defrag_mode_strings); i++) {
+		if (i == active)
+			len += sysfs_emit_at(buf, len, "[%s] ",
+					     defrag_mode_strings[i]);
+		else
+			len += sysfs_emit_at(buf, len, "%s ",
+					     defrag_mode_strings[i]);
+	}
+
+	/* Replace trailing space with newline */
+	buf[len - 1] = '\n';
+
+	return len;
 }
 
 static ssize_t defrag_store(struct kobject *kobj,

-- 
2.52.0


