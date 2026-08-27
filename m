Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30071C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:15:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDA96B0096; Thu, 27 Aug 2026 08:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2BC6B0098; Thu, 27 Aug 2026 08:15:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 412E56B0099; Thu, 27 Aug 2026 08:15:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26D966B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:15:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8A43A0404
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:15:16 +0000 (UTC)
X-FDA: 85146944232.15.D35E0BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 61038180011
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:15:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUzQMoxJ;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787832914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvXjJRXBUzQTXjIk2SBQORZUK73WXX7PK6h6g7xXJSg=;
	b=lJEVdi1g661HI+gZ9nbT5gwgB3zQp9/DLoQi4FLTXkfsjtrif3dS1WH3zCV3s19OdKpdW9
	02BbsQLk29QBQkcup/pxzMXM1jTFeREWunAtYdGPDA/r+LqgbwZ6SHM/mDCeCZf6DrP9tS
	Y3y+o7K2pRxyeFt49UJwEA5Onq5MIA0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787832914;
	b=kdFVu61uPm5Pbze4UshNxQOoLRW2CO6f7ZmcmG9bg6NIM0Yg9M4yn47L1OY5+gpgqm9OoZ
	rrru3gjsrfxniRzQI7Ac0X7Fp1eIMinHTi/K+tQb9dD7G9s2iHuxo4E1SSHosXvmRoamBN
	8jw/EsrzDUSR7aJJ7W6qiIZsCUPPZ1Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RUzQMoxJ;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 089FC600D3;
	Thu, 27 Aug 2026 12:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEDA1F000E9;
	Thu, 27 Aug 2026 12:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787832912;
	bh=OvXjJRXBUzQTXjIk2SBQORZUK73WXX7PK6h6g7xXJSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RUzQMoxJkpxyCoz0a2/sLQb1IVLhrCUgiaTIeCnSk4MWC9vT3OEIh8jCRWE4mCcgT
	 xnM9Bcwe4KEkZBsGphkk5RUH1kzegvjvo1HDSXewtMd9o6eTJylWendZlZM72Kg3DX
	 4lq0tFfubJiZtt92Hk/W4kd6dS+CbRK5DmhGbnrIy2uRedQmdeKPojrlkvu1GgdBYy
	 ttbhgX3KLVczbvuZX9rR/FcBg1vHg3gfmFuhD7xIyVeCtDUjX8BHEeq8Fyp08gepDK
	 X5DUVWEiG+hLMau2NQqaPgkN1vQvCKidO3SzXwSfQxTwpM1GJ++7IwnNfEgCrypvQi
	 7G8z+2aoh45yw==
Date: Thu, 27 Aug 2026 13:15:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, liam@infradead.org, rbm@suse.com,
	akpm@linux-foundation.org, luto@amacapital.net,
	brendan.jackman@linux.dev, david@kernel.org, liuhangbin@gmail.com,
	corbet@lwn.net, kees@kernel.org, mhocko@suse.com, rppt@kernel.org,
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org,
	wad@chromium.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org,
	geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v2 1/2] selftests: run tests on nommu architecture
Message-ID: <28939864-7a8a-4204-bf68-b53e77200f35@sirena.org.uk>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <20260825015945.141739-2-thehajime@gmail.com>
 <ao2aTD1ZGObPfp4T@gremlin>
 <m2zey8ufh0.wl-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mrf2Wb1b1zm1oMZI"
