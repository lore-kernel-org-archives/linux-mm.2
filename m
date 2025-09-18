Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E990CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 20:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 603A48E00B7; Thu, 18 Sep 2025 16:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9BA8E0068; Thu, 18 Sep 2025 16:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5164D8E00B7; Thu, 18 Sep 2025 16:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 405A78E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 16:37:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D560EB98CF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:37:07 +0000 (UTC)
X-FDA: 83903530494.18.33B83E1
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F6271C000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:37:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758227826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v7xpfX6fEkkbnStkewG7QbtECvAPIycp6/D6Q3kleRs=;
	b=ezPkBGwT9PlMYni22UxWK4kQVw1FelQGFrQf582hROvHZTXfOthdOi4lIHYJuoCP+Svsya
	jPzA688XIRM3JJ6PHcsGAtcMMhjeur82Uo/T0jrodsVuW3eyU199sR0xltq07WqLO/5M6k
	KdMj2KoUOSb6P2BZtWNdg8UkiTfkg/0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758227826; a=rsa-sha256;
	cv=none;
	b=3L5Fs/nG8LZkZBQwCj57hxGlsm4Y+rBsxjsKAssLkrmhfQjoC2rFHuRcofIFxk/1EI0hQf
	FV4/k1bGSjinrkELiFRiOBanVPgpakfciJ0kHF418XpEjqqy/TkzOjZtL3RYCRR6CGwPco
	GIedBHzbbR4+VJdf/4H5w5Zz7vY2kwM=
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E6D31604ED;
	Thu, 18 Sep 2025 20:37:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id 9D9BE6000D;
	Thu, 18 Sep 2025 20:36:44 +0000 (UTC)
Message-ID: <13389786a2a121c21a6f4940b4acf09fad53a3d9.camel@perches.com>
Subject: Re: [PATCH v3 05/35] checkpatch: Warn about capability_unsafe()
 without comment
From: Joe Perches <joe@perches.com>
To: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will
 Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck	
 <luc.vanoostenryck@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Alexander Potapenko	 <glider@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Bart Van Assche	 <bvanassche@acm.org>, Bill Wendling <morbo@google.com>,
 Christoph Hellwig	 <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric
 Dumazet	 <edumazet@google.com>, Frederic Weisbecker <frederic@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Herbert Xu
 <herbert@gondor.apana.org.au>, Ian Rogers	 <irogers@google.com>, Jann Horn
 <jannh@google.com>, Joel Fernandes	 <joelagnelf@nvidia.com>, Jonathan
 Corbet <corbet@lwn.net>, Josh Triplett	 <josh@joshtriplett.org>, Justin
 Stitt <justinstitt@google.com>, Kees Cook	 <kees@kernel.org>, Kentaro
 Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn	 <lukas.bulwahn@gmail.com>,
 Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, Nathan
 Chancellor	 <nathan@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Tetsuo Handa	 <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner
 <tglx@linutronix.de>,  Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki
 <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Date: Thu, 18 Sep 2025 13:36:43 -0700
In-Reply-To: <20250918140451.1289454-6-elver@google.com>
References: <20250918140451.1289454-1-elver@google.com>
	 <20250918140451.1289454-6-elver@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+Psz6mclmN7I07c5jPtb/CcemQyIEeoMA=
