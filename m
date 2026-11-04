Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83466606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bDR5duko
Received: by kanga.kvack.org (Postfix)
	id A4F4D6B00EF; Wed,  4 Nov 2026 04:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D71B6B05B1; Wed,  4 Nov 2026 04:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8766D6B05B2; Wed,  4 Nov 2026 04:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57D2A6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:47:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA472A069B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:46:59 +0000 (UTC)
X-FDA: 85396957758.18.004AC39
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 222EB20002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:46:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bDR5duko;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XN5Sh2oQBbGY7k0dXGAYdV4jnNut/n5mRreEmSnndEc=;
	b=1d+sGXDWHXNFXGvPjJXgRkwn76H6WiCc6Gxp1wj5yCEwmpLBOkORZYWouhk6iheCWvyZVq
	iiQUfHyRevWxeLfb1S1hvXJavrlMTQXuSKVIajnZycdLql1uceY9ZLOQXC9QaTXEOj8i8J
	s0EvikTunDV3gKlsnyR1PNpjN4NDBo4=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=bDR5duko;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of bobby.prani@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=bobby.prani@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793785617;
	b=if5WRKCyhWaG+4puD6RHAUx65ugz/S9LS7Qn/LGP35WZP+BuNjeU54QQjld79zcL1plKo/
	QT0hLipQ0LBzqd8pA8ZaYOjC6STn0YBxCaocH18Ejl0exsh0sWuEoeGmQ+uLU6luEqTxKh
	8TQmKthvH87uAaSWwFU/yPTAqGPyNQs=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3ab3b29a1d4so4036581fa.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 01:46:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793785616; cv=none;
        d=google.com; s=arc-20260327;
        b=fNPDkM/8GrDS1Evr4B7BYDUiNo4nBgnJN6p3uo3Iq1APrENoeuoBLLn7jcO2plc7Yb
         yJWt1ohLXL9TVKjwcLty/NX30YmrkNHCG6DtRtM2uXzl7mjCczY0ZslhX7+tY4S5xnWR
         98pYVaO9IwXkdGAPMajIZe0caZE0mvEsTAtRRYV39cna+7ejPDyBdy+mqoX9u89Kcrwo
         pPIl5EYjCkaiOgSsgbF/2vxL2l49pmlkO/4+Whhy/hUDSPesshATO8pj5IGpvG3BuJwA
         wIx0XuoWwPKAr4v4/ilCvSAcjk/EteZfrQQZKLn/VkntK0bi3CFelf5U+MVogVd+vTPH
         RaGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XN5Sh2oQBbGY7k0dXGAYdV4jnNut/n5mRreEmSnndEc=;
        fh=ojxrSQ3w8YdPekjXumR+/gAW26gDpia9TkLpr0GOjR8=;
        b=XHTHXA0Yfws2OQ4jH/PVsov91B6d7nCvF+QRe9IF+3qYrbZvebhsBPUv2uYAY8lZb9
         PsHL3vzCJ497jz6N0W0hgOFm2C/75UDvZoBqAbEfO7Mxal6AYTEL6eppcMiHWD/pLZRw
         EZBp+j3ie5B0g+BtVzTI1rtS+fDDeQZmXcfnqZRSdCdk/jZhVGeVa5pFSDuhNjtuJz8X
         SGUsxc0SP/OZ7QPfGtC87Q0aHQmTlhkfcrixqsSjOKRxOBq83U+JNWRBf83Dmcs8yd+G
         cJx49gJQyafAyL0enxK8sEWvlU92Xz58cL4atDqpYknbdU7uKLfECtSoKrElMioUP4Ni
         RD/Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793785616; x=1794390416; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XN5Sh2oQBbGY7k0dXGAYdV4jnNut/n5mRreEmSnndEc=;
        b=bDR5dukoXIFST17dTIsd4EpXiF8Jje+JbUbkhFamXSHj7Oo9Y2YcX3RgjY8AOAtbPK
         64gwWeGzg1VsX4rk3Hol+UKEZPY2/iwbHON2ogUav5cQ9R6kdtthe2MAiEwl9dVcCKap
         7/WuVdPoc3tIxzSa6ejl04oX1sTuWNuzxOUJuxnkXSsewAicbrVx6BG9oG/8SXqe9ExS
         Q2lU2AP69ZwBiVU61wZ2Fq3+JGYvaW+YZMTp8lSDTUOiWW5CEZ5ADkWU8Ldhagx6I+x8
         W6grhZPQchU+EaXR9QzKua2CVHVwk0+y3IB2IXMBZSkd6XU0z0NCxqvajek7IOWmb7gL
         gHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793785616; x=1794390416;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XN5Sh2oQBbGY7k0dXGAYdV4jnNut/n5mRreEmSnndEc=;
        b=qN7xzpV+i30SZ2CwOSJcwrF2Q4z3grlCAO6ATRoG3WcuFlGZl006RKQsfvKFMB86h8
         IlQA5RD8FeugOWppruwNsIguQk8b3k3P7vsrYXUXNPflJNU0Sq6zKRZVDEzuBu8+6TgY
         VM99mnFpEBeDGxAUBvySMs2wTghUG1IVzpSSjPKoHMNEdKR3xggIO58cL2N/0gcOtO/+
         xudjqDQ0SApjCbzxIe+AXVUInBoeZl31Jpea4Po7V/7Ev1NQON7j95B+xv5bz28EwNi7
         y5ieMYIDNbEdxgHggr96LAp9gVCGwshg49twkEXj+2aIKMqA14WsdF2XsFCtVt0b2Xp8
         Ss8A==
