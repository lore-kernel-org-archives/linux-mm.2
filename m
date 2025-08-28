Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 671EACA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AFFE6B0025; Thu, 28 Aug 2025 09:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460CD6B0027; Thu, 28 Aug 2025 09:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D896B002C; Thu, 28 Aug 2025 09:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280236B0025
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:03:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4DC11176A7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:03:22 +0000 (UTC)
X-FDA: 83826182244.18.F1DAF84
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BAF2A0016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:03:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RwumEO9D;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756386200; a=rsa-sha256;
	cv=none;
	b=eT67myE9Jf3q5ZFVyXwB2qvLt2rNhfpEp0eccJFTdq3jWImQWKxvQZiJ6fOSlkasWwvjk3
	khX63PbyGuga7ESiFHn9StGIVON/Sssj6cNTuz1mue4oeuVWILyzwWVyUidS7YReWiyDUb
	ScUPubv/ErUZB5/ozidpKzoHp8V4kNo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=RwumEO9D;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf15.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756386200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B/MNTLOoQaC9GH63ytxoIqp7bt+zk5wA7d2enl0xewA=;
	b=aZ73vP36YlwTbhcQ1jzSJ5RWyo8PU+aZXMn9Whnv4TD3oAekwT6r4Fufiw2+mQf4YzuqTa
	f//DAJc9YaN96a4Q9O5EEYr45Rt30gNpzegQMXdB/6iMG2hsRSah35HXpoAIBzC3Dtn6RQ
	T68GpdGosrv8e32VTUQq9+K4zH6I6Lc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b7da4101fso662975e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756386199; x=1756990999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B/MNTLOoQaC9GH63ytxoIqp7bt+zk5wA7d2enl0xewA=;
        b=RwumEO9DHLtZtwmgWmbNbDXfIk4CsGW8REPiYa1TA4qdzGiZt4wATdwZc9gNcQX8bq
         IXqPVkl7zXuSmOBt5mSMDxtxkfwMlDcx1KhpK5jeyGvnnfmQwz8ueMXOxzHlGpGaddjT
         RxG4qnFa/mC6vSF+jVK8oSt3TzlvX3llJuuzO0sJUsVOd1pg0ktzkNsLzoze1s0E4z+/
         AXCbj1hFCtBDW6mXxyX2U62f6WqAk5a9eERFSYvqw+do87zQIf0iJBwhhK7Ua1Ll+t2K
         7SvZbAlGFC46ObSCL75NudxLDKaqXJ7Yfxsmfpa579Scml+Iy9vRSVMSCFsIh1l63M6V
         IK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756386199; x=1756990999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B/MNTLOoQaC9GH63ytxoIqp7bt+zk5wA7d2enl0xewA=;
        b=bsbsBESm9ti2YUtt9qYKzUDD7Q5zSB0Nn5BB3UrMdRNVfk2mkoXdFfMHQrMfCE//rt
         AEBn6dO6NtnCHpqkDtSSXeGNV03y7QYCH23PtVFOzmBOMHIEgxLsQ1tCexIXtcdR7stS
         JegDaeFug/Y6pbnmelwLgom//9QkdpyZPGXC0YnrkH7E0ogXI9BSfrUiMbd8mU1ZCxgl
         JAhck4c+CR763b6MjW7lhLYv4RQJbcl9MtorYMr7dE5SSYHftfIKeRxo9BQ1qDO7RKOi
         OCbhDRWoklb8HTstT6/hi/fRZF7Gj+qIRSlJCkEYNKedG5TIeRNCMl3/VDXzDKBPTIaA
         MBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA9XddDXln3GsIVW6a0RdmVgpkzbKUtciAAJVUE8x2S+noExCSbtUKIp6b/k6u3GJSaUdR3rLyBw==@kvack.org
X-Gm-Message-State: AOJu0YzNT3gm+nGZ7cW92CE8pTGFAldAC6O15GTGOwyRN1dKt2zkWD9D
	mToIlJeNLlsGt5tR7dWVaaP3RFxIzk+9ESNYnIfcNjHV6EaVVyC51mAgqA+rALbFNpo=
X-Gm-Gg: ASbGncsbOWwynSlCCdsHmfqMNxdZwd12G78wQVN/VFWUe9xBQbtL6WlxABF3EYU+H3n
	UlUSGyVoosXMtV4kCue1ckUQJxAcQxaigeGX7LiwNj5rTP5XMAKeU3pxjMTj4zO88jiBJqk9Z3n
	UvFm5XdQzF/WxeprXJNQOqcMDCTJFVX1nJcHSWRH4YDMH1j0YZi7uBCdUqv+bGqNG5QQX/bDuCR
	TA7DMSJOoQRtggYZ4t75zg2Taup6n4mv82ZFVS/FVkS2hfb8QMijv4AcmuoESpv3Ig1xKo16Voi
	/2acWjLzWpdQO3Jent0iuhe70SDSo7h3SzOHYtiNXtu2B9sLj/d/9ekNlg32hJDtTklpWI7r4DW
	8BgT0zZWxzNJogKnEwaDGXwDhseyYZq5+BvYOeAVGUkSdZm/Cnj0irBBUWOFuo2mQ2NpHNuOI4t
	6jkHLeEpuVg2MtsHWYF67ZWlcwWBuqYJSO
