Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A89C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB296B0092; Fri, 18 Sep 2026 09:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9AB46B009D; Fri, 18 Sep 2026 09:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63126B009E; Fri, 18 Sep 2026 09:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72CD26B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:58:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08D29C0651
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:58:13 +0000 (UTC)
X-FDA: 85227037266.17.93ECA95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E5AF140007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:58:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZJPbnJm;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ckh4xj2dtrXQbGay03Qtd0eiSKV8uJqJ7zpVnkgIPA=;
	b=DBgi/wZ1TupYdwRFV8E3m1tDqopyId5V0vwBl8KY/WYiWGsStwyOfImyVl+ZCuN5jdqmN0
	f4dgK1xhe9A0OUKyHWLiEid7v5NDvcOp92WLOtFxGCWh7DMzTmrjFf5tRKDLJntkk5WQ7X
	Ba6y7w4Txp8IhQBtrzO9URsUyKAi7xg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739891;
	b=TZVhnUKss/MocK/zb8GY0x4dbw8Mkv2OQKSiyVzZqlxNvZbHArLCXT1hMca9V5XeY5fXFh
	YIgNLQv5meuYXMSGRVWjpaGdGjxWMZbOwbE0AkyVFI7NJbgSJkjEJTnMOy1Nj6k6qwORYF
	bD9Uul3yot1DiBQ1bKsH66i6mPWwTEA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZJPbnJm;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4898601EF;
	Fri, 18 Sep 2026 13:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9A11F000FF;
	Fri, 18 Sep 2026 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739890;
	bh=0ckh4xj2dtrXQbGay03Qtd0eiSKV8uJqJ7zpVnkgIPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PZJPbnJmAfhpO7Ga0JnK6KzeGeWKWKjs35aPU8TqVKym3tDfbrHObrcmottgr/1Wk
	 fgH5RfYipAgTJnqYgcT3H7iBBMICLhLQx4W3sN4nbZvP/jirAi+1BwgbaFgi9PfMii
	 7a7YamJDkaOiDNuvPvL0LNVzoMfMBcEfrYJbIlDirg2lA82tWCJ9RxeCYrF78Qegd5
	 oCMV5PgNctEx5UfyRRSkRpt7i5LeC1dmNk/XoXRMVNzHRouZ687pmToxH/bY/OndNq
	 wK268y6wXIGUTxLU1UuFcb+wHS2NnSnPzo+DrwjTqUGfoHv03fVfQwxhPnIpV9Flya
	 kmYLoKqglyu6g==
Message-ID: <989e3584-4008-4c5b-a49f-ed84b656ed14@kernel.org>
Date: Fri, 18 Sep 2026 15:57:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <41b46756-ed02-439c-ab72-e32a84fc7f17@kernel.org>
 <aq1A90ltg9Qn6pWZ@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq1A90ltg9Qn6pWZ@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3q7i7djnogq5tp3qa83zoit7ip4o1j9w
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E5AF140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789739891-250277
X-HE-Meta: U2FsdGVkX1/+nSBIqKWlkPFhDce6iosxyhypPzWXLJoUQvzgjFuC6PC3SyE3fPaWIY2ulpjmobRjWt3+Hs6FWduQ2FAcY4Hl7OS1sn5vnpuZznBY8aLnMGQTPttY1sCgXHM3X+E+EpVyqzJQrTH8G2Sg0+8FdZD1GDHZ6n9cKeR3pqostbdWy/N6gWWBjTh50M/eJKCnweU07OWZcFUOLtJWMs6ANETz5BmbNH/9ERwFmYHNZrX+bhkbUk6QIXv8Zt17xQNtjpV6HP5HRKR0CUsRjnTKB3eSB6k21d2SY+QcD5xjSHdjagTM+ibFweDA5kn3K6E/IIMvJjQNAKnQUR8CZTKEVNy05e/5asv7sTSRziWpuzi/UYhgBqcB3SEueIJ/HiWvOn99nJOQmZTDRH/K1qr7AcK19uMI1xFyr7MPUvwbXw3nCnkp8muz4kqjXfXgz09NuAN3HV0foxVfuOpZXC6EFa9zfp96981X7F46Y9enHiMv2RfNtFe0di0j26XCc+x3wU1f8r9m+m1TgXulV97lG58rNkqZ3P5Oy3iar8QVoU98bavIUfsPVpvzKQJ96lPOMU32sNI2JwVGKWHZ66K3FZ2zax2mf9r2J0hm8ijh2awx1vsyeohTJ+fXJMwvmHT0W4cdg/ix9vGhe1xA0lZAnoOmFkuDau8sIVZ+nJDb1IpwU/JFnQcbVwsCnpHDM0Nbm4ejvjZaaD8XyhpjxiJCIr6/Ou/YyKgk7V5nZYZa7eYNSZWaPi+BB8RkDa7S/77FsyP2Ki0BapHD4mAMQe5YqnOvVU8r7EfcZwZZiILsGKMevOv8t0Yqu4QMf56jn+t5tWTpnleuz3iheQwQ7P15qCuh2nkeaC3Z1ipRhlGOo+hr7GwL5Xjhfc1yryRWWWO1qAjVtgaxskWvWt3pbuqSeFttnyf8YEtdadk5tGWfXayI/X1Et2kiM4SkqtypVVPZCljSw4iei0q
 QSi/pwFa
 NXUq2A+/b/TKF7VT0CQx2YwR1T0IphrsH/DtBx9ZWOeKVHUf+6uofAe9lDCuPzlWWZwN77rNpqzePAzOA7kE17CIrXXSC2+eDmNPdzDCPf2CEg8Z9g0tg9m0/pa2+wMy4+HG9hNWSM8w3HVBdCpTwW5bjKT3MG6pXA9ugTvqUXvXKMHOf78ZwhA39DwQQcEv/kcsytwdvyTHwNsaGfUcLfohsq0plqGpCptcymz2gmZ7pwhO+rydruF3ZmIBE+dt5CamHIM6/pMUyMNQWqGLnC9NgFyrpVkqtYHyPy/8xY4NEDsfuyTsf5Zed0HEKSL505XDp+Xm9/SsuLW/Kdl0uikfKFUW3CuGT8Ovicex8E7yUMP7NWX02Zsx6URCK2yxhctAnmT20bGniNzQcdibNC59U2TNeRdwPR42yo85ti/kddcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 15:54, Gregory Price wrote:
> On Fri, Sep 18, 2026 at 02:53:40PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/11/26 02:18, Gregory Price wrote:
>>> From: "Gregory Price (Meta)" <gourry@gourry.net>
>>>
>>> NUMA balancing rejects shared copy-on-write folios and executable
>>> file folios mapped by multiple processes to avoid placement bouncing.
>>> These checks also block promotion from slow memory.
>>
>> Right. How to we know the direction of promotion vs. demotion, though?
>>
> 
> numa balancing never demotes.  It either:
> 
> 1) moves between sockets (nodes w/ N_CPU) (NORMAL)
>  or
> 2) moves from !top_tier to top_tier (TIERING)
> 
> Demotion is only enacted in reclaim / vmscan, and has no coupling with
> numa balancing.
> 

Valuable to briefly mention that here, and have some helper functions that make
this obvious (and maybe document it as well ;) ) :)


-- 
Cheers,

David

