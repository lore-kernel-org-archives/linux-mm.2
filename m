Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C31E606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=azAUGPgc;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=NZV1BUnv
Received: by kanga.kvack.org (Postfix)
	id DD1D86B05B4; Wed, 25 Nov 2026 21:25:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82B26B05B5; Wed, 25 Nov 2026 21:25:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49D66B05B6; Wed, 25 Nov 2026 21:25:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 526BD6B05B4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:25:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CE554C0264
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:25:26 +0000 (UTC)
X-FDA: 85475678652.09.7BB0249
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4B09140007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:25:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=azAUGPgc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NZV1BUnv;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795659924;
	b=emogP9q6dHHj7FkgNubzkH0SqqMHlAW5mTXion0nWF2FJeXJuFpHWpC4tF1KMUctdKJWF3
	B0Xiaa4dS0FHTkr6DFCM2+PkTYCTh0eDojWQnz2MpiuiFfMzyKzf5qW+s5IbX7lIFcUEUj
	wX8rvWm7LPUozZZcWEUAMUYruMGGJi4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795659924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
	b=0rjxaxnrErReKA7dj5TjpAxLhha3rLxrjvMX392N4TnMwdcKbAlRK0QO3nvXh731RNWNMe
	jFFK89l1ezszK5CUZW66hN0zHeXwTWM5uA4smNGhBJvfrVfd1/HScKRE5knftdOugifnik
	BdqoYeVXSuXiyjBwhOjLWFd7tms6Uvo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=azAUGPgc;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=NZV1BUnv;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQ1XFrf1038947
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:25:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=bq5K
	8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=; b=azAUGPgcRU1jSI5UcEdk
	lX/Oam7hV0qSGuaoRoZ76iTO+yUv1p2TSRxSWqw/GV116U6mifykV1LTK1RDVF4I
	iKOPSY3PSz8vfny7Ha9obUkbMW6zmIsYItSxjLycctsWrDJ2rP2Qa4yaT+QQ9KqU
	+4dz298p9gibceQ5lCgFjd5gQzpe1qreD1yq7bVWWajVHsF3DL8u2w+MyeG6JCax
	6uARcxrpY97cBRd9pD/9MBjtHydvImyxeSEwdpM3USUiXBCQARMKKoJ4GgI1FvmR
	xUwASOZFEFsMGQAO+s7arILwa8QlmuqSFhjk/ZCiUMSZ1ZhwWwfuQrgDVwgAtLqi
	3w==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j69eq8pb8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:25:22 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f5844e383so983151285a.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795659921; x=1796264721; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
        b=NZV1BUnvrd55uB/EiNuoqVdbBL/j1/3wMu8mH9mUbac1vElU/DWpMoDFE5S9iQn3HN
         S8F+ZBsFy38Bop2oPe2tz9FHdZUvcuCDRyakRSF7ykh0IIslItVmS7Ymto5hdwzKpkSL
         BlMsc7OjVlexwbRiqQFjnKFJCfjL/W0AzO6F1OsxBHfj0yBolvVn3p/c5yjkDV5Rq1+e
         Bc3bGeNVAG1AoDMWceiLjI89o5liutJhRqCobaXqHshyTk1AnHGtiJL8PQl+yG5hXATC
         CWwITErgblDnSmFvwCuRIivdJwG5+v5PXlq7ZEFsKPP6g9KO/qtmkHH6is3gDLdvNygC
         50BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795659921; x=1796264721;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bq5K8Z87IavuvaaKNiqMth7LGJ8zdX5mtp1Bwcp67Uc=;
        b=CAZ8GzRsoAuE4gYqtwaa/IsZWiPFBx8TTez+StkXjxHo+dkJzxBXyw+CQ2Xl6mHZ63
         ITLWrtppl+7E0BYIWf4LFDzEfjq/DycG5RBtFJ1m3ygL8qxO4NU8pXLdg4huoyiIEeRQ
         EV0NeNPp6f4y8ZzunOu4B1XcLlx/mV2SDpMRKXK4BoCWcMYHe0lTbIyRkQwMUrIWFKIn
         XJx8s0bV+CVCPHb0GaRQ/uePE/9kQ5P0EGtNdiSk7VJzjZVIm1eA0ClRs59oRR6U+Q0t
         zSRo6ZuFKoKT5LcWbjh7oQSb0MsD4LawmhHAo/V3OCzQI0MLPQAYtbp9X4XPEc2E1MlW
         gT6w==
X-Forwarded-Encrypted: i=1; AL+hErEt2vFdQimXXnFekJBWRZSGs0whplffnM+8u7kCSY5iplpJMJOalmkwNIQs5tiW6Tr0rot7gZNNCw==@kvack.org
X-Gm-Message-State: APuU4Z+sE8DH3hekKpkjC3MSZc/l281kyiWogroibgO4UQ1MgNjma5ef
	tMDDl4QhedzfGVlTcPSt83AYOGxReRFPs+bC7p4Ag8f7zi1V2T1xFbGNYRzIpYCJHuGSuKFt14K
	pKMlloFJX7RbVF0h/W511RISDlO66t9d3MUhU2B8Hes2pEEgfQSE+echm
