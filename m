Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AC2660A2620
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=VmPp7q7i;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=kM+1cSBa
Received: by kanga.kvack.org (Postfix)
	id 7403B6B05BE; Mon, 16 Nov 2026 15:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7181E6B05BF; Mon, 16 Nov 2026 15:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5951F6B05C0; Mon, 16 Nov 2026 15:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 362756B05BE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFC17401B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:42 +0000 (UTC)
X-FDA: 85442060004.22.4AB41A9
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 42E67C0012
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VmPp7q7i;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kM+1cSBa;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OoLTYMlr0lZV4JPJ0qpA2+2MwBJd9qMSNSbWYReUmv4=;
	b=B+IRCSGpGwAbl2dGNqZNNrwSZ7571HXmmU7yay6Wl4peotagQK542dSqIRq0do+c8jphNo
	XpWdxr9yRLNwf5JD68d7/7Ur2PU2YoITlaVkeMu+ivgeo17uKsbRNbSd4nX4QSKc5noc1t
	BRQFTS7BRBA+7NadEXXuWSHqPDewkG0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859480;
	b=scxUJLTylwfXJaG+cS1rV+UOvUq32GccfrC2TQVcTYWNnVQvEQfrsL/by5JZCHnC7ckWIW
	MnSOdRDBEVLr6dRnoKTk1AIEZ3kroXLzFp/hjaED11XknkLpWpYM+p5tE9ieQv3Kzw6YZk
	i9f+jTINF9+Upu5G+Jg8iNQUQyjYlBA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VmPp7q7i;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kM+1cSBa;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXNuK3638137
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=OoLT
	YMlr0lZV4JPJ0qpA2+2MwBJd9qMSNSbWYReUmv4=; b=VmPp7q7ixR/GQmSlNvEE
	kjmcyohLdB0C4sFEehPP88ZgwKMUFwGkFDkqrb2shv1Cy7FPgg0x0r+Z9sjlHc/U
	NuVTsGNgAkBRak1je4y8WwazCm93d9hmEu/dCxQbQ6BBI9tkC8MGMN0GJDzDzYAo
	HXE0iPoGzC2ycj9VXVdzPX8bPAyV8R+vEwZEIpKQksNa8VmYKjUSxaECMxx4RK5y
	MrHC1Dhn2b4sQDsej82n76kYp/RVPD1H3+7ugnCS/qVwCiaN6+h17CRFn6ZUWi6t
	zHDCuP5vvBjNK3/GrhKIuVowWPwAE7dn9kj1ax/2kXEjEk1RejzlGDP8vTHQCmbk
	yw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059cj333-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:38 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91f10c68ccbso4725006d6.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859477; x=1795464277; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OoLTYMlr0lZV4JPJ0qpA2+2MwBJd9qMSNSbWYReUmv4=;
        b=kM+1cSBaJsxASXXHINUYfcdz7ec0rLSSIe+nJzEae0IzIPWVEtqnuGIQcsaWIwE5GH
         LyBOFCexgJbAc9HmHJ7+9zq5apTCvd7SpgxNlinQBSBLjm4pAYUyeFcZsSb2ByfGZnuy
         Ni6moasMZ2gmtHYuxf2/HeLF+LcE2H6/Oo0AU6+h7BC3xGyv5XpB/lnZoDGFE4dXCUX6
         Oi0yUlvgIDWkrl9imWjs2S8kf9FQFpkddIxjyP/2bCnzbtTXNoAONSRgvY3oAYsMznDU
         PBwxA1zH+cxOp7TS4j07FY/3BRTlkc24Rj3pQycRmMEzfd4kyFbS/oIa3BSzpGhtFegp
         Gesw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859477; x=1795464277;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OoLTYMlr0lZV4JPJ0qpA2+2MwBJd9qMSNSbWYReUmv4=;
        b=q4O8j1h0x3/QnxdMJop9rcS9Z0RnFB3OFBlyhWgtB83VPxhS8dXvbtFjUYGNZlgnU2
         YWajDt0eMq0kUbmy+Ee1vQRP1uUtD0Jn6C+9IWq7Uqhsua7LQtjZAyUFOxEUH7OaY1GH
         UEdJxr7qqk9cUXy/HOeb7SShnKTTndxp7VmAsH7EuaTflVdWwqSDwVL+bLrnqzymrE7f
         Dbo7JQuF65ZInFBGPiHkC2geWaPh5SPmJitCBA7AgGYilqRqiLAWmCKjW8+aV/TFmxZG
         eAE1APpzDuO4Dt1bh9qX62+51u5v7qCag4NQ115N+BnEyk93PQrXbtjo35AsbQvKrm2N
         a3yg==
