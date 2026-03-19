Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9141091932
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 23:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B996B04AF; Thu, 19 Mar 2026 19:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2697A6B04B1; Thu, 19 Mar 2026 19:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103266B04B2; Thu, 19 Mar 2026 19:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE18B6B04AF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BEA0D1A075C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:00 +0000 (UTC)
X-FDA: 84564410280.23.9357CB1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA543A000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:30:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QKl3DEHH;
	spf=pass (imf15.hostedemail.com: domain of 3MYe8aQYKCIY68srkxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3MYe8aQYKCIY68srkxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773963059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OCMt2z1jL5wVFi5HOfim8vFneIc22rcNHAIsqy/Chyw=;
	b=1VZATAwQ+fUA+VJlFjUOMwhl9q7qXKgrQWBLVlqngl6XVoNBCI48g9F52p5/77gT1crYmL
	ZmVdCwEJDcA93RKAHPLHzeB8IZQKrtI8uFe4BpOMGecyTiwe/FcyyjbF/FmMTLSAPWIi3K
	NTLRzkgFDjBDJhdq83gbwUQm7bUAbDU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QKl3DEHH;
	spf=pass (imf15.hostedemail.com: domain of 3MYe8aQYKCIY68srkxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--wyihan.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3MYe8aQYKCIY68srkxqyyqvo.mywvsx47-wwu5kmu.y1q@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773963059; a=rsa-sha256;
	cv=none;
	b=euRrirv/BZEoYOGc/uOlt29iNYR7tBX3LFxmoxbNrhsJgJpIRvhkG0mGT8zc3b/8ONR08O
	6KNT/j/5cy7VOm4iTNWdW3IAqkqZ0gI0TIgaT/QPNrbuKkfyIfokrToR4ulBk/3w8hf0HF
	o0+SHrCR5t9IDLjr3RXjxpffaQXlot8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c738bebd53fso285837a12.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773963058; x=1774567858; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OCMt2z1jL5wVFi5HOfim8vFneIc22rcNHAIsqy/Chyw=;
        b=QKl3DEHHnrh2tNjcALpqRRhzsVkxjPb3/IRG/g+1fc9F9GXCXunMoBKDoGT9auCrYW
         KQPq7+0wg5Nm+ugpT4YJT97byJVzL7b0SmzPrkT/B7bwH3v3qGsf/dvNpTKp3oe/EyqI
         Cgc9gh105sAfdC0Gw3R72ldzFWb0YaMTzWRi/hKidsbhCnObF1CEPdbBMJ7ZRTOx5thF
         7/mMMeHYW/dJK16d4reyL6PM6zrJfEmcFDxHTD6l3CBbm2GUZqZdq3tVli3DVgt3BMao
         C6f7MBTWLwwWJvOxjIgylcjOJRkI90v1Spe9C/b9sjGf7kw+CywNIm1WtQ/NoYkPhk9T
         B/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773963058; x=1774567858;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OCMt2z1jL5wVFi5HOfim8vFneIc22rcNHAIsqy/Chyw=;
        b=LffR6TJsqINGQ3dG2cc6i2QTFGlyXiNUc6gAO0VvSB8s25JsAd7YXAu2r3DTpbcTei
         OHmtaaw+rXn21sHpgkC/gVPYhHslHhkCJNV072I1AmVOXJaO9XN/VtRxmycuMhr/NprC
         /St1/fdX3nkfRaFjdh/AizuLp67Oz0KH9vqi0ja+9b4CR6rxMcq3iwYpmKx35pBqSZcp
         OOFQ7LzslEkxGjRuCE4uLkJtk7pHBP63X9yz4DSIic+bmXPub9dHyzDUIP7c5tXL9q/+
         igzGDD+LpZ+k6+rsXpRVb0aANx2HJShlNPjii9gvqEf1axNkrEdhb35aLu9RV4WRT+A2
         NhcA==
X-Forwarded-Encrypted: i=1; AJvYcCWfUeDfvceeAcI0wrNhkkbzfLyfy5d+rDFGLRVDzuFCWnu5YNAwy5sDX5y2UDkV4pxHny2wuwz7qg==@kvack.org
X-Gm-Message-State: AOJu0YzFyxaEmHxPd8Vc4loII1lbTFU+7Bmti4r1RK6vCyXW/yU7RqI7
	ljSzT0DWfm7bgz/QMhTWz/jnkk9sS/reEn9/fvtYylzI3IOxQuJ0f5WYcJI19aJUa8FSB/Sqyud
	kduhZ/w==
X-Received: from pger18.prod.google.com ([2002:a63:a012:0:b0:c75:bd4a:f509])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7d9e:b0:398:f1ed:7fa3
 with SMTP id adf61e73a8af0-39bcec301e7mr930308637.57.1773963057622; Thu, 19
 Mar 2026 16:30:57 -0700 (PDT)
Date: Thu, 19 Mar 2026 23:30:29 +0000
In-Reply-To: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
Mime-Version: 1.0
References: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-0-92c596402a7a@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773963053; l=1473;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=bEQvMaA9O2hDkO+lF+QBqIJNJg07ecLAkODpS+u5iOg=; b=13DaSlI9UabzaKWe4h2fh2HtJjjXwRHu/w4sC/PfYfQR83rUFlAnEp/P6cSUes8BAsTQjFGZ7
 scwG/rZVGLFDn5Cdb0QuA+zOHJK4OdPK+rIY+aD7esoRAD8+cY0a+dy
X-Mailer: b4 0.14.3
Message-ID: <20260319-memory-failure-mf-delayed-fix-rfc-v2-v2-2-92c596402a7a@google.com>
Subject: [PATCH RFC v2 2/7] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
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
X-Stat-Signature: 8ju1hp7tjakmbrzq6zx5biecrjwfzw8t
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EA543A000E
X-HE-Tag: 1773963058-414389
X-HE-Meta: U2FsdGVkX18yQJSSD3nLzg9uGYGh7fvCU6db9c0CDAS4bZhh6pKf4ywXN48y236zmE5vsVQlH9vL4FyApDdeMHCiVOHa0mJamm31LvR/+5kIXSblgAGQN3h4+tR2AiksHEV9lAQWscL31EbCjy7UMD2i/QgBIYSSl4OdbHUUeWyH/xZCUZX9WEwtyC/HsTImkf377TJ9DObAntnxcbLxRJY6sDhe2HWxCXFejfRIm0wD3/6RhTfTekpUkbmhIHoKiHLd66oI0Z4xtRWR9iREmQU7TwMXPlR+dlk0i6LkyrsEL5ebjyGwfcb1drOGLCpqMOx16X4tWHqYl1ksTXIuTAtf9vAtOm9gwb02iGqGT6HGKdiZL8DVD3kWgtrpp1CaqGJFc1iiYC1TKAel1RqmPM9/XijrpKTu9U7zi8UFdvOaQuRXlyeEXxmrYiQSkWTZAEuBQzPfyUyHqEcDKtMWC8rId36Q6TT+dQtiuvz9/bdGCyC5G0q/XMT3/NLtKIdO4HN70n9r8pwk1CfwRdp2ERNdFJF1pu3LrIeZjzZqIslueddC1Fm+NSU2vwvi9qYnwFXrGThNyfedlog4A8Xxsy7rXAqNED1ySkKC1tOBUWQ8n5QWv4P1pImlR2ssOA71KphIQFkcfSs3HqYOEZ/YtY5uQYqF8UKKVbMNVW+p4vkRbTF1in/FmBm+Jxy2d9dqkImZr1TIWgexZtgBcc5RsNITXIE4J3Fz32mFS8S40l0EXRAm1fGypqRkp945acnrjkLigCmvbCDn4OaTodV1gO4zRIh5x3yJGPAFw0DmTsror35Yxt8j64DHMDiSuVYoQpFA0MBir4Swugp+blO9dr3b+BzTmXOymqAiL7WXo263N3GKsn3VO8t5EnOqSIW5rAx1OrAKy0kO/E8GxJFRc1PoFUrdrbfhOqs2TMY/7VFwJSlqe4Pr0IPHrN90EARimlD2hPVDhW/euboU5Ln
 z1/OZxWK
 tcafjnt3hW/89cDibcM9AxXKedGj/JfdJltUxmMCEvY3tOlIbfvzVcj9sLrGaSnhNYN0y3B88pcJl0+1rkJlWEe2w2CYLpE9mzIOtZvXNnMe6zDcR0CZHbmIXCjKvcjYNIaPHUvVgSwfeG2tREMKZdRlM1bZLE3w46OvGMmjHhDm7hylJiC2WVqB93+ysX2pGFMTvZEPNYfYxDJvHvS08CiA6kiJcUovf3IjO4Ko8B8TpRZCLiuOfAhRgqiLfoe3/wKSnqhj4EuLU122jSwS+Af6sUbPGT4XDtyyfD5T/MtsRovK4CnwgoRe+W17m0qfcMooDYdEmwyajjkM5WeUjr3vuXTTFLDYEhSHmpaXiEA9XIxyJ+Be/vV0etq3pJC7/WMMIQ5Rqt9IuwIZ81bBDOtq7+W2qvyokSh2CiJRZsqGhC3+cuYakV46qTch/kbgJUNWjujAKwFgOOJc5Yvc/UkDt97ohWSOcATUTqbceJisOrAjkYiZe+raqg9Hbw/czjtUUx0/ja/ME3ThyB3riFc2Y9SChQucA9tqyLtarJdaxfhKJlWXlRw/2oOv3/7DC1aDFb4V2MF3vO0JL+JGx1+0mpwx0RRURLR0IxM/LyIh/dPH0sO9rv9I3PFwlyvdF9M5GeBGTkOJ8l0h9ybpxk+KOC7C3jsjkwL00yZGno4ulJT+qZzPna6Rbk7h6AZ5K6mFHQ4gNKLSM9bwSg1oVKeWyUYGZ/NikZXLq6V6axOK1TtFAXWUJWV+I1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4f143334d5a1..57f7762e7418 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -941,6 +941,8 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
+		if (err == MF_DELAYED)
+			return err;
 		if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))

-- 
2.53.0.959.g497ff81fa9-goog


