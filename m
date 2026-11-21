Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04F460A260C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zMF9vKQW
Received: by kanga.kvack.org (Postfix)
	id 8D0EA6B05B0; Fri, 20 Nov 2026 20:36:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881C66B05B1; Fri, 20 Nov 2026 20:36:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 749DD6B05B2; Fri, 20 Nov 2026 20:36:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 355D26B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:36:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 898B816029C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:36:43 +0000 (UTC)
X-FDA: 85457411886.24.3837323
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77DC5180003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:36:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zMF9vKQW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795225001;
	b=VAsPEQJH2BqzI28MA9PzHsQi5CoRuDOjYQHvH4xAZ2HlXqF14LxAYrI8ORmhL+Z6b5Dmio
	tudjY3TcSpBf2UXs5O9X/mMbpzZSMgr74qqtveT4SyTcbzvY/XoyczBQw5kCvap5l5H+mZ
	Jn/cuQiIl3T+X3x/xMIz+twj3inJobk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795225001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
	b=LDKuHD8pfMnLbXy70OLA1mS4XCklt2pZ8FRf0/sbQUoKjkSzCAMXmx0aHbAPllXWHue7oa
	8e3CPoz8oFw2MjceYXU3hARG/GuDEIA24UnY7gf5J3uXSvRqkR2BIQsUdCboNHUsObEue9
	GCPncqibkjbQdXJtCP3uHL6mTjz9yi0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zMF9vKQW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3acd523a802so13719521fa.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:36:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795225000; cv=none;
        d=google.com; s=arc-20260327;
        b=URR3GDswYCIu6cQF+jG67ydO1sDwDoghr5DUC8zdzJENKz/kqHtNRxtTvVAHAphBWr
         R/sWkhettlf9GpjPhh1rLn+OVRKh6U08UfWijbe5I5TqEZQxO6jjTcy2ItW0Xm3zy2iB
         CPlHVDFBURiXcWzyt3zNIAfkJh7ZwFPyQI97WS4nsZbzwELTq1Cqw8XRn24rWz8up/01
         WbcQj8GpoBLyxhnvPA25GUzE6aq07BnRGO81SvPIANl62ama1vKbdbvZ9gJpXhzljS5J
         rvKunP8L5BH3bThCnYNDGTYIMJen7DElw5XdBJ+WxvLKBsniNu9L3b9hfncp2S8/4DCv
         8jlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        fh=8QLOtTY4GPVVrWCSsE8lbayCpfK8OqGgXTIIE5yrxSI=;
        b=i3QzIR3roPzin3bC6a6AzxJCa2sZMyta+CYc0FTyD0OeNrMmf08BTyyjkXZc9AqN6E
         jXJK9QNBQXTWlmYtuCv4IAHlYMyjYVNqoKEYU6/Q7KZ3xwpruYOimsjvuPMoUyT9Qk+E
         G55djFkIwbwdr8cyaJjAdC1NqIN2EnWjTFrj+VRX4NPz2rscSQdo/9qqbQEf61fpsV4P
         X2fnn6gbC3k/IDiL9twnTPHlPgs8O7mPjnuQrdwjGrYOfLuR+3jMYhw8P/s7XbyQodRJ
         o/p+3SK7vAXYaLjLx7cPOv2UVYvb6e3YmbnAF/T7zWxsxcgRnnOXKeBu6Vb5a6upWbjq
         mSMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795225000; x=1795829800; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        b=zMF9vKQWQa8BB4+9d9iEiYRbBctnZz4NvJ8LIgTSruV3wETNSMrM5FL7vQv67KZ92z
         4YWp6eeXefZs5SsDdPpUzKBnYmc0+hDOAlq+PNRFzFg9ia9Z1pvhwqnl2v8eScSCVPaK
         92PrCR9up8/OVbtD4ted9Gp2Knyt6N8wGzz6fvHqxjyZ0xvttZLvaRAf9NY5yMKD8VnL
         J7c9onv1Sli9UKGbbUtZx5TEacFKPkJsjQ4OUmAlevyfUsW91sg8vBp5kUU4XrDC80rR
         lu27xyM7HIQJnK1FfWi3q/77FokNm5Q9ntMsIBK0iZQA0uUm+pSuMmmyWpsggMsSPSEB
         5ftg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795225000; x=1795829800;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K0GTi1D3/sOSvq62k+dOmi8FEYi6pvAy49neuOOswQM=;
        b=No7Nount1ya6rAjV1CrJeXQWDKRZBkanHOgAb9ZNFWbC98vZFP/oA6v1xY5NNUDSjt
         dbUY0A3CzAxTDg8JCBddU/t0LwGMm359AWlnkm4aMUGsl47PxkDO4jIAWckoTNbQSeeq
         qgAizHAI8mDC+HmvRzJkvfxGZOfpLU6Tf1Wk1Aoox93X4C/9x4kPZmGDTj/slvMkOKHt
         QemGiMZxvtziGGsTJ4m89O+liC9JgkbJ+gopQjS/GWG58Hz4AQ20lEJ0wkxku8f3UndH
         PmvbmhspKKIAVd36oPk6qtshYeOByInCtGRMbVZVNdhaIoxtS3zM3GjB1SFCeRvdeu5E
         K3Fg==
