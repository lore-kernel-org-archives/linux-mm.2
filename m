Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB56C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917F56B0098; Wed,  8 Jul 2026 04:56:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF246B009B; Wed,  8 Jul 2026 04:56:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B856B00A0; Wed,  8 Jul 2026 04:56:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 436FA6B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:56:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A679F406F5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:56:00 +0000 (UTC)
X-FDA: 84965002080.06.82CE1CE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC59920003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:55:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fffacYUf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of pabeni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbP35j/x3DTm7o/Yn1OIdMEqiWJ44P60wi1DTKxILpo=;
	b=f6ys9u4ZAO0r5A7DN+wOP1NEUiH5Lceq7RgEdKua/QgEHDgPFc7QikEq2nqJrZT5gitD96
	/llq+CEkLe6Zc6rSnaalUrIeOr5vS7OUs6xmmlhquUA/ZUDP+w9/bXLyaCYIdhfrEB05SX
	MQN/MywTidsZJjX6tjScwC1XKljamWw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fffacYUf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of pabeni@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500958;
	b=0R/onTY4z2ZYSP102RJqfEY/xamml/yC5LOIXtZAM3sA8zjI2pCRjf15gUz3MbUiN2wkMm
	dIDRboX6ZCqHq4a1whWg6ZdBD9PpjKK+rPQCRGlphSoMYjcZSyXYp6HsqnHchR+LLyRtXO
	kyYpXGtACdALvpG6/KCyqZ+OLzZeNuU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783500957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IbP35j/x3DTm7o/Yn1OIdMEqiWJ44P60wi1DTKxILpo=;
	b=fffacYUfhgTW5h6bxzOp1Y+4cSAPeLDB+cAH9DME/CyALa1kBnBSOzCY1YX4+lkk5082/T
	EAZ+3Vp1PttNnunkPcEJDQEYb0rCQALR5SX5ff7N9PM5tdAzq7tZ7Ktg+HVVRtxBQeEuCM
	/qPpH6j0cI48/Y7AB3R7aLWa/9vSsJc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-tNrpGuUeMtObLyegQVGfSg-1; Wed, 08 Jul 2026 04:55:56 -0400
X-MC-Unique: tNrpGuUeMtObLyegQVGfSg-1
X-Mimecast-MFC-AGG-ID: tNrpGuUeMtObLyegQVGfSg_1783500955
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-492488f8583so10774295e9.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 01:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783500955; x=1784105755;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbP35j/x3DTm7o/Yn1OIdMEqiWJ44P60wi1DTKxILpo=;
        b=Yuj2t72lBKA9jrELgXRXcwqG6FH251Kuuw0QBflA5YlmbbYly5kAfvARM5c3Ys9HrN
         l8Wtl6FDnzUKlATTs7udYcv/W8wXqsIGpEKlOGFzPfoeyRMu6rka98Nuh0aB+4p/XdLA
         wD50r72FD4BBCdbntbu23X05ElgF5JaDRSE04DrwXmNHVCWOFxZeBjzI/mcwI/oEVjGN
         fICfQBNnEFAxzdN9KyjLK4x1bGN3aZ4Ake047za8+ZJH52RApQ899Te46zsWKbs5pD1Q
         9biznXm0HVWyb+8hXCZ6PUXptsZhiwD5T7EkFNv4XupDMgsLhjnBSpKMTOih84nAc+nK
         fXQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr2bxe0RD7m8RpIn7+U4BvH/2v4jAUsN+v2GKC9DMzBOXIrZzmmQKPfD/vBUJbdSB0L0Hsa9CBY9g==@kvack.org
X-Gm-Message-State: AOJu0YwuhjHj31lI9It1bbMRrP4ZtK12y+6HZYeP0wjTotuzPjhQGTb5
	n2rXs7DpDxTON644QgBDcRzTuTATTj+ptttPwhmH3xd3DFCPGhUx880xvqKFgHXGBJcbXkmylnu
	BQYfDdKjpMSU1oxGVQxLZRboctSmwbMvmCYK4rPtyIbXH5B2tfdDX
X-Gm-Gg: AfdE7clpqRxd1dcUGKUBVIoZrgDfzxVIwNPmNxbDB+E1PLDaue5skIWOXNwl47hPfx9
	aPz0khnFCjRHV3P0dBSB2rMFZxcvIvG69R1LLdOTMgkH/3byKj6amhyjfpnjyiZGHn8Ab3287ki
	DSaQRqOWoKtfMc7rDrUApqMdKlsUMO4CA2Rh+ljXoU1I6sMsaaWxDFqeAnd3VNiY3k7n29uhWm5
	sd5+lmzLeRvBqggA1rs6T1urWPmNblkji6eKWkMv1uwoGbzvYSxedREZVhk7cfKhf/Is9GfSWs9
	j6zdCIe0vmCmKIaRF1cT6SdlVAGL6RsY41ntRsIQ9QbYoCkIwFHnm+AjEW6zZMaoDBrMbfuXi8h
	qdflAxcHziRk01TjEKfnia2I2dxL4yN+S/f3sBFpECFyaRvlgMjQcTXKh17+xwrrUVTbLT8Q673
	tKJjWeWnTA9zgQ
X-Received: by 2002:a05:600c:548d:b0:493:b8d9:f28b with SMTP id 5b1f17b1804b1-493e68c7f63mr16435235e9.23.1783500954923;
        Wed, 08 Jul 2026 01:55:54 -0700 (PDT)
X-Received: by 2002:a05:600c:548d:b0:493:b8d9:f28b with SMTP id 5b1f17b1804b1-493e68c7f63mr16435005e9.23.1783500954522;
        Wed, 08 Jul 2026 01:55:54 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e5a6240fsm34114935e9.2.2026.07.08.01.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2026 01:55:54 -0700 (PDT)
