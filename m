Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA29EC1120
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22936B0005; Mon, 23 Feb 2026 14:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD256B0089; Mon, 23 Feb 2026 14:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD6C6B008A; Mon, 23 Feb 2026 14:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB8766B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:34:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 930DD1B57F8
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:34:24 +0000 (UTC)
X-FDA: 84476722848.14.1075F20
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id D173020002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:34:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Efc4suOe;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ankHr9tSJqIrETb5hcnz3SBlChL1ny9Cho/sWsrfPQs=;
	b=wVBtulGOYGQ8jmNR/z0aw+FavWI6rOVatk2OxDnPH0rqHnyWSY078Y8eiEAbFWw8k6I3KP
	6iUn0Yd3KTLc1WlnK0dyrb/GVZif/CrT+MWpbZunRLDVlbCBGTe2revyTlLh4lF7uEj322
	IQUSWdjKaFkZBBBvyCSSl/xxkyJ6+MA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Efc4suOe;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875263; a=rsa-sha256;
	cv=none;
	b=REFDhC9//ds57sFo6TwLCU8PgqlMq0TW3SJMZyMF9D7B6A27KuYjCEc/akLxQ8nUd1TgIu
	GKZ23xWiMSdvjAe6rqxB3gb/F7uuZkdAMtmQKrMsha4Pqtf5msDaia1/3UFoLiz3mK3JUx
	+8qQMCKzWdZORnODhRBt8XN/P6MSvHw=
Date: Mon, 23 Feb 2026 11:34:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771875261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ankHr9tSJqIrETb5hcnz3SBlChL1ny9Cho/sWsrfPQs=;
	b=Efc4suOe0fbcjO6Ps7x6R3IBLwx907NhPrC5I3eVGAIJbQ9hUTd5vRH2+zoNcMY5fSCNe5
	AqyMkeEHd55XlQfztLlGIIiwrI8JDHQgdul1BkM3VL6JoGS1i/Hca+xcoI1nX0P9+mnFGe
	kNVvibBtIPzKJdGtwOv2UjrQIQN7Qu8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mhiramat@kernel.org, mhocko@kernel.org, rostedt@goodmis.org, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v7 2/3] mm: vmscan: add cgroup IDs to vmscan tracepoints
Message-ID: <aZyrkRDJpHh8ZnCW@linux.dev>
References: <20260213181537.54350-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-1-tballasi@linux.microsoft.com>
 <20260223171544.4750-3-tballasi@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223171544.4750-3-tballasi@linux.microsoft.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: D173020002
X-Stat-Signature: 6a1fbybsc93um9s4zorpm87quaeenppn
X-HE-Tag: 1771875262-988621
X-HE-Meta: U2FsdGVkX1+aAIFGwIiCVh0FOvx1nDJIJ69Jep16trOOYGYPmss4/m6+7hnOgS2clx1ahJCCMRTALxAPmEV7GRkuRQTogkvWRu48V6YZLs+C70G8QadKAlykc5JBg0mhYyH0Ccd3xckGnXv2mjBIHzz74ZdOK1uI5+fv1hsS0u7sKq27xTERJkWZTLZ6DhZ4NOv3QhODAoLX2e9mHuWgqoj6bkAQDXsG+DuupLqjPWutCDyoFimYG72XugOCIEgwxUo8ykvcG3ozxS5+iWV6vw/Yfyt2s+4uA7txEwBGRbj8PPZnuXzYxMUEt2XPDVmkhupr794lRZw24Y5RYE+qO03ZWh4AbUVo/RXgfJNSuMIxTT5wtavRH/MMSkP6M2dX1EAEZ2r5MY6EVWfrEpYoK7QHCTwalGLFO5BAJ38rH9pkK5aXjzSL1CMNc3ocMENvrE4ZP94VGQBAkYQq7gAMPv8BukW335A4Rf+BO4kGwx7azNSiDKhaqOCkISUqxK3QvyeBBDlpJw1WI45R9zEsNI+JuvFrvIlsfSFxbVKYb5U9Z+SxJrbK/1cLNpkXPkVO4oVrOxjYn9J+3s2/zu6Tk7J88DaFHR8DbMg1i8OaFge6OnObj0Bsa6K1/T5Yd/wTnX/Ml0UJcIVJ29JJjUUwoEsb15yYf5wZY86XCvYm1Zigm8vUdXiD3SQOzt1q9IDvqnuOizaFRXCtKVx+4Thk30dEZTZBSwkR8VhXyh/nc+djh6Co9+iV67DN4y/P30WIEX3Ggpc2ji+bsvTWTAPkat5y+w0Qj2FPqY9yK1q4D/xSTMpalrhY3WlF6/zgXFefonIYkiaOy2RrYOSQT0FGMAyvRVHODqVWsbwJmxK7zCBZbcbyl5s53E+MHROZLL50AxSy0ZnKdYihiwqHGX0mXKY5i1mdiMME8qMGlQiGMlWYtBksP0qVg5j2GcD1yZ5xAuJ0Y0C08vsrjBALXzn
 IHDOlHcN
 oTrYHvJM3MtgpVJVtF9wkY/UatwGRPSc02LkbwXgggVFkXl72aeKmfEEeC0lOGj79C/BDKF22tVE0+xgRXXptSs+AxEJpYYioNIeQPBlz/YeZWF7o4lwRkoAIjbwc0Zrp+pCBGfoK6SOyoBukn1lj2e5ofqmafsX+ussDQFxcHMZ235alZTZefinXUAO9O0Xc3ifTHQAm4wh5f8nfdVW03kX2a5N3J4WhN3AznWMVdNne8JE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 09:15:43AM -0800, Thomas Ballasi wrote:
> Memory reclaim events are currently difficult to attribute to
> specific cgroups, making debugging memory pressure issues
> challenging.  This patch adds memory cgroup ID (memcg_id) to key
> vmscan tracepoints to enable better correlation and analysis.
> 
> For operations not associated with a specific cgroup, the field
> is defaulted to 0.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

