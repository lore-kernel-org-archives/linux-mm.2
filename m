Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919DC606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Hh7sd9pL;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=WybY0cfA
Received: by kanga.kvack.org (Postfix)
	id 7C5D66B05D5; Wed, 11 Nov 2026 12:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 728CB6B05D6; Wed, 11 Nov 2026 12:56:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57AAF6B05D7; Wed, 11 Nov 2026 12:56:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25A7C6B05D5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 460271A03D0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:12 +0000 (UTC)
X-FDA: 85423592184.20.711CC57
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id D39B920002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Hh7sd9pL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=WybY0cfA;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419770;
	b=o2ZtoCrSrZ6fYMYO7BBBLixxYiHWfnx7btNe2IUiVJEbBXWl0K+9pnzvSpy60sJthKiDMB
	OnTNrph9zvWrRNgCu3orvb8v0S74LCg3x9B2Rzov6PZn47BNR7OsiHhSV/QxM7C3AZAEkn
	/dxQFXkrZaoN2YxeNVyg62hxospcETU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Hh7sd9pL;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=WybY0cfA;
	spf=pass (imf31.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BBlMDdhjzTQo0mVweCvphKP4StdkmuGlmZUd2y9c2JY=;
	b=kAnoUyYaP2XLHCuYntd4M4vH7HdggCon3Ie3dpW49Mm7xvClNgBPOKOuY0i5qu2RgFl62k
	Pp5edGXkk9abK8vJ48K0rBUPLpqA6GoQQ/xNvnAe00cyvnbRWCttaCgaRetNpECgNKpxuD
	Ypw2GAHNtUUl/jqbeFPom93D39cikaI=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYFZI737668
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=BBlM
	DdhjzTQo0mVweCvphKP4StdkmuGlmZUd2y9c2JY=; b=Hh7sd9pLX35u6rtxYlZD
	dOxs6AXrfDKYFU3/qNuaqZzFICWetMLouHi567NphQxkL0icIcLmzP+l8kVtqnLK
	EJ4h3S3xmxzrH1Ed/xY0Kg/wU3P1QXtWAT8zKvcfGt9iqsO+k5ygY8cqTipWQB70
	EbuBHeXykU2+jWv9NhaFE50/yEg6CvkI9A5kq4jZvS9UIT9G7SpHZao4BLi48sK2
	WoLN+xd78SbCFK5hFQ5sjUhorjsqLHHO3XV0ljVCpJLlr9nivITzDw9Ar6WUVaES
	U4+lkxX9MBi+E46Y+xpNva3RXBJLwbkkQGH46akYRZe5D4KMgpE610DCQedVFH1m
	Gw==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvdjkd4mk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:08 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-542fc619afaso44785881cf.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419768; x=1795024568; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BBlMDdhjzTQo0mVweCvphKP4StdkmuGlmZUd2y9c2JY=;
        b=WybY0cfABEFi9kxhJovrVu5N/n4OTZsfE13BKvYfuewd/Ti6Eiiq3RmnyE1rGRhIJs
         0YxS2xf0aXkbxWu9IGW3HYfLFi8k2ZuXuIyENRqg0veDX1LEWrIouXT+/ha74jJ7ZcLk
         bMc9mEBt5YE6LmMX3ow6YF05GtA+zR9zp2MenNOM4krYMNcXz/L1NjqpdRut8ezJ9Zbj
         JZDEOaZLsNNnfXEs8oJzDDaGXOtPjT9KgC39+m1ZdHGE/Ivn6LG53W0vez2mLcZOLLz7
         s/sJ1sEsHAGWUh9M9vHEfec180QjgMJkIyyYnyT6mlpyLNcel0+OOr7jiu1Phivf7d0f
         H4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419768; x=1795024568;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BBlMDdhjzTQo0mVweCvphKP4StdkmuGlmZUd2y9c2JY=;
        b=RmRw32T5hXoiHcpZwlppIIb+5J6iRERVBbbqCsKSXj/bpW1C9QayJhx/WoVQTbxEG1
         2BZ8Jvx55y4171uRwx2fj+FRUcl35xc0hakyVPo8EvKVT+FTPsNor2rwuFQj5mFLrjwe
         p9bx8mVBztKpJ63j+ndQy34uKO/n7C0vO4l6FWewG6Ie4HaKO5iwVvSCvPIhMLgevjP7
         gopIzDF+hV1thB4GFbJemyGMxt08/mHn5M/O3Tl58LWDrDaVsrGYzScmJ3iaVwwmiar7
         QKcL4k+scKBQkMM+fIWazS0Cj+XwZnMGJzKDlrgxDng6vEVov2Zw9gNt4bHg4luOlPmp
         UlDQ==
X-Gm-Message-State: APuU4Z+SaLs1QXdCiTrhXF9iCmz/0yebwrjw9zNzQmD48Uo9gfKZipH2
	cndFA7cH+RLLSekgCr5rWbT9esf0Jvo13Nz3CZk+C4Avmjl/JCDT3R4KDJQpxLr2ulanGvsJ2uQ
	/KlIVXCgfkrfAp8Loue1LcGVDFMBAyAhdnQ8ynJ3xhLsQkIXC
X-Gm-Gg: AYBFou0WxKbM8PlMiLk5Qyov0I4id4oA24+5TAGGegFzN2l2eb1k1MRZgceNlllrmaI
	Gc8QEWndgAdt8fp3hw5jWUof6nCwojC5iRnqAd4Qtyc4zvJbw+UK8DQtgsQLxBMTUQZHqOBRiJs
	ywVml0CT3sb9Py4/Y6t/GAXtmU8E2W8fnLMruIwwm3SEcQA7baTki+ylaNMFvWlQUk1W6jhojgX
	hn7l1DwRMtTPvterT/oGwxtkSuV4DmEqMotlZ96MZOowQYF8MvDuDBDygdAXaDyG2vcDYB0bgbN
	kc0yQ7056NT2p9nCtFq4+Qjo4Xaj9qsugfahS+vNeLwMjWqcjhb5cDA1OGFykwYsjw0lLlw9K6m
	ha63z4zHsG+cc9LNSwqgOTzGG39IlZaF22js4DwsZCMq3cEJP7adjsPN7UkF+S8Bfn9fLZlleN0
	YBnhxMGpp/lGXjIbWBTg==
X-Received: by 2002:ac8:5a0e:0:b0:536:79aa:de1f with SMTP id d75a77b69052e-556c1197894mr48425071cf.59.1794419768068;
        Wed, 11 Nov 2026 09:56:08 -0800 (PST)
X-Received: by 2002:ac8:5a0e:0:b0:536:79aa:de1f with SMTP id d75a77b69052e-556c1197894mr48424651cf.59.1794419767488;
        Wed, 11 Nov 2026 09:56:07 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:07 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:18 -0500
Subject: [PATCH 10/12] mm: set the uffd-wp bit on a guard marker when
 write-protecting
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=4747;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ul44rnbOIwU4lu3lsdNUVT1/DDeRuHSjTUnRw0a9WDU=;
 b=fQsTj/i4UDq/yryVbSh4wKtMJl71uW3GYCH+sFLo7nbH9QwIF3IoGj2UFmj9P90rfaHOlmBJe
 gd1PEh3ydhsDVrHDCabHuLuuuSUCXXz5rWvEfQeIz3wqKs2J9YDY4iH
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: ds2kB9QGIoeR0Jw5ycQdQpBDuHsSpZh6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXwtbWPRMeeHFz
 f3mAAIPsU/a5Wqawgl4Swz0yK6q/UMOAo47q//vLYKWq4XXNN6JcGwaNqU8Ih9uB6XRyOcftVzY
 YyIpxEU67QZ9UPYlLzZmE35hB6QauRpiGSvRaUj4GCvMEahkFEQTIOBLWo7fi2Rp01PU1o5vRRz
 fG7c/V8rVazGUBDEo59FvNpHLWJtR8hzsD8UBN92gTTDFQZojBgiczOcubwrW8S1I8e1onSr50E
 ily84us5Ryy1yasqbbi5lbYURqfgK0OtUdHItE2gAAQzK8BWjZSCHEvkVTsw/SHLNbXsoilju41
 kCogrg/9RMpNy09beSAKPKYfKdYfPs/RP3vB9KuGqH2RLXKRbdhMeCG/sUmlrZ1kSLcJ3OFtKh/
 ZO/ZacALlT6Zh6Rq87AQgpv5bPY8k/4CqWmNBjDM6HFtUYb7/6a9WQXvLClIF+lvQ9bY9nGt38G
 j1064audT7H0RDaM96w==
X-Authority-Analysis: v=2.4 cv=V/boQuni c=1 sm=1 tr=0 ts=6af4ac38 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=A3l_acRxY7KWR7xJ1gsA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXwhNn6mRu5oNY
 CIfVpujHotxaTR5/ymxbQ1QvCJkFC0EZj9NVPG3aJlURG/1dv7jgo/QmHd9SWx3pQ+dZZ9F3bYo
 TowmQ9lPXwF8TAE+cGqMY3cf4G41vVme7zlMDp3wENtyVsAUQ24r
X-Proofpoint-ORIG-GUID: ds2kB9QGIoeR0Jw5ycQdQpBDuHsSpZh6
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 phishscore=0 adultscore=0 impostorscore=10
 suspectscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Stat-Signature: 7pfiixpcx8p3yp9n6573dgfwjyyrenat
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D39B920002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419769-151369
X-HE-Meta: U2FsdGVkX1/Lz0A0cKBNem5LOQtyAneBSXXptMN4vJWaZF3SeyCeVx8UKHMVgBaNYh5K3gaCbb169irzpZTh81Nf8xHu1uKRW8AoZsBKCnILoyaFc8T5GVnIN4dMvDzKT1nSoG7oJRdVN3/MHgzjzO7f9YK4OR9zyuyco806+g6bTJlIRBAx6yGE9hNSHai0ShNwZV/f3aYMzIWB65wejvKW9JBuNXCL1rBrXPSEAtXrtBkDqvbm8Mlp6/S/XQ5NfzdE9bZhKYdNLnl8IDyTdta/KvWBB5QDT7hqorBZ/72PbNOyyNddXthX7mDSzW6IwMr0rsoNNfzAgZsPY31Pj0fUdpE0xSx+UgSOiivLdn2SObFm/kyiiwz7b1mUkDU2kn5CG4IcKlnOmuRwR4E1tD9Yp5zIkZa4ysqMl22Qogv9td5SacBtgypSJ1hU23VXjI7j7z33AgwIewJ31zzgBRv095QPZxr/yPNyeJ1+Zvnvk3P5bY65s7aGYrnsmpD3Sva8A7dSV/GsypMnKIlMCYAasnCXMsxJ8e2iwM/exeLkVZpKoAoPo+rgbxf3/N7s38uKPT+qdfTpgtEObMVQI1ZfQOcBdp8LC4PQibbyJfQuk1MqxAqbRgnOZkCrVgU5yRkPNnOmkRIPORL/sJk+CgdQwl1VKLYnTCzC+Xoc/dJ6vugm9v7l8ykxDpg42fOM6RwrNu3ShG1md0x6iH+PVO/9JlYMxRxPzumMF+cPyY7oawI2IPAH88I/tL0NuEbAnt4YIuEc5JNfRKWYRcFnyW3eVRl3khlCtjZvAZipOj+qDJSVDf3x/C0MKEq1y1QCBUze3GodM4yRp+ZgqXRoggiTPKqtJEwrigDJJyorBuSYgqHvuXqc4ML5TuAxu1k3EHYn2Vj9bHduaK0mAMg5sllMtdKYMDokNKmOJNNGyszgCVa0JeQkjZgMjr7MrLOI9YpQaVEEgwbZPSOYZ0P
 OS/QWZ+w
 CZl9EdMuTWQXPpHVHCfDhG5KsHVOEAWHoS533fIRvEVFf6k9bYCXwkGjrmdziosy8A3jg+PRmlzVlv+Rdwmw6S5RPYh6UvDhTDdcQ4wQkNLpa2LSx7EDSAmwSzWCNfwpw+2XNCrVDCgbGQQxqS9rxD+P8h8JARc0/IARV8CZhupNlAkArj5ZOVjuO7FBkjMVhxpvT5ZRY5KFUlnLf4MpWZoSo+YgFd9k0JLdL0b55fanlznRLtx43lUhM47rgnFm2o7RU5+KS/bPeSe+JiVr3KkYAMuYDiVnEyUHm7z06eyTAwyZA0PFcyqL+kz88UnsD78EdA56GFMgq+Qi099wbrLXkGX1tcPha4a/uZlPw2wcpqRz9S4Al971gfvUoBFvE7itxaxY4RWk9D72MMbKRAAbwP9tSSeJ4AleojKDtmFr3EmoMn7tijKSJrrNd8PZP8AO/ksjwWyOO9mM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_WRITEPROTECT and PAGEMAP_SCAN with PM_SCAN_WP_MATCHING do not
write-protect an entry that holds a guard marker. change_softleaf_pte()
ignores guard markers, and make_uffd_wp_pte() only sets the swap uffd
bit on the marker PTE, which guard removal clears along with the marker.

On a file-backed VMA, the page is still in the page cache once the guard
is removed. It faults back in writable, and writes to it are not
reported.

To fix it, set the uffd-wp bit on a guard marker of a file-backed VMA in
both paths. A guard marker can carry that bit, and guard removal then
keeps the write protection by leaving a uffd-wp marker in its place.

Move is_guard_pte_marker() to leafops.h as pte_is_guard_marker(), next
to pte_is_uffd_wp_marker(), so that make_uffd_wp_pte() can use it.

A page that is write-protected while a guard is in place is now still
write-protected after the guard is removed.

Anonymous memory is left as it is. With UFFD_FEATURE_WP_UNPOPULATED, an
entry that is write-protected while a guard is in place is still
unprotected after the guard is removed.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c      |  7 +++++++
 include/linux/leafops.h | 14 ++++++++++++++
 mm/madvise.c            | 11 ++---------
 mm/mprotect.c           |  5 ++++-
 4 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 752f1b13d47a..7b1c843a4fd0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2439,6 +2439,13 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 	} else if (pte_none(ptent)) {
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
+	} else if (!vma_is_anonymous(vma) && pte_is_guard_marker(ptent)) {
+		/* Keep the protection in the marker, as mprotect does. */
+		const softleaf_t entry = softleaf_from_pte(ptent);
+
+		set_pte_at(vma->vm_mm, addr, pte,
+			   make_pte_marker(softleaf_to_marker(entry) |
+					   PTE_MARKER_UFFD_WP));
 	} else {
 		ptent = set_uffd_wp_swp_pte(ptent);
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index add4968ded44..831b85a184c4 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -547,6 +547,20 @@ static inline bool pte_is_marker(pte_t pte)
 	return softleaf_is_marker(softleaf_from_pte(pte));
 }
 
