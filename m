Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40C54606A331
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=XsYl4wxj
Received: by kanga.kvack.org (Postfix)
	id 4AFB76B042F; Tue, 20 Oct 2026 04:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461336B0430; Tue, 20 Oct 2026 04:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F916B0431; Tue, 20 Oct 2026 04:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02EDE6B042F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:22:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78DEEA8658
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:22:35 +0000 (UTC)
X-FDA: 85342313070.23.D65ED53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 847CC180002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:22:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsYl4wxj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4jp3dxFAzyLqjrHv50Jg9sR4jM2Bn9qOTXiixdLDnA=;
	b=Wc1qm+o+PYnJdjWOx4as62gF+Pn2dfIp60tnHAn7BiVP0Bn/pl/RxqTiz3ndkHolPMaJBo
	IellgGKkFnwnK+AIQDTol3rWpxKk1Sy6EFzFABBAQ0vy7xXQzBhOVphdSEK1RA35I+rqhA
	NUGo7VgCrDO3IjSQc2TahR98VNl5k44=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XsYl4wxj;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484553;
	b=qne7zkIQVfCCPNMD1uXDl5bvOcogsfKr2HOpiEzI+OL29N3M6GsOhV9hZMbrk5+qs6Pua4
	kA37d+7VUvdBhKSQmpLlhxKcLek0nFmHLxUEK0S1tdj0SaxwtU1ZmFgB19RYjurbDB5g9G
	dMJTcUAT+G4UUZWEuzx2l2IUCbxAtxg=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a0a4aa99bdso3501652a12.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:22:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792484552; cv=none;
        d=google.com; s=arc-20260327;
        b=bzIBojNhqWDDOPM+2KaYPxtqkdN4WpS9+nAp8xCqdRcMM++/UMJDfEu6YNZ4ue9vER
         UpixRmaqoBbNkRVSXQbmj7U6H3047XK1lsgTzScQad+aEZsVg+to4WcxgYMMdelLA8sp
         uHlJF9sLVNuOCyuqqqr97mVUEwCwg7RivLp8cy4Lk2sDNGNaq2Bhf39Bty1c8x6tmkYe
         AzqdqqFuCf155yPr5DqqbKihb6AGD0WCunDgUMCvGc7efXtJjDqF4NbpmN1QrijxKMZN
         sBM/RLatKa24PieS3oovfi/tBw02e9M9U6qA39tOb2o7922gJQ1R+RpOyOXhXmMQP2iN
         ay9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e4jp3dxFAzyLqjrHv50Jg9sR4jM2Bn9qOTXiixdLDnA=;
        fh=pzG1TVX4AKAKu9GEZB0Gb2jPpZI+2GBA6mXueWY4qmE=;
        b=g/Msl8NStuYCZVOPuA4+h+vA17YRwi2c8HkwTJ3nir+HFm3ztf9UZzIRjC/fFl1AEC
         NCVqAe5ba/tmtFrRtwcZgFLJk+SzAQGQpyToqsnoGQb33Z3GVSP3mdEbyl3EQ0uhezO8
         ZWWFFnyOaKn5RPKE10pmj/PKqvL8nl6jeY8pcUMNUCJ/V6fYfyUCYn5iLGGlmhatTiUE
         oPq32AZgvKmodjayFxUk7AvYkH+t9XoIyTkWEs3rLj+RrDUkV7h9H82U5JSutV+2NZ6Y
         hBpkprVd3iOH1xRPBrbRQErErW4SEkkvTpzYEaXqvYMSekxVB3g8l6HRTo2OayjrjBNd
         kApw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792484552; x=1793089352; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e4jp3dxFAzyLqjrHv50Jg9sR4jM2Bn9qOTXiixdLDnA=;
        b=XsYl4wxjOfhW9Fe7EpYRtL0gNRQZ5afkzNuKS8kTtf5HHTEP2oXvTWAHsixAbSt7R/
         DkGaSTVDXRZiFZXds+6eZ3uIeVGp+Ulsb1aiAnbSfAq0xomKt2cm2QTz4EyRVazCQQtA
         zaij2qWlrtOZGani/9sGKXK7Fupiu8vv+nHjA4l1FGFw4kYTKbcMZtya098z9oUawayr
         9ci3yNgdE6Surd2b7uKu8/n/M1OQVPZTXY3Jq1ljBLMyYLRL4JS0jBzkeRpXPSrDL2cH
         Q+/VXDy9fIjrC/aD48siwIaXRXPYxE37/jUtDd64nqZ8zXMjkZSacCvplX3/uJ0CsZIA
         3+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484552; x=1793089352;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4jp3dxFAzyLqjrHv50Jg9sR4jM2Bn9qOTXiixdLDnA=;
        b=n0amD90s+Z+vFnY2ebBbPqyiTIGqUO4il72yMo2iXy7MOH85Dfb0MMPw+of72I4IoR
         NocHyoNBDEYIPKz61bIsNnyOC1VlOyEyAZtiOnX2o9PDiHr6cPWXyLNLL2CvBeA5Seds
         Oupc9UISL7n84/xusTuzdmULd4rD8uH4PKRUdYwEEYJvqoD/bqkmXMsKMEgYdr4Pew62
         4v42eOACOHklL6C+N8TJchmUxBvZNerdryaYi50WUOlHkCMxozLM7TpadaWMp1KRRcEc
         ZiBWj+GvVlmgD8QS0NQ5BpEHsqih8ekCurIjeH2VXs/7UTZfe7tVZiKZVWcp4CH/Lkvz
         DBvA==
