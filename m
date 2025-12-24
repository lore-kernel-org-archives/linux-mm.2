Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94750E74908
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 03:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC67A6B0005; Tue, 23 Dec 2025 22:28:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74756B0088; Tue, 23 Dec 2025 22:28:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B55F56B008A; Tue, 23 Dec 2025 22:28:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4A1D6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 22:28:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3926DB7497
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:28:57 +0000 (UTC)
X-FDA: 84252933114.30.00F4445
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26A90140019
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 03:28:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QOMtNkV9;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766546935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEnYiKFC1BPTOh2lEem5yt8CWGQxdCaNcVZbw2GCpAY=;
	b=QrkAptJj8zUNEE/iS0r6M3YYM/kurk5ya6jlwT8ioli4pqjB9b+GjSdkfUoewBQVCID9bn
	ZOvImPW94PK5xbjZr+cymTj3wiz4OqHHf/+BFuga//pJFAmwaCJgFdkmHRy86RMP7mzlfy
	J/Tdbe/vK+hE+ruv9DJXW/BtvjpymmA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QOMtNkV9;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766546935; a=rsa-sha256;
	cv=none;
	b=3mVKz6bdsVMuF617bK1ivMjpHNBuelirTq5OkMeWzHy0kQ2IEd95Iy2s2gskbFpzjQG4wE
	fp/MuaZlNjZZG9dLuwnqXNbu0vJukd+vvaZwyxvWOwTB1npdyvBHWKZJ8IVfqeCQloPdK4
	rJliCIWsIAf35EJmryYqUU/IL1rSzNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766546934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PEnYiKFC1BPTOh2lEem5yt8CWGQxdCaNcVZbw2GCpAY=;
	b=QOMtNkV9f6xARWWwm1STXKAlQqM3VyZPwFPi9yvl0SyWtdUGh4wj+KiE2YwButHjj6zfjM
	EiaxBuUFfs1AwiZn91cNd6JAnOjSxe56MCvLHD3CLWqq9YE67fq3a2GFwjyZvbiuwZZcFu
	gX1krZINJ2Gp2oynL5UUuQ7nIfytNEY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-69w2rVsPMJybW1GIqvYelA-1; Tue,
 23 Dec 2025 22:28:52 -0500
X-MC-Unique: 69w2rVsPMJybW1GIqvYelA-1
X-Mimecast-MFC-AGG-ID: 69w2rVsPMJybW1GIqvYelA_1766546930
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ABDC1956046;
	Wed, 24 Dec 2025 03:28:49 +0000 (UTC)
Received: from localhost (unknown [10.72.112.137])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C99551956053;
	Wed, 24 Dec 2025 03:28:46 +0000 (UTC)
