Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B390C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 13:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F40B6B008C; Fri,  4 Sep 2026 09:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC246B0092; Fri,  4 Sep 2026 09:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAD56B0095; Fri,  4 Sep 2026 09:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D39A86B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:43:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59603160375
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:43:49 +0000 (UTC)
X-FDA: 85176197778.19.2BF265A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 68A0A20006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 13:43:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kw7oAwn1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of rakukuip@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rakukuip@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788529427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pk+ekoqv4mOUrrBEKJkMRNIlFSGEaIH2fs68xJ4kFYw=;
	b=nfd1JOUcnsv9Oqw3fYt3/fW3jCNq0X1UjnL3QK3penWzZpp5o7o0p6Nn/MZGRLQZX3eCwX
	q2HYkvj4AIfk5SGClhlg+xCpYSkwRc4FCDXaxQHRgb7j1BL/jn+mvsjmIJ63GlYQwppAkZ
	2p4jwH1jQmAyhHKtltmJBVIxJcz7Z20=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kw7oAwn1;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of rakukuip@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rakukuip@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788529427;
	b=10C4NYlO92mvTvWxo65303Csh9WMFD7arxmWBE2RUVjxNkJ9uOoDgPizYdCKD0EaHCP9L1
	GzJwks/qNsOJ8avJo4Zgd8YE4CwuVXHbOH5xPo87W6JUv1Kd6ojsM3IRmg+e5GM2dAJfq6
	9chFAHdNHSkbSJEti9Ko9EPH1lAFzi0=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db217a2b2aso2416065ad.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 06:43:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788529426; cv=none;
        d=google.com; s=arc-20260327;
        b=MpfuW2Np0PqYj9aMZBpO+tcw4ohsv2BEJ7zq06uX2SSr9QupO8nATElvlDzdLLOcwu
         igs6k3mlvW4Yaw6oT7lwWa0ksQpRsZ3KkvqYeiQiQNyrhLfTMZfUp6wGAghIwBSRAWFi
         Tk5r3jRN3+ioATrYKnAFJVyDODnS4WqsOU6AJKlhXRmmyIO6d02pCz4uJjxEiyfCiQaI
         pmg4KNFo0HBJbi4KfcRiW+lWxA2TJKq0YqacF0pdFXW09uOS3atOxpUIXGDhbjt8GzoY
         WbHCfEinOmv31RNr7EwnzrlXt8P7AdUQpIbnow+n8yht78denaxMcfYz+c6W7eCGOAPE
         E2Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pk+ekoqv4mOUrrBEKJkMRNIlFSGEaIH2fs68xJ4kFYw=;
        fh=dFpRHtAkfnOw4A7MaQA7HY9yPr4t+ReiLQMOKgJlZpc=;
        b=rlairF/cqrJ+93aq+jevq/k4OCKYh1VsxfeURJOSWm5SLmRBZgYGig/ebUZ4hrY7Q3
         L6bFM/q0TIPUmNXl1i+0oDyaQW82iPgETZZJcXZWNYCKJlzKzqs036q/ZS7RTTRZV4f/
         23fSfLZ+/3O+GQK1EV+Xq8gRxzIcMMoeGnCizKNplVrn9muu2U2XilBvJpZYUOI3fNRx
         YN2/Wg/N7RTVzxHFr45ARyzM6lkoHFGU+iX3V+FSf/4mPJCHx/k4NqnjHqS6PJmFqJzQ
         xjNwDsbwWb6Ky1Kar4z5sON71Mjg18JjsbuppzHd7IajzaeBq0R0gr+to+VJs3ELTlcr
         omhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788529426; x=1789134226; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pk+ekoqv4mOUrrBEKJkMRNIlFSGEaIH2fs68xJ4kFYw=;
        b=kw7oAwn1sEMr5q1YSGvqj4+eBGrbqFuaBCNrDdpLt/x1yDHrBC7zuv1fv9YR+DKMzD
         pxKbho+HdotGxZUgoh9g4adzGhbBuzDoR2aCWJzhoYovEQVg/r3Wrzsokb1kg08yMrRs
         HgffuhlaK/50RU6FXfBlIAS5Zhp2zPYGr9O/1ygWPp5VZe9F84nPmBCqQPDJ2/pXl5Uc
         PDvw7twjKfCVwu11/4LmJFMaaSkq7O7qFedta84DEM/nyIlPPE8+t+KgQglrviXAbUBE
         X3OCTSowHmU+fW/dorxwuoucmqcHIen0HHBiwPE2v/EDQfxszQzF1eIlhNNMEqNBTzQW
         ijWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788529426; x=1789134226;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pk+ekoqv4mOUrrBEKJkMRNIlFSGEaIH2fs68xJ4kFYw=;
        b=SsFOXPrl3gbmqsASSnzpFp8ORDufL9Bgwtzu5FoTi3J56q2/0ZzcblBqDREowJTA8r
         WXXBBcfugo4cT1PNnyuyMiVYf3R7AlmKV1peOE8+ibaHlPnjZfF99Lvr/FjE7zhfu3dv
         Uf/4JYF5yhP24PzagXbhxZSSEeKKsaZAMOY7FLat6j67lm5zjzzKIMMwX6mNtP9ALMOu
         QGPuVhJiRjDDZ/+8XxDaQg8e70V5AcCNcKZM0D4Gp4+lYqFCdGzNPxcoU258UNAMFHie
         wsLv0TB2g7U4eNi7dNYT4m3SMRr1vjPyH+pkl/drucGUmIipwZvsybnnIrNWASEV4Qw+
         UBdQ==
