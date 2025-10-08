Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3783CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DE2C8E0051; Wed,  8 Oct 2025 15:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5908E0002; Wed,  8 Oct 2025 15:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2708E0051; Wed,  8 Oct 2025 15:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3928E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:59:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BED3A5A20D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:59:19 +0000 (UTC)
X-FDA: 83976011238.01.A7C8F49
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0DEDA000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:59:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="EV/cXXbs";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759953557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bQgR6a95356dPsVrbrUk33Cag4UDOjeL50G3GytdiSY=;
	b=cWkkjNwrMLwk7Tz4UPPaUMFC/ekv00JlTAaYO39J2bVTsX7sIXH8AaFPnGQugv3p6JHKx9
	4tYlqC16r3+osfNb/+YSdDQTJwdFbNHIyxvPqVLOGDlt68JXxQ94v6hblPQ8SBMN7A0WgM
	RMRGfGureX3ZyAw8A8oSyQo7uXVWQOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759953557; a=rsa-sha256;
	cv=none;
	b=RdOsEG8B3WkXjrWzITiMgITMCkOpOQng3hjVIv29FGRFNDdoXKiuPab8756zIAd412Sm4c
	9r+RemxgEGKIhxAqcJDAW9ylBx/wYSGgdowgqcIHKndxQQ9cxaInoty6iSMCgh47c9LS/J
	6d3jZe3KQIp/N8WHNhBk8AyvXcAPQcs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="EV/cXXbs";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-7946137e7a2so3413056d6.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 12:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759953557; x=1760558357; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bQgR6a95356dPsVrbrUk33Cag4UDOjeL50G3GytdiSY=;
        b=EV/cXXbsznL3RXayfT9GcJ80bFqDBjDpk+WpMGjMrH0mZ7MuDqsnpGviaxbkgTnIPY
         WPlmC58tVa1pq/88D8Uq0wTNqCBxPW9dmzqqRl4ttPUWL6LLfh0/5yIaJaB2yEIvs3yv
         N8aNXglKWcNwUSkb5F2WaEehs4wYj78w8Ydwqty01gysMZboXe9A4yb8VGZdhOJmjgvt
         0qiZmlNTTST7dBuNWDfFPQe/IGCb0I2V7F3LtqAzWfilrY+D6N04P3YWNCGd1mFl0YzS
         TNaYfHBICKJL9fGzQB8ojmmt4GSGl8Bh4XPFc6NrILF+wop32qBmkYGeJr8/XzwaqyUC
         zuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759953557; x=1760558357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQgR6a95356dPsVrbrUk33Cag4UDOjeL50G3GytdiSY=;
        b=fP6AlSLKznDRDIQUZ3OxvrtKbHTbu2rXJZyRRvOk796q0pVUa0VJJ46U9slX6Jon64
         pj4Ztmo9jCpTX6ZGly/9PQlqnkqGdE849y5/OCIfjmhnyfGxNFnIwL22ezQXc4x74/mK
         tIDKG56TWv6xnjhAmtZ+uNVYWTbY6NN1Rr84xuGlMWQ4N9vxm3jdaw2z3ZnYKOhTTrTH
         Dw3pLVBd982OY3VblrLlH0HPWVOVPErbDh1Dbd3ZN2ItLuqAuLYK/8O913OagGGbz9ge
         ZHvVcfn38VBiAJZ+zAoxnQYg09rLQPKNjEs2lYehTozQzoHBO0wah5GAi73yvfKEl2cV
         wF7g==
X-Gm-Message-State: AOJu0Yzqzh0B9z9cKthD2A3YaUNQVYO0Px2npgPBs3aU1D/diNfJzEP7
	nbPsVRn1o0Qqa/sbJnwCkjPBZGzBh9VFN3JF6AvvL6D3lEeqAaYFrrRNnX8vHJkQJR0=
