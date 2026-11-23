Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5065860A260E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IG/CW4cv
Received: by kanga.kvack.org (Postfix)
	id 618F86B05B3; Mon, 23 Nov 2026 08:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFBE6B05B7; Mon, 23 Nov 2026 08:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1C06B05B8; Mon, 23 Nov 2026 08:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE6C6B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:25:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4C97C08C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:25:51 +0000 (UTC)
X-FDA: 85466456502.20.5634DA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1620B20008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:25:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IG/CW4cv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795440350;
	b=E7d6L73fMUHdxYkXLpYodsBIGcZQxKTDxtgDDqD9mVm24VRM0M32tf7MZ/TFtuf0vgto/I
	hvXbDvTCXl6xZUP6s4EOfJFcEtqoCaDVjmsY2jf1ZxYjo2NRLLgpjAP9XWO1+wKhkFNtvx
	i4U5AO42bI5vEumrypReMqTra1oUlQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795440350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+AcgEGNVf8XGbfJ61gaQU4lgyQ1Y5lkSyO2e7jckEI=;
	b=EDBpa4VnvcrqVweSNaZfh/ZOaxJuo3BgCpLKYiDXX2Mk2soTVGpy6h7rTXnr2QtQfTl9V1
	nGTzSKacv7K5BHo1wlS1z3jhCvUHOYAgjbVdD7GHKyGuTu8Trow5ijUxbdugzEpmT+GXjI
	mbUPgjV++RxXM7EpR22bqWsqRDFaruk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IG/CW4cv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 253A662169;
	Mon, 23 Nov 2026 13:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2272D1F00A3D;
	Mon, 23 Nov 2026 13:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795440348;
	bh=C+AcgEGNVf8XGbfJ61gaQU4lgyQ1Y5lkSyO2e7jckEI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IG/CW4cvGp7/2EHOxmS095yYCn3GkihksF+fkHnCoFwx6rbFuVB66JTeqhPXWQyku
	 zaFFso/3daE8Z53QdIhOFp0amXkx7o/6ekzhmYy5YcEh2Ll3QkH8fkiF3fAmDIYMFq
	 qnSTGKqAaLSspfKaAzMYc5/lnGsoQdIpujd+J58VCB85TDcGwvBMgf42xRTukHTejE
	 fdDWUpyNGnUlyoG4I8BBzO+MltP0IbtJWRgAPVF0vE2l4egwT7mfFigjz5Nts0kXXW
	 0J3zLJo0uIGtZUyLJLxsRWXxespCl3VF1hxfl4Q7HLsAN10wSwuEnnHwGIFO/Pwkbh
	 r298B2xOxSF+w==
Date: Mon, 23 Nov 2026 15:25:45 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awQ-2UtDRtrv9fNu@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
 <awOUJCbB_j0BuHvo@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOUJCbB_j0BuHvo@kernel.org>
