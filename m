Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF347606D828
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=P2o0hyyw;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=uJiHjjUL
Received: by kanga.kvack.org (Postfix)
	id 1CD116B05C4; Mon,  2 Nov 2026 17:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E236B05C5; Mon,  2 Nov 2026 17:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093A46B05C6; Mon,  2 Nov 2026 17:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDAF26B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BB08A0280
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:43 +0000 (UTC)
X-FDA: 85391685246.10.0B9D690
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id B11EB8000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P2o0hyyw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uJiHjjUL;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WodIHx+o0x8mOdMhlt22k4lCyVvacVF3CF8lj/COxI=;
	b=hkmgMdm1foahSC8S9T01XLXDLw99gBYUKjpcwa/Herb3dWosMLLcrq3KCy889OLSIHsSww
	xjaOhKhG58jqcuD23InSUe1vDv6bpkZVegGqg7DhESmrrxnfg2j9di1mFPsNiyfQ6wXZJV
	UA8YDF/yb1FRUG8qIG01cJ9j0/OYKEA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=P2o0hyyw;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uJiHjjUL;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660080;
	b=6BXVmRpgwdTuEYdpSSBtSw4CcvzQgUG+lH9KClwd0h05gLJo5xfVoY7EQDrYP2cGN/s1Jg
	R9ABd9NeACf4uqDMNUeygNywAq5lKDlWobRKJGTMIdQ7TP17369sDD+YqYxeyV7DU3yEZI
	mBUelY1dS1LWPE3sRIpvE0Q93juJB8s=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LYAj02772632
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=4Wod
	IHx+o0x8mOdMhlt22k4lCyVvacVF3CF8lj/COxI=; b=P2o0hyyw8W2kWy+48HDx
	MmkDx4r55EcETld/+U38+TsvF/8ZuYQxAVMYMQKHrgxHBhicoGUiqM3gkkNG2pNx
	nIkW7AjPZR0vYmT1moFXQatNztBl3G4x15DBxbJBEdvlu2MBv/XJRngIpzckrjZL
	1zrOuMlH5MkE0iW4bqhmlLzQnKeMMBXBzXP2dEhuedkoqrfiZXDDRczMCjCA7hpA
	xbvSZKuZJ1Sb6d/JewBK6U8PIKmKkJNoOnPXCSz8JAU0ouGSdPdXiJYuwgvmkAiF
	Mp9HdBMiwW0bt6zjGKl2XGFP0mceNq2eCbYZ1TtdwIrlxS0hROPdc06QXw9Zumkt
	UQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hpua8n983-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:39 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93909014c85so705844585a.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660079; x=1794264879; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4WodIHx+o0x8mOdMhlt22k4lCyVvacVF3CF8lj/COxI=;
        b=uJiHjjULgSzXQ3a6Y1YbH0G629HPk/W4LQI7pxPI4OxQV2cvZ0PcA6wyMMbnLXJ53x
         o1af+TR5D8+4kRR7HGe4Dy9RdddE8XGNSrCOzh+khotBywBepRBrwtmD+OEDAQ8fteA4
         foHYfJzO+tmTSXLlskiXgUL94/T7P7Qcn2RC4DzKKq5qIMw/RGRVxaXdHuXjAejeS3w8
         6AWObDj7KXUeU9xJ4PrciZkkhRUBCvH5shAuAiY3IbWFLortkK/1T9boHiMmgKb5B2GI
         NYe7NfRyJRY4KEWqdrhf0Zbe/YmJLHcEAWlhz+m20sHC76p900bgRrSMGW2L3o5CNvSl
         TNtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660079; x=1794264879;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4WodIHx+o0x8mOdMhlt22k4lCyVvacVF3CF8lj/COxI=;
        b=gDQ/00CzKAdqNQ+s9h+a/m030hCKIPRb1MdTibhziXd2UH2f1/BOFi00mVBb1eEe04
         kK67mlqxzL7QNkzcjMwgxop2uzBXoHmcw0mUAUb74e5/Jd9/o0GLfcLRRIv7iZBmHktq
         DBMQC2YL7mgJPfVcU6VNtp4t4Kd7LEje9c4fnH0koaWSU/xJZ9JKIg4T1lcfvvYh008K
         FdMFcYAHfeROR7PwtWsUQbwalgxwbx8mYb3VfjuGtvmmxcg0quqJ5XcoS5bB3yDQJiO1
         z422skeoSx26qCqiEounQEPLsjNizFvsz6Zo3FmuHt6OzwPdCxNM/Y1BJ1DiHJuCC9fg
         MX7g==
