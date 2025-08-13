Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA7FCA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB58E9000D1; Wed, 13 Aug 2025 16:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D0C900088; Wed, 13 Aug 2025 16:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BF09000D1; Wed, 13 Aug 2025 16:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 944D7900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:21:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F21A140365
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:21:51 +0000 (UTC)
X-FDA: 83772855222.23.B087BC6
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18B5D18000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:21:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=TQsDu4Fu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755116509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H30kUHUoAp0mgFKEUbjujIS0Xnkk94c0v9Jq8jaPeYc=;
	b=nbLJWI+jFZx8m8FK6Y+WM6ia5yzChW0RRCBezyHaExC5RqAc21sB3/ACW49nPWHk2iVx/M
	Iv7smYleAIh61RFts5WOM5GdKv+zUONhclnjD+yPWeutgdqN4GB3VzXoyBmgydG+AZoS5t
	phKcvX6ki+QHr/bCQpAm2ezJFLoOolA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=TQsDu4Fu;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755116509; a=rsa-sha256;
	cv=none;
	b=vcGeFisYuzXbTfy/9CFL6yFOYRj9v2oNq3GHzMmQarV9PQVeJBGZEwrgYQ4JTJkd7zmWIP
	KlMBuP+6fQVATO8lgvlITtfqgy1o8bCV/GQu3ycVEh+Zjx2lt2rR7YP6GIb/SC75cVCgUX
	XdK06r4KWyjqX5ISyK2hcHa8KOSSmKo=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7e870636870so23362585a.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1755116508; x=1755721308; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=H30kUHUoAp0mgFKEUbjujIS0Xnkk94c0v9Jq8jaPeYc=;
        b=TQsDu4FuOgj8w9klUOL+n0dBtJuZ10bsD2ApE0X6laujznwpsVcet4ok5mMevHTknT
         JST8lmLDCZjQcQt7B9+DCuWANucVQ8zBmzV1ICxyEHgfLjJYyW5zgZpgIgD7k4aOYOgZ
         BYLRmQePOHl7BvYGxPvwmekJCUpAt5si6ZzqtcCoynIdWKktqdj5qsy1s53buscVASTX
         cR+a8xHiO10rZ0fajlqr/Ul0bEb2wRhILEEvc+BGxlj2zgMmJ8KTXIY4n12AI9qeBM9X
         D3XzZxMcOW9wzpjke3LJumbTik/Tyi06DtgmsubwW0daoPLN9aD4H9S0NGKSLTeWnRnA
         gcdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755116508; x=1755721308;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H30kUHUoAp0mgFKEUbjujIS0Xnkk94c0v9Jq8jaPeYc=;
        b=uQ8YwMsC6PrIw1EW/hqLiDMZO70s2AXys3jJx6VYaLuM8WLlkvemWRdQgCo4cpFtEL
         MIq++B209EnsQE6mmwqThR7RxvZ8iGyH/sN34iq62eofdOGGFNAqNgwKBw1IoO30x+fG
         WFZF0f+RTCWBb9ahE/5shwd1JzGEZjrg3CtAU+5D/Sf+y+ZJ6wts3dEzsCAeiJQyenSq
         +KYdKelmIdUsWTjFDg3ss6zBKjSzi+629YqLiEiGl/uYnGmX1DCS0z31aREwf7r2SLhO
         ClaBKXzQTbdevTB0qnVZlqhbcwG8JrRtApIeI8oqUVd5q8++Tx9Q4DjIuIwwiWv9dJCv
         Kbzw==
X-Forwarded-Encrypted: i=1; AJvYcCXMULTe88Pg3FSgYagY1qiRZ5EzmytRwEvJPFW3hJtWuFSv3jcAo5LiHk39fK5Tq7m8AuaVqE9jVg==@kvack.org
X-Gm-Message-State: AOJu0YxAsJ3H0u6RvEi5FXKpgIG/H51rPpHFF7qPacjk4M/rlV+f8hrr
	DkYdMUqyQZICMbovh/3Lhryy0ufqrlRhqaBVKKbFe5xv5M0W14hI2DPBfGK+Mm55JfY=
X-Gm-Gg: ASbGnct/WwANDGmzgwlYTO8P1CKeKQatw1lQR5fv43E8SMMgOXmkrI8VrI6M9d1nvEQ
	3HXOiHss4IRBxN1DPTM9t2NEwZzZqkOEtzxPq0zjCGS23xV2JTbDTS4jNsCNShZkr/u75voNE4t
	RfHhsYMb4reiFzkWXlwPQL8+JCDMJkGhIJhKCS9LwZrjkrCTHjpx0T/I111TbtXAdGu7A8iyn2k
	an4paOyAtrDG9XT7jZYLP532mKTU8+ODlj0qm2bAs1wjO5WAEKg8Ifqw0bZyTYrXj2XG+fSUqf9
	tm/OInJyJk3MbxMecU+Wum+q9SLlS9U1RpY7ueSp6ResE+/tQRmkB50uhkruEIZVHtnhvB8o/rp
	DSqFul7JwSMozaHEvJZ9GGw==
X-Google-Smtp-Source: AGHT+IHL4RX8mGUQFHn3xTKxG6noHoTer9v5afSRdyTGpU+E2ho9o1DxodPcyvf3+YYPPRrSEMF5JQ==
X-Received: by 2002:a05:620a:3bd2:b0:7e3:28f3:8a5 with SMTP id af79cd13be357-7e87045d632mr87942885a.28.1755116507799;
        Wed, 13 Aug 2025 13:21:47 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-7e8079cfcc9sm1486333285a.29.2025.08.13.13.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 13:21:46 -0700 (PDT)