X-Gm-Message-State: APuU4Z+qUDcRHtPaRM6FQb+7LYtr5qEb3yhi9D+vhRH8OWlexIKgcmSA
	USK8ISCReKR3zIcG6n3kpX9NkQzXv6lH0JdOUkEyNtMFyzIzqIvgw5+6i6aQLWGv95eSRC9nwA4
	oCMRTBhGsXKzVVXolm88NAiBiL4JsMYOegjZ0DC5AAol/1zR1
X-Gm-Gg: AZFdTZdeoDqR0FLhKN2hMkW6SW6GfF6H5iTevLNtGprhLR+rBum1q036bw5sdcEzqqS
	4vzx36z/MUyRpMySfAslZV8m7eKNSEFg3t+k08vAoM6EWkkVsNqajX1y8WZTjY9FaNQExsOZpaa
	iWJFqKzuBC3/q8xzHErJ5dvbEQoiC+LQxclDgWZeKWWkm7hH1CUP7hvD4QDLsNUwi2KOQzK3GDo
	Lfj7RZJdokB5uKM0DoWzG7RTxdTJfq5XmhAF/+RFWdCr3IQXe8RM4h4GKE1pvOqdunewydttgnH
	7+dRyYVVS/1RdJTIiBO0SXEKvFGQJ9/bDK6mzKIMiqSXJkT/uOBukAabKn3FmdfWAfo+j8wqAFz
	FkN6v94UeMlrbqMRt6a+FyImwGv1/YZyXfquMBDSKV8lOvWND7zlTEzzMFzdHoKzxGtons8wGdf
	a6TXciCqfsF7oKlIbhtr33
X-Received: by 2002:a05:6214:404:b0:91f:3063:6b2f with SMTP id 6a1803df08f44-920fd34f33cmr9007286d6.17.1794859477431;
        Mon, 16 Nov 2026 12:04:37 -0800 (PST)
X-Received: by 2002:a05:6214:404:b0:91f:3063:6b2f with SMTP id 6a1803df08f44-920fd34f33cmr9006626d6.17.1794859476833;
        Mon, 16 Nov 2026 12:04:36 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:34 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:50 -0500
Subject: [PATCH v2 8/9] mm/migrate_device: do not migrate a uffd-protected
 zero page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261116-uffd-state-fixes-v2-8-4397a0196479@columbia.edu>
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
In-Reply-To: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=3477;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=rmChA7WgdOrC/88AxZpfJODdWq+Xphq5oh6yqVMIGRQ=;
 b=Aq8YehfZb6/OHRe5fm5im+wKKZvGIc/GWSlOLY0dwMWs4pJkhwuqJqx9nc8S+eDs6q4djpisX
 UCoLnNhweecC9FQQb7bS+LJGWbllO0Kys1HABgExaohJoPu9hSmT0f5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXxveicpsla/Si
 PSAxjxHsKH4CmL70eSKBxwqB1Qizu8EAp1t13yIphHxCf0QIHf5wITmHZtajNwH+yclmolDwnyL
 9I+3PtLl2MK4NV3VZIewizJaZNZlkelHrsGGiE9KXOqtsxjVhOYt
