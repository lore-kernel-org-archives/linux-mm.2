Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA523108B8FF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:31:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044E26B0093; Sat, 21 Mar 2026 01:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37C76B0095; Sat, 21 Mar 2026 01:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D526B0096; Sat, 21 Mar 2026 01:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46536B0093
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:31:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C8691A04C8
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:31:49 +0000 (UTC)
X-FDA: 84568948338.06.3B6141C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id C71F7180003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:31:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HdEqI0kj;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774071107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=TSrGnm4uwHURRo/Dbgx7AVRGahiZ5mij0ljFmYODkAo=;
	b=iDL7e63JLSGvvygi4gDnBEoWCU449z6nsSerdlxI1Pv1uyTWTFz+nn/lm4etG+yGZL3Wd/
	sl7HdE8KPwuR9LiggNNJIVPwBtbf0Cjz3kWPdMHouTK+PyVQ7hrVgCZacePJfaRrcqV2HI
	Zza6h3UA06+hcR2fUmSOdPCp9PCQLb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774071107; a=rsa-sha256;
	cv=none;
	b=EMQ1RqpiMGy6ISQUC0Eim7teuvmX6DnyUQPuzmQMSjOECG1GxTmte3rzc4P/jU11TMh54R
	Yu83TlKl6aKgvYg+dlvG9ZAfIafFfKhZwVfCfqfLjONSQAMh8JSebEVZBK1BdYpl9e7wHo
	P2ctKO3RTRe3yVK0Ix02Wh1ZgOMTG48=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HdEqI0kj;
	spf=pass (imf24.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35a04d6aeb0so934451a91.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774071107; x=1774675907; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TSrGnm4uwHURRo/Dbgx7AVRGahiZ5mij0ljFmYODkAo=;
        b=HdEqI0kjFxN1dzef8lzieb+yEdTBMEOzsOPftRlf8L5jOzFWEQnt5JLqVyc9Wb9bhm
         jjotoHO38s3Mk4hW/ehKDcpBe6TYE+sgev0ULfXKdvejVCVFhiuJxVzGp9GZtSmjGRXc
         tpc52Py6Ye4p2YewmUmKP1zPV/+scP29esgxrIIuEu92Ba5/xC9EW+oHyk8oZieXMa5s
         UMqGFc6oqtNMUPNOYArA0yc2542HTaLw90VAP/nd9ofN6Sv3xIy+klPzmF7Br7WEOa7J
         WeN8/QN11kTHpxVFVtUJ/fdnz3fmSKt4HIECUjLn8Lw9Lvo4bMLCtrGfMl3ulvaJhlRE
         6c7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774071107; x=1774675907;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSrGnm4uwHURRo/Dbgx7AVRGahiZ5mij0ljFmYODkAo=;
        b=SR2JA5XFGyKJqVW+xUgedEbAy3gF3823FWmZ2YJu0T7fxxWtbj7VeNtOwNydIjWRCd
         IRjMMqD+EuDbyGWDn06X+2Uc2XPHonwiHxqvAVEX9AvSKpnOoTUfXxq3fCvLzdik0A8d
         bPnOgpzTTatkNgaHFn3opwk9WjzFXWd+gZObABvYNNcfVrQg9V2+Z7g3AdpejTf0ZeNN
         Vyb7i0XwCjMwA7tkh4XCQCGbRrkMznO2bYYwf2QhAfdFN59qE6LcQaP+KaEWw0xcdz5p
         +ZbVJHHHisl+nbX7q9uLUvngeus2lCPPTmU+LY55LYjBmRJblQ69Wvf2Sp5MHAZ0OqRa
         kN0g==
X-Forwarded-Encrypted: i=1; AJvYcCUsO/ir2NPPgWyCxsZ7/8eH0zT2z16S8RhoAghnTnNg8oVyPNW4Ibo+iyepYY/2hNO6FcxEi6TVYg==@kvack.org
X-Gm-Message-State: AOJu0YxJ11EPjIsxCYVfN8399jaV93k3RLfHQBQlQ8vz3ltf6E2KmFGz
	uTs61aWK1zEPOPAmRg8XFncbTyyOoSfqyQASYcV6i6xmcvIY15o/G1y1
X-Gm-Gg: ATEYQzxgoM1noST3pjhZ4gYKtku1+Gy4J/u+D/M6mzD7cbGnprUcJMHNmYjg3AIpCpl
	YIB4y7js/2f9juR5EjLZQSGoek5HlNKoL3j29yuAhya/e4ByvjkH8M1BfopjUJs/0H0aKztGTy7
	/zb+9Yh0XWdhcbYpqxUGBgmGoGp6TNV9uDnttdmVCRa/9JqYXir4MotD7SUoOy5KOoBno86a9n8
	aC6sAlm6LAeBc47MM5YYsg0o82gbAIHqJTUNiEWGaKO4lDh7ZdIbqW7cDyQGRR82evMeNWJU7vo
	3JxNpZuzmx6fa4u5t2qbN/7MCoTFsZoXwElqegzTM05pEWCJT4SZYiPALHlgxwetkYwVWG38Wpc
	sdgEJ9e1CXtx8WTyyaB7uktCoIf+wU4xv6UtU03OnzIC3Q9mAuDqdvthUtGBgKiduTnfDbi6heX
	eomH4fXJEKrNtNgmA9uAVLwg==
X-Received: by 2002:a17:903:191:b0:2ae:8272:deb0 with SMTP id d9443c01a7336-2b0826feb3dmr54931105ad.15.1774071106610;
        Fri, 20 Mar 2026 22:31:46 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083516aa6sm55638395ad.9.2026.03.20.22.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 22:31:45 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] mm: change to return bool for pudp_test_and_clear_young()
