Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20FB2CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7008C8E00C3; Mon,  3 Nov 2025 13:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8408E00C2; Mon,  3 Nov 2025 13:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6162F8E00C3; Mon,  3 Nov 2025 13:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2418E00C2
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:49:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07243C02A4
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:49:37 +0000 (UTC)
X-FDA: 84070184394.17.525FAA7
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1585C10000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:49:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGM0hPYa;
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762195775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUXHg1xiNrQAJnQmh3zAMwsMypmYmGeR8zDCYyhj5sQ=;
	b=aht0Mcrc5J4jMIX71fCY9h4kCZdFcwTfuPat2vFjXYHf8nfRJYItpHzS10K8YieC3RPbV8
	Y35Q7l+d21u5q/mfECEGbonRQQpZfAoYe3Sz1s78jpr9pWRZ2BwBuE+ODEiRKw5eO62dmP
	+OuKNwEZEp4416T8gQREaItlwZPJDgI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762195775; a=rsa-sha256;
	cv=none;
	b=wQVu6ZRH4MYjNt3YvR6j+q4lMsHUzyw+CDqFqBOO3SJSk8mjMazXK9tgECepWBWT4Kk94q
	SvSPK+WXOovqtnKuqXfjtQD+hV93N+o2AjlveKcRBujwzskq/nSxm1Bib0G6q2g4AjeJPs
	YArMTiEC2Koww1f0AjEmWGO3xXwVz5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WGM0hPYa;
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-429bccca1e8so2122559f8f.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 10:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762195773; x=1762800573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUXHg1xiNrQAJnQmh3zAMwsMypmYmGeR8zDCYyhj5sQ=;
        b=WGM0hPYa2nCD4LDJU7tHN1/4Z/+s9PxV4gk4b9I0vQamQkHy5mWD+9xdC7nACeDbCL
         YUSPS7ruebKqR2rn5eI2idk4SR6P/81g+92tOjC3juRP7JqopgfJ4oRsPbEDqsAaGZ8v
         OtyEThWp1GdpJoFZTv8mJLDr0chXO0PP9nqe12j8En6hF/iJlEmRrWuPWmDeKOjeT088
         aOuH2JnvrUcvedE69wjxXBseDwDe/cXU2C5f7OCZtROjFEYURknmDuzu9nTZ/TAyuhnw
         QWp2p0v6p664HrjW0AzmPj6AvBx0Hl7awwojeFgzvaZL4zFIy3iVf6LoYxibBBVTP1x7
         o0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195773; x=1762800573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cUXHg1xiNrQAJnQmh3zAMwsMypmYmGeR8zDCYyhj5sQ=;
        b=wVoVyBI7oAMKDYS5ko+YLxpXj4JwEkdlmVVZr56JCDUQZmV+xRlr70ey+Uc6EndUp0
         scZNLIr2gJdoezUI+PvFeNvWtziiaBsrLGTYdCQuICYYvbRCW+yArFs8rS19lu98pXQc
         VOD2NInkcDDFrUuTmw/oN4Qkx0+uXHSRYTgVzLgFiXp6gLGPb/xZe8JrN9L1nO9SkV76
         eAzsolfxSm6RjXFvAO4P5wQbapyQI0/KXCp1A5yKGACOuqJpq7QR9lyba/qYlfO4K0gS
         ykXLdnJjcEgFy0YisRO3XzoCz3Wc7CvCJoiFfWdcWBc9yY1NFwjaME9daF7AVsQxC+at
         uAIA==
X-Forwarded-Encrypted: i=1; AJvYcCUY8aODrT+PGsG5APe+ExAM0l0feZocMXIMSbZkazqXPST13N6EiOzj1CQxNTaLRRFYtodSIvF83g==@kvack.org
X-Gm-Message-State: AOJu0YzEMcerVtxZkSEPECfFqJpWC7EC5sfqn+H1xVJhWMNPLsM4bEOF
	ReYt5c0WunWTkYOfYlouz2APoEF5SLSsBwYHbOZCPGLFSZVQUGUcD/lKzU4kSFt2UGafHZe8HKz
	r+zvecYt+WiuOeZwaJIm4sfEXRVq9ovo=
X-Gm-Gg: ASbGncs0JKRQStx0sdMHtknil2krjd7/H3q91X2p3YXhurq52MyHjQpmz9LOpbXf3lP
	pJNDrtLlB5p+NlH+Ge0u/OSp7NeflU8HZHZM3qYnoVOUkJTh7Vn4ycHZvCZFE0B+4qvqk10URPG
	peLY5QTLQktcjyhBAIQBWF+V8Ju9DtQgVtSpSIAHHE+ALZ0LHS0qYt2U9uE8Lrpi4FHBbAgzILr
	T9fTrEGeyMaH0KXTkTimPrYS1kzOXyyrvUoKByQnCSltawlQmpXybZgIJOi/OtnUaa1PUq8zglj
X-Google-Smtp-Source: AGHT+IFt4gOGrDj2t6tA8XILvHGEiv4nujQD4kFEHH+eHW0pODe/pp5N8EnfpMaVw2g1H2iXy/kIoISejExSMdbzjy4=
X-Received: by 2002:a05:6000:2903:b0:425:7329:e1d2 with SMTP id
 ffacd0b85a97d-429bd67c41emr11138869f8f.16.1762195773367; Mon, 03 Nov 2025
 10:49:33 -0800 (PST)
