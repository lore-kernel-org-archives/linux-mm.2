Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 317C2106ACCD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AE06B0005; Thu, 12 Mar 2026 14:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E746B0088; Thu, 12 Mar 2026 14:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4001B6B0089; Thu, 12 Mar 2026 14:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4456B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:33:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0F9A13A95E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:33:01 +0000 (UTC)
X-FDA: 84538257762.02.C909EC2
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id DF609100003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:32:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyLZ3zYG;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773340380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLCydgmsLZopSIxYCWTXr6mj5+UWpP/7itYlUReBj3Q=;
	b=TmmTUkQi4aOYqdb0rl3WpH4FDkItUZplgEk8bOwUgIRKbIcBzUyspI7xlVai3r1X1ucKgY
	1QtaOtwuteEeKrB1b7j4GwtOdUe2KDzVMfVZBhsXBSAnSGyfAYoxHz/Cm0pffMXn52IT5f
	YH+4TiWG93HYTOdCtrx7l6mPszuJu0o=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QyLZ3zYG;
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773340380; a=rsa-sha256;
	cv=pass;
	b=wgwxENbBQsovbvxtoqposmHXhAaHU74U5nnaG2ipktEIlJDAcMsdENWdRSmU+aX2UMpNq8
	qbgh6joHX1LSkAznq8lpJz7cmX+VXWs8nCZzwoqQIv5YhJJniCRj71+/mCW+Zuv93VsOYr
	6iFbez7dxzq4I0ibWZRHImmr0yHeJ2w=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439c6fc2910so1140669f8f.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:32:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773340378; cv=none;
        d=google.com; s=arc-20240605;
        b=ZH7MCOX69YMD7ENPgA4n/GpALOZgjt/DZzreU7sySxlDCJU2BITDzIa/0DxQ7tsFRx
         X3omDeTegNDKC46RZNF1EJHby6Y6qKSmJsarTAkP7CEWtLPe3KhikFt1OvEuEzL/jrOS
         iwvs4aO+bUIMw+FXL9DB5nHzHNkvkkpsjFn3urRleCLQeCURDLlmwQylYJY0T6PXEuB5
         h9QWwr3L3DIdswxBDojaOpg3wziz6Nwc0ZhGSiCVncWNeNrqLKVKn8Gpp4tVXI4i7OpV
         vVnw5uUy0Y/CjiVmUublzcUPvinw9ou/i2k0LYbItLv4W+zRc6wGg58hknl5FA/htXSK
         liVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XLCydgmsLZopSIxYCWTXr6mj5+UWpP/7itYlUReBj3Q=;
        fh=Qn6pmXc+4vgTj7vZHunj/p+MYRQtAId1cx6h4mRNmiA=;
        b=klazT5m3TnWjfFcZ6CjBsmAQK8k8nUP4DL2ScoK8pZE8HiQqJCxnjn05a7UNBX8cAT
         3e8M9zi1WLvN27eKVVoUL7VIjpogz0HjEV5HQJ8g18HHNBXUo3BQ9QlEftGXrHXT/pDC
         ofpYnLHu1gCOYxIm2A3ot3edYLPOQWnsD4hLXG1RphEu4a7VQigtqUaknABRsVzU8C9k
         HK3p4War6KT5FuM5xVwzXJj/AzKdrPWPFfC5gJY5Saek0q9EA40ytrjluikP6kO3VBs1
         QyxheU5CvW2dBoIR07TewohnFr9ofVuoXXYVI6MIj8tf9o5KQZQUvgv5K4yuPYNj7kIJ
         W6Hw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773340378; x=1773945178; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLCydgmsLZopSIxYCWTXr6mj5+UWpP/7itYlUReBj3Q=;
        b=QyLZ3zYG0AVpzq0EaKTIEWQi3f8TBfkQyyv3piYEihifDOAzBE+SoDkACHcS4y1G5C
         fzFPyWX7OV+N/Hoh95e/Ba5R4yEdJ4625k00GAr8T18tBu7ga4jnDfSFAQmq4tUopji1
         Woy8GDs/FmP+EbxvACSL3AO4S7kLP+FDbT8flpdBGEkaWzJ4JNokgRZBXA8x3IMcnP3L
         aeEUHY7HDYjl2uCBreiwTYI3CScc4/sDM6de6HTmE8CVyPpzx36ybFiwG5xmyj5+NllE
         U8dJeAkFtG0j/ZT+ow6oarZH2Seb1SaImrJQzBQZhFelLT8JRM3e79R2+sjJg/mC+a2L
         1dSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773340378; x=1773945178;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XLCydgmsLZopSIxYCWTXr6mj5+UWpP/7itYlUReBj3Q=;
        b=DcAA5G/I1cu/pJKxPf0J/6DBogBtbdQaKz2imOdwA6+FRrgZdrBnYjbdaernrHgXHu
         +J3QGFJTM2CjiVZG40HElJBKrz21dhfweeDcBFk471qblUE/R8UGjFXb+5kULJtSIj5k
         DGZmDfVwaCrp0FqaQBg5aE7vrQcpslGF5/y/7FwiBxApYmngpuzDu//gNqOYypNfVqyi
         qzLtFlkPMTi4TeOWgYUDqCtCZ+KU8v8wNt5Ng+1ersJeLnDvBlmY+FyUx+KpSfnzFFWt
         xo1mxZdgxFAYOu+DKdULHqBDvk3siRQIIlb5t3X9lh2MUVQyqpFWtDWF7asUfQ8M5cwh
         pkUg==
