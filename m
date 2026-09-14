Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47738C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4466B0088; Mon, 14 Sep 2026 09:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347046B008C; Mon, 14 Sep 2026 09:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7DA6B0092; Mon, 14 Sep 2026 09:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E868C6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:36:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0AD49C0142
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:36:34 +0000 (UTC)
X-FDA: 85212467508.01.2F29A15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25566C000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:36:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbRqgriI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789392992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xz1lKKAPTU49kJE/WKFp+pM2D18qghdO/ykaxL8bDYI=;
	b=c4F+juxlHQ58rXeizP3+3jD8UH4Lab51Jd7xwWXOleJmpaMJGZhVVYN9NxBitdSMUN/Y6I
	1ifWZ4acA/al4QtiYCAmWGJFz4PzcgGuwIVtCEnTwZnqknPtlUiabsZrOC39/8iUsQiXXv
	8dxHq1R75fAL5gt5AXDk1p2iSelYkg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789392992;
	b=vkf5ukDRWFEnm3/Y4Z3RrkiWotK9M1ibiEQFCgziEfUzON5fUe2PZFre/F5SJwXpd9Fwkn
	5/PfJJp6SX1Xww6rpcC1yeTefQMTn6zA0BgbvIo5K7YjrXtzHrGJI50HpIZqSEAVCC7IPy
	Xgt1RhCm+Xldm27LLczMILLiQEg5W08=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbRqgriI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8074443C10;
	Mon, 14 Sep 2026 13:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEF31F000FF;
	Mon, 14 Sep 2026 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392990;
	bh=Xz1lKKAPTU49kJE/WKFp+pM2D18qghdO/ykaxL8bDYI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CbRqgriIm2+dHG7z6Akep3ysV1FyvxsE2dnAwFVmaoQQHtS5nlrG0D7rbFVWtzUoC
	 K4kbWPgrM7PKtYOvf0MVr8HkY5u74RMXRBXQGbMazI+LLLvP+OnHmDOtATrBLYtiwt
	 YV5N6bYLBsWjS+INkT1q9S/FfLMqFUdJhrvRLX0Mn8i6wM78b94MDbNesfrrio4IB9
	 wlMOEJunVKOV9fu8xZqa2FVKfn2VOZUE0e39ujABM/NNfy+31kj/QhRxFZM299eFjx
	 NMExfhQTHbGkO9gi7GzeJhfgmP9LUPL2WnBBvO+H6JcAWg4Pv9Ltj8wmL8mhd9PMJf
	 L/NFO+JlD1uNw==
Message-ID: <379c3f9a-6a07-4128-b776-1a0d17b674c3@kernel.org>
Date: Mon, 14 Sep 2026 15:36:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 15/16] treewide: remove PagePrivate() and PG_private
 from comments and docs
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>,
 ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-mtd@lists.infradead.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-15-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-15-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4o64cz13u7driiskhxi1wadetcb6hmxp
