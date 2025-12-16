Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7CFD609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 17:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02576B0005; Tue, 16 Dec 2025 12:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86496B0088; Tue, 16 Dec 2025 12:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A2A6B008A; Tue, 16 Dec 2025 12:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFDD6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:36:22 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1E8E5BB016
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:36:22 +0000 (UTC)
X-FDA: 84226038204.20.E388EBB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id C308D140012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 17:36:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAUPFKFD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765906580; a=rsa-sha256;
	cv=none;
	b=3LymO+YQOMl5Rp9GwwhNYC7EIBI/YObfLjFpKxK/5Lu+HAMnh7nut/uXt+f3iIv6sgYlT1
	MLmoALzeVbOLQp3Z/ogP/ToPNGclhZI6lxzNJ0R2dIi5+8+dw07Gm8eq4ROVQNRFydbAQn
	twrfI4MBj4xwbqSqEXsijEouIXjpf0o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iAUPFKFD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765906580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
	b=sfpllPI2uumHX7fpx3CQRU7GMB6FRExjDxWtTpFq6jBdy4JygYigX9PnqM/InSt3PSbSUN
	Kt3qPGZKnIxekJCknbHwLM7qSuhz5jgFaw50EqTYh4zlFbyU1JquZ2Bi2C865ZBX77FTGK
	Y15ShzOjGLxwslxCTFnji9u2sKE1CZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765906579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
	b=iAUPFKFDtu9ThrqDwtpyplxcRpe2VvrprN0VrzELom6O9YJBV6ifUB6ENZMQ98Utz9a0+g
	IxbZHidoA9GHcYN7OgtaA+9CYJ11kUezjZdzxZ3Y2yon30iLK7BHw2V0S4LcEPQ1Yq5IyI
	SF6iXaxajV87EmdMm9O7CAtjIMF3Wu0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-qd_hTRemN0Kg6k0wZPKrUg-1; Tue, 16 Dec 2025 12:36:15 -0500
X-MC-Unique: qd_hTRemN0Kg6k0wZPKrUg-1
X-Mimecast-MFC-AGG-ID: qd_hTRemN0Kg6k0wZPKrUg_1765906575
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b24383b680so1749627585a.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:36:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765906575; x=1766511375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsPacWIswoNkPxm/WEWv6XOaNR0HsYkw9lp2v40LAGM=;
        b=cCXFVyqGWxPq4+RQneZrGm9KQ7LvCe2jqnEjNDcJZftRxYRWRgRllBvdUx2OITS28G
         SqW/k1lIkoBu+1NN/LWYEHsKdgqW0rzeySPRqNk2u+v+SqAiGcOoW6TAwxLqulgOv7+n
         35E0mldDsLEPCdm4xYlhR8QsWTOLJTBsA7BCadm9msvdfP/ZfyvhiMoAQY6kbB3xzlMo
         BncijFc50uPi70HTcpJzUqaGJ3jNwOZSEUvu75pbk73o+mA8ALj7/w1fI4k1sQebV+96
         MBpamMBvZ/Q7IkNKXiqkq1lf0SV8fP4ZsWNCp9LQuL9k8Ot+CeT0R4CMqTHPG/TRP89L
         0NPA==
X-Forwarded-Encrypted: i=1; AJvYcCUe/J2k+lTkVD6VGMcGdSV2vxN0hlvzU9/KbsVPrlSkrco3Rbl9NV9rtLif3QIEXlJbwbs94Vexpw==@kvack.org
X-Gm-Message-State: AOJu0Yz4k/7/rxboPOoGvoNbWijEMsqN+i2nKzP44N+N8biC3ERB77Ku
	vLFI5PnwoasihBhCRMUDh/L9ByxNpyUKP1078FyHupFBx2z7iJNaPpHzgJd5+MWTz6K88d9SN0u
	bePdK///XydEFdTTJ2tQIMpcuLQe2fP/85IjLkwZmq8gS8LP2Ijo5
X-Gm-Gg: AY/fxX5d8uHAB3QYqknhJwgmSy0A7G++xRyXrrSRQUBFXLDv+PEhOzXnuMYoVigGcfU
	jtW98InCJUU0eF0eEJ8Pc96HhCaz3cPX2INbM5jKfzagCCnKANfIkEBhryItQK8QE4eJqiiIGjq
	7t/OSVbn1PGHkhSN7Mhc2MohZYqG3fRtwTcXn6neuVuOPfX+rcMtPrVZpflrqQPZWIPYHbvB6Hr
	roRqhYA1rzQKnW6favzjpH8jTzttPRRoviMJVKYlBT6o+eIPblPOxfzAjpcHgaslT0pleTDltZX
	LfEvG2g6+2h9UENtri+zOn4Hd3jAoKx2WB6eDghUZUE7+aJepVTJuxlsOoyvvCE0PjT2F9WmDX8
	VyZ8=
