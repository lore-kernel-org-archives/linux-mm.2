Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D3DF364AA
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033036B0005; Thu,  9 Apr 2026 13:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26376B0088; Thu,  9 Apr 2026 13:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14776B008A; Thu,  9 Apr 2026 13:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFA6E6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:09:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 796FB1608D7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:09:48 +0000 (UTC)
X-FDA: 84639654456.17.CFF2FE6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12773A001B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:09:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FThtOdRo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754586; a=rsa-sha256;
	cv=none;
	b=5exl5bMU7rigXTzE8FPyLCLTKKRbLVjA5L47oS4r3LOljRLuODaa5l3cSLEbvVJ2ZvPdsG
	IK/XwStjM2lBQ2hnDqZNkYV3MEaQwEn4Tcy9+Q2i358XKgtdGPi8YnZrkkVvJWBiJC3UPJ
	+r58sQpuCQQsQr2qrMI453CMzVTrRoU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FThtOdRo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Oxezvv+XY94eqFB5rhe7YtVnfzUNjVg60HqVaktujI=;
	b=BZViTJvzyEnaDknKik80kstcJ4gXR9pGGy5rUVIix12zWghI1qI3+7bkPE/mrS2yO90Zs2
	AmFeh8DLPcgherwRqERRmw0IhP9vRzWq+8BEjGS1S0liF7ZhWfx4VQSBnk5dB60vJum3IB
	FlMHTNXiAc2NXqmTpt0mR52QpH9Dcp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775754585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Oxezvv+XY94eqFB5rhe7YtVnfzUNjVg60HqVaktujI=;
	b=FThtOdRoSyXykU8hvOVvH8dU0Ecvl1CYOuzYvq5f0rH/0VwWF1g4uLg+vAtqUFdJJphVqx
	TRT528fmhzDlvUDdAQoG8g+UM3Kv2U41sfQiUYnALUHiaQ6j2i8ycsL6XKmxnch5g3/WI6
	o2prjJXJHO+x9+taQ4ODQahy/W3sXtg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-3TMZ0h_CPYqKFNAIyLkK5g-1; Thu, 09 Apr 2026 13:09:44 -0400
X-MC-Unique: 3TMZ0h_CPYqKFNAIyLkK5g-1
X-Mimecast-MFC-AGG-ID: 3TMZ0h_CPYqKFNAIyLkK5g_1775754583
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8cfc575fa15so203439785a.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 10:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775754583; x=1776359383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Oxezvv+XY94eqFB5rhe7YtVnfzUNjVg60HqVaktujI=;
        b=Qx6Th/fAZPy2XY3wX5BzD9dBl8lEKM76Tk48ttj0k7UtTUZM/l1iuDmbmSSZeCwpA+
         ATzaU3yajc4hojQIoohp+RHECeBYfmb3gXUt/8ro7CaJ377hCTowGr94U97pr+I7+N2m
         URbcsDcS8Z0E5EnS4dbdDJA1LNEKPUd737g2xsibG2qFAOjQHln/0h26L5Bc9huSPdS0
         ijlKG1cLun5/Qe6YQGpM6kLL8PbytLAOtCjZGXc8J7BoAVAcn1kYe1M86FjkNQyTv8mN
         4Wi+hpzYRkIoA5SN3abLqWsGIctztVYAi7AvzQsZHH/iKNPvrJALy2303VQTupx37Nh6
         xyUQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9Pc4d79yUI+mLxMYfoMGc11gO/BSgxYQlL1his+kVcKaIUV8R5yLDlDMja5Hn/sY9hfeP2sBrNg==@kvack.org
X-Gm-Message-State: AOJu0Yxo0j7HdcamgdGJZ3MyOyTsNYMiYu23vRTdBioHYYnGVMqN2NSc
	HyXA9vtHeWNEffQEbosXsP2zYmJQrMHHnidqiCLrBThOR/kwyaxuZkF8HKfJBO8CCHvjKOB6um4
	LycYLXVLGFcMOO8eGmnAjdj1kSFMNWNcYkf81szypWVJE4iQ5tNMq
X-Gm-Gg: AeBDiesTB+Coe831/TkZdYxU9FjjZip/tamnUDhl3D8njehl7gPoK81Sj9jnwRORs/S
	5IvuZ2O3wZvblLdU25nSc3JubJ7iDEOLm3ZV9P32yR4lqVerIJeOZEauL0sblpfd3TyDqZmWeaw
	9fpJdqu47KGdg56sB1pUBCoyxiNNNMbXmgI3AJjBpBtXXNY96U4n9xGJ9pHOekVOkD5mPxY84ZM
	cK9Z7wRU86gb1KfhF7BUjul+M1EqXO+LyPe2xmh65sw+Dl0zKg/33of8H36NrsIZtCzMm4YV1Fq
	tyoeUCS9kosKxUyRF4qsI0KXHOqvG9SpQt1N/D1IPCW3DI12LjrOMsUKuuR2bgWixaD96OSwY7K
	iFA92MTtBNKF53H99EGQoKeFkw5Xz+dc/K0jzg0FH8/36W1w=
X-Received: by 2002:a05:620a:4505:b0:8cf:dd93:acb3 with SMTP id af79cd13be357-8d41e62f87cmr3528894285a.56.1775754583147;
        Thu, 09 Apr 2026 10:09:43 -0700 (PDT)
X-Received: by 2002:a05:620a:4505:b0:8cf:dd93:acb3 with SMTP id af79cd13be357-8d41e62f87cmr3528887785a.56.1775754582478;
        Thu, 09 Apr 2026 10:09:42 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d40495cd32sm1615693985a.22.2026.04.09.10.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 10:09:42 -0700 (PDT)
