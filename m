Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A827A606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 18:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LAqonWv4
Received: by kanga.kvack.org (Postfix)
	id D12C56B05B1; Sun,  1 Nov 2026 13:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC32C6B05B2; Sun,  1 Nov 2026 13:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFE86B05B5; Sun,  1 Nov 2026 13:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A13FD6B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:34:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E6C6140A32
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:34:20 +0000 (UTC)
X-FDA: 85387400280.22.2EF994F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3038C0005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:34:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAqonWv4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793558058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vmoWTKpodF0sixBD3Bte4QbXRriDHgbk+I5LKRP+ucY=;
	b=yS1eBOzWi8H9I83G+ItxvRibq9e2fVqatAANIvsN1b6l5/dYp4PCF1C/HMIrZBw9mX7Qsj
	rmewN960dZCQLtUY29dhSaFQm8LpQ8ImT4wMF5XKMrMKTU1HOsbZTSjhOYZ3u5/oxVItuf
	RvY3yBKuPfGWmQC7VLrTVc9/26DRXBo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LAqonWv4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793558058;
	b=5mgUxu86PpvtXoMmpnJeYHH8h66k16BnXvyFpnGS9GYTDoXzpYzzoAahc/Vgs59BEyG/cC
	ELd2P/yZga71YZRTYI8MZghKoza66p26s4QMp7Cd8unmzP0sn9kCISi89WlfeHcdK0s6zj
	dfFXWmxVQ8sWNtnCC3wjkocaCdE2Rx0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34BC4600D4;
	Sun,  1 Nov 2026 18:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1151F0093A;
	Sun,  1 Nov 2026 18:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793558057;
	bh=vmoWTKpodF0sixBD3Bte4QbXRriDHgbk+I5LKRP+ucY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LAqonWv4/N7g4i3hDOfoLq0a6yhIonzlH+Zb8HBsVvhoBSBqQc0BfmHVwJl8U5NvW
	 vwnoXAtWuGRsM8Xw1PSr/CKYtB/5G9nCURN2r3MqtGNwY3e2+Ul158+xhPz+BUlwL2
	 1WIcm6iGrs5GaDSuSclgIo5mScesPMkN6gB1suDAf2gHTG3p3DOv+1V8a9fczc1J1h
	 14NNfc39ZIRovlkXAKnv1cXgdBW0T1Im57YrzAfxGpT03PVwdyj+gC6+2lIS5IUObU
	 9yLGCYakHYWK6SKULeUNa/dY6WWSDbF8cfSTT+XLYZTEqPJNMeWYz6ZN0T43YeSVKn
	 pZzUfr8/Mh7FA==
Date: Sun, 1 Nov 2026 18:34:15 +0000
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
Message-ID: <aud4gPOUzvHtLYnJ@thinkstation>
References: <cover.1793253633.git.chris@chrisdown.name>
 <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name>
 <202610302115.8C7AD110@keescook>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610302115.8C7AD110@keescook>
