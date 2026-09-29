Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F8DCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9CD6B0093; Mon, 28 Sep 2026 20:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B69CC6B0095; Mon, 28 Sep 2026 20:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31FF6B0096; Mon, 28 Sep 2026 20:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80DFC6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:59:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC4E01A034D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:59:55 +0000 (UTC)
X-FDA: 85264992750.24.8BACB9F
Received: from mail-vs2-f39.google.com (mail-vs2-f39.google.com [74.125.227.39])
	by imf23.hostedemail.com (Postfix) with ESMTP id EE757140002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:59:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fAykt4Z9;
	spf=pass (imf23.hostedemail.com: domain of morbo@google.com designates 74.125.227.39 as permitted sender) smtp.mailfrom=morbo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0ADxDwdLkQq+vcZGCf4NIyg5yF4IrOepz6gtzfzxe0=;
	b=743ZpLjY8vp8KU44PXfrBgwyjgaLyHWt0VMmRkghg63PsjjhgcIQOTPWbZXqIL3vn7AF/X
	xSslg6cqeCOKrMYMHe8ZGzqAzrIulGunH16LbHyzia27sby5XU8ySWTJLH3Iq2oqUO82n0
	CAcCoxDpAly9CICUdkOLuu4+EzAwCew=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790643594;
	b=w302D4BtzYl9wVPN76khL3MgzNtKsxhK47Ic3notm1Q46I6dDUxL4/YCB4p3uuiwy95Pbv
	zSIl5BZuehaMYYjZls9ugzaTaW3ttKNjcbcms+sRCTagj83neTFtj5kPdM6jrQLy1BIrbh
	hKDtEDkLFBe/IQKrJhEIbNA+XVJ3JUE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fAykt4Z9;
	spf=pass (imf23.hostedemail.com: domain of morbo@google.com designates 74.125.227.39 as permitted sender) smtp.mailfrom=morbo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-vs2-f39.google.com with SMTP id ada2fe7eead31-7b2907c2e8fso1790890137.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:59:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790643593; cv=none;
        d=google.com; s=arc-20260327;
        b=C0wrlFR6ATdDwF6mYRwQ/8WjNQhNHa7fcjYgSZvInLd5Dhqa4FiKrGL9co5pQ7KHgP
         8TuBgdxa0GQuOEWRZYK7oHcIvfoDrXqeJYBHGo/RCFJsQSAj6KwNWIkMMiRob/YEIrxK
         Nw/0CFWQ661zPyh7Dnu/rNTMm1+TWxSyKvof41lXhkGioZpuzOUeSewheUScuM1dMbMI
         B8ozzqdlrZ9uJzijwT4SVJV50oq4SJNWH4CjxdoUykD6pyyXCtLegPy53zYQunMSQFhA
         mpLcH0CvqxU/QFz/+utqbEU47MXo05LRgv3modKNU9iBcgFb7JF5m0aB3PsnVJmnGX+c
         U5uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V0ADxDwdLkQq+vcZGCf4NIyg5yF4IrOepz6gtzfzxe0=;
        fh=5BaqPT99Tj/lM3XfC8GVUfUaFD5EiYx+JudJVI4HtCQ=;
        b=A+vk5zPBz+VQQU3D1vbqUnEH+yLYdt+DMdHJb8vh23OiekosSRoJFhqt3bx7VSMJsN
         H+oOEeQe+rLwBsLEWk6GlhgiMf7QIRlgK49eI88+5+7i2NELWuJEyB2btiZ36vxUkVcQ
         r+fT3nGtKYvp1NPAkmh4M0YICIC9ajS6D6sSdaggEVCOZt7UQUAlVUk7nOpAviOYtQmH
         yTwDPf+be9pm3QYPRGvKB4r1JxVVgZFt6WoEH+iBpUlVznEwN2Jpr22ibdCuzuxvZw/l
         Vvcm81c6rljzM3i8Jt1ebQSv6fXY9DObeEQcPstmKM6KzUYxoxU9dtH8GDFyyNcv6hV+
         5VSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790643593; x=1791248393; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V0ADxDwdLkQq+vcZGCf4NIyg5yF4IrOepz6gtzfzxe0=;
        b=fAykt4Z9DQE04oH/C1pxgAqMA3ukjbSR8W5z5W3lpbVRYaBXqdg/H0Nr/4Wn8JolTu
         cB6jUvimkarfLoZIPMMOl26dK5ouuTmS4Ef/ZiwFfupzmKyk8UCww/K1yg4/O/BcC89g
         n7muA0TUAznwuIrxEWEmdsGp2TkaKfAppm9oQT27fsx+f0YWvlNPPWieRcpvdT5cb+m+
         U4UQvStpfbdT5usAZfvjuu2GqOpATPQs2S4sRfdK+4D7GAS0/ZZEKWKdeaV7dUA9wklP
         NlAGD4dX/86SnXk4GvKovjJyGhuhF59H5xm+9BASwARlsrQ7/iWGrrwEbKeFuQDlUPY2
         K3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643593; x=1791248393;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V0ADxDwdLkQq+vcZGCf4NIyg5yF4IrOepz6gtzfzxe0=;
        b=r/CjkVKllFusYdStJ56ELOybdfSHa0D+9An3HhxLgSdJwD9vidx/El/i5qawgdfAFo
         oHsMO/B3+eiCtqzOSNnDqQsZe6Np1qgVc+RiLI1jzTvfh9Vuy93wO0hJsud+hSveTyGM
         tKULjAJXFbEv3s7EcAhL+gR18m489ehG+RvzZBGYGTo1wSPUE+GcTVUR8rnh6oV4FGom
         7ZegW4cVmkXzMJnIRkf6UmXxK+Jvmp2dHS2pzwlfLGO9bDvokDojMd87pPbNzdQ+W/1+
         m8xxCBJEYdYD0YCoTT73Q3rqbkGbUZTxDotv/UC2XXi8RCqjnK7wWDba+QvS2tYjUqL4
         S4Mw==
