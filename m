Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1F9CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545EE8E008A; Wed, 29 Oct 2025 11:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51D518E0045; Wed, 29 Oct 2025 11:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45A698E008A; Wed, 29 Oct 2025 11:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34A808E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:29:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDA6612B15F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:29:12 +0000 (UTC)
X-FDA: 84051535344.23.F0F7524
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C667180012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:29:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dymG3BvV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751751; a=rsa-sha256;
	cv=none;
	b=1ZsHDdceU2HjEjmpY4klbKujizUe5ifU7DEcuvISbLd0bU7Kiv5T9D2Xzg1GRorOeTG/QQ
	POiJG+6we64zn6zk9DuoYOn+Zct0J/CBxpSbMQj2j3s46JieJBsygC+tNvrAY4wuIpfY9F
	RoPeO7TiC2GMbHFE7ENlxmN0JmdQ9fU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dymG3BvV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f625dWb+wusHB9zK0OBpFfEoYrOJJpBna/xRpvKUY48=;
	b=zyfWOAPjWrT6+SnUNiCImqz5IJvQWXqRl/CN7e+c5K4CvwcUbLFrPf7cExpmNAZR4DtoQz
	k0LrRnYKIExapmsJ6FF5hD745Iumujq/Z6Ztrwj9QiKicImwd55g7ZB+oUn0XIXe135nbF
	9ZZRriJ6V7t6P0eq/yIo89M0LMM4Jsw=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63c44ea68f6so12931a12.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761751749; x=1762356549; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f625dWb+wusHB9zK0OBpFfEoYrOJJpBna/xRpvKUY48=;
        b=dymG3BvVNY4eh2+8YaH6at+d2/kHNZRypArirKlTyVmKCrMcoiiqPPN8rl4N/HBmf9
         fBKKxu4w8oEXajN+a7bbfmVMRi0iuD3RedQH/5rkI5sNCVJm6vvHZC3VG3nB2b1dZmYV
         No36TVcaKZfdc9DPSrHpcxn6zj6wyCH3GOECBy/Ix9v5HoM/wEbN//lEgdCcfSNf+crD
         6g8WgFyLU2rKqT6AQg0aSo7pORjCPgef2uGn9ik6NtcXoqlDNLcv1XgoQ1L2XDu7qJ+n
         t8yiLCYwknbcCuWUClMjDV/LHC/BSEXkvkl7VTU1PJst0NASeePqRuQYMGppGRfVUwUF
         sXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751749; x=1762356549;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f625dWb+wusHB9zK0OBpFfEoYrOJJpBna/xRpvKUY48=;
        b=ccDHaTpjatBwB3HBOP8Vi/LA4H+UuERZZE98WLVR7PmNExO17HriNLV7/b/GqbNdux
         kexy/JjB+8CkLktna9k6o4KFQVUCmkOyKvJGdnciAI8MI31kkL5SEfDQ3wUrMHOnqcnF
         S1hWfL9CbKlbtAxBCnR5wJY0W0jyq8aThWpTCUSy+OI/w0Yd4VGIGta1KVpNZIHFda9z
         a9ZyusIiTSThCe0BQ9trsivDvOH1lvPcCas7cLQfe942yHjFpOUM8md5BIDimRZKC5Mk
         IdXHxzsnWXA5AKuS9hGY+P/FQWyWpU1GiCfpHmuFhPuG6R/30bYbOmSeesGnnYQR8g5N
         5DcA==
X-Forwarded-Encrypted: i=1; AJvYcCWDDT3K2Bnf+576DkZ7TCD+NYeilh5Oy8WPYZrhF/56N3zemMT1J+84CRDX+5E5YKp0DigL5D+j0Q==@kvack.org
X-Gm-Message-State: AOJu0Yyonr/b4xmS453UP1ty9tydoa748+HU1IIh2KGk8tevwcnJgGlC
	9+N94l31aOBHr7+ftTV1/3fVrHBL4f4O7znKxVZ5LAimRfvF9EjNT7I0WN6lxA6hlZtttH62b2B
	U59k5RK4QRa2Q9lZU0xyQFmOsi3mJ4et45nmZaunf
