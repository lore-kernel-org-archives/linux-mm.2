Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC71FCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A5B6B002A; Sun, 23 Nov 2025 13:38:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5022D6B002C; Sun, 23 Nov 2025 13:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F1B6B002D; Sun, 23 Nov 2025 13:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8A96B002A
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:38:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4397140173
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:38:26 +0000 (UTC)
X-FDA: 84142732212.13.9038CB0
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 04379C0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:38:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJrBIIew;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763923105; a=rsa-sha256;
	cv=none;
	b=iE+82v9QDRZzRN1/48QaGvB49aGei96EurdjcdBB5A0iunGPlSJWPPIrNFNYuDrTOnMes4
	nhp9hYnxEj/wRcQb08OMHB7tWl/TLPS7i4K+cekYmwUrY1UNni5tfUb2zvfc4OPvXt8l7z
	j98tMbXZ2K/unpHBwR4t7KL0N4sbmHg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJrBIIew;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763923105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdwuuNGRmmTs+l5hlJgp44Bjw5VpwMElnTjaANaCcvA=;
	b=2CKovORQqL6lTyyBvp2hapoCwEvNlX5aIsjgwAmjpgZZVIZVkAjWVo7o7vP5azFE+BZX72
	Bn8UEsjKcz8JzjpTyfAIH7TP1werXlR2HGNAbfDedQ+PHoo7BJ2IJYEjxMQwMjq8B67ghY
	i0JRf5b8T+0XOqPLPmXcNl8vqIgJSJE=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b25ed53fcbso539994185a.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763923104; x=1764527904; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdwuuNGRmmTs+l5hlJgp44Bjw5VpwMElnTjaANaCcvA=;
        b=JJrBIIewrdZYejQHGUaYL0H3/U6cnvBCAg5bOw7fhGOusM8jRBj5Guvycxsyt9L0G/
         7JekKwFQ+c/aEBENPmtavjXDKBXwZgYc6YTLoYOn//44zT4Y3TI3HcaXpxvQyqX1OeZL
         LnYN7Rpb6CIgemTBg/3B12jIgznZGzFyQQ7guQuKckJqYZa9aa97IX/kBeM/hZKRd3BP
         y8ay9IyQygR+Yhew2+maPOKLj6gTSpRFnGINNUuam7sNiNAXG16Y84YjTaNrPWn2U4P+
         2DPZuziloK6anlsOUQ9U6lbmclXc70UEyus9k7lyDTVht0O5JXEXwi8FWF7jrDfm1HDP
         c+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763923104; x=1764527904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rdwuuNGRmmTs+l5hlJgp44Bjw5VpwMElnTjaANaCcvA=;
        b=frJnf1fdtZHcnxO+pOr5dxANn3OBG66gxmsZZGnREWAKlg6mNeMIT/zHTjaQ0RK67J
         2yGdEM00+TVIS5BABJPdShTOMj9qbkRSbFU1xrJaU9lLvESbty9mIUCOOF1scDenDVL4
         0voZYCEK1x3C6HqDNp8tOdPydEkkUmFbJnn1rRsxKVCHDKIryFCI/mU7pIyiSLD9az99
         gQwYyLAkkr6XaxGKBr8JVxlSkEsAprtAA3QNbmD+huJXv7BZw82+yzh3+n03Kj6/QvJc
         0ke74WolfcPhEwxzgw9+WQWy3fkXS38819hOX3qh5mhWo3jBLcFx3CD0Ji+t8Y10KRfM
         XhSA==
X-Forwarded-Encrypted: i=1; AJvYcCV9nwmn2hFsAAq0B+ojShsKU1cbW2427SZMW5zv2y/5ISpvjzMGKvsN2ZhaRz/7TtoISLnQF1ppzA==@kvack.org
X-Gm-Message-State: AOJu0YzTKL0C01IesaDJlUpGJkKTs2WZbbEEEzURRx7dJTpmbJnb5Uhy
	aSWqCjPVHiwL5QCLq7uQBrLhTO40wMNKbxCapSliBTsaJUhZYzhC6JT1crW+WcPu1aLCBDb64wN
	4qYTi+CXikCRvkJGx2dVa5tCm/0Blafk=
