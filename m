Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E8C606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yvPwhGJk
Received: by kanga.kvack.org (Postfix)
	id 88F8B6B05E2; Thu, 19 Nov 2026 19:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8669A6B0605; Thu, 19 Nov 2026 19:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D2E6B0635; Thu, 19 Nov 2026 19:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 462FA6B05E2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:21:38 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1463408CB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:21:37 +0000 (UTC)
X-FDA: 85453593834.10.0BDD901
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAB15C000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:21:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yvPwhGJk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795134095;
	b=JUWncBys9XGOYv6oF8rH0IbXtw+wI7Cqp1GjndJs43xvB8e0TKpZ7MlkPvjMKi6TVU43aG
	ky3yyPU+8oMhZO/qx62/ol/wl/3/E/ZWVmKNNVHMzfgzpQvvoaBYLEVqH0K+uOy7U4j1fN
	+zVbeX/SeSmNdOODaJPM1k1q8Uoxlww=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795134095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
	b=j8ZkQDeo6D1aWazkhfkIrSXLZ5JJtGDHchEgG6HnKkeKQC7eWUlyJ3Ke03qF/kspYDZ335
	0TDDuw7VwMsneMuaDES7ORHZ2SdyQSjYGPzRLDXwxNJ6pUgpg/A02OofcnQkOGTdMUYKEB
	QmH0zXhf+RMsD6ypfYOsTmr5BLhZHQU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yvPwhGJk;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso2553675e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:21:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795134094; cv=none;
        d=google.com; s=arc-20260327;
        b=iTo2tkwGmcA06+6XCKfFCBi7c+0L0rBERjaePxIeaNDjEPk7KdLANYM30EGpKp+510
         LVS2EFmzUrfYIrWOOqfY9jGy0U/WaaRITKnLFq4Qteyx9UDcgBhUFfyqQOkJr8B5D0DE
         1hYpWfoaUglbcEdKJKcSA9+qOnYHYHV26RjLJ4WQpV4c1XmoHsKgmfi8/LVQ+TTsdnAn
         c6SpjBaFMQybOnzc4/FLlnauMsincg/zLN4gJRHA3M+Zjkbp8heM+owqf06zEiShbc/Y
         CJXOkXNGq6py0sqqEzhm/dDBD/hHXRJnkkPvSiDXUIUXjsQ+UTG1snNFh2qo6Df3gQ+i
         Xy4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        fh=39UXCLgR0fVvU6WUJKwhy8HUNF3wC2RwkxhBqn+gC58=;
        b=BoITSZX+PCS0MdpAHlQddzN2RtBxRPMjKlBnxiAXMrFI/a5eQYFfdR7gH5Pz/+Cc8g
         n7mt7XfkOzHYVuiDTEqoGZ7F8uEBZs45Ll58uiRTRH4ig8E71LXuI2g9fkZaUPPL9tu2
         PZYbAPXaV+Hyiskz0yZNNwVobRW4MHS2Xuv6Tv3BG3/0fxjZuCLbsQX+Q9K9TxvvU/Qf
         4x1jZyZKqEdBvDicyrDC0OvgVygJbbkE437JZLnGo2uZFf0OA5L/lTFHGt0cTc4lev2E
         AxqrLF8dTjfcBr/UyG1HUaIaVrxROrKAoCsMuMbu6rTZ2Iqrih9GNg3HQu2w3aVz+5jc
         YCQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795134094; x=1795738894; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        b=yvPwhGJkErAU9e48fAzTaGTCr4X/rhOZwaDoiQH9XzUhbFe7Bi6DLFKoiUgOa2vvxg
         BzLRF8vpRj/sNcEgPK9PtqkvuK72A5e78brdMac/m6H9Wg8LH6sBiXXxGxWG1wJZxKiy
         N0LKOw39Dlmw2HrxyWpJWgQc0zrh6nMviMmIGkcEJK3ZQlKtWZWUqMuZiqeJKrncsywS
         yK1gXG1ETRHO+cp3PoVrM7UBCXVYOMlTmwyktxQSI+vVoSY9LfBE9kT7HCJUp+l87R9f
         t3azY4g0+8JOVt9p8wVHjdor5gXH+n68rD8P3UP3cY4g9QYiHivn8g+wpePiIwSRNiHN
         Ze3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795134094; x=1795738894;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0CZfHhfHfESc4YrPufMYXO8QeXfOTlDtABpZbDYX5SI=;
        b=rYwFJ7HwTQLyFMEPC6utR5lMfy6Ijz/QDRCt+PB/wzl/4spgon+gDsPUNDx2nSvBwy
         DU7ws6qB+T0AHwGJFC4k5oelKmFmr1lES//AzLQ3l3ce/XO0PtY4dQZ0mjt7oCjMIzCt
         klphHjp75bZcZwotCxJKMLSR8g5pk4ysJ1Ye32rphXo8ddbckYLxi9bq+H5x6fFWjdjK
         acRGItNVLAUiYNjeBI+6yrg6a90/dKslUu+owpqxbads689RdDayKd6KGdWNlad99ael
         4w/C6pzFpUuF3h9NU5kcnWA6ZBqadhvTTEar2QqSPE9/gilaMqvOpOUGQ/nc5Zv2rVc1
         6s9Q==
