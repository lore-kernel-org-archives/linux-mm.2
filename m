Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D813FFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499416B0092; Mon, 27 Apr 2026 12:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FDD6B0093; Mon, 27 Apr 2026 12:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387376B0095; Mon, 27 Apr 2026 12:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 271C26B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:58:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1DF1A021E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:25 +0000 (UTC)
X-FDA: 84704944170.13.8CF5AAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B91F94000A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="TgR87r/t";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777309104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LJqHfgFu8BmTEERX78LJi/hxMTGrefOw/D2+E6mzPE=;
	b=ApzB6NMVOD1oDXzr6rWVMdGnpXQakUZ6nBYCD4v3anWgRgl3sUyXzFjWt+/XcP3gJkC/L1
	jmp3sQmvaEzRKyS6zqeTz0iK8Z6rck2n1GO16brxho8ifcqeQqmql3izdSL+RCxJa8iGVg
	IQfMzDIHNpP7qpac1+ZJW8Ud9tfMskM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777309104; a=rsa-sha256;
	cv=none;
	b=ktjUUqmK/ftHMMZPrJiciTbPZ9G8peDdjtY6jbPcx/WWv0LqUNCY/YsVhPGYegykfAfVKo
	CHa+8yLaSFP0l1vh2gAv3fKS30hQuKdOs3reNXPcx3NOq5FCqOB1rGBtIqeE29rXi9ke2d
	BIsJayiL4rJuZchRj6K4RvKWfGmmoW4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="TgR87r/t";
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58ECA416D9;
	Mon, 27 Apr 2026 16:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFCDC19425;
	Mon, 27 Apr 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777309102;
	bh=gF0/KqE2r1s/rHh37xnH1iq1RSWy7/8b/0idZTppFi4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TgR87r/tAsqffUdshHCL+xOVugvkbtl37982ubKyKahtqP+6u80aKTyIN90MOzS1p
	 32Xr6wc0f60VvHsrLxoe49cUpvWcaPcKoT9ATaOVTPW60FVLqnIVTzyYcXafF307vF
	 VXWw3Cg5uqEYYE5fRxwUmZhnv6nyKBXyQc8EAez0=
Date: Mon, 27 Apr 2026 09:58:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org, LKML
 <linux-kernel@vger.kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests
 invocation
Message-Id: <20260427095821.b9ec5644c83ebf0ff5b9a80c@linux-foundation.org>
In-Reply-To: <6e105a9f-e335-469d-92a0-9bd0aa806706@redhat.com>
References: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
	<20260427091250.61316471db20dfb0852141c1@linux-foundation.org>
	<ae-TlsIq_YkQcCUY@kernel.org>
	<6e105a9f-e335-469d-92a0-9bd0aa806706@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B91F94000A
X-Stat-Signature: 7f8y3j43grqy15iec37cf9d44z136771
X-Rspam-User: 
X-HE-Tag: 1777309103-617452
X-HE-Meta: U2FsdGVkX1/xS92SMZrlNYsZfDEVcpfC5dCzi1lzVJEbuQtooGZ5JTLngjIFVOmp1sSvDtCaa3tNgc9/SG4g0uLyNnfEHuG9+Vn+xe0V+8ygZPJ7i+8AWZJNs3o1tljpUYahV2ODndVB1JOuJQwb97kTfQYYDLKx3NdE2W3pelWmlE2sE0f4ll0GQF4jSP5Gnx4y4frABRG9qMzOzx2jq2UJqw/TSZXq71GwhbRIl0KNyk1ER4ZK5InZqh/uTLT4UXxsGtoeY3d2K1OcZa8OPzXTzGPoY00BhCqYtKbXMZxL6FVLEKROdob7UdJayQxb9c8XFKxq3nncEmdMxs3oZxphvfJwoxEwtpVVPcxLgc5mXZGMzlBR/zvQT5+evRwW5iAkNfVEBn/STsM5JGah4TaEJFpv5l06v0c2206zTPzgmTmDIIOt4ma0vBpSyD0B8ulH4oqwUELeomILjuoMxOAtFNeEcf7nvbM3zsvLTeZkKr5oi/qRKK1Dam7vX0OdWuhYkndpvzr6Um9e6/5qFlJR5bpW5jjRgfCZj6pECD0QbG2QDFtOuWP3s+2Pl618oU7aS1OulRUOS/GDJkH+pqnF8TD28HiXoUIX0HHlV53a1PJFqXN3+/tB57ZZfOnm6QTHq11dwLcel9uV6NuvmlIe0LwTo5fsA1Pu22GuxCoBC//lXntiCvS/jItiqLIec5AHvShDdgQcW3SOoEbSVZPwfZOpLj/1JEcCFCOKT4BnAnvSBXqSId0Invb44UMHT4SH55wqqYCB/SMJk0vVMjJXTE+rf9rqqFQtnc7mR2NmXM2EN66Lucc01S+mkB7L8l1C8h55BL+rv2yN4x6IfvCMLHtCzam+1hCLsWhctr/DEjKpPXtoKeh7pKnmZDiZFd/R0/8mOu2UOd8a4T3wURDIrWIb20YvW8YBKI8yTC1AFrZLZcff28kjhQdHNgMEBr1OWyDh0eBufhzGw38
 nFSwMIe7
 FpJHQ43v/tfjRoerukwUjUTBULLFwj59gjdDgwwwwErinbXJQ+4umgAgXctAYPq82Dil6Q6Sw36VuxTUv/oQiExfT54Rz6RT7EGUn+7ElOfDfhjaCxBTG3QkSSm6vwNnUv20yNHGXMNdzJB1YRvYv0jqNWWt58JubaPhEg46S0lKYSmyTe/p1K8NydibMnd3pMyWHCiUn5uGeh1MUWVm+UqeCmgMomT0RG3hHLuURt1Lrt7N9mfs2PkCtHrtrYZx8HfBayteBQfOuSj0pZmZERUc+ZAd5tycw23FE229SiRqRawKJZvL5JsumdHi754X9BoXd1N7cu0NYdD02y8/8NeBFsqYQuwQ9eTQBgUERqPoreiTAhzaSM1KdyURfUuQnWEktgRGFu18gF+5xm7n0gKbnFNwuvtlft15QULQrsO6mMWTPrNR6I09azggf0MH8D730ALnZiIikMauGwBXAbFl3PmJX7PRVzykDVUi3cGwBQLYzWq8f69HH2oGih0V7fCU9120gm3Q9qj1b99lzZSLP7lhK+o5EjV6r95ZE4TZ9lbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 12:55:34 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> Andrew, do you need a v2 or can you edit the patch description for me?
> 

All done, thanks.

From: Luiz Capitulino <luizcap@redhat.com>
Subject: selftests/mm: run_vmtests.sh: fix destructive tests invocation
Date: Mon, 27 Apr 2026 12:03:51 -0400

Destructive tests should be invoked with -d command-line option, but
this won't work today since 'd' is missing in getopts command-line.  This
commit fixes it.

Link: https://lore.kernel.org/214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com
Fixes: f16ff3b692ad ("selftests/mm: run_vmtests.sh: add missing tests")
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-run_vmtestssh-fix-destructive-tests-invocation
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -103,7 +103,7 @@ RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
-while getopts "aht:n" OPT; do
+while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
 		"h") usage ;;
_


