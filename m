Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC725606B1FB
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kiFrZXPH
Received: by kanga.kvack.org (Postfix)
	id D24226B0609; Fri, 13 Nov 2026 03:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFC416B060B; Fri, 13 Nov 2026 03:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12936B060C; Fri, 13 Nov 2026 03:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0D5F6B0609
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:31:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94253120321
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:31:05 +0000 (UTC)
X-FDA: 85429425690.06.3E0BCAA
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4330100005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:31:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kiFrZXPH;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794558663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AE6LmlUfD0UD/MlCg2IXWoqx7xIo+3XrxhesZ8DM7Lo=;
	b=315uvlPJXbE02qp9UHuPfpGuweNeU4OAoTxudBpluoePjH3SJ2Znt/phWupM6SW3s1kwUN
	ZHJenBwy60TS6F8xxGrPfi+bZfmUMDGEcNyZsMezw+XgaBmIYnKx/yEvASHoJQW9z1MNaP
	nJEgs1QC7Mn+4NSUAFhAbE/MdZ4lgno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794558663;
	b=ryRSPm2pYtaqayJERopY0URYRF09lyFZcYPfQrpByMg+0skY/QoLx7pf6QJdwEGxHeuDml
	ACLL1z/rfHbCGEq/GzqhecQhM+Gaj5eLb3X9tN22uTXF7YQiRLOkMz85pGksQZGng5j4O3
	gXWcsk7gufktcvZX+BQt+KGuMVdv93U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kiFrZXPH;
	spf=pass (imf05.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a07078200fso264974b3a.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794558662; x=1795163462; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AE6LmlUfD0UD/MlCg2IXWoqx7xIo+3XrxhesZ8DM7Lo=;
        b=kiFrZXPHfXDI4bXs1UrXDtwVgvIGHSyXRvibKIwTLMwObrnjqlhPJxt0bfV77aEipT
         gpxT8Js0fQ+igtzsNtkVgVI1XVpkc0AhdUSfMNsbfmj9gVtFadNg0W7xsTcpq3nnjIAc
         QcB084tErcQxa5qo1qsESg5EynRIjFNtIOQWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794558662; x=1795163462;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AE6LmlUfD0UD/MlCg2IXWoqx7xIo+3XrxhesZ8DM7Lo=;
        b=ZSi7tJO4vowqmxyPqKZpw9M8Qq0ZECVVB2RsUR0nq/3QKtG9iX6r7/mTuJb/aL+JNm
         /jyAy0/UOE1iYOqAvowXtKs01OCwwbt12PXMcl7o7Xq6KxQfVeMCdwj8c1oJCuixlzzt
         UQbRniAVk5YZVNKb0Ap+pyXrJmV/beWx1+N5m4HOwuoPVpu577evCB7oIACbrlJf2RtA
         LAErTR4e336BNsU7eB2BE/vIjhiAu5fTFpqjk3aeZGiWlXvQVeYRvie/4DUZyr3Uajqi
         NYjrea2DUPPDVOFdZ7uG7I2EaZQVwfkrjREhGp6SoaVLG0rhjIS4XBF3jYbvvnIw6LC7
         naPw==
X-Forwarded-Encrypted: i=1; AL+hErE1DKzaw2fWaG7tHWhL2G0qP5B42zMZK6pdddCv/NI6E6aNs1jd6D3Abj9g7ybleWfdup4qVn9yzQ==@kvack.org
X-Gm-Message-State: APuU4Z/D2nAoG5+wAmb7goDa2i6NVqj0u910/TijGOeMaFEXtoLFFBkx
	b1dPnaAEhLN1wDXDgUHnNS/6iGdCrRk+8sB5td4x8R0M17ISGX5pEr7+/Vajzzr5EzQ=
X-Gm-Gg: AYBFou34+GzeykJQpR+Lp9sM3HWtolwARjSdd7QePnOGJWADmi+PQP+VH8oPdcItHd4
	RJd/JhFVrvDl7beBxOFhLvtdxFovhcVxvxdtTDwLnttCGp0OGSYKBFowEt+fDU1ykE8Tb2BbneB
	umLi/Yg7nsddHgQY7ABevCtMpsA7lKDTBNkJAx1iFgoixV/tgxuaV8ipeVjTm1SFT3m3zRfPqlB
	ReNiJWrBIcgWMb1hC0jKHsRtVRjIO8VNzg8W1rlwGaO8jR1xdwzoN5f2smjsm9anu9u3p+253Wk
	mXkHPV92mvwFcDJmPk3HbJTRgqaBbTm+SoQ6sdtIiokwZDMYekMLo67ry7hjCwcVCrVFosMRne3
	D8xIVavbbU6DejSAaMBNGmXz4ZIhHotEZ9aJ23e0N8lpPmJvQg8cLAe0L1jCffyPnPoIObObfw1
	LgPt6EhGL0ros8a/yonQvzoMsp16H33KxVScYc3aDDQGICrIyv8/l6w/f4RPJ9V3BOSv2jZ64se
	WNAJ3lst3LgVlTrRFP52Ya1buZjaMjpkno14k/Y17H6jg+v41OYmXuxJkiYEZfVudmu1ivp3UzL
	1q1R2ycLM1Vu+Ti7vn5LU3nbQAhuNXOCtkJrNyDqUVsexAl6AgxiI5FE0q8cUCv1awYpjK8bDrp
	FDZcxXIzu+xqsy2Osb7XkDUw3pEM9405kEKeyze3h/01hJ7iDDfieB/voH+9rvJ4CqRbTbBcP+/
	GF6JX28aoNT4cxZtsS7jgC9qNzVFPpdSf1pHvdi2whzW8sIiGhIH1DCBKhoVo=
X-Received: by 2002:a05:6a00:1a8d:b0:89e:a2cc:8263 with SMTP id d2e1a72fcca58-8beb21ce39emr2120292b3a.5.1794558662388;
        Fri, 13 Nov 2026 00:31:02 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bececcc9basm738703b3a.3.2026.11.13.00.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:31:01 -0800 (PST)
Date: Fri, 13 Nov 2026 00:30:59 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/9] kho: Make bootmem reservations visible to fleet monitoring
In-Reply-To: <179443886218.2329176.10742245280418377061.b4-review@b4>
References: <cover.1794383544.git.chris@chrisdown.name> <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name> <179443886218.2329176.10742245280418377061.b4-review@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113003059.056dd036a6546756@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 4zqboypjdzsebcfiztowurtwtner494s
X-Rspamd-Queue-Id: B4330100005
X-Rspam-User: 
X-HE-Tag: 1794558663-132955
X-HE-Meta: U2FsdGVkX19z2mH25gqLd3mao1XSxYU7FoH9fF6DUuiO7oB/nq6ZIjPm3r9/bGiYwOBT4zCyOCx47eMyyli2Pgu9CobNZGbSYoPWdIZ23BacsmRT6j5sPcT8jLwsgujJhWBAmEmH7MZXWI0oJ+dfQhCv1+vNnhOIG9DtG+IyyuzyjNB+XcL9IWdIYxYlcXUc3jlrKyLobSeIa9QQyQJDe2n2HDP1jX3svL4WQcqBSiUHvhDb9OAPJFNLD+dt+x0zqoM2b7Sa1RYWeh0TYp44mIB38p3c88QOmQxiKJeiou2o8pPPabipKvixu7ftvmQnaUj7b9T+CpjtLnXzUkJ+FjN2JOkVbF3OIYbA0dNufhCW45BqbztikoJUUK80RG9paLXwxxqGA++1xO/5JvTdJXjkkuaAVopY+wU0PUwcL2nhyMoVBrkxcsTglPGj2dyksyuAaEOnyLfnh8zWClyu8AsuxfNiJuztAKqyvWVcRKEEflpbhGZy4MAlXnD6NFduSGjKT/VPTA48Se8BfaBOcJmooaIsZ2kznixIuZalk9sz41cKXmQJQhtBE1wm7H5AQCJ4ZtOcj/zTgHEwAfvXWa4ceAFj7LJJ9sLztvT+D1ey6StvIcs3TR76MVIeQHugDppl4vHbPSW690k2JjS2ewDhxWx6GFGTqbbMUDyFcXKusmvqkssIBN+ZgyBSc9VTfiWkGffV8wydDM997M2QfHbSCYI5qX8IV6JgsDTz1ZNMeq4KbRCd1/Pf5ZQWkOAxljqKLxuZLC+78onEJqEF8QFBKyCbCGbGM/w0LK5XNgtDAQZxQSllhbpu1cQioMbh68AlEd1lwAgzH/V6ei7hZDKz+yeuPucUGvoFVHawVDFFIggumV2djCOIz07KxuRKR98LBaJf6fLEqJZJ823fShhnDjwIVMIqeYSQt/NxSAkQ5BQfTsDkgXZwPZjqmzqIDOXjj2jeY5Nl8gNqRHu
 gZU5LoHB
 Ss+xm24vJYJ7f96idGIs7wZcy7woIo0Kd3nyaC4u4PjusExz/glecmOxWpwqVZYePGzJpwoJr3tofHi3RA0+OzCJ+VzhvDHG53EGSQAz3rqmFDsBmmSoBJYHm3P8W51aaAozt/nMP9Ge1+oDVzr0WTQGU8hxAh3XoQkD3AkRaalzdQ+weS2K+3PLcCzhtsCI33nJ+7AsqmYlmbBU9q+u6hwEpwYiqbDXkv45ZRcA9tbU22aJRXbtzozcVpz8OzJMp3bWrHqJrR3CnIi7nTCJpGn4OvIASv7P25b9UmE5Q0RqpMCax6d+gRgJhSON3pScYLQyTwdtjyYCPs1WcusD/u/fWeOFer3ip8mHCf3CL7+yMUULVW5PN6JKfxR5vYaTQfkj/JTfNWs62qnF5857VgxSDTiYOOEAMOVGs/znlKhwysm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Pasha,

