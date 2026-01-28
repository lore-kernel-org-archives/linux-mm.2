Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C98D3568A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 08:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3A06B0088; Wed, 28 Jan 2026 03:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981456B0089; Wed, 28 Jan 2026 03:06:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CF36B008A; Wed, 28 Jan 2026 03:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74DAD6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 03:06:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7A2459322
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:06:19 +0000 (UTC)
X-FDA: 84380640078.15.7AAB556
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id EDE478000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:06:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LzQtXb5c;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769587578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enqYBRxEAs7b1XTfNQDYASta7yWhNLiXox4ui9P9FD4=;
	b=2PXfLzTFzKPgutShf4urS5NlSIP+OUTjJdVtllOqRHPR/E7mZEWL4525pByZQUBKkWGRfY
	VjRd2rhHb46ewYu6We2+PvxvebV6YuVxckv/7UsGM6d5MyWJVqNe0aGgnYSYvHBxI4NAzx
	8vMXFLjeCXMjiR4Yr448GE0teKZU2os=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LzQtXb5c;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769587578; a=rsa-sha256;
	cv=none;
	b=TG5tXo/Z+MGtq7KkQRd8Hm33f86tEpYlHQ0R1vzRtzVtYpc+j1r70dMSSS5/TFPbbxJ6mI
	JoA3KcM9rT/euV3QM4qz9G1YoMk0fni2OytNGWyu2C0mRK/iVNcKbw+mMTXe2yYi8qAb3I
	Ci1uXqzpJ5TmCJ1KLK8l0VP6jqnyoAA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4358fb60802so340377f8f.1
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769587576; x=1770192376; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=enqYBRxEAs7b1XTfNQDYASta7yWhNLiXox4ui9P9FD4=;
        b=LzQtXb5chPydHQ8MtmU66VL26vmzIv/bEWn8y+eVjLqgYkZ/MJeJFuo1gKMqan3R+Q
         E9ILCRTigo3XGjsHlli688MzEQ0bOTt3ijG9NfgQ0PY9ez1hSuvqQCPgKA1Z4BkYug8y
         I14zgpbF92hnCvaXcBnp7mwnUW5AwQJR6yf4WRUhYjFREiQNIEZuD6KUU8Y4jzfhKHFL
         3wGtb2g1+ZMGRxyh3/pdUbbctN/PoYh0wHGoCkuC//L9U1vrHNiJef7tNHQdNzF/virr
         VigITwYs9PZxwQFIt1Dcvd6gAL/r9wxAnwH+9eliRLIS/4/11TrHpn4pGZbp3DrAmZos
         P5pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769587576; x=1770192376;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=enqYBRxEAs7b1XTfNQDYASta7yWhNLiXox4ui9P9FD4=;
        b=Cd0qppAkYBTdND4xwNiW2qU3LXDUGnWEvK+urCwAXEcz92qhkznt4BPLQdU04c43Cy
         KmnhX9XKzuqd8W0CdVL0xYd53rgDR0ZfqjiDC3ARVaORCKvGGmAnG/MCh0KsAnFCtZrJ
         fX6mA+Wi4Bo/AZSnBTUnbS0z8HKF8EKCcMmTGaNO+BFCvOEPMegOz/hp4Xoi9xxJ5TJ7
         rng9iEntkr1KE+Bb6Dqe1rMthG79WYtLEs6bqq+qlUdbFQ36T/kCYfF0wvSt7sjJ/Uzi
         /7j5jujGEkCEgEEcKJdoT7hX8ChwinBgyHvlmd0jtLRk+9k5EL6jaUETk2unrZDIgY0p
         Qz9A==
X-Forwarded-Encrypted: i=1; AJvYcCUlw7pdkqvQEe+48ZqusSrm2OdEpso7EWpAQOR4zj0xIvlcAghC1OQt3tW7P8cf1bYTTv94LkCWeQ==@kvack.org
X-Gm-Message-State: AOJu0YyosfCecwg8ZXtAK3NlbY5rF7qi81dtJyj+GCbhlJPOSOjERhz3
	9gds7wZSnYS7zPrR0+qvMi0euXNZrJt9Zg3jjLI8n2yeXBD3qDrxJEK9E5qTyBf0QxA=
