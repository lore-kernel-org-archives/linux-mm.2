Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF06CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 22:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20ADD8E0119; Fri, 24 Oct 2025 18:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2158E0112; Fri, 24 Oct 2025 18:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11F7B8E0119; Fri, 24 Oct 2025 18:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0106D8E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 18:34:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A93B4C0F11
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:34:52 +0000 (UTC)
X-FDA: 84034464024.24.86A26A5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2347A000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 22:34:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HgjgtQJu;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761345290; a=rsa-sha256;
	cv=none;
	b=sMkVtqEwIfW8AlzUQtCLJuUOyKcfHX0N19EteLMHOP6s9gk23X91bgYxvgqVTPVLNVYmvC
	6WJ55gh/+RxIPM0TQg7J8IBJKEu9rVz4r0OLuhqRoKh+tqohfOWjQt3XijVZ/fYf57fHHB
	+15IcoNNfAl5roczOeQXlekW/X/yUao=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HgjgtQJu;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761345290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgWMmy8jJ+GexnEc4sqtdfOGQCxpNGU9Ux5BrjtS6oA=;
	b=leWXM0xSRuYPzh/LXS7er5KCb0ECg/gG0dpv6cmcK/a5osOWbio2NooQLgap7DlAGwcGFE
	dPORdu5cdEjMXTkdBCcbOyfWgKevSnZuItfXhfQYE32OjHboqBa8NLavFszD88PVLPe1xZ
	eeDHkd6+IRJTI6XtOQgGfhVWQo+m5bc=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4270a3464bcso1880016f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761345289; x=1761950089; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgWMmy8jJ+GexnEc4sqtdfOGQCxpNGU9Ux5BrjtS6oA=;
        b=HgjgtQJuz8BBqGNY80RIXBI+Zo7fr79zZYMnoM4ox2/A+Hrk7710099vau4uxkkLeD
         KGZWCTFh0D9WWCceUVioDzJDnBj8j/N3C8YxCmVTiTbHXE53zOwr/t7R26Hfr/OeOmA6
         NUz8rNUfMUaDYkReGVXXna/LhUsgjJ29mLIf1VFXWlHu6bWqQ9K8mStKG/pW9K3sfleG
         0hUTla1T7UsVsTWFsl1n93O8pja8TJuvtW76Nn/GLDhpzq/B2t2ySvDSP1WffaRaO9Sj
         6bAuAJ/4zPIF8v7rfBXPsLxNg7POVfr5/djpeNRzWamLCRO8uZASpytqY25CfUc1ctog
         2kRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761345289; x=1761950089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgWMmy8jJ+GexnEc4sqtdfOGQCxpNGU9Ux5BrjtS6oA=;
        b=Ff76rHGoZHykH28NZMEX8Ase5wLndmsyO0ApgI5o8/qHr/7AEMQX4Et7WNyfCqOQeI
         2z79paSOOQv7zIJzFDxq+OKyyM4QcyKt6Id3ifCNwGJFHgy5vVLINGBFhdrRQl5lnrDq
         cuVHWUCNw6aUzK8y6CUMVLj5Qy3Fha1kZ2qeWuI3a7Sl7UVAL+Ytq+Yp0jHLeuglq8Yc
         8qMjgIimFwKJLaOq7yuW9sken20BNytT0DJzhmHgiSr2KXQFMksA0d1LHtyJjGL5Yoq6
         ryp9cuy1PqvSecvFjzHrTmgvUltytEECsY6BDo6vnIq4bNa3t7uO282q8ULFscsQXWy7
         dT6g==
X-Forwarded-Encrypted: i=1; AJvYcCVfYNbrIxfwaA9xeIzIlJZjpyRnod7hys3uEXKPCpEn6C8IQXbInLXH9qM/04PDg/bCWF/QZcIeNQ==@kvack.org
X-Gm-Message-State: AOJu0YzBmMvcyCQR96AGMJ4vlrEGqfuhoslLdK8zR63h9n7itcH6MIBd
	a6qm9pKsh0L8LA9LfPfag5ibfKFIefJAyZECCpsRRhMsOQNJXfYlBuxERLc5uK9j7uDdBAL73z3
	bWOJKm11UxzIpwRL5JWYRKYsYaBh9/9s=
X-Gm-Gg: ASbGncvonGwd2dLZHPxb5klLB0ZDBAYs5uXAFVzHGgounhi1fnwVCq4KxaEwNf0chTd
	tBbI8iSYlc41/4cNRARUxm6aAmrIe83UIaLQUEQS3Y24vNpRwV37aGOWOXiIjD1xPqx6ImvIhoK
	k0aBINwjL0AQgSmWCdDBVV46quBFp3FXNigXp1Mx/m/nBtwUMLtvsm2G2Th3evmZX/jSLUEeipe
	/JvlKW/3YRrJomim7H8VedmeJooFr9G+Y2R+tkKHV621AhnbvuBCeHPCZV77BVO4+3sM3fWJYxH
	QVloy9EFakBYSpyWhv+A2RRinQz9
