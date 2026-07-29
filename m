Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56CAC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 07:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBB46B0088; Wed, 29 Jul 2026 03:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C9F6B008A; Wed, 29 Jul 2026 03:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3CA6B008C; Wed, 29 Jul 2026 03:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBB716B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:11:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6AC8A1A70
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:11:10 +0000 (UTC)
X-FDA: 85040942700.11.014EC2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8D1AC0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:11:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eZ5o4w/B";
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785309068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+khSEQMSChpw3NVSm/yYUm5aInBS3g6tlULYE5PXYc=;
	b=DiuX/YT79K2slIR41FOUEpKTpHYWfWwpHTpfUvuEC+MSL9iTi/UXMkVqPp796mkYEildW2
	c5NkUmpIu5prr5Fh69JOg7f+hD7NrQnb/UmGdFMCkNpnkC+MaHdFV+AERs5NnFs/NJ1E62
	6t1ECVs7Tgv+cG37CHPrjIN0uvH4sgY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eZ5o4w/B";
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785309068;
	b=czazPSxSwiTlxWFLzYzvh7xON9JXYNb9pP7O4maaOaoe4HqmhokeMrHA3CInbHATAWJ19n
	kTfZfMKarWA+ixrxal54eFzti8Ym4pYkZG9kwNcyhqMQ1dZggdMLRIFRSclrXlr06xjw/q
	r//X0xr8FzqX6zt3kF7486Z0WHAZ0d8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16F5340AD6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:11:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5401F000E9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 07:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785309068;
	bh=B+khSEQMSChpw3NVSm/yYUm5aInBS3g6tlULYE5PXYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eZ5o4w/Bf/q3d2ymEm7yvHn5t2k6KCdbK9EQosumr20lgtnsWc4kLOF9+b/7WBwBJ
	 wkXlA1q2+xStGLWbgGey+CHJPyrNFwSi5gynAfduQuIy387RNcCOXBRxzVIJ9KqxaD
	 0agKnMGJZTXMVi8FBDtqlshepL3gDpEXB0rTfMigH7RY4H4/u0kaRWywZPcD/9MXON
	 rrWEi5m3J+lTNVJ5JDiXXgF0DoM5it7X3IVeNlE12ZUT1mA3s5YtnO0qWMv+3sGkqG
	 C8RGLlq2euZ8COOxWPH+G+OjLpdOvSCCwnj7oIqOsdv0eSF9Ch8/v8sqAVSc5BrU7m
	 xIVQxWrcKw9dg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e57a753f9so52030285a.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:11:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrTo41Wqj3tDufBxyQAVVX+7JNrhgup0FtA2GPwfdpBoof5i0dH8A6QjA/Gct9wu4dJiCB4qWflBQ==@kvack.org
X-Gm-Message-State: AOJu0Yx63RRuuRB4vSnR6WVOy+StCrDH8Z4a3HlGAI0yohOOMYOOZzYP
	FDbpeAAeLeJlBZ5RzrGWWgFgYhEq0qEzW9EvQEBX6DZeXtP5QFJzc623ZRwcZOZiicFfIKG7huU
	fgw7TMrj6acyxHvqrwa6rJIdIKcmhN4M=
X-Received: by 2002:a05:620a:26aa:b0:931:328:fecf with SMTP id
 af79cd13be357-933026acf83mr556175785a.26.1785309067407; Wed, 29 Jul 2026
 00:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com> <amiabgyHSz3ZYY5k@willie-the-truck>
 <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com> <3e5d7992-2f5c-4adb-a027-f8d266da40d1@kernel.org>
In-Reply-To: <3e5d7992-2f5c-4adb-a027-f8d266da40d1@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Jul 2026 15:10:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x3PO_fXCNch_Ca2hKn7BjgvLzzr+Sdg+devRUCjgfa7g@mail.gmail.com>
X-Gm-Features: AUfX_mwgraeCd_0quLGHIdabjJBuJlJK1eOJ6QyQ_MbqztWAuvAIzHpjSg2PzBU
Message-ID: <CAGsJ_4x3PO_fXCNch_Ca2hKn7BjgvLzzr+Sdg+devRUCjgfa7g@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Will Deacon <will@kernel.org>, Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, 
	Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8D1AC0009
