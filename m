Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FDFFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA0066B0088; Wed, 29 Apr 2026 17:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A50BA6B008A; Wed, 29 Apr 2026 17:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966566B008C; Wed, 29 Apr 2026 17:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82C8B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:41:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38C861A027C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:41:45 +0000 (UTC)
X-FDA: 84712915770.17.3A896C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E84B6A0003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:41:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gtFP/9KM";
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777498903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLMGfClPswcI0gsxCTX5OwwaVtVPt+QfEvaeTz/tYgE=;
	b=3IeRz+QJtyz2XHQopicIVk8gmNX+N9cr5M7Mtsi6dZW029wcEGeSwL6KATDUTnSojNO4rg
	aQ9UPU1mF94JCIUA0mmG4PEZZ4v+nAbdeOP3KTdRDbszH9lg7j/Z3LPvbn9S6ksIzOs/Bb
	GbUet+XL94z/SobdKRYMZsW8J6oFUr8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gtFP/9KM";
	spf=pass (imf15.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777498903; a=rsa-sha256;
	cv=none;
	b=l1AsVMq9y0kl54UTKu8bVi4QhIFu6zkvIjOIg+r8laTHw0gN/XAa2mb3KaVLusHBWjZ6rk
	xFHOvRCos6asVgFhROGoaSrqh1vh/raf5tag4umAmiu6HizR3lQeBNbbg9lOikzhGp95wf
	q7VM4N6xmpohF8ukHtdQVDzOj5HLWTA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32D6B6024D;
	Wed, 29 Apr 2026 21:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802A3C2BCB3;
	Wed, 29 Apr 2026 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777498901;
	bh=XOibkyLy0IVe150xVr58dFt6tHTML3fQOpFxcRHSscg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gtFP/9KMtfCIdMN59rmE+GGWQgKK6XalKGSYNc8W+mO5uIwxVSZmWUJmSYDnqKXiD
	 0Vwz44wcQfX/oIfgjgTnDcKDMBCCIuFYec4HbGobONXFWKtFcx0vDyXWId5wODvW9p
	 RiypTm+y98UiIOc5Ul+X0IOV8GXyD7gliZBZu0aE2hAXXmRPirHJpNRVrE2Hn3bmQ3
	 Gq4KedknY1j3/fBtOXTwuFigYB+VMX2t3NnHDKue2TlmTq4P1pa6fwzJqIOvEzpKsN
	 lrBVsdDuILaUED1pLifUwWYEPntH/Pt3ifDNRpLDPu48T3dR4dJeJhTaf09xYk6Uh0
	 oi++eFuWQ3e/Q==
Date: Wed, 29 Apr 2026 14:41:40 -0700
From: Minchan Kim <minchan@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, brauner@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, timmurray@google.com,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afJ7FPkNK6cxUxSe@google.com>
References: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com>
 <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: E84B6A0003
X-Rspamd-Server: rspam06
X-Stat-Signature: z1c46y4cc6jfbokbmjsa9c9qr6jf169u
X-HE-Tag: 1777498902-465363
X-HE-Meta: U2FsdGVkX18cieC4zbKuKQccylK96KP2SG/rn3yYZxvNuISgfb1l7AOKaiZi7V89eXhU1qxPhUJPY+eqrtlBkQPhfjuzslbGuPEPqQiL118sfF1LVDKUr2akDXv5DxSfjGuVYZHdYmzN0oiTKqjUOXy62IvMVf/KBJtiEfHcY+R5/CLywyS6Qu0RM4yqq5Au9UgthZ1y7VE17g6LB6dn2F7C7Ey1NqAL7ilf1U8+XuwLYfmYMGCSmLP3aGtdkZed7+cLy8fJhazxja0SUbnpTLO+tW1e3e7yuTrFkG82KfqdeKI1mhcr4yq+1g5MFCls9xq0fKU+vLTMEE+S/7367ACjPvcQ1O19mOfhX9kp6Gym+kOYeesHjt9awc8QY+5q2Ttp0aY95J+I5rEjF2v1ku4po3hHzpUaUZSmHKgpN8SuI2nTDBvrpz1fnwqG14Q3jX8cEwMJ5nTLAAD407ZPZtQ3bGUZA58cb3/obYXqiyAdIap7kYPzv4fW1CxZ9EKLjVUtM1p6lPPdDDQOXzKUu4mZN9Uym4v2Ts25Fd/IRhZOeuYAQppNAJDwXdZSV+x2Km5QmQnLUb2xw4lW3dfr2Vok1yVNBqidJQBYmyWWCVhYjB1mr9SGlmcKIlsf4pvruKfPXPpH/0OPYlNWeSc5F01uTRDF5b/vkREtW91ch5UXfGjvRKI+ZevWIgcGHkMnxzd5FcbapUpbkStkaseDH4x3TJ1PhG5tX2ovvy3u4I2vsRRLJ2gT2eyJzeJEURui6gtWGzKb4yMFeYQlzLmbNyap3aiEEQIOdRdiki7mU6HE9PUmhY53w+VRxjKVHELxxY87hHqeUqYftpcGHX87DJC0GKwaisdm5ZQai2RBxrHQ/7FQmNnM69XnTfjJgYI8xASfqEdlWmBucA3HC5SIvuqvBveiDhzTKJjOsQLkJsuSQbHT9B8MeAhM8hNdBaFfveiXmEbtLgcC2lJbgqj
 nEovqXwQ
 +vs0GMYzjNR6FGhBeMuAOiV9K0RYKZRSzOmYkatPpc4sQQcUtfmRvgzS0iDbzTXRfnBpaeI8N7YBwjnH4MDeNmUbwAs6JXx5BQYm1X/2lUor7T/4lUO+pI1XRMpgXe4KUMoxq7MN+sZrKISKaJeC+SlCfewAdSIirL9xSJ6j1taeIL7njvNZ1Sth4TuSgW8iUD9XnH78MWITmxfSUjktBVjRoezrIVtigZhhpUdGojRmZU+N6uPIPloN03cQYB57aeyqvq94wlUzpRBBbLAQFAiFD89X40VZ/33CPqQeWRzQMe8sDZq1SbGnto97PTW9WsBqZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:09:55AM +0200, David Hildenbrand (Arm) wrote:
> On 4/29/26 10:18, Michal Hocko wrote:
> > On Tue 28-04-26 18:19:31, Minchan Kim wrote:
> >> On Tue, Apr 28, 2026 at 08:56:36AM +0200, Michal Hocko wrote:
> > [...]
> >>>         DESCRIPTION
> >>>           The process_mrelease() system call is used to free the memory of
> >>>           an exiting process.
> >>
> >> "Free the memory of an exiting process" implies all memory, not just
> >> anonymous. User cannot know it will free only anonymous, and I am trying to
> >> make it work as intended by completing a symmetric reclamation path.
> > 
> > Page cache doesn't belong to any process.
> > 
> > [...]
> > 
> >> >From cf292f8f8ead8df9161aad342c36633ffa90257f Mon Sep 17 00:00:00 2001
> >> From: Minchan Kim <minchan@kernel.org>
> >> Date: Tue, 28 Apr 2026 16:39:06 -0700
> >> Subject: [PATCH] mm: process_mrelease: skip LRU movement and expedite clean
> >>  file folio reclaim
> > 
> > I will let others to discuss this. I maintain my position that this is a
> > hack for a very particular use case and you still seem to not explain
> > non-Android users of the syscall. Anyway, I will not repeat myself here.
> > 
> 
> One thing that got lost in the thread here: this code path is not
> process_mrelease specific?
> 
> We seem to end up in __oom_reap_task_mm() also from ordinary oom_reap_task_mm().
> 
> There, we unconditionally set MMF_UNSTABLE to then zap_vma_for_reaping() where
> memory can be "reaped".

After updating my development brach, I see zap_vma_for_reaping now.

> 
> So why is there "process_mrelease" part of the patch subject at all?

While __oom_reap_task_mm() is indeed shared with ordinary oom_reap_task_mm(),
I added a boolean parameter (try_evict_file_folios) to isolate the
optimizations in recent patch.

-static bool __oom_reap_task_mm(struct mm_struct *mm)
+static bool __oom_reap_task_mm(struct mm_struct *mm, bool try_evict_file_folios)
 {
        struct vm_area_struct *vma;
        bool ret = true;
@@ -556,12 +556,14 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
                                                mm, vma->vm_start,
                                                vma->vm_end);
                        tlb_gather_mmu(&tlb, mm);
+                       tlb.try_evict_file_folios = try_evict_file_folios;
+                       struct zap_details details = { .ignore_access = try_evict_file_folios };
                        if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
                                tlb_finish_mmu(&tlb);
                                ret = false;
                                continue;
                        }
-                       unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+                       unmap_page_range(&tlb, vma, range.start, range.end, &details);
                        mmu_notifier_invalidate_range_end(&range);
                        tlb_finish_mmu(&tlb);
                }

In the current patch, ordinary oom_reap_task_mm() passes 'false', so it
does not see these side effects of broken aging and file cache eviction.

The optimizations are strictly active only when userspace calls
process_mrelease() with the PROCESS_MRELEASE_REAP_KILL flag.
(I believe OOM killer is ultimately target of the user but didn't want
to introduce side effect until we can conclude for the direction).