X-Forwarded-Encrypted: i=1; AKwUvBxB+Cb+yHWIlnGuGpoBfn4mzaCGsrZN1cT3ehdUpytB5wvphzZ7l6b5nLWK8u6jZ7uybkUiNYZw6g==@kvack.org
X-Gm-Message-State: APuU4Z8ibtvGlZzNUFb5gb560dSAV0rQ2xREArOWGEZaD1K09nGpPpky
	ZxEEs+8mL6OYthIRFKTpZbtSocCSEG58HrNLXKdfiFsm5RYqkk3iEGNaP95JmUM6mXQjsRCo09N
	ZmLoZdnUKDofEp2g98FTTnNlPEFF+b1I=
X-Gm-Gg: AYBFou1uoMHhaVWoxM3ZtDAH3Dl+1Qhv4efOEl4+GvwYYJjQ1kCzcxJW9Atkvuj8M6a
	VHyWexxfdz3qShgoD64pF+oIIR5/TX/q8++si4nst9REBTXshqxKH5jC8r2Flyw4FjXHYQFHsy4
	ytnqJ+PE93gX3cNn997cUzrj9SeguS8e0ujda7EAOGhN/V7bRTrIU+gjYFCISd2Wg1mzs5/fU1E
	s6vngLGHeXAosbHH/6UKvMBLRQiLATql+B7Vzfx42lLA7wZstn/RsXrfgRq1XxETy4p9A/JtCL3
	2QcBpNnzjr3KRb2tdGdrqgNb3MAn0TA4UUu5JiT6ep3haDpKAEpXye53d5T7XKay5CYY7h14POc
	IQ5XqoTWUptHZd0qZ/P9OOqkCZdrhNYgJqsg=
X-Received: by 2002:a05:651c:554:b0:3ab:2d74:71e with SMTP id
 38308e7fff4ca-3acb7aa68e6mr34698191fa.10.1793785615870; Wed, 04 Nov 2026
 01:46:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104013139.1341582-1-bobby.prani@gmail.com> <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
