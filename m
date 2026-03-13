Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5558107BCD5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 18:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C986B0088; Fri, 13 Mar 2026 14:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104B16B0089; Fri, 13 Mar 2026 14:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031536B008A; Fri, 13 Mar 2026 14:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E4BA86B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:00:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80911B741E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:00:34 +0000 (UTC)
X-FDA: 84541804788.17.BE58C00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A685C20006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 18:00:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LUN3/wnP";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773424832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUIU6/wlRdeKrauKtqF44cNrZ+ZOtO6M2mEVZIXeM98=;
	b=Nqylysf8/6FTwD8cti6AsxgTiJS3GeAnKUl9PU7h4kNFWrl/tFB0slZk5DiQm/PjYoqGf0
	cesKSay3ihb4mCkkTTWXsIvy9yXxHKizYSDxstg26b52zQKXfihbtI09hGSU/d+9YXjetE
	zjDc413r+ULY09q+1eEDDbll1Qf2SXQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LUN3/wnP";
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773424832; a=rsa-sha256;
	cv=none;
	b=UeW9k3SvGQrn4P4xjQSMqBZciOFnUAGg/8w34GUpYT9zKDRKSahjw5PxIoP/bx+FiMA/bI
	kLdKykZ3IwujKkuq1HOTWHHMVeSYXG02BRS+WI0Ylvbq+Ndp7IpsUiHu6A1g86KHDsPnlr
	eT43NoXYFUZgkoCMcAf+QQia4KspcTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E0D8440DD;
	Fri, 13 Mar 2026 18:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA26C19421;
	Fri, 13 Mar 2026 18:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773424831;
	bh=j1izIxsHXAtH1Vew0frqZGI8pM7hKLQvwq6UZjh+hhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LUN3/wnPZjfXNMWouCGXhVi7C7o5kanWGYsgBb6LXYa/XKVmSPdpHdLCeYz9ja3v6
	 TpkJaf0yelz/1jp9eJlMILhGmkb4GLNf8EUpj/h6Ua6Qt7r2Ju4OAye0rUJOEiRCJg
	 pSo+RTJefxEJp6l2Wh2J8g7FuOpxWgRPc0Mg1X+Eo10USDaZ5SBQ8QTMXFIHeNZuy1
	 uP4PP2m6+FDcnmvGPmvw+0RKuIzPVQQ+GsF6KHlP6S1nGyv5h8v0D8yu1b1ABs2QaQ
	 r40Sc8UGfAOQFS6JStOnFMxk6bKykfp+OvZatq1kWXg5AkTdHOn4hf+yhnpclLrkjK
	 On4PAnNv1HtUQ==
Date: Fri, 13 Mar 2026 18:00:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, Chunyu Hu <chuhu@redhat.com>, 
	akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <d73b4f26-d5d2-4c16-a017-d23d06b07bf4@lucifer.local>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
 <abQqLQ_6QqVgzunL@kernel.org>
 <DC5C1A71-2250-4723-9CEF-EDD300DD26E8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DC5C1A71-2250-4723-9CEF-EDD300DD26E8@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A685C20006
X-Rspamd-Server: rspam08
X-Stat-Signature: canjk4w1s8mckafz589rd84nmeembck1
X-HE-Tag: 1773424832-572512
X-HE-Meta: U2FsdGVkX198edIlXOcELoqFEezGQKjuoCaQ36zyyzFDIuL8WKsoXZoT1B6CFrxZHQtqn6kfl0CUScJ6/wdhfvt8r3jhb0YR04WCXswDN9Qejrx6c8CFFYOygXTItJJscub7bN3AgqI4Iv04VECA1XRgqbDdXmpkyynGaFnB/1QAnP/2zn7GV36GlkvGF+zp297WN7BNNvyzQVu93Q/ulbLn4MPJYqZ5PSEobAIYDEbO55SuZHNN6dLrG6z52/e2qYhTHYOYIQ6ufc1RDMUVp2flN1I4Uy42MlbwPY3i/EZ9oc8Hhdj+bWv+RrHGfbzn8HAW3ADIxdQFDZjbX9bAyFzQKg0AUVRntE5eHUVIGJE+IGEeABsHfo7xrNYIQ3dOiVKm0ZpfwiPT13622pMLsfQmTZ10kWApbnN4qpXiI5FLaZsGQCLcr2XrxCWXbqK4v2RDsOSPgGJ2/qAsx0Vck4HBPx1/vDOQYI/iTv5Z7f1y9GL+d8IrgzO5pfXT+jxbD/hTpixjVIzLyhW0MLgW6Z8m0afhsKjWhz1ZCBiq+bRVAlBMA/2fWd4C91igGMAO9QoB4kjOiP4efp537dbkrhNKKj6rqovIpcNtBHQtzoDEFRdfYGZNzy9ug6MM6dgqT0bvf/4z+tTHsVdDgpc6WT9Xou/8nO3peHAcCPRst2kR8+Dj6T6vlOY7ciyQChOI0ZrzO+uciVtPrEa+y/RM1o9DhH+9QFPjy9SgIszCsAY3AQwarHG7KBsztKREVyMvmkxX0x/UJ7TFJckUmCVJJ3cWq+jrH26EEQEA/16hIiEM6X68IUgS8BmjM1p6lwZAEF5u5fmAZTi4TH0QASqC3H2vqeF7y83uK2xo6v3oQgipCLoxTEoWs5AFtfRuUy6OQj4/IDvk5Aw69ppiJrn3FqJWN/AeBc6Gr5xuhxG7dvm2QbcE7+gY/Ddg05fwwWDhyQdPmUaaZtnLFmBSLXD
 gPpjL/fq
 U0434R1dce1w9rDDPq2JYCGRpasNq15iTw+lfVsIPCITS/49al9ybxONUiazh6icxEuysCB2Y8T7f1WoHdU9TYwCbk3FTDMNHKJ2Ls4WXeu88he51JkeIluw2ZHsIA1cLgce754ydkzmMldJVNohGvyX/GbfiK1+zMsZdhKmne5emOyudstYZYukHlUOJb8RQyTbc4udoziRNaAJnhLjgvKn0x5BO5AtSxA1sUrzGmpGBnqFjgy0iaIjSC2LHzwYpoFBo2FktvpQD9wj2nEz3zzAnQ65EePZa2VNbEZtkOWOdOioqzr419WqzUpSBO/gvCEFnabbui70CAs4Xrhx85nuZM8DOFxeB+a0zZey++iMNSgg=
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

Yes please :)

With Mike's suggestion, LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

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

