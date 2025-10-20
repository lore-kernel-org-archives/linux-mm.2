Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9B64CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 16:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68A28E000A; Mon, 20 Oct 2025 12:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18A58E0002; Mon, 20 Oct 2025 12:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07C28E000A; Mon, 20 Oct 2025 12:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE8EF8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:14:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 628A81A0227
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:14:18 +0000 (UTC)
X-FDA: 84018989796.13.FB0B3E0
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 88D17100005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:14:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bk9VDLkR;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760976856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovFN/fCbIduQYs6aLAjGNuo1sjBICaBJVjQ0giTZsZA=;
	b=2F2eQ8cWaKoqWRZZIvzLyKocz4sGxOKA2CRdPYqG3oX+Mj+VQeXJARstlf3JDR7OQjBpzU
	/QZoqmqoVmAUA6Z2XFEXCGqgF1vJolA1QWzl5SIRd77UGar73uCUjQ/kA6n+CThWOdDTyv
	gzO2jLbw+6HW6DpvxgGURp6sGjZvfBE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Bk9VDLkR;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760976856; a=rsa-sha256;
	cv=none;
	b=dGV+tGZgzbAQUlM+meboT/LSzzItwULrGNbOKfQy1tFw5bFyhDk/o6WJfaJLDMntiRGNm9
	qgEEruRRrcn9O64N6QX6uRrxZcXxavqXiFWhQfQeGtmgk3WZZNrkwjaAhagNyqEZicXbqY
	gV7A9SbiLX5hm8gznPBrk+8+B4F2Ows=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-879b99b7ca8so69263656d6.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760976855; x=1761581655; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovFN/fCbIduQYs6aLAjGNuo1sjBICaBJVjQ0giTZsZA=;
        b=Bk9VDLkRo7KyMekPy1Iu+vIYz7YSwfRQ1JDjRQZuMYi6T/wCQJZptTkJlpMmYjzWKE
         ZUQDc7un0Gwa7w6HuQruRHoOcIiu5TpffaFzEcwM1CPhAoRXplzfOZw/ajW1T/zYXIML
         vnIGQ9GLV3NgWi5yLVAON8Wv4HJR2F42JCp/s5UjLJQ3tMUfEEesC1kbM/+AGJTKLuAk
         d0Qqk+hIg2A5ZAbhruXBMj3hOfc7hEFy6Qc/UxNEoLB4UJzDGHsMSDXju0nvFFfhUBan
         DgKwZ6XoGkokPnbqZBZelNPTbOCyxFjQdDzJAiAU0h1ORYutttnu5dHM4VV5C/zyV93w
         d+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760976855; x=1761581655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovFN/fCbIduQYs6aLAjGNuo1sjBICaBJVjQ0giTZsZA=;
        b=FTlARP1jwqo2WVgKpJg/C9i2ea4ruo6Nhd5E7kDSUDMMR1CsOkZ9Zh71ZL5hQYufBF
         TaTasQyRG+V+1QtB41POBTeDhptgm4hZkJm8Fuu3jdeyB+/QS0uwZFPOYa9s52+tCbHM
         H+6SflA+Ap4I48PrbzUnxh4t1BCaRK2rSgyEmDUvd3/FSmjlWvNXCAiyBN5Vb14saAfS
         mG6iaBUO04iHkOV1AsgFMovOEwTpBneJEK5OrSSqWzY8yB665+FGLgdeO1YyzgdaO2lt
         rby4492hHXRUguFNrSq1vdp5c0mx1Tm8ZPwWP54KDTepEjLoSGeiGbxPehT6OlErD4BK
         Ulsg==
X-Gm-Message-State: AOJu0Yw8uFKgOoSEYNBhi9E5WW8LTEZuUdzrtEe7KTytid7gdGgeSZmB
	gmlGQ/fZUQylAu9+JuzgmkC625V6UnInThlXE6Tq3KaZEVW+iMyiB5cqLJ2PcC7ObbQ=
X-Gm-Gg: ASbGnculWPxOdB0GCuIF1LBZJsg3n5D7bDxJwcRK/Sj0XfQ4eAtKgyHzIk8Ht5kicqC
	1Sl6SDk8XL/curqTwtfFTKaRrNOt27RuDav9yp++ECIYO71KWEbSytyQZUaPahWjNjfmKAJ4ZcW
	LgO9YMP5uaVeUzcV91i6E5AmBJLQgnVUy7+Q9PBYdQO0czV46TQZXiIk2W8hIlK1KRukTDVQaDn
	6NYUGCfrtSIzglRRQzRqitNCzMjbaRlXj+suxv0wshqPgZwhwnR/mXb7ZMG1aRv5JbIgv8sw8l9
	GaIozTcuVIenVW/bhh5Lp+kTM7l1awgxH0a7V+8IdOiPhn4/F9HawSJc/qrlMYA5dl86wn3mNyJ
	qCpGZG1h0JECiaPPE0AfCzE5+STA4EPbPHolluyYk74dSt9XKhBpuyQluX0HBqevgshVgZY5Zx0
	nh0JgjLb/DWrVlMA0f1YWQS7nNA6SqED3sjk0lxJ217+BzfQdebAik2UsIInv00izbLQunT6rxD
	X59fdjc
