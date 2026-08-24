Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6390C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F2B6B0092; Mon, 24 Aug 2026 07:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E772C6B0095; Mon, 24 Aug 2026 07:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65BA6B0096; Mon, 24 Aug 2026 07:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFA126B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:05:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FD89140472
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:05:48 +0000 (UTC)
X-FDA: 85135882776.20.10896B4
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3C7FF1A0007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:05:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUFjAjDz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787569546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xbWHx8W1MVljpMD2nJgZ+iZRUHBwV4fQn+7ykl2MkBg=;
	b=up77xyba1SBvR7nU9tUPGqOPYJTaFhV8UjwUUJVwn8zwMKXHWomlsn16+xf/7VHDcGJN7O
	T/zzcguxwm5dZnG3h1SQlj+CuNvaxPp9f4F3W7f9p1S/IWfnrEL3gQkCkStMMtAIN8qzKH
	lpAN4vW8VEPwRrYyj2ShcR/bu/N3FUs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUFjAjDz;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787569546;
	b=WIakAxDnai9Ndkufq0r+pjUbSdBXTfyuuXyvsQ+cpMTBtqos0U0kPRqB7MDtp2yrEPXDNT
	eYsewoLgV4hVJ7v37sGDh2qPYPlpaubGiJ8F8BCM4A2M7ab2jflBKivcdHyenuRzUrj9I9
	qIykKDGVq9akd14OQhjT3oRB0s7nnSo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6a0c8283146so5669364a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787569545; cv=none;
        d=google.com; s=arc-20260327;
        b=KDon+1qrGKbWyNkQtlABxVtjpdJIeabrg6d+uLDt3OdcQJaHS2pN9uBZ4PslkuCbRt
         xaLqqzuvFSRri0Ectq+qKIqNv2ySbm0HcUJrhJqwC/GaE5/mTzf/vdkCC0IwNwBkqMSk
         nBT4UwJcpCukfgwY6gxN77R6pVnkSTRMYukClleIOHwiUBDmN8J+gbd7yhpdkdbIvkTi
         33CFQ0SPdvOGCBlUUCw9grk1FU8BGNiErqtD5ALUfx0b8k6AWBJkQ3M9tXK1e7EkCY8K
         Q58/RTnG/ntaixXg/LXi65GHDgU21Ng23LU0NNvIUPMEulq/AhuhqUw67y/WIh/wFhEH
         7VgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xbWHx8W1MVljpMD2nJgZ+iZRUHBwV4fQn+7ykl2MkBg=;
        fh=1ovLHli0DJ+fNCfpl1S33NN6LOm035aN0uCWbI9mXRg=;
        b=rUIEMXZKF7Z9/KaF2iyoDcM0WzUOCZ5a+GuKMcfLLb/4yJhQDqiiz/+E+mhROrC/op
         prnpc6acyEkE3YPWnk/sIC3TcW6j/nK3c8JYpcZT/fS2IiLDQUwd/4sGFEI2aOtREIKK
         r3bvt7YOJziHey4ABGZ7nSOrPM/QiQwaV0T+Vqg660c53+th04Dt2uYBlIXBHG0r/7kL
         jT3wOjwWomYHylP3INAM7xgwThRSAukMw7NwrBWlVbx5vcg97Mz+PpzHfIuUvD0zF6NC
         kneg/bdAkDiC12EBllaiJuf3dSgMJeSvhRIywnkYD3UhobgzaOKLxolhO2BqFa8bkIUI
         pbGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787569545; x=1788174345; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xbWHx8W1MVljpMD2nJgZ+iZRUHBwV4fQn+7ykl2MkBg=;
        b=MUFjAjDzO+TlPwrpJXcO1jzbZ0q8LxAR3D+c55Ghpp09QMKIHUB+ynN/06E64Wr+WD
         5XZl7LZZccYs5AqcjZs0Vrshrv2w877v5A1F3/1K2i/C2HvakJobHO4k6JQ8zyH0tqDu
         hiIH34RDIWbm+chk9kXte02Ks99cY/TgiZZcggGRaKZ3tyqJN0MAJ3T1V7jGN4KKwBSl
         tHGDn8sd1DG3zr6UY8nibUcDNf41PXXpwFhgj1KH4W0SVQvRy+hjj1vu0QMhOhVF58s+
         WKzhoimbRPHh4zQ4jUAgvt+FEK6llylTm4pdpoVqr99RuCrEeEYrfRwN0yGQDgT3YPjN
         PSJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787569545; x=1788174345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xbWHx8W1MVljpMD2nJgZ+iZRUHBwV4fQn+7ykl2MkBg=;
        b=TPqBSsF9ZL60Rji42tnfvCrFbE2/uKTk5mRxhfhSMTTcCn/QdBI6Wvp13lA3/mUbfB
         1pb8oeabzm1dm5g0HcUdIht0qBId8TV8lGquLfzmuuHzO1/RbP2FOzIdyQ8tgvjINf4W
         nWlrq23ZXc6s5qWFKqFeXWKcu5+XSaMzn4sTl5o4+orlLz7218EU1+R26LCnfGGIpBqF
         C4L46YAOOhVxRMybEnPfolOndlhieUDHoE2mv9DTahh9Ivtdej0W66n1MboPyQ/4pghc
         EepP/KgESBeOEiajw/WGuPuh9l6Ahn8TyVbApNaZPooRZ0N93SB0jJztJaOlugbVoFgS
         Jtsw==
