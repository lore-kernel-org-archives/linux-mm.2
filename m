Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4972B606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g565L9wk
Received: by kanga.kvack.org (Postfix)
	id 455CD6B05B0; Thu,  5 Nov 2026 16:16:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4070B6B05B1; Thu,  5 Nov 2026 16:16:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6156B05B4; Thu,  5 Nov 2026 16:16:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D97716B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:16:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46CB412088B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:16:56 +0000 (UTC)
X-FDA: 85402325232.16.DDE00CF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A278F40006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:16:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g565L9wk;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793913414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VxizPleZhq8HwEA9+OGD1/wqtPtl9/FGqR/08An4bnA=;
	b=X1CCP3SeC3zTj4gjMndi5z/EOexNE9JHKGmVI4qR4zC2aw6CeOC1cTS4wz0A3bqPeWevEt
	r/QH+cd5A4vNuUf8i1IcnJsg4/SlhnlDhlDkLD4aggAUicIcJ5uLRHxnmB22p2NSV6asBe
	tjcE5P1fE7Fa6j5G4J0pl2EEmkvl15w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793913414;
	b=jigY+6J4yS15IDu+C35GpvZz0X37m8tPf26wIDjlw6uCV4KGjWOpH50kurYOpYMe6ypqMy
	vpMBzAb9bmEv7oGBZTv/I2Jq3pKCSA/njUHbYh0MPK+f/+6GXc5PMuVaJYDhmPD3yLLoDj
	/MvSzlFnewPsus7umLpuHlD58xFbl/A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g565L9wk;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C52E14122E;
	Thu,  5 Nov 2026 21:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0229C1F0089F;
	Thu,  5 Nov 2026 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793913413;
	bh=VxizPleZhq8HwEA9+OGD1/wqtPtl9/FGqR/08An4bnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g565L9wkD5iSSuGFWKDuD3r5m/puCbGyJJCo3TJWpw9Qk1mtMlX3Vhu/zaycMuZyG
	 8WIHVCle+3SB5Y13eRo9Q/o/7luBCPOEmo3Ccnjes64p+oDk7jULazfvcBLuq5BP8p
	 ejZYak2vpyWx7teiB/ViaVFVVt4nGpOAS2ngNx9Jp7VKECYVgIb8o7HI8C2fDkaeJh
	 1L+iyjnb+5rRrtkH5nQw1QSEFedeiKX/TPIZiO0SCv3OgZGZZN310wOQ9GXsMclAs+
	 7xgKYiEZJywRJ4oAqp4kOsDiORP6ys9gNtrwp9RMPZcFAkHKvefz1LLsVqo4RSAXPT
	 MFSEB1NF38ycg==
Date: Thu, 5 Nov 2026 22:16:44 +0100
From: Christian Brauner <brauner@kernel.org>
To: Chen Linxuan <me@black-desk.cn>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v4 3/3] pidfd: Add task path ioctls
Message-ID: <20261105-fotokopien-essen-inbegriff-be31e4f3c8a6@brauner>
References: <20261027-pidfd-get-paths-v4-0-e2a6a47e3c95@black-desk.cn>
 <20261027-pidfd-get-paths-v4-3-e2a6a47e3c95@black-desk.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261027-pidfd-get-paths-v4-3-e2a6a47e3c95@black-desk.cn>
X-Rspamd-Server: rspam06
X-Stat-Signature: 3bx4r1696hqwz86bcnmgtswo1n1tdmmi
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A278F40006
X-Rspam-User: 
X-HE-Tag: 1793913414-721183
X-HE-Meta: U2FsdGVkX18Ikz4hOKmmgNHzYZVEyaqo/we48aG8jbswnKgjTaBE/Xxqw7pITRT/pa+9imjXHsJ8n8i24KlT2ZCyWypuVC+iHEBHStU8gq1vilw7jWjHyAKdITmm4hXIOpcs0itB86ejbXI4sDjjZXDJmLG5JpMq2EfrTmInz0cbv4g3e98SbXyhTqTWecujU+7fv0viNDBQOgb7le1FFJDKGFtQA3tbHi/xkdeXrsB/7TaWZZU39BuYRaPYWcjibgbkd3if9q4t90xwtpgPNjVTQPAZPOrNHTJ/BZ5fiqrOt4JTQIUyNzxz5ntyjAiGpBz9PSwJXLidhmA9eqo3Y4Llpee+0P6HCTMyR5pVgG+la4l2HqkIFLXpAcZDrNRPVTc9FB0jETEYDOEx7Z1EhiF8p7LdljhviV3Ko0AglaqZpz49c/TiAkjeWzh7aijw4K2g+U+T0Rmr0ZQfZZEmrZYPjRSdgHAENuWzQCk4b/ybqAicO3oXK2vXvve6/RGRZRnT4wo+RJ2Hhs8HiP4u5xj6EjgJw+iJ3zcbOPhFEcjXeCOnrBl67gUq96ibQ5Ab/yTqLpFyO9zDVPugZA5nAFQBupMnFfRdJuoHHVdw5vkuXEJ0sXKYObqJzKHOZrnXZc3CYFNZHp/9okGVTPp6R0Suv1LiFgIpGpeFSAW6P90eouCAultCD7R1CAaWQOcFGT03KPNp+pB/ocXj9KM12NYUigR7utUbg1PjNm4Xle2oxpZw8TCQtlEySRAFaSDoV4jtr/9DNVHnVxt4bV1EzXys9JYclbrTmsF4j4rA+5ow00rTpHrvSYhTiHzaC13+lo5BYRmCIQBVTg3tSBkCS2/fTJ9fPHGDm1cltLkKjSTN7V0e0nfQwpUetfaEojNvD68wcqUUZh9Vv3A0EgXlwDmCw0TjiNMR1aRfYrMOt8Du2w3B7l42gmiwFHAQ5weTIt9+H1A+hXLPoE4t0eK
 gFjCke3T
 Tij34cPMk2pZM2Pn5XDxDTLsLiqDywmRXyH1B0fpluT8XUiziuW0yc3/8KalZAr4zgLlFrOlTXdqJ1tX4CpYQtxsLeXcDIOdeQoZ5+hFa1/hnX7yMFpu14Jh9AWgTxMuRJltoiNJFdeJl36NqIZTvwXcrZ3wQHU4i3PqukM7Ki0rx/RC6q8dgg76HloyHq7FTZyjwhuwLTd6OxVidyBH08pSPvQxpp4ZvgfWJTmXW2J7VM/jVks2qHL/NGRvoutz3yv6bahyvDOVljqI+LC0NLdvupq6edbaPQ8HQIKBznjOPEcRjiqGpanPG7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 04:46:09PM +0800, Chen Linxuan via B4 Relay wrote:
> +	case PIDFD_GET_EXE:
> +	case PIDFD_GET_CWD:
> +	case PIDFD_GET_ROOT:
> +		error = pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
> +		if (error)
> +			return error;
> +
> +		return FD_ADD(O_CLOEXEC,
> +			      dentry_open(&path, O_PATH, current_cred()));

So the path we take from the task is a jump target, just like
/proc/<pid>/cwd and /proc/<pid>/root are. So complete_walk() runs
->d_weak_revalidate() on them. Without that a stale dentry on nfs or
overlayfs turns into a valid O_PATH fd.

And failfs relies on ->d_weak_revalidate() to refuse pinning its root. A
task that fchdir()ed into the failfs root can now hand it out through
PIDFD_GET_CWD. Which would be breaking a guarantee we give. So we need
the same check here. I'm just not yet sure how we best do this.

