Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E504ACD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5F56B0096; Tue,  9 Jun 2026 11:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD206B0098; Tue,  9 Jun 2026 11:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA746B0099; Tue,  9 Jun 2026 11:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223756B0096
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:15:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A5E5164E19
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:44 +0000 (UTC)
X-FDA: 84860723808.05.8701AF8
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9BF5C8000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lUC/vfi/";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781018142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01y5Yp7Lv2fsZ0TiFN6M9m/RLD3dl7/dyTYKRdYu1dc=;
	b=UJsQSB+bTXGkQmhAiXuPD8okYSVNdWQfEBQc0PrcuZ/gC6fxu1EoPihMRxy9gA+u2Lsywg
	yH4aXS5ZuQy9zf/zMTJUGYSovDfuIfywXA+3ZX4TiYrwnkxkcfToCqM6PUNt72AzXpqReA
	Tww3j66zcqOYCY2InC/GZ6srniNDFN0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lUC/vfi/";
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781018142;
	b=I/kIsoetEpLAuAnjY/yqJ6xUu0/bRxtZ58vTM2jz1o/qyhbGPi6SaK92P41LvflfHevgON
	zmpU3280ko46jMTPJgZeHzwzdmfwNuW5XB5hG+ztM4upLuSe5jJSuOmNxCUlAy4SnNLSIc
	ambhz0Fl7CxjnRf1e5j7H6hzBsm8Q58=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9159da9bba5so409053885a.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781018142; x=1781622942; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=01y5Yp7Lv2fsZ0TiFN6M9m/RLD3dl7/dyTYKRdYu1dc=;
        b=lUC/vfi/B22BLSmiCijmOXRCsoW4rbKEHShPtn62ec3uIl6ZR0GqlaFba28M6cz0xm
         qHfOFI0/pUQ2Ed3zNFYPRVqiwtkNAnilEYuVSUVAlvZSIZ/yy6IHqIIfKfUIO7sW0K26
         ukxP+5is3hOKGQIM31xF8/UbFagd+AADjvvldeolB+3U3Wif91KUE/RLTWpAFUpAuETo
         0YOIAjU44trgk48GQkXbCiiCXo0ZUS61JsRRth+ywZLBmXEnuk78oiplrgQXdDmSEjs5
         CM2F6lmvAYlsgV5iUQu+jxa2F+yIpJxlbJ5921h9wJEXhJMDoTokvgLGMM/CBzS9d6Fb
         G1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781018142; x=1781622942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01y5Yp7Lv2fsZ0TiFN6M9m/RLD3dl7/dyTYKRdYu1dc=;
        b=XRJ1n8EZLDFs6v3siSz1MSclPcH6OCvhPd5DC8BwPDTUR14eoPNwL6cmFw6KZIBe12
         mjKwN64xL2YiW2+tSXjsP9z6lwwWz2yZw0WeWl+dBH01ZKD5ziK0OPeL3S/1CtLIR7Kd
         dET4Vn/3rgiMsV8v3msWOegIEX531cDBqBMtZcexgd6uNpeesYqy4esk33TlHZxXtAx0
         3jQmIVzyi0VfBSrmatKMr41ZL57ZyLV0dzqLaXKv5t5X42NiLaW7BQYpuatZ2OhY8for
         ZuPVovLljNUKZjmistwb9k4t/+pxmCtiW44Ua0wRSAllzopZiQq6nO6XzUa/emsncmVP
         pU/w==
X-Gm-Message-State: AOJu0YxdimBtBoEMJ1VNSSEZ0eQ8g/qIMzqshDIfQKqNE+EUyIRIMk4O
	VVAvNfGDmCoRF/x020HLwj1AFvl/C6h5g5uEEtFxBX4rCC+VEmQm99iyUytwLVecD/U=
X-Gm-Gg: Acq92OEMEczraTqpte0+1PGoTILkjiP3RYc2fep1B5y1qbYrqTFCnktznZtlRIMjrVK
	bct2BIRQuq1Cg7gBTnxUKEx2u+RcN9mY72yvs9dOwBM5sJ/zm7VzOBXHHDyh/gDI5dtbUsUzsEb
	/DQf/QAMF2cs1wemauyzmOj4oU1bNctlmTGswCwCaFFvFvtKYIswuu35G8ckTczLDcjbR60VnV9
	JHpWlwA+sDOAmu7cEdnZp+nbW57Z0XAh36tB+wSe+dvv7r1a8YSXiHtWAcLrjyVCYV/CmtqCjRw
	2mLsiy9Cpl0e7mj89Jd+4DWZbYWs6SXmFo4n4hlY1Udt+1HDIx2Idhcim/EH3hI0ALUIIxgWyvS
	0C2UW6pSNc4vqyuk46d3QZljyEjY0Stl8PDX83MwgAIanyAunVlrUjn2VpUtDriEW+8DbQSzDSZ
	RUr2gekX0tLNAv8XRJYe+3ayIQ6RJj9QUUSPo3faTEFajztbA4thss55xh2JI0WfYoyGsdccHhG
	g0vImuPm92VyXF6Tg==
X-Received: by 2002:a05:620a:2547:b0:915:9972:cfc with SMTP id af79cd13be357-915a9c7bba3mr3335701585a.19.1781018139752;
        Tue, 09 Jun 2026 08:15:39 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91589ea0bcfsm2153439585a.0.2026.06.09.08.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:15:39 -0700 (PDT)
