Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E663CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 06:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E70C6B0088; Wed, 30 Jul 2025 02:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370756B0089; Wed, 30 Jul 2025 02:55:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2382E6B008A; Wed, 30 Jul 2025 02:55:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F53A6B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:55:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99DC7133C78
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:55:00 +0000 (UTC)
X-FDA: 83720018760.22.7F7A25B
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id CDE7F20006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:54:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vHE51Hiy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753858498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xb9lxccqqzV/HuE6IBjo5UmOhzvTQ7eGMAvIhyfuiTI=;
	b=KMlwZEn0Osmp4Tv+xOZ7sEPLDCYLGIEmILmI5xhkfrdCVKRP5eR6qoeDKRkOrcEqjT7Wir
	cci6htjz+jsrusQWPFnD8v6vL3WUGLYZaW0XenUd7kjEQ2cNpFBLGz5FaFfZhH8w3VdiVw
	G6Vbr8p3bgi3h49m52azZMlWh7yHKUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753858498; a=rsa-sha256;
	cv=none;
	b=W+T2ZMgJ03X452bkTyCPLoaemMvzLdvlp2Lz3sIjzVuZnheGvOaHn0FjF1vP6KE1ZohWoV
	49ZktEMOUMUDPac/WAXmFHMwlb8Yjn/AAqHapwrruh1RJYrNzTUztztPSm1LDkMXXzVjHB
	AENQ9fbytTGyH6Lta9SLYqfJ6rLj5AE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vHE51Hiy;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of hughd@google.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e8986a25cbfso4420239276.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 23:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753858498; x=1754463298; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xb9lxccqqzV/HuE6IBjo5UmOhzvTQ7eGMAvIhyfuiTI=;
        b=vHE51HiyAmkZoI6Fx1NfKANn0gsclUbcHvRvFDHeM2/ORMLyfF1ObrQ7Pp5Y5yO55Y
         vZ29x650zp8mGlFtKlRV+2ER1f8hzUU1R+sTwPN8WwWwwF7QVSVW6Z1H6IKUHgU+jI5X
         ouNnDXN4jv8zWi25frsyl+xOG1HY3ztQTbjiWGhTN58ttTH1i1hbr6v/DOjU2l+CB31o
         5WDAjsbesF2dRIhCT7HBJQeiABG7dfRdeZuE6zhSWIXx144uDzfk0CASd8cpgwN7Dmam
         TVXVuak5NXHkXBAH2MkzlvAsbXIMV3bEzMr8GBurPfMmQRJ0hoRXGxiTCQa6rFrfwhtL
         UXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753858498; x=1754463298;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xb9lxccqqzV/HuE6IBjo5UmOhzvTQ7eGMAvIhyfuiTI=;
        b=HaZRWPAw27T13IZPTE644QLGs2/ZHfk6ivPJ4BTxf2SS/Vs8VphdUT/73QRk5hIdgP
         bNh8VOnTM33747/ysnPYKHlp37WYpmp1TbLtflGu3gAcYjPscL/EHrr/ta+W1+QV0/YN
         6guZjQTPz4fj+McUGEUJkOxFxSLSCevUgjeQt353k11UDUKzokXdKStIre2XVSMQTt7F
         d/YhfJnTDZyDgZl96uWqi9hizstcq5f73T47sq+IAm4strAvVk+3seHQGWNJWrusfD3p
         GhJQ7tpHtbaCTMGFq/BnTSoT0qGBqhIH53U7DvjzQkpDc03Ir7pZfqzLkr1iMQHTW0FG
         IHKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZsIg5JnQ3Y4axedKfYNp/Ozq80CWow8OkiKy9hfWBGdnG8jBFKLjZMOllEUD8AGKML2v4+vbxbg==@kvack.org
X-Gm-Message-State: AOJu0Yx8Vlt4tcvTEV3eNjidLDYkOmwgG2OzaY+WKdiGoTMHnIt0Jiy4
	yk1sWM5Bi5uLuPM8KytHYSjXbSGLyLA1WiN0Os7M948RXl2bEhd08SB4wzqgdGWvVQ==
