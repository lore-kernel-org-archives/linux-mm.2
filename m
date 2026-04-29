Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E33FFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745C86B008C; Tue, 28 Apr 2026 23:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DF56B0092; Tue, 28 Apr 2026 23:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633D26B0093; Tue, 28 Apr 2026 23:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51E6B6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:32:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E23E016065F
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:32:18 +0000 (UTC)
X-FDA: 84710170356.30.4E9E1D8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3A1414000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:32:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J/dkKNIg";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=obUrxMTS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J/dkKNIg";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=obUrxMTS;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777433536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkMuz1cS2oVApSEm5t+gykE+rAqHJofwoAD6Cia1xhQ=;
	b=wRQ23eZH+PoxzyB9X8rlEgZ578tmVwOyb0UK/bduKrp9LNkPgjzadtT8eyzX/tzEL5wLZG
	qampMyChyNIj7Igr+HFbd1Tb4zAvSUwi7NGEpOT/4VY8BAT3uyqbmnWotRGr6vx9W8BuE8
	ola8JTlJbh0bg5Kni5U+/p13DKPwN6c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J/dkKNIg";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=obUrxMTS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="J/dkKNIg";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=obUrxMTS;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777433536; a=rsa-sha256;
	cv=none;
	b=BwDbOXTfmY5Tbmb00Pd28hhyZlnKBeVBe418hBr3/RJ4dy3AuKtq9020NQpj6axCQ9BtY0
	jYJUvNk7OAJP0IOkc1zS+Qo42ZIJ/G5c5rHwuYZ9zzEat7jzef9ywMu6e3e78NxTfffiU6
	noSz2MaPBvtL5e36Ysv1hqh0eAPNCA4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A20135BD4F;
	Wed, 29 Apr 2026 03:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777433534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkMuz1cS2oVApSEm5t+gykE+rAqHJofwoAD6Cia1xhQ=;
	b=J/dkKNIgu8elcZhN50GVIHmLaBzgpquaed+/7P9TFJ0ZEmYS3TFEtzzfaTZ8KeRtuLVZwY
	nxO8fPhAdCR+CjUEz9GeK1i5FGDoDeyvu2soe9hJvOTYz/TtzWbe+MVa3442vF6vPzrkAT
	jSf5emQugyis6e3yy3P+UjcHtYvaKm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777433534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkMuz1cS2oVApSEm5t+gykE+rAqHJofwoAD6Cia1xhQ=;
	b=obUrxMTS9ky/k3/KdLdMB9aby5iIFa91VEaGnFhAXWMk5Hi389z0e0gW6NXRK5q02XPyk5
	h65N3bwwPBI36eAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777433534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkMuz1cS2oVApSEm5t+gykE+rAqHJofwoAD6Cia1xhQ=;
	b=J/dkKNIgu8elcZhN50GVIHmLaBzgpquaed+/7P9TFJ0ZEmYS3TFEtzzfaTZ8KeRtuLVZwY
	nxO8fPhAdCR+CjUEz9GeK1i5FGDoDeyvu2soe9hJvOTYz/TtzWbe+MVa3442vF6vPzrkAT
	jSf5emQugyis6e3yy3P+UjcHtYvaKm8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777433534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkMuz1cS2oVApSEm5t+gykE+rAqHJofwoAD6Cia1xhQ=;
	b=obUrxMTS9ky/k3/KdLdMB9aby5iIFa91VEaGnFhAXWMk5Hi389z0e0gW6NXRK5q02XPyk5
	h65N3bwwPBI36eAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5BC4593B0;
	Wed, 29 Apr 2026 03:32:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U2WdKb178WkeKgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 29 Apr 2026 03:32:13 +0000
Date: Wed, 29 Apr 2026 05:32:12 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Dan Williams <djbw@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rafael J Wysocki <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
Message-ID: <afF7vI_fNXs4mCVA@localhost.localdomain>
References: <94F5B89A-008A-4EDB-920F-31B4895C2699@linux.dev>
 <c6e1df1e-be5e-2468-d46e-453985ba1e79@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6e1df1e-be5e-2468-d46e-453985ba1e79@huawei.com>
