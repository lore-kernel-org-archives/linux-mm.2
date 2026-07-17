Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6154C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941C06B00A9; Fri, 17 Jul 2026 12:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A7F6B00AA; Fri, 17 Jul 2026 12:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8311B6B00AB; Fri, 17 Jul 2026 12:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5F56B00A9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:02:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FD77A01D3
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:02:28 +0000 (UTC)
X-FDA: 84998735976.01.7AA0779
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C72E100017
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:02:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjsBwWxd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784304146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4EpY7AJQ2z/UEGmxEkcHSNHDxA7dCAY+EM32t/GnvPo=;
	b=rjfs8qw4T9k34bCKU/XeNXumXzVNdECF6LSTmfI45cspnuwyzA5IAOxoHO5rmWonkWoDwL
	g8ViwebRwf1zO9sWXdH14qZlR5hjB5tbkvOaYTqf8ZgSl4AkBHHvmsKez3jV6ev0NMLwWu
	KtFpghEYuOyukHCBJVrerK+u+muOxYY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VjsBwWxd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784304146;
	b=muY0xWPjW0JHkUYAiKf4XVixbtPcAtrJBo4oLEscVT3w+DItBvTVqPUpdyXCJuQC2058T4
	tZyqU8Fae6BkjiZZRrtoc/QvzAz6KEc33d+sniiKmh9Y6jadZYdJllzdEdcPMA5PuBow8R
	lf8yGrEtrF60eW0tNufOCfifiYxtvSs=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f633e6058so671540f8f.0
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 09:02:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784304145; cv=none;
        d=google.com; s=arc-20260327;
        b=REx8bAt+iywe+d/vuMeivGAjn49pnNCMow7jWjTknSvlLH5nUjLfV9RJuxX5ugneq3
         7ca4KxxGbwBh+T1MGeTDva3JVxbccEugNLoVX5Tw/7fJOTe3AH7hD1Gr3ZUJAa+bb2xG
         wMO7FqiMQguIDdsYkSCMM5J6Y8rHveN5dm0LY/ku9tUew+DT3gGgR0irImlBRWABkZi2
         FnoeA1yYytRvXmFz9jb/Mx3vU6+lpD3+31IGQtmjAQIiiWiFJGpRVQ4X02rMonmLylzu
         rRAiI9hzmFGXBVtFj47od+ZrgvH/q7VaBSAw3t3RbjQ6bOFe2Sj8iDMMiReyUb/LtRki
         F54g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4EpY7AJQ2z/UEGmxEkcHSNHDxA7dCAY+EM32t/GnvPo=;
        fh=h8RNFSscKaBMTvh8yfSBD2H9C31gZIZuPTManx8BEis=;
        b=Twy887llttWgf9u2IUNo0/XOjarLpjcXQ9muFrbjw/KBJaCsxQvFt2qDHQDCeXZScm
         hHV22iMz/WadI9n3sAkWZzVcK5/+lQvlibjGqZ1arYoLSafxfz9XcTEy8LFnm0I7rkAf
         K6XeXTCIxubZ9QPAiDacfXq0xy4D91dP/WkiGSUcItkT82ouralIWCgzsg1P0nziDYiV
         hfn2NOhKRRFWTvEjA1vOEN2NVX5K6qiixjGMNkIVFEqH0GZOssUm+AYkeHu2+us+/VC9
         dSomn9ASfj6g6hpa685zHI732G2Bxkic9xnoNsIp6gkFykU3glusfu34yFylIR5cQESb
         o3xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784304145; x=1784908945; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4EpY7AJQ2z/UEGmxEkcHSNHDxA7dCAY+EM32t/GnvPo=;
        b=VjsBwWxdP7FzoaWfmsogywWrX/3EJf/WzZxoPqtCaHs27S0uYjHXZDP8hFuMsKQwnH
         JEgGjfXIylGoHUl/qJt73XN8Rn/mJZ+kqAIAxeDab4w9ET6YcGziD4yAMpJG6JCp4ulE
         e5o44srjvENol0mZnERQ8pVmu9DMExxy9Jr9/mmmma1GrloGvwgrfHjjG8PEr0f647Rh
         fFL3qBkfqe48o+3Q0dyjSXP8/DZHt1mzCCvyoS4YZOoSlZKeQ2i7GBfu1+jCzoAlh08I
         muZDcYZEo/534Z5QrNH6bzMDlxlzuMr8CCMwEqA52BYITNX7SkZ1grLyxCmtWFrc9cL2
         8rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784304145; x=1784908945;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4EpY7AJQ2z/UEGmxEkcHSNHDxA7dCAY+EM32t/GnvPo=;
        b=OnK5w9J/aGZjctKZEArmPe97K98leUjuDlBx3t8Z0gzX+VudNdKwRAYdGVpiLhVIvp
         2CdqQuHIkru4Eux5RqvAKeOWc882QPOmk81/WfUNPDbPoRKVQQSSnWzIKC9rTvlGLxVm
         s88eXxAHfZJfOCUkf0zsJMl7ksVCtQ3GISGpjqBHVt1K4/whi92CTUkvcdFAJoaI0xht
         1JU9No6c6uWfQkUIjHYpPBEH8EqoaP6p6xUiuEXigA+0+fkXV8hg6iT/bVQ2QIXkQJP8
         gJQKC8ciHWA+0ZXe7egcF/DxNxiy4eAuDfu0LkGYSN36JJCic9mdgA6DT9Arf9fE04ir
         uDwA==
