Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DE8C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C04A6B009F; Mon,  3 Aug 2026 10:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597296B00A0; Mon,  3 Aug 2026 10:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486816B00A1; Mon,  3 Aug 2026 10:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23C9C6B009F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:49:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5DC5140732
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:49:06 +0000 (UTC)
X-FDA: 85060240692.05.E86888A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id B823E1C000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:49:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jb0q17HF;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785768544;
	b=kCkawc+hWZY9XO7gzQhgrhMOAxNYU+yXLLEOqFEyzNYC1VnOwzvFS8/hJVay4KfzMbOwH6
	0NUUyAvSNJGl8iroiNxjmP2J7JZ0he4MRtR7R6H9w+OId1LJHOyT/Vc6ry4fFYN0DGns9y
	sgsMabfuArjH8LL/yicQuk0JsFDFkRo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jb0q17HF;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785768544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPe4gHIdFNPXlT0kLvLSW569L8hxSCoFqSGU6JskmWo=;
	b=k65wod2rvKIcTQOVLra+RhXphkpdAswz59VEgjoV8FJwCcrZLR8pvAJQnpTq1uxdFbekwI
	Lz9OsXaq615EoSHQVFRFniapF4wSQNQvgJhl8HiXP1LiiXAHGVhdzCbVkIRl5DVBV4bHWa
	UAibC0Ub8rdapss0wH5jThFr86GQ4MA=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2149571dso30907871cf.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785768544; x=1786373344; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BPe4gHIdFNPXlT0kLvLSW569L8hxSCoFqSGU6JskmWo=;
        b=jb0q17HFWaSOi3LiQpaiVVI2WWYtXfFnAuiNavCicjocX4JlXbj1LPXKpkBDwcdhk3
         /GsPUowgUkxsZ1a2Q0C+1AncE73W8Vc/u3Mk9EMMzw2LKEIgmV9m0eQDc+o23b6ztnuR
         rzHD5Ax4OzPq9UJoUle8xcMUNcdTJTVoRmQKGr4NJQoZqDdT1+f8IV8d7qr5zIh5Nf9h
         NqZ56WbKjhA7kcXRRzw62rnj3sbH+9M9NP6GZ5xVRL3/CLXBvuilwb0EuW3r2fr5Wwro
         umgl7robnpcVK4/z8d/hqd9HcYOJ3lsrgjAnbCR+PhFYMHjcyHKF4yQuVSjhrB+xwLUB
         pdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785768544; x=1786373344;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPe4gHIdFNPXlT0kLvLSW569L8hxSCoFqSGU6JskmWo=;
        b=GlGLt7XyOg274XGoOSvkUbD9dVVV7BqhsmX1YCA1ApnwwZmVn/fFU8eNfp18r+ESPs
         ABvxPn+nbl17J9GhSAa3p952v9qxU1pacPxi4JHuJrlcZRHhdS+Lst1ta42PU7QuXxfy
         JZZDAulYTtNN8UkgJ0YSrApFYO4kgA07XTOiDaRsIpzd/2LPT/HHISme3rCQA4ELu3E+
         IB7DlD9/qd79wvO7h7Zzaw4ip/hYkv82WoxkDY6X3mJBqI677QkwOWAy/MaOXWbm6PZd
         thk6A7POQWXOuWq1pk9WGtSy/FBxA5OrypnDch6SUeh1RytVVQBuKVxSmcMmT2wNXp/i
         PASA==
X-Forwarded-Encrypted: i=1; AHgh+Rqt40kJS94C/Z3v5kg+K/uITJPxruduWxvRfVrv3Ug9PxVE+jDJnCV2XFwpwBcwU76yYA5lqMQMGQ==@kvack.org
X-Gm-Message-State: AOJu0YwXHPi0Z3H1RSbptX/pnAVCFEJsLX6mp4GfDYw+cHcqVDAkNghB
	PS0Xl8hX4wyRJ6e6kwokY0WFrS6a7HFTPHgDDyRlTxVAN34b087zVVN2eTG1IyREjdk=
X-Gm-Gg: AR+sD12pxxVi3xK18f7tu+6W6hQd0k4GKakY4SuHqwPhsGLNyb0cdPz+H95DmW58ts3
	Dndv4e+GqnpJVBsFd5k5XXu7qfo8hs5DmttaYcSj1Zx6ZVMov9VIicqlkAyXu6XEQcOjp5w/DvR
	aizdNxy3cFW0qUvqISlOLUbSQvTzkXRR5ImeW1Ir5z+RtSwOBGfZGivHjE6GCHrCzeZlP1ImNU9
	W88mL+tA6YBLUbMT5919e8lAm+9AhCYcrmrEYMgAWZZ+UhshIssso55ivGlVoS+WjSDonmCHjZ6
	MoOXk6r8raeI86jKvXJdk49HGdZpK7Y94reJLuPADwJWYNMME5CwqG5KNUQWhP3yzr+r8Drcknf
	bSCCfdaWtOsvtXxDAYcZ2xZrO7xlRLV8EICa5GTs7udIgXt3fTa5Xz0DTnbMV2YXpJuMJTm24Wc
	qfRJUv/atQsJO8vuOUhoKjqWf54RaeWdZgPvvAK4KbPdojYZ/VRRousxtqYFbcZ7x3oQA+oSt9R
	NIBvcll6/XUKe+9yXsrFIjs42ZCly1KxsS34Cs+QQrm
X-Received: by 2002:a05:622a:5145:b0:516:ed02:c85d with SMTP id d75a77b69052e-52b5666f9c1mr211511451cf.3.1785768543910;
        Mon, 03 Aug 2026 07:49:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4eb96ad0sm62590271cf.23.2026.08.03.07.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:49:03 -0700 (PDT)
