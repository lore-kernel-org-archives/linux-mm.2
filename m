Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B882CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3488E0010; Thu, 16 Oct 2025 02:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A728E0002; Thu, 16 Oct 2025 02:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969EA8E0010; Thu, 16 Oct 2025 02:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84BFB8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:43:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33E15B726C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:43:24 +0000 (UTC)
X-FDA: 84003035928.04.8977D2C
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1606E140007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:43:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F8i+5ItO;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760597002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uMB4WotgJMB2B9lnpkEFb08bYlsI5GtgT/xlgxrxy7I=;
	b=6faSLBuRS+2c6ucDCo8HiyljjYf8XadCQUPiUI6eayjLXvLWsRhf2jx9tRAwBmjs5zm5PF
	T+4YqB/guN9My6jYIkBYgyAfyMvKmMOgn0i/C7LVsYx+2s7edM8saw37yDIy++NfDlLhSl
	jCzD+9QEIfH7Un8+zXlbbWLHSA1rOPg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F8i+5ItO;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760597002; a=rsa-sha256;
	cv=none;
	b=Ieom5K8rRVn4+lcqZuT5zL34zGNez6W19OGojmgGZFiID8PPaWmh+w93HO3FYH0gaf84EM
	2unmqs20iAzbUAUAUBzdC2XkdD8kZ0+whtz7xNiwW7ZJJ+/420xiHeVG1B/gz9bQmKwL9s
	gICLZ7TqIDhjMx7QM5gcAac5YA9gFDc=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-74f6974175dso4174507b3.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760597001; x=1761201801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uMB4WotgJMB2B9lnpkEFb08bYlsI5GtgT/xlgxrxy7I=;
        b=F8i+5ItO75BWM6pUSSiREheKsoJ5/876fhz0A5oP+1W39OdpUxYOk1H7FNoZjHk1cG
         yMxeVhribFxCs4qua+Mt69Ww5sgTfQokgSDSKyaVs3eUEDXUaaKEuwrO4IFKjPXWBQoI
         Ohka/e+mHW+vTnX/jaQ+l6XQFO9QGSy+5L8hAFlr6LvxKLpk0kHJHCMcPgWxc2Zji1dt
         TjGEtpDsAsAoYAB2jU7F04wMx8cQ3fZO6F6QA3hr+jOARLL25NsVm/YKXSotdmp4oL/G
         v0T4dlpMl+E/Kys3ak+PgLjn4Lmhj1hScFdkhiNLcQYACmrV3Ei7fsLNTuL0MK7CI1Gi
         rfVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760597001; x=1761201801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uMB4WotgJMB2B9lnpkEFb08bYlsI5GtgT/xlgxrxy7I=;
        b=giGfVqP5TEPTRkrtoHq8Ax7O/xW3kDODD9WOLUpDTEDsWdNJmoicKKwo6IVHmxnkqT
         B67HLj8kMRnA4LR3hTsULUgrHU0/f1KYa2kPKecyYtEt1kcLro+XmvDHaOxGgbefzXkv
         6cn+9zNutav/UmFt3sjyypsAccrazJ7KWOiV21iv/rmbTi/FV2oMkAmkRgXyfX8Z4uq0
         1l8ffnyk5UeUMAhxxDhMzqTrwNnnLIvvL62dkctuUnZnKz0oCioyNwRgprkoQGm+Ps3P
         jypGwY1YSJwpuyVDLd5iZGyIIyiLdNRC5S4KVvl+xj8AmZOiIVYPMKN1YflKr3WdgPCx
         cZYw==
X-Forwarded-Encrypted: i=1; AJvYcCXmiU4l9FG2EdDzS9y2e/T4FbS0zyxBRKedloIkx1guOShxnw84HfDatlPAYlaaCpzXHehVAbpENg==@kvack.org
X-Gm-Message-State: AOJu0YywI83JVmth4w7URU/ef+7QuMjappokipjV5oibfdZ8nGUqCZd9
	J55yOvNzL5JWZl2EYLAalz1Xd05GDtP02mfeFc9rdpUPNE+vnwFylowwUxiJYJ8Fnm1fnTltuEp
	Pa3EHgPbKF1ep6lHwDJA6r5k2b4JlYY0=
X-Gm-Gg: ASbGncshihfN781zs64Jl5aotuIlnRrI56C6B+jKF5luU9ANrYFsLCSouk2kH1atTfb
	QW23KjnXyjz80u8c9NSAFTwbcM/JRQjXYI9eyUoINKbTHqjgQVt5JCZL9egMOmxeINd+uOKnlWL
	tGv6tVOWXIwBOQx1LH21s2PDDk4Oahsa0GwiZnBRWpaJ3es/aurfMWKQ4WREi0EWe8TYebjN6JL
	OrvDRZNb79zCyD+hv+t8uF3VMlQ+7gDTrloZrdd5oyKrlHAsDgMnHgm2iI4F4ZTyjkG5DuX
X-Google-Smtp-Source: AGHT+IHt55ghDR10vYNQX2CPbLTIfDAHnS68w7Y8BthdNCorUSQCnA/OvTwgVVZCE/MUA6kZegO483oB/tunMLgJW3w=
X-Received: by 2002:a05:690e:130e:b0:63e:1138:e0a8 with SMTP id
 956f58d0204a3-63e1138e2a7mr167963d50.14.1760597000939; Wed, 15 Oct 2025
 23:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251015141716.887-1-laoar.shao@gmail.com> <20251015141716.887-7-laoar.shao@gmail.com>
 <CAEf4BzZYk+LyR0WTQ+TinEqC0Av8MuO-tKxqhEFbOw=Gu+D_gQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZYk+LyR0WTQ+TinEqC0Av8MuO-tKxqhEFbOw=Gu+D_gQ@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 16 Oct 2025 14:42:43 +0800