X-Gm-Gg: ASbGnctQdEyiNLBzTRYHuU0Vt9a5GOKhOjcON0pdb54KnB0gTyzIBejVVCreOW+Xr9H
	tmg1m4QnG2CpEag/kK/R9x2iiit1sWYjqP+XNtH7KaixnGLyY2JWass8EqvZ0LZdKqhghNGDPPK
	U7y8lkWip8pcaWOOGFUpyWj4VDbUcS2mHK/7ZcZjlYRer1rQp5XC5wjr7cAZz8K1pzfvYc2kOb5
	Aqko7awKbzzC26ZMZr9JG7m1Kq8WGV9uLdFYBMiAppRFTs/aVm61MI3osnYh4pkSJ1NYW0Tcriq
	xp29DNWsg0+VTds76rIFs4OHI4uCVg83ypfRAiCmNSpG9D1ZX2UW6XcIZee7KTBxZxL4cIYo5An
	1IL1jGHNC+NQdru/sxjEUNPAtlQ6gZTQdWifkDHZuwRXSMfTB7jw4mWUBsR1NfMqfzMu+UV6qRq
	GWWTvER0oGsshL2IhbzpmdYfRAKiVe2y7Qdiv9t0+u
X-Google-Smtp-Source: AGHT+IGOIjFNFX0UWzmMPfhHtuIlkaHHvw+0tGaxRx+44ltIOKx7Dm5ffks6WimcIFao6ap2lPWKnw==
X-Received: by 2002:a05:6214:410f:b0:77e:aba2:c8a7 with SMTP id 6a1803df08f44-87b21000e61mr61430946d6.13.1759953556821;
        Wed, 08 Oct 2025 12:59:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878be61f6bcsm169735486d6.65.2025.10.08.12.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 12:59:16 -0700 (PDT)
Date: Wed, 8 Oct 2025 15:59:14 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aObCks3bwrT27CIu@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZyt-7sf5PFCdpb@gourry-fedora-PF4VCD3F>
 <f4d0e176-b1d4-47f0-be76-4bff3dd7339a@redhat.com>
 <aOa0UPnxJVGvqc8S@gourry-fedora-PF4VCD3F>
 <b6d472ba-e6cf-4c96-935d-88c842ab3cd8@redhat.com>
 <aOa_A_i1HUt1wzCj@gourry-fedora-PF4VCD3F>
 <1763f0d9-37fc-4c3e-b31b-2cfac33d5c95@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1763f0d9-37fc-4c3e-b31b-2cfac33d5c95@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: obbp36bws1fyshn5h97actdnsa9rkpj1
