Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A33EB105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25756B008C; Fri, 13 Mar 2026 11:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3646B0096; Fri, 13 Mar 2026 11:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5766B009B; Fri, 13 Mar 2026 11:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98E286B008C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:16:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38DDC1A0239
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:16:10 +0000 (UTC)
X-FDA: 84541390500.03.CF9EF24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4B5611C0018
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:16:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzHclv9s;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnD0IwvDUcymKSPClJgrfv6oj4ZtBpBpOQ9XoBw27FE=;
	b=AHhnn6Ztk/ZqRi6ToXKg4s4I/6uHzsDO1gfPatWEkpqXmG49faGdrdlGVQ9Q/1ANYsB6En
	MpdLzDSEL6Pbw+fqG4L1KZRfjvqQy3XdEMrnnldzf54mh68g4+tyNuJ/q/rqpjXfGRbSFB
	CUmAOuqY6mvxhzFMhrJXesIzWb2trso=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uzHclv9s;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414968; a=rsa-sha256;
	cv=none;
	b=s/NBKw6200iTt83rfR6T4EqpK3A6/QYplKqxlXGL4FA7qSjCT1lZRM6zOCpT1ieadMFvMk
	9B9Nf0hyhL4wVK+byDQygSrCI4M3QNImYoJQgW4ClQdbyLHPLqtErAgWWxOQWR+dftAo0A
	wWX9oCfyNW3LImMqEFJaFyGCisTgXYg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E24432DC;
	Fri, 13 Mar 2026 15:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464BBC2BC86;
	Fri, 13 Mar 2026 15:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773414967;
	bh=hmPBFRDIjNYL93/8I6WyJ/XGzf5bSzknZVavkSNFMEM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzHclv9sW8UPcX+VMX30E3oYY9Gu/EZ2xaTA2akoeMCDEs/x52+Dj10azyrM9xmx3
	 bABrtB2xmzIjbWn9fCRhW8v2MvdDsj5kKNI65FxUVEwWL4Y3B4QLAMtWLgN9/zNFDW
	 2J8AcIJtItn2pW8oAIq3NJBuryFR3AfxnP9ys3oLwdQWfE22f6Khs6nn0Fl1/vaLpn
	 /M/RRJrlY884vpWZF+khgkMXnPXAIDTf7vzm+PEN6zhfC4WPKyfWG30pUAAXdeX3B0
	 uXnS/7I2H1os8AUDChoL+T+2llXF8qnIPB1hI9C8IkUDDk5Ku0kfTpBBZ/CA1LpM9s
	 mYdaibWdJpdpA==
Date: Fri, 13 Mar 2026 17:15:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
	ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, Li Wang <liwang@redhat.com>
Subject: Re: [RESEND PATCH 3/4] selftests/mm: split_huge_page_test: skip the
 test when thp is not available
Message-ID: <abQqLQ_6QqVgzunL@kernel.org>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <20260312114027.634559-4-chuhu@redhat.com>
 <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CD772D2C-F489-498D-A61C-9EA0D377B174@nvidia.com>
X-Rspamd-Queue-Id: 4B5611C0018
X-Stat-Signature: 8g4j6jwapqtuc99tt11cwp714z5baqw3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773414968-749365
X-HE-Meta: U2FsdGVkX19eoFSNuU8WrAtMI44jdlA1fqqbt9Lcr7JdMCt2pXzMA7/v2x25K71+49Iwc13Q63vDvtpY6FGVWVyR61ZNE+XpaLsM3ASxQi0QL52yEJKlYfpm56l8pO/tYtGRKbt8o0PJj3xxu7aSnLfSLnEirNQBAI4Eg3W+hk9/vLaRp1R3vPm+94PdfqIAhvQ4L/7qJaPTEEY26fJ/TyfCPHJjqDTKWj+QjFvxkVD9rBnXGRoF6Qs3Fp8kY+6qroV0VkhxxTWCoNLSkqDejfZnGoAaIntoXz0yDgYlaKyXaugjrM5SUJ+FySQEgf+6X6AJLkdRrkKK5whzn/u3QScEfVnicIf0yv2O7FFXM/4PqIFD9vHBtJDNpFr3QYtPcDdEmJAgds+cj+vrhJ9SYr6RrVZVw5d4ZzEyyXnV5pg4SqZAq6Orsh8T3BnIZb+sQsJJGH5uZe4THR0SRuWtXCafYuGWx3NKmzBTynldXvm+aX3TQu+flRkPHq3s4zrEcoC1RSUNK8NN038sD3jgRvMZ5r6n/r4cQ56U4+l6o8rbyU7LLtc10VMwTEjhTlL7owBzBlbKVUo6TDqkj8zurJvTiC7sJ/VHqpkJ6HIF9qs/eXSc4tIHsCE1SJ0Kq7KRT6y9hXooTU7yy0V3Q1N2czNlO5XFOx70XEg0gPeqqQCdnLwrVowry29l2RGIIRD13PRxeebNgJ4pFHPaBlNu55WjiT8QOYWkAovAyOTV/OZaVq5ZaPQ4+kkJtnH5HLTrDr8diA7+20lNytBJpKSBUBqHSXXgKJqNBAImjGkIB5lbcBM199Cr0DXfO/XlnX21gtgrWjZrBSCQdcIRgfr/dIfsuV+/QsPi7uGzedYAD9YwdYj5/USmgTKeVKBDuXuT4YQs5+HamToAkiji8u67l5HaP5cN2Y/OkY/4UZAmqa8id9e7yReVkfIYQeJkKXdBbyx2YOoqs4qYit289k3
 +SI1itX0
 2ADyUKj7StftM1BzKSe0IvyVwxFYGGY1UHUfNT1qa2cK5xKcVFsu9gen9u/9QsF37gzj+Xraq9luI9wE+J9uoslXI7QaMa3uawIOI4fL6AILzx7gcURCAHBXczSt5IR+BbcNhupl3I2oHL7oxnvM07phf1BpflxsAhsZtEIb8LJZ+7/u6q2qelIhFKuSnmQSNv9LkH8NfTScJOiBs04Oi8p7jB4LOGeh2ihFDqj0mOiI6xQK6150tu78OaBjVQZDW3hC+9l9NB6yOBYURa+/F9YC/odeF3jVsfHe6cTslIgOX/kS6l6T6PJWOr7VDs4+S0cCkRs5OpiHUkR9Xm6FXJCRAwlSTf6HfN+Z+ZejGmTilsIaHXJAKy+QHVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 10:11:12AM -0400, Zi Yan wrote:
