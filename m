Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAD96CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D910E6B008A; Thu,  8 Oct 2026 11:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41636B008C; Thu,  8 Oct 2026 11:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D686B0092; Thu,  8 Oct 2026 11:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1F546B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:31:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14DFB12019B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:31:32 +0000 (UTC)
X-FDA: 85299848424.06.F1F6177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3827240005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:31:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=notCj0oY;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791473490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C8aurPJzK/wJUnjdRt/POJZVmCHvh4rqZatlItZkIw=;
	b=HrpvDV0g499B1gwDVFcfh2WfbnOHYMShLdcfTgiAc/0SBXe/GvhO+/xtjR0eJLVzoFg3ea
	dbD+VL2/h32nCw9bE2NN2G3aDyaW291/vli9TtdXQsOK6vr5t3SGZWy+CQjSu5940Dvv3P
	uyzd9bLDzgk7yIkROqCxXK9h7z+v6Mk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791473490;
	b=0vjnbEggmHGuJHRGjEw3HPXXvs7e+cc8zLeHAz6XbinNMNXwsf+o2Cz3sTHCO6CBi+QnJH
	N5YlAqWExyibiEx5EKEd6Oy3vOYi3yP6s57rsz6SJa9xZqRL7xXf2Ob3S2xwpYoZN6mvEQ
	Z0x+U0axc9in89l7/GK0n/B+aEQsLK0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=notCj0oY;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E28C43DC9;
	Thu,  8 Oct 2026 15:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C501F000FF;
	Thu,  8 Oct 2026 15:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791473488;
	bh=1C8aurPJzK/wJUnjdRt/POJZVmCHvh4rqZatlItZkIw=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=notCj0oYOmJTZdKJ1nQwQDZzte5321kXLZnZgmSnB8CCKK4MLhVBq3f7b7fo4KfWl
	 e0pzoOLjGssbkrTRqAfMg032MTqcuGRkIjxMcF8DRaD4Lnl7lesVWIicUdcRQrpIlx
	 XEEpb3ejC4rgB8SYVtXxji8IGLxk/RcbLZK8bhQM=
Date: Thu, 8 Oct 2026 08:31:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>, Ayush Ranjan <ayushr@modal.com>, Pedro Falcato
 <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, Matthew Wilcox
 <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, David
 Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-Id: <20261008083127.0305bac995e8b84c67e46bbb@linux-foundation.org>
In-Reply-To: <20261008082304.bc6f4bd6c80fe6432abd4fc5@linux-foundation.org>
References: <20260924061708.1645968-1-ayushr@modal.com>
	<arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
	<20260925053027.1998394-1-ayushr@modal.com>
	<20260925065013.3682431-1-ayushr@modal.com>
	<20261003033107.1488699-1-ayushr@modal.com>
	<20261004222831.bdd648a2b406f02747dd9e40@linux-foundation.org>
	<fyswoh7wpxzlbnjjanggjd2jz6yispmeirhwjl3wzi57nacddb@bjkb6kxyfcal>
	<20261008082304.bc6f4bd6c80fe6432abd4fc5@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3827240005
