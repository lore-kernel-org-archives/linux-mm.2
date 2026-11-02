Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9618606FB41
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ozsxDQ7T
Received: by kanga.kvack.org (Postfix)
	id D11096B05DF; Mon,  2 Nov 2026 09:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE99E6B05E0; Mon,  2 Nov 2026 09:28:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE9A6B05E1; Mon,  2 Nov 2026 09:28:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A89616B05DF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 527CF1A0137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:10 +0000 (UTC)
X-FDA: 85390408740.10.03A7DC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AB4DB80008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ozsxDQ7T;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629688;
	b=coD/7kUS3gZ4f/SK7oc/KEfU0AuvTFOZaUjpR/ziQMkYP51OSZLBMIahRiAT8FITooYO3/
	vV6G8TnVOPh11ycjdiOnW1hHh7n7a8iELv/xYPAcjuC7KOa1abOhrWrAgPl/IAJTv5+Hyr
	bqglVXEjSsT+Mt5jNh/HMPgAo4LxRj0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ozsxDQ7T;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmlPnk2wIc+2RmsDQ6+3x1hdmOJyfBWq+EeZH9+2Pdo=;
	b=uCRsyDxDwJYTGkYop/2Cca/Fx3NERgfIttJS+D4K1uUWW7fkgK3dReYJ7ZpD6q/jW60v2I
	TRpDAJ+FH5I3lyGeaBEej/GlBfaZ4S/z8JcyiY0vkeTVmm1Jr0EY6EnssFIBIn13D8tH1b
	6kum0VuBxIMNoFrOo+eYbz83mpC3+Q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9436942088;
	Mon,  2 Nov 2026 14:28:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF001F00A18;
	Mon,  2 Nov 2026 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629687;
	bh=SmlPnk2wIc+2RmsDQ6+3x1hdmOJyfBWq+EeZH9+2Pdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozsxDQ7TFt8FaRNdBHVg8EK9LBcs52tCdGEamZhy9C8FSY3O9WZlcUgYYOBn0CLsm
	 2xNWL2Dlvr/tzOxorcjPR/2qoAvHVKNijWST3EBsJSIQtvTQU0Ds5Vag7FTYz8JQDl
	 hOcyyW6CrW9t++ywa6HB+EJm6hgJs8HPJXg3CEi2kgM/u+SEJfG7YAt9BYD4Vm5afr
	 eJ2eYCOQiOVdPjmYOEu99/tG++7WJTCKNObBYH9RCd8wjA+vMTsXLbA1K+D/hYt7px
	 dRuclJCvEm02PM1Iev0r4Tbp1aCaNqj/OwSukfQe7UfhGJmtHI+hvoLS5RHJrYm/po
	 tN6IIpLwU5nDQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: vbabka@kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: kernel-team@meta.com,
	urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
Date: Mon,  2 Nov 2026 14:27:57 +0000
Message-ID: <179362967059.3922839.8161883636909403176.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AB4DB80008
X-Stat-Signature: t8zh49ooeoojoui3g6yzfgi3ipqdfa99
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793629688-20915
X-HE-Meta: U2FsdGVkX1/2FzkSRMt7h0hdiwAabkzDlocRMOo/x9NU1UUuqNiZ/Dn/8vhFAzf4f6QQposixSoSI6MyMOXciOWVPS8bcLwWURxoMoSiSqcLv2xyE6umy6ba+/afLxMgL/U2Bb4m25caY6bSoUoT79n7nFRjLRoLzye8+1qLKPkJcRMAc8ipiHOgn1exrI183F2ouHavduhS9oTknemO6uin7gNXn/KfNTfw+qLm6h2InNBUOj1cR9WN61PWZ7IpuDDx415FYnP6HCa5i+BBbWDPfg6Rc0hnZHnsTX5S/p+bBNyaORgsMaLBSRiy+f9Koi7/x1qAqEXZyLRl/k0z6wnH4sTUppL4hCw8DvqDBtBJRLxUQNsxnkdVGytqZdyGPOKhDMHX5L3P6psymkzx1O97FQjcl0sBOWu8dBzIKmnMAo97S3SqXqqBt5oKQl1pOt5rPXM0uRQAwRR2O9FLUImlHxeSTfJvu8nz5nSRxV0GA6K3QBH+r+Jm1ve5m24PhmJXrbeFBmfGOG91wGFmvfr+rswUDnSAMARA9hqX3zWT6yUmuryD9/jm5poDhEKLmRtI85QseSxxpHmWdPw4SIiyUC4fRt53R4DWrZnyce8G1hYde7//lUTu7kx/Ua6iOEWrD+Q2EdcQkNknS1b6rggLbHTicLEXVVNEGRaDnPkJ3r9u/w8CYkqW1XFCB/Vv4wc2nRE/EUzhtnn65pnCnc99IuAlnqTPBAhYXpYlTWqKlK+xcjZvvNbslDlM3CwokysvQkHYGbTYPAy4GP3UWOGqY51MqvNlSZTTMbxF46kVHKEeSrjdY0fG1oHrOPxIxlJyX6QU9GfBp+3pBhKGx1k3VZZsTK8+umu0+wb2ey7ovIfu4nYBWWktgN7LwTMkwtWOa15yGNQPQXDeNR0Si+xaNbwLCA3dJZzvDLzklUy5ijPK13rcFiQ07hzpZ2pFqLkGlGxe58V2w8rWczc
 bTN8CVG4
 w63rhqOHBoS+hPHiJrEbHtDZ6xgANRiZIrULYNoUUeymQCYh9HYKekAXdqOsd+FAEm49zcEWpdPbhtTRTGMe2EFm6ydM1CXGetw3yQy41o2DDgsxbMyW7et7seNLXa8E/qq3VKgnttVxbcdSSPcN5+re/Shli0En4YtUwHxoVbTH9QO4bhennMJKHgp4ro+kilzQA8C3mBDRFq3acXPJhyx2zY2IZ83+qZ6mRylgcZWtvFDds8DULMHN3SlO+R8PPnjQ5LlvtU0Sa1pY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 21:46:46 +0800, Zhan Xusheng wrote:
> The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
> MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
> rcu_delay_page_cache_fill_msec became slab_common.* and the documented
> rcutree.* names are silently ignored.  Restore the prefix; the
> slab_common.* names, never documented, stop working.
> 
> 
> [...]

Applied to mm/slab.git slab/for-next-fixes, thanks!

[1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
      commit: e6316aa3c7aec549e3ab017a9c49fca52194fd4a
[2/2] mm/slab: don't queue the page cache work under krcp->lock
      commit: 03a176b9248c4513bb705ed3d931af3a7e9c2a08

-- 
Cheers,
Harry / Hyeonggon


