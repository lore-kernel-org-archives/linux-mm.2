Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6144BCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 13:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E786B0092; Fri, 16 Oct 2026 09:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040C56B0095; Fri, 16 Oct 2026 09:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71356B0096; Fri, 16 Oct 2026 09:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C26826B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:17:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3ACC7C01D1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:17:48 +0000 (UTC)
X-FDA: 85328541816.25.2FE7B50
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 580991C0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:17:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c9KALmch;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792156666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCoaTxM/vxVZVMtWCyBRil1iHn0bt6ZcqZozloqgfQ0=;
	b=Nj5aJ5U6hv7hRuy4hmJohZKpMcXogevqEcAquf3AoOeagtqTyWQQviyFXfsCNpuxdWZaJ8
	vA+yw7Zdlz5Z1vrny8YGVZmalIqea9NtujOXhtmah8DX36O+iDsBUcbvX1w4s5rj8zNIaq
	EeGR5eDu5IVcIw99YLj+0DnxfTEZhwE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792156666;
	b=ureIwRPdH6domU9ThakOsoACrdlXztdSjWCx2xGdCi8SHxkEbitMc0lL/gaMdCViNkvfFA
	NZUH+FIYTx5ke59svddXAdJeH29OTzu/lmhyPQMUVSmE5WmDMLSEh6xoZaT54qvTlh+8V+
	lMM+LGG0MtgntvHyAYuIU8aF5pFgM18=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=c9KALmch;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91ba702cceaso28327186d6.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792156665; x=1792761465; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eCoaTxM/vxVZVMtWCyBRil1iHn0bt6ZcqZozloqgfQ0=;
        b=c9KALmchQ2s8sG4Rt2P5Q/oKo5F1HrT5KzKJIUgc1nFXEyR0QUBPu/wnDYWdvcSskt
         LegosRt+veJe+GmikSB74EPYY+sYdCn2DL1kRELiUG19NKOelmHtz/KNM196HQkA4hE3
         zKxangccNhewS2cbK7YiniqHYcJVfGO/9z+bFzFmJLdIwc9eOSb7BNd6ofzJyEwu2s3D
         4FwKu93iVw2JRQS/FesD1UrwOkHvL0Apj0xFOMwEM0HdAO5TzZ0OdzWbuX1b2MqYbOay
         UIP3iaayR+JyLwVw0TjB2fnc4UVeKI53QSqqwtnMnYGu5Bh/19qec7ovblM+joP0W41O
         X9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156665; x=1792761465;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eCoaTxM/vxVZVMtWCyBRil1iHn0bt6ZcqZozloqgfQ0=;
        b=0P4m8lc3mEPpg2Ja95YRXmqU8W8YRuMhRhl8ZtgBhtM1x6lQXqemCMfYHo8gQngDjn
         HuiNO452FsEUxXCPF7ZdYNM6RHahpxrQ3IsnfSESmaI7b8hwLhLJFLgVo4SVAJRJZIsA
         9rCds1io95WTLXgad96lSz0N7VVLZolOoDVtrNjkycP0C9BEC6dQIMCh78rCbpncvtJL
         /R1NVd4Hz5rXCzbxdmXicRgHApiyYPPKxmtNIX/GmQCydFLzSL4UJtzt9aE7gnVjl1C8
         aovaSDAyk8YuyANqn6KCQDJiGPNxznCIP9Ky/L88kqQXRInsEeOfbeiEIJbgQSRKIdoe
         bsfQ==
X-Gm-Message-State: AFq9FYIMsnUWFU4rkxy9iz+VOWUOPW/Vh68sLb849XbKFKC0jp9KN58Y
	M7yr3OG0y9ufuS2wOMKequ6r885XBzYuEYeIsefpYWDICumo6U4kwYsyq5EfNNSkZQ8=
X-Gm-Gg: AYBFou1/weViA/NOx0nzwrW8PzoZTfirifdd005XcxSyMN3+bivHYoNRZ/PRzLTgBCh
	gdVejsdQnrhe0Wtj3juLsL6gBmWucTEGeRnLsld8tnLtOVsqmVzPuNxHyOioYFDwrMoVx5TwMbP
	bjUm59/2Fh//cmRFUVkk6hmH9ThpRHaMWMRy8UFfoc7OBl9hcPTNTsCezaPZ100Sm37IIgn/1LT
	OhSNxyZITMftsFsvjH2df0jooI8vABXZOcEkk4EGNVS5g4bWUmqytRMlm4RzrzwDtxx36JvVKVp
	2LHw61FXiXFiR6HddfdNwVFA2jCho5ov55NyIqy5IDabj8dvN2eZ+Un8koXBNTPsUXc4PNp7zkz
	DZA32QUOFp7bcO/Up+0JEJBiYQ6a2CJLi0huTi2yyRYcPXoF1rkyMktc+uQnpq7Ams/rwI3MBjV
	eEBNDTSrz2kKjpajElTOeoZZ5rmhyZvEST5fnVNYA0XwdzY0sNRMk3h3tEz53p+XMhHM2G/Ca2Q
	dHIsxxEnfnzKrc4yY8swwuZsnI2w6MZ4bT/RiAeH3BgOZlN15TGoiFyOH09Z8FyMQ==