X-Received: by 2002:a05:620a:448b:b0:8b2:f31f:ae20 with SMTP id af79cd13be357-8bb39adbbcemr2032247585a.24.1765906575314;
        Tue, 16 Dec 2025 09:36:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrrAnQyi8tUGXbUTgBDtrC2LqsXXW6sIsNBRadKPa5Jo0RMegb7ho96xN3vIijiKehMDr3nA==
X-Received: by 2002:a05:620a:448b:b0:8b2:f31f:ae20 with SMTP id af79cd13be357-8bb39adbbcemr2032243185a.24.1765906574822;
        Tue, 16 Dec 2025 09:36:14 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8be30d8693fsm225390785a.18.2025.12.16.09.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 09:36:14 -0800 (PST)
Date: Tue, 16 Dec 2025 12:36:13 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUGYjfE7mlSUfL_3@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
 <aUF97-BQ8X45IDqE@x1.local>
 <20251216171944.GG6079@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251216171944.GG6079@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wAGwvIw-2RxKiuRM4oB4Pc4GT0Vmu5jw_lZ1po3PDrw_1765906575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: C308D140012
X-Rspamd-Server: rspam10
X-Stat-Signature: 1wy84pgpcxrd7p6p54rfr6xo9jig31zb
X-HE-Tag: 1765906579-800747
X-HE-Meta: U2FsdGVkX19juYhrl52t41Lo7huha5ZajqFYP0+Bkk3nKWq1i2mz/KWtKTUZYXdJInAHdzK+ue8juJsNMZaeC4M/j+yO2nk1dkqvZfskfja5x3+KDIJbkyUxiGWHYv/fXGJWGVw0BGESO9dRJkStnD8S9aMQkxfoY0SOAIaTQpB+72FXDXZ9jbrNkKI0WP5QWw5CdXu8YZ37spY4ZqAWHLNUzzRD5Fqfhayhx6giOuNsZ0hRP2glU/3k0CIAXV36W0pkYEN/tAttCyIheCjNpVjSZaZ+TMDhnOsoHZAXUqy506eCq89wjy4aafIo6/I1yy3MStJO3ptC/5Ci2HmZUNCWyFjkwL0rjy2CeVXJ/MNmpTyv4ZLuAjmAa8GXXjWyo54jGsJCev18JbbWSb8zUbzDN6iEdzxpmsNyt2a2xKQRONVE3qty1gCN/o/wMpyxIZIneSQPNGy/brWdemosqALTYNq5xFt3RQKZ7tfqPKUurUy3NEfgMZXdC/tezUmpvTo49gIyLcFu1Ovc5MeQHUxC6NPYp5E9ABN56f7m6K/HX28TjDgTHPZeshQgQJ4jniy+lPb7xW/cXQ1wWttRPKmKv0siQC9tLk8vNCujx3v9DKSqRjwpSTNLC4HHP9OdKtxdFftOdoXEp32cViRnfFtYlrsO77P3S6MC72tU0WxfOHf8KM9wYqrXtiYMHDfaS5d/IAA2+3AZ3ZhyPiA09B1C8xDy1NbEDA+b/uW9m6zwsN8jicZORhfnzz+oVzssfaNWIvPZXIFx4hJGbjQ2D9m4jofOkC06grPIniwk9XOyE4yqRpVbOaXFHyPxektQL7uVjt9P8YU5mvVjBz0DN3AtRnM8+iMy0aJ4NQXk/eR8cvuz9AZunwyJnLDZJffsj8KfPVACpGtxLeeepeQHZMuFWcwYjYlKUOKyoorjSQjt6BZtqQ3MDx2IBw3LLmIcG7Wb7ULa6oxr6Bhx/xA
 y8Df46my
 CGvFPtpzyru2b15nWSBxMYSDrpS9GHbNlRM+bqtWoeR3JsbIaBzTozx1xKJMTtnzLkf+cNiEqY3RFlNsoSXIXAjE25iO0dd67bCCp9AkVOvZxsZ02ecaAPhmTxCNkn3OS88gt0YcxJpDvmL/cDv6Yl2Xb5vxjBpJu6Mg5NO8O7S2OUuybxT2RCSi3Erfj/eLsDAa8fzzyTcUdMWwsfXolVbLiCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:19:44PM -0400, Jason Gunthorpe wrote:
> On Tue, Dec 16, 2025 at 10:42:39AM -0500, Peter Xu wrote:
> > Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
> > with len_pad (not len), and pad the retval at last.
> > 
> > Please let me know if it didn't work like it, then it might be a bug.
> 
> It should all be documented then in the kdoc for the new ops, in this
> kind of language that the resulting VA flows from pgoff

IMHO that's one of the major benefits of this API, so that there's no need
to mention impl details like this.

I thought that's also what you wanted as well.. as you're further
suggesting to offload order adjustments to core mm, which I tend to agree.

Here the point is, the driver should only care about the size of mapping,
nothing else like how exactly the alignments will be calculated, and how
that interacts with pgoff.  The kernel mm manages that. It's done exactly
like what anon thp does already when len is pmd aligned.

Or maybe I misunderstood what you're suggesting to document?  If so, please
let me know; some example would be greatly helpful.

Thanks,

-- 
Peter Xu


