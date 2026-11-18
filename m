Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D93360A2622
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lfWAuTIs
Received: by kanga.kvack.org (Postfix)
	id 302CC6B05B0; Wed, 18 Nov 2026 10:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9D76B05B9; Wed, 18 Nov 2026 10:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216B86B05C0; Wed, 18 Nov 2026 10:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0329A6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:28:12 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88E81A07C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:28:12 +0000 (UTC)
X-FDA: 85448620824.08.074DC57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4074100006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:28:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfWAuTIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAGnVdZX/dnwB/YL80FuMYmEILyT33bR88HdQuYKvtU=;
	b=5wcG1UBwNzdlOy2yX8rMmq9ePWnWnrNbRgvWcF1cgXIZNXtyOp+iQxXAf71fKetJ2n/j2J
	4i2HLMq7g9dWecmCrePpQjxBA7zYw8DpK5dsiTnAJu5bTmh2mjMzFM85yh7JcGJ6i9Uurp
	LJRR3j4ynUZMjbFkb8+elKIqD7HmJWE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lfWAuTIs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015691;
	b=8Ejh2bc0TfMHWoe2Y8AASOgosrOBr3/4HantVE0CKwjt51qdhsSrvmfDsT3ziohubEk7Wd
	/+niksHoQjyp1GyrjPszL0kCqWkuaShZICY7ETha1lnUOy1uaE8PUtGt2KhHQ4DtKbFVkL
	pTYGxDPAn2a7wluD4hFCjpIUM5rd6fE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 048FF432BD;
	Wed, 18 Nov 2026 15:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 28D621F000C6;
	Wed, 18 Nov 2026 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015689;
	bh=WAGnVdZX/dnwB/YL80FuMYmEILyT33bR88HdQuYKvtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lfWAuTIs9elqBsJl8tmIxnEDN32PGAd9hMguq1CqjQ8o/RkfsPYnbLyaCQh0JpMyp
	 fCYFUcg47M+Cd8AFwuhSGC48F6Y5cgH6aM9nlI6/evJByLvuSbtNpi1JGxi7EIwUTJ
	 OBpe67ieUMV93jPV8zcm3tdhPX5s9eusutMgiqm6kM4wKqXDNMLFHJEMZuj5NeUXxH
	 ZIfPVbs2MPGv01KSLzRUChAtf5HJHH1+2P5aDyz3rsuVFgR1gig0jWqw45i+R2qnT3
	 bQzaR2mSDre2f3gEgsLPEbuxSQhiPc4duXWEbVzw1Q34ufIovz83232MT4K4OG8WBG
	 GN+02QKGIh6MQ==
