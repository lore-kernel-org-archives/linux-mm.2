Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970F2C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A5190006C; Wed, 13 Aug 2025 09:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F23B900044; Wed, 13 Aug 2025 09:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F8390006C; Wed, 13 Aug 2025 09:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12DEA900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:00:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBBFB587E5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:00:19 +0000 (UTC)
X-FDA: 83771742558.21.2A22642
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id B31B114000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:00:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=Swi8GWOD;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755090017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/BrlZbr/T7l2ZRE6UEhDbhwVQUKfgdvzKuP95OrSQY=;
	b=D7ItZX/HS+GqiKeByj2izVr7kVtkrGMmJvqMm4subr4RSnRPWi4p1SfG0vSTc6taVja6XE
	GarUfBjSSKy3fMG71m4+ahi2cRT6g0RWaiC75nmHd7IECJ01y7fRWMOJ29oui7I1Kno3TJ
	Y4Y40qMOSAzYVEZgi39NIH/BT+fj+Zs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=Swi8GWOD;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755090017; a=rsa-sha256;
	cv=none;
	b=j1v1xmLxuBh2uHyJNPq/GnwQUguad++K3Qs+mdYjvC+KXqnbzHn/Rvz2K+3FmrBWlo8fjd
	MfsWzsg4ywyM+nyQanumxyFNSiMRe5U6ToL+tjbVx6yDIAz24a3BfnUDxFrnBZEyeec13c
	cKlpmlExRWnvz5Mj22YEkO+mEgViBg0=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-7073075c767so77772666d6.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755090017; x=1755694817; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P/BrlZbr/T7l2ZRE6UEhDbhwVQUKfgdvzKuP95OrSQY=;
        b=Swi8GWOD5rT2h40auyjq+S3NFpg6fhaywFvoapfInGw+7ly0M2rIRhpjdXPN5e1ktM
         wXHiGXFchnj00w0v6zLpejW8bQ7igW1puIgTuDXBnay1CAHhqEqahzdgwt83dz6PTtIi
         sjuptVtQQPBk7McTlmzfKGTc+0wRyrRKwxg/44OcTaqF8gq5kgBjCDFoRv3ZQ7tAVziY
         Uk7HoBEpDiroq4BP3ZEw3T5RK0E2oIz/5/7J3AwQdvw/4oJxypyYMe3iXDwg0Pb3RiR9
         OTOTcozdoHn5u0ArANT6YNT5MGhQfarKuK1DQfz+HAY3RFlgpNWd72d6VR7K6ln6vCyN
         S60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755090017; x=1755694817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/BrlZbr/T7l2ZRE6UEhDbhwVQUKfgdvzKuP95OrSQY=;
        b=eQuqn47R/QvtkRRAQMUuhRWm8YbFZ66+UMAbw5/ewMQoN+R0VeuElTT3kJ6M3uknIi
         XuoI7psrodMCwSRmANu49BZid7txzLEMTpCEaHhi5ldYtbBq0LqQttaTHOQu7EdCYAi1
         9VqL03u8rTEVWLWLtx/mlPYy2UDmD7Lz9vnjWeDCAXRAJuLY6YjVBH98Hink/xzpXaP+
         7IFPYIkaUy0dHAsBWxQSC/U442yDtE1XvFyfqIWXC66pqxK3FicQBHcGY0szTB7oWHZL
         qVgbc+bmzbjHnCG/lACXj4QKZiH9otVoI+64H2keLDM+17ovOcEpWxtHkJbKEk7LT4G5
         ccwA==
X-Forwarded-Encrypted: i=1; AJvYcCW5TKL+Fy9TWXjPde5+ZNabUdemCE1zGb/NMxJrfsFss1kI08MtPqDmjO+4gdmsQAU4XcD1w8ldmw==@kvack.org
X-Gm-Message-State: AOJu0YzbRpZEC7xS507uDlVsZM/u4SCWmZ5wnm1JHenBbdFqjZIiBnwm
	rIPYpDRF4/Ju/hYOdl1BrR/6TcB6mLBlOUHeaBLGccAuLsEnEEJZ6qFEoZPbKs2iR60=
X-Gm-Gg: ASbGncu8WZvM5JhSTUb6yhQ8UPBUix/dDvhwBdMm1sgA4LCaT6p0uofsoKbwOeVhdGJ
	QJ1jXqrcanbHT2/Pz4iXFM44p6exx3Q/OyeX3q+5ieioleLYNucmQW09mFl2vqT78TApvgING3m
	GcU6KpxoEM5Iv+mG+G41PL/pM5tJx2HV/8aUlgsh3tz7EdDqoyZeAnzT72ZRePUirRWmkkB/Bot
	T/V0dbpPxts/816n0QiNCw5WiEwq7ZLpFfqc2MgRQxMpWfey9BUArp8Y+YhOS6SxaYud65+0vMY
	5TU/VRbJG+ACr6IYfZRIWalAArijLPcSFoc6ENURR/Bqw8lnPtiS/EOPhvOG6//6N9DLoukNxqX
	ktvVYlizoIXrtPKwGvZM9yWBkUTqOJ5an
