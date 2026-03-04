Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B49EB363E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF1A6B0089; Wed,  4 Mar 2026 08:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D00D6B008A; Wed,  4 Mar 2026 08:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC0B6B008C; Wed,  4 Mar 2026 08:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA1C6B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:03:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B3C513B477
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:03:05 +0000 (UTC)
X-FDA: 84508395930.10.9BF2026
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4B5C8180016
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:03:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g6NpVag2;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772629383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YmQ8/dlI6gePGND4BPMhZG1AgMT7LpjrtQvUw9jJuE=;
	b=sBpLvqdnrUjl4YLoiCjJMzOqGuws22l4pTEIRDTP3rdvNobf41mw2WxPlZYZLDPwZNk83L
	YtmyxyZahHo2hlwlFp99lUJ4N1X7AnC8md8Uq4027CrYERXKT/rQVcDZtDTE8HNHLptEdn
	h6QYCCGgH1Sg3MvB0jhKjKK4EvW9Vl8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g6NpVag2;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772629383; a=rsa-sha256;
	cv=none;
	b=PiKPkl76jaG6UH6q4jyNTo0Xkv1G5r0EtqVvF7hWd5rfXGKwBPjxPlZaq+kfQ6R0mK41JV
	zhDEqjWF+HDt8riKQjpDA7YFF05f5qqwWkG01a/FdsfRLZhTnR45Nm8/v0VAI1J/FKQJXV
	CqjiIbCe0+d8899KTMsf7XQgc+ZlQgM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A8464451B;
	Wed,  4 Mar 2026 13:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C092AC2BC87;
	Wed,  4 Mar 2026 13:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772629382;
	bh=TqA3vtHqmK2J2FK5mNjZzCVGaW+JImAg60XzuHNKSk8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g6NpVag2wYWX+aprYWMsse+oPMxIK3jNcy+BS3pnNRtMb4TbjuqM/yaE3hjf9goJA
	 1Nh3eQEgVu2qX/p8k9fvx90ctsUb69BZaIVeGtEXAKx3PW8fvS70A00D5h3kTf9T9W
	 Lf5kEjD7Rm8QHPlYBR5kDauqX4AwYhBjuMrq8UDUmZ1idEY/Ts5/Xs0ivw8L97ll0s
	 io0FJ58pylg3xVQ80FDpxIIPo1LyLmE6dbk6dM1G7KKYgJVQaJCXjYlYr6LMNgwT27
	 mjiE/LFcubpLvXBgs6fOy+gbQxl5AcBqfqCwMwDTv+B4EjJl0Ql7mE0H8586C3BDy8
	 Jdo9gxfZRD7PA==
Message-ID: <a61c62ca-45f3-49f3-90d6-a708e468af12@kernel.org>
Date: Wed, 4 Mar 2026 14:02:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260302195305.620713-6-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B5C8180016
X-Stat-Signature: c8dzn6wexyra3hnh7f5obcgw951wi765
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772629383-871654
X-HE-Meta: U2FsdGVkX1/auR7GIgfqiURyHqtymmYwE1zmZvxz/6J1knqC9IdHVRUIGOElLnawrDUhZmz0PrJeDLgj0MGaQDFbZcJC4RH3db/0yyJKCJ2Ivb/juXAzoRtpijd68ee2oBr87LqCyWb3k4cL8/HVTMNgvaRXKigDS7yoxdfrBSEXtSYbRqYB7qLgOCxsDAhLnR8GCcOmB+8S0tG+Su9eVrguajOnc5hkuBOKtmUBxWEnsNIJ+shXBmsCIEo95/QQMClqEsGk746T4aVmoboYvmVcueYX5+MX/g6ocNZowXSTPGIgyB8VgnaW6OizGxKE20yf84BPuK+VIGQOmm9H5+u3PURmrszzSRRFXfFoSOZ5JTwwNFnkrFZLbU75IDH8q+h2vboT7t4Wo1mezJZBbbqIgg4BCWEf/BhoL2YwCuVvcGksMSzJg+DgksifrtusXkfjSV/+mhqa6xv1To6rzdVAU4eB68MW//boJGdkYE56fBgpluBdARaF6X5DhX6XOq5YDeclP0Sq6ea4bTetP0prFuUgZA8agtQzmZ9RiMggjuK08WHeVtNfp+idS1hQDRVNePE2J+NKwS4IocVBRpyfKjZE8AmjQnPye8IIRHIoRntxUk7uC0ipxgptXjqVKRLByBFDJsqh/efN+ejVUSQdAFyEOTx/B4FfURScpwzlB8IkR2h13SHOg/gntCZuDXoWKSCv8d9XWe3YeT+wE+u+Dk5wVEonl93hAlknI5u9098nrJf3W8Cx+CSl60ykC0koKOanDgQvMUdbkytDPFiMIHSF02mvqT0oD6IwwqLPQfcghh417UUMufQPToSJuAaSLnHDNF4QBXqYOfEoPV5/zzahIV0u5g9temMLFC9BXfgvsI1jlKZw0cGIYYmUxHljau2qXY+Ql+ecpmIETCTrTQZPraPpAsDY1ob9JuKZ4r3fBAg9Usii8S9GsHwmLbPPNaumMFBChB96ORb
 2Aky/C/b
 fcrjUkiDBM+a3PexKvrIdLL21IR5RNi6qUJB1AkRKryEjtaQuQb79bDAhO5z7W4bjqhw68PyjRzEeO+zJhB3uhNQiuRNY+FYG0ERiu/aZ0rJewQe17Ict/WUKmc4wd8GQr51Ndy2PHQZ/qQmJLJ5ZL6EcDUAGKNiar4M9Hu+x3oHm0nnDLRysUvO026BkQQ+37TEUTfqvhDKDEzSHEONYwDEtq5kvwM4nMrg1pn6+LS++8vz2KEAHGYB6hKWyXtlat9Et+2yvku1Otruvbo+f2ISKLRZqa/y80LepfizBgTei/LgCjIRwP2tFS6yl0Z0PK0v/VuIh/X3j+XrZwZsHQchjww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 8:50 PM, Johannes Weiner wrote:
> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> charge cache. However, the intertwined code to manage those dependent
> caches right now is quite difficult to follow.
> 
> Specifically, cached slab stat updates occur in consume() if there was
> enough charge cache to satisfy the new object. If that fails, whole
> pages are reserved, and slab stats are updated when the remainder of
> those pages, after subtracting the size of the new slab object, are
> put into the charge cache. This already juggles a delicate mix of the
> object size, the page charge size, and the remainder to put into the
> byte cache. Doing slab accounting in this path as well is fragile, and
> has recently caused a bug where the input parameters between the two
> caches were mixed up.
> 
> Refactor the consume() and refill() paths into unlocked and locked
> variants that only do charge caching. Then let the slab path manage
> its own lock section and open-code charging and accounting.
> 
> This makes the slab stat cache subordinate to the charge cache:
> __refill_obj_stock() is called first to prepare it;
> __account_obj_stock() follows to hitch a ride.
> 
> This results in a minor behavioral change: previously, a mismatching
> percpu stock would always be drained for the purpose of setting up
> slab account caching, even if there was no byte remainder to put into
> the charge cache. Now, the stock is left alone, and slab accounting
> takes the uncached path if there is a mismatch. This is exceedingly
> rare, and it was probably never worth draining the whole stock just to
> cache the slab stat update.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


