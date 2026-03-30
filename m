Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C631061B22
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 22:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E226B0095; Mon, 30 Mar 2026 18:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEC06B0096; Mon, 30 Mar 2026 18:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13CAA6B0098; Mon, 30 Mar 2026 18:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 071DC6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:42:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A01641B8DCB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:42:36 +0000 (UTC)
X-FDA: 84604205112.03.6E97EFD
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0CB218000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:42:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lFPaTKqf;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774910554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOzLtK2W1VXiFd7PdlgYDJK0jWA7BV31CiHuWpEPBJA=;
	b=tqDCK477jgIzgAt+uPFDNcbjOolhtKx2X7LQR+HZmujq5A87LGnDJkotMlWFwtvafEXTHf
	7HasoIQC7O/++y1xr9DL2twMKfw9fbDWgoZA6HtiIm2AokeDwqd9k/FX8XfUma6Lyogty2
	Ci0dS4sVQd8WRzgckTiO6cL8ubokHbA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lFPaTKqf;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774910554; a=rsa-sha256;
	cv=none;
	b=Soy3RD4cg31KSwNrIKMvHEUKKlO6FZZK1+05P9ihakPKM+PgQ2No93p6GENUxnTl3C5PMb
	2RCgs/+DlePZKGUUpNYGtn+o41SZFPCaz2gztDyQlDdQSJt4Dh9U0UoEZGWtdYnDByQNnq
	r4rcJri6ILCSNGlYF8ANy67DHDrndwM=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b23fcf90b2so28811985ad.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774910554; x=1775515354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOzLtK2W1VXiFd7PdlgYDJK0jWA7BV31CiHuWpEPBJA=;
        b=lFPaTKqflQZQS+elPOyMxdHlOzlDSijXEZBACrL6ib1bXUQTJu3FvFW7pSaNBTf4mt
         v+s/cv9J3aef1Thm0yO544GPfVDKMfHBxHbhFVeifcZAKxprSHbTj963Ja0Ym0TvWZfw
         oitdboscaMPFvUqyUZaNfw795CI0GYhySspGZMk8i5G8XM5I/HZvDIOiBfT4vjw3fMbb
         GFR8G1As50MmIhzzPei21pP5Cs2ZBl5V3hTNyTCqX3WmC8I4ZsiIslMvJQ8hHb2FgGJL
         I8ZTg63Z5tp4bo1OIFTtWtf6YpD8SRV9r7Ph5yyx19aduTxVK9pt15NFVXkVCP2ZZZ4/
         QK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774910554; x=1775515354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eOzLtK2W1VXiFd7PdlgYDJK0jWA7BV31CiHuWpEPBJA=;
        b=m8gc4iK7dmiCNC+osfvXo4sENmtuMnsY4bWNYBhdhUkeP0iIV2tUkpaQAquAkYA4Ix
         iHhRt2aTscHgc5yO3b9fjKcUcylxL3UgWIUpO8DeCkGXUr8nazyEURv+c7AH6D/kFgUE
         6kovgvwbHJLvTyL3YR/VPVFCbKIx40eJsXv9znzJ0F/5QlKSNz5FjXFAVoZoEunaeDOp
         GVyGDMDyCcoEsY0/TCTnxSsALxDBdbqiTX8Bgh1TlHz4UU7SXo6hYof9Z0kMXXBhDttB
         OXmRrVSUQbQT80Ai+GNah9leoW5BdJIVFZ7bOahapxerajnWKQZUVZdH+pnl0P+mG10s
         FWJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHRdbV/6yULpcSdn1eoLEw8EUxBso0z8SqUQyWiYeFsoW6ABfHV3KskcflgY5rANDd9DwbA8xS9g==@kvack.org
X-Gm-Message-State: AOJu0Yw81ne/W0iVKw3CHH1G6249BU8An8KSwzBK3s0sE7gUJOlBCstA
	r1/NpdspxK3cImPYdHttlBnSX6BX45InVfXOoI94qtpDvJOKxokOCoCP
X-Gm-Gg: ATEYQzxdKgdP0YqvVhNMus3s17MjK3PPa6NSu4Fmr7oz7mG6wv4+FNoG1xKeJAInGKF
	1Xbnml0wk935FyDIFXjFbAAltySC1dQIhcuLhkAPBdlBvxxx8Yg1trCSfHIIc6NoMazk5iHSTca
	fB3Hos9TE8b1MmgRSf0MX6AuWqsuRgtW7rvNvB5wzYpnbDWv0tXju1AqwZN0HAZ8s8RBik51LZp
	LX+xBwy89NQQjC1FU1yXrZeyAb40QCFDcfOxD2IAgjQzPz/cMEV0gkEIExepGVL2ZnYF1/r3meJ
	wV4CjfbDUq7LofjhRtDcjkeZ9dva4uhqc4/T9876WszNwm+IO9hIcAyN6XwiS/neNxDyhbGldWD
	5OyZFBUs/bTzfy9fiFU0LR8Uq3jB8mLQQ60kJ/edYNfyeGJYFDZ1xteap05yLH/d5lw4iqrt43K
	rJM+WQq/sqHXF47KC/2gI+SmPzqC8=
X-Received: by 2002:a17:902:e809:b0:2b0:72c7:3ed8 with SMTP id d9443c01a7336-2b0cdcb074fmr144441025ad.25.1774910553555;
        Mon, 30 Mar 2026 15:42:33 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427658e4sm110689335ad.48.2026.03.30.15.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 15:42:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 06:42:32 +0800
