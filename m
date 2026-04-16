Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134CFF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 08:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771F16B0089; Thu, 16 Apr 2026 04:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749CA6B008A; Thu, 16 Apr 2026 04:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F8E6B008C; Thu, 16 Apr 2026 04:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56BA76B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:41:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E560C1A077E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:41:42 +0000 (UTC)
X-FDA: 84663775644.12.BC41AA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38C71C0008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:41:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8uzB6ao;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776328901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxYLJPMw/cHOX0IjxfgYAsQLDoqqt1giCCW4+4R3ndk=;
	b=y5pS3AKottBoEAtXs4NRHU3AqrtF63Jqcubkl8aNJKOnVWOlU4kmmbDwp3PUHZid+VWuWh
	qU0QtOJqC+coLyqzxX/Cy+osR3QpOEgIcheCwhKp9oZNfN6lBC8oBmhA6wgKK111Clupyx
	CHgogot/XuLGO5t5VUQf1BdhMDPAcPc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8uzB6ao;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776328901; a=rsa-sha256;
	cv=none;
	b=aMjA/EVyzG7udoxiw8TZqG6togd70A3gr6btf0YaWF+WbSLs3OC9YGRTt6VkXSWusAkV8W
	Tvq1dCU7E9vpI6BfkicucBrZ815q/fVwWmtnbwxU2ghbTagktRbFuQgZ8FRK8HLGxc6hoq
	avOH/XPykiH/qk+9TWrii1jvX5Hs30U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 89CA660127;
	Thu, 16 Apr 2026 08:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B90C2BCAF;
	Thu, 16 Apr 2026 08:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776328900;
	bh=c0z/MoObpI8cPfFzZtMALrrcSJEqfu6jvTeJkX5JR3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m8uzB6aontBX9myMaBQgETnsDXUxhNDVlPOYhtHR/Mt8YXc/baoadpkpS95McrUBZ
	 NeAMZKLon8H/OGIZ701tJ8HOhCe2u/FlReE+KS8mt6vb6ycVjN7LasfUYZzs2oYRnM
	 uiYNypO9OnVJhUT90uVDQ7xH1Hvgt84/WTTQfB6KITXH/uiC33mVUha/PLd0/weUHW
	 p6ZOkobE81TK21rC2lnoOXWmuBaiviENshN2v3tlwCMEwcxSUPVwdhXha6G5QcYdVU
	 kmoVRTUIRtDH89/syJOel/b8rgIkLlcCk7aluHi25oRpoJgq8e9+UJgG5MBlEjOa3/
	 nJUeVafxtdZ5g==
Message-ID: <d148375f-fe17-4f28-aec6-9732058fc3ab@kernel.org>
Date: Thu, 16 Apr 2026 10:41:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] selftests/mm: verify droppable mappings cannot be
 locked
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260416033939.49981-1-anthony.yznaga@oracle.com>
 <20260416033939.49981-3-anthony.yznaga@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260416033939.49981-3-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 38C71C0008
X-Stat-Signature: xffbaaqfwgp6g6bwk4869cdgnecqkcc4
X-Rspam-User: 
X-HE-Tag: 1776328901-114944
X-HE-Meta: U2FsdGVkX18ozyDu9LEj0JAlcvFcrfwt5obX+JRJm5Xni9Q5KWHNO3RJNjcnWGM6GmY/pm4xUgLvCSeRND7YulEVpA+BjSgAT56SvPL0PK7CdmwcWPiNMilJ02CdosocbWAomRFPDrYUXnGicMNLEoSk1FcXS1cdilLJ5YwqG5PIgYZu2Cx1GLuf20p0JH20xPfH3+/bn/FPhmhuol0e9qMK3426U4H2Rm2cj6YC9nBmB92tqcnAldSCdui+Ekv30tEVWDes7Ojv5eSS2MEOS7Cg8A+lpnwtiVJ8Tp9g1eHZ2ck5z8f4Cm7X79Lzf6WlX5a54DyfLhHv0NV8LGbbWKqEiFjqQeQORCOVWbXfuMOBEJPYw189ozR1Y+7KNj1qC3tXqxo9qrD5GJEggtybY5aSiCnbG9V+czenH9yw4tDHPVju2JEkasULYaO/9YRj5MKj4QGLsiFIAG/4YYKYavclBqFH9PqLeNHDnJRvqkFtXZknYC5ZVCcj1mMXDaTKV3bHsVk3b6JRxoD9PgethDstX7EXD1e6H7d+Bkhr2P7NwmI5HRVq8go7iIhW85edVnoO76HqocEKXhrDgDFImR2kdv+eK+J81bPQcaAaZ/MO+7FmoIkqNXqnJZs6ufEosk14oMF3uDa/DdfYTUYffcsJcO95V1K+2pgoaq13588DUePP42fq7dMx+3Zk2WOxDrvglK/2VbGKptDfuLGAgJadeK8pcxeWkE6/IvIYrgKXv+kxgW22kQQLSiZ8Mj1r9Q5qRvMXXArLFgPpDVazRkFx//VfSs7ZxWH/6Oa1i3G5P1FcEZydAyJsge+amPLNt8r4eAkEN+BV95laXtnAGIs1yc2Bx/oVQW/UR/KTRoQYKxIiVQ+6TmRkoLylIIoPithE5DZFyYXgUKOYvQikA/tFs3kUh+ZwJEnacLsM+6T3KnPIHeIyOrf75297BE+ZLDqxuiQSTjkI8qe8Iz/
 7cwMJZld
 Fs6f/cRzAAmcEBiWy2KRXHkKUH4BfLy2Ko3C5MB6rdlwvaBoGEUmWOH9KKVBg6OoBLA7LWAfQRAa6dCoEi6biXR1CCvBrZdwAHRukabu106yhcJS8EcPVj1NMrWLeMvvmWMPh9FyEVi2FNFLrrh4rqodm0goSJ5T6y4EcbIFD6kbmo2hoNsWe0M2Cnd409s1FLu3FF45X4ysEaMdm5ARijRtuifksP2gy7B/+MVqrikfS8XXRR0EUndrJeVolC9bBtVTYZZ03yRCaQod+Bcl/MaJkNNg9lm2fLKqeyC28Rlu2tsF4AazULB4rF8jlerj4IEuDQxc9HmkyNISMl/qBAYsWtbRnw4GqrPg0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 05:39, Anthony Yznaga wrote:
> For configs that support MAP_DROPPABLE verify that a mapping created
> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> be locked if it's created after mlockall(MCL_FUTURE).
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM, thanks!

-- 
Cheers,

David

