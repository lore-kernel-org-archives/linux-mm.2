Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB4ACD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 23:37:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF456B0005; Sun, 17 May 2026 19:37:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8EEA6B0088; Sun, 17 May 2026 19:37:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6796B008C; Sun, 17 May 2026 19:37:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4026B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:37:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40C65160E5E
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:37:47 +0000 (UTC)
X-FDA: 84778526574.30.72B1B14
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 53F7C180006
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:37:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6Ur0JoI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3R1EKaggKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3R1EKaggKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779061065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IIw4dgFcNyD4s+iRRHHoK6SylCzaJ865VSAF+4CcMNI=;
	b=TMDWrPAV6AahVKacRKpzpGDO1DwC3ZCQQakOzw/zAkGggCTB49/E2yH/Iwl2CQZNFkSimr
	yqbF9YsZiOM3l1l7WRSUkbYnMesJInV4ghNboHdeG6iM1DweFdT4wWwuwmkAmt0VVeK2wI
	G1lrvGzUhzWxv7ZDMkAbpDtvEAUgvf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779061065; a=rsa-sha256;
	cv=none;
	b=3vGQtPASpyA/Doso8lFNdF/IjEeONqHhbgyrMqEN5hTOEYGspyJEuM9csFJ7q7tRABqDCi
	fQx7hC0RdX5BInm8eEVmTSzeFQntLnM2LMlxn3vkoAJAj0EmXnfUXHvsiCXHQKhrjT/Bu8
	5A13tTthbre3EWhSpogvtV7eU17NZ+k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e6Ur0JoI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3R1EKaggKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3R1EKaggKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4497a0e3acaso1492356f8f.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 16:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779061064; x=1779665864; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IIw4dgFcNyD4s+iRRHHoK6SylCzaJ865VSAF+4CcMNI=;
        b=e6Ur0JoIL3oHTYqwZL8ylyo9S6XNLtgz/UkIAl5SAu60Ek6OGDS+9GnZXHvxZlcXwz
         aWTzLK//F2pS1U51MVGHhRJx4eesth9OiQjIkvGJj/aE4iCQ9FNBbk5VXpVEFPvehUi6
         z86BErb0kg7up95oM8waE+ZQgcZNTe6mnAyDWbi7R03nB0HC0Pfpcp/ewOk17jkPzvl2
         Eq+T/TFb7LUwYENhcfdPBdQJrj0HRiYepeDOt/koFsecG+ccqIukyeR1J6o5znGZb+7+
         /dR4sAqkFcloTQgZkoQDc10UtCPhRthhpBnoJw9emCfyU8WUqmpW+lA9PWGayknpYZRk
         7heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779061064; x=1779665864;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIw4dgFcNyD4s+iRRHHoK6SylCzaJ865VSAF+4CcMNI=;
        b=EyyeG6hZO2a5NSf1wOzTjTB3XeWQMr8gmgWucIc8IWUxIHdbTqn6tkdr0jUFEi2OkT
         y23EMM3DbdREa7g+Hd8NO+jUrtIdEIn6h6/qafINmIBhB565xRFD/RGm75GT4dX6j6QK
         7EBc4zV/iEHNsk+CKxG4jGLQo8D82sneCMht+LpxbTLcO7EQmlfpF1WbLoEiOMVOoeQ5
         c+p0G5xHxBo1ELg/6DzMD4OYSReUlasY6Lkgik6PUFe1E6TggSdQnsu6OvanVXWyxGxR
         4AtAZL7XJI7K9bNJYD3YGFFiKlkPi6rDtrUuVYMiC0bAJ4eG8feg1EN/N3tnCu+QAM8c
         CMGQ==
X-Gm-Message-State: AOJu0YysNTIWeCKe4vStifdnuQqe2HlmqoGHQFM0hVPPC4GqFAICEhuF
	RhSqa6v6Zu9yvhbyLULybw/Af1xykiAXBnmZsTtvdEMfZEvHXC8EO0uGvWqmR6IVsYKr6oFCZJa
	EOmdT0SeVbVReTA==
X-Received: from wmqn21.prod.google.com ([2002:a05:600c:4f95:b0:48a:8fea:9222])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f1b:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-48fe60e7fa1mr196320125e9.13.1779061063690;
 Sun, 17 May 2026 16:37:43 -0700 (PDT)
Date: Sun, 17 May 2026 23:37:05 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIACBRCmoC/x3MTQqAIBBA4avErBtQqYyuEi2mmmpALBT6Ibx70
 vJbvPdC5CAcoSteCHxKlN1n6LKAaSO/MsqcDUaZRtXa4ljhHPYDyV30RBTvxDNqa5VRrZ4MEeT 2CLzI/X/7IaUPj+apaWcAAAA=