X-Gm-Gg: AZuq6aKqtwZSaHCaIqS04tEGXVL0rzBQpGDpy1fm2HIRChPeGQ0hwMdrE/QxUKFpQdv
	fDvsy3bseeIqLYnsadFv9HOoPga70r2TUgc91gyqe+BvCK+Gb/m9Sib/lJTfqodrKmG4X0bFJw2
	XotT4xW2PDt0AGNggbWWR7WDFEH65h6WDbwBPLz5q1MEc98ucnVYI6Rj6657OFgAz4Hz8no6/Ic
	8rdHHfSE8WGXpHNXn0rU71AXZuvDN1D+thdstz6xryWm0xh7yAcqe1gWw3N8RO1WpEDLMBXgsu0
	9GJ9nZevIlH9yCwAz3oE0o0kovbADhEIy8BMkigsy38vBeIQlEzbjtBOyxyUFtsLWLQxu7Gsb74
	5e3zcxpdIyfDQN2k57JukZQFWoY+UBKger1MwbFLtLhHdIBEPEfZStAAiCck6j/vPPLLGIzXekA
	V0hfmURNYPXWhTMn2koCwtpnNH
X-Received: by 2002:a05:6000:1787:b0:435:9a18:5a29 with SMTP id ffacd0b85a97d-435dd1ba13fmr6723122f8f.11.1769587576172;
        Wed, 28 Jan 2026 00:06:16 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10edfe7sm4930747f8f.14.2026.01.28.00.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 00:06:15 -0800 (PST)
Date: Wed, 28 Jan 2026 09:06:14 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
Message-ID: <aXnDdkYmtipGwSjK@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <aXh_LpTzDhvv20uB@tiehlicka>
 <7ia44io6kbwj.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ia44io6kbwj.fsf@castle.c.googlers.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDE478000D
X-Stat-Signature: mz9f6ouc85fd9a6z4814fu6t6fbc1m1w
X-Rspam-User: 
X-HE-Tag: 1769587577-965668
X-HE-Meta: U2FsdGVkX1/gGaBbKhDfxFMiQ2D4PRujm5r6/MXG8Qtw+40cO1szmuSoNb8zKhLUvS3CPJ1pPv0ll/dBF1b9eRfH5763Ucd6qzXB5MzZwFlnqTdwO1IlRymCURUFfrlfV5PZ/27xyaWlziArX/pZuzRUuqAjoPCF8At5SeMZyxn5A819YvoW+1yfeyuWt1CMm7g0qp2xrqIeBR54T916mzTWfcn3M6GJFahEb4kRZCDSqh1a4PMrz82dB9Vf5YAhGSr+9HuNmfIL7Uk046wT54+YKZQLUgJdIS0KcypTGZvBd3ebvsotLZMibUdUGTAuexJfdSZ0gQjJulvMFxQeAewUK8d7xNE9AJzeaSJvaUnOkIPqT0ZB33+KYPBqcg8uukqpo26yGcrWCG271iarmhBq5t+20po0YWAw0ZGi59BOEXirYzlBJH+CFIfqzIwQGA9TfLXXrACArZVxHRCTVatRrcbiLfZsIXwZiuznu7FbU3iU+PZe0qCTB30ZLF39jU75QJiWWMveLyZPBJIIvDm8lqHOkHEy+dcLpO+7NPmlE9RMHMT04zj0MbsIGSKrFX5mjKhebLPvYXaaJDCjs0vMoKTUHW8wMRMAXsGZxLcmiiAUukmnwXRwKfmElEm0oGcabLUyTPxR3t8W31WITvOL/N96PcGykYYKppHtozjSBNk4WYsj2g3FRneWYzkIGDANl22aoMQTgTIuf9dlaP6HGwgMKzWh0uG5BAMImP+VqGcjkY3yj3DsJiU8w1gAsp1NZ0TxGMfcCwItyTNhOq+0YuOWbbf++9zhGJSUkB8lT940TpYCZMMODdAdlmnFmJ1HQrYWRvYDJZxvhSvpL0l0eEBXOj+UPB6496ncau7qecqWEWNPytb3s0TQnf4KECygyLLX+QtvTJNIRx8mBWQIr83umRmP9KuhnumxP5cy8ZW91dbhMxdbesqglUOZ3BznsTaAUiay25g90/B
 A131XuEO
 t9xL2/vGdcwAl4+PSrBiCJu8zQnIwNfTTS3dVREAvfIIiktEgyFfLRc+QlO9S6FU9Xd3iF3H70Zih/TTH2F4jNMLR/iIGDpCfd48CBcGTcRbvxCmfiHCubSB7w3vApz3sLd140COs5zwzYyNRhgCBbrbyLjkZnDoaLvCUqXqL71IcAU0GGbaBDc2lpu019IVOh8Qv7Hm0xWeqKsFBbhq2ClNzILORY16NzaEIvvwmDxiVxn/vjBkmrEbG9V2q0FbviPZHTQO8pAZOOd1XoJ2GcIVZE18ZHYXegHUApHNFTJ34q3e7Pr7P5C9UM8+FsVz7hhQ9xgcSEMXBMmfYhHYgdA29mNFk0Rz6Wf6hKeRnte9dvrhuDWSIcVByJOty58ru3Bbm+PbzkWWP6imBcTa1y1O50Z8MoxWzZm6DV6uX3X1kYqnuiXZMt4gwdo7fHdKxLtVl8p1AqHkCbfFhN9MgzN2rMt7Kcu8x8lWNr7725K7JJMtYSX5OxUa0hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 27-01-26 21:01:48, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 26-01-26 18:44:03, Roman Gushchin wrote:
> >> This patchset adds an ability to customize the out of memory
> >> handling using bpf.
> >> 
> >> It focuses on two parts:
> >> 1) OOM handling policy,
> >> 2) PSI-based OOM invocation.
> >> 
> >> The idea to use bpf for customizing the OOM handling is not new, but
> >> unlike the previous proposal [1], which augmented the existing task
> >> ranking policy, this one tries to be as generic as possible and
> >> leverage the full power of the modern bpf.
> >> 
> >> It provides a generic interface which is called before the existing OOM
> >> killer code and allows implementing any policy, e.g. picking a victim
> >> task or memory cgroup or potentially even releasing memory in other
> >> ways, e.g. deleting tmpfs files (the last one might require some
> >> additional but relatively simple changes).
> >
> > Are you planning to write any highlevel documentation on how to use the
> > existing infrastructure to implement proper/correct OOM handlers with
> > these generic interfaces?
> 
> What do you expect from such a document, can you, please, elaborate?

Sure. Essentially an expected structure of the handler. What is the API
it can use, what is has to do and what it must not do. Essentially a
single place you can read and get enough information to start developing
your oom handler.

> I'm asking because the main promise of bpf is to provide some sort
> of a safe playground, so anyone can experiment with writing their
> bpf implementations (like sched_ext schedulers or bpf oom policies)
> with minimum risk. Yes, it might work sub-optimally and kill too many
> tasks, but it won't crash or deadlock the system.
> So in way I don't want to prescribe the "right way" of writing
> oom handler, but it totally makes sense to provide an example.
> 
> As of now the best way to get an example of a bpf handler is to look
> into the commit "[PATCH bpf-next v3 12/17] bpf: selftests: BPF OOM
> struct ops test".

Examples are really great but having a central place to document
available API is much more helpful IMHO. The generally scattered nature
of BPF hooks makes it really hard to even know what is available to oom
handlers to use.

> Another viable idea (also suggested by Andrew Morton) is to develop
> a production ready memcg-aware OOM killer in BPF, put the source code
> into the kernel tree and make it loadable by default (obviously under a
> config option). Myself or one of my colleagues will try to explore it a
> bit later: the tricky part is this by-default loading because there are
> no existing precedents.

It certainly makes sense to have trusted implementation of a commonly
requested oom policy that we couldn't implement due to specific nature
that doesn't really apply to many users. And have that in the tree. I am
not thrilled about auto-loading because this could be easily done by a
simple tooling.

-- 
Michal Hocko
SUSE Labs

