Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96008D58B09
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 03:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08FE66B0108; Sun, 15 Mar 2026 23:51:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0689F6B0109; Sun, 15 Mar 2026 23:51:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB69F6B010A; Sun, 15 Mar 2026 23:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D71866B0108
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:51:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A5028D224
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:51:47 +0000 (UTC)
X-FDA: 84550552254.04.241653B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 372F0C0007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:51:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJKFha3V;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773633105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/bz/OlRIsr3yCmSufJAxeWqWIyBHqS7n7g2qlL+oDc=;
	b=3L3WnMripOVQt4JHTZy4TeJx4tervo+0fv+7A8PyRt0iRXdrEm4mZcah0uhIprJmtMkPM7
	glsvRwQs3Vnt9/ptZgsbuaBIF4gxpi2LSOICfbtPNwHwJCP0VEASdDJDZp5hBsNw23VzXS
	YgNmwIEszdyOFU28DFfacYnpjem/uOU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773633105; a=rsa-sha256;
	cv=none;
	b=T8cqRM5F9FXnV5+WfgOYYODBkqU+ia330MAsRlvQlQLvYdAgr69KqSv8jNickCDP7x53Ob
	gZjWbJUPTBsCSJ/LQDgh6e+0piitsbVSWklmMsyqpzBPIiVH/cZgGf8CRXn/H/r+3urgdZ
	DXiEi7g9Bzcrk8gn++7UQe7fBZshUCc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fJKFha3V;
	spf=pass (imf22.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773633104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/bz/OlRIsr3yCmSufJAxeWqWIyBHqS7n7g2qlL+oDc=;
	b=fJKFha3VWTZG6/o3lyqHiA2bafgRf1wRyFKDH5UzkrPQg6qqtlPQONktNv0JVQqc1vHPll
	e4f9sbQCfFaBzmkHXNN+YxNEEGykKbOoERYPThaiCX91RAIQA1JNdsyIdY1+NnnAmkZMjU
	UCyrjRfgmVCEa2zW3OHswYFGVZ4IUtk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-gq2VcK39PcazRcXZAKMU3g-1; Sun,
 15 Mar 2026 23:51:41 -0400
X-MC-Unique: gq2VcK39PcazRcXZAKMU3g-1
X-Mimecast-MFC-AGG-ID: gq2VcK39PcazRcXZAKMU3g_1773633098
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93B901800365;
	Mon, 16 Mar 2026 03:51:38 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.28])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4AC8180035F;
	Mon, 16 Mar 2026 03:51:28 +0000 (UTC)
Date: Mon, 16 Mar 2026 11:51:23 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <abd-O8yFlB-ZFu7e@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
 <abQqLQ_6QqVgzunL@kernel.org>
 <DC5C1A71-2250-4723-9CEF-EDD300DD26E8@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <DC5C1A71-2250-4723-9CEF-EDD300DD26E8@nvidia.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 2YL4niJYw2b_w3lLXav2UPWw8LWXMiVFtxkUxfyPluc_1773633098
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 372F0C0007
X-Stat-Signature: wzi1fnk18q693h88dk9d6chdbthmyod9
X-Rspam-User: 
X-HE-Tag: 1773633105-567191
X-HE-Meta: U2FsdGVkX19INXE4wKtLbv48b5qfzlQG9+ZUitoZm7g71RG7k7hjiMO0CuvszFkvijqZezMz5NqFxW8ZLmONywmCrPbM1zdoMfT52q/KvMFZcWejHLv4bdMWnCRhkDsqv6prRnYT2q4UwD+cx5jb/Hn40Vwp2y4ZF9X80hUSDQZqOwxW5Za3B39xVZz8V4F2xIVYgQx3rPkIMrLpNFgW3kbJieNrUnAbWi9P/n97ScWCie/x67ShwtNkvJ4DWz9ACte52heua10Z055J4xoBqL/spJ74GK4Be4yNGpBJ1XgfHhFiO0yFqZL8gw3Am44JBGl/g9ks+m9doAwSxhgMC1kNZPOV7De3KT/ekaZuk/8ohwOlQr+sOmLbLiM4Q8183uDT6TQzX5c5+DCSIC4vX9BnX0uNpTPoyS9dRsDG9532LTzzgElQvYGcrH1+e2sK/wsdraitLMiYdhBwxyO3wJ9fdmnrOiBHSZPZEy0LHOrrHZXGyT99uz4ZRxPJymTtZQvNxXGEJIC27lJlgLfDHvWW/zvOnHslCT0JBFvBgxSEFlFcpfOTAqpGgJx40oeSu0v35pkOYpjF3QHtmIA6YE1xBwRDaLQnmNvsqT2sI0RYdLyHtKrrDKyEYZxAc61JVclccMgcDnDM+hivRNmjRF6ZKQlOr7t0RKkbmn7DRxxF+PkhH8BLG8MB2LWRMSmERtHMTWl1UUrAt3eM9XTNzqTUXOIVclZS8XiGOfgL/jwg6zEW7wlEgklf0mPFdKhsJDTfi9YSXnTPEDs63sBgg8Qm3NmxRQdBp/Ihc4gu6AB5XNIARlEdAYxWi15cgr75zE8bKM7aba2hXewvvVaYqWVui7cSOIosAV5RqrYy0cjnfb7Qtg/8GAEFWzKK2QQNE+Az78O/+90LLKcqhd3SWDBjnPtACzOyhzf4BOc+YjRKQ02j2A8OcKSD1aEjPw1i9JHONgKx1IThsU4yDzF
 WEEBDMt9
 Ffn6QPNRSRv+gzhw1pMGcSZVFPz91qltZfIEnhyv6AHm7QGpixpieJdPxX5fs7G6LE+4GSuD2oOfNkbDmXUlyPT2GlX1AOh5GB50Vq8VKklkDIDdKzNTEEc0tryrYrxdtiJ/hVe8Pc4m/siYDIjxskdqsIX2C6xN5KOwdWWWiDUxwVhYLruzCeiDOS5o2KsAT86ZJ/QDjQjW4VwVOEUGLoLbqdrXqVArx8brScXNrAqwJI6nix2B/igvm4DtBNbGEs3s8RqD46GGxMxAqV7fe39ozu1/RX53+/PgbDypC3TsBRBGw9akryJprs5uPOBCs9s0W2gm1WfXfnsUmbU0vNf8DpJ6O8aUGygLRy/mYrQlYogS9VgspdGntjrvWtsOX9A3xFTCQtVLlZ8tkW/YTqmhiqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 11:27:30AM -0400, Zi Yan wrote:
> On 13 Mar 2026, at 11:15, Mike Rapoport wrote:
> 
> > On Thu, Mar 12, 2026 at 10:11:12AM -0400, Zi Yan wrote:
> >> On 12 Mar 2026, at 7:40, Chunyu Hu wrote:
> >>
> >>> When thp is not enabled on some kernel config such as realtime kernel, the
> >>> test will report failure. Fix the false positive by skipping the test
> >>> directly when thp is not enabled.
> >>>
> >>> There's a naming conflict on write_file() function, both thp_settings.h and
> >>> split_huge_page_test.c define it. To make use of thp_is_enabled() helper in
> >>> the thp_settings.h, rename this local write_file to safe_write_file to
> >>> avoid the conflict. The reason to use 'safe_' is it does some error check.
> >>
> >> Both write_file() do safe checks. Actually the code of both functions looks
> >> almost identical except that the thp_settings one does exit() instead of
> >> ksft_exit_fail_msg().
> >>
> >> Can you rename the split_huge_page_test’s write_file() to write_file_local()
> >> and add a comment above the function like
> >> /* add _local to avoid a function conflict with thp_settings.h */?
> >
> > Looks like we can move the version that uses ksft_exit_fail_msg() to
> > vm_util and drop the other one.
> 
> Could work.
> 
> tools/testing/selftests/mm/khugepaged.c uses the write_file() from
> thp_settings.h in file_setup_area(), which is part of struct mem_ops.
> I thought struct mem_ops was passed to some syscall, but it turns out
> that it is used locally. The only downside is that file_setup_area() now
> has this ksefltest friendly code. Someone might want to clean up
> tools/testing/selftests/mm/khugepaged.c with kselftests APIs. :)

It looks like work in my try, even before the cleanup with the
kselftest APIs.

> 
> 
> >
> >> With that, feel free to add:
> >>
> >> Reviewed-by: Zi Yan <ziy@nvidia.com>
> >>
> >> Thanks.
> >>
> >>>
> >>> Tested with thp disabled kernel:
> >>> Before The fix:
> >>>   # --------------------------------------------------
> >>>   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
> >>>   # --------------------------------------------------
> >>>   # TAP version 13
> >>>   # Bail out! Reading PMD pagesize failed
> >>>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> >>>   # [FAIL]
> >>>   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> >>>
> >>> After the fix:
> >>>   # --------------------------------------------------
> >>>   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
> >>>   # --------------------------------------------------
> >>>   # TAP version 13
> >>>   # 1..0 # SKIP Transparent Hugepages not available
> >>>   # [SKIP]
> >>>   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> >>>
> >>> CC: Li Wang <liwang@redhat.com>
> >>> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> >>> ---
> >>>  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> >>>  1 file changed, 7 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> >>> index e0167111bdd1..615b75ca62cc 100644
> >>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> >>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> >>> @@ -21,6 +21,7 @@
> >>>  #include <time.h>
> >>>  #include "vm_util.h"
> >>>  #include "kselftest.h"
> >>> +#include "thp_settings.h"
> >>>
> >>>  uint64_t pagesize;
> >>>  unsigned int pageshift;
> >>> @@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> >>>  	return status;
> >>>  }
> >>>
> >>> -static void write_file(const char *path, const char *buf, size_t buflen)
> >>> +static void safe_write_file(const char *path, const char *buf, size_t buflen)
> >>>  {
> >>>  	int fd;
> >>>  	ssize_t numwritten;
> >>> @@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
> >>>  	if (ret >= INPUT_MAX)
> >>>  		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
> >>>
> >>> -	write_file(SPLIT_DEBUGFS, input, ret + 1);
> >>> +	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
> >>>  }
> >>>
> >>>  static char *allocate_zero_filled_hugepage(size_t len)
> >>> @@ -772,6 +773,10 @@ int main(int argc, char **argv)
> >>>  		ksft_finished();
> >>>  	}
> >>>
> >>> +	if (!thp_is_enabled()) {
> >>> +		ksft_exit_skip("Transparent Hugepages not available\n");
> >>> +	}
> >>> +
> >>>  	if (argc > 1)
> >>>  		optional_xfs_path = argv[1];
> >>>
> >>> -- 
> >>> 2.53.0
> >>
> >>
> >> Best Regards,
> >> Yan, Zi
> >
> > -- 
> > Sincerely yours,
> > Mike.
> 
> 
> Best Regards,
> Yan, Zi
> 


