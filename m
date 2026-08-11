Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209D0C5CFE7
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0EE6B007B; Tue, 11 Aug 2026 12:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1891F6B0095; Tue, 11 Aug 2026 12:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0545C6B00A9; Tue, 11 Aug 2026 12:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCD766B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:51:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6410D40128
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:51:51 +0000 (UTC)
X-FDA: 85089580422.22.D2BE91C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD85B4000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:51:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zu6P4EWl;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786467109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nUtXloIWo+60BaXIYhpidIQX8u9D+3kedoVN7C9D9/g=;
	b=TZpaXPCKC5nqhttJ3I8IYUuZNV5E7q3dFD3r+skvsFD4Aui2vPILZ/QlSNBbPXdQNOossw
	/R//WX76avxWdPZzxkdJEUeeR9Qmaye6oZcu4bFnr6D9OG8/rfGz6T7w5yJvC62onUDItZ
	8RY3jsPw9vfWHftkYLL5cUO13c+dVUg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zu6P4EWl;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786467109;
	b=wAeo2q6U37MWyrfQMuJCfBPOHAYHS1eLLyBHH5Q72zVd6hti4i1TSkBo+3uvEr5/Wv5dCl
	pYerQX9tFpPScvgpS6eDepY89RpXoAg2MlAMDPQPpaSXg0B8nLNWvUuQ28Sqrd0IY8Dvtg
	jJ45iRJPkjEsSKg5n+IbPetZK0c3gUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66C52600AD;
	Tue, 11 Aug 2026 16:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694BD1F000E9;
	Tue, 11 Aug 2026 16:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786467109;
	bh=nUtXloIWo+60BaXIYhpidIQX8u9D+3kedoVN7C9D9/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zu6P4EWld4gpzY1R8hq3ER5DyVSS8EQG3tj3hB0FUUqztpnB1xSYcKl3Q43tc8cmj
	 UUsHVaeqqzm48VuQVJJx2EmW7mni8RQ6I1+levHRzt5ChDbHMTxJyaxCh3f6iBS0/C
	 55H0zKXQaRRXxQd/+WCqvaxpLr5pPGlTLRkmGM/8141rUWlck+hHndDPdyOG2aaDBw
	 gO3sp1uV5pzP/Ne9Y0kFwRhkfkxbs6cWxO90fh/uBbI39rSVBYq65rSukH7lNfLsuz
	 C2uETEK6ptuNat6DVNihDE0Y6C1cj1icY2cXtTTklAMhkklLMENnIaGg5NMBUxP04U
	 D1oeyGwJyciyA==
Date: Tue, 11 Aug 2026 17:51:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Boris Brezillon <boris.brezillon@collabora.com>, Steven Price <steven.price@arm.com>, 
	Liviu Dudau <liviu.dudau@arm.com>, Huang Rui <ray.huang@amd.com>, 
	Matthew Auld <matthew.auld@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	intel-xe@lists.freedesktop.org, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 07/20] mm/vma: fix self-merge check in copy_vma()
Message-ID: <antTCpT9gXN7pSRn@gremlin>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
 <20260806-b4-scalable-cow-virt-pgoff-v4-7-ab318a350404@kernel.org>
 <3a0a9aaf-20f5-4f92-b848-00ab702e8fe2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a0a9aaf-20f5-4f92-b848-00ab702e8fe2@kernel.org>
