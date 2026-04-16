Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46708F8A148
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C7C6B008A; Thu, 16 Apr 2026 04:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EADF6B008C; Thu, 16 Apr 2026 04:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4906B0092; Thu, 16 Apr 2026 04:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF566B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:44:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2142C1A07F8
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:44:38 +0000 (UTC)
X-FDA: 84663783036.23.EE7EE60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6634540008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:44:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgFpq8ip;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776329076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ykg0m7G4f8szj+bmz4Q0dUSvXB13qMgBtB0igQRQ4V0=;
	b=tYLhuevAiDAnMCt3o8GYTgmr4jWpxUT4+rwDVeY8HcGYJ6nYDnK358P6wPwUrTkHdnQuJS
	1yLzfsmE/Uddhc00LcYHgdjsajQN3is0vLamqo0Qjlzuf9+hjZb05QlFOBYX+4kUhYZ/q2
	3WNvjrZp5Kgpz1OnRtHZ8bROaKYtLSE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgFpq8ip;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776329076; a=rsa-sha256;
	cv=none;
	b=JCiBudcWOKurND0Prz4P8qOwJPQEU86SZ4P/YlGscdlq4CJB6Ns9yUQQReJcUcEDz7EwWZ
	9dsyICAE/MKdxzH41UBFslRtL7hSY5xajZWCGANqHhHxEMj0husZq/cPlPvcEaSe70XY1g
	fnosgPphOBpPGX4ZAPyJLJVmt/JyL3A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE19F60123;
	Thu, 16 Apr 2026 08:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89696C2BCAF;
	Thu, 16 Apr 2026 08:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776329075;
	bh=gAKlU6kkC2VhkkvYb8VZH47y5YSTapJVn5LN7FPl5KU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sgFpq8ipNPUDwHg0S0f0GYn797xyHGz9s/2LHOijK/SVj4rkz7LxfyO2I7Z9Ni5hw
	 K1oI08fM+b/5ULka8PZeM0qluz/A5VtfxN04GQfNT95mHES4zZdZa1lpNlbtWMF6S+
	 ktaitMxWFlz0p3iCAM0ujKfQ9lJdT01SMTlhHhAYgJa29ExGeXHtV97PE9eSosYQiP
	 /MFRQYTwWJIS6fHu2Kefv93+oXlswoLq61TW6kWINDF8BUTTUfxLNH0B5vkGhUUv8p
	 NJ0G95k1La5LxitHuxQnYwT7235OtlfQgy3V7R7bMsSOC6Afz/G6IFEIIeZjK2bLNm
	 yS+27IDNGG4Ew==
Message-ID: <82c7ab7a-dc44-47a1-b13d-5119453bc82c@kernel.org>
Date: Thu, 16 Apr 2026 10:44:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: willy@infradead.org, akpm@linux-foundation.org, hughd@google.com,
 ljs@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
 <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
 <907b3a20-52b3-4969-8456-bd3a8d2571f2@linux.alibaba.com>
 <D29FD39A-50FE-4EE5-8D14-A7B40E565074@nvidia.com>
 <50a01c86-fbf1-4f93-9557-6e5cc1dd1dd7@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <50a01c86-fbf1-4f93-9557-6e5cc1dd1dd7@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6634540008
