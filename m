Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB0ECCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 09:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE53A8E0002; Sat, 27 Sep 2025 05:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E957F8E0001; Sat, 27 Sep 2025 05:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD20E8E0002; Sat, 27 Sep 2025 05:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3B218E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 05:30:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 476A414066E
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 09:30:12 +0000 (UTC)
X-FDA: 83934509064.10.921C6D0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B91640004
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 09:30:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IW1kfo9w
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758965410; a=rsa-sha256;
	cv=none;
	b=p/NYssAToACY6KYLVyER9v/u2fJdjOfVYzq9k/rOEO/FtPRtuBPeumAxPhCsNRex55GGSL
	aYsFbIaCeObcxR7llkrbdqIIs7n2HNWSruWzFuPUYYNVNk39JyFSm2ywV92d0GCEf1N4CG
	XmG2e4y+BUAtxjkQYgfOhFFfeNdtjZo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=IW1kfo9w;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758965410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s4jykuELibpNRJE1uEk+yB4rTfv/cTiclbrj20NPvpU=;
	b=MuxzH2Hma0JGekRVVhYiKXTtHqBeufzEu2JrtVfon9uGROJRyZDchSO2in0aqnT6+Ty8AJ
	2Enj4wy+/+v6klrFyAp3d+Nnc48pwG4WxlvuALSzP77MEjFJtWBrMwCa8mApqavb1EhtFP
	rxyrshg5nmRqwI36ZaLjwrnEBRJrvLw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=s4jykuELibpNRJE1uEk+yB4rTfv/cTiclbrj20NPvpU=; b=IW1kfo9wGHua1gLFS9y09rZrbC
	wd4BRzJqQiEhlOJ/Y88Uiu54w6Ki1yIdk8s+kTMJhVS70t9C9/w2V+9tWoFO42H8M38sksEE3lHgb
	eGtjn7YQNHduh7D8JIcLc6lEhhoT31xQ6bO4AptZD6ksLg/wjjoSMk8+nbXqHBqOObxr89WmPPCK5
	Y6jKNUnZffKcsFV86Skeee8bWqHYZtKrGjx4YTmU7RUlzfTVNzBoqyC3aSpte0Bx48YND0yaJIiZ+
	UEu8bWopoIlM6zcKKp2l5z0AT6r4FS5vMm0GoM/NOPVOsTc0fYq7t106twxltr7SUXgkj6NURIxBe
	ie03LZ3Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v2RFn-0000000FeRw-1uiP
	for linux-mm@kvack.org;
	Sat, 27 Sep 2025 09:30:07 +0000
Date: Sat, 27 Sep 2025 10:30:07 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-mm@kvack.org
Subject: Last call for Plumber's Memory Management track
Message-ID: <aNeun9iH5wENhtdw@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B91640004
X-Stat-Signature: ut17r6b9q1dyod9pqesb641b51ya6yd9
X-Rspam-User: 
X-HE-Tag: 1758965410-851682
X-HE-Meta: U2FsdGVkX1/BnmF5zcNjBAQhi6rUZiDd0aJOeh3uBTzeBdaLHzDNKAlqketbn+ZQUud+pF31n5IiUNC5OZnddzOyjVl2fMuvlHUkLtvsFFxmGlleYH/omzJhIXJQvKfFqGFreOCwuotSgzyVGr7mhD2P2R5WJuXosXb3m7y/pt5Y9NlUWL7lk8qbigStUc4JXbh0SAlEnHAXDEtyeqbaqjcC/wgHBgrssQji08h21pkAWUFvvJmNKNiUMpufscDjOruIcImn7PsLxW4nyZZznqZyhnXJt1Ghhb6hzerPMGRBigvQPXaCYcTkfwp1d7K87UXnALIU+/aSqPYAtdp6KU/ssiSAw+i6qzltMqpzsNV8fLGW0e25EQtRL3NwVa+EqiRZMAE1DXNwENSN0DTQEL54NTGEdbs+VzV5mC5ifL5XwfITB0tB5zgWVBIxTy1BOXVbBv0hVc0kho1r1YCm+e5dpGEBybcCb97Va+HwZFHgMviLFzQJaZvcFDLUvXUucUJA8M4/+eCgQ0lSALy0V8wirNFn8Wlg4o3KtVrPvwL0gddhCXVO/s0Y6kJl8XmyINnqAEZajujvvHdfP2f3wWoz4ug9lHCoCIefWdfy68VMu3JuPkbqW6R2pAAI5/ViXAWD1BN/RmO5gTKu7gFaLT+xvtIdVVpxymGUszRZzIB9NwIVBcbKBGH7SchhlxAuKril9n9usKWYOpysZDQff2R7Ef4y5bi0UtMl4kPuvVncKC4QZ228CUsStinbxCP/tvHWu8t1YyAedI4j8ITlUO2ae76fXi2uRZWz2WMvEpf5XNA4ac8Ya/CcVl2oHhJFmGA1Id39/5qNWWQHTylLrv/L6XWdpdfY9k86O5bVOZbG/oEzTALALFaA0J8sUsWA0LSzw/vxEVEoJmKJ8BNHydOH/Bjka6rnsOwiIOb+RDyh9N3RZCAWTcGOqObagAHwduaGsud+vOK4T3vkR08
 dXRNjZSI
 3xrPUG0yNI+8RoZvQWoMHSWVJHuvnVz9f4liePI3GI4rOegoOWV+cBNKKfmxvqij88fmBvJ9WyWf57zRZvPMowD+b8sfRVeDcKu7l/l5IDG0OJgh5JUNAqDhlTExsZDI30SnkxlMZDYf18sOmpB3bv8I/VJhCji+uIekwrr8Ok8dcwgdhiWMhZQtkj6mrqy/JPog37XVo/yll/Di9rdHLQI5rcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

David and I would like to remind you that the Kernel Memory Management
MC closes this week.  See the original announcement here:

https://lore.kernel.org/linux-mm/284f04e0-6555-4469-93b4-fdfc0dc7b91b@redhat.com/

We've got more submissions than slots, so please feel free to make
our jobs harder and submit more topics.  As a reminder, you get a 15
minute slot, so aim for 5 minutes to present your topic and 10 minutes
of discussion.

If your topic has been presented before, tell us what's new this time
and what progress has been made since last time.

Also, you must be present in the room!  That means you'll need
a ticket.  While all the publically available tickets have been
sold, speakers are given priority access to tickets which become
available.  Also, we have two free tickets which we can give to presenters
who would otherwise not be able to attend.

Thanks to all those who have submitted proposals already.

And don't make us quibble over "exactly what time on the 30th do
submissions close?" Just submit your proposal while your calendar says
"September 29".

