Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FD40606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xiXoJimB
Received: by kanga.kvack.org (Postfix)
	id 9857D6B05B0; Wed, 28 Oct 2026 13:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C526B05B2; Wed, 28 Oct 2026 13:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871DD6B05B4; Wed, 28 Oct 2026 13:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7F96B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:14:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A2B2A6FA2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:14:48 +0000 (UTC)
X-FDA: 85372684656.15.86CE6E3
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06B7A4000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:14:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xiXoJimB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpvH8Kp7pKhcNKeWguQojqXnpg5TBg/XvZmMs15zNuc=;
	b=DuCvy6plAjh6WFgS/CxCuFA4N/xe45wOBLcaIGxpAoE5s+zPK1YSZrzRRZWq97YAASPdzQ
	KeAkmCfs4h8ibvY2DjsqnOCuD+ouALimg4XJsbdmoees4xcWSV55sURKWLR1E3408MrLOn
	KlWdqUlvHYBxOSsNruloOHQNwwKCWS4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=xiXoJimB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793207686;
	b=bQIz4Hk7itNgvavZN7rbD30GVoaso2H0e/BVkJT8+Rss97AyCotavENTkfCf5w++MgHcHs
	va9nowDpgRB5IE93jnjuoju26ed/1jcyHh9LZ01+6k+5Ojx7l6FXs8NOnSwf+n/t9qRzbx
	m96WKbe1j/N+IjQD8Jz/VsWK0G2jyyE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so11214085e9.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:14:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793207684; cv=none;
        d=google.com; s=arc-20260327;
        b=oZrKAqszX5/S0nPakuuaONPTEePEIGT+FaeAYvqaiodTTJxpFam68Gmy8JIe+0iAG4
         dzfaYE5r38MbzlqZfp+QY/e9XwEk3IEfLTNZMI3BTSB/5w+peGiBs7c4X+wb03M+9vXE
         iSj/dyyWEby2VJtPPo5lNHjuDthRl6ujD1czn1lr6DwBOhYRDVikqv759KMyP0Ygk6vw
         ODOpCiwrDd8siFUNs5BdpSPuKNTdjJ4HDdHSq+kJ0RHHWcYnUqHZ96bUrk6C5WcYGNj7
         33BQuMNTobOI1+U7exbjK6bJl1emXRwICc5cdUAiiW90LA9g/57pVjuUhxvbN9Vl8dO7
         FRwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bpvH8Kp7pKhcNKeWguQojqXnpg5TBg/XvZmMs15zNuc=;
        fh=uRisIIFRNIQIOBmLpQqQGQC0+UhIDzdZsUoZB538BtA=;
        b=GF+6NIykANaGAmVV4jssZZGRljXxCzMSYHHNv109BVx3yQX0d/v/b7dr/T+HBYmO9C
         XgitnSRfGlcWM31eobH9jvTjWnRBqordeFdZjUdq95ofZdUOT3EEXDcEmvrsea5fA5jN
         EjP8O6SofJaKX7GhgJ3WjqfGL3gSqYy/VrpcONoKNgoX5iZYYtNOZ0g21Fkib5tgwiS3
         F+THq2WJDXy8wLJ3hFC9b0ZgOGpCdz4bEc1xNGi/LwWXkVilgZFwO/GW8OWbOaR2kXAF
         f0AAz19jM8ZIol83F+W6qM91Zvq9F7RStbybcvHAF7Wh0IRgHwmx0n71xlJyECjirmC6
         wVow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793207684; x=1793812484; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bpvH8Kp7pKhcNKeWguQojqXnpg5TBg/XvZmMs15zNuc=;
        b=xiXoJimBsbyx3HQxbCF2jOu29KYdqzpVOm9KNQXiTS0hkiiJ6RmJgZigcGNTpBrSSi
         ycMbcnEgEZHferIoTG2AanL7hP4XNcEcp6p3rFGx6n8LLtH/Un7GthdhE0kI14WV2/s5
         BtdgevIhyDW244Oz8LZCZg6LMmag8BP54m+pLmk8FyTAqt493uWLLVPoboaKUqam0/9J
         0fUFACsrhR4bTUixwmyrIAnxNVOyxHX5J6jrR0ii9XSEher67tAs4qc5le3fJToWqgVV
         7PMcuQq70be0FUJsMtyHdWkGJvmDY70qLr7L6BN9H9/fil7Nso1MHn3Lq+Nte4hx3nMk
         DCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793207684; x=1793812484;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bpvH8Kp7pKhcNKeWguQojqXnpg5TBg/XvZmMs15zNuc=;
        b=1FoCScdn3XbVrfA0JG4hdIWZ+42KRbgQwE+J/b3iewzRessZqSl/zkq3pyTrRyDmSR
         GQ09vLRjqO1KU0PpkhmJXO4vDS3gDJ/oYBSm7fhZCuI38lsuVAx9eHYaiOxAJtvLBwC6
         Dcv74jw43oN0rhIodaoJT5J86y7ZXt/h40AucfZDoueKUAuAW/gEbYitNq8WFfd3jUOb
         vAjS2veCFtCA3Mwi986wacV1J0F7Luszq8MDSOaQVecEuAopXyCa30kWs1NjlSjZqtX2
         dV+8g3x6gopbQfYO8pEn8gHDdzVlXbtFGYUm7DxK4im7S4vQoMHwVcMkbJf247GtMJSK
         uwbg==
