Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633EBD29C2A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3E76B01A5; Mon, 19 Jan 2026 09:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546E86B01A6; Mon, 19 Jan 2026 09:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4532C6B01A7; Mon, 19 Jan 2026 09:15:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 346606B01A5
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:15:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7D7055DAD
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:15:36 +0000 (UTC)
X-FDA: 84348911472.28.DEC87E3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7291716000B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:15:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ppE7BImW;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xgRfJpL28zXK/+9Mu0NkoRr9adKwzNEuyYL6hfZRhI=;
	b=041ezUKJFwdKW6hwi9l+JV1L0b4E0JPNzEZ/utJLNUqNHABbiniBaT6AhdZFMkRJUKdrUo
	IGzMkWQ/QRMQBLwFnqqkF2dyLiAlYBN2b8s63ZosxF9HFFfuyu1t3Ppw4x2mVwZc6Jlo5T
	B7GVlYTp0AgvgQShdaN66YGs0c/wsKU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ppE7BImW;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832135; a=rsa-sha256;
	cv=none;
	b=RtKIbz/LvDsxLBKITSpB9DQSm4pd+wGFaz7v1dJY9DodJ8Tx9NjUDBIz0cCHsNZ2VZsUWc
	AoCSQTIHQga+5xadY+lhjGaZuhhvwDTUxEoeMpiz4OLvw+gJ3ejQMhqD11MXhs9RdFmoyO
	wa15jLM7A6gkq8nzq+988YbzQ1t6Wk8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9xgRfJpL28zXK/+9Mu0NkoRr9adKwzNEuyYL6hfZRhI=; b=ppE7BImW71CsJWjLVHwbleqLui
	SBUUNKziZnjCMKOroDlbZbRX7b2F15jXDrTclVlwPrKAny6Zfmno1y49CaWUDxPVOGsp1lWDIX3wA
	aLo5w5TkUAwOy+HYkY/MxnQ5nc1VO9KSHUMzYnDOY/yqhdBOuONkQSFy+HgB3etzRt4PHkFSC5+ID
	BJ9JyJ1DryXxZ3sxu1k85zRjFaShVdoAzKIShmvv0o9T/KA71mSV+W7fZPqpDFWLtxKFqxNr7cZpZ
	Eqjxg86c+e3BYlNc4xxVzr2UN7ce9TRkz+qiQ+D91UJ7mHz5ZdCmi8YVPLPIRizKtfynykkcHucy6
	3jw0GATw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhq2Q-0000000DOsr-1sAM;
	Mon, 19 Jan 2026 14:15:26 +0000
Date: Mon, 19 Jan 2026 14:15:26 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Zhiguo Zhou <zhiguo.zhou@intel.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
	gang.deng@intel.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
	osalvador@suse.de, rppt@kernel.org, surenb@google.com,
	tianyou.li@intel.com, tim.c.chen@linux.intel.com, vbabka@suse.cz
Subject: Re: [PATCH v2 0/2] mm/readahead: batch folio insertion to improve
 performance
Message-ID: <aW48fk0IVus32QtW@casper.infradead.org>
References: <20260119065027.918085-1-zhiguo.zhou@intel.com>
 <20260119100301.922922-1-zhiguo.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119100301.922922-1-zhiguo.zhou@intel.com>
X-Rspamd-Queue-Id: 7291716000B
X-Stat-Signature: xcjxnneb9n583wsi3k9swkssnhfnm55k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768832134-694393
X-HE-Meta: U2FsdGVkX19vrf/9yPtR9ZUSWRpey0/XccIqF8WHvpk8UxV1434Piv8wSoUgKnp72d/Ui3Mcr4yWnj6Pf3neOqAxQoQ6VLhAXjknsSd6kG4fKV+k7srkMY8ybYYIAI4AzD1ceFw3IJ6c+9Mv/zxmrnxOwssdEgg3tHPnmekW5Q4cPBj1AwWCxOBLbITntIQf0KtArBX8D3SAkrNbbYCdVfBPqDS+LBQLK97BZyFerNxCH2puuhwamYwzo3ck4yqdF+tqmOuGWSP5IedZO55OfhgsOjKMtSIFzRo/05GqLB2SEt4XQnrfb9tEJXex8fGTJ56lbuHcQP3wOHF3ESNMYojIkTq1z9BXJ4HwI3vXd5vcEWm+ilgb+79yrPyxQLySoZrtIsd1zMTRSCZGiR9eroN09eIp65kONOJBo63BWkFEyeEtnkanLyfDBVAMGuT38nxw1gM5WX8Ctp8qzhgUsPH57D/Y8qfmkoWDBV7f03vNMsBMM4aJHaS9Bf/goJQgyhd3YFbPbsmP0MDw+x25lbFEV1wTM8UfkEZNcrn72fvn6dAJn84gZxjYK25GWEgpTcpOmzCEfdqKMHWZLUl7BDXSlHCzilOkLa2HiPfgoqhIaVimS19ZRbcd6rS+K8kkQbV+g0Vlyr1S/yXltc0x81Pcq3rxOjpfNtj6p1p/T2JlEsVIDsoXqVPRCHBaJ3EENR9nRpRqhubP8wnEkcZs4KlyIY1m7dyPTwa9SUKHtWCaoJkHDHR351CMRRCz8JAFyXuK+T50ioSHkxm31EXNsZUORvdN0jyLVnyg4CwYSHwD/mzIaq/BRZc7uZTCxscI6MwjqZbM2AWlU9eheN7x8M411Uh+H5zga0AYGndybFApzPSCyaABTyBff1oU7muPjBaFT2q2wpJ3bqMyIPSruR6qJXayjchBLlqe3I0/ej9Js4Y12bjsz++mqHJvRrIGx9wUU574ED316iPWYpj
 /Y70HV2d
 PU99fesn0zIkWSdDUMr6Me6fvdnlPL6coOxraEnFhblTP8Uyimv4pgLe1LK7SauAoR5RIedR2f/J8nwJV1Tg225rgkhjM6fO6uUtBGdJoBucdin5UuaftLiUFMpqNHZEZMF2zFLF4Xw7cApEosi5Tehl13238My8mO6f1UhUCSlir6ia1zP6GzyZN5AGXUPEd9w9kb7JA8hHbWLNfnrGwLjYuYFfiYRn+gdKJ9dujv0gV3t2VUms2sNzigP7T5bYtM9o8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 06:02:57PM +0800, Zhiguo Zhou wrote:
> This patch series improves readahead performance by batching folio
> insertions into the page cache's xarray, reducing the cacheline transfers,
> and optimizing the execution efficiency in the critical section.

1. Don't resend patches immediately.  Wait for feedback.

2. Don't send v2 as a reply to v1.  New thread.

3. This is unutterably ugly.

4. Passing boolean parameters to functions is an antipattern.  You
never know at the caller site what 'true' or 'false' means.

5. Passing 'is_locked' is specifically an antipattern of its own.

6. You've EXPORTed a symbol that has no in-tree modular user.

7. Do you want to keep trying to do this or do you want me to do it
properly?  I don't have much patience for doing development by patch
feedback, not for something as sensitive as the page cache.

