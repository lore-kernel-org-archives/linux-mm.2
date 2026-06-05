Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B9CCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142D56B008C; Fri,  5 Jun 2026 11:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11A3C6B0093; Fri,  5 Jun 2026 11:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030026B0095; Fri,  5 Jun 2026 11:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E607B6B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:54:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A16DB1C0DE8
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:54:18 +0000 (UTC)
X-FDA: 84846305796.13.98EB4B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E858E100009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:54:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/s9h5Wp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICbzPk1sygdgk3fCaD/XQJdJxLWGiMtjQlsanlmFhaY=;
	b=UaDKw2k9y52/da9+cw0A1290ZNEZRmbCvs2Iigl+1eNC3sFgY7B1Nbl2Ynr902mIHNg6Gv
	DK3sChgfZguBnnuN04VnVnQPF5Fut18JD7nJSzIfkO0nnJUbTHOWo3rqANbduQnF6P00NU
	XKH35UjaExAcxHipyVrLfnU3PCFy6MQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k/s9h5Wp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674856;
	b=A3r6v079J0rZfH5QCJLjk0XYV/fB0ody5hmPlQCWzk6zIIyctSby7woRBt3JO6BDsMetwZ
	dpRBQ2+kE3eNI1L4RyWtMVEGTiWpWmDbKFViU5bL1o6ujR52KnqdCQb0DCHhCCxHMDvkjt
	UB2UVwC2ezDLHH0mFNd3rbvrqeZqZV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73296601E3;
	Fri,  5 Jun 2026 15:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AF31F00893;
	Fri,  5 Jun 2026 15:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780674856;
	bh=ICbzPk1sygdgk3fCaD/XQJdJxLWGiMtjQlsanlmFhaY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k/s9h5WpvqfmGi5vf7ltu+UCKQ1khGhtNwrVnOm3KPtz5dUUMCU0ugI8Uufk7SpTa
	 g9jUaGJKKiYA0cJPk9NU0mOb3POQ3vVHQ3zpE+O26L3Rwg41uryfh8PZvgKUQq07H6
	 WWZ8THi0a7XpQxYReuxVNzW9RDT9su+QIB78LsvxbCUWhzf30xuIzKtQW/FB6nXxwe
	 Lf6Uro0PiUn1VNYpQQue19jFId6oa4jgToyF4MIYoj2E+aBZR8Ch/s3zoEooOK77di
	 jGOT5aY+lscwjLSIGTW41RfnrymzmAq2sPpe2bNyXimhpv/1R4+7GO2d4sve4NSjWz
	 ztibZYwvWqqfQ==
