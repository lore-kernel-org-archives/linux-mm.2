Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E57C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 14:51:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B110D6B007B; Sat, 18 Jul 2026 10:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8AF6B0088; Sat, 18 Jul 2026 10:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A013F6B008A; Sat, 18 Jul 2026 10:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C0A6B007B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 10:51:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F035B140460
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:51:28 +0000 (UTC)
X-FDA: 85002185856.24.3C5305F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 77A9020006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 14:51:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWBF0EqB;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784386287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRQXKgZvVOLKJU51yTAps58jYtNd2L+HPiejoWLGke8=;
	b=Kf7zyosy3WQk2sDk5Oe/86ceelMY9E9BLstYEvnc2ZMkkzKDqlYFa6Em/AbldS7BqAwU9a
	weozD0cW6L8b/qhaMybf0+oSSWiF/sqTLLMKNhG/l5sRUC3jvKS2Zg/wxUoPGaBA6p0ggU
	pRHTSUm6fCicfjsVnNlYdvVcbgoDEg0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nWBF0EqB;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784386287;
	b=dk33zUaSC4vJtYa4JPZGpF15dNLAMov0c08PEUE/nBKeF852gnWw5Uo+isUP5xl13xTLt6
	KD8gOJyy9EdV67pgG2Ie2IpyXfluSqLXTvs8kjNC0bWL/FbC1D48A6kDD2TQ3KvZOqtFeT
	giepp2ZK7PUfcbfnrp2JOqD3QD2hQ+Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3FDD60204;
	Sat, 18 Jul 2026 14:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730901F000E9;
	Sat, 18 Jul 2026 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784386285;
	bh=RRQXKgZvVOLKJU51yTAps58jYtNd2L+HPiejoWLGke8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nWBF0EqBfhjHJvpdqs+h1dzr94c9R4BdvZwbvKLWoOESTja4JB8XXnNcOenPFuVrD
	 w7k7v7C0XoPBQ9ot5oa3yL77Ju8nMOEldt3fYz6cgfVAB+G39pdKaF88Ki3lc/9V6T
	 gL7bTRbDAm4Q7ch74uTOKPfnOaygB2dp5AQzutVMra7CSwPlrBvudf3cQy8AZUoEOU
	 Ao6sj4DJz/LIPxR9eCGY1xzCh0Zxlz3ViOs7LF7onoabL8Cnftip5KbkplrpgSd4Ud
	 DEZoMWo46oXL0e+rwwhLC4vLVh7414ZS3dRMbSlALPDPJ4RKbFbprP7iy6qqaZejt2
	 ovzYl7a1tfFgA==
Date: Sat, 18 Jul 2026 15:51:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is
 anonymous
Message-ID: <aluQgZAL_fOL7hik@lucifer>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
 <20260717-b4-scalable-cow-virt-pgoff-v1-7-cf24910ef094@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-7-cf24910ef094@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77A9020006
X-Stat-Signature: po8pnjmc6aiy5pi7hexqhysa86jb5qcn
X-HE-Tag: 1784386286-679993
X-HE-Meta: U2FsdGVkX1+e3TkdczmCNG0lt496dZgGsaEMkv9XCBkmQURaFZrirLFeqpDy1cjZ8yL5g62phWApjUMF/7bFOraAM3H1h/KymDYCz8pDmgvGt0NCW9PQpFDsbT6+eKyH3wDU3s5eGk/e1d7OtDMdX7xGItKCyX4Vu90n4CKDg2tMOQQonIUMdMJIuU08cH+bobWRcKFsLKdUX4Hhc9hqV3qUN97Tm1GdktUDD0npJ8ipiu0aGCaJuEzSNbLtMp+SdOqU8ASAuPnMZE7s1nFb+S1li+SVX0RQzk4JgrHdtOWvEd945ZaTeuQhxvDVPzqmyW48Z+i9RkB107CmPd7ZHrCIp7TAWJnBypD0gBYvc2pHbXZHWo1N8OIqM6HQWo1v6e38S+02SHRQ4YU69XYh5Ar7thu+/F9HUPaiybD5Sp+WUHSfZgH8OKexTDYvq5QiY+y+fvvHR/xGyh9t7PJgO6i3Dsg0YvVHL3ubj7b/FBPw3owfDEli/5z9/A79sjZNCur4r1uyMtdtqqRb6iclBu2SVy7fjUazHxtDzdfenMWnxu7gqJieppT2Tl2rPm8VI6J2BsnmTGXtxzrCSeoP2/LGeJ+DsZZVqFXHoiWiypjeH7+IEt7s9iTM5LWi0BfdmViPL8Qy/HtUBhaVeSbCctXWAZ83RmaOjzwyz7lAvgV6GQGPTr7uMerTi207nACXcfCf/QicGf4tzNGgt0faH9g3m6FeB4GGaTxCMECpE2Ojy5HmSNtiLlYlZfyaNSy6oRIbddU7Cko2Mo9ZpO2nY0Zep/0lpIZqnJ9qKybqXppiFxLGDFX+y0jYuj7XyXc+AOAf8uO3J8pZ0pPw+Ayu2R0mh3lybUPIgLlhGlB5XBqORImNNQ9RcVRdqdxrqr9q9Vgua7JunP3yP43H2l4xZTVecT1MBU4nPRXDa6013yMv2t4p09t+Z5QrOXBAnsq7+Pbzl7Thf8iuxGXw5wH
 hxd2LBDT
 c5WFq34bax8XKxELU3DmpYzy3A3Lo2XR6zycx0s5tmXeP1xkcPmobKtR8nbpqDPsQmvYZDv/4GnEFf3ZmcxDKQI0S1HybjXz3NUjXBkKH1evgPS3AcgVQpM811VX/Q/ZbLZpLAogfee3hdNT36HqFzij2PS51bGstnUHhDNUX+JJB6D6qtWUZmNXu938erK9MQ2Sb2z0RKAPJ2uixCPia7XQXMtl1FYY4U3ngfXs5VgNhxo8le8gESU5IbPWGl8xtR29VRWpyt+Wgnbi1VHMw1wOBtlrWZoPtT1xN+PDVsk55n+c+6Y7qXAbxlvCrY8WMersK4IZpe4H2C2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:19:45PM +0100, Lorenzo Stoakes (ARM) wrote:
<snip>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 5798427d007f..cfd4195ff1ae 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1240,8 +1240,10 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
>  		.vma		= vma,
>  		.address	= address,
>  		.flags		= PVMW_SYNC,
> +		.is_anon_walk   = false,
>  	};
>
> +	VM_WARN_ON_ONCE(folio_test_anon(folio));

Andrew - can you drop this line please? It's incorrect (folio is always NULL here).

Thanks!

Cheers, Lorenzo

