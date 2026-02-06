Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3A2EE20A0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5106B0005; Fri,  6 Feb 2026 08:08:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FC96B0088; Fri,  6 Feb 2026 08:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73A46B0093; Fri,  6 Feb 2026 08:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5DE46B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:08:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0374456593
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:08:52 +0000 (UTC)
X-FDA: 84414061746.01.D43B343
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 315A41C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:08:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9sEWGFi;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770383331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVhzraKz/eb4hRtZ/6XrRCjI9AzeGgsZG0Fb0OBcWOc=;
	b=nb+AeULoD2ERt8ePoAow8K+YGwFbl1jgrbJ0R/Io0FaadQXRjDvAfDDYKd863jDvsxbSZf
	4veIzFa7+e5LGX+XlhnLX7kpUvz3HOqb8zrSWOB2eI8xDlzGVTXG/aI+UAUlK1leUn/yyM
	Q4Ouob9CgXDjztGS+WFiE73vth05wuQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d9sEWGFi;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770383331; a=rsa-sha256;
	cv=none;
	b=os1DqqDob9s3eQzf7kv1oBc6xjSyDA1UsKJZD2sih2akJN+hlSU+RMjhv9AvxccWm1ts39
	SgyKD+HrsZUvAtbyvzGE7ByvnvtIskL7d89ZE66GRRO7kAXwAiK5sMwbRBSBkmFlYiOQbb
	jq7qgrF6LXVvbEixC/qR6cGaTzUgvCM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E0060010;
	Fri,  6 Feb 2026 13:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF11C19422;
	Fri,  6 Feb 2026 13:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770383330;
	bh=yQatAuidA98Ax17IPcwzDzo7BEX1JG3THZB2KlSl+JI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d9sEWGFiaaRuc0sRdnQAcuG1352EjsHTlcUcZGWkuztARjNwJJPyYsFnT49xnGmu0
	 7RHw4Tkuma5AimwbVkiWgqlHShrqnXx8/G7FadMgRziOJSchgxeIt/+2oZYCYuX154
	 ysHzufYNUs+vgv+HRh/pQNvSxxpX86RNqQAgoFFvpfc02+PO91cogUGWhLTSINmPPx
	 x9eXbp0TD4j1ScpA2ICUEfIuZEK+I+4IBrX2hp0brX9ZJEDv0Zav3wHtmIBWiLjrnY
	 yV9VKuehMQ8VweK5VFvGLG5DUYp82+uy11I81WooluYehQahb5lQAYEC1YKZf9zTQw
	 vDF+s8HaV4ZJQ==
Message-ID: <ef673543-b03b-47b3-bd40-2540a56b6333@kernel.org>
Date: Fri, 6 Feb 2026 14:08:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/13] Remove device private pages from physical
 address space
To: Jordan Niethe <jniethe@nvidia.com>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 315A41C0006
X-Stat-Signature: zcj8hin4ntori9jmaracqamstt899em8
X-Rspam-User: 
X-HE-Tag: 1770383331-37504
X-HE-Meta: U2FsdGVkX1/9fClxYb2Mi7gEkBivFP7NdXSwLMYBnqifryLqD53VCAAvBGnbp8f1qPLudOhFwDoPn76sTtAbc2ela/HciP49JQsDt2vxv5jGKNJUfw4JCbl+7O89m0V/p0BrABTkiVZJ2Rqke8mW7O87jiQV/JsR99ui9K+dhZrx9MSXatJD5CY1DLtq3dG7WLqR3qJk2jupA55Bq52aYQ2R5OlqG0jpLXsC8bj3SAY2siRL68o8JFzMXABtaKP5/LZT7FKUMXBQtM7ttO9XqUFY8Zfn3d7Jujx45z8aHehpD+CAKvV2qBLrM5kEV5LaUxF2rPAyJB0PqS4tgjgGfM1+/nH/ZW2NV0kK3TPgH8y9HB/GyIREVfYaOA+4+dcqhGQKJosTZJLlVp5WQwWpQWHHgcOUHzXDtviwIYNp1KSQLWKbwUhOs+E1oRWNnNFCntdx8IBpjEcIzh/zhsuqW5Wg7ISN0405I4TH2kdl0LRAeRsZMNpHzu1Zg1gJ/Za3qXIUKytjScmW9iRMJQ3gLywJLzu9gflwJg+3qRSGxZqR6ch15JVW85P8JXhpHbN0U/jPtGFpLZY8C0iDLDQuITMiAKtRNm0SfKrXklmQkn6x27HaqiiXjMovZvjhFO1COPgDZMjvwzNdlE/I24/GpQURWka9u0tGWALxw2iDVp0+bH9cbJqgeUTBvjraBJCmusBAyR+OYxsOtkAWUWwb4hZg+0nlRMOqWHgvorJ47+cL2NChD1RqFh2tVmpZuap8iRi1MKY2lEq3vU6iveDhVp6VDK/gEaet/KhK2RoIg8zt2LMRDm1ie5B2ffHFDv8cosWaa2uA7kBt976uonW0g4cZ5hWfOmyIgr0lpNZSF4P3muHy4lQlFV6owW7qeAeMsdUe2pWdTdOUSqnq+YKb+ByIVhM9MPFjBFizKm1fyuEEnYMx2EOTfwS7L6fr0Ye1OKyfYPn6PkHVEoupCC5
 3tgaI+AZ
 FKi2uCFSY5f88roeF9HpH4UnqJU2vIvO3csRYfpXB09GUvjelO0j3vsoSRSOBaZVNPBdUcNrCkW6R/FN68Kn6mBO0vbOQbpUL9JeymTQ5tRyZllfYgarD+JTRNdgTa6ucl25MubOAMna26ovjMV2ribsRm87FDNbwnwLGlHHDilw2iqocy8JqDuhzvmHwdTtf4r4Vi2NOtUo0kXv3Rt+R5pkY8BuJddaMaEf7pvvQWfOL+B2KFakW0wf9kjeh54aPo7E4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> By removing the device private pages from the physical address space,
> this series also opens up the possibility to moving away from tracking
> device private memory using struct pages in the future. This is
> desirable as on systems with large amounts of memory these device
> private struct pages use a signifiant amount of memory and take a
> significant amount of time to initialize.
> 
> Changes in v6
> -------------
> - Fix maybe unused in kgd2kfd_init_zone_device()
> - Replace division by PAGE_SIZE with DIV_ROUND_UP() when setting
> nr_pages. This mirrors the align up that previously happened in
> get_free_mem_region()
> 
> Note removed previous discussion in the cover letter relating to aarch64
> and memremap_pages() as this was actually already addressed in commit
> eeb8fdfcf090 ("arm64: Expose the end of the linear map in PHYSMEM_END").
> 

Now that I stumbled over v6, same comment; planning on taking a look soon.

-- 
Cheers,

David

