Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69F99606A329
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L0mPKacG
Received: by kanga.kvack.org (Postfix)
	id 7ADB16B00EF; Fri, 13 Nov 2026 18:51:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E8D6B05B0; Fri, 13 Nov 2026 18:51:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EC26B05B1; Fri, 13 Nov 2026 18:51:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E180C6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:51:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5324BA7BD4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:51:41 +0000 (UTC)
X-FDA: 85431745602.02.E700A32
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5B046C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:51:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=L0mPKacG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794613899;
	b=HiVDugWHwni5Olr59xnxugRHXkRaJRrecdsCDhl6Cjs5jo7k0Pvb3qB58ZYhfZa22dAjrk
	wHLFnuAAsx8qQP6MDTLbFGPl67SBo0ZAC08mttOX06YspHyC+w1wQ+2/VjHhwGK6B9hrzj
	qrcaDbW0ZR2HJjy07hS6hMyydWnq+Dw=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=L0mPKacG;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZKpqrZ3SRC8d1RwccUdQki+gyeXQzlhXbDf/1N3lq4=;
	b=0tOrFW3RafJaA6r3LqzwXrHNpdHjyNXFo8KYfrgui765kS1CY3EQ0Me9NC7pL3NnhZanOl
	e1Zep/qgSUdlbdh7hw4cm0fAIq3uktlEnl9dyU/P/O9uBOc/BnmdYoF8EJy1j2Ukt0tuHH
	MFn/7RW6/0aAtCuoxZscA9JqmN/AExI=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e10a70540so751562f8f.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:51:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794613898; cv=none;
        d=google.com; s=arc-20260327;
        b=iwCcofQV4fOXcFjG74hb43gYN4GJwa2XOOo3LXrieS9KIfL1vetUT0ae29wV/E14mH
         3O6LyLpBjh4vBQDAc0bAm7H5XjS1CKIbcqKjVshlG3j2GzVCALWTCExhbN9Ya3Ozl6S4
         D9Fd52JuqwxvAew/XH9ayZzuLelgu/ANhVqEuYXioZd7axOgrkshV3QYWSW26ycujg32
         N8ErhTLDc0PBhTGX458/gUmygac86IRQVO9jGPmA3buJUnP9Iuwo52tAazSPPuU/2jCO
         VZ0WKCMkcs0eyHJ66iHAMsa/LVG1Zym4tz8SQdjw0WpH9VILns2UK2d+1xf8Ep9jdZkf
         8Bdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7ZKpqrZ3SRC8d1RwccUdQki+gyeXQzlhXbDf/1N3lq4=;
        fh=I1Duv628AoCeu5NEZrPcnFYPpNTtIMBa2O7cI2g+R2I=;
        b=qXLZQqyTiageXkiwoLdD/sOSfk9Ot0EQAI3UKj/yn11je8M/8ZcLyrXku4fgaSNa85
         erBPAHJT216Z5is+IJvIUbeSQtLsCtsH1gDz+OMN4EuDiBFxZ3XESfWommHIwN0y0W/l
         E5XBekpc1KZ4NjpbYwogS1dngZfqXBySxUr1AlzBud9PcwOrjsWA6HzmUsMB7GoqjFF8
         6/v+mcpaDJMzqKaGb6hJBZIQGoi/rp7sPiv9M6bRDqTENqIaEcXDj+h+PtwcyzDqgDE3
         7SgNeaBqk4WSUhAmpEZWlJKxlUon8UrKaM+pfVNWxEamL6Gym122kt0wdxqgl9FR/6q6
         plfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794613898; x=1795218698; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7ZKpqrZ3SRC8d1RwccUdQki+gyeXQzlhXbDf/1N3lq4=;
        b=L0mPKacGRvyVQkkhxV84mofosA98ByFYXSswTFPT4pZgnlmXDtKDt6Y70WyR2uSewQ
         pDRl+j4Jf7f3NpYWyUVSPjcXiAxHlIErmi7YDfys72W4Ecf/FST4cxN/z9wL57zWzhWE
         ogUlLSCH0Vl1RNxQ5UU6huQm+VockkYr8t6uT1L8m/dp/tEc12fTtkCAT3p+8UnujZjR
         Eh1Z1FkT0UNn3PfitHK+//3xgxms8cIkcg1Y9NNcDt1EZ+6Gjrr1x9kAEl30D9/0Oobt
         9COLQHOQWxbIUQuuefNms/2lFLAXFTArE/YStf2Sn/3u9JpHiEoWs7rSNFOaPm+Yyfln
         ruAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613898; x=1795218698;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ZKpqrZ3SRC8d1RwccUdQki+gyeXQzlhXbDf/1N3lq4=;
        b=urm7gDZfTXHrRvrVA5MDOoiBmEQJ2GoMoQG6i/PvYFEajEE5nMo4eW/39z5jNeq4Lm
         saRIBWu/o0SmNH2B1AdCW274vurSFfZfjvEF4Og0vskP+xKc5LipYqEKf/RjHlncYxs4
         3yGKolbtP0wFqTsQgO+u52ToUw/5iT4PSLlxqt1LAN8Kr6PHemItVPxy1KLST7DpXpz6
         VSpTuqOop95PsFhi5L6Z052nq978b2gQmPNeQsKxMNibYetSk25lsr6lYrDQrkyG4JY+
         6scnCwGgy/cPe4e6S2TgIZWG0LBrK3m3ZBUxHFzN63J4akz0v8Si2nY9+ggznriG78e1
         eLVA==
