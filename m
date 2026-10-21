Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529D0606A330
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Res92e2P
Received: by kanga.kvack.org (Postfix)
	id 576BD6B075F; Wed, 21 Oct 2026 14:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE6C6B0760; Wed, 21 Oct 2026 14:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6CD6B0761; Wed, 21 Oct 2026 14:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13E356B075F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:24:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CC7A4068E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:24:32 +0000 (UTC)
X-FDA: 85347458784.26.FDA2500
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id DFDCF40008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:24:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Res92e2P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of samarth.colleges@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792607070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C8k+JbJNU5IGiHKVYYM+eJQgIjguwqcbHlYgMrCENwg=;
	b=G5ddMC1Bkr6t2UpbRriWiU9rOwpIuPD/Etr2AUwFgiHRypmgvfe94Ju/iFFy0dOJk++50g
	6qXYyd2MLhKOUcycze0YQ1pIn0UezCqOHCcy5zNoP6Ioa/1FwLUuFiz4xin1Ci2s2eLkoa
	TCjtKNioGVvLOcuhBryJP/x0sc8ixN8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Res92e2P;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of samarth.colleges@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792607070;
	b=NRtaSr2A+6n1zzWHt3BVckGviB0s1eYBIAaS0qcPUwBSzuVd2uO/8IWxzFXwbfGCkLZgZl
	XywZC7gsfO4IRWT5emhRZW8SXopfWw83e3euRnrU1ZoZFJq0uT2zHIYND2lGHcBViZxDIu
	MYK+/DOkS5Aso0wF1kgb6n6KsAUD8+4=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3535a54bed9so1397675eec.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792607070; x=1793211870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=C8k+JbJNU5IGiHKVYYM+eJQgIjguwqcbHlYgMrCENwg=;
        b=Res92e2PXyRXAcZx/syEU3xjlg8CT5JVkLpRivAcEV+PYOeBHMVR826ztFmxiAarly
         qRPh8fWbCI62EchKKyO2qgmiUD3lfA1uHywn2l63Uytz2NvZXuI2C28njWoAzpEt+iL/
         Ag0ao/fjjZXMN/4uouKTShZwi/uX2TD/dI+512qrh5ZXKuuqrA5taoayY/PhZuIxKl6q
         Grdjq8NWVFYdEzwKlB3jzONDP34pSrwqY/Pw1OcgUE7iqbS5CeN5tPfE6vZC2HHo0cW5
         9nCgDsH9bjRYyOFylTtKub3cgGEwe2w3jxGKhCBrLiAHSFLv/tf95FvgB0KEgnkSiXPa
         aGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792607070; x=1793211870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C8k+JbJNU5IGiHKVYYM+eJQgIjguwqcbHlYgMrCENwg=;
        b=FSD76qCRsjJzoaLRIViEI4/i6lnOQR63Jdf32f3xoUvHoKYqzAO5zlanf4s7oUSz+v
         kKK5iRETZCK366jS0yn+nvvqHVe6150bPq9tpteChBNQLgyVFd1sqcUTFv1sPr7c6MRt
         tl/BIaF2KOArNVOdc63YFbdkIDBR/pM6I2iPGE+YM1wToUrr8r+dF3YSFep7+u8i7vhi
         908NBIakMUKiIiqcYXtzYanQEH1VYRP9B0saL+1g4JNsl9tW3eaCINODAlZKCtV3IbY9
         09vI8MWKhVHl28Y1Iftrl7cML2BaE07gQsbHx2W5EhGFTXY7QathaYz7Asw2+qgqpWtC
         JJOQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXATd/P5tDwoLkmY+OqSati5ljtMdVbZVdnMO5S6ppsPjgMnD769AEsz/4ktAKASaWPjciXXUkEA==@kvack.org
X-Gm-Message-State: AFq9FYL4qMeNLLIdLtZ35vD+cj5o+ZypqpcYQmZ02EUAhmJW8VvYvARY
	YNmbMRwXd/HFlSRlhviQeE++s/aQw7DQsWc6aoTwtfD42D2IysKBAhO5
X-Gm-Gg: AYBFou3L7hZimWzh+Ai3QmvYddpPz6mp19lS0Me9J2yYlRVVaFg1zS7OdUvdAls18ow
	ZSU5phDATOZF04v2+J3IEoulRfN8KVx9CaE8JIzTUkC7lU2FwdiFB39tRL7AKRWMQh1kdfOcW1D
	o5R1YOB/Z9BaIN6LXl8FPZSCvRt4lJm++hJR2Vw60MshIwlr/I3fgSXVz6YLyROOmiFklUwfcjO
	UtUrleWR3dE4zUyumbbnN4S5/0hW83Mme0Zl/5YFe6O9IE8by1Nvo10Q1VetBF+J2pMSvzsZGIc
	HA7Ml2LSN+Ej2UcFmIXqveJ/iSmshXokkM/xskp2CR9TbxPCfsBiTSMdK0a3Zvv89Ig0UbWPkMx
	npadnt01maeJUOl5vVwtryhcvmpXBjj0hbYYlhRFqj66C29SXEu2/bkdVR8qRuMraCPjI60O38j
	FAihEfyOKq5Iqr1biIuH/hkDPV5p1rwvN5wQS+17NTw32YpFWvAoginUAqs9DYFSM2v4+b0eYA1
	tqtKBnsVtWXmY/VTov6lwzyKfgqm7gSObWEu/L7YPIMZQDUU8EMV/L2Q1E15gVqn3NYPeHDf8Zr
	CrK/NGpR8tk5aC18IxhvUomrPlSb8hRLkqPtYg==
