Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27C7CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 19:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3922A6B0010; Wed, 10 Sep 2025 15:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367D46B0011; Wed, 10 Sep 2025 15:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E026B0012; Wed, 10 Sep 2025 15:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D78C6B0010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:49:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99E28139B45
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:49:25 +0000 (UTC)
X-FDA: 83874379890.07.15A71AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 182E720010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:49:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B2QUeXsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757533764; a=rsa-sha256;
	cv=none;
	b=HmjX8sk5v34phMxVBz7FH2iLzOVsxuK8H0KEaBd1yBjVxXqf7m/NlnuWEl2rDBqlrL5pyx
	O71O+yYz3eK4Dd+FY7tYaozOIc0mMY9oDWY5tco1NifoqVsAjwrkydJ/TL7GuUcWTAd7nk
	DoxAtppm7IGTqXhAhUBQ2So8Rx8Q800=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B2QUeXsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757533764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoH38RtYXmoZLN0q81m7nCOC2Xpz+em2/gxxRmxSaNM=;
	b=pCVRBQ5xYTO9SjpXD59atcKelicZZqcwg7Ui4KoT0DKi0zCCSbbzJcOAUDkOnneCs2eTeX
	etiIi68MKjvxO77F/iLu1epAMeX3J1SVLZfaiX67yXAFHypbVs/ylVzfyryW3Gcg+htJDk
	oYTymNvakN0s/6ZBMCkadEHyo5FSa4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CBE9601AB;
	Wed, 10 Sep 2025 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E9C4CEEB;
	Wed, 10 Sep 2025 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757533763;
	bh=VlR4T7W5WUcCl5jM8ND6VF21jkI4rqDyaEM8DrBDXtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B2QUeXsFP/8t9H+uXfCOPC9W7hJbSvaQzKCacm52pDLARWQhOaI6TMggUjJ3hlcOs
	 +2ffNodYhLpM+Ry8vHv7i/kEUS92UQDOCNEw3cR7q6iPZ9fi7rINNkgfeKAA+9qLL1
	 +YGHNXz9Jbu6yORdBXPyU+aiKz1zwAUJ9tdV7rlgVlPgvBAB3QdMiyr/dgnlVMi7ub
	 jfhiSXOt77FKB+biQ8XCc9FFQAET7KoMtskxVOuwO376KJ1ca3Ido85CFZFbkgulub
	 40SSo2ut9ZJD0mrol+e3Wx21uHB1djpQHebJ2CToEgpTLhWjMRUQbNfvqT+bp9tUOg
	 iV4HGYvVU1D1g==
Date: Wed, 10 Sep 2025 19:49:21 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
	kasan-dev@googlegroups.com