X-Authority-Analysis: v=2.4 cv=MsPHeGae c=1 sm=1 tr=0 ts=6afb61d6 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8
 a=9jRdOu3wAAAA:8 a=e5mUnYsNAAAA:8 a=Ikd4Dj_1AAAA:8 a=El0B2wc1DFe8a7cR29wA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
 a=ZE6KLimJVUuLrTuGpvhn:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-GUID: 3dAqnpwuMb7YOehd86tCvcB46OvmZWWp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXxYDUkDzT7akE
 W5RNLNKcmxmIrz855hLKEwaL30x3iYABQiQR5GYGXuQ92UUXZYS3r2P7ziVuhtvw9Qb4F6cNC7I
 PyQesafQxvinXzUNQcVx6QlldP+erygHw/MdWxFUPt7+/XvnWrjPLRLC4jdxxrkOnoHPQNq4GK+
 9tUlKHEZM0QQNp3Eu8tQwM+TtXbKTgjmaiulMEde6+DkfOxNrr3tMWMPa2+QdTWN/W1nrSCabkg
 YpQgMrfGmtB/HD2/MaVc08CR/uheTW9qG9Ad/9x/Qz69alW7Sgt5FKrdrVMwoMF91Tbgy+2ARyc
 WqWs++uL0JWY642ZvNVhBdsjQI/ebzBA+eW+Z/uHS7e2LwRaP8bJGtW7MELLXmCxYBeDB7bSuvy
 lkSfUdkMQjrJfRcX4b3lG8/oM4jJHacUS6VLC8HwQ6T2RpM1GrH+mRoOOC9avdsRSwuv9jza1/d
 6In7ehedUTWGUSaHPZw==
X-Proofpoint-ORIG-GUID: 3dAqnpwuMb7YOehd86tCvcB46OvmZWWp
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=10 clxscore=1015 impostorscore=10
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160080
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42E67C0012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ed3b674cpmfsxcq3eywypsb8tnyxyojd
X-HE-Tag: 1794859479-184899
X-HE-Meta: U2FsdGVkX19JcWnKIgWXXbBDwuE+13ntuuhW0CIVvjqquvb1J60uo788yGHU0qSQ4eeCOsvS7G/YQs+koiKsOHRPPCasb005e8+xnxtXUT5f9QtIk8ocRAB6d3Uh5cyM3KKRkR42QZrYKoQPXiLBlCr6oNBkQMYbR1tlaf7dQ3PD7P3dPsyCi6TdPoXLSCVOFQRahaojYIgHAkj4A204lGMCAsYqfWqTWleqdmjsRu1eRdK7Ifoc1GstLdnwSomx77DvH2abgo9nZkrZpNswJEyCle+C+eUm33HtPNkqkGGyV3DY/gO31e2v6Ar7hpsOt/yQbCYCjlQ8m4DuMsscwhbECpK0Ly6i+rb7LrqdAmlWJb7f8Ea+z5qNZlw61X52xpt4+mHcYjJU4V+SzfAEEpxfV4/ejsRL6OxO54vT65pAuwNnU5FznzpPp+lcTBNNV/hg5JZSFIgUUlykxwGvNoh66c89R5aDXX6XiDWR7mfioVm+08UyYcPKbREqXy3L3wD/9VGC0QpXrBN43JQeWS4oeAoI2mOLwogKzvJt9XLbXZO/j2MGmC2hXb44/qNVS+UT96ord1syU2Gpklex0xX16IeQNp9OJzOmx11iuav7IxBTA1UBBetxxQ87aG91bw41wYjiy6rxXuKl2OGeRJYN8i3P2O7yEPJC2d40B3E+7pj8j6TFngNInGU7CA8JjIddwgYQ0RBazBK2yXSB8zrfKzGGHuyLT4mhcfny9gTaeYaLbfDVxSX9Nx8TgRqAkBxS9RTJBThjbX/PbhBdsfa/iQ0K1aeFUAX+yre/kDQpa9q/y039ReHveNUpnSpCaOn5t3j2quwjp32iT8WMSLwVNLhurkeJ/y8Ra2+p7ZaoVJLbvFblt3/C9RE8wa+vKdAdhetkqsQ9j7lenk5vUJtYTf37CVQc+S5HcvZJxxVTXQ+4vUEn0G8xD1fqIRYh7+bg6T3M8qXExTBuGdi
 AfGdOL+p
 ymxa57WMSZy4q7eP4MIkPprI46tyr5qTDGIgw3meUu4MrvUBo7nzhhbW0285nXhNtcqyY9X1qVPcPf5mFA//pMhSaAYsuDgXG+stHJo1f1wqdbWnP9/FCcXorIoVJf8GMewHbwsNyB1GqEiJhYVGjqu//gG2Icsjh3CrNZ2T8veCnwp+yAECwwCk7YqiUPYUnmQgwI1TCIe/IWzi/Y1U3ftx1vyvICf7DStTxR7etWMnDique1Fr35r01ECpVNyMtStpoqpKq90qPkZA/xGrZCWSJcLZT2jNPZo44MciRsEgHk+B/P8TfxZPGthVIHiMdOx2vM2aabJ+t56bZVDBVZjRm08a82bYkjs43AejrHt5jc6+tPFU2V6D3cw+RywD5XA+pLKzk/1/4ZfZz4tzPBS9FpYROnwSuteRd7Z5B9wmc0PFHCe1dXbnPrOMRR+9XyYXzq9IHKIy5oTqIC2koEYV8BCNafg0DKqhCnbiGgSOK9X6EUYBdla0ahpppRQZpp/Z3R3PgzzMvCbgE2Eu8rXvRSN+WZ1fcJ364FTZT0HCGG28XCudkLrQfW3C+6OPjeMSuHiAp2HJKANdnPeWRf4UN5hdFQNFWfu1pvo/dEHwZOZwlLpDm1mcctvOTofL/X/P8EqxSSlpizQBGAkheKJoIgkaIuqaL8ov3rfiHLJ9ob4nxeYnyydWWTtAuG7a3FgjnhVYCHVqQCs4kTCgOqeqFYtgi+ZPvsLm+5DvweKiBzjPEKRCTDSAdWxFOBlDqvArw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device migration replaces a PTE that maps the zero page with a new PTE
