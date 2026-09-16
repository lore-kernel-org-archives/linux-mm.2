Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0707AC88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 01:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4F056B0088; Tue, 15 Sep 2026 21:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFA56B008C; Tue, 15 Sep 2026 21:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE436B0092; Tue, 15 Sep 2026 21:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8175D6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 21:39:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E39A21603F7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:39:55 +0000 (UTC)
X-FDA: 85217919150.07.D9C747A
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id 02F0B140008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:39:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RBd+YWln;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789522794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7/Be39iQ67QXJSJm73iOaskwF1HV5SnLrr7SsaSjB4=;
	b=hCxD0vLGr55YSoW/jfGk3Sm1ES0XFWwP1aAmYc7xwGjJ9GwIC1fdNnMud1raFDDrr5QgNQ
	T2Vvz9rIWBJGgtKUW/B5di3sdHBtcKIexYMDSGwKRg7jspsueNQZBBLwAEz/03G68S+RuE
	F1ybOS4YNpncBu0DosriP3Plgpzymto=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RBd+YWln;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789522794;
	b=XFSDG7NXzO94H8HHwkfAtEzb8uD3HehuT9Tri/JKndZXyfdATlfHllczKj/G1az2mSH0T9
	Yrkb8ffpXZWI9D61OJ+T+jbfLaXyCWr/ui15FhgWrlbimH8FRukHb8Oa4jtct9GXWSX2uj
	n8CAeRlSf/AGB/M755+CKGe2brcYfss=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e83a388f8so2745065e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 18:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789522793; cv=none;
        d=google.com; s=arc-20260327;
        b=GSX47rYJB0GVzkfpwnSYE4ELuOv1sHKrJOz4EFli0GZVPfQ0ynQPRGvDzIiJ0BA+MB
         B2Mg0GyobpSFPIUIzbJElz9c1eLyRhefG/sM9tPPVPYQJvaPI2dFtr2IJhRpjNOOf44e
         fbWHCuKSfdbqflOcxSlFRr90mznkGq3ezFLgz5VEOGyMSjyUsWo3oe0Vmoqirub36Ifd
         o5iYxq/Xt+CKIlxD6dyzeHUfljMSWfq6dTO2DdhS7pdgLY7l74w/SDF+ajuNy5ComFuo
         jFmbYZHJXHOo1tM/P16HSqCWaczcIjlX9qqVwYW/AaQOLjjJa4QqXM8cVL62N9gIQ/e/
         Ic8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F7/Be39iQ67QXJSJm73iOaskwF1HV5SnLrr7SsaSjB4=;
        fh=nPjUk/tyVW2jPDdfhewHYgjcam5tLaCBtOrW6X2AHzs=;
        b=KWRBU3wnTxd7mQa7VzT9yDixqVJ+ga1wjxiJMqVeBrh8cs/HOzOTpPIMw+UwxQEZTE
         WzEtnV5is24T5/FmzlKi8WXUjCFj8ytin937tw8B9WqgWIDFJV+OqcwP9F0a/014tXgd
         biXWpx45VVfvHRJcCw/SNmYL/wSk61hRTPEGs1iQMDRCQuzBB2J6YMO9wW1qRL1PSN3L
         Ae3RkPTBjenGp2bj4bt+8WdwSPqVgpJZdBrH5hGPVnJwmA/4ayjWVr39QwIdRQfNmg4i
         U+7SjAoMIyoHLNXjkPaWhz1lKiTbT9sLfUnfvSDJg5dweCzvlvqbYjPich2xOY5T+Y4t
         x+QQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789522793; x=1790127593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=F7/Be39iQ67QXJSJm73iOaskwF1HV5SnLrr7SsaSjB4=;
        b=RBd+YWlnmHgAQlbQFRKJEq9vLZl4WLF10b989YQAVWHGl+SOwA+AYoFh1QE2CEMaRx
         7Dhn8kppYfHl30ViPFlf/N6basg1uE6Y4o8qZXhjfo7foIea3PTUpSv/XddVaJGlu4Ps
         dYcH1PlICtrMYOWNkLXcAa0DBqJzgM+8txs9v8mtwlEse1yEc5lmV4/l4ekFChvl0kES
         U8SgxZzTPhqwANlfS2F/XfiPZEr/ZJp8sr0qZcR/ogal/D8gnN3N5lk8bSj3wrexdJnC
         JrasRAa5AC/8d1nr10JFr4vs5vdPtaaKFiaTEHcSZUTiIGEPsbQpcHbQHaeDT9IOTI1F
         5B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789522793; x=1790127593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F7/Be39iQ67QXJSJm73iOaskwF1HV5SnLrr7SsaSjB4=;
        b=FYs5QXO+3PbkL1utgT+9XooDaPv8F1TokxLdKv9GRBELjq7Gk+8PV+1q3VQ5w3xKlA
         atFVwRLBeXsfK6aMxjQssVtRhXsQX95ktbK9MB21kK2p8itauDTG5mD8YZn6w9wVfwku
         3hvGrsU9guLVp/Fx5XLJT7OHAbTnPQgw2iX6O+f2apcwUoA/eF9sE1+LacgtvoHQsUTJ
         qJnnCcaf7mBigAhvuEDW3aJoUCTbP5tOSyzlADwjNXxnY3z9nA1keACscKznYg06OjeA
         k0/1EH0q9MuZKjbnC5ErdfHrhjQ2YAKeWDjWijRYxo1DeDIXYdUCtvf6bNXYUUNIuqiE
         2QiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxdQSNulcHWq7AIjNJfekkfNBxNa0QeTH4XwIwg7fQj0l+yHxu3eUuMmIebBbzpU8+wJaUPs/dP6A==@kvack.org
