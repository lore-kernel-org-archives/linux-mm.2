Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950F2606A8AE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=iYLVIb4e;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=w8+LwLWl
Received: by kanga.kvack.org (Postfix)
	id 9F72A6B05B3; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4016B05B6; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FF76B05B7; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F40B6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCD22A79A7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:51 +0000 (UTC)
X-FDA: 85442519022.25.8E8F61D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5D398140009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iYLVIb4e;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=w8+LwLWl;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shtRRPv4sO05cfKy9jDsVgauLpUzE/l0Te4xSbg74SE=;
	b=ZKjhamIquxBu91+Ugo3QyicTRpr4BkOBc+hKbvG+fXH5FA9jGKVp6fO2h+suYBqzrycgZB
	s03XcGVWFyu4kshFnXIucFb8rHE+YErEL52hRhLst8rVjLDwD4USe4rn/I9ksWmXRTYeVX
	ajobUwnr6WD5QuJ6uLPMtKC417RbV+w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=iYLVIb4e;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=w8+LwLWl;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870409;
	b=qcbNJmmTMAuHj2x86TjD1UFGMCJ8VGEw3N/YpYxvPJ2ZdAPnDecC+JzP/E78RNhg3fTx94
	QXRIxYnvgkBJZ2IhO5pKqgCGCV5ZdStF0/BnYipVGDv6LN2hUhrKXIy/+ngMND3wu5LH7Q
	3fYBTtGSmc1RjcnhXdQThYuQz/CiGEo=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLYlbd3519921
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=shtR
	RPv4sO05cfKy9jDsVgauLpUzE/l0Te4xSbg74SE=; b=iYLVIb4eyo24+udnvs3G
	MJgMkShakHkhAOAO9CCgFnM6i8wa3coBagtc8oRa+Lz6Z+MsbX20IDG3LJDy0vFX
	Z0Yjgn48CeEZWOfHZUatppMpD+9lfvTeu1uj/3fqHOBdXDNgGL9YK9AfIpsuUf6b
	JdLsR/VkazINFOI0UV6cZ08cE5if7g0pIqYZr6Tij0qLt8/TfT5VCHu0/nirog4e
	J04gsFT5b3xlACp4HxuRzGUOdy0q0fmWzSUnd1tqycWphXxfpPmPT2mfDAxLoHOg
	MM4XfQsJlIgAnl7FQPviBjf51Fu25cAE/NqerET3PQEQk5MvIcw/7mao9MSb59qZ
	Lw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059ybkqs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:48 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91ec6cd898eso84915056d6.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794870407; x=1795475207; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=shtRRPv4sO05cfKy9jDsVgauLpUzE/l0Te4xSbg74SE=;
        b=w8+LwLWlR6uKMFpg/SZb8CWNBoUXZHL2OojAY3YvudtyrfiZYPQaxUxSKVgvAE7ESo
         SU+338Np5KJ8tHxDMaRMhaxXKZAYFUe+fSjk6FPyG1Ni0leewzITw8LOthEAnihTi9hi
         gfiW0v8D73RuCkDlajN4Utu0DDR9cw/xUwBnCfSI7kgDuYraL/fOpDyqXOchh6Xg8iM1
         9+dGJg8BDQW2oQkvwFuWFdzbU+rjZT//CjU2yOGhNPPyFmeZMMpkSURe8mxqNp0YMkG3
         PI/nCWGJWpoD4ZCfRO1dmXQl4mPUzMMkepSF9gJllto68mKYlhgb0qGumSoS0uvzHMbi
         g3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870407; x=1795475207;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=shtRRPv4sO05cfKy9jDsVgauLpUzE/l0Te4xSbg74SE=;
        b=aWDZUkiWw7iH30oprMclekZmU64LyBlAgkttreiLjYbxN5qXqebpJwXaOwOhYoqDO7
         AQ97mfru3IpWYC7HF8D0jCnbdQ7M/n1zCLjk215FekAoVRzXTXDfTo8tTPjohtjxFfWy
         xhkhQVMD8P7qxRItDVf/LQ9aInZmXd+rrXrHVHMDH8TSls15i8gT7FYjKVRbkfTtobaR
         E3GBG1hO8xCfdxUi4UvPY0uS1ju7LIkCyyt8UFsGrDUSfRDflIOZkTY46AjW93tYA3CZ
         n/eV9q4LAEKfiUlvGo016P4yItksaPT657XeFL1iSSqeu7vXJiC+mMM+IrbxZJtjULWg
         sE9A==