X-Forwarded-Encrypted: i=1; AKwUvBznu6uRT5guYM0CcHV2pjqXwIlqEswELyi+IYZNxpqyk/dCnbH22SH3Wrpu3kAjiSoY7gkN2iYeTw==@kvack.org
X-Gm-Message-State: AFq9FYKqe2uocGZlFiWINnK6Ka1spUlfXccJPQZ1A56sBUaXOBEOgHxM
	MEdQEeIYVJ7REoYdXJ70np2sgHqyaZ5XqDJ4rb5odODGHZxHvK3okFbq+A31UI2zj/l9wDfY+x6
	vTQ8xVtGDoRW9zHlWMlJiLkPwddPOKACVqZitoVeuwerbOTWg
X-Gm-Gg: AYBFou25v+PRMQBGz/Bnu1oEnwkNq+k33xOWXKE6ucDhBfvsfEHPfv1m5vEMVILw+tu
	T3/kiQEan3n83fSAqe8nPbT5jLcJrm/YMuP+iG9HdOIJ7WLJgqNWg3ZilYk6L7q0MiYwHbqoXZe
	eF8aqzG4XX5JMtudms1Afkfv798JF2eyWNu6NsGxS4O1uo1tcpiWJ/4vu0TI7rSD5JUVA4VTYdG
	6un53w9d1JxEg0Ab/YffWbyclH8Jtb6V1W+hI6VT2AAylexiYxZxNtETI8sSgB3jP8pwpKH6oXr
	ludztJOMj6+oUqhri93rnHmZKict0XDLliCA998iYfhwJlWGhqf901Xa2C7xIih4oKVsDNhjjrg
	/AlNTDbCmEXzt8lAM+VWo3MeDXYy9xWWUc9SWg+/PL3GM2ZbBfIw3TOrmx5w=
X-Received: by 2002:a05:620a:2609:b0:944:dbd:8253 with SMTP id af79cd13be357-944217f72c8mr1693641385a.59.1793660079311;
        Mon, 02 Nov 2026 14:54:39 -0800 (PST)
X-Received: by 2002:a05:620a:2609:b0:944:dbd:8253 with SMTP id af79cd13be357-944217f72c8mr1693639585a.59.1793660078879;
        Mon, 02 Nov 2026 14:54:38 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:37 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:10 -0500
Subject: [PATCH 5/8] mm: remove find_get_page_flags()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu>
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=805;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=n+LSToSjOm7X2+ats/vE55AtTanVeZ9G8sfdj5eY+qI=;
 b=SLUwpgSXGUPwLxafx3YfP9ua2lMfAyIM7MGJHk4+fQuEir/y/Mm7DSEa79ds9kqwGshw7+/nv
 eDd9qzMfmilCmG1z+7o+2ocLmkVs8daBhezdzyb2sTGJqXn6Gm4KKDe
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: WH3TuNwzP9E8LmstYWKxjM-roGJuHKnS
X-Authority-Analysis: v=2.4 cv=IZgSymqa c=1 sm=1 tr=0 ts=6ae914af cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=odCjmUfI5hfCSXoyQxQA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX5ur/As1VYon4
 cv72tSaL5Y29sBzCieQ2s5M2bIWd8rwdHzmCcpcYwMnFMQ5JREqkCGZMABsN1bvlpUAAMVVcRma
 MCzvuX1qYjwiAgvEsuWWYeOSrCFbZZw7BaXxJV1o+gTbL2AqN6uy
X-Proofpoint-ORIG-GUID: WH3TuNwzP9E8LmstYWKxjM-roGJuHKnS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX0GkR/nyWifT2
 SXnBn0/vKUAsKdBPmIPE5qXFQW1cfJhqMaRa5lSw9T0Gd1nkBfqj+3ALg4qGeJk1Up1s+e4v8Lu
 G0UqFHGLp2B2QyrzISmYBNWmgq7yKILQcPRnbK9KDQKeRdUk4CEdKJkn/FlVdozl5vscMV+n+ij
 5Vbm527bv7pr+HOTdMEmx+nkJKOCdSW8uA60plYsRGU17og4XtwKzpSU7aZyGPE/lyu6RQyNnGO
 Tg8LVGzXBSm64xaQychRoHg/aREASk4vXaaWeLSQRFFVg6o+CpODZcAppsHeoI1KKM1fIYGPM/Q
 sWm8DleZwtqNY5XxUTepvyWLmLO+RV1Fjs3z8J5+DJkyNZ+zkhDRrlcW3NKmOPxdTbxDPDAhImd
 Kco9wmK1qJAdyZUN0aEdZTQfnqQIeY/P01NUCBMU9PzqdwpFlNLKU5eMglA7yFv7aaOJFZr7t8N
 lI3YFJSEUPSESr0XRRQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 impostorscore=10 clxscore=1015 suspectscore=0 bulkscore=10
 lowpriorityscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611020090
