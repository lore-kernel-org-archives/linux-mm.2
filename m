Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBE3E606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=VFq71Kv2
Received: by kanga.kvack.org (Postfix)
	id 2E2A16B05BA; Fri, 30 Oct 2026 10:43:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBDE6B05BB; Fri, 30 Oct 2026 10:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA3F6B05BC; Fri, 30 Oct 2026 10:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E14B86B05BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A8A1806E0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:25 +0000 (UTC)
X-FDA: 85379560770.27.9179CC8
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5EFAF1C0006
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=VFq71Kv2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHyLSqJ2IgkBMLIdsoUZzb9zZiHVerjdrR5kDtqcKaw=;
	b=4QKS4GnL6bITHjiyJesK3/Dqj8AFcEITMxF8fP/cfT5CsFoVHXwPri+MkOq6LnNHIbvjm5
	XcJmgAN1Tz9S2UAZWkJxGJJWB+GRMPAe2TGrZGtgy5oi1DHAHEuoSb1QjAkNr1uYbyenJ1
	/MRNxM9OaJhWU4u9fZ8nEqma1qftC9U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=VFq71Kv2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371403;
	b=clflwinW+BcTOhVcoLqjWG25hWmwSDXs3LF5SPdZ8yaAcp95wYAb/wIrCSAIWYYFpyYnVl
	isktrw6j0UVWI0GKZAZEfCBOgsM4Grx3gQ71Bjdk9vv273ql0e27BTT1dNmFrK6ElrEjrq
	JSZaZRYghQUfCB8oRCXsbezkqweRt5Q=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48df4f540ebso395661f8f.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371402; x=1793976202; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aHyLSqJ2IgkBMLIdsoUZzb9zZiHVerjdrR5kDtqcKaw=;
        b=VFq71Kv26DkFRtLZeR97+2ZONm8tcvk7dippND9Ua2ebb2gSTP16JUxMHHr2AnJYiN
         qTrh6QZYHP6bIhNwMf/BeBtcxP5hqQ4WWevsIhpIRKDFyJ5y9GdNf4FCVxmRWeO+IFZK
         uotBdFkw/ZRnN5mwf1OkKxRlfiO53ydBhFaC4J0wUowt5+1jzRGU+xQdoI7PDuG3VNmK
         1Rxgymv0FWr0zL8aPY4xZolHf8DHF0H0ChKhvWetBwjrVnS2sPXdNli73SJLalD0dE8z
         5v3AsQiLipi3qZqWz1pRyQh2wIRpOTHIDXok8mxyw/gm+LKjkWBH3tHdjjd9f4M81xIR
         +5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371402; x=1793976202;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aHyLSqJ2IgkBMLIdsoUZzb9zZiHVerjdrR5kDtqcKaw=;
        b=cI1PIW7lXdECmGrssALX3OjPEEtnH4UA7XfaQp1HWtoq6rhjzrLSp6poBj8MRQ0TV4
         cljMFQdjUHbvVU6ZIhom6DpITUmCNXzUIivnJ7mBuBx8uO1Z5nwCG/lE/eJSMo3yVN3L
         8vgM7SSsJlc+NRLCh5Cugj2VAK061xCCuUalawjFM6X6J/uxDHfuAIXjyQeJSJFuRn+W
         w1iFBlSTKC6cdzJXT4alSAU+dUGRy/k3pQnOuoK2LrLJCIkyFnFalZa1gbpmlw/rfY+t
         my3gcFNLl3VvAcjHSFFkIK8W3/qORV6bZsC/W5L4Z41LCQkg2ibozDVp5NnNwyKys00q
         uYTw==
