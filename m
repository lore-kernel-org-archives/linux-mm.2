Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825B7CD4F5B
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2766B0005; Tue, 19 May 2026 21:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 852016B0088; Tue, 19 May 2026 21:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741106B008A; Tue, 19 May 2026 21:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE936B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:10:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D006F120886
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:10:25 +0000 (UTC)
X-FDA: 84786017610.28.57EF40A
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC96C100013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:10:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=lym7Bdpl;
	spf=pass (imf14.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.208.178 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779239424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z8CY5okN4WA8PTCFM86KJ9V6OUOBWWwS3raF/IMPnCg=;
	b=kqNrOtczaAv19EWrCQESybEXN/3xNZRCNJgEu78HaJ8B9SBCElVAoguzBTOs/Mfkv0vQ7O
	1riIhhx1SimBa/Ou9K0NejyZt1hNDRQY+TrH7wG3o/ZwfCWuUfFE652MzinZKzrYrYYH3C
	bGkxtrrXz2tPW1FhlLuNwHapjlE96vY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=lym7Bdpl;
	spf=pass (imf14.hostedemail.com: domain of vladimir.zapolskiy@linaro.org designates 209.85.208.178 as permitted sender) smtp.mailfrom=vladimir.zapolskiy@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779239424; a=rsa-sha256;
	cv=none;
	b=3IYFfwRt6rwQ8uRTf7+smVOwXRdRHz98ynmODPursDJSKY/o21KE2hmRYuiUamXNPm5PVg
	ZHOO1y6MmPAC1B1ZzQAmB28/bTI6JkOBm8OjhUjmkklL6/j6zBm+2qqGcUzRT7ZiF1xNRR
	uw4HDkhgQ8lPAQsBNF0slYFiAP8nJnA=
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-393da0280d1so5511591fa.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 18:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1779239422; x=1779844222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z8CY5okN4WA8PTCFM86KJ9V6OUOBWWwS3raF/IMPnCg=;
        b=lym7Bdplcg0ex0d+YDEPHh7TgoPv51jS2Rzf/Nvx40h5o7IPN6sLd2UczjuElUNQtX
         tC/NFFSSrUoDjyLyinaPj2Vjyx+rSWx8xedaG9+NpL3fJgqvURRIrqhvOOZplZ7PoSL5
         Yttjk2RU0//HcCAbRMcvOKnr40UfvHKddpXlFQXqD9Dvi0CQb8tvbxijbs+ujVOlNNye
         csWH739lYynyds1Z2iZr2JbVwpe0h9NNAQro4Wj2sS/8Zm8SkgW0LPJ6Lk+So/qz1RKl
         g9hqIGnY9kfBe5+/j1N4UT/PXAQTryYEkp5c/jIm1vL9p4NnyleQrmg8KdSR1eHASdc7
         Lyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779239422; x=1779844222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8CY5okN4WA8PTCFM86KJ9V6OUOBWWwS3raF/IMPnCg=;
        b=V+0a9P1xvNegoWjZcL5/YTg7vvSy95v0tnoYge+tUd86JfXRBffy0Smzo0w1uSIXjq
         Z2O2ZZYNRy7d6ZiggQ8+YZ4VadiAxmJ/XImSGZ85X5yH44w5U2Xu6YlaDsgjf3PQPPXb
         8Os8QknBzL7KU7I6c1VLasLznLfgpBivb+e5PkvzZf2r0cCVljMWOWxx4/pBLkb86n1K
         PqYhPqwcA8j32uu3BUxcW3g/QufU5AdyG28DwPcL1T3wkpSfrhgi+4VJ/Ghyq/jQStTy
         7FUiUgURXdwXWxoooDUU6qU2DZNDaE/9faJbxhG9xOpoxuBo2m6bNZyhK0OwScYPdUcO
         EKpw==
X-Forwarded-Encrypted: i=1; AFNElJ8nDegTeW4CD6TxI0rIR6LDflBYQ89OITAJ/F8LBqdG5iPVY+pcI/zkpxP6Nmzbl5aRWQBUu7rjvA==@kvack.org
X-Gm-Message-State: AOJu0Yz2E4vB9ASJvxXm0PpxuuU1fH8zcHpcGG1Q9BzImydEyRuCsT9X
	1BKfS0Nsw5lYG4A5E/+UJzR7Q5qoqj1NjqCli0rSp5n/V/an0Z/lAzIvEmaGCSk5w9s=
X-Gm-Gg: Acq92OEGQwNurqRvWhIe612FfFkTWU/fh3ulgCGFqvR4p6eQTcSLGm/DgtnPmr6OqhO
	+EA362wfHn84RZxHiLt5UGuVlOBqBkPdOVE8YLewwaTWsBsqtSZ8Kmsg8mcFnwPZ4HuryBPCkWR
	eI42YMUH9kAM8XU7xtKrkIv4/U6PReZnt+bXoWtkEGtlqVh5qKLgZyvson/mhbPe1goPbZj1p1Y
	zdBryHsycJ1/pWsd4zrycG3KEiZA2Z173e4ojc3iBAbwykuR42ZUAn23OtkTrXHqI/NuUkwHHCs
	hTxp+pe9c4igkB94oG2fAtgI1KGRFTfe4F6CL0d74R6LkDm6HWYw6ipE5mnfIZ438O2K43NnLRH
	YIuw2WGr6U3e7ui0o8hKe1JwdoA4Z8XAWO+iiAsoVyptKxF3ze1zg2EOkD1WHOAdZRDzNJmlqT1
	g3gm1RjDTZ1G6pDviBs4G2iTDVuSlEyb2tsOU9OUmjQYY5KBHJPuoKWzmac8raxo7C2A==
X-Received: by 2002:a05:6512:1249:b0:5a4:a4c:6595 with SMTP id 2adb3069b0e04-5aa0e74584fmr3901637e87.4.1779239421757;
        Tue, 19 May 2026 18:10:21 -0700 (PDT)
Received: from thyme.. (91-159-24-186.elisa-laajakaista.fi. [91.159.24.186])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164cf0a5sm4457297e87.75.2026.05.19.18.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 18:10:21 -0700 (PDT)
From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hugh Dickins <hugh@veritas.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/slab: fix probable issue of dentries registration under /sys/kernel/slab
Date: Wed, 20 May 2026 04:10:19 +0300
Message-ID: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC96C100013
X-Rspam-User: 
X-Stat-Signature: dgqr3oj1ur7f1j5nbrqqkrdkz6bonqnw
X-HE-Tag: 1779239423-465045
X-HE-Meta: U2FsdGVkX191k43VidgZaGhk8uD43zIju+aGEvmOujpis/SRpya6kzyaqthM9wUp237ZsBEYYL5EyJbgfgLR5/ll+3ICeaQQ/OJqRd2K4ms8KjsjLNnl7BQPNHSpPCiG1IZGNOmYkIGUl30Whi2wxjF+IjStG/StFOMIQg2JLZQ6KyOtz2sDX/+DFzq/S03bQY0YxB4oxM67olQV95l5Yklfl9pMT1m885YRknFVT1HnGMQu1Acc7Lx3wfuV33XyJmy52M7KUsRhMh0q/GADjveHmWrUtGM7AKxl14hHx7WY1h/NnGPeysNoVDvkDXk73YLovsTtT/k/SlAF3cIunQs1hMYJ3LRKtm2OqSW9lU1fmCuoE92Fa26pxeycqQdnPZgJGrqiHZRiOm4sRBIJcoSzKjBP0NLd/itFX8veNy8lIjKHFkDXNbJIUrs5xgXV9bNiKBKuNGGBO+F7oHtRr3K96DAdAUB2zdwPQcSuP4NM4aJU0xnOxb1C2cESiMO9ASPRfhRNZfGZOr+H2woiAXobjrSjbprmh5FiWHzmU/kwkP6H2kTTidEQypY1JYAwI80RTSuf6aD1OpYXKdQedVi9aPisacIaxP0FglknLB1phfligu5fKjulAjyWsMWcGC51UHbhK5zWDuQbWI4QHtAtuNUGlXJn2syF5AELtCArxb4Ub4PPR9yGLrBtFMAgeWgq64DjzflWKOsfFGYBvz6W7Jmct/0yFQ66gz4hWHtOTwv9mrEZx7bluu1SI7yYDXXelDBJBUJ5xZ2fNAEQI0Ul2Y1hmONduIWRi/6iscF5PMjJLjqD1XROvfGGI6++rLfJamLjA3iD968oahb5awjsP/d6I4I4qj2GAFnQSI8OjFFmw/tpD4Tw+N/1OnWypeYwmSq0LTBxE4WBjgdBaUwq/0hRveXpLNG67pfiCg2Uyz8EllyyCp/wlr6aDD3E9cnPHf6JytuFCCNoVT5
 2vSfMM4s
 teyhgN7wGDhnsWNBIPZKMAMUggq7Cf9StTGczJMbqBFq7bxoYLVtliTxaorsBcMQ5HbtsiFOFd4wwlFqV0tn/ocz6tvfJenxBZKe/46T4C/667xcgtSfSlMOflQr7VlOkEdvg7ucer4+BOOM9YS9sdjRzciEUmieXY3zjtrjK9UDHoW+vc4OW6B978sqe8MR17vqmoIVCGmT7aafLbi9nc/2IPhxqcdsh7RQgrqeHa2zJ/u05Fcqt5xhKfCz+NNP2UDJynaySTRG/iGH/BtE/w+tSrUuR7pfH0UskTKtGnhaAHRiUtX1apDGoqdpthLIKWUZX9e/2iSUWxQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
names are blindly used as symlinks to slab cache objects registered under
/sys/kernel/slab. This kind of symlink creation is successful, but its
dentry is obviously broken, as well it breaks the access to the list of
/sys/kernel/slab dentries.

Likely L2TP protocol renames cannot be done, since the defined protocol
names are exposed over /proc/net/protocols for years, but the symlink
names can be renamed, because they are yet to be properly created, and
this should be eventually done by this change.

The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.

Fixes: 81819f0fc8285 ("SLUB core")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 mm/slub.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0baa906f39ab..843bed864a7f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9634,6 +9634,7 @@ static struct saved_alias *alias_list;
 int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 {
 	struct saved_alias *al;
+	const char *al_name;
 
 	if (slab_state == FULL) {
 		/*
@@ -9652,8 +9653,27 @@ int sysfs_slab_alias(struct kmem_cache *s, const char *name)
 	if (!al)
 		return -ENOMEM;
 
+	al_name = kstrdup_const(name, GFP_KERNEL);
+	if (!al_name) {
+		kfree(al);
+		return -ENOMEM;
+	}
+
+	if (strchr(al_name, '/')) {
+		char *n;
+
+		n = kstrdup(al_name, GFP_KERNEL);
+		kfree_const(al_name);
+		if (!n) {
+			kfree(al);
+			return -ENOMEM;
+		}
+
+		al_name = strreplace(n, '/', '_');
+	}
+
 	al->s = s;
-	al->name = name;
+	al->name = al_name;
 	al->next = alias_list;
 	alias_list = al;
 	kmsan_unpoison_memory(al, sizeof(*al));
@@ -9691,6 +9711,7 @@ static int __init slab_sysfs_init(void)
 		if (err)
 			pr_err("SLUB: Unable to add boot slab alias %s to sysfs\n",
 			       al->name);
+		kfree_const(al->name);
 		kfree(al);
 	}
 
-- 
2.49.0


