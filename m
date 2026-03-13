Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8198B105F7B5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28EA6B008A; Fri, 13 Mar 2026 11:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0306B008C; Fri, 13 Mar 2026 11:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16CA6B0092; Fri, 13 Mar 2026 11:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C09DF6B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:36:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68FAC1601F9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:36:05 +0000 (UTC)
X-FDA: 84541440690.03.DF3879C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B6F63C0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:36:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/xzZO5t";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773416163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MerlekVfk9K5c0NPVB7gC3JHabt0YVuv55ZAQ7AyrtM=;
	b=HKTJ54hb6JmYYgbsyVpkY+wpzoLuc2zwRrRIHGIdzfwKYnYM2Ko/aYiVgAJLPZ63ZhXxu+
	tghctoAMIKmhY53ZTdDOy7GaVHFvAf68ZcBp+Z5Fx0/cZcWhQQuuzuj84JkzvFy3IYTT52
	1BEtnD3Go+JV5K0+3Ekg6Lo98PH2+YE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773416163; a=rsa-sha256;
	cv=none;
	b=44wdoXBgJvr0+MVvq15gUze/gMuE9Bm4C53TilIlNDtN+4yGYGo2yYn4qLnVa1vijcNXG1
	NFC2s2D0SZQnNnSd9wYtxdKE9KejmuTH2lcpRJwPuxTnsNxK2OUdY34Ck4u22uTtGl3Zey
	qZvumKqxuE0/tIhQXn6r45EHrUfNl+s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/xzZO5t";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17D7860142;
	Fri, 13 Mar 2026 15:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C858C19421;
	Fri, 13 Mar 2026 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773416162;
	bh=8CTc2A4Y/FaXlXTchN73Tai25CXorxmWgxGIdw1ZJVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/xzZO5t/wLPFo20XtpLKo/vxjUUykRZxGexCi2DjU1XUbSUwW0+HBOs8mY46TByB
	 yD53oGpu+25ooVbSBwgTUnNoOOP4XZ1oNGaaIt0o0QE99L6ugp4TbeTA1EWylq/UCV
	 /EDNPnAyUrbEnXPRvtqUA096JeyHkx0+A1Wg6JmCbLN+91C8OY46MFWMwU077HwKD+
	 Si9jhPtwNam3sBihNNnZahvKGjqmhGcNRyXLVlPr9JhqU9wYLUWYpLX47tSGNVgtkP
	 qVElMluhW6ohJMSQUbtROl1FtOr+zpPhrXMdZbAG156w7rezNeO8RDxAEWiCxKx0DK
	 fAnQfQMcHmfiQ==
Date: Fri, 13 Mar 2026 15:35:55 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 1/4] selftests/mm/guard-regions: skip collapse
 test when thp not enabled
