Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CEFCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42B2A6B0005; Thu, 28 May 2026 05:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCAC6B0088; Thu, 28 May 2026 05:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB576B008A; Thu, 28 May 2026 05:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 196A96B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:09:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3D8D1C1F1D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:09:50 +0000 (UTC)
X-FDA: 84816256140.02.4FFB779
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id C5A364000B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:09:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=db4TyZ7N;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779959388; a=rsa-sha256;
	cv=none;
	b=ImpLjbmlQrjcXW6IuQInEZyArZV6dm+ixYT7jlKtL9OkzjbKt6rBFT44qSd0rXjLx/1if/
	1f7IHAn3Pe+FCHN/baaLUJgvKl4SX5T3d+fcAa47Bc55R/u5h/o+psMi41CTxsIQKJsekY
	q/pJZpt3mmvTpnBTFzyK/5WRbX0FB08=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=db4TyZ7N;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779959388;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4oQKIQh1sPjJnNR31xrjNByxiIuwWJnJkv/ei6fL+Js=;
	b=tZAFQwvJsLJ3wqFIjMAUv3eFa3GabKGrPI50mzNGPpi1csw7VWTbYU8QJsvgIiDRWdsBVh
	DzMvh888cwwcPMIv31l9MkRuQYjDTmBva7ODw/CB3kqRRho1ykPCLbcV2JzD9yAoR99qDI
	X7mNyp/VMAYM6jGhX4Jjsf4Il7PyUsc=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bd2e8931915so2505282966b.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 02:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779959387; x=1780564187; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4oQKIQh1sPjJnNR31xrjNByxiIuwWJnJkv/ei6fL+Js=;
        b=db4TyZ7N6JXv8LD24RBRVTkg4xYilfBx0SM+XbwLFhQ37biOHyhfVksdI7vjlECc3j
         MZESO2j//cMR4nvrdYXRlEtt7GJXneldFqd1FC9ExbZB9ECMZkhxTND5uJouK9tLJYrX
         ymnC5Zk9UlXrcLPr/2wBBthIwPtXK1Jrdox/x2SfQtAHt1cvB9ynTN3nZ58xy1S8wEXi
         6UcHR1mgvSn21jmSecGmJBf275Cbyhiw8KNdkMtd036Ey50K5Ivq7fpFxM3YdAFrNnay
         aCry1ASBYNUMnG9rh9DOuzGJGPVEwD9zghJWi5RwFOZzg1iirchHLucpPeW5/OD7ugRm
         TYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779959387; x=1780564187;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4oQKIQh1sPjJnNR31xrjNByxiIuwWJnJkv/ei6fL+Js=;
        b=qGk1lRLnJOoQRUdaogvFuYi9T6kw1q6i2zV51e7kk3Eqxk7DkkbskNAKNIrCUUs5bC
         OD8mJQ0keK/IRuWtK7zr//OMOysr4xte6AIcVFUSjSNcizuh1nYXgGNa7bks8/gNlUSv
         4+yWyELd37850tdkFL34B0Nf31KE2OH4mkekrYwDYkYaQnOuBvUV4EOvK5vXscIDmSx8
         u7mPicwsgUAfa1Ql+DpA3QTTdpHJWpVuzhib6xuLd6dwc9Zd2BYU8faVHSYe2A73Q/uX
         BzXZGdIkfGtVzKXKwuPOV0HmuVv24Pdkmzj6sIJZyl2adi+a3Hv8rB37mbbl3dn5nQx3
         LBFA==
X-Forwarded-Encrypted: i=1; AFNElJ9X1JX0NWCbitUyaULykvAX/h/pqReveUyYuQL6tNlvx7fDRtsD0qzBdTg/t/h6NwgOa0Oimpndyg==@kvack.org
X-Gm-Message-State: AOJu0YxpBqNdeUf9c5B/QmCGrfXx2gRA8xxvR/80J06tCJqLliF2QxoF
	qjJgMCWehOCOcoLgLEgxKPC3q5+4bxfN0Ef2THufll+AQRSgx3Czdacj