X-Gm-Gg: ASbGncu9YBSn+rNO4tONaCud5tgQMtXSTfGeaWo4GDuydDZ24w1rUg+RfODIeMOZLlG
	GSjNxyn+3UwwhutcF0KFamvaXUQGPVoKgc/emhQoUsRB1zs4XO+NjTW3KnH7qUi70FaY4sDsMT7
	zgXKIXCCQIl9tTOCmjvPc6y+hBEQVNqFfglKX6LgP/PGrMVkvEAQqyzdgSEo1VBtnP3rBfWyl/k
	hkT8oPIIYLVShKe5le0tKfH29MEwsGgUvHhVRvjdmGD3Sa5NFkbySKJ7APTdNZ9GGAi/sBkM196
	j+7X3HlBnGcQbDM=
X-Google-Smtp-Source: AGHT+IGJr15cLDbC+fbHSXbTnzvTz28tTliyWmFftwEcXMbXCQuxnWdN03oQ6RERl24adkiisnp+L7hn3wCKpUANYfE=
X-Received: by 2002:a05:6402:713:b0:63e:11ae:ff2e with SMTP id
 4fb4d7f45d1cf-6404519b54emr90964a12.3.1761751749371; Wed, 29 Oct 2025
 08:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-6-harry.yoo@oracle.com>
 <CAJuCfpG=Lb4WhYuPkSpdNO4Ehtjm1YcEEK0OM=3g9i=LxmpHSQ@mail.gmail.com> <aQHLDTwwEuswvNWv@hyeyoo>
In-Reply-To: <aQHLDTwwEuswvNWv@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 08:28:56 -0700
X-Gm-Features: AWmQ_bmezBnR6pc25_StLvVfGCVbr2qQzQa79QlxZjsxwYQHjSt8eI_UKHmKW6w
Message-ID: <CAJuCfpERqLpAkbK-+X32s9o2udOfLtqeoU5=9BykbucFePv7Ww@mail.gmail.com>
Subject: Re: [RFC PATCH V3 5/7] mm/memcontrol,alloc_tag: handle slabobj_ext
 access under KASAN poison
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C667180012
X-Stat-Signature: iwmtxjoqeionus58no3knin59aetsshh
X-HE-Tag: 1761751750-670663
X-HE-Meta: U2FsdGVkX1/xn7YTyd4ZgKJBMvEdAtNygbLVjhI/pFmdNxsp9vjne34VhRmAmEZi4zHH5EbAAQf8JVR6TYYfwfxoNhBlrA5dG3y/QoLTEN/3XtxzhZf98oC4zP2jlvLI/J7CFED87YPvF9SKXHkTpibT8mzFQeKQ73X0pz3zcaTrShSnH4nE+VnKDcii8erAulQATccGGlu3sbFO9pVTHCnIKLqK3KAAcP/3Pq5AGKjqPqjREDEzO+8ab31VLDolJ+6XEzvffk7/ZukY5mq7Q+JzHhbgXDTRmei8CGqHwTbyBmjaM6P5wkmbNVE0JRvpidXv6dadPaO0y1Wz8GMmucDXWwvSh4KDEb1ZVVkxXEEXJhW+cM/e3ohu3Y4hXHXdNVLhEEVqWiWj/D17pMpeOej9PcSmHfR/i0E8UOgDAgdDQHaXmqgZiGxAQGyoqOycGnipT3NY6i36SHtM3ADXssauPKCWSQhlXHtGgx7zJCn9eCkxOEj34vhhNfq5jTwn8Y21TSX6XSclbnpb9eC5YsUpPfK+57NbYuvs35elUtjiy4KsLjFdOcU/NFHag3FHptxm4rkvgpuvoeoZBp3iGBKI8jIzW2Mgog4qOTXMZxRYf10uZ7pV42ilfMyxbGzXSjNTeZnKAkIr3dcZnY9F8yGjr9JMuTqVdv2OlDqjIaoS9+KkJxXOgNe2btoC9t+M5punhjN2VfLk+rMgbIjklzhAvL7kwHdb7dQ+RhtmWYQtgVc58guUYDGaMCyouJ5bW3mEqQ4d7Q3H2idEhdLCDszbL1ONxDcRxPux2+Z5qLTB+NpYgxqej9k+cUB0ZUN+ovE6XWGI3AeMEgqrEvRddavSjn7F4LErgOQlihJJKn0Wba0vCUwXw+k2fz6dt7A2aNfazUE61ljH5LeiZdcMs8ohEHpWk2xUnbfAat1jUGurk//b/SUHq/edFUbtGDZSHZYlApGPfaZmqqUKYYm
 /O0BkwVo
 Ts3eRiKLKp/J/YuPZyheFsmg++lfna9aDC3Wte8Px0SniXUOrCS0dF3cl5347TRD20AsZ8BNeS17q7b7xT/aGRJu6T+cA8imsu6/xsfROO6N0O6xbYsACtGLcV2IET4whpxchX7x+TMas1dxd3SwCgIlzPGKYZqZAI/a51BrYIASkva/uENKDkiC/HM4t1xANXtcQAMUB+rm/y6UlcXDXM/r8OfLRuP0yyn+q3zvidRTVSYxRsxR8lCF6kqNKeEMgDq8kGhhaCLDP2bKwJPHDWd6CBRDXJZVo6pBXu26EL2utZ6QUgFNFmmjy9hQAC7gYOKD24a/RoI5U2hIlb8frfrEQ0iFhJmqlOys4I0btHnHpXAY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:06=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Oct 28, 2025 at 04:03:22PM -0700, Suren Baghdasaryan wrote:
