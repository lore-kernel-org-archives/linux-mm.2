Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB12BCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E276B0005; Wed, 17 Jun 2026 05:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F716B0088; Wed, 17 Jun 2026 05:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFDC36B008A; Wed, 17 Jun 2026 05:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 902ED6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:54:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A9B0C0A89
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:54:54 +0000 (UTC)
X-FDA: 84888945708.10.ABED0D1
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 08AA1100002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:54:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bBFEpBYp;
	spf=pass (imf05.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781690092;
	b=4BrCSWSw+jjYS6KU0YVe4nBMAMu+aRuJm/vaflphnMnt9+veaSQayuv6jklAYKZp9LSvbc
	OflzS2OpHAw5XblNIL3H/6sKSS8/JRXj1sdtLPIZYJSKxMic4TOuZG5iyFsbhJuMu+R8Av
	o62cKO/nQtryMt5B+qk3IouiHWU9vcc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bBFEpBYp;
	spf=pass (imf05.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781690092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKF34iFNpf0eQktLcuPksLJYduBCknZ/BznJRp3knLU=;
	b=2f5Pq49pQwl/pB/MFlhK+Few3d60HDk8iVe6lPeGWJrKZiBIQXStsQoVJQ8Z5HK6jmJcuJ
	/zVNNJ0HgjS2RYkrR8iXKPZEjWzLGRTdvxXXRDGq3fV/VuefOubF0rkhkLdhiupVX3h0VH
	8hc31JpCAv9RWAQ4FyJSjmg6sUI54rw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45fd464d51fso3267647f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781690090; cv=none;
        d=google.com; s=arc-20240605;
        b=UdH37BNri/bNgsQS1qBqhFWYlQI//HYi/X09dizT0Xr17WNI8CHeFhDvmqwN4L0Kbr
         KYhoZhnvOZh56Yb79YjXkboI1TCgWOWtAWwMRrgZEt6u8i4CvvVhVAkLvLGYN7/QqTk4
         LYiNFSlnG0Bhtyry4HIpEbhB4HK48gb1sKNUQw14WKRg+dnFW3osi/LL8UIBTTO8/aQ3
         A7V74eKm2gzu6Oot1o4Y8Br1Gu0RMznYyqEjp07hRoKxz8Cx1X63BDRbUx1VoK+oJRK3
         Twzo8oqNI4qgKM1JitjHfxq+kRCglQ7u0IrGtCOJ8MhOujA7bwc2KGFCb/rIT/PqXtom
         4NNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WKF34iFNpf0eQktLcuPksLJYduBCknZ/BznJRp3knLU=;
        fh=kNpfU/eYkz14Pk5BZf61XZJ3LLV3pfONCYEfAyX1t6E=;
        b=Qu8dNV/v5zd8RVTfJXJrCwajP3URsLofszGM5BF0NzPRtnJv0w3JiiiOz+UjFldzs4
         YbfyexdKBYq308+dSWmVEhSkIrWvbwfE/cWWhc/p4eEjXASW7v3TQw/F2qgQGfOO+Hwn
         EbCT1LUNeKBi8knxk36LCN2MuRpuFCuSLZFt/74CyP1r2mzvD0AHdvzpTotb+zvzuuSE
         ECu/jRI6Be10O6IlO6av6AmCiynMvhQg2ZqKIE5y+DZ/oChYPNtyji90gx8Yh5OzbWy6
         L5Q3Rh42qKIJ4tiNcxn1jCO3ZSY7VQ2Xmlha/MWZ8K8Jm8YEvQn1mbf8kY6f3oUK8ysP
         L+HQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781690090; x=1782294890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKF34iFNpf0eQktLcuPksLJYduBCknZ/BznJRp3knLU=;
        b=bBFEpBYpTzRvRmFQSZlepFBnRJem1yl9bjQu7W8thQtZUmAqfdNwJ4OFM1xGOElNbp
         JNYA8sn1x2KWFjfY/FCQOtjeUDjB1U2QZAynwOFFWbbUTtxUBwaDKEiekB/HXOM4VtYx
         dw4VGrFbPQdnx8prNa7/cBoxJKAalNdLLmuqI08lWvrTZAbRPJodwT93CD5z57qJ0TAa
         e2xDmc7EYpF3gm7WgvlOXerlaTf1G70f0TioO2jzIhQZHOVzTXY/+NBjyJTBcBuU2ITO
         jrFvitT79ZPPU+C30e6HpmKpE6WwS9bvSbaVBhJlOpfkbf53lddYKq0D2OiKrmuQvOqu
         yfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781690090; x=1782294890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WKF34iFNpf0eQktLcuPksLJYduBCknZ/BznJRp3knLU=;
        b=NZPBbJlu424IuUGObokIuWlvYve/bFASwoFFkvZPObXphFLZs1BrHRDDGqY9QilrZ0
         SwZu4RkxXiYw6xX1oQG1Snk7IUPF1n4X8EGmAXIQl3Tffd2HI8mmOm20cWyZUIb/DNw4
         7VpTfyXMqFEJh9kO9cv6JHIrNB6WCulRwaZPYIvCvnqQUJB8tfFIpEZr8lq6gP825CEf
         plpIaZdO32gT9fRtPH+1TY010nftJaNClpTf6i0A9liFFlktO3Zcm0cxfWROnVGi4HOQ
         I63USqWgJ3O0YqnwD1Plx10mqvlagFnnqX4govdxwgIbsK/49qNWG/lKyGHiq2dqNheT
         VxRA==
X-Forwarded-Encrypted: i=1; AFNElJ8Vj6Q99Lsg/VSD3Ko1/BhcVKJEzqSdEfXZQBgzLKf2E63pUI7JNRtN5SJFL09ZIGouMG1GGl44Lg==@kvack.org
X-Gm-Message-State: AOJu0YwMAZsy33XbH6gAC/UkFJqN/+Myy7cipVnTHwuIc2Ibi/fwyT14
	faOZmnsztvktBENx9x+dP5MEIgupf/rIQLdyvcUf9l4BXMOn2/hZT+sN1G/F/uG/4UFxSLcBzEA
	KWIGBb+tU+VYPBspDzkd/1psUPu5alrNIvqFoYzzf
X-Gm-Gg: AfdE7cnIkFCdt+fMX4S0Nb2zq2ii8p/fOqN8ZAJw/ZtVrUIWPcQwE4/VawKCE5wp2X3
	GTweLrpnrQ/QGiA1zDdGDtpe0MYaYZ92wwcX55wbhW+O13r3GG6RDB4RxMIs6Lqer/uLDo8P6BB
	17ZarbTdgOS12G6y6Z4Ijj0jTNYU8283YI578lvqw4ACHc5i9PdxVsq/CXIGzMhDpcNH1s242mM
	WcDXTdULdQY3gU7ZLHe9OpCgEDTt6xpsJlob9AmS2Ogih0WxgUxIfVI62s6dTrzlPVOvehSTV8N
	AdCFtbZrIoKUGVZTITiD18m8dedJBpwKXaxGKfEkukQWQ/sfVESlpLITdgI=
X-Received: by 2002:a5d:4a91:0:b0:460:f36:79b0 with SMTP id
 ffacd0b85a97d-462376a4df0mr4361735f8f.19.1781690089839; Wed, 17 Jun 2026
 02:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-5-7b4c3d2930b9@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 17 Jun 2026 11:54:37 +0200
X-Gm-Features: AVVi8CfPlpZsDlv9ciJ6wpjG8CPXMs720UTUcxwfh8qgpqFIXUpU1m_9T99wYrA
Message-ID: <CAH5fLgggdf0CM0o4Oa1VbY+y8gQxrU0VU5z_yB4GWCxnbqsFuQ@mail.gmail.com>
Subject: Re: [PATCH v17 05/10] rust: page: convert to `Ownable`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>, 
	Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Igor Korotin <igor.korotin@linux.dev>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	driver-core@lists.linux.dev, Asahi Lina <lina+kernel@asahilina.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08AA1100002
X-Rspam-User: 
X-Stat-Signature: 1quc9hupxm6fce8gprwhfia83gwei6hx
X-HE-Tag: 1781690091-513481
X-HE-Meta: U2FsdGVkX18ISw3syXfk9T4apWYrec1vIq4Pq/NBJw6Dgd8dJWTN5TNwHro7mi5wjGVRm4xwCr/1ksn8I/8Hts8ixuRg9FMSGZfdKgPlGeRisuNvt2WmphpnYayNIj4ozWDjSqA8gzOEzITtTFSOOQVvdM/s56tBMqM4vmd5DcLJF+uc9djss6Lhjz2Bf3rgeKSKFqM14prJ1AhP8AQ2OtUFwpG+aXppMaCK5kJ36PYvRlELDulPwEkS8cfga+ksLs27hmICzbl4W34P7K9SgR5mizYq/3mr6bx2svoPX1SgCGQzrD2dLwgVIrsTUE3yUgQaVXyX1zvXBJkQKfGhi0weiTt3CKMl6BA5w6wIa5hH7w81LT7lH24k/NxLXtMuNQ77Hu767FF3y8wijSTvNRtbZm9vJqCYWN/+rM5cxkz1UMPJx8QZGkTKTSTBNpCmmWBnuVQJDOmjyBIUW7OAixRyePFuO2CUwmCZaJjhrE0yfPrpHsdDn8QTqTu4mJrDtgptJO7NmSrTnUbYrPjY3lSoRWWWMlh6RiIDP5WgMuyKHQxcCteAEdZ2c9Y5jEoKKPUh/R6rZJasCmcuvRo1fCP51Ze5woFysWv7Hl9vF3booFCFtCTMtYnxxNN1+sXxnbZMMUSJJ46kJlDRR3Pt3IgtpQwdtQw5oHJKvMcNQILQHxQTpIHs3xv62XeET7n2d+Y7s0X9duTRRF1lGHr6tjckp74jLVEAml4hl/tWIjKGoA+ILQxALYP9gbiqKeRXGZWH5pQ5NGwKn6CfhR9fZTRkZIoYZTVwOFZD/TApngzj82M4k4y1Ee6URfzNhLn+ZR0daDwUUzijs57g/6On+ozbAgwVCg+tOifFIkcgCz4D+7Mnh/MRkDLafdZ1OoV0B7eiCq98MiNKM09RJ6u93K3nEvgBDE84r14P+cP3qnUNfuuCak2BlF4bMl/SgNT/sihybXZ8kfrRt0eLDwU
 GwEI6U4O
 GmiHATMxD3Ha6Zmz374W0X3xx7pnk+fXN53RbTkGv+O3WCNSrd9aGVh/T87TpU21hKocW0fIXT23TBE8fK/ndYixfElp+aHirJ5V4ZWM6tigjOYS5fwYadQfM5kJVJ47GQmNxxvBEEB43UmfXxVzk+KVQN0V5jKBlGj9IoDyfKMHZe4DTdFNo6sSIlckRw75/U/4JhvqOU565pPI50wiUR6hmAZ2/DJ3hBJNGI4phklgaGSca05GYcuuwIeBwykorGh2Vt9TSYBaPpyNuzimfwd0W7X3JAD+EgDN7rVHk+ezzyeLCetQGdV9W5Xzyv833bvL+ObrMW098/eCpRjLCRg7Lxh8MvzgvdSoL0dmWhQuSa4IqxUZ/Q2iSoYYUp4Fj3zXl0MHfb48iCNAajXCR6HR5o4JjH0jryBFW0Ecol1OnK2g89BILS3fvow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 10:14=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> From: Asahi Lina <lina@asahilina.net>
>
> This allows Page references to be returned as borrowed references,
> without necessarily owning the struct page.
>
> Signed-off-by: Asahi Lina <lina@asahilina.net>
> [ Andreas: Fix formatting and add a safety comment. ]
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

This will not compile unless Rust Binder is also updated.

Alice

