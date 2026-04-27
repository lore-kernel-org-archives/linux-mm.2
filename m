Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1FCFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9948C6B008A; Mon, 27 Apr 2026 12:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C8E6B008C; Mon, 27 Apr 2026 12:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A96B6B0092; Mon, 27 Apr 2026 12:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D66C6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:49:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6412A01C0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:49:35 +0000 (UTC)
X-FDA: 84704921910.26.D4FFA1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4DC5940015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:49:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BspDxyaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777308574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiCwUSYMF0z7tVaEiWeybZCdGkeS6zbQ5EAwotPV/V4=;
	b=FLe9m/ov9i9hIyZJDr0QQNE471qWpaH4/GQUtPRot7XDvJg4jj3oZlaqwkVfBTU7noz1qb
	xErDSP+YdYvgoIT3Q25qDfVTrJNV/XEigtsDqgSFgp1dr/GwJQFQIxyCd48DuTGmEMlMa7
	LqcmYZSwBNGtKqZrueRCfYjKSnv/z+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777308574; a=rsa-sha256;
	cv=none;
	b=NNlqlXYczATawV8E21joOsvxSPDLZHcgALMOG/20Ffp1XB1EXLi4siw7EXJw0CdeyDJ5cw
	yXvEbKbOXnHFomnNFrZT1AhAmneG3M/ItRoIz6cWOEAwsTK1s5q2ALpk8zaihRInxMQHZy
	sRyTA9rkprT8PiA+xZxmyfW9auD85bQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BspDxyaK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AA7C60126;
	Mon, 27 Apr 2026 16:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21632C19425;
	Mon, 27 Apr 2026 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777308573;
	bh=KmYd32L9lRML6KYGHyxIlyge+HcaDt0cRuYzVqygieg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BspDxyaKeYJTsKRjrSO6QFjRG9fuNUKxklQ0QOSV7YkBYz2Ve9kUCFrvBdULpvDfB
	 Awu0dpoWTu7m3ONEsjXiD3xUDkZbj8qwKesrsgNqn88UxU7GChz+dyctQGq7wyFdxD
	 W8hAuQCBpgVKJx3/PH0YbYUfIRaD3AnhsM2myCyHTiixug1/xRkHgdcwVuhy9+faaN
	 jwq85jBcl9C51LjFpK52qhif7IZS4oLcGeNdgW11YvNoFGQfMgK56QUnbh0IhPNX69
	 vVQQfEMP72RZmyiZjHQeifzUxnS8ygO7g50nrL+Hq8tbAxEmaXN/CCnJm/vBwDnBnh
	 iEzPUSeSx6NSw==
Date: Mon, 27 Apr 2026 18:49:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Luiz Capitulino <luizcap@redhat.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix destructive tests
 invocation
Message-ID: <ae-TlsIq_YkQcCUY@kernel.org>
References: <214fd9e4-5398-4c26-859e-c982c2e277c3@redhat.com>
 <20260427091250.61316471db20dfb0852141c1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427091250.61316471db20dfb0852141c1@linux-foundation.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4DC5940015
