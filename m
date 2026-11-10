Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1532606A765
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pAhxQpXt
Received: by kanga.kvack.org (Postfix)
	id DF85F6B05B1; Tue, 10 Nov 2026 08:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0146B05B2; Tue, 10 Nov 2026 08:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF0C6B05B6; Tue, 10 Nov 2026 08:41:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5E76B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:41:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 330B4A090B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:41:25 +0000 (UTC)
X-FDA: 85419321330.19.295FB84
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39BF0140008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:41:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pAhxQpXt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794318083;
	b=2Ve+zmb5onms0SJ4JQ/MCuJZKP4WDhGF54Cr1XGQ2FkhHGeR0i5N02/x/56IMnfFZCbRji
	2UD0v3Rhbrj6vohnY2IwdmJ6Ft4gLo1M2yjEXynxEZL9D8zv4sQ5VFFIcrxUCFvtlagJh+
	VPYmqpSAuZyGjU1fDR/uMjk80FRa/0A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794318083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tBk3fV1ajINvotJenztWjVRGM1U3hU6xKj+PJFM2C0=;
	b=JwAR3BwJIbmEq8A450oSLDvB90Oq+I6z6qMt0yWivAPSOSEw+rExiAgERxoIhDcFS9+9v4
	flKFXI+XeV/eS8+aoTiPgIa00YlTYWxf4c3TH6fWS72Ll/T5LBpiaACnDr653AQwrrYxDD
	fb65bVEDYQL4odVr8kjCXjssC+ydi/Y=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=pAhxQpXt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-67bfdab8f20so1258074d50.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:41:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794318082; cv=none;
        d=google.com; s=arc-20260327;
        b=gIqO1wY08tdJy9Jzr8HUf8TowoenVNHW9kfKLa+yl1o/eCTWFPKBQOj5MtAx+ir00i
         fPp/z4BsMbLHMLpVLntrnBWWQjtFNpx6+Xr8P0SJ8+vrKDdME+qJRUK5N2yjxSlFngUf
         FSARpUa/xkltiShOL174AiIFXiU6ow0hv7hIsXa+gg9c2EKXkg61pMuwOpxH/Qvd5enz
         gRIWBZdXEmIyV4iTvPl6iD+SEIyUXgiU1+rcy0umCKq9S7wwwwt9gpZYuz8QyHvl3WzM
         kaNwRJloadDeRINYCo2ebTosyQhVkgma2bHh78DMX12NvJD9PoTMDN685+WjaugplC/U
         FJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6tBk3fV1ajINvotJenztWjVRGM1U3hU6xKj+PJFM2C0=;
        fh=dme05l4dsFanYfSguKNQW7jPNbNn0WiFFIaSMYZZsM0=;
        b=GFsj0C8R4wHsO69yZ+FTCc7rbo9e7aOXec685ToIUsZlkYIhOuhje/vzdrwfiW6b3C
         Zj0+Mj6xzpRt6yC1cam33g5oYu6Gwq8kfURbhRQFZLuww5lU8M+gJqx1UXXWzbAvKEXc
         tSNvzq6SyXY73OeaaMSGg20RmJrbA46RscCVOKTHcuQSbJTks15gBn31ZhMfGokwl48n
         cnerMU6lvitB4DR5Q1x2aOkzE35m8NLijsy/xb8Uu8I0u+9FyxHXoi8fD9gtktRNyCpI
         KEmDULjKMGrt8VY7ommpmdAQozmJWeuvNcu+Uh/kAVmDqaDAT2jMQQfWFi8iXqmHlN7C
         ljzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794318082; x=1794922882; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6tBk3fV1ajINvotJenztWjVRGM1U3hU6xKj+PJFM2C0=;
        b=pAhxQpXt9v7Zz7DV4ObBBVzNVnPvquQ0c/5yAU/AsSL22d+44tqYQga4ZcpsqptUuX
         08eFANWvtuaBa5dVPPajHKCA3Dz6dCJTGpksYSWIn0us1IoTisKkuGmPosqj/9tLqN/L
         qiqmb4Fo2ZvVs6rj1zbR53IclPn9S9aUJxsIcWviZx4yxWQTWJisBZ2etXO0vq8jztmG
         HeVAriseJk8isCTTdIojClPHXtK0UKf2cY09tu636hJmlvPAYCBARAQL/MvhNUJSOIp0
         rEemrFlyiqm8GyoVcZT84RrCtLcSm8JSa+HZG/ZRYinLGLr9WEte2Eus4K0s1HdkgECk
         s6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794318082; x=1794922882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6tBk3fV1ajINvotJenztWjVRGM1U3hU6xKj+PJFM2C0=;
        b=VnJ1RmpIbFgEPuAErjmst5r2r3BmUmkFkW0irvZcAyqgYRVyU5dIOivMi7eyz2L19V
         4FATya6TmrwgtQtV270uIPm6ICXqDLm+JPXBroA22XWolfsuPC/RRZoXVl9oV75lTRnA
         T4mRMb+3YiZCo/4BciKhsfn3+Depx9k+st5kkYCFaZ5WcB2PPFOPjBqDxZeCHKlwfg5X
         hSVbiOco7mIP353wlzCX7mr58/w/Q8SCxlZrY38NfC+N9ikfisrvbLiEKRmiBXedT4Rg
         QFWDLCZxHxZfI9OiV52aC1A3OXmJl08bkbgoyF3lmbaS3bRqtvqWFovtF+fWXB/9XEr2
         ivsg==