Date: Mon, 3 Aug 2026 10:49:01 -0400
From: Gregory Price <gourry@gourry.net>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Byungchul Park <byungchul@sk.com>, 
	David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Matthew Brost <matthew.brost@intel.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, erdemaktas@google.com, fvdl@google.com, 
	jiaqiyan@google.com, jthoughton@google.com, mhocko@kernel.org, michael.roth@amd.com, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
	shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 1/3] mm: hugetlb: Consolidate interpretation of
 gbl_chg within alloc_hugetlb_folio()
Message-ID: <anCqTkQsgOwy_0g4@gourry-fedora-PF4VCD3F>
References: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
 <20260803-hugetlb-mpol-interpretation-v5-1-af2b7089f8a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803-hugetlb-mpol-interpretation-v5-1-af2b7089f8a9@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B823E1C000E
X-Stat-Signature: 4fgono3iyyx7bqio9inhzet8mu3am6i6
X-Rspam-User: 
X-HE-Tag: 1785768544-797972
X-HE-Meta: U2FsdGVkX1/5wearR3QFPwniEbw43FySbOVu9tFxJEhS1n2Z4MMHxS/fHmZLBd0Vl56LS1SVHIafU7ySPb797QE/KLOHHO8t0uCix54tWq1MIYPc5UGCdpy2Fw51wHGXYsnjfwn6JcQslZOkP3Q4YQwg/6E4t1DiPjJ+4b8O/nfE6S2JOq/FoTtn8XAFL5ptB9uEu4fOdSZCr6cdhDQ8N4PvazLWhGXtD5xg2cyM0SpadzW4TAeQphcyoKeko5cwHSPDazhjGv0mNOswRMZ1PastysiIl1/J3ckmPcjvUcS/Pzg5I7iom4KBPTMpwXUvwTXph8W8xhE9mVL2MfJ4Ov7QYV2IU97SSt5Fc7nXOdkbgvlnYdoXX7Q1tvmKkulVtTAvnvmaTP+STE9Lj9hQ30K3MdDvUCJ/j9jOh8ntD+YIP8apkZbbGQKMxd2iXnwkZ9OKyGW9PTP3d3+JfMUH9XOZOpiM/BwGGtnnPIMqLcD+2xvjMpnpuuCDl9rrMrAiJ+X4NYsV/qAz80jf/uvK5HjNCZSnS0lfc7hjpoc/DFj2yEQ2nLywEKEJPNJ9NUf8oim27k++BvUnpMQf/gQ0PN1qy7wLpePSD+G2fGoaeh4iLenIiYxzV+EakC+2FSVG8Mpwhk+UTBO0sThKhfqw5YnwI7PSAiw89ogjhs6bjKtBQI08HS684MOYyLK8XPdoPYfdNx+LSJJxiUx59G90sRkxEdSKNwDKnZHC0xIu1Xv4vzYl/7JvPfygST5sGYYNQgrQLHYmPXjplHuYUCl1AxwgHL4ste9xkIZ8PA5nbEKWMtdH6No/JRzopWks55Gi0ZtggwHq38OmRtTPYHvPN6QK+2PFv5I6V/lUbewOYSai7iFSCFoNT+1X9KqvArybM4vKD6ATNAIt0gz9l2AgWgLu11fKCM95jOiBTv8ENEuMshHZNRaLwIFMOwr1oel2Nz/mMWJmavHbEUw5zlV
 qk8LpI3q
 YlAhs+KUVym4e7AWUcvvJfdzSPusT3EeU71wPr6DT7y3qB6PSERTzSYtXmy4PPFf2Tmmw/dkxdmiNg0pNYnI5C5YGc1gf7I3cqklBIpwkwMeCxrSEbxiay3rhkDXqIxSf3omEVWsWd9EMsMZrQwVjK4zIXxs7DfCJbLLUQAGz4UsI5RvnIN8TNSwJgiJ6UNB+uqh4CTrXUe+P/Ai/5pFvCqzingROpJKNVZdrKTDa+2PWzjJk2U6v6gsNZwaZlQ2FovENt4e/GSNRFmjO9jSGBbugEiAnliOjag+ttg4fpmvHihknl8nKDZRnClbGPfKiOIeN3+b5oWYbwKq0IAk4U1F7971uH1w8eI4kyDyzhasAf75MyMlvehK8WCb9qMI4r/jWmcblJHD+KC4LqROIO90OPlyWXfkp+BIfcKTbd7OXN8+9R+AkcE5NgfSfXC/98m0jff5jkeBq76Gjk2hZeJL5NhuCYFHHv8Vc0weRQ0APP1mdaaiYGdKByjhLitbCu2QfB1jVLdsuntF6AJD5tpQBBd31HS4IzYYRBWPbr6SV7F1ahedEOF+/wtlIGokYZkf0ZCUshqLcpDinC8NxCh5A74tXVVm6RqqSTChQjVMuNtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 06:37:58AM -0700, Ackerley Tng wrote:
> The dequeue_hugetlb_folio_vma() function currently handles the gbl_chg
> parameter to determine if a folio can be dequeued based on global page
> availability. This leaks reservation-specific logic into the dequeueing
> path.
> 
> Relocate this logic to alloc_hugetlb_folio() so that
> dequeue_hugetlb_folio_vma() focuses solely on selecting and dequeuing a
> folio. In alloc_hugetlb_folio(), only attempt to dequeue a folio if a
> reservation exists (gbl_chg == 0) or if there are available huge pages in
> the global pool.
> 
> No functional change intended.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Gregory Price <gourry@gourry.net>


