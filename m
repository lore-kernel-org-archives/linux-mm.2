Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1A3CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63FE66B0088; Tue, 23 Jun 2026 05:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F03D6B008A; Tue, 23 Jun 2026 05:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8C96B008C; Tue, 23 Jun 2026 05:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE7E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:53:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B51D12043D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:53:11 +0000 (UTC)
X-FDA: 84910714182.04.A8F37B9
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8A2D1140003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:53:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qa+wsXZP;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782208389;
	b=kZfQQjus+1FFyi/WamNI9V9USR/GAYMzhr1ZV/434l0lDmgXbxhw6Tatd4pCmoz7aI0S0U
	gspEgbJYQi4c09UXBqZqGf1cST3N+8fv98oAnITWmHUPYYSFYLXue1O5PnPj/bIL4H+3fb
	Y/QTlmDcbaKy7LZJeEZcUtMqDMd3OdU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782208389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD0SX+qNmhfrapVROd/rHVLulNY501VFTgteqW+bmiM=;
	b=a4dEugatdYZp6qz/aeqlrIzLyqVBBWVi/w0FJgnBahC+dLGFOtxEJJKNocHYugTpoNKcYs
	sjxOg7kvaiSQUsUWwFUbFRrtvlKRF1bqNX+5FHA11DEl6NfkAp2mFN0SfozT/Z0DhQy2s6
	XmdQr8kzRpMS8KJwq0A2GuuO8QLwOJM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qa+wsXZP;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30c5912314fso70155eec.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:53:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782208388; cv=none;
        d=google.com; s=arc-20240605;
        b=VeO55FT2Ur63UcSeEdyRK73WSeX+/aoe8olfRXY+qnwm1l6k2TO/lU6mMnBd75nbpO
         lz39wvKjOmA+4H7IhrQ5rxXjjlOcZy4rcl2CeiRS7uiCmrxU4azt2FOq2tGxao7vGV+j
         cB3UV9tEwVkH/T9vknLbhpMYqAlz38EN7LQbRZKH5HXScgM61vHpHZtGf045FQOTU8lW
         SazjLLVzIkUn3I/wqnyQmbaYnesqOHBY9TXW25/H8+cT9VNrthr36L18LrpE9eNZpKJS
         lWEekXo440/S87bjLXX5WZg8WuafRSe3gfJLRa1YKmWm4Z6HIxzH02+A11Jpf4/f/DdG
         6rrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oD0SX+qNmhfrapVROd/rHVLulNY501VFTgteqW+bmiM=;
        fh=wfgQyBH7nvlm+97Qh5aWimo5ZyA09VmWGZE1uAXWV9w=;
        b=kWDaNRJ4wrfsOFvvha0/fvD5Jr/bWloROix/4EAGCDf8C5gUHLE3oJepEyE4PK4FQ2
         oo/Z0gISh9ZrqM2YhUQPirLT+Oi2SIBJ6HzVYbXBJx1QHv7pnZTgWRE/Y9c7QyofzK00
         o+gaWHGhRAEqjfBS1SXb0q2+B/bStShA9JwjEv42hNnCYZ8kCQIvBctiYTEWQQEEAlyW
         itIDx4TVYaGv+LblWHNzvHbj6OrQiRgrNed/vSek9DLG8xluh6nrgYtt9sepyi5kXDNS
         jrFdbeahkMPLeO5p4QqKsTWJ0RhmKfGSz4bK9HP62TE0KM9Gth2l1AR11Q4m8mWqqdQ4
         KzHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782208388; x=1782813188; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oD0SX+qNmhfrapVROd/rHVLulNY501VFTgteqW+bmiM=;
        b=qa+wsXZPuQUnMvM+xauM/pAXn+LA6inuetdQBF4GmhqFIoI1ueRTnHqzWprRh900dN
         ACx5d2w++w9wTj5NJ2RV9a5/J6MkYaQglBx0w9ibFBw3VscEZKhkhW2TNk/BQEPg66dw
         h02mYmLSaX8/33TrbBSYdNnYsINxCnk+KGPMS+NjnVC3vYja42HRO68lkNSsPPPBRWkR
         45hc8nzlZRPuPWnn1LzUsGdEWkJha7VAFmbXUPN1W56lfmQ5akuDoZvk6acucb82iaw7
         YLNYik4qbNq8OYtuBMoeQme4j4XwoLM7uqIxBNzXsKQgSIhQHfS3POo6VkLoJfeJdcMe
         fGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782208388; x=1782813188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oD0SX+qNmhfrapVROd/rHVLulNY501VFTgteqW+bmiM=;
        b=UYjYLAJD6tJCEm+FgIY/mKg2BZEd44g57X8kRcBZXHFKz+y2gZYDLAyCEXlWiN/rD1
         rHvs/k6lz0zyrLwaCpvyBPmPDbQhZZvC7Hl1CI7RFh1jQxOJa2fbAnxD3yvOdY92GNfl
         +sc6ifoM6oPkT1vRycc/Z/6q7o03q048QYYa8G+x2RVIbI1lENPjn/ca2TqpksfRfrod
         fEgsaMRKOKHxJG5Enzaa+vlp3nctuvvIZqd0fP18dSgMIL/JLAMa9YrjK95u7JPBwn7p
         Gy6+2WQp4MCPIpXuVmSfCPnTw4QYOnQywuDzXncry5f8r8ow44qR+BpjwYthM8Khd9+9
         DYpw==
