Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984E7606A338
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=L9VTCpGL
Received: by kanga.kvack.org (Postfix)
	id D85FB6B05B6; Sun, 25 Oct 2026 13:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10826B05B7; Sun, 25 Oct 2026 13:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0B06B05B8; Sun, 25 Oct 2026 13:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9066B05B6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F40B51C3DE0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:27 +0000 (UTC)
X-FDA: 85361862894.04.2DE3C23
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D8C540007
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=L9VTCpGL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z1nKV9RROXIYz6IEYr9bUViL602rE2TVHzP14wnkAeE=;
	b=5jAv1sw0RI1l554oXQym7npsqcz/V42SSRgjNoA7l0XfvWuLih8d1xCAy02aNonr0ynGXQ
	XwoYq63lioJQMH0pRcWKsjk69kytAKDFfxxUWBeRri1orfC51fhej8MBXo7WqrVHgNuRpZ
	fSqduUzhHe10VBgPeF4Tahedy/Dd4rg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=L9VTCpGL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950026;
	b=hbdLve87zjqwx3jgAub/S1ZBN0yUTgM+9rjuxJx3wEx/xXFRUXAlOJMDmJCw1jAaw7G6zJ
	U//Ya836GLwl1JjR8ALro7PFU+YLFdrX5zsq9y/xQXEerwR9dh3hd3zBHP+BEsuWVSb/fx
	XBCaNg06TqmZJsYItBNIc/royHSmDnc=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5eac01ff101so962827e0c.2
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950025; x=1793554825; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Z1nKV9RROXIYz6IEYr9bUViL602rE2TVHzP14wnkAeE=;
        b=L9VTCpGL12BZvsVonD1ZPFXneMLR+lfpoSDZC72PtsPwa0/g0BHHpFqhBGWGvybG3h
         FF5ZbuF+RR7ppefwZS1rCrTVXTGCRW1I0Go1yp8AEXsovZYcbKowRsp1psJ/VcxtnudF
         3hn9Dde7RsPDCLBBtRCSdn7P8HXIl3FkMf1FVXHIhX7iOq/IcsPPXe8yse3IjzgZbMWX
         F8s0kNS1B8pxWpxvKQgj2FyZzpCC5l4ovOOc245kSedNf1Q3kwnLhO+bgkD9oRjc5zAY
         E6qDPImFm+kjXSoXbVBogHgIAI1eIZGUicKQJFkxCpUv7UKhgwFBiadDVCVVvl0VmNlA
         Mcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950025; x=1793554825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Z1nKV9RROXIYz6IEYr9bUViL602rE2TVHzP14wnkAeE=;
        b=UvhMP6LO4ShEIktwpSttLV/CjtbbotuNiLf32u1hN9WjcDp/0VoghX7v/PSqFmVA2t
         SotqKEGsV8NiWIN6a6fQgJ8ZtzoduQ+5ChV8Jh7r3eocntE1qJvLZSEhEI6HRsx4x0LV
         xQ+y4CNz7OiuqJpovoLpLg9QnWYWlPAaWd5LKtwOW0Trg0YC7lFJ8RYAiC7+oVo+b7H8
         gV4udpTYtVYPfSNx6shtskQ64KY2/ZbppvTQqdUo0FJP67oH/HcM3r2se+Nd4UpQczlk
         peMZphe+Tkv0/gnx/POgmnPYGhQuxLTS/To+DC8ph8cMgiTmLNFWvtXb3//n8ILc6l73
         6Lrg==
X-Forwarded-Encrypted: i=1; AKwUvBxwgHbe9qFtHi/FF3c2JjH9qdtzMv9cGBilChpR+NF+AeOcAR1hNwue9Io06zfeBX1LMQHBdT37FQ==@kvack.org
X-Gm-Message-State: AFq9FYKeT2kN/oC08Cwd3uc7IwYX916zWKSYbLtiKyfUqZBnyfklcWNT
	CdbIk76Ip6j9WzzDJ6Ar/yY+/9fUHaqsTfBmzBmcwXLqkQHXaOz3ZOKcmD0Z2FBaecA=
X-Gm-Gg: AYBFou0rnQjb88QlIChI8zi/P0wEQ2MaJAuqybKjuPLCVRsJEyl6JGAlBr3lfcawONP
	DMAyOnd4xjoGb0pZ9+Qs8RtzvI4UqZCtLda9z8NvYpuMxN7a2Kh98LTXAl2Czqg0Nb3A/iKOb9x
	guHyTG7sftyRCoz1bggzpncG0ooCHjA3JPmh/D3sYm/1cNRKaZWV3iUT0+qxmm4wgVyAV/86+fs
	6yQu9QAcA+UmpjHRIRXp2b8NJqMNwd0OclGxPdOyg9fvR+pY/J280BqyXaiv4He8fTYrEKORU6q
	vBcm0on/PyRWbpNnsrm8Xa8QtBF7PnbgqmkgtgCOdGo2zI8AfNKuRBxhbnADNCyqTIUF/Rbtt3w
	9Kac8GLsijKJ0vn2q5XxlEEx18SPDJYxZLtnnaCpcY6R6Ptdd5kJ4J7TKwpGNxSJ7nffNUcQ0KY
	4T7wlGqsTy5EWFacClkrc6MLblJmYXdGvsvi+BuZbrxOKPX+Kw+a0mRid7ewfFp+RCWgdpXxvFc
	oMXAEUTdnjKxBZ+tDBxaXBPSXkrDVEUiIArN3n1/OyQ+yCsYsBPcBulXMHqiYzmDZya+403GnZa
	OoeC5cU4yYbujkn5GaWbYxEC1qKydUJ1hrxy0tOnTgljmUnWRefAzLDnabqRwhKAhXpjNBk1vW5
	2
