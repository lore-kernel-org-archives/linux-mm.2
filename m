Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D86CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06D18E0005; Wed, 12 Nov 2025 02:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6BB8E0002; Wed, 12 Nov 2025 02:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD1D8E0005; Wed, 12 Nov 2025 02:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8578E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:29:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D36413ABEF
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:29:11 +0000 (UTC)
X-FDA: 84101128902.10.6458EAF
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5EA111C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:29:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktKx11xZ;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eC7AqgZQkH9Bf8jeUIBuhznj5sAlbf4jzNtUK6FuTHY=;
	b=zQkMh9N66DOc79WCucJkoPcUpgixkJOvnJ1B9XbUpu+Gw7vSKOMI3Rd1RyCsTWKJDTtC+r
	n7L6hFZ9DHTQfhwiaFD8eUneYaeq2tD8PvCtiN4LxfNwOYNLx2Zgyl9kexo17Vg9foz8xp
	JiAe9IuO5MC3T6MkFF1jGk+WuddZd6Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ktKx11xZ;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762932549; a=rsa-sha256;
	cv=none;
	b=azLPeJ0v68VefI1xOLnHvwxswk/jo6Cl7g5MwvYr7wDX2QS3X4GC8A6PbGwXAlMSbNCP9d
	nwcEpOpdaoJpaWuaYD3yKUN1booXOIA7LHl1PVuVKIoX+dKtXWkhNDbedgpRfcavV1n62F
	56j+PqHem1wYQbx5V0gK31BP4m3jD4c=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63fc6d9fde5so519322d50.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762932548; x=1763537348; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eC7AqgZQkH9Bf8jeUIBuhznj5sAlbf4jzNtUK6FuTHY=;
        b=ktKx11xZ1lWC7yRtKoyaBM15Wiy2+WBKrjO7QoJz8/Vf7EjUy3tRVvIJScjLS6oOQm
         rG0/1llCNsnsr1++8x7eLMU4s2iDtUSC762SeBKHHaAmgxRvWzDeJjGLRo46TRyd7aaT
         wutraQwpuPBqgGbgYGHx1dPsCz1WhwH9SIxTWTLwYx4Q69Fdfp/C9yd1xO801kxdYrqD
         Cv2H9q66ctLDwmJ0O2HWJ4ZFQxbpa6Tv2CGzqNnLJ2HcexyvzO4joiF4StPk5doBIQ0D
         Ojmc6ro17kI5fFI4OYt8xoUdqxmaNSixXXfZJ+H4ku1HgDXE49JPj7Ybzp2+u/CQCKCa
         1JGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762932548; x=1763537348;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC7AqgZQkH9Bf8jeUIBuhznj5sAlbf4jzNtUK6FuTHY=;
        b=q00k8eQkT1SlPT6236M1xihB4ketnY43gHUMHzD8plQXBB7t6OEfYMe8yLjUuNIRY4
         pp3dBL4fKT9AULaUUTLkQJd9ezBVJYFnkLM9RQibeqAq1psYDs90INBhF2TPVdXUrn6l
         TybOIru2FjmTCxUmVju6nAReOutVj5hb/X4dMYZPkpFLkoSkWeFbkt5+smHF61cca1Hn
         m0FBhRCXCz0STT/6EEI/xKEkMEd56ZNPIstfma7gzZpB5/gFqlzQkyi4bk8iwlYaq/p6
         j8RM9j2ulrTrhKhFgJPDHzsReZLyhJoJO8wr0XFVnq47xZIVkg9iQKxGT9gPkJ1nutiA
         xHew==
X-Forwarded-Encrypted: i=1; AJvYcCVv7id/OGRN9ohISYG0LtB2u1HCNfTihwLEneaJLKfF2zmfH7bXkAqhvCoWA0dvuvaTQn/OFNPN5w==@kvack.org
X-Gm-Message-State: AOJu0Yx8WZhP4nCHiTMxSJ8QqVG2CwzCV51cgUQcr/jA/zbG6jt6KukU
	3yHXLbE8eSd/9F4AEQZz+/jLpB5PHKnvutc4mZbhV2plpx9dZZh/ApJS2aNwiVUiA6yq3fcdHPW
	AGdcVh9ua7gvNdT0+ffyUcv/UZYwdOgI=
X-Gm-Gg: ASbGncvt+PNsjqm2OwsGsHQGMGjVkXrvw68mZXLX9oFHGiDzEUK+iX/HJ8JoRZSQIe7
	hzr34hh6olJqAO/VK8ej+UkI3Zw6qSsXh1CBg9RZJzxtlTkJqFjr9o5MT14MwbhkNFiZQ22zhrC
	RaPx8GNiMTcmsnNF6GL8tiM65onrLGIsNRwGQ8du6fbFgSQDBYHZBrvlij22b2UcgRiwBShJa2M
	vS+xQoesevmwR+aIp3SuwrgmzHUW+Pk/c7hNRTBCqx2LprzKXWCFO8ilrq8CwoPKP2+AgeStTJ1
	qQCKRFSAaFiDZAFIuA==
