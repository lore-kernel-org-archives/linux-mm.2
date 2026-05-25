Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC76DCD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 03:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0CF6B0093; Sun, 24 May 2026 23:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61C76B0095; Sun, 24 May 2026 23:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9776E6B0096; Sun, 24 May 2026 23:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F5F6B0093
	for <linux-mm@kvack.org>; Sun, 24 May 2026 23:52:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D56751C0008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:52:30 +0000 (UTC)
X-FDA: 84804570060.12.ABD8A8F
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf22.hostedemail.com (Postfix) with ESMTP id 50DCBC0009
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:52:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nspQdq1Y;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779681149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7aygqIY72kQ/p3Di74VnQFgR5TlEfhNpKIZCSQTE5Gk=;
	b=Z40E6GAK2F5HdTOdT8n73y2if3j/GVcqa24mhgJz40OUxrLTWkh7j8a56/m+QPyTbjV9aR
	RKDUQQdFPDAv+xp05lCBGZ36InogqzTaNjBpI7n9papJeny78MhnEcmyJdFvxvbKznF2AP
	MwisebE4MpCRMcIWrsAF/QM95VyCuNc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nspQdq1Y;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779681149; a=rsa-sha256;
	cv=none;
	b=7Wr+KFOFYNA3d0sVCF6gKRZ+V0Sn9TH9LfGTEbw21aUirv6LqVKMsIOvW0MymedeWQxErx
	3pXB8qqy0wDu4HodVCltBkBzDDThVItn9gn8dHJ8swIeHItBIDndtTsMWYVdAikO2b7w2Z
	h/KP24tUdGtkNPAZnbUtTAmTwv76+/0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779681143; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=7aygqIY72kQ/p3Di74VnQFgR5TlEfhNpKIZCSQTE5Gk=;
 b=nspQdq1Yu7uGDRh0Yv5uwphZvaFKYQhj78LB5V776zUM6MPUlxNVWRKsjGnyifxwBrH420
 SwGHd8sC8Tsxom2cHuzhinwJcLO4jEpSLfDpoLsVt6BByN5J2Msv+HE1YF2hOwoh5SjESq
 ITqaQ3mqKIe3d5U2F+w0R7yHWrmj3k0pDo+oiueVMZ1o92PQCzNNA1uCT8WJz5bYwn5I5P
 +XBxM/+d1o6MhGU4uOWe9XT8ALif4V2R5HTwBEexuVDH9ivGuEgb3c+ShLkMedtZ4NVOxP
 GEvRTjj5S1Kb80ZAN2H2uBIaj0w7bJF5hek4i/DpL5rqUcJE/T+iIRLap+yCNg==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Date: Mon, 25 May 2026 11:51:56 +0800
X-Lms-Return-Path: <lba+26a13c774+ba545f+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Subject: Re: [PATCH v2 1/7] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <20260525035156.94490-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
To: <rppt@kernel.org>
Content-Transfer-Encoding: 7bit
References: <177953825215.3959652.4404326127425239303.b4-review@b4>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <177953825215.3959652.4404326127425239303.b4-review@b4>
X-Stat-Signature: suwnunka3ce9kdiy39qzboh9sagneeta
X-Rspamd-Queue-Id: 50DCBC0009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779681148-115414
X-HE-Meta: U2FsdGVkX1/jvGKmxjkfL75e/n19ix/yokCTIugIE5pIlo4xcQ1tJTCkQOOF4IZKUKEeK6JaDUisjK/xzMoKZKsd82+XFXPCX7oNKKtccCzt8SoEmBrNE7ZtPgGQQzXNhcNrDWFqeGOdQa9KcYKithk2AtZ15230KW40Fd+itaj08/R7rXo7JprahI++Zu4nI/Bwyq/UxSUC4Xgy7T711ilIO+QGy8jjRnRzeVKF0FoRH7vJFXNnixqVUTGrEDMBPFXzZEMTkGm908twzkdum528YXqrHaxVVH83bBoacaqDO/zFUg0LcPrCnCvkmU/IAaNlWD/ZJI8/RO7igzc0ddvRG0/8bqLmMANCkBcd5rmV4rFjk1uTNZ7twq78BIuFYQehpdnOlAKOU5IBjJvPPIJoLwWgbZA5vu0dhDO7GnH2laFHqAZTqpVsKzRVRaBIyfT9UF9eBpNKB+2zaIocrj+LMHvjruOSbv6J4uK45YoYx6n5CLwMTZhPHzopjiWwUPSxc3Bg+sx4HmyUFJzgtm6RK/DaZRyxJhCE6/ADeJ5fCNYef+ACNdEpaOC+n69axMJSlNxU2lX0p+mH+5qzDj6APvkLVh3ZtRpIOYbHsjDDDO8AX8FjlaldBkRJz/mICxeryyHHOnMuUFOLADdy6B/wGCf8w1r2Bbiig/2j14zKbc92AmVAS1Gcg46416SXRtXCbracz8liNqJWx+i/Z4fLUxh5wSN7KqLjc30P5ipi+duXI4QYtjIP7vpYxPgDB6P8+tLeATQ+y1ZRP2lnS3NMYcUHSgkb9zwY3AbvL5g3ewdVgcIZ3PUoStndAWgREwiVZh/rV8hLTu3VgaXbFVlstCEbYM3N/RsAa1a2ToIkQY6lUL5uZxbErgezZv/fz7sdp1ZAWnIi9dP83+BSCNNleby6tnAE+Ao17Z+Dfk+ZsnYdooR3vpFe9k0of7fEokJP9NlyFGZ12qyYJVZ
 bNiY4xTy
 YgqcWBY5HhxtIHmjGQvL7X4HAVSsyOPwdIsJ+h3hFTlck737kKdWxLqHgdYFUItXebaF62t21hKqOmnjP3tfn1R8J/70kpEiftVOmVROgWVvOtTX9ReuBm1Jw/0NAY9v+VrtKwM/4jpsU040YwUEXqqQCW//ewrCosRqyiZ1IUf5JBqHVjMrswLRfjrMT4d5cuIBUUszIKBP6qVPr7KmSK5tPuXufYSzdtFPhww+qYhVyZa0U6ALC4E18fkfU66sysKPOiBRRXV6ShVs2yANedcXZwIWgych3niIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 15:10:52 +0300, rppt@kernel.org wrote:

> On Thu, 21 May 2026 12:01:18 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index f9f8e1af921c..4ba506df93bc 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -987,11 +987,36 @@ static void __init memmap_init(void)
> >  }
> >
> >  #ifdef CONFIG_ZONE_DEVICE
> > -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> > +static inline int zone_device_page_init_refcount(
> > +		const struct dev_pagemap *pgmap)
> 
> The name zone_device_page_init_refcount() implies that this function
> actually intializes the refcount, but it's actually used as a predicate
> based on pagemap properties, so let's make it bool and name accordingly.
> How about
> 
> static inline bool pagemap_resets_refcount(const struct dev_pagemap *pagemap)
> 
> Other than that:
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks, I will fix this in the next revision.

Thanks,
Zhe

