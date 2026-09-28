Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C2D2CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0EC66B0099; Mon, 28 Sep 2026 11:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE416B009B; Mon, 28 Sep 2026 11:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986DC6B009D; Mon, 28 Sep 2026 11:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 748F16B0099
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:10:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECD49C01EA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:10:07 +0000 (UTC)
X-FDA: 85263506454.12.21BC323
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 003AB80011
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:10:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RPudxE/O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
	b=KlQdEkQg9US5jurohgazUB9Sy4321iHqU+eQLOxACvoEhigmHMCwTKkTM1x5RP0R0os+DV
	iUmTpU5fZnEEySmzRIwne0rB28ux26MwKkKPccQbrHA0W5LGsBd6wAWCoOy+ll6G+NGZP9
	c5cqjzYNskJCwatyiqB4puKtCcfUWLQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="RPudxE/O";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790608206;
	b=Ga4VZl1FXC7sQUSq2rXUiutQ1gfj5IDN1wS/03/Q1bfABJvSlsV+xvqRXrghNCzgb1ytB6
	H3fTqE3ccbWeOjePDfo4fELOYj1EN+SXMiZwgx+p1UkIElvoBzFbb4GyNIejT47hC9Nfbm
	S1MHUX2SkgHtU/NXQAQcK13Cm9fZbaU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49e6425f96eso98305e9.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:10:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790608204; cv=none;
        d=google.com; s=arc-20260327;
        b=rq18Dea+4TzAV4sVuFl84YrvbcbhLOkbcnOkhOIoh3Be7g1wgXB2fwwH39SPAzwWwt
         fNlpGDltTrN9t7M7CfXrK7YYA4w+Q+wxmOw3GF1oOlJ9HQgBR9S/ljPFOjnCju3iuNye
         zHPI6aSEagreWSbBlRv793Z3OCv32LM8VSf4pCnI8DCCOg5ANU+jRY5bXqQ1EIm3KJKr
         XWTeroHPXg+keZNiGrN1Dd2NxB49f/vAG+6L013QjZdvmiUzf0sXBcQqGWfQRCaQ0vkl
         pK8yKqLgx18c7Q/jsMkDWIYd+lMLgdS1JEoF/04wEGs7cbD4ttfhgHBaJUa27r5p2P1+
         OrcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        fh=IT4e1VSrs39AJDZh8vrId6T0nudYszap7jOwkKpn4b4=;
        b=q/q+6WjAxI/6gu6HarSqv3PGnh7w1XtVaOh7u5b6yQ07YveZ5MhNHuAbv95dE+DAjm
         fJU3LIBWAxggUyipC4cFnOijJk4J0NWm/+tsP7H0Jmhx2wuOrG2GacJ1yy66/KUKeMhw
         M2FaOtWiiKATvg+NNbfu8Vi3A+79Yctl8ixGWo4mjK+vi1D5YGb1H2VlVp6Qa5Sl0OGL
         LCxxayxb62XzIjnxJvqm2hxqpHw/zN/AKhxhv465BJFCK/rPDKo5mrW1IwaRdLY9Tgia
         uey3pWyZaz4+queJyvC8XqLi1pKq2zdbNotR5YidKBcC8kKsSiFaZeXGb7hBvKtSjohs
         el1w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790608204; x=1791213004; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        b=RPudxE/OKk9C90xHdRwq63DCPwVVbt+U/2ETxZVIngBM+gWotrzigg9D5YUugTirsn
         UWAiXDTZFO/J+0F+RCmri1Q++PAeLhGULJzY9AYOI+FezP7LfFvQIWNKpO0RcnIbF+9z
         29hPJuqXKi4HKbHybl9IGSNlGEd0/H4OiQ1hVwefW4N3+12SX0bnt/F6LsryyVtT3c6t
         4R/esNNn/J2fH1vP5gYskTd7XH8tO9G9VSTZgvI2r9w017Q6UOPxxNXGqUeOFXeYBg1H
         qirktlxwzpEXZg85AP6xG7pXGLQQc3lnTVE5M6siluHCHm5SlG1H/zIES9LfDIynA68D
         XlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790608204; x=1791213004;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SOdnKdZSsp21Wh1GtsWQOZQyXk9VHFHxURgHVJL/kIM=;
        b=EnxXq8HVJxfy5Icf91Wxq49pfyFZU3WosIV7iZmm0Wb20tu7jLo/TO6BwnPw3ZpdpA
         cnc9HBojqsqS3wtuhzxJKbrE7sRtAU/geAkFp6J/HjAGVRtuqpY2dOy++ZlDwGvvQ46C
         CbFVmsiGQw1+bQ8tSVl9KOj4CBZ5oHTsHC9+ClTpCDQfMZmJG4IpsTNJrBzmMo77oIyb
         bhTKpLsmGLCI9+wq15l1J6gxebw0L7jBA3ozvUK7H9KUjT2gcT8p5SPE/jP7L25pt/G4
         2704tS42nDHGyf/cvQW5PO0Sqvyk0f/PjijINpr5FQ/9n0cwSuyTLBe67p5m5KQA+lwt
         kkng==
