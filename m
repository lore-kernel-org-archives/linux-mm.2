Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5084ACD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847CC6B00B5; Fri, 29 May 2026 11:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8456B00B6; Fri, 29 May 2026 11:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DB16B00B7; Fri, 29 May 2026 11:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BCD46B00B5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:01:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04D221A018C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:01:20 +0000 (UTC)
X-FDA: 84820770762.16.4D03D89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16549140019
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:01:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1b5V6y8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ShsIQPosHpMnirHmH4xFd5qCR/Qbqzv+ZOS1pe/kbc=;
	b=NZ90GFk8ERgqjNoy53GvEIwtMoRiZwkuA6qiWbpDKRaDZ9NK+ZsMQOPp0PZAsWldMA/NT7
	hNxbAp27fLPDwhj0jWqan1eTHBVqltDDX+P8YVZvWwgNBmJlRLYap/rLAHIUXv4Pt0grIm
	+hUjvYzm5MLTS20PVeYN6CKzDVuCDwM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066879; a=rsa-sha256;
	cv=none;
	b=alNNLIAgz8LNh01KtpgKufBsMCvvo0+gBCRNLPz7RLPl45oeXDgfLzxOgayChGuo4GXo1h
	aDiUt3RmKK4SRSaZ8lyNF5n5h+laShrPuWcx0JxHHstfC6HrY0Toj6OuDeoLkmoq6p3SzJ
	eSCV9up47mPXMdYhdsM1zuqkjJUcK8M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1b5V6y8;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB28140371;
	Fri, 29 May 2026 15:01:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825971F00898;
	Fri, 29 May 2026 15:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780066877;
	bh=3ShsIQPosHpMnirHmH4xFd5qCR/Qbqzv+ZOS1pe/kbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1b5V6y8fHjzldH5MYPUCQotj/88kq8UPiKAfP48FgDCJrs6LhbUNWDZhSKdPE3EW
	 cwvLI+8VBgLRWCYaCGMTsPYiEF7QemHD845Zty5y9YE+GHnJ44pCOXM2hQ5QfLPVvE
	 D99s61wSEjQ7keqXkTRrUulvX0970/bUO9XAwoT9lMH+HrG6LBqU7CLnssLHMPBncQ
	 j4S5rorAIowxpyDjPSRxAaDE+CcDZjPrhZ/QXEtfpf014sggaYR7BXL6K86trSO0O3
	 nP6EtjrDyo480gssnYzAsy63XZxpSExgzFTDPKeH8nag1UNciYV8sxQ613Vj/ehhtk
	 QYTy2uJHwB5eQ==
