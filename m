Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74522EE57D4
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 06:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C589F6B0088; Wed, 31 Dec 2025 01:24:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C050E6B0089; Wed, 31 Dec 2025 01:24:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE71F6B008A; Wed, 31 Dec 2025 01:24:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5B46B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:24:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2E4BB591EC
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:24:03 +0000 (UTC)
X-FDA: 84278775966.24.FEE5ABE
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5C91B40005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:24:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ei+Uz+zW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767162241; a=rsa-sha256;
	cv=none;
	b=Dobtd2yqlVjJKgkCmtcBoHKw9P6UGnY18xY5cv+/5aPE9kzxl1TgPs/DiwwrBIiR88ZlQI
	OVglnLHU2/PV0DJxF2DOfZ9siiLjCXkC8feJ8awIxwZbtvOUDkb0v8hQBx8evD1IvVwBJQ
	+l5cuSCfJL111nrNlufpcor3hkNcW3Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ei+Uz+zW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767162241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwvjUu0d93qZG6sZgfSZozkTZHv3n21XyLmLwrQR6uk=;
	b=m6QMY7CzSWB90JfxJ2jsl7RY2WH72vrvig2RZabRxXgIoQ1JKDNFFqg0xXgvHNMxiNnp87
	cJxajOfWafhB6iWM6osJ1DC+v068IsPrpt2M1fXfwmGXcaLEIKg9KRSH+hvvUzAA2U86EC
	JBvFEpkHjNWutW+zVE3jM0ZhdVBWvnI=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-64476c85854so9344135d50.0
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:24:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767162240; x=1767767040; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bwvjUu0d93qZG6sZgfSZozkTZHv3n21XyLmLwrQR6uk=;
        b=Ei+Uz+zWMCLDvJgP56ji35vpTIuXKFn4ENVPjPT4a/BBU60ykNDv2N8EinBcl5+Ybd
         jPRr9Bd7RmQuAZ5DebwiHf6MzmvH1r9msD1NlX4BFdDLaIjr6IekcJOwehSdxjA1WZGA
         KGItiFXa6CqWbJCmLDT0YOxnYWkfw/vx0UP7m3cfKRkJU02YpKTCCc2T7Hnqi1kwHnGi
         DshNwO9QdaqU8XucotfXK1aPvuebF1rMAf69LETgaA8pwuB7Qdx0tUMO2g2e4SUG84jC
         LXjAOUtiwRR922mTns+H2xrFFVv3G7ODhGlJCPDWi64JNrPROpxaPNLrVM1aW/4M7Nd9
         Atuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767162240; x=1767767040;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwvjUu0d93qZG6sZgfSZozkTZHv3n21XyLmLwrQR6uk=;
        b=hKGRaacOdJT3QPbW0Qx4DB3epno2mYNaULCTX85qQYl48Vk/jCb3EHA2tEfKdrDT5U
         uQmYZkz0rtK6Hx+ps1FbUOUG3MUT/xe5DvWM34vaVBbxuOlk8oDCeFoE15B7sdJHaigk
         c3Mk9DitP6mArL0VeUCai0P/jY6Vm74GN5azJ78f6mjBDTwBdDPmxvmg/KP4zNt8HM+2
         bGV7La07VgC8XwYlJ5pweyuIrv87kdnNn6Rp/zfaRrcKeD8tGAFXV4pEqdy8HUbUSZeZ
         f27U9nOzr8DUiSF19Zeu1FQfV/IC3e8hyAWnJtcQ3NDkbGuFSK5M0wLwMME0tUMxEklk
         bqIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBMusHrtgNqrXu3E05yViNP7DIeMFeVIQ6yRya5BbnUIpB1kZmDtDcg7neY6LTNFG77hQehWpYFQ==@kvack.org
X-Gm-Message-State: AOJu0YwozwoXdtajgs/zUEcSz+P86w39ZJIY30LnpOA+59raX8JD493+
	7j7qjwSh/2FhKz6u7p2hcZk6+8vZ+4ULVysyyqwoiBVa9VTuuwiLBnZAzF/13LTsxSsUusJFOBC
	McHRpS4Tj4w/AljF/tMGzkon5Cfp0u4g=
X-Gm-Gg: AY/fxX7qxkok/P/7+MnvHCQ0IR7KIvDzWKrUmu0AHqJuSs7a+gUh7wZt1oO+xxGC3zt
	XJJcwJaiAEGOm8Xx+e5pJquqRiTAHn5l5phn/mj0ieSVK2k0KdiLiWiQcLFiunIXA7iciEdK5H9
	3Lf8ZDD63rNsEJ8mL4J6t6Z2fSzlE99qNehKD/kRc+1cVlPdpl9ErW5blF1luSuhtwwW7eMKszT
	uWoD7tbc+CBYhlBJN6UFVyZ+gdvsRRJN2FCdfsIahbehG5CtWOe63GAEQyToViZ78LKPTex
X-Google-Smtp-Source: AGHT+IExqKOYs2I0mOY5AkKqfsU/Mkp8RrJDp+UD/RFlnNenrvmaZMwK2b9yRpYc+pkmxj1Y/3gk/ywpaOz7YD1biNw=
X-Received: by 2002:a05:690c:c4c1:b0:78c:5bb4:1d4c with SMTP id
 00721157ae682-78fb403af1cmr638283427b3.39.1767162240391; Tue, 30 Dec 2025
 22:24:00 -0800 (PST)
