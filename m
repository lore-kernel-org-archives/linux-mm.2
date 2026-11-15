Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B53606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=b+M7nknD
Received: by kanga.kvack.org (Postfix)
	id 86EAF6B05B0; Sun, 15 Nov 2026 01:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7C16B05B1; Sun, 15 Nov 2026 01:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E3F6B05B2; Sun, 15 Nov 2026 01:05:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CADE6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:05:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A70B9A03EC
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:05:36 +0000 (UTC)
X-FDA: 85436316672.01.D75F518
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id C0F2020004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:05:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=b+M7nknD;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794722734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMjYG3/Fyza/CbXoIQUPnk8H85cPMajtM8cpJ9BN7sY=;
	b=hIaNHu8RlDI3kmK3U+zPresWhYbpfg3vDD0wELAsTgWP3o4ssGN+SzoBbvKp81v8YPhjVZ
	kOi+hOmsfw13QCrMgbi58qrNNAZyUFEJvx/dmb1spXrtQpbyhgHpqJIqk2LKiO9Eusvahy
	wIVeSYVDX4efeZHtawk75caRQViAJC4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794722734;
	b=rswu6bfDMBQWaRsPnpIjXLRWsvzp0A8Q0Xbw+Y+HWSjWptzO7GGrlMqFhNROLyvSIzwXFA
	YyYehT0YJF6JiF/4tfotQM8jfUlBJlnYeL+gTg1KksX4vvbUII68doyUIJDU6IXF0B4Vpz
	DnQjmmNRAet60Nx1RBXTKCO/Pxz861Q=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=b+M7nknD;
	spf=pass (imf31.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.171 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37d424f1ae8so783772eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794722733; x=1795327533; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oMjYG3/Fyza/CbXoIQUPnk8H85cPMajtM8cpJ9BN7sY=;
        b=b+M7nknDi3CNfn04Cg60DdlgKlRiH3wECAc+SJWyyKbrdT+fjQk9O41ftge2wDdzi+
         ls6/v7FyKddYWXNc3/3/vieVPgeLp70xUnBzHpsUBTUzrFizX3OgANDlwZG+mIo0Zxtg
         K9fbZH3dPwZ3l/2Bm3N8lbYqPvipFqSsu2ldM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794722733; x=1795327533;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oMjYG3/Fyza/CbXoIQUPnk8H85cPMajtM8cpJ9BN7sY=;
        b=eGu31sEwAKPHRFcqzMEshJ0zbPOB5E3Nrur69lqB/W1QhzDNRZ9LXqhhlTAi/BSYfG
         bfzoLjQvaZi5a5dT+W+McifHjCebe3O9BJQjXNC9F5FJK9RiVCGU5nuowPAflwk/Dvou
         eP3ARsIzLVHfG395XiqDtPnuB+/oBugc77Cj4CHdyP9rQt+U47AEc8x0KyM/unFZDexn
         UCahTdd7I4cyLTRud0Qd4jenZjPcdJv/rVS+5wtlPhivwBO8qiYN/F3eJVIUtIzQOyuj
         5X0IJOOuZkX/f750LG4b1XD8LCA8JG4l6VrrHDEjddU7yTDwx56DUgojbZWj+FhkBYbg
         UM5A==
X-Forwarded-Encrypted: i=1; AL+hErE3WP/SMkwQi45d+bKjlL+iYtmYwKLuPxuXR7ZHSbzAhQv54Ld4VkIdJBhcqIUjVyN0/JAud/D0/A==@kvack.org
X-Gm-Message-State: APuU4Z+VIFy67v/tbBQ4B/Ij52s6+oGe8d6eixEf/XFbaWTyOZM2jY7F
	qt4/YyP+PnJlyM3b+PHp+DowCOlnISIc//dNbv5Zfl+GoL9cGEkJdUq5wUjWfnhezk8=
X-Gm-Gg: AYBFou27IX0fgToeJ1nDDUZYmfy9HK+9SgzazA4HGWsG6BiBXvEqQlQibqPJ7vsQ5vp
	8X86BhCh9QXvpS1+9GjZpuTbyBIV/pg3QTLzwtf5QylrlPJkVWXMcxTyDcrxURTu2xJmG0Mto4e
	QwfqtMZUX1U2c9xRiKNt0riNDKaPBv8L3XvKP/oJERSIABQObEUtRAh1tqwCSgDE7Z0L2Nmlw9O
	PV4wjoTZH0IBeiG0LHkAv8lwkG4Gtp7AIxYu2BiVPFVKTEYttgSFcj404zzCTh5nTJGrb+O/sPi
	ow8aUn3MRgRlGUm8s77Zw2TGj1EgGNkjni0eeM2Rt6ywuxJ3MndsMVmEZM3nITTmRhYa8hgqB5B
	QW/5fL3p31PQdG/zQUzLB9nAklH/7dHaMOf/KR0TRcdUmhSPahi7/ff80aHP9hZhmgHgzlASIar
	paRNhK+0AnX3+g1R7wWO9GrbbylksYoQo3j4bCOCiV7WVZTIf+NAoCysBpyHnfSMTy/YbA3GElt
	QxDpJ1D/5ALbePizL2gJx1eqI/lQmzLjZytz3ws+LtjVXZb3NiMEbXQe1uxs0L0Zyv+bXA50G44
	xKHDq8Dc2QQpIp8Of6yaciY0x12f8q+3Deh9ciV+GYGuO2MUp/kAAIC0I/6mdZmS6+khTisckAM
	DqxI0BAU1hDiQC+iUoIw5gueL4+IToOhNCoOU7Ix9TgG46wNk3bYrQQbyfXf5cRKHjQIfZ334zD
	A3/nFXECL2Fpn9h8/y+yBLVQW/7B1LNm9371N4UJc1rZ+JV6KCEYpaawVPdCdJE8vW
X-Received: by 2002:a05:7300:7481:b0:375:c5e1:931d with SMTP id 5a478bee46e88-37966e3aff8mr9995533eec.25.1794722733483;
        Sat, 14 Nov 2026 22:05:33 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563e6b6dsm39445329eec.21.2026.11.14.22.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 22:05:32 -0800 (PST)
Date: Sat, 14 Nov 2026 22:05:28 -0800
From: Chris Down <chris@chrisdown.name>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] mm/memfd_luo: keep memfd frozen until finish
In-Reply-To: <20261110175855.2437084-3-pratyush@kernel.org>
References: <20261110175855.2437084-1-pratyush@kernel.org>
	<20261110175855.2437084-3-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114220528.f7d9874a014dbb5d@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9mfuabez4kpw6ecg6pwuyqt81gnkuxzn
