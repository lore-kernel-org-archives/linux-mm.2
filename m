Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE77AC55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B9E6B00DC; Tue,  4 Aug 2026 15:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C5F6B00DD; Tue,  4 Aug 2026 15:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DD66B00DF; Tue,  4 Aug 2026 15:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6086B00DC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:15:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0294940294
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:15:41 +0000 (UTC)
X-FDA: 85064541324.08.BBF3587
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F1AA2000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:15:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ken2sQLb;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785870940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1Dta2RSeoe9YdJLecTqGrTMMuZ8ntJIXx9AmBauxos=;
	b=rn0vAv7wdkeUvJmQ+6npOFrNaj3NWfa9I2n3I3V9XQ6qgQ4Pilnhgv7JPDp626MjQM2kr3
	wA+BaVpKgyPqvin9+2bA+unH+hu7e/vW4haU+spcbDhhti1oKfVO0HQ1o/KIPurMwUzxYl
	tccS8k31a58MMmIVJ8ZsPSbAZ+eTDC4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ken2sQLb;
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785870940;
	b=ZuJxBkXU9dbj+Oar//LTEk+jwKzzJCnMqGYPz77u3CeBuSFYvsY+GBYoBxlaMCCbzPiGDc
	YLZWTVfRkPoReMDB1T1ghTWGz1ZijSzAy34hH4PssyT+gbDitvCL61S13UpsmyqF8xEGHU
	Z3k/RmoSWwDsQHYFFYC1lq2ii8oxl6s=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f0e5e36912so1062736d6.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 12:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785870939; x=1786475739; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=k1Dta2RSeoe9YdJLecTqGrTMMuZ8ntJIXx9AmBauxos=;
        b=ken2sQLbTRBK4yIMXvRhrcvSrGlO7PBdGYOCndHZWgQdC4LgcDW07t79sQ92uU+Itb
         J3bRVxDa2rK8utm495/lEMvCWbCFqw8Jo2ObLyAv+YiRGMe9H1x3xhMez440rEXNUEno
         8+9WoZQaCG0mfaCcfj0ZwgiIaN9gcIQCWxDhB3o85tQeWetOKpqgR2QgtmCKE9Km5E8p
         Rgbo8vhXaWvVeippH8J1E+D/TLFroRqiwAEPcYbDwyAcqpud0pvsx2tRk5Afuree3QyC
         gKTNb5f/UO5dC5brrHQYu5liPTvHfGzFnKlD5xphHKGR4bA7Nab83+88G91qz4peKD+W
         aI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785870939; x=1786475739;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k1Dta2RSeoe9YdJLecTqGrTMMuZ8ntJIXx9AmBauxos=;
        b=GNch4/wLnZOKIsqGvq86vQQaETEw7yNXjWIW1SG87fqrxr6HNd5MZVHi5zTb42fex9
         EnV6QF7goBwKLVjvcNzAIc0/Eu2DE5MfKTNwRQBcTctWFDtcvlNz7pwB5/oT0qcNHeEs
         rBMPq9YaWlRXa8befQWv2tV8M4L6VNh1qh28nE1zgHZZeXHDx3TEZx66bIEZCocATKFJ
         IWtq5Il5hmpIxCImnphQKDUoq0ddmsf8fLI1PV9WD4JVNClsAm+1DIHSJvj6SofGV3qx
         Nu+3j47WmraaeGgSD/bThh6hznRMSoTSQ26Rcg48X0x0Ee2iIKny4JCHNS31stQfexKT
         b3BQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp//TZpNICCyggDRjF+M7X8cjuBt8l2HVvZezJbei2V7ETab3XsqhyPYIu0LyulCaADQwUEX3asQw==@kvack.org
X-Gm-Message-State: AOJu0Ywae0k42xXKyPSYT9PyJcqaiG3iObVZ74lsvuz+0ENgqEfQ9d3c
	jpAYoIv5NZ7IYszGBluvNZxNfrnmJcmvlg+IUP7/48f3qy93QPgP9iWNAMB/biZhb6o=
X-Gm-Gg: AR+sD13nXcI5ti4qev6jZgScVQY3sa+YM+G9Vh+g3z942oaHxwYh3LUtM/IPfMEACUj
	W1D8SSQSJs15Cei0Q12q8f2rOkYUk35Bif1bkEs1tP/GUq6xIHER7jAr7LfVATklVZpSemUckic
	kKn9j5Xy2XgyI7tHxbL3kxWdf+5aQIh2VSNxay8cTRYvLXWIbJfbQ5o7v3yPBiWooLYrlfbz8Hv
	s7xV3+xiDGH/Ldqhycm2XdPzkpBNGBrbxcRlRvTcupydHgZwv+G4kDsUHx8YxkrvHj6eJ0AJIQh
	caxD974lynAtN3ESvM7KIITrsFdg79hueq9gTROyFMWM9EPLbOC5e7C717xJ/mxaiYDVbVd3aYn
	OsQez8I2iK3027Zq4dz/YiQujGV/uLpLhO95pD8wUetC//sOGGDp74Ja0Aj5NaVYhicSiJ4jqgs
	yX1V6L9ZLlIArRfEepjW5oYIwZDknjgGw/G39lDGr+wUtuD2r4x93OLgjLpw+Ug0GS/CORDjEIv
	/h9S9fBbp73igRlrH4X/2tEhycNDvnyhicPYKvpzQqHTA==
