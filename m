Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0BA606A883
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ozZsnQja;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Hv9wbNtf
Received: by kanga.kvack.org (Postfix)
	id 6DB4B6B05CC; Wed, 11 Nov 2026 12:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666086B05CD; Wed, 11 Nov 2026 12:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C626B05CE; Wed, 11 Nov 2026 12:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 26B556B05CC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD9461A03C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:04 +0000 (UTC)
X-FDA: 85423591848.16.1C014F0
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39B1A1C000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ozZsnQja;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Hv9wbNtf;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419762;
	b=jl6iUuj7m2W/prr3SLZTgTg2BDZFfga1XI034M/in5vdS8RHrE4d6WfzNp+27NGaIoma7+
	QcLEd1NNoYleVK+50WziifTtBfMqalU4LiOBNnb0pAjFP/ftuui+EJ0qXnhM7ViO6aFOkR
	kv2ICogh5cATwByCw/7P1RZwHm0UHL0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ozZsnQja;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Hv9wbNtf;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLh94H+uowZr10Df0hSuV88QMtwxibroooekC03x3n4=;
	b=vSWa8GrNL04HQHfNKTgvipUsYNhHbMrSquWBEenLIz+7z//WlaXyarrN6QMfdQe+OxcZjU
	eyerKD7muUH3b1HEIhH4vK4xG+wHIRbou0Moxdqk7aNEMwLAl1yjJLJPS1+r3ptkFHw6+0
	QqYj6cInUxzPI1yPfWh2Q9/XvfpSRG8=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYG72825555
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rLh9
	4H+uowZr10Df0hSuV88QMtwxibroooekC03x3n4=; b=ozZsnQjaNao2IqvZc6Rp
	p6roRzoRRGYKiG5ov5adX69nBBasWdEBDyp0z0QyW3Dp/b3FaDI9jOFWyzJ7L5lQ
	kxUYD+50KoCWnx1pGiUz3eRe+M5/mXchhVX4ubsbfNylzlcFwWl+mD6Eif42+mRF
	rKdRROP+hw0tztBTXHYMZX6Jpe3gMYBvddxoLc1Kkt+xFNw68pI7CNvwEjdbAFW/
	Du6hbii6NLqESVcxNhy+YFzC9JFj/f3mtis+dqrI+tDhoQLu92QKRKICrg3iMEWI
	H+gXgL1kR6iomPk3qpMmkE0HN8uaQHtiJV3D1vTihkcrm7Ig9CPKP0pODnHTmLn3
	CQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvvaqrhge-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:01 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-542fc61841eso72320701cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419760; x=1795024560; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rLh94H+uowZr10Df0hSuV88QMtwxibroooekC03x3n4=;
        b=Hv9wbNtfXPOVVmadlxCsei2oi5MbG3d33Ccgl+DQUBgSPWjGo4Mn+MbBp9wF3VZXNy
         vOFhQyIb7txtP6DQGfn55rRDuCcP6OAlJx2F+3zv87kd6A6mIhfARWjf8Smeg/pU3oJ8
         QugJue0XHxMQIBokOrhfL1RlaGuf/FAieKhJP2gZ8cN5yjLTPzEopgOOIzWfoa+JEiW0
         a8bDs0c0E1Mpi8mbmECJjZ4gOBn3zMGIcrLD6wNic60LDbjOHPupqjoGymIGkbFCZWAv
         Ir0Rus11eF5WkHzzSEzL5DEWKDgtrRGCt8+Up0KVT6O+CmfnEajIINKW+wNjUWKbNT4W
         YH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419760; x=1795024560;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rLh94H+uowZr10Df0hSuV88QMtwxibroooekC03x3n4=;
        b=gvJFIvrDFMJ90dqxtScgIw1aC+Y1cOkM6mtwrppDof+cu5rguVgdzsyy0fMQN8OJGo
         cBkvefQrjvJoIIbwvP3j98/Q3Irvtw4ofDPOcMwdcDXZC+SySJCO2OCidZCU5s320KYM
         wUhVLmsRe1DQqf+Apol/CD/+BQ/4jKfNR9B974dB06r0Pn9hFUBElJEaD0vCrQhNq5fm
         mXsDTDe+4Zb85vNDrUymnSx+KmmLcpi/MbPXcn7+kNnm4DDCKjLZfCgd1RVsHhhLoyhk
         XtvWlyJpLr7ljHrouHc6CypfrMlx9+3wMyaLRBYHcMdzO495DH3R644zIfKQpFvb4YKV
         Anig==