X-Forwarded-Encrypted: i=1; AKwUvBwW/EpY7vdgUnMpg+3wIYTFm1KCMNSfs0dlcsSbGD03QcMbxRzIGwDnaNySPO7F3CAmBzZTrmDJRA==@kvack.org
X-Gm-Message-State: AFq9FYJX/fadml4gyCjwLmWNaYlGMMxe4I/DV9EGJerslnWjzi4x6lkL
	lICOX/gjaTf0yyF8Inz1c9FY/3ZZLXnwoBKm5sdVY2PHC8sEou1lBzrp1UUkV9dvB1zhfAmC0Pw
	mvj5bpPo=
X-Gm-Gg: AYBFou27N0r9btv9GLPAWEGCgG8ZL8YFf7yH4Nr4qpgFtO2D2jhAUtEZpXGU6VlREYX
	lLlCx0KLZtwuGy/CtjddKn8f4+mmQYbzBnI7gLfRT+turqiVleaoB2FgASe3JJXRO2zs92ssE+w
	DuQRZePVNs53IFbF/EJ9qIG6xDPAhQ3kPn3QRd4Bm8rMLDwWuViuXCGqkf6+q0Xi1hMAu1LmpB4
	sQ6JHIphDfl9oqTKzcjPhvkfRmJGiMNXJl/3F61BCAQopYCZ8sAMGddq7qFf4tSjDarWsXyUEPf
	WlDza+Ajl2UiWeW3rmQLOFhpJFYNSdOW0ILOB0/NwKnG0Hv7gjKANbWo2T92c760o/zj9BtWDbr
	B10Qe3zTA8r60S/FHcVNhKTDwHDgWeN7DjV1GSwRh1Hm856rNAy5HV2Q2+l2oeuy1Pivr7mbHBy
	EYMn7ozTpyN4EkwsHg9vD3S5RyOFhzBbhXZsZyFTlf8zv+orIHScjilIR1tgcf8FcDki6gymtRd
	agDxgWX18j9FuFusuKC7CLJT8Z0B8eoqGkXW1R+X+Kc6liz+ps8zKJsWYn8X8ZSjKjka5KgoO+C
	59E6lQWmatvktzw7djvO9QWKF9yFhaFhSbhHvFeo5AJEXw==
X-Received: by 2002:a05:6000:22c3:b0:48e:61c9:4e32 with SMTP id ffacd0b85a97d-48e6e505515mr5700754f8f.32.1793371402031;
        Fri, 30 Oct 2026 07:43:22 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8a5a7sm3618797f8f.37.2026.10.30.07.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:21 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:49 +0000
Subject: [PATCH 4/6] mm/mremap: restore VM_ACCOUNT if the unmap fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-4-c1829811aed0@toxicpanda.com>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=1875;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=Qt9++Odp0ED5GEcp9NI3XJcRFonorag+SwIsdRdoE/s=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNwS+9b9SdMdsKd3p+Xuml41LC9basp5HV8cRhBi5By3FUO5bCdvCutAnfXNwIX7l/iWobSNt4/
 gN4bHaVk65wg=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Queue-Id: 5EFAF1C0006
