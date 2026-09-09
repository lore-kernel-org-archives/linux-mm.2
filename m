Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B238C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 08:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22BF6B008A; Wed,  9 Sep 2026 04:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4B06B008C; Wed,  9 Sep 2026 04:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC36D6B0092; Wed,  9 Sep 2026 04:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A15FC6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:21:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4D541C0243
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:21:49 +0000 (UTC)
X-FDA: 85193530338.15.1018893
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D43A9160006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:21:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uv4c86vQ;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788942107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SfF3JxURKislvoLHd+K5OwNU/uCTCtJ/cDbpcrBRrVo=;
	b=4GdZWVKNQlxpfakcXSHQyc9RiT6Z4Z+XwD2mRBZ+D1HYptjMZ13Q0NILPiMjbxSGguYq+B
	yWNHAAhOAwCHfYGqkIoBHU66T+uLmyrSR2OwLwDETjctvaxqOjLV0tKem5Wkked8ejstIZ
	i/rgHIIetsX9L44GEsAbMs4rIoLIbSQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Uv4c86vQ;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788942107;
	b=WZnvUNfpmH8XEgy/ukoXb1AyfF2EBUV7opqw6lu+eGdBByU2VZAWZxiCCkbeNJdiErkfbu
	9mna/OmjLJCSB997mZHIUwGpR5E8pIQe/04LTPc6S36YIla1GIUf1Rik+YUOfPxQFY0iWk
	hUCb4dyKdUxv8rlG4/z31LSGXlXjhBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0606841B5C;
	Wed,  9 Sep 2026 08:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB9B1F00A3E;
	Wed,  9 Sep 2026 08:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788942106;
	bh=SfF3JxURKislvoLHd+K5OwNU/uCTCtJ/cDbpcrBRrVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Uv4c86vQTCv4xfC0nS8VA99y3SRZh1rvi1Nj08CIUp+Nj4m6mpyHq/HOVh4Fe4VFs
	 pqLl+zVJij3ia32XwWmggUO38Uv91pF2bDaNffMHBWG4IBaGayiJcKPGgdxhCTkgAQ
	 FolW2jpPSJlZ0PBvBaRooKFklN6yV6L0VknhpAz5SvOx+kq5mfUdh/Av9nlxNUOWUL
	 MNXpACIa+Z/Vw7j5y2iSPrSq5TbpeMpCE7AgxNSRt4ydQjqMXugswPgrwVXD1lcFQF
	 japQ2FjinTQHm74YKLA9IGdGsyJMH45xEJr2DE0bLC9wm8n/PsbtptqTSGxd+2rceE
	 tomEQ0cBJKMkw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 84E2D198004A;
	Wed,  9 Sep 2026 04:21:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 09 Sep 2026 04:21:43 -0400
X-ME-Sender: <xms:ExehahkXr1Iw9g_tHjiorO4Znnm8yMiZ7ANUckjjMXMypOwWRm-tVw>
    <xme:Exehav5WnoPYSEt0HF_k3ogH88sPOcj5hC2cNsnY4V66yIgXQpEj6B9TlTpfCeqS3
    ygP_ursH0XGSQH1JqN5AWFy8G7zqVaM5RHVjgMSk9ws1yxVNHkUoauw>
X-ME-Received: <xmr:Exehalti17Vj1kmXfJIM-qS4neBz_b8zdOPTCPugdPEKRfBDQlOLrpg5MRI>
X-ME-Proxy-Cause: dmFkZTEcTcHQ4MngkuVgRvgCf1pYu4WzUNsiawxGcilgXUqmQ1oG+l7QhW/s6HICWDIeEa
    PQfaB0zQ7ywHUBXBRzm3D/YBMjJRsDBA5TdAGDbETxCjzg0l5Xbtt12D1dHBki6qcPpAk+
    baB+GykBIXQo70A1drmvwTt8T6Einn/s6xy52G7NYFE7zenfgyWUCypXrC7Qliajo/L3bl
    zt+6zCRDD2YjDcJgxWmAhFN0P4D8A/0/SGnOOpqq/8cKPStit04/XdTFWg6ydCGu3CWx+e
    fHQV/89X7tINX+yQGiZkTrDYgZ7RNTM9zMHBzXwSVdQWovc7d+SIs/o6QZScLrTze9fAty
    1qsGQWzHzSFWL+VUKPSQJDshh4xREQy2Jyb/6YiRF5LgK/4A+eWOgy717B+F3lmcOo5IOH
    S+MOxLtEZT7nhivp6HJPmdbsoVfFG1paS0y91FxHWGAeP2oqzaz+HZUy4CCi2w0TKxRrV3
    aemW2ZYGoBGySi2b8Zu3hutBeDmx5K0d8UEnZBLg/RazNGXEc0h70/gTMPgb5qmf/Y0zw9
    MAHulkaHrhD5f5JUuuhyrX2+/+RybBV9jyrM4qHPYWYhbD9EveTRIHCAVVSBOy6bweX1v9
    qeFK06YbVb9rmxQ1EehxUv1yzlS8t7jC1/n27vszQzUnCqhw0f0/WRlijIGw
