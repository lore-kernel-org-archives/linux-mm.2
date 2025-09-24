Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76ABFCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43788E0018; Wed, 24 Sep 2025 08:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AE98E0001; Wed, 24 Sep 2025 08:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57AE8E0018; Wed, 24 Sep 2025 08:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4D38E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:52:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B045C0519
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:52:45 +0000 (UTC)
X-FDA: 83924133090.13.0BD41E1
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0CF3100008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:52:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=AmaFo1FI;
	spf=pass (imf05.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758718363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h5K+P/riDmU7tvn3fIuQxPNsf4KltKjt2Yr02gW3kT0=;
	b=77YvMJusl+P3AeE7523bN34v+qCJHGtB2hUIFQyIr5Itc+CGCTirkGl4mj/pYACMm6WBjR
	ugkpdA+aLnWHqHWz6Os8jghJNYgytZHbv+8OyeDK5aj2uQ5+R/gOdf1DcWUwA9bvVtzk6f
	ne0TcCPI2dUZkdtmYxGid0+suk6vY+s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758718363; a=rsa-sha256;
	cv=none;
	b=AVKwqH4y/FHRP676AIVwmRo6M1Wp/qu5p0GJt2lrXY7/VrjmiuIQYPmHgLxrCDi6EIfSxe
	UkTT4oE6Au96lPowEnp8VP7kHotANiV3NFl7AzAG4Uj1/2Sj7Q/UAJFw4aWgz99icC7tE2
	oIegPGKQVaVgX6PYV4wo6Bo0aCLgdeA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=AmaFo1FI;
	spf=pass (imf05.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=h5K+P/riDmU7tvn3fIuQxPNsf4KltKjt2Yr02gW3kT0=;
	t=1758718363; x=1759927963; b=AmaFo1FIYGhDn8ysOJWdXbu4JDq0k3l44jZB7KYHhx/0gRQ
	JnZohNcZSnKzZxp647Uog7uL7ZRedaJ5CgvWhSrsAza12nQTb52sEgrZdXg+OJVF2GYKMYGwNkmkT
	pku4CmqWF/VFvBo8ZSoUSJsSHBdqn0YEB7ltDz0+Tjsi49G5EYMFwg7irHJOgAVtUkKJH1PlexCbi
	X3HXUb5O7VJBa7vI13jeBH2ETVxCGePLLhKQ6aaSg9CMSuIrNwBaatrPGJxCMvEH3j+bvgWL6IFwu
	PvL/Y/xhTRYBw63QylnrampQP9X4ufE8JaWqSUVK4yf2Mx0cfzZt36+NqaXuTNGQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1v1Oz3-00000008sim-1o1i;
	Wed, 24 Sep 2025 14:52:33 +0200
Message-ID: <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	glider@google.com
Cc: andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
 jannh@google.com, 	kasan-dev@googlegroups.com, kees@kernel.org,
 kunit-dev@googlegroups.com, 	linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 	lukas@wunner.de,
 rmoar@google.com, shuah@kernel.org, sj@kernel.org, 	tarasmadan@google.com
Date: Wed, 24 Sep 2025 14:52:32 +0200
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> (sfid-20250919_165801_647339_D5FEA55B)
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
	 (sfid-20250919_165801_647339_D5FEA55B)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Stat-Signature: amtigst9tbt1x9sscuytbjxx3hr7fxzx
X-Rspam-User: 
X-Rspamd-Queue-Id: B0CF3100008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758718363-2613
X-HE-Meta: U2FsdGVkX1+/LsdiICVS4Dqfkj6Tr/hX8od9wB+IgcfKNnuL1UkL1n/bAJetiXmyBfny/ADPqyQ2m+kh4dRtve9JhzdTVRLXv+q7mUb8N1Ri8VLaInstFiANmUWHLt2SJ8E7nGjgIrH9oOVVxF3B1wDqKUd31cUIG/BVR4q5btndgmnsj565fqKmE4MzWNbSb03WFqfJ7u0bn1UB+LjQEoyHtjYtyCD79YQzO63Ek+OGfMtJaKzA6RuOEwKmxxH+Vdc0uur7gtxVypoyN4ALN0P5uiq4DKCNxZKVC/fbESOqofrUhCaU7148KGn+Rt4VehhfP7mt+qBu3ZIDuFE4KPWkVA+F9po+rDGx8/fpcZmVbW9udYxcKW/t8tgbGHM5dGK8SUIOiHFLTalwjfr7h+EgpI/qNktIetFMH1uI7MnBuuhMYOCKlvpCiY3d11fIZHLKzfNg5uKAAcp5KwWbEECwuvihfr9HmM4vsu3M7QK88JGwfqRQz33od6P9EmYUFo87k3lhfGCTJ/sd5c5qeiJpnyssnvn2fmJbK3OcLNwUuMBEkttC9YXoVjXw3phKD+36UZxPZS8MN+tDzKD0PmjqCQVXP4o9bFl3T27G3/tlwpGRYxUmas1vk4JrnjDB43vFHwoaul6DpLahQruV0cutzjqsA8w3lYqohH//QKjczaUy5WMgdCZE5RcFfbdnePGkg9IbjG4/u2/rRcpas6Q7UV6nTn3/CLfNBekFgh+2SO8KM/uOtjHAP/yHUjaJN22jN6cLKBmaF/+daQMrYrACOKq1JhGt6jx95GVDuop/yKDeEse/1zTbI9hG/PWqf0UtOE4N0fRF3PB1/+PBKMkJgtlQrwfPgDQRg4j1j7a0iMfuL+lk2nMkoc0KDJGRDqsEh2F/blGKNHSb550GSDxVFALgYOGfNocWGX9l0hug5a7sjYC1Z+Qpentu1aWqvBKsGE5oxDnUBQvFbD5
 pZ+GLJBF
 K6xOw+a5xTh9Z/lE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
>=20
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.
>=20
> The primary motivation for KFuzzTest is to simplify the fuzzing of
> low-level, relatively stateless functions (e.g., data parsers, format
> converters) that are difficult to exercise effectively from the syscall
> boundary. It is intended for in-situ fuzzing of kernel code without
> requiring that it be built as a separate userspace library or that its
> dependencies be stubbed out. Using a simple macro-based API, developers
> can add a new fuzz target with minimal boilerplate code.

So ... I guess I understand the motivation to make this easy for
developers, but I'm not sure I'm happy to have all of this effectively
depend on syzkaller.

You spelled out the process to actually declare a fuzz test, but you
never spelled out the process to actually run fuzzing against it. For
the record, and everyone else who might be reading, here's my
understanding:

 - the FUZZ_TEST() macro declares some magic in the Linux binary,
   including the name of the struct that describes the necessary input

 - there's a parser in syzkaller (and not really usable standalone) that
   can parse the vmlinux binary (and doesn't handle modules) and
   generates descriptions for the input from it

 - I _think_ that the bridge tool uses these descriptions, though the
   example you have in the documentation just says "use this command for
   this test" and makes no representation as to how the first argument
   to the bridge tool is created, it just appears out of thin air

 - the bridge tool will then parse the description and use some random
   data to create the serialised data that's deserialized in the kernel
   and then passed to the test

   - side note: did that really have to be a custom serialization
     format? I don't see any discussion on that, there are different
     formats that exist already, I'd think?

 - the test runs now, and may or may not crash, as you'd expect


I was really hoping to integrate this with ARCH=3Dum and other fuzzers[1],
but ... I don't really think it's entirely feasible. I can basically
only require hard-coding the input description like the bridge tool
does, but that doesn't scale, or attempt to extract a few thousand lines
of code from syzkaller to extract the data...

[1] in particular honggfuzz as I wrote earlier, due to the coverage
    feedback format issues with afl++, but if I were able to use clang
    right now I could probably also make afl++ work in a similar way
    by adding support for --fsanitize-coverage=3Dtrace-pc-guard first.


I'm not even saying that you had many choices here, but it's definitely
annoying, at least to me, that all this infrastructure is effectively
dependent on syzkaller due to all of this. At the same time, yes, I get
that parsing dwarf and getting a description out is not an easy feat,
and without the infrastructure already in syzkaller it'd take more than
the ~1.1kLOC (and even that is not small) it has now.


I guess the biggest question to me is ultimately why all that is
necessary? Right now, there's only the single example kfuzztest that
even uses this infrastructure beyond a single linear buffer [2]. Where
is all that complexity even worth it? It's expressly intended for
simpler pieces of code that parse something ("data parsers, format
converters").

[2] admittedly the auxdisplay one is slightly different and uses a
    string, but that's pretty much equivalent

johannes

