Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92648CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8DF8E00C7; Fri, 31 Oct 2025 05:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69638E0042; Fri, 31 Oct 2025 05:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6918E00C7; Fri, 31 Oct 2025 05:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B8E0E8E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:18:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1998816041A
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:18:45 +0000 (UTC)
X-FDA: 84057859410.12.380CC58
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 38C2F20005
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:18:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf03.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761902323; a=rsa-sha256;
	cv=none;
	b=jwkeIqGV0qtHDZV05di54z4imnypUO+WXHGH83Vgr+Z7FieHrovSlcUNjGHnxkvEnuwk0Q
	ufA3kvUbJ1HotOFKH1RTQ3FbAvSTcZSSyGKunem7BGcFBHFe8WMChH9UIrDfEiIXG4RCl7
	xRMAMiBEzI2MeRpbyFWfM56uYYnnbeE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf03.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761902323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+NZHuy7slH1tEgRbDXmTQJQ+Q/vMpvRiCleu5bnlac=;
	b=3Wgx4cuA0HTdBON4+YoGYiVzL4uF4Vv/W4wkm6JkPZCnMATpRDxSFqTyx29g2oAzZCnCNx
	eldZpoxrwM6ZLQJfzRDNY1fegNA2JggUeuPqZsJEMeXeU4NvvhB8NhS2Bpd9A19VhO/qPE
	hFwQpOI+BO9LQReIboStOduYpFwq3Vw=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2953ad5517dso898525ad.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761902322; x=1762507122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W+NZHuy7slH1tEgRbDXmTQJQ+Q/vMpvRiCleu5bnlac=;
        b=iTduroAHePseIZyoCDGrwDE0Q040mSqEfnCUnCMZzPuKTRU0CxofkItrke8BPhMhS2
         L7ZL8vxdxDjW7ZnpRJKJNhXVO0/hwP3snIhnUIlU6JWp9Cxv++W0G0XcTdnm6FEbdsEs
         0dppA+aKLCx10NO3v7VW3CAe5+F5vB77IRKJ81dDtaHwod/f1P3+H9xMHtOgDTmcAeq0
         EPKrbhjTAffd6wE0p3fHiWwb7nnCAcvvVIQE3a/GLtHRD+73Cg2pZSH3My6zabFz3qjf
         69NHVuafKoD3E/qts+hYtaxeIyQm8uI7tpFmaLiWThTCQlnLOz7kC0YPDPFhf9AHBxdu
         E58Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/r6ZP7wtLUtaSp0ZwBrRgB4kSPSoeBcsfgDyjtaSGHuF44w4KjOtLDPOBVGfCoid+X8vZDWXEOA==@kvack.org
X-Gm-Message-State: AOJu0YwywKIKqoXKWDCNkWGSblKVsmyKZDFAHDlBra4pUbLqps9yuyNL
	gXGnC3f1FxaD8/2XOfbqit8PoT60RLjNlY+GMrUZ56yZ+sHUZhaMEcyO
X-Gm-Gg: ASbGncudzDLC2yuVw0EClY0vl4DMiIte4o2QJrKOedXNPdfrnjnldbqCBnIBbOEPTG9
	s9cs5vpAtrmtzpQKLRcg8YS61tfquRtCgHFyvGwDLtZMqaQ7LwC6xkB7HcRLcHQfT+4bpPIQ5Oc
	VSk4lgqDwNde7NW8VWA8mUuqfG6xg6KW/OtOITCu7UOF2yty1FDQJ97oNOEBrFPqDacsBnDZWNr
	TJDYIlP2NFNKgI8jESB9HgqTm6WSKmiL1ap7qxl3taoaTODpzZCi40JYHE4jTtdNt8Z9lmoyWlZ
	XMWbRE4AFY7w5qBD7EVApki9maH+hRX8q93GVLJcEbQFKQjgKHc6JvBfwl1PWot1nAcrSAH3AwL
	1epvgdcDpFBb/w66NqmC4chTHSk6Vk3S2hEMZRJSc4UFD/yBsuLwak0O/ok5Vp9K9J6Ta1D+tHt
	Daj7dmeKjsk0bQcI5ueq9633o=
X-Google-Smtp-Source: AGHT+IGaY5+g1K6KFzwg6ulzp43eGNlMp6k/vOU+6dw4kyEoznXaP1AMdrHNLfDz0Nl70DbFrEP/Wg==
X-Received: by 2002:a17:903:18a:b0:290:7803:9e8 with SMTP id d9443c01a7336-2951a48cf38mr43274965ad.48.1761902322016;
        Fri, 31 Oct 2025 02:18:42 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3409288c7c0sm1524575a91.5.2025.10.31.02.18.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Oct 2025 02:18:41 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: big-sleep-vuln-reports@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	rppt@kernel.org,
	willy@infradead.org,
	david@redhat.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/secretmem: fix use-after-free race in fault handler