X-Google-Smtp-Source: AGHT+IG3aWTBrkvPvuuQElLzB0eddCtWy0l0vdwh09kqUvGD618PEronOpTcNT0G14Vl0737ytOiAQ==
X-Received: by 2002:a05:600c:45cc:b0:456:1e5a:8879 with SMTP id 5b1f17b1804b1-45b517a067cmr204805445e9.9.1756386198751;
        Thu, 28 Aug 2025 06:03:18 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f31d083sm72983315e9.24.2025.08.28.06.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 06:03:17 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] pagevec.h: add `const` to pointer parameters of getter functions
Date: Thu, 28 Aug 2025 15:03:11 +0200
Message-ID: <20250828130311.772993-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BAF2A0016
X-Stat-Signature: e5db4xj14ku33g4jtifnrz6b81minq4m
X-HE-Tag: 1756386200-531134
X-HE-Meta: U2FsdGVkX18dvVUul2LR7XMI/ctsISzt7H2dEbKiuE/BICqTCeILtW/+1mXmD8F6Dr5+R8JyuNGXRrjdPj+eBoe8jAnZAIZcYoyMkDvavB+B3NOcyWMIvuRS7kvnezEzptnoJvi9mN3LmEEVFQp0KlfBDdl6kJSrnf3b7KdhtZEChlsln/nEw9LQniEBZWV6sbxBkwn0Ou13NhUqguW0fDsSwkBBoeb3N9V20f6gzgrEZhBv80YtJRnIMuGyQ6JU9vRlMYPbYHPhIjHLuDXatOPxu7Go+F+MAT54FC5smXNDuTj99GCvSjj/5a8oovwkWsoKqS7LgGJUo57QhPrhHk+qmMVczM39fqJtPE7VUbmzqiWtWovX5IyG9IvBCyPUygSXf8jlWy3OBdH+GKgz7y0fKWl3XG7XT8zVdKagZPUhaId/cBvg5HpnXYkbj/08lnY0PkpVyFI7YIf3MvXEoR5Sr39CeIIm7XpbRh1vK9F6/blZ046qoJ/GuuRaAwdUIrm7kgA2hQMgTOQfIasbs18PC1cMe785j5zYvj7uLKxdCS9ebDeoZ+JZKga7qA2KR6/iVhNR+CjXLlJGss4RtwGlP4bROjIqy1miSE11p6TMkySKwh6ScgYmZ5svBf4N0bTH7cZfvVHxAoongx0sAxzGMbBOaJRYyHKlabN66gnO6oHSC/vBeX4zIeF09Y0IDc838JOdJIptvDivboKLJ5cDV0ao3jNH5kdF4954vP2v0QX3EqtrpWgTv2Fymvck/lLJs7Tef7i1Glp1R1bpeiL0GAJYfT/laNgERW7DhvRx5qKK4oAlgHlb9uc/odkJc8vInTOdQEb2eWRyT7wmRqj/CmgrZ9eWOF3IsIwjwkS/coHTrrMJJviVLiLwSqceFU0YirRiZzFfJT3WXRbLKS2oYYeG10LUghtuZOWL3aYCtTkqnvjci56wxOBH5h7C0j/5SiD09ZzMXHKQ4Tc
 kqK0nE5s
 BlmZvDf5C+m8L3pDybSqvMZpJSioYn1aFJJXz+syMPc+P7GdDXFf698JYhDSsxinfsZmfXTX/1PxUeid8h0FtoG2SiWu+Lxhzxi/+VCIdVJodMgHBaOs9opyBDNPiQ9fvPaL42aWc8Yo/xqkk2mISg2+XW+efWkpeZQbN/sMgmTkxJhJxhXqjfcq3wFJgMdIcrxi43loKxE0iBCwyI7fPaxuXM8e2EBJK57XU/l+lP4b/CeCZPRrpV3y8tEmT/k+SyGSEwZxtJ9kqoa2zHMByvz9nYwej8W41lJOZ9ifjsOyAvorXOXxcAyJMXt0tXw/7FJ4aLKSDdvnwcFQFO1xCaOLFKINMGRjDSMhEpBIUVqJQvAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1->v2: reduced patch to just pagevec.h upon David Hildenbrand's suggestion
---
 include/linux/pagevec.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
index 5d3a0cccc6bf..63be5a451627 100644
--- a/include/linux/pagevec.h
+++ b/include/linux/pagevec.h
@@ -51,12 +51,12 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
 	fbatch->i = 0;
 }
 
-static inline unsigned int folio_batch_count(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
 {
 	return fbatch->nr;
 }
 
-static inline unsigned int folio_batch_space(struct folio_batch *fbatch)
+static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
 {
 	return PAGEVEC_SIZE - fbatch->nr;
 }
-- 
2.47.2