X-Gm-Gg: Acq92OENn9Mjxu7Q1xzDrJd3E8YLndFlkBk2XiIcrE2NTD7cE3S8tfCbX2Likn4dOfw
	m0KDj3u8haudvz7FdMSeio/xhammo9QUW2wfAFXplL9cGak6rcfrew35hEkakYbjTLfy41iNSpc
	7WX4O0SFm82Lj8zcUlrDXioW2Yt4eMCZ3UYNm7VZ7pU/EUofEadtanFQUgmIkQUJSgcoE9CFOLr
	tfTdYnfShXkjZb+2tRSgNx0TvQns8JRyEtD8vdr8hDJwk6FYaOafZbzUButkOlQMnipaQNTeHC8
	G3jZ1S9wfS65n4JOrgmRWFRCgjtSd9rGFRjkxNOLGDJU11Rpfz9n1+N9Kh1mq04wmBMJE9sGFbI
	O4zqcEmyBL+//dzCJ2iLiVmei2fNaUtRsa/XsE1z6aBW5E8D4Ocl2rFwqPs0dyjVDvvIUCJshJI
	X3hoFWOE46YPUMJSeA9sKXrXbC+uGAvlr7
X-Received: by 2002:a17:907:d09:b0:bd2:44de:d698 with SMTP id a640c23a62f3a-be87bc2a556mr45218766b.17.1779959386947;
        Thu, 28 May 2026 02:09:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be1d4678920sm357239866b.31.2026.05.28.02.09.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2026 02:09:46 -0700 (PDT)
Date: Thu, 28 May 2026 09:09:45 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_vma_mapped_walk: Use ptep_get_lockless() for
 lockless access
