Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98255FF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B02BF6B0088; Sun,  3 May 2026 13:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3C26B008A; Sun,  3 May 2026 13:59:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9846B008C; Sun,  3 May 2026 13:59:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87CB86B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:59:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E07C21C1412
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:59:03 +0000 (UTC)
X-FDA: 84726869766.25.A840C9F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3E5F52000E
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:59:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNa+l3NU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777831142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=pFk0o4JWpcFOrDUzmGXYwzfHWtQM19RfFRUQ7XDLJQ0=;
	b=7wdRBjf7phHPFW1wrsWiQuw5I3hlgVGSN+/NhTvVlYSogPVPPozvxIJ8gpE/Hcgy1+ucTc
	IOfHzg027eXzoNd8A5HHBE+rtnNgOQLksRb7Z8NU9A3zKJO0njSbLWFxjSrq3H/ZnRM9sy
	4gepwI2NSi1YXTb0Za0fY+AVzGBKx+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777831142; a=rsa-sha256;
	cv=none;
	b=uVwcCeBoxse6clYIaMXZcsg7JznIaz8166dWPo3uZ5uIXA+IGiwzQbuAhqbNUDKHgtRax7
	+zcCrSgHkTroUKEsmAJUT7WuHyq1tm9ZwucKq3lcTszmIxoxWurnzqAitNTvROhv2+3eq9
	+HuWzKo3ZcusbgpOHDhHPuKWhqZ2mfM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZNa+l3NU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-364e5d895e3so1791970a91.2
        for <linux-mm@kvack.org>; Sun, 03 May 2026 10:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777831141; x=1778435941; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pFk0o4JWpcFOrDUzmGXYwzfHWtQM19RfFRUQ7XDLJQ0=;
        b=ZNa+l3NUDS9g2xC3zJAxtIZoMj9Pfq0aYVHzyHEzmJRH4C/WW570fwYYnPt8Ow90/t
         AQiSX6i12D+hEsv9HQEqE6JyZ7rIFjRuxbnN5aLWeFjEYYIkpVEB/fBc/oBmmIOtiGNg
         Rqnm8EZwJnQm/ISDKw+TgKYW8onKNqA8ZSLR9k8sPRcN/xZbmn5WZlwWfTqGsyltEkxh
         HzjMAF/T1zLoanzC3xtWZYSO8dQGnNgkMaj5AQ7qCQGk+/iH0FvmQLaWQ46IOaUQai4Z
         l0WXpcQriE/YRBVOi+538K3MMkyCLFzNXJg1sDR5Moy7fkHn3YqSsC4I/sEgegiUrG+0
         9tcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777831141; x=1778435941;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pFk0o4JWpcFOrDUzmGXYwzfHWtQM19RfFRUQ7XDLJQ0=;
        b=gd92d4sy8xw8GJJELqpyGwU9gMA9Zgu1KUB2moAnpp9Gr0HomYBv8N/5b99QsSfVGT
         FdhdYC1/Nbtc6daBhX4XJM1zEEhCqOd52kGLIoKUiudYRFgpKvtY1+4uvvneWPVKRKbf
         R4Hun0+VHHKoQeBVufr/Ewnja3umvpgR0T9Jh31zNjaiWWPzB6+pFdOdYKYoBul2BOJv
         xDdHIpFeB9Gj11NlHUpOqKmOw7Ml98bMSi5iD+52dOFK8TtjQ82+WTKxO2GmMVQaPPWS
         89wkj2jFpw6MrUvs4I4fxDD9MZS4n7ACvCVK1Kk+DryDwm7UqAm3AqnTrZoaMv6Zm7nH
         S1ng==
X-Forwarded-Encrypted: i=1; AFNElJ8EIo8diCrXY1OFkrsrKxDEgOZQyGWtY7wmPMPwwXQHc+GmQb1VpRASHCWPDDt3Xd9ruv38J6hBQA==@kvack.org
X-Gm-Message-State: AOJu0Yz+slyS51phJm/Kttk2FTwHJUoA3lRXrgbop159ROGEiThAJPYH
	FcCMmg/Z1tRGHNaUyMonNrOzVJDTxpZ/Jfjb0jLQqzWt/SJQ+tYftwkD