Date: Fri, 31 Oct 2025 17:18:18 +0800
Message-ID: <20251031091818.66843-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
References: <CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 38C2F20005
X-Stat-Signature: 5qx59jes3qa1bhgqb1w7b9nsg1mbfbws
X-HE-Tag: 1761902323-125233
X-HE-Meta: U2FsdGVkX19HOdZYw2Hbi9ayxqj07RLKN0J/60FvaQ9xD8Ne3M3Q3joiKmt1R+gTp6u+XN05lP+44XU8Qpu91aTwPfQnCS6XGqTxPQMXxIBGOZ8FicWEGqmZAr7FTMr8nDl5G/AjU5/Bns95Yrr4pbtn3MvIsLKMujpWwgMJV3HjtY1jaHNafOMMRr2yuaX69s/au33DXfhU2RR4P8ZZ8d6brQt7LVnYSbcAo7NidM7VdMZHaLCwuEGRJga10XeuoPR8P8WipeNOpR4hG4txRYqiZ6YVIG5W7CfaqkHN3mzKkDu17u454tQduWwfrvmSDe+l53NG5AYvyilMOoIpzB4dvuHhXSWolBGSlTGxnSiJRpYHlkWHRPoL/mYVQ+jlRcijhW/JFxT89/l+sU48Kd92C9gYzpfuayVMlx4wxAj3t65byCO0MQy/XMWD9pkR4J3EeDSBXSHbVIB1T4FcbpnaAEu1UkF/W0Qd7vD1Yxy6j4R/oUF1GK+ODFvE2k3HAXLrR9/3/hu7vQgTJYPCDjNpAmVtSKYz3lImDCsFfoLnP+Grp4ZwP1RejUJr5+O3tBuhdpMcsTbhhmNpL4yLzWgQNxH0N0sDzBRvlyJj9weg0WPHKOjs+tow6YbWyvlr4KXhqlhqy3zYWZ8PWkvyaEDASEcqOawKnGDjapin+WhRPQI/RK5R1+IFnLa5PXkXSrhddFz/ohpC+QiC5mvB8RFiY2WvFlfycaItWY4IaWEHsOYLzWpf9xSRpNpGzrkenkI+584RjCStZ6cOtO4wkmKspz3K9nw6Mh90m8MS0GTxwu13JTInX+QjH+GJWOCN76j1pQ/w7J0t2gI3r3efF05iybwXmHQ/EDwOKfHUz1nLjpvwF3f1kuQOv9H8coiF4LTSRHCpdpSXVR/VXmdp1aBefCLv739pLQsEWNX276YkZrzriu31wQJAg0W4sUxIy2p8KbZNxJ+hp1R1np+
 citXlH7I
 H+S/J8huFFKHxADTIraTjwwUruEEMbcLt/Oaekuj4mYFk4DEmOXEeLv05amwWdCKKtyK1Jb0Zz88tx/l0XW1QTGQaJsrqvhXVAXUGJAH/iZzEh9FzghmSy0EfnMTK7exLAsm3zJjfRAQoGAmk+MCfgCw0kE60QI9vK7Y5+I1tunexfcERA9+wpBkuicoEOoTU6gwfzECvvmUE4y6MhLBeZlUrdzjLZ1vfwETDzSqxQ31nfYFPctL+4isbDUcACysRFRc9Uj1HTdurZE0H0oM/1g9HSHNHiiZ3tw3yYaMpsiFj5vKA4vSmyWpdCzSrn8BJs9ER7XFnFCytw+HtB67QLT0puuboiNxa1X0F8ABAg7YXbFOnFygro5MIdA6+LCFbiFmGvYAiCPf+jLnbLAmKDRO90N1WoxJmQDfFoHPtgvO8atkZR7yGLf1vjfRY0dmnesA0c+DzGqYy+DAnBPFF7eEFe0RDrRIP82PTJhokN0pD4zabX++Ld5ZGZICT86sTVZzt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The error path in secretmem_fault() frees a folio before restoring its
direct map status, which is a race leading to a panic.

Fix the ordering to restore the map before the folio is freed.

Cc: <stable@vger.kernel.org>
Reported-by: Google Big Sleep <big-sleep-vuln-reports@google.com>
Closes: https://lore.kernel.org/linux-mm/CAEXGt5QeDpiHTu3K9tvjUTPqo+d-=wuCNYPa+6sWKrdQJ-ATdg@mail.gmail.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/secretmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/secretmem.c b/mm/secretmem.c
index c1bd9a4b663d..37f6d1097853 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -82,13 +82,13 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
-			folio_put(folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
 			set_direct_map_default_noflush(folio_page(folio, 0));
+			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
 
-- 
2.49.0


