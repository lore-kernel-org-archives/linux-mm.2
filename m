Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F6E606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGQkgawf
Received: by kanga.kvack.org (Postfix)
	id CCF2B6B05BC; Thu, 26 Nov 2026 16:19:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58886B05BD; Thu, 26 Nov 2026 16:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA086B05BE; Thu, 26 Nov 2026 16:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744B56B05BC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:19:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D856B80122
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:13 +0000 (UTC)
X-FDA: 85478535786.28.0B63D71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 19DB3C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:19:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGQkgawf;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727952;
	b=Ztesfu16ab/WFqasPCJdJifx4D9hBFGrHDcy+2PhAwilHcSKWeM9Liiyv/pW5wL1F1teu/
	eae9RyUyJXMS2KGW/wPTmeoAp4b/QDxFs70zazzlu7YoW45YP4LclAIkwwH9zqmLqtXH3F
	Spn0OQM7+btBlKZjglFQ53jjZnww88c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oicFZg3PZAtEvtRcxaG/6RIrfDc601vXmAq3DDYC6X0=;
	b=0wAoz28B6DhDIELC4+IUKX4uWHbX9mpA13oslJwEx7Wwzhv5aHiGvFJQJLm6ZhsoG2mxbC
	FjErw/RNOsUiXmnK8gybNAkpu3/QFkCz2SGSzFQ/GYFHTOxQnW2VHTjjQYGgxZi0OKZz5+
	ZMuPa47mWcZKuHR2WucLGoDAZbPno/A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGQkgawf;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE1DE61379;
	Thu, 26 Nov 2026 21:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B491F00923;
	Thu, 26 Nov 2026 21:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727951;
	bh=oicFZg3PZAtEvtRcxaG/6RIrfDc601vXmAq3DDYC6X0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NGQkgawf7OepBD0bNaeywxqe0J2xEr/mGqcfU+Erk9Yq9kaLnkFXwcNCqaMuq5EHE
	 KnmLa6t8gTrul0F4oy/ztYqMqlTk28l55qxZGZkWU0J5NV26wfD+BxchFDC616Hp6H
	 B09YMNNZ7iInObuz83d2e17bBARsCo+Jn4auL7ve6KptHUREzWFypQB4Q1NiScRIOs
	 FE5cjiPr/Ki9n75C9Bv1vWEPtc3Z0b4doPy1fuCHeCYujS92k2TdTVFy1+JU3t57+k
	 STDrCIsS5ENo+81hY+aWEWA8W9J6Ny4yBSHTx7rtaiXAZlGMrSeOBbzBg54/YpPY6v
	 LDRr6B0oQgYrg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 26 Nov 2026 22:18:39 +0100
Subject: [PATCH net v2 3/4] net: skbuff: limit folio refcount when splicing
 pages into skbs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-skb_refcount_overflow-v2-3-a6f600a5634a@kernel.org>
References: <20261126-skb_refcount_overflow-v2-0-a6f600a5634a@kernel.org>
In-Reply-To: <20261126-skb_refcount_overflow-v2-0-a6f600a5634a@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Stanislav Fomichev <sdf.kernel@gmail.com>, 
 Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>, 
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Rik van Riel <riel@surriel.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2698; i=david@kernel.org;
 h=from:subject:message-id; bh=k5M7OtcbHAW/WJI8bXuPKFdUy5X+jLqVEyvsPvol7tc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI5Fpl9/e0a9GRvr3OaGaPhr7TpQc1R8VtyLX4+3G90U
 +bljXnmHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExk52dGhg1XzvhcDfu24Os5
 d98HD4tCiuUuz5i3unCt7KeG45uyHvAy/BVdWXj9dH22f+9S94X2/qX/+bLiPf6vD9oZMP2kTeY
 PFV4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19DB3C0003
