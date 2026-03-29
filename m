Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D51AF3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3596B008C; Sun, 29 Mar 2026 05:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAAF16B0095; Sun, 29 Mar 2026 05:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC0BD6B0096; Sun, 29 Mar 2026 05:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABACB6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:45:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42DE11A043D
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:45:40 +0000 (UTC)
X-FDA: 84598618440.15.5415A2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 469C74000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:45:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fKn0/Ug5";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774777538; a=rsa-sha256;
	cv=none;
	b=xd21OvFS7xIWZgjbOSbs6Bg9RP7nh6KOcHY0iYY3olj7U8fURnU50UCUzxU+tbMZSFaOHd
	LVRfiHEVhqN1iJhSEdyYYmQUnchyL8B8tfYTgBkRcGc/wZVWtceZvSjhK/NBBZuK710RPZ
	BuB930FztThr/dhiqy+M2rySrM29tRg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="fKn0/Ug5";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774777538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W32nfJzY59XmW2B9d/SGk3BvnOc25rvI+OCdxu9B65A=;
	b=cU49+RZuBaTv3jpWTpqqG6b811mq6OdWnUymxpyDr8XeIvtP5TYgOl6b4Z3Odw4IRoLdkO
	cHXPk998aQqSwwsDtDmNeqjTxGRKJko2+tKNDSETbDS3P6XsWnUisgXJoqJj8M4HmGsyai
	MtCUWfmZELiWjz/sgsJhsZHpIRgaMPs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774777537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W32nfJzY59XmW2B9d/SGk3BvnOc25rvI+OCdxu9B65A=;
	b=fKn0/Ug5n/DK+ycytWbjoo96yIOZBTtjjOFZ6gclCqrufPRCe62bclJlFg1+j9z5mvJq4u
	s4/dXuNBSas+L49oH6fPvQNDC1TBZGGSaWZMG7IyCWHrmkns/41DomY0ezWAGYX3h4eeuQ
	11q4SIJ/1SVgB8qjThxnYoIFBfzj1LI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-wyu0aMiCO9yHo1yryKQgeg-1; Sun,
 29 Mar 2026 05:45:30 -0400
X-MC-Unique: wyu0aMiCO9yHo1yryKQgeg-1
X-Mimecast-MFC-AGG-ID: wyu0aMiCO9yHo1yryKQgeg_1774777528
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD12A180044D;
	Sun, 29 Mar 2026 09:45:27 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AB5819560B1;
	Sun, 29 Mar 2026 09:45:17 +0000 (UTC)
Date: Sun, 29 Mar 2026 17:45:13 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [PATCH v6 1/6] selftests/mm/guard-regions: skip collapse test
 when thp not enabled
Message-ID: <acj0qcCUUmj-x1OQ@gmail.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
 <20260324013316.2590422-2-chuhu@redhat.com>
 <399e238e-ed6a-4d74-b075-ead17fb47d3c@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <399e238e-ed6a-4d74-b075-ead17fb47d3c@lucifer.local>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 5akorhEUKaMCJEC_ItuN_jRb-PRsOe_zZVveILGVcrc_1774777528
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: r9m73hb1wg4q9rwnssaohj51y4omtfq7
X-Rspamd-Queue-Id: 469C74000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774777538-583277
X-HE-Meta: U2FsdGVkX1+Z9xSRSKk781DwH1x+P6dhjcWnmNAn8XsVdc+N/VzK0rCDLMfAjg3ZzWNSz2jkj/NX0VwoCqNwPytcjcQLxubSN25xnFrBqYPDNM7EXbyeMDDyZintLzJy0Jt1VsZ+2OSMwD5xQfB5xsAy8P7oVMCr6SDPf+rlZflKK3i2flSSxet+HL/0K6FAsVKqH9rlDh/f68pFoGVpISgoQVTQBex987acPS617KI1MB35igjRprkkirVs9VWOil/MoGg3K4hrvoF2SRcmJhkHgb2stLhFchJ+AGuzLQ19tiAyXjy36eJYDQBPU7kV9n7DYM2XfBUhVwUQuPPu9ObsCtced/eeiGhHNoYKHKj/IAgSakZlE5ug/bUl7aBhi+mTZNc7C3NbXBLsa79iYywT+9Z1u3mzvHR7VoVFxOGjEcd+I0WV7h+LyjF9TZ/sL55ivfxYbyh75sxRRjr3Bql2OxuDDXYbl0wvRMtLHKrHReU0GOJv5Fi3fLtes3Nwka3j3yvXeS3WcUiTI65xRXjZMAatsWRDhGAZD8nnZtrxY8n2Vr5Rip1pjZdk2Grusv2p+Be6IQNHglw9He6OIhFSBlbWmK/jrkcRyTjuQAArPGtTb3ayH4EC40L2In+RBiKNVrZP9HuMS/woQVWJPBTb/cIVI9b5I88VNGeBcQEKWT74rOd14OoZLxQ3UWDbsAvYOFsFp9HIF0uIkht+Wb9v4ZNZ5oD3EB4QKpdJqvqT+1wUBD4FEWYHpyECVZQn/LajuveWtLiAqP0vLNshkrIQjFaEG5iI9f0FBoxSx7oxDOAplZR4luZsJ32MPugQ4uyaVPxwHsfjlLpI4A5EZPtBO+Iq7Pbh7xqdAhZYNJuysoCoAFAq0oN09HeLcfeQ1jRePnJcDWLU2nPtCBeikyWpDdLf0nBUYfDA6lerp8U0czddf5xBvANIBEGb5QBatpP/QSelbYeK+OmT9MO
 SUZfYmRI
 8eXesPXFCUE1B6DTJbKzxfQimZCzdBRNz4gYfY3a3y6VHczXnGJe7z3S538EqNyVP9BPOUxUQU0oorFr87XXyQg5zjhNSeUzFsyJI0NSyMUfiZ2u/WqmNG3/lUjodbOYvn82fDCaLF0c9eJzhIxt2aR8N6eaArlhiB9Qjqj37xkaGpx0/jrUB9ooPweGuEcnFD+ZNLyQAlNXWUKEMCv2hZK2+Bhro6LMhrcPhmCs1viNo+NyJy97QkK6pdwhkDjNH/LZ9ba3Yvm4q75tYQm4IgJWEkzehW/yaxw0HJXRTs+030Yt/ARhtfULzdqtAu77ZuXHK2OHxt228+5qIh7S//j+41wFkLN3Y/8BA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 07:43:14AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 24, 2026 at 09:33:11AM +0800, Chunyu Hu wrote:
