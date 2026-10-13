Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3C5CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 21:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B856B0092; Tue, 13 Oct 2026 17:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02C16B0095; Tue, 13 Oct 2026 17:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41256B0096; Tue, 13 Oct 2026 17:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67456B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 17:01:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 284218020B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:01:10 +0000 (UTC)
X-FDA: 85318823100.10.B724C5F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AB5C40006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:01:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ze+YyELs;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791925268;
	b=urDobsIJG1j3qTCTjrmeBZwfRPjTwvIkg/Zanta7Oat/N87GsAxyHtFwq2r/Q+QPFw2Hk7
	DZ4ZQE8YU3+z86OCGVbgiDacaPWFZl8RpMljZwmDWZCg6Aa5RgF6JIBhzNjqRqPaxfa0rW
	e3p/LTAuGUmmdQ2XyXmXHx/ztiMGUHg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ze+YyELs;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791925268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otzqAwHTarH+nPjYAj7PC0qYusRb59jP1GBa3Q2bM/8=;
	b=lJaBo1X5Sp3S1dWvGLfoAeF5k3ahoOBgx3McsAwdPd2hmAs+Rpr2J0vLYpBdbXJAImSfH3
	Kkf6kS0aPNXaPM6U0DnZngAhWg2zxATm/GDYG7wfzB3u65RUW0sGn2LR26fpGIcZ66wn/Q
	JoC3BXQPMyjzhG973tKFDXf0QgNQ7Lc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BE4A6022F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B58B1F0089E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791925267;
	bh=otzqAwHTarH+nPjYAj7PC0qYusRb59jP1GBa3Q2bM/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ze+YyELsWXzooRsH8Nwdw8sHpfqQhqX57KvCfNiePy+9l8l0oZs5QDWKMeOOMtJCZ
	 cp9PdgMMnYugE36LIjYfY+bK5/6Bat85gwbdTJRibl+Uf2I9JiUQl/xtsQ3EkHAtAv
	 w0chzgxOlJL+dtI5vxqJgRiychRWf+GrCt6N7MQs4rOflSwAJEYDAZrrbZpyt4mtvS
	 9JYZsHtCMHYZ1njOEW7iGJS6evqzPdlPDMv8j6pcIRQCipPYeF3ZDIyUGHukAYefim
	 HS5s3JwhamteA4n2ZcMBEwFVohicWzhIZ/A1AV4nHmaof/WvK5FcN/jbAs1f5tGVgL
	 MpkjoRUKLClrw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c247f6687dcso525801466b.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:01:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx2g9Z+/2A/1wwv8Lizx6y2gjzJ/Rzt5onyt/pM6c1kIx3tZI+m3JBNMAgUtueiAYYv6DH1RGtiNg==@kvack.org
X-Gm-Message-State: AFq9FYLFbxLjmkbF8InvPcDMBE/P0ZPb8V+9wfikyHiKQL1eEA5lZ+Fc
	wxVsAIN3qLMRck80WvU5eHHwYhuXTE+McDOHgRLDTP49VKPtoZhda/8pLuinObeEDSZnc8sWSU+
	xcEAlyGiNS0s54cHl4fct3gl/PuMKn0k=
X-Received: by 2002:a17:907:7b8d:b0:c2d:d9f4:2c85 with SMTP id
 a640c23a62f3a-c31aa0c129fmr1295928366b.41.1791925266214; Tue, 13 Oct 2026
 14:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20261013151007.2093943-1-usama.arif@linux.dev>
 <20261013151007.2093943-2-usama.arif@linux.dev> <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
In-Reply-To: <CAO9r8zM-utRFYGBfaEb=89LWM0DOKc8dywcDLSb6L7f4c80yuQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 13 Oct 2026 14:00:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO5HgtH0-jgCrj1uyv9fjUrHCxSZA21mWpDVU2B7qS7Ww@mail.gmail.com>
X-Gm-Features: AclHuK81jQ6rnaJmrP6r3K2lHMSwKc6BJEWDK7sFlCmG2sgXzWUx5CcLolataic
Message-ID: <CAO9r8zO5HgtH0-jgCrj1uyv9fjUrHCxSZA21mWpDVU2B7qS7Ww@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: zswap: use separate compression and
 decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yypwe393ep8h4jn1cohqtdr1zh1if4bo
