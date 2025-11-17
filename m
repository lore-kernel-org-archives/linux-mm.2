Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F05A6CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 22:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563EF8E000A; Mon, 17 Nov 2025 17:43:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BDE8E0002; Mon, 17 Nov 2025 17:43:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4786D8E000A; Mon, 17 Nov 2025 17:43:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33DBE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:43:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7C7E12939
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:43:38 +0000 (UTC)
X-FDA: 84121577316.15.02BB8A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CBEE180023
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:43:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FyEeWQ8i;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763419417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fbv04ypCQkVNOLO0sNJ75k/LanFNU8xluYtFmS3Ra4w=;
	b=goW+dWkwVGUYMiLholSNPn9wzxNIed8oc62BTXmxVQnGu0Ipb6tzvFP2ZrQfK6drPrz0H0
	l9YICY7VMS1GCFDwgJJHlG/RpLLCF3T486akzPbrYV5BQNQNvCnJVovySb4ijJccDqyhDL
	/fZqCLFKTp1zv5KftU38o1vbTG7qyUo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FyEeWQ8i;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763419417; a=rsa-sha256;
	cv=none;
	b=YeFhzhiw6KGttE3+aT1uTr0fq18azq2tfM2iyOjn6gOl0U7AKS7QU5Rs01+5/b/Ux3HMqw
	OVhbjw+eXe48ozAWG4NmPwBHB8xBMk4f1cSOt4s5bENX4+NNZMlttmprBeWYDKcihqEbUv
	bGygw5AGgDzEyVCA9bx/p8RJKGni4Ik=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88517605E2;
	Mon, 17 Nov 2025 22:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24759C4CEFB;
	Mon, 17 Nov 2025 22:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763419416;
	bh=fvcx/Gt9WjAEJUY/t8KcGE1aZ2anNZHWj8y8rDypI98=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FyEeWQ8iSZBK+XnCJYC79Ys+cl+vTmK23FjMTSIBT8qxfqwAdGJWPQrUDKKb25F3X
	 9LOCFYq7rd7q0KO1765OIQTvs/NItDf3p96v++AKHzUHor95T0Ma5HfgoXwMW2St7d
	 Ck8Z+BeQg9aiz6mwKaoXhpAMMmJ5dCexanDIw1M8=
Date: Mon, 17 Nov 2025 14:43:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrei
 Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 3/8] mm: implement sticky VMA flags
Message-Id: <20251117144332.d338e8368d59c3ab665db986@linux-foundation.org>
In-Reply-To: <cf58c518-05d0-494f-8fe4-571879834031@lucifer.local>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
	<1ee529ff912f71b3460d0d21bc5b32ca89d63513.1762531708.git.lorenzo.stoakes@oracle.com>
	<cf58c518-05d0-494f-8fe4-571879834031@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CBEE180023
X-Stat-Signature: g8x8y56t89oqzmkfqku3dx8g5guj95sg
X-Rspam-User: 
X-HE-Tag: 1763419416-65919
X-HE-Meta: U2FsdGVkX1/TiOW7Z2FmMV56V08M+Ka83izRCnYtHAEwF1u5xPno3nofVwh+salgHOYXzlGo6HtCrgPKGtJVjZkHdSy5SF/DFThoHXrilu8hmTpl23cMZ96RuOa4cc/aUMNzp0UISUUsf07iwVi5DXkXssj3S+DcAWVvczVAw5NLAkewBCv5uLwXK/dtM3Hbg2RouscGtTAjgBVQ5zlnp8ZzxJLbooKk6gjDnO/o9eqMcImpzWkHdBFgZIv9gkcX1Lot2EuD7HgaCFPxSmKmaJXPweJFDiaL5BXgwGGCuZG0gPQXpglYAQwsJDR80ybmcKdA5BHU2Cct0oAj6KrzpCrP7leCMlZ6O024A+rkKfHm5ZVNs5uw6VS5Qluy3Hqw2f3lUiMJFWFJ1Mmn+dgH/SsdwHJl7YIjsjuIReZM/pYYE27yqWafuwCBBuZsbOTbQFYXBhNfiTWuz3PO10CCBz/+Jy+J9bE1CKURqWj17eCuehhRc6Bm2TYBCXLtI99irNs9EA+E7L+2WMX6QmITwPGQJyCKKxRGJs+DAr413w4UgUrG8GdlPYOkAvUFTlyZuoFlY2dTN7elzTD0m5XjXoBhUuhw6Ihmz8jQ0Vruu53t+Vpzs1e2ZqR/r1m4UKt748hVR/j2zhp1HevLP9nFIo9xCEZWURyXfdJ3RxslBccSqcqeDNGhaaLbqE4lmyFtJggNKYiYAhe15xFxy/YdLGXo4/QG5pvqcnvSP6lOZd15mXLlK8e8653IGxpSCRBS4QlUqKhgpCLmMAbL2Ls3Jmxl8Nf5K0SjCyu2ptLzKawhqhnBizcvNbRdrZ7Mm3L900rmf3lFp+H3QAxD2Uop5UfLUoZmeAIx55uuXIxlkVcR4n6EEBKGn9hBKxIyvuuQYJ5Co2dQevGk4KBf1qK7VOYN6WHoNaTy9zelrUBTyBc2fjViuo1O5rA3xl3RXb1Ewl4IjFO0YskDbELPMn3
 5G1SEB8V
 KfT5ujZVOVrJCsv5Ab+PutKRZVBElaN8pmfLYxsqAwulO0szgjaA/oGjN6zbq0+6ZFy5cTd+0hUDplEALLbM+5AFwvxT5co46a+RPjqeyL3rBpZxYbvnhU4OmmxicpNdkgPAzs60aGnWMGb+I459tibeSB5shwzZPu9tQ687aPHzSsGsZ/5O95AEwSd38KbxYom0hP42mnNJM0PrvHU/ZzCbasT9BKoKczY+PburYwSc0R/axtwbIw+XRmsfWHWzbsr4+cU44KbWrKMunBQ68UM1u3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 20:02:03 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Sorry to be a pain here, and can respin if it's easier, but can we update the
> text of the comments below? As in discussion with Liam off-list we agreed that
> the current wording is rather unclear and we can do a lot better.
> 
> I provide the improved version inline below:

np,

 include/linux/mm.h               |    7 +++----
 tools/testing/vma/vma_internal.h |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-implement-sticky-vma-flags-fix-2
+++ a/include/linux/mm.h
@@ -549,10 +549,9 @@ extern unsigned int kobjsize(const void
  *                pressure on the memory system forcing the kernel to generate
  *                new VMAs when old one could be extended instead.
  *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
--- a/tools/testing/vma/vma_internal.h~mm-implement-sticky-vma-flags-fix-2
+++ a/tools/testing/vma/vma_internal.h
@@ -139,10 +139,9 @@ extern unsigned long dac_mmap_min_addr;
  *                pressure on the memory system forcing the kernel to generate
  *                new VMAs when old one could be extended instead.
  *
- *    VM_STICKY - If one VMA has flags which most be 'sticky', that is ones
- *                which should propagate to all VMAs, but the other does not,
- *                the merge should still proceed with the merge logic applying
- *                sticky flags to the final VMA.
+ *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
+ *                'sticky'. If any sticky flags exist in either VMA, we simply
+ *                set all of them on the merged VMA.
  */
 #define VM_IGNORE_MERGE (VM_SOFTDIRTY | VM_STICKY)
 
_


