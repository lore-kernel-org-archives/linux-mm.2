Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F86A10F3DF2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E67B6B008C; Sat, 28 Mar 2026 15:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4975F6B0095; Sat, 28 Mar 2026 15:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386176B0096; Sat, 28 Mar 2026 15:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26A736B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:05:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C296289944
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:05:22 +0000 (UTC)
X-FDA: 84596400084.19.C356EF7
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id C5430140004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:05:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1NnCQH9;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774724720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6R7bdKTtR01U++16QfLiW3OdiDGqdN4Iruq6c9Hy024=;
	b=M8m+MX6VrZRdmlaO5mKyQH3yjOGjc8nrN3PPazFkBFz86SKy08EXay5MuSg6OpKX0XLngg
	tSQ4E1FNZ8YT6ADAJmaSWm2tKpTWDuf6tIebsWZPHPi192+80U07ZIV4qgagsWo5N9AOht
	qkB0RSwYwU4izGM9p/d19fz+/mqBm30=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1NnCQH9;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774724720; a=rsa-sha256;
	cv=pass;
	b=e6ytFr3efjya1vnm2YbZc6S5StVGkQSkQR4zh4wQWGgNE7vKbL/LWZUPrQ1bh6ZPjNfomN
	FTU5qLlyWVZmhsYXyqdWbQeSE0Rt4OR6BI0yylNtoHOm2t0N1aaKqPmcl+pWo83SdMwFl4
	uXW/J68HDDQNeE1yzrEkc151xAZM1mE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so402461cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:05:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774724720; cv=none;
        d=google.com; s=arc-20240605;
        b=Ra++B72Wf1tPir8PRkv2L6F96s/A1X6QIinTxsJKgBYDDzKx27FAxpQw8m7GDPRQAh
         KDcuJgBo1IkyRXC1cHy66AYqHYpsKMFkL5j8K1vqyYkthLZo66VLVqjdOPtEJ9R+wnRX
         PYAxJg2DU0WMzQBgdnUkwBS6DN43trWer55DZSkwezf9dY5lmLGoOfCU9O0se/w6AuaE
         kM3G1V4it9IKlFv8fj2bJ2+99qZGOrh3XFCWYtQafm65izWByrWPgFFczs7n9HSZx+Zz
         3I3IdMoxXJuBpeT4OdY6q8k7AjEZDqVVLWXLNDNHkjVdMRPYje+Z1m0Hw4x2nGfXr843
         Ni1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6R7bdKTtR01U++16QfLiW3OdiDGqdN4Iruq6c9Hy024=;
        fh=9tnUlncbii4auwbKBFyLRZ6Uox0ooXmtLmeYHc6yWeE=;
        b=RT7F4hZmB2nRyU5LPkTeDnozRbWZ+uRwNDEXY9zBR+TDnClaMwcYndjf/KnoBmdcAB
         PBYch0qaVIxeB+Cqc5qLPAR9CvbOoR3vQ90pT/DbaeVMzPqm3xnuLxMmc2KUh+xaH9vE
         m/42uG6gmjKF6ug8Z415q4edodY09RQs9GkoOsPEXcuWhe8kXsEiyfLAiuBsTS7KBdhs
         UPKrT1s2j8DbJFoPRTh9KmfDIzLU5r8FzW6fhgtPeWXYvhQR8Fcb5Zt0kR2BOCpWgjM0
         nFUM6XGeWYwT900wvWn4OZYzqhZSefiDVSxdt6a7HeA0qMtkz3sAWJ6MgdVzQvplQPef
         w8XQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774724720; x=1775329520; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6R7bdKTtR01U++16QfLiW3OdiDGqdN4Iruq6c9Hy024=;
        b=Q1NnCQH9SuJyjYDBvzKyQgPQpSR0ntPWLZUTlEqj4RxSGK7cwlfVL+Tvv8y8HFF/xR
         hQuY0OK+KpWA+tm5lPo/wma9AgVPIOCRKyY1ez4uKPm6+ggqa15AxZMNRe9kJc+tIjSN
         hbDGCLyuO2klSZWZpqJ5o/qfJA1jlovFt6CCkgZaFqBBldu0ZHGTHIK+VyocQsb93bFG
         VycZrlNaXnxl3meYKlkyOc9dR4h8ESYIKM3MgZYD1JVD9j4ClPE5pMNwgr/R8y+Uk86a
         QjUxXjY6QNhTdFrpnztDzwb104q71n72I7vOloA6XniUGuh8utXPzuLFe2v2ZhItvmWp
         n5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774724720; x=1775329520;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6R7bdKTtR01U++16QfLiW3OdiDGqdN4Iruq6c9Hy024=;
        b=AydxM2BxM6oF8PxqTd2iHq0tMAFJDMDA2XMUPEpzOriBj8jgdafU30yogKw00h//pb
         lkUfDVR9LsUFgyrsk5Jin89gOWHxDNOMMxbz2+Bq5v/NJnKoZkApUObcrub76VK/KEcs
         WPA+g2JVsRj3K+gsgxEO1GIB1weHgpEMGAFF98AJhCx9XK/jEuNfMcdJbmV+7GG5Emsw
         vyJv6xKy9AOW3/o1BKZ9Eic7v30yfmMTmodbyITcqI74UPE54SBrwqf5VIGpxYQ7VCRd
         j7W2aoqiZWaBthX3LOalAaklkpTQPoJ6wiYWWBD/vv7l4SHMPhD5DYyRFXh4V4AyFTyV
         vyjg==
