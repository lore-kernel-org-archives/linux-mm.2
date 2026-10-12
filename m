Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C6CCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD2C6B009D; Mon, 12 Oct 2026 11:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EB16B009E; Mon, 12 Oct 2026 11:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5986B009F; Mon, 12 Oct 2026 11:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AC356B009D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:09:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B80E40AD4
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:04 +0000 (UTC)
X-FDA: 85314307008.23.F781DA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EADD100009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eu84CkOm;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791817742;
	b=8EFfrfF1xU2+J/pu5YI/CeS4lcb6OcI+yYr3Yg7dsIaad3TVlVCBfOCjlbqhpOvnRyWOw5
	SrFPF/QrDJ1O/HMNOH0oymEPimTFvvfT+Ixff94w/frY2d+IYd+777yT2pDHHXGqSrrMJq
	vf9YIQeJMTde55doUBscQavzjrpJRBQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eu84CkOm;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791817742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWUTCJCREI39E+aOOjzAotyeoOPH2eDIrrDPoZKoBu4=;
	b=R6yxon+vHr9sXl8mR8Di73ZzyicAoP/c7rZq04kF/11XcuAYejoPju01dQmHdR+np/8SP6
	T/s/Ekc64ILYnypr+VQOJYSMcnbt9Qh4pZONffk/vg2g81M7XZt8rmOVw2qoYxVDiYy6bt
	9gRRsek0/xKKilP9Uci7A8ygp88gYyk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B187B60229
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694CA1F008A3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791817741;
	bh=aWUTCJCREI39E+aOOjzAotyeoOPH2eDIrrDPoZKoBu4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eu84CkOmwXFvMRBks6U2hSG/qU6Oa7OELN7uWkx9qsNlcq1FrAo3oASGeD5VO3WfI
	 KdV+hD8axKez7OeVzfU9Gsg/lft/D2RMBGY/V1zsGzG8zkb5/Luk/0keI3C+ZVjtvj
	 +t8qmN74NptmUQr9nlEHfPar12/eFDKiGywqftNP+vCHoh/QbKBx31a9SeVI72cAXX
	 SPuL9eMmjnQH/kzTbX97R0GQxaGZZ4qClq6VS86GlXJ0L2vYPzrnu/7LVlRe72QAMy
	 y0c9Lw4B11ktrTwZvaH0QnB95SGQNcWy9J0AOBjRNjHiQeYBajHVzq+gOon1TJlzRl
	 b1MtXYTh+/SjA==
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-97bf91b2e6eso286453241.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:09:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByDc92Jj4VoeR8eTPurxDhnAGN9BJurY6PM+H3oNVamIV9Jo3Szi4t6HIA8yPFEW3IMIGTD/ekvDQ==@kvack.org
X-Gm-Message-State: AFq9FYL5Pzb4ph5QzINgbTfO+1D5WHiqWw6Qtuf2Rz/Wgc5KjMox84nV
	0DL/JvloezaxfJ2s0vNdjunZ3yBIpqcR2hctL1VUCbbYj+HrCLGPAc2o6TDRVqWzScT+H/XgDZH
	A7w5tLv2BHwZli/0SaaG9avbEU8/6c98=
X-Received: by 2002:a05:6102:5114:b0:7a7:195a:1b29 with SMTP id
 ada2fe7eead31-7cb375057ebmr2198065137.35.1791817740701; Mon, 12 Oct 2026
 08:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAGsJ_4xyzgUH4uhKqpD7PTVuOzdsAkYgowsyn5iT1LHWiaYqqw@mail.gmail.com>
 <CAEmasaWQm6DPqAhmW_z=kuR+3LDWJ=h+yM0hAs+ryNoFQd6qmg@mail.gmail.com>
 <CAEmasaXa2pB_Jm_VgBZAWQwu1p75yUSY2=dr0Opt5okLgWk-YQ@mail.gmail.com>
 <CAGsJ_4xw+CLzrazOFxnvJCbvG0qoauEuFGR6OdtT3x78ef95pA@mail.gmail.com> <CAKEwX=NrMD1jpU=Kfh367mGArw_ju_8ku=Rh_v8TiLumx3+S3g@mail.gmail.com>