X-Gm-Message-State: APuU4Z9r20fdcAIUJLN1ubRHxnU3zolJphQxod+W+U2vqRScgP2X22Tz
	/3pGqHfDF9t/ndVV9lmpWOuU7MXLm6xw/moLP5jpd0KUMW7zLpM6/qMzBDRS6U7JrffGu3EogNL
	lliSJE4azSW0uS9nKvK/Wxe7hNLWNLS8sgubxQjCuoN0bs0qc
X-Gm-Gg: AYBFou2YY44lVx/+ot5qegGV26Pu1lzkZ+KuESs8wVtbA8gKd7EAymKpbgpwICZXawS
	a5VbuigAUujBnAikcegKmTmHrUHSGyC9NJFCeK1RRNJOUa6jsb6U7PmrVOzKCQQlOY4J8hfsifk
	5BuGCttoI6rtQH0QbDQA/e/sm7WBtKlbPoCokbegE2VLDIJDe6duUSCqWGw1BkBNfJZVBJ816YW
	zw7/wu/HdScKbHkfZ/uiTr4dAZ55ZehKJw429IWCnCf8BeTA3S0UE4YAE6Qu/7MFNk0IqDNo5BI
	RFLt8dzV8j+nV6S88dnCqLgyOcEmTz+q5kcDwFhDCdB/CwK7Tyi1lFXMk0cpkJ5vAfiXXUoEKtE
	D8n6BLQy81UMeG2EDmXzOTmDSvZtcVUkUzP7JHT8yKt0w9vRlN9uneh6u3QjIlB417i0Eskowas
	0+FFWUcjjkMBoWo+P3XQ==
X-Received: by 2002:a05:622a:1651:b0:537:dea7:adb1 with SMTP id d75a77b69052e-556bdce0a89mr46732711cf.4.1794419760664;
        Wed, 11 Nov 2026 09:56:00 -0800 (PST)
X-Received: by 2002:a05:622a:1651:b0:537:dea7:adb1 with SMTP id d75a77b69052e-556bdce0a89mr46732341cf.4.1794419760108;
        Wed, 11 Nov 2026 09:56:00 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:59 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:13 -0500
Subject: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private THPs
 in PAGEMAP_SCAN
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=1653;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=NMR1mZVf/ZZ1dsMSsUl85Q0wvIFNRvQkQz1f9feUbD0=;
 b=BLkWdBWcFR7ZCJE0naCht5rRXOwRZShjmmEWgb1C0a0/hRfETNoET5Qey8Nyu32VSu0C6gbxs
 gyF1eLl4PuWDGJEVmtlYVSl2O7uJ3n3l7j1NMSpNDb9jBfiLHhcZYAw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: CT1xesRD94ocKP8z-W-BHKd0Wz6MpEfK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX+oNvyCUvWW8T
 ijJfYOa3ElSEbm23lXTjv+v/C/VRnbKUn3JopPSqf3ZxAPCEfQZZreWv9lVqwrS+ZqMqePe3BCK
 bs4ktUVXOwqEGhYoKEb9FQnFm2ndvF5MvwcK/YzLE0nM4aOok5Lt
