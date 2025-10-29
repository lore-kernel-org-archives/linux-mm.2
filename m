Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529BBCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E2B8E00C4; Wed, 29 Oct 2025 14:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE778E00B2; Wed, 29 Oct 2025 14:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B728E00C4; Wed, 29 Oct 2025 14:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 733BC8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:14:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DAB1C0730
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:14:29 +0000 (UTC)
X-FDA: 84051951858.22.3D71E70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9108514000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:14:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tj2Sop8s;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761761667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv/0bffyIQDUSuNV2r16Rzj+mh8NfZ7idCVtnStQ8tk=;
	b=DW1Srbf4BW5b4DQaZcwhpz+2CHWDNhjtxz2TFmhibFvGEjcwWjTfatE3BNcgyE9FDJ7HJM
	N9xMJb4CYy5bfYPmd2ahqa9nlh2FBMD6GbRnc374llWPCkJphyG+916C+0LQ/vcq5yYMIB
	rtNM+4PfuJNJgFuZePRU5lnHzh9jkMM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tj2Sop8s;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761761667; a=rsa-sha256;
	cv=none;
	b=yOpMrHMuBSATBgkdLWcEKTSSU6MFOdUsPF8fJ3sPIqJnLGR4lLigVqGCXEEVQUzg+sBnoZ
	TtdIYf6H5AWFIEus0IRWsZ09LevnZk8JbVl4Jy1nAu75vZXjBobFvS1FqWDifb7E0zvjGi
	vTitRAXMDKco/soLTGl2VjLZaGNmDwU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C311061DB5;
	Wed, 29 Oct 2025 18:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4485EC4CEF7;
	Wed, 29 Oct 2025 18:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761761666;
	bh=kY1V/QJFs1h44N/K6efseCUY65CASyAedOZu2/bpKm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tj2Sop8sSHOaqPkc3ZcouOA0BeyHTP/TNIJPDnKa6OL1M1cai0IJ12t6rUPYhMo5f
	 aQ3nH2Yw94Jwug09AOD/tfVe3pKBeC/FCu84k6NzjnZwashb3wRtAKjpa3GP/XYHlS
	 kzgxg0AZsJVSe/bGBGAt+mn8DNraSO0xzFSsLN/CYYqvlTTJHcwNPcMf+jVzseNy2N
	 Dqeff1I9EkAZDxmvMxCjL8X6erqZTxddlEl+VwvhBEtus7/b6vjybe+uHIMe6rSgNm
	 6xOPif8V1incnhlbEZa6wBVHpQarnjv9J0wWGVYLVYkJbvXRrCAZ/TOi4TmrR1tEry
	 IAUdfrT8XT33w==
Date: Wed, 29 Oct 2025 08:14:25 -1000
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
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
Message-ID: <aQJZgd8-xXpK-Af8@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-3-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-3-roman.gushchin@linux.dev>
X-Stat-Signature: 4yrz8wzkn7kmw816f5ecx9ka13hhzdj5
X-Rspamd-Queue-Id: 9108514000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761761667-553804
X-HE-Meta: U2FsdGVkX184UfwmI3KybsE9sp+fQxvwcv47pdOJAD4c0fH13YOS84LHQcAdu85wqzetEU3WnXtxLpOjmU7QNWsAt/gJQr5ZVta9SFWlm/RprwskujtXJx8r93qVkYuCiKC+3sV2SnbKGHUGXG/axRACINqJnMdkkNyz4HHX2X1Wh7pXLK4/zZdhhSHW900OY865rxz9TduuifTkb/Wlg3DFTOa6NFuxywaP2NARzY0Y4PT60VmSavzD5y8HYtLNxnQlfhWIw/Imp7/SIMVl+tMcYYRLQ8SWDA9ShOAjpP721aTuH99c/mei0CgHABbxIaRfTNvgr5Nv7FGlGDnwnhWqi56GH4jiGyOjXDIxkvqanhW0QUWXm2fSlttX9Ha161/Qoswa6TCR8S1oZFhUTWQD5KzpOofMvlTTojhJax1y3NBO81+xV6lYNJzJxqJWlLdPmdvp4I7XQlWsxxx7XSo+XgstSNwLsrUPyAuGllG0diNF6iWOOIIxpo4n4gzRQCBTJZanMYwFOKPELnyPxRXyNbGtXaeOux6mytwzZ4k71jMLnS9+7xhe8voYs/NUh+mgHFitnls4/jOJTjhZEzRj6a0RV8rblSnxNQDrTt/5yNnrMbkDPVvZQS999dq6dLnhSn8V77jYMMqTNbZkU3EN3m/DrXNHuEPkniuDmq53j4u5Nar1vUZAXHms02rwFXk9lxqRg1KF5BSmXrdXuoIaH3uqnVcGS3puQvd9eOteJcNb7D/K3n7zy2+iKT+S0DwnyKj9f1IONU+vNpOkoP0BSseAVQ96JYTh844Mjqy2IBOLkMl9trXmxsSE4fgXOUofpDytt1+vhAEbLwgbkVIWKNkN/6kRH2eHaUtDxPegIVj1YHnexUSG9mR48DZ3wHXOiGHqZQiEgTzDktALmQt1jcKTTUQS0a2haeKAm09iXJ8LUgwBlOpNB3H5D6m35/p0qbt4sWiP5GpNHIm
 9c1LXR3c
 DMDv+76+CIxFwFSXq98NZbHcU/BQGzcyMfemdyQ+czUq0VXWQoo8j+EVittD4NpwtK9xCMlgezoCjFHu/0Eos5+rZThLmkVhf5QRNQggCT1nl5cio/FSFmvwJWivtHO6w9a0x4F9m3xyVtT1ELqSECuUZq34/UQj9NiuTBycaLCYKJX9CBmSb9ITz6oIXBcp7z7+ixp/dq+qBItDYb0VWRHjnN4OH060WUube3YaSUeUGtyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Mon, Oct 27, 2025 at 04:17:05PM -0700, Roman Gushchin wrote:
> @@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
>  	struct bpf_link link;
>  	struct bpf_map __rcu *map;
>  	wait_queue_head_t wait_hup;
> +	u64 cgroup_id;
>  };

BTW, for sched_ext sub-sched support, I'm just adding cgroup_id to
struct_ops, which seems to work fine. It'd be nice to align on the same
approach. What are the benefits of doing this through fd?

Thanks.

-- 
tejun

