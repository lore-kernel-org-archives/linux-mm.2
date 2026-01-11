Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD0FD2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738766B0089; Sun, 11 Jan 2026 14:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEF76B008A; Sun, 11 Jan 2026 14:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDFF6B008C; Sun, 11 Jan 2026 14:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F29B6B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:58:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F22CB5DE70
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:58:50 +0000 (UTC)
X-FDA: 84320746020.26.51200E3
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11353140009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:58:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gbgAK90s;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768161529; a=rsa-sha256;
	cv=pass;
	b=omIqtsVZo4tuROSVeylNEoGDsz+GdNxLzS+tv8n+CZ3ePFAy1hE1FSfNLhvMFGIYNFvWUD
	ttJpsslFoDkrexKoHsJJui8gG9VvwLtEoDs/VUwBRN2x67JlCx3/qAbuqGn4py/ychC/bb
	CFYgUhxX61QiLlQiBNgmbVFYioby3Vo=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gbgAK90s;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768161529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6+hSBJqSA3+VMmKzrfx6A2YrNqWOjPkf/fyemiS2I4=;
	b=vWF89Dq7Ts1cfjfWhEH0kiD2kTxRxaVW7HtltTamo+R6hAT7wpMNriPkFzgTWtdJlH44/4
	BspUXwKu9Qs4mxPoYiN7rdD/365oil/qAXex1SeS+JKjOCrSksPmBAvYHbDI/qbhU2qPVH
	xdKn27RcVjjGqys8xHEvTa3uQhw3Fws=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso551691cf.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 11:58:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768161528; cv=none;
        d=google.com; s=arc-20240605;
        b=Gi1J59qZVccJzG5H5t3hJ68NQv1yXvjgUFJAJqO9H2C9YuwL4HuMgW0JUcFRkD3ood
         0ZBh71+2CeihR3tWurS2gl3PGJErm6zTwJagPWYz4hOQP2D8elp2uTp9Ec5V9AZFAzgu
         n3lql2bq9rmqDang174BRU/F0t+CVqLcqXCe9i3BngEmR/bj6yl2VObh3KRjMKjjxC8D
         Q6jdTk58WUvtTYT0LuC3M11hq9AjeKpxZf7y8d/WL/s7dypplA7fFxwiGYfsJN4Zj4Wk
         0oImZzM+VtBnWDIuCbbchM12x8yNuNi8H2AudSIaAJUVncjb4XmCXFYepCXrG8uDnvay
         3mWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I6+hSBJqSA3+VMmKzrfx6A2YrNqWOjPkf/fyemiS2I4=;
        fh=qIsss00sPj0yMXzogVcZ4KpWjMxPIBQCdLltjJtyB4g=;
        b=ZtKTI853LfdzqiHp8jiuIY5rAAff1eBeS+sVheDf8/NovCrzsMIsSZWotl/pe7D78+
         rHAW8UyaAzdfxceEBeBVOcnTiHbw6Veq4I02gvCdP3lnAUqeqODS8pAbZOt8gV9EZXUP
         IVBT6ENsSQCivS9fpxj6ikxLydTVcvJ2/vbDuimTelzhHlmE1L16+EdVa1Q6rFU6VxOv
         0muE7V3ycSxp0mOMjux6ffcN1L1DP0edbNso1gsMOf0O52gH4NvMJxRRNS75UZgA04wn
         uQR6D8aRkCtSLKTz1T0ghuCQif3O/M2TTy2hcaObbgPt+KEpRxT3zDAA/Z6SYJMzTAxa
         9Oyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768161528; x=1768766328; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6+hSBJqSA3+VMmKzrfx6A2YrNqWOjPkf/fyemiS2I4=;
        b=gbgAK90s8m4ULdCaXeyQUxQecW99mbLcGBIsp+KmFBcbjs3rTy/SE9za74o2IdHVeb
         8KuyZ1Qf3Yq+d+FNkZByc8/q+qeaCpwxYsVw0xnOZ5kEQ3ZWrK45PNpl8t7zDvbtBfi2
         d8Y/MFNeMA7KHZuzmeJIT1K9btbXiTc9ICm25IIhyoWgdpAFerani1Bd8L/VxEBeXuhv
         J0BIkUTiTSI/TytywnETCEPpSDPMpCWxTXxXSTpSJR6uUPKvKRal9FcJnKZU2tIk5Y6T
         GZUIGxfrOlD/X3sqNDtLLOxnx7SvFpnD1Qh234SYX80x+c9YBo9wFl5WdVDYnOp0w46w
         8S9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768161528; x=1768766328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I6+hSBJqSA3+VMmKzrfx6A2YrNqWOjPkf/fyemiS2I4=;
        b=LZleWw6O8pIpEQQMILlPknQDV8+B3r96cvUxkl//g1ylFGAAklHisgfqAk4ipahvwg
         B0w7EtxcdbEg0ydCOOkM6YnokSLHMqhBN2zh5beteEmViJnmt0/g2ot6OLBnCr1Hs25X
         1Ofjp+KGCO4fUPa8CQ9plrQsnlWe99QRkyKjLWGlHK+eztgyvosgiD1RS3F4tuim+4Fp
         /MS1ZGH8QTDo6njw6tMw6TxTpmKTx5JYdaRrEP2wYqyEe0Cq2xyI/peE8WGTqRP1Bzni
         y4Uq1fg0rKChV2rlLvZlnwBBO52miOgyaRokXzlHjdrmtcSbt3dQb7wqPgSg5/C0D8Vc
         7Zpw==
