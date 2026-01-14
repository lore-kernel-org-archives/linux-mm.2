Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5914D39013
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 21:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47A76B0005; Wed, 14 Jan 2026 16:25:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2356B0089; Wed, 14 Jan 2026 16:25:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD7F6B008A; Wed, 14 Jan 2026 16:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBEE36B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:25:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43826C0188
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:25:18 +0000 (UTC)
X-FDA: 84331850316.05.E6EF687
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C27640003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:25:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vzfq4TaW;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768425916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFssR9m6JmSEdLkwkhdloyBA1rXuH0CiSKtaJh/W87w=;
	b=otT+RSKDzjiifY7JT9PRtQ5b9RPHqYhk/gNbWk1UAI0hfoHFdGZbexsYatAcplrwMEhdLt
	hKim33xZN6UA2ZOhcYEzPbyEqd7y3PGYh5JDbZkOG4AfmGgVAL+InW+imw0qCQnr6y5/T3
	NqGSazHjrbhgAfb0R7sc4kr5EMnOC+I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Vzfq4TaW;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768425916; a=rsa-sha256;
	cv=none;
	b=OIkT2zBd4DrSxNZbV2Fvug/crBlCX6MSFz9Sv5g+Dp80LFx//voj6ApvOHHVBvjD8GYryH
	3aUfO/BhD2tEkZWljXVfnupu4nYooW5y1LfuLnO8uJbz7qhwDGbLolesnX9u3tMldFpXaB
	NTjOv0I/giEFCuVl5PIvDkWpV0/68pw=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47edd9024b1so1669705e9.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768425914; x=1769030714; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rFssR9m6JmSEdLkwkhdloyBA1rXuH0CiSKtaJh/W87w=;
        b=Vzfq4TaWM8Tz7F7xqZd8MR+AJmJOjEcl/IABrXrWyQUjAYyVomQ5vBzdtR+G57OYbq
         eLKjRQfHmxtvMmR3jeILWdX1x7qXtRnqBKaM3NKc7BX9emTGKxQwam2I59c2SA2KXzAk
         m80xEcmklXhXAjAnpho+tMx9vf7NDgLIRqRyCYzcbVEvfJVTvVyQtSKteiUcazezGbOy
         Sb2YQbYEgl0+ZMMuwWDVAdof+LkeMu2qYQUo40/ad7NoRhym1O4d37XKfnptJrnX70fJ
         c8FLjNr2whyEfuDcCTsJ38RlBckDQSkvGcEUffT6j6xkJt7TgOuloB3VAXxSbGyBbX6T
         jTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768425914; x=1769030714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFssR9m6JmSEdLkwkhdloyBA1rXuH0CiSKtaJh/W87w=;
        b=s8zZd2LEXXLESp4k0/p7eVsLDlNqUFAc65z4RrNE2RGrjwVN0DK56ybnVk3vJi5KEV
         WGb6riG81r0fVM2SYCsKsLzDETQvRDgxnHnAUEnmZ58bAT7W0k4uF6Q7T0se8/jFxzdl
         1oPV77N8SijJhdnXOztTpqDktisDey+5mztAKPD8OuAvosdHG509lu7p7wrsGu60nUw4
         lyuHge1Hs6ycN9hR2f3KCnTY+ezIUcueS/gtXvAfM4AZ7Eu32gC0kCvNdvWjHyoiNXCm
         cOlpv9QL9qpKW7O1UgCvEORtc1PLDw210hNE0WV29gsF38rVxfg9pRl2/EeLFxbpowVz
         zxDg==
X-Forwarded-Encrypted: i=1; AJvYcCV1uTG19dG6lgh2eXHJvBWYgFVxucglFIAAcIpM9pJZeF7PVuSCBW1yESWEhVSREbU4EJjxyk0q9A==@kvack.org
X-Gm-Message-State: AOJu0Yx/Dzf9OZDWJ1F1hCKGiA5nK++bwBKG9LDvrMhCOJF1UlMvUsqe
	IpZ1q3Uuu1aWeEEvdwyOa4qngdiWzRV9AgWnbi0qFKhBCJYKUirAivPfBPq2PcIXliI=
X-Gm-Gg: AY/fxX6FtYxdFgYdNZZaWGhP0v4nbqBgFGPYLL5z9/rz3lNHhtLYgUREUoyNFk/Xm0Q
	LJ73g+byEaj/5U1g1//7LyaX3wh7sqshQEF3jBy45l6p3nfP54oow5Qt1qdHHdAbWoGChMjWokl
	Jn3uJfwMLT0drmn6oIosh+Ot28t3A8oWQrABy94+WiDMhGElC8GtvLVfsZR25AuQrzu9CAX2CAE
	ZOvZ43tyQtz6uL2H76To2XfjWoFGYVsjY+zsSri/fmtuKEI8PUACH27zHMNcaC6q7ratMhFc7ZO
	VraWAcCIPg8xAxzztAAU+LMw4s99J1mKi4zsDAJgsYzuyNfmaWNSuheIGmW+H9T+1thddlcogia
	z6byMV7LFtJJFaq9Q2oJUNx57nIxeyFP3pqp9eI3PiTKl0NIVw+dlHAlGu6oT1G82iCNVt0W5he
	+9fQ==
X-Received: by 2002:a05:600c:444a:b0:477:2f7c:314f with SMTP id 5b1f17b1804b1-47ee32fd1a9mr50887305e9.10.1768425914375;
        Wed, 14 Jan 2026 13:25:14 -0800 (PST)
