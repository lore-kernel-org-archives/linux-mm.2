Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05A50EEC296
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 21:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B9C6B0088; Mon, 23 Feb 2026 16:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2956B0089; Mon, 23 Feb 2026 16:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10FAF6B008A; Mon, 23 Feb 2026 16:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAD616B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:56:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CB911602A8
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:56:21 +0000 (UTC)
X-FDA: 84477080562.20.95AB65D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B632640005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:56:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SiAryGDr;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771883779; a=rsa-sha256;
	cv=none;
	b=W68A0R5nTtB57z3A3al8syojWysVhOWnwt5CjKjnzAuEiWCCh2bPWKD267ePsnFv2Fr7v6
	NzIdbylS7Dsv9om+N3CqIH8KZFqDyNk6E9SG5JnRpt5EdossxaBXCiQY1lNTZf1cy6HKX4
	9bxGLxATci6vITJxaeMdxjqmPXUZxYM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SiAryGDr;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771883779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMYKf0q3pNRXedO9tJdf88tZfkkLocSrnc6sVlK/UVI=;
	b=DMpSXYoVR0hfLKSe4QJAMqRf38olywE6De48IRUrp60bbVYZhnWJM4F3BE0Hx/3PXRjbGi
	2sDxou9BA+XqARglp/YPEJGtGikG6T+lDNMhflKCoGbWXiOQyg6nyKPNyMDcZHv/YOmTbF
	5M1lSu0jIqTFCwTuSMxOSHxJ5D8XfGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77E26419C7;
	Mon, 23 Feb 2026 21:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057A9C116C6;
	Mon, 23 Feb 2026 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771883778;
	bh=fQIHqy1M3EnBsPkSeluvFe+CzPVvJ3xbr05GGxDh4vI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SiAryGDrkCovEn2j4uohrVDXWPiJmV5sCYkegexSkKYuWS7Yab9U+c2yQqqySi1JH
	 2NH6LIJtP4os/QTlmf6YFUQh54Spl58Pu3l46yBCu06ZnvYyJ0YrZKh+QRk8lzd5xz
	 VsdkZXiJJ6JE8Qot2esjDx2JlBqtXQLNg1DzTZBwR1SVM7ATEbSFyFr83t+gaYcfA9
	 QcHHQNoEWnnCN//JfpsBuAlpojl35ab99z4OTP6BCVNEXqL+3LEgRix9DdCf+cldgC
	 sN9lkIDZYIAEqs5csxHzG5yfxJukTaUYLnpjn8Ss+xHvjKtgaE5uflauArFrZecsvD
	 HZIjIX4/x7wlg==
Date: Mon, 23 Feb 2026 22:56:15 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZzM_44L1vKzcOCy@pavilion.home>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aZdk19MqYhWK90Do@tiehlicka>
X-Rspamd-Queue-Id: B632640005
X-Stat-Signature: jbx7twmez6zndbykfwmrb88ixkqniu84
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771883779-417788
X-HE-Meta: U2FsdGVkX1/cE2W4AL7MvXlY2oq72tw0elcSFizs1NMZDrGtpQ5/fYDEcnvEdy0XIZIKSYbDYVgMj/mEXZqHKD7KNyGLmiZzytiVfuxSPSpzUV3yiacP0gqtWTWiAxGnXPWEaQdfKFyTMKVNn1hEUYGKxwuPL23zMdnbioW8vv+19unPGXmwy6X0h78CGsDtwmpnVtMPWzira8+3Dk2+I457Gig2116zljjDtVa2RAQ0eIXRkSIZFwPByZbBCYI3VjbYxZvBBVafWvsNRm6QGj0o2+ig+HySPrgcLgMkQeOcvUBEJkbQn3rR1BJvCITrcqTxvpgmxU0RniatBFMpzfnJd2t2FPncQcoS3+jh2NH0RlejflfHonR/W7ZvQWn7FDXBzogyQVSjfJoS4sYDXs4NjLs88gOYgguzbAbOPTpvSMF16byP5/mBw/oIL1bGPBR5WzQPIzKM1cToKiGVPswdlsTDesg5Emd2w3wLSLJPUYXm7v8JgcjL9lmlH81yfe+G3pg4/JYVjgcZi2EyIm9JvvoChf8Fkgnc60zLvikZ7Vznn03561FXfUrhtVuZQE2pwN34D5GcAtaoFa6+9OyhSI6e7ninIQyPCvBIFz75F4116HHzPi9OkBCgYksrSq9GUUJa4eCLVpmNQxPzsT9T0gJWby1h2M+rWT6ig6oUbgE4mrSdZHob/PyrYfGvpTNYKP8h7qSJfWinKPRFlRP0oHh5SkJOPzB6xP3n2ptjHGxsgZkRCGiB/0TTO8511W9npKmWk/wBqSIf3ATPiVGl5vq/Y65B/1MZe71ZwB37i1tDgle8C1xM966skYNRrjFuRpCwG9rEekLaq6+XfjXDKKIArWMk1CM30kL0IcqWMHvoUxWva5hVsoK1kZvBHIqvQwrffYIdy9C7t5WUPZBR1eXXqwpl0CCPzuBkpyoGE+hz+t+JxfayiJ8/O88FyqqRv9GE2ytQ4ts6Wal
 uVZxAkJa
 UCsq5OXAzDaZg6QubcdFOquzKgnIM/b1MVLvwsTMBOwBSbtEYbKE7DYH4JC6qdM9NuElz3ajlkUbdTJ/unhDjsFdbCoL6mZ7fSGljtELAqUeWHnYsSUsOEj1cmd8Qxkz7iuKtRXr+oo/dwr3vsPPOn7jLW9Z8DLV3EKriWWIcWp/N9vOJsjTmFrJBXb6qVHTgQ3HqualAWC65BCDT0KqXWDHK5MbtvvcJuXUUj7dapOl+CRVCK0poM2eqzbCqt7V1YOZ47TjzUZLxRUvbVcHdaWlhX9zeGspmkLKUmGI79hKAPoRN6l+TyEaH2K2us/CAaUTFWU/vuxYXhG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko a écrit :
> On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
> > Michal,
> > 
> > Again, i don't see how moving operations to happen at return to 
> > kernel would help (assuming you are talking about 
> > "context_tracking,x86: Defer some IPIs until a user->kernel transition").
> 
> Nope, I am not talking about IPIs, although those are an example of pcp
> state as well. I am sorry I do not have a link handy, I am pretty sure
> Frederic will have that. Another example, though, was vmstat flushes
> that need to be pcp. There are many other examples.

Here it is:

https://lore.kernel.org/all/20250410152327.24504-1-frederic@kernel.org/

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