X-Forwarded-Encrypted: i=1; AKwUvByGlM8Yb9lNA+KFnx6huIBOH0jb0nDalp/qqzkao/euzqjnRz37NMlxo+pqxj7bSacAdcHtAun4zQ==@kvack.org
X-Gm-Message-State: AFq9FYKPGp651o4TEUDv8a171xUPnK16Q4WWYboOyJctkJRpfgNDpImB
	x18bOjr7+9M/lBM/3hE1O0QyUZ73HqZasybPvwyxKrLfD3kh9CYOQmvplUuyT77pXGKR16gQI4H
	67BFmL59eJxhRuZ292t1GPaAWnNMReo9aHspoIwc=
X-Gm-Gg: AYBFou1o/Do0zqQLR+Gtd3V543vkFbipZcMWHvGxl/TZ7Bl6I3VlQs4R7CV+2+wG4lw
	Ia/LnaKBxkvSD7eqePEWugzziS3N3E/j+Qtl9bvlrcrT0KV9Sh8doBpCURpL7yQUyw4Ir2hXV34
	L7wnNoxbr8x+ou87TuPbimKaWXXu/nVVDWrqfZle5F/LPtoxZDdLnhyvEfFoOsrUobNMUoLQoZP
	kWhPJ7in9rkeWBPod7OBZCHyevkg+/ybWeLQIX9JHIQDQjhUXGfWfJgXIXnT6QiBKnUqKehKD0R
	GJDSSsrL2EBdzLYmrttCBEmUc56aegrTtodSM0IEjwdoafnuE+9Kg+UdCOoHkplQeKL+P28n/5u
	sf8q1Q0qQeVYe
X-Received: by 2002:a17:907:5c1:b0:c3f:8c92:3b4a with SMTP id
 a640c23a62f3a-c419df3e37emr689197466b.8.1792484551834; Tue, 20 Oct 2026
 01:22:31 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <CAGsJ_4wnuQhyCkMq1Dub8HgB+uYAjy+LkgBxCRJG_kZiwAxA8w@mail.gmail.com> <a3d410eb-e7ac-43e3-bdb7-d00445cdc7d6@linux.dev>
