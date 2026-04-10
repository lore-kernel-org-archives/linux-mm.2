Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 584C3E99052
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 08:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFFB6B008C; Fri, 10 Apr 2026 04:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7AC6B0092; Fri, 10 Apr 2026 04:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14E26B0093; Fri, 10 Apr 2026 04:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A145E6B008C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:04:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64AAC140460
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:04:16 +0000 (UTC)
X-FDA: 84641908512.19.089FD35
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9936710000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:04:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YI2JGwcN
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775808254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnWyemV+NZsY/YXdFzXMuhYB31BzKbN6+vDsj78YGmo=;
	b=FCg57L28gjh8wSk0Wpzg52p39j73vlZgCxWZD/RuPDc1MGt9UKLZ1sqBik5LUnOsGpD/vt
	AoXiYh6rL53745yyV8nOQ2aLXTXiUZnHZLQbr7cEhrKZDh6Tsgf1WkL80xh0SxmIWaC4kV
	fm0JXJO+5ej0wG8hlobQn9dv+dvTUFg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775808254; a=rsa-sha256;
	cv=none;
	b=sj/zWURwppHRQ/a4xhjnWOeMtC9OyhaZAnsjC+EL7SEkLJcoZIVdXvyKI5TEqGMZNbyZmU
	AdNlOtD9kxSIT/HxI4hN2IlDJeSdQHfFNYetEEQOQTRbXPpZz7CxiJ7K/KAcYefE/N1w8k
	y1WaMBIA6ZwocRU12ZvWWGPnavNO1mI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=YI2JGwcN;
	dmarc=none;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qnWyemV+NZsY/YXdFzXMuhYB31BzKbN6+vDsj78YGmo=; b=YI2JGwcNCq/sWdXmZgi0jxW4L3
	uoxTV4UW8j+EtAkLy/c6t3dH5yx2NmzAiuiKThfj5/XdFJaOBKJsG0B7beoWVD3HFE07r5yqTPMuA
	I9dJAmiJ4bSVAHk7fhRg1zCBu5NaGBEdRQiW4aI1VBwIcmzSP1I0h8H+uKOsKD9Bo590ViI6dZw3Q
	I8mWM1J51ZUxdpD/47QGmMWv8dRb/udrxvNSLSPMCN6kFLU++QvWAdhFqyKUfmehdqK21vCV1Jvlx
	1QqT36AR44yzY/x7TnkEiWc22ocL7tFbEUI8bkIJ7t1CkF9NmdPPZk8WwVS9y39SaE8CDQq+1zRBb
	XtBwzjIw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wB6qP-009q4T-1Q;
	Fri, 10 Apr 2026 08:04:01 +0000
Date: Fri, 10 Apr 2026 01:03:54 -0700
From: Breno Leitao <leitao@debian.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@linux.com>, 
	Dmitry Ilvokhin <d@ilvokhin.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-ID: <adiuinlYfkIjuoOJ@gmail.com>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
 <7cf39b82-ff21-4d9e-b2fd-1636c3e203ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cf39b82-ff21-4d9e-b2fd-1636c3e203ce@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 9936710000C
X-Stat-Signature: k1rxf494bqabst9x154h8n4u9y4nhrmy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775808254-889728
X-HE-Meta: U2FsdGVkX1+FILZ+10yRr3GgMI0AzcXqOgpBZ68ryl4sw/ZiscTNpY1t/aXXWnSF33DbFGjFt3RQFnkNOe9lsir9+GDbny0PMuB0qZeycgyRI9WDnuTZ8YHJkayzK4sjUEt5AgT/2toG+KlRUFk4418iDt9F8EMv0YZkBAjuaYzNYumP/6pbM/8WWRVAjKxHklpuSPpfFfaRUNnXnvMlZc7IeFSxIXnsrx77LU4tcorjP9ZR2W6rcP6OKhNkYGRs0mHOR+2QX+wgPBPmjVTW/5/guH10RaXBH/VLHd8GdiRbYKwpUlSbR/CTMfIchLAm/O4F03JCdQRD+jHrsk7A0dd6jZ45pyhGbvS7SJATSpXxcveKg9rOLNZe1G2MRJzx3ppMesxpwE3HyzD09puuOiI30mGY3hBdDfTnChY9AaiLXlWoEq0js45N+VLB3qpT98xUqo5e7mhaYjEnk7H86qzhEvfnTts7G+qMvR1EibL5shMRfohAAaadOwVsjT5+mN42ja+doYUwCt7nNIHIxO3DMHO1joppr4erQV/M5OGnsngKoHxPLa6ETnCX2HOmtBBigWhdmZAwG1oE8vox7k5jjZ+5TrQx7VZkbXbzeQMeDqcDXeYlz0uWxMu3xWDS5nrlQ7r3jdZcPWed3NMn3/kNyuHskDoY4ByIn9aXKTL7woMryRb8INA5XYXTLfTnNrCJS9FFGqzxber4iDM3/FIu4nCoNd/SLxmWzxaC86Gese7GqQM/4TFxzgIN2Un4v9EcKmFDDitd31TFTvRWiL52bnabwR53iKrV0bS5yVhsP96QWh9Fq7DJaqsXchx29nah2cl0FuGClMuMaRYdSeCZdX/Uew4gJlXGPsyaaGKGedU/agyti4b4SqzU73CGEuZH/DPCtpDEoZbeNZFBTXmkZXz6gYg1Ap33MzDxQj6XY3WkOcCyICePakYxNbFai4jKFMi/58lqVJP1RE2
 u0xKs9Ok
 Bs0ExIVDMOPlkfac39f3RhNsxdIQ1/geeuY1s9eei5/ZHCnTeOOe9YeI4Je8kZnUpRWimvtZ2d0LSWNO/cZjNBmIbFWuJslmbueHQ0gRTKtFA6XQuaGtlpugGw37AZ8r7PesRMR8PFtcdjHpUJRluj+B3DvdMjXYj/DUdbt6dAZoD5KYWC4cHu1vSlmFdVUG6QUO+165hq3ROBTyc0lsa4RXXEyUptFMq8SokSyNhb87cLaU18skCBjGPmGdGUQUjFSKs9fiT0H+bsllduuctBOF+OKlaa0eUsSpW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 07:01:01PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/9/26 14:26, Breno Leitao wrote:
> > Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> > Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Looks like v2 posting raced with Dmitry adding R-b tag to the posting in v1
> thread:
>
> https://lore.kernel.org/all/adebKQaiAP4G3liv@shell.ilvokhin.com/

Dmitry, would you mind reviewing this version as well to keep the review
trail complete?

This is essentially the same patch you already reviewed.


Thanks,
--breno