X-Stat-Signature: eq7oqamhyhz69qupbpfmytteyafjarrz
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B11EB8000A
X-HE-Tag: 1793660080-700192
X-HE-Meta: U2FsdGVkX1+xlHv2fD1j3lt/pqzVIGPkOH7R5yHIUUzIA6iDaHdBQQcijLBVs57nTZh35YQjJWAGvRcGOjTbTNUuCFulCRaluOyxnKA8dv7Y2W1iVOrrB7IUGwSY392Mfhc/6IvL67iI0GjsNRr1OJMRAVxyoBnMs7Nq2aB3Sb08h3h4wPCQuDs7tFyojXsPXc424jn8lX8pY+3sexla7SQXoAwSYoRrP9wTiLLWZbbLLT2W1HrJzLbX7m0W3+qmVSg6LWm/pTdJ9QNUVFxLQDFmvad2f+J5xiSty3H3Vn+vOUUk92YDY38uHq0PzPJcRd8cABa+ULx0ed/HGyAjYgnw6ypLD+q8fC06LSLbK8jmKqllUXWTCTlekdCGLMQ5P537JFb/X31mtxRve+qHXo0a9uuo//VJpkbIVW8PDKFopb3d1cPZr0NCQCOFZyOQ/OVjjuFckXLvhZuPveyZXEuro39fwP9JaJ6apCZfnGeGeH3wLWq8Z4AX98nlvarhfxqfTrBUtbh4ce6xXH+oHW7DVmn/NhjOu5cCbRPdFMXhK12wEMlRIApthlTthgBeEcLg2Wyiw6RDyylB1tH6OdCNHUaiGRYdZKdt6mhmi8WuBK9fMxo/2RTH3pvkGlVU9Jzp5A5dWXdO0rzHx3VojR/fKnnDKzihEfAweN+vYYasK88KZk/eFTECL7ylLr07TK6Ey8C5zuhQpQnKZNgX5vw6QThT0ExbNDk/H4HZvyFa8LWd/axFm3rmOtT5tuSqEnhBejCmj+KkyrerVqep7idAlUG564LVU0YpWtTELYxx/PharFOjlajfZLM4WSr4fmAoRMkSP4ux57s6soEQipye703pg7AKR6aKKYUbq5F8lO9w/7MWKwp+0mUAd4prhLVGZFmmdfA4+/jOSy85+IB4t2hEwlCo/i+GZh27Tbnw6m4+BPQvYHk5xARehaIIk/RYhgxDLUSJKrLCGBe
 ejRDnnHQ
 dhkD4EEeZMw1EmFqvp3pZniN+wLbQQfv8Ov0k0VUX2AsJkaBibb7V/ylzwmwLGpSIy4LJD/guefCuFzn6OnUzhZ5AKud4lOWE52QbF4g0AkCHDdG27IwgwgFyEu2P7YBgn2KJLYX2GaggKj4fCw5Xo0LDbmgZvAnDA30J0aMvPipZOQObVqHhRGb9ooPJlAX0FOCBJZCFkI0FUYjGAvQOhRrfHG5yfrogdzSimuFU7xnDYthkSQW3dx4xHlNJRYbDqyrvBlW/YeJHRKn+J+jioDz2QtmQKCNldrIPiANj3gxuEmIMXEmXBqTDBNCKE+YFgowtbSSz3ZEEzhdRlP3w7ACCoTmc6vjCOYXSR08ZUePWjo/68SqCIFmR0aweimlg/ArK/OyG6Cs23tfsRQ7jJ7KvRwgrkAnr0AWyN0pxwew6gwcADtT0rrf0QU24s89VujkCA620xM1wOcX/y6LgKxX1cTO1EPOsJVNO5c/u/nDG2YiH5VyiM5gyow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left. Remove it.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 37b7786350c5..00e32f96b459 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -846,12 +846,6 @@ static inline struct page *find_get_page(struct address_space *mapping,
 	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
-static inline struct page *find_get_page_flags(struct address_space *mapping,
-					pgoff_t offset, fgf_t fgp_flags)
-{
-	return pagecache_get_page(mapping, offset, fgp_flags, 0);
-}
-
 /**
  * find_lock_page - locate, pin and lock a pagecache page
  * @mapping: the address_space to search

-- 
2.39.5


