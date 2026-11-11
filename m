Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3EFA606A338
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=nL1QA79v;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=2WiX7ibV
Received: by kanga.kvack.org (Postfix)
	id AFB316B05C7; Wed, 11 Nov 2026 12:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAB476B05C8; Wed, 11 Nov 2026 12:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94BDA6B05C9; Wed, 11 Nov 2026 12:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 645196B05C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02322A7C26
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:59 +0000 (UTC)
X-FDA: 85423591680.07.8352469
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6898A80004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nL1QA79v;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2WiX7ibV;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deCzxOFeDCQXgKxHB3hOal3UgkmEGxjDuW74KEugHoU=;
	b=0Y+uag38XNoNA8WhEpinfP5y/8eMzhjoHlODe9gLid89VK1HHB/4i1wCKRE13CqXTR/zzr
	16TeNJ9UZTUjV5Fo/4QDUhCDPm4RLA8LgI11MaeMHsalsa2qEGZW0K9eod4sXgHzrvROAM
	zbzF9DRIraRFWIPWkRlN3WVO2OU1g7k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419757;
	b=ZL0S7U2X3UxdnbFNmHduOPG+aJR9we7YvGjRv8NghxBlV6VIcN8T+LQ11D4dVIPpyAlqev
	WhzQMljO42K/HSk4S/o2VGS63Ad0rwaGpY8cc+jM7mKcRawJcoU9c8I9qFGptCPXlSuSJu
	S2/lHI3vVkMs89E9Gra2REpKEdE3wyg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=nL1QA79v;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=2WiX7ibV;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYY1H135676
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=deCz
	xOFeDCQXgKxHB3hOal3UgkmEGxjDuW74KEugHoU=; b=nL1QA79vIxrk1LgRXl1R
	ipAVXpxa26rNAPdRIHB2IMbb1SbgNxZNxC6+K43RVctvACGgXZ9c/sMH0lHNFgoA
	NUbS4vXonzDqYheWBIi2VsAKB02Siim+bORzdo4O0M5R8/5InB4F8/SSfIFg87+7
	eLLBRyWqs+PiYQPhiovxSeEg4g5MM5YSJ76W2DC9A9b8I5E0i3L3raNk4nu7TUSW
	QGje/p67Ob49L6nWEu5f88d+wHJyf+pEQqyK2S9TpDoyMMjUaPl06rVA/reQ5GOw
	1kLoNnQWh+PPE13TgFJt1BPQB9NvkEXaiUU6KSu/MmojvRAlqAZV/8IZXws0+NEk
	pA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hvtu5sfwk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:55 -0500 (EST)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5339739b343so69252191cf.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419755; x=1795024555; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=deCzxOFeDCQXgKxHB3hOal3UgkmEGxjDuW74KEugHoU=;
        b=2WiX7ibV8IXLircb7sRG60FNnSWCeZcpHqQQ2ynVmwv1bavTGo0MA9t/tk45Z/cy2O
         kAjcT/hWrKf4XONkejy8rKHgPPvM08365zb3NZ0OPNCLrlVi7muhgZyh9Z6omt6cR5Tp
         fmLEkoxvghOVSwFeswVAeVe0RDYxezev29U+iNVDU6Ptx7ZMNJZPt/LC3Ul6hV3sANzc
         TeaxQIQ0BWB9tpOLPBiyspUaA26Ji87FODzwfo0zOd4StVHSB9UCTpTZk+3/kdJih3Gm
         HKf2toW1vqX11EUatql7C5ir4zq8aMJOguJ0oqoznPWCL6gfuWoJ/3F73PENC4r2mocf
         NGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419755; x=1795024555;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=deCzxOFeDCQXgKxHB3hOal3UgkmEGxjDuW74KEugHoU=;
        b=D20EGp2BhwFYVtu7gz22iusvnu0iUaeliRJmRxP2acYa2Q+Q2O2awQWA0LW+ScHlSR
         4QixeRCRKtqkAGPhnn8gJfLrYTBPX6zUfSXMQnBSAv5d8/PrscJL24Hnf72kk2D6SdFT
         l2domVTMPk93p7/mwrvOwuhyWNfpRcJ89A14oXnysonSsf35JhktzkL78SIv1wt/09GB
         TtY2SP/40YqGjeu4xP9gliCLvoWxf7Q0ag76LBFvH8UBzGaoYQhPqW5EC7QOJ0VsYeIg
         38NVA8IsNx1fP6S7hEu8dVsbtKMJGCRf3dkxQTUwoZOuZUJbWqz94uPDGpK3GJpNfWAG
         8bEA==
