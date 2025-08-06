Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313DBC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 01:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8936B00AB; Tue,  5 Aug 2025 21:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90006B00AC; Tue,  5 Aug 2025 21:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6386B00AD; Tue,  5 Aug 2025 21:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE636B00AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:28:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2232CB81A6
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:28:08 +0000 (UTC)
X-FDA: 83744596656.27.D3A47C8
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2DDDB40005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:28:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kXYuKVUZ;
	spf=pass (imf17.hostedemail.com: domain of bijan311@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754443686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F174FEcKIx5bp+8tkyGPW+DIhLOLfIgidyWuudlk20Y=;
	b=itQQYs7HX7od/4rslIWVtsg2pN9m7+fWfhZvnpYyvukwhovUWF4u4CfJ9ft+Ti7J7VSivQ
	6IaxDNwQfoh4KtfS50EJpN2vTbQrfwZQg3JdFyioEOrmQOZlf1YvQaJgWCMqPFGxZkpR6C
	AGvOO/JygP/Erf+13KZPJk0CUE/CSfo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kXYuKVUZ;
	spf=pass (imf17.hostedemail.com: domain of bijan311@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754443686; a=rsa-sha256;
	cv=none;
	b=tMInyTT3SogpWLy3t3wPESGKmhMco3/hpJme4J/oTEcPr83oTaE92XmSwWdn7p8uJxox0g
	TlmJxucZxF3Qft5dfn67Q0Hz3nYd92jlO80PyViStfflwRD9aeWOg5pJzi/hmsbRWHHjrE
	IKPpJqi500mXSdKFNtstFKGxGpVVyUY=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6157b5d0cc2so6974364a12.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 18:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754443685; x=1755048485; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F174FEcKIx5bp+8tkyGPW+DIhLOLfIgidyWuudlk20Y=;
        b=kXYuKVUZpWA6ApOoFgrdJJ1/V7hz0LkQFPHqw7aeZY3FvpzOCcIrmjWZemnrk87vdf
         7ZF2EXPviaD7gQ4MG9MUR/650xk/cfa+1CRJErSKCwUq27+ltZZ2/JXbzv1BczCkxAfp
         4A8WEeQ/fpjJfdTXgxluct3gU/Xht8hZ5JKJafD8pm6TXBivAhEHrXE88fjvE5xvm0q7
         5TJ0epJ6n3bNnaiGl0/IuYBlGiXmtPCPRAnD4ZQhXK8dhlAUvUkhbUBqIkmdZSHAwIJq
         pf3DB2ciA4gL7ty9bqU+Lq10TcPl8TiQrQzBe6G7iWkSHvn7PQlvmvSpiVnlXaK8b3vO
         136g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754443685; x=1755048485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F174FEcKIx5bp+8tkyGPW+DIhLOLfIgidyWuudlk20Y=;
        b=r9qO8kT9w52C1ptp1tiN0b98aapo74lRZhFiwmL31bR55KrKzFV/EuMX9Qn8Tcpc9E
         1mWmqpthVdECkcGBPd0XgHx0HWxGXE7EgPLbuSJio5EWfnpvhAgZz2e5W5/2r+C7e1Ho
         SqV0a/oAWYxl8b3T5OwSrTDMtyPaVbUqawTwbNcRm4ufFR555FmSaw4OXpYdJZ0aI8B/
         HsMn02MEPD9I7YoF3/ejnK0v+bX7CKORIIiYy8l70eRHVgMAtuisthkAbrmRac9WF4Ez
         l6gEZBCJSHhf9HVw1R4d5LUSPSgORXVt11x9hpNYbqemrwyoJ8CLcLirsmJgq13ZR1KY
         oROA==
X-Forwarded-Encrypted: i=1; AJvYcCUasOubwMuyuZ0C3VUKUcXi+gI+rpgcUNBkbopCcgDdS5Kjn38Kf5w+yCMPBfEilTbu/j35knzgfA==@kvack.org
X-Gm-Message-State: AOJu0YwXOGz0DdZYZI6DUWe3GiwI7ozIGqyv0Hqc/xnzwvygn1IdYRl2
	QccmzwYfcvT+ikthjYxdWjkaa52E7o4dxvtPaa/akOXziTh2utBf9MV46XaEePpQoV3iUJWZEG2
	G1mXm9tQZbMSBVjSI6qN71o9ntgMm1zc=
X-Gm-Gg: ASbGncvBbEhb9g4tbYTdC2jzGbT0QkqUAqX0e7AtYNX+tjKRXf18FZL8DFoLml3V2jm
	o8JlyZfTPxUb0e9qctQACiCEumAmUXJiJW879K0sPSYnMlPscnLLNd0hQYqJ7SR4nCTov3NI/2t
	PSYnpVsPT5rC/o5OZBYd8DWVcMJAdVEzY5s/Q6RviEZWjFRo6dDv7y9vDtwItsHtAVwnCFlVqDc
	g/eulv41fGYeO8jFA/PmZoQBzvjdK56hfSwbHIprw==
X-Google-Smtp-Source: AGHT+IEtxmGoVXyQi9biUweIxyKxBVbBBTXXXrLHkql4H2KhjN85v5kEqkNbiWpW4Q+t3I4jyPYF5sb+cMzt7HA9eSA=
X-Received: by 2002:a17:906:6a14:b0:ae9:c2b9:7eba with SMTP id
 a640c23a62f3a-af992aab7a3mr52454566b.24.1754443684401; Tue, 05 Aug 2025
 18:28:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250805162022.4920-1-bijan311@gmail.com> <20250806004003.52864-1-sj@kernel.org>
In-Reply-To: <20250806004003.52864-1-sj@kernel.org>
From: Bijan Tabatabai <bijan311@gmail.com>
Date: Tue, 5 Aug 2025 20:27:52 -0500
X-Gm-Features: Ac12FXxqXWKYvb2iP2635uUmCnKs4Ru4zZPjGe2tc8MxztU1iI9ZJV3Enr-80ws
Message-ID: <CAMvvPS6hfCRh1fQh5zU5_quswPFVp0zWyS9N-Zikc0K-nSZd_g@mail.gmail.com>
Subject: Re: [PATCH 0/5] mm/damon/sysfs: Add commands useful for using
 migration dests
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net, 
	Bijan Tabatabai <bijantabatab@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DDDB40005
X-Rspamd-Server: rspam06
X-Stat-Signature: r8rgtk8cdnqkfm8eqtwgno939ia3fj6b
X-HE-Tag: 1754443685-506144
X-HE-Meta: U2FsdGVkX189IzISBN/TZU2ggk8Z4KGuFeydoc6boMZLigtxYfQ2Vhcobkj6Sa6/uWaPzMyye9BM6VMSxa54Y1AuteP4uZWl+D2xL7HNzRNqN/ttREEG8JqtBReV+iIday35ZSrFueIxJqA80rHqxFQlh9+UicpPu2sFX9Gl/Zqc9nNZt2BgzUoOzDPssr0qDrlCOYPLU7hQip2YXsa3WuLDWzdY1JNiTVc0ivAR4od8jSMbqutFJ1gOak16gMFDwFRZTx0+KI8MZLs3ZbtHapCFOHU+qEPcRVD9xDFBNbERkkW6mKVpJz3ntAAZe+3PnJxsuRG+mGv8kPDdlsCN8iYtrK82gw1GBlXnfiPwxLhtMwFClqjfWjdR+DRqyojGmbQSyrJ54HbjpdZ9ZawAz1OXK971vqZAvy0p5af1QxoDF3RH0CmcJlliIY/naqBN3iDHB7OHu7sWB6UnuLHsePmOLF+qphorqcC9cG3FJqoY+QGsNt9YjoOvvcYUuuv2clT5v8D5zjdsU9/FnG10OPyzYoLEJsiGHpgrnaO/kRbcoPewd1rpj3AjrVwazNY/M1WdQRf0d32Rva6eASgf+Vik2MqZv2oK2ihuaevvaCfi/aDKx8hORDTt8qysQg+2hbanWnN55/89dfDwNdw8+hBzS5TcPhCP7Str85DHwSIFgNvrHdLOqyf3YLq0Z88HZ3uAfllrUKSyOyvBY5LhHYb+3zGb14U1Wdt/lp8HExJxJ7+l/FEdozNzLCtNSwvkwrYSXu8meRWshliRkeghRpziWjOtmvy8uUwj37kCI7Aq19NpAbx6zSOlOagaazfIi3EmX1MqTbWzm88o4YkHLirkC/oDbtwOMWevCbNRxG03wlucTsokjqQK15mYjTv16EzDvHc8L/EM/p82gBsnHKDy5texSAY2FKsZ648VWFtLQoY8CvA2UR5vB6opOQnknKnr2yS7fQzZf56pJXP
 +UuNCUcG
 15/x8ssqroCbHWvjOyeVvTcWiplVzJPzx0KPgAC1i7ppaQvhSuDbGkaoxKvcl4WL3y3mgjCqEjyLpl6bfxVzRWvooG21/kAVv6Gd3+TshpJ9mkbd+MQiT8AY6De+UtWRXoHMwodCuAKiWHJBU4tJSXLqqv5Xivrp2soKguf3pvVYy2doD0MpT5w5qYohHXyOnur8CfMQ8KsVYMPEsl47QDG9jU8+vCPdeNlxfjrz+gkV2+etP0FYxM4hAOIXjYgWI160e1Oi4S6ENVYoMD2fo8i75qRduksDLMsIwnW24OzYXtWZXYwfI6CDPZ9mboM/JbnWMEDOsa+pW4VSX6QTCPgq1ExSkfbxlvugpvFWCgFlEFzC3aLXvZn8uJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,


On Tue, Aug 5, 2025 at 7:40=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> Hi Bijan,
>
> Subjects of patches usually be converted into lowercase when be merged in=
to mm
> tree.  I'd suggest using lowercase even in patches stage, if those aim to=
 be
> merged into mm tree.

Noted, thanks.

[...]
> > The commit_schemes_dests command, similar to the existing
> > commit_schemes_quota_goals, is used to commit only the dests fields of
> > schemes. This has a couple of benefits:
> > 1) It is more efficient than recommitting all the DAMON data.
> > 2) Doing a full commit resets the aggregation and ops_update intervals.=
 If
