Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E79A3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IH1LFyTK
Received: by kanga.kvack.org (Postfix)
	id E57356B0B38; Wed, 25 Nov 2026 18:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E566B0B39; Wed, 25 Nov 2026 18:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6BAC6B0B3A; Wed, 25 Nov 2026 18:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B22926B0B38
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:58:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFC6F1A01F0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:58:04 +0000 (UTC)
X-FDA: 85475307288.20.AA7D4E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D60CF140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:58:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IH1LFyTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795651083;
	b=jFgPyyrJg8CGcdVO4XXxkMA+baXd3RPEK1m29o8axaszVBlwQU9SPKSz2KlvDAW9J+YM3e
	ecDKYNtxFQj5Qgfk4XhXen5a5FKnMOg6b9szTYiTGEyTZBTO3NqexqyZRqUkL9nB2M+f5e
	CYeGeEBLdywbprTxQbpScZN+HsIyMCw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795651083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QByRUv5rlJW1jHmEeG8JFi/GILcESu8Vs+uT+WAAoVI=;
	b=V+90Hg1warCcx+JQg3rkisc7ImObqNHyZZwOCXAxurte5pRHiwKxHsPfmRavsmFfqoRiFB
	4nmByWabC6Ks18xVjqI9vsp79ZNoXmG3gmsbfTjWujnDIn3cbCEVyb22ekZVqv9/KOGLVd
	PqJatjUbwVXKmT5FT8W+J1Atj1q69uI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IH1LFyTK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2A9943E64
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972BB1F000C6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795651081;
	bh=QByRUv5rlJW1jHmEeG8JFi/GILcESu8Vs+uT+WAAoVI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IH1LFyTK7NOleATIKojcyfyUI4cohYYE6aF2tNl5T4DZP8Y8cO41S4Xf50Br2p2Zr
	 vxg+plKQmR3Toq2rfhRUea9O3Ow0EBmjSUfD3YUIfrzCcmlpCcH/CvgYQjCyUeEhNZ
	 ixlcO3ODRLaarTeKbpBrr+BUxpBjYuob8miTTgKA+mu0/6J1HhhSPQPC19XzYbhtKf
	 X0/2my13mg6VZcN2HNNNHEoTjWDqboTAmvH+ra3sP4PyZroryl9wURcnx9op7Osg6x
	 rpFHftOU38ek8e/jybJ7OsF0ovD7I3y4G0tNjbCdKtn74e6QhJecKNgy3mNHfYrZSm
	 iGZTK9zyWSKRg==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f20b304c0so577248385a.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:58:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEyshoybIxVoYymuEMIEh25K0XdQVXh3KWyJB3V9AUX+lkigxcL3zjvDayUlYizJbHx5tT9qVtCCw==@kvack.org
X-Gm-Message-State: APuU4Z85hVcleiFugtmr32JbAdHt/Rn3AUjOEhIx/Hybuhr04olE5Ups
	ZeWF6GDwmbCcMejJ8OdGdgUmAu9SmwngZtzciLhjp9G0fkBrMZFNEpb24ID/NRrqqN51GW9YFEs
	toR2iFiquMunMrBtqfCH3WzgDaCb23e4=
X-Received: by 2002:a05:620a:6910:b0:944:12d5:fd45 with SMTP id
 af79cd13be357-949bab2a96bmr3505693785a.70.1795651080960; Wed, 25 Nov 2026
 15:58:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125094056.3973331-1-ridong.chen@linux.dev> <20261125094056.3973331-2-ridong.chen@linux.dev>
