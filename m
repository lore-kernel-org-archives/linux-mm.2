Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C903D43361
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 00:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08CA26B0005; Thu, 11 Dec 2025 19:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D876B0006; Thu, 11 Dec 2025 19:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC056B0007; Thu, 11 Dec 2025 19:36:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC2A66B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 19:36:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8804CB8C1F
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:36:55 +0000 (UTC)
X-FDA: 84208953990.23.043E5B4
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id A613D1C000C
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 00:36:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HSb/IcFp";
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765499814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAHincoTK5ENt2l8A7VD7dTozjfJCW5AOpMiBUorZz8=;
	b=IPAP0pjShkgz5aTlxtOgidmpMVDUVka81XfcvgFJfJ1lwwKEQ/5SkQXbHVwnA0OTm58Lon
	32bfX/jPZVwFjk+OlXL1phisf9aiZlfyH/jcs1gIAu3Npu4LydZz1LdgodT7ce2u/4h+cq
	3+ZJ81Hz6UduigVfgL3/L1oIqJT+GDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765499814; a=rsa-sha256;
	cv=none;
	b=S4eY9P8AR5ZXmEc8mj+GKcTftupNoi1NXr0xzEzUTrJi8BE01G4CwDyMSyZ9Tdj/UyrUao
	KKL9vsd1gMLx9vX4UEGrfbYxt9n7cai07g9e2FQfcKFtJdwJH+CKAwtkyC/5g8c1WRokQr
	UBiD+U4euqInkZWMRZ05n/qRYrqCI90=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HSb/IcFp";
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 11 Dec 2025 16:36:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765499811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eAHincoTK5ENt2l8A7VD7dTozjfJCW5AOpMiBUorZz8=;
	b=HSb/IcFpxJIIZt5/PosJXklalJUrHM+gU7WbmFAyuUxs2fT28/YFkoiucwKFKaodoZO0JW
	Uiy+u9NIR3phygFK2cNSVzN9aE/qsNKyYYJYeCRXQI/+yfUZdwHoQjAuKIp1eSSP2IZ8MZ
	PxAAX3FZ2/FjVZQ1a0LP99mcHuk+X0E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH -next v3 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Message-ID: <a3od5xvmpuehxss4bwp2dxo5jfuw5clgweh3ko5bqfidywvs7k@q5zjsb52zw6m>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-2-chenridong@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qfbkd3phmh5yqroecd7yeq7e9nwjmiec
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A613D1C000C
X-Rspam-User: 
X-HE-Tag: 1765499813-354187
X-HE-Meta: U2FsdGVkX18AQaU6h2ettYRNkZLojYYoThsVSF1fj72dnRHM0gqL/mdO0aBNT0/p2gdvZO4yx7csQPznf5UCyFJiKh2vH2zXPoC7In0yxJQJJ9ORtueJAg3geXolT67uLhN8otjbfgc3VDfn1flyZjlsRs9rF7pXLPCg3Zv80DMxIVp0cwkH+K3lGSmsZfYsmQQ+H/l9bEB0Fe6dEyPkWG0xNN8uqJ4Bx80hKZZCafYgH+xBL89tiEaxbG7N8VaYQtuGZQ8rtjAw3FB12EuuloMKuf9K6AuaGd7NldAjbT7NtPjDxCJBwMiZy8riX8OpsIdny1Wbvz2HPb8yXOYG4BrG2hEPGAu8m87QhYW77RZKCpB3Gug+rD4ze6wz4bijg9cwhaNWQ2zDlTgzYia6yiZQxhp4U7IwMHYcj2zRgigmcKQ5jSK4ilo1pR0vvqwb0D2APzTXhhVR23GOUPXw/bADlNmh+HbaSJg8MU015PhEz47wCTRPVpL3lG5qa5BT27E1cTaUIiYqkqUFTjXUgoVAxqsQDIFl6AuNakzM3vnWFgvsZvgsaNgAeZPNyzL2Gu+cmPqm0U+RdYOaRe8hMP4k4MDbYGgiK5+IeDb1RsOKvHdx8IXtiHYcMpEz6Gg48Wd1/gfHRvSQuFjaHFl6R0nF2U7I3r4r426MZuPQnWQkOZNQwwP7yzl08Ov4RfqXxKlicacuKejFNmk0lwpjAwKWSg83/84F8LSE9dfc5Dl+KF7qzP0ifjHC7lzMmTmVE6R5jt2hidWNAHYVM6owsM7LSie7G3OVdTKu9BPWNxV79Ju8IFtZ3CPM/NT5CGQtN1M4VjUK7vRb4VtzpoeXQ8KhMr4J6JM9QLfGOKI9BUY6GkdFO+ACaHyIUW1TkwhsmIYBFRCpPtAj6UQhScc/Me8NBKIuB5Oo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 11, 2025 at 01:30:18AM +0000, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Currently, mem_cgroup_usage is only used for v1, just move it to
> memcontrol-v1.c
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

