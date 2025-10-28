Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71F8CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:39:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4981801AF; Tue, 28 Oct 2025 14:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A208180199; Tue, 28 Oct 2025 14:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DDA801AF; Tue, 28 Oct 2025 14:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 840CF80199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:35:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C54CC0550
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:35:28 +0000 (UTC)
X-FDA: 84048375936.28.9E45290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8507240010
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:35:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DkXPJs4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761676526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtZ1eEic9m/s9FzpFVABmkmTAEDtWlFchXrIVdQu/EI=;
	b=pWS+LphweiSsroYk8hW3AcxZYCJPRNR7mGZgpnq2wMtbzDPwnlsxLIpDi+V1XqUy13+lGt
	jrtcDAP0M0GYnmmsF7pbugnF/xRAgBuLVeLeHcTdDdK7EJuE/yNJCMig1ycJ2EvIkTSoQ4
	SBMpRxFjVgZdJoeGJmiUjDwSknjJbww=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DkXPJs4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761676526; a=rsa-sha256;
	cv=none;
	b=k2I3wrnvMSm0L0Ss5LVBekruRuexoZOCZcmMDrzi553crbf6GqmlY8rKg99jdWscQVdNSB
	tr//E/NCq84U72KnFpRoXErm+xgyVcq5e4rCDwb1bkqI081tMyLQgRvKCSJcyxMGBpz+iw
	DRh/bbJLZkx0rEDYENgg8vgC0TuzCg8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C2B4060408;
	Tue, 28 Oct 2025 18:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D9BC4CEE7;
	Tue, 28 Oct 2025 18:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761676525;
	bh=3UXcs294ueg+A3S/kQ6Q1+2MpVpVfHJWY6pMkZKx6dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DkXPJs4sEEStJ7xMb9Lw05H78+Tq98eFF3dp/5EIhMxVw5bC0VmVS7kDVqdn9YQ8G
	 go8ovk54Xd5MkhILdC1Py/3syiXhRYBuPTUTWyoESIZBV5Cx+dCBN5z0x/pM6ir5Mj
	 +uadQz2fg1HM0rdHBLzv/EP0q8gBoiDN9ZZ4DUl+/otcqJWh4w5YJ/2b3Z3Bpxmx+g
	 w933E8ZFI+ovX7wmOXRWafB1iwb12qgsbxLECnywJ/f6G16rTrmb4JKN94J3ull9ag
	 aVl/MvLP16BxNChdQH5i1fX9ZlQxayd6lzjU5G/UBpn+Xc+7+o/xILIhZqTOcthIeQ
	 HvuNmMrJaMfBA==
Date: Tue, 28 Oct 2025 08:35:24 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 20/23] sched: psi: implement bpf_psi struct ops
Message-ID: <aQEM7LXpZdOpsgvU@slm.duckdns.org>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-10-roman.gushchin@linux.dev>
 <aQD_-a8oWHfRKcrX@slm.duckdns.org>
 <877bweswvo.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bweswvo.fsf@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8507240010
X-Rspamd-Server: rspam03
X-Stat-Signature: owe7fiiexgxzhjwmbp6bbid8bpo1koxr
X-HE-Tag: 1761676526-248029
X-HE-Meta: U2FsdGVkX18wcRbWYRRo2O3GxTovZRFjY1rW4ljQBfMJlgLXts5mSu4pwecqndKwa8RFezUwXub8/ALA1SJarkAAROpTHxIwEaJ4Tw1RuRWHAtJlq1xTjhqUScB+IENIRFcwmpOxX/PRMeAm8+NOzZ43mYiN0mYq3hAQipfXkR94TQj7HxvwWypEY8ITCok2WkcE9JneRwOcXrVIVcjGnnC+VjVli1Zs013uNX+Nzo9GPm12GyMVsfeq1LB33f7osGPfI4hYVBnjb/MXWjQmwJLvNavtbsCPwKjb7PxBbj9zJ9rmcw1FP3aQPSdJCF2lbzkK/FDpoVtNsaXlYBzhx3prtshS5+sfCLWigcTzvhiceSOqdfqEQHTR9B3PCEtlXdNgtHpiBGRnf/WH0VwfevebTDw62IVPQnIk22SpVhHfFiWmTbgFujuTuyR91ZWPfL6iBe+8t4ZDMoM4r1eGf3iQDR/WwDd0ZvfkZELv4YC2iuTngYAxUW1K80DQ9uqVEAjqs1zWkiH4fxIQ07U/vR3M2epg5nJIamsvQ4vXYZu51yhfa8kYxoVkjpKSJtk5z7dF9SGDfZP9+ufK1l9rmAFF4oivsS/bhNGdSAAukSmRbUQ4Ay3mr44k6EDRwFtKKKuxxJh94XnBhBw0Sg4E3ar/PAy5RTpv+blOJZrrSfU0Ati2nuM6EMNB5AKNKBtFhX9VLnipBYrfbh3xChLIGJsJE3j1YUHGKKGsraB/Eh5seWQ70dZlIFQ3opnHonRjIG3lQqY+naxvf1DK2F1lvoOHKTJeDKo8uVfJM3Y3FwnhqpKR9VwcLJjUexpR/9SiJZMMZzKVYnc1PKMuKCLByzqAhcxAt1PMon6SNAG4fHKplZw6lKU9j7C9PHO2vi3GU2wUw2nwgVDuLG5rE5V0XSpMX7iXZr2kNmDG2dC3cv4S+fzPn9s/VF8RY3izoaaDdqAiMzHkSFkjBguigpj
 imQGGYU5
 OIYz/fBU6EBMiFWNLbWRWd+JIpmVPZzC3FJyRCPw/NwpNWu172j9ndceE8ZZKOWR6WegNzEHnq4uQ0XSnT4QSFM3eqTxN1Xq3olfopiaYky3g/GySKvvsr24XW6ZDSbtKoOLJ0LSkHOUBUHAkQG9qKkT4hbe2S+i+G3onbIE1Jk63gaBTnHwzKCYS5dx5wxJHlXwepZQ4ptZJFCr9pOg0+VA6SMWsHG2C0XKODShyYRokyRDhf94CmIXYFmLht4+wW7qY7I9UEl0Zp6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Oct 28, 2025 at 11:29:31AM -0700, Roman Gushchin wrote:
> > Here, too, I wonder whether it's necessary to build a hard-coded
> > infrastructure to hook into PSI's triggers. psi_avgs_work() is what triggers
> > these events and it's not that hot. Wouldn't a fexit attachment to that
> > function that reads the updated values be enough? We can also easily add a
> > TP there if a more structured access is desirable.
> 
> Idk, it would require re-implementing parts of the kernel PSI trigger code
> in BPF, without clear benefits.
> 
> Handling PSI in BPF might be quite useful outside of the OOM handling,
> e.g. it can be used for scheduling decisions, networking throttling,
> memory tiering, etc. So maybe I'm biased (and I'm obviously am here), but
> I'm not too concerned about adding infrastructure which won't be used.
> 
> But I understand your point. I personally feel that the added complexity of
> the infrastructure makes writing and maintaining BPF PSI programs
> simpler, but I'm open to other opinions here.

Yeah, I mean, I'm not necessarily against adding infrastructure if the need
is justified - ie. it enables new things which isn't reasonably feasible
otherwise. However, it's also a good idea to start small, iterate and build
up. It's always easier to add new things than to remove stuff which is
already out there. Wouldn't it make more sense to add the minimum mechanism,
see how things develop and add what's identified as missing in the process?

Thanks.

-- 
tejun