X-Forwarded-Encrypted: i=1; AJvYcCVf6ti0Q4kbxbluJqRKHeRHYpLw3daNcPHaddve1ayoAVBhpEHclZ9t1I2WB36/X8YuXkVcmUSd0A==@kvack.org
X-Gm-Message-State: AOJu0YyxwH8AjbJ6svuM3778td/N6BqwABNw8vBs7/aDRIjZMBshhyi1
	mJJxVa0fbN/AP6q/zSaW95S9Aw71zxa1DPXHY6SFBWvHQRrq0vitK1d6AwTNmYBhAOokBWxDU0U
	RYwdeE1Czv8fGFVapnLZCRnlNVzzuqrMw1PWtuqlR
X-Gm-Gg: AY/fxX6737B9JWVF2Osl9Xh+OgQQb4ELeMc1T3979dYwtthuAREnE8AhUMgdkRBrEQK
	gojFwI0Ls5O0xLKcAiVbDxV70Vp2wSFgQMEX7bOK7mLx5BLYUJ9qQuaijRyIC+S7MnOX0D+DyCd
	SDHmYSV3tksNkwsqlUDtnWfwaODxyqVbyBg6jI6tdLXuZnmIUkiQWGG8pJb3iKpPvyoPaVAtB/s
	8c2ZicYiDeicGFQvEQNAkVhN385pNOb1vaWVul1/FtJ5ifMMtmQ31EZ5mKnRRuP6FHsYw==
X-Received: by 2002:ac8:5d52:0:b0:4ed:70d6:6618 with SMTP id
 d75a77b69052e-501183ff303mr13581271cf.10.1768161527878; Sun, 11 Jan 2026
 11:58:47 -0800 (PST)