> On 12 Mar 2026, at 7:40, Chunyu Hu wrote:
> 
> > When thp is not enabled on some kernel config such as realtime kernel, the
> > test will report failure. Fix the false positive by skipping the test
> > directly when thp is not enabled.
> >
> > There's a naming conflict on write_file() function, both thp_settings.h and
> > split_huge_page_test.c define it. To make use of thp_is_enabled() helper in
> > the thp_settings.h, rename this local write_file to safe_write_file to
> > avoid the conflict. The reason to use 'safe_' is it does some error check.
> 
> Both write_file() do safe checks. Actually the code of both functions looks
> almost identical except that the thp_settings one does exit() instead of
> ksft_exit_fail_msg().
> 
> Can you rename the split_huge_page_test’s write_file() to write_file_local()
> and add a comment above the function like
> /* add _local to avoid a function conflict with thp_settings.h */?

Looks like we can move the version that uses ksft_exit_fail_msg() to
vm_util and drop the other one.
 
> With that, feel free to add:
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> Thanks.
> 
> >
> > Tested with thp disabled kernel:
> > Before The fix:
> >   # --------------------------------------------------
> >   # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
> >   # --------------------------------------------------
> >   # TAP version 13
> >   # Bail out! Reading PMD pagesize failed
> >   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
> >   # [FAIL]
> >   not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1
> >
> > After the fix:
> >   # --------------------------------------------------
> >   # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
> >   # --------------------------------------------------
> >   # TAP version 13
> >   # 1..0 # SKIP Transparent Hugepages not available
> >   # [SKIP]
> >   ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP
> >
> > CC: Li Wang <liwang@redhat.com>
> > Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> > ---
> >  tools/testing/selftests/mm/split_huge_page_test.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index e0167111bdd1..615b75ca62cc 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -21,6 +21,7 @@
> >  #include <time.h>
> >  #include "vm_util.h"
> >  #include "kselftest.h"
> > +#include "thp_settings.h"
> >
> >  uint64_t pagesize;
> >  unsigned int pageshift;
> > @@ -255,7 +256,7 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
> >  	return status;
> >  }
> >
> > -static void write_file(const char *path, const char *buf, size_t buflen)
> > +static void safe_write_file(const char *path, const char *buf, size_t buflen)
> >  {
> >  	int fd;
> >  	ssize_t numwritten;
> > @@ -283,7 +284,7 @@ static void write_debugfs(const char *fmt, ...)
> >  	if (ret >= INPUT_MAX)
> >  		ksft_exit_fail_msg("%s: Debugfs input is too long\n", __func__);
> >
> > -	write_file(SPLIT_DEBUGFS, input, ret + 1);
> > +	safe_write_file(SPLIT_DEBUGFS, input, ret + 1);
> >  }
> >
> >  static char *allocate_zero_filled_hugepage(size_t len)
> > @@ -772,6 +773,10 @@ int main(int argc, char **argv)
> >  		ksft_finished();
> >  	}
> >
> > +	if (!thp_is_enabled()) {
> > +		ksft_exit_skip("Transparent Hugepages not available\n");
> > +	}
> > +
> >  	if (argc > 1)
> >  		optional_xfs_path = argv[1];
> >
> > -- 
> > 2.53.0
> 
> 
> Best Regards,
> Yan, Zi

-- 
Sincerely yours,
Mike.

