Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B1AEF06E3
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 13:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61FC6B0092; Sun,  8 Feb 2026 08:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4C696B0093; Sun,  8 Feb 2026 08:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38046B0096; Sun,  8 Feb 2026 08:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B42C96B0092
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 08:26:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 50486D5FC3
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:26:34 +0000 (UTC)
X-FDA: 84421363908.11.E1388A5
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 449E712000A
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 13:26:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LOpPe/jH";
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770557192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzPMnIUrSlWlaSMXYDo8rfw4jshtFu4eqrIv4YirQLU=;
	b=KXddDKQKNMkVM5S54rfjwyujjYdpDGF+VGj24GnPimpkjo/FFZtWuza7cOGmZtb5QnplTd
	sVcIV6/oEeGritkUp9EbvRkA4Qgc+ZhNhtpP6w/EWPqOukuDJatBnRMtJIThHYsQbSJ983
	vTL6MjtYz66EyOlKihBHCSljUcXIPSg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LOpPe/jH";
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770557192; a=rsa-sha256;
	cv=pass;
	b=x6Tb3h+eeSqZapu/G1DuLIBuC5Au5lhIhpxB7fryw7rQjJe4mRa2HrlZF/6dOd5oi5euhi
	MThBCf4u4hvhoK3Bty5aA1XDmZnjVsYvhqX2fRy3tS0BSOBC9RtUGXl2fEno8a5c8GwjK9
	w9JLrGW9aWu8yBPm1L5YA4prO5yzlsU=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-385baa8afaaso31993271fa.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 05:26:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770557191; cv=none;
        d=google.com; s=arc-20240605;
        b=eGINp8FKoaW3GejFp8k2YT+/JNnMziUFRzKiSF/t0MjVAI+VXJ6SR9QmkXb8hNklme
         UZ49i1UxSpau/3vxiwcfg2e+z8NjubGGsQESbc0MK54SXPQkEKP6NBEV7lILr8bXXIKQ
         V0gfz1rAzGEvMwSX0y36pRk1KROjmzQVoyqm1OAr5+IqVTBiE5u+KCC2UMkmRLFkdTIM
         /xCsGU6f7S9LgGOwvawbdbWRj0yFVbGc5a05Hj6k5byE9vryiUW1SLQyK6x6s/QyQjH2
         sHPGNSJaC97rSevSbAD+ndRxJonoTg7XM03JGUX6HBZ10Rr0cVnZ+YtVgr0GosvireE6
         BUsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FzPMnIUrSlWlaSMXYDo8rfw4jshtFu4eqrIv4YirQLU=;
        fh=0D/SNspcTTLflWACg0du6DxuL8BXSYNhrIQmiYhkWoY=;
        b=Ju5c26t8iED1euqzCnZp4TQt/P1HLPEcj3XCOryZBkpWZxUIrYxmJITWwzUl1QgpcT
         1drBnLxAjuYXcvpnWj8kZXHtQ3RaBgZpj/Xkbx3zxbSnF3skDphJdgLmklPad1kJajz9
         r2EPYwLIGK65U3Ia8q0VEWm55pRV980/EUPePa+7w1vTYgXcHIkxcujT983LvIJvc+4G
         DM2+WCvatRXs3wnVSRJEK06LwvLAku/4R9kAgq+nVScVM8ekWesOAAdvqKkV4b2YCbRj
         ITOfMjJkQy1Jvj7v5/gjs80/C47tV5WT4yVsipUsBPyw7SUvjoNrwYKs9Kd9pnEZFDon
         UwPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770557191; x=1771161991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzPMnIUrSlWlaSMXYDo8rfw4jshtFu4eqrIv4YirQLU=;
        b=LOpPe/jH7JWgbvuCotx9h+an61H/R89BUWJzL8zMEn5LDH5tlgkPnJvo/kave+q2Nm
         YsEeGXxz9Yn+PsiHWM3O5a3o51CgzlMdJOIfRu0+egGGQQIQevdMkgbn4ul/nnZHA+n8
         +LWdaVo2nmhgjxqU95RvC3v0NAZW+HPSG20XfJEZEhwUDuBPdYxaDumLQX/BZRQC2Q6+
         8jBHW8J0UlOiEcsnscF8OLki5+C8FpEnJHvyFKH3hLJT6lKQkZLi0llGxd5QJEOyWTKd
         JnPFxbESdjIrJ18cx7cebMalMkbxm/EAqLWt1mOTbGau/6SWp5HY/wht7trYUUj4Hwot
         Bbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770557191; x=1771161991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzPMnIUrSlWlaSMXYDo8rfw4jshtFu4eqrIv4YirQLU=;
        b=iNKPyLGLNpFLU0PTjUMFEC/KQQvGheX8fLtLHxMpZeCnistgqZ2PtfYlClCQW5th9E
         d5v2vTuMsfQRHY2uMte/CF8Dnoo1SqfgP3zwSzyGusaL3l9e1m00To/sfnMOiMN6Vj38
         0PoYR6ajY6jhIFty4DljzjVU5plWaXEWGDBucJvkB8W/6QEn3EEUs5z6pf8+1akfukLL
         apuqQn2E9SylYq/vWI2oqSGuZ7sJ1yQMx1V9Ql5jBXepBpryK9WlSMEBkfbHtAPi3EQb
         AkWZl9Zuq/r+BGW9612a4XDnklSgwFS1WBQ79nvhHwj/eU0E1Z8/pvw+iQHxGz8wv4sd
         OO8A==