X-Forwarded-Encrypted: i=1; AL+hErEF/2LJcBK0X9dekenuVCyAFQYxcBHieRNr5dwWuHLDuHLQdHn+et1PC1+XNxU+Yjpg1iO5dwuGMA==@kvack.org
X-Gm-Message-State: APuU4Z98xjIc5VvUpoimyHQDDO+g+A/dla+jyJyucrxTZPznb4XrqV0S
	eeaBo33DtuXQExu7UyM6ONnTwmQc5IhipB2XTzwV4XHdmIFubQQDTjhfp7hK7iuzCilC1t5fKBP
	YLQgPbrRTxdvTmcbogGeH9HSiyp/hm7o=
X-Gm-Gg: AZFdTZcc+9qnw/eVrPqgG/vcQxupwVdn9FRcniTdmhHz+CLpamBimbomrNazLS8X2y2
	N8lMXd7inYCcjXS+ygbUd3ZpuKYSw3R0vxnLDWL1v7s3l45FZGJYEJkAaNx1DYrg6OqNFTFWr9d
	jpnT5WfZrv2kE+goehRr4d9NRzwgzIGIF0TYk6t4xcZ7SEZ/R3sNpdDDAgqvojNw47CX+SXuxdV
	TfCalip98onhEEpSjw2YuOg1AHbMTzciBDDFM2rR57xKgmlMPVIJtb4KDgv8j+lc+GcFuLIc4lN
	CKU+bT54Qpa+QfVHdFEqI/xT4KCZNkGNvkJaNrutiCZkkyzDXf1SnoPRiCvcS1ZExbERuO2DUT6
	8+FLYkoR2xGAvLzqjLw1R4qodjDtkPeDC7hd2
X-Received: by 2002:a2e:bd06:0:b0:3ac:7ad6:2003 with SMTP id
 38308e7fff4ca-3ae7f9b1020mr13168511fa.6.1795224999709; Fri, 20 Nov 2026
 17:36:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-8-kanchanapsridhar2026@gmail.com> <CAKEwX=PuyT7WhrA3nEQQTyw1H_5D_ZxEcSZYQSF0MyUTii36MQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PuyT7WhrA3nEQQTyw1H_5D_ZxEcSZYQSF0MyUTii36MQ@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 17:36:27 -0800
