Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C110FD29DC2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA2B6B0005; Mon, 12 Jan 2026 22:50:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27DCC6B0088; Mon, 12 Jan 2026 22:50:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 189346B008A; Mon, 12 Jan 2026 22:50:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 021076B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:50:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 924F5BF22F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:50:18 +0000 (UTC)
X-FDA: 84325562916.21.C2B8BD6
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id A32CE180005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:50:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5FZ9zlF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768276217; a=rsa-sha256;
	cv=none;
	b=EaFGvEZVy3puoMzQOq3vtl8gk2v/ZM/iSQAsjwVdVvG/t5cVz6zcbHlnFH94JmrFop9wDQ
	BKnoVoe7V99D8I80dBwiGo6OaulE1A9nCRMizGQUNewdTfzFugVwkhUi23atzRg2MEUOfN
	dB8bWh8H3qNsoIOvCZon73a0+PPeI3E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q5FZ9zlF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768276217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccuHs/PhTi+GRhRHUsSlbq/s7PpYOv/9mfNFn5Q2piY=;
	b=l2H4vFRFmVDOVK3QbFaV3lQPD0aHkjnpHacC196ZvTLclOCRXUTGE93FvFzSWzleVVInC0
	CCBC4bgUmCFglKbrx+rH9U5iNckoJGjTD/1pkwtYgbQ3WWnZeWM1wOT+x15BoBDWs/FWuw
	ourtM7sfJl3+qUTzkQetcrB1XdTW6DU=
Date: Mon, 12 Jan 2026 22:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768276214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ccuHs/PhTi+GRhRHUsSlbq/s7PpYOv/9mfNFn5Q2piY=;
	b=q5FZ9zlFsFilp4zf38MD7SqYTzYkX2j700qDdNMnOHrr1s4gSqH2/e0E5mYLu4lLy/BtSt
	O4voqlRru1XGPp4e6URnHWezxx1pC62g6FDdQVcWggDr0iNdXMb6vSOAolg+2Lsokdne9e
	f7AQeQ63t6cHwIliWq/elIAPYACqgSA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: ranxiaokai627@163.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, corbet@lwn.net, 
	david@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	ran.xiaokai@zte.com.cn, rppt@kernel.org, surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot
 parameter
Message-ID: <aWXAaiLXn2tXr8nU@moria.home.lan>
References: <aWMLQkvushKidjQQ@moria.home.lan>
 <20260113032735.161838-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113032735.161838-1-ranxiaokai627@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A32CE180005
X-Rspamd-Server: rspam06
X-Stat-Signature: 9wogaodugd5gp6i89onxht1d7a9p9tpi
X-Rspam-User: 
X-HE-Tag: 1768276216-846749
X-HE-Meta: U2FsdGVkX18HOYZyBTZ9ga1PFWjZb0WGhGvsd2Nx/lpI86bU1Z7XHUIHrGJKq3ZJAMaJ3m7sUP8oMQjm2szvB8/AyIcOgMIL72sqspvjRrT9QoHwDcoIb8UKDp84sais0zMbA7HIOC+voLp/XbLhsCYcISfV8TasfnNceR4h3It6AVjDvLL/V13+5udjIkPpxWZW9CqRcq8JtUgGMgN0MzEI9+3xhQO+90DcPWmPHEQgaLShLe1Pj5xO0+zl35NVaMFEQXxlUb803Ku5Q/0rlu05L2VV0l5SJA1nMRTK7BzJsyjGhTGjvAMORjfc7a9MNDQ1JxRhNmlERo+sV7VIDdop7p9GDn11QFyOS3lc+LLgLegyYvlY65XBtvaHcJNK+pifTG83FvpKA8O1o2vGRU5hatd6wYsn49Utta1Hg8j0csOPzZqsvBo/rvlajsuTlKMXOKkGPCf9cqx4oASjw/MRrDhhJf42GtJQw6rTs1i2GckVuP/n0/evPuxgaEYJcKijELB2eySNUpC1eYowhCRF2E9WfruXfhlufGuR5hI6Bg4nVGasEOqEP9nvyZ+8i0AdhkdX5vJAs/NyrYcPuYu2sCh+7PPrcSEUO9fK9wrE4rOxiJY5FmNZW3nFq8RIxqECiJ28X2S4InuL22/LT4Gz7GNUlPoyLjL199H7Z0jaBz7LRfCCo+NYOND1rBCV0DTpry6lpPpUXugEao4WDROaeE3o0hu69zsLXwqFxwe1UZ7y7tkWhHaUfDDo0rsrwiThWy4O6rxRuB1Yzj88f0b1BzINH3jSNriXc/939aQiWhPE+LUo77lYW9CN5D+81J4yy7ubm2hxwAEqOS6pwhpXqsNX0df1Z1OwDBi4UdS00Pu1rnmbFngmfij9OWpPSCxoWVd0Qhh/Vw6rfU1PTJFmwWBqIBfXMdqNxIsAKZd/Ze2U1uF+Pau4IRVsFoi6YpXvSxiW/XQGrcRGiR5
 yYbieCBA
 VGZZpLhOFp0ZjFnPqx1tFtLnQXbiuSnw9nj0vCyCBlGPON+vRdst+gg++qmnqa1KcDr4pGChcg0ya1kLyFLKw579tg8et9dfUuLCr2kFdV7BXRO5TBvNouOmudvNRd1BwEjxxfpBgstojkIv2mcEgptH9JLwjkeGt9w9UkQ/JK62d2Y299JPIHVxtkSvSa4DKWIarYV41ipDrBbFzSgjakshJPbmjfvCvCn5F2G8Xwrb7EYjOsd4MH6SftpaUqlnisbsjIhk/WjncPOnXUOikaL0Vvb7vYiE9kPflrM2phWd0d8w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 03:27:35AM +0000, ranxiaokai627@163.com wrote:
> >On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
> >> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >> 
> >> Boot parameters prefixed with "sysctl." are processed separately
> >> during the final stage of system initialization via kernel_init()->
> >> do_sysctl_args(). Since mem_profiling support should be parsed
> >> in early boot stage, it is unsuitable for centralized handling
> >> in do_sysctl_args().
> >> Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> >> the sysctl.vm.mem_profiling entry is not writable and will cause
> >> a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
> >> rename the boot parameter to "mem_profiling".
> >> 
> >> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> >How was this observed/detected?
> 
> Actually no kernel bug or funtional defect was observed through testing.
> Via code reading, i found after commit [1],
> boot parameters prefixed with sysctl is processed redundantly.

When bcachefs was in the kernel, I spent an inordinate amount of time in
code reviews trying to convince people that yes, they really do need to
be testing their code.

Strangely enough, I have never had this issue with project contributors
who did not come to the project by way of the kernel community... :)

