Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8960606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gDlFrTOj
Received: by kanga.kvack.org (Postfix)
	id 696766B05B0; Thu, 26 Nov 2026 21:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647B76B05B1; Thu, 26 Nov 2026 21:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D666B05B2; Thu, 26 Nov 2026 21:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3523F6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:51:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96840A74FD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:51:55 +0000 (UTC)
X-FDA: 85479374190.28.1528979
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DBA21C0005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:51:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gDlFrTOj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795747913;
	b=WCPjFXufkrvmv8N7+pKWUeOtEZU03Hjvm6QB+GPTAjAj2+91JSC2yaCwUx34S68lP8vW1M
	xO0hhZjCqbTAS/nLOh+yuX/Xw92qSDrVY+xfb2xhTLv6SgrMcoUNA7nWkmA9hF5b8zPCLa
	U99DYDWFOSqv7xFLVc3tOg8D+4lTm14=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795747913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3GFXWam4TmIQpT0XlDq+Sl01DF1V8kTIQ3JQPb/fqk=;
	b=lKKgpl/2UmctY3ZjRPJ7xf8mbhIj8gHRi8S1prXZp1n059N8GCENvEPLJgZ8QPLUDB3/lC
	K2b/HZi9uAD5q6YiMoYVa1L/rKLusAJcSPpx2ffEtq1VN5DJvnDmnQKsF3v8+KOqMK02Nm
	D/ccbb9gyI2zjLMMwJikghHiN5DCHi8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gDlFrTOj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n/yaE/5u3zb3VjPb/KsOiyC4y5M5RXSQDqpebthex+s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795747911; v=1; x=1796352711;
 b=gDlFrTOjSgBaGde5t6VzQd1WSF71FYfQITuNJh80zcuQVhmY0BUa1uzonkW7yOs7jj/hoCRR
 RMvNWXHEHthv8/N30p0l8fUZ+uHBxTiMMHKXnAnMnlVuTrwYwCQlGMsyYhz1PZBl3q01daFTk/v
 Nh3kSwvGjWLc1LVwahZzUBYc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f83eb12f5863e0f1;
	Fri, 27 Nov 2026 02:51:51 +0000
X-Mizu-Trace-ID: f83eb12f5863e0f1
X-Migadu-Flow: FLOW_OUT
Message-ID: <bdb0ea5a-97f3-4a46-a541-ef01c062d6c5@linux.dev>
Date: Fri, 27 Nov 2026 10:51:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/27] Docs/mm/damon/design: update for report system
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-10-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-10-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DBA21C0005
X-Stat-Signature: hh7oauuwxfoans9pf3wzf36cn7j84rfz
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795747913-323792
X-HE-Meta: U2FsdGVkX1+owmNpd5tizlSoyWASE7yi1Orw+/yD8C98Iv7tXp7S5kTvLHJT0hIaco8bxUTmPxZ6sEGXfAUWlEW4iqsiRfdfDKRSvmeyxJHKRdNpqbhP3m8xy2d8YBh5bgTO9zssw/c/U+56IS+pJHAhiLQOJHCEuiEdA/GVkqNZCIfQ3BtSE4BsDL7achwdntdnuRDkebJBgdJrKWsV4w/CAn+aNA04c5GXzehpqWyKbxUNLNMAMkJ20VfBfySBgfR081O1MgAKOvqtBRwEcU8L1TF+5J9kSYAUN7cuMgpe14ZgD0igz8K1vAWyEui/ZAkRh+9lUzYkX7MMISDAWtXlnRYOT5ARmhNA00fslM8RSjedjjAMgpQQzKAjw61ja860JMBorkeErVh2vftfeljfjQuBV5X3nrGJagvF/lKP2KQWUO4RK0llVlTuIGTfzYTANnaeN7/FrurhAHQG7fYNYl7CAiUVdZ7TuPtKD5aTTvKQXwFNzYkS3VnN4HA7GTqE94WNv/BZqXE+rEp6JPBcQ8aEgJT9m4oJQBONhdJLO/PwDbrxLxUil9XR3fOXyA+pgsoHrLYE6Er592gwknAR//LoPeH8jjpzCsCHANxFbJCnZoWq9mIc0xE7Gwc+hPg5VhOrr9Wzyhrtox2Yk1aYsxhi6oi2mALwhu8j9hCocuyt9SMG0r71Bkh99Y+IV3C+aZ8avS0QEbU7QY6fAbRwfbP7etOvl+IwhPebzM7q+FOG/tDYfZK0o/DS7OM5QlgRcJIbWkfv61OeDxJEQkBVvhk/8GAllyGZ66R4UljN3Mic3vnk1rS0nIDQpZjRppOKCH+xNiaa3sLUdLwpOdu3icTPmkPr7+3ACGVvxY84B3cioqTI9QBMy1NjV+ZgOJDjvQe5HEmOKm0Of4Xm7Pra6rowbIG2spHUPWxEOO9UUF2hdlwjBzxFH70ZqSD+DteA7Dj2ad5J8ZNLkzZ
 5xFtA5jr
 9OA6jvk1+mvBzdfu07Idr2pnXvJvAFfD73XvV+9Db48jsYOv//HLXOP52yuzksRX+WGoGIHMmo/X9kMxAPWF6IoXQmr+o1rC7FZ/wE+RcOdZaWcHwojcmfdpMpqeeBEM1mDZg5gOPsOXeqM8XwSabN117w+Z0bQ5jKAYm0q+6/c4hZXJx67sj3J3M2ejLYp3oMxDf55zJ8Ranr7qN2wmFY6MA9uJWDev8RzuVzt4xs8g6xAPZdrEeIwGz1FVPVHa4gbaMWnK69k4fDbiMdwLuXM6xWZKSRQCLnZRdjK29htfCc00KEa0M/Ok2HHbRK83KgY/qUcSnso/a/HspxMyBWS1B1ORcaknExx09Gp2uHQ/PpQbAjWpuiLJJpPimJO6GAxAfV6lzjQq3CkSqkQz8Hsp097XAFeo9BeiNnfgWr6Gm2cLAoFKijGlBq1SrgL4J5UZcwX9YacnGme4STeToiXH6WP83TegNcUY1msxMRKOBA8UVBpzawEH+vQ2sG1Esw0P6SUCyUlcuuic768Lr4vYV/2o1MCV6f63mK4n+bhdHhVLrzU9ZB8l1V8kdYvbnEeIQpiDLwY1cFXHfy3RCtMPYEXmwEBLyCTGo89IZ++9T/LKePt7yL5GsdIj8HysYEX5vJqmvNC/p1muJF3bdAHWLlv/gAJtcr0k+YD7zRRdczyJ/oTKmqJ2NiLaPWiG9HlGYubMtyZqAifA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Update DAMON design for the data attribute report system.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

