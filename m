Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8743CD13C0F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B96776B0088; Mon, 26 Jan 2026 08:59:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43BD6B0089; Mon, 26 Jan 2026 08:59:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FFB6B008A; Mon, 26 Jan 2026 08:59:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 967936B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:59:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BA4EB9573
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:59:55 +0000 (UTC)
X-FDA: 84374273550.03.0D3468B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B9CDA0008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:59:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q7sbxvHC
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769435993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CA7ZM6arGeM7G5r4XYd+i+HkxrAcrO5ouJ48DYGWkxk=;
	b=wdlBOQ6lXCJVfe8vp1R0u40jNyU/NxxNziT+xzd668TCJMnAkNeQd+6MsKgB2G7QxQfRJX
	6979sExmDszvHo63csI4VYV4Nss2mLj85QlTss7KQ/boJ3m2iiQdxqUbkOV1VAFVfW9bXj
	dMgh3p5JaL+sIlLqCE+zYJAoxEypskA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Q7sbxvHC;
	spf=none (imf25.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769435993; a=rsa-sha256;
	cv=none;
	b=1j1kvgmEhl0TrbiwhyudpKVcYhJ2V9LySf5oNB8PYiu4eFWBzUva6dFW9A3asGJxoYNh29
	0QA2Aes3h+J+kh+KDrDcvPAHORbpdFSv6FWcAmGw8xq2sjEiU/bjE905VQ/IbrwjS6lNJW
	TQAL8Zhr9DEn85FZxJCLIdzAPUD/s5o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CA7ZM6arGeM7G5r4XYd+i+HkxrAcrO5ouJ48DYGWkxk=; b=Q7sbxvHCpdJlOA8+0uz3927nIV
	KNaaEpbu0uDEYOC7QS+Zsyy5x2BGTRKzrowzUL3FKnt5t/IUy9oI/eDR5hKyY71LyrAPNfoCM6Pi8
	4N+4PiyYyDXCiRBrYAZnlsG2H2PofaRBU1DaJiOdtIumZ6/XHerpclx/I9lBDhVhrcavjvUTglMGM
	Aa2ychCEXyVFuE1KrRmDjZgSzJC1T8VHtw8tHRGvVdgGHHCnPG3AWncsMuyJ+Dzz139qym9F7UrdT
	tX77nPTY9Tl6MFne75lIndVhuZjUdk03NffssHw7WyF2nJZbOyytPo1c2eJeozzpZKtOlfBbITWJv
	BYbM6vVA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkN7t-00GDx9-Lb; Mon, 26 Jan 2026 13:59:33 +0000
Date: Mon, 26 Jan 2026 05:59:28 -0800
From: Breno Leitao <leitao@debian.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Message-ID: <aXdzLk010qbTNbUh@gmail.com>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Stat-Signature: f5x4gz5nny8jkpkufuqwocbem9d6znjh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B9CDA0008
X-HE-Tag: 1769435993-527996
X-HE-Meta: U2FsdGVkX1+45X9nW2M4Z5XEDs5J33wExzobktmCHhcwG8ZfHKQZQ0na/bwvLwCY+63S5uEPOuh/g9VdsGj64X+8wVANdJr1nKJUtxtHXb5U02qDfhgxFf3jXA/9zEYL6UxNFF2LMw1dGDsuGGI/noIH99POSMhDcJrD2sAMjINWZE4fTYGqJgoVFJJpjMvmrwAzMqtGHpKRwRvDI1o580MScAZLgdEuCbHck8CY71fWoMQbRizlFGNUVMy0ZPMtMS8F/mN+tGminYpqVAAL2aaziOFK6WZBvwQDpKc8wN/yvpsPSKD3FsLbOxoPi825/AeNwdL2dkUqaXxkXJQfYTfp/ZhLi3ASbTTJzfY2zQXQn5/fK/huZQuwNOmxdbDhRVTTIvumVGiJXzyAcei37DSxrCvfGfiiFPhFAEnsMjBDfDn3wlaRZZw8v8MBn/SyR6g1wN5G+PJvKd+11QThpWAl+uDAEzspYRnPZjtAmNTNlOfgjr1lQ9TdVC0MmGPBRgRd9pr/5JGX68KFihVFzDqP/pVo9pN6KA/Kw2YU7LVv/i6S1FqZkRcbEuOP+bZ7yAyhRSCLEZACwvGgyce8RylNXJ5hbKh67ej48GRGI800vIThT8yDtHzDjeZL0JruidOB0+ria5iS8M0peMDIdAJEhEl51iXJZYssaYn0fQ3wXgUJ7EosSKMYrp9B8oREO20u5JbMND5k5KKiu4e0I+DG/RId2ECC/5mJIU1a4otYKayhyRx25W4B2uUEgbBLNOkEKNUYfPhs/z2yrHpQAIyv6+88ETFZoiUaVigbFc/zA5EBebmaiX8MPSOV8ypYcDuxWc3q1I/30D8n7pOK2LOixjcXOsG8H3vSEfTbSjUDSzxDcseqkDHkNWj/qeK3AUW/k0ENZP6o8Fxwv7Le7UqoOu0PU9H7NjzM39VCcemXIsuhc1QHsvXKmghxTI5cfhYDVfk8S/Iczy+vRfK
 xFzCYG+K
 Ji4EblrS9US+p/VhHD6Okml2sE8TW3ph0H3bdXx28KUjsA9qrvVWLSX3cJTtyOqVlp1A3rgpCo/Ewkjp96HI7lAD8zZoS6eDDrP2c99XOWKXjapq7ksqSBsTSZHiK1pO52OJKx0St+CbPDb5shOex06EGBS5LQPbbFESH6tDD8oYpfhsbnrMO/DJ+cLPVNcZvf8zWVm4TqeOSTyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:44AM +0100, Vlastimil Babka wrote:
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().
> 
> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
> 
> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> even for !CONFIG_SLAB_OBJ_EXT.
> 
> This limitation will be lifted for kmalloc caches after the necessary
> bootstrapping changes.
> 
> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
> recursion with kmemleak tracking (thanks to Breno Leitao).
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Tested-by: Breno Leitao <leitao@debian.org>