Pasha Tatashin writes:
>> The reservation varies with the kernel, memory size, NUMA layout and
>> command line. Our fleet collector needs the actual size from each host
>> so we can decide where to enable KHO and catch a kernel release that
>> takes those hosts over their bootmem budget.
>
>HM, that works for cold boot not for live update :-)

Yeah, that's true :-) A kernel we live update into just inherits the areas, so
we'd only see a release change the size once hosts cold boot into it. I'll say
that in the changelog in v2.

>> Today the collector would have to sum kho/out/bootmem_len in debugfs,
>> which isn't a userspace ABI. In /proc/meminfo, free bootmem contributes
>> to CmaFree, but the reservation doesn't contribute to CmaTotal. The cma
>
>Is this a different bug?

I think so, yes. Bootmem pageblocks are MIGRATE_CMA, so their free pages are
counted in NR_FREE_CMA_PAGES, but totalcma_pages only counts the areas that
mm/cma.c knows about.

zone->cma_pages is a separate problem. It only gets bootmem added by
init_cma_reserved_pageblock() in kho_init(), and on a KHO boot we return before
we get there.

I can send patches for those separately if you agree that bootmem should be
counted in both. It wouldn't give us the bootmem size though, because CmaTotal
would still include any other CMA areas.

>I have some concerns about exposing this as a stable API. What if we get
>rid of bootmem or make it resizable? We only recently renamed it from
>scratch to bootmem, and we have been exploring for way to optimize it.
>
>I would keep this exposed under /sys/kernel/debug/kho/bootmem_size for
>now, and not worry about it being stable.

That's fair. I'll move it to /sys/kernel/debug/kho/bootmem_size in v2, and we
can look at sysfs again once bootmem has settled down.

>Keeping it together with the rest of KHO code would be better.

Will do, it'll go in kexec_handover_debugfs.c next to the other bootmem files.

The kho_incoming files in 6/9 are already in kexec_handover.c, but kexec_core.c
still adds the group to /sys/kernel/kexec. Is that ok, or would you rather KHO
set that up itself as well?

Thanks!

Chris

