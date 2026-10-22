Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7297606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=thb9DBd2
Received: by kanga.kvack.org (Postfix)
	id 9E5FA6B09AA; Thu, 22 Oct 2026 13:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98D216B09AC; Thu, 22 Oct 2026 13:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C626B09AD; Thu, 22 Oct 2026 13:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E34F6B09AA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 13:57:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A042A12023C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:57:02 +0000 (UTC)
X-FDA: 85351018284.06.094DCA7
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id A833E140004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:57:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=thb9DBd2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792691820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIrmnsOR+HHqvO287vhtPz0FYh6eka7mZUJWsTNMmN0=;
	b=nwSNXR7tRUgClNgwcSC0TW556LjnrXPHi9Qoux9w/70af2vfKviwyGrZlxM2eYfinw+/oy
	Ik/boJSRrLnYdlL7Kj/rTatR6CMw6GG75p4n00Twe2X+zNPEzGRUQgIes8EnzLwbXNepHB
	ch+DwOWneWvaqEC89DxwPDSmMj1iYqE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=thb9DBd2;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jannh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792691820;
	b=oK5rD0F4d5hWzIC/lHdXjHqoc8r0vacCeeROVgnn161jSTBEncH4WdDU02YHKAfaRM24qe
	U+jW7Ka3KRfVWH0HzOCReLZD70rrgqtQ7b4vaurvS9/UnmgUjp5IYws4mJqXnfg6nwBNuA
	qHyFl6u448HBu5FIjgbp66IeODNDEgY=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e8623790f8so6905ad.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792691819; cv=none;
        d=google.com; s=arc-20260327;
        b=c94d1CGzZMkSv+SAr/A+X7/cqj1iMmZ7AOZ3aoKlKuOmT1SVbKk8AkQepzI6wPWwgX
         mmd+BZipixqI7pcyYBlQvRi+YQdTGL4HqAJoidwNMGTT5FKRpUggelcNZcwYblC480KR
         c28A/EKkGwoZ/kqB5eAu5h/Sn2g1Jdkko01zu/MvxFfcMb9niRuj9ooRgZ3mFUZOdkgU
         5CErdBr+jnj6Oc/CapU8HceFzlO6mRgXxtnTyPi9BPZvr/au7QvIPmaAuXWcLF+rlvoL
         JlLyKQymgvAXFqGg/akXvIiXziafMQgppKIf68EuMZ4U0jiFSqQhrRFTfNT5G0X+RL+1
         BGbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BIrmnsOR+HHqvO287vhtPz0FYh6eka7mZUJWsTNMmN0=;
        fh=cKhS2CE16rdQBqPdd7jB/n631Rb/1mkeeNPNFZqZkdc=;
        b=MmJ3mMerdDsYGiFbQ8fPIllifkn6zDlOEAhOKkc92Mnpd1fYFlm5RhFMhUqIGXW9KL
         3cUFONdxYiKaeqGRjRXTFmuDcZLqXJxB0QV1sS7Jh0q+QjPSP9OHljCOL11lRV6N+09n
         G7w5+L4/Rg4cPOvotRoJN3xErYjBKFehqsjmNz09ju7R/02hFMIVwllHtIKeB/jB7Cue
         1wbNKeDATRHyIO5wCKDw2Sgv8AuK0dEO+DeVBM4rTPlDqf68RE0jJ5ccBT9zk1irz9PF
         JBMbNzSazHCQsNndM8mHIZbR3PjMXFH7R1exNMJTqIlkOVjlysdFrV15j9BXVeN5W8zL
         IrSQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792691819; x=1793296619; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BIrmnsOR+HHqvO287vhtPz0FYh6eka7mZUJWsTNMmN0=;
        b=thb9DBd2u+cxPbXuBUZKr3rgJBcKnF0P1ppuA1NMn4GnVE/yAnG0kS7R46SX/J98z5
         gYD828aiSgJhM7BXymPgkzynmjFi76nxczCdhztSSYIiE7w/tK60qjWdXbqUG926uq2r
         FVgfUR5vwcfDJib4jEx7sL36bS4YRG5fcNfGHqAuvXG14BW9kqXXdHlu2M6qxoJQQsSb
         PZ0D2dtURXYshVs77N8YwkN1jJAeb0kZqidwIEycDXkY35Cx/IozhZL5mVz2HnhKDbsr
         mCVIX+gCNKWJGlJC5xip0nnZUx1jNz6kXiJGL006g/pIQPTwlKsjTCyW6LzaKleuZDc7
         KpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792691819; x=1793296619;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BIrmnsOR+HHqvO287vhtPz0FYh6eka7mZUJWsTNMmN0=;
        b=gxJR2oGdwJs4VOqlqumHRo20leFlH+J8ZFxC1ItALFK8mNpFeZEU4mYJjeEfWXYvTQ
         el8glCyt9nRgEhcbmYbONzLwmz0ZavOJ7el17E60iwcMGcvIXf0YzpCdmuknHfNB4zbB
         WCk6m8NszVZREOCxfVRfsCFnD3/F6RzCFgEsqhTigIZmIzRFvwcbSinHf7NnAuaYxxmQ
         cb2NXVhkRl7qoBgF03Strdc2+Pn1jRqnfmNt00QfmhCKCTNOAsK98DHsgTrs0KDnCPKL
         tn9eq5kY8xZvp5Ay9kIBc0GIRXBtX9kucVABZg9vq1Q8q34YlbDw2ARiKZPi76XSF2At
         tqqw==