Date: Wed, 24 Dec 2025 11:28:41 +0800
From: Baoquan He <bhe@redhat.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aUtd6es8UC0lNf/9@MiWiFi-R3L-srv>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+fCnZcVV5=AJUNfy6G2T-UZCbAL=7NivmWkBr6LMSnzzTZ8Kg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26A90140019
X-Stat-Signature: 3to4p4xsasm716b1e6rhhfyasc7g8eic
X-HE-Tag: 1766546934-62606
X-HE-Meta: U2FsdGVkX18AOnUBOoT0uWfbSrWtGeydtNO1WVAu/QUu0kfybZNcXgMiR8+QIomjFUUoQScVQtzn393AS6DhyFEhNCovPNkkOo5NYHmem3nq0MpxeQM54b6KX930ExGI2SM52SXi3kV59dqcRtvBuf9ZQHw//NMxvrGlysEQkCgg2QaYmKu7P4EmrszJTrtfx1pw19ompiaZlTTsS5Cnh9pGaNAFVZH3+4pK5tpGS1oFIW/cITZ/aA88rhixKpcn7hMGKg4J8GhGqD+sE33SxAda1gEl1lHEvOWE1L77SI21Nsu6r2up7Qu8vep44VhJU6oMtJtSbnCV6AQQzgglWA6FL5oXT1WeoscCdwSrOffZG6Qq9owazqFCHRlsZ2/s/1IobMFumH0zWRJZMw0XqjkcsowXMA5gLBbBvmHmDJdTAkvRNtqlkG8pUnqFZImJVXZ2e5tqUQPmI8adwtNgY4JUDAm8kLiROkAGhbEvDYy8fkUWu8uoNsyFTWFWxlu/KXYWOaMxdFzH1xWhwExaKB0s9wCuPv3XZiVwK4iQegqfQY2U7NTO5nXZ0ymZSvihLKBlYMJqWLR7q5Auu0JoUlUQDHr9DTWJym8IWD3BFCne0EXIXC9M404g6b+ZxHsTyPUD1lPZ3ROhDN9iIrOtgmYmpzAxVVGQIleLrigcp2HYtinhXyMbDkFrKJSnT4mwfpebCPJp6BzuGzfOXVF2JovI2h7v+j0GXAHXCGK5Fss5Y+atM+aBSG/ZCnJ18bigOPetqr8H8fWUA3CUghZai12dKo1gwByMAiqkacdA64nV4z0TrqUK0CHk4248BYYpPiNdmLbbstSghUy5piXsRk6P+r3y+kppuOCPTFeg+RRchq/05ryuYRRKML86zNzn4kpsow86k9gsBKGOh+rTgCj3RhU/z1nyacn+ivoWXplbQGjb1eFxte7Oz3rro/lMct83EBUal7pLWYZvali
 uT11GEqI
 WEuYDcdCAfeD6LsWjfZcN41sdestOPefnWw34/v3RBgh2B3HL9sgebJk4GrcvqFGqf0CRp98SYxt0nNRy31eDzdkXFBK+++o3nQOMMBVVDyMCN8R5GhSltOZ2UEDH9TDZfUqTBpCN9L0d/6GaREZJWNXLitDpznthsmA++2oUf4DxIGxd+JdjJe0kh6MLXxK/purB7X/Kr3U6XZ0hD2V4n94YilrY4UyyyVRHP60TOVaP7Es6cJaDanc9k7EAQzoYTUcIgrKm6FaFgdYu9ajGSLXpazR6Mv44tnYS9wTYpfWYKJviRcWL3+ASIogXN0OtP3GS2CT4mWGjOVB4H52nuCJD8Q6melx+6AE50QTgjJXiyr0cC/xP+OvcofNVlh3h4VF5DSK8yBbJxXoTQkAed8758yWMjUb/XSnFFMjOmXnarF5g+QSWrBcNyhThf/vYE1bLwof3O4ZawvW30l9jS6doOizTglAJuArTZLC/MvERkuKucMsHYfyd5em0L89fTp6GjC4gJk0zTES815KjIA6z+1bUmSCf8l7DV5z20ySrwTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey,

On 12/04/25 at 05:38pm, Andrey Konovalov wrote:
> On Fri, Nov 28, 2025 at 4:33 AM Baoquan He <bhe@redhat.com> wrote:
> >
...snip...
> > Testing:
> > ========
> > - Testing on x86_64 and arm64 for generic mode passed when kasan=on or
> >   kasan=off.
> >
> > - Testing on arm64 with sw_tags mode passed when kasan=off is set. But
> >   when I tried to test sw_tags on arm64, the system bootup failed. It's
> >   not introduced by my patchset, the original code has the bug. I have
> >   reported it to upstream.
> >   - System is broken in KASAN sw_tags mode during bootup
> >     - https://lore.kernel.org/all/aSXKqJTkZPNskFop@MiWiFi-R3L-srv/T/#u
> 
> This will hopefully be fixed soon, so you'll be able to test.

Do you have the patch link of the fix on sw_tags breakage?

I am organizing patches and testing them for reposting, but still see
the sw_tags breakage during boot on arm64 system. If you have the
pointer about the fix, I can grab the possible unmature code change to
make sw_tags mode work to finish my testing.

Thanks
Baoquan


