Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FECBF3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BFBD6B0092; Sun, 29 Mar 2026 11:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349A36B0095; Sun, 29 Mar 2026 11:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237D16B0096; Sun, 29 Mar 2026 11:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5456B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:12:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A47A114047C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:12:23 +0000 (UTC)
X-FDA: 84599441766.10.48BB558
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0E4DB16000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:12:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4T93kwb;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774797142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PheHktpL3Rp91F5gOB0+0XeVD7Vocs4mgsoUPOfBDgY=;
	b=Ir/uV4MPlxczQERYCv49l3B7bCYFnECT+I4gmma3Epeb95h23ScZuaI66O3TUs95HIGmcf
	WidIISG5yZKOAYmF57BtZRpqmfOIFwL8r3EJY18lpB7/57XSX5yPFOqNNhTVER4jyv38Po
	82mxqcc5nAkzFsJZp1nxb176hj0cNDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s4T93kwb;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774797142; a=rsa-sha256;
	cv=none;
	b=WGXN7Fs/IlIpm9M4f57dTV/4KdpPYJR+ADB3P2hICEqo2cRYTp30xB7bhBdxXhfSt6grM7
	lpLnXQC9rsmn4XRR9yetDYFMKujc2H7wSz8gONyvZCdZpvdwhgbgtYpWaqc+RYmzf8yb9c
	rCbGVjCFSK2ke9CF8XjjHTQNEAQyycA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6352260054;
	Sun, 29 Mar 2026 15:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00020C116C6;
	Sun, 29 Mar 2026 15:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774797141;
	bh=9hextLtkAfjK6hXZX5ChQd5LrsN03XztqpNRxzi++H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4T93kwbCo35X+oPgNmpQx/wx5boeQERvcZ+DQfyBj6bYfxXusrxZJXmV8KES8j3e
	 ZuyQKCObwbUgEcB4zs5MU7ONT5sujNKGwKsy563/x2qGDN04XiwkXA44VHFnWlwc2C
	 LLjTBlKTLTe2Z9LYTNirgNkeBJ2E8K4ZmJ2w64/RVwWa68331l1jWlsvI2vtqGz8Dt
	 IKNyrkqatz8iTqpoYhWGy5rQLJpOWR3IMQQpoxDM1Xbyx7UEwxXjILV22XfslUB/0D
	 IKYBsI3D7zPkIokzMVnR/vX5TJMA3629txKm02Da6RDkX4SviQs8J29F87kbjv9/E2
	 +4mA/LO6y4pxw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 29 Mar 2026 08:12:18 -0700
Message-ID: <20260329151219.44003-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329075415.36775-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E4DB16000B
X-Stat-Signature: 7fmex73hdprh8y6mhizpf5qbwe6not19
X-Rspamd-Server: rspam06
X-HE-Tag: 1774797141-124382
X-HE-Meta: U2FsdGVkX1/5zARB1knGvIJE0Wd8rN2tXx/3bliihCKLv5iq37fCFgPFt5lXLRuWPx7AOvSGatVAyrMmUScRUMzobLwfEFuLPdEYIxtxvsf7QKnqJHgEOYxRgEyekYwZQ2+gfkJsEpz0t1D3ELefysNpIYDeDnTSnAHsDzte6ZIIKs61E8ioQL3aKoa4yS1AoWrUnP/Iqo3efXGiZNbfg9j084FgaWl92ekpPCfKP0PPmHZkOFd8av1ui9U00Yg0ZJM0cgo12dxQmEreE+sh1rhAq3hn8QuHe8yfDrKLPyXfOlg3qVcmKo/ufZ5JQJlMU2XnhcYRd2Zr6P+MwcBSZpCXMHK0Lr6iU1oeZIL6MpM3D24SHFtwYQW2w7wGMkBmFx3rP6HsyT/Ts9SyolHIG3ang8IfNauv0bekYNBQXYbFVXHlvanqOuHsZyhQAeCmUvreW5d2MTNmq01Tkv6uedzt9iUHhArBixtUu7i+6WkcHHcoefetbZW8bRlkQo4SyJjraZVLHGQswsrfR3OxU/c8z2bGWEY9N/dgbvKwbw3wG0/1fCMAQRo0U/k/cqngyl+3keCXs+xkBKVIjJqL1Wq9MkITebkpTcd93IV/pMCF1v4MKqEbKCfuecCJZdqDVpMVZ9NFy8j7F1pzZgNn1xajvZRWnN9SlgK7kJCQMdWGqFPJi8DMOs+pm9aDit83prua/sEUrsmzt/gJS6hYArnI+pIHCqUzhJ9vHwkRskcW86ozX5Bm0dm/RmbHePjn8DwnbrKGUyNixFheuQ5lbHnVUy+lRRsGcp8Z3iRTToA8VbSUDwcoPEN56BH06FHK/cs06remIGVZYJlHmogB65G8GTE+OsYQWhHU8hHTBmboVZ8NBNAXJibTrqqyXYODSz+6nTuak5/ulCt57lYfS7xF4OeT6XS1m19zMYRiFT3qExq+8zoiNU8ZiXbLXtDOLMCzFNdhAoX1/ToXBZB
 EKnuNKYr
 dWaZV7dlo7fzr3RvRVW3BZKdtIjc/UKvpmudh0WsivkA4ElErvc8ArW2P35ga+OuYxZJug4YeNSK6xTgof/i0LAhsGCMyb5POgPLYfAsCOVL/KZkm+whuEbJYrxqYr/MOto7K2d6L6xsvct4ba0a35cCxfxW08ksmZL1c+K+hkTPvjMpf/SdydVEVWlMmrxl26vj2UU+otzOul7Qto15Y+BbO1L1U+Wks/Ez8kY9CI97umKxBLSPhHX6dmn7F4ZuPEWyLq5Kfb+EJCH33GiyjPRpoeAJIt8sLa4sV2y45IG99zUY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 15:54:15 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
> silently (no error returned to shell), because the validation happens
> asynchronously in the kdamond.
> 
> Solution
> ========
> To fix this, the commit_inputs_store() callback now uses damon_call() to
> synchronously commit parameters in the kdamond thread's safe context.
> This ensures that validation errors are returned immediately to
> userspace, following the pattern used by DAMON_SYSFS.
> 
> Changes
> =======
> 1. Added commit_inputs_store() and commit_inputs_fn() to commit
>    synchronously.
> 2. Removed handle_commit_inputs().
> 
> This change is motivated from another discussion [1].
> 
> [1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

Note that mm.git is nearly closed for non-hotfixes until 7.1-rc1 release.  I
will add this to my tree now, and resubmit for mm.git merge after 7.1-rc1
release.


Thanks,
SJ

[...]

