Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7464EFCE42
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02056B0005; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85766B0088; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84946B0089; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7B1E6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:34:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 218121A0659
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:04 +0000 (UTC)
X-FDA: 84509532408.09.4C62A9F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1DCD14000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:34:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=HA6Gqfub;
	spf=pass (imf17.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772656442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqT9WNYz3ZuMaGbrnnkO9KS8167OdxqpYCX1Aav7XuQ=;
	b=Yx6GVahJ7zUuEATQKnb8UiTeTm7z1OQcze3FaituREG/BvzngGUQdBp1eUG9qnkHJUNfQy
	mrZ/Adt+NFhCfW8+XH6QpUWY4bwuB2cvtGqFNMD7vKZxhFNgZEqtfCyt1ftYGBD+XOGYtD
	8jqFzG3csrrVr3sBMa+7sRlQAOQsP7Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=HA6Gqfub;
	spf=pass (imf17.hostedemail.com: domain of gpiccoli@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gpiccoli@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772656442; a=rsa-sha256;
	cv=none;
	b=FNRa5jwyxNbLSdVj3rfMmEZEVBZANh6zMS6PiNJmIhOWwzFCwNKffqBNjEtow6i2hxV+Xi
	q6u41d3dZWZZFbeEzpAywajWt/wpi1p9xIvWO2eZj9kajRQkYZVaqJacEwwdDXboqekTfD
	XwOkMi8BHwZvSMBZMWPutRiojvgzvkg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EqT9WNYz3ZuMaGbrnnkO9KS8167OdxqpYCX1Aav7XuQ=; b=HA6GqfubG6VXpDBQk5CCcRzIMI
	1fwLyYT43MrRyS85hVWtBrTc5jOMD4lxpRQSz0j7ofCuKNQxZ04ZrS6l2RJYFZTneKU+r03ZvkkOc
	i/G5PuZDYrw04tOexmGdl+++rC7Msa6JLArWWSpqGwI9n2iYnAiSbQ6QT4lq5+ll4460beOfthRVn
	NaDteLOEvz4vV7r7em0d4k0Ylyeimv+UVDMdh18guimyPtxVyy70R18oO53iLl0cNhPQ6icfPdwqV
	8EOk8NHqjdgym/ofZR3OI09ktL/gEXBjFlFHofBWI8rM+RZl93RzsMoDpYhtcGykydGyyoiatWwaX
	7DCxyIlQ==;
Received: from [187.90.181.146] (helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vxsut-0095KJ-SD; Wed, 04 Mar 2026 21:34:00 +0100
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To: linux-mm@kvack.org,
	rppt@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH V2 1/2] mm/memblock: Print out errors on reserve_mem parser
Date: Wed,  4 Mar 2026 17:14:10 -0300
Message-ID: <20260304203300.1414286-3-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260304203300.1414286-2-gpiccoli@igalia.com>
References: <20260304203300.1414286-2-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DCD14000A
X-Rspamd-Server: rspam07
X-Stat-Signature: j78x4btpd5y6pz944i98jngh5z866w3r
X-Rspam-User: 
X-HE-Tag: 1772656441-385414
X-HE-Meta: U2FsdGVkX19WE/qj7zoSQ+HgzS5/JS4RtjpE0ZeWxBnXh+uMeefBwJIyHfGm/Nx2gNK545ev8eqA5TiErBNjRdOAkLC8S5Ae31GVt0y4i6loTNaqNBQykfhZORBH2dAYTaYrrDHRPyPL2/shCP4f2LSQAJ5lNGbwtc7PgfO7g2eGEnjN+ALoaOdVGceXJ/aVBOU89myPg+loOwLJAPyowam+myna9cnlC8CSetN7QoXYftCjakwBXdZS3m/NL0sLkMbI81/NTnTaFjbrjzaqqD8wmpVfAkm4ayiTg1zxkgrmVLS04z+RrtemzGH4BheCuL3IWofrZ9LozxRBw9e8Q8utQx2MSTviX6jqg6XkhzcjHEi5lAjQ326cIr1peGzFwYPVLZfrx+MQ6eDbR8vF27svNJLXuea/Io6WUF07la2uCqgQeEuY8g/+RsVOs1gm43eXAmHfTv//cf2fVHMQlkcSx7c5sTEqQ7kfeGIxzFr8ro6F4hdM1Kqs2OwIOdvSmdnaEFnTTY9hmATFbgETWdzzYbc+oL7GcHqCoJIH8OBOC8qhsi5DalMI0EH8XmQOww2rVFa5Qq4XhrqNdHopdDGdiCb/AXuBOZIk7NmUzqP/V09DElwKTHecXnT4iQ6nxbW/U7RgN6tb9hbChcqvufGMQ+sq8JJBbw9G4LJASDGmIHBcYr1s9lXESqwwwveV34G7a3OF/lk3d+9N0QJIcnXsKbBOx5Bc61mh0DPRoJ8HtBrcaE1PHbWAZPo0bgTwYihE1JGzM4/eQQNS0jktndg8/0LPzvzq8e0M7Ml2RzkCtJ0B3hpSfZLPrxfOstBzApEnvLO0/TvFAjaX9kpSAHh/b5dy95Z4fYz/ghUTMfOEOu8SUCgBpA5XPg4ow7PFXK2KU43r4EP/blVRd7Vq0KLUyUjTDn2x7GPRU6E6JuL+TqUxexp9HKBe7XdWrKmBxl/f8agjqGddyE+LU2U
 JkkT3oUR
 KMs12djrxzh1nYFcW9n80jGHOmnIo3wBOI1m3RKgDKXIIFVSUxWtVgSgTn7zy0walBpfgdLzuhX2Yl+7fJmR9v67vSpnZ4Ymfm/FRIlC1MFla9iQdFWDxmMNUAksro4e+JmGmgKWDp17dWkyOPaftWw1Map16RQiB9stccc3tXn9wl7s09u6rgXQcBVzWrqVQztt4KlDVj6ma6oznAIT0Hd3RXHwipJrwyKTW3PhhpNRiXL2CyJQqxwgNhVHBLm/twnxet30Rnxx+8L0dajc4Kg6Y+BsCvcyQjj8Q+8HtHNk5ldQe+qKThT5Wmjb2tTBM5p1IlyOoZtSIvdwYCMNTRgj9StyMxd/5pPj0pU50CqVRf4SwXoQE8Jj7D/pQcQkO9XjC/8ebq/cT5G7HN0NRD2kXIoVemBL+SryIiSU9HcwA+oamskQ6mw/ABYe8LIploQnrYEsMdQvcFaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The parsing of kernel parameter "reserve_mem=" is subject to
multiple failures, like duplicate naming, malformed expression
or even lack of available memory. Right now, all of these fail
silently. Let's add some messages so the kernel log can provide
useful information in case of failures.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


V2: no changes.

 mm/memblock.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)


diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..2d2646f7a120 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2642,23 +2642,25 @@ static int __init reserve_mem(char *p)
 	int len;
 
 	if (!p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Check if there's room for more reserved memory */
-	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES)
+	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES) {
+		pr_err("reserve_mem: no more room for reserved memory\n");
 		return -EBUSY;
+	}
 
 	oldp = p;
 	size = memparse(p, &p);
 	if (!size || p == oldp)
