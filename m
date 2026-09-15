Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3614C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 21:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54816B0088; Tue, 15 Sep 2026 17:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DD26B008C; Tue, 15 Sep 2026 17:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B3B6B0092; Tue, 15 Sep 2026 17:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 728606B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:09:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE14B1604FE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:09:31 +0000 (UTC)
X-FDA: 85217237742.04.6865081
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2F1780007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:09:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qAKK2cKO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789506570;
	b=NWEUs0+rePHTz0bTcq/ub2+o6k2WgYrjmAKPtOmdUOfIEmuLxkZQYMYJ2TEhzIv4sO5xxG
	WFSmWLCwbMc4dBbeaTTVT14XcnCOOFUgM6PTXB+5Un6qSXOXQptYLwqbcf0ksVv5u9q8BD
	25qFRgJl6UTnk5F4764Ogx4dIpNDC68=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qAKK2cKO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 74.125.230.205 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789506570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAM/MHo0tjYo/TgHknUbcGsVAWd3749MCucVMwwVJms=;
	b=NF4OYcY8RIelMRfI1BH38k7afr1KvckiUXD+4IZguVDCr1NWW2RFcQ3FAbj4B/7b4LFaLF
	Abw0JHqldhPkhUlWsYxJCDjKkBTxf+IGS9e/WF/lEHpwPt9W7xkubhZiSWMeZ1ImSs43Nv
	z5fSTYHuqUatwHchF5sPtlCW5rLSMWA=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-5306706e89dso23161cf.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789506569; cv=none;
        d=google.com; s=arc-20260327;
        b=WcwZh0eJHgvkG1BKiunk0j7+nO8mDwNIciGyMt0jRebtutlg2E1AVriiWUk86jGQFM
         +PIvYw21JTlDopUN1/6sXDrjAE2SnisQ5aQICDp32QJq0FkFp0TDmGQaaswJrKdxmBEG
         zjOkLJ/Ai1qZd/x2VRIzEE86xkB2YT8/amHmAiKQoQmDDAbR8QgrOvfFOrHW6bZKthss
         QUPkSuzaNRPN/H88aT7zKymMkWjUaOeF9MtmW2iAbKyggIy0qCaNjQ8DijAW74obm9o9
         8ViuFGiCmFoDJNq95EYz0G4oy/WqF+o34/JDsmcU6CLYSler2Ir5FeO9PaZp+Y5QCeqP
         1stQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OAM/MHo0tjYo/TgHknUbcGsVAWd3749MCucVMwwVJms=;
        fh=VKLfcUYfeUSu9eNaygcECKdcK5jdAfRERqcTBS8AI34=;
        b=jstZBHZHBtklB8ywR3Y3TWw8vZpi9QpCn/LvMcI6/lXzVZOuWmAvN56wuOMmu8o+4N
         CzKIwQxdeua2frl9rKrOuU7+pH8r+vWXwPcMY1p1rPmKcVaJs/McVDO6nGhi9tKJfqoh
         /qGplMpeYEgBdQm3kN21QfYb4f8PPWG7nRVBGurvbaEFij276j5CkLShOL+c2pWfquwR
         Tx29jergfTT1eHmH706noaVICWo06kbq7KdeIJgeNzHxvLPNChAMu3EGXi67nSTiBg73
         +asgNVfG3i7vNNLsRbILPrrXWKrXMR+ZW3grEDd/WEfyLs24Nvj5LX9zh3C6sj9Hcf7M
         xc/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789506569; x=1790111369; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OAM/MHo0tjYo/TgHknUbcGsVAWd3749MCucVMwwVJms=;
        b=qAKK2cKOdnMUPW0Flx8kaYlY5wN2gGxtHlMBSeueR5ljkFZxdAxx4lp2iRDvdCf8t6
         ZFjvEQ6NZrCJ5mjIdzk78Q1pBa/6S9TX3kchjPtMwG2JJzLXyPZ+Blzt+x9P/aTb0e0Q
         xBwKqHagS5+F3o8BrHacJlQZcCuXGPmTa9yR12Lum/0Z3N4FQ+WiLbcLdSo1ZqalFIgH
         wviOZnwmlXHCmv51nMMn06lC0V9/fQFkWjOeIOpNEOe9fopinVQAwLDG33LGTWI7u6d0
         B19vGxdKnx8yz1NgIchK7rFYK3MpubKXhEKFBunvJy+uZqm4wDmlTD4DLrMats0wYc0d
         8ShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789506569; x=1790111369;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OAM/MHo0tjYo/TgHknUbcGsVAWd3749MCucVMwwVJms=;
        b=d/hQHqZDsaCuKW4VbAv0CvVrmFM1ztberuwhdbCLzTbATIJspHLoDUEPpsuFT4VZS+
         rz7gMDVcCrP5rJZWfBmvGIZw9YnHPVZAh5MdOtDwOHayMkPd0SdplLMyEIXTqrVmiOM2
         Q+bVEbWhmhJd1H/DBjlzD9ByVnaKCzJNEYPATFUzT0/eNKqMgguOYL6+Kel/5i15w4kd
         GxSiAuIo28xIzhZoPZveibxszO7et5hoVl8z9LauJr6qqRA6/TmoF1DOrWUW8Cam5OBt
         tL9jHnKFblCoSc9KE25lV2b0Ki5iTYFVKY7a3ww0e3iPKjB7ykYT9/N0UrAPVpa55kZ1
         Or0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxPYymSk5BQcZhXX6Q6LQATb6AcgNBwriNEBEsiIze6645yadzAJJSi/m2y7cbn71sFXNiAMCa8Hg==@kvack.org
