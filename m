Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B87360A2619
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zHRNF0V+
Received: by kanga.kvack.org (Postfix)
	id 378436B05D2; Fri, 20 Nov 2026 03:17:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329956B05D3; Fri, 20 Nov 2026 03:17:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219A56B05D4; Fri, 20 Nov 2026 03:17:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6B8A6B05D2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:17:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D88D4C0DD1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:17:16 +0000 (UTC)
X-FDA: 85454792472.05.8B18938
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA6E6A0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:17:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zHRNF0V+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162635;
	b=uWSS7vmxUE1zxDUoJFgcmCCL/Yo4/kKYMFbyRhcnXT4lWm4TfkdUuGqMEgmsZVIHIaSXId
	vMK0PkPO2HTqFdI1D2ii+BJScpc2rqSmRZp7PijR0HCWRFUgxpZ62rFWdFZTETN5H/GYNb
	NfobfUT7utMgaa3xS6IriWF1VDa+gco=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9NquCUCJSJuGXe0n1gktrr9r7y4Jk/ICWggLQ59hqA=;
	b=6awsqSaa5EjAAdN7N9Cy9EApt8IH0iUWQ7Po+c3R3reGYQtFgK3uEQY+V2HMglE5D9E/BM
	79luNGN27MT5vOJpVU44zOW6A0hXQ9ncLUs9euJSqUlXWFlg1M4IZpSD1hUqph2GWGFi6v
	7PD80orin6eK7k1kEadcFOzyngiQ60s=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zHRNF0V+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so4833525e9.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:17:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162633; cv=none;
        d=google.com; s=arc-20260327;
        b=XuvRDmSgIpKew3LNvqdZ+/QrAaDrvsy1s7vGbwDLDljK46xiJyFP+iKnHxHh4tsy/T
         4B5WpWC3yGaUZDSxNY1POuwLxxznxzghS6po4lZoeVIRh74tiSK8e1yyYa50IJh6/xbx
         dFIFMiduVDgia4vzZsKzNiF6EKDA5kO1dWr44HiUS9ok5i5zwgtXb7DphnNCoM3PfXZy
         5icrw2K5F6CLkEHnYEAd/mpASqEba9CmbidadOlk6gqvrG445VjrAlXapXySI8OEuNJe
         xkwh1DgQL+HN+9b7aPtYQTa13/gHMeyV1W7cWjq4w77SHd8+wW2lznCmeKk/LN5X4pZb
         cKnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I9NquCUCJSJuGXe0n1gktrr9r7y4Jk/ICWggLQ59hqA=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=sVD5xvl8Z3F1JhKm56DF+GGSsscHzGncqyh/YCPXDz+/S5RZroQ30Xoam/yspCJAEi
         v7kWvpV37857HG5YA6n0y+04gXLl3ldSCW4Rvw4xepBm+AdbhuLUQuasLT3854srzrgV
         gt3KvoTWSADumibXVwxaSxt08Wf9Bk2lKGEo6zzQt2ArImi+weGAwxiDB1Mwb15Uyv8V
         RoaYCxCvBoiX9wqNFTNFZTWBznS79FsrGYUzKSoonH1MgYuKGQNAGB8xl7sEOaDtjdfd
         64imS5tnG42fyvIsyvwRn+uCBCZDLSgTfyLwMi+b+GYvE/Y9ftMLl5S9hr0ppPXxKsLV
         1fVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162633; x=1795767433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I9NquCUCJSJuGXe0n1gktrr9r7y4Jk/ICWggLQ59hqA=;
        b=zHRNF0V+kqmaOggbNvVPiY1t5B7IEMxEdWPR4Bhil0+DtwFs3CF5dl0qkg8c0t+FHu
         HMHT7FtFs8Db1cSdBhFWIjxLkQCxDnYWoOqnXbyJqO6b1OkuQd8zA4GxanUasePZ9Qy4
         jViGr/p/OjOJBzmdMwldtPs50np2InXQ9JTG5Cx1vC57fDSljUKipGIxrx5SOR5k5RPd
         DT6YwjtuT04DlnU0GZ5uH3BFJlDAU0DDV0XSC2oBKI1sBlx/4ia2VTTonPWyjvDaYJLk
         Mv1Pn5fbgSfbPVNnrJU6szSpAxl+b6cQ5ZCGMH9DqC6a3xcy8DI69Xz1a/31U+VPoOtC
         eREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162633; x=1795767433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I9NquCUCJSJuGXe0n1gktrr9r7y4Jk/ICWggLQ59hqA=;
        b=Ulu4NPO+Hv1XXWekLqMlIgQK6DdMymN1nUtUtDg38NGW4ITh2cyilHn6igz4WooH4N
         meEA1bFdoLjaRir4GwimdHapdWqr7WLvSA/SFPXdkK9lqIkBSlGZ5KGNJblkEmqJr2Qh
         q5ls0jlChj0H3i49aYkGhL1ufwedzSD9PbD9hrluJeTAeaoW9MJRQuW6OYDknSrt3T78
         FyzPNS4LMov4akF9zUZ4tTYfAKWXKJ8AGb/aPE13rQR1udAgj+1SG007LqnX7qA0gKS5
         HrHE4+zL/XbYeG1cF+/MKxqPYoVEpjY+fqEAyrYgIHueIM7VBaw4vnFQqJT6XvJMaocW
         9Oew==
