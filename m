Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECAA606C213
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=L+q+MG2X;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=1pSg/Hb0
Received: by kanga.kvack.org (Postfix)
	id 3F5C16B05CB; Wed, 11 Nov 2026 12:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3576D6B05CC; Wed, 11 Nov 2026 12:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D26F6B05CD; Wed, 11 Nov 2026 12:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E55D06B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 859F2160369
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:03 +0000 (UTC)
X-FDA: 85423591806.19.16FC29D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C740C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L+q+MG2X;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="1pSg/Hb0";
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4/i2EgwZRht7H/ivL+S2kGFMBILOdVUz3uGWsdouUQ=;
	b=Z6XL4aFXw+C1KzpKLqVv1sHlSrx2HVmUpyeki7ZaOTCe3Cene0AILBz9J7nuqmk6CXfG/k
	qPsxPuqjRPbg0WLXauDkMMqFnvtNbyRXx9isQQuU8bQYcx5ZKwyUdEmbeu8tklIpm6rLhk
	f3x3Ik7ye2mM763bokcgTooYgb3uttc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419761;
	b=Sy6mFDDhauxZQwB7Vd5IwdLaJ6Vs07w0hwguH4hYgDobWGQDOS8F0a/IRJVWIAiYVbSBq4
	PuGbUWD5vbkHS8bfk2s9T6GIO3vFrgWRFqHiiP3UM3NLsnkWPQv9wxjKVslcw1JQeUP7aw
	/xkvEr57fCAZcU5DCi7qpkowxuT40BM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=L+q+MG2X;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="1pSg/Hb0";
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYChe737271
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=O4/i
	2EgwZRht7H/ivL+S2kGFMBILOdVUz3uGWsdouUQ=; b=L+q+MG2XoNuKY/IZsad6
	soELIyEKZKjBGQipZvfNqhhUz0I5GLTo8piQ08fVpEzhXaEXUfvriTC3aJmovqL/
	tKrgq+kR8i7QkCh8Hd0lZK3DNR/9BWJngEgeAN3glgzDEP4wzkgwc1JJT4+27etQ
	kHR2cU0TN2ymHOLKFMEVqWtRzVGfUYiA0lW1kaPXF+b8+aXp6O7/qdIAfzyJONxW
	YfQvpcCKW1ZMgv3IJ/XfdvWY/AfkyV2NE2R6nyp1TtqlunHxUEKa5X6G88mLAx7Z
	gWKST56SjdGAabyk50imTHP6tZs13oxohjvTNVsyZghslaLZeJWsaYqp36risHdJ
	fw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvdjkd4j6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:59 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5358515b4easo60203931cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419759; x=1795024559; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4/i2EgwZRht7H/ivL+S2kGFMBILOdVUz3uGWsdouUQ=;
        b=1pSg/Hb0vwzqID8z6vm5KZWnoiNCTxb5RXeg98x2jqh0WYLVsq31ZCZWiCfVEYG1e5
         71isxazpDYmsrKQgzvWayabSGjj+kJHsTo/+S4abAoNKf2Chvlm9ikiLc1O39CAPdTCp
         qJsS6kgZ5pCBRhBC5wLDYQD8Sc9HT/MEnD9FaxIINjz+nmpnkRRdbNF+Z2stP6xsflsL
         FFBe3CrIXTrqi/0dW3JVjM8ugirRvOA7OF2sQdZuy9CQZS8jQ768af/CozlPn3fV8s2B
         ENWhVBX1D9+c7cqfPEAPnRr63HigZI06Vr1kz1zCVL84MSwBagesxeWsZYPtCXv5yKBc
         WgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419759; x=1795024559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O4/i2EgwZRht7H/ivL+S2kGFMBILOdVUz3uGWsdouUQ=;
        b=IeoSVKteeA04PP/qA7trf1/h9FMq9ttxqLuxZu4WnHtUs/6AsfI95PktAor7Mf+xXq
         WDkizTz544EKMadHTAVPOR/eB4MFEV82s3Z3v20pCcX2iNuC4rffUgSfL33QpdptjisB
         QBzn19JuiCCxo6ZtyHzrdl0DvJQZngqOqZh5FPz8XJDgF9Gz8T1S6I4ksB245AoD6L42
         bwbLIAMVTRLaVFmqrd2Q5BhC7XHiyOvg5Vwm0TLEw130gM2v7MGXnWJWcLtV3iqNdZeH
         XFbaStRQhC3SS0VaFbqSnjgCjNui7Lm5wYgeyOpIjAd0MvDzZM6fWOOLkLXL1ZkxI3PZ
         5XvQ==