MIME-Version: 1.0
References: <20251230005716.47160-1-sj@kernel.org> <20251231012826.75989-1-sj@kernel.org>
In-Reply-To: <20251231012826.75989-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 31 Dec 2025 15:23:49 +0900
X-Gm-Features: AQt7F2rI-GvhmFH5Jx0faiK5sgTkGJp3IeIlGfr1oxMY5MYCA1t_-vBC0NNbn5U
Message-ID: <CAHOvCC6RwVzujJcuosiignDEQoe038eRJHuJVLEtJ4-qP8Ot9w@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: modified control->repeat loop at the kdamond_call()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, rgbi3307@nate.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C91B40005
X-Stat-Signature: 3hihqd9p7qw1aju3erfhjghr3aff9oro
X-Rspam-User: 
X-HE-Tag: 1767162241-653697
X-HE-Meta: U2FsdGVkX1+1oO/okbIKwoqfx6tKGaAFtJqsagUK5ZY20RI5ys2SQ+Q813KFwPpYLMTBI/3vnryPzvMYcecF0EpgndT48mdwslNHtiSkyjiSawhWZ6Wmtj9qfcHRfBpimfgATXmh1iSa/YvcqJrr+TnyvWLS9yfIk6AYJJvyxKYIsEaufEUDHI91G+l0Jay5KRaUfmeiB8OkLpV2nIWTGUe3FZ5W+IVHqiULub3kMzrfV48X1h5IAbBxX+5prWYV+1LwmibDxEA3Uvc9I43nWDWvZoRmoGtQkAa7E3opC0q5SRro9Y1pr3cnskw+wYaXzbw2/9jxMdhM0+DFlfo4QQ3pv3gSFAw+21+7oFlGoKSclj1pGEF7w9Eo6K4LpcChDwPEJJCgfDr5xGGheTsZwrv6Xd9TWbU37u0mUJ7iyO8iadUgqrEIg5wZjgRrZh4Z7IjuAQRo2Y9NK6bRU/eeNacBQ2N8kYoHIiLSt5rZy3BJZ1xA8pVy5r1PeexVVrVmbN1qq0ulmPDzQ1qNRvN4G15fug8gcEesrL+C/altVDEaq3wS4o/3G4u3WJvPkXlklyyrAOu7uH8Hgsp/23bKEvfu1UyV8EOB84Znzqv+C+ACcsz5JyKvd6krk5O9KAtlGG4kyA0FhhNyBm2Ls2L1CK4QaTGO3K0WAcRC4r+GQ5cUoTv2PAHL+7yzVyAsxk+KDP7aU7qVnA3ilrHvbWntu9bPzxdEPW5VrqSvEEeB9sDp2XQb6y3DDAwT5bdisyTdZogUnOLN1a1kU/5Zu/hwxWImQlLKxJ8EpqxAjDhC+hLDsAAwnlgPaKKSJRtzDqXm98ZkQymzfNP4QlI+Furmpe9Ra0Szn2fUHllBrvl3Sk6WtBIKgvclt7IQnu8nH/9QMpFTcuvP2R3uDerqTHZkJKb8rk3Ee4sCbZzLpX6JLFP6i003Lkei5S/zMW6pJcqSI95sguoLlKhejaOdBm1
 iGqtKbDg
 OTHRMgahy8FBhc3z9snhLDd6OEe2m/jG9NAUaqDp+zCa5kGb5r2SfGWzyHilr5yW3TC3jpij9G374Uz7BnZ2Vje0QrYmjn8cbnARpis/zR2lQcU3po1AILara4C94JNLALFzkabH8EonawaYreOaFC2J06RuSn5C0Yp8PoSPBGCUI99cAhil54imWMwCSINp6oSSqx7LkkmLZi0olgeXIOH718+SDugzdVMCViQUqnmaKrElGD0B9EpdiPaSKYBaWtsxsIQMSPAOziKjIpM8VsvWxL7P977km2ZhrMq916dX0lK2M5bfwbvTCXeVtUUTsrtQ78VcmId+6ctK3YFGVhdT5wZMWdf3mAX1L6awLxMKkdsUbAJujQaBVb/lmKSWRo8gnViiBSrBGq+IIYGuYgRQZOIUTL+ePgYFc6xCqsh3YT6ruvaMzSbP6I1zw1A9oBa1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 at 10:28, SeongJae Park <sj@kernel.org> wrote:
>
> On Mon, 29 Dec 2025 16:57:15 -0800 SeongJae Park <sj@kernel.org> wrote:
>
> > On Tue, 30 Dec 2025 09:14:37 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > I will reflect the above in patch v2.
> > > Would you like me to resend patch v2 ?
> >
> > I just found my fix [1] of the bug that you reported has a race condition.  And
> > to fix that, I think kdamond_call() will anyway need to be modified.  I will
> > shortly send more details as a reply to the fix [1].  Can you please hold this
> > refactoring until all discussions about the bug fix is done?  Sorry for your
> > inconvenience.
> >
> > [1] https://lore.kernel.org/20251228183105.289441-1-sj@kernel.org
>
> I ended up sending the new version of the fix [1] without changes on
> kdamond_call().  Unless you have concerns on the fix, please feel free to
> proceed to v2 of this patch.  Thank you for patiently waiting.
>
> [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org

My patch for the kdamond_call() function further improves control->list
to behave as a FIFO.  This also improves stability against the control->list
collision issue encountered when damon_call() is called.
If there are no further objections, I'll send you Patch v2.

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

