Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00649CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273828E0020; Thu, 21 Aug 2025 14:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224048E0001; Thu, 21 Aug 2025 14:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A9D8E0020; Thu, 21 Aug 2025 14:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F31408E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:35:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91A5E5930A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:35:29 +0000 (UTC)
X-FDA: 83801617578.18.55112B9
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id B401480005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:35:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u7Ere37+;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755801328; a=rsa-sha256;
	cv=none;
	b=3WNWJjzbXF8+jOp25uFByZ3BBSxWRayRDupaVb/ghetN0Rh0b40bI+hb2AHou2u3qP6Zf9
	tW/724Kdzk09gh6aXAETPg/mSBXYG6ock/VY4sugX1cxAxQoKq8Z9FKfOLW45/G3JqV33t
	WDamwvoLld5GV/bWmzSIr95XzS2y5gg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u7Ere37+;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755801328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYKvb2dH0bTbVOPzrM44BfmX5KXCxGsEa01RWtRNfdw=;
	b=5uTaJkcJr1FyHVq1wKNhjF+JX5m0MnHmjzVAyIXsse2rO3W9AK9rPXrTlfdbYYKMOqHOvn
	ekcdifCDht1v/sc457M5fvEnr+jb36wY17/UaO3zc1qdMa5ESXXp8Yz+Rf7n1gJnyu5qPF
	UfgY3VyqNK+IkUeSFe8QMXuXryMiq0Q=
Date: Thu, 21 Aug 2025 11:35:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755801325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lYKvb2dH0bTbVOPzrM44BfmX5KXCxGsEa01RWtRNfdw=;
	b=u7Ere37+9zchNOCm3RVOb4Y4tTbmmqMZwwRwzwD8nVr+Ux4rter4+q9m/8C9/kcuNGwegc
	9HEuDvjL2v+gNwk/aJEpKtXjS+Hf6MAcAO1dPhmdry5Uu4bhLth+b6FjeyzhMwmqFgudF5
	25yO/1kH8+xsZn1lqgEktk9bbFdloE8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
References: <cover.1755190013.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755190013.git.pyyjason@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B401480005
X-Stat-Signature: 9ktemogw7f7hyhr8c8y8883s9azukbd3
X-Rspam-User: 
X-HE-Tag: 1755801327-317927
X-HE-Meta: U2FsdGVkX18ICk5KFcW0x00kA30jr5O2LNb96whROLBRN6hMoIJENsoy1shWoLtw8LmgEPvgYDOyInhFr+DnxNuQhO2RrIW3npS6Gfxof3p0df6WP/rETQtU5v1HqQB0Jdo372luOP3rLOruiFqiE0QrFLTe4wROahj7g5PPSqoAoAe1psHBssVupMdJfr5suskBB1XovrHlNg+GuoK2WPgKumLiQRM7OVaUDZSqKQ1DAQaU+jjO5orhjdNM9WX38Ql2Bym3Dv4xJQfrALN39DNi4jpelVTWzU3NbTjL2m0W4Jx9HTH2Y2ijJL+PRrOlO6UIzMwgFDqhmAn/fGYvArHvSAG1JBSOoCAGY6AJZ0WaNi3QobBnJxDr7VeVeWK+xbvVY/v+kqBZQZ7l9ml+8tJfVsx5DwtcJpLxeOxTQHlaTrvknXOv4u6kce2BBOxVyLB5M4pCEAQ8jt3NJC+KePpwFPUXw0LpPKAfzwcXwPfDLPc6FWXqNA4Y/ut+6QKwEpbHrVXXyFud/P1BjczsalpLxs7kNLX4Dj0bNv4cjhewO451vfI4yE/no4cKaDjW949R/eVj2FNG40KIP76yYJq5QOrZmA7D4l1MbaoWLkYvhIWi2+2GIItSFAyy+9SzGifJXWWQ4uVjG3UOtlDkBybUYW0uVF2x5tFqXqHOhqi3ojWo/jIsDKbj5OWV2oW+DySZWQIxVjDeOjRF5y2VOeIKE13YmTtR0nz+ngiYQjWQVAxv2IFrqz513FdrhZUdehq4dXr2AqVvdFL50BXZBVVXItxZrYTfAedL5NxKDhzNlRrtqTn4OcdF0MIuyXMVxBN1VwLbPxs6z2n9e5sXIijxX0ryr6VAynwI4BJBmATaOjoIBdR6V4gjyln1NaJlyD+k+TS6w5ScICRz5dzmHpmUk1nsHI1mSAOP7WvmUU1w7MSKmc8wteuuiRhlIflNSIDP/b+MqpgLYamqORP
 OW6kA041
 NTdpGDXMGqFlO5beIRz1Sl4IUqPiRk1dp+igf/BTR6qF0NEkwQKUgFO2LHXVa1jFFh11XaOGXRW3lI/Y6OMWtqbL3i11UTV8pwxCBwhWZGn9K9ZhrsAA2MIksZ+6nBUdv5Xr+uBk6m4X+OWhx3zK6Nqumq4QIjLkkflsz6igzsE4KAPKmVHlk+6jIRysxGBFU5g1l35tJE+dxJrNSBGxxzhVw/jq4Su8QFfWB6TuBu6sT1KY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> Right now in the oom_kill_process if the oom is because of the cgroup 
> limit, we won't get memory allocation infomation. In some cases, we 
> can have a large cgroup workload running which dominates the machine. 
> The reason using cgroup is to leave some resource for system. When this 
> cgroup is killed, we would also like to have some memory allocation 
> information for the whole server as well. This is reason behind this 
> mini change. Is it an acceptable thing to do? Will it be too much 
> information for people? I am happy with any suggestions!

For a single patch, it is better to have all the context in the patch
and there is no need for cover letter.

What exact information you want on the memcg oom that will be helpful
for the users in general? You mentioned memory allocation information,
can you please elaborate a bit more.


