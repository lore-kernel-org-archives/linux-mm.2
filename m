Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B81606A891
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OewPrXgc
Received: by kanga.kvack.org (Postfix)
	id 6CE606B05C1; Mon, 16 Nov 2026 06:04:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4C06B05C2; Mon, 16 Nov 2026 06:04:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAE26B05C3; Mon, 16 Nov 2026 06:04:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40D3C6B05C1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D29BAA08C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:31 +0000 (UTC)
X-FDA: 85440698742.08.39BD70D
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 21C2EA000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OewPrXgc;
	spf=pass (imf25.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827070;
	b=GEX0gTH/S2XxQ/QXmBGU9LYViIH840nsSeiEYu/aICBm6ynkwKphbsCp8Tgumpa0UcUz/3
	XMchGTZLBByV2nxVmdhGeHTVsl7Bzz7WFJYWV98hm+nR6nLmEeCjpB/gjTYB0bSz7qp5aM
	b5005Wz+A7U+kSPBoChQRNJKnkkbpyQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OewPrXgc;
	spf=pass (imf25.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
	b=R4eAOR0BNeODwpU4ln3lR/Sngib9uLtzMldJTh9jGK9YwXQfm4OjK8JTfRsSDIgXFiVAsG
	ebqYBcYgKfFm2LPhIBCLDIf/JFGL6XNfOvkrRn1Dm2NtHdhCA+mUZqEqinNiCE+Ef8JHus
	928vdWirWwHXZh+cg8tjB8wokRUAfwg=
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15dd124bbe7so1496514c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827069; x=1795431869; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
        b=OewPrXgc2MAEBu0/KfJIE+g0CRxQWhlK3gEYr9isnq3+o+2/XSv4QwngSw48AXnVLf
         3omqNHDQMEJCA4rg9Sf0hXneeu+oZmqDpLSeQ+h9ynivOh+SfvG7DaZ77Lz+MykooDhL
         L7u8IUn2HuV2kWmMIM9av/8HolUGTIaUkuovlytypXF5qys2o/iHXuQ7kjNa37vn7dpe
         0eHwgQHYBofkXMwbskXxSviVo7JcQvs/FFPE7Y3bRNHFZ9mhZ4TZXhPeUyKFVJNWLTQ1
         /AdOPe2/o1ZiDxk3gD+RjBfPWtNaZ5soRmp+8xEdp1UevJZJb8FLH8Fo7Zve0E78AvtN
         LsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827069; x=1795431869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=de7uWRaoa1siS6iLR0pU/Ia14wz6HbTA+F0jrLsvNd8=;
        b=exP1NtfJXraq07PCRWJ4JNEXuVMM1wtwT5mjUTqZJZZXgAB2V5ig+w464+QPQvSm8M
         E9p3TLHutv89VM3L0xZyYu2fA1v8BrWAdy52jaBAV1IX7EpG17WPIMIV9iR8RBJK0mVO
         gn6HunswmaPL52V3l/xmqQwZl6015aoWaXKnPz/IzxzVvxOB7/rAeL249htur/hF1Pbm
         ueDZPbUHMtx18gH+8pU22NgNtG78kFOMrUdnofBVCSzlKHZlpJQ82ajcbHohOVDX8S+S
         Do4oLXXYDilfxha93ntzXJ8+5IaNCj+Cur+DZIxssF4SPVQvttfBcpbCwyPAb4HsSp+E
         kQrQ==
X-Gm-Message-State: APuU4Z9Dm3NCpFJ1R08WFh1JYZjcE1A7G+82mqsPeENNFkKSg/EtxKQ3
	ABdH/X2KTToSLParmQLPCgHyquObvk8awSnJtIt13sIsAkip6wT38rawjn24QMK7fvc+l/2z
X-Gm-Gg: AYBFou0rkhx3bfVWB1UPW6jVwFEjfSHLy6xxHgiOCoMsuwsFIPxrt6IBrkAd2uViSn8
	VX6P+anG6jmAalI6FOaA12MFbc0aNgCUTVe6dWLtoOAKEahrVTmLKXkTtYztGcBIqzipSArmLa3
	vJPPXyjx6yCNLVXdL3pvYxVSCTANLPvcl4DiU4xOpyqBP/G4fI6RoUhRG6usVY/s5j5hzQhowP4
	+6OkrkDKjMQCY0l6Vjj0erUqfGa2eHvZNblo9v8WBK/LFjN1WLpUnCQxFnuMbYB//QoqAvAohg0
	1IXc1RFokWgxB+A8FEV8frN4VFlB71o9HPkF4nZQqIF0lt2UdGwOkwwk+m0PP5V0SOIU6C0YlLt
	ymJF544p2RaRk86A1DkrB/sCgLOWDCXJT/O4G5uAuKaQ2xxi7zmIyQ4M3R1I5p9Fikwlc/2/LLy
	yTMkGBX3ZFYFD8szN4nL2PD7tC2jB6qlbABU40JyePiMMgwogHIHioMOTJcR1L70+V6ulOwkbok
	h1ab/i58lqPCGm7AnD4ebtP/JzthLvINUi8Qr43gQLb7FEzje+PgbFpLw2UOC+pZ79pYkqCl02X
	Uw2fLcTWKwSt9RxYU+SEglc5kFTicwQCt1gpBipkyTfbR84=
X-Received: by 2002:a05:7022:b881:b0:174:cf1b:235c with SMTP id a92af1059eb24-1b5031b37cfmr9037773c88.43.1794827068735;
        Mon, 16 Nov 2026 03:04:28 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:28 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 10/16] mm: memcomp: queue restored large folios for splitting
Date: Mon, 16 Nov 2026 19:01:16 +0800
Message-ID: <20261116110122.309748-11-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 21C2EA000E
X-Stat-Signature: b5o31q6o7udit8b9nhddye9gog7qbbza
X-Rspam-User: 
X-HE-Tag: 1794827069-152907
X-HE-Meta: U2FsdGVkX18MLr1b4FGOMgew/p7hSPA4DXMJk4soq6YjKJ/7DzSTpUnNh7J5iA6S+Sm5pISxch/0e5dL6XEZfdh9C3QxOBrAJmkWa82baYBukv2/gurm63JCjaz0qkP4mKqCT19cH1t1A4mqFGWopkjpdQ9uZaFvcBadtaetgsDDcSRrULwNoMMNCZQXGU+C8mnROyGs7qDDajPPbAufttUn74bMmOi3Gwp0Pz92LcEl8uvtNn4QnNl3ukYESp73yW8zIin10EXKwaQPocMtFMctdlA7sTXSajskc5WYXlkCdCz/nMBIYzXe+ahMUdbDlwgZjWHkkwPDKEV12sfBhWgp+Ud/pUPHaCswmBvxFTTl9JwAV0v98JSn3b3wR1NAXHdCSjS74Lc7tEpkI7YIefjiktHxuA10wf8KsyfhsriS0SI0cJ5iGHK+SwztjQ9PErwwCWY7Lhx2tpGwdAhQN7fm81dunhQQOgCXba7o6fhK3JbeEEfA2vkl8NYxxfTY4gNArXdAdoqcYsQFVYnhftlWn+B6Qx5WJYr9P8mJ04TZqRUo4ST1WBX20N58yRfCS+8UgSwLcif+n4ynR90Peq+xPXKF9GtLBkxoAju05adWtP0LYaXawlkkYuVgnyWhvNT8Fuf43rqKiSo1b63P7tRFVmFbHa9jmMlmzeCekejyV3D7iWJKGlxhB0gYPG/oKiSuYmK6YZ5aHxiN7fhIZvP+ABaQa/MPFJgdrwowLhQzi9vwclk6cy1Q5/zt99te0hLiYVWX4nfHuaO2SotB97tjjVDSPVg+MOOeCgo5nG9zG8hbqnSMt6uRlEq7vtfNsQsimlsMP8TtkAc0AqXUs/Yp7RZxcxIEYwuKunydiLThIWqS1SO37on4h96jS+uEkjR4mQWnbtGV2vRlEE2StnC5Cqc0yovDoDgQtqMajmH7+yUIYzvKMuGdwJEtzgimSk8mHChqhrJ4qPFZE9e
 mofwLhN+
 Zf4ELuc3VMqRg57NT4mQo04SO77uCM2HpVYYs8ZkW4rUsPsCj87X7G1C2VY4RMWaRM9EbSJcQTbUWV2g7WWRQPvHa2OaUGL8XfiBv1Ny+WKq1mtfZwMZauAuE++2Zur+knqn2cJ/TPetRtTEZzTQ8mbI5L0itmfCd3ChZcVCRaF5SNsegRpMeuHNezvOMTg/vMrSAKRHPC2EqHXa7d0Gz5S89pIQltkQHpIBERGvWQKxarwy4C7qTYyT4F7IAS0uPnyKQi6Jfrh67wdIxvfIxXGMDvSTwmvFhSvpV0brUqTNf/yU3XD4yZO5vUj/adZ5zcLsc+Emt34Ng9ybf00p0erXmuzHinx6Zfh0PEqX2yMdWHQAcY1uDNc2O1sPq9kXlpr0BjdGCsUPvOilZJwcsiB/qFZPVChJeNNzWf3tG6eXEK2xay3UW8zFk6tJY35DSajZ+vTPeNFUCBu8sLY7PwDEYn1aSC8KQd8K7AqmfqEEtB35SUoLSppyEQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Register a successfully restored multi-page anonymous folio with the
deferred split queue before installing its PTEs. Keep the existing
single-page, failed-load and rollback paths unchanged.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/memcomp/fault.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memcomp/fault.h b/mm/memcomp/fault.h
index b83ee7011aedf754173dd90034be3d6d25536414..afdde325c0e5f442868e9354d9abc84ae354bb0a 100644
--- a/mm/memcomp/fault.h
+++ b/mm/memcomp/fault.h
@@ -218,10 +218,12 @@ static inline vm_fault_t mc16_load(struct vm_fault *vmf, bool *locked)
 	folio_add_new_anon_rmap(folio, vma, start_addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
 	folio_ref_add(folio, nr_pages - 1);
-	if (nr_pages > 1)
+	if (nr_pages > 1) {
+		deferred_split_folio(folio, false);
 		set_ptes(vma->vm_mm, start_addr, install_pte, pte, nr_pages);
-	else
+	} else {
 		set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
+	}
 	arch_do_swap_page_nr(vma->vm_mm, vma, start_addr, pte, pte, nr_pages);
 	update_mmu_cache_range(vmf, vma, start_addr, install_pte, nr_pages);
 	folio_unlock(folio);

