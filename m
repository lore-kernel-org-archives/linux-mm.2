Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9221606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r5z7PVAk
Received: by kanga.kvack.org (Postfix)
	id 744116B05B5; Mon,  2 Nov 2026 03:11:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4606B05B6; Mon,  2 Nov 2026 03:11:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC2A6B05B7; Mon,  2 Nov 2026 03:11:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E76D6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:11:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B8161A0C67
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:51 +0000 (UTC)
X-FDA: 85389460422.24.6FF5308
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id D400740007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:11:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r5z7PVAk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793607109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAyyYwHdR5Ch5uO/F1MiXirGDsn56GrI3GAO8iDRceA=;
	b=s2oXGnowLRqNAaV2W3zRWbmoh/ncmnxZGXxVJXM6pNhH1LGePvPItmiQJT6qYSfE+5zcHU
	G1cb6n/d10MQHMToo+45ZZlaqy0g9126h9Ol27w2rNI9xFSXcLxaSn7WruYmhBcINSep4P
	r28TuWlLODHQBLRGAvsnbefbMexiEo0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=r5z7PVAk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793607109;
	b=PSSuI7M8njwFsB0cmb5lVaISvwB26tIlHnVGDSX+py2GZ3CJ4ARYIPMn0uBFf+Bvl/15Nn
	ypEfXlGZUvJzDr6QFgJ3fOeAdGY/bmox6DZVXwRWTOS4W4DPooSaLjxp7Sy1Bwq8cgt0M7
	N/l68wD11JH1QdzbTsgNngnxmweuHK0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so20551655e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 00:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793607108; x=1794211908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FAyyYwHdR5Ch5uO/F1MiXirGDsn56GrI3GAO8iDRceA=;
        b=r5z7PVAk95NWEEExFQZM9jypvLtqAWVPJVXYqKizTqA4F3IYfRug4Y7byXoBLRGb6h
         ++mC7OQwWx9Gh2V6sGvSpAN3pHzEZ6+Fh//usu19ER9h5JiYojifRrVff5CX0nP/1GrJ
         I2ItLXnl8jihCE1ADQQ+/jXiD/nEwiDQXr43/2YSKcPGeADBSz+CjjrTYomhrsq2UWO1
         sRJ4CLo4qfuqG4+aqj4sBoRyEgxDq0i37usFA9i/+XKv9oRnzvmaDgAOVNd8ytHYvXzS
         KkGVCpLH2DFBWWG0Ry6Ah633dWij/HOodD9PumgNRMxqERygidFBaq4ysEAGTntEsFDf
         rz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793607108; x=1794211908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FAyyYwHdR5Ch5uO/F1MiXirGDsn56GrI3GAO8iDRceA=;
        b=V86aFSzwtKSayJp5F6Cn+CKU30DrJdwPRadquZ7bDQMmtLJWrn5hXo3ioeG4WGsAgR
         uC8Cx5oePLWhNsGE4qK7ITnZVa/MWCpzVHDF2wmIEdxjHfdPiVvk/mkJ9zSvCky+GDVj
         FZPFWTN59mIFlm/Ji6LlJ9/xGMJbS9t8UDl9/UZRYXbmfGhmVXDGRkXqXo82PNYOhgR/
         5iYGrB5q5A7u8k6LeA3BjGzTy+IOZZSdM6IeR9SGKEARPnJ2/GaHZQUonXfdM4vSvLRj
         kla4SovbQuu0WxNQwGU+CC94ggDTKb0H8bwwet+mL1f2BoHqUnH0ybAMsiHvUzQrfEvB
         JtVA==
X-Forwarded-Encrypted: i=1; AKwUvBwsqX7JyIssRYXIC1E7lM4t0uhHmckHPrUw5UQ763zOxfCWNReEeoItkjMWJ0Wo9zBYBfnRt/1msg==@kvack.org
X-Gm-Message-State: AFq9FYIoklgnMk7VUNuWCVCcyQ62BA8AVuc2VMF7e0LswnKDWQYzy8JF
	xRGGScRl6z+OeMLB9tzmaK2W60SUDm2+fHVpdAwmU6w5uUpGxUOuvi3a
X-Gm-Gg: AYBFou2doNc/QgH/NvdJPd1aBtdhM+rC75ZNfOAo39qYIoj2YlhaDnKqhPlN6vN0aYc
	s3diDhrr5PfFuTSX8dKfDOkuegqLUDanM8QSoIpxMAEos+Nc1bA19GOYi02aBVwgcaGAsxAcfYE
	8C4BtOeVV5hutsYScefKVLRw3+GxWX5oUieVfisFzGf5oYTXdJu8mr7FXgHmm5zrivcEmYVrs0r
	7KZV/gpqwDc6tzuhUTUhwoGKM1UVI+ji/YCbpBzUUC12fnjL7HXp3TQK9tBOwYYBd1iZmZ2PVpQ
	w9Oh07lrH7SndQ0M5ssRvjuZOpc6iZh66wN8PhqiSKx5cff/oQYmUhsqUjkqnjlyR2n3kSCp0wA
	SfeOUZiXYWPNA4Dth9Lf5jNfQH8ro03q3Exc2dNCakeCHDqBu2oOp4ngAkW7y5ukBnZ/mJfdbsN
	oWPi8YXSTETyl7X7bGwEQz+US5DnKvv1HFNF58IUCXgUNsa6E9e5Mm420LgfCyZ5Wd2SWyXdEUF
	Ztp5Xhhvio9zLfz4jRju97wausS2Ysxy641+ss/n4EiPw+q01dlXCI/wcLF3meamBRtzW4nWzI/
	4fv1fVawwH3vrQ==
