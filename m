Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D313C54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 141C36B0124; Wed, 29 Jul 2026 10:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111616B0125; Wed, 29 Jul 2026 10:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027336B012F; Wed, 29 Jul 2026 10:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C24FA6B0124
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:52:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BB251C0E57
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:53:23 +0000 (UTC)
X-FDA: 85041200286.07.B851AB6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 732D6180009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:53:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kKo2A1BQ;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785315201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ss/DaoJYNqjgpN1lAskphAlKNITya8LLU2vIUgnSPIA=;
	b=6677AiiqHq8HbsqXEWVr2DWyAYfz5SZn/WUZUa3W8I5bED4cxLgg39Fvci69hU/8kNpedb
	aQq5ykiy1JHS9cnjPEjWA7EuP+4UdKjmCMTtTe5sDo/kX7r8xx/Z2yoXXwiwo9M6oPty2D
	aQxOYb8nWFHtjNeOcO9f72sD5ZxNYxE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785315201;
	b=7n0wVxug347vGiaubeFck0IJpxskRPwxO7uwMZ2w+fzqndWNqYEhv5bL9+ikY/L8Aa0Au3
	c9Ii9apoz9EXoeBKflWmdHjQq9BXrv83K7BCvQF++JP5YPBlBoup+CxRza2OqeldiS7ARV
	+smkys4T14KGV6EURzT3a2Hdt4vjAtU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=kKo2A1BQ;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ss/DaoJYNqjgpN1lAskphAlKNITya8LLU2vIUgnSPIA=; b=kKo2A1BQR3Y09foW8g7qBwUPmX
	NYROK6U4J0bpmZKOyfm1oFEXpv3CNR7vfCuRy+FO0mbwp84eXe/JU9LFMYD1ge1BkKqbwxKSdae2K
	4KqnPzg5sQt3KaFOUT+/Qrql0v/KSWTs/CgLao7wTcgECQR7c1SU6cLiV/gtktS9ZhLLmN4GgWr2O
	4ki88TRZvcEBBLW+SutP4Up07yWZHIh4rfIlySxODkjQaFtKxlBp0dlXMiRmcx1UyuRLTtaUU1YqS
	/p7TeB9eHR2ldVifgdc8dOspz1w740YC97n3B9wlxbYGxnj8yYlC1HwuqWePIDeQM51EBozdKJoZv
	akJNbqqw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wp02F-008KmC-2v;
	Wed, 29 Jul 2026 08:53:08 +0000
Date: Wed, 29 Jul 2026 01:53:01 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v10 6/6] selftests/mm: add hwpoison-panic destructive test
Message-ID: <amm72Bu9qmWLI-9b@gmail.com>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
 <20260630-ecc_panic-v10-6-c6ed5b62eea2@debian.org>
 <ee4982bf-ff45-8f0b-3b76-7ca19228f12b@huawei.com>
 <20260727212402.09baa9381ca426273fad4719@linux-foundation.org>
 <de29c5cc-3637-cd18-354d-55ceb3d60afd@huawei.com>
 <amh1nZVVaaZSGD3M@gmail.com>
 <20260728122016.30752d36c3b3c3af231efa9d@linux-foundation.org>
 <44f81bea-d64a-4f73-8665-46652a928c83@kernel.org>
 <amkn21ftNme48Vbl@gmail.com>
 <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f83d5b26-b369-489b-a305-1eb5ec6fccfb@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 732D6180009
