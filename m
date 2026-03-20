Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D648C1093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369296B042E; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319F36B042F; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2303E6B0431; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 146C26B042E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:18:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 971E613BAA1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:18:43 +0000 (UTC)
X-FDA: 84564984126.07.30765AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D534A80009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:18:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCGRZxSu;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HzAyuv1cR2aPHHtMvh1o2+bWKgmUnvOcDh+3uBWmXE=;
	b=0a91Bcqygn1z1zEuwEe0aJNn+r9iPixH8O1yd2I7uXspjHZIK5mBCou+OkEoK/pmzerT/l
	Zbi+uRo2qavEIMMUz+UHLNHRsREvA2rjrdebMw8DXZaV5x2fnC59whGf11RAYYRXkYgHYG
	90bVGEvRe/A9nu9k5xxJ2tW5XwuTaso=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XCGRZxSu;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976722; a=rsa-sha256;
	cv=none;
	b=ZjhQuoLAqn5d0BnWvmAiWBSRPEYlYTTTay09QNsWlfspfUyjYzI3Ppb3BOlJydrBANktec
	nLww6i/tiIuLfCtE/vWbXuB6PZ3QWy/68/x9vrONjeidRxZanleC/m//CBx96gadFgij3+
	o1BTvnUz8ecbTOzjE4xerFMnwQyCHsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EB74B4358E;
	Fri, 20 Mar 2026 03:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A21BC19424;
	Fri, 20 Mar 2026 03:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773976720;
	bh=RnWaFWKleytYk2xnMbn6rVyzIPDB56jqJgJOybkNp58=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XCGRZxSuX7NB0ciVsWAd9qvBv9OyQ8YLbS1a+8P3iOs92SF02WGeSPOmDhHZYN8k3
	 2ERRZEycezU/gQTEFoNqad93hDeICz1JmYWv2WgOP9VeqK4G40VWziMGpyao6ozqpE
	 +lt/ohK+PFKlyJD2wClCMFCru8H2uNJzFHowMP6w=
Date: Thu, 19 Mar 2026 20:18:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org (open),
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] change young flag check functions to return bool
Message-Id: <20260319201839.2dfa704041b8f13d8dbbfd3b@linux-foundation.org>
In-Reply-To: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D534A80009
X-Stat-Signature: 4wscqdwq4wrwfbhhawtwdmixndr5pa9j
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773976721-738126
X-HE-Meta: U2FsdGVkX186O9oTemY1CvG6iQagbcl+DQRGx+boA0cTobUcHLkumcAKOT6ImSkToiw7Ed2LwJMdwVbbiaGJ1vtoTcIVK45Mo5723wvZN+YKdns5menj6K6WnuPuNikGdIClufQnYtoMy8ZCtfNUuYOqrA7vREoSDYZ7CpymEwgdXK+PEq9FtQeKu6jeRxTt6T2CLYxW7HMFeCPrvJ7oXmZGsMhlVMzzf56jc9Zsqrn5da72imua3CL6TZ4tfYMDLkoIVvMES/lTLBHobLD051ys32p4yTxz/JXuRq9fqXCW9sueXcrSgrdnqek2X3Bngnzcu7dWBQiombuYIhJ1UNeBwCT5eyIRnCmAEwCqfLvdXbJq8arjq3kxPSvI0SOWQeXWi32C0sAYuupL5kVkEDYypw1AokIqbVibQTEaKuS+4aDvOeM84NVu8QH7mw7VeO4YAGtCRL0EgDQFzM7oqMqWevnYmkT4tnkUtg9uXqU4qpvRErVYj9fEJtIY0bFThRnqEvZfmqytv8JCE12I8x4z7OQXYPl+jw8C/XGCrBgNueS/Z5fpm2orizx9BU8xYbJu9qsA9QEiCqF+3uQPx0L9mnwWe9rXoAd/DKdEzYhp+yb1nX+n2yEgsOwF+QbeBOdbVYGcjzuIAXQT8k/wL7i/aOnG3R8JWlA85/CPRZ2wVAV0YTFmHQNW9KsZcEQs8f1L3xL9la7EGZyCXwjRoWn3ldQaN4kJbG+R7ogs4mvpoMNiSLr3SsTTa+Rg/Gzae5GUpNHEAObdZGN1pldmfbsZjrJxonTYXiOgEfhtBjox8RLOHMfWRwqqHVCiO2NTlCIuad75vaP8Ah0ZnhwEhMlBEX6MeBQAIN0tHHJwzuDlYXiZzNrwtzZF+iM79p9cv2EpdROGftU4reQ4hf1fOXDa9otY3OTWlzGjjK7+ViFBCBUZFcICsoP0tSv831xc8i1pGNAJQO6IyqPNKPQ
 T9zz1Fzw
 9gt/d/Mtr5P95oMzCiy1tlXH1rto7yanruagLYUGv57eYXSs32W3hoJhPJpX37Hss75Ob7Qwo/WuY5LRL9ikpiMJty+/Fi2GE0PrAn7kED7KGrqmjR4Im12zPjLn6kN8mc8gdmJu5zYPcogzu5T6vnKnXbpwivqOOiRg4ZeNoS6HXBEwd7uWzhUI4ecDAvk+ZD8uKaTaJy5rC+0yR7yBOVxEeI5K5FF7TGnnBEdY3f8IdtNPDvxcpF5Hw3b/7MTMTpVB6NSbDgW+RpxGsu9fWSis2JTj/5V0PpycioeG10dD8fD6sgkpeXOKbZ2WphpaUsXPspXHztSmoWmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 11:23:59 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> This is a cleanup patchset to change all young flag check functions to
> return bool, as discussed with David in the previous thread[1]. Since
> callers only care about whether the young flag was set, returning bool
> makes the intention clearer. No functional changes intended.

One observation from Sashiko.  Minorish, worth addressing:
	https://sashiko.dev/#/patchset/cover.1773890510.git.baolin.wang%40linux.alibaba.com