> > a user sends the full commit command frequently (relatively to those
> > intervals) the aggregation and ops_update events will be prevented from
> > triggering. Having a separate commit command side steps this problem.
>
> I agree the commit command of DAMON sysfs interface is inefficient, and c=
ould
> make the infinite intervals delay problem.  But, I didn't expect there co=
uld be
> use cases that use commit feature frequently enough to make the inefficie=
ncy
> and the intervals delay be real problems.  Could you please let me know m=
ore
> details about your use case and how severe problem DAMON is causing?

In my use case, I am trying to optimize the interleave ratio of
applications to maximize their performance without prior knowledge of
their behavior. To do this, we take the steps of updating the ratio,
observing how the system reacts to the change in ratio, and update the
ratio again accordingly. Because we want to approach the ideal
interleave ratio quickly, we update the weights frequently, motivating
the commit_schemes_dests. Similarly, we want to observe how the system
reacts to the change only after the change has been applied,
motivating wait_for_schemes_apply.

The consequences are not very severe. The problem can be worked around
by either updating less frequently, at the cost of converging slower,
or decreasing the maximum aggregation period, which from what I
understand may affect the access monitoring behavior.

> Depending on the real problem, I'm wondering if optimizing commit command=
 can
> be a solution.  For example, skipping the update of next_aggregation_sis =
and
> next_ops_update_sis when the intervals are not changed might be able to s=
olve
> the intervals delay problem.

