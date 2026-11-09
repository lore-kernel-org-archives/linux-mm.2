Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92B45606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PWMKq2ci
Received: by kanga.kvack.org (Postfix)
	id AD9626B00EF; Mon,  9 Nov 2026 04:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A638B6B05B0; Mon,  9 Nov 2026 04:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B796B05B1; Mon,  9 Nov 2026 04:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7045E6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:20:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E34501205DE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:20:51 +0000 (UTC)
X-FDA: 85415035902.29.37E64DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A4EC120005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:20:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWMKq2ci;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8h0PI3x5L84bxHJWgvhwyPcSqbxezc6i6wUfYwT0/gw=;
	b=LBM70OJFkET+2HHNGLmgxCpmrmQZQQXUYJ6C4QbjHJ0BS5v4v1wgNWXL5QHodNj9okpTNJ
	CvD8SM7VHTquzWNwGaXbzwnWMxLuOV7hSFx7pwiF66PV7hhHMzN+bvRAa4HMHkN5ZAZsir
	axollebc9B0ryURQklhmNy2hcPNZXWM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794216050;
	b=LDzHV7SOaNxQccbdEd0CP5nOEn4m/q3wqicIaQrRH5YGeebOPzgWZfOD1Vp7W+8gcY8HBJ
	IJgbNlDbmOmBRJ6TRXd3gVvCE1vyAAinTqkjNBMXk2IbbrrtUyEOuXFMnp2lfX1S3JJH/F
	wsKNrOxMdZHAAA1vKzYq49kmDhQd7M4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PWMKq2ci;
	spf=pass (imf29.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AEBB43D06;
	Mon,  9 Nov 2026 09:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B8531F008A2;
	Mon,  9 Nov 2026 09:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794216049;
	bh=8h0PI3x5L84bxHJWgvhwyPcSqbxezc6i6wUfYwT0/gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PWMKq2cik7On9nLBWZZo+q2yFr8sWXi/dqsHfAOWf5G8lTU47xEhSOhDJMI8XikaX
	 5m07d7IVQvL4OmfmjXbpZC1xKhl0bnPIHFCc1+GnK9lePH1J9OXffOSC3rolXJf+DP
	 k4ocKY24KRkrPS6q7WNJrkW/H6guwGWdd1Qlf00BWCHthyiEskC+lVYU1caVCSxDJ4
	 8mr+TmUNdQsWrTcx+JFHlqbf5vM/T8amfu0IckZaVZKSK+i+YeSGHR/TccZjqYXArb
	 yGxJbGTMk29VHdRtuVjfBsvlx9exyhCVwGps8u3eDDtXsofy9sTxR1LmMTyHZmh202
	 /IyFsFh/XTSVw==
Date: Mon, 9 Nov 2026 10:20:41 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org,
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 4/5] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Message-ID: <avGQadeXQU0ayFYv@localhost.localdomain>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
 <20261107043122.25650-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107043122.25650-5-songmuchun@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: s98kj95px9htj8kk6djemtekzzzkmkfr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5A4EC120005
X-Rspam-User: 
X-HE-Tag: 1794216050-235858
X-HE-Meta: U2FsdGVkX1+BnAj/j2Y48dHxp+xaGMRk/NEQAIvAttp54SW21ByAHf30WoEjdsrL4z8r9pdHQdUHstThx6vRfgWEwUneFmsSZXd5ZVpOG5DwgNh1oGBR+5ldUiqsBtIWGgOcgp7AWPhmvcd2Z8UxwBJ8ah0y0WVA7pVBNx9gu/nHayHvDGKdYhNbp0p45AwRwWx1Sbs0CIw/z/YY851tWl9YORAOguYQ2b027od2CDVYBrzHKWp1o73tffrVARybWs+7m5p/6meWwigokSh0bKDAiobd8rMQsT3tdwdcrTZA0HrP0yHLY8m6itIipYKu/QrpHwCE5bEtQs0OIbCpbO/jUVQSMlFtu1AThWzSWXe+mDvZeb6du2Mivv1kRv/O7/xZ0fhPHeBf1EE+uRsrhpXx5IAzGxkf8jsZxY4fKjj3JeXyI2Yiisu55xVgbsQ4gkB5HqCq4xg2E/C6QwopPPjpppmUGmXbmAKBjm2fn62dGuivxxfgPZvDPG17R4AZIHAkeIb6GzSwKF9XLxukKqZ4jviuku8aTNCJNoNoo45EbDpjQxMRbovks/XPoIwT0lSSi8zo8lqjPrBkthCEDp0EOjtx9XTvDUHm2SYj8ZakigZ7EjnHNEhY8WKEVaEAoKamFtQlQpZJKq+JdEbYbwmo9RbUTkNG70XhoYhWBQtZpDkaIqfQNS/bAlx0md17a7MvCJnSoRbYxihItzbF2nhuqFJySi+ulPTTkqyLsQONOBCnkh/LOECSgntD6JTwCb9xwOyqqs61ARlO0SefNEDX2+On3yYrVFFyyWwOqBlFQgLO7HLORnbEdXbicEGwc2/Juu9vZmR56YMEccV/l8cDCeteYcoIAsIC20+aOsorTtYzaSSZEJqry7JWP2rMKfC4PVKZCzAJW03+cIOIsEcyZw/WnW95guKNTicCi+dpwTCUgtXCfYcjEqj/PRZ4CP1FXDaa5SbwEdI46at
 s/JLBb9R
 vZ9Y1kKMkPApXSPXVvkJBcZwRkvKUSP67VeZwJ9lumTsEciyXYTCRJOU1BZ07q+SIRqkUPT77nzUZTuSrDizCTQJbozlq+1qZ0VTG+bE1+eW3tLiSrejEKFA6bzaLMBgIgFcDN6W+RsbJV8obHBmBTKj+mZdHmGIDzYW+9BoyAcgJkKMKnXjQAMXi4SZyBKxQlsjaN8jJh6BYyWwku+6LtQzoBniK4qGAoc6+wLPrIn4BJZzewwqCYSmxeWwojJ0P6qO6DJvNudSwx0uc6NfZxDTi5ezZzrZb5JqVV3gblcpZisS9S/y2oSHdt2w4Z+YcfyJT+ml3x/wgr08t/MKD2NQR3FAXDOuh4H2vvOdNlutt2D9Iwfub8yuOxwqdmgLehcPm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:31:21PM +0800, Muchun Song wrote:
> section_vmemmap_optimizable() can already decide whether a section uses
> vmemmap optimization based on the section compound order. The DAX-specific
> vmemmap_can_optimize() helper duplicates that policy, so remove it to
> simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