X-Gm-Message-State: APuU4Z8jimuqfGpHNltH0XDz33guxdsp6EJwxJPG6iHNoRk8/ca+oc1f
	TM4g7OHfETVy/aJkaMPL0gfZBsOMa/joLM0u9VsvmpFOxNi+e6+uC4YZL4dXqi0X0cEbsuxPQP2
	nV6DEVWuWuK0J7pQXKcPsVwclMjVFrCNwxObKCTKMPxzunY56
X-Gm-Gg: AYBFou2K9L9hTlr8OTRALI4boC6nnG1QC7k5qjklLgeXunY/mf8bp5PLEFaygX8kWF0
	nk3HipMCnLqW7S4B84lrvz7Q1EMJslPY86RfBdH9DBs6x2aGQwFgPn6YGQP9jzLqlz0t1oLO1bB
	zdnavAqxpYzwxxrFgfd+Kk4B2zqsISPzCdNHUMBAL7XuZoRcdt3R4gyYF+F0SGSoY3YGbmkh8Gb
	B5NKJ/j6VN3lCqnhCGWcnLrbA+ikxda5T9z3J/+znBcrLDVkM1UCBpkDEDSLAcVaMdez/ibaP/O
	as6mAdjR+JTWTrnT/h+fZJ5qDX12Y6QZ8IviegbP0chRnaTDtUbzZgIzKFHY9DMmKqR8Afpz4a6
	RPmgH2lOlAHfqr7a8MOZijtN7ak5RxQk0flv83wpgjS3Se1pyRX/jUh1xJxvJ2xL5/lsWZgGijS
	lhjuIph6GXf0/VEbsq+Q==
X-Received: by 2002:a05:622a:4c6:b0:551:ad99:3df0 with SMTP id d75a77b69052e-556c1a5e3f7mr48808121cf.71.1794419754911;
        Wed, 11 Nov 2026 09:55:54 -0800 (PST)
X-Received: by 2002:a05:622a:4c6:b0:551:ad99:3df0 with SMTP id d75a77b69052e-556c1a5e3f7mr48807671cf.71.1794419754264;
        Wed, 11 Nov 2026 09:55:54 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:53 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:09 -0500
Subject: [PATCH 01/12] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-1-00713d368976@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=5307;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=ZGzqhLx0gH//2ZFXY5DcwHUNOIJoLDbuuIlcIz+dT4o=;
 b=eBI5XdW7u+jazsrmWEO2BTjYrlgooAZbQFoFI5BxfJc84/TDMCva259mt44pi4Q3MmInVwbC8
 Gp0p0OSeiIXAPfpI5jclFrZpIzdZfkcquSiZQb7hr/WMWAWNQXKUChK
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX2gBW/a/Xqq9C
 KqkfozLVe3TtxUajaTed5BgfikqAsWVXkJHqCWbOkdlXZCUmmJXwUPeWYRY6Hf4V4unxBmuaSqV
 vufu4eMuzgtqbvgzp3WWbUxGJ1ElWNFvFayZBNkmTYBhPfu7vZlOVToow+1RXmdCzEfhfAIHtv0
 GYl8uYpKvqjGhjIRh0TP5qpw2Ohh7h8TS8KgCwXHKMPZ7b/eBksps0SGN55TRYYQQcUvS1vMkR5
 V8XLBbkwbV0PY5u4QlgveoD5ec2QASe5POX6G7yuzlQPBh/yisZrVghBqEQHwsL37kp1l0jccE4
 LJrLWeRYJ/ta81HHmUPkIky3WPAJ6rCBX6UHAov40mLW19iu+BXCgE1IGVOzh5R5ranwWDUUF/A
 qtR7I64o6RrWlUxiN819LzhUjDdXzF9AoIfldIYSS9A1uLRIdlSk/4b8QELwldxSIeG1iz/OzzQ
 k5f7hjh5MmQ3gu1EKdw==
