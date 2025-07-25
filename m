Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A53C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 18:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7156B0089; Fri, 25 Jul 2025 14:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEC86B008A; Fri, 25 Jul 2025 14:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC2F6B0092; Fri, 25 Jul 2025 14:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFB9A6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:27:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F58DBBF2C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:27:31 +0000 (UTC)
X-FDA: 83703619902.22.C79A9BC
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3698D8000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 18:27:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k8UO8l0G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753468049; a=rsa-sha256;
	cv=none;
	b=my+z1xnSbFLjSTwu0PzO4R7Tw52xhPPJYBSxQ3dhMK/Uxycf2ph2I9cwGC2Ir2CRm8Jb2Q
	TSPG13MnTJXoa1q3zrxirAra0gqdhA3Pug3jlLYDhn/B40lFehHtOVTRhcT3Fd1Xzh4TZf
	4YZJkYkFAjNFqlVjzMoWresoW/Vqmsc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k8UO8l0G;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753468049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGsJdJPVFg6ouh8HRlVVj9qvC5pGjbJ25tCnf1EI3MY=;
	b=xGeCkDSFparlvNxVf6VFswtFFdU9JHFyYDXYWeKKBM6OZ3rdeDGY47flB7Xr7I2lQfsSke
	ZIRfJjsNPpT9Qg0tFoqU65VcIZNTuQJ4R5L6CqhObu3GN7oMGwd48u2lu0dAI+2x9qelyY
	cF/47UoKwy1qey3GDTbUVFAW/dTOAuA=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-713fba639f3so21566337b3.1
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753468048; x=1754072848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGsJdJPVFg6ouh8HRlVVj9qvC5pGjbJ25tCnf1EI3MY=;
        b=k8UO8l0GsvJzGYwOYLfCY4vqItyZHopUYMK7dtSLUWJ/2YE59dIyOJXNvhnnd928By
         aTiedRbVUknGYEwUEXR6zT14yruto6kG3Wct/qWe3Xp1T7ft+BnrLACTEI2ihZNuSF4i
         RLWouXrnOXviSOEcnB/p6aM1LDTT5syXJ0VM+5vcBih9jWaCp++HtGE2lmixGaNhYn+0
         NmB6R7bqTK7qutS+z/u3KaVFUnFC25Anp9Iyk8hXf4rbil5bx3+E2LkHKiCf2CPJoXmW
         X2KVby2cpWDg0GahliKzJyS5x8Ph9YR0ipEXcKa/KhgsJCg8fgFeH7aZkzyxy42Ns8m/
         0w+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753468048; x=1754072848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KGsJdJPVFg6ouh8HRlVVj9qvC5pGjbJ25tCnf1EI3MY=;
        b=Yc6yttntVv03jy/hHZGIrKTxuKYrvYxtwJtUTyLpmK5ezebeVEr61eazRfEt4tskZg
         NVIDNXkscjrPFM2fH7WvZh+IbV7ckuvRlsC1ylS4PaQWTTutumFJkLWfHE8XanZ2jS9b
         Xzs4kCUgY27NwwE99xzPgeENhuzEJxGJPWUkvvvD2RyT9tszgcy0YZY5Muk6hSMLe8sH
         RApfaubepOebVWWVhytXzG/VcZHNeRQsljBkvyQyCiY7dVPFTM5PJLEYMSb1lm2C2/Nx
         1qZqe0YmC8Pnv0vYtGgZPD1ht0eoYCPW+kG+Ag0Qq3QO6dxGGUqWhvrKDBTRI6BSEUHk
         I/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkr+yDPAl+6HCiiAIxtItgYdooQjS6+UtZzQmUA+8FhH3wxJwJ6pKT/YOMLbk2oRGaw7GlwMkV6A==@kvack.org
X-Gm-Message-State: AOJu0YwZA/H29hGzy1hU6/KSoQ+x98AP127zpBA7ip52T9t+kiz65AnQ
	AFOYm2jxZcY7bpz/mb8HolMr1sOufQbvubffp01Y/MeA25B3OygpmW+0
