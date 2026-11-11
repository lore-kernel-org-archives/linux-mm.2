Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C88606A882
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=mZ9TpS6g;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=JlfQXKjk
Received: by kanga.kvack.org (Postfix)
	id B485E6B05CF; Wed, 11 Nov 2026 12:56:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA7E6B05D1; Wed, 11 Nov 2026 12:56:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924F16B05D2; Wed, 11 Nov 2026 12:56:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 617F36B05CF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0CA71C3A90
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:07 +0000 (UTC)
X-FDA: 85423591974.23.BBA2F1E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7A9071C0009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mZ9TpS6g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JlfQXKjk;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6AzRWOawdY/XLsSE0SxncPICTiSBCQ9PaSP9Cbrxo7I=;
	b=8qLt5mL26iIfgUWL4E/TheSdLgOQ2ML1pXiipdf5sr3LhvfPttRXpBhLmfqOme3jO+oDz9
	vslCcj4fPS4WfXRNdbkfmnJ0zPOtluXCJfusFjJlBuo/KrqKj/ediiJgz5fwT66lL2WZ4L
	McZkNSQr5SPQab36JCSAe6Q5Y9wT2uE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419765;
	b=UdznuVGjWOUaw6AxKHHPtldOglcQiKxjYuxn28v4RHURyN3iNlH5S+z0rGhGBes3lcGL7o
	wOgjo0lwFZM7rfhw+TvAlTqikViszTumSmp7OmGVYSgI6xiWgD6i58G19lnv0uXfBtS7Pv
	fs9RNqlFmcgpjKTUA5NvhPd/qB1y+ho=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mZ9TpS6g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=JlfQXKjk;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYFMb825541
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=6AzR
	WOawdY/XLsSE0SxncPICTiSBCQ9PaSP9Cbrxo7I=; b=mZ9TpS6gUjDIbQYCHJ6x
	wJP8tC5iyLAn99DRvrMSIGLa9e2Abh3dQfauq3CMKbiCjS/TuGgkzl8BNmrkaIZh
	RhpnHwtoODq8GKkVL2Yd5lsoAJa3NPfYsxNt6BpLW2i5ckWuIUK4jnLafvUR12/V
	M2znURM75XoxtxR+ZTLwEs1RnUmwNTatoKzRzze4FZSnuLISvZJCOh0eCYtIPJkW
	iJHv9Gb2/iEOGuu4excsj3SNPXa36ewwPD2EYRMXmXcFfnFk/GInj9+js2drqfjx
	UXY97LrLWcRNQ6Qx5mT9zekVGFtH/Dk1D27C/RuK8CDdunZJwrPsvRxPYgyZdAT4
	bQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvvaqrhhh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:04 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5364605e74bso89092291cf.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419764; x=1795024564; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6AzRWOawdY/XLsSE0SxncPICTiSBCQ9PaSP9Cbrxo7I=;
        b=JlfQXKjkXF3ntm9mbxFpgLiuTAC40Ue3OseGXs1qNOJzf9BZaE0eBTgOxkIIJz+XTo
         j+HazFajYPni6TD28cBh8WC8XgMQEJYuOSjxLpfaoK+RRmjHJD4GQmXAZZoz1DP8Zv5k
         WFMN2zZa4dRRMNUIB59ReN7z7rXuO/Th4YjeZ6d8n1py/2AilOIVSM59W/99R+pfC4Bs
         NmKcBFywh0SaVpb5PaaI40O6dc7mcQRuryzGVxfa8B4qFky+88YUgGGA+K5NYNAnRzhi
         vhXUVjL1tdbi0cX2Y6wgORF3/lBNsxwO+Nz8GxKfGSIKj1GXixKj92iH79sluo33Z7Ko
         nIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419764; x=1795024564;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6AzRWOawdY/XLsSE0SxncPICTiSBCQ9PaSP9Cbrxo7I=;
        b=qe5OkMv+viHMyfVkckLfjD4mEr1MvD5lfipKHzbLtRGcEeQjvOlbm2X/C8y9CBycfC
         ASIibTCdaFLcbkwxnl+vefq4oAaSBaqjLI8lmEfycg73ctCDNT1aFUcgZiXAn3E/jAcf
         YC/eILH4rolR3uW39BpB87k/C7vMUa9LZ1vCyRBzaPzhYqwSN5AdjLudGWWUo0s9b+nc
         tLh3rHCNE9o6HZ6V30q0xAu6I/TSpsNrCbA4AUqvyCuAct1gvchBZP4i7AmHHqggIx8G
         hquLsUdu3M84AhiK7jMetfksew3PKgdoo+vqFWhMcePtm15RATfvGS6XLAaSuJoVcoUC
         qDGg==
