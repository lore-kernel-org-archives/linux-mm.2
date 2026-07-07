Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431B1C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E7E6B00A2; Tue,  7 Jul 2026 06:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2470B6B00A4; Tue,  7 Jul 2026 06:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EBB6B00A5; Tue,  7 Jul 2026 06:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD7716B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:35:54 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6522C1C7E43
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:35:54 +0000 (UTC)
X-FDA: 84961625028.25.3692FEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AD3224000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:35:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muEHhNZS;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783420552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIdJ2kWnZSzaIc2VKvx3tV02RUSZsKP0aF813USpRQY=;
	b=MeddSrJyJy7NzFK7Nus+S7WpmCt3GUy5FHdewa+XjdBoFKLTfmJl8DJad1p/5hxJFECNmf
	170nCnQWv5eMRLEZ0qAfEzHuFheZz288F5aXdqa5AZroDYw2v4Dyg/R8eLV0kfOSk7jyRk
	rXZ9J1i8StDX8j+7QPGLkevlSXyGwCE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muEHhNZS;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783420552;
	b=S9iDzL4sTk0KLy+0iEfANcep9D8+LiPzQdfqt6x63aKhQSYryxW4AJ46iMEJilILOZgtDj
	zvJun410oM8utatErCNWYlRpAIiiLrkaIZinC8vtB3fVHEJ0RtKvfNj9pTtZE6oTl0aVz9
	n8R6De4mb/WPmTTjXjq5w2dPNVlDzNo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8A77411A4;
	Tue,  7 Jul 2026 10:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF751F000E9;
	Tue,  7 Jul 2026 10:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783420551;
	bh=ZIdJ2kWnZSzaIc2VKvx3tV02RUSZsKP0aF813USpRQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=muEHhNZSQ0LSJO5dQUblRtk+3KNiW1Sexx9P7JyID1p9Hp3xGv0J4UbRG+fY5Nk5k
	 lfNOH48QJc7HVhAUIDSaP4FNnIxe1mCFgX523zuLO4ghOrfTq4nTYzyBZzGlQjIANh
	 G5dVcytVLi1Y4Go7lt7Hi1xf1O/iRDFx8vFh8b1fkkLSr//7hIoyAOX0XNg3mhaHuE
	 /MZdzFdyC5bAY2+EfgYmdAJYL+l14uqVN6YBlzzFherZX3IvuvVVB4464w8KwAKHFR
	 Cb6iDTk1N1p2T8kQle7lANNppyIF7SnaCJrLWMjV2fVD3A9nrBk/dbzE9PoWVE/mTu
	 kXgj2SJWBNUbA==
Date: Tue, 7 Jul 2026 11:35:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 25/30] mm/vma: update vmg_adjust_set_range() to offset
 pgoff instead
Message-ID: <akzVxx6vIeiXO-cV@lucifer>
References: <cover.1782735110.git.ljs@kernel.org>
 <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
 <akZLhkjsJ_3sGdox@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZLhkjsJ_3sGdox@pedro-suse.lan>
