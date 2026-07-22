Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4561C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 19:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808736B00BD; Wed, 22 Jul 2026 15:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7928E6B00BF; Wed, 22 Jul 2026 15:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659B66B00C0; Wed, 22 Jul 2026 15:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0B46B00BD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:16:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7007CC023B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:16:12 +0000 (UTC)
X-FDA: 85017368184.27.86581B5
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 18422180003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:16:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fTOZ3Xh9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=harimishal1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784747770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozOug//rn4js3ZBhPhRoANd/kYjBAviHldTtDn8NnaE=;
	b=zAfZKTAgrAQ2U+oGO5dMcMqtyT7y0N8ZgLI4A0fO6jPBFr/vBUHmrHdX/6iCiHXspuW33F
	xsPFnYcn9k+bhguqqTOhjvveFkbO3yHXy/rAOHCtEDQEDR7a3OEB4bDddAcQfkDLyckMPk
	XR5b+aGyhqzIok1nL2ytwkFJOdZf8yA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fTOZ3Xh9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of harimishal1@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=harimishal1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784747770;
	b=tiTqnBMw2yV7khVEvReu2zxudjxbxFkSf2dOFlb+vWhTRCnS6LAawuEVSsL9wFyPcnN6VH
	3wliXWXE+eAr0bVvDs6HU23+/yPl8Vxovr/KJuehm/vjfrcb46W8tpmN4ItDvxd/kbFQdI
	Wz05KhXoLl6JERfgajG/+k5vGLPtMoI=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so6110026a91.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:16:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784747769; cv=none;
        d=google.com; s=arc-20260327;
        b=CxANZ7blUViUxTMUd5ucRdA6hT3DkLScmia313UJmZwgyYktMILLULAGB3qdyXkfqa
         maAEpRVwU05kI8KVK4SEMVn2ztDhXF6sr3D0uYpwTEZMUujn15gFB+spre4/lze5DgBH
         ZNnJRMC9guXSuIUcO71lrSOqH/DFD1JW2NFcgNGFrTm3i0rH1BTiYI2orZa1nfiKAtb4
         SijpB/rU/JV0CFfIFsdFHLwmx7+iQ+mawO4Coy5ydOR8etnr3tEoJOFd3tewMpRBHtde
         qbPM0srW4vgR3JiDa++8FJwGwHQZ0emrMF8OuPufBrFaqiUePXcq4fBRXI7gnlBLaKd6
         WvIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ozOug//rn4js3ZBhPhRoANd/kYjBAviHldTtDn8NnaE=;
        fh=x9PT/faMZndQtL5X72WPenWiEGIcciiyETBwM4O+Ub8=;
        b=ImVykh3Jhz0TwV6IsfNAveIaSQV9CwDVixca3uR5PkLOpwprxeojhh1W3odgwbxeWx
         AVrY41CUqGkpU51H3Km7SseRHy7Nt3DqdFFDBTGpGgFtWQWf1pG2uPHgTfqcoatdNTkx
         gImVCVpCrZ3X6YorSnWqZzYQTMIBFRHDeWvBgyZcY4NsIT3SiPcmG5guFUVeGGwGhaCz
         qtfil2/4+6FSeyrR2CgVcQME9RFJIrNGq5FQEKKaSCytso73kwYwlBXugyLZYMfzG0rU
         /BOdLmSGoXNh7gOt5r0NLxebqT+JK2JS8Xrj/jo7Dgitxl3KGQGSBSrwCWg/3ycKi24h
         txlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784747769; x=1785352569; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ozOug//rn4js3ZBhPhRoANd/kYjBAviHldTtDn8NnaE=;
        b=fTOZ3Xh9DrarTTIK6fJOrtvbkYpOLfkUB0tlXV6LA+uAI22lNZqOmI/c4XNwmBFUIw
         ArPE0plRY43Uvn1QKggrnR45KH6xPRivXFuMOirl3QGLegyBdBmmRMLqKYmA+7NQzugB
         A2uZ1B22Gq6uxcbkzGMBtxdMmMOEvti16WXBdtg3TOn4jbgGi6VHiCk2s32VLaVBEKqG
         aFiKXrHAFBLFRwxe+Zh+G+NEJgQ0jNxDSVhnW9L5/+WyRtuUNo+KtTkv6jEXP9pd41Uy
         gWUQ0Wk7pEaVlyVwq6xQjCPemEESZ5eS10xjA6mKLX+XJpPojoHiDUp9c0Cn9sk1uwDo
         Umdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784747769; x=1785352569;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ozOug//rn4js3ZBhPhRoANd/kYjBAviHldTtDn8NnaE=;
        b=TGC3ie14tZl6O4OyNGDPovD0EEh70Sil3f+x+hyT4FgxgG2KVpvjZY2/NbuYlxY8pu
         voRY7FCH1fWIQlTSBKl60t8D7TM/UtPto7fQEVeGpKbDGU4jzBFTJl9E09MeF6OhJ9uJ
         PhnjHGH5tbyrPRh8TYQK46kE4letAaEi7pKQgKpMw34CdqY8J36wqcL+JIVQCsWI0DX+
         oKH02K9p3x/5vRn56f5HvGhpZ5EjCguJcJE0UHJx70sZmU7Fmqz58a0yAe+CwdpFtj72
         k/x5L7j6qB55s9wSqrg/GoLURpNNXIs8k1PEyuarbg8+mppiIC77xAjsXvTGtmAl0oxc
         +SbQ==
