Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43D48EE36A7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842E36B0005; Thu, 12 Feb 2026 11:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813E16B0088; Thu, 12 Feb 2026 11:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740896B008A; Thu, 12 Feb 2026 11:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6748B6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:47:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1561B56AA2
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:47:47 +0000 (UTC)
X-FDA: 84436386174.26.06529BF
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5CCE4140008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:47:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NO/vXFaj";
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770914865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Kji4RKvQXQVvuP8k7YkpJrLiCBp/aXH4Dh3ytJmnssc=;
	b=C74GrCeC36niJq7VtkoGqGPZIRSv94W2Wul2kCUwFUMA0/mD8LED/yGiYEzn2kPxDrEP88
	ByAU3OQfRy3PVXUHhEmC6fEfISjvOkg0WvW5NoJYSuk/lkEhrC85WtuePX0eq8hHlT5Tm/
	rXReoe/4mxBQB6rO7+jU/5aiT7vQ+OM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="NO/vXFaj";
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770914865; a=rsa-sha256;
	cv=none;
	b=7uLT7Pp9mGXwsq1WCsCCr6IqCr5rymL6cz3kVXrnIKtb4FNSMgM7/JEx5++LR5dUSFXw2X
	sA53aQFANs4Jud7d6rwwxwnpyLiaP30yh6XszK8/atdBmB8MnCwRUh17kxKMJFs2Rgmbtf
	uDDH3q2fRpy1OLpqq/CeKt/kmt2nvlw=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ab47d8b33cso55225ad.2
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770914864; x=1771519664; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kji4RKvQXQVvuP8k7YkpJrLiCBp/aXH4Dh3ytJmnssc=;
        b=NO/vXFajCVxjNvp3ruCpkQI50nyQV6j6pko31Y4I5H5R/8NLJbfmaIzXwvebuuBfcq
         M69peqjjOIajWo9GfVj26SbCjCl9qQz9DQSJGpna7sdpRn/fTMrPo6XOX1jmPercmcch
         FV947R4v8pAgVWMeGvGpQ00lv9oEsTKrdub3UjdWiUYi0B+pOjunRQDLzjpFIngJbwdT
         a7Cbj0S9zJEPIx1ZAxt7M91UAxOkTBcyzitK4kBhSUEMhVcf4k+ghxF84rycRr2LHRMX
         9FDFVx5UgVANLvR7nov5ADre3tgWNT0OvIc5cY3IywjNhr6LYQkyxuK7dV7TDesOyUZ4
         siYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770914864; x=1771519664;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kji4RKvQXQVvuP8k7YkpJrLiCBp/aXH4Dh3ytJmnssc=;
        b=CisBwH0Hi0CXes0yIqQuAOdGfcxHRBrDJ0JStINvZq2kMKO0CtEWGAugeagnoyry92
         Ca6wMJGHVwH1jlz8TN6J2OANqWY5gh6p9VGDmG5nsm3m1zKyHd59hC8T1IKmPwpxdW65
         eLIjj9ZY8IcDdQJhnRyddqT3v9NslvPMFqMF7fDiAPk2hDZH28Gz7SxBSxfXnRlWToYf
         krjcrmTKiPq8aTkatAPRNoEPrmZ2USLYu8geMKuVFSqroqm3upWAk/sYzdkCzW5/HXcD
         hV/uWFUuwozawp+J3ApiRBux0H0zNp9tINT/fn7VPBVloDUZXDEDD9a6SZdpeP9jdfAd
         myEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXr+Agaj+JnZFbHx0PVSKso4afJhlf3UJAOz2W3Y3n3QnS8e2J/Tnducbwzgjlky8vRdD+h1MS+bg==@kvack.org
X-Gm-Message-State: AOJu0Yw7cgpqHC0DQDM9Lse/S3XWQ+68Ujs500eHWgzyu1NWNOFVvrbq
	Q0XTqUoWT2+4DeTt1NsJh3camdyeSAnc//qs8RBWHIVqIZvpndfy3evl
X-Gm-Gg: AZuq6aIQXCDAQoST+0k0G5hOaQhza40XlhVKKlOyzUC/Lp7FGWvTIjBR71fBIpSRFkg
	c4YZQA95q4UlRCCbAqfwhJwS7ZIxliTulgoS9sC6ShYVPLkFNNaLr+EbmX4Wb/2XjQDZlUKg0eW
	UyOdqrzwSTy5TI6cQ6ShgIFEsaDZudHSfSKxrWt9tFzrEu79zIqGIvRKa1SALfqczqNuqSU8ud5
	jdEx/IWjnQUvvgGJqqn+W0W8ZctMrMHSr35rkzfDWTjXsvpJQP5rWYF8mGRZQmFMDBrr7w0PTJr
	bCX8mxxPl7KW6SAib3irAyh320lvwlqx+ngeDw435ewZ+6ciwp7KY6OwjwVklRVz8XqzU2aMlTJ
	PFWAaqSlJyS1cQYs28o1IT9JGYsVjoVfdLH7O1yEJPf+X4/xcHbiezsfzBJoG4eIdv8s4cFgYC7
	KvccVu9IyUQr7Hl0lv70hqzp7/Xik=