X-Proofpoint-ORIG-GUID: CT1xesRD94ocKP8z-W-BHKd0Wz6MpEfK
X-Authority-Analysis: v=2.4 cv=dqFOmFg4 c=1 sm=1 tr=0 ts=6af4ac31 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=RyLRxA_qM0uo8G8YelwA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX8UG27hRq6Zk1
 YLP3tEvqUW0w7EYKoIqclqN63HZh7CXa3Xps+BjxJXo80HOQ/+RYTrcW4ey9KBJlRRLOpWfafUY
 Hahdh9CX3smCsnUiqSFg7m/YcVTgJhqVHCeuij3MKlprxbk2OCZMZ65bC0Agyp7TRnGYvEW7ue2
 B6V4wcvOJZI+EqpQJNgIeTRdSR/vZirKV4vEGE4gGCDC0QSFYG+6YKS5oDOxR6PStGeqx6r2KPQ
 /LA4kMTQnC++nFSXFY3Tpa/LH9Ovrc9nVLEbFxHFGPDK1z5Bp4+PUdTX8Fq98r2aNZVfHdvlNPK
 KIlRrvKnIdOJ2Mi7CCZvDyS/UsJivvOuU4rU/4i/L15gQM4X5zzfftMgNNzaBWyrHXtsehBplp1
 41VMtH87JnuP2Wi9q2iln10sY9jR9LeISp75wtX0gD1aKiU/7QIjIl5v/uR2ifQHhCPxXb8x12X
 TJxX2pnhD1Eqna7T40w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=10
 clxscore=1015 lowpriorityscore=10 impostorscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Stat-Signature: 43tfjoz34mnba5b61iaduzzigfniotoi
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 39B1A1C000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419762-904463
X-HE-Meta: U2FsdGVkX1+lU/XdWQypuLr5+hVJjE6nRKizVbKSwVzIJ6QR5USxPzAymSVLv+iJci8Of/m478EiuPEpT5X5Hb5q90TN3vy/FQQXe5mG+JFrRFCWf+zreIXxv6WqSYKCHD6z4RIRhnXxuDYt003okYO/BkD0yYZ/gUrrO/VHr4YRG0Poa6xywZim+RuCUiS3dywnglgYGy4QdQcmrJDl1jo0nwXYb04U3HfOvvHjOhcY1ctRX3XTegdhb2/bZSDwpMXeyv+4JfjYMsZw0qHkZ0ciPBpISyK6iJ7pM2LM3BXlAw/N8vd2etFKWXnakryEXx2d15qI3XTU2dPakU576JDn3qIx8zXdLUBpmzLPF6z4AREnEaMuMut1ENQLTyvvwl8pxr9SjtxdwKgohhk/sOz7k23H9xgdltRldUEI/i0LcvoCnHRUTyh5TXjWrEc5lcDZpHOAzdTPz9JKxjBO2WZVgdIZgu8fbSiLEwRyFW8LD5LXFaLUorECmSDO0B85wJ58774XY9RH0y3DMV5LwK05rFPFnjImu7DKGUfHtI4LWYZ1vj9hf66RqThbl5oceDUhOD5E44b+T6mFyIgrFbKfX6vDVWcDVTDZV7x0BYnbn8aPZEBxeOxJ+u+vqUmv0n0X6rYXm08gC1UrbVbO3AGbdzz3UWol2Rz+6XSqqKdXTIvQzb7PQTYm6MfUxq4eWeGOr9KOB0oQ1oTUZzNqwOP//A5wO3TlOvwMICX0YJJrVVEfmWKwDY3GaM22+Q+4oFmzk9vfK3E/5nTck1Ai9rIzbrAWEvkgU80ioPUGn2yHnOpiTEYBofxQNe67a82Qb3WZqX1wogDMV75xo2x3+Z6o9mGubsTMNqdQlv64l5jattXVCE0ZC1oXoYdmPCGru2L42xW8qr3+x/Ubxu1Vwjrq633XbuGhgE7vsT111/V4K7tFBSo0obIPaj11ORy8ivifIprGm4MF1I4mc86
 NSpx/Ukj
 85qDyBrP5rn9Zkmn+KcBRjS8NfEa3WBSMDfbywioe7k+YGm0YJ0gf0d+IZ+66kTq0Qa4SypNZXJCiYw//yLgFnaqNGcn91dlVBSq2MKjKqwQaC5Wp1zAajA6GPCHpC5J2LHALkQefMzHAwd2QuaBbOmC6bpek3wyEWZ+F46UVSSzPl8bPal4OhTxcz2vrdMIdJWIEU97GUGY5IzGo0ZGzZDh7Od+MKXUILEQLrK+sbcWyD41pnO9BDAb9dgCBzOeasNy5F3Fiju2uxOuUVq08cu6viZZTCQAQibjBzXMoAi5Xh6sVTvUbkc9PSQ0Rt7S7mJiFKGxbWtpYHinKfUw6sSc46smz1IdeXFIupbu5VYSlVx3mns9b50LE+BbgpCS+Xhq55jFrn8NOaq1iROT4zd44AvWG8q08I527+e1GGX82gv3q+jPCm8fYBF/72EweeIxn8d1Wg1/kCBUzJnX2Fd+Lll2btA5BWzll/4jNeXu7kKNBBbFbZLITPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
make_uffd_wp_pmd(), which handles a present THP and a migration entry
but does nothing for a device-private THP. The PMD never gets the uffd
bit.

pagemap_thp_category() reports a non-present PMD without the uffd bit as
written. A user tracking writes with async uffd-wp therefore sees every
page of a device-private THP as written on every scan, whether it was
written to or not. This requires a driver that migrates THPs to device
memory.

A device-private PMD must be write-protected like any other huge PMD. To
fix it, pass it to set_uffd_wp_swp_pmd() as well, which downgrades a
writable entry and sets the uffd bit. When the THP migrates back,
set_pmd_migration_entry() carries the uffd bit over to the migration
entry, so the write protection is kept.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 53780a454432..752f1b13d47a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2524,7 +2524,8 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_migration_entry(pmd) ||
+		   pmd_is_device_private_entry(pmd)) {
 		pmd = set_uffd_wp_swp_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}

-- 
2.39.5


