Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C52FF606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K54FqEM+
Received: by kanga.kvack.org (Postfix)
	id E661A6B05B3; Wed, 11 Nov 2026 08:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17396B05B4; Wed, 11 Nov 2026 08:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06286B05B5; Wed, 11 Nov 2026 08:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA1476B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:14:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49DABA77D9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:33 +0000 (UTC)
X-FDA: 85422882426.06.B8FBCAA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4BF2040005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K54FqEM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794402871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/0oI6uv/H1EEuDN9a5C5Hh0fYM+cFB/bWC6crw40RE=;
	b=X5B5QRF0CJImpQprdTVPUnJFHL3ZsRv2dUHbfROILsxZBPQiViAujbiE7zaS8OZd0LTseh
	RLpcOwq73ZrY/pXcKC/A7EZzvOuz8QE374iKMNsVuN3ciNU8Ctvy5JV4D3/FA2fJM681Cl
	ka1fZNuKPQTSeZirE2M1fpgUS9KP3VE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K54FqEM+;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794402871;
	b=rKPugRPFus7+oDUfna8bJbHlYjJLgmcZhjilQ+/LPKdC54dfi1eakwGh5B+W2kfBXwcqTN
	S6fOR6vTaezrsG1g4HMv4mEzJbfQO8U60pJyyGv6wltng+2l/K7qAr940j7ij8kxncw3sS
	z0j3HRGmKZNkdNzAzc8OSR/s0VeEzoM=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed408b0d9dso11336065ad.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:14:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794402870; cv=none;
        d=google.com; s=arc-20260327;
        b=h4gxhV40+MDlvwxgedISQebOo6dyz738iZlsIIBywJUQSgnCgX/04w3Y+fSocy56rn
         2R2fMlLMRjyjaMgk0ktZbqtyiG/1SyYp/GOR44KTxGHe0rEx426julya8SdgdQXg2ZSO
         Le8Zc5jxYEl9tCTG+z8oIHENqaJVEhQLyR5q5tc0F8ITwAp6UGuHGxLzIw6Mg0OgFb3R
         4aR1m/2eFWBq1WfvtpeOr6fN/dLBQ8yovLl8Otcd/vG/ilSTllrG6ml5oJZro2UZDwGI
         aQXkkPH66qLs+HRv/IbreldH/IRyHeo8O5xbGkMpZzKoxZCiztcqRtemTsEVa7AWcjsr
         XLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g/0oI6uv/H1EEuDN9a5C5Hh0fYM+cFB/bWC6crw40RE=;
        fh=FFXKBtQhj089z82sCjnkJZ6I0htXS0wzfintS5fJXKQ=;
        b=Cy1YgwUDZHlxBFl1vW9BOXRPfGAb54Nrpk8B6Wc+Qj6MavQK69t/XIdokvwu1P0zia
         3TtyK7i8M2wajqrejBUdCvE8aVU+WSHdKXx/rivy7WpV4eqmWQZUlFQddAsiFsr9Ug5A
         bh7QU8zlOtnANVgKz9ROPYjBFRymmbNxIKwaGXATWELIsESasADGNabeYnu8meysgfQK
         bTBrIUgSZt/A1jeIAUbQN0/3c+T/VMuVugp+FEDnmapcksgMj5E9dmMjIWPfuJ8B+cXo
         BlHdrwxEbApOAmrjPsGXjtQyUQ5hCeakmdbo6EkvhXQ3eNFBJfVlxhEl153U87NTb7b3
         /r8g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794402870; x=1795007670; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g/0oI6uv/H1EEuDN9a5C5Hh0fYM+cFB/bWC6crw40RE=;
        b=K54FqEM+fA6reLijMMImtHJ/uLWeDMX81TDk/I+wcRvB7TMa35zNPjSgLWwOwB3VNT
         /XeizahgYg4E/sJBZvAVhGEDEJHsdIM7AqNcYAICHJ7zhQhO759Fq4oajjLX0tcUYpBK
         Vf6+cBYAGkrRbctMzsQhQfrRaLlMiNv/kqoDHY/ytCkNL70pAiNmohwEJSeGr4HKPOTC
         qnCRkJvXQMTvXqPtozngVllDI3AWiTxUNipdon33diy5m2i7G7DBHqEn22FegIFr6BZc
         6FJgVBiQWY916CYBfZ5IGmTK5+owWBSvBnrK3OC2jAT3Vx/kdHcQz9mkgMMbh35No4xp
         k9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794402870; x=1795007670;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g/0oI6uv/H1EEuDN9a5C5Hh0fYM+cFB/bWC6crw40RE=;
        b=ydyA/YAjQLS/y8tcXrG0w1AtnGy/qEtxO8ZYPMwBGICUFuBgAUDtzOrPdkdHItet0W
         E8NS4wW47jW5qtKx07owI8XOWVtkHo+lJFn9UpIS5c0n6mdqChdg6gqT9iFU+PmiEV0J
         R38+35luVZp3aRZ6uy1M7c4BZsC2oH/BDe6zgC4soyi80sP0cCHW/cNsiXBgrHIzv47J
         NH594Pkqya1gmlH5qR//xYgVlWDHdpnfDGGgqK1Qc3byEAGfD0h/gwB3gy2YsunkgR8g
         DBX6xdKiDb10MDnfqYFSZum6ETKAkM6FP3Nkko3CzYziGX/Zh1U8+wlDUhbAmoaRg1Mv
         krag==
