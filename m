Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9837DC55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1896B0088; Fri, 31 Jul 2026 17:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881E76B008A; Fri, 31 Jul 2026 17:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770876B0095; Fri, 31 Jul 2026 17:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 525EB6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:17:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58324120162
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:17:33 +0000 (UTC)
X-FDA: 85050333186.10.5C1B4F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A582E8000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:17:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DATojsrq;
	spf=pass (imf02.hostedemail.com: domain of wei.liu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=wei.liu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785532651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WZzBzB5TcTM5WHmYQ8Q1dAbLhGvD103w+cLEBe4VuA=;
	b=YwfxTIKNJ4Y85cZpNVEqeHPelcGRtWABFoJLzb0O3po7vCOGyzdTpFbnodItsKfzs1wxk7
	46EH0UWRL0B8j74GxKJJDrhRCipw7GVExcDP42f/x0sywmHoB1YXLokPYl1fnREVviUxLx
	DaRhDrnarEFqgS/3nUBqQIBqztIZJKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DATojsrq;
	spf=pass (imf02.hostedemail.com: domain of wei.liu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=wei.liu@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785532651;
	b=Of2dIiTf9430NEBHWRRMPenKCxJSihUauRopRKIthDCSVqf6RoTrDT8CLp3rouY/pAeBXi
	3RuQCHjh4OGzWoi1JX0jhc3BNS+P2kJ/q7DIedMxUgGOpUVyJRWnafNmbazCh2it9kT0ec
	DhSG3Tq26iQZdpvsuw7Bb4wuJJqI89g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE3E0429F8;
	Fri, 31 Jul 2026 21:17:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEB01F00AC4;
	Fri, 31 Jul 2026 21:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785532650;
	bh=7WZzBzB5TcTM5WHmYQ8Q1dAbLhGvD103w+cLEBe4VuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DATojsrqDUH2APrMK9JbylCWoE2ibRCU80F00dlXpjJ5tQnjcDpOyY3g1h5BaiXkh
	 OPQFeTRsYckQ7zkJr8ySOqnEXtUPJ9duft5KOengcfVlj82GQ7OHLUYl/0APGURpbR
	 InOeOg+Wkvj87hf1xVBgbm80Uvpy76xZ/d0vHtznzV505vzReXQHxpkJDoWCGw2BwK
	 n+dgCmnoh3oGQ2+xsXY4mwgUvbCBCaqlbGSY1kPFCwF5fvZuxWlzKzyDR/rmE7RT2q
	 LZ/Scw8myMGgEFz2/B1FpXBFZQ6957WjjFwwulg3XmXtT4VNTWJnUiMnJsb6tmcpDb
	 QxHvmvGNGUzpw==
Date: Fri, 31 Jul 2026 14:17:28 -0700
From: Wei Liu <wei.liu@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20260731211728.GA3243658@liuwe-devbox-debian-v2.local>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
 <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A582E8000D
X-Stat-Signature: h51n7woyghzgu5aqbz8gu35xdz9s3gkp
X-HE-Tag: 1785532651-153436
X-HE-Meta: U2FsdGVkX1/CwoBV6tFULZ+j5w3KKRZraauMqkfOIVqkFxib0DQILtebAPVm2M5Vf6NHfFS1I6rgvSU04ShRiEmfm0Q5MOJyP1gEi7de0xbUTVd1uQ/+dfRJNGAYJhBSjv2L8Jj2OEi4ly1dsCWfB1VUD10ePUuXbiHDrAi9tJXVYPUO7jl0d2Feyh6b4U5OqkSSb+cgpRpVbx/aCum7M/yh3wUfmgC+euHwmTNsVlkHkenbl1dZlew/OsfSMnRaeovNK0sgi8uvBzCesyhthGBKrbWIyzT8OkiH0X3YyhMFpgSkbNUk6Vrzv0uetQComtxDIhN1PFihpnB21kK2c3+b6yLNhHq8hDoFQIyhoj/BeBYSNoL0v/WN7ybCdPK+cUPa02Xo7f29jpcmhb5tkqtFAABcHZiN/ayNRzWKciKUGFQoVVunGRTWo+qLsYB4Pkh2BJ/H9h8BFN7l8uJxZXnt0azs2f7oSIhyJCz7VNLasKfhY0BhGNPPkpBdj6qj7jzKRwrlR9vDvkzu/DB57GeygmbUfsqv0ueeqjUKuV7QXcW5uccJYn74tyTGYN7vnSuJLZDzavu2gEgJwZ2mi8Y/IEBg/bWwhz38b5gEu7AD3kYKt/0tKfdIWie9vqSc1KEuxAd7PYT7jVpDjH7kHb5DH0xw1pANTro9R/J/MHfJiBP3Oqf+oPEPI56jTsgpPLdgegWO+aTjn6Lw/GgOb9xT17gaaivnOwr+pQbz41Lo5+ApPFPbOxRkCzAaKzgKr8TQUlxumapmmRpNkPNZYwclI0ctYevydwpdivyhT92ll3jU9B8Sz20zHfwjkXr3j60qGDR1eAAduDX/x4D5+WqS/4AxsmHCfDNzJDgdIshdvfYEFRjchC2IaB9kbnTD2a5CtLvShiJ/Hvv14iUK7ieVS1ibS1sOV14t/vsbTrVlB0yNu3Kbe/PHal4MB9/R90QN0HjQSTvI2gvO6Jz
 RYEEVb/O
 n8LMK2KkVd0Cw191Aji5xEXAxFIEBFlyj170KUnifUet4+oTj9/AgMRJzilCXfkYpYv2V8e6+O0vY5G/E9UsEQ0cGYUgCAUD5nL1XBZVS6sP5QZzs7JSexnxyymDrbCTk+n1nUGSWH9maF5BFou8C1ItJ2ORE2FilfuG5R88UAGcP9q/krlcgKmGfbR2ySCuMfuFZffE63GCwUP/2hTX/tY3Qjd0rhot4QEJaaGWImEUfWvkquXdNBNi8yQUlv6ND06ppndh2PySeTm+QvRztDRTrDfGw1wmM0r3ctOMgNvd7V6I=
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

Hi Andrew,

I see this series in linux-next now.

I'm curious to know if these patches are going to make 7.3.

We have some work that's dependent on this so would like to plan
accordingly.

Thank you Stanislav for continue pushing this.

Thanks,
Wei

> 
> AI review suggests there may be some problems.  Sorry, I don't recall if
> these were considered in previous versions of the patchset:
> 
> 	https://sashiko.dev/#/patchset/20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com
> 
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

