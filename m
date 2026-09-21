Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B295C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021F06B00AD; Mon, 21 Sep 2026 11:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B726B00C7; Mon, 21 Sep 2026 11:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78D66B00C9; Mon, 21 Sep 2026 11:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69BE6B00AD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:11:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 475D31401CC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:11:39 +0000 (UTC)
X-FDA: 85238108718.04.CD75B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96CB2C0007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:11:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6f7WBjB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E6f7WBjB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003497;
	b=w3Dbot2F7AU9Qnj9DCz+xDNv5sj57q70+KLQNswHENNdFvNPP+4PKNBDIeYZg3BmqBM02Y
	e6DOskufEBpxgDd8CWbS+v/oah3b2FjgqA/yRUnUJvPj71nDwZwGtC0sA2bZS6qx5ad4Yy
	t723QiCltVjKsHlRzKUF7sLlzU1EA+k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sk9vyzM2uD70wOxKcgsOkvu8vUTfDretjM61Kajj3YQ=;
	b=TpMtZu6iZ2I1FeyurikNX6+Xk2YwgxyoXSga1p0rn8T3k0H3A/FHbrn+5YZBkawphwo+y2
	2833tUIahGbSKLNTD8JlpMVO/TKnp2ryXIMjDP+Bl8QSlPkQst/Ixxh+czsndyBypCKUP/
	QCm0po8vJoTs4HgbZgRYlTSUkiGu/X8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9410640BA4;
	Mon, 21 Sep 2026 15:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13351F00893;
	Mon, 21 Sep 2026 15:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003496;
	bh=sk9vyzM2uD70wOxKcgsOkvu8vUTfDretjM61Kajj3YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6f7WBjBZ7DfKPwEOp0rJ376pA35DG35ZBXKt6QxAZiM8siaD2taHg6eqegHA+pk8
	 KxNcVmTgeWAdCc7gpFNcJRigea73Knesk+EDOnoF9/e27qOo+CBvxdGVh4sCYruKxN
	 xbAyw9GL31PSUmJP6cyas1Qm4lZ3uRteWQ0/ZazUKZhWzFjS65e1yxXjs2Om6JC3Hl
	 Ms2AMCTKOs4/1lexafUF5c7g9RoXhg/99AxYjda9pEWltPzzkrtTSXJ9jas+GefICw
	 tJjf8jDopDmBxjIcJ4Jp6bNjLRWq5vH+51IKdtGiMJveimuRM8/2oehmahMNO42596
	 Xclje/YqvJvmw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: vbabka@kernel.org,
	akpm@linux-foundation.org,
	Hao Li <hao.li@linux.dev>
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: make the case handling in __slab_free() easier to follow
Date: Mon, 21 Sep 2026 16:11:29 +0100
Message-ID: <179000339670.55983.14009373005903071416.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260921125421.142452-1-hao.li@linux.dev>
References: <20260921125421.142452-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96CB2C0007
X-Stat-Signature: rebgqqt6zs4zs17e1dhdj44j137xqwit
X-Rspamd-Server: rspam01
X-HE-Tag: 1790003497-367842
X-HE-Meta: U2FsdGVkX19YB1t6SK5CP28BN7SvTjB/Lh58XdS/wqITmrNcM6tYOGJ8C3O4FMrmJm1aH7qU8zaz4J583ax8qPqkjfwPYXLwg/NGd0AaQ+fche63B2LoOc2u/rT/kXKu6DBKGPKk6eRqQBwIhgl84Zjeg1xZxpWnUfpS5U782LBezfQvrxUunpqlmaO8/DJz3wlcteatjJVP5U2xlHO+44lOr8IUfHVRDzN8msF9teo2Xo3paovFK+Zt/QJSyK2p6XpiXfkr1YnMZMtpK6h5wTpkWWuVpHzsg8yzZDz0H89ou7MUmWcBpZsqrzzonANCU7OtQI8WeL4spnKebahwoUjgbaVmHsXzHKbLgK9tQuvOvYfRuj4sbii1Gg6tHgwzxvTN8yF5gAo8sc4sbYI3mloO6oiWYJSs4nl7qUn0jmqp3EzHgo8q0qEJ3AFmnVYfFQB2t68l89Ziu9kZJIsVnEhiWPDng3HE+xUSvpxu8jSCCZ/1r6daG+vX1M3I3AEuxYYPallI5HlZs0xiVbyasrAqkdtXkMUDTCPwNIUNh/TzGy9hlGk130LQmRo/jgkMGvRpoLEYjtYhCuvL8LnEePianvbltxV+UJ3aZKF5hXly1IQyU7RVN9bl5JL4O7HD7pcECLLHvRqNTvTsREDC8gC9GJUV45JzTrixEUy+yinPKSmHMMRRGstfiTHSfhWpsJImVJ8rFqYCqTx3Jzksd3guEtquyCoR7M/Z7zUyOomFTSas8AU50zSvlQNwV4gyRdWZ3EqMlpoT1ZGgOxIeGSTVRq9S9LayVG5NsdKyBe40x5RNa/YqWQtKoFVur+ujF7+Hga3rnqjfZIzIKHm/qAbaL4hO29aSo2ETE/csp3yelRaLfIg90XncmxDPlvWZOmbc5V4s495oaewOAwiYB+1Y0ER48Uorx+oNzYxM6j2Rhbl9wILNiCftUeXZXV+/vJs8y27hh6CVq/nCpC8
 v/ksCi4D
 eS784GCPgXDFveXEnIHcmgwL0LQ8KmciRM232tE3L1COrE0TL3Qk3956UaCvYLpgtDsWKVgiHDEOGrB0rdXLOCh3R/YQUU3kA6pGUqHuOQWD4Hdj92nDWqNeevbwG2If5oy4Fn6jEOEhceKB0ePbMFJUcYCIhnsU48B6LCK0dShM4xXxPex85WbvKTnTr9BfKqca0F53FkgOdiZLLu2PzyVgoZgqSwnq981tsxO70+WtVS5A8pJ76Pj8wM7KmtSiwylvL2ZNNSbRP/J0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 20:43:22 +0800, Hao Li wrote:
> There are 8 possible transitions in __slab_free():
> 
>   a. partial->partial, offlist
>   b. partial->partial, onlist
>   c. partial->empty, offlist
>   d. partial->empty, onlist, exceeding min_partial
>   e. partial->empty, onlist, not exceeding min_partial
>   f. full->empty, exceeding min_partial
>   g. full->empty, not exceeding min_partial
>   h. full->partial
> 
> [...]

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slub: make the case handling in __slab_free() easier to follow
      commit: 6932405b8154dd996b892a8a444a5543bb2bc35c

-- 
Cheers,
Harry / Hyeonggon


