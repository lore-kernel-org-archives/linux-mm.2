Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE4EC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 03:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108976B008C; Tue, 15 Sep 2026 23:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBD86B0092; Tue, 15 Sep 2026 23:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14C86B0093; Tue, 15 Sep 2026 23:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 749D36B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:47:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7CD3716046E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:47:11 +0000 (UTC)
X-FDA: 85218239862.02.47673EB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7955E20004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 03:47:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tnJJ08F2;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789530430;
	b=BOMdP+0mJ6HJmG1G07MFROgI0ZlZGjAgWatdVxlDnfm/qR82oveX2douqo3htl3J4ZzHfp
	QlJmm+yEKg70+cuCP10Gw4LITF5KYNYUfENd2XIxBlGMAo2cyIFsrJumYriJ8AoKTrSykJ
	D1SqHYMUexrG7TonFILagRfXtVYCLho=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tnJJ08F2;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789530430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9efYSZJn9a/CzhHEaT/SrO6qZOgETJFVf5gs3eb/8ZM=;
	b=VdiZ2LA+hIFrUCBASg83ejOgqhU2j+t1AxaaCLSZsHmq9KFLXRdQhFAy1Pnzbrzd4s9gMm
	zo09eqG7YLUvIGgfSVBToADiE+j2+wW0oM99ersjXDi+NhfYJC95saHsWEd2Lme3DIO87r
	hF/dYZ/6R1KDfHRH4ySMVcvgxC52+Oo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D8ADC1516;
	Tue, 15 Sep 2026 20:47:04 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D860B3F882;
	Tue, 15 Sep 2026 20:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789530428; bh=gOP7mzIR6JicHMR6kpk3glCyrPVAZFRo2ZW+FrgmoTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tnJJ08F2B08v+fsmMrIYOk0W1spMzOSuvw85ZIxDRL/cerfM015Dh3CGI9V7nyzyf
	 pN74mS7hOpVty/3zNCtYAkuo4HA6jeKDhcnCFOMGC7vZcmFtYKiYsulg+fFme8yPHo
	 CeN5iGihTx4JeaKQbPMyN1tnhGhFIBW2U9blnLao=
Date: Wed, 16 Sep 2026 04:47:03 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
Message-ID: <aqoRN6_qo2nEy27c@e129823.arm.com>
References: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
 <20260915-fix_khugepagd_fail-v1-2-bb6f04c8759f@arm.com>
 <24690e82-3aab-4f2d-95a7-3bba332ca5bc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24690e82-3aab-4f2d-95a7-3bba332ca5bc@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7955E20004
X-Stat-Signature: iu94a9pzwqrdk4h4cg5fgnhz5knnaag5
X-HE-Tag: 1789530429-641623
X-HE-Meta: U2FsdGVkX1/q0R6K+yW7j7BqEHOFcOpTWRgpkVOKI1phkDRypVUEN6BJedC4qwpwP0LnDF2VfH+Isgp9JiBJ10kUECHPGhLrpyFspDNMulbSswfR5Zh+1lRNyJ5+qEzjNpj+kSCTAuhyzyHtFoSXbVbICo6ni+MCHsV0oSYnxrQXaGIsw5GaPpWi53RozNuG+VWZThVrNYNVplxl0CJs8DQI8Et+ES4mPlRiM5cSfVz/cYYclhUaQXm7rMrMa5N5BEtXVPqK8GIXlLGJhrw5fAz9yB96b9W60E0VhI3+po9kdo9Q0z/ZERf57Aznm+xjgEKQqfB394zcNJSHrJd6M6qbzBRJXxuPP9OSn/ZDgAY/rAmgZtKV08iCWl4XI6UfKAm6+ajkYoUogDZFDuYqi7R2CuJBwwvAXKl+facaUOSay5/+3aIjhM3zKg7vjGvqbyYlWLG1WLRfwvxZ3+6ximi21T/zGMEqm96KXqGKl2fzer6JnfIk+88vVFAeGTjJgy6i98qIV31r6GBS6Kz08LWhEWHKmz9jezadC/8/jQzxFpDcgZtFLyJ9E4pW2s6/gOSEFheTpoy3n932nAczHJTQ3sThjba/S0wkG4VrY+LMRPsO/T0Zg/hKGd4J86d0dNsp7GtJO+ZCgFOu+stSg+DL1vmkI43u/fvAqNtMat9Yt0BuEZad4VmGMTIl66JwLQ/eJb/XYA1yH4zwOPPPCUqkEd+EfxnWaGjcfUQ5kMtY1MzYrf/4O1mhUkbd7q32xtAnAXmVi5ShADTv1j8BHFlp/EzSDxAAwdA2vodMm1x1xKWIokyTegcPisdRiuV4pvzTUxR0xajFFD7C2rwRJoSp2eT6R2mCtP5PyTxv33iAED4O0hX/V1jXHdQHDAToLSp86OsVLrbDuFD0pNPQTUDezJ+9jiehrURxOAaBudAsB4pKGxaSbEoAUQk/CehNhL0e1PBfjvQkkpvT/Cp
 0XULSJnT
 LBqMoqNxOUSnO2NxXx6bManSLBrUt3j+dZMObWVZrV1qBOslGl42a2KmZBiMCSC5uyQb/mbb5ECRfMOsvAWQyU6K5lGr5orAlKF+TO6d99kGUv5T9k4DWnj1/zDgkijIx/GcugvwNgQzI5Gr7G6qeiGL7wR3hK88UQbZiZeJ6K0KwF07nWxopFc30n1xAzuxVqz5qs6kg833ZBQhIcPaIhipSZdgmZaHdbJmejBw3q0ZLQO9WKUj4DpqMbJNEFthWumGUIu/h+UzZdO4susdH2LhRZlOVPLc26VeipwUATExvOds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> 