Content-Disposition: inline
In-Reply-To: <m2zey8ufh0.wl-thehajime@gmail.com>
X-Cookie: Alimony is the high cost of leaving.
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61038180011
X-Stat-Signature: ebq5okd4wacidwoqkgj3z9q8s1qnhjzf
X-HE-Tag: 1787832914-115828
X-HE-Meta: U2FsdGVkX18jn4S+Vh1l7FfLwXToRnicNYSUhZVMIR1zqT7KxSrRZq7CgusLEgC44cUIsRC/lIfDfp+jLp26puJmpFP04J8bBDuEkYGP3V4tIaaeV/Hco4WX8q/GP4fUY6Kl+7jgD7PSBzWkd4tCqYZFBpZHtfbaD959ouMMJZ6R8rGK0z6+nj6EL5g55Ri+x10yzGCJvB4RQorpYaxpvyFbjUa9dg3s60hCk0DYdkvf/HR3d9KkarkNqgHbhIvWp7LCR5Mt9N4q7UjO20W9DI+75Ec5+L4GAbkDa3o4U3GL509Le7Z7+O0U0beZ1ARho88UZZK4EHIDkBXhXI6GUmGITVJaRGgOGOGqK16tUed81L97NprNvLTIBjY7PKJEIx2AoHbG+EybIKLYFAckAtuT5ffQkvXQOHVI6lyRLXfa6Qc9ZsXax+7X4IdKTOUdsVKPAY9ty0Le+GsoNS/oAY3yxtDMYXBNPxBJOLvAzeSuOib2alhY37tCBhTYdmu8tXgCYErANrVte+hh04ATNPHBNAvkXnauNZD5TV8ZUZFH620k9eb+H7nSdgmBCZnPjYZYoEgaCutZ6Cqa0c2ZKV8mIUYJImIGjkfSfo3rBt5Q5UNtD52zvd1Zf5896CLiaAfoHI6KSwdCqejvkeM5W5nAawuNUNOC9s+Q3M2ckUNl3ntaKhCZItlrjYi3ZnC4zYm8Wl2m2SIomLM+a/h42LBJFJPXl5TaTSEVzCD8FDv+3GzWV/em7r/qkiq9V3Bw1Qkrh0qvCC1yhHiLpvZToOcjago3mWvOQWxp5/TRu4pB86iZ211tIOSj/Tmtezv+stIUsqhIP3zQDfnQdGNkrLJGeD1wyWqsuoU8/LzFfRVYrXERUdiGuvWWUlqtSUdZ/71YL00rHmdl0T0g5xEKB/oahHmb4t3ApVU7Li84r9DtKvKADkc5S5/RqGP6NTcCmXBBU6F+HqGPfhaeyKG
 3QXJF7lz
 RlBW+Bk0nAPG1EpIlTGvCzRQfXXnj3aHe3dwcEEQHHvtFOzI5kSf7L8DFK412hlH3Kr6I+r1OO/Q3sLjlHaF9VY94xajprG4cB4rIYwt1aMqrqLQXpX4NE/XZlu5r7Y+vxAIxwnxzW1PfCDFGluJGwqPtAY0vMsrGJ5/PtaqF3RRzmOBs3v0vTCQeTDcgf26WOoUZwQDGySLpoq/c2qis8o31bd/LflLQuQRIbzhAguH8z3xkgXnOsUZnLnt9SpRzzuk/A/3DfJ6v45lTO8GFpVVDO6pwNsJWblDovApiwtA9utahz7hzZFQQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--mrf2Wb1b1zm1oMZI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 27, 2026 at 05:36:59PM +0900, Hajime Tazaki wrote:
> Lorenzo Stoakes (ARM) wrote:

> > >  		esac
> > > -		cd - >/dev/null
> > > +		cd "$OLDDIR" >/dev/null

> > Hmm, why are you changing this bit?

> on nommu we cannot use /bin/bash (i.e., no fork(2) so, we use
> /bin/hash, a busybox-offered shell with vfork.
> with this `cd -` (standards specified) isn't implemented due to slim
> requirement of that shell (I suppose, miserable...).

> thus this workaround.

It'd probably be good to have this as a separate commit with a changelog
explaining what's going on, it'll make review easier if nothing else.

--mrf2Wb1b1zm1oMZI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqQKkgACgkQJNaLcl1U
h9BXfAf9HIKrY3R1ifWbdQiCchDNja2ZvlJvk7WjJkdSkjVHJpNUyYWBr7iNXldP
uqe6h3Lxz5A01ehepxZw9SUHN3KJ7lFEKu4+nL1Mad5Ilj/fxLocolyYhzyo7sff
9rNiCZgNo7MTu3Fo469kifhj4gTzmkOVFmruROcRqHnsfEkRFA5jl0QG3SgGP+43
vlVLBlc3hLG9gmxOvnC3D5a3U2WdKvn35p8ZFZGp2zGSH0sAqNda1cx6tKul6r+k
zjOxyuuOwW4JjgUoBbRTXgyUziM/UFEYpffTFZ2fVH6rtOeS6cwJaCoAJ8xR2N/8
VpL8PDYd1CYUFKaaQFzI+zEMB095gQ==
=Em/s
-----END PGP SIGNATURE-----

--mrf2Wb1b1zm1oMZI--