Message-ID: <20260528090945.xjnj5hmyox7sahhg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260528075507.1821939-1-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528075507.1821939-1-agordeev@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: C5A364000B
X-Rspamd-Server: rspam03
X-Stat-Signature: xgdcitzo6r97x3ex7mugfqs4wd7em6jm
X-HE-Tag: 1779959388-974372
X-HE-Meta: U2FsdGVkX181sl1AFZdxRwTWJ11UitTRI0ghpQ1UiF51MeKcL4ePyPzswIHJ4v37X6HQsh3lLzz04zE2+ngyKfoHxCkgBGzi5+OufaulON1LnHcaipJccnrJNNxuYg3svqG/PGHXmBKew1pcp8+7pf+Z2N/ZECL1m/622UDqJtrT91WH2ReY/LAuczDSxMqYVnwA0Y2V7+CWgtB6MzYHRzzPL3plPDRm3dIxyJroAewC8fw+crJjB3L3ZsAC4kHAuDjstx3+HgMOHeWtNIAsWGXqGKzi5/W3WADi0TdxCbwD+hAt93JLecwcHB0mGw96uVRlrLxzi5Q8roLBxO04amRgqDgZmnvmtYWYCYwCIBtHsHbMvrsRwGj/s7fRDgYlelRhJN5QhIJaFCpQZi+qXMHiW6Fx6MFVP2PVhagkjjnyvOyqGjrOgzX9CCI93xTPhDiFi85fabs6C9QJsgoz3hGgzPR+135Qn2fnjw6aRyAqQ2hwxy26hT3kqpEDf3RSIcLhK2IWy+VhphYN9y3Qzaz7GbVXRCWqSUU4Z7uP9HHnSNkAhy0INb+tlXlkf4lPdWuaxS6ihRPpn/zIe0W90s6BT81yRFfNfKAIRMLhAOgSgbrl8PvS2cKcNSZGU6ocz9mBMYebSOfpq0TtRQyCCPS+JX43mFObYvS0EfarNoC3zQze2Pm1HxmSwG2aOYVzP6KD6Leo56UZdph7tTVq8oMilNKecwPJbcPbZffPekYd7USucaHl22Z7aYr29WOqu9z2urUkuxnd78XMm8wUt11FbKzBlWxwiv0uI2Eal+AP5jQlVxp0PZC0CWywVlmC7fB1jRHwy/26b/u2otGEmel5UhOL1Zm9LFdOPfaxT3cGwu5vw70NaIU45FjTsRaZZyEuAEiTR3Y6uYrCIZriJFleXWEBzmoH95REk7so9clWN+iguosKO7rsb+CGkU4235ynikpha2LlpXxDDJm
 DbKQIOjQ
 +O/Q7ohn0fsI4LiZHHx9EdD7m2rh4KqOSRphB/AiJxKdO6TpWmAjs2A79CqMPNdHHGSTe/UhN/HtKTmIJ0SMDsih6+WvQlYhioCWhjQRmA2tkRBRmbMSprXVMpk8Vcspj2QuQh5S6wtxM+wGA0LLxrisjDyLfuP/5c0i69DG3WZ8cjB6V5F3mpl8gKZopgm2LZStn1C8XEBMPjugS7/B6CMj9TZs+Eu2Z5uKDK2GNmt+Gmx8AGRQf6ZsG6Vqe+E4GDbWSfp7KQpevSpIqhuqXwGWx2ed29LU9qGd2QP2gzvMkISPyJqS25HvOyx7+VZiS5d8z54pdDHf6Fv2nl0vvgpsf/QjOevESdXpS7iSS/Usj3V5SwTs8hJUrsuA6Fbs6zWl8y9s2Khblu70nzSBxReGyaVXRSRyeDDnkvav93HGJ+/poVBCvblHE8z4lu+5y4DCteuptLIBl7xBaM79u+XPbAaeju3fyAydNXJzlqm9UDC79hh+8FUwOi3+rQlO4AoxC6U/zfGKh72KiIUkUeL07nnEYwSQHnl8JuFL6jlcwGYI88fRBoEV/obB10JZULwXrMakssPwVLnzkR3CPkwsvIO+yJhfUee0eV2tUOjNtyplzNCZj/kFtci8YzzEJ5+eQpBf7XKm1aPuja6s2bhWlWru/b5npAzNpmYIlAFbitU/kjAxYsmQWPUFwzBtNaanJ65JArffneqbQyzZXpMlRAPX8gERgZRxwod9H9FDAUk1dDsf0VLeaX56oUl5jKlVcl4mMS7OQTyhZvniwmHJSHBxBtTnPZLStPiiqT4YGyX+LZhtN8XzH1iDpD/SDneCCxYoyFQ4LH+npsejVkKAIEmSFvP5UagdMpSAi7zQfJmlBeGLt3kKeLh98jtpPJPPb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 09:55:07AM +0200, Alexander Gordeev wrote:
>Switch from ptep_get() to ptep_get_lockless() accessor for
>PTE reads when no lock is taken.
>
>Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
>---
> mm/page_vma_mapped.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index a4d52fdb3056..2ccbabfb2cc1 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, pmd_t *pmdvalp,
> 	if (!pvmw->pte)
> 		return false;
> 
>-	ptent = ptep_get(pvmw->pte);
>+	ptent = ptep_get_lockless(pvmw->pte);
> 
> 	if (pte_none(ptent)) {
> 		return false;
>@@ -183,6 +183,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 	struct mm_struct *mm = vma->vm_mm;
> 	unsigned long end;
> 	spinlock_t *ptl;
>+	pte_t pteval;
> 	pgd_t *pgd;
> 	p4d_t *p4d;
> 	pud_t *pud;
>@@ -310,7 +311,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> 				goto restart;
> 			}
> 			pvmw->pte++;
>-		} while (pte_none(ptep_get(pvmw->pte)));
>+			if (!pvmw->ptl)
>+				pteval = ptep_get_lockless(pvmw->pte);
>+			else
>+				pteval = ptep_get(pvmw->pte);
>+		} while (pte_none(pteval));

Use ptep_get_lockless() when lock is not taken.

LGTM, thanks

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> 
> 		if (!pvmw->ptl) {
> 			spin_lock(ptl);
>-- 
>2.51.0

-- 
Wei Yang
Help you, Help me

