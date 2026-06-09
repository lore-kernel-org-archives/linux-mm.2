Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49ABACD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B223B6B00CD; Tue,  9 Jun 2026 17:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2366B00D2; Tue,  9 Jun 2026 17:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A4A6B00D3; Tue,  9 Jun 2026 17:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83E506B00CD
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:45:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27F06120751
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:30 +0000 (UTC)
X-FDA: 84861706020.20.52251B6
Received: from mx5.ucr.edu (mx.ucr.edu [138.23.62.67])
	by imf31.hostedemail.com (Postfix) with ESMTP id 663CE20002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ucr.edu header.s=selector3 header.b=lr5D4nyI;
	dkim=pass header.d=ucr.edu header.s=rmail header.b=gjUnCKDT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of ytan089@ucr.edu designates 138.23.62.67 as permitted sender) smtp.mailfrom=ytan089@ucr.edu;
	dmarc=pass (policy=quarantine) header.from=ucr.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781041527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cc2pubclTH5XFLkn1JbAg5pIqAsoToCze6/lWOdOZ14=;
	b=KMwjJoLcw1pjdXhi9vlMJiQdrwBNIYhvR6JkY5IPaIm6TC1qPd3DNyVa357XXLCDbg4xog
	TDzquuFIpnSk8e6WOm8fhnoL8QwdZfqajEuQRDaYLMSLuxyHQkQHdkBXwiS4gWUAGfMb5r
	amwbgusrgTwE6exI72y2jj+OIKhaR/Q=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=ucr.edu header.s=selector3 header.b=lr5D4nyI;
	dkim=pass header.d=ucr.edu header.s=rmail header.b=gjUnCKDT;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf31.hostedemail.com: domain of ytan089@ucr.edu designates 138.23.62.67 as permitted sender) smtp.mailfrom=ytan089@ucr.edu;
	dmarc=pass (policy=quarantine) header.from=ucr.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781041527;
	b=5AWW+ocTFRWnIyy3GZKHEkEO8lXOoni/767rxGss10LVOxEz47Aqd6HSywpovYFUPK5p7B
	DoMFbsBIhLKslyCuHoe20x1YWwigVJQ63C/KfdA3AtBMGEceqWBBAE8+0JKShnJ8y9XgDV
	e7Bj+ARXWbSo7S/LMox4RIs0mG17eXo=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1781041527; x=1812577527;
  h=arc-seal:arc-message-signature:
   arc-authentication-results:dkim-signature:
   x-google-dkim-signature:x-forwarded-encrypted:
   x-gm-message-state:x-gm-gg:mime-version:references:
   in-reply-to:from:date:x-gm-features:message-id:subject:to:
   cc:content-type:content-transfer-encoding:
   x-cse-connectionguid:x-cse-msgguid;
  bh=sg3v6ccMS3XaIU2NZ7UniX1AbZwcjXhCTJATNCR3JM8=;
  b=lr5D4nyIUBA5O83u8yFjn9SDtMenKrgxKQc8Rw2jcq5x6zhdQo+ch8Gx
   EEwrJPw989XET9gybvWse5PYrNlh90dLIAoFgnsEhD6/ib0khRRdQLbgI
   +zGnxLIHrUpoGcHfgzEWlG2Y6kNLnsvAekM/ikdmZBLiMZqlVQFL/jvMw
   0fhdylnMj3D8btUoBx5BuMJsXvkG4iH5X3Ng36O4Wj0Zzw0ib9kebfssB
   VN2nKmEeVzjOjXq25kCADfmQAAAlUe29LCmhJ9Re6t23400EMG7YtD6vP
   lVztiDYcPtU49wxa80kwrR79DVa/nnA4Le1gIt4U303mGlVVJ1tTWYCWG
   Q==;
