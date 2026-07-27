Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45592C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A723D6B007B; Mon, 27 Jul 2026 18:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20A56B0088; Mon, 27 Jul 2026 18:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938EF6B008A; Mon, 27 Jul 2026 18:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD2B6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:51:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D395114023F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:51:41 +0000 (UTC)
X-FDA: 85036055202.28.6D32455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DACEFC0004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:51:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QXjJWs/5";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785192700;
	b=VI/qChFQ0JmTJi6AMFzua9T5gthZYhNq8p6Bk+X7HxRIp2bg0jX0BRnLlwBYJPvui2BBCh
	pGRjg7z+FTBswFfXZbHtBIA2JL3pwsxVe8Wke3RFkRN3j3pn/Y2PUKofSjKGgomMYwphg2
	k+F46m8q8W0CeFCbPpSVHL3jVfy4ypM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="QXjJWs/5";
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785192700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0muGi53WJg1ysIJuxO/SQ/PBfSmsWFFN8uP1UdHBN8=;
	b=oC9aj0G3tisLHOVkl7v5hVBRvtznQWbgGVPP4raklnkOEH8omJBJFgpRfH4/K9Szev947+
	dYEkBwEzcvmFkxHY+bvNx82ckF/UdYgcULNqDWd+iGp/ylH7GrJyWqUxUaYyOkQeblp1S+
	6e5SIo4s4E5Z99JX/pNg3KLkASHl+1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 552CB6013A;
	Mon, 27 Jul 2026 22:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BD01F000E9;
	Mon, 27 Jul 2026 22:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785192699;
	bh=I0muGi53WJg1ysIJuxO/SQ/PBfSmsWFFN8uP1UdHBN8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QXjJWs/5LvCNvTh7IaBAV8v39+eAG7R3UNErClPC6Hr4LRg327WM65tYqFJa6aVPd
	 pFRw2haxQaTLJSOf3crlYTpGHKMDpOsov6WOOGc5qLDoOnxPX/rhH48GNorp9wwhH/
	 KbdB0fyIqD2crUpCZLE9s1gXwFSYJSR8vr+XvAXc=
Date: Mon, 27 Jul 2026 15:51:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianlin Shi <shijianlin11@foxmail.com>
Cc: linux-mm@kvack.org, vbabka@kernel.org
Subject: Re: [PATCH] mm/page_alloc: only update NUMA min ratios on sysctl
 write
Message-Id: <20260727155138.82e51e144237e66bff50bda9@linux-foundation.org>
In-Reply-To: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com>
References: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DACEFC0004
X-Stat-Signature: ixt3a5hf83kbasss1ab8zguxoamzaozi
X-Rspam-User: 
X-HE-Tag: 1785192699-5044
X-HE-Meta: U2FsdGVkX19lJouseOyhnoCStIH8ZUYRNArJbKZ8oEkZki2A0RQrNe9E8893G0U4/K7yM5u1XS+yelQ77yXDRNq8yjeBHXpkoJtIbBpBnwXg/8gdkmQ/HZ7tsDlBjjAGmRGeq8V/F2BigFJG1Iew/flyJUpyMXQbIGgVSYlmV3Tb2bf3e19+VEWFFwodQ8dva948DOlEmi3bGGzQWMRKO409Y8zoJ0R4oEHB3V9e3jNM30GI3Ba/xw405Vd4LeW/qSsx0YJOULppEG3p50H7ZLzJ9s2dJVmePk9qVzgQAcPLwEwtxokpYzfTCex3nVtD6XpvPY//dJLcmqbGWjDpvq4mEptVB/dhuxVFjgU1lju2Kl+tHQyL6fqfCbAZd0etpUvvKjKDbM5ohi67l8/aQ5dlALvAskExHsneA20UH6REtPcmiNf8wd0osjSAB71KTwd285+7KXhJmR0NBAODhhxqHfWRgLeL/oYfwQ3YDVWjhskOZm4A8+yYLX4VHg4z3UK9YoOU6dNklMdXFOOQVBX+gO8ttdkfMFl32Nax2CTkL0f10H+CtFvnErSMhq7SBiT27MJo6U3bDhCNDC12YAq5vNfSsypy6wDjv0uLkdE8Fc8M5NTTHhyiFyB/Gm8vipT/WuN9TgQLjj9Sjhg60eOdWqD4KpeA3xFJ3pyG2BSZ3sWv4nhmLjmMGfXJMWf75IE/kbSvwJDdo1mJYx4HkoGY37g3zzrfaKyS3KaX0H/YumMKon3OcvU/P4j0y4cM5Sr28/QFbE8eAT6KlBzKWDi29KM8M/SJL/g0YGAL6phyY+WN/wnNWj40YmpKRHmdjQr1U3ZkMeY+D/iexinAoJJg9JU6zTD4jUGpyrbhrkC93QZ6Ply5gUJ+peBLJdPVRzKNDtsCAjzutSxMUnA6ZsSzSeXGiNpZvfoNplDMGe4hI4ZXwYW6N8d2VaU9Jm4Ep9QcWOrD5VjN1Eq9y5R
 kebcsd9k
 s31R2bB5/ghWm9aHXGXz7V+0pMIFQvbxFu3poKIWt72ep+FpalH6eSOHkOgvXjkCSuhd/UWYWiQiCBwWm0WCkZAEn65PWa2N3OPVRfhzga+gZnWOjX1C7IAPEXhrGdu7k6gXZbBYyWzZKYRUObwJ8yZRtWMPl77ufmWGOBvj33UX5LBDHOaj9ecZzQCCenktVSCUP5qJsDxCi5QcnrUmLDRVmBywCLz6WWflLhuR4efEooySrPX/YNm+QKuBE9Mk9lxD+lSjrMI4cLGJGSbw39EB3Tpw7B3fqTJ8bjLFFH4E5zqH400hHXOJrfCRAP+ac50rmDrhEnqlZU+MyMMweJRVKMR3gYjt7dXY1c4sbHhvY2/n2sLbEiFaW8q35LXkIIyv9aOB2zIqyBd8dMTmvdfFO6CxloRY8PMyHm2BUvr6y7ROyedyL1JMeig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Jun 2026 12:01:38 +0800 Jianlin Shi <shijianlin11@foxmail.com> wrote:

> The sysctl handlers for min_unmapped_ratio and min_slab_ratio
> invoke setup_min_unmapped_ratio() and setup_min_slab_ratio()
> unconditionally after proc_dointvec_minmax(), even for read operations.
> 
> These setup functions first zero all per-NUMA node thresholds
> (min_unmapped_pages and min_slab_pages) before recalculating them.
> Reading /proc sysctl entries therefore temporarily resets node
> reclaim thresholds to zero, which may disturb the behavior of
> __node_reclaim() and node_reclaim() during the recomputation.
> 
> Fix this by only calling the setup functions when the sysctl
> is actually written (write == 1), matching the behavior of
> existing sysctl handlers like min_free_kbytes and watermark_scale_factor.
> 
> This only affects systems with CONFIG_NUMA.

AI review points out that lowmem_reserve_ratio_sysctl_handler() has the
same issue:

	https://sashiko.dev/#/patchset/tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com

All these changes are non-backward-compatible userspace API changes. 
It's really lame and somewhat unlikely, but we should give
consideration to this.  Perhaps there are systems out there which are
dependent on the side-effects of reads from these files.  We should be
careful about these things.

So I suggest that these changes be proposed as two or three standalone
patches (independently revertible if problems are discovered) and that
each one contains a description of the worst-case regressions which
such oddball userspace might encounter.


