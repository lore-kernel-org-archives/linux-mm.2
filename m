Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5088C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912CF6B0096; Mon, 14 Sep 2026 22:20:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C43F6B009E; Mon, 14 Sep 2026 22:20:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B20F6B00A4; Mon, 14 Sep 2026 22:20:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2146B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:20:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E54D1C20C1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:19:59 +0000 (UTC)
X-FDA: 85214391318.17.4FD6D9B
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B2A440006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:19:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuaQ1jtC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789438797;
	b=rvOHqvyy2W64EpiINp7PrTc6IjT4cf02DjdVs53Fp/Rjtrnlsh9N+LqeQASFtrNN+xkhHB
	bOcqnwy2Vj2XIVwRa2f2CZsgTKT6/W9n98XWCJn009M3/yMw9G8/vsWLnursS1Mwki+7y/
	ckoC+xBs01pYPvLRGvKdxdvi7lAzQR0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuaQ1jtC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789438797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uz6pzhfSfo3jkEMjApuPj77vcnUzEs00MyRYle4FEto=;
	b=qHknywzCSxRyJf8itcKWst+kW6ITXUuxWPTj+ZsRvZXg2kYFynDlDWboYisC7YvrRJPpf2
	uqQACSxmLvE9Jxu07M6NfPq+mLzOL+pjiXOkpDX42/k8pkoA8O5FB+pIRKUQalB+EWMAyc
	6XY0aMMoMh9ph3gzoG8nOSGHDF3CWqU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6356256so957649f8f.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:19:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789438796; cv=none;
        d=google.com; s=arc-20260327;
        b=q+ZWLKv1jSAcj3+hIr78JHz7IK1NFaYEm0IRn9xfdN9o0y8vz2o4a+d+QJ+yxS/57Z
         q/IHSpp+d2U06M8tc9833SlPmj91FFT0oJchjVM6PGuEerq++Oz1PpNOMgQkHN8hSKHa
         0gh7OeaU80l6iLpnNs66K2kpPQEsPeTtA2eMoBvsx8EuLhThinEANF+tQKFdCHeDiHg2
         9uf1m9d57Ov6sjeYVf9nzYdz6OYKWm7o0edBYB75486UGN31jsrg2HDIVGwO+KEsLAPl
         fB0qmkgTGNs4P1V45Kyj7oGxoPsQW0Xs7u/1EA+PIEL+deai9gWEGtRqiO0O8Fc2KITz
         A9kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Uz6pzhfSfo3jkEMjApuPj77vcnUzEs00MyRYle4FEto=;
        fh=MPz1SuhjKc3r28EM9NBjrW0R/Vlt+Ssg5VFIHaO1eMo=;
        b=clwE8tVd22BAAgK8F0YfMp2Zm+FdHcyfC5bYc9YeZn8jURBZUZZqWWXUpFvKvOCCiM
         skpwrdQG1aJHvELOxisfi3UkM+SJrtUe9I4sKaBA99Nohcv2jphBb6gzaQJW3+vc2rHw
         LV9qKOVjC43W45ky0Cj7UkmUve4CXv/JBOtl8jYPl042OW6snVx8V0He8hQhrZuS7UJM
         CyXXMtga9tbQZC8UIEFQRu+hv761+K0hwP1AxKAjdsUz4phziALrZrJLnIYO8iiZ7YNV
         yCkAY4wSd+zdqQAruCMkmTrqd5SFOcI0uuVCsyeo/i15G7UcM7L/bhxnLXFWZJV/rYVI
         DvgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789438796; x=1790043596; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Uz6pzhfSfo3jkEMjApuPj77vcnUzEs00MyRYle4FEto=;
        b=nuaQ1jtCKDlawJNo+xrWiW0UqhwSbS5CFnbYJcpx1A2O5AKhJzppkvd9bBxkgrTMDo
         4rZMxxgNxMRqA5lKvwRVAs5uVMshkCBPcIUmRVSmafrXdGtDJGDpy8S4xE4U5iWwswtp
         odDmz+x/bbHiq0PrAbTDd7jkkKghyPr3gelEzVfaXisrf649m237Oi+zvZJdRfV3MOYB
         jnEwtm/iMDvIfq14MBIzTTceWQHGX7y/mdenmOfDof/7EiS9awiXJta/kwBDpzuqqaLu
         CItJgR1lEMN7tuNKNWOaENuz/FMd38GXt0JrpyBnDm7qtFl+4m7AvMhX1Zd/HAuvcoO2
         ChBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789438796; x=1790043596;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uz6pzhfSfo3jkEMjApuPj77vcnUzEs00MyRYle4FEto=;
        b=q/YycOWtqXN17dJ9hmoVP4Ck1dPp7TON+YFlr1Q6Nkzw7Ar5Uz1+knFjcPW5uG36Qz
         sibpVf4Qg6f8JRNEYC99f1cVtZMH1kLIE0hQkITQnuxNKfkOW+8sFrYJvgd+qw1i23Q2
         cpGK7Zr2A9HHJTPhAXrAm4pVRJgj2ASDiJk4+eIPvygQ1qf/iVpjk24+vcickIUPf81x
         4o51yZltAa8qJsR8uONjTQ1ssUe4NIqybi7ifwwJ2lsGtWgFG2BF36kgBnppTUT3GRgA
         1Lid4O9VdTffn0weL5sbNMer4+ZF0k9RcBgKJL4Ph/ki0g0jImKUAS2XOaCyGljY3m0h
         Wa3g==