X-Stat-Signature: hydw8f943ssm9rh8bwuzhi6uxxo7fbzy
X-Rspamd-Queue-Id: CD85B4000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786467109-739412
X-HE-Meta: U2FsdGVkX18KEL/4XW2aoVy4f0Y+0WKJ1r9vEtZZI9xY9Td1mSfc7qAKHRAkZN2wLRn9A6qw/HRlYwNMRisTBOB5ZteBDxcPt3xChT3CmM6XVmtwlinE1d/WW4OGjylhed95RSO9T7EOZKrwkn9hDP+kfbJD0I1TQdkGAVSGU2XkNBvYZwifQvuQkJG6FAYUDaHxOT+L4wMUxCn1UXixRE1x9LQADsPo6pyAyxNMCfjFK2jQRK13J1nA2Y/vu1vMgmIe4MXsSNhcH258hM9zcGoVNCAk1TWT+0DqfCZekahSsONMTRACVK9NRDjS/Zr0XlxJBya4oNRcecLZrUIa1hoS9LKWr6DieMX8aQHvcaQXIWi6CQHnB59bS4YT5iaZ2k89RuP5Z1haenHvjhV4hmXJ9FIlgl8/rc0WP+M5kTXqnFmAfAEr1gJODeR2Yu2sOSsY2+ycnHbQPi39sP55u9n+K0kNm07oeMzDPJOk2hUIsLz8xRE0jbW/JehZE771RyYLRlTmn6QqltrvmH1kaiRwlKy8K7wpfUBSyogLgxKvBJJAQwts8YZVroMZUFVIhWB8LQMOdWpxHeYOTcWOi+VGuYx75wt3imJ4ycdvFToIOJi+y3qdVOyFhN9rjt1FGUplpg3TTMhZk9n8hYsleygzYuSd9K5ZrJ8tf5xb9ckQZJcEoZvVLifQLD7KB+A0MrlbaummpfUkUXqVtk6saf3KR6DDzbg8XGs4WNcpCkI8/76ty0VSbcQLANr4jGnetLuLYaPK8eEbONgCs0SDpPGWqKv5AQwowAVAK0cc7RK/w7Jeiq9aaXxp6tJwEft0maqZOmrY+aKW8ygOGb9ZSIKsOGHNkuW7wfytwP6iOhghCEDKDXlIaByW4JM5AAlguySfTVsCNajEPqIxe0BDEVMQ/WExjTEc30Tgllh3FpK+XavuYIIOjcoaRRmdFi4VF8zBnyZ5TD+JDVMwBn3
 w2GmOfxW
 wlkc2GuWeMeOg3Ij6dVJ7YPaTEX3JcHvAtNYrm9jJwfAVPGrmvTIIFHQG4wBV9+JKy2oFPUig3F/YDb2KwiVoj5CW0Pg2ybmNgrCwiYCkFXnwIAspyx/5jJ1t5vLfu7IaO+OztZdk7+x8GLjp/e0Q5FIfAYpYpbYD4nES7J4um0U98DFYN0D6AI0NAXJlZqFSDI5mHdUtEp/9c5PmzEArRalfRfnNWkRa7T4OsOYpgjMuut0Inlo78ja4yrlX+2Hkrz/0qvgmniXsYRj6Z9SpiDcAh5slMs93tVmNtZG4UT2TU0tl/W4B/eyBkxvVC1j2w/u7AU8z+pRI/5mJYoXU90n6DYqnkK6BKDkaALEajJn8kmKtT1B8pPES33WaspbKsTnnvzlkshsrjIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:44:01PM +0200, David Hildenbrand (Arm) wrote:
> >
> > Since copy_vma_and_data() which calls copy_vma() intends to reference the
> > old VMA after the merge, it must have this pointer updated.
> >
> > This kind of self-merge is not possible with a succeeding merge, as the
> > merge always prefers to expand the preceding VMA if possible.
> >
> > copy_vma() accounts for this by explicitly checking to see if a self-merge
> > occurred and updating the vmap pointer if so. However it incorrect did so
> > even for a subsequent merge (this is simply a noop so it had no impact).
>
> Took me longer than it should to find out that this is no real fix ;)
>
> >
> > So change this to only check for the case which matters - a backwards
> > merge - and rearrange the parameters to make it clearer we're doing that -
> > i.e. check new_vma->vm_start < old_vma_start (having already renamed
> > vma_start to old_vma_start to make it clear this is the previous VMA).
> >
> > Also update the existing wall-of-text comment to be a lot clearer.
> >
> > While we're here, replace the VM_BUG_ON_VMA() with a VM_WARN_ON_ONCE_VMA()
> > and update the VMA userland tests accordingly.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> I skimmed over it, looks correct, but the merging stuff is way over my head to
> confidentially give a RB tag her :)

Well that's what A-b is for ;)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

