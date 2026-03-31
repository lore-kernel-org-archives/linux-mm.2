Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3058FF60C8
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 05:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BFF6B0095; Tue, 31 Mar 2026 01:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCB46B0096; Tue, 31 Mar 2026 01:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2496B0098; Tue, 31 Mar 2026 01:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BFB76B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:29:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BADD11408D9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:29:51 +0000 (UTC)
X-FDA: 84605231382.06.2F276BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4C6A91C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:29:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HE/NV2dh";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774934990; a=rsa-sha256;
	cv=none;
	b=Jb4nmpfuXObMZpogi8LnD2daK/bPaVsDrK2HZGE6rDgmoRGHbgBFmKRVA8ZbqeuTHJtF7T
	q5BTxaaapRPTA6vwO60GCjNBkPtA5C2wC6nqF/Ns6qBAG3zd6Ete3yGo7EAYF0Xo0ccKhA
	WzzEkaeqot50tHcHzte33YoIHYUgZVs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="HE/NV2dh";
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774934990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZKXrNlM3kfQ3Y5LDAK3JLHBCoadmBApjtiqO2hbOYHo=;
	b=CI3c2WFICdLRbxOUkGt4jJ8a2Tr14STJXBzjeC8RbQgceeZ1MYtOb+ooAgSHUWQtdPrAnw
	U+t4UrhxMTOBqsAgcJTjS0sIO6rpWwtE/2h5SPQr/FRU2d/EJ1iN5srdXdN3csaepzPsMT
	0yQfc/lvFhp6GIGRcqx2SX3jFB4nVaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC6A760103;
	Tue, 31 Mar 2026 05:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5E8C19423;
	Tue, 31 Mar 2026 05:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774934989;
	bh=DNdy8awue6ABSIysKyK4g8jkYPLvxBSWcrnExTEfhDg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HE/NV2dha6cd2OtUwR78Q437KzC1h6ofgAfUZm9jM9WofymJUN2njFrAFLeB1kXPn
	 gef3tSe4IhSNi7rCJF4iHKGa4at3yroDe4DpECVgZJDDJPgKp9cUNSZxtMJ/k5pc0w
	 2bp/9qroFHA0km+6DDkzHuGC+KMaEz8W9ADsVlOI=
Date: Mon, 30 Mar 2026 22:29:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] selftests/mm: serialize local_config generation for
 parallel builds
Message-Id: <20260330222948.c2cc6544492e68ded355abca@linux-foundation.org>
In-Reply-To: <20260331040156.119158-2-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
	<20260331040156.119158-2-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4zudqxim8s78fzoe8eke7tqi6k9gfe83
X-Rspamd-Queue-Id: 4C6A91C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774934990-901013
X-HE-Meta: U2FsdGVkX18muG8Eg9CnAR81YVs3SKyNZXBQKwFIdoPSgamNCPRUrGt8nxDsaInp/yQDYpW3LVbwpg6eiE7UHQUT6tg87czbzGeSO2qtLtrxFYAlkey+98jaTvkMd0SEJ5CSnsSZ+aTWspxYk09qMYxKhRra4mmfL+2Tw0/rkz0bodsfcxZfVZ42WcpleE0yN8waUxykqR+tugrEtOTBXK3544ZTd5PnXB5CA6XehyRmFgzUIrRc7KUxwNozimpii6yAo1pWS1skJJ0Dk7rMtWq1t9uAkZ5bcLq/4BXR1LVGbbzdeW60fb1HwlYDlYYAhkzLE8QZ6IfQTDc/MBWuotPSpLrcxexHkBxvUjlmltZBxlUk4Pau+pkttaOz32SZp184u9+eV7dQRbwGf6jN88jk2jnmc0xByc/QMqtrKvk+4fc/EoAFFWtBpw9XkCHyc5QafDTXqcvcS0VeFWVlofh7AjvcOcUyb85pOz0aS9G+iFiGzLO8JtGmimM6khHcCMfZBhKJfmKUH9P9PVhX0EtDhJIrOljbW2P9EzKvDeOTsXjim/Xc0JBIabtW40lSxRcsY0Slfto4sYhbDdB4vy5rrH29l0vpKcGlEhwrfcccb1YcUfbEQZCadKFur3q+tmAykL5I6at8mQ2KKwM0m9I5AedfYp5gxWpr3RQsXK2qRRP4jT8OSYEm1v7tJnOuP6BAmVjvLXq4ivY/xC8sT67VZdXBpUz1hZTQn7PUjhSS58cwOYG81QBmmxfWsYML3dXX9Li7bzkFfwcdguOiV/0pEroeCS6SGWWZcSxuZ/a0deWgZU9MJPmPPHins19q8BD/L+n5EQVQWYnnk1QIi6/Pr0HTWG6n4dC5R7KC/iEyo/5goPZRx0vKGh0KuZRFt3ay9gkMxTP4rjBgqiExYXA/lLs43qg3m/NblOisE7vE6+oWTmQIs8htwqFBTAGuFxKzfnQ6ZcAAas/VIGJ
 wo1+PQ/9
 etg0A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:01:54 +0800 Li Wang <liwang@redhat.com> wrote:

> The mm selftests generate both local_config.mk and local_config.h from
> check_config.sh. With high parallelism (-jN), this can race and lead to
> incomplete target builds (e.g. only a few binaries get built after
> 'make -j100', while 'make -j1' builds everything).
> 
> Switch to a stamp-based dependency:
> 
>   local_config.stamp: check_config.sh
>         ... run check_config.sh ...
>         touch local_config.stamp
> 
> and make local_config.mk/local_config.h depend on the stamp.
> 
> This ensures check_config.sh is executed once per update decision and
> removes the parallel race window. Also hook local_config.stamp into
> EXTRA_CLEAN.
> 
> No functional change intended for non-parallel builds.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>

Well, the wind changed direction.  I saw this race a single time today
but now I'm trying to produce a reliable before-and-after report, it
isn't cooperating - everything is now building with -j100 with and
without this patch.

So not very helpful, sorry.



