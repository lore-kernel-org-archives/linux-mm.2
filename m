Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F22EBCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657C26B0096; Tue, 12 May 2026 03:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609196B0098; Tue, 12 May 2026 03:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8006B0099; Tue, 12 May 2026 03:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B28A6B0096
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:47:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D82551A03CC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:47:42 +0000 (UTC)
X-FDA: 84757988364.04.7982204
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2F06240004
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:47:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfH8aFKm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778572061; a=rsa-sha256;
	cv=none;
	b=1y/bqBnyvylT1QDiwLpBt+BKQe+oqpU/B2PgqdnAKwreY9s6BxEPA+et11mkHiyhceIUcq
	OBXfwI8HxpkivGZ+tVobdEELfWH62VlDXL1vEcpzMkS3IMTJe7SxYGyXQHMh1VqKnTPJzu
	A4vOdZzUzlc37sXMjJ1nBch8/Zu7JW0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KfH8aFKm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778572061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ntK6tjYBwRe/++/oh1AWSHRhzJGu/i+Tgo4xSvW+lU=;
	b=ggDW1eeADMjSEEngXh4490E5J7Em1MCsHYlnyJVkTPNW13zz0QGzYRBJGqrXnQ7GhGGxW8
	I/EkM8AqMHfb9SeMeA1FujK7RB7sNmY7Jqyd+PueV53GN+63uWv86057yCQnwrq+hu2hwC
	jX8P3RNID1hd1MDOOePYmY+77Sm2w6o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 995BA60055;
	Tue, 12 May 2026 07:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD3FC2BCB8;
	Tue, 12 May 2026 07:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778572060;
	bh=SqZ7JuR9aZYiSNIjFrM9/Owp7pj1r/N+r9S6ZbflLLs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KfH8aFKm9U4WSzucyrLYsh/QmdVCSVlPGKBRnnS5gmbsYLlAGMaD5dfTgD3OJJtxQ
	 SrIzwEEBr+JLyyxd6cSDlD+Yb/V6jguPm4vjh3hNlVrJERzxAZecZwXlFgBhjqUJCP
	 fq2iNIHqnKcOTKN5VVQRmdEg4FtJq83TkTTMR6iIq+GGGmP9JtcM/S47L81kQd4O+c
	 FrJe0I5Pk7GS7XZzb+SW1CGEpirOjbkeUCe5Z9qpO4HgSMGVCfKdLtdgax9fMGnFJV
	 DoJD8cUmo93tkso5BAxtd/wJxsVLSkUS/0pnLKkpOqh/VP6Y4F0c6r0o++ZwL6ExyH
	 HHTZm8Epupc7w==
Message-ID: <ae34ed69-f56f-4d19-8a2d-48f7ff671342@kernel.org>
Date: Tue, 12 May 2026 09:47:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
To: Michal Hocko <mhocko@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
 <agLai5lr0CQRZLBK@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agLai5lr0CQRZLBK@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wt5j13z96muxarnh61sfaqwxkuwzdt4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F06240004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778572061-142627
X-HE-Meta: U2FsdGVkX1/32U/zXbv+zHxHeE6X8ppi8ptgO0vgPQR45Qu+bGr40jPaJW2YuotmlpEClw08oPyJ6wVZXkmNog/pLvEoYRdZ/JoPlxB0Uh8hMDBJRVjCN5uJaRemjkp7JsRGD0eyQs+pgRZTS4647wMVXchcmp70ZEMtYruRymm1NSrOXg0Ip8eoeZdAomiH5FJyXfWspaxmKbUrO0QO4CNfW8/Lh7sCvd/1eMYsESmApXEnpYZqQq0wje5CQFdvZyvFimhB+3vUX9F7ZVGhTHOap+4Q04c/xbSooH25SG2qBWjfwZz0+GtZ4yXVcXkG1V+y7bBZJimz/6W3/85PZkHVGXQmGNnMdCDdM6tZlixdhWhG2eLgL1kCezVDJHiEg2t57VfBZti7tI3Ia14guOsEKpHEZya0xlitUIoQHo4UljwQ+eSzLv1srK90lIeE1ivQumQPU9gmfKZbu1jXGTAIzZ0HDZ6xFqJynUMBbn5TiRvjs7sEyGVPeS5s3dLYJhXGUpx9X1+nW0NkC5elKjvjVfnKgiqA4YCuOZ5r1ZTNATFRzX3AqdAZ78nhb8bw2dHIMF7Tgwn/F7hVYKUX0+LcUlmCaVQySqzAq1DtbHRbZBnDClUysrhG1JN0IGFX0e0AnxXTgMyYtrZvcWkYsSfgjHgPE5ZB69X3pUqeB1VOShfSG12EJCpe5f7AveGt59kr/DbVUIZzmZJRYLD2kfhzt3wLxxyN8TZI8lTI2DUdXmFYzqwBPg7+xt+EOT1m1EICuspj3mopT+DRRGdpK+m9R/Kkh9EJBB/EOSGrgMDpmg4s5hLdxnfPkSJ4z2fOuEvDrMrTt1Z6MBru+K+72wWnNcpExOv/U06/NjSnJUkZVpGqGsTE9v7dQtAlWB5tw1pT1Mzj3rNibTNpHMv2V1WSRuEEzEgW8SlQ0Ep1Rl7+ZkeUs34XEw02XpCXx9RTkllP7mQDWOO79TEu/oa
 DiAhUK9a
 2Lei/Z4jRsPImtvzTeGZwd3spM2z2Mr5z3s7gq4frejDYGlqapTkuHanhnOY6TKYNLEjQ0p3ARIZzs3LVfIf3ru7zkubakl6NSU+qXV292l+zLgHZak2nEuILnY/4sLh9EJ3A94X02t+35SA64MQkYFAhA17+ibraLsAmMYEZhAk8v+ofURBXUxToFs4cPOkJXU6jyGAYmBTlG4yr1ztb3ZfBf2nhP6rLxMnXw0krx5ndQ3sVVDQhv1pxWUWxSneis0DoOXzu/S8PEIH67Xl4MYmVuiZCwUlM208EjqdJ9FAiG1wNXWXeIJgWPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 09:45, Michal Hocko wrote:
> On Mon 11-05-26 16:05:33, David Hildenbrand wrote:
>> We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
>> remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").
>>
>> But it really was never used it besides for safety-checks ever since it was
>> introduced in commit 04753278769f ("memory hotplug: register section/node
>> id to free"), where we had the comment:
>>
>> 	5) The node information like pgdat has similar issues. But, this
>> 	   will be able to be solved too by this.
>> 	   (Not implemented yet, but, remembering node id in the pages.)
>>
>> Of course, that never happened, and we are not planning on freeing the
>> node data (pgdat/pglist_data), during memory hotunplug.
>>
>> So let's just stop marking the pgdat as NODE_INFO.
> 
> With the last user, shouldn't we simply drop NODE_INFO?

I'll drop the whole thing in part 2.

I actually had both parts together until I stumbled into the vmmemmap x86
freeing issue that now causes conflicts until upstream and synced to the MM tree.

-- 
Cheers,

David