X-Rspamd-Action: no action
X-Stat-Signature: ic9px4x3kaocms3mryzbecsuk1mdhzrs
X-Rspamd-Queue-Id: A3A1414000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777433536-877932
X-HE-Meta: U2FsdGVkX1/SKQO1DQNk8usV3KUM7gLEAnuxD/mS8nul0KtzDvcTqMH5Oc+QS2DE+iAS89D0MY4UbCI+g96bjJuodJkdv6x0jQMN9GQ6Sxji2ZzfDyML1QHYmSkIGeizSX7ktIkJIWi/Jh38BtEEkzVDD3DdxcGEGSS/RdIi8Xv117pWhq73k7u0XxfRVZAIa6RVpMW9YzgmuGzA61mbfGsdCgisIi8rJNu1l41Bezn8jznGcfDr9mIBiZlciERcdvk4fdx7j6hG0pJHC6HN2ZW9GYQUiSDXPX4zw4h5554G+ih7MiqOFkuEbFB/fS2xKRm5IsXxr91X/ykqfyGDu1EI7d6La4gUFiybWiY7iXrwGLsK2vc5DouWlY2zM/360GY7ay3FRzTTQuwQBA9MS6hPazq7ST+H/JOA80F/1JPxG/RZIF4iqb3uQulHlFIZ3Z8k7CnxIztkrajmtsAfGouep8DFF+uQbfk/71DplXHxWvJ2Nfr7M66M6GaT8cX4tXgWH16oEWCB30V79FSjA6LfZua/hbQ4KGdxBKrVjMwirL36tLBMWZj6gz8+hNVR4teo59BOrnlQz3G9MwbfD88ubzIgKseAdh+FEJOQoaC8VhVUo9cM1YgCZS/4Ba/Qvwl/ywwq6x3jF4ZY3eOQumH3HqCEPwSBMuuVx3nZWmlq8jcVFq+EaagNdy5n1GxdssCTFSxSANAgcjSYrPqkhZPExbqoVtlrnKmFXEhwpgVEZfnV21h9Mny8s2zswaSKq9NSWW6Bm8yG5/fCUQAF8E2Yl5o8bUUlee34GKRk/0c/VLJjfbOjYvAhr+eW5+mriuQo18RowaYvedTBdpXk/bucFEAjyuMMtQG9wVTlOLa/YLKU6WNGuegscsFZ9Je3Bh2uvGwU45w/gxHNU7VqY0ZPQz1BJYqExpgIIcRUnJuaSyJeI4DSmc5fDmC8gy5keQJh/9twrSa0YPU85O0
 zjogswyB
 VJjrzqsC1m1tiltdp+AQpqqxhrnYv4xpHFgrtNF/vlLwIxgmutHKyljLrAZeCEMmDX6wAKxB2MHdDzQfBT9uj02OMUC97Or7GnxbzAQG54N7fRJxNYKbiWskIrG+QaXSWIB+U3FvBhvBNkIrAoAoKbb7+ICpqFGkKrVXPT5qM8xnFFoSIb3ubLN4lvvzws6Dl1SDeDeNZBkK6pf7QuYfvNL8EE1vN4O3zA603/IcGrQ70Wr26o6sLUD1NJ27vXSI8OXyVCS6JHvg5ixBDcHong/6DD40l5C+XTDn70BFtWO1dXnsDEShJIL+9A+TpRLlUBmIQuj9C08njRy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:08:51AM +0800, Miaohe Lin wrote:
> Right, I missed that. Thanks. But I'm still worried that there might be potential issues.
> For example, this function could be called while lock_page is held. Acquiring lock_device_hotplug
> while already holding lock_page might cause problems, though I haven't seen any specific issues yet.
> Also there might be some other potential scenarios that haven't been considered. Hope I'm just
> overthinking it. :)

lock_device_hotplug is a mutex lock, and we already take other mutex locks while
holding lock_folio in other paths, so I am not sure I see what should be special
in this case.


-- 
Oscar Salvador
SUSE Labs

