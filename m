Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB92FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF7E6B008A; Wed, 29 Apr 2026 17:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E96E56B008C; Wed, 29 Apr 2026 17:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4896B0092; Wed, 29 Apr 2026 17:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D13426B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:42:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 776E1A03FF
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:42:22 +0000 (UTC)
X-FDA: 84712917324.30.DD7E5C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D56E0180011
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:42:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPkh9jZz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777498940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU5qr+v03XqF4jCkEPmUWrxlrGQhJ2VSYuW2zeDulsM=;
	b=UldyKd6LulvyUmvWz5VerxfLrRUlZyhlhwzmmP4s03lqzevRIAuLCnqtkNCesCXS/29Cme
	ujD3d5egT76fkmo3biBUfjE0fxA0I7OjZkbbL69yIXYKbs3uu11v3fS6fc36T0OZ9H6VsE
	kBs06Mh6LA36ONnIU66z9BH/mWf9PKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777498940; a=rsa-sha256;
	cv=none;
	b=ravT1dw5SHcSP4MUMlnH36rfIUFo8/qNDNi5TtwuGfhlHLnu7hoZFeizp+2SLnKh9EednV
	IHK6Erx8BBolRtRZeuWJrUoHPjNDTuvGutJYStwUpniTuph8hgVsAx8ZHRSaAAWkXXj6sb
	tCfGlRWvJMsoLMAKPgT3Qa4X9BFv6DY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TPkh9jZz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AA2B6015B;
	Wed, 29 Apr 2026 21:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9DEC19425;
	Wed, 29 Apr 2026 21:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777498940;
	bh=LwKwakj8JQvdi7CWqQLtK7O2+mUpeZJ75DrDVytdbgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPkh9jZzNQbVrGSgR6g2dF81CFcvOzt6d+e90Xk/K1vn3KaTTIicc6YJUE2l8WLJg
	 +Xc3OhZb/HMJ3jffKNflV/PT41X2pMCmNb961jMj+xjDjyC9AzsFl3BjQ1nsbWDguW
	 6Fr9WWBb1HFu95hUHGGQ59aOutaXJD9f/5a0uWMiWoa50KBa6xnzp46Bq7ZMm8qB4H
	 wMGPqzXBOi9ZbK0VDfzYb0+j5/xuu9KL4+zpD94sDF53kyi4JTe0h2wAl43SmTWFTn
	 CPSnYwMRYUs1Dfp0kDuPJJRZuvyS01KY34w7wAQYtEW0wuExvSTdLGz3SktGN+kJ6c
	 XuM06kWQMnaTA==
Date: Wed, 29 Apr 2026 14:42:18 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afJ7OhkfTj4sjTPR@google.com>
References: <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <e5a06ee7-0916-44af-a90c-7ff7cf1397c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5a06ee7-0916-44af-a90c-7ff7cf1397c8@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D56E0180011
X-Rspamd-Server: rspam04
X-Stat-Signature: nnzns4pzsagbc8qz7jxj6ak3qah8tw6c
X-HE-Tag: 1777498940-95575
X-HE-Meta: U2FsdGVkX19qBtd408LBHmqB0szCnWIrw1abXVqdS1uDXZmGoo+K2ciBz8LmPXFi7mls4v9oBA3B6J/99AOlNIdesXoIYTAJMhGlGcZdpVF0uzJi0oReFoNw2t3rgcbbrGGDZrk9a3i/pkwQ2UUdOOUaM6sSplFIGSXW9NGYXj0eOvo6fn0I0Jp16KbcrqVPGVI0hqjGB/wCHWnWpC1svvGrnDBXxaQYD7qS6+UZvCe8RB5f+YmgG+79o4L+9hcjopliCtM1W8QqYjh4bjUf9h1ncrwr2PsHm5i6FHxBu8yIlcnhlzSyqEXOubaTAHD1gnU0PsLo+huMuWg5ohkUNKwYm9HlFPZ+6vULwiq2aAYuDIY8YxUdFCSlAHVKEgKQz0OivhznI6+LFbz1y2QP/6gzaaG22Ad4ltXia1OR2uBQe6cINvWIZUzSbN6/exbmQFXl2xwg/vcHyLT9J3vmT5zAE/UTtFRj0QWLwfaZ7661vqQlMODV8gvhNLXWb6ovR9F/bo8+kjYbre5v4J+P/7ei1zaLQbXAZj8m4UjCyzx3aOeOYSR7Gpf4kdYwLlNp6qf3JePg1rgQRFjKUw+HhPtsujo2rgLgE1M8vFKKK19QA1QCQ6GWGlFpFFspZxGgcOpgerepkjfr3UPHyl6WKjjVkSkG2czJRZt7nMpMRemGTEyp8M0Y9GWqaVvB3oSkUCLPHkj8EhiWfIKQ/WD8iTjsAH72nwibpTCUQF1Icd6X51MGidY7ztYq+cZj+xMhgWHbAnfSifwy3rKNATrj0kd+kKekJuhw9qQEOmkwWV0U8cdQ5+vBYL2OEvcEIiDxLsUGHc1CKEedfbwAj08zswnUzP96Qa6mavIWwEKqbRyfvuOamG5C1I3BPdx9Jct2nI3DZ18gdjCoc7NSQChNELLZY/h7XORu/9m6l1mSER278Ua1BxPQXpThlJB/ZOGGh3ui5BtylMDVv91LTIi
 +qZVeyUj
 /fS0Fu31pLhMtJbsmOYEoRUnvOnNjsJH1iUC4mYCWGgZhtNAHAN6eT9p/gl5RGjRaa15btqgjvb1KI91+THGS/BJRT6/8xMMk1Yl+GyTPny3jKeZj8fKaWHrEr9uXK3uF75HW0zZcqlnWvxAy1e2S6+6m/+zo65nLWkeGhJepnMu4+zwrZtACrDGueCRCuy8oNk6NxtDnANXaJNKrwU/8eEsT84vLnkBEiYl5Ynz9nEOAETO6yiYxCIGmkhKFINP+kcrTWBMNRsQRHUAcJLkg+FnW1gpx/M04e6Dtpq0ihp1CgsmIjc2V6OxD+Ob+a8jbys7+9ODyZ0mMJKa0avQpl7JtnEwV+Mrx5cXncIJrfK3DN1c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 10:55:25AM +0200, David Hildenbrand (Arm) wrote:
> 
> >  
> > -static bool __oom_reap_task_mm(struct mm_struct *mm)
> > +static bool __oom_reap_task_mm(struct mm_struct *mm, bool try_evict_file_folios)
> >  {
> >  	struct vm_area_struct *vma;
> >  	bool ret = true;
> > @@ -556,12 +556,14 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> >  						mm, vma->vm_start,
> >  						vma->vm_end);
> >  			tlb_gather_mmu(&tlb, mm);
> > +			tlb.try_evict_file_folios = try_evict_file_folios;
> > +			struct zap_details details = { .ignore_access = try_evict_file_folios };
> >  			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
> >  				tlb_finish_mmu(&tlb);
> >  				ret = false;
> >  				continue;
> >  			}
> > -			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> > +			unmap_page_range(&tlb, vma, range.start, range.end, &details);
> >  			mmu_notifier_invalidate_range_end(&range);
> 
> 
> This API was changed in the meantime into zap_vma_for_reaping(), and I do not
> want to pass details on the new interface. If so, zap_vma_for_reaping() would
> handle that internally I guess.
 
Will take a look what's the best way.

Thank you.


