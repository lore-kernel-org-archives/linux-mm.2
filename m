Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA28C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D646B0875; Sun, 16 Aug 2026 18:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25086B0877; Sun, 16 Aug 2026 18:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AB86B0878; Sun, 16 Aug 2026 18:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD7AD6B0875
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3745E1C197E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:01 +0000 (UTC)
X-FDA: 85108619442.07.424C90B
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf29.hostedemail.com (Postfix) with ESMTP id 59267120003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d 7WK9YC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GJUIGH96;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mo9/YyuZ+27uiSkLEdlk6rzsMwO0ifUZXBUSyhK0NkI=;
	b=o9DcUSQubGseRPF39fN9msP92eTbu7DcuRomRalrb1o9axELZO7c8+mSYSYsRTLMKsBWy/
	8JjDPeOlWLc6bTSvzFLh2q3JwQBH9CrB1vPPzM2DVhn9NtSnYRGYEB12YdLhHmB/LRptCS
	au0qETqDQyCc44sJnc+L4hJJqI4BR6E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920419;
	b=HbakwnTxHovEvF1nPNQlYHSjYTzw7qIyx+Jw6USQacZ5cR8KCRQGQvLt2Eo5g3EeFgpUGh
	X9VXvbFPRYhURmX46DPZqiXb1Qhiy7+6HA3mhi+Ni2td0Z0cwDvF3qeEvuJQWxJVMKRxh2
	v4J9GPxSih2Yh/pum3uAvXRAkSwjZ+k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="d 7WK9YC";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=GJUIGH96;
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id EF0B3EC0242;
	Sun, 16 Aug 2026 18:46:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Sun, 16 Aug 2026 18:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920418; x=
	1787006818; bh=mo9/YyuZ+27uiSkLEdlk6rzsMwO0ifUZXBUSyhK0NkI=; b=d
	7WK9YCRZJRHPwU0pAQUS10+wHOnpDVzzsLoMHT4KYOSJTernWLvI5zEDM0UkfP6l
	sDfoB0P4LSOIrmvVWaMZU5WgPwdOZ26zGOGxOQnDXF7zH9//nENd0dCVsng3FqEi
	OfNRivgTRghzdRb6B7imJ3QTM3oow78pgAp7RWFlnqlPDWREvgcw7lTuNGFIMucN
	HHliw5wwSFtsS8pIfixDSCSHfsp2yV+7TtjaDqxBOCz9kYofyi62Najmtyg7aEcI
	FSR1kV7BgaHkM7t0KShfBPl5TJt3QZi4a4CzjmLD/tozU/ZJZUyg8b/oNakVgcKt
	9arG4B0r60J5KjF9IK80g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920418; x=1787006818; bh=m
	o9/YyuZ+27uiSkLEdlk6rzsMwO0ifUZXBUSyhK0NkI=; b=GJUIGH96wLw4Ae4b/
	KotBYngP01kE9QSEmFZ40LRhjCHLB0RR2+4JbCP2BK0l/nh2BSKndFsJe3TmuVr/
	Uvk1WU/Z8DtRr0wK4C0ws33aKKox37XCxk05NgPvaKBYWbrmrDtzPktez79HbNmi
	JHctxjj5epxyWTBslwvYTB7Ti9pz2NQHCXgz9OYdXjGXA+aTU8TsreCpgNHaMWK5
	LTznPv6P4TCcJjocAe0tKvz25zwiJRIW6II/5pxqD06ZMfbFHk5GatQ2wvvlCz5S
	qXRwGf68w9y0T4WgtoHJxrkkgdWtZuIOOEzoHb92rsS9hg/YC+ZdTZWQ4m4J5+Zn
	ahRpQ==
X-ME-Sender: <xms:4j2CanQqScaubasMLkTsysJw-SK7UfwGJd7eoSwFYVX2L5_o5AmVvQ>
    <xme:4j2CauGArq4GUP4XjGMM3XggInpA_aUCDPkf74NbM9pfE8qYwzYpN1LvtPDUInE5K
    N-9XRxVWBWMMee-iU-K1pINfPFkr3SZKV9WI7KAhtlTE18MuweGkgJu>
