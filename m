Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAFBC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438FF6B0093; Fri, 10 Jul 2026 04:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4103E6B0095; Fri, 10 Jul 2026 04:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FF4B6B0096; Fri, 10 Jul 2026 04:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 116216B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:54:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C569A03A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:54:18 +0000 (UTC)
X-FDA: 84972255396.07.B87B99B
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5AC7C0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hrbfdunm;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783673656;
	b=e5mk4JD5CVJwac3fJEhp3YqApxv7JvNrk32UokyA3l3RxfA1Trir5yg8muy26kaEG5KeZn
	Vl8hnpuxsYqXicRr+dTwMbr6YMxdOAaS+f1GyqfcY6G1fwuOlL+GM9X571g3lPc2cnZL8G
	xv8AFSEFCkk/eEKp12K/VbvXnYDvDhM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hrbfdunm;
	spf=pass (imf28.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783673656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfyxUe0AubAJFPIEICfIoiV88xma8/wDPcu4g6C27ww=;
	b=otIFQO2bqds5TppV3bPNDxu39Sn+3vHaEwNqubwZmff0qTmU50ghayrCElwcT2ze+xK056
	0xz1lJ3XtlZLfOdTvWRkXXW/TkEhd1UcJ9WcpHi91wA96dSj5Kf3pYbqzNHLordjhsiKY3
	zBh+aD8RGziGV8JnNZ9BsrpTRxorVv4=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493c19bad03so5506765e9.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:54:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783673655; cv=none;
        d=google.com; s=arc-20260327;
        b=se5actLLYYNPbLoLwKzYfAP4lvA/vZ11ZkgbnkmgzzXAcFlv869n3VLx8LXa0hj+hj
         4b9kZrGAJVQm7F268i4f8/IMosls76dRBhDLw5kc84Cb7Z8Dl27iloFvKgm361YKsJ8C
         QISmOPD3m0HpfqqocpA0okJD9CaWXJCsHTXCp9au9G4H+qYwzKhm69wp3jODdV+N9mqi
         O6J7gGvX2EkEwCIUOKcVRgDK3DDwkL2CU24LUcy2qqZuUhTFYK+1YVNtlNwX7EgYAeB7
         2/5NCrABbtMnaBurLYavDs/aWaDlesiijz9d4DuhTRkEW7DLZLnzypSCPkgN+z3FLho1
         /E/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=jfyxUe0AubAJFPIEICfIoiV88xma8/wDPcu4g6C27ww=;
        fh=wY469C9s5Cd74e9ykMkiSIC0Mh/ulxEbsGOMfzdUsO0=;
        b=subUoQqUdpLysRbhawkkmJ8wkXJ8l1tt0psMhQzog1uH2GKJgDPAa3gnPejtcq5Ytl
         DJCNjyDKLzyvsIRC/uKyT55Xnvq6+6zDWPG+CSqlC3qWIb6RaDweTr27vEDWO0DbgZHk
         WQfZMYKZfdKZzhLV6w3HMIrv2ouUO1pFLu/xA85dfsnPZkeGAfHR4qSeiBIpFVuXIDdQ
         c2ShO7lUhViXlIa+hMsF3/znNHzEVcf6tjcXWSM2iQuqGNqz5mg3qfbLFS+9jbR8nzi7
         ktIxRCFuiYZKAvUo/gyWSW4zp6LriLkOHrH9qfr4RjxTbxqwzUFuB6hUan+A8oCx8dYY
         pNsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783673655; x=1784278455; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jfyxUe0AubAJFPIEICfIoiV88xma8/wDPcu4g6C27ww=;
        b=hrbfdunmAzQc/fecKHVrGQgnvWofNE1tXeZW7V3kVIhe+fpLOo81Ip1bAP+RvnZaj2
         OFwRSqRTQJ6lx8ooe0Wk+7e/q5zgU94IpxYqxrTJ/uaZIvPTrqDGjAtPRLwhXkvTe+Dv
         FBB356Kmu8Yq0SsIH2bydXBH8bdZNqFiJasACvEm5T/oILHkcj1AbRN14oLKSWPmEJEa
         +zpcmhMFoo7a6Lz3D6yaRUeoYIiltOao1MfsUqS0XALYGFukR9Ojz8xK44+VC5+Kv3Te
         SMvFgV7n+NTNflaC+97ACfZ9qvOBXDzu0k8bBMI6LBLCNQ8s/GoWLRP/FzkHyjgi54eP
         +K+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783673655; x=1784278455;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jfyxUe0AubAJFPIEICfIoiV88xma8/wDPcu4g6C27ww=;
        b=aniEJ5z8EuZmRluTg0spwzxc8fHpH1ehh3iL1FhNywWI17Cfc82MYuJM5Zgcr6evc1
         cCNSqbKklXFR7rwm2noCNU71qyJNMS1qAe/twNX8tO1Mz2KDlcJTSUQk2TYEARui2nUa
         AkH4FQqqyD9J+nga+OoGSgVcSQvOg/uc20gUz9xoUwxaFNPnBCj4TUBNxyI5L872+L2a
         hOroPib8j2e/Nqw6PA3z8NX6c7N//i8cyHRHZ9QSAx5ySpXet9lzvdEIij1wNTxuaZur
         PPviPnmGqrtmpGEgeM9DnC34woKTkHWkJWPoi8D7xw4YqxEV0/8YS7cz30lM3fRpQFsu
         hj6Q==
X-Forwarded-Encrypted: i=1; AHgh+RplWqlo/Bds5bYGGVbnPmvWRJgHX9JFWh8/kx+YhTovvcpMS8euzQYpRGkdMa8widtyzxAD28bm5w==@kvack.org
X-Gm-Message-State: AOJu0YzQoTkYguuWtdoiHSutQS+pf6A3WVJwYWIIVkqyePYg62683bkh
	CGCB4jrPNXgomwrFsnqVS8Razo9Hb2fv6sQ0cUIXz8M6o0aColijJ2hGuJa08SuzRPj52pO6CIy
	S0H5r9vFC/gTg9WK6Wiq3QGFSTwtpaP8=
X-Gm-Gg: AfdE7clBFp37pHntv9ovt2v/4tGLhxqAhbHPoQkw9Q51GWRCOOVoPo7LmvM2WarMNhh
	esbK2Iu1FwYsGqqLpucSMrG9Equ6o80v5mtMAI5iO6ZBUwN+9VHMD15H5ZI4HYSA1M0hczidbU4
	CorxAf5z9yTmL8GdEr46KaIpONMZBA+BbutVQ+XVlx2/iZZ4bV7c/6/oWlo8hnz8c4K4oh6juDW
	sXz5Pbytlnr7PmcsAPTYeXiUbd0V86iDhODuMJyu6PEts7qar/aQMk1GvVum8XcHOWCxbaE51/x
	OgNkmsiM
X-Received: by 2002:a05:600c:5299:b0:493:eccb:8cb2 with SMTP id
 5b1f17b1804b1-493eccb8e6cmr62025005e9.30.1783673655004; Fri, 10 Jul 2026
 01:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
In-Reply-To: <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Fri, 10 Jul 2026 16:54:03 +0800
X-Gm-Features: AUfX_mxhkgYSqJ8_goQZn75OlAX0v0UTx2TdJpHp7v9hd8vfeV3Nuoxebe3-rm4
Message-ID: <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5AC7C0006
X-Stat-Signature: qpn9gk1aa93dwxpebwu5ygjqez7f5c54
X-HE-Tag: 1783673656-280595
X-HE-Meta: U2FsdGVkX1+Z+1vQV1mmEX9Jl2lDTxyccKZetWcETfQLxTaH9jFthi8i22INxMwL5PDUQOl77dp+I+ONSYZfEoiWBCvhkE4sQTclkJYuP46E6U1qimc5N57tskOMPDFSH+Uh0HibHo/YGU+XS1z/Gn4RWiTKgGA/gkNnNA+brXTOBhQDR2SHd04raVD2RJBpCOWt+ya55MXDgcZq8OkMBpBRrO6fQlC5zvNEI6EUowsFhDQrCdpM3LrbASxbn1SmOa79OlO49oZTGAqgTlQxIe3Zrm/TxoVc3LwdH7LhPwB26iH2IGhLo+0r97Mj69GR9NqhuFhaB4y2dVjRZ1T10/WNdP+OhkfvdZGMCgLwix1I8nbePUggNeQyaErzlbUsvvnSwMQ9d7K3vqm0WhhtiAF3s0ztmdDwSSMRcdsQHRxph6hB7yblU1kI2qltZEe/4lhq1iI3Jsk9YSUR+/Q3CNCbSlRHZY0sEfSbnapr69UUIktPpLyveduf/Rgz0FJc++w+Gm+9Usn5fV6tZVaHsIChl6sHf3VwN8oGIJtg56kOrVGQ+WN0w7PW6RVaPc8qeY2N3DU7renSl/GmdqgzX2MrsxQrGzVQd5jvXSNTJGY6xIziDTZbp3YaiW3x3Y9clFj68WgDxgws5njxDuoiOeC4opoiZptq+nauyM+a4zUHKTOMKh0DVRjyVqiHVTAp00ngp4orcyh4cl1Wt8bK1MT7TS3EolfIcbQMvICimImK4a50zlrI2oWHw2JPm4QHCFQzg4ctuZsL1Z1xjMGTZDmyd6swAWPpCRyebF8rEwJtHhAhCrncYPwNDB8idst6Fz05MGG36809ZfXs5dBnppWoyG2EusDBPPZG0xdQFUrZDGvlfMi9IhEnxWQwtYDoc3vE9BJU74n2Ka1FO6KlCY/ymj7RCqmny/EssjAE5pKX2k7CNBAe1J6iq03uOGtxfrhsaG4EziEphynzdJJ
 IjTIZ3M/
 T2I8QkFSobXIhOQd2KFUG8/8Q4zmKX2ufT7G4KmzfU0IQvc8zXO/bAJjkw8imBUnECMte/PTGwGLlJ+2Nw2vTFDaPlLT+79PozV5G+BHtIFu9e+p1vJ1ntrrg4rH4mhA8n/AwgvEQnMOa+crSFTy/I/T84dk9BbtUFav44jj/NV+XQSaxhae9dD7nnLfY7cmqAA6U1+TGOms8kK9osI38/toZZxR822v1Pn5MBkewltG3N7x+R1HazaxkKEqY/6UQCayuUwlCFuDlQHLAqi4l0n1YXd6f6KyQyXtNDb2LdSIpXZy97vE4SzqxE/9PYmWwoMvb9qCOg/znSBEdYOdSrQFu/w6Z8Y1eKntuhzwanxOpL7PuMIApeVX2rsDLmlXM7TQgHDPe0EI6i34/O7SpPAVCGZ+PRwvbeYbNUQqMAHO7BYzkcpRA44zyrIgeU2CB97gfaDvtPqzde7RcGE6ZmUMT+jNlPTbIikbg0/0xbpDsrK36V14bF2LgWFjGCPqRQ7ngy/GwISOc0kt6yyOg7ZTBMQXb0TLxF2V21L/ji7i/SmDAUDEujQm1HKaX/kScM3d8wq+9Segb/2eGK+nPjJfze71xTiI8nw4x/AsT+Pessgqh7rGwsgd/HhwQJlZiQ0Rl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory
> > is physically fully or partially contiguous.
>
> Thanks, I added this to mm.git's mm-new branch for wider testing.
>
> AI review asked some questions, and some of them are new since the v5
> series:
>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com

Hi Andrew,

I've gone through the Sashiko findings:

- Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
  is added. The extra sizes are only used by init_mm kernel mappings via.

- Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
    array of valid struct page pointers.

- Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
    already discussed in the V3 thread, and a separate fix was proposed
    there.

Thanks,
Wen

