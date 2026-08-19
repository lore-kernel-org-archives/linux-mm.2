Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9681BC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBB76B0093; Wed, 19 Aug 2026 10:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45326B0095; Wed, 19 Aug 2026 10:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9358C6B0098; Wed, 19 Aug 2026 10:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667B86B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:32:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F052416013C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:32:33 +0000 (UTC)
X-FDA: 85118259786.19.CC9C1D0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E97741C0009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:32:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZs8asn2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787149952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w9Hnw4iausYsfKkc9e2w+Zv+jsIN0rEdqaj4/sjNlgQ=;
	b=cUwC3nUxvHFllWHddIZhjAkPGuDBSXGSZzch9F/e7XVoJpeA03lP5W+nWYZrCtoonRenhs
	zmK3ElOQyloHXRDDJdsJlX9+YIeW4m267AqyWP+Ksa5CEFbTjq/AXFEkhgZOK7SjbUKaY9
	f5ihMkr4+tOklfXzAk7tEulDIO1onyk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZs8asn2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787149952;
	b=CVwUwz8gqJ12kAktyq7pl0oBrMmnbUuNl3gR0ZFuPsRsZuXxNSuHdLBinrCxD4+XMF3Vi1
	7H97UnKElbctO4TM9734ywlmX2EHroj+fv3Fqo1YnnFT2Ir9zrl2fUh+ksgTaPyzVEDQ7u
	gGzcemshfMoNRJEN2DIUY2pclYYuIQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C78942A27;
	Wed, 19 Aug 2026 14:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CD21F00A3A;
	Wed, 19 Aug 2026 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787149951;
	bh=w9Hnw4iausYsfKkc9e2w+Zv+jsIN0rEdqaj4/sjNlgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aZs8asn2hOgtxdCZzeZ1/52BFhppyKmfyqK0otCTpAaZLwZce4+ddl7pVS5EyQucR
	 c0U2jgK4V+lyeH0+a/IHf5KVh/or9hWU3OtbbHsOXlY1KBNjD0fjFFsL4rXPPlMym2
	 xcS/w063kky3FPXs9kXFhoexSkCTBy9IQXreq0LddL2kz9v1l32PAxaXNG3SG1Bwqb
	 gW3OnQmUg/eLn7LoW1vHYMZXLeIIsuq9vxXLraDx3fcaQgqs1cXf+HAMJ9VfHwApTf
	 ca+PJK++UAH7oWVuWPCsLr4ygYtXjw9RgKe/WJh41kwNYDafoSFl93bFW4EFQGP0fH
	 R2Ga3vlprmLRA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 724421980066;
	Wed, 19 Aug 2026 10:32:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 19 Aug 2026 10:32:28 -0400
X-ME-Sender: <xms:dr6FahamhZHxCIl8LX94qpn-c_hL9Jz8MRp4_N_UnqewwwliPahAWQ>
    <xme:dr6FavJlx_YvQC6XEfHCUJvtCeH3Z89jFetLtIGCxM7jYoPN0yv2AQNLmtQPexDgy
    uj1H9G4L5FFTT-iQyOWeFVPRc4NcZBKLR_3wPkTP9iwPtx3yKUU1P8>
X-ME-Received: <xmr:dr6FasHIR_WJb6fWfGGk4rOKS1c9YFKNFbE3xDQrvw_2vHnGYK-7C4iAJKI>
X-ME-Proxy-Cause: dmFkZTGojgGhrOmIFSGSW8TvW4qPO0f44TlNFcF9GgYHUktHLzH/Nr65IvLCzp8c9ptunc
    U/PqK7WE+nj8zzMcMMFD5HrD5AMsJNlvonpg0NnZGxYolQcHhe7qbVzIc9LGCUaATkCzQq
    uSdQpIUkyAfTm+SfUNtH3SdhnUdjpNb3F/BiMGaaKFvzrshZB6oa0utVQhimv0K5oSCT+c
    fyFyeWRWjCnFsqiE20gQ6ih7x7fZX/ad6mr1oTPfQ/SiD2JgexHETg/rs3yyEt2aD8HI33
    +W0VR0oa003xdS8Ru9JDlCf30s2sNB8/kg7EJpssJ4fyC6jKkoyfA49M0NwdxeCQ1Fc+lM
    MvWjJAZ++qQdWeKTCySJkJnR7kes8IsxnAksElqXtMKlsLltQSQ6mll9MqARIud0ht/VS/
    rhOEefsXeS5nCS9JRKheDG6OQoMzenWlZ5JciqRg6HPzAtmG/cnyEpHSp1y6wnPtzM68YZ
    MFQCjjVnpKqDeiZlRS7szeeoKOq7K2PCvMsqPoO68p95vLgxxsEKAbQ0Z4RUp/I6tUkh+B
    ReBRGMxNRnG6lGCTTa/clKs9hUZLk7k4MC5ExXHsE/rWIwZdBcK+59MvyWAQ+Kf4/kIq2K
    gio+ZuwBnjM2Ofe0FxlUboVPbcmgrNRS0gtKT0XvN0N6UavDgL5YWAlcTMqg
