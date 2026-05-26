Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6C5CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C596B0088; Tue, 26 May 2026 12:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D2A6B0093; Tue, 26 May 2026 12:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8528C6B0095; Tue, 26 May 2026 12:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 705AE6B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:30:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BDA1A03C5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:30:41 +0000 (UTC)
X-FDA: 84810109482.24.7202314
Received: from relay.hostedemail.com (unirelay06 [10.200.18.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41FFF160014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:30:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779813039; a=rsa-sha256;
	cv=none;
	b=nJ+Hcg1jWqP3oHNGRspslhnQZSBMVxwHl014I54L4a6VnAOzefo6LJ4CBpnz01Zn9E8XLK
	kXTorAtzXX77iKyweTAEeYedjLc3hKdFIwWv3itRrb1p62L43ExkojnTGF60IKOeLMsV3d
	0dgmb0gn537fh6uLGj9FawPq7YLnVHA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779813039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XeJlG9YOS9M5trkgW/cH/bKJfaBNasP6x8pJxGH2VzE=;
	b=y/XeE+dnRy1Xi0o9tnQ5AgSctJJtMyK39nGJhTPIwGKfdvXa9TrQNPJLKY/jWbaTDHasB0
	uLfLN9EUzlT7jdvRhrIboPiU50bMMsaDt1Od7tVuy0hHhWPLe12hp6+RJ0HBgFYOgX2P38
	zRCvAkPN+JHKuVy0owStbN8ADa3+xu8=
Received: from omf05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C20E31C033A;
	Tue, 26 May 2026 16:30:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 5CC3320010;
	Tue, 26 May 2026 16:30:31 +0000 (UTC)
Date: Tue, 26 May 2026 12:31:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Christian Brauner <brauner@kernel.org>, Kees
 Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, willy@infradead.org,
 mathieu.desnoyers@efficios.com, Linus Torvalds
 <torvalds@linux-foundation.org>, akpm@linux-foundation.org, Yafang Shao
 <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
 Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
 kernel-dev@igalia.com, linux-mm@kvack.org, linux-api@vger.kernel.org,
 Bhupesh <bhupesh@igalia.com>
Subject: Re: [PATCH v2 4/6] sched: Extend task command name to 64 bytes
Message-ID: <20260526123103.4facbaed@gandalf.local.home>
In-Reply-To: <20260525114241.4b6f3050@pumpkin>
References: <20260524-tonyk-long_name-v2-0-332f6bd041c4@igalia.com>
	<20260524-tonyk-long_name-v2-4-332f6bd041c4@igalia.com>
	<20260525114107.7fa5b4c1@pumpkin>
	<20260525114241.4b6f3050@pumpkin>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+SfqA0tIqUxOUmzDMPGsY2Bynwi9HM1FA=
X-HE-Meta: U2FsdGVkX19+DgaPTwc4z7iRVXUSZOqrVEfAtGYSvV7OnTDacZ1Hw/MUPKcmm575Hv6x6ldX6k779vnxNpGWZI83exoqPnaDvD3uiHdZGrm7O5Kn8tyfMud8UFNzBiy7OmfhPALhmcYjVcad5UeM/aK2bFkxfct7yhyONa0bUJwJQYnXpiEhTGrDK4+ottHoOwIGmxDD9djJ4vguO4i/d9n6iTmTLNIPSiyaJZcjqepQIJDHLt8k5S3jRqxtjKvWU+LHRBTYm/VmDYxSfyjZj3V/j8+bRbPwmMHzhEo8tM5IGa6nnWPigAFfptTCc/yad9e10ugVvl7w7SVjyWGNoeMVvvQ9cdK+
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41FFF160014
X-Stat-Signature: e9zwjq4hs9mt6bbxt8t9g3cmi9ag6k5g
X-HE-Tag-Orig: 1779813031-406674
X-HE-Tag: 1779813039-70524
X-HE-Meta: U2FsdGVkX184UeM3m/qi4sD/xN4xzzX8U8Cbw3dEUqiIj/WUvPnk1U70Jtb/pQheY9RA5YdFt8tlK98wQb0gkXMcWsf4ej9o/bnJL6poMM3X+3loY6oDuDsPzuJZa8L/cSQBggDYw3LiqvtGdFFXMCNGLtDOwfp6sQuc2/SjumzfzJrumU7Tp+0zwHX325XTpa4mv5PoJdjprgbSRx1fKYQhYpCfGEiVcoH5JfnwVngyz21oASO6D5mwvd/zNRIyI6eldGs/H91YAjpiG5qvGy3MpXqfH9M3MHRDmCtNI/wM7jlM85UBMSl8OEdaXaH1GKGq245Bhu9uTLVcwi4R5Qs3SQmnnfZ31j/ORAZGlKuqEr63U2oK7ThPvBRAOWH6/JVowZmlsNUvUzoNQgvG0kUOSaLGDFIiflMW2McaGjV4yhy6N4VOFNDkjwlQ5XN/QCVUXuef7HDuFUvl/MiZ4ubg1OHnM0ct7oxA05F0ESNB5v4phy0n8bFswiYGN2tlgz8uocEcKLUtRrMExmZoJSbN+SoBjQAkykJwmRIL/+v7kkzvPNwB+SPIkHdCwMKCMw+Ii1Om4FLghVt8ciJ/VyQSym1v/pdb1pswG4ofm1rDP5++GRq+QqCZVDnO/Rq8Vdi5Kt+WkYe1j4+HSSbvzckexJBfwQkmXZQpdn1LvI76UWRrrRr5YLAQo1E6VdRhw1/ecpKYtLDR7zo+NIgOAaHbUtXrprhase+TmagVhFXHyfcwdRhiP5X+scBTI7ncGgAf7UCSdXwTC+7v7L/6r/6DtpsJSRdAQK5EOt88wdDWCB6MqL6hW0/hUpS3bOP6uOhYuyFJgpNPzR0uAOntJQkV4+wxecWurzu17XIBAxy7G2b7fCLX5o7cp8xfgV90GP3Ho8dUsFHYQ4IulmRFp/3UtyuMcja2rJaXANI4EejDPNdsHJ+sz2hKKlTMjHfrt/QkEQJJB3rWh9EOS0r
 SRAIAYrX
 2rRvx6TthnAPRG3IQyR93eERysQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 11:42:41 +0100
David Laight <david.laight.linux@gmail.com> wrote:

> > >  	error = security_task_prctl(option, arg2, arg3, arg4, arg5);
> > > @@ -2601,16 +2601,16 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
> > >  			error = -EINVAL;
> > >  		break;
> > >  	case PR_SET_NAME:
> > > -		comm[sizeof(me->comm) - 1] = 0;
> > > +		comm[TASK_COMM_LEN - 1] = 0;
> > >  		if (strncpy_from_user(comm, (char __user *)arg2,
> > > -				      sizeof(me->comm) - 1) < 0)
> > > +				      TASK_COMM_LEN - 1) < 0)    
> > 
> > Nak - you can't do that.
> > You are reading data that the application doesn't expect you to read.  
> 
> Or have I got confused over the names...

You may have gotten confused by names, as sizeof(me->comm) is the same as
TASK_COMM_LEN. Basically, the above doesn't change anything.

-- Steve