X-Gm-Message-State: APuU4Z9q+MnbhyYSvDHL+W/uB7Y/Y3z6Sxvkemp6ild/tfrh5r7CF7cu
	INHNikf5kkC3xkfMAhIqMvrLqjMtFfCZjbcc9Kh3AKVKNg5czjmy3fiaPp4G2Elax3kHjeRFBuO
	InLP2Gj3lpi4gkuIdAjDot8MKVL8OSodF5ysTRNSaY2h1uxOp
X-Gm-Gg: AZFdTZcVFWVBqq8TGZhHueig0eu6TuExEtwhc1Sre87NyXjsLiTYzI0jfCrfkUb4pR1
	kxPoKpzunP1ZCcux3vfSfOStdTz44smvi0PG7DmenM/0k1tbCaeTgUmg/6R22gsQTdoM36j0yTW
	k3qKoLsalUO10c0zisEwpyvjIYD6efIAojG7HAbt+RGVYOUWfwAfsbOO2p/ODb4RBumKVc98+iH
	CygG3+ZnWVprzmnYJW/Qn0U3x+z725WXmiF4t015sS2RpNDhsw4ejPeCYcmct2xEH6EGW8ez8K4
	1PL1aPiAUc4hDHyXhwaLBlT0tGz1KXFIbZJXAhSAktXQvRb+hOt+NzWLE9i1XhDaKAN9tEHwQP4
	VibwuR3pDvjkRXUmoavlhtjPSjMycYJnpnS1Q5iLkNprduabc0iCM28lavYJfPg5t4HnLvKblMY
	rnJTheiKsCnyd1V1x2lA+EcfIj
X-Received: by 2002:a05:6214:486:b0:91e:cb85:f84c with SMTP id 6a1803df08f44-91f241ce6admr203454606d6.27.1794870407350;
        Mon, 16 Nov 2026 15:06:47 -0800 (PST)
X-Received: by 2002:a05:6214:486:b0:91e:cb85:f84c with SMTP id 6a1803df08f44-91f241ce6admr203453936d6.27.1794870406649;
        Mon, 16 Nov 2026 15:06:46 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d459c6sm97731756d6.14.2026.11.16.15.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:46 -0800 (PST)
Message-ID: <71aa028f-c753-40d5-a8e4-8daef5aea3aa@columbia.edu>
Date: Mon, 16 Nov 2026 18:06:44 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm/migrate_device: do not migrate a uffd-protected
 zero page
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-8-4397a0196479@columbia.edu>
 <a384d75c-2134-407a-924f-ee511f65a2d1@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <a384d75c-2134-407a-924f-ee511f65a2d1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MiBTYWx0ZWRfX43/Z6SQXkSG6
 jnJH38glNbtQOJaVVHDaFqlvrSazXiNX0kHMJ7zxvRPzVMtD7iZbfRJfcEphTWP+3Ip3uObUFiy
 hXqqizhj3nh+J5Z5yNoa+y7hk4N1tuwgdf8sWlQeGtta+KTjzgGLn1Ex9X4wrrchrFsZR0+Wb16
 qbdsl0bmybXDWgzTjtl4e8rfYlEJf5wLZrWzTmelRrwG8qGX7mNKe7PxEN5j2lwAyfJAs7R937x
 YQNZCFQ+roiQ1uuAL7m4Y9q9iPxqXMXFvzh4unWK7HG1FTrZeVpqs0TLiRQeKRdJ+EuAhzG2vNu
 ZEY9e+te41mUkZqeYhe4LQ2l1w0Aejn+0q2S743lRHjlWUDJ14utkKiyBuEY/Ol8eG4JlNVYQ0h
 8Xn0gU28dya1alMYNRKTtpJT5rEprpLcg/EfrZ22Q4JPXSJYRkslrm0Z1Cnlo4MrJ8sAtaGdcnF
 jQVA5/q5ATu2LFhlNpA==