X-Received: by 2002:a05:693c:8399:10b0:35e:f1a5:9ba6 with SMTP id 5a478bee46e88-3674a40738emr4497258eec.5.1792607069610;
        Wed, 21 Oct 2026 11:24:29 -0700 (PDT)
Received: from 1u1g-b650-0212.nvidia.com ([72.25.70.131])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cca3d8sm9107228eec.14.2026.10.21.11.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 11:24:29 -0700 (PDT)
From: Samarth Narang <samarth.colleges@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm/ksm: keep soft-dirty when merging a page
Date: Wed, 21 Oct 2026 11:21:57 -0700
Message-ID: <20261021182157.1873726-1-samarth.colleges@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFDCF40008
X-Stat-Signature: m8p84rhhedm37sok4i3846jr6fubt4yx
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792607070-393790
X-HE-Meta: U2FsdGVkX18p+YpAUC0v7ph5qTWDWF0D7goAmotj/JS8bM46DQzPCHucq2yGcEHsF86G0+tdduapjntZDdQ20jk4JPW9YKDz8ot09SgJzidpamndIk6GBQq43+D3bwWVn4HN2VvHr0c9NlqhSFZiho0BxlhO+xpUr+4ollt2nWrVm62GMUxgVf+v+3IPI7/ZGzPUifa8ORIomnsHqY8Sn9V9tnXn6N/wAjO+S9zCfV4BEurZYsXEU0iVDOFkMdQPvETo7fSZ7wJLyIP6xGq3cq2qiVH6SymTpiwveu2PBfwwjhP1nQTOrOSvWxfPg9WvcYyxPTaGHwFV9x8XVad0QsSSVKLOr9dqBLq1Omqm7tw+Oq62sQx3kZ8TdjIvTak8caAc+2MhbY8KtLqqv5h1gn6vJrcsI7+V95HYO6FlwmHmWoKS53xnlmG+1IOcheN+QzOLYK/6wjlylnYAuJe6Nr+PzJnKkZ4TTOClnsx3JZy3iC7dSYyccaSbR3Ser2zSLxMWa9R6cRIAZmQgy4m05Xbw32qVeRG40BQapfCItpZV9wmsosbKC3NWH1TtYaWw60/rD8uwKIsk33qZkZ5nccCrSUeMtMTj+f7AIFE9ZKcQfQZGfrbEj93lSqz30W+YTO2f+ovtfgKoP0+wIJlwSHCPnU+cUzwp3ivn/S3YrOEgMQpBm83yS7rc0f6fEbNncGx9MqycuUtZArOQ/ObacSWi2w7D8hvfz1kko3/otBYZjHGriT5l7G4xyILdpmcmPkhRKDujq4YmwHHSIGWgTN0G+B6OVu02gJfAbFqMZjN1GgablSsuSaljjAu08yQL5dC2RgylQTiffpuVVdB9IZvWUwbPmc6B0rlNWjGH30TZoE7N+xw81asa5NWypYDn4jtizGqMY1X47kYBElchTbKSzaRTEOh61wQivz4NiVTMlLFG383/yTZPy8OLh9mw3PAU9H1Fm8Eccw2azSs
 Z2n1boDR
 rg1x5EgE4BFNrzqoHcA3bCy9BBbM9Z8ngxtoIjp/04gNGg/djS6xLBarTSG6pkVxFPQYHLv2ti3o/0h96RjEi6S4kLw+HLQceOt7Tq+AM9yJMQBwE40rK1oxV6eC8FYEumf8w0brX0gVhdQ6VMAnc2sCCYMP5+LC+C8MtVezKb7aThQLdq0nfSsjCi0p8b9HUKjQva79rdU2X5TBPOoAwmPcU7SmlltaBCY9n7hx4Z9Jk3ltd3mkG5LO4wslDa+6vIweNz5JUWi3MaORgeWA9hv1OryEJuU8xdx8jx4JU+Mj8tgRiNfVZyOxcQ4oHnpbEZBITH1qGF43VaiysTTHspOWLtgvRqptPbR6OidPUAwqHyFBZPQVFsq0KtU8ddhI+2aOd8AKR2E3a0fdgl+WQlCIb+LO/3VR/xai0EDHjnd0u3CC3rzZDchRJHgdLO8GOMmbp5/zqGwz2CdWjRLsUOCZJf+rXnP+ZrtJXqMsvnQWbqIDpJn6Dz2uBhkL9A5Emp46c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost. A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and
a soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
---

Notes:
    v2: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
    
    Changes since v2:
    - Keep only the soft-dirty fix, as David suggested; Lance will be handling
      the uffd-wp/RWP part.
    - Fixes tag reduced to the soft-dirty commit.
    - Dropped the Tested-by tag, since the patch changed.

 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index dbfb8f98b189..910a1307ac9f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1463,6 +1463,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another

base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
-- 
2.53.0


