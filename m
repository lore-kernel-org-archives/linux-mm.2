Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D71CD4F25
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F556B0005; Tue, 12 May 2026 13:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFB526B008A; Tue, 12 May 2026 13:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2C06B008C; Tue, 12 May 2026 13:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C72AD6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:41:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66FEAC0C66
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:41:59 +0000 (UTC)
X-FDA: 84759485958.08.D5D0C1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B092C0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:41:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9oJ3s7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778607717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujf3UFPsmAB7Nd3Y/nudOBlYWDEwcq3ruBgshHF2MKA=;
	b=S+scwPqmH1yaE+rslNzpG3Ek5EI4hVFL9saixf6zqd6X4mslmSvYq7Hq3yeV7MA0MQEs4x
	GoPWNaux4aYaOXRzSoNAlQC9V43sM/iMZ3lzo171KfzGICkXTjevr9+hcBgJpZu09FV4c7
	Rt8KSb8qYRP5ZNNUz6vScGJbXtXpotU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778607717; a=rsa-sha256;
	cv=none;
	b=2CbaKt6qbEcl8tmE+oRl+OdRZ8IxxRkwvGI6qcmzlV8GdgcnPDgsePuqNEGuvIZjbqIq//
	JxjTjCvxBVwh5s/OSfsotQFS7PjpQno//aWXnTOpddisocnyXdm8A7O17x4finrjQyklNZ
	uXxdzB+qvA2d2f+4hUUgMIqo+YXgtl8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9oJ3s7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9086C4072D;
	Tue, 12 May 2026 17:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8B2C2BCB0;
	Tue, 12 May 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778607716;
	bh=gjIHcTn2SNVbfTdFwDqfeJDol/cMiaN3wAL/qdYHzDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d9oJ3s7+soX7DYUyP0ESJXspaTPr/B47iWffX9FN8OBabt/l9iSOyTpR9uJ9+XaNS
	 IlnC7UL1NcTV73iIbeiayXFZP3AjjaJnWQWjduFuRpElSp6QJmlTtANDaATUIxQiB5
	 xWl1vUW+5u820yiGZaCnwMNgiuTXNYg7Y77csk35pMuVxlBq4F3NBCu5jUT5PQeCYq
	 0nxM2HF9q1cW5tjceh+u7lxbOzzlQ6JcSV8pTf6VJHKI7wFB9/5qmQ0Tw5uAvpDbE2
	 cOraQLUE0qHVrlC/IM9838zgCjXQj00KtdwWOTmeSaXrIrq6CBfbGyXWua3l0J8Xno
	 fCg7HUOF45JKg==
Date: Tue, 12 May 2026 20:41:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 10/14] mm/pagemap: add PAGE_IS_ACCESSED for RWP
 tracking
