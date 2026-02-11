Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15423ECD6F7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC646B0005; Wed, 11 Feb 2026 17:23:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F5C6B0089; Wed, 11 Feb 2026 17:23:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643BC6B008A; Wed, 11 Feb 2026 17:23:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC866B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:23:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E63BD593B4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:23:11 +0000 (UTC)
X-FDA: 84433602582.14.18C5AA9
Received: from olivedrab.birch.relay.mailchannels.net (olivedrab.birch.relay.mailchannels.net [23.83.209.135])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4641A1C0010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:23:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=QU7y1Ajr;
	spf=softfail (imf18.hostedemail.com: 23.83.209.135 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770848589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PONYIdbDGRxdo56DTcMpUfL2VeqX9vWTpesN1Ub95bk=;
	b=r55XaiGRD9pMNjB0H6zW3lQgVuxx3mCyr03kkP9kQ68FMI7EgS/S4TgDX+NGybx6zlY283
	Ro/K9lRcteNiOqfDC//q46rwvjgCPaObpHMWbLIfmUP62C4zjWUAkBSB0rWlsYAEZbk6LX
	HWgUHjGe60at/E6ZcmKEpROOiVKpyt0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=QU7y1Ajr;
	spf=softfail (imf18.hostedemail.com: 23.83.209.135 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770848589; a=rsa-sha256;
	cv=pass;
	b=vHhdy5tY657FrPDpL+3cDjYIV90lkvXNhTwfgP45mCSZ120Qby3xYf0LD9gRbFHEBaHZXu
	fbwW7IqZZRszQYdWxZbhsMjEj0JKpbNJSXrGNYv488LFbNPefJoIOAe69bjAP0GWgq2WJK
	2JtdPEXXnncowKgUOJ5/25WPNixXQ6M=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C10F944199D;
	Wed, 11 Feb 2026 22:23:07 +0000 (UTC)
Received: from pdx1-sub0-mail-a251.dreamhost.com (100-96-86-174.trex-nlb.outbound.svc.cluster.local [100.96.86.174])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 452BC441A1E;
	Wed, 11 Feb 2026 22:23:07 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770848587;
	b=IypmqsYIeBZwbj16uTuPsarvT3ON3Vy6pmMNPSgl0hoZ/VDvuZn55ohmZIIJ/Lfw3iS/23
	TeecAD390LyowofmK6q82MAlgP/9J33ZPx168sTiW2/Wla6RLNHWuDx99jCL1PwK3VWxC9
	uFK4wEXzWPR7hIz1UvtYoVXqLXJ05LMczQZjeHFkDsocFcrOtvyOOVSTaM43RVGahcAGXw
	OpyDd1C1YQMU3F/VY9tYNoc0fmweffGKs3YDcZn8eeL1Se0axDaqO+IpwVM1TYzS434Jt0
	r728vEwhDuj3ork9F0xFX3YdtQdmZYJBuSHGw2OeeqVICCFngLqVItVhIO3HHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770848587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PONYIdbDGRxdo56DTcMpUfL2VeqX9vWTpesN1Ub95bk=;
	b=uzdNdLen5mvUQkOu5dpYKKJEMNRGNPMAEcAwpbj75UB4hGdKqS4mHN8EMH+EN08PvL6oRw
	MZ68A+4ktRQwOIslbUNj48aiyX7cmZxRnXavnAqdjWK1EhjiOjt5YZWrIXoZA3JqdmT0oc
	AsYZgix4nuOJWVr0+hNrmtnH8IMBy1EwAKunjxj2Z770lsdvNR/GDtETV8EBGKOy0dMWy5
	1FxW8W1vHroev4Rut5gNj4/DOxlMgnF2k0a217Tp57u+nBXo/tBAKH2mCgcMPfKBR6vTcC
	0dD83sUWjMEJXZBGtHpgoeAHKpilyffkvQmwxu7NMa+najGhEBpWp7kt1xenNw==
ARC-Authentication-Results: i=1;
	rspamd-79bdc9947c-w8xzw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Befitting-Dime: 0ddd63e94dd79c47_1770848587598_223137175
X-MC-Loop-Signature: 1770848587598:2068019580
X-MC-Ingress-Time: 1770848587597
Received: from pdx1-sub0-mail-a251.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.86.174 (trex/7.1.3);
	Wed, 11 Feb 2026 22:23:07 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a251.dreamhost.com (Postfix) with ESMTPSA id 4fBCcV2qX7z1041;
	Wed, 11 Feb 2026 14:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770848587;
	bh=PONYIdbDGRxdo56DTcMpUfL2VeqX9vWTpesN1Ub95bk=;
	h=Date:From:To:Cc:Subject:Content-Type:Content-Transfer-Encoding;
	b=QU7y1Ajr1a7JKLxkXZWmXPu5llbF+rk9H33Ux5srLDRFR3jGMgNXO3EazwSlJOO74
	 rFzzSWY8KbDsbgkCUv/ors6d/cg3U6taTgULmVYzyIJCvN1NDpg6BMRs8KPueHJxfZ
	 IuOXzmXb4dpnKIw8uLnHETQifiWtSKFjg4BufO4boU+UPABj5fXjNZsXAYjgCv8T/s
	 q5gktzcj2f6PNrjlJssrVGxJy6Gd/JM8mHRC/WLkVhWxK3JBxn39Vj9pcGh0Hmg1b5
	 e1PC/NSuvJz3ANjmx+pCcsT8JKySIzDb2g/hLIcMCgHCJaefuF80oZUPOHyGKrfeNZ
	 XGMPLpCreYB2w==
Date: Wed, 11 Feb 2026 14:23:03 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Thomas =?utf-8?B?SGVsbHN0csOvwr/CvW0=?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <20260211222303.42qfp6rqxxnpfkr4@offworld>
Mail-Followup-To: Thomas =?utf-8?B?SGVsbHN0csOvwr/CvW0=?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org,
	Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: qzhjimxt4fxyhmd1s8hgg9ursrhdy7qs
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4641A1C0010
X-HE-Tag: 1770848588-189023
X-HE-Meta: U2FsdGVkX18X4EZ28zXQNAJvZjVk+hfsfdVp+Ia3UliQbozRme1Fll1Sbre2wMvBcjgc8CeJKvimX6qywXHdOHSA39Pq8byCcanNjnpMeaMMdMCqh2JOUj0rpn6Cgy95yEr1QFWaUzrh02I5GAku8pzs5TIV0cH8cLL0uqGruQD2Zluh8TKFk8Erg9J21CzcApCglg09ErDWqZp4W4EuZSEA1UBqIuwNLg0Oa8G6mk+mj7sVYuAAeyQhaE2umoQbsdCfhL936lz3UUHARTCCYYb2p2mUJsOUyF+z//a2xjFCmy6sch7gmVyleJ/TAEE2qQSNkjzZaDbQPVfCnzIXHGi7RDgHunabX/ZTKf+Fa1QpsO+I7Ud26HICW3l6yDH+xSbhkie1B0+KgxzlPvz2aYqqO+2xwgBRCqz2NM/NfF5T3FvD4NSLGog8FqzpdfMVuRkAyo5hus5OrbpQfK4W3g3bmE9uZWLxNip+T4agPcPzx2zv301RhEzq8cHhd99mSwwkiZomk4AsqrKyMUPjyEbE9Q+zkUJphQnVesxyeTskzCutyaThicB/o7ulgLvJzCTcIe5mSsjnGBK+iVWopl2Xo2Y7pc92nfQQGVCX00jrc3FIq8S1d0vJsFaleSoo+sMkTTs5DaRHYOyicSKXiFKPZwr3zSUdvRYFJttWXCLrw0KwqmLL9RRaVZaXac6u9fVBddYs8XM+ombyfJHH1nOKgDW/gX1LerROY+A6kdXfBtzKE9jB0IVdxoiriGjVvX2IG2W8ZOOlRuWuOEVUZFUzfSJw0tv3KQSf2B2F9cPE3NvhVJee9YXshg3ZYkThIYVWaeklMiTN6nkKSmahGHxRxdsnu6hZ9DkposwE9W7aVP1cDMKJoYwCX4IGx8vqX31mv7shPFG9f8lAKYtGSszZNKx1EF/qh+2Ik9FxdWqUNfDNd5XJoP5o3klgq/76lfaXsavQChspY2fa7t6
 JGletWEL
 mIzsaOnPZsOIdVJJlcrn0Q8Ta8fDi1eJWRi9UDRydlRGBF8WS0bZHku+7OIWoz7R2sVW+bEgLtGbGKTgwQegFonKzn86sceZjL0LZm/Gv25H6YClKGDKwbPlW8RCd1XHoy6OWsyVxLTi0eVJk73KF1m+IBR8E68qxuTr3C8zJCxX32+h/j9wS9n0SiNH6YKvEQOoyEPMv+t2jEW+U5xaxuHrxhh/EXYesvodBtLvVW+5eR2xOOvI1ZrDxUcIJ0JJg3ug5WXOhCl4hvnU+Fhsw7G072HWoeWT6iVbYDj6BIq4V9lLS0xVjcvmpV+Y5/nEu0ASrCaFG5L05dF8wcMmzAhy5mT8shLNYKpNoP7GecZfZ5s8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Feb 2026, Thomas Hellstr=EF=BF=BDm wrote:

>@@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, u=
nsigned long start,
> 		}
>
> 		if (softleaf_is_migration(entry)) {
>-			migration_entry_wait_on_locked(entry, ptl);
>+			softleaf_entry_wait_on_locked(entry, ptl);
> 			spin_unlock(ptl);

softleaf_entry_wait_on_locked() unconditionally drops the ptl.

> 			return -EAGAIN;
> 		}

