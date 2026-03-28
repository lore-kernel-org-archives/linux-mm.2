Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E9010F3DF4
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 19:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19BC6B008C; Sat, 28 Mar 2026 15:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1796B0095; Sat, 28 Mar 2026 15:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07036B0096; Sat, 28 Mar 2026 15:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDFF26B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 15:28:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B1DB14024B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:28:57 +0000 (UTC)
X-FDA: 84596459514.27.AC0BAD5
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id 823F61A0002
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 19:28:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdYbZ3MX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774726135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgKzpV0f8TiZbPqRGh80/zOiGEc0MqdhLqlMpC5tBoc=;
	b=q2WABn2KQNRjuP88JtgPCyWPmrm2TJ95AqQlF+nUjM6xU5NdA2aCpTcadZ6udfCJt1vwOn
	DmCRcsyier7/xppoaDwG/RHTVLR+DfUnEr59AiCIpVJ3iSJ3XYM1dNXVsVFxg/fGQVIJ31
	2xn2Hf2jOI0R4EHHsRN8BWQF4v3xGIw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774726135; a=rsa-sha256;
	cv=pass;
	b=g0UXbW3+2gTL3NIsrtfstAO7ux9PmUJKPJK9lR4A9oBXq6DRkdWydNKT5ltQslZwHITBZO
	Q+2uio1oFkw7RI6FG1OrmPgK3LRyppwcELGIU/G6uceXgkgqIDmm9n4Fefw/YpQRShVZQI
	E/ruVqHjyjKaUBTq46XHz6O27SypQwM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdYbZ3MX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5091ed02c54so408101cf.1
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 12:28:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774726134; cv=none;
        d=google.com; s=arc-20240605;
        b=GpnC6al+nY8nErVAnaFODn+IWeIhiiPNou1FVgMCvMzubP5RRdA6KuHWAEzLLzwdnT
         ta3o5EmJh86JJrDNa+XTnDhVB4a6F0Nx4TLjK66gPoj8XLQS/iTXP5aDbxXpRwmKPebQ
         RBBKu+9KA010UXKeZuJmHQ2HQXUkfw16TjxdfJzzXRKjTNI1TFlWDl0piXfzMBF9lZCz
         /8Zv1F84QI+9LMoCweKj/m42wgYJfSip8t36s1rZZMp7z+9Y7AcofdIsTRxPPZusA4IS
         7FwCUz4wOldfaIMGQhLRIgV9KFfRr48aKLoE2k+27Qq8KrbwUDL2PHOH6uviEJzO3jHb
         Y0sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TgKzpV0f8TiZbPqRGh80/zOiGEc0MqdhLqlMpC5tBoc=;
        fh=ykqp1Xzj6LLy07D+7IBjlmsiXZPX8nzGEaMLHRXPlxk=;
        b=FWCJBsCxgHOf8Y9Xd6h2eDxQhK/9tXOa9B6wkE2Nm3yRh9LjPXK7+jxffBQhGD1/37
         zqc4g1aV83w/GCm8PKSkWMvu/vmhVP1CMC+ddzqAg5q7cito3C50Qs2g5QmNMD+KZ7Un
         tmZ03aICJ0PDq8++Xe+r9xmLZRiNYIzC8QvlgM001htcO3wMjUTXJhSgpa2Rp+cP61pS
         p6pVRzKXtxa7OQXI1ftgydwL9KuO8pV+JEU0/KRF3HliWb8sAohwi1ep9Ek0XS9frk9Z
         NOMJ1ej5vch3usGrVWGiErQYClfTdaF6X95YYbOvr/LxXNjN2yA5xyD6e9LuC1p8/l9C
         xfjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774726134; x=1775330934; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TgKzpV0f8TiZbPqRGh80/zOiGEc0MqdhLqlMpC5tBoc=;
        b=mdYbZ3MXqWDihxAlzA1IrZ3Cr8HaiXHnDI084evxqUsnjrI4y+x05ehrkH0MC8eGuj
         8/Rey9g2BcLEEJvPJIDMSMt84crADb3yHx0wfYmaDP+8IB8oXJ8fOcns3Xmx5vFqCRS7
         GTN7SQzmKkuQraUWel0bHD4TXPNNUMCgkYXFUTgNNu8sDN2kgvSI5wHHdYv9EDIpe++U
         nn7bUQwEuggYGpD6wyJzTlWX0HdxGg8Zmoqqkc2BtWvrpIiWQAVKWfZk/HdZ+n23KO13
         wXr8Zj9WcOfqMeL488ii4XIB3fjyCd7ofzclvuoFJmscm4y1OiyW6mhzH6O7YdQvaMMq
         /d2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774726134; x=1775330934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TgKzpV0f8TiZbPqRGh80/zOiGEc0MqdhLqlMpC5tBoc=;
        b=Z+Jz1qf8yQN7Mv8/AFHuip7dVaeIBrzu1U99yA726vR3Ez9dWm4c/hmilXkZ0LmBtn
         24+R7ohzD127PFw2fN+CNWyJL5TwiJNqjVRWtoS2t7GW3MzP+fp63n0iA8x6thdWrwYr
         A2WjCkTQs3D05OR0VvqFVMUwuUdL8xFM5potJWGP7sO8loY5SEVEXGiBKAPBniouSFRV
         6su3RwpgUpqZn6c1UQUb6z9gfN1oOT7+1FNTQB94QQRh4NAHcBXvFwtm3A42cMrvftXV
         pbz1cdhHhlzwZ2YPwos/jcJc/QzJiYONC1qWPu5BS+GJCSiRTdrrGxXpZLKasAO/KB7f
         h+EA==