X-Forwarded-Encrypted: i=1; AJvYcCV0HWbotz+1p4b71xp4loJ28hShBatXoBsJ36nijPcsvW6YYp5rNRY+A9YQFoD8P46EXlFwFxrZVQ==@kvack.org
X-Gm-Message-State: AOJu0YwlAFmnxmHXQDOV+SPogimpMSsK5g+oV7qhR89WXcf7RmE1On4N
	NIN5UKUC6mPKb8LG2+1KoP1loSePj0nCpo2NK5iveP+9U5c9QWshrB87dCPuyrg/mKo7REr9YX7
	yQqNzZ/rV5x/OXI0hroGUy10Do2jtlLRoQryw
X-Gm-Gg: AZuq6aJlKDURLy6s9jgXYW+SFImCiv/oR9D9qdHVVjOburoL5O94t9/IMuNNRgoAPT+
	O/vjNl0fZ9h5oRE0+fC6gA2FyErDBwFqr8xTW+neWeh6iSK59oUc2ziVe2L+KMbOm1cgf16pxuG
	rTGSrEf6CBK+rqIX0StatKPPpnHoV+L5p3QMAp0ZQ0jHI2Glcrt6mkGzHqju6apxmIlrIfD6FLc
	NAvA+1edMNlvfEBPS/MQW2pffzbjm5TCyKlLgflUFQ6bbnjUeQ6GYUeAF+orsasuAVTJ/lJ
X-Received: by 2002:a2e:8a87:0:b0:383:1255:9240 with SMTP id
 38308e7fff4ca-386b68182b3mr25744971fa.13.1770557190424; Sun, 08 Feb 2026
 05:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev> <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
 <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com>
 <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org> <CAGsJ_4zBpL6a5ORAQUFwZMM+ikmMS8JSo9enLDZ7VFT9kkge+A@mail.gmail.com>
 <bfda8f27-cd2d-43dd-9fdc-cebf7b7cd7f8@kernel.org>