Date: Tue, 9 Jun 2026 11:15:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-cxl@vger.kernel.org, linux-kselftest@vger.kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, osalvador@suse.de, shuah@kernel.org,
	alison.schofield@intel.com, Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com, apopple@nvidia.com
Subject: Re: [PATCH v4 5/9] mm/memory_hotplug: add multi-range hotunplug
Message-ID: <aiguGeKKfSOu8haT@gourry-fedora-PF4VCD3F>
References: <20260605211911.2160954-1-gourry@gourry.net>
 <20260605211911.2160954-6-gourry@gourry.net>
 <b62e071b-9dec-423f-9b4b-e3c34ea0a409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b62e071b-9dec-423f-9b4b-e3c34ea0a409@kernel.org>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gh163oysqq68db5s1igi4ggm6wpkbbht
X-Rspamd-Queue-Id: 9BF5C8000C
X-HE-Tag: 1781018142-758887
X-HE-Meta: U2FsdGVkX19nkQgCm8AZZJWNXUO3Y2p53eMrwznbyw6cUe+gNjGNcsv+/Zb0m1fQ957nOooIGeaOXOE2ggDHKMbFXUlcoGh+0kDESKQYXTvGvTHPGEzsZfk/E0+fNtr2dWVMgYndB1ior6BX28qFtV0PZHKq+hltF8fXuLVu843eotF7/z7l9uSifIidFwNxr4ulesZjBaP52pxUPFWMXr4JnDMvZFtTe+oCzZ9jNoXA0T0GmyeP1zrm9SqxMJ4zCaN6UuliZrBGUvG6ju7BTihpd4VWi1L5JmbIcs3GJnMUni3xYFdR52o1uRpsbtVlkRFg+HIQSoxjiOuZhQTZ+WcSXPwXafJBkpdhtSYEcSunV356focFJEjK3tgxWyisQKT8hvcVZCmAGg37YZSKbc0MnTmZDelY3Wkj95ItaX/wi/BVX/UUGCOGhvdfc63C+F2BvF3V4V2CAQlYTtIajSHN5FjD1QMCJGNcJeheFIyvf9nxCa0yIZelvqLwUpFHy2U9GzxfdLrwoL5KgXbz+ZAHfDpGkAnL8oUyPyVpjWTtotpY7qeNqgXi+vaoAeKSzLb4fF0R6kEgu4h9ZTFtE3/c5Mrsh/pqMp3TGBuB4sX8Xq6gX/3QKyh+kfnQBfSlN/DYrIw6dv0EOPaIsXysJWtYR5WYTCJws/uKOMsaFM8QqHgWpmnlDkSwQ13lHnNWZdoEExzFc/mePZDdRb/ogdWpP+IlubnRpGowC3eD3JMJgobeIPsllNI6D1xA4A6AFgRtx+APS40b86jSukz2hajmuz1A5IAM0/I1q9i34OIMlIBwwKk/L/wN6lq90l4IaKnDvJTaasbw4Pq4OM5aGHWt0FQylN8OOBtkTfkbxmk3LRgs+NMhHOZrsj3Edl8K+2fK3ScBHVm6bkPPnYDITevMICwZFvKSR5Nzrsk0p8TYcpQlRh6PALtTZWxw+69QF3+Y2q3sXEwGfWtur6q
 UsG3tXPL
 oODiD/isd/S/7xo1aUc4EwD/ItIEr2km54BTL2+KxhZ1aS2Bg4AeZ/JHxw5DfgpjCG7Z64wTTbLzPQ+htIPJvBWl921E3Bs6LudAEwTu8ygSwV2R0eVLbTx6hTugeNbrSusxgy5I3X0bof+lT/JI7QYh2EQ3z30k3aSUouiG/7UqXfIAQYP56Wv3payGBM+frW/7VurslNq1cZ7MT8AWnymSC/N36RUQldQrVcvOiCTIfYHgIg/rwih7B1jbG4cUHdREEQYWLQVoYdmus27hi/wtPalTVH3spgAWeu+xVGheZTv2yFk+/DVcF7E9Cbp57aIcOS4lEQwmHrt8of66bXRQQWad1Yi4TJXWZM61gory3qLHyBm7aTD+hO0IEZBQtbXlL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 12:06:38PM +0200, David Hildenbrand (Arm) wrote:
> 
> >  EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> > +
> > +/**
> > + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> > + * @ranges: array of physical address ranges to offline and remove
> > + * @nr_ranges: number of entries in @ranges
> > + *
> > + * Offline and remove several memory ranges as one operation, serialized
> > + * against other hotplug operations by a single lock_device_hotplug().
> > + *
> > + * Unlike calling offline_and_remove_memory() in a loop, this offlines *all*
> > + * ranges before removing any of them.  If offlining any range fails, the
> > + * offlining of the ranges processed so far is reverted and nothing is
> > + * removed, leaving every range online as it was before the call.  This gives
> > + * callers all-or-nothing semantics for the offline step, so a failed unplug
> > + * does not leave a device split between online and removed ranges.
> > + *
> > + * Each range must be memory-block aligned in start and size.
> > + *
> > + * Return: 0 on success, negative errno otherwise.  On failure no range has
> > + * been removed.
> > + */
> > +int offline_and_remove_memory_ranges(const struct range *ranges, int nr_ranges)
> > +{
> 
> Is there a way to just generalize the logic in offline_and_remove_memory() to
> multiple ranges, making offline_and_remove_memory() then a simple wrapper around
> the new offline_and_remove_memory_ranges(), providing only a single range?
> 

Yeah that's reasonable, I'll look at what can be done.

~Gregory