X-Gm-Gg: ASbGncsIn19gpmU7pi9Pqp42pD+iLwEPxXEIu2CJSuLr3xqp5WSLXlKcdGZpskWcmGk
	F0krNQ9iRsr2CaCLTpgOToROyoQnbOx6m+xYj1TOK3V6kmXb4DnZpViFQRr9xkdrkoiN5qLjpnK
	NuuHIM+7TQJ7enOysUOQjlj/4NL/mpJLy9uqeZ1H0asg+Bws6DjKO+x1ieEi6aS3Tdpesv82hOi
	Lcixv2cP/jNdYKGe4Tb7afeoTdkARFh5Js6O3ukB9hqm7xz7tFPFh+0RhoofFP8nKp4ABuEoPzo
	NUPbQ/xLmUK7B/L1UhviZiOK8pOdVNk2yYCGtEYVEqu9K8cy8Cirii4lXDMeNUSHQMFFv/tFIiE
	Cc6R2UX+Vuq/crjwOFKdb0zmNjA0DCpwJ8mEHJAUQaqFkO/9ao3YqVMn6WszNgQc5RfF2if6yCf
	iq/u9SKx4=
X-Google-Smtp-Source: AGHT+IFRrK4i6oO1zKk7GnmCX4K+vLePl7LTsNrBKA6nlwjLECThBMqUufa7+jqHJdcW9Ic1/5Dy+A==
X-Received: by 2002:a05:6902:921:b0:e8d:7451:d738 with SMTP id 3f1490d57ef6-e8e315bfb59mr2626997276.35.1753858497592;
        Tue, 29 Jul 2025 23:54:57 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8e3f3a46b3sm504319276.27.2025.07.29.23.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 23:54:55 -0700 (PDT)
Date: Tue, 29 Jul 2025 23:54:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
cc: akpm@linux-foundation.org, hughd@google.com, patryk@kowalczyk.ws, 
    ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org, 
    maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, 
    airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com, 
    joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, 
    tursulin@ursulin.net, christian.koenig@amd.com, ray.huang@amd.com, 
    matthew.auld@intel.com, matthew.brost@intel.com, 
    dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
In-Reply-To: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
Message-ID: <ff93c415-7ce8-a331-9568-7543c6a37992@google.com>
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-1769646309-1753858495=:2474"
X-Rspamd-Queue-Id: CDE7F20006
X-Stat-Signature: fq9r3em5wtaw7hpgbkk47jhrrdiiatsd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753858498-566427
X-HE-Meta: U2FsdGVkX1+gPs2dJpHHRbEQzPxfJWKz2p0ELgC8k2RJBONKrn+Gu3l4Je9SfRfyQufIyIhpRCgcWtd72jjLmH1VKojz03tD4LpMvAggdlu8NgZvBoPBHe6NgKeC0F4UrS+EPB+yEpZtd8kEWdfQJxxPhEB2CactpQvbpKyi14EeA4u2cw4Ow1GpOe4wq3Y4kbJcU7Rv2hnUKSHS4RlAQM/rDTrD+mpoORhwIihL/7yINc88IagDdOuBjrj337N5v426lYvUThLrZULxnnK9VnRADguCBe5RngRYEDysmxOT5fJOrKBqooI4n955NSIbPHY+jegdM+InRwja1g46VJLFDZD3QZanv2l65d+GUvLudazGg0DTe87XZhg3Dg09z20Del3Gp3RdBhPrEDe+5o0L/Hzm0aKEwgPClHWnUPDP1dlmrh8iC+5WHCoYC8uEfjHFjNba3hm/sp/iza61YMvBa9SzwAvKNphAsj/CX1PO/yAT5+m5EIb2n2g8YMjKcr7MwvRjvz5C728IUDh2438tpah0ym5P1eQF6H0ejCEpdvM857Usqfsgq4xdQlYlmB2qjgG7G46452Y0AwON/+vqsssoB5S4uG5fLvdLnzKgYx1uXQoff91+6YnRFeMRovIMxBWbsiMBbJoUlP973z4ORYRhdXYa6IwsZGqJfsSfsb2Q4gDtsoluxbSwtKlhiZLnMKTiO5Pi00u6KApjh1P1oGCbM6x4DxT91ah047yOAL7lTFhwvk8n+iy0IKweBRA4TQoTpyypgksMmuZH61Hk4JLguaAYw3rdePH57/cvqYCqKDB3p4NNyRrsT1ANXv9vPiOAPL4FQjYhVpDqcSnNEHrZatcIFeONkS4TLODOFGWhHSnhyBmObE+Aq6zeL178spk0415HjaIlqKWbdLaeVAwohpKlFsDF18ui35Ddx+ArZMmEZwTKLl52jOjL8t5hV7RkByOlUFV8rE7
 WMldKkGr
 35knmqGpMarKNp6denW0yzsEEBINlTKTBnvrl5xgLMDdrftV+cazzSegkYfPwDrIAjgCJfaT/D7+zqLmzZOew1tCENWnhYGWmJUXDBlqYg4qyCD/PgRY03QG9dQXm22XR5fNu8qguEFGBjQ7mtIl2qn1Iii7q7JqEGUnYHJAnw7OI0jqTPSlWh1nMj6VooAj/snjfc0PJJ8LIYIJtRGrrfi/szQGdwC59EuESQ7DPVrJE3Q9SHMh/SyPexIC4fI81NMpvZYHvUrNkHxvLwZjviVL+DkvGm3Ksqcz4SXLLf4Y4orlqQ+fKCUlGBbpJixxI85Kk7LqAt3tet6EhvhiuCLvh2wg8M3cdkxGTJDbGb5WZId/6iOqqaWJjiA4GJu9uRenJSuKmGK7oricpW6Fj5g+XXDEF4HMlR9pg5h8S+1jz9e5MkShYfySkaMZPBuuoFjPMcjNyDptPF6kY+8Cf7u1BkTp9YUI5VwCqWDjpb0cr7D5Wkz5X9YPErSXL4PqtnC6sIdGNWwbEJFmDWX/m8jF8iAYyzMlJq0/R1yoQigJdTCA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-1769646309-1753858495=:2474
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 28 Jul 2025, Baolin Wang wrote:

> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"=
),
> we extend the 'huge=3D' option to allow any sized large folios for tmpfs,
> which means tmpfs will allow getting a highest order hint based on the si=
ze
> of write() and fallocate() paths, and then will try each allowable large =
order.
>=20
> However, when the i915 driver allocates shmem memory, it doesn't provide =
hint
> information about the size of the large folio to be allocated, resulting =
in
> the inability to allocate PMD-sized shmem, which in turn affects GPU perf=
ormance.
>=20
> To fix this issue, add the 'end' information for shmem_read_folio_gfp()  =
to help
> allocate PMD-sized large folios. Additionally, use the maximum allocation=
 chunk
> (via mapping_max_folio_size()) to determine the size of the large folios =
to
> allocate in the i915 driver.
>=20
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Reported-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  drivers/gpu/drm/drm_gem.c                 | 2 +-
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 7 ++++++-
>  drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>  include/linux/shmem_fs.h                  | 4 ++--
>  mm/shmem.c                                | 7 ++++---
>  5 files changed, 14 insertions(+), 8 deletions(-)

I know I said "I shall not object to a temporary workaround to suit the
i915 driver", but really, I have to question this patch.  Why should any
change be required at the drivers/gpu/drm end?

And in drivers/gpu/drm/{i915,v3d} I find they are using huge=3Dwithin_size:
I had been complaining about the userspace regression in huge=3Dalways,
and thought it had been changed to behave like huge=3Dwithin_size,
but apparently huge=3Dwithin_size has itself regressed too.

Please explain why the below is not a better patch for i915 and v3d
(but still a temporary workaround, because the root of the within_size
regression must lie deeper, in the handling of write_end versus i_size).

Hugh

---
 mm/shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3a5a65b1f41a..c67dfc17a819 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5928,8 +5928,8 @@ struct folio *shmem_read_folio_gfp(struct address_spa=
ce *mapping,
 =09struct folio *folio;
 =09int error;
=20
-=09error =3D shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
-=09=09=09=09    gfp, NULL, NULL);
+=09error =3D shmem_get_folio_gfp(inode, index, i_size_read(inode),
+=09=09=09=09    &folio, SGP_CACHE, gfp, NULL, NULL);
 =09if (error)
 =09=09return ERR_PTR(error);
=20
---1463770367-1769646309-1753858495=:2474--

