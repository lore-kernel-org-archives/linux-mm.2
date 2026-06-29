Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B565C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24516B0114; Mon, 29 Jun 2026 11:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED44E6B0115; Mon, 29 Jun 2026 11:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC43A6B0116; Mon, 29 Jun 2026 11:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B52396B0114
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:51:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A1231401A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:51:33 +0000 (UTC)
X-FDA: 84933390066.14.EA7E8D3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 02235100006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:51:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="mqqMcK/S";
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782748292;
	b=7FDDg50TyJUP7vjKMfSC11JEypSbAY8F8pHzPHZw86/SXbgDfwuCkUZfZyPY1IZ6ZSWKGh
	HCrq4Ii5plQGS8Tp7D3Myu+x556zwkkFmY2es9wOohvb6gW6+0euJm6ux2TMGLcOS0XZvf
	sqTSrwHxqrpcb3k63bZQrn3LgR0YuNE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782748292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeejG0MGjUvD4AhkLMN95MQ3Dsdsxp52TnuJQNelYwA=;
	b=w2IMVYRoGAvfKqxPbKjmiVMgalG4thC5yTTBHFkpBPjCsT4FvoH4u9rhWwtoUq9npfRedN
	ODRBTPiykkf/cJdHQqXjSiMPL9KnyUuGZa7qKXb/QwI7Xm08T3+7O3qdIi4eaobbju2khu
	a5VZ9IPceV7IQkqUR4q2C7cuypuwIHI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="mqqMcK/S";
	spf=pass (imf05.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VeejG0MGjUvD4AhkLMN95MQ3Dsdsxp52TnuJQNelYwA=; b=mqqMcK/S0ffTfirKJEMqcC/Ija
	8MScC4GpriSuke5cvw9W89OocMlePAkwIX6hRqRBAOBICl/Jk24xJEReCepneIo9AsQ6T64BsTEuU
	KJ7v6x86URFpLL6v0b35ayfP3ksScr/ZCwY+9RFl7FSivLEKwP1HPvd4T3Ky0pLFbp0Emy+LGVbAT
	pa+V0JFJJnN0R/VjabN8iyidZewJxzgorjpeRhG+v4WZV/eUD+Er5X0mQ+KbBMLPuVhOWukCRRPkg
	UOfYtf/pIAn+/y4sWQEsSlib+rJMDZxTPoWNtksRVS/9IjviHEnjRXOIgnK+lHrm7PpeaF8mwBgHD
	xA9VFsaQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weEGA-006Ojz-0e;
	Mon, 29 Jun 2026 15:50:58 +0000
Date: Mon, 29 Jun 2026 08:50:51 -0700
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <akKUDDtww19NVra4@gmail.com>
References: <20260626-ecc_panic-v10-0-6dacb8ad024d@debian.org>
 <20260626-ecc_panic-v10-6-6dacb8ad024d@debian.org>
 <aj-BShkN6BXex_ku@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aj-BShkN6BXex_ku@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 02235100006
X-Stat-Signature: fwjmassedbj5dcwns5wzgwd59x8f611j
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782748291-178289
X-HE-Meta: U2FsdGVkX1+u0QeEWuzx1sFqgn51V+lvipb00OVJOmmwILx1Sf2nGLDq5Tw2avhasv5OyZTxlylMXz/179XhDezQ7IyInUQN8QVFCGT21Qyki6SJe8vaYhu1TaQrnWjxTE6ov1fcoOfePfd0eP7mdQjl8X/vMpAQh2ZsIm9g9qivZFomCxNF2WWCKKADDowiT/FYkKrjE5bMGBnGDP0tg+og39ky3m13P4Xl9VdQ9ArMPU8v2MisCgSQ2+UKBoWlahO8P7D32BmOPL1hpo3U+VQgHgOwsyLqGYac5BHYMReyIwRwmE9GTtZfVt8+W/Ku4dm1HFOMv4vFCryiVy3qYB4YaW5C50+y/1KSKdAOmRByp/y4TYLQE8bwAxmDYBnMvqTNh5xbdP8lLGf4W0ou6Ez6bnUPaj3nlig6IjySOjvHSTPpdlJPoPjMCg/uLOzvER3k5VjMpZFRMGwg5XhTOkfkSiP6NJX072mtbibJX9Xt0vx6I0ZeO+6hFGTE8QpMXivVWqOEBQJdTem77CdkAdg6MwjaTYDv93lzgHRZwj0Fjt/vsYEHxfDirc2lGUypb/GO3NwIKeNRaIE+notMuDIQGv59j6mBsVbSp1MWHq8ARFh7EPzSGr/n6wSfO6hr1Zk0ltXnb0lD6Kd8rqFYVlYpopGHcAZuA4HPex2RAKjN30Omv+x30T/9E4Dr0DdEfS7FY6YRcd0Rngpjg8ETPTUjKCrOgC2iMK5buOt6Lyi/l1tbo+EYgjZ5wCST7mqEuthArCZvNSpdeF9CCqRd3Mysx+Mb1Pqz6nsd6pmhardR2d9m3KJrXw09AcBtEOaqxnArK6hjQGiWaIkdRfNzeFlFGoW4zLyYll66ho/MYk1q1gXyFjiMSVm2N+79oY9wDfy+Y1ZjLFyakD+1gpDaJ0bSL56XkMBTdHn0HA1wcMBiTI5noJboxl6pKgFk8f2PdvUxj4OzttH7Wi6uYUd
 QgvM/pTt
 o4IfZK0jXsWbSvIIt01w7XIZ0wW7p5yWX69nKgGpWCqQFxvFFy59g4WzY5GTM1JsixUltGp+WjtsosC6mvpcP1wza/EEkoNZyXiigF5/qoBd1dmCy8FVK2kJdZiUXOcZ47GXfMxO7UDBAslEhR88UZ7zPX6WePjq2e3OyH2mkVljsvJjwiM6JMCuurc3aEYPhM/Cb+/EicZqNEMW6ZZC3efGn7mMKvqaBY5rNPffN1UAy2mSwr54zyngXhELTwfb5hDK06w0F/r2I0qCCV3EocNhkx+JEYGlL7ojeEQnUCbMsUKkAsiFI98o42/NAhDcrUlEK6nCn6wbwtQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 10:52:42AM +0300, Mike Rapoport wrote:
> Hi Breno,
> 
> On Fri, Jun 26, 2026 at 08:33:20AM -0700, Breno Leitao wrote:
> > Add a destructive selftest that verifies
> > vm.panic_on_unrecoverable_memory_failure actually panics when a
> > hwpoison error hits a kernel-owned page.
> 
> > +ksft_skip=4
> 
> ...
> 
> > +ksft_print() { echo "# $*"; }
> > +ksft_exit_skip() { ksft_print "$*"; exit "$ksft_skip"; }
> > +ksft_exit_fail() { echo "not ok 1 $*"; exit 1; }
> 
> There is tools/testing/selftests/kselftest/ktap_helpers.sh that already
> implements this :)

Ack, let me source that file in my selftest.

	DIR="$(dirname "$(readlink -f "$0")")"
	source "${DIR}"/../kselftest/ktap_helpers.sh

I will update, thanks for the review,
--breno