X-Gm-Message-State: APuU4Z8avNipVZC9yB+tMsUi3sK7f9LG6gWxXgaeM2GIRy/NRLFh2ytx
	jpLIzmF42BagCvX3RnutsYnhU4ri/qS0o3G4JK0tgtM4EcGaUY4KdeU3lx4f4OYxobjXJP9C7Zu
	k2za9ZhiFkbdwfQmdDx7tePxNVZd7mmpjgXVovfA2RrhOikMm
X-Gm-Gg: AYBFou2Ec7L2C2CMGfXncgrqmH5mryrlg9rOaIUP38RGFVEyWoMBkrOegpP4F7ylYPN
	oF8B6/OBOpN+xvqlbG0dgdsjDKlv15yWE/pKluCKkdue/4m6TOOBEJWKaS7uojSX3Sf4snB1mzw
	ZzXr7bWsCv6U9ITb/p5S0RFDCi2C0ruLDCLyKKcufm5BNdnKpGjcBTgScAsoFPolnaCtX5+A7za
	eZc4seJfQRbYbAi98WCUBfZr8W9inbh0I4bSO1ZsBNTlnf7LYYaqBcJKMrPIrsrI+RG9Up3ytd8
	wlJ4eEueP7OPwBKHUwiHvzblMsmTO+PONpmMGbUmKLqIc5wlmHd1+J108YwKZZZVr+lPo3u2aIL
	K0pAWkvK2Lut56TOI0hnIiMwwTtB8Q85czQPYgWrFXDGZS2nlSRGhGXtBZoJBRBLPul1+dAI3n2
	MtXIueKT2kDUJMD0Qaww==
X-Received: by 2002:a05:622a:4c0b:b0:535:28bf:556a with SMTP id d75a77b69052e-556c0cbc608mr46373021cf.37.1794419763588;
        Wed, 11 Nov 2026 09:56:03 -0800 (PST)
X-Received: by 2002:a05:622a:4c0b:b0:535:28bf:556a with SMTP id d75a77b69052e-556c0cbc608mr46372341cf.37.1794419762971;
        Wed, 11 Nov 2026 09:56:02 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:02 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:15 -0500
Subject: [PATCH 07/12] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
In-Reply-To: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=9517;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Z3HcYciE/Tpm+iRergRe0sb0AcvrNns+MIo/9+inaMs=;
 b=cOb/U2nEhAPxpm+v1OHS9aAxpELHnPNk3VbTh68lRUDhTNV1JAziyMSKOd0O7bdJx5n7IvbZb
 ngljTmRptHrDjYwAfHcm4/DsgA9qTM18A/se1FF5D8AsJoUCtCbFO9O
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: H5sdzMnLy0FDNRiOmfxrtdvKOYmE4Jpv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXzMP4MkTxEFXK
 wJlACdsfFEBmgfpELnjJsqpc6XOLC/hbouFzhISoLXmj4yZLoyeabt5XNSosXOu6etTloew99pY
 CYE6q0+6U6R/+jAOSCq3PcssrTljljqAoWPh0ef1+J6nNLHP4p3K
