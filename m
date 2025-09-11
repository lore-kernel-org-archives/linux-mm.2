Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDB7CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 14:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6C58E0009; Thu, 11 Sep 2025 10:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296C78E0001; Thu, 11 Sep 2025 10:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4348E0009; Thu, 11 Sep 2025 10:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B54F8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:00:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEF1F1DE8F0
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:00:02 +0000 (UTC)
X-FDA: 83877128244.24.B9674FA
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE41440004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:00:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=RgtBcMQp;
	spf=pass (imf17.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757599201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZpIIGiAzp9dlmnlhXDwO9rr0Iyle3/GOpYyQPgYY/c=;
	b=eWVj0SPhumuRMY7wG03WqflWNTPeveU+Mm0mc1mtaAhoxIfkMu0yE6fR0Al8Ae+fPNa+Oj
	2GISzmJjibHlHtak+kseoJRYTKNjJa4K7gCZZOYXsKG5ESCDBmmLiPoNj7zetzv4cez20v
	VFnDnYDq/YTnnIv9S9uBsS7vrqtw0fY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=RgtBcMQp;
	spf=pass (imf17.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757599201; a=rsa-sha256;
	cv=none;
	b=klPiAbaRDVPbx6FJxGMKWBQT5vM2tiHH/A4QzBhRqpEO6BmI9MlBBjaBBc88krLZgiHI9S
	II2tbns01vPglLGx2sqSM6WTZiSgE15N7FUJzEqDbJkscGDGa7sU8D7aRHnW9cUTDYYpeC
	yBOQahA0kE8rjbcvczzNoGCATnK4itM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1ZpIIGiAzp9dlmnlhXDwO9rr0Iyle3/GOpYyQPgYY/c=;
	t=1757599200; x=1758808800; b=RgtBcMQpdRYu7kSyUPSDU4fmmz5v/B/v59TcWLo41lSWDFj
	FfcWWE8L9TVJD07kCQczX3AWKHcjgCSwaQilQsoDaYlP34mTh1MhrHbQIxDrIcb2aWJKyZT3sH6da
	uRUruvfYdfCHtBCxVeI1dzr6WRaa+qtFoyz/wACRiFZ3mEDdNb09JI5x6KqMMAZ8IxsVo/XoBAJAK
	pdlkswGLd+kr8WHDpglpioT/fKR297+DUOgNB+MdUj9uWOQwDCjeLOAZAesINPRhZLr6/QQIGuLNE
	4KG01HdnL2hjnHMA3ttlGq9OhniWcI0Pp+IAPxuwDPHCv1IPdVRxrzwf+nf1bj/A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1uwhq3-0000000FP2l-2ojG;
	Thu, 11 Sep 2025 15:59:51 +0200
Message-ID: <cf3eef898266e5a8064c6cc5d2c12a9b0971f75c.camel@sipsolutions.net>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Potapenko <glider@google.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	dhowells@redhat.com, lukas@wunner.de,
 ignat@cloudflare.com, 	herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org
Date: Thu, 11 Sep 2025 15:59:50 +0200
In-Reply-To: <6eda1208c08130e00cb54e557bc4858ce10a4a94.camel@sipsolutions.net>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
		 <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
		 <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com>
		 (sfid-20250910_124126_320471_24812999) <6eda1208c08130e00cb54e557bc4858ce10a4a94.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DE41440004
X-Stat-Signature: jq4ny8695pa83f8byy8kmztyzrzyowio
X-HE-Tag: 1757599200-206099
X-HE-Meta: U2FsdGVkX1/TRSnhnHgYrDRs06rIxEn0Y8MrN+2TIfmMDLIvBHejW7WKgTzOwUhYCLBmJKdQUNF/EkM24Br+JJrXhPJ7CHTHSPF01LO6Vg7YCrTy+kv6jX9tmCwRmbOKYHDjntswmYjztsTl2LULhlv3m0MR2+a9kxH+Z3VEIIgl+zOHA8RXQHgP1QlqqIbrtbJ1ZpPos5LMpkKo9HYKrYnX0uvU7cbWc5g8z5bkPaFYkoiYiqqJvXHmlHBOlASlmVLQ1Sw59qSpv9LfKyLemN+Fs2rtYh6JlFV6CG3YcbfgK9IeB3kRE9HA4mWNKYYc51I4szBBtFWMcviTajoVAXCrFvVRzQ22eY8ArtZ70uJdw41s33GUue5TtrwhYXKNaIATP+vglxOKnQC8GU3frmcTdwKmB/mIoDxfeFojFZmmQAGJm5AIFHhR8VrsnrZs/fV5gkzp2JWV1vuPWnM8giW5v8RYSx9dRR0EYMup8+lkkv6SiFFVzdpJKshu8kNkM9ZSq9GSnRHTDKbygY1mbmxtrPBw07QIT887/g2Xs8JfCF8HOu86HFeGrwymFDkHOYoeyYkd3QhsceQPY4yxw7cyt/14DxyPi6Qbe2oivw+ngOU/MJuAlTEuAqEkOnVrEib53PKkD8WjDFjJi5a3UnEw22e9DhZ+extFKSL3Z8mQQD+Ke10/9PyxmKumc/pb3Yrz4F/1ZboruJZoLiJ224DX+JlAfU0kMyPo9T+w5GSF/FkQ+YNMG18YrfZwy0PTxgdDO+YG6FONLOH2KBsHpGlYsXD0qvl84EMGTj+Kd9QbZdWmYrRlFkRxjYvsiyEu7ItGOcZr1fxom/Qr6lNBw51RQMf/Sp/YSjIbBGMbaW4G0OHeN5Ul1vtZgC8DMA/vUhngahLyuST5S24tdqUQn3rav8uMaVRj58tQ4gtED+rE86+dTzVYhT9uHOzJuzj77vqz+dDWo6NCg6UrJH+
 kPT6qsls
 8HmXs3j0DF9tdwa42RWTnG1vN+mvwoXcP07pT8Lcd0qEiBACZolFm07N1Uzuzoe+UYF1hWqmsGau10NkijBBYwv7TmWlRxl4NDaya/2+4SAUTMGVt8NMv18yS0KhoD6dEzjwo0HTcLJ5PMKe7TCa1oZ/YkFBbHK/2mJDzotvCMWJ9swv77mg5NB5MlCwbpJgjbhJ3WEsoXPoiWJGy4VFfRYOcesQ1oGw/oleQA18yac/i4YGpf7c60nL6qbkQ2dn+N7KDM0lai1TT13PxX8GVuCy0qjHBhXPRD0fU8T1jfBWwuw6PeGr13vAF08DISkfj18ysi2/n2BPaFY+LDSwr+rRQeC3IpdemlgwhMmTN9ZXAzLVa15C2vrPV5R8vMropUdgtBgN443P/hF8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi again :-)

So I've been spending another day on this, looking at kafl/nyx as
promised, and thinking about afl++ integration.

> I've been looking also at broader fuzzing tools such as nyx-fuzz and
> related kafl [1] which are cool in theory (and are intended to address
> your "cannot fork VMs quickly enough" issue), but ... while running a
> modified host kernel etc. is sufficient for research, it's practically
> impossible for deploying things since you have to stay on top of
> security etc.
>=20
> [1] https://intellabs.github.io/kAFL/tutorials/linux/fuzzing_linux_kernel=
.html
>=20
> That said, it seems to me that upstream kvm code actually has Intel-PT
> support and also dirty page logging (presumably for VM migration), so
> I'm not entirely sure what the nyx/kafl host kernel actually really
> adds. But I have yet to research this in detail, I've now asked some
> folks at Intel who work(ed) on it.

It's actually a bit more nuanced - it can work without Intel-PT using
instrumentation for feedback and using the upstream kvm PML APIs, but
then it requires the "vmware backdoor" enabled.

Also, the qemu they have is based on version 4.2, according to the bug
tracker there were two failed attempts at forward-porting it.


> Which I'm not arguing is bad, quite the opposite, but I'm also close to
> just giving up on the whole UML thing precisely _because_ of it, since
> there's no way anyone can compete with Google's deployment, and adding
> somewhat competing infrastructure to the kernel will just complicate
> matters. Which is maybe unfortunate, because a fork/fuzz model often
> seems more usable in practice, and in particular can also be used more
> easily for regression tests.

Or maybe not given the state of the kafl/nyx world... :)

I also just spent a bunch of time looking at integrating afl++ with kcov
and it seems ... tricky? There seem to be assumptions on the data format
in afl++, but the kcov data format is entirely different, both for block
and compare tracking. I think it could be made to work most easily by
first supporting -fsanitize-coverage=3Dtrace-pc-guard in kcov (which is
clang only at this point), and adding a new KCOV_TRACE_ mode for it, one
that indexes by guard pointer and assigns incrementing numbers to those
like afl does, or so?

I'd think it'd be useful to also be able to run afl++ on the kfuzztests
proposed here by forwarding the kcov data. For this though, it seems it
might also be useful to actually wait for remote kcov to finish? Yeah
there's still the whole state issue, but at least (remote) kcov will
only trace code that's actually relevant to the injected data. This
would be with afl running as a normal userspace process against the
kfuzztest of the kernel it's running in, but with some additional setup
it'd also be possible to apply it to UML with forking to avoid state
issues.

(And yes, kcov seems to work fine on UML.)

I guess I'll go play with this some unless someone sees total show-
stoppers.

johannes

