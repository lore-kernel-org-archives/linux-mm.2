Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F813D206A9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641946B002D; Thu,  4 Dec 2025 09:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2056B0093; Thu,  4 Dec 2025 09:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0AD6B00A5; Thu,  4 Dec 2025 09:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38DE76B002D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:31:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E96AAB6B6A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:31:39 +0000 (UTC)
X-FDA: 84182027118.09.4344AD8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8689C140022
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:31:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LuraFdCn;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764858697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8svFyJFXxwthUnxYwg8b9pc9HtZrBQvHp0Eb3p2+C8w=;
	b=shn1lLIJlraPlP+XtqYvNhB8ZKZxepx+VcXcZNfMv/6cglgN4vn/DQTOMXD9pXN1Jgfo/v
	rlOtjWG5jae9oeNftC5WE3d0c/9GH4hWPc6LC/Vhj7HBRZjU8ykqTbYwd9psJm6w750Eng
	XQRXNq1yGKPaxt+96TMp5fk+EGfSQj4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LuraFdCn;
	spf=pass (imf23.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764858697; a=rsa-sha256;
	cv=none;
	b=A7y5JJgtlUCKvkBJFYXx7nwBQdPRGBBZBQcyTwTiba7O3sXg+wZyKALGwXYI1pvJ6FevJe
	Zfkn/hU/bx11AIMmwxV6qR/4bS2bgnGb8TQpIo9jp1aQ3XGprmNn1Z48E8fP/nQVrlvwy/
	uDgl3NAuU9h6ZFSmPOAqioGOT9XTMEc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764858696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8svFyJFXxwthUnxYwg8b9pc9HtZrBQvHp0Eb3p2+C8w=;
	b=LuraFdCnWLF63VOhNFO9dvriw97PkXooyi1vxvnZhdlfopuLDfBmYcrTMHOtS84ZCZbArx
	Yot1JcI8E/0xs81VRf1EM6xT1GdHB1QK/cze7r0FAwRMekGVb87OzgaufB/ucZtPkv0Dp8
	eaonOq/JcH5WUA+W338uie+e37HX8Wo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-VUX6OVjbNZSz733o-nNyqQ-1; Thu,
 04 Dec 2025 09:31:32 -0500
X-MC-Unique: VUX6OVjbNZSz733o-nNyqQ-1
X-Mimecast-MFC-AGG-ID: VUX6OVjbNZSz733o-nNyqQ_1764858690
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A94D1956096;
	Thu,  4 Dec 2025 14:31:29 +0000 (UTC)
Received: from fedora (unknown [10.45.226.144])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C8AFE180045B;
	Thu,  4 Dec 2025 14:31:25 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu,  4 Dec 2025 15:31:28 +0100 (CET)
Date: Thu, 4 Dec 2025 15:31:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, willy@infradead.org
Subject: Re: [PATCH v2 2/2] pid: only take pidmap_lock once on alloc
Message-ID: <aTGbPIsEO94cFHZr@redhat.com>
References: <20251203092851.287617-1-mjguzik@gmail.com>
 <20251203092851.287617-3-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203092851.287617-3-mjguzik@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: zn1jxzj3rskk9hki7irjua43gz34owob
X-Rspam-User: 
X-Rspamd-Queue-Id: 8689C140022
X-Rspamd-Server: rspam09
X-HE-Tag: 1764858697-234296
X-HE-Meta: U2FsdGVkX18CIxzKnn3bHaEOpB+wfP/s1gmjnmYlznIxAflZ7ePoyRmhuSYMZnFYLie2VV7ZxHyFXe5uLLWxHpBhyS3RtpgEeT6npejduPcm5MaPGznS7t5RhHoPAHcGOI9RPihOotocotWGpMDtKAq4tc6co5H9W/LWYhnRGnyBcMxEQtnBgafS+gApm9EFiGsHY6SjMKPgNqUFPS1ZLjtI9FyAec9029XlAx9Sfm6Uto3D7q0vmJI3gKI5QhD5ByVTxdsQS8jcbmygbVL+XiZLinXaNo3IutNq3FD+nssUSaiwVrsXOLXSBiD9P4Nz0xgs9Gh6QccdLeXwNuHRhySyMBRHwlKo7lFnelG/337enXUxzRgp1URPYh1nmdDuYnHqKxP+ae15aLay/mBrdBllsfDq6OpxClwsfuGP/oofvMv7EjxKEjjIIrVPMZiIUSeFJVZTPEqcAhcXw1YGLDeByhNG+JFpbsPD8eI8npCC3Oa8d7HxkdfFQ8FgchWQQnAop/JzxIonB2N0/P5ApzTKYnLtZ/4bjIlWoMlElPMADthKOQ6jOkGvxn2e2OP4mZ0eYauk7GcnRetgJzln5qR3OZrCEFtgKrjB5zfqq9UrfsJ50N1LcWeHr2iGVY0yQgR+lZVu9PpPnUDnyQS3Pbr5LYJ+P+pKknoRo53gsNIZ+ND2qnDS85HGUkaC5HFHBJXnf0ZMyCohw0iVsAhykJnRBFXHI7ok8Mwp6goAHG16R+1rdtrEvBnqCu3jop3GdUpvRAbnjUD54kc21Qkqbk5iUtLE+W51c1FVffjHPtv6ZPNaGHU45DK453NJkFLZVGuEk3ywK38v1IyG0CohlIXzNFP5cjyI72VG1d+CMmHerias6Lk4A2o4DEKuuY3Up9cxJkHkuo5Wtjpg8QbUZqMoAi1/Jf0vgnvvssg8DFLDF8kRhGM0Gc6IXpqMiuEWbE3feJbWszf55j7BotL
 8IJcZlza
 XFfSw7ZsEgfvlHMqCP5Bw9vZlyCPB5r9Y9j0bTr6lDmueUvOERzl0zE0dH7T637pKE8DqphIUVZOe+AOAo0r50oGGTV/aWfVfdqwSO2PNzSh7IyOmEasTmasfT9xUv0gq/ZmLFmaLSmLugRJkX3wsHsRM7Ol9tYsduk/4Z60ZeHSeGtWHue/751aTlmBlnUkajmEpTeGRmxK726PjGwbYaEJNfr3EnuA9PtPfAJZrOSf5Dg6sLP66G+05sxEQLZxAWFrLyU+0e+v//RNx0Yr4QzlM5I+SK8kCrfnKuLsJLxIb6wHnPvUwI0GtgoSWmP8qXLBjby5d4KHnxNJmvGfhnS6ghmIij5PYmU2Y32Fe4TrOajOQ8LUL5HxIMXLzpDnJElbqFl5RupySrVolWdCnsz1tpvMqe6WKSuD8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/03, Mateusz Guzik wrote:
>
> It has an unintentional side effect of no longer issuing spurious
> idr_preload() around idr_replace().
                       ^^^^^^^^^^^

Around pidfs_add_pid(). The extra idr_preload/end was added by commit
9698d5a483654 ("pidfs: rework inode number allocation") because
pidfs_add_pid() used to call idr_alloc_cyclic(GFP_ATOMIC) too.

The patch looks technically correct to me, so FWIW

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


