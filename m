Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26977C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29ED6B007B; Mon, 20 Jul 2026 18:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00B46B008A; Mon, 20 Jul 2026 18:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19A06B008C; Mon, 20 Jul 2026 18:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFEBB6B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:39:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 414031A0310
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:39:22 +0000 (UTC)
X-FDA: 85010622564.11.B647BD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2DC9380003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:39:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IMUmUWOm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784587160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9Hp2lCCEZ9lb9WzpnWx8yXkzJX6L7iH3HYpRFS5fnE=;
	b=l+AKJZcUJQN6Y2cwfR3KMAl8HBUwGrj4cHwkCe1+OnPmPguBIjHg2zfk1iL62yCQ86sBeN
	z9hOMyBTHK/215oL1eCNG8YXAei5Kf+JOWdnA1TNGSYffUXVN9EPAkWTnxwnGXu4c9Aro5
	62Tb1zdQeqVODMHA1PzTBIyeLS2nh3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IMUmUWOm;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784587160;
	b=OrYODAO6OtG4yQnU2HjQJidqpgNZKztHFrItqrNEdsBJpC/6ISJjnb/DHyi1oei94by6OH
	F6MZP4SQJK5H/H5+5f3Swc/lPnwpff+UoHPGe1U2blDAIkoEunDjaHds2oqdfyu8QJbaR0
	ozSJLflxmcrfjr1BGFaD2hosVJwU1c0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA9B04030E;
	Mon, 20 Jul 2026 22:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558E11F000E9;
	Mon, 20 Jul 2026 22:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784587158;
	bh=n9Hp2lCCEZ9lb9WzpnWx8yXkzJX6L7iH3HYpRFS5fnE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IMUmUWOmBd0q+fgNDoomb9dXf9qnFt9omp1Qdq5dnG+Gvz0CxQOs5c8CbsWGX2g9F
	 lQZuRWMgT0grvsxE3h4FY8sb2ZZdzqkt94oZm9MK+7XnOIH3/eC86U2AmZ9vu4YAI5
	 4yV2/5lqtSFC8Qax9ZGxFvm9W2w68Y0SF5BeNn40=
Date: Mon, 20 Jul 2026 15:39:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, paulmck@kernel.org,
 puranjay@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-Id: <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
In-Reply-To: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DC9380003
X-Rspamd-Server: rspam01
X-Stat-Signature: ufbisby4ck5ka9dqcezf46wgozwz7315
X-HE-Tag: 1784587160-297922
X-HE-Meta: U2FsdGVkX18lKsYkowRqcdI6x9zJmXiNR/TPIJKFr5LjE3/YQ0a8gYgCr6RJJaM0JQUV7P9D0jvwuJhfQxtSbGbn3Go8UmQA1jskZvuMaMIl3HGFdOHvRKFQWs39zfLEcDebLLNXK5I9r/pt1LSQ3UH9+iXYlcmuj6DoS7S9j8SmyMTnd1wNm6qJOjyxTno78i6MYrBMgCLiPIRroicTKudU/3jlGt7jtQ+kKr8wVr9rQjP7WAjsleVhaLj0bYgXpN41f/kJhcS/1/vmnf4jTuZlElQOegbYOEWLOx+X0CzzKS8dlB3p6KsIS1XciY9PJvNDs47C+Gw8xuJZQM3FBPggsh4gP7XpEk0ESsR0xzYclAMhQFFm6+HPgQDYDa6m4bq9DK5LuSgXkmRD5Xon5FYj2mN/VB+M90xNXYTUrrIBONsv2Ek3nx6im8iIT9BTa87B5mHTIODCO9ccjMdoiYBqKt0iXgrPq+Zz5ONZzldSvKeXJY6Xa0fhGj/tJf4kCts3P7HeyCGmVBkAxRUpq76ZbWnmY4ldG9d3jauj09s6yGv5r5TLmkWLpQjiXFJkwTViZDQxTun8FAwrUz2I0hwgpB4TUFm0bhILCu+Lli/XVhFae9kIsjtmDTd2Kyh9BJgdCXrzig8Nio4CzrUSUD97owMAi2FzIXoCj+4cEVklpIetCwLKj8q65wFYJDC27pN3o00xr5lZ0JJo2UZpcchipno1MHHmlcarbxkOGhuN6ns0xp3hr7NYiuwTPgzWT4Qr/AG+AzdprVz9yLlWYSMgubwC2BxQpLy0UUBqhRo1h053BZ+YSvyYIrbF0/ngmrEXq/xwzfYszd4L96ec8cS9/W0R9K6DwIQtlFSV56gjmr+Eg8V2HZcVWaRZgCA5ToXD3ZiF7vRrR8A7A3CnYWYCiY3lksgx20sth6MTet6SP90vGhMZpOWaMHre69xs0XrhuwyuBKwRmabuGvc
 r9auzTyr
 HPC8D+uiKhe8bu5dMaQ77Wp+kXEp4VsuKSDJU9Zb5IDSqgFbuFhFmB7Rlqt18IDpRj7n76bcIbwICleOVqY7w2Rqfj3QXx7/QSV9YeJmPx1JmdCwnas0VPHfio8yRaF+VEND4NYaqqU2kmQVynFCBV9HR5Hf6jYdUTCO3rJfnAituWH5ey7z+Ptv99oK71k0fBEKzqDRvx6ce6kOfbF1uaIYKb+MZZalqZW8Ybc3hYFUwDGlgqn8eTIoteusr8h0kAqbtwW4j1rJycMb0oyhysmYPJFmRXGxXWQ4XvIX2ha45u/s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:

> kmemleak_scan() can run for ages on large debug kernels. It was
> causing some soft-lockups which I got fixed with commit
> 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> stacks") with our beloved cond_resched().
> 
> I've got the fix above deployed in the Meta fleet, and now I am seeing:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
>      scan_block
>      scan_gray_list
>      kmemleak_scan
> 
> and, worse, blocks the callers waiting on that grace period. Here a BPF
> struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> call_rcu_tasks), is stuck long enough to also trip the hung task check:
> 
>   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
>      __wait_rcu_gp
>      bpf_struct_ops_map_free
> 
> Then I've learned that cond_resched() is not an RCU-tasks quiescent
> state, so, we need to use stronger primitives.
> 
> Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> reports an RCU-tasks quiescent state as it proceeds.
> 
> Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> quiescent state for task rcu").

I'll add

Fixes: c4b28963fd79 ("mm/kmemleak: rely on rcu for task stack scanning")
Cc: <stable@vger.kernel.org>
.
.


