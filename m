Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13292D2ED08
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1043A6B0005; Wed,  1 Apr 2026 09:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB796B0088; Wed,  1 Apr 2026 09:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018456B0089; Wed,  1 Apr 2026 09:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E43816B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:33:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB2071B8B13
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:33:00 +0000 (UTC)
X-FDA: 84610077720.18.E1090F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7059A100019
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:32:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jA7Ycd91;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775050378; a=rsa-sha256;
	cv=none;
	b=ZLArKtGH6HQt/PgTWRXaxJr4VeHkO999xgnMyM8KUUqnF/ud/7rg8pp4iOlv4fauY3yZd/
	ejIkbyHEtHKdffLaLvJws9gilNyt4+CYPjh38VOPg/Ih+NUFfeHp+mCEsP43xaojgMCyVv
	qACmMhHKh5I/j8ChEJbfNOa6WRiONCI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jA7Ycd91;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775050378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eod5Dm6xkRNC6hJL1r+h+vVL6U6P37BniZZLgne8chs=;
	b=iAewow0Iw1wcOhJmLBG3Ki1LQU7tqh3eRg73f1KAtEmS5fys9dbzRye+QN+R+kLrl5tYAA
	0tD3V2mcYv3kOC6zPi66dnTeVvH8POKc2/t2GSIrtDK8YZ0ngRTs9sv6Xfe6cRo2Oird+s
	xMvRE13B3L1L/o39++UP2atJMJKpryI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775050377;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Eod5Dm6xkRNC6hJL1r+h+vVL6U6P37BniZZLgne8chs=;
	b=jA7Ycd91Z6xl5zzLn3boYGtASaoMGa4MSLD2j+VQ15I3PK00MXuvn3V5Kw3bnXpERTBcu+
	wPk1KBw3xoWfM1rL7b4obWtZ3LFhoJSVVeRztQvb39FngbbJhiI3CronUDytlJ9TrNAj5e
	B/4M7ZC4wQ2z2qFEePmB/LbyT2xjJAw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-D9Cs-343OMeKmLLb3mjglA-1; Wed,
 01 Apr 2026 09:32:52 -0400
X-MC-Unique: D9Cs-343OMeKmLLb3mjglA-1
X-Mimecast-MFC-AGG-ID: D9Cs-343OMeKmLLb3mjglA_1775050366
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FBB118002CD;
	Wed,  1 Apr 2026 13:32:45 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.80])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6511C19560AB;
	Wed,  1 Apr 2026 13:32:34 +0000 (UTC)
