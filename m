Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 420EDFED2F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 08:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB336B0088; Thu, 12 Mar 2026 04:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7931E6B0089; Thu, 12 Mar 2026 04:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F1F6B008A; Thu, 12 Mar 2026 04:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 571596B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:58:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6B241CE80
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:58:28 +0000 (UTC)
X-FDA: 84536809896.01.9C24204
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C455318000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:58:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Osh1CVc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773305907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+lYq1wwJXJXUGtuRSDpec/dRwNOiUTB3H57/49iiOk=;
	b=hJWACjc9o47wlA4o1cmZ2lpMfW1ZOO0kIoqsiZ/Iej+YSDd0D8jIsPwmiUtItxCKu79YrG
	Nhz+7nQCVkGmuKuY+O3avPLdOROCH5BnP8ufjWpquSX6lDrFFmZarn7eqLP6yhWxfWF2L/
	dHUf0+ASFv4nWQi+GQ3Cbf5/xN5wZRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773305907; a=rsa-sha256;
	cv=none;
	b=HRI0QbV5ZE+BlYVcmws56qgPVHSUeYneJru31R7BkBF91rX7vHs/VUWJdYbBfzA8aGEnDs
	VtGIBaArMI7zIYqeZ/V/Y8Gz5AJ0hymTzwbr5nJm6kO+rE1WvfZvyQ0LahXJe4wANaFLAh
	niuZw+pwdRWlo7yTX6xfy4kRFxJF22w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Osh1CVc0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C44243B33;
	Thu, 12 Mar 2026 08:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3DEC4CEF7;
	Thu, 12 Mar 2026 08:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773305905;
	bh=DdfFRNTopIu7ar0QnGlnBz30tm5MwFJ5HMPNhu5eWkE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Osh1CVc0M0NOKA0+xKrJEUHt5bGEH4FKvRE+lhAgwnte4lb/L6KnsOOdaNBLQs4WW
	 MLvAOfB+r7k2bnjCNxBiV03ZYvghXBvB8f5VQnx2l+dEIn/Xvcm+JntldNeyIJN5bY
	 UAHHDUPLQ8qeH4pg/gL7YUeyTa8fsZu1gan6z70R7qyEu5ViGOU13kmeV+nsLZ5J5i
	 I5oG2YlNJA4lmLTgyH+btArgC7GCV2rgIumUFSMARFKDpcCmp/shVK5+rb+2NBqvIO
	 NZr1QvGCveZg3JUtq2z7NhJNAkvEbXzCti0OfVfpiq3ZEYCPfa8NpC7N38Tam24WSr
	 Jqh+HawIfy6DQ==
Message-ID: <a339c666-79ba-498f-baa6-14d1fa47c3d0@kernel.org>
Date: Thu, 12 Mar 2026 09:58:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: pagemap_ioctl: remove hungarian notation
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260311180737.3767545-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260311180737.3767545-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C455318000F
X-Stat-Signature: 4nka7ofz7qsdtdmza8oij7qfkd9mw36g
X-Rspam-User: 
X-HE-Tag: 1773305906-938035
X-HE-Meta: U2FsdGVkX19eWu1QtsrDtTC/43Y1FSZVfoecxo4jzoYP24V8eAcj13LDnMAKzj68JHY8utIgNC3d2KmbEExUPSTnw6Yc9/vEYkaGBaVWkTt0I8/ya5myPUPNMvijAziuekgOxOL3/IaMhswUlcBXfAsl/HgGOg4bxM54DJPbOQIUqi8VjyuSBxJ6ofWsorCJn9BuvXsOhU+T2bP9oZvlpxWn+30EiVPeppQsAFzULhGoaJK0fHnKjOCxS/Y3bsM/Qb27M982S1rs9WLVs3Jzvn/oFhukV5CFfMIaz9Iisyqr5PJeUVpyO6ZhE4G0L9gbxDaodNx3WK8W9cZpJtXxx+ft292TnhK/DVNn7UM9gMgE/LJ65lFqir5Xd4PVB1tIvtPSQfPsZLpInPpa1mXmLEa+sYS5543iaGX5Pd9J1Z3B6XC0Wu+dp+oGYCTULj8btWOsIYoSMTG2njQ6/89zAdn1ThVD9LZ1HhafEkLqpcaoUHKgLaicOlxKkGjrTrt49cTMiZAE5js8OoY0VuQYEL+543QrEbR6nfE+p2B6A+X1r40pyXtCznhfjxrPRMAcoh03xDZgtzUXTHitep/PdekA3B9rWPcmc8TibDJmdLl8zy1ZTx9jxGwSsjfbNBpk357Rk28NEocMpwCrZ60lF5ecIlxijjFtmIa5AdjgVYcMRWMgF8xrsFO60fnPczbtbkYVE4NQ3ccMiS+sm/wQ+Fiqh8t2GNgwpDfgmC/hliaOmcdfrF9KiikOXIk+H81DlueDchjm5lfTx1amdQ6idya1D3eoweQBo7aoB72lGIBcqkwwtK77zF0zrVkmb2Q0z0V49rDV7kwGrUWLZnkJ20kmgmHgOt/lc0BSQ5qtcst7/wbf1wolXS0vH4RthvtNdK0GRNJS/k40CP+6Ar8/Ow+TVTeVUCpRjlraDJhnCWUmcp2NdMKY/A2P6M6YZfuz5Dcq/HrfOWbYYMSo+OP
 WZN0w3nJ
 XUTmzpqqu39tfFXNKeX0Nj48o+bBhuc0nhwrncsWKyg99Sp3y/pX6A2NoHDYRVetxN7gIsGYLIUzQBzkjfzFg1RwCznhi/d5VBl6whsx9A0p28Yuz/AdxgogB96YDOEU1KJ5Md2UBLWEvqDG6nn7HxUyBfXQ6H2aYwCcCNV5bCIttyy1CVEH/viT/M6p6DfcLSl18pFZIlgJnthXjUMK6RBz27fDdDl0SZwh/tekNeoEloHnScW05iJLSJQu3wAigkSJw8I+nfvpeuKFtukIn88if5kTLZL27wyUuw0qgJh46GXKEw7TfHTPFxey6f1qrEMIVoD7WamvM4ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 19:07, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Replace lpBaseAddress with addr and dwRegionSize with size.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Thanks :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