X-Forwarded-Encrypted: i=1; AKwUvByX1EwjIA6RezAStRtUKgmbXGOZrd5qRykxVG4igpmS3Ogh0NHzsnnFElPfUj5XWDJ1P98DmChbrw==@kvack.org
X-Gm-Message-State: AFq9FYJybgfD4aYFlZDf54oSaBAr+Cy8I3ib26v7FPfk6A5sEOOk1Nri
	pSXInOsE9QThj44rVJ5s0cnDrnyo8whju/Ore4f6pr3shDKCCIXA8ADgVv0g1jY7XoqMbygb5tQ
	yd3S1C16ateo76eRo0n/PRAR5/pDL7bw=
X-Gm-Gg: AYBFou1z9JNo7/TO12THuC+U5sE5QVEsNaQORJSyuAE+YVPzTWYGDEx89nQm21L4tDY
	n4qT3bn96aYGleHLsFMRhyMEFqH+ah3m5jV75t5tecRo9jKjvflz2fRiaVhgDVGc62dTTmHY0vE
	p5H2qGqgQWfGxD7euutsCryC0zZjQvJCDA7Yrs9/NPAH3jf89orvwYYfuQCiqoHhsFiW0Np5zSz
	bE+W7TqfrIbALH7upxVjx/2qWz8OHMJKqoVyaJldR0LXzJFHY368+iO8mBKIrWlGdNCX36VeBtd
	4LaD3wVp2FDtnDm5Aga/4EwNYUsCcKlVKuTwx+I67+8wo6cmG3/zhB5xrxmsYRtMXmEIRc5RHo2
	ZZZNVXFMmqlzYihJpvBssSmOhY0j8UcAcgSYSMEwLp/tmn16WCP1ga5Z46vysIm2lwC3W96Rahe
	9IuA0ZRUnIJMgeOISSupdihvmbLAvotEDDPaSn8wzK9qRSHCOgsBm9rWBYphjQ8uuYpDImJYwGb
	Q==
X-Received: by 2002:a05:6000:1842:b0:48d:f02e:f7cc with SMTP id
 ffacd0b85a97d-48e5d599647mr7878806f8f.24.1793207684168; Wed, 28 Oct 2026
 10:14:44 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org> <20261028-fixes_shmem-v3-13-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-13-4ce3baf2db4b@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 28 Oct 2026 10:14:32 -0700
X-Gm-Features: AclHuK8uGLMeF-yLDH-Azm2VUTE0jqvp7VNoB49he4XaLFESCOLaEk0KKrGGynE
Message-ID: <CAKEwX=OPADynOVEwpn3cui4U2GsP5T9phZQMaJo5xF==Nq_Tow@mail.gmail.com>
Subject: Re: [PATCH v3 13/15] mm/shmem: fix truncate loop after boundary
 swapin failure
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gregory Price <gourry@gourry.net>, 
	Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Stevens <stevensd@chromium.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06B7A4000D