X-Stat-Signature: j1fp4jni3pyw7eoyburkcewykzho9k9k
X-Rspam-User: 
X-HE-Tag: 1777308574-239564
X-HE-Meta: U2FsdGVkX19OXLXHFwY8xaFMGlgru/seD9lJPWn8+uonCPjqzOQiWa/RW0txmH09Q9vWE2HCG8L3QjnDnzpr8rRt1vUTOJEMvAdu0qGF+spRiKh1026nqF1viznqIr8UcVJZpyIZI9AuYNIz+OHC0C4Xd3OL2ZClqnxGKDsIL+jqjG7Q22Q3ikxEyodsZRi9LHU4Of5RsJfXqXAQZQXYRN4pWye43KwYPnIJyvEd0FdCtMjkqTIeYzVONqVNFMHj/sCoWciKFZ0kMw36HEtakcTndRbGJbIZp2N5Zmik1vRoW939W6UUnur+cM0MwNntCdr9M7LjEiDLxg6PwmUZ1aCwTnAryw0cSl9bXDx3acrTENV9HwqM+nbNjeZaxj+o7NcRGmPoSka9IKf9e9PuJj2rwH3esoEX1AkmT0aYW6eoCpKb8eIj8LJp8+Xlf2WPCbbc/hXVq29VQCMznR+Sum1Dh02y6hBYRbA6sbawp6CZWHB9iYKaheCcLXHkPlAr8QcfQ1flUSYRZaBBubnlbZM8vJG81cFlobW418LGqKU0F6Cr8L9u686ASm7gotfvxMClQz3LsreVxhY6iyaT8cH8eB/SGSQYTVQPS9L7rHMM/pnCyUc/3p0GpzU4u750zapJCSA1EMo/UbCm+YbN2aBP0/cDrN2kFZHOpfbumb95j227yEDq1mgJUVKE6AtEcsb2JXY3xGC/pSVSApDjucbXyjTk3ejYSYHtGEeVvwUj7pLBENr7ixYj+/MiE8atHtNi04z2EFKdJ32T1CVt3NJ7joBi02/vvnlj3/KNWI7MQCCjZLdYZeNV0mlt5522gJn9yGjnnjUjUhUoJVCB8eL/ZgjsEsH/DUL35DMGk5bA17wAGjYa4r3Etsf7AYjXhBYjpoZTNTgiGOnusQroYzjylnx+hCybNQ1ereTNX+rmEPrc64DTwCU9Iv8KlZMbkuoLn4XXv19FZWrhkYV
 FQ3AIicS
 cK+5is39KSvm/c1oOS/e3CrcbIwpl78LdfXq6U0bZkwM7GJ5D5nVEb3+RAU6RSYFB23mHfVABnz038BeOEHUEYU1Td3YfVm7mi1YgI7zmr7sBNdtgiOLuivxs0Lctvu3GDzdPxPDBYXHJReb/OCSbondxMij9KiqGoBy8WkbStFsAIeJ4Ud+Vd3MSvl7DUjKSV9VZS8ut3tU2icuzDfY2zRtTu7ho+nJGtOwFCiG/F87lNXhlc1a/01mtyOQxfr62tWm+N5YbkdYVMYhPd3jtzmC2URx9tQzOPklVupjDNvZRtWljKq8ufmH56bUSmEPUzbEvzoMS7OiDxBXxiu3RCXINbBxnwrnSJxxz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 09:12:50AM -0700, Andrew Morton wrote:
> On Mon, 27 Apr 2026 12:03:51 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> 
> > Destructive tests should be invocated with -d command-line option, but
> > this won't work today since 'd' is missing in getopts command-line. This
> > commit fixes it.
> > 
> > Signed-off-by: Luiz Capitulino <luizcap@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> > ---
> > Mike,
> > 
> > Maybe it's a good idea to add this patch to your series since the
> > hugetlb-read-hwpoison selftest won't work without your fix.
> 
> Or I can scoot it into mainline as a hotfix and Mike will pick it up
> via Linus, soon?

I'm fine with this.
 
> It'd be good to have a Fixes:.  It looks like a3c5cc5129ef5 or
> 2bc4813622459?

It's rather f16ff3b692ad ;-)
It added RUN_DESTRUCTIVE and a case for 'd' option, but missed it in
getops.

> >   tools/testing/selftests/mm/run_vmtests.sh | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> > index d8468451b3a3..c17b133a81d2 100755
> > --- a/tools/testing/selftests/mm/run_vmtests.sh
> > +++ b/tools/testing/selftests/mm/run_vmtests.sh
> > @@ -103,7 +103,7 @@ RUN_ALL=false
> >   RUN_DESTRUCTIVE=false
> >   TAP_PREFIX="# "
> >   
> > -while getopts "aht:n" OPT; do
> > +while getopts "aht:nd" OPT; do
> >   	case ${OPT} in
> >   		"a") RUN_ALL=true ;;
> >   		"h") usage ;;
> > -- 
> > 2.53.0

-- 
Sincerely yours,
Mike.