MIME-Version: 1.0
References: <20260109104251.157767-1-ranxiaokai627@163.com> <aWNouDKhjUzHGXks@kernel.org>
In-Reply-To: <aWNouDKhjUzHGXks@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 11 Jan 2026 11:58:36 -0800
X-Gm-Features: AZwV_QiK_IeHIRZqrnBt1bCRQM6Ten7OJ1GzXqY8S_qkcmlfi0C1bxMOjNQwRmY
Message-ID: <CAJuCfpFoR-vFN9Smw4jpd94h4B0PjVJXTjY7fDamz7vyfBZi2w@mail.gmail.com>
Subject: Re: [PATCH] kho: init alloc tags when restoring pages from reserved memory
To: Mike Rapoport <rppt@kernel.org>
Cc: ranxiaokai627@163.com, graf@amazon.com, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 11353140009
X-Rspamd-Server: rspam06
X-Stat-Signature: qjxm1kuny7te4is4xhbs655mzyy4tpht
X-Rspam-User: 
X-HE-Tag: 1768161528-533238
X-HE-Meta: U2FsdGVkX1/Tp0XQYXGm9ajxQe6WKz+rvFYJ4tpSXueiwXQJcYHlumtWxqJ4gwXk+9q6GGm+W8Z+GQAnWhUpTfBTcSYymU+axjWFu2cqtOhOd0VRwnkKRk2H29i5HTJLmoQwpitH2JsmY+qaW9Q8n3BL6Z8+Der9x3/ESVpITG1vrttPj3SHDeFmuja1imSWWZQjy6yqnQwWZaJ4l/8BX5fl/c/vGtVOYmpJ5xUP8yysbuaysi57+sWGY6dLLipdVGY+uqU+tV9uHjvA0UtlihhLPM2FX3EmIN/TCqQ7dcXzoEt31YbzVYbp1Jgek517FFP0DNWzSUfJEIjPwAfblBnHB3HRTR7XimMEnhZHct3vF0uTv7KSHdiyLnZO7wWURpGp4GjOuzvxnhGI9A+QEnfp09LmVptXq2Dn+CBX9Y1kZQyPpcSCIV4taYtbdx6AgfkWRtMVgIXFFYsWsf2dHQzZTm3rd0OMxi+LSVaZCaF+uR9jsCYkWARu0k5yyIl1frrdEbh0U8xJ3XdRx4XeSi8eE3Ac7NTprOZA5WPslZa0Fip97mAKoguA20UQYMe/5ZTcI+pYzz2wUJoBqvD7xqbtHR13+Ib28WpukAcxsFENt2/BsXJvSNZm85GC3XVRn5QXItVbqR+bfmdfM0Ftb8CoV2BA23np7igiJd8aj1PFLQerYl+P3G3S+IdwpLTjP0Ap/2LH+udR7/+PoE6CD1O0zyOslWflehGTmoNzT8wT3cHGo746rUcc+oJjwYfXkSYazLs75j2KZCeC+obS9iLL67Jh0ca8OxheEYkpG70oj/iScRP6WObm7Hf8GDKhYE45XKqiG6urJbifMhr5eEyzNzjJga9RTn6N59ZnjscOS+tFZDXzuiG+1ppD0qiJmCJ+77057OqZw+Fbjkg13ceO3cVw/TM9XnO8/kOcMYrKbQI4Pk03E/XE3TMgSuzKcbKsebTJhs0BtefZAkx
 dKqV6uKz
 94aN0+Fcz5ZdTvdQafhqLhWimXMPyfSSOPpU4leLZc4fNVmq4Kbm4iOjHQ7oUiq9BDdGHkP0T1g3fV8xzwwHfrxVPn63yEiHcbbPKcMTeedB3F+cQi7Dabpx4hYI1QEGwOPU5VC6JusoCWIfdo6VZvh60VF4Rs2sZHCT3xbHp+7y+NjibLXjSQXcH+Jh7XoxFCb36V/fJt98K0MnPfSia5mZJcF9nkx/EbjYh1UGbgk1vcEuFvzM5xIrEaECTIVZenDOj+ikvxR6VE4p55qUu0wtku/J7W2TX7bFOUngKzBJUll7KamDAVk80nUx4kmy0nDk3/CGHLc9SA9kMg9Zpz8WfDCuYtpP24cF91a3VuU5j07hL27zpO8fxyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 1:09=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Jan 09, 2026 at 10:42:51AM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Memblock pages (including reserved memory) should have their allocation
> > tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> > released to the page allocator. When kho restores pages through
> > kho_restore_page(), missing this call causes mismatched
> > allocation/deallocation tracking and warning message:
> > alloc_tag was not set.
> >
> > Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> > fix this.
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index cd6b3fb9dcae..2d47f2c50bd8 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t ph=
ys, bool is_folio)
> >       else
> >               kho_init_pages(page, nr_pages);
> >
> > +     clear_page_tag_ref(page);
> >       adjust_managed_page_count(page, nr_pages);
> >       return page;
> >  }
> > --
> > 2.25.1
> >
> >
>
> --
> Sincerely yours,
> Mike.

