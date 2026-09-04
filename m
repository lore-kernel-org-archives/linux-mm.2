Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF09C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 648406B0088; Thu,  3 Sep 2026 23:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F89A6B008A; Thu,  3 Sep 2026 23:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7486B008C; Thu,  3 Sep 2026 23:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28AAA6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:27:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE7BA1C2617
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:27:24 +0000 (UTC)
X-FDA: 85174644408.10.BD3E723
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id D383B80002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:27:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JEFZD/+Y";
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788492442;
	b=fv2jMaYjyzQYIAmfJKEKUEWMOa0Tn75YhiJPJ5Iqo0fjG52cppNTjWReTHV9cvmQCQJ6Pu
	5a07RwVuSzvHcnGDCxVT+Tr+Lpwv6USYSaaHfN3kMhRquEhmZVlYBCkNtiyF1EVfzzhJL6
	Nl0lzhdste43doz/wbDVVB4K22dXWVo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpaNCdk8qOT4pxEFWnuB/KdAsmJR7/mT/BqEQpedxvE=;
	b=nxH5/6iqO0xWNYmm3BPWNzJZl2egogUdWmrYUic8Wvw6x/pUQcvQUA3d0la880t7JlcSCo
	NuaiL9A/hvsQ72r/hXU/i/GBmgeUxz4YsdM1DDSf9R46SxvBeP8jy7c6UDQ+GWHhNRFIdB
	u75GPDpXWI0tCD1JXA2vxm1sLCTCoPo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="JEFZD/+Y";
	spf=pass (imf30.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4956d1d9fb2so505335e9.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 20:27:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788492441; cv=none;
        d=google.com; s=arc-20260327;
        b=f+6n90omXMDLDaEZYoNKX5JVWlU1EBoaVrO94ZbuCrNnKeoFpqG67kziFyCprszY6f
         fccy89Y0Ne+WZL9A/rslkBe2bQiYDB6YofD8BZiP3BBi8UpdfaG1NPX47LfazyX3g1DQ
         dB4TNXlulnjU9koMIkRZboYlTnW05e8v4Yu03pAm+ZunQ0j2e5oVb6eYxXstBdXAlGxH
         /DyPl6F79hGFcJWiGJDBFUi2cjdj9j9kUKqcKBd3OLRcHJxq0VGvRNGPd2Ar/EFNnaIE
         EAAefTmYMoErI4oAwEhrE3ZYmOGrjnh4sCbNAhO5rtQdNhhjznmO0xePTAouu05JAvFL
         kZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YpaNCdk8qOT4pxEFWnuB/KdAsmJR7/mT/BqEQpedxvE=;
        fh=LYrCUX5KHkEe/IdjUD572J+Ypp50Um8mO5sSi0zkOHE=;
        b=XuHXDM7VQMCoY5cuqhFGuBVDfN/BQhpRPgncLgx3sXlc5Qrkhg1KDkMsTKhiyAAPJu
         /I5yTw473ZakwET7uc7nkY3dltMzyccwqwCodsBt79oghSx4BG8iXd3KeNvVAG13veVi
         Cr2sMWPYAu6Z5ikCrJnyfdmG69T9aeL0R9WOJVfvVf3CY00/S+/BFayuOZUitBTr2tcm
         dgRS/95KIG4GqmBArErqbfwyO4WdI5+hOHvoHQlNgOsytRxRmveb9cd5Qafa5YyQ46iD
         +6+YNQKyQ/pdBB+V7qcVQk4uNLLS4NgrXVNixvJSpYKvo3F//9HqD81qnpD9fsiGVBPo
         wF6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788492441; x=1789097241; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YpaNCdk8qOT4pxEFWnuB/KdAsmJR7/mT/BqEQpedxvE=;
        b=JEFZD/+Ydebe7xGzqn5LbJCvr79lVwvnEcpzSkP+fuIPTRLuUbvpmwgSLFWgQAm9BH
         MZcYJA9hGYu5Q8ExY0hGvfkEN2zKzFZvAaitFre0T25wpN7OLr1SsKfUX3tKUODwQfmg
         PiAmBvp9SWF2VVGjWxkSjCeFqwHphFSfBji7Ic6rvpmgCEZ/6bVaW8vb0DMP9W1K18rH
         iES05a8dgPCKIqgP7BZFmeAQmfk0st/iOmZgYG+L70vB2FLvsWppwKM+gsA7ghCG/Det
         /ypVl2AhK8ZwO0CQBk4YHCLWAX/8sQLhWNgqQpEsJk2xJQ0iqFM3W4yVVPLlQ/rCNB7Y
         /T+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788492441; x=1789097241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YpaNCdk8qOT4pxEFWnuB/KdAsmJR7/mT/BqEQpedxvE=;
        b=hPvhumVh7c3DKkygY+s7N8KSthM+ELTGEaS6MlAnNB4KAFbu/dELRGDnZcqEdOeqdm
         lWHgZxuZLkE1KC0lSkS4Sgklk0T+4pBPjICy9hiuwS0x3ava9qpw3yqxD/+LN4rR6S8f
         zO1YyMAeFZhwzLVq+8LtGetG9mT16KTiIGbMNPw9APPpUlpB5N8GtcqQJyeaMjFdmsjr
         bviaTrt9+TKLSKJnp47vi5Fw0MY5gB4ntxdZ2ZYXbNZ3b+XJo98u25Nu2xl5SCd87kZm
         UlrBZKmnDX11ypz4Ys5U8NlmHRMxlvJLfC29nXXmr4pbShl61ztNNxJq4X5r6UQawlcb
         PFfg==
X-Forwarded-Encrypted: i=1; AKwUvByTckYFUxy6wzpwAmnSE41cEKHD0+BCKdw9LGF8v3kdiNEKcp43E5ifgBuydsZ8/uSrCsgYFJmpJA==@kvack.org
X-Gm-Message-State: AFuF++lFDDGb2ZluQTA+2kqnkkpi9PG6rwD7jotC7ZPqDrLnOheLJKK/
	a8QGBQnxIAX6NOzmRxBjU2aWV1zZ7kTs5WBqp+YXWhMbHfkOZ24fDty9Mv6xD3QssjC1goQF8JH
	pJ2R/bAVHgBQCV5XIi8njNHrl+ZdHeOw=
X-Gm-Gg: AYBFou1oPN7pGP4asXPptvD3k9CxhIUE5Z/3f33lWBA7GRbmbjp/xq6ZRgiVFJHQs5H
	kkSGyXl/Fz+KPnpqmYhx6wYQyeKcVm/v5geHDHn8YzA0x9pB7Wx89UDV7haNV7ACcRlLqo0p8in
	HFR8rUxHGjv//rE6B8a0oygboPr96CkCp2ZVvTfRwXk/eN9x5HP9EH3gsbhOR526reydN5xwEas
	HzzUbVJf7kxd+t0ESpINJcHoDbQIK5ZhN3hIjaLiTu+WbhhpvbNL/mqp3CZgnCARkx710RqJ5I7
	NfyOxOgLqv9DjGE9u+pR3GJ1Ur+TSbZrQfwZtrVkCkam2xIx/5TzE7IzFCLCr+l2rd25s+L5cxP
	xOhXVPxF0NJXfzch3lOF2e0PJLfGv1xz61AtysGg=
X-Received: by 2002:a05:600c:a40e:b0:49c:f9b8:bae0 with SMTP id
 5b1f17b1804b1-49cf9b8baffmr9477045e9.2.1788492441090; Thu, 03 Sep 2026
 20:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
 <apk775HfHg_DXpiW@kernel.org> <1aa2b2a6-b068-4856-97ef-91ab848f01c3@intel.com>
In-Reply-To: <1aa2b2a6-b068-4856-97ef-91ab848f01c3@intel.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Fri, 4 Sep 2026 11:27:10 +0800
X-Gm-Features: AcwNN1VvYizDBaPoshS173cq9tRkFRCRmLlnTgzXTNcKAb5wasusdZ9mZR0gx2s
Message-ID: <CA+qSx6wrfKJ+KuRkU_gLwjN+tS3+yv1VqXpsnZk86m2PZg--8A@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, usama.arif@linux.dev, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, kas@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D383B80002
X-Stat-Signature: npgxmu5hx4mf7pogu6gag1noxruxsdjt
X-HE-Tag: 1788492442-602072
X-HE-Meta: U2FsdGVkX19r1ICWiLdDMO/othAdjKN9hHUDQeNaXBS6D6H8QTM8JdCXz8A/z9Tm7ndsFubQKGiDqMLnSXm08DalM9xWY2C/MOaOj1fIjd6pUR54InMEtEcQj/0yQmYd8yVBb7zKYL6jmkfWa3IFSJh0tb2U+ktdi+XdaT0xrlTT0bN2KUZB2Bi++g8gEtSsltjDQIzDdvuGY911kJpMX7YNDzlF3ICRK1iaIl5xTZkQYOusAN9ooKW7U/vlKcCa7WNrMaNBCySBshQDh5VI0D/adV95zZdZtDAy6b8tqfZP8bphF9OKdTS3p6lHzx6DjnpzBIjq4Z2a3G+bEi5UjPsbaO5nShdTYzU5cAC2DLtd25N9g996G0J66VqBm8C0ySkkfde5wotyw50s19wV2jJjX2T9syF/K+uPQeu1WB63np577T3oktOt7LCCjE0YZQR8FlNX4SpdIbUXTGuQm/ks86zeFq73HaM5Wzc9bKYIujnLk43uyxTW4FPowx+o+BZmhmoTCH5u/EBBDIeu7hO8eh1ZRaMsQ604lO5QebSZozgOdTh1ttu8Sq5snhG+UbeLZM8IJhZwGGHxYKT0ixn1Kfgy0bbGyryyMcaYUVTksIzE1iESScCtW/LiulbWNwfjH6pOb+WlCO2pUvY8J0P3B/EFyxEu1h5JiTrGJlm7eQyCfep4F98uV5A9FSY859r+Be523NFexbBhVLIsvPesuRk0f65D/jgjo9Ubr4n3XpWr+Igh7RY4jybA7p/1McY2kR3un+P2PLFbF1jQnyfCHjNjr+3+Npox2xzcT++l0kLJaSepCsOKrgE9zHb1O7MH2vV7isWsTe9CS13aHXohy1GrOef54lJLbw0kYLQx+PtidakVTQ4cfZtVW/33oFwNOs1y0pF7oNNEQMEPlOwwp9oq56FdPJ61bH/7Bhcawiqv/FPoZccgp6+jOLBqdl8pJw9TTcSDii97ORn
 Z43oTEiW
 cCirCalYVl/9HsOQaoIjobwv9oagldqqwutbxvS9HcLfh1/vTEskVImONGcPF3jRvPgA9iANhk+X3wmT8H6UfI0uR0fUDdOPzsudwTRVfFp+OJJ5oASxLFY5QmQdDMzHWsKlsgcFDOmiQujYWDq6Pd7AVCPqnT8iNNoqji3LdmpNu7LHaxhZVvzsMCypP+XBWJjrF31+NZLwLDi6dJSjWmFDgRGgF8+c+yjeoNwmWbr5B8Z0b6AZIsWRMElFAKEufWYjBDmkmMAGgLRQ49wIcYwQWsbr3mVe6+86H58iiE09SBq5cLlizPxGdX17/GCh5X/Fq8ZmJ+BnErLBPGCoJMjQ0dqBKIHYoXRnQBNpioMLzosdYQPWYbV9kVQqhi/9yGJNXHG6499uxiumPYHG27uELJiSHj+3qI/uy4p36SoErUR8IErTJ6gXnolH3k1f7zoAGZPjmRr3u+Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 10:09=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 9/3/26 02:20, Mike Rapoport wrote:
> > On Wed, Sep 02, 2026 at 01:59:15PM -0700, Dave Hansen wrote:
> >> On 9/1/26 08:18, Xueyuan Chen wrote:
> >>> +static inline int set_direct_map_ro(struct page *page, unsigned int =
nr)
> >>> +{
> >>> +   return 0;
> >>> +}
> >> I still really think the stub here needs to return an error *or* the
> >> thing needs to just be void and tell folks that they can't know whethe=
r
> >> it worked or not.
> > All other stubs return 0 here when an arch does not support set_direct_=
map.
> > I'm for keeping them all consistent and fixing that technical debt as a
> > whole rather than creating a one-off here.
>
> Oof. I didn't realize the set_direct_map_*() functions all did this.
>
> I do think it's generally a bad idea, and I'm also OK if it is not fixed
> up here.

OK, I'll leave it as-is then.

Thanks,
Xueyuan

