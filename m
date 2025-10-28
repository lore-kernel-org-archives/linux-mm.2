Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6F6CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BCE28019A; Tue, 28 Oct 2025 13:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194ED80199; Tue, 28 Oct 2025 13:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2178019A; Tue, 28 Oct 2025 13:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E625980199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:42:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99CF216054D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:42:55 +0000 (UTC)
X-FDA: 84048243510.13.3EA3112
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1C88380008
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:42:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="smv/lP5o";
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vg4CLNWq+8zG0hFycm+WTRnOKvh6p+eUSvdTbVFbFVc=;
	b=o82gdNgkgDx/V8BOLGFpuwojPw+uBPqVG6ixQo4dHd3w/yKWReXiG/In4CSNA2vwjljgyu
	VZlmhtFt51IpTf6ciA7B3vPiEDCr0FznWYxsm/nfhdQgFqaEOFQIC9HC77aBZgwah4/Fl1
	Lgfrwx28AyMiostZhaS0ku0Pf8D79DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673374; a=rsa-sha256;
	cv=none;
	b=ih+jhgzx5CkdkcbTPWuxKMRLEZGv8ZTtzg+gY85GuAuY5aOCxnMLEVvguWLZntRy/OvaUS
	IDlkYuV2uPDZStyVavfJ2ag/7YG4TZg42KyX4W0AGWjrpOhhjk9xiIM606/fcf+JUAYoul
	acSeu3isZQQR6IFt1zRc98B1Ah5PF6k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="smv/lP5o";
	spf=pass (imf30.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AB98620DC;
	Tue, 28 Oct 2025 17:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188B7C113D0;
	Tue, 28 Oct 2025 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761673373;
	bh=O9h35W/5qIeYiR+aZ394LJfEnSiQZLZpjbezvmnwe7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=smv/lP5o9CsLvG21j5v2Heg6EF/lysOnQHrQpZJiX8DtUg2Lq+g99CODEbIkkrZy5
	 OnjRJPcTk2LkvWjG2QWv+/uQ0Ww+4DXzENNaOCqTBqeroFUrss8437dc7sS66Uzdkd
	 saBHMOWXQZgMHK0ZAe1/AA+uB1En7rv2Aefwc7TpOhguU26if64+pyj6FMRBrldQyP
	 0jKG+7WgPyu8hiTKfkeJC+GIk/EtN71fzJen24goMLtLwd4sZbowqCWy+tNdr6/Ezc
	 3z5sSEESJtbWEZHhKs1Y7lcFapuO723akp7KCBJlKkXmJurqWZgGNzlgHNtz186X/3
	 +mbeVR8ykC8LQ==
Date: Tue, 28 Oct 2025 07:42:52 -1000
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
Subject: Re: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg
 pointers
Message-ID: <aQEAnB7Gjs4vew8x@slm.duckdns.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-9-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-9-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam05
X-Stat-Signature: ktjk83aga39951s1rm6fbw6ex841uj3i
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C88380008
X-HE-Tag: 1761673373-918546
X-HE-Meta: U2FsdGVkX1+/xdMwOQ/51veGDHOhEuBr1gJ4dZmK+PgnLaKjqv1fH+r8NqKGFw4LT2QjlCs1jdsqwTna6quCCV9tLv1NiHTdplmNFmastyGP0Pke6XM3IzYwLDcyyY4Li5NOGRoLevMPtKWRf6R+gzfLLWNji3C/rkrG9ALkkrY4l+lfpTBtJ6b+lqtMhyVzqLs2OaTTaJcOl+legr8BooDPhRr8623r30zw85hmj+qsuKKZGjZcFhBnWoKFg1DjKfSLFBI9nfvlu1bITVNr4vr2fDiVGgoazczhg6j5gv1GOvvCXK6/cfIhlf46ZHlkhH2EN+xOLsZTxm6aKdO82828T2aTPeDLaN5Z3xjcTn6UUeeunmGnywpsHxewqi7PsA8z34gwrm6XWieEZyycfx5KigYjXkNqEpd9jZ+0ye/Xe509hKDJHHMFTAEBzQZ1EenYnU6V84obO9zD+PzDyYftDtEp0aatckRUsdREJBCHs32+aEyDDPr7oM6InT/O9HA82z9GEwQmWDdUn0QOCJs6yuM1FNC8BWCEnFpS0Wvi2rwwFt4eVlNBGA0Vbq+H7TMh/nB/6kVwnaOJEo+wGp1x0pj2vMb8mJX8UN69ZFqxe1EERvhkAmuZphSArNXHdkYyNi30DbCGdKUbP9up2n5++U2Dkh8DLrqG3X0mJ6n6atw9mf3gx/LLsvH//ARJrXQyR+KC4HfkIjaP2DCz+ntFfEkmp2jJZkhDMFY6c1Pi7R+56556PX7gowQoNZgIQN+spe17BFnPvJtaX9foR0FSpeGbscIpXDdQxhfINDxGKOJSr00hOV81z4yLPx2wZGmU7jWsdRtX7AlEYGqK357psHlZFLdH4z6M4+fIL9aMetEIWbidC9AoLHuVMs6AlKq043RF9TGKbozROpKBnNCXDLM6D6MtAoMVloSoGJ+jQo9ShzeTWkM+lGZqBODSJBFBcPGLqKcKZIbwMIT
 qFrY+eTc
 6o7GnQ4/+Fhe4XGpQqjb7H3kVNVGsbE0Dm82hnkCVf7t89FLK1SZZSvlMAKF7hZdGY5S6xKQoiZz3BQWFzlsz+8jeWTfSk2fj3kD/PiueDWKvnyGeBbNzYlUGKnbAmu0vDkJJ+ZEJypz8lUgu/OBrm31/D+wPQAAXgipWZT6RQIBrklBgCIuQDrC8Tvn3UOaELAubfzJyQ/At3qZxQ6Os1FkeZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:17:11PM -0700, Roman Gushchin wrote:
> +__bpf_kfunc struct mem_cgroup *
> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	bool rcu_unlock = false;
> +
> +	if (!root_mem_cgroup)
> +		return NULL;
> +
> +	if (root_mem_cgroup->css.ss != css->ss) {
> +		struct cgroup *cgroup = css->cgroup;
> +		int ssid = root_mem_cgroup->css.ss->id;
> +
> +		rcu_read_lock();
> +		rcu_unlock = true;
> +		css = rcu_dereference_raw(cgroup->subsys[ssid]);

Would it make more sense to use cgroup_e_css()?

Thanks.

-- 
tejun