X-Forwarded-Encrypted: i=1; AKwUvBwYMxqDL+gDHpHSI4F4xXTgB5W6eNWpJLckgvrmzI1o4BXguYqy3deROEZ7sHjEKfHA9cj6q/vl4Q==@kvack.org
X-Gm-Message-State: AFuF++lBM+DUHN8i3yA2N5SrahTtBJRi4mbPQi15YpkFxxpYBplvSaBF
	WA3Cxls2u5XyzakLtN9p+sm34jxtWyH4ZM8GN2Wf7nZwUnndnD0jP5hk1hsRD+SHszQh96dw63o
	PXfSDo8HbY6JNh0xrip2z7zAOG5dUUUXYYXxVtJih
X-Gm-Gg: AYBFou3GEe9FlWTf8YURPZDKuen4nz964TJ/9fCqpQJOpSt7xqR7Ou4G3gJ7cfmBLG3
	uS+SoV5JQwEsfwmgKHOV/N7CqVAClfZntRaJaMac9BXSsWo84xh67kgsv+NU6WGvCrZ7jqY6Buq
	djIj9AM9iloTcgRiDkvjnt/qqCjd+w1i1f4bI/lh0/tp5fep4Gz4sF1KNF9YX6+yrOGPmKh3dmf
	AqkCCryqUyP0/IsLmq0XV3c9PHR9r70obonu5BRC3pJ/gq18OOUPZBujJ5fuPvzDwMRK20fc+30
	IwDoIOXvmBecDYhRq8cjqUSsmTzoBYT3JH8Q66UW+/gpF01iZ8bkxTQmHP/RN2mDJ2nlCgjvYWf
	iOrOyA0ONstVYttS3DVBceWYS9CDHry5+6cuY3gt/O/9CVQ==
X-Received: by 2002:a7b:c049:0:b0:49d:21ee:1d7c with SMTP id
 5b1f17b1804b1-49ff9060be0mr2197165e9.14.1790608204011; Mon, 28 Sep 2026
 08:10:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260926054205.28933-1-sebastian.chlad@suse.com>