X-Gm-Gg: AZFdTZcPexyJwYAi++kHdN1GUzJv7PeOnhzS6ywJXYRa58591PMiE+Dryld1qU5E1un
	0WvADIjnK87lTdRq3G2Ec2MdVY/Cx78lWw7bLsIiiiTcUMtulRvX5SUO84wJ0hg1zrtFBSf7uOT
	EHCH5oo8wNOubVLiztLD7XL4zpEO0pZ5Ocg438FHAq/z/XAjloc5DFNvrlAMWKl8DZDbpaGmMH9
	fxwwTt8vi31uYUwth2psXoGEpfcHzaQCmRRYmY+qxj8C33QZancq3d7W4wjQR4PupJJHwu8I+2r
	z2Yu1nvEONqs24hLSMrzRnVcFurvWRF4Mvw9sSfIcLIFGA8ftnqzvlYvecZI6eYr/9TFG4+gnaW
	foSpHfgT3TAzLfiDrF875BL9ynLUMKPbqeNzXxNsd4haLqgKOYxBmc1pn455oCNqsDgbP8vxN9C
	LtwB4en/tARmO59e8YOVBtD79heErIpQg=
X-Received: by 2002:a05:620a:1b8c:b0:949:7920:9d09 with SMTP id af79cd13be357-949ba99fdd3mr3499403185a.35.1795659921388;
        Wed, 25 Nov 2026 18:25:21 -0800 (PST)
X-Received: by 2002:a05:620a:1b8c:b0:949:7920:9d09 with SMTP id af79cd13be357-949ba99fdd3mr3499401185a.35.1795659920987;
        Wed, 25 Nov 2026 18:25:20 -0800 (PST)