In-Reply-To: <2711ec4bf6c30182004e34027fb31a2e8e24749e.1773890510.git.baolin.wang@linux.alibaba.com>
Date: Sat, 21 Mar 2026 11:00:45 +0530
Message-ID: <cy0xycje.ritesh.list@gmail.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com> <2711ec4bf6c30182004e34027fb31a2e8e24749e.1773890510.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: e51y3rrtdu5h3zxboc7d3x9d147x3qbh
X-Rspam-User: 
X-Rspamd-Queue-Id: C71F7180003
X-Rspamd-Server: rspam12
X-HE-Tag: 1774071107-886573
X-HE-Meta: U2FsdGVkX1/TvSKIL79itSwbnUuU8y7tXqbDIQaCMM4Yl/1/m2wv3zsjzfpYQQr7jHg/tV/O+jm4bQ2cOdVAS7/s/yX7qeKjV9kiKtJe2D2xjrRhqVwxwjuPsoVdhIiNH2jLaw8vc2k+2yL9d6HNy0VQoE4bBa0arax7pQtAX9k1WT6JEi/GPMpNGZ9MgJbTiuiaPVQH+QxtM+1mK1MNviMQnyiMXLf29w5ehzt33dda8CG8jK9QxvQmMK9DjTQSkeFrK+FMgHH/186SfQe/fR3EGhp/ajR+HtflzfJxVLHcM6LgdsJQRvqXC1V1j5gQ+BUCEb1PDIeGCaVf1lRaI9i4Y7W7OiF5GRuuxlbAatZpuaBOtK6IXGYOMBNIG1EfYRyatZ/kpxDBOZDy854kbsQ4dVoxnYsXYngjwdgKnwsSSHX37+/VzWdWQKX0xruQ2d0qvHz30gCElIOXPVZwTwNgVr5dhkmaHrv1N2+qE8T3OOtMXDamP9qVIyw2rDRO5bEPYQS6iQsTGcMEDIWcMKK1vUzNcL1nwPa1l05+X1fYB++GcyUk1b7dxVK/uMCkG+OzvToQhnCnDpDz8PkTgOeNeMNsr/siNq+QSC7A/s1kaSOIh5HH8Q9QJkwuaTJgc/RNJ5oAGYuzU8MXCtwQ7oTSJet3QTwc0BO1hvb1K6DPCfhY3IdQckmqd0SSyL3U8D8jFIfAphSx6/jfY9L2AjuzcRZpBUi/80ewHh7QBtL5Fujw98znO0Gh6fqFzzzzLcJSWVHl3LWpOq6usAL2XIbmNXKGTJbGvrOtGYHxVuDhlMPlkTluELpNmVphKTPVu/dy22WP6XPnEK0pOaCCOF6ZMvKGYh6m522lLeehsCKqsdnRKEHSJp/G4vuPeDulbAfaALxPff0Ia5r8/9/ndgNrZ68FTgymJH6Hu+izikRVGa3busXjfcACjTyhKDFtc45kxbL7qfRdiI87gLe
 89PA8I12
 C/tXkHDLiiUzp+c7GGw0DBceNLH+h1/05tCOk69GxGdhyEzn6u5lU3XylTcyYGE+gQlEn3hfVhvX15PVe/OVBK01LZypoDV4amjt3W6fmRc4a9g616T+xXAxSf7kvd9yBgIhDUOU5o4fqKNzqutxxqF9tXKkVEsd4604jJe2E1Lfu2ZrGiZwy56cqFquI7QY3ZMgNuEOi6SfM0yaJ9BeIfS6qOjJzCuNZPyOZWgdX1vhiHIQa/XtGokNWAL9tbuAPMh6a1aIZTp6j37fnd0prqX1ZxmUQtJfagG8ZLTXJlvupPUtVBfDCCADLtVF8Q3sE/n4Fzn14x3KoPjQBhg63Cz7XexH36j3Sk8hiDVbAb3u0d7Q5rT/JuvWPxZOdZ19n2JrkCLGkSWP+cp9u9Zg7A5Xc4Xc4ctywQS2kZiK867y38EwBwD/5wl3UjgK9b/plRSqNtA5bRFM9CF9LYxfh+mWPx/XsO3LUB8S3C+sfUR/HF8aL1TmmGAtoZ6Sug7cF8JSN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> writes:

> The pudp_test_and_clear_young() is used to clear the young flag,
> returning whether the young flag was set for this PUD entry. Change
> the return type to bool to make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  6 +++---
>  5 files changed, 14 insertions(+), 14 deletions(-)
>

LGTM. Please feel free to add:
(assuming you will anyway kill the unwanted externs)

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>


