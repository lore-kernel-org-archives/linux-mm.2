Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CDCFCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC35E6B008A; Fri,  9 Oct 2026 01:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74186B008C; Fri,  9 Oct 2026 01:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8A476B0092; Fri,  9 Oct 2026 01:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5C276B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:11:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20DAC1C27EA
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:11:20 +0000 (UTC)
X-FDA: 85301914320.16.1FA9E14
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB380A0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:11:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H710X+lM;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791522678;
	b=XFsV1iNgNI8fZ+16TOD4Oy3gHdDXlXfWGx8I6f7IG95PNC16JAReDnZl7ZzIG1jviRgx5C
	pATTkVzvuDD1tkTT7EFz/Etx06XLFKZ1bzLTjlj+WEZmRSHb17uZMt14gmpkieF1pvtm7H
	s0sAzMp5E/evrn7X/h3oDOJUbucx9qA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H710X+lM;
	spf=pass (imf15.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791522678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgYPlKtd0W0m89v2pwIMLE7SNT3KIwwGP4CJHnEB95o=;
	b=2CzeqNGmYcnFAmgBF+yyJSp3tjjHZ8aSWzr1JrIOiI1+AR67N4tpmCHV9fRuO8fDrZkHOs
	z1Yhks8FE/woIIeWw11mMUHdcfh+URzbY/ePNxtDCWFxu8m/n9bY1dUssXH7Zmb9QLAQiq
	CzLSJ959pkQrMDZfzhkPNsXeqwp7sQA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56CCA1570;
	Thu,  8 Oct 2026 22:11:13 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74E963F8C6;
	Thu,  8 Oct 2026 22:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791522676; bh=lBjaAdFxpfy7crc8RE8VGmgtFxkCYa7iM970O1toESg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H710X+lMdqIZiMuj3NWGtOeCHDSwUDjMIKLflt5xeio4nbnyKjJvBjo2pgFFtI5g4
	 uzGiWDykHvTVAhVDt3vH2us8pXrJ+Jt8/hywbgd1E/5VzbrZHEzuw/bTBJJPM/OVc1
	 nMPDLnx5D3EwBHs9gv8/0SbaJdlRWGJwLgUezDkI=
Message-ID: <4ff35e20-9bdf-47d3-a96f-8269224cb826@arm.com>
Date: Fri, 9 Oct 2026 10:41:07 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] kselftest: mm: rename read_pmd_pagesize() to
 pmd_psize()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-1-54378ae45add@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-1-54378ae45add@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB380A0006
X-Stat-Signature: ajxrc3hmf6ubp3uqsp9bu99e9ot1zt7i
X-HE-Tag: 1791522677-623814
X-HE-Meta: U2FsdGVkX18Y8VEWoewqtltFv1N7dzSy41J9Q/oj4H5AFerDTF64Fjev2ciGMZofgYsa8UgzBzXCmPUs+VKCeTt+Adi7WvixyKVFb3mAqQz+FQ57MNSd840tLW41jPhKvAivCzLvRFe0qHCmB3skRqpUjMYhISEIxJJjC8qf8NBi6uwwPu5L5cbQj75ISvdK/JUg6XidhJdXGyqhhKfGL2QVfXONRRf0wlMTi/2lNtX+XNQA8lMwetK/MnpmpCx86DGWRCJ/lELSTCEcVsjYIgop/UrYJlzUIFv9muByQ55clatOlGyUoY1LJzHQ5GOPAAfK2+KB95eiewH4eleJPDn7kYj0iTOjCxNbG3iEwZ+3C3Pc7Wy7Wd0rvyuxEMwd8lQEabUApM9OF/fnKbnHAvemZ2e89+MHhsKdXXkgNnW6BiWZLzZbjGl/7XIRXeC/ASsAL9/J1pjrvUgqv15J3emd5B+V6eVY3RUmQL2jC43+IYYNhLatV3zBBufrA6MFgwd/4L9Ko+UgEXwv4ubJP+QJWvsrK6rTZ6HOs4UBw0fEs4N1RSTNmfgvmS5au5XmTcqsl11NbBc3SOXk+SNyQ2zJuKoHklSxpscmZjZRa+gwuvrIarJqho037Jms83cWib9xHmuK/bbQnRygEmx6kmb5cITHsCj8dVn0kCwJCeERdtwHNvnugKTI/0MRe8gc0wmu4ahHP32OCKpHypXuOPNDoLqTx5h8y9B5GAXzl2dGEt30sF5zUHDEKhxsRFpjXtZpZHhVHvrtpKAfYVwDhdsCsCnEx/ydphJtrv4oo3tpB0aCvxKRfi/f/CmbSHn+NkRtucaL/+bgDsVnrRjEkKc4IN6k2L0uSKfqDUtriG3CPYSg1Wxi9dHoERz+CWexp3EL6nFaH4Z0jzFv03g5XD6H5NlsDc/0eK4or2JfgnUPMEfuTlnhczM/IftmLieHtcUk+AgN8Sr+TDVJrXP
 kjbJSptN
 tykpksNk0BgFOiTzfQAT7NhE4TYRkYRDZ6iil+BNt4X6CzMnJN2+TnLG3NSTV2afOM96bORcGhtNlgJ39W2+fQ9elrSplE+Z16iXz9Sk4/51+O+WWZxXUvCbZ5lGrbqT5jNS1Ft2qGuGAA4DNSmA1vNYYDH+/C4AHSRqECZPwSCNW529qkjEKbmH5nt5V3LNYbD4GN/HxUcQtXtDB47qTz10ogS/GrAtO1oafkHw1FbJlFr+/LZCznLQzhS53axAtaJpixKsIiCoAOLDItFLR2E5LjHrxY0uGrkvSPdB20MgdQUIE0QJp7o12jXxW3kVWL8irXHvPtR1/c9XExUIPY3FUog/S6JaGBTOvyFFKguvknE+YGbDg/TQCtfIlhL4yqCLfoGZ6bV4Umzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 6:57 AM, Yeoreum Yun wrote:
> For consistency with psize(), rename read_pmd_pagesize() to
> pmd_psize(). There is no functional change.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>