X-Change-Id: 20260517-b4-drop-always-inline-17702081c2aa
X-Mailer: b4 0.14.3
Message-ID: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
Subject: [PATCH] mm/page_alloc: drop a misleading __always_inline
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 53F7C180006
X-Rspamd-Server: rspam04
X-Stat-Signature: sywme6y7afpcco7cyxmonksm6o64u4sy
X-HE-Tag: 1779061065-866056
X-HE-Meta: U2FsdGVkX198WEyoSO7HnTdaN3menQWhGCl2OfkIirU/Ui1b09E88Lfi1XGFYw4PzuEQY4ZaOA30UZPyq2KDFYyiFJ9EoK1XCHBYU/cCiRCt0sfV4wo7txTR3ulwYW5c1s1yYehgVe6wIX76VJ4xluxrdcZQPKMVIEumf3QFFt7AvIgHbdQBhSIfWjQROKca+t0u04mrAoY7dWxtbK20bAFs9WHoKbzTTEbkMYagHwqC4L7RvFjLZ3MxZwIr/Vexm4DXHfyPA21KcFT/nlj1RPTqHd3fed4cBB5Ud1U8zArC7hIUkdgRrfY5vOkgJWc3muYUejdXy6hQ1GFWqKB8MvxTHyfkYyXl/zTFo3X/XKv+VXzUwbXUVRlP4AhgYAj0h5jmJrVZ0zij3Ir7ovycAmSvEUFDhENa8LAmCIoDWQBoKYIGpo9qeK3pT6bjvE8a+5V8hTPR4RvpZgY3et+ed85jYqJrLxCr7oQQguyvqkiZo7vH5bupvOHVDTBioPNIyB3qPEQCKdEoptPr3CmLQ6IFBUflCRh+bHLjYEc+Ub4plf2xRgFvyRJgahvYD290KuMAn42QFMxYN0paPFrEdxxaoVRrojNNg28HBCunLOLR/bsy9Q/WM2OGjA9RobPUxq828di0KHsZTp89jKxYxPJ3SY/AiPQFuxe+eoxgVwy9mc/meWal7RZmyrB15Lgn33KSOHuLVjMeKv+wN7gc6iLqI7AGG5ByeKhvW3zPLhvKfu47s9rSFNgtZ68dOAoOUlbV2R29GCwQyBvvNRzlSzw6XQZdwkHY2PlXLSy0wKdqpmMGovuev3sFsgGOUjkjA30m1LTrw8FNjneJ7rsAhsRm4TzbSf6Rv6obcKe/L/+Z2kaTW9TJbbRhPkFsC07mMclSW/FcgqBAyihj9Rhip3N7htxcHmnmAQPvq6qVFKhWTdMKtqbhhQ9nNIhEsc1CMFdjZubrhwuyYOcDnkY
 9jaR5W1x
 VC7lZ/lhc7uLPmIRhsMRTPq+GDjdEkZcHSRbugRwvxSoeyUrJ5mBwuwnBf0suU9/i2yJWKno4e0w36zIy5W/tPxSY3Yag0nW5oINEuhdxPr7HrDYECf27CYOENKRct33KzpLqYEuXBy62dlsuDqgtC9n4glIzSWq9LVUBpcTwjsy+F7pOv+9lZ/oUbvVznmuR2sza/k3qnP0o1Tn4mav71yEyaCQtzkGcxcQyMjPPPXGdbzSn5x17xPHPsAVcJ4hYkKgpqLCw468P+MxoDohcEDAEYxiah2tdcldGWFpBQ6089srLOKpYbzLFEq9+NlhpBxQ7CQbxljzeU+N+c1vnXuLSpijhYhTTqVnGtXKbeyr3G2op+RB4h8Hk3kaeNuly6xc2svEr+FJg0zYGMiLg2P7sBiFzSuduDTdar1hBNm1+knyOSYB+RFQqYxbI1sSyjn+7Fwj/txQLpEEnjnqwlzLpXP8peBe+dXBvQTP0+km63tyyVmbhNmfga5dXJ23J/OjgHPpPRWRizgNNsuXsWYt1chzQfjs+Z31itItWB5pQXK1cq4CPkvKROB7iwQKpUsNQXf/NMjQfJ6HLo2Yxod6aU8Dy07AG2Yccvm77KECQZICJSTif6eIS+qMAjE6gIUGq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_pfnblock_migratetype() is called from outside page_alloc.c, so it
cannot always be inlined. Remove the annotation to avoid misleading
readers.

At least in my minimal config, with GCC, this doesn't change
mm/page_alloc.o at all.

Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e262d1316259d..be7f5671d421c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -434,7 +434,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
  * Use get_pfnblock_migratetype() if caller already has both @page and @pfn
  * to save a call to page_to_pfn().
  */
-__always_inline enum migratetype
+enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
 	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;

---
base-commit: 0cec77cfd5314c0b3b03530abe1a4b32e991f639
change-id: 20260517-b4-drop-always-inline-17702081c2aa

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


