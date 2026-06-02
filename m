Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43106CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C946B0093; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6B56B0095; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47276B0096; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C33F16B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 927E8160D8D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:11 +0000 (UTC)
X-FDA: 84836331342.27.EEC9993
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id BAAFD100010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FOBLjbfq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3eFEfagYKCO8npZYReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3eFEfagYKCO8npZYReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KByQd5D9+h5QFxoMWwNO5RLzWEY8UhS0HfK4sny+Tpg=;
	b=tqGfNQM3VTvKU1J2QNCePtBoLRTHYtIORsotQYZqRFjtM1JBoeQVciNb08RwfhryxvHlYn
	MgsFHtEknTcUst33QAq4pFU9OTWe3PdQzUncP+R8I+Q64OsToXdPMq9sYo9/omGQObiCbB
	ODU7qczMUAVWPcdLMC/2nD2ToOPMRg0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FOBLjbfq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3eFEfagYKCO8npZYReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--wyihan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3eFEfagYKCO8npZYReXffXcV.TfdcZelo-ddbmRTb.fiX@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437369;
	b=PeVBJqWmEMCCGfVAif6eIHGVO+kpFVn1yRFfMikxyGoIwNg4q+i55YjT1wK6l30Mm3A6tl
	8fefYQtO2oCsDOvDzbBt+iD9V6dxbinYW0edkb1k/Ir3XshynNuwtpRZ1omZ/tUGIWXrq9
	Y2+HhupRQzOd3pyNpABmkApXwmV6sNQ=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8421f5d76aaso2765210b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437369; x=1781042169; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KByQd5D9+h5QFxoMWwNO5RLzWEY8UhS0HfK4sny+Tpg=;
        b=FOBLjbfqK78CNDjFeQxqrhornUjjoZku7Ef1E5aLIsq8VERNBsOPir6JiRL4tLAI/7
         LENT7xjnXejbTtid9kF0fYjaoBOrN/dZR5KeaQ8v+dQt7X+Swc554+I3HdaMdwVxmKVh
         6Nfx+ipyg4oXSB3gKoWqglrx09sYyMMVK6p1iwZruxqD0NVQnYeag7S3OgDOpFV7Ve+2
         h53gPB3ndrn2vtgdASN7r5/Ad6jxpCDJFHv8f2d8eNK7vFZvbZKsjmDsE0YqunUi7ke4
         AxBwCSg0P+fNNUaniMVPzyozG+EIPYjTR7CCnScYVOC9XIHUlO4F9Uz5BTZIxrg6bT24
         DNLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437369; x=1781042169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KByQd5D9+h5QFxoMWwNO5RLzWEY8UhS0HfK4sny+Tpg=;
        b=AzdOQAKlmopqqMmYw4J9G3U29bEMJ0tj61ONP4xvgY6NgDsBE3M6c89mqMnGwBw3IP
         tcsVZKLycwUlmBQAsgeVTN2ceBuF0xWFNMicB2ABvo9/UkTH7hTI0RYcd0teHz1CeFf9
         27gJaGqV9FMN6o1T82nFU1WH18QeVLOmUiO+27jbzgfidRcAMy9lHREx/OCZ4KGUJqWt
         8i8a3+T6IEiSnXkUqy8GazV9iNIdq+vCO4c0mRCUAUKUUbRZf2Oz7NyOcwvCZcsOBYej
         iF3Fa7f5dUgiVDtZbDzkNgo6LD+/7+S4prkYsDyfojM6/7PnjcmD7TAvT9hw41XCDMG9
         nk5g==
X-Forwarded-Encrypted: i=1; AFNElJ9XdVFUTwKY8HxI2Pf4TPq31Gei20bQdY3NfLskhTzJNE6cb0j6oVrXqK4P/TskpqQzbD2wZNvong==@kvack.org
X-Gm-Message-State: AOJu0Yy2uEMH5WOQ91bq0xapER1wxJ5nSh2E6NH7UqGOfxN6O8ya8lK5
	2LaaGUwhMV1PkvqjPycwZaXdX0XlXUL0bEMe6+2OCZJnUp3CTRlMimL3U3AafXoM5WlaxQoqVqL
	Ffv9aWg==
