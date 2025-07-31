Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EB2C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 11:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE2E6B007B; Thu, 31 Jul 2025 07:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457BC6B0088; Thu, 31 Jul 2025 07:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3469F6B008A; Thu, 31 Jul 2025 07:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F5746B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:43:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D782C05F8
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:43:04 +0000 (UTC)
X-FDA: 83724373488.28.8657B72
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id C680980004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:43:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753962182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNZng34dT63FE37DHzg+AMqrlz9B1bTsIpA8vp6Y3ZI=;
	b=V/rOJUlWscGqEHmnx7sqeoq8e2V8cdg1Pbu6RI58Hcg1aUmjcXphid/gRRQwnWzGP/h6Y8
	QMVxX+DFXwzCDBTuXU2PGCArlBpULne+olvNTkVTjDvlT7gSgKb4e1RMkJjhVgHv9lN7Xn
	RRXDP/c71Rd4p8cCCNiICa/EyJLfgKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753962182; a=rsa-sha256;
	cv=none;
	b=LMsTtW2sXdnAc4Tg9u8vlH8ulQgMz6OpLGVsNZ+yk5J/oqLs1NYB7Njg/opZ74sbPOJiBV
	54FQRFYIbVwtfoOpruPT5O6tob9QTofAUP1Sbh/1O3rnVs2ytOdIBr6GaT6YEPlhOKvbhk
	FMLf1tgrzQsZTZ4ik/2xfaQRI+Jg+50=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25FCE5AE12;
	Thu, 31 Jul 2025 11:43:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 649A22000E;
	Thu, 31 Jul 2025 11:42:58 +0000 (UTC)
Date: Thu, 31 Jul 2025 07:43:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 oe-kbuild-all@lists.linux.dev, Mark Rutland <mark.rutland@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Namhyung Kim <namhyung@kernel.org>, Jonathan Corbet
 <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/2] tracing: Have eprobes have their own config
 option
Message-ID: <20250731074316.01372681@gandalf.local.home>
In-Reply-To: <20250731070836.69c43401858db35dd3b43ff0@kernel.org>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
	<20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
	<20250730091727.7b3a8b96@gandalf.local.home>
	<20250730225722.c88d2dbd3dfa07310de7edd4@kernel.org>
	<20250730100155.268d2442@gandalf.local.home>
	<20250731070836.69c43401858db35dd3b43ff0@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/2QzxW4XVvfLrsFIwKaHhcoGCASP1Aksc=
X-HE-Meta: U2FsdGVkX1947nv5PoTy5NutxctdkU/H9qclbFNhMbDa/Emfi9eh29SVV8qUTTOxJKouHXZcQ88Un7HHerBhmr8IAWIVbZmv/S6GXXI33owq+ZPkog30CDT5GZ77aBlObKXzxgmYSrd2eXytOamIOH1Hn7IFJMW3eD3yA/yHdKJXPMVgTQWXlegT6B+rdsdcshalXqiheuARp273GsvDUOiL0CNcXZ+y+IQySTMO4Dq+rHIM7ZolMg7ADr1GC8oocpktjM65YslXXNm428dyjDgkt7CAwItuTH9SESGIyQoeWvhqGeAz+CpPnPMcEidmFxHcQmZBQSMwZc9jeLErgM7XFSQefTMe
X-Stat-Signature: eamgt8m16dyjxneimeu1i7pdo8cbqd71
X-HE-Tag-Orig: 1753962178-872116
X-Rspamd-Queue-Id: C680980004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753962182-646476
X-HE-Meta: U2FsdGVkX1+HDp036UCjzrWTPrhVDKgEkUTYhtva0hoj+QnBAKeHdNA7N818Kwf/3PxL7CueIGAv7AMfdvBKy2FvID0ohn8yUuqBn37iJGsKyNacpA50WzuWqtyQuAWFSzn5NnMsId7Bk2wipXNCJrsO9Z1bUhXiBZhmRKYI6SvY2jFLgpaw3IpqrTKlesYVcrCllvPfMOsAr8zDfVaeXfO89uPefKJ7ZvlzpTu2G8FucO7KlJvbmNy05PEgsfoINGq61xl5kRjMUYf57mN60zBzlPD86czxTq3lU2IcL7z4Sx8Ta7axYyG5yJj6XABbVCdLVAmBTKsyFf1G8vvUmti1oMEEIQ/WJsA+RFKAoFmldqUD/DoP9EdrEkUDi1Bdm8mzt8PJPHBt50u1/zbGqfjRwyQHfzsjNJpvOS/tafatkKJj0mgvs4xcrl8QjgKTgRqSLPglEaejb9Yn82DAsssLom/e+tLx0YDFaXatmVKge8XqgiE3tSj1LAQhVKr5Sjbj0AaDBwKlXzWJNdk/YIsZiKEO00PwAvYfsm4eGfycA8omdwBdQlx8vqrrjhzVebx45nKovABGahzv/iK80GvYr4UdU+nRjbNjknotwSxe/v/vkqmkEzpneNWMs46+RXfggYh4YvrkzGEiaD1FlVXrx0A3EQusjM4UcObXXjHMyK3vallCu0jzaBkd2Vg85BVXrB0gJj/f0Mz9xwr8WwgcGGT3zn48VamvTJNq9cHn1fn+fBkCqA2yWJOVY5b+NriR+TV/DdyWdWDfYDhYO2oNw4T+aZiu1pDo9/0L7tOQefmDloz/9ufytOH53wa+gIzFKDiCD3nREwr/Y+QqPh5O3SRJ5JAXv/8VPbLe6aJJO0aCs+cynBwzWAw1+bQdptK+keH+8plVK4NjSChcxSL7NeyA1zzI7D8pkmn8d8Bqa/dvboagIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 31 Jul 2025 07:08:36 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> > I still have the trace/for-next to push (I've finished testing your last
> > "attribute" patch and now I'm just letting it simmer in linux-next before
> > doing the pull request). I can still add this to that one if you want.
> >   
> 
> OK, could you push this to Linus?

Will do later today.

Thanks,

-- Steve

