Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F3C606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 18:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M1HivhvE
Received: by kanga.kvack.org (Postfix)
	id 100FE6B067B; Thu, 19 Nov 2026 13:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7BA6B068C; Thu, 19 Nov 2026 13:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FED6B0699; Thu, 19 Nov 2026 13:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35FE6B067B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:32:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 527A4140B9C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:32:59 +0000 (UTC)
X-FDA: 85452715278.24.534D94D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6A4640034
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:32:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1HivhvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795113177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHUpe68o0Gyuu9bj/dGXGOLZdSYedum7yw58Zv5M3uA=;
	b=pOb6AepUZmGWtEcXSOuwaiuN15GpiOHEd2azIdnGx8lrUvKGsmXVd7biUe5RDm/Ys56uz4
	NhhGC+13O168Azn9G7C33mFNMPbfuxH0uhle39ND+2es3+VhyvKV3Exw5Er/QdjrbkbsFW
	YiwtKiu1ZmB0PUrai78er8uvYi46LVA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1HivhvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795113177;
	b=GfMkUgxJFJpPqUVHePFteC8AZngqdjfZSCeWz7H8RTzjWi+sstQIndPfK33dSDpbSPsHQH
	OgQMMphKw5R00/JOyPbSAOgwna3ToGZyBJeJjIA5s4FDU94yG3obUt02GhK4+F8TGxdl9A
	OEBJzf+G0Ess/zkRYGdRbgpy86JIJQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C361612CB;
	Thu, 19 Nov 2026 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B8B1F000C4;
	Thu, 19 Nov 2026 18:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795113176;
	bh=eHUpe68o0Gyuu9bj/dGXGOLZdSYedum7yw58Zv5M3uA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=M1HivhvEpmZhxvpmc6r4vY/xkVZfSRaCfhSFVKHd/NQDka6qnq0Fp9Kvm+5I3xtSH
	 dbjOov2+k/DqmIL/4QGh/tM9Kbj/yRQqtitg6TO4IgomsOdmXo+1qfYJ7fX41Mtmdk
	 Ru4RaHbHdV8/FDguWGdnmCmot6FKWZS/SqWbYdQ+ZxiQ0niM9MaksfAW9mVYmMFTlx
	 xfiL4oTqokVgXiatdDe4PHjbngJ1xHt3PKYntRv+VX8gi5OYskfFDabFoJ5PvjITkt
	 BWwdwFeLrVLpeJDssQC1Fm+tO5xkvNPOJEYOS67LYR7XWVHzGp1bcnXF9XrMuRa5Vj
	 prGC4UZqIlxFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: sashiko-bot@kernel.org
Cc: "David Matlack" <dmatlack@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  sashiko-reviews@lists.linux.dev,  "Alexander Graf"
 <graf@amazon.com>,  "Andrew Morton" <akpm@linux-foundation.org>,  "Baolin
 Wang" <baolin.wang@linux.alibaba.com>,  "Christian Brauner"
 <brauner@kernel.org>,  "David Hildenbrand" <david@kernel.org>,  "Hugh
 Dickins" <hughd@google.com>,  "Jonathan Corbet" <corbet@lwn.net>,  "Liam
 R. Howlett" <liam@infradead.org>,  "Lorenzo Stoakes" <ljs@kernel.org>,
  "Michal Hocko" <mhocko@suse.com>,  "Mike Rapoport" <rppt@kernel.org>,
  "Pasha Tatashin" <pasha.tatashin@soleen.com>,  "Pratyush Yadav"
 <pratyush@kernel.org>,  "Randy Dunlap" <rdunlap@infradead.org>,
  "Samiullah Khawaja" <skhawaja@google.com>,  "Shuah Khan"
 <skhan@linuxfoundation.org>,  "Suren Baghdasaryan" <surenb@google.com>,
  "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v4 02/19] liveupdate: Pass user argument to file
 preserve and retrieve
