Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F04CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953C98E012D; Thu, 18 Sep 2025 15:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B508E00F6; Thu, 18 Sep 2025 15:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840C68E012D; Thu, 18 Sep 2025 15:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 719A98E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:40:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DC8D58E1A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:40:41 +0000 (UTC)
X-FDA: 83903388282.27.9D53B02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 411B24000A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:40:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qkCy5zq7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758224439; a=rsa-sha256;
	cv=none;
	b=lnpgYh6w4x5pvsijcPyAMe7f5HLb+CPsyyh4uetjT4rRPz7OpC0Dw7NocfNZNDAdHwG5eZ
	/2/S0sl50NTd6iaTYoPjtdWFGyAJG15WbDFx7Vnk/vuqSesWH5Q5dIYSw5JLPAtx1gPCTq
	P108XDQWmZICVETz5n+1cgxQSi0jPrQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qkCy5zq7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758224439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vIbbwP7GCvPvb7hRRchVESVHm5MRSjl/DOR9gQmNqY=;
	b=QhESltu+e6cIr4+qU+1NzXVEGq1ovhSyGIKtDJS75mB+zryuHr/uP+WtJfdHoERJy4DuHD
	SBcT7Edq1a22t6jhX7Mz37Qcm+gLCprhZ9sHQM3QhPh0pn2NaXSlIjk7V+xjfgEWXfoRmt
	kz7theSbyLQF+KOIRZ8PsUbvD0b8dy4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF1BA434D3;
	Thu, 18 Sep 2025 19:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B1EC4CEE7;
	Thu, 18 Sep 2025 19:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758224437;
	bh=GNLoPVl1DXIVax+PtnoEsKdKDKFCQNOtCNXTfw8iceU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qkCy5zq7k3oMe16JYv7VlKExpwS7wxKXd0JYnRIUtDgj+7Qq0qsQIOWdm7toXWBkq
	 qWWWYrzR7UIQvF/lWUpmPC5P6Z+qdxmxw6iACC2LtXqrvCN6/wzeGRmUaVeOjUIaZ3
	 yWB1FmongptVZ5uIN7XzmR8KxxYJfFw7/U7sxSI0m0WbpLrULrfnpoXInLZICfv6Lg
	 7oR6vK4+RXkPaAxuIzgVcI5Ri0YEBtO16rHrjo5xw4sIIKOkKSjdV/eB2iU+F3IG08
	 diobdjjvcUaEalg7hsOHEtkzvOVwCl6Ry1mVN+hHXasJm0gzOGBVCYfyrlvSoDS1mY
	 QDh3hVnEuH0TA==
Date: Thu, 18 Sep 2025 12:40:26 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Marco Elver <elver@google.com>, Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Will Deacon <will@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>,
	Bill Wendling <morbo@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ian Rogers <irogers@google.com>, Jann Horn <jannh@google.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Triplett <josh@joshtriplett.org>,
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Gleixner <tglx@linutronix.de>, Thomas Graf <tgraf@suug.ch>,
	Uladzislau Rezki <urezki@gmail.com>,
	Waiman Long <longman@redhat.com>, kasan-dev@googlegroups.com,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	linux-sparse@vger.kernel.org, llvm@lists.linux.dev,
	rcu@vger.kernel.org
Subject: Re: [PATCH v3 00/35] Compiler-Based Capability- and Locking-Analysis
Message-ID: <20250918194026.GA3379805@ax162>
References: <20250918140451.1289454-1-elver@google.com>
 <20250918141511.GA30263@lst.de>
 <20250918174555.GA3366400@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918174555.GA3366400@ax162>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 411B24000A