X-Forwarded-Encrypted: i=1; AJvYcCUvB543/u25jSCvLHk30oK8HjZIZD9PVMhXKRykAv34EyvDhBrfHmJGaBwZr/Be2yLUeDxms5Kk8Q==@kvack.org
X-Gm-Message-State: AOJu0Ywgmc5lNHkVDXn5LA4mU5Hvsf+bCSRmDbvC5bDfS2M0KqBHZlCA
	9wOPBF8Oph18stlNReBQULwOmvC5zxFXKM6MnoX7u/UYANk6YM+ka18x60V+/Aj1N/bEjDdOvdz
	pvcDIlpZL34z4ZsfsaiAMhRT4/lht1UdJSruTRHos
X-Gm-Gg: ATEYQzw0wv9rKxT8LGT3eTu+ZFNxJgau0e0VGHc5X7YiZ33MRk95SC0AX2U1h2olLy+
	lUqsfNcKmroOmzIeUWyZfcFZilMqdp/OGIX/E1ehLh+gatDIBkaW6OI7fHS88HzErPiPA9cZ8ik
	xiKjS9Bc4okSo574l7cnaUhl630NE/868bMW8WSc5sgx6fZ+myKfoxciJka9SW24UelWuJcwct+
	IhNFZILbKgeg9cCYMat9yXlUGSLwS4mB3EmtJg7oD58nX6+9rWmsMFWwEXsjcKGAYEdYuv6/KMc
	ZmGtzZZvsVCy8SnU
X-Received: by 2002:a05:622a:120b:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-50bb3d35bd8mr9823291cf.5.1774724719216; Sat, 28 Mar 2026
 12:05:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <fcf1f6de84a2ace188b6bf103fa15dde695f1ed8.1774029655.git.ljs@kernel.org>
