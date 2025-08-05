Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA8AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9D46B0099; Tue,  5 Aug 2025 12:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1C16B009A; Tue,  5 Aug 2025 12:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D77E6B009C; Tue,  5 Aug 2025 12:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 797EE6B0099
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:50:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3402F14019E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:50:19 +0000 (UTC)
X-FDA: 83743291758.04.99DD9BF
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8167440008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:50:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cPU7jwOC;
	spf=pass (imf27.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754412617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJcoJrBrh2R5VK304PCoaS4YQ5dFpvDYdFen6NXvqWE=;
	b=DV3v/PUq5LfrlzajWOs5v3gaQMOQrbEuAxP8zfjTPs3a6LO6CAErzl43hDd5xN1ODa5uyk
	jv3vvogfL3zB/R2hRs6X7wb+E5f2HNG82RFLUSYazrkbRK/42ZRcekJR2KQNrOAMFK40xx
	djo8Jh1xNnBVJZOo99xftDFFLADKRvA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cPU7jwOC;
	spf=pass (imf27.hostedemail.com: domain of sudarsanm@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=sudarsanm@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754412617; a=rsa-sha256;
	cv=none;
	b=H33gZ6gxEB/UXjGpVjitc0zvsxtCWkP1CKDTDapn/e+R1704KeV26VeiSR0BNVK/G3/C+N
	WlAk+wpfvnWgwBDgPWldqDVaM+f3c3DYX5qaWaeC1sp/HMk2FJ+r7LPlOT48TrGj9IDHzx
	pT4kwz8knCGjmychC+RtQxgE7Pk0hVs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-458bece40fcso17851225e9.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754412616; x=1755017416; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cJcoJrBrh2R5VK304PCoaS4YQ5dFpvDYdFen6NXvqWE=;
        b=cPU7jwOCvGm45Arx/WDK5VwKcFJ+uDK3bNXidra8UvFrwvEUF+o4ttta/JJTsj2UvQ
         d0v0elgxIry9IyRAmrArgMeBRbRbZiZNQz1qSuYroJ6az5KsSu6x5IrHWmprXnyM6F62
         yAw9/LlUUNkEmM2XAKUUaEQXgREme8oCE3Za3c5HHZdVXyRFdJ1xa6S8C9CNnpt2EBeT
         1VevzBdo1J32N1wcsjBcnQWi+3YDxMiXvyX5Q+E4+IG+XxR9KjwciG6rvDHL191VGfVX
         jg/OV21Lp+lqAbdDlUSTAtds3Bv+NfVUtbok9U5bPmVjAgLleDsO4QrUiUXo9GTbi9r5
         P9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754412616; x=1755017416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cJcoJrBrh2R5VK304PCoaS4YQ5dFpvDYdFen6NXvqWE=;
        b=CLa4R0PtHrrG+ncHBDLQAhi9dx0zZ8n9UV2mfR+XaT6ipDGheXofTfLnXisva9uAg0
         rDnJLAvd1ZeC2mg/iAGs8CBmXeZlwVlAS7xtK62rPNw0svQbDxyddcW+hpD4AOHPGjv8
         LwNP9+IoqNgvttdXXQZ7v9iUcyrMY+eKUBjCs9MMjIm8mb1kOZgy4ox+WqJB7DCQCMHh
         eEe58L4pEzaBeEEwskFHMgszje1YFKbRSzZw1c7qSvdrc1XhUfGcnQIG46A6G08G/CG5
         DOXFubtHJxuVIwEEN+HZBxhAQAhhhYJQ+/yceoPlNGk91HeaiYNg4AK/j1oGdqWTgvvI
         OORg==
X-Forwarded-Encrypted: i=1; AJvYcCUSbEQgYNQPs3To9I4ur2Abccbn1IkrqTtF6S3LOiwuIXpOresGoU/Y4aP4nBCwFNXdD1KHB7zgNA==@kvack.org
X-Gm-Message-State: AOJu0YzH+ABloIPAKwvp2580kKNGsrgnozGKUb1Aljx4DMMD2N9g5Vla
	1xQqARGLcVUhyCRiktkXHK6IzqMYOE8TkH+sO0icnusaxtnnY46lVUttIzd7/g56snZXRAOszt6
	Z5DgoQivt0y4d8fS++oak8IHuiDc9yEFCC5JZV1iF
X-Gm-Gg: ASbGnctchLI2Vg6kcIpldNvOzAUZXmvyvKd8s2UNzF+RdcVm51yygIev/TdgtiXVheN
	pQ0iWS5wFaTWCg168e4YLoRKYcFmx5NZLb6lktd1b7bOr51Q/jfTnHiQxTaHAny8K8MaeejN0UI
	1srcQHNyV36xwJA8/mpWZTmfpZ7Y3qA9ciBPlMx+0HP4v5Fiea7n+nSSkbK87b5OiHmUiKz4mfF
	3rCGhu0
X-Google-Smtp-Source: AGHT+IGnzkRfnLMRZMJFxDrRi3bNwVHI+Sbxw075Tz0UjQkJk3DxlLhAxGEyzLIAQODvZJCnncEeJklUOavPO5pACbY=
X-Received: by 2002:a05:600c:1394:b0:456:1824:4808 with SMTP id
 5b1f17b1804b1-458b6b58542mr103451975e9.32.1754412615588; Tue, 05 Aug 2025
 09:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250805013629.47629-1-sudarsanm@google.com> <24bbd9df-efa7-4090-a696-1eb40904ad85@redhat.com>
In-Reply-To: <24bbd9df-efa7-4090-a696-1eb40904ad85@redhat.com>
From: Sudarsan Mahendran <sudarsanm@google.com>
Date: Tue, 5 Aug 2025 09:49:39 -0700
X-Gm-Features: Ac12FXxESoQHOrJPpktg-TGCOr3ip2q_10eJzmyDxEEsqXYQWFyt6x5Dq_KqP98
Message-ID: <CAA9mObAqO04H9Hui6jcgv5rPBYVmnLeVQFuPeZBRF3DEvCxxsw@mail.gmail.com>
Subject: Re: [PATCH v3] selftests/mm: pass filename as input param to
 VM_PFNMAP tests
To: David Hildenbrand <david@redhat.com>
Cc: linux-kselftest@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org
Content-Type: multipart/alternative; boundary="000000000000be79bd063ba1046c"
X-Rspam-User: 
X-Rspamd-Queue-Id: 8167440008
X-Rspamd-Server: rspam06
X-Stat-Signature: sqi49st5ynu3tgohsyciwt3tcgny961r
X-HE-Tag: 1754412617-927898
X-HE-Meta: U2FsdGVkX1/AGRUYqPhOO4SPR+A6W5XblG/x/ad2M0kEdufgU+I6TpxZkss1zoLqtqUz1uC4oHYavNnyXr3R6zhLZb9e3BSJQ9iAR42pZBcpSX6t7TsE7Eglril6bDWjTHHrZ5uRQUpVhF9A/R/mYcGrBb35ByuBtGFPhcn82JoMBhFI2lkIWILfHiTTv6gCl5X4JmpPauxALDwv979UZLtP6+jCSONBqguxGHkR4PabgTk7V5fU4N2aT5s3uBLuvBWe89dMJUUCHtLAZWFO3IInCZlBzkvzRIwoJ8rNfDOl4LYyn6Ytm6dqbh4t493h/0EflTt9nW8Mfla2jUAIMUQMeULitSr/1RCCrTM2QK5i+NIC1e+3KG66eovXKJSO1b+XO+PvSOuvPOlq/6eFbqlGB7yjVux1OqF5z8W12LxNRQIh8i1q9mRJoFW9HOBbqG4BIkdjHYNvKWXZo+qDfP8uoN2Zvqb9mVyPRIvq3lYOwsPhG1eX/qeeTAsTI/XbNVmQ9pWeejhxifEeUX3IKfeXAjW/ijCr/SAN2YhxrqhZpe54Pm4sUvhcDWRqCRVXdq5i7Qx5wadHX55ijwJwvQyUk89nrA40YLfBcoq3luntZ0uVM3NJoHVbftotL6V2SV2toxzMoAma1SZDgcXlUq+T0IV6aHu/HlgX2me0oBn0TjTgdv0VZ0YZUR0xpymGKo28XOtd8wjzZGiRDhAGOP/4P7OUfSm772hyoqYj5f0OijfGW6qEableXHCeHysxO0FGVOoI8g6I+TJ3xgWfZ3XAZllUc30E9Do62W1VKCultGJWA7OCb/DEoVFiQpZzfSL2tYRo+Ke9op51WUP9Xb7T4Xo2p5VX6SbGX+LeATYW0CKMSElrTE5q3I8xhX/E9A4SGTPwBJSvwXZQA7E8foKy+VRuBbc6Pdxt5DJ8Z+VxD9FzWBhcxbeEiZp/58mD6S6ubKChZan8gZ4CwoZ
 XtOh1Jf5
 4qI6iFbQr4eo7dO6V9SvN6pkeuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000be79bd063ba1046c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks David for your insightful review comments.

On Tue, Aug 5, 2025 at 1:47=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:

> On 05.08.25 03:36, Sudarsan Mahendran wrote:
> > Enable these tests to be run on other pfnmap'ed memory like
> > NVIDIA's EGM.
> >
> > Add '--' as a separator to pass in file path. This allows
> > passing of cmd line arguments to kselftest_harness.
> > Use '/dev/mem' as default filename.
> >
> > Existing test passes:
> >       pfnmap
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       # PASSED: 6 / 6 tests passed.
> >       # Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass params to kselftest_harness:
> >       pfnmap -r pfnmap:mremap_fixed
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.mremap_fixed ...
> >       #            OK  pfnmap.mremap_fixed
> >       ok 1 pfnmap.mremap_fixed
> >       # PASSED: 1 / 1 tests passed.
> >       # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Pass non-existent file name as input:
> >       pfnmap -- /dev/blah
> >       TAP version 13
> >       1..6
> >       # Starting 6 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Cannot open '/dev/blah'
> >
> > Pass non pfnmap'ed file as input:
> >       pfnmap -r pfnmap.madvise_disallowed -- randfile.txt
> >       TAP version 13
> >       1..1
> >       # Starting 1 tests from 1 test cases.
> >       #  RUN           pfnmap.madvise_disallowed ...
> >       #      SKIP      Invalid file: 'randfile.txt'. Not pfnmap'ed
> >
> > Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
> > ---
>
> Thanks!
>
> Acked-by: David Hildenbrand <david@redhat.com>
>
> --
> Cheers,
>
> David / dhildenb
>
>

--000000000000be79bd063ba1046c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks=C2=A0David for your insightful review comments.</di=
v><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" cla=
ss=3D"gmail_attr">On Tue, Aug 5, 2025 at 1:47=E2=80=AFAM David Hildenbrand =
&lt;<a href=3D"mailto:david@redhat.com">david@redhat.com</a>&gt; wrote:<br>=
</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left:1px solid rgb(204,204,204);padding-left:1ex">On 05.08.25 03:36, =
Sudarsan Mahendran wrote:<br>
&gt; Enable these tests to be run on other pfnmap&#39;ed memory like<br>
&gt; NVIDIA&#39;s EGM.<br>
&gt; <br>
&gt; Add &#39;--&#39; as a separator to pass in file path. This allows<br>
&gt; passing of cmd line arguments to kselftest_harness.<br>
&gt; Use &#39;/dev/mem&#39; as default filename.<br>
&gt; <br>
&gt; Existing test passes:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pfnmap<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0TAP version 13<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01..6<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Starting 6 tests from 1 test cases.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# PASSED: 6 / 6 tests passed.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Totals: pass:6 fail:0 xfail:0 xpass:0 skip=
:0 error:0<br>
&gt; <br>
&gt; Pass params to kselftest_harness:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pfnmap -r pfnmap:mremap_fixed<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0TAP version 13<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01..1<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Starting 1 tests from 1 test cases.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 RUN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0pfnmap.mremap_fixed ...<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 O=
K=C2=A0 pfnmap.mremap_fixed<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0ok 1 pfnmap.mremap_fixed<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# PASSED: 1 / 1 tests passed.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Totals: pass:1 fail:0 xfail:0 xpass:0 skip=
:0 error:0<br>
&gt; <br>
&gt; Pass non-existent file name as input:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pfnmap -- /dev/blah<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0TAP version 13<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01..6<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Starting 6 tests from 1 test cases.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 RUN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0pfnmap.madvise_disallowed ...<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 =C2=A0 =C2=A0 SKIP=C2=A0 =C2=A0 =C2=
=A0 Cannot open &#39;/dev/blah&#39;<br>
&gt; <br>
&gt; Pass non pfnmap&#39;ed file as input:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0pfnmap -r pfnmap.madvise_disallowed -- randf=
ile.txt<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0TAP version 13<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A01..1<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0# Starting 1 tests from 1 test cases.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 RUN=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0pfnmap.madvise_disallowed ...<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0#=C2=A0 =C2=A0 =C2=A0 SKIP=C2=A0 =C2=A0 =C2=
=A0 Invalid file: &#39;randfile.txt&#39;. Not pfnmap&#39;ed<br>
&gt; <br>
&gt; Signed-off-by: Sudarsan Mahendran &lt;<a href=3D"mailto:sudarsanm@goog=
le.com" target=3D"_blank">sudarsanm@google.com</a>&gt;<br>
&gt; ---<br>
<br>
Thanks!<br>
<br>
Acked-by: David Hildenbrand &lt;<a href=3D"mailto:david@redhat.com" target=
=3D"_blank">david@redhat.com</a>&gt;<br>
<br>
-- <br>
Cheers,<br>
<br>
David / dhildenb<br>
<br>
</blockquote></div>

--000000000000be79bd063ba1046c--