X-Gm-Gg: AeBDiev2VyigNmd0ZkoJ4jMbV1+qjHMFNDzFZ4qzYHZme8wOUceRym059t6XcBhmLWX
	PhzYqpy2jg14EL10Uq3kgjmsNt++5baXf+1rrrU+lV7cZ5rE5dvE/xd0kqU+NSGQP+LuFNSN4iV
	cAMIEa8adXVuN4LpJSakXIsNkrg6+CggJj+4rNTsh5lI75hOSlOAqXIFJEITPQ6U8QO633PDBH1
	clZ4RAEzn9xqdPCTiEBeVA0d0J6hyDlBsHiGXyV1Rv0OoIisYu0NAJIaczIX4+Uve+hHhXvU4LR
	sIr34lwdaoPXdiDOylSM3PonFat0xWW83O3+Fys+k2bAmLlVUqHdkN/ONi/QxLwH2vuN2+/xfMp
	XaNHwFabQvIDm1k24of+XTAzStR3zfuvzR8MWAJNYdMJtXJGkLbe9vJ40gb7dNY4ggIsFGVPyTt
	J/Kj0hHdFVK124+qfPeOlo/S5qjBPtJye6
X-Received: by 2002:a17:90a:e18c:b0:35d:a4c0:a0ac with SMTP id 98e67ed59e1d1-3650ccefc6cmr7084928a91.3.1777831140990;
        Sun, 03 May 2026 10:59:00 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364bdf2aa41sm15437701a91.4.2026.05.03.10.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 10:59:00 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, lsf-pc <lsf-pc@lists.linux-foundation.org>, Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>, Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache Pages
In-Reply-To: <afYdH4Alu9QA18CO@gourry-fedora-PF4VCD3F>
Date: Sun, 03 May 2026 21:48:01 +0530
Message-ID: <8qa0sc06.ritesh.list@gmail.com>
References: <h5ossmwe.ritesh.list@gmail.com> <afNV5wbhsFQJLzxi@casper.infradead.org> <afYQz3YJdWB2R-1q@gourry-fedora-PF4VCD3F> <afYdH4Alu9QA18CO@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E5F52000E
X-Stat-Signature: 4rbcokey9zojja6ozbaerjbdgozray8e
X-Rspam-User: 
X-HE-Tag: 1777831142-548656
X-HE-Meta: U2FsdGVkX1/OaxI3q89k36636CEOEs9Vfi1oWdzKoyhwNlp8C+1tIXp1TbBqA+DcN1Yv7g2t2UO9WApORM2zv9EXUPHQRrY7iwIfZLIelm3yMdbEXXT1lCoecbtZcycguOByqx9zKGEPkzmnL3nS2aEPIbQl2Mmi35zlLjU9qJPFfHxuY0R75GD+8pVXYwYDi/2oWUWKFVTuZ0Igb7S0siJT9VGBm6rDvYwmI/Atx/cFLlSTrVw/rsGi57KOc/2QDUrBJlc+dFXV2xfalX/EcwCUuUwPbLZ2AjNzjYTUH3ymA/hr6zHOeULnZHwcCVAyCi8q96w4I03//sy3IKtTYCRUojukBb1IDB+DE1yQH6GNeh/7enMi1GUTXn5uaMTxN72Pm9AxGOVOCemy5h5Qp/S07mczu7gCWziS2YSUq7IPxq+j1U386AdHzOYRr8nmt7C/Klj3alhUnqfM1zMTniKRCwbfuNzWbMCzt9BCK4OnlVM2ySpp6p85H3wqpgudIl7hhHSTpkdWbJRAOcmioDN7sEwOy890jh1rOInwy6/Nc9gv3O1hzYndN+ezRiNpLEM4amnyyuVLrXAbUl5uDeGAivlRJEKziZjSQxtuUYqGz0ZBikD16iLs6ygtM/vz28WqJmI3AWtomzGRnxckTraxri/7gEDz8yuud8sqNdMe4346YR1ntzUixtd5lnGD5a4Oobhr9HxHpB5ICuqSd805jittZvOOx3A95lTpjQVzcJBo7n/1sxZNmaLGY7xxxJOyielJqu9ZA7xBUMDbw4xj54ZDGE7Xd6gkUnj5P7dwi8cgpoNxpnHa8FSGutbyUi/rI4deZhLJ18+oXXApHdAG/ZXR2m+ilmjjoj636Y0D8LY6Zt4L4j9tfE3ZVY759xTAHG7ECM7VHwvl+F9w2ty7zn8nTsNpvosJYK2tZmJe5M/mXTX+1Tznrugk/iG+RJu/Zw6bfsQzlpNDAmr
 QjjdjRWa
 UsBr2wBfWvXyk4G6MNiOK+zARSKTdq0y1+4A+TwWtEOi/8tg7X06VBDI7BqJBJIUkv4U2lT8JyiQ+EI1C0LzpdVfrnvlZtmEcGjjIuC9k+NLmhE8bKofj5mC4Dgh4iN3/0gegj0EzcT83RhMwtSKy2wwu+O4/rRjuw+snO5A5qKTikZa2oVsbJFq25QCaFeXFNdIHMNb9T+6e/s6BkOlB+Nj28aN03JXfn71xDSCa5NEFCX0eHtCQMYVL/uayDJLZX65+/mH6CzJkkAh8uFtralv8C5eUSKhrB0OLWohv8kL6zFrVuJ5yjrIul4qVpk83ALyKmsq5vxP0/cWd86ec2GDcVjBacDO1I85qs9jPfcuBt/h4KYDwj3+sAY3qiJIXRDQm5TraoQ/VWquHmsJ71sPmsbIBEQwENyv1YmSq2cqgDhvsyOozHLCsubTbH6IEw0EazGCMkkUYwhbIJ06uOWuIWP4Xsh291BpA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Sat, May 02, 2026 at 03:57:19PM +0100, Gregory Price wrote:
>> On Thu, Apr 30, 2026 at 02:15:19PM +0100, Matthew Wilcox wrote:
>> 
>> fd = open()
>> buf = mmap(fd, ...)
>> mbind(buf, device_node)
>> /* fault file pages directly onto device memory */
>>
>
> maybe more explicitly, something like this
>
> fcntl(fd, F_SET_FILE_NUMA_NODE, gpu_nid); /* pref node */
> mbind(addr, size, MPOL_BIND, ..., MOVE_ALL); /* move existing */


One existing problem with this approach of using MPOL_MF_MOVE[_ALL] (not
specifically about gpu nid usecase here) is that, it only considers
pages which are mapped into process address space. So, unmapped page
cache pages are invisible to it.

So, the problem which I am trying to highlight here is - Today there is
no mechanism for a user to move/migrate the file-cache pages w/o
incurring extra I/Os. The only way that works today is to first populate
all the folios belonging to the file into the process address space by
issuing MADV_POPULATE_READ and then issue mbind(..., MPOL_F_MOVE). But
there is no primitive to populate the process address space with only
the folios which are already present in the page cache (which maybe
residing on a different numa node). Note that MADV_POPULATE_READ will
read the missing pages from disk too.

So, maybe something like this.. Would this still be useful? i.e.

madvise (addr, size, MADV_POPULATE_READ_NOIO);
mbind(addr, size, MPOL_BIND, ..., MPOL_MF_MOVE);

MADV_POPULATE_READ_NOIO should ensure that only the cached folios
belonging to that file are mapped into the process address space w/o
doing any extra disk I/Os. The subsequent mbind call with MPOL_MF_MOVE,
will then ensure that all the existing mapped folios are migrated into the
chosen numa node. And also that any new pages which gets faulted in will
get allocated onto the chose numa node because of MPOL_BIND policy. 

I believe there might be existing applications which might be facing
this problem today. This can happen, for instance, when there is a
workload which can run multiple times and may run across different NUMA
nodes. Our internal test team once reported a similar performance
regression with llama-bench on subsequent runs when running it across
different NUMA nodes. The reason this happened was that the existing
page cache folios of model weight file (from the previous run on a
separate NUMA node) were not getting migrated (because they were not
calling MADV_POPULATE_READ since it can cause a read of a large model
weight file into the page cache all at once).

With that in mind, do we think having something like
MADV_POPULATE_READ_NOIO make sense to address such problems? Do we have
any other usecases of this too?
Or do we see any problems with this, due to which it never existed?

(Note that I haven't yet given a thought for how it should behave for
anon memory).

-ritesh