Received: from blackbook2 ([84.19.86.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428bc400sm10109435e9.7.2026.01.14.13.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 13:25:13 -0800 (PST)
Date: Wed, 14 Jan 2026 22:25:11 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
Message-ID: <sp5yxpqi62ymfhjysggmuvxxcwsxtz5kthu64h6kr2poymesbd@3tjqlq7z372p>
References: <20260108050748.520792-1-avagin@google.com>
 <20260108050748.520792-3-avagin@google.com>
 <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
 <CAEWA0a4s+Uhm405CnvNsE61ed5_xJ8PUZqL74zfeZnivw1BChA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAEWA0a4s+Uhm405CnvNsE61ed5_xJ8PUZqL74zfeZnivw1BChA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 8nt9gewzghsqk9h3gx46c48ad7ts7s8n
X-Rspamd-Queue-Id: 0C27640003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768425915-400565
X-HE-Meta: U2FsdGVkX1/H5owIMc2QwFOXvXSvjn/KKI0S+hKKXL8lkD0FVw9v4iaenXCDD4yjh+IpiSsGhejM+XqAEZ+s3+djAAOBp9KsUkmISNZHO04yS7kKzBDk+Rk2pNkYPw8gyb1rva8vlFLmSyElVVfADVyiZZ3fHwO/m5JlLBp2x40h1qp6r6jv0owOVEyhrArCj3alRmGtFx31Uk9yM1M9V1syWsY4EZwVIiZhgT5hart6CN6jsgYOF/NQnOLAqJz9ojLuE4tsj3pNhA//GBbwpxl1TUo31LE496uKviTBlTZXIUXLS6ZtkjXwReqJ6bkf2MRi666zw2fuHNd/AGD9kOYgCGLTIUewQ7aCoS1HLLkIeyV8kZ1q1qFG87uXulCz2gUWbUg72wC2cg64IJYVil3F4MNoKvgO/MrfiGSBlKDCMoHXwRkSfnsaJl59h+n5YrEqqpCl3/04eX13kLVEXX3fCfDMsaWFGO3Vjp+M0jRhYFW9fWxKI99kuM+XoCMgIa19bSektaAd7dpUSkU2hWnF2IItHGlpe5Ai3E5tS6O6Gh1BrbYrbE/dya9IYBVsxhMppJixgZJkIwwIbJoAjG9UbvuUwlB9/ofOGR9z4MJtmJiA2iFOQsoDsFyV4YVPf7FbHSHs2znOGMclNb6nOTFyvSid4wym+zYrOQNodZfJvSC0enhzqd7/do69I0L1TBT+MzsneYrSVrExGRNNVRWdFldyQSbSgZduiF8crK94InQNwj5TW7Szvqk4A0A0RVHd3hfCR27pSJrUwT58uLRIZhJJUL/tb7vmBfZW0gSqW8+IEWHDlJTiZdBoaDXZRcIYtCfs+ITFVX1LclFLfUITvQ02xENVbaPGqlLh9ZExAq5JJoyvXpa6O4g3KLDBIDopB8TncOWKCWpHps7dy3+1hZSY84b86iSaLWCyZE6KTB8e1IMzkJAxff5MQ85USX9OtuiwLjKUmEw/jMb
 LSLHM1Q/
 z2A7DNF3/WEqJN7OtGaUCkhZzrgXP22Mk7HPGWve+TxAL2D08mLfkPxb50sYLvsU2+URv8Bx9/hA+xJZkPKpzVkwJ9PfmHuxEkaaGaCTwvUlhu0eUgoOTUi4OMsWrZ2i4qHEPn6vPgKCVWmW7fbiZPkFZF2EMFcRyYQ5QPb4iPTetm1CeAyZI3bN0ubWk6zCdG/w4ESfDxjp9OlGWObrZJOL4fhf55dG9+1yl50YLpPRIse/aYII2xQ52Wgh/Jn81P6j2263YgFKebNNTc4J/vvrw3pyB77CFfZPuvm+oLg5uhpt1mR6e03TwjOoi8EhkReNIMJst6sML66Ojjrmt+QBLdEVkCfYDGMhuBCFK6ABGv+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 02:18:18PM -0800, Andrei Vagin <avagin@google.com> =
wrote:
> It is true for all existing arch-es. I can't imagine why we would want to
> define ELF_HWCAP{n+1} without having ELF_HWCAP{n}. If you think we need
> to handle this case, I can address it in the next version.
>=20
> It is just a small optimization to stop iterating after handling all
> entries. The code will work correctly even when HWCAP n+1 exists but n
> doesn't.

Indeed (I accidentally ignored the AT_VECTOR_SIZE condition), it turns
out no big deal then.
I like that it's not needlessly searched (and copied altogether).

> The inherit_hwcap function is only called if MMF_USER_HWCAP is set (auxv =
was
> modified via prctl). However, even if mm->saved_auxv hasn't been
> modified, it still contains valid values.

Hm, bprm_mm_init/mm_alloc/mm_init would tranfser the flag from
current, I'm still unclear whether it is necessary here. (It should make
no harm though.)

saved_auxv validity seems OK then.

One more thing came up to my mind -- synchronization between prctl'ing
and exec'ing threads (I see de_thread() is relatively late after
bprm__mm_init()).

Thanks,
Michal

