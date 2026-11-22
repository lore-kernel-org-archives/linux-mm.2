Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B03606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A3mSp33Y
Received: by kanga.kvack.org (Postfix)
	id E075D6B05B7; Sun, 22 Nov 2026 10:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7346B05B8; Sun, 22 Nov 2026 10:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FA56B05B9; Sun, 22 Nov 2026 10:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A434B6B05B7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:43:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38143A818D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:43:36 +0000 (UTC)
X-FDA: 85463174832.23.55FEF54
Received: from mail-oi2-f8.google.com (mail-oi2-f8.google.com [74.125.231.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DCFE1C0009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:43:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A3mSp33Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.200 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795362214;
	b=PjvAR5beQdDeRlizDUUJ5MfK6OE+7Q48prIMe14A6Hdw7iC6WdSg4wu6DFfsE64efCBKva
	du/Mmgv4gIfgXZfkxSLo2540uDFasempvfRw8CHcuRP/01mSd0yEPzUhQQAE6KhUmfs/X1
	TvMvlruuKx2sCpwkbfm9W/H/bKoT/U8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fK2KNecjm4gsbzz96uBojyVhl02omCTQXBqS1mJ9XuA=;
	b=SHqO39ex8dwJvf6s+CRYml5mk+C3WioDpDxbgBiaoAbE7qpMHZ7d65hJMx9KN9wa8QJsOg
	L/n3juE8Iwd3qe7CCojei1piehqHfF+RsZzbOdDAdQ5xK7l8e53OVQVxmMl7ohopW4gPkD
	fb3pURJOXHoEC/edl0k1MatccLp1g0s=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A3mSp33Y;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.231.200 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-oi2-f8.google.com with SMTP id 5614622812f47-51cddc2451aso733719b6e.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:43:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795362213; cv=none;
        d=google.com; s=arc-20260327;
        b=CjqYjtxJ4y+cVFU29+OhW0cH88kjOfRzGimt8oY0RtDjVICcg+DJItEpvW1krCA314
         yi6HtVyw5J538RbPMILCFEJCOOQQRgbwfbbfWBRrbuK4yEshUl4CiaQbQMBY4rMjMnLx
         U42lpje+0IjpUxLpYtXWnhy0cDiUwG2FymwZNuVvtBkJ/Icy8qsklsUgwy8uytBYuTM1
         Vb651akLUXh0xYeAOmIKv/rI/vzAF9R7pbKIYUU7q9rOTkTGXVuFMEMPUMz2vvq2BqXP
         O1QbbTXizhzCKf9sy/rXcSJxWrLezfChnrlSgof6UFyy0Pq8kiz31XXVEcPGIWTWn8eP
         noIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fK2KNecjm4gsbzz96uBojyVhl02omCTQXBqS1mJ9XuA=;
        fh=W6gxgZ0qkToNqtnO/6LhLVja4NTTHAfVbUgxqFuq1fg=;
        b=pz7jZKbh/SBuTyxkN9kEwZeJgiLIDEuShnXOIXEbX33N9piHfJvlZMnzXmBFbYLAZo
         2Uv8RDN+MRq/1haDBurhU/k5mbGlLmJiPdObx98awHcr6W2SuLs2VXe5rZ+Q+MJ+MdaZ
         nymgxBK75xrcFH8oIOwxU+vRwyXusQZm/3kICoICghCUh2d7Ls9ytlv0Wsoexo9mDCyi
         lEQ9t1zqEaGs+/LgT1TMHNqNF7DqBtzI30Llv/LN4afl19fQNSwCl/RL5TlvE1EIJCiT
         42TW1/53aOTCs7g/YwtR2e+kYV6J4n+qMyo4Co8yBYkiBmqkRbjJO/XAObBKO+kNkSyc
         Y9TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795362213; x=1795967013; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fK2KNecjm4gsbzz96uBojyVhl02omCTQXBqS1mJ9XuA=;
        b=A3mSp33Y2lklv8xF94riBoK7VCxcKEYSQnteQ0X9ODjO0Dad2yAG4i62JRrRnAjszR
         ii/RGeovyQ+6S/iMWnbKFY7yKtPENY5EgZ+1LdmRlwNNRk9vud67NOWbNSa7/OPCQnN+
         7Kj3WmlQcNjpWN8RwRlDi7kJH9wTsR9YM0AhQQYAXxwZ4pPE+0E4gzfImINVxHnXjIrD
         Jk8vQhEmAdBqnxQHDEqMR5fr2upiv3rEkMG8zHkWRih0JqfaarOaZ+a4akv5VrGheqTA
         g0vFRaLq97rsJzRNEGu4VwHHGg8hLN6/LDoWcwmKtCbiUQDHSDSrcU6b78KdUOtGBCvZ
         KXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362213; x=1795967013;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fK2KNecjm4gsbzz96uBojyVhl02omCTQXBqS1mJ9XuA=;
        b=QtHSTnH0jxAZIn8KHop7ZLpMaIzB9/8Xrwkb0kULH3oTqWCybfXXKID0QCqtnEoLzk
         ZvoF/FfGAHD8oy9vITxEkOZVtiVGeZwEgnMOnpRmdoWmT8MrTSjGAYM+FmxpHqL6vnwg
         3IYmzDXMJOjU59mpd+P/vfhVm7PM3GSFYV/CVMBd7ochpBRy6XtbVA7x14fiVBgh5vXc
         8ChANO3+yX9kfB5nkIZt+9jm7t4k2oHJUDKEzK6XFw1cDe6UaX/qk56LY+Z1TE/+mMFs
         lha62O2LwfsEJK2Xm0tM6qrxoAH/cQpsRa80N+i3U/DKisg/pKErb+8BHX4dMvathZfO
         NdoQ==
X-Forwarded-Encrypted: i=1; AL+hErHyZxJk2tttWUDvtHX73vaSWwVwIS6HzMWqkKGalC4xekpfKx+6pbhN/t3Ku5hx7RAU7d9zsm/Scg==@kvack.org
X-Gm-Message-State: APuU4Z+aod2qbTJLRCRxjmNDvqqnOeiWbmM0Iv4Zch/4tHrFM4lG4DEY
	rijPXrAnofcAXnTJ3kJm3+YPg1kSJXFz68C8LkkdG9ep39TwmBNMYKR/20SKxx1GAIPWdx7P1PI
	G+Fn4M1Vo/oYofHp024ud0Hs9kOGu3S0=
X-Gm-Gg: AZFdTZcdN77CZeGtiDi5iK/7p5BgzbE5LWLNhJLi8tNZYioBPCkR8UBzdy6INybzp/e
	eTSoTcgfGXMlwkH1v2AFdD8OLVxqKbuCY7CzRpVu+jmD7RHS2fVWemtTC47K1difPdinbPfAcjy
	LcxyJwmvrp/FAUpYAMls4seWvqCdvwOOk2UjMjyoCm7/XaqIoCfSc1v9tXufb7AyDP1hzmRZYfS
	m2/eUnWdnpLFTE0k56gKsBdqq2mAP/vx4JJ8fEHaHjUn8t2Cy8vOhZFHZVqlhTCc0gLp6Y4zXfB
	nfgEsEJYHUdmL46/s3+1kpvLzjS8t4tbwtwQ3Y9W8FAxpn8DxrqE1bCyT1kAO/CN+5XSgUaYBcF
	Bixvvnad2Q7XrXUFXBpulcyO3EJFehLPXcc5BGbryUyOgXJpkpz2Fo6WqryR4x/kmRIRg39BvMo
	pHC1sI+XdNaVQW3796rvnW721pPyDN
X-Received: by 2002:a05:6808:6615:b0:55c:844:9904 with SMTP id
 5614622812f47-57a0950377amr9553693b6e.17.1795362212940; Sun, 22 Nov 2026
 07:43:32 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-3-sj@kernel.org>
In-Reply-To: <20261121210013.130397-3-sj@kernel.org>
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 02:43:18 +1100
X-Gm-Features: Aa3M54r_iVP4bVZcK2JPCcha3mQ_iDkHO1_5j6gGvQxgZFzDQ8kSC8cPoPNvnOk
Message-ID: <CANOyQmE9kM_WgOneXhQ29HTFDLYJwdzWjVKj4e11ESTtT7K2Rg@mail.gmail.com>
Subject: Re: [PATCH 02/27] mm/damon/core: implement data attribute report queue
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6auw1dwuux8j7s79g3s1foutws51ymcf
X-Rspamd-Queue-Id: 3DCFE1C0009
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795362213-172328
X-HE-Meta: U2FsdGVkX1/0pNAUSLKxWY0ydr0hKo8HxsgtuYMlsIrvh3Ph/C84BVEciKuGEXeLkmz4SL/tM/nZN9bt6tPQj8b3c1jeC6J58Aa2Rz4dS2+gsV+a5IAHao5lk1p15I73n1fMfbmLPeT4CABDVojTwCrPHh4IcZfBW6dU8r60cOvVSgXMq1HrNY3bFaQSrCVJCMn8v94Nw7YNcpVoKZEGgOIA7Xs8w/mt+sOHxc4RyO34WdyxbMkWptJUXl+jk+psa9Gj8QW98sd02zMmQa0pKorp+d1xQ6D42BtJAk00NoXGdvzOM8HzPX+brtmYHYwCsVcq3o/j0bbB182+HqHjC1DlzIFvYJu3fcUgYIq4ZK+TVgjlfoXvQo1nymQ4Qp6cccgyjQ0GzUxicpl/DTCqpraPRTtkd8mH9CGEObPgceDHfyop8KuXsMlls1Wyh95q3GJvSlNQ6grn4r8TeCvbcgKxkscb7ZVS+jQYUzlEaAyutvdSxytqx6/DIhlYHUDjluzumi22anXPXp7j02n5xSDcmtmCbADlOyecPKKskqi6RqzWuSOOnA1cqy2R3wLgNwSBlsG1vaVCXuKFE33+dfGAranXV26aEN9w6JIl9zWt6lJ/M18QWXbdgO2GbP5Btf6okuUxZoNIszLNvITzeMjCGYpBSPQYHTyEJHJ62OiMxJTaxTqhUt9U3FmS4SwSIyAAfmBTA0Xgra3psjhTGJdcazmE76o8U+tz7sfcClvDq0VGKvdvTtTTYsxdeil+Xg5M/ugFyhrd6Uwd1AZxqCoIbTH8AxeUwkbhtU4NfH4HdoPHeEOl/q5ClxktnCPp1mBMFAr9EQhFN6uUgFQ/6vwdamJEHWpuvSIjjl5yFddyLU2pPxwIGNff/Y0bP4X4lMFJYZoQZzQB4WB/Nlnrq8NEA7bHMzJYEj5I+OdfUF7Bvtns1/wAkFFtrt/jHgpFjIzGRIXxsWBwxBcJZhR
 YSuJyEtl
 xxyfKBEacbt5em3n6deElpfJFpDyhhSoh7ekPjBNkhk7VGHt2JsGxXtYKoziQuS/cCWeuGpmlzNE62BKPfoQSA8kSiP2733X2A3Y6DCjobTXpa57NG0tMZUzlqucEALs9tXb6T48AuFbW2kAtw+21uYIOCyfcXmtNyMw1t/JBagX4B96DBfbk2R8UWQKiCSPSUAjyMrxVAvSZXYL09sPQhmV30XIcuQCoViC+52to34jGFi15pxD7JcsdNvYMpQ14yMSK72q35iHYROv2yLCOoDXLHa7o0dbm/f/+JIh56Gi0qpahYAxZPBS9CMg9actEhFG1NTwWyze/wDv+Lkw9OXjODhn02zq1ZA8z0pb6f6MoIEFDS3+Uj5fFxv2H1FhOSjdTQJiGeJAIwCDPHZg/Wp7/dQZnu0duoY4Val16uQXa++puXWpsQSQ1Bq9MScerCDFYtP3c1R5IuV0nzsHhBt5jrloFN6ABsXjjxh/IKH6NwAnHU+4O66aSaLGJ8hx17IJPXhvdEaqkFF31fahtTHJc4WjAsjlx0IrWqjKuFjzyrjMi8IafaiColfXGQdQ9ihO1cFz5OLAGbsrksmp2yVouxR2Z4y5xGcci7AWPpJmA2IHI8vwOuwhFOpTJ8U5I1gNQekgT1+T3EIRf10GiZFwE1m3UBnbLbBN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sun, Nov 22, 2026 at 8:00=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
>
> Implement DAMON core internal data structure for queuing received
> data attribute reports.  Initialize the queue for up to 1,000 reports,
> inside the DAMON init routine.  Destroy damon_region_cache and reset the
> pointer for the queue setup failures.
>

Looks good to me.

BTW, while reviewing this, I noticed a pre-existing issue in DAMON
sysfs. If the core fails to initialize, sysfs still registers the
interface, and trying to start monitoring with an initial region can
hit a NULL pointer dereference.Maybe I'll send a separate patch
to fix it.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