X-Gm-Message-State: APuU4Z+TkzQsG4o9g8JAWhUuCeNqQxL8O+utGJdtDEuosvCp80f2jt3z
	nR9kEkmE3RRskfhSKqrk4ciT5ben6UKgULg5SEvZ/zG6n2FSY48sSNiwYGDc/LNj5sw2rMRZjEZ
	fTyURrq+yDoykOjcZ9EecxTwfKEW8qBU=
X-Gm-Gg: AYBFou29WqnE93OzfxR7V0leU6laf9NndN3ttw57ppCHiYTSEO3FH4VCr9oMiK57R6A
	PeNXgOmOT7QbfKTos7eaP5KT8PCSLyRTNQrsW39+kFHwynTcSRNWnzdQuUChmpZOxAIXZZ1L9Es
	HnmUEVDa3h6eLa6G0EJ1uc5pj+K0jJDBcmlhNd1vygSyb77oNBPilw/YEMEF17uFL4Bmo3kPzwm
	Lk3CItKNQJLxMKKl1SUIUkVONr2NqnVb1XHldenQ9FGsUkGAT4RzAT8tK6ITxe4A/T2X3llzRln
	cDVPHIQfqwtsO322fzd69O2UFfhh+NbgLEIDp4AJ95wshUzBASZvEkzyEl47+MpNWClVLsIw8ws
	e0Iy4JOJJoXnb/hxXr2s7d5SfX4KGrPLlqEhofnF5E1nkhjXqxcBvZjNxSLU2WE/CHA==
X-Received: by 2002:a05:600c:b8a:b0:4bb:7007:4a5a with SMTP id
 5b1f17b1804b1-4bb88817772mr45942875e9.23.1795162632893; Fri, 20 Nov 2026
 00:17:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-7-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-7-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:17:00 +0800
