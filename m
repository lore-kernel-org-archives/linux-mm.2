Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65696606A8BB
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=T4qiOUVq;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=kDDigErR
Received: by kanga.kvack.org (Postfix)
	id 88B6B6B05B2; Wed, 11 Nov 2026 12:55:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815516B05C7; Wed, 11 Nov 2026 12:55:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68FE86B05C8; Wed, 11 Nov 2026 12:55:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FD1E6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CED151A03C4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:58 +0000 (UTC)
X-FDA: 85423591596.20.934D87B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A49920007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=T4qiOUVq;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kDDigErR;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LvmOJZQBB7IFXQ4rWiGOm3EqZVi1Citt+WxZ2aQ6a20=;
	b=jhxUQO08aU2uDT/aNyLFair2YRnnTlxaN1tV9541xgBV8YcMY6Ir1Q74JtDqGeyyTnnpbT
	HQiIFrqOPZyKkck0gbX/aA4jiNwHx8Fc8xfmFXRB4BrVhv/w+fnuKw1l0780DIpW3/Rjvo
	tIJBXydGBSyl6b9RxPKI3kG2KFIHGOs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=T4qiOUVq;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=kDDigErR;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf03.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419756;
	b=z9+8oQsA5YoJSHx8NKrUgLzHNUw0P2hqMJiDMrDPWpEy2utO11bljVO0G5H2/qswtlcAf8
	dYcZAbfq1JjrWeLH22qKlHCDGUdV9Wy0P5FFKPYfTYWsScG7Vv9A5doqLHVwYSbe0Pms8P
	aEe12QfEjqGF7J1DAXL9hwvY+NMDkHs=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYFt53844932
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=LvmOJZQBB7IFXQ4rWiGOm3EqZV
	i1Citt+WxZ2aQ6a20=; b=T4qiOUVqH14cGGbnsTSJxS4tbddUBrhFmsLiPt+sYy
	eveWAhH+ZZRt1Zc9U4VkkGjt6JD8dbgQOWe7txZfaxAXGCvp4IWTVZEtjY2ui5QV
	Cz7apLFSbuqpYm86l8jC5gXpWWByv3rzgpnr2yodcXTs5QVg3EurmndxGMjGlRXm
	2vzYejk2gq6udQbxeQ1DdosGkSb96Xj1Bj7TvpIITitTAwk+GS2AY/+8CLPAVF4R
	i7lfZpPSkWWKD1wKguwZZfdKclL2xEVnsb2a5IpgvFoWinZfHUVHyqK/8W1Rx8/X
	s8GXFaM10U23XqBjlfPO6Suyg4yxF4X9cQZ08RvcfSjg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hvg4qmexc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:54 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53664602c7fso75584691cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419753; x=1795024553; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LvmOJZQBB7IFXQ4rWiGOm3EqZVi1Citt+WxZ2aQ6a20=;
        b=kDDigErRWxfJffYTnKDr+lBxCQIcddg35bfO9ZeN31l/BkDMUK0MFnU8nPXIZTMzb2
         t87ePUADT7u0VALnIkv8qyDLsGxn9UHUTFbKlFrZZJSUFmq1trrmA2X8VeLWP6TZxUBb
         AVZ/RxYFqaj9HxqhCh/vn2XWHKPXVVO11cz1koyfiJiaU60X7OTrqY2iMOnYJW7PJxRF
         Y4E5Dgdw4/g97Xq9+jjSXNHjN3joWFJ4n/h2kIXbltjQ+TaWHJBZms3BsMbpetEQtlPl
         H3/kzEBbOtcoX0wAdBIkvNV46t7T6mOzItGn+PjsNgUAQbqYMCOBCiWlPcecB9wvTnLG
         erGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419753; x=1795024553;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LvmOJZQBB7IFXQ4rWiGOm3EqZVi1Citt+WxZ2aQ6a20=;
        b=o2nmmm0wlWAENKs7oDPd2q32Ll0tRFHPtgxuE3T32rJl958ukZpTPWcNSlIxOl6W5B
         TarDJLmJGn82Z2Clgzg+uwhSXGHnqek3TfsoBYf5b5WAOaDw2gzxblUl6BGRgX8j8OYO
         Kq69PCJWLoqr46cbdiJVze3To6J1AhwRQU+FCe8n82CzFdO7KoeR7J7C7fMcM87HG8uV
         0VrK7gWZHmysK9lyWAqnmHU+aaKNuhtRQ4PUGqNPY2jCEGwj9IHF6rDO1JBZat5JN9ek
         GPF4TJaPlOPXyyxvqX7ngjBhN15diw0s6Yb1Ari2aVC0wiBcMBFRDtyf8KKwxFfdJWb3
         J2QA==
