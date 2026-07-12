Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB04AC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 16:48:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7582B6B0005; Sun, 12 Jul 2026 12:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1ED6B0088; Sun, 12 Jul 2026 12:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584F06B008A; Sun, 12 Jul 2026 12:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29E5E6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:48:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B28CC169C6B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:48:57 +0000 (UTC)
X-FDA: 84980709114.04.6790DCB
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8794120008
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:48:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Le7KoJp/";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783874936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
	b=JKSisWUv9GXUV1uu9+/clG5+ixaZrTzkHtSEt/jN0EP4RBX0WrQTf1A2aNGz9aWbd26ZeF
	lSBHJMI/ulkGMEIl6c3a7WPltOEpzR386DCvwIxJ7qXxVvT2KzfQxPnBiS41Ba6vxRq0NO
	6wwerR2GdPYmY3ZHZ5mo1xa3VHBcw7Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783874936;
	b=MYbacCvhnrNxPqrmEBIv1Rzv4W3sc9OQTj5+PRisNJjBtR2b+Nb8YBwzs/qG2RgG6YFGHM
	phQuIeS7VmNt02RxgBXCUaxUFfw9bD9NEyGLjD4BHeJivaIsOmb517iMp6c3AZorQFXolq
	1VDUCJX7BBUhaXCaUsA8wwoqIYcBcOI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="Le7KoJp/";
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c04bf4711so23135961cf.2
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783874935; x=1784479735; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=Le7KoJp/LhkmkhNXvwWhZ5JkR+8L1LApa9V7cOpfG1TlnRpBpS5mJ4LdaS22jZ/i60
         2XpLqftT8KiuWczGuNFBH2PCdJ5IHAi+w5DvJlZpk6oaxuSdS7jUVv5rIzcdY40HNWr8
         5jr07yYhLFGndztE4GCZkBZyZg4NFDL4l7tR12aTNEEDp6KpIJorPz4CyGUZZ/PjB/I1
         BL2oZSS7iDKRCCkxU6Ocqrk+gItL7DmP+oITGag67Fe6kEvFaS6h/3QD+jPe7fR2dVTB
         jbF2i0taG20AowbQUQNKCq9eeGfNDfamik/9PdYH5Zo0QAa+/i29IZEckTBszQ3wc5gj
         PXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783874935; x=1784479735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=l/9xSRzIrgNdedFAM6nDGDq9FPftWwRQYYNOljlfxjHaEmCTtx7uQYxwg2cNyo9W6L
         0ZdXXXIjGJ144eWKX5IpMAxP8q8BpCO7gyqd1gF/yhqlGTHfRJRyJKvkbt//6OJPHG4c
         eGO77RsQTAtnsbYcGlNmVyVETJ96wkgUdmi/aKYNccPbMGarJxMTy2r4UBUn0hOrqsMJ
         USo1plLGJezYJia7k97avs1mvKW830D8F+GV76tbE3IV9wEJhA5+D6xHUoztXwGeDz9i
         rxClgsJkPVFRKfH8zjGHl2CDNXhtQ0L0YrCV+WZOZaXZsx2R34TdLVkSNLT27N5bTS3Z
         uRPg==
X-Gm-Message-State: AOJu0YxLb/IOs5/3b7b/5sqySKjiub5xIPcBpon7kgLJafEY7tU58GTu
	ldMmMG5kmz3VdzjPelzmNVAKYDV8+WvJ3lGYebw1MQW1zAwte0+pQggvZqy5+Sg8XXg8lG+VGR1
	YGYer
X-Gm-Gg: AfdE7cmwZVXeA03wbrBNkqjosFlnG7HsNAX2ZRVB6MXEwz2UGHYr+S49OzG0LsgSkf7
	hFPDt0+7H0JiRR44zTXKYLal0bhqk/7sqepPgBk06zdMUzWVQdA1nNWS/2h0fT1j89t3wteAEtx
	OA1JcMRtbmsw/wUEBbQtkz1jhf0bmsbsETN5o5Zx+tcFfNfxu2Huc24AOWu9ehMQ5CSO+iUF7MU
	Y8nCj2PSMWZ8iBIUaRfugwzHYXwu5kl5Qb9Y4odQIXcOpBiZXVefrNbJRN9ZjYZ+UmIiMUU9EEC
	OduQC6kGstVzILBBiGmW8hk/7sWzwlmLM7gxqC6CDqeCKebg5VRpzRXeUuUhLo7jlEcRZbPRTB4
	fKhI0YHJfc651RWd3eR1+h978hBHbPPKG4ebAa0A+QdmQCS/OGRCzvruVpFEHWk5TFHJ37TYHrc
	sz7gmTOhV2HTojRqaqQx/DPOmFmUj5NIQR60tHBmh2ku4Zk12IPGrT13qtsW9RvDZxh2WF
