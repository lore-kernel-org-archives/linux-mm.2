Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1C3CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 09:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032E96B008A; Tue, 26 May 2026 05:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A2E6B008C; Tue, 26 May 2026 05:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A8D6B0093; Tue, 26 May 2026 05:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E556B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 05:01:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E0421A02EF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:01:15 +0000 (UTC)
X-FDA: 84808976910.08.647A797
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 10F3C80018
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:01:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGdUa1Jr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779786074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gIEisP8kdco3Djn1c38mmHcBtVair+BJG8S6dLuz6s=;
	b=NWvxzGJaVbNrwdUjHJGLIDOSx0xNVRsqCA66vRm93cnOaqCEdbxrazCL7yinLMe6GV6laJ
	O/ET07JSidnHDeZkBnAoOohYM873sIc5Wm3WvPQQbmfVaWMgyFeuOHuRwyl+5yOOze6u2A
	r3m2SJ2+eNdt9aB+YJazn6c/bo5c/50=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CGdUa1Jr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779786074; a=rsa-sha256;
	cv=none;
	b=ICt6f8Xrlc44+Utngsmvn3nMVywLEtR4fIlj3n9HuZ4XMDSxvnz9xP/16KbyA8IznQpyoP
	NURSBX0VFH2m30WKBVPNIG9PeuVzXQ8JMueTwUkuo1nylw9OyjZe04qhF3vCkWObjnmJT7
	pS3jTYfLqm2pF7gEfNMdo6GYhv+7fGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E068600B0;
	Tue, 26 May 2026 09:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAB11F00A3A;
	Tue, 26 May 2026 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779786073;
	bh=6gIEisP8kdco3Djn1c38mmHcBtVair+BJG8S6dLuz6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CGdUa1JrH5XUiDOyuLGW0WeCBhQqzqe97tZlT1D2tfa/kUOKy5OM9s3fkBWV/7ZCQ
	 Lc+as+qLHuelmMUDDc2i4t5Kdd4LlaNbsfW4qG2+xFBUGoOB80lpJW7S5QceEVEBpm
	 M16YcXY9Bv8U6IuygGXw+XFe/jBFhV5DG7ddgcQoOy6a34hLVc6FYnstYRGhIqW5k9
	 HFLiJ6GIIjkMod3+/JuGBWS75LA+D1eMFeCtjTtEvGg/43idzw+RyZrlC0omZC9S94
	 hp8D5yTjSn6nJrYvT6KbCVoob4zQA5ylKDha51OMGRplD5YbeH0hXInGArWDw4IiBz
	 0TWg/r/RizI0A==
Date: Tue, 26 May 2026 12:01:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 1/4] tools/lib/mm: add shared file helpers
Message-ID: <ahVhTWl0fTF3ASsC@kernel.org>
References: <20260521111801.173019-1-sarthak.sharma@arm.com>
 <20260521111801.173019-2-sarthak.sharma@arm.com>
 <177964236205.4000040.3083558454897469696.b4-review@b4>
 <ff7d212c-d3e0-4476-8903-ffe88fb7048c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff7d212c-d3e0-4476-8903-ffe88fb7048c@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10F3C80018
