Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25994C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 20:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C9A6B0005; Sun, 28 Jun 2026 16:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D346B0088; Sun, 28 Jun 2026 16:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64956B008A; Sun, 28 Jun 2026 16:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93B026B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 16:09:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1EFC71C33FD
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:09:01 +0000 (UTC)
X-FDA: 84930410082.19.E6E48F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7C7901C0003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 20:08:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782677339;
	b=O8wV/DXOitxvDeGMraL7A70EwlrmjN1bEgak6FJEgZmjfu6JseshH/youW5ai4dQXSAduc
	B1JpLePc/dWhXKWLee5VlJGp7MYzi2oQ6Fs5ggEEaI7YeGrgjl0MHry5WkhFedbZ3WGktN
	FWS0AhQHjlu3KZJGXxrMiqOMnOBygj4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782677339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fQMIAmkwoxSiV/Pzdjy64QfPd7kY8krFNQtXtdik9PE=;
	b=ALrufp6E7rSVi1JPiMF9PdR0D+3Na5EM4r1Sw46fPm/dXs7Sm5mlR9LYeLqYiSjnuObrgo
	2KnlVzPZDXRGjM8zE0rXYpUFX0Y4LpEsMJFW0GcnuUFQXrPAbrrTZFr2mJigCKUa2v/W/l
	IjKy1CkaeaPqfY/yZ0IfdYf6+Ib2AX4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA5006001D;
	Sun, 28 Jun 2026 20:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E4AB1F000E9;
	Sun, 28 Jun 2026 20:08:58 +0000 (UTC)
Date: Sun, 28 Jun 2026 13:08:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Imran Khan <imran.f.khan@oracle.com>, david@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
Message-Id: <20260628130853.7e20a6bba55ae1c6e90ec922@linux-foundation.org>
In-Reply-To: <ajuED_MZRzDuE3tJ@lucifer>
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
	<ajuED_MZRzDuE3tJ@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7C7901C0003
X-Stat-Signature: xhoopuoyi3fxqr6nouc3m9q9kerubzpm
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782677339-860261
X-HE-Meta: U2FsdGVkX19LcGJKEaIJ5tfhyPooMATdhGWfT3B0hiw03lb9f1OKpEMQkWM2IGpve152ziv1bGjK65b+6+bNBi05Q0zlEQNYaz7oFgkyhnMO+hVWwwPM6TWbpYUwlFtvejK1arokvcUmBJ/82OX2CWfSJPZZs+OhrZuyurAsZrb8hPM7T25DfhoSwUtgeZg5KAlUugoizmsIHD/ymaABp1Ch95G4sLsNQHlXGJMo9TFl6U2GTA+h9Q7nbnS5++0lJxcUTxZuWMrrY1LqkYkPLQ7HyJjqfMfPBrxwAZA8ssN+n3vSvQkyFs8sQfx55BYqvUqytwOwPvxN0I+BsfAYw+KJ7PDp3IBAmevE07mFVdd2LG7MNDYuPDP1z9URXgm7+jrSk1xKz87iA69Fph2zeRRdvtTSojSasDuTUs6THZwQk4Atx2xl7Tf6xEC/81BLY/zUINHNgYVYlSpchBQU1vFyUkqwyS1B5IYeVk++L9gxKbP3WeaVSIHbWeUrmpgL1PQ3SFRB/+ZBuCWT+lWtOnIdLe3i5CPGMTJ2nby4xdRULIyHJIH9R9g8vdmfvMAry/BBZ+tfMCp4dVOzJ57jyyq5Bx25FFZh4Z4ohPtxpuH86MdkcRCOzTmYj/kDRYf/VHGFRMt5mWObIYLQqa9TYMYGhXeyrNUXhPRFZnj/3c3JHMPh6JTiVwAROaZyVP2nCf4KmK4NOsqYBuoICjnRHTcGv+GSGDLqq54u0JFIpu8vO8S78TSQq9NqhRzyNvJFwob79j4vmBpot6BuEooBD2tAbBPiLBzelkgu5ef6phB6cjc0fdUkU8lNFHpefW1vMZhcXYI5PPjhbGWjauN9xJiJ/bvi8Hijjepbxdxa7sQl5b9jNDGKT5AAiB51qGZMy9s0yg+G5fFI8e06DMxumAd4tlFEHnCtj6wJQtxsGaZ7o0tPYkHTmNwqorv+9KVpAxrmuzytdxUW7n5cLlM
 Cny2UfpM
 g1Vtpo5GrM0EjV4TzdQqkHuzXjQeOM/WS2XyGgPBYFaXQ2yf12laXwapUKXx3OV+XEV1u8NMCedJqJyHpTXLYkXrBYQfNaEKVyMQRZy1iqbPMRCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 08:16:50 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> I think this one got missed last cycle? I don't see it in any mm- tree, and has
> a bunch of tags.

It arrived during -rc6 and isn't a bugfix so I put it in the "next
-rc1" pile.

> I guess Imran will need to resend it at -rc1?

Got it now.  Thanks, all.

