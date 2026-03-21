Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06DBE1093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB246B0088; Sat, 21 Mar 2026 01:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285136B0093; Sat, 21 Mar 2026 01:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14C9E6B0095; Sat, 21 Mar 2026 01:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F323D6B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:26:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1E8813AF3F
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:26:15 +0000 (UTC)
X-FDA: 84568934310.21.1D33C46
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id E3A60160002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:26:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhO9UFJR;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774070773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=PPum4GWetd7qCwPivtEJVV9TkLkZOn6LkWq6BWUPBjA=;
	b=J+fPz0fI5+HPltNhmaX5WrAbpSRFQ9wY23y23fwOGKUzIgrcp3TfC95tmQFa8nyccZ5YWk
	XYqvUpp9EwycLu93prdkr/K+7D9DgzXGEKFI6mIzLSF7hhwNB545Oc+mD6oN6lAoVSpn4G
	0f0FAusOhCRaeZeo4kiTeeTx9igtlvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774070774; a=rsa-sha256;
	cv=none;
	b=K150PMUo4cICeRO6iU+dRVYhY+DTeq3lnmat73RZf7Y9DFjACYieraOj05Dp7M25MXqDy/
	g+qwMQfovSG3P0z10VdQOqvflh3GcJ5Do+7hU+wc6DBZQmdjcGlz8JdD8fCy2Ri2hLG1C+
	sXdzzadkYpEx3qfz7l7JwsISBZ68Uu4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XhO9UFJR;
	spf=pass (imf08.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35ba749f441so2367099a91.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774070773; x=1774675573; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PPum4GWetd7qCwPivtEJVV9TkLkZOn6LkWq6BWUPBjA=;
        b=XhO9UFJRUiYN0Ln5wRoeCgyoOeCgNkjOQdh5wisLVHl98tJlcYD4ql61YNHi+RxhEn
         rQho6g8KkQ0nUBMt2483L5duhV7qp2ePa5YN5aLPRzW7EP6EgR1vjY16Q4K2EcJBCWWf
         ajLlNhp5uWvtmuYWnF4hihiR5RQQmYbKyZpoIs5jik5TzXK321UfLnONgO02uE4tVftM
         Fk6rowUMEY3X0H7Bv2hyq365c0AJcdNLR9KGP/P/CxHiHUUUvOkB5KyhQ7FhpXw732Oh
         6kp7MU9um0S3kQ3wL0EzcgG//iJ4w0MOfv0D0b19rwXbrl8dY51SiaZrHKPeQ5a91jMc
         dDaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774070773; x=1774675573;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PPum4GWetd7qCwPivtEJVV9TkLkZOn6LkWq6BWUPBjA=;
        b=MgI4vMkGk515MkmJGrmM9yreVID3h8eH8eV+G6KZqamG9pieQtUA6CWTKGczOOM8no
         9Osi7hMJNNoMZHHyCOecp4L8f4n9M88f/4WLNZ33FGm/LPUp9kPTpxOsUeKTgyg+Vn/l
         Tg07oBxyf4w+Or/EtDjt1AeauEWFQJ3TduRub48FYSqKa6++Z68i/cXON7idH91Iqp/Z
         ywuc9Hu8MbRz88YRCpqqBSKa+pgeiry+l3DnG4unLTjviVJ565tPkWSrpbiYNWTW1EUQ
         zJS76eWRhQbsXq1v2O1zwQ7PdPr+rQUgYDTEat65BJiE/sgmt36WEDkwAULuhWK7sLwU
         Q/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYMYr9TiYUxqV/kOS3XPmxHZBnjf7OnlqsW56VI6ZWs9/yj1brK+zij3LanJ40pQjxk7ZsuKNFew==@kvack.org
X-Gm-Message-State: AOJu0Yzx0pr3OR0d/v9o7BvqNXMRQEL7AO1fTSscl9xAfcNmGX4LiF1T
	Sjyh1xf/FCSKzaXBWxd6U6xQ1LOYQn7fFYoaXdws2qjA7z1m0+b84eBe
X-Gm-Gg: ATEYQzyZllpZ8pFe1elXYW/KMje8aDD6go+CTZ2q+4CEut6reStpXxRoZZ4JJ3ACqe1
	NijOCJ72HOSUJrL882Vir9HLhQyREqmqWjF/VQI3HiVh/APFn+WT6ix/uslJ+UtyddMuIuBEuia
	/L5/eMfPhm0iG+PcVqUZkgFV+sfBifGIEEj4VAD1wyIRVEkVn932dJfmHLjAmAmZSa4Rswf76VU
	9lMfouPFzvQL4r32lGAd3WyFIkMCe07E7LKW4wpwu6pDogfF0IoYSV3VHYfn/OoHnQvjTdqoRSG
	FM0scltlysrZKK6MbJW9V85T9nj/o0NVYyhnt/Q+cIfjlp5hbt/8m/EErVxMn3yTyFJ4hHX0xyG
	fPww+nXmRIPHM5CDxBhElTrltxq9bLUUN3kiWJVU1Ud1Lul9+5XCFVCCx3BrDX/gCkitaP5n8y5
	JZRHnAH61jxpo0BVTRANirCQ==
X-Received: by 2002:a17:90b:510a:b0:359:f3b1:6811 with SMTP id 98e67ed59e1d1-35bd2bd5ceamr4620697a91.1.1774070772650;
        Fri, 20 Mar 2026 22:26:12 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd41347f0sm3299371a91.17.2026.03.20.22.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 22:26:12 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: change to return bool for pmdp_test_and_clear_young()
In-Reply-To: <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
Date: Sat, 21 Mar 2026 10:54:05 +0530
Message-ID: <ecldycui.ritesh.list@gmail.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com> <8025b898d0841a4bcbd766998959b4e2ae4d4abc.1773890510.git.baolin.wang@linux.alibaba.com>
X-Stat-Signature: ygcxjhtjw4xds3br113757nn3hfasbs9
X-Rspam-User: 
X-Rspamd-Queue-Id: E3A60160002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774070773-355981
X-HE-Meta: U2FsdGVkX1+t+woUyTXU0HoDNPKg3CWejjNyp6q0yvsK+ksFl9i7bCLpva+Ct52T/kVYTFSC0jClPPkunlc41/Fbaqo1bolL2BB1R7tKsRiE9uUP4yDwHWMKYitkRbnVJulTKCvaGzPg1tdh1RDVPKaS+mrOlPLBi7WhlOV9x+d51gIXM+Jf8y9yHoK5IeTTlrd3DRskZBdQGfr6TLopFZPLkM+XXPT/+0+/ogOwd0kOBK3kmxNY0ScRoZGaZ0O2G9XLGfm6sKO5vbKpU8urj/ul8Os4XYBzOG6R0LPyR4alQwgFVA3tnv+uCj1cIuhlezoQIMrW2Cdj10qgu675D/mpLQOIkpdyMr+2TOnM2UFSd1Jxr1munRfLaCQnt70AAPoVtHWrTFw0+o28IA6nMyaNabY7zbqK1nqyrzEEc6aq4SmhYaSb98ryoBqwpdO897yqJ1wYdbke12a3PFtsSbiZId+1PCnU+gRecGWv2LqtEbT3eBUqPUnU9pVcpNMbmf/28GakTRBZtegTEwz4Zykv3l1LTf1hC5Mbf8chstPeMDY9DypBYhbPQBOiDbz6q6srhXtmCKFuiJOyZhZcJltOHODO3yh7vg/71Xn5bNWoQR1j3tG6LOfF2u4XtUYmIF7fcTYYgAlbReNjk9aCUkOPnVdtyGVOdYwD4QHK/31CwsaNSdOT3zztKWRdY0iPG+r0nQjmHWezYku4j9ZUrI6qVZYwf5cEmrRvDyWJJ6uO0UQ/rE1ubyVBWIupLZC+57DaqUOfd0Z5OwIErMvTqVRoD+qKeghGYPSZHnppsE8fw2gdeOvgEyoFpp1DR4fKwf+47XEghH2zvIqjOcklGAjMqUD0H/blVVHo1YiOJlvQ1HiIOdEoFkHUBTXQzDL5FAu0BAYizO/aq0GIIveyhCP6cH2ZeyWpHYEoVp7Ffhzt3VdOR+e3NBoAA1rE1MeTEInSxJSfdYukyul5JjS
 Bmqv8nch
 vIxctWJgTg7LhaIOZ2UfC9DnpVTDt7h3n7RHjPhE8xgfEtcQjSk+Y2FWqTOb17Ea0E70cO44n2tFkKLZ9xOkeMLd4cZ3/kLDjW8+okrEQk6REsZceStW0h72hVVKl2M104k8ha6yI7etsmiDaDc4YlGZWDvHpMUecDv1182XGqtfiXVLxYLHsdbhA8ZgU23RbIlrbkV+LerofJ80jUsCOithhWIZSa25Qw5YgVGggcslMIapi65JQDodOP8ITeTgkCALXyJni5wMnDsHq+ykPcpsspeiZZ2Y3PkN1DmSCmdQppNOnRyNV6vNgogGn2H6ItfeeI9nlxgskvfAUQHZdaLdN4qpaywumhKEXyjPx+6HGJD3ZAwMi+JOqBeYojEX0vGOwuAufsqaeDxtn+Dh7x3f5Yjs5UWwnGR3wMsKERFDRgTw79VBqeHWY9657JkaYiiGjCPs0uxYcb+7MXjNlIMhSIE2KonJf/+M+4zmLVl+gJ/o0bThAXXcf4FsHZYbVEb/X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> writes:

> Callers use pmdp_test_and_clear_young() to clear the young flag and check
> whether it was set for this PMD entry. Change the return type to bool to
> make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h             |  6 +++---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  2 +-
>  arch/s390/include/asm/pgtable.h              |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  6 +++---
>  include/linux/pgtable.h                      | 19 +++++++++----------
>  8 files changed, 27 insertions(+), 28 deletions(-)
>

LGTM. Please feel free to add:
(assuming you will anyway kill the unwanted externs)

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