> > When thp is not available, just skip the collape tests to avoid the false
> > negative.
> >
> > Without the change, run with a thp disabled kernel:
> >   ./run_vmtests.sh -t madv_guard -n 1
> >   <snip/>
> >   #  RUN           guard_regions.anon.collapse ...
> >   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
> >   # collapse: Test terminated by assertion
> >   #          FAIL  guard_regions.anon.collapse
> >   not ok 2 guard_regions.anon.collapse
> >   <snip/>
> >   #  RUN           guard_regions.shmem.collapse ...
> >   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
> >   # collapse: Test terminated by assertion
> >   #          FAIL  guard_regions.shmem.collapse
> >   not ok 32 guard_regions.shmem.collapse
> >   <snip/>
> >   #  RUN           guard_regions.file.collapse ...
> >   # guard-regions.c:2217:collapse:Expected madvise(ptr, size, MADV_NOHUGEPAGE) (-1) == 0 (0)
> >   # collapse: Test terminated by assertion
> >   #          FAIL  guard_regions.file.collapse
> >   not ok 62 guard_regions.file.collapse
> >   <snip/>
> >   # FAILED: 87 / 90 tests passed.
> >   # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> >   # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
> >
> > With this change, run with thp disabled kernel:
> >   ./run_vmtests.sh -t madv_guard -n 1
> >   <snip/>
> >   #  RUN           guard_regions.anon.collapse ...
> >   #      SKIP      Transparent Hugepages not available
> >   #            OK  guard_regions.anon.collapse
> >   ok 2 guard_regions.anon.collapse # SKIP Transparent Hugepages not available
> >   <snip/>
> >   #  RUN           guard_regions.file.collapse ...
> >   #      SKIP      Transparent Hugepages not available
> >   #            OK  guard_regions.file.collapse
> >   ok 62 guard_regions.file.collapse # SKIP Transparent Hugepages not available
> >   <snip/>
> >   #  RUN           guard_regions.shmem.collapse ...
> >   #      SKIP      Transparent Hugepages not available
> >   #            OK  guard_regions.shmem.collapse
> >   ok 32 guard_regions.shmem.collapse # SKIP Transparent Hugepages not available
> >   <snip/>
> >   # PASSED: 90 / 90 tests passed.
> >   # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
> >   # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > CC: Li Wang <liwang@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> 
> Pretty sure I reviewed this already (but hey I forget to propagate tags myself
> sometimes so meh :P), anyway:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks for the review. Will add in next version.

> 
> Cheers, Lorenzo
> 
> > ---
> > Changes in v5:
> >   - updated reviewed-by and acked-by
> > Changes in v4:
> >   - use thp_available instead of thp_is_enabled() as when thp is set to
> >     never, madvise(MADV_COLLAPSE) will still succeed by design. So a
> >     failure in madvise(MADV_COLLAPSE) on guard region will verify guard
> >     region denies it. This is suggested from AI.
> >   - removed the 'Reviewed-by' and 'Acked-by' as the code changes. Sorry for
> >     that but it seems the changes is a little huge? (1 out of 2 lines)..
> > Changes in v3:
> >   - commit message: update the log snippet with where the fail happens and
> >     add the '-n1' to the command.
> >   - fix the 'false positive' to 'false negative'
> >   - add reviwed by from Mike
> > Changes in v2:
> >   - add reviewed by from Zi and Lorenzo
> >   - add acked-by from David
> > ---
> >  tools/testing/selftests/mm/guard-regions.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> > index dbd21d66d383..48e8b1539be3 100644
> > --- a/tools/testing/selftests/mm/guard-regions.c
> > +++ b/tools/testing/selftests/mm/guard-regions.c
> > @@ -21,6 +21,7 @@
> >  #include <sys/uio.h>
> >  #include <unistd.h>
> >  #include "vm_util.h"
> > +#include "thp_settings.h"
> >
> >  #include "../pidfd/pidfd.h"
> >
> > @@ -2195,6 +2196,9 @@ TEST_F(guard_regions, collapse)
> >  	char *ptr;
> >  	int i;
> >
> > +	if (!thp_available())
> > +		SKIP(return, "Transparent Hugepages not available\n");
> > +
> >  	/* Need file to be correct size for tests for non-anon. */
> >  	if (variant->backing != ANON_BACKED)
> >  		ASSERT_EQ(ftruncate(self->fd, size), 0);
> > --
> > 2.53.0
> >
> 