> On 9/15/26 5:21 PM, Yeoreum Yun wrote:
> > There are intermittent failures in collapse_max_ptes_swap() and
> > collapse_max_ptes_shared() when using the khugepaged_context:
> > 
> >    // while running ./khugepaged -s 2
> > 
> >    # Run test: collapse_max_ptes_shared (khugepaged:anon)
> >    # Allocate huge page... OK
> >    # Share huge page over fork()... OK
> >    # Trigger CoW on page 1023 of 2048... OK
> >    # Maybe collapse with max_ptes_shared exceeded.... OK
> >    # Trigger CoW on page 1024 of 2048... Fail
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 23)
> >    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> >    # Run test: collapse_max_ptes_swap (khugepaged:anon)
> >    # Swapout 257 of 2048 pages... OK
> >    # Maybe collapse with max_ptes_swap exceeded.... OK
> >    # Swapout 256 of 2048 pages... OK
> >    Bail out! Unexpected huge page
> >    # Planned tests != run tests (26 != 17)
> >    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
> > 
> > This happens because khugepaged may collapse the pages before wait_for_scan()
> > is called, causing a sanity check that expects uncollapsed pages to fail.
> > 
> > For example, in collapse_max_ptes_swap(), after faulting the pages back in
> > and paging out up to max_ptes_swap pages, khugepaged may collapse them again
> > before c->collapse() is called.
> > 
> > To prevent this, change the khugepaged setting from ALWAYS to MADVICE for
> > the affected tests, and mark the VMA with MADV_NOHUGEPAGE after it has been
> > collapsed by wait_for_scan(). This prevents khugepaged from collapsing it
> > again before c->collapse() is called.
> > 
> > This failure was observed on NVIDIA Spark with 16KB page.
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >   tools/testing/selftests/mm/khugepaged.c | 15 +++++++++++++++
> >   1 file changed, 15 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> > index c32244b565658..83e9386bbc842 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -578,6 +578,8 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
> >   		usleep(TICK);
> >   	}
> > +	madvise(p, len, MADV_NOHUGEPAGE);
> 
> This looks incorrect to me and would reintroduce the previous problem.
> Please see commit 7962e05a835f ("selftests: khugepaged: fix the shmem
> collapse failure").

But, after the thp_enabled changed the THP_MADVISE and then fault,
there is the chance to be collpased for anon.

I overlook the shmem case. but simple could we do like:

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c32244b565658..047524f001532 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -578,6 +578,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
                usleep(TICK);
        }

+       if (!strncmp(ops->name, "anon", 4))
+               madvise(p, len, MADV_NOHUGEPAGE);
+
        return timeout == -1;
 }

> 
> > +
> >   	return timeout == -1;
> >   }
> > @@ -839,6 +841,7 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
> >   static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *ops)
> >   {
> > +	struct thp_settings settings = *thp_current_settings();
> >   	int max_ptes_swap = thp_read_num("khugepaged/max_ptes_swap");
> >   	void *p;
> > @@ -860,6 +863,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
> >   	validate_memory(p, 0, hpage_pmd_size);
> >   	if (c->enforce_pte_scan_limits) {
> > +		settings.hugepages[collapse_order].enabled = THP_MADVISE;
> > +		thp_push_settings(&settings);
> 
> I'm not sure why the collapse_order setting needs to be changed here. In
> your test case, you did not use the '-c' parameter to specify the collapse
> order.

What a stupid of me and I post wrong one... thie should be thp_enabled...
Apologise :(

> 
> > +
> >   		ops->fault(p, 0, hpage_pmd_size);
> >   		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
> >   		       hpage_pmd_nr);
> > @@ -869,12 +875,15 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
> >   			success("OK");
> >   		} else {
> >   			fail("Fail");
> > +			thp_pop_settings();
> >   			goto out;
> >   		}
> >   		c->collapse("Collapse with max_ptes_swap pages swapped out", p,
> >   			    1, ops, true);
> >   		validate_memory(p, 0, hpage_pmd_size);
> > +
> > +		thp_pop_settings();
> >   	}
> >   out:
> >   	ops->cleanup_area(p, hpage_pmd_size);
> > @@ -1075,6 +1084,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
> >   static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
> >   {
> > +	struct thp_settings settings = *thp_current_settings();
> >   	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
> >   	int wstatus;
> >   	void *p;
> > @@ -1100,6 +1110,9 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
> >   			    1, ops, !c->enforce_pte_scan_limits);
> >   		if (c->enforce_pte_scan_limits) {
> > +			settings.hugepages[collapse_order].enabled = THP_MADVISE;
> > +			thp_push_settings(&settings);
> 
> Ditto.

Sorry this should be thp_enabled...

> 
> > +
> >   			ksft_print_msg("Trigger CoW on page %d of %d...",
> >   			       hpage_pmd_nr - max_ptes_shared, hpage_pmd_nr);
> >   			ops->fault(p, 0, (hpage_pmd_nr - max_ptes_shared) *
> > @@ -1111,6 +1124,8 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
> >   			c->collapse("Collapse with max_ptes_shared PTEs shared",
> >   				    p, 1, ops, true);
> > +
> > +			thp_pop_settings();
> >   		}
> >   		validate_memory(p, 0, hpage_pmd_size);
> > 
> 

Thanks!

-- 
Sincerely,
Yeoreum Yun

