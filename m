Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A52E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 06:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXJjwAxu
Received: by kanga.kvack.org (Postfix)
	id 0BA0D6B00EF; Tue, 10 Nov 2026 01:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B4D6B05B4; Tue, 10 Nov 2026 01:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F09F86B05B6; Tue, 10 Nov 2026 01:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C81E66B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:01:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48077C0899
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:01:15 +0000 (UTC)
X-FDA: 85418161710.13.0CE7699
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf12.hostedemail.com (Postfix) with ESMTP id D2BA140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:01:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXJjwAxu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLh8JQ8NDxlXvfdd8nmZgCeYY6KJkmD5D5lm9FmA80I=;
	b=DY/B5BvAuiXnkFxYr/xUydfCQiqZSfAH0/A4lUZwBCf5j/nn3E43B30Nt18kuI+yL4qrrQ
	DMtTywqoC7hBoV9UpmYtGSOxZ1VEjhMc4e/ilWJboZ3q1yLvXC+ubmRcqkLUC3BFKBRzjC
	5ApaRNBUVPLHdoyoaH9WNph1sQiQz7Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXJjwAxu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290473;
	b=DNVGjxUA04uvuh0nB16FlgSrhVVXItxVwbN2s6uD14Iz3qwX2LBl5L/CP0MEJNaXhsDvQc
	6rAt6lxwiEbz0o7YeXVdR7fQaaXceK+DvaPDSKR6PRcRElBOcLRhyszUcPBa79VtjlvUSO
	Z/Dm5ndkkCYQ3Hc9PUX1hdhZGSgI/f4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VA3K6iPo/olQKGrY3SmZDnY715mLMX0FXtR/KjMqe7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794290469; v=1; x=1794895269;
 b=lXJjwAxuAyUigPchBpexbmn0zCmwp8bYRR0IhFKbYxZ6sAuSu9WOnlwmUqQmKmES4Zo6BmzD
 1OUYjlLuHFgvRVo8XSG2TZ+w4KGzA0AAXSf9Yu+IIPxqIqKXATyhQattCvw1mKezI6I7/e+4gWJ
 Uw+GzuJvSc0FC0JFea1QJnQw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2ff0dc8c22bc786c;
	Tue, 10 Nov 2026 06:01:08 +0000
X-Mizu-Trace-ID: 2ff0dc8c22bc786c
X-Migadu-Flow: FLOW_OUT
Date: Mon, 9 Nov 2026 22:01:06 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mingyu He <mingyu.he@shopee.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <avKy9oMwDRjKjfzm@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
 <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
 <asy_L2s1TNcN7bOK@linux.dev>
 <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
 <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
 <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109212410.ca24bffef1abcd50b3f58c13@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D2BA140003
X-Stat-Signature: 9k1ghsbd7wjudposktd1wb3xd4qgdbc7
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794290471-347326
X-HE-Meta: U2FsdGVkX19BKVe1MwgYYO0qdzJDXzqkc40bfATftTHpr4W3n/HBY6j5rDh0Qx89t5iPsrcLU6Yw8+a2+uhbW2WTtsIiGyFlwOPnoVppIuUnmplTYbH7pWNceXbQJUcfrmr9wK89pwuQsT6TZsuxDAYAOnDAGb6vJEv7WXlUF0xiS+5HRp81xoeEFZej1/FTYRS7S4id5cTTIOJ2lMV/aR7Um/j5kQbBwFlHSmabh1WdF6NxbWWs6gopLUftrCKYnXgL49f/Snh55qTCUS01Eu+bO/oYgVkOhC8e31Uh/TbQ8Z1Yb+uxnKc429FxoRvw8s+6Ww1MqKIBgrvOD5V230MUTZLj6OmRO259JHG6vgGTx0G8So0OxMH5y6PSJ3wWyc+tv634MbtKRBxlopQyM6ObYmBiL/tiQeSamOTiBkrbF/6HStbbtznpny9npDatwvU3ljkJTZNl8yfCHyAwBROfUuJ/4CCkGMGSFQuKMzvIEXSHQhP2FNC7OGZF8web0FzxrQYIpDIN17s0WmaFLghAZKpScvSN9pK78lnfhKKTuB+sYlTaM+vzBnc9lFef4TPSy0LPrGnv/7nE6StKYAzWg3sXS4D3/SKMUducQnhS2CCa6Bl2gNq86DzU9b75U101jTgaRBWAlCSDsI+3tHUN7uniQ6YYQOvfQKp5dgsCrXWEv18GJeD5YvFDlJhtv51EnJlXfQ7UzihZNP5BJ950vYi+B0DBBcTdGY8fn0HoBNW6v7AvM/j8q0gfjlU7a895sPyPHLMzpO02lu7M4cV6jUMdC8lDiRWCA0yosUqc3j9ssch1474jaUnoIOEmso39yPWE3TeyOR93xO0nZ4Fa7v5qFuZ6EnyAS4kSw71J/Ht6cwrJCMMrCKbwUKgEHsWnH+MXeLSooSOlFT05yvhVifIZaDVHfHNlekzqgPOu6ERpqHrGpJgStoiaE+vRJcSMowttDzEdfwqAe6d
 QIf3a+4Y
 CS78Jo9GEP5XD1uVeYWONH8zKwdw2vJ3TFxzbWK470WoA97OsZsqzUHI/4WKgP06dBgR6cXVhZ5qpHqN5y69KIv6PupX4aimNhELMV8L3dgGhxB0PyeWYkle3UbIWQeq1p0M/rO2YdYhYvSzGVZDY79dZVx9YAujrMqpz16pj0fIdSZUk1xbCpOijoftc1KrY+OmAMHgSioLRCq+PbFHElaIjNKazbm+tAW6T0geSaPce4bsswfX4jLvf6ICdt4+KhYoi07tU6+F6PrutIwnWlj1EkUZbj+0r1i9Em9MTFONgQcKtZ/RD6FAGcj1u8jOdg+XFZgutKOHhAXuKjjfFG4gDweuvQH3F9KyJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 09:24:10PM -0800, Andrew Morton wrote:
> On Tue, 10 Nov 2026 11:17:37 +0800 Mingyu He <mingyu.he@shopee.com> wrote:
> 
> > hi, gently pin this email.
> 
> I think Shakeel is suggesting that the bpf caller be altered to also run
> css_rstat_flush() regardless of the update threshold.

Sorry for the late response. Yes, just always force flush.

