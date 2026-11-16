Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35D5606A89E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=rzKcPpLP;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xK3oGKA+
Received: by kanga.kvack.org (Postfix)
	id E1D116B05BA; Mon, 16 Nov 2026 15:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF52B6B05BB; Mon, 16 Nov 2026 15:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96016B05BC; Mon, 16 Nov 2026 15:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C2E96B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3CA7A01FD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:34 +0000 (UTC)
X-FDA: 85442059668.30.FF3D9C7
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 76005C000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=rzKcPpLP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xK3oGKA+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ioUD8QeW/Bl2QsONQm9YVJC6hK9MPeWajyNk7zYtP4=;
	b=ex3/n0rsZKwYtcXN6O+FrWbtCsWYyA4dG252ATur4p94upr9QAyGVDpRK77b+eSRDudZyL
	XhKFTkCHv41g6TKgrhMS6pj/P04adrvFfKUo0ZCMVWlVSkuRru97BlSDOKaY0RnQO/LEyZ
	NppjjXv0tw4110YkLtSR/1oEv5U+CzA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=rzKcPpLP;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xK3oGKA+;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859472;
	b=4MgRjDhQeOyghu4YVy1prkyYRFSSPkzqK7cNIfGEKq06h+my2SxeXveAX1FCXkk3tsmuNS
	dosmJ785lJ+y7OaXX8fYqK46A7udfnb7mG8GUnrd6B/Q9EZJh1Fcccq7VOiJSKYivq5f9V
	XCRxYr/XxY5FTxCxGhkt8Z8YvnYN8JA=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXQ1H1467535
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2ioU
	D8QeW/Bl2QsONQm9YVJC6hK9MPeWajyNk7zYtP4=; b=rzKcPpLPPjOBbfptWMeY
	KHBzukkwaGB5Pv6nbCYgFY2Oh4WwqTg9VRMTGxWKpUEyaA6PBzLi0v8FFWNZZSOz
	zh4/jwq4U3HmxAs6MHf7veIkmGvFQpNRuI7fvivypEBG4JTsSb5QUS5ocd9d2nth
	F91XJTTFa6DPCOQtFYeE7aLYtyVQZAAXD1IsmWH2zezJ7V3L46Je15bu15deNoXu
	/ne4yXvHiYnwd0MNHqVU5niignlDu3cN8QfUyKv66dUUsEgqKm727DtTCuURhIUa
	slKFrd6eHVZdFDIDPbIzNhgdGX3wx/eRm1UVIZrHoc1bkUQdj4GzaWC85jMSaI7O
	8g==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059hj03c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:30 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91f0f4c70cdso49118896d6.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859470; x=1795464270; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2ioUD8QeW/Bl2QsONQm9YVJC6hK9MPeWajyNk7zYtP4=;
        b=xK3oGKA+k4F5AtZmLD7o6Q1Sjhw14XOz3VOoTpQGWp5ELBh7o4ZvumL5O0Bz+U7w6Z
         IzMlPesXqoJNc2qsuTwxEYYRjZp/+CEyk2zek5DM2tfetDl1StF66sYuJFYZTzlCiMo1
         /5DfayuhKaCk4NXeiYeZ0KUm5rW2Af/6lJVUu4LOECyYLGxelcgnoihr4D29022+Cmuh
         SM0F+SJTpm+gyaMYAbllqNK/bLwBusgc5sbjeU7u9wWan4rhnfDEQdkG6VyIPIZCNczZ
         iMLi9h2jg/4jwQ97Vl8OK9tFzCVKGHYtmDhzGPrAH6jDJns40e3NStqeP50mZht+RX4P
         AEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859470; x=1795464270;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ioUD8QeW/Bl2QsONQm9YVJC6hK9MPeWajyNk7zYtP4=;
        b=VNSg8YVyaF1WvcJUyVEUKU1YgrnjMZe/P4cMP78s4RGwbA+5+BQj42e10GOkQ/wgpJ
         MjmOR4YhUKcI+aTMyugp3qd4ze2+d6e0itDg3N0CZD32bYyXoJuDViED7qZlGEkV1u32
         XLXzCNLHp4eDU7qOrNlsVSP9UsBbIn5mSFRJkmHfOrl2w1UGQCIqbpUulPNFB7zchZq0
         enPgNxBXQ4a0A1BrFZsg/RswL8+WxR45GSyQuiE0SzO+T+xUVtwXKQilJg1qPDe/znI1
         QP0nTaBNKbdQjG/qElNH1DyhFfY84hnP++ugCos2LqMr6zdepfhRvoyNmFANWxGqJT4q
         yHlg==