Date: Wed, 18 Nov 2026 17:28:06 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>,
	alex@amutable.com
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av3EBpSuzn_TcrDk@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wdwc3b5edgtgvrgqfhlzhrachr5hrqb7ahipcuqdz5pffxlc5b@662cpwhxwjer>
X-Rspamd-Queue-Id: C4074100006
X-Rspam-User: 
X-Stat-Signature: s198yarczbeuya738g7upqoo96mfs8nd
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795015690-77866
X-HE-Meta: U2FsdGVkX1+G1BRNqentzDOHBzVl7DU4uudM5LpePMQjrp+yf2wXWzmdKd0sOluDdnibK1+M6BN48ykPbLNpKC9BmRTXePbvtenWNoPXMvGn3STXi+bUBc4pTZlbM8PEPCdNAFjW+BjWr8TbimsCdmoJwvRrgWzcmU4BUypgIfQzEo2JgUVANcIKuU+jfnuEH91b6iDqhMIDF8gaonbnnltQihPi5eF12LhzxzaCJwzX+6fn7z941A56aVYu0WKUohWSioNrNQ4Up5oSMbBMUr0jlUrswWv468si7L26GFZErtPOFIqVTZRRt7fPmEiNqfpvKfVI/pAA7VZKRfdsexNkU3UC0x1bTYFARN+atFbgFzg4SOO5fa5cjF3L0+NepbFn4/tIxlPb0KfoOLoQ5I1txKe1CsNlHD9eeO3WmPL/2rrH1dKCT1VUhtEiA7TwHqJpKA6GhDaVJf7MlmvYJv6yb66XTgZ0jKzOPv1xaTTTXZD87WMp6/F0x6b9Hfh60r83gSJaFJTrya7mHQ7SggELkg6n40VXTnZeHQs9hm0zJUY2ac3970VHncC7x1eVN7lN5tdQ+y46fpsUeqTfFYcyjvFH5XIIoNKC3w20GG8RawU1OzcmErKHFUqSjuC9m6y0NdiCZ1fPtzYagLKPBtppVtk82Xtn7SfCjFeFTaNmJpI0brkihoxaBWyiyvGPyXvQmzWZz+O1Sg2MJLGINJQGvmv82xlCLUMCLeVswS5K0T5WABAGhtfDtE4msQMiQBnV+4bqx6tIP5PZfnYdFS7uulgZ/z3Z7LSVXUBV83jYARQW9xkuEcVvrfe+7NmZFXxq12m9xgUb4rwzcS7SkM/HpSvY0jFONLpEdVMEaP6wodga6stajXhqAvfCxnwDQEMqLKnvBxn/V3IiRarJTqwzrHIwzTxqyzcwJnsQU/kihE2WjnZi5cZ/CacCICO6E4NCXiZeXp6aTWxcAx+
 M3BXesve
 /XdGprkI2yq/UPcLm3shuiYxctide0zvAqzF4BeKzgrtbSSyLefGF97oz1Ca3R9IUWhVshkhIUEFw7IYBm06Joz0XqKQvQTYJYa96Y6uZbE2woAryRC0cyZpButfyeOIMZVcv3KXyDG7ER0jhNXieBpI+75d5PsdPn+1mIAvscrzPAJg229ez3ubbwcqOREvJMtFJOgcwB0Sqj3ar/KqiopcGAPyFeM3+BP9VlYvo89wdeL9t1sExRnoYG0aNyBv+43Sdv/33WidWaskd8htX1QsKGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 02:47:34PM +0000, Josef Bacik wrote:
> On Wed, Nov 18, 2026 at 01:13:39AM +0200, Jarkko Sakkinen wrote:
> > OVERVIEW
> > ========
> > 
> > A root namespace (rootns) is a kernel object backed by a file descriptor
> > that binds together:
> > 
> > 1. A full or partial set of detached namespaces.
> > 2. A dedicated PID namespace for spawning processes into, signaling
> >    members, and polling or waiting on PID 1 exit.
> > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
> >    populated before going live, without inheriting host mount-tree
> >    ancestors.
> 
> This is what cells is doing https://lwn.net/Articles/1102593/, you may
> want to take a look at that work. Christian, Lennart, Alex, myself
> and others are working towards this in a more wholistic way. There's a
> lot more that goes into this outside of just the object itself. I've got
> my version deployed inside Anthropic for securing containers and I've
> tripped over a lot of pre-work that needs to come because we can tackle
> this. Alex has my rough outline for kuid64 for example, which is
> necessary for making sure we don't overlap UID's on the system and
> create holes this way. The cells work/anything that wants to have clear
> security boundaries is going to require that as a pre-requisite. If
> you'd like I can include you in our planning so we can get something
> that will solve all of our problems. Thanks,
> 
> Josef

No it's not doing the same, and this why I sent the patch set.

I don't see cells fighting with rootns and given that rootns has a small
surface and it leverages already battle-tested code, instead of
reinventing the wheel, it also has benefits. It neither doubles the
number of container frameworks in kernel.

What I'm not claiming is that this is better. I just wanted to fact
correct "this is what cells is doing". It is not true. It could be
better solution but still that statement is untrue.

Br, Jarkko

