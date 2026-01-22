Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B06C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8F06B00DC; Thu, 22 Jan 2026 00:17:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3BDD6B00DD; Thu, 22 Jan 2026 00:17:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F026B00DE; Thu, 22 Jan 2026 00:17:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2E796B00DC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:17:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E9611601A4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:17:35 +0000 (UTC)
X-FDA: 84358442070.12.C3536D0
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf08.hostedemail.com (Postfix) with ESMTP id 682E9160004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:17:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uG2sPJdy;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769059053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvXyJ4IjTH3psLgpa4Edg9bKy8go2O2C/kV6B2QSdmE=;
	b=VMm2F4pjTpe8PecHbEH6QdYbnPLjRV8ssAmSiB4VoOrYV/yFmHYHPkjST8MvzCZEFTPjcY
	7pN4vychN+omrwEH1r2SHq1Cw2wSrJCfmbpDnBk7J0RHR3fhFcwhRjns47xCT1yEb7aSzE
	I4wAIEjrkhobRu6qaLLBrQ+fqRWiM8Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769059053; a=rsa-sha256;
	cv=none;
	b=RYHHftJCZe5ZA5g1kR/JK/YfSQdpsucyHeyan2JA3fCT8KB3P8N2OFIdVjjlDIsOH/2W1J
	GGfv7AoPUnwyeMPOx/AWwjKuS9pwuPcHGoa8HITddBMqA7juMne+IYF3F2Ibb8eRV8uat1
	RhJCuUqtT6RJT+pqu65p5az5419Ze7U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uG2sPJdy;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 22 Jan 2026 13:17:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769059051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FvXyJ4IjTH3psLgpa4Edg9bKy8go2O2C/kV6B2QSdmE=;
	b=uG2sPJdylL6tZnxLGvfyIAOf8RviT0HGsSIOb9JNKrQQFbzgVPw9qcoy+XCgkfEzMtfk4O
	4IB5NGfZtMn421udxUEyrceLzNPQkm4GHJGjRR2TlQimSabJbNyrAxTyQujDwPGE/ApLTK
	ChMn55qEW50lY6+mMjEAErQ3fJUNIk4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 20/21] mm/slub: remove DEACTIVATE_TO_* stat items
Message-ID: <onpv3vtvqrybt2ceuyyzv5dm7a3lt53vyr3cc5mlfirf2y3pti@vkpypvv62ijv>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-20-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-20-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 682E9160004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mcqb7f9g8yno6mtnhoxqz13ccmknm735
X-HE-Tag: 1769059053-86033
X-HE-Meta: U2FsdGVkX19klE5iPIRKPy0sKHUmIxlpfJE8jbEHIYQ5bRBbmIluEeSvi6J364LCb03mYie10e67oWTNoh/pLJpD1BdycBB4R/iESaV9bpYnMQnNQBUoiZJb4M6VnOq2gfy5NTSDRYsYl5d/rrwpuMcCe5bK36ml+nBcQcwpCOHO7KuKkbWsfTwIl++p6BWK10MlDFdz41/wkGzlkyOvHU8VOOM7LAyQ8JDRAZEW7lUFtuIQDt99Y8aZU/AfQWreZISCCDoqxYqiLIG1LGessWH94s4oObHomKrpJdOW7nfgdvIyPO1nY7BkVXzvqBrjdYONuA/x0oZ3zReAtsPGAIciTtFTmfA5j6Q2J3MHUXion/kbAqTAk1rzGbWg8VEQGHDMgHC2PiNKSU3qlIS9PV+CEE+H83Mvpd21cHXiOU5ExR7W5OEW2WhgrQwXP+KHxmQTdY9cO7VEZAlMmKM75grs41nxde/iMkkw+5hkyNSF/8nEIqR1qleGgv2v2/fxp2ROki4FetZDql79qfEOI/+35102adrp7I89D06RV/xItw6Y0xScky16HGOYAflG2qBZcDafBO77uI0372TooEaK8Sqw8/JvDjqtj4NKO4e1sbxPM00/TAU/i2ijpN73xdP0OFTQoUJI20g2t/0PcjDnF5cj7Q0Iswk58U0nqKEDY5fnBynweYaCweGq+hN5nBoAT8Dspcj+vU49+NjHt2He81cFRWUVeP7E03k5EYu+aCx0UCeoq1hqB3P6eBjKB1KvcPYN5Kh0cZBo1yU82fp5qiPxkhgke9jNdp9yGCP584JxpyD/XzJm76go9y79TR6RoSja25j3GM70FNGuJH0NTvgB0SBSMyo4BjlJuI1ve/H00+Gr7bQ3VUNAwEfPvYaRXQT0O9v7I+1mwJHY5LZjJVpOXmY+v1m68zKQLCiU47xqYqgBc1zDKWkpCJQQOpEBbU23jrqQ+KNKXR/
 ZUQGuE7d
 O7Y52m8L9bCUenlrkdfNxFbt1W7UN+FaQIU/DT6yoRpPsfEbp00xjReke1RHJyznBhU0/oy9llmtXkRcLBtQomDoU5giLh9yn58+evH7A6n/zWnoypNcGTNGeurX1zPAzU/utdwXoxGzLgMLop3WrIl/wfQ/WbAbXieIw1ykC9puNdrgU7bnIURofmNRbykpJNbmz1imX3OLIB7ZPjymoFZASfSpkZrxcLI02zxsjNmsa1sW/1NmhOIGk3eQ6lGMFIEDo6FLw9PrjwLn0q8unN0eOPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:40PM +0100, Vlastimil Babka wrote:
> The cpu slabs and their deactivations were removed, so remove the unused
> stat items. Weirdly enough the values were also used to control
> __add_partial() adding to head or tail of the list, so replace that with
> a new enum add_mode, which is cleaner.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