X-Received: by 2002:a17:903:3b87:b0:2aa:d611:ac69 with SMTP id d9443c01a7336-2ab39c62378mr32288565ad.52.1770914863950;
        Thu, 12 Feb 2026 08:47:43 -0800 (PST)
Received: from dw-tp ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab2986efa0sm54735705ad.32.2026.02.12.08.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 08:47:43 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC 1/2] mm: thp: allocate PTE page tables lazily at split time
In-Reply-To: <22d65938-4569-4e5e-8f30-bfe9b38b6493@kernel.org>
Date: Thu, 12 Feb 2026 22:16:14 +0530
Message-ID: <874inlnc4p.ritesh.list@gmail.com>
References: <20260211125507.4175026-1-usama.arif@linux.dev> <20260211125507.4175026-2-usama.arif@linux.dev> <13ab56cb-7fdb-4ee4-9170-f9f4fa4b6e37@kernel.org> <875x82ma6q.ritesh.list@gmail.com> <22d65938-4569-4e5e-8f30-bfe9b38b6493@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CCE4140008
X-Stat-Signature: rjngzrom964jtpa5wc7sdnmqq6smymdm
X-Rspam-User: 
X-HE-Tag: 1770914865-275945
X-HE-Meta: U2FsdGVkX1+sDm6ZAHzg3ME5p3I4Lp6anYy/jo3DkuBKhdX1obXlDxRFl9oPitpQn9zs51XAHODfamB1YNtSXxNYpucu9EA61sDW1jq5RwnPAg5rKEjbUEen4tgxuzu90cxjaFrogaABEdwcrAqqRfKNSg2Lfe6iW5rdj6/gtYpkAuLU3pb0lbxn9ohpLv7W2POX1NWdTkFImF85NfDWGkCGs4R/TtHZwCkY9kolmw49rFAklmD3AgAVQsywhXcQCE2fHTTt+zgCrRXM8sM42CgbAg3NBlSx7hWgpBkB9A/Ol/lF5/eh1aL7/N0Q/Sr9R/5RWLdJ0Dn1rPbaprK2hWWJgJAFqW5AwoII741UOn8Nbdp8fOIO0Wl2z2BqaK4dbIxLKulOMGKgPAZbnUpLd6Cqhed0juvzOHCs/EjXJfLsKfYbHtLT6bopbJ5n/Drl7RnysZv9LGcUo1+K/1MXywh5u+gCVh8bIkwYoTRrd1yXeE/dYxrHXSePgXNVqoeR/ZN/ZqWyEHeqwKflNeDXgCZd9m2ructqxmEIJ5yIzUt498JIXYhO/rfg+11UKnP0+Rb/nL/Ekx7rkFkNkuwQrgTBHGwRAmSu5e2tWEwAS+MyRCXWF/OuqQWpDufjpAFBv6LW+iViY1MiTpp9G/54flb1Yt5EO2RfOo3K3wspywwDKwS8XHy4FYhhMrSYs9hcwEE7I3ukA1J3JIfzJJcL8zeGO959T7muS4eu1/NTsBeRSGBXMmJZgmKy0wSucL1rrxSdAn25ag7M1QtKUhbsrs/XACgxr1FIhI7asHpDbs79mJY0Q/ydj6kNakcW51PfJfTKBXI+89l3JuM1y6wCbdGrAehmbMGXIpRf/dqpv7vtBPVlYbsaSjHIG8QsvXiLAtLnYMPRlcUdh59CIElp/FGmaF3vgGpvIwYvud/6wM63UkD0gUZdpe/WXbgmNSQ6DEMtyWbQwn7Ryi+xngD
 4gaS9HpI
 RFNG55kT2BNjt9hPx1K8VY6ii47Amev/8sdQf0V+WBEHleUeKLRpPEM6mJb70COgL7N+ZKuADkjcOKV8em4TL+NyUDUWsAtRscPmYF+fw2YjzSqAyN+TK8GKWF0Q0FpQqHdy4lzZJ+av0MODbIsdO1gE85uIN+Y0WWoP6f7ianFsrMbrjZuVgnMrQUEyEYEoS5SPd1H239E6Gf8hLsPkZDbF2kJMiy3jKdPqX8jGZrRHKReCdGuuKJl2Mq3d7/HeQG+Yv3mbZgS5ZSP6Rlk1v78T1f1TFHFvSL7exGc0tY0Dw2GlltfaxJB9NouEMOpsEXiC23dtFbdltDeXHNJb0KUntuUi9ZKyPRLkCWU99DPVnkRhzHIyDwzoJh7DjFJRyyajFPpv9uS7RR2pqznUKYSqEZisQLrWMMkYLMA2yuaQiVZZNSXjxsUMY4eywPJugIV1WR7RRTtmEXS2FDH1USz0ZgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>
> Thanks! The series will grow quite a bit I think, so retesting new 
> revisions will be very appreciated!
>

Definitely. Thanks!

-ritesh

