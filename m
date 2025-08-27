Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DDACA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E2E6B0062; Wed, 27 Aug 2025 17:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5906B007B; Wed, 27 Aug 2025 17:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32436B0088; Wed, 27 Aug 2025 17:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9480B6B0062
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:48:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DA6A1608A0
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:48:36 +0000 (UTC)
X-FDA: 83823877032.19.E74842C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52335A0004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:48:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J3meIb1R;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756331314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmyXnG0yJwF/HL4SodHdLyc1Rm1EPk0Rs1d6dlQVnVE=;
	b=zeCzNNjb3LJ36pEhc35DqXJSUAsD7ax1Qqc8KUX+8C1Ba8jqUxA1kWCZXXUklE86sK+xaU
	DeldcS96qplMn7ycASVuczZ3gS0BGzzUYe3ftESsQEAzQ8PCSoI0tXtYVMQVLt52Ywgp88
	a2BL/02MZjrBIeQ19g3I2iiX7u8aBCA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J3meIb1R;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756331314; a=rsa-sha256;
	cv=none;
	b=nf1qAk3Ga55e79gkFnZcvRH7Z0nfQCBo1bfrFtpq4FfST9FCTz2HOR66cDcyzqXhyTGVTk
	Oi+1TGWQwJWn7Y2RaM8ppsAxRRw+jF66c42RKrc1BP+axYT1AWJvbH9NAvluhSOLj/OEIO
	8vG0YMj4ebCvL+jooYQtou4xA/U7Gxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 363BE41B72;
	Wed, 27 Aug 2025 21:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB648C4CEEB;
	Wed, 27 Aug 2025 21:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756331313;
	bh=wxEepMxFMucuVNOWTttN26FKUa4fU/adFqguDNxZrX4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J3meIb1RK2YZnMMG7UCvwivy9aKF/I3vkmftYzJ7hn5Mwbk7tjwH9r5FMlizxAufA
	 Yrqdl6ZAgo5WRmHdJFE572ZlA9c/pBBJw6J9yTm5WmyGaczBcvfOefOAEhQRZ+6MNt
	 95+lqa4PTha8j3+MIyAUuzozy+ap4IzfoNt0ViLk=
Date: Wed, 27 Aug 2025 14:48:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-Id: <20250827144832.87d2f1692fe61325628710f4@linux-foundation.org>
In-Reply-To: <20250827192233.447920-1-max.kellermann@ionos.com>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 52335A0004
X-Rspam-User: 
X-Stat-Signature: bqp5jpc7gzgwkgqz15ak73wtq635fzax
X-Rspamd-Server: rspam09
X-HE-Tag: 1756331314-866104
X-HE-Meta: U2FsdGVkX1/yRBV6rAlxJ974qg2xdA/evkO6JlyEArKFJBBa+AVAW9bNAzPrZedSuVr4XLSeHzPu6a5HdjK+b4KQHsxWDXA7XBYnvez5DAV3UzJWe2SuGJeZ790YFwGToTuc6hijgq98HZOet4fo41oIBbPzd/2H5oWz9l8OsLiRDClGakdE15hXPEoiRDkpUGHSqa1O/q8GebqzaTCIkd2joH0eqknfIyjGOqC0dkAAWESdzNrYbuTRdrHvPKihN8SV/6iW2FW/WX8+257SdzGdeTtD4+E+UvzQL3fkRg+9euP+m5KbdSGCvCdVa/Bxzdvm26en/1oSPUYNEX9Nfh/n/TviDYBbB6bDPjqggy9XYSt3/koTRl3nqSICHvqwsQdBrmEqRUbD0fYbqdsLU10AZNvNY4orkLBgO+TI9CNkrwh8s8NPmvwg1Fioy79K5/eawcCPlwczxIbLv+Xn9SB3MhHe5BVKUxmDyiIv78bIgyeoJ2L0asbQcYrzogClbj+uF5tkPNhgIijawC1CkmU0+t78PNC4tKMY4ZM0c3zmWL2A3CmA05QtW2KIilqKLnhrym4yZbmfP4QRnMyqsYN+0SkB9RntNi1TSf5wP05XXJ/KVJjLDKwKIkGZYLLj8YTNrrAwJxyMQoWyN5Fj1qL9RaMhaI5ehU5f++vyXFNpw7HI6AiP2E6N4ueK+49TnC0tXbUvQr85tU5kEnS9t30jP4XkqQUq3VEMUDkGiRX01KRD70H9xOxH/XxyxxPF4tlegNCPC5GF5N5soE2Y/As5doHNHw59Dn/Y6pQVkiDUNGCcZyh4ihx2Esj0d4TAEUnT2ZtqLiLiZ9KGHoNDopRJ73/t/eJ1cyZ4EFY6/02qSU5C9xnkUkCV1notkqYysKqcoC+FrzjmIOm/hz0ubof617z1+6auGFLirBxmGZ0LHd6AGkuOJe8SGPzuUSm3ScCoTt42TDHAuOOG2de
 /9ZWFB/B
 5znSmTyrYU8YdHT9TLzZfLcslwmfdwiMe103vQQGGVP1PvOtFMMP1e9mwbmVAtIIy0SX+NWGjHOuheDeBdqNc1CBzJ+sp5rlSize28ZnRoDGgc0bIYgHhfoafYayxWOukgajERwnGajmRxTxQ5oISssg4+ehvbw7IuzDwUV9B7fz06K2EfEtG11Smn4z4H82JKdUJK0yvXlFc8bo63LPjOHWpwavKgzrEVO/R2Iuken4K8gll9BLXS3paqnqy/7RCqUVwt3ZI41q0eR346/3a3nVvKhIHljMPyDlbnU+wRNzj6BMFDk1w3Wor2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 Aug 2025 21:22:33 +0200 Max Kellermann <max.kellermann@ionos.com> wrote:

> For improved const-correctness.

OK...

>
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -537,7 +537,7 @@ struct address_space {
>  /*
>   * Returns true if any of the pages in the mapping are marked with the tag.
>   */
> -static inline bool mapping_tagged(struct address_space *mapping, xa_mark_t tag)
> +static inline bool mapping_tagged(const struct address_space *mapping, xa_mark_t tag)
>  {
>  	return xa_marked(&mapping->i_pages, tag);
>  }

I'd actually be in favor of making all incoming args const (C should
have made this the default).

Because modifying an incoming arg is just obnoxious.  That value should
be viewed as part of the calling environment and should not be altered.

Try modifying a lengthy function and wanting to get at an incoming arg
only to find that something in the preceding 100 lines has gone and
messed with it.  Or forget to check fr this and get a nasty surprise when
testing.

Not that I'm suggesting that someone go in and make this change.

On the other hand, it would be neat if gcc had an option to warn when
someone does this.  I bet it would be simple to add.