> > On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > In the near future, slabobj_ext may reside outside the allocated slab
> > > object range within a slab, which could be reported as an out-of-boun=
ds
> > > access by KASAN. To prevent false positives, explicitly disable KASAN
> > > and KMSAN checks when accessing slabobj_ext.
> >
> > Hmm. This is fragile IMO. Every time someone accesses slabobj_ext they
> > should remember to call
> > metadata_access_enable/metadata_access_disable.
>
> Good point!
>
> > Have you considered replacing slab_obj_ext() function with
> > get_slab_obj_ext()/put_slab_obj_ext()? get_slab_obj_ext() can call
> > metadata_access_enable() and return slabobj_ext as it does today.
> > put_slab_obj_ext() will simple call metadata_access_disable(). WDYT?
>
> I did think about it, and I thought introducing get and put helpers
> may be misunderstood as doing some kind of reference counting...

Maybe there are better names but get/put I think are appropriate here.
get_cpu_ptr()/put_cpu_ptr() example is very similar to this.

>
> but yeah probably I'm being too paranoid and
> I'll try this and document that
>
> 1) the user needs to use get and put pair to access slabobj_ext
>    metadata, and
>
> 2) calling get and put pair multiple times has no effect.

Yes, I think this would be less error-prone.

>
> > > While an alternative approach could be to unpoison slabobj_ext,
> > > out-of-bounds accesses outside the slab allocator are generally more
> > > common.
> > >
> > > Move metadata_access_enable()/disable() helpers to mm/slab.h so that
> > > it can be used outside mm/slub.c. Wrap accesses to slabobj_ext metada=
ta
> > > in memcg and alloc_tag code with these helpers.
> > >
> > > Call kasan_reset_tag() in slab_obj_ext() before returning the address=
 to
> > > prevent SW or HW tag-based KASAN from reporting false positives.
> > >
> > > Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
>
> --
> Cheers,
> Harry / Hyeonggon