In-Reply-To: <CAKEwX=NrMD1jpU=Kfh367mGArw_ju_8ku=Rh_v8TiLumx3+S3g@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 12 Oct 2026 23:08:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zg-PuThnKMgN53dV-VbC6Zxo-s6WKoN=x92Aa2=9pu8A@mail.gmail.com>
X-Gm-Features: AclHuK-DxxppJUvPEq3sn3XyNg_m0af3-igDf9H7UZjpJzGKzM_B88Cpkp_3Ugw
Message-ID: <CAGsJ_4zg-PuThnKMgN53dV-VbC6Zxo-s6WKoN=x92Aa2=9pu8A@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alexghiti@meta.com>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	ryncsn@gmail.com, chrisl@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3EADD100009
X-Rspam-User: 
X-Stat-Signature: 7pa16ksjsy119uby93ozqrax7ywdaugm
X-HE-Tag: 1791817742-866628
X-HE-Meta: U2FsdGVkX1+F7Z7q9H7L/vZgz1crkij8adFICcHiRJIgElS7xfV44asz3T3OkuOtokhniXwlLsnS2HiHel7F636zxPbXbbEfoPLvvfqh6vYtSPBZqoWWzhGaU1FX6tvBPQnTqtyOGaqwVP8+f0oJI1j048DXbcG7xrrfFw2PSrJ6LEe9UYfMPuJKNNkFo11EwS+4QEM1lgrl4PMBKhUIgjJ8KTq6ResAIdgXWJMSUIFPFpLQ6y42TeUREoKh3eCkAr9ILp/Z5lW9JV6mj4XymExAXNjsE+04PrYBlSDEA4nyVsRjmIOyakFUQl2QRdHvgqCUWklMegJtp/p8dzAzED8A5is+fUm02qezQNSr6C3UsUWjRfSopMS0bPbY9wNfo2HzXILomrQug2xkxvLdNThombNwtpoS1V+Il8Btxf7l9AgnYvTZU5rj53PxX8i8VMP5HlIxWpT5xt48iRhjnzlPTaV2Zxax9PjnJTceqvILnCNqWFUhqsTQaCWTOl0n3A4xS/wOXDfWtX36rFwaG0PpbxaxfSeWBgOx3i8BVsHQvj7pM7Xkiqz4J54paLkfaS4zDgffad1Ug56z6frJr/tgV0i5znAapVNgWWGfu126u4n8uCvp2N3wk8UTv8NMJsNYUoM0LmGC3upueD3GpX5T6HIePcsQ93HsWNhMNgQI1PE8Sa1/2qHxRrazJKU0NRg5S6w0L7E4GDtvqLMuPG77Po9w1Ve3P2/4t9CjeAmonrNnceR8Q0Qlx/zliPoLaPD1j+A7rp4bBatHTdNaJN9Vzkc89+z9jcsl3w6cejtJ1lEtqCox9LmY1Iz+nW4G8IySiCNNMLif62jc0GomqhbjMHRNic/3AOu7pVvwF5u1EpJZE3kGiAfVfzX6P9KdMjTLE3ai28o67nzhHU35yBg2xvQcENtT6uG8Jkbc1p4rGB4FKvlqfnI4rGN7PWJqqa+winhs5DFYXQRTJbU
 SJ+C5dh1
 EydFmTfyDpK1zJHdU3OJjVkwNHi7t8vhylM0hvIBPwj8gq3SBr+VgrKzzE/5YcouC6xBCf+oDwc3JfzlxADJFV1L/2Kag/714p2gM444ubZSMwssIZS5KQ24cmH544PhhCuwE7U/zFF920BIrngxm1wV3xZQB1QorCryqW5zo6sDuzXCp2dEIKQRCU7P0NidRd8PMT/X+uBwCctfQeJH4Pk9Pg1kWbplDN42UizoRs8omRWlh7w8gIAFApVg+5OrbR9XfpHQ+nQn/SIE4P41sEsPbPcnIckonUMPmXBtcyj4sqdVJZ1QNB6NzMsQeNwHHkZMmtTJHulhmefM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 12, 2026 at 1:01=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> >
> > Thanks! This seems to be a strong indication that setting
> > `page-cluster =3D 0` can also resolve your problem, even without your
> > patch. :-)
>
> If every tenants use zswap, yes. But we have tenants with different
> kinds of swap backend in the same host (some using compressed
> synchronous swap backend, some async IO swap backend).
>

Yep, I have no objection to this patch. As I replied to
Alexandre, I was just curious about what would happen if we
set `page-cluster` to 0.

I think Alexandre's autotuning patch looks good overall. We
just have a lot of corner cases to consider. For example, we
might miss zswap and trigger readahead, even though some
folios in the readahead window are actually in zswap. The
opposite could also happen.

However, I don't think we need to handle all this complexity
at this point.

Best Regards
Barry