X-Proofpoint-ORIG-GUID: H5sdzMnLy0FDNRiOmfxrtdvKOYmE4Jpv
X-Authority-Analysis: v=2.4 cv=dqFOmFg4 c=1 sm=1 tr=0 ts=6af4ac34 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=geY7Is6-Ug028d5rLKYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXyMCSH8EyM1GN
 I/tiHt8etptyESDU5TCgxQtvmfqDskMGWT1WidkGNwJd4RPTdygYZisuVvMREaikUmGzZ13sU5a
 QYDwDV5CycV7rhCJ4r95DOENwXoMax0la6GvT06ONebHtNUx3VYoNVRKOqk21M7nhHF+2darVpZ
 53UISoTY39+v+QoIiC6Yx4c0U4qrSYt4f65zUZD8p+WS54zkE9D21WXPH5kJYfQrtos6UMhvYhD
 8FysSIe4k6xqk1Xoj1VkF3sUVpOWtDGXv+mgyYpnN2omgaFXby9yw/Jz3TlzH0351ODmNgyv1cI
 so/3LH3hyE6J/hRuJiJUi1XI8lHGBD92/MXV8qRhEjKum26QRw2ToUGqyGoHJBWwNQCWgEh1EVv
 dNI7lGTnHKW7AReQ1xhdbPoiaIUj9mcjPeT2IpGWk6z5b+/oJHtmAyRyuw1g9VPSiuM0GAPn21m
 osFm/J8ohO59KK+tl/Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=10
 clxscore=1015 lowpriorityscore=10 impostorscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7m6mq9gb76d6jh1jg586dfw8fdo985gz
X-Rspamd-Queue-Id: 7A9071C0009
X-Rspam-User: 
X-HE-Tag: 1794419765-646747
X-HE-Meta: U2FsdGVkX1/qvNjjk7R87YdFTMBs/SAWTZ4FKDoj9VQOkCd+YLQEdogpU7UCEKJwJ7ZFIdB5TdmC+lnU1VmbMclShjdjlLhLJdUxzwTwy0fhjTF2BzZF0oxK5IwM3f5d6JMdkagFznTNHNcnbj4yULjSCBKLhHMSX3u/3R0dIMQq1AL6X5JpBTSZv6gCXxPQYLy/KEQNBVia8bz1lgx0xKubi0MW5hR+Hz8OgH1/9MJQfOT5nIKMv/rpQ6qShiXW5s6wQmN8vogcADnoZbO7QgeAfUMOu/T1UH4mJVtSnTJH5lTQM6lhE2gAD+z4hgwUfYAfqxlrwrBpyJrrE2JnBd+pb78KUQlSvIJaVGiqAybOGoBvDptvQpl5U/HKn+3X9TRcceqJNbxsTPntob/EHRf07vp2tAGte8RHRIc7PSkA9tF3h3g7aoHaGxlZvsLfDdCDKw2AsqQ2bvhOV8DO3hBPrslDEZIWxDWHDlv+6ZH0kRrYZydrON03+qSE2TRivFO4qCL+si4U/5RedvoS0W1w2KjFHdCBtlf+dLJ5z//aRQ+oveK8SHUw44UC9MIiH9DrV1mZePf+2ii5R4s9MdEliRbAwThm5Yp1x5YFhlEhQDNP36gksyjSbqQVKOEbj2sc8SfKZhi+m/s/RXrB1ZzaGlwq/r5nQgumd8ggBwcrghNtA9B1IXHZ5Z8HHTGZEu2viXWtJ4w9lr4+UCkCzqnP9tzDUfKO4uYe0Y8smohDPok6M1t9axA/I/qnexYgovy3hpBpVEYvsS1ClIQKG/xa8uqZmfqybCMpt5IK9VLe4C5jyTT3snLfJVA4wW9S3ZOKIZZdyUCIKLgzfR3+6rj1Z7wn9IVde3njkBgdJhhxJl6mG0DoWeJvWgSEgME4HO+dClGb+WypAKLD3po97bjR/56KUFz55H05Vh8ikU68uLzDm7mquZBkJpAYS1rI4cL12YRn4TTxm6+yfby
 UQ0SsYAL
 gb0Hpd63Xpsglv60mwdt+D6CiWxIndqcGtXIiU7IyYLDpj2x6u/UhCbAfKZpLxfvXpX7XJdWcpmVwTQnPZoEFUEvgfL9/hz63A+Jb1kbCoZmrYlpLX8/HiBPIn3CaVg72rULkmDShGGVmE5aCIcx4A6J8DcWupfqjTWt+RjnGLmGYSuXBBxClJRDkWaTRFHwkV6aO2b02rQJFQiaT3N69ffGNGtAI0uVJg/qFrxGWzWT1wkTYlVEfv/JfRqhYBKMLMS0TBfVk7lKrSYS0g1wN3VQ5HkXHK2HTc9RI/SqPmIxQdX+IHaAUkwQKA3Ec3aMbTmO8VpN1ZuEboJpKg4YeyNETYg/OCvKBz1tnPeF2nnf0J0VVQvRyA3RAqioChaEzdBQUe5jNEwsMO0gGpWw9CnpVoWBD4OXvcIOCiljwhvxh8DSY3eD14qucs+WePKpMC0ulZ0qE0crsBjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