X-Forwarded-Encrypted: i=1; AHgh+RocNxaWPSW/MF2Retsj+BWkLKJE3jPzbquL8MW2YOGBCYpFqedEK91f65SeFhuxhYKMWvluaGVUUA==@kvack.org
X-Gm-Message-State: AFuF++lFiufsYl2ETUoSv0cu/I0EeVcc+z4MSTUnxnqOF6NL4JEmLePa
	QBwAdsx84Xdt1rcnF6RQgSNNV5CP084IJ1Cs1TuFqgusL4P11L55LaTxCUg7Olm6kASn4/vU12Q
	xLUEc0rPugP2wkFprI4SjxRZ3Rhkq7SdF0eWMYj4=
X-Gm-Gg: AR+sD13053wvPz6MCC2ly4HRBUBpVRBLjShUsbsSh1EYZDWg2AWQG/suBUWTEZTK0It
	HoBW28CkHqXTOwkPE6Xm6w9+1fi+l4yUsC1R7a/q82t9y7RDXt1DZO8GZHVBcNhSV3aADXHiaeZ
	a49zQ8ta52x8g/TGsJkTj/ZsHxukwVddzp8reXs/flF7ML+wgztDDDmPmmBmzUE/iVuLWzkCqEg
	GExFNS4pggLudUPX7k4If4KvmQdS5KRcr5j4ZhpUbUGpEVWi5umeC3vlvFE/ndBz3kGQI62itT7
	bszSFTMlIa5ZFIx56Fii/Nvk8LaniX0g4ejFfouGwdruTpnaTTxgQ8IzTFJk/+L3VjALVoNw1kh
	rJsHZMjzGvF4T
X-Received: by 2002:a05:6402:a0d8:b0:6a0:926e:f907 with SMTP id
 4fb4d7f45d1cf-6a42f184b7dmr31867176a12.1.1787569544515; Mon, 24 Aug 2026
 04:05:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