X-Forwarded-Encrypted: i=1; AL+hErH+ottt0ymOU7L9Ed9qaRbw3mP0Zy/Xoa3fpyk0q7So6CHZNGhqvKu9XdlHnuuTZ+FgLpd3POSlTQ==@kvack.org
X-Gm-Message-State: APuU4Z8q1xddMbIep8XBInYFrwgQ/FV2HsiiV0tnRG0RzHg27L7+8VjU
	3u5WOFhUyOEVdfqHarBGOEz1LTUv3odv/ZsRNVNiUdYrQjtUWiktmLN3ktJb/1xciUb7NVWqmJi
	QxPtCBZoUeT5FeH8WkQ1j0sbJ4t9Y4E0=
X-Gm-Gg: AYBFou3mr7khBGJsCjIF57ENrpl5SfYR2BqA2HU7RWMbdVEemHzsW+oWS/Pe7bN4CWM
	LBG6GvLUPFxNH6UCqYQt0P+8tEm72wU7oe1JHL7ORuRfcgrfeue8ekOtw50vVywkrTzoMzigTgF
	jM/S68+TzEsh6dQN5ETmlc0n4/RM9wIY2TUwNuH/XjhzPvE8RwDVwKmrArH4lfhCmq8iHMtbk2U
	Odl3D6nTh6YmWcXpwkPHEJ8IQXexuELQR2qb1+E5CYjzlzn0nMKlzPhhp8eLFHeqgIuRGYLcFtJ
	AGPQslBVt8KSt6krgHnolRt9F7w8PhhGdMdeSFN4gd+Y7C/922+gWAPX36Y07symB1bz4elrt+f
	afjtwNAr4ew+sn0QhW9fI/7aRkee1oRQaejPJwW/3+IrMM7dPt4TwYBMyH4B3UJZpvwPJUOpINh
	0skTe75oPrqduRdWleXxL4OI0+WyQ6b+UKXLhuhhk=
X-Received: by 2002:a05:600c:4715:b0:4b7:6b0a:a2f6 with SMTP id
 5b1f17b1804b1-4bb55a963ecmr83924675e9.21.1794613897727; Fri, 13 Nov 2026
 15:51:37 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org> <CAJnrk1aMwrEHdv9v=1cC54QpxzRGpRMbiu07KGfyEhzQNP4XFg@mail.gmail.com>
 <a127857b-d1f6-409d-8c14-3622ea553ae7@kernel.org>
