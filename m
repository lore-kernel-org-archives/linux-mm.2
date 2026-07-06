Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5127FC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450976B00C9; Mon,  6 Jul 2026 10:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401486B00CD; Mon,  6 Jul 2026 10:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317416B00DC; Mon,  6 Jul 2026 10:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 091C66B00C9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:13:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CCBC168B59
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:13:57 +0000 (UTC)
X-FDA: 84958545714.08.8BA98CB
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9538AC0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:13:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GYcMZG+W;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=is9HVNRQZtO1NsqI/qhXurl7Mb6p1rD9Hcahyv0lRxc=;
	b=QMyvFxXkUCq6miwv7XVW7/YgTXQn2LYTQfBqkuBbeM5WOBfyzJ2xu/hmyLTPOuhtrSYzlw
	Z+8sFO6NDETw7Z5QsMt+OPLhjNPLvWGJPEX9OAN2pljPMCL6iJEaHtYrHwu+rjiN04v/N/
	j6DIJYpB2miAv9MFibX7A6FTDOFY92M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783347235;
	b=jEBJHhDcV0hfYfCyUlBvA+n3fiaf5VojXT5tbgedlVL+tjeUOzMiIYBk3UPqQGKLLNpx8N
	d9Q6kyMrZFWLit0Id0/sQrTRDFQktHM8VlYcfXAKz6/KYGTc0CDABdgJGhhUpg+panGBJ0
	8gqk4KeDiMxNK0KY/41CgHguU9mT8aM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GYcMZG+W;
	spf=pass (imf22.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4758b2a9e2aso1903621f8f.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 07:13:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783347234; cv=none;
        d=google.com; s=arc-20260327;
        b=mQJSlrFahalu4PjmD2g7xNb+nrGMk0X/xLbQ9bArgFziDGC3OnJEq8Jz28Himq1QZT
         /T34Cb6rKt5nFgOGMOeWWl2BwaRsXW11uNZBz34IAznQDwXQt6DoBPIIqD+OcenjuWkd
         GAHpLcKqfPZ7bNU1dlC73DRyZh5TPrt5e2mFYF/8SVgM6jm99xNFKW0GQKD2+d0ehBdw
         jxR+D2xYhR5sAT5Btj4AAfCDw+4gqKJO9gE2fFxgV5WQf0QG/eBSCNilObCDhKUDwz2d
         CpEE4gRXfbekwN51aLe97PC3eUlLOdbuN7ZIS1rMVWcdR6IHfCUtdLAc+sAJgBsTRYqd
         G6rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=is9HVNRQZtO1NsqI/qhXurl7Mb6p1rD9Hcahyv0lRxc=;
        fh=VoA0S6IylaFqisrMpy3/ISU7TxwKDjQCrYyK6kwLmZw=;
        b=XDvxYwpVOUQODMORN6Abre6nhb35mO3HoyrQy+F2yN3Gx0d9o5pg9Jex6h7K9CWIPh
         kgET5bQG0p/3ej82ZfGu5dT8N98YlRBohBwx7GkUhYrMHlc9ZZcqvvRdpW76QrTykFuj
         dZwqufCgksnxL73FSbav6akEJNl3gi9aMyhpJQG6GOzpIW8gQ+3DBaYkpUFhQOWNLTpT
         zDFvAxTwjCo1iXh5wYVjkkwug5pQHeesWuVuw7hPqGV3DILAurcCdovID64ahXdjoAuY
         zPADdkmVjqTBJ6HniJnuZLGtAOF5RkX4uYUZQcbwaEGPyojPzNUvvP0ISV7BbXjECnsW
         OJ1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783347234; x=1783952034; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=is9HVNRQZtO1NsqI/qhXurl7Mb6p1rD9Hcahyv0lRxc=;
        b=GYcMZG+WOCB2YuW6E31I7HGKFeR+1XxauaStWBc3U7I9obF0vsGeWUHkz512v4OB5x
         z2trzu1/sOrQg3g80LCywjpGg6WOhxc87w/6WGJJTL9Og1srxMCVTU2rQJAju5MXbwgS
         nFmG2P4KOeuijBW2PvUjmxHcI2pKcmqr6jE1dLhBywhXMqMSpOPm0uX/RU9Rw9cs70gl
         pEBO2U1BghEJsonIV5O9q1jOtlLZgc8+a7yernj0JAmDTqTfqrqGFBx8CxBcvDvVTmi/
         AMU+fXPgho0wIkjgjBNclz62wrVjEvW0qSyCM8rH2kZBvasf79toZ/cnyOvkkhxHhxOH
         tXlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783347234; x=1783952034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=is9HVNRQZtO1NsqI/qhXurl7Mb6p1rD9Hcahyv0lRxc=;
        b=BSMO0bXvFpCImRUjPuih4p9OZN3M6kL1hE22kMh9fjtPU9/K1Bj82yeCo3szzpiEnt
         qvWIxwZ/PkAbO1FAaAoR/8iDy/1BMKqc7eZmZDfj9WghPwpkoT53srdRnUb6760YnRJp
         hJOXMTJ78QfsFrTLsbnlG3vrsdClFFPLP+88TLB5bvLephBgeb0h8aqfOowd5zjtjcb8
         dUaghPdU6/3ZS86OLwn8pH9bxBJGSGlN5WYHMYMSfRybWId9WskFV2PlOeaPLdwHL/oz
         0YTWVOfAVn4gf8shZqFpwmFelPM9O3RzlXoaWq6egYmjFPGJ9dzMl6KCsotRzHJiywQ5
         lEGQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGVvPW3WA8buYFbxd6+pZ2NrAIZR3J8WmUI5tZHCeUuEy9hltAyhFbFfK+XjSB+5qTEOISlnw6RQ==@kvack.org
X-Gm-Message-State: AOJu0Ywc7P7QAuj1oP5/L0PIoNFqyd8Qs5xgyPdFfyFFeul4AN5eEOnp
	BzgIryVNQ5uFaTUhS88upmCkpVfOU6mvoFz55QsX2+AoY9FDIqYncd7i5g5zsLRYI7SjntTQ6yE
	wcngZFsf1z8QLlmNcMMxpjGwedKSigtY=
X-Gm-Gg: AfdE7ckAAWL2E+h3cgXoO/M3teEO7r6+hx/Q3F4yB4kO+cid4re9zRtjlrmQ9Ryws5D
	fPkYX4XnkPY27O2Ma59F2+1J+4wf47l5Dezr9k1q1scrZETrlA4ni7+m3t9kNgKRuhG32SkkI7D
	5UyrUlNWlYytWn9RUoY3zkIJnZzvsd5DRyFhS8zXvJ1uDO7txa4nihYWHIpPrMUkht69mN/mSW+
	rfc6vubQzY/N3kFxDeEModOR0WTDKZYf/0Fmp44FX/NtDPtAF3RMbtHWCtlc+5zevNMjHPcAy//
	AfmuTrLcr+01zXklmROFyueWBmXKn8A=
X-Received: by 2002:a5d:6845:0:b0:472:9bf7:2f58 with SMTP id
 ffacd0b85a97d-47de66c3e2bmr335360f8f.36.1783347234124; Mon, 06 Jul 2026
 07:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260704092007.3483-1-igorpetindev@gmail.com> <20260704092007.3483-3-igorpetindev@gmail.com>
In-Reply-To: <20260704092007.3483-3-igorpetindev@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 6 Jul 2026 16:13:42 +0200
X-Gm-Features: AVVi8CdI6VAiNsIgWHaF26_ieG53mvsQ9Axeo2Pa2H8OoGqEhq9WkemekVMxkeI
Message-ID: <CA+fCnZe_R7fc2ja1sBN75FSJfrpRPYLi7Zd6cgv5nciFaiw52A@mail.gmail.com>
Subject: Re: [PATCH 2/3] kasan: common: use ALIGN_DOWN macro for stack alignment
To: Igor Putko <igorpetindev@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9538AC0005
X-Stat-Signature: 3isfosi1bmfsejk49dmjyy65i5dzusix
X-HE-Tag: 1783347235-477798
X-HE-Meta: U2FsdGVkX1+dYhJfyq7vojOl6sOdz1tCtb1nkD8/vDTrIi/m5PJktSeS8iXe0b91JTBX1GPloIQhbwGqq2h17/rgk7QL8VceQNCQXt1Sf0T5kFlfmXl+h/PuTFsGfMbLFbg/95FXRZNnSH/FhyMY3lWcOFLlTyMUm3QGG9Se2ACLnn9cl0x3mYHyFg4xy+l9YjrXmYdl8SttL1OlBipUvusP11vJFUKPEsh+peZsPEqp7O0Y1r10zdJEFzFf4FBmd9ycMv/I8w0/rW50xbyRWtQawm2pZWHlQrl8pyay+otnSrizCPPGwbp9y38HJcuFrA6lNkcTb/wce3fe6iw3RUqsAvTB/G7UDh89InyaDpBdr3LMFfUnZV1IJtcApiL6zoKvrb2OjX8bFqMSpsZy9baqApS1dn9oaegG1SuySNB/OJBgW75Q23d+ORrD+VF+HSqCj9UJB6xOX0CWZtvQl6EjeJ7S15mLPrjOGZrJAvdwIoogAyUxAFElPfldg3kVFpQMCVFYBCX47qteRdHGw8papCPRfYzfn5B79/1FsmNM0/YBGkR6BUEayWPDFtxg7fWhOUqaBR1uYjqV0Om2U/bmpEgvKltFuT5aTLZ71tAd3smpQhSVnSoK7fbK2p02DZtff3L2tezuo3Dc97kbWhe+6+4hjgIOfUDPR91W5YgjwgxjNJh1StJaFSiYISivIB8QXVcGqOveel8+JfNa7Cl9UP3pCNmGo7wN6/9VhQ1kYbWKtFEeAeBSJ8+ksEOEzzmBXQN05xK1rSItO/j0wZV6FdFnFwnxxS/MQvW2dwFlodNmFfQMtscbL3Ue+tV6vFHpRD/6wwEdiWetvrzeqpwVqE5lRWYUpBE0JfZjReHpKiBwPFvOUn53dNulRpiVowedVorMhOBwnsZZbLRjniDmge3UQI9ieJhoCcKFlzhIiPOy40ZPcTX+jD8+U7hECiNWNPYpMwtqMg4RrJD
 WU9HURZw
 znrm5QrshRfNKszodQ8CKN33U5mEJ9PTID07CIb2+SWLQWvhx20IbiGowHluz5fFWuoezZNdqCb++qez4hL44hqI9VzS3Dl4FvipKvtskn6gnTnBCSmG17A3vkRJQB/c+L4Atd81+245Hzuwe8rSJeU86TJ6AxHFWLE5RRSLMvzZMnLvc75w96GasukZEV89/JlPU0N+wkF4YZCy5IL56GBk+q33Mk5OtwVLP4qvWoFpYWZ0ZdpLJ63UgTfdrgeVZuwxUt49HjPbBQgdTDBOfe5OG1SCMoa4aCwa0waB6yFJV+JGvBje/QPyxGfQ3/v6j/QzVvACxtaYfyMA+bvzQwQCjvGc3cI6JvYaLDWLwlLfjT3h1hOo/6s191Sb/g/Dd6fIkYV/V9c+jkHt4Wcs/qsUO4S8qs5eqQC2pHNw7CSjzCwC+Ylt5BNapXAq0H/2SuQcbjLfJkPupY5tPF0+HCXxiSzLdA6IY1oqxLdF1HcklXlzoDogcvW01Btfjc7kDYBX/cICg2GfoKny+tlQy/fReFPV64/nPpenF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 11:20=E2=80=AFAM Igor Putko <igorpetindev@gmail.com>=
 wrote:
>
> Replace the manual bitwise alignment logic in
> kasan_unpoison_task_stack_below() with the
> standard ALIGN_DOWN macro. This improves code
> readability and conforms to standard kernel idioms.
>
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>
> ---
>  mm/kasan/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 34aa0fdce..5faf73c8f 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -119,7 +119,7 @@ asmlinkage void kasan_unpoison_task_stack_below(const=
 void *watermark)
>          * because this function is called by early resume code which has=
n't
>          * yet set up the percpu register (%gs).
>          */
> -       void *base =3D (void *)((unsigned long)watermark & ~(THREAD_SIZE =
- 1));
> +       void *base =3D (void *)ALIGN_DOWN((unsigned long)watermark, THREA=
D_SIZE);
>
>         kasan_unpoison(base, watermark - base, false);
>  }
> --
> 2.47.3
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