In-Reply-To: <fcf1f6de84a2ace188b6bf103fa15dde695f1ed8.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:05:08 -0700
X-Gm-Features: AQROBzDbGRimcZNigZVGIjZ3oSvexAYkt4odzexCd2mQSgiQhUIxn9ELrb94nnM
Message-ID: <CAJuCfpHQj+-nfkDA+kH8_KhCtrPixLvHnJcTK2KtWLD4wXeeyA@mail.gmail.com>
Subject: Re: [PATCH v3 04/13] mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5430140004
X-Stat-Signature: cia8x4snm6wen95f11qkezz7gs9fnbec
X-Rspam-User: 
X-HE-Tag: 1774724720-325967
X-HE-Meta: U2FsdGVkX1//cdR7Mx9ydwfNGZMFWen2YLaHngazGOgTP90xx5zCb2pmD5+wA5lJtZYWVXrA3PY8gHZskYACJIQT0tGBsRznxQurF4PXdKd6oi8+EycIRMz7Cpyif7rgUcZWP/cT3Dm2ErA0Ci0maI/DISsy0dfvvL37fqZA04wLeb/swy1LvG0wjWeQCMIfEqQ2tFWlSU53CqYpJj7zBFAm2+UXI00Ep/k9mBb0A8g70/ldawxcAX050TjVci7pz1vq26QeYFmXUMMvwiZ93EVbrGVpcso0mOgPplSHE4rz0v/w+aqj1zNzL1jLp1zglFp04z1Q8K0r5en1jmzwRUi5vXeimXcnPRxVPtYW9IZi8eWMmTd3LZR6XrAovDDWP+f5LVb6CJ+FqSETjo3uQm5zZy922tLSXuwIzHRRoIqRN6Hg73veoAuEZZsnnIiXkf7sgz8QGtTOLCJ865tgF0OaAkk5k22i6+FFEM9b8jVpoaFWInpB9auwEoe+NyofgZZ4eS1td5CTl6FxnLR1H3yA4r7Q1PuigNrxao0C82lm2VUY1yc2ZEvNwPKX67mnN8oyGcDomlnjECzB9GFwZi2fotVZ5yXMRyUnhZYalf5YTPI+C9R3+ldhWVdyO5mYUM+QWPpWcX6i26xS9bLKfjglTxk9aw6z8SvZyDYR/4tg7pSrYdF8+A9E5LIJy/loDH4ri/2i61sZwHv7/jqgFAf9qM2Wkn8/Fd5FYIrqC2xwEHhoXxOVyArbylFIJl6l3YK3fKX0uk16JgfJc1pmrF7SlEBlE/eQ254s8NxKDxtTTTE4O9/V2/7oGU2oq1J6IEcz4J9FbnNT0shth0lx4pEZbHal08EVD5az/NP4M5FspOGcEyK9BzE2nU3Zd78sXSXDiQkA4yX/GgXWimjENAtsu7WWtPY0sgbNFIlJNdelq41giBu5AL5BiMB0viF4MBCXOmw9z7cYdFhAlWq
 L63zfUbz
 HTTieYW1Re6qyE3aSEnm7rwLEhUW6NZG39E54UzPaTn/cIwq7v0LjlL5fgC2xzKRiZe+GANhhgljJco3jDSLND64OFVGL3BHu0Uv6nrCv/dL/Xx9k3bV8kY3BnxV0XJDzUccK8u17u36G9nQcus/hxTDhnMySvsd15eaFh7h6Cd4brr2usVnqenZgPzlKZjXYJe/U2IdcirNTWYpj5tV/LpYKPWAlSLlI5yAynmkaRgNOdZ+SJBiB/g63/4FycAkYZiLX11xCVyd6Do63/D+tud6ZHj2rOIlCp6ZlzOfeYdjl76aidvWaJCMe9Rq/rZ4SzeqO3JssyH1CtlZ/GzRArFqsKBGa29gMcy5K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:07=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> A recent bug I analysed managed to, through a bug in the userfaultfd
> implementation, reach an invalid point in the zap_huge_pmd() code where
> the PMD was none of:
>
> - A non-DAX, PFN or mixed map.
> - The huge zero folio
> - A present PMD entry
> - A softleaf entry
>
> The code at this point calls folio_test_anon() on a known-NULL folio.
> Having logic like this explicitly NULL dereference in the code is hard to
> understand, and makes debugging potentially more difficult.
>
> Add an else branch to handle this case and WARN().
>
> No functional change intended.
>
> Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lu=
cifer.local/
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Overall LGTM, just a question below.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/huge_memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3c9e2ebaacfa..0056ac27ec9a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2385,6 +2385,10 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct v=
m_area_struct *vma,
>
>                 if (!thp_migration_supported())
>                         WARN_ONCE(1, "Non present huge pmd without pmd mi=
gration enabled!");
> +       } else {
> +               WARN_ON_ONCE(true);
> +               spin_unlock(ptl);
> +               return true;

Apologies if this was already discussed in earlier versions but why do
we return "true" for this case which would be interpreted as
"success"? Perhaps because we still managed to do
tlb_remove_pmd_tlb_entry()?

>         }
>
>         if (folio_test_anon(folio)) {
> --
> 2.53.0
>