X-Forwarded-Encrypted: i=1; AHgh+RqcPSjovLwp2+D91aTPdCa2Naq7TGVg7BdNL6mxO6iXaCw+ffIfy/juZHfemsb9Fo+tnF6qclwOwg==@kvack.org
X-Gm-Message-State: AOJu0Ywk7akKevIp7J8W995yYsOzPt0Ju9Kgd2afzd/Eml3DcjZcBY3y
	uEtcUrkLF1u+TCbBzAOhlhpYyY0rr8DCSeRG79NqDGuK7cZacd2LKjBtzztotQ8wuwlDeom124E
	Q02CFDunOzlKvmnFbTNTki+SBGwdObN8=
X-Gm-Gg: AfdE7cnRvOS6QI6lHLIr7wlo1ShPPmwF5+DpvcC8vtZ6FaMmCbr4ixvgnO1qej2z+7W
	U94TDH3b4JiPCA9xxBfQol7jSpSyS6Msi5peMhtaxWzG2C6fmgtDyiGkaCgxOBuwmqfMUEkG1fy
	XHmJK0z1BnRiqZpSr8ySagUpcD93PaDSaNVKJq8LEWFrtVrFAim06Hp0VkI8jnKOkAUMMQBeVcg
	uO7zE0OwcgqjCEm1Ylhg8suet0W3lMWXY1su6itok9Dzcye1Aeioyu+80J3ILN080u0SUQnNkK6
	c4nZx02vIyruqrrNrhE6T1qcRpScLkUGJWmoSYSIlxrz7M5qaAO3ZSmwWjLSCqdpFhwnfsce4Lc
	fOt5SGtKBge1q
X-Received: by 2002:a05:7300:8626:b0:2da:b05a:5a7d with SMTP id
 5a478bee46e88-30c51e0a9c6mr1347953eec.0.1782208388003; Tue, 23 Jun 2026
 02:53:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260623093919.3543473-1-cppcoffee@gmail.com>
In-Reply-To: <20260623093919.3543473-1-cppcoffee@gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 23 Jun 2026 11:52:54 +0200
X-Gm-Features: AVVi8CeV80fcldi_N9sbAOnQmjyg1l3bbXCp4cBmAtT1SPqIg-CTD7xhKY0n3LY
Message-ID: <CANiq72=sSkApehxg6eEpAoNU8zSsRAfqD+RVymM3UQGuvfKyeQ@mail.gmail.com>
Subject: Re: [PATCH] rust: helpers: move list_lru and task_work helpers out of binder.c
To: Xiaobo Liu <cppcoffee@gmail.com>
Cc: rust-for-linux@vger.kernel.org, ojeda@kernel.org, 
	Linux-MM <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: mwcrbyq5yrcgjcbtu9bzjbgyb55m1fhg
