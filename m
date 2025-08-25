Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C38CA0EED
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 02:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745F66B00A7; Sun, 24 Aug 2025 22:53:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DCC6B00A8; Sun, 24 Aug 2025 22:53:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633C86B00A9; Sun, 24 Aug 2025 22:53:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1946B00A7
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 22:53:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFB9B117C21
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:53:48 +0000 (UTC)
X-FDA: 83813759736.01.2B0769A
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9865140004
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:53:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ealP5AOi;
	spf=pass (imf09.hostedemail.com: domain of allyheev@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=allyheev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756090426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuQEOF8lXWx0tyN0E34X9QSFDbgyKnv6vJT8/V1kPN8=;
	b=4ZLKEwh5C4GH1zW2X0oDcGORYp8dm3qCMmdQojCiFQyPVoQ4/wJaZeiCmmbQwD0b6xuZA6
	pe4WMxBzJy9kDMqNkyOtbF/MZQSFqxG2Jh3S+J046NH1wRbNd/2tYNerZtJ2Pe45sZvb5B
	11XZ4/Pserw++bSFeriP38JtXwLaRsk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ealP5AOi;
	spf=pass (imf09.hostedemail.com: domain of allyheev@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=allyheev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756090426; a=rsa-sha256;
	cv=none;
	b=uEiaj8HuKhbXgDCyQ8otu3rt5YbwGB3p7vxC9ITD1g5JewcVUzZR9+jtF6vy+JlmXJNRix
	a41el6to2QxxRiKUyHvHAE9g3H9cV5PhO/fPW1QPdtDsVe3sYlj3m6d6lsqYY4MzS7zC3o
	7Dvt+WwOny8bUPbJlkdki+7GTlEy224=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61c5272afbfso1608296a12.1
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 19:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756090425; x=1756695225; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuQEOF8lXWx0tyN0E34X9QSFDbgyKnv6vJT8/V1kPN8=;
        b=ealP5AOia3um2c2FKZg+UsuowHguFpt+Wj2NLGKoOtQSdMoGIOyrVpkn59uNuzNLKM
         6NjChWChfD9u4c93nFvHjNjz1pNq/xDYfMNTnsSTYAKz2eWL3wGWBiTsaK7ir40g0T26
         E1CoXo6G+rqRnuG+R7gubtJOjvDlnLE0lT8ck5nlApa7KxQaw/Rnsnn56tfSuJzFg5yr
         X2iRctt4LrZMggDdmhzMVu3qEUH5Y7MlQUZcb9xPysFKM2FP918nsXy7Mz31+rIDSs3P
         hzRyW3AqqP3OrRLh65LY23Q8jqAVrJ6ueeezfuVoi1C4MTTTMH1+To4V8D1Kf4P6yYyg
         G69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756090425; x=1756695225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuQEOF8lXWx0tyN0E34X9QSFDbgyKnv6vJT8/V1kPN8=;
        b=kb8HuN2wgeLyJmC06IMT2km/KNUnysc4HE+o+c+FwYVfYcVMylnf5UQUTetjoM9c0R
         ZKfxfVZYiyy/PDPaFD3O7VHM1QHwE0TlB2Ra6y+NA4oOGoirBGZlmgdbliaAupVYe29v
         9eUujCt3wbAFh/paA3LRs2ansvei23bGEoFZKT50yr5vQ3YfejTZlJCA57piSbGUwb17
         DJwvAOOLSvzbRgxuXhCQPbrCdwrDEcke/QHaupylSws0G2/0l+VhFehTIk3E6fAmTwsd
         St5k6e4zyy7LyRfjzntmXF9FvIDrE2+C4iWwhrwN34rDo7yf3waMfxgVGHUEOSQGKhJO
         +eeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFcLxbQ5TdZU7q6poZ89N8Zz1rOrEW0O5tPX7U3uiyB9ra59x2otBByhi/3+Mrmp8F3nAxAetQQw==@kvack.org
X-Gm-Message-State: AOJu0Yyvvbb4ooQXA3wk8vimS7Hrhy1x4zpePqkojtJoowTtvwgXc0Qg
	BvZdm5/jAWCySd8e9kEgeyfs+rcPxtwgnXZvfaPno4sqRretqJNj/jx7ISXUKWe0oy2tjdvpPJL
	u3ESavdK6OU2WO7laekQsEv9uZb/O/8E=
X-Gm-Gg: ASbGncvD1WCxZyK0KCy6201EWejGXDC5y9S+jvG9CiG05RkSIYxvhFqlq8KopXusH8F
	pjkCygEeen3d/q7ZYOLYWnzlcA5F8Kp56ncgXRQAZ9lMtI73gMZd76Eu1dt6yi33gIEGEwxdYvI
	JuXHQ5mbax9sgbxbUTAOYAIy0DOiDIiToIP5nTVaGwLbPcj+yCCCV6PTfSF0RryLNj1qEAensIC
	jSSjmRZGh8x2SFUo9Jl4lVYtEKuQvvp/DbdOzNuhu5mzsYnguSwPBWRQF29U/2VbO7TQEXuMw==
X-Google-Smtp-Source: AGHT+IEU1FlX6VqgN+0TONBTh6JTkrbGtb1BTJ7rjrRMKFIkmyRa22u+pADcYFGDkQRMTM+s2m7G/3I2ftjPQejby5g=
X-Received: by 2002:a05:6402:27c7:b0:609:7ed1:c791 with SMTP id
 4fb4d7f45d1cf-61c1b6f5a6amr8602984a12.32.1756090425106; Sun, 24 Aug 2025
 19:53:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250823170208.184149-1-allyheev@gmail.com> <aKq25rlqbyYDaWVo@pc636>
 <20250824171722.ea915592ea3bd060c6b17a38@linux-foundation.org>
In-Reply-To: <20250824171722.ea915592ea3bd060c6b17a38@linux-foundation.org>
From: ally heev <allyheev@gmail.com>
Date: Mon, 25 Aug 2025 08:23:33 +0530
X-Gm-Features: Ac12FXyys5mnbxszcX8Pac2LI8BHvZ5qDrWuATBA5w2UNc7UXOxjIJmIvIcS8TQ
Message-ID: <CAMB6jUH70j20WgJ9TD=Lsy21XktDG0PqxEgjZ7XZFvcus9SjkA@mail.gmail.com>
Subject: Re: [PATCH] kselftest: mm: fix typos in test_vmalloc.sh
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, skhan@linuxfoundation.org, david@redhat.com, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D9865140004
X-Rspam-User: 
X-Stat-Signature: 1kru8rz7ca6ziducpsrkkhbpwzzmaw6h
X-Rspamd-Server: rspam09
X-HE-Tag: 1756090426-749991
X-HE-Meta: U2FsdGVkX1/qf4AnyZh5b6NuOIzup5Chn4TG5pVYI+Z1/7o828GUpVzoNUnPmRRrBLZ1R13dk0/L18iJ6K7YqvDSqVpnFhxhLm67qj5K24fS3dA8jaeXtCJgIlkQgivdC37DXXz0U13luQHh8O4MBZbz3RXoaC7K4HEaDZIfoLct/53sUc+K2DZlWRUsSiR4RWPQWQGDtLn2XPiiodVcU7JvgjpwPI1SOtPZ3l/7R3vWJBXf7N8bKooOQ7d7K6HuBohRWU4Nqpy9QfA+Nzzm5yjy9bSnsQkCy0V720o55Wtf+2sm1xdcUV3ZfriAGbGZYrbsBDwnRbg8X7/iVkCmfZIjBdiCmIpc/wqQdsauSn9EnObs2JRmbf3kKD4SnXiMU/2/2zfWPxeu4OK8tsT1SXLuHgZby80XJ0HvrgMObzKjAvFCo7NtkMyZvW9aZgrP+mEdi4j20c8bozUSo8+Ma6OZ8NElOqm4irbz4K3DQfFZAzkr9/RVzsc6a8Efxh+GHeVDSSgVnrRI9KzvLkkpY8K5juhkDqJl2gk/Ec6/IgGnqbx2I05Ye/HEPxPDQKj3pwGZvaD/04xEuWi6/1rqVSd/cJTaxTbJ2fHlV3PTaLneJB0LMiFO5s1QxZtMcqWuBHO430TUQNAAP5kA3AOjW2TEyibEKHowVA6ETtmvxYZuqY6lKl/PyAy89OoBGaIg5dv6sFnlF+n19QNLZPDD3zHy5RAcZYxMUXeZ6DP9j7sSIqyACGjO8mD8v5q7wkex0N8aFmcLZ94oE8OD+Qmbi5p8EgqtpEuSQDg5C5fehh7e37KhdQwkzvfGIe046P4IQAQMXXOWwYKbon+tcGM3wlKUG+mNvc1aOaJlClZnEHSDYSVHYYTqaupt4n4hnH6wVYQRmu662XXF/MXipwLlNh+cusS8lw6yYre2ncbePb8Qvs+HNsdLrGjZCxVnhXp2gl2tQZ7QcwWjQyNeBOq
 cd8v3800
 WISsOufYYfjseGENuXl9vz/NRNdDHXPOpsmbug2TU+IAIj0CsGED/ExlxYOssycgjcNZVyCHO2LjpR7M6lwBr53LEWOBuTSPYVDSmWCkg04OxJ+j0GxzDLKNg+6sehHpQ6fAE1Boqna0PVSAw1xScTqa8015EX7qJ3fvzyshJMDmRFodhiNEgvg94fixNdzTnn+vGy09XYcV71YgnVz5W8LWJi7CGinMKLDCJ33l4JaPTc8JTU5mK/OLon+8xkndQkerGC9juaKtTgSZozoERELALz9/+mszsR1ztmGs13kxd8iwBMCQOWrGf54IlNKn+w4Wh6oJMg51PWewccPGUMLxQnR2wtrsDfm0nx1qisFDc1DaF7ddFr1udnfaFXAe2ZTkPUPECqvONBu/aelhVq8P11lG5pimon92ugxvWikwCZ/oHzF2q/VvO0VGXv1qIrcDCv6G9EgVWMsQDsO1ntK1uXqCwv+EokLBK+lR/M42OeHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> A changelog would be identical to the subject.  checkpatch is being a
> bit excessive here.

Yes. Hence omitted it


On Mon, Aug 25, 2025 at 5:47=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sun, 24 Aug 2025 08:53:26 +0200 Uladzislau Rezki <urezki@gmail.com> wr=
ote:
>
> > >  run_stability_check()
> > > @@ -160,7 +160,7 @@ function run_test()
> > >             usage
> > >     else
> > >             if [[ "$1" =3D "performance" ]]; then
> > > -                   run_perfformance_check
> > > +                   run_performance_check
> > >             elif [[ "$1" =3D "stress" ]]; then
> > >                     run_stability_check
> > >             elif [[ "$1" =3D "smoke" ]]; then
> > > --
> > > 2.34.1
> > >
> > >
> > ./scripts/checkpatch.pl ./0001-kselftest-mm-fix-typos-in-test_vmalloc.s=
h.patch
> > WARNING: Missing commit description - Add an appropriate one
> >
> > total: 0 errors, 1 warnings, 24 lines checked
> >
> > NOTE: For some of the reported defects, checkpatch may be able to
> >       mechanically convert to the typical style using --fix or --fix-in=
place.
> >
> > ./0001-kselftest-mm-fix-typos-in-test_vmalloc.sh.patch has style proble=
ms, please review.
> >
> > NOTE: If any of the errors are false positives, please report
> >       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> >
> > Can you add a commit message?
>
> A changelog would be identical to the subject.  checkpatch is being a
> bit excessive here.
>
> Oh well, I'll add the obvious text.