X-Gm-Features: Aa3M54oYJbz1gF7DnN1eSJnxvBH5vcc-wU5reSCTlWZdMlRlH4dttzatd7d_HsQ
Message-ID: <CACpmpoeerjFsaZ7ap9wJCFDGHdtepbGxeSkh4QFo2VkMKKUEAw@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: Nhat Pham <nphamcs@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 77DC5180003
X-Rspam-User:
X-Stat-Signature: 99z3jacmwtnxrtpxgzaeqph4ri976mit
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795225001-227156
X-HE-Meta: U2FsdGVkX19jQ+iyUX0QxHn41HjguC9JiJOzCDqC+eVE/RpZUEZQUJ0OHxhm9j0+brJv5k2pZzR9WrK9rWxr5AJxdN/pLGNgI1p08OuOh4cMPBxNOpdKLF9C7S0BlJWxIPVrx6iSSd7/58NnkSLuvl9hoSVEZ5F1I7UQqlMaitP2zENF2jYakOE5uUbW4uA1c8Rm6Us/H/Xl2wRK/g01NnhYzAaEPt2gBNTYWGPfW5JOJWcEG3ethknFRm6Gbsr7taGO2MxpcInbVYVCxtYI0VN9wk5Kgz8gAQuoLrUJSzK62ZheBtaZwKU1CH/zswmN24oQwiXFBzzwlfy3vAlkmjURrQcDwaHzheKrGVTyhMWZsLSWvPsJ1LOQ4PUgg0asuqi+M8T/Sm8gaWhmJ4bOTN1tynb488evw2W6NefNQyAc5nyqb+BROGU8KwX8XFSVgxzm5eZI5zSeL7ufjUhvlzRGxtRhS8jIxaldT0Yc8yJNJWaXYdnf4AxbS7JsG2748aNoA3FCpymBPhVA7uZfakafQJR+iQv7X2s0CNl6xopVIBsb6F1VCOVyJ3+cxXoC7LaOZBxVx/2OwqC7PaV6YLS33aiTkqvbphuwccyF2RjmELprl2iFBsMV/SchW8feECvBJCjMql0tduaUkoZJ2ZAS04inpEWD86T0Yeue0CmivOR+JQ2/y8W11dC0Md8cDqGhw83U1ub0D0mfw1fDzfqye2kCC6p0/nUCbdAYOJ/C9LK4TA1zmDFOAkyIVFM7FRIMYI5NSJHtFeEdy0dkF/20zPhZARdpblHxma/tCMzuszMZNkrAB4eDiEhG589O6B2QrdJMlwB2FulB73HYnqaCarxmF04QicWDC3j3drNNpXhHMlBlTJt0FznErEmb0/s5BNJ8AVAwfZz9RcOJbZ3TVO8qcqWASlR9DKOJPYjlGceZtSHsLWXTwTiW6Ycx8Qh7a+ObV2I4907w2wl
 SlyFP0Fz
 jUTVzKnEMKtI1sVNHgSjmZT7i1f+Rg1pmHXETAIh1G7j+sl06j7/2NIyvz7NNrlAlg3ED3+np68ug5zlMEFJxpTSjiSKoi3yKIFtYfCqvU0mw+TDC/QQlBQ5xwou9Z/CHNKiJe9in4B31ugFtXwPKbNFo5G8prfmyr02fgyt8Vwr2OF6NBAu3Buuubj0iQkV8puMkRCjwV8Vh0s5eg++hjoJaOht9NBefVniilRDpjmf8egVDEf/M3O4oF5OaNvfRZSly+GdNEnyz1kjMqOUdey5oRL8Y3HMLq52I+1TxDnQ0WR/jfx2I+g/j868E8vr2oyLDE91rk6nTQ6ZivhapEV4D97zsrHDp8buGVVZBm+MLGnKQKF2N9RLCVuSch7ohaiVFZ88WOM3Xz2mIRIEN37Goqg+iIx5boTMTKlnwAdNPruC4qJmTL1rK4s76dmYa7M87mM3irKaQqY3cUMLvgXBJE0vm3RbdqV2Oq3MbwpEbauqEk3taE+WnON1qwdjhQgmbd8f6JG7Mk5C9YhlwVLuiF0+jTG6Nouo7GM/RD6Z30rxuh1pUPuMUxhDy5HZkTrWpStOLOi9QDcd9lbhzyZ6iEhs5yLdi3AHAbD67YjCc73CljrIeHDtW+s3m2BgbamedvsD18bTIgyUV5VIP+TJZyCcQPgiVT5G6m7nIIgXODGHGN60QHoQD6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 3:46=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Nov 19, 2026 at 8:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > Subsequent patch series will be submitted, that implement ideas buildin=
g
> > upon this batching framework:
> >
> >  1) Replacing zsmalloc with SLUB allocator, comprising of kmem_caches
> >     for a finite # of compressed size bins. This enables bulk allocatio=
n
> >     of compressed buffers in a batch that belong to the same size
> >     bin. It gets rid of significant zsmalloc latency overhead (locks,
> >     compressed data spanning zspages, etc.), without compromising memor=
y
> >     efficiency.
>
> I don't think this will be a good idea, because it will make
> compressed memory unmovable.

Yes, SLUB comes with the constraint of the compressed memory being
unmovable. However, I want to better understand the trade off between
compressed memory migration vs. potentially representing it as SLUB
unmovable memory that needs to be written back. I was hoping to
include a discussion of my understanding of the pros-and-cons when I
submit this RFC, to get your thoughts.