X-Proofpoint-ORIG-GUID: Nh9tu0g197knjKKqXIcAGGQiB78ifbhO
X-Authority-Analysis: v=2.4 cv=MOv1C8Zl c=1 sm=1 tr=0 ts=6afb8c88 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8
 a=9jRdOu3wAAAA:8 a=e5mUnYsNAAAA:8 a=Ikd4Dj_1AAAA:8 a=zEWuSTdDNGilpxNPLJEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22
 a=ZE6KLimJVUuLrTuGpvhn:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-GUID: Nh9tu0g197knjKKqXIcAGGQiB78ifbhO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MiBTYWx0ZWRfXy6+oamYgH7HL
 uYNhAegVmSXlDt9JzzuzkD8rvcAqZr2q72kXLILtj96qvZ9pyksbVHLa6/Qc5TlL+mQe+xhQ1yA
 qkhQDqZ9Nsixp74GX/NJQOyVeek6WQS6IJ/5a3rDS5LF/X9N2Avb
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=10
 bulkscore=10 adultscore=0 impostorscore=10 clxscore=1015 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160092
X-Stat-Signature: mr13pjyfr8smgctnfsuetgqqpc1nwhxg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D398140009
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794870409-605485
X-HE-Meta: U2FsdGVkX18nmdrOGa978SNbmOpyFqo3VZTMIJCr8J3O1h+20HR/1Lvy2SMc+8bW7lChIMEgwO8H/yC/y+2+BfWjE0c5eYX9yTPTXMijzwVKbb0qM+LjA+L5V3UlUGGSC+kKYjGoR6k0kDfu1vn3OK9CLTNaLU7vo8jZ/hCEkSgaCKLf9MXg7Jd+Z1R3ElADj4d7nf1EdG4a/nuXfCvrq9nm3WlMPk1SDvTv+JqJT2qjBo6zboH4nwkzZ/sofO8FCcyUpK6x22L5U9XvkRwCYFlhz1Qjzb5qAqXPMy88tkk3w2UdbvAFJMIboN0ywBDIL/I9WXDStmQ/yb87PRPZ89jaCk+b+QnvXGOfTzi/62G3WKOkcXNtYh5TU09WxhuC+jO6046slcg2R62WVM6IXu8Eo1Swl/J2v3UQqfStcHEU990NW8Xpbb/idUBWqlDoSUrGCyCxz6XjpDowDnoMfzJD5iARsrJuG4RKmsYQtiWlGUjzTGkdIRbP7diR3N7d6dlcWbo38j0D+bYrGoIMWxUcLSl5kQ+lZbTHVTSqbQIgz5nPUhSpxy9Vw+vYw2Y+StCLs/eybvazT1i1WGb7FjukAXpeIHj8/9+XLWx+9tCS6mWEjSvowz0bzNSGlyWSAfMlb8RhjJ7MjhmmyMhbmWIZZrwVp33J1W5IE8BnEe2M2q21t72SpPMF/g3aC4AmD4THG1OqK4yRMY3cx3kuZ9aCbLhNvkEkFa55BkpGDOV/GCcoyPMBYGuv5jdzxe0SoxTijQuun8oKebL61dx4pPht4MWkms1RemosZ3o9ZM+An4IyyVs3K+IKbfz2S4j97FMD7yCwjoGdQh9U53IdsR1NVFdg2LsksGKsYHdeclNw7DnE3xE6e4tz3zAB8olxfqgDES1IjdHm+xcNhT7Wf6z0zDwEVwj0d5RPb6MbE9mmCLqUYebOVscJKyDAfDe8ABhpuguvg4lKaMeZJSt
 RuHMiu62
 /PjZ4dRmcP+7Ffb/XdQdqskgspEzIp8+QCcjVgKBNq6+cYlX4/E6yNoIAttnRRLlg1Qz5BANUUNNSTOToU5oV2L7bhPtY7goddtjrsN5qu71XYx8CSUAEhPcn88paborfQAF9r0y+USgF+vDaW5MBFqAAe9nbBJhceYDTri0N9zaEHIopKY+ORwHlsgCD+C6jQp/BOyZgRvE2TlvDWIW9mcvlbUu2yGUGyeIdQDq0X3F7/JMOmkoQA+cQvawMf7HDo8L4Ws5LcElULRbMQP2/s076UDIkXdKcq3vRtA/VMaFuab8gwIZNkL5IsTqRyJ73yq7q4FmVthZ7Wa84rvA1y2gULDvO269Ofr91i6V/Kea2grmym+8qzBK7JNW3Ih2zXL4ZP+CVZ4SEjDekqjMZAPDXsEbRhr2uraNbF1rSA7Wv9U1fWOB020Cx24AN/JEFGhP5Dhl3jfmHIYaC1ZhC4w8+G7yd/5Np9P2K5aqXDUp66ZYXNDes6NgD3K6I1gc9+gYQuIofiJVggnmcIJgvFZRd+Y8PzJRizyF0lZOMEw6LyE2Ztn+uFGLifSMbLRotJCpdMcpUJn1uwUni5te9QFYjTatZN8Cdrt04kqE2j/MUOZaQ6rgTD0m7sYfy57VNL0HwdeUvOlyU1pjWvQuucasrhYs7sTXcHF/8sR9aeP31kHh3VH3B8zfGoP9JCp292sJoy/FQopCC6gYxC77mmN/kb4iF9rOuomBmPp23jBzkT5+HUx03F9/7mDhRKYu9XyBpzFz2xkAU7iSCoNPhLD9UoEaHmT/hjbRX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:45 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> Device migration replaces a PTE that maps the zero page with a new PTE