X-Google-Smtp-Source: AGHT+IH3czW3FFC2OSmXtjeaxvNwaarf66L+VtGACK8pE6fNuWKDq/oMJT6l6rutOkaSLLGkRsNYgw==
X-Received: by 2002:ad4:5c8d:0:b0:780:6e19:8ed with SMTP id 6a1803df08f44-87c20825260mr151746346d6.65.1760976855561;
        Mon, 20 Oct 2025 09:14:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d028924f6sm53420566d6.38.2025.10.20.09.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 09:14:15 -0700 (PDT)
Date: Mon, 20 Oct 2025 12:14:13 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugetlb.h: flatten logic in
 arch_hugetlb_migration_supported
Message-ID: <aPZf1aOyhVHVedok@gourry-fedora-PF4VCD3F>
References: <20251008212614.86495-1-gourry@gourry.net>
 <def56e60-42ae-4848-b0a0-91bd1c95d8d7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def56e60-42ae-4848-b0a0-91bd1c95d8d7@redhat.com>
X-Stat-Signature: oaysi5r7ympuojrmmxw1mxikw5jiwgsc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88D17100005
X-HE-Tag: 1760976856-697159
X-HE-Meta: U2FsdGVkX18JJcw7P9e3NDdzkuRRgtK/je2c0VdG7zS6jSutow8WqNDjMJ+OLwSomduAhgSEUyvsbvqOyLIX83hp9Qkn2c5+SKV2a2L1TeOhRbgmDEoneGtZDYQ1/1VGVKnrlgEN0+CoxNsSl8hj6/aidFJf4hq+8sDAMJ1WdpXUCTr4tafuW2RoZxI6qXI+G3mSr1mQrs31HGFvWP0DFxHYhgqof5ChTIXljsR8aZteCTiOoAtuhYNj3AbGzYgLTX6skXtRTiyAJFyLqvEvO0Beoi581Cuhh11NC4INnXYTE140GPbANDiVuGiBlkCHf8QE1tMBLW6vFHQ/SqiM4WJDHec4xYw6QRqewlemtQ5jiG/uH3JSz+MRB6zW8cyK/hny0i6GqWIhx43tix9nR/C5Ocf6udQmO7tvF57oHx9awPFlqOi0SgSZ8pV3W7NDMJvD6CkDdCgOqBQMnes338swMifPozob/A56GdYtAtLgKnRNymf2dT/LxA8w5yjJAduYt+59BWsI2tXFrXyZTKmulc5I0ZU34aGwkoBJokSiPgaaY9QOeaeTYm6Zth8IXhrdimBlIPlGah2+tMlMRlJNqcL6QSZwpzJh8tdCEt1WQSrNiXPmT1swbFp5exmupaaeN0kqwJ0S/Bvre7xd5EoaYA4SMp4OY0mxldLvj5XKWdLcnwh+puTU8a8jCivqd98ihX1v8vU4VcRF9/UPPhD2PY7/dZ64S7AvN45IjE5/BfpQWn+nIHZWEZ4ZcPdIjtJUCQnuJb4EqB8YWzPx1eozXgyuGp5PXQnOCx2e3LL6fh0nGIaDBAvlqYzf9D3okb4o1cOmNSTOT6k4pF9p47S8PtRM8OWNqYnU6CKqQJw72cFP4DdacNkrAa6yFDSGVxt0o4uvoPaNxlvhlSWkWGD5qbZiWVdD6sNutH4Zzp3pNauU1VBZ0mgsLJ7tA/RiJYrttJZIm/X1Dn05RcD
 VZHTVAZp
 c3VXmAnhBnvj4hVwW1DypCGoiSe0YliK2v087oG8y/c4z1/eUldnk/2SY1v6bF8VcviigV/fe1InZuzViLJt4uTI8XJM5/UPPCVAmtIZieFNSVz9UaOnTxX/kA2pggNX1tV4AWSkjJVUsgJd1cct3GGDdYIIip5V+IA4qdJ1XLhnD9/2UHFlM9V4CWIOZwAhHkR5j44iyh9z57vqluw0/IZSaTxRC9Op5TEiij9EHrXsR5vpaFHb14u2oLZlZc+QXHFupebGa/NU3jzwGwbOyiW0se65WtioawJyUgiwWWBHzQdEJ0GSyQnKhgHpxw+PYeeQfpyRjHnJHhb55pMYO2i2CPM89YzEQU/gCZ6GNqYoYTHKKDlzGKdAfbRhqt0WUDjwouOMDq7h/NxoLRvhNtAN3dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 10:10:05AM +0200, David Hildenbrand wrote:
> On 08.10.25 23:26, Gregory Price wrote:
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 526d27e88b3b..b030850975ef 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -876,12 +876,9 @@ static inline void folio_clear_hugetlb_hwpoison(struct folio *folio)
> >   #ifndef arch_hugetlb_migration_supported
> >   static inline bool arch_hugetlb_migration_supported(struct hstate *h)
> >   {
> > -	if ((huge_page_shift(h) == PMD_SHIFT) ||
> > +	return ((huge_page_shift(h) == PMD_SHIFT) ||
> >   		(huge_page_shift(h) == PUD_SHIFT) ||
> > -			(huge_page_shift(h) == PGDIR_SHIFT))
> > -		return true;
> > -	else
> > -		return false;
> > +		(huge_page_shift(h) == PGDIR_SHIFT));
> 
> switch (huge_page_shift(h)) {
> case PMD_SHIFT:
> case PUD_SHIFT:
> case PGDIR_SHIFT:

PGDIR_SHIFT is not a constant on x86.

~Gregory