In-Reply-To: <750560f3-4c5a-44fe-b72a-0611be383f32@kernel.org>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 4 Nov 2026 01:46:29 -0800
X-Gm-Features: AclHuK_952V20K0MdX2zFJG6-rtCJoctiobjvK9UdyxPOe36f3zxfg36adJewT0
Message-ID: <CAJhHMCCu8ehOU37_4UpExNO3U8YPygjnht+2S+axkxTwY8bx2w@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/rmap: use release ordering for small-folio
 mapcount removal
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Richard Cochran <richardcochran@gmail.com>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:PTP HARDWARE CLOCK SUPPORT:Keyword:(?:b|_)ptp(?:b|_)" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 222EB20002
X-Stat-Signature: 1rga8z4sefsrxeodznuc4dg7d9pu1tuh
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793785618-407832
X-HE-Meta: U2FsdGVkX19u843fims439dS6Ktjbz09V46iEJH52tykUsfFk2SLom4LEKDfKZpNGM+SxoWejUxVXKWKXvIEZYrqsNlFlt9x/hZ/mf+RIIGeE70gsM480urZvUG4KjQRvg+DLGfXJdA9D/25y2aRMZiEhvHwoVtu5hH4ybSq7RFtXCLxmavHVERHuAwawqir1wYMTQTsNVcgQG9A7ft+BF70PrP50XSaRK2OPSGoC15JbCZnb/CqRsBV88J1sWNdu3ED9BvjhCvGEv8mJYE+WO4+RZLoP8Fa7y2uQklhYfe2KCNI9+oS1HgPHp3MQmxC654Cn7ZzTdrHNIGOUJgQtK5Nk3DmMma+kraG+ya3+eNz06MmaNIa/aHIOidbyac7AFJetMONCLgmp/tDIcTNaSO5//xpuPvimI7/51a8YAB7c+4PxfFpN6HZeB+aSGF68YTe2mSvPazHp8dV5e8fPLGRzCy4GULo8cNMXFvK7J5+mFvpKq27dBDlwWkUmnVHqm+MQihjLPAkUNVEb+U5upGZGE6tASDDP2+FY+CjbPaLWMyYO+pgxRjqIoDRdj5mS7m9hgnhtRLkTw3SCWXuXKVfApKH7aXphH66clyPaErdymTAkz0E5UsRE/MC2TJ/yFMzvpLdT2flP5On/y/yB/z9qfV3+WZ1fpiKSIFAf887s3EU/dDwN6kWQNNnerxGRQfh0BOe4H5pWC08Vj3oacs8oCOrmgOs7eBiSGzHkL0NkVY5As1vHfFg1ihzbGQUc+mNjw+2rouT0MEp05tz79eFUKcdc/1YWuIIrVZFyDGoAppipJeC1YG/LKdGti1Px2vA/LgEyF0UN+D0+EGIyg6q3mdD48u0ZjMGMcZMwfMxY7r5+3Mu3MKiBL/krcBgfurTYwUnG1JJFXginyrtq8vr0kjG6SOV+iyw00jwGR9r7rt/S2KA29wHUNglsXHrJ3Wo49SrtJoikg2mnhp
 rgB5ifYe
 KA+zW5CGXFFMaxqYY35l8yzeaq5F44hDcPtPjAeOZaW8LN5vglsxss4rqrnOM5w3iDGBC3i7nMiNdnuxFt4G/ScExdQRGUdU1Fw1tanbCCFtNNc0N/+xZw0O84KWenJ/9JPtj+DTvCt9ddYAy0ymhTgrdcCurB21n6+msWWOW03b4RxsePnboBKi4icnxD1qkBIsXmsSi972VeCQyQgNmWi28zEk8yg329L6zkkRtuQ5AxOQ9RS8BFM86NLJiLo0zcIlb7kpgHJMGulNvJgZJVKAxCsJ+Y9lJ6Y0SsQXMg3895/zsqSYUuiJ8LbqNN7rD6sB1xY8XdTVko020GtWIzUU2X69Bl/eAdlranQ/WrPCS+g2RmbuvXGjhg56dOcAAMy9pPebtBeck8EmHqQ4xPP+xYMkM9d7hNy1UF1HLnPabL1eR33XqBzPfGBeZa1LdhIJ99yNnTQhZNns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

Thank you for looking at the patch.

On Wed, Nov 4, 2026 at 1:16=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
>
> > In an arm64 page map/unmap microbenchmark with 20,480 minor
> > faults, simulated cycles fell by 1.54%.
>
> Thanks for the patch.
>
> While I see value, I am not convinced this is the right time for this
> micro-optimization while we are busy with other things.
>
> This needs a better evaluation: 1.54% in a micro-benchmark without knowin=
g the
> stddev isn't particularly helpful.
>

This result is from a deterministic simulation, hence no stddev.

--=20
Pranith

