Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439E5CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6A38E000E; Wed,  1 Oct 2025 15:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550AD8E0003; Wed,  1 Oct 2025 15:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419258E000E; Wed,  1 Oct 2025 15:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CEF28E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:26:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DED1714023E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:57 +0000 (UTC)
X-FDA: 83950528074.09.13733F2
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01D18C0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=By0dBrDJ;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
	b=lpy4v6+zGAZPE1mzx/AwzIOYwRw0mCoMULP/Xx0mn0NAkoFMyrbwaaQO6mhc3QrtjnOi4r
	qf8foSv3tzzbWFTrrMLOBFpFBRygLqlvkwHbX8EcBZ5eE5dkRJw11GAtrf/pMut+r8Nlya
	YPFO/6l12LBVKVrnBkh8ck4YGHoR+/I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=By0dBrDJ;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346816; a=rsa-sha256;
	cv=none;
	b=dglRWXU3dGrOQFeZldDAdEKgCEGnJckM30F+NAt6K1s/8sJqw7H6dtQwI2B/4rwGjukSZF
	kdGs7lcu3vCXbzooro/oy5/qHngNzOJDn9YwH52FhD6vhsaS6jtasV1BByID4mp+H80ZB7
	c12Ei6zfASMBpfzMgvTQzaOgZUBiIc0=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-57da66e0dc9so225495e87.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346814; x=1759951614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
        b=By0dBrDJjfMaap3qv47ETRkn39NebLW895iHReZkuMcS/Gkm0VCPy5R5A0+wOD0BWB
         Chr+UbsFeBEykYcWGn9RfmcR+RePTqSEzX8VAE/BbDzDy5FkNpQkylHKsNYnUxsLhjB+
         Rw/VGiEGS3BfqGc71nweovh+ZkF+qJdyMXfXPwh305OGb80YgpUVyQKCBD1nWmbLvDJR
         cITwhrg29KwpR4oXiqygDniaJjSnBO0w+06JM7PnAC8oX0aLFw2uK+6PiGd7dgytrIOB
         G+PoxjZsClIAWOSvR2Giu2HCzr35Q/5x23mUAIWPfj7YFIcO1iHbPMzyQIomaUDmUGLf
         bFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346814; x=1759951614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CTx3t8206FADCajKY+kyp/2YAJmhuLjY8XEm0uYYaD4=;
        b=TLD1JD5OmanM0yptcvnuEes0CFajtpUbfs0N1PW6KMCq7aY58J10LlVxhdVtUuWz73
         5o3Xo1rZt/ctJyqj5UNSRyviUj4gfG9tLWFzfTN5cAYkNqgWxA2fOxT6HHX0tyJA/YgF
         LEGaK8pRjib6oe9BLIMKF58kDBWhI6op3zRqW6DDb8Af0P6Bdb83VgfUbIWGk+BzSJx+
         efAt/ivWz3Vf5XjafsssQkTxoCFc8UL+fuA9Edee7ODCyjKjr/JVeO7GcKJSQffh5+j0
         giJ4LS3hnu7LEqtH+H7RiaM3XX7fntSaHxLlSBin0fpGmBVqtG6C8k61gK/CFgQCNJ+G
         B3Pw==
X-Gm-Message-State: AOJu0Yynt23zUc3/Wug9VaozM6OYpwA4sbD+5KT1OkcEuDtgnOZNqLcI
	9ZDR8cYeekkBMRi1ytBddMEtVIthuvOhFWiBkbcvEQxk6jx4Y2rHrSmoWzqELLlDJT4=
X-Gm-Gg: ASbGncsrN7LoomTRvZrOvqIVUIsHkr7PmuITLRlZrE2LVSb0LWDYablOL1892fTh9rv
	b0imRrvnnmF+OZyIAQJQKF6jiROCBfMW4VeVU4yrA6hz7gTHtX0c5ddhOdwkn2bwdpLqAZ139CL
	91jR2GgWjz/Rv3KyxDWgauycICwYVVVw8vch+ReBdFOrj4/fTzUqDLl3lpyvc+n3uLQj1/hZPiA
	C/Sfp/+bxtFu8zLBrFh9xQBU6Ol+qWjjN3iNexqPfnV2bDd2/hFEpDCuyXYJSGEBUhnCPEToZn6
	sW+x9Ndi/6KaUrQO+8fhuKWY8gatop7vQCsZ9rp4i1mhVbEGQL0cEkMbTfsfVoExXeakw12uC8W
	8It/W8Do2c/BpJJWwDpg+OnFlajyhJzmDolrKr0J3
X-Google-Smtp-Source: AGHT+IEdIYEhyfROGcpz5tzh2C/c8xPkZaS+cLjfPY9+92lHTiKC3SF2fw4puKKC6CoPwT8eBnXURA==
X-Received: by 2002:a05:6512:3a8e:b0:55f:4423:f52 with SMTP id 2adb3069b0e04-58af9f425cemr1391668e87.37.1759346814169;
        Wed, 01 Oct 2025 12:26:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:53 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v3 06/10] mm/kasan: Support non-blocking GFP in kasan_populate_vmalloc()
