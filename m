Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04168CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 14:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DC86B008A; Sat, 30 May 2026 10:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00AB6B0092; Sat, 30 May 2026 10:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E167B6B0093; Sat, 30 May 2026 10:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F536B008A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 10:10:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34C3D40396
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:10:25 +0000 (UTC)
X-FDA: 84824271210.25.5AAA299
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 156332000F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 14:10:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlZTu6wO;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780150223; a=rsa-sha256;
	cv=none;
	b=RTPaEkwMT17GNV0aVcxXs4NXdOr3qk5QrHFrfl3UR4B48+zmCk1W0ArxLAVpvhyX5RbpUc
	rxGF/uTL7exYXeuBYWLf7IWWZtuzX8t62WO+1Bbx8+uYBkT5M/PyQ/RSA9JrtRI6Icmatj
	5oWfo91nzRje6cI0sEPo8tQ8pKCirf8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VlZTu6wO;
	spf=pass (imf13.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780150223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rHzj0oWHgChdLmB/fyna+PsMVuLCqphhK0Q0cKp+AZU=;
	b=zbxb0WoH65AxwOZeGlJTtYdbp/3/K//Cnalw3wABqnFoMxOqgMgk6ax+r1ORFbyBOnh/yV
	kctsbDJI2fgYBW1fYjUVkDGTDrM+OmoXxCO2y0Iw7yXwZs3g6pPrX2i6rRh9dfK6Cfgki4
	8IYAvWFvoC2TykCBb9mqxmGd0YylgaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780150221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rHzj0oWHgChdLmB/fyna+PsMVuLCqphhK0Q0cKp+AZU=;
	b=VlZTu6wOx3VlbolB5LEcaIHqMuuzJg87Q8GZNGiaDrMJpSAX8+qho5jvHebxNCzJ/DV8m/
	kVajxYkrZ0xPhvwyF9A0tb2adsjl7UflWpk/W+jJYX8Ek/uTaDqpCp5hRGeUOeJPpfE9lU
	+mxolcvHV9iu9a3hQEGdbMAk9LIs1Ms=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-yosW6iIYP0Wf3gDnZmBWEw-1; Sat,
 30 May 2026 10:10:14 -0400
X-MC-Unique: yosW6iIYP0Wf3gDnZmBWEw-1
X-Mimecast-MFC-AGG-ID: yosW6iIYP0Wf3gDnZmBWEw_1780150212
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 749DC195604F;
	Sat, 30 May 2026 14:10:12 +0000 (UTC)
Received: from fedora (unknown [10.44.33.166])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 3CA2B1800352;
	Sat, 30 May 2026 14:10:08 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat, 30 May 2026 16:10:12 +0200 (CEST)
Date: Sat, 30 May 2026 16:10:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm_access: simplify the security checks
Message-ID: <ahrvv-XGt8SiZUvW@redhat.com>
References: <ahrsfJE3NkKjShEX@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahrsfJE3NkKjShEX@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 0DWHlHnJ91nkeK3yJaoOdRBWHV3pprABxRslJ5NDyLs_1780150212
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 156332000F
X-Rspamd-Server: rspam03
X-Stat-Signature: 9wy457dgk8erz9i86ykezwrux5jdb6cs
X-HE-Tag: 1780150222-378172
X-HE-Meta: U2FsdGVkX1/zBrOwdO7VCt9NJI36BfQ5sfr8S6edcGHpwTXpCPc1DcWOKPm6pGdWhrJjkZpoMIVCsqkzVDyyNBlINDteMQMLeNzUpp9hMjsZKxodRuqzNPCD+j8QrqgVGlypCWB1O7BCJu26X4oTT2fmaxuStDdM7LT4AWvxiy5+wil2oKTOCtfk2KjH5rbYbPBmoYtbNmBA0eSZ+4DXd7SjR8jW/HrMXCzq9nhVv9XFwbg3CORTZBwUk0r9X7spAFFMacayO3x82TzIDi+8fJ1HaJG0x6TH01mzzikAXE2gTL0e3WvR7ExgaoQwSxGbmtYjLExgoUnlzP1OQCQ2n/YUON+Lnhg4sk16mH8RuIDKfQsK6/MGjaDk6UPA1yDb2zaj/pa6WQkN03+MNPyqRW70RIKFWaWlg7/gCWZyJpR4KPyDCtPMJSyaJtPTwgrS6wXlM/ypjaWa3Teb2h9RbvEDG89XkkyhAS+InvUkeL1jSaG/7AOwXGWWGynQW0BlAS/5c7DSuQ3Do6HuVxV51T4DnAiXPmoArEIJpRb6g+HZawhhUnqkZlG1IuI4KSE7o+GGKjTe70u69ONBAVHYMvKJpD2s0VBuIBAMlhvblhh6tgk50bP0HnZOgzQP0Q0/D5y1bpZThxBa88tCTUqrN3WOrBll6kpM9hk5X8CCBvNP/ApROGTFAKLVqu4MUX17L14gzh2M8SwYqJYC7ZD8O+Rxtulr2ZBqeuY/t9xI/HUlEO6UrqOor/XuF6D5DFJOqaSyCdUiIpe6a2MEqWJqM2uR8JhuYQdpy970zlEm3nJ/VU/tE+2eZuqtl/62WP9ZYJnFSpTxzgz+19X7Pq2G8AmulW4tCc8Z6ZSfpuC54U7YMqXkntZy0UwXDz3zQyHFU4Vc4NiFocYux4tZBJ0geGKOyWPbKiJPW1eCJiRDN0xiIC9Wh/gn839VwXHsx/9YLMBs4M+WU+XI3Qefh+/
 4pkoqilJ
 Nz47iiVJwPU9NAy6yitPpxfVmy7l7LSJ1+yO6uPfgxXeV7AkjvLxra2SuiNq3FIJuIDK10y8XJoyaQMS1C3FnxnDYyT+fzmlurMEJH8udN8LHE8WdOi4W6c73nCbJ8wadpvFUSuISu4jN5fTqp2kZUqATK0IGA4583PBHBj/NmbX9quJBmIT7Q8vT+RSJqHSXWyNkzqTllzcG9S32/fkQ+hcTWHs9XWbKEwP7L3dq8teIXB8v6afP5U60TSv9z5DrzKyXHiHR0kGD9/UUYYbEBI4nnSyfQp3tNN4/eWcWwiCS7voMWMDuZHKigxGzXMbT8OXPbPBOP+wKMgzt6jtXjkA76+eyyOsd/JpRDo6I/ZTfeedY04VhoNqI9zmcr6ptDrqAPsUNBM+sEIddwWyxJAsS9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/30, Oleg Nesterov wrote:
>
> 2. With the change above may_access_mm() doesn't need the "mm" argument,
>    so we do not need to call get_task_mm() beforehand, we can call it
>    only if may_access_mm() suceeds.
>
> 2. With the change above, may_access_mm() doesn't need the "mm" argument,
>    so we do not need to call get_task_mm() beforehand. We can call it
>    only if may_access_mm() succeeds.

OOPS. Somehow I wrote the same twice. Will fix the changelog and send V2
in reply to this patch...

Oleg.


