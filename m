Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06BE8C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 21:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2EF56B008C; Wed, 16 Sep 2026 17:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6F66B0092; Wed, 16 Sep 2026 17:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A156B0093; Wed, 16 Sep 2026 17:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA6CC6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:30:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0293DA3DEE
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:30:35 +0000 (UTC)
X-FDA: 85220919672.18.4B2F5CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 78FD7C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 21:30:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXT7mazK;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789594234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	b=B29+0W5C6UR9VWTx92NFsiMB4wkw7kDGZzuBUh9GM3igDqm7LocFfU33pl30nnSBG0IGZW
	77ADKdTa9z672FSfqEfXtnhZL6oaWFg1mUICOMv2tQVTJfSwKRT9XArcgWEnyVWmjd/1O+
	qI13SKiIMP0yiswTeifEHKfATZuL+Qs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fXT7mazK;
	spf=pass (imf22.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789594234;
	b=q9bU1hIXGQYlWBaPanylqJpiBgzlVSkMCEFLsmhdsC46/LbxmO8jXnAJKTv4HVtZPx+suF
	HpsczmUxzbxFU37ywZBrNm5iHNQF2v5yo5iETNymRFNmZahVcoOI6nMMX/6OtLqbI9dCw+
	4YxLG/jLuF80OdTemU7MGwgPS6Cj+Jo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAE4B600CB;
	Wed, 16 Sep 2026 21:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9B91F000FF;
	Wed, 16 Sep 2026 21:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789594233;
	bh=2nzSzoycrfwe2uud5bUJoBtH/3BuHnvkcQd1i3N2lQs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fXT7mazKQbr7VC4dIrK8QNIGQs58lRoCJ/K+BUq9p+JNhS5vuNDvCYwDuXNvaM2qK
	 Hno3Hr6eonSY36B6fsG6bFel35zeRT8jQfGlQuS4jqWQ4m7+FUlaaz0R/n/Ivxcr0A
	 wksc+thKIWuB/RJJfb5JpuZm3BllRqhJUPcmrdBgi5UkQ44PQ/WCybTKg5J5bL7Vw7
	 zZFoTq8hC/pbw2h5wgdx6ajVXa8cFM8QaBkH1tZiQzwmS+0xktzpIkpM2P8roHzSwV
	 GmhMykbXU3N0HRCIeqEpcePHHe26kF+vQFxbKD4e96LLW5hvn3nrzj9igIUdi4KGyR
	 IIAn2Jjcsf2mA==
Date: Wed, 16 Sep 2026 11:30:32 -1000
Message-ID: <37f5a5fa8fc2552c4cb6c5320e6c71f6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: give the O_TMPFILE open in
 get_temp_fd() a mode
In-Reply-To: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
References: <20260916204436.821378-1-eva.kurchatova@virtuozzo.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78FD7C0006
X-Stat-Signature: 9okwscnae3819iwxyhn3z9obg594qn6q
X-Rspam-User: 
X-HE-Tag: 1789594234-467940
X-HE-Meta: U2FsdGVkX1/1DqfQNanAT80nNk7XMTHGwxvCWS8/oLFgAaBjcFeurhuPohrJwgDM599dFX+10rthzBNyeGrs8XLA7+XeUrH+fhXOHqzfJmPHXrgdbSuo9U6qbpoIL32LDoT3NrNK3UmHAAiHt0jQ0so/8rIVT9q6Z8F/FJ9D68hyd7pceh1mCXbuA5n3kbd+Rva1Yt3XMllFtz4qNed2VCPB6eXuDOf5TwZOCTDuW2WDY2QKetwY4SkBrpOOKPcynFXZKTJcgTY/1KsYpUxVynGOdOwZ3tM738xm+hinOi+aGnPogYXTFkhxtstYTMGuFqa1j4Caj2S7+0tSrLnY7dMG08mzdXYOIEemOk4XMN7rSZqOLnW3qzdbiY8LW50wcjM0ZfLn+j3JHX5B69G5eN+mKz8BHjdNwwSnQB+grUx9t1ADdGINjtv8G4RGTbMuYp7isysmoIsN5HVuUvG1z+B4e77o/aAapveHlxF+LgatrdJCZJkMXO1UeYXKZ09P743XgvAaUikwbfai8puq/6niUGtAy4S/DUlPQ122urDMveYW4O7XM/GUq7dwtC06KVp/r8/QXoF9D/kM+9/SGdHnCFcydc41SpC0Epgej8xyWTPdr15uyx9Tf8vn67PNG0/drVa3nNX74CSzBFJ/Z8+MGAi3JjLQRC8beMO2ZNp7QEtAnhEzhDO3mIugAkSOHFmUhCT6QpfSGnsvfpMnIlyNey+zfvznJOzOhkzBvf6ljmdPTx/Jq2bXnL8BRpwvVvJ4D0vr9i9vuPGPxsL2GjVdZWiEJoOIpn+A1XWYZSWcBK5gf/Mu/jRzzZOLmsyFiu3Uc2l31RzzR0BgItKYH2fBQ0cCZEydj/ki1O90PvssiN3In1lv6YnKsazD1mqGnF9cF1EBNld9viulswstEUVDzlw/PJGGc+VBJoGOcodH5xBEkwujSY2xhsv7sbahcssftuk0DX0kUuUf1zs
 D6dlEzjS
 jQJNCTMms7zZ83kk15TBDf+yfyGNy5aAOW2YQ6AfKccx2+spNdfB56LgYcwlM83mlJtCVV67bCPuWm3PEIrUMqAW+7xfu4+o7yfztMtBghIKchu6xqwpWJtvZkfAciYZXIHJF9fI2eUkoyhJolIdsmgZkNdzLA3PYMqucNp+k5wtljyy8Pi3oltiWqecH3CjBj0o3LRU4yuhQWMeA7OtvMqBOTN7sNhy7bKo4RV8N0+TBiEvfhEhavgyyNfe7QOl3S2lUWWF3ubTrsKvk8ej+avUvoCgdODPFDAdc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Applied to cgroup/for-7.3-fixes.

Thanks.

--
tejun

