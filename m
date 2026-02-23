Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5212FE98DF6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFCF6B008A; Mon, 23 Feb 2026 02:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1BD6B008C; Mon, 23 Feb 2026 02:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5853F6B0092; Mon, 23 Feb 2026 02:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5D16B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:25:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA0B71CA68
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:37 +0000 (UTC)
X-FDA: 84474886314.14.F4ECA05
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id E30D240011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:25:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o2vrWDx8;
	spf=pass (imf07.hostedemail.com: domain of 37gCcaQsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37gCcaQsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771831536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QO6T3Hywklu95Q2Lh4PbmzrawpSi1ul2o5nH7XzPx2M=;
	b=Miph7LplP9P4W297tLpDtX+Y2Lr8CgO86XT0ECXagWp8MjM3sg3lmnlo7FSfZeOvvwgFyV
	i7ZyvhpHneWscMt52mQ31i4nQQcr1xF9xd6+rxRkA3kbAbUME6TD7EnRn+5SGGeLjmcaB0
	E1n6CcDsIVJrZpnVATDDxtXAZQXPTY0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771831536; a=rsa-sha256;
	cv=none;
	b=RdaFsjXtldvFVqMpOgpdfcqgoJSYjlBjkX83qXhyGYP2Rlyt0cMkTVcr7HcaJq48qQx0PC
	FDh/tn4e08igAPqH+hJ5S8AL/Pw6TvSVZY8MbliXJG4CL+uLOuPM5jQyJgMoULgDy8mmau
	cBtTAe4Ioi74CVcRTMun7z2uqfowOY8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o2vrWDx8;
	spf=pass (imf07.hostedemail.com: domain of 37gCcaQsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=37gCcaQsKCLMTVdXkeXrmgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaf2f3bef6so41656765ad.0
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771831535; x=1772436335; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QO6T3Hywklu95Q2Lh4PbmzrawpSi1ul2o5nH7XzPx2M=;
        b=o2vrWDx8lqDv12KHqT5jhEDcpBeWbT+XeFKoSzVbl66BKnXv58Sj/Cu7pXVqeCYtTD
         DEPTgP1H2mHnrHOq3esUA34OPRq0rri/ZaC0OZsrU68hAL1WUWOQdMhtApjkCVSfV9RH
         8jkyhZU7Dee5EL922FkmUWlk24yEvRCB1iSz+5s35vEIP10kQqeVT6INS4urEhvzIv6f
         rysLWg4orLKEfxYvYC2+tWyVE+7/XY3iaP/IORznf+PZA4cEXGc9lC3veB9Q+AD7WZg2
         ZE9Xgw5hrddXf6AOqJNyxysw+3eCXOX1nCCOAX7o7tKjaiyfZKgC3dAla3pYj1dmcxKH
         iVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771831535; x=1772436335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QO6T3Hywklu95Q2Lh4PbmzrawpSi1ul2o5nH7XzPx2M=;
        b=waaW/WjLRHF95Gt6a//5Ge6+ScKYl0fQvgK+O2kSq5Ay2yb+mqros97XGtQiyW+iDs
         3ZZ2kgOpCUlklgTE+ZExWGqD2dm4upsVEY1ORX/7rmAjSJBQZSQqUkiezw0IxgYkDRoY
         AZP77McHs+zKFW2P3DYw5tALyatR7SdZhMxMmIdyA0lQBdurqIzO1D05333z8XSczxKB
         oO3Y0UIlKBe6296rfae5EbNSB3VVjqSbatqCexhceKUx3hZXAtln5IzWq5fduLsECnHP
         AE0rr1owNWzoP6gT+C4iA3VgrESFF4LKQ4igsWjcYjaT8nmFR1Hnvrgw8zDKfz1M0FPK
         3U/A==
X-Forwarded-Encrypted: i=1; AJvYcCVjHxLgFpUvfmEb30dpF1sbMbRuHxkdSO0NTa22OscIpSHSAu85C64ThshKL/mIkM2voioY+X09vA==@kvack.org
X-Gm-Message-State: AOJu0YzFVVGp7HhM6mqdVYzrRrSL43/4B2PeeGeTY1xucazEMZ0AhPnW
	RE/VEovWEJBC+YVbQTM2KuPqpa8K/3Ln0z9xXrljvEkSSDqxv9ALOQVJyKRFI5iPeXhOtIJCzH0
	HJvZanvb8xXtnxgZKBqhMTGTsKA==
X-Received: from pjbbp12.prod.google.com ([2002:a17:90b:c0c:b0:34c:2797:7072])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b28:b0:2a9:43a9:d367 with SMTP id d9443c01a7336-2ad745a5e98mr58917065ad.51.1771831534600;
 Sun, 22 Feb 2026 23:25:34 -0800 (PST)
Date: Mon, 23 Feb 2026 07:25:28 +0000
In-Reply-To: <cover.1771831180.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771831180.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <bad1921421199c3009a773d006c1f8782e90452b.1771831180.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 RESEND 2/2] XArray tests: Verify xa_erase behavior in check_split
From: Ackerley Tng <ackerleytng@google.com>
To: willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: david@kernel.org, michael.roth@amd.com, dev.jain@arm.com, 
	vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 3jse8449fjkdk1mfp4mdgtsrbxh4sofp
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E30D240011
X-HE-Tag: 1771831535-906468
X-HE-Meta: U2FsdGVkX19k1jrwjs8lalQKNh0Xw+H9/D5tyZ93HRyyiPcmNpTMRMzlcY2s4lB8n3t2wyAkCpGZFMuF2dHEe+L9DJNJsK6GaLStiqA3C3TP5CESNX6vBjsEpoUHSMbY5hRYbM7bBrMieHp4PaurmZ/R7jvIqtvrmzAJ8hNrtXTdq1bKp5zSlZCUqY+nGyg8xfaq/YSN6lFIgaPqjRvkt056ZZYK18rEKcC3kYziHQ1AzYs5ndR76nlffJfbgKZlJqMK7x6S+cn2mhSr/I4VMXMX075bSzBP0ka6mdke9oAUDoJU5VpmwYmO4ge+G/ZLeaJbUO5rxidbwtl1RZmfVQKv2O4uXFhYMqM4UQRmrcxmnizxzmQhQMGhku/kZFUYdQKgdldq8+y5FNyuBJtnBbWtTJ7QRyrmiRosIq4zsrN4oOa+q2rmvOrlAUBPaw53zcX9UruLpSUmvp9xRgd1cUzm+qVRQ1LULrarCeaT7XycdnMufJBLk+XwDTA2Q44K+yBhCId/PKCLcRstNFkNBMXmcfIac4toE4P1h2W34RtMHngWBse4CQnTAcS4EoqOjdO1KQlXIhfnSk1x/s10HAsukufHCbxrPjR7SjzJs0uATUNHznBrF7Ff9xI/rpIHjtNQu6nuqBxbN0K02WoZGZWPaHzLsdwX4oQJHPTlxx9Q4ZzS2eku+g8HDbYibzj/amZFSBNSh4RbedXg77YctDCbwLY2pCnVSG5gM1wV8kWmf+84mBqmAXtWeH4huUZmTQJVXCNAeD3a4aH3fM+NYnMFBQPok94DKXgHqqYQFxX6h7uCuetsUd1zy5JGGK7jH8n0FVHeOQfThMmkpiQ9Zz1oXMdzBtNHKFpzsHYg0MshWXmwmB8qz60sn4mucVk6jXvt5Dg2dYFB5iLJP4iX6IPI9ZcRn3MlH12M/eOKxk/Wjl2yG1aP1g7EvHqhSQzeBQBsZKcfqwq5yY+kke7
 jPIkPYAT
 9BHQ2fgnZmHClhMB19HREO1zR1gQy0Z2l2mZGjb9s/gQAOucMVKsqbTOEF0WsHFlEP3hPNjJN8SJh6MVysd76w6rwCDCYYKPd5KUO2jUVSFWTupiTzgKCslZzG0d+OjBIIMY56fb3ddLqHUXWCI66Kod0rmEr5CHITg1kKKfH/+pZm84AxWZXSUK/l002JTtvhYThOteHF+HGLjv3ABk2QEDHtiHdWiO/7tWGULvy4AMml1ucm8yxuGRcLHP92VmnslgsnDexhJSg8fkTG2HOqn76S/U+2LsmsiDz1axQdcqA6Pz6RynPqO+0P2cLmfOpWGwvCGnebbvJMCyyESEBvjzBSnSYvNoKVjOvqzIYczO7nxUM/G3dLDBk9AtPeS/hs+a3c2vUyAeuLOQv8k37QWArOuL/L126DQh8XjIBqTdKuLnTqUf4L6Fn0UkBFZRM/OwJpuSsv9n7GvLzrn4PxNs2zFBA0u6lqzOQ8zr/yKaT7pyr35ajyyeNJ2miQT0gIMGJiMnsD98y/PWtdaGKgCc0txljcxpcFJcPKBwybcyDVQUgQdTIvm3/pJwvvZU5jR/75OgUuK5WAAGF+r7Kr2bTjZ3SzQTxE8pUxvg5v0wXT4amoPKwDTMx9fyPj2kPhdP7LUUhWVv9vk/vnvA/zAhWimrYFLy7EazWrfpAa8Ii7qvIyxom9Gx4gghbWhpZTyXpZCykAOH8StQMMOoaw55taw==
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

Change-Id: Ibbbae5e6339b46203f22658cc84ea9f16025fa14
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


