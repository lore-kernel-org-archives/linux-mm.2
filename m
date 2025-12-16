Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E27D609D9
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1949B6B0005; Tue, 16 Dec 2025 13:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141D16B0088; Tue, 16 Dec 2025 13:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078C96B008A; Tue, 16 Dec 2025 13:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E98A06B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:20:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 642AA1367F8
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:20:09 +0000 (UTC)
X-FDA: 84226148538.19.5E76B89
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 706F81C000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:20:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VeIdLN2j;
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765909207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfDj9GtyCI8OW2NssNVdrr2ItUoHgFSeJ9plyqIAbwk=;
	b=k8Lc6jltgg9ZmLC4XO6QjxOCL+MJBW789S3ekOtEU8takV3RsXPakjJt+k9C4CZlOn6Aj+
	oZn2vTcnANh50mWenQbphzwJ0/jGmrwpc99TeybXm4ORb9VhGoWVsO6Fql3RXCOdFu/1qI
	NmeQP934Hep8LKhFeNVOLt8c0nXwLRo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VeIdLN2j;
	spf=pass (imf20.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765909207; a=rsa-sha256;
	cv=none;
	b=LGm4zTfMqZTMCt9mbXJ01j6yiZlIMBSGRxCxuMgxVqjWkgaTOogAWviF+tCQtOqnmA1+0S
	dP5hb/6/WtTq1VW6JGZHxKfioi1AbVcBCj0nXukuB1FQxybZtu6CdhfRl4fqBlnjPVtEjo
	T38SYi7AnLM4A7sQmEvssJx8C4rb51M=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64951939e1eso8722420a12.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765909206; x=1766514006; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gfDj9GtyCI8OW2NssNVdrr2ItUoHgFSeJ9plyqIAbwk=;
        b=VeIdLN2j5FsdytYMn8zrLJ7TRF8eIGVjWYrM3d1prJ3fdTP7XXF+dh4F15PAX4dYLg
         GQwB9LDVSzCMZWlQXHv/2XfGMGn8Ririm6zdvwoZH3bJ5WVOA/sVkHeNWCHmMh+RYF90
         qm9Q8wdst9eWrDwI2OyTRrXj9BN8hp+yAFD/ZHp/scRfUaY0989GHhVMcGI5BwJvflSy
         vcqJ1oDFSoViAkaanWjvX9VUDGZ8FIku40/rYk63xAWQKxkUCEdQqmDd0e6oLVk2yXZc
         Y5GeodKQ94r23TNKCNsukyy9rGM0Rg6lLaURl3TKHIOssNTtF5dF8OXpK9s8IAdiW01M
         tipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765909206; x=1766514006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gfDj9GtyCI8OW2NssNVdrr2ItUoHgFSeJ9plyqIAbwk=;
        b=NVfcZUvqmmXZM5LDtgRmr/N/huF083v24WiKjjqbGFYvWIIGT7VvocbLoHhfzIXobO
         5cywFGztcxu52yJ2pIQbjndWQ5/3H3PvlC99h12kZR0xfHatdFCzzdOk9/2jga4e6wvH
         ED/f2oPReZzx+P6n16vqg9BRLrgNVld6Q08NeCFcDWgou7X3Ub9NDMDuz4bm5YuxdRQr
         9qrOjumd7qaY27KepCGtkLbSIKVSZoxwQohqJjx0r2jHL01fX6qKK9C2vhyYQCp3Sm8W
         ugj6FKjTKDgxVkfbr/apKHVICr8GqHkFUudDRxI5UShVZDb78YjN99P698LdbrTMyZlD
         as5A==
X-Forwarded-Encrypted: i=1; AJvYcCWAS+T/wdTD3BruIRUm7CYShOM7bX6QntiHX0yJCmf4BLFXZM6Ry9p0OvqK1Ty5Wfv2xmlRgkK1xg==@kvack.org
X-Gm-Message-State: AOJu0YzS9Wwi0PL0NAnv2kq/kBEwsKILOcHFzzqm/1z/WkbRVF9/D25h
	IKUl65MB6x+ClElyTA3HycGvArWxeAh/1tMzqNuMwDdihgu8pHJdrKes+Uhcxc4MCxlBFgnNSRh
	OArBUS1zbnU3vRrybLaweOk2UenonJjs=
X-Gm-Gg: AY/fxX6jxLr2mIzbaSn9i7m6iOS++Q8mWIeMY2GnC8DgkZZ6dJvtIfOSbcCN/CjEF7v
	vIEDEH7ZdlefW2dkr4sxY3UCGYlGRxUoZyNd924KsnSVQafk1M1vRyxl+TBNwkbyB6Z3UJeSnGb
	gTvEV03ZByHGrud3O9I6qth2Y0SZ18XpCYJ5+kP+7TMfvtO3FTtLJpiCtVIj1w9I2C+VZeZbL7a
	r+TsYgMksFTJcqOfIcNRtgNZCCqIklAN5iTli2rVnC4VS+XRw/6C5hP9RdFMSYGZHjdVzznbNK+
	0b9lQM1n9cv5eMcriXS33gBXteM=
X-Google-Smtp-Source: AGHT+IF6gvW2ctw22PENqZ2fxxhJ4OjelzV4dLp1vzJIOc1xF1t2vIM0EWGCQb54F1tP9CobPE06Gi0x6tNNmhvzNm8=
X-Received: by 2002:a17:907:7210:b0:b76:6c85:9fd3 with SMTP id
 a640c23a62f3a-b7d23226706mr1609488866b.0.1765909205377; Tue, 16 Dec 2025
 10:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20251206131955.780557-1-mjguzik@gmail.com> <20251206131955.780557-3-mjguzik@gmail.com>
 <aUGSO68Am0VWVAuv@tycho.pizza>
In-Reply-To: <aUGSO68Am0VWVAuv@tycho.pizza>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 16 Dec 2025 19:19:53 +0100
X-Gm-Features: AQt7F2qyzJWfM9FW-AbUmqEArqMlN00Wb8yGW298fF0nOnHl-1A2xmu_prHUnTk
Message-ID: <CAGudoHEsq=1YDYYmN3uu_HMoVz0Rts1w=bkOYNP3084PsSdOSg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] pid: only take pidmap_lock once on alloc
To: Tycho Andersen <tycho@kernel.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: cn3o8xea8dyn9exbr9635ig6xhxya4ho
X-Rspam-User: 
X-Rspamd-Queue-Id: 706F81C000B
X-HE-Tag: 1765909207-253043
X-HE-Meta: U2FsdGVkX1/zUCj7CYi+ZrjhVE1h57ZS5pkeOYe5qEq1o0R3upVn9Cvwo4zzu0adyPw8dh5mYeuhBu9PXk3gAiStz1N/MR48j7GY0bH3HmGUJuB3llTAZJhHEPRAEp5zbrtP6/Dx/dfSx5dhoTXNMDfrJ+4PlBODJQPblKhJ8PFadeUWUNQ8/sihQLvS6iDDLeFP7ItcwxGfpdYzK/P5Z8beKf+MF8SIOTuHouiQRV7RSE8kXQWogNl35cJaho69ZkWLcDk3pItmDkdCsWTNV1eGvg8tR6mvr3xXwvG2gmnE5npizbrpxu9vIXZC1jaBdhDHXT2DAlxRjml5eGz8iXGDv+8L4ofM0MnJOOzZgDrhEsRUyPZ41EHoGCNHSSgoWGXK3e6X5ZDtMHEy5ln8eXZy9eihNZHyVszj9KLdjs7TuDeB4hRNANfg+GM8CpyrdspDc8oSBKuEwDz1ukKpS8b7clMcU0DzB/4K1TC3JWcHRVM5rtdqsQEMXXIvfo3FZmsEB1uDzPcrvg46wk1F1ogPRh7yMGO/O1BdjnpU5LrBAlR6QQMJBzQ7bgbav0WDBox//jhgybxdEkD3NvXmMi89vo9zZZwdjiHxzYISwt23OJdnXBPDlhBSfqqboKcb9GPmNz01iYuU8khhwoLy6xmpeePNadIv48pQsmWqwiJfS/+1+hx8smc9+yrT9EKIA7vCB8kKxDdCdrD15aQfKXD8MfpWMGwk+iYt2mcrFG7SQtEIi1Tz2Ap2ZPUiTJEUcEnDC7RNrQrgdJS+v82gEU7/CEBEGvX8p2qZzeB0tbXwk1/m1tVsd6K+qzFIkoHuKx5FOEoEcquUPlPDr4JTyE1EC/Os9UuZ2949vo2lH7EeGOnc5TfxwMTDa75SVM7nA52d2BZ0DB3Fcd7bKQ0vnDE4yeXaUIGh345OSiC845rcwOWPS2G2GOoDa553syNWXdWL4awOJWJ9Hvfo2JB
 af+xeeEC
 ZP7vGsPGNo+9hVgrszKzuPW630iOWAUqaXBRH0r/ke4RG8DfZQqxHxmwHKrPHD6A13nQMnmlNafRzifJpFwjiREg9uPz/qfoqs/TjF21IMNCMTA8pI+ab1gKmTyyYl00RIQdE7ClZSQ2UlQjjr6a+7ZyOh0teWHvZZO/yg9PYmayZuzYp78LjAVz9k4yhtJtH4rYt6lcSDVOJbB/3qm4YegfqurZEoQNVBPPSDk4aH69kj11lrXlnTFXz6S1rubWlEnxB0dmi/cl9dGEG1I9usSXJlBMdQLvyuRdI6bWoVid52oIOsXWk/C+GONvCPj7gWArCwyrSoLrF54teMjidCDJF+3VbRJK96CDTiRIRLQsKT9WrXhAZbt4wympowubBYsAzThrJL9COrSpVxovV0fkpYyTjUGZLFBgU2kNp1Abba6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 6:09=E2=80=AFPM Tycho Andersen <tycho@kernel.org> w=
rote:
> In a particularly pathological case I can get a substantial
> improvement in kernel CPU time with this patch:
>
> Before:   Time (mean =C2=B1 =CF=83):     53.007 s =C2=B1  0.148 s    [Use=
r: 430.891 s, System: 12406.459 s]
> After :   Time (mean =C2=B1 =CF=83):     45.624 s =C2=B1  0.394 s    [Use=
r: 435.021 s, System: 7692.072 s]
>
> across 10 different boots. Feel free to add
>
> Tested-by: Tycho Andersen (AMD) <tycho@kernel.org>
>

thanks for testing

> > +                      * (the routine unfortunately returns void, so we=
 have no idea if it got anywhere).
>
> Is it worth changing the return type? The underlying function looks
> like it knows whether the allocation was actually successful...
>

willy says IDR is a stale api and the intent is to move consumers off
of it. the loop is already a result of not changing the api, see v1
which add preload for more than one buffer.

Whatever replacement should definitely indicate something like this if
preload exists for its case.

