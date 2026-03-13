Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2023F107BCD3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 17:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EBC6B0088; Fri, 13 Mar 2026 13:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D62A6B0089; Fri, 13 Mar 2026 13:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D87C6B008A; Fri, 13 Mar 2026 13:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 496E86B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:35:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA5C51A026C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:35:24 +0000 (UTC)
X-FDA: 84541741368.25.3D2F49A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id EEB4D4000C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:35:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mjw1zWLw;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773423323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9M9IHqwd68/9iKqxw7/Loa7/m3MUyVQus4HkfOD7kBM=;
	b=j3+ei/+p54LBI6qNMczrL8blhdTfy/UQhdx+/GOcI+s4yhOlAG/4PHZcFt86JLDvd7pJGT
	wsWswEPG0nUBVLFUAUpHnzzZgIPtLLe5USRTzUjTbUrwmiM2PCzibP06j1tOEGN3R86dFv
	txCb0gLv8uzUCD//DVR25SLhg0dB4rY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mjw1zWLw;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773423323; a=rsa-sha256;
	cv=none;
	b=OjYbd4hUUAd6Eoi9iTeSmt4ceNNANua4Vloker6GFd546ouUjes4bxALobCK0tGMatY/2B
	oFqIaSMT9vXYNVrsh/yGI5ODyKB3s1peRjPNYOObie/jnoPGX4RLu0Q9Muv+mQLMtbGQIz
	A8FX68QXUVu55bOKT7w0tHoYMa9MBb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1AA84342E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F6C2BCB3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773423321;
	bh=ApvbsXVbaqMbdaCDuqA/3rLOXLy0yrXR+9ASU7EGH/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Mjw1zWLw9cf283V0S0iWehmdz1ZoVsu3IdmTYSBhyZN7QTHParcGEZZFYIvC+SLhY
	 8UnumqpE21F1PTRBFZJIxJ1LmLUCMzthA6aARqjOwOksFXAAZdtfnEW41x1A3vMVPa
	 m3o0IFb9XFW8uvp/iJJCj3qpXXKXMjxMiRbLJeG8zYtTMbPqcebeFmdtO0/Ybzfqif
	 mgfYU4RaDr8Ocf1cwdJ9N1VndF2Rr1oQBr7ssPIWn4sW9gQXWrF0VcGjS0vjBMWgpF
	 1WqUEoal/aMGMzn4Uv5lKrQsUVXABb8onSFcKaFaZwlPLomYx9gT4MxPQWmZytddgy
	 y9Upt0tDAWqNg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b941bb3e23cso422282366b.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:35:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU+kPjOGgScVc7A3qKbyCVdMPK0vEilsI4o2qX8QnqTlDPXZG0crCybiIuhLqrXNK7hI7JIV8XETQ==@kvack.org
X-Gm-Message-State: AOJu0Yye7hmVjaR4YoGgU2z4k88KTor8d6R8M4eSZ68f3BgnOBYRYh0T
	nN/rjI2BMAIFWrUb+afBbHHjnpu9LocG6HUA4LEKFVR4vfHMjXKvoY/6ZckzD56cTlgZJUbfQnP
	fJofnNIcXoOOMlNkd085JS0zE/iTMMSY=
X-Received: by 2002:a17:907:9452:b0:b94:244b:2ba8 with SMTP id
 a640c23a62f3a-b9765103493mr283406166b.29.1773423320405; Fri, 13 Mar 2026
 10:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260313043532.103987-1-liwang@redhat.com> <CAO9r8zMsbVHKnCzfQcdtomRMWTNFgTGY4XALxwm+i9m1SUPPvg@mail.gmail.com>
 <abPEALhYmtBnEULi@redhat.com>