X-Gm-Gg: ASbGncvyi6P+F3vTG8ciQhRUHoxsKAMeNRtdbCBdoNvA3hXooBzxiMcEnbJv2rbDxk5
	Wuw8Hb+FB9mITJwisicTdiA3b3B7ardw3ZaO8v0yb8q6xbJKMwRaeHKe4nP8EC4GybXx5sdld0I
	gvCjntGQfKWhNrM8Qq2WWF0A5FmKAsTdQpjfOgRAoKFyT8fdXMkaaJtn5vsUNulKRVRWv5od2UK
	93fd2DgGO7Uv1GFP7nrNEJ2NqG8+BLL1lcGM8sHXnFwro0ToigtyTwotYZkymMD7qVqNw==
X-Google-Smtp-Source: AGHT+IH+5QKuCZvf5/keMK1WgTgUsf7PktWqUBp/WFTbe4Rmfh9TWMyTsLPIagX+d/qwlIFs1KQDUNC0jdoWq4eQjxg=
X-Received: by 2002:a05:620a:298a:b0:8b2:f9ac:a896 with SMTP id
 af79cd13be357-8b33d22b4c5mr1188253285a.32.1763923103870; Sun, 23 Nov 2025
 10:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20251122025529.1562592-1-ziy@nvidia.com> <20251122025529.1562592-2-ziy@nvidia.com>
In-Reply-To: <20251122025529.1562592-2-ziy@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 24 Nov 2025 02:38:12 +0800
X-Gm-Features: AWmQ_bmB1GmD4ipBcMkBhXxOqNr8QTeyJfOT5zmdjmT7NAcBwIU-SnOo9QGRatk
Message-ID: <CAGsJ_4wyL9TZr141emBOBTKhN7oEJjeA7kFxhoBbi-cme-5tKg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/huge_memory: change folio_split_supported() to folio_check_splittable()
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, 
	Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04379C0007
X-Stat-Signature: kbo74tcdu4gq3anacgfauf317fof8one
X-HE-Tag: 1763923104-333965
X-HE-Meta: U2FsdGVkX1/7W8KZa7xYdL5k+Ms1ytl314ybVEqacZ2pZ6tSesfE8M8euN/ncFgRpGruxmsj3l3er1ze351ilaHA/iJN1vcndghxUtetoxwmexruKq2iRjEY1f+n8aJW2wQGpaJbLoFM2dzC0dYoiQDRk1XfgjDQf1RyPAJMcYOgZAYFzUoFNkDjY0UaFAilrbYlk28mbctA2jRdhIKOkvhOuTaY2NY2M2mGOA97OJr5ovQgNZHK+h2DEaP9EvfATWsziTIyDVlbvcxZ6iD3avJU0bxoi4N1MDrcY1HdEic09g6dL2O6KAPpmqK+XbrBpFirzLUV/LjkAdKHWtTdIHmnjTs3qqDoRIrUAakybpeDdTA7rw5qOpVejUyc0xJK5rrW8SCMpOrxFMXTV2mOUa8tdyw6m1KihAENZfVbcdYTg81nHf1cCtkILyoBmw3LBGZ3ac3qcG3bGfiQW/tBDaolGk/y2piLPt6Z/pggdGr1b1vqoLPXi4Z3rTbLVp9mma3CNJJ43LiDlpn54VeeyyQzldrbi4CwK1AQZK4DGpw0XVLygsnFJpvnxfGxbExn0WxlbxsoHP2PbQgIHut899K9uUUx/hdExVVNNWBg8LptUP64/2sl9XdzPrRuLe82od+l/yFCClBAX4jRALty6FwEYRhwS+8SwKgs1dVVl/++K6i2Sw4mtvK77n4G65XxNUh0Ay62qsYPzR6ST/hP7Gw2qUeij6GEazDIcwcZfHRV3QPgx1brz+la81tEEADnNjU2zSRkyENZiryqwarb4l9ilO6Uj5D4yCNjM9xETkHUh6DqJwz4hRs1TNmZfVJ/QdXdPfnC16SeIFbSt2/qTIUEB73B3NaM8bFfgegu0wnTeNlMqpfb75kcbhl/vOZWOvA5ZmtBi+GrpCqhXV9p5g9GtuPs8SQlkuaFLEDCaCovNqumiz5l/Y24kvCtWoA2CmEHP6dKYqEbJANEmaj
 tDL3qmWW
 ZaP5hB9NmigYLjt6DYPGuHsrHq6IilaQ+gi4JyeTmByOOAOMqbk5MYh/fagVYiN+39NGz1Xq9pFfipnQBJDmgM/IBEcbXaGjObpD+3YGNmbfDCUisgocI7jMhrb/ZfO+re+/Mc8srbfGjQq3cq5L5xfNHAuCjP9XEn1K7LCDrPWolRkPGoJaUqykSNDhZgqWOC2wcsej4tHtui8xL+TvIE6+VHJq5PS1mbsNlIvCDkMHgv/JILfm4K8XWn6vH5QVgsy78XR+bgdOwaymgcwWFQF1/2pkXu7UnHiTSGCA6JpnsTQ8ZuL2+Q6GbNvHYfOtRuew/t5p4KruqrRlb8aIJQD1/2z3Sicq7o/vHQ37HE6nNya0Z7Cc0xok7S2+W7XqAenSasDr6fMEqV/DQ+JYxGO+As/XIQxloo3u3wjuZPyUy20wzREbiiQLaCDOPlB1PddyarpUfClufqMbJpOYmgjsnftkbcwH2YB9yvARoiS8r9OuCgiSxqWibGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi Yan,

