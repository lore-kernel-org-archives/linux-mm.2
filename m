Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6680FCDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5830A6B008C; Wed, 24 Jun 2026 02:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533E56B0092; Wed, 24 Jun 2026 02:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422E36B0093; Wed, 24 Jun 2026 02:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 208506B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:58:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8847FA0221
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:28 +0000 (UTC)
X-FDA: 84913902696.12.0B250B2
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id B37AF120003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:58:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qgv6xnPX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782284306;
	b=Rf8MjwxIBLFL0ZSqQkeesV5UnrEc4m14Kt8evXjdVA0xCWdHFBPGFNxPfSNiTvq/9GZTiP
	67AAa2QvFHQF/ysv3jRNSd5GyU2csU6piimzRL8uaSvJVyELaBQkPVpriA8lhqOsCBe1Th
	0QQxlyIZ8MRD38AbnI77NgCJYoxBzQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782284306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0Um4hH99oeJ48BWDhTuqgCjMj39PG5+rvU6cG4OaeI=;
	b=KTpCBrOaqzq/FrMaZlHWiBv08V5YBsq1cS196nmLmgNrTLUTK7IP6ont5EraJ6A+rcWG24
	uG3JzVPH8GFjh/hELyd8xVW7M35DTbi54Fdx+1TEl4a7hGDxcUc8e8WcY5ZJFeqxaPsJEP
	YY0+23sIzYPpve56IKOYBq4+HS/VO3A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qgv6xnPX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-37cae998401so363467a91.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782284305; x=1782889105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0Um4hH99oeJ48BWDhTuqgCjMj39PG5+rvU6cG4OaeI=;
        b=qgv6xnPXCwiErzp7aweVx4pop7w+Rx+IwUha4QqTf9pDBr2ycos1xKQdnQHCDaZ2Pn
         aKn9k1jIGDOJonlLnQh7e0nPLV13e9GZsNfzBo/ocfcbbnuqMHkp1lmFC69l9L7GhKIs
         1d1J/FNPWLvgTrdG/Yp3FtzA49pgOHLR47viyEL66Hz0WDrywDZzPtWhDlseUH0z+ZDI
         uszu8r6qGRUo2Te0yY+/MXwt5LUB0ejIzbr4jJ0J8uMn8xMQ4AuKL5GLFWktytMnrTE6
         aA+QtdXjOrtMfEJf7FAhsUCi9BTfISZLyi8lM7ELaw0qjV1FKY+aHuypBMHZwH9eD4h8
         /MMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782284305; x=1782889105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y0Um4hH99oeJ48BWDhTuqgCjMj39PG5+rvU6cG4OaeI=;
        b=X+hoDYMfzyavLjYt1+xPS0wMo92EQlCP3NpXWXrUmZfFploK/R7UfZbw8A+e2sk3Ft
         RCJ2O4JBFTSa2FelFGac+tve1jMAnWaSZjpsNMbKbZdDARmf4kw9HtYfoxxJLUY3OQpO
         Qk+dMaIp8mguzu64+2Y6RG90U9IaEbB2IEYztTi6/rGjOh7/Sih/eA1PSagMW5poC6XV
         AW4iKyFspP+po7cYHtl4Dc0y9HIW2nU3wGCPlQGjNcpt4XXmQPhvs6U57QT85/uUVNjb
         abtQxeWUg9pXraHlk6iN/7eAUA62BMoXt741SV8AiBZl1kOy69UpOriX+a1Phc/XiCyd
         UoZQ==
X-Forwarded-Encrypted: i=1; AHgh+RqMONzZPSZkU5O68I2thvTLc2pLI6QZMspzxeDVEejqcDdD9bv9SIBzNKdniqoJg5KbktRZtZd66w==@kvack.org
X-Gm-Message-State: AOJu0YyFA9ibnAbZRSk9+1wqSvAG9zN4+OqG+WWuw+72C3WC9H1S08kI
	rSq9ccR+URjuFiT58o9wK/F/YjVmA5rvvXUYUU5zPzuVXhNYrNdksJwP
X-Gm-Gg: AfdE7clsBW1m6IiUDMlkoZWlcydaJTpVNsmhqSo76dQs0UWgOFkqdllNwKq0xzmNBhJ
	HqusRDTfqNk6xBDRAX3cpB2wBIDapSOLkrt68VlBtzGKGYtx+MQH+nWq55l1lxVuHaWmvDeJHUg
	9hNiMLGUx9XSoqeHPnSb85FH3MKwCxdbv+ZF0Gf4W15/oHbrN5FwanxWuUGt+88wWRbaHWWL0Hq
	gjZSpPLVC7cGQz4OZd5RZecvttAVwV7Vk5kduDaHYNfYwMuJt49G9brArKUHdWplkhltQ41z0wi
	6dlQcQBeoCbLRVUW6AsJohhjWiwxK+93EevkQ+QANqStlMZ0c0k4NEba0pex6WEc1f2245vo7qo
	jKf+Sme8F705TM16JI37dHy0YlUAiEIjUSkxcHBiInZW3odeHiYEcqIWAxbeYEkDsYPH9gaxITO
	FD0EpV3pDJSWISxMTfseXfAijgktE92yy0T58uA9NgeTIdzaJg3Bxn4i9H2whYvg==
X-Received: by 2002:a17:90b:4ac1:b0:369:7421:b36f with SMTP id 98e67ed59e1d1-37de462d411mr2084324a91.21.1782284305284;
        Tue, 23 Jun 2026 23:58:25 -0700 (PDT)