X-Received: from pfde1.prod.google.com ([2002:aa7:8c41:0:b0:83f:2c4a:9b48])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e88:b0:842:1ffc:55b4
 with SMTP id d2e1a72fcca58-84284fbcdc1mr620204b3a.36.1780437368298; Tue, 02
 Jun 2026 14:56:08 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:44 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=1543;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=L7ogU8losQ0qpIb9WkPmejB/jf99wccvfK1O3XZC+fU=; b=mJlrN/uELijxS3oSODYirh2cPSOXjWPWaEt54M4JmmDGGXz9+ycPvbHqL2O2MpPVcM6A3OFJ6
 Nb+TJ/2LXYfArqbI0EbK+iXy8Yktn8BPbCJxnp/bU2rKdKwJHdiTrWI
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-4-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 4/7] mm: memory_failure: Generalize extra_pins handling to
 all MF_DELAYED cases
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BAAFD100010
X-Stat-Signature: 9tqyd9hgb5mmyq157s79jwkjury6gey5
X-Rspam-User: 
X-HE-Tag: 1780437369-884609
X-HE-Meta: U2FsdGVkX187y0N4LZPOoajKG2sgGZx17rhRTnnVz5qCt5NoEpPbpwF7mQjcQRsPJiOgdgIqiq1ThBN2Espbsru2g8ODghRqZJpreGcBRPeTsuc1DTEUoL/rvG4LPmkt7Zr9oZ9/2MIOAsDg5EmPVRsC2p8TCEUSJ0zVnt81jsMfgv+LNKC4na6cl9/3k7KQOkgRG0j92oBlhd2Mo3bvcc0fE1MFDUflxAJVsA7lTBfQ0eF1ZT+mX3mG2eU/VwvVGOhvInZPBVOryyRlz3W62VbSLuN57rxoKHh/paU91zNwxU7IhnNAvh/Z3H1etG3Aqud3wq9HPDKGEifGWYbKXM5Jx5SpEBOO9egjhEKyDDaxXB4tVFa1r2dy89UcsQCD7/6vskkisgHR5PiqQRLqMr3qhOSG6+HYQlFXMi8iLJgDPFIukHSgHw7vTcV2BRbZ4hNHRb9lxQClC4n2qKVY8NLO67V/rdFqfqLiVMYtRDW1PcJz91mRYMxOCbPC2Qjvl2cmZQ6Op7zhXH3IIg2kx9S83TBb6kHmJqYvfi0nOXf6goZB+fqjK2FRDMGVHPeT8fijuGhuSlyZEqjUIhWBfgkhNRWhCxY4cWFzXQEE8f7An6lBGNrjMnPDSSr1Jqld0ent9Yy7uoQXTqZsIalv7atmQNzPaPe+KaLL/whNkFhBaTPXoo5eXC1BLLxggxkwiqievAZsn4Oae0OU8K+Q9YV2P7z8Ib9qwZ3/+j5HHxcwpYCKl333vD6TUcBqGpNi3EAFkEwtdOTqVmYxxMK3F7IcElDZ1x/KvOWxbVAr1PppezZMFM6gKyRZU4dkQTY6laI+EpBbKyTxIxlYP1YUJoSe6iFs/zvj8vmt6kPH+GWvkbR+XpRTY3D7eY28VHIc0UK+Ywj3m239YpU9BLtv7IexvNLoUdP6dI6WJHmkccZKFjKqKZPq+y86DlmhcINj7i4zmDwoS7YKWAVS/0Y
 ySJnL90o
 gMiHu+7qYrFjbGJW8vLqPxudFm33blySaRh+1rSUKnXHnLE0tLfneL5B0OrUM06dNrnzghwrByhpF+nb8Tjxm96OCR4yW7uilHl3HrAqkcazF72g3KbCOsu+ykKzB0iTfBO+5pbHjH2C43sP1GKCHunzXcVFMGaPB8LtFvH4+HPM9oO7ajiqrND8weLm5wYFJhdlffoix2OCiZzkjxnqcn/9hFFI2/2SO/9UqrETkZ7AIFiyOdfq5hMhDfo8udQq0u20aG5rk7vzhpjh1cYQjYRqrchvWHlxFW9A70DDeQkPxLR7O9PMuUNmD/QaoX8LBLlWEcK/mb1YpTN+NLvjXWsIK54VYp5i0xEvPwjOxkl83Coh/LlCBWuGvNzNJ9W+CoeScwhMDG/evg8rgjwkBQy2dUUdaTg0Hbm1b3/fByNwuEH5khrJ051qQhZeDap0E7nVzYi4ry5QEdc/PjVQbxuKfy4vFqVg/mwrX1MzXWGThCslUzbtHzp4sYqAUirq/GLPIbtZ0jY4GwQ7SCKvDAMtSs70IPFfhPXWo0Pu7KPD4v2FcwkbvR1Vm33CHBwvJL+FQajo004kSyRRl/Gvp+d73CTl8sZIXDNHBHbQ8nl1ud7fGnZrMRu+azguHNh9169iQrNPNxSh/NnutIQFt55I9ZUpIPSy/RaI+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generalize extra_pins handling to all MF_DELAYED cases not only
shmem_mapping.

If MF_DELAYED is returned, the filemap continues to hold refcounts on the
folio. Hence, take that into account when checking for extra refcounts.

As clarified in an earlier patch, a return value of MF_DELAYED implies that
the page still has elevated refcounts. Hence, set extra_pins to true if the
return value is MF_DELAYED. This is aligned with the implementation in
me_swapcache_dirty(), where, if a folio is still in the swap cache, ret is
set to MF_DELAYED and extra_pins is set to true.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3aff0c981fcd..dcc56bedcb28 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1052,18 +1052,14 @@ static int me_pagecache_clean(struct page_state *ps, struct page *p)
 		goto out;
 	}
 
-	/*
-	 * The shmem page is kept in page cache instead of truncating
-	 * so is expected to have an extra refcount after error-handling.
-	 */
-	extra_pins = shmem_mapping(mapping);
-
 	/*
 	 * Truncation is a bit tricky. Enable it per file system for now.
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
 	ret = truncate_error_folio(folio, page_to_pfn(p), mapping);
+
+	extra_pins = ret == MF_DELAYED;
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 

-- 
2.54.0.1013.g208068f2d8-goog