X-Gm-Features: AclHuK87_PiI6KLw_fxUiiW6AWziAjedbgzbNSGoCid8qtKuQuZJuSbue31J1p8
Message-ID: <CAN_Opa_mk5xH5LtV04f=ooQuVatjbEviN6jxkayAatzqkie4qg@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] mm/mglru: make folio lru referenced times count
 a generic API
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Stat-Signature: pfrcu6xz73o9bgsguuasq1cjtdg6y5iz
X-Rspamd-Queue-Id: EA6E6A0005
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795162634-829426
X-HE-Meta: U2FsdGVkX19PJ5gCmsgXWssS0kDahCBDS8iZyuaA6DdoI/7x+e9SELGGRHGd2f8wpq2LD06b49oSCVHZsCn8iZP16gedtOUYIaYF6Y2ZG0SCVGZSliXaokx262nFs1sUgsYR1PumBthXMr56ZE3SjmJy62MAp1T00tvwKw99wCVJZV1kcB+N6qmhS/6tIB8YtAcxJNYf/Kf9uMMXxMUC978S4G/Me2b/BGrotI5gmFVokvAD40SyhIAQSxw5BTIRAF0F0Z9Iw6zMe7FVPzXu8Kien/xJsmKywcG6XNOasWrRbfRYeg5zb2/ah3If/1r+Bh/0q/9H3Bh0oEfF9S7Q40zIteVQGQvS68+1tzntA7jzYTnIcgKxkvhs+pskeT5IgZBTnFF47N0p7WwmQKjeODOG21P4Iz1zxtvaIbkKvnTEug+GACnfcpm/iXe3SDoidz0BUiP02gqJZeaK1SVj1sUg4cSBoVl8nKr4AFtXHS/B99Qm6y2LRh/h04AQQpbnzDAP7fR7waCPX7WMNxPjxmNtGwdCJ0G3rGNjn+K3bd7rLIePyTZCW5toBUDbL1fTqz+/bRnaiOXIGESCIcbqbiV4qvsHuEU0ghzT4id4CjRkxveV8u/+wuBPZEFGMNX8kHd18PqD7IqHsr9lJn3XtQlxBXkp+Ob2/Dlj4R1m2K26PlEBdJpvhc0gBBjqIoOLPmRimEUFALIeeX2GOMn4QyxGksWI0lbEPtdcL501xSNYIz7g/3pRBBIoLk7EOz22Mg0sUcfVOJAolwcXEs0264p9IxxGSuSlbIUeZiBa/1rxD2Gui79NvSd1Y9K0T828Yyt6yY4Fg6HOn9mP0eQaP6zjuiJCC+mabyZ2pwxG6grQNJ+2gwW9kkhRwV3qM5Rw0jxUCH0t5kgsoXAMtXC5AsY6VeEDLbKec3p4ET0mpbkfPbdAgpydGJ4hCKM/a6gDhHC7VpdE1Ty4zxyARRw
 ia80H7Ea
 KIFQtaKGqrYebi8R+5kWIWKs7qhYjsS7AgTmAxCDBBegUsV+amBZ467JS6iMyLPlbOxnEfrQ/K1VZvlPlj9/ZHjy1HOpFxUIF8M4SZopR/S2uXCb8zVFWgOEqENDfS//wGa/opQOr0Yp3wzFGdjQdBybyAnzEFrrLCq3tXTb9TJ1G2Pn8hvFA9uSq4j3ddYgCXFbVKxyBNmfnxF53lHV6zWx1js14k+ji5lYCd3wVoiZ3aOerwv1XgLQxHu06696Aec/XGycFA907+KI4UCwzGosYxHS2xyiAsBiFN+tT5TMykRsNPHu8HV4IhKMIr7uy2E6fErMXorSyUVgXckJQNteYRvZY0K76fMX7FxtKCNkR2Q595P8KoMYMYWJOyKkdIhsT7DeHswSmWdRxCODG+1q1UZs342LNtdX+wNR99+/wxtgIafAKkQHuoRM2RIi3580IqRQauGgZLlKcvoQLI0P74oQNxAT2TbFU2cNj9Xo69v5ql9Yc05qJ6Xbj6aztCxcnnKdbFRsgeIQxXhXe94mtFEc6kZSHNqKcLKjDDk+yiQ0vj+sQ5hkwf8VKYenHboeBXBrcPfmGsILsh/FrdRC1a7VPHYVaZ2NTeCuTayZqRpPhH+U/3/DrgTYmxW7SFi3h3GSSsetA3dLpCuzyUE6iGSotcy4g0LgEBwqlZ1mdFZeLvJvEtUM1Qbdp8669jBycE2iiVIkiPt4YdwUSwZE48H/u9Eld+Z/wru6DBbS+DqRNyyZYsi+ksQ1CsVTpoIkuSvifrRdEPszzkDBgoT872kz0AZh1FGzEmKL0vr38k851bmotEZTRk3Fvm3ZRMWQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Pure code shuffle, no behavior change.