>
> >
> >  2) vmscan reclaim batching of hybrid any-order folios, that will submi=
t
> >     a batch of folios to zswap_store()'s batching framework to optimize
> >     storing of batches of pages from different folios, in addition to
> >     within large folios.
>
> This one might be more complicated than its worth, but I'm not sure.

This does benefit latency a lot! But, one step at a time :)

>
> >
> > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> Code mostly LGTM.

Thanks for reviewing and providing valuable comments.

>
> > ---
> >  include/linux/memcontrol.h |  12 +++
> >  mm/memcontrol.c            |  23 ++++-
> >  mm/zswap.c                 | 181 +++++++++++++++++++++++++------------
> >  3 files changed, 153 insertions(+), 63 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 980358bc6f49..93f060818c14 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1244,6 +1244,11 @@ struct mem_cgroup *mem_cgroup_from_css(struct cg=
roup_subsys_state *css)
> >         return NULL;
> >  }
> >
> > +static inline void obj_cgroup_get_many(struct obj_cgroup *objcg,
> > +                                      unsigned long nr)
> > +{
> > +}
> > +
> >  static inline void obj_cgroup_get(struct obj_cgroup *objcg)
> >  {
> >  }
> > @@ -1921,6 +1926,8 @@ static inline void mem_cgroup_calculate_protectio=
n_path(struct mem_cgroup *root,
> >  #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
> >  bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
> >  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
> > +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t siz=
e,
> > +                                 u8 nr_pages, u8 nr_incomp_pages);
> >  void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
> >  bool mem_cgroup_zswap_writeback_enabled(const struct mem_cgroup *memcg=
);
> >  #else
> > @@ -1932,6 +1939,11 @@ static inline void obj_cgroup_charge_zswap(struc=
t obj_cgroup *objcg,
> >                                            size_t size)
> >  {
> >  }
>
> Why do we still need obj_cgroup_charge_zswap() at all?

Ok, I will delete it in next rev.