X-ME-Proxy: <xmx:dr6FagcGVsRk7iWEklIuB_1H3ZqABGO4byMrQllAUZgSAP9vP0u_tg>
    <xmx:dr6Farj1CK1EcrOEE7gJfdFgICj3OVnTJrujjYkU1NQAX7kWcMz4bg>
    <xmx:dr6Fat6uec-92u93AIHK5uVe6ndO2oTo7yR2M8XE-ZnEyo8iDRAJoA>
    <xmx:dr6FatgIW_5M-s6DbfX1Ld4r96I7aNGnZ8W8Ux6OVUAC7pIJyoZ3kA>
    <xmx:d76FapaZKcfnfwbZrcVt5RHIAyuhptGvXYGwv4fmlcmhGvo4CxlL4GgY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 10:32:22 -0400 (EDT)
Date: Wed, 19 Aug 2026 15:32:21 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, 
	linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, 
	willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, baohua@kernel.org, dev.jain@arm.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 01/12] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
Message-ID: <aoWuiUGAGXgUNZBP@thinkstation>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818131202.494754-2-usama.arif@linux.dev>
X-Stat-Signature: hbgbibg74gmm8fyxw5qpebfdhfbfux1d
X-Rspamd-Queue-Id: E97741C0009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787149951-124711
X-HE-Meta: U2FsdGVkX1+4plBKHYD7Gs+05D8D23l0jvn5eDTSM7SpDdfnZbP8ZcWFVnrQSioRg8YtBXoksZZNE4UikRB4YDX+maijB4gYaLCJfAVzeUBoiWD2itg/CugcgJit8HURc69uzxyhaXEIRShVvV2abLVYoq/pLXgMhA5nptqOz6ibNglRQZ29rbZ+lfKUgl0vrxfIBpricSVgjT1xxHDqtv78fevJXuCR08fuWsjT/s+qBfqf4Wh1kwGg/CO7ogdif9RZ/74E7LXsYI5QZ11RLAVdnj0KsPk7c7zlkcfRXS2Fb6qNBKow7Jo9nf3LGyRYZrBjjJDz7EAvocZj4rKK07VP+AMGtdJ65inHvS6w88UJ4iNjbyOgfNPSFgl9lEImjacC30Jr2T7F0UOmMu9EY44JFPp+uG5COFfGpB1ypg5Bmcd8gUdH56YLRziLXKHcirzPOoVXpOanGk4h2JGTg7pnBHeRbgk6p520V+mBBZjUNfs7LyWS7kdyD42rLwkw8qWhn2hDljQsiiJCNNeibUx+GRmb9tjo4icnDM6V1TVULNZD9KjwNg2/GnMwDDrzMLKddVmWdyNw1/eD9rlAmiuAd+4+Stycwb7TTe9Ont/2CpSwrgUHyqVEMoPeDQcswbgqEpmDwUyh2GsGZIjO22i226TLwNnJDk7d6zzklT9PzEjBsQWq5yR/ow414DnDWdQdB00ZD7OiB3JdXQeDcai51CMByKif0AXnlcUUAefbRB0cT+iGckn0Je/OXo2So+U1ndqF09Pw5sirCI23EO6u6Ipm8e+q0UIdmDhd7mWyLATlqZPKBU0ej6jZNXPq4o2Y0kice6JWp0/8q/rjkkbn5ZfxpuwYCqYgUmRWPswQFUIX1GrA+ZRB6m00wDgCI2zO5FgfjrK0+0Je+sgaD1HrW8tDjLnwzCam9iF6BUnGMqikDUpLbUvi4ZbJlUHtuZdxsS26PFwcimBrf7Y
 1A+ZuNQZ
 2J2Rzzohf6myNy6Xe6oxrAjW/n3m02c1MMmED/fTjj1m/Esi+5JN5DiUQW+OOlKQhSca0pet94qmM90oCorH/6S7P5i+um7yzAIS+o+yW9+LwxDqru9RlPVhPE/r+ddNqYryp3g3LytnwCGIwo2witeiMRa67mwnOwtMx+oJRbIlknMGBxsLkT13hN7kbOrNnLSRt+Zq2Xv3RGA357s0TkDEoWK6T/ZHgWLYHoZIDUClHHvkxqEbtGxuv2oQ9/WSywsGcbHtI45Kg/0q8i8XLRwejB2P7cZobuGWUG2HIURU7eC6hObw7DfMPljbY8xrugarw9wTXtk96v9Jq4Be5ZiqiDbsievcsADWAjBErc1+4FmANsXDeet+rH7HoUHyAv95pO1n2yH4JScKAS4gsDEGwcI7w8EAoWNSU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 06:09:42AM -0700, Usama Arif wrote:
> pmd_to_softleaf_folio() converts the softleaf entry encoded by a PMD
> to a folio. Rename it to pmd_softleaf_to_folio() to make the conversion
> direction explicit and align it with softleaf_to_folio().
> 
> No functional change.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