X-Rspamd-Queue-Id: 8A2D1140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782208389-868446
X-HE-Meta: U2FsdGVkX193nNW5vFaAq4abPHar38gFyWwcsFZFm7cxkph4zEZZOgG3UpSekFqnthYcw6gS8pneQMppdH/8I9pkZQTFryL+yaSMzHJlJat8Xksib9176N3IDypY2I0X6ZvTybEOgblfqr0OilfVz3SPHcw/QZHBUotLp9DTSvQvVEmjcqgxIxopy2lqVSqYa+f6kLqkytw11Ov43Ty2EzUVEd66H9wgDOihbfRybShXdR/Hy8sKi866iu9PYycnjVcAiT2sSw9TK2rZK7GrYM5MpzR0jkDpT1I5wbRYhI/ZNhyT+tSDpid6Dt4bnmVCuXrFKnWnMmBanK9SOqyC4Gy3J1QO6YrdxK86VgM6NI4m/94GLEehFZ5Se6EuXCn4RkcabyV9wcpVn5uSSpJBBP8cVmVitsZ3iv+0tmjbDDyfFNfcDe+2ZG1gh6Bid/6Jh8+ytYzdyA3KlcNO1xE1/aNtr126rV4W89JyBV9re+ywO3D6sBO5ZjEut1iCHpHopLwPiDXqHtsddEWvkWaM+EtO3Rp8Lustkp6xSfd3K1yZiamFx0oG4GKqMmzUhSVbdsH/1k9HPC3cOl/6SEHIjdzv6N4VYQWpYuKoGnZXc/Xq7kH/b8ezPpACj548mSkjQBDGz2VtFQelXGNWUaUfA2X4VxSTy5qUaz7HWlMMgFl7ETEgHPkS49A7ZR2Txrd2sClxKZhxj9NXVnnWjMDrBVoRVN6P01lQA3q+tLSRWqadC4xdILmBWAAiUiy1+Gze+Nic/u6mPw9VVJhzKu6OmjCCdl8rrPeKbaRAF5bu/3wqNQge1bg+BNoJRr908k6E0fkXDYRnV0Z57iU0HYhwxf1QmRXrdiI72GyLOetQyA3iKKeEgWoUS1lTAkoMp8GB30ha0C2ffAJhg5Z8YRboRIATR9laEWtyLCp0t8pdq56W8A4MbR60sTf1763vkwy41hgvdl9IdPqV7v+flB/
 gVtIe8SC
 x3cVCbst2wInVnQLJGcqouDZyMdOtYisAxId7f0tJo2a/9RKCDyddctsB2XlL+N8P1rJS+Qhj+9gUoFHiiTcqQ7wtLMaINBMAoorh+7VYGoLytsbO2yrPrbZOhCnZBcaE7XWaSYaD+7jcTf0JGtT1epuuvgB5eE0/cU6zQBluzLEA6vYJsC193fimJIShpcIqcNLFcJwS8ycIuICkAJc2QPxmE68iFXk7ejYZTZ71eP6d8181ei/470uGz6E/NVxMvtMM9zHV50MMFBSmtpbNkNHNPzcwL7F8dI851cOoVvv00LduX7ZkP/JPHHv8DzwvWNV4uVHHH4p45A8nWzqkzI2gLZCLxlN8wNx9/SmJ+Q2izG6U3JbnjZ60poNRXlNA3I0l2kF07y0Bdy0HB0GvA0xUoK8OoqjfdN+ULEgvFnb80aN1KxJSceF3eNRdU6E5WO/O4M2vOr9lfD8LyNliLuauGzYVK7d69Z+er9gk4pR0KRu7jA6PpKLibxED4oZn3WW5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 11:39=E2=80=AFAM Xiaobo Liu <cppcoffee@gmail.com> w=
rote:
>
> The helpers in binder.c wrap generic list_lru and task_work inline
> functions and have nothing to do with binder. Move them to mm.c and
> task_work.c respectively, where they belong by subsystem.
>
> Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>

In general, please Cc the relevant maintainers/reviewers/subsystems as
well as the LKML -- `scripts/get_maintainer.pl` can help there;
otherwise, you can check `MAINTAINERS` manually too.

Doing so here for you to give you an idea of how it could look like --
I hope it helps.

> +#include <linux/list_lru.h>

Since you are creating a new file for `task_work`, what about one for
`list_lru` too?

(And we should likely add the new files to the respective
`MAINTAINERS` entries.)

Thanks!

Cheers,
Miguel