X-Forwarded-Encrypted: i=1; AHgh+Rp7mFJBii88IA4dLNh1574ynrtS+aH/6AAZKonbiDYWRIx4JcxHuVt6QsAiGA6TLsoKM0FnwS7Zmw==@kvack.org
X-Gm-Message-State: AOJu0YxKwo8BZlssQ0D8LJXNZagd1sRALmcMRfWcmgOniar1uoThHMqv
	CoF8r7GAjjZNH10UXr4JPxhJC+Bs+HNVsPTJhmO/bolTOy6FyNqygm+23ckrW8z9ZoCBzim29hO
	/b8+m0Eq5GhApDnp90k0rafpsSUyh7sk=
X-Gm-Gg: AfdE7cmKEHSxLmgb1V/vRVP25X44XCwg+RSdXgdSQ/SVpvNvltk66H4ub3IuxKifkLC
	PDzP1AthHfFQT3Y9lcXsDgFDayOwBK3whxGKRWz6GNOI01gQhEsIfjfVEj/GRDbqKFzmWeAQxJ2
	MKpTNWVx3i5qXf2AudF/+FGlv8IzTk7iULkke8I3jRdqUgL8y94DXBqFKbZtkdNOHpAhcKweK/Y
	0HxNxYHd0+sTACG8ZE57MjnQxPhnc9ARYAeAFY/FeQCyKy5+4LNxjtFC0C+yheN+eUPxiS8XGye
	wjdXsGYkH+Z0mQQi4WJJsJOnysLPJc925wQsJuK3c8oe
X-Received: by 2002:a05:6000:25f7:b0:47f:4fbf:7b21 with SMTP id
 ffacd0b85a97d-47f622fcd69mr4322259f8f.12.1784304144768; Fri, 17 Jul 2026
 09:02:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv> <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv> <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com> <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv>