X-Forwarded-Encrypted: i=1; AKwUvBxbA7NZW3+IceUhdxdHgmDJUWS8JjfjtTvhYgPrtYsnfqF7nYt3VV53Vz4Mbn1vPqXIh4WHzUH8NQ==@kvack.org
X-Gm-Message-State: AFuF++n1wapt6IhWmxak0iPm87GZ7TNNo95qKIQryHnr7JFxgDacNivV
	vOGZIEJBItLoBsbzc20a973bKcmcd4imGAGPRbM2WkuxUfUvbdhu/N/MCi5ftdFVjaKSecLlri2
	ebFYCqNd5KBy/3M+E32K86V3ZAe1BMlo=
X-Gm-Gg: AYBFou2oDIuqIDiWvNBjxoHpZLtDxIWFddoirkePfqMGGabT5iz8R51jKoslg7IT9Qu
	Yda/rPrQoUm4cQ7RcQYOqUI0l7RjrS/l+ugwywStb5MYMvenTYVZ2uqMyyo8UCmeEOzNNOx24vr
	ng7OVuWCoIV1I6nszuAr2MYVj6u8rEnWBHsLXN3zbpL+EGHtqIpQq0JoYa6Zte+VLX5+OKeJzWB
	yTyUvgk96f6hLB4qTkNIPnwb1DwFNPHZr4DW9GKfBriRFw2VB+FkeJfJ3pvORaW2fvtERUwO6Kj
	F8fIly+I3p5vPIKPinlM2hYSZ54+3ofHU5Fm2FIIAxcuyngwdyMDo+S9XQ==
X-Received: by 2002:a17:90b:1d84:b0:396:4cbf:45a2 with SMTP id
 98e67ed59e1d1-39b261e3b7fmr7927943a91.14.1788529425879; Fri, 04 Sep 2026
 06:43:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784428532.git.rakukuip@gmail.com> <f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
 <25e3e218-cb74-4d7d-9301-24b583f4323f@kernel.org>