X-Gm-Message-State: AFuF++nH3VHZMJ1diPtVtyGc99Cjo/U7JKZ6QgBvY/kSp9CdgSsWam1F
	uE4LX8uT1geyoQh4EwdrnFdrNpRbSmkBEocGyiNY0OTv6/ulReeCFWcOXTRDn92cqO6SAs/mlzr
	8pV+twCwcelZCxgqBVI+DZc6LucIQJJLF3KEhbKE4
X-Gm-Gg: AYBFou3z86Pin1g3KXq5HOen/nDiFQ6tmi5z88ciL09MDjwGQQTvRI9rzTn4FzKguoo
	8rj6bADnFxr14+mUpAHLVj1UJKnIsKidJ//WwrQrGqxXx/xZXN3X3PXHz4c7P/ftm41d2Bjbroh
	JZvlwxmCyj4dGhzZzoJ6XBUsInVF3eKkc2K1S6iyxYK0WA/m/NPSt7kxpjwImgOKCs5ngmJ+dk3
	ZpGn9dJ6M0LC4hKBrpaxwDaMWBVMqCvgkOiybI+5NEQdGRBFcQLqElEtVIR0r1eBmNo4Z5Cd+1R
	3qoySSQa17NaC7RY0++MkAdFWxqaoPTHUskg6hPe/NUJcYB3f/nV/4EsyPoo/ct8on2SzBOzo10
	YkiSPdfzUuvTmdpCAglL2
X-Received: by 2002:ac8:6f0f:0:b0:52f:9ed4:8d75 with SMTP id
 d75a77b69052e-5327ea623fbmr753851cf.15.1789506568256; Tue, 15 Sep 2026
 14:09:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-3-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 15 Sep 2026 14:09:16 -0700