X-CSE-ConnectionGUID: bkWWJctOQVmJBsUtC7VZYA==
X-CSE-MsgGUID: eDR6+VvVRHqd8CflyptTVw==
Received: from mail-lf1-f69.google.com ([209.85.167.69])
  by smtpmx5.ucr.edu with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 09 Jun 2026 14:45:25 -0700
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aa6dbdee74so3792523e87.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 14:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781041524; cv=none;
        d=google.com; s=arc-20240605;
        b=U9v7F2ZKWol0pHTnJQacCBeAA1VMi5am+uaYF2JF1lIhIlY+WTAeCKw28L/qrU2Kf0
         bRvT50/siNMKvHvnHl2x+Na7mawFFPT09Isq6uj3VSdwD3k3IStxrFVJ1e2zeqxa1Q9P
         wnA4ttHuIipVGssola4B0FqircTJ7qN4KxdBVjWeC8OlQgyIzTwHDEp+RWKy1a1Cf42Y
         5TKDjcAbOXVOEAjiL4jmliYXesk8zSrUKM3m521gIlOAdYXbD/9wVZM4yRHbD9QSE/tz
         2oQVhHM3Q0HTs1PZLVF7HsrmaKhWgMpaVWhZKq7EqOkjIHhHJOGKNjjJ1EoNA3Ww6xzZ
         hfKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cc2pubclTH5XFLkn1JbAg5pIqAsoToCze6/lWOdOZ14=;
        fh=Fn1vd5MUdn0wT9QZJly0t/ex0V5z4qGMRhvHQsGSLgY=;
        b=O/uKda2fr8TJo2JALv949vuTWKSYFaZVPBe1ayHcPT7mVYmFQ+M7qdCNhu5NTMZ1WX
         +ATrAq0fzA7/43wEkT3DlGpM++OF/SQcg3IbwqV+PH2AlL/OWngUPm7a/6rE9EbQtTdA
         j14/SWlC7okA3QzuxtjlKfd79sKZ3lfSO02ofjJrSacSnHcmH+vLAr5ScSak7wJ/nqvI
         nwgWt66CsYsgoGMNgM+vnF6abT1E4kYxmJyRdcLJMIR++OTMtDpyd8NrajDzAGDWcnq2
         jN8dPZossdF4fG0Qi2AUsybcD9ftm4YKVkrhMJMI7NTqXWxKqKqtTeRTKym+7XwsG1wZ
         Soyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ucr.edu; s=rmail; t=1781041524; x=1781646324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc2pubclTH5XFLkn1JbAg5pIqAsoToCze6/lWOdOZ14=;
        b=gjUnCKDTjY24iPj4+thFxQmNGPqJAcmVe2K6+UJZvKBO+u5Bz90Kxscec26VNTqAmi
         EhbOa8e4y6yuwsDsD0enDuThGIAvQOvZDD7wF97mWSMa2QqQrnnVNA+Tu6sIN/pmOtme
         aFKD1YKuh+XFXM0OM0/E5VHGd+tvcED/HpqhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781041524; x=1781646324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cc2pubclTH5XFLkn1JbAg5pIqAsoToCze6/lWOdOZ14=;
        b=myRytHEUv1Ns8XFGQv9r0hZvD8aeluDqsgLmwmlalUtdLrfWbXmAl89JEM6BSQGbfl
         saA0pbjxtJyEPT9PlxvX+ThXQLiVW9+KgDS7w8wiBGoBD4Hqi2rT3CNmDByg4UNXEw6c
         65Q8e0B4aHjWkD7yoWUdoTCrueRafG0a0ietw7+fkNfrTaNZFrgGhL0a31FUm5a+//mc
         XOtzVoVlyZtMLUQljG5t0X5gZxSjgkJ00uPEjNFbOjvmI/7r2gCuvI4qZNMwCEUenUaV
         rlGiDSxhjWWtGaEczTKT20l+Ep8PdExkQR1HpwsWB3fjJCK/oh9bWAX2Xx8nnuXu1rWB
         ykjw==
X-Forwarded-Encrypted: i=1; AFNElJ/W5jfBWu/o5qFM4ygoJswB/YNK9IziCWE3xzDnVUQNp5Dt/1POifwOCVEvxbJ00vvGrr46elmPlA==@kvack.org
X-Gm-Message-State: AOJu0Yy3cG5urSI2IhUCIvpIJa82P3qealBu0Vs6D+BUNeYHLRGRqPLP
	mLRYF8fCg3wzMiojk9KlFMLh3+5Pd5/UF2IaZMuHpBE4bMfrkAVspj89m7Xp/jWepZF7FvojXNI
	qpIXXoh98DT7we2u1tHNyteBn2fjjZXgHgSLEOVKTQL3Z3ykHfC5ZulZClm90WaiRg8txeqYmbX
	69f6DyOpIy/8eo5Il8L0h05cL8bGbJ
