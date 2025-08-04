Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2162C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B7D6B008C; Mon,  4 Aug 2025 04:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC236B0096; Mon,  4 Aug 2025 04:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA636B0098; Mon,  4 Aug 2025 04:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68D8D6B008C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:37:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF780C0A9B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:37:16 +0000 (UTC)
X-FDA: 83738420472.09.A772533
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2776B2000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:37:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=tQIosnnf;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754296635; a=rsa-sha256;
	cv=none;
	b=FfdSEt4gWMlM473iLKx3U8ln5b5yqRgfaO5Fwf3WHBgVAl5AfLu6LL+TWt72211iOXjzKe
	4b8LvnLcUYVoYcsp2ZAcDZDRI8X90y+bPxOiasQe6G310drlgnUviokCaOwK68oX3ayd7l
	sxmAAGnyNTWglhX+bdpDk+vLQEAs8NY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=tQIosnnf;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf03.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754296635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wPJnPv1bn5Li9I/0MOxjuiNX4rqaManwCgRKuRDtlQ=;
	b=eaE07vI1afZ6/B4UrZt7JdJs8Yo9uCdoimVsx7+au3blMKKKsNQxfXB9f8z1fNCtPhHME4
	XxLDKjD5L2QV11gTra9ydzuV5nfCCdBq//qoNIBEhcBgBYsm579g24rrfrcNM5W0Zoaj/a
	tXdIVPf/plC3nOD7ri47sIiFlLuMiZ8=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bwVKf31nCz9sxm;
	Mon,  4 Aug 2025 10:37:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754296630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4wPJnPv1bn5Li9I/0MOxjuiNX4rqaManwCgRKuRDtlQ=;
	b=tQIosnnfJQ37NBK6nScKmwmL/r2DsnOlMH8NmKwU/1J+eiAE8TIF/z/4vRRMBiXWL9OhAs
	Ev3sNf1iILxDYEV27e320oPn8umOlMIt6ywe0tFVSMBmakfOSZkEOotKPLOxsWsnsDZ1VB
	CsQshtiJmUg9dq7RvfYFsVH9rZMVlC3u15dB1eolZJrLOASd2fFncxcTgJrGAfigKokZDo
	gys9bNHNBOlK+176OkV886HR7vQF2uqIrJVNyLf8ECIQfGBcJgg1kQOo9Ok5CKz6z/C8Iu
	xVAa/fv1eyE1jqdOng8qoE26TuCp4oqzCYXRIIWObZ+G/nyeN54b8uJufuVUmw==
Date: Mon, 4 Aug 2025 10:36:57 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, 
	gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 1/4] mm: rename huge_zero_page_shrinker to
 huge_zero_folio_shrinker
Message-ID: <arhm7vlux7xl627zvlexwziq6gpgxueeslxvjrzhofld7xgvul@uvlyngrizze3>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
 <20250724145001.487878-2-kernel@pankajraghav.com>
 <87v7n7r7xx.fsf@gmail.com>
 <88296851-3bbe-44fc-a507-70964c0bea8c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88296851-3bbe-44fc-a507-70964c0bea8c@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2776B2000C
X-Stat-Signature: 78y3s3sk415yxd9hjqeddrwefbwdaxkx
X-Rspam-User: 
X-HE-Tag: 1754296634-826125
X-HE-Meta: U2FsdGVkX18QKNPxiAxfY8uL22h5CXx27Jph5iAb25GzDbRGybRJuDCR3ts/EVms7F7f4ZEWOzVLXqKaLzYceDnGwnLnpIXg0Jk0XDbCTrsd6eAA73yt5AVUHBsJJ98d4DbFSfl0mhuH7nn15SP3arf/oD2qJRnxfqan6L16PyRc1PjgQlRneHPelMvCzwFab/jNNsLW1Q1wwiSV2/dG57vR5EceuW1fLjoQeYGN+SeAv8Tw0b2dxQ4akEO3+8UPKU3V3GovPmaXj7fi0CZnuvk+5+NrR/muFU4QcGiXMe53Qkem5r8ZrVMd4Uo80q8rgvcGwXfmBhHKpCvkR6nZwIBWeyIWGNK8AQ0y6SL0dCCflpX6yNRas/hEUP4/6pO/QCwBwOAH1IVobvHL2K1pbMpOkGf9skyiQHFZgW7xc56gUKUMTQLwDOEaFy62NuCU1CxrDYI2pGm3snrcw0ZiB661VayLDRmt+SwJvnadWeYSdHIQ6BbgEg2MAQKw6YIAwCg0WPat5eORB/56KLUyzAUnSrz0vPM0sqIMtNsm2IIVQAZooAMiEdTLbPrBAfyQUUuBU3QbyvsGWjY2q+NxbxP+9E5SSYAa3ViLI0OcNEQnuzDFNQex6axGnmPvTYN+e0pdm/l7eoCHgbJ3y/YIgAQjAhU+5h2DkFOagdkAZ8i3Ftv08Lmn1nPPaGzsR694AbbWhD8Ax91GchrlSO+bhqVF7qaSHmePwmT3Tab5QjiIMgVG9M1RndLCHfckQjndLUtEPyvh70phBVQZk59tWoHmgXW2CvgRNVBGV9G/A8Uki7CfKXH+tCF1aAXOLUDsoB9flfumCtKcruVQp04F3Y24+OA3425gAYCeO7aKaVS68WaOqjYrpD5Ya6LUC2WqnHF3iCqoMQglYs6yOzOeA7532+TP1iF8blWGbMfvjeBxg64k0AsYFueYHaQaG3dPuW/in5lg4KnHu/zvuOP
 0BEKI+0W
 HMwVeGscqkd/+zLk1HEZzOVJ+sSuYDDhBRDTfFNed0ML/6f5xG7ZBcmoxHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 05:30:46PM +0200, David Hildenbrand wrote:
> On 01.08.25 06:18, Ritesh Harjani (IBM) wrote:
> > "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:
> > 
> > > From: Pankaj Raghav <p.raghav@samsung.com>
> > > 
> > > As we already moved from exposing huge_zero_page to huge_zero_folio,
> > > change the name of the shrinker to reflect that.
> > > 
> > 
> > Why not change get_huge_zero_page() to get_huge_zero_folio() too, for
> > consistent naming?
> 
> Then we should also rename put_huge_zero_folio(). Renaming
> MMF_HUGE_ZERO_PAGE should probably be done separately.

Thanks Ritesh and David.

I will change them in the next version! :)

--
Pankaj