X-HE-Meta: U2FsdGVkX1+3ZResTrAAf9g9L6dJTCgmeXzyM4kYyOanBXCbxLPKLUzexU279fp4Uk1s32nIlGL7ALFntG4iQsakleJTeVRQim4oreS1teDe2c1v+Yr3chddZziKPoDc++AISXJQPhyq2w3G+YXN9VlSwrMnsmWf2JBDP+6EKscCwfkdUqEPS2c1jIOhGC9JFL5oLKZVp7yaxDYTVOVvcxJD81BMXbf5A4qGtQvLNkMWZnMoJtyHKmlojlv7i6K2T4g5I4c9AZ5UYsKsHO+RYQ2ZU++uSS7Q3j7El4OW8jbzA/Y7Pj1Sh8vbE9tWV5T5
X-HE-Tag-Orig: 1758227804-881299
X-Rspamd-Queue-Id: 0F6271C000B
X-Rspamd-Server: rspam05
X-Stat-Signature: m8cxfoou1sm4m3rwj4bzm383ue3uocbg
X-Rspam-User: 
X-HE-Tag: 1758227825-335802
X-HE-Meta: U2FsdGVkX18XtFdSuT+ozyXsk2HhzCDXMnu1h5Eh6YBGHOek3asuskYjLj255Cf6e2bUKoWRi22iHfw0N+AtJ4D/oPkyqVjWMLjUprQYbzrt6frJ5+akBkDNl/e5rwteBYqgUjJn9JbyTxcKtnnViY2go+InNrpGCONbOV4F63U0rgWiJBiQqC7hRm5vjIh519LuF3rfU3YI9WvulghBxF+XYT/g6h5VTGO2qKLWe0EtPr+z6Ayc4H5ER9ArGp70lC4G/ddMHTOo1xTFE46YqUEUS2gJGQNEhYJk2VghqJCg5kpUGW37KoZe8CqwDFAE0stCeX6CYCDv7cG1QGKGNrE9kox6Y2ZC9KT4XbYm23wVtvJJC3/3pWk9u80a1XRI8xVfXzYmU7xo8V++mEo0GN7aOyvHYRERc+8QSfEIg7H/jM94tTkQ66I+5vZ0CtKq/ZvF2QGYehML5PeHtvG+SDiEIeujt8uOgpsKipxjNDac1PMNGPIPwuKopoB7sJAge0XQ6Y5RqrfQ23MPsYq/nfVhKDaQGW8c2UkYSJwCe/mRF/N4QyOnt3frfyxn8juDOC9LhP0GWB9SjyweWxUbwcRMKVjACI6rOwL5mKXiFUT1rBYGHVmpypetRWHtqauFf/VW7TG0VDRh9FD4hvG4sf//dnqRJOXhe+juU7jMfgz3WeSP/EF1r2IF2pkwTIfTtCj0Lb5sd1eJS7JnT2kUiIh0B0OYDOg4n5ug4snKSuXiMq68pDZVosGw5wh4cGFf+J8lyeBZ8wQFoHZpgzGeo3kTBkCmkQBQuM9SWDH3vBx/y4vNaBFpdltbd9zYD4fMxpypzxKLNcqPzEPnjd5TXFq/xJHao3te/sRAcA+KapjEzLRkjpaUbwFMdij/IkAvCZK6REOtN2EqGWiFnQdyeR+IYmQMciyxGYvz8BaosEgUMgDy0vtWcZWQ/BlI1fDgxoeIj/ouyIznfk+HEuN
 tEUu0piV
 1yDBtOW9/AhbFAQsp4QSp6TtBY9ALVRrsmvIv24rstat3s2y1OGxkG2VV1lTmxknlgZ2xUQbKqHtxfywOjyfDejeaW+uSNI1R18aE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-09-18 at 15:59 +0200, Marco Elver wrote:
> Warn about applications of capability_unsafe() without a comment, to
> encourage documenting the reasoning behind why it was deemed safe.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -6717,6 +6717,14 @@ sub process {
>  			}
>  		}
> =20
> +# check for capability_unsafe without a comment.
> +		if ($line =3D~ /\bcapability_unsafe\b/) {
> +			if (!ctx_has_comment($first_line, $linenr)) {
> +				WARN("CAPABILITY_UNSAFE",
> +				     "capability_unsafe without comment\n" . $herecurr);

while most of these are using the same multi-line style
I'd prefer combining and reducing indentation

		if ($line =3D~ /\bcapability_unsafe\b/ &&
		    !ctx_has_comment($first_line, $linenr)) {
			WARN(etc...