X-Forwarded-Encrypted: i=1; AHgh+RoWq4vwwUT81f5xDWuiQnJjlTQ0aJlWfp1MaVjlTfR2Z7V0DVqus+zZkPTXqvQuZXdIxVnAKPS/cw==@kvack.org
X-Gm-Message-State: AOJu0YwzVAXc2jvzskMA4wgfU6NFP73efHEcccEzmT9s4IEEYpfofuHn
	tV9WXj+A3nBmZj5kf6MA5homgHyywvyd4rvWpfkRL18RgE9J4+khDu7oFsUq959zqaXjCiIB4aX
	8DKrcRGzZvQciMDnqMQilIi+kBmyiVow=
X-Gm-Gg: AR+sD10y+2cEGcquRSneFw2H3ag25K+9eHEInWIMfDIUbtQqIKk8wHQljWbMClgRbxO
	nlGiC26j/xMcxPWipsF/EySs8LTAl+t1MSuMp+V6es+3L5H0An9bALSGbZNSx71GVkhzehepQ0h
	J3KPayfsb1xrMJiGQlN1GqfYXwpPAldb4m9qyxz1pXVPN/AvicF5vEmxV7psNXutkaiKwyVIrsn
	Od+i/0GkK6CqInjvpAWZSWnm+arihNQVdJo9lFF7Rdp/WeQ0ebJfIMCNHkt4PN4JnmR6IKbHln9
	x63nO7mlWIo3d4cl
X-Received: by 2002:a05:6a20:258d:b0:39f:a8fb:3354 with SMTP id
 adf61e73a8af0-3c3ad805268mr25896068637.17.1784747768953; Wed, 22 Jul 2026
 12:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260722033844.65932-1-sj@kernel.org> <20260722134812.88133-1-sj@kernel.org>
In-Reply-To: <20260722134812.88133-1-sj@kernel.org>
From: Hari Mishal <harimishal1@gmail.com>
Date: Wed, 22 Jul 2026 21:15:56 +0200
X-Gm-Features: AUfX_mz66IglqNqdzZCfbnWOLo8Vdschk37JvoWGxCkjUKLSNKZYiZ0uUUFwDeg
Message-ID: <CAMmC+=BDZ6thHptTq=yGvfygUQb+0i2QeGbKXH+OFcXpnTXv1A@mail.gmail.com>
Subject: Re: [PATCH v2] selftests/damon/sysfs.py: clean up sh processes used
 for obsolete_target test
