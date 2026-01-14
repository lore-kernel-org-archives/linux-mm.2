Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07908D29FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624DA6B00AE; Wed, 14 Jan 2026 07:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8516B00B0; Wed, 14 Jan 2026 07:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB636B00B1; Wed, 14 Jan 2026 07:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 396306B00AE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:37:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4A911604B3
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:37:40 +0000 (UTC)
X-FDA: 84330520680.29.9B24A6B
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1DB0340007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:37:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="dM/LOjMq";
	dmarc=pass (policy=none) header.from=sipsolutions.net;
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768394259; a=rsa-sha256;
	cv=none;
	b=o24Eszc54Szq+scG/zqVrf0n3Xm6r7+Gk4/FCx6sqeTbdHxyya9zUCWdPx/XuXvLC9L37w
	p6pj/LJfDD5v9/QoRO9zTcUgdM2dP4R2ec07uUv4TcP7xKLhjf6+FCBHq1FBE5ZbYoEuJ7
	qCG4NAc2ErAHDQXJj0kPa/7746Jmywg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="dM/LOjMq";
	dmarc=pass (policy=none) header.from=sipsolutions.net;
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768394259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivImLx0IMwWptsei2EtrkPEC8sK7x+WsxIR0q4hvYGs=;
	b=0Dhhd8I8n6SFblAPAbojn5SmyYKJ0gAZkTZnU+9/f+IXrDw9G1cx1vaf34xpNZl1KeDvz1
	/f+1DT+KGP5IOv+U6HUZbtXoeB2YAObSN8dD/vGw+PwnScFhMYx7LRMbl8z2cqexjYMM22
	Iw+Ax37B40WYYd3BwDDW6TkCTKJZyK4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ivImLx0IMwWptsei2EtrkPEC8sK7x+WsxIR0q4hvYGs=;
	t=1768394259; x=1769603859; b=dM/LOjMqjZ2tIU+MNlUFNOcasrhF7B6TMJHgQ3DVNjFsNNW
	YuBwfEHZwvIKo7H/Uc9ugcxDvKZ5pbdd/nO2lsnCpC2k71ZSWZkF26pAadU7GgPd3gLVavgrvvs8+
	net9yhKjTAV6bdKac263lMxtbp+K18AoAKKw8HHwCLDgsUoonu1upy68C14cN5NZFkRY4UGa5XpfL
	yJOxfCGELaGVqogoyLgT2QmsMra7mvzUtoRXsLGAHQxTtcvW9zZ5IVWXpgulRmWekuv14/RCoFsM4
	/1IrOimLkMNZYSDsDMDStzu96I3j6TCz5Uwwf/Lb4S8gu3sArWhav3gCQuKGTW6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vg07s-0000000Be2H-0lg3;
	Wed, 14 Jan 2026 13:37:28 +0100
Message-ID: <27c35b1f39c4cfaaf3b8322bbeb793c268fe4b6e.camel@sipsolutions.net>
Subject: Re: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy@kernel.org, 
	andy.shevchenko@gmail.com, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com,
 dvyukov@google.com, 	ebiggers@kernel.org, elver@google.com,
 gregkh@linuxfoundation.org, 	herbert@gondor.apana.org.au,
 ignat@cloudflare.com, jack@suse.cz, jannh@google.com, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, 	lukas@wunner.de, mcgrof@kernel.org, shuah@kernel.org,
 sj@kernel.org, 	skhan@linuxfoundation.org, tarasmadan@google.com,
 wentaoz5@illinois.edu, 	raemoar63@gmail.com
Date: Wed, 14 Jan 2026 13:37:26 +0100
In-Reply-To: <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com> (sfid-20260114_132852_914833_479AECE9)
References: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
	 <CANgxf6yGDGAD9VCqZyqJ8__dqHOk-ywfSdhXL5qATfxnT-QGFA@mail.gmail.com>
	 (sfid-20260114_132852_914833_479AECE9)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DB0340007