X-Rspamd-Queue-Id: 2AB5C40006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791925268-607757
X-HE-Meta: U2FsdGVkX19+0iKp2J8cOavcfyE0aJtQ3TkbggF98U4JV3vBneWEfW2jMmh35K8jqZzNTHJTZmH3pAZIYHk9razqnmUALKrymFLDIh8OUPLbjxHbU6J1C1sihN82tSPbQhjnIBBExVzInb2aoAWJmWqWwhecOGqoC91y90xZ2IPHHsLTO6pAyg4OEV3QluGrOws4OYUvyi8/ytecRboZZ6c9d5Wog/3I2thi0jraerRHkHN6zlwvj141NBMDBwITZi1S+TtONdDiMK1ktrtIHMwCpz4RBcAe8wc+n08rOvgPBa2TJjD1ELTK5rvagHyh8+5XgnIAo0n4YkffAYYrRlJ9l0TW7zBSt3hIZyCNZjhLaipexkkqvu0fP4kRHCg44IY+FZSqCM1dTL4qSQGMIqQS/Nm1FQ8bD4vmF8T7u275+dNcMWtAP/T1SguC6+wH3EI5xBvqFnJh3TKV7V7xIhqIoNzhmbjtaU+jyyhWtKjWJAMr/yQiMs1QyFfYA3MOi1/4xY4nSyTcaaQVlQ4Eq9TyxygyqeTTaTgTceHS6uLTzSQiTxgnuV08q1vSbuWHSc100nIlM2mag6lGWgx/XbES1jIiCrKur42GD0IeDANthmfkfjHJSwG1mrnaol0aUu7dWWvdPy03lMzv3cTxNjUBqIkKtnDje4SCHupoaqh8nbNG6waVZD9jrv9YzveM1O60Dy9wm62FiYKdav526Y2VabxuLKSDCq5a9XxlPEM1bQJsjhjlz9FUCPsixHwoiaqNQXKtrGPwl1zh5pfsoEa4oLle0DIE8qBqzPW3F8jd2akFW0gjIOn8Oy4YQHa873En9CXZesjkv9XVVkA7bavgWOJNW7Qmlze8D3yBxSWLbVKjCWxwbdte9b+ToqOgCFCJOErw0+C6Iyl4o83f6sifrQcPV90Xnw6KgOlZ0FFzgl0Mw/w4r55biHR81ErAXhNLSp1FnBgFcaB2+aS
 PU+0euLy
 RKgAl0bC9oYhWI87Q2u3dIuasHgYiO1oQ4t9J358yW/315evBPNbySPjqy/42uApREFpfZ/i9YzvhDuF6ExIf2CqAiE1Wi7JoNIPJbE7tVDuqzFBML0boKXK6LDhmeqXbgjI9pMEB5dPH0oLT0y4B3suUQLcPNQqdeAgvnij1/n+oe5Q9IEFjZT9VnKFgQd4CcYBteosXTF2iMAIQ7rBfspeBMTRGcXVnJzI4Dnrk32JIl8gfWz/wHPNJe6xv+OU+cNLxyKooKVrCSM8qglrQkuMRPv6x3wU3A49LKXx0qKckCSyJGpfePGJEpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 1:57=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Oct 13, 2026 at 8:10=E2=80=AFAM Usama Arif <usama.arif@linux.dev>=
 wrote:
> >
> > Stores and loads serialize on the same per-CPU acomp request and mutex.
> > A low-priority store can be preempted as soon as the compressor drops
> > its stream lock, while it still holds the mutex. A higher-priority load
> > on that CPU then waits until the store runs again, which can take a
> > long time when other tasks are runnable.
> >
> > Give compression and decompression their own request, completion wait
> > and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> > decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> > compression, so group it with the compression request. Independent
> > requests can share the per-CPU transform; the codecs and drivers
> > synchronize their shared state internally. Loads can still wait for
> > each other on the decompression mutex, and stores still serialize on
> > the compression mutex.

Probably worth calling out the extra memory usage pCPU (at least on x86_64)=
.

