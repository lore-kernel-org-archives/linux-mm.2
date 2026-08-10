Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78854C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 20:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC46B008A; Mon, 10 Aug 2026 16:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61D106B008C; Mon, 10 Aug 2026 16:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533176B0092; Mon, 10 Aug 2026 16:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1A66B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:23:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC6001601F2
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:23:39 +0000 (UTC)
X-FDA: 85086485358.01.653EF97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6653580002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 20:23:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QPO+gtNs;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786393418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqOA+3smWlYmWZnKA+ZlQGSHPttzuKCyY9xCjtxixKo=;
	b=UsDa4JQ+f079iWTzNqwX4URM+L/1PLPCyfBkHRe2Y2ohtZXNGNv87Hdce3sbVIF2CcxcSd
	72zWq7PqMlFaeqboUnwuHNtTOFtozEbXT0i1TDhBJWWSc6F/tQYBgxuXAnGnNTaXE0Qnib
	E/rjKv9X6EHbdHy6HVOqwO6h/wI/tRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786393418;
	b=8PMmN/yZfdCeZeMiTJk1AYMtTuPnw5IxkR0vpNKPQj1Yhch6fT/aghUkfFTI1zzV1uiyeI
	rDxbzDWRJ6SQA6MuzkbfDvJS33QgrusfJ8Uae0JCLJ1RGPgT1OlIaIT89wMPBSI4QJ3g2g
	HL0x01n4CPmOpuq8IKwiJ57qpi2UCgc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QPO+gtNs;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AACB741FDF;
	Mon, 10 Aug 2026 20:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9231F000E9;
	Mon, 10 Aug 2026 20:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786393415;
	bh=nqOA+3smWlYmWZnKA+ZlQGSHPttzuKCyY9xCjtxixKo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QPO+gtNsFr3mhwBGxeMw2VpABTVOyrysbpkvdqWcmpGnvPQyOOkxUkdYvxiR2i+Gx
	 S7I2fmr9RncPOQU8Q5pnKg2U5eKlbWiIACs8PCewD65+Z1h43EgCVu5Ya2BitLmULj
	 am4pe5Mf3aHDbEKo6bn4kNMCeYCzRhjiEiZ5BUpM=
Date: Mon, 10 Aug 2026 13:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 e0ffd277b09a7c9f1a436e5f75be37ac490bc59f
Message-Id: <20260810132334.3cf85dc3e9061bc7072759f8@linux-foundation.org>
In-Reply-To: <202608101053.PhnVUM4u-lkp@intel.com>
References: <202608101053.PhnVUM4u-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6653580002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8u3yepkrghuifg9wguo63ax1okyypr6o
X-HE-Tag: 1786393417-991149
X-HE-Meta: U2FsdGVkX1+2IsXMPB8SPVkegIbwybqnxQ7EqHcOyGwbJ3ljcy5Yg7qTtJergj9CDG73fsmisbmTW0RHnLCNoQIA6wvFPqrAQt9Aa6xYG5z0VyTqGvQg0xcmevtB63p2jGPmlNvm4RvShu9ajK5nCKpaQZyp0PJneU0PKwoO8i/njBFzkrPjwM8MFWqFGhUWCQHd31rfExsYEoDNAeqKXyRvQcyKbKLoUsuiU1rDY0tbZzyoO5xRxqaH/j4K2F+F97WHNv6Xja7RkdzKqyTKpP7LiGhwhTZrsYxhCg1MbdJrF/33W04Bb2SOsTeEHqy3/8aGP18qQJMsXOjN4p6+c246Goq10apgXhzr9M9Te/FsXuW2D7SI8XmCCoitxy6YyFGEzNuXTDhxOPzulNy7KoW9JhyMvECJq6XNZAc8KZH5ysOU76cH3FOo4tKFfv0NqkYEyo2nz+6J9ngMELt4ZYtIkEIjFRblC5w+j0N7NmbYZ3GUM9EohxijrzOPKHcv1XmGn6qbR4kVTm781FZs/wdG9vOibfTdJeW+aN4XA9ijsVC6rE11TP3FqQhh6h3QKo3DMjnfTgOFfDbRhDGbtS78UkeWzc074u63gpGYkXMSzncZ5qGOhQYcRkD5CY560RFeBnyWKENd5PuYEzwzmWegajqcMYIbfJVkbQWQS5bDzNBlSToLmNYwTob1mblFVEFrpLYf+8QO1KL7T6B98v9vGTpgotBQw3bvE7VF7dVWc3eYnf8wmAV6FyytX/WYspXReD3T5ChVQYVHB561NCRUlV/Mqkt+ehrtHpP/yiqm5gGF3VJsyj+xAH3pZ1wjT+69YnUERoFyCl40uU/Nbef3W+TBc4wvnXLIa9VswQdu8K/HcI+XfC/t8AAitoEKYgekV6ZbtIdHy7zfwG3B5LMY4uorOyyE8cNkgwXRycSURwQo31hzhO7sdPopHA2XU6MnW7w3Qyexx0BmRFm
 QMbPNwym
 7sqrZgIb53OvkiTSbIuBaqCVYLciGP1/OZar0OxQ7mq+g4YCB9dQ74UBeRN7mS8rZseAMlPxNQYBkvroTNmCK6d0dvoHjJiBrAboZOiSEwiF5Dx9AMydmNGj8aotQuLlXXF6eFOhqwxDQIi4h2pT3iS510D6CY57lO7t8i/Cd8sIPkqK9AyHr4p8QTcEsUq/QtzRXLkfqCpBDPCJWTYHrfa7Y9bgtS0UqhY4vqUx2HTa/Vwx4Uue47CA9rdQNDcFMUfKBhcXWC922evv2Yl/waKkQ/MdygnJ+WJNFXNAS/Ze5CyTFNVSHtBnS2iC9dsCgqr2qMdto2WkJeT1BMnFNERl646c2Z5Q2lik+djoWL1mjIC5la2CkA9qyzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 10:44:13 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: e0ffd277b09a7c9f1a436e5f75be37ac490bc59f  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)
> 
> Warning ids grouped by kconfigs:

Thanks.  I assume this warning was produced by sparse?  The report
doesn't tell us this, and I suggest that it do so.

> recent_errors
> `-- s390-randconfig-r071-20260809
>     `-- mm-hmm.c-hmm_do_fault()-error:we-previously-assumed-hmm_vma_walk-locked-could-be-null-(see-line-)

Caused by

	121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")


Stanislaw, you've previously said that this is a can't-happen, but boy
I'm getting tired of seeing this warning report.  Would the below change
hurt anything?  I can't immediately think of a cost-free way of doing
this.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hmm.c:hmm_do_fault(): suppress sparse warning
Date: Mon Aug 10 01:16:37 PM PDT 2026

mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Stanislav says this can't happen.  Waste a few cycles to make the warning
go away.

Fixes: 121170831228 ("mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap lock-drop support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/202608101053.PhnVUM4u-lkp@intel.com
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hmm.c~mm-hmmc-hmm_do_fault-suppress-sparse-warning
+++ a/mm/hmm.c
@@ -670,7 +670,8 @@ static int hmm_do_fault(struct mm_struct
 		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
 
 		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
-			*hmm_vma_walk->locked = false;
+			if (hmm_vma_walk->locked)	/* needed by sparse */
+				*hmm_vma_walk->locked = false;
 			return HMM_FAULT_UNLOCKED;
 		}
 
_