X-Gm-Message-State: APuU4Z8HOiztwTqVGy3wdJRNbZdl0NNC8z1HvfCF9T5XAZe2m4P8GWpz
	GQxmaA2cUORqlLlHgHMwna/TjvU9JHOkxR9UIbMWqvGkJHKpfb8G8vTvYT7DD1+42L3zotLzG9x
	ifvVEf+l6jybfpxAghTUx1emmfgjCfgEaGrOEE8253hO16Blg
X-Gm-Gg: AYBFou3UMmwtUcBR2G3G118I9ncom4k7Wrf66bPIKgid0R+v0GUB4lzzTNwo/rFHJrD
	ZOPSgl/5YY62h/JofebhyrYqtIPfPRoWsC6cD1Ar4brcWz9xWtriB/s8a4SKylAhCIsOIdoauzo
	u9dk3fDLu4ahjhgaqZ0UQ3/EUHDngzcznahdOKwQlmZMJxtNZmv4O7IspCkVzKgds95sAQ+lOQT
	U3Pu2rPV85Ih+2ijYhswjj9UeIuJgcwqxiZoIh+nyZDuTsFrFdam+/r69ffzMrax+4kFq8qAwMk
	rw7uY5JsJA0GxUsP5K7Dkgrw7gmlbRSeDNIGSPtz2hSILM6BF4oVAaaZaDV63GGectQic+qBL9L
	a481jKzDtxj7OOLVh0WWiYNuMyX7B7bt+cDRYvGTXxLqAeLW9WtdKKXY33DWkgvUpEgJkVK6ov/
	FXjPkH6bu7jhSwjgdj9A==
X-Received: by 2002:ac8:5713:0:b0:545:c5ec:fa3f with SMTP id d75a77b69052e-556c04f0896mr48125881cf.45.1794419759295;
        Wed, 11 Nov 2026 09:55:59 -0800 (PST)
X-Received: by 2002:ac8:5713:0:b0:545:c5ec:fa3f with SMTP id d75a77b69052e-556c04f0896mr48125181cf.45.1794419758662;
        Wed, 11 Nov 2026 09:55:58 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:58 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:12 -0500
Subject: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=1718;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=oJnm9FzYnu6qaz/PaR7bVgjlC0D/81eFAkcgURIt440=;
 b=bFUiMWTquKqFKlwBKZ89sJhyun4AHiRJEsk78WWUx1+sVlv6Qb4KBgPb6/z8x1kgBoXAvmIo6
 hJJcR37k5fyDamaO2atD6gtZHwsAKPDUG6Z4UbgtfLNFpXNaY3rhISm
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: opTjDb1zQKBCRms5O_8iHRzrR9gYM71Z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX9+mCeCv/ZXNN
 SUSR+6+WFnXatPMoPq+vZnijl9IDswvF6I9Nzc0nupIl/uL13VdDsC9cj+ANIxreSpl95dIPvvn
 AVgBmJwR6JTgHoVkmkJLz390bmjcIvcXcrBDfxm9VjfrhRpDlzuoEdMtmu2pyOKnG3Kbr7H4hGb
 r0v2DXrl6iMvXK1B/ZSz3tuFpkfdiXzXVMAewQZQ9tGX8CvDLepk8jAuSspNC2tOPN7BoQ+F/Mp
 HT1/1qnldCxnqjVzU9L117Xk44aM/EJWtu332Gftvd/NqQA5glWyCL7GHu+56tUwIi7FTZrWGa6
 ZeqpWYgw27R5+66D5hvwf5W9/Mw0VVDaf85olGyK617s9O7bsi+D11G8mCFRXOJrzYnIUPcHqVj
 svTgelWepzjHIpZT5hCQq3ZYSjuHS3qPlyzt45yHohvP5SFLP69+sQalmmCzHM08+J3wRP26a+P
 +N9+Lr3Mq85yH1u9ZgQ==
X-Authority-Analysis: v=2.4 cv=V/boQuni c=1 sm=1 tr=0 ts=6af4ac30 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=7D-TeM2RRefI-p9tlh8A:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX1MRaLywIus9k
 kXI3nkr/IL+zIoxX2yZgQyJs2+xlhVPjY5TwmB13xt9p0XAq5AZKkw2RGqjC+/DBNPQaLjzREl+
 xjfq1AKb9+bJsixRVUIGEj6RmubXuCYvrONbCTd+p1wMHLffmbFE
X-Proofpoint-ORIG-GUID: opTjDb1zQKBCRms5O_8iHRzrR9gYM71Z
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 impostorscore=10
 suspectscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C740C0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ysetq9dzbjarasoakdefozibyn8w5ieh
