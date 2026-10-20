Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1B2606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 05:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UMWCj16O
Received: by kanga.kvack.org (Postfix)
	id B4C876B0125; Tue, 20 Oct 2026 01:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDE76B0128; Tue, 20 Oct 2026 01:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC0D6B012A; Tue, 20 Oct 2026 01:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB8B6B0125
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 01:19:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 297C24052D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:19:42 +0000 (UTC)
X-FDA: 85341852204.29.FB80CF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42B9B140008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:19:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMWCj16O;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792473580;
	b=4+Ld0p0AAKu/zqx0r+haP3ooupL6A+VxWf2mkJxzWPiq9CGMosbYBc4XyckePIvVGllohr
	jkk1JlWISh6A2fByvJAra2MY6FVUthgHrTChW+Ay0U+wGPFLMRCio3l7bbqer5VGAJvAY6
	VOniR5lr7a0aDKhjEoTnRab6mUIAlzE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMWCj16O;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792473580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgiA92Rw3GBP5F1shghCZ2z8YmAbZXNEejKdnMhHo/k=;
	b=RKaDPD56APYkrBec1C8BDz8Exciu5FxjBq1YHm7oGwoXR6Kcexf1O4xuCgAPGS2q1QZpKH
	buLAsgJEFnlriKklOqcf1Ngri4o+W1pr0nLkusmQUXnAOnhQaD5ttMPD2jvQ8bkjl00foR
	xWIylYDKPizI54NqiUor3M5lNtdIrmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E69D447DF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5A11F000D3
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792473578;
	bh=BgiA92Rw3GBP5F1shghCZ2z8YmAbZXNEejKdnMhHo/k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UMWCj16OBuVk0U88Aunr2hcNay/tMEVe6sCKWnZWHUOCWlPoZ+vy0CkCwTJXjGBsC
	 pUa8wBJtW4t+MJ5+UOARI4G5IneAjBe77CMR8zJGM4CIr+dqyU8VozbKkWRBrmIFe8
	 kRh3PZFiC3vuGVQLUOI5bEHKdiyjPrCrxfqieh7RDSukTJyaXgbh+kc2bU9zBP8fFW
	 kLhl3q2xpKuk6BKQ4xgCll1VHSTAEO7q2/iQOivJFK6dLVn8mVFgjxsD8u/e30ucyr
	 vt2db4Vol7IA4qF0LV3M9Oa/2F5xtU6I2Pw2FbjrezgNUcvLA3TT/3syeCcMruarhb
	 ThIaMnm7xB3qw==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93efc0452b5so181561785a.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:19:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByfFFNQMo4G6iTIckGKNStPyxCtllhsKD9siZ1Zs7lqJoG4G5hJtuCcyDuFJesZ3H9bUiji3ydYZQ==@kvack.org
X-Gm-Message-State: AFq9FYIcIV5OxllkRjoENDZfV78dyWabrMv3FHvY3CreCxeKu9rYslTa
	PpkzY5ZFGrfonnIaQhdjWQXrBYAcGGtwCzg9qTML/XbWYJ/gYx8BKep/mb+ELpvD42+Hziv2uWv
	4CJlMS0aR56pPyqHhaVnTv6x1irxRPn4=
X-Received: by 2002:a05:620a:17aa:b0:93f:1ed3:a9ce with SMTP id
 af79cd13be357-93f29db7ae8mr1618788285a.70.1792473578195; Mon, 19 Oct 2026
 22:19:38 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
 <20261017050928.128582-2-sidchintamaneni@gmail.com> <CAGsJ_4wGq9oc05=-g4aWptLdCbTwUjMjXk4Rd6KjJ6x=tzMm+g@mail.gmail.com>
 <CAE5sdEhGFtGF6LC4xNkMwGj3vTxLOW=GNBXnk3-JmsgjntXx0Q@mail.gmail.com>
 <CAGsJ_4wmvBvEn_vXu8-c6BRAnRewYmTs8iUd8T7KRx7_svZrwg@mail.gmail.com>
 <CAE5sdEiq3bY1kgMUQ6x7RRJCx0JH4sQ9Z_a9_YQSM5FKNwpk8A@mail.gmail.com>
 <CAGsJ_4yZ3rueVMaRJ_+25Nnab0WH5ZLQeLjporWAFj7xJnJFHA@mail.gmail.com>
 <CAE5sdEjFgVoQbWw12=+AKdCOB9cWm-akxzbX7hJzvyO3vpCtgw@mail.gmail.com>
 <CAGsJ_4yrAosgxnxqc18qXyeJQHszYOdTxJw4TzSJqp10YQWjag@mail.gmail.com> <CAE5sdEj9biuOuXp7aej7pV1Zyjc0kqcH12Oi6gLyJCeuihF6Hw@mail.gmail.com>
