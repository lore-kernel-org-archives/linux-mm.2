Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6B6C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EED66B009B; Sun, 23 Aug 2026 15:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151136B009D; Sun, 23 Aug 2026 15:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CEE6B009F; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6A086B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:41:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C939160393
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:17 +0000 (UTC)
X-FDA: 85133552994.22.170B9C4
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8B36EC000B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oqf4LZth;
	spf=pass (imf22.hostedemail.com: domain of 32kyLagYKCPsz1lkdqjrrjoh.frpolqx0-ppnydfn.ruj@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=32kyLagYKCPsz1lkdqjrrjoh.frpolqx0-ppnydfn.ruj@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514075;
	b=CsB5FRoUqrv0WXMrFe/M2v7pXjYO3kwuLy6rASnhUPJQfB5Rcjw397b5CbIO+vABeCi2sr
	PT9D24KpxoqG5+hSK7lEA4/H73WRuPnxvABi5n096Ke6Ke0T754jfrw2WbjaGVkZGRq77/
	LclIe1nCeXYQ74v1AzQKV7kIDMqDL4c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oqf4LZth;
	spf=pass (imf22.hostedemail.com: domain of 32kyLagYKCPsz1lkdqjrrjoh.frpolqx0-ppnydfn.ruj@flex--wyihan.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=32kyLagYKCPsz1lkdqjrrjoh.frpolqx0-ppnydfn.ruj@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PLLVRLXNNRd7Ed/uUOsyNVCmInoOvgLdAuldbbtEw8=;
	b=O7+X+hELYX5PwkcKhHr6qH1YR1bStK7cAvcvptM2PbU9VFXmH9xjtad1OqCvRb5FHUSTya
	ydRoDwR1fSS0Mv9R5dHHh4D0CbLJQ92UGmErMnR+Dbb3aBP72abI5QuX6ZoZaQs7S9MdAa
	n3Dtv2NwlnpxNWxTvW+pgYZ/Iz0RZlE=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cce14a21faso37119085ad.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787514074; x=1788118874; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+PLLVRLXNNRd7Ed/uUOsyNVCmInoOvgLdAuldbbtEw8=;
        b=oqf4LZthtD40CyUsHwkEqzBMwxSmwighFaDHttI5uOrSsxXQChS++oX6UJfEWQjiPe
         0uy7silVbBvICU4lCGM+rfPyG0mJ2WBSThyg4hzaWtcadJDZ3vAXVxuHLsjVjpptVA5y
         qUH67wIu0nS26eqsFshH+joMP4kDc+re5iO0jr1NehDvJgIcDa5U9R9daU7FfA/tsg+i
         O3Fg2lByWBcGWpNKt5Ol3ZV9aLPfHLG1OPZUWdASANxXYGCYOtE+0vJ3imgzz/ef3W5g
         M5jNRswBDQzzASzRYibi9XN3E75D15Oe0i959QFyiVY95jTO0fsAxpCscIRD2vgBTIKM
         VHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787514074; x=1788118874;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+PLLVRLXNNRd7Ed/uUOsyNVCmInoOvgLdAuldbbtEw8=;
        b=tNRk/G9M7m9SDFVusEvSlefRzNra11POPQAX6PKMd75lO16SKt6fwigK05CsuMd361
         WVmZmEUIqyoiHqU3O2Wuf1eB0d48P7eSy05/5oJpFBNkA9vGpNVA2+m1zMbNtPHn+xjy
         i9mvcrizfakbWkap0ZpnV9FnmoVQlvIqB8W1RgSDGfCcVd+PI9ApdKnKvdquN+dBBA7B
         4ZpvQah2umyDjsaQQA5Uqv5ZbmiYKOTQpkEh9Py56nHsbUj0ze3+aUub9hXZfRS6NxNM
         Ne0Q5DeORDg+cKjJDQVZwTYycrmB25aouk9jHbiw5TTHqfyWrjEI8xttcbIXYBIo0Evb
         FvJA==
X-Forwarded-Encrypted: i=1; AHgh+Rq//7BHfCzsl2+kHYHHZdTwzito3yfQ8QtFx/Dq5VDiP87xGQXpshD7JTuXH8wNJs67Lf3hjyvtFw==@kvack.org
X-Gm-Message-State: AFuF++lDCd/0AzdjA+1yyt1+3nteprFe/ZVp1lQ5XYfdDNMK2sELluSx
	O/XA8lsmMJ2NbPvVL9/DJVcBhaMEw0BCaSNfm3mcaOB0bBVJT4bGLy50wYd3Wbuo0O6ziED5dGH
	5iV1Zqw==
X-Received: from plgu17.prod.google.com ([2002:a17:902:e811:b0:2cf:e9e8:7776])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19c8:b0:2bc:e299:4b3f
 with SMTP id d9443c01a7336-2d6501d2265mr232088365ad.10.1787514074179; Sun, 23
 Aug 2026 12:41:14 -0700 (PDT)
Date: Sun, 23 Aug 2026 19:40:54 +0000
In-Reply-To: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
Mime-Version: 1.0
References: <20260823-memory-failure-mf-delayed-fix-v5-0-d97a5703e45a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787514072; l=2540;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=vCHjJBFQNgP1MdM2vs0H0cX8vGGek8P/ghWBajkazgE=; b=2sOGcjZM07dUbENkG7ka8LU+3w8x7MPjDTsuM6RqhzWcVud3VEqIB1Z/Pld7tKcRttGXPnsFr
 /62srT92oGsA7CVfqsivq5aDykS/C493DC4/WQwo3KfT2kM0654yUZf
X-Mailer: b4 0.14.3
Message-ID: <20260823-memory-failure-mf-delayed-fix-v5-1-d97a5703e45a@google.com>
Subject: [PATCH v5 1/5] mm: memory_failure: Clarify the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B36EC000B
X-Stat-Signature: 3gx7eox1mndzfg96tndmdiabtmmdxcqc
X-HE-Tag: 1787514075-839756
X-HE-Meta: U2FsdGVkX1/hwe5m+BVe0x3yJB0y99ehl7rK0ajmeT2gp6K0tohgvZM7/xDEKYse6QZobF6UKkFJiWqL+JMyi0rtBQfpUjLAJ67M1fZyNgHTqsGqw6muDZrYMkfjJrluyE/+WwRq664w28SxmoQ15foaS9jtziTw9dTGvJFjSx0W+h/ekcfk/8CXxJAVUxyiTnFFWPD3uTeo18BlD9OFzDsTiWPrvePE+s4Tb611CVIQnLO+PKwfRSoUii0mL2Z7d91pljE94zyWKw65XFA1bK9IZQ9i9GMw9VRob8IgZ5VlcUiTQ3z3a6pBwT2Nap/r/OvoIjejhoFJxafp1ydY0IB0FYBGaZWvUEoVKJJNRRQW8Sezq4JNzJrSafZxLUjiUCWOn05Uz3Qhe0L6A8kn7q7wtHJBnv/cShxCpy6phhSBMqGIXJRFHitgSd499UN2ziBU5NEEVMT0QfWJCZDjPQktP9TB2kJ4eERqLpPnuqIrWt3i0Wp+wib4dC0vVx5aaz6fSCuNlKYnNC+6ucW467viaB6OdYvA/+5VQlV9VOTZWXP85cTQB18ygHjP6DG0bXmOO5i+/Uva/nKrrWNu15I+UPoaMgBwFf+Qv2AxG+82NQcZIXPIDCLeKIDlEXeOF+21tZvuuVc+rzdbNZIUq0AuWmjtxXoBroq9lu4nvJk2e3WBfYBINnBHfDIFQ3tIeBWFWegm9YeRMAW80GFaW0ZSWk2eQVKjuGP7bcp145aq41bgdXDQ1LuwrTej6shA7H6LCw5sH7SJgOjnTYGO8X0Xs8xuD2LzHgcSgUL60GH9tE3SraMuOMiwKNdpHynyc7hDocrbUiCSJF3XgPuA5Qtdagh3fGIdfm3oRvGD+Y7HVZ5/cKRWs21KvdN2etENK4UO6VWGCX4sitt/K+X+nVIHmNMlf2p12QDkdhotEE0jEk75myM0VzcBRuyiYTZjmmXry4pi49AIpR2YoNd
 a5qAj1c8
 1KXTNBMdA3hOICPv7KT8QOYcEiMhAw2DGcwx35Im6vMIAMZwahlBQFjEg3MDeuGaNGlf0jzNqeY905TJktf31iuh8NjpU4VQqo9kffj7eac9SoyAc4+A1WRl2yzO1q+Hlrb0SA/yrZ42L2KRYT4SkISxHihSocyWBLv5vj67Z6D/FgORYTMHLXtaqMSFLbvPvem8/iWPdeUj6TQPpU2wSiK6d9FdPfXYaHiuH0ryZ9tkPZc4dBh7g7oqlyMa7a6mlUIkoOTyo8YwhZYlmXomK4fi0LWhC++9i/SW7JrzS0LEgIudXXlTNnRYIx853VqDNmm/9Y9jpx//qkCdrZaWyItZ2VVCjkOoYdMm84oeigMy4MjhL4wBfNApS2yCWYJR2x8vjSSEEoYow8Yj9lm55CZbzXawO9+cFHEt/gmPTp3UDxgA2+rJXzUS3ieOI+rVxWS77dZ+MHNg9Is9wbxXaeimiRCZ77RhjPMGvZo8lnRXNzd8c7OtXo9bDf4/Nzd95J1S5ZeP+aLRL0WtERk0uDaGnOvv17IEDZlHycKvMW2Zu3FaE+ZTrmeAu5B6QZKUmcCaTbvAIF5wdzJmEBWLlY7q6fOF+btRAgKFjkiPWhG1nI+RXK9pBKPd3pIA3NEHUvndWD2ObJ+W9AfY7kWFjU+X2CHDwd9ir/xqZklWbVK7Bh289IHbtBVyzZTjrVydU/M4+8yN2azJnxbJBTNZy/0Yk/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch clarifies the definition of MF_DELAYED to represent cases
where a folio's removal is initiated but not immediately completed
(e.g., due to remaining metadata references).

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e..e698d0e9711d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -847,24 +847,25 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
 }
 
 /*
- * MF_IGNORED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_IGNORED - The m-f() handler marks the page as PG_hwpoison'ed.
  * But it could not do more to isolate the page from being accessed again,
  * nor does it kill the process. This is extremely rare and one of the
  * potential causes is that the page state has been changed due to
  * underlying race condition. This is the most severe outcomes.
  *
- * MF_FAILED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_FAILED - The m-f() handler marks the page as PG_hwpoison'ed.
  * It should have killed the process, but it can't isolate the page,
  * due to conditions such as extra pin, unmap failure, etc. Accessing
  * the page again may trigger another MCE and the process will be killed
  * by the m-f() handler immediately.
  *
- * MF_DELAYED - The m-f() handler marks the page as PG_hwpoisoned'ed.
- * The page is unmapped, and is removed from the LRU or file mapping.
- * An attempt to access the page again will trigger page fault and the
- * PF handler will kill the process.
+ * MF_DELAYED - The m-f() handler marks the page as PG_hwpoison'ed.
+ * It means the page was unmapped and partially isolated (e.g. removed from
+ * file mapping or the LRU) but full cleanup is deferred (e.g. the metadata
+ * for the memory, as in struct page/folio, is still referenced). Any
+ * further access to the page will result in the process being killed.
  *
- * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoisoned'ed.
+ * MF_RECOVERED - The m-f() handler marks the page as PG_hwpoison'ed.
  * The page has been completely isolated, that is, unmapped, taken out of
  * the buddy system, or hole-punched out of the file mapping.
  */

-- 
2.55.0.766.g2966f0265a-goog


