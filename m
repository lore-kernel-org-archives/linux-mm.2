Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D13FED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D356B00A7; Fri, 24 Apr 2026 08:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6AE6B00A9; Fri, 24 Apr 2026 08:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433B96B00AC; Fri, 24 Apr 2026 08:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 325E16B00A7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:48:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA0E686D11
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:43 +0000 (UTC)
X-FDA: 84693428526.21.8951CEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 201A640008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:48:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cFpBcO2v;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOjEYFXYDPsGlFdqnHYfscQIjAdJyCeWFAVNVgaNLuI=;
	b=KkRVhlWWpMFhAnzDH9oW85zoOeBrZJq1t+Au27VXbExs+VJ7aaqWzZsPdBQQrqRRqX6lgI
	sjH0nJprRy7MOpW02HVCZtlb+RiNdd/xV6Ce/rJQ8jKbf9Fi0ErYPaJB+ku4Oj5/Gp/xfe
	+Reeik821gLGJG8rtiEXo7hjaq2E0Rk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cFpBcO2v;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034922; a=rsa-sha256;
	cv=none;
	b=cimeVcoOek5QBGWoN0pKK1XnMeSMo7djImIecTeHs5xQNsdOhEmD6AxuQuallidrnmKIvu
	OVBXKBHpmXCmt1TjetCpxAoUaR05BH0PL25BVWG9JlL02rhYzpaBBUZ7rDns2OpjVs1iao
	6dWWAyrWbC5ssscUDbiYk0PFOb8TTzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BDC8600AE;
	Fri, 24 Apr 2026 12:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1A8C19425;
	Fri, 24 Apr 2026 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777034921;
	bh=TROVbJzrIa38ArftKGm7M6iYtIDBZWbB0um0eGyg+zU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cFpBcO2vALXr7md4hid3exLyeME0fHrvBJjlifO6sM51NXzOxK4YlOkMEBQOymJ8l
	 Bfh2flYFFsoEBJftcGNE15m+vewO3VtLyRNpV459DjEydpAmB/VxIg+aeq+MeFV2Y4
	 6+5v1ltjzw1cQVsfP1HG1TkTQol6eMmalQBLhR50=
Date: Fri, 24 Apr 2026 05:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
Message-Id: <20260424054840.a63d80ed01b968caf9d9ef64@linux-foundation.org>
In-Reply-To: <20260424-ecc_panic-v5-3-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
	<20260424-ecc_panic-v5-3-a35f4b50425c@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 201A640008
X-Stat-Signature: xoh8wm5d6biib8hp1grpxwy38ootjf4k
X-Rspam-User: 
X-HE-Tag: 1777034921-543789
X-HE-Meta: U2FsdGVkX1+3ZAzL4GoclZ1rvbd08x8GCeQRThlGTEDCcYBY8/Hg2ZHOdmQ/9bgnx1J7DjZdtwTS8GxBHxUFIym70PqZWrhswFEPXI2uWflDVBdTVSDEwlXDlabeamb+sMsjHsbgL62CD553iyK/2k0ROSKV2iInO0r3oLIUOtrUS7YrzSJtkJF6+N9oKTp25DYnfX65BhPM5YHVlDsFJyUFMNRl9+uU/H//N71v+aD0jaWCxJxb2V6RTlpgYbTlhLmGvZBH9KJ6D6Jgz6y2jjN5uJTfXRH21SaHhoTgO0cBsqELDXXR7iWrBGplFz069KmIyl+uP9VoDDcwn5E9e80WDnoX8+nX341cjN67IBe0+PHJM2HCuWqRySpKXyqxDPyZtfpWeRxhvXC7sCq9TqQ6vwmEPrWHpq9US/fEumTugM8tyLtD6aF6q/8JEKZMLwrtI06oe9J/cUql0Uo2Ql4kG88JjGYTcCjRTzSa+9t916MRuqS1lDJmNjJVKuI07X7rW8209xQo6uxFNibpqH4mq1iN6YdRlOXrsN4okhvlaWoxEvToc/CbGm4g/V0xpQTe9gct+/svR/ZOg3qpdc+uhsUd5zKvsAKeh0KTedPV6WQIhM4ltU++VBpnM+1pSVFXVehXW77mOXMVCQYjXB4sVPHgBl2giDWB+oXsL4gUro6wPwH3pOASiltgg6YJonQwaLhGgxuA6JudnocR67htgT/xqp8tci6SzKh7Oi65XrtqB3mBqsPuGEKJX6AcxW6foCc64+VwL3bAUbylZIDNRkgFI0Fr7cUOfUSqlwPjuPjrwi1sg7VhCNuhJaC+IUjJmHNd0LBWbFABFZEnYrP+Kijxqa5fs5X17urDRCFCAqz6wABYiX99YYREKPlRieeGW9a5pGWq4JFYbeOT+hB8eqLg73Ix/fc2mIlOUp7RLU6sF1aPWWjY1q1/j8RhyVOMu8+Fc5SstDpy7pZ
 OJ9WtNMM
 BvK/QZS2M0Yk/qz0DSVaY6aCZ2xPkpE/YsgyAgXyb95CB7wvQO6Wc6vpZOxF43Xbwvz6rESV9BF6bgxbkywCvxLdWbDv7dsDfURxvI19iTWT2cV7fdA6UzxsTKLZweGRqh7X80GPnZoktUwn9xK+elmgOBFi3fasuQXMS3doNzW0VkqX696BxJubjPLkDKYnTpHv8K0aT5x76niXngQ4qkyqf4Ohz8MHiRUXo85JJKm/2tgypONBVE+YhxbN/uKBp8MBN/3Z0yQG6xYFltPRfAg4tFZoQRF37F9r9vwUMROXMJwBwrB0D96UJEZzQqy9qIA+A0BQ/ntpKvhrW5QnQ2Y5CphQY7wRHh5gh8kV/E/lqUcGQ25kBnuvGCLm/apPigTmhhVy2LNGhUSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 05:24:01 -0700 Breno Leitao <leitao@debian.org> wrote:

> Add documentation for the new vm.panic_on_unrecoverable_memory_failure
> sysctl, describing the three categories of failures that trigger a
> panic and noting which kernel page types are not yet covered.
> 
>
> ...
>
> +When enabled, this sysctl triggers a panic on three categories of
> +unrecoverable failures: reserved kernel pages, non-buddy kernel pages
> +with zero refcount (e.g. tail pages of high-order allocations), and
> +pages whose state cannot be classified as recoverable.

Before someone asks, I wonder if we should make this a bitfield thing,
so people can select which of the above three should get the panic
treatment.

