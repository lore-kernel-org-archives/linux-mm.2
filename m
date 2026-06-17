Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72360CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 18:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3CC6B0005; Wed, 17 Jun 2026 14:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585D76B0088; Wed, 17 Jun 2026 14:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49D5F6B008C; Wed, 17 Jun 2026 14:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22DBA6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:29:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90AD41404A1
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:29:02 +0000 (UTC)
X-FDA: 84890241324.24.5E1317D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E4FAC4000F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:29:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=la0c7O+C;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781720941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwTXKT1EWNTmd+zBnvgMaSU0bhs1xgsbFgpE70mME7M=;
	b=yIKpBmJFXs2k9ARuXzk8NC74aPhuTf/Z4PKn17oz82otLduBmNt6S/qlM3lKeFdG9g3am1
	RmQhX0q/WnQ8qNOxq2OiLEv5pW4J+a0imPQU6PdBEBMwzgoU9Gh1nb9NBQcAQgvmSLPGWn
	VC/B6cGWgtMXR+nH1ih2C0YzBj+5ZgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781720941;
	b=lOU73Kd+bcQsLdOg78+rBAkRZlneS3/8CE3v4gatdaMFKFCNZEQzRqJ5BeEJk+MyEj/sj1
	ycuO+dS+whwfcYemCDiP6asecN54aOWKEso9Kz2iZHbRk3Bl+hvwec76CujgPKGoCuG4F+
	fuqgXXL2rsxEPfOVYigbBAKBiDBphcU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=la0c7O+C;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA5A541A4E;
	Wed, 17 Jun 2026 18:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB46D1F000E9;
	Wed, 17 Jun 2026 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781720939;
	bh=hwTXKT1EWNTmd+zBnvgMaSU0bhs1xgsbFgpE70mME7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=la0c7O+CxDdY61dPhd78+22LGdOku/1cGY08gVvxkzcIZdFQeBHRhLVanabeliUF8
	 JpdIQEnd2ntNeka5WyYoIWz1vLwPcpk/yoZ4053foxf2ngPP5XrNzZZKAMYcq/g4xv
	 B2Bl38KAf/MZMETEs86d+ed5g1O25faaEV4otDbcX6qYsJV1+/mUj+MNSYW0o9StkO
	 V59XrbXrlk8t+JaIehn3v7zE5FpdRsMSimkAXiLPlKSdiUY3GVQrxxH6GVOGaLDwEs
	 hTK+8wVbWSjKopNkos2n0iGH5mjN0oIQ0H1HfW0Q9M/vJ0KI/MMA3Yq92n4nuYvqzr
	 rustaSbP31X6A==
Date: Wed, 17 Jun 2026 21:28:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, brauner@kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, david@kernel.org, hughd@google.com,
	baolin.wang@linux.alibaba.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, lorenzo@kernel.org, peterx@redhat.com,
	corbet@lwn.net, linux-doc@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 00/11] hugetlb: Use PAGE granularity index in exported
 i/f and adopt the common read_iter
