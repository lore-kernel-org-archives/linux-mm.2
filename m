Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A155DCCA471
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 12:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCBE8E000A; Thu,  2 Oct 2025 08:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB43E8E0002; Thu,  2 Oct 2025 08:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1898E000A; Thu,  2 Oct 2025 08:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADE548E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:39:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A1F2591F8
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:39:38 +0000 (UTC)
X-FDA: 83953130436.14.B550C01
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2157E1C0015
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 12:39:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bocYj6Uv;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759408776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5C5fdoU0uLbm+o545BvXxQdudZ+0LV6/rGhuIig5kkA=;
	b=AxsoJlpIVjZGMH7b9zc51K5GGusKENjldwt7hapw/M9+LsOX040OlHtyISOAc5jlLai9gr
	AvsnBJ0cH0T1ELNEnd5tCbe/hDjfvMf0A/PUH8XKBdIVZ/FzJeyORQNp//z+DLQRxG0BBO
	pzlOH94kkIzUydf8YyUNigwfpbjAVSQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bocYj6Uv;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759408776; a=rsa-sha256;
	cv=none;
	b=H2thOit+WR6BLFXkAxEmQWmtCzNssHZE5joMAjXf4KcIxnhrKOaX+fF57iMHh/7SEHkWmR
	ZIr0nJYxUxCSyJTYZ8JJJDLy8dR3metILDHU/Rpj+I7mFpe1YkQTjMKI0EWUW1BiTkmCo/
	yqZyVr5mWkAPe6ttkJ1gUvD0BrPeHP0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759408775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5C5fdoU0uLbm+o545BvXxQdudZ+0LV6/rGhuIig5kkA=;
	b=bocYj6UvxlL28Q8bKWhEc6cNw+AHgJRe3xfDFKwAXtx6hL8kRqTtjcAu31RgSENxJXwZuK
	d+HFnNmHBKTtzpsmm026Hq+3X85VAQ8gGVnyMP8bBYgNBQ55yVtpdD3e0o392OCKrVTxV8
	raVhN+TB3vyuCgW9qLynDws95H3qAlE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-377-X-X1YACJOfaDjCWvqwo9Og-1; Thu,
 02 Oct 2025 08:39:31 -0400
X-MC-Unique: X-X1YACJOfaDjCWvqwo9Og-1
X-Mimecast-MFC-AGG-ID: X-X1YACJOfaDjCWvqwo9Og_1759408769
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9516119541A6;
	Thu,  2 Oct 2025 12:39:28 +0000 (UTC)
