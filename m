Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34176C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 05:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66726B00A2; Sun,  5 Jul 2026 01:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C168C6B00A4; Sun,  5 Jul 2026 01:40:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05D06B00A5; Sun,  5 Jul 2026 01:40:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757C26B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:40:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA39F120629
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 05:40:50 +0000 (UTC)
X-FDA: 84953623860.14.4CE0AB9
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id C0D7620003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 05:40:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tw1cHCuE;
	spf=pass (imf13.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783230048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nisFkIOWw8wG1u4MQ01sl1TtxhOm6wKesEiWXh9ta2U=;
	b=qknIjil7Y5Tr7WbzANf41uXgKQWUN0XeMu3tuf72LqdiOinpj/W4dPEF8PPwGksHtQDUqA
	TJ7n6HGYHahwpaQiNzvAE96DdSDffSfFPrTt/GdftGsNo2JweexUhnSyfoQf/Py4RRcrMc
	UOhq+2qmhgbomBMKl5pE2/6UwTcrB2E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783230048;
	b=g1PFx75ycSYwsArnVTCjHG5lMMdMZNGvMpoh6k45UAB+hrL4nwMPt/N/tUaC70HIKSctDI
	XHye2iq7OjYXDK5fx+iNHa15eY2pA8ldNPv0o1ov6mOUFH+X9ASSQ0uKVrCeDer/SqM39C
	+/o5bco9KC3W+sF0clZyt4mro1cymn8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tw1cHCuE;
	spf=pass (imf13.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so46188e87.1
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 22:40:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783230047; cv=none;
        d=google.com; s=arc-20260327;
        b=XhCxAdeAaUuPUM2Z+bAy4f26HE0xGjT2Oy1li4qcaquXnEmnL52EjgyRGLGsLCSS47
         IsQS7dwHj0e+w3s99lZbqqElfN3zQeqIvvVST5Lqki/LyhkEJqVj4sc/FDbZgBtncJ5G
         mhG9u6QLajSMdUOjeUPWu3wFgrS4tG69vSqf3QqtnqqPJ6Jk0aAzg73a8oL/f1eSaVNt
         X688hFq7ngJ+I4O6msMkE1DSf3bXd3suMguJGVgs6aest8mCv+h9pVDVIphe90/1pIOZ
         7YTiwlaV15p/XFIOVJh52QGnARIxG/hJ6/Pei8NaTow0Ndm8lLqUYKIU/ZfDn9JtVNZG
         Gqmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nisFkIOWw8wG1u4MQ01sl1TtxhOm6wKesEiWXh9ta2U=;
        fh=VLTXg0ghRlvJ95gKkoS4G4FYyK9UYJEPNFoWbtF+ZHg=;
        b=Y1n3qPA07IrO147VWOhUuBc72dTu4SsBhSNRY6FY+ui1C7hLPIe3Jub2qo1nfoTHl+
         m+7E5B39PuSQMue0nF8XdMEqpJ9SBsaKNpcJ9PLEaPloEfq0aLH6CchEk/ao6xewDtP7
         3FaQKA1nT0FZJziJD1iq005UiQYXLPzvN0OaYal0o4lZieevT8CWaQY5XSWpZoq3R7Qn
         xkrweXAFH1L7myz7O9JtoIkUxXCFFH+s1eU8vyUDP2nTh70yM22iKcnwsB//3ATqnhhH
         UR2ZbFztonYqKruV8VTKeqLkRJCl/WtHg9MPwNN49x0HxHPifAOVrjqIwrvSsgVN4Mam
         ESWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783230047; x=1783834847; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nisFkIOWw8wG1u4MQ01sl1TtxhOm6wKesEiWXh9ta2U=;
        b=Tw1cHCuEn7FDPCjlCE1cz2lSmICoWt8hlBA3gfQvjWt2lLhPjcNOW/fHADkFWpUmYa
         wJvJ6kiH4zdx+uRhNMoiEJOBbZyWL+pxgYyadkD60l6SPBUWXgplZHDJQ8kzTkzFpzhy
         Z6m59wFHwHHZCk6Y51d8XuN9Eca+6GiktD1eZzSOKOt5KVFTxAAufdVOcZxABiMubnH/
         wyKrNdDMrAo4qL5uBo8Q9qqys1EJUPLbEKn/wd8HCh2VEJ2ClcaFX2/oWiEMSC3e+J+E
         qais08bpdzXlz0sU7xHlFuqwk0eQeav8KX0/cHJ2nIarT7trdismjFWv/LvHUnZkrEz+
         q06w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783230047; x=1783834847;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nisFkIOWw8wG1u4MQ01sl1TtxhOm6wKesEiWXh9ta2U=;
        b=jlXDD2WT1CD61pl+rI0bk75oOgy71YkyM9x+09vNvL0rG1zqzCiit6BTUQYvaJWmRV
         ior2jXTFamh9AghhScb0qMSqHPL7tmP5Sk4c81uJYTtUCsLyWvElpd7KlXdlao2F0PgS
         vezSVQxA8oOjSgYa6Wq8odbqqRR6h0Xrs/fca6in7P3uE2coBpQOdhYt/orStSoJT+aa
         xgoguArOJgLlc/aRdUDIamQtqLKEa6cTgowJQX6fmmqg6o0HMTvclwBhl/v2qidN1h4G
         kERFWIYeTX5eWfbIcIvoOPjw858Bwx/IjJK/Rz95d52bSfcIX0qCfEXYAM9fZCvylRhZ
         8JKw==
X-Forwarded-Encrypted: i=1; AHgh+Rpvf0OzDYpQ3Xf6NO5zAEVZ0N0ed50q5Sezzl0TjllxK3TC0AGOlY4e9jp97BP4zdx0MQ/SW1lnWA==@kvack.org
X-Gm-Message-State: AOJu0YzEzTKmlG8KOstpXdjdoCNTVA8G8O6JvjGJEztlnbxK+XUIuqcv
	TZ1KLcPLgBnVFxYCpvAoB/ZlUAAc8Nb6+wRUvY6BSrNzpT5sLngWpPAYqihk/h6pLHRdUClriSi
	vD/7kcubW7Za660xD2ZACXbReRLX7oleaouJZ30sl
X-Gm-Gg: AfdE7cndNYeZdGSxzlIGxyAabt0oSovpBa4BPOyNe/vYpYVFUTuZmA/6XAS/OvpHUwS
	/gEcecgLBob/Nei/GxkXYuCVPB6o+CDBUI6KGs5vg4FYWGdbXuX78LtP1Z8GmrscV2AG0iPxA7r
	N/gKb/HvFXYvWMwjZ05bgTYV8bGJaowEBSnyLsyPIFc/+fNpY6pZQ4OQedzwkz/qzQNRLQzEKUn
	hljuSSoVXIELDREv4kOO3/38+vCCLtFQ1a3MywmrgeABTrzKKfd9J378HiT5fNdyVH+VKf+gykk
	FZxZBWJ/FUaxljprz3pZxqu81fopw0oo+CMn1xU7Esb+/Z7akU6g9r5+BHkW4g==
X-Received: by 2002:a05:6512:3f06:b0:5ae:b726:5f1f with SMTP id
 2adb3069b0e04-5aed45efe29mr58601e87.8.1783230046726; Sat, 04 Jul 2026
 22:40:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260704174930.2885785-1-souravpanda@google.com> <20260704174953.002ee4990c62cec6bbfe4391@linux-foundation.org>
In-Reply-To: <20260704174953.002ee4990c62cec6bbfe4391@linux-foundation.org>
From: Sourav Panda <souravpanda@google.com>
Date: Sat, 4 Jul 2026 22:40:35 -0700
X-Gm-Features: AVVi8Cc8VCOFqHMacKXJi6c0zmURsw5honuJBFah7xlNvGSyvyeCg7MEIxLVgkI
Message-ID: <CANruzcQp8V-izMuR6isNrZ0WE+g6U3LTQ2kkt7z6AGXiUsfhAg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb: Fix null nodemask in alloc_fresh_hugetlb_folio
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0D7620003
X-Stat-Signature: 16rfxkxbz5tw3dtp3fdbduwky8c33bog
X-HE-Tag: 1783230048-398907
X-HE-Meta: U2FsdGVkX1/E0h7wK6BJ3WhCDf3O+xzxg4d8yHAAiP5tQ1c06RcClk9XVZj98aI00rw8jQuO1Rdhhejyiw8DL5GNiq76cInBKVn257OguOaJjofolK75CpCbLmRdLV7ryj87Ur9f9KeWuulPjiCtCVSf1D2EvcTn/+e+wekXPAvHweNCpstQKYJLlTJB1ofXSGNsJ6BDgotZQQufIU3qCJhxZMKp6UUsTh8s9ly1oDtpuV2Iqjghl/TWuD0Zy5nY8tEC4Qub7j5Ts7u8HRnS6XScRKjTbRoI1+c8Wet3Qz3oodhySJVxkfqYUbmNr9RHjw0G3MHdDDIr0PsHrEXu0ljzvMNSG6uuHigYiry+8oOLjGELB9CHw6tkYVdxwR6/04IY8EOCRjhB5BEu7DOfuDFCPE5m5DnYlbNkjVkS25jhm0tde2NTiXFAPUnrLVmvhUZciQNNWNWvrCkvNhQduvgDipmmMRFtctOHIxOMDIGa8LVQd90iadKl2kGA3CFK1yEPa0DPdaGO39dX02YMMcwW07PO+j1/CNkaSmQVbIFvWEwR+92F/d+8HwZIXp864EX3NOQAIDWBBE9R7Xve9AuPvOxZzrGTKO2I8RHIr7cY/b8HIVssE9v67+dW4m+j1LVF9Ht+u2UudaMjfFZnkOtMoKF06RvIB+er7rP8ZH1ElrbaqopfbOXenlwJZ0TDp5tUyEAkLjK8olZaC7xCFBcZGD10PNIdH+0OFI4yRO+Oh2Ym19vbbPeTvW9luqNUG0gn4A4s2tus5LFSfrZZyphCwgiWRS6W9YzE4GhHnGP4cgo8ycJh2l/GXvHONAzjlKkScO2nhSSquv+Mdzz3uXAqHY+QbHiSP1HwYo7HxiYSiuCgnadPWuJLREH+pqq0kwsUJzGU1WeD0zwO9KvyF/6OBgZ6+Wh8TWo/jErDIDXXU03aRBifrT8jQJuNYk+Cqt+5VL39tDbr1m506i1
 YkLgFAHM
 XuTIq7qBgEMl2cRnV3FOUNMQ8irIF7DZ3V8aTNSZ0akMEcLVQRxIXHaawAc7A0gI1UAYdkDhloWUyD5bOzmCHR5Qk93LOVDnXF4Zb3DXihXXFCXVDRg/RhK0zcaUeoVhxR234Vbp82RUHyCzsxfPh04+yj+5WlqEH+D+VaPDIsKlon3niMCgjSmwZ2Mj7OeD0bUWz1ixZBDr3NjwV26qSVBN6DOOmYsDL5taFIRo/+JPf3cTiqy/PNs0CpmV3Y0IJE3+GRq9C6U41leXdUqgtMjHcI8B7fGueJ4HdR/VlL8kAp6J3iN9a2yGdrku1jiXt0Had1KyHITrLlTUOhJeviQKCxRQLoM+EMz819otSe204hBu+st266b/mv0BmqxfpWhVwXbzwlXDNZzlCp7s63qyO8OcTKPIqUEHBNYZ+pdmbyvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 5:49=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Sat,  4 Jul 2026 17:49:30 +0000 Sourav Panda <souravpanda@google.com> =
wrote:
>
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which blindl=
y
> > dereferences it in for_each_node_mask(), leading to a null pointer
> > dereference.
> >
> > Similarly, if the CMA allocation fails, the fallback
> > alloc_contig_frozen_pages() is also called with a NULL nodemask,
> > which may cause issues.
> >
> > Fix this by explicitly checking if nodemask is NULL in
> > alloc_fresh_hugetlb_folio() and defaulting to
> > cpuset_current_mems_allowed. This ensures that both the CMA and
> > contiguous allocators receive a valid nodemask.
> >
> > Additionally, this patch adds a missing node_isset(nid, *nodemask) chec=
k
> > in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocati=
on
> > attempt respects the memory policy.
>
> Thanks, bu the changelog still doesn't explain the userspace visible
> effects of the bug :(  Important when proposing a cc:stable bugfix.
>
> So can you please condense and include the info you sent in reply to
> my v1 question?
>

Absolutely! Thanks for shepherding it :)

I will send v3 addressing this and Sashiko's latest concern.

>
> Also, Sashiko is saying stuff, as usual:
>         https://sashiko.dev/#/patchset/20260704174930.2885785-1-souravpan=
da@google.com

Sashiko's concurrency concern is valid and can be handled with the
  read_mems_allowed_begin() ... read_mems_allowed_retry() seq loop pattern.

I will send v3 with the following changes:

+ nodemask_t local_node_mask;
+
+ if (!nmask) {
+ unsigned int cpuset_mems_cookie;
+
+ do {
+ cpuset_mems_cookie =3D read_mems_allowed_begin();
+ local_node_mask =3D cpuset_current_mems_allowed;
+ } while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+ nmask =3D &local_node_mask;
+ }