In-Reply-To: <25e3e218-cb74-4d7d-9301-24b583f4323f@kernel.org>
From: Lain Anc <rakukuip@gmail.com>
Date: Fri, 4 Sep 2026 21:43:32 +0800
X-Gm-Features: AcwNN1Vs3ti2GIIaKPH-KN5z3MW8u40mPX7KFTlUSbwRns9e1XZmUv3KVUPkOio
Message-ID: <CANZytUx8s4Pj=VDm15tvORd8E_pG1oJQKdKx_9Dh+J5_jarbLg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: fix out-of-bounds access and race in generic_access_phys
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, notasas@gmail.com, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68A0A20006
X-Stat-Signature: 9b6fjgogpphewtxa66mysq6zxjw4pf84
X-Rspam-User: 
X-HE-Tag: 1788529427-989749
X-HE-Meta: U2FsdGVkX195M7DtlnjjLHQQUyiWnbwf6e68+/sCxTwR6rsz3CKuovawy/K8/PCWWI0vX55qmAHJiDyFjTwQi9ng7dCm2CsrIoQ0ldolg9V0bghK/UweGf9YSL7yGRhaurI/Zgw2sTogFJAdB+1bzcvtCQ7hfW4vDPZ+7hHqXs7bkPpLNwztYmBkZ6uRt4BA8EEqdn+Q90MwePkTKk87UuZIRnNsIY53KksxkJbK4L8kxUct3I1KdebUTs7cvwK3s9M8z8tWBgX9xEoYpSDHfTOzgCwi2CK4t9hPGACdQ0VKBTfSpaIdoJwxs2aBpyCrFtrOkeqv2a9ZfRbKIIbnqFh/9NTs6qrlMQJSmXrMXDcC5D1dg56qMaE00kR1vRVzf8gejzxRm21I+BnWD+4IwHSp2LKGR3YBQO54/CC0NKZV96i96ZqZ1c4DZ7hVf1Go+jZn+xqVUWIUdTo7kO6v/lv4CsjH4RH/W5kQlbJSUsxGDTHoHJhZ4NY1/yM8NtMa246WqE1SN/SZuR3CjWAtDpAuf8uDDEKK3u1G3NLgyz/xlgwF+2UxfFLYyXQ3/Dt4DEYrJd65dkSFyzc7/Jzli8NC/0upRJLKSMjDjKgJEH4ilG85+NGtWy5ZABPcpSaYapYN/qsgjULHRAhBfdtee/WEZU8inEIPapype10gi69fBKFu9/qC16Hx8VhBYrJ5M9aRHk8yS/fjRF0Sbt5nc8ob2Uc6NBLqc/ftE0DXgmWmXFondlRLVtGbU0Fa/ZFG68AVUiSVIu4Of+df00l8dVS0qQ7pivhvMIrcmMMjHuNTlS6qlsnFUowmKJcQuWlh6omY9NjsEPBKeMufCxYSGQ+YL+EInjSbQ/SzXkNrGQaMOEOTA2e6CuACOJ19M53uTrQxPcRXEf5UstVdLVeavc+xfqTjBoApYOQA6pHqLWYif7hRB0NVBv0Q7z7+/TRDvNRPvG2J9DveEVOBGBQ
 SlA7uNkp
 Wx827eHYDIKTYfPZwLs4VSplTeKrp/9QsT/jEUIQ6Jmq75YQvSuKcmWmYBKAAcuY5nRiiZheJRU8ldojoIQ+ItHviFiydRUGZxsex16evjoFaRNFU/aOOF/g6M+1VeQrImNjVeWqG60ubdUim/+gr9+WI1IqyKy1fp19Oa3fzEhrM9q2l+thOj5B6vcU0sLYcSu5PTV5niaDXoPiYXubiQQ4qwowr+kWCdlx/WvpkjlE6ScQ4n3haTOXUehj0XJKfbL18Usj+lgeSCO5CBO1qE1nDLz8b24PD14T8COcXyNBDd5e1xCeB+BsOMBxWAdCZT/It2FetuaSAO4v00YM3D//9McPrzqV9xsJhvlxpaMYQTpcUSQ6VZrMgxVKQwmz0XbM7xPpBs7FqQK40zFjc4qW/ZV1Djsmk4xR6+crXjc7Y4JLeWpZI4NIK92HBWpu0gUPvIsYCUBLzqHE0NGmDQUHlEa1UxoOmR6aQYifBY5IaqVMZEa53T4B4UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Hildenbrand (Arm) <david@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=88=
21=E6=97=A5=E5=91=A8=E4=BA=8C 22:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On 7/21/26 16:26, Ren Wei wrote:
> > From: Luxiao Xu <rakukuip@gmail.com>
> >
> > generic_access_phys() improperly validates the memory access range. It
> > only validates the start address using follow_pfnmap_start() and then
> > uses ioremap_prot() to map the entire requested length. This fails to
> > verify if the access range stays within the VMA boundaries or if it
> > crosses into adjacent physical/MMIO mappings, allowing out-of-bounds
> > read or write access.
> >
> > Furthermore, the previous implementation failed to handle partial
> > progress semantics required by __access_remote_vm() and lacked
> > necessary concurrency checks (retry logic) to prevent the use of
> > stale mappings after releasing the PFNMAP lock.
> >
> > Fix this by:
> > - Processing memory access in page-sized chunks, ensuring every page
> >   is validated within its VMA boundaries.
> > - Introducing a retry mechanism to re-validate the PFN/protection
> >   after mapping, ensuring safety against concurrent page table
> >   modifications.
> > - Returning the total number of bytes successfully copied to satisfy
> >   the partial progress semantics of the access_process_vm
> >   infrastructure.
> >
> > Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> > Cc: stable@vger.kernel.org
> > Reported-by: Vega <vega@nebusec.ai>
> > Assisted-by: Codex:gpt-5.4
> > Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> > Signed-off-by: Ren Wei <enjou1224z@gmail.com>
>
>
> Hm, I wonder if it's responsibility of the callers to make sure that [add=
r,
> addr+len) is actually within VMA bounds. Just like it's the callers
> responsibility to ensure that "addr" falls within the VMA.
>
> That makes the ->access() implementation harder to get wrong.
>
> --
> Cheers,
>
> David

Thanks for the feedback!

You are right that callers like __access_remote_vm() already constrain
the access length to (vma->vm_end - addr).

However, within a single VMA, consecutive virtual pages may not map to
consecutive physical pages (PFNs), and individual PTEs might have different
protections/writability. The previous code mapped the entire `len` starting
from the first page's PFN, which assumed physical contiguity. Chunking by
page ensures each page's PFN and protection are validated via
follow_pfnmap_start().

I will clarify this rationale in the commit log for v2.

Thanks,
Luxiao

