Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2371FC72D8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 18:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09476B0005; Sun, 22 Mar 2026 14:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA6A6B0088; Sun, 22 Mar 2026 14:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0766B0089; Sun, 22 Mar 2026 14:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B988B6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 14:54:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E8FCBB964
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:54:56 +0000 (UTC)
X-FDA: 84574600992.29.A67858D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A221340008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:54:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KbmB1Xtx;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774205694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBkuFngdQEyMnpNjm5LdI5EcON1BgKgNSOoplTx67Pw=;
	b=7eVFsusPuJ8VVFYtiZdMnCYxHaaXVqdLJ0CXjZJ9vsn6f4ZW9xbY8MNaexet66aT6b0O9I
	BOvLA9n6BSLKR+O0CjUg/sUCYunpvHCiS6mnnro0sFx+jmDxKxT18O+vLF7Z+KFmGQibFB
	SEDMRBss1rfTbwaj+ddK1RtMeUqNz0I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KbmB1Xtx;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774205694; a=rsa-sha256;
	cv=none;
	b=cpJBk047nCG6Sy5Cp33wkrY0nMQJNMFushphzMyyqDEbjSUcgbKP4GhHCZAFYcaDWSVDOp
	iSI+tYSxW3Vz5EUx3AWxWKtOvPGAW8WurC9tZpEn9QCNygX30/+MoVUZVUA4Oe4xBSICxm
	zmtY7VnJ1HSiHh938c7sgjWjgvA6Q0Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D423560008;
	Sun, 22 Mar 2026 18:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D76C4C19424;
	Sun, 22 Mar 2026 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774205693;
	bh=qDXlRfkTodGjLro0lMquyx5e4JEwIwAwz0SCRLtlrF8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KbmB1XtxdXnVUQFu2CgL1CdVTVnsASwmT1kRt0MviAOlKnBlsR7NwVwhoKLCJVFgH
	 myDCAswoa1nc6i/QleE+LWmtVibq+L/5VtrmNzZT6GZIgPMpmDDQ35FXlSNZsEQsb2
	 vds9bqxUVciQ9kheMo0oOE1RJEWJhUupQ/Rqz/R4=
Date: Sun, 22 Mar 2026 11:54:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in
 mem_cgroup_css_online() error path
Message-Id: <20260322115452.29f2ce981610faf2d7b8df32@linux-foundation.org>
In-Reply-To: <20260322164943.37460-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
	<20260322164943.37460-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A221340008
X-Stat-Signature: t695fyqij7chkf8bhd5x4jbrbwhe8d79
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774205694-857888
X-HE-Meta: U2FsdGVkX1/LBNpzLbNzYzgPefhXKnfzfMryXJFHMBxImgR4ZdRBG80LW9RN+6NMqt3Y+0dFKcbFTc2lYXOpra5qToI8qsGGgo4yoMNJs7ashpvvdzyzvJBg+gxBQ5nrdVexsaBWLfXMHBiC1jcSMA1KMm4tFfWyMzW4Yqwf3Esa+acq5pIypr3/7dhKpxs6nQ7Eob6XdEGRyxErWridPXnQ/cth/EDO9JaNA1BmRG9h/5vQcivutl5kgvlWJbew8fH7UHZElijh8xWrDP+3HK/GmVt5g8MDr55yUtLll4uTn81dsKJQYnO4dfSFZfUrzGozc7x5DnHTiEQFZ1yIniNWMqdkT8S7X5/ElkVUa3CUQ3n4CZDXPtZfqo+8mTBAbvtFnCNxcGdvknm0pnUvJ8GEUXyfP7RUz1OhwXytQk/fYfnS6f07YorNF/rTJiPmp1O2ILR+OTBLvDh4VVzIGG5D7574Kh+aFyxodSeV3tIXwzts+JtoH3EgR108qQjc9htjJP5t21DuP41ITTKDhHnJlSdqSEC6tw2JCnOepdRcft8KG+Tq64652CK54erRpppFgh0c3IPiaUnWDFkTKuvTqXKSsMI+JgWWVero0FkS4N14wbNBEYTv1q7zf1X0DTKdJZL61zYehRctVT8LUmyHEhrhwi/F087u2baaGIHKyT+q6q7DDPT3GHBWMuo9EU+17BAKqCn6b6J1h2hSdKpdhLyzzBATyRKbcP+zo48igmw769z9NudcHIRhS0rXHaAFYio16Nrxsm1chqzYvW73KgNwMSP6p3slbc2zA3FvwTS7DAfFvnHNSg7uFs1c7mlcfaFyCFBhtVXocWabP7iUAMKLuU1Wd0CmZkyJ9aahymQUBAobDVvoXrzfEENP2KszOfuh/3GhdM7y2HxTebjSuUSrUq5jJOxLGGZx1WDWX17AYiHjTnrTw7YjgYZYTTGC+1PHx8kfPyLS2I3
 rz+GmX2y
 dN23ve+dTrEBgp0beppgr7502Hos11LlnP5gzYC4omcwJnrVQKJwy7z7qrFxgnpq604Tc9QifCATetjKELXsT6pQ+hfIThrzORbciQDT81ZWzL2yOwBo7uiPwCLrOkcRYYZlvQfy2Shh/bBXtu5ZtZzt5wvq2jyVCwyIt4de2eQbyQ0W6cyzlovzO9m3+Q8MGZeJqQ4oTvUMU3cERolx7RUUEePdymVzUuC4DJREbd/So3pkU2akTqOB20hTiU5yaMMAZ4lp+vNKSFMiwUpQAhBvfIGQfDb20g+FRkR/8bbergkd12RXmeUa/XHR5mvb3THrJHKFo13Xb/EMLHgA+8dxj/z001halmdGpJOYBbFRmo2A8CNhIXYQ32YWE9rZrIawXHjxEfWFRV11wpXB9s134Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 16:49:43 +0000 David Carlier <devnexen@gmail.com> wrote:

> When obj_cgroup_alloc() fails partway through the NUMA node loop in
> mem_cgroup_css_online(), the free_objcg error path drops the extra
> reference held by pn->orig_objcg but never kills the initial percpu_ref
> from obj_cgroup_alloc() stored in pn->objcg.
> 
> Since css_offline is never called when css_online fails,
> memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> normally drops this initial reference never executes. The obj_cgroup and
> its per-cpu ref allocations are leaked.
> 
> Clear pn->objcg via rcu_replace_pointer() and add the missing
> percpu_ref_kill() in the error path, matching the normal teardown
> sequence in memcg_reparent_objcgs().
> 
> Fixes: 098fad3e1621 ("mm: memcontrol: convert objcg to be per-memcg per-node type")

Thanks.  Sashiko review of this patch claims to have found another bug
in 098fad3e1621:

	https://sashiko.dev/#/patchset/20260322164943.37460-1-devnexen@gmail.com

> Cc: stable@vger.kernel.org