In-Reply-To: <sashiko-outbox-209934@kernel.org> (sashiko-bot@kernel.org's
	message of "Thu, 12 Nov 2026 00:31:05 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-3-dmatlack@google.com>
	<sashiko-outbox-209934@kernel.org>
Date: Thu, 19 Nov 2026 18:32:50 +0000
Message-ID: <2vxzqzgg3c4t.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: qr8d5mns77qhwdee175muq1j6icphc3n
X-Rspamd-Queue-Id: B6A4640034
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795113177-168901
X-HE-Meta: U2FsdGVkX1//TUKYUI1BhMrCUm7HFjkciGDCZACFBWI6bb6vuaf7Yk5yLcK9LKzOcPUPVwWV/JtWxuwTL30dAZZItssybB7Dn0tilbE4KRKSWS4qrfC/wysh07pJcfi13mVyxgoH8OYcsv4N88N0pPrx/BF+V0qo7/uevUla2BT9MOscUAzn6VTbXgyFB7c5xZuUCfJYjKzmiWukRiQbX1cAmfp9VBFKrx2soIrdj/CNAhRutfAtwpqhktu7JecrSO+NMOAw+sKeS9QO1kyVutt7JnFHKhwLLmt13fqFWUCbsUNwGfeHyx4GlZlejtQ/G5QdN4EHBEE0owfk2mlS902bo66zb7DyKsw35WwUtT+AIqxD5jSpCXRADWLlvLZVnqF6S0yjvq2EQgI5Jsc8qcMIy1NnsX5qkxgpp+DV0FYVEL1b29tIXeyy3bxq11B+C/FLvJsUEyQiDnccVbgknoLxILB152zGXbwrBUDTbTdFnXAUMme+3m8WXPMvlTGwuIg7iVewNhnC95VbSz4SFX0W8uaqshyG/sl0stFlwOhHz6sB5W5rlR1kc+RPG8tdz8BoBuJlwppCK24x2RdN18Iu2bSgwRX5MYhpuIiPuRAd4q69bz+dfagKLALMBd7+/1ENZwMOFn9zl7TKIu4zKsAMP6yKMlQrvnEKceyFZrjLO7PdgKpxi05Tx+QG/bes/U54t73yRymFsx0P9zyiD/JZkhZdVTCe7w1KZXxW0YMGLmEQBg745IOc0kwMyck5VHWrHoTw3kvRFQ+Vu4zTcXFlCDoZhWD494SsKU1tzNTXa8GPEDydSwdn6xDZN+1X7XD5DxWw/GPV+E8/VGqrax8uFaGVyKuAAfWDjE3o5JySeOT1DI2EfOadOzE1zZNg7TDHYRdOJT8JmeHzi+Nw0Dbu+PKXV2fMx51H7kOR12f1FqqXnjmXpSg+vYynDyNNmORDu1qHV8XAT69QjBd
 FMB5gC5K
 5UceaTKJo0D+Hmuj46b621MRcPNqF3F/oP5/GaYJSq6v75knLWL8n/H8X5Ep+IzCBLE7QIWppSD+xTCtsUjnQZ2nGYdpK2cCDGN3zkeg7FCxXHbyOLKXgRd4EQX8APTYDxE8GgFj+NePBIJ+021u+Er753um3fyZKy4No1q7vxR6zbTVciJpr1r1QJ/7bIdPNQDchzMj1MzLESiid97+15+mkAScvISoijHMjom8OqBf6xOjquCgUkYfbMUIO7fsmkJ8x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12 2026, sashiko-bot@kernel.org wrote:
[...]
>
>> @@ -995,6 +1052,6 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
>>  				 struct file **filep)
>>  {
>>  	return luo_retrieve_file(luo_file_set_from_session_locked(s),
>> -				 token, filep);
>> +				 token, 0, filep);
>>  }
>>  EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
>
> [Severity: Low]
> Should this pass NULL instead of 0 for the const void __user *arg
> parameter to avoid a Sparse -Wnon-pointer-null warning?

Sashiko has a point.

With this fixed,

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