Message-ID: <20260330224232.14212-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330195107.71609-1-aethernet65535@gmail.com>
References: <20260330195107.71609-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C0CB218000B
X-Stat-Signature: 4fh1763y5je6s94b9jxc3ggnqip7sh1n
X-Rspam-User: 
X-HE-Tag: 1774910554-392491
X-HE-Meta: U2FsdGVkX1+ltOXCpKcI5748OaARJM8nyXbtyN90i4lcM1UeRrOG/tc1EeKNv6vlzwTK9JMruvUfpFsQvw5RMs4lwOKQroL9zzAWpLp4JT9LrmI5WSx+46DEdo/+PPflTgeBLrAqOV7LRF3EA1NqoOayWubEi2XGyCZfs7jjnEJ5hKZNazeVIjrxOojXF8My5iSkkH16S5uakP653dlT+RHgA35ECLKWj05r7EWLNVgqJf2cxP1a5m0bq8gVzGCtovqDwKtqmjxfhw2qxHn9I5b2cmiQuRjyPQlYcIxOHj82K/rLzKrgFp8jB7NUSGepNOkBepSHjLSuBMLDlorwU6tyPjuIW411F3OpjHXSx8Wg6X1xuyHoVWu2udQr3fZHqMvBuW9XdwrEtpEu37QLABujEcTo5PF1kvSDUT+pR4gK/Si1uLQqpqeG+f0LPub4nYpSJf9BP6t25UkglHLHX55sHPz14x5MD8a5uGUsn7TWMAqtHqu689T5QZAQYR0wMHDhopQRFikwQ6FVzO9frkmcn6pFFlYndpIbxhvz72laavrBXH8fRBZTxtpmeUpogogtrCh1lA1SJYuCkKXZosMFCDwAM9mdRXvctlhpmMybnTdZaXlSz91Pv/IEOUzqPmj2czrIrTZtMvsLXPLc7uA6UhqcxiIqtXddG7iFEPPzHHdYvW3wiyOZwNmcD5N88iPZ4WXswxnAKYQ0EBS3C7KFFS8vx5nP0nK/jfr+oTDuPgQASDLKudqyF9Pb3DZhEQev69/WLDH2jrcRIC7RZgt/RadjV0lBnEnVKfAqeUgLoDK5Uk441EbuZtLWvORoxRz5ScZoD4Ky8hzOHRefYfNW4RTWx2F4MnAFuYcGQNQsB5/1xuipS3qQCXHAqfeJs4tSJvHVqc7CZklZ2B0QyniewcF9gDXasiLclrDuRel0UJ+JtFB/k3cwzUDXH4BAfAlmEJelacSwF6eeIP+
 Hav5Tfks
 oWhusYk0snJdOe8MxqFN9oSTrvxUs9D32oA3nbSJjuVdH+SVEz/5NqG21tgyqem07SyznbUdq/wifVdOCa6RxkemBP6eyQqCoa9LV78+x3joUnavTd2ChQG4gPBLAdJ6W4+R77z3wzxLberWjW4e0F9JWBmnxIsUJXkQ3B0g+20Njmq4bff4cJ+z2C9Lm4CTBtlYc3UtTPZtxTBJQ3M+XntPLSZJuYPKVQ8nwcxjlwk5O2t7sb4Ou8pMzWsX23GIUGdBO2ulGVbBqMn5X46VnlsyUgOcaFrt3kGWh4ViG+QYB2KbtnxWRabxXXuP4EYnjW6eHwPvfKR3AG5vDEttRem8NXnOExZTXBmKOpLsaOODSULzX09VwLLRZowUAN7GMsI+ZVUJsmzPxeBdtQreOTe4QLuZkyQacuf6C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 03:51:07 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> [...]
> > > +static void damon_update_thread_status(struct damon_ctx *ctx)
> > > +{
> > > +	if (ctx->thread_status.kdamond_pid)
> > > +		*ctx->thread_status.kdamond_pid = -1;
> > > +	if (ctx->thread_status.enabled)
> > > +		*ctx->thread_status.enabled = false;
> > 
> > Can this write race with the user enabling the module? If a user writes 'Y'
> > to 'enabled', the store function spawns kdamond and prepares to set 'enabled'
> > to true. If kdamond exits immediately (e.g., due to invalid targets), could
> > this line asynchronously set 'enabled' to false before the store function
> > overwrites it with true?
> > 
> > If so, the system would be left in a state where the thread is dead but
> > 'enabled' is true. Subsequent attempts to write 'N' to 'enabled' would fail
> > on damon_stop(), leaving the module permanently locked.
> 
> You are right. I now see the potential race between kdamond exiting and
> the enabled_store(). While it seems unlikely, the window exists and
> could lead to an inconsistent state. I'm sitll thinking about the way to
> synchronize this without introducing new issues. I will try to address
> this is next-version once I have a solid plan.

I think I've found a solution for the race.

In damon_lru_sort_enabled_store(), the current code sets 'enabled =
enable' only after damon_lru_sort_turn(enable) returns successfully.
This creates the window you mentioned.

I plan to update 'enabled' before calling damon_lru_sort_turn(), and
rollback the value only if the turn operation fails.

Best regards,
Rui Yan

