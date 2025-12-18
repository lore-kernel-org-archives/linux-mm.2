Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB2ED6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BB96B0088; Thu, 18 Dec 2025 07:30:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C916B0089; Thu, 18 Dec 2025 07:30:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C1B6B008A; Thu, 18 Dec 2025 07:30:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0451B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:30:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97F178ADE4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:30:56 +0000 (UTC)
X-FDA: 84232526112.18.EEA2DF8
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2FC5E1C000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:30:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=Ae3Q9rGH;
	spf=pass (imf21.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766061054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tP+xLtZgtlDLWdjd9tn46aUJf6F1I9NoEVzUNz8fHXU=;
	b=FnaKeQYNY3N89R71r5k6kqxyKCE/b6Ga7bJ1Fcilp2H+g0wxrhUj5ZZ5WQ/vu24guAFiMW
	o6gQeQvjOs2oK8HmrZUxp8L7/6y8A7XSbqIvxTe1u0km8VL1hIug7SHug13myxMb3XSS/m
	TzZ/8zVq+8P/HWYMxAfpaIqTHwAW/B0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766061054; a=rsa-sha256;
	cv=none;
	b=lV2NlAaP+wG9WNEceRZFHUVFIDgCuKM0xAc/zBomvsd5h0MDxluOfJQho0ZfXFwP1/DKcK
	BMtmztyZCPwwA3vkNJLcggBPdEzQh2ABYS1eQ6LZYzgC92COOkCs/ahimkXyTjSkViCm0O
	iCkBXGtJbKybEYRLOvEg67suxQNOKmA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=Ae3Q9rGH;
	spf=pass (imf21.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34ccb7ad166so543695a91.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1766061053; x=1766665853; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tP+xLtZgtlDLWdjd9tn46aUJf6F1I9NoEVzUNz8fHXU=;
        b=Ae3Q9rGHZdn/RRPPnCFURWi0c8iUP/mWQJDzDyDnmazYzvtH9grsCz94dCi1LobFjf
         MgGfDxgU+lrWPXOgUF3IIXPJmMZY9GpOc0nahnMkrQrkzJ+zi3X8Ev9MkNT8h1hEI/xt
         08k9X0IVxYg9x6YHu782B0enjb8i82tUKEsU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766061053; x=1766665853;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tP+xLtZgtlDLWdjd9tn46aUJf6F1I9NoEVzUNz8fHXU=;
        b=tkl3bkfXipi8S5w8M22eQrVcp/lGyvss/x3+vGX4+NToK7sarQep1ZOAxQnX7aqQwL
         ZFnB5k1ApycHjSXdltFDDeieY16fqFAjNiyuuX0Ryl9/Dvb5G4R+qJ4iWlVkrkaZfEWl
         3CoacF4JK+JQaxkE+6sz8RQD0jM0GojefvqmYtX9UZvVopiIIYIXaJk0kr8YBPLsDmPH
         zKCfdnurd1bWmPKi8yCybVSJYFDjce6Os8GQpxHa58LW4JjBS4piBW3cvCG4l8Tm5Ct3
         G7uNkwiB7o00yxeYB27mAxASbmPLfoabs/akNAyuOXNCdGw/vu1N3Yg6r4B2j5jL6gv0
         55xw==
X-Forwarded-Encrypted: i=1; AJvYcCWSK/4bePfuCT4k8mKFeES1JZmBLoKIdKR6zgzlngWxY88ZvGw3X6Beaaldd0vdhBwZvg99TxEBWw==@kvack.org
X-Gm-Message-State: AOJu0Yxcdi9Isk3gprt0wB0xMJUI8fnjYk87n8Jaou9Jc4n+SLyuzFBh
	cHlVsGwQNIlSoGJv+xNHaesBBXGhymgwVES3zLQjtDaCrvcOMkYcTFGwXiuAaei+IbJTNnoOgmJ
	lAh1sCLXqoE/kxca1zaFs7e8fap5F48Qs/M4lhCi8vA==
X-Gm-Gg: AY/fxX6meAM/L0Lu19yKQKda7MxS5aG7SnoWS/k6uZPZ45CyDuwTfayPXSNw7ATji4M
	1eouIukvIHrE9qM8kZbaQxgTsFugC92EYB4fH9SyTQbE729elJpZMLq7LgxklRFI0VmPBKf+uNE
	HOSpyFJZW69RoKMcRbtZueTxYhSBkAxrvNzh3OeLp4Q/FLDdswpetowC7sNneJEQNoQGypmJakZ
	v62PJ1F+WK/C8ETjZKB/Drkx1dSfmJggsru6Bxx4Qt0r1ieCSzmurIoNNGvwqnOCekJ+yWT
X-Google-Smtp-Source: AGHT+IGu2Eu7RtcW9c2zBiOmY97+906uwUoVXUQplsN09hPVWMPuxt4uS8nUcxY/74bdSgMmsl9UMc9K+dT7k58K6I4=
X-Received: by 2002:a17:90b:3a47:b0:340:d511:e167 with SMTP id
 98e67ed59e1d1-34abd5d38e2mr20348007a91.0.1766061052903; Thu, 18 Dec 2025
 04:30:52 -0800 (PST)
MIME-Version: 1.0
References: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
From: Daniel Palmer <daniel@0x0f.com>
Date: Thu, 18 Dec 2025 21:30:42 +0900
X-Gm-Features: AQt7F2rK_7wgkI2apPb4L0y_XrU2_RCv4C7E3ejczHCuGEQQAW2pFOcChHjoj5w
Message-ID: <CAFr9PXnK+WCOGYs_e5HiCiwxN1SdjGhmR3DOi8w0BYRqooQONA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for !CONFIG_MMU
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Guenter Roeck <linux@roeck-us.net>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: sg9gcsmwwgkgrnqx78cjefjk3p11uobi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FC5E1C000E
X-Rspam-User: 
X-HE-Tag: 1766061054-917724
X-HE-Meta: U2FsdGVkX1+pz+W1hiaGvGdqE1vkkMOSKW2e90Fdi+LkHn1kwj3sIFKIVqZB/CqKZeV0zCat3SS7zyDDrTc0Oio2LEhxNeHlTIKQQFsP7BOkFp8wH8nnr0hBG+6FlwNpZdlK3KbyTNr7agWoU3oLYHd++JRw9suiPsOqW8bTaD4ofpu5+Y4Swvi7tGIxzBxu5tM5liVs+Ic7PNwpNL13aBvr4zL6T47NluXk5/xETk9suc4cIBW6mbSM5hkRtOzhGrMqQjcmzDj5hvkYsF16S0Tq/PfOJyhtj7MVFReJ4tSGci3LZeVu/JeF6a2XOnpKHwogxM9lsDOK52neMdw5bZ8hVX5XIf/OXnNnk5XwHljin4T9JvYieqeP9DSP1EAMIx8FAUl4ZpvrzKh00VKJZXRpZ8FiUJVoLjvbHAB6LXNQW52o1FQPhslfQiMWgwf2XoG2kghjD7lLuTi6THDoW7+m3XflBazz8tl7LtmQp4bxP8DmA/bFwWq6VdBSgLNmReBnXQJeOEMi0q3mPZp1Ro4FCz+s82sJdsmNrupmNbo8ivT45Rh22M/aFjiZCYaSYEhdsiL+4vr/mBYTxigKOdJPA8kjGL+UaPh5dQCeM3k/UcdB2WQZmVOkkct5Dg/Tkk2d/5uzJYfrYH//B+JWZvYIy+Os59aO1sdKFCB9ltLuqasJOoO7RnFxtiG/k8RFr8OR8E/Z4xryz0te0ucC9rmbrUG9Z2IHX59h5o3kmcvSRLKNHU8KmwNrMuMueE8iiEJE2IJj0/qWvOm7/EJ5jxIvUnn9NJV34veTufk0C0hEkZFJ3hosrNJhG17/oIQNgTS093RGOxfGC7ZuvSmFAnIaAl8IqIoqBCQUqj2eg+MKa5JEh9N8ixVdVbl0I39OHI7r6xXBcEHQ3rej0QFzzoCkexMfTyCcmm5JBEg625bp4WMrif/Ius4TAMTRI4GKxlkpdgyO+a6WBhSBE23
 +eb9kUwv
 JJcqM8EBUKf2pwv5kKrLBXYGhV2hNqKh+aZFRi5naczq/BX6BPL0zxj3G8mkJGEFjHCnzk63xDFlTiYlleRR24q2dgZBQNsWOQJrjo+WMi1g1JWtim9QEvmLiKYAEDIXaRhnemL0DhXqhxxhDs0zgy0CEdnRuHfv6DfnmoMU7o5/bHFekcpK7LDLZVRL7vvI62vcQ9cfPs3Uxq1qmYJmvPfT1a5aJhkhJ8M1ypK05cPYEl6OEktoBcr7qMWCM0CJvyln8Z8dK6BxCVW0qoGtph89mzSyVqRN8pMoqI4n8yju4OdBnXJGVFejJOnrnI2CoKLjbnP1MPWc+fyH6Oxzn1yxCLttqriYg4Xq/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

On Thu, 18 Dec 2025 at 17:32, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
>
> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
>
> For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
> the previous deadlock-free behavior.

Tested this on my 68000 setup, filled the memory to cause an OOM and I
got OOM instead of deadlock as expected.

Tested-by: Daniel Palmer <daniel@thingy.jp>

FWIW There was a BoF about NOMMU at LPC last week and I did mention to
the people presenting that seem to be using NOMMU in real world
applications that NOMMU was broken in mainline. I hoped they would
have chimed in on this..

Thanks!

Daniel