X-Stat-Signature: g4tmgxuxr3fwwdbftenxsp541rpnahgp
X-Rspam-User: 
X-HE-Tag: 1768394258-857452
X-HE-Meta: U2FsdGVkX1/AG8X9GPoZWb7XSMywUFNUwt+sOVLSDtiU/jMx0Ahd1wQpgJ37oR3qM2OOAmLwvVe5crQk0LgZehrlX/aTMnRNa2sxTwshYJm/8yEIOAza6gXWjvPjuXlubrtwh5IVNNY+T4i9JWDbK7uB4OgUOMc42xw4TcfWr7sKrtJYFXzhoQLInGT8FigaINAglzVNmrtNK3yPhlQ6huRuQJXMcxYd9uT8btB4Ur6tpN08Zcqn0DKABVPN4Jja3HWrSQ4Fqc/Uuf1CjieDPaShfyc/CQuNlSDxIf1UObs0bS5BFRZrNddVkyiHGhpVYUHwHNj9iaijaFsYgrND89CSp0oZRI5jSpiV8PQsSrE3GsMCj9o6nQV2ha4HAUNrAlYCuEufXEF49VQCX2iSG2ATwh6S+cTIkRv9q51jhf7vluN11I69/3As1p6lVJDcojmgevJoKr7o36AbQLpB8h2VFp7MTX4PVv4gP3dprCwj3kfRBJp+1mL+E/zLaOTc+S4smRH/uZSMPdwmhAwc5Up0/5ewMIUZ1oSU+/xmyRa0rOFCF4+Eowqd3+5EmieeKN9BJ7Mue6y6dLAaTLz/GuXg/LRH+cxTYcXs3EIqdBWR8Dr4OLbDEvZzcvKbyI4D5qY4dXZjXYzg8/Wx/SLYArGHZBgN7VfZQPAgMg3SOmz8MB8jj9SKG+8PzCQLW/ATfom4fJm93vPvKTVjHT3WanPQthVn95UVb5CaBWD332ePgtq+fhhJSj2WnxRxRnyMrZuEHrh4xNld6rAkG32V4JmVI3UO20L9OcHsOaI/DLg8D/24j4AgRui8ELUgFKJrEvft2+KQKNiRPB2GjjRNz/kvRWUz4SmMmijJXAmP6S/gQhFBkN2jDcWkvSjM5LuRrAiolGZcjp9eALxlVpFsL11nFLVYwU4Oa+meEhfR/QvpnSmYE4QotdfuswNnY3FGs9xvguYyUN6dcUXawE6
 1POl7ejB
 CIWumb7+hSpZ8fGZFVumU9LheuwRai7eFv53UN6Dt8JmBol5w9lq2yg//zV3M+hf2/lbPZAQAdzUCrUrBrwFbirQMRs/lYTGxFSoXc+eKO5d+YR4X4eNgIhvZA6NGAlGGZQ0mcyeWqvSFq3bfWA9bDFJJRvJ6979b1rCt2gUVwUw0bO9bFqxi4igG19mxDZnkR22nYGJiwukuvnjeu4isYD6f+YVEQloPMVAu6DF8q5Hut934Q6rQLPpW/g5FMKRWxa/jPiZWgKx0Gk9Tn5p6JB8Sxxg0d+xvDDUnRtFqghGb+HPnizoxvDVyNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

> I wanted to check if this v4 aligns with your previous feedback regarding
> the tight coupling with userspace tools.
>=20
> The custom serialization has been removed entirely along with the bridge
> tool. This series now focuses exclusively on passing raw binary inputs
> via debugfs with the FUZZ_TEST_SIMPLE macro.
>=20
> The decoupling eliminates any dependency on syzkaller and should help
> remove some of the blockers that you previously encountered when
> considering integration with other fuzzing engines.
>=20
> Does this simplified design look closer to what you need?

Thanks for reaching out!

We're doing some changes here and I also need to focus on some WiFi
features, so I don't really know when (if?) I'll continue working on
this, but yes, this definitely aligns much better with what I had in
mind.

FWIW, maybe for new people on the thread, last time I was considering
building ARCH=3Dum in a way that it would run into a (selectable) fuzz
test, fork, and then feed it fuzzer input coming from honggfuzz [1]. I'm
handwaving a bit [2], but this would basically bypass userspace
completely and let us fuzz any of the tests in the kernel with "reset"
for each fuzzing round.

[1] selected because it's compatible with what the kernel does now with
kcov for coverage feedback, afl++ currently cannot deal with this for
some reason

[2] because I hadn't quite figured out how to make UML a single thread
only and get rid of the userspace running inside of it


Regardless, definitely yes, I think the design is much simpler and even
if I don't end up integrating honggfuzz this specific way, I do believe
it will make it much simpler (and more performant) to integrate with
other fuzzers.

johannes