In-Reply-To: <CAE5sdEj9biuOuXp7aej7pV1Zyjc0kqcH12Oi6gLyJCeuihF6Hw@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 20 Oct 2026 13:19:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yApi_o0HdYokaanRAtQXFQLJ2qiCRfRdBVG3=SZ6MxzA@mail.gmail.com>
X-Gm-Features: AclHuK-bqRkpB4GJrWRBWTc8leo0NsW47GnrpMNZ80hWNmfMyMEJyA6ae-ZLPgU
Message-ID: <CAGsJ_4yApi_o0HdYokaanRAtQXFQLJ2qiCRfRdBVG3=SZ6MxzA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 42B9B140008
X-Stat-Signature: 6tiyzrrc5c1gpnen4abbzex1hofydok3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792473580-925760
X-HE-Meta: U2FsdGVkX1/ue6MLqv1hjwN8aGJdsjD0uSQB/sj0C7UCJCrjICA+xH37JI0c88Pn1B438fQWLVTVQ3pBXm4nyatqmOaZoQnOq8W+ugrv9WXCaocK21i1tubORHw1jvJKF2i9PrlvaWFXlqj98LCIscaYjaeEUwn1HYSOMRkkcFtGGhtUt0XI2bbSDbQSLcLxaB6jCy4DWV+9IhFWfI1dFY8XEhJvzj+b+x4AeqHoisT3a6TjZqxPbek/Zvx9tE+uXM5kptnhTvB2saqRrXgqH6/8AlkcgGRPEBTC+635A9s9d2OnpeYxyimqOmAGq/F2mXGmCb/67x+83A0sfXmLfs1BSsP54EUB8eYQxRjqAM1IwH6I3hlPnM7bBD5ssSRISmVOEe5zLI8mIuw+1N6PseqhQmBFya4nSPl/DKl+NWuDZ/kAz8uPVQ+zQkONPoywhIOW1yhqASNG067YKIgMG2DRrXXMAwvtRABfbvZjMFmHskBl/G3D35lwYgcMC6oXm07qLKXSGTLu7oqI5WQICsAx1o+ooaVJFXWW5kP474/vt10xzsE+LEwAtybeRtqQq8LoRUh2PjsnSqYaHvjgMs+24fanv+CtwRBSbd+729Sll7SHKvqlhie9FIVoiphbwmLilkbN8mvjnHTddtpcIpwV+R6X/sqND1IU0Z8+XVpfPH8uNAkkOFBRDLt9v7dcE4v765qYFVKsiUCJHF0WLOVZ1iGD3tyJeSMkYp9CySMFM9gbEK1MgnZ2wXTrctvL6kU+K/jaR08tlTmA+gH5oy7GVXyxRogZDMSACziIUjXu5nMQnPT6qH+dHZBsNS7r588/KuiZFW8GjB83p5qJD80o5BcHGw9W5vei7H68Vcm2c2bQlQdgwJ/Q1slrtJ0hwQDBYiw8OC3CMlEBS/YDndb73rbUhAlXPmT8wsUVdmVci164ML3GHsGvGqHvKL9pH/GOe0C8T7cqMgdJOgj
 RrmIdS2F
 fMJjfut6AdCrUcznfmfq0CLMzXvWHhGVVUJcafr7DWb3RxyPeZkLjvRtY2U1cMWPC6dGrOm3sJycZxWjgRAUskC8EYvB8XWEFevPyCfZyio2t0OvyT2C17tdocH6pKFwKn8z8TQh0D+1mNOmAUUgps/Z3KcH2kWBgywjXHPdLhfJ9JF2jaO5CtAI6w4PZktpSvKs16IU5l2pFu/fY0Mkqo9uA2mkrdHGOY7DXXJ+mTQzXNe8HqGQOA+5xUlHmGMUiSbkGaEbRtwjT6VDeRU58vWtw1tcuc505tGRrqvcLoEwQJz1RTZsnMmFLgjr0RUg/zqRGa48SuMlZyv2QrwDk3bfztbjZvg6tpgbCLQa1HAdAIs877TW9umDH75OCJ2w20tDU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 9:37=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
[..]
>
> If that is the case, do we still need this patch?
>

yes. We need it as cleanup patches. not bug fixes.

Best Regards
Barry

