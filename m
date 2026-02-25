Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A05F55431
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 00:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00FC6B0088; Tue, 24 Feb 2026 19:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ABD66B0089; Tue, 24 Feb 2026 19:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888A66B008A; Tue, 24 Feb 2026 19:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8A06B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:23:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FDAC8B5E9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:23:46 +0000 (UTC)
X-FDA: 84481080852.28.AD6FE78
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0257B140012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:23:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwUzYfYI;
	spf=pass (imf09.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771979024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uamfHDmCrLi6nzaR6RT4ftOE05lQx2cwZblWDDjb7zk=;
	b=AWV9IO0LP2NaauxMIgCYYrcqmEpoVBMS7//h1IUcnBf7BWf1SmvhvKHoLAM/Vhb6xUUcTb
	mbgFkLJcPl413XMd7CT1SLvg7LXubU0myp2OUE41ukvduvfZ5ysrjO2Xgs+aDdWpjOsV6v
	3BKWxZBlcrmJhDr1ULuI5jfb6+uAQOA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwUzYfYI;
	spf=pass (imf09.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=avagin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771979024; a=rsa-sha256;
	cv=pass;
	b=OdyzjVAhzM9t/CFbMWyH0NGJ3GJceDMVFtH+TKWTWY7HAtZm08OT9ZgU0Zqn/J6u8zvffB
	GESF+bu1gtuOmlp/W5usbzi1agRO8pCiB96H5Vn5P4A77ETDPLXZOSeOgHsHaE7c3Z+LAh
	7VonHCdmvgOMRGoGIrXbGN2Hb90oFyA=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7d1872504cbso439260a34.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:23:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771979023; cv=none;
        d=google.com; s=arc-20240605;
        b=W5oInFLEQt/+BV5Ai3ccIUVzzDg/IQtbC+tkaQ6yfoUvc8YxH8/Jna3PBYuCbXIzOh
         ddYef1H9EYNZ93N62Q8DN5LP3yV1zK5hsw9/hepyU5CxaTvDR8Z0eCY+LOtqAyiNj7We
         V+vOc3+g6oHbvx2pMJDwsWSyltdz31nDQX/BsUgxEYvURUV25pR5uEhTS/tIvr9l+adO
         M1WxBoP0j4Ur8MYYFDt0xUsu7QB7okY4EoUgFHwPKDLvMRpsmOZFyyWrM4pW23ruRc+E
         37dhIBosQVflbWZTBt+DMZQC9EDiK/2Aa5OP4EWAvmmimJsQ9WdYaeS4zgaFgM+blFEX
         Go3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uamfHDmCrLi6nzaR6RT4ftOE05lQx2cwZblWDDjb7zk=;
        fh=VUdPUU6X0LKjTT9Cz0Op754vMLYiBae5wLMr4WHqgmE=;
        b=cWkYlw0PEMImB3x0v2c7zVfgQhm+ZKyBcrRbBFein9zJmRNR5lpTQ8t7wPLcSPu1E/
         B236WsP+HLEbXuoInrTeMWV6WpW9oG6zI8Rjfcm1UQ5+njI/bt3YwKYGp0h5llwsLjN+
         IzRQu4Uk4q1pKeN+3Yo3ZOhPRrEBhid6Coqwqug9rxjRsgI6EqP3hS3f60XpWRUJtGVk
         HZgP2pXuAUqrDnEbgsgiGAzKe1cObYv7UfkGWY5EWsdBZafbmFykvq7iUVN3+TZOheR+
         gJf5TLtgef0b0jjW2DsvhGNHMO3ynP2CxNsfspNnmEcxdh09+1/DL0RG5UumzdczhIy+
         +HNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771979023; x=1772583823; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uamfHDmCrLi6nzaR6RT4ftOE05lQx2cwZblWDDjb7zk=;
        b=cwUzYfYILcXi3xKZG51+91D281yPoQSHsQ9hZEZcNYjazj7KKZXE5US1cWHd/OL0sE
         fjDvWUKmB0jpt4kUFE7SB1pxorw4h8UxysjGwvVzeH9s1Dyuqz0VdKFBoSgQ67kRND9B
         SPQNdRwgjEhGgwWMkGioU6OdXlYt/pPgdFaYfkqBaD93RkO9g5mzAystzq9QUc1/ZGD7
         doW3LxaF0K6YqxjT4JD6HI85avHOKgsw7gAh6Yw7ltJsPtKx695d0l49Uj86ryxFdgUE
         pVoJQrUreFkcr8Jp+DRlAHEiG6GTJgNE83TeRYzf9uehcofy/EBu3n5J/5aNA6u7TcoV
         s+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771979023; x=1772583823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uamfHDmCrLi6nzaR6RT4ftOE05lQx2cwZblWDDjb7zk=;
        b=PBkfFhD6LSTl3Crk1cH7eCE9HokvDzMzHKnyu+ABkXQl/xv39cfM1U8kGml5QqmKBZ
         PO3YbF9dp0R8SVzsFEmjViye58561W7jY7IS7/FN4zdHRrbNmqNY7M6b+8SaeH0bkV1D
         /2fvxXl60slvC+a8Euja9tA2Rx4e7zFOEHlYnTPb0uKM6PTEb2uHHEAx/8rSqkcuaqAu
         fZsrXbkA50jmy5d80TX3Mp5mR54w0SrUjtnUiGaavdJT7Qw7kI4noYXKgq7jKpOBY5KZ
         zhXPPXg4xQ9nzv3439PA0QiaR0bHYkIqOCqTARwOkSkihHkcc1KSNBNUch6V2yZu0Yuq
         cCEA==
X-Forwarded-Encrypted: i=1; AJvYcCUP7z03rYTe8h78XZzvuid6EjBGAjbLjZTBxIP302+pBf9iqmVmmo63flrRmytyESySR9ohQl0e+w==@kvack.org
X-Gm-Message-State: AOJu0YzAKmvVrsbjamSYdXjFmsFrONl7xTLrhhi2Eu/9tI72Iaw9znV6
	w+S7KRzToOEQ6BeA98/dRdU1WSrJ2d3iZcj3XjUd9FR3yLkPMHRjEtQgkQNR9JTKtSRAN0zZY9U
	W9SJtQmVuSGxPwYZcOyXJ13gGy4IAdjk=
X-Gm-Gg: AZuq6aKiuNQL2sZ6teqKs0cP/tGJy3Vtn7LqzIh1Gk7ohAe5Gh23Y23mwe+ugMbuxqd
	QSkYFQVMuuwDuoxwiWuzmWpPmuznfxmllvDuZMGM8pYMtwagyns33/1li2CdUoO48ii7GqLx3kR
	0voSLGSDiTfCKqSFtW3Sj0OMIbmzXkfvUqwfeb0x42Ue5KqylWnnEsKOgOOTxOQ1rbxYDcYqb3x
	30Mg7v5YflcrDm0NzLtO5c0FrDZdqJlzW0hDdD/l0TVbe8dkpHkY0yrEEX3sAJIZmnTSiX57eEm
	1qjCfiQ=
X-Received: by 2002:a05:6830:82cf:b0:7d4:ba6d:e33b with SMTP id
 46e09a7af769-7d572f732e4mr1157163a34.14.1771979022917; Tue, 24 Feb 2026
 16:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com> <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Tue, 24 Feb 2026 16:23:31 -0800
X-Gm-Features: AaiRm51sc6PYns4iCYnbIf9VDxONZDk0EGBX4WlziIcqv7s5ocyQB1y1CIul7gs
Message-ID: <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>, Andrei Vagin <avagin@google.com>, 
	Kirill Tkhai <tkhai@ya.ru>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Adrian Reber <areber@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0257B140012
X-Rspamd-Server: rspam02
X-Stat-Signature: mejprorttphz74sxr3pssar4rnxxakz5
X-HE-Tag: 1771979023-17643
X-HE-Meta: U2FsdGVkX1+IuuFPBseCxAPlninUtqxkYbs7KldnPe60SXFY9HTMAuYG+XMSbNwcPb1oiBfooEe2Z09J2xp669xvF52j/g6Kafn4N00RlBQDHTRqs84UGF+pRyaIisEANHAJLRE+iDWMx9VNq8/P0Xs2zDGDG+GyEbCw8J+yp1CirJLbLUmUAEWUAlPXHe0xKNhTwydpWbMfgjmCQ3/AnFQ3A0oFVQMQh9iyPUIuGBs4hBVf7Y1qVAEEdOPj4hTBtxKTFI8NWVTtRlBW3tadMYT7c8dosgCGBWAyOw+OJMJNTZGGraJO0NcC2LHrBIUxzuDODrPwjc4LcJW7BWM48we3ggN2e/X9WkmIO2prw3hzwdZwgGE5Za0Vs1QorCSUbgKONIU+DsZOCZ+3B1UK+U6mAm8yeXaFXV7o6In5RwCF3Bg+mljCMsttxes9ywOcCYBRaaGBcqzAkyQZOd/zJoupvh5Gj0oRPMiuLUgIIE7faAH0+CArkBw0U+7CFYYhtsqcx66c6L79KLc/XXX5hrbfGy4dgSieAipwNNW7chY9BrqHnq2pho3DkbxbRu1Wuv0TRU4EU3AMj8CpFuySD049rnEk7eUWelGQisbNWaatmVtDWU9KWwIpQ8bYuu8ToSlC1F2t0988SmVT12RvmhInEKLq3BT5ekJWyEv6vlqIEcqQ72SLOQ4kih84xGZFa4FSZ2fkNVK1H23/kpqQsGP/Qr7ppI6g6DCRuOYekjFg7SyEGZI+mKzS/tWcQrDOf6VaNDDWlqZWe7o0+8GztED04A+3pzblyu79ZKv2olCDT58RSSKyD0fMdS9BCGpJ1rjHsst/fTjfAy8f7lTK9bMxHIEq5an7gWOpcerpABliRTZ810+Y2Z95cON060x3PJhY4/xrsjvCprvtay4UzxG6kgY7mpTEXD+mADHqaTRULLUu5EODpVNtWDeTgyczEGrHQWK9+H1/eP9LOxt
 CUZ1tK2n
 uKOjIRk023O5bWnStOGuIKWUC4o6sNcZ0qwK9rynvz3t/dxbWWRJH8NMQL7qzrXSkhiCv2/K3bsIv7HeIPg6i7ZrY+JLhgA3ewEn49dW3nIHi8KMmEEfIHj8pODqL5IYwGZewq+Xjwi3Pv6YSySdtDq+EOlGBu2i/zbiNNgvadY0U64e3DQqsnqVe2uVlIyknkdH0ZrBb03Do5vXFmdqxhY1jue1WK1+UcZ4YbWt3k1reWAa7AkDzA0Bozo/AnetoywEqbMhrwD8D3/KaNYGyZpvk390unuaApdiYloTqfIf4mm6VoX2unGAUuMM7zOQ5wwALPQryMIoy8S5W2M/mrbRnzJQcyo0KZKYYxIAQSV5L9a8P7JfCGL1DSInfg6UHY3EqJSf0FhzPAXFvb15a8/kJug/9KZzI544o6rI1uz09wctr9Ijk0xI+9CwnnHqUuaEEZLwzR6C2o5psjZNwI3Sk3Sn7BX8dPyIdCG1trluKCsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 9:02=E2=80=AFAM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This moves the condition (tid !=3D 1 && !tmp->child_reaper) to after idr
> alloc, so it not only covers that first process in pid namespace has pid
> 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
> itself gives wrong pid for some reason.
>
> This could've been the case before this patch, when creating first
> process the alloc_pid()->pidfs_add_pid() code path fails, so that the
> idr->idr_next is non zero anymore and next process calling to
> alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
> leading to init-less pid namespace, which is a bug.

I don't think this is an issue right now, as we only allow one attempt
to create the init. If that first attempt fails, free_pid will disable
further PID allocations in the target namespace.

It is a sort of off-topic, because we will definitely need this logic
with the next patch in this series.

>
> Note: This is also a preparation for the next patch in the series, which
> will introduce an ability of creating init from the task different to
> the task which had created the pid namespace. Needed to make sure that
> init is always first, even in this new case.
>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> --
> v3: Split from main commit. Merge two checks of ->child_reaper into one.
> ---
>  kernel/pid.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 76c2744493e2..ebf013f35cb3 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_=
t *arg_set_tid,
>                         retval =3D -EINVAL;
>                         if (tid < 1 || tid >=3D pid_max[ns->level - i])
>                                 goto out_abort;
> -                       /*
> -                        * Also fail if a PID !=3D 1 is requested and
> -                        * no PID 1 exists.
> -                        */
> -                       if (tid !=3D 1 && !READ_ONCE(tmp->child_reaper))
> -                               goto out_abort;
>                         retval =3D -EPERM;
>                         if (!checkpoint_restore_ns_capable(tmp->user_ns))
>                                 goto out_abort;
> @@ -296,9 +290,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_=
t *arg_set_tid,
>
>                 pid->numbers[i].nr =3D nr;
>                 pid->numbers[i].ns =3D tmp;
> -               tmp =3D tmp->parent;
>                 i--;
>                 retried_preload =3D false;
> +
> +               /*
> +                * PID 1 (init) must be created first.
> +                */
> +               if (!READ_ONCE(tmp->child_reaper) && nr !=3D 1) {
> +                       retval =3D -EINVAL;

According to the comment below, we should probably return ENOMEM if this
is a subsequent attempt to create the init process. In the next patch,
we may want to return EAGAIN if there is a concurrent attempt to create
the first process.

This isn't directly related to this patch, but why do we check
"ns->pid_allocated & PIDNS_ADDING" after allocating all pids?  Wouldn't
it be more reasonable to do that right after taking the pidmap_lock?

> +                       goto out_free;
> +               }
> +
> +               tmp =3D tmp->parent;
>         }
>
>         /*
> --
> 2.53.0
>
>

