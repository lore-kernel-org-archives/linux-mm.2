Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D013DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875A96B009D; Tue,  7 Jul 2026 14:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827496B00A0; Tue,  7 Jul 2026 14:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C466B00A1; Tue,  7 Jul 2026 14:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31E6F6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:25:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8440C168F43
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:25:32 +0000 (UTC)
X-FDA: 84962808504.12.D49CABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B09CF4000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:25:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8R9IeOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UodfhMWHJOTmOaDJSgPxCuKgMVhusPF/cnVjRAHGFO4=;
	b=OT/tayQ5sPIt89HZJ0vzYMyk1WB+lXaFBosLzXX67ZQMOpwBSgdFe3B6KKSvCsCnu8i5sx
	ZYJIf1X25nYALwVbMvlM1L/jG9RB1SFB9ICgNmhB9OM4NO1GJt7S2ATOB18RUOq0pPTJen
	8KDLDyg9R9x6v6H1RWnMNCmIqCakHVM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8R9IeOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448730;
	b=bRh/AiDxlCKX8cGyZ1dPFtUb9ejyCqMgylTVfuUDzzRVUF4zrITuCsOI7C0/EJmPEsW2bM
	dt3KDyVkDJAzdi9aW3K5qDWYbkOqGX9AULXk0QtCDKKkpst5dHm3DAUR05d8FQ6Z0KKmsu
	JDHPvUEO4xp7+Cc1tL0w0BAJo2TW7xo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09771601C6
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C081F00A3F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783448729;
	bh=UodfhMWHJOTmOaDJSgPxCuKgMVhusPF/cnVjRAHGFO4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=B8R9IeOmQ/w6CN0kw35IGwlxxnZpEu99nbMX4c/Uz0ZcV4rgegRJI/jZiko7++/tb
	 c7yvthhV1zfsHkolcBeQOX7HTX0sx6KH3vp7Q3YMAFi/s1gGzciFZzeli/XT38Q9XE
	 jIUj0Ye1Vn5XWYnys16iy4Z9wVohuuK2k9yXDeBgmwTe3+cqlvBbVGw5OjeRnTJXaA
	 62BCKeNy8ZiHZVWFCkEqfEs0r5Bljrmi6XyIu93HnVEejHreDAPSoHcaQutzY/dk8r
	 cqIupSIZo4R9LvAy9nA4m6/IzjGrfi2efqDUvgDh8BiMKdxtEm00EAfxT4kT2Xs2Xg
	 r6ZyRyoPdR1gA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c127813835aso532812566b.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 11:25:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YxRfAFZtUU1mE9LW6sJu+IdSZhQUJpIHWZREoZhvf/LH9Z0XcPb
	UCeApJBwU8Ql4EQbZI1Z6a4R5hL57oMtDLb97Shs+ya1JjcNqzMdTCkOKR5zSQ0cPuK5Qd5j9Pf
	EnISeNVJjvSI+U/0gv3oM0TFdcr3JLnc=
X-Received: by 2002:a17:907:ea8:b0:c15:b27d:51e4 with SMTP id
 a640c23a62f3a-c15b27d5823mr202693266b.20.1783448728654; Tue, 07 Jul 2026
 11:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
