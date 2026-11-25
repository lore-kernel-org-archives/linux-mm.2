Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA91606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LcXD63oI
Received: by kanga.kvack.org (Postfix)
	id 9070A6B0A2D; Wed, 25 Nov 2026 09:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86AB96B0A2F; Wed, 25 Nov 2026 09:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70D4F6B0A30; Wed, 25 Nov 2026 09:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 482146B0A2D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:25:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA564140ECB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:25:55 +0000 (UTC)
X-FDA: 85473865470.27.6C4A100
Received: from mail-oi2-f7.google.com (mail-oi2-f7.google.com [74.125.231.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id CD40AA0007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:25:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LcXD63oI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795616753;
	b=PonZbcnzDsL8kJ9mi+wQsT5paUslnc/dOYJ6ZsqyT+/rZ3lTJMiFnudFEmzkmUCDVu0xcA
	YOLgEl7xrqEuil+8mXxMQ8pU8TP3uIDbb4YKUajv+UFnaSGykOY5917qsTf81F2bHGy3re
	aWTsgkXynjgA035l1ZG69pQ8lpXGJJg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795616753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UuvSUG/AlGrELdXALdkN0Fzdz08CRX6xTiTsgmsS7Q0=;
	b=MFF+NyPnph9OuWgfRFWnOEWjmQkWkqQhscTF9xN/0lY4F/CRFyPBDHEhHC4PIvbni6QUU+
	Z8YrtXs7yvhyjTI4VlYBVY/15Z2Hp+xymNNz7SC0V7hkaActu4hoTQjRxloTjGTYAbSJN3
	jDm3/v4ag0jsZQC+Pq39mbVxfwMSNL0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LcXD63oI;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.199 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi2-f7.google.com with SMTP id 5614622812f47-4b39374fab5so2031990b6e.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:25:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795616753; cv=none;
        d=google.com; s=arc-20260327;
        b=evoEqsM3nlphft4zd6A/Lcf4VmkcPcvgM0TPqbIcl/RQsUK4pZPF9qpscSMYVNTBqH
         o5oXPbAKlsTDSZZv+bKaSqnC3PAqkQGptrBzmSRVzQY7lVb9t6wTcLor9rOMxligjAyh
         oK+ZFXy1NR9WGqNjTUGY9hiijU4q0lpCp4EaRFE47QJ0nma0i/6X974Uw4w26x9bWneS
         uiFeAbEokVyLXknDEt4qy3/U3lidOjUB8uumbFMVdeKPp+/XgVlz+Qw7fAnaSYz/mkTk
         VY1W9ke/mLl9PT3BWpy7/ennC0u8hX/qiaietODJnrz07OirM0lEnnRLSknwF59gJoJX
         4nDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UuvSUG/AlGrELdXALdkN0Fzdz08CRX6xTiTsgmsS7Q0=;
        fh=Wcd8JOgLdMHo0FZFqUwg4nY0BTKgOk2esK2hWBKsGKo=;
        b=n5B8pQ1Xr+5m24tUrNpYTsIUYrc0KpJXfYarhi9IrCy6IvzSgc+jWfLIEx2a01VTsN
         fsdjzCRD8ZGr4tjVTdJDQKzmEZdrLGPZTuHb4hSa3XfzUFfpymHQyHiCcPignCie0nbz
         UjBzeVyWljqSmd+MWq65Kq/HZTYFuB0uuTt6wASGSfwzDPEJaShToe/DO8QsTvx1uoxi
         E1/M+eRvRZBIlEazIWYpyH4Z/hLSzU32KDSgjxE4gq+P11bvcdZLfDhXcAPW1Hf/7jjd
         RG5d5ntbH+wldg75+yb+B5FNgtv3RcnwbpL5b2/1dyHXnZ/fDu1wfRvj0jyeQbNvsVl2
         55Pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795616753; x=1796221553; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UuvSUG/AlGrELdXALdkN0Fzdz08CRX6xTiTsgmsS7Q0=;
        b=LcXD63oIVWa2pydrWoV9UvkRoS/vXoMZwD/0MRW1/L44OpCbPSn0k8pGTU9u1EM5la
         yDuZjnMQhV6bfJobmUv5xMIgv90tCcFuxhbyHFUAQFfadzqhMX741rriEyQfGu/M/+e9
         2oyNumJmYSmkvWTlEhnyCwFGwr5dnn5ZZ3r7FL0s9AmgI6Fs79S12hJ5QiXnfvMA1lZc
         VPHcljXugnty9/sFGmtNE7xVUgtKCYiRv6w7j8Ps/xof7PvgAN48FNg+m9UcRnIe0Llr
         yv8a8qLevi6RLOTx+LpXGH8R8/i4la9XN7oTwB/KSO1kcOqFbgISPHNF2rvs/Gsjq8jI
         0VrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795616753; x=1796221553;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UuvSUG/AlGrELdXALdkN0Fzdz08CRX6xTiTsgmsS7Q0=;
        b=pQIiIWzZk4GzI+SnXQT0pi7DRnOlRrsQivtNbrydTmEMLa3ELRH2+kHuiDjNGYFQuh
         m36PlJDmrJglTxMbGWY+ieFghOJzpX5b+iID+JbII1A/mIuFEoUNMxzfxoTx5WIP6fNl
         6ASZ8VORpUaF4/R6JtTKL11uZr4q739yN9uy2qOQT801j335VL1BnixtDyBfIopd0udi
         rp99SgoUSz7XNke7Ui0ATXrvxHYZGX4ABDpmBeLumIBe1aS8+WsFFpAD/TTFiklWs7XL
         c5JH/Qd0HI+uJCNc7oXOWhIl9YAOCe9k5Kd7BHcY7pO45N8Ybw0nRysFpzIxGL2+f5gq
         Kw3g==
X-Forwarded-Encrypted: i=1; AL+hErGHcxNnhpyXjk38SAdAmemLzbxjJvkWzZS4TvRl+zl/yYdEifD6q3T6ayghTuyza3NRihmsiYrvow==@kvack.org
X-Gm-Message-State: APuU4Z9Or2DxvzUKSuvsLSa/sKG6OI+r5VBkxdVxmwWb+VUtIKj/N7mk
	cXlF3L1fB4iQ7+g2qVf8Nr8Nmd9pqt28qcwVeWEqsJuAJcxriyw5nLqI21vG2Dp+AWXjuhFOAZ+
	gAu8P7LNlGMTGMxEy3x5csHmWLtmy/I8=
X-Gm-Gg: AZFdTZdGDsvOX3CEbfSgiAW0/Bz84i88yLoHmoNzwCLQEGbRjZvurbqq70mMu+SbpW6
	i2sAPOwsRhHdQyXNuJ6QyzGnK6Y/jf74BdtFYMM5MazZC/DfuZaFYe6nae6vSM62ZMQzqYVtmUT
	N5FhoRW2EUfUpqiRu0g0T+htJ5KRM/MLV8S26lX3CNJiP2uCauFTQdWEpyLZN0B9CmED9dQsNOB
	ApfZh609N6R/dCdJFLF/eIz/MTaH6Qy3V+ENoxR5IoSrE3tNQJndpcU6XF5EaPO9sg2ZSQkPQQ1
	994AByZ3ZoNN6wJBbSBe5StI3TaOvkXklx+K5isPqVO8FwoqK0o/640VE99l6ktLfrvO+h/EaCO
	9jupFiNnDDW1PH5g5aoGn1pvFLUmiKiPGRLhIYeZY8ubAl6tMmqfazqTxLt31UMVFN5XTZ1pKOL
	mEpPg3kfN8Yo5FqonZKt8tO156amA=
X-Received: by 2002:a05:6808:1314:b0:572:75e6:1cf3 with SMTP id
 5614622812f47-57a0b3464fcmr18893238b6e.35.1795616752595; Wed, 25 Nov 2026
 06:25:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <bae41f6fc4114357a8a74c8b958f2bdc.1@linux-foundation.org> <awbtZjtII9h1oJ5R@raptor>
In-Reply-To: <awbtZjtII9h1oJ5R@raptor>
From: Aveline Noir <jm5905938@gmail.com>
Date: Thu, 26 Nov 2026 01:25:41 +1100
X-Gm-Features: Aa3M54pcmOBqypz_nIQFR-Ig54b2tAgMU3tEPOdP-w4b7Z4sSqpiMGUndOnwO8k
Message-ID: <CANOyQmGPHrHAzVW70Q8T3AYtzFi3C7jCQdd-QW0rQCPEf=ycyw@mail.gmail.com>
Subject: Re: [PATCH] lib/test_hmm: invalidate all mirrors on device-private migration
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
	linux-mm@kvack.org, Ralph Campbell <rcampbell@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qyafjuuehuiut5r4wzbwjo9z91gt7wh7
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD40AA0007
X-HE-Tag: 1795616753-872259
X-HE-Meta: U2FsdGVkX1+r2YZTyINtH7Xv6n6JOrwiK9ftx32dAgMMstuGh3mtT9oIIlQdvgDxEJkzdoLdc4rzLNQEl1WZ6ZhQbzXkNCTU3rFu6b9POJ3yhtxNiCk56+9rsvyTK9OURg7JpLI/b0v9Luo9uSclRgTp9HI/XWVkGUwXAxVL53HJ3pVH4BUtCM9/HkYP0kh4TrmN4U3GYzI82qqc09lYIGxqM3BatECjGFOjIDpzvF6liKCDBPfo5n1d7hPddgMvlEtzFbmJcxmqOm9fVi1ryjFOB/ePfv0c/An0sJ/lKEtSBG7zekdBWE5/xbVwKUJcxW3yvOrQJaByTX9+35+hXt/C6rMNpFMfJW/E9VOOAKJxZP/iciK4+ncqdX1vezNZcZ1xelgy1bgE9bKSGadG5maj/1Hp0rdDu16Or4zEIyfZhLXtSwO4hODQUVGnEB/8AWwdAcbn3uLfF6n2MarT7e4jHH3DKRB5UgppxImn1Kyyg/bjYegbIc/xcbyK93nVGwSZfJ2+fGBffTKsC3jzyt9es5UV+JYcFpJE9qwk9Cy4HhXQvVEN7kwfMKgMYNYR+hoHExSd2u+EJ7d66lGcpCssAVG7IAqkFne3cvs1WC6J6nOmfz2E+ZarAZejoYCM4cwqGXYM78Fa/u59tBbh9vDEUnM3bLgDcCeif3ca+My0Q92NgTTFr5MPuOaVnweggp/hG1U1gVBiFVSodNPQAuz1R5x+7vzNsZ64IAh4cT7i7BzjliFUMhzwRzrEWZtSsX/WhzcBhjFzekQYumvnlRcmsu/wcd6v6nLz7UT/JMoCTGQ8SspttBJtnOPy/IJu8b70dG7e0nczBKyTnE7FwKCrO3AG9zHbYbFxsLBULqVxMlaAWQc5BC+o8wFPwrTFKN1p5FLLIVtlex1hQ2PCf5l1H37LRo58aq/BhQzNaOaKxyilp+4j/w7Poi3PTRGxbf3TIq5B5dM00A61vXW
 SfVt0+6k
 y+zVOROPdhf+5XR7AxBeLWT19ZZaE0LRTcEp2rpqs4vvgc6T87deNIgy2Z1MTucCUOgYQLayXH4ZFRmqgBVZkOabfYDBLPbeshaFoDQmFkxOoBLHMOCIqI5zK+ed0uTnlXPuTqyUFNxDQsK/9sFCanQ0dWhkSQ5fziIfgTzVH+aunjqZZX4SuwlOx1LIJ1KYjtKMTZxyiEGN+eBPqGuQuyU7KlGwn39VQ+X2JaAa1TMXNcOoXplNwAAHDw02+E6fs2wQkje/KqH4Mux6/i38bCzJhRn62ulGpmZVw65qytg8I2TuJMv1F8x6ZpqHey2RERn5dOhaCFZQduns/cJYypRKOJbZQlfhQWbQ5wqgOmJ0l42R/PWCKOj1R4xAvqeOGLCdPlbx7GonC+A8i9FK3OfmjCjdEAxIiYpoKH/R7Hi+kEpTpa0rl1x4inBkuz8fFEWjhK2MzR+C6RM9sac/pH35rXUT8W/TUp2EzG7zwTbKj97QC2kY8dJ0EmhiD1xwp+F3zkG9KUMg/Y1Kw+0T0Qrzfx/jnsnlPD+ztY7SN3XB5gaXCGVzLfeg/7DK1NSl5pbeRc8I0Z1QXs2/UbVPpcnSZRspWbBGnrRLO19OsDhaBIrOtM7VKYUq6n68KKh6DAsTFhKh/WR+qaTtqGTj22upHOBCoFC52OBc8ebJgcWOhE3bncfj9X8NdVm+8KeAzNmIlCGbMmL0ue0kiWZqP9hHNw7nEbjKccLcfegFrcZ1GdGPZt96e+10YMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex

On Thu, Nov 26, 2026 at 1:15=E2=80=AFAM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:

> Might be something on my side? I'll investigate further, but I'm not very
> familiar with the code.

I reproduced the same 0 versus 523264 assertion on x86-64 when the separate
mm/hmm: account for subpage offsets in device-private PMDs fix was absent.
With that fix, the test passed. May you check whether it is in your test tr=
ee?

Thanks,
Aveline Noir