Message-ID: <097793cf-10f9-4b0d-9d13-f728fc0c4d58@lucifer.local>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312114027.634559-2-chuhu@redhat.com>
X-Rspam-User: 
X-Stat-Signature: 5xt94e6nmg3wsi13n74xfygyunsa5ksz
X-Rspamd-Queue-Id: B6F63C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773416163-872845
X-HE-Meta: U2FsdGVkX1+NFRpESy+bunLVwychKGnVFPzRTV0nypaQQJ0wQ3pAynnh4vONUQoyGesyyrqKvnUicoR39HwYWiSyTiKlTumCxDy5vUTCpQNFzfRIJfaUrl3jXQDp5PSCTuFBJzMdOeUAQEENG9NI3zRoW9rSpOTPSDi9CCpgCEAKxvgUXeoe+bux8PSoIuR8Tz55IdJCPhk/bIinO4QEQChvt63H9bElnXMdC/kjoKuYhCaBUAUQUWurrHgEauBXo5UOhpQITzUQb7c1ndczR6x4IoiWWVvb7tNyu8XHGtzjYqeYuPpFIGQYwmkbZF+U5dWTv+Y125+400pAXK2wbD8pLqWq7Nq1B2OinPBF3pzqtzjzW8lpga5M31Y12Y2WZ8CvhSYDfMPgwlaXS62x94I3YNN+HuASMGSzVvrbNs4OapUgAZmcX9fsy3neaKcLtxMUiE7npLqnOfuIPpMAagH/XpLdyBpERh/6iLgNqv4nsFIt6sDcQ7FMtQTe3+HoQwGd1sFLIFLgx7djJrFBkl9y3QxwdHdHUzt1xYTxaWJUBTKbAhtJVFl5SAXYL6OmVnpExJL6lttq2QYm+P4JDykG97FzJvcCOKJn+9nXdeBLtkRnt8mRKTVKVgZms5dHRXNm+hal9lP6t3aZ4IcOB9QSes8zOIHclwPwekgf1pdIUfP/uqf3oegT6pxQ1D+wvTzP28fbUlRbHcL053xvnn6tkpjFPW1NVGR8pcKTZdNx74fu3uB8jNKQvwE8A1QmCPDboyigZcmPazc0vCSipOjyHmbKXEBbjLtQ+7sIS8K99WpKmBT8DlS6e/YknupydHAHcQq+e6FMe6+pO4KOAm0e2nnuXfN8YXnjS93O6oppNvGH11PgWWDWtTeHH3GTZYO9gQg/+V0Ym6BTr/p4IiqRtWbIWOBGOIdf4YGb1352qYlKesntPscUto6wsyzYtIFPGNc83LJUx7JxS/b
 AijJMUbE
 knkJmlcjyMY8pQcjnWaavFYzTWs/sgChElng1seqt++hU8I+Qf4KnAaUXSS36KV8OHZUAkE1DryfL+43mKVKxvwiiPCv/FGGpeSUm8jt4hdPzLuu7BVOjMvHDlpwCdhBA3ZVRxl6YHThEwB5xRLOBmF0TV1piqREWosVnQ4g82yhNXWCci6TDkgAprt+Hl5fipSz4SR6Ho18Tt1d8TSEVShOCf9n7GS2yQ+zm+V802na/ojR2P0JFBm9kNLD3E4MECSyj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:40:24PM +0800, Chunyu Hu wrote:
> When thp is not available, just skip the collape tests to avoid the false
> positive.
>
> Without the change, run with a thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard
>   <snip/>
>   # #  RUN           guard_regions.file.multi_vma ...
>   # #            OK  guard_regions.file.multi_vma
>   # ok 89 guard_regions.file.multi_vma
>   # #  RUN           guard_regions.file.basic ...
>   # #            OK  guard_regions.file.basic
>   # ok 90 guard_regions.file.basic
>   # # FAILED: 87 / 90 tests passed.
>   # # 17 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Totals: pass:70 fail:3 xfail:0 xpass:0 skip:17 error:0
>   # [FAIL]
>   not ok 1 guard-regions # exit=1
>   hwpoison_inject
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
>
> With this change, run with thp disabled kernel:
>   ./run_vmtests.sh -t madv_guard
>   <snip/>
>   # ok 90 guard_regions.file.basic
>   # # PASSED: 90 / 90 tests passed.
>   # # 20 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>   # # Totals: pass:70 fail:0 xfail:0 xpass:0 skip:20 error:0
>   # [PASS]
>   ok 1 guard-regions
>   hwpoison_inject
>   # SUMMARY: PASS=1 SKIP=0 FAIL=0
>   1..1
> CC: Li Wang <liwang@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>

LGTM thanks, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/guard-regions.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index dbd21d66d383..897af9c512f9 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -21,6 +21,7 @@
>  #include <sys/uio.h>
>  #include <unistd.h>
>  #include "vm_util.h"
> +#include "thp_settings.h"
>
>  #include "../pidfd/pidfd.h"
>
> @@ -2195,6 +2196,9 @@ TEST_F(guard_regions, collapse)
>  	char *ptr;
>  	int i;
>
> +	if (!thp_is_enabled())
> +		SKIP(return, "Transparent Hugepages not available\n");
> +
>  	/* Need file to be correct size for tests for non-anon. */
>  	if (variant->backing != ANON_BACKED)
>  		ASSERT_EQ(ftruncate(self->fd, size), 0);
> --
> 2.53.0
>

Cheers, Lorenzo