X-Received: by 2002:a05:622a:4c14:b0:51c:2633:9ddd with SMTP id d75a77b69052e-52ce61eabd5mr16510221cf.41.1785870939179;
        Tue, 04 Aug 2026 12:15:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d814sm8251026d6.10.2026.08.04.12.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 12:15:38 -0700 (PDT)
Date: Tue, 4 Aug 2026 15:15:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 10/15] mm: Check individual hugetlb pages for poison
Message-ID: <anI5bPVScck1WXvh@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-11-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731200802.574821-11-willy@infradead.org>
X-Stat-Signature: osidhpu43n9dpwdi4d58wq5ri79t1gee
X-Rspamd-Queue-Id: 2F1AA2000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785870939-618278
X-HE-Meta: U2FsdGVkX18dWX0rUQQtDPkEjMWuSdd1nh4D146JQ+2NQ6SkBJ8HUxTICoLYP4OST6s6LliKr/4dSxnHqsTs56LznXiwReCTTA2JqqEHJsKo1Q7h+LX9GTAJ914mLHR8NANf+J5QVj1dBPCEX+S7ExbnQysrCMHleRnuahqoqAHE2uocDoIDveWB3toYQSK3DpDx27jjYN3uQWp/x2g5gdztO0PoQV7sWA92HZOSjETRO+GBSa24Ld3t3RT/fEFf0vODPpSrWKTC/teaTmiZaprtobe2X/OkuLmdvjYsi8VmnhwkClo20Kdjfge112e9gUiCzKgZzkJEd546z8jeGq4iUpJi6xBgqBdlgqHRrszDbbK+foQVG8ukUFr7PcgjFdJ4EM/Ynitd+7vieNzuLTVYSpjALr2DQ2Q9w1MWSt5YtERtD3eWiNcHsorKMHX7oi2m7tE6nKptTHRe56LJih5ldd1wRo/MN4qYOf/SU3hLoIyVjXzFsSAWeQjZIO3UN0RReUYvIRwXPWqEFC/49q9U3eWEPl12NzyQxUWC5eeVWPG8/JkdWaso0BkzgQbPZ5O0tlW2sZ7xvVqg9tGPaePZdwbMsB7/9wYN0qTHmYGI1JTe6adjCLvlQumZonKOexqNTFmwxU3lxevOMY0g0CklwpIwRe7X/r7emvXyabHwQWdVH2OmJQEx21autOD4a99eMzvK5wVaoNMGQ38XkcMKBag1bRBfzCRbAtmwJkr5jl29cyU2AnECYHnwCUTGF6JPBwCvxesFVnyJ+O/9+2QAU9C9wbQzbFUdZyw/pXHz/4DwWnEXWQ+C5MD9qpJPB16bRyTaDJ1LPIjo0w2W/i67tFZMWsiz55+XEzfOBHkHhmcKU+up8FtoBI54XgyFwZelfy7IdYe2CFLRRco6FLuIvAe4PSZDZKsU0OsinFsaxicVWv7vxKGTuVI3T5EMICqRU4Me03oh2i1L9PN
 F4pTGn/z
 PSCRDLPZsakVyPReYvawTY76eipT9ifPDjk6evS4nr6fLKauGd7FuxhsiPRCUC27SB1f1wEP/hDE6aGTYHu/Dvclb+NOV6XzB6+7KW902tODmjoFmRC9Bzb9sOj2ucL8SMKnsySLiG8xqVHThvi6Pv1OgF/Je1Qpqc4tMXAm/RWq4F8XwOddtAwIWSLG51P67wzJcQp3JeHAMg62q2yqDNpN0u9t9z/uxK0V1/wrv0xdOZ9qa/67Hzq9jZf5T7LfL+1U4PX7t6ZrzNQDRo7bdwQlOGKgBQ0mqSVsoVsh3nWEmyIVZINmLTbnxF62k9lUT/Uz6VSgJYNvTwwHfjaEzikvr4da4zZYA+h4QBOYf7fzdpURCtk8Vocz6IR1YjiT+fbHpYGkS93gkxGP1VEJHOocWwbo1bX3yxmP1dd4A3IUi25rW25rNpYK5aZgRf8PwoR1d699+CXhFowNR4yvGMzABZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 09:07:55PM +0100, Matthew Wilcox (Oracle) wrote:
> +/*
> + * We have no reference on the folio containing this page.
> + * The hugetlb_lock keeps hugetlb folios from being freed.
> + */
> +bool hugetlb_unref_page_hwpoison(const struct page *page)
> +{
> +	const struct folio *folio;
> +	unsigned long flags;
> +	bool ret;
> +
> +	spin_lock_irqsave(&hugetlb_lock, flags);
> +	folio = page_folio(page);
> +	if (!folio_test_huge_poison(folio)) {
> +		ret = PageHWPoison(page);
> +		goto unlock;
> +	}
> +
> +	ret = precise_page_poisoned(folio, page);
> +unlock:
> +	spin_unlock_irqrestore(&hugetlb_lock, flags);
> +	return ret;
> +}
> +

I ended up with the same question as sashiko - i think this behavior
implies we must hold a reference on the page, otherwise the folio can
be invalid and all these accesses are unsafe.

But that must be the existing behavior for poison checks like this, so
this is at least no worse. Not sure it's worth addressing.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