X-Gm-Gg: ASbGnctqV55zPhKacu7GOxdgYqQe2e5KTi8BKfzfpOijzIg/e0wGs0pnlPwwHNG3U6P
	IlW1zo+PR/+sEuGqaaYPFy9a+7Q6M7pjCNsaDV8J8qQjDrJYKQgn4jJWc9UvkSDjBnkQTK4y72R
	/r17uz1qXBKGqVosU9dZSJ59tF4k5QndYqH0MSQxwEEufuK4LWahtpyLaeXh3ojmLH04eyJTnUw
	cqfDcEKlTr5QVp3ICLbaDbUifDT9nb3tVZw0VgmXl7uac2xpz/wtjBZ/YNPZz3blrb/Ty7IOqly
	bMLRYEDJQ3jzCsf8Ype9Tn6+QyzeFAMB+s3n8Qu1in5BSno2T3h+iJ/2EfLgMVwDGoHv6thNIeX
	pcIeeRmeN7CRx2gBs7PLIBQ==
X-Google-Smtp-Source: AGHT+IGvP02ssugHzK68/uifaDc8Ut7qztKieRH0z/WUQl+bdaCcOjca5FRzv6cc0PXhAr8U0F4sEA==
X-Received: by 2002:a05:690c:724a:b0:70f:6ec6:62b2 with SMTP id 00721157ae682-719e328b19fmr41101687b3.8.1753468048036;
        Fri, 25 Jul 2025 11:27:28 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f23e1f19sm866757b3.83.2025.07.25.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 11:27:27 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] MAINTAINERS: Add missing headers to mempory policy & migration section
Date: Fri, 25 Jul 2025 11:27:26 -0700
Message-ID: <20250725182726.2540602-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a2a3b527-8ed0-45e0-be15-85ec4ef1afa1@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ud9g3fjw6wod1uwz9b1q7utpoft66bus
X-Rspam-User: 
X-Rspamd-Queue-Id: 3698D8000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1753468048-397553
X-HE-Meta: U2FsdGVkX1996GaNfYLusiuweolU/qgDBhGYYtsN0SkTrIAovEU21XFdfU2EheHRR5n9TcA8CUxv6BiakT0ovRGvUJRQWVAFICsP+0K0e1E2/5rIRTJrigubbnDe52x9MTRK6mwLWQL2Iftgsln3lAKAj9NhWXh4NOOj3MZcuVC+IfgbtxKQnG655Wd5okrn+1zhFkdrLbOhgP4H698zToOfkC56uKPGP3rYnrX+NAwVzdftYxmRAlIX/50BnqkoSLH4jniUNpn1OJdQIsDZWS8Ingaz5FZO4Z1+u/WKNlBElnYMcpGzccimd+7VlH8h8A5+20AP8NPbfbmlVkhbup34cL4Wj8egU6ArUGU2OHvsQRhvHPSVAKpJuLe7t1L6CAQnRQgztgUemUjjUkD0vWf/Zzmsce7yS1LADVonQZLGrWAw8Mmrv1eNM6M5m5TrTv7EjOvwOcPhH1Po64zebyRgswxp7qGp3nKLaaCwlBHqBksS/kA0NtQC1XqdxxhxaPk/HCimLXTn8js8F7P766YHYULECtxnFJmiy6gQaEerk7klgvOIDIe+1zXsJdHjV/AUWO5+5xto3EiPdUnnm61flMCVL3igq9RpJeXjQR1frrEYtyeKS+oIM4DcDNmBGTisHVonKh0hY6ENj4aNXerrJLAAy2ZkBXFPRxa62zN1E5MoupHXbmsLt+bvvTGAsVei4QMdq2Hp2GRUdVPKmPf3crbLtZqIoJdUmZts7+xIe1RliMLu62QUznjeFwVs0mai3BZ1ir5e7ztaxeYepqY+jwfRNI7qHcKAil85QmQXCynm4VnxKhJpfTmet4gYcxiZUG8CX6G7JvqGyAbhtRXjXA4/3890Aa6DfZ6I09/aOLmg0XuohmoW3iR3Jdt9CXFS/4iBzh+vFFkF+//6oq+M9RQ3qGAHmncDtKUQJLWrvnERF66qxspCmtBT5UlIG947T4oNvqk4Yg4RTN1
 TN76N59U
 OvSzmxGqavlNZwUqVO08KM9em5B/Ec/poQcLL4YF0zvEPLJV1POoI2Viix23K3OlflaeUZmc9U2IEQBNXfsVuGCVrjKai3HBKxf5uAJdeZ0WVc4uiZmIXN7fLCVWnnPAYjzrxX9SBbHHiWHBJmCxyEhxgX+fk23GTxxNpn6rIe1JHBU8vJMq9mHWLk6NnTPkgnUDWhsC7rse9mI4NTcLUhvwTHuJTa1X3lpqsAC8olLHB5YBTMwjuq3/wliQ9s7Tr5qUWs5Of04Tyave6nP3TkKe7/dzwrdANgIFSb7CNpF0fpl+4t2LGyIaxGad1sGpk35AeZFxYrOL/dkl2TIdZBDxbF3C3I3J4/MzM8XlagmRMbkEbTgur2ynr4RpMxyfVv7IYnOH6rf1iu23XV6JR+f4vEdOv4UkYYpGpUSPEHVWJxa/6RMLloTEEwtOIdU7kqLGL06HX4Q9c2sP3u62yzADTl45XC88HC3O7kM/z+6MBLkt5TiH/gDk+QXYj23mi8LTxBqTQUQr1ck7BWT57n5UJBCqTq08jUkhWw8oUFpEpBvUjbfZzrFD/gN/H2wCxluSimxFMb+Mlzs9s6nJi55BcKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Jul 2025 20:23:04 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 25.07.25 20:17, Joshua Hahn wrote:
> > On Fri, 25 Jul 2025 20:03:09 +0200 David Hildenbrand <david@redhat.com> wrote:
> > 
> >> On 25.07.25 19:56, Joshua Hahn wrote:
> >>> These two files currently do not belong to any section.
> >>> The memory policy & migration section seems to be a good home for them!
> >>>
> >>> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >>> ---
> >>>    MAINTAINERS | 2 ++
> >>>    1 file changed, 2 insertions(+)
> >>>
> >>> diff --git a/MAINTAINERS b/MAINTAINERS
> >>> index a8bebd0886df..dec8db8b5cc7 100644
> >>> --- a/MAINTAINERS
> >>> +++ b/MAINTAINERS
> >>> @@ -15838,7 +15838,9 @@ S:	Maintained
> >>>    W:	http://www.linux-mm.org
> >>>    T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >>>    F:	include/linux/mempolicy.h
> >>> +F:	include/uapi/linux/mempolicy.h
> >>
> >> That one is already on that secion on the mm/mm-new branch
> > 
> > Hi David,
> > 
> > Thank you for getting back so quickly : -)
> 
> :)
> 
> > 
> > Unfortunately, I can't seem to find this file in MAINTAINERS in mm-new.
> > Perhaps I am not looking correctly? Apologies in advance if that is the case.
> > My HEAD for mm-new points to dd811f4553a9512501205ba8e58ef1a6af4cb291, for
> > your reference.
> 
> Sorry, I was completely wrong ... I got confused by the other 
> mempolicy.h file that Lorenzo also recently touched in here as part of 
> the MISC section.

Hi David,

No worries at all! Yes, there is a lot of movement in the MAINTAINERS file
right now and there are quite a few files to keep track of : -)

> Sorry for the noise, I shall stop working for today and enjoy the 
> weekend (and hope you will do as well)
> 
> Acked-by: David Hildenbrand <david@redhat.com>

Thank you for the ack! Hope you enjoy the weekend!!
Joshua
 
> -- 
> Cheers,
> 
> David / dhildenb

Sent using hkml (https://github.com/sjp38/hackermail)