X-ME-Received: <xmr:4j2Cao79UHKeyM1kBRBZ3tKSjAYqTy2tTxq6UKqARBtFB5dVCRDwDg7FGfY>
X-ME-Proxy-Cause: dmFkZTFkhNC7YI+Ei0MrF6zu90W9yR7z714JmmtstcBEn9fnZ0JEx8KxNru7XjOIPijUAd
    VrNDumTIvQCtLJHAbrPKMRdbJsCYKY1AWxa28xNEDdkQaDqy3PIOJVA9R+OjsTN2M4dnB4
    WQk97ejO2lmWwXR5mw6146Dl5x2vSRCf1uehpA4Z3DNP/uvzS8DmGwE+/LsFmt9BQO6ZtJ
    eWd0dPZ2F0WrWW1tiYo0zV8d4Xgh8ztMbcUaDgwCK69ZeQi0ebesOWu50OSj19NNGHzec3
    w5R1etyOsXXy4NxsI/YxbKwNbzdBv+aWoLN5/PFLP+n740pr735uP0KJxEPqjezkxGUEYw
    zcznv5swWAyw6XmESrxIGM8A1bTTyyCb8TGgw+qEShLJxmw0H1QgFlfOeuxPMpjGoxHDtp
    PCjigTxTQQ2SQYH+g1Zjow5z90rNIRRpTNdfes5gZJF781hKtVjYAOe4if7ktPzJJA4yNg
    SoS74FodWm5MlganZ52ThBjBAI0zsQCzKw1kMNWmaHUySWEGqzr+6R499T3SjVD8uPcKN/
    4SLidXdUPP7GCHgXfbqC5pStWuEVCtQYOB96tZz4WWjhPZl2k+r4upntklA4ZEhZgnxts8
    Lxz66rlvmgByz0pVLkrls4qWwn+V7sbwBmY/Z6EOmYn3bFnzh2lepzJSEjtg
X-ME-Proxy: <xmx:4j2CajlsvjAN_IEHAIV1kdp5qFXcSIkYNgoGFY8LAx7-GMiLIVyIkA>
    <xmx:4j2CamyLPAh9iniFOlqmrcrm1VGdAlLtldJw-Q25y0HYU9VT0elSKg>
    <xmx:4j2CalODmyYrz0w_UYvd--3ZMZ88iSP2eG9dXy7GQuMAp6S8f0v36g>
    <xmx:4j2CagjRf48cFh8tnR00-qMgeKzkwFPTMv9-xyTkeoMwOiCkBud3zg>
    <xmx:4j2Cat0OGWz64CT28dddn965QWPo0PjRSa2NkonwE7g1N9uko2NxaYeC>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:58 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 21/57] mm/collapse: settle whatever the round reached
