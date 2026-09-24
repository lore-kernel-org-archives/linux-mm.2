Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35170C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3155F6B0088; Thu, 24 Sep 2026 17:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C67A6B008A; Thu, 24 Sep 2026 17:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC536B008C; Thu, 24 Sep 2026 17:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB20E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:02:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F2CE403B7
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:02:49 +0000 (UTC)
X-FDA: 85249880058.12.B68FA88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 306E0120004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:02:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gre+hySW;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790283767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoiJXxM6i/kbsQEIiuA+nIFj4EQ8kOYLlbyqdsm+xTc=;
	b=0+h6zWlxpT/t0vTmtNkhQ3FUcLdGGqH0tvz4sez0di8Y9J3PjiJIFo7TZreovhEgaYI0fJ
	l9ziFWTOJmv8I0BPVhyLggZIF3bC8npHmCRpr/FmohLb7ivNxU7iuSv2gV07YjeF5ykbqV
	zn9wEY2kBQOM3yCp7Z//BC+LfSq2PfQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gre+hySW;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790283767;
	b=FCynZ2s/lnthZOFWfc/DkYNhQAdIDcJP9fhKafQYjnCENekYrwfvxWP1jhPVxhgkA58Vwg
	C1So/7MwEjVohEEf1YCLyMjDCmQd807mFpYC5ni65OYwWERh14rO/TEjzU5xec0oRpGWvd
	VFKKyIWY4oeH1eoAcMmG7Z3T+rXyKrc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8667A602CA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBF21F0089E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790283766;
	bh=XoiJXxM6i/kbsQEIiuA+nIFj4EQ8kOYLlbyqdsm+xTc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Gre+hySW4Jcz6RHQZXjSedwjaQRk3V5Msvma829u3XUHKWLJTnz4sDzashDTfOPN6
	 VtK+wv0V9y3/FM/D5kxsa5vcWpRHSox3YmpUShUhKSeIeNpsKMnWY+fhui0WfNi9qX
	 AjzSbiuGAPcQ+2ueHQ33MCPcKhiIGtgJQ9ARiZ6XOOFqLnizMdkory1LoOgcXGDB0D
	 0Rz6YPypeeH2FNrlJc1tauCxBWyNb88Oa6bxM/avzQl5IOEGdIuywI+yrI/KoE1pbY
	 IVgOj379nXeMFK4EhWBUVwCoQpObxwGscSax+dBCPxYsYoTHWll87TXwTuNoB/ybZg
	 QFymTZx0RE+zQ==
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93be29bb454so32943485a.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:02:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwMIZN80LEIP/8GwhbwvhbTRwsAAL8mvc6Gic2aSAERtdbqpmIxcYhVAuhUl/6jskytPXHWkJWknQ==@kvack.org
X-Gm-Message-State: AFuF++nXFyDm6j0hfNwThcMGYwr/t2Qe0MrEMjRa/yIMVTO7b1AehGOq
	49TsYsrBajaouMX/3CVXEQWx1n4+aKBdxGyMnN2F3THmPYKBXHVKCdKpDVIDS/NAFIl9gta3ULW
	FbY6HpMHdP3CE2JnnKhw9RvPkcFXClFU=
X-Received: by 2002:a05:620a:4612:b0:93c:234e:d10 with SMTP id
 af79cd13be357-93c43b86557mr105850685a.11.1790283765486; Thu, 24 Sep 2026
 14:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260924131106.1730494-1-dev.jain@arm.com> <20260924131106.1730494-4-dev.jain@arm.com>
