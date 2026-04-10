Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F74CF44842
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450106B0089; Fri, 10 Apr 2026 07:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400846B008A; Fri, 10 Apr 2026 07:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316366B0092; Fri, 10 Apr 2026 07:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB896B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:48:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A34E91B7E58
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:48:20 +0000 (UTC)
X-FDA: 84642473160.03.68824D9
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id AFB6110000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:48:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RxqZGCJ1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775821699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AqLOGr7u2EsVQKGgZ6etRKNa4B02J4pU4jvPoN42Sro=;
	b=A1hAnmrhIv5v7v+4T7qvkk+TucZDFqTIkzAvdQEjPWI4+sVO9LCjrzUnMQpfnkMqrTTFnr
	JUMuPFoqg8kkESTDfBza2m2NoM8N3Vpps/6dIcoZrVeSuetZYSh6KHSb5/qm3RCcIzMH0C
	zMptyTm1GCRFtMNpGcl4M4PaX0XxOHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775821699; a=rsa-sha256;
	cv=none;
	b=g/QsKStx+inH/78IJp2R4YL/+fuYS/EVLY3rFAs4JuSW9IkLF1NhDF3CFSY/rRHN2JsJmN
	ubcLcq/jV51WhYfuHKSISyjCSavgVI5vVtBHZ/lF11D+TRY/VrePX1NeaSf+OF6maH3Os/
	I/LYX6enftRAOU8ABNqT4fCN8Yw+v5Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RxqZGCJ1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775821695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AqLOGr7u2EsVQKGgZ6etRKNa4B02J4pU4jvPoN42Sro=;
	b=RxqZGCJ1wN9svorxpul1HncGWj+1nZ9oxTLx6zY1X3eyB6kcomoWqOGw50cyEq8moEAfs5
	1EQjpmfNsdV+RiNijymP+gL8dirx47NJry9Re1oXYZ+JxgKZ+ktRItfcy5rMw6uwCVbDKG
	QkhSldRhKHV+7XcSvJ4UcWu/WliNd5I=
From: Usama Arif <usama.arif@linux.dev>
To: David Carlier <devnexen@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()
Date: Fri, 10 Apr 2026 04:48:08 -0700
Message-ID: <20260410114809.3592720-1-usama.arif@linux.dev>
In-Reply-To: <20260409120653.290386-1-devnexen@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AFB6110000A
X-Stat-Signature: gnytnpxy16b57rfmsbmciyxkyquutbm6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775821698-107308
X-HE-Meta: U2FsdGVkX18ULlxTPXdMmtOJ9yyYVBXkOCL9BVkL2PljU7gQIMfktjuRz3bpPRU4sA+fQv4ONZzgZMzIexGAa2+Gq6piJNYgUljY5LTPkw6F6I4iB3KGJLfdLRw5bsU6KRt6yVws9Jkr47E0uFYwAok1pDej84r7HWZSNGzuBlT87hxg+o1Z3KP/igHPiNUjMq66ykxY9e2LXAc7t4g1A9iZbs0OF4ypPsMGPA8xfhRCCcOFIKtNttoNbVRVKyeqGszWGTO7WtRt8nEaJBdLXcIucD/+cw146+JQZxH/1d5qHqpMnDhIzkSa99X0Fb780+zkTcq6ldSGqBdbkxUnmSN+20rZMamC7JZoj18xi6y48ZeBhtkPfTAlS2srjEzCZRnyKoh1eTcPgQ3xNMUljcu43/WZ7JLrd552ts+QxQ23s6ldofgiTQH627gc7jNkv3Z7I7BjQGSB3eAuv3ixMiqxF66jwnfeEh2VIJg0q934l9RxI3RmxEkZcagPFzr96NxWIqC6RKVY1qVMZQQmL4s8gemyyy1kbRnNN8DzH2ORZopntg+ea938X9GCvZgQTiEC90/vsToe8mCkNSL7Jz0cmuQLteV0o6YrorfgRWT3LQ8R7umgqEDJcaWy0CQKVCpWQwcOWqpm+ejoI6/IDWja0B+dAfMJzv1iDlwkG5FUEh7ZoJENOChzZuQf0W5lIGAzrUUJlsIf6zt2GIRc7mfT3Xc6Dy3DdTAiWj+s+EUm0r+zdJg47ZMXL+Mc9+HRgfmQC3Di1VngUVVCPd52bruSsKs2N3ZRt+9JZiPy9sOGOsxRNN8NViKGnMR/lHAuu5esEg4YHzaSvE6AzNEgNMDv4go2FLzlhUbReNSFu3iP9zrA6AZFWIQkTAbaP+1cdu4b2XdgIMAjbWSGQTomuLVXrpGAYr0WKqXNPj9lrj/GYYuzIxBoy4vjBJtCh3TCj98YIS0xdYTEUc3fxzN
 NNIIA6z+
 XV75l7U2EbPFa7elO2yZmhx5J5SyLynSaxwvBxYWFAAC4XRr6AzVRQSISq9VsdBhmTYv5AtfBNDIJOzHzrweI1IX0csXV0LtOkY+FQq4nOgLhBZfxXjfipkrABUwikvmYnqHmiahVhU1uBqULGe6MKKc2CcmEKWLL85yTVUWrMZeJqzZfXRiy6GI6bV/3e/L+X7VgODxEDBAOy7sxRXHyy5yES/Bs5TWAyHpmHwO7fW3QAdc8s+vZQp2G0cw4PLzkRtyUbtqnl2T7q+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Apr 2026 13:06:53 +0100 David Carlier <devnexen@gmail.com> wrote:

> mfill_copy_folio_retry() drops mmap_lock for the copy_from_user() call.
> During this window, the VMA can be replaced with a different type (e.g.
> hugetlb), making the caller's ops pointer stale. Subsequent use of the
> stale ops can lead to incorrect folio handling or a kernel crash.
> 
> Pass the caller's ops into mfill_copy_folio_retry() and compare against
> the current vma_uffd_ops() after re-acquiring the lock. Return -EAGAIN
> if they differ so the operation can be retried.
> 
> Fixes: 59da5c32ffa3 ("userfaultfd: mfill_atomic(): remove retry logic")
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  mm/userfaultfd.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 481ec7eb4442..214923a411c1 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -443,7 +443,9 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
>  	return ret;
>  }
>  
> -static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio)
> +static int mfill_copy_folio_retry(struct mfill_state *state,
> +				  const struct vm_uffd_ops *ops,
> +				  struct folio *folio)
>  {
>  	unsigned long src_addr = state->src_addr;
>  	void *kaddr;
> @@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * The VMA type may have changed while the lock was dropped
> +	 * (e.g. replaced with a hugetlb mapping), making the caller's
> +	 * ops pointer stale.
> +	 */
> +	if (vma_uffd_ops(state->vma) != ops)
> +		return -EAGAIN;
> +

hmm I am not sure if this is correct for shmem MAP_PRIVATE.

mfill_atomic_pte_copy() overrides ops to &anon_uffd_ops for MAP_PRIVATE
mappings:

    if (!(state->vma->vm_flags & VM_SHARED))
        ops = &anon_uffd_ops;

This overridden ops pointer propagates through __mfill_atomic_pte() into
mfill_copy_folio_retry().  But the new check here calls vma_uffd_ops()
which returns the original file-backed ops (e.g. &shmem_uffd_ops).
For shmem MAP_PRIVATE VMAs, the comparison always fails even when
the VMA type has not changed.

Maybe save the original (non-overridden) ops before the MAP_PRIVATE override
and compare against that?