Message-ID: <agNmWUl-_6HE2yPh@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <c076bf8d482e80512b0b1db0e107ef0c822c5ddf.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c076bf8d482e80512b0b1db0e107ef0c822c5ddf.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B092C0002
X-Stat-Signature: 766wsedk91h3eyd9737fnzo8y45811kf
X-Rspam-User: 
X-HE-Tag: 1778607717-307224
X-HE-Meta: U2FsdGVkX1/txG3YXdn+4Ph9lcfnEQzDVOmONCSKuoOkGGnOBEGsruBSfLXQ74rxEiN9QBKs2fshhYkgWa4QhEGNXXDFS+ssT7LttNlqel29i9v51p2W1rY8ptBEIovE6OhMhmRIBG4M8z44pkTFffNf1R9lIx/cvQZSo/9Kz2nTgH+eL3Zpbg7Op6qP8bniU7yeeUYB1wfAgvAYbQFWNQXuOviw1M4rGCmgK5JDlBLYtVYUtC8WFAXjngC4GM2PQD+2vnuETBAVx+Lfaqo8eLR7R++89lkiiUeb+XUIkskNxGSl6zgyMw3uN1Lws+KRdjukxTiyOoiDLbVI82L9R5PBuhkH9oWI6o4hVXXrBQhbYkukMjb4C78zbA0D1nNeV7j532lj1VBlPYAj+ops/utdoK3QOqyKAXjaILPtL883KR2NICWfu7VHmV/PLMhdzsis4RzimC6A4yLi7EbU5owJ/EoIlmqcqzkLNffUHp4zwjI3vmasJOEVTFZowxv9qwp7pfKKu1KFNWjjJG4ARVRH3rJTNrkcxr9IiPYvdWszvPVVPID2U+Jj/XXdFeO8L6hJ/p5tAg2cpwANUzXz0T8ZyOZ7Pz6Ggo/S0PhpEQn+UCp5KUwWFwEGMfX+o0Y5nteLrTW+W7eoQOlH5SDM0ZjmbJCBa/Y4v4yr/mSX1ZdD+SOcTBfl5oCT3IGQfTKxxaAMcQ9v7nmLIVylOXP3LJCek+BsFmOIqalxFPT+y4kv8FiOaeLTonZkZ2HjXvA3nmNUm6skfVFCklXX8IjghZD42ybVb35zbfltoIhuHDBzcCC48P6gQa6ObOtsFvRjtlbNszP1VCxt4nVhmcNSK7U220gYILcPRuxdHF2WfY4m4fW0ffz3t/M+jqwddb1CveFb3PA9KtCfbtPcvT1GBXsPkSlMs3I7tAvsUsMaaoYOJb41lI7zyCzio3uGPQQCbQjVhVnDM2zkY7jODkY
 XB+eADS2
 pV4AlbtOnHwgPGL/XRq2m2G6bBLMfBMR+K6cUFRP1lOasLPOzZtLWIn7qMULEZeQfAjjYtfioY1VBHGb9CCFb7uekQ19mWL4csG4WjppAgZB3eGDTnf0LSlmr42jFV5XHxwBo9hvy8ZlMJOnse/vSM002eQ0HGxz4BKSvLuKjgWdMkaEMxEx65d9wd643OLNDRpVsAqlj0eZY4JYXaWA8tCjxUO9Ijyl0DkDwDbvMfTrthpOec38ZD0mbfQrJwC6yWjqlinB6eX+u0Rr39z3oYt9vLacho+Zvkkx4DdzLy/VMa6txEzFD2ZeC/sItS0jbBq3FlVSWdOIYyoXcxlvd8rH6oey0FCaHwd33
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:22PM +0100, Kiryl Shutsemau (Meta) wrote:
> PAGEMAP_SCAN already reports PAGE_IS_WRITTEN from the inverted uffd
> PTE bit, targeting the UFFDIO_WRITEPROTECT workflow. UFFDIO_RWPROTECT
> reuses the same PTE bit as a marker for read-write protection, but
> "has been written" and "has been accessed" are distinct semantic
> signals — they happen to share one PTE bit today only because the two
> implementations share infrastructure.
> 
> Give RWP its own pagemap category so the UAPI does not conflate them:
> 
>   PAGE_IS_WRITTEN   reported on VM_UFFD_WP VMAs,  !pte_uffd(pte)
>   PAGE_IS_ACCESSED  reported on VM_UFFD_RWP VMAs, !pte_uffd(pte)
> 
> Both still read the same PTE bit today, but each is scoped to the VMA
> whose registered mode makes the bit meaningful. If a future
> implementation moves RWP to a separate PTE bit, only PAGE_IS_ACCESSED
> switches over.
> 
> This is a UAPI narrowing. Outside VM_UFFD_WP VMAs the uffd bit is
> always clear, so PAGEMAP_SCAN used to flag PAGE_IS_WRITTEN on every
> present PTE there — a meaningless duplicate of PAGE_IS_PRESENT. Now
> PAGE_IS_WRITTEN fires only inside VM_UFFD_WP VMAs.
> 
> pagemap_hugetlb_category() now takes the vma like its PTE/PMD peers.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  Documentation/admin-guide/mm/pagemap.rst | 13 ++++-
>  fs/proc/task_mmu.c                       | 73 ++++++++++++++++++------
>  include/uapi/linux/fs.h                  |  1 +
>  tools/include/uapi/linux/fs.h            |  1 +
>  4 files changed, 67 insertions(+), 21 deletions(-)

-- 
Sincerely yours,
Mike.

