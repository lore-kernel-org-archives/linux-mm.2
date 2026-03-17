Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D50EF3383D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE3C6B008A; Tue, 17 Mar 2026 10:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F596B008C; Tue, 17 Mar 2026 10:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5DDA6B0092; Tue, 17 Mar 2026 10:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF4D66B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:38:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 631F28983C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:38:59 +0000 (UTC)
X-FDA: 84555811998.12.FD51A53
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62907140013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:38:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jty2Jf6P;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCK8d1JfjlDupwEtZNM10gNgosd8pfL/mu/lil2s/pw=;
	b=jByrmtp6uDQeWDU8OFmPRiv19U2cNUXpehPkyDakaU/TNEq0EQBaiZUY+zgMH0rKGFXjcx
	E5Q4QudR6kMLdAaT3haD5YOCGjQJzOCwfsE6vKkETHlSep4z5XGhQlvRej9AzfREPPr7gV
	gQVMiVztlalTwgWp7MUf9CB34ekiLHU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Jty2Jf6P;
	spf=pass (imf26.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773758337; a=rsa-sha256;
	cv=pass;
	b=GjU522wzbUbCp92FrUHq5Kecx2k6Nj+1I7aCjMs1qZjl0ym/3Hhn3XGpB+8p6ey2ApXzd+
	NvM+wWy9FbDG5kdcw7dq/Ju3ysnA3Z2XmbzjjACsgO6SCu8iemtn2MqICVsR0TSn6MYtw3
	Q0lSJoVloAq5rrbSoey/FlxkcpU0hnQ=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64ad8435f46so6203725d50.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:38:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773758336; cv=none;
        d=google.com; s=arc-20240605;
        b=VUqaY3rX+vb3fLvq0pG+mJBjXqPZRkrRw1XZ+OtW8Z/aqb9gt/hHpAlaMvFiVdCO0C
         gXF76ZXsqhmT5HQxoP1aBFH4FgAiEJvE3RryF1BIKA8eqzpItPCO9uhI3E2FRIfGwMxj
         VK02UyuCOfCShVo6Hz3hFvRMyhzangUpjE80P8dTL/8X6avFlWH15bEqcnXJtr5BoRCQ
         MLDtMiOXJnl2KMouTH+KGTzZyv78c2zwXYo2lJnKmWVricAgtMpBzGFNS2U+MZDnNWX1
         yajhgWBu7Q2sYt+obMQ2DQ/Vg9VZIGbXkUz/tx8I6FQ6MEr5nf5E/W1cjbUaSxDYnpCC
         u1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZCK8d1JfjlDupwEtZNM10gNgosd8pfL/mu/lil2s/pw=;
        fh=3iB2U8oIKRe2xLG4MJr5/ysp1TvNYyS44rnkLkE1tUI=;
        b=XeiSYhMxu6LisAoqYCN93eeYsUvCjBHctd4GFYh7EcOO1tw3AA7AXujLqTynfI2FsU
         bP5OrZIh3ldLuFjqfZp7WJ8z7STs1FTt7aRnrVowZzqU5SHXK2pvavjDcVxge+KmRiGj
         O2coDlT8pkNcdYWJG/nSvSQ361hiOMOT4rDkBEWdVgRm1NgiNmHIDp6POYl0eJiAvx9N
         4Uyv22cTMOKWjCIIGDYXtpAyzQR+SpprZc7f1f6kma57vdEiNH8sgvomrjnJ1fwvrctv
         /vKyJ10bliM9OifZYCT/nFzXMROL8IFa9HX56OIM6Jq8o2tbcENIjF1nP33tS0JKsprs
         oM6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773758336; x=1774363136; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCK8d1JfjlDupwEtZNM10gNgosd8pfL/mu/lil2s/pw=;
        b=Jty2Jf6PitQKvFtrIBFPw0bSVv8Q56gkZsdla9ze6274Ij414whbLx7Hx6MaD8NPSb
         6I2jisknY2e0t7rM9FFG0n3H8NKSpZizNUdcee/XrzcCRMtIVQBwt1uh+T7f2aTTEK6U
         yN+wydNhLyZlyuPpmfrjHhpJGNJOQyDjTTNd1u6U7jHROoommFAPwhCiB63KkiZ8xH2/
         ryp4nlnCbyvzseHraqyg2nmVGC6yUSXPVSjWBO8f9ffS1X0fC44jAtNJ7rB+WKY4m4S2
         iZL8LjIeiN/r+nApWDWipkt1eBtlYEwLrHfGS67TaRPSxO/rHmrglT8DHrqpRkXPriu7
         yBVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773758336; x=1774363136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZCK8d1JfjlDupwEtZNM10gNgosd8pfL/mu/lil2s/pw=;
        b=Yq8uyt03PHJG1FsVjmtgXL78frSYaQFQaZQ/BKmp9zSsnuuF9y5UjbLb7+rCD39Zot
         v5rtRD1HZ9pEu2De1hdEcDo/SFSwxJ+LCpJn9FGUPRjr1Ppsn8j2Yiy3Leh3ouuPKhTW
         tRg/lxJlb/+G4tByGJyISB7CgpXxAd/n2raRTwvwvmjDryf3HeivKa2kVZPO/tbnuXW7
         LvW7gzgJHPSvJil133PP06X19NbGpgSUp/DHrTH0FLv5fEOjy/L9ow4wAfvwirwt6O5m
         ENXOPXzSkIKTgsUv5UE3pfyjbX88EJjmNH62k5F/FGKWLDon1RvtxGytSn1puPogZ7zC
         IUVg==
X-Forwarded-Encrypted: i=1; AJvYcCUuRc8JG3pYJnVvyhTXvh366j2n3ZVRbz8ejqqZWXO9NdephuqAIGswAUY62MBwjpDwZlGUd3t0pA==@kvack.org
X-Gm-Message-State: AOJu0Yx3c3kXXHw7EyR+81a76nXuI5llqI/u4fVSn1KD6xDQpYGrLyqR
	vGEW90f35KzPSp40nf+9T+ZAfhaQSL1Yb97B892821M5fZ6NY4dI7WN/I4sxHx0qJxqqXsiqr+1
	NEb1WETKzKoLY0WJv7hioBUu+6a4XfVg=
X-Gm-Gg: ATEYQzxkBwPaJ32tYyFkdskVKhQjXFOtJwnSuOU3+Fej1F6g9Av1eeHZPF1NmZV/RYf
	LcU2/aPj2BTc/UbTq5pQ3In/uPds8ZhgwTCCujKXnWaLYd8QR665Yv1dbJHQludNlRwYN5wFQoi
	c2GQqgRJKwCNlTxo5zQznDd6cwRVN496DYjWQbN6NclvTvNn0+OiHG+CjK+cZ7HJSA83GY3Cktw
	6E5wGjwlelBgeWCJaWe94QrpDTZiENvLGF2YPknp4isbLjpz/jVPaPpjdllKkZM3+c+CkG4seOq
	dSiM6t3TMYewhXsXGh2HGZ+2RnRvC7cDjUFYyGiMRcy3DJPE/B8+zh1XBPJjwcvbNaD9DZeJ
X-Received: by 2002:a53:ee68:0:b0:64a:d6eb:6e with SMTP id 956f58d0204a3-64e6310e52bmr13169034d50.80.1773758336241;
 Tue, 17 Mar 2026 07:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260316151956.563558-1-kartikey406@gmail.com> <abld-ilvMEZ7VgMw@redhat.com>
In-Reply-To: <abld-ilvMEZ7VgMw@redhat.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 17 Mar 2026 20:08:44 +0530
X-Gm-Features: AaiRm52NZLh2X_VTuxcK4EwzGSrL0Dh9qff93nA1P79so-bjnoyTbLsWb3ODk-8
Message-ID: <CADhLXY6NnOcScf6kC84Tf64=RL7Sfi+ntunz8B42Wm6iLVCivQ@mail.gmail.com>
Subject: Re: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal() checks
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 62907140013
X-Rspamd-Server: rspam08
X-Stat-Signature: i7gxo1bajtmhqf97qt6hctdxgu5a3opf
X-HE-Tag: 1773758337-759741
X-HE-Meta: U2FsdGVkX1+OtZ0FutwXRB3oMs6jO80eBEM7rq7TJcr6Su2N98mEwUTLf2GvIgwepzhYF/kkQd+cVmGbzIre+BASGWx55Cmf4sMaDj2vQGElbguSTz0AxXX8wDTrwnp4IgEcZKB3kX3Fz8KoUQPEURSDb8FmXZfdiBjmyiDz3pb5HORonbLnoyW0IDfD7KNow1s1uWN6PrxTZzbRffduUKgYldzFg+FWcESJ2TuLP8LSwQhSh24njoNYQutBJmnVvkNLTMLDnuIEZSKklGeFlPxeMO+57SdBCWFWYvnHQcjEeijju7udqBmr1xIyI5XbbWO1lG3F9w4H6AVQ9kGzAdzRxciRHzCgz3T8vVVLVLf62UtcOmU9DbbHZfwokY1pIwvAW/MeotgIw8QjrdNO/cGWVlqwGolDMGPzi5BkY/fPqYK6bQlBwzhKqex3i2/GPVM56bvcOFKsR61ImeDfRfEF01flMX/GGwFkmVw0/YpetbUQHAQJVMcz/CSQWhZKloDsmTmKaVw9BpViBcbwgcTBNcvyt1VCjuSdgnQXyR5JRscz38rdQVIIV/pi3iFme9nq5ww0XwyswLOumlidS6ndeQ9/mVP/rLk7BjDZckJ8cOstrIx2AqfKJa90zNVzJmiilybuAjLc+ZWlVUBvQAHOmWf2J/G3eHRNzxYmPsRg45hwXSRKpxpEeF1hGMlFeE9qA3U7mbUWxqQYwzyCC+J65G184+WefJNMLldWKfIPFOCNqgAj6bu5Li5k9QvZ5DuS9Y0t0E79HeLYLO4qymraN7eBRsZqKltyV8Lm3waoXWgV9+f8qHMAaP1elRjD84rkI5wiTL/w3p6485liN14L2szmcDatwNEDngS6FF/PBkZS/wsUKmJR5EbV/sGlSEYkJkp526+pEXwpvfHv+t7i5I4gwTvE7wAyK3LqAmHEG9gf/Rz52trTJd6QlKlT8IgII6t6SEDbTjeS8yg
 0SPPppEt
 n+Fmo8n75xV3oQ90dgXRk+AXcX74BtgSyCP8TbKyTdo8G2Cf9QSfOeP8CU4eHjgmWHI9u3Fz+VVTO4LZ3fuDLOe6SYPEqHFOQS55Z2+7sF+SJNeNddfkSMm4M0jpWkbDCabPFW5jsBCRMyGtfep5o/LrgJ1LgdWPoW/S4uJGCsu0OicU37sPDJNYONdxOlO5VPgMqqgoOAEII8uKuTiz5ANYmJgFf48dtY2b6ND8ONYq5CP3TGOjM87yNtxtOFalV5WeQBerpMrPHOxAtmmewlyjnwXISJ48e7+w8wT/xgE7dkMLnZ8BAWMbh+U18MvlqycjSsJk9nMTdjpanxRHRD7oKn7Em1Ldlv9QX8IB2Kb04gFpF+dw+zDgDkSwazJq762BQUJTDsd+BssAmvXEMSbqyPD35QWMnjt8ggW0lFiTigJ7Q1xVhRDIHMGsieFWxoUjDHNElWYGiLR9m0Z+R0ua0buojpppExA8st8GnOMZA/qYy+kkOHVXQ8TWGRFI8zvkv7KXzqwyouUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 7:28=E2=80=AFPM Oleg Nesterov <oleg@redhat.com> wro=
te:
>
> Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
> argument of do_notify_parent() must always be valid or we have a bug.
>
> However, do_notify_parent() only checks that sig !=3D -1 at the start, th=
en
> it does another valid_signal() check before __send_signal_locked().
>
> This is confusing. Change do_notify_parent() to WARN and return early if
> valid_signal(sig) is false.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/signal.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 86aad7badb9a..683ef92f7234 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2171,7 +2171,8 @@ bool do_notify_parent(struct task_struct *tsk, int =
sig)
>         bool autoreap =3D false;
>         u64 utime, stime;
>
> -       WARN_ON_ONCE(sig =3D=3D -1);
> +       if (WARN_ON_ONCE(!valid_signal(sig)))
> +               return false;
>
>         /* do_notify_parent_cldstop should have been called instead.  */
>         WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
> @@ -2252,7 +2253,7 @@ bool do_notify_parent(struct task_struct *tsk, int =
sig)
>          * Send with __send_signal as si_pid and si_uid are in the
>          * parent's namespaces.
>          */
> -       if (valid_signal(sig) && sig)
> +       if (sig)
>                 __send_signal_locked(sig, &info, tsk->parent, PIDTYPE_TGI=
D, false);
>         __wake_up_parent(tsk, tsk->parent);
>         spin_unlock_irqrestore(&psig->siglock, flags);
> --
> 2.52.0
>
>


Acked-by: Deepanshu Kartikey <Kartikey406@gmail.com>