X-Forwarded-Encrypted: i=1; AL+hErF5d5+uR2f1LgwbyLzEv6oG4615Xk9V1TtWRPZtf8qa99Sk/tKbJRym5Y/MbOjorR9XHpVxm37wFQ==@kvack.org
X-Gm-Message-State: APuU4Z+2Pgc6Qk6QCCsglMp5oGzisTDUBj2vysJ0RdXy0ankH7uPP/f/
	IRAIy07cNTBe5a/QwccsTHEh5VtDbiyi2FML5BQx9dbspqP6RrIuVhn/cgwcMtbRezjqORDgqU4
	cPB9FcfmKG+JLHDxKp49YB7UvGdKamME=
X-Gm-Gg: AYBFou3hC15Coo9YnZKK1nNOhUCUgyJiziS5T3byXr5zaV2bDh5NSqo+o7HqStx7BUy
	TQozeUCna+XW37ExTC3jQR0ckh2RKV4f4fCKtpme+nykrfQSZGKpwPlXmVJxF6btZtBCkZyOnrP
	hh7mBjAmGgimVcs26uWa3qpAs2RnxqS4iJL3ve6oit+6RF/rNPVoDo5CiSR3OoP+Rl5wF4P/9pP
	/aOmqMmwJDt3XOvK17Fg+YlDN4JJnd531FpLpiav3AYSPELUWN4tILv5rHGAYA73F121E0Yi4g8
	vU2fHmRIvPJfUs5Rnmx79rHmTcQyaEO+jz68OfEwbfwgZaDcXR5GXrWC0NW4esWmJaoz3f/Ee9N
	gX6h3u3/a7cRBtTcnQXp/gmuAEqAW4cFdId8JCi84bkhv1ZazZTz9CuOK9Y645Kcw
X-Received: by 2002:a17:903:2442:b0:2ed:45eb:51d2 with SMTP id
 d9443c01a7336-2edd7a9888dmr27729925ad.47.1794402870030; Wed, 11 Nov 2026
 05:14:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110085132.1023-1-adrianhuang0701@gmail.com> <20261110153907.158338-1-sj@kernel.org>
