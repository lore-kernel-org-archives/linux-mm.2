Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57893CAC592
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 02:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8C88E0003; Tue, 16 Sep 2025 22:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668918E0001; Tue, 16 Sep 2025 22:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E528E0003; Tue, 16 Sep 2025 22:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4735D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:16:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0CB486450
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:16:49 +0000 (UTC)
X-FDA: 83897128938.18.1C058E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DD82C0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 02:16:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u5BIwCmk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758075408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaVEMS+KznVxr3BopWbagZcv0apUfF0YHHQ2xANPjC8=;
	b=ulrDoNQH/TOMZyMgC5B2s2jRazw+CrBiJxqfuMlA5g0+gC26d4njCqaSz84wPdnL7LZSt2
	LSXdEiublL2dgf6euvvAKggNKFSry8Iy5USjSpmRHXMEErN2KzYxCpKsD6fe3ghQOnSfn+
	G9jMOAnTDOFdq/k5zKLAEvcJYuZ45cU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u5BIwCmk;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758075408; a=rsa-sha256;
	cv=none;
	b=79+O1bU03hm5y2/0Y286Y3hmWTqdxbt2ZgQTaCxBMjTQaCjOmKr5VpWvwYJisgPax1mP9w
	oo4JenovNJQEsAiAjs52QDNqXp7mE+K9vGvdIu+zuxFgx6rTQh2KV+3eZillnA5ezefxIs
	gwtO9N+OAPz5txKas54Mb1gXASzoAqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A8FA60285;
	Wed, 17 Sep 2025 02:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84ACC4CEFB;
	Wed, 17 Sep 2025 02:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758075406;
	bh=Y7E9FgWFmiluyPV1OTAKxPaUN0ogdOZyX5+tdyu3XVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u5BIwCmk8zcWTJgkEDHluvpFKUJ+aQvEoMt5i7SU0M0JsqTjpt2DrYWLAnJKdQH6Z
	 7dP4yqdgfiai+hLAEJW9o2X9KCuqnM3sRjwqylWH6wHaT1WnL3QPARHGYvjYGMeV2H
	 7yZBaedhoZWKOqr6xIHnVhSligT+feIMD27ILX+s=
Date: Tue, 16 Sep 2025 19:16:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kalesh Singh <kaleshsingh@google.com>, minchan@kernel.org,
 david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 pfalcato@suse.de, kernel-team@android.com, android-mm@google.com, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan
 Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-Id: <20250916191645.15aae276992acafe7f7e723e@linux-foundation.org>
In-Reply-To: <aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
	<aa95777a-8012-4d08-abcf-7175f9e2691c@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0DD82C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: uexp5x885t8ze6qqq51bxwa38t395jpa
X-HE-Tag: 1758075407-218835
X-HE-Meta: U2FsdGVkX191AP5ZhEcMOMTqMWo6f1UEvZhSaywjQbNytwrs7iKc9/1pDeQMrKu+W+Mdl3BfAofnyPasUADFLtYhTWKbjxve5SyI+2i2nWqnj1eih7xjQLpQ8MZti68T4nQHlvkd8aKYSdpphdf96co02ZnviZdkJyLhx7ftNuTiXF572Iv6f/qdk+LQ1GKnZyIGq88ISdV51Xl25s0vlsERnzc/jbQAP0NE84J+HyoT1JoxqI/kautAnoeGuQ+uxn0Qn2yDlIXUItDFc/xqGPL4Qqho9QLP630f8A3SguSq3XHO/6eKSIiZbrEHWVq6Q6BhbUxr+q9gBPbS9iU/V6ePVyPtjPIMZaeRmZ1KzDAl5Xrnlx+EYcRN8MxIRf7nTcY2hYO6MPYNVrV06dJbwWb07a9uxKZVHnEO1z2XTdBtS0zJEdTLytSLXBYaR304/noRuaaOAf8iZdc2m20w8gBZ1rFLui/ILcVLVRUm/LaHMHn/OYzJocgtekKrrzd9dUkwu6Eo4Kt8WHYjo09Ep9TG/8Q4O+iRw644SCZMPKfX6TWKY6gFD4ul82EJZCDkbRhznn3GYGUV5HGcaIHnanx1mNq2gk9cakRr+BQaYl3St5LeNkkmvvM4E1sWPvIKFycShwEwgZowcQvdBbL+liug6YU2ZibrlN5gCd6xYUKy593EbxLVGQyEAuhqiDdAx2OP//BEnTEh++TbLwN4dE0+9GSJdLdwUD8LD5NlpnmXQ77domiImLDmKp6Af1UjFM9Auc4ytZ+OJVR9tjM369/OzRYG7WWP36Ba36xm6W8zhhOdeQS+h3DjFqRUvxYlqjrY48koHexdwFjLva72Anco716SCqrAyr73l/4aQWQJXORAwQde7Q0WxQPsGO9AU2bxIufxkF5EJ9MGjBkdI6Lex8jtRnVBQgq/uA2IWx04wAVRuHZHABb9Fl7B7MyUnvun28jZ6B6f0kLtaTF
 ES4SGTwY
 2yJL90mdOMFhzc8ULZ3xzr78t0T/3MEpHIONrQhTiH50IBZBvlTJR70QXaf6+sTfd1Djm3lRJQGUPDoVV2UMFrkqAUlAkSHiOV0MScsIpDCMGyZPlx697+89Gfhrblsjdz8OM7kDuG7QnppQ/yV7/AKlJxXQKSE6C1IHHF6pHZ6oIPr/7ljsR485ajZB+UVyHJwvrMKLcKVNdEmLOAhB84D9o2eD+bikq2H+V+w7wWR7gr/ZgqWyZ/RmwyYoMwTI4bZjRna/laAcdqpA2WXyjzMImhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 11:12:03 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Mon, Sep 15, 2025 at 03:34:01PM -0700, Andrew Morton wrote:
> > Anyhow, this -rc cycle has been quite the firehose in MM and I'm
> > feeling a need to slow things down for additional stabilization and so
> > people hopefully get additional bandwidth to digest the material we've
> > added this far.  So I think I'll just cherrypick [1/7] for now.  A
> > great flood of positive review activity would probably make me revisit
> > that ;)
> >
> 
> Kalesh - I do intend to look at this series when I have a chance. My review
> workload has been insane so it's hard to keep up at the moment.
> 
> Andrew - This cycle has been crazy, speaking from point of view of somebody
> doing a lot of review, it's been very very exhausting from this side too,
> and this kind of work can feel a little... thankless... sometimes :)

I hear you.  I'm shedding most everything now, to give us a couple of
weeks to digest.

> I feel like we maybe need a way to ask people to slow down, sometimes at
> least.

Yup, I'm sending submitters private emails explaining the situation.

Maybe they should be public emails, I find it a hard call.

> Perhaps being less accepting of patches during merge window is one aspect,
> as the merge window leading up to this cycle was almost the same review
> load as when the cycle started.

I'm having trouble understanding what you said here?

> Anyway, TL;DR: I think we need to be mindful of reviewer sanity as a factor
> in all this too :)
> 
> (I am spekaing at Kernel Recipes then going on a very-badly-needed 2.5 week
> vacataion afterwards over the merge window so I hope to stave off burnout
> that way. Be good if I could keep mails upon return to 3 digits, but I have
> my doubts :P)

I'd blow that in three days ;)