X-Gm-Message-State: AFuF++mQCvg+xXZ+aqCfyoNjgRVNG0mto157ZdDiv7DBBsqKnXTEugCQ
	cIj7mD6yAIrhAqOg6uB1pIuZX/BEBJK4xcHL+evyeVuLpyVViJTtU41p46BypfcJd5IL6S30GDn
	540Ie5tdEVwRgVnheO7+0LzuUOrvml00=
X-Gm-Gg: AYBFou1/FbXUY0b7HLNX1KSc4IPFPUW517xwjiB9qPErrmeo8dch/mcjO4uQDu4fAoz
	sG2owFxOV/mrKKhOZtXRihNFSBUp5Ta89ASpVBQt/yVw6fvszZTR5dCEeQlagcLw70vZWz5x6iq
	rNp0hvYWB0mSThX0Oaq02cZSlLQTVOZyRHGG6PJw3RmWz6jM0qY6dWUziSzs5JxMF5xWonKHDjF
	HE4G25Uw/2+DFqULJhSq87IVvo5V2dYUnSq5Kaf3bs2K6Xpqy2bQ6KaZOGexyyZYwU7y2wThOzj
	oyXK+zkHv63U2dgBuBYMKHtyjj9sYcBsQ0hnfob4TN44zetdKIYYyZmSl1OzizG7RGConr3f+om
	992fvw0jmX0Su
X-Received: by 2002:a05:600c:3487:b0:499:b65e:49c9 with SMTP id
 5b1f17b1804b1-49eb7326671mr12886295e9.10.1789522792473; Tue, 15 Sep 2026
 18:39:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260915033050.1579457-1-kunwu.chan@gmail.com> <20260915141428.90098-1-sj@kernel.org>
