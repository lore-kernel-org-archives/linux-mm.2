Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6324BFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 14:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6926B008C; Tue, 28 Apr 2026 10:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8DEA6B0092; Tue, 28 Apr 2026 10:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB4E6B0093; Tue, 28 Apr 2026 10:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9C16B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:16:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B94C120183
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:43 +0000 (UTC)
X-FDA: 84708165486.03.1CEED2F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C7BA1C001A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:16:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y91yBWuL;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777385801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XaYOz15wOGh+EB+moINtXBqa3/CyEdPhX4+cS85jwaU=;
	b=KOFcRpYsLdRrANeLjO1CLW8lU5Lr5X9TlJWXY+InihbR8rC2dEcjeAeFxRvA2zzw4g6w0H
	zkxmim5BDRbTYo6PtBIvk9Uw/Ycdc5C12Faa02+ye4eF5lSKXQepeM+fmr0tokKGxgiwhI
	C9CAaksIXse83gK8XnP67WKSMqMJJl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777385801; a=rsa-sha256;
	cv=none;
	b=P/D01lczWnAR7xpAit8jLMi9opk+EtB819QOIB4WISDvCQ57X0x5uXpUlhM9YC1gKYXWqa
	D54tPA+DAOHMhE1fhJEGgX5MWdB6ylwG7MM1/wBxQJI1aUfyr7mXhxWOHjBtX+4xMrwThX
	efO5Pt84lWfM2gbGXyx0+SC6dWsEOgU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y91yBWuL;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CC136132E;
	Tue, 28 Apr 2026 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8300AC2BCB5;
	Tue, 28 Apr 2026 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777385800;
	bh=UattL/at57T5QqsU15Ijo7r8+bjYkLs0PoPIsDETnyk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y91yBWuLlrROcgwR1CTvATWhhqa90vwmQzmigqGiL+94Xm2XlEyTabW11nUbxAsNM
	 dJuk4dC12lxZhh9RDrcEPsGUO0Q7lTOOpsm8kNfGJO27C+8CMMIIfTiQeb63nv5N4j
	 JF6DhqVGbIXv+3h2fKMZ1/54crN8gvbW2te4TSKg=
Date: Tue, 28 Apr 2026 07:16:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with
 nodelist support
Message-Id: <20260428071640.53b6f37e3a0b2d0ce520622e@linux-foundation.org>
In-Reply-To: <20260428071112.1420380-4-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
	<20260428071112.1420380-4-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C7BA1C001A
X-Rspam-User: 
X-Stat-Signature: yujdwfgiujzykq7r7d6dk4sbdkxrhq5o
X-HE-Tag: 1777385801-366213
X-HE-Meta: U2FsdGVkX1+eRZfSCZjAGgG5RmWNaz8kpazCu8G1a7ji8qfzqXFtEB6xaDPxWluHOvUULR4Qj3Lm4mjs4PNswA+ZMwT1rfyPth4gTQKICqS+Hf+n9QEryW+uHKl+pHM6Zzu8TNyzf0+ABjDhEzA0YnEmnC1AE3A0ZZ61PwyAAEHVU5E4GN3OX66OQFYYpoxt/eu4tRmgqvCSLQxg79bAx/ABf4/KTZhfG+OSaw8mkgFdz9sxkWKe5yjqoQ4CbeMoTiRLe1wZc8M1QDcXFBtUwLPMUf9AghusecrsxaprrwO/A00eNBuHoygBuuNniVgGJd7/uKBAU229BJhFpYzJNXENEdtM2B7KHplj83ZtviMaylfe3oWKmTiXfmb06DrkOaXRgPXvP5ZghbScluY2pY5fop1NxcNOi+nROM9iTmERnizqmU4yQGKPPB8xeYtRpqoVW5RTaPwHopojZztw1wRUdGfj8ouhvdkMpvOtMlZxAyeCBNc2t3YBCkM2G2JCxqoYxl8SS73p/xiI5OwLcQJThIof6nbIMEnOPMHLMUPGJ3Fl/914BVhxVc7xKiKA3/LuZa7FwI3h3HnnBMODdSeh+k9Uj2y4pKjMgRy1bbIcdwHDh4P4E6LbWKkeeJtmOz3YtH+8iq1OgWBu5g8Dx3ybUcVLZUoBViBFdTOcfqddXVCueLG8+r7RJk+Z55VIKifh28fW7ScOxPMVuFtngCZKmak8tq/2MgJ7PzbjzgYrkFVW+7xDsmGnA//4IB0rwmqJak8l+uvwVTZ/kTjdi0FkOKfshTYdnuBOii0K2KA10PO2ggPYSdj3hj1RdcD+oGbOPoffw7jWMBFrJ1yGAgplZ/jev/vozVJ1mcmmrRrShCg03xq6zi6vtlYbCuT54lVXsu+K/x/Aw/wyL1q13HxuWAkf/oZWI+3mGhmnIfkdcPNcnxZ/Rr5AqFiKdSxAa/jbpT+vl0j7/+1dlMC
 HxrYMQg2
 qLDFg4RvwLTxAqy6P5plTviGKBZMbBMv4zhCbH+rk+9Y7NE6SH4u81ZtJOoKxt6r+RHdIaOtZ614NlXoOQhvha4sbpGtfb4CskmmCpn2pT/Yu3xcWmA6qsAI5q+YuT1UrSudJmJ7HIZvOJPnmbMlR2heO5sXO/UHTTD5IANGj3YOYbQqHWeOplbkuLM7t3QS2Q4A4s/b7BDb02F0DHXydWp8+9pZKs6Y6fEjuqbo+AwOiV3MeRL33M5H4xPkqbgsu5uxerzy+ncbQBmQ5inHplcTAUuXEcY5uojj5lWk6eXtx1gA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 15:11:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add NUMA node filtering functionality to page_owner to allow
> filtering pages by specific NUMA node(s) using nodelist format.
> 
> The filter allows users to focus on pages from specific NUMA nodes,
> which is useful for NUMA-aware memory allocation analysis and debugging.
> 
> Supported input formats:
> - Single node: echo "2" > nid
> - Multiple nodes: echo "0,2,3" > nid
> - Node range: echo "0-3" > nid
> - Mixed format: echo "0,2-4,7" > nid
> - Disable filter: echo "-1" > nid
> 
> ...
>
> +static ssize_t nid_filter_write(struct file *file,
> +				 const char __user *buf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char *kbuf;
> +	nodemask_t mask;
> +	int ret;
> +	int val;
> +
> +	/*
> +	 * Limit input size to handle worst-case nodelist (all nodes).
> +	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
> +	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
> +	 */
> +	if (count > (100 + 6 * MAX_NUMNODES))
> +		return -EINVAL;
> +
> +	kbuf = kmalloc(count + 1, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(kbuf, buf, count)) {
> +		ret = -EFAULT;
> +		goto out_free;
> +	}
> +	kbuf[count] = '\0';

strncpy_from_user() was not useful here?

> +	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
> +	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
> +		nodes_clear(mask);
> +	else if (nodelist_parse(kbuf, mask)) {
> +		ret = -EINVAL;
> +		goto out_free;
> +	}
> +
> +	owner_filter.nid_mask = mask;
> +	ret = count;
> +
> +out_free:
> +	kfree(kbuf);
> +	return ret;
> +}