Date: Thu, 9 Apr 2026 13:09:41 -0400
From: Peter Xu <peterx@redhat.com>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adfdVbCY18PZMfI-@x1.local>
References: <20260409120653.290386-1-devnexen@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260409120653.290386-1-devnexen@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7POv6V0JB1XGenUFQHp9Q_C-7Zsw3DFpn7c0Hq2mktQ_1775754583
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 12773A001B
X-Stat-Signature: w3wp9zua5oqxo6oz69h5piqrrw37we4d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775754585-561153
X-HE-Meta: U2FsdGVkX1+2L5GZyMsgpZg8C8p/WeJKrdADUwBkKdEceX+C9VAzq6MNcpU9CNvPRto6vgDKrF5vqsjVs6O0vYYVP8HsUDtvwxRHGSuJufq6TNm8essPGqK2CdmRhxj8P+LpMOjltWDQ/v6LuMybev3xFAT4mYTeLTv8c7Xa3Odl6OwXKtTd5mHCfx4voUICkBhjOfjOhurguvQ4CDWhpak+AnVF7dpIN/RKTtISxhy1tnzjMoovI94IrIxi34qhbHohO4uWbzr28HICa8eFtGaAb2E064EX+KKq86o4b7iJAg7Z0zZH3LmPKpyTaF/W1lJMtc0rtQW3GUgNWb30cdD3owLoDXleekswZjEg/krscbNMTdO27ngDPtsjV56zIzLhCRwyLuA5HXUypWVqCL4U249Zr6N4W2whRTL3pPYSkS3kPy9rHGbr1hXhl3SMzV4aAfBaBJPFN1e3CDYQYjGjNM4/cNcXMuKunc/K6jUgR1i78/w1fWw4bx2KXovGLYpOMd4Nkr5wFpHgEh7RoS+6DvD7wR6cuiiv2lykYOT2xBuIxVUV35tSv28DOXxGCiixfmdnCZMG+YFd1ddZcAvS9xxcMa4H6OmlQBC3zZqMbjbcjTGh+xHb2N3LfSd1A6qL/f7H1Elr4OuARI4HTxyTXW/mYYSBspBETgHk1Y8NO4QyEdoGRXobz3H+rP8U7gi2EWyM+fZG8fFA7qKAisCGssdmGzJiR93wXhEGHsHRYpToT3hhptlrJsUGYFE7dlRx3RENz5+GS7ZBJd6UgnqORTJinE/OJaloiP/4x99t+4HwZCmr636Kb1XlkkrRK+4jgEP2YmxKxV7NB+vx1t9usPPm8Sufz+LP1GgUA4hS5PDvNKM+tsVps/Ver8HTsHyFeeh+Ko7lGFIEtVDmoNigwqucC2NgOgJFjtCnCTBQoNOFEXtQsknAAhsLwpaZEuZD6tTboEMood1DgJb
 taCOEWBB
 qMYW5J7lRfyZL0xLPaSQVssv+0zwiwZ0qpvMvlANXLa47LpVlSDvBZus3RqqmbRwy/XXPIZ6im+Tdecwf9mlKzR4lcXf3lQGEC/ZOVJ9x1446N3NR2t9/sQPq8uXQMI/uYVvxwk+2NKD4CcODCMUncQILyB5iUXRyQGSndOW24rn5T59jwBlvV3ZD+4JznK+hFP4F/5Zwnf9K3ZGJyQclJtibgr3LJanKGK16bBo/GxyvWk/Ssdp+0Cmn+5rK+vL1xm4GLDBTrEo4OA4+kECevQbW0qwI2QCN4NeoO0FTa4IYEaz4HWF7m8LAB0/DjdOXdf7S53KNIAYrV/fuU+/7d/Q3a1BFICqbNexvuEUw0pYcrSxKuPZl8cwkVOmoMzt+VoATur9LxZ2Kr/4VNtLYK8/giTn7hKWC4XG/Bk1QiMhrL4fe2de/PYnLwdUKhgL/taSvnVSE/2a4Tzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:06:53PM +0100, David Carlier wrote:
> mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
> During this window, the VMA can be replaced with a different type (e.g.
> hugetlb), making the caller's ops pointer stale. Subsequent use of the
> stale ops can lead to incorrect folio handling or a kernel crash.
> 
> Pass the caller's ops into mfill_copy_folio_retry() and compare against
> the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
> if they differ so the operation can be retried.
> 
> Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/userfaultfd.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 481ec7eb4442..214923a411c1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> -static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> +static int mfill_copy_folio_retry(struct mfill_state *state,
> +				  const struct vm_uffd_ops *ops,
> +				  struct folio *folio)
>  {
>  	unsigned long src_addr = state->src_addr;
>  	void *kaddr;
> @@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * The VMA type may have changed while the lock was dropped
> +	 * (e.g. replaced with a hugetlb mapping), making the caller's
> +	 * ops pointer stale.
> +	 */
> +	if (vma_uffd_ops(state->vma) != ops)
> +		return -EAGAIN;

I agree with -EAGAIN here, but we discussed over all the things on possible
inode change and I don't know why we don't consider that.

I still think those should be considered.

If the vma snapshot idea is not welcomed, fine.  We need to think of
something to cover those too.  Current patch won't cover "ops unchaged" but
"inode changed", or offset changed, for example.

Thanks,

> +
>  	err = mfill_establish_pmd(state);
>  	if (err)
>  		return err;
> @@ -495,7 +505,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
>  		 * will take care of unlocking if needed.
>  		 */
>  		if (unlikely(ret)) {
> -			ret = mfill_copy_folio_retry(state, folio);
> +			ret = mfill_copy_folio_retry(state, ops, folio);
>  			if (ret)
>  				goto err_folio_put;
>  		}
> -- 
> 2.53.0
> 

-- 
Peter Xu