X-Rspamd-Queue-Id: A3038C0005
X-Stat-Signature: hew6sqkyjqxx5b1ppffj9oqegx4no3is
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793558058-425338
X-HE-Meta: U2FsdGVkX19VFvaWIN9+YgvAGRIEHXRX1veUHbdHHYsi0gS9/zWHUS3hpvPdPI4RXb0Z6lNbJ01dfJPvI6Vc699UFqaPbLVF1ksTGoknPLg3O8x02D2I95oqNBEpbKVckNduMQMgHbRSgSQ20yNScCp8ucTnCdfHnWEDYyECYB7I20g3+QGkmCKEoQH7ptS6vvLTtaW5KCj9kHZXq9ffVQXfo1WLhuaPCFws91AYkkCUA12LSPgo+0YdGhsD4XeJZbNcspXyOBLIb3Z7khPnPxZUOtyV21CMq0O8eq5IecqZr5l41bFykg1Tzk/P892F4I7Zub6mkboLpykO/IaRB7ytcowk0coNCsJ8AOi3+R6Rq+SXq1Yk5lKOP6pQtDwFICEIQIVj20iRn2bO0VPMCCHgcUdDkmJd/TImYqt0aERtbO2nzlfGJZgSNsXjZDntBzoydYWC1tWEmP1Oh7x5b8iN83yyJNUNml/tIN8QupBPuw4LRAAelE4hNL9Oqq6+jh8IbgiiJ31iEbC+wnZ0Hn3G1d1JYD6ZBHsL8/TApitM3wOzeM9boQowEFYM+kVLquKiKkqBGmmcLHfg68f9xsAVolUfZVHBcKh9d0JQhTilBGc4WSJLG2yhcMMgwi4R10pn2stlw9mRmk/M4PuJUzV8aDYZ31PkPFL/gFIpN0ux59UnbZYrWvyDH9l6cn4DiWZtRmzxkGRAd8UYTQueBTwXcInORzfGvogSsUMRv58zEMnVDxZ67XMQcVJ3IFkRnPK2TlAlbHM1ibHGUILGSaOAETOoEuebtg6ahL+DGywyp8lEnQwCzERfV27NqkRnjpb2LH+UsK9aTF662aWJYmYvPx1/C2WTA/8z5uBiX8jEcthQyEAEZwc5qy04puAAN7y4V9I1mcVxq0olxdPlZnfPbOPbhFNHxgOYIQjWZyxPLXK3UjBLrJ3VY+mAme3hbrkZd5RC1/IavbydRJP
 SIehqey/
 q+wiAJ68zUhb8c6C2ynUSgpVFdDzy1yEpEUVqixp6FYoYsuLn9Vt2YlqMMyHY0mChSVEnM3vgYuefF1jll+fKeLDVOvVYZHlbGQl9xiQzHgJxDoFFEKgmsmXZO7psWIg7gmGlwBEtoHgSRmfzOyFqFOKDG+ltLwKAksTRb1OYFY7tEaSQ2cu9cc9Jbsp3ncTQCDk4UY3AOGKj3K97feWWnxnCxGoNHkrcGExvDzredQT9cc4/O4O0nrfBRmTctcvVvzrkyUz0VXQpauYSR54Lkd6ZcfaEOBTqpI53rmmR18IujniR278nMN+5Dv2HZR6rYhZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A gentle ping to Kees to hear his thoughts on having a bit more
coarse grained boot parameter e.g.) `slab_hardening=` to specify
how much performance/memory is worth sacrificing for enhanced security.

Quoting an email from [1], Harry Yoo wrote:
> On Wed, Oct 28, 2026 at 11:27:37PM +0800, Chris Down wrote:
> > Harry Yoo writes:
> > > If we end up supporting boot-time parameters for hardening,
> > > I think it should be all enabled (or disabled) by:
> > > 
> > >  slab_hardening=none|light|full
> > >  # please feel free to suggest bertter names
> > > 
> > > none: "Turn of all of them to maximize performance"
> > > 
> > > light: "I'm willying to sacrifice _some_ memory and CPU for security"
> > > 
> > > full: "I'm willying to sacrifice more overhead for security
> > >
> > > IMHO more fine-grained knob for each feature doesn't make much sense.
> >
> > I think if we did the 4 knobs that is a good idea. Given now it's two, I
> > think it seems reasonable to keep it as two separate knobs unless you
> > object? Otherwise I think given it will only cover the latter two, it
> > should be something like kmalloc_isolation= instead. Let me know what you
> > think.
> 
> There has been constant, steady efforts to add more and more hardening
> features over the last decade. So I'd say slab_hardening= is more
> future proof :-)
> 
> Kees or Marco might have more insights on this.

[1] https://lore.kernel.org/linux-mm/auIVIKxjrdXIaUIY@thinkstation

-- 
Cheers,
Harry / Hyeonggon