X-Received: by 2002:a05:622a:7281:b0:51b:f98f:ea5e with SMTP id d75a77b69052e-51cc9d5d02amr30044441cf.22.1783874935089;
        Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caae20a40sm68575071cf.15.2026.07.12.09.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 09:48:53 -0700 (PDT)
Date: Sun, 12 Jul 2026 12:48:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org
Subject: Re: [PATCH v7 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <alPFcfjlzSHYk3jA@gourry-fedora-PF4VCD3F>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8794120008
X-Stat-Signature: xq5uj35u5984adcp5sgug9aant7bcd5h
X-HE-Tag: 1783874935-800899
X-HE-Meta: U2FsdGVkX19/Mt/LS/750FmSvWNjVOaIden4+xdY0N58Cskp77M8b3pwhhKm7/eA52dKPOqcdQqROiyKpcOPddcQJmMw7rAT/KiRTXWMm+0diG06WxNaTuczlqI8QFqc2ZFx8p/r9VGKtCWaWB6YEGgOZ7vX8GEOKXogV0yBhzppJFDjfkVsm0cPTGM3S8m9MCei6vq1Zc97Kn5jxU3kjF2I2zbn9CbpFG+e+SruBvnyUpCqCeTfI7Av94DwBZwz1x/V9SOq5CQUvVZj1OTLKLecV9IK3Vju0SFj49Bjnh2Xn6Mmsli4DiLEIfbYrjRTAtHNzNjTLFrNXN7+3AxBv2Cnlv3CyRt6NBP1C0bFC6A6/mFS64MQcm282i0K7ZTPgDhjQCFvJ5e/qvF9/iGvXtntMso+kv111bACzwR/IfoqKRH1gjS7rBtzZGD2K03u6nFSM5xxcLGZOX/s14VgIgsiR+1YlAaruZjw6TtsXW2sGZiaXlfXK8pvvHEWvepTfYbFdQSZqYTDwbL2Kz1gy/6HgQr152ieKMavs69Fl0jegrfrkNVZYUM5QzEiZyttlNPK5ANE610L9LPkE4cCiFgRtd3s1DlzPNPY/vWSRw36S3E2lqlyKQPPMixY3HhipOD1S82Ntm6viltn+SHbd1y6/pJa8rUyNnrtMbTfkUPwn5auxToXZv/lUaGiX0yqtNSAIjxb8xO3VkqEBjNTxcVvuAjktVInrruZ/pYOLGE5K2tWEI1kSkgCTyfhBG3UjeDoTv3kJATCbwEqR+8osEZWJ4ylqyC5LsGwSyWHdkwjdVFBP4aYGqTVKN2MHfjbUEzb3oRM3SKeHznKlUuQT+9lh51FBBrjK5VwwGOBwpMm3MAxEwaFEvVptEUmRawPibIwOXBOwy8Vy7x6Ei42vz8XY6YV7j0dB8xOQ+5+UxtgSp+qlOBUqNKMyGagjX76JX8uFCwtI3ImLMpnLQ+
 pxmn18gQ
 2k0lCKYV/iHNcZ1T9IREdSF/ksr/nk213HebNTsgNIzt4+MMHkx6vazv/4mLDCo+7s7n3jvTgxIZ5ZK50sSRhBngTFl09sJ1/gRiooD2uAZicdgBun61wpg3HKMX7qQoYatVGCDF0f3O2K58N62dy9bNtNks6vfZltX7VBob2+E2FYFnzJfSRji78qpr72UU8GyR7yVJb7pnL3Pc/fgK8roL/AEANZiK3xKmOgqVb4AQUx8hcNd5Nu2r2nPCDG7myN3RfpaSD9NqnYffGZJVSmrShIn9qqBq2EIm1G6sdvAT0/RwOXntgobsMGIUliI0WXhOPEt6BG8y9TUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:44:54AM -0400, Gregory Price wrote:
> The dax kmem driver onlines memory during probe using the system
> default policy, with no atomic control for the state of an entire
> region at runtime - only by toggling individual memory blocks.
> 

Took a look at Sashiko reviews.

All are either false-positive, pre-existing issues on isolated patches
that are actually resolved by later patches, or something we previously
agreed on (WARN/pass in phase 2 of offline_and_remove_memory_ranges).

So series is clean as-is.

~Gregory

