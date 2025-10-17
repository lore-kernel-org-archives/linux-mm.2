Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA64CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 17:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BC48E003F; Fri, 17 Oct 2025 13:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF3158E001F; Fri, 17 Oct 2025 13:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08BC8E003F; Fri, 17 Oct 2025 13:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE6758E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:23:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70E1786150
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:23:59 +0000 (UTC)
X-FDA: 84008278998.08.133D943
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 80BC280010
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:23:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VQUjiBXJ;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760721837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwrEFhopX+T17eWRbQHqf7rS1iblWbJiljgu2wLc4+4=;
	b=5SYUjk6cRbxQfOvqdZCLrN4NBJmS6kCwuPCV1WSCecd3mWGhYLGXu9IibB/MCgerD+uT0b
	4Vsj9KsBxuaoJvkT5d3+ZyGEx0V41Wefh5RRoq8iBqciXRjNUHObwNDtFLQTFS4ATldz+j
	Yol4KCfv+c1214C1Egjvk3e8jb85N+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VQUjiBXJ;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760721837; a=rsa-sha256;
	cv=none;
	b=07jcX+pFVGaUC61mS2rMHMsLA3bLzInrqrY6dzs4VPZUhXhHl1Vm3c17SyW9YWaGCanMbP
	rfO606Goh6CBDedruCT7q1G7cKryTcEWzL44IkRAEgyMCtcefqZMsyDbDnwU4I84iRsFjK
	rFUtRaDB7MaanmEIkZ7LKEgw7B2JYBA=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-87c1ceac7d7so28086036d6.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760721836; x=1761326636; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dwrEFhopX+T17eWRbQHqf7rS1iblWbJiljgu2wLc4+4=;
        b=VQUjiBXJ4bHsGv+/15Z6EgZGwiDyF7f8yjlby95FWq5CtKeI1Y86R8xtE0rU04BJbm
         58yMYIlphgA0JxKDY2XokyM4tBpm8gog2SmGnlcLUu0G4hXtRZ353sFoPNQROnsIOXEH
         wwvGc+Jsd9pl1bkFO2DNoC0C/bFcBS4ukQAjHXFYcEdjrrQuqVYf9DA9yepYBzNTr4Z/
         RHS2K1UKSq2IuUNfz8RBbDq//bQagA3G9ZYDm5xPlgNRXfx4jLsLS61NitWgQ2yMPEoU
         x1J2WXMWYPOBmr/j1Vwtc9k1zy5bW/YNhtP00dw2oUvZYPTzF+bL8ML6SdteICl56v8L
         GvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760721836; x=1761326636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwrEFhopX+T17eWRbQHqf7rS1iblWbJiljgu2wLc4+4=;
        b=E/90vpSmV8bG6HYjJdGpPG9gWBvEWbxwVvDE5sRmz7pmyN393uTsOueKkzqjBXR6vu
         dDoNFytox+XaAGeallzkc4N2tp5Mme0ClT0wB+Ru4DG7zvjvSgUx/KSnEmes1XLtY1E3
         O0mtJtbszkUL2RdE89JsSfjDQPWbo9QQHdd3Jas6VE7DcgrwFHN9z/8AXHxEIFK6CVU8
         ev2oXnHJofkRg0P4Q++524qh6gQXaQsFDe7GLDp5zcSArudRPwFGBlw1rtwFjxcfB50Y
         5FmrRhOP4tBZvdCffmVKNdxYfvnravAu13qseKKRRZ07DfXtT0PhTYvq6ScAf8TQZI3h
         tUsA==
X-Forwarded-Encrypted: i=1; AJvYcCXhTZ7kx6N3j6wxHd+7dB8C4RG4Y5LWKvzoKnDdEFkIl7tEiXMEnZuw7ip5CJyQuD2hKLL3IAC8Vg==@kvack.org
X-Gm-Message-State: AOJu0Yy1hc5bj2kgQdcsI7CQZjiBTkNUwDkcwmsWR3kVZPp6cGUAg0Mc
	g1ThFGjK0ImvU1Rk+l/Wg58b4UsVodZNw+z1JuIGsSNGUJcAQqw7K96dH0PxP3H7Br8=
X-Gm-Gg: ASbGncvQefcj4hMfsafnuf5OSdN5h4MuZunNJTRd0ugtS9rrZ9ETfRF9s1ux9KpDlQG
	1mb3SKxqpsMBPdK7WKdMl63UxMhP8k7kh8UrZf00Md9vDHzTAV3SoDcJOKdM55/CDceGdtjIIke
	XJ35H7CiPeKtNk8GOC5hSuIU8sQ++qkEz80gdC1UZWXrDaXEE1BHdG18i9FIX4QMzYiEolhkR7l
	oXvv6/ayFuqcNyFwS9xQavDHTKieAKG1rcdjWn0AS2aJF/EspIP+ZdfoSXmBuI81gcA8gmvThiN
	Nc4CS9jqZynUmkA9dd8NnjcpGqJaYImoGPh68zXXpma560oZ7CKoyulBYu4F2+AUSzuf0eOuEEi
	H0o3oazp5wbxfBWSzPfMeEV1Onl1fadpU0cQDzQeN4eEa5RgGPUGC7kx/FqoqVqpyInq+z7yhE1
	ou7qbk6nks2NFSSm1MMqV8TBRJ5SIeRt90A68iVA5Jkq9/3+tqbamgTfk6qiKAq0BeKms/Avdcp
	ZEfSRYe
