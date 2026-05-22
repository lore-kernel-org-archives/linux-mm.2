Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28758CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915A96B00B9; Fri, 22 May 2026 12:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E71A6B00BF; Fri, 22 May 2026 12:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823D16B00C2; Fri, 22 May 2026 12:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6FFE66B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:24:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BCCE1207B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:41 +0000 (UTC)
X-FDA: 84795579162.21.7C62B56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6218F18000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIebCu8w;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779467079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	b=pI722zWGR6CKV8sjNTW1otsVBPyYn31Ka7Ih3Ggwwkp6MgOY8kWAEJkimS5F0PiQLh3jbj
	5sG419xQMOncKfkTOhC0y5Q9WyAFG174bvrHg9ADoIm8jWdirRrQwEwDXCgl6W6JZ/2L0e
	dLkmn9ElU3Rs+3sXVNFjeKTFTa1zVeA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XIebCu8w;
	spf=pass (imf06.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779467079; a=rsa-sha256;
	cv=none;
	b=tfUs5Rmhxf4+JRVNiZvcOsulCMP9fRGX0sopyn4e8BIenFiV4HqgaQkHVym9W6ZH1vO4IR
	GUWKnn3MZMPbcnRjdqTAIYR3OKdFJzik656Rph7fSdG+AEk42CoWELkUQM7fAsgbEkRn5l
	bkD3y8yLhU59OKdbXvnxd8sXFfWgxx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DAC7460138;
	Fri, 22 May 2026 16:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CD81F000E9;
	Fri, 22 May 2026 16:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779467078;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XIebCu8w/5EIsnTAkusMssIT/oJ++zXZHLC1bxea4xQ8RIVifoo61GRKbJnWBCT11
	 px8/BWJ1FsE6P8UM0bHpDrBhDalyvGrHouJBfM0NCg7hDMzjwSUfPPT9zA2+3EdUaA
	 6W8O3aSeK+6T2YmpeLi6rdxg1Kc4iOCZm+ZiZEvu4sQruxZ9wZQOccShdL+d4mVRaA
	 pVnBCTP6bm54v77PyYTnxkhFgNFA8R9pAizBvIj1HroEMZj52iF9qj1hs62LL9/Dih
	 C5+J7RB9P5cPL2SgUWFq3MnK5PFOKbQnxQhuCkIZevGpwBVrtK0cDtVC5Pum/iKjRX
	 YjpkbyS2oy+qQ==
Date: Fri, 22 May 2026 06:24:37 -1000
Message-ID: <1644404988c5e2d333a9d09399533dcd@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	=?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: enable memory controller in hugetlb memcg test
In-Reply-To: <20260520093130.490020-1-zhangguopeng@kylinos.cn>
References: <20260520093130.490020-1-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6218F18000A
X-Stat-Signature: jgi837mubt9ihyqmpzh7zrmmrjjeejpt
X-HE-Tag: 1779467079-732734
X-HE-Meta: U2FsdGVkX1+XPR6+P/OkN3+OeJkJW2QCcpEKdlXH43yVm0TwqcAqSBIEIbzwJeTc0x6pUuQddiEygyP/2FieDRMEclYhwaNn2g3auo+0BxbmU+qxX1WTGP8r1j6t4u5hdUxAC437vYzfRt7lBMW9eJEcxkUt6WdO2BoFBr8cOaP23ICm6HvBC2dRkVy5ODRmB1goh0DFVBDkGgFIm5XMQVqlNbeaVfKv5IKJ9/yPwLsP9u9Iualr+qdm/4NLylVdddsnlPM6AWXH2U1A4HjO//DJmmblHEDyGTqYzmQiV+jsS4EodUbGPKAsXcp6LvVJ0Y4XHCU8Vx02SBLHKjnGE2dN1GLC5dns+Hk7+6+V2ZHp16bTA0kysad7Z0Ws8jjnqen83hbtmn6ryDPrefhQvCK82FLsPnSq0JegH+NcVNbBPExMfbCeO9vsLAkv4jRmejjA4c0TV0FTGl970gJOprRiSs86zAHlzvM8dHTaZX+yHa6PfRdhTNiHUbDy3E5eoe/85tq/EO7TVwDtMYWgI3bOQqiCmC7l5sQosBIjSzGSC+uEkSU+30BWu+CRuh5zx2LqU2vjPRgHCjMvFli2Iyy8EpVU0hj7UukpBb47b72ZGZs6LRJdozGb++lxgmxAhCwfKgHgHoBMzRRZC44p2IFbOA/TSxcu96rKrdIIMS1NXgQAPi+87VtGq5VQuwk5HDkSSeUeV+r7ALIEfhsXA1kt66Fo+CJB1ejba8cjYeF2vi8vXygZ4xNjzH5huTwdO5KbgmaBCQZDLEZB0ckaAaY9DWy+OGaB3Vp35TuOCNNuU8YDbgS01bKYYwFe+nEBPySZqVJn5lJ80kG7NA1yKOmM0Vet8tbcOVnnaK80njd7Nb25ZKKCqA3RTk750HxEAm3l03wCe30hMhrA8T0XQfSLLbQVv230n/Gsme6J/mJKh81i/w6o8YXdeK9ZVoQjfu7/QAWn4CacdU8aKPH
 aKW2i+zU
 x9ppVeULnPqqV8+ZftkPn72uvHyLqOtgWQQMWrtNBDJiOxCrldrp7vx/ZBeyglZwzhg8t74c0LK827Vrlr9N8Jx+k9U+Hjen0yKJ56dcBQoGdT8K/ICObYHk1fwdmEDfzDPzbl7hmNQsjiB63jHCsyYPOM6Ibdrys0HdSnqISdrEscvwOsymWpHhcpte2Bp8k65FXahAuLSZ5v/e1uKqT2dmT2CyNhAh7EHLkmIzy/Z5zGVcwxH0EVW3qCi3B9TJEpRy3RGuKbfalIn7eLO0XHcF4MU/F5gzV2JyCyZB+1HOBY/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Applied to cgroup/for-7.2.

Thanks.

--
tejun

