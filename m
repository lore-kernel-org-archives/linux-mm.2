Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1C6606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfQS3DUV
Received: by kanga.kvack.org (Postfix)
	id D04AE6B05B1; Tue, 17 Nov 2026 04:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB59B6B05B3; Tue, 17 Nov 2026 04:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D5C6B05B8; Tue, 17 Nov 2026 04:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 988646B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:12:44 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC0BE1C3AA9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:12:42 +0000 (UTC)
X-FDA: 85444045764.18.21F5A16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 025891C000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:12:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfQS3DUV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794906761;
	b=67Otjz75HzrORTSl4Ko6ndz0Dw5i24/EqRMzL/058c3kSxat9eQE8//vXhEKFUAZgBldEE
	wpCPNgIcERfzrXHfCVQWXEJVUXsNPM7PfPuJz3XBXsxVJEISfaCrePn/xK+JTjzZimOROK
	H4OUe92oJdUg1WWy35TYkMJy6+aRohQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794906761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zN96UsNGo+27/gzghlnRa+Y2nGKlxtKLVFBbnRWnKA=;
	b=p5DD1b7iGGhjtsdJLHsMAgoDLbradGfl78KBvIT4ujkRRITWxkItyqYTRyUslbLozTEeX1
	oRCqv4BtmchkY1kFXL5S7R4IotxRmaPNVx4cS+6m9xk27+GrXHAuoSjHDJEjFm2E69sZZD
	NuPYENEXSXwswnD9uJKgBe4Pz2K5ZTg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cfQS3DUV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A14C632EE;
	Tue, 17 Nov 2026 09:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCFA1F000C5;
	Tue, 17 Nov 2026 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794906760;
	bh=2zN96UsNGo+27/gzghlnRa+Y2nGKlxtKLVFBbnRWnKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cfQS3DUVghvcnGDxvbeil78VNN/casUxaVraHxuyK4zfb0Hg9JHdC+Zq3AokTKMch
	 QM3kfdzE4hVrBFfPQ2M4gw770ZkYhby8bPAy/H7i1yaZqdPPyE0ltlEJ+PFO7nXWuY
	 05lyL2rshYLz9rKWO+rQkTOYE8gV6YFVPMs0pk7XWn0kdtllubcXRA7PB43fLfTytK
	 8XCvUB3YDosWN3AThXC6RF9sfH9q+uF9JvYhzsCpLl08wYViUMIrjD2DMYJfLR89KD
	 Z55+fqRYgXW0qD3jiHxLtQF9E8lctO4HhleXHQNmrojR05MvOK+Id3xkoNITi6g36C
	 wWoLBMJukiNOQ==
Message-ID: <ce017546-8e86-464d-9472-0905219e0360@kernel.org>
Date: Tue, 17 Nov 2026 10:12:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/15] mm/hugetlb: various fixes
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
 luojiajun <luojiajun3@huawei.com>, Josef Bacik <josef@toxicpanda.com>,
 stable@kernel.org, Ackerley Tng <ackerleytng@google.com>,
 "Gregory Price (Meta)" <gourry@gourry.net>, Chris Mason <mason@kernel.org>,
 Daehyeon Ko <4ncienth@gmail.com>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 025891C000D
X-Rspam-User:
X-Stat-Signature: r87huiiscgddjxak5mafc4hbrc8fneye
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794906760-198018
X-HE-Meta: U2FsdGVkX1+FM7vY6bW8sbXIsqXYmaDZMY6xRKXkRLxcgIggaBKcNpA0nY4UxnGI9Bc8vANn1+164QynHSeq/1s3iglff6qNHXGsIzhrRmFnyFHTaZjpqg3R4VUlbWHxPVdyKEWzknyD40/Ty2nKUOeheevvDuFRadhVvctoBUoES8xuDNzPaTbBUnECGI10y40MJZeaGec6ct5f/Ou8YqX3fs2rvX0iq+AxcGWxWQ2dz3XnvaTNhfn/BNp4JqoMD9gptAY+bTE2han9XRRjvHtm98WmT6bA9QISsQUKLVuhjTvpNKeqqvoym9hFwI5Glk/r1CcrfS8WjaHBRSmish9SrEJqn1RPq9NQ8qHpLyOOgp1QxtnGPj5pGFn8EC8C4MZP+LjKKIvASjM+sBdHXtqqlaBCeqsBv73TH7+OELsV0d1ZinjSsHuEwpjVotzG6FVIdmbtYYZYfVebj2ZrY+KI18/kyLqwxInhaMdacmsiqP7vgT9TN5k3xDCmCsFU5lKrekC9Lkm0lzSfMNx0H5+QJbh7Ann5UDN1oe4sheLcMRon5Lw3oRMm3WAj+06F8GnuUpJzQlYwwrwLCLujjpP98n1xWs2CI+BhbzvtNk09vnfRNRYvPt8vzWUNhblf+KFayFghqBV2kKk1DF8TDcASP6Z8nHriDLolqDbZNo4wUJu6o9YKLip1gbPCx80zYNVqBVqnm7Et2XI5MuVKXvsSLGPqYtcfbWMnsroMJ52z4D6pX/PE7OcRlPO9+WshzPLj5V3QTgVVmCRQQo5lnm2tNlS0jE5xW1ARgDlMrRNqX+lbt+lN+yMBsUYlX4n99QSfS7pHeB68xKXQ0lT3t5giFLRU5PUFVfhObrT+DfxS6w8mbthOShLfl/6YGRrt3cE0Vz8+8+uhVmw2Cu27knI/S3VY8fFuFHZWHtS98V4o88S7lKp+59reuO262GpoQY/Bs4sDcTN48c770rt
 fCqzi1Pq
 nydA7r5/ZzCtOmjfmTZo4+kRSLPwq7gCaP0EInKaVO6eHoJly+ecY9E68JNiKsOqOHbohfx+ZEvyx2Xnwestd96bp4RUYrO78JC/nVSdYMMv3/BtHEqSHDgZDaQEX4C4T4IqabCIRAJ8XekHX54gHiBUUJmxWfsx5Ha28+hfuGtCHgUAjKfVbse4Qde2wAuwWKBvjvot5/Q6u5L3M7rQdarcxBpG+NPh7DuGsR2sfNk1pOXt+Wo56sAhNDtWCyDGQSJV/cHtiXUWKyQJQ6eFOSLj1Qndi+VgDP6bc20S6+L3JMxsPOByM13Unfpx7n+APAdAiS8KL24CFvPvFG3gsYLAXJOkN3V+0Zm1erl2ObiKM8F575E6R8ojB+xki/Li8UGZ31pr7qOpYhV+afs8ny8P0+sUouUiFCKlSx4p55tdfpDQwKeDSovi9GtKtXJjA/MclqQJpEuB1tl1oL6D2WCaC3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 19:29, David Hildenbrand (Arm) wrote:
> Hi,
> 
> v2 of the hugetlb fixes. There will be more at some point ... let's
> drag these over the finishing line.
> 

As Andrew reports, I accidentally used the wrong CC: stable address. I
assume this can get fixed up when applying -- unless I have to resend ;)
-- 
Cheers,

David