X-Stat-Signature: xbwc1gjua9sgni1gzjp7nui8z477rier
X-Rspam-User: 
X-HE-Tag: 1779786073-792487
X-HE-Meta: U2FsdGVkX189ygVIYvQe6goei71Sy2SKziGrPGGjNf5TNEE9KkLweNqnkic9TkT3ydYOB4eNhn9tyvYJSQtJPgvd0M2umAjgBwSn94RNW+NGoreFsES0ILB2RrV7vV1vqhdeoBbT3qhERjnuYFgPCtkqJJiMvLk8GS2N0YqZOCwOvY01lfZO7bAX8QZUp2oBD+D8o9tucidIfmE7sMnD//04aGDYN4AjjiR07AHDNrX9q9jNNEBGI4+rGNHjuhQfss733jomhroEgJwrYM7T68HWpJ+2wM2MTtFHZXJfRrgxzt2UDM2gTyu9PR7BxoO1HARTyFReR0mMnFe5XktSRY2LsDx3SE8hwWn5/BgqkaDCZ+HfGyBp9qXK1EQ7JhcXPs30X6Wb+dZSReIEG8f7DnJeSe7YVmVNPqiufJIDSxF8XDRjvh661h4RRDVFtz59vM0A8/48S5sJBVms8+2BlciD2hJOARF5ZNBpny21RsNnqK/WwIGd4eJQnqg3jnFk+BS8iOF7FwCAR0eKioj5cqgKRizE7izqBgTwyjG/4pAmDHilH5n6Veo04jMR8OxADm2OGpMCOB9pRyYBoPUAsPQAP/BBiSO1fut5tE4q+4n1AOQjxTQfr53GB9wNQdYDTeaPO5FzZN+Yvj4eYPnSe8DzoSGXkWPTwZuATbBn5V3UBYIxfuKl4/KfXxXZ9yZQ+pSvZQ6OtBqVSlDRapRMHak+/aYWKv4dpGbwMaIw2YpfLmki3VtY6WNoCQCY5lY/rkOnNMBTCbgxAC4f/vnBA8ets8+OWBf8B4x+tCSpexnKGQYJw+2DDkPyWtTVi4eT/RbinTV4RmP6WhHBO9ruAUvkK+QJOJUJ0L/naiYy+GEf5gFx1hHOAmKNxnCjJy4ccMHNihC8dwgCgVeC3r+q3hZ0sLpsefCeny3z1M6/QYieoJB8fbXeUKI7zzPSv1GvV2mD3x/aaQUR3J07PsB
 3Wl1IR3M
 qE/KXqhxyEwte4hCutOyx79jMpMR78xGLxerX06HFTnIKsPjuTbUhyinBUFqMRTZOLLUqLHjJvwRNsP/7csKS/QwKJMfitP2Go8UmfyVb/XHrjeI+4Y+fOVU0MbQ/eLdzIbSRKkxT6MFsAICBLnsBG+4F40RJTYAquNdd7g6nmjOzyzs8vYKHfS8B4G9G6vFDfh0cNNCJYcrgHXGftCukpHvrIraLE9U4rdvhmUIcy57WXTrSDR6XLThkR3f0xxoTyo5Jt1MdMs8IzHw1ZUjR0k5V/HqCdY5y7awlptGiuRDvYR2Y2sz3fkiX9dZeKZMACv96PZ9QJfzPGxCBplHLyIhtXeaMRfRA+vpQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 11:59:32AM +0530, Sarthak Sharma wrote:
> Hi Mike!
> 
> On 5/24/26 10:36 PM, Mike Rapoport wrote:
> > On Thu, 21 May 2026 16:47:58 +0530, Sarthak Sharma <sarthak.sharma@arm.com> wrote:
> > 
> > Hi Sarthak,
> > 
> >>
> >> diff --git a/tools/lib/mm/file_utils.c b/tools/lib/mm/file_utils.c
> >> new file mode 100644
> >> index 000000000000..0f9322f2cf41
> >> --- /dev/null
> >> +++ b/tools/lib/mm/file_utils.c
> >> @@ -0,0 +1,83 @@
> >> [ ... skip 48 lines ... ]
> >> +	saved_errno = errno;
> >> +	close(fd);
> >> +	errno = saved_errno;
> >> +	if (numwritten < 0) {
> >> +		fprintf(stderr, "%s write(%.*s) failed: %s\n",
> >> +			path, (int)(buflen - 1), buf, strerror(errno));
> > 
> > This would break TAP formatting for selftests.
> 
> Yes, thanks for pointing it out.
> 
> > 
> >> +		exit(EXIT_FAILURE);
> > 
> > and while EXIT_FAILURE == KSFT_FAIL I'm not sure it's robust enough.
> 
> I used EXIT_FAILURE here because the helper is moving out of selftests
> and should not include kselftest.h anymore. The helper already
> terminated the process on these paths, so I tried to preserve that
> behavior while removing the ksft dependency.

In mm selftests a failure to update a /proc or /sysfs file meant there is
no point to continue the test. But if we make it a generic helper for
potentially broader use than mm selftests, exit() on failure is too harsh.
 
> We can change this to return errors instead of calling exit() and update
> the selftest callers to report failures through the ksft_* helpers. I
> agree this is cleaner, but it would grow the series a bit.
> 
> If you feel strongly, I can include these changes in v4. Otherwise I
> feel we can handle it separately later to avoid growing this series.

There are not that many callers of write_file() and write_num().
I think a patch that makes them return an error rather than exit() can go
before moving these functions to lib. 
 
> >>
> >> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> >> index 2eab2110ac6a..5e947abb7425 100644
> >> --- a/tools/testing/selftests/mm/hugepage_settings.c
> >> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> >> @@ -8,8 +8,9 @@
> >>  #include <stdlib.h>
> >>  #include <string.h>
> >>  #include <unistd.h>
> >> +#include <mm/file_utils.h>
> >>  
> >> -#include "vm_util.h"
> > 
> > I think it would be fine to include file_utils.h in vm_utils.h and avoid
> > further churn.
> 
> Okay, I'll change this.

-- 
Sincerely yours,
Mike.