MIME-Version: 1.0
References: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
In-Reply-To: <20251103-fix-nolock-loop-v1-1-6e2b3e82b9da@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 3 Nov 2025 10:49:20 -0800
X-Gm-Features: AWmQ_blWzRfr9N_Nvg7Vzkxyh1lg6x7F8lqvMADmV-lK2vXgOf6Km-urto1BDyI
Message-ID: <CAADnVQ+pMfza=PF6eo05gSrtGkE1LbT6Fsg6DnmqZcta-3KUiQ@mail.gmail.com>
Subject: Re: [PATCH] slab: prevent infinite loop in kmalloc_nolock() with debugging
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1585C10000C
X-Stat-Signature: nbidprs8th8ezrpu5qoxbdywguuhab4q
X-HE-Tag: 1762195774-59212
X-HE-Meta: U2FsdGVkX1+MzdAMFSqGwp4hjf5DLm0F3vNOouwv/y/a+8tSTQVhqkYcCYK6HzgDzL6hHOOX6DNN59HxRWgMO6yTOdxRRSGogaTX+EIFgRYmONfy/jf6YVy3lw8I9o4bR2QXhz3vW4S1uXDTx7rJLmzlH67AhpE/3Shd95m2pIdRT2pj+rUCyXT2fJA0Rduj7lYNkSoufYIRLm8qTbiytzk7wnZAzomgXpgiBZl5x2x4VWVoAmTWGr6PEpGNRbpN7vUPE6ZNeI9hRzRDgpZnnd6sIxXiQETJ0PEx6zAxPkFd3St0h/YO2/WRnzYW6cYpzdCo4XXSWLGG7sVx+cBiQTrEGpRfwuiYkmZWac3y+xhWiQNGCr+cpIBpC999/ZZOuMXEdfZjRC6W0jJO+QvdX7+BRxHUGfs4kuKuUIehunzNKGN1oKfcYV0DT4Pde8abfWzTYfL9D+s/vgrn/B9Njsxt7zqaFXalpdNStHaLPpQGOZeA1qyV/Xjm/hUiyTuywPQf/WpGZpHU8L0AelaXROl5yiBiqDnLL45TTzoyaapv5WxfA+kzJ5ANDUMCxMjJ851l9mb5rzguPQ3+z+r2NbqI+EGbuBE2s6xz+ZhAHtpsdCsCHOGbAPFwypMTh+eGlb4Q17eeUv9UQtBilrDo6mlZUxs8MA6bX3GJz/njG+BTh9TQUTS+PYJ7UFf1Q00aVALxd6loX427W7AzWMOKvOzFFhgl6vmfN4RACvXoYOX6tKXKjtPtD2C4vFKLMQ7v/O4NgeAzmRzc/rBDfgRgV/825DYCo24WOhhVu1EWiUo3bzN/zbHLMa5PWndBSNMa/q7gPISyEQicrsfY5adWximVaaA3fCNseCL7vq9TnA+n6QMDGv3KLPa9jkmgyZN9dQP8i+hZVNKyDktM8lRctRJRsJAAcG4m2wYAHzFdaMOhL+Jw3dIjQQex/Sn2Evkg22dbIqREDz3yE+7mZF3
 6LWWcIhu
 QJINV05/5lXa2vO0DSU2saNdDrQ0bANx/ZdLhP2CvUTZiZuAKnUMzZUjlJZsFzwJtgsLgKC25ThXRg544jHuiog5m0Mb4PvuE3E9YE3Ukn74QW1c8Lw6AQF1FKo1ApukRuf9FmdfdKf6qnzRpKnOdaQDfcfo+MMQSKqa4h394Lg16n6uVjkuYZ6D+n5HnOZK/792dmj02HQlbjV93yCMHQxc2RlbAuQoTwsC5Bwj8V+lZhagMv3G6xKG9QzCqYQajEULtMpubLI0yladpwPKvDn212sqHPguw5ZGjclaSfwjAKKAv3CPcAfTuLlda5+/GFOL9NO9nFf9VPtMsf9XiLT4V3TYBYCqmCFH1yMRf8mO9wqTDuqJuN5eo2WKM7/YXv5d2gPxWdadHbMBB2Yv04zEEF9x5a0W8f4AjNJ17uMjixZHh8fY+PpvyjJuOP0QDrWmGiJiKjCOsjBYvlc1FdQRmthExiKGzsaBh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 4:24=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> In review of a followup work, Harry noticed a potential infinite loop.
> Upon closed inspection, it already exists for kmalloc_nolock() on a
> cache with debugging enabled, since commit af92793e52c3 ("slab:
> Introduce kmalloc_nolock() and kfree_nolock().")
>
> When alloc_single_from_new_slab() fails to trylock node list_lock, we
> keep retrying to get partial slab or allocate a new slab. If we indeed
> interrupted somebody holding the list_lock, the trylock fill fail
> deterministically and we end up allocating and defer-freeing slabs
> indefinitely with no progress.
>
> To fix it, fail the allocation if spinning is not allowed. This is
> acceptable in the restricted context of kmalloc_nolock(), especially
> with debugging enabled.
>
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Closes: https://lore.kernel.org/all/aQLqZjjq1SPD3Fml@hyeyoo/
> Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock()=
.")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> as we discussed in the linked thread, 6.18 hotfix to be included in
> slab/for-next-fixes

Acked-by: Alexei Starovoitov <ast@kernel.org>