X-Forwarded-Encrypted: i=1; AL+hErHx+EL38WcmyK8BMACTEHiVxPaXsbeqEEHPrS1ygFloUdJyPFEnpFkASvr7Nxjytzal588YJma/aA==@kvack.org
X-Gm-Message-State: APuU4Z+bg1jbxxO22AKHe1Qo/UTLwbEUSryJSVQeZE9PM5x/5+V2GpNn
	kHNvb8KiYYcce4qxU0V37TBrV7bW1I7H1OgOBrrrFTaJI1zbJgNaNvYCKlJbOKcFaTCOiTNQ7X3
	Sx3jKJPchmN4oFveBKhiUW73NzV0VDds=
X-Gm-Gg: AYBFou3vpBT4++dRQbq/girCw2iZXt4JFGhPyxv/NXcJXo2+FmAVoTdNElB0V3+KQpk
	ZpdnjjNZbfQYmxpmfBCB3kifjmS05DskcH6OIyQpCPKUKvtX+ZMTyo9tsa54HFRPUmqhwfj5Yle
	a+Um4UHMgPEf+WuLZqW6mfMAb3Xl1uFA+B7BiJOvLrL0mDPHPJGAqIW84+4EqLopUvjj+jEc54L
	V7HFOdP1rotSLBI1w6Zoc9KLtneDy5Qr6I502VTsotEb873Ehk/VQBoo2AirOlSkRLHD7Davl7F
	yQz+L7+7RevAY9XFqJ5eKtUE8Udj6y42VEBaKTVhNue05Fk/jxMDZJ6DiuUBICmVgQ43Ma2gQL8
	a1Ip4F1D+QCU19S4rJSxfGwe6ynP1JXC0FE7HaNg8ISOswjDYU3FYIRKSdtpBGyhu1yCu51nmn5
	m1RjZaxjA1hARNr4MB3a10/ICm9HYDF6XaMh6+XjvF
X-Received: by 2002:a05:600c:4f84:b0:4bb:8701:a2df with SMTP id
 5b1f17b1804b1-4bb88809950mr27334705e9.17.1795134094416; Thu, 19 Nov 2026
 16:21:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
 <20261114002822.1043378-3-joannelkoong@gmail.com> <avvhFAxBcPk5Q6pW@chrisdown.name>
