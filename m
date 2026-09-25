Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1806CC98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDDB6B008A; Fri, 25 Sep 2026 01:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5D16B008C; Fri, 25 Sep 2026 01:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D126B0092; Fri, 25 Sep 2026 01:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE19F6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:30:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD666140561
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:45 +0000 (UTC)
X-FDA: 85251160050.11.058F155
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C9FC840005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAjoFiD2;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790314243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iuVHKe+kHLV/jSPQ1Sp6pScTLQ6GybikNB88F+4NQpg=;
	b=2cnmzvIDQQXh+W3gDEt0YbhSYbEzQh43RUGXajafSM3wu0cmvkndwL5Nk7KDvp6aqpfVSO
	isKf+cKfYvUHFfupDxjkxWmiNsFptMFO0JQUTzsJZTY2ysnyh52kT3AwC9YnlwCDRyqVd4
	c7gEfoF1iySo9msiX7KrI2NXg66Slfo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAjoFiD2;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790314243;
	b=D8A6YEMQrMfumjD7j/GkDdNMD8VS1F9zAQOBgAkf4ssSK3NCAAMvJTN5EiOMTKovG/+XQM
	/Fph0cJOP0lCCf/w95lAaHtaJjcbTy/tBBPI6rHp3X+sHBEdFywTNvam+2PbtxMMqCCDIx
	/laCxtxf3oTu20xwd7a0jcUAPQcxgQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0182A4458B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9F31F0089B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790314242;
	bh=iuVHKe+kHLV/jSPQ1Sp6pScTLQ6GybikNB88F+4NQpg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DAjoFiD24Cdy6c2ES17VvfffdKkBKZC8OaKquPQylTnZu3l0Rfcfzkow9Fvr1RQpM
	 CreQeqEJU5ZY92W638ubb5rI6AJm4tgu8yU2Oods0rF8H5iFRaC/UvmozeNqFweKfl
	 DNjEM5WcsC2W44XwmRN6vUQIgOJ5voCv5QZkI5X/G+5xgZZMzsJzvQWvYy4gX9B/3J
	 KwJV1JBh/C+bx5VoCTbLUD3AtEneolnWi2VACjE+DFz+yDVsRMqi72YNiGWbow+lsx
	 1cwHVrEDdYho5sLmNjCYZHgVt06d5avWNJt/2DVQmfe3967e7PrWAZJgsSjfyjs/1G
	 vmqiNUoe0ffIw==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93a222edc62so57163085a.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:30:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByNvsNi8ab8BM8Y4hepMO+Rlk6xra8u7t6H04rWtaQhzL11gIdF3DheKBz3spDifw+7FPbmRVkcWA==@kvack.org
X-Gm-Message-State: AFuF++kkd/oA+lDPfoRo6ml2LKCS3sffgFYB9m66myPz1BCD4nZdNRWC
	wpHQYVsNOU9T8dOeeXHDz9HZp47JLY7t/TyY3/r5nUmd9IoxwTgHKv7urW9g7cbAqAbMZk3oITX
	RA+1wGJrg/j8/73eK2XC79oT2+OJLOYA=
X-Received: by 2002:a05:620a:2945:b0:93c:b10:7243 with SMTP id
 af79cd13be357-93c43b61d03mr262098485a.5.1790314242069; Thu, 24 Sep 2026
 22:30:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260924131106.1730494-1-dev.jain@arm.com> <20260924131106.1730494-5-dev.jain@arm.com>
In-Reply-To: <20260924131106.1730494-5-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 25 Sep 2026 13:30:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yDZypOxjwmAY_usM+v_OJahShz-_uRSAiUZUAzv14VRA@mail.gmail.com>
X-Gm-Features: AclHuK8jj4BEC2ZukHa7pkW7xEBHFBfsvYex5BDejOLunxBiVqvO5dSgOHCPAnA
Message-ID: <CAGsJ_4yDZypOxjwmAY_usM+v_OJahShz-_uRSAiUZUAzv14VRA@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, davem@davemloft.net, 
	andreas@gaisler.com, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, pfalcato@suse.de, jgg@ziepe.ca, thuth@redhat.com, 
	sparclinux@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9FC840005
