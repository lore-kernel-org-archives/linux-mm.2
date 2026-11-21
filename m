Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 783E0606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqhNilQt
Received: by kanga.kvack.org (Postfix)
	id 914026B05B0; Sat, 21 Nov 2026 12:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D746B05B1; Sat, 21 Nov 2026 12:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765B36B05B2; Sat, 21 Nov 2026 12:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 511E66B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:23:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BED19140598
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:23:58 +0000 (UTC)
X-FDA: 85459798956.20.B79CFC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26013C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:23:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqhNilQt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795281837;
	b=fcBOZJ9UkhuLuBoP0zIDd3LI+rObE1mmh+87Rk7xlxGqXYQMdporgjV/PajTNOw+yAsIn6
	hagXOmnuUChNyfiUj5KRtGRc0UePpKUDimVE8Keo+DSdrLSIzMeqHQJT2Whs6qCwG5ZSJC
	N0OLX6GI2OR0nnT46HEhRTkm55yeVng=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795281837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fUMUx3jV+Cza+EQigl1rcYAIkS0QbtIwp0tnJ+ZrKLk=;
	b=ky9oicZem0LkI9WkU4IsPRkttadnJg5wGebbLDcoV7cV4Ps5ADA2N1+8aR97gd1YLorqE4
	j5MU8rHR+wLkNyBb8tZ5o2JoZGlEQSish3DLs6Tq5oGeVUEnQxvamL/pa5SQ6dIgychX2k
	ciefwj1AywKhUyOlVWumrLrneSzEnXs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqhNilQt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 606F96120C;
	Sat, 21 Nov 2026 17:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20501F000C0;
	Sat, 21 Nov 2026 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795281836;
	bh=fUMUx3jV+Cza+EQigl1rcYAIkS0QbtIwp0tnJ+ZrKLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dqhNilQtZwoham26ThtkeeHFtRSps35xLwa1G2F5usdzpdsiI6le/VhPeXYv1dufh
	 OgjnWpU9RRjsrB0eA7/vhOqPTprsZS6b8J45b7hr5KwnQE3bHQKEkFd6V1O+ucl6f1
	 NiZBhQ5VDsvThE9AzIuNjg9TcJQPe6e2fGOV6BdxqJ5UrI11oSpbUH+qXoLw940UkO
	 GABVMs95EFUbN0PV6MrjJecVWDRwRDL5tLSbcZWSyG6jzK3h4Gen5q0cZ9AgCF0sLD
	 T9nD7cd/T3xXNxdyUHmH8nGpteEU5wZX5UuqUZTGXQ/Up7i/WAZqKgpOnPJiXT3ZCO
	 W5ZrEdrbWrXvw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	arijit.desaii@crusoe.ai,
	Jonathan Corbet <corbet@lwn.net>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH 2/4] mm/damon/reclaim: set memory PSI 0.05% as default quota goal