Date: Sun, 16 Aug 2026 23:45:33 +0100
Message-ID: <20260816224609.308019-22-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: id8taqdifp19urohcyx8ah88td9jd7jm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59267120003
X-HE-Tag: 1786920419-175625
X-HE-Meta: U2FsdGVkX1/W4/OpP6/wmQbgymgJJFXltXrvysKhm/OKWCVVmgn4rLqTdruk3n1SNo/ecKFjfCtYBfLgYJzFLK2OtROPFQ+/9qzEUxFUXrnuaPnAZJkOIiTDIMl5RXEn12+mU/HRnN+DgIwXwrwWQ4o/ZUMVArj5mNXDxqPZvPzgDEk99+u/MRTXBdEIrCxkzvJAp/2OXAv9eBsm/LgTVHsfKtcs3bluYIkuOq6dRUp0HZpocbTXk7xViGS81rNBI9Z2uR/pvvCJr3N3yKyoIc6jLZyadA20uJX/9g93JJjmk5BmZ89HsMwPqYccKBe1h1+8vumkCnGqlWpkrV9sJoYN4Jxj8MtbOcIetIHde+yC1karRktQ8464GmL5PEpz91i9DoZTclGW5Wx6MyO2zuH1rwdNIAi3/0cRr4cH3mikAV4mFBvmxKSmnpN0QoGhtmuOdyRxo8phFeazOQTbcO4o4YOELF3CSbXdUEvQqXGPUXeHl+qDJ373xTF1gNJ54x2ujo4V/kFUksu1/1xgVGDlG+Vayn9ZvaW4Jj6TZn3axLhf3bXX+pnM/Ob0j9v+00aD1iBMsnqI70X6/vQXmTNMlMO8DUR0PZrEDLM8KwCObVlbdXj1wSLeNYSA+ricydRCaalUc0JHob/N1pWvj/a5el1nbLrlUGPf0jKlTt7D+pssTw9BL5CHEZ1S+iSshMPZS7JlWktqKBoh7JpVrKpGZc+oZ9dqxcjM/s8/ODLO+SXxWkCQy0yBM16Ga+7wf9d9Km9OE7XXNnONuhVgv2Apkr+5ATo+zA/8ASDsN6DOPGtV4C8QQQRmcnQxf4l+NaSsbR6yLDZJ1LCKsZoms5zfz1VTXSHY+f/FzAUpthc+sEnmsNiCJNQdbPhiTcKyTTSjzGVdKj2I3F/ZnZ66c/fEh3Ii5QSrvjDId1OW/TlnqdB3eAR4j8uDJ3/Tv/kGnu/H+658IM/pNEnUpra
 s1z7hWr5
 kp5oBhYA0+Tl+UWgx0kUyv/s65ex23qKT1UtLgohSoZMoxwuH5k0Uq6tVNI/F5GsX5hO0BurwYlYeQgTMKLfqLl2pE3b1rFovqrbfSYYWp9HFPm3yti6n9d26UUGAfyH7ImJrhDkg7B41xAIBPfEoznWz6lk1KdXsgxwYtzIjF3b2SeNHJ+I9M5KwKVXwtsH/pq0yq5+59fOEKT4F/MYWgjhNgDO1DWRwwgqDXp5SOOomHkIVkppQUV80xrjbXNSjcuXtFJPlwG1QrrXNNPlXALZX9VMYBuyFdKliHMgZOEoQ4UQYA+j/qfozvA01zeOoVV/EpHt2JcIKDhnyWOw/ZxKqtbWUhaTS1DtA4aFdGpexN0ZB9RxXtZEvsNWfehXbldR5UVGfeszwhWXOO0vfY6y29Nh6PaHQgvq7DwYYalmI5KnwPH7OEQT0XiF4QvQklrZE2XEW/hbFCOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the last pass.  A candidate that never froze is recorded as given
up on, with whatever result ended the round.  Anything no pass took
ownership of -- a destination folio, a table meant for deposit -- goes
back.  The count of installed candidates is what the round reports.

Holding no lock here is the point.  Every refusal before this happens
under a page-table lock: the freeze unwinds under the ptl it took, and
the install aborts under that ptl or the pmd lock.

Dropping the last reference to a folio, and the memcg uncharge behind it,
is not spinlock work.  So a refused candidate keeps its folio and its
table until the round is over, and this is where they are released.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/collapse.c b/mm/collapse.c
index f65f413339bf..2da1f8ddcca8 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1500,7 +1500,30 @@ static unsigned int collapse_finish(struct mm_struct *mm,
 				    struct collapse_control *cc,
 				    enum scan_result result)
 {
-	return 0;
+	unsigned int i, nr_installed = 0;
+
+	for (i = 0; i < cc->nr_candidates; i++) {
+		struct collapse_candidate *cand = &cc->candidates[i];
+
+		/* Never froze: the round gave up before it got that far */
+		if (cand->state == CAND_SELECTED) {
+			cand->state = CAND_SKIPPED;
+			cand->result = result;
+		}
+
+		if (cand->new_folio) {
+			folio_put(cand->new_folio);
+			cand->new_folio = NULL;
+		}
+		if (cand->deposit) {
+			pte_free(mm, cand->deposit);
+			cand->deposit = NULL;
+		}
+		if (cand->state == CAND_INSTALLED)
+			nr_installed++;
+	}
+
+	return nr_installed;
 }
 
 /*
-- 
2.54.0


