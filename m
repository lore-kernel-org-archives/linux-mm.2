Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1719C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 05:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E44E6B00D9; Thu, 22 Jan 2026 00:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C62D6B00DB; Thu, 22 Jan 2026 00:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F348E6B00DC; Thu, 22 Jan 2026 00:02:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0C446B00D9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 00:02:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F543D18D9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:02:03 +0000 (UTC)
X-FDA: 84358402926.04.03BD57E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id D040BA000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:02:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQl8IV6O;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769058122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nesrHAnPEf109FX2/lCNqfl81JEqewLyfAPoUShZzXI=;
	b=cXo2IaTws4SfMjmVmGmZAnGLFAtqYuadMSGQIU43hIFSJYYKl8ybFyB8sqLe1EuqKwi+Yj
	ch1z9YryjD2mpUxoGYDjTku89RBtyvpB1yFmHFhuvx/yxp1Cg/ctdJfxC9bKGLmZ2Flm/q
	dN5YAczK+62WcH2aYo2YVDZNN3Cwq34=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qQl8IV6O;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769058122; a=rsa-sha256;
	cv=none;
	b=lLn7q3YiP0m7zwJys/+pV0QgG1QjCmLmHLGc9V5D10Ff4Osd3+4dj6AMlOm2is2cxFcVNE
	abpC4vWFpjVYilkGoqNWqRdY2rVU28kQMnLYNRnl0Y7si2axpBtOKnHLnOwZQpj5YPYOb7
	raXRANnbet53nZ/0qTq4mMNGKwqg9hs=
Date: Thu, 22 Jan 2026 13:01:48 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769058119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nesrHAnPEf109FX2/lCNqfl81JEqewLyfAPoUShZzXI=;
	b=qQl8IV6Oqoiu08opgd6gb71Xe1wVWqUbTnUDjm2fWGwarbwE/LQdD4fuFjLZ4Ep1NzwQma
	6uncJSiZ4ciNdkQddvpFierFWn3e0sMK/3Ga0FpYIViZUkj2BXJG7PtHPZo3sdioIXCjbl
	nDLG+Wm6HNOClrZ3kX+BTk3K7a/2w9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 19/21] slab: remove frozen slab checks from
 __slab_free()
Message-ID: <7syrsyflw6ii223mwyvnwz5pu7chlh5ddmblyq7izmgvtv4xt5@pl6osos5rpy7>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5jnd35zizebq8henoy97un51btkdhi6n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D040BA000A
X-HE-Tag: 1769058121-518000
X-HE-Meta: U2FsdGVkX1/W9qx+IZODUkx8A9splelSd4G6wB3fgfOlSj6DlUUnOU9CFECzJv7O6FwS7InbcGkjRMd2AXdhvJxp4eZO5lOD1IR80vWOM4UUipAz+EFDN3R0yFD6XdKq6jgIXHhZ4sveBflVHkrThaEP6aTRW1sFOppuTLWMWGMLDhmZYmqlqzzkRyUJe/3GwTj7XMs7RVaugYwbgPb4PAeUOh5O7ARs/NNrhxFj4/xUUfwgGFtODBRp5NUdtGUFHIEw50h9/rJxzi4aafvJNXsycf1n5CR51pHH164N4oYYz4AIb7Es/0hoUQ2FjNb+WM6CqlAYi1mNB3gLUmkpP9mzAa93CXdqCbIeJ4f59H64i0pTOixzGwB4gLixWoWyP7V31eSripIp9Agw/P5OPgM1aF176tYMGOUjAhgflVaqc6TdvByn1+3h9ylZkTMf5XAlCEhH0YrS6dC171CHrbdx9T0ujtp6OnmKgt50nDOEiODBlVIMxULlFxMe8Pw+EYKjC9pM5YoNm6AO5CBiF1XH8Wm5ssedKFYAsc10RgZOifR3nD8fHC/zaLmgA7lzw4q7kK/vFUyF4+Wn8TPuHpL5/kOB7m/twJxR0vQT+xGx+ybKwDry7vIX7HCgp+8k1egg5aOXMtI0cg0Sl4+ZXtF8vezjTOAzTOmkiYNpB1ZhINxtF8OqMhw9MNz7oJR9c7QdB1It3g2Fl+sDYnGA4zxaNxwbiVY6Q97fUNuF+kTctHf1n6oZacSWIo2AYWiVXBory417udpurkRcnEeWS7QCCvQeNMaNLOyXrpY0y1o9QnPUa24RRxtuuqqDd6AFrhy1rTbmijC+0gQWkG8/aUrxZov8A29t22zwDodThECaCkiXht/zNgI4rYxk2LOw+vhlQlDFIU9Fryka8goJziMyTPqucx0JeHhIFvCN79lcU+swvV+xNoVDL240mQYiY4xG2fQ3feKDMCgwle1
 yUgyU0GR
 RXq4qPiZYdYZYjsII0XsXDQgeyt8InGnE0yynn7WmsMT9eqV3DmF7QjzdTy7r4H0+Zv/jjF0GoWtAYsoHY7n3aMz9rwPhWDrJeoOVYgTrHRTr6noy+WwcUsiCmYejG6wPuu4VCSi9wNQCVwC1M/7hbkqxxct8yfm9i8sdKr7On186QFNIK6NcLGiaFrhCacMzIDA3Wzezs337KI/t4Tzs7SQn6rNHrgViGwRQ1PrGRuHB08k9JcfdOw9GEJjru+qHMsyEqNfBxDRT+lbu+MYTiFhekg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:39PM +0100, Vlastimil Babka wrote:
> Currently slabs are only frozen after consistency checks failed. This
> can happen only in caches with debugging enabled, and those use
> free_to_partial_list() for freeing. The non-debug operation of
> __slab_free() can thus stop considering the frozen field, and we can
> remove the FREE_FROZEN stat.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 22 ++++------------------
>  1 file changed, 4 insertions(+), 18 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