X-Stat-Signature: 8c43ghtaq59u8g8n5dgmj7tp1f965fjw
X-HE-Tag: 1790314243-340279
X-HE-Meta: U2FsdGVkX18FF9affJTw1I2IDMmDJeMkAYYxMuQbOOqbFdwECzC+VxkkDUlhVJDaCf2G8P8V1Zg5djawlhDAcFM11XuZWGFSwbqfUVYfo5zCm2cyXRTUZwGEnG4UZjBmbKGXAZEjxdRjRMlCquO3kcfwUDuXVUAuPxt+3zK05Qlunh8Sija2vVIv/VjRzKY6dnYVDCOpAp5B0h4M+pdEaPTao6cyFITm3HodIXREVnm+K271X+xWWW7SId7cM6RqvfdiCJCk5pSB89r7RGQg3bkXzlsINOnFwqD3Rt79/ZRKZjyp0Vi+6PGYOtkVa8M+KzqKfs9hG8omDGMcSKaqEzBy4OKq4c1SlMRblPTF0T0ULgT9hvKWf+BnFN4FkPTEmnxGYErGItm9hCTp0EyAgNCLPjI8H54qhK/GWmCDB1QP7GRR5hDQkKW2qaZDIrzkIw7h2TjqpyjgmBtY+2e0HX8GLFQR66+VfpAxdx+ZZFp97cRnj4Cz1JsAinuFBMITYcipJlt/IAqXkF2W55QjLNsovwuzQ8tCzt/ITO+6kR7i8zUZL8wwS/UB1cHUzpEShqHsAjGbiMs8kagkecPXeQzTBrc5PPxCICXFY62NyoUsghXNq5wKnen/p4FPXUKeEzDO9KrxY3GBDHq0JFsJEOme5uSWjpFYsJtZrJDe3dlBz9fzU1wg097YDOIVrK7b9aNbCLDqTInnhkeq40xXy2A7y55vpHu5bxNHY+NhHOrfkepSoUNtWBhUNbe+sxJ+Rap45S2qIHw/bzQJM9XVy1w6hevcHcqG2Ds4C2kN9pvMdYAhtoALVeOnFO5S1mXHfuTQ7DCdVGwNi8jDJl+Mamj5Y/N2MCsYe/SUJFxIrSEOrMnmRQILfxww8/l7k7SWjpCik6u+i7oBQxbIdA/8Z/ozXFjKKXkP3zfU6lxBwAaRcIUSUpMFVQt0tIl01nR+NC+hynzVVhjAr9vRtkL
 uSPdXEWs
 LxWT60deE/jGW+tyzu+wvzYuQ2jMds5HZiL5fAR1Px4weNMtwzJncdsTK5gNdww7sIx7SDZdDOsy0VoEH58LIRk3Ew0uvJ4+djLf8ARt7avAYjmc8KUNK2UAHKQSw/VXswJqsLyBl8K3h9zRGDuSHMIVNXGlmfrNch+AN1bMcPRRErPECc3Q2KaP7Gp2MDJpVbe8Ns1Jn+O8jCsOTryrfQY6xTD4N+/aMNJrmaxlMOrZTYkyAJSAoxcx92obBUi/snHT2EoqeCD3AF6Us30ghU68yH0IWnat86BDV/Zyxyz6wGNS1W26gdMQcx33iCKhKdIAI+M2i4mxjRA8gWSCSeyMCyO9MDvAF9h37cybvFmM+XJZRrxsQm6ObL/geiPxYvvmJ+bMxQ5yfisc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 9:11=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> To enable batched unmapping of anonymous folios, we need to handle the
> sharing of exclusive pages. Hence, a batched version of
> folio_try_share_anon_rmap_pte is required.
>
> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
> batch of nr_pages. Refactor the function such that the clearing of the bi=
t
> can be done at one place without duplication.
>
> Note that __folio_try_share_anon_rmap can receive nr_pages =3D=3D HPAGE_P=
MD_NR
> from the PMD path, but currently we only clear the bit on the head page.
> Retain this behaviour by setting nr_pages =3D 1 in case the caller is
> folio_try_share_anon_rmap_pmd.
>
> While at it, convert nr_pages to unsigned long to future-proof from
> overflow in case P4D-huge mappings etc get supported down the road.
> I haven't made such a change in each function receiving nr_pages in
> try_to_unmap_one - perhaps this can be done incrementally.
>
> Add two WARN's: check that the batch is entirely exclusive (for PMD
> callers, need to check only head page), and that there are only
> PTE/PMD paths converging into __folio_try_share_anon_rmap.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

The patch looks correct to me, but it seems a bit hard to follow
because of the `pinnable` handling.

> ---
>  include/linux/rmap.h | 56 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 39 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 62ef511a6175a..91b5763ef466f 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -723,17 +723,23 @@ static inline int folio_try_dup_anon_rmap_pmd(struc=
t folio *folio,
>  }
>
>  static __always_inline int __folio_try_share_anon_rmap(struct folio *fol=
io,
> -               struct page *page, int nr_pages, enum pgtable_level level=
)
> +               struct page *page, unsigned long nr_pages, enum pgtable_l=
evel level)
>  {
> +       /* device private folios cannot get pinned via GUP. */
> +       const bool pinnable =3D !folio_is_device_private(folio);
> +

If we make a helper that does:

for (;;) {
     ClearPageAnonExclusive(page);
     if (--nr_pages =3D=3D 0)
               break;
     page++;
}

wouldn't that allow us to avoid this ugly `pinnable` variant?

Then we can make a much smaller modification, which should
also be much easier to follow? No?

Best Regards
Barry