X-Google-Smtp-Source: AGHT+IH7KULuuRrF2Oly5Rimc+QhsJIxRJ3ajNz39rkRuKHwfzBK/tXJ3NwVa7aPrWyci+T55J/S8XdqtHfeU2E+JxQ=
X-Received: by 2002:a05:690e:d44:b0:63e:18d6:72c1 with SMTP id
 956f58d0204a3-64101b37d64mr1604942d50.46.1762932548401; Tue, 11 Nov 2025
 23:29:08 -0800 (PST)
MIME-Version: 1.0
References: <20251112031631.2315651-1-kartikey406@gmail.com> <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
In-Reply-To: <2a10f8c9-dbdf-7bac-b387-e134890983df@google.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Wed, 12 Nov 2025 12:58:57 +0530
X-Gm-Features: AWmQ_bnwRTMjo11VJ1_SlN2ozfCDVzCWYVVmlr2dEKduOizviC1FKYdbRb3--IE
Message-ID: <CADhLXY4qMvBTqirNmzgiPszn8vCkCFV6GGeDkNpxVDi32uhzEw@mail.gmail.com>
Subject: Re: [PATCH] mm/memfd: clear hugetlb pages on allocation
To: Hugh Dickins <hughd@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EA111C0003
X-Stat-Signature: ewukwz4o75g7s163rukcfj3fjt843yoy
X-Rspam-User: 
X-HE-Tag: 1762932549-787614
X-HE-Meta: U2FsdGVkX1/gpyDTSFiUfZ3efQB4G5ix7WecoCma2pZgV9BwZOx0lXLhsxHjM8O0dlKqIjdzfWLKO+uYKZXK2+rR2VoJdRf3wdcTGFlezgdVfGCN3AXzUdBjBXQxKLQaCKWBYmaU+EwxbfdnllG8OOOAT5ltHc58NIH3ETVygMBOoXL2KGDOKZxgs1pogjuMXA4lCg0M9EIrCZALCTTZS4M0uqzml7xr+7FKWD/rTN75X3N3fuwBcyGfY7PH+7thb2AwaWGqqdFpF7SaJEM1HihPclh9xFJlUFgZe9v3q0Mt+7zLSLS8GQ6w2F/fP/P51V9FR9D4WitTGGtVJISi+6NfemR9RB9FXg2Mmi25CWt9ti3xq/3qwywTIHaWGuv1+y3E/2xJRFciRrE00Umpsn6FUWCCB33/uJW7hGaPHJUogRWkhBQV3drLjuaugz67KiBFDOYZLhQA+Z4bMM+Y1fWH8hiROEaGNxkap/U1OaFtsFJk++3MyE01FYmAsz//4oTNt+orL7JVRi/rKysNuQ+kPMufHe4iWS0Won7iTafBOSu40IznRwMxcINx91kEDMKZ2950Y/i1p7roQ4zoXW6/xgqLzGRQ4xPaDy0XV7vJlwBR6P13UPSc4CEt+mvJUDdbebtpnA4sNvTDxkRJ/N/MraxC/1HRKmVGAG1avSOGRseJB9Xceog7Y7EktoBED8p44nXU9dFu9cfXAtOQMIfN5sqLvcaHIYKsNO+yqdvV2trfpcg1+7NHNO0QcYT3ATszZP+OB8XvpeILtmP6T+GFVfRnnTXPpX5qlZwwrinbfEleT2kDTnPafKIVMXG8WaXcSPf1n99JNiMpuey3GE5EoX21iTpflUg6C465zDCY5BXDGClMVzmyGnNcHN+te3HHkxV/ofbs9qC5MrXea543QI8YsvlJTygQZbFojF7Tv/DJ6Yus7+XNATI3LYqCbbwHkS8FdlOSlmrFsw3
 D4raiJUM
 8lh4Jg7Z5899utZ0maEoSbpNfIfTBy+nmxO1zVMfLlG5R1Nnvsz/FRQ/8sNB/LU3XWRSvOHl0P8RaOONdilW3aQqcnTzOJiSp1OBrCTgCo97utwVSK4/hgRDW0pGs6arig0Nz2dugYodbMBkfRZJ2Xwr1Q/UN1CX8IPv2dmQZHmJyKECQEYJ6cSowfFbO8ByN1LJonR6hNW25ARoIeI9pI7CJR1mY1aRablHh0tKLaHhfCJIsiXZMpvJmxL/1Q/InBFTYgLKD9GPA2vV4qUlkh0/H/WuazMQjvnOcgoXh5W5LfdtGZold0W/jGD1IpuqVebC69W7zldr3ZWnBo2NtKkKfd4TpDKBemGP3smORI+wuFJH0oKfUHSO7FvHKPzKqPWFNM4EH537SYvYkJ1Z33ApHPB+cI6MIEnxq3czDuIFLXbvGvNQ1mBKMj9dp5EwLg6/gXln98NXqRh4FIq9SCLb7HlcdYg9dnIEi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hugh,

Thank you for the quick review and for looping in the hugetlb maintainers!

You raise good points about the approach. I chose explicit zeroing in
memfd_alloc_folio() because hugetlb_reserve_pages() can allocate pages
without seeing the __GFP_ZERO flag, but I'm happy to revise if the
hugetlb maintainers prefer a different approach.

I'll add the Fixes: 89c1905d9c14 tag and Cc: stable in v2.

Should I send v2 now with just the tag added, or wait for feedback from
Muchun/Oscar/David on the overall approach first?

Thanks,
Deepanshu

