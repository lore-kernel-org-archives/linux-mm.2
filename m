Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B3CACA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 12:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBF96B0095; Wed, 30 Sep 2026 08:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D31F6B0096; Wed, 30 Sep 2026 08:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9C36B0098; Wed, 30 Sep 2026 08:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1302B6B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:39:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9271CA7356
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:39:26 +0000 (UTC)
X-FDA: 85270384332.14.A5752BE
Received: from mail-dl2-f40.google.com (mail-dl2-f40.google.com [74.125.229.168])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B1694000F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 12:39:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=be6tSWGb;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.168 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790771964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufPsRVmbq2iTAMU5/0hWY230+5/O8NUpBJI9AxEx5Fk=;
	b=eJ+wpcBG1TGksAOcx4fXhZz/X/cPtYolyJuEZzfb34o/MWSw+KF/GQ6o5XsgU04tGoLRBo
	HVJy/Q9h7iNwjeKuz4Xx80acnw73xq3RpB9R6DmByUyMSUcTnwkE+M1ev6tH8BpwE0ymjI
	rkw1DzjQaHHGUr07tcsFMeEtGEhR7OM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=be6tSWGb;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.229.168 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790771964;
	b=TpIROq2WZlf29V+MTXPXrjl4EWx3RGVKuYEARcnluyGubSkfAEYJYltDjq2+v4VL0ohxlL
	c+U4cxA7ahXokADjKRfVhckNkyQ2MLUlgVe2UrLp2/z5PSw5jcnOm5zpp963hg/pksQvbW
	monkXir3h5AkvbKBELzHsbkYSFDaclI=
Received: by mail-dl2-f40.google.com with SMTP id a92af1059eb24-14c96a4b7c7so142601c88.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790771963; cv=none;
        d=google.com; s=arc-20260327;
        b=SLZ9TrIEb79IUd3TC70aeny8gtFXW0UducHLXKITrPR8aQs3tC2sIZqS5qlNc/jXsz
         RRQY4mrQ146EeLV5yDa1dVIwzVPO5csLE1RPBRVvGKiG/QUl53kFG8od46HsRltE0Y+Q
         SW0XWibwY6RgNK+d7xq3OsyZ01YOQsQBfmRGDynZCW0B1Y3Ba71gHlYqwALPMCDbLKF4
         gl7jcoLblQEQEfE7In73N2ELg5+spNmV3w7R36jgE+zUoDdX7xDJqc0k687LF32ux9qj
         KQz7edGjq8VBNqK/JariS5UG2p+zC4PPzh5guRfzZrsqfJj82Q0Ay0peWdMTTerefdqf
         llzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ufPsRVmbq2iTAMU5/0hWY230+5/O8NUpBJI9AxEx5Fk=;
        fh=xQYVvB+w1tmu8JFWxqns4JZd66lGkVAf2sAcljKg9jQ=;
        b=ZElo84ozmpTWdM7HlE/6OKUUO0QodQlf6cEiDuNk2QDi0Y/XLXUznODLrSZpwg5RUO
         emgqdAatZqD9lLz6SEexB2TJ5pfvylgB4seJDBqqV0HsHCFrNJybSrLNr+bJ1g66Rd5V
         NeMl6JFhL8dlrM4vdDut+3U8qdWaYU+dQ6NsAg42YJHAD1nMBCXQuaaBgkYZBxEkQ8c8
         RCCh5estj0VF03WAOIAgGL4TY38wZVfIYjj0WyO4cyR16byUP11yWsqAzor0CfyGI6gi
         qf7SdKMjQ36fmQBxt5jVbU4jkK1zRSg6pkQrcQMM86oP5ioeor3ojeIl7Vtez94iaOQS
         oTqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790771963; x=1791376763; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ufPsRVmbq2iTAMU5/0hWY230+5/O8NUpBJI9AxEx5Fk=;
        b=be6tSWGbQrcR8O0aNFoBNpPwOc1lPsp2ht7rMRoyMS6G2zvgC1KKyojvuecDzBuwUL
         AuQ50dIlteFLYvCXHKeaeTz51fu1aHwT58+tSctm9iMJN0/On2uczYdbXtnBu8aHk95q
         qUoP74gOmUHMOd6UNlEV2v6IWskWmnVowTAR/xDLKNjkOowvx3lceak5XRvmANwFyWpy
         tXNwpHz95NIfI00aIlJhOJ/nOXYGMAvUeEo5Rq78xwHuW7Ca1nSYPU9s+wjXlktplVn4
         YG9ZtlTo9f7NF1313UX+LVHKB77xoqM9QkA7SxOJdv+/n+WVIPsbfj0jbniCBKrFw5l3
         zF5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790771963; x=1791376763;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufPsRVmbq2iTAMU5/0hWY230+5/O8NUpBJI9AxEx5Fk=;
        b=MeGVzJKcHp2qWohXHQ7IqrAN/XdDLeW6BBbs4QgI4kkOMFAo5Syc+OGVfBB4TuW4uE
         aUxv3K89VkLAPqYr9BvMhQrUmbIlKfBJhxmG1wFw7ltWWRLQ+/Z15g2atn4VaK1Undlq
         2+CQAzDHvUgWdAqdFJKc4aOfB+O1I8CokqOZ52qU9iFH1sRwErEVoCEwVNHGrn1q1DKz
         Q3if19xTopQI4Z+DtHmBeJ88W+f+HhIFxUTYNfu5P8mKBr8IycznR73XU31cxA67JGoH
         GpplBK7mqOZWMHg4Lf2tlXJNv49TuXOTrAOtCrPZc7au9pQqEapfsY0FwYusS2i7Nb0F
         Wmmw==