X-Gm-Gg: Acq92OFSQh4JDHN/vlWyKWPEl8wP3R8Bh4KCEIv7e4NHlhVI+xC5sfbXpcJ2HTQHF6j
	pkE0S7aXSaSVw4dzL4bfMq7gdLFVOJ1v/Alc36Ci/u1IDbWoh8oZVYNTKxCpAKaK/q8nu30Xci+
	LQArBkp+kqPz5H3RuG8rPG3XokqSekKagxPRC9DMzbCHZs5h9x4q985IenSZlt7m68RFmx4Zyr3
	Ofz/vHyfaVazq8sEuxrYnj2vc4WYVx6MV1ofCDoMRFywmHq9g==
X-Received: by 2002:a05:6512:1285:b0:5aa:5e22:5add with SMTP id 2adb3069b0e04-5aa879ed345mr6613387e87.0.1781041523843;
        Tue, 09 Jun 2026 14:45:23 -0700 (PDT)
X-Received: by 2002:a05:6512:1285:b0:5aa:5e22:5add with SMTP id
 2adb3069b0e04-5aa879ed345mr6613371e87.0.1781041523427; Tue, 09 Jun 2026
 14:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org> <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-1-82c7404542e2@kernel.org>
From: Yuan Tan <ytan089@ucr.edu>
Date: Tue, 9 Jun 2026 14:45:00 -0700
X-Gm-Features: AVVi8Cc7l3HzAy2Yt2xtgg6-CDVD_domuZQHBShLKIw1SGPTFaAMN-OeImdTFrE
Message-ID: <CABrc2FU9HuRp4tVEU_R1RdMMRkkS=tM4Uv70WG3UBTeho_C42Q@mail.gmail.com>
Subject: Re: [PATCH v2 01/83] block: rust: fix `Send` bound for `GenDisk`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, Priya Bala Govindasamy <pgovind2@uci.edu>, 
	Dylan Zueck <dzueck@uci.edu>, Yuan Tan <ytan089@ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 663CE20002
X-Stat-Signature: rux6t7de6ubauqiug6kmsq6wm4ftrc7n
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781041527-935507
X-HE-Meta: U2FsdGVkX1/WrpTHKohGSJmeTvOH+gTdANkyRivk52vXG7w3NOhC8BUzXLVuIpW2GUTtJSs//+cqvUFZrnHaJwbjX5r7vb9T1lGMJMWz02Lh1eve0q1evnjeipX8NqPdyw0oP5x0C0NP8UcOTRXS8aoC7O+vKpblK7Nt5EXWvEVfR0e7GTLm5PDN4Ph+DbozAbcrpuwVUGP1lyhO/k3vdIGAywgilfNF/gmDW/45Z6vLaBfWiYgPS5W1NmJ0f974f3mR0rSZdCzJLaydYDu9NW4B9xDUm3E8w+NkpamS43n/ymBZ29fGbPBncKmpmDQm0GsyOX8EraX5p9RZPMaBMeYL6AG0MuM0yEGxN5NJ1xBsESOHlouUDavb67SNUgtExI1uxizM6aN3UF+4H40w1gwgMtn2O5jfzcUPB3HcWXLy8AtmJLpE1WOOpi97ZkdDtzfPRWie5R4e1Gpek2T5eozqXeIaM5nGjs6vPvEdfou6ylBw46Bq9JBHBj3NzJSFXu07Zz0VXxXQdaESSWYwbmQXj3WGNDAkWUCEvqF9juV7XvT0ymKp2dGFSpT+hRi6FKyLdwRhuqnKywKKeyiwzQhZLUduimdMbbX78tkB0U9HH8TqZ7cTqUnab3Sg8AIiuUWHlgD0xDc2UcjPSYnNR9+cyGgesXNVVNwrzxjulzGIfqmm/fpVu6L/g0QtkMP86cmZ2wLPT7+GWBLLY2D47sBxMlMGKNn6JJXJBAe7pCUKQGOltYJRnP1fpKQ8T7AN42HAdfsZRbYsN9Z0ITwcKGsgegc9vWdm1zxcSHklTQlrmYqI9OsiFDqCV5KPpEJ0CiVMGN8WAYONuj2reiIWoKskEvn19Q+Yjp3Vi23ieuha6O3qM96oJZ4dMN6VYyVnJ56VgRrGTaOuGAZh7MhjYbND5yYk1cdNI0nr1WlyKL0YHkJui35ByfrFOC7eoc913iACbsZ4/SeWhrkNfGG
 93IyeOfx
 xZMZnAzX9Wqm9FNSq6iCandLoNeOqL94G3ldBmbMQkGV1CqcpNk74ptAU9Cb6mZ+174bSWlxxOSA5TeOiC/PL01xBkuhIPDazQqW/Gp6CqTN036Wx7OLA4unLlUY1BEOl2uB33rYs532trr4uEZiIknvSl3PKj8uDN5z5YxY8AhjDs4faB1RJOrUw4Rx4XJVFkbAEq5btFxz6N8S2PyfGRdZe6NwCMIrjzIXjSHHEiSoBySU5G2zJkm+FcdUFPlPvz5WFjJzjEBfZ6xTRigvO5XoPrf5c9ILmr9qTmA0CkhB027ceNowOO3riJIynPzATXCn3SVBVJC2dUzsHcYiERmux3Zl24eP77OMBLQp5xeZkYu1hMYoH0sKT+U4UDFKhywI7H3aSNlqkdB3imFuNT44eQWdBz5jPHfkAvVHHs0p1pd0RWu++OEuQfyhTqGexlBrvrT2k9erABDuOsngCvU//dAZxeTPhvtAIQs9E5TqyLd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 12:13=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> The `Send` implementation for `GenDisk<T>` was conditioned on `T: Send`.