In-Reply-To: <bfda8f27-cd2d-43dd-9fdc-cebf7b7cd7f8@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sun, 8 Feb 2026 21:26:19 +0800
X-Gm-Features: AZwV_Qjnb0hrc_baMl-CLvkEWHGx7wjBdz6lnXFtS2sh5f8ZrwO-GYDrBRG7K0c
Message-ID: <CACZaFFObE7fy8yRNFoYhntOP_x-7eXRbVhTg0xH-SjWSyjwfpg@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: s7zuqor361gc1336qmjuccgsw3usis1t
X-Rspam-User: 
X-Rspamd-Queue-Id: 449E712000A
X-HE-Tag: 1770557192-829620
X-HE-Meta: U2FsdGVkX1+eoRRzMUWScoTWVujgJLtyiyHegcv+YPrjHw8ZZtGjYFYVvMHqLbG7XEtuxcEieDWCgh2XKtrwMRpGwT37bqOlcgTxyUyEEuB+vOrp1LPEAJKaCSvurgU8P+2amtSnDLdbZqVHOkDs5rr2eHZY+pHy4QNDLLgEYKKr+gjyj7vjDTeAnu8oT3jtCbyECULVKOXPezyJcKeVwL5wZjL7hgcpTQU4pPrUk4JqggYWESuZmc5VOJmXBBARCgqHIgBiWaQHEYzQZTIZaqEhH0Ud/UUty1o4UpmQyu0hnm1jZnx//SMGrZ/1um6zY0rCfcaTpHQof0yDQE2KcgODCIS15cWKcJY3MJXQNGlcEE+qNHWUjhK5H6j83X5Ud9zV58yLhoA42/urL3E/OCQa5zaqvfqn07lvPFri/hXtMA619fPef1p32ft00NfeJ+/FMH2+djJJWiLpwUhgaglEdmhJMxKoe0+YZsMl7Jcqe+YJ6dZBWQTur6FfzZyiXOW2WB8RwJdfu/jVxlCEToTikftZ8tBnGunyqk9OJ/wyF38HGmw5LICPdQ0VZb/7c4SxaPNFa+npZlOgZCtws7OtIxCpwawawegDAUr/R8lK0mPAdiwE7cwrjYGn0XaidFx/hb0CnFM74MmdJ2B8FydF08hh1EHGhk6KFsISVYx04bmTCQ3n5q8w4HRyFkiwxXIESkPyoglNVQxZOdFYjO6ZwCe4N/4bgwlfs8t1gRa7rehJnrZTKHnCtZ425yOX9OriUU6qaBNhu5WAjAzwzBrsOc0h/k2uJwlzyxAKUqCOg7jrcwlL/Pe8GexH4E64AKmxnkXnJ2twKoGk1/STsNywMmkPSfh2R3gDzpqeGMxMqUAZz0P1lhlWGm1tquaJzbkzkwu7YTPIpt3+a74HmNapKKsDpMTP6chP06FYhi3QQN2Lmhfo8W3Pf6GQd20msNUFSW0AQQ7l+OoKZDr
 4TwS8slc
 1KROIqINX4LPZ9x1D7HJIRKT+1AOVf15kJwdBI9b18/DEIeJ7wb6JIEFDZlm8scW4rg6NkUnC2aV/+B0llTCXTTl10Nsv0zz3V5+ptfbUVjd9VNVDX/UfE+kHmu7FZ1OZEZFByKW8BvUX4+M3aKlra8/NfPUmFvEUR0yEBPB3623RftkRxJkj5zTkzndtOP7F3uZkc0SabpC3gUTg3hanF/GisF2P0Gi4xg82s+KUB1K4MbrQj5VSlLwArxhZGpEAGvZ4vzkwtm91mCYjo07pR7Ce5mkgpNf8F7UV2PbKQ7a5PjP37q7I+kK1ibCOrhen3VcXOzI56hvGOcgGmYSxGg8LsDiEH7nNyUtPbMnpAwiv2lXb0WvqxBabCAoVfirrC7julGwC+dcSOFwhIB7iqUBKVJyZA05RPNB6RUOh8TOiNJU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 6:25=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 2/7/26 23:17, Barry Song wrote:
> > On Sun, Feb 8, 2026 at 6:05=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 2/7/26 23:01, Barry Song wrote:
> >>>
> >>> Maybe change =E2=80=9Cjust not skip=E2=80=9D to =E2=80=9Cjust skip=E2=
=80=9D?
> >>>
> >>> If the goal is to avoid the collapse overhead for folios that are
> >>> about to be dropped, we might consider skipping collapse for the
> >>> entire VMA=EF=BC=9F
> >> If there is no memory pressure in the system, why wouldn't you just wa=
nt
> >> to collapse in a VM_DROPPABLE region?
> >>
> >> "about to be dropped" only applies once there is actual memory pressur=
e.
> >> If not, these pages stick around forever.
> >
> >   agree. But this brings us back to the philosophy of the original patc=
h.
> > If there is no memory pressure, lazyfree folios won=E2=80=99t be droppe=
d, so
> > collapsing them might also be reasonable.
>
> It's about memory pressure in the future.
>
> >
> > Just collapsing fully lazyfree folios with VM_DROPPABLE while
> > skipping partially lazyfree VMAs seems a bit confusing to me :-)
>
> Think of it like this:
>
> All folios in VM_DROPPABLE are lazyfree. Collapsing maintains that
> property. So you can just collapse and memory pressure in the future
> will free it up.
>
> In contrast, collapsing in !VM_DROPPABLE does not maintain that
> property. The collapsed folio will not be lazyfree and memory pressure
> in the future will not be able to free it up.

Thank you Barry for pointing out this corner case, and thank you David for
suggestions and explanations.

LGTM, I will fix it in the next version.

---
Thanks,
Vernon

