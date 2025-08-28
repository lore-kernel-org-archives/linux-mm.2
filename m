Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44261CA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 23:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2049C8E0006; Thu, 28 Aug 2025 19:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC688E0001; Thu, 28 Aug 2025 19:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC118E0006; Thu, 28 Aug 2025 19:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE7548E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 19:59:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74E541191BA
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:59:57 +0000 (UTC)
X-FDA: 83827836834.29.4DDA2D5
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B7C31C0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:59:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RVikttvw;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756425595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yItl692DyhuDS6W/wEpu2bIzdUK1IZAYDHXcH2tTSMs=;
	b=qr4HVmQObGmLuz2AQUBuJYUKUEYpnRRm4ZA1AVAmfoKCdWn/p5zyv7Awx5P4p0DdnaYM0O
	sxSYvo9fruaC12uGC8V54hJiuFZwBt9LNNtELx3PdIUdXiqQd7HsIw0GaQMn442IKHDj9t
	AM3rUWqgBZgxZc88Dl3Y4CRIxAmhc6E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RVikttvw;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756425595; a=rsa-sha256;
	cv=none;
	b=lQ4wZn5JYw/wBKZbq2AfFTB5ZLpFu+7YKoZpl6oDooNAR1GZgRzsk2ybasctlBKO/aA+Bh
	i0T7x8QBmu8WLP36m35dpe4JOiE0YK1nRlYDn7SRrSV2wnp0vfn7hEcGp6cCPHepmzS72f
	nqaKQQN6V/DjlNZeOvylnZzQAQS1hCA=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b109912545so18778971cf.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756425595; x=1757030395; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yItl692DyhuDS6W/wEpu2bIzdUK1IZAYDHXcH2tTSMs=;
        b=RVikttvwsereSiWedKsDPrwdqigSA/IKnI1wpGBtjlYCjlshvUfIdon8Jqn3Z5oH03
         3POnDNdzi1qUIMyZ7/sjnWq7VEJBG3rU+q/7QhDfeCUobzynMGJ6ccO/7au1CnnI6RyJ
         f238C+WaAvr7A3leV2aiprqPMm9DTC4+wcYvmRp8hX5qhEd74GbMfmx4IVwPB5DGpRJW
         x1ncH3y2VVwTihF4V34ElgIrTNfksOMnU8lEMp4vjxCLNvL5agsbwfRSKZUle+Q+l7iK
         KtizC3aWMGzi3o9j5sVPOXJRfiisNrRK+rEhGv+csiVdOZgPsNOOYnfxnUlCK9NRUoXJ
         Kovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425595; x=1757030395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yItl692DyhuDS6W/wEpu2bIzdUK1IZAYDHXcH2tTSMs=;
        b=fQTgqmJEgRPlvPujF5jKKfAUrjabG6D1XTdTn8u9mfFnTUq66maxSv1cyXIdI7PYMu
         0+7Snzv5krEOcNRExPi8LUiBS/TYMCpFNROVlNXL3qbAi7bPtGHzKNCd+A3Ys8p/SRIX
         BLX11vpsH6ms///azrTlXiPYCXaDZdSnhBBSewEMfHFvkauYtgUXQFVIFPmmlVCkTtbX
         vziP/fE0OuwDfm7qdiCEjssw2ZVI4qCgJxY0Aq6a/NfPY6E8h1FtyUF+AJ9mTyjs1Cpg
         pNhBi3lttsmPB1yXbHiUqNBugCFSDoNTrgjFkp7XaXUC0mFlkvBcDmTcyBx2uZiWwWEB
         bUdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi0wBhvOruiJfHq79Mq+WAItUajDoVF3yjVaHyr8TRq66WO2bqd6Vyt9jSq/R5oTE6Lp66GapvCg==@kvack.org
X-Gm-Message-State: AOJu0YzUR1V4OYAjS0fFysi6lY6IqpXcNuyZOlQ/RMFX9ghitqT5g3OK
	HKgvAu53TAh+MvGOOs/U85nMKLx1AtAAsnj82yuXAMzeNkxx0a+4SJeyCCzz3k+7wpm+hWKcPR8
	kQzLVLQIUj/1SElwnirmHrLFMM6DeddoXX3cV
X-Gm-Gg: ASbGncuXiwvmdw9t8pfypd4RWwVKITg9FQrTnutP/Hb2LOZDBkNkBS9NQg8FxoIrp7i
	gR5GMW+NQPWk9aMqzTM+K1GOWIp5ttteVS70NmZxo7aYXLjEyPHSiB/WFHPjw98IePsjx810c9Q
	PDrsPGdKEu1OzKZuhJmwDjis234ef8Z0ehbJxbM29mSdFhzoEs5ISHi0k+4b6SwWfPRU01nGVBm
	bEBjY8aCpV6F7RHVA==
X-Google-Smtp-Source: AGHT+IF7fCSXabW657dVKAGS/GF509K9twPmo/AHrq8NDU0U6tCuf/HScs7K1Azgv7V+H4gdMTsEESUZ6v1fcRS+ldg=
X-Received: by 2002:a05:622a:4c9:b0:4b2:a8d9:8683 with SMTP id
 d75a77b69052e-4b2aaad2aecmr307254751cf.53.1756425594653; Thu, 28 Aug 2025
 16:59:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:59:43 +1200