X-Forwarded-Encrypted: i=1; AJvYcCUJbpEBV+xojLfkr+CeM88+mdf17ESmZURGDW8blFlI7oB84kRf1YOlgDQ+T6o7obuy6wu5gjDsig==@kvack.org
X-Gm-Message-State: AOJu0Yy5MwI/oNoiY5E+P+AmyQXemo62vF5QkTZVHC72TRVa34hwRtPP
	KXkN6bt1h6chXrMObdY18iBh5XL58ggKRs8nUGgbYH0THxGnJ5j9krb5EO9tVOcfjovxW3Xoe37
	oRomYFKiv7b593g1YPAH3ssOd0QOIk5HQYGiLZj3I
X-Gm-Gg: ATEYQzzlexoDQrDCyYnS9WBE46mcVZaEGqF2hjguaaHlwzW9cDzqbe8t8rmmQ0Ulsfm
	yprRpEBd4Qt/pMCQojb6rlIzfxUF0haJr3pRD4i7flHV1JFOwn/ABvgFv7q0OAJxe+9RtaXAP6w
	w3zNaAO+0Nishh4et6VMKeR/D+6jqwLlJwFn94pm0yqXF3+nDuaHj6rsb04hcuukggdnFw2GzGI
	vDlDcYIAjDh9rZi/NJykJy2+SOpHQXyuAq2A10iBkgh4djiuiLNqVg4gZ2AJd4Ip/Dh+Ot0iKvw
	Aea+cQ==
X-Received: by 2002:a05:622a:4249:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-50bb3c66284mr11091651cf.1.1774726133983; Sat, 28 Mar 2026
 12:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1774029655.git.ljs@kernel.org> <b677592596274fa3fd701890497948e4b0e07cec.1774029655.git.ljs@kernel.org>
