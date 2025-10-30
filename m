Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6AFCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 12:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890CD8E01C7; Thu, 30 Oct 2025 08:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F38D8E007D; Thu, 30 Oct 2025 08:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694618E01C7; Thu, 30 Oct 2025 08:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3BE8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 08:46:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB08E1374A7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:46:20 +0000 (UTC)
X-FDA: 84054753720.27.9FD5950
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05375180006
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 12:46:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j6k44/F8";
	spf=pass (imf16.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761828379; a=rsa-sha256;
	cv=none;
	b=4qTw1eY5LG1QYmiRjWBatvN4Q58G/N2pVpk5o2Xq3RVozwZ8alIjAIRngvLF7aLNqpH0UM
	Soon71mUdS7YZUQtA3tf0WenQVmyIzAdzhURaOHdRjajWScizmqBuk9B5y1t+1f3WM0h2K
	bXKOS0xY7LwXsXWKh8HFCDzs4B9nQo8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="j6k44/F8";
	spf=pass (imf16.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761828379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aywFaym5MviV8j+hBaTBsO7fPrPlzSx1wz2Rl5oeL3s=;
	b=ni4/R34S/Exp1gRjjQt9kPxt/wi722d1MYDK6b0iVo9r5Hu1GKxKztzR6L/rAvHDcYGLgJ
	uN/b2H7Z0WGbDKqd0v4o1pyMvs+6InXLxTzW5fGzWOjQ4lVVzSS8vq8OCtOPVHtFU1A8SH
	Vk+L/KHnSylX6t7zxGWB8bPQAzgLXGc=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b6cf1a95274so675536a12.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761828378; x=1762433178; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aywFaym5MviV8j+hBaTBsO7fPrPlzSx1wz2Rl5oeL3s=;
        b=j6k44/F8lf8XJp70QdWl0zGQ1fDkdr2yINIZrHB3CyQmIQa5b33V75bWgBw8VQWlHL
         jP7A9V/WgZXP6IwylmZIgyMfxE1Jw8WmnHL5o2l/YYxpE2tE/vOkjm5lPCmw8eKaQ8Ji
         Yt8NKTZzeBRWFw82XvcGhqRWQTZOxkHlRffLhZz5SoAr6h5RfLDKpzAk/S2TG78kcCbZ
         deL6/my/4m2TycLgoZBVy9+pwLTOA5wHKXgsyBDcC4a1kIUPr+TFLZH/fd9Sgx7HPTln
         ETrs5gF94awGHB7F9dg18GXDfmij/U7o5VglJ+45ytusGde2Vwl11RyGlgwzIaxAMx6b
         C3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761828378; x=1762433178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aywFaym5MviV8j+hBaTBsO7fPrPlzSx1wz2Rl5oeL3s=;
        b=gtEGXrETcnL7Zns8YQp3lHiqrAA3NswNucecygCj+xVTOt8V16jdxAUU3VZuuHIx9W
         TlUG8EUZrtp1OlFWWAK2TxTL5D5V83uaWvC8ZBsHW2gQIavs8J5uW4GCCOK1Ekyb939o
         lP5ZhtCF+0atF2Sqfrf4aknYwjriw9d9EnzOpYYZa82Q4+b9jnAohrbRdtNpsL0OReSg
         gjFjtzvEUM0LAnwB4DhB6LVo0POrM8vcl1DPYtiKhNdu8D8Jp49OBtYZQMnp07Z7kKvU
         IAzjgrymLSUuVb/VecehulrBTQdg/KkQjdddGrgrjD5NcXUCLV6C0qltZL6Cz2Xso1Be
         AwOA==
X-Forwarded-Encrypted: i=1; AJvYcCVWmyd6LTG9bzKcnzhk7zuGK5SGDMgob+W40wkLkCMDybPMbwghGYaARR8XLnw8cCbexD4xl44J/Q==@kvack.org
X-Gm-Message-State: AOJu0Yxbulop0aN6nxmL0L3vz4DjJpuSKujH9rNwHwn4IizNwXjrrI6e
	SeEKJDSlgpiJDUErjiaurHGIGy27aQGXN4vOukIFSRd59pLtBl/nTAFJ
X-Gm-Gg: ASbGnctnS9614vyXQXvp1avxQ7p0KIfEkvCKfjV89jDqw/fY8AeGsWjBwvocpgRh2jn
	ZR6OduTQt8/kSwPmlHAbozXFi7peYutnuyfNkGKOw9ZtY/a5g4TlprDvt0vur9bu88OwvMCMn1Y
	GJpo75qfJBH4XuccS/Q7aMB95R+4iIAgi3HgPq52BkU3nqSbkd38M8QY8rGJmxFF1ixRpPpBU9K
	VMxHRVv2n1LsTSA0Z+LJScdZ648wy67EuWkPZKswPldzZ+kbNV6v4rdvvP3MSS7rc1sJJYh+UbJ
	y8JDWR5eBtfh72akmxT3XEbsMGnugdc899N2Hz8UBU/tMmHYDkYtvZGlUTUydi03dxUqsW1YvOb
	40rOHlM5sZp3DPOEP8uePB0lyG4MAIAD176Z4VAc5P0bqUl782zZSm5n/LPVVE0dlPIZG7KFEen
	hKmjYOq9w+eaWVWxqPMMF2zA==
X-Google-Smtp-Source: AGHT+IF8NS6uwddW95Ca4xNktUaEfkbRjObW0ncpiYiEzKkJbcnmXQc940NhU/wMgWqGrjJSyPjeDA==
X-Received: by 2002:a17:903:32d1:b0:269:8edf:67f8 with SMTP id d9443c01a7336-294ee0a300emr32024455ad.52.1761828377626;
        Thu, 30 Oct 2025 05:46:17 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2 ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498e41159sm185118455ad.91.2025.10.30.05.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 05:46:17 -0700 (PDT)
Date: Thu, 30 Oct 2025 09:44:26 -0300
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] ksm: replace function unmerge_ksm_pages with
 break_ksm
Message-ID: <udw3ecuflmfmjvfwubtss6ky2kx2g3d4hlhfyl6xlxjkk76asz@x4byag532ooc>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
 <20251028131945.26445-4-pedrodemargomes@gmail.com>
 <bf832253-0052-4ab2-b664-33bec3837c23@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf832253-0052-4ab2-b664-33bec3837c23@redhat.com>
X-Rspam-User: 
X-Stat-Signature: ean8o6jtp76g7dyrxs4otuue8tbhgzxs
X-Rspamd-Queue-Id: 05375180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761828378-477400
X-HE-Meta: U2FsdGVkX1/R65CvbwUq4a9WRpyhsWEF2NLtiLALn48eoq6gNXJDofTvRlO8pFnLBJS+7ln+SAwey88DSsYs4A94CZ6IaBvyGxXEFaVluD2yy4v92skuGRr6/0Qzq05e5rcIXlbF6jklQgv3R1aZ1b8CYYEUpv9Ij//9JrHC1vZEZvihZl8iaUfg977cvAOSZIPQp5Dho6/XvJqoojnTUvgVmL9DA7AYiqvZD1VDI9u/1pwHYMM9dzvP2M9MYOw4gyaYAPKbLzVlanCh/LHe8q/VAc01EuoQYNZTMd4XfpNv5uQ23/rnY/v7suUx4o0FlBXICTdAzlhSUxrGdvNy+UoJ097mCFhg7Qwrp6bJGmfGtQzb++sPgK2SfbUC+jnZSO1SDn1Z89fIn2SCPOPpA5MW+vM5j5T3F003G098vvvNgevbp1CWFALHlXxLlgNiz/xbbon5/P3dYJN5J9A0y3WdgKXTTWJapFEGteOyXSedM80/LpfIMs0keK1JhcblVKU+UWTonbSit/3WAltDSowg+6hKNbopihowhEY63qPwc7FRK0pNzfO/Q8JOnTHGDU72om/6kxMnu3qMzWYYFYvzKau+5GrBeQZ38E+5BrgjBhMmgar1ncn97BJHqZc+sIglMg5m2Vh2b8F3BGVzak7H7Kb0mP0XmGgfrm3CbHJ8INw4HMt1sya3osA9lIcUJYuuJCzuTb8V4VAWNIXbXXjY8kVFPQ4TbQuKdkl00/hNaKJjvfi1QGhIfp4kaltCvQlVX/SFkOE+jo3WvcVmLrs+4uuY0fD5zBOyl4ZFcHLV0GB/dlz/UTR0KcK0DRQKMlngISdCeTgJXXfh8GVo1Dkj9WrnC/pfOwa6nEh+TWZqx9VwR0Dm99ka3l0pGIDElshefnjdIoB7w/Qdh9C45BNBvDeg7jWTKw938PgwP8z0Rp8xqCo7xfugGP53F0TTEaT8zcn+zIisk5D6lUT
 SYFtNyKX
 Bj4o3WDWaJmHexDvzC7KMKPeQghjm5DkrAJ2mIPyS0zb1CMl+SPHgIrP8ZmLYs4CGLZbt/AyrLv+iL+Pem7Pdi5uAcyhSxV5pf3/HDx0OBPkBzKjLXl22+QchnOHGx/7BjB2pOxhw2u8rSS8oZ2nXrmTqoh1NRJF5YWpAE5IcnYn48ZILcCNca2gcHJCpSeEeHQnpFhZT3NhuJ4ttN4haUAEvKB0AZR/UT97t0eugmsHzgoFh/2tEQx0BXs4taPRWtsu+V6H9Uo79eP1JHph+dNYph5Mu/e66oASfs4lGMYkxrgTTnNqU6IbLOzSZx9vOZxJrL8SxkTgk746m6mQyx/CO5iVsT4H6kpoirvcOGvuGs/9XNGa1jtCDAciavEPOKxukTOCVu1C+juvAxVEYrZMlsWMEAHUbhLSgKiFSIXYJ1107ln9oIDqHkfXcacNl8SOS9Qw1ZEWJ6XlybptTywovWkzCqGtzBp0RY2TC6yd3NV9ROHwjgCZn22WI6xsvAeA/vhnI4xJJfVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 03:46:36PM +0100, David Hildenbrand wrote:
> On 28.10.25 14:19, Pedro Demarchi Gomes wrote:
> > Function unmerge_ksm_pages() is unnecessary since now break_ksm() walks
> > an address range. So replace it with break_ksm().
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
> > ---
> >   mm/ksm.c | 39 ++++++++++++++++-----------------------
> >   1 file changed, 16 insertions(+), 23 deletions(-)
> > 
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 1d1ef0554c7c..18c9e3bda285 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -669,6 +669,18 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
> >   };
> >   /*
> > + * Though it's very tempting to unmerge rmap_items from stable tree rather
> > + * than check every pte of a given vma, the locking doesn't quite work for
> > + * that - an rmap_item is assigned to the stable tree after inserting ksm
> > + * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
> > + * rmap_items from parent to child at fork time (so as not to waste time
> > + * if exit comes before the next scan reaches it).
> > + *
> > + * Similarly, although we'd like to remove rmap_items (so updating counts
> > + * and freeing memory) when unmerging an area, it's easier to leave that
> > + * to the next pass of ksmd - consider, for example, how ksmd might be
> > + * in cmp_and_merge_page on one of the rmap_items we would be removing.
> > + *
> >    * We use break_ksm to break COW on a ksm page by triggering unsharing,
> >    * such that the ksm page will get replaced by an exclusive anonymous page.
> >    *
> > @@ -1077,25 +1089,6 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
> >   	}
> >   }
> > -/*
> > - * Though it's very tempting to unmerge rmap_items from stable tree rather
> > - * than check every pte of a given vma, the locking doesn't quite work for
> > - * that - an rmap_item is assigned to the stable tree after inserting ksm
> > - * page and upping mmap_lock.  Nor does it fit with the way we skip dup'ing
> > - * rmap_items from parent to child at fork time (so as not to waste time
> > - * if exit comes before the next scan reaches it).
> > - *
> > - * Similarly, although we'd like to remove rmap_items (so updating counts
> > - * and freeing memory) when unmerging an area, it's easier to leave that
> > - * to the next pass of ksmd - consider, for example, how ksmd might be
> > - * in cmp_and_merge_page on one of the rmap_items we would be removing.
> > - */
> > -static int unmerge_ksm_pages(struct vm_area_struct *vma,
> > -			     unsigned long start, unsigned long end, bool lock_vma)
> > -{
> > -	return break_ksm(vma, start, end, lock_vma);
> > -}
> > -
> >   static inline
> >   struct ksm_stable_node *folio_stable_node(const struct folio *folio)
> >   {
> > @@ -1233,7 +1226,7 @@ static int unmerge_and_remove_all_rmap_items(void)
> >   		for_each_vma(vmi, vma) {
> >   			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
> >   				continue;
> > -			err = unmerge_ksm_pages(vma,
> > +			err = break_ksm(vma,
> >   						vma->vm_start, vma->vm_end, false);
> 
> Move that all into a single line.
> 

Ok.

> 
> With that
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks for tackling this!
> 

Thanks for your comments!
I will send a v2 soon with the corrections.

> -- 
> Cheers
> 
> David / dhildenb
> 
> 