registered with userfaultfd: mremap_userfaultfd_prep() drops the context
from it once the move succeeded. The uffd-wp bits, uffd-wp markers, and
RWP PAGE_NONE entries in the new VMA must be cleared as well.

However, move_ptes(), move_huge_pmd(), and move_huge_pte() clear them
from each entry while moving it, before we know whether the move will
succeed. If a page table allocation fails halfway through, mremap()
moves the entries back into the old VMA, which is still registered,
without their uffd state.

Writes to a WP range are then no longer reported, and an RWP range
becomes accessible without a fault. Nothing restores the protection
afterwards. This requires a page table allocation to fail in the middle
of mremap(), so it is rare.

The uffd state must only be cleared once the move can no longer fail. To
fix it, leave the entries alone during the move and clear the uffd state
of the new VMA in mremap_userfaultfd_prep(), right before dropping the
context, using userfaultfd_clear_ptes() like unregistering does. A
failed move then puts the entries back as they were.

This adds a second walk over the page tables of the new VMA, for VMAs
registered for WP or RWP without UFFD_FEATURE_EVENT_REMAP.

Like unregistering, userfaultfd_clear_ptes() also asks for the PTEs to
be made writable again where that is safe (MM_CP_TRY_CHANGE_WRITABLE).
The old code only cleared the uffd bit and left the PTE read-only. For
private anonymous memory this saves the minor fault on the first write
to each page that was protected.

However, this adds spurious minor faults on shmem and hugetlb. When
resolving, change_protection() rewrites every present entry in the range
with vma->vm_page_prot, so a page that was writable and not protected is
made read-only, and its first write after mremap() faults.
UFFDIO_UNREGISTER and UFFDIO_WRITEPROTECT already behave this way and
lead to the same spurious faults. This needs to be fixed in
change_protection() and will be done in a separate change.

The entries no longer need per-entry handling during the move, so drop
uffd_supports_page_table_move(). Where the old and new addresses are
suitably aligned, move_normal_pmd() and move_normal_pud() can move whole
page tables of these VMAs again.

clear_uffd_wp_pmd() has no users left, so remove it.

Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 25 -------------------------
 mm/hugetlb.c     | 27 +--------------------------
 mm/mremap.c      | 46 +---------------------------------------------
 mm/userfaultfd.c |  1 +
 4 files changed, 3 insertions(+), 96 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 09176b290f76..468a49041b95 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2616,18 +2616,6 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 	return pmd;
 }
 
