Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF8D2CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0157A8E0008; Tue,  7 Oct 2025 16:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09048E0002; Tue,  7 Oct 2025 16:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E451B8E0008; Tue,  7 Oct 2025 16:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D33518E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:01:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72DC71DF43B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:01:55 +0000 (UTC)
X-FDA: 83972388990.09.38BC4F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0DC8140012
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:01:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M0HQm81i;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759867313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/qTENvypN+T6XZscWhWXyKYPpC65ZHTocsm3lY0Di4=;
	b=z/U7UkGXqP6TfWikvTcEojyY8Gi+o1wm4KJmphJelaLq28UYgxgj9jbnyOD8Zs9VIao9fx
	8NSjq3lHPY2gAwCSC09Yp/wGcq1/zSk6nl4PdOSsPr/mHXV5jR1bOx+SFx/rGmYng1AKgv
	DObHyKLcNygySq5qZzjx9BAY76qAJYA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M0HQm81i;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759867313; a=rsa-sha256;
	cv=none;
	b=zxQ2DOhf4ms8xVJ56NYDEU/tEB6Nzsa6ALMCkLl4XIByP9U4R5r8Cvd0Y+b2NLoupM6uMh
	3Hu++MHU7mum/XeYbpV8ihDj6WzTmBHxWHI8inJP3FfdtuGGl8uGX8p4rGtVtNfFOWF9P9
	6ztmEUQr6tm5WVAeqCV8uh+KWxn1Mpg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34A4F61DD5;
	Tue,  7 Oct 2025 20:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EC4C4CEF1;
	Tue,  7 Oct 2025 20:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759867312;
	bh=+kd6dOZFIOmjSNgpR1x2QwO0MCg1WYh6jGTABkyuXDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M0HQm81iGSKVFOSxMqCnqXlOfEFv6hvpPMcwP5z48eSQ8imRIFnKsFkYDuHgsujXi
	 PVKhmKCkmd/rNYLZfVCRK26CLzqWjHR0gkTPEUhMqHEzj5VnzwrZ5v80ZG7qF7vWM4
	 zv6c+msgQaKvsRbf8770PclbOK8w0Ng779bXGzs+0S/Hd0E/+8EILbjN0zNPDjDDSJ
	 MS05VhZrAGsvSMKfRsyRgwCL5Xtlt4a5IXmfoyNWToFbxoXCPGKftLyOmc+odxx4s3
	 Hf6YsWifRQO0YIkeq5gwyP5PqlWbk8fR+H2zwdairp2bJwwaImKb7Scu4pfRUak66Z
	 aTfR8LfyzWxTA==
Date: Tue, 7 Oct 2025 10:01:51 -1000
From: Tejun Heo <tj@kernel.org>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
Message-ID: <aOVxrwQ8MHbaRk6J@slm.duckdns.org>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
X-Stat-Signature: 4zqtsqce5wu3qdqyry3ptbdp75syk3p5
X-Rspamd-Queue-Id: D0DC8140012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759867313-687752
X-HE-Meta: U2FsdGVkX1+haysHQ7SJfN1sYzr6BEV3PU/jiTbnx661f/2i7VrXaHmi6DtpOB4nUdmmHP6Zgwhd43jD827aPyH3euLO1WqO3dyZyoto7M2wg+3YC4nEq+8y+7MEtSivPXc6EOTsf2D2I+WRloFPAJ68a2VROl8Ixx4UMQ0f3+JHgbDMLChEmeaVqMkrEPnAVD4TOiPKjPhilAylQ9OIbRhg9BHNAc+3nUfSWvz1cteFhgl6+eUYkZ1FlPnIPQSJ9ytta4SnGt5PbmtUAmZm5ZlDRtEnUPbsz3Miuwpw5ABmBSQni6WphvD3PNg3AuB7O+L/tQ0TSAYjlv240hWy8n3qSUgquaGbrVt/RFu3hFvdsBfuqPytl4VfonQYLyJQBL0AKfprf8EIWh7VqJCrFQnwKqgJ30cq31eSSQ8SgVtKfzEvfHwpBHllHy0ts2esveQ5L+MLYjUlYSnmU52X+gVC7EviRFSoIzmeezuFWJPda5j5yK2h2C98Kw1cPSyWfpVgekwq4PQZmUfM1ks0leXt9jw6nTvJQmr5glwkzMvPk0gkvrevLRZq4kSTTQu+aUfcMEzHQLdKLeY5DEe+RChsX3TngMHBmweOGMSn7vfGXt6knK/sztTwGpIwcVAR41BVignj5Krj/FZll8Ppi11RNdlOKP0gpCHwINwb1AhFVzc9Pz2xaq9d6GmOkVC1aPOkrCxpntt7Ozxi1I0UeFITZUvfjmKyx0dcHmfkY1uMYRe+INcIbXMZ0/WcCbWQYVesT0GRB1IQvZnIp/+RGdwoNdrItCtKVU/so/kMa6f/btffBILG/Go1rND4SBR5suPXmMxk2LE14wcIDMi7QzskO2PsaWGh5w94KAwBNWAtAxIrTXBpMmS5UIJL7+3jItviQefnaqMu9Ko4c7svLwkROQtRJHwMtWi3jHaapaqxT4RPlHXf4KMQndVkpf+AbMzuTK4Qq03k3BYEXLx
 Sb7Mflhj
 TI8jSCnWcisGabOyWp1iKi9swDy5zRMweFbCrj5XLCYMRTbxVi8hpf2nNqKPuz39sZDlB+0NQb6ng5AbymL+H9FZ9arHbctlycqn7iNIHyXeR0zVEpB+PIkINJP2ASMkYLM+9ngB6028EOByZnC6vcuBOYTYhNg9bivWwVPlErrNGEmsHysDDBSef2iJK+txbSXGbIMopj9eBQRKynEbmnJdF4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 02:50:56PM +0200, Daniel Sedlak wrote:
...
> 1) None - keeping the reported duration local to that cgroup:
> 2) Propagating the duration upwards (using rstat or simple iteration
> 3) Propagating the duration downwards (write only locally,
>    read traversing hierarchy upwards):
...
> We chose variant 1, that is why it is a separate file instead of another
> counter in mem.stat. Variant 2 seems to be most fitting however the
> calculated value would be misleading and hard to interpret. Ideally, we
> would go with variant 3 as this mirrors the logic of
> mem_cgroup_under_socket_pressure(), but the third variant can be also
> calculated manually from variant 1, and thus we chose the variant 1
> as it is the most versatile one without leaking the internal
> implementation that can change in the future.

I'm not against going 1) but let's not do a separate file for this. Can't
you do memory.stat.local? It'd be better to have aggregation in memory.stat
but we can worry about that later.

Thanks.

-- 
tejun