X-Forwarded-Encrypted: i=1; AL+hErG0GfWogGx0EPVOeJBM0iLEObrR4pxKEaCzE6zgsPHJEjFtgT/HGVQl1paQW1+JJ7L+lkLNuDlFmw==@kvack.org
X-Gm-Message-State: APuU4Z+A07bPFijwjLHJsId/OQkkUUnZuDlb18rR36pUMBDigOYTUzI4
	PUK2nvmktuBb0hr+MFiBIKv0LtRcfjCt507/QbdfdfhvKepqCaM0RZlQCu4RPevdyd4P3y8AUmH
	ZwUhpV7z7ENofPdcsAQZDF7F1EzGCxRo=
X-Gm-Gg: AYBFou0gvnl2rYZtbuIdNbbdIPMqiVWpxTUEezPONN+DATVjLJHaS6dcWRDvzRbiSYV
	SP5VypqZfzhis/k2tb/9UNDW2SofCFxrNyhP4GAUcquA3bIVfuSf+v8HAPnvsHlaBEAhs4cEOSt
	T5kaFnfAllJN8Owj3VGkognQxRc5SHO1sRu3rHq+S0XBdIntjXRXtKR+ztGkxJpHTvJ3B8Nqn/x
	aBPbEq8UtZch0L85baIvWKTRsXsVPv9PHCfcZ+u0v28mgCcgeX5iyn3Ukw6cMq0gs6iJE2EQc17
	rp269CWkEUcY2Z5Oil5e3emVf5zXbuJryl5ri49ll65cn6OGyueSQ5Vd8TPSKczu6OLHdx1Cucy
	knSg6DFh0LFGM1/TJvh0Dc3odVEuSUQSysAagQoYc0Le4fkBlNmPlmueQK2tQVARmy2E=
X-Received: by 2002:a05:690e:4803:b0:67b:e431:4a0 with SMTP id
 956f58d0204a3-67c5674f7e0mr833246d50.52.1794318081887; Tue, 10 Nov 2026
 05:41:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104144753.2266231-1-ekffu200098@gmail.com> <avMdQuXxfqMCBbBA@thinkstation>