-static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
-{
-	if (pmd_none(pmd))
-		return pmd;
-	if (pmd_present(pmd))
-		pmd = pmd_clear_uffd(pmd);
-	else
-		pmd = pmd_swp_clear_uffd(pmd);
-
-	return pmd;
-}
-
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -2663,19 +2651,6 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma)) {
-			/*
-			 * See __copy_present_ptes(): normalise the RWP marker
-			 * so the destination starts accessible instead of
-			 * taking a numa-hinting fault on first access. Only the
-			 * marker (protnone + uffd) needs it; leave other present
-			 * PMDs in the VMA untouched.
-			 */
-			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
-			    pmd_uffd(pmd))
-				pmd = pmd_modify(pmd, vma->vm_page_prot);
-			pmd = clear_uffd_wp_pmd(pmd);
-		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb2de24affdc..97bd29925476 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5168,7 +5168,6 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5179,31 +5178,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	double_pt_lock(dst_ptl, src_ptl);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
-
-	if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte)) {
-		huge_pte_clear(mm, new_addr, dst_pte, sz);
-	} else {
-		if (need_clear_uffd_wp) {
-			if (pte_present(pte)) {
-				/*
-				 * See __copy_present_ptes(): normalise the RWP
-				 * marker so the destination starts accessible
-				 * instead of taking a numa-hinting fault on
-				 * first access. Only the marker (protnone + uffd)
-				 * needs it; leave other present PTEs untouched.
-				 */
-				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
-					pte = huge_pte_modify(pte, vma->vm_page_prot);
-					pte = arch_make_huge_pte(pte, huge_page_shift(h),
-								 vma->vm_flags);
-				}
-				pte = huge_pte_clear_uffd(pte);
-			} else {
-				pte = pte_swp_clear_uffd(pte);
-			}
-		}
-		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
-	}
+	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 
 	double_pt_unlock(dst_ptl, src_ptl);
 }
diff --git a/mm/mremap.c b/mm/mremap.c
index fff0465f5e06..4564416a6994 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -198,7 +198,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	struct vm_area_struct *vma = pmc->old;
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_ptep, *new_ptep;
 	pte_t old_pte, pte;
@@ -290,27 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
-
-		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
-			pte_clear(mm, new_addr, new_ptep);
-		else {
-			if (need_clear_uffd_wp) {
-				if (pte_present(pte)) {
-					/*
-					 * See __copy_present_ptes(): normalise
-					 * RWP PTEs so the destination starts
-					 * accessible instead of taking a
-					 * numa-hinting fault on first access.
-					 */
-					if (userfaultfd_rwp(vma) && pte_uffd(pte))
-						pte = pte_modify(pte, vma->vm_page_prot);
-					pte = pte_clear_uffd(pte);
-				} else {
-					pte = pte_swp_clear_uffd(pte);
-				}
-			}
-			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
-		}
+		set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 	}
 
 	lazy_mmu_mode_disable();
@@ -334,25 +313,6 @@ static inline bool arch_supports_page_table_move(void)
 }
 #endif
 
-static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
-{
-	/*
-	 * If we are moving a VMA that has uffd-wp registered but with
-	 * remap events disabled (new VMA will not be registered with uffd), we
-	 * need to ensure that the uffd-wp state is cleared from all pgtables.
-	 * This means recursing into lower page tables in move_page_tables().
-	 *
-	 * We might get called with VMAs reversed when recovering from a
-	 * failed page table move. In that case, the
-	 * "old"-but-actually-"originally new" VMA during recovery will not have
-	 * a uffd context. Recursing into lower page tables during the original
-	 * move but not during the recovery move will cause trouble, because we
-	 * run into already-existing page tables. So check both VMAs.
-	 */
-	return !vma_has_uffd_without_event_remap(pmc->old) &&
-	       !vma_has_uffd_without_event_remap(pmc->new);
-}
-
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct pagetable_move_control *pmc,
 			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -365,8 +325,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -434,8 +392,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ad9d243dc64b..bf42fabb5afd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 		up_write(&ctx->map_changing_lock);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
+		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 		userfaultfd_reset_ctx(vma);
 	}
 }

-- 
2.39.5


