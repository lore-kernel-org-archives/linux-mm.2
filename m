Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6383AF31E29
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:28:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD3E6B0005; Thu,  9 Apr 2026 11:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4F06B0095; Thu,  9 Apr 2026 11:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1AB6B0096; Thu,  9 Apr 2026 11:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AFA936B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:28:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CCFD1A0838
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:28:33 +0000 (UTC)
X-FDA: 84639399306.04.CF5B93A
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70ADFA000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:28:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AcG9I3s9;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775748511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+DnPa6Sb2TShUFRzmwJOmZQYJ7+4xed43t8HDhFa3Hg=;
	b=K7NBBKh9PlJQ6u7HgwP81eUruRPk9ImsSPZeib24yX1FQ8jcBkXIMV9plBBEBuwmJKzTK3
	xP25IpPe6CUEZzyS3cULNoK9YrARE8CqFNNLQXrLFHEr9Qxz3bK0xV1/Q8jk4MRiYMFQHO
	hjSsbbqN7yVNlUh9Wxytis1kC4nnKP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775748511; a=rsa-sha256;
	cv=none;
	b=Bp2iotAipZk4J5b49Ke4AQ8xr+dXOql3CksOLxDYJSEKaN3mSLNF/7ARgRwFcnyHF/Wu2G
	j0HAfG4tCyepVxxYPDCB4lT4SQZOfFD1h4HzmtQDRws23v/AD3MOC0M80jfYQ4LiHM+Hck
	/eZBiY3EkP+kWBLgxBN2MQwVrhPbgBE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AcG9I3s9;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8d736211595so70126485a.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 08:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775748510; x=1776353310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+DnPa6Sb2TShUFRzmwJOmZQYJ7+4xed43t8HDhFa3Hg=;
        b=AcG9I3s9GYAG06A7tXa3draobZYHyOJamoCNmTd+QyCkVKPZERvVwRcAzuGA5Xgeyr
         056B+GHoRFmv/pEODrnaFcSq/W5YpDiQtyebnoEH8Qgt6QzY48L9v1dwv7K0Xb4px9VS
         CbPvW1pYsZ7s6DsM45qYuFJu30gWurKV0OyHdTZxKv5cx6isH75aSjRX042RMDYlcvm1
         9fJAJfq+ur58vK6w9zbCm7BRFP+HNsy51NFfFSitnsXKKhNlsqtHl9ozuDcVAa6ipbqX
         v+/EAKItMiYhMMP81FD4wODH+o4QldzMcAXwJdjU2/d1ETPztFzuI9P4nR/PTPWJT05L
         qlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775748510; x=1776353310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DnPa6Sb2TShUFRzmwJOmZQYJ7+4xed43t8HDhFa3Hg=;
        b=rdluVE1GZTpD9M7RtQv2WDQvX1/NYh/mamEuMnRzIB9TwmDhwI+UpGRVSEPBQr9hgC
         1dSFiTRR2AoC5IrNYemPX18aqF5ArRA3TBsTEsS5aPmcV9drEQ3ZP2R8mjIpTBwTOomi
         mhMXTULVSFfqiWvbBG2mt59fgq1VQet0EdzB/P9kljze+VuzcHKKXH1wUfdooEeHVbYg
         QamVHa06g76eTrle0fiMNrhR3v7VHxW1hctyTV9xToK6K83sZw7SP77KrszI0KVZIYec
         i0pLV1qGsyNKC0BE2bSzXyBZAQKB8hIBFDa8b/ir41MGfX4x8qZpvoRX3FNeIiXGp5m5
         HB6A==
X-Gm-Message-State: AOJu0YxIUMI3Y/K5kuQktKL/eENm7HxmlGhpxXcTiGV6hE8vffRXd4Sy
	6SVo2FsXz9ssiSzWZZXNfXoYxWDWJn/JFRts6PiVnfL+H4xjIX1+XKufieqcqsDKOXpeyTmb5t0
	2QJgl
X-Gm-Gg: AeBDietECZrfO6dwLKdbs8E2hA/I/zs0JUkHjHLCUsikbozaAEv07aCFYwNCPzL/9iF
	j8HKgWIHKit+/17vRevKNLeQxiX8SOOXG4vNbWlVsI8CSDXRHzRUJnGwLR2AYo02alRtM1oVai1
	N5/vKIu36OqbGyLMV3Ko8s1p+8cAAormOwzQ/P+NdVwHc4ZVfDfh6qE8KfcJBunz+R5OAjkCMyK
	tViMLcq6oDWsjhHuOLKZFw5aztjcCqVPgePbiBMAXEENGMCv6msN/HdM+wVmW2btYappvgVjzAL
	Mvk3QZGhzRGCnokwBSF0kinseQJ7JYmsuXGz+PMy6v/jjV3Q/c5MJDc4HDB6ckT4pFxusvLet/4
	er242AWolv7SxQTvC1XBCGPYNmpwkHhZPs4Q0m7iAvYHQlpA3U2BYpnDs08u+rJN8BCzoS45kBS
	3HlZs3LLCNcWe0wanHtG9uXhackq5/u9zvNUoRcAC5qWoAp5/TkbLCC24+8wh7+E43CwHJwSa79
	/PG6UvGMFDVwDPG3Q==