X-Forwarded-Encrypted: i=1; AKwUvBy1dUa18nWuMQDsp8ZdjgYTZyxfC3OK5o7B5v4k/Rtee+TZubXE0NF8LZ5dlaDlOWBrojFv4s1dLw==@kvack.org
X-Gm-Message-State: AFq9FYJZhcsHogdDZFnQrDODKLNfKd6Vv2yPWBYyErL7oaWcbN9kGrKY
	u+YSTNRNvy2mCXdUtoEBlpbjLgWZuSxGqMMdBweNylysUYP80DTozWYWcIuzqrHwdup077jo5iE
	9NNuyO9fkqsb4q57PhBFbKgdpIA444LRAEVnEdXw=
X-Gm-Gg: AYBFou0PDxZ48Zar815DSlGPBhbZ4iTSokc32imT3pdGHOZ0eptXBpTaAZkRMLhUPRs
	KYsADuTdq7LsZO6dv5CJzGg/e1HbF3pQHf5056QOrFlNFiHI5CVB4pl4v7IAc4rbxLjllrmHRpl
	zy0J8wXoBuIUTaSsoUn79D0ys8hJ0FnTEEt4r3vdH5JGYJUv4CnVxs9i1c6ov2PuLeaiawCyFGJ
	U9NTQ/cQtZBkViKjiUZq2kwZqby+rr5I6SARRV3nBTCHfr/nTeBgptapmjrmonJBkVWbOnnJwbk
	UMDbQwSK41QPS8FMymbUYczqaUqqg4u67LQ3ojnRLgDcdHmXv44e5mWCTEZo+hYfNQMCTu5iRm5
	3gsvz2h33ueDH3krlmYot
X-Received: by 2002:a05:6102:8645:10b0:7b2:3925:9587 with SMTP id
 ada2fe7eead31-7b23925a3b7mr2618011137.17.1790643592416; Mon, 28 Sep 2026
 17:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260928231737.2092716-1-morbo@google.com> <20260928164235.041803152d3f340d4c59e59e@linux-foundation.org>