X-Forwarded-Encrypted: i=1; AKwUvBzUf0P2D/9GkYW1ss68puMNOJGhxEqhrDVSUWYgD/wHNrcmxvm36NQLWD7tKKc4EuPV0mywYI73pQ==@kvack.org
X-Gm-Message-State: AFq9FYL1Y6OPJNOfIvCwIrtoRjfGa8pdwrsOqgoARqRzlUfmMbxz3b5Y
	dvai5RrIPke+K7NtNfqRcxobjjitevE0QkNm5G1STtf5kl4dZOXKSK7KO4E1XhAqciEsV9f56Fc
	hiOOvulpV6xIs9Ei+sIyNmdziQ0YMbbJzdbRu5wx+
X-Gm-Gg: AYBFou0c7TN2kw+dkzWILnVlnxtILTiNnNky0oP8rsvvIp134D3LW2WJf249msrz/xc
	dbicagX/vfQ0IHLis3tz972EYPUfeCHigfJp/aGSxsR67ZcQJgNe6l0tll/svfA8D3pATGjlbIN
	Ng8KZwtXEXs1isdgjzI+rSv27lN97CO73fsW/9yGCIeZdm0rJtJV31Kslzb9n3fnL9p5Lw1d/S9
	r2dONkKbwZ99VU/rws26kNaIznRVVzS/0VuVbAmgr6fOssuchNBJtlpn0+ggBQZNFojefxLBBYh
	nEThRbgq4fcJ0R4y/986gHxXiWKZsF1jEzq90myWZ2qqE2U7ZTv5rGMxyxi6Fw2nGDsZl+LM3Cq
	ZZd4LhtGGJVjO+hcqTjGlC6r4GiW7gfvjQZjBll9cimq5f6k+yvDBu2nQHgGyxyb7V6JezuqLfR
	bxm8jVvzWDtgptD4YgBRLu/Q==
X-Received: by 2002:a17:902:cece:b0:2dd:3a08:d47b with SMTP id
 d9443c01a7336-2ea7c856829mr195125ad.13.1792691818910; Thu, 22 Oct 2026
 10:56:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com> <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
In-Reply-To: <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 22 Oct 2026 19:56:22 +0200
X-Gm-Features: AclHuK-YCNtnPegYnn9KvUKugGxObkR7MWrtu-3qSRj9_sjY2T5TwF4c4QpzRSk
Message-ID: <CAG48ez0cG532aaXZF_asCDk+fsnQmE9L5PA9T+JN6OGdx6yjGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized
 probe can't be written
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, 
	mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, 
	liam@infradead.org, ljs@kernel.org, surenb@google.com, david@kernel.org, 
	vbabka@kernel.org, hughd@google.com, kees@kernel.org, mingo@redhat.com, 
	tglx@kernel.org, x86@kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A833E140004