X-Gm-Features: Ac12FXzBq7J1whHqez1tkCmNGbSGiqJOevhIX7mUkGKttCKRWOFATlZ2WVnzLG4
Message-ID: <CAGsJ_4zFXzXKVKu9M2_R1Nqqt6FBEktT1YBGAFPRgjTxv=+1_Q@mail.gmail.com>
Subject: Re: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h9axh57jir94op8suatyuwuqz68xrj73
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B7C31C0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756425595-282197
X-HE-Meta: U2FsdGVkX1/pcFboe7DyYZE5odWRYIRjPXlA018x+C61Apu6ENYdK9Lt5pYB4HHIm2dbNdPEhtyj8/cY5mpyawuI1IE25efN9DyGnk+W9eEUbJ8EneyCp6KDC8w42g+RNOq4ykmaswEdfC959lCem5Z323w3Q9VPIQYx589GgYmOan/KF3CBfjGe23hIFe2seHvxP5DUiIqvXl79aeYA2Zu+vPKsxp5hHObhgc5b1vVANzOJ35E1L9r91yTJv9VZK/jD2GGx0nZDVp8YyLq7D927NTsSXsA0da/5BfixwAQ0Lh4e4vOAYujhMFugjQZvndT9WtUsf2f1QsuEo+ZfXSUEHOUHMbIWNsKunuV4oLstEcPKgHtiEqfbsev/aHl5+UhjHI9+MADER73TF5u477sy2w7p6oD0Qp5jv/i7twcTFxzQZLDpFO2bvId44S5ai5QUi2dcMVpDRx7uM545E62kSN9s/WkJJe6PxntUPSmLH2PdR3dqII9P9VNIlumF8piL1mUuQ5MlFZ5L+tTKH7yJVcdvQhg7GVxZ2kwgpvceDK75lnbqnW2mIs4AxaO9WOnqqTRc2pg8NR7eUiqPhJAzceiWMRp6awOR1KRdANkCBXDHsk7NOHEyVPbu38q2dUvtn/yf6xuK5MKN7dxgAt3ZM4l8Asneaqk8P8JmqYCD0igzY36NLu7mnXfg4bsrAHX8NTD128mAUTLLwbEJnFrG4KwihnmicZHuj/b0knj4ZzCBUd6lE25hLqeLbqgFErsEvyQy/QwtYQTuVZE8mTQYjVQuF0Q6wuGBowdv6uGhuDIQ3RR85NEN8MXf/Sn5Pw3j9m3vVEd/xZgHKaJ/W6vyAj3RxMr0Gq+ixZj6+mTbd0IW13ez1doZpLNhGn1XpaSNn7OSBWwr6iZQnyrIWt9GCqWixoMvptipfTyNXdb0QKOvbhOve2JjeW+CS7KIcFNJkaMiNza8nAzKIjd
 1Yfni6Hm
 i4MyLmoGhZSzrLSJSlHd8JAP9guu1nbrn1cIiosZvZgFjfjteJ3b/QHHZrmYvSeDQosuhsapZBzwuGugPIPW6dfi7YiuHW8y/lP5Dh0BLGRtttwNcRsTwFniHZiaqXv4zfzOeVFykKNZSykTqiq8kyOP9j/98RlV3H1Xa9c7TLvru298rRY0oObOLC1rTROx2PJokuqOZQgPl6UxJy8/O5ZtqakH+x4cEgpgEJX/CWqDRMF/I9v1IRdgGM4jefItEQw5V4+c7VCNJRHoULwhPR48M6jzAEdjZAjy5lP4m5JdtR0xk3xJKlp/NrilCNsr48WlO/JndzI9cPHsTXHJcNpd5CAUuBvKPPdFVhZX3V2zwvioRoHmSbIXcm8H+HPGCpejOQPtGHzOKnP3bzMZPKqIaWCa5JW751YeRf3yICk/jFT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 4:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch modifies zswap_store() to store a batch of pages in large
> folios at a time, instead of storing one page at a time. It does this by
> calling a new procedure zswap_store_pages() with a range of
> "pool->batch_size" indices in the folio.
>
> zswap_store_pages() implements all the computes done earlier in
> zswap_store_page() for a single-page, for multiple pages in a folio,
> namely the "batch":
>
> 1) It starts by allocating all zswap entries required to store the
>    batch. New procedures, zswap_entries_cache_alloc_batch() and
>    zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>    to optimize the performance of this step.
>
> 2) Next, the entries fields are written, computes that need to be happen
>    anyway, without modifying the zswap xarray/LRU publishing order. This
>    improves latency by avoiding having the bring the entries into the
>    cache for writing in different code blocks within this procedure.
>
> 3) Next, it calls zswap_compress() to sequentially compress each page in
>    the batch.
>
> 4) Finally, it adds the batch's zswap entries to the xarray and LRU,
>    charges zswap memory and increments zswap stats.
>
> 5) The error handling and cleanup required for all failure scenarios
>    that can occur while storing a batch in zswap are consolidated to a
>    single "store_pages_failed" label in zswap_store_pages(). Here again,
>    we optimize performance by calling kmem_cache_free_bulk().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 149 insertions(+), 69 deletions(-)

This seems fine overall. However, could we pull some data from the
cover letter. For example, even with hardware batching, we are still
improving performance. Since your cover letter is very long, readers
might fail to connect this data with the patches.

Thanks
Barry