Received: from localhost.localdomain (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb34ae74sm1452063385a.8.2026.11.25.18.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 18:25:20 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
        Pedro Falcato <pfalcato@suse.de>, John Hubbard <jhubbard@nvidia.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Zi Yan <ziy@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
        Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Date: Wed, 25 Nov 2026 21:24:18 -0500
Message-Id: <20261126022418.3620783-1-tz2294@columbia.edu>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de> <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com> <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net> <55114986-0ba1-4a80-8498-bf674d64e01b@kernel.org> <away88BuU8ibcTA5@infradead.org> <d088452f-1118-4a06-bc16-1942e523e0fc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: PloymAOLy1QbJFec73vmxPe7ZNLyzz3z
X-Authority-Analysis: v=2.4 cv=TtJzFzXh c=1 sm=1 tr=0 ts=6b079892 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=X-ZpGw2H3ZcMOUJhEmsA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: PloymAOLy1QbJFec73vmxPe7ZNLyzz3z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDAwOCBTYWx0ZWRfX3tLHmCqRoUt/
 XcjFgbqoQRoIe33pjXKS9geZDz7aX9TTN7RvkB8sgQhCXl0uoCxNM06mwsd/XCEFQuY8/xgdUNg
 5lM37VgH8QMS+4lI0XJ+xioIy9SjH1MikKD3pQ1pSTCwz5aPx0jnZ5IqFjJBntpAgMcp124fT2X
 I5GY3/OTQAbZsKJsufUwLEANeHK1piTsQh7WgnjwNVBxv5c/ZOTZqqEsnfoSzW0gDvm5zRGFhkT
 z8yqfqwPv8kmva7nTUoF2n1X/Bc9TQmAnENZxwYoWC6j+lRtKR4FTpd3TZ0I5hsftqBkbXOisbK
 1i2kJO8pjd9d1LErGMRJ8ojTbIEEjWM0nEn3Iys5DroVR19oqanAWSLRUXMK8p4eiTIokXq+GU0
 TDzSrcCfTPcnyfbclXi+npbAkEBQi1ND8Phc4rsxZdxKzFG1qHPcNBRPA605ciySQqlV8s9222O
 aSnMhGYNW6ugbqeuC8w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDAwOCBTYWx0ZWRfX1DUixquDJP8g
 cuXs/C3jV4QHZTM6JzfcuVnoOJTAOokjz9y+RLsIupCQn9pCXsWrtVMCNLOZQphttUXOzGzbxgx
 S63Mucn0EtWAr+l7ozay8BWAGslvDIauO6bwdZ4y0HfNaWU9x1Q6
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11977
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0 lowpriorityscore=10
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=10 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260008
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4B09140007
X-Stat-Signature: nf435oup33zgmu98g4n5uzcsj9e6h98k
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795659923-925488
X-HE-Meta: U2FsdGVkX18FyYOFXodH8NLf48JkL7Qd7Z7Zxa/TlWiL7P/Vo7chgK2r5390nbGWq+JiiViXo9P0qI6ojSKL+VaEXj7eD2jjn3nUoZ0tbJL+GKGaJV+/NvBI8KvsHXh8eV+WC4N1aoU4L6mGC4gNSx5ZCneubETd8Xqfm6j+sqmiRuGFuCNGebfqK12FsKjR2ECYssQQkqGb92pkbJ4Z3rOzJvbZW0BKVhCwTVCH/u+NmjKFFgYB49AUEmr7mAeQ9bcJMS5qX+WaxIRSbtGI+cMkGBQ0Ui/6xGcZ3VljYvyic328+IMBAn15J62WWEyJVhmPaV/uoEh8Jzl0BOe5Ykb/8sdMhpS+Wa2B/OXp6XI8US4jKeILD4rDKtEolSSl47Zf07hyMDmo88mHe99UtiLrvbv1VanFMqjjkA+R0EIryto/SjtLR9tu34+2SpcuDU4YU6nFAQAIBbI6R/W/iVtOezA81iHZyEzYalT1ATgfsNpuwWFG7oa3rzPvDzT8lq4l79YGBBpeHzGVQHzbdpGw3uE2+lTtUYw+lpuhXWe0F71d5BourFt8MnS0K3G7w/CpM4+Y7Wdo1d/ZjFv4OT9fVHb4oZICg2veGrm3JzxKkrWfHJKzqTNq7FAjQ0UvYWGfrMS+mcwhtdWKNsDMxCs3khWduRY0/pDhSTolKuSeBHvKTkslx8VaZCHrbF9CKtswrFBuih66vERdIw0SssnbThzWrBRv07cUyGxvSPlXps2Fb6OWgomT/xjw/PNokFw4TZ1CJodUwEmdqUusKg7D46XwlsI7hD0HI6d38dqEb8LUBZRtNcwB0S0C3TfXKpjTwTcp2RxCCjnOkX9gyD4nTno2AeMWtOS0ROt/4/DfdCGF76B/znTZdoMr3H/sc/QZwcotQTExmkj48+IPE6SSMcKRhNW8JwsA5UjwjqimGCar18ELtH5jufue1LDBQfCtad/b4n9pHpWRas/
 ttV0JbMd
 Op2tuaqaiz/xuz4gDmE8XLA+AjUzIJWhINMK1teRnFyjhFZsmiTEzHkCPMTwA9JgE37IFmmCoG1+w7lw2OslGz/dmy/oiWrl9JlBa6bUr5YnKF9bLgoLn5lzR00lRHTKT6Be1wV0N7A0VQSfvLPPopZgrBU93emsMeNCz+DrI97RFDEDFSEYzhF+s2f4RQNF+EEUZa+crZyU2rG977z4a29HXrCZVXpV7A2KcdZr3ctvyrikcHXQqOmQ2rwODicdC7Uf9tSciOfFgMNx5Sykjj8TT3nARqNoLpcZTEZpY/ZXyFMox0JpC/4inpMDIWiG5slJ3PM1uEgHsHo33cnOZ2w5dV2zkK5YfX2ClbROaLSc5JYLLJrVv9KWhYp+hYv9OXkapeJXOd83j/g9k/IeLKjxXvJ+OnkED/f+JPdUCdS7AVKeMEB0eryNRQdnjbgqEvcBtx3inzh+HjeVXCTUEetmSE8d7yjzyJuPHpHLfdxntj497LUZO+YF4E8OHuIWiyzWggOI2dbyBTbLCgg3SswTA5xhMiHwPDXe/kEleRK/qW5lZE9YrPKBHkJNDFShguUroUzQylSkSA16lZrWleM6ntK1yxbcgQkykm//EIEu6C7j3uSQ3WYs4B0M3kQYej/BEzfKHNgJaXjcdh23cZR2Lughnj8rqQM1l87l/aKzlNzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+CC Miklos

On 11/25/26 5:19 AM, David Hildenbrand (Arm) wrote:
> On 11/25/26 11:05, Christoph Hellwig wrote:
>> On Wed, Nov 25, 2026 at 10:50:42AM +0100, David Hildenbrand (Arm) wrote:
>>> 1) We fix all such cases now where unprivileged users can trigger this,
>>>    converting to FOLL_PIN.
>>
>> We need to, if not for this series then for all the other outstanding
>> issues with GUP writes.
>
> Cool, and I agree (that's why I placed it at 1).
>
> But who is "we"? Because I recall that "we" wanted to do that a while ago.
>
> (I won't be "we" ;) Pedro, can you take a look? I'm afraid the fuse thing might
> be the harder nut to crack)

Coincidentally, I sent out a patch to convert fuse_copy_fill() to use
iov_iter_extract_pages() a few days ago in order to remove its usage of
set_page_dirty_lock() and address a different race. I think it should
address the fuse side of this issue as well.

https://lore.kernel.org/all/20261120-fuse-copy-fill-pin-v1-1-72a0d888f140@columbia.edu/

Thanks,
Tal