In-Reply-To: <20260915141428.90098-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 16 Sep 2026 09:39:41 +0800
X-Gm-Features: AcwNN1WkItfrjGuvh4D30_0jXdjk_3N_mQEQU9h1o2CriinlbmIT02nd1bs-e_4
Message-ID: <CAN_Opa8kqT3veKMw2Efir1p4mKH3oQuD5OqyBigjiBMvw7pjnQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: a91qcwqizrsk9z9fugy4orafnckuac6a
X-Rspamd-Queue-Id: 02F0B140008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789522793-727298
X-HE-Meta: U2FsdGVkX18MR0FCXjo3SdUwYvLA36stygb84khUBeTBkD3Mg2V+POjDhSrMAyGAu5AHoGqAPG+8qotGamIh8UXTkY2RT3KtFlAFNNc0VwzphAMsNSleY2LzCayez+y3hWHUshQaSvxPcPppOs5UyB8MJfzCDX/MNGnrsRwt4btAx2QW5FNU81GRxC0CCtckGkUYUlJl5R0/VIbld+3BRndmlU9NL5j5NYxpv3hV9S537F/YWLf6TYO9fsy+fDBfZT6qaus3xxqG4hBFTZYvPJ5sNcqF7MAatb9fgpeuuQbf8Aydj5q619KasjQ6a1t6Lf6YjbHCx6iz9rLxXIXclm1Nt+lRGeW9QRucJ0MbyNIFU0FrEC0GPsdotdKqCOHFruaVEw1uexdy9jKNI/jYP7+iZxP+2isLgAtRCHSOwphZI9JN2Id3+u6JFLRHfZR2S62ES48teFYGGexqaRFx2YM7Y5/eagTVYVHrj/GOzpzs6IhN+dt+RUWF+WYvM8ldx0JnZkqozaZ9cqFk0Y7PL11nsi9TcjCJd6xALsEm61miQ1vYQhh7eYhtZI4nKVXY/XxNyRJncasxadwIRnshRQHjvkVYHwVSng3AReFrrLLB+E3xaBx22r1rBQgjeLQH+5iwTPCLp3oDCBght8/a/0+CirDOHl6yrKqyOPZeP4/k9q47BMHLIsg2IwoJLxBMoLdtYr3MuKULT0b/LZ3qkfNSUHqQ0f1/2wlU2AsOZbqA64vXgIqgu2q1NZ/9A+6IGWtLpY+gj9AYrHSxpBG3UN8C1JtREM59NuGrbrDaG2ldIaAHMH1YcEi4+NenJ3op9uSfXlahg3sn9WyTu4eEs9M4zJNqNTHSqW89n74c8tbR1Jv2MejmMUDBpXI7oYxhonqCemwQ7X3Xe+RGF6mFQ52Ii1xZCseAU6pL27N1PFTb9R4Ap93DzNi1izL17irWwHdhc24e0pE5cKGLo2L
 NBbxJyA8
 TypvhYMIxf4mYwh+NfNJSCbekFo5MflQ3EqkeXnizIrktwK2x9wxVJhyLy8LEfusvgGbshrmVjHyI0vqPcuuYyiLCI93QZ3jadyMZhirTwWUlXyohjOFx7wevwKoUcYIQ4YvchIGsDt+F1MbSkJ3UFQ78gfNfmMRPlddYLb6ENXRqBXk4PYEb2WkV3a+BJPEToU7ZBMt457hqO0vDxZawyH3RZJbbpZqtR63GDD0dVyMt5YpVuEIdkHSrETGKy4BqwTeuQkIOyWlYTcI3fbsO9AMp13mojv1uLj5tDP0p8FnbYywBwjA/eLMXARVxCyjRiWkFTpV6Vw3ygP71K4ingfwm5qFKyEHRRSf6BmDwFANaqE+XldrvUj/W7r2+LqSVIo14mOAM11qD0N8yOQYzmRpFs8VFs0MlsEbxmXVOgJM3s9Z8pVanUq9/jRAXnHEhOWbgvYsO6J/AgxDjHZp+jRCo98veghFXH976seBHE82Cq2dIg+6E0iN9uA+kmYwsSgJoMJiqp8htK06sV3d5TZOPytciZT+otR5Ep4Iqn5mzgKSHh1cWIJgXTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:14=E2=80=AFPM SJ Park <sj@kernel.org> wrote:
>
> Hi Kunwu,
>
> On Tue, 15 Sep 2026 11:30:49 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > On Sun, 13 Sep 2026 10:17:00 -0700 SJ Park <sj@kernel.org> wrote:
> [...]
> > Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
>
> Thank you!
>
> >
> > I'll take another look at the remaining patches.
>
> A new version of this series is available at
> https://lore.kernel.org/all/20260914142327.92510-1-sj@kernel.org/
>
> It has no real difference to this version, but it would be better to revi=
ew on
> the latest version in my humble opinion.

Thanks, SJ. I'll review the latest version.

Thanks,
Kunwu

>
>
> Thanks,
> SJ
>
> [...]