-		return -EINVAL;
+		goto err_param;
 
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	align = memparse(p+1, &p);
 	if (*p != ':')
-		return -EINVAL;
+		goto err_param;
 
 	/*
 	 * memblock_phys_alloc() doesn't like a zero size align,
@@ -2672,7 +2674,7 @@ static int __init reserve_mem(char *p)
 
 	/* name needs to have length but not too big */
 	if (!len || len >= RESERVE_MEM_NAME_SIZE)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure that name has text */
 	for (p = name; *p; p++) {
@@ -2680,11 +2682,13 @@ static int __init reserve_mem(char *p)
 			break;
 	}
 	if (!*p)
-		return -EINVAL;
+		goto err_param;
 
 	/* Make sure the name is not already used */
-	if (reserve_mem_find_by_name(name, &start, &tmp))
+	if (reserve_mem_find_by_name(name, &start, &tmp)) {
+		pr_err("reserve_mem: name \"%s\" was already used\n", name);
 		return -EBUSY;
+	}
 
 	/* Pick previous allocations up from KHO if available */
 	if (reserve_mem_kho_revive(name, size, align))
@@ -2692,12 +2696,18 @@ static int __init reserve_mem(char *p)
 
 	/* TODO: Allocation must be outside of scratch region */
 	start = memblock_phys_alloc(size, align);
-	if (!start)
+	if (!start) {
+		pr_err("reserve_mem: memblock allocation failed\n");
 		return -ENOMEM;
+	}
 
 	reserved_mem_add(start, size, name);
 
 	return 1;
+err_param:
+	pr_err("reserve_mem: empty or malformed parameter\n");
+	return -EINVAL;
+
 }
 __setup("reserve_mem=", reserve_mem);
 
-- 
2.50.1


