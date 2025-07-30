Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E145BC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 16:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423FE6B0088; Wed, 30 Jul 2025 12:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC636B0089; Wed, 30 Jul 2025 12:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312A16B0092; Wed, 30 Jul 2025 12:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 210996B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 12:11:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6E0A1603D6
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:11:40 +0000 (UTC)
X-FDA: 83721421560.15.93E189E
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id C13B7180009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:11:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=pNEwcYUi;
	spf=pass (imf24.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.43 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753891899; a=rsa-sha256;
	cv=none;
	b=ixmSArQiB1+ZLPEzDBvif/ahrmIGxo4Cz4WPHXbC4BtMB0W0+j5FNhfVxiUCPreCUq7i76
	BWYAY6qi20r3FY6dm9MPnZf98ueXlMRUF0S06ywwkGbCPQneWw71MkrTI5+U1AahzzH3+z
	UPZBFcejdteQii9f+gIQjmNLIhVyc3Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=pNEwcYUi;
	spf=pass (imf24.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.43 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753891899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2b79vf5ak+e/xCZeuA0BNxm0tT114JbbliY/uAS1iI=;
	b=Syob1/i2d1bVc0EAU62A6G/E1mH9stI5P/oqY+8ZrLA8aHvA9d5VOJV7Ly9Y0ap8FooBIE
	aQ1VE19X7Gac1EUdUUG6B9tDTm5dfMYk7yTBWRoR54faY5ODuIhk7y37Nuyv5NwQsC1IKD
	TFdRsZ/c6gM9bA0FmxvCcnBTOu8R9Dc=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-615398dc162so6105439a12.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kowalczyk-ws.20230601.gappssmtp.com; s=20230601; t=1753891897; x=1754496697; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2b79vf5ak+e/xCZeuA0BNxm0tT114JbbliY/uAS1iI=;
        b=pNEwcYUi2fNZoW78xxWArvoNGER7JeZy8dMea6U9UxQrL1WF8N4XKH3qrev4Em4Dow
         5/+w97il3Tt0nlY0Pb3B3gDuAHKA45lR1gQ/g3njAPNIcKRQyGn0GP1JWC+GCdN2fZyk
         LpXk1Ca4qfhKCOVjFcWIKQo0ZlBd9ZFC7o3YsNw+iN0LjDyTxsuJJtInKCZiJPIvpliy
         3aYVLDtxrV6PH7SLGXEmiy5JQoMx7hD/vhBu4SJi8ZUaU+eIu3RSY9s/AbRyvl+2v9Hy
         75GfLQ2UJuOiAt11e8tpTjPzR8Gx1pW5fEY58RNgTmGXmSmxpXdYTn9jvfvNQ4ufN3JB
         Derw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753891897; x=1754496697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i2b79vf5ak+e/xCZeuA0BNxm0tT114JbbliY/uAS1iI=;
        b=bPW6zjFPztKrSV5+7lU0j6uHyJRQD/GYInOnoFd9uMi/44L3kp1Ngli/a81stiGEKL
         YESrqQAEulZnD8xIQw63tJMz02X/gHcZkNxqmCEPImMpmHAadGVrB3Wf4odxgx78884H
         lxAkx11rBLbs1m9GVywRX6ptEqyMC+BiwHMgG5zKM4cXifDpM6vUhXXPiWfzsVxEgrwN
         hhysA4fBw0h0dFn9UgyONDvETZONzEtXZwnq4wH8zgtb9utz4uiwKpJDL1qvN29zbIfM
         DmXgIpIJQM7FfKxsLuATHB0hOKtFzuo8S3+hXsUmGQq56Jxkz6Xe7eTQsZtDnnsgtgQ2
         yhtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyXM29GnLA5yvQ/RlG17nV2JT4g7gPKWRx7YIBlAxskEJHTiBF5Bjt0SzKAsJloAIAc2iVaHSsKw==@kvack.org
X-Gm-Message-State: AOJu0YxXrDWiLL0kZz1ujU/jM8urjo+Er2QjEA6wTcaoa4CdlcZ3mj1i
	LXSNPR55TQFpizmzXOtN5oEifmshKamixMOg9EtM+WmsBlwuJ77fsEBxmprE1vUaB4CTDbfPqnY
	wGxFz0ozjnUJbT5f9xJDwZanmTDTczf84fR1qQPZz
X-Gm-Gg: ASbGnct1lD3Eb4kWV3yZGd60UKvHO3qciTcUNlhxoxO9900nZ6Za1lFjOqRz2XI8VTG
	et7LkXpjDaX0UJKc3QWkrqtSwdDjJwHfmrYGPWZdX9rb+/NUqR3/jiswpRCA+gFD1UihYRgsZfS
	JxhGwbxMEGGmPjfWogSHSEvvUEDQZUyI108ZCifHUXNtbsp/PbYuQlWEPS83rOiUye3amOtB1ZQ
	Qiv
X-Google-Smtp-Source: AGHT+IF0RbHZTmyeGEceTHCSVk3sXAK7Fvg37ayxPFDsP6BZA0CVmeBroxYKzVp8m2JfRHhouMt2MBxOgQuv6Q7rqjU=
X-Received: by 2002:a05:6402:2553:b0:615:8f13:6324 with SMTP id
 4fb4d7f45d1cf-6158f1367d8mr2751996a12.1.1753891896854; Wed, 30 Jul 2025
 09:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
 <ff93c415-7ce8-a331-9568-7543c6a37992@google.com> <817c59dd-ad54-47f1-ac16-9cb9583308d1@linux.alibaba.com>
In-Reply-To: <817c59dd-ad54-47f1-ac16-9cb9583308d1@linux.alibaba.com>
From: Patryk Kowalczyk <patryk@kowalczyk.ws>
Date: Wed, 30 Jul 2025 18:11:25 +0200
X-Gm-Features: Ac12FXy5SspHtr8bWKbmfyjbAMrdH8laeeJCxAogBGa40D3TbRxRNcwy2_YhjZ8
Message-ID: <CAJCW39LLyJjOyMNreiVd+SjS3dKSXwvT6kVz-sf8y9YpsU1dTg@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, akpm@linux-foundation.org, 
	ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, 
	airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com, 
	joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, tursulin@ursulin.net, 
	christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com, 
	matthew.brost@intel.com, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C13B7180009
X-Stat-Signature: 954dgeod1fp45n69g7cogjht6k1asup5
X-HE-Tag: 1753891898-84638
X-HE-Meta: U2FsdGVkX1/VlBPw8DeMnMjms9eXibCRwVVQog9VCZNX/5bJRLhGVKPXFZEUHBVVwANuPb2E3iwKwXOKKB89SVBvVibdH6bmgNa5omCw+2X08fDjDPKFYAUiaSFaQjF+hDNEWN7G8FObD3A/9Wa+oU9G30AY4YZ20FrsGlIXidTcbwGZ6F0tuCMe5VKkw5AWQgKHFSHc4ocyF98E6VukasxUKPmyY23rClQQIjxlCZyCBGO5yUxc3s9e9IxzvQGihfsIg/SKJ63XyPW3UnQHRpBc0pFJhmoCPLiWQ3ru9loN3LDmE+5+bu25dQW+n4QI3TK5iScqr3KvJYyXHvKxgyCbiGcNuFLpqk3NHzxI4PApwqbJ9b8dB61XMUhUqpoXXdEyXllHLKWddgsjX7rrLQRMPRgHYpsQMaBJE1CBadKPBTfwNRGuSCINN5nNdPKgq/YUKiauPJ5+hX4gOihTc8FVUJpsCl9RX01iIh+akwn2SbVIzipVFMHmXERx0sxFN8rwBLZveYScejsROSPkUb2OBzbhvBnP/YT0OZ1cm0imYyWGc8PnIeuJ0+knp/OcEHxlVflb3GbbB/SbjSSEH010y18A5NKjUSkMeaQ5WZqa1V0QQsh5czUeW3h4oGp8KOR4JFnxC2a4YUNitBDlD3/T5rwlSk8cTfgetMmeSi9oIN/hpPbNkGr2+A7Nf3uYEzWAtzIYU/riTuX/q809ML3+RIoryFHuEKwc9yXjd94BT1/Sbz1IYA94keUooWwCOm02osvkRMC78QUW5UVvUTxNekQywqL8CqdxiPadgkXJMppRovVfUzYWdv3IKupZ6OIj7FJlB3MHkeKx2sovjJYqzcpYJbHTOabLzcrnZKGV9+CNuFepm0tTIlR+Y4kWNGawm7mI01Dhf/CUcP9qCqIq8ixVXKMG9zFBF6byR8UCqZdUp+yuT9cSru0hBRJdIlNw/Vb/lQi17Fgq/fG
 /bOWeeuX
 4CwCa+awo9lPRwZBz64YeKbCbROloG0zCa8QJVi5wcxJscH+JWLBR/kOxyMfZKh1xYCQxhdkKU8KEMEVEYTH+CxT/JkS+CIFf5M5sg9rDwsVyYCxvwfyVfjjuNGx9QmmVd7bvQqC4jPtMNSiXV7WdzSlrJmOd3wuh/WBqhoM9ljm77VMaNRg0zlqVBqiCUead6MjNSa7nzK5APbB7sEe1foDjtPPQexYpPTMvfzZWsxgECKqGi02Jrw8R717qWnj6y0LiFzGC0OiXygrb3/cd8hXNVeU69J/0jkZhHJL06EufxLlFqyJu6fMRx9/H8AdRj2/JxuLfsBqbOc2NWFpYTHK07IQyUMVccGVyZt8YwN1Gd7ZVrWyZQDeCm6amPQoC3b9b22nbpqrIu32TmkbJtX+pfGo9qa9x8FZb/jMEVKGL+87H6NYySAD9K+8WIN5I8mgp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
This patch solves the performance issue very well.
best regards,
Patryk

=C5=9Br., 30 lip 2025 o 09:46 Baolin Wang <baolin.wang@linux.alibaba.com> n=
apisa=C5=82(a):
>
>
>
> On 2025/7/30 14:54, Hugh Dickins wrote:
> > On Mon, 28 Jul 2025, Baolin Wang wrote:
> >
> >> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmp=
fs"),
> >> we extend the 'huge=3D' option to allow any sized large folios for tmp=
fs,
> >> which means tmpfs will allow getting a highest order hint based on the=
 size
> >> of write() and fallocate() paths, and then will try each allowable lar=
ge order.
> >>
> >> However, when the i915 driver allocates shmem memory, it doesn't provi=
de hint
> >> information about the size of the large folio to be allocated, resulti=
ng in
> >> the inability to allocate PMD-sized shmem, which in turn affects GPU p=
erformance.
> >>
> >> To fix this issue, add the 'end' information for shmem_read_folio_gfp(=
)  to help
> >> allocate PMD-sized large folios. Additionally, use the maximum allocat=
ion chunk
> >> (via mapping_max_folio_size()) to determine the size of the large foli=
os to
> >> allocate in the i915 driver.
> >>
> >> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> >> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> >> Reported-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> >> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> ---
> >>   drivers/gpu/drm/drm_gem.c                 | 2 +-
> >>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 7 ++++++-
> >>   drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
> >>   include/linux/shmem_fs.h                  | 4 ++--
> >>   mm/shmem.c                                | 7 ++++---
> >>   5 files changed, 14 insertions(+), 8 deletions(-)
> >
> > I know I said "I shall not object to a temporary workaround to suit the
> > i915 driver", but really, I have to question this patch.  Why should an=
y
> > change be required at the drivers/gpu/drm end?
> >
> > And in drivers/gpu/drm/{i915,v3d} I find they are using huge=3Dwithin_s=
ize:
> > I had been complaining about the userspace regression in huge=3Dalways,
> > and thought it had been changed to behave like huge=3Dwithin_size,
> > but apparently huge=3Dwithin_size has itself regressed too.
>
> I'm preparing a RFC patch to discuss this.
>
> > Please explain why the below is not a better patch for i915 and v3d
> > (but still a temporary workaround, because the root of the within_size
> > regression must lie deeper, in the handling of write_end versus i_size)=
.
>
> OK. This looks good to me. Patryk, could you try Hugh's simple patch?
> Thanks.
>
> > ---
> >   mm/shmem.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3a5a65b1f41a..c67dfc17a819 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -5928,8 +5928,8 @@ struct folio *shmem_read_folio_gfp(struct address=
_space *mapping,
> >       struct folio *folio;
> >       int error;
> >
> > -     error =3D shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
> > -                                 gfp, NULL, NULL);
> > +     error =3D shmem_get_folio_gfp(inode, index, i_size_read(inode),
> > +                                 &folio, SGP_CACHE, gfp, NULL, NULL);
> >       if (error)
> >               return ERR_PTR(error);
> >
>