X-Rspamd-Queue-Id: 25566C000B
X-HE-Tag: 1789392992-387914
X-HE-Meta: U2FsdGVkX18O0G+lhnQEz+nx5l6TSovnMORs2O5BuvsUVMYzsp6in9/98p2eNkWZ4Horma4P74jb7JpCDspgztRVTiqYt2O/XTfxt+iWINaxj/AzNp46gQkO8A29y0g5MbWjInawtbnnBDmFGW/JphyHr0NBz+zKdOkgtlajujZmCgZ8+sJc5pRrdu8woLQV/GPZkavWMFbj9VcfnTYl4cmHd+671Wv4fI212wvOUOBOIL/Fk2I4GogtakU38xc1tlytkeBriBqNewtl/Zhb8w46cKmO/6ABogg3DyZgXPXratUZJhAG5xixo9f3XmLto4OFKiqWG9CqcxtZTGbtQjUsLXrUwNV7FkDSzFZjclr8hcDarEIETRtft5Uz4XUIECISLkTjRXURoLJhDMsTvU3OFc0f4WyG602D37ESLN9PEw7TjWP99cRdq49dcgAxwvGaYPkahiuPKXMfXRSel6pSgcpxVj/+jGRr/+cCn5ktr3Gk8JGOBo/YcDwPzoCDYWLgMkpVaM9mDlJO5CI/CdNMv4CXS5I87zFoi6ypcsvcuVSsYTEqhzb+1BZKofN2ODfKdUCor3ff+yGisuK+sL3UwNiNhJE0ud6ImUCFjOMmvgChDN0Z20X4fzXxrBOJV4EZ2qxHZHPNI/A5oHfYAFiT6Wvla6YjkVbtqOqKgLao2aYqi8BGSEzkXJ7ert7TlhdK9YOpyD6mrBdokvPPbuoaJxK1qiqvX05kfm+NMOr3SJA308F8MG85JMYDBD8VcoUzA6TW2Ql7ON6xS0KCHNB9C1PS/w6uEZRbescji5gtsadtSANB1F0DMTq5dljHW8E4VutoisXcSb4UHN2lWfu/fQ+9nLoOM9KgFF7phej3+GJ5SZ7ZmrN0HH/1k0AP0m81X/CgWkrfez4oXqAkxv0w56pHifMrLy33L0D0N8asXdJNsRE8N2DfQGtnIrEHG6xAS/dzbIIRd7kmQpF
 M/vpMnkb
 929GVmGQ7vZOejEbqLeSI4VXfydiZ3tnBdB+dbzl2y3afX6cK/U9CvH8KhcT8WjXfJMHi4uqC//yhkbDfwrOi4bZwroYAiNmlQDJoNlD/xwuc/4frANBt/7Ct3digW5qM85mYDiT3VB7HsbNB0V/fEo/iatvK2Dx1Lc/ATh9oXPlkcllKdFxy4AJsA/oJADrzLZGtX5n3YZDGtiUnsKsGPNNHMeiBv+S3A3HAty7rj8sWbuwuihXBz5GIaKktqc3/joO7mPaFvOi7/eu8LGThCoBVwLaF92EiKLoYBlR9lTamXLBfsD4LjwPnFschjjkoYnkIQyUVSmU9U8/fD+t964JDvOealuDjOa4czZ9miVeNz2YylzLSvBeHP9cO7Naj1RvKygnNQ1/aHc8gLfEbCm/Llz0DVOxWpN29S+1eOnsyrd7dRKXH4i9NgsroqO3yV58QTc3KqBiAOQq9SRM590coKXgFNIETdb1YmGwzq2ISey3dimGsWkx4JkGEAnr0V4WpSsF4otPP6M7dSDprdlww7S8BhxzQb0h6owJnFqxbqqD54L8l2/XjVRRarCmtWVJnkbVpNPhoQOhLcOUT7bPI5WErbZDbWQYa4xXw8ID/Ihk/HBk1fzjvVPRZgUPOGbVrG/V+ltjzxw0gkKsscEFI0cEGB8ZBNXTEbkfDq4knwlBQqSSbCUuXmrOAlvYMIua1eLAeD5Wuq4cqmNFltoS1+dlERNjA4tONp1/l+X5jjyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> PG_private and PagePrivate() are no longer used. Adjust related comments
> and documentations to refer to page/folio->private instead.
> 
> hugetlbfs_reserv.rst is outdated and left unchanged. It should be
> rewritten.
> 
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Ilya Dryomov <idryomov@gmail.com>
> To: Alex Markuze <amarkuze@redhat.com>
> To: Viacheslav Dubeyko <slava@dubeyko.com>
> To: Trond Myklebust <trondmy@kernel.org>
> To: Anna Schumaker <anna@kernel.org>
> To: Richard Weinberger <richard@nod.at>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> Cc: Zhihao Cheng <chengzhihao1@huawei.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: ceph-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-nfs@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-mm@kvack.org
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