Date: Wed,  1 Oct 2025 21:26:42 +0200
Message-ID: <20251001192647.195204-7-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01D18C0002
X-Stat-Signature: hwt7w5chpfm8zogm38m9oaewauu3mshp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759346815-209562
X-HE-Meta: U2FsdGVkX1/4AcuNYgrRHA/0I3FDntohLCmBTkX03Yoy4W4G52HUOy0mThE1XO1UjhQgHx2PXQAA14It742ID5aaTkyv5pFHhcQGwI44XJta4u705sOS9dh5U2I96287IglYeTQkUpX/+NXCa6e7VPLXHfeNDx9wLXPUfKz6ao+Ws2T9yCQ9C7GIHsg7c9Ks4OJzPOjMYWnKSGE3KSGcRF1JIHJP5cARc4s1QES2W7yb2Ne8drw1fU1BqqHJIt7MSdvtif/o5W+8wdyrYusTsHipwVrAnKBrO6kA+Z4hNlpZetB9yC6geNWXlX6BEFFuelHUQhyDx8bvPg1rOlXbCdES2G53/t6fmynrtp2UMTnKIP3xAKwkptc+uN894kOgTMhSsYW/PrZEjAdtRWgMoRaEHXfHKFJHQomRtb03IDSK2gCqJha48p1rb7ILJvQi/0veHpPImOlBWFSUiqjnMFpXQ5zknZbZsAlMK1i0yyeBqf0PTOsnNE/TZ0D1oGptI0oPFd80hmv/h5aclNUJO33y6MtcvqRnGtYA0FczO/jqWSvfApVvAMzjr5cER+hA43NR9iGUU27+/0vlf1QmMH0SkaaxTmUNEZWMYdIG/cp5CK2wpLcOlo1j46pIvbXXThqjts6OKN7h7M8UoW2o8mcJd+U42StNkZ6Q5acpLHU9y02714wivlo7Cz8p4SQZ7UTzrKc6KJdMo9+uYqCHIHXjV9b6UZ+X5bihSPXHat0BYMvzmGQ8VeH0UkhpxfXhhsnRgDh6lkUfCx3djnTMzyNSRo1FAzyzGp2UmoQ7ba36KjltsZP7T3VarWOL7wGSWbJGO2CsqRwCrwThc89WWzdiFTSjVKDxJnQ/3r2qItt8Sd1pDwM5cHLwyRvwEGh/nroeVU2UzVG84nUcqTjLnpNvxkZ/ZPjTIWtFpOA1itGEMJbeFSGRI8vKn94VxC4DfCfyVW15IUWb50thwWD
 HYFg3a4r
 0wpXbt+Mc3ifpplgBS7s2GLnzGOewxZxQp6qy4L7WIXOONOi8lnbl5BxpxRvUqS4N6VfkGebKIhLD0+C68HOUBgVns3VBOvE66pGLwOOg04j8/kWNbz3Ug+dwKB1IBa78YFh18I42mGt/DRXDRD1tUvMrYdK1nAzvxYkK49+k4nK8zEkNR2w+zGRL+DTeAvvFIjTrrpfCjRr8dOljJ5XLZepSqp4sQPt2yc5UaFFOte/IOOheQaOEfPOAuzro1Ys1exE6OP8PxgZ6vrA7XE6Nitiop7r8YSW6i8L2PHPzfx2nmb9dk5Qe7bS6LcNQRtYZLFgeksnmhXfFCkOCY83Z1AHZFx5cpuvjaU+QMuuPaLIbPya5wr3dHTZUqyRlZEitstMzVd4x45ZLX+4sSs5qJV8YPlWIF6sJSI2jFZGEPpe1CYbqMdJz8k2cv60O7TYP4EQTb61iGk3oT8Xd9xh7b+RkttZByyrqLjgljcJalEV56Ekxn4JqRU5ImzauD2MjtpO/oZzk9YZ5jzbI2K28m2BEc/Y4gogjL5Sxro1RQP7AaJ/9WeTxprOmnaIyrmUAl9KHK7vJR2KohB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A "gfp_mask" is already passed to kasan_populate_vmalloc() as
an argument to respect GFPs from callers and KASAN uses it for
its internal allocations.

But apply_to_page_range() function ignores GFP flags due to a
hard-coded mask.

Wrap the call with memalloc_apply_gfp_scope()/memalloc_restore_scope()
so that non-blocking GFP flags(GFP_ATOMIC, GFP_NOWAIT) are respected.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/kasan/shadow.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 5d2a876035d6..a30d84bfdd52 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -377,18 +377,10 @@ static int __kasan_populate_vmalloc(unsigned long start, unsigned long end, gfp_
 		 * page tables allocations ignore external gfp mask, enforce it
 		 * by the scope API
 		 */
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			flags = memalloc_nofs_save();
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			flags = memalloc_noio_save();
-
+		flags = memalloc_apply_gfp_scope(gfp_mask);
 		ret = apply_to_page_range(&init_mm, start, nr_pages * PAGE_SIZE,
 					  kasan_populate_vmalloc_pte, &data);
-
-		if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
-			memalloc_nofs_restore(flags);
-		else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
-			memalloc_noio_restore(flags);
+		memalloc_restore_scope(flags);
 
 		___free_pages_bulk(data.pages, nr_pages);
 		if (ret)
-- 
2.47.3