Cc: Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] kmsan: Fix out-of-bounds access to shadow memory
Message-ID: <20250910194921.GA3153735@google.com>
References: <20250829164500.324329-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829164500.324329-1-ebiggers@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 182E720010
X-Stat-Signature: tfbzpdyqhbqsypyp9rodeeghqwwkwz3z
X-Rspam-User: 
X-HE-Tag: 1757533763-272575
X-HE-Meta: U2FsdGVkX19woHP8mLdwlV5Zt77TVj/4DJ7kGZcCJSRToVijw+WIGOMOVyqKbstGiZbMfHZZ0EbdqBQAHWIv/kjX/1Pob5zP+Phu+bivQODNyv7B90aw/4dbLpomWO91uzLRdoS3tvmqP+CeJD77v3H2vS+8NakVz3x9Wcpfs0RVvG+uda7p62uJnTSpnNL/1DQlldUie955125obOa/LZo05VLEA2sXih//GJ9Ldh2fj9opo82cV+sLWpk6hch1uiCF0Z6vnBUXwlOwSBXO46aa7JTzUDosb/ZP0xzKjymiBSL+aUWjYpFkLxV8wrceA7GfOUm6JcwF81Kb3gEAqkzP58vIprT/mgiPI2FuHUBej/gEgA6vIhJaa5idqe4wxXDDP70l4pInTBiL+zD4XPTgJR4DGqkway4kAOaEK0BHWdm4HqvMju5yrbw4hE8qUf2vQrCKrAkTTNKDqK57R81tODlYo9Cwg0fhhjwwZyQxqipxYNxnIADJVNYJORiQd46Qpd+F/dnGdxSEfeHusO6eV734vQxCk/Lx1ikW60JtdVP85VR64SB/e3kvYijFIjTTRdPVCV6LYCrEyTLNaeKBcjibhSDJ44dmoDrK+6PRS88kurEVmtfTZcujEyzuoRXF3DnRDkCXTRXBZ3RJr1UkDDOH/MY2BUfMHgxA+oHCe1SPzlauuSZzjRw5HugBlthrRLf+6B0a+XgCeRcy/pmpYzr4C6c+uq6LI7x8WJuk2K/DDlIz7nsvw+o5dkhmVzo9GjJoOnG5m417qkd2v414b2G11Crb8CPyRDODMRg3tIfJH/zkGSiHU3aXr1TEybM55eX2Ap09Ekyjou/iPGbFDojf460sxcxnoHtqTNUdxiyWb86qtdiqdcUKls6AhhXu2TwriRy9L4BUpCiBqtWaN83cyb8RMTxfOP4umMlk6nu8YzTDXM0WuIQVgf5TwIV7y/9tvlp8JqTo1ZG
 7qxbZyvb
 Xzuo4C8S+yD0AS8C54L7hhjraPzzVRlpT/TpVMkdYHCoHeeG6fsYh9jTP/KILfuS7xu9BnYwyurVjpbUWX7PlEoTlUESyO6L9hNSmXuJso3qUBXMY5gCuFnCYkQNKSO6NKGcTsMpu+40fod1FqQqcjdB4uVD59BurzZoHpvNnlzarb/x8RnblbXeusOjUtwVOA+EbNkEcWqXGO8cu9IBxa1ZSX5fqcwVatN1ljQ+soNpxcdFvrVy+PxUsdbF1Xb0gtqUAWO+00Qedkm+r4e1XtP4Xhnfy//hEqehEo1GoA62oJ0bdvV7rfmLHLRK9BIdRYfX99pjIYa9n7r/H3Tka4evHXjIM6z8reBSPrpKW+oOxB9nyMJXyCjFNYsiH6aFEsHtd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 09:45:00AM -0700, Eric Biggers wrote:
> Running sha224_kunit on a KMSAN-enabled kernel results in a crash in
> kmsan_internal_set_shadow_origin():
> 
>     BUG: unable to handle page fault for address: ffffbc3840291000
>     #PF: supervisor read access in kernel mode
>     #PF: error_code(0x0000) - not-present page
>     PGD 1810067 P4D 1810067 PUD 192d067 PMD 3c17067 PTE 0
>     Oops: 0000 [#1] SMP NOPTI
>     CPU: 0 UID: 0 PID: 81 Comm: kunit_try_catch Tainted: G                 N  6.17.0-rc3 #10 PREEMPT(voluntary)
>     Tainted: [N]=TEST
>     Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
>     RIP: 0010:kmsan_internal_set_shadow_origin+0x91/0x100
>     [...]
>     Call Trace:
>     <TASK>
>     __msan_memset+0xee/0x1a0
>     sha224_final+0x9e/0x350
>     test_hash_buffer_overruns+0x46f/0x5f0
>     ? kmsan_get_shadow_origin_ptr+0x46/0xa0
>     ? __pfx_test_hash_buffer_overruns+0x10/0x10
>     kunit_try_run_case+0x198/0xa00

Any thoughts on this patch from the KMSAN folks?  I'd love to add
CONFIG_KMSAN=y to my crypto subsystem testing, but unfortunately the
kernel crashes due to this bug :-(

- Eric