In-Reply-To: <a3d410eb-e7ac-43e3-bdb7-d00445cdc7d6@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 20 Oct 2026 16:21:53 +0800
X-Gm-Features: AclHuK82qZWD01jLYGYlE1KkBrPsLWu_FaSyfHwoBsRgP3V8VjafyDQseh67aSk
Message-ID: <CAMgjq7BEC8zs6St1QCXfjONypUWu4yqKK8O65bzuLcNnAvghhQ@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in lru_gen_folio_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 847CC180002
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: pd8zbtrqffkyqme8yebi79wfyi8t83zc
X-HE-Tag: 1792484553-401109
X-HE-Meta: U2FsdGVkX1/HVaeGxL2JWyI/+3Cb3DgM19OWOUbcT6t+3iBGQzJzsVCe4RSTM0gG1sVFgb5rimSok3PWfTHj5iUmRLdtoQ9LhBGeH4QY2IxUuxU3wJ8BxQKEG3uoZl33rW/DGxvQpIMQ4U+LQjbs1JywFV4o9zcCh4lQdjjag2jSa9OdZj6n3FEdwSYnCgR6+NBaPjlws88qKwvCtRI5vziocBMYPjxVsb7c6IEelaN4wKM0uM38DluRq60KDe+bKlOD2/sn/QDOgbTQpEi1rrFJLZuLf2/9lddku9+Ov8TS4DyYh+4sN2ne5uNRCXdZRZ3u7NLfzB8HBGEJ0RthT1XQfGsUPcGlN11UHl/3ODk+o4jiYo3qxpzRcF9LarxQARv6Rn8SMcv6+0g4JKHIhSATqsO8kvAEstqOqSnOPBPcv5v/OlhzS9EQzXrooV27kUqbJ3cKJF68HHf4rL+lusUkhb04nzxVhOV482zXqDC5gjdneujQupQHalHGIX9tfQltqRyabOx5PVyOrbYoXQH9SMrwPzBqPo3MGZHtIOTWlHJU4/LqeiVb8erq2qqqbBdqTPSs20Htwsn3mfdJqqmmEdAzBwv2FcALlaG+nt9FDrgFDSQNX9zZbDuM3Ld13w9797LMT59Nd9uDYpHT7zRmq44Ds49zDWaPB2+PXVuxImL1DqtIoaPOPix0e6iez0ThuRwnHLRMQszjNfXHwOdZm+HdwbLJQ9nwMkDVInyRr3pEfyejz7nal/OpyF47QwUtlR3FPzMCroI+5Z2YkVUCFEE9i8P5aLPnYXJ/cF5KO8FRNogUEJGoy5KF7zMAeEEKlyNJNabWSO4qXHgiWbNKRvDtlnmWGtTfC6guGfp6AUEZVWD8MwbkPUQwnZjT5fjSMsOa2JAZcoiykUp43dICi4muNKk4JnUft3e5BlLzWzIDPUxxbydvUMDVgYzBhmEzTJGyj6zE0XL1VJG
 Kt22cvcJ
 3UgKluHKzQSVVQub7UsOF4/d/qNq16xEUm3CR/VYf+64yfxCdG11Cn5ZMwyMMXtyAWgZxfWCjMsum2M9JUSZTjQNw76sf6oQtl4ZmYzMYYhqtiaqrnRlaAF7xIa+NZ1xzDeVzuC4/VYIEBQB0tJ8pdXlUFKXnsr+l+emA9c480Hzv3i/ZqE1n6K+YSmwTfM5oiI3kvK6qPu1sZ+rgT9Wm74XSo2d5hnMpBKiPgsM8BAgJS4R8wJyAwRu6MHEfII6LBUgC7Q022ZSrnOcQncnoSNoruoA5u/ZdtIIpbeF4oFl6LHEojTCYxLqCP7pxGhL4x4sIaJQ4ylSNOgRpdC1HRjvZ2XpS0HolQJM7u1niCNb0R42HevhAT9P4H/r8CmshJX+y81pZxzGqnrCsyRGdQbJGLmDcWHFLjP7F7Wm3CW9PgewQ8TVbFXiYfkwy4JPnkobZ4Ms1pnH97jnEdEdl5AYVoCl1Yi0hlkMVLpfysIl5pVvjeOjjTLyPqRvGc1XHY9io
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 2:28=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
> On 10/20/2026 1:43 PM, Barry Song wrote:
> > On Tue, Oct 20, 2026 at 10:36=E2=80=AFAM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> >>
> >> From: Ridong Chen <chenridong@xiaomi.com>
> >>
> >> lru_gen_folio_seq() computes how many generations below max_seq a
> >> folio should be added to, but stores it in a variable named "gen".
> >> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
> >> seq % MAX_NR_GENS, so reusing the name for a relative offset is
> >> confusing.
> >>
> >> The comment table above the code also no longer matches it. It only
> >> covers the PG_active and the final branch, leaving out the reclaiming
> >> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
> >> although lru_gen_folio_seq() never looks at it.
> >>
> >> Rename the local variable to "age", redraw the table so that each
> >> branch maps to the age and seq it produces, and note that the result
> >> is clamped to min_seq[type].
> >>
> >> No functional change.
> >>
> >> Assisted-by: LLM
> >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> >> ---
> >
> > Hi Ridong,
> >
> > The cleanup might be right, but this part is changing rapidly
> > with Kairui's MGLRU-FG series. Maybe we should wait until
> > that series lands and then see if this cleanup is still needed?
> >
> Sure, I'm fine to wait. Looking at MGLRU-FG v4, though, only [4/17]
> touches this function, and it mostly adapts the workingset checks to
> LRU refs. The local is still called "gen" and the table still leaves
> out the reclaiming and "can't evict yet" branches, so the function
> stays just as confusing after the series.
>
> Or=EF=BC=8CKairui, do you think this is worth cleaning up? If so, would y=
ou
> mind adding a patch to MGLRU-FG to clean it up, so it doesn't
> conflict with your changes?

Sure, I can rebase or add this patch in next FG series, BTW for the
comment part I left some review reply, I think we better keep that
part simpler as the if branches ain't too complex to follow, repeating
it again in the comment seems not helpful. How do you think?

