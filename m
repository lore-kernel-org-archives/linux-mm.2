Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F4D4C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D53B6B0095; Mon, 24 Aug 2026 04:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD236B009B; Mon, 24 Aug 2026 04:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9C36B009D; Mon, 24 Aug 2026 04:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF026B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:17:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFDF51A0491
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:17:15 +0000 (UTC)
X-FDA: 85135458030.22.B4036E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F7B920003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:17:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qpl6pTLo;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787559434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXaDWANMBlI65kh+v9rkRtQjLvm/PKZVB63CiqD6Ees=;
	b=eXZ+lxvIcnxhnQs5wG+/YIaziFfIfCYyfYZ1NdQHpJZmHITyt1ydRP0KlHQb4A/XsmCMsT
	juH1nMiYzavvZ0fgcj7R3tk5mu/TxoQ4SDq91jS0DO4xAOZd7w8ySSHL87OAmvnur9/41O
	wwxjBW4r66gZTKZ5LYYX62pI0tY5UcA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qpl6pTLo;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787559434;
	b=PUIZ9IdPl8GKHmuyRpBp2Om06v1eeV+zuVGSPZl/F4lLL0tXrYVGe5xMecGaypqCIidl6d
	npfLimQbl5bPjR6MKFeCQ4kVVbzpcp2z7DE9NE1tzo/ahDGg+FiHensGzwyVdRKoYOkcOf
	a4prlZM4l3kt1171VyRSheNN1tpsWFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF294600CB;
	Mon, 24 Aug 2026 08:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F411F000E9;
	Mon, 24 Aug 2026 08:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787559433;
	bh=IXaDWANMBlI65kh+v9rkRtQjLvm/PKZVB63CiqD6Ees=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qpl6pTLoaAeBpcbEKuwh7r8MjAtDrlHX9jbAvcFpcR3CrHgdYxXx4sNdOyT+5UBKY
	 hwZq5M/8DVldhkxcUcUBBVJpFFJx65vumAzWROkhZFaJiuN/Go9Oo5qBngNafk2Hnz
	 4Kxq6N+gG+DKLwsJ0rRHEZidN7GEYCsTMgChe8YBhRjImyKcBI3UrAtavVAVigyJLv
	 z676QZZTMwHGh3tA/ERm62yiT+TLykLWSMuKPn3ZFlO4phL6vWjYq5HA7PXoJyoZ/A
	 GP89f/3ADUV4wdxx07Q2m2351EcJIaNzyIUdQOg2KcUhJ+DF4PThf+Jgvs99hwVs8n
	 TfuPMAbNrQQ5Q==
Date: Mon, 24 Aug 2026 11:17:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org,
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
	hughd@google.com, jannh@google.com, jgg@ziepe.ca,
	jhubbard@nvidia.com, corbet@lwn.net, liam@infradead.org,
	ljs@kernel.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
	mhocko@suse.com, muchun.song@linux.dev, nico.pache@linux.dev,
	osalvador@suse.de, pfalcato@suse.de, peterx@redhat.com,
	ryan.roberts@arm.com, shakeel.butt@linux.dev,
	skhan@linuxfoundation.org, rostedt@goodmis.org, surenb@google.com,
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <aov9_DIHLHynm7tN@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <20260824071126.41979-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824071126.41979-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F7B920003
X-Stat-Signature: ocbcp48khmd5z8zdwnxzeeuwcqygbx8f
X-Rspam-User: 
X-HE-Tag: 1787559434-463304
X-HE-Meta: U2FsdGVkX1/WgKyCWoMmtwNlfSwYGIFCYeYfCctnb6qNt1oag46OdDekmyC2lCBUxDHf+2mhEXGHdmPZJO6jaxIbiSuqTJd08cQwiQkXo89Rhx44m4teznYMhaiz6TkNNhC1hp6b5eABWCF07k7UsxnX9de9lyHo/57natFADIGRHWJBkdchs3QH9Jylciosau6wefS2UYhDMXPzW9MBJLdnNZxW4F0RENCHGb3CI63lWADHgCmcyZcVttrrLzgiNqU0wGsK7XZ5yUH5kzlmF+XP/6u7SbAHg+n9DzcoC0JgchZ3D8xW12ULliWHVI/s9lLMtvRYrLnhNcfBd3Tc7xPk7iT8Qt9it04XcqiTYln8USAdFEF6bho/197rHAsi7xuDMWX+zCCwMjnpyyl1/D9DmKLyzfSGy2H3Zsn4l+1N03uUkMeeHEzc37TKUZtKYYaA+kbf8OM8taFkvFTaD7tlX/BC+jIHl6JzUFhY/LtIHGKg43gLsoPHmnipEZan9KXVqWzP0Gc+0zF5udtsqH8wFiRwhzF5uDWXeH7Q6yxebHBpbk5IW5ASOw5ccuMnmz7afcDBPLXkZ7Kq+2l4nO4aQcXhGcjsrxIhkqCZEBRY0WZkdRYhYKSVUlEdhpETOyriiNptFMJphtIxoKqR78SrTfbveu6jUgDVTgez1PiuL8IqAMIGfVcJFVgBSwFwGpBr5uk3nng3F5XaQhmm1FJVzx++tj7Fr0cFNGrsSJyzMZxQlI10JBlmP1NDYTd17EglDbQKSueaLv11ChQngciJC4c80HUb8l52wziXwt14Hp67Y4Y75WwdaRkZ6EAOZJRV842wL/8L4hBADah93JlVi32gaUtXsfcArrpP+eC6S++8LX/S485PweEI/3oV1u3U+b9NSAkrWAb+BVBWYPs0ELG8aABZyV7TSPQApvifP4NGZ6qSy923L988tdiGotRzlLf3lsn1kjdNqyV
 fkBMbNOs
 +o8kO/PEwaYdX6uDMyMQga5Jhhib7bEk0Cg2ED7IcRg2j6h1nGU+EIg8b4ApgoAXgkHXvi6KaUpiyXa3dJFAH4hDepp43OLhuTqCUtQI9aFoQnAQfc13ujTtCiVXGriXM3qOSya3zNIkBKKYQWH76fXZAw8tNjIwGk5HR6WT1HIXkvSq+w01J/JUw+sJsYb/zfE1GPeXkTVA/WlXykWin3On8MGVgTEwYFTUBV+UOmUaWsEkEh2fP1EZj4g3MnWiZX26q3BlxJwjdOo+yHgNBSlwij1oh1hYzvDM7jgDIfY+gEtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance, 