X-Gm-Message-State: APuU4Z/QkrM8lDJ6mymUd+oPFIPS7iWSN6WW1TZqah4HjJR/2DCkjv19
	zyloUKqGSDw8a73oKsGYN4AHgd5lb1mkaCpHyLlVfd1JF/I9gTaAXPadr/yqHIiOw449lR53Sg+
	c0KZDVBpxLwGAtKduiUV6/bjC2oM7WUzZE5YFnLjj5z5Nd8K2
X-Gm-Gg: AZFdTZdUXP0Nfj2EXrWnYg5tbqQPVN4JTqoSSoLa/ywEUo6yJTlus+jSQdPDKWE4mM2
	+Hk9qLU69YHN4oqIeDJ3YTt7Ienpi1Ehyc1jjKT7tF6AtTvzJVF/VWGn51lU55ok+iGjqA5C4mr
	EJcQaAXUN/cvLuS1EJXldNks88puB9kaKFfVahT9PQ+vSy6qNuz+rcLk+NtsAEqNCNqWF7LtQgZ
	1hUmPNtE79Hc+VpAs1SNlkZ5LazQxbi/1bjSzCrPaW5bwMngbQ7nItF3CJ+Dk8xChP+FkgERr1E
	UHBITIJIsJuxkprZOGzEqZ6mXHwNOqE2Cd7PRQaBmO2aEzbNdI0s0DJBC9bof8uF9ZFzRwgXz5q
	WYWd+Dl6UQYha/LyKdskyGtglMMYM2Til5cVihT3E9wmMrijmG3HiqaqQc/ArJGKn7w14Ay8JGw
	MguRCsqHS8a9qsW6RLsldb
X-Received: by 2002:a05:6214:8093:b0:91f:26f7:281b with SMTP id 6a1803df08f44-91f26f72946mr159226736d6.43.1794859469729;
        Mon, 16 Nov 2026 12:04:29 -0800 (PST)
X-Received: by 2002:a05:6214:8093:b0:91f:26f7:281b with SMTP id 6a1803df08f44-91f26f72946mr159226286d6.43.1794859469056;
        Mon, 16 Nov 2026 12:04:29 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:28 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:46 -0500
Subject: [PATCH v2 4/9] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-4-4397a0196479@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=2071;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Rpcxw98gNx7X8R3gnCRpd2IGCaZ7qUyuKdN6HwM4pEw=;
 b=yCtqcH1n96717qFSnug0DmtvKU2aDoSSvP8usjhBATY5U782p0hwGCGV9M5Y+cr8bHvHRBbSm
 HdPRffja1PiA8jPnHDgHJlTaf2jAJ3jlTESZwHdSAhyY+MGSmKh++wr
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: AbNiZDJysUJ2fwgwGgScN-CGiMtb7exy
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX1lzwbkIs/VZj
 Mc0X88082jm2rFFV8awOwgYL42uVupg1Dpg+u+zC5EICkwWm4aTYb0pGi7MZD6XBna3e9qdRCet
 /qlSnDA88n25N5OdtTIwpBENAg1lz8V3ERUoMShxCPX4YwYXRsMJ
X-Proofpoint-GUID: AbNiZDJysUJ2fwgwGgScN-CGiMtb7exy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX0pUQQ9oWsgPq
 ev3rlNPl046+U+ZRYL49HVlz4gCvhdtgWIx+PoQ5O1LUfyY+DVTq0U+8NnfCuVBP3JS7OJUJ8O6
 yoUZdHn79kf1H17E0sEjThVZCEgpNk8F/DkOXbT8c1flQV5zYEWdRDVeAo+VuUDHrPaYsA7EfhA
 eHaiYw6VHQ1OXGT7VWqpZAxrFQm3rdWVsCGUSkZw2zOoiFxFWIL/x26TbrWoMccg4JuZ/U3oGtR
 ILzrsxNtoDZn25D7bD4/cbpCZ4lBl4ljz1H5L4mjWrAaqu6E8Z7kUZUSKFo5vxcrxy1afcZ6hm2
 Nkt8YXG49O8oP87NWxsmEgiveoKrexf24en3f352kMKRPV0/u5eEFa6Qk3piDl4FWkJoG3LoS0g
 Q8Moa6hCf4CIL7kzAPYK/IdS3mDZssNWYroHRu/YZFq/4yoi71/LptvfsqXoVZLRbPrlxLbHjhJ
 mN0cWvSpoU8S9zifwTw==