>> that is built only from the VMA flags, so its userfaultfd WP or RWP
>> protection is lost. The same applies to the huge zero PMD. Writes and
>> accesses to the page are then no longer reported to userfaultfd.
>> 
>> To fix it, do not migrate a uffd-protected zero page. Skip it during
>> collection, and check again under the page table lock before inserting,
>> as another thread can protect the page after it was collected.
>> 
>> The alternative would be to carry the uffd state over to the new entry,
>> but a uffd-protected zero page in a range that a driver migrates should
>> be rare.
>> 
>> Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
>> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
>> Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: Felix Kuehling <Felix.Kuehling@amd.com>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Cc: dri-devel@lists.freedesktop.org
>> Cc: intel-xe@lists.freedesktop.org
>> Cc: nouveau@lists.freedesktop.org
>> Cc: amd-gfx@lists.freedesktop.org
>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  mm/migrate_device.c | 23 +++++++++++++++++++++--
>>  1 file changed, 21 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 9e19fadfa65c..140b99f72508 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -159,7 +159,16 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>>  
>>  		folio = pmd_folio(*pmdp);
>>  		if (is_huge_zero_folio(folio)) {
>> +			/*
>> +			 * Nothing carries the uffd state of the zero page
>> +			 * over, so skip it if its uffd bit is set.
>> +			 */
>> +			bool protected = userfaultfd_protected(walk->vma) &&
>> +					 pmd_uffd(*pmdp);
> 
> Now that I read it 3 times in a row below, these needs a helper.
> 
> userfaultfd_pte_protected() ? userfaultfd_pte?
> 
> That might help you to get rid of the local variable (that should have been
> called something that includes uffd and should have been const)
> 
> 
> Maybe just add a simple helper for the pmd as well and use it below.
> 

Will do. I'll do userfaultfd_pte_protected() and userfaultfd_huge_pmd_protected()
to match the existing wp and rwp helpers.

Re: the local variable, I'll rid of it and just call spin_unlock() in
both branches, which is a little ugly.

> 
> -- 
> Cheers,
> 
> David
> 


