Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305E0CCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA5C8E005E; Wed, 15 Oct 2025 13:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86AF58E0005; Wed, 15 Oct 2025 13:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75A328E005E; Wed, 15 Oct 2025 13:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDF08E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:28:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12CD51A0256
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:28:16 +0000 (UTC)
X-FDA: 84001032192.16.194464A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id A02C980003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:28:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="O/AIKjGH"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760549294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHD1PbWJgOF9XOuL5HA73G273J12JtIymtajQ7fqsQ4=;
	b=eCKR7zTXKvEu+xGDsO5mXHXS8cVuQTpb4aqJr81x36WwPQQ4as5hb3w0q5gqeVOKbH1sc8
	40uZd4ppY6hnylPFXVuDaBWXdDubGkZvlJTs8pK/2yP+mMSarBTr9X9BreGBIzq23RjRWV
	Bf+mpPuJ1U5QiVfDoEX2F1rlvNj7q4U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760549294; a=rsa-sha256;
	cv=none;
	b=7PeuCk4SWcba1B+31z7yAnuHcRE0T0a6cRvtd7UjRL/C9FiBPmoRfnHHrCa3YkgQkfkFzw
	VYgQLiy9dnkWS4xgRli/YEiNklJKC2K9UEDn3SgGVNQcLYtDHU2lZTI7I2QmfG2P+KIOtV
	vAVwB0+UxfOxXOTzvVO0MGaM1K648G8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="O/AIKjGH";
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=OHD1PbWJgOF9XOuL5HA73G273J12JtIymtajQ7fqsQ4=; b=O/AIKjGH3q2vAiI35ZMnFpDXL9
	C+s4LMohbjn1T1gowDff1QATHCAKFtMlK/vQLkE6V3EMtM4PyVK7+qNjjH8p/SMgAOrlYDh7E5JNj
	s6YHmSgHX3PZeq5i2cQTrpXa6f/EsBMgS+kaQRLCyHVc51UqP5td4HDZnJ8pJHHOP2BQCs6Kdb3dl
	hDdhTVC23HoZ8cjO9DV1mJas9/6i26NP5x/fG5klzP8VqwqGrFQpNOM+S4KcTQZO8AUi9LAwkUeyi
	W84rWDUlfmhJWd6nz90Jtg0an/C/x6jqBk720u/RVEgVMVk7m7XzfqEOkFEtR41Jp2xUsiPZ+01/Z
	FUrLjK/g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v95I1-00000002tYN-00lF;
	Wed, 15 Oct 2025 17:27:53 +0000
Date: Wed, 15 Oct 2025 18:27:52 +0100
From: Matthew Wilcox <willy@infradead.org>
To: =?iso-8859-1?Q?Lo=EFc?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?iso-8859-1?Q?Ma=EDra?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v4 03/13] drm/shmem-helper: Map huge pages in fault
 handlers
Message-ID: <aO_ZmA6yoqbzTKt9@casper.infradead.org>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-4-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251015153018.43735-4-loic.molinari@collabora.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A02C980003
X-Rspamd-Server: rspam02
X-Stat-Signature: 7i9i1xsqj5tkz3pdjp9dq6zose6e4w89
X-HE-Tag: 1760549293-648525
X-HE-Meta: U2FsdGVkX1/OMhgu6W1eWS7Lihfx6DS2XeuTp1LRGyBJ4T8tVHzRP/28pIIoL3SuIrWtWWMgbz3NG4qfuqJlPh0C8YNHcktxqZ2xa8//IUBrxHi8NscmyCkwIQq6ILcihZQJ99EkQCYupzIC61+1AFGq5Y0sj61druVFXo+xPmxjSiCcvAuGmv8TYcUjKPY8r0oh8B4R4m5ZFTm+78p2yn2j//3Ln4haKlGW++cftxgSRLGWtJBbijf7BIGoLZkU0bG3kIzi9UHLPUa19nCb7g70K/3xIhx3pdz/cwRq6CqGBm/k6xOM2YTlnBaw1Uikw6nTUIVrj1qupBx2tWFCuuYWHmTEN6GZ/M4llSsUNZDvk//JiIMsUeRvGCtlJzdK45pi7UODoMpbFyqF13pL5i+s2MOSGxYEI6D+Y+HckJqCTq/78Cb0vz2Y89Z3FZ5O2IJznO1koZFX15eEo+yS5XwCCVd9Y2NoikdG8q6wdUzdgXX68XM7hyOb7JdrPISBIkh7D2itxedXvMW4pRYSPj2Y9frQWsVqAZMhZdXpR/RlY27ieajis8Nf62Y7yuGEOoEjZCWRrXGSc0c8+jV2Mw2GxPIesc4LcKuac493wwJ2VXemXNY1ECwaOB6g0eCLo2bYm8Qlsf5QIJ0fQmy/lZ1UvEYrZE2O2WcBGA4PLluvuE0wHzmHmqQWc+uAOMfSNCT1YLwuMVQR8L4JxLlxI6aQRUHaWN80Mni9Up7Wa5mPzvt/msdmIjtWZegq0Olg6Em+aGN0QpzopQcOab86RgfcaJ6ZU2MtnDfU/Hb60mZiTXZHLFiXM8lVXfv+aA0s2lNYYpzJedER9YnxBWeZjBf3TzMzh+F/8YMHzvZAvjHnivH6PaHaZ88YkI9Gxn3+do1Xnwb77aCVe07YW3AySRUuuLpUooE5x9lxr1vU5WFWEUzI/IlJMLPkB/adasaHNGD+1tO/rL/cAfcTchP
 uXRtN1Tq
 LQypqZuHKurSfCQyhVFLcX/FuF6iC8MoBPGVIkcnKzM3mk6LQkI4S+DO/Jm0Q7eIkBorZWpcfQ+9faKgXTR9wXhwlE3YJ2ynXvhHnJJVM82FDZPOds8ka/sJeaNtdSKLNXfgAV60Wzd1BWM7zarWQ/4+T6ZLnGAReieWOk3bO7C8Cxe5KbkEB0vWFUjDoWhrqdlpf7c5sT6E+SpQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 05:30:07PM +0200, Loïc Molinari wrote:

This looks fine, no need to resend to fix this, but if you'd written
the previous patch slightly differently, you'd've reduced the amount of
code you moved around in this patch, which would have made it easier to
review.

> +	/* Map a range of pages around the faulty address. */
> +	do {
> +		pfn = page_to_pfn(pages[start_pgoff]);
> +		ret = vmf_insert_pfn(vma, addr, pfn);
> +		addr += PAGE_SIZE;
> +	} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);

It looks to me like we have an opportunity to do better here by
adding a vmf_insert_pfns() interface.  I don't think we should delay
your patch series to add it, but let's not forget to do that; it can
have very good performnce effects on ARM to use contptes.

> @@ -617,8 +645,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
[...]
>  
> -		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
> +	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
> +		ret = VM_FAULT_NOPAGE;
> +		goto out;
>  	}

Does this actually work?