X-Rspam-User: 
X-Rspamd-Queue-Id: E0DEDA000E
X-HE-Tag: 1759953557-512616
X-HE-Meta: U2FsdGVkX19MG6ryj1AOs6KXKIt5wqRiEkvLUyGBkTZcrdZEtuSCjWtuIZ1ziUX4yG4M7R+dYsTDnMGwSEYEm8Rmz9mV8hGwhJd3McSoOYYI25laB+FCerOVAvCGUg2IQp3wBOqBD1FBX6mvHT86Bg53ymEmTQ8cRQedJVIjkl8cZTU9g7OEd25Jlu/mMseJnaciSG0UHVpj07SozEIydO29551EE6iBTiHWSyo9BasaXOk03u3MnmHg8G7EoYPPRty/teo6gQ22SMTeRmAurlylO5prWQAXeDgtw5sl6eQm79sk9uNQcRskZDyLAwqsLqfPHuWZAAJZ2P1wYVZMcdDEPVyAJ1KFoDeRrF9oO8XcjKY8mJjdd6chu76L4XsWCQfY1K8Ki2vPd0Pii/8Z7LZq4JZDEcTpD1BQNkZTItKxv9yoAxfhwM5n6JkPlspkOHDmYCscKSIXQjJlckSRytXoU2HT0h1ODFgj1F97MqBbZue3Ke8/Y/lhazqLEE46E0bK+XHuFtHLJxszNmb2EwHZXSwwwMAUL0NSUnnOspBgRkgD2QwxEAmABTBP5TtDgBZGcyOqTrE2L5d5uelvvA9Zv/c0zgZOQc0I4maihqCGKpopkN94gYUWyZdyx4HxO0Qf4oiDmUrCS24ptqN39jIciTCKGeaGozCucBGDFt30SvQ5oXB6FCs0ehkFDQHrSYDlW6nv+SkFk7LTjbTivKBxAyDhapgxcMtxlMgQ5hI6H/dql5XicWSQnJPR0uIuvVr1TV8LfsCRHk8SMtw1OyyLfJKI+o31CRYgSQ1EB8rc2AUBiVlk2XgIIRfJFEhdftYnHD2Alxm2T18iUpmq4klflQdEcyG9pTUxYFkNaGtZp6PbegHxJpAgnvtp0UsyzTfZxYmInF3vR3X52lhuuDfmq9Ia+R0rPqzudJuzIA/Ue+gm3QQcLQRvbVrSnYQ+/n1uonwbpxict7Cyr4U
 ClLou6Le
 AuGwNMHnxkz1WYR7IHidkjSDUo0wkvynRDYVy/YZ2F26PClg6/FACZT3pWQdsO4uowPb9ksnDq/23AHyd90eSWC7XcwkAAhUTX785YnqceNOUaMha38Iukak/HFAqD/B1nrJk+sukaHK5as9IrentIlJIluaW0RZ9SPFuHYjr/i2bEU2MSvrlSu/sjVxW10J9UccqoOqttn7rRO7kcLjOres+31IvNc/8VWDBqtfilQ9pJrmf08kWT4hF/1c5/HHC7xpmUCknt2+5P3B3ALE+RK2XbsBd3xixx40OBjgrD98dmevaREpSPysVuGcrXMWg+n6RiXyE52/0pWgPaGuugR1BNHX51g5Bbh+VuA89nQR1znyMCq18RpOy7ny627hiSMSl8WbyigYE+oXNCyaTWsf5GC/w3Iml47YoXoVMStzivklflOY/IDT+pmdsAB5JeRMT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:52:09PM +0200, David Hildenbrand wrote:
> On 08.10.25 21:44, Gregory Price wrote:
> > On Wed, Oct 08, 2025 at 09:01:09PM +0200, David Hildenbrand wrote:
> > > > 
> > > > fwiw this works cleanly.  Just dropping this here, but should continue
> > > > the zone conversation.  I need to check, but does this actually allow
> > > > pinnable allocations?  I thought pinning kicked off migration.
> > > 
> > > Yes, it should because longterm pinning -> unmovable.
> > > 
> > 
> > You know i just realized, my test here only works before I allocated 1GB
> > pages on both node0 and node1.  If I only allocate 1gb hugetlb on node1,
> > then the migrate pages call fails - because there are no 1gb pages
> > available there.
> > 
> > I imagine this would cause hot-unplug/offline to fail since it uses the
> > same migration mechanisms.
> > 
> > Worse I would imagine this would fail for 2MB.
> > 
> > Seems like the 1GB limitation is arbitrary if 2MB causes the same issue.
> 
> Yeah, with hugetlb allocations there are no guarantees either. It's just
> that page compaction / defragmentation makes it much less likely to fail in
> many scenarios.
> 

Gotcha, well I am open to suggestions.  This chicken bit here feels like
a sufficient guardrail, but I'm happy to explore the ZONE discussion
further if we think that's fruitful.

Joshua Hahn (cc) did privately question whether zonelist ordering breaks
for such a configuable zone.  If memory can't live in ZONE_NORMAL or
ZONE_MOVABLE, but you want it to have some combination of attributes
between the two, it can't also live above ZONE_MOVABLE I don't think.

~Gregory

