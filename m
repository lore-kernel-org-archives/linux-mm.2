Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF5FC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097246B0092; Thu, 23 Jul 2026 18:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048196B0095; Thu, 23 Jul 2026 18:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54E46B0096; Thu, 23 Jul 2026 18:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7CA86B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:22:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F1A0801C6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:22:32 +0000 (UTC)
X-FDA: 85021466544.28.93ACE1E
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id 51ACE4000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:22:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e6hhBdAv;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784845350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzwHTZR2iosFUiZOe0Oy97LjUFogfrOTmiFLxNsdVTA=;
	b=RQuDOorcAgV0TxHy329R9Ulc46N3hFmQ4EpoxXHsQe7X/2Kon/AKvtR0HhrJiD+JlDiqWQ
	5duM7mcccd80y4KcPUss6BpgUOxLBx7OtgHqwIR67fo4QyW44c5GzpDaeo5tS5wtsUhhVw
	aI3hESE723SaZQKQK8Bpn0FmWulmgD4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784845350;
	b=Ta/hMH4nCX+MKjRKB2eM6CPRCeQuCqT10euiZjfo+sYYaWcom7AK7g6f94E6hXCqrBZx03
	DzwEUv+nd+aBClLtKxVcloQxmYnpXmK+Z3QTqRgAyHtOdhRjDl4NvwQ3PILiNXsoEmWRhQ
	pZq0kLBiIcTC91WrMoDrcOTTqKbzjyM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e6hhBdAv;
	spf=pass (imf17.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cca0c5799eso12167715ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845349; x=1785450149; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vzwHTZR2iosFUiZOe0Oy97LjUFogfrOTmiFLxNsdVTA=;
        b=e6hhBdAvMzy9Bnzg/Qx1oaGTlwjA/Uf+UxjjU3jNMU2ollWwsrKcgnsH9k9SUN0jsa
         mjiiNwD4NfsbGeDOBT7MfmCRYkEIH0lV4Ulx1QcWKt0ljdmtPkvwL+3N5KpuwNxjbYb0
         jQFqNUo0BtEmAe9/5PZFDwobe7UHh570zygqbYKOgVDC0f7Qu/9QOOhAIXXzbCe9hRjm
         UVhQp3RIUbwGwKJMkfbC3zczMh5kUTMx0oeXSOP/Q1mXufEBGAf+3BLoKVNgPIxqjlKH
         GCU04w3grhYpVe/yhij7FyNy7XZ3NbRdQigiROswjZCQIK0yhbo+dq8RfcNLXLIkPY3W
         4uWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845349; x=1785450149;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vzwHTZR2iosFUiZOe0Oy97LjUFogfrOTmiFLxNsdVTA=;
        b=OKbwRUuuOys/cxCC28++xqwXwtU/wbOni6FVD5+f1QNQXBBNRYUCiyKAXHSRzEIJoR
         M4mo+GN0zd+HPsza4itBQWIyfmyrUgvr7pTQiSrgFqTmvLieiUSl9gI1SVwMetIlabH/
         4ahzLl0FRZrLVnqrtD2HXCoCJ03LO/UpHZf3YCcmKN869wD3vN+eDefvOagf1zSGtTSo
         CKMVYCUdI46apIqHdrpdwYA80mG2j80S5hKDLWbWuHRn106sDfxJTEKyogOjgYTBgu90
         8ErPXTlC7q113a7SBtVUynLtGng9k2lUbmlW5JaSPJJnLB7f4xf6yIG/4n+JoOxjqXDO
         Ktdg==
X-Forwarded-Encrypted: i=1; AHgh+RpqSL3/8PIwSdudWDuayVedFpB/cL6ybDvDUrKMr83jWan6ctNm7jqp/PqGDoofStabVrxfMjSPTg==@kvack.org
X-Gm-Message-State: AOJu0YxIKdx34OaxWJjqMlT1eMQ4E944TH/Zdp3+D/YQOJFU7kAwEoET
	zPnSxfC1UOilPlKJ57q4ABDVvUVdf22QnbCpR/6xU6UKzD2VSfVcftXk
X-Gm-Gg: AR+sD1094U90Xo3QXfcIKW+Hsvlrn1rXTUqrPxG+9guORknYH25yB57gp3fCkPVdIhv
	wWwo0OBitJ6dFYAMlq+/jxPM8ZYKEu1eonwoZpffvW8JAMXXWPQHeMB1Po5+zkX3xzlu9T6XM/E
	pgHfFXvXgycm5Z4xGAYujERpqN22SwWad0XI463OGtfaWekX8950MtSqLs98rPz+Qft3ADu4tFF
	65Of0FH29GdDiy+1UzwekGS9HL21u2qzoGbwIey6YOrm04VgpFrCIqIS5JktYQIMetIRhoZKSoC
	ZXwUrXG6Dv0f1DxMTZ4TOBJHyMjztB81j4wbKbBaTtRQyyWIpTk+eEMAPTHb3m2S9Q4RR+AJb/9
	FGjKAjNGrH7mEyQ6HgiHzXAWUIrZdlg7yNuGnLNgj6iDI3oqucUshGkR/+9KWamh7VW4gzF1Sq4
	QgqeHiUalPQ/WoqPsB5YK3wIjmUZdKxfJEFx2Y6ywW19Zc
X-Received: by 2002:a17:903:90f:b0:2cb:2b53:559f with SMTP id d9443c01a7336-2cfa6c793d3mr60755125ad.35.1784845349134;
        Thu, 23 Jul 2026 15:22:29 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f38757esm40198575ad.75.2026.07.23.15.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:22:28 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:22:25 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>,
	Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <amKUIWpMfVS6OFkQ@skinsburskii>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
 <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 51ACE4000D
X-Stat-Signature: b94a6x4xeyp598dit7toz5jzwzgj4mxu
X-Rspam-User: 
X-HE-Tag: 1784845350-669737
X-HE-Meta: U2FsdGVkX18uBNdFkfbNHIKn4SprzN96ViTCSOD7YXAE8/t442hNVDDAY7ukGNa4Vk7upz7CtvN9nvwYfJCylrFh6CSWgAxDVMQgzN68Z9liL5RDxK4A71q9Onldc8Xr1awy1WuQTKbawS87hLiJbHWTs6ARsPcMhjAVqc5fdyMP2CL78kK8JXBxB60Efl83nFBfIf37GcugUuflFM6BQx+lxtMwO1GOmUX3kLRCBsYrOMweyALIKmVY9CsRa5uW1XG4xdoGEDxw9M1QhbBI0YaVqo11uXW5INhpRikgYOIwoFu1yTv6VYhEzAAzvKmjWxCrYBUn0SagQEHDBVQtsNu6CEMcuq7NO6YdYKDxleDDR83O/cPMIjo3teVvPyNto/7Q4G1flPkt2JekSuA4eUHTfoh3+ES/Ah2DYAbSmIby6iQm6h8mDz/NScgzlevJtCfJMiEtiIAMMflFZNyYw9HyAWgXf+7hpSp3/AoCXBZXcQ08dr6Bx1Fn1MmP+CbQrzmpQ8DRPtdSI34o9wuC40vtC+6YuOi+xK4QsOr3QMROjEYcbeTBrwIH2+NNKSTpQZ7FWAxAy3Utbn2oxib2auhnbLe1ZiZzEyZaEHHTZhz/rih5epuyEcH5+TAtZXuueaQPmjIjPzQ4yLcsvwGqVe/DK1VKlNUhLJlSkP8pPbiSI8wi71rqP0Pf4BefLK8+RQQUjJWNNqQ08T0DPZBWTaCSf/hlm8zv5zmCaRTjT9b+OtsAeUyEPQ2uXEIivAHFLe+U8EMDAxj51UVHM+k982dxkLLH94jjTIEfbpvkQt2JXRnlaSZrKvKZcOH8rb6GN42EAA7WOcXT9oC2b5Dz9aYGbR7IROBbaxl1kbZZF0u3xPh6aEU4Cz+i1thDAOQeKjsOHy/Rl30iuN6lhvFWzM71uhQtM9waQXp6wu7Q9TkVDZ8pfBNuO+T8S6C6j/YZrXjvK+uaUakgABPclSO
 SCp+OAZq
 NEG1SdzL70FwSCWvv71yFezMvu/QtKCaavgnNsy3KOnUiDBiE1Wxxu6OWxgQPTiCBWRKVwopYt7WLY2Un8HzB7lg1+1zcIaFtPzoYWD8Az7FdSduotjBYgz4UutbpuB6YGq9geHSuvtDbdIrv3tecYtnjc5MgR2P+LWHyAalkuV2EPW289VnlL9+e7AME1CqB3ny9z/9aWQW3nxrzt3FgcPdbiotRJz4mNjM5crP3vcslZqzwO2vAlECimowi5msvmBkJ3KxEJUEV17NN3n3Ng93Dez6yOpvAdVk3MY9csdCWJgGTxtnOrA82D2EuMkvymPT67ArhRzCxO6v2JzS3G4d4Y/uucFKP6bKzHY3lJLcrO5rDo1Q+SjuZzctjz3nV4A1W2ArHrPu4QBLQnQcqlouiZmezHeaFsziRVJRVjT6GN2uipv8ki0nDMtb3E+gFvrDsNrpXAxidhH76UuGWiCfDBnqb7X/KZIfZycEFKQ/M0vHKzZvfoEaxhkmyozbL+1h+gRZdkMZAyK0pYk0H/3WH1MvHUtXgceeN1iLXMMIRX2fESBdg4D8pw+HZbWlwIf3j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 02:22:42PM -0700, Andrew Morton wrote:
> On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > This series extends the HMM framework to support userfaultfd-backed memory
> > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > 
> 
> Thanks, I've updated mm.git to this version.
> 
> AI review suggests there may be some problems.  Sorry, I don't recall if
> these were considered in previous versions of the patchset:
> 
> 	https://sashiko.dev/#/patchset/20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com
> 

These look like new findings, perhaps from a newer model or review prompt.

I do not think they apply here.

The unlockable path sets FAULT_FLAG_ALLOW_RETRY only when HMM provides a
non-NULL lock state pointer. The legacy hmm_range_fault() path passes NULL
and therefore does not opt in to lock-dropping faults. Fault handlers are not
supposed to return VM_FAULT_RETRY/VM_FAULT_COMPLETED with the mmap lock
dropped unless FAULT_FLAG_ALLOW_RETRY allows that, so the NULL locked state is
not expected to be dereferenced on the legacy path.

For the FAULT_FLAG_TRIED concern, HMM is not trying to emulate GUP's exact
single-address retry loop. If a fault drops mmap_lock, HMM has to restart the
range walk because the VMA/page table state may have changed. Resetting the
timeout on that path is intentional: a lock-dropping fault made progress, and
the timeout is meant to bound mmu-notifier retry churn rather than the time
spent servicing faults.

Also, the newly converted HMM users are not using this path for ordinary
file-backed page-cache population, and process-context callers can still be
interrupted by fatal signals. All the existent kernel thread callers are
capped by a timeout.

So I do not think this requires a code change.

Thanks,
Stanislav


> > 
> > Changes in v11:
> >   - Reject unstable address spaces in hmm_range_fault_unlocked_timeout()
> >     after taking mmap_lock and before walking page tables.
> >   - Compute the remaining HMM timeout budget before the time_after_eq()
> >     check in drm_gpusvm_get_pages() to make sure it can't result in zero
> >     and lead to infinite HMM range faulting loop.
> 
> Here's how v11 altered mm.git:
> 
> 
>  drivers/gpu/drm/drm_gpusvm.c |    4 ++--
>  mm/hmm.c                     |    6 ++++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> --- a/drivers/gpu/drm/drm_gpusvm.c~b
> +++ a/drivers/gpu/drm/drm_gpusvm.c
> @@ -1422,11 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
>  	struct dma_iova_state *state = &svm_pages->state;
>  
>  retry:
> +	remaining = timeout - jiffies;
> +
>  	if (time_after_eq(jiffies, timeout))
>  		return -EBUSY;
>  
> -	remaining = timeout - jiffies;
> -
>  	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
>  	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
>  		goto set_seqno;
> --- a/mm/hmm.c~b
> +++ a/mm/hmm.c
> @@ -17,6 +17,7 @@
>  #include <linux/slab.h>
>  #include <linux/sched.h>
>  #include <linux/mmzone.h>
> +#include <linux/oom.h>
>  #include <linux/pagemap.h>
>  #include <linux/leafops.h>
>  #include <linux/hugetlb.h>
> @@ -806,6 +807,11 @@ int hmm_range_fault_unlocked_timeout(str
>  		if (ret)
>  			return ret;
>  
> +		if (check_stable_address_space(mm)) {
> +			mmap_read_unlock(mm);
> +			return -EFAULT;
> +		}
> +
>  		if (timeout && time_after(jiffies, deadline)) {
>  			mmap_read_unlock(mm);
>  			return -EBUSY;
> _
> 

