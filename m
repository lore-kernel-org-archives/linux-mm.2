Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E156CFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579136B008A; Wed, 29 Apr 2026 06:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550AD6B008C; Wed, 29 Apr 2026 06:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466E56B0092; Wed, 29 Apr 2026 06:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 368F46B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:33:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5F2A400FE
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:33:36 +0000 (UTC)
X-FDA: 84711232032.30.9E169BC
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7BDFA20015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:33:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=o5bT7MdE;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc1bdtiiLVnrHG/ySdu4hkFQib6QmOtBtlzbNliUfdc=;
	b=qer0pXuqMZxIITs6NdzQOYX3Oyauq4bGxyRHy3s5tW39lvkU6sRhejQGTxelNR2GbLeBRj
	blDz7ovnnstn79zh6+nOzGpwSnTPa4sPGD+7k1jn9vAKxZFZs971zF/MnWX2bIfc690k39
	ohNZId8xZxKTxXKT7GxBq63fyPOD50Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=o5bT7MdE;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458814; a=rsa-sha256;
	cv=none;
	b=bARBHkBqrShN2+KhWvaB4wSfG6YWaRYOLWxOSH1i+DoJ6ru8GRv2NXYCs7pdln04mXyKYt
	T882/uP8Nsgnav6JdJgCBEJE3PNgeDQpByxg7b3kv29hGPCVdmCje6oxWjXPkYc/jdcKK1
	hZMtpIWyONYoTr0sBwcyIqkl6KR9oPA=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43fe3e22e33so7967342f8f.0
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1777458812; x=1778063612; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rc1bdtiiLVnrHG/ySdu4hkFQib6QmOtBtlzbNliUfdc=;
        b=o5bT7MdE6JHHKAdbqBrPCdSEX40hIqSmBPRKatGv4rATGHpLQNsUGAxWVVMx8fBOAm
         cPb+VHIeffsm6icPBKmyFxlNA/ZWH4/EkP0hWJu9iBpns2FPibmF65998lGmJgM78jT1
         mZ7n9kMogdi5UgCNPiW3I34DUVP2SThF7n0RCAz9afjn7iJYodRxBEyU7W36PCV0E8CT
         QLrTgqRJYDnHiZX4zbzRde2VvccTPtNZPeeCD0KJp33NYrKbQXCe+98o/kc5tQAxCJMi
         QuobojfJQv5PlgKZrpSAQGsxaMFpEvpJcdMWVVDviZkfeepw7PpwheyPq5IlkH8NoSxj
         AMXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777458812; x=1778063612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rc1bdtiiLVnrHG/ySdu4hkFQib6QmOtBtlzbNliUfdc=;
        b=Bxo5gBKtjswcHZzabFKl+rwfIY1P7zuQA6BzTAIvRzO/osnzTTZ+kRMHhQjtfWb7N6
         MZxFG3dEJZCcS9IIjzGLOcDljPKbPkxf2mVeaE9KqBXD3LE46dSQnyhTnumvovI21wn2
         BgDY8QIBY71OAsj/YLxIlNfKJ/9o40xSATdADPAiqc98pXv1iLNa3sQL6SsreOsgTuWn
         8UfGNWorbY728aw7J8SnO80XW1bTTUb7Ds15EKtsVTno6HQivLLysdxig93GiuF7RX+G
         UnrXKmZ5UvmRZ0H/+dKbDaLht7bEFbcWmu/0PCqdpKcdC+4g95j8PV/tdtOFaYaLXVmo
         g7XA==
X-Forwarded-Encrypted: i=1; AFNElJ/Yb5fRE/vAqJl6Ym5RQc/kmxfHE2wRhptObSrrr0R0AR6Pgog/0zSMS3ol/Yhng/4IhOBqfSnUMA==@kvack.org
X-Gm-Message-State: AOJu0Yy4jBxm4Cq5NnPZVraV1LzqwpfTsk/1iCO622VpqiJERnXm7s78
	sKDhK3GpFjvHp4cuyKUuu1l8KXPRgQ5d1HG1xDhcsHpOILD1UlxZYw/gJmn2FBnPI/A=
X-Gm-Gg: AeBDievn1BhbXzNqtAkcMgAuBZtJRYKn977fsPpjbagJlcJBt1EkUXSkSJYxYL08BaW
	zkVXqVdBBmgo0VtKHYA01dIA7O5wlP+glxHtp/gCzehY2rfLjwkzY/TP26owdlEodcnFMVc8ppa
	e15E8u12qH4nEnLFDdmNgLETQeqOB8WhBFpApFueLjG0GqQFQmjiVYp8hqQMpQ/BLoM37I3j/RA
	GKnAtVYdVhb1l9RsPijWHbf6j+8pAMPvQ40sscZzPPcawxV62u+wu2xIoRfJeK3DYR0FUuWPv2y
	nqHlxwsIUEvMxxNCMoym3JLF6UvQ/D42Djnsrd4FXeu9AYWA30G5UMtDW3Nty5yXCz/I70PPiZ9
	iIkO6eoCho7+AWAzV9NSwGKg1/HJZ+lr1fUifnN3ADDpGWL2uXoWgPXw/LDDWQyHHFXXubcxP2D
	y++ACLdEY7uBW6k3Y=
