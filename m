Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4415CEB48E8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A736D6B0005; Thu, 12 Feb 2026 03:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A216D6B0089; Thu, 12 Feb 2026 03:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8686B008A; Thu, 12 Feb 2026 03:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79BAE6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:57:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C9C814061A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:57:00 +0000 (UTC)
X-FDA: 84435199800.24.C66C12E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 77A874000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:56:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3P+tnYd;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3af+MlltrUJA/uboRMs/erPVn7vNghqV5n1Ad2OB+I=;
	b=lf1mP7mds3yEel2dgBttfukk8bG6fPXaUfGmUPq0z0ngYoLFXEUGvpkTChgx9zdWi9ovbf
	tgZ1HLDmrA0fnSlTMZCsck+1fi0e3HPyiGciUUF2paBJ9Rx7FvFkPMB/UgUCRWBRrog36k
	ewrnFKT91LxJ/iE2yLRwrk0j4FkOyoA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3P+tnYd;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886618; a=rsa-sha256;
	cv=none;
	b=8qgX4mb1qaXgLf8n4plS65+z1252DTHn6QERAn8awgEKyGQvLfBkc48Y20IJYug+6GJOrC
	3GHQzLg+uwdToT7HQk0niPWYeiMuzRBB9/zn4MkyWkIL1xvQiLRTkVjDlK4//Tjffa9hB1
	8EaRwTshxnzfgNKKj7n6rdn1nX1lmhY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABDA260148;
	Thu, 12 Feb 2026 08:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D63CC16AAE;
	Thu, 12 Feb 2026 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886617;
	bh=GSFGi6Wo2gbSRWUm5kmTNakdsDg392jncu06ZCo6F2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=S3P+tnYdoMFREIUFIC069mQQC4uLJ6Dt1oCYwvaxKDa2e8zNEtLTI1vx97FaBuZAW
	 5xrzYTctJzVhHKi0XVOJUIY5DH46zCoKA+33SzqDZy9a4lmVQL55+/JhxVDvoFPrtT
	 eEaJbr37tKv1s7fZVD6BhE3Mv1ZK/7BxxHOQC0lTSud89gI6SsuU97cjf3dGZCESb0
	 jPFgelLVbcNJ6wXavCb11wYhxCM+IHiqZIbppRhdxYCquLIVbmkl6qJYfiHnUL9SZf
	 CMeZaqcd1/zfangSWxJz1rirNkrYlbdfbHd/Hg8/yBuxR+ueZIVHPnt7DynXedsC3x
	 UNH9k22cBlm0Q==
Message-ID: <39da9858-7e7e-4df7-be58-9d6ec32a4473@kernel.org>
Date: Thu, 12 Feb 2026 09:56:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, osalvador@suse.de, gregkh@linuxfoundation.org,
 rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 Jonathan Cameron <jonathan.cameron@huawei.com>
References: <20260211215447.2194189-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211215447.2194189-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8z6ysy4zku338ejnhopcqfrzgbofrpjt
X-Rspamd-Queue-Id: 77A874000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770886618-980548
X-HE-Meta: U2FsdGVkX1+dxeuk0/rgsAB8bdWG5swZluD85DP02BLVIagcRBRBeueKu3ojZvwq/GF1NWjf7iyVJbF9EpS56Rk8N3/60WJnUp49y6y8cI86FJ5O5AmNuVUuNwAbQD5zirmzGFc8EfnDzK8mqd9pMggWboniC56vQhfW6AiwVvDdwXaS3unp1F00g2vYxU2VDCK2pDUZu/l3158y3iaOWvTc8Uoqk66AXtjidaSuUExfGLooTGpOig2Kf+FNHZo1avr3duRjFZEULlUZM58Jpk403yOlN+8s8wSs3UU0Mcu6UQrDRytE92w+jyPtT6D2RHHwh10Gbo4+8cQORIJt5CxVb+/NPZAQw7CIeXHSZKBT2Og8dMw5HWuzZEpitFT+bGYQ69jr2C2UI6y1OcHn4fTOsNnUUU7r6mE7Dl6ZUUDpfj1UEsU4q9idWxoLcHrYgYBBWT/oKFHtmBNbJRynjdSgWOdEIfiyoNSmsjsGFo9oasY/lUO35dwQY79f19/1h2tBzasHIwpY4dFWu8yObi8dvQmsuw9nOWeDsYRo3EHlgWDsx3yzCgb01zzCz2xbZlOpR8rwuz8KrWDJ9EKOa7fK+8rKGAFiXOAsy6/glFNfKWVWRWI7jTfylMYsgaUYWJdhgPZW3yxAXGezHnlKfzfALydvTJDAFWP+y5hTPyeM8cne2nFbbE/ngHAdKcp8oEzshSP3ptkpYPaIMFMCR1KLkBzTKIWCYy7GpvskN0gDpXnYV3KFq9B8TBinw1AKpxITsWXzIofJbHGfrOKQ80xFEJ7PqxlUx7BetpwYAnXYofgKFOFUvH0O8i5RSC3j2PEFMLyqhzf59/YxHJXxfqUnwfAKVOrI0PSB8F9soGdATtRZlGFaTM5lVRiuMp5GphU2qs+3LgmJIdzcJziZ+v4v+tkgAQMLBgrjGns8L97T47qZC94mQMc0w6ZTJQ+QlrVLwo1RxXW1GakPdHZ
 a/KwjH+R
 wbEdjv62BB60bGB1SOdnuJAs8bLoIZiYl0Cl01yA9aldRXPOkbMHyTeYW8z1k/x+jx+uDP776YJBmF7BQjh8FvUDspYWEWGY/MUEJyAd3lOitAPggAeHkPStERoMSDVz8DAIUPyp+4lL1foI/aWo1MTmgTUp9wZRPcYjvgboW/ypRLzXRRlt67KGEAeIIszy5jF6Sb/fBZ48qs4Q1zE70EsS/O6KEGUNT1COKpDkftfS7iY0EHvuMQb8uTqKe/YwCzwi4StgTTY6C56ZhmB2/EzPUgTzte8VgQ729MyPRSO30wocBx/04Jc/Ad7gDhCuUrE6vts8Nt4GWt4aD15unA4//rYcqBxkrv3nbOCUJvY0xfpA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 22:54, Gregory Price wrote:
> Give the MMOP enum (MMOP_OFFLINE, MMOP_ONLINE, etc) a proper type
> name so the compiler can help catch invalid values being assigned to
> variables of this type.
> 
> Leave the existing functions returning int alone to allow for
> value-or-error pattern to remain unchanged without churn.
> 
> mmop_default_online_type is left as int because it uses the -1
> sentinal value to signal it hasn't been initialized yet.
> 
> Keep the uint8_t buffer in offline_and_remove_memory() as-is for
> space efficiency, with an explicit cast when we consume the value.
> 
> Move the enum definition before the CONFIG_MEMORY_HOTPLUG guard so
> it is unconditionally available for struct memory_block in memory.h.
> 
> No functional change.
> 
> Link: https://lore.kernel.org/linux-mm/3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org/
> Suggested-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> Suggested-by: "David Hildenbrand (arm)" <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

