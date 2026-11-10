Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C6FD606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=obkh7Bqy
Received: by kanga.kvack.org (Postfix)
	id 8F5526B05B4; Mon,  9 Nov 2026 22:01:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A69C6B05B5; Mon,  9 Nov 2026 22:01:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7962B6B05B6; Mon,  9 Nov 2026 22:01:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2D96B05B4
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:01:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B59C11C1197
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:01:21 +0000 (UTC)
X-FDA: 85417708362.19.BF521EF
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id D745C100008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:01:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=obkh7Bqy;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794279680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keimOPBn6zqYZGZ+MFySGLhtS4gerw7P0fcwObyzCWU=;
	b=M5Z9GNcKcNOBqlZuC7lu2QQRfzx4LIZ4N+xp4RKSHfURuPt32HpWPj/sNu+y3F8qtHlism
	7CwDZh2EYfZf/LagdWUbkkdVjTlyn6nZgg3eZYXNB1I4ftgC789rIDF8oOKYBOOoPuj1uJ
	41HEfupegTfqZBiP0hqA9oeiL0xqFcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794279680;
	b=dk7Z1+L4CCb+QA6OjYkoIsAAzuDRvVE5zB4Bt5wOd2W1BqmhPKyYaLd02qyBEs8HtapaoW
	H8sWWeztx/KgUnpFva7Sr47bZtJqycllvjx8Q7ED8PvK4BnIEsLdWvqjXZsQe0A/gZb5ID
	WY1XWe/mI3DzTB10VpEZOipd6F2/i7k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=obkh7Bqy;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ea138a3497so10112035ad.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794279679; x=1794884479; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=keimOPBn6zqYZGZ+MFySGLhtS4gerw7P0fcwObyzCWU=;
        b=obkh7BqyZa209WLh6VClrq/bPpyYByWeq/uKmVhedWZ+yf7PBLfcRJP/HdE4xC+Vi4
         QmofZzPkm1Ui1GgV9XcHb+2/0Ip/6/Mq2P4YgXUL6xLwRWsdqwpVfU380+jauX6h0eRa
         VAq3+XA9NNh70TQ03xiUEY0Vbqm16Xam9Zrow=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794279679; x=1794884479;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=keimOPBn6zqYZGZ+MFySGLhtS4gerw7P0fcwObyzCWU=;
        b=npnLJWwuCxnU9Q1CfGc2VG2i2bifuZfOkhAK4sAuJZDNgs17kghL6+H3DYqM8OoEG+
         aV+PT1rV1CAhybEJNpZKTTMbYqAso/j714s/6P8HUlO7n9wGQWN/W1tTeqe1FbsXcKGW
         VqJ9UhoH62GUvrvw/o0LAuffRxSTYKukSP98rkhWYiv8uHBUlTxFwTt2jUZCOILvG4jl
         Kpr1GyTWqKarxTEdV7hy4qvPLaV7eN9CrRycroLpn2tvXmMMB+Iqb4+B5fDYE3+2d2Uh
         yl2jmgx142y/YPHRSbxVhwm/HeuYdB6m+vRC7pV4RwctFnuHXcDPtB+gc7MKaz+sVBLh
         wx8A==
X-Forwarded-Encrypted: i=1; AL+hErFx6MZmiLK1gLvyGl5C7LEefqCFdklrXYTzpx2wf7fXWRn0+Zoj19fwtbN5Ejlboj2V6VhTLlsy8w==@kvack.org
X-Gm-Message-State: APuU4Z+/tY/7Yxe6NioEibPgNSQsJXpmRZtbDSevfxP+4E5zwvrdjdfm
	+FcpAIrBflTe6nDjwjhzxZ1tayeOcmMaSO0jl34puDRKIsVmSnRZS38i447b25J7aQ==
X-Gm-Gg: AYBFou1e9bMlztxubaIdmfDdGne80csrz098dsKgZsCIFUT0kt5FjEQiBxZe40GkV35
	utHsM3+Zokzi0dmmCTB8ItFdgl3wVVwk0X9QLoq0+6VQvEZXsmKEUqFkHSGGbKVN4XnrTUwCO/q
	94Wg8skOtddS8U14mYmiVEGy7J4KjBk2lGQyDur24s7X/zYhHpIGLKwFpviX+Su5bvrV6W1z9wY
	JhMuv/2uM+glyKa/5zbxlSoC6kph6YTuZoqI6OdnPDJfuN3QYv28rXlYcSzMk9nH05jyKQH70xq
	Lk1NkHNErL6UoOjX9/8Xlayb9TCyGhanInZsBlB/lukh+2ln2fDo9mBDAhm05w2zzEX2NwheBQC
	PA7CLxmAnFWx/NOh8YQeJaxmIiQMpyY1z3aQfdhzrV5uiZUXzzHdf6yvOg8cSPf+H1boyQ4kIsy
	+psjSDAaEdej3HIB1qREeKRy9HXkAojpXxZrvJ7krNKGsQKAyrKcZuvCY4VaKgsiUf7uPPaH1P2
	3oW1tgvwnSbkElaCgO4TrK6TN4pC+XptVz2vryJ9vIFYMCfc+cilOl25/KQc0yVjy3Oif0/Cn5r
	6SSQdjPRdoeyx6eUSstMVEFzMZuHAWAtv35ejHHVxsremlEqu5M7VmHrRLYe4+vFbdA6bw==
