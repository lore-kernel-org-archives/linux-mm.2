Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72814C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA94B6B0316; Wed, 12 Aug 2026 16:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D338E6B0317; Wed, 12 Aug 2026 16:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22246B0318; Wed, 12 Aug 2026 16:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E066B0316
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:51:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DEA11A04CC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:51:11 +0000 (UTC)
X-FDA: 85093812342.22.E31180D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 05967160005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:51:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="C/SPeLcb";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786567869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67F9PoDSJyF5NhuVxr1eoGrgb3Su1mBz2fUlFv/Yg6E=;
	b=A1JSJu0HUc0m6XPkdx4WlJFkq/tZ3KfuyXUUbM1Q7BJBq/erPERRUg/tSet5WGQltoT1b8
	32BxkpBmjZADMi87t3uu8h9CJdEBrNix8FCNUGUtnHoL3ICBnCaRGCS15Vgs0us+irRDJ1
	82zUG0wv+SrfvMSf/Wvr/voOC2k3cA0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786567869;
	b=35DCZWNzKnr4WqvKQPOfR97jlMU6bmhqSc7++9HKwNAAo7nF2/umkwTldIoM3eTyxnaHzo
	PpJXLC2myFbq8tj5t9h16smlzNcxIs58vLRV0yI11m+HRofQOSruNCNAlcnaCeZCOtHmYc
	ezD3phBgf/fklJMDoDtHTd6Ah9gnquo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="C/SPeLcb";
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 04CC8600AD;
	Wed, 12 Aug 2026 20:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4363C1F000E9;
	Wed, 12 Aug 2026 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786567867;
	bh=67F9PoDSJyF5NhuVxr1eoGrgb3Su1mBz2fUlFv/Yg6E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C/SPeLcbVdAGyhpeOF9YIAKyitqm+ISjHcu8A6lDmGY3kDhvRbUOvS7dMvAhy6ADC
	 w2TQ98DCE2fHLETpDp5JhhAanCXA0CKhT+S/YpH48L87+IunQkRj7N14RUHiGAenBz
	 c8EI2P06sPS+6XUmX+JLNJF+WAcg2Yc+fDwq/vDA=
Date: Wed, 12 Aug 2026 13:51:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, shuah@kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, peterx@redhat.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] selftests/mm: TAP output and global-state fixes
Message-Id: <20260812135106.7709da03e92e0e7f5d8d9a5e@linux-foundation.org>
In-Reply-To: <20260812120821.523860-1-husong@kylinos.cn>
References: <20260812120821.523860-1-husong@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 36e1sbuz85xq8m6uqcz1bk8wc673ep8b
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05967160005
X-HE-Tag: 1786567868-771228
X-HE-Meta: U2FsdGVkX1+NpKY+3y8JYvNxZb9n9FhNBd8Hkn4HM+n4F2+tdl646K7qzTz5zoFkEclLJOHjVxAL1dpxfoHY7byI5CcLhiKDjCOXJ52vcqrLyOxBqIXG6qgOwNkKJAdVmWQTfk/dzWLYAMw8wj6uh80U1cuthFzYFhK+lAbbdQEvmkIstnJQRN81g1ToZxbvD3/lxBVd5bFAr0f41iUwgLM/kn+JHLvCmw0eCs/ldmHFABM3LNx+gMEK/JYVdijAzP1ShcmM5c/trGQde+nzi3Vpjz72NKYZCN5TLrslONmhG9+cwjY9hTJoaNDJgQQshpxNKjO15WyOuS6D8L7T3otbBj7yO6HqsTaOb93iPfKNRprn7/Mzz9HPjEQgVbkdMNpST4ITmY1cDYSdlrXgNwRQCNt+G9Ps1svSq5VQE2gCNl5oiTqiDc4RCBrVgPYMFFpKr3QWa5K7tYZko/edFvzsfvOUn4w8y5cm4x7ctw4P9XWkcRIxMi6VlgdmEa6Y/ALJlqjkWfcf5aHC0rqjqngvK8oYQ8ettfDibvwUB3o3iG869vWwwXCnevKK+3gLkCjJUUvzUjvlYnWG2Z2b0MfNsG5z3RRAmLQgpt9MwlQOlTWoX+Enjv0sjD3GnB1ogcXGAkJYON2v4IhAYlf1zF8wDSnHERVG92AEX5QYTcqyAYrNE2ftaiLaJfw/lFgV5QPfpvhP+r6tcuOBsGjwMXmPijL2hiII+upzbF9x+wEQp9GKqLZhHNC141jr+XLLe4mORnvRyKM7Ipq3eRUjfTGdoCp7islzfutOyS2H/UwasuRJE0qxtmD8Ap2zZzOAdcwKHJTdSYDR8ePLVvpZ41V01UbH7BE9VWr0zyFkfwuP/ZgyuEeD3ws0mflZmU9+MmSmEPYElxBpUgnqhf8s4xvwXacHvMKaC6dZQJpUdolhU0z/ywu7FEW02jTTuyF+EKbP3swG748nTRtdHC0
 unF/ZTel
 ZrfEwKNYzos2YnLQeI4YIOuxjRBgRc+RyY9BJLct99SVvqNlZOTmivRrBxPhJIrIc/sG+8NjuPgg9NNG5oq8+xDghQ70LLsRA8sZ915RPM3HzyFXXTOab5Lh9mbLWnn+Gpr+pKfMOYKYXSljKptdxQKx+44xE3yG4yKHrJxCwmZPazDKYwx3vlO4gq9V2P3f6UU4GhljMkbqu6PoRViZfmI/8oox/n2U6qsHwyeK4B1M6xggBfBPWftKbGBtqAbC8s9yEKaV4U6w28oynm9KR7N1xqtkFzxKbQjVo/FHgIB7fqQgfW/B7ubfvBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 20:08:18 +0800 Song Hu <husong@kylinos.cn> wrote:

> uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
> skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their output
> is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline during
> the run and leaves it disabled afterwards.

Thanks.  AI review found a couple of minor error-path issues, both of
which look legitimate to me.
	https://sashiko.dev/#/patchset/20260812120821.523860-1-husong@kylinos.cn