X-Rspam-User: 
X-HE-Tag: 1794419760-61177
X-HE-Meta: U2FsdGVkX18zF90Lo+EVtwNzhEUGNdwiNwpXZD4Z2P5kSeUQIlV+CFYthxZGrWJ6jnT9QUPCg9y+wCSbbVR8si+IxtYrvUPZUBBbkZaUVujwXQ7DXZAnRhdCWEkF3tEZfqN/1/Ssld6yeuggomomIEotnzbyagiEdgW848ttaKKDZSxXjQuMuoLA0ORg5EVz10LODg+b6KC/dNVU0xqYvgM5+aTbHoPSMi8tOcSTkkzqs5JvRYl9isjUhRhQ0nkYoLpuL8SXMPhngKRJRH0RGIf7swofP12+ZZGhLBLON/vOTnvmCwnUcVOiGTG6PL20yx1l2ZHu3YQaXo93xX4BnkeaTfYIy6FIK0mGy4tYGIsCNWuu/Hu45atpW15pDyMgYDyIcqTJGENv8H6mKEnX2MCQ04g9GS/J/mNB+YN6A1J8lZie2iajcepMzhlnMgUlwMf74AYpgXxjq2nY58HStv7Uvk31/JPIfXR/Ut8rt4o8Xf4uyJhCQKjLt1ZSZxnGygApOe0ZPWQ11n8nntU0a8SkYwZWPVf2yf7brqXy8uuyXezw+4p9ZYnHp8CAtRtIvbDW0261qD4s45N+56GvDNAM7AP9FWqIqfY1PtwtViXmf651n9qaHYG/WIs30bDUqoBvA2gJDp6pkpr6YZB+0bKVhgwK4CafOpbFsNcKISnLXZyhh8W4+09coCu3Kq7R3M5Dzcup1d486NhhnropPLu2cMZ2jE1G8U42/uPlmq7aaqrMijT4lWzgqHaszTOxj0Fiz7B44Ip0OK5mvM9cUH/tldwyIgUgX6VQIZvrczY7/E8ckxr3gvGBLnU5NUmh70Ppp5Bhf40TYdFtaYOAsJyOjslUeuiIG9gkOVOi/JURANxWCuV8gpZr+XgEVVxN6TXewnBfjBdpdzj1BkHyAQso3Asl5YI52c3IJI479DiIDNgW8ExuPNfzCC6MQDJrq8BUAv/6typiMt2yQ1z
 KNBw6SX9
 gifyPlAv9ZxpWan5QhMQqA+TdleVdvkTgTeJfZqoob0Js0BcUitRv7XqYlf6OKNPB3+U6GcyxngMC0RrXmug7FegR6XkxrwbcKiRzT/UyINOD6XW5mjHJNE/8z6Bnh12MeiSBmf9moF1/RL8ooxVIBfyUHpVRiJWexpq1sRGiUYbBpt4w0JQFJQ8sLj9xM3lubEyyH79t/OUDHjb6OTDyQrpsV6/kZNR9uInQPIP8MUquVlT14YVfikyk0oPobdDTE+KhCkQTMCoAruPqCtJuIdssLSeAyCutoHtHd15cLVjNZ3cYE3Cu4rILMlz4KgOtdZpJjYs3t/5XXy5vXEfuCvPQQfrMm1LW/1RDI6kfZx0DpRV083PIUZeFki72GAWm81vqmU13v3zrD69lT1MYPMUJJdVk1UF2l07vOam4T0oBiQRv3g6Pwyob0jfWuBlaWw8sQwOQJrmW7/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remove_migration_pte() makes the restored PTE writable for a writable
migration entry, and only looks at the uffd bit of the entry otherwise.
A writable migration entry that has the uffd bit set is therefore
restored as a writable PTE without the uffd bit, and the page is no
longer write-protected.

An entry with the uffd bit set must be restored write-protected, whether
the entry is writable or not. remove_migration_pmd() gets this right: it
makes the PMD writable and sets the uffd bit as two independent steps,
and pmd_mkuffd() write-protects the result. To fix it, do the same at
the PTE level, where pte_mkuffd() write-protects the PTE as well.

The only known path that created such entries is PAGEMAP_SCAN. Now that
PAGEMAP_SCAN downgrades them like change_protection() does, we should no
longer see them, so this change alone should not be visible to
userspace. If another path ever creates a writable migration entry with
the uffd bit set, the page now stays write-protected instead of losing
the uffd bit.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735..d200f64b5f98 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -399,7 +399,7 @@ static bool remove_migration_pte(struct folio *folio,
 
 		if (softleaf_is_migration_write(entry))
 			pte = pte_mkwrite(pte, vma);
-		else if (pte_swp_uffd(old_pte))
+		if (pte_swp_uffd(old_pte))
 			pte = pte_mkuffd(pte);
 
 		/* See do_swap_page(): restore PAGE_NONE for RWP */

-- 
2.39.5