Date: Wed, 13 Aug 2025 16:21:42 -0400
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
Message-ID: <20250813202142.GB115258@cmpxchg.org>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
 <20250813130009.GA114408@cmpxchg.org>
 <CAAVpQUB-xnx_29Hw-_Z4EbtJKkJT1_BCfXcQM7OpCO09goF+ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUB-xnx_29Hw-_Z4EbtJKkJT1_BCfXcQM7OpCO09goF+ew@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18B5D18000E
X-Stat-Signature: yzbh8mw8juyq8zb8u6emkk9d49iup41t
X-Rspam-User: 
X-HE-Tag: 1755116508-940318
X-HE-Meta: U2FsdGVkX18nm6evqJakCHQ8KuerSTR8vbnKx2j1RdcSKiBlN8OhDPJDw6ti/Mu71HGQYZEVXUlKbngWnFYC8Na8MDFnweyQLDPLSX7VHHjD3DqLfdHmjYH6c1o8YNLfGM58xFqebHHpgM3smqgnXkuWgBH3ZhSVPEK0F54cJc9RLHpqj4+0wAZPm603A3rDcGGK0TJRycSUFFXoGL3CsZslXCbbl7HcvPXPVOqDVhemkl2sRkbIt3C5p22xrsvxjtMFM4XeydBcOpzpPVYG2/LPmGmpFcGHMqbaPR9mD4+eWvwBB2aSdChOmeqLSEOBFSCDPmucbaP/WyNai60dWr60s4LN2Dn/1BctsAToGjIFcyDgVNidS7tUWXB1qxpge0C+8bsD3u49MMaYR8NInTNcjskKReqsomn5Z9Jl1G46pCUS0VGGMB+1WeHBpfvQEPPkIj/ea9YIWy5wtL0BC5QxTM+V7N+/Zh7xZjWC3pFjpHNfEijd4uuOweoBi6eAZ//A0svt4wlX33WGlbhWJB/bgnm72fuEVeMTZjshHjWUUV6Prbjolqw8SIgEdobE+qA/QoNX4y9dbMBEAJdVT6O++/Fwaat2G1kn4Dkt1ZSNv8pJZdvYXYXPysYCTvm6k837Z3s9wrDHksnjaj1BUIKTCnQ+CotxJcK0iRclMfji7x1zRU/D8XYQAIUqAcfEfXpm+Z8jeULtq2DMuL1R+tdC06mBON6l12htxAmVY3T4aIWQeDA/+O5Q90k8WN809LLmU0ijXgJGCVAF6Fash7lM/o/xdNftjyzRuUTqqbOELP2v83lW4JZrVOBnU1qxpKLYIUcdBGjVi/6gEWDtgX923c9CgeY0OeeD8OD/l27NAcjBW+LMO0CmW1GZJD9zkYst4C4yBpToI9yBUffKf6Por4wy4Ju1uuRbwz4mFqfwrJ6aDnGtz7HjL05+C2N1eYHvgXYEZneFp6LzU7I
 WfUpJr7Q
 wT1VwqTCAV5EvA5N193YHWeKAv36a7zHQbFxSlCd2HQ86XxgwSIYFrWzOp1IQaFIohXYxP+YvLfKw+ntKDhjpoKpLsDdMU0kfC7WTPl74qNCIs5BVwmrPU9w7VAMKf0m44e2Fot8pyhuZA1WbeSG242EG/55gx8WEw8AtmJG44hpPjIbsZIeuPGogOQrCu/FFn+YqiH0P86lC+KU8BDtbAafcLr8+8wvwtno7NZ0FWepRPAajiyF668m9GYY13Mz5BBMERwyGgH2l6WRsEaHCQ3OczR0aoSS3fJiYplDN8mXEgjj8hBGcljHnK2D3R7QLKk+txu3WZYQmN/5zWLqjiBBlzZ6aTjZzKps86KuLzGWih3+gssqNvFtCFm+ZqaSjOyP7tWy7W+Th1t3JPOTe9ELqHAzYddo7ITNH6Wl5nMSv2NRXOvdDJo/GM7WKogTy7jBhO/EO9rxOp3o5Uf3DmOiYXXVuX24BAcX/ubGyYYQeD/wfuoyEvIMasPizdS+pituDAeNGSUpfgWE4DkSKx6TVmaf0KDVJFCTbgXLHqgoWIQA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 11:43:15AM -0700, Kuniyuki Iwashima wrote:
> On Wed, Aug 13, 2025 at 6:00 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> This change stop double-charging by opting out of _the
> networking layer one_ because it interferes with memcg
> and complicates configuration of memory.max and the
> global networking limit.

No, we do want the global limits as a backstop - even if every single
cgroup in the system has its own memory limit.

Sure, from a fairness POV, we want socket buffers accounted towards
the containers' memory footprint and subject to their limits.

But that doesn't imply that we can let the cgroup limit be the only
thing curbing an explosion in socket buffers.

This isn't about fairness, but about host stability.

The MM can easily get rid of file cache and heap pages, but it has
limited to no control over the socket buffer lifetime. If you split a
1TB host into 8 containers limited to ~128G, that doesn't mean you
want to allow up to 1TB of memory in socket buffers. That could make
low memory situations unrecoverable.

> > Maybe their socket buffers is the only thing that happens
> > to matter to *you*, but this is in no way a generic, universal,
> > upstreamable solution. Knob or auto-detection is not the issue.
> >
> > Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Please let me know if this nack still applies with the
> explanation above.

Yes, for one I think it's an unacceptable behavioral change of the
sysctl semantics.

But my wider point is that I think you're trying to fix something that
is a direct result of a flawed approach to containerization, and it
would make much more sense to address that instead.