X-Received: by 2002:a05:6000:438a:b0:43d:c95c:5e75 with SMTP id ffacd0b85a97d-44648f28e79mr12311770f8f.4.1777458812324;
        Wed, 29 Apr 2026 03:33:32 -0700 (PDT)
Received: from localhost ([2620:10d:c092:600::1:ef7e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b3d481b2sm5124018f8f.4.2026.04.29.03.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 03:33:31 -0700 (PDT)
Date: Wed, 29 Apr 2026 06:33:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
Message-ID: <20260429103326.GA1743@cmpxchg.org>
References: <20260401101634.2868165-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401101634.2868165-1-usama.anjum@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BDFA20015
X-Rspamd-Server: rspam06
X-Stat-Signature: ypr9t5wrz7bjmznd5u1nmz7p9os16d3t
X-HE-Tag: 1777458814-769094
X-HE-Meta: U2FsdGVkX195jpPuL1Toy5ufYl2T79Q2eRTI/zbSSJUK9B0+p/tT+sgx1D2egeU7Zw0Cqh6K9zm3I4TtOpUIBtpTt3OhosVkw92MSdZ4SSiesspkSHmZJZBJYg7fnJLKtYGcxdZhwRtlyBSduxebeOomtpKTvwP2Pwn+VQrtd+P6MGDdZQcz77wjyjAUfGhhYDswT6UPKHyGshFVdH8TpCXDQB4SMsM2difVzba9CKfsMusryx2lVVZWMc1GKv+UIbCJ/yhHc+io6ljyLnhtt7AczZinmuYDwf75EX8JwGI2DX2wpcUCntKc+seRWJlpm3e26kkFVXGph1p9syOkwdGnbCprXnZHgQ9er/A8nG3FuPl1Pdb4kRbhj6kDBujVF+J+csc2Y4RV3GoyiVTX+9rZ9UGlOOdCPGA5XUJ3Tufhss0YwoSq6V8v0x0dVORSsdDkNvkddk+1UCiFm2StolEB7CnrZycFHpvUd2uBPbUd6Lhknw3QCdQO6UEMpTrI92EO4uMgj9COKY10t34kdCMjgL0CtekhSQG9DX+OnLu77v+yldGC2cqmskkglkQ+VtrCgzvpueW6nmhpygDg2vTH/ZR+jqlVOcWgi/mDOUnKSIXpoxI23qkQXRRBkIA+yF6NGRGvoCq81Qqaa+sIaqkDqKS6YHC9e+aA1LhZufdBxU4mbmwh/ciA2OoWI9Y94ShoX5Imvy2/bGeMcELIqSfQw5y7DEAoWCyVj6Upduu4zUJcm80ucPr95c08oLo2sFnkSN6+jMLcyC0wA1NwfziUk3ExK2tIEbDEOFvwI86nHOLYZMcQL4wMrjKFD3sz1sfthjIW6odtS4qvmuYoD7GU91eXSkQImnL3gmqeSF8TK5NRnJjVaIHy9B2WSqS/2cOzVXyLpwCZUy2nfS3/pXptOiIsjfBATrGCXw93vOtO9UGX24VUD+TIXLmpgkOMbWyp85p72LAKCNUxdeq
 ZSBcdA5T
 RwV9o9cekLWbr/oSSbPROfJ28b33wn0N/cuGPBaCifuQ5AdjDfS6jXRSntcW2ND6YIU8iUVZiYKSlJhtvCET+DRpVa3HNjCbVy38i+dCsvyDicr6RNGQrV8fglhqrPBDnR818rKeRaLCV975zjelmY+kTi+2uFrfwQwgt3dlIO42s6sONGXaR4bGHUfiZ3hTQcW4oaCf5oYcTOrEhyz1W21FvMbVXDFVx7zWxPAw1huaocTRcQrANDOKLt/luVqRdXinK9cutcoc3QBivciZYJfrZH57XMBRHoFX4t6KhLXCLBBy1vKsFn2Wee5xvRNbVIV3efnegXDYeRKHO0RIPwCJLCAmNkWz8mjoKUgljai2RDnGLkc77dnv37ODl/nzzQRdFg8Fj8eyIK124dus9zzj7g4tMejlgWnm8If1kVCFkjKhjrZZ1QURcpJ5fZBxLTFOjWFpFyaSxa8jjPkM1K643kQMSd9svGmzx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 11:16:18AM +0100, Muhammad Usama Anjum wrote:
> Hi All,
> 
> A recent change to vmalloc caused some performance benchmark regressions (see
> [1]). I'm attempting to fix that (and at the same time significantly improve
> beyond the baseline) by freeing a contiguous set of order-0 pages as a batch.

I think we should revert the original patch.

The premise is that we can save some allocator calls by requesting
higher orders and splitting them up into singles. This is a frivolous
and short-sighted use of a very coveted and expensive resource.

The buddy allocator tries hard to retain contiguity *if it isn't
needed by the caller*. This patch actively works around that.

The cost of recreating those higher orders elsewhere is shouldered by
whoever actually needs the contiguity down the line. And that process
is orders of magnitudes more expensive than we save here:

We're saving cycles per page in the vmalloc path, and later spend tens
of thousands of cycles per page to recreate the contiguity. Scanning
PFN ranges, folio locks, rmap walks, TLB flushes, page copies.

That's a terrible trade-off.