Message-ID: <ajLnYRJdtA5U996i@kernel.org>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617172534.1740152-1-jane.chu@oracle.com>
X-Rspamd-Queue-Id: E4FAC4000F
X-Rspam-User: 
X-Stat-Signature: 4y7gpi7yqkg1xryzujyxdn96tpr9999r
X-Rspamd-Server: rspam08
X-HE-Tag: 1781720940-622922
X-HE-Meta: U2FsdGVkX1+LuKkEQjRvybnuohVjggqA6y/CJYVuMN1nAwQcE/v0zlSLP7Bk2qSzeEQtzNsv3lptfjDLIQGbfFbnFOHvnLJ4VXugdgeBNYtUn3kocUJpNhyRvocT8mN2kc63NhraR2GM8nMSGX1e+WIdJwSPrUcuMtRFQNuVWVFIQo4XugeC8Ed9aAq+gXuLb0YcafQyGmbdJkaQC3bPsit/Y5IvSSajDjGhvNgpmmZ5a7b24TPtxMkpZ3LLmMpJiArmk2tdirk3iedUOilUWVLDpmnLcXJ9oGBdxnXDJt/GtpNH9PZ2C3KemTve6WiHrNoKtUmKrEvpjbdZH/O/i8DOAVYU8uNLCOeRxpYF0G+Jxm8V0sOs51WIaujt+iUGwn/iNuIqrseK3naYDCkc2epUazZYweU83tUpw+BDvctXC+IgJK+MGMCcenhafzc6UdRLGZZxlCs5lENTAEmWjxqQBJa2BaBGc72EyFHVLcHKmTkPoUB2LZf1zhABLhALFDYuFkayJ/hmEoTX/qSSmcH7ZOVf5QUwcCLztExya8PHXnJtAaWLliLhA8v55C9PYi4U2LdzYEtTo6qjkwpj/5muMn6tvgkU51ocNHBrpU69aKSlhwhrooUl16och/WVEsAsQ2FJ5VRb4chYqiBB8zpX5uqq+htklw70eC8K1MEZFbGiaes/ZmMvhZiwtWxwusDGsJZWIdXPP6klfVcKK8KeGGLcwOo+l3iPGVRq0Sv9kK0ry8e6N4s2Xs0R2hUXTCvirZwIZ0NQQOCYBiy+JumD7tw+hgp2SRUNvpfMfk/5G031lv+sJFAMoXvWNiVPhaCoa5ZJM3lLURExXrmGu7eQEmH7sUlf13sHUsE1+JU8UeEAvHja83GVMoQa8VZISNOd4XxTUL0ekuBZ3P5bDFip2I39wYgH26qJoyQuoPEeY9GjE3yngwuY+r99JqLx4cwB+9H8hhJOF4uv4NA
 21vr6JWW
 lYSC6pqByX9Agd53qR+hggHufz4s30mNF3gfZ/z23RDXMKeFJfGmOhx7KEFYAmiInwLKYaJJzkgYFbYbBMI4VHzzdxbzJuvaFhxOkJxUz6mO3cHw85MUbBhYCqmK4G5fOyPXBuTn0xitTE+MQHgDPpa+O28+RVwd0UE36Si7dZRhYX73xooq2aMibA++GscI7jGVBZC+12JYbBpM/lEIlxeCKVzCaK1C7mVJymb0M6h7jf6PJ3NyM55xfA+FQrK7647eyD0PiT3cnC3CmW/OeuHUVAAterfZRZJr65gFN7FTVqJKjhLyRnn3dkW/5hmbTWWFUPsubR5BVJwRzEMVC7p+v2knFezV8d6IqMEjcbYKyguT9Z29K8Iq7T9YT5KM+Rpb8LueCnWir7cm97Q4O9v/f3O/d6QlumAkwORhR9gXLBg/6Q4dtJqS5LC463q4fI+b01JDGdCyiogh7seamPVqJIkh/O1d2gNoa/0p9tiqkWV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jane,

On Wed, Jun 17, 2026 at 11:25:21AM -0600, Jane Chu wrote:
> changes in v2:
>  - new patches 1-4: add hwpoison handling to filemap_read(),
>    thus replace hugetlbfs_read_iter() with generic_file_read_iter(),
>    suggested by Matthew [2];
>  - new patch 5: convert hugetlb fault handler's vmf->pgoff to PAGE_SIZE
>    granularity like the rest of mm fault handling convention, suggested
>    by Matthew [2];
>  - patch 6: fixed a bug in v1 pointed out by Usama Arif, also by syzbot;
>  - patch 8: did not pick the Acked-by from Oscar (for 5/6 in v1) due to
>    updates to the patch;
>  - patch 11: add VM_WARN_ON in hugetlb_unreserve_pages(), per Oscar;

It seems that cow, hugetlb, GUP and HMM selftests trigger these WARN_ONs:

https://github.com/linux-mm/linux-mm/actions/runs/27707843062/job/81960927740
   
> v1:
> This series stems from a discussion with David. [1]
> The series makes a small cleanup to a few hugetlb interfaces used
> outside the subsystem by standardizing them on base-page indices.
> Hopefully this makes the interface semantics a bit more coherent with
> the rest of mm, while the internal hugetlb code continue to use hugepage
> indices where that remains the more natural fit.
> 
> [1] https://lore.kernel.org/linux-mm/9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org/
> [2] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/

-- 
Sincerely yours,
Mike.