X-Forwarded-Encrypted: i=1; AJvYcCUAEsMKPX4qEGyXEINhwbuf6B8p87crwlpyZtuX/I2EgbHg4RIbjBHkHrr/mr/ACWLZ5rml8+6UJA==@kvack.org
X-Gm-Message-State: AOJu0YwPIjeX43F8lCeIVW6u2wh0xwczx22oFGu/tHj9t/axQWB/ulOR
	gA20pUN/MDvmLak2FxaRx5aiwfrGIy+5mdcEBw6L1SKMlTW/6zQ+HZQ9hHcPhD5rV81Fs8bmfOA
	RkK9U9ATXErIM/6DKriAGQx92QEXQj/4=
X-Gm-Gg: ATEYQzy809W+FbBG/nttLRlr1YtHmUb3w2izz/IdWgFo9OxR01RJgTZwfvj0Y5llgQu
	KfkhIUsfTzg7MRXUZ9UfW+BcnX3kBXBndc5onken2/qJjBABfbJ4KiOLO+x0BD372qYXCDQOk+w
	223vQLKOLHMO3djOv3x+6LVjBDwg6X487xwqNbEJVD4bCXiKvZkkRN7+OLcmGNs1NpKBdN4H9mq
	wqeWq0LsG8zsS0HP8caDCxdnPcqNLtyVDjfzXBN+sn+sOQ9sCFzfxREg7S47mOg3HvuWIG1q06c
	BCCacDXrDs5GyN0DA7hiFACMd3P4VdG9GeBgrx0=
X-Received: by 2002:a05:6000:2912:b0:439:af0e:57a6 with SMTP id
 ffacd0b85a97d-43a04da8280mr1300920f8f.36.1773340377966; Thu, 12 Mar 2026
 11:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Mar 2026 11:32:46 -0700
X-Gm-Features: AaiRm529J2z7GUFjqxFaqWDZiHrZWf25yuHp83ueywxtszNnB26OhIBqBJrPi1s
Message-ID: <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: mkoutny@suse.com, yosryahmed@google.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DF609100003
X-Stat-Signature: srtpsggy6ojg1smkzen3drx6bzejr4rp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773340379-590375
X-HE-Meta: U2FsdGVkX19MLE6evu1GdqE3XGdEGD8h8nnQcw0XNrtUW+lrTPTKyBPB8WJb1TYI0WuKR+EvDXzAeHtRMQw16/EQUzoPlZyc7EkTYpIqP1DH8Ta0qw+1j1uvxVwOuawDP8IvPJtNg0JGIo/MA89HweGASlfvjpHuJVeOMrleRlZQvnEo6zWj0R9hiNAQQCDNDI+baipmf7Vptrqmkr9hs9mza8YgVJB1LrZVno15LnuMzZi/+Xr+3/HXf2K5HFfU/LKVzN6IBQhPKUNqJu5jPxox6XP5BNkBfPqMV0nB0iESTp8G2eljTdPykLQySNWNHwt1B78yhKzpu17w2cSv/tX5tfr4LaXHeYtc1S8tQfN6Tj71aQVG8vAr2fonCOQCKyfJIVLp2adNhEGitHvSZIxQ+iJyq99O7BLZSHF8LRc1/FSURMG5+cY8PoR56eRAAmeDyDrdU9r6NkoxmyapzWqnjLivV0UxVvXjeGDuojL62urp+uSW8j7y2stmeVw6QEuslyOzSfFFwAXAXZolCtR6f5NL1SZW6S5LT+5Z0tlA90TmLuvynuieqQv/mEZkl7yb+JoVmZKAY/YVnhjzJtNyU3OBuMPnU8vcRzaCfd/7pTrnh3RjrCm4t4qsY73rUFtYq6eti5VvDpEG90MmqJxmRUeP31sPCRomkm993tI9r69AEUyIMiKQcrP4T3DJV3aXQQe4dEwjoFeVZZ+Il2f2cMFrFvrBgpnTXMt47/712Vyc8x5UxEfUqFT7y2RY/EJRoCm8d1puHA5P7YHrg1KkpwmxLHCL3HMjAUVrj4v+2Y34l9dn4XUHrHU85HyDNFsTJCXp2EfetnMp+wa8FWXAckK1Oit4txxzS8F6mQpetHGP+aoC8ngjw0bmn9M1P91I5mlkqoSy6YkeUduZndmF0d6y6vdn5YEZgcfybpR0xyVVDq4BeyLPvvc0tkUH05DJlbQ+FDM94+AZwaz
 cV8s++y1
 ebHcbtZEcR/buLHv3U9OxivHSw2WGYO1KSVfMnBPhsurgFfczxqQWo7TWMQ0t7I6NzpCx/2Hqv6LA4NydRWqTDHV0JVlkqPh4sVaDY3Eh3lcwQMl7u25R0FdrNNpHDzttFaahoakAFSOsdfVLy96/EkkPs0J73tsf4rycvjHquxDKbUuC5EOSlHFlbf+pcCC658WCcdVoGtxmMm+BSThDktv/orjx7xnISUGbigZbNWgJq4YLRfP3QLWTcZmGL6iIkvvlp48r7NER6+RnWc9DbG38hTUovUowb4fX41v32+g09LRXolIVA7EDHHjsFXxt6HsZw4qu9oV0OoE05qDBQNwaoJjXOJHZHkTitEzIZ4RhhrM2rhtq9SSWuFGAUqadoG4/vgCOUhFrtGM/atC/E10GXzQpsx4vl+d+G0+9ONpvVO28If2QFuiyfZJ5OXqJEVHqHcyWswoS7KfCO+wTR2pfy9Y2No5F1DnzVoqZpHmNj9n89v3RHVQIlPcujKVIIj2CT0XReakYnBR2O9REiviUS5TSVCrSedQn2PNm+u19CSgbzSpvryKRpSfP9c7oJhHzTQyEfpuJzSFvv/VchVOZ9LMJMzXQOX9jOPF3k8tNEml4PKwy1YasWf9dwxxP26CoXOSveI6XMcsLp4jijHhP7/BC6QQCawfD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 9:06=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> Currently, test_zswap only checks for the presence of zswap via
