Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8382C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:57:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05946B0095; Thu, 17 Sep 2026 17:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBCA6B0096; Thu, 17 Sep 2026 17:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3756B0098; Thu, 17 Sep 2026 17:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70DC56B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:57:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0912D4050A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:57:51 +0000 (UTC)
X-FDA: 85224617142.11.0B78531
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A08540004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:57:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SlSV3GrU;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789682269;
	b=xoXm1/u6XuBjWprmVQQzdXPkWg1s2tDf+OLdatAtfMD1ZgNISzBm9XvybQRRPxcLb9A0CV
	nbEMfPzHYNzQoybNaZM3fvhK9H3jZkB7pvco5G4GBCaIJDe51YxrlVcwXBGs3F5zViOPAf
	Z6ZQ3+i+Hy6741/EDwRpIICEudZSA4g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SlSV3GrU;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789682269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGh/RcyyMvxZRhh0cS/raCPqx192hVwJtSPLUi51+yo=;
	b=Cjl6RYCGcIhN1HIwZTkLVV6GXQbg+sRb05joKiiWL7lNDaaSCnXA51hIKuGZj1vF8vwJnG
	kKJe7o8mmMQwSKx6Oz17Gq80/kHWrKVV7nsr7uj6WVp344RWnd2zYSL7O1vi3HUSDbYU/A
	iFHyHUBD/Dzq8uADTomCqx9RX9eP+Ac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF956600AA;
	Thu, 17 Sep 2026 21:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A811F000FF;
	Thu, 17 Sep 2026 21:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789682268;
	bh=qGh/RcyyMvxZRhh0cS/raCPqx192hVwJtSPLUi51+yo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SlSV3GrUa7u740KQ4CZlB60JnMtupY8Ev4iwtRzGS52me7gHQv7TgCjcHrghNsYjK
	 EL3mwxqFkiXwPjYJs16VBTBuPxA3tfqe/kgirceityizCFXUp0PV27U84rh34GgJHA
	 jlqzkTV3WU9ulgb48/LCg3RjasB0BrcLCyX4m8pg=
Date: Thu, 17 Sep 2026 14:57:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Brendan Higgins
 <brendan.higgins@linux.dev>, David Gow <davidgow@davidgow.net>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, Shuah Khan
 <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, kunit-dev@googlegroups.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/10] mm/damon: improve readability, clarity and test
 coverage
Message-Id: <20260917145747.03fa94dcc327d43e84bef650@linux-foundation.org>
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A08540004
X-Stat-Signature: tztz7n19yz1nezw8c11oaa81spwsjnfp
X-HE-Tag: 1789682269-917362
X-HE-Meta: U2FsdGVkX1/MegQ5K1s8oiNfLgQw7LfWWeMFoF8/XlVJya3fry8neBHvS3XnBxhmuOsQfz1+ashllPyH1YW6ioG6+yDXlQEDnUSLBPXD8daPm95KXMw7NAll5iVBowZzSvlM8OGa9t9bAu0yg0EPmJm3tRAm3vv8QOaJcxflxJw7KDzuFKKy5jTnlZRy/tBXrXQw6MwwF36oHgQSalb7Bgoh8mySH1oZoS05dOmT6u2uizbgk1CP/mLRxk1PWGJpULC8wFVgWQoDRmBfiwMTe0WjmZPk0lOz5RGlqSWzWUDPA1R0kHC2/bM5maDaRwppay9AXXoScPMBAMo1bqVCus0JRMn6PMoONAuaA3yBdUi9HhkXlFAa5YYtqc8hq87XbVLvIUJMtvaNCKVlDWTC/GNID8zVxVWQG97sfdkoWnJyJpORSdSbEz+h569hNBGdDCR3ZHp4lazBUtkCnikcPbNivwpRPFgus4tDdqgLZSAb/1boOcSGFVb6XlYZMjtR42BWCFfrB13rVmWmTZ8SUCyUv+9XeFapUheBaeaf/1UIy3dfITum9uMqeG7eZ/QOB7WhEYqpuIgDpt+gBZY1M5+3rn6Mx9h2AxLvtv0MCpqmXwZxqkpHF+6o/Yfc4M0dKyEkcj9ybs3Xv2cLkfimSh4G/Ydm3q9EqfrwemcR3dVlcRBGzk0isjKF9IBE24HMHsQpJcXNj2FVkB/C78ZY4EZBHV2LNrS9CCmv9MbRNd+Saj/l2iY/59NK2T9LuBZKWf1DwC9892YMNVUas2BocScWvCjOkLpqjfxiFggSQMXI3I1F8NRbDiKGD0IDXUf90hJKK9rQcWJpjQrjLQ7Hh7uaxuYONaL5CWeu93qBVBDwjrFkg0MKPU3RotfSuIratjxoKxz4JXzu2eIzbpOYOzM0CllPrtKA+CxtXymUfdjmA/b6Ewad/V3+Ft+5y048QkGpDYBLsfYGz6Ze81D
 yjOy8BnB
 2TINza/A4O3UV7rWCQaT6v10vEQ3MoPYuVSWa9bp6nYi9SuKKtrcBKIqmFR7waW2Wo3JbtdAOAtvonLhe6DYPVvuUKqY/SsyZrz1YZnDjwOuhSed+tVXykhPmR3Z+mIEE+ExklsMkW9ZgTzYzGZVHza+EKfOfKq+hYGRNsQdtfciAUtv4kMW7jGsO1GOPVnaea4aBrxLHhhmy1JVGvg92IShv4Nw9lhv53lnoiag8LzDHa8wUmMgkybPWIuZX5xI2ZQvoZ6zp5H12d/zv+SFw3dyEvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 07:21:58 -0700 SJ Park <sj@kernel.org> wrote:

> Yet another batch of miscellaneous DAMON minor improvements.  Mostly
> focused on readability and clarity of code and document, and unit/self
> test coverage.  No user-visible behavioral change is intended.

Thanks, all queued up in mm-new.

