Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1D9C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 23:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952619000E1; Wed, 13 Aug 2025 19:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901B9900088; Wed, 13 Aug 2025 19:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818609000E1; Wed, 13 Aug 2025 19:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD78900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 19:04:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1984914034E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:04:24 +0000 (UTC)
X-FDA: 83773264848.05.76F9CC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5D3218000F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:04:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gULORzCb;
	spf=pass (imf30.hostedemail.com: domain of "SRS0=/t6I=2Z=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=/t6I=2Z=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755126262;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRa+gBJ/oeD3McTOWaxYB6xLBV3+tBwG8IOqQRzKjCA=;
	b=o4/9aSm7L75iS5O3e44VjS6ya0d7c4M3R9aAHRl0WtjzQ1KzObN0eyh6eIU8Uf/giyBQSg
	1U9n82Rh2H+jjpbj6ppChcmAlhv9GSIBtuqAjISfFYFJ22g3KVO/BIeilo39kTPX90WbU8
	argf4Uukez1Py54/kvg2lkDgznUbyzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755126262; a=rsa-sha256;
	cv=none;
	b=Vc7kkV20R06DipbrvOt4hm/MzEWOaJ0n3EFHaxrIOLMrtvSc2l8W9j+3XnDyqIPl6kSX4x
	L3TA0A7iC24ME5C28F8i1cmFx/GHvzL5RsBq96E8FIWjw0UY6FMxntPhvDSVw5JKq6Jf9G
	crNRTqINdNxg7dcQXATety9OFU+tRhc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gULORzCb;
	spf=pass (imf30.hostedemail.com: domain of "SRS0=/t6I=2Z=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=/t6I=2Z=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A1CC36020E;
	Wed, 13 Aug 2025 23:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5ADC4CEF5;
	Wed, 13 Aug 2025 23:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755126261;
	bh=3F+ogyrYcJ8PY1I57KN+xxu49Rm1DOvKC0zBkVlpS24=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=gULORzCbX4t52dAfG5DuKvm4YIIqfvOAx2w15GEnWcGA3zPp1j7Cf5X0DN1XTUtdv
	 n74MCqWqzp5i6s8L31cAIYg53ELJQ/y78Ez/QPWAtAMqFKENy687JX6LZtwcI1YySK
	 X/4AixLfnG9jFoOCWc1ggn2g0Agkl+XXXBRlStfpOCy03YBcMGgEJ8P4X0dasp2onI
	 ySv+D7D4PiGjXg6hX02QoDFlpOVGN/82cxQhy2q1soLdwF2tgPFkX+o6RBjn5T4ADE
	 HhxlAxjwmBcpTl+gyAlfkbcB5xyfUjjHWZvzun5VoZ0syqCiu4T32eftEcAdCVhLqA
	 dt4p4tG6o1mzg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id D4BCCCE0A48; Wed, 13 Aug 2025 16:04:19 -0700 (PDT)
Date: Wed, 13 Aug 2025 16:04:19 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <f389ac0d-de77-4443-9302-3d8895e39daf@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
 <202508120250.Eooq2ydr-lkp@intel.com>
 <20250813051633.GA3895812@ax162>
 <aJwj4dQ3b599qKHn@codewreck.org>
 <aJyVfWKX2eSMsfrb@black.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJyVfWKX2eSMsfrb@black.igk.intel.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D3218000F
X-Stat-Signature: xwogcnyxyt5frcghjgoqdbfi7ah689h7
X-Rspam-User: 
X-HE-Tag: 1755126262-811920
X-HE-Meta: U2FsdGVkX1/Zcf5TmRW2dy87ZX/qWbE4h7Y2/OLuZO4OFAfYS0M6ihhDPVMs71oEFsXWhFgyVPtZba5tjLcsVsi+cslE99/GAP0iWuHJq32KDLLvfmsh/l2qaxfy+/7oszlNqj40gKOheaXgQxVHieAiganSqKXzijsvtWgBcjCz3KrINad1YLkmoeaiqYxtumKACg/O17po3yD5OYzW5FfDKOo6BTz2vzC5tcj7KQwDZKvUO+G0Pp5qNhqouq0dlIlLdClVhPWiRS3c5gVPCUciud3esjuaA1UqCCfNsKHjq6fHia3lVcwXEkppFDSMVFLC737hOVyxSy2S5beyFhZ1ob3EpvSsTMchmx0HZ8R+3r+3Subj8EfbkwViaUJNIzW8isZ5MorqEFy4N9RuOkDF5Wd+BiYZzjQ+vNFaRolRFAJ0D8mL/x6wUe4Qaq2aaXG7YCzKfUy/evJLDXdKMlpUWNc12IaK0NYWEPCgJvTRBtsFXyGTSEiIA/BkRX2KVjeSHsDo4jrC9bAd9EKZrnFlPfTS8oIeF5ossWYm39RS/+u4AZRPC9agYCYmnkmylNM9NlmS2KD39B0JIu7Eo8eMJa6gKvpuMPF54c1MW0dbsGPjV3img8kKv8s5JgROQ4/d1hGBWSV4jDBWJUVfwHTF0h24sbAP0v4I9UAR5wa5szqpLeLp6G2Ugx+73/gl9ZONbjU50qzHUEMS5ti/2w2uYBZ75cz9A5eCos1E+08uCw+bwmwCxOqdNFhYEJtzeYc3bqCeJf6NDHIXhpRzGCHh6zwlnrkUXhu2t7xRvX91E8ej16MNIzDdGY+hC9BMcoE/pspB7qc29+UfPZ3o7IX36dPUlwxIw03XxejbEhbMcD3E9C/pPsPHfHB1JIh7pUM0SU092qojx3jG9ZzOnXeVT6kxtGv/zGY2spLQUhrYa37ef/rAMDOWZtnNXJwPkl5I5U9ZdBdP1v4CAff
 w3UeT2OI
 wjAyesQ3ROo7hn/lX9bOdp8b3VYMVUnbFSzJnVR9ZGvcAPlPxwZ04e9xz+770qEv9LMz8ef4ndZu3DnoSSx4E6MEPuk9NxDMsQSV6NhY4QELiuzAFEa2vOGIiKttqCQRIbuISLLAlsz/KADbI65lptL9HBtVnQP8ufs1bQL8WC/wadezIrdhlIfnRd7ugVCil87/KvUkQjGqjmoowzTIdttrAddXR6MuHpkJs9I8TDkIv1lhptArpky2bZgYtXpY2Y9IzU7VI8MO90v8Ar7vaJ+ZDDmcCM+3ou1WfZyd7haA03oWNoSvMrch3s0wDk4BOEst+QLPklsJKOCelhghds8TuiJo/sSrgTwhxyzh3TszfH1Z6V520PT7VFncEzj8nY2KGEwEqFuAeauwtHK8V1OY6yf1UkwWLhcf239wSfUnVkZRQO5VJBWLe/ICTfBgb9snf1exyyOFSBvglHB/dABHg94fOPXqvZefue2h6Uv01nqg+S+f0dWTSoJw6BM4LqmzOQGuBXeuUw32Yw45NG+104zreL/9hj6lJ4FR8cTztn/FBwnkuVMdL49rs+khAE08B6RPLlm5FJrfGIGJaXt/8QGpDFqMDJeowpo2E8b17sWNHeovVBusC011UHsxpV4b5vYrRCm1K4UBjJe7pRon2kxZT1x9qo0uR/NpqoTAys7glHS8f4VYM/rRs6foLOsvH5z/QVOL8eK8YHruU0Y/Ycr/HpF27/PVN4EdLczX10pwbuQGAsEwpIOAwm2fcBxluNGBS7qL0b/0tUpJ9BuMrQm/5h74e4LQZQB6uKKE/x7Iqs+kRIKQpgn/+gWVVg/2ceV6LF9ywEuT/vrXuEL0kYo6Iip1FDOtX6UyLbf63Kyv078vjQn0YMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 03:39:09PM +0200, Andy Shevchenko wrote:
> On Wed, Aug 13, 2025 at 02:34:25PM +0900, Dominique Martinet wrote:
> > Nathan Chancellor wrote on Tue, Aug 12, 2025 at 10:16:33PM -0700:
> > > >    1 warning generated.
> > > 
> > > I see this in -next now, should remain be zero initialized or is there
> > > some other fix that is needed?
> > 
> > A zero-initialization is fine, I sent a v2 with zero-initialization
> > fixed yesterday:
> > https://lkml.kernel.org/r/20250812-iot_iter_folio-v2-1-f99423309478@codewreck.org
> > 
> > (and I'll send a v3 with the goto replaced with a bigger if later today
> > as per David's request)
> > 
> > I assume Andrew will pick it up eventually?
> 
> I hope this to happen sooner as it broke my builds too (I always do now `make W=1`
> and suggest all developers should follow).

This build failure is showing up in my testing as well.

In the service of preventing bisection issues, would it be possible to
fold the fix into the original patch?

							Thanx, Paul

