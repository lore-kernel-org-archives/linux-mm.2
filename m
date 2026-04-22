Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D78FA1FE7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E26B6B0088; Wed, 22 Apr 2026 15:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093996B008A; Wed, 22 Apr 2026 15:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC066B008C; Wed, 22 Apr 2026 15:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCD166B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:08:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57A9D1201B2
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:08:52 +0000 (UTC)
X-FDA: 84687128904.10.4AAD81B
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 837FE2000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:08:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g90sh4F6;
	spf=pass (imf03.hostedemail.com: domain of 3wBzpaQcKCPMkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3wBzpaQcKCPMkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776884930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVMtEztbiTd0hbm+E9Z2wpGXbkqaSZ9UDyzAJLuzfu8=;
	b=XzX2aQtQMvDQnMDEuHpBhUjVVrE3lu5MkQ7EA4D7EolOiExtm5wzs9B8jcIg5rswrrZjWz
	Vi94T17LQMTfvfxB0DRZIscZjjI7eWYvZq8MVrKDcqXeZpbysHAlIZ3LveDbHRWeUIU8Zy
	eWsRJSRTt7Mx4Yb/zN+BnbAZ8NWqRy8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g90sh4F6;
	spf=pass (imf03.hostedemail.com: domain of 3wBzpaQcKCPMkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3wBzpaQcKCPMkmVohVgbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776884930; a=rsa-sha256;
	cv=none;
	b=z6wQDsF+cNLuZVgMON3LtcrIXv4h7coi+ewra3t/Fjlan9wDq8AXF3Da57MhbfZV8WwG7z
	ObHitdxNrcb3yPRRKLtx/FKFD5g38vqgTB8jpHg2cecACN1ypuNMRNQYJICor93GrvCCdu
	ShFfn8ASqmJLe2fXvuxlkD1qtuJbv5s=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2d93379001eso8672850eec.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776884929; x=1777489729; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cVMtEztbiTd0hbm+E9Z2wpGXbkqaSZ9UDyzAJLuzfu8=;
        b=g90sh4F6NKJ9JIo36psTWH48C2QcYP+FLrG/WjprGPSYQTiiBMaHYvc6rvXNsc8yRi
         vF0EIm4AV/xlM5bRTpEje1g4XubWN8FmTFnbZ2tXpRELPt65pE3hvZv5FU/A+GRetome
         GeEVbXUD8KyhwER50C38QWQvgFO8XMnfrBttlrWWaK0lTC31Xtp6iFqoTHuYoZQJnjOZ
         14saFzBlhNtvpc4ONd2gJwE7ca9eDacBpfoLUclJsfRRz5McJ+LVcZHKGXFmYS+SgLvg
         PHSHuwZmYDyQZvKSkQGyx0lzpb7h2OSB7GeDPmFtkNsBr8H1Dcxt7MSNBBACl+SzRbxC
         U8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776884929; x=1777489729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVMtEztbiTd0hbm+E9Z2wpGXbkqaSZ9UDyzAJLuzfu8=;
        b=CwImnaM251GXQrijywwcW22fsrMlNkUAJC5Mrfh3TbXNdtOsLi8WoA9IVcIHtPXupM
         6/FnehHRdSoHaPna94ieM8vTkRvdaasiMXO+VApWR+391IYjIxgZLUcQKYKwB167GBA0
         qnOrJ78/KQGa1Rt0Alq1XVy/YkyPUMZ09/JwiuqVid1jXwk0hHhYUuNezWySkPVUdy8R
         x+AtvHgVXsbHe0VCOzOIPLCRoAL6kY+X6NHIwBeyJ2T57o2Kl98Hc6y7mW3ZXEpBHiey
         jch1U2g+XnVbQ7THLFwaFZD7/XlQUJH9hPKTyScLUyCphHYZQJtP7gzmd1Q8JVzeon8p
         U8Pw==
X-Forwarded-Encrypted: i=1; AFNElJ/6va71hradnMInlRllAb8p499wobk2K/A0Nfzp7UWiCH880JXNw7M9Vb63ulFix/gEEZO++7OQgQ==@kvack.org
X-Gm-Message-State: AOJu0YzllpfTTXWaonRTBTWJ1Cm+Bs4KdcxhEbcvobSp0DRQ+9ZkxyPK
	IFnXXKhtHfzh8SY/G58p4uIr49Xv/hqGI3NGB1uJ/NfAlcAwufrxALM58U/SVZNdSb6wikOAEfM
	/IxVhpl7S8A==
X-Received: from dyhd3.prod.google.com ([2002:a05:7300:8283:b0:2e2:b79e:ed06])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:2b04:b0:2be:6f30:f2f9
 with SMTP id 5a478bee46e88-2e479215120mr13595652eec.26.1776884928695; Wed, 22
 Apr 2026 12:08:48 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:08:47 +0000
In-Reply-To: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
Mime-Version: 1.0
References: <03a23a7a-58fe-42f4-a294-9d688ce33e2d@kernel.org>
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260422190847.216343-1-pratmal@google.com>
Subject: Re: [RFC PATCH] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: david@kernel.org
Cc: akpm@linux-foundation.org, shuah@kernel.org, yosryahmed@google.com, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: cwphwa8jp9kpupcsg6kmuo8n9jnn5dy3
X-Rspamd-Queue-Id: 837FE2000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776884930-439559
X-HE-Meta: U2FsdGVkX18mEzPoHARu+Jtf8vDrKXOJfBR5+T2B9Ru698TM4cv4Gm3w0yp8YWdyfd1Yw8oGPxLk14WIarOnkq1obrMi9jsXC5g4dQpd0Q7OhUI8HUc4TswyLjdkNYFFFi+VHCkp+mdMaIqbFSRcXikGmfNrt/qHVOTUyvLQR+/rlCIDU48syWMRSvUlEPsSi3qC/9qhrGPzw/Os4rO2Dsh+1oeXSCOs/Z/IQKvyc2Vs6YdJ8CmigD7/GrWgtTMzI4WiVdb9SYzNynhv4p/+GhuTPpxIM3Y7mlcQUioq4gUxkxPNq8uLxRRELK1XPGtFfsrZIA7xGIR0gEPjh7D2GzWQlbHvDr/W4jIY3aTFr6ko/Wbn4V/QV6X+Zp5B7NlXSm2EhzkNmbXfhoUf2YZsbEiyKj9t50w9odbxJIiKYYFVbwU02uvZpEbJCabG8x1jUqPF1YoKHp71W++FzkKXr+5X8rksdfbnLaej6+9CDYb2fEWsrl8rEiJMTdkDjsAB8NoWzbgXwpYjj1XiolnTrpnf0fOXjKjHto3udJfZsGtpiIwF8gu4DyddPvnG91irHCjYx80S5l+3cAFPqBqcTA9J5dGT2bMoOwJWc+XBIFTV3uk7G5y/pty0Ej1u4jhkGVbF8nT4ljejTqvM0EE5qzSeJa4lMXnIKKd54HG0YB3PWvKle/cN4OB9VBOeUiusysP03N2fkbwP7/wirvI99hUwP45a2URW+0P0oOMFKs6NSmdtd/Riwu1ZHCK9FGyN9RV0ki2pTeyKXmwcnWw0g7vrf1cXQrOA//zIWWxJhtiHPPO10GvR2JmTmt74/7l8s/4Oe/pmfjA1bwyrtZhnKbc1hCtjy9OOvbCYiELp7RBXX1au1+0qSYzbhCqk/iVt/wheMzV56V05S0uhE9vj40vfePG0Ti+5JOysxlecZ3tvkonkIGo8w1tejZOKbmHka+dwAn7qfRj1eWmjrDb
 Zgs4P4WL
 mUbNvwouyV/s8KR4Z/86mvGAaD6XrbBwEYQYFDz2haNAV7mpUGIAo1W9mP7dhyx9X1AS2NqR/qdT0ykdpesGvyulk3iPTN1femk7aweJsBR7mklVSxs1erHF963Me8C/9Qcr0KVPXlHJCE2RERkxFKdidPeLJcJT5W7hpgzG0J5dPxlYVEdtJtlHJBeOzBEb/4e9gginz9scNTRfLDm655A6fz61jTAwtn0i8oXFrtTj2yJQ/HSerxR+2cXmj6CJs26mLgVDWVzhsMGPdAetS8G1lXd1V/NK4Mh2gKyZ7JzZNG5I5fWvR7kYXXZZQfqkbufwd2ezlsRvHoBFyWPw4BaBOfTWckwhv5IiQnW3tF7l5PLhMMTGdkyKhSd4ADVJyxwxIVdcVn10Pd8os5ANN8Udz5WVSurwkEAfTLDLXe5XwYgpbCYk7HWrSaupGAtTnfOl8yn8CbWhooU6fN8NhHN1OkrpLzzuK6PdrdxejzxayrHWmPtzzZ5E9nEFI02mtQJQWibo2LRn2oA4sz8EhSCjO9jE6ZP0p2W+u7QFdtIusqve+i/9HA4XknRwnpKylPqdrwdXHwDtMQmhOHg7dhOEj+lqGpm2y9p/sju3BGexkeQ7aplS0jx8sxUHRl16eX/M0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Resending to correct David's email address. Apologies for the noise!)

On 4/22/26 18:04, David Hildenbrand (Arm) wrote:
> On 4/21/26 20:30, pratmal@google.com wrote:
>> From: Pratyush Mallick <pratmal@google.com>
>> 
>> The current .gitignore hardcodes each generated test binary by name,
>> requiring updates every time a new test is added.
>> 
>> Switch to the patten-matching approach similar to KVM:selftests.
>> Ignore everything by default and then allow source extensions (.c, .h, .sh)
>> and tracked non-source files.
> That looks pretty nice. Any reason for the RFC? (iow, are you unsure about some
> side-effects?)

Exactly that. I verified that the build works fine, however I sent it 
as an RFC just to be cautious. I wanted to get some feedback in case this 
might introduce some unwanted behavior that I'm not aware of. :)

Thanks,
Pratyush

