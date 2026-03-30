Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD671061B07
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE936B008C; Mon, 30 Mar 2026 11:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D6596B0095; Mon, 30 Mar 2026 11:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013346B0096; Mon, 30 Mar 2026 11:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6F0A6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:08:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72FD7C2977
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:08:37 +0000 (UTC)
X-FDA: 84603061074.27.3C2A8C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 965BA100010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:08:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=coIyVwBS;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FslEZLGrHdSf43AAIQzFqtD5sOQfPP+idfsBJwlyaI0=;
	b=Qnb+qArRMGieRq+RjX/yVhnqi2wkxvQANTpR+IA4EHIF3azlC2wi9ozJ7naUk7eCwBy9DA
	Z8UYacVuY+xXcZUPGCJQbnmOqEotfYrJkbV9W3zQgTsruJgatYRmIf1tSboWZZn41wQTWA
	Ci4U0Mz7cdn8VaXAx6zgj0fDOkMvs9w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883315; a=rsa-sha256;
	cv=none;
	b=ZnJBSOFtT9bjw1ns4HWXDbA9cAoj79w/uv7T4K8uc2agg5JXsF2l3aWxVZwbcx+jP3yZQU
	IxCBEc9QjG5JJjUS7reR3hIcuENTO1EdVUDIHEky3L0MhHyR9m6x12Ns8UBTKCXQDHjg8h
	Wdlr1WgECGZ1txp8vlMTedjg++4PHqA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=coIyVwBS;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D8EA42A30;
	Mon, 30 Mar 2026 15:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D9CC4CEF7;
	Mon, 30 Mar 2026 15:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883314;
	bh=jOv41rEu/2ktVd7M+2jdo4/n+2f8MJwP1q3KeKnQRd8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=coIyVwBStTGlcUHaMCqxzkWXt6xQc+QcUv2pBlK2+S9cQ6g5Jmqoa8F2XwuH5mLZX
	 75s9iNgSpTX4IIS0iOWSJTXQAcAQLbTTEgv5my+Ck1WJO+L+jZY1VPR/f5PK4NIPP0
	 WWvjELcaiAnLWGizZpHsbZ6g0/y4192eywiuJ0xZ7Qdm5BmIQkg30dtQkH+8Qf0uf9
	 0iz+epdvnmrw8QxQswB6sjQ6sT1ISd5I/700k7DLqJIkVs0XyBS+59zvhSR4t2TOLX
	 /SHMBBCLJJAxqlQVkxc39j1rKXdtlO9Kn8L/5Ud+4exylIIeg+vstTMs7jloKCV8k3
	 RXJWJo9MrtmYg==
Message-ID: <e2933d9d-1607-4be1-9868-e15dc7376106@kernel.org>
Date: Mon, 30 Mar 2026 17:08:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] mm:/Kconfig changes for migrate on fault for
 device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
 <20260330115611.347988-2-mpenttil@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260330115611.347988-2-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 965BA100010
X-Stat-Signature: 79c7mkt79hskwissbb759sw1tmtjfngh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774883315-397374
X-HE-Meta: U2FsdGVkX19Bx8jMWwxzCYciCazz7/GieloyL8Dljwg09v2L2b5aDo0SgCnD1yF/J9vc5KVHZ7W8sg+xG4fNLJ9O0BkGoyyRrvyAgp/NjLge3Nb7pS2PgVyitmm+cV8a7/+3ZgfKVubZITXrYWHXR3sT7OlW/DAyG2dANkdfTXBzxcZtVY69g4cH9KT14JuD0RM5dLAZCKc/pWJdpXlgDB0SCcSIefZ/QEvU8Adu8WcaSbQlac4af23mSWlnxCJRpQHuoiwB2Trb+JUKkUGInLgXN1KD+g2gUkVvi59Jv670xYD2jSeE4ki7qWhyLvg2qmScn3gyTAPxbhjlgdpNR3XZOyxfhzOCJVNZG30chOJKsLM0dfF24nLpRLdRfedReo3l9jMsIkNoIi6U/fFT8jFP3xY2L7EjCKPosJwXFS6WPafTP8CWyL/ULO3CMY7uxY4ZcXIrxJmL2hazLfERkHLDx0S/27062yKNvFF2Tkv9dEyVClo94fy1HQUWcaO9GwULuQlrsUblaKKj3N2SD5/7R/Lh093IbdtmMpk7Q5IA3chHoYDpR80Y3S2rUkoc2gxbptgYN7YdIB0IysJnDqa0EV56JK0+HHBloPskupKxeK/4VUYSbu8daEqP9/Fo2buPh1vFKVVE4A4OtMXgy+oG866LCqI4gwyNbF+nXK1i5HzGioru2oZ/nY/Yb1Ms2WmO57JQJ+0eZwxEHlMi4H4KC9SpNaUo8ATztdvBgrCTZog/FHYCepetC+pr4ja6x6C8qkLxRsZMSuri5PizoNLw1MTyf89jTFYwfa+dhsLj2MTVlhpFC3RDITRTquR/a1Sezh6K1ChL+5aLriNS2Ex98zSEc7iGNmYFOn8XcjHnRff0fMPb4BxKxoI2Y3yYIjoJvKrzsS6wA5K9xPr9AKbslxNu2gdXYA8VPqDqGTGsfBEeErKk77AynKxlvyqlXavJQSVtUvEwFMd71tN
 0J9fvcZC
 CWAUPYISNGhCSqlrGP51vEExhNkz8RAuxNVklG6HHsL5txmW6bZJCWwuez034llwzpnDn9Q8UwHfI6vErIT6Xq9aWD9XRtW/Bs9cf5wcVZd+ftnbZ3TKPHCE5OswuWLc7QvoQDxCLgLHxFMQSlFgmNEsHSJor7nvd7h1sg8wSNVxWKu5aE2rk+UqKqNaNDsIEvEO8Kn/6PO0EYUiu5QKUD8cOaYvbDP65h54fs0EOv+dlEOABsANuRbP0j335A68XkTdEhIwBUgiv0ne1BQJDrjLa59QyOqTsImGSsBUF/LppXXNxCyShHK6X4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 13:56, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>

Hi Mika,

nit: subject should be "mm/Kconfig:". It's also wrong on patch #6.


But more general:

1) I have two v7 submissions in my inbox. Which one is the right one?

2) I don't receive cover letters for the series. Please make sure that
you CC everybody on the cover letter.

I recommend "b4 prep" + "b4 send" for patch series management, that can
simplify both steps.

Regarding 2), if you prefer to do this manually, you best put all CC's
in the cover letter, specifying "--cc-cover" for git send-email.

This is also what "b4 prep --auto-to-cc" + "b4 send" will end up doing :)

-- 
Cheers,

David