X-Proofpoint-GUID: dJShRlRhXs2LurvxbyAWAvs4usn3SoPV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX8JMTPRhYE6vs
 hBU2uZ/Lzy3M8dRCE10UNsZq/ru2sv20QVPK2WBN7tTJTW0FELraQ460ELP9xhML3+zHFyVN5ac
 dn1s72AgyykmKLOjjlTAXXU1ByHpj0HA4xgGCaNOuqHs/4CCYriL
X-Proofpoint-ORIG-GUID: dJShRlRhXs2LurvxbyAWAvs4usn3SoPV
X-Authority-Analysis: v=2.4 cv=A+35rKWG c=1 sm=1 tr=0 ts=6af4ac2b cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=a5NvJi0EDLanwwYVvGMA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=10 spamscore=0
 lowpriorityscore=10 suspectscore=0 clxscore=1015 impostorscore=10
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Stat-Signature: xob7h4wcckyki43p6pmqguxzjpoyjq5h
X-Rspamd-Queue-Id: 6898A80004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419757-353016
X-HE-Meta: U2FsdGVkX1+I05J6YNcneMICoulGDfnfbL8LMrx2uu94mpc290zMzB28Udn4zkBJUtipTZVnhej0t6/Z2YvvMMReg93lCRgrOj+olGRuu5WMWzlSklfNLLO7ALPmcNY83LdM26tnaE3AYyUtgriTDf61Q8AEvrzTLgLsUcVDRBp8orBa5qN3eEiELM2ZakT+CHBeNnl7PTZ7bKyUUpV2TFQzJKKCT5xspMqlJt3RpfDlW2QW82mqHnaTvClcrAu0B8Fu7x247PnwYs4cO/btnQT4YZ4KvhJwNGox4K+PoY2IxNWtA98Ma4jhA3UElWcvF2KoemCF4ZXCBAtQzx62VxlV46r94e4N0fCQdhT6PYur2D8Hu7FC7spYouTLlDYzYjC6sZxkEO3Fht+D8bRbASr/m2nbp2htytWKuaDv1LdaxiSeb/5JOmqsbQVj4kfrNKrHCVz3eoQaIGujiITsf8elBTzYzM9x6cLI/yxfbTVGxzj9kBBpyA9JClKtICvZuKRWomVzW+gzFsCXWRQCyViF546ghOotVMCf/zfOWkbyGsMgmTzlG8HzKVXaWB//mxqWmgNFtr5y8b/nY27ZT+LY9Emb+My0XR0lk2m9pjItWf6oPl4sx0Cyrb2kNLV6woFj32TkQeYFaJMBleQjPm/ZlFF5/0S6rVxQtU6HV5WsowPjyt+Nk3f+krgj8JwjUHXb5uMl8crFoU+h9xeo4SX7u8HGixCliN6JHoKPyTU2ZF+ZUiwRuHAHBpEmUJGKNtx2wv8qJgm7Fw4beSkThtu31v5iT7yLPNHSS75QlfjV5tFamoFSqsOVvwhaN7UsHI6RX585thV5qrjbF5e4PQy3/BvzZZU3AWvyFdQ2fQXjy24wMI9XRHNpwESnTJ9kUYlauZRunm7lzvoWTXXHtogo0rmVRFQKEkqNR1VyN3CR29fAW5oowMXA/+11wLkFSxk1XW4j3kwnB62xabT
 fgALBbdf
 v8vn2oP+ow2aHvsHFZgZY2xOpknQWp6d0m1lSJi51jCzVqR/1LGQhetp+3lFPQtjqJZYz1CkS5RYq9uBTt/0BEsNaLQWZ2Q4rv7xqa9HabrLNa/fTI6ZL1n/Nf+GrATGU5Rxkq2pAobbZyGnMyxB7X8SrKAzL8tLbgkccaAOQJL7VkePnlPxW1S1WsAFC1VyNRHaA+JxshH9xNa1fGo+KHhE9s8I9Tk/jQFE1MM3w1E7bWr4sVeaLkoYxD5oSAR4uRE7MGEpN4uaxiSZgvhceS2wcLDNAUzJS1uV/TXFL3aJcOWtjyenYn35gwjcGBAVoMQ+hX6ck/btACvJ+eojld7BEfDHIrSRxL6wvVDaFCJvYMtACNVRQNj8AYjSIElNUVOZ7Bglh2mbcjQaoWNK90KAwLupVtLhhQItQLGRXT6C0QMhc07k9evRQVorbSREJY5IELV3lvZODKwQ4r8y5faKLnCl8MSdwun6APHpgIxgL2WQv9J31U+4NQb3ynTJRwF8B2e9MG+SUz4Z0AJ42ExrdZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