In-Reply-To: <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 17 Jul 2026 09:02:12 -0700
X-Gm-Features: AUfX_mwoPLG2cvvdwfPkYyjRN6pEPnbJyU3HWZ3Bhu4wEqgvsSFhKvl51W_U3mE
Message-ID: <CAKEwX=Pm2=fdPYE6e0o8bO2sazACwGhKCpstii-P-8P2AxWGDQ@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C72E100017
X-Stat-Signature: obujpemahyruc6t9jeroq7grryy3ep6m
X-HE-Tag: 1784304146-254922
X-HE-Meta: U2FsdGVkX19gLvwOM96YuGxpySAEPImzykToIHzoUSzxXRski0x2/NQ8jp+geiSEvv8NMGukTqLCcKnqYp9gtsfALP0LhCopg7KfoJpg3VBQqZmtBFmeGRCTblkGK+NJE2A4f2MVcqwCqjuOe24ftS0fiUY0Kt9W+yKF7UcYkrO/LfvmzN8sj6T3eUu5PFbjgtJqkS7U34q98ou1hiBmM0eKBuF8C3cY4wgOlaTzQT/ED807gzB7UIv7fqympX15IiHvlagC1CTZ/UvszrDEVtzTu0jfmKtxspMrQIkb4G5IEMTvllNqLonvPVinK4S5kbOvylSFmF+j6xYlP3c66XWwlO7kWABHZEPWNk+sYK8QzgLRkpMWeusYUyeSG5PR3Jm7PvZE6uknyRkb/Y/zAPkaMC7UovgR3+bB/CTfJ6Sfz/l321EUfI/nZuIhbCIn0zLHemnQ6P6/UfxHpDy3zIS5noEjzFsU1OCeszOe51zKP2IKGYi9OhM2w7M4udf6D2nB3Krbk29GKo2MSNwKZN4Rc/eyJo32iZ6C9LmyrPeovJ1gh4Z3P7e0LOPXgjq3N7tooSeeLyD+z+/qlCVDElbrMG4/s3mkPYtqYUUUZZ+qo+hJKjzllcU1X3yAIVpByGUjz4vOyfQ1Eu0UwiudhyoDpWfT2JLxoLtvIvB3qTNk7mpf/454VYFHtClmpGKNanr7asDnEFCujrLn+yfBpmoAjWZZLRgQVq35RCv7Lp1M+24eW0LJzte4HJlc8sHOtns2JE1iHX/vaYNYPOWqeo8Yv3i8HKQs1+ooIlp3nkcCr8wcuwMFLAhPmGyKBE2KqRGwtbNyYOgMMxLlL1+hTFWkwUxbpFW7TMWRhdr6+Mk8sCFwCjydEVhNMPi41PCmob5LNS7A877xdGbvBaVdC7qXv9hvScKzP+uJmmoog9NFGgAsOnwW+/dE21JI43tf7GdoVISvSGcJvyQt2QI
 uNjkQQNe
 h1P2KoimHxB6Sr/+4JUz3dKaY6JRyEfkLq1dACAW8HqQVPZ7H4r5nUZ1mzxV+iMx39mYUyCvx7/LfewyTV8rXplYSH7whFeCKcn2X8C3njpNLRqUm4gptB1RUsouPSfqcmyZ/S3dD1pUnfZfT7ubffviAB7UIWnjr5/YPY7WhwsCHPcPW9gRlwoJyzqCngpRo3vUty915EW+RuytFGE3uoi8ZDoCPxUX3Byt5ddy9AeuB4msXZ1RWEaSTYmyXmmSvS6w5sM4Cq5z1S2Pz3JFycoztsA5zy5srcw5h++QlmPHMHRBrMyQsSCaMnPP83T6TzVLkvx/5sjX26m7jF5EyJQMuODHC4VEyKdeEw10bDTyuNZVYLnV1NvDM74NnU6DyyA7ghI5faM+7PzLOg8ehUzoZmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 7:27=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 07/16/26 at 09:49am, Nhat Pham wrote:
>
> Thanks for the thoughtful reply and the very constructive proposal.
> Your suggestion about moving forward in small, incremental steps in
> last mail is really appealing =E2=80=94 I think that's the right way to m=
ake
> progress on this. I need a little time to think it through more
> carefully before giving you a proper response. Will get back to you
> soon.

Yeah let me know what you think. I'm planning to send out v3 with some
more cleanups and fixes, but I'm happy to hear what you and Chris
wants to make it as useful as possible for everyone.

Best,
Nhat

>
> Thanks
> Baoquan