Date: Wed, 1 Apr 2026 21:32:30 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <ac0ebqaDxWWAYitu@gmail.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
 <acuijiUs81Z7qYSL@gmail.com>
 <20260331120902.4612d93efb89f71a0d79bb5b@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260331120902.4612d93efb89f71a0d79bb5b@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: baYe2amJ-U9NuiiKPtkwohdTN5M4jK9L9NL9ZIXw4Sc_1775050366
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 7059A100019
X-Stat-Signature: 6i7b85447qz3j4b38164ou9h377ib7if
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775050378-246947
X-HE-Meta: U2FsdGVkX18Husn7FS5pVF4sKZNoYDHU0+jtU0/dmf/7L9eK0nwdrRJpmW/NPafC2XaSsEV7hJFyYmHbgblNUT64b5DhJNZBK/ckYIrp8LBVCVpQJZGmZTrriihvmdoipTGdUr0fH/4O5EtJDzY2CwDzhb9HMyQClJECDwYVC4wahpVez0rkbLSM2xJ69I4fYsS2ieQjt+SH7P8BPDh9+rUhp7qsIf63Z1Mej7Z5/Fq1kvOHG0EWjGz7u1alA5GlVD0K+6/AfzikyqR2oSU8TDxVQ+D6OTgjZVFBJEerLH9WRcjcucy6+BPZ1sEdtswRQ1rGvqrGSyLHSWOIbbpYZN1bE7SOvCrd3UGo15GGwTU/jU1gdeUsR4GkIgEX/NXOhcwZH8oOy07oj8d/wky9rtIQ7PKBGbCeTOPHLBfUv1e2EM0KPBPbAl7a/DPlNdacO7lZbKteRs/bVrwNob/NLE0G7EUlOte8Lmi6ox+J8SwDmeOMJFVDUqkgFuNzYpHFqA7wRlRnam17gfflRtVWBBN0hGM7d5+QlVFFSEvX8PWdbAloDj2GOcJfaaVl6bULvcMIScjGtk6JccGBkrTM+Qi2yQ6C88Sn1q8bxpDLxNuw8plWg87o2Kf9cfkpDHDzQ4STY/I+YLHymI+RUeLPvJufmYHX6gV4lkLR2t7krXPJFBhobVieS6QQ0GUR/h1N/pn03r4TkN5r9bGncgbv0ZPeLZV5vmDMMi2owMVFh01ODg1u/7mdTNrX2EZx9QI2D5fLPTV3Sn5pQXDCHUnmWryr6v5s96z2nSwEdUjMTz4feAALZD3c/WW+cr17/SnRKBSwf+Atv4BrUe6LktDCS0xWwr9Wpx8GHNtawLXTBKtUslT++xl2GoJxJCrwG38RXoXUGz4lrve0kFNEUjVPj9uBqMLEA5j5t//JOq6PACaL2mC9pLOoBLziLjZR7xIAyE7Hl95XBjZ5amnt2OL
 fbsUqUdu
 hw4q7a9eZZTZ60ed2Rygq7wPkVtohrCIZgEfAqRBmQSS2fnlsQvKamRlcyOrPy1szSdnqDzGeXkbo0UVBhpAp1pamaj1feaT3s1wm8WfOLA7gCvZZ1BG9c8GgbsqmeV5bKRuOUwgxY7cQiBfkD4fNDms/jQsA06/vhOMQp4B3kBDnaZsdlcmAUk/njDUq+EDMJ1fQ6u1fAOakmVjcw93EjjX/PZ1mf1D0wFujK7iY/OQrZQcXDmloH0jDxMDXX8jJdwkVQ4txVCdzy6BFvGGYxZZFDAeZrNh99SblXY2/5ozSJWflKSM9OUxbDk7H5/9ijWNJhbEEvpRXVxyNlexiAQg2OQkuj+ZUJUG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 12:09:02PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 18:31:42 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> 
> > > -	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
> > > +	va_list args;
> > > +	char *buf = NULL;
> > > +	int saved_errno = errno;
> > > +
> > > +	va_start(args, msg);
> > > +	if (vasprintf(&buf, msg, args) == -1) {
> > 
> > kernel test robot reported compile error on this, as the vasprintf
> > required _GNU_SOURCE. Looks like it's not appropriate to be used
> > in the common header. Looks like it can be replaced with a buf and
> > vsnprintf instead.
> 
> I like vasprintf()!
> 
> "#define _GNU_SOURCE" occurs 402 times in selftests/, so perhaps we can
> find a way to keep it?
> 
> (err, *why* 402 times?  Can't it be just once?)
> 

_GNU_SOURCE is a feature macro, may silently cause troubles if defined
globally and it's recommended to be used explicitly and maybe that's why
we have so many definitions in c files.  It's usually requireed to be
defined on the top of the include file list of c file. So although we
can see kselftest_harness.h defined _GNU_SOURCE, but still can see some
many (80+) c files define _GNU_SOURCE on the top and include
"kselftest_harness.h" at same file in the bottom of the include files list.

So the side efffect of using the vasprintf in kselftest.h is user need
to take care of _GNU_SOURCE definition because a header requries that...
and the header may change something silently because of the _GNU_SOURCE.

And a weird thing is _GNU_SOURCE is not defined, but the compile of
the selftests calling the ksft_exit_fail_perror(vasprintf) succeed by
accident, maybe man page need update or something I missed.

As Mark and Thomas mentioned, the root cause is not this macro's lack
of definition, it's when '-nostdlib' is specified in the compile flag,
the nolibc lib don't have the fallback implement.

So it may be not appropriate to use it in the kselftest.h. And
considering if we use a buf[], the size is limited and the message
could be truncated, still not ideal.