In-Reply-To: <20261125094056.3973331-2-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 07:57:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
X-Gm-Features: Aa3M54pAX7vIIF57y0BLBKt6gLxfgtAaQydmyS4ws5dmZll_OfbyOHC2Fq1AauU
Message-ID: <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D60CF140003
X-Stat-Signature: xht49knex5nfaxmfcaraimagh3ari4iz
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795651082-441036
X-HE-Meta: U2FsdGVkX18anrlFzntRBGaTeG7PARc8V4HZaEVuMlTTkioMqqKsZVNKhQErUdnKOqyXGrTmQwt6oFgNmYff4DmcZxpm+qAuOfrHdjlPGfh1Oql6tSKusmIwOFyyQHGrhQAKToXTOmqM8RoqHSPIwVudz+smfSnRgJjk7bR/3AD9ct6U0jE68uCanGtkTfDOo/pemYeuQOw0KiatkbyXBn4OoPXIrVXQMkY0I9UrUpnsTfaf+llAXRmSvC8O7VBXsOqnrto7aNdFXBTCzbnW/Lk6IECIAQRUyI6922kNPhssYW80eDRTME8EXN37ewlNxtql4jkQqNYsRtoZpaLZKjTYcEXYPrxfu6OyxlI86ynCqIeUnWAk65DL4n3JsKNn5dGg+5DX5N5Guwb7ycoafEWCy45Ibd0wdcnWXVmxB9Dz9Rc+bwljIzVX2G6kB1z81hAEMWMwxkdobjT1y1I/Pm3lgmfojb2rpWyWWw2dzlnRzpsZjK7n047YPQOhbz+y2QHLmL5WmoAjWWPH7ZhDMiDkUOCH5MKAUG4Th34ZK5vbKwTbgH8syXMIzIfxjloXdGWsubOgB5r32D/+7g701x05KgjzNT+wesXkvmKwPUwRFDfXr4HFwi5FVSO8OIr7IGV+YajPItNGaQdWfHsi+bbKymCp1jNPN7fsk2Q3G6ERp+IXBsRbvTjo/ZqXe4epqLaGiG8Deu/Yc1UDO8PxtJH6HwLADLQy+He6mZnj52pPvvKOYyNL7PRt0NOTlzvoSXSdjuxLrhQMMnP//1cMFMB3bAdGMFCoKiN/rUmFoM/GNiRwKgjE4y4f00O/lo5EOvlRsftOASvaIBIbVzK7WdDExWNuPL4bRIxYOL1FcVqGtAqTsOBZuc8rZhIYd9SMPOCQcMmCjRAxNRyK+kNWYa0PnnpQzUDf0J126pN00efztSs8Xcyox9doOloH05uoeN9tNw9yLrO4QqmLY7a
 DwCkknIQ
 1mcOnFzGJI2yfLGwReCwHcX+uQFCXJVG243hZT7XEJZv96okEfcOcPVNxGroAvFJ6UMzGisHqHvWgqIqZcERc5pGvuslhqSLvWIdLysYk3piIJ83Pk0nGe9hHKBiV1Tige8iWieiPXhvNdoHmq6b+X8wcitJOPakvziku3VK+U+SkLCJFUqjzTJA36XjHcR+GeeFGwOnhzX18whKbvYStgH6zStJyeKlpnLE4IOrZjlKlf5HuAdrq4M+KBXm1LY0EgXwhbT7hLyCtGYogo2LP/WPmORK6escfVw3ae+FJT1F3mXCHGihRktenQ0Er1ZbU8GUImpghQV0tMGEPNmEWTycPsBhbzDA89BOF8+nx3iVPI7N0WpPNEOo1l0O5OkRGzb4/5VKWRpDJ4eyfoceQAQfNaIzoiRWdXPRGa9jN8cNPN8zyVgoHLEnyPN5kBReNKJfzalgckpkMAXzNfrAaj9jGbOJD5DPms26OEJbC5kDKgBmxRUAzyLKj02BQQsCHy5qUbYfnw724SWF8zOvU0QgVKAsBq6M0KShTJu6bmhVX9keNFPjqIBIMiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> +/*
> + * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
> + * MAX_SEQ_UNBOUNDED for no limit. With no limit and tail set, the folio is
> + * added to the tail of the oldest gen.
> + */

Another option is to make tail and gen orthogonal, so that tail
isn't necessarily tied to the oldest gen. This would be similar
to the deactivate path, except that we would only need to set
tail here without changing gen.

Would that approach work as well?

> +static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
> +                                    unsigned long min_seq, unsigned long max_seq,
> +                                    bool tail)
>  {
>         unsigned long seq;
>         unsigned long flags;
> @@ -406,9 +413,12 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
>         if (folio_test_unevictable(folio) || !lrugen->enabled)
>                 return false;
>
> -       seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
> -       if (scanned_seq != -1UL)
> -               seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
> +       if (tail)
> +               seq = READ_ONCE(lrugen->min_seq[type]);
> +       else
> +               seq = lru_gen_folio_seq(lruvec, folio);

Then we wouldn't need any if/else branches here.

> +       seq = max(seq, min(min_seq, lrugen->max_seq));

Thanks,
Barry