X-ME-Proxy: <xmx:ExehalDjPivQmTSI230Hn_z3uWT8IT0XdbiBhprg8dSQVWNZU8y1MQ>
    <xmx:Exehal_VSUm4Z8x9uydycDUY7Q7Wv2uMq-CLTaKb7jvlLZx0MmtxAw>
    <xmx:ExehauQU7KzKa-LT1AtNfzPa74H36wJKMnvIjY3G21OzvGQzDH82ZQ>
    <xmx:Exehau6tYCz-C8nUtki10g5CS1bWqmVt9O1m_lCAT-oBKCTNkVah9w>
    <xmx:ExehamISSlTCcxEQxbYmBOtugQelPpVerJ-_UytzrT0GabshIhZnWfTN>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 04:21:38 -0400 (EDT)
Date: Wed, 9 Sep 2026 09:21:37 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Yeoreum Yun <yeoreum.yun@arm.com>, Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v4 13/17] mm/huge_memory: move memcg switch into the file
 split helper
Message-ID: <aqEW5zTARWWFf4L-@thinkstation>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-13-b532a3f20e71@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-swap-thp-cleanup-v4-13-b532a3f20e71@tencent.com>
X-Rspam-User: 
X-Stat-Signature: r5p49d8q141as5t83h7bkbzer74ne88i
X-Rspamd-Queue-Id: D43A9160006
X-Rspamd-Server: rspam07
X-HE-Tag: 1788942107-323001
X-HE-Meta: U2FsdGVkX19dcLIGyz2XUDVly4mRVJiPiFvTXSlma3ntiP9XAyewrlHTkzpY0+HXSZwecClo/BcAMTtOSt35/wJjUWxrYbad4tsvI1GuG8YqeW+Es+8niBQ51/sVBDg6zxEHhPAgu2AWULJArF8yvrrMrbIWaxC0eTgWVpsad4Ysb93DABTUzMfUoM9Iung9aJPHz/yeuAAgdCjn3Jvkg1FvhGqx5UbNDlsPZ2Cegm3wsvaugi9mMKIbXpPHenQp5dXCbmLaoYnrAr0ruP2dwu6E2N5WWDr1CD0ydQOr0bzbCsO+p+dPNCR4V+JpZoDyLHdHtosiz6cl1+tqGRJDtTvawNPVnZBuTt96QDC2PO3Cj571gB/hr+AR99RvXGMFzh+Q54YInCnr/HySwLJXlLQAsFFWg5jRN4J2OHJQnU/pFkn9rdwUinmWoWntEudwSvlsWjz7QX7xJ4G5DfcNY06S/NCVNWm9r6IBcw+ITIfxXWRTgxtLB56pauOKjUJ08i3CYKHJfCH3iHVCIfJjLm0WwFFSwrGXpaeWHNCJUOFiCEGWBfqR82K8VU7NjRQHMbMPDVrDWiQ/cEEaHH741ZRmploIE0FDWV9FgJKWbe9p8tmSt/qUkk7wxOYG2qG3G0VV4CByn8klFhciylP2TSPAfFD0fNlixPZm2215B2B6qcCXfkohkhZc1mh1CuSiCqLhQg+hkwyJyqyrZYlmhnriRgI6uUxliaSgADNuVV4ZyvRL63u/F0l1HhgYFaARI4qyp7wtZbbQs2ayBJFuXluySaafIaLcDHYJUt+ueFipvBiblNzQr/tV88rytiaqTBGd5qQo7zpaf25pT68HvY4QrUcvwno0Aw5i/TwtBpQYztTXQBCz+c8EprsacrwJ2enRc1MIfNEKcMk58fCZjQTMlfsMWZ9KURQ6fCFQ6r/tK3b9qHlQwridORWiFQqDpJPG1O9qZoFhNsgpcLR
 Id0USO68
 ulwQEhlkijnO5eNy8YHeFFoYbQpK8P1rc2GKg623zp3yLRfsNMxPLejGvy1j5V4QOfes8TGLi6a3p7/yis0BZ8RGy4j1E0ge+24E4wtUIbnvKyE5wU2/DDF07f6I6oSRjOyVTcS9GOVXfF/9zrJng3yuG+sCpqp87ib+rW1+7dAMDmmWzv87lpxZXsmbRkS80gfCK87zIPCSdbFAVXyu2+BcRgczmNJw7v2s8wL3AYKvqRdSTQOkYUY7toXEL3DUrfHoLJbyzLkYknUykdfgtIHR9wvXKpBLE3gqPUGpZmdCYtIHLZ5t4xQLJCUPY7tmBO4DoM7ZkL4dW0sFtHxRtP4iJ0GOx3FCtdkq2BW43x2T/YeWfIQY4OOFu77DSuPSWf96Jq7NAdVRljcGRUYO23BjU8pR2Z451Qyk9xeX+SZp8Eu/L2nQANF1+rz9ARXUZfGVEaBJNIW5JE9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 02:12:17AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The xarray node allocations in __folio_freeze_split_file() need
> to be charged to the folio's memcg, so move the memcg switch from
> __folio_split() into the helper.
> 
> The anon split helper and the after-split folio freeing perform no
> chargeable allocations, so no memcg handling is left in __folio_split().
> Rename its out_no_memcg label to out.
> 
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

