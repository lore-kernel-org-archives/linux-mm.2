Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFF3606A337
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cPPX+PGa
Received: by kanga.kvack.org (Postfix)
	id EFC5A6B05BC; Mon,  9 Nov 2026 06:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACF86B05BD; Mon,  9 Nov 2026 06:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C3F6B05BE; Mon,  9 Nov 2026 06:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B30376B05BC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:07:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43BD4C063C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:07:24 +0000 (UTC)
X-FDA: 85415304408.18.E14A53B
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 640A9A0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:07:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cPPX+PGa;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794222442;
	b=0a21ZL817lvYPP4vgSMiz9+QFMQgWsi9sD1AG3+sE/Mzt+3GXBwicHyre8jL/h+5ZiPuwN
	6EETU00i1Vx0/CBxM9a/ceZ93nVU0wiw9k7//S9bOQLqDVMVtO25xc+OKIVLF8nkRF67GX
	E657dI9CmMvh6GHUHjn6g9asWS/TG6g=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=cPPX+PGa;
	spf=pass (imf25.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794222442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65mXDclEWyE8ywbYwWS+OTM5iohbgv5+R25SHeg04wo=;
	b=y+G/plTvhev95E3kcce/ftwpUx+TcaJsrvJYe4bJoz/AGl64+9z3Hq7i3Y2tvYP/PWgcru
	gFxgBBuYE0XGJxCCbsn7+44k8cygCGE1WoMOoAwZxm4crsSXS4NAlSNwK1GGkr/Sqp1oTy
	igS8fmk55MhnDbozwaWPMjBTZ8w5GLM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so5679495e9.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 03:07:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794222441; cv=none;
        d=google.com; s=arc-20260327;
        b=AzfJeQVYSvhSr1fIKA62XuvQl0nGcdxBBmcFxChtQjMG/CkQ/fHq6Cgz7sozPtQ+u4
         W/xWbq7EpfrCIdkWfM/UKq2jLUhriFpPPeID2PKEfiRXCh/SZqXYi1Gwjs94PeOfoudm
         C8cmiYIG/1BlnYEO9kklhGHX9T0fZFlyNL0ZUbLyQ2THa1YmxpJmukQKvkN6dYK80qoO
         KRYIlrxbXd3cDXRM4D01A1bCBCFuG4nz9KldKIgW540Z/hJTVzLht9mbbe1HHI2n+Hjj
         GD1VBrGNx42UxcuODZ4ZGtecH1VA1ZG4rOhj4JEKcVGO9TRaEuKIfhA/isMqJm+VxFpi
         rQVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=65mXDclEWyE8ywbYwWS+OTM5iohbgv5+R25SHeg04wo=;
        fh=5+M7KHItMRM7pV8b4SqAHsEFznqMoCbTmnR/WAohS7E=;
        b=fo05TirvbFWWdq3jYyLFSPRED5rkKF7htrsX51/QbsNay96BkgSevJcXyMkxfkwIxg
         bM4BBxzedFCzvd4cdl1RseJgAK1EMaDt/uBIXprbmpYoRk9gsmKeKuyf/eAvudyHETeD
         dtFEcMl/a5tDiatYbMUGyUXPJYbLrw0hBlz4UEFd2qXVbX1VC2D1mNFCYelrPmHQ+Nel
         XzYq3Y5GsJMHViDa1nKA3rHIynJhRHD7rTox61+eFBdpiGt2aVC7kJ6WrucWPRurXIK5
         zSKk99S+E1jHTJP9uqLiLhxgwr45G3VERN/OvmLcEEIISrJ46SnNeGlz1hIMzS93KmQw
         X8Sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794222441; x=1794827241; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=65mXDclEWyE8ywbYwWS+OTM5iohbgv5+R25SHeg04wo=;
        b=cPPX+PGavYWPTyLc4avW1V8LacTXKrj9DSao34rKc7c1YnMk2K7NYO5CbKPcGNJGPl
         09jkmn35BVLe7SjwvBafbbHo1RdzTk/2xVS34dmvGw1zs77C3jFdLfCBjB8CJsGZTMBF
         NcqiRzfMN1Bk3bhj7Vfbfl4dnYHSG9QVrSmEPyMU8JDPUiLfGt93EZU43tmTt70tJOTK
         ZWfIFuM++CtU2wyNqN7kuxKdrsFvbRmBo1bUquYC5oygx20IZQ6RbdIGiXxPCCis+vFL
         MfUyPIhPaeidUtXfUIcsK5R6lx3iB4WtK3U8YBtsbTZI2iZBquq9Yse5C5L5WLJ+FD5M
         dL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794222441; x=1794827241;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=65mXDclEWyE8ywbYwWS+OTM5iohbgv5+R25SHeg04wo=;
        b=TreNPr0vyV1eVRvztqy9C1nKie7yN39fRGbDAJBIdoVwHjRhWnAkpXuqZ9fBxgxWY5
         SQiZ0L+TcSzy4mUWOSJExXzy3uCFTC88dd3fQDmjwJvoPcFCYC3Y3kdXra7tRuV/84d3
         mPwDiAGY4ZCO/b7gvLq+mxU3SoAx5v30wpe+QbyEpi2hDWhxOfMWRCTvwukgYZsRxckO
         TSumpC+mGNewg0K9JXjjDah6rbPt3nRNeNAQ0haZZoq+gqeGa5IMZUKN5QnsQDz5VVez
         w8LQOeY2i9GKOHh/7asmb+pMMzj4sKbXi2ySkAmH+CjuvobP2siTQV/MnJA+l86Am0XM
         hJnA==
X-Forwarded-Encrypted: i=1; AL+hErHSl/HKnWoSy1p1BXx5C7gZSS59VCQMvc1NAA74FiEVx8qnrUux6QNelDVmMcVVCGTjqJJK5tnVyw==@kvack.org
X-Gm-Message-State: APuU4Z9D/Ph7WK0h76YGTuPYnRLEE7xOXCtyS0uIXgaWSvTd848qacgt
	PttnOOWliSEi0x8xTb1zU0DGpCakdl8jxmS1TIZmVabxtLSgKMYsLojQOWuhiBcNJLTz8a2fQ3y
	20tMQjKNLtRgAGzFfq0eGImlkDmxt3W8=
X-Gm-Gg: AYBFou0aURcZF5AfZJ0A07TJ7amedoaRO4Szrjhv1BrjinhR1UQ5EfjA08Mgw1yYdoZ
	N2EZiGU0jM3P3Y2TTCj1k5nz6VKzYox0mra/0002b8WOdO8pkKyBMAZefWe6pUEq7tW+ovQm4Wg
	vD+vNpttT5NVMNMVVK34jMWloxjBg/uuPcvbgvVAw171QM49Ao8plTvmABnBmI5QIjoI+7bPL8B
	PsYUqD4G7KWeK0G5NxRbClCtAXqPdVIoRo/s+ov5Avpic5G1TAYosq9qpDOsnvmFK/ZXFz+GT0x
	kjcGslCJcgDHU51U+EkBGDzVjyfur7htV4ZG9FnkcVWc62MDyRvGb5KTo2abkjgmKBKEzMCPqoP
	/Mmi72TmJh/tHuzB9Idu6K2RCXiMi7eNqe9VPEA==
X-Received: by 2002:a05:600c:3b04:b0:4a2:e0c:2b0a with SMTP id
 5b1f17b1804b1-4b960e9a794mr69581505e9.16.1794222440621; Mon, 09 Nov 2026
 03:07:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261107134953.748622-1-jiangwenxiaomi@gmail.com> <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
In-Reply-To: <20261108230842.3a77b9fe2d4bfc2a04b355a5@linux-foundation.org>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Mon, 9 Nov 2026 19:07:23 +0800
X-Gm-Features: AclHuK99Avp6YitNghM646M3nFfapLv4xavJ0UAfEt09SDcSvaVsVIm1DZLJeo0
Message-ID: <CAHKocdGWE9OVA5pJh33U-FYnNkUqRS0pzFt=rCwXWzY9w-QXyw@mail.gmail.com>
Subject: Re: [PATCH v12 00/10] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com, 
	linux-mm@kvack.org, baohua@kernel.org, dev.jain@arm.com, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, david@kernel.org, rppt@kernel.org, leo.yan@arm.com, 
	xueyuan.chen21@gmail.com, chleroy@kernel.org, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, ajd@linux.ibm.com, 
	jiangwen6@xiaomi.com, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 640A9A0007
X-Stat-Signature: 3bqonxskj9s9b35rdyhjjiwhjk41kng8
X-Rspam-User: 
X-HE-Tag: 1794222442-408831
X-HE-Meta: U2FsdGVkX19ftBXC3xZ2clvQuONpzWax3t219WULb3BAOwJj8xoFRaHAEDnN4gqOAkccGyZC7i6A2GhoQMqu1nV9ecD5H6vHf0r/DQ7dtxv4cIJynus2xiTt5xLjK88QZVivx7W7Bja/E3tFclgSDAMNCpVMNbbRCTB6hjt+tXFPw4kLygiHBusBEAC+0vqvekKJXZxQWRV+h8iIJ791+Gn+G6PQedXmN7Qlo8dkh1eng1BjdU1sbACCXaLN1HPpXhyktnuJsMvK5sG2Q9Eu5MZ8CFpDbZnbWRDXonBBjpmp8awli2YQ9WxcoapXRb/uEkhY0KQSEnj6vTmcuwvXoHgpkD6GyWhWvoJn2rvzzc+30r0nLJ471vNX7aA+bHTlOYcUhbkvChqPpYMdEjTwaQBwsRN2rOZRJI8/slyfpnbAorN+DlzT7XQNz4JMhXRxi9BS6vxsYjUKR03FQ/vIlfyKLkelfOavjuMUPevHT8NERprgNw0122kKiMZPO8JO+qqsiLSnpF50QqQQD+gIqTpckSLbZQWgJcB5BYbsOXauhXhR9/YbkgU5Xc0DI8g3XGACt8K2WOg9MeaXE7Oeivrt216MU6s8Kz6MNHJs0gJhH7z2VU37F0Py/sLrmLOtZY5ehygbgV+tExZwAbssJ7LdjYT6JjuAmdAVK1TrJD+kyHu26wOtZlgKE3D7w1OZVuTMy5Oh+uANd0HnrfgH9voEGAkynKNh5ZbKLao37rjUUBVaHIBOzkbLtB24bSwXDcKnFjZb6R61je41Sn2BmU3lzw8R+orYCIceCeqR80zdSzdEbqrBe6FzMCnqQ2pnDJFcTILthpgNRgiqPNxlmj7IsSbKaG4OMdRcNJMKpizbDq2CHIhfXm6HqeLT/k7xOt2OZo5+Rfu5dFp4vzejjuA2Z/RPTLhbpkuQtLwq2QeneeDFOAi0sPXzotFayBn16zcc97tVL/NBs2MKZBX
 ykGaoVB0
 o60NZG6tEtFRXHnXcjTxflbWQLpN7wmoiTeB9T9l4IBiSIgaaSnSNPTIsemGVdjHE+zq0i6lXD2eUGs+TtCfzy23jHFh78QsWStZ49hGNf1T9J8lwzc1mcb5UgIxxw4QSTpeMPKR4sMTSPAiMACcjy/HNDfCvj/WsSo4KkpvQ12zA4OPgjkKg+hrs5lJ3u0LsW7dL2fwGZ8gV4aeyOHaZZWnayFeAALtpShuk8j2t9LjxqQrfXL2eif4zdhEzqdW9nRlBhPH7F3hUVM/v/ev01Hwp+hKpFDiRlbVS8nBc3TxutbycnoSTVEgcqDpubDoxnv1EBRKnymlUUoC5SFEBchpxHgoqAKekD8WqyGm6dILFeQYE1xBs/83sMYQIXXAlj0akv4Xt8ehX5p1UroQ/l5bnm8UFWLv5Sp9wrOcAVnCmOLr35EgGL9cE2fll5AuNiCuOzL1dT74ptQtWYhBz0ztXC+f8+2AT91hEgyje4iWJVGcMN/WUzPmpqVjzHTbnSUIC6gqvA57Xg3AEkir+uFS7yndBiTSKcooNYPuCJifMyxk+lGXHwWw8lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 15:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sat,  7 Nov 2026 21:49:43 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>
> > This patchset accelerates ioremap, vmalloc, and vmap when the memory is
> > physically fully or partially contiguous.
>
> Thanks.  This looks pretty mature and reviewed.  I'll add it to the
> pipeline for linux-next testing.
>
> Sashiko likes it.  I'm working on a different AI review setup which
> finds different things.  Very slowly.  I'll let you know if anything
> interesting pops out.
>
> Do we have sufficient ARM review?
>

Thanks for picking this up.

On ARM review: Dev reviewed the earlier revision in detail and
his suggestions are folded in. Leo Yan tested the large vmap() path
on TRBE/SPE. We'd welcome more ARM review from Ryan, Catalin
and others.

Wen