X-Rspamd-Queue-Id: C0F2020004
X-Rspam-User: 
X-HE-Tag: 1794722734-794665
X-HE-Meta: U2FsdGVkX18714QM84jirsSNpijYf/j6yxotng6TO9fwEnJCV0C7A9yWE83pWa3XSNMBLW4KnGAZ7WLGyLf3ke4b+Dh9RF+k+i/meh9/ziEzozb0YBzoAYmJDCe7tp6MkHXEDgGfGwFtz7wqmT3/8AyfnrD2LzBv3Qy2ZYLTGA1AjEMZNpvQHvvZXLubShlwzq1bQekogCtRcTBdLA7NxhEBucQXXwPjkRWBQA0FjfxYIPORv9wCH6oWKXxS3rRdPK7Apej3P8KxBCTBqXZH5tjxF56b4D6UOmMw+rWL3rUkWZ4JWu29yxGtxdsw5tTimeWqMfB3OWQ4QXTlLtGJ8EHWelaTYS4mSdFpsEaG2bHp0NrM71n1gkMBzuexy1g2DJk0hBciCKb46OY6+W/FrFOzT+9KPIPws4Y7uy7gMQfsPoCFVa1v1IIbDU/bLxB/WyiVJ7NGLSrMoUKCQ/4wbiEfCvQ3TPWPfjFlc/647Bi/tX/BFMMpUc6M9fpBOkrTy1BO7WLzh9JQmqZOHjrC4MkarNFA0AMBRMV1ufUyMzSQKtAsjTvD37+Eb9Tuh+ugtoiNi8qOjLXWWQqdHj2eRwlkl5tKICi/DDXcAfjvsevxjaz/EsyxxsatfuoSQNj1yIeVIYn3fS/lLVnwDuEHSas6ovjlDG9ygL3nWeNhVESgGUwv0H4V2+RN/opVvdFa/CcaxWXu8BrBAqiLpt05lb/LCrLUOSL2iQtDi8BhHnQORqxCXAegN1N5WdT3dN/6Rn5LBpiXx5X64dc7Wd4yiHSZmX1aI13kUYEWNBuXvMEjc/lL9rkDIzGKvxt8GMB+Q59gT2mt9tREqqbezSbkOnTraDEl0V46hYmur183xOpl6sUoPaIgwQpSSiSTBSKW0pJRCYGJx0q167BSBSt7CQCF+ethphr84blpLM/J1IXPsg0VF0xbJ/58SQQ6ufJVESaKfRUPiECdk8MbFGa
 AQTx5hN0
 XVozXVeTjvUWnNbeuDWOHM71AwbBgJp/zGzQh+4MnqTpuc/uGv0PNr0d6KppcinGXG47brjwo7+mQoN2Szz4VqhS7ktvmS+GWdKVUx9SrdjqT+LerVJUzi+7bROAA5P8dc8qNeKR6/oFyqewd7NrpEERl+Xncwf0PdJEx1lPHr8rEF+JrUGTmFyvpOdMZJ4YxImpCwa/+Fkog6jDo2aJXnJpq+eMWQi7NuKgRl14LpoEb50mzlC+b4ZbolkUbu0sVsebUCQLkf1iBWAYxC2NKiNhiFLBoIqkp0PZuGeOJihRJEqfDNKb2+lkNiqPQCMNKeK3VIQOCrr1gOg81C/vPwN+e0GsqZqysbgLyb4cOpR7vIzQy/1gaqirn6QqLNhOOmp2NOAsv/LRl3vmQz0KHE44CkcCGLxR02bZ5f0k/oo7nyxnKtkcgCNCNh+5WJUBUVz46O6GsqPEIZBVJLkle5Egj8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pratyush,

Pratyush Yadav writes:
>+ * Restrictions
>+ * ============
>+ *
>+ * While a memfd is preserved, and after it is retrieved until the session is
>+ * finished, its size can't be changed and holes can't be punched in it.
>+ * Operations that would do so (``ftruncate()``, ``fallocate()``, writes past
>+ * the end of the file) fail.

Not a big deal, but there's one more thing that fails in this window and
isn't listed here. Adding F_SEAL_WRITE to a retrieved memfd before finish
now waits about 150ms and then fails with EBUSY. That's because
memfd_wait_for_pins() sees the reference kept from kho_restore_folio() as
an extra reference on every folio. Once the session is finished it
succeeds straight away. The same already happens while the memfd is
preserved in the old kernel, so maybe it's worth mentioning here for both?

Also, fallocate() fails with EPERM in every mode while the file is frozen.
That includes FALLOC_FL_KEEP_SIZE inside i_size, which neither changes the
size nor punches a hole. "Operations that would do so" makes it sound like
only some fallocate() calls fail.

Otherwise I've tested this across a kexec and it works well.

Once those are fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