In-Reply-To: <abPEALhYmtBnEULi@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 13 Mar 2026 10:35:08 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
X-Gm-Features: AaiRm52tG5grTbDaQuCRVOsImQRc5zDDMbvT8ehPQwz0Bf2Lf2h1t26HM-nxIv0
Message-ID: <CAO9r8zMciNGa1ei-pSvx+ndrCJtZguGj12R3sa8PkDHYwsvGzw@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: yosryahmed@google.com, nphamcs@gmail.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EEB4D4000C
X-Stat-Signature: acc7s9concsaj51gxz3ddpx33buenc6c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773423322-18424
X-HE-Meta: U2FsdGVkX18DUOU/Kt+emdS9U+hJO7FLfwGkI0Vh774Y8T1nXZqAsnBIeOjmzsmV30MZZh5Ue8w2EwZOBnJgm0SWx48ZXJ+gZ54qV01RqShoLAF0C9rBrH/zrjLQBQVMB5ZVW7vb3tx9sHPiU49LyNvSURzhe+/4FUoUHjoRdNAQOoFrSMxIEuNIa9Ktb0khe3t5Kp7fm1aeh42rVhmikP7jVm33OVRuxoQmN1h1aDOrJv3ovL4qzKMcCFnT765u+3zyhycVToLe2SZh1cStWELmeNQdx0z6W1CJUxEO2itqYUVJnGcU36vn5x5HWo5ZbKFMoB8FyvDAekMrGW+izkLEitgO+8cf20ym1uXQoSAXHk0UU69rCjIhZKjZgEfuHbW3uZh37eZ3kGH6FHt5Rkw2Wmt6erq/1XLIJeMbBBSmuVs/5iSc/r/iM7uLswWSuRH2vAYZds9Iz4/99KAxWqepX8TB7u7NwW3BEBRR5MmMCAI4fg/GHBBv9LUzrqf3od8vJy3HvPVgsX2yyEIwGt2K+b9+u1bDaa46cTSVh81v10660HcewH+Ur9jKQJujIfPdXtfIhG+gFgSzOrfJJojxly46JzT9Y1W4/GSdX0JUaSM/HKsfKKMfJ0VEKvz7HNgui5CMnFpxe887j0LKfVf92l1t2gqPIB/SHaPp3XTFbPxQyrtzHLYQgLee/IQJC44VvMt6HUtRDc3HtlBIOTIO4sIyVFrFwfoT/EkWInjqz3/nle4zYvjdYsrDJVe4Bng0Vfp25vsxrDxCjWYbBCiJ0nWwf53cHjk9+xnJWCW+38uvUm/Nug/VgR2i0CiSo3VarsTlMErTavcTZmQOhcyPG2wOiEW5EeS+jr1RmBlA+D+YVvZpyws0/VdgrLoT7ksb/m2xKaBr5SEd15V7twrjNsU9mjfODuTTn27X3q3BoWLb9yL66QH//S4VcOManTBtuGn1PuHcf3i7MbK
 96VKqZkp
 OtDnhR98SWh+6E2DKmMPvnC2QB2gZ0HArTPJsTFL7Pjar/AuCIxZeBT27sRB/RzmmL/95S5uMqziaKhaUK5S05oFD+nn7ah8GRxDFC9vlvYvk1eZY6LE9YaG9lvGCoGaQBURRgWOFSoImQNKMIc2efMInrnlE6WlXbehNXqCRBm0OAaCtw6xpmq3E9psuSSvf0QDbwOfy8waR5dtIOxmH6Gt0ssKEHFvIjfBKQZ3P9RhUpYZlBkCHUbZBMw6VtocbkGvwBhxtVEFLFdGSzR1laD8MRvZJpCuDtRg7mCIiv+viFBfDV9z9TGAj9qXPMAPgUyMBuEdDgIu3/h8wHYr0L8SkSYsBH2g0w5HwqzVmJpqQzRoFZEIwzikktBEzMs/N51Zw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 1:00=E2=80=AFAM Li Wang <liwang@redhat.com> wrote:
>
> On Thu, Mar 12, 2026 at 11:34:41PM -0700, Yosry Ahmed wrote:
> > > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/test=
ing/selftests/cgroup/test_zswap.c
> > > index 64ebc3f3f203..e69d845d3592 100644
> > > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > > @@ -589,9 +589,21 @@ struct zswap_test {
> > >  };
> > >  #undef T
> > >
> > > -static bool zswap_configured(void)
> > > +static void check_zswap_enabled(void)
> > >  {
> > > -       return access("/sys/module/zswap", F_OK) =3D=3D 0;
> > > +       char value[2];
> >
> > Please wait for discussions on the previous version to conclude and
> > give people a little bit of time to respond before sending the next
> > version.
>
> Sorry for the rush. I thought that I had clarified the issue there.
>
> > I think this can just be be:
> >
> >     char value;
> >     ...
> >
> >     if (read_text(.., &value, sizeof(value)) < 0)
>
> This actuall introduce a problem to the code, as in read_text()
> that achivement is:
>
>   len =3D read(fd, buf, max_len - 1);
>
> When 'sizeof(value) =3D=3D 1' pass in that makes read(fd, &value, 0);
> read zero, after that, the value is set to '\0'.

I see, I missed that, thanks for clarifying. If you do send a new
version, put the path of the module parameter in a macro or variable
to make the lines in check_zswap_enabled() shorter and hopefully have
everything fit in one line. Anyway:

Acked-by: Yosry Ahmed <yosry@kernel.org>