X-Gm-Message-State: APuU4Z/oLy+DY57IC2Zm+mADyecyTp6lUn95ASeV64085ex4fz+m2tyH
	Q//kfhmX/ItI/CxEc/r3Mh5IV7xEU5x3nQI9JnA3XdpwJmRn4ultIb2KXEcNFuOvw47rHuLvwAw
	q9y9noLnR+C80dsv7JeGRQYmRPb/bOM4Ui90WNkYVgyw/X7d6
X-Gm-Gg: AYBFou3ZO9up/esTVVbu8H0m1w3OdvLImvAPgJYMUCHdOYmTvjeeT9LnjiH+p+zIzmV
	diLvc1p0wiCIv1wYfnwbMoP2tWdErnSFhgpJdUxJTqNsXtBoPyoS9QygfLbvdjrfJQDeUgEBYYs
	6OJXaVlCHXPbV2v+F3RPcQpLRU+okwzhERGl/56ilM0QQFvZLzy9jHalYcoJ++b6S6E/rHXN9Ne
	I6CzRIdIum7eiqyc/LYi0Q2M6CnSPVTYd4lF+RRELDXA0gXHEiZiXifsppmCBza55F5wifVF3Vc
	IAUiYQ6QDUVLEin5L9k5UytH1W5992blDgY5lhCn/BXs3bgl+JmvwRC/uPq0AqcojgxDGUSK+aa
	egmwhgTMAT8aPPmOM8JU7fkLB9+EWRLe60PCE5l2YKW+PsBqDl/9y0u+5j/Pc3OJboKPUlqhNKY
	egxRoxoZ6xEsOe46Uq4Q==
X-Received: by 2002:ac8:5f4f:0:b0:536:6856:f590 with SMTP id d75a77b69052e-556bfc28a79mr49069481cf.18.1794419753278;
        Wed, 11 Nov 2026 09:55:53 -0800 (PST)
X-Received: by 2002:ac8:5f4f:0:b0:536:6856:f590 with SMTP id d75a77b69052e-556bfc28a79mr49069031cf.18.1794419752787;
        Wed, 11 Nov 2026 09:55:52 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:52 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 00/12] userfaultfd: assorted fixes (part 1)
Date: Wed, 11 Nov 2026 12:55:08 -0500
Message-Id: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPyr9GoC/yXMwQqDMBCE4VeRPXfBDUWkryI9RDPR7UFLNhZBf
 PdGPX4M/+xkSAqjV7VTwk9Nl7lAHhUNk59HsIZicrVrROqG1xgDW/YZHHWDcXAiAuf78GypZN+
 EayhV975ta//BkM8fOo4/Jw+9OHQAAAA=
X-Change-ID: 20261106-uffd-state-fixes-d2111e2abd48
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
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=3924;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=cHZMnkuvxuVsum5IPSVBD2Hn2T2KOpeSqPFMnmKTxDE=;
 b=PkxX+j2NoQYADfdFn1SMpbWDsHba3k2jAxsod8ceDHDYyebLuzyuWYyJoweea/Y/WhGIgizjc
 tc/IiVb91ndBzMIK+oPCx5sSZLBqMlOolvppMeZlGQp/vadBlj2yIzh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX9n6TUdA/TX+2
 k10+6/aYuKsUr+YMaATE9q8/KuZd49UZMBWddXpMKro2nC6N04AwuhF5nFG3LLhgyVeH1Xp297e
 xsBOyZGUGwN2akC4IJeJi3Wb0BhGXsfIkLB/4aSTVXLpa1BC8Cj1uHpulhkvlnzyQ+U62mT3hHC
 J+j1cpVMg5R0mexO8btNHqibpoeOBGA1rqMW6B+ULv4OUPqHje3A62H+ND72Ejqs3xGWuH+6yQP
 AEgwB5iAARXFl4kr30CEfQ0oi3AO6bTT4zYoyhIYxWxcAxZNJpXMPp7euB3y6PC7E2+B0lUvHez
 WjMiFVtBSRBQcBiTaVh2aMnqHW9KGfSKFCFWwYGjATlkVXo970+fxqyCIlBhGvCNpxkzCHjzXlo
 dtXZiSuoWRzbFVfgybgOUmC30KpRDTsoXEZEj8ddqwAyNOSd08djzX5nSvNfid6TAEwAqNDZgxZ
 SVDcmQN9DZH5N0AlrRw==
