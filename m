Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE17CC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580AD6B0088; Wed, 30 Jul 2025 10:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5310C6B0095; Wed, 30 Jul 2025 10:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447306B0096; Wed, 30 Jul 2025 10:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36F646B0088
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:01:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBC5C11405D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:01:45 +0000 (UTC)
X-FDA: 83721094170.05.E32E571
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf04.hostedemail.com (Postfix) with ESMTP id 184614002E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:01:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753884104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NrEqE+qdWKX5Oy8lhCggNrWw2dlKAprGN4eu8ZpDCPQ=;
	b=mwGjOAAao/pRb8nNJLi6u4KL88IV85Qjn6CvQZS9KuxN24dsK3Lektq7X1BziJCvkCVggH
	o1/czFtzRts7H0oAQtnpwd94+BcA4JIxXa7kB7dYy+T59PiWBLvd8Wq35PBizSHhti7Q0o
	EAsYCiEzjK+jY20MS1hysxJOfZzjBEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753884104; a=rsa-sha256;
	cv=none;
	b=oq0fiv4dDWqLBc2c3/OfOkzBQ3mYdBLzM+ujDrfcSr1XhEzqVyRlS3F5Py4wWRLu8qPVyR
	UHxOTYIqqyNk0dgUN2W+it1YMWHqnBqnYfF/2PgE8XSDkrGwV79wb3d5rY3snxK6NlAGFL
	INMb+19EAMGtjufdARZcxJar6Ti2JUQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	none
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58F1C160462;
	Wed, 30 Jul 2025 14:01:42 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 917A41A;
	Wed, 30 Jul 2025 14:01:39 +0000 (UTC)
Date: Wed, 30 Jul 2025 10:01:55 -0400
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
Message-ID: <20250730100155.268d2442@gandalf.local.home>
In-Reply-To: <20250730225722.c88d2dbd3dfa07310de7edd4@kernel.org>
References: <20250729161912.056641407@kernel.org>
	<202507301452.JPAcMvT0-lkp@intel.com>
	<20250730191101.7e6203f21b94c3f932fa8348@kernel.org>
	<20250730091727.7b3a8b96@gandalf.local.home>
	<20250730225722.c88d2dbd3dfa07310de7edd4@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+/YoaC5S0m6XgLEI0KXUlT7Ux5npWQxGs=
X-HE-Meta: U2FsdGVkX19fNWmLTzEFbGr2d8oyKHH1JxLjen/f4/Pq5ZFXK8n1OCSZYlWKoRxJjvbVP1eZx2Z+YU1Vpu+9GeZeuzlfTnEqu7ftGHkC+D5raU1QP/7i60awdafBIT+ByL2WPuB9n3BPwnn6m5KlvxrCTRoGpEbwYw3/2Ip/qhCOkYST0eKSpo7BkeHKSe9/peJwCwGlRYNyRg7WSL4AS2OEvyrVCwLgW2aOmRvz1eY9o5NzbRQKm8XH2ZvO+Pw65mDq8IMzB5m0PuoXE0uVRWKrqDrS7X+QWDcZWcT82Xk/VUhryK/7MRTKmZERDPdoB+94XmgxR+n9lYsrje3SIygbYUAJlwTo
X-HE-Tag-Orig: 1753884099-284807
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 184614002E
X-Stat-Signature: 84zsausqfo9hcd65gummmrkzfmefux6e
X-Rspam-User: 
X-HE-Tag: 1753884103-877845
X-HE-Meta: U2FsdGVkX19VD/Cm/jZ6x4OaUI9HqtCTFMatZvl/sJ7RU/puOq/ui9vs17ljhnZonnQpg2IQtQVHQU2z7jjEjREqqEAhVwEuKTOUfYi412LBdSFina7IAAcQICcllxDYRJWoHfVqYHHAaIO+d4hlCd9rejOgU8nj43lZIRXg3QINMPAgp9jtYZh6UWMFg3ZP7v29Bih8d6v5BmQZg+bmy+oATGXOqvoG21cthvM8EELLQY0GTZRKkaQLVz9NdmEQ5M4Iu0F8roN9GzlhCXGvupkPVkARbfzdakxXrlwuNMMJj4PO5DVyTVp9RjxwxVqrx+7xbwtj/5wVpszZzA4Qyz3xfMEmazLKGtt1YKfTZta3rXu0F0/lGHbkBX8MBtI76lwFijgZ2qbF9r9+eTENZeKlCz70xAhVb+X9e47uwmuPIHKF4vaonWXNTI9q7dXFFqQuegyw2c0Ib063DTfCNDPnKMEjZPs4+oSGkaTpYBuyDYcP2lqphWCCWMvZgvLZmmayyRb9q5TZO/kDllU9YaAT0NDzAT0s1wEEIFOOiSjykPGAWPGaj60XVQ5HmzSNrW03AkdODcvIT9ZLX+VCo5APOMNs+1UGpCAnRcpQ9y//Q5Ag+vfgPMnI5lSmjGWfp72gp5lC4lYb/BiEDZ48d2hUEwQ31Pp/E9D3kaYkU7+ei2Fo+8iIgmCsjjsb034ubgVpJioHgTB9HGkRR0Xx+sLtC95tYSHg1ClUJ8kKZChMqn4f/S1sI4W1El3L/psdKIUJ+oNkufoEAGCGzWNwFQLxWz1g5Xp1hnuffjm7O5r50Hw0odyeD90rkpV8InSlV7ykl/cS8BvGYzlUlu9skQ7pHGxq4vd0JTttuq/k9HCR0bY13dczaDtl6SP9x2gPZSuoENoM+C/74sCmLUxKSPbb+rEEnIEpaN/kVbwkzy6KEDbKZzR4WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 22:57:22 +0900
Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:

> > I see you already did the probe pull request.  
> 
> Ah, I thought this was for the next one... (but I think it is a kind of bugfix?)

Yeah, as its not adding eprobes, but just making it configurable.

But you haven't answered my question ;-)

Do you want to push it to Linus or should I?

I still have the trace/for-next to push (I've finished testing your last
"attribute" patch and now I'm just letting it simmer in linux-next before
doing the pull request). I can still add this to that one if you want.

-- Steve

