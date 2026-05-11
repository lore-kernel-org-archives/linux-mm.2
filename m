Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC53CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBDE6B0096; Mon, 11 May 2026 04:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2A06B0098; Mon, 11 May 2026 04:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFFC16B0099; Mon, 11 May 2026 04:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE4FF6B0096
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:28:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 61D3D1A0555
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:28:53 +0000 (UTC)
X-FDA: 84754463346.05.EFC8A53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9FD84000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:28:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJhCk7dS;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bB+8HiN+wNFcMx4ehYWS1JqIHSo9GKA3p2rcdFgODKI=;
	b=jDZSmJOIY1rqkmQDEavQ53bK8E+RaUJWIPIVPNQwXKI5UDZFVEg7NJo6aRLOvYqkxdB0S/
	0I+/tv1oX42AQ4L/TlPzDFWv3CCsFT4YDPfvTuHVSUaOdQ51ByWO4OaRnDyHPrrI254DGn
	uhJK5lweLzhXKpKN/UHX/0o+RR6B1sg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJhCk7dS;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778488131; a=rsa-sha256;
	cv=none;
	b=GvTzsm5gP/++QC1iQ5EIzib/koRRhNCen9TGuxU00fBH23zv1E3KEhGNacC/whiaRm0/pq
	JmEDkl8ucsWkpIYZZm03Rd9Jqrcu6T3vdW82hHFAnNgq7vZ4AO/bjV1fKNPipCqGNM/kHE
	scc8y32n1Xm1Ssh8ZiyarhgrxBeKgpE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F0296001A;
	Mon, 11 May 2026 08:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074DDC2BCF5;
	Mon, 11 May 2026 08:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778488130;
	bh=iozcmjeAP6nUALBo5HVeYq0TXjJRgbdJ7Nhs9vISU1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oJhCk7dShIW/oMMoKij4Ca32+sU9UI6r15MDLfTGp2dwojSWsZ+M8I2Ytayski5Kf
	 QRNb+SNdhZzARNckyjO8uRXM7Gyh7q9Vgf5iogek3QhPI3wrD8dqQKQ4lptuO75NPJ
	 hKlPUgo/k/0NArrTVJtZf5kT13EUBkNFi+7KQCUQ0xZpqWW7KgEeUZ0U8H5vz46+JB
	 OR5Gev5TZlZzbi2b9F8RE5UUwdEFF2LFqiwgly3v4T6M+MN2Db+ZOJf+W/Wk7C9CL8
	 7DkBJ2xrrVqgU2SslIQ1IAdxNWKwYjbiHaOx2Kngr9LR3ZiamlGCfCCU2KkJdsGxBb
	 I2JdEeRTkrJ5Q==
Date: Mon, 11 May 2026 11:28:39 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 49/54] selftests/mm: uffd-unit-tests: add setup of
 HugeTLB pages
Message-ID: <agGTN2MVcGsZULz-@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-50-rppt@kernel.org>
 <2d31eca4-9ecc-4a7f-9359-2c605858ce11@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d31eca4-9ecc-4a7f-9359-2c605858ce11@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C9FD84000F
X-Rspamd-Server: rspam06
X-Stat-Signature: qd3yptznwyxwdkgajhxi5ziddn8ddati
X-HE-Tag: 1778488131-578095
X-HE-Meta: U2FsdGVkX1/sUguCiej1tAPFHy7PAhCs5z6wlnMNGHvnxINPZCVy40jqGjRPypvb1xoKGmN7FbwwEa1ymn/8WBhpebJmjrD7MWJjeSHl9yd14s66l/yq3GwYHXxUHHya72a3uom0sjtrxGipNAjmNeZPwNDzvO7PtaP1PP/1+Sza9HqpFqLhBRqw8Fr/10pFUkT8oVivR1F8ANj4jafVApEyeT4eziCNbtO5jgyQUujsgrAW9m5p4RKeUPNAN8NFRiEC286TcjVzSQOqCoa5vAgGal8RTLhn3z43W/LpohLS1aIifi/DxTSoCL3OiEc03F1HmAC3j37/zK/+cvaJqw6Q/XrrcnX8KdK5qrj7GUYQJvjFQSTqnl/uze5iLEawrCqH0q0aJkPpG66fYfV+1MDnXkgj8hPqyO2z8qmmngUMGAAnmmURMD3HHWc/LAit+6d2TnaHLIEGgiyt8XApMr4ZeMq8gDBPOu/4oQwC0Rzs9Iu5wkItfW+sVYpwjodVcDyeDm3SN0xVpIPs/OoPewuyDfag+B+Lgf8ASm7WWaJQRFHll8M0R+pHnCuBr1MweW4NFRGM0KhyyxihnHl5J/DOPSqhBoB/xDw0KIg0uMQyZlhBSk7QE3/7bebHQNiyLBfThb8BWIKVNxfuoJZMjh6AE26AhB1lRF84JRtm/ZLaE4maJEVkTh5n8HE+c4GVyaHNbE/MUjJLJeA/BllntUcajubG+yN0uv2DU1AP6Oq6IhZCVUScEFFZFxoAh8V7ofrFjLAV9oeyhuFcYH5i1z+0oPjXTvK+2WSVaWCuBHDgwXHIJ/avkeevt4FB46w/d6Wiq4GZAmQEa6rerBLAz2wp66DZ83yCJj3MPV8e3QutfoPZCaffjqttDTc/oTlPDCX0w4WM9HlPtif24bic7vn3ahny9sRzRh6UvDr7MhCGCzzhWKPh2otxiz8W87MsiU6SNyWgAvsUTirKkth
 RGOA6Tq5
 JmyQuMDif52YaCwxl+AeaUt/Vs0ec/m271dcuScdJSHqzAm7dZktqHoNYoVxurmo7EvHCN9R/AmPbdTeegvkhmpsYiSQdtPWwPJs+tVF4LNiYW0JvjW8s2ms10r/v5RVizCuvRw4yamjbdNzg6w3p9NNtkCY98pZtg9SKyl93DgpB/vXUNEyufxW9xx4i9ZM3wqMck2vHQRPNLuCecVP2S9ESdQh3R4QY6az1gWT9X07Jbbgeu1EZAyHQI3CKS8AwrZGN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sarthak,

On Tue, May 05, 2026 at 05:18:38PM +0530, Sarthak Sharma wrote:
> On 4/29/26 2:12 AM, Mike Rapoport wrote:
> > @@ -1771,7 +1794,7 @@ int main(int argc, char *argv[])
> >  			uffd_test_case_ops = test->test_case_ops;
> >  
> >  			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
> > -				gopts.page_size = default_huge_page_size();
> > +				gopts.page_size = hugepage_size;
> >  				if (gopts.page_size == 0) {
> >  					uffd_test_skip("huge page size is 0, feature missing?");
> 
> A small nit, after this patch, uffd_setup_hugetlb() can return 0 in 2 cases:
> 
> a) default_huge_page_size() == 0
> b) hugetlb_free_default_pages() < nr_hugepages
> 
> The skip message only covers the first case and would be misleading for
> the second case. Should we differentiate both these using different skip
> messages?

I'm more inclined to have a single "Not enough huge pages" message to keep
the things simple.
 
> >  					continue;
> 

-- 
Sincerely yours,
Mike.

