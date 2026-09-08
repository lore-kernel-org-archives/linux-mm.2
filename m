Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78473C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C3A6B0095; Tue,  8 Sep 2026 09:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822606B0096; Tue,  8 Sep 2026 09:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75FB36B0098; Tue,  8 Sep 2026 09:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4856B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:43:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0505B805D5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:43:57 +0000 (UTC)
X-FDA: 85190713356.10.4B22E8E
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D78B140013
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:43:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875036;
	b=fq+L6kIPp+Vz6asCTCXLUFaU5sHQrk7CseaA1PDB5JN4dL/6TKoVP1DoZN/x0WWjhwCEzs
	KT2tb0BevkwD2WU4dJT3dn8Htrl5Mdgpi2GQDbDMoJCzBxHM96/fgInQAGW1BwLVlLVTBc
	dY7l6+mOdCktdrsVNyNtmblGNYGIg7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiU0gQgIivxMXDl0zgbYhPk8oyM2E0DKZNUOWfXezPE=;
	b=QwqD02VN84DEDxprFlR4Of9+4SoaohpEhYzfxl/K7fO55kk6RXV1PGXNXzGJCX6+WK+/kH
	lAad8jYYiXvf7JocL9vy5g8Ip/C68T8GtnjTD+XEcpKfwgLe0JdUIoBAbBC4/dAfrJdG9y
	mVdTHXQuqODNwnoIV7qWGIKVgXcOS4c=
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AF027406A1;
	Tue,  8 Sep 2026 13:43:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id EC2622002A;
	Tue,  8 Sep 2026 13:43:49 +0000 (UTC)
Date: Tue, 8 Sep 2026 09:45:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH RFC 0/2] mm/mglru: add tracepoints for aging and
 isolation
Message-ID: <20260908094504.262faa76@gandalf.local.home>
In-Reply-To: <20260907042447.2450663-1-ridong.chen@linux.dev>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18+1aPqEe+I0efvAIbVVaN/kC99Mx8Reec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=iiU0gQgIivxMXDl0zgbYhPk8oyM2E0DKZNUOWfXezPE=; b=HpE5SGiiuxKj7bq47CkQ+++7aRTVn0JFl+Fm7gbccqwLXDVJwKpZKF92KDYlHPAW1+xCdsG7HM5kzci+/6vUjkKE/woYRWAr6bGuydlUiP0t0Y/H6Oadp5/KYwE/j2chH6ZUchcguZiLU7X2k5oY1Cqi6SAV7lVVl0CmyMCaZhg=
X-HE-Meta: U2FsdGVkX1/QHc+GCH8y8n9WiheCPKUalAQc8N2Ac8+hSz2QrlRSsvCEAmTJaejt+PWh9DowvhMneXV/VBuCoyox8UCVAyTfvndQq9kRwZ3drGXr3F+NM+9RigwfOcodmN8NPpabS2ohcQKPS5VmW5SgvRrSbws9U3DySbWkx0eYQjIlhs/WH0nKqjFpMtJmViItE/JcOD2RXxHI11wrJfv1sm4meJ8CcZM0vLQuvDLsJpE+sLFRyJS2xLmKb0+J0ndB2z/8wdr73gXXQWRMUK0QkqC0WnPE6IOp+hfpE41N7GAbXxJn1eyLF+Ypgg5iUJ3rufdNV4YJ/cppdgR2SIDD7N8RocQxa6m1Mo63Ar6VnHZ0z7r3/tj+AJqdmyVh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D78B140013
X-Stat-Signature: ghmwifje766hkpe8hxg8fraf4fpcw3zt
X-Rspamd-Server: rspam01
X-HE-Tag-Orig: 1788875029-929189
X-HE-Tag: 1788875035-455692
X-HE-Meta: U2FsdGVkX19rPlnYy0Um2yZmn99/faYI/I6UfGNoMvxnmqA97/8q0rjSn7bDiCTyLd7xFGheeYCLmspOzgEdXErB4KELGZzQWijbH3eUBm9YjLpb6bWENmIXaRA1Q426Hpu7nV3If1exZB30+1kHO1qxBwZ9DHYDF0yO8n0/8ex1nOTQjRGgvnbOvrf/iI52R92clhS6KJkIfQ5eVI+c1/HfCGXmROibnoxncBC1pF1lnsn4kHm8gF6t4VwfgU/oTwKQJrJHkKlC9nJR11Z1GQPvuyZZMxICslhFET4hBpPEPVIJD4q0Ze0iRtGK0/IgVy6RyyKDJzeHqI0xbnfZQm5jigSQwAxaT+lE6Hha6Xnzs6Ds6d7erHU6Hi9vWkNA7uEiKUrZZMuaRT0qRNhPcZECALjOhEK3gSIQlj33e4f8oNymrscFmNCPpZBrbzQupVdAy39bT1J3bke3MHqv1PhWbL8PKX0UUkigOrbz0aaYNMMFlF1KsOUwKLKmOPol20AdY6a21s6nY4pT9mtEwqS1+UbyzVPKMhBj1JERR8C0LM5PesSrgrYQtVtxxdvQkEyc+cGCxTxlxgxnYnB7zYtXExwertIEWDfFJP5gT8llOaZMe5HqA54IcElBg6TUoXDaqQmr7JCHjTzDnu8B1XH6U4oXFszAklL456K7vQBJtiPVVA+rr+VNMictd3H41nj0iX7uRWYczhvhg8wpfC2NzxGKDdJfv/78VXXz+DCbCd3XQEhqBaSZvMxubYR6UUCqF4/7j3s+EN7xy3B1WKHrlP2A2ZIhXYPX5UV0FraX9/wAyaW8GvfpS+N78ltFdGLjyS7Ib4ZmPF16XpCNs+luFJFfq746mi41jMoVF1xyI0U4eLuNfgScII3hDHXYrieJw8vlqPcLRuoAPTfGlrn7Tdmr92IuGfW/JLdZpgbFhNBl2w15N/HcAQsHNpnjNgCbL/2jMabTtuEFZQS
 xPuK2gdD
 15f+Ibb6E5Yy13M0T8xqSzU3KTmzUE3//AfWRy4pnyi58csFE0I5ioqRJIG4jwDoDMhDEMDH+MtNDyXi3i3xODmhXsHPLxmIkbukMAJw7G3hdxwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 12:24:45 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

> Sent as RFC to get feedback on the choice of tracepoint sites and fields
> before proposing them as stable ABI.

I'll let the MM maintainers determine the above. From a tracing POV, they
are simple trace events.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