X-Stat-Signature: z4af9bcj8n56mrehh4j6tsno9cot4eqn
X-Rspamd-Queue-Id: AD3224000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783420552-662886
X-HE-Meta: U2FsdGVkX1/HQdKeTa3RIccDFtZCYXX9vJWgD3eRCnmR3RVIbsO7lnsaCfeQKoRDgF9AK6a5FIH5JeeYQ1OEJuPA5VHeWAP5jq37gXfOGgoVRzw6WK/K4cC70Yf3Z88ld4d60aoIZnSuWVG9eUKb2QvnsxDQyBAc5sE0aIR8F+8wWRVzXSFd2Js/791SPUkyA4iEnBh50l9SibWb0YSDuHz2eZtWx+fspfnFETQZuMc6X+3QfLcXbJxWEhHWGQtnk0IdT006zggaY3OdZXocBpAwdR6+fd51lvQiQZFfMm1maYbUmZ5z62QkgLfYrElEJgW7nJXKeFvr2eI572PwqOCco9itF0BfaQnO8Squknj7PVZ/Mo2NjepZVHZQIZJ3TdamJ10T6lCJ2j6lu5J2YznWSQcQAErZ4qPNspn7lW8MwUD9rOnU9rCRtKhTjkAEZfwEjNIg8LwaNQYvT4cdV9HTYqV+aDswVoT94FeVh/D6Kh+Wtu0mPwMtJsEKqxTNk1Fx5DuNMSEJe0UErHrpPMHkT9ynATsHX0I7IzO5mTHcHYNId9kq4iF1IUxnUPFYYpdrMVhidQpIElnxvnUulaPmlxsojiOG6vvuIB0aSjujKdNCO2R2HV1j7RDkJm2Dl1eXxHP6PSJRp0H98veIkbg1MaagVhoMnw8cq7HPNTHSOFMsjzFrwZf6iiuCnmN5YHkrpBKR2Xh/K8+vg2qAeaFHzEQmlf+DiCPXJix3Y0/Q2Z8dsmzlRKzGb5Ord8pZT46xEh9xXL5RFAytdbb6xeEhOEoPMP++naUMYfWJme6eZrzacQC43Lu2x09cBViiG9KkJ55wQQqK5glq8SPyY0udLTbtgWh1H27SuQ2JX6x1kz0M6qjOioduTcSoq/WN8NU3jfajCD5+WO+1Sis/HVnam69B4Qx3Gf3iSxSz9LKzCbm3Q3TG7KLuZMRMEw9WN2shPfZV2BQToY8R1QZ
 2pEOSaQo
 HrI6Vcu+zNkLXT/5ZbAsf5mfaEvfL3VwzI3d+l8F0L3GBUSbI3Mup1c6EZLe0Ko00nZ+Rf1gDfcfSWcENu1e6M8iBumfHLbiYfSU3UEaLWgIuqYIAMy99hyjmmwo9J7p29gQRL+kHZKxvvLn6rdhG1kDAvxwBNkSpX4p7AoJS4MzPnJ8UkjVGwfiIEG8f5LTKlh8cjrWFIzFv3XnwXx++/O4bxXixt8n4Pej4HnDkxK/s/6S7bQln6WiLUOH8WJgUedkVjnESaTN5hAGlyCR/f5gXqTyyn2B6BjY/CaYofpZ+v35JwRWJx1UMZ6fSigOvXonjAX/scLRLk6zsKSLYzZtPbJVp2lr06tRLnsGv7Zs4O/Ud5g6Oy1AN33xGOmDtw0cz5xA56efWw9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:29:54PM +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 01:23:36PM +0100, Lorenzo Stoakes wrote:
> > We are calculating the pgoff as an offset, since we have vma_add_pgoff()
> > and vma_sub_pgoff() available, just offset this value directly and use
> > __vma_set_range() for vma->vm_[start, end] values.
> >
> > We take care to update the range before offsetting the page offset, so the
> > adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
> > the page offset helpers operate - this matters once vma_set_pgoff() comes
> > to assert invariants which relate the two.
> >
> > Doing so lays the foundation for future work which allows for use of
> > virtual page offsets for MAP_PRIVATE-file backed mappings.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> > ---
> >  mm/vma.c | 15 ++++-----------
> >  1 file changed, 4 insertions(+), 11 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index e3355eab11f2..0579fc8c9bd5 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -714,9 +714,6 @@ void validate_mm(struct mm_struct *mm)
> >   */
> >  static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  {
> > -	struct vm_area_struct *adjust;
> > -	pgoff_t pgoff;
> > -
> >  	if (vmg->__adjust_middle_start) {
> >  		/*
> >  		 * vmg->start    vmg->end
> > @@ -735,8 +732,8 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  		struct vm_area_struct *middle = vmg->middle;
> >  		const unsigned long delta = vmg->end - middle->vm_start;
> >
> > -		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
> > -		adjust = middle;
> > +		__vma_set_range(middle, vmg->end, middle->vm_end);
> > +		vma_add_pgoff(middle, delta >> PAGE_SHIFT);
> >  	} else if (vmg->__adjust_next_start) {
> >  		/*
> >  		 *                Originally:
> > @@ -764,13 +761,9 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
> >  		struct vm_area_struct *next = vmg->next;
> >  		const unsigned long delta = next->vm_start - vmg->end;
> >
> > -		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
> > -		adjust = next;
> > -	} else {
> > -		return;
> > +		__vma_set_range(next, vmg->end, next->vm_end);
> > +		vma_sub_pgoff(next, delta >> PAGE_SHIFT);
> >  	}
> > -
> > -	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
> >  }
>
> Maybe this should be squashed with That Other Patch that touches this.

Ah this separation makes more sense from the point of view of the virt pgoff
stuff in the RFC (see [0]).

And would rather keep as vaguely bitesized as possible :>)

>
> Anyway,
>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
> --
> Pedro

Cheers, Lorenzo

[0]:https://lore.kernel.org/linux-mm/cover.1782745153.git.ljs@kernel.org/

