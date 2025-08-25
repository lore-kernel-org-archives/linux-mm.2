Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F84DC83F0C
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC718E005E; Mon, 25 Aug 2025 13:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4B58E0038; Mon, 25 Aug 2025 13:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA678E005E; Mon, 25 Aug 2025 13:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E89B8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:45:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C0AC118A0E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:45:59 +0000 (UTC)
X-FDA: 83816008038.11.3F78CDF
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9FB92180005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:45:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MIQYDY7m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756143957; a=rsa-sha256;
	cv=none;
	b=qtJBIQCqEV4DrYDOYEZ6iuPrWVwb8ZtFH+eRrFDPjGR8ZVa6EhugwQHprJNiipWfLUTKDV
	vXYSl87A1SD5JR7hXx91NrQQpkeQI6dd81F2cSLKtaL/xEzQPiCBQB468JbBCIz6APV+UU
	e2y4d9ydbGbrp74+IwuoLziJyfJBwiw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MIQYDY7m;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756143957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OT/3jnBTfte7HdviQkf1yIS7M/qS42669Lv6VXZMcY=;
	b=Gk0Be+M7bFXvDsIZAF4W/mDT0inSBXeC43Qe/QPnmVyfkFatqjyJ1GVfzJTV6annZuQXBb
	5PwhiK9AZ4Adld7AiDmFdZAr/s4FxIVe6rqyNJbwlVgGmUjoRpb4UGvH7Xt1PrIn4/hyLf
	vhkhFYDQfic1LBV1PRnvvkkqVMKTF2g=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d6051aeafso39755227b3.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756143955; x=1756748755; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1OT/3jnBTfte7HdviQkf1yIS7M/qS42669Lv6VXZMcY=;
        b=MIQYDY7mRjpNX4/iozKUCeSTrO85lu/o5ET1qVWzKS2uGJrdk0gwY/oBdryhhhYiN7
         jgUx+UjDpmWLimx07GdCG7GXgLUg2pN2rj2bFB8KoQnrOhx9eOy5yApNA4Us3dsxpwhQ
         6Ta3St42AUV3ZMAw38EYQBHxKIVTssHkmc7ktJ7L0I5kWv2JUCeIgBYA+k1lGwscSEx5
         tbXh2merMlXgd4rgQf+0+StHAUiyLMgJ+qI5xx2OJKMPjgzeeHfLp9T9W3eUJm8/zuLv
         W4m+Ql691VlsdPoofloZjBGuZyRx0QE1yroIas35ZnuF0XrLhNGqTGBj2XzIJc37gBXJ
         EFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756143955; x=1756748755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OT/3jnBTfte7HdviQkf1yIS7M/qS42669Lv6VXZMcY=;
        b=k5g+L3dDDiKlLHy8DfN2IWVw6WKdEZvz7dDZtXx/KE4ewkdG8qYgexLUASDzYB1Ss3
         8dkMb/YrpTK5+AlsOFu7Tx/oRAclUdT8yUoLDA9U2t1K+mY8kRzsYIdPdYEmwgoxO1Ix
         QpBjOJuUZDuPPD1bxPX8h8F0jBkrTs6M0tMk4SZG91MyQa+1g9xAx8n3aUZPJlsRRrw3
         nlKae2yn5BIiSIZOWXeBp5WBo2d1+rE5GgOrN0F9MmWn/gSz9PMCyHUv01jpGYksw8Iy
         EYLsPho/Y1fgEPpHJpOIGj/Dv4a1y0M4kwBWlGOlm5fHp5zYYAK6/GSdxocDZof7F+Kh
         g5eg==
X-Forwarded-Encrypted: i=1; AJvYcCVN5MB6Ie9CgiBTIxm5s0ZRDbRQ0V/qgsR44WYeb/Pg325qTnSK+2ynJ4GPYD9BV8MoBuZoFesmUg==@kvack.org
X-Gm-Message-State: AOJu0Yz3kZkB/fx7UO++RFQPQbUJHARRT6LMamI3INIfHXHfGDqCQzaK
	2g5i59q7Jm0SCVyn3C1yTLp2ldlG6VRxtGAW5k70n/qlMXkHRKeSdEBpUiVVQybFeXBDPDcZE//
	l1s7PLgAIWLPVmQZiarXKH43abo8l3k2VoIb4wHZ7jA==