Date: Sat, 21 Nov 2026 09:23:47 -0800
Message-ID: <20261121172348.80312-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179526475633.4.14859465649138957731.b4-reply@b4>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 26013C0003
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: w7n67gaxjri75e4f3159fcfyyzm64gz7
X-HE-Tag: 1795281836-768241
X-HE-Meta: U2FsdGVkX19bY7H3wCEEyxZafvRyBhet5JylxAVo4XL2riLNzW5OYFkYm+ynahS3CANyp0oryWerlxoThNikv8Eg+7RL8kMFxvsRiMI/nlyk9gA/Npk2m2/0WMrabaIEszb6Zc1t2t7u9jlN8t9iszaTI0R8KC5brCkSWCUdFi2iiYQNjaDvAjiDzqcOE4dKVHHqlr7psaEG7QqIybpCZYY0zYkF4ax4VTTC4PpzqZNnm3Gy+9rFx3Cmu8QYVCOXE14KhtKZRdHPp+pAPWsCjH3O8HhqmcYdjrdujvMtv5JC91BiPNzQdmgT9rbSKqDfUfpxmqBl1tQzFtYYjXo7D3yR+4d/eylWk98oaDAygIzRWP3H3ZirauVl03+P5iKvVRDbWCeZQNm70K3zV8fVwEe6m2lJuWRnlxXL2Ui74oNKNScU4l436EPrO5leHtuHb8M7QNNi+CxunshjkCXI19DFfd6fcW6xsef1od3a4xJzhrtKOYh7gbSD2WYwfAxaW1UzmBylppQjc8i4ZCPCnG2SmvUzQFHzBeiNvVQK8gKvVbXijwTGHB/Wy90pHK5Dgevez+5eOz5PO9My3SN1cf850rBa+DutumZ8LKaUUkUPxm6hh6U1xpArdlCM+k3INMQ6dlnANAxhjmnTNxtL7Bym9uMDVkzwREAo/7MLzMMzhBPPU7KCnrjZtGWWgkyvZTY7lJ4a8LcHzyg2gKp8fmAvZiHFhi9aoAwgpxZljvq5oglTYc2iu/t4AFAmSk0vTDwQFObuEu/5JecRO/+itrFgXx3xk/E3FoqMij3kf8Dll+0859pYXp2EjX7diO2bh3djbEZplIR0p1ESZI+MpsmG3ZCRIa94Psfq31hpPtf5BhcqAakfiOqtpJswiGnAA6PiZtMmD/8H2frAAkahjlswlfQI8md74Wyq9KYdHbUtqEOqsk/nLOFtl9sqf7ftY179N5PPcIhUYie6H0E
 gG6LLmxe
 YySCqTeSnDkat445oQNgZzbgLcMpTKR5caSi3bCM6LEvM7n1iHxoy5L/RcjJpUGQmBssY7HsvwxdjHxx2WKcBdmrWLsV5s7ap2sHGvtdaBiA98b2npoXpM8f9l+P+1IFhvoHYltGz+6rRDnUl2LHSd4CI6sq50TQSjv2qOGpua8hCtxhkB68vq/ENfd22gKmNBJ9XfK6ybbJGE62Oa17Mu5rmT7Xlkcx0nfXeAyp5FnP9cTIH464fGeDmy/9MdwaoI4MJkUIWyBuyTWIXjW0jyC6NRh79iWtxs+rlfP2Jw5qA2XZdzuWbUFGTxYH4AdqjKtqPZ246nJJYn7tLsp+GsXVpLMlodJcLiv2bINR97SoxN1qdni5Ta4EqG4qoOTBALkZjRi43WMXCfwUTQH580K9+czEfGCTvxL6iOyYRX/lUuPBJcbucMg2MGDS3rqpYSLK3fcyx85Gi9IolfRkt5DTxRt/14YpCVA/7dRh9S5r1iXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aveline,

On Sat, 21 Nov 2026 23:39:16 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Thu, 19 Nov 2026 22:07:36 -0800 SJ Park wrote:
> 
> > Set 0.5 milliseconds per second
> > (0.5%) as the default auto-tuning target memory pressure ratio.
> 
> 0.5 ms per second comes out to 0.05%.
> 
> > +static unsigned long quota_mem_pressure_us __read_mostly = 500;
> 
> With a fixed 500 us target, maybe a longer aggregation interval also
> lengthen the PSI measurement window. For example, if the quota ends up
> being reset every 2 s, should 1000 us of stalls still be compared 
> against 500 us? If so, the tuner would drop the effective quota
> to 1 byte, skipping pageout for the next quota window.

DAMOS quota is not reset for aggregation interval.  It has a separate interval
for quota reset.  It is exposed to users via quotqa_reset_interval_ms
parameter.  The default value is 1 second.

The quota reset interval is evaluated for every sampling interval, though.  If
the sampling interval is tuned to be larger than 1 second, the problem Aveline
mentioned could happen.

But, I'm not sure if it could be a real problem.  Reclaiming more than expected
is a definite problem that can degrade the system performance.  Reclaiming less
than expected is less concerning, as long as the extent is not too much.  It
doesn't regress something.  Anyway this is a best effort proactive reclamation.

We could revisit this if it becomes clear some real users find it as a problem.


Thanks,
SJ

[...]