X-Stat-Signature: gsmupt4wxoyytyshuf6iix3afdfn3ein
X-Rspam-User: 
X-HE-Tag: 1785315201-920241
X-HE-Meta: U2FsdGVkX1+sDCp5S3WPz7lQ7AkgGwCYEH1hQaz3E9deV7IK3mNaXzxq5IrcZ8B8u/UGOSZfyQ2HqRvsdHw/AkHjkc6qos8AF4nOYoNLJ0/BYg83CX9BuhERuvc7vfGOryLWmjlUi+ceCbmniAXOE2r7JlOEQcPUPzjbxoRRg3t7Gp5wUrQAelT1CUv+/af6lnDAQgLsITfAe+tiswTfi2qqC7y8QgvDp9rGIV/0K3lxwQEeBmE7cfDYinH1AjsHLuBzaMgreGK5JeJCN+D4QSjxEw+P2Aaq6JutBkrkhOdJBLS6BNyahx34zIduxeBCeeJvmQU65KA5zAatvlR/veb+9orGDokqrIwLxA4mpZgpG0yYi5ylauJhPSBU2YJnwkKIphBNXuxhD4Va2vOBmZ2MMBIRAr9bpLol2pLELBYmtau5KwRa91H7yofERbdVewSxAgdEUF5Vw0KCQN0N+TkJZm/E0TCA4dFCyc6DETDGTo+08WxIiNYoo3wd5O8WfJ0sJq30E5XkRHsUQl9QEsxLrFjJRrNe6usTOrE4ReVe/sNY94i8mopwMUd12RoXCBEBEMxjEuFn41i0P7qiEbYDKkLN1slxzlqQlJ1KmhMpewgHWevaqoczcQqEHQabkhc8hfhv8GzpywGejvPAyaz3X+iRPZG9aScTzctdhUToA6Sb9qPJy6bmRAOwhzc7AY/xJQtMrdxGp01lEfs07XnPeC6mpY6gL81PiRiBomRVskmd3giRHA92ybSlhThv02QkpycU7tQsjvAh1JGawz6AHO8k9TlC4I77x8iOEu2Ou6JJjqYVaQOcFOiEn+S5gHhR2CU9yOHiwdlxlFDbHp6EanuWCG5CwWvl0P8fD3Wnj4f8LLcvIT/45vnK1VWKdJVtFcwFbHgrzJO6V4z7bKSv/v+FJ7sZ/Q3C2ZPZq8rNnWPrChoiogFsrGj69fohG4qpdh8foXwfKcQc7Bh
 VDUOlFT/
 GLoXh/blH6q0vqJvdyvExB30s8FOKeN84z6+g2Ej64EuatJ62D4Da+27RPS7FjIC+UbCVbkbVHHmt0NvA5ZVDAkcv6/7g52CE64QEiMyfiXum8AjNSnP5CszyMeTK5wqKzbFq7inhxLdcX92qQZZnX513NN1vM0LqQbidLz1VHBuHK4e/gahgDs/RxcGBo86tHngLJxQYaMFXG7ktSLnouL/DAXzOHgyu4j/eS834TgZ//GPsVSvuCYNe6/FzG3C4V7G3i67GpLha0TUH0fRAr2lyt/t/3Gt2wLJgHhhd9F1A9AL/P1F1xxDdrCe9U1cOt5UNQ7x4LL795Smjz1R6xSN7q6AsR1pXG3QlAOqeR9yq4J+AHepayUp1kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 09:25:16AM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 00:07, Breno Leitao wrote:
> > I have a draft of the selftest in C already and I will give it more bake
> > time, and I will submit it until EOW.
>
> IMHO there is no need to rush this test here, we could merge it after the main work.
>
> We neglected our selftests quite a bit in the past, and that is biting us now.
>
> That's why I push back hard now (sorry) against stuff that is different than the
> rest and not easy to maintain.
>
> I know, hwpoison-panic is a destructive test, but I really don't think we should
> just merge mostly unreviewed bash tests that will just bitrot.
>
> Which makes me wonder now: should this actually be a selftest? It's nothing one
> would just want to run in a CI. It will crash your machine.
>
> Maybe this should just be a tool in tools/mm? I really think so. So having a
> nice C-level hwpoison-panic.c in tools/mm might be the way to go.

Agreed. In v6 [0] I actually removed the selftest entirely, since the value
wasn't clear and it seemed like an ugly duckling.

It seems tools/mm would be a good fit, and make a better home for this
type of "test".

Given more changes coming in memory failure (at least from my side
[1][2]), I think it would be a good idea to create a subdirectory
(tools/mm/memory-failure) and keep these semi-destructive tools in there. Is
this the right direction?

> So let's rather make this test well maintainable and have it properly reviewed
> than rushing something suboptimal.

Sounds good. I'll move this to tools/mm and resubmit. Given Andrew has
removed the selftest from mm-unstable while keeping the rest of the
series (which is fully reviewed and frictionless), so I'll focus on the
test tool now and send it separately.

Thanks for the discussion,
--breno

Link: https://lore.kernel.org/all/20260511-ecc_panic-v6-0-183012ba7d4b@debian.org/ [0]
Link: https://lore.kernel.org/all/20260728-kexec_posioned-v1-1-160c81d180fe@debian.org/ [1]
Link: https://lore.kernel.org/all/20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org/ [2]


