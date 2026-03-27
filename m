Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9B310ED661
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B301E6B0095; Fri, 27 Mar 2026 09:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07F46B0096; Fri, 27 Mar 2026 09:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D926B0098; Fri, 27 Mar 2026 09:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 910446B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:37:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54650C67F7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:37:40 +0000 (UTC)
X-FDA: 84591945480.27.6E6117D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 842001C000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:37:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpsGr8Rm;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774618658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+790CMkcmRn+gxMs8OCoomzv6p6yeioRLt6uYunqFrU=;
	b=TiVlFwg6rbp+5d7erpwdRAruNcxK6Y79VrDA+S7qZXb1+vWF6o+HAVqfDIyv4rw7/f2R2X
	7RDTu1GYiPz3TjuZPQ4hNnqkW3In/1dEghlZgXQneNimCusjKtYlKSMf+lQKF2Ue92nkSX
	i63gTV4u94iyNMMtATbaYZLPvLM/R60=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774618658; a=rsa-sha256;
	cv=none;
	b=kaaD9AL4fULe86Bmg0gfLkQhc5jKNeuvr371aYEjcsIFgwQxfvNUXeffE71hlFDtFfWe8x
	mml2Rqh3flRBe5y/aMamIWK/xnMYiaWo5lM+xkVUWOsiQFrmAizAUUsy567rhBPq5sgwS5
	BBC8tq1Ljf/yemUeblDm3Srue20JzOk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LpsGr8Rm;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ABD7409ED;
	Fri, 27 Mar 2026 13:37:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AA6C19423;
	Fri, 27 Mar 2026 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774618657;
	bh=nZns1tAP9si4d7z5PzQHn2p8PDrBrvalmvMnDNZuEQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LpsGr8RmLF6EmeJkmn6EEFSZppz6AOLtBhVPzdaFRqbtb1LcOLvbNQOJ30/7s8erM
	 rCNOEoeK4t0Wd2ACinrcnEQNRAppR5h8dWf9SkyVhckzmochrZCDtP7QvtQSIzFbfl
	 y0R9ZeUTLMo1m1Zxwe3YPfvcs18ghsEvP27p7BQYMCZm/5Do0wa22+lwutV7UZRaRi
	 6+/WlzwmWbPKLZnV3BZScEKlzqC1gmAOWogEFPe3YO5kfPhZ2qmkAECU0srIt1Xxeu
	 mxghOQBYsbEPCIesgEiC3JCpZ5h13Ct7eyHEiDwyeQ4fhZxpMqmbNCshkDmy8TKajp
	 H5cfBXUKipYmg==
Message-ID: <f3602a65-69f1-4d80-82f9-c0c5b56afe00@kernel.org>
Date: Fri, 27 Mar 2026 14:37:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: h8c71dpwfu1o7dq7f9ne48tqnnfa45w1
X-Rspamd-Queue-Id: 842001C000A
X-Rspam-User: 
X-HE-Tag: 1774618658-384372
X-HE-Meta: U2FsdGVkX1+hc1LNeFBu003YHOKZyjB0V5jzuWELCujbkVg6Wr6WPMvqiFb4f4fYu9hlfpx1FMi47HDRn2epZCDtPJFnmAelDuBGnsNYCI4DVoUYR93Crsx2yMZADnvyw934UXsF4QmaoAWOC+EXEaO4eqW3LOfHYHH34kZ57G5/fyhjVDbiKWExbAqQSFPlzyV7faJOs6AZmIHokw/ujSukycgkuRwY0tTGLsmHIGQYp+YZWsiH/5ANEqKPAqJwJrTtWVi9qManad7OA8vk2KRZh6gUOuIBrj2sn6raCVuAyYGoRr950LgcUKjt1exbQegWQhKoznOEn+blGr4hSqLwfrpjrfvy+n0V0B1f6hzAcx0MXZrlnf804ZbJwNbx5+1Fu42o+ByxCnoyn/PAxXuNenKTghl06SSyKSGEb0lWuDdt49avCSCccprlaWUEy+qgd53ZG1LecPJc7eJm4F55hzKhxBvXLM8Zlbu9UGeekjNo64b+4u1rF3d3MMvShXdhM1RRO+qsV035YSpUIqM5nTYiWMXetS69Mtba+Q+Tk64PT+G65+4EbwN0s4IpWXr/sHzhmepNHOeMwcyah3CJOj3KlmR3Mfp2lkD6jlF8So1bH8259RJoLsNIHzd2yt5CxTyKRbOoF1BDwU3hvtzNLkGl451Pa6HJtGJ8k24crorunCy50VkIlG3zOCHd3iH/cILf79jBgcNUYzjrGweu6eXGuEG2Rbw/jjGyBiPsnwEAOsrQ7FCfo87vKGsDYWu5evIAJKdscLel206eoxgSMy0AuTOLNT4C31IjOofJFFDCCe/LYiWW5bPzbVqJHX4sxAgozQmWyLfumKz4qb46HL6jHkTy7x87CEqjY8WzqonAtf9ZG+ajDcHUmzkJZpNRQWBBoGHw0uvf8tp9uOBmHTQnizM4xCHnSYhzoQ7wSJBZ0XFYq9OWdRD5i/Bmwg1O1QcWGoX8dlK9jP3
 0+H8HuAm
 Cztz/5UNtZQRSxgMMUbvDHPqgQYMCHCLwCl8lFY1cT1bjiaQFuPXvkwqLcI6rgsV9gYe14iLfzhytQMAyiJhVlJY4c+9jgXS9GRQ4aHm0AlgeGGAF6CvcZYp4MA/qor2wcbwAkf8mJrcD2oir8bnWz0t4l6b/SNTN+Is96otHexxw6RAZv9NHmp8onUv6rhJJ1T7PR9jCTNPIPZA+bUfxyA9GhOb84cta1iG1iXBeI2+ZAAVrgtiXk4HQlHFe0jw0gkTMsAMOXefVpr7geh96k6U76qomnMR+ghLmvNtunwrukLcILMIk/kreJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 02:42, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> huge option turned on also sets large folio order on mapping, so the check
> also applies to shmem.
> 
> While at it, replace VM_BUG_ON with returning failure values.

Why not VM_WARN_ON_ONCE() ?

These are conditions that must be checked earlier, no?


-- 
Cheers,

David