X-Stat-Signature: jra4ou37n4frpad5cpo8q8z8j5fjfh5n
X-HE-Tag: 1785309068-304304
X-HE-Meta: U2FsdGVkX1/N+76GF5rdTa5TGcgrvilRzbnDnAdeRnKeyBnuZwUtw4gl0HbfW8OdUdhvWmj4hgNy6Gd5cHUq3rY/kPMX5N2rxyuTxoUQa6OcGx7DJK+N3waiBnm5TZ97ubTgMydS1PwdYIQqoDUSWZio73ts86Zrf4ghQtxaRGo7Y2OuKdj9U3/HRwuOIZ5WTHcqMM1oqy7Mppc5Z7HnkIlakyPIDJpkzrbHHFPdfbE5Wyfa7d6M9WcnqHaJm/c9NDX3zojozsVlEMwjXHbSSV9iV6I9O9cUuy0M+bAc1W//UM0nj+qEbrPfiqFqKxBCOD7EOYzp1gZ1bylxMbvMQwmv1bN13vdKJF7wIGiiPRCONlN4UceGqJgBawO0YjpX4B1W/zejTBHXsdbbgJdY90OyVjesBDBF7tzj0Un/GT+s22tFvr8wqa7AKZoPpZPDXkUmRAHxvgs0s/dzD7p5N21WrWXlYhst8MkzZTDii34SeV/PTIfNzhdxJ55azh9zfILRWBgFBnzySIpBZXkS6gCzZS/6gWwN7bk5zOzbdmji+ikjCbArRvLRTTmaenRENkNaAD9OzU35l832153H22lCS/1JszMvI2ZfSnVVIIkV33VqZZB7xQZMhUwl+bIYaXCFQTZL818jNx8/9zFsw0ic8VRWu1RSfpX0USEgbOxUVhoCw5jiT/aqR99V/8eWPdxlfAlY8n5YIXpsrm+es0TOsjWTflWo14Z/7L/erZNIYJOtjT5TQk7/CrKWd3C5uO28o+SY4AXj79nyotbSy7BFlRMNi18MlOjSaZhLO6ihE0LoRvaqoNzsMw6fqYWPHXg7AEMeOzT+mh0wjMH0zmaEUE26BPYpjvsT1zkc2KrqNJG7qYTOr/s5eeQIdKfPGO34XRPARGwlbobq9AnTiFMeoQ6hLmkwi0MME6xCyAFefc9XxeFjG2rGSqOtHCVSunM9wvnhnbNsjUohUUs
 S0VBTzWW
 akpWtNQ5Mkq8mzxqdYjNz8NRO+PvMSkOIYfCBeWZ+Iq2DKsbwVgeXQcHjmwzJFP8RkLEkeZTXWZdg4sSc+ZPWOwXgK20XL3ttmtQlzrMGxx5cSe/QJQN6f+mRieEEQR3cYghsywCwt0KmVT0+aWffbSfMDp9kNpGwFGmJVHV5R3fjzzIwGFsuOR3CF5n52/vQ7TqsaT6ICforAb7fmWj/H2o7CLcyTe0rLQbW8IWoN0dLAQmtwX3zikiXI85PqCn88HZ+mIA1vMWvPfigfGnoRCNX5zI7DiINnkuv1hdhJx3hDIZA8LuvNRwWYuDzhgFVqsnli3GfEspdl1D4xU/7ghNBazZ4r7NvzsIiy6uHtjbjUfpwCn3vgSSrtQLw3Yx/D+HI+pWzNLYA1tv+pEl/eVqlDqB3yrHnBSKF6m6OsbNdw5Z0XvSrT3RdiRHYOiVI82GoUHR0ZeRb3EttxoFPtY5ocqW5bciv7xsh+AQ/T6EoNjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 2:46=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
>
> > I agree that coupling hugetlb with vmalloc is not ideal. As I
> > explained to David, this has been an issue for a couple of
> > years and affects multiple architectures since 2021:
> >
> > https://lore.kernel.org/all/fb3ccc73377832ac6708181ec419128a2f98ce36.16=
20795204.git.christophe.leroy@csgroup.eu/
> >
> > where `#ifdef CONFIG_HUGETLB_PAGE` is required by `vmalloc`.
> >
> > So I'd prefer to address it in a separate follow-up patch
> > series.
>
> It's the perfect time to sort that out now :)

OK, looks like I'll be working until at least 1 p.m. again
today and tomorrow. :-)

Best Regards
Barry

