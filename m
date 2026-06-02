Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212ECCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643556B008A; Tue,  2 Jun 2026 17:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531B36B008C; Tue,  2 Jun 2026 17:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABAD6B0092; Tue,  2 Jun 2026 17:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCC56B008A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53E181C007D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:08 +0000 (UTC)
X-FDA: 84836331216.04.4F17F32
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70B8DC0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HN5Qq/Rm";
	spf=pass (imf22.hostedemail.com: domain of 3dVEfagYKCOwkmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dVEfagYKCOwkmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IodJjZi5r7h0hIvWeeU29JYBpcZRZhnAZAUBtd3riDg=;
	b=Q+FI4rxBqoM8Zc+4NzZfZ+Lp4dIByDrRCH5FezH2qWMjo2WvxT3xaa82Gpy/KjNP7oyTNN
	tDt0iJKyJyD8wua0LDMHY43OmZVqOiKZIO4Uo14ylltfByAFtEVaA7HLykebv0+CM4rG3I
	dbXwQO8ItIW2nVl6N54vPH2JM7IyaQA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437366;
	b=xagid+A+IDdiCTPyMLOZGlPf4gJWpr3z6YE4AnMC0hWtfepHkXKUWG3ptzKhpanK4xqv+V
	YrudECY77alowbQSxLSyF2WXRQdShJ0pSFL5qXvNy+Pvl+4+fgeXLQPBdZDP/aiR10mjwx
	JPsLr4bASi59bIE187i93hDe23bFlWA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="HN5Qq/Rm";
	spf=pass (imf22.hostedemail.com: domain of 3dVEfagYKCOwkmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3dVEfagYKCOwkmWVObUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf335549b8so54888745ad.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437365; x=1781042165; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IodJjZi5r7h0hIvWeeU29JYBpcZRZhnAZAUBtd3riDg=;
        b=HN5Qq/RmVeYVe2wVDrTs/QBA+XZb85hwewWZBm3Zu05vOW97OnQ71ye1UYWkDYE5cp
         EdvgGPaxelrD7Q4r++L1y/Uryl5qN4v9fd/YOF1G/uSbLfJc+2k2txq3o114oVF8M3N8
         v1Vtvp3mlvLBAR6fsKKOL12IIwC/162J3ApDyVO1QDLFbMIy5M1uA1Fjw3uxWDKRMcWD
         Mpli3Pe0Ck2j8oSaMviGywoY7Be1xoAfmT+7UOX0gqEulEUme7aOgbrYgm5T1czoyTFf
         JFwj2zRwxT682KIvi1z3lzC210yOmRnVc/2TQxypUywTY1+2Ye6rnSWMwrTbKOR9rjVU
         U5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437365; x=1781042165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IodJjZi5r7h0hIvWeeU29JYBpcZRZhnAZAUBtd3riDg=;
        b=qaXw0K51dpVzBo0D/eMfdC7cj1j3KgvUZoU8fCJNthXbCiNMcfbktm7ir7oMKGqR9H
         ov4FjAkChEzqVBF/jgLBdN0caW7im8bgztYj67hU17uEECc/6jZDbHNGEDihnsF3SJAd
         Kxu0RIumF7TTZxzHFzgTXGm+66zKLBp1RWiJSs2jCehfFSvpbR02zwIRVyXnv4DzNjcW
         9JGSHZQfccLlpe/eXDNpoeWvT8rWwGtKrsFV1yumoeCovHGjrimF568lL3jtLjc0OgfU
         Y05ucx6kB0I1YOcxgXE9Uj7uliGubNbOoqjoBUnmRg89WKKlimzd8fgpEnKPL99XS/Wf
         ++xw==
X-Forwarded-Encrypted: i=1; AFNElJ98jvwMLeOHVAvObxbpsYlDvVX0DBxajG5ysbwmmAnLDr4Qq3QOFIAe2+m7qmYR10pEPubxUl/W0A==@kvack.org
X-Gm-Message-State: AOJu0YzrRhERlIn70MYqSv2me4SJPGLs8jKSphRrzsUo1xw6E/y0ehSn
	lJTu72akbY2BvsQA9sPEGGDsT4CjBrrvpUk552BuxkK4WHXiNJaanMOSPmNknAPMeqFviKSIUWj
	orCzxgw==
X-Received: from pljf15.prod.google.com ([2002:a17:902:ff0f:b0:2bd:e92a:169b])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b8d:b0:2c0:cbd8:5ff9
 with SMTP id d9443c01a7336-2c163fa8268mr4999375ad.21.1780437365088; Tue, 02
 Jun 2026 14:56:05 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:41 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=2390;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=eDCJmE+ukj/QmiRfjhh4tiNP2lmAkBpX7X42rYIjVPg=; b=qlOZ4DnpysCVCE4RR3aGPdX4Di/mOUwwaTmtW26PG+ejDM/9AkmX+V6nOEdYaPJYt6sl8ORav
 5QxNZfYotzjAiPo92LoZAmJK1I57WL8Zcm0X9kR0EJD3OR5c59Nwoco
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-1-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 1/7] mm: memory_failure: Clarify the MF_DELAYED definition
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70B8DC0006
X-Stat-Signature: b7pwxubzoexh6uwht3wiqozfn9gkn7q4
X-HE-Tag: 1780437366-179433
X-HE-Meta: U2FsdGVkX19TUckTFJ4fcjEsRkEzlOvIEWeNy8UYYYeT3Na4T/54zzwdpS0+XFuRw4zL90U86ev5CJz6dpOmOkX/DkDpZn/eyDzHfbIV+EVN02uV3VHmFNYps52bTaBj0iaAFCVKlTSXuM1bS/l2yaQaytwh6skrcnVz4nHYYVD+jj3HuhYbnaE/8rE4xVTCE9MUldrIWq+6tWamzmIhcd+uFaTzMmY8SR4d4hX9HZ8D28B50AcuyIFzab6iLuAo5Bz6tnu2uWJqeN4PGoiQ40ScB5L9uuZiLOQpe8CzQkC/sekOXkmgyN8xDbRmRgr8J+cTecRoP3qSNP8SET6S7JX4c3C2UEOGWLFNVlLUuHx2OWcEarScF3ggGV8oV/t4TuBfZpOQg5PsywNq4Blia9lyqF63/WO26QwpZF8AscHLVNX0bvn7/la9AxP7VOuCI0aU9jTPVbPfWYLagqC634V7DnXaTTUArYwc6t4/WlWaJfSWy5W61bzZgoL6HQ0cDMZsusZeFwnEy90m8F8Y4M42EyJy3Z43jIZCrrHBKKmE2sEie9lpyXK5onWlgTPAPOJUH449BSjLc8+I7I77lKVGsyy8RX3zfM3gLCUW9zbHhcTS5ReFmet4vIR3PiQWEEbFgiIxFxKzUrSdCGsjqkb6QNAwMKKcrYRZNvaEtH62ZUJW2z5XOBqbkwiySRhzi3/iCsc2Ih7HlnD4phpzH23Mm54utjcfoQ+TpbVHD8q1iHxthczoOfzymvYh9J1j1wnlPczFHeeXr+R30lnpn7nN3MeeYnTnyfIaL2PgByS7pM95mpp7JKJN3lu4kKqcPG3CP9VVXk9EDUOCIq6kbHud83yb1xTT68ckYngZ/CmRMk0GVnuRK44wdXsITXbMSA2vMi1bkYNONj3RZHS1M9MSvH2mTdnsaMQ3wbNpXLtEsJRcH9iRZ04B3qgQhZcC+m2VrJbu9QOpap/aesV
 x2AB8kL6
 B99jokGGEHNULKeo0rxpnFFSI6Ig6hVYxDcZPZuMfWYiVmHLk6UYUPzu0vYT0ohlqOA55b81P+BivZ/3jCgocgtBjEa/cfxglgaqZ737YlbZ90onZ7BWx9pza7fK0YNwB4CCiUPbSShi1agA76q3sQ88udJ+nLA3zmkC1xA0twHW5WOwWidGeifCErvJztAytrZbbK/0vrZnqJ26euwkRRYNDvNxldL1kExK4VcBZKx85KbNcdXNxchAcrrK8y/ailej3TnOFTKBOxXWRKlJJ85E7UQjVRtU+vfEQ+5sJf1bInSCuyH7MUixejhGecghT8Fdmr0PBGhL9CO6k3UpwJQYAWG/NT/8+kw+7KSG0sKyrtE+Pqm5QIzHJ0J4Z470ASB7CGIay2vKC5OcI2cGv4uJDfLI2Yt+8jm/O1gjY2R67J9iDPJgd3+31F0U5gVaNvNx1bxJYq2HXl9jlrDEq7T0WXvq165M5ABDBX2vAK66jrTYHCFjuTxNoStCHgAZGLyy5P/ZqLXMJ1C0bvzZXs/rF2ApNo4RNS0jyuJx8oWdTl9kcw45nPpBA+rSrd9Hy1PZEOd0YjSrvZjuauDOCs3NVcaY9iFNqaRhER9YB+bXwUvOF2U1n3urVgjAy5zefPZ8biL0ZUug+poxCckBBg89InE66L7dCgAc8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch clarifies the definition of MF_DELAYED to represent cases
where a folio's removal is initiated but not immediately completed
(e.g., due to remaining metadata references).

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..2e53b3024391 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -849,24 +849,25 @@ static int kill_accessing_process(struct task_struct *p, unsigned long pfn,
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
2.54.0.1013.g208068f2d8-goog