>
> > +static inline void obj_cgroup_charge_zswap_many(struct obj_cgroup *obj=
cg,
> > +                                               size_t size, u8 nr_page=
s,
> > +                                               u8 nr_incomp_pages)
> > +{
> > +}
> >  static inline void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg,
> >                                              size_t size)
> >  {
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 091401cecf39..2236f5ba6304 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6345,6 +6345,23 @@ bool obj_cgroup_may_zswap(struct obj_cgroup *obj=
cg)
> >   * compression and storage in zswap for this cgroup to go ahead.
> >   */
> >  void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size)
> > +{
> > +       obj_cgroup_charge_zswap_many(objcg, size, 1, (u8)(size =3D=3D P=
AGE_SIZE));
> > +}
> > +
> > +/**
> > + * obj_cgroup_charge_zswap_many - bulk charge compression backend memo=
ry
> > + *                                from compressing a batch of pages.
> > + * @objcg: the object cgroup
> > + * @size: total compressed length of a batch of compressed objects
> > + * @nr_pages: # of pages that were compressed to store in zswap
> > + * @nr_incomp_pages: # of incompressible pages to store in zswap
> > + *
> > + * This forces the charge after obj_cgroup_may_zswap() allowed
> > + * compression and storage in zswap for this cgroup to go ahead.
> > + */
> > +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t siz=
e,
> > +                                 u8 nr_pages, u8 nr_incomp_pages)
> >  {
> >         struct mem_cgroup *memcg;
> >
> > @@ -6363,9 +6380,9 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *o=
bjcg, size_t size)
> >         rcu_read_lock();
> >         memcg =3D obj_cgroup_memcg(objcg);
> >         mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > -       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
> > -       if (size =3D=3D PAGE_SIZE)
> > -               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 1);
> > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> > +       if (nr_incomp_pages)
> > +               mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pa=
ges);
> >         rcu_read_unlock();
> >  }
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index df59ab0c1029..5e1fb5624ffb 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -491,12 +491,12 @@ static int __must_check zswap_pool_tryget(struct =
zswap_pool *pool)
> >  }
> >
> >  /* The caller must already have a reference. */
> > -static void zswap_pool_get(struct zswap_pool *pool)
> > +static inline void zswap_pool_get_many(struct zswap_pool *pool, u8 nr)
> >  {
> > -       percpu_ref_get(&pool->ref);
> > +       percpu_ref_get_many(&pool->ref, nr);
> >  }
> >
> > -static void zswap_pool_put(struct zswap_pool *pool)
> > +static inline void zswap_pool_put(struct zswap_pool *pool)
> >  {
> >         percpu_ref_put(&pool->ref);
> >  }
> > @@ -1603,55 +1603,60 @@ static void shrink_worker(struct work_struct *w=
)
> >  * main API
> >  **********************************/
> >
> > +/* Functions called by zswap_store(), that operate on batches of pages=
. */
> > +
> >  /*
> > - * Store multiple pages in @zc->folio, starting from the page at index=
 @start up
> > - * to the page at index @end-1.
> > + * zswap_init_entries() co-locates most of the zswap entry fields' set=
up under
> > + * the assumption that all phases of store processing will succeed. An=
 important
> > + * marker to simplify catch-all cleanup in zswap_store_pages() is done=
 by
> > + * initializing each entry's @handle to ERR_PTR(-EINVAL).
> >   */
> > -static bool zswap_store_pages(struct zswap_store_context *zc,
> > -                             long start,
> > -                             long end,
> > -                             struct zswap_pool *pool,
> > -                             struct obj_cgroup *objcg)
> > +static inline void zswap_init_entries(struct zswap_store_context *zc,
> > +                                     struct zswap_pool *pool,
> > +                                     struct obj_cgroup *objcg)
> >  {
> > -       u8 i, store_fail_idx =3D 0;
> > -       bool ret;
> > -
> > -       zc->nr_pages =3D end - start;
> > -       zc->folio_start =3D start;
> > -
> > -       VM_WARN_ON_ONCE(zc->nr_pages <=3D 0 || zc->nr_pages > ZSWAP_MAX=
_BATCH_SIZE);
> > -
> > -       ret =3D zswap_entries_cache_alloc_batch(zc, GFP_KERNEL);
> > -       if (unlikely(!ret))
> > -               return false;
> > +       struct zswap_entry *entry;
> > +       u8 i;
> >
> >         /*
> >          * We co-locate entry initialization as much as possible here t=
o
> >          * minimize potential cache misses.
> >          */
> >         for (i =3D 0; i < zc->nr_pages; ++i) {
> > +               entry =3D zc->entries[i];
> >                 /*
> > -                * Set pool_idx before the xa_store() below publishes t=
he entry, or a
> > -                * concurrent reader could resolve a stale pool_idx lef=
t by slab reuse
> > -                * to an unrelated live pool.
> > +                * Set pool_idx before the xa_store() in zswap_tree_sto=
res()
> > +                * publishes the entry, or a concurrent reader could re=
solve a
> > +                * stale pool_idx left by slab reuse to an unrelated li=
ve pool.
> >                  */
> > -               zc->entries[i]->pool_idx =3D pool->idx;
> > -               zc->entries[i]->swpentry =3D folio_swap_entry(zc->folio=
,
> > +               entry->pool_idx =3D pool->idx;
> > +               entry->swpentry =3D folio_swap_entry(zc->folio,
> >                                                         zc->folio_start=
 + i);
> > -               zc->entries[i]->objcg =3D objcg;
> > -               zc->entries[i]->referenced =3D true;
> > -               zc->entries[i]->nid =3D zc->nid;
> > -               INIT_LIST_HEAD(&zc->entries[i]->lru);
> > +               entry->objcg =3D objcg;
> > +               entry->referenced =3D true;
> > +               entry->nid =3D zc->nid;
> > +               INIT_LIST_HEAD(&entry->lru);
> >         }
> > +}
> >
> > -       for (i =3D 0; i < zc->nr_pages; ++i) {
> > -               if (!zswap_compress(zc->folio, zc->folio_start + i,
> > -                                   zc->entries[i], pool, zc->wb_enable=
d))
> > -                       goto store_pages_failed;
> > -       }
> > +/*
> > + * zswap_tree_stores() stores the batch entries in xarray and adds the=
m to the
> > + * zswap LRU list. If an error occurs during xa_store(), localized sta=
te
> > + * unwinding is done to erase prior batch entries from the xarray and =
delete
> > + * them from the zswap LRU list. Remaining batch cleanup occurs in
> > + * zswap_store_pages(). As batch entries are processed, we maintain ag=
gregate
> > + * statistics to do the accounting in one bulk operation.
> > + */
> > +static bool zswap_tree_stores(struct zswap_store_context *zc,
> > +                             struct zswap_pool *pool,
> > +                             struct obj_cgroup *objcg)
> > +{
> > +       u8 i, store_fail_idx =3D 0, nr_incomp =3D 0;
> > +       size_t total_batch_comp_length =3D 0;
> > +       struct zswap_entry *old, *entry;
> >
> >         for (i =3D 0; i < zc->nr_pages; ++i) {
> > -               struct zswap_entry *old, *entry =3D zc->entries[i];
> > +               entry =3D zc->entries[i];
> >
> >                 old =3D xa_store(swap_zswap_tree(entry->swpentry),
> >                                swp_offset(entry->swpentry),
> > @@ -1663,13 +1668,11 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                         zswap_reject_alloc_fail++;
> >                         /*
> >                          * Entries up to this point have been stored in=
 the
> > -                        * xarray. zswap_store() will erase them from t=
he xarray
> > -                        * and call zswap_entry_free(). Local cleanup i=
n
> > -                        * 'store_pages_failed' only needs to happen fo=
r
> > -                        * entries from [@i to @nr_pages).
> > +                        * xarray. Local cleanup in 'tree_store_failed'=
 needs to
> > +                        * erase entries up until now.
> >                          */
> >                         store_fail_idx =3D i;
> > -                       goto store_pages_failed;
> > +                       goto tree_store_failed;
> >                 }
> >
> >                 /*
> > @@ -1680,22 +1683,10 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                 if (unlikely(old))
> >                         zswap_entry_free(old);
> >
> > -               /*
> > -                * The entry is successfully compressed and stored in t=
he tree,
> > -                * and further failures will be cleaned up in zswap_sto=
re().
> > -                * Grab refs to the pool and objcg, charge zswap memory=
, and
> > -                * increment zswap_stored_pages. The opposite actions w=
ill be
> > -                * performed by zswap_entry_free() when the entry is re=
moved
> > -                * from the tree.
> > -                */
> > -               zswap_pool_get(pool);
> > -               if (objcg) {
> > -                       obj_cgroup_get(objcg);
> > -                       obj_cgroup_charge_zswap(objcg, entry->length);
> > -               }
> > -               atomic_long_inc(&zswap_stored_pages);
> > +               total_batch_comp_length +=3D entry->length;
> > +
> >                 if (unlikely(entry->length =3D=3D PAGE_SIZE))
> > -                       atomic_long_inc(&zswap_stored_incompressible_pa=
ges);
> > +                       ++nr_incomp;
> >
> >                 /*
> >                  * We finish by adding the entry to the LRU while it's =
already
> > @@ -1711,17 +1702,87 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                         zswap_lru_add(entry);
> >         }
> >
> > +       /*
> > +        * Each batch entry is successfully compressed and stored in th=
e tree,
> > +        * and further failures will be cleaned up in zswap_store().
> > +        * Next, we do bulk accounting for the batch: grab refs to the =
pool and
> > +        * objcg, charge zswap memory, increment zswap_stored_pages and
> > +        * zswap_stored_incompressible_pages. The opposite actions will=
 be
> > +        * performed by zswap_entry_free() when the entry is removed fr=
om the
> > +        * tree.
> > +        */
> > +       zswap_pool_get_many(pool, zc->nr_pages);
> > +       if (objcg) {
> > +               obj_cgroup_get_many(objcg, zc->nr_pages);
> > +               obj_cgroup_charge_zswap_many(objcg, total_batch_comp_le=
ngth,
> > +                                            zc->nr_pages, nr_incomp);
> > +       }
> > +       atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +       if (unlikely(nr_incomp))
> > +               atomic_long_add(nr_incomp, &zswap_stored_incompressible=
_pages);
> > +
> > +       return true;
> > +
>
> Can you add a comment that we only clean up the current batch here,
> and the clean up of other batches in the folio are deferred to
> zswap_store() (or whereever up the stack it is handled?).

Sure, will do.

>
> > +tree_store_failed:
> > +       for (i =3D 0; i < store_fail_idx; ++i) {
> > +               xa_erase(swap_zswap_tree(zc->entries[i]->swpentry),
> > +                        swp_offset(zc->entries[i]->swpentry));
>
> xas API?

Sure, I need to spend time on it, thinking best if it is a subsequent patch=
.

>
> > +               zswap_lru_del(zc->entries[i]);
> > +       }
> > +
> > +       return false;
> > +}
> > +
> > +/*

