Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC202107637E
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9236B008C; Wed,  1 Apr 2026 10:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9DB6B0092; Wed,  1 Apr 2026 10:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFFF6B0093; Wed,  1 Apr 2026 10:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF9496B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:06:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 865811A088D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:06:34 +0000 (UTC)
X-FDA: 84610162308.29.593C890
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1A5810000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:06:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rfcqm4bj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3/rH5uo+g8sJkjRkUiHeu5NNZhWP1osqYPs+dik3iU=;
	b=4ezZoI6AiBnihiTqjEjxjIxC5NtL3i2ITrZ1M0FbJDTJwuF02FzFUl4lDs+oT9OJ2FkxSr
	yKQPvxjCpvvSZ3OdJY6w3krfXGfd9STdjsOn0TJR6mPYeHfvfluih08p9/rf0VkPKnYLaF
	5o3Je7GgQ8C+Q032zl5FjiA13BPuCX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052392; a=rsa-sha256;
	cv=none;
	b=wdXE+YViI0ere4ai2eS6eWRKsuUn6awR8MMF4GPlQfkrS6InEbJ1wP3G521rzxXh3M1gLW
	YBlozpovwZ+FZ5C1H3/hJbrgX2h8dzyO6clb/jQ0dNB1JcpHu1kcFNzeL4g9BkYdQNJmVI
	c8M8mlVsK/sgfUenvy1Lfi5XUUBsmzI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rfcqm4bj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 17396600C4;
	Wed,  1 Apr 2026 14:06:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BEFC4CEF7;
	Wed,  1 Apr 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775052391;
	bh=cxVnBzqdjqFWTZAgsZ5um3GJjilJSoMxDnvtKIE779o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Rfcqm4bj/SYJzxPuxmgocTdUVdfpmEg/yKOuHcPtzZVp2bMAq8xAF5bgIXDyM2MHm
	 7KBDBReICSpNTUhShYwpQWkVaoZJAVBKMsQe4MwT88U6rXFBygwZUu1iCVG2/tOVPe
	 jPA54OIonFN9Q+YD06EL+0yejAZC8e7BzbHMQb6HEookQ799RrNNgJOesXHEzMG2qI
	 RUTkU+e3CQMJABxd9HoKhURbhVLlyBY4P7m742XTuPI+E3Vr6/1RAzOEomVvf1KiMr
	 HIwpalNO03k+QDegeJsYIm9l9SdaopRMNM1Ry1J8iF9v+MO7PTIutWe5orWFpeFkIL
	 3+TAiAhoeGJDw==
Message-ID: <30ab15c5-56c3-4855-914f-74ece8ac5ec5@kernel.org>
Date: Wed, 1 Apr 2026 16:06:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/13] selftests/mm: fix hugetlb pathname construction
 in charge_reserved_hugetlb.sh
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <705e68507c9a0d20de835d53dd332eeda7dee772.1774591179.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <705e68507c9a0d20de835d53dd332eeda7dee772.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1A5810000F
X-Stat-Signature: ia7jsqupd3nn89hu1k5hx7d1aib9s67d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775052392-389917
X-HE-Meta: U2FsdGVkX19OuWj9SLRoDWbxawX43Don11G1Sic2tYZdDp/s/v57asQ7Qd6mqdga5Tfkpf+OiktRXYoFyHLY8Ze3LYFmrSql1X9iuHufs7/tgGh2FAzv6quaIj0lS8REDI7XK5kBxby5X9kClcvxozaB1WNBnkOdvlvCSsorUtyIo7IH7HQZVOJOk0sfKdZGExAYwbaP6hGZ/cH6XpR+GMjfTeqiM8Y/vYyJJoLLMW/fhVOJcNSuBEaC07bdLtyobTHMNYDIgUBFXseMEFM5Mfpj/gsxYKUo3g+CXXl9MYuLWIurgKE45Kx+j+dVWagiBblrhvKHqu4MCnCAAqls5b9Omw7Fb6m3m4E4bDzA6yCqjY6jCaKdoVeTE4P7iFc80t4w+x4ekA0krgZ15jsS1AJ7ipP0LsDllCtCJxCgxIyvmgWgHHRrNpvvctaaw8ShG7OkvHpy72ocKMOmgr1Gxve19J2FMMLtCOlczDYK/eteMFULdMRH4+uImKqdhXHbXa1SMsNp3b5Osh6klLzhQ1NHSzm9wmEsqSe0i54sFHgDXrQMlWAcw/K0bWE7TKobh8iVYLO6/2SPyO4KL+GY6Jbm2EmWGBYteKQz8Gmy+pjVH422N1rEBYhLISnjy7j+33ofwOavQOU+gWZQXrRA1N2iu20uwDhU+/D8sjsUyzZY6io2RL9syLLQtVUfCtLVYAfw4qnS7iCW1A7aeas9PxeaIBKjwlzB7aflbX/HCGibhvtbW/9jUFgMMOTjcQMqq68LF8QlUQMebZYT2ammrytfFnuAHpg21HvE5SKK8MoNFy+JTPDinItJNaU9URKvdXqyIAwjAwrdxMrOYTej4gAxe1wH+wjXGC/bgKYYtJdTS4r+5jqt6N6xsb5Qsu3et58Ftw/R0Ic0pXwz1H5UB+N0PTj0fuz35/e31++re+Z07YiNKoj80EeW8Qj4G65atzX2h7HRBG3Qx1/TDaw
 jUhkGhvT
 nI7l/trZrTWZjZTRXX56QLSrSewaYSPTt+jZwat5dYLZLwUUwB68C1QvnBQBFoaWGlmLXFaLjzBzDNXCBbIlwDj6raExyGpdEY/s4gtYzP/jU33onEyhCHkmmGmu2U/ikKC+jsKZgYBppZo380RApVJ0zGH9HnD8KgwAYPZmBrCtGZb6KGt0R8NLyRwykH9QLo3hPWjKgQg4PCMocvoka8uBennuE0JRi4HddTXl4dYjRMku9qUrXJNV+bAN4aPchIIie679aYhnFn0lQFfp2q87tn3h2BWSq+Hj86MK/IDWwwRxJlOXQvU9RIi38r3vOG3x28aV23TZMQPGI/zDnPmbhJ803hCizamnndq4hO/+yTFZxrZCxX7HthJZMCEs7tA9OLWf83/PrvOIX8+10JFW9Jy0kBseifmb/QP9kcAJTZgQrfgSEV1pBGBhHxXf2Mzfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:15, Sayali Patil wrote:
> The charge_reserved_hugetlb.sh script assumes hugetlb cgroup memory
> interface file names use the "<size>MB" format
> (e.g. hugetlb.1024MB.current).
> This assumption breaks on systems with larger huge pages such as 1GB,
> where the kernel exposes normalized units:
>     hugetlb.1GB.current
>     hugetlb.1GB.max
>     hugetlb.1GB.rsvd.max
>     ...
> 
> As a result, the script attempts to access files like
> hugetlb.1024MB.current, which do not exist when the kernel reports the
> size in GB.
> 
> Normalize the huge page size and construct the pathname using the
> appropriate unit (MB or GB), matching the hugetlb controller naming.
> 
> Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh work with existing cgroup setting")
> Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