Received: from localhost (unknown [10.72.112.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCDF919560B1;
	Thu,  2 Oct 2025 12:39:26 +0000 (UTC)
Date: Thu, 2 Oct 2025 20:39:22 +0800
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	youngjun.park@lge.com, aaron.lu@intel.com, baohua@kernel.org,
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Subject: Re: [PATCH v3 2/2] mm/swap: select swap device with default priority
 round robin
Message-ID: <aN5yemDFqJySK9us@localhost>
References: <20250930063311.14126-1-bhe@redhat.com>
 <20250930063311.14126-3-bhe@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20250930063311.14126-3-bhe@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kb-W28da2ympTjtwmKK5fjhc3hdzPLa5qHhD9ye28og_1759408769
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2157E1C0015
X-Stat-Signature: 7g9pfzbt3i3rpirtyycyjswc6k4rmmju
X-HE-Tag: 1759408775-90133
X-HE-Meta: U2FsdGVkX1+KqchO82GSSwuWQEQzJOLHKXlkM0QO/euXuTgfUVVpQw69DkEm3MYoSlyQZm9POW4IimmLkCESj8p5pnatrHFsMp6A4W6OGvun9HUb7P8UmuqlYp6OL/baHjLuO2m1Kg76Y/jhN9HfWdKhi/L851ACqVa/BSQ01xe6v9xPiPPsh6vxfTBBKaCENCxCVBvV7q6r6Zoc/DJMLnZa4IX0ouiAF1bQ44pxDa8rBj0HhkEk08VxIm34Y5k7l62zZVUFYIrOVLBW+8iK138PK+ATkYriO2m8SM6dFuHsdrkDRhsswf4EEWmEmO3baboB0VJ/Jif795BBVIzUtP1rgVW6GQytRTI1vymmU20cjG7/mAQuKyRSzCG4SPhf10ez+dyT1uS0MJ3yod/VLjvlXhkE/r3o9yJTV41yg8gPzD2EZf9jOEsmz8R7V/fv8nkU/YzXuhNCF3y8+Nvi5zWRFx0FztZcAyQzqJ8TqJvKZhBCjG1hza9M+aRcKsPyGkXjDKqrqZuLWQf1OWi6MDln5vm8yy1ZLQKoUFxWBWUm5X28JuNy2rhmaLHGekKzacE18nCedM16Q+KBh6AMZms9SlIf0hKYyUvBEWJ7JCwuQhS4ED0gRCkdun7hP4440+g+dqGKfx5s5jh6A+NuPdGF6cLkHuhH9G2GmSL9xwPyYG/bmc8ExFmOWDaDTYcKkfPQnNZCRWxSxnhLTQhCHwnfzCckkJAeDp2oQvueHEoJYw7q1kx56eoIHprRSwHI/nJFTIOy/suRVsgemvcqY1xAr19LB4+ubgDRryBENHp2hRTvAJDTrSSP3S4GXHDOVjHCBxvl+po3PddTUvtG68GGa7OaKLPyM7JQHBam516+UtE6dtI9WwpEoyDRGBkMET+xRFJxAOqF3AecaXko2MAmBQrr9A+byYJYyWuJ2ENxTxpaHJWwC7jARAdLv14Y9Pwm+eqAZaZUr5TX6bz
 jt1JSu5Y
 Y9W6vuSSaMMhq1K/31ZKsHr45FdmhF8l3Z0OgLp6NRhQiHTlL87W6CV0BqEN5QOiXB97C2TwHspNK+vfGvAl+UVL4T1N6V26UfCbTun18GFiXPwnofJJhbHTbCw0IrrXoaWg1UXXa2VadzEGR6r8ZKtP9WLZvE1GlgpRMCv3sNd4o4OiuPFIDh1dELDioB/cfEtW5WvsKzPMlVbEgwg0Bu8MeRXImxkNSroS8eRC9Qg4BkT1jyzFSrTpO70dzrHCNaT40xndgUoHnAoQzmB/f5PamjcdlWQ30Rro3GVnJAbsFhXQgj2PaaqkK4VsD2T1GeVeDMqAfoH6owzp3MeGSd6UX+CKYXMZjVrkkM628cERBG1CJ+irZZ9z4PDvby/14DDnalsBv1gqIrpT1ahYTu82LeFtTzWT+43Gnm+iLUsZkwS4SeUZpNF7FFUmE9gW+F4SCBlxmHwf3sLA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/30/25 at 02:33pm, Baoquan He wrote:
......snip... 
> With the change, we can see about 18% efficiency promotion relative to
> node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> the worst.)
> 
> vm-scability test:
> ==================
> Test with:
> usemem --init-time -O -y -x -n 31 2G (4G memcg, zram as swap)
>                             one by one:      node based:      round robin:
> System time:                1087.38 s        637.92 s         526.74 s     (lower is better)
> Sum Throughput:             2036.55 MB/s     3546.56 MB/s     4207.56 MB/s (higher is better)
> Single process Throughput:  65.69 MB/s       114.40 MB/s      135.72 MB/s  (high is better)
> free latency:               15769409.48 us   10138455.99 us   6810119.01 us(lower is better)
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>


This tag was missed for this patch:

Suggested-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 31 ++++---------------------------
>  1 file changed, 4 insertions(+), 27 deletions(-)
......


