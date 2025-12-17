Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103A4D65530
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 10:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A34B6B0005; Wed, 17 Dec 2025 05:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151DD6B0089; Wed, 17 Dec 2025 05:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FD56B008A; Wed, 17 Dec 2025 05:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49A06B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:31:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81E87136DCD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:31:43 +0000 (UTC)
X-FDA: 84228596886.21.CA5BCE2
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id C10A340004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:31:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=nNVdNyWF;
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765967501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1d43wiHNx7VZeptPxlkNjgMo8OMak4wV1yoG3x6lk8=;
	b=pZIxwUR3yk1lqi3678kEMgJR6Ygg8htyjLb9j+YoSS9YvavmBXhdac6ZAotMEeqkA3yiM8
	wgVPynjWytM00uKJLtkKTBsVu7QSEyv66fCRH0BKhIOlS7WTG6GaTEPW/2aPaJffXysE7e
	URDxnzhs4Q8eeb88aPlraujnIEzxCZU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=nNVdNyWF;
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765967501; a=rsa-sha256;
	cv=none;
	b=G2PMcO8fEK9jw5BIwqO8jQT8VZUJ85ocERbcGph+uvwJqQJUp7u8zosRcLQdaLLbUKxJc2
	v1i/UTKnPB2DFApLd1OlO6tRZuS8EKCqbuo238BNwE2mj6BNWEvN0eKgCnjBqOSPIytsiP
	u3QrkjAiNW5sbPwJUYTXO88eVLqtpuk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=b1d43wiHNx7VZeptPxlkNjgMo8OMak4wV1yoG3x6lk8=;
	t=1765967501; x=1767177101; b=nNVdNyWFr9ZeJ5vi9MVKeznVBz0ORb/fgQdk9pmqu3RXxou
	LEb2AAckGHt9eUZ2V6aNl2zM4pF7T+kWbLV2mLvp3gVCGFzfEmCHaFTYs7qtGoK0v5kQX78b6PYjp
	osZaRbdD3+L1Iov48Mmwh1y+cb7LIYaIhd2fjX9AiY1/OolBvp/b91tNStase3oXLQt+zTQ1+a3Gk
	O+C02dLUTH30bTF0jI2HyE0sXA40JkRN4K1iApZF97bcVZOpjywK9kt9ItyLbu+8a97HKy/ywQQCp
	nSSQafdCNZuvZp+6XdBeybUU2+yAcTwt7j3vMgBa7OTNNy1h0ZZqDCLjyuVJzp/w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vVooa-0000000BlwN-2EFt;
	Wed, 17 Dec 2025 11:31:29 +0100
Message-ID: <9adc2c51cb0b176006c362c26f2b1804a37b48d6.camel@sipsolutions.net>
Subject: Re: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Potapenko <glider@google.com>, David Gow <davidgow@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Ethan Graham	
 <ethan.w.s.graham@gmail.com>, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, dhowells@redhat.com, dvyukov@google.com,
 elver@google.com, 	herbert@gondor.apana.org.au, ignat@cloudflare.com,
 jack@suse.cz, jannh@google.com, 	kasan-dev@googlegroups.com,
 kees@kernel.org, kunit-dev@googlegroups.com, 	linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 	lukas@wunner.de,
 rmoar@google.com, shuah@kernel.org, sj@kernel.org, 	tarasmadan@google.com
Date: Wed, 17 Dec 2025 11:31:26 +0100
In-Reply-To: <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com> (sfid-20251217_111949_169881_DE704F52)
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
	 <cbc99cb2-4415-4757-8808-67bf7926fed4@linuxfoundation.org>
	 <CABVgOSkbV0idRzeMmsUEtDo=U5Tzqc116mt_=jqW-xsToec_wQ@mail.gmail.com>
	 <CAG_fn=WvdKZgmkqa09kwLLH3P_j6GFYzopeD-PZ-Qt0-1KUaGw@mail.gmail.com>
	 (sfid-20251217_111949_169881_DE704F52)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C10A340004