X-Stat-Signature: wich8e3xhrta8fxhjtjyeeqwjprhmt3p
X-HE-Tag: 1791473490-725469
X-HE-Meta: U2FsdGVkX18mBTackj+065z4u2OUhNFglUv7rW4F1dpeS7j6w5ig39RmrBgsGx1zOOyBxRmH/MGLLg86oYPFB2JkYYU2x5TckwlaiEYaUklVarb8AE0Zh3gDKCr9kTKHU7Kk+wfhiAQacnB4x8moSDs03+uHwDMhJCwcp4CyWu7d7A1dlhPB1pmISw6LIfL1n8torvK2H493AAg/I9ykhY02akUgGL1Ce8cOJY82T9Ry8Ju6lRJ6ay5XecUxANPkp/bj6Mi6OBQJw1OF4jKM8lg1dYLRf0ec2EL1s+r58kE/7nZ4esGN38ja+Tv+Wbrzd6C5YNBqoIPwy2sVcLEgjYnhbuOj7MC1zpb5ZM3UE52O3LbFrq6qB8ehQBGphBDhmDr4Tc5OH40pf9kuM4jWbbQAuI4ZyVGBKfH0gwbwIRzj6YfkX2ULjv0gJizwtghdqEiaiWWzWwFgO3tlbfAMZ97loq/eNjvmv9/Fd2iol2t6FXfA5ZesWR1/ICoY0k7ZrJNpqrvdQENpF1nWKLJ1CaHD3Rzkt8m+TRXv0IauyypkmEvcekRCowHKAihL8Bik5UHO76V/aPNnbnPjiEyuJClD7ON84KBc2PlCl2THD31/rkkow89j/gmIvQsHxOmAAg/iY22fYphMMFkygCfPR618gAHQCn3TA5Htdisl4jAfZkNxXnJieG0rG/HDkXLwhTp/IzclP+zviK2g3fLUgPRnhNIdcPuOeeiQqBzBxayYX0WsfCMcj1zQygaCz2BhZPjx2JAW/Tx56KR0UeVhhG2sj1nuQf0bzDNuPN3CXyWx+6ZsBimQh1Jf4rKwn1wVOhfVyT2iXFSAA9PUjl0gRUdRbe2o+ZJnXi9qlUwTnlEk3I+IQN4YOInFm1yFrizvFw+/XvmYsQxgoUYY3v0NqKnV/x4gvMxmrkMrw2livao+uio90LTVJtNYHxEE5Bt0Dh+R1f4TejRdent2xG9
 s2/72nGl
 LmRQiR1vdxstnSgVPEthB0inzQZBU31doQTuB5JaS78eDDlDvflQt8lHaJQuQK98m7UdEUuAC14hW3xqeMthyvKmn5BI1hhC8ElZepjYg5eoc1IgXPodK+Fstz/ezGB0rzB2owHHUOXAKrjoxwiYLmdiME3CY9MFtqfB4riNzEUuvqSi3qPaCg4WG3jjrTDQe4wcA2RoqCiq9d13W40HvAr71YUkmHXKSCVzUG4SWbsj4uHlZ4HuFEmXAW4fxNFmzxwt9J6jbH3P5GYFmyv63IlSeNc+Qd+Anp7oyau7wv6om0Gk+c+M40omBEUx4gBkyZL0MFxuyc3wNWJ5YTR49srYwZeQIixxtjv95XaVMa3YEn3SIku8r38pC3oiIrTDNsRMtz45nxM3leH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 8 Oct 2026 08:23:04 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> A useful next step would be to instrument truncate_cleanup_folio(), e.g. warn
> immediately after unmap_mapping_folio() if folio_mapped() is still true.
> That should distinguish "unmap failed to remove an existing mapping" from
> "some path installed a new mapping afterwards", and narrow this down
> considerably.

does this seem useful?  If so I can add it to mm-new/linux-next for a
while.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/truncate: catch shmem folios still mapped after unmap
Date: Thu Oct  8 08:29:04 AM PDT 2026

Instrument truncate_cleanup_folio() to determine where the shmem "still
mapped when deleted" state is introduced.

truncate_inode_folio() calls truncate_cleanup_folio() under the folio
lock, and truncate_cleanup_folio() calls unmap_mapping_folio() before
filemap_remove_folio().  If a shmem folio is still mapped immediately
after that unmap, then the unmap itself failed to remove all mappings (or
a path outside the folio-lock serialization installed one concurrently).

If this warning does not fire but the later "still mapped when deleted"
warning still does, the mapping must have appeared after this point.  That
distinguishes the two cases without otherwise changing truncate behavior.

Limit the diagnostic to shmem and dump the folio on the first occurrence.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/truncate.c~shmem-truncate-unmap-debug
+++ a/mm/truncate.c
@@ -156,6 +156,16 @@ static void truncate_cleanup_folio(struc
 	if (folio_mapped(folio))
 		unmap_mapping_folio(folio);
 
+	/*
+	 * Pin down where the shmem "still mapped when deleted" state appears:
+	 * if the folio is clear here but mapped at removal, something installed
+	 * a mapping after cleanup rather than surviving unmap_mapping_folio().
+	 */
+	if (shmem_mapping(folio->mapping) &&
+	    WARN_ON_ONCE(folio_mapped(folio)))
+		dump_page(&folio->page,
+			  "shmem folio still mapped after unmap_mapping_folio");
+
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, 0, folio_size(folio));
 
_