X-Google-Smtp-Source: AGHT+IGVBqTo1Qga775DM3PeXJFOBVyycwfIPdw/nCiZHEmybAiqSl5amP9rqdkQHIC0hvV9j/gd2HZiroKhtTMd1Iw=
X-Received: by 2002:a05:6000:40c7:b0:427:847:9d59 with SMTP id
 ffacd0b85a97d-42708479e00mr22413715f8f.45.1761345289151; Fri, 24 Oct 2025
 15:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz> <20251023-sheaves-for-all-v1-3-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-3-6ffa2c9941c0@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 15:34:37 -0700
X-Gm-Features: AWmQ_bm73zAZG0hwU9rfMl02lZ4uq3I2SSq2VpZGEnfSrxZZCZEFxDP-C90Ympo
Message-ID: <CAADnVQKYkMVmjMrRhsg29fgYKQU8=bDJW3ghTHLbmFHJPmdNxA@mail.gmail.com>
Subject: Re: [PATCH RFC 03/19] slub: remove CONFIG_SLUB_TINY specific code paths
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: iyinfpwz151rj84bjypja5dycx1thhcj
X-Rspamd-Queue-Id: C2347A000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761345290-320417
X-HE-Meta: U2FsdGVkX1/r6FmliZRxG6CW3Q06Ku5bvL1KV1wDdCB0UBGNqFYzaERahuOmPesaxXw0p1B88XOYJ5n6rzfBsMPhnKtcYdnHGV4a+vHKu/36rTa4Y4cnuMC/waElRIQr7qotukBXz46MdSu3jyNnCBwPk/15H9SKyrKF5ZfMlE/BOjWSs4tQgFa/E0GxWWUw5nft/jmyg5QpZ8DYTedAOzd/jcTamxnHZcUykcNs0eqABjhVuwJ5TrQY5LkBi6q5Pwce86wDSnQUHljuL/tD3P217BFHZWcv0H55sUg7p2SYGBKlwz9Uruw2Ferk2lvqVWaCDNiZccabyOccMOoayQHSuJHRHCY2Jtj/xGtSYIbYADvAge8O2S0SCV0d4dDm9uFCRtrRukLrAFZ0CA2UcHtlHh3nl4xAPuYCu71OWnfzYE84l6/LLAG6ITSMhsLVSfNgL9p3isq1qFVVTFBmabBdkU9d8HYXI36Vr3RQw1VWBmAOLZidR9olJOUeQzaCsdqYTcKnRQhRWOVxGrdAqnocXmVNejoXxqsyPvJ8nrBBof9QJjNcESLtohaPbuK6MTXV1nPQWXasLDmQA6jWKZt+hQxEM1UUlrnpkm4Rl4/OCilxi7gorvGnn+zH8hmB6JEZzMSor9+MEgp+QDWWuHxtbzdHF1SL7uqBJa8DA/Gij2enfKW6+yEgfCxH7GWQ74EtOpwtLx5LkQUqfJ4jr9O3ki7q1+H+tjt9O3K7v+Wvlp2SPV5p5UXM8Q69ZIAYHcGhBFXrdf4azlUsDtQsCKsrQF3kO7BDAStPKl74g27837n0bLPM409m+MdL0+olNDY6YmIusi6eW/GEb/QXu6PfJrzjLglLCuenZe1tCG63Yx1luqHDOPZCC2e7hIm+8o15byNce0UhqzsJ2nkyIdJJ37yu42yppLDgfvOBpYdjB3AvILQ5SodlQ09kL5JVdvejuBH7FIwJohPcDi0
 MjhA66he
 FCi62cF9p7Xi0wYAmj3spQnpo+G4EtE7TNLwgkaRGLZSizwEhr1j1BQVP8ChflHbwkQpgtZzvrit/Qxx0+PmpJQmAYpbv/7weLr35AKfntOgT0IMh0vh+FxwlJ8Brk9qG3kA9UjsHI6bzzVWdGKYTIdvpHe8L0eurjHO5RoA4hJl9XptDMIz6gA+SF7Gb1etQaB1D0t/YiPBVVRXJbxOF+Jjdnp0OQkogMAShg6snAVyqlEuoEJuT8pGkdfhZFKs7hY2yhOjCLPXAb/tr9AcvWW1J7dWYUfbIqoTNForVJjkXV5hjceqsAtl0/vXjD5BCn8v+SWA0xGQdBckVs0OFuOiK7ZzQ6PC1lyJogPOMcHhuAig3AXUrPUUzCUzNKh5+B9Pfb7JdFxY/V4aiayD6Hh8bQte+LpEUefRjrsYobEY9v3BOWROT6JcwNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:53=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> CONFIG_SLUB_TINY minimizes the SLUB's memory overhead in multiple ways,
> mainly by avoiding percpu caching of slabs and objects. It also reduces
> code size by replacing some code paths with simplified ones through
> ifdefs, but the benefits of that are smaller and would complicate the
> upcoming changes.
>
> Thus remove these code paths and associated ifdefs and simplify the code
> base.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h |   2 --
>  mm/slub.c | 107 +++-----------------------------------------------------=
------
>  2 files changed, 4 insertions(+), 105 deletions(-)

Looks like it is removing most of it.
Just remove the whole thing. Do people care about keeping SLUB_TINY?

