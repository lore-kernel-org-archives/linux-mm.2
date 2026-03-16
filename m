Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98701F53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BF8F6B00C9; Mon, 16 Mar 2026 11:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D7A6B00CA; Mon, 16 Mar 2026 11:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E916B6B00CB; Mon, 16 Mar 2026 11:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D577E6B00C9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:52:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B2BE1B6F42
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:52:32 +0000 (UTC)
X-FDA: 84552368544.05.5851A7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2D1F180012
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:52:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cm1SISVw;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvRmFV10ifihOCkJ3GZfZiL/I4GFsF9tsXxX85lW/Pc=;
	b=G5bFpkgXB5kYrDtBQpSR6OMfDUztESY83xYfS1nv+MFLGIEXJMuVWwp3sVTpqfh9JbPkMN
	q5NIuGJhdghfjhLkiitIeVhZ/HHYUyKLyVMOkThKvOAr8/MtsXYuF+Sx2yilSiDVr/r4/B
	vds/dqvnYTxmrZu789r9kWQiD0i4uCA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773676350; a=rsa-sha256;
	cv=none;
	b=6/ohoRWwBpbH7AfOaTHt3i7apPdMPfGC2s1wTuEvrwyPEaJDE36/Ygax+WgVRmZY4j/vyD
	u0mMKSt1gS8nEnSs28GQ2cwn4euORU+363s/lU6R0MbbXH5apiKV7xZ9HCNH5bJa5YHQVD
	b+sLuXzsDaEhMXo+N9dsGuCLbd3k7AY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cm1SISVw;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29765600AD;
	Mon, 16 Mar 2026 15:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC99C19421;
	Mon, 16 Mar 2026 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773676349;
	bh=cNdeyomVAEFIBrNAObdGtkhUFNC6v5JlcC5z23KYG0Q=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Cm1SISVwt431T6OvrwjpJwhkWBv+6rd6M6nOXfeNjrIcN0REG9O1Ih2vD2BDj6YHd
	 QJ5YyWg9yzTZT8QRkDkysiYheCQuPjEOiPj7B/9ZizaHTTA5CboHDFN5jxIhjNM9f8
	 zUAl9X2hVk0F+dMXGZeAt7qShSnAkfuCUJYqPGv3Y5eiVrVcgJu83RbEaMhC1drhjf
	 dnTh3OdaKQ/lXVDoSPKdovRTjZKFfDSc+1dSfAYSWyuvnCKp3xJ1Y3ht43W5d0vYuS
	 dstZ47xnyeu1lgwkc+pX/NDyik4R5eb+WuoyCRQfVC8FQ1zyktmvVndUgecABQC6W5
	 PQzFFd0aDY0Tg==
Message-ID: <00ec73d6-11d9-43ab-b1e2-d543425d19c7@kernel.org>
Date: Mon, 16 Mar 2026 16:52:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Discussion: Targeted memory allocation via
 debugfs
To: Juan Yescas <jyescas@google.com>, Suren Baghdasaryan <surenb@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier"
 <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>,
 android-mm <android-mm@google.com>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 lsf-pc@lists.linux-foundation.org
