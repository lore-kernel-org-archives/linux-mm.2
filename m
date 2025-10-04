Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63BC1CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 20:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A68B8E0006; Sat,  4 Oct 2025 16:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E988E0002; Sat,  4 Oct 2025 16:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB2B8E0006; Sat,  4 Oct 2025 16:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B23C8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 16:34:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AABB7C01F4
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 20:34:22 +0000 (UTC)
X-FDA: 83961584364.24.A39F587
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E46B140003
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 20:34:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=rKdqfEqL;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759610061;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZggFdLpD3/YFEeibxFg+TFexkOTsM2GqMFAjK3D+I0c=;
	b=ByWlqq9GwIFXEvUt/5hmOV2ZUTwrQlO61Gs6b8XUC86iiFewsjB4QvdZeEwISynQBcH9GI
	kcQ1/3U8KqL7zYgp39yvxfkG7vWhdKzZCqoOCnq6aCc1hJdHT1KUJV4yYT5wFGvYRwacGw
	HgRrwdmNG+1M3z8qK5odaQ2D06Es584=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759610061; a=rsa-sha256;
	cv=none;
	b=umTpTAz3ExwbOiqyjff4Xb0gtB8kcuzHrXCFl3CRpXZitvTJGYmuZXtFTJW5fPNoYKRpMH
	MHJ6H9U6z/3ICpGfYdtpPn6AyZKyY1eQWeXRJ2irQnFgSkWcKWjBs1xVQj5ninWnuQE7j4
	TMNHIJYjyrb7ynAMmckbQE2J5bQASqo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=rKdqfEqL;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=ZggFdLpD3/YFEeibxFg+TFexkOTsM2GqMFAjK3D+I0c=; b=rKdqfEqL1u6x8IASpFEV80tLr2
	Ieb7Fe3/0iosGk8pIjvFqVQyNyLnXwbCSsC/BqzkHy1YIY/RZ3NRqeP5hLHGKrm5BA5iMVR37JsyY
	mMIKPcUjQ5+f1RTJww28Zz0jCRqmvFwNoE++LDMcNl8nJuqcF9uL5ejyvTVyqmca7DOAkSRg4rvXm
	sOt+R2bgDmNoPSAa8dBv1MVRJAd6kIFEJqZhqgG/RfKhKmAoAr7Kf9NkZx/V4QH6xbMWMw5EWkc0E
	mpfGyvSSK4PT3q/eEZVVr+393aflnTMd00+P2ge797A0PRSl3VC5JtLgyo22i7prZRpo84NQRVRv7
	9gTqWDcg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v58x8-0000000F0jq-1sVy;
	Sat, 04 Oct 2025 20:34:02 +0000
Date: Sat, 4 Oct 2025 21:34:02 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
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
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Christopher Healy <healych@amazon.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
	kernel@collabora.com
Subject: Re: [PATCH v3 03/10] drm/gem: Add huge tmpfs mount point helper
Message-ID: <20251004203402.GC2441659@ZenIV>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
 <20251004093054.21388-4-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251004093054.21388-4-loic.molinari@collabora.com>
X-Stat-Signature: afwhh7o5cif3zswrej59axtbm1wfrxyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E46B140003
X-Rspamd-Server: rspam10
X-HE-Tag: 1759610060-640500
X-HE-Meta: U2FsdGVkX1/XzTfb/87x6uUhhZxs4PNR2yyVqPLOz2VpxQi17CRUvNzn3e+7mI8gbhqwDWzLbkOIm7eTy5ZcnI2IXCRwQlE7G/STh1cWRE4D+u+u35wp8ZgwKDSy8f7UcNh5YtQWUycA4Py8+7sQbZ/hBSD1h2DX+rW0NvR/KjsRJTFXD9Vct0VF4wxH0ZhzxGFloQW8/DdwDkOruvsmQFYLZHpQkVCc97g5p83mUwa6fgxOEngzVU96Dt0AroucMUPaSp/xnYID8tKwHj1VhFYddhgXxnrOftCiRy6hgEevDjBtLO/lWAKyekhJiqEFZz9BitqNriDZKGXYCxs3FC8+TMSgdvDqbCr773iBNfttytkyP8uQdW22x0qzxbbDyPhEo/mMixJq37GG+nLE/7T/1XguCpMFpqC+xHH/9ooaC0ngfbSXe2NW+0/IaAQeoGx++m1Bw01+0ezJN5RNIQeP5wL6zX/XIyMFhhwg0uhYXkI7sctjkr7lx84WgYQTxPzSv7B2gr+9xsSR2v7oxTojKKp1GMtgO+vkAFysbH4dBbSZEegmPutZQh4M3+/VtzH2igcGqPg7jwf69nbpxSZ6nxe48vmjZ+XkAND1Ru5ml0exZp7FcmgSknzyMqx9+iSJKvMc854YrDh1YS/2KKo9XCvt4U086zYQHMq+a9hRhrDti44gZxooXaxlWhMKr0J43Jg+nAQo4pDw2nF8B0FrWP7tG3VgJXSKODvEcCar7Moa6RJe8NAPWCYQyhFJwtWwCwb7aHN1u/7C90TaaocZXn5XrHciKOiM17+jY89LGyMM2VIP+QLYj6DJo2Mp0Vxmn6DPlOd/gDSF8Gnj+jC4mLnmpjQbBMbkspZnmUsHla5DrhDCfuLolo2yT0xdMzwBUktAl+0q2OgbsRCRIyMBeRxpV5r/bJ2nlNlzMZZfP3TXyodfsJTJxTBh8CBurLkqsSihaFG8BuWJgIA
 i1UCK8pe
 Pn/BNVPe8PRc0HMd4sj63PN0OSG3kIP4G8cHxx5VtVruosxUrYd+JXUi5ZRZN6j214CeVmA5d07qA8lbMnBTL+DhO2+dBR94jlJQ9mE7tNiCERh6XpTIWJosHCLpYoc+wa+8V7N9XkOOl7USCaHFaHZT/qc47LzLt03KJDI7dRXDhIkNFWDoCW9lh8H3pdnLGplnRqz1vhBn8QbT0UzTKpZJERICFVJb3rWYuj7Wf1KfEp3rYG1ogxFwpX5/mGyfHUxBnPDpyhHAjtt8aWvEcAnjPELtFNzB4S+nEHrA652jKNHfDFyMGWx8XTFpdMYD4mMATBS8XOYYIjW+ddaN60R03A5N6Ut+74NEu22Zfu7vLFptkePESlufKXFKDZ1v9jKanVFmLrupNai+mS24wVGgNqsqICkJqfKjGeMFF4rHR6Xv6S65gSydiFXHS9pGCBTENtnQh3n+/tz6hHs5hGIlseQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 04, 2025 at 11:30:46AM +0200, Loïc Molinari wrote:

> +static int drm_gem_add_fc_param(struct fs_context *fc, const char *key,
> +				const char *value)
> +{
> +	return vfs_parse_fs_string(fc, key, value, strlen(value));
> +}

Documentation/filesystems/porting.rst:
 
**mandatory**
  
Calling conventions for vfs_parse_fs_string() have changed; it does *not*
take length anymore (value ? strlen(value) : 0 is used).  If you want
a different length, use
   
	vfs_parse_fs_qstr(fc, key, &QSTR_LEN(value, len))
	    
instead.

IOW, your drm_gem_add_fc_param(fc, key, value) is an exact equivalent
of vfs_parse_fs_string(fc, key, value) now.