X-Gm-Gg: ASbGnctg7kw2tG+bQ+O/v5iWM/yRuCSuqHjRLhK1iQBcuuoKbEiYsaQ8uuL9XUraDwr
	fcaPbSLprefKyy1ElNwOh10QWTxZ8dF1Oas8l8Hn9GcW9qobHb2zsDaEec4tBB1mfHCx2Vxv8km
	rV2e5bcOrDX0/gjbIjcuJKpFpqwMAHgjHSlYDu9hh9pbWOilQiDXokRCEORbAlSbu12GuIkAkRf
	QJ7SFFabxZT
X-Google-Smtp-Source: AGHT+IEewseEoi5RyIQ11sFXi1Dz+0DgF+bccMhvM5suWzRi9juSFrm3PhDgSwCeoDygtX1TkgND9JR8BfJWU3XKEdk=
X-Received: by 2002:a05:690c:3802:b0:71f:b107:4dc2 with SMTP id
 00721157ae682-71fdc2dd2e4mr147859917b3.13.1756143955410; Mon, 25 Aug 2025
 10:45:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org> <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org> <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
 <aKivUT2fSetErPMJ@slm.duckdns.org>
In-Reply-To: <aKivUT2fSetErPMJ@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Tue, 26 Aug 2025 01:45:44 +0800
X-Gm-Features: Ac12FXz-noqncD7Sg6rActzzOUu7I8FaVkMIzxJKc6Jc3poEaZnSiD5yWERwbak
Message-ID: <CAHSKhtc3Y-c5aoycj06V-8WwOeofXt5EHGkr4GLrU9VJt_ckmw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9FB92180005
X-Stat-Signature: 1p7qyh6yfpg9cdd9xmgpehqzduueg6wj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756143956-608074
X-HE-Meta: U2FsdGVkX1+lqf0XzL7K8Jm8w8U4wZ8pAaRIDPoQunGr6APfH2zZvhQeKKMkxrzcDhhXEfy9a3G9Jz3xX7v7xu5vOXcJ3lR1ZK2yEjibg64uAt48DWBy3aRUrAXVkRNLi7aiX982rJJRUXTlz5yJ3lPmSXTQcAGEAtxO0i73mKMy83fUI8FfJ77K6fr6cCMpjzuP1zAcMb8Zg+0ST2LpFyi7QIND0IGUGh2IYPBXT6wo1q6kQqXFe2w5kMlQB2gAkSkYhG2NNZ8aT9Hcej4TZWJLhpsXIp6C4UQ4VH794EsurSguCfDL9egTYODt9sv5TDzMh19wOv6qhlX60blG3pButLFfXr+afwOTiOR7t+uyYTTvUdWcqLp9Nn8N/PBNJF+aOlLKGsEosONmUjBI7tile1i6m0UVwU0YoePNiRs0A3Zi1qyYMrPwb1CUfCzSIVN5Pdyka74RhVY3CKlhEDKorfNlHU3rgYRuQsl6rmNk02TBUR98536+DX7kU94hPy7Y4d8gOOj40xB20QyGpDibBdbaCO9YMmlJnY2EueBXZ7kEVd5TSsQkwCk2Jfj+o1mPAngfe7pje3oNZ81knSi9WxxeB3uJuv4KkQ8T7WqC3ISQW6gO3RM2oBs8K9Kzbby4DELutGM+d9PmpcMlIdEi2jcKsrwvPxys+6v1N5lh/0pCBWlfInqQhJLxgKXLNs0OVbwV9lGq9SPr55v1PDjTyNh2Re4gu4lDvHMekH6u/mvPCNh18An3ik12Tj0JicXxcKhuDzEulhKKldGVKqWAEf/L6owcjXHq4parzMNu2ED0xbTlEwCcjXO9bkOxgi8YBTrn6Fx7+tPXMutLmL3MwZnX5eGIVfK/+EuC/2F8T8XQd16T+/v386Z8LYVC5EiAx8ROnoy7t/isl5rWl/2dmI7qMnGkm6hQ3Zontm0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000002, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Tejun

On Sat, Aug 23, 2025 at 1:56=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Aug 22, 2025 at 04:22:09PM +0800, Julian Sun wrote:
> > +struct wb_wait_queue_head {
> > +     wait_queue_head_t waitq;
> > +     wb_wait_wakeup_func_t wb_wakeup_func;
> > +};
>
> wait_queue_head_t itself already allows overriding the wakeup function.
> Please look for init_wait_func() usages in the tree. Hopefully, that shou=
ld
> contain the changes within memcg.

Sorry for having misunderstood what you meant before. I=E2=80=99m afraid th=
at
init_wait_func() cannot work the same way. Because calling
init_wait_func() presupposes that we are preparing to wait for an
event(like wb_wait_completion()), but waiting for such an event might
lead to a hung task.

Please correct me if I'm wrong.
>
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

