Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AEBBCD37AF
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 07:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDA46B0005; Sun, 10 May 2026 03:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E4D6B0088; Sun, 10 May 2026 03:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D16B008A; Sun, 10 May 2026 03:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 681416B0005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 03:21:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBA0A1C0E1A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:21:56 +0000 (UTC)
X-FDA: 84750665832.13.A1CD889
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2979B1C0004
	for <linux-mm@kvack.org>; Sun, 10 May 2026 07:21:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DZ7mKWuL;
	spf=pass (imf21.hostedemail.com: domain of 3ETIAagsKCMw1665E652s5yy66y3w.u64305CF-442Dsu2.69y@flex--joonwonkang.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ETIAagsKCMw1665E652s5yy66y3w.u64305CF-442Dsu2.69y@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778397715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=if2R4DTpWcRo19/tCAWfphYb8a6St3McgVsuZtgi38M=;
	b=77qU38cHlgn/dJrew+inngOLY490CDBl31kVog+IS00edu9T0w5EXnT+gFgBiYocDQZMJf
	w+7K21Q3sDGWDknl55JrdQKOhPGfSa3gA0kQStcM+VvDCeMOrxkgMhWcYToJpKu4PDUkHK
	zVeZx5Iu74NP3Oirx3f/qYqdhOCJW28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778397715; a=rsa-sha256;
	cv=none;
	b=MYsQ7UPZvBQwWAqotMyjptXtw5LbYrhXS6hg7UvFmidcuNXzApGpC40xwfU7ZU2Wt2K68h
	rIQmj/avaSN8ocXIQ3Z0pHxO3LfeVd4N+GArUAg4S0oHkDUsK8GuUkAyBXvvZO2CZO5qX0
	V1PQror2F4q+b9CtYjkB67SVekldVxQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DZ7mKWuL;
	spf=pass (imf21.hostedemail.com: domain of 3ETIAagsKCMw1665E652s5yy66y3w.u64305CF-442Dsu2.69y@flex--joonwonkang.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ETIAagsKCMw1665E652s5yy66y3w.u64305CF-442Dsu2.69y@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c44bf176so3927218a91.0
        for <linux-mm@kvack.org>; Sun, 10 May 2026 00:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778397714; x=1779002514; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=if2R4DTpWcRo19/tCAWfphYb8a6St3McgVsuZtgi38M=;
        b=DZ7mKWuL/38aS+YOcVVJM0mTSHiikySnO/2ACg4rQBAotiGsQfy9s4DCto58vIEgjx
         UekOdkqvrx3uPRCVPeZuafFUoZoz97WyFGJ1HCboERUIdAqHZq/KSzODM0e/JpwXeNmD
         VpxfgImc6jLX9xLG1CQlO54KFhUvqQdQss6RxpqB5V9oTP+fFLjxFTs8X6RNkWFdeAEG
         PRTtzffJ5WPc1SK5epiTI54ZtAfMDAlszAGz/N0tzq3reyT8vyIrxBUF8/0FDb9YRkCP
         1U9YAzKQgwdEuu9qbEhVvWrEvH9wammLsvuVTXqgoXN0QzUhJQOt8Du7BqsJ5MNkVyPn
         G88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778397714; x=1779002514;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=if2R4DTpWcRo19/tCAWfphYb8a6St3McgVsuZtgi38M=;
        b=qSperOCahMkormZp4hN3zfb0hYuQ8wT/GVwQbyS4nYwMOcorJbR5uoJh837GpSLbTr
         pO7dmMI2q8nD38eMZXT8kMv/6XNToDB/FQU7c3K/AzuogWBUnt3wkWtthKLTqD9RmqOI
         nXY1sIl7JclUrJE9fJAdPopVzfI7zduQrtOJzdC3azXcu71AApFNilTxZQaeFiJ2FaYT
         qDAT+ahD4E9wW5YZQwhp+Mk+XzX5ZLw58JjXj3XItacSr8dR04HOxbJKGSJcmK8trqW2
         nEVv/wokqeu6DIP/gzlETDBYraqE1CMVogN05u+Gl+46iZvXZd7QNP25zBxqP/538JQ9
         vx0A==
X-Forwarded-Encrypted: i=1; AFNElJ9wemit7eeZyc82AqYxqB31Rki/KEt+9sS1IgBikwoD/tRNHiZ72SjdT0u/kQdqdFxgo+Qvo6MWVQ==@kvack.org
X-Gm-Message-State: AOJu0YwAit8mrLq74yVn0k27b6uZu9O5qydn3AushMKdRMB4ReR4dqWj
	6FivyeFIbdorznts7vXcBDNcy2qVRsK6NgTqaP/uKl9nGeC4HcAmj9gx+lFXvMEnO0NaL4G2U3h
	8Es2Z54vAhwSzfybqmk9VDnRzMQ==
X-Received: from pggr5.prod.google.com ([2002:a63:d905:0:b0:c82:283f:132f])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d004:b0:364:edd2:812 with SMTP id 98e67ed59e1d1-365ac7a440fmr20885008a91.25.1778397713827;
 Sun, 10 May 2026 00:21:53 -0700 (PDT)
Date: Sun, 10 May 2026 07:21:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260510072149.1279887-1-joonwonkang@google.com>
Subject: [PATCH v5 1/4] percpu: Fix wrong chunk hints update
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2979B1C0004
X-Stat-Signature: 3yqnqijwokm7jpxdce8mkyfftz767nwm
X-Rspam-User: 
X-HE-Tag: 1778397714-276809
X-HE-Meta: U2FsdGVkX1+BOwvhiGfT93bB0pOaDoE8V9Qb+MRSJjBHoi0KLUtSJ3pHGQ6lPsSS3TRKwN1VNnH74kN+A2S10VXTEHAz574s/B6lbzOPoicPK2dvqi1iOTJHVk/TYfiIpDQ1ynENn4m+xe93PARfxGlFs+DKUhTaRxfpSGPQ/VasVHyhlF0C2ENaL6V2+JXS0K4mUQ2R2F/LL81ATutVlaBA2fKiSP2BASFt/LHe/b6W16gWEOv6NXCEnZEZUAvwJSKdMTc6Cze96AXhMwHq15PHLtF/0K5/5ifx0suKH1bcSaYZ8B0xhvPdTHzEDRFG9Cly22F/dc138ZCKGAjeSRqBKKJzXqM1WwPq/B40K6iCeodfqV8yfY0wvd4fYzkzk7TL+BtM4rSzbPPmNqtKMtnzXW8FI18n2IgzA7VybdDv2bUm+cP+9f0kJONGolRv9Y45VLzrrHH9I9/kB039yWUL/I/exk6TIB1oz8Txo/zUKbkjf/lRnWqb25ilf+YYfU8CGSwrhptqJY7Sl9RJcyRePrKtQljgqNbLmqYsUqoPWo1FS6oohJhSYEC8NS1lpNAlFOx9ybsbSleTrFUSH82NX+lVtN40iRUUd86oDWoW0ut2HZEx07rx62AWY9iPcp6IvoM2ceAR/jLW81s+09lv/utG6MHSWIyjUSPUyvYJqfuuFsWVqXRxzWiY+vASY9UvP84MaMCS6ONEtSd4AhUs556NMNrqHkt+ynIrVmIgjB8SMEXQ4nTtSIrW8fBaX/L1krRGa/5FTkXFo+BIzhyF6CjxqvIhdlSJwCUC442IGr2FK74N8NhVaGTlzZWkb3i4EML1Mmmij4WM/Wg5aJPvfFDyUD+wfN4CT9JpTmCx0MeUV6c73hX6tMHHZNV9d90Pp81fL1JbtCrSYcgvh4WXsEfwlHxgUbllWc76/ub6LKfhwnmomijsghe1WhE5pVSwLfgnrogKM/AWoK0
 8mjKSaXD
 sR9/lojMDmfpPyCRt/dov3GfHVLp4e5w6zsb9oMgiTSs1KUi1hOjMdR/pJKlO4qmx5TSaXXDSibEFyHsZG2ME7PVIy1BGGJ8EvIBihVXxZVeCYD4d4C/Lg2JuILwnIId8MH6agZUO3E6MigK8VeiP/iPHDP6GDJy0E/dMdvNjWFN38gBprT2l1nrCXsZhkcFtH1C5BJIimmdomOOzPzwOdQVkimhKvqSpkNbYu9pX3SVkfGsHJG+ogYGUe7FmaOJpGe7XEfCmusZSUx+/cQqVzPv8fnuH4JilFHblb+yRLrERikKSJwXnIyWpVvOkqvs+1pMD4OEs1pqCPUni/dpTx05nkfh1rm8eg/cK++INacnS7rNwBDJLKylXCzwQgf5vOOzDBpvxfaEmV4Z2stYPSEY4ylU6IFRUp8Y50usivj0RYoeNQpjXG4qEqZVlkquYGXadgc5DbO9+6uTZEIljfTaVPbM8PDIMOxpAKVhL441JVkPDdx+cx1B2LRPuQdrD+/j4KbMSvz+OUvK2fh99r3Nb1su6sofqfITwNFjUVsXPE/Fhzvk8R/qCvmwRv18UCIhntGN5LuD45XeW3jvRnRRFOUpgCvjGBzXZ3oAnlw/GWj6Vy5wVQh3sYrq8usmP//+owxgmglA3z61U4e27z2Vpk95ioU00IpDyviiSP1om4UQYc/cJxIY6/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chunk end offset was set to a block end offset, which could prevent
chunk hints from being updated correctly. It was observed that the chunk
free size gets minus or shorter than the actual free size due to this.
This commit fixes it.

Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
---
v5: No change.
v4: Add Fixes tag.
v3: Initial version.

 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..3ecd86096641 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
-- 
2.54.0.563.g4f69b47b94-goog


