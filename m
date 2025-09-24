Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B83CAC5A7
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 08:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D9E48E0002; Wed, 24 Sep 2025 04:44:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B0A8E0001; Wed, 24 Sep 2025 04:44:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0718E0002; Wed, 24 Sep 2025 04:44:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21DFC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:44:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C58E65ACBE
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:44:40 +0000 (UTC)
X-FDA: 83923507920.21.702DEAC
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18022180010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:44:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="n/nEpjyN";
	spf=pass (imf24.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758703479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E6QK7pHBc6Tj/OKkybEC4KJUY708g6FvcrorHKD8Ws=;
	b=XNGN1FM980bVrP2CZ0cB+fouYEvXntJ2c8PI7ySiLmho0GsBdiDs/e1qm6BbYfz0eJS6V0
	l0UIGgpIsbMEu4Zw3kAuygO4dnb2YBmPXd5lCYwi/BQFFkshXruU5giBSuyjJ8TPjOdbr8
	6dlHXCKXBCsixSN5ID+9lI0hbmHvqL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758703479; a=rsa-sha256;
	cv=none;
	b=BU0ABzsTb0nJvifvwlqECdjT3qITZtHzYRwCNQwwF+gB62z+ZfwHPweWeWAuFRH00gXokS
	RrqPqHGGI2DQbWbjlKMHDG355bEcVNfaZRChFifY4xnOTgyguqrl2JXjLrkJyuRsBxOCqx
	SESX0jvuZg94H+d06JMo+DnR+RnHBQI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="n/nEpjyN";
	spf=pass (imf24.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7E6QK7pHBc6Tj/OKkybEC4KJUY708g6FvcrorHKD8Ws=;
	t=1758703479; x=1759913079; b=n/nEpjyNAmQPJvvj9sPD4cVSeMuuxACtKSqk5aQZYOgGsi1
	AhKMtt7xTHCSSFWpqJP8KbEOzhbx9iKxFJplDYE2Do++gDlJ8jlKcFPOSBsY9tc4CIiO/CEhJMDgN
	wK+gOvpta/FOvThh+ZsQYCsG6vxbrie280R/g5FZvSq7rsFQmvNXA4CHNPbPdhnUK8odzOO+MFLMm
	XXmoTjX7l+MYBBHoK5FDuCh1YsKsxe+IecscdU8lMRAP8qRFeiotq4fqssHPRCK0J5OmXN3OirBtY
	KfI+Jpl7aKZ3oiG2Qz0A6tjDvEM2YdL1B6cOCaJLvp1luZUjDq3Nys3CMlIBXSNg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1v1L6u-00000008TYW-2seR;
	Wed, 24 Sep 2025 10:44:25 +0200
Message-ID: <8d2ec79561f5aa17403014a298bb9188f904e489.camel@sipsolutions.net>
Subject: Re: [PATCH v2 02/10] kfuzztest: add user-facing API and data
 structures
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
Date: Wed, 24 Sep 2025 10:44:22 +0200
In-Reply-To: <20250919145750.3448393-3-ethan.w.s.graham@gmail.com> (sfid-20250919_165803_858771_D7FB8768)
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
	 <20250919145750.3448393-3-ethan.w.s.graham@gmail.com>
	 (sfid-20250919_165803_858771_D7FB8768)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 18022180010
X-Stat-Signature: iygquyhked5trrd4n1s61xnau7ccutoy
X-Rspam-User: 
X-HE-Tag: 1758703478-975331
X-HE-Meta: U2FsdGVkX19HK0+8TBKEWivDHjHRqrjHfwD9NWsWzOt6+JiBe/OXbTrGC9Bi8C/yzOcfl9tF59+jqx31X2flduFfn5weKgChRcFSIWM2aKRYlTy3PLlHlo4ucI4JYhac0xIVzaIm+5d8tsk6wA04EjihJ1AqEOWWczDAa+2BVDrcgPD+UBcFGyIYR9LPnW4Oh3ij31o8pDCKN5rq8yNIZxPpYeGo8TGcfjotRfv0kMDmrWiOrwAvLJJW5f4JJ7sefD2ej7adKOGsRGIhneuZB/EjnkUaX9NO7xa6p4CLFPgdg+Itpkatp5GVC1YY9TEsuilJKiceWCV3UfUWQD4MvMy2V4BBUkp8SRlLy+t5uUt4tHICV++eBysNP9Lb8LNb33255poyjbKlq9y20YNQQQ2lN8cMe3OUwaRQYqNHKGHSyDAaKbnHx1pcvv01IpuWJaLayLV/EeKMzju6CsV8HpwK9Kjlc10ELWIA0gpK9djAbxpVMRKT7Osl/r/3BbXDxJLtd4+rcelLsT0ZVQ4LIpfcZrLWOH2X2QDm4xJpc2stFrnqpMCvSXKVYs9GPFxG4IwkpMbiTVtPMvffAcPnGA/o9N0qJCPXcci0kxhqCS4Vg8p+9vjUzhDZ/lQMwKerBplPuCkopY3+stEs+IEkWenqGSO7Ro2EdlIG4WNDEDtSR6FAQXy4pQbJPiRImk3Oj7xRbIJMvedCo+xLWfUOstvxkH1LaHBT/0OkXIyh4XJGmUE2qNgzJQyXomVaEjGd3spSBcSKJ7oLZISh2QhEgKW95Y17XeW81bx9FKgvIUCItN2F7HLFHngjMxd4MveoYfaAcqLDiOqMefqVg9KYTRe9zVQEOHjrr/cgVCP4wm9/dH7+t0JnOpiUg8sxYXUWCXJSl8ll4kZHlG891Quwu8ywgc3SA9wd8H586Z1Rcgf2TUqnr1MxWj4n8zsSknRRwrpxrVp4SkdyRAh9H0T
 NTR7w2YK
 vCSpTDob3x8dxdv9Y7BjzdZCyINV5lLrU0O/kvBCNQRnFxJvSUDz7sduCBCYIlB89ECwEGD9xvr/uFZ7MIS+fJ2sgTbqYPubIQzpkqUZa2KCMJP17o+FNBi28SU5HeXgGkpOybQG1GzfxYHCRXJTkK4NM2qekZfpSVD9k3EgMAxeZm1rbm6gsmk0gRK8T0jx0UISLFZKp+WFbAROmkzLKsLXKK30HF4E15uOSDvQcmKviTTiD3DCJUGvveW9IWRqvzH6xuXEcdeRH0+/8hSmn21iXFqTbV/XlARWwb2WBAzNrm5v/+dJuC7aikA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2025-09-19 at 14:57 +0000, Ethan Graham wrote:
>=20
> + * User-Provided Logic:
> + * The developer must provide the body of the fuzz test logic within the=
 curly
> + * braces following the macro invocation. Within this scope, the framewo=
rk
> + * provides the `arg` variable, which is a pointer of type `@test_arg_ty=
pe *`=20

FWIW, git complained about trailing whitespace on this line.

I'm trying to apply this and integrate it with ARCH=3Dum and honggfuzz
(because afl++ doesn't work with -fsanitize-coverage=3Dtrace-pc and I have
issues with clang right now ...). Fingers crossed :)

johannes