+/**
+ * pte_is_guard_marker() - Does this PTE entry encode a guard region marker
+ * leaf entry?
+ * @pte: PTE entry.
+ *
+ * Returns: true if this PTE is a guard marker leaf entry, otherwise false.
+ */
+static inline bool pte_is_guard_marker(pte_t pte)
+{
+	const softleaf_t entry = softleaf_from_pte(pte);
+
+	return softleaf_is_guard_marker(entry);
+}
+
 /**
  * pte_is_uffd_wp_marker() - Does this PTE entry encode a userfaultfd write
  * protect marker leaf entry?
diff --git a/mm/madvise.c b/mm/madvise.c
index e2c6b0f26672..e8b05dc899f1 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1085,13 +1085,6 @@ static bool is_valid_guard_vma(const struct vm_area_struct *vma,
 	return true;
 }
 
-static bool is_guard_pte_marker(pte_t ptent)
-{
-	const softleaf_t entry = softleaf_from_pte(ptent);
-
-	return softleaf_is_guard_marker(entry);
-}
-
 static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
 				   unsigned long next, struct mm_walk *walk)
 {
@@ -1117,7 +1110,7 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
 	unsigned long *nr_pages = (unsigned long *)walk->private;
 
 	/* If there is already a guard page marker, we have nothing to do. */
-	if (is_guard_pte_marker(pteval)) {
+	if (pte_is_guard_marker(pteval)) {
 		(*nr_pages)++;
 
 		return 0;
@@ -1275,7 +1268,7 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 {
 	pte_t ptent = ptep_get(pte);
 
-	if (is_guard_pte_marker(ptent)) {
+	if (pte_is_guard_marker(ptent)) {
 		const softleaf_t entry = softleaf_from_pte(ptent);
 		const pte_marker marker = softleaf_to_marker(entry) &
 					  ~PTE_MARKER_GUARD;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6cc5b99b4185..3f2d6e3aca93 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -261,7 +261,10 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 			const pte_marker old = softleaf_to_marker(entry);
 			pte_marker marker = old;
 
-			if (uffd_prot_resolve)
+			if ((cp_flags & MM_CP_UFFD_WP) &&
+			    !vma_is_anonymous(vma))
+				marker |= PTE_MARKER_UFFD_WP;
+			else if (uffd_prot_resolve)
 				marker &= ~PTE_MARKER_UFFD_WP;
 
 			if (marker == old)

-- 
2.39.5