X-Stat-Signature: 8ws91jcwinhy1a33an75rfkc9ut1uucy
X-HE-Tag: 1765967501-171238
X-HE-Meta: U2FsdGVkX1/9EVIF+u933vPehwDlDb7m89suNuBQdXR3uptw8HaZxTiUoi7/Pz0SuJ50MLDR8gKQvEdPa/pm3xu39fBjycIEqaYCQNtZhy8U303SxvnTgXsghIpFYNLBohduX2heFO4zy9TZIrryuuG9FlzW6BZk/Z6KmWL+cVk1iWdHPzGJ6VWjdp0BNM2CEbUpL5IreOYU6B32dSesym5nw905F3Ke78uCHsENswwnrv92G2SPwwomChrqruXitS5vrSOlQFIUkhcWPQsvb3YMFlTmXni0m2IcWZK+0wpzLKNDwRoypFUek8nYhUWhQLwzhoo0weyaKZSKpcqyjZw0QPh+bkRR0GI5se1bH4y4hvOlBG7g/wR4AFTvfuyJSZrR+1dsPkPoj6pU+KCZ8D6GkcdAE/zsn2IkzVPIqDS0DBpkOClS6+Hx+W5d7Ig5K5jKRuHpk6Hyw3gOdwTdrUKt46pRJJYbnuuLWYkex0HtQb2jIu6yxQJCpAf6+6iH9hBzGxH/6rNW/MCjMAjivQJq+cyrsaXQSnytmug2fjZjr9/C34aAst8qdrW7uWLYOJPymI8iRX1ppoRJ+gv69fCofAraXI00KN1ofKXsT0x7T/6ivjq2hIZFdZbAapDCp/sbpsBChZxGS+WmlOAw7hXf5nOrP2aGMELG40lS90ZMKr4KuhnKU9uMJ/GlY2v5zGvZdS6AMXjxdqfWiuNfwSNeiPgTV7ZWZZNwCQmFBL8TsSFulUHhMGfjFe+6iXH7q3ysYIMwa+AsZCo6amYdlcKf7/iT63K80sfK+yijKgOslqCWBu/H82yiaQ2ZSJpSEA/1iIoEDKPE1Vli3R+jeKYOt3NzvIQT1V6grEvIJ7yg1XiUb2wObQHtidhGgel7Sr2fE1j0U8HodUx2KvW0WF68J2X9kiNl++nLqW4vPsQSII9E0Shkaodqf8nOPFIBLXthryo4gAHGd8JXTYZ
 o7TezINK
 4GVR1wZ1UV4BsMZUd0CHyHuLafy/szNtKs36DUfBepVFSut5aRqJFLkfJK/gbiVtNrNBBGIrpZDVYXFICNylLvFyO1lIHl4pLgD+XWV7hAzHrGOvkdcxbSPcEbs/4TJO0OwoT0wrqeJ2JIMaicYiK/AVqlscgLQlfdC8zOKrBJM3U2oHvtTSPoVMMYooQi+kh6meC6eiI/AXRqKNW9VYHbiBe8sSYT6TNyr4hUoS8OziTa5eGdklE41T5/kE7vX3dZgwdn5zD28MZM89b6FqlDpCgpqMKHjonvGf/E1M8jrPjDQpnAyirme30H5wx56AA6K3M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2025-12-17 at 11:19 +0100, Alexander Potapenko wrote:
> > >=20
> > > As discussed at LPC, the tight tie between one single external user-s=
pace
> > > tool isn't something I am in favor of. The reason being, if the users=
pace
> > > app disappears all this kernel code stays with no way to trigger.
> > >=20
> > > Ethan and I discussed at LPC and I asked Ethan to come up with a gene=
ric way
> > > to trigger the fuzz code that doesn't solely depend on a single users=
-space
> > > application.
> > >=20
> >=20
> > FWIW, the included kfuzztest-bridge utility works fine as a separate,
> > in-tree way of triggering the fuzz code. It's definitely not totally
> > standalone, but can be useful with some ad-hoc descriptions and piping
> > through /dev/urandom or similar. (Personally, I think it'd be a really
> > nice way of distributing reproducers.)
> >=20
> > The only thing really missing would be having the kfuzztest-bridge
> > interface descriptions available (or, ideally, autogenerated somehow).
> > Maybe a simple wrapper to run it in a loop as a super-basic
> > (non-guided) fuzzer, if you wanted to be fancy.
> >=20
> > -- David
>=20
> An alternative Ethan and I discussed was implementing only
> FUZZ_TEST_SIMPLE for the initial commit.
> It wouldn't even need the bridge tool, because the inputs are
> unstructured, and triggering them would involve running `head -c N
> /dev/urandom > /sys/kernel/debug/kfuzztest/TEST_NAME/input_simple`
> This won't let us pass complex data structures from the userspace, but
> we can revisit that when there's an actual demand for it.

I feel like we had all this discussion before and I failed to be taken
seriously ;-)

For the record: I'm all for simplifying this. I had [1] looked into
integrating this framework with say afl++ or honggfuzz (the latter is
simpler due to the way coverage feedback is done) *inside* ARCH=3Dum, but
this whole structured approach and lack of discoverability at runtime
(need to parse the debug data out of the kernel binary) basically throws
a wrench into it for (currently) nothing.

[1] other projects have taken precedence for now, unfortunately

And I do think it creates an effective dependency on syzkaller, running
via the bridge tool isn't something you can even do in such a context
since it's "userspace in the kernel" vs. "fuzzer integrated with the
(UML) kernel", you'd have to put the bridge tool into the kernel binary
somehow or so.

So to me, the bridge tool might be great for manual work (initial
development and reproducers) on a test, but I don't really see how it'd
be suitable for fuzzing runs. I expect it'd also be quite a speedbump,
and makes integrating coverage feedback harder too.

johannes