>
> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
> Without MGLRU the extra bits are never set, so they are inert. Move the
> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
> unifying the API for checking folio referenced and workingset status.
>
> folio_migrate_lru_refs() now migrates the complete refs count,
> including PG_workingset (bit 1 of the encoding), bitwise identical to
> the direct copy dropped from folio_migrate_flags().
>
> lru_set_refs_flags() skips the nonexistent mask bits when
> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
> !CONFIG_LRU_GEN builds.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------=
------
>  mm/migrate.c              |  2 --
>  2 files changed, 28 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index f38dad1198fc..180db43c3a85 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -184,6 +184,12 @@ static inline int lru_get_gen_flags(unsigned long fl=
ags)
>         return gen;
>  }
>
> +static inline int folio_lru_gen(const struct folio *folio)
> +{
> +       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> +}
> +#endif
> +
>  /**
>   * lru_set_refs_flags - Set the LRU referenced count to folio flags.
>   * @flags: pointer to the folio flags
> @@ -206,7 +212,8 @@ static inline void lru_set_refs_flags(unsigned long *=
flags, unsigned int refs)
>                 *flags |=3D BIT(PG_referenced);
>         if (refs & BIT(1))
>                 *flags |=3D BIT(PG_workingset);
> -       *flags |=3D ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
> +       if (LRU_REFS_WIDTH)
> +               *flags |=3D ((unsigned long)refs >> 2) << LRU_REFS_PGOFF;
>  }
>
>  /**
> @@ -252,13 +259,31 @@ static inline void folio_set_lru_refs(struct folio =
*folio, unsigned int refs)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> +#ifdef CONFIG_LRU_GEN
>  void folio_inc_lru_refs(struct folio *folio, unsigned int flags);
> +#else
> +static inline void folio_inc_lru_refs(struct folio *folio, unsigned int =
flags)
> +{
> +       /* Should not be called with !CONFIG_LRU_GEN */
> +       WARN_ON_ONCE(1);
> +}
> +#endif
>
> -static inline int folio_lru_gen(const struct folio *folio)
> +/**
> + * folio_migrate_lru_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *
> + * Transfer the reference state to @new during migration: the MGLRU
> + * refs count, or PG_referenced and PG_workingset (bits 0-1 of the
> + * encoding) for the active/inactive LRU.
> + */
> +static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
>  {
> -       return lru_get_gen_flags(READ_ONCE(*const_folio_flags(folio, 0)))=
;
> +       folio_set_lru_refs(new, folio_lru_refs(old));
>  }
>
> +#ifdef CONFIG_LRU_GEN
>  static inline bool lru_gen_is_old(struct lruvec *lruvec, int type, int g=
en)
>  {
>         unsigned long min_seq =3D READ_ONCE(lruvec->lrugen.min_seq[type])=
;
> @@ -424,20 +449,6 @@ static inline bool lru_gen_del_folio(struct lruvec *=
lruvec, struct folio *folio,
>
>         return true;
>  }
> -
> -/**
> - * folio_migrate_lru_refs - copy the reference state to a new folio
> - * @new: the destination folio
> - * @old: the source folio
> - *
> - * Transfer the reference state to @new during migration: the MGLRU
> - * refs count, including PG_referenced, or just PG_referenced for the
> - * active/inactive LRU.
> - */
> -static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
> -{
> -       folio_set_lru_refs(new, folio_lru_refs(old));
> -}
>  #else /* !CONFIG_LRU_GEN */
>
>  static inline bool lru_gen_enabled(void)
> @@ -470,16 +481,6 @@ static inline bool lru_gen_del_folio(struct lruvec *=
lruvec, struct folio *folio,
>  {
>         return false;
>  }
> -
> -static inline void folio_inc_lru_refs(struct folio *folio, unsigned int =
flags)
> -{
> -}
> -
> -static inline void folio_migrate_lru_refs(struct folio *new, const struc=
t folio *old)
> -{
> -       if (folio_test_referenced(old))
> -               folio_set_referenced(new);
> -}
>  #endif /* CONFIG_LRU_GEN */
>
>  static __always_inline
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 28a8d7734735..c8c49357df87 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -796,8 +796,6 @@ void folio_migrate_flags(struct folio *newfolio, stru=
ct folio *folio)
>                 folio_set_active(newfolio);
>         } else if (folio_test_clear_unevictable(folio))
>                 folio_set_unevictable(newfolio);
> -       if (folio_test_workingset(folio))
> -               folio_set_workingset(newfolio);
>         if (folio_test_checked(folio))
>                 folio_set_checked(newfolio);
>         /*
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

