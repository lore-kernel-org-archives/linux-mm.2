Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A56606A337
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=YJXB7eSh
Received: by kanga.kvack.org (Postfix)
	id B0D246B05BC; Tue,  3 Nov 2026 13:33:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABDF06B05BD; Tue,  3 Nov 2026 13:33:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D47B6B05BE; Tue,  3 Nov 2026 13:33:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73C946B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:33:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFE04C0512
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:33:05 +0000 (UTC)
X-FDA: 85394654730.04.034036A
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 46A37140002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:33:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YJXB7eSh;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/5qJJsssWC2R10WR5gALUBT4DU7jOez8BymVy/deKE=;
	b=lu4/7hN2MdNJuL+ives23cGdsvfyDMxWGRbCZ/M4tgrNDW7ta4x4z2ItNs+LVX9vtB/vY2
	vlhhXyl1HklVKHHOjF1L6xUNSdgj4rvOZ1oS6ir3SeqHISwCU7+57O3GoN5O2rk5Iml1UT
	T8FFkxQWAkr+U7dyihew/jmBGGjXIsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730783;
	b=S3+84gEVeLAT+NWI42w4EV1RCLbGelBiF+GVAvKDJTZrhNQChnjMn5Np/KvQNbJu0rVvc7
	IYropoXH32yk5ycsnaeN9xsRcOvkG8BbqzdvDznb32dfKoWdIDAi0016cyvMyTMYwJQygI
	f3y7ZKuYV29B8qD1uZTE9I1dviQPcBU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YJXB7eSh;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b0f59a5fdaso42107967b3.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793730782; x=1794335582; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I/5qJJsssWC2R10WR5gALUBT4DU7jOez8BymVy/deKE=;
        b=YJXB7eShda/9c/o8ESR+RzR1sJbSVZLycaPNZ4kUQitGoU/6qsnG7PchFIRssBFtA4
         /la/3DuYENdi3vS27wkvbZe648qudIrGHZXHK5Q5nGP6fXlVF39HKTYC5j6tBrjmJ9VG
         9HgOUWinOai1qIKHx7pBpbNzhTFl9gqBAUwaSMVFxKVvIrr0C0XCwF0PNNjuqB9aRWWq
         5rdfPCeym1mVvdmWDQuGU+78ia7yQlHlnKQiNXHY16yhjXyva11u1am7o/j/4JmA0u4Q
         iMpIZmWRp+/TtQ909csm0gIPpdEPdCmTc1GSv16/2o9T4+ArnIXafO3cyyOgJ8iNwAAK
         N2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793730782; x=1794335582;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I/5qJJsssWC2R10WR5gALUBT4DU7jOez8BymVy/deKE=;
        b=uMBu2O2GB0lW6U4RbO7j7Xcg1Vt5JMBK/98b0AOJOC+SzktKu5nbCjUWKaIBD24Yn/
         z9uSiNgZGzsczC2Pw3DYPiRnndi68T6c7bVsatV/BkjlkiY+FQdsqlKlIoAM4VvawXPD
         ugW1bOi4u3c475JTUKTV9X9xK9iilR1NG1NjNOXZieAUnvnaQP5XkzB8MqDjN49wx+Q/
         8NwugkiD2KuL/xbd1WUTQsA1uimrD1XbrTa0JsyTzZbl70OncWpHP710ztnQSMZMSiDd
         xN8S6hI94CBWbxm6S9dzG9cfIaTk4q5nxF2FgryJ3c1gSXCS0ODRku8/LUAG+ZaWero+
         TPLA==
X-Forwarded-Encrypted: i=1; AKwUvBxa5RG+hI0PnrMM4NA5O//Y1+b9dEnAmYd/yN6h8m2Fo8/ZK6rSjDCht4yrqytVpsrM0WwEWrWWzw==@kvack.org
X-Gm-Message-State: APuU4Z9VonuBKklySwC+QQNxrSFi9kPvU8M14Fg+MbU33epfLDECrZ/w
	F7QSUORJlGBhhuc05/B52KslGTU1Z/3F+1nRxAF55g9OzUrvazN88MhEBxMHW1zW2SA=
X-Gm-Gg: AYBFou11X/8DdP8YstDFBHsbKHFIwUkcA9ZeFnxrX8FLO+mgt33O2Epm0n1fJBwV9zs
	BfVLz0v7TRvMrI1UNLJfUsOVFbru79FQ3Spbv/tOB7C0H4ASFeKsD53nG6DQO3D2ewRieiDavyi
	/bS4vIFnAmDPnjxd7jsc41vA6to7s42k05wST8SEjo1Hu/UXSzj9uhujq00v6gVW3TVam/K+WBz
	6g0QYQheKz88qHeHxGE1mVClto5J+svWCbuVHbrNuAcvmWptYh76RDBuxjb9sxFiL2QwQehUlBu
	4/4r6B0b4wBjPFnWAamCaZOU9O5Mxsdr4xybiICMNxaoDgxbVyV39YM7YLwmDyzu5W8jjW+bQHi
	3LUp5TLfqXOGRbPCfaMoZRiNhjrn9Sjf78KYr53+wRc2ivMtyFzLAs/tHuMbp0qvWlmlIPcZw59
	Y2TjpPxolMt8y50BRsNRsXwPoFu6FONg3gXdAVAOBoCJoRE+ODVn6xQGYYwYDuIXEDlDfSBSBdQ
	Gt6gha9ZnbPQqPmnHIeHx5VQu/EKziBVHUy9kJO11IpWFG6BvZMXZtqO7zMBhMGefhBMQ8Cv/zO
	7zyhHoCW0GysN7wGI0yVBLMnam0=
