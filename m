Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BD4E83837
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67676B0089; Mon, 16 Feb 2026 16:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3856B008A; Mon, 16 Feb 2026 16:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5C46B008C; Mon, 16 Feb 2026 16:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4AA6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:44:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 416AE1A0F6B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:44:12 +0000 (UTC)
X-FDA: 84451648344.25.6A86DAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9C99B120009
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:44:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wb1aDObO;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771278250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DlPMKKjiLj9yl5VsXusoKiLd9Ewnw+32pLa8zO0dG+U=;
	b=m39x4vfhmngVByuOmL8L5eyGiUemAquCg4tPUiF/0RDUyYkwkgt/MO9+s+d/LDnEeHT7AE
	HX0AXDGnlZR7cPBeqGVhxsGBxIqUilDyLGSd6Kt/Fx0hMRaNDe6SUmgIb1Vd4q0jLUYwdz
	bliEBQ1j89q5m/BmSD4vgU2FWOQBWfo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wb1aDObO;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771278250; a=rsa-sha256;
	cv=none;
	b=4BFUBUD04izHvI9fqIMPfOfwsWSbzHXRpGkgjCxUeg2cLIZqt9e2MPGE872K7HjcVgdsLJ
	pPFdW2IUYnaEngdro+mwvTmsojAkNI5TrwA7ViiCaPv9al6Ptik+z54ZVmqOL4LbqMTZ3J
	/k+tGbHrp0lSo+VczNU3rT8glXjISSA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0973360008;
	Mon, 16 Feb 2026 21:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82656C116C6;
	Mon, 16 Feb 2026 21:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771278249;
	bh=VAzTqo4vbXr8m49U0BBWa9rngxeDz0Euqj4DoptU4AI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wb1aDObOR6kZtDVklaYqXKOyTC68B6P70UEyjS6i9y3eIK3GQ7aMVowE0aDVZ3SoV
	 PUhkBB1jy46mv6fOpH1GEsu/8F3Ejs0RerUQYnScDkpyIF8tO5Byj2rTTgVyXt+paO
	 zbDz1VRsZ07ajfOkozUx1EDnfLEH7+Z7drW7vJo8=
Date: Mon, 16 Feb 2026 13:44:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport
 <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] liveupdate: luo_file: remember retrieve() status
Message-Id: <20260216134408.12dc6f88f7139054f9e34637@linux-foundation.org>
In-Reply-To: <20260216132221.987987-1-pratyush@kernel.org>
References: <20260216132221.987987-1-pratyush@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C99B120009
X-Stat-Signature: ccpeu6irbogpkycpb63acsqcrfneefyi
X-Rspam-User: 
X-HE-Tag: 1771278250-932050
X-HE-Meta: U2FsdGVkX19KYNjUUHFB9GElyVOLxLHPTZJhR8uv+B0rp797fPAT6D4Ua4Guwrov1kAZxuBTSnSMtR15rGC4Rrn0ik5Lvm8PznIJPfqyrgl/RMvQ9w/TF3bXuByMW/xyoQug5g39YM1LRxU8fuduLhH+kgXzbJMzLiLrWuzxAITSYEgcHcPz86cZCwxOvPuvNfha/jRpX+x0mWeg9KpVOHMEjXVn3oudgUY4lXFEkszpVrGwZJNKJuQHTIxCFimeNp767ZGQU2Tr5YrZk0YHpbukfe86Mc7rM+N1hdJRJ8PhFGbWHg8jnMPW+NbySYrv9B5tzwiS8oWNjKRH44UnZHnYCimCfgxxYk+9UuPr5h41mrrgBWsyqQTzmMn7XO12Pxabt/lwTeBWmov8qRfYhF4zDSplBiJUuxxyJwmrudjtQoWPTYLxkRx/Cy7HRiUhR0KR3H7KhnWRA1pEtKieugEd+rSC5cYmClpH+mSDpEqX/l6Keohxl3JFmPl0cX+hEMT+eZ4YWtF8D25S69tqhw4xpTJ5r3i0wXJvZBgPlb63Q5171EbhUAjRvkLkeQkudCRwwkRW4Nk1knfFkmOo+YJQMsQPx+PcAo+2dJpgwJhk7Ryz1XF9iJ/bsMHPWZAE0gFwTewKHbjD6S54GasT8Jc6gl82a5KebZEvW2vZqs2y/fLWbPCWqIR2sVkfRRezKtBsmtiUTsAbf5wtXxXzZzeierUNxDrBgF+PJyPmf0Rvmrgsuj6XFwRux7CIH3YkjQoku75yfThRVhqNEvMQttaJR0ZWcZlGmuk45e2fFaQS22GYhyf5i32bPBS9cmJy7s0KAO10FjRv5VF0S8l393fhoUnFJRoHsliAK8vmHMK2Bm3/zZpCjBr/5mj7UaCqSBouHnhU0eovEphzeW+axl4WlfYC4OSat2Jx4+OarbeZN2DUmzoC6nnI3PeLtG056LOsRFVHo34AIgzcdUk
 XpcZeenq
 VZvsXF/As1wSntJU+wkCwc+tKXWxsXue/u9w4yQAI9hSHgWUE+NLDpuzPeL58KgU/jU4Dl5Eafplp5NDMdEC31j0b2QN11/2FyaQeWCocEE+Xml8T5cfgF5o1e0GsSAFwJBkt7r2x1kfdRbUIsUAcenRkUY/f+KyaBjiWKeTWpARb55pfREP5LIIHwIzldhDyBX0k9D2Iv6V6aYBfi71pY4R7WDUV5QaAQ1RCUyHKyL/rYFZWHIuNMJpghJoZjGdkLBhOljNvTYg6sPfI7wPd4I0tv5j/wl9N8l1UntOzeYH3RSufqdQxdZHTpm2aMdsrx2rb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026 14:22:19 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> LUO keeps track of successful retrieve attempts on a LUO file. It does
> so to avoid multiple retrievals of the same file. Multiple retrievals
> cause problems because once the file is retrieved, the serialized data
> structures are likely freed and the file is likely in a very different
> state from what the code expects.
> 
> The retrieve boolean in struct luo_file keeps track of this, and is
> passed to the finish callback so it knows what work was already done and
> what it has left to do.
> 
> All this works well when retrieve succeeds. When it fails,
> luo_retrieve_file() returns the error immediately, without ever storing
> anywhere that a retrieve was attempted or what its error code was. This
> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
> but nothing prevents it from trying this again.
> 
> The retry is problematic for much of the same reasons listed above. The
> file is likely in a very different state than what the retrieve logic
> normally expects, and it might even have freed some serialization data
> structures. Attempting to access them or free them again is going to
> break things.
> 
> For example, if memfd managed to restore 8 of its 10 folios, but fails
> on the 9th, a subsequent retrieve attempt will try to call
> kho_restore_folio() on the first folio again, and that will fail with a
> warning since it is an invalid operation.
> 
> Apart from the retry, finish() also breaks. Since on failure the
> retrieved bool in luo_file is never touched, the finish() call on
> session close will tell the file handler that retrieve was never
> attempted, and it will try to access or free the data structures that
> might not exist, much in the same way as the retry attempt.
> 
> There is no sane way of attempting the retrieve again. Remember the
> error retrieve returned and directly return it on a retry. Also pass
> this status code to finish() so it can make the right decision on the
> work it needs to do.
> 
> This is done by changing the bool to an integer. A value of 0 means
> retrieve was never attempted, a positive value means it succeeded, and a
> negative value means it failed and the error code is the value.
> 
> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")

Should we backport this into 6.19.1?