X-Rspam-User:
X-Stat-Signature: xoko9cjbq43p9bffsrhqqk66zc9unf51
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795727951-314836
X-HE-Meta: U2FsdGVkX1+cP6FdgaXdmwmFr6MGX0ctSxhJWjFfHvwqzclOqcbu2ajC8qMVFXONglvcRk66ZQIulxBzg99KpxuOWT8z5fj118BSpMjqUDXiov/ch27aj6Q0J+b2AJ34/OGCt9FxDxt3X9XSK5zcbMtlglXDkC3hQqNjvLt9TnvC2wRm7w4udMIhlvZvwpDTtG1F5Y+xbkrig1w0xzZpTvLn+Vy80haJX8syE/AjgaUtBqaluaNhl00wgSr0f5vNbU5Hya4Etf7UFEUCcr+hfdWViPFnUw+u3PyJwrqBR/c7M8YKvd0MsXj1ASZm3vAcWhtohW0eVTVlvkFz3gTOIO0q9JnQxygzLXv5ZWhPYpju5KVFyBDxy5naIWvK8Rql4i80ElMWXhLFnZVOCA+N7Hr1OMUj6E2t4lF9TQ0oICm2HAxm5ZyKFuR/OsdlLGiNaFAA3gBtd58h69fMOHjprml8RFfVDJqYuR6lTNIawEF+1FNOyX0YCU+Mk7DXFsUIKQSCYHPhobRLjen/Iiz9jTp6MrUin1Pa6qsR8pvWpON8hyk4qyjrnhiB5VQR2DhEa6DqGlzDKB9HdJl1eC3WK+oq5VijQU4L041LN77GOkoT1mDzPayKI2C2UpLyj8HUT0+ClUL/K7+p0fI/78+BJoK0nSnBamQcuLjTwcl0Pw7T5+Pik5ptrN7rFxJxTL+pHPRu777d1imQ6oIkWtXajse69gUsZrjBRclXBLbz9YIJjBhPGvMykkpqzKtpwp+0p7WQx0rn7kBgAgNDdORPs90FQYkmCZCFfZVLGFSXDN9UsKEsrY4YMPJFGA5i8m+kLcoG+Gq11xbna+iRr5sBe3sP8fmcqDY8v2tZoOEu3JkfRVQpqphTTeI4WxUAZtXFBSjO7SXmBGmseJuIVN4UIE/tKVvuqRza+XCfp4W2FQsjxayhTbGAKAzxCqnRj012NzI9MjZkT8JvbEdq0zq
 mWfrKNST
 68WI2WoYetIz5/nwr3vEXI6KaEsKKsSuakHadk+Yvl73VddMpUJJfq4NyQJJenQKS+vO3LLQ7KF7L237e1opMsOxVc3q7FXR8vjE0YFsNYkBc1/YWzUCb4xFTyyMwJ4CTkNHNK8VWsY1BL0bMVcLT98bsZGcTNi45YdhL1O6lPAEuhL83bpkU3/rR+X7mJrS+5iBYBDCrIaD8SqTtXrJkxMR/YgPYBgj45iOYmR3oKfJqmjkOLB23AM2qhekD54ouAwW0+WUIh+6V3xR509SiUaTdZkdp33wbRwTyptgqrJK/WewMwPU8XqY290zh/UXC20lPbhCAWG9d//B2ALNjlVtFa+F0y8LjQOTYaaYOXstKRX9ozIzcs1q3kfFRuMuqaYRU0ziAPjj+QyzvabO4ESvzKcwVfl3b3YW6gONdT6gUbw63sYwm2T2O7jO3uVXwr33IJmx9o81hrpvXA8jyRzws6HB588byjBrSAlxXo8FsgaQMX7pEjhYqr4HiD8HIaDWzxKKuLnBRZSWIa97u6kbSnrEAZXmzfJuIV1fExYByc7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Various networking features use MSG_SPLICE_PAGES to add pages to skbs,
whereby skb_append_pagefrags() takes a page reference for each fragment it
adds. Pages spliced from pipes were already checked when entering the
pipe, but in-kernel users like sunrpc pass pagecache pages directly. This
allows for exceeding folio refcount limits.

This is not specific to large pagecache folios, but with them it is a
lot easier to reach the refcount limit, as page table mappings can cheaply
create many references.

Let's use try_get_page() in skb_append_pagefrags() and fail with -EFAULT.
Don't use -EMSGSIZE, as TCP would just retry with a new skb. The only
caller, skb_splice_from_iter(), handles that.

For nfsd, such a failure while sending a reply tears down the
connection. That can only happen if someone pushed the refcount of an
exported folio close to the limit, so it's not relevant in practice;
nfsd could handle that more gracefully in the future.

Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Acked-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 net/core/skbuff.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6da51ad8fd440..957335bcc5961 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4714,8 +4714,13 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 	if (skb_can_coalesce(skb, i, page, offset)) {
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
+		/*
+		 * Don't use -EMSGSIZE, as callers would just retry with a new
+		 * skb.
+		 */
+		if (!try_get_page(page))
+			return -EFAULT;
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
 	} else {
 		return -EMSGSIZE;
@@ -7613,8 +7618,9 @@ static void skb_splice_csum_page(struct sk_buff *skb, struct page *page,
  * possible, copying them to fragments if not possible (such as if they're slab
  * pages).
  *
- * Returns the amount of data spliced/copied or -EMSGSIZE if there's
- * insufficient space in the buffer to transfer anything.
+ * Returns the amount of data spliced/copied, -EMSGSIZE if there's
+ * insufficient space in the buffer to transfer anything, or -EFAULT if we
+ * could not take a page reference.
  */
 ssize_t skb_splice_from_iter(struct sk_buff *skb, struct iov_iter *iter,
 			     ssize_t maxsize)

-- 
2.56.1