In-Reply-To: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 7 Jul 2026 11:25:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
X-Gm-Features: AVVi8CfOmsujy8Bb6nVmdtBpnu4IHHs228GbFDG2jlrs3NnSjCrtP5K0xKzG314
Message-ID: <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B09CF4000A
X-Stat-Signature: xpjsn3rnphtkk1akoqb3oacjgp1io9ct
X-Rspam-User: 
X-HE-Tag: 1783448730-826307
X-HE-Meta: U2FsdGVkX1/qvlDTWJiZitlPDnOgme28ZGE4KF+KHiiWErZ5jeVe62IokPklDoViRIci1LTsAwvZOtblwIkxyBNqDfjGdfpTOdZvZ5SPkDFu7heozLQpz713YpnOGpWxZn7EBbR1CF1dBfbhCgQwaHPKPRP/1zlkRNWS4glglH4TNIOvLbYbUKyzClSOZLm4dNb88LiuVQKyzBq794R4degUajmMPPWz6VWwyjBxIPh5h0I+EuoeF3t/Hqjn7qTGvjCa35aZcvK9CiQdwDOD1MTnyG8GK9YzAc/uwYeflo86IaFwoSMxEgOFZpcHaCOpUERro/iCnVHqkrszzgbAh28sUxNFyCnK0ym0mMJEbg8QhMJm4D36qWVJWcb8qYHO7MhmzKeQiEbxoAo/P6BwCgOUwhvphVHo720yME1AKY81UZSyOdhRw3GYe4Tml+O0BeqPRh/tpuShx3BcQJJJNpv6MQ3FuYGzzrNT3Bgy9v6eQZboWuHh3/fhq8QrIJmREW/AALYI2Jq/SrVEr+V7Mho3DgpyhFUAxegVHLNOXpsx/gK+hxGpGcRxYOCsh8fSWnHzwBUkivVNJ2t0FZNNI0SLig/OgCpyMuh8P+mnwYQR1RDs79CDg9J2SDjwCgEmBApaniMIwj8n3VxjLwfmXZ8EtTt6jGHSjms7q0xcFnmhdg9P7jj937O8JwIf4QWsbhSueGo5V69BiFg/lzYaghLSIPZGuPevg4HHDyAlL3PNJolxkcEN3g9RawzjJbItabM22gSkMIvfwUoHPmF2EhdrIzmNWmaO2UMTshcigfXjnaDZ5UctIQAJVO9fJZ/l5Fq24Z8824H5nTdB885G3E9uKN5r2E/ScYnKrWdeC0bAWfXAaqxk5C9Si4XZeO4mqPtjSZY8SwQjdMQVMevWNaYd0WXt2dxhfCSsZr5vlsUS+eB/EQdqVRqM/zO+WZT9hl7OYKTUX9fn036jxoJ
 M4tXJmQ6
 OrcXG+Q8NWRuyZdMm6MMY6wr4aFydygt3HCjU4hcpz7sGsuTuPaygsUx/Ax1WGon7VOb2WSithwScln1Ji03EI1YtsKS9i6hjNnCJ0ir6cFfTRlWkx2tsZx+QXgQ6hNYzwRNyEwtX6uBpCkYqNnLgOwrvpncBSChi0uYkMHLauFnzxaerkf2HXjEQpnvx7brP3dBL8fV0DPNKvNqiEV+jZIuahxpbBwtFc9aK3oSFKa+oCj8sjnD+G8BEo1Lgb3AVbdh9ogJPDoSFYGpGZAcavlE9nNGaUjCN3R5WkXzknh8zwzPgM+o87UH119UHNC+OOJqNVQkQ5MAzZ6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 2:38=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev> wr=
ote:
>
> Hi,
>
> Running cgroup/test_zswap on my arm64 box failed immediately with:
>
>   [root@localhost cgroup]# ./test_zswap
>   TAP version 13
>   1..8
>   # zswpout does not increase after test program
>   not ok 1 test_zswap_usage
>   [...]
>
> I'm sure that pages are successfully written into zswap by checking the
> count_memcg_events(.., idx=3DZSWPOUT, ..) trace events. But "zswpout_afte=
r"
> in test_zswap_usage() is 0 and results in this failure.
>
> I guess the problem is that (in this particular case) the memcg stats has
> not been flushed when userspace reads it.
>
>  memcg_stat_format()
>    mem_cgroup_flush_stats()
>      __mem_cgroup_flush_stats(.., force=3Dfalse)
>        needs_flush =3D memcg_vmstats_needs_flush();
>
>  static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
>  {
>         return atomic_long_read(&vmstats->stats_updates) >
>                 MEMCG_CHARGE_BATCH * num_online_cpus();
>  }
>
> I can image that memcg_vmstats_needs_flush() will return false because I'=
m
> testing a 16k-page-size kernel on a box with 96 cpus..
>
> As we have a periodic flusher flushed all the stats every 2 seconds, I us=
e
> the following diff to wait the flusher to expose the accurate stats to
> userspace.
>
> diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/tes=
ting/selftests/cgroup/lib/cgroup_util.c
> index 3ce134509041..9596f294da0b 100644
> --- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> @@ -95,6 +95,8 @@ int cg_read(const char *cgroup, const char *control, ch=
ar *buf, size_t len)
>
>         snprintf(path, sizeof(path), "%s/%s", cgroup, control);
>
> +       sleep(2);
> +
>         ret =3D read_text(path, buf, len);
>         return ret >=3D 0 ? 0 : ret;
>  }
>
> I have no idea how to "fix" it properly. Please have a look!

We were discussing a way for userspace to explicitly trigger a flush
before, which would come in handy for testing. However, we decided not
to expose flushing as a concept to userspace.

Unfortunately I think the only way to "fix" the test is to allocate
more memory, enough to trigger a flush on most interesting setups.
Perhaps we should scale the amount of memory with the number of CPUs
so that we don't have to keep playing whack-a-mole.