This would work for my use case. Another option might be to have a
more general commit_schemes command, which may be useful to other use
cases. I'll defer to your judgement on which would be better.

> >
> > The wait_for_schemes_apply command causes the calling thread to wait un=
til
> > all schemes have been applied. It does this by calling damos_walk() wit=
h a
> > NULL walk_fn. This can be useful, for example, if a user wants to know =
when
> > new scheme parameters they've committed have been applied. Another use =
case
> > could be if a user wants to record the system state every time a scheme=
 is
> > applied for debuging purposes.
> >
> > The functionality of wait_for_schemes_apply can be achieved with the
> > existing update_schemes_tried_bytes and update_schemes_tried_regions
> > commands. However, having a separate command avoids extra work and make=
s
> > user intent clearer when used in scripts.
>
> I agree extra works are always better to be avoided.  But is the overhead=
 large
> enough to be a real problem for your use case?  I also agree it could mak=
e the
> user script cleaner, but adding a kernel feature only for user scripts
> readabilities sounds like too much, since the user script could have its =
own
> abstract layers for its readability.

Totally fair. I will drop wait_for_apply_schemes in any future versions.

> Also, even if the new command is implemented, since the DAMOS schemes con=
tinue
> running, the system status will keep changing.  If you cannot do the reco=
rding
> of the system state in a restricted time, the recorded information might =
not be
> that reliable.  So I'm not sure if you really need this strict waiting in=
 this
> way.

Fair. That was not something I was personally using the command for,
just another possible use case I thought of. Regardless of the
usefulness of that, the existing commands using damos_walk would work
well enough.

> Could you please share more details about what you want to do with the ne=
w
> command, and how much problem you are seeing?  I'm particularly curious w=
hat
> system state you want to record, and why you need to wait the exact time
> interval.

I mentioned this above, but I am using this to wait for new migration
weights to be applied before monitoring how the change affects
applications, but again, this can be done with existing commands.

Thanks for your response,
Bijan

