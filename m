Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D11FCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A816F6B0005; Mon, 18 May 2026 16:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32216B0088; Mon, 18 May 2026 16:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947456B008C; Mon, 18 May 2026 16:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84D0C6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:42:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 376C01C20BB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:42:45 +0000 (UTC)
X-FDA: 84781714290.12.FD46EFE
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7730240010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:42:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g81AO9gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3wnkLagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wnkLagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779136963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEZiI2mCaxhF27MBx5FxJQ+kMagKDbcRpCU+GTF0M5o=;
	b=1/MLt+DXP/fBQKSVjWG22lBhuC+s6tPnbPSOKC36pSdBXPJrXfLu0dzKIW5Z3JA9GPqVND
	ktHEAa0mbMawsdYxvO0LBKlW6q8S6czW0Bu/gXXoOIuT5P+DpPNHcrhHseFVkJGcsA1TDd
	eACCPGpvdzyWTenJcF9HFk9nWW3TZZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779136963; a=rsa-sha256;
	cv=none;
	b=RWRPjCkz3WTXvPk8dQTYTRBVioAWDnfM7lGHtUG/c21kkhjU8WufYMA1MyFuKtWlvstpT7
	GJFnxJu55SHeeAiKuJ34IzwSZNBJjW018Rf5W7HlMXtacu48HPO6DOZHUyyfvbmgdcMmC8
	ZM/ra6e6nPK7QQDHzXGBmM/7iNj7SY4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g81AO9gB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3wnkLagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wnkLagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bd5b20aaa6so30919115ad.2
        for <linux-mm@kvack.org>; Mon, 18 May 2026 13:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779136962; x=1779741762; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vEZiI2mCaxhF27MBx5FxJQ+kMagKDbcRpCU+GTF0M5o=;
        b=g81AO9gBFqHFlvWcqmr2jqriEqlA6znNykoIncbRZ2/CoXK2Q2GlK1enIEeb1m+MC0
         MQu6zqscmNYMzrak/hZ2c1O87tejg64dKr0/TAT5npu89ztSJfLGpCsiimXl4TN6uMkm
         LewOM6UEkdpyMrMWTVJKVr4n6jGRFMOxDhImfVE2+5mBFoKTI71neryiXX6ogMXJK9lu
         iOm5vskdY2kWAmNpDk1lJqxS9998WzvOaQZW8XGxXfvAqw/vN1zyHoaOqGhjQWF8bPV5
         18niJ2IkslmzfqM/op+oO8xiyCj01ussmTx99e8e7X4TQxDG68uV8pwr0y3wpqQuwTMp
         zb6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779136962; x=1779741762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vEZiI2mCaxhF27MBx5FxJQ+kMagKDbcRpCU+GTF0M5o=;
        b=bMzq7zhwoJz5ApaP/CnEG9YHGWNCbb9J+mgVQmemqT2T4whmeiVSg+FZEB59lefDh9
         Tki+uKU86jwnckAq+DscjeSjVc8lobH9agvQE/pqkaFS1HIGPZNwRfkAVchFNB1dv/Jm
         IEBKI2bGc+eFDZXPVDfnhVC0Xvn60hTJRvJ2dS+Nxs447n2DJkSJvhTCFgblA++vPAsT
         3xMOuBZupkJwLyfsl+DBcxWUZ3UfPNyHvAyYqaOlrXUKl3JkHCSsnOSqCKoNarZbhJVZ
         hRGTY40qsDmPToE7oDemhVC+a++QSjMYflSnGObUiJ3PudAuRMGxPpNBALKJXYiH3lLl
         f5AA==
X-Forwarded-Encrypted: i=1; AFNElJ+iLKK3zMTuKb2ChIPlckVJVnuYSW28iBNALw5nG/WJi8NNyM7xU4Oyi08I4oHh//Mo8NltZryPqA==@kvack.org
X-Gm-Message-State: AOJu0Yzf0yrIPdClSmhgUfyICbWqN0YhF0+gNeibs15b84t8hEDeLffy
	v/qDmwgxkPFtZK5ByeaJX/jRVhQj4ZOyJQ60OuOQUTNfITysk3qXktutCd6lj26n3cyTxem5K7g
	m6xMWcg==
X-Received: from plsr2.prod.google.com ([2002:a17:902:be02:b0:2b2:48d8:c695])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c43:b0:2bd:c310:f7c9
 with SMTP id d9443c01a7336-2bdc310fd7fmr94710675ad.2.1779136962102; Mon, 18
 May 2026 13:42:42 -0700 (PDT)
Date: Mon, 18 May 2026 13:42:41 -0700
In-Reply-To: <CAEvNRgHd4azPaMddvqnSG+Z5fmg+LWd+pz=LSB3PrJTW618dww@mail.gmail.com>
Mime-Version: 1.0
References: <20260402041156.1377214-1-rppt@kernel.org> <20260402041156.1377214-14-rppt@kernel.org>
 <ac7oE_1j6gxf8OKT@google.com> <CAEvNRgHd4azPaMddvqnSG+Z5fmg+LWd+pz=LSB3PrJTW618dww@mail.gmail.com>
