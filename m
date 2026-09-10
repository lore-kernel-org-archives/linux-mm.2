Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC8DC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAEAF6B008A; Thu, 10 Sep 2026 08:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FDC6B008C; Thu, 10 Sep 2026 08:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E456B0092; Thu, 10 Sep 2026 08:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0466B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:34:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29413A051E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:34:44 +0000 (UTC)
X-FDA: 85197796488.15.3D0CEC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87172100006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:34:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrFIE8gQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrFIE8gQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043682;
	b=XCJ43Td9KXuUT7hRdEQ0hKvoLzRZsEqm6/Ysn1mLzj76411zl9F5qvcbvoOpv1v6N55Av5
	evMf5WNiRZOiJOVa8f+zSSQHy1e5MrA1CN8EX0b8YWbkEvmgManlWnAdnEwilSokF9SjJ0
	A8UefZstudWm3dOGHQBkoUruxROwtio=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SToql/8RNL0QlmyNgNcbyVZRZMo9Nm92xz+B5aj5Gw=;
	b=CXTnzaY6la26LHjiA0TMuqweB85BnsE8ZUncg0IJ0PI7KWYGNgojRrs233pV7/24k/R38v
	x1kbKpHgI+xZ68nriSWlFDdGiXogOY2XyvhgmcQef08VtIbXAGiCQ77SAZSkBaPlRhaWXB
	8FiBtCfqCsZjyaBCVokGx9lqYPCaLmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B990343B84;
	Thu, 10 Sep 2026 12:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47F51F000FF;
	Thu, 10 Sep 2026 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789043681;
	bh=1SToql/8RNL0QlmyNgNcbyVZRZMo9Nm92xz+B5aj5Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RrFIE8gQ7v84NTuotjDRyD4tILIQT2Xsh0Vj0Z2rUTS0mgBEtCl4Bfoh9OtwAOtYX
	 JHI8mutv1t8pRR/3neCq9NATaX1TSG1Suwzd/YioG04M14L0D9jyLWRWi8/6Le8Gv7
	 B7w7t+KVS6jsJ7COZ0ZXMrU4QRGT0egmnSffh59Ku6fhEN/GPddK9f+4ktcTkM2Hfn
	 gt05++xZK63kz7ZjI4siNm7jLaB462ptROeRyxUaluAcOWGgrExWNM2yUW9dNdghxb
	 BDDqN1Lu+ht4w98wVCZ299xiwY7jctune3HZrRxX8XACFaIeLrr84Xeldkurkbp/3i
	 QzX1z3taLHBJg==
Date: Thu, 10 Sep 2026 14:34:32 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm/sparse: remove flags parameter from
 sparse_init_one_section()
Message-ID: <aqKj2Fgq9MOL8caF@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-10-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-10-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 87172100006
X-Stat-Signature: cx3sofz31iw3ss4r8ekjtz5pt5itqhki
X-Rspamd-Server: rspam01
X-HE-Tag: 1789043682-578079
X-HE-Meta: U2FsdGVkX1/1B0akIGrtdPcMnoSCzfvAk5sMaf6n2F0k7sK7Epx6qmnvY2GCguOKPpAUACktNDi/PE0Kg0S8iMLYOmVLZmiPILbm6N1RdyabkZS0bdMRL0p10GSTUiwZryk4NKsU3E5m4132p7fZT8Mj9IKxLAASVpVDDUDHzpy/O0Kp8L75rCwdmEDpc8bmRtNW4bBBz9H/vPCMySulvOESVWK//JwNFv9f8+FrNu2l1j0TXWTSmgsO+iHmahp0Loti51CvmqBciLzcFxw3EXBoSdqqt0OOmAT9CXsenm8txCTjPkkbBKrCFwvGYPjnzMA/y2T2L21/Jhqy+IdQJ7aDQWGlv0cQQyjTvJIUJfjZ7ZA0Z6M25qiyiSmQ7FLVOOMhhmU3wxlu0SKysRH5d6KQNV3/WEk40Scfs1smFdT5n91hydiPDs632w3yOS4N/KAWbk2qD4OoSK5u5q97hCF2EJ8jlXcQTbi+Ru1noZaypsSoXnPJH1r/gcJhoP53+wSV+4VSZGDkoMsMNiGHhSh1ZSyN0xdhkJZLQY5ALXqhqDN04z7h+0d4mEUIFX1KTz2+oMkjD/LeQOlnKMeux3X6cLiKgjTU8nNefKTQqLKfuRE8erAjeKEH2YyqxwPxRCG7tTq1fZ1GPKSWou2hOaPsKERAtjaEit/ZH3G0U41yRgZUr3yZIUCuzsn19vczOuxnkInk+1BTYIZ7VLuQK3dRf2TJNO19DhSB/pxOPp/i3Wx44Aulz9to3p5twDYcy/fbMlW1hqRGCmaoX34qoj3kCwT0aRIfs6Geo5cwlZAb7QoQfEVGOrsvV5htB9lTm2IJ8xRwRIAdCoyPTq3mx4+xm0rpktRLEh+MOvBf5SrO5D2iqGZufZHqlIQnVn9i5kNRJBlh4LREZfepix1DuhUuMvVGEnvhKYBRz42ss0MSIepo+FtL6Rls7R8z+w8JMD23G4tCtSuv5726iPO
 dLEqgMic
 wIgtBsLYecWZT8dKu2vDmhhVrjgS/wxtrAp7K8cz1qxpMTDEbleWNRNRJI7XmpWqu2B1iFSDbgg+q7Lq96HZenKl+kKtNRIyjI+kQg2rowDGjbkdiH7f5j1yS+RwztNBZFAIuXIoBOrsAOTiLUROJmSrkxkPVdTXz60lWj0EU+MAR4xfLvWAgmmrTNCBAbLaBV3DuupaJWlD6KwHp1poIMdAV47OtPetdVcdL7gvYqnsmFmEd8KnaWdSVUIffxhf8ZCopbqmQAcg8zHvcs47JFJKd68/x4h6k5nRaB/oCBvWeFZsxbSUwAH+yuVHKYn/XohlTdhhvcFTddy4J+wYW/cmyHNsGTEdNlg5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:03PM +0200, David Hildenbrand (Arm) wrote:
> Unused, let's remove it.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