X-Authority-Analysis: v=2.4 cv=NLlAaE6g c=1 sm=1 tr=0 ts=6afb61ce cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=Ikd4Dj_1AAAA:8 a=b4_iZGTmu4G-YPbO22QA:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 clxscore=1015 spamscore=0
 suspectscore=0 bulkscore=10 lowpriorityscore=10 malwarescore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160080
X-Rspamd-Queue-Id: 76005C000F
X-Rspam-User: 
X-Stat-Signature: czxn47r9gsx57i8gwxr74aymrupwz36z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794859472-910874
X-HE-Meta: U2FsdGVkX1+TR/EqmMQMBQ108NMsSOB7hGnZGDERjBlZ3SvZ9Pm2t7oLKwVQaz6G4LPX6cC9jJyUDNMYr1fddr/pssyRrSB9l7wJvMs2uREpFXgEm0ktramQDYvAThlqFwS/4k7VWBxDgloUbzUqSQ2fjLQakMp8T/ef2YthaUMNawR55fK0MTM9Lb210f3Fk8M9HS66XBeduv6vadkwMYM7Y9ktYGhjAWV4z/ktk3GZTywIsb3ICbBA6Kb1Skw9LaI/DQmLh0BSYv1QL/HPql7wQvTGRWcToFCZQq5bnbaKoaw/+puCH81PnL40EHMXTO3gVFDpjG1p2oaunSyYkV/y8mZqFMvSj9nVfarlisQs5fH5bwFN8IHMiKR27XKO0QlSqBmJ901xaACiZ/TH7NQOlaCTX8Oh8QWOuma0M7vuAo2BeU9fuk+4kWlVv418m0t2oBj6vR8ieyBOY9/H5WJavWWeEgkDN6zxaS2k6kak6e6OpIQsar3IGbrMtPkNRd+zB4xotxE479pZsfx7RRGTc9oeDwZb+ySimcatMlhmHlpfEyCxOoJqMwxw/RGKhQstmcfBPOeu66Vb4XV/Fm9rquw3ExopRhq/nT0xgptrpCTS/e6k16reOgUtl6+GGN0ZTM8ZuUUruEXyvigawro597E0PJkgW7UKOcTrbkRmQJT+I1hFV8Cj06YvrGGS2DF8jz2/wA5KQqBi4Zk3xrNSu3NjK+tIrGRlyJQQLwVvB/H+Ow56+/wR06HfpuMIth1yAdn4weZz0cd7FFoUnRwQMrspmW2l3SyKeYLKKmwa/Okl8ciU0mggylsA6SH8dyqujZ3RNYQpjel+OYGaZhGq196WiWD1j3C5nCx4Ez6MAyCee8F5ft3AxTHoR8dhVsAI3JtIBfO+WssD9xyeJG8EoIWq+3NUMq6boiXpDk5rPlARYA6YprOCKYLafwUOUc38MmDNsF8GGwckokN
 Y0E0G8Sv
 9B8ZZIAY+tIg+8iTWmfIn7nWM9YJTC4C/KN+h0PxuX+o8VBieDLOuvFhNA1Jsj7Bced7aE51Ml3YlcERwUOlMBYPiA0TQ5sttJH41X5CMPA1+TLqQ6OfwMTPWoTtjvJ1H/C+nku8xSLrRBmqDfj/gVmYrDA2kmt44u4Iu9aWldFVdLkKuzrlgR86VPE63x+AEpuNCSw2Wgo2SsPHLHMOj5xQMotbxclut0xAqO54lt1CtnJS2yOe+g4Z9LVD+GthwkjgMUK1doDvfa28fry8g6bFIT4GuibGL5aIDcsLcnID5RRVlMS67Wl6jq1Ah2s/Fi/v6apwmvdSJGooApAJe4LqaEw7N66A6gjf+VV8Lwvcr8bJSV5ArWBgjdfhPsOsnrU4ZbHjj9z2JwxpGd54iut16PP0R1hsKiVpTwhspNAE76sknzsSaYd5fiKCNsL5d2183cP4vDTO7Fp2MM+V4gvz9qYIzGZElOuMb1lwqhhgI6MnZhI1xcLw0iNhkr4FDPJguRPyxY+2nkgWvwgPw+6ejPs0KK8wyxew5lDbrvleGgOTwwE8k5D5Xqg==
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

The only known path that created such entries is PAGEMAP_SCAN. With
PM_SCAN_WP_MATCHING, it write-protects the pages it scans, and it set
the uffd bit on a writable migration entry without downgrading it. Now
that PAGEMAP_SCAN downgrades them like change_protection() does, we
should no longer see them, so this change alone should not be visible to
userspace. If another path ever creates a writable migration entry with
the uffd bit set, the page now stays write-protected instead of losing
the uffd bit.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
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