In-Reply-To: <20260928164235.041803152d3f340d4c59e59e@linux-foundation.org>
From: Bill Wendling <morbo@google.com>
Date: Mon, 28 Sep 2026 17:59:35 -0700
X-Gm-Features: AclHuK80UuTfMLELvaE_jdAE5HpgJUaUpVSxG6Fx0aY5YOmC9Nc8zrqkCvUINPE
Message-ID: <CAGG=3QXLkQKiwb0VfpfWKYwSEaBLp38FAo-P0Nja0Sq8CvBbNA@mail.gmail.com>
Subject: Re: [PATCH] kasan: add KUnit tests for __counted_by and __counted_by_ptr
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	thomas.weissschuh@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: epff4by53rp81ksiixwdfqykqbxtyqxz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE757140002
X-HE-Tag: 1790643593-117291
X-HE-Meta: U2FsdGVkX18H6ggY0OC2nYaTLBa5u/Q9f7ZkGXdQ+DOwBjWj7x7mKp4skKRazaJDcaUXGtQ496EixohTusKdZdU2drndSD91ItlDjS0uLho6fws4MT2+lmsNEPdHXUYd/LPiTdZe408Xac9qejcP+I2ZR8kkf8OolRmNJJ9/R6btL+qPUg4r5f9/GFzAP9XfjRCXMKVo+r9u4CDFdMfnHhCs8P3laa1N5LfpGbyFM20PFHTTZI/qLGcK7zVYclbtTyRBoTyx7xM94o9Md/dV8tr9YLiQg2UhGgWx3eNhYzjuXQf4TCtA4EhfxiZhpSEL40k7mGc/CAkcbpCKJHDnLQyI3OHDItcs31ZzxifIh917txeIbVSWoVunXepgpswaAPkk2a0yXlmBWGwvRSiLHSgEw8eXtYvHo2mJgG/knpcl9/hi93Ri/js9kpKyTrgk2J2Nw06oJfgCCpkzDp69EBHOoGl+mx/zZZISybNBwWFVU4DDAvjdE8rAnW2B/ZrOL3K/2P2fF+Hr+DcON5pyVb5oGFA0gwYkm52kHdtqQ53VtyOIK8XRr6p0GhYz/6+fzi+bgquW3QGK9lFG63VQ6V7aZeiGxtTsCXIMwME6KJ9W6H2KDvSza4vJVoLe3Vi+PQD5RqcHNNqYlhaH3mw2JkEIFCNUoWcjr5UEj9pwllaa5a4Ba1jaWyp6qnZQkfQnK4ANI5JDYbXsF7bIDtFWNjiEqjYfkoMj6ylylvV4ZPHUar9svWN/wfQKwpJaCmqChp2LgjNwSNmqHtFzkkU/KzHy8AM05yYXNgEmPzgpxZqk/gaNAsNVnVDjyq+jrqeo4z4Ozid+TrwPIPbsq1l39zKwao/OhEPX0lyhusFc41mu7s3NvEY3fjtQNoFAkiguKadqEtpEiPDr2kLzU0h+bZz+MUPQEIyn6ls9gLV7KiGspYnoXVMOIG09DeIz5jPG3TEYKCRsp2yaeUsv/iW
 4mj/Cy1g
 5Se2s9XUHDqRfnwBPMB9Fse7Jw1wMUR7cb6Wu/huX0NvXV49vZn/agUYJBM41Cu/kX9bJUAtcn9njoH4ax9sF787FHRWsudZrQBAcluoUVGUWe3/R2NzFwEq++biK/rXQyGdvInuVbb7HDv/UWNcSOn+eIi49RcdB2OBHiD/KzEF7iM7wJ6ym0SzvBDqnLX2/PPTTSZLvCiUd40d7m1YtIE4DkLX9q9yK4R/ZaZCkaYYTYQXutdG1RIS3vOZflq//qvdJs6p/tpC9nhLC6jJsUrfRqcamDeJGfEKAH2rtb1E9uVeKn0f6CKlRlKaxJJfxljPniU5u9vkcT8NCHzpZqCtGf2qOSxNw5sISqW6i+YuEQvZANVDQe6DFK3LZrJhfYdE7Ann4myG/H1mWyNEDnIeaJKRSUTzUVYksMv9+m2BGYF9x2ANJi6Ak8JwTRZE2KOZ2gStgH7snj1mlv8j/WhymxAQprE8s5gizPiBl4uQb6WmxeqJB8d6dzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 4:42=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 28 Sep 2026 23:17:37 +0000 Bill Wendling <morbo@google.com> wrote=
:
>
> > The '__counted_by' and '__counted_by_ptr' attributes associate a
> > flexible array member or pointer member with a struct field that holds
> > its element count. Supporting compilers use these annotations to
> > compute dynamic object sizes via '__builtin_dynamic_object_size()' and
> > perform runtime bounds checking with KASAN.
> >
> > Add KUnit tests ('counted_by_flex_oob_access' and
> > 'counted_by_ptr_oob_access', guarded by CONFIG_CC_HAS_COUNTED_BY and
> > CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:
> >
> >  - '__builtin_dynamic_object_size()' returns the expected byte size for
> >    annotated flexible array and pointer members.
> >  - KASAN detects out-of-bounds read and write accesses beyond the
> >    annotated count.
> >
> > Allocate the test structures in 'noinline' helpers and hide the
> > returned pointers with OPTIMIZER_HIDE_VAR() so allocation-size
> > attributes and compiler optimizations do not mask the '__counted_by'
> > and '__counted_by_ptr' checks.
>
> Thanks.  Are any of Sashiko's comments pertinent?
>         https://sashiko.dev/#/patchset/20260928231737.2092716-1-morbo@goo=
gle.com

Yes. I found a better place to put these tests. I'll send a v2.

-bw