X-Received: by 2002:a17:903:2f45:b0:2ed:1c15:ffc0 with SMTP id d9443c01a7336-2edb91be092mr12516445ad.30.1794279673820;
        Mon, 09 Nov 2026 19:01:13 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dc9ea4sm3699045ad.54.2026.11.09.19.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:01:13 -0800 (PST)
Date: Tue, 10 Nov 2026 12:01:08 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] zram: allocate zsmalloc object under slot lock
Message-ID: <avKISrcR0goF2NXv@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-5-senozhatsky@chromium.org>
 <sashiko-outbox-200764@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-200764@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D745C100008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: s9r4oqrtjadhtsje91qxtgnardkzkjw8
X-Rspam-User: 
X-HE-Tag: 1794279679-309451
X-HE-Meta: U2FsdGVkX19G7hF22mEp9wLmlRQ2mS5K9EiYunQbtMWcVAQZ82oL3NasAM3FK80W52TVml22a/ylBi7MaHeuF4gUTTMuqjg7suCe+7ESB+/7QFkqWYXBYNcXgF6q+Rv55Et2ySsPI/djVrN9E7V1ITpI/k1TVshhMpdg2hwmTe5Qgr6jxfVIRr5WjKneDpRLfwh+IrUtExSZjbMAmAaBF2i6aWmcNFb2TKqu2n0zsUm3dhD9xPcFOctnGiwgdC13cA/w0gJELXL1twAjaWl+7B1BLl1sMEeumBeXUuD8YFmzgZSSzsCso4DK77YYaKG/G/WqXmbUljr/s1RwJQ5uduA4WC3toqtCI/kscUGozI2fM+t2MK1bPGWXR0E4YHTnM6up+V9B8c6QpXuqBb4HMCyeMfBe/CjWYbnYg/BiX9jdd3rrZxDApsX9DfVR9bY6XO71G2EUHBh5s8fGrjhDHIAfD1GpBl4PMgrkS8jWDYQCeKkLOlsGgeISL4auhjTxbcQ8RtkBue1fX46Iei/t4OJ3TLEh76Vg0Ohd3iPJVfR5i6G8FTBWHrlDBv4dUTyjduxNbI8TKAi0hPksnBSoUgJvF321fX0ynCTjrDihPhjh98ehF88CRAAr7eT87/0Iw25Hp6Fs43/Bv/YGKDpX0XEQChq+UUUaQTPUNHR4P/WfKS7FyB12m0isdhmIafXLIXAljrkCAOxARaziV4Z0G5JURKNduLrkGE+2+xURmjwfmkwEABvum79OU8IjoyzTO0bgOuZPiPzvRS9JP/kNA0M2fDepV8iUGHetaG85GvXHe17F1WWmrvsyNdoeGF1P7O9cH0GTHyHdCorhEXEd5Yo4Zc5W0UDw+ukJ1fvkC30r25aH7U1ygLg3zaugDuJwojalrVDcTjkbDicjjGE892lD1ZkOTDbkusGoFrr5+1Z1gC3GjYDZaRl8qhsG5D+/vh5tmfzpC69cy9VXrV6
 LleRH8zI
 80SySN2kBATQF/ZoFj8lVieSXVFmZtw1pp0pmJSLM+wJT1+CVTpXbRUOsBN3X91N6FixiijsCf+8hVVruMnzrvAWlv5Rwi4w9xfei/IxScDDoaSr7HyaFlE1JMWwJKSL/f8HVLeKSaMS5481Hafxsa1M3v61lTjyknaTma0Yjzb7VDPPM/x5LxLGXAh9KP/gSs1BoJmQ1gMHGgqb2bSPBpe2op18GwjWbvMgezG2Fy50QTf5tdfpI2Udrrrf3SCIr7CFBXOfXBTC64tjD29X6abNPFJnzkSb6/Q6Lg0jqn140cgTgvJlYQrQOkr91hiWMoYBV//oD+/proxWSYZVmQChTIrRcSJ4/ZlLmqXUNHjbPc6QKslXcifuv0O3PGcAjskot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/06 04:48), sashiko-bot@kernel.org wrote:
[..]
> > +	slot_lock(zram, index);
> > +	slot_free(zram, index);
> >  	handle = zs_malloc(zram->mem_pool, comp_len,
> >  			   GFP_NOIO | __GFP_NOWARN |
> >  			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
> >  	if (IS_ERR(handle)) {
> >  		zcomp_cstrm_put(zstrm);
> > +		slot_unlock(zram, index);
> >  		return PTR_ERR(handle);
> >  	}
> >  
> >  	if (!zram_can_store_page(zram)) {
> >  		zcomp_cstrm_put(zstrm);
> >  		zs_free(zram->mem_pool, handle);
> > +		slot_unlock(zram, index);
> >  		return -ENOMEM;
> >  	}
> 
> [Severity: Critical]
> Does calling slot_free() before zs_malloc() and zram_can_store_page() in
> write_incompressible_page() and zram_write_page() cause existing data in the
> slot to be lost if the allocation or memory limit check fails?

Realistically mem_limit is the only scenario to consider and I will
move mem_limit check before slot_free/zs_store.  The mem_limit was
never a hard limit anyway, overshooting it by one zspage is not a
huge problem.

The zs_store() failure is very unlikely in practice, because it implies
a 0-order page allocation failure.