In-Reply-To: <avMdQuXxfqMCBbBA@thinkstation>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 10 Nov 2026 22:41:10 +0900
X-Gm-Features: AclHuK9r5g8a50g69OltVtd5PYl6bmln-x3U9YjttRRW4R25gSMvB0TudlcOIuY
Message-ID: <CABFDxMHZxHHdMc8a_DAS8yp_yT_BoNeCkRq4JPEKcgj0JcPYTg@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: remove outdated comment in create_kmalloc_caches()
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Hao Li <hao.li@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 39BF0140008
X-Rspamd-Server: rspam12
X-Stat-Signature: ebw358n11wfp71ws1dio6dfm5c6ke5h7
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794318083-322069
X-HE-Meta: U2FsdGVkX19HpNaIzsur9ixoL2cGC7EbJ2DUCm1Vj4c9HosBEp+C7Q2lqm4zIQNuAH0NXWxqQLsy3ncd9ccx5wzVYUJiAV/wxs6dfbd3rDLe973CC31uSi4tyEM+RIhbyeGx5XzsjV92jI8fQ1pPuHSsxDs7J3numwuiZUSet0uNreepmvv1v9ueMN0X+IY4MtFH4X4pPqdyLkdHi/WlGXw/R8LJpzwmaJa3961JjNA5IyK3ic0OmwBZQXQpzPGHpdMYHZs8F/7QcSm09BF0ys/+3HuxfiaQjuvLcuce4/jwdcxqcIUINVMInalA1YHDxTUxzvvdGZEAtcTjZmOV50S30vGGDkMwWOD1cMBnBk0HJdpKANfQK5IL3+6wLFTZrCfZ387gWckb23Qukz8K4/ZIiSoaP3gLbwqstpdtXXXSXOy5qHJlq+ds7JSCsUxdiM7uwpyWaihk68PSXu4seGEEx21Wx2UZaVfO+LH+E0kQdHR2HgA+S/orA4+tPk1bZendBLfbPF+9JvAn2uZ5mh4GjS9/HPlUmdc3ngCBoTEl6pF6NJWZTuNo6uVLlZOQIavz1xkLZbdLhUF+DQ42swlPA2yXgSobH8EewLoYUQUqzM4EBv8Zlag4E2kjYh2PV7pTHmq6a2srTE6NZtmqQm92BNiPngZX2dKQMrGf5EMmGMYBC0joxyHb2d+Xy9FIID6Hu7LvfDeB4iRwtaSXoHtEBqysl+h4EJqYO6wDf5QmKavcnMRSZKUFgdIjvojp8dDZDmv9RDDdJxjrvVmm/KdfnHQ4aVM9CqyOjH5QSL3+fMOpHCBh5YUm8c4RMY4EjXKcCSLelIWk0lPNnA6FreOw1s6x/4s+JuD2uy2OS8NZBFfmHP6NYGB69z6qTWuBnyFwUvrL83mEVFB1UwwDazDi8TtRS3FvLoiLdomc2GwS9XyFP+CiaWnRb6nhbXh3zbhWV4WX1M2wWpgqLCW
 /zuO1KpR
 EkVrP8Tq+sDuI0OWaxg6bX52AZSATL4YUaJXkxRKhy/SLz+YDqBnl13c/58b/23tkUMw/S9V8TDBDTs/s5VQgS6uN/wgpFAmMfg5s86ffdg/66JMrJnopFYfBAAzvJwXGqnOVOxEpCy5FzoQtroKknsI96jiVIsAfBtZA3gbhsJSHHTmMACpruO2va66pljJdGMgTM8j0m/kiHqD+kILATZnKzptP+l+QVtk2pi1CpXxEYPZDwMsz/tGLm+VUUY2N0vuLPDI7OIxWnWezKCeh8COMwpBi06w9JJ6Nvlx0ahwczDecWl36iFV5ZA6Ebcwm+b9ID4zcTfCsG1F969SO3J/t8n2gyXfQBVXQp6HCPs+JOazbJ5cX6Bqv6AQIpvl17+eRJ6qfkOZwInREjQPpEfKXHsdyhL3WrKMSS+LpXm0qRAJdCVBJ+XUlUFrR1W4AAW4HxingvowRMt6JGERy3kcyj5N1oJrY2RAZ+XvHB/bRAUyVoSx0ayQAsSB+TBgeH5Ra1ckhmJU25lMYck4JukTUYBycf95oRsdQXlP5QSGzikpu0R5I58sKEUAm7HkPAlhBC2V5TKxpMuy+pvzwq1ZOACKoWiFOPnQfMU5mKlPNclrmXZer4WW13rPBm+/cghFrXj73Bf2z45E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

2026=EB=85=84 11=EC=9B=94 10=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 10:37,=
 Harry Yoo <harry@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On Wed, Nov 04, 2026 at 11:47:51PM +0900, Sang-Heon Jeon wrote:
> > Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
> > removed SLAB, no kmalloc cache is created before create_kmalloc_caches(=
).
> >
> > So remove the outdated comment.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> >  mm/slab_common.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index e66c0778ee98..c4a386f0dd90 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -1029,9 +1029,7 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_typ=
e type)
> >  }
> >
> >  /*
> > - * Create the kmalloc array. Some of the regular kmalloc arrays
> > - * may already have been created because they were needed to
> > - * enable allocations for slab creation.
> > + * Create the kmalloc array.
> >   */
>
> LGTM, but maybe let's just drop the comment?
> The name "create_kmalloc_caches" already covers
> "Create the kmalloc array"

I don't have a strong opinion. I'll address it in v2.

> >  void __init create_kmalloc_caches(void)
> >  {
> >
> > base-commit: d15d7703166daf7bd62c844a3cb1b3a6279adb4c
> > --
> > 2.43.0
> >
>
> --
> Cheers,
> Harry / Hyeonggon