Message-ID: <agt5wTK5I-FvlB57@google.com>
Subject: Re: [PATCH v4 13/15] KVM: guest_memfd: implement userfaultfd operations
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrea Arcangeli <aarcange@redhat.com>, Andrei Vagin <avagin@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	James Houghton <jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, tarunsahu@google.com
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 7730240010
X-Rspamd-Server: rspam04
X-Stat-Signature: 34frpzccg7ddm76m4kfbddqkrokh31zw
X-HE-Tag: 1779136963-964944
X-HE-Meta: U2FsdGVkX1+0pHXXC2Tm9oiRi4iGxwHCnb9Cg+Loyq28mVffp3GANur0W+3+xEHNuhNaDB7QRFypZo4qpPJB8DE/EwFcYtJDc8GKcce7Pr4xCTQWmm4zpfVql0SA8gExjAMR+TqRL7Ae4IZTs4reAeUkGsYcH4WcX6enDXifXyF5WlNqeQGPoN1z/SLrd9C54mJ2XVoe4VBSIpkbgSLrhiE6EdWa45bSQM+UBJ+sycXE/JsznSiRm/z2u9V7Y38qIRlOHobK7YCADY8erv9SvBy/5Mgyg1WNh2nFd46LqOMdf0qaAFXtRyWUlqsAOnTx5B9pOHHoBI60eqMRibHuydxxCkUM9wJwRaiN1u4iQRmOFQFL7kstqo88iF7ve9fbU8qPNHiBDZXAF24Wtta6Z/gdM1bvkr+5/etlYiYLtkuCWmIDDfIUHtsfPgWIuvm9Xko3Kvf6AhqveiiSL3DofvATlJdC0inA6LY/RLyCp/asnym6khFi/TpPVddzLQuP6B4O+p4UduAogU5IVzrIudSrwEdPb8MZX4QpjlW+6zj3oLa1419PgwN1fZTAi/V3aF7EO7cGMAplR9oXaPu6tk3dG7eLTZM5Nju40EYkzYUwr/smYfC3KblwSbA+Am6K2Xu5WVD46IetQiQFcM2LyTchc+OxJHCjIfMxO6BjcCmEbsnJe2/ya41lkIGPVEW7TJUjpa3XiaROtZ9yt8DCsWiQiVelAUdbjCTYU9pduU+WezjaEqHhhhbnvsqEYv5CyNUs6IAJ8Fr9zW0uhiRhvjoLFuzQln2StNR3FUbmgkUkM0tee5EtAiA3KQzUjjeHdTkCrNXqPIk0wmgXLSMzF2/pmhOb5srFcW8AjykuZT+S44fOjsF3mUFzG0cKSMly3GMQVJs7wWVLFx+nkDtnk/hz0zKW5XJD4uPcfKao8DFr5dSNjn08rLnyc/JwdXo/2WkcU2vQtipZUE2KL3d
 eR66AeXM
 /2MsedblmPL4aU5zZyZQbVYoQQPxXqKELxbdnPc+kSAyv+ZXYOitrhz4IOztGmZ8dYYldsdGzErLRPGqmpl1Pt2hH7praS8umezZMe5Tjlg99CjV7HFFEFQa/RxxRzEj/NdIJoXYNxdoM3MHV9wEW35ZFsuqr6Qo9MxJsEH8jqy8JI/m66CMM+ypj4L9TEYJVck1S3MTMfG+cd9Aepgn1rrkl3wythhyPSfZfBMWOQiPw0BzlRksp5QJvB+lGL6KZq8OxlcQRWIX8xujcqFAFunUj6UXsiPcVoP7uNXYPGhwg9epqaBcKDxvRXcSse+Ki1UMVis/7ptb+8GLaWzJWMal8FBqiKdQlM9tR8fzOh325Q3wKHhVKstMniATZb9maxKEA2kn+WTAEdUGFCQQ6r1Yf1/7IShDG8RHOW0VPsGbaZPZ/TYY90FvhDcclRJTFndDgURjXOnxaWWnAuHkY5yfkDR4JvpFvUPAkdZgttTpqAwdi5OQydx/DJeI/unSy22ZbdISbuTDWxd2MmEuv7EOTUXcgPXsq3q2nXBgg4q/hywKr6aEsPvSfklEqu5m1SvJ1px5qRmIwEW9Lu9aotFR7MXUV0r03E04OQYGjhF6pQCk6yw6anL5uJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> >
> > [...snip...]
> >
> >> +#ifdef CONFIG_USERFAULTFD
> >> +static bool kvm_gmem_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags)
> >> +{
> >> +	struct inode *inode = file_inode(vma->vm_file);
> >> +
> >> +	/*
> >> +	 * Only support userfaultfd for guest_memfd with INIT_SHARED flag.
> >> +	 * This ensures the memory can be mapped to userspace.
> >> +	 */
> 
> Is the principle here that any memory that is allowed to be mapped to
> userspace can be userfault-ed?

Yes?  It's more the opposite though: memory that can't be SHARED and thus can't
be mapped into userspace can't possibly support userfaultfd.  Six of one, half
dozen of the other, but I think it's important to highlight that there's no
judgment call being made, i.e. we aren't deciding to support only SHARED just
because we're lazy, it's a hard requirement.