X-Forwarded-Encrypted: i=1; AKwUvBzBMdeP7ANkcZREa2juWlzax57YUN2zV4ZyX83Ike2wdze+gqMBsWGPmji+3MlcFMJk1tjcGF8JbQ==@kvack.org
X-Gm-Message-State: AFq9FYJ63AlxlAsasNKi7qfI+rwap63VLTZ/rDAI13q5pzKs+paDJrXV
	rV9RAyo5SrVM6SPM0/zx10mwytrekYO9X0/TeUJdfHg6G/ueow+ZDksFjz6YpJKpC03HIlSLhQ8
	ZLSte04H1PNINdT5OYcwfACLgdNkJykg=
X-Gm-Gg: AYBFou295Xvy47a0Y3rsQIBqgua0vRslpxKG+RklutHWe60F+WyVerwWwEoOyAc3sFm
	HZmwnG5P/IhfV8a+zs3yI5+JPHRx+wbEvvkURewimCCg/Ba28gHwVPeINwA62vfrHfIM5MQKtrL
	D7X+w9uW7Cszn4/FGUMmEdNshm12Aaqj0SiQvF7LLIIU1c/kki02LAZ02uDEXDcdzDWMs9poVL3
	ezT7IZj3v/4weOIcO1nuROoDOOxQ9OTmacIT+O4VgGG/hGNLx3kCFW7mWzV2sPJUJQ7RqsdwZez
	bLd63PbCVr7wCuE+71ChcyqVldeuxC/8RMMh3cAUQpglT4tfxhwupZnC2IL0l3pWFrNof46uw1N
	+a3A2Lv8Wg/HjceOaTODMcWUVSHr+jIScl+mJGNuUU36WfrBc7+SdhcN8w+laklLClLcP7P+gMk
	2h2PcnHtY8N9+wR+ReZFUD78ewukK+BHVPnsXHAXOGBYw02ecglQY=
X-Received: by 2002:a05:7301:6192:10b0:34b:101f:cdaf with SMTP id
 5a478bee46e88-34cde6749bbmr2898570eec.1.1790771962989; Wed, 30 Sep 2026
 05:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