In-Reply-To: <b677592596274fa3fd701890497948e4b0e07cec.1774029655.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Mar 2026 12:28:43 -0700
X-Gm-Features: AQROBzDBQ3SPeGlkEFLJaoaPBwXp_hUaNTRANBZ7WzUX5ZmCUVer4SxAcxyLTgw
Message-ID: <CAJuCfpHVHcqxmwvLUq6S_yEqBK3L15xia0XqhRBYzVOtjKRf4w@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
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
X-Rspamd-Server: rspam12
X-Stat-Signature: s11tfcugnpreher93bnfgcfzrmsmxwyb
X-Rspamd-Queue-Id: 823F61A0002
X-Rspam-User: 
X-HE-Tag: 1774726135-549488
X-HE-Meta: U2FsdGVkX1/vXyuDbceoqdgzm9E/YZSDfZyDOAJgP/upUkf6AQrK9FT+QNeQGpOdqTqxCU7rIcoLTc0sswuNA75wfaHJHFPH1XaOOYc6Ga+Edm3LqREbdRMsfQpvjGimzimcDuw1Y0V4iE93CxybX/wsjgpImaardk6uii4ABos2jnekAr6Z7HPRIqDXDnPF/9Kdz1Pu5+wsAqmbn7bF+uSsH1KlEk4H65tpJIrcxlR6R84CE3TsVyikFBBOWO6w35YAcmu/y5aBYbUb574RRTvT1ISI66vfUVGAV6HHAQqetotY3j7XvmDx9p7WAW8Sh3OMXKkCI3zSmKRi8NlQGFidNRSFuk35/fY9tUZ0ldfVnTsrOy8q14mOXKS1sVBHFM1F/rG/PNQ42l5UtM4vGRNdzzemwCnXzMOgnIlJM+D89sMClQuCDrSO+hRBIxr9/HDk0YktyUdYycahv3rLQDvwxSJmXChTsZg36H9/oWSWMkmvSHN0afO/E9hetrnPOuhN9Yi44LNjb4Esl4Q2zejABbAOoJhUTC/5HtcPfy1PbSNnIa8lOsD4CHU6CknFvVegeDCWNCjCkzPJHusnhW0094jlhyP/tTXQV4Zwa0DIM2cXyXzqLdAyvQC+BFwf1myQ9CUqy3eaain+ycyMeL+pjlNcp0WSU7xgcWXvHhp77UsEkZtt5UkCzOkTjNsb7ntORqPk5USynqR/DFXjrK/9Q+dhpZry32q9fgkUoWnlS/8D2aN+famA2M+t3e8qOVZM5QiF3KPoB7UyAmpdQz8EWbn3mHKIEyOrjdlQxRBbTy15/H7L2oy1VRpwCxaE/FAS4bFtYzBltPOCxJPeTMPhvVBZ+zd+EWC58DdT5YTFRTdWF+w8i1acTiwItEoRDybCSVgdi0MS00vaa0+o9CaYDYjlC4cZaZiob0yYvIpVejsnAS4k/JNnWWvIYyamnZHouP4IUvm2unGsZ1u
 oErLGTWl
 3A7GJqsz0im0NnOI8oubJoxxfYX7a11ZctGOMAxx8CF7SwkTs63BdohY9a5Koq9fqydAKhlH4sZPUoB9lomNArNbQpxlP0aMpeBx6vj1Hj6yB5NI9nFqO7IjDOcgPiWoRg+Li+c0cgjnpPtxQ8QI6/LBWL6qmzDJnu65LyTKiejqfXoW988bIkFNzqlxvA7mjWuCYf53/9R5H65OoFYWxX8N2BAmKxnQoGJjMiBPmj2R9vk0rzp1V1R+Np4yks4PEN5dYbcd7WNH72rvHzhCok852PF6ClDjCU+UILvZr+rmOAamsCV/fM6sYGNK77yFKqlrs/up6XmyaRRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:08=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> Separate pmd_is_valid_softleaf() into separate components, then use the
> pmd_is_valid_softleaf() predicate to implement pmd_to_softleaf_folio().

nit: I strongly suspect we'll find out why you need
pmd_to_softleaf_folio() in one of the later patches. Not a big deal
but it might be better to introduce it in the patch where you use it.
Anyway, this is minor and not worth refactoring.

>
> This returns the folio associated with a softleaf entry at PMD level. It
> expects this to be valid for a PMD entry.
>
> If CONFIG_DEBUG_VM is set, then assert on this being an invalid entry, an=
d
> either way return NULL in this case.
>
> This lays the ground for further refactorings.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/leafops.h | 39 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 35 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index dd4130b7cb7f..65957283fa9f 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -603,7 +603,20 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>  }
>
>  /**
> - * pmd_is_valid_softleaf() - Is this PMD entry a valid leaf entry?
> + * softleaf_is_valid_pmd_entry() - Is the specified softleaf entry obtai=
ned from
> + * a PMD one that we support at PMD level?
> + * @entry: Entry to check.
> + * Returns: true if the softleaf entry is valid at PMD, otherwise false.
> + */
> +static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
> +{
> +       /* Only device private, migration entries valid for PMD. */
> +       return softleaf_is_device_private(entry) ||
> +               softleaf_is_migration(entry);
> +}
> +
> +/**
> + * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
>   * @pmd: PMD entry.
>   *
>   * PMD leaf entries are valid only if they are device private or migrati=
on
> @@ -616,9 +629,27 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>  {
>         const softleaf_t entry =3D softleaf_from_pmd(pmd);
>
> -       /* Only device private, migration entries valid for PMD. */
> -       return softleaf_is_device_private(entry) ||
> -               softleaf_is_migration(entry);
> +       return softleaf_is_valid_pmd_entry(entry);
> +}
> +
> +/**
> + * pmd_to_softleaf_folio() - Convert the PMD entry to a folio.
> + * @pmd: PMD entry.
> + *
> + * The PMD entry is expected to be a valid PMD softleaf entry.
> + *
> + * Returns: the folio the softleaf entry references if this is a valid s=
oftleaf
> + * entry, otherwise NULL.
> + */
> +static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)
> +{
> +       const softleaf_t entry =3D softleaf_from_pmd(pmd);
> +
> +       if (!softleaf_is_valid_pmd_entry(entry)) {
> +               VM_WARN_ON_ONCE(true);
> +               return NULL;
> +       }
> +       return softleaf_to_folio(entry);
>  }
>
>  #endif  /* CONFIG_MMU */
> --
> 2.53.0
>

