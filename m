Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080AFCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7047E6B0098; Tue, 12 May 2026 15:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB1E6B0099; Tue, 12 May 2026 15:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618376B009B; Tue, 12 May 2026 15:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5080F6B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:19:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F323C8D988
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:19:55 +0000 (UTC)
X-FDA: 84759732750.12.5FC9EC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D11F16000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:19:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHPIuXYY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778613594; a=rsa-sha256;
	cv=none;
	b=T3/O6BXCRXx9v0y4Ac81K16iKNA5iUnbAxBE4HwXQ9y2d8RwfkJ7A/TP0ihLzn2Fkqgi8K
	bLHYKRjUoGylwbag2Aj5qz1Q154XEQU6VV2KaeUqiyNunkpIV8FQRA61o6QgIlMtpB2Oo0
	JfmE0ElHLTjUe+KUq+s4/H0uurTqSHY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHPIuXYY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778613594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cHZaor8+H2oKvyFlGwzz5lxOoIPER6LO821Vrkq50M0=;
	b=AJeZX3Rp2UPtvYy5MHf3q7tNHc/Zfq39ccnPMAz8MKpw25oWruW+HXYu1IoNCPKibDisTH
	Nh/lWI0N5MlxBkyECbK54/2EtkJ3qOUIPcudLwIHr+TLspNV0DeF4FYvUfqiS1abK3diIW
	U0KHeS71CzErPqcgAazL2X+eQow0h6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E95860123
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D7CC2BCFC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778613593;
	bh=0pqjmErb0bBz+jPGkfkbyo5U07cAJWSPPiwi5VhxD2U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jHPIuXYYyceAa6gYQIBkkmz8snh4ZnnKTtFsorN3BWL1QomaPACptmV1C4zno1enO
	 TzP7DwKNIl1Um+hbLeT4grRBxs3Gt7Zy0c6793LTzF2SnDBIyahO24RBgJBUJkukp/
	 eoMAA1ecPMqQdZwDwd8wE7pl3/H5BpMWFNf4wqxE9IVetorlEKrf6EqC77GgPcI1nj
	 gdpYTMqYwW/fJiExpYKEKfBDrPFFGeiZsjmG/dl3ehCwdrLuI37AdRQVK+p5YcuOfD
	 WrPNisuwP3GesdDkb4/8Wzu7D6/lgtn99dfGbyi5JkRgnMO+CSjtvf9xyUnDnWL9/q
	 Xj8g5eSa696Ww==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bcda7765d64so510798266b.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:19:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+UwStFk+6HaTwgdl0XPdHkU9DjWO/4iQPXveKqlfEEJSRwtJhd+rjpSVScXPvWWwdk32ZcOuP7Gg==@kvack.org
X-Gm-Message-State: AOJu0YwlSpWg9m/YcQhcBImavmmesfm0fxsJSV829M2a91JH+j1RXTxG
	GAVbOUjwGPCDzsYHiKZSElWfasOoxY9C0jthukxqLgx98eoRzMWXBB+loeGqkhE0RADHLth280R
	FNT+NWUoKoqCdgNsGkGhB+6+cm9XtlQM=
X-Received: by 2002:a17:907:72d3:b0:bc1:c4d:cc70 with SMTP id
 a640c23a62f3a-bd3ab9a61f0mr21477366b.2.1778613592080; Tue, 12 May 2026
 12:19:52 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <agJT6D5zaUD6FpwQ@google.com> <c0effa9f-1262-4bed-a99e-ae5441ac47ea@kernel.org>