installs it through vma_uffd_ops(), no matter what kind of mapping it
is. An s390 KVM guest with storage keys or protected virtualization is
such an mm.

For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
cache of the file. That is wrong: a private mapping must never modify
the file it maps, and the file might even be mapped from a read-only fd.

The ioctl can also fail where it should succeed. A missing fault is only
delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
an address that did not fault, or can race with a write to the file. If
the file has a page at that offset by then, inserting the zeroed folio
fails and the ioctl returns -EEXIST although nothing is mapped at the
destination address.

What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
shared zero page can be used, and what UFFDIO_COPY does: only check that
nothing is mapped at the destination address, map zeroed memory there,
and leave the page cache alone. The zeroed folio path did that before it
was moved to vm_uffd_ops.

To fix it, pick the ops in the common folio path, as
mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
mapping, the ops of the VMA otherwise. That makes
mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
so remove them and rename __mfill_atomic_pte() to
mfill_atomic_pte_folio().

UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
if something is already mapped at the destination address.

Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Cc: stable@vger.kernel.org
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d65184d9a480..61a712e1f9f5 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 	return 0;
 }
 
-static int __mfill_atomic_pte(struct mfill_state *state,
-			      const struct vm_uffd_ops *ops)
+static int mfill_atomic_pte_folio(struct mfill_state *state)
 {
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
 	struct folio *folio;
 	int ret;
 
+	/*
+	 * The normal page fault path for a MAP_PRIVATE mapping in a
+	 * file-backed VMA will invoke the fault, fill the hole in the file and
+	 * COW it right away. The result generates plain anonymous memory.
+	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
+	 * generate anonymous memory directly without actually filling the
+	 * hole. For the MAP_PRIVATE case the robustness check only happens in
+	 * the pagetable (to verify it's still none) and not in the page cache.
+	 */
+	if (!(state->vma->vm_flags & VM_SHARED))
+		ops = &anon_uffd_ops;
+
 	if (!ops) {
 		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
 		return -EOPNOTSUPP;
@@ -597,32 +609,6 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 	return ret;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
-
-	return __mfill_atomic_pte(state, ops);
-}
-
-static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	return __mfill_atomic_pte(state, ops);
-}
-
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
@@ -634,7 +620,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
 	    (dst_vma->vm_flags & VM_SHARED))
-		return mfill_atomic_pte_zeroed_folio(state);
+		return mfill_atomic_pte_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
@@ -927,7 +913,7 @@ static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
 		return mfill_atomic_pte_poison(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
-		return mfill_atomic_pte_copy(state);
+		return mfill_atomic_pte_folio(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
 		return mfill_atomic_pte_zeropage(state);
 

-- 
2.39.5