X-Received: by 2002:a05:690c:6989:b0:8b0:ecb2:884b with SMTP id 00721157ae682-8b2b6707c48mr109801807b3.26.1793730782291;
        Tue, 03 Nov 2026 10:33:02 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30997aa84sm2416257b3.29.2026.11.03.10.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 10:33:01 -0800 (PST)
Date: Tue, 3 Nov 2026 13:33:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 3/5] mm: page_isolation: do not take slab pages for
 free
Message-ID: <auoo3KKZxRQ49FO_@cmpxchg.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
 <20261103-pgalloc-ai-hotfixes-v2-3-e0d2890ab74f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-3-e0d2890ab74f@kernel.org>
X-Stat-Signature: anw9nn69kmoeeytwwrqjyis1nbraestf
X-Rspamd-Queue-Id: 46A37140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793730783-711098
X-HE-Meta: U2FsdGVkX1+VaGOiGJ10gEGnIgYPK545gW3EUzZieKLTmIrXhcalzH0Y14fh8rnfjca/LPplagy3Ypkh+2q1GGYW1nvmARQwfB35hSvVWRCBVL6Qm03gdMuBNo4N4N6Z2MJAKkFI4137fw45AgIUVVBzg0oSkzwXDEmKMI2Vf5dK5o/BG7uYHCyQNzWT8HEw4/salKu1J3n5bNYs1S5Ppp08E1XmrFoL7NILiDi1IehHBeGNhxK0XcYiw3Cml+CvWSB3C4jpa89k3Hi5M2655RQ/AonzqXNxYZFS4M+s8FjVnAFYZKLvqFrcb9NbWWt16pnH0qfRUyNq/XPBNEuSjp24KimMx3NvLHoGwZg97r8T/A48k4F2xZ41LQas5idegRDr4ThqIEj/U5K3hfDhQwzTVTQNYZg3H0ByOkezm9Gg/7gjAnR9+Ijwl4nMouVE9jNxFi/xOaW3mm4ZTPPTpzfG+FVHa77zASl9ol9N7x558NeiwOFHgIZ/+F74b1cvcRk/kdnRjeUXbDuV5bUruN79Wwf0onh5dNuYLKxv2ZSa5+jmXALU/5U7GQWZUICEd9lnCsmIDZhkeOwJaOnLBYrKqsZSANHG/YKmEU7ekOrS+XoLlb2Uy3baycL+BcZ3jrJQTJ6Wnx8tHkZvn11M4Pj3HV7aqaijH8yJrozmnvlm2Q9Bbb5xnlurlU102+uivhBTzTuiRi363o3MIaMl6m74VjJ+fBK+eGNo6+27UZCbj9Xvmz1xUydJjxrVdwrNJibLLd31PjMkHET8cCdEIZMd0Ag7Q0hXNxgW8ojhy8zbzEGao/CwTESID4awHzreK38dELvnZVGeNEB8Ed5Svejv5Ier4jYTYQg6/6sUdq6bPYHeMgc3p1J+Jj1Gj75cVnt6cxRpLEOpYj7VR4zRaVsZ0OCBXdaILhv0bq8IzZpu2QvMJlvDMVqW7O2WWmqZkKvWIdDPYVkRHsJ0EIz
 Inn7Pbkn
 5/QnfzzMv8f+lY836RjGwTxDk/Ron0InqiwjOR+BGdNx21wEhjvcd7/yt0QnwPGx69z2U60mlWL2YK8Pt5r73eP8aK4NGlMKB5HNn+OIk3o3YdvUh7pNLIonLB7/wFrIayTuoEGGaA256yYQwCDo2OkmRENeqLt/lh0QsAOrtFD+MriCGNj5ywsnZQMlJFE2OxLYq8KWnUlqrrb7Sm7F4UgRJepvu2VVi0Mrv+k7hNqWkBrH3OZyOv3FWrTVTzhqnQkFVP10ArPp9oqdUXzQvU9NRSHyte1fMlvTvITqU/vfCY97bBoo6he7uuu6j4++DrID7RFC8i5iv7dtyjy0eHibWhh9BlA4GAEW+38VvYqMVExqqXYFDzvIL1vFVyn8eJRRzdivK3lMxHjkMzE1Wlx4g3qiTb2U0TtKDRZfIhZdJKGrc8pyeeRGSmsTMxFkA34+lRkroMuXNxzPPFVODSrmax1hhKVMgzIFV+ZRcKSTJivnOm1zXJyMd72sYsSxClo82R8Kwq/7d+e+xlfMbx6bgTjsv1AxD3O1uNFdfqPENQJn+PSQvTYDXkKAbvMl/OWeVFpE7r2yl3bI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 05:16:49PM +0100, Vlastimil Babka (SUSE) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> page_is_unmovable() regards a page with a reference count of zero as free
> or about to be freed. Since slab allocates frozen pages, they will
> be wrongly considered to be freed if order 0 (higher-order compound
> pages are caught earlier).
> 
> If such slabs are the only unmovable pages of a memory block, memory
> offlining now isolates the block, this can lead to offline_pages()
> looping without progress.
> 
> Thus detect the slab pages as removable to return -EBUSY, as would
> happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").
> 
> Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

