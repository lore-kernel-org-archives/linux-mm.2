Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC2B606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 23:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iY8KHlhx
Received: by kanga.kvack.org (Postfix)
	id 2CDF96B05B0; Tue, 10 Nov 2026 18:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A60F6B05B1; Tue, 10 Nov 2026 18:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF7F6B05B3; Tue, 10 Nov 2026 18:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93176B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:46:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F518A716A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:46:16 +0000 (UTC)
X-FDA: 85420845552.27.813AAB2
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0986F20006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:46:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iY8KHlhx;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794354373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bV6upzA5StR1b1wyNZFKOklGx4ha7k0DQuLrcpokU8o=;
	b=2EQXj5/TJCTq14JEeg65bAyxGhnJfzXtbRy3Ung6Ht5lFC3MJgQyFOpplHL9nIw2uLV3X2
	Ik31NJqrCbvvVH3lqbqSKTerdp/0HSiggEpXRQo7vsctSFIb8DCz+bz2X3nJfxyrnzH5xg
	Y7FugbmN0VEd380vVBlcQr2U9o/piko=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iY8KHlhx;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794354373;
	b=j4buZzIIJXu7Cf37alEeR0iyoE/ryH6XKk8lhEUHGsURhPVKEWZq8h2nEWPCZd88SaAeBz
	rB24CUsuJPemlM0ycnCYoNwEhmPIMnXMXdgJXxGVpMbGf99WEKszzNWy017+X/4t4qDwE6
	5h7mIxjN4677O/U2SA3+jQz5f2Ne+30=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bV6upzA5StR1b1wyNZFKOklGx4ha7k0DQuLrcpokU8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794354369; v=1; x=1794959169;
 b=iY8KHlhxHAGrs3qH58ofiN470cF1KdSVutOe7C6fCq4lJChwUZ2UGV6ybT44OovBxCBR8QGD
 wGJH3G17G8JmKCGR4BQpkXJ81F1ldIXm4IXalSaAKAw1suM8hQWFBqQUEugyhCH3cH0kztOpi4r
 P4bXuooTIpIQ4I0IonLP7vkI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da08650cc9e97235;
	Tue, 10 Nov 2026 23:46:09 +0000
X-Mizu-Trace-ID: da08650cc9e97235
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 15:46:07 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Noah Feldt <noah@feldt.systems>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/memcg: list_del corruption on memcg LRU on
 7.2.11 despite bf4ade7dbd76 (single NUMA node machines)
Message-ID: <avOsiy7kGWpehKJn@linux.dev>
References: <20261110132853.71228-1-noah@feldt.systems>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110132853.71228-1-noah@feldt.systems>
X-Stat-Signature: 3haz8toof6fx73twpo1i6und8uw1s11r
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0986F20006
X-HE-Tag: 1794354372-740497
X-HE-Meta: U2FsdGVkX1/ThfDBKu8xsxRRT60VqgqNdT+2SeqFZjmDT9xbHxI0dEmzI+VFM5ktfgwrooh4SDXAWT3QzR/7JKeyzPt6h15fSrdkKDU/i9WbD0Z1yAY+JBP/Z3QXvivdgpToPesdirRrSJYtHoO2w75qDIUr36EEIGEIlTmbHHEG/li7MzOV/auTKCga3dYOdOpl9y7WVcNVCHONrN4xp8aW3cNHwI+3DxW+LS884t5SaSjIi5s1bkvsvNebFARb/AAhuHY7uc87Mx/5k2NMyf3vqUlV9FhE9BdY/lm8eFnYewsKVHfEkNtKHBP+NQ9cITjHcYu2u5eLY1tqFP0Y1BLKAaTHRzD6h2gPYWW5SWJrHJBw8NG1oM9pjIqU1BpJ47+Eb+JDpL0uh7FG4ZivW+ks5utXvtKlJ3mkEpcbHP0OCjTQCfKiCYVngjaynkmr/UJLnkrlA2Iz4TWeyGelL4gp33dOi8U8lLRWJZLncbVLRqHYnqkf8UQIvEOLFgbI6kYxaf5oXUbOxAyuZHo9LHn1gPbChUje9PS1FlrFsGQI9lGHz7OnHe0NlLBdENAdgct8x9YyAbINTNbwGbczwFC2KW0Upe9GlcDssf4Jm3BTp3K+1FkPvonwy7sf6luSBGoJVikuNN3dR3lSk5lFntJfFuSJP9n2spwVhi+2CkOjkt3/nqwz2W6wPSlFdCmeMdCBUjl09DD5l8A9z+vGKzIaYjFuD9eE3Tom6nrVOJuJL0bg7DJcGb2S5GdVdG1mxMHIwh+wj5lFVvsj/3YcUFiMPbrPKR8Z+u4lAW8ekU9G7B8c4BzIo/mDCQTCwObCyzuoqgJtNWDX3NZPgFXlvAvotlJgBmGL06d0voi1jYCg5lwO2qnSjIHSKBZrs3XS4qYuQrat4ZsIF3fp3vMhL3slAGJKEHRj5jO3FxokuKUKSzKKecnEam4usubbZBhO9I0H8LduFmRYecrkswd
 eHjJirhJ
 /oq93n2JR/A5OWRMrPAG8rV9wVTfqS3Djps9p/b2bnkU9GOMcYgbhHAA5ih2f/cSPZ+wZZ0+4ry2VxAO51hkdcdKqVKiHQQ15EiFrguE/qv3uDg9qPR1jQrP2mf4ntvFWugpGO5XNILh1At0gNOa3gwKGIGQtZnYBjK2q0mBQ/KQQxAJ0ANM/O5duLNZrwKGEor/+hMxvc0a4EtUd8JbX9A7p634glqS7391m1C8msETR0Li7hMFouzPGKxRhdVgqhzxf0aO1MnTOo9sooezch9ACZVSdnV4Tf/vYCDO/+H+idzYkRMOBWsrgAZdXUixfkxjR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Noah, thanks for the report. Can you please first test without MGLRU and see
if you are still seeing crashes?

Shakeel