From: SeongJae Park <sj@kernel.org>
To: Cheng Nie <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH v2 2/2] selftests/damon/sysfs.py: validate memcg_path staging readback
Date: Fri, 29 May 2026 08:00:56 -0700
Message-ID: <20260529150057.84753-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <FF9A1552C03B7C88+20260529092131.1703337-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 9pyqqfmepr699q6uo9hi4e5o3s5g9ajs
X-Rspamd-Queue-Id: 16549140019
X-Rspam-User: 
X-HE-Tag: 1780066878-755501
X-HE-Meta: U2FsdGVkX19EcBU8ZHXSOYp7DMEHC6XG7+9XAAkIobtGXWZ2iZzdXAW2W4y4RZyGuFU9P3psLR9V4+W4Tna2vj49uO6dfJaQxWqqO2j+4qHFDZQlcuuS4nNlTrcCMJaIW3cVMXOSymwA+T3LCkG0LNVUtVfSpOMQ09aaxDtKnMz+GoT4vqJ/BR9iklyBR+rCBh21dwowzRwDJ7TbCcQVxPR4GCStPXLKAKHEksfTGh9pf2eiZGITNZqjbu7/bw3Ihvux35oVkXXvW7C4HGD5j5TrrwkwHvJg2tWA0KKh0eZwByjEmLBVHd82svkknTjLXfkvrfIx9KeB0F0xGrLXMczlt30Tvv0+Kg9JmYbQ/2ErcsTJE4hHZJun8VbK9xDMW1QPUdIo4O+tUQbNv6AsNkWEeYrMzjWKQAK5xocHfArsll+CrlmT1A6YZ3IutDS4vqcUtmTOY1Zdy5sXJjGPkXvuAJ5OdEMSgFeKYuNo4vFWEtTmdwi7erZFyPb0v77VWvyVPEL7rffCZQyj6hrhX2YPeNdbLZ4X0ZGP6suzr2s8rpE1I0GvJb/laLYESrm/2CnUzVOwMsTs9taA4ntlT/sH4Qs3wOZNKcABf+CLYuUrlfc+DD34EXHu6yncGj5PFP7lFfmxAnJhRKeWA8EhMXtG1Q1rOE55XSBiJyggXLQXXx1DbdlK6aiFgAimt7KgYaxkh97mLhfY50jJRkpu5dpqOeefEj+Lw0wRJSL321H2Uzb+Ce2bXt4McRb8NG2diJg4t99PSFGCNzGGZw9XIU+jnOe5WQb/O5v5bej4jgC8gZFVPogUN1fGEUfXEnMpKjxdbmXV7KZ0+AiywVI711dMJa4H6fWpiZEv3MyiQl5WvDOC3TnjRogF516Svg0XgVxf6cyc9Y40VKp9RIJ4rFc2Sq1fezUZ6DPnxX2WudiGO6Kp5WgZKoMKbVQTheGSqyK7LvqT/fMei7ozcXQ
 ecOZpQVe
 4sWk5AsOihG2QMALcnCrzJYORDFOHZI9UQIFr7xIIVpMBEkPNw6eWCMDevsoaXmDg02nwVSGXSuWUUM/ishfihIPMdHbnfdB//cu4Ye+djd0n/oQh3laFmZsj+vEf8Cj4GUkdvaV5vhPkxNbJz8LNj8TagjinIf4IxxT+Nhejk84/9UmLNL+TOym5ME3SH8dvu1Y+8BGYtGMmrueulN/mWaZyYPUHq8ebQcMqI53CRpRO3oCJ8kE/CT9asEsTGyJmRC1uVxzXkWKESsfHOuC72X133CYyXeS+Gsog4vwxGc+dgQFsRJB/TQPYELUaBDxHSb1YBI2EDASJKDXu4QUVwg7vzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 May 2026 17:21:31 +0800 Cheng Nie <niecheng1@uniontech.com> wrote:

> Add a dedicated test at the end of main() that writes memcg_path to
> sysfs and checks the readback path.  Validate the readback rather than
> a derived memcg_id so the test stays focused on DAMON sysfs behavior
> and avoids depending on the local userspace cgroup mount layout.

Nice addition of a test, thank you!

> 
> Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
> ---
>  tools/testing/selftests/damon/sysfs.py | 39 ++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index aa03a1187489..0f20bc9c46b7 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -250,6 +250,43 @@ def assert_ctxs_committed(kdamonds):
>              if ctx in ctxs_paused_for_dump:
>                  ctx.pause = False
>  
> +def test_memcg_filter_memcg_path_staging():
> +    global kdamonds
> +    memcg_filter = _damon_sysfs.DamosFilter(
> +            type_='memcg', matching=True, allow=True, memcg_path='/')
> +    kdamonds = _damon_sysfs.Kdamonds(
> +            [_damon_sysfs.Kdamond(
> +                contexts=[_damon_sysfs.DamonCtx(
> +                    targets=[_damon_sysfs.DamonTarget(pid=-1)],
> +                    schemes=[_damon_sysfs.Damos()],
> +                    )])])
> +    err = kdamonds.start()
> +    if err is not None:
> +        fail('memcg_path staging: kdamond start', {'error': err})

I'd prefer the error message to be in form of something like "'memcg_path
staging: kdamond start (%s)' % err" for consistency.

> +
> +    context = _damon_sysfs.DamonCtx(
> +            targets=[_damon_sysfs.DamonTarget(pid=-1)],
> +            schemes=[_damon_sysfs.Damos(ops_filters=[memcg_filter])])
> +    context.idx = 0
> +    context.kdamond = kdamonds.kdamonds[0]
> +    kdamonds.kdamonds[0].contexts = [context]
> +
> +    err = kdamonds.kdamonds[0].commit()
> +    if err is not None:
> +        fail('memcg_path staging: kdamond commit', {'error': err})

It seems we don't really need to do commit().  As Sashiko mentioned [1], it
also depends on CONFIG_MEMCG and active cgroup configuration.   It would be
suffice to simply 'stage'.  We don't have stage() method on Kdamonds, though.
What about setting all parameters including the memcg filter at the beginning,
do 'kdamonds.start()', but ignore the failure, and check the content of the
memcg_path file?

[1] https://lore.kernel.org/20260529094327.6D5031F00893@smtp.kernel.org


Thanks,
SJ

[...]