X-Gm-Features: AS18NWCmAzqewH7c8lKNSOM6N3YN2rFyfdEP9RCIkzoVhyDUX8WzpaYI1pA7pxE
Message-ID: <CALOAHbBFcn9fDr_OuT=_JU6ojMz-Rac0CPMYpPfUpF87EWy0kg@mail.gmail.com>
Subject: Re: [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as __safe_rcu_or_null
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	rdunlap@infradead.org, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1606E140007
X-Stat-Signature: nga55hry9kurgbeogiky1ha6skudarf1
X-Rspam-User: 
X-HE-Tag: 1760597001-241573
X-HE-Meta: U2FsdGVkX19xB2rczZ5HGqWaOUvcyY/d2JFiJXqRnzlLShjM3ZL5S/o4hYEDzDy9H3ECAO7EbH5u4pfJiC1Ju7vVI3k9D0bcehNJk0jONOo6TmIVpPBSMh+hoGC7Dh4wKWKWXu6O6AZmYh0IiNB6n369v3zXDhVcZYT61vzeitlx+1yYktUaF0TP+EgZVdq61tc/Q9xblzEU1H018s+hU8544TtmnF5csVa7twhIJBxndaPZA/y8JL7GWwhXh6U53WwU8U756LLyOLjF5GNiD1oSe3E4o9LWkiV506yTixBGXlXGm9FzmxQpRtFQj+x2OCuy59SLHuuO4ti9t2aErwg01JiwrP6fg+FJO/CIK2h7urVOXNoVhvK45PMxEOD97aBjzAR4Bi4+64HohhIbn8Nf5AM/VrkzCvIqsOZmlRWV1tDjVLh2VvTJG5FYSLKuizndVK+zcZb+sb4F/Efh0TbCNJz+dNKPrIchL2CoOjEZfS4zUPrHSWgMmcwG10EYpT3xCJIyHprVxfmqzcFxO3mto7oNfkoNDWR01iYVyG37ODk4VH8tlQUDIyoqYNm0fx9WiVgUfr5cqGJRI1x8A1jEt0LuDUYmYxYiijn1RuZ5NHmRCp64d6jKDSBOF4WpZJAAFVqiuTLeWHtdKyyE5XRnz5opdau6Ld9FYOY24HFQ9WPCIUwlB+gxbJhaZt/EXoYoGsukncgvRdzqu/CEscz+Buv6q/SVFGuMMMFHO2k8B/Ul/rZnIE6KlQhp+2zOTkgxOBOWq858fs8tZi1EsNIJSpwxuzNAg8ELYgzaIZFhFc70Q9yYUCLc/hN/CBrJgggd8xcFVgoZFgJMBKa+pDcMtUMg+jrfiAB1GhHfN4deQwtTnU+S7vw6J2SJCFZS9xor/waw1g6KJ5OvWKSshmG35SCcMP1/umGWswVoMVe1rl1Vn8Y9/O6d3kxTFkR5cMzgoQk9UgYUcWTB1lz
 bk1CAIal
 8Gf/QqykmerRcOMvTfqVIweFKmX8A7JePnPX61r4gI7+SCLfo9RofdqsCsd0HLdHQNCe2aMMeRXIt06iaLZjfkIsi9nRVZW5qVS/g83bascwXGIBx498v1lBw9l0Nfe6fT24MFIFkNgPa4u+4Lbhgynbi1QK37GdwCfmYK+qdRKwR/nsz8JPb8nQZdhZ1Iy+iuAP2gchYM7VODi4wDFzSm7hbTT3+pcGoo2GL8Uh7vRiLBA1rInZ7r+pGyj1+f6a+Ri+x+J7SU/8hirVbr6HD25eZ+jpW51tNAMSqmUKtIa+fdYJEpVQgsPcau/5DMcB+I+bU/E93tIt9o80KST/W8XsNC6ZcBHGa2Yxo37XbFREW31ZewblmMZNWit1p4rKiom3oxJH2QF7dC7YejC7DYGNTGcY1xKcre9Lv3HvcZMBVfG4RdB5mGGm/5WYsWkRLvQNnb7I/KJYQpGs/0TBuR/gD3HlYnPMay1cdII4TLKcc/zhTU6Ey/ZNUKvh3H/Mow61nFCBNtLQjiFMAGWHIdy1ORNepit2jfQKPqQZCievYqTJ82vwFMTNq/+AD8EcBOJXHJK6w7MhnzUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 12:36=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Oct 15, 2025 at 7:18=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com=
> wrote:
> >
> > When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
> > owner can be NULL. With this change, BPF helpers can safely access
> > mm->owner to retrieve the associated task from the mm. We can then make
> > policy decision based on the task attribute.
> >
> > The typical use case is as follows,
> >
> >   bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
> >   @owner =3D @mm->owner; // mm_struct::owner is rcu trusted or null
> >   if (!@owner)
> >       goto out;
> >
> >   /* Do something based on the task attribute */
> >
> > out:
> >   bpf_rcu_read_unlock();
> >
> > Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  kernel/bpf/verifier.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
>
> I thought you were going to send this and next patches outside of your
> thp patch set to land them sooner, as they don't have dependency on
> the rest of the patches and are useful on their own?

Thanks for your reminder.
They have been sent separately:

  https://lore.kernel.org/bpf/20251016063929.13830-1-laoar.shao@gmail.com/

--=20
Regards
Yafang