> /sys/module/zswap, but it does not account for the global runtime
> state in /sys/module/zswap/parameters/enabled.
>
> If zswap is configured in the kernel but globally disabled at runtime,
> the zswap cgroup tests will run in an invalid environment and fail
> spuriously.
>
> Fix this by reading the 'enabled' parameter and gracefully skipping
> the test when zswap is disabled. A helpful hint is also added to the
> skip message to show users how to enable it.
>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> ---
>
> Notes:
>     v1 --> v2:
>         * remove enable/disable_zswap functions
>         * skip the test if zswap is not enabled
>         * reporting fail when zswap_enabled return -1
>
>  tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++----
>  1 file changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..ec64daaa2f5a 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -589,23 +589,41 @@ struct zswap_test {
>  };
>  #undef T
>
> -static bool zswap_configured(void)
> +static int zswap_enabled(void)
>  {
> -       return access("/sys/module/zswap", F_OK) =3D=3D 0;
> +       char buf[16];
> +       ssize_t n;
> +
> +       if (access("/sys/module/zswap", F_OK))
> +               ksft_exit_skip("zswap isn't configured\n");
> +
> +       n =3D read_text("/sys/module/zswap/parameters/enabled", buf, size=
of(buf));
> +       if (n <=3D 0)
> +               return -1;
> +
> +       if (buf[0] =3D=3D 'Y')
> +               return 1;
> +       else if (buf[0] =3D=3D 'N')
> +               return 0;
> +
> +       return -1;
>  }
>
>  int main(int argc, char **argv)
>  {
>         char root[PATH_MAX];
> -       int i;
> +       int i, state;
>
>         ksft_print_header();
>         ksft_set_plan(ARRAY_SIZE(tests));
>         if (cg_find_unified_root(root, sizeof(root), NULL))
>                 ksft_exit_skip("cgroup v2 isn't mounted\n");
>
> -       if (!zswap_configured())
> -               ksft_exit_skip("zswap isn't configured\n");
> +       state =3D zswap_enabled();
> +       if (state =3D=3D 0)
> +               ksft_exit_skip("zswap is disabled (hint: echo 1 > /sys/mo=
dule/zswap/parameters/enabled)\n");
> +       else if (state < 0)
> +               ksft_exit_fail_msg("Failed to read zswap state\n");
>
>         /*
>          * Check that memory controller is available:
> --
> 2.53.0
>

Seems a bit convoluted. You ksft_exit_skip() for one case in
zswap_enabled(), but return some value in other cases. This value is
checked in the caller (main()) and then used to decide whether to skip
or fail as well?

Why don't you just consolidate them in one place. If zswap_enabled()
has no other callers, let's just open code it, yeah?

