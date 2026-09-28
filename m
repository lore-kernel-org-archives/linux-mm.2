Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11B0CC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65216B0088; Mon, 28 Sep 2026 06:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15F16B008A; Mon, 28 Sep 2026 06:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C1A6B008C; Mon, 28 Sep 2026 06:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4DB6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:45:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 484A4A475A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:45:31 +0000 (UTC)
X-FDA: 85262839662.05.29B7356
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5F7C72000A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:45:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKiPZMsi;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790592329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkN3i1kfI7ou6rynJpVZcTVcqK4JP2ip7U/AkgCuNZg=;
	b=Rm5wy/+MNYXNI6PYiobL1OuWHoy0E4x4kiwqbqzx7bD+iu7SbIz7VLmHcCxHMayWLPnkE0
	9S1LJTLQzpvON3r7ZXynCQWi7mRtVlWcV/f1nAW+HcaiCOtFHVpwe3P6S3t9IfeHCiOlCZ
	KFR1dyBWu+oVcOSZRCsm1ysaXu7LqcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790592329;
	b=cUhQjHCmuLWLq71M6wpYVhHSvZwYbv12LP/RapZcZrpw0JMQSesyiO4AeX3nOQMZOYlNDK
	+m5LI0dGaEhxsDCvTfy9MZN23gfaMYrHQCRIGY6T0DDTcx1+bZbETqA35Q+0lRyzLYnhZS
	FvilRWFteOsBJ8VQUlNJ5vF7glJ5FXQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WKiPZMsi;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D9D60052;
	Mon, 28 Sep 2026 10:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AD01F00898;
	Mon, 28 Sep 2026 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790592328;
	bh=pkN3i1kfI7ou6rynJpVZcTVcqK4JP2ip7U/AkgCuNZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WKiPZMsi7vwK/6Pna+7AiSU+ZoChJ/KeICr9iXiyPBnol6puKjOj1zFcKTK3NhjgF
	 n5/SjtTXHi1vQG2DzeDoHT6zBs9tt3Fzc5ZLeh7/qV/uX6POrrmfYQNxNm+LUpRkQ4
	 L6/zptJvf8KWKOwXbIpyqitNxUyfAysiWKpGbwcRL9eao8s3zynxJYo1gzQu/KOtDg
	 qWXwqXGrUtPzU3FWRwJbu+/1Dnq3133sE0YbTtGkxKDICkfqyWuF0NL/pv1y/vGihK
	 e7LywAQ2OhBklGy0ajFJlyFZDrKo0LAxV2FSY1lprg/iN3Aew/v2wXidkCLjXXcSj6
	 TTR/NzXWR7ZFQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0ADF0198003A;
	Mon, 28 Sep 2026 06:45:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 06:45:25 -0400
X-ME-Sender: <xms:Q0W6ame47D9MaXBY-G9oKtIF0u9qyGuMcWh-z2_zFY13ibi5h3FpMg>
    <xme:Q0W6agrV11EYmJoOBxuq2ktzvOciho9MYMAFiT5kmXW78D2IBup33aLx_LoiIY49Y
    1vueIlY5LRWfOPCmz7_8meHs3t6DihIw2c6hyVOvML_tBSSsFAU95pJ>
X-ME-Received: <xmr:Q0W6as_0QqgphPDV6kZf_MxU08Xna30sVf_-eX80ZHpUMsQn7wO5WKIDVJU>
X-ME-Proxy-Cause: dmFkZTEQ2M4Yss00TVpFpyzYKayTNLhSmxlk8jgjYdWRC8efZB9dhd1fhy51Ard/y+ZR52
    mQzsiCa3phAmXiUEsipTMcJZKBtf9dU2wz0a/IwoLhZl3hUY9v5yn7wDMUjwGwyJmAh0XC
    bjpflSyPRI5OmclTeYExGhZ5xy1PLjrywhAsS7laXNeXT5atgJLELAXGuiG6jFTyo89i8N
    6QrLqf/9UpPfOJ2VRQ1pffV0SHdsTMeCSkgCgk8VYQb9KnDhpYc08nTyCMw2ppxi1TusCU
    frbp1suLUW4f78RzbWO+LUGjoIyb5F/hrDuH1UVFGbQmOyOePFniGTBH5CX1x2U1eK0tTx
    3CAj7Tq/ETMBGkHKCBBxSzxkd2hwtd2MP8GN1m1ZL8D3ztlRI0inQfX9YZexQE3LnePDsI
    hLJiZrCPKPYIfvxLOJyUytXOdjKpzSmzMbkmjcyAqnkzbEPpf4SgGJawzEm0x0fdIwPwjL
    WUDs8+RNftCaeTHljXiKAoiW0Drmk3JYLBXfpPOAuvxvbfywJHy07rCO+YQQtuk8MrN4hS
    Gjdp+OMmA3A0b+SuFVP2TYpGnsTcGrcLzmgM22cbxKxmJJd4LToubqv0fB9JWIy+7mn9XT
    MJz++EzRZD1yR1mm8QFaqg/rtlE61Yca4OhgDVTw1nD/DjU9h4xDSAVKht2A
