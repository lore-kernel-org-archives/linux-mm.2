Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4D4D20688
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CE16B000A; Thu,  4 Dec 2025 08:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C046B6B0026; Thu,  4 Dec 2025 08:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40BF6B002D; Thu,  4 Dec 2025 08:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A77496B000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:31:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 62885138FB2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:31:57 +0000 (UTC)
X-FDA: 84181876674.18.6B7660B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B9FE01C0026
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:31:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WA7ZaIof;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764855115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znW2ij1+YBzOOXe0rFHTvN6YSHRmZf1lRSXFKtQ5geQ=;
	b=D4IF+UROSKz60DmHBuwZOpsQJTu4iZYn0XE1oixgHl0STFjDCoAMVdYqex97uVw+rBvXF8
	1T01i4+U8bJOKRvs40ZHOha3bHnv/AqIhU2yGwF9qrRxAGt4mMK+6BdmGCCfANrOTezyFe
	es3vx9RoHM+xSbLrOrjKqhgVe+fSRiY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WA7ZaIof;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764855115; a=rsa-sha256;
	cv=none;
	b=PKnCzBQKqIkDS2CNvO9s2hzxypLbM+pXXvqCxj/IFzt+oofsi1cVO8e1ZnwNykFc6Mfzj8
	uTIaNO4a4/PFBoUimlrFxtgQlhoqgf1/B2iO3RVhDy+jyPYvkKb6dkCkevQmG/1caZ+a4B
	TZKuSC5l2/InJgJT7foaqKba9gXz8bc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7749601EA;
	Thu,  4 Dec 2025 13:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBCBC116B1;
	Thu,  4 Dec 2025 13:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764855114;
	bh=vB0xFKHvvz9CMHiXhSjsKWzNa3U5EY8LSLMpWjHkcD4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WA7ZaIofBp98YOhcsvMjQjNfKxnNEycNG1QKaMUu7DS+0Q7+s6XKOmJpSjZq949w1
	 CwUew8dklDN+Z8awuif8pTdKVyVO+BexdxclflU0gO9q1IyjSGKobVsT6L6y3BjRDW
	 XgSvt5QxUF+9XINpCmdy7Kd34e+ZDiaAGkvnfQDLklgL+GG7SW84iOnWikJjtqyhUf
	 XUSVv3GTXEpxn3yMAiOT/2zQ/8sazlrEJc8C1Ka4p05vYGaPtTyO73yB6wQlliblYM
	 YnFhZknGzAKtmsi4PDMmRjrp6ly7YVhiHkTXGHe6y+G817oklmLTX0uVWE4Z7Rsbn8
	 DXNT+m3TB8vqw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Pratyush Yadav <pratyush@kernel.org>,  "Mike
 Rapoport (Microsoft)" <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Arnd Bergmann <arnd@arndb.de>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Kairui Song <kasong@tencent.com>,  David
 Hildenbrand <david@kernel.org>,  Christian Brauner <brauner@kernel.org>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  Kemeng Shi
 <shikemeng@huaweicloud.com>,  Guo Weikang <guoweikang.kernel@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
In-Reply-To: <20251204102905.1048000-1-arnd@kernel.org> (Arnd Bergmann's
	message of "Thu, 4 Dec 2025 11:28:59 +0100")
References: <20251204102905.1048000-1-arnd@kernel.org>
Date: Thu, 04 Dec 2025 14:31:47 +0100
Message-ID: <86qztal6f0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: hhkhqhy5naeffnr33z6neq5uhzarkfsp
X-Rspam-User: 
X-Rspamd-Queue-Id: B9FE01C0026
X-Rspamd-Server: rspam09
X-HE-Tag: 1764855115-507263
X-HE-Meta: U2FsdGVkX1+Swi6vXmwZOT/9AP44aN9DW8Z89FV2FvL4R1EUsPYvJ2U6XeEH3oF3QCmdrBGIS42Z7O/rsKHPhRt7hEZn+8dD4gXwgrUau2BChaO9MvZp+Ws9GFDaON4gUelJs6nIMDR46UofGzqr2yhMZpEbY1kaX9tURQPa/HXPo8ctAogaCDCkc83mwzBG3aaYFeB1c7zGwqt30SUaiI/TE7A17e8TVAP7vRm+smL0jQbV0owz2aWNFabLkJYE4j5aLr0VGjQlfPMrYW1GAJnzt4lASDhqQoVcpVs5LCjZQe9gxlhnqAp7T6ulty4b4glrK8D2x3Ywmbu3KFSSPcoBUa3kSNTAr9+hVCX4FJ1Ekl0tCB5yHLAufGd3evYwI2/2NrYEH577R2pJxNq1JAk2jMe3sK0zsA52qW8GmiZiy6u3hSyKKm6e3ac4FZSirydwYKCDnDOvWHJyrFwzky8UKsRdbuFobuTLxDCbWqzlZjjypXG+7212UVEzIfwCkWfW4cWj00CddyZ7skv4gG/ClGt1BiyvHnMP4/HRTcuJnEK23RqM48VXvqYN9ODitG4aw6lKwuN8aUu7f/HW2jxg8VQSXWaC9YFRNnaT/GCQ+mdc+1LsSf0ImZ7XC8UjLgg+UlJwg45/6T66O9NBZ8S6Y4Bdc71omZwAmWvSqIxWSLb222JGn8s0CQYbYnW/zDkTE/9x1+MILY70YSU+q9zdby+ouOUmDSbkefA1zChrBChQ92I13ZK59qgA0Br/XjQ7Sg47DXSJvWBi3YeID1RGgalh5wrTPE2F+ro7dgw8/2JRFUiiWlGRdDdZZW4LK9XDbcFhUBGW84lxRvhdnBKGdE/KwH9RJIY/Tim5OzMin+29sdl5pqZdC0M5/MGsJOQIoDFjay/Fsj92HCi+mqyth51Hhvb3EC427YyyetuwZj1mbv0dKFIer0rorqsRePXcPpzQLRvxY7aoCRs
 K0ts4One
 m9B4HYmd5qlU5M+ZxbHOTPuxxbl1FXmf2239acteWpgIdFR84s8brrCRcO2YZCdPPwLDlmt8uj/U2Knp4eJfPXWIbcFTay/PqZ59KGhU8HggC1p3PBucKVBQzEdhWS9msT6BGg1VPVuIECpaU3DyfiQ4f1BOXD7/l1deeQtjT1bPARLixo8hQnOxm+4ug9AEJQfeejp9xQmcqzlFHFbYGAZcQrz4+sTsL4Xkc/dePWUUhUVoUR+F15m/MD/UfNQHzDfhS7BQMcRd4XCeLRi3mFYX3eUAhJBsOO0ZgpoMAmWqUklMSO4LWJoxhNE9pbxRPoKMXPE4r8GwImkoO+yXX8RNjDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04 2025, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
>
> The newly added 'flags' variable is unused and causes a warning if
> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> into does nothing:
>
> mm/shmem.c: In function '__shmem_file_setup':
> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>  5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>       |                       ^~~~~
>
> Replace the two macros with equivalent inline functions tto get the
> argument checking.
>
> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