> This constrains the wrong type. `T` is the `Operations` implementation,
> which is typically a zero-sized marker type that carries no data, so `T:
> Send` says nothing about whether the data a `GenDisk` actually owns can b=
e
> moved to another thread.
>
> A `GenDisk<T>` owns the queue data `T::QueueData` (stored as the
> `gendisk`'s `queuedata` and dropped when the `GenDisk` is dropped) and an
> `Arc<TagSet<T>>`. These are the values transferred when a `GenDisk` is se=
nt
> across a thread boundary, so the `Send` bound must constrain exactly them=
.
> Bound `T::QueueData: Send` and `Arc<TagSet<T>>: Send` instead.
>
> Fixes: 3253aba3408a ("rust: block: introduce `kernel::block::mq` module")
> Suggested-by: Yuan Tan <ytan089@ucr.edu>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>
> Please take patch from Yuan instead of this one, if they send a fixed
> version [1].
>
> [1] https://lore.kernel.org/r/8839ddc5ff54bf454d508cde91d27d00fc3e2dd8.17=
80633578.git.ytan089@ucr.edu

My last email mistakenly enabled html. So I am here to resend it. Hope
it doesn't disturb anyone.

Sorry, I've been busy with other things and haven't had the chance to
send the fixed version.

Thank you very much for reviewing the patch and for preparing the v2 versio=
n.

Could you please add the following when applying this patch?
Reported-by: Priya Bala Govindasamy <pgovind2@uci.edu>
Reported-by: Dylan Zueck <dzueck@uci.edu>

I didn't discover this issue myself. I just helped write the patch and
I don't want them to lose their credit for it.

Please let me know if you would prefer that I send a v3 instead.


> ---
>  rust/kernel/block/mq/gen_disk.rs | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_=
disk.rs
> index 912cb805caf5..b36d24382cc3 100644
> --- a/rust/kernel/block/mq/gen_disk.rs
> +++ b/rust/kernel/block/mq/gen_disk.rs
> @@ -199,8 +199,14 @@ pub struct GenDisk<T: Operations> {
>  }
>
>  // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `A=
rc` to a
> -// `TagSet` It is safe to send this to other threads as long as T is Sen=
d.
> -unsafe impl<T: Operations + Send> Send for GenDisk<T> {}
> +// `TagSet`. It is safe to send this to other threads as long as these t=
wo are `Send`.
> +unsafe impl<T> Send for GenDisk<T>
> +where
> +    T: Operations,
> +    T::QueueData: Send,
> +    Arc<TagSet<T>>: Send,
> +{
> +}
>
>  impl<T: Operations> Drop for GenDisk<T> {
>      fn drop(&mut self) {
>
> --
> 2.51.2
>
>