In-Reply-To: <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 24 Aug 2026 19:05:07 +0800
X-Gm-Features: AcwNN1UPfr78Gu6KdSgUdG9sx3OPrdXit-fwBczuLNxYcgUffHGSUWogJ7UVBXg
Message-ID: <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3C7FF1A0007
X-Stat-Signature: 7p1cixx9uzzgkyxis67y7gfs73sh35q1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787569546-25026
X-HE-Meta: U2FsdGVkX1//HNyrww/+RTlAtE2MhLTCE2uW2lxxl4eNyR4cyc/vlbF0Qt0zvgKWxQ3NKM1kJQSd1+BnvNhzDT1unax0boMth0dO2MHw7FAZPhsbQOkrPGBRU8nO7RgzYhJRpM+d6jQU85YsYWd7QlYSnoBc4O5bYFI9IqLbHUbASD75izz7OVQHCAdu3Z6SZGEyKLDifgmi9QVPpZCWbR7WW18hKZmjIq2sF3FNycnd/Dr384JrRrdrT3+bqrthEE9gNDAFg8SrjstWsAjzDzCzBPFfeJShnv+LwXt3dYO7KbLyUI3cs7InZG/tSNpmAsqmc3qiFIyo8DxHpIcvgx4gZbUoR5JooKLU7FHC0PexJp77vutUtblMx9iN6GxU61CvFsA6o/H0doOK5ba0iKg2ebXH9dDUn/cjSOMZq6v/U7xds3OmZMjAkO9TJgjKqw0fSGox/8aNR5Uw8XnKehE4gb5PTdDt0MjcBFluAPgqmPSQ4zVwMn4jMIeANrcriWrS+OL9CVgT/1SA/ZXhjVGtBjr36dDGOI/rq3LMYOmykstNb4VWFNz8nTmai1fr9cV43JgPwX/aKQL4j96bk135/XehWSsCimMSQ6VreBM+Y4fqNAXYLTr6MTr8wu4vdJ2267NdXbU593Nbt+D69fsBJJyuXJnB2Ml2rCjkBNla2pnt50zXsjDZPsXpWfCmQI2xYbUmRlv/IPSdipCLnTD+qSFzZ7Bo12lOEzH4mXnPSntTztbqI+aBcroOgdlcSCb1YMij4Mp6D0DSYMMdC+UM2wVl8/st87EPl4tW4Ux9af+hkEp+XNqBlzTYWzaHGEFf7uVV4NdqsQEXDPL/3/ZbsO6fBIBDjUsROeTPDzD1P1/DR8+lHGxTwGAE3JcaidN/WUwqMtihzpF1SqEORSqRP1LfxrSUMcrH5ODC1PVeqBksaxewl47hIQTGnLilX7R8jAU4HQygpRFHdjL
 4QwG06IP
 /ZOjdi+V/wZVUm/CFksmQap/K4AgiAMBO4CLDEHHWW1ASHO2DG15MtalJ1kAW37d2VnKteGAViragvnwIkn93q9VtLchQe5VyhfoerOdHZX6YuZH2gtxCxxTUH+YkzVN85ku/FSu7yCsWCvV8bfhWzGJIzyqfou0SPRbc3RuBqYQF5q0qscYYWW7vFqwC2vK3hYrC4N/enKLvtKQD1OotA90Gaj7gYFkrUQD0kBL/8kvBkqOGmYgKvSD3xvIq3Ygc1Z2ync4vj2EcSuc2ZiChZa9rEy3QHLVPSy9SsjVj2F0B/35VaFsrMZPXC4hLYC/3lyl5wREMuJyXeLcr0nsTojs0Rn7E3KZwZPyl2tSQaPptEgp565lHl7BgcnEaBVNTNm2xQSwJu9d3i+pxhu8HrwHmzfNI0Bdnu7oVbVXN3mBgupTSuFuOt7JGew47Ctzc8nJjo6/JCzqFeyKpEGftynaimHZ01Twzs/RMoNucBEqYVfvD6Bs+UEClwlJDIub7YsKGroM3yqclfF7HK788kX9UwWF8k7GY+V7PyNdbe183VOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 3:25=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> > This is a cleanup series split out from the MGLRU swappiness series [1]=
,
> > with the cleanup changes separated to make them easier to review.
> >
> > Right now, isolate_folios() is quite difficult to follow:
> >
> > 1. It uses for_each_evictable_type(i, swappiness) to iterate over the
> > types, but i is not actually used as the type within the loop body.
> >
> > 2. It uses scanned =3D=3D 0 to detect whether the current reclaim type =
is
> > exhausted, but this is not an accurate indication.
> >
> > 3. It has an internal retry when no folios can be isolated after scanni=
ng
> > some folios, but the retry is implemented in a way nobody can understan=
d.
> >
> > This patchset makes these behaviors explicit and much easier to follow.
> >
> > Run kernel builds for several rounds in a 1 GB memcg and take the
> > average build time. The patchset shows almost no performance impact,
> > with a very small improvement that could simply be noise:
>
> Just FYI:
>
> I tested this patchset with a 3G memcg limit and a 10G zram device,
> running 'make -j32' to build kernel on my 32-core Arm machines, and got
> some performance improvement for ths sys time:
>         w/o patch       w/patch
> sys     1845s           1570s
>

Hi Baoliln

That's a very interesting result, can you share a bit more info about
it? e.g. vmstat? I'm curious how this happens.

I suspect patch 2 or 3 changes the swappiness / reclaim / aging type
selection behavior, or maybe it reduced the reclaim amount?

