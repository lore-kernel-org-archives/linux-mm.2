Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D575CA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 01:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F9A280004; Thu, 21 Aug 2025 21:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547668E0056; Thu, 21 Aug 2025 21:21:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4859F280004; Thu, 21 Aug 2025 21:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 383098E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:21:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B34FF1A060B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:21:51 +0000 (UTC)
X-FDA: 83802641622.05.25AF9A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93A9040009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:21:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHvQWgG8;
	spf=pass (imf17.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755825709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP1gIuRFr7tSKsLKFv1sUFXkEDX22rWdnjLkvx8Dr3w=;
	b=B/8u5Joa7D/UbC0zaAXEDZ7J+Zshx92Oz7Z6fuJPKpW0I3oORP9Fa7svgG/hMaMHwyYa3K
	VYwp0/+T4b+wuDxAPQPJkyS/jRDN495EFNaNSELg1mHEN4K5PXDiuEZGB8dnrl40yx6LCk
	aIkGAC5uLiEW2ye29mtbYjLraKL3oTg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHvQWgG8;
	spf=pass (imf17.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755825710; a=rsa-sha256;
	cv=none;
	b=iUTQFZRT3fSd1njiRG5bsIb5WVpwNEtB3Q+LHnE4XO8boVfWFs1QK2vNmHfT+gNx9nuB1A
	mMTlVJ75Jh/NFkM1txCHHE8PdJExUykmUuiQCKQ9iHMKksniY9lpZsqpy9GVLX2d9RKtJs
	ZwJuvMjGOIHK+1FLs7Igc5c1ErSYxhY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755825708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pP1gIuRFr7tSKsLKFv1sUFXkEDX22rWdnjLkvx8Dr3w=;
	b=hHvQWgG8NY97QSYkFazA3BB2e3kqgx/vbjoio6O+s+h9YcA3Gm20ATGChvygcSeEGdp926
	lkhOGQ23iTG39uMJ5iCEnsrSSw2oqgQANF56a9kn8Dcx+pwnJC/VTMpoHxx/EKL9tnzX6z
	cpK4KCg9eaYaABAirS7i+JiYWImNa/w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-167-NdzZ7o2eMMy-971uUgmbKA-1; Thu,
 21 Aug 2025 21:21:47 -0400
X-MC-Unique: NdzZ7o2eMMy-971uUgmbKA-1
X-Mimecast-MFC-AGG-ID: NdzZ7o2eMMy-971uUgmbKA_1755825704
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5BF62180035C;
	Fri, 22 Aug 2025 01:21:43 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18ED9180028F;
	Fri, 22 Aug 2025 01:21:29 +0000 (UTC)
Date: Fri, 22 Aug 2025 09:21:24 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, mic@digikod.net,
	gnoack@google.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: Re: [PATCH] selftests: centralise maybe-unused definition in
 kselftest.h
Message-ID: <aKfGFB2MmkbA4BBC@fedora>
References: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821101159.2238-1-reddybalavignesh9979@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: tiftcu7f7hbxhpapsnfzidru1pzp3ksq
X-Rspam-User: 
X-Rspamd-Queue-Id: 93A9040009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755825709-279751
X-HE-Meta: U2FsdGVkX18TcYLBGKzoJ3YPfsKyuPcwxHqDUGVGyAjgTRwYAEwT9aAKEr4GCBKt3KdTnvG5JdgUPPRrL4nURqXKEt7g2VJk++3VFk3GpaEif4YtX+OYcoHoz5kQgapxxMSPPZIopunz8oNyP2BGhArO+dQMMwUVT8BC0dTLkEipe8JkoZYgRAEs8x7EGG4ne/Krhe/hTrHIOtxmnQ6oU6bCHjtH9j9VP2ApdDq4MdfCjmVWMInUB8ity8Gv8ke4XmcaCfjl/M4hP2nvIeQm0Ha/UE4iakvZVqHeK3FDaIRVt0YiNVIFhXDELNgY77AA1NpHykDsWuIE1pSpnVhnonAgFcifi7+yImGsvJTP2JkoWmoKNJaz+dBdpoKRWi59pJuNfqLcs1kUeuw1I88X/14O1LcAYaGjzrdaUqg1SvjHDe+7Vx32Peang5Az63vc/iL3jf93Eptrp+PVZFY/NiXC27CeWbFPPN8IvfTaVCQpkyE3EzRNbOsZW8TJy6YWyWIRZjmmDILb3yDmydOrx1TCC/s8gqid5wVvNJHb4z9KbwCfoCL/+geGNV7HkI0/F1b3i3SxxHhVZaEFF7Y1fyNQ07hY+iyDN50uns1dPg6kAcCmtCrrhc7gVdH63pWWbPnkzuzJGX9wRzOeoctsZDM0Zmadqhxn/6qW/jBvZtvxiVNToi+4RGdZWa1Qk7hgNhvKo+i7SCcrHg5FkoHZ45rmfKFdl0nOXQzagXmoB0qGLrESvRxDB9Ji2x+cKILZ60Spg6R0cSzHhW61Eg7besyK7wCLHaM10rA6cgSLZaDQY8DJ+4GCszEsgS5EeVY78xC55At+tzaf1LIAyv6/xrwOaiqW5Myqdmd/w9K8Du7fMZTcRFb8dfll5WoLJRI7tT2CEDHBortEAm5svFZasHrENVv/QguBIsmDUv2M33KRoo+2EB7WcHWh9w4/VcbkfwGyKGaNwB+rfWUaDu+
 pvVQyXUc
 qUFpiMA4wqA3lgandWh+m64eL8711PzKSUiUYXutrsPgra5mMvI+23pzLfrq5Ps8jI7Xib7cDtVJbQDUyLhY+Qn1e5mqPO0cFPsYJQyNxqTNaN45pcgoTNVMvaQCVk743Sjw0hMNV11/N3DBz45jF39zRBmvHrQ9uTwYKlms+g883ahfsVe0AYToziKx7Rq55yhj4FL6MhSZucV5Rtn3NVbMYKtSxn114TqLNLLWR6mOMvbUkL3Hh0PS/UVclD5feKV8RDVNVX1Bxmcy34CpwjxLLSkKy60zsVW6jgcGb9suRKcl/A6gmswpK/qcB2My+yURN2ZtzmPmf2RxI3HLziCqxiZ5bmQGslL00plcZHERkOwLLEVgcjMpnUnykiYj4lgG8/xxrjaYhSqPM6qEUGZNu7Jnts4nsWDp2ATDViZWBPxngnKMX5wS8c4dNEBeZYBGm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 03:41:59PM +0530, Bala-Vignesh-Reddy wrote:
> Several selftests subdirectories duplicated the define __maybe_unused,
> leading to redundant code. Moved to kselftest.h header and removed
> other definition.
> 
> This addresses the duplication noted in the proc-pid-vm warning fix
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Link:https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/
> 
> Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