X-Stat-Signature: he8zbskeozj4icq1ib5ce9to5m31kcae
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792691820-64923
X-HE-Meta: U2FsdGVkX1+rAT4ON1FfKrxYqo8S2aIQSL/pVF20dsOt1PDC2mUK0Qb7qykXq4AgJ6iEE2d5hIXMvbi+dF2gINBJJn4d06+cxm7hHNZ9pSeqgI5SatJWhQiIG/iXNr2wmI3ws9et3p3U9pqFV7/JqKqMLHImLvMxxYTVFBp4krEuE6BsH3SLO4xYavsisL8WY8yUXgBVgiEB4epLgjh9Al0BtljQ6dQ0bSx6b9bx4HSlvQUZDpuhN0+t3iIJu1jwEo/9uNSQ2dYT9FFfikpC6e6Ns1G0ZVTwD2QryAYRHDynLDQj0y0uj7nlUtGAA3oleu/zNMA1sDPBBpeqKbNqJjiiUcEwZREllhLBGYmr3uMharX0u1NyzoD/PCW+Jt3K0DBg2hdLgQJl+6zuaU70hYZg9Cu2K4elYfwL30O3ysZfLaXl+25rRbNovhb/ENnvNqphxHP9miAvLWsYn8Ji0YLQK+8GgLETlWw3AsVogioEdKAFS+EBc/oWtKFpZCkub/IuWGPCwglqsHsEXJ9TY3/yNQwWgFAEB+a95u2siDeaJ52IwTNRHzEp/3gNp0E580KaK3IplalPY8gM1kZdY1m5WqNcs1PtWOKwzRaezn/L5cPV9h8+77DFskr7EyIYLEplW0y0oqHPSu4V+CbSYfSsr27CVfKRtz5eMcPI8CsT8lNMUIyD6iIX8SR3c2KZjRl0MR+XIJUToOI6naPXTWkwi7GaYpCtT2p6HPZA46l0O4utO+ohW0ECQRH7EXwwFLK7H5ZVA2MCTmC0j+Kai67jU9mx8SYjeEuCDHQegaeo6oFjhdyX4cCnH/d+ir8Jy4JoCuBwmxdIH9GDFa31Bzfr11Vn9+69DHiTpGoz2R6nD6O1MP02vV6lp6Ww6gOGajQKUe2MzzYhRFny6+Rk3/z/ZI2dLYJBg0exQ7H5xwfOyuwIAf7H+ujyIEafzUIw6/6Xca5lGdHfkeSgaFq
 NZGBZ7Ev
 NA1MjAAEjBigCt4XyYRuVrlOSXknwzq6TBwtAbM123v3FLSPvL8KVRhivkkq6LBa1eRgsmaL5zRDJfGdix5fEnC58BwZ/BLdlkcnG9NtAGnAnlNQoOVU4S+YccuEVm6pfacHI/raD2fP0iW819jNb9mTcbzQ4XuFzflKuu4dZL5smikF6MYHk9hMkf1cGuFZ6/VcOa7Dgjy6M+Dhpw9+gShhj90S42EQDZ9JnG+ucsiDusR85pfsPAz/JiuxYeH3hlWEx8Ak0d5PuOaMtyFUriEHX8iihXh4501fDAoKNqzIb1Db2FQwRJGopFyvM+U57PU9zlamUvSRthEqHMGNuBMT7YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 3:57=E2=80=AFAM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> @@ -1197,7 +1194,7 @@ static int __arch_uprobe_optimize(struct arch_uprob=
e *auprobe, struct mm_struct
>         if (IS_ERR(tramp))
>                 return PTR_ERR(tramp);
>         ret =3D swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
> -       if (WARN_ON_ONCE(ret) && new_mapping)
> +       if (ret && new_mapping)
>                 WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NU=
LL));

Not an issue with your patch, just FYI regarding this preexisting
WARN_ON_ONCE():
A failing small GFP_KERNEL allocation could theoretically cause
do_munmap() to fail; the VMA tree has the ugly quirk that you can't
reliably _remove_ elements without memory allocation.