In-Reply-To: <20260924131106.1730494-4-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 25 Sep 2026 05:02:33 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yVhXF+-gOrOB+JOK6nZt19SA=LT+gXpmaMpErg6Ra5NQ@mail.gmail.com>
X-Gm-Features: AclHuK_dkYU1S8LfF7mhgKUW-YMPRJkOty82Eqfv1olkQu1iouCk5LG5Qs9Q-x0
Message-ID: <CAGsJ_4yVhXF+-gOrOB+JOK6nZt19SA=LT+gXpmaMpErg6Ra5NQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] mm: move anon-exclusive batch helper to rmap.h
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
X-Rspamd-Queue-Id: 306E0120004
X-Stat-Signature: amcqjkzdedzucaym5s3n7io6xfoj4886
X-HE-Tag: 1790283767-543269
X-HE-Meta: U2FsdGVkX1/ziTlEZEwRx8TW7YmvyxQS/wi0Rq05ieiSOMW0/0FMeItxceo2uXN3vJRmB4CUnO0IqNWXLLw6UzCwVQP0HrTlk9he93Xgu2RKXkyTHt8WXVgiAYOdrBCC7kzCvpzUS9goXWSuSV44/5Ipl8O967hGAaX4OCHG1YGBJ4Wn7nKsobvO8cRIrk5SaskS+nWYoOnunVyW/1mVP0yRPP8zn25Hp4Lju8rrvM50jaiVCP0LbIAO1MiSg2REb5SFy5FjCdElKjetw1xF8P/p0WPMaNn/ilKnj6NAyZwRwLdtjXAuHn0KBjHYn5YJqVhFWHBLAqGemdFdrTikLJU5hCJDMu0CzSDDV+YThLAQMgD2Rb7Yyizp1Xb5MPIZcpCvQKzd67b1YEdRz8SFTQOfA0JRBMv/wAQe0Y0W8KMbfK1Et78WvDYZ5CmmQlcTPzv461RlJh/82pp6NPHqtvkCo5DX0dS8OwZ59HKLlpyyfP18UgI7AQwXDGRtxxLgSZqh1AJtUnH/dbvRqzGmJp/C3/2QZjNzzcMMeXUAtF3LzoM07Q2Wd8fLYmeboEY4ZEQXT7ughajIyWFXpCMAJR6ZRRC91m4rffNebbRt3WNEGL69jmvybwIG8t2Sg4U+TkAp6GwkGbpjknC9796UNKCqyZ0dN0CULmon+VnWcDQlMoG+RuQYIYoVU5ES6iQa9jW7xtmR6ToKREEhPGlm9Q2wriHnj8TGAU1QiTP/CaD0N0iSyjoiXJ6vDInCURCmKCqfQtBDLXEmeAY7jy5iMH5mEA7GN8GfriaFBQzoyFPVBzspGDiSzDDb6kdWvQpvofpjGD72VZSjfDJY4XuCHUdTfDqbV91792awW7Vt6gmUlVyw9sbBMGIM8qt0+YfoDhYPRwCWUeSBWJEGT3RIrldLKclOPUWjzupB+y+b/FR8HFNFwbG5NA7metf5Fy+yc35nv+8Q2CXKRvBFNmI
 ODAb2br5
 KaqWCXV/esBWEazuk1FTXPolkId9wKCwsp+RPlyX2wEeFfhnuckaMmGfJ0Hij4X/yIgwClx3cnp7PazI0p7r9faqwx6poxkT3eiC2NSLFCgL5xPBGotMWuIsBALs3SY7p3kbmc/c+ORUxMbdGkcyHUQT4yfjM6GBuOG2TZEXdOgKt6vFh2MRrhsj8QTuPCQ9FSkeeKbGGltHmNVukmpINb4GUcxLIyeiaoBIwLeWmuatC2+/BMIRj+cDdSegmWdmZI3eqOKT4p+vg0EtP1XgYN1hzHRvlB9p7F6PNB2J7AQ8s8mQ4PsTnkFxsQik5sDUKYI5oEQ+wuME1iz8fmF57H9AmDBW9NdHeIlfU9+b3Q7bzs4uArsxu+lQRtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 9:11=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> In preparation for optimizing large folio unmapping, we need to reuse
> the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
> existing use in mprotect.c .
>
> Therefore, move it from mprotect.c to rmap.h.
>
> While at it, change return type, start_idx and max_len to unsigned long
> type for future proofing against THP support at >=3D PUD level. Also
> shorten expected_anon_exclusive -> anon_exclusive.

I really think the `expected` prefix makes the semantics clearer, so I
don't think it's necessary to remove it.

If you really find it too long, maybe just use
`expected_exclusive`, since we're already in the anon context and
know that it is definitely anon.

Another option might be to make `*exclusive` an output parameter.
Then we wouldn't need to call
`expected_anon_exclusive =3D PageAnonExclusive(first_page + batch_idx);`
in the caller.

 static __always_inline unsigned long
page_anon_exclusive_batch(unsigned long start_idx,
                unsigned long max_len, struct page *first_page, bool *exclu=
sive)

>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Otherwise, the patch looks good to me.

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/rmap.h | 17 +++++++++++++++++
>  mm/mprotect.c        | 18 +-----------------
>  2 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 74cca0e3c7264..62ef511a6175a 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -106,6 +106,23 @@ enum ttu_flags {
>
>  #ifdef CONFIG_MMU
>
> +/*
> + * Get max length of consecutive PTEs pointing to PageAnonExclusive() pa=
ges or
> + * !PageAnonExclusive() pages, starting from start_idx. Caller must enfo=
rce
> + * that the PTEs point to consecutive pages of the same anon large folio=
.
> + */
> +static __always_inline unsigned long page_anon_exclusive_batch(unsigned =
long start_idx,
> +               unsigned long max_len, struct page *first_page, bool anon=
_exclusive)
> +{
> +       unsigned long idx;
> +
> +       for (idx =3D start_idx + 1; idx < start_idx + max_len; ++idx) {
> +               if (anon_exclusive !=3D PageAnonExclusive(first_page + id=
x))
> +                       break;
> +       }
> +       return idx - start_idx;
> +}
> +

Thanks
Barry