In-Reply-To: <c0effa9f-1262-4bed-a99e-ae5441ac47ea@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 12 May 2026 12:19:40 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP4EgQCSNgZbDaNWkROO6P6HJ3N6QgnAFTB0Ufe0zbanA@mail.gmail.com>
X-Gm-Features: AVHnY4IltmX3gwRLKldRQslOdG2_1-5pc6gcF8afVV6rLxOQDDzBSAPNbt_fxCA
Message-ID: <CAO9r8zP4EgQCSNgZbDaNWkROO6P6HJ3N6QgnAFTB0Ufe0zbanA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio swapin
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Baoquan He <bhe@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xf5efoz5jkeaimt4fst5bxx8fjf77r51
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D11F16000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778613594-693989
X-HE-Meta: U2FsdGVkX1/G7CCBauHEcqr0dnBB1yYggUGbLr1Bt2utkT6Z8NkV6uawtJfZJRbIGTqETk6/Ba+RV8MuF16j7wiuWXcEbGk09unMLSZC5YXoVc+yqJ0jasauRr2KnIh2qAv/4w37+VrNcQ6G1dbF46NWuRR0Qrp7wpZPMlrT8flJnjTnXqDIkVvNx8F3t+YtIbgDit72ODjnL97nmoFULMqD/yEg+Nph8W5fOoXwSbHU1VYW/6XkzJauePIcue8MaXLmP92arhGqhDoI43KCFXKhfU0H1xaW3Y+tCY9Izd5IhNIRQvEAzJBGoZVIAM/WqzJskblCFtIvbdrwhpE36I9FWizI/59/qi1YeoGmC8oPLS6K3+ovLktFdDr9vNTsYV+X8C397NIJNn7SFZtEUGIOgs2PHlVCVZqjJbFZt6aKrIXrGVRfG7xz+uvUYkY4nYnM9DYvLoCvGthWcWvWhxiJlp9/bVrro2b71MS7Jc4Xq6lM/Z3Ii4+CCH7/sWSQSbkzMdA+x+Ka7v93YYL9Bd69nTfHrDBweERY+H2/o51rKrf6D0Bw15tEG8BOAVY1+GRrGlKIp/vMzeqCEyL+YrQROEYkLU1T0AG5PlCIcjG/ODMWqblvwOXENY7nDX+m1O1HVNL4/UWJCketr9NnLB4YXjUKNim4/coXQxIvx6c9GPVCywSi3u+iggjnmZCeDbo9jGhUF7Lr3xtZN6qmRcDy5W0NX8aVHrbnLvALFMudb7ThWAirBXMFzDZHULsZS/xVP+6f+85q3AYTyz3W6tOHfoH8GFaK99+UHzu2pJkBeurCkcVXMPvobB5FSaiA11mSq4KryvYltGzhtmQT96UUBffqsSg3roFZfBw/NJLUid4avuuuhdvaWEV6zIQjaA7n6ePlF6iBy98jIgmszdCQ1KjrPlFnwoBGQdgHI0+0ab6hixQV9f/wUn267PWWZL4CCujQXuVSNbqHZXd
 MPsaTMLO
 SJ5JwQhBHLJcgGrGCntdPv9oKu4v6ZTHqNrIg9mv+JD2joOkX8hknQSxNwZKgLNwpbmc5paSQTzWKQWYajf4exeFBWokqK/RuWoUAQZnrn20XojtsViFKSzgs8HaYQmgb/zBUuqUih5COh/goM1hx12/IH5K4cR6hsSiKv/T8iFwai9IUxX6JiIqG4peLJIxW4SnN430QaH/CqNNEI1YMqehZ4ZbcawqRGWuibeT9y0zOYNhj2262nScuaEI438PuqVhGKe+oiooox2UaRfewxRaWAQ/LnBUleBpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> Feedback would be especially helpful on:
> >>
> >> 1. whether it makes sense to support all-zswap large folio swapin first,
> >>    while keeping mixed zswap/disk ranges on the order-0 fallback path
> >
> > I think so, yes, but based on my read of the code this RFC only affects
> > synchornous swapin, which is more-or-less zram+zswap. This is an
> > uncommon setup outside of testing.
>
> BLK_FEAT_SYNCHRONOUS is also set for pmem and brd devices I think, but that's
> also pretty uncommon I assume. Well, maybe if your hypervisor provides you with
> an emulated NVDIMM to use as swap backend ... maybe.

Yeah, I said "more-or-less" to capture pmem/brd/etc :P

> I thought there were other ways to get BLK_FEAT_SYNCHRONOUS set, but I don't see
> other usage.
>
> So seeing it for zswap is pretty rare I assume.

Yeah that's my understanding as well.

