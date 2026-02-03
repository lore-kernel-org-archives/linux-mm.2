Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9884E83062
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 09:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB616B0005; Tue,  3 Feb 2026 04:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E4F6B0088; Tue,  3 Feb 2026 04:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F816B0089; Tue,  3 Feb 2026 04:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3AF16B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 04:10:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72DDE1A0423
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:10:30 +0000 (UTC)
X-FDA: 84402574620.28.EDB1558
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 698001C000B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 09:10:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VP0nnDJw;
	spf=pass (imf18.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770109828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YufSbN8rzwF9dXWtPAZkMmBI0fMomtuTdBXoSaaILsc=;
	b=w1oupcv72FVpcRgjU/m/+Drnlm9cV6UX83KCSc+QaSdS9/gn+VA34z1mN+O0x+JgC7fbhR
	IafeJT6A2QpmS+cLSnNrvJ07EU2zAzMUu+cqpTl3b5O41vWk8pW/2uRuVZLCuaLUpHE2fa
	nZMMdLPaO4XE1hqfEfMi6sNMrvSyN9o=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VP0nnDJw;
	spf=pass (imf18.hostedemail.com: domain of ahacigu.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770109828; a=rsa-sha256;
	cv=pass;
	b=yUfsEFSR7WXtfA/C4Lik0ZkhJ4dx3VlLG5XbhvsWD5QDNSQAtMOdENJt004bXDVKWtU2GM
	e0ntxBH0r1tZhisZDxxyd9FIS/NFRIWcQl4p8/mPuYDlmffhvOJvV1UG1YLQ5YluzV8gBH
	ny6f7McqucPMMB6ZdcELW6WAYXSxoFY=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4359a16a400so4607941f8f.1
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 01:10:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770109827; cv=none;
        d=google.com; s=arc-20240605;
        b=ihq0lZWq0nIRusT3Ck2Wd6O4g6fry01gpzJ9bNsVQZIGGzRv2/A7l8txySMw74cmQ1
         UamjEgyop6HG79BPNxfaFLBhvF5Uf7oti3oL/owYhA30Bj9yyakyYVjZx/ziRtP1Ddbv
         oiWZ3O3w+zH90WA/98lJbDhlOhOaps+I83Z1ghTHKrLkPAWx7Wm3VX+LLJqsdycHCeB3
         Fn1xTRJombCx4OVOVAT//LURkf3Wc+zOSKH9PMEKZNjmDQ4gAmQevdAmRAUCLae/yYYp
         qqZqq9gxdqXyYyIYW0nCDTKPMhqKO5kpLspxxJ0bUOLWX0Cj85KdcMyjLoLosuFvVXvR
         H17g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YufSbN8rzwF9dXWtPAZkMmBI0fMomtuTdBXoSaaILsc=;
        fh=3HgnvO52m6JTBv9hYhI9+jgXdbxtryPg2iFKyRDOffc=;
        b=g/DnLvgecUyCGS6/TVnPJqmD+Lbta5Ia1XKVQ6YH8JNAbJKo4zjRoS/ScrwqzFYAUs
         42py8pTYpXya/BxAFYdVC+HLchgugP3VP85Q7bGtjMYN2AznRFg4PsLCHRWfxiIAiO9Y
         OZT5G32sPkI9kBzRsBS1HQmpmGrg/1Z5Rd1D7zSZN236PwYFCGQfKZMZ+aoGh9PuU2A9
         k8vP7TcLqCAGYCTonEesbUvUUrkI/fuDRb/gtAM/kO7f2nEaIB6rKaKiBKncJktRWCc9
         xklYFXLW1KDN+4I2R/vfm6xNIY60P23UDX+f4yAAXgI6iRx2yP/h9zd2E+Ckxao1QnK+
         peSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770109827; x=1770714627; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YufSbN8rzwF9dXWtPAZkMmBI0fMomtuTdBXoSaaILsc=;
        b=VP0nnDJwET0pPN5vcbAyY7p1EifjCSl9fBbQstbuAsUrXNOY2NejlkQJ6h7VUB196L
         QkGqAezc1mTs2Bk0ZFWyfiGMRTsUqRgeNgaiG0E37EfV4EoVEf5M7wbhBi2Dr+ahEt4w
         Sl45rQMOcAI3z5KC6RoojqqgzQhzLXoRjtyVo3DUY3b+BoMPjixqgt72W2GidJXgoWZh
         6eeNnppxTPkULyMBmj3z1btLnHGfhjVr1blXmfLFGnU+uABYN90Dz3E7yGobls79MCDU
         AEuZSE0GOjIvOAPwV0oXqtXc+Kd4pyNJPeQjMjjf8QJlBemuO1iGzwnu3ItuGyEdT8Ww
         xJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770109827; x=1770714627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YufSbN8rzwF9dXWtPAZkMmBI0fMomtuTdBXoSaaILsc=;
        b=a9p3UeqtXXipXQJe0nF/97rFk073UMbBXKIWCpYCsdx5g1A2HiXJx6ZRsFGw/D8Neq
         7WzrFAIGF3EoyqnDrVAxdxZgIDvrA8FR88XTlHyji0OOHTwpyXlyvO0dy9iuh3I9AybS
         Aiqz6RBChM8Qy1M7qPHfbnz7TO/++K83RoEQXLr5Xe+1ngTSNq88v3d729ODvTXWNTRd
         u2M+TGdeiUwZshlpCOf0Qc9f1GZ84AHMxfQ28XNjZGQlLACBiet6i0Kj28qEekg4EGK2
         aNaoXfbNB2yBInwLf/zOWiz8Yvo/BZ6yVjWeVVjOMSXcwyP8RuwPt8DxThvfSBlFEN8v
         FVdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTjPoC9zP5lZO1LxVs3pd1c9gchso/vyZ5lAfcGe35xp9e3MykgQkw2iJaplUz9kDAmpIW7VjU1Q==@kvack.org
X-Gm-Message-State: AOJu0YzMQulqatwqTrb2MEOykyHBVNIY3Vqp66Cn3M75aNyAQ7EcECkx
	DsjF69YK06CL7GQuf2ga/CF2PUFjztw9HSTkCKDwCg8sxYWDC8nGhX2dQkSTxQ3BM6oiMbgZGn6
	1v6JZ7QNlsHwSq4UAxwhvs3VSNscGFdo=
X-Gm-Gg: AZuq6aIC9vPNf31XksHt06M2m3Dcqb953xZuVPFIUdvmiAzo5vctcYqaoJHEElnhDzE
	N5ygT6kp987QfheARk30CsthMLE0qO7Ke7XVSu8cR/+AL0JmvrxQx8H+4Vze8AzS1cWIND0DApM
	Y6eQUg2vGwFrWmBNpYN2UXWjPv7FpuQtSP28JgLCzLc36jJ7kKoMOEWrvLp4oH5lz651iPwRodQ
	21TYYFifF57bPZDEs1J+hjf9KwPfnB+9luBom4G+OPzbmEM4ogDZBc+uWPUWj0oUDbDpAc/hNoS
	bqg875cWOyEbeP1SwzKOpKWu2mM=
X-Received: by 2002:a05:6000:2304:b0:430:f742:fbb8 with SMTP id
 ffacd0b85a97d-435f3a92266mr19654828f8f.21.1770109826689; Tue, 03 Feb 2026
 01:10:26 -0800 (PST)
MIME-Version: 1.0
References: <20260203073757.135088-1-ahacigu.linux@gmail.com> <3e59ca4e-2301-48a7-bb8e-d028f07b1446@bytedance.com>
In-Reply-To: <3e59ca4e-2301-48a7-bb8e-d028f07b1446@bytedance.com>
From: Altan Hacigumus <ahacigu.linux@gmail.com>
Date: Tue, 3 Feb 2026 01:10:14 -0800
X-Gm-Features: AZwV_QjHN2f1dqEKp-oNFWKTebxMCyw9kDZeWtR0aZqGJ_jsA4ifzgI5DrnO9oc
Message-ID: <CALjTKDkir0WvFKCfJquwxO-qfYa6CT+5ECa49SbRiUrexRpyrA@mail.gmail.com>
Subject: Re: [PATCH] mm/shrinker: Fix refcount leak in shrink_slab_memcg()
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qj731mprixc5bubo61gt7xq5n14ud3rz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 698001C000B
X-HE-Tag: 1770109828-529283
X-HE-Meta: U2FsdGVkX1/cF9QMKfdvgPec5apMvJynbn40FCEi6TNohkg4BYuiBwqPbeGFGQgDkhqWsWXrzRxzKy1cgFmITjfJddLdhQMxzmObo75ltJFrjslOLXT889w7is0ID3ZRIn2uUSKao9tUkqri48PE1+9FzXTLVM1yy/oAsShdxM18ryeu92UtgFo8+3JRGfXC3872gN3Ml0d5Gac1WJmKNqUMJQFMYS3UtOT8GiBkwNzZVSVmpEK2XVYywPM5YCsv3MuAIG4y8TwoETwrfdgNOmcFuodpdbnHLpD8HIbdNfJr70lGr7AuqTljUEMOZLYOp4xUF8B67TG1pBRAeX+PPsKaOzECK5BJBB+v9CiNxA8CDzdhTh290DsThN65LC6mhG9VnCiF0bERXN+KbOYjMazbuf+SMdkGTOkn88TBJOrVTTjOadIzp9mgOTVj+5cA8g+GOymMCa8WLG8Qe2/sg3nSqArhpXlwp/PZsCxS0hvWls7gOIbroy61pRR76nFJkLyQbdtInFF5Ks0GE7imySBI/tQAz0dcwWIEFeW4v/Ke5Yg+nnDWkPXTV+akmM5KL6rz6PPZrwQ3APylB0Gne1gf5pqteyNJRgNajblBWoP4RoBFDv+h3dRVMGr3Zr+V7idxi6SxjUwadWaobt3SFeoMKy4Q528mg//G9fsUO8MZkCBEe3vQaXqIUZQktBBxPRBdTlJvl1F6U3YiSG2NgAoU7ZH5NNIehMp44YJa0xPOvSWD8bbVbC9RIhU7CPxpuN0jEBMv6p/vDYbAF4e8LuWsjZ0EyxWP1GMIzmgZDh9sBekfsMYAXu/PAvbWCLUa+/9/p7LQKiBlEvZXENnThK20Z7SrnZBOZKwNgotkjzraKBclCH/xJqbR7qMs6zDMAMvKExDoe6f9NnPvVajI4O7M/8SN7KA4m5d3PJXgcanuKUDO3z6a0gW4iC0VsbEVvr8rfln7PszrW90f9H+
 gLHm5HXZ
 LSEi46ZHht2jXd1xKJSz98wOdLnykKbfXX1vCmaap2mwB/W1UnnCuolUIKwXLpIKy7Hbt1mvUmbHVqUc9L4jG0lzYI3dU5gkA2asPagZk4tfii6n4i0nGddJB0eD9WeHY9cTygzmewzd6cuaUtSnQ7hXN25wIt2xfFBTEiQXYPpR00wpr4VDYyHyoNlZ+fV2Tg5oJxoqyefHBi9/Ch7QcZTvteckE++CswBj+Ssd9HO1kf9zVCB8bLMSzsb+nC+0XT6mZjVx7WwtFtsjMBU1aNFsqVeDJUWfc/G9ljNEn+0PMugGu6x4bY193P7jIz32n9VO0X/p96iP+whcU7WOsm1ZkvV9f/qKver/KGNhw47ZapS/P0jF/8pWbdT8oL6Cj5/Lvo+wPlfG37lwrqsIkKfTUtzcPhBzowzRdVywqaSJK3KIOlOtpFs1qTrrmAg0xtE4ta6dwT0hKrHtryPA+OaDpSih2NGJvYY0bx9CnzXAsiys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sure, makes sense.
Will send a v2 with the bitmap clearing.

Thanks,
Altan


On Tue, Feb 3, 2026 at 12:18=E2=80=AFAM Qi Zheng <zhengqi.arch@bytedance.co=
m> wrote:
>
> On 2/3/26 3:37 PM, Altan Hacigumus wrote:
> > When kmem is disabled for memcg, slab-backed shrinkers are skipped.
> > However, shrink_slab_memcg() doesn't drop the reference acquired via
> > shrinker_try_get() before continuing.
>
> Good catch!
>
> >
> > Add the missing shrinker_put().
> >
> > Fixes: 50d09da8e119 ("mm: shrinker: make memcg slab shrink lockless")
> >
> > Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
> > ---
> >   mm/shrinker.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/shrinker.c b/mm/shrinker.c
> > index 4a93fd433689..d0be120488b4 100644
> > --- a/mm/shrinker.c
> > +++ b/mm/shrinker.c
> > @@ -544,8 +544,10 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_m=
ask, int nid,
> >
> >                       /* Call non-slab shrinkers even though kmem is di=
sabled */
> >                       if (!memcg_kmem_online() &&
> > -                         !(shrinker->flags & SHRINKER_NONSLAB))
> > +                         !(shrinker->flags & SHRINKER_NONSLAB)) {
>
> Since memcg_kmem_online() and shrinker->flags cannot be changed
> dynamically, it's best to remove this shrinker from the bitmap:
>
>                                 clear_bit(offset, unit->map);
>
> Otherwise LGTM.
>
> Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Thanks!
>
>
> > +                             shrinker_put(shrinker);
> >                               continue;
> > +                     }
> >
> >                       ret =3D do_shrink_slab(&sc, shrinker, priority);
> >                       if (ret =3D=3D SHRINK_EMPTY) {

