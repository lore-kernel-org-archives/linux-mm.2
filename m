Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C505C61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF0D6B00E1; Wed,  2 Sep 2026 21:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6576B00E2; Wed,  2 Sep 2026 21:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BCCF6B00E3; Wed,  2 Sep 2026 21:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 202836B00E1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:19:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F6941403AD
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:19:58 +0000 (UTC)
X-FDA: 85170694476.20.E602D74
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id B40481C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:19:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r6aSaCa4;
	spf=pass (imf21.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788398396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgqTW+c/z9t5AbxEcu1d9HLyoIRvw702lxlM03yZwMY=;
	b=YPKSItQfaVRFlTZVY32U1Q6ZcBGT+s3HEixt9NW8jeSRu4tJyoReyupGUQNnZszN63bX8P
	opXswLCivrzstwV0v5V6PtW+AfjuMlaMaeahG5Xhzwth23vidZ6vI0vedUUTa2q8bXLLhh
	SSgORAPNGY7ioULHWWiciQ3ui5jv8UU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788398396;
	b=INM9642H6RrTINm03fDZxZaxmtiyNEpamkl5RbhKh3dU+CvYWVlw1G7vQMhYWJ3N5gzPMr
	J3MDvCfWF23M5bM8871cs8GPpovgRazpZuZmv6lfp5rDiKQAh6svq8vn7eS/pkkubdJtEr
	V6mWRJxH9npXpUltLG7OT/hUhY7XRLI=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r6aSaCa4;
	spf=pass (imf21.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48432729fb1so132190f8f.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 18:19:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788398395; cv=none;
        d=google.com; s=arc-20260327;
        b=HZXvDSv2CYDhdfoyVCOIbM3p+RY7+xJU7VBTFQ2LTCmB0XkB3+wNngilYqlXlrtG+b
         ZwQduBJcR17mbFfa84VMj7RSSW9Mahnx8kJheMxQxaXSx+CjyEHd7n2bfZIxKV6KzKOF
         LPoZwBirafGwJ7CC7ArDuoiiqoHf+QHkUb2Zmn7+mcR9Wv+5BStvNfts0OErhZpD5rfi
         kWHZZtcmY2Smdme3htJA67aZrGyJArsMIb/16cvkTMrdVo8dhQvrk4+1ZUeHyniMve4O
         5z0eTBZD1kIhF5fULs0mPN8ocyoDg17RV0a5lpSSMptKkMza4XSdxliWEJejaG10LFwu
         KcBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jgqTW+c/z9t5AbxEcu1d9HLyoIRvw702lxlM03yZwMY=;
        fh=LKlyHEkaPWM8xLmsfXkn2hyMG2kpqBGIA+1jFZ+NTIE=;
        b=Xgrl1JYjtEueH3AHR5L5KPpWHmp9oJ4ZIXyGQP8s9RlgklvOEIx/Wg1MCo0v3mziff
         Vbavs9NkeuMSUVfDLJsHzJn1lKiixZwGwhNXNsgjDklDvSTikrgqVQaP0jQHu8jNrSto
         LA/RmFeG86Jlv8zw17lAfOO8PhKkVyHOqJullUYbkiG2IWnrx9mMq7g4BvfJbYZvnKcl
         rzi391C4s2ShQ8skNLOUYbjsZ7NKZj1jf/tMN4oMpFrPfLw5zh2Pp42LqjnUZFNnFI/k
         9OkLg6TF5ZUTig47ypouy42xQs2rXmpr4bG9ALFsZiLBeznn7DvjnKFuQvuFBfnzq1rH
         Tn8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788398395; x=1789003195; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jgqTW+c/z9t5AbxEcu1d9HLyoIRvw702lxlM03yZwMY=;
        b=r6aSaCa4mMPv8qWvI95ghfM5Aeh4wyXkqr7QGNhBnbqux/uWwcVHKoR7Dy+z8x5Z8r
         DqWMeWEkWreD+SQw+kUUve4RujNDMLu50Ra9bznmHaw1mWXw/duoGn81Br3AD/vs3vp+
         w3Q0WE9N61fA0TXr9A1QKIHetcskApKaoMuVG8lLg23ojslSDNUlxmqddNKUUrFtPEfL
         2uPpjAw0WjMtDJNAaGlLt5C7+WMEr8izGEMz/Z3zThfyAG2n/nIchu01AWzgRIGWN7Vf
         lpwcs9GOHLlMEdyvxfBlFrJLHHUQbxZ+f3aW7Qt5263qshQgLiBeUtFZoZUMRti6A7sq
         wFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788398395; x=1789003195;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jgqTW+c/z9t5AbxEcu1d9HLyoIRvw702lxlM03yZwMY=;
        b=hUtWsSmdE5xrH5X3pWKAeDmRUQY4sB/rENKQvw/LQ3nAbiUlWdsJKJ8B3gfwY6/mTn
         EiMaBXSrVIEKpyVLhuuO5DR1kmjdb8Xr2MvYIcem8mLQtWqNVTcHRFoJTM4UihhByMP2
         2aK2MxJTixX96iE116aZUAR9yC/u2Y6ByHjBwHNVn7dvRAyNgYmV6iYY56x8f4NwBpF2
         mrsFE7SmvoOysqg5PJI8YmtYQjQwOWEH/s62V6pKZruvKShMTWzbat9vzeLpA8e37Yy5
         YCt8QQokmdmsD3paOhW1FNdenOhKlTBpcHmC6azK+xZFfFw2kTcxu40pDMwiRjjQRQDx
         YCSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxE0/OARqzNiOHzF+mHkvnB8ZSBjozJQyPwC10wXiKDQwwta/LgqpnwCE89pEr+zYvl7pqI6WiX7A==@kvack.org
X-Gm-Message-State: AFuF++lJz7G1146VEN/EgYcb7VrqESdFUDa3tV7Tzv/1iwt/PWCEfbmW
	hOf4vIkri7Z94xJxjF2oRmQXSUTsJa8tbCaRz3ZQ78laWtTpQeBWgNRLipQq650l0BdLruVC+nW
	8mksNu1/+LkCWYV4hK1pYb/7sT5T6tn0=
X-Gm-Gg: AYBFou2Xqw3WzFUC3PCI9Czexx+clXqLy71kU7l3UtGe0tkM8xU9CuaiKkCHtxA2oqu
	juBCxYEAEt3H5TYG/f9wBmvUlsMzX/D6xDDauHHCfMpeAG2zSoESpYGacZZKtFRAZNY0AH1NwsH
	gNK/ARJKPf4dEt+u45EUVHaQXVQdPdlG9uKeDKzS55DogbB2M7lLZ548t16bRxhelGDmPAhLz0m
	XZmoNmYrbVO5smV+ULgSRyI1mlKeGkQIs/TGDZ48pDkUMDiz/2JV7B0z8YTuWFpMs8DJtvunpmL
	RTgrka1BZJjkZht6rBBpjYed1V+k50L06YQQpNf/DJ7L5CaP3KOZHfdHmOzedLUo/l/Zg8yRe1B
	J4pExIe6itAKXr87yvq5Wjwcwm+XH
X-Received: by 2002:a05:6000:2489:b0:46d:ff8a:c8e6 with SMTP id
 ffacd0b85a97d-4847fbf7845mr8859062f8f.1.1788398394849; Wed, 02 Sep 2026
 18:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com> <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
In-Reply-To: <5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Thu, 3 Sep 2026 09:19:43 +0800
X-Gm-Features: AcwNN1XnLo6-oKNjTbE1kRt7miwXox33LCM3EiGymV9pOk_naJm9L63OQVRRrdU
Message-ID: <CA+qSx6zC4FmaK_UR1VnEGrHAma1vWeTi6v8abB-2QzW1-P062A@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Dave Hansen <dave.hansen@intel.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	usama.arif@linux.dev, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org, 
	rppt@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000000abb97065a89f31d"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B40481C0004
X-Stat-Signature: o5nq9egx5rxueyhg7cby4amcb18h7zmi
X-HE-Tag: 1788398396-637162
X-HE-Meta: U2FsdGVkX1/Pmdsj8ysJJ5N85GUWyEpPiQimkGDBWA5RGPPoX3XHn28zoxkQzmS8zEHPKkGERHXHsMl6ZA3Ouxd6Fui7+yI65Z4mahILMv2P8BnQzn+tVh8vew9cdCuCedTbVjKb5+kPKTR6lnRwqQ+lY+ezjq3J91VJ9fJGo+aUvQ/pz7Vup97iJ+SW9OxIr/Zj8nmlTE8zh1okCSCA3xYOjFWcDBdELOMcjcNtFzlDrdXDIj/aOwKTFe31evR+NjniFDHzyK5EtJO7aSo7MMXmDlCjrSPMi0FxsJ+cuWI4Mgp8ediB/sfZiL2yZ24/mZWFMEkUC9O9s658q+yn/YtySA17voelC338Ryw+Ub4G88MOxif0WiZosrF7fqUJAWymVp59NHcv3Ii9J+sYLerpztYtz+oPiIOZhshIS6Y1LMzMp7/ATaPYHtq7yIs+Uf1dWKY6zZ1qmYGtx6XbPJwOUF8FiOfTzcak5Tw8KpwXxK6CLkLHtrqyZ8YWubl2Aj1ExnrEaTaFRC9UR3eXUCC9t1mLVXDBESkF5T7i7HqHt/7WVbJ9dyxbeDy3w1TYuhyZS0qnV7G+LTgQRUvWc+v4wY4T8NY5X0DNnnAVbrEfIPK1iUxEEyOCb+pZ9HxdF0Uej7e472lvtfdMlZW+MrigaixeRxpgK5kn0X2W3kccqN6SPt5B3eMz+Wda768y84QIexN4NSCmllJLLXxr0J6yYnFaNLlAF7SSQfE/vbh9Y3/ByZANCSNyDUu2TF/xCecbIGHmhsgdawMUkdmFXJGWD/GDZrWS/Gb0cj7ZvkGBScufJgebo8kxpL/rRwxuQhU28hau4aHSCvt822PGbO5H04K8qOj28tlNjLjYXeC8+aehBA1s4arWabWPZk19hj/zpq0Qv+t3GtTsn2nd80LWIRXaHBkx6301a0BXmnfYfWBhqDuFN5XKwP4Z7ojxAlQVDL8K7+BzTIGofxz
 /C4YxDHP
 1gF3eUNNG4YAMxnvxMpDRb4/lQWGpuUoHqKYz1rW185DpwOgXG2l+VGLqkxxyZQNh8AKnCV0uGT+SNVNXMspOUKbUVxPYDL3doR4xhdcZh3B/gnla/cp3tqlD4CfRAOudyNy5phRmlE4OSFOqCD4PUEOpT7jgHKfykLkCD4tZUjb6Qp2BVO/xULebNNv3dbHwha55uRmGH9MLaP6zmbKLhk+HCOEym4xcgDGoqxjSJYikw6rFNx+f0OUyJfQixQVCxMDFFjGyQDMERH7NunItpYQ+8fbwO0H/p/2kPfgYLM0zwanVjeg8fsO8XluhlD2Pv5uSGVzJ0k0z5KFO7jypEe9o8SiVEP73Fheb+U7wxk1YxGn0bfcMvQwXQkMYZmZJYxVyLq41BagZQ8SjmgyaSYsZbcKu5zlapEh7MkLRkq1vvekSdYq2R6oThfbpg3/FLTfVCsg0fqMjMGBb8qXExbIcgP/+34M6J3d6YDH6MCjVe/ukBATEFSxEi/GGh/TIdlWccKpEDX7GMbGOla8NoCcFjm8qBt2h2sXwetleD2YvGqA7EeKtriDKGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000000abb97065a89f31d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 4:59=E2=80=AFAM Dave Hansen <dave.hansen@intel.com> =
wrote:

> On 9/1/26 08:18, Xueyuan Chen wrote:
> > +static inline int set_direct_map_ro(struct page *page, unsigned int nr=
)
> > +{
> > +     return 0;
> > +}
>
> I still really think the stub here needs to return an error *or* the
> thing needs to just be void and tell folks that they can't know whether
> it worked or not.
>

Hi Dave,

I kept the stub returning 0 for consistency with the other
set_direct_map*() stubs, which also return 0.

But returning -ENOSYS or -ENODEV works for me too if you prefer that.

Thanks,
Xueyuan

--0000000000000abb97065a89f31d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><br></div><div class=3D"=
gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Sep 3, 2026 at 4=
:59=E2=80=AFAM Dave Hansen &lt;<a href=3D"mailto:dave.hansen@intel.com" tar=
get=3D"_blank">dave.hansen@intel.com</a>&gt; wrote:<br></div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">On 9/1/26 08:18, Xueyuan Chen wrote:<br=
>
&gt; +static inline int set_direct_map_ro(struct page *page, unsigned int n=
r)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
<br>
I still really think the stub here needs to return an error *or* the<br>
thing needs to just be void and tell folks that they can&#39;t know whether=
<br>
it worked or not.<br></blockquote><div>=C2=A0</div><div>Hi Dave,<br><br>I k=
ept the stub returning 0 for consistency with the other<br>set_direct_map*(=
) stubs, which also return 0.<br><br>But returning -ENOSYS or -ENODEV works=
 for me too if you prefer that.<br><br>Thanks,<br>Xueyuan</div></div></div>
</div>

--0000000000000abb97065a89f31d--