X-Received: by 2002:a05:6122:83c3:b0:5ea:d1c4:7cbe with SMTP id 71dfb90a1353d-5ec2332c72bmr1427722e0c.23.1792950025414;
        Sun, 25 Oct 2026 10:40:25 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:25 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 4/9] kho: do not modify incoming serialized blocks
Date: Sun, 25 Oct 2026 13:40:11 -0400
Message-ID: <20261025174017.3870481-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4D8C540007
X-Stat-Signature: sjrduqxne8fxtancz83bqnifzmu1gkz8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792950026-344088
X-HE-Meta: U2FsdGVkX1+25sZ4LBV+pb1QqHOXFHzRm6Rxzdq7tZ48tPhKRShFUWVDrPvu83++wFeFvJ+Pdop3Z1NkDINiZ2ai19DGZrcSI4N5k5FcXHMIaRHXcTzECJz3ejuMQOHwLnu5LzqR48yYmChtxN795FXIAYUpeKM9Rd9GoIlLxUUt9Z5um4Rn6TFt1Lomn0Q3MwZR88DMng8UDBURfe2RK6P/2nWABD54B1pudd6d0dFR2Og8yaw1Nzjk32ZJrObXwEpEuavO9cb1QDU8c3cvhKILdj3weaWVJtG+sZ1VjyppVwIi6GEhZyeYJWjYKkk3tgLeOBDgEte+L7iHstVEC86HE8LJV1KwxGWEzMA23tWOHu8DABNxiJsYRrdOEHg11ZEJpo0U+M222AW94fYxXGg8UEh3LdVajulLq6bsaxpBMe8eVC6eUncf5QNqYUKd8K2fAh9j75aNNXp58AmklebcuY0+odxVwPtCrUaP6kz6TewK4i0Wc2VrMaQ82IFMAWSHjl+2/zJa0bZYMyeSOJZmg3kIm4oCkX+BwJkfYfEH/6+RwzV7Pnpf7iJR3ch7cMIVYN6o+1yEhbnAtdcapEDm2EfE7maWI/Xtpx5WdPEM/McpGgceuO7atJTDvxMePld0OYO7YxkqxCHSJf0c4LNoRxq2RVx2Qr1hbE6cPXkCGHyWbqZpyh5yBgVeiZt3sPly2Aapeh/xJF1jcB7wGCd6Fejfoq2FEq7Oyj5/7cTf3bMebImsuNWHbNvNhV63ZlQxS6ruDjcsnF7dyGAT7O/+yaILck1HOEtRxtyNWviquHAgFw65zjT/J449yYnobhs5N0a2TZIiZ0oHtriN1FSL+J8uEWwPx4fhzmO8WbKD810YjzyS0JWgPM3p+8Dm7QZMbtqOawf02Ydn4D3J7UFq8IhewZA5FLU//LF7XQHC0TonvPAJjIuGU5XsWfMj5JSkcf8K9KFplPeAyPV
 fhC+s4QO
 UCWkksBcwhwrHjm2B8k3Fg/AlN9jV9yD6OINW6fWBDHH/sSg5rmYYb06R/X0Ud8OWGydcUriZ8a6boxcLyjdntZHu2PPtQGg9GVzq+1oe/q+QjgqDZ9NYt/540D+DkeS37k/EYHadNbtI07Xk4p8BgygPDARzd/CvIYrqkhGonIyDLCtY0XED8zQJ/L8C/DRRXggpUAsi6RsTNJ8DvquKiAO9rf/2nd60KKmKao7vLuJ9KVUO5qnA5b4zsyFrIGxoMyoKLSDvHfRmlxT+CVjmx57QPJJdPGvcJalPDi648+4LXcv3RyAb5L+UBJn6piI7AJzVTXcdpuTSuzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When restoring an incoming block set via kho_block_set_restore(), the
physical chain of blocks is already linked and bs->head_pa is already
set. However, kho_block_add() unconditionally rewrites last->ser->next
and bs->head_pa, and kho_block_set_shrink_one() clears
new_last->ser->next even when operating on an incoming block set.

In the upcoming KHO read-only mode, incoming serialized blocks are
mapped read-only and must not be modified. Guard the ser->next and
bs->head_pa updates in kho_block_add() and kho_block_set_shrink_one()
with !bs->incoming.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kho_block.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index 0d2a342ef422..a4e945f28fad 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -93,10 +93,12 @@ static int kho_block_add(struct kho_block_set *bs,
 	list_add_tail(&block->list, &bs->blocks);
 	bs->nblocks++;
 
-	if (last)
-		last->ser->next = virt_to_phys(ser);
-	else
-		bs->head_pa = virt_to_phys(ser);
+	if (!bs->incoming) {
+		if (last)
+			last->ser->next = virt_to_phys(ser);
+		else
+			bs->head_pa = virt_to_phys(ser);
+	}
 
 	return 0;
 }
@@ -133,10 +135,10 @@ static void kho_block_set_shrink_one(struct kho_block_set *bs)
 	kfree(last);
 
 	new_last = list_last_entry_or_null(&bs->blocks, struct kho_block, list);
-	if (new_last)
-		new_last->ser->next = 0;
-	else
+	if (!new_last)
 		bs->head_pa = 0;
+	else if (!bs->incoming)
+		new_last->ser->next = 0;
 }
 
 /**
-- 
2.56.0.307.g5fe7bd680c-goog