X-Forwarded-Encrypted: i=1; AKwUvBy+GAoyDOHuZb/7tUodxYnMRy3In2un6wHbzvOntqAj5mO0vi21xIIoROdRYvcIizKEzC65xj216A==@kvack.org
X-Gm-Message-State: AFuF++kzNWkY/YkmDi5GO0CuIKiiAhTuGa+QpEafdCFRheRUxnlvcV4l
	Fg3h2N4B922uRxsVn8BvdoisKVp44CHEbx1krqRs57rJJjtBwciWqF3VoS52cjzDvWBJ0iIfi4e
	jBeMNHq8nerQwgb5z72LF0B5Yc1ULxLI=
X-Gm-Gg: AYBFou1Hi9+g7EmFledhwWeKvbu929dXCCLZH/TU9c3T+uryX3JAzeQOQlNlYOZMTUF
	I3sXIpiFEGepnFH7zaqjU/TxAB/UaZUL3BdvoZK170yI+B1t9A7PJhCvlYWIYRFl9S3GWUZXS5y
	Mbvh+Ctu3/YckGXAOIFkJG7tnoOQjUO4Xi5obsv9ho9Rodo4YKGVLRc3/gSrQ6UTcdweRv4c4JK
	WfL02sq6dndQpepLVz6kBZUCjllVw3CyWDDLwj8855WkjTXOl1VLyHSukdg6VAGUnAKCypXm8Dt
	y5dJVcXQIaJGSH68wlvr4P6i7XZs4R0g9955UAS2qPmstprXhVVAQtJcEDCPZHcSntco7k3bJ7l
	Ti8zzESbMcPt2
X-Received: by 2002:a05:600c:5307:b0:49d:1e79:35d6 with SMTP id
 5b1f17b1804b1-49e7d750cc2mr26446565e9.14.1789438794905; Mon, 14 Sep 2026
 19:19:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260914150150.1507525-1-kunwu.chan@gmail.com> <20260914151617.97903-1-sj@kernel.org>
In-Reply-To: <20260914151617.97903-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 15 Sep 2026 10:19:43 +0800
X-Gm-Features: AcwNN1W8hM-JtjZLNyC-iYEta08SQzUOjubSm-5TdDfo7dJjMBqxsOi_D3YW6Tc
Message-ID: <CAN_Opa8qSHcDNU8k=EWMywUADizJEhHPpuia3jMcZ13i5iYXgg@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B2A440006
X-Stat-Signature: gtyr5se9zzm4r793owa6s64z6ebgtzkx
X-HE-Tag: 1789438797-751644
X-HE-Meta: U2FsdGVkX1/Iq7g8v1WbGytmWh4Cs4uxydPc1zHIelazOl/SRPeravmZN9D0kauE2YSuYM0b8/gjzoD8742zskgGG/qkti2Zir5dtqyczdYhCnqrOPjcd3/M9okUJ9heVZtrQ+fhj+uXRSQdYDNiqWDgk46eb51nVOg2JOuz/3tJwJ+p4BBomz04M3LQEKn1OcjZov5MB3neeeDP3Dz80JCA4FoJzmV1nVNlavW/K6kkKxAREfdByn28Ds/JrlclN5Fhwz0CCZmu0U+GSFmCp9PrcXGpNHJfWjv416keYUf2diXR+/+ABsXPoj6EIf5N0KOG3lBCceJ931WXvaH3Dhs/MT2D9XuxA6xTagule/0Ix+KZVKs/2Lbhnig7mrUbmJHcjQuZUf/XnHIHmTRaqfz8GlVPuPXeb1rmJy6LxFxFeX6YsXN0k2Z3iRGOZrWybtf4zjInisz4fBVAyq7ViiLR2S1D153Dp6nr+FOr2uyffyoPnOgKsNl0hdgW/7OZpeqwEh/ScBn0tfPOxBi7mTyuzeE6wsWhJkJPqF/0QOE0UWpgoeOaTLQmom7XwY01gBVUU44Q2TjzaqRGHMTYPtirpqeeD5BgNsyWxzVAHYqZ1pg3X5/64PmwnRmLVA34k6eFCNrtEuNH7lA8oa07AziUFQwQUgmtjRF35eYuHgmgeSAPro+cYHmexivbWQhIs9jbdvpPVDwouCY/yb8HbadvhXaDFR4QvvF3khlaNpy/AT0adnk21FbjjyoSNjLCAdTozW2vG0BdIZBmPff7KevbQKuTFLEEqBzFty9VGt23q0jkll2xpwCCdTlMS0wJX1SG+66Q5OPxwb4Zbunjneyx3Sx/mlu9/CP6WrW5JkiQnSDtNx+jdeJl0jgNhKVT7hSObV5DXqaqVcmcrgEqfr+AcIwFxW/Qsd1SPMfg5257rSklpS2h1AM3mJ1dMCW9URw20xlIe0gT91kUHm7
 uy1iPYjQ
 QWExvSDxpPCvpeyxsqwkC9vOuTVGR9VB/gL3nX1/iZLRoMssKt4NwEZrdohnbcDMUgP9NRcJzRTVyf1QU4SuvG+1yfmiaHhpMq9TbLHDlKPq2MfhjAyqzExA2d6cQN/wUkdcGgYlaRzJx7HbRgI76tLUS5Uo601TfvFnygH2Hz8U7G4o/E321NvFCT/yvEVMVr5hlv5qyrnqasHcEp0H/RH6Opg5TNoMxXVh+RN7nxVeqq0iq0O3V3W3wIHMJbLxfr4uXDn3w2Ff+C9vlnPdjE4djXTKgcmZc0tAgG1BvqV1xP97X0MnijvOY/3JYsfeHOYra/eyv8k/oc/y9WNk4hcwjWBOHxp4sh/xl89EFOw/3OKf/6Ft8cvqu/E28vcfaJZxuCWHzMcH5+u1uKgYZhDAoyYqHij8WqFH3l2nVb7Ac9MDjr1ngY8xXpARG6lXvCwTP3FeXzIgYyoVvrGeVKqQSqeZ60lebdFeuMs0ZLeGogsZvORHwN27jWB1GpD5XJn/sLRLinV6CnK7SpSCDySDAyjA+oq9Q1lumvoEkqqYVobeGm09KCsllUXGlJ3FpAv1u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:16=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> On Mon, 14 Sep 2026 23:01:48 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > On Sat, 12 Sep 2026 13:08:05 -0700 SJ Park <sj@kernel.org> wrote:
> >
> > > damos_adjust_quota() is manually checking if the user set the DAMOS
> > > quota.  There is a dedicated helper, damos_quota_is_set(), for the
> > > purpose.  Use the helper.
> > >
> > > Signed-off-by: SJ Park <sj@kernel.org>
> > > ---
> > >  mm/damon/core.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > > index cf10f6d725c19..dd27068cb83e3 100644
> > > --- a/mm/damon/core.c
> > > +++ b/mm/damon/core.c
> > > @@ -3344,7 +3344,7 @@ static void damos_adjust_quota(struct damon_ctx=
 *c, struct damos *s)
> > >     unsigned long cumulated_sz, cached_esz;
> > >     unsigned int score, max_score =3D 0;
> > >
> > > -   if (!quota->ms && !quota->sz && list_empty(&quota->goals))
> > > +   if (!damos_quota_is_set(quota))
> >
> > Hi SJ,
> > This is more than a cleanup, because damos_quota_is_set() also checks
> > quota->esz, which the original condition did not.
> >
> > The path that makes this matter: damos_commit_quota() copies ms and sz
> > from sysfs but not esz.  So if a scheme runs with a non-zero ms, then
> > the user sets ms=3D0 and commits, the running scheme gets ms=3D0 while =
esz
> > keeps its old value.
> >
> > The old check would then return early, leaving esz stale.  That stale
> > esz is visible to damos_valid_target() and damos_quota_is_full(),
> > which also use damos_quota_is_set().
> >
> > With the helper, damos_adjust_quota() proceeds into
> > damos_set_effective_quota(), where the first branch resets esz from sz
> > when ms and goals are unset.
> >
> > The code change is correct, but worth noting the behavioral change in
> > the commit message.
>
> So, if user sets only time quota, and then commits the quota to zero whil=
e the
> esz is non-zero, esz is never reset to zero.  As a result, DAMOS keeps ap=
plying
> the action with the esz forever.  Correct?

Yes, the stale esz path is confirmed.

One clarification, though: it does not keep applying the action
forever. While charged_sz < stale_esz, damos_adjust_quota() still
returns early, but damos_apply_target() continues to apply the
scheme and damos_charge_quota() keeps increasing charged_sz.

Once charged_sz >=3D stale_esz, damos_quota_is_full() returns true,
so damon_do_apply_schemes() skips the scheme. Since the early return
also prevents the charge-window handling from running,
charged_sz is never reset, and the scheme remains permanently
inactive.

So clearing the quota can result in the scheme applying up to the
stale esz, and then stopping permanently.

>
> If so, this may deserve Cc-ing stable@.  Kunwu, what do you think?

I think this is a functional bug in the existing code, and Cc'ing
stable makes sense.

Thanks,
Kunwu

>
>
> Thanks,
> SJ
>
> [...]