X-Rspam-User: 
X-Stat-Signature: udearku147npchn7yemq7s69p7h4ditf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793371403-184499
X-HE-Meta: U2FsdGVkX1+A3nLLMdH+Ak/G7/sqR2AW8WBC5ozO9jaPEzwaUpld9kgNGZDbvccu0pBrGQho484aMP8dkZkwdhcCPTM+fSDj8tXoUqcg4zKbUd5VjElMU7odDHUgj7I9FrrR9vs/O85R4m7dO+neq4+6urKsNcvs7oTvqndJF3WpbMF3wc9TEce3cR9iOF/MQOlbz6J4u1TFGFEolhfhdd53c2iyDVJvZ0grHyWRWAIyS4kj/fMSVbtxoN53iwGoiIcYZPBhZdP3WV4v70bmHc9QB/sC5U/QuJcRG+xcmH/aDiTPvmjy+hcTX5M9uFs4jJULKrYB/4LiMnnQ+tgk32q2v14AciIm5yz3t7PekhbVoGKq3Kk+VZdf2ku4masgxJ1SNeoXU/jgHi6dy5EiO2RdBcFT0x9WHAlwroe1+rWV7fxkkH84yxHibFDLLC5IAJot4MTZGkAm3/LVMy+0mQ8TOxFz1iUStbu6V18kXVdSmyfilF2BWccJ1hIhiVavemCdlhPp57IFKXou/ZfbyStEzqeAGHPSxPBSyFFmKho51TTnnHzAqixIyoOdgzQthIW8nnEaKpTXhgYpPWvHOXBU1r4wR17nosZ37d/63OvjmldGDgIP+9EN9FXjGlw9640T1VTtQzOXDM67dSPw1AVenbYkGUnkjLBDDkY0LqVq1h1Af3YiwKY0NmjfZCo008S3hpBAmzVd1PGY/dlOvi9fMqNuSyJcigDGx1h/AIeubpOxAhrHZ+bSskle/kuisi9zAqXsv95pT+4ANOW5Cq/LALIz8CIQJUkmR+bMZq7UyyiwzLW5ymDKHYTWss0MQVJh3J1J/rX+iYA9FkgUXPtuTqMgLG4cBIWMHbfqJVkhJ+lLVBcybB1yBo0ZtldcOaAhrdR3Z3PK0Kc3qLeUQxB7CAtkIZ542i1XoPnLiogwSjLwr6hfJHnMGpcpq6zJ4sbuLfm9RBkvf/LXygx
 QwvbxsRY
 81GZa+epmtpXxMgib7in2BzWyOMwEMS+rLBGPl2Y5W19+zBdSONAfYaPoutCjlTQMiARANpeRag/rJQFqfMdrSxRdWQWf7BEv/vp55PmaIZ9xJ5hg+ivOwOUbWPVSixZTzqj3G3eD1v7TaxB/u0JXm5YMsWles4D9Z0ScJgdUCaOrsvOkfiE4LJyC6VM8oaB25pF7Xdp06beiLnSfjQhNqiEyYBHxAl/NlJd0qDtWyjewTsO1A33X1XbsxsHV4q5itgahfsxI7LxwrQt6uCFfi28NJiygY0Nrsk3OH6r4EeRsQt9r4ZpWMrQM3xITYeJgyWnr8TBJ7kEgDg6nINohKUB7A3ZhNk+a270x0mxNgxX29pKuzUChqtRwTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the unmap at the end of an mremap() move fails, the source VMA stays
without VM_ACCOUNT. Neither munmap() nor exit_mmap() uncharges it then, so
the charge for all of its pages stays in vm_committed_as after the process
is gone.

unmap_source_vma() clears the flag on the whole source VMA before the unmap
and sets it again on the remaining parts afterwards, but its error path
returns without doing so.

This was reproduced with fault injection: each failure on an anonymous
mapping left Committed_AS higher by the size of the whole VMA after
everything was unmapped.

Fix by setting VM_ACCOUNT again on everything in the range of the original
VMA. A failed unmap may have split the VMA already, so walk the range.

Fixes: 51df7bcb6151 ("mm/mremap: account memory on do_munmap() failure")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 6f941aeb1b5f..256eac721a07 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1246,9 +1246,20 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vma = NULL; /* Invalidated. */
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
-		/* OOM: unable to split vma, just get accounts right */
-		if (accountable_move)
+		/*
+		 * OOM: unable to split vma, just get accounts right. Both the
+		 * old and the new range remain mapped, so charge the range a
+		 * second time, and reinstate the flag on all that is left of
+		 * the VMA so the charge is returned when it gets unmapped.
+		 */
+		if (accountable_move) {
 			vm_acct_memory(len >> PAGE_SHIFT);
+			vma_iter_set(&vmi, vm_start);
+			for_each_vma_range(vmi, vma, vm_end) {
+				vma_start_write(vma);
+				vma_set_flags(vma, VMA_ACCOUNT_BIT);
+			}
+		}
 		return;
 	}
 

-- 
2.55.0


