Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B2ACC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240CF6B00A4; Thu, 15 Oct 2026 10:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2185F6B00A5; Thu, 15 Oct 2026 10:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155166B00A6; Thu, 15 Oct 2026 10:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA0DA6B00A4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:54:16 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85F2AA88A4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:54:16 +0000 (UTC)
X-FDA: 85325156112.30.807AA8F
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CF761C0005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:54:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=xkXsuCbZ;
	spf=pass (imf21.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792076054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92wt9W6nClBnkJMhpXK7yiFy42TeLGQnoUzCp3QHkss=;
	b=TjnkJ8rrnJr6yKTzhaPfAosbWL7wWMXr+sCtGaIlEZf8P4lkSUPwNQJfxd8GvdEmGMRmbL
	O/BIwuBrBdyC9SK/7nlPi+cEbSYIHPP2pmlCC3atbrNKVRi26aaK0MpIOdghJt0jmQiTzq
	PDYfYcd+MfuENk7zweDvFRJFUBAjvQk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=xkXsuCbZ;
	spf=pass (imf21.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792076054;
	b=bN75k7ckfnJmbxLoRfCCFSE9YzNx+UMRlIUADQVuqzRik+7AiwVpMBC4Wag3XhzGHCexwp
	egDfgUWXiLdrQc8DuEpMwViWcIPbbYtWk3VwmFxLdQyostvm/jTBgpvGjnrDgj5IPX1/AB
	O3toldYpjuaiZzb0FNo5uHu60Xt5wSk=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4j5B0z0yYmzMlQT;
	Thu, 15 Oct 2026 16:54:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792076051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=92wt9W6nClBnkJMhpXK7yiFy42TeLGQnoUzCp3QHkss=;
	b=xkXsuCbZn8jEUvC5dnXZLM/6WWnemlIaqFWfaUar1sjG3cwkMsOFusBbpTv7NNJiDj/pz5
	TkAq+HjAMOvSc7r3OY0LmF7DeibdIaLXOdWFqPOVe/MqN+ZLXWuAkTSKZUo/dRn8Gfud+V
	7H+p2uGARTL+BB5Srrd/ZTNjYOSJLU3yWvipF+1z8At9fxJ0ZA1NYB+G43ux0eBzlbPisq
	ezcmLMY/+ecPZg5kv1EvAJrGOH+2iAjNGpzceNtDD/yVomiKgIJrXsd9nxclW/DEjmfNtw
	Cl4SEdPrSvcYHG9U/YwQiEN7CDKsexG7l+xrAYE4MuwadhXzXOu1O2ThF7Wkkw==
Message-ID: <ec9914ce7333e02e1e9e49b49b8adcf38ee9fedd.camel@mailbox.org>
Subject: Re: [PATCH v2] mm/damon/lru_sort: fix grammar and stlye
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 15 Oct 2026 16:54:03 +0200
In-Reply-To: <20261015135047.87355-1-sj@kernel.org>
References: <20261015135047.87355-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-MBO-RS-META: mj66rq8tbouehnzoxehty3m9jh8cqc9j
X-MBO-RS-ID: 6230ca5123d12a61066
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CF761C0005
X-Rspam-User: 
X-Stat-Signature: gk4n8acm1k95x8sksp4azx5f3q6fhxgx
X-HE-Tag: 1792076054-774519
X-HE-Meta: U2FsdGVkX19YOwqNCVx9oIQZ7LVOm+3OqacGU34QreGrrC4THUEFKWtTV/5saYfnkREdeRwdIyXwRgIFz5wIiTehtIt0aBowz484l6QGDmLTuDlAwK9TCSmcsnF3KJVNGtZXG4fSyVZjqOH+9MUlziqKu8YxKpGX2wX6gSfPTVKLRVizkAfzsHOz3/vKGUNT9jlJB2KZHg+LzED2+yOKqcBD2teoPBX7NvVvMnUGLNtILLOhPTQ+M6tzskDaTYFOrr28MnU4Ur1Bdw9Gvk6ukPtYJKfk0oN7x/PHyj8K1bbkUaCfWFHuGEuAk0hv7lRJewEyzDYBAXU3MO1Puh81LV8rT04PFpqw3ce3M8mIhupaDltjWX+tm/YFM8FeZrW8rZ9dE/4i4FQvSgdFtl4SpBcC+0Ygs65IkZMh3dV8o1p9oIlNtvwIzCHiCQQT/SRUZFqW7nBLaHql1b1pQq2ny2lVDaL+rUnWURa6v/5dunD5mzdlWkgI9pVs2JuVXs9H+Q48LgqpiKQYUPwA6JLGR7YrvbMqiMRckdngAQcifjTX5UsdCxnd2mxAKV4RIKo8HqoNo1JvK4GbZRPQ09x0UWide3n0Z8p33GTN49vatjcSwY+Hw/63HzsrYs6ilf+osrfFp/fvo/XtguJcgQfnzJttvi6Xgunq8m/0cRtNKH1kycG+AkkQLwWCXtBeQ0qyNHX1VTZw+I8NL793Xd/DsELTGYyc5y3so2PjoVlDuhpmmIVaQ4eeAR+Vi2hLln7acFC2igqk5aaFWx3Q7qhcPhuTiXOVsnIAjcoGJaw61775Q2iKu4eAg3/7YHcQ7zl23Ofb/1MBfOuPYZy1SRr9eXCYxopvb1xb4d6HlA2S/EVDvjolZxHMddzwvlxaU5R+3+bD6nMGvqefhGMsSUelLpbMIOTb/XGuddVkLJAlOAucUuCHVeOgQRjii1bPHA4EBlL2TsikQky4HwZCOR2
 WBrgvYGj
 AnDRdc378p9NKvmq66H8kT36hD97AGYg655NaLtt6wmdVmt81Qn54GTIsTnfpOyNhONysGMz83LX+nM0wboI4LiPU96DUa9TW43XUt5nWa16XBsvHsFXINJKvZDOYxaSo2nLrCDcRJmVDpIW0IOGNryt+s9NvWFKw9vv3W9lEHtEGmJHj6rNA2wJRySKcKJAjK6M9bCFmz41AR9bccsmWoGhWG6qykAcf79Z0MytLGt/OgkToewwLgmHuns7vGp/eq7wP3hHs71RWKAOR1pOsvx5NL0KAfzyrNPag4INAKrtNtV1vrytmUnpJgBUlt8firVHMEsstGwVIMmZCGGHBZEn+jhguBFLMzo7yjmx5Dvt/JA9N50AOKXlWCMLWbGIULXfH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-10-15 at 06:50 -0700, SJ Park wrote:
> On Thu, 15 Oct 2026 09:29:47 +0200 Manuel Ebner <manuelebnerli@mailbox.or=
g> wrote:
>=20
> > Fix tenses. Split long sentences thereby imporove readability.
> > Replace 'set as' with 'set to'. Replace [] with () to make the file uni=
form.
>=20
> checkpatch.pl warns as below.
>=20
> =C2=A0=C2=A0=C2=A0 WARNING: Prefer a maximum 75 chars per line (possible =
unwrapped commit description?)
> =C2=A0=C2=A0=C2=A0 #10:
> =C2=A0=C2=A0=C2=A0 Replace 'set as' with 'set to'. Replace [] with () to =
make the file uniform.
>=20
> If you don't mind, I will fix this on my end.

I don't mind.

> >=20
> > Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
>=20
> Assuming you don't mind me fixing the 75 columns warning on my end,
>=20
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks,
 Manuel

> [...]
>=20
> Thanks,
> SJ
>=20
> [...]

