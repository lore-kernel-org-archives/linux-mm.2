Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36631CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 23:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559E96B0088; Mon,  1 Jun 2026 19:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531E46B0129; Mon,  1 Jun 2026 19:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F126B016E; Mon,  1 Jun 2026 19:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 374EC6B0088
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:17:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB17E407BF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:16:59 +0000 (UTC)
X-FDA: 84832906158.28.A39548A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 37478C000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:16:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uLIdPDK+;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780355818;
	b=f5BEE71tcJRQRZ24T+ws0225K8hyEnN/qSGUfe9FdtTH4Nxx4LWuE3VetmtwOGwPnneMOY
	RVMqdtDZLO+55H+UJbLdtUOACVQdava2ELBhAvxtRczWQqlJapEIT7fCqn/WXtP4OJ0i9P
	CjmYearmuBCnu1aBqUm+bJH345q2zKA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uLIdPDK+;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780355818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cEAcStiqlum1XAuuC9p8c4isySH/g/mtr+gGQXo9Jg=;
	b=ej9VOQWvh85+lWQdkhKvlHGXacx92/mzP2/OStYgsfu/MCyx+0WDVKYQCjHm23qpubcEg4
	9WJXl0SeQ6p2aqcUim0J9SD03XrgFkYeILV/4+mIxf25dMrJESZsaYa0nBJ+ZSgRYJ9a4N
	bNcYfswJSYYSbjKUMk658Lz8iy8gppA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A90BF6001A;
	Mon,  1 Jun 2026 23:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DDB1F00893;
	Mon,  1 Jun 2026 23:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780355817;
	bh=4cEAcStiqlum1XAuuC9p8c4isySH/g/mtr+gGQXo9Jg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uLIdPDK+VSy74BjLMhQwhGVHJZEqEdvehJq4lCeqxoY3WkVPbsKy+cIwb1hHRuUhI
	 AOiSgk07vxOWw/kzr3gVhVB/7zc+cLgupCmRL3PF82kG5cFjq2DBLHw+Xul+WM+o1K
	 B+e+mE7RtRTUdVW1yJKxa4iewFWKIlCB1kLlf3ww=
Date: Mon, 1 Jun 2026 16:16:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] selftests/mm: refactor pkey helpers and fix mmap
 error handling
Message-Id: <20260601161656.203154d9f53c2861f1bb2623@linux-foundation.org>
In-Reply-To: <20260601061953.696844-1-lihongfu@kylinos.cn>
References: <20260601061953.696844-1-lihongfu@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37478C000F
X-Rspam-User: 
X-Stat-Signature: exh3rx1wi7cbwnhfj8xpg8o6r68xy13t
X-HE-Tag: 1780355818-422121
X-HE-Meta: U2FsdGVkX1/y+MeWL7ioyJe7p3g7C7D/HWWW/F65p5sNBp81RcMBDLUhlhE/OQMd0H01mdAlWrqiCljp+KoaT6J0MyF5K6n4vdoiJNnHmt/QgdSJ/mivCGrNj3iH0vBxIXz6RXoCnWxkpYs+zX8vJwF+xWKn41lOlG/eYmrjQ93LB9KN+fCM3Mcz16d+UOTij7hcxsPtD/QOLt3axCeQJ9M3O3fwmMfQPsQR7swd2q0ubhasoqvxx6Bkql7w+aNLwDD+a57uUKLQvXHjMDmR0mokXC83bsdnj8WTKt/9qubZ2MQ5yVNltcDAWaukLicWDuR6Zp2K9wzaSJxS2bqxmWZvSaqRYXspZhofZqFYkFaNUlUE4mWRtgXUSdeGH5xsa3038nCZLKB0C+OMY/2TyJwHUxrL253Za8w7/0k42zxQACp1Wg0E8SSOdP4SePaoi1qDo3sVq9tVFpSA7Xgh75p2HgEG+Nbe0i9WHNBF5oUmzIqhn/8SlbzYqeisUo/Or51j3hObDZ5BlFqkEuxhy0RB19TWxKp88lsh+lcwJcWfdo4c7LGbbocb9YUJZAldMX9Oso1YudSpYwxu7qK3kshBxnEKXcdqfoxREJ3ngOTt2D81OFzXupXr3O7FVfRiajlo2xy06WcVriJbHronFtOf8B1+HWGe/5WYCLPP4PlUacul5jDU5YxEalEAbgZCVnPQkq7euuOtc8NgHGkeu9Xc2eL3wnoKNbECH28W8n1lsZaQNIjNQrE/JNNHk0BoB+qYZpixx1CJPnfiozl7su0qecjX0EZqm7vfbeszy4rRJ7QPu5zhNz+NLqwxVsvfYqCXrieLwFzykE2o+qmxZJGstrNqumgw8fSovwFwQOA/iaSFcG3he60e23TSM5bUC5FNHYGzziHG9fNlTq+/qXKVrPtOBBDouiDvPdbRrQsBst5kMilf7wHZoeKEHsqBBmex08FygXOXZKBNu8S
 H7nfkiN5
 HGx/V7rRz5oeyeUjE1Fv6R/n549eiRB15CEvKHL9mmm8a/GsrPfoC9BZAvYQUT32oO2qfQOvxd3Hx262l6+VMpH7CMNut/t2563mL/3QhTmopRl24e7yX2QUPA9krnPCuAyL6ZhyaG3wj/aFzu1CB4RY32kbXf0yJLNnsJFPHpCZeUyUTcwMWHrbxy3CK+F0nPro+CUSJn4dmlINkJCX+13ueE/cysJL0bg+A9+WgsVCOt9GGV9eX6INeUiUlP/ADKf8i2jAVOhYrDqrwOs1bVY3yWRzsOoEfQJDWc3/Ek0291st3/7iQ8msUeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 14:19:49 +0800 Hongfu Li <lihongfu@kylinos.cn> wrote:

> The main changes in this series are to refactor shared tracing and assertion
> helpers into a common file, unify both pkey selftests on pkey_assert() and 
> per-test tracing for consistent diagnostics, and add missing mmap() return 
> checks with MAP_FAILED used throughout for readability and consistency.

Thanks.  AI review found a couple of legitimate-looking issues.  At
least one of these was also reported against the v2(?) series and you
said you'd take a look.  Were these things false positives?

	https://sashiko.dev/#/patchset/20260601061953.696844-1-lihongfu@kylinos.cn

