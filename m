Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02829C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 21:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F906B008A; Mon,  3 Aug 2026 17:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F8B6B0092; Mon,  3 Aug 2026 17:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1263D6B0093; Mon,  3 Aug 2026 17:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76666B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:20:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A669A223C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:32 +0000 (UTC)
X-FDA: 85061227104.27.0CBE4AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4BA580005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:20:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0in8WIyB;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785792031;
	b=37Mt8DUbOvefyjfumOxu6pcRlgw89jCDs5rZyR4s5J+LN6r0ok02QR8BC8MwsnpneGqyF3
	moh9o+/G729UO0D3wUcH+1XzTBlphu3KCGVnU7qVGpDeiodekd/GiZLPR9WehHvPNEYNpr
	45VyBLfDCWUKF1/A2+yP/bcrNsrMrJI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0in8WIyB;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785792030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ovGrfL8FA9IcoXlsdJxZJSu3Nem/9OzLoCHFXhOX0sI=;
	b=CFrL2tIeY15A1xNXoeOL0AZ7R2vfdejQ+IbDN6RMGX2PyWdrWUjaYK5OgBRiq4WFqckp/2
	EyuABptEm8GDplN5Rn6kJ/Ky5aWVKhJwXh3I8cFXsKIUBghpl5c7+CxrCR2Ov7SMDTKTTi
	36+XK55kGzqFt12qMZyotGuKyOJuMoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87BDC600DA;
	Mon,  3 Aug 2026 21:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA7011F000E9;
	Mon,  3 Aug 2026 21:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785792029;
	bh=ovGrfL8FA9IcoXlsdJxZJSu3Nem/9OzLoCHFXhOX0sI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0in8WIyBlnv7a1VnK2h1m2MHWw0wWOVuRRb9xFVnTt6Ha1lVPz+GREdAwtncfqCI3
	 sHCsq6sOE/FwDZRfiKg2ikO+gp3+kJ/1MZLexFScZohQLBcLuKohB8ttZxOvcmFCjh
	 fRDPHECut1vXZR1NLGbKqKeskVZ7PykPlW4mq+SA=
Date: Mon, 3 Aug 2026 14:20:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 1/3] fs: fix missed removal of
 super_fs_objects_eligible()
Message-Id: <20260803142028.1facefdbff955e593aa36e53@linux-foundation.org>
In-Reply-To: <139ec7ff190eeddc52f40e215ca5c950af5d087d.1785746588.git.zhengqi.arch@bytedance.com>
References: <cover.1785746588.git.zhengqi.arch@bytedance.com>
	<139ec7ff190eeddc52f40e215ca5c950af5d087d.1785746588.git.zhengqi.arch@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4BA580005
X-Stat-Signature: yanq64wijkz43npoqftpigjye8m4rjsh
X-Rspam-User: 
X-HE-Tag: 1785792030-570003
X-HE-Meta: U2FsdGVkX1+4AfUAS3qqwv9/M6K13/eL6qVI7apH0JvEyyTKcL+JHUgwVlhb3dJPqeN+rce+WFV3/HZXk3TXAbRILSbbU0Lu0iPl69DD86NHVlv0uTFogqYSfJD31T8jOeEOO8NxJ/KnJOEUtHwqpgH2StabAB+9p0QaQpH3h0ZChQn6Ste2m0mlxV/z8LIXgcWBGELjbxwBRIoOXcYg6SHwjYLFr943fhifi4lPUaAW5Q/OvB1XcRKcbqwgAWnS/iW6Q2ZQEIzD+2NQIlwPaHwU8RKXbD9vUpJ94Tv+Xbokj7l3pq6Adz8kNEcSPxKlrE6gELr9VnxojklJYdu6r0NIs2ydoPCN/t67oIBgz7ap6pdipzCgJpF1XylzqwBqeLKdWh5Ipi/DddCQPYWo5izcDJyV/NCsPPgzaAKnxSWAzVFlrciHr4SJDFNBJDhYPeE0Fvqtu4w6F9+yTQFP8SDpLwzhm/j5BdiCilmiRE7dltp++y4SOpOR1+C/J0oQOxX6fb/Jcwg5OFlxMJkXl/Fnt2tz373TYQO/0oB1Fxvp5gPsrrHZRVmOkNHBbfq8WImEOPCSGyjgnucDnNNXWJlDwGwS/P1gyrkKJbXWzoX2wgmn9lYhFSEzghUZFrFIn7fTk+2g7pi6rv3MQhFNYmanIBpUfFXVzhIAwqyfAtHcOeuP/gUk8NB9Fq/eTUr4QgMV68IScSfrMd0ab3qJnHVQ3NlNKeSoHcmKUli2Q6zQVOxaJs/cScDR6VhEuWMBsy9JmtyhaJqxnb8KQ4W+jyRMPdT2WKqbapnUdLulL+PBub1vn4vu3VMIZV/14zQt1Nclwd0e6uIcyIZR7+xqqHySFZ+4XZuvwUd9DKtWcCdTwaWrNToi2Dugtgf5pjRptxZe6PydS1NOGeDsykNgVERzWuUHlZndnxcXjOHZox43p0OLgj+hVsjupKb/EGZKUEmTLcTzHPYNFLXDA9k
 wMpSe0bP
 QBSDJiwfWdpE+/XVQDFur453zDUUaqSFXBGLHgt4pbMBo/JZR1l3RYuG2oxcRKpZRyDpE3UKVbRNbJSBGHrlNovBfnJJtYJiVQAtHF4KvQ5/8bVup+t6LFpJzEDB0gp/5Xjzn8iQdKAfZQUNFv6/EQ3Q949qwX+xbzV2jbeU2ipEZ3VYKtQ4KDRrlMCmCsOoVY8EWklCQw3fNY9gOdSUHX/optmDjPnctNQB3p5K4gNT4bCcy6ZhhVfvGjToOv6roLBMPqTHdT8p35kscjZlv8wpQE2NxxPvDx9k+D6Raj1CEYYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 16:46:33 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> individual filesystems") forgot to drop the super_fs_objects_eligible(),
> just fix it.

What are the userspace-visible runtime effects of this bug?  Please
include this info with all bugfix patches.

Should we cc:stable?

Thanks.