X-Authority-Analysis: v=2.4 cv=fodJ914f c=1 sm=1 tr=0 ts=6af4ac2a cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=ctVpGLEqiRcwzRHSUTwA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX0UN5XQz1IHEu
 RXUhieIevU8LAHM0Axh/CaGg2di5AL/YerWTGf3imDMoQNrPWxDL0cQoWKO67XWjGXYUaADf53T
 HBYdbfRsHR5FzmokiV3nXYivRdlf9Ot6NHoyV6sFP7Bw5HdmIBh4
X-Proofpoint-GUID: zr-jYVa84CXGUqctU3POFsKKhHu8AO4B
X-Proofpoint-ORIG-GUID: zr-jYVa84CXGUqctU3POFsKKhHu8AO4B
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=10 clxscore=1015 priorityscore=1501
 lowpriorityscore=10 malwarescore=0 spamscore=0 bulkscore=10 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A49920007
X-Stat-Signature: pigfay7d87s7ii4thpcsw15j63e44ds7
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794419755-392238
X-HE-Meta: U2FsdGVkX1+ifwyKx9z0ekD/JtHMIBEF0kK4gO2afaMpaKhDiLqRVgkCtbKkgzjtfo4pA1hOw2whziuFvVtDnzIGVXmqUKeK/lJQ99/DgZQUlkfU0zQ3L8f+yAWi0XqXMoFgy4Ke5HB4k/yOgWoOYMjGKYm2UdMPwuGmqhoHr2YnNSQODFZYhzFjJ6AYhi7Ql1u55Q/a3b1KCG3o33ve/TSakHCWIEAulexlOMeXG7wPJj2D6vHIwEHxbPcEYmSrvofg5jtf8pfyd/TqJyiLnIwb/6n6fpQXC2uSuUAJsISiStJx/Z1eCKxsGlwqFx8AJrMTx75IGsBQgAp2EflZ86gOcz1MrYKoJsgu7VJc5K9CVzWB4IjsMKT3Z1fKLXtGg3T8bjnio0MhfyjV6s0NoUuyAu0IcAqyLzh0ZD/CQh/julSzX9hAW98guO6yyCSdPvjwODuh8NZowxV7aDhUMoMgUnONVW2+5IhJ0i8trjgAa7LSeIC9vjNy37LCyx77QnpnfjU+hwbPtydTqqcjq5twS9FAeml3yLmc19sQ7iZ9dY28Xiw9gA4428HC0Qg7n3y0pamPe0IYI2/I5HGnYibMQFkLdkI6qKqFoQtmKm6OvPCtFRHxNy8+ACTI47EO1vZwJQ+0q/26si1puss/FwURqD1+co8aPb5rDQqcu59OFDeIaYOgQK1cKiGOifz5dXjksA9hiYHXVWAVEuqzMoHk+XapZyBNdHHMmR71COS48c4MqYTlu4fXotbcIC+SVEwsNYyNlLvGn/8GqvFMgUMNmL6+Sf1CFicpXwuVi5ADGuqoFAVEvTYHk4Q7ADbWht5rqaJPZZ1pltQ7S+Rr5aUl3qK/odO76yRb53ou2r9/6abDbsHKWFKPDVS1A8Ry63p9xSzVIL23GgDamia6RIDc1icLC+fh3neoI0G7iv9zmNYTanjKPO6gbIzKBGJdU0KkH+/Jh6lNtP+9i9/
 HoGeqpXG
 TJkfNzR8mC6GDJ9ghASzTj7CfxW0J283iJzijUgYN01WCK7hEIAxAyLKYFJE6CoU/gnWBypR6sf7tMmLT/1zT0vOFGO+pkPJec6D15oZp35CErYSZJ7GLV1Qnp7nxymrWOMoOqZ3gUCL5AbQY8mbilEB5B79YP+4DihZMDx3ULp7IVxE92yIhVF+tH6CHxx0wtcbIH2DkqjHTq7mIAHxYBhfEf42LtRduPqTfX8UfnXdxfHTDUNiV8ACt898iB/714VNCo2WPV+DGv2Cks7jVaqtMkwsV0ffSj6XxXua8UnAl3Xp9QP74kJS5eUf6csbEjeEfgDaBMw5q868COFgVE1f/qdQVoJitaiUIvDLh13865BExW+6y5RtNXM3tarbLwyccrOleXbDvBOBf86D+pbbPncBQy2xBU3JLRjRNE7XPt51e4O0Eo+0V8ptQqAckIARL9NWYzsAKeGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a first batch of userfaultfd fixes, with more to come.

