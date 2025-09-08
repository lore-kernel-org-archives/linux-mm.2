Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475D3CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63698E001A; Mon,  8 Sep 2025 09:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3A9C8E000E; Mon,  8 Sep 2025 09:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977DD8E001A; Mon,  8 Sep 2025 09:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 825B78E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:11:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 370BC140152
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:27 +0000 (UTC)
X-FDA: 83866119414.23.EAAADC3
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id 612FB40014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:11:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=qEWzUqpx;
	spf=pass (imf11.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757337085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkcpqsNtIfH0/2T4tzf3ihFLKwziOQ6MGxZZ1TVH8gc=;
	b=j+g1yLRilS6hJl9OmlTw4W+Oy8cs6lXKDKH905yGlO8a6J+vRvw1ZEwkVwx9Uwzbvu/fL0
	n5XCCR0FARWh0fzGKQKuRl6SizgDJ+dYRfuiLXeqdMDm6+yT296HLfhwBN6exVv0WXdn+V
	wDW4Hakt6+kTiXoGobeOjdGdeuBCbsY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=qEWzUqpx;
	spf=pass (imf11.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757337085; a=rsa-sha256;
	cv=none;
	b=bsE7B9V1krBIydrcsJNmnJ14sNmK7ZVTjUbnMd4WrMJOkUHsH8oCIPJtrckLwtA5bjy69V
	DrwQFQonCuCZ3AzCkJfbgqLWSLM1Yk51HJqvzw969yPs9At1Xkl+nQEbFcAJG1HQeo5RtS
	llewlOL4SiAYOfv2EBurqShI8ocNf88=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=NkcpqsNtIfH0/2T4tzf3ihFLKwziOQ6MGxZZ1TVH8gc=;
	t=1757337085; x=1758546685; b=qEWzUqpx5k8kXiuU9+Alzk/TTlN+Z3vsL2Oyc8Zfyq55+gf
	FIxA7UNC7dHoLg4uNInS3i844JlyQRxtttpUR8Ph7n8x4u79kwBw2I3vJlGcJvQYno3w9uXPbHaTn
	RNQogcALJ+dKSlOMiI9dI0AVL9hwwugSfhKOJG4YqvM/m9mdNJgio5xlDl62c1cJYj/Tb0irKCoq7
	6V/zEEqAaxAzGWNFc1hlyk2kbIyrPBqiKzwRfog+sIIt+NRkWCzV8/C4uzq6CpQAmHEjw8J0F9fLa
	Dtd/q5b1sxAn+nLsxTqxOUKetHkp3/9DCaqHVWgVEuVBYdhcZ5zxdf+C6L6o2UjQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uvbeH-00000007aGR-1hXH;
	Mon, 08 Sep 2025 15:11:09 +0200
Message-ID: <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com
Cc: andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	dhowells@redhat.com, lukas@wunner.de,
 ignat@cloudflare.com, 	herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org
Date: Mon, 08 Sep 2025 15:11:08 +0200
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Queue-Id: 612FB40014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uixrjrtyffatgtyezjeddht9skj3x7ff
X-HE-Tag: 1757337085-38754
X-HE-Meta: U2FsdGVkX183hlygg+Fx6xvwiOzXhGOuJakWTzyLA55aRigfH/qt8Rm+8APYPuJa3eJ8xfigfRUaesq9x37HxyaspC3ylxonYq1Wr3JwM9GM+UUZu4drTxwbSpE6GUOGgRhTgbDXR2lZu8Z8LQHaZd7SMkYEjFaETbnv32lrm874G5VkkDeIudkMGUuw9zp6SkYEC/gaEyMclOqUvRRKM6wCR/jnMBxWcBoiKUjtsREvvNSkRZ2jPK6tzXybVaU8hrwqs3AqpazIFMhjBpw5eHQyiTnNnSDS+46mVBhBR9pU+lL/qsWWhZ2H4r3LZvZQ5F+UT4CmdnxgDmtc8mU1s2sujaSp6M0WsQ00cfbCuvwdhHw48bC2xzd3tDyZAtm7KPKvSXEO23LCaJ+4GB/hrlO4hpDVK+7OlginVnP+eTjcpuB+jjpYLQloP/26u+2JL6MI5ydNW2yUQXTUBC9EhBU2Rs6XKRo+7+soibX+BIMCLw0OQPYuuVQ82TfjlFNiNf5xjvg5ysVC2arQoPV+1Cb7y4qk9QSCFXh3NKcnOZ1t8nw3PnSIEJas9Om17ZUgBkPLFGASCKtpvy2JWZVkwXcOCIaltZOCYBEnXL1Ei/4fE2a7vXyfLiFGbURg8iJckMrOtZZ5+nop9ffhmNov4IMJ60clwvh23ElUoSgN2piMDtrzIJ36sRVN8dfXmtPpa08jVDtW2J3VX+RT2PR9WyIqKwd4jQRwXBM/aR5gR6ahzVUPyqRDuc+HwRoCnAwMo9jBW4rMmA15qcK4qtvrfEZIjqqZysnpUkzmdAbmkdBq64O9Vezgqt5amaGetMSJT+skpwB81aFboAr/KaSL4LCbxQT2gsnoA/KS5Ggun0buVeSLPSZYQnbIUqKDRirIFsEdaOl4X03zKGq0/KB4MS8xl/1hCRciq8P0Cmucbj6Va8voulj5mw5ydUn+owb77OJ2G9B3Pgvle+AOwXM
 zCRlsx4O
 iAT21MyGmB4bJv6eTwKLcX4FtlJw3CdBaZVn9+vcwmiie3RhGzPoxWJELt0k1kFDgT6a15SFxy13E2XHzwo66jz3EgVW8Y8qdqaamOyf6AkVCX/e/Dve3PvtyPWU6e0Dwvphcig1P0z14pvRX8S4pWyjcMPL4ihHp8SaxS1fR81aSFhI/afdz3K7jxczB5ehadiKS+ovj7fKWp/EYOvdaAS9YpvRKOhaQRB6uNYuGkr8cEGq1GFyMIxn5vs3kpx6OeuK016WYVSGX9Py+aZ4JoYbmIcoitJo4TgI+tP0lI9ZmUgfBtXTdgVvm8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

Since I'm looking at some WiFi fuzzing just now ...

> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters)

Could you clarify what you mean by "relatively" here? It seems to me
that if you let this fuzz say something like
cfg80211_inform_bss_frame_data(), which parses a frame and registers it
in the global scan list, you might quickly run into the 1000 limit of
the list, etc. since these functions are not stateless. OTOH, it's
obviously possible to just receive a lot of such frames over the air
even, or over simulated air like in syzbot today already.

> This RFC continues to seek feedback on the overall design of KFuzzTest
> and the minor changes made in V2. We are particularly interested in
> comments on:
> - The ergonomics of the API for defining fuzz targets.
> - The overall workflow and usability for a developer adding and running
>   a new in-kernel fuzz target.
> - The high-level architecture.

As far as the architecture is concerned, I'm reading this is built
around syzkaller (like) architecture, in that the fuzzer lives in the
fuzzed kernel's userspace, right?

> We would like to thank David Gow for his detailed feedback regarding the
> potential integration with KUnit. The v1 discussion highlighted three
> potential paths: making KFuzzTests a special case of KUnit tests, sharing
> implementation details in a common library, or keeping the frameworks
> separate while ensuring API familiarity.
>=20
> Following a productive conversation with David, we are moving forward
> with the third option for now. While tighter integration is an
> attractive long-term goal, we believe the most practical first step is
> to establish KFuzzTest as a valuable, standalone framework.

I have been wondering about this from another perspective - with kunit
often running in ARCH=3Dum, and there the kernel being "just" a userspace
process, we should be able to do a "classic" afl-style fork approach to
fuzzing. That way, state doesn't really (have to) matter at all. This is
of course both an advantage (reproducing any issue found is just the
right test with a single input) and disadvantage (the fuzzer won't
modify state first and then find an issue on a later round.)

I was just looking at what external state (such as the physical memory
mapped) UML has and that would need to be disentangled, and it's not
_that_ much if we can have specific configurations, and maybe mostly
shut down the userspace that's running inside UML (and/or have kunit
execute before init/pid 1 when builtin.)

Did you consider such a model at all, and have specific reasons for not
going in this direction, or simply didn't consider because you're coming
from the syzkaller side anyway?

johannes

