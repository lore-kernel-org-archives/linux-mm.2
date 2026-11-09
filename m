Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99BC0606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N4PYsCmc
Received: by kanga.kvack.org (Postfix)
	id AF1E56B05EA; Mon,  9 Nov 2026 13:41:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9546B05EB; Mon,  9 Nov 2026 13:41:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06986B05EE; Mon,  9 Nov 2026 13:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFE96B05EA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:41:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B71380774
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:41:46 +0000 (UTC)
X-FDA: 85416449412.29.416F96D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 526E480005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:41:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N4PYsCmc;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KyvQTJzcbmQ4aop4C/wDl32TQvem89RduDDh7rd0ck=;
	b=Z5oPMbMHv6C6yakPwwYunSwS75OVADTRDmoeIB+jG/gH8VmX/yrLs39m0rzvKySgVMCU7u
	+/H2nYKa6jjLcnP6Hce2IQT4ACmVaj5FjTW3TefoPID4VOKZnUzHZrLYwdUN3pqqmoTwSz
	IRfBalD84YOZs1KfZvM0sYv5vmTDZ3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249704;
	b=itpgIuTftFtloxgFIBrGkcg0cpJqon5qMFTttC1M5ibPK9+gQ0WB8o7w9d8eb6xuJTx7o0
	qvL4HHorsPVKOaLa5j+WG6KuNBs2X2hX8NZNz8bdPurQukK33wwWswltO/hgcrTX29ptg3
	72+ArDH4U5qd25si3eppNKcD+mFWIrw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N4PYsCmc;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D66F8613FA;
	Mon,  9 Nov 2026 18:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18A21F0089F;
	Mon,  9 Nov 2026 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794249703;
	bh=6KyvQTJzcbmQ4aop4C/wDl32TQvem89RduDDh7rd0ck=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N4PYsCmcNhGd6lqTYimK+5S1xKYGvYtlUt01h5elvR/s1my1PY61eJeEVmWmH+83f
	 R4grjYJTiZGg5iiOfmVqGVHBUF9OxSVoIVRLUP6/ks0u0FUZKr5qaUmteL9BfNZRCC
	 hfFlIoWRamc89vgFsyQRq2qhb8xYkOcYfFfhwfrk=
Date: Mon, 9 Nov 2026 10:41:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Qi
 Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Muchun
 Song <muchun.song@linux.dev>, Lance Yang <lance.yang@linux.dev>, Ridong
 Chen <ridong.chen@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
Message-Id: <20261109104142.c4e01c2e29ee9ead4056f354@linux-foundation.org>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
	<20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qucymq45jj1cu7tj96es4131oeaog7mz
X-Rspamd-Queue-Id: 526E480005
X-Rspam-User: 
X-HE-Tag: 1794249704-117054
X-HE-Meta: U2FsdGVkX1+402kolWI0RQNJx9jnmXGX8E4/r8HGyhI64xmJgdXHkTS/It+FVBNWiC0sSEyBSL4+DMgCk8CjKaomYwSaJnIzlkiq8g+e2/tJoilakkRAOTCCTiQHP/gBl8XclhoeFNVJMpUXGohFwXyqmtO/q4/Y9OJ2787TldeHHMC0BabB7QTcvUVaktN7996kaqUWoYS8mIcYnhte96BH9xfy8zdI+hH9Gwx9uwO0/XtbdHYKfHVnp2t9vaXPSOeYzZFgxO6ao9zpVp3rLai7cy3pEZCwO158PYI2acn5TC1DIore8WOzHwkIYx7RpIGtp24+GL6l++40Qp54lsXMJsS9byRSY6KnieyR8P9d58MFOwBja6QxjHEyoYMofPZBuOIVovWayd/HUoa8bx7lbzikfxgQ2ymms47kFOOMoah3k0vDOi3qC/Y3K+mj1N0fEemBU/2meaVp44+nio05zQf9Vplo6T0AFAraKMXHqnrqDepOtauevxOzlJ9DN3WhQRB2MT2Ef2py8SI8exn8B66KlxxbMp2WlHS0XKaaEQCsBlSkxK0iZJwJR4FHDYgMvZoTEin3S7K256TVpw3ozYu/BmmpziSWI6hsy26czsZavPdNwy2P7PXWaSu/H6wzQ+RR+qFBYEFZCfBP0Gn8rvpwlLledDK54ZXbC/yVbkWgkLYZkQjAQ9wN4qah9JedNXG8TW+JyqFX40RG59RebswiTfeoUfEC+ZpOgB+LP90sBAVua2ynFgz/g9bH4mAAIR6JZNBRC+7VoZWQgm9FE69Yyc16NnJSGPkY3pYX5pgxjuPjvI73aDg1YIquBfmnhulyVY3B7Q3ymhU6UBn/qI8XbOFb0+O5nk+nAnVe1c+B4057Nyatw78whL7oqpqmp8I8Xh4lj08X4LLV2a6W+gBpVbq/43v0D4uvqYYIFVaz+c+6BI3jYULiLmR/8qCcXpNEPYDdgECp7EI
 JUIjgMcW
 mPVdljm4DYZU4U3Ordr5SAir3rC7mFjn1hSYjpFhPzgTXD+GbqQTGZyI2ich4w9pVYnvOmvS9i/JUh1+JqYRicgtwxCD/WOINy9Yim4biDCVWO9sXRJ5Qa1KeUyjYiAZ83pUjqjFrbHn3GuI8BQzUDf6TnoekiYgg5bzhITJw9Jq7G3lvRi/Aj8LTDuwZ4i6qlOWRrtypvmS/EvOWl1XEJeMyI10rHj1q/u3O8fInBT1u3i6XyJjh9u12m+SyBjB9svBUvXkuRmCFxubNoPMd97JAjo3pa7wF9EXqfApHNIIcakaVy+qTBeJyaJG71qInCCpk/CfwL84gnabi+7Dg2sHdsrnsDGo+9dlUeGSN6kmEWhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 19:31:53 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
> 

Yay, thanks guys.  It's been wonderful to see the rebirth of MGLRU over
the past ~year.

When do we get to remove the legacy LRU???

> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
>  
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Kairui Song <kasong@tencent.com>
> +M:	Kairui Song <kasong@tencent.com>
> +R:	Barry Song <baohua@kernel.org>

Totally-Acked-by:me.



