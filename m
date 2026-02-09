Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31AB6EE20BD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 08:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A706B0005; Mon,  9 Feb 2026 03:11:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508186B0088; Mon,  9 Feb 2026 03:11:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414686B0089; Mon,  9 Feb 2026 03:11:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 307AD6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:11:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 007EFD6338
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:11:52 +0000 (UTC)
X-FDA: 84424199706.14.A2ACB95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 280A180005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 08:11:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hn+UPDqt;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770624711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50l0l7arSP8Mc1SuJ0FPEfrM/K2HGzCxq+UPQbzFobs=;
	b=Cnrta3gwG4A9N2pNRds+tJeNFXkVgGFhu3l8oowOO7a5/RAg4DRtzjp4SGpUcPY0NbhQJi
	q4Mt59PdN0TL1hP9Ug4k8fRh9Q5VDvUTRL2Xd5R1eG0QCwLpiTUaS0V73vbiAwimSG+Lgl
	ByPfQNnTKZoT75pHuwvyMe79c/BayCI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hn+UPDqt;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770624711; a=rsa-sha256;
	cv=none;
	b=ImjEPelw6TI+lhyndYWVFE0fWia3Jv/TAc8j0kY5NSvm4fo+s9KpWECCr1CjrRHU/DVpLh
	YsCLjOJa0ue97Sus2KTYuHeILkZFmiAEPPY/dOOuOOJ9Bwlh23P/Y/IStDSiDjzYD2q+v9
	3jFVgU2CR96slHijdACatCvLph6xdRg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 192D7443CB;
	Mon,  9 Feb 2026 08:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A64C116C6;
	Mon,  9 Feb 2026 08:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770624710;
	bh=L8oWFHABpYlRLKDFyyvLn/HsEWp3abYK8JEFHOpAh/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hn+UPDqteqgyuGfdYJqtzLugJgNnz3dFTl2+L91tmqGVsEiIXGb5BXZ7HBHY5kFVV
	 dJ+VvRlzEIi5JCC+FDp//whR6ivA9eqo7YbE4pFUeNTEKYmLM8KED1iXULCr68h2VD
	 QOYyPrGu5PwBC3EO18Rx0b5Xe6enc9thv+Tk+3UnWB2r+AAg61FxyI/RwSxxrcUI+m
	 TYON0Jlmnmoz58PifxllXgf4AjE/a8og863ddQiYNP2XESaqkOL6UyZh3YSrRZCZSm
	 sYwbXwxRcFbR0uok4BuxbFPstcDrvX2q9ksdDNlfr2e+vmS7PkzmLh+P+1ZnmYRD+z
	 HE3mzLwMw4xUw==
Message-ID: <4fc5e312-b56a-4664-9722-81163ecef515@kernel.org>
Date: Mon, 9 Feb 2026 09:11:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: cma: Fix stub for cma_skip_dt_default_reserved_mem()
To: Mark Brown <broonie@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rob Herring (Arm)" <robh@kernel.org>,
 Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 49cdryye5ta9h71dn7wgxgtjjfa99e1z
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 280A180005
X-HE-Tag: 1770624710-617703
X-HE-Meta: U2FsdGVkX18PU5o3HTzpT/ROY/pUBGOao+LV8omTQTQfbx8jT3Ny2irCwQQFxV8nsSzidImyD2jOj00fW2P3OJ6OyCNNe1NVQ6VdPdqI6qLNwZ9fSrm36YfMN/hRXNug3GAANxp2lq6HdZlBBtCImixLT0cwN3Gg9Ug3PQb/Kfm4+xsG33ojjHXrIhxmxM9JYyQrxyf4BCTVL7rq8oxL6IJ/aYccHretBnzPBcun82gT47yenxgaijpvvhLxclKMU1rKViRuVoHAkMMQkV057+gjOBRvnWqa82QRMtpY7KNVpD7oLjuUJnF4tNKIytWhrHLwcOqrqMx806TJmLk0h6kaJHxup2rQ3bKiPfAumUg6+P5WYX0ef67FzFhN7DZZqdmyH+ovGDjnhkYxknFOrCPCk6ICO5YufgjJCQ5sICe9qyhL/Z7dAWTWeG4oa5okQxI4VGenPyCKqo5UCqqeuEqHi15PVRgOQkyiF5wkcjvqAjuaxi52iNxHCFh6Rn0d8ihbKycexlYPJMiUxuLvRkTYp7PnA//+07VqBytY9lINS7yLRVj8OqPQiwILV0OD8OO7tNYmPuTG6U46LUvlyMAvkWkoRiZ+5T+izTplwRZ2IylCmnsqRbo28RtRRoZX2/B9FbwMZrEqdJgdpPNQVYmcX/5GTOKceW8yb5PwNMyrkhR8h7wFbU8ghps3q3coKVJIsANSicApfLYNkz2+949iW6HAgcUpLsKmUBkT60MxxXeC13xXWep3ziNvrv/ivC5Q1XsS+MnBmw50sY9aG6xO1MlbSJvg4iejijuFmejvuw5VTGEx3shVA3FS0+TATIHajxjabF/J0hTf15cOCVzZnmf+unCflQOzKjDoQk4B9OdNG+BfeJVUfKWorrVqNEOjlxJZNQxQPOAqVs7BkWWuKnP0oBvidtiq5u0Pbvfg94zHIcDmnZuCxNg4QC2LG14vIttdRQUkGOU3zoA
 unoYrxf4
 p7RGf+cs1KagpcKYM4H7tTK3cucPqVwyWe1XPBOSM8974sf5wI5NX6Leyf1ABMBSn0hJB+w7rGG1kkTgAhrWZFjZXh/OkLrJryuGgWt/l8Giojow5tdmdILRc8GYlzfMBFL1G0UkCVCAH1jATM6rFTvj7l9WKM/rsPd4UNVdHjtg2jtQ/8xu8jMALMV9XKNdFSGoehXAO7uNF2tEcGNZqaecbKrKFYIWdsieAve6mGL7Z+MfLtQcmFyzQPufsrHjjEbZB5OP8dv7dtPTgXx/1UEyDxPFQ61xDd+PwFn8q1e5kTUla+SBT1CISeO6AvrWrYKorh2zHskr+6mA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 17:28, Mark Brown wrote:
> The stub for cma_skip_dt_default_reserved_mem() is not inlined so
> triggers build warnings:
> 
> In file included from /tmp/next/build/fs/proc/meminfo.c:18:
> /tmp/next/build/include/linux/cma.h:68:13: warning: 'cma_skip_dt_default_reserved_mem' defined but not used [-Wunused-function]
>     68 | static bool cma_skip_dt_default_reserved_mem(void)
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> which are fatal with -Werror.
> 
> Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
> Signed-off-by: Mark Brown <broonie@kernel.org>

$ git show 26332ae848f08
fatal: ambiguous argument '26332ae848f08': unknown revision or path not 
in the working tree.

This is not upstream or against an mm tree. Against which tree is it?

-- 
Cheers,

David