X-Received: by 2002:a05:600c:a00b:b0:4a2:180b:3153 with SMTP id 5b1f17b1804b1-4ac185bcc7dmr226206975e9.14.1793607108359;
        Mon, 02 Nov 2026 00:11:48 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa8213ead6sm333331005e9.14.2026.11.02.00.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 00:11:47 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/userfaultfd: recheck WP registration in the hugetlb UFFDIO_COPY retry
Date: Mon,  2 Nov 2026 09:11:30 +0100
Message-ID: <20261102081140.201987-2-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102081140.201987-1-azpijr@gmail.com>
References: <20261102081140.201987-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D400740007
X-Stat-Signature: dayq8segdzc8ty8p49d5rk33jfh8jmaj
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793607109-939760
X-HE-Meta: U2FsdGVkX1+ty1fpRFEqW1UTCL3iYdnaQs0ev13pHcWuSWyhGA1v72vx8ymHcBTEFlxezRtIoepY+NtrCKAadsxZUl2GiEzR7JgQ7PJynY7l/caxwSgBuHTVvOpzrSQH9rJFIzJ4I3OX3mGSiOhkM4MGsNg62+Ump3V/991Xz6u9wMZGiLrfH4a//RUsFyHfXK2CAPqVfAxDVMkpBjZaNoIS666xjmolKB+wH6Uce21620XwdwwJ6D9FEPMrVFqaK8nHhl1iuMonItd1IUZ/HNNRVPQBQHUkXexAtTmNbmbfSarNxWu8w1N1M4XxNg/XEqAc9/+SWeFAubxdn1Sycz7DokusyPKGeKf6aQMcGQ4BHPXNhdMI0v/dSJG2Rz9QCtBnOyJ/QAOTsx2alEZD8ny5P2iBCGJxSTGM4iO6KRVvD9IrChCdJJx0cW9dF9lF6BPfkHFjEEUoUEYBBuCotBBro+zRB1aF+FIkQMpwxs/+grwZvttdzCcftevR/zsVFSFrWS+GOvfe0SOzFrGGIHWK7venHgmCrGPS6+Mu74Jzo8VtK3IPNxs7I5RfaCeFZS2bvMGhgeQxi/09n6GkJRmRgDGmE0/dRIZySNsJuXMX1flzoSP83CPKoJmenW2pyLDd/u8NjJrfvaYDpVpl+5vACbzHNX/i4PxRVp8Oszej2iVsgg1C+ivf2mvArSGueUp4DW0cXPgRdOM82E94MBEtN5cCVTiilyv8n0jHqE6FiEOZ2zJsGkZLv/VfaL21WsuEcjPnX0EAbMsNiRSYnpmY86oFWkzdbgUk0qJ6twHI29txQK4/FNTkncz6iYXIfkU0+cJA05RgwDlwIcIRXDAVgiHbicVXcMeIpfTp3XDnjNiADDm3X44PfX6qHmKzJrHHS3r5AwQNpJ1QmzkdLWirSlUDLPZqAQs36VA6fa6DWzKBs0XnK7aUaiuBbOLpPVxomj0moHxo29NVE7I
 Gn1QYYuR
 UUhy6ELLpNd0KvoBdTyigxt9i2C1aqrtRtPg7nrVOmo6AZAU1mwrIhbPktTwujIV4pf3uuND2l5aG2ks4wl1bkgL5cz1splUK2fdeCAqa8DYIVMwlJHxDaaAPQ6aQfJmNoYrRkd8vtq7i7Hg85hD6gkUv8ZpoyvIq2u5Zf5lgKKeneQJ4BqPCuBMtKn57Jrx95rHu2TaeODsMWu2v9/3De9F0nMbUE5tqlooLpcQrPF9O8gcbTzpLHs7GZXBbTGnzRlo1eZPN8loaVtzBzRNwnfkGUupcTWNtWNBH6n1ySNSyTs735YzUbnAd6qIbVL8GLe2OXqSXGPRW6IGK7xdcYTaIuVkeQg0AqAKSWddDHfnXPw930tN8CDCQNft53/J0RIG8KP0jBnfcGU9ahZCN4iHrBCmpwkI6kjFdmbd28f9K8a4T3BUY9g3Uy0WAU+hx+PgFf8qm/dhVAPf4a5+GMLrMCW6lVpD8lPbGp4kOJN0KLT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mfill_atomic_hugetlb() drops its locks to copy the source page with page
faults enabled and then looks the VMA up again. The retry doesn't check
that the VMA is still registered for WP, so if the range is re-registered
without WP in that window, a UFFDIO_COPY_MODE_WP copy installs a uffd-wp
PTE in a VMA without VM_UFFD_WP.

Recheck VM_UFFD_WP for UFFDIO_COPY_MODE_WP copies after looking the VMA
up again, and fail with -EINVAL if it is gone.

Fixes: 6041c6917903 ("mm/hugetlb: take care of UFFDIO_COPY_MODE_WP")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
Changes in v2:
- drop the leftover sentence and the non-hugetlb reference from the
  commit message
- add Mike's Reviewed-by

v1: https://lore.kernel.org/20261029221129.89068-2-azpijr@gmail.com

 mm/userfaultfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f33ccedfecd2..6321bb82c1ef 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -810,6 +810,10 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		if (vma_hpagesize != vma_kernel_pagesize(dst_vma))
 			goto out_unlock_vma;
 
+		/* The range may have been re-registered without WP meanwhile. */
+		if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+			goto out_unlock_vma;
+
 		/*
 		 * If memory mappings are changing because of non-cooperative
 		 * operation (e.g. mremap) running in parallel, bail out and
-- 
2.56.0