These were found by a mix of regular old LLM review and by having an LLM
write a TLA+ model of uffd interactions with PTE bits and other state
and seeing what issues fell out.

Most of these fix places where mm code loses uffd-wp or RWP protection
while moving, migrating or zapping an entry. Userspace then either
misses writes and accesses, or gets pages reported that nobody touched.
There are also two hangs (UFFDIO_MOVE and MADV_GUARD_INSTALL), and
UFFDIO_ZEROPAGE modifying a file through a private mapping.

Patches 1-2:   UFFDIO_ZEROPAGE and UFFDIO_MOVE fixes, cc stable
Patches 3-5:   PAGEMAP_SCAN write-protect vs. migration and
               device-private entries
Patch 6:       UFFDIO_MOVE of the huge zero page from an RWP source
Patch 7:       mremap() losing uffd state when a move fails halfway
Patch 8:       migrate_vma replacing a uffd-protected zero page
Patches 9-11:  guard regions vs. uffd-wp
Patch 12:      UFFDIO_UNREGISTER with a misaligned hugetlb end

A few of the fixes change what userspace sees:

 - UFFDIO_ZEROPAGE on a private file mapping no longer fails with
   -EEXIST where the file already has a page, on an mm that cannot use
   the zero page (patch 1)
 - UFFDIO_MOVE returns -EEXIST for any huge destination PMD, not only
   for a present THP (patch 2)
 - MADV_GUARD_INSTALL sends UFFD_EVENT_REMOVE, and can return -ENOMEM
   or -EINVAL if the VMA goes away or changes while the lock is dropped
   (patch 11)
 - UFFDIO_UNREGISTER with a misaligned hugetlb end fails before
   unregistering anything (patch 12)

Patch 6 has little user impact on its own. It is included because,
together with patch 7, it allows removing clear_uffd_wp_pmd().

Patch 7 adds spurious minor faults on shmem and hugetlb after mremap():
when dropping uffd protection there, change_protection() makes writable
pages that were never protected read-only. UFFDIO_UNREGISTER and
UFFDIO_WRITEPROTECT already behave this way and lead to the same
spurious faults. This will be fixed in change_protection() in a separate
series.

Based on mm-new.

---
Tal Zussman (12):
      userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
      userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
      fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
      mm/migrate: keep the uffd bit when restoring a writable migration entry
      fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
      mm/huge_memory: build the moved huge zero PMD from the destination VMA
      mm/mremap: resolve uffd state when the context is dropped, not during the move
      mm/migrate_device: do not migrate a uffd-protected zero page
      mm/madvise: let a guard marker carry the uffd-wp bit
      mm: set the uffd-wp bit on a guard marker when write-protecting
      mm/madvise: send UFFD_EVENT_REMOVE when installing guard regions
      mm/userfaultfd: check hugetlb end alignment in UFFDIO_UNREGISTER pre-scan

 fs/proc/task_mmu.c      | 64 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/leafops.h | 18 +++++++++++++
 mm/huge_memory.c        | 31 +++-------------------
 mm/hugetlb.c            | 27 +------------------
 mm/madvise.c            | 62 +++++++++++++++++++++++++++++++++++--------
 mm/migrate.c            |  2 +-
 mm/migrate_device.c     | 23 ++++++++++++++--
 mm/mprotect.c           | 26 ++++++++++++++++--
 mm/mremap.c             | 46 +-------------------------------
 mm/userfaultfd.c        | 70 ++++++++++++++++++++++++-------------------------
 10 files changed, 215 insertions(+), 154 deletions(-)
---
base-commit: 2dc0136b1fdac153434ab02778fcdb32db5d0dae
change-id: 20261106-uffd-state-fixes-d2111e2abd48

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


