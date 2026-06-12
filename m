Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61AE7CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7966B0093; Fri, 12 Jun 2026 03:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98606B0095; Fri, 12 Jun 2026 03:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87AF6B0096; Fri, 12 Jun 2026 03:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4AB6B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:33:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C9D51C32B1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:33:26 +0000 (UTC)
X-FDA: 84870445212.10.57D17E3
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 491D5160015
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:33:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fCDtjwew;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=37yHv6yFdGH61lIGAgzgwqwgl+igTLCwlH4B//p5pEE=;
	b=DgZCHCPg3riS4pztFVMiVW+C7aFFWk7rmBKyGbti0RDKTTHRBhxIRijx90nXqDPgKlkRA5
	FBcyK4Jdga3yAV9/47AbAQ3ZMhYk2fLP0JAQ0McKCnLhTthO1sMlNCYEKL46Tq1KSXHXiH
	xt8SVkY9cq2P2wOvsFTT+Gt5HMLFPf8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781249604;
	b=CedYOdom4+9hXXIN8qfwH5lu8WlFaYTF2Y+KTmLGwGjp6braBIv0cHZESH2uvQS7+t3RnV
	dBXq8gZKwJq+YG1PPPfCCZ1uaiaHnKFWU+QvPIqsYjUt5aDfsKgZLrZ7tF+PCh9pUhSFsi
	70LBxHGQ/JD0TGQvCL1bdbbf3agF3bY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fCDtjwew;
	spf=pass (imf08.hostedemail.com: domain of glider@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7de68222e96so5154627b3.2
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:33:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781249603; cv=none;
        d=google.com; s=arc-20240605;
        b=V15BrW92Yp0a8bSOImJ36aNayBPcHdBP8rnXK+f0N3w1eytFEg9QA3BfPZjULwaZfz
         T450jPw5yP6wvblikE2egKIKin6JQGQ3t/PX83FxC6gy4NUGl0AIciKFdyQp6KoQzzJv
         5MoDUERzHWF1uYGM+OeqojEg4Jqw4ZJH5dSIy5pKrEizdg6QZE7nnkCsgRPFgpLNLKrI
         el96a4cfXAqqxu/1wCrAaZxgkzG7mTdm7DnE7dQYQUmcP+XWBq1Ml+90+3weJSjHf0PT
         Il1yAxKRpokqQcokbZ5x5PqAAPOTisv0jvAKcQExFUzJtxiNnwfUN4ab4BEqBulllgkf
         CfCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=37yHv6yFdGH61lIGAgzgwqwgl+igTLCwlH4B//p5pEE=;
        fh=9WKfJOCawOGypUxuNMgZoZUhv4BCdIcALzchRIiaugI=;
        b=le60wojXmhTGym9aM5/vbgkkYCDE2t1EMfzBQi0M8ZsYbpfChbACbdhPAdntH9d024
         JwvSxrllkhIDfpX//OYaRHWYs5e76JWldp1OER382NYPEI4T2S3l9HQmaXI5QhgUpoL3
         P4lWWzD0Hz/iJznw4wKXSLH7Sx3vCpFmMTU5sUfThw8A4KMY4GH6F0+A618uSa7+LZYx
         npo6a+j283xh2qfWQfwpVBxtcjAnSHyLPkJSufWeA//iy8VYmwgzoqyrClOHAO/1uAx1
         V9t6S6Ady155iUXs7FTBkwE6pwky6Jr2KXfmmGQjwp893zUsw6tgfcArWSpkaK5LvOqJ
         ragw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781249603; x=1781854403; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=37yHv6yFdGH61lIGAgzgwqwgl+igTLCwlH4B//p5pEE=;
        b=fCDtjwewJBDJz+iyHuzRPhO7z77J9sFsH8bY7iCwtnkV0HOntkx/mtJ2FLeBLuN5wp
         CMW5rACP4IkWWyTjxg3vFxu1G8yY0FQVoQ0sa/Vf4hZsyAFuiXIGehDDQWf52/wvf/bc
         z9LruZQt2ATOmNZ6npkZUjSvhpyb4tXvLDjul7KcvnXwoXf3v0lDVbfF3Ld+Ex4B30fN
         eSRyyKGE1wNW2qlstrt3iq0YOKVRE0rqF1B1aurj+hczmtttXt/k1WQEVr6PWqMXrxgD
         siYLIZCPWUoqiBw/SLXxBLheaXPpuja8tK4Svz+cp6lK4vNGGibzLdkkqpAE8qKdANfi
         ze5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781249603; x=1781854403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=37yHv6yFdGH61lIGAgzgwqwgl+igTLCwlH4B//p5pEE=;
        b=LaZ0BbJoduTSl4vniXaIYaWp8xCwt9jij/SYC3zhPFZ/N2rhSaHdYZwqTpAvFYGxXU
         goCoJteu4v4JcvX0/+dqr5OCP/vJY96Y+la9eJzqVywENI/5P2kq1K70rgAJnhcmn0Cb
         VhR239Vez/mIsJNwkJetLrOi/vJXPEa3I1+IiXF5g26Sl4DV5wndCUnV5dS7r1Cw42fc
         CNYxK1+ELJpTkVqIa1D/F//cSKFbap7NzfwTN3OxktOVeZThW2aGKIWL6UJMb5zNNTxL
         x1Sq6lu6z+i8xlE8S77FlYPzrb4vnQ6B5vIQcncvio6u0Ztpp4/WCkupgn25zzccE0Yx
         zx6w==
X-Forwarded-Encrypted: i=1; AFNElJ9EtilcGtI2g0h/fheJipEl7VFHSQ08yiqHWDlmMnYf4w2HSdkSSJLR3eMDL5DG0BI3+m7C/Lfteg==@kvack.org
X-Gm-Message-State: AOJu0YwTMJhqmLELsAtxEvNQsawn+P66mvW8YhMgqmc6cdIZ53f14dHP
	bQsHclCyFzMDytFkJAc43h/mps0peVSV3GjlMRxK6STV1f08A6xIUPMQMr8CI6PIhW+FkoleMgQ
	tI2gzjISClE2EBtUpLIuuv29Tcxp0/uAoXH+0/EW4
X-Gm-Gg: Acq92OHUbjrOfc4M2pTWy0NKcHArvOiSCfHh4sutGQNsQ1Lk93eunSjXWrBL9hmBkL7
	LHwgbKjx7BhDN/PP7bmoACbGzUypCiYYU+a6BkrlX3lqFkD7il0U/TN05coISV6pkptcAU0eNyd
	xqP+L1+5RdvDfwVi3PfFACxlY0rfwummkCTrJ8Ke/YbO9RKEVAG/ihmcAi2vlZnj4ALLe4x5GMS
	L/qbtqsa4gbNWQ4lHPh1oSv+kxZAml+mhX4jVtmLn5m8zNC2EoDIHXdObMTTPCdAonhKaxPYkAp
	UlHIWVD8KM4IRUnmup/4YQvjtAVjjSo+/dmLqQ==
X-Received: by 2002:a05:690c:c502:b0:7bd:8752:cdbd with SMTP id
 00721157ae682-7f7bdb01a78mr15009497b3.41.1781249602660; Fri, 12 Jun 2026
 00:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech> <20260611-b4-kcov-dataflow-v2-v2-4-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-4-0a261da3987c@est.tech>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Jun 2026 09:32:43 +0200
X-Gm-Features: AVVi8CfstzQNbiRE_Nzp0e98G9-7hbopDZWc7hVRExeHcpnRY99AeT5FguWPzQ8
Message-ID: <CAG_fn=UJTVm+XVjq-wq1GsfFLvQuET7N1A6ZF_BWtYwmDab_TQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 04/14] kcov: reject enable on multiple dataflow fds simultaneously
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>, 
	sashiko-bot <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 491D5160015