References: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJDx_rj-fTpKjtsw1jJ0aAaC3a2Rt+zrizqY23ZHvq0Mm56uTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2D1F180012
X-Stat-Signature: bjgtnoanimabwzpjc6t77waewqjd37xx
X-Rspam-User: 
X-HE-Tag: 1773676350-795800
X-HE-Meta: U2FsdGVkX1+aE+RWHCee4l82P9oOtmzv5uiv2T1XOX/9q1mHS+S5c5nv/Y+wzXiVOVaei3cLCu95CbvJPeqzm3Uu1FYV2qJICpDpJuFUTWaeg5fXZpCzO/21Rgh5fPV7XZTJhVl2ejVSxAxqFHFK1MSUHF8WKndYXkgwJBSihXEzzFTZY6PW1dC/sICBYZ/RxMwAE9JukkR4Hn6Tr//6g8ShxAnqrGx35XWpJPLDRc/8gAU9Xd9J2ws92CrD5mkM07N+cEW6r2ebijZDbzagxeKORGSDzcpvbkDzFYVRVW+3Y8Cd7ccRLWMD2xSH9NP0mC1hRXWdR60gqvMV0bs1+Pz5XWPLGaIqjhEbYHWa3oUQ/cJ+1zUGxGK8AR0OcukB4i0hwEQEtG+B3io/UthlopNmUVIhr3cJia2JzvIsLfAziNaTSUlRhGfoWdlbeld4fdd3Xis4T8a+BkJevoJLd1ReDjBLjON/F8ycKQmydkXPP7ZN3pVCra0DYi6Xid+NLcAw/kMPWEEfjjAEjI1FQnonIOJr+0RFw5dzcpZrWW5+0wRBYCwGEjv39jx+mS3Ap4a5PaXc32aZuX7yUyoFoaTjkSTBeYtdaw1EKRuRaeu4PtjgkJ7Eo4yuO9u2SuGLm2M3g/kfKTJY24I8tY+TLnKvkIlvJZjNx3NoKxxxuOmwCSnjjf/8jVVZqxo80qtCS4vwHPdnOyilFcB6Y5aszhGsih5LGsSgz1/1QBd3pmWKqlqvw7qJPBquMh6JeZfjsdthgtOJd/3qFp5du864DxcQYW7uaGnbozUvX1hRiCHWb+Lnfe5MXf374nTwCdC9xQ2W7iN85UNd1noEKonjNjK4hkUcOUsGxsY4c21rN9BIT2DPH08KaAcZ/UF6QXZRwWEU8ZyYLJJ3RI/ifYo/MIrSmnxyC0F5jMlFvN3LSSYZI6zCmru9YSpiY1OaNaKFCpZcsyrvUMqJmtMh3I0
 7iRuSHef
 FLICaraNngklEXZOm5YjKXW7dVOxBZfGS74S/lIZHwZsbEmwDcQPkDB+b9aLRY1GtsiFKhSyAJaC+ltv7/e1BDRRsXkOmf8pHo0d85XdkdzxjFv5759nRf2nt84YylJKkHzbnw1krBEnFfhbQ5reY6wjNCdhj2DUkZd5InH9BSfaXHz1sHabcf9Rw3xrQyl2UeX2PPJ7Vjm4tdg22Jyi06lol6M42xgtEmDfy2R4rlXkb9ed/Htog4jSh21F29FlvLGZB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 03:42, Juan Yescas wrote:
> Hi LSF MM organizers

Hi,

I'm late ...

> 
> I would like to propose a discussion on improving our ability to
> reproduce complex memory allocation and reclaim scenarios, and solicit
> feedback on a debugfs-based testing interface to help trigger these
> edge cases.
> 
> == The Problem ==
> 
> We frequently encounter complex memory management issues in the wild, including:
> 
> - CMA allocation failures due to pinned MIGRATE_MOVABLE pages.
> - Page migration and compaction failing during reclaim.
> - Excessive reclaim loops triggered by specific workloads.
> - OOM kills.
> 
> Reproducing these specific memory states for debugging is currently
> cumbersome. For instance, consuming most of the available
> MIGRATE_MOVABLE memory, or forcing MIGRATE_UNMOVABLE allocations
> specifically from Node 1 and Zone DMA directly from userspace,
> requires writing custom kernel modules or relying on unreliable
> userspace memory pressure tactics.

I'm wondering whether an OOT module for this purpose would be sufficient?

IOW, do we really have to have this in the upstream kernel, or could we
have a public OOT module to perform these allocations?

Then, there are no worries about API/Extensibility etc.

Or would you want to fire up this debugging on a production kernel? I
would assume now.

-- 
Cheers,

David