Message-ID: <c3ccd136-8898-49ff-8c0f-3e4b543fafc2@kernel.org>
Date: Fri, 5 Jun 2026 17:54:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] tools/testing: add rmap walk latency benchmark
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 corbet@lwn.net
References: <20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260530170404509QpJmBtpSjn3uQHeVKA2iA@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: kwjyoy7fcs6ibwpwya3hfz7a8e87afkk
X-Rspamd-Queue-Id: E858E100009
X-HE-Tag: 1780674856-600530
X-HE-Meta: U2FsdGVkX1/Sa1SMmKtsd9LzB7kjOq2PanlaBN6GjqIhTtu1v6e0qmSqbjbF/RG7vyTBUF+m4JhLuW1kYUnJOUl87qGk6cRgHv8Ez71ikMa+Pzyoj9TEZgsj6CLxwCn4BbfCUxSu6cpEoiabCPjQIGg4ovx0/Ewl16Q83enL80iG/RUBBZd+FZwS4hmMwq8QWE1BlstwkeFUwrUcxBomWkFFTH+m0AqwlNVrdUkttr542aBwKQyLnphkB5Gw0mvRJiDHOaVMVUUJHuQVB0EtA6pMME3CtDqeYmn3KplZZPF8Z0fNKq6TEKtcEZFVUx40EUSLWlTQvuDmyI3TBQCNtPLhAiXg+Upy8NFa6ky2GB/3krVwN3AHPWT48ntF4luMeQ9mA4QHtSke6Bmm3XRje0wXXyWo/wTg9gfv4fgyaCchc6WWP1X6i3mgAN9+4k6oMHkHVsWWQIXYpNjH9fwTBzUgqwkhtIJommKjPLp3Df03J/7AlSaKWcn7yH9rd+vyzP4jwb0kV5/a2otnDl0LH2j5+GvG6cf848+OBJPElxPyVLWoOmfFNArk3AlJxJcKRifGSMw8KrMhFrdymtbXpEKi5mlYTbwnP1k+U2EyIX91hJyjIfbDJHjAQaHxZxVc22EVPoVC9ryOzDgjB1FdTHzGEA/Je5qa4oQiOPdk+V3+gGaFNgUaQHLuiLetwN14NyNKwLgbZbh2XiNYc2cySLC5WF6XKFuJXZwFcO3F1gI2yLWCEPzYe/CTEouoHXnT7hu0JcKwM2zQW6ZKlF5CAjWUpYL2+sWAVIDBbo/KBQjZCr1VSedhPVhPjeww5ZVj24dE4knKsSmoPCLQAA61j/1XVe/ItVpQke5jrCpndicsq+3rgwImPInQ0iEX6QjjzYEkOmhVa3ZkxwxHvy1K92oEIXqMZc4gXMna3mSvADL2OIy9AdKOX6H9yJZr8pDjb1RIv/9tfJKJpDa9vP3
 H958G+Qq
 0CAVlQ7har3mfA1UOlrcdOmDgLtCYAkJJD7br4lEwWRUeub1Fa035GMdWVYM9DY0A9pEQOuCS+FddYzEWdmUx8aoFLz0UpX+pa+ktGErVcns/oCxiAkbC4VvfuRADyZyvmCbOCWnZFnGwSpUB2NoyLOr3IkOH1K4SC3GPFcDnLiG2jAenYZg5HR4XZJLbLGjFY9hVWL356YKJki8L3fkKtGtiwnvWEVLVYOHz/qMY2nmhPSn9iQmR2b5cBr2ttUS7CKiKlpzKyayQwaLCHm9S99LlgM54hiS8BIefsVvQMgQ0SZPL7LZu7liXaOELJVwBAfiTFxzwNHtKpWrKxH0CaswzEwawhE3zpfGtDxnS0BDD42E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 11:04, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Add a benchmark to measure rmap_walk latency for KSM, anonymous,
> and file-backed pages under high sharing.
> 
> For KSM, the sysfs file "max_page_sharing" is set as 256 to make
> sure that every KSM page can be shared by 256 original pages. A
> large region is split into 20000 VMAs via mprotect then merged by
> KSM, whose purpose is to construct a lot of unrelated VMAs
> sharing its anon_vma to reproduce the issue proposed at
> https://lore.kernel.org/all/20260503205013850sym7UO0jvKJzyRiTYmO8V@zte.com.cn/.
> 
> For anon and file pages, 256 (equal to KSM's max_page_sharing)
> child processes are forked to share a single physical page (COW
> not broken). The benchmark uses move_pages() to trigger migration,
> collects rmap_walk_start/end trace events, and reports max/average
> latency. The tool also saves/restores KSM config and filters trace
> events by PID to avoid noise.
> 
> For each test, the program prints the number of captured events and
> the maximum / average latency in milliseconds.
> 
> This benchmark helps developers evaluate optimizations in the reverse
> mapping code, such as limiting max_page_sharing or improving tree
> traversal efficiency.
> 
> Usage (must be run as root):
> '# cd tools/testing/rmap/ && make
> ’# sudo ./rmap_benchmark
> KSM rmap_walk latency (Shared by 256 VMAs via mprotect and KSM merge):
>   Max: 839.00 ms (838998 us)
>   Avg: 605.80 ms (605799 us)
>   Count: 4 events
> Anonymous page rmap_walk latency (Shared by 256 VMAs via fork, COW not broken):
>   Max: 4.05 ms (4055 us)
>   Avg: 2.86 ms (2858 us)
>   Count: 2 events
> File page rmap_walk latency (Shared by 256 VMAs via fork, MAP_SHARED):
>   Max: 2.57 ms (2572 us)
>   Avg: 1.25 ms (1250 us)
>   Count: 4 events
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

And that benchmark would then also have to be carried OOT I guess.

-- 
Cheers,

David

