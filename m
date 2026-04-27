Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3638AFF8864
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CE16B008C; Mon, 27 Apr 2026 17:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41DDE6B0092; Mon, 27 Apr 2026 17:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333C46B0093; Mon, 27 Apr 2026 17:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 247BB6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:44:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADAC78B4AD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:44:55 +0000 (UTC)
X-FDA: 84705666150.18.686B19C
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2B49100003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:44:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7gZ0RGD;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777326293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ks2Lt6yJ3ah4mtlHpB3bqT5HUFjdEUDMpMI/GdsyYSI=;
	b=gshXXC7deB84Chm/NwLL6knILnP8YZUv/k1Gw2lAdBLjxL02/vIQOrRl2qr+c5wp41l0AQ
	Vvkl++v4CCsawTKgjb8FDd9ZWeJZ8NBIJLLclYj4LeHhSW6171T3H0zb2Ug+HLEbmwhYi/
	rjl0mXG7TlDmBGhLE8Dnui8Iz1E8C8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777326293; a=rsa-sha256;
	cv=none;
	b=u01Ovezn6RBEaPdyQ+7GGoYZyF23Y2d4jfd+xHsPn3bPTY2Cod42pKrxcmzv570NfA/Tz4
	0CWtKSBtesBOIHVcPPk4mwVhTet7JxYNNSjlJ66WLVTEET6rKJ1DAZIWZTID6AsUhJ85K/
	TYhUk22sxnZ84HF176P5pfhVxUBcsm4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R7gZ0RGD;
	spf=pass (imf05.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2d96243c91fso17452313eec.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777326292; x=1777931092; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ks2Lt6yJ3ah4mtlHpB3bqT5HUFjdEUDMpMI/GdsyYSI=;
        b=R7gZ0RGDzexBaPL9atAw1Pg1UgNP2O6lhb5ujKq/OGjVoaHnfEuR+nEDIuiGwUZ1Vb
         mG+rxyTewd7mvWQ8vZlDUU95TcMXw0wvcqhsf6HktoiTxIp5NDOPSQ06SaNGhsfWPpBZ
         i4TXYLPqXJHvVw8fWTkYtVHao2xSEfFNIVv/I4qLvxTB93ddODcdo9vvdalWGIIcaFzI
         PabHxN2LCcelk6SGFlYEhdGcr/f29D03gCHDYGiUyjo+b0prutEh1iGDQ78dSKbZ9PYK
         g/YRrVlUyhLUZFeH8FWcrj5Y3LGCItjnShy4xqGVc4baGP1/r97ghGEGPEZ0DcywTYVt
         jX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777326292; x=1777931092;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ks2Lt6yJ3ah4mtlHpB3bqT5HUFjdEUDMpMI/GdsyYSI=;
        b=deyacuhRNsrvme1CrO952VL4aEQequ5SGfhX3Ddfob6TQpX2Lc7seg0aogelMSzL7t
         KCfZb0XHNI954ZmsOgbWg2nUm5N464GdeTfTf6xplx+4KcvYlMPHY3gGDRwzvnnwOKMu
         35TGnej3NtcP4B/N/jqTB7JwSQangtn9oHPRD71NthpDfdoMqNQ+o/ZhpdQgk5vsNh/a
         rJ6VyoWRr84hjPt8vGjLop6DSYBbTs7DAC0lyOTxvm6CNMhzTCu754T3dKe8mNeG4rGR
         H3wMBkU34hx5f3Qs/4A7Iyk+P+oP1wUOQRZoxZBsDrTemHCKduhEANoi6sK6pmzSpqg3
         uxlw==
X-Forwarded-Encrypted: i=1; AFNElJ/MQimNcsMqOvaQJGbQ6pHW8QoHQTkW0UHFwvzD79aUcASuj/BpTmNdvLwtZPf9tqhVzJZ+cDJCdw==@kvack.org
X-Gm-Message-State: AOJu0Ywlede3CPwYBcHFecAjmsJzVDdDSTYZoNQkGCCK1Fj2DSZkySX2
	kcevoaT63MAwwrBQSljd3gzeue6pS4cjHPAtWEUodoEDjH5ZZtFPz8PH
X-Gm-Gg: AeBDieuuGqwRMAU+/7ITFGCU/81KkiJF8Ih949VpFUhzEWtyGXoAaDgJ/2pwwUOGUQv
	cBNMwyE+CbB7pouUHbDIRtZIUyDX39Z1OLB2YbylCF/FMpbJh97Jg/Ty2XdBReBwZB1dnty444S
	sclqmxuGbDNjNkq+MCb7Wppc/jYHLdlHsTAFcPGflc6owOhm4iHIquGO7VrfHca/ElieZRdRzzI
	kwVeKPjdAgpRE09bkGcGFKowgRyBf3XvBKJEWG6ZrUGDzHJRd1wIQIzgHg2F2gTQRc/eMtjB/6Z
	CO04NbeuNZogtWtUw54Hlaz6Y6oTPP4H+tUObj0Y9xeVKeoaXsWnJvLvcje+VCm8HATZYNIuyJ1
	i8HhdglAPML4uK3+dywgf9iT3nSbq7mTFPOZUXepnBRtbrWd4SgQ4HzQhOaGRoWHTYA2CtH+Bg/
	wGN/fMDhVxi7ne/Is3upbz1o9DqlniA18bdWWc1CSzIvfkfYQ=
X-Received: by 2002:a05:7301:128d:b0:2e6:4d6e:2cbd with SMTP id 5a478bee46e88-2ed0a03bbbdmr354798eec.8.1777326292467;
        Mon, 27 Apr 2026 14:44:52 -0700 (PDT)
Received: from fedora ([2601:644:937c:6c90::47b5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed0a13f915sm649354eec.31.2026.04.27.14.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 14:44:51 -0700 (PDT)
Date: Mon, 27 Apr 2026 14:44:49 -0700
From: Vishal Moola <vishal.moola@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-m68k@lists.linux-m68k.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] mm_types: remove references to s390 gmap
Message-ID: <ae_Y0V8WsHPfQSJk@fedora>
References: <20260427105810.23761-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427105810.23761-1-pbonzini@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2B49100003
X-Rspam-User: 
X-Stat-Signature: gnadyapkqa9xgmhb44rgnypozt1tggrq
X-HE-Tag: 1777326293-35604
X-HE-Meta: U2FsdGVkX18DYIMCbq90XFdmVJ08FAeHuRbdq+wQkONzTCjSsrPssccMWQjUvD8axzRNptyLAlmN+qX44ZzHahYDMKDIUlUcRKzX3Pu8+7wdlrFOnCZjyz6ln8cwPTxYJFSBn93d64BI2EfMZNc/OB8GJZ7yeWdZLG4dHZ4M3ZINe1I84nG9YpmzYp7Y0R1haZnCFGS06sPrzTIWUqLMRqYhdIJaT2pW6OxbW7npS0tU4HN0vXy+SG7yPj9WkcbkN4orNAbJx4acWzudwgbBE8JOnLf9K1KV5jViXsDu6hKe42SJQq1hT/kTeAUP/ktqCuWicCoZWfEy3HkKBu1tykpG48Nc+J2BxNT76cHPTGYCQhIR+GZFTfkGh2Extn/2yAnDSPnvi/worik6ucrKYoFuSg1bYCOVTdz0EyjBCzsC/GIGATHJdZv6Wbqr/3pa2R0MNEvUlywDNPxHJG87G1u18Aloiadvkysw9aOzCTOTtBOC4KwqAntRxgRGqqIrobHP+uBYoMn95kJBk0YX9P5HfThgWHWGStJqiTVU/JFiYvaeKsUGTAzkUARpsjgZQ+y9nkp/QxOlRXFHlbuaFr++QLatAOikwBPPn+G6lrTqA5SpzOSlNdqwYTBcS7RsVXrOVR8gfaYu9TP43xiShDMz0TRyyOm85cZ+p1+SFhP+CIgkwMVGCi7Pgl4TL++QCcInZxjKV1yYaT+ZmaiLiEO4+I+5wufX7FOAnBkvOK3qRrOQ3RkF0dBBCKycwHZqEZzrsJ7g31zUckgvozB51RolP29sHYHhitIfGig0tMfEU2328ImOvdgR8ga5J8Bn6u9iWluOh7vR7Taby4z+g++Xi97LlhCbpb3eFMsZVJhHCj46yLysug+oFkKl3i9VpNA9jcGkz/iYbv/vV083WS5FSfeoE1IDBk6s1FBl/KUdO5EZAYAbJfs10inHrfj/0D0ZsSvAjr1wjceyfuK
 4uILtZ9L
 qwunSJt+6twPLUovTODyyPiWWuPrgmLa5vvL1ai3A7zJS/DpTaps17qh/VMI43S6fFdHDjMJWtCem26y1ioO86aEvUmtxJkKgyNzbfG4ZQ/dr9Pcd2nPG/HfOUNVNzo0R8IfX82IeWofCnAUWiOoLi57vPI2zKrtkGAl6fSPb2i/X3PS7WWszyRDyemURTATbuBi+qdwbK7EtP1W1c0KuXkgZDrU7c0tQFIASZ95CZhIaoXYmDVhYOldTYEsh+Oy6bvegPUZqkMz5+7zNz/I9nuKy8WgRJm6g2SLmO7wR9oQb6gGcyYL4EU2bVbYvX6Zrgc35yncJStKR3Vj9qUczX3APsIVXYeeBVrgC8jVheqFd04weEfcgjUdinB4FTb/bgO8l8doU0MolDKBTS8w+SFutLv3O16NoD1hXjTbjFO4YxNy0oFFeUC7nIDFN7T9E9poaWlyD690SksboPDC+Bvsf3Zd5y+eCPRf0E4ipnPTOFr363MtSqpTQ+V7b3g58TuJKDZns0JLgwTp5yLFlrbwpFzRcBSYENNmaXkw31ofihJYUiQFUBMxgkXZdGYji23sGlrALyYYs3ZtqgWwcXsLZS2DlUHrUTsdyLD57fCLaZIF3aU+/Prg5Zv3jQVDDfBXW1W8AFgh4BXG3TPmkOalKPQ1Yv5Q9BTStr4J7PV+Vp5DqQKxqrjsYPrcBGX+CPTxtf+RX1Oe3WVZHbPqj7g6wRUrwPnPp3yyq7CkOMZckahaRajzgDUicBiCChw+hI+5NBawSv5oiJpUvDsxe/5ZsD65rf/f+UhdC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 12:58:10PM +0200, Paolo Bonzini wrote:
> s390 does not anymore use special struct page for its shadow page tables.
> The honor of giving a special meaning to pt_index is now m68k's, so
> rename the fields and adjust them for the desired type.
> 
> Cc: linux-mm@kvack.org
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Acked-by: Vishal Moola <vishal.moola@gmail.com>

