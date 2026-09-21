Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32C6C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78E26B00CC; Mon, 21 Sep 2026 10:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B51876B00CD; Mon, 21 Sep 2026 10:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E216B00CF; Mon, 21 Sep 2026 10:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89B706B00CC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:15:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EC69A4818
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:15:43 +0000 (UTC)
X-FDA: 85237967766.29.FB4279D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A95640012
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:15:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cA1iFqdu;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790000141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCfJQWWrymkpBCCuzcDQp38cBUvHqaHF57c7ldLBjfY=;
	b=RYmV5JKLovguyPYjAR4/Mo+1qZl5Lf78L6rGFjQ38Gz58BkQUDJZFwKN4hWMXdAFwleZC9
	VdQa74llPCwwiinUJc+0dgGRv76GMNq89FjQwwy9nEO7rbNz1nfuIUESM8EL22t1yLsq9I
	zrkSG+wov9hiQ/KuGGEn6z66WTIKjuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790000141;
	b=5k615rI4v7cUSLFqBvfVjuLwxBoinlwcTsry/2a4Tl18dYr9kYMCb1anAN7ZNQYGn34Niz
	3LdWrg7kZOwEFlXLBQl5hCi5ybHs06k4DYt3Fs/OD72ZoZbDoSCX7f4r3A6ZtS1OQwalz7
	eCX8IJ18durYMNW1qheEYaQZ8Xg8BhU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cA1iFqdu;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000140;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xCfJQWWrymkpBCCuzcDQp38cBUvHqaHF57c7ldLBjfY=;
	b=cA1iFqduum70HVWlKNEmmGUvZzsj9jkrj8pEdga3YgYjBbGdIMr60XC/Qu23J7eiT2kN5X
	Wlca7JiRx5sSdkjgwlgKRelnU+BdM9C0te1MH9QQsMSi6g66GYL+TqyGoMkVOX0MsSKf7D
	HozX9pyY2cpgFJPoVpqL+4mfkkyk80Y=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-nnOlowmtPSWcbtsMAlShDA-1; Mon,
 21 Sep 2026 10:15:36 -0400
X-MC-Unique: nnOlowmtPSWcbtsMAlShDA-1
X-Mimecast-MFC-AGG-ID: nnOlowmtPSWcbtsMAlShDA_1790000133
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C60D180061E;
	Mon, 21 Sep 2026 14:15:33 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1FB2A180034F;
	Mon, 21 Sep 2026 14:15:29 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 16:15:33 +0200 (CEST)
Date: Mon, 21 Sep 2026 16:15:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v3 13/17] fork: move the coredump and exec checks into
 create_io_thread()
Message-ID: <arE8AJIB6UeDUV8n@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-13-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Y3c9WoN9e-v2ka2xVJjl3THK8TymQUCi41iBUvDbl1U_1790000133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A95640012
X-Stat-Signature: yjkq6yr83q6haerw6mwy3z8b8n5tq9i8
X-Rspam-User: 
X-HE-Tag: 1790000140-94474
X-HE-Meta: U2FsdGVkX1/4QyexY3eoMV6KkfQuj5Awt7CMeKBxXkHaHSAcXbRy2W1OuAlAdTFgVzBrQcPBuS3CUNhLt4M1Ff8Wfs3z0p3sFkWbqFJTBnqcsl7X8tvi7g6vYkcDCN4NUKJREHP9d4rXMzsb97Kku2PR28w5D1mhzwYRf0+80GHe002ncd60KlfIrFkkCeTDacVn7SrU0am29OL30Do7vUxmTLYhaJuYI/GVrd29uso4d0tArNeU8SxdPI+jYbbDskfk4Jyr/8rrK7I1R7u08Cn4Lwp/s6M6BIs8BM1SWU1eBvJRshQPS7hyqHpd3dI7XuhTAVNATsTjRSF11g3AQdaVftNsIiA2oTkf1aJgRJ3ShsSmYHLwLbScwsfevqo9Gt+TlgKK1/m9GQn9UZ8S8TV2NttZJhUhpvd5BltfypHQiBtNzyjwRSgWn+rTpL0Un7bcbUJAAYrmumJnx74t1aVmugjxdXmXGJ4M7kOOCOzwcz91rQLxDXM1Q7YxX0sKV0mXA7ORp0K6ZrIYfn2hsaaQIUyxpDS3piznl0HenXwhQD1f7rgncxflyyxM88K9TQ93ALmw4pehCr7TaXmY0ANBcysG0HgmepWO+QAvHXnYIIRdAdqAswxUSPo8NnS7CgYh2KohO2eT9EJBoHF0F7HoiNioSsJALzqNIS+5XofFuv0RgGos0ESfJAAyKSlPUa00ewNoRdteQPnNWU+eXwS2VP8maPxZHyfs5rg9TL3jEo+XTqHezSmdqQQ4k1eglSUnspMxdS4gieVo7/Jxv/QVcVQqzhy2OpWMyONkYiJ2WkUMZRDJ7OJ29nTxFIPzGthBp/Rc3G4jwsXxkAOgmo2PMB8SAigDdU6BS4Z9uFgMfc361Hwn9szqTaRp1X79RdrQQuqZG1bd6At+O7YSRCg/X+BOjflAeXl4cPuydHMUgjwoBz8XJ682+Ile6N0Fi9vVnj0wRnODRNxQwCe
 Wa4Et8Rb
 Dc6bUeqlCQ80+gtBKCA8wvn1NM6suUxM3A0jbE5Em5BwezGaiKd9z1LpToMoTgoT8n7rpkJEAF0l/79B0Lgb7Voy3HMxksojLLVkTNBtw3chpi+B7MdKoeiBWlGy2Z6MiF/hkeWUd4hOuqmQFcmpJLwqRnCuy3toH6auRG4n++QvO1tfkYGW8aFEWzOewFaVNIFKo0fwlsvSYG7JC6LI3t9bnchIHxAKihVbXwXKpT/WbBIRjTDkZM/QUnk7LEqRPpxoA9bRt9Nx1+oSssjXEds2bOgRfJzwFz+CMpIbxZryXzqVhKrJMz4iuMuDMMUubsSahKtLcW8UCrfVHGUweF9SWhDoVyD7YqRwllRj0yQZI5afcdN4z4loYwUNQB9fWO8i+Vc23qbyLifQ48YX/bKD6R18KwsfszAdLfjjBonREtCcOqCRw3XqJIXYJ9xLWyPXD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2706,6 +2706,10 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>  		.user_worker	= 1,
>  	};
>  
> +	/* A creator past its fatal signal gets no thread. */
> +	if (current->flags & PF_SIGNALED)
> +		return ERR_PTR(-EINTR);

Acked-by: Oleg Nesterov <oleg@redhat.com>