X-Google-Smtp-Source: AGHT+IFgGWoMlnm/Y1OcmFOyyn2dsuqu/R1TVP5M10fhTPzIDW0MUbQN+HwN5hLswo+SbRfYuOk9QQ==
X-Received: by 2002:a05:6214:27e5:b0:700:fe38:6bd8 with SMTP id 6a1803df08f44-709e8843a0cmr37405206d6.19.1755090015449;
        Wed, 13 Aug 2025 06:00:15 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-70920e28dbbsm188318676d6.62.2025.08.13.06.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:00:14 -0700 (PDT)
Date: Wed, 13 Aug 2025 09:00:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Mina Almasry <almasrymina@google.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
Message-ID: <20250813130009.GA114408@cmpxchg.org>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812175848.512446-13-kuniyu@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B31B114000C
X-Stat-Signature: 1ukxag5dnefigmjbs3er7qckmdmjdr3q
X-Rspam-User: 
X-HE-Tag: 1755090017-837887
X-HE-Meta: U2FsdGVkX18ahpcKLodHl7tLXhEwWlwZ7Lm/5eTPmXb3P1icHri68ukDvSQ55sI6zFsg/nAru8MaTxa+H+SCwy8s1qvb5DgxhMIxXhPATLBsEuwO3Fh9KR5Aw0XEQ1mYPJzQ1oUoPd60k97DaniG9qCQdm4CcCWTFh0+jtW5JgMaEPF4xx94wyd2+EopUKo6Wl03PTT19zE3r6jUzs6KoE9GnNcEW8q3SqGmVoCcx9Q3s5nTk1o+JipA3WlB2F5A5StNvgauAdvTl+qFVJJH36ppHEjeqXyYueLT/wd0qnvtT31UKFuf+rz293nisjBiMPRknI/TdtSgQoezei33lc3o1Hno4rgub9DqtN30yymUKBTuEXKpsHdr4kfpFIrhN4oFz5XqT5o3gcatZQqoQKzYIZUzllIIQFlz38ls82PC0nKM++LORTA/r0Ht6Rur8r7UNKVgTyHOFn4BMpDx3Z4ykprqq3P/gkYopNaFt8+34OoAxe49xjTwdTY1XKKFUNlRJEJe6gPLuLcLLSTJkpVdk35FVeq26P8bFtHF0DJQl60uPNEl8rtyVEdW6Y+a5S3Prpr4n8Rd67UBnJNVLbPUNT5V9DpCHjDEBqRfR8A2QBPsHvRlDcB+O1mR35o/D1lJA0JIrcOhSJqNMnLx4Jtpy8aoG4MVpSvD22WGfjrHHbqVTgIx1eXbmE/Bvg2wnWy3VWgFXbccXf4clojxxCm/6Wx4ir4fawGiWRVy2NLr+ZG1fxZZYVa01PrykG2OZiVfAl6IOrs2g5Ca0o1X9JhF0V0OOw+YOQiCUvr+x99H9/CRqBkdVXC9UZ/1GreaAWxgrFcSGDc+IWxlPFa+pPiJVtwqE/3atwYmYi8UiGmbTzzqe+gsJDbwSM5d3lP/hhljaA/hHh/stu/gXVbYx2EVzM7br8K4zy2UpRluA/1/pYnNxih4qKfvwyFmER+gaDgA+mkO4Q5JUv7mKPA
 FHXbpMLF
 iQV16dcNW+U/h+38rdbRYLj5rqzxhFxfnxH7VHZ/DeY/ELSBW3xYtRDokd3lLLrjuO8r+pqaUTJ453DzYq0tumbXQD545w4+iEBxIinBh0UlbFMjXGwUCNMbWB7M3Y7qdoi5f66BCJeMiFB1KIsj+jgyq6zUluZpnEFDEhPWKlQisXy/uwcZhj0iNmKNpv9e+VdVwTM0cl7cP8MPrBUcgnXulCBZG17BJ7D24+EksoakTYYuA70NGpFnZZFWC9Zi2a2qB/xV9ZQs3svLzsbhl7Nak/h3nMKzvVWpSiH+iZEBBjql0HX42y/4h6esTzQzpDwixUbffVzTVQSpU1vIghu9XdLC3GxmwDE8NSzBO947yNY+IvA4Ujf4v3gqa6FT6mBB+6k6XwLYBcw9VIEcIwo++uTUDO+xQUReecFXuZk9Tq/WhH9OkvAdSbZyxHHdnkJRoAP8js+6mKLypaaNpf52O+9EA59MM9uEhkxJzOSAiqrZOD26ze/XacNow64RKD0b05jG8DKlKPi158giR6dxWcFq2D14jWJpM80ilu254l80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 05:58:30PM +0000, Kuniyuki Iwashima wrote:
> If all workloads were guaranteed to be controlled under memcg, the issue
> could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> 
> In reality, this assumption does not always hold, and processes that
> belong to the root cgroup or opt out of memcg can consume memory up to
> the global limit, becoming a noisy neighbour.

As per the last thread, this is not a supported usecase. Opting out of
memcg coverage for individual cgroups is a self-inflicted problem and
misconfiguration. There is *no* memory isolation *at all* on such
containers. Maybe their socket buffers is the only thing that happens
to matter to *you*, but this is in no way a generic, universal,
upstreamable solution. Knob or auto-detection is not the issue.

Nacked-by: Johannes Weiner <hannes@cmpxchg.org>