In-Reply-To: <20261110153907.158338-1-sj@kernel.org>
From: Huang Adrian <adrianhuang0701@gmail.com>
Date: Wed, 11 Nov 2026 21:14:18 +0800
X-Gm-Features: AclHuK_JPlTrjZpaZjohmplxPFoK1WduWQbas8gb3wbIHqUrtWb9Qa3r2Biv8pg
Message-ID: <CAHKZfL3+i_Sq+zgA76O0gqj1nP8x_FKJR8SRa0oz-5N4LrduFg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/damon/core: simplify minimum watermark wait time calculation
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BF2040005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6nox1egz169q8nposbknpkhc9913b6oc
X-HE-Tag: 1794402871-385579
X-HE-Meta: U2FsdGVkX1+29Hr8loI4jAV2iDTguGjZ30rIK2fEEtXTdkN3OWE+U2B0hMxLa2tl+o/2h1qUtqsh/ZavhUNrnJBy10XvcvxD64O2QH0ols+UhCsQ7wbyVzKU7PD9gLZqmuyyt7PywWz4kNjAU3vbdgjF5HU/BhFvLu3+di5yM2X9F4wATOl1WZrcrnMTE7AdhJnp8jDlkK66GLBfhg/hhq3O0r0lGYnUT3iPZY5+IXz50AOhkfunP3M9K4S6lHD/duIXOMFdfwPQtwC3Wp3+LwNQJitK08vy3CwHZeutEcU0hQ4oFloV/1HlYlrsF/uXPFbwJWi2dPDvLArT0R7YIzTQ9IAGblwhLRy6qJ1cWCPBBeeTsk6efVPrQDwh7oS0m2noksa1x+cUdiMSfYbuNP1QxzcpkWqQ784i944d+KS9+NUDWdIkfvJg3pLyKG5Ie67mQpPFc+tnudzSYwycQTgDI2CwegfispQ8U+FZJt9hL1SXRTM2ykT1R8NevHw3aWYewfq48LPayyBey8DJ8ha77zaAyCcwxpD5hgd37tbr84yFf+T+zpeJnPT2OlisFTSNSAfR0jAHsl3jBL6bGdOSBkDGGQq4wLmd05LeIanJaWwTrEjlUQ9HarlfnbRtBHx5riI4PTu4Lf8P+k7CgV8n/6suzrvXsLZlP4ulbv5ktc2UxuLCc9IzBMqNvlHCA4eOliW+UU1WMkkFabUCOq5XbupmcCM5wF58MfZUBTbWgziEOnhHdYkfLwnczVErHUiRTFB81LRwqlFqU1zDUf8VQinLutvujUrdQlonGTTH5Sh3qrh4vhBZmYNcDFV+2eq8WCFLdbv2g42n1PyxREQR65oTrCOQFScr3UvRUOkp75XY1RwLDrr7rTiEj7pGj4ZROio7uQFoKgxpoBoSAX2SRbXxtOu1927X2MwJ2TTN+j1Hw3Kq/d6QlIYP805Ggq0EZFQOIU/gdHGFL0W
 T9BDf77L
 8PjrPnStW+8P4F2ndw+0Yb+JAEQ0OmOlHI4nh2zcbBiuEQgC15fb2QdkQK2RAv7cA9RxH+aYq6Z9GXYRJNBBhzmzSt4i+LETY0uwFRy1I529mRDi3lsjuuIiROmv+KJHwiMFyS9SE6t/ZN1HZT85LaDTuCu2R3CjE9s2PfGxf25H4wwhpydjiIAY5dKcPjQIEPl/e3DTWWX0nBcYxv37GDRoGx0P+IQrMta46eA1vYZ6e5I6AK5BQHTVO97ca7AwWjwDsPn5PCzetmhxrSHOHla5NLGh+IE3ESX+GiM7N/SYuDe4kPBFXZaZQnFTXqwe3yTULyT5XC33JaTpiz82iU07odWkjZaIM1x1mNV/AergnBwj6aytg5DVR+74s4du9GEw0lfkrgRVgevgSdt4CKbOch4AIsXy/q/sWyYtGxWg3n3AJ0GdwvZSPqeBrP83unBuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Tue, Nov 10, 2026 at 11:39=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> Hello Adrian,
>
> On Tue, 10 Nov 2026 16:51:32 +0800 "Adrian Huang (Lenovo)" <adrianhuang07=
01@gmail.com> wrote:
>
> > The minimum watermark wait time calculation uses an additional boolean
> > variable, init_wait_time, to determine whether min_wait_time has been
> > initialized.
> >
> > Simplify the logic by using list_is_first() to identify the first
> > scheme and initialize min_wait_time accordingly. Subsequent schemes
> > update min_wait_time only when their waiting intervals are shorter.
> >
> > This removes the unnecessary boolean variable while preserving the
> > existing behavior, including the case where no schemes are configured.
> >
> > Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> > ---
> >  mm/damon/core.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index d36823f4d092..93ec684a113c 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -3985,14 +3985,12 @@ static int kdamond_wait_activation(struct damon=
_ctx *ctx)
> >
> >       while (!kdamond_need_stop(ctx)) {
> >               unsigned long min_wait_time =3D 0;
> > -             bool init_wait_time =3D false;
> >
> >               damon_for_each_scheme(s, ctx) {
> >                       wait_time =3D damos_wmark_wait_us(s);
> > -                     if (!init_wait_time || wait_time < min_wait_time)=
 {
> > -                             init_wait_time =3D true;
> > +                     if (list_is_first(&s->list, &ctx->schemes) ||
> > +                         wait_time < min_wait_time)
> >                               min_wait_time =3D wait_time;
> > -                     }
>
> I implemented and used list handling wrappers like damon_for_each_scheme(=
), to
> hide implementation details of data structures.  This change exposes some=
 of
> such details.  If we agree we have to remove init_wait_time, I'd prefer a=
dding
> a sort of damon_first_scheme() like wrapper.

Ah, sorry. I didn't realize you intentionally hid the implementation
details. That makes sense.

> But, init_wait_time really need to be removed?  I cannot show clear benef=
it of
> removing it that justifies adding a new wrapper.  To someone or on some
> evironments, init_wait_time might making the code too difficult to read o=
r
> inefficient (system having so small amount of memory?), though.  If not, =
I'd
> suggest dropping this.
>
> What do you think, Adrian?

I agree with your point. Let's drop this patch. Thanks for the quick
feedback anyway. ;-)

-- Adrian