X-Gm-Features: AcwNN1W8v3TTrRxzwemLVzpv82f0jC7eBKsciqbn6XlLizQdqhzOL-UqObB-lQI
Message-ID: <CAJuCfpHJSwNhgotMVpmjVvdv=m52_7Kvzpztf0WcN0AaoSeGGw@mail.gmail.com>
Subject: Re: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2F1780007
X-Stat-Signature: ps84uqekxi4ix3eeup6j14frx6kabosk
X-Rspam-User: 
X-HE-Tag: 1789506569-159071
X-HE-Meta: U2FsdGVkX18jGeWbmHnWMti8XNt4z2GK95HT/7JTgBv0d05AvoDnrsnHFLW0IDjtVvWJF0+yvQd2klwmOeziXh+CxAQ8H25JFlWtbNgYTFSEvT98YsJCPm3DGVDDbJJ6xTm4dngysQwyXOauxbc4K/522fjIkt9lvdySL+5MqPrfZuRbojdr3gxeX4abY7gm0GW4itleVEjh8pFnMjPT5ut95scfvYQ7p+XoCO7SgYLbg9qf4POlTG3Uv/pG3/GJ2eP6ArKjzIpPQ6uSJu8hi7FG1GxLJn2EQo5T+0Cz8ZCJME+fCCNiTlEfTYq8x9O5ftoSgTdmrg2vWlNYhJOW9oYKwshKwID7mg6ZcFHip4QNtFUle8BESe2WlF1CyXVi2pu6zXCn3Sk3XFGL1vEi1mwTlz3td6nIvjdtyfugjrQJMR6lg0V+dJl/kJFeGB5Qh8hP+fwOyb487HKtJmjIQiGDRIn/nU8XKY7p5ieUESFTPtW98m9kVEGop4YKEaWG15CqiuAxhbuTn9aBftoo9rxGoNHibdN89v03bc+S7wadJtdqLzxKgHPARGSMor+Kvak+MJYU/tDu3tZ25qN9KZPAbr8kwjD7Zt52oiulEBkfsqrB5tJr8NLteq1yFUIJFId3O1c12IAVLKbDGiMwARHY7v2yR22K3lMuwnoyLLu8ilfvhFVNP3X+D+rK4vsXs+c5LEN4Qrfwej9/jOrIg5YROUeDD9dl3Jkhfts+kyrYpECMw78TG8vezMvGpHv0CaCimpV1ZbDnnK9HAzWOlYgEtLd4dEyMP6COgj5F/ZFW3AHV7nzi1Rljre943wMfB3sYrQIQWKPR9cRVqb0mGfm8qQtQttjEUW1diOYPKFE7zOPhMta4wXSvqJJ5Cl9HcRxDcLp69i31EPe4QkZoarRB/ZHmHacdzNoFwF35CzZ4sX22H2W6ca31X9L0OTIk1yQhZGxpW70cwbbWksy
 0LJYXQpq
 OtBmr05qw06jvEtSsFhLwr1uIucure7nbpZoTF7hG8KXuq7lqayIqM05BvIXOi1RL3J40sPqn49UEM00l75AmRMjUQViFGNJQh2rlb74YXuLWaP44CT5gx5/VRp2DtfLDlooFLfsxg06vGBvI48Yu6dIddcqCJKrJTxUq9YJEEN2FKAJBoDH9isgOH+XaTERNIKn0shzf7xKwSwlKDEnFjWBx8BJPO409WLenJv8cl03+16TcC7TAurLWW7/0bdlK4kO8ozVRNFjhnzTp6E+nRRks7QakWQbBoUdqfyf+dMO2kLLe5gBxufhTkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> The reservation is already stored in the maple tree when
> vm_module_tags_populate() fails. A failed load never unloads the
> module, so nothing releases the entry. Release it and roll
> module_tags.size back. Without the rollback a concurrent load that
> already passed needs_section_mem() can reuse the freed gap, skip
> vm_module_tags_populate() and write to unmapped memory.
>
> vmap_pages_range() may have installed some PTEs before failing. A
> retry to populate the same range would BUG on them, so undo them,
> but only if vmap actually ran.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as neede=
d")

If a patch fixes two other patches, it likely needs to be split so
that each part fixes one patch only. But read on please. I'm not sure
if one of the fixes is correct.

> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/alloc_tag.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 2070e682fe10..95ddf5b743d0 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
>                                      next_page, PAGE_SHIFT) < 0) {
>                         release_pages_arg arg =3D { .pages =3D next_page =
};
>
> +                       /*
> +                        * vmap_pages_range() only runs once all pages we=
re
> +                        * allocated, and it may have installed some mapp=
ings
> +                        * before failing. Undo them.

If vmap_pages_range() failed to map the range, why should we need to
undo it? If it indeed leaves some partial mapping when failing then I
would argue that vmap_pages_range() should be undoing these partial
mappings itself before returning the error.

> +                        */
> +                       if (nr =3D=3D more_pages)
> +                               vunmap_range(phys_end, phys_end + (nr << =
PAGE_SHIFT));
>                         /* Clean up and error out */
>                         release_pages(arg, nr);
>                         return -ENOMEM;
> @@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mod, =
unsigned long size,
>                 return ret;
>
>         if (module_tags.size < offset + size) {
> +               unsigned long prev_size =3D module_tags.size;
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> @@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mod, =
unsigned long size,
>                         shutdown_mem_profiling(true);
>                         pr_err("Failed to allocate memory for allocation =
tags in the module %s. Memory allocation profiling is disabled!\n",
>                                mod->name);
> +                       release_module_tags(mod, false);
> +                       module_tags.size =3D prev_size;

Yes, this one is a valid fix. It fixes 0f9b685626da commit.

>                         return ERR_PTR(grow_res);
>                 }
>         }
> --
> 2.25.1
>

