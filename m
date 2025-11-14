Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AF37CE7A8C
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D458E0005; Fri, 14 Nov 2025 03:54:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924C88E0002; Fri, 14 Nov 2025 03:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862778E0005; Fri, 14 Nov 2025 03:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76B5C8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:54:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F8A54C4BC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:14 +0000 (UTC)
X-FDA: 84108600828.23.719FD8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 908AAC0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:54:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uy/K/NwI";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwZzv3y+js47+JZV3i+NA55WAqjJ+5Rkr2Ompy1vDMY=;
	b=tm0PyoECxKwIjiRw7r+nVfI77RsH9IzGCyfyRnEL+XvEziEj7o8lnNjUymNT2MCiu05NMT
	ATSvsaPp+bo/DJjVlfy/EVoSFzQbN9tsuKnr7rfji28REUt6lWhBJhkPbzyIQTx7zxyEE1
	D5HeCO5FZASP9uf9aBJtW5o9yBYlpDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110452; a=rsa-sha256;
	cv=none;
	b=6JgwW6XYK3uOvA6NbpzUrOZRjaS+ts8lCjd2cDHVJ/PjiQfnS/IyPofHHWKeXw4+JhYyfv
	zr51+3EoyNoAY/iCuLuXvZuKPwoVWk87QApD/J4QGdJhGJOYWJDDResoehY/qWuD/BmwAN
	FUCJbPJG97/gjdIWE7Z0nNvToYGIZWs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uy/K/NwI";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBAC16016A;
	Fri, 14 Nov 2025 08:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060BAC113D0;
	Fri, 14 Nov 2025 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763110451;
	bh=chklDexcVxOZTY+O7EjWQWgJiqS4fQfWDXZub1nS3Ec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uy/K/NwI+6wZozOgdjofH5BAuvB97W2ZxC+/01tdLjf1sJIS1waJ/gDwS8DfirYVc
	 /+QvJfCve8P8x5tNAOw4PrHLHYejbladqHW1YyMonOz+o19fboHA0ZoAKXhG6eT3x2
	 N8ohawAwLJ6GXRGsXEr0EzFJMZtBgc/HdlvK0PREeZnUmfi9557O/yyPAMr3E+fY4C
	 Vr9T28xshR8moGyCPzbbvj+RyzinEeKPNS35ZWgPa/rDeqboUJT3+eu0WKG3hGEyAc
	 Rrky3YjDVZV7josWR9jfyXXXu84j0l1rEF/NxLuWqz+prZsnlP9Wf8+a4dYjBetzan
	 iMfBUPGrBXULg==
Message-ID: <62228641-9e9f-46ce-84f3-a4338dd57a20@kernel.org>
Date: Fri, 14 Nov 2025 09:54:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 2/3] mm/khugepaged: continue to collapse on
 SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-3-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114030028.7035-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mjjbejmbj978i6ypgedfugdnofy6bopt
X-Rspam-User: 
X-Rspamd-Queue-Id: 908AAC0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763110452-564795
X-HE-Meta: U2FsdGVkX1+ViQsOmVfPbibHbuo5D/M7sDLUeFGA2YheJnhHBxvxJFZwAn8j3N51UqDofTceDy40QuiGWna/VlrFSofabIlJMn3MggqVDmdUTZJiElgyddyIf7Ltcvr9idpIot50R15mSfzPhGEQcjQtiJ1VExwKYYejoP0bZG4fQeAj4hu6wGzHflwLvWeXvRpw3XLhedwwxskQqOWGg1gNvEFm+4oDhV+frvcVIpBYIVytv2dFrempit4F7zAxphnki4/RTX8cI1dUFg+8IF1fie/N0Q1FxBJU0sz/DY2q4RQ8NzdxXO0GbzAtD5cikysW98mOC0JWwIyngZgOz43TfWmCofZXOSOfubhhnxjIAnRn0tpYjyx3AEad/Dys9vigG7POxBXzq+32WCYf9nU6jZQHSwIaJejx3vbBfWipaDbQYU86BAgetK7LCvuU7J2kstcvVSLFKljotF+z/zWDWVqfrvHwZxPtx6UJfb2op97tYucnU5SBE4Bk9DC1IbF3UYAcWFjP/I4mDWzBF1pVfsG/VJfBgccwPpOSXeLCBdFJIsuRjyRAoE40dp4gmiCa1ey1X0XQmw9MyQn87fd5HqJ9X8fkbjiuLhPAk8XPUV2fMeHA05q/aGOi3FzheCwdmm11LYMpeq4hGJab42FFcIWuGA5SgYQeXqZnOkkq6hEKuLmJz4mPtz1P7q8nZZJW6FkZZ5B82+dE6fzK0zBSIZZ7SZs1YH9Qbyr4a/jlC44Q0/IndDkHLqee6dPx6wxAL0B+mDgd6ezJesKCSFBYx9muYecSRjsgAu1s2RK5X0o2hbxn/K8ASC8jUQyZv82xb2Xf2w2mmVtNmUHB1SptmUW29pNaYW87GWg7PhRXfu6bYniqxCrhySlHO6upGyaKsG9cveMu9FaGTLEtrdpxs/83JNEqJVOynqRdmqjFtebeDE9y4b/STmpeekWgQvfP2aXo888E09Bjazn
 S7FqdGcM
 3uVW2WW6qesSyAQ7yPV5iQxTPXJHcSdsZ0Lri9NtFS03Wkqgtyb9emG6gXB+zto0FYusPWmPGv67Pe/Dp2qF9U1ImfkRCpGmciCB3oZG2zFbnF5ogPsCYRaBv6TleBTffa0SC6DKfQDXX0doTmThFWATrHzgVZUNU4ABWlJo09SBIy5g+ta5FObcX4rUoeRQjls+4cvqLN+rEaamNPnSpT4RcaD50cPLGhU4kIEdYxP+7ilWqQy2S8ZwUNLxX5OBsOjNVMFsPtgNz/T6tJn83cq958W8PEwSfD4ZZu9E0nNKXZw96Voxe6PDtR34M1Xs26mLdqSSallmya1uMNK4znIbxrspfFU61y4EinQg1zx7Gh7GaIzmbIci4eHXbrFqxJ9edZid7tQJRI2es+4+79SBV+bVDhKCYEQQZgmXO66CAwPO5rpaI+Idwwt042Nf5BJbyaOv/eIGqNJVRc4JXkuJ/DV/U5EOidyDh1UxHctF34f0RHHnSmB8JKWMKj7puTcS0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 04:00, Wei Yang wrote:
> SCAN_PMD_NONE means current pmd is empty, but we can still continue
> collapse next pmd range.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

