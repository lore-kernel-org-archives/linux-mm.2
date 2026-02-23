Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F18DE98DF3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D636B008A; Mon, 23 Feb 2026 02:34:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F146B008C; Mon, 23 Feb 2026 02:34:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F196B0092; Mon, 23 Feb 2026 02:34:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9CC6B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:34:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A5F11A0844
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:29 +0000 (UTC)
X-FDA: 84474908658.09.294A258
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A860C0007
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:34:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o1ClLGdu;
	spf=pass (imf22.hostedemail.com: domain of 3AgOcaQsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3AgOcaQsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771832067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4IDTTN2imEE24tZz4W9ct9niFiZM+M1v4/EEqKS/dA=;
	b=IBJotCDHgWMSDjDS8Yu7MKcAw2w4jqM/ARdO7je6GrKFfpUzeTqP1oDrKot7mlVq3u7Zrb
	hOEObjbD5dYUDB+QXwfvT/9K7Qtvc9mDYuFA778lPGtnwqlJ4qMTtFbkeMzvFdU43ukx2T
	FlPsrse1fBdx9YR8OWXwBYS+2mijRXw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o1ClLGdu;
	spf=pass (imf22.hostedemail.com: domain of 3AgOcaQsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3AgOcaQsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771832067; a=rsa-sha256;
	cv=none;
	b=cul7niGA+JeytkwYzVRtRbc86W4qf3m7bA4yi9vu7HIXUn3i0UatLcDku8MwBD7w+WfboF
	ihgugaRFSMdhQ6WQHcSUKckjfyD/8I89647ZMBGvn11LyAyT0lRus/hi2OB2iI+SCy2pop
	csJcmDuEdl8C5vbLliqUT/0zin+6DTE=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bee18a62so2982370a91.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771832066; x=1772436866; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H4IDTTN2imEE24tZz4W9ct9niFiZM+M1v4/EEqKS/dA=;
        b=o1ClLGdukAbkKqX7/ouywxLLC5KzB823EUNpbj+fTEtXJnKr+Kzd1e1SiRkqhRCVsO
         oobiDKD2UGmOaet7hxfDWi7BAB+z9UlEorv+IyGTl+Eo+HDM30M3GZvpvrXvz1kRoddM
         QXo8BQzW5cM12Bhw4ymNYI3NOu8zkqaAN+raiHJi7E8+wFSeSIzl16Pk1cH6FGDr7acP
         RHX7gEn7aUENz8LIWV39CnUQCm2gZ+hBjhDgJL2A8AszKaeECxdBrjrifW74ZRArl3zG
         BbqTt8ez0u7DEonV0lmTDsBShGdhpimRt+/q7yRFsYPq0bl584tssvyzQkZf9D2vHRDu
         XLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771832066; x=1772436866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H4IDTTN2imEE24tZz4W9ct9niFiZM+M1v4/EEqKS/dA=;
        b=Em4ndSZiZ9RDVe4AJzzX83XUveS6DtKmqApyICrpJtKjrwib6mJiSa6cl3cy+EPcAc
         MkAtchqW+OPVWfv97aVRyBmfMdF85ZWp9pV1HL5caQX8P3vMREXAGDfpuS3pWhZn4/Y4
         RM6OMN1RtN/bgePrWBxXaX8HGvbms9AtvFvlEfL1ChO0Bv/yGTGfOl3Vhaab9wfFQap8
         fH9KyK9YVmSwoCZouUjEoM8T8k+04Re5IJPYABFI3FDxd0WWmVw7lZYdinLViiaJolQb
         ttrJp7aEu+pDEzKuiW5n/OC20yOQvwmY+HBn92ZD49kYkI2zMQtyMm/Mfy3X9JUGVN0F
         X0pA==
X-Forwarded-Encrypted: i=1; AJvYcCUrnCeH7w6aIN0DdjJbAaPhoVu15cGMkOjgTFeiIRJ5EPg4fIxzGOH/lRoEhg1eZw5QzZ3ZCqak8w==@kvack.org
X-Gm-Message-State: AOJu0YyTehmye6KZvbEOqS/Q81jn0J5J7Nip5ijyAQui3wh3n0HaedGV
	2CY6RYbleUBtJpRp3vGkArhhGiIKAf/OISnf/L2eq2GBiiKh4MkJMc9g0jRHW0niV72BPeltQiG
	C9pBpdqK1ePKedewMltwBaosFDw==
X-Received: from pjbbx20.prod.google.com ([2002:a17:90a:f494:b0:34c:dd6d:b10e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17c8:b0:353:6373:590b with SMTP id 98e67ed59e1d1-358ae7c352bmr6655610a91.7.1771832066318;
 Sun, 22 Feb 2026 23:34:26 -0800 (PST)
Date: Mon, 23 Feb 2026 07:34:14 +0000
In-Reply-To: <cover.1771831836.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771831836.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <bad1921421199c3009a773d006c1f8782e90452b.1771831836.git.ackerleytng@google.com>
Subject: [RFC PATCH v3 2/2] XArray tests: Verify xa_erase behavior in check_split
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9x5of53byh46ds8skt9pbjkzryngg1x4
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A860C0007
X-HE-Tag: 1771832067-510602
X-HE-Meta: U2FsdGVkX1/ivuD2prNg5CLiTsmNBJezWbUCVIbxJIuTrQ+o6oDa5MqiOQpIHoip4AwI49Lk4hYVYIHM2ld1shcTLy7CP0uyvNNRX3MVzEuS+psMoZ7acf2nXMqJAjhC2AnzOO9k9EViq2MPfWXCWoJIK5XvOxHco14rT8PpG6cPsJL4UynqI/Qj4xp0ZMoZmnHzFP9rlyW/foAaDDJGwuyAjrbt63OMb/wUZtr2rY4HsjAnr3aNm66QWnQgPjSSzqM/yBoSltbLD+LqTugC1VyxF922I++lrW2kCxwSkUnXz8DZcOK2yg1blXuAmN7Q3GBjAElBs9nuL8ThFuwvtyoqPIt4Y5g7qI8BzBdIRiTToufFGLPj+fyqHso5HlxG1TeXE/361T0P0qJsd+WaLi8qybMyhjh8RskStbV+J60+0Srs1A4Iu8akNEBPPLCZwYPpi9s53DFMDQUeP44FYRmh3nIbSqWu665xRUQD/uWSr9TOcaRFhf54U9OIdE7a0/NzYqHusaSl5rLHDn1AmgylUv1qdPqaFtAbbJShUsodHN9Q5Bt4QpQZ5425m3++Tmz2gdMGA3wSl7uP2vOQiWGtDb71Ql1dBpXDgYP17XHCRNq0s1Lu7jOyp7w40GX2ekBW/xxL+soclXqZyBil3H32hxmOXZgKmwewMc0OtpnlhrP+9O31p5vfR0AQi87mYoXNOr7GDgkgWQvGjoOEYNEx0yI+BeXcD9bsoeiuiITXhUP8gPRMAhJSPAG+/EPoIj2E8k9HFqFvwNy9hLLcBg8qPuTC7Vs+WH1NWvWhSgQM5TBW4jErlcVR5vt349VRmJkLfGvSlVacXmz/9EHgGPrJStS+aHYUGUnHOeVcbs695+LHw/zwpDgNtoiYbLOwn5mdrDF0yoK51qDb0AOh9QoXgw4C68f3fNnkVYWbzDtvrI+/xrNfLlZUaOPM0bj2HZDQDPy0ts1jUOUJrtX
 HPwidurC
 bIdPNUN3vGAp03BQjPOioVk8FcQcyKRXgrEy2mBcjiLEzjPT97YpVvO8lHkzVdhO8h0JK0ECOQwuogJ4kiqaRAxIC6jS9l/WZ3pzvp4dLyEgO8Xl4DVhV7GCIB8xlycaWgRNh8/9BLeahO1mys4KBUy0DRsenjmvSYhDgSriMJ6DPLVCux4d0Av+xhktn/TCe3TJ+DDHl05JaCZ1ASTSVB7Mee1BiruEMHiAyj/g6yQ/FRb/lG+AcjC15WSDKgYO/kblh5/YQsrc5sK4MViMDJNX+J5+QYsBg9nIwyCW7TLH14NnmuiVWvX9O/hiozVy/rz/H5ETnu4K7ZdNGiqYR619xPQ2WWM5+plUwVlelaIpbbV5QiBiwepqgLZ0TaUv6QysOVNeNWVcE5KmU2XtscnDqT0p/CqeGL4D21KqY/GAn8GkV1GoxxuPpUFds2I0p6+GfDWvzMu6gfVx8sNsltrKeQo2SE6p9drHl1bn3rdylTulVZRsnwgNHl9fj+T6/PpSJTbDSMjgigwPj4tlbgEpKx8DRcaKsO7SkDMZn6zAoSVR2wNq30+P3gy+FLICUEYU1+VwIAO3IeFumqAeZoiQMAH3TAyVE78/S1tN41E+/Br1n+z7MmyTjX7uTRTA9dH9qI6dpn00kAJQwyadsppQWQDlD3OR+arBgYki8NMbKdX5AYW9+V8nJyC+XeLa/3guGXHZdbqLnsgR7r/zYxabQZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both __xa_store() and xa_erase() use xas_store() under the hood, but when
the entry being stored is NULL (as in the case of xa_erase()),
xas->xa_sibs (and max) is only checked if the next entry is not a sibling,
hence allowing xas_store() to keep iterating, hence updating
node->nr_values correctly.

Add xa_erase() to check_split tests that verify functionality, with the
added intent to illustrate the usage differences between __xa_store(),
xas_store() and xa_erase() with regard to multi-index XArrays.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 lib/test_xarray.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index e71e8ff76900b..bb9471a3df65c 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1874,6 +1874,10 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 	rcu_read_unlock();
 	XA_BUG_ON(xa, found != 1 << (order - new_order));
 
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		xa_erase(xa, index + i);
+	XA_BUG_ON(xa, !xa_empty(xa));
+
 	xa_destroy(xa);
 }
 
@@ -1926,6 +1930,10 @@ static void check_split_2(struct xarray *xa, unsigned long index,
 	}
 	rcu_read_unlock();
 	XA_BUG_ON(xa, found != 1 << (order - new_order));
+
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		xa_erase(xa, index + i);
+	XA_BUG_ON(xa, !xa_empty(xa));
 out:
 	xas_destroy(&xas);
 	xa_destroy(xa);
-- 
2.53.0.345.g96ddfc5eaa-goog