X-Received: by 2002:a05:620a:4486:b0:8d8:ba4a:596c with SMTP id af79cd13be357-8d8ba4a5bb4mr1928631685a.51.1775748509683;
        Thu, 09 Apr 2026 08:28:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d3f588d2b1sm1529802085a.43.2026.04.09.08.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 08:28:29 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH] userfaultfd: preserve write protection across UFFDIO_MOVE
Date: Thu,  9 Apr 2026 11:28:22 -0400
Message-ID: <20260409152822.1073083-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: jxzg3as9cyxcg7at8zfs71jfw47wkyzp
X-Rspamd-Queue-Id: 70ADFA000D
X-Rspam-User: 
X-HE-Tag: 1775748511-148129
X-HE-Meta: U2FsdGVkX1+zee4VPpiXMWkjGZMSGzx9U2lvfYVZpOWwxht4Emp9Sr37OWX2zfU9ZVNGitoJViJpKXUWY/V4ny3h6E9lZsPEmcvlOK/wnpqfZRu+11sn6jhDI2VRtxMtxjOhu7ItIfMObz1/C9g/V0XYHZZ5AX/AOO1WMrYajbE7rHMXqq33Eabs0U5wv2mBV0Fk+G/27OlOg89O5XdyDl2BrIpFIlSTKhWeVPmWkyRBohgq/VEtnnVa/o98kUYnuhcICdDLVggMbsFPJVM5OdjKM5/jmWC2JI78rFwAHEpBJwuHfek0I8k8QNLv0BdgGS3XHocP5vc7gsW4fiSCgEizsoFcXjimI0zFNZM2p6KHgIlxGNoXFS8ASCNX9f1/oB5xwRwnRNFmRfso77f7n0yB8amSDRMwTRY/kEP3Aj7GsCe/XiDBa8qCYNsgZYHpkIyAFMAg4v6Kz5c3Q7iNdXXY7XNeROm1coB6UQDIEIcqW0mvBXnbfTgN/lO/Dt5mT9ond/UaPwQSbPt1oP9y0oFdsQa+opNp7cqqDBQGAq8LFwUytVBPkQNoCoAFJOZ2/7JpZZsF7tGzfOvtW0V8MA4/GcRFygEyX3pFZsmiHprzumuLaTMkOcsA3yxx1BGTSXSJqLncqmRDI54gwV+z7QK2r4tcEK/64KmZmHi+gks5ZMiPW60UXxs8VAgYkNFVQNkVOwife0rHlH8NVPoxCYX7EMxUOgeIPeX8IEntg4RWj+T/HA1OnE+YgGlNNTlTqTbXe+1k6KUyeUnH2n5N5kAcLio/T+l3BlvNfmjPkYb/IFveuXHa2xYbTMGplPiRR6JPntZqBqLRnfgxIkIYR2Z4CA4w0gkAa3+GhVyqfzDkXfW1EWP6sF5OywGLgcicD8E/h9NSSOEbsEDD6Mcyt3N4ihy9wgqh/hOOB3dy9YcPzu2nB9Rr7gKYWukYwcesQK22w9oZdFMo9Zdut6N
 +ytGrYKL
 OHMeiijd4VOgwth3pi4TLhM8uGC3MaAEaT1DJHW7cTx4aiZqA6V+BAyWP6KaYBuh54i1gVc/SH8l8E7hf+EcAmpnCaoR5STky4sLJbPwX2bSd3MLIGabDdIDVs/4lkkVEoM8UfsmcY+PN0P/8HgR9T1WYAZXIYjQ4CX2qdxfokBrkoq0ZtYkHc00bDZz+5r4c+3WJ+5UbSRA1WWPEZQGKtg8AbBkJrqPEQLDS0Y3hW+s5cQS6755sS1hxULFFsPCNzjplpzcOUN6Wo9826YxSPkBcWOWX+LTbGP0fsIFsD+WLmkY27FizqPcdkUmVx7h8FcKcrdQIxm/IR5SKT8/jrRe7PrrLP3htx63jNoevh5T8FTvaD5oi9Rrrpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

move_present_ptes() unconditionally makes the destination PTE writable,
dropping uffd-wp write-protection from the source PTE.

The original intent was to follow mremap() behavior, but mremap()'s
move_ptes() preserves the source write state unconditionally.

Modify uffd to preserve the source write state and check the uffd-wp
condition of the source before setting writable on the destination.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/userfaultfd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e6dfd5f28acd..783ca68aed88 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1123,7 +1123,10 @@ static long move_present_ptes(struct mm_struct *mm,
 			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
-		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_write(orig_src_pte))
+			orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_uffd_wp(orig_src_pte))
+			orig_dst_pte = pte_mkuffd_wp(orig_dst_pte);
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
-- 
2.52.0