X-Received: by 2002:a05:6214:2b8b:b0:917:a253:4f8f with SMTP id 6a1803df08f44-91b55577090mr362058926d6.40.1792156665348;
        Fri, 16 Oct 2026 06:17:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb0961csm22365796d6.30.2026.10.16.06.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:17:44 -0700 (PDT)
Date: Fri, 16 Oct 2026 09:17:42 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] mm/mempolicy: convert mempolicy refcnt to refcount_t
Message-ID: <atIj60f_iMYCl7I6@gourry-fedora-PF4VCD3F>
References: <20261015231322.3392551-1-gourry@gourry.net>
 <b64e2b5d-d880-4ea9-ab2c-c04a0963427f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b64e2b5d-d880-4ea9-ab2c-c04a0963427f@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 580991C0006
X-Rspam-User: 
X-Stat-Signature: fgoq3gthth7young8jz4doq5zhpirrfs
X-HE-Tag: 1792156666-940746
X-HE-Meta: U2FsdGVkX18CvlPfy36mh+euyLLRA/b8e6sMxrVmojDMAmEMrAWKG90aI5X1/fAtCXu10HKtnw0s71AlkDAiKLx0U97cfoDK5QUDUsz+x7LqHUdgXqh6rm1odfgZog+TphAZLGLzJfRDdA57bHTL/73kr1yTpKzfPmj5e9hcAE9oIPBQffXld610hxfFFHE8g6iwURcOdpo4Q6Q2yblETPbYCSFQRSW6l2lcvkX88LW64R5/u8dgCBFVey7NoEgPfKvmS3iWLx8FCVfMtbebcXpfEpOzQBcvRbvIziqAsplsYJOLBFtHV7soSzPe/dRGF7o8IJuJol7evtz+jPMYc9rAucA36H5ZZUeWbKnEAq73/ojl3javiqihaujdOLa1hzASG8rt1+5Qoa38LV+uUxeeHcwUgSdY0ABHLCJX4NIsfve6nlRUuvcBxVmpltBI+UpbrMgd8PI6JuX+2QFbkq0ml6w/DdRRPdSPirvDV++EagGtFWxDRDNukH2yQ5SmOlnFx/TB6st4dAlBru5soH8ygDJ5t5rmug3ohige60Ot9OYqt350KXRorRhgQ8kfsfboJY1v+Us2gVscj9AiWwua3TS6CReIi/0Dn3J+R99X/esANN+kP7Iqxn68b+K67737VrPmB7cNJw36Z74rYwyX8jOAweHMlN/PR451uGLEnUIY83OztV6e/onpjSEsT/5t8coVKh6I4v0I+BVCck1hlW4GpZ8p+Lyza/BFPDfam5IkBNMI+50X16CKu/LXq0NfGm9mF8SHYMLR5Ighwt3BZnChqHlR6Iw456jVyau4XhQv7djH9Gv5cEtjjsARr5cLBUhq99HJiA/5Ic0fdU5rucjTeGNicNZHa1/Yhi1AOFGdjctN9kCyib1F+HN+TuzmJJNTbENgQ6wvsJFFlqANRvLClBHGI4ZixzqixpRKkTsvbcWwqxnDvPctl7dAsc2WmrbWpa4aAqH0nyv
 mULYLJZZ
 d2Z9CVgjQoM91qDq5Jxhe7gulGCoR94MSRkUGM4lKxjaoIv+nknoUnwf2gi3MMGBFR30K0ncxoqXP/2MTULIzc12p/4SES/0pmyk4ha3RjyT03+gGrmY0DMr2c2FbAPAb1J1SOswtCrBu7EiGcNXjluxgChuybjK0cbk2Fc0eDgmfT6zLiGiEaQbqibeRejhzViL31+kmBRgE6niSd7m3deG1CQ44GkjQ7fyIk+A8yrVqj+uxwLey5SDTEwqby4oGfxwIda8rfpox/jNsD24LaPId3aouufaGYXfe7qvTkqZa8a0D5ZLvyp7oVM0vRN3qhv5RqlrVD8UuKRY/Uo/E3T7GS3NP2GoyMvfytsT/hN1yjt9xb0mQX+mxJTX80yJ1gttsgPGNpaNabyTJsaIuqBrEX6Z9rVKb7J9rubV5TJz6I15vnr3UEQqsbagw7WhI+9eW0cLg/Ec9tNcPTVDAH05yoyQprha1we3vm+UEXR29rIRrByoto3t3cBTQ8JTMUXP+NeXrFfDJpJw2JqjR1jOPpu29bUgIrF2FeKGQ+RFlh4Pf4anrLM0m9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 09:54:33AM +0200, David Hildenbrand (Arm) wrote:
> On 10/16/26 01:13, Gregory Price (Meta) wrote:
> > struct mempolicy uses an atomic_t as a pure reference counter.
> > 
> > Convert it to refcount_t so that overflow and underflow are caught
> > by the refcount saturation checks.
> > 
> > This silences the atomic_as_refcounter.cocci warning, which started
> > matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu().
> > 
> > No functional change for correct callers.
> > 
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp@intel.com/
> > Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> > ---
> 
> Wondering if we want a Fixes? If this only fixes cocci warnings I guess not.
>

That was my thought.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