X-ME-Proxy: <xmx:Q0W6ah6NgBNPToTjNWoaDm7omAaGWgrC7ZsS_-8lm7O0g2QIPq8ncw>
    <xmx:Q0W6amiC5N-CbhpZ6pkSN_tQeoY6Q9uScOkFbq1js8aBwq4he4mM_Q>
    <xmx:Q0W6aor9HR-Btkv3EH984Ou_Fq34Qwvob97iB9gBtEPcIKifgNOT_Q>
    <xmx:Q0W6aiLViP_tumx3rNT1HgsOVtVpqiNQYGxqh-3WA6npHFMkfpAzRA>
    <xmx:Q0W6alvyKHocqgx1txQ50t5HDAyk0da1pYdclSxqTGrghaw21JLIPODy>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:45:22 -0400 (EDT)
Date: Mon, 28 Sep 2026 11:45:21 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP
 self-merge
Message-ID: <arpEHIwTy8QxUjI2@thinkstation>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 5ynsn69ag6yb9c7ceymefhh35codfqk6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5F7C72000A
X-HE-Tag: 1790592329-534668
X-HE-Meta: U2FsdGVkX1+HxIxtWXZ/5pJwTTmwwqvqgM2PtvhDoYfz+Fz4n++F99gojewhaiW0CiSxcwWvqFx/1agFk2n2nSLK64yeqnKe4bqYPj0/kXAf+veLpwJrfFh/aNT7KOUsvdoJ/Ftgu60SCropXVcuSn9J9cu9lV6seQWBzRFYk6TFz3qQyWCvu+HwR6S2khZzk+8H4DB7W+oIr1jj39AwJ6ev/7LhWUUMlXplCHBA6lw7LiUeJANgkEp2T6XGlp00LxJO9J8QOreEWXs2wGwOluAykot9PY01i6dltJkJCXZsMIRAGCWHCuXBN2QMQTJzvjIxA8afuaadCQhZPcUoK+iO9fFHDxqlMU5olImRpiRIQl0J5pmd07wtyDYqWuSqUbe/6EUBIXW6pVUyMvkbpPCZKv89qYyU7TKZT5GJHM6LxqmpRUYZDsfIwKVG3pPONcwcaZHeumjWKx+lAlBnMtZTjY2exAGzh8PAvGqei2ii7yOOMyg9MdBjulUsrf3tXGkMT223wCUYWOR1yvSFy/2ikuURpo1pt/oA2HqwItxwYyt6eG9nAnvyPA67+TJRz1FYPGgCZ6i3rj/CRwJzUbRicBruyf1e0K32eM/FPBiNJ+/WC2hVzdOxahIGvaORSoeLgqQ3dwxQPFGrdt+EocrV9kt1/KqR/5IzLPaZUHf+UMtD1jy+qaFchmvCZ/aJcTVVaA9LPlDfsLQw8LjLxXLyMLwjICqqr2yUwl9iaCSU0LAXvgOLU4QVtQd1sip/th8qapFl6aQW86P9rsU3Hawbl+FbRG7OZgMstlym6gV9V5XXH0TuGNE82Vol96ywhqjoNjvzMagFUC1Vs0kKy3uMHtZgE4VonfjMIupL/Vkrd8R9lnRHSL9R8LIj82XNxq3A6VlTWXwHhFbzvp0zeETpzrsKV0OktzQPOXQEB+Z3841TsgSCvkrCChdz3k+HI4UduYNNKxWfI69Ygs6
 niscUNY6
 oIaC7m9/7VyPuRtECXVAbwwKMYXQAqKp2p7t3DW7qGE1m4Y1cnFxARxYvKcnejb9mBCcyiWD+FVGUqz4eHWayT6QjyKGALqzS5SaFtOlzluX4T6/ELkuOfyAxE59tIhHVAmy/njHQAMaGDkN+XrSMSIq4Ezq0LFdJ5fauZ2NkFw44dMrEDeNwCZuTxaqCw9XbFyuud2rni7RImZqwMA7ROGjwY2lajpqdhil3gXVTpVszeSRNxU+vDOfL6n7h6wv0N3/CUGv8eJQX5KpzyuwfBr5EgWe1m6wv+0Q5eR+VJLiC+NcXshTXD/rCDjQoHUyYqH7u8bhFrCz6+Ya3Ne9icdywDxmM1QULpYOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> Fix another of these - self-merge.
> 
> Self-merge occurs when a VMA is moved in front of or behind itself and the
> attributes of the VMA permit such a merge.
> 
> Practically this can only happen for unfaulted anonymous VMAs due to the
> page offset equality requirement for merge:
> 
>                            |------------|
>                            |            |
>                            |            v
>         |...........||-----------||...........|
>         |           || unfaulted ||           |
>         |...........||-----------||...........|
>               ^            |
>               |            |
>               |------------|
> 
> This becomes problematic if the VMA is configured by the user to
> mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
> set.
> 
> MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
> for the destination VMA.
> 
> Self-merge makes this impossible (there is only one VMA) and incorrectly
> clears the destination VMA's mlock flags.
> 
> This causes a leak in mm->locked_vm as clearing this flag does not
> decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
> is not decremented on unmap.
> 
> Resolve this by simply disallowing a self-merge in this case - the source
> and destination VMAs are kept distinct and then are able to have distinct
> mlock() flags.
> 
> Update dontunmap_complete() to make the now-redundant self-merge check a
> VM_WARN_ON_ONCE() instead to guard against future regressions.
> 
> Also update the VMA userland tests to reflect the change.
> 
> Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

One thing: mlock semantics of MREMAP_DONTUNMAP are not documented in the
man pages, only in the commit that added the flag. It can be surprising
that the source gets munlocked. I am not even sure it is the right thing
to do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