X-Stat-Signature: 7s4aseuka9xz1s4qjaub4fm4za5gg6dy
X-Rspam-User: 
X-HE-Tag: 1758224439-283328
X-HE-Meta: U2FsdGVkX18ynr7VbH8ufnsDFSw8Not2XhYRJ6mLo6FhjTitYyamzm4F5iyZGFDeQg3ofGocJxY7gRFQRV9AAK4QEXHHJmD9tQH8OYQYIkt/W/w29HnZOriVXvAH3YoQPAPIWeCHPaYup+4puxBUp3jhA4O4hD2nJ65fl4CUD7p/86RHyXA425UEAgAUAEj73YQ0BJD4kjCTkaGk2sQ1VKg1uPDrrp/lbxGzrb2MBQo8vGRCrHFKRZfvyuR8S+sn4LLwnGIwXCGhy7aoqR9qhkDXUzSNyN5qrc79y9yOSP9uozgSbJeQ3qUCVoPKvlvikpRPNZVoYOgg6Dly5XsSik5MwVDr3sUqqgdZsz47TdpZaMNENtqZTW0L+r/at/lFH8RUp/Ej6Wtpz/rvobFGDFJRRtnh26T+rrr1WdRwW6M+Bz85ILCK18qiXK2F3nwgmP0kd9l7gFjr1XOL/T0oR9DcYpgOg4RA1SQdyHnx4lH9IEpRMl214JlkrXpaWgXdtzIeKZOYdn7nRsB5Jr5tI+PHRamYIIE2XQq3FQceu4XmLEDZzX3+Rjye22d9bgI8eLxwab3j3+rfXAMn7D5qGd1/UKNkLu2gg2OOm+K07R7Yf+Es4GvXxNckO9RDi76krqJUxmM909uDAnOCRgYO3eBDdnJnjOuEj4FXZhn0ZczJskeJlvKdLZLumgmmMX+ziZvC67xX42tqyfuwSeflv9eAkefFDjkhRyh2cweZIyS3PigWBwzxPi0JFqhwbTISMa9VcX455Ig97whU8XS1eoHNNzutjsEv67VfRy+PjBSAkCezpbF2YaUMT54Hv4xSBRXbY3PwzNkRV9wryuPeHjzdagJxjTNG2oH4yTWB/nn5xgaCWXIStBiBSA2ShxKPmkFgdF/oAlT5EYCv6PWwJ2ml+YucTHtRBxDVY9HJ4v/4JAEgey8x2R1uM+io1BOzY57JgYxx4/Yh8sMmLej
 N+iHrII4
 wCAV5pXSjJ51lD4ZlVpHAQPYUYXxXCGVpO9TaYOuwyqjpAnFGa7YgdFxIFhTR0YGHa/4eJbUpXDOjoqh+3cpVt/uzZsf5+idF4WOMHxDrzYL7+gLzuwibmsTXSrzdws0plMeYAPPabSM0bYruFKG06oy2OHNJV92+HBrFTmN72d76joiwxH7IQzAMl/udiMTKM/YJj6r3aQz58kT/8i4wOKnrdkDR6LbPowFnswdsh3J7WsUMxNGnYlfh4tAyuEA7Xq3o54kLk2PdY3rxNWwpCRYyby+G0Fo5WoUAKCy5/7BkbYetKWKQ2v6YPeZ/RRK1KVEoSbeON5dkv2SpILOlcIA3XgQn5SzPvIgaXrzDW87DL2lTkQ7t1Bx3fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 10:45:55AM -0700, Nathan Chancellor wrote:
> On Thu, Sep 18, 2025 at 04:15:11PM +0200, Christoph Hellwig wrote:
> > On Thu, Sep 18, 2025 at 03:59:11PM +0200, Marco Elver wrote:
> > > A Clang version that supports `-Wthread-safety-pointer` and the new
> > > alias-analysis of capability pointers is required (from this version
> > > onwards):
> > > 
> > > 	https://github.com/llvm/llvm-project/commit/b4c98fcbe1504841203e610c351a3227f36c92a4 [3]
> > 
> > There's no chance to make say x86 pre-built binaries for that available?
> 
> I can use my existing kernel.org LLVM [1] build infrastructure to
> generate prebuilt x86 binaries. Just give me a bit to build and upload
> them. You may not be the only developer or maintainer who may want to
> play with this.

This should include Marco's change, let me know if there are any issues.

https://kernel.org/pub/tools/llvm/files/prerelease/llvm-22.0.0-e19fa930ca838715028c00c234874d1db4f93154-20250918-184558-x86_64.tar.xz

Cheers,
Nathan

