Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6AAFED2F7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833FC6B0088; Thu, 12 Mar 2026 05:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B3F6B0089; Thu, 12 Mar 2026 05:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E286B008A; Thu, 12 Mar 2026 05:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61C346B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:42:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED7DCBB825
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:42:06 +0000 (UTC)
X-FDA: 84536919852.16.77BB7B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 09EA880009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:42:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgSB5cm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773308525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsUnfIkVDknxVCk2enYM+hVaLDPO0AfUI3X/ixVHS5A=;
	b=g23uNR1wN5w0LzLXgUEcwp5kj1i1O6Tgv85RIGNqhdlKA5T3SRwieVATDcrIANJOFwd3/S
	r5ZxGcHFHIxWz2I/WtUjuS9oDxxUfQ6YCGEwqNdDl2i6ReblGYZqBC+ByiRkQhPpf79qhW
	bfKjRZsDMYGKqMbiM3yaG29Z2dZ47k8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773308525; a=rsa-sha256;
	cv=none;
	b=BZlTik1za3j7V/wcdVOweDWq0P2OPRPtjwQMDHRBo9gOSdqqcFdlv9Eq7ItkkEw2T4mMl6
	HPxRW6mO5vKqb/IRp1mP+xztJ31s7mh5xh8IO6+7CRk8gdH+ALXbAdoA8NKrtgUOmbT/ql
	lCRvNSyV6UKZDrtW60A5Xr1oEyehDlU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NgSB5cm6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 087CC434AE;
	Thu, 12 Mar 2026 09:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21AEC4CEF7;
	Thu, 12 Mar 2026 09:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773308523;
	bh=XuAWzekBd7PCiZIErNzidx175dSNzqY/W8IQHYMvnpg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NgSB5cm6aonSSb5Kc8ap0Pfe0MXqC2Qxpb3j68QalfD6WCoKqhBp9aMXSIwy/ARVO
	 y6D3X5HWbMho5zs84E2+muSU/oSlF0RWLu3GfDSp9GY+h/dNsrSNvldjyeSTJdvUse
	 HIxVdlVPn9e/kfQMr+ah2AuBCw3N1gNx6+iFLfmcURnfbuc5jEzH/BkMplg3bHiDdF
	 tCJnYw3IsV/dGch9yhRqhyF8Ta0cS8w9Z+zZieAiJDdQLAU5eWz1IGSdjQDQrK+ZAy
	 f5yTLlQEDQn9c4wEquu3/VXVqbjSTcUaTFCu5YsIn6Mwuo7IwLH49T/Abo5ZpFyKrE
	 XbGZs5pVWbnVg==
Message-ID: <d55153d9-4ff2-4975-b00d-5877ae80a820@kernel.org>
Date: Thu, 12 Mar 2026 10:41:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 1/6] mm: introduce folios_mc_copy() for batch folio
 copying
To: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-5-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309120725.308854-5-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09EA880009
X-Stat-Signature: tjp1z47nzj6hzs4uoqemgf75gpe5zuts
X-Rspam-User: 
X-HE-Tag: 1773308524-441940
X-HE-Meta: U2FsdGVkX1/OI+AGdw9zgNrcCb18c37yj1XbAk6RHKxkYf1DigEqFjVt+8nla6xmkuh2ykfhznevmWAeITIVg08WP8hVXssv/F/bqxVCpHJAn9ee+RywaNcMM34CJIk/N6ABgrytzcaCGPcDNY9HDlVG++qzZiENesap/J8EDCx26K7JGkK0kOjhuWoT63EazVPEpSvnof72NLFWv7OQRV9de0eo/qinUg+bYWSW4DQ93ZJC/wldy95phg8dyEUJWvTycSLl6OhaLtFSxavBTcFLfuDbaneBl1PX6x1ieqo2BjrgE3r84P8uqqH/R2rE3gw04BAKYXiIQhDXi37vHQOPQDSghuv7y9qPkPy2AdgLD4VOSLdtT16p9NH/f+RofwkXaVDCNkulM9OMmuSpZO2j18Jdp2xrcIWMBpcCGR3VCUt5csMsFHJRpa3fMi225l2WEojIKzY3u2RO5paCk7DqoHSxeNp12xPvzq4SI5DswxaSCBeWS4DrLOrOxIgJsSr1xDpia6BNfSBFwgmXDTsnvjJrtJbVSlt/23MCf0n05vxdvLuroRk0oeQ2j+pCuf2FXxvXMjqM+3l1vGBd83fwb5nIOO/pOfrnPqVUfSHikiOgdLOBohaAsr6BUA6PgNWvWRuVImrnX14jHUie2haC87fM9nnaAL2kKoNhTlSQSM4EpLcYzJhM4JTf8LGFklWfUd3wFw4DQAQNTh1hVpORkcsHLi5Np7n1Wn7NJrsWr8+sXL1biauWl4CRYm/HbFGpysog34gIlcPo24+Bs46cI6wZZZSlkT8GLWVj1k+mhxnWn0MNmIRmH1IoIc6e8PxbEsf3DTDuWjvZmm7HTN7MCw3uqwrPLBXKEU+/QlfPE/w9T+dKYQ9uso8CqZ2LeyJGQE5K3CzviemJ1J3uwj6AgN54HORJ3+JOoEv0BO2QdLFmlqp+6ZFHrBXj/uvpgpJF21u9MaCf1JkkuWk
 qeUP90/D
 oAZqwpPsj8G2jLkkNT1iG55K076LFWzuu8eW/2lAhBZkthf1nnxQfXIcCNLZJ9wRVLKtYnbotUw5xTdotuE3vMlwQ4b4ke/nY60dZWxC8SxAM5OKEWYc6/shNJHBW7GJbzjyD/1+bVMrK9Ayxf0U7cRNFxSlrmS8j0esVwAES1kqLAiZ86Tpe8lEsdBHL4/r5ef/HA/c8Z1Ed45TMyHX708+8HZ0qRN4Ku88NhPg3cGid3tzlPBLZS9c6LgPECuYpL2Dhu5yppNmXz0j4GfW5UBCl5KdYUmNLFctUaRgeWeqZ1asS4JWc6qS0pcw29rMhW1X/fcLd+3qfDJexpfOZPdtAdWsQk9lWcHDyCVRFu6H1JvvZH41W3uULLjsWNgkMZfzJ4uS3ZybX0w0WNdsGZ8tJ1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 13:07, Shivank Garg wrote:
> Add folios_mc_copy() which walks list of src and dst folios in lockstep,
> and copies folio content via folio_mc_copy(). folios_cnt parameter is
> unused here, but is part of the offload_copy callback signature used by
> later patches in the series.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

I'd just squash that into patch #3.

-- 
Cheers,

David

