Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FF5CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 19:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B0AC8E0009; Wed, 22 Oct 2025 15:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588918E0005; Wed, 22 Oct 2025 15:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49DE38E0009; Wed, 22 Oct 2025 15:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 347B88E0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 15:21:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8D4B88C9A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:20:59 +0000 (UTC)
X-FDA: 84026717838.03.501460E
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id E2F4512000F
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:20:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QYedVnCs;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761160858; a=rsa-sha256;
	cv=none;
	b=dcm1cAp/4ecCUInUViKhEwp8I26WIm8z/4FjZuf7/DUhwDtUc2RpazUqQJm8Kc3if5r+5U
	A05qqaKN85rVbR3g7myuJtDur7bPjUx5LtHq7ylWAiouxVAZjSB2RWxglTrzjUw6rqw9SK
	eovkgvc0x4uP3c5jsJnzNNYDBZxSHHk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QYedVnCs;
	spf=pass (imf29.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761160858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+qh3CE/VzNaTrqql/qoqDM5HA3CBNNxquHRgL6QD7s=;
	b=by44ATBy4o9fhiFaCffElul2fIOwBBUj/OPKmavf7xqlHpInWdCEQyMwMtnYO8hWXoTy2Y
	HI34sKxO1MPaR9onHD5FNJ0sWRdfmxLnmCtR5zCV+8X0lzu3X52R8OY8V0ZEFfvLgLgzDK
	aEQLA18vQcrv7dgwwL0K3mCanjjEr7s=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4710022571cso61825855e9.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 12:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761160856; x=1761765656; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k+qh3CE/VzNaTrqql/qoqDM5HA3CBNNxquHRgL6QD7s=;
        b=QYedVnCsC527tSmKfNwdzK63WDaTMg3c3p61RQ/B4U9x3mwz5WCeR+Luajm8w9JqSc
         JtriN9JV+LgXLXGZz7cXVE0k94upfxQNO+RxXhnMKLxAKJLMnVlTWYb07wg903AU3d7Y
         //mw2nOThh8p6fFWXPP5buk13f4y/T0LyE9/Qc9Txt3RRwrVL6CIf3HLJ6oOORfEnkY7
         OOYtLrOkUT9cVUGavnTTZ8JaZBMlpPlbJIGDE/iFP9FQgDEcKYMCAyUM7oE+lMSFdcp6
         hY0nrWj7GAEMH0dBS700dM5PWnaquGcd1O6TrQHcEROvn/siVXp3mKnoqPNCrIb9SY72
         Qg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761160856; x=1761765656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+qh3CE/VzNaTrqql/qoqDM5HA3CBNNxquHRgL6QD7s=;
        b=DLt+8xhaZQKyImFkPuOfcIf7eG4Q7tFiruOwITt7lBrbYExOL2k/dtvDDPN8ueOuGT
         0vTD9NlrsR++QCXhjZdy1gdSxKQbQsRWb5/3Cr3MDDmz/poE/TkXn8WIR2S3HTCUqGqg
         ahS3MkUljED7p0RjjKArYpHT6bQoLxHrYM/PHHplXpFMBHnKgNhbf3hGKrknsZ5BvyWR
         F86mTgi8DA5Pr+8n/vBO8HbvvQiVs78XuR8tUYuSHZKEwrgIRzJpWtwMWd4d2eK4mC0z
         ImDjm75Azgbo6jDf5Yv8OexWxMdYArd8uwep6YHyo9oDNGhxEacbUx2IxG9xp3ht6VvE
         Vg1A==
X-Forwarded-Encrypted: i=1; AJvYcCUmtI7sRJc6NPS1AajaflgWzPqVrekm+9YzHeBVpzS711iTpUM7fKc8ou1X0elrRkjMl/nxUobwQg==@kvack.org
X-Gm-Message-State: AOJu0Yw9w3SjerYWk6IpTlBroslxtn7uZJL8eTx0eM3C0frm6z2gQObm
	E0Ws55vOcVMJDiBrBdQmopu8w7pHux1RH/G3THzWVP2k0RzS7lPkxV5om00COAx2ztoU+UjxEvF
	5HE7DFp7IB1emvHFg/Mras1sodIj+CoE=
X-Gm-Gg: ASbGncvT3TZvt/MJcQ7uNEwE2S7LpJmTq8FG7NfwII6afe88Tadw9LQi9XKIhSbMqnt
	UAV3BD11A9HzSl4pCBPEnMIKIakzwAbwvjDgDjHEd4GX4y8/ezL0nochgo8CWhhDAaDNX5065Nl
	U4/nDnBzaq4LBLJOdONuS+Na6SJPh4XjgDfOm/1P/6Waj11S+J/YFt4cIi2ybcAl6LbRO9AqQiw
	xtqj0VTOkGhC5nDudoavXEPf3FOohaXEFzVSjSE/km2V1GjX2d+yRpmrewJNFq/e/YdEkgJvLje
	PCcbHXIwSakEQ8ZLta0ZS2S7HkII
X-Google-Smtp-Source: AGHT+IF4876amNxsWT6lCxn1MJaV47IHSNaa9AOOQytVEr4VTHmcwE9o3W3K49dS4kNqMKk7vJ3S878Sqao6E3aUkEQ=
X-Received: by 2002:adf:e19b:0:b0:427:53e:ab3e with SMTP id
 ffacd0b85a97d-427053ead3bmr14361051f8f.56.1761160856038; Wed, 22 Oct 2025
 12:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20251022-fix-slab-accounting-v1-1-27870ec363ce@suse.cz> <53f0cc42-e19a-4b84-8631-390cc5b178f5@suse.cz>
In-Reply-To: <53f0cc42-e19a-4b84-8631-390cc5b178f5@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 22 Oct 2025 12:20:44 -0700
X-Gm-Features: AS18NWAFaUq4KxlFKcEHWSegwYcFzQGgXDB1ANKnMEoNkJowl2AheOduUky5rT8
Message-ID: <CAADnVQJXDPFaY6HyB+RTnGAVk9xwv_TZkVxu9MO7EPRktRLndw@mail.gmail.com>
Subject: Re: [PATCH] slab: perform inc_slabs_node() as part of new_slab()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: axe15cy5pr8kmkwqzy8r6agdgt4pym81
X-Rspamd-Queue-Id: E2F4512000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761160857-148990
X-HE-Meta: U2FsdGVkX18X+2cir6D0mJSqdJqYAvTMFDYSCbil6kkXKhwpf7mPuS6sH8xu7Hr1NU1rVONcTOC+2EG93bji/S2RDlWwH+wl0oyFCz7fu1UXtYTpEolVTdhBqO60PZ64SeCFDNMRnCUMGu3aSCD5rEOQQdN50uwwpdDyJ95fj568ym0GmS+Yw3s1IecyZqdzKCzRVNykAOJUQMBIGgab5wkwxniOKMXs7zIVIVLyW/65sPqicnJid0sbO4rEoLQPMS4WjqoNChhsz7W9DfS5o3yqPkPzh5TiK/UTpH24cSTwg9IImTU6J7AzC6yFXhsOT51Eu93neFIiaoTYW11CjiTv/O1DeLIAsuKhyZnj/A+nU/412ImK04fTtykpIHSNpkVb9D4mi/mtA35tiX/GJ+kLW4kA6+CAOH3pSifmKyNRGMtF7Jc/2k3tOJGEqIy/bTjJsFdX/KGUaqbmCoeTg8aU+Qe9E64XlKcuSrgLqvBTjWz3Ee/e7pGb1vitbkVncPfHVMbC13B1q/zwjI5Yv4Gt6nrLVW+ihbGZabU2p+ET4zyZ7Jj56aK/ZNM0v9djHiAFYuyvQXP5jsCIZGPW8zvDtKsThQG0YcshaB5DF3Y2vTWHs4ACmbAJ8kyOVyJNs80JEWKcbjCCJrQRmrzgZrPjRWhRx+JEQXyY77DNYKHUv3mGDFWSp6GhaulkxvlGuUxJc0rY1TEeHG5PNQSM3wh3k5fefnAY75W1UeAqeFGJDHlDJ22/LGM0FXg4KUPEDLhHIxIGSO/pA5QmOlTkTBhjls1lUudjnojLopDtf0Z20nk02WTZEXNtMRsxmAtlc1/YWO5zmgbx/U3nNSINyrgNvVLN2K6zFv4/4MZlrHZ0tLKXm5cpzz8393zKUm9FJyBNWnYvJ2YMwb0ZA3Ls0eP+2jvnj1sAVqJRy5eltqiFpAqCDZ0QvwA6P6tJ5DaDCMGbcVtuthgFNr1u11z
 ORiqWlks
 t3XKPO/rdGZOoCqPsuBhZAj08XmsIPYyM24fz5wvqbBBOwg8Ni1s2l2tagN2+0og7UlBkoTH7mRj91+5XvoKBrSxaNl8Ql/du6zshh6TU3RzhSZCfZHGVYsbgnp0LgxXfmJhlor7MQTYEDxQSBE6qPNtwmoEkcw5CjLbOOs/Dj+o9ueMAhHO4q9fdkLLUYEPHJOCujScu7bX2H4Bnu5zez+B8afi1kIS6h16V1b4Qm5BomcIDOlir/JjDnQeXvNietzeLrN2s5O0spahHi3hvMBUGIuodvY+DeoKsJk27ZHUkDuaCYMjWeu5TWpaYZNSmy3Yd5Rxdh2nfE038mfHEAcDFpiY0Mase9grxcTRaqLLKMaJz+c5fhjuglPsD6DgITgL41Dnkyqbmv9ZPaSCmbI+t+MvMYesDBYmtvM9Kaa0tzI+aGinf0FSM9RaGwUmfKWcDV9j2PFdpte0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 11:00=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 10/22/25 19:23, Vlastimil Babka wrote:
> > Since commit af92793e52c3 ("slab: Introduce kmalloc_nolock() and
> > kfree_nolock().") there's a possibility in alloc_single_from_new_slab()
> > that we discard the newly allocated slab if we can't spin and we fail t=
o
> > trylock. As a result we don't perform inc_slabs_node() later in the
> > function. Instead we perform a deferred deactivate_slab() which can
> > either put the unacounted slab on partial list, or discard it
> > immediately while performing dec_slabs_node(). Either way will cause an
> > accounting imbalance.
> >
> > Fix this and also make the code more robust by performing
> > inc_slabs_node() in new_slab() itself, and removing it from its callers=
.
> > As a side effect, in the theoretical case where the new slab is
> > immediately leaked due to debugging consistency check failure, it will
> > be accounted (as full) in /proc/slabinfo anyway, which is not wrong.
> >
> > The exceptional caller is early_kmem_cache_node_alloc() where the node
> > for stats is not yet initialized. We can handle it by using
> > allocate_slab() there as the gfp flags are known and fixed and we don't
> > need need new_slab()'s fixups.
> >
> > Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock=
().")
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> Pushed to slab/for-next-fixes for testing.
>
> Note I haven't seen the imbalance happening. During the ongoing developme=
nt
> work I caused a very deterministic underflow elsewhere, decided to make t=
he
> code more robust by creating this patch, and when going through new_slab(=
)
> callers I realized it fixes an existing issue.

lgtm
Acked-by: Alexei Starovoitov <ast@kernel.org>

