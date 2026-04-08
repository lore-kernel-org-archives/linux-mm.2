Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E4B9105D990
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 01:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162096B0088; Tue,  7 Apr 2026 21:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139DD6B0089; Tue,  7 Apr 2026 21:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076AB6B008A; Tue,  7 Apr 2026 21:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E885B6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 21:09:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 771DC8C951
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:09:26 +0000 (UTC)
X-FDA: 84633605532.18.D7A368D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 926EB180006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:09:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GynKecIT;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775610564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNeRg9ClOOIa/eHcOH5Spew1oosZHs0TBG+NUMh6stY=;
	b=HGg3z96RhZGDsAYO9CCqhqcVJQkEpZjd4zZtai+zZGK0JC4FDqruOkfSn9aWHLt7WtFXoN
	wkppK4LCGnXnci/G23CIGi7xA1OP2CL19srkioBWHI3KQM10hZiEh27HmK2mPwkPfQMmHJ
	sDXhDdXS3TAcTjpmt6MKM5403fE88yY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775610564; a=rsa-sha256;
	cv=none;
	b=uG4ACuF9/a4pmWhld/Ak4sYy05ZOL/EGl64ImhLI52/6jks+d20l9V10ssMwyjPiGmtG0p
	zs+YcjTsObh6kENiuRYIAoMWrabXFhOm2E2aXzUSQAWxowV1TyrJ9LcBSuLpzHMBf/yr0G
	O02YKQL2tz3yMgSF8tpumE6/8QIbDe4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GynKecIT;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E79DD60123
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5B9C2BC9E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 01:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775610563;
	bh=OEDae0ck8DKN0vDv9r+3Ast4ENvDWmcMfFoH6glx71A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GynKecIT6xudSzx+m0kseSw8xIW1JsjiaGNhiiJqLbdE7JnGHSj30UQVNsye04q9y
	 4m5Wj5uoUoAjqmwBIwco8nVJsWGPr5hncI4XXhF/9/+qWtK4VjxkCzVp4qVrLW4oXz
	 RdBTSML1wtkihUQaJiEot9AbOvTELNuvbS3aOq1BmWQ/nldnhqA1NVDwHYdfHcju5F
	 jgxDuJ9QlTnIQEF9AnCLMsqMbCy3lKnGqc6r3VvuQwVv4XsLqt75Zuv4eQC8+lhaNi
	 oUXhTjI/hzvJ62jjhg86debv511xEtLVpgPcn8EuNdqZkqOQd0++dlhz2dKQ7vCSHR
	 OPy/H1iQJ089Q==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-50d880e6fbbso5379401cf.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 18:09:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW1fwRxOxz5ljmCSgF5fjVbGKobSyv+lfY5CokCuWiobtqFLM1FbgWUO8HTa48NeNIWeiK2uT0zMQ==@kvack.org
X-Gm-Message-State: AOJu0YxkDll+ukh4gHXoOhrdO85l3r5l2vqpvkeoDc6IgI3lb8J2etMp
	GOurPGJ4135+Pt0Niy6I08W8FL+5sIs0uxFWYhUubB5LLSrsxXbryBPVqXCOTXcCrkveGIwc9vw
	vox+QhUQzooZWAGMWPmZs+USy90wac1Q=
X-Received: by 2002:a05:6214:c6a:b0:89c:6263:3c25 with SMTP id
 6a1803df08f44-8a7033658eemr258114486d6.2.1775610562946; Tue, 07 Apr 2026
 18:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com> <adUJPnyKp5xDgJBa@casper.infradead.org>
