Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD116606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ePJWuSs7
Received: by kanga.kvack.org (Postfix)
	id A8C0C6B05B6; Fri, 27 Nov 2026 04:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C426B05BA; Fri, 27 Nov 2026 04:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952976B05BF; Fri, 27 Nov 2026 04:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7267E6B05B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:48:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06FB1140278
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:48:32 +0000 (UTC)
X-FDA: 85480424064.12.B795E1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC66380005
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:48:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePJWuSs7;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795772909;
	b=zOQniib1k7u0DQ4A4ueQEzeE3fptenzh6ataQ07GqFpbZ9GtkrYrNSnlepzah1+2G2qORF
	atTfnUoKFxsUAqdspbAQXzgwhGJP/B/6Aa0zFAgrsEzM4mNRoYcALNU51eV4NylageRWef
	kTJLrHnyaMV616QoyIf/FOLmEsMXUWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795772909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epkIPtG5+c+GHl+3f6ueC1zpCmkM49EEu5iyL2i6hAY=;
	b=v5uMjPkoya6CDcVRFUVMc98H6DhVhkMYVU4cMqHSIkUkd735jPws5sWQtbvxY6ED8ot//S
	2VYoOmMYdFlokCbOEgtXoRg/mAPI+jibf71qOIvTLEbHG5KeZ/weFFpKxnwVIdZCmVCezl
	vUchYDAjlxmkdswqvf8I03f8k8Kd93I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ePJWuSs7;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE3B845874;
	Fri, 27 Nov 2026 09:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D1F1F008A0;
	Fri, 27 Nov 2026 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795772908;
	bh=epkIPtG5+c+GHl+3f6ueC1zpCmkM49EEu5iyL2i6hAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ePJWuSs76WjdR0Ierq65rsoFcKNDoyKM+5HVkHMoaUEtkhIV+yo/rQLjycxEJ4s84
	 VaoG7m+nDYcLbmPtyUciBrHU4KwQ7kPFceE3jb3RdE1fFrT+083+67B+/qokXZg6df
	 KjmW1Qx1F+3g4ICOr/CvB14HuMTdHVK8k9rKyjXuTo0f4XlhBOHXa96ggHAdsauRId
	 2wwG15OQZqrCZdPkJcKpgkPcIZ+yIPF0/efxW9OIPjJnvtkDz83pAinj+6Kf54wRtf
	 8/caKHQrpZ1Fx8uSd/F7qlnJ99gUVF/0WaqukPTbWOMhQXeBaHeEROFmJR0uJzf0+9
	 fG96MPMwSkPeA==
Date: Fri, 27 Nov 2026 09:48:22 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Maxim Muzafarov <maxmuzaf@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Yu Zhao <yuzhao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] mm/mglru: MADV_RANDOM page cache never ages and
 thrashes the oldest generation
Message-ID: <awlRx2rh_7N4fT3g@gremlin>
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101160427.85701-1-maxmuzaf@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC66380005
X-Rspam-User:
X-Stat-Signature: 3fwhwtqrgxnfo11o4bccxohihd91xxap
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795772909-369055
X-HE-Meta: U2FsdGVkX196lftxMm4KuSyEv89fk+/8Qbym8Dpr1AxbxA6HvK8SZSzwNWy3W+Kqng1Rtxkaw55F0kALvQiMMmeRIhrqNkpCGD/jys/soIvkIEbkWAILZ5z/fIJCaAAPDz2ia7EtEBXpUII6w4bm/brcZyqIhFKxCiRdx+7gldUKqvUQw409IJdW85vsF5iH4l9/rBagnryOaNssJqkLGRTxLxy5WEBYFsFsEZOR/sPpQJHzGmyjI5VbfA+IeOm0PvSPHzwxM39Q7t1UJ9HJu2K8kFaGRn61sdFXOuRqj6tn6KlAW3vIGKM+5qkR6iyeoUO9NM7OPRSo235j+sXRSgIbHX5bnA2kQA10E/AShSRw5b4yD4e/gjqyglBtCMKSTdrtJiBIRiX4g6n5BkpMkUh9LCweMVdzoCr+IrRDOubF2toDjySWSNrqmsfn5IGmesI+Ryq/xv+BGkxc3myonFqidYBI1RMe9KSeonvABO06qe42hEl7e0/3EQfh8MjCjxJiPhEUWrp8ezNMYV16b4EGI5OX+AVR8OxWSqP9/mV7rlSMbYn5x/WEESEU3Ry86OKo/5K1UA3faxBj3K2c3MG3/ZPbBm/FnDHjvFqDyIfrbdZYl8x5V2LchSNYeog+NbLL5ZLIyxNiKo+9TN95vbqDaKElRWdL0jr2IpKYv4nMhy6INaudCo+rD8BMn6iAjHjBIhx0q38tGvJF7ogTYQDUoK7+LU0/aKvHXPVK5X3b0bH7UZf7eV6OLESNCoeM01n5UkKkeFE3OsKY+GGjVAZR6O0rgFxvvkGGHY6olB5Uiiny/U8hliRDguO/EPVBtRr+CyhIULCEUE03/AvLtB7HLD2NPcfDa2CGRi9ZUxhA8fs3j/l2PSAbIZUhnOyUo1lWuj0OmhQjAqFRHdHzvg2uhxz2OTVKxeSj7i/vh7fenAYr/HZ4FA1C6sSIF7ZF4C3lXSRgDKDnqwe4sc6
 Ixhj3375
 nwfO89LAnfh814KbjWyPzeY65DRuLjsy86ByYg0uFtxMB+xgaMD5mV2rUT2e03znL1mgOsTWMWiPHZry4Cm+gdegU2Zq2uy9BOAjYxTubtZSiNBI2QO+OFHJILHBfqzRpQlqFl8dIn/MXnVTvg18HEXPBBzs6E9LDef2OPxDMq8rPeenXbWtEVaEgw+JuVMIHP0sOMAkjpO57woggLn62Y26vUZ89B0v+PsRe0Zi5/D/91+ilBYvcJiMbuRwzjlPkp76ta3RS8ipfuLGPIbgNCq2rxXJOPh3JoDiF3x4ISn4dOAyCpnzBHGVSKCLVPQ9tWRHU1YQWUJ4c1Qlkj1Xq1/KXunF+kM1HOqS4ZY3MhOLXTUdxpb7KO4uLdHI3QkhYmN83xeyzNBWUkmRL2X1gLlZbZX1HnsZVIpXHJl+EuYWHu02BAK5tqDLvAulSLIGcwbuZhmQH4RVV1/97Q4+4L+vbReuB5nCYPZTahVb42rHzScdmZ5PsxQTdK08gQ0SwtbKLlzhNseKywssQEZ61fYKWLtM0gOrIL/7CdyTArzQ7AmipWSlwNaq8+f7vrQniKMH4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Small nit on process - please send single patches without a cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

--
Cheers, Lorenzo