In-Reply-To: <20260926054205.28933-1-sebastian.chlad@suse.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 28 Sep 2026 17:09:51 +0200
X-Gm-Features: AclHuK-UI-y0iD6O63glrzneLIs_6v53JO-jYanPzVVSviUMa6FZaP0zTiAkdhs
Message-ID: <CABdmKX27xqreLSwf0u7F=abmVNEKhMFj95WjJVQP=+QZsWH5WA@mail.gmail.com>
Subject: Re: [PATCH] selftests: memcg: Don't hang in the inotify tests without IN_DELETE_SELF
To: Sebastian Chlad <sebastianchlad@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Sebastian Chlad <sebastian.chlad@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: k1i5z46jtjsbijp6xgtmejnasudhj6kj
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 003AB80011
X-HE-Tag: 1790608205-200486
X-HE-Meta: U2FsdGVkX18wjyqczP74zofJsr5wdKK9fiPump6q9XNs1LgauJlMU48V98SfshRA9Wot2uGjLV/9FDncI1W5dBZ/ULRArLvzzNCuy63NM0LT1FITlggCJQNsP0yezY+EIsrllcIQzmcCA2kc2QOP8vzK3VzdoVmDUd3X7EQ5rAEiRgpDThReFbPs33rGlBJmQ3TgoNXSBUQjfFY23rb6z9ftcEb95uKUpL0Oqk0xUOqzJX1P4gtmhI6UvV+AmErukvi9+qsKVzbuEsraKjPPO2lhzxiJ9TSYav9AtgQ8Jqf/NZrx2NE9SNt5HZyRWmDvP0FBIgOehfps6Yd9g/VZbV+jugVD0vVXn97t8lT1NcQufOtO57ASBhMrzFQBzzOcC214P76TC/OeZ4MK+V/5opCFBAHFjGDV/qtV5vi4+fMn6HrRxaacZiL9LhQqohuzbMcKIKAycRntmgr4UlueYb9igvhcwgvkuEEHl5qAvf72Nocj5vyIDBm4UWCFyS2xJkTQ88P3RCNlmL4Ra/7T2F7byksj0kp2Dp7OUd4HQazgxDMqL5A16hPp6Vr8fxMq9e1fZfNeI6shpIjU69xO7a8ZZo+3bwDkIm9hUrgYw7tkb0ndS+zXuAd78MzHU5TVT7OgkOkjssqWc/UkOzhOLw6beh/gWWw5OStjpkBRTo9rdQYhjIqMgTB8skaBHUb7c2g/TrKQV1wUBW3Gm5QdIE2DGLhkqHfj/oEJwgilFLLb6Dzwug1mcozk3J2lXpQOXJSSDUU0OMuwWsoBX+GIJUg/KJXtPwJWAvMLZ0tWJRWqj+AC01M9Y/R0si0I49RnGmsAAd/o/l00wZSj2TwszZbmxA6f/3wBrslpLvOGZtabd56Qxc3wdCIugCaNZ8DYXOhRjeD2o4JLItWCSJ5Jck70DlnO9n8oWkCRkPWaIS5cLuOd8atF6NH3lDuAc63mDSWddgwzJquyVAC9pJe
 f+JXoDCN
 lGJGEheUntHdOlcMkbjE/UovOW6jxZPsh+uK/IJrJxY0c79pPi+C0AmVQox1KUU8KS1MtVYV7d6jorAPjz18Eo/INRFCyEQrvgggjpFc667wyeyt3JLBY7lCNhkPFL3gbtHuEpsU8C9Uflr7c7qlu45itKfc5hAaoTQ9/bFeW4+GiT0bE/6xNZG5YbYxho6V/as98J6wirm90zWwn4D98f6tSe4qb4hQ4I2EDawKsKOkHpuqwULHQrb+bjD4UOIrJPC51THvLnrkCktqyjaMYK1Q3Bc53h0peKFX0rDkUM5s0CFruZnvIGtPs+Fz3DjNT6dZVa+5+yFxhckSLnR9dHM9YziqPucQHs96BLD0V7OBMMdHdxtMsW6gr5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 7:42=E2=80=AFAM Sebastian Chlad
<sebastianchlad@gmail.com> wrote:

Hi,

> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> wait for IN_DELETE_SELF with a blocking read() on the inotify fd. On a
> kernel that does not send IN_DELETE_SELF for kernfs files and
> directories, the read() never returns and test_memcontrol hangs until
> it is killed by the kselftest timeout. The remaining tests do not run
> and no result is reported for the inotify tests.
>
> Wait for the first event with poll() and a timeout. If IN_DELETE_SELF
> does not arrive in time, report it and fail the test instead of
> blocking, so that test_memcontrol completes and the remaining results
> are reported.

