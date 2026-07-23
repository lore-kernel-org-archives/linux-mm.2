Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B711C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 18:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11BE16B007B; Thu, 23 Jul 2026 14:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CCE56B0088; Thu, 23 Jul 2026 14:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFEA6B008A; Thu, 23 Jul 2026 14:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFE8C6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:21:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 337EC16014F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:21:21 +0000 (UTC)
X-FDA: 85020858762.24.011C8BB
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7D7904000E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:21:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=xFbhv7mg;
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784830879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfQDPqw11mCJJji2f0Nti4HsEvZmmxB/+DvabiWGe4o=;
	b=N8Xi2eFcZAyWeEuloYvD+gbPM9SerhjVx2DE9qQXS0WW6AZW1mfFHqm04cY50vwoJGk/SS
	T6PuuOgTqMWzK7RZ5jhnmlS5ssFqlR8qGiA5UG1ZNMWI4W8aqQvhRvxcCO9ApIbe2gT0AO
	1yM5dxla9KIpeUCkoCZHzG0kl1tvbRM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784830879;
	b=aD6GrDfNV1OoFASVuvb8/Yi9tmCNlMlTmR3BC5vK4e9zN76uUOEVkfS7E5Cpv8KTZMKmml
	wa1+o8kSjvMJc3Z47PWe8egPgxcApfPimsfdLVfcP3FPgeib9dVn50PuV2vQPKFp2t6v4z
	89VTm9l2U+UuxUqPI4dB3W5EK9b4MSM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=xFbhv7mg;
	spf=pass (imf11.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1784830836; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=DhTCt/0+nbXkNrT16r/mYqwaIRGTbMZ2tJRdYDK5WwZpUIEEeJfZUR1W8jfmfNoMMYsi5G+xb0qoVG87YDr13cjS99F4mDYQEDHrcj7JVaJOKxPRHHOnG3J7xdlvZpsL9SCgT0rbN8ZCgY7x4hsBF62uyMsPvu+G5eB20yYGS7U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784830836; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=pfQDPqw11mCJJji2f0Nti4HsEvZmmxB/+DvabiWGe4o=; 
	b=bPYqK4TEtuGlf1Iv7tE1PiEybXOUGlCAEw7gRZ/ZLlxLhPVmtiOrDRuoEOxPP4lQNBxSRmmQ8+yQwkLR5WXBe6zAqgWajaQ7EZK3lPTbbFChZ1e8Sd0megUTWMr/Bh86mPSic74axVVNcWs3QEzfwEx3bu7jKTRange6P9Ey/EQ=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784830836;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=pfQDPqw11mCJJji2f0Nti4HsEvZmmxB/+DvabiWGe4o=;
	b=xFbhv7mgSE7zUFuoNZQrs81/lHXApMTmweZPcKCYwIOBAXqXUm6t+CFpPOy/2oco
	OQM8TDoLXmcxXoWM71ua/6HiyPvdT2BsNPin5Zh+xtkyM9VEOLNNBO3qzIYpGriqC93
	o2iv/A/Flgm2LP5+bHEg0TmCDbDQ+4QqI2T6x4vc=
Received: from mail.zoho.in by mx.zoho.in
	with SMTP id 1784830836074875.803576409499; Thu, 23 Jul 2026 23:50:36 +0530 (IST)
Received: from  [14.139.128.54] by mail.zoho.in
	with HTTP;Thu, 23 Jul 2026 23:50:36 +0530 (IST)
Date: Thu, 23 Jul 2026 23:50:36 +0530
From: Aditya Sharma <adi.sharma@zohomail.in>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Mike Rapoport" <rppt@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>,
	"Michal Hocko" <mhocko@suse.com>,
	"David Rientjes" <rientjes@google.com>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	"Steven Rostedt" <rostedt@goodmis.org>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"Kees Cook" <kees@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
	"Peter Zijlstra" <peterz@infradead.org>,
	"Juri Lelli" <juri.lelli@redhat.com>,
	"Vincent Guittot" <vincent.guittot@linaro.org>,
	"Dietmar Eggemann" <dietmar.eggemann@arm.com>,
	"Ben Segall" <bsegall@google.com>, "Mel Gorman" <mgorman@suse.de>,
	"Valentin Schneider" <vschneid@redhat.com>,
	"K Prateek Nayak" <kprateek.nayak@amd.com>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"imbrenda" <imbrenda@linux.ibm.com>
Message-ID: <19f90353d61.105539924624.2933593927158737842@zohomail.in>
In-Reply-To: <d6c3eba3-c596-4903-b298-ac6f424d639c@kernel.org>
References: <20260719185409.409685-1-adi.sharma@zohomail.in> <d1180a70-f4b4-4c22-9ce5-881cb0e2370d@kernel.org> <19f80cb1ed8.13fd666243425.2308143427066829733@zohomail.in> <d6c3eba3-c596-4903-b298-ac6f424d639c@kernel.org>
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large
 exiting processes to a kthread
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: haczazoubin5ru9r7xigizr4c4411scj
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D7904000E
X-HE-Tag: 1784830878-57210
X-HE-Meta: U2FsdGVkX1/lAgNiNL62q81ZpxmjupSTwe640Cogdbhil0I/XdGRH0peenKyzjbNgRAJocYRiqDWRGdHetePqLc4ZmhHJ9j/RWGTKnItF4gYjOASKso2WKJU0hQN74/5rxogfDOsRS3He+loLUjPGQEXjs7AqRmSF49opkQep5y2WhJNaA7TxAClxUT3WWNo6eYnjh5gyz3GVhJWJvV8dBWymJv0apv7jxMd8NYiDIaAnwBz1tLFmVVSiU0rR4rfFNfFIUg6TlNnhlqiJcTr+yyDwdjFsvP53Qnnd0YZkDhM1dOODBZgMAjmVQ541Gbz5YJKryfw7D+OYwtb2Lvqsbm9NL4oIuPisY/jHchWU2+lXge6y70aTLPv0eS3yRTXoWv0ZFXe4Sey5oLizGPPNU5+JVJkVBA5P+InqgfBHUtayrvsslNLXs4LC3uHzveL5nft3jPV54mCUvnklYKvGHZ5N8eI1ytczo16g+AMul514UrnqSM1WI/tSpDxcPB5zrPvHUAt/zgxVVGd4F48bLdorsu+ZbmdUWOD9KFfUTl+HKwm3her/YcNyz1FACllGxTGIedgmqIkfMXxkiYbDJdGqSmFfNSbQu05D2Iif0YW2dy61OzCnvsGuKD68CsHELjaVmj3uwFalZWn4JVmOYGvo+W/mjMfUOJVCsrb1RJyGCQjr8Q4korQVwjMoBbBuQ4u0A3oQxKJEhu47hyBRtzSt0NyzhqhhzMCqjjQfDYPiram4KDpmiKbZ4CnQmFa9/OWT9qSWXzaKJok8wsa6wcwxdRg6nUU7uFpspJIXTkhYq2wMBME3P+D980ZFRYGvkkZEoGf1LtSXP76tv59sjVVtS23q+KoAgG9K3zrUlkglNbefPEgYI0u/iIeM1Zx+o9xgA3/dCzLxxVajReo1YtL6lO7nW1K7n7KUo9Evy+YjPvnpcefekXHQa8B8F6qrEHJx0YvYkkYsNkYsVH
 SiBLy9EB
 RXQDPIT1B/Lub75mWDpdP+uLYgx5LIfZDZYP1y4EhuMQIPRK9o72990qNunCFrwOWpHk6TGnJ/wpJqQqt4deJzT0Eaefz3BenjcYcqErdJQJsJBRiH4J5fMuKt7+eXeKe2B//GL70UimirHYu2XlcSKSJrUxhsXsvvlgGd8US6sWUQ4Mo+bCH8sUP3zgcZwG/Wc6vK5u8KUQSzuH9kLzpX666Czn1BQSa4WsSSZHunr/38huetlj1Z3wLzuikiRx7lLX8XMGJ9a28kZ8lbblpsFI9KGRVeeFlMcdxeJWzQebXYyfbhLy0BSK4O0CnqFa3cdH5v/kTc1lGNVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




 > CLONE_VM seems to work for the use cases you had in mind.
 > 
 > There would have to be a *pretty* convincing story why we would want more
 > complexity in the kernel to handle this.
 > 
 > Some smaller performance improvements are not worth it.
 
Having thought about it more, I agree. I have a workload of my own, 
which as you say, I can simply fix using the CLONE_VM way.

The only kind of user which the shadow process thing does not cover
is someone who does not have control over the source of task over
which they want such a behaviour. Here, the only case I can think
of is operators who cannot modify or wrap the processes they're managing.
I dont have that user.

So, instead of further argument or sending benchmarks that would
show a performance delta, does anyone on the list have such a
use case? If not, I would consider my questions as answered.

Thanks

Aditya

