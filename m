Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42534D172C0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 03:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BCF56B0088; Sun,  1 Feb 2026 22:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340946B0089; Sun,  1 Feb 2026 22:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C736B008A; Sun,  1 Feb 2026 22:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1602D6B0088
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:50:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5D6513BF75
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:50:57 +0000 (UTC)
X-FDA: 84398140554.09.240659B
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF50110000C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:50:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQQRCSOn;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770004256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/nclWki/7xNBiIlkN5lOVwIekiG827g6kvt71oYAjY=;
	b=LxacVqlIrJOfA0IUbEErlBn2RjZjOxOSyqS5bdbz2hhxVYcf4IVNmIwRD8BqGAEXOA8yFb
	8iVClaqbXZYnG3zeuor9sFW3NC/Pl8gxsQShPnn0JHdmntfD931lpr1ktwrb9+az1JPLFV
	8Jcx/JUIJnBzbp/ZAd5D4LrCM3uTlJ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SQQRCSOn;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770004256; a=rsa-sha256;
	cv=none;
	b=xVSUPoLtMEcfewNPncej1y9pSlawrYy/ppkkwlGx8oOYAB7Hxm0K5JnW65QkZ/kEWFt8gI
	0m3pFoAwBS1XbknRWo1q7EBVb+Yt72gwdLmFB2Oc5ybuECgXi31YozwnCCCrMWwBvYKUKI
	EcfgwgeH4RJZ5nLN8o24g9OK2Pey00U=
Date: Sun, 1 Feb 2026 19:50:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770004253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/nclWki/7xNBiIlkN5lOVwIekiG827g6kvt71oYAjY=;
	b=SQQRCSOnhRwyBJOGTKoC6hpkHmmhG9xPQf/BGFGZU5QS93z7dnK2JuOTM4uh6b2K6vOsB2
	vKlJ7azzBawiw2ZNaSlUuW6LfkngfvK8vfVulMeJ+dad6OPIMrCb7EulMaQfMvkednXjqA
	LwC8zYdx1iieZpj4bLmKk2/eqwkIiEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 06/17] mm: define mem_cgroup_get_from_ino()
 outside of CONFIG_SHRINKER_DEBUG
Message-ID: <aYAeex9xM89Bj0jd@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-7-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-7-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: pmm6sib8wk8pmtmo675ctagrymoagsae
X-Rspamd-Queue-Id: BF50110000C
X-Rspam-User: 
X-HE-Tag: 1770004255-506795
X-HE-Meta: U2FsdGVkX18EFDSVphZL/zbOnnnpxs+921f0bkwYFXnMe6qgQ/sioFRw+YXXcIN+ZAtrCp+xbt9ZEktYSK/aGdOB6JQkJzBtaVVMQxbpc1HuSrmRpz6fJfxcSPEbua92xXYE5xiNGchnoaZPYsdIm4l94amJCa9/4vwoH/xZ6UVud2SFzgPu3WTuwvyqDDNvL5oAy5OZfRZg81qGzDbv4O1mEVQF+RrlNGIi7EYo2yNe6yCAzpy1r+HF37DslJzjUd/nMwnsskCi7otzWyMW/xykRDFeEFZev67jIAcV9iD7NPg1C1XmzwZy9k5IarZO6oPzjcNxgZjPJxvzMM8ncSOxj6iULcTkcE3AMuL9rmi6HELfICYfFT+CJBXo2kXsTiZg9boRuq81iwO9Q5+q2OsKcg7Vu78HUsiEvsOhO2ZO9+4ga9sP23RkWXOKpyC5Vv1LhKY7pVHBT9vjJdWDFYO5e8LAK24G0c1fRskrrFo8N6dc47tZjQpAQpBS8RtsxWgmgZxtI9MHulcY9n37Tvx0Utq39hdsuig7SwLagoKzPr9Gn0LFcNvv7Wa3SGKQ7euSSqo13jp/nbABeQc5/34XvwHqp9QgKxGYOpphjDEJoDbylhujhxD27nP2cIpckj1212JSWJHXg0gPQ6xVbo6JcDqnf5pp4lOPySKwVb7wk2sovMslmKyIu1jpeDcydqcwaf+P0aIwnuLSfZvJqtA2FhMaFT9OQiPWCaHbhSMyn17VFucC+agmcpej8BZ9HK+qWg0BjNlozj5x5JjdigW8G0pH1qv87Pvk8wV0Sx0jAvo/HKWfEGG9/ZlDMhnYPzsYX5SpUcPHeLwdWvMTsvcBs6d3sQk82m1MrU0PI1Mny4sl3gjH7flBdUgh+Ykec49PWI2epMiR2+YVD0Y/GC1SEJhuRyqXB7NL0AsDQphJY/8eCodxIkdaFe+B04q9ggLyaBR0TsACLCawPEY
 /CevMbvC
 12obz0dRuvUJuOWO2w1G9N8S6DhIN8ifTs3reZ+LObDllvIEGAiyAd59cRyrgopnwqFmGNXbf7S6ZOHJmnXZBagEr1NIZEUFnv1AJPBtgKKWfWf0YtZrS4fbHljBBP7QoovjkpO6mf6nTcLFFADg5nMbxUUm4xCnZPp1p+52HDPqaRhBhw/kS7FkCVP5HGl+ITpWuQ1ML6IbJ+bLT5Y3a62gFYmEIhyJwioSj+/vpwHxKEWg7O0abB+wx1c6PpA47QaBEesqDvifVZkYlg04xFN9R4CRuCIFE4oh47mzyQM3pS13ClacUyuFAqe3T12a4TAPz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 06:44:09PM -0800, Roman Gushchin wrote:
> mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
> but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

This code has been changed in the mm-tree and you can directly use
mem_cgroup_get_from_id() after changes in the mm-tree.

