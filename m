Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE59CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 16:10:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C118E0005; Tue,  4 Nov 2025 11:10:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBC28E0002; Tue,  4 Nov 2025 11:10:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF23E8E0005; Tue,  4 Nov 2025 11:10:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6D48E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:10:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35889B9CF5
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:10:01 +0000 (UTC)
X-FDA: 84073411002.17.F1673DF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 837A52000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:09:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hgdqyPq0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762272599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=St9wqhmqMcEmT7/OdxpN+99PQ2BTnsOVLJLos+d6yX0=;
	b=fxemTf3lDOJH2neZn8X6AqntoNzP2x/QTBuj/9McSM1HntEN7PE6GMX2FWryHmu2kLRLDu
	cWFiOu+FQvdzS03PIl9hGNCvU7tf6ZjO1tPgXpgLF0sv56olduE0UGgUVDbaYYByuIGmMe
	ljKi25fPAZ+5Lm8c74sPVjtxQgTWs/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762272599; a=rsa-sha256;
	cv=none;
	b=7JqQp4RXzMaASQ5KsDhfa3pY0BL5Ph0ZRnjIcgYZkm08Va2eKYwF5dCY4piiZL9YhJS7mm
	rtY6MUNAx1x/GQfMRcUTft93NhiSAeIZkIXueH/J+dBKx09UwLIq4qaEyDXJCCmp510hGn
	DF+o02xTk+l76egbyhqDl6V74qf5u3M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hgdqyPq0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=St9wqhmqMcEmT7/OdxpN+99PQ2BTnsOVLJLos+d6yX0=; b=hgdqyPq0eJ1cQR91NCrWtxig+W
	iOljKPmAqHQBfTAzrVxZ+v7j9c990icL7TUGUFtQ0TW/XnF6eSBxIf1yW1MznYKmedPHs2P3IvmtL
	bMFSwqrbKbBBjLwuPaMdJkkvHKB68BEIHK6hNHGyCn4UuOqbavIKsgV93/HTJRkSHuGxP4RVFz4n8
	6ULKTRS2/h6mKrRMgzFmPxInE32NAkqa2jXpOgzHZUjS5mw0hyooJKX2nX6Jlr3X7fK9iDU5rGMXV
	jH0BUquq84BsbVOxt1wxRhVn+BZnl/ORLNhtskrJfY/g+GKjfa01q4Gke8R7zwNjnoYk6yLxo1cjl
	lq8368Qw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGJbV-0000000CYux-49xa;
	Tue, 04 Nov 2025 16:09:54 +0000
Date: Tue, 4 Nov 2025 16:09:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>
Subject: Re: [PATCH 1/2] mm: Add vma_start_write_killable()
Message-ID: <aQolUadEhSqoBjM9@casper.infradead.org>
References: <20251103180348.3368668-1-willy@infradead.org>
 <20251103180348.3368668-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103180348.3368668-2-willy@infradead.org>
X-Stat-Signature: hjqi7ih135cpjnzcfqk4fmcttt8ir43c
X-Rspam-User: 
X-Rspamd-Queue-Id: 837A52000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762272598-697045
X-HE-Meta: U2FsdGVkX19xP0iH4ciE0sM29wmXkOI1a2/u6b6JQN39iAfsJ0sqQWYvrGSfSc5OzzAEI2IP1f2ObzAD12iG8HO30BOIj+cWRaUm55QQ+Y2smjDc5D8VZH1Z8lpbYi2/IXC96bn2ATZcKBwr7oBtZWoD1WTPX8MBhqhAhjSfR7hjB/zIKSJNSWY2mDU61EUytxyC3OuZtwkRlbKsDQ5uUG4MDDiJ4SbZxPiWbJOHdKDijAaX4OVeRPMt255OfRc/y4p6r9dDgnBP+UDBkuJEYUPDXWitnQcqnmjYskSxhYPk1CsL46NKG7+HXy8TkTnHZuF6yQe0DgtXxb0vXkxPW1m6JPXgBNq/c+jiVMkdHrloKuDbfAU2BaDYE4h0lHkOy8/g90ll2ssaMFQOJYYGCJoapiP8KMsPqleR2hdt650sErSwVXWDZEgHfI5Y11zbiLDhNkBKWzthJm+249uBYCiAeiAXDl7+FCWxOGqThMbUUArlyOoPltqvVT34eW8sBMqEzBmLo4PKfiUaK61QKeElU0cW4rXABpGOKAx0g9GExhIZ0dphXdPNNcKX3JIb0W9rl24ldzxUm7twEel8qvSPTCtBLGHzncSTOmUdD7fEOxlvUgJA6m9sFKgcNowagsLH7qWGML21dkP55TOoTaKhSMft4x87B88/ifF57urH7ba1r7RZO3aKYriJ83UcrFbsJX5CZj1tKnYQ8qg0IjY6fq6beTobnCOc4K5wOBPvQAb5GqpW1pMBT0jcTC2wRktzM84/atbHT4pJawCXKAyU9NniY95M/Fuv2kV61EQ4cltl+T9YaYvG3F0BEW5caMFtYOWCBR+u4V3NPkJTuYQOlzyQOLBA7AScy+rfYowqZH8Vhfy/jyPK2qjBlIIa6AamWQW90ChkY+7zaKt/+xj/gMxoeaaq/Bme22EQe8VlSx8hjy8IIwEBQzwzeFFDfZ/yKgEH8T5NdEL8K49
 E6rL3gtu
 VfR+RbiqdY2Ukv84ziOCfOATslui6qrxd6LTzZlmlgBlgtIdueYOi64gEzT6ZlFB4paSg9fsh1XsCj+P1/y+29pWM//ns/JS56bx3XY7trAb+SowfPIBt43IIHb5mJlpnJWjIhC36rMwjp60XQOFQnzl4k5nCDTHGHcRdPcj5Ymgg1k9GV3py/vhFVfOA2CkJzDwSk/zGOZZbUOcJDoG3vn1QZV9N15Vw0Rfgmu+YP6D2syBFrChHifdUD+NMprn4qXygOgGg4RSQ5gJucAO5qVhn3doMbbzJ1a0mA+qGPPFzi2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 06:03:45PM +0000, Matthew Wilcox (Oracle) wrote:
> @@ -58,15 +60,17 @@ static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching
>  	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>  	 */
>  	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> -		return false;
> +		return 0;
>  
>  	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> -	rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> +	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> -		   TASK_UNINTERRUPTIBLE);
> +		   state);
> +	if (err)
> +		return err;
>  	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>  
> -	return true;
> +	return 1;

I'll wait a couple more days for review before sending v2, but the fix
for the syzbot issue is:

@@ -66,8 +71,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
        err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
                   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
                   state);
-       if (err)
+       if (err) {
+               rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
                return err;
+       }
        lock_acquired(&vma->vmlock_dep_map, _RET_IP_);

        return 1;