In-Reply-To: <20260113192949.689834-1-lorenzo.stoakes@oracle.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 30 Sep 2026 14:39:09 +0200
X-Gm-Features: AclHuK-Sjsrg_okIPMKenwQ4dypX-VxuVqb8A4w8gwXJEEOTFm7LvkAnn343C9Y
Message-ID: <CANiq72nHOinPTuJ7NLP=X5tLN76uxzz0k5t4tTcU+pz_JOCPHw@mail.gmail.com>
Subject: Re: [PATCH] rust: fix typo in bindings
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B1694000F
X-Rspam-User: 
X-Stat-Signature: 1kchk3a3mporozdnjmkocsehroop53xz
X-HE-Tag: 1790771964-709228
X-HE-Meta: U2FsdGVkX19ZLByEiFBDOxLXUstDFh+rz4mmMhcmDCNKja4+eOK4JzeRVV3nrj8GW59xE32GjEfCeKZIDYrSgYsxR3WCv9wpsQZDg7iq1m18lSM1Qn+UXIC2CZr0U7cOBf6rBisFPkpVcr9DP+e5gJeebPn6PGOl1bUQyGHhM67EdLphKtR63rGk0khZy/fktyMyg+MfbJae4cPkIqfX7lrv3k+96s5PcHRbjtYxgV2J3Osc3ZJMCKtCFFfvXgUXsUjVs0D4JjmCih0QJOtiOWQzuWkEeA8gjqB8+S9FtteHYiH6rlDziHWtFQX/bY5AmEbTEpfH/WUS4kj15cdckPIGtarjM1UT1Nzc4QYaORPAxv0BPYpcvfxhmVwTa5EXpsKBmZeXr0DRB8FbfnH6pWNeoey0cJFdjqO9EZkeGMZIj1muRdrHcgjqLRWPABfgGMdUYH+LVsnhMtbpU7RaiCo5G8E7DwkCMa+hxzT3aiuOUsyFu00ASrbejRlXikGdPN5njJe0PX31ko3FslBSDYD3hvE6xRt1USCLXDnhya4rYLWoB7OCQ/xzTlZMu6SlzNKdPiQK8FU2ab9I8jX0ok2+C7TodEUo6HuiFZE1+A51HrwmnmzkpTYCdOXuifpdGCfiT9hF99xozTt8dNk5LJoNkl0/nn87fZcHcmabaNHmjij1zsqTMlAFFgQBpJ5py34l4FoQm6QljfkGJeWujnReJ8Qmf5nLCml4BPZy9vXELvLoGInAFMsqvCtVD0nsPL71OsyuybnzzlKsCPSpgTsF/+56WHBnv9DjSJmVP8wY2vuig3f/TIhXZE7iM+FzMlzaGqnfppJUaKsgMCLdxZykktr4VBFBneqohT4j8t8Iz2pS9sYVyDKyhFNFURZlmsPFAIZNV2j1PTDxQBXp2HDlh6VxXWaYzwU16Ed7ggbOg1fGjBkZesMjLHlozhUVRubNvFHuqNsi9gZV4Up
 GOI1okmF
 mpUKt42fbiyXQvbv/igIjMxl1b/vaElfxMLa8WmFlY0PXU+CzcxM5vEpzSnNFcnxRtSU3JCgBpVAh8uvF0VBehYwQi+NxdhswreOucukL+1ffUYgqQFEv5xerya1TOzmVaLK9GwkGV+CUdxTnQC+2mR9Iq4MbE9otx7IzF/sJRMvK5pXCImlIvfEj9REJXjs/xutZMtGYkBTfw4aeqApKHZmAt6iruKx8M68tsfrXlGz4YyPWx+7R9q3KgYR0RBQX6qoYDOxeyfKIl3u0aXJnT7EMeP7n2p/76m2z1MeE9ydME33ELTAprLcH2iOhyplcj7AGc7TSiDY7G4uiYYvsQ3vouBy9IHoNATgtSP5ac1JikH1S1S8bmS/ErdHRrl9ofst880CzWW4hcWF7tTYwKZ156RQWvBfWV7a23YkpHONRAZ0FY+kdHRtdjiNDdidN/yQN4fsPNYvWYLu4ONQofck/OiaHPMJTKvWYX265zRm6g6n213A/WMVgsBzwIaZBPiB48EKq+6dewkF8ckp2ZnxAfInMsWFXfB7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 8:30=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") added a number of
> overrides to the rust bindings helper as the change performed in the comm=
it
> caused the rust binder to not be able to automatically determine values o=
f
> VMA flags.
>
> However a typo was introduced leaving VM_MAYSHARE to be incorrectly
> interpreted as VM_MAYEXEC in rust code. This patch fixes the typo.
>
> Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113185142.254821-1-clm@meta.com/
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Applied to `rust-next` since it doesn't seem urgent, thanks.

    [ Reworded to improve title and to fix typo. - Miguel ]

We also have a similar typo in the `bindgen` flags -- just sent a
patch to go on top of this one:

  https://lore.kernel.org/rust-for-linux/20260930123645.302318-1-ojeda@kern=
el.org/

Cheers,
Miguel