Received: from localhost.localdomain ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37de3a8441dsm1488142a91.4.2026.06.23.23.58.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 23 Jun 2026 23:58:24 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: willy@infradead.org
Cc: josef@toxicpanda.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] filemap: Remove file pinning during fault handling
Date: Wed, 24 Jun 2026 14:58:18 +0800
Message-Id: <20260624065818.49975-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260622192114.1147198-1-willy@infradead.org>
References: <20260622192114.1147198-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B37AF120003
X-Stat-Signature: 5pxmcd9mni689tqe88uyi6cprk4ps7nd
X-HE-Tag: 1782284306-718537
X-HE-Meta: U2FsdGVkX19flCbF2+mhBN8I//dm6Kmst1MrkAk6fRWhXg90/0JsNBa8gRuUGuNWoi8+4YYHQ95XtO6WwzHzKjt2U+OQg3SoPGR0gzlD04DDdyypIXgowdrk5b9TVmgV+s5ClRtJnbhaIipbfGGIn46wH2sobMGq9u9u8j3t5DgJF5ftTidI1CwB+mgwGOheBg37mrk+crZI4x3ClUxMPUQ+X21Zf2nftykHS0hWIwhm/8XUzSnD1IO41te02MLEv9Ub/oNyxK7eYI6g7t00sfNRlo1PmVqD9AKJ3aEhmPIZvnTtGipFDZxq0KfX8qwoN46D+/PR46lS1kqkLtEkkztiR+RI3Jr7al3pDi7FJ6KMMUe51S90TIE3dfiD3/mtbHbXQEEHhcw5/60mGGbf49/1j6sqRRDM+OTW3tNIk8hZz+IoQlniJLZrhyZD0E7/2EkREjfm41o9dflG6XIpYi/WfTxBY9v3EIqWTsAxyFPNNPydTgIR8W1V9aALwurvSduN3TGswHCwAjDC45NF3CZSBuoVicshcoVrp0WOJ7a+wkXsVNQO4HpjdaXqX5j8IYnyERrFEtFKxH18eU+3MWRNEtC8RP9SPKo/1CsBOHhPaiYr0qBXo7UWKx3l9zc/p0o+aQVYNcMdKvL9PE4EaQqNZ5ko70ZhyqgOeQnmKv1kRc80E7kuBtR2J35Rxnch5UuuyxkdgYc/HZSCw2qf8Zn8p2lDGcIu/Um3XY3Jlg/QwtIVuUYfy8s4/hO6sLD3tX/hQveNdpIcQXOqJJLxdjOmPTJuLmII6WmvEODkk93oKT1KampoMCpGKi7u8NNJ03sud3OCZ3khHDuXa5F1q88p9jICUWX0a1U3pP5beQgFmAcZMIYzgEaf81Wjb5G9AmMbxN5YOD83LAri1MazxvdQNRSnoLz8WTf+wsuHKuvHLXC/RIRY19RwVp1AnqDkH364ycNFXmhQlvhwMd8
 zQT82tiB
 nAcfmCyYx2UPTTWC6Iqo8Ku4sEHa4iskgggKWoI3lPavimaRcjydVlNAP/sAqUVhpBOTiOXfqi0tho0o3Uq+m+ipjWd6YpWXQqUWlB7t2p71c6zTUxYSx2yjbBEPGK+jQn91GAZU/+kbDCR0jXUOP5MYbkw4xNJOkIVcm/LNO6CG8jMzjfHyMp5Q9LZEzTl8SqQYAm0WITnneo54p7cw1cB0EXL+FZ/2FLvkIbc4DWZ/wqW6a/fPLfAe92eZXpfp8CiCK1siy+WlsnpallrMtHAKEMPWEg7WlFlowVugwM9r6nS259wpHB5GbpsHPTFYdEJ6rsyJoRmG9MAy9c6f1RlEsAPNhMnxGEifExfvyJ1eslRo1JY7BLcBE9GHBwdoQiiMIHmR17mkk4sm6DnjReHn5GQsTIHNCYp5LT5twnw7ASAd3EZo6ClXOMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Now that faults are protected by a per-VMA lock instead of a process-wide
> mmap lock, it is far less important to avoid holding the fault lock while

We could have fallen back to the mmap_lock from the very beginning in
do_page_fault(). And for GUP fault-in, we have always used the
mmap_lock so far.

> performing file reads.  The per-VMA lock does not prevent operations
> on other VMAs, nor does it prevent iterating through /proc (see commits
> 6b4c9f446981 and a75d4c333772 for the original motivations behind dropping
> the fault lock).
> 
> We will now submit I/O and wait for I/O to complete while holding the
> fault lock.  This removes the need to return VM_FAULT_RETRY which means
> we won't fall back to the mmap_lock from the VMA lock just because we
> had to wait for I/O.
> 
> This should result in improved lock contention, although it is possible
> that some workloads will find themselves contending on the VMA locks
> due to them being held for longer.

Hongru reported that 82 of the top 200 Android applications in the
China market call fork() in heavily multi-threaded processes[1]. It
would be good to take existing applications into account, please.

[1] https://lore.kernel.org/linux-mm/20260623075805.466317-1-zhanghongru@xiaomi.com/

[...]
> -static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
> -				     struct file **fpin)
> -{
> -	if (folio_trylock(folio))
> -		return 1;
> -
> -	/*
> -	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
> -	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
> -	 * is supposed to work. We have way too many special cases..
> -	 */
> -	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> -		return 0;
> -

Does this break FOLL_NOWAIT users? They are KVM on x86 and s390.

Best Regards
Barry