In-Reply-To: <a127857b-d1f6-409d-8c14-3622ea553ae7@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 13 Nov 2026 15:51:26 -0800
X-Gm-Features: AclHuK-ocbDgGGLGfqnYXIT7eA9RbomWthXQCQwnGcrmsUcJfk2O3Cp_x_Ue1-c
Message-ID: <CAJnrk1YWf=rJc2uB-sCwxSVFa8KperRn30bJ3m_1Q-026P68BQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>, SJ Park <sj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>, 
	azpijr@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qkky31c489sp54mxn8xxxctfibzci5qm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B046C0006
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794613899-76770
X-HE-Meta: U2FsdGVkX19bNjktXJLzDofSz8dy7sdhs0bY3K5uWpZY9zWTRO58WsDVD9KOQdC3C+hVqWEJhouFNziKgf/CBfI+zlKjfn8Hfcxb4yqrrTQNewgbQFQ0gFuQnpTOatZ1+ZLH4KpFKg2QWwu3Bv9iLK2Q1/eSxfRcefQz+iNGvBO1rHsxFUc4xWqfAXPj+uGlmRJvOpeD221zpFGQ6vF37gmLCfSUf7kHNDAsavMyHGa9TpZMMWVgAXJL7ucFp5wuyRBgFd/tlzLNN8J9wh9nJ++r6ydgxnFIupgKUo4IABIPVBTbfmLngMm/hn5wwbMrc4JoETO+WJpD/o8mjdwsDS7V+nTLOGy+pchKoxYJLqlHHGvFtNu1iIH3U691E7Kz+SSVfBEtsmVZkygwHcEIbAp1RtllR0d2lAuPFQDjcwH2Mki1QBG9lZhBXGpcpikQSzDXfntLxEoNrs0KFYYzwSUcpGIugre7xYhF2k3C3iqlr47cAJy/jTbMkp/m2lFB4NFzjw5UeL2tLaO913dhY9pODxMUoPmpvYyP2uhSOG4/U9NpoYvIlYoWXl6lrf/6jC1hM9hC+X9zytNR+L5aMWELjShK/BOHfZ8+ECiizykg1XPK66W4rYHAUk0eKrytilwBlHEkGqau+YiBUpaQGGLj8Pez42+pWJd5L8yMpFdjMhaZw/V9FKY8gM8HMQz/yPiuY2kDN/L+7ShSYVMuK/KDsM3WkDM9yqnI3kgIrIhRBx4cdzrh0fQqCIuIZuzWv7Os5bD8YFd2hr0dRfuE5n3Yoh5r4rfz0wcrfL+naGMHKY6Y4oUm/hmfW5yfyB9uiwAQZX7UU08haTgOtuQzL8eJcfMYpfbvfsYp+r9yVrjZvsYtmIRwJ1XEmOrHgm/X0rFT/GPHUBzQch0cv8R60t9kRLIFYzuoCYs2LYL3vH02asJw+4FOh7NgxN6wb7B2t/2BRwXyZOsajm3cmBy
 RUKz54dH
 KaXf15zFQGEs8efg6V/lrRtZDyB1HUcZC2YsBYd/EKUgt75spzkL7Mv9g7D1G4TzlaE6ea8M1LfcwYKl+VSejn7dpZvG5sRJJhgYPyFhbll4eTCuQKMBiIKy5dxaeQBIRd/cjr12M3SihKk/EU+XkuFNwVH2uDPqb6CmuMLkCDTMBNHzquTWHcGRpU09xTYgDHP43X+CzP4xAInqtpwqPYQDEZmpkTVZGepxfP72jRgzb/6pfkshhiggOD4hqPY21/kVKkPnlBoF94cdTqRlnqpgYQFHShjfW4DANoQaMG25NuqNYQr87sHIymmSr83WDMa0uk3my1VnNg1g67yuQ6iKs2yUthba+Fks0TXTNBqVmz876gzpNqFlW+5x744CtRj7ng0xrkrCak5QThxuyDXk1/a6h72mSW2Iu0jTE9WWIuXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:23=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/13/26 00:28, Joanne Koong wrote:
> > On Tue, Nov 10, 2026 at 3:49=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> Batching resolves the problem in the common case. For the remaining pa=
rts, we
> >> should likely just check in the deferred split handler whether actuall=
y
> >> partially mapped to then clear the flag if not.
> >
> > As I understand it, there's no simple way to check if a folio is
> > partially mapped or not under CONFIG_NO_PAGE_MAPCOUNT without doing a
> > rmap walk.
>
> Yes. With CONFIG_PAGE_MAPCOUNT you can (still) read the information from =
the
> folio, but the grand plan is to phase that out and remove it.
>
> I just keep getting distracted :)
>
> > Would it make sense to do something simpler here instead
> > where we just check the folio's partially mapped flag and cache that
> > before we replace the PTEs with migration entries, and then for those
> > edge cases that the batching solution doesn't cover, just restore that
> > flag back to its original state?
>
> As a last resort if we cannot get something else working (and we really c=
are).
> It is rather hacky.
>
> >
> > I think this would add coverage for the migration and reclaim paths,
> > instead of just the deferred split shrinker, but would miss the race
> > where someone tries to do a partial unmap while the folio has the
> > migration PTEs, but I think this is already a race that exists in the
> > batching case. imo it seems acceptable though given that the race is
> > pretty rare and doesn't have any adverse effects except delaying
> > freeing the unmapped pages until the whole folio gets unmapped.
> >
> > Do you think something like this makes sense, or would you prefer
> > having the check in the deferred split handler?
>
> The question is, do we really care once we have the PTE batching in place=
?
>
> We would still split for if we cannot batch (multiple VMAs, PTE differenc=
es that
> we have to respect). Do we have any idea how much that matters in practic=
e?
>
> (I raised once that, just because a folio is fully mapped doesn't really =
telly
> you anything. It could be mapped into various processes partially, or sca=
ttered
> in a single process.)
>

Sounds good! I'll put this on hold until it's proven to actually be
needed after Shivank's series.

Thanks,
Joanne