X-Rspam-User: 
X-Stat-Signature: m3haehpxiwdm8oeze53r1fbc7bcg8dsa
X-Rspamd-Server: rspam08
X-HE-Tag: 1781249604-597866
X-HE-Meta: U2FsdGVkX19YKPqElK4gXfMfPGFCamv/MnfzroEbaWEDVlXIBLqO8cwL2pZhHVntD4hYayDdqyu1fMGwwTeN5Ii+oKH2USVhxmT7Y/xxPmvmW3uCvrTufEi7BBqjtxIzWM/LIFAhog1BIAUtLBBlOq+DZKi+4fS/vdcjPEKDrWmPRRUoIMEc7JVd0I4S8/SDSbIMbb4SaEiCvKCQVb27B/YsoyFRrEkbZ0C/DGlhBQM+fTpNWUnJVaRYDwhgKH2mhrimi0VSgTQjw6ZUKZVxMoy6KI+AdESVK8+giNwvg6Whlzm3EsziGQxJozDzSvHRb/G8bzVHu6OpQML0Mmz6x5bX7vAJ1vg7YbUVayWQGf2MjSHF43Ww2zemq0hAeLidCBWElTpJvkVsIxZAfpU0P6oyzYpbRzdE4DC1hTfj3DkVOabtu8zWSvmHwfDX1LikLUjJ3KBeTHBe3Ye4fhO25OYf9jBTMyVe36vKAeVTK99zExCvlfvOECbdEq1GNuhYAlyJRn/kdKfGxkIPiBoFWF8THgy1yCrHN9MjT8oHCVrBs7eVXMvZI0TKciCMFbwWk8uhNurhrEqM+1IRHomuaDEGVchd/iVaGkZIjpv8mNb9SKsSEDaTf9fCLK8b9LOLG00QENB5cso8LBJBJ6rpjTzJdBbryQA3WrXZfcywvw00EbxMxK+9oUWuXpzaAEPdKZV3ZkWRD9vooA9I9Ey0qYLu3zqxLNWNji0YKaDSUSxzjR6yNXS7+D/B/EePjJBj/IGUBPttoshF8mcDDPGXkxdojCYy6tqKQTFAFgmGqLcw0mVvF1Bvb5uI5J6LY4P/K2Q54y/FJ1ZwzXz8JtCQAKtDoTmtLxSGr8rp5eWjkn5FKvr3jEcWrv3JwTXox9C9ecQ+TgfyL9YO9c6lkkUA5Gl2v/RTV7Blp1QHPHnwrP6RX/uuOqHazH3zs52c+L38FGm/EM6AdxWajZS6dyt
 f2rayPDL
 IOeoxVYLG+c26VblcjOGLZ7r07ogN46RXCmLTD02eOY78r9CynKi5NrCMhAEsu6xwf4PBYQxJseJ97mgSw7QCnQtf7H5CglVIVnMtuaeCHq7Wppwav5nng4YeLnVRbRhSu7dM0cTO1bMVpmpEqr0+HnqrfiNT/e7yBfsw4jkyGmYNMb9bkwjsLDWfJseXVje5jA7gQG4IXu+UN3XQAJoGRCYi8SdCtFc/r2i6Y1HA1G2tEY4Hcqdus+qMmyVfjirzIQV4O9FswCF8ME/4mRjAWAKDa+zND318To1pCv/t86BnoA2eDy1XB4+oZiZfG4pFkF3AJ62mc5bufbkLLMIF/b55fOfE1YVHkePlhBTseFjLIMwXc1Q/3+TX686KmvFqnvTBmiT5Liakw905MdmLrpEaYLLDLryf8E+yqfa48uzuCnUvtzpwVQ7X4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:21=E2=80=AFPM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> A task could enable tracing on multiple kcov_dataflow file descriptors,
> corrupting the internal tracking state when one is subsequently closed.
>
> Check current->kcov_df_enabled before allowing KCOV_DF_ENABLE and
> return -EBUSY if already active. This matches kcov's check of
> t->kcov !=3D NULL in the KCOV_ENABLE path.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260603-kcov-dataflow-next-202606=
03-v2-0-fee0939de2c4%40est.tech
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
>  kernel/kcov_dataflow.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/kcov_dataflow.c b/kernel/kcov_dataflow.c
> index 5248293280d5..27587b8ceeab 100644
> --- a/kernel/kcov_dataflow.c
> +++ b/kernel/kcov_dataflow.c

Please merge this patch into the one introducing kcov_dataflow.c