In-Reply-To: <adUJPnyKp5xDgJBa@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 8 Apr 2026 09:09:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wPFtUXMrpjTNM7=e9GsBZ9cACu3NupvkE=PO68O9FsBw@mail.gmail.com>
X-Gm-Features: AQROBzBq3nYYZKeL6y6DdDPgk1S8Lsv6RMbh6cjAf6fQcOmnsGz2KYpjlfMtGz8
Message-ID: <CAGsJ_4wPFtUXMrpjTNM7=e9GsBZ9cACu3NupvkE=PO68O9FsBw@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: Matthew Wilcox <willy@infradead.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, david@kernel.org, mhocko@suse.com, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 3kbjke73to756j4um3agfjeohke8a7kd
X-Rspamd-Queue-Id: 926EB180006
X-Rspam-User: 
X-HE-Tag: 1775610564-561348
X-HE-Meta: U2FsdGVkX19pRof6+q2ZlU9yquQ7BMVkojffTfka+2sL2ZKyrnlu9VwG+ZHyeai+iYO6HlNvaNoj00MsKIgcfeGoAKfxqXQNuwSHL0LfDUP9M0RosOLZKmYRYybi0srEieNeLvUiTzKK+kAdesy6XlZzNvW9pfbf3eHd0Zb5t+qfqQy42xbRvIbI9bhlHHm6dcKlxHLgo/C2UhMQPg7yoMs52f0wIg4SkTQ8c87yOoH/m8gN3L5Q/mFGV/T0OwWOJo6Pvasxuh0wmZi2/UAKZab2tX+uutQuDs0fx/QxQlm1aDi++YddC24gUj/NkMOJphfFYVKKBu/Ghm9U7Z36bbSYbhT6NMRcXHumK8Cw4rQ66jrL1r/FyY/eXAPvpjw6F1tWMn3F5J8GyZn+Czs3tB5sF1tft9/z3NBBbkGny6TqM5Jpa9Q43+Zk58EfAruOwcrJh0fGKprKvxKL9bAFvGBVGPvIjzXxLA08AromNNMNCyVIA5WoPShXjT6iJTIIInoYuFxKt4jvjbm1SY0DkLwyidwP0jcW3lFdRkKZQwAe/dy+S75qY6mfTlwRUyZPu5kTe5hVUij3F+5D4weN8jHNh7Sz6P38VA6KDmFZesl8mRs5HqxcWjDPtC9crP/09DHDQRgyHoc9SO5FOurninXxL2vnHrUW0AJVJI5fmWVlV+uyZSKFGxSo5kpYoE7sXQjWeb/b+tXTcAdDyC/y9U92Aoa3wOrnt5U7Bygf7vRi3CL+sjyI2jAq9GV6ZStS5Mzzj0wltIUav6fUlJKnNKDDNuFca5AD5+XEcB2rmf+kU03tFxuBqGiaTIAFX+f680s+xg66oYVTgVyYbfZE/qQMfSDPn9KpyX6lH8Dvuu50tpDGXT5bkf5lZklEV5GdxOBGSPRe8cPGfrRM9jhxbK/nQ1YPRJMMqfF8LiHBOmd9rAoR1VXQ7L/ZV43NCoFMtUh8hb4T63suXlSpwM6
 lhVtWd+7
 JpRw2FZ6pJmEyaysVofnCdbhhTVyESAME0jcNtiCs1INaaX3cIr6gtcA0IHTEPsqwHYVoby6Xr8vzo9n82Qv986HexaGB8C6vhMhxn4UZarKPFy28/ofsg0mEBqGJrNOAuVGEzHov2F4wPN69xJTUPkM60oiTtMNkuX7P4HgjeczmEW27TdmqhmtXIEppeVVg8KU1Zf6eKWq6eoH+LqtuWFOx7OoO8KsFwhXikKDLLH1bX+BZEDXLowDvBWNb+o2BbgiAN14sBhfWOnc9pl8pfuuPfLu/y6JcwQtxeRTe4aitlTjAEI7fgyGH+brf6rWfMlC60hVbGEeWArfAzYRr+i41KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 9:40=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Tue, Apr 07, 2026 at 07:00:02PM +0800, Jianyue Wu wrote:
> > +++ b/include/linux/mm.h
> > @@ -39,6 +39,8 @@
> >  #include <linux/bitops.h>
> >  #include <linux/iommu-debug-pagealloc.h>
> >
> > +#include "../../mm/folio_lru.h"
>
> This is enough to reject this patch.

It=E2=80=99s really odd for a top-level include to pull in a low-level head=
er file.

it seems we do have some code outside mm who needs
lru APIs:

   1   1036  fs/fuse/dev.c <<fuse_try_move_folio>>
             folio_add_lru(newfolio);

   1    868  arch/x86/kvm/svm/sev.c <<sev_launch_update_data>>
             mark_page_accessed(inpages[i]);
   2   1440  arch/x86/kvm/svm/sev.c <<sev_launch_secret>>
             mark_page_accessed(pages[i]);
   3    123  drivers/gpu/drm/i915/gem/i915_gem_phys.c
<<i915_gem_object_put_pages_phys>>
             mark_page_accessed(page);
   4    203  drivers/gpu/drm/i915/gem/i915_gem_userptr.c
<<i915_gem_userptr_put_pages>>
             mark_page_accessed(page);
   5    119  drivers/gpu/drm/i915/gt/shmem_utils.c <<__shmem_rw>>
             mark_page_accessed(page);
   6    150  drivers/gpu/drm/i915/gt/shmem_utils.c <<shmem_read_to_iosys_ma=
p>>
             mark_page_accessed(page);
   7    406  drivers/gpu/drm/radeon/radeon_ttm.c <<radeon_ttm_tt_unpin_user=
ptr>>
             mark_page_accessed(page);
   8    353  drivers/gpu/drm/ttm/ttm_tt.c <<ttm_tt_swapout>>
             mark_page_accessed(to_page);
   9    571  fs/hfs/bnode.c <<hfs_bnode_put>>
             mark_page_accessed(node->page[i]);
  10    682  fs/hfsplus/bnode.c <<hfs_bnode_put>>
             mark_page_accessed(node->page[i]);
  11   2801  virt/kvm/kvm_main.c <<kvm_set_page_accessed>>
             mark_page_accessed(page);

but for the belows, it seems they are safe to be not in the top-level
include -  I mean include/linux/swap.h:

workingset_age_nonresident();
workingset_test_recent();
workingset_refault();
workingset_eviction();
workingset_activation();
lru_note_cost_unlock_irq();
void folio_add_lru_vma();
void lru_note_cost_refault();
void folio_add_lru_vma();
...

Many of them are essentially MM-specific.

>
> I don't think the patch is a good idea either.  Yes, the current
> situation is messy, but you're not improving things by moving it to its
> own file.

Thanks
Barry