But this polls for every read() through read_event(), not just IN_DELETE_SE=
LF.

> Assisted-by: claude-opus-5-5
> Signed-off-by: Sebastian Chlad <sebastian.chlad@suse.com>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 27 ++++++++++++++++---
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/tes=
ting/selftests/cgroup/test_memcontrol.c
> index 0ed82347044e..c00420acc9a1 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -11,6 +11,7 @@
>  #include <sys/types.h>
>  #include <unistd.h>
>  #include <sys/inotify.h>
> +#include <poll.h>
>  #include <sys/socket.h>
>  #include <sys/wait.h>
>  #include <arpa/inet.h>
> @@ -1655,10 +1656,20 @@ static int test_memcg_oom_group_score_events(cons=
t char *root)
>         return ret;
>  }
>
> +#define INOTIFY_TIMEOUT_MS 5000
> +
>  static int read_event(int inotify_fd, int expected_event, int expected_w=
d)
>  {
> +       struct pollfd pfd =3D { .fd =3D inotify_fd, .events =3D POLLIN };
>         struct inotify_event event;
>         ssize_t len =3D 0;
> +       int ret;
> +
> +       ret =3D poll(&pfd, 1, INOTIFY_TIMEOUT_MS);
> +       if (ret =3D=3D 0)
> +               return -ETIMEDOUT;

This mixes -1 with -ETIMEDOUT. The lack of consistency for error
handling is kinda weird.

> +       if (ret < 0)
> +               return -1;
>
>         len =3D read(inotify_fd, &event, sizeof(event));
>         if (len < (ssize_t)sizeof(event))
> @@ -1678,7 +1689,7 @@ static int test_memcg_inotify_delete_file(const cha=
r *root)
>  {
>         int ret =3D KSFT_FAIL;
>         char *memcg =3D NULL;
> -       int fd, wd;
> +       int fd, wd, err;
>
>         memcg =3D cg_name(root, "memcg_test_0");
>
> @@ -1701,7 +1712,11 @@ static int test_memcg_inotify_delete_file(const ch=
ar *root)
>         free(memcg);
>         memcg =3D NULL;
>
> -       if (read_event(fd, IN_DELETE_SELF, wd))
> +       err =3D read_event(fd, IN_DELETE_SELF, wd);
> +       if (err =3D=3D -ETIMEDOUT)
> +               fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
> +                       INOTIFY_TIMEOUT_MS);
> +       if (err)
>                 goto cleanup;
>
>         if (read_event(fd, IN_IGNORED, wd))
> @@ -1723,7 +1738,7 @@ static int test_memcg_inotify_delete_dir(const char=
 *root)
>  {
>         int ret =3D KSFT_FAIL;
>         char *memcg =3D NULL;
> -       int fd, wd;
> +       int fd, wd, err;
>
>         memcg =3D cg_name(root, "memcg_test_0");
>
> @@ -1746,7 +1761,11 @@ static int test_memcg_inotify_delete_dir(const cha=
r *root)
>         free(memcg);
>         memcg =3D NULL;
>
> -       if (read_event(fd, IN_DELETE_SELF, wd))
> +       err =3D read_event(fd, IN_DELETE_SELF, wd);
> +       if (err =3D=3D -ETIMEDOUT)
> +               fprintf(stderr, "no IN_DELETE_SELF event within %d ms\n",
> +                       INOTIFY_TIMEOUT_MS);
> +       if (err)
>                 goto cleanup;
>
>         if (read_event(fd, IN_IGNORED, wd))

This IN_IGNORED case now fails silently while IN_DELETE_SELF prints a
timeout error message. What about moving the error message up into
read_event? That would address the comment about inconsistent return
values too.