X-Stat-Signature: aw67ompehhzq7p4nmwhqu5u75rwouqxe
X-Rspam-User: 
X-HE-Tag: 1776329076-151734
X-HE-Meta: U2FsdGVkX18KyHDAsju8JLDepYU9VqEx6k9ln77GR6+WT70U/x5FghS6ruvV/sB9c2fjUAw40S6t8xAh19oYIbewkyy+Ej3RSudBoJY7DGfuzieYfN+LTYP3sHteAuj487+5mQjyAnFecMJB4e9MXiYREs2fadl/Co9IvNuOSrife7StikN7/OS713u4xL5AUK7ItVYOlctxf91zpJeLblIFJQccOtrGOWptCX7Cmwb4C1VAiFkGNTf8ELKDCgEqQc9fDR2cU9QfV/aFh9H/T5LoNmC8XUV/bUEw7l9dJnMr3t9S5iQ5Qef2vvvML/BdJNMWsiBeq0vhWCpKhKB7SPWKkTDmUc+7WGrxS6A5d5GwUs9JIQWknSQE33JFYZfWuh74C9lyKCQMU8gsj9OjrkrLRevGzaW7FgvovXSFbHvsZUEdhqh2LmIPX/xsziqiKBDZH2CAchPJwG3guLIFpdW+E17MZInnKuN25PHPyVhUU5o+Okd5iuHBpYBodIm4xMMT9DGs4vIzAlwRfLD4rlhnsymekNnZrzHiLveAAinZ3zvca8WK8HBc94yrNMq9XNasyw9uqi2+0DNBDd2oq7hXVrecBZOm4umkXUgJRtS2J2AE2zJO2mIXJTYo9Uj6J7pfFE6Yhf2+tM13pMkcusVIVmjQwBMbb9t5Aan3KYvODMesjlaW5ABYugJ/eFrGz6uX+z7zIMGy25s1QJ2bkBsml/2BPoL7QZuPV2a6/DAPIqCpzmapUNJ3S0vRz94i7Jb1fYd9qbSzeCej3tHx/iR/jJWKWHFkdLnxwQcAo17CwmrtG//KC2mdZZV7TUOLoUAUPzwRqt7058S7bZKu2EJnS/odctgxgl7h+9iIt91xJaZ+IrIgEUwYF/hgCruFIeKSG3O2b7z2+f5ob5RM1gqta96+wU8RUzWa0RohZ3kfSrT1KoClYd8U4lOnYmVArUerzIndxEykP3O5vDf
 tk6R0Z/4
 /zvK2enb+hNi96YSBgDYbEjWRZfPxwkg1X1D3R+UzGHLfuPqP9WaNzMFAD8M7+yHMRfS3+dJqf54+4QQNmeeNRbGb7aPJTKdtPJxsPUWWR7jQFhqLlrbK++Gusukl3wssM5FVbYH1sLXlTEuGgxDHHD3SrSojtAUw4CIUydh70IvkiyhaDFsaucN78mVYMz7hUB4iUyv1pYeWZT6YRRlApk5HLrnpfmE1lJthFj9Os48wKTlljqnVSE3RSC78584OO5xtE1qLp/l3XHMoNDgoQt7pyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 04:08, Baolin Wang wrote:
> 
> 
> On 4/16/26 9:52 AM, Zi Yan wrote:
>> On 15 Apr 2026, at 21:45, Baolin Wang wrote:
>>
>>>
>>> Personally, I still prefer the current fix (commit 5a90c155defa). We
>>> should honor the tmpfs mount option. If it explicitly says no large
>>> folios, we shouldn’t call mapping_set_large_folios(). Isn’t that more
>>> consistent with its semantics?
>>
>> Filesystems wishing to turn on large folios in the pagecache should call
>> ``mapping_set_large_folios`` when initializing the incore inode.
>>
>> You mean tmpfs with huge option set is a FS wishing to turn on large
>> folios in the pagecache, otherwise it is a FS wishing not to have
>> large folio
>> in the pagecache. tmpfs with different options is seen as different FSes.
> 
> What I mean is that tmpfs is somewhat different from other filesystems.
> We have tried to make tmpfs behave like other FSes, but differences
> remain. For example, the previous fix to tmpfs’s large folio allocation
> policy, see commit 69e0a3b49003 ("mm: shmem: fix the strategy for the
> tmpfs 'huge=' options").
> 
> So the tmpfs specific 'huge=' mount option is another way it differs
> from other filesystems.

Personally I'm fine just not calling mapping_set_large_folios() on
mappings where there must not ever be large folios.

But for every other mapping where there might be large folios at some
point, we should just set it.

-- 
Cheers,

David