Thanks for the nice cleanup.

On Sat, Nov 22, 2025 at 10:55=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> folio_split_supported() used in try_folio_split_to_order() requires
> folio->mapping to be non NULL, but current try_folio_split_to_order() doe=
s
> not check it. There is no issue in the current code, since
> try_folio_split_to_order() is only used in truncate_inode_partial_folio()=
,
> where folio->mapping is not NULL.
>
> To prevent future misuse, move folio->mapping NULL check (i.e., folio is
> truncated) into folio_split_supported(). Since folio->mapping NULL check
> returns -EBUSY and folio_split_supported() =3D=3D false means -EINVAL, ch=
ange
> folio_split_supported() return type from bool to int and return error
> numbers accordingly. Rename folio_split_supported() to
> folio_check_splittable() to match the return type change.
>
> While at it, move is_huge_zero_folio() check and folio_test_writeback()
> check into folio_check_splittable() and add kernel-doc.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h | 10 ++++--
>  mm/huge_memory.c        | 74 +++++++++++++++++++++++++----------------
>  2 files changed, 53 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1d439de1ca2c..97686fb46e30 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -375,8 +375,8 @@ int __split_huge_page_to_list_to_order(struct page *p=
age, struct list_head *list
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>  int min_order_for_split(struct folio *folio);
>  int split_folio_to_list(struct folio *folio, struct list_head *list);
> -bool folio_split_supported(struct folio *folio, unsigned int new_order,
> -               enum split_type split_type, bool warns);
> +int folio_check_splittable(struct folio *folio, unsigned int new_order,
> +                          enum split_type split_type, bool warns);


It feels a bit odd to have a warns parameter here, especially given that it=
's
a bool. I understand that in one case we're only checking whether a split i=
s
possible, without actually performing it. In the other case, we are perform=
ing
the split, so we must confirm it's valid =E2=80=94 otherwise it's a bug.

Could we rename split_type to something more like gfp_flags, where we have
variants such as __GFP_NOWARN or something similar? That would make the cod=
e
much more readable.

[...]

>
> @@ -3734,10 +3762,18 @@ bool folio_split_supported(struct folio *folio, u=
nsigned int new_order,
>         if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && fo=
lio_test_swapcache(folio)) {
>                 VM_WARN_ONCE(warns,
>                         "Cannot split swapcache folio to non-0 order");
> -               return false;
> +               return -EINVAL;
>         }
>
> -       return true;
> +       if (is_huge_zero_folio(folio)) {
> +               pr_warn_ratelimited("Called split_huge_page for huge zero=
 page\n");
> +               return -EINVAL;
> +       }

However, I don=E2=80=99t quite understand why this doesn=E2=80=99t check wa=
rns or why it
isn=E2=80=99t using VM_WARN_ONCE. Why is the zero-huge case different?

Thanks
Barry