X-Stat-Signature: bfsuzbxrec18wza534ik8k6sxof3d7sn
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1620B20008
X-HE-Tag: 1795440349-620513
X-HE-Meta: U2FsdGVkX190gZW3Uq4d5CGeYCPyEIcyrPQQ3OTKjJ1jycGFlhqG568NqIiH1dUCMmXulDvKb3sRxfzeCM+i5ZvuggFomNXUaelO0A1R6wCzehs2ShGzaYzN5EZkPz1UPvkItxhBielcSQjp2GHxhYSxO8iYt+H4WJGTYIHKuwInZoOO4F3cu0nTypwu7PTjcV6kiREKPpaZAuKKZ4R0kP3XN+A2+oS7OJmHSy5+mo77qdB2IS2n2vlRnjmePzCtohyLkN4cuPlhvKyjGuFywbZ8WoHURKa50Cy0L/4mXynLtTwezzgTZ02OmMqLijxC2f0ZtXPfLPVEtSoF7VlAMLob7EMC5fsI4TnTgJtJjoDfXHXLjVOqtMvgPKtF60QfFKnFq57wzXQFu6LMrQq3ua2vsqgLA18hluc+ykd74+LbhvEVoU5V1Qt1J7zmE0SuxRAM/o1vETpsAaETZZ5GuLUjXYnmKNjXRSh8sy0UmqZMNbRxwOaugB6aXvOSkYmOVM+U+Nf+1gjdQinKUnP1V0iSvaXe6Xid8u2y0jXG7UIkD/GtDx3B2AWQwIVQEm32s2mFXI3Z6hk3EDcl1TDHwhrqbuTBhbQ7Vh9k5hf7XdC0JKoRq7/XQTR1Zc1hRK3AbUgV7EozfDnn3rW7LBE4cqeO1nwojzxd4fJ2EzLilprYXM4x/7ZbHULJjgveTzKM0Wo0x7+cWUV3256THFMaW7fguKOSXL+dPtI2eYN++EqvcydLVfAbdvRnmehWgodOlRgMk3I95U1LwTIRDW+vbaZ46YAWVTUEW4Y6tEmgq15A6ALCjL5rUFGA5anJBvF+hTKaCZWeNUUmxiwB6oagH7TCsisFOCmLaApOXVRUMqZ29mmeGRP+DA/dgG5G40PePEurZQT9/tgrFtQ+BAdm+qNkzbK04XqN/xHNtBPX3+2hi32N+shJYeGYWOdYOEtg06jTxUtmUTBkkMXuMYz
 /clGgrpg
 a1ZVXKpAp6q+hmt8tP0s4PKtZoRh3BHEUx/g0Y7cc9FLJ2assLaw72xRSpOooCV6KcOCNmPhD79PEs+UtAXPqtrQasIymB2eg3jU6bc1ROXC5NIalEToIrupqodgtHUzDOv0OYrmOTZeckkxiF6d4S5Dt0oZqIbhc4F2u7fP8T+abrrFj1uJPNXAElEGc324XgZetwMnMWqHxvPndfk5VTfGg2OCFqnUcZTBaACpJ/sOiBUY5k2L02jW92iBwPwXrrL5n9y981tjJHIO68U06NdRLnsMOR3eb0BJHPHgkD7/TC/yibn7FZMkFwdW2895JItCHMgv/+E1S3FYSEN2Qeddku+lSheqFvT5z6CMh2xcx5cQkSBfqXiGjf0OUk4BI3ir0PwQ/aJfJVn65mII7IPXJIwVFLWpa8z+uOFP0LqJyM7lbtQk/Cy9RIfpDAs/6KQbkO9UUmbr/jeb41QM/1gPiBlwjsBIYXHlNwyM7Gu2sLYN1l34rqeSvC/CnGS/EQx78tYzY/soZqKs9x+u4/yptB18vNOogWNfm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 03:17:28AM +0200, Jarkko Sakkinen wrote:
> > > The way you're spamming people you're only reducing chances of anything going in.
> > 
> > I personally think that "getting in" should not be a goal in the first
> > place. I care more about that whaever gets in has a high bar of
> > quality enough. It can be something different than this but
> > when I read the LWN article about Cells I was alarmed enough
> > so that I had to do this and prove my point.
> 
> For completeness: I'll consider this final RFC.

Random throws that would not be this but something else (but could be
derived from this basis):

1. It is possible to use file a instead of syscall for container
   creation. This allows to split the framework in two pieces:
   the core piece and the driver piece.
2. It would be possible to create Linux Container Module framework i.e.
   LCMs. I'm underlining the technical side here, not sure if this makes
   sense or not.

Both alt's can be quantatively proven given the existence of this patch
set.

Kernel LOC growth when kselftest is taken into account:

1. v1: 1211 LOC
2. v7: 2149 LOC

It's not exceptional growth, as for a compact implementation like this
that easily comes up from e.g., LSM hooks that were later included.

Further the number of patches has only grown because I wanted to more
accurately slice everything up until they are exactly in logical chunks.

For later issues, I've fixed those that are known ATM to but hold on for
sending any further patch set versions:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

I also think that v7 made most of sense for the reason because  I
realized that the cover letter would better have enumrated all syscall
extensions in addition to new syscalls. It was the primary season
for v7.

If this was skijumping, I would get worse style points, and will
improve on that for sure, but as a feature this does fly further
distance.

Br, Jarkko

