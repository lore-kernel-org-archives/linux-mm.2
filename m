Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212DFCCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 05:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AB208E0006; Wed,  5 Nov 2025 00:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 282A98E0002; Wed,  5 Nov 2025 00:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF5E8E0006; Wed,  5 Nov 2025 00:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09D6C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 00:44:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F9DD866BA
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:44:03 +0000 (UTC)
X-FDA: 84075462366.30.22D637B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C60880009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:44:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MCwQEn0x;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762321441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9anBVAz2hfGO8p8FWHjuAN59LdM7EdQcG+brg7ozR58=;
	b=d/MmkJ+IPavmDAzfKRDoFdXBACsJo6py1X8u11D+fhSK3mFYgMOViFk7f8HCwk+MNQcCEm
	J+xL5iorr4COGyevgX5avcKUOW/DRrTcXw7Vr7/neNEySDtgZwIQbGB8fgobxhexf/V8/q
	spmUOSrF8LT2XoQLP8f66pv2QGyOTMc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MCwQEn0x;
	spf=pass (imf30.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762321441; a=rsa-sha256;
	cv=none;
	b=oBLyUkI+/JeQOJ+9nSE+wcl68Hhy8Ht60TyD2lyQT6GxrW/wNgSQ6t7qmqHlwzLm0PK2vD
	HenDsd7kwrQDOqdGHXLHSTMdiCajL1wKe5nOW/a15qYhSgzUuDIN9sjKxhsTGFzLuiAoD/
	f/GCo2LNtS+9Hg2KqmHLBxZFwaFCgtc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762321440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9anBVAz2hfGO8p8FWHjuAN59LdM7EdQcG+brg7ozR58=;
	b=MCwQEn0xd9sYoPWlQmle2yXy2XHgGKQviqpCCW6yi/42XnDcFW1qYbTt1yAPjFovA+FFCZ
	TB2+Gb9B3kQTH7n0Pd8ld7G+1CXV9eRhnbPK2X7vmnqGMxpbsFfekf2zbqif8YuQH9CxsR
	g9GdEC7oSNJ2aGMnB60DSQPbRpc/VgI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-F1-14ySSMlONZ3Zg0k64LQ-1; Wed,
 05 Nov 2025 00:43:58 -0500
X-MC-Unique: F1-14ySSMlONZ3Zg0k64LQ-1
X-Mimecast-MFC-AGG-ID: F1-14ySSMlONZ3Zg0k64LQ_1762321437
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 313DB1800350;
	Wed,  5 Nov 2025 05:43:56 +0000 (UTC)
Received: from localhost (unknown [10.72.112.190])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 222861800451;
	Wed,  5 Nov 2025 05:43:53 +0000 (UTC)
Date: Wed, 5 Nov 2025 13:43:49 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Minchan Kim <minchan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add Chris and Kairui as the swap maintainer
Message-ID: <aQrkFflKE+aiLnQw@MiWiFi-R3L-srv>
References: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C60880009
X-Stat-Signature: y1odzwnhrcidaty67tyzomr35zyt5enx
X-Rspam-User: 
X-HE-Tag: 1762321441-680174
X-HE-Meta: U2FsdGVkX1+x7mBxwr1teQnudVNaiiTptcGYlterhkesdXIagJLPQ9mwlkKIsyOQFJ1xXEt7fQ3FRKwLj9XUUJBjolUAg/9Bz5c1UXAToVuHK2AKrNr+BKGyZQX0o6ody6+LGZmZS/OtKpvd4eIGXOe84lEImU64mPttyDNQz3kBeuD8XBAAfgvDfUV6KDO6iA/1lrp/Hg7SPrjMGnO2bhOoaOck6fVKijocLc9gViS0xc7kK3IErcJZBrRbqiBIf3HMfX/pNYNwTaKHQkvTvkSWHJZs0aD5tREtBI1LfXEq1Q+vBL+FnR9OkksgFPliuFw4CpixQZ+c6IqX9TizDQufHisyXL42CQ+CGFdzcR9BCqefeLrBYkYuKuaWgnh3ISGE0uZsyHDHpl3qFK2Hy6P+AjdiOu2NEfVeHN5G8qK6vCGuos4bDO6Ri4XEmxLTTzkHWb+s5+O/uZ8OZwm6MfJG98ReqgU1MYeFINw37m4lP6tn26/0tu9ov/Joi9Z2TYiUdTiJYnz9vdz25CWhFPlA/43EItLa4qVDnKok2a20X1dAB5TCqVlwXyZzu4xzsyXWB1/Wr5QsIj6hV3prwaLf4F8/5WWrGEmqgf/9m8vQ5ixTsoT1irBdB+iZfxLhsoQ9gg6IIqh/44UIQgz8HQNukHM3Svcgig4mkKtV75thxWCHmzDD/Rv+HZsLNj/kuojjyTCf43ITUty6DJZlUp3CjDuAjhm2ftZp4FBDjF4+kt14B+iJeNA3bAkw79YM2zTd3YlmWdX1TPl+rcE2umZcM0L7b/aYqunaZKmwiDPdJRgYeDxM9tyI3/UNcFBAHyukBcm3Cr06yO/14PTlcyTEJyX6LUYsekZTGkmi9Z2OYjNNYzAousisbrQHjtzNDrk5qylIpD9rADYEEmgNyzFtQfbo9g53ePZ99LKbBN6BSf7gmHWKrInrf9bRLJmCpVf1hDJ0Y9oxTV4sJtb
 RYk26vMU
 psi4/6y8JTV9Tvu0bnk4nZbTA5A6FcpC8PpA8utsj7Ct0cMJfwUOQaLlRawIeMxOboBgu19XRM9L+zaXnESr39mgzqgtWMluCV2MC4g66Ea2+KzWlOH/qy9SwSFbh1AYV3jy9AOqU/H+9MbtLBGjgrWSbhZ4f0UoaH7kbyPZV8CkPdY8uDVu2wZgyC5bYuHNhn1zT2Et3ZpBhVz20PXlP8RJ8ttP36NPXjOBcn1uC8ax3ls/rK5zcsjkBDsBaA9KY5l/KYGd8nj4l0E02oL4qzUcQcu3Hvny4rCC1/N50RnLZzJ/NeH+nc9PK/lJqejC9fHF8oKhsJG2XP0EdAvkxGe1IKYqOK6RIOm4Vxmf5OchtaEiz5Ob44qEKCyuqDf+/jyUiyaFr8LvM7aTddQsgiZ2MaXyims1Wm4YG6LDJPJDHFwhgRhdBnGvp6SJ8nUEyXnf0zuLHrGJtjFJDZZVXXyxX3mZYgeGxXQ3o/TuO5HYOCE8BzQ2GtdMWNF8gTmWm4+JAkUQ3PCs/irvdJNpT1GXEPwG+KztxkLMg1k5imKLB57TV0zywSaPaYapXYEmc/curq1R4ZPexLr6jlfLsrjq5rTBz5KQjXWavsa07bZ2qtDXYtK813yJY+nuRi0wx2Htr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/02/25 at 07:11am, Chris Li wrote:
> We have been collaborating on a systematic effort to clean up and improve
> the Linux swap system, and might as well take responsibility for it.
> 
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2628431dcdfe..8b5af318a0c8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16497,12 +16497,12 @@ F:	mm/secretmem.c
>  
>  MEMORY MANAGEMENT - SWAP
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	Chris Li <chrisl@kernel.org>
> +M:	Kairui Song <kasong@tencent.com>
>  R:	Kemeng Shi <shikemeng@huaweicloud.com>
> -R:	Kairui Song <kasong@tencent.com>
>  R:	Nhat Pham <nphamcs@gmail.com>
>  R:	Baoquan He <bhe@redhat.com>
>  R:	Barry Song <baohua@kernel.org>
> -R:	Chris Li <chrisl@kernel.org>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	Documentation/mm/swap-table.rst

Chris has comprehensive understanding of kernel code and possesses
extraordinary insights into problems which enable him to propose
some highly innovative and visionary ideas. And Chris is very willing
to share his perspectives and iedas rather than hide them for personal
credits on patch posting.

Kairui is highly proficient in kernel knowledge and system operations,
and he handles complex problems with great patience and resilience, E.g
the swap table patches posting, and performance testing in different
scenarios. Moreover, he is always quick to respond to people's feedback
and address any issues related to swap.

Thumbs up to both of them, and ACK to their maintainership on swap.

Acked-by: Baoquan He <bhe@redhat.com>

> 
> ---
> base-commit: 9ef7b034116354ee75502d1849280a4d2ff98a7c
> change-id: 20251102-swap-m-7907f24e431a
> 
> Best regards,
> -- 
> Chris Li <chrisl@kernel.org>
> 