X-Stat-Signature: fraj8okksgixze8sh914xq9pqi74dmze
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793207685-635169
X-HE-Meta: U2FsdGVkX1+Kf04wDmhwKGFaeQ+NMFchCu+vLppsPYLN5TYFBAgbnFoevDAPspUGaIhYBJUBGUbV3mEj5ZjInGuxJZb5nedopAlJYctflG8Uuqhgg3owJnTvjvfQ1CHmh6FlRFf0LmbLzvyg1vnqSQts7WrasLd6XVqdR+gAK7p9GdWFW3jkx7ZwiF/U/3L3UHMTk+Oz9tMGsPvYSrXHWRs/gEsL8gA8GHnNqiCpDthLU6FiT9JOjQx+fnty8XN7+5+ZKx4wa9O7cjlvICzMH9UrymYfxijO8IqcE12Zq5TexEPndkUL/tGDakBq0VQYeksPikKxwmAl1pNA48vBgElJcrTpa6gTGTXaBPWJUanSXodcv0vmErtveNBeF1qLIGd1kpJaNZFJco3oW5kQX24gNwoGiRAyV7G4acH7UObZnRJm/IpoH9NR7ddH0aAqmSNP+HaK3/rXOwpoA1IGhyIGOQdCx1nltb/eTKYDq4fxuYmgjmS5Z4j6I/CZ6spJb2kgCrWZil0OnVaK0UcVbY5yH78D2kLGRrsz6SOLNMBSvdRDrA+AhODKMcdGx9sJDW5mNnW4+ju+vIwyfowqPdi4QTdgUb7JbBNGwDTAEKJqUMUA0fA5swtl8KMPJPyQ4uc76nnUbakBSVM6FnKgiKJru13MXmyj/aPsQP69t6d4/C7bvmAJRN5J2qOMMHeXBkRcLPUjq54YZA6m6c/MoO7hGFCMFXsv1M1f9cvbjU2E9W1Nrr6Ld5IWWyVM79k6Q+enrOc+gEwFD72gtpz2JsbmkPv5NY7yS+vhJs3b2oOLVulrtQFOmy20H08yhHEb7ErgaPKcIaL8PKabctRd/cJdWnWM6K3LKcojwxohjDKtGaJNnEEoXFL6VebQrcexsguuzPohzw/4goYUUKDonCvVaBggK5pspCEb1N9LBSz+KdG6G0gqRl7zIcM1mBpTisNrHLLbICkVGTItXz4
 JRmJ5BOF
 J99KlWmcvqy/HJcLnCXF7TYF2BCxNuOWRlnHn/a2JVPhhr4zsK2zK6O268Tw3NIN10wk6nsgQSptzJvRlNlJ3JnBBWbDkXUHgZsbMsVYjs45zJf4zIPT7cjLtAvvxc1sJHMaLu5yLOKu7kZodZ3T4x5bIzYmPEd2/z0hoAnIlSAEsxNECXG+/Ah1RmgwP8BHSp7B/JmMIDOZupmrFy7pWq92megMO8IdZ6HzDHdKECuOAojA/ZRvwf/O1OvepAYoI1PRxwzkDlc1rvhUQGtvMEp3LY2TotbuxI3ZUCquZRjN2DDh5zCtjPHyx986c1A57HhmB0LGjo/rNniIK9vm9TZiLkFvrVlAQqkH7jK3kJ+qiHu/EHlmWUk8AEHbDDXAgraxY82LzyEFOx1WwLdT7mgXkK+1dVgCYtVSLDUsJ+n3cKLtOLBueHJydwkv1fFg/y1fEyWBm7XFYwrDnRicUhM4U78jCUYElRsS1cSxt7ArXl2eNHWGQL9NW4uD2VRDsmF5hkX9b7KzbxzK5Yv3W66Jo0x3xpabxDRpckDELJ1K0Ker73D3ncF/FRMfhbFyxiZ7MakvUmZNRLi6Xe8Iec6Dr+2iMFAhCf3PU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 2:57=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> If swapping in a large entry at the new EOF fails, shmem_undo_range()
> leaves the entry in place. Its final scan skips the entry, then restarts
> from the same start index and finds it again. Truncation can loop forever
> while holding i_rwsem.
>
> Advance start past the skipped entry so that a restarted scan can finish,
> as we already do for folios that cannot be split.
>
> Note that this does not fix the missing zeroing when boundary swapin fail=
s,
> it merely prevents the endless loop.
>
> Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry=
 split")
> Cc: stable@vger.kernel.org
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

