Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC37DEE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BCE6B0088; Tue, 30 Dec 2025 15:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5066B0089; Tue, 30 Dec 2025 15:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E2986B008A; Tue, 30 Dec 2025 15:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F37116B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:33:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9270814033C
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:33:40 +0000 (UTC)
X-FDA: 84277288200.04.8CB4C21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B858D100010
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:33:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OuqShLmo;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767126819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lzGIbQTFq3w6gBYegWyny5ueK2uBEjjvlnaIEW9RxCo=;
	b=Qm/3Hk91EUlLBz1j0IV9Ds577bBT1PhipBzAvp9tL7B/muTIV1mmmz5MZESFsx0kvl39Dr
	0+UL1lCFkor+1AWbo1j30Tmg+Xgy81rJB6FR+zz3vit65gL8GAxpSYntBtpCbAkcWfBLCw
	vxR/CS0Oq1P74PWXPbCoQQ+nJ9jncrI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OuqShLmo;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767126819; a=rsa-sha256;
	cv=none;
	b=D3cWkfw5fRm9BlUd99dVVqmGAXUb8+sCjy+vuwlu3qh7+UJ8O+8GsKDrs2cWcGAZHPNh6o
	5SWWWYRCUPOnD1kKn2I6CQESdL4ZZA9Dd0uhIKNt0ZIOv9N8zOvtNyURiXchLl5sjf87Vu
	8n8Kl/YxQ+ZjoNxIFHqhvE7k5bsrsj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD307403E8;
	Tue, 30 Dec 2025 20:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB7DC4CEFB;
	Tue, 30 Dec 2025 20:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767126817;
	bh=0u26j7AJ8QC208/ooPb6KaynFf6cllwNRkgmFyhiWNs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OuqShLmozNBMQLJfxjfj+YIvid4oax7GDHVH3u6OGu9dHM0DP9tqjFIr37I5zf7zv
	 YZm3WkxVHtQUiHdRu0Cwsr/9vv7v2nU4IqfYNKee58vvFd3dHbiD0/vsZxkpO9FUT7
	 R/JfReGiWrojA2ZbG2aGvTM6M909Tpig0AtwRaQI=
Date: Tue, 30 Dec 2025 12:33:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Dipendra Khadka <kdipendra88@gmail.com>, David Rientjes
 <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in
 format string
Message-Id: <20251230123336.ef33f8a55df71f3e3f782532@linux-foundation.org>
In-Reply-To: <aVI7Zsr9S1WqKxz8@tiehlicka>
References: <20251228154456.2386-1-kdipendra88@gmail.com>
	<aVI7Zsr9S1WqKxz8@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: jfzctqf6p4w3xyt95xc71uf3z6n9e81a
X-Rspam-User: 
X-Rspamd-Queue-Id: B858D100010
X-HE-Tag: 1767126818-14384
X-HE-Meta: U2FsdGVkX1+MKBeGmceAzyXLvI0UKNm1CIU5mgYPGU3Nb3dhOj/5amH6E33sUoR0Z7z3Z2SeIEs8nYBt5GgU2iiatHDQgM4q22lfLR9TahZq1rvKE9vQxv6K3duLoRACcAegaCB3Aevz+niZKs8KgGy+Jx8+O6ZqeYF17V1pFkQliO9IJyUnn8k2/K4s23CLHOczqYHAIlAwTjBKv4tzVUfBk5H+YqGSruOWZcgUKmZPKW2VnMP7DCX/8EQnsMfZBrdZvGYYbStq/YZ6sbNVsP/4a4shX6sV66jtEtaDGgNR21fMa5mCjR3TkOTgk1Bv0L4xbm+pU8rttRb7xwFDyJI5FUDb//7Cp7YRcgrgKE9/8lmpZXaJ0utaVxYSwxiAe0GZSzBeKjVCLf5O5SqRl+RIqGE6uWomqTR5WvarWAEPRp5ArQ7jOt2JbkjG85ofEU6KwtFBIBsIfv8M9fdAHRzMKGOK/cwJTlkdYsfRMuyWCDnG/0pG+KBkcCZx9k5VxTlmYn3YrDo3TTT2N5MyopnE5GY0zgmWCWGEjHGuXzmKPukXLqI+XDKlajLt776vDf8w1TvP9KoG2Vx91Y4bjRV1CJvzphfIuerD8xud+SPrGgy1ric1HTdB39EezH1UuDj6RGoXWmc7szhr8MynwcX/hIOtBW+qU3AIz4H7mu+2FkdaYf/s1qn1QXNzuUIeEQjURM3xnFKjT/gjWvj+IUAGPplmWP6+pefZ1oQFoV/zAyNYpfjNbR1G9f/9IwAFGmGCiGdvCC2LrhG9r86RBaHUBRa0cxyaazoMbW5S4qQvcgtPUwyg1kvKCgR0QRwxwzSJ+w5wOclAWNHBFIvGCkP08AI4xvdxtW6/g4rl6BUv7jwtCg0ueHNRPgWpkzzMZfXBfV8z1pmgUAEpPTOnfoiwAqLYekfRXtdgGwMCQ5i/GL/TGaZ8T08AiRdGCO0fijGac7Ib6Fwo11ZFznA
 Rtx7r8UX
 EfAp+5WmaBIbP1JOrZigmCCt3xJKNoRYPQipSYKpNDGy/JQN7pflieFPbCLJEwNETxfxM9lICamXefTYkac4Q7pbc3jPs3kLuf6nLQNf3RlWDbfH0F3K9n2m1Xc/C6tnYFZAnE7wM/OXSUJNpVdJ2XeUKNkes7+uH27qd4mVkRPxzrZvuu0uMKuOQjbifhiKCK1h1bwUO6lfiOEckUqs05rnzVZnsAtBua12LcEj15B2yUcqrnuTfGuNf3QY/DFeEcI/es7cC7l6dhFdMXbneLz26apsc1baTDbmNd8PoXtoCWBKyfhoajdt60bdUFK1ygQXLRvlgpJDVnGH+qM/iMj+eZ9PGjTfooAVhipBofjbI8P8/obPspp7HXhp+J8YuEjSq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 09:27:18 +0100 Michal Hocko <mhocko@suse.com> wrote:

> On Sun 28-12-25 15:44:55, Dipendra Khadka wrote:
> > The 'h' length modifier in '%hd' is unnecessary as short integers are
> > promoted to int in variadic functions. Use '%d' instead.
> > 
> > Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
> 
> Why should we change the currently correct code in the first place?
> What is an added value?

It reduces vmlinux by 2 bytes ;)

It's a teeny issue but I do like the present code - be very explicit
and careful about the types we're dealing with, don't rely on unobvious
C rules.