In-Reply-To: <avvhFAxBcPk5Q6pW@chrisdown.name>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Nov 2026 16:21:22 -0800
X-Gm-Features: Aa3M54ocPog8ZiHHSRBMvtbJbL2fyYxbh9unTOuH5y8YoEH3_wTAT4fdm-kxXRI
Message-ID: <CAJnrk1b8cCOVe+4KL1LTUqw3vPE1EiFcELwurzgGPtfkvc8UoQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node counters
To: Chris Down <chris@chrisdown.name>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAB15C000A
X-Stat-Signature: y8wzosbdb3bxacfe63ia39abskrw87s7
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795134095-585434
X-HE-Meta: U2FsdGVkX1/LoAdpmNAd+5Czq1ciqUHv4wi/+rw0svMmjJWk3uFqXpWZxkFdX+Ze5KFkgXxR+GrddrdNm2O4VttTYpB0bABXFOwWrgpVfMNJ9u0VIjf2iYc+z3kNg5k56yaRkHawUF9Av2NvDN3+Y/9I9FQW7pQek5QAb/g4eB8so/BXmmSXHG6XX+3+/4XmNd2JSE1MB2kIFGyP5zHPSlEOX99kH8CsW152Re3zb6dIQU2JvhZkRYCslof94K5RH/THIgCfZLoSUNUdVfjjsmj9iawU07eOzzfdRx4BUzK5oykaMC9KZ//wQi7PGMyjx3vo2bG0a+FxqDXRZmWVxMKmALJbN8wNHB/WYm35j8YEMhdo51rimZgwf+MRLTJvohWcx3KzRELQXiz33WXL6EAgQR8vZrQWTyFTJu9rbwjvyy+iZjDOdmCXJ/PCVn0N/nj0VuPVJ3BJ3fQc5P6uZU0omKcbEO8NKx3WA17Zxj1KO4c40cYuxSyFubLZnE9bk3tOJWBECRwWewGS5my+A4oIldvLV9OtR+sMfp5VAb1B7XZ4eEgXRArA7FhG2v3U+dtVXXBnnY+66zA43zX5lZMnCKGYzpBgkkPLuz4JhYBSqN8vkxJxSXey4FHdzfrfAeHjjKMqpBUcrgyLwC4HC5EmB/YltlVZ3sSEhFwVM1ggwEcudmG83y0NaQPZYdSY0WAX+PtLG28+6lvJ49e2Qj0UTPN6FZ4v1urCKz7/rrOxJIHwUC70kXm+tOo8760f96CddBBcVWmvCWx9uH1b3NWYe9FBcFOVO3KXPS3xzgD+i1maTVvGoH5iTIYH+5fonLvsFUuzRP0KskjltR5U/cRO4SpoqVtbOQwB0AwxHZkK7okWVkwqWJtog7Wnqrk7hnix2r4nDQZjQVEjb7fi0OFxCl9r/3dBOYuq2FOfsg7z713UEmn0cul8aeyOD31y5PzKvlYSQk+oCHhmakP
 E0GGBoVL
 D0P4s7U2W5YRbeeiBe/83W+we8Ne5oqVI2BU9YGttq3tMK16QmJtRHoBn4ePgM/Pi6dosGldIgP5wjC70qbITjNkOTCKYJed6k+IlJmQMBpdcaEoQ21FL2plzfoh0h5Zp+bWikkOX0HG6dAF2cq0pgS7Hy1lflM9F5LQUoFhxF1MdDy+13LqQxieJSHWLQyhJtKgTK6oD92Bc5ONsoeLRYY62ScXAxdLroKaf7uvRPSTQ9Dunh0QHt/1jBR9or2mE2sWMq7rgdw+fcdebEYUgbiEQ9gnhxOYogNrb8rUI+WlSlsZKrfD7ZT0kJrU+eJAvvqWu9T/IfS7bjBz/IrhIeWTr/ariqYPSyhzqI2NApQ7cw8Pt/ZhlQGfHuVzKzSdWETeW/0YKXzWdSmr0P0OD82G2PmbNKWE/QKlJsRGbL5F3l5ZRPUj3BPem9jizGkkEuzZcv8ArAdsz1NwA4wp72ZNKJEIBV+/eG5zJo3XYX7aP+FBIIIYfu0OEIldcCxXCXlITfkQKZb6d2AZu+4yCy2T7+ZB+Xosnl4IIk8K4Co/zUH9sBYYUgGwc3NRZp7GzgoJkkqjYQTar2mkV1g86BXEZfXPvHNvednnqwnNWPmD76O4Cfa1LkQ28zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 9:07=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>

Hi Chris,

Thanks for reviewing and testing this series!

> Hi Joanne,
>
> Joanne Koong writes:
> >The exceptions are the kernel memory stats (slab, kernel stack, page
> >tables, secondary page tables and vmalloc), hugetlb, and
> >WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
> >objects). Their node counters also count memory that isn't charged to a
> >memcg, which falls into two categories:
>
> This still describes the v2 denylist. With the allowlist, the root memcg
> also keeps reading rstat for NR_ANON_MAPPED, NR_FILE_MAPPED, NR_SHMEM et
> al, and some of those differ for reasons outside the two categories here,
> like swapcache being counted differently in the node counter, for
> example. Could the changelog say what is on the list instead? So that
> would be the stats that only change through mod_lruvec_state(), with
> everything else still reading rstat.

Will do!

>
> >+      case PGROTATE_ANON:
> >+      case PGROTATE_FILE:
> >+      case PGREFILL:
> >+              return true;
>
> NR_VMSCAN_WRITE isn't on the list, but prepare_scan_control() adds it to
> WORKINGSET_RESTORE_ANON, so once the root flush in reclaim goes away,
> root reclaim would mix a live node counter with a stale rstat value.
> Unless I'm mistaken it should go here as well.

I think your analysis is right. I'll add NR_VMSCAN_WRITE to the allow
list as well.

Sashiko pointed out that NR_SWAPCACHE and the other charged-folio
stats between WORKINGSET_RESTORE_FILE and
PGPROMOTE_SUCCESS in memcg_node_stat_items[] also should be added as
well. I need to look into this more.

I'm out on PTO for three weeks but when I come back, I'll update this
series and submit v4.

Thanks,
Joanne

