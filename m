Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C337BC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C196B009F; Mon, 27 Jul 2026 14:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514F66B00A1; Mon, 27 Jul 2026 14:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452636B00A2; Mon, 27 Jul 2026 14:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21EBE6B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:35:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73B7F160177
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:35:34 +0000 (UTC)
X-FDA: 85035409788.09.9F2BBE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5A654000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:35:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p6tOrDOn;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785177332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ViR6DC/ZvgzwYbu96XsomABAIBwdE5dXzIiaRXSJtpI=;
	b=k/iZHJVZJ9KfxAHLweqG2ilNH8bunx2pC236z5BIWNumjQ5i/KF1ZlKe8aq+KC7lKrVgF9
	ZJxIxXRZHcf7rYi7GEexaS+vECqRgJ27l/48Kvz+Oe6JGMsU4NFasmTrhA2IKUcSH23fxj
	n0Eorbf3QXNutox3/h42EuseojDyQ+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785177332;
	b=1xLr2nF12eGCm79aYHyTUbgBiEhgPYCe/+bZEdLa6/HMCJ1aDDaVxkpQQdxL2cnnb/VPbh
	EiNPjLlgnUtrM2i/W7c5qPPJ3N0pYQJSwc4oJuQolxyI8tdI1R4BfFCUgG8n9BMe8FO88b
	ZLpEjHPjXD/4VrGKxaSKQi1MsADSM8o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p6tOrDOn;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EB9260008;
	Mon, 27 Jul 2026 18:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ABF41F000E9;
	Mon, 27 Jul 2026 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785177331;
	bh=ViR6DC/ZvgzwYbu96XsomABAIBwdE5dXzIiaRXSJtpI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p6tOrDOnq9TjYLbCW+1lE+T/5SWNyB5fpetZ4Nf2WdIKeCWCVA/e05WnfeNKX1Gmt
	 UrXdMhCwKUcph6svYM+yL3QGbrzOuQwWZxcmJKs9umRexTqsKt92PoLTVM5iUIgDpD
	 8v0zrIz64eQ5WTULfU5ERZwUEsOePmTNevotOKQI=
Date: Mon, 27 Jul 2026 11:35:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, luto@kernel.org, peterz@infradead.org,
 lance.yang@linux.dev, usama.arif@linux.dev, jannh@google.com,
 yang@os.amperecomputing.com, rppt@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org
Subject: Re: [PATCH v5 0/3] mm: make persistent huge zero folio read-only
Message-Id: <20260727113530.5cd347581a66b3279490a604@linux-foundation.org>
In-Reply-To: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
References: <20260727143426.1077133-1-xueyuan.chen21@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s6qh5jafiox17izxi15wc7oogs1cewcn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5A654000A
X-HE-Tag: 1785177332-995300
X-HE-Meta: U2FsdGVkX1/CXwfh1WPkUE5lH07UfpMgmAg9j2A7zCW8zC/KYSQxdwotniZg7cAtsXAmzUgec6AR0zrrTGNHNiIpOSFNgSqitosb0tm8MAUzny7Qn078xxXCM6hMbqyjNUo2OFW8EYBwOPU9OS2eJIOAcb7Ldzxo0s+HNYTeR6NYgVwVJ7PgYwNZQGO6tawnNV9vUmcvPwG2S5iGueNWFxiuw6C4Y6iPErj/H/3Oc2RMDzQ1wi/H1//Ic6D+JwzEnnT2epR5+sYMFrn8/mSTktNLZXkz38OJEcYkqDvCDYoW6WCNKclx9JRFFu3Qk8c94tE08zxr3/i6pVcdDvv1ERC0+0f11c2rFEKgkjl2h00EVrMSJv4y4U/vhahqu82Vq/BsDmYKLxsGbg+sDhyD/5wb0bkyb3w6XSzulshJZ3iqSr9P4pJwZVOq9+uSiIvsjjYUQ9P8s8bTdObDFWAA+MP7K/sCOvzT5mRby9zWcJBBurIc1GE365UfAZLoVDx593wTRFP5xohGGHGdjXfw1FPQt6N9/tB3M4m5J40SKhz6BjQ0f/IXulJ6SL624qx5Wzh038m0/faj2X68I1eP3t+bsA/UE2/RNPwPXmy+lZi8/RftHE7bYSakjtJf9F2WjHK5TbOKmEXPvNNfl9DbHQ8V/tbXSSwJUqN32WR0R5dwH5TtDCGSCmhH/EI2WvfNgPtic8IJBM4Btl12qImGZurKyFFZXYwb8Bv+bZrU02DJ/dbmaEWfLan7fnhM6Gdqhzi2ngxtlRhj8mTocqgHtU9oEOwK83uyrCUogQRLqAXd2WYRthoDjrR6POx8wWLDQmfd1UIhX90YPhh6jNRhtK5wphC1PwjilvuYnHgzA7TndFzEz3mffKo0dAROmkBl27xbSITq4z9IDfCkRyfT60Ll+X3KEoJZ06kBQgOfWlMAjDqnAmjhWyJquViqJgbswc6F4IwggPAqKr2EMla
 iQjEkQiw
 SQjKfodSKuQmvuBq6iD9JcWGk7/ot9HhXl5t1O8UTJLQcvMPDhKwb9hsJtuTj3SCl/NfGqYy3WC4EQKHiXKwQ7Blj2N92/LeNWAa5pEeQJUAuI1I606pP1PWeCk88MzWEXJZhsHCmfo/ODzmMH2YuwfiKeUXWbvxywK3ttI8wAPfxZREv4QsSXSdBRqkCpu8VT5ms/cnaqdeNAHuLUcpDKdQXJdE8a/Fih2mnW62R0etU716YXLqyS0eP9MhedUPBCSC7kks0tljuwLs+M9gXZ+m34Bb+/RFG3eT9Zn9ylfUWtDfXkxL8GyGcuBj5ilgbuXyERZ1Jw1xQwRADQRPhInijhk2e0pzaWBYk5SmqlY1qqFm1+5pUZ3Dz333KAseTCjpJ4tK+IXS6FNzQRsTVrdJm1+OsOwXv15ueuY03q7Y8D1yLkQjWY6z4YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 22:34:23 +0800 Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:

> The persistent huge zero folio is shared globally and should stay zero
> after initialization. As Jann Horn pointed out[1], kernel bugs have ended
> up writing to pages that were meant to be read-only, including in
> security-sensitive cases. Making the folio read-only in the direct map
> turns such writes into faults instead of silent zero-page corruption.
> 
> This series adds set_direct_map_ro_noflush() so mm code can make a
> direct-map range read-only, then uses it for the persistent huge zero
> folio. The helper is direct-map specific, takes an address-based range as
> discussed for set_direct_map* helpers[2], and leaves TLB invalidation to
> the caller.

Thanks.  AI review asked about a few things, some pre-existing.  Includes
a possible pre-existing ARM barrier issue in arch/arm64/mm/pageattr.c
	https://sashiko.dev/#/patchset/20260727143426.1077133-1-xueyuan.chen21@gmail.com

