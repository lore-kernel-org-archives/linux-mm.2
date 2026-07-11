Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC08C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 03:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E356B0005; Fri, 10 Jul 2026 23:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EEA6B0088; Fri, 10 Jul 2026 23:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43E9E6B008A; Fri, 10 Jul 2026 23:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1592B6B0005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:09:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83A891C8CD8
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:09:25 +0000 (UTC)
X-FDA: 84975015090.15.7E994F5
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id B46F920003
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 03:09:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lciooVKE;
	spf=pass (imf13.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783739363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBT/pxhbpviyB1eK4ppjTwsrTkYiVk3Lhi/aEEh6q5s=;
	b=GCO16R5a7eWOzxtMxGlUlbXsfAlj0w2S657eNJiVMzZCtQ5xC2FGEOLsPRsfPPlOXtnFd8
	AG9e5+0GtETbZ/wZgnFsZ/sWtfZpkonmz934jKkAj/W3L5q4MG+GvEmD3iY0ul+j5ft7qO
	zwsRV9NCADlhE0wizZbWSiYpmYsmovc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lciooVKE;
	spf=pass (imf13.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783739363;
	b=HbP/rNk6c822ZbWFXgyaMvw0i0DaW18JV8k9Vh5EybMLrzgfk4c31yKV4UekjbfZR/9A9G
	eWp909J0TMLXCUWAGNsRGK5JFOd8K0FTeOHW0XxyltljwlWw21uyCC78mlfhKMXB93ve8f
	ZN4n3yIMLHTw5ILTbRRM16wxM9bYuts=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-848761b5897so737153b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783739362; x=1784344162; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KBT/pxhbpviyB1eK4ppjTwsrTkYiVk3Lhi/aEEh6q5s=;
        b=lciooVKEUtD06XYHOicFDs75iFfwHs2MbT3wYiPBtv3Notyxm6PAv5gtgOi9/KMapF
         EhETeo3BmOafUkk2rDdCHuRv0IFOEvgwDZ4yWqOdPB73zLAOmDGSpSeqYJpzMOXpH7d5
         ef69RBVUzwQhFLKIHQMiWeSBVqsUGA7e76G1jNTBjmmy+CC+lB7ruavHFCDPbtAX+YP8
         KL8vZUNAjfWNDOjlCAgd27nmZy7OW6ugx5qHUUHHYQo7Pvsan3gv35w4JOivBQtzUQE/
         lYEA4dZEnz6TDlyQfORTCaWb2j9DtOG3LU0U8ag/E1xITOHTxFbb2PCI6Ssq7zEY/IQJ
         SjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783739362; x=1784344162;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KBT/pxhbpviyB1eK4ppjTwsrTkYiVk3Lhi/aEEh6q5s=;
        b=UgEp5+SEloStHjUAuEN0vjK7fA2pHYTRtEP0/l7aVvTY0ctHmSYLjpacaesQUMpQY2
         VYTPLwHGFe4/vInhxKSYba8myRFHcG326dUwznvaVUh2NLAzzXveoRh0moBnOPp3NufV
         Vsa8MKeRAolhPhwHL63WaUO9gfrkdDATIf/zRSfyqC6kdRtRVWDni2fhSp9Y8Y1SdRRj
         Z8z/ZY/l9B8zZVAdgMO8tSfAyn38EhsXS0o8vKBOBHRi3MqoL1lTebw48ap0EuDbyfGA
         tTHFkwKly+TxXWpfi4MaiZT4IketYu6suCsWvWc8Lb6sCjxWnRLBpxk25+vx5sZ+rQFn
         3duQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsjbNUBzTbOAmqldOB85koDPP22agmC6fBEoCYXd04q4k+6yJXdIbxVe+GDsCRsF5mVazyfWJLvQ==@kvack.org
X-Gm-Message-State: AOJu0Yxi0MxS4GmqqT0+876afG74H98i2RS3TaWIAkiGrZJKczQLkDqs
	DSqxz2jh5KPVUyfD3XFiWRBGWPtXjpfnD2hDmnfJNzdKovwegM1/uWUG
X-Gm-Gg: AfdE7cnZljqRWTKaNoB6AcDS/nEjl8ipyYv+lobVfEkMt3VYMdPDFyFDGRAnbEPJGO8
	v+pjgUszx9zfedT8eyMaU56O7hqH/J/EFJpzkhPaV/YkJCwO8sFnK4xHVTj3XVqsuh92dFZHdth
	4y3cIDXsfg1uH4648khHJgc+CENgIh7KQNZcZijF7lntdiR+L699gAlhJkVaAcXvMEUZ+APVBMm
	cXj55egmcSrkpKPdfrDF8kLKt94RWrxY8XX5yReDgqtzbO867hhYFiLMKfW4uNBWhquxIBZ7W4C
	nn0hQYriz16bKhyql948bihhBxLyR3+oHd3LZuxqBPHB80WNP0ApnedyxKgpjVETeVYEbx3IvK/
	9dmtOS7tlHO4ik+xBU8juDWwTCtGgs+BcQoE+EKKmgQjVba96AK4p3OGC2ti7akqod7SaQRYJ9o
	J+TtkMk+vebW4W8NNtU4RyRH42q98zY9LLh/81WLw0iTavqN+woyusUUg=
X-Received: by 2002:a05:6a00:3404:b0:847:9151:3409 with SMTP id d2e1a72fcca58-84889797ad5mr1318139b3a.55.1783739362452;
        Fri, 10 Jul 2026 20:09:22 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6db29d1sm11140358b3a.53.2026.07.10.20.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 20:09:21 -0700 (PDT)
Date: Fri, 10 Jul 2026 20:09:18 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 2/8] mm/hmm: add hmm_range_fault_unlocked_timeout()
 for mmap lock-drop support
Message-ID: <alGz3vywc6W5hvso@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371879503.900500.7148019929226548795.stgit@skinsburskii>
 <20260710151209.157d7c80b03dc56d73b5884a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710151209.157d7c80b03dc56d73b5884a@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B46F920003
X-Stat-Signature: qn641esoxn9aie9rnccaxkgi5ea6iz8t
X-HE-Tag: 1783739363-888037
X-HE-Meta: U2FsdGVkX18i8jqJvhjFzEgMKaCqvbdFSNQZfzwrSgwz+gOUroyERfzdemYCkcHtlYxt81o3vN1Vabm0RcNMjDCV9U23UUwqHiFM55OXvH924m+P6U9IVluIRCmy+hzmXejJhPvDdIEPBnbS0EUzggIiltGQpDaEZZYkZxjDkxBAhrDAsKuherAS6eK1SqQZQvQd8kE4PBD3wa/2qvEnTB0kenaH+oT+NJIaIuLU10LjK29ImfbJQ87zrQ/Fv7Lg9TP9S/z1HyZaS9wImDI40KjFH7R0GnGa9b5xwD+uh5nde/KlTHAAIfa9Zpf2G+6nbq65hAKPviw2dFIxmLlBdxsjTjKZyv3gGoIvSa77MitI623Fg+rn407Ss3aOAWAq5iwDUYwGjpu4xsz67CBf4UHpPYEEAJWKQiumFqgyRq+0s/7o4u1TUm8Y3xh3Xr/axihNgUTVtYpyVjC5zf0ryqcSDQ4H+Br/v79LnBE9+QGxOukWQo2KgnM2NhZsNhIr8h3UiwjkDaZclsIJOuw+QVvxIbP/eaNyw6+nUZdSvrkaVwFK/SZDEyO/0GKueWBaDZcIpMEVXXGhxWDDGE4wtlKDREJOi0zsbcuB92v58IxY+7sEmnktVST2WvMeb1uXN8UxxXeuBDKKVDPIA7J7m2FbjoKbHJZncdWf5VWVR87wC8I54hTjz/CsHciKy8El0DadmjGivqxBu3Wu3+8E34XI5JCRMqkE2EMBPZK5QnfWXw8f57zF8n6kJviKRF4v7SAGJVTEWlN+kSEdinLmLOTMuTH5RCnCYWT3FlJhNlb6hRAU+Mn6VCXstZCeKA7pNXIcm4ifps+UO7PkFTqTQ4WeY9jiTut4316xZVjbzV8+yalwFs57u+ym+GUNbAe7P74Vhy40HDs9RTChZnoVVob3waxbnXR0OEiMIZQDaM7cCwMCABd2dIdFTZsGH1Fut2UGNdUvgymS3WcRteM
 o6HmHcHA
 AyB6WrHnOB7w7JiI03/m0kYij4l/dG/KRnodNV60IMLYIr00F3VMXCgp9/660YSFXMMbqd8I0zdrg+KlItDbKl1hhgdK4xRJ9u2Rotxwi4ik2kA1bAwvMoJC/O+l/ymdg16xmHwZ2HOoCD0zu4/qHD/Gr/5NmZneyAkNrWmY4FeB2NTCXWUbVnCptrdoxjVJJdEJdGpzkaRu+oFulbeGRoxY7jba9Fw4LbLAIqOKcuXBlOYtxQzj5GStVjDtno4w8511dcaRmFPH1i/zkiVJWBQC3NfpM050HeXAnhNLbRKKZtJV55ol0j1ystbiHF+nJSLXjlUcw04aGPooX7mI1YhJxzELwGzVaRdNvejLTJbNZSMNYjTzw09F4S/paLq0meK9VHppNZ7UyomvbalSMdNthoPjeJhy7kq8dHulAPyjCHwtiwhwmkUhGOGpfWs/9IstiXlpYBnEoOExXwjK01AqbyjBFagDRF0JGGxb6Hl/ygPJ42kL327+p+K8347YnNZFwQtr8NAr1kmGikPSh1X0DE9WuxHuIFjmASEgIgRCFqcbTrmtixAD6gFzkSkY/6ehXcYazJYH+LcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:12:09PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 14:26:35 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > hmm_range_fault() requires the caller to hold the mmap read lock for the
> > duration of the call. This is incompatible with mappings whose fault
> > handler may release the mmap lock, notably userfaultfd-managed regions,
> > where handle_mm_fault() can return VM_FAULT_RETRY or VM_FAULT_COMPLETED
> > after dropping the lock. Drivers that need to populate device page tables
> > for such mappings have no way to do so today.
> > 
> > Add hmm_range_fault_unlocked_timeout() for callers that do not need to hold
> > mmap_lock across any work outside the HMM fault itself. The helper takes
> > mmap_read_lock_killable() internally, calls the common HMM fault
> > implementation, and releases the lock before returning if it is still held.
> > The timeout is specified in jiffies; passing 0 retries indefinitely, while
> > a non-zero timeout makes the helper return -EBUSY when the retry budget
> > expires.
> > 
> > When handle_mm_fault() drops mmap_lock, or when the range is invalidated,
> > hmm_range_fault_unlocked_timeout() refreshes range->notifier_seq and
> > retries the walk internally. If the lock was dropped, the retry deadline is
> > also restarted because a lock-dropping fault handler made progress.
> > Ordinary -EBUSY retries keep the existing deadline, preserving the caller's
> > timeout policy for repeated mmu-notifier invalidations.
> > 
> > The caller only needs to perform the usual post-success
> > mmu_interval_read_retry() check while holding its update lock before
> > consuming the pfns. If mmap_lock acquisition is interrupted or a fatal
> > signal is pending during retry handling, -EINTR is returned instead.
> > 
> > The common implementation conditionally sets FAULT_FLAG_ALLOW_RETRY and
> > FAULT_FLAG_KILLABLE only for hmm_range_fault_unlocked_timeout(). The
> > existing hmm_range_fault() path still passes no locked state, does not
> > allow handle_mm_fault() to drop mmap_lock, and remains a thin wrapper
> > preserving the existing API contract for current callers.
> > 
> > The previous refactor that moved page fault handling out of the page-table
> > walk callbacks is what makes this change small. Faults now run after
> > walk_page_range() has unwound, with only mmap_lock held, so dropping it
> > does not interact with the walker's pte spinlock or hugetlb_vma_lock.
> > Hugetlb regions therefore participate in the unlocked path uniformly with
> > PTE- and PMD-level mappings; no special case is required.
> > 
> > Documentation/mm/hmm.rst is updated with a description of the new API and
> > the recommended caller pattern.
> > 
> > ...
> >
> 
> A trivial thing:
> 
> > +int hmm_range_fault_unlocked_timeout(struct hmm_range *range,
> > +				     unsigned long timeout)
> > +{
> > +	struct mm_struct *mm = range->notifier->mm;
> > +	unsigned long deadline = 0;
> > +	bool locked = false;
> 
> This could be local to the do loop and it needn't be initialized.
> 

Unfortunately, it can’t, because its state is mutated in
hmm_range_fault_locked() and the resulting state needs to be preserved
across iterations of the loop as deadline reset depends on it.

Thanks,
Stanislav

> > +	int ret;
> > +
> > +	do {
> > +		if (fatal_signal_pending(current))
> > +			return -EINTR;
> > +
> > +		if (timeout) {
> > +			/*
> > +			 * If the previous fault dropped mmap_lock, then the fault
> > +			 * handler made progress. Restart the retry timeout in that
> > +			 * case, but keep the existing deadline for ordinary -EBUSY
> > +			 * retries.
> > +			 */
> > +			if (!locked)
> > +				deadline = jiffies + timeout;
> > +
> > +			if (time_after(jiffies, deadline))
> > +				return -EBUSY;
> > +		}
> > +
> > +		range->notifier_seq =
> > +			mmu_interval_read_begin(range->notifier);
> > +
> > +		ret = mmap_read_lock_killable(mm);
> > +		if (ret)
> > +			return ret;
> > +
> > +		locked = true;
> > +		ret = hmm_range_fault_locked(range, &locked);
> > +		if (locked)
> > +			mmap_read_unlock(mm);
> > +	} while (ret == -EBUSY);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(hmm_range_fault_unlocked_timeout);
> > +
> 