To: SJ Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18422180003
X-Stat-Signature: rrpkrf6ioey5pqqx7fs7534g36z7gnai
X-HE-Tag: 1784747769-200456
X-HE-Meta: U2FsdGVkX1+zG7z1KFQFP0EcGT9/3AjdNwfvjdM4zo1g/eJ/Kv2xk0tZ3ZbaZna4C+Oc3CxLsWN6LhP83UlTTSWvzFSH32i3vi+wyraBJpGzod3V2s3EYjkb2KAB7ZtNyUs7+ZHorO78NXGdeecermbP6mwJUCsWAGWLC/EsWt6YUCOjnDHbIEcrmhI3Xf3+gmOhVJ9UfJJEfNlcOyTEcICgB5DaqYdt3HQvtYLrdgUnqTC86zPKbzbu5/pSL9jPB9Qvcdua+C1xY7+RJSR5VDAx48C8IuW8laC7OtQQB/sgf27QdpVJbbDb8Hp2Yxnc3AijS+95fxWFGSCtzOUfWTszskwH+lSPwCyorBhTZe1TRLGXFOgb00JrHBZ1VCugfuLKEU96mezfzbRydqqQYj2zIVxf8JSoYmAabAgaqa7XzAbpg8WbAZE4hVomxmscKMVGvXBICJa2+3xxctx7kDX6vxKRWE9BNAo92Vve6OPFef4md9LrvL67gBtAYlAgbvx73Q81KIds5rJ8j1GsdjiAwR1sBpvKkqvPv9w4b6jS4BUWRkPLVdsiIex9zmXXIdseJQ1y9238OOpZcHdp0IqO/ORJdowiD6vI4M5mQoZJ07hS7Pa9r2BiEVhCYJ3JFck38npEMtMoLS2vbsy/uNys+3qKUo2t8HDFyOvLT0FBHZDHnWkk4JiZE8w2ww5rIciMPBcDlBp2d6748+/Etuj/3DrRfrz6ts1i/UajbX0sXHWnV9ND/FdP6jUjuR+UxC5dPOe3U1bEMYi711RI5uUGxFsDwfuOmsNBvZqMqH3475Fz1NSEX9ez9qWrgsgjqFwh334X5W3I6xlBTr1L3EL2EWEeBC7raQHIs1FOfqsM8K0mDy+MYgHzaWrKyBC7E89S2TW8/mwVLP0ALVh1Ah9ZC87MPtYHK2koBZyOIqQJVx44ICvGvbBHil2yZ7OB2nrPhWJffReG5kbsmYi
 KCzfyMYc
 NnURAajhwM9GWEZw/DMD29OQWd6cabVrF6p/dIgErr+El14Lqk8Yh1owsDvEY1yDGBdQxIIEa5wJfn9KJpIksSXGWorNom/J9nNB1Brl3uzty78/PV80MSuX2kTzqDEwGTfWucKlShmIALGV3lfysxHJHoKO/p2UUAAk50n7zwULXEji4wyHnmeM5Klq++dIS8GSEnEG7sqLElR277OL+fdgl3bTiRBeEYNY9wLRHeiq3BLm8FFrb5zrxO+Zg2gmO1FaUikEWPVovZ/p9eatYr22jL3YMG4zRsFsMW/1riT6CDpVGN/rcPvoNpKTtBakdVGm3MdRdYBwpNCrNk2Gr19l37h6M7vY0RSG2w6FZ8ZZD22RhFkvNFkKjaUU1tzrAyHyVZlgY82+Qcn5fkd7/V3iSJiUA251cT2awt6OYBDp3UIqEga96akCQ39AvLkCXOtplMgwxi6HZpzOrfDNVx1aZbXvNPndSwzw13jLlULAWeMy5luQ5i7y+xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From the next time, please don't post a new version of a patch as a reply to
> the previous version.  Post a new version as a new thread, with changelogs [1]
> including links to previous revisions.
>
> Also, give others sufficient time, say, one day, to add comments before posting
> a new version.  If someone publicly asked questions to your patch, please
> answer the questions and keep the discussion in public until the discussion is
> clearly completed, before posting a new version.

Got it! Will keep it in mind for next time. Sorry about all the confusion! :)

> > The obsolete_target test spawns three sh processes and uses their pids
> > as DAMON monitoring targets.  These processes are never terminated or
> > waited on, so they are left running (or become zombies) as orphaned
> > children after the test program exits.
> >
> > Terminate each process and communicate() with it after the targets are
> > no longer needed, so it exits and gets reaped instead of being leaked.
>
> Makes sense to me.  Thank you for this patch.

Ofc, happy to contribute!

> >
> > Signed-off-by: Hari Mishal <harimishal1@gmail.com>
>
> Reviewed-by: SJ Park <sj@kernel.org>
>
> > ---
> > v2: Terminate each sh process directly instead of giving it its own
> >     stdin pipe to close, dropping the stdin=PIPE changes and shrinking
> >     the diff.
>
> When you add changelog, please add links to the previous revisions.
>
> Finally, please use mm-new [2] as the baseline of DAMON patches from the next
> time.
>
> This patch is applied to damon/next [2] tree.  If this patch is not added to
> mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
> to pick this.  So, no action from your side is needed for now.  If it seems I
> also forgot doing that or you cannot wait for my action, please feel free to
> directly ask that to Andrew.
>

I'm quite happy to wait! Thanks for your clarity.

> We (mm community) now want to focus on making mm.git more stabilized and
> therefore ready for the next merge window, rather than adding more changes that
> are not really urgent.  I agree and want to help [1] that.  For the reason,
> unless Andre pick this first, I will request adding this to mm.git only after
> next -rc1 release.  Let me know if you think this is really urgent.
>
> [1] https://lore.kernel.org/20260722133829.87607-1-sj@kernel.org

Definitely don't think it's an urgent change. Anyone who is using a
tool like damon would be able to debug this quite easily.
Thanks for clarity, again.

Accidentally dropped reply all AGAIN, sorry about this. Resending to
make sure everything is public again.
Cheers,
Hari

