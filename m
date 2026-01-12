Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9041ED26D97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CD96B0088; Mon, 12 Jan 2026 05:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAE86B0089; Mon, 12 Jan 2026 05:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC7C6B008A; Mon, 12 Jan 2026 05:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBBA6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:20:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FF8913BD91
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:20:29 +0000 (UTC)
X-FDA: 84322917378.24.14233EE
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D037180007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:20:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J7yCAcLJ;
	spf=pass (imf24.hostedemail.com: domain of smostafa@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768213227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K81YAnOXZO5D4mYdCuhOxp178GZoWafY9YiJgFtn31w=;
	b=t04cFXpWYpJlNun3FGl2hm4G8dNy1mLMKBSo0xGn+v7jt/CizShOrtvzG0bpq2bLzrqgFB
	OyxpPQDn3wc5SrBbRGRfhVkRMX0rUcX2x6fSoE5BtIVJhZGQQ3lch5Cq0SvMtUKEuFqwyI
	jk6AebEy1ylXO81YqGYzyBwt2or0Si0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J7yCAcLJ;
	spf=pass (imf24.hostedemail.com: domain of smostafa@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768213227; a=rsa-sha256;
	cv=pass;
	b=kp6D18P+zuUHt4uqvrpa6mx90uh5V2npWoxQgo7BIXgErUsb3FpV9ImgYFNl6djlv7UqJH
	E5LhNQA2EayoWrQc6DOo6ReqG9BUlIS3Lc7NrX70ANEV1R4HHCnVEF28CF1yIJyCseIkhB
	fu0mxU8DZ1zM5Fm1uAe/FA4CkdPnIHE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ffbaaafac4so858361cf.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:20:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768213226; cv=none;
        d=google.com; s=arc-20240605;
        b=J22SPqd1K0Lf1m2/gdq2zT7ymdNDNLLK4yF83pKl8/h7ND0tB1rDePEPwNJjkO7UE8
         M515oNnTXo4SSa/L1fTB9F7iy9tpB2LsZpA3ARbHts8wKDCRRHdNJ0BRDe71W1QAAo+7
         zLZEvpDy0oiTYLP1SZAqTvN63QtxWZ4Ie232uc+Z0ADT9a+2sYEfML2ig31p5nvX/XVY
         1tqnFLNuZ9g8lobM/F6R9K4On1Kd52yhOTeH3NYQ7xPsBjXRRzNiY4L/3zVx6MZZaxOK
         Cp88dpaXxhBZFXGbbkeZ0yXWKIwO8Wf+YNV2etJ4aw2MZt0jJLpBf+1cTJqGhnTq90D5
         Aubw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K81YAnOXZO5D4mYdCuhOxp178GZoWafY9YiJgFtn31w=;
        fh=gmy3vim+lyLQAZHW0CtXh7r3TBmX5Emig2GMVX6Hyb8=;
        b=WydqBPSViOHURnGFLg7Y8d/YAk8m/JmI0ytnLpBPBevfAwBQAf6j0jmYXVyEPUQQ6W
         sVEX4keVTiN1o1gzYrPZWopebLkjohNxHhBz79UMlEMTSP+5m17+TeWdxUf4QGm5gleb
         zl6mt27HCK5ZgwEH+076y0gasLNwAHZbwGDU5k0zRr4GaaCFX+rvUNniGt0Lmi/mu9JR
         AUZsv/BlVomJCHsedPc6C57ppvF1Po3fvb4g+c74jxxHLaGt7jAZi/wKRppwD65uqLiw
         xMunHq6XLRdYdYNsIwIFboGTbiTck+VqYs6OXDdtLFE6cJc7f9Pe3T7boNa7mfUOU720
         V1zA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768213226; x=1768818026; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K81YAnOXZO5D4mYdCuhOxp178GZoWafY9YiJgFtn31w=;
        b=J7yCAcLJOIeZ7+IEIfdk6T2vw8kRHDc9jzhDgoiQ1+nPg5o6DM5Cl8MmP33CMn3ogl
         Fz7fknibA1kpBVQ7sdkAPFcBa2R5RPa214SOoDuvhhmKL1zbz270MgeeYYfWfaovIPZ/
         pY9iEHRVpSwvdEZwFq/gf1nopCaa65FNkXGHnr8ASk8K84Z6YKUnNkokq7kBXSHuXmN3
         NgGQIAHsa2pxES8Sivy4oOrJ/hyCYGI6/diHU5VNiPydbQBWnAuj8cxuDmLxHp5wveKy
         HFqUNIg2yqvrm9z9PHFBN31iz/JmAxFZtbAT4r9R4RatCfrmTnv/mbbp4YNpAQRC/kXO
         zKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768213226; x=1768818026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K81YAnOXZO5D4mYdCuhOxp178GZoWafY9YiJgFtn31w=;
        b=TgwEyri5L8GEj/iEJ2+hd11lq17Tb83GcH9N41IB5nWa0zzYh70qUWUFrjrFkvxe1i
         HfuQ0rq4ajntn2rojQVZKDZOrfeN5CdzY9LAMInjxbooPm/wRDODXVh1p37slFzVLmvb
         CNt28JOFesIoohByKYTLvCJD+FebVk7Mi2D9bC0WVZDVzW2L23+UeTyiCO2JrxRyN6iI
         NqNk3vtwJaGOzUGfIz9v4xvlk0PqAefnB2D6/1q290Zrt1uuQ6ncSDYi5uxP8SrSqKgy
         1s/HmzSHCAjODnox7lW+JSeX9AXrjzLsHwmMsLV3yqzSg2Q55tKZd1a0cIU6Q6wDJ62w
         VEgg==
X-Gm-Message-State: AOJu0Yyl2SDcAzraNGVuIu4rm4Ptid3vJSG59g2fLB/PvGU3q2EPI00o
	SeFLm3MPvV2Muf9wZiPqZnhFSnqOxgaoT51ZJkcek3Id5BD1//rKhe67A5EWyg5ImMe9R6/ut8Z
	33tJJmEyADGzXeiJECZu+uV+e8Jk1YXiJp3YV6fK1
X-Gm-Gg: AY/fxX72acfMI01V9zSjBm6P3YmlFU76PoREIO9HdPouNDqIeWY9jTuGdxBXqnjFUH2
	jufN68xRSfGZWRypq+pwY4L/6f5l8AXbiex8MyfN3k6TfoEuBZCqUWtxMma8UHL6D09d9yYEz84
	EQ+4DuDiDo6o2xmYR7J39OpvvxS0j0v/TZNnnUA2okFMwi/+GqXHbckETR6KlsOcB8QrRooP9nG
	7hAYClXH3b9zthS+o3FlgnFOkzGPxjqGk0HzqK0vqdzWM1g9peJ3vDSO9x5voj+uPEo9517k40a
	pPO5RgochLqusH8WBTz1eZuUgA==
X-Received: by 2002:a05:622a:350:b0:4ff:cb86:eec2 with SMTP id
 d75a77b69052e-501197697e7mr18829141cf.5.1768213226233; Mon, 12 Jan 2026
 02:20:26 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca>
In-Reply-To: <20260109195111.GQ545276@ziepe.ca>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 12 Jan 2026 10:20:14 +0000
X-Gm-Features: AZwV_QhBZadnJiyUFvTjuypzRI_tAKalJjtR7zhOZQkOyHcxgKv9-680wPv8WNg
Message-ID: <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5D037180007
X-Stat-Signature: yif3zrnqj8gy5esotmdozhypjogb9htk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768213227-75238
X-HE-Meta: U2FsdGVkX1+Tnyj87YVbtDIIh3p0HjjAIMN8lYl3HsVnywfsctaQgqIWXouZie911Im2f8dep/isjaTpUWqwRJs5ogulOlXHwdYDIh4sq9G4PTBYYdmUXUqxvHNbo+KNjSHYiayy6E5zDb9/goPioV1kfrG3uPblhYx+rIoo2gL+qJoEr53HY9VL5gVCGrHfhDgg+LZMGt4DIDS2eOkMaqSgm+AHNssPkN8HnA409CJenSLY0WTLJvRSk0PsWXmmQWT55lRkeIf2wWJurXXiJW6EtCpDsIPhXTOr48KwI7ZKwCFFdO6RpFIcpap/zcTm4YmqpWmTE3TofNYbdrD8egzCnDp/ZflGMEA8T/5EjcB1tskgChSu8ZWe0hbjNkEOC/WX8Ewd67+ebOm64KEEO7Y/7lqAJQ0dciQMtp48YhyeaVOGx0jw6Uz+QO355zsnJ4dwWWguf7vw9Bt2IBWXaEX81ltWQpDARktUcG+128LunUDl8VHgKwpiICbQ006konPBNYFg7X5hN4aGWVigHfSDayWcpxeuMlooCN/YzRDysmBrFEDi7ETpX36rbbAKtJ+abGYOP47IHVtQul1F6N9gboC8yVhyQn7cNkUUUVqrL9VDrtYCuHMDR0rVXZGcoSTGsNTZfK5K2dUMs28Lgeup1G2oqpv/TvAH5obViIrNivMMLV/McoS3Kw2EXFgITa4EHgzIsMLADYUCdxU3rMNuRjieLPl7faOCfcgY2hG2WPjEv4UjVOljq8Jv9CwKKUzI+P/o6Jnvq6292pKVN5q7YoBC0ibG6yUJrVeMg9uZq+PVb6hRP8an/vk0k4ws1eyO/b9ORvn+9n/91aDWXaekvkAUAfsyhHZCNmeG86/AG6jckrJTVG4ptc8pkkw9isNJQaLOCDoJcA3IcClqGKZ/iwjVNKf2rZCaAnaZa94V1sTbdsdzn+RC8Xv5argw7hZ1abHmjOu2dTQK/xa
 KrFDMNFf
 mbfNrmz3pPa0jcdeilA/6H2xSU6mZNT0gG7gJ6PTseN3qmJCfroPfF/Zzwkdd/ALgErSYVvOZ9sty13u9GKs04QoShyVmCMR4q3aBXByvLFt4N2AHOkiKhEUdqPEKRKet1tmGsCHK5VtlvEv+6ln2TkiIX+vHnbe7i5QGJgpnv2KB6lI18NT1Ysq9aykQ6klk0VSMl9Tsmlf+UNStPJ1tKwUQgTucLVrcJQukqj8AmPi+EJqnlcC4Y3aU/30TDi2U5uxsuBP+jOdoiCtRuON+7XIrkvG+rERhrwMwITE1SoTWFJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000135, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 7:51=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrote=
:
>
> On Fri, Jan 09, 2026 at 05:18:04PM +0000, Mostafa Saleh wrote:
> > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > +{
> > +     struct page *page =3D phys_to_page(phys);
> > +     struct page_ext *page_ext =3D page_ext_get(page);
> > +
> > +     return page_ext;
> > +}
> > +
> > +static struct iommu_debug_metadata *get_iommu_data(struct page_ext *pa=
ge_ext)
> > +{
> > +     return page_ext_data(page_ext, &page_iommu_debug_ops);
> > +}
> > +
> > +static void iommu_debug_inc_page(phys_addr_t phys)
> > +{
> > +     struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> > +     struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
>
> You cannot do this - phys_to_page() can only be called if we already
> know that phys is a struct page backed item and by the time you get
> here that information is lost.
>
> Probably the only way to resolve this is to somehow pass in an iommu
> prot flag that can tell the difference between struct page and
> non-struct page addresses.
>
> But I have to NAK this approach of blindly calling phys_to_page().
>

The callers to this, first will check "pfn_valid", which is the right
check AFAICT (looking at similar patterns in page_owner for example).

Thanks,
Mostafa

> Jason
>