Message-ID: <3832c190-b5b7-49a2-902d-7f75598b0789@redhat.com>
Date: Wed, 8 Jul 2026 10:55:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] drivers/net: replace __get_free_pages() with
 kmalloc()
To: Johannes Berg <johannes.berg@intel.com>
Cc: Brian Norris <briannorris@chromium.org>,
 Francesco Dolcini <francesco@dolcini.it>, Jakub Kicinski <kuba@kernel.org>,
 b43-dev@lists.infradead.org, libertas-dev@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
References: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260701-b4-drivers-wireless-v1-0-60264cdf2efe@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: joXj-gBLRlNJa38TZx_eOULmI-fwi9Z7IKqZLUld5lE_1783500955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC59920003
X-Stat-Signature: iaqcfur1e5kayf6wr8359c31n7askriy
X-Rspam-User: 
X-HE-Tag: 1783500957-697073
X-HE-Meta: U2FsdGVkX18Ol86Yzh5BQ375NRuA8BiDOM0p3nXAdgXNc5as8TxiQzHbuTBNhy7dX+vndt/RTFAmdf6puW3lsnyXwfnXeifbIgvE2qupn8oVIO9bTXrrOOwlyN5TjYU9tSG2Tbb+sI8WEqaJHG4LbV8aiPLz54RR+QhgPCSh0ahN2fP5Oh9OCIDuPHDmALCUijscGooo0eXgugt9hKaIE43U3eUPDemrcesun5ij/coyvwYLF0eX7qOw9L1ZB6O6LMUKMd8/1LB/1SpAmw0EKZyEYqxYUBqskiEQBFxXpqJQtXPLiXbt4msNpGvCNTAALIpGyYHuHT5tHAywmlr0txQiSp57M0ix9f5wdAR4QAwKencBi3J/79Y0IE587McthrewFcvPuwb3nuGBmuhv9KKdkg7VgkCFiApdmtYKtj+HzVtGi5Kcd8WRBlqiTlhXbEizlBMJfpiRQYP41mzsadX8cHEUCfK7zW13qziU2NrrcwZjPY8+TW27T8SNGYsk61x3m6RMYSen7avTE0toNhfS3Ttqp1mh0Uprje42/5tAbSgJsb4/qA3B+DIIhj5clvqVY1ytIDSYnNx8Kv/idhBNzpKxEM6hzmigsLMY/U4Ks6/6uLWfAWX2dAlKmP7g5IuPtjZzLvui6e1rBaBnWVrZ4d5LTN9tDxXh1vRJALgyyqpyKycO8loWqGoJZUCLGGTGtW9Vqrr+ueIzGm/Xo3fjZSTLbAa28oAwuWYW00kR6/pLqjYD0fPx8iz6A/WQ81NXtZFMxK/FovCAQCpz/NWWNofRpvweENbQBtvtWnwj9BUYicP2i66k/EevN0/EPRdLmUCsMKgS1Rhw+YEpLNGsI+ahZjaKnKxt9vKfr/8gx92laYSr7dqG96CslFTriK7JOQPO9D0jCuVl2HY+Da37oF0AHYLTf5NgfIJUzK2lsViEbTymBzEaviKHjPQJnMKNCJK0+RQw4AEnJhE
 rrhB0hXL
 rBRikI/PGMBXh3Xzeeq+yzXhqDdqNyQrZ4uyzmH7cdcdxzTNLIWJva8xFWz7eQGBZt6lmtXnSkGkZDGOacB2i0ITzSzIGqkOPzhC8fPM+gQMtsiZD9m6kULYLA1ZR3zivq31oRWhsfjXK4bWGFUt++I4jU6NqT6OFOa70/ZduzJatTcsZhbjhLVo3DnRUxKu8M+Aif0SCAYGtAMMwSWrreQBhg8ACuxVXfVHkOb4VUxg9saRYAGVN7TLdxl4BZIATjSs0ovakH9olKxUJjJTRrS0LzlsfTRFP3SXGcOKRCDSbwP9cdDahoRinfw904j+o6tn9Mo84INdITCkhDchcni2rRlqkUn2WYK1jL7GoGAHZXY97+q8oMSfqnCPm+gi9hwrHNZUQoBtmVf00x5+zaU0A+PN4+XZrBmkCetxkhtxDZ7N4vfBU0lHOPS6DOkpz9cQeJq4ruOoEm5HrA1PxJq0lyzmLlAfQ7ISa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 3:59 PM, Mike Rapoport (Microsoft) wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> Largely, anything that doesn't need struct page (or a memdesc in the
> future) should just use kmalloc() or kvmalloc() to allocate memory.
> kmalloc() guarantees alignment, physical contiguity and working
> virt_to_phys() and beside nicer API that returns void * on alloc and
> doesn't require to know the allocation size on free, kmalloc() provides
> better debugging capabilities than page allocator.
> 
> Another thing is that touching these allocation sites gives the reviewers
> opportunity to see if a PAGE_SIZE buffer is actually needed or maybe
> another size is appropriate.
> 
> For larger allocations that don't need physically contiguous memory
> kvmalloc() can be a better option that __get_free_pages() because under
> memory pressure it's is easier to allocate several order-0 pages than a
> physically contiguous chunk with the same number of pages.
> 
> And last, but not least, removing needless calls to page allocator should
> help with memdesc (aka project folio) conversion. There will be way less
> places to audit to see if the user was actually using struct page.
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/drivers-net-wireless
> 
> [1] https://lore.kernel.org/all/20251018093002.3660549-1-rppt@kernel.org/
> [2] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> 
> ---

@Johannes: just an head-up, I assume this series will go via your tree
(despite the slightly misleading subj)

/P