X-Google-Smtp-Source: AGHT+IG7Xp9f5y9hy8yPwbOBBYk0UemuYm+IQwWyBmJocf5cK17O94ZO9vp+HamzhJzQNeYlDTl7kA==
X-Received: by 2002:ad4:5aea:0:b0:796:6034:c0fb with SMTP id 6a1803df08f44-87c20545108mr57988986d6.13.1760721836398;
        Fri, 17 Oct 2025 10:23:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8ab0c3f92sm2246461cf.22.2025.10.17.10.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 10:23:55 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:23:53 -0400
From: Gregory Price <gourry@gourry.net>
To: David Rientjes <rientjes@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Subject: Re: [Linux Memory Hotness and Promotion] Notes from October 9, 2025
Message-ID: <aPJ7qe_2xznFSUMZ@gourry-fedora-PF4VCD3F>
References: <3a1586b1-4107-06dc-f630-8951cc044c5a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a1586b1-4107-06dc-f630-8951cc044c5a@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80BC280010
X-Stat-Signature: pxxgrizjgejjfxzbgnyerajdaxarhgrw
X-Rspam-User: 
X-HE-Tag: 1760721837-305249
X-HE-Meta: U2FsdGVkX1+ZKIdhRtQiSjeuY7iNqD/18aAY6AciQ21UyeTa/e8zUFs5DWqCfIz+ISJZVrf2HBljQpASGqX9xlY1HumyykPpAUYIgsTXUdc1PLmOxL5eFfxSUgJ7DaV/2pC/YoQ2eGEQ/lK5oX3zskXfcypevwWYkx75VdiP+d87Ae5sBtBEd2SnvxYbNuSIALW5i25dDPq1jw8t7QQId3z74PLuHQHqxyrd0NIaETCLO/opRmw2PLtn/ny5P1Us/5H45da2iJ19tJ97pZHALgs8rreM6kGYKoI+1KJzCW5+iYytDEsBg7SyEqlMdjNqbUHD4+6k+W3hUFCmiMnL+403ClwSwr23+4QiB+Ycc+YzvErQVFVysv79/NCQ4PN/S1QRsGmQ7ZysrYZr3TqLlQMA9QJWTXgQkIU22OeuWh6Q1m+PSCgV1tf2PmAsyKag9zHMi1tiMgEHDtEg7I3db1uxkm1NcI3dReTeloonVlrzPBKf6GHOqXslh0dPOmak53oRcGg/U7WM+hkzt+IoOZipbcAxRUlJ3KH/6ZU3AItgJafwxcXJBx57J4q+/GTGWjjGUJ2GjHw/9hZvJQytz4dk7TP2IigoVxdWsjTkKDnEmVKEcdF/nfoDg8KojGulTDPpFYq0M0e26ObywKbtguul8fGCn3JlqP8yhs5iVXwy7zg2yDmprgHmG8yl0EIDnvOze78YYTftiDHR++pO3g9go09lfILaX5orj0azGP30UoccjURFiLOHvfPjNqV6a0SLQtUt1hjpbFjtiMDDJrboKZAmp9HF8d6G3IvNVVPiPoBwOvzmyowtiT6TuBXOAO2iN+pfCfOPBkMDeeMEpbhS+uq6VCk8mIV3/f54onPP2gyxM58FMaaczeLh90vnFvkUMl2OLHjbyU8wD9H5lhj/lds9GjHSvz5x6DFh/7efz5ONsT3qWTUzVMBXXJAeqbGDRaHNBfLt6VjaWDM
 qsWVlqMY
 /n85ZQjbOnCuoFlcCEFg3jr+yIsWXIC+8ojPI9QRGT5DGiTBqlVv1Fb/yUYGSRDVQvC2DockoSAjNZPIrHE4WwzdFHXjmI/mSXkcWmg/x/SxnvTe7dOiVybKhLZ3jLiFjmzd/lw7+qD/jX8XZ6hUuti9ypCYIQjSPjz7K7Truq/HauUW9bifL2xJUGsCXZLfCL1s/0LgtpKsGyK7o+zrITcgPPTHHs66aPvDnF0yCWudYgqnsugDB0GtpXxWsyDh37lGd8dqGjPqDAtPnEW78PkGknEd5kJo6q6SD2pLXzX8iBbUASnPUxH2oSqNbnuVtZAe3qiE7Exm5BXdTeBBD6/SwYmFy45pO20OKkH2ayZ/nCjkdpO7U1xZZh8AD1iw7pZX+CkS4DngmN1VI13xu/xSFAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 06:48:59PM -0700, David Rientjes wrote:
> Gregory noted that both latency and bandwidth were related; once he 
> bandwidth is over-subscribed, the latency goes through the room.  The 
> kernel wouldn't want to stop paying attention to bandwidth.  We should 
> decide if we're just going to allow this kernel agent in the background 
> continue to promote memory to optimize for latency.
> 
> We discussed how per-job attributes would play into this.  Gregory was 
> looking at this from the perpsective of optimizing for the entire system 
> rather than per job.  If we care about latency, then we have to care about 
> bandwidth.  Gregory suggested two ways of thinking about it:
> 
>  - we're over-subscribed in DRAM and need to offload some hot memory to 
> CXL
>  - minimize the bandwidth to CXL as much as possible because there's 
> headroom on DRAM

Making the thoughts here a little more discrete, consider the following

Bandwidth Capacities:
[cpu]---[dram] 300GB/s
  |-----[cxl]  30GB/s

On this system we have a 10:1 distribution of bandwidth.  We can think
of 5 relevant "System States" with these limits in mind.

[Over-sub DRAM] - CPU is stalling on DRAM access
[cpu]---[dram] 320GB/s - would use more than is available if it could
  |-----[cxl]  0GB/s

[Over-sub CXL]  - Headroom on DRAM, but LTC hit as CXL is hot
[cpu]---[dram] 0-270GB/s
  |-----[cxl]  30GB/s

[Balanced]      - No Over-sub, CPU isn't stalling
[cpu]---[dram] 0-300GB/s
  |-----[cxl]  0-30GB/s

[Under-sub CXL] - Headroom on CXL, DRAM may or may be at limit
[cpu]---[dram] 0-300GB/s
  |-----[cxl]  0-29GB/s

[Full-sub]      - Links are fully saturated.
[cpu]---[dram] 320GB/s
  |-----[cxl]  32GB/s

----------------------------------------------------------
Minimizing Average Random-Access Latency / Naive Bandwidth
----------------------------------------------------------
In this scenario, you any given [RANDOM ACCESS] to produce the lowest
latency possible. This is different than [PREDICTABLE ACCESS] patterns.

In our 4 scenarios above, what is the best state transition we can do

[Over-sub DRAM] -> [Balanced] or [Full sub]
[Over-sub CXL]  -> [Balanced] or [Under-sub CXL]
[Balanced]      -> [Balanced]
[Under-sub CXL] -> [Balanced] or [Under-sub CXL]
[Full sub]      -> [Full sub]

All scenarios trend toward [Balanced], and once we reach
balanced or [Full sub], we start doing nothing, as we recognize
any movement is likely harmful

-----------------------------------------------------------
Minimizing Average Predictable Access Latency w/o Bandwidth
-----------------------------------------------------------
Let's assume we have perfect knowledge of the following:
- [Chunk A] is hot and on a remote node.

For demotion to matter you actually need future information:
- [Chunk B] on local node IS HOT and ABOUT TO become COLD.
So we will consider demotion has having no affect on BW utilization.

Without bandwidth data, naive promotion produces the following:

[Over-sub DRAM] -> [Over-sub DRAM]
[Over-sub CXL]  -> [Over-sub DRAM] or [Balanced] or [Under-sub CXL]
[Balanced]      -> [Over-sub DRAM] or [Balanced]
[Undersub CXL]  -> [Over-sub DRAM] or [Balanced] or [Under-sub CXL]
[Full sub]      -> [Over-sub DRAM] or [Full sub]

1) All states trend toward [Over-sub DRAM]
2) If you never [Over-sub DRAM] trend toward [Balanced]
3) [Full sub] is now an actively unstable state.

But remember, promotion *drives bandwidth*, so the naive approach
can easily push the system state into any given [Over-sub] scenario.

Overall this system trends towards [Over-sub DRAM], because [Balanced]
and [Full sub] trend toward [Over-sub DRAM].

-----------------------------------------------------------
Minimizing Average Predictable Access Latency w/ Bandwidth
-----------------------------------------------------------
Now lets augment the naive approach with bandwidth data.

[Over-sub DRAM] -> [Balanced] or [Full Sub]
[Over-sub CXL]  -> [Balanced] or [Under-sub CXL]
[Balanced]      -> [Over-sub DRAM] or [Balanced]
[Undersub CXL]  -> [Balanced] or [Under-sub CXL]
[Full sub]      -> [Full sub]

Major difference:
1) [Over-sub DRAM] has an off ram to [Balanced] and [Full Sub]
2) [Balanced] and [Over-sub DRAM] now bounce off each other.
3) [Full Sub] is now a stable state

So in the most degenerate scenarios (over-subscription and
full-subscription) the system will trend toward stability.

This differs slightly from the naive bandwidth approach:
   [Balanced] is no longer a stable state as we're seeking better
   immediate latency for hot data.  Maybe this is desired, maybe
   it's harmful - this comes down to quality of data from some
   profile or whatever.

-------------------------------------------------------------

</wall of text>

~Gregory