On Mon, Aug 24, 2026 at 03:11:26PM +0800, Lance Yang wrote:
> 
> On Sun, Aug 23, 2026 at 03:17:43PM +0300, Mike Rapoport (Microsoft) wrote:
> [...]
> >diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> >index 83587d34b189..193f6e65d875 100644
> >--- a/mm/userfaultfd.c
> >+++ b/mm/userfaultfd.c
> >@@ -50,10 +50,10 @@ struct mfill_state {
> > 	pmd_t *pmd;
> > };
> > 
> >-static bool anon_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> >+static bool anon_can_userfault(struct vm_area_struct *vma, unsigned int mode)
> > {
> > 	/* anonymous memory does not support MINOR mode */
> >-	if (vm_flags & VM_UFFD_MINOR)
> >+	if (mode & UFFD_MODE_MINOR)
> > 		return false;
> > 	return true;
> > }
> >@@ -462,7 +462,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
> > }
> > 
> > #define MFILL_RETRY_STATE_VMA_FLAGS \
> >-	append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
> >+	append_vma_flags(VMA_UFFD, VMA_SHARED_BIT)
> 
> Looks like this drops registration mode from the retry snapshot. Assume a
> shared shmem VMA is registered for MISSING and COPY reaches
> mfill_copy_folio_retry(). While locks are dropped, the same userfaultfd|
> can re-register the range for MINOR. VMA_UFFD, VM_SHARED, ops, file and
> pgoff all stay unchanged, so the old COPY can continue instead of
> returning -EAGAIN ... no?

Good catch, thanks!
 
> Maybe something like this?

I prefer to add mode to the retry_state:

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 193f6e65d875..a0377f7ecc69 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -471,6 +471,7 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
  */
 struct mfill_retry_state {
 	const struct vm_uffd_ops *ops;
+	unsigned long mode;
 	struct file *file;
 	vma_flags_t flags;
 	pgoff_t pgoff;
@@ -482,6 +483,7 @@ static void mfill_retry_state_save(struct mfill_retry_state *s,
 	s->flags = vma_flags_and_mask(&vma->flags, MFILL_RETRY_STATE_VMA_FLAGS);
 	s->ops = vma_uffd_ops(vma);
 	s->pgoff = vma_start_pgoff(vma);
+	s->mode = uffd_mode(vma);
 
 	if (vma->vm_file)
 		s->file = get_file(vma->vm_file);
@@ -493,8 +495,9 @@ static bool mfill_retry_state_changed(struct mfill_retry_state *state,
 	vma_flags_t flags = vma_flags_and_mask(&vma->flags,
 					       MFILL_RETRY_STATE_VMA_FLAGS);
 
-	/* Have any UFFD flags (missing, WP, minor) changed? */
-	if (!vma_flags_same_pair(&state->flags, &flags))
+	/* UFFD registration mode or VMA sharing changed */
+	if (!vma_flags_same_pair(&state->flags, &flags) ||
+	    s->mode != uffd_mode(vma))
 		return true;
 
 	/* VMA type or effective uffd_ops changed while the lock was dropped */
 
> Cheers, Lance

-- 
Sincerely yours,
Mike.