that is built only from the VMA flags, so its userfaultfd WP or RWP
protection is lost. The same applies to the huge zero PMD. Writes and
accesses to the page are then no longer reported to userfaultfd.

To fix it, do not migrate a uffd-protected zero page. Skip it during
collection, and check again under the page table lock before inserting,
as another thread can protect the page after it was collected.

The alternative would be to carry the uffd state over to the new entry,
but a uffd-protected zero page in a range that a driver migrates should
be rare.

Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/migrate_device.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c..140b99f72508 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -159,7 +159,16 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 
 		folio = pmd_folio(*pmdp);
 		if (is_huge_zero_folio(folio)) {
+			/*
+			 * Nothing carries the uffd state of the zero page
+			 * over, so skip it if its uffd bit is set.
+			 */
+			bool protected = userfaultfd_protected(walk->vma) &&
+					 pmd_uffd(*pmdp);
+
 			spin_unlock(ptl);
+			if (protected)
+				return migrate_vma_collect_skip(start, end, walk);
 			return migrate_vma_collect_hole(start, end, -1, walk);
 		}
 		if (pmd_write(*pmdp))
@@ -337,6 +346,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			pfn = pte_pfn(pte);
 			if (is_zero_pfn(pfn) &&
 			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
+				/* See migrate_vma_collect_huge_pmd(). */
+				if (userfaultfd_protected(vma) && pte_uffd(pte))
+					goto next;
 				mpfn = MIGRATE_PFN_MIGRATE;
 				migrate->cpages++;
 				goto next;
@@ -871,10 +883,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (is_huge_zero_pmd(*pmdp))
+	if (is_huge_zero_pmd(*pmdp)) {
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_protected(vma) && pmd_uffd(*pmdp))
+			goto unlock_abort;
 		flush = true;
-	else if (!pmd_none(*pmdp))
+	} else if (!pmd_none(*pmdp)) {
 		goto unlock_abort;
+	}
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
@@ -1074,6 +1090,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 
 		if (!is_zero_pfn(pfn))
 			goto unlock_abort;
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_protected(vma) && pte_uffd(orig_pte))
+			goto unlock_abort;
 		flush = true;
 	} else if (!pte_none(orig_pte))
 		goto unlock_abort;

-- 
2.39.5


