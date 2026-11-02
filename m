Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C188606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=f794UEnE;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wxgbmbNU
Received: by kanga.kvack.org (Postfix)
	id 661246B05C8; Mon,  2 Nov 2026 17:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6393A6B05C9; Mon,  2 Nov 2026 17:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527DF6B05CA; Mon,  2 Nov 2026 17:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B53A6B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:53 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D609C01F1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:52 +0000 (UTC)
X-FDA: 85391685624.27.A3B55E6
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE96540007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=f794UEnE;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wxgbmbNU;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660090;
	b=i0MKiGnhxaGEmR58SC0ragQyZJwYCkfINW+FttfaZSK6WcvJqJ7vjmY7wSyWaw11jNeMxV
	zrEkDSMN6t9x0VN0sJ9PECu3ilu5ofOQrpk086EIrh3R0mVxO6nLCarwhjdvCDZzOZPt53
	sciySeDYq0oy+oeaV2D2EWfFl/QRN9c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=f794UEnE;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wxgbmbNU;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+n+C22ug44tZi/zSDo7h3XNZ0RC6s+0z26GFL25p54M=;
	b=Y37jUTAgYNpa+l5N2/Oper7NwV+E7Ft3KGeWAt9XEPJe7vJEr6DqiAj0fVfIrca0RFaFEo
	h4/oYJMca0cKI3tlgD2MB8lIRpdYXx6iWgOuZIYlq3GN9BI0uwPYWB3KbFDjRqxA8x6ToS
	5PeFTk+2YIZLU1vL+bi/LJN2Dt84f9U=
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LYBqC3358557
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+n+C
	22ug44tZi/zSDo7h3XNZ0RC6s+0z26GFL25p54M=; b=f794UEnE20qN0MjZa2Lf
	8yLMS6g4sqhWKbjKw0V/PgJVyJKk8CgRzJp9sXwvI2mu8gFdkx/F+mItbkOF/I5N
	DcjVNqBeAsWdHLb91ZbL+i/rDDbWOY8EYclHvOl5xhp3b+knIHTsq1F7cXrfMguK
	0HkwMAGOdlvN/Slp44+ZjjJMr51FEFsRzoxitSx6A6p9CqRvDr/6FxCHcoGf+0K1
	T0tgkJdtOXz2A3a4HFkha3mzJswtDa9Eq3AIBLKhLXqp5rWuwaqhd98yJxUPvm3w
	r2nyCdGsPickemPnQOU6uH/S/dws/Y/qvsaVaZqxZlOiX8GYuOjGpRrha9Wmtkzl
	Ug==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hpwfcv634-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:48 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f5844cb60so29409985a.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660088; x=1794264888; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+n+C22ug44tZi/zSDo7h3XNZ0RC6s+0z26GFL25p54M=;
        b=wxgbmbNU21a3jPkDjL/JTjrdLJ84J34fGsKht9Jy3e70oGN+jXhimf18lb5IA3uATZ
         ZDvOUOkhdP+v0eKX4/BdonZ/8oLdWAC2QK4tV+0KENuwlwQX4LcnGAawu0xvSVJKcBdQ
         XGIvNmh5JEPxLj8F/ENKSQsSTASCqEcZ9cTnZ1twjiji42b+tgju+6vVpsxvWpFlr9zm
         hbQ17T7hqcEgTBzAfBju0jY14en/2fXJ7imX9NW2xaxcXYy/vSuG5gkUd42eLem8XYJk
         Omp/T9smEQteKAqvT/LHm23eHBIy371cKjQ1Av4/mNwPNy6MrNzcg5jo11E6oo3F5BoW
         7ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660088; x=1794264888;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+n+C22ug44tZi/zSDo7h3XNZ0RC6s+0z26GFL25p54M=;
        b=JMGidxPmA65AT2kwwWNWySLr8NA7jkCJxeL7/az0dQ8EsEHJZ24rRVTJLmZPZj/+Cm
         iBozTJUrDt7uTn6j0QHPqvK83Bx+VcvEAwDqyxMvdm6bMxou2A3T2gw1wK+K2J6qMu29
         dhCTibmxFvgxxf3ZuomNExwG9VBUCUvbj2/YpeurBsU6RqWeDK9DjcIrDJyvvr+v383I
         OIfduOt1VNioGenbZeMrDqx5s5DBkD+cZQvngUsHgH8pJC0AreUaDBRjSsHa7C8nwxlt
         p0X1jT8Lanq2N+BpL6KhJRTzCjQk4P9Sj7billWqJlcJh2vWBggCpWC4LXuseVT/mB/b
         DF1g==
X-Forwarded-Encrypted: i=1; AKwUvByenNP6dCwWLzt21l3HzaA5JI03VdXkNzJA4Biwd6lxHZ5wNbuoSwFHorb9I42/60UVCqTk3hdtFA==@kvack.org
X-Gm-Message-State: AFq9FYJtfJSqu7dCbeODsLsEFyBLbVaxVnZBIjPlT262nyYL6mzXk1/k
	84f2JwkWxiutFXO3J9F9kTlu62chB/mrmUsGecHtyGOdrHnYkyG2Wpd1OkJQJZpDAOZ0aExMaYV
	DyujowNkyX1dt0qYJelNrRkBuj9EdbfSrcFUjHFEpnJHzUZQE
X-Gm-Gg: AYBFou0zU16PhIP5nVDFEDnX5oj+sEJRhEohk2RKRDi+jDYDyWzbTjzzWJ3/94rFEkp
	0nDU+hsODia0MMuMgxe+IP4l5qLfc9E0uLC54zOukJdMt+LktaGB0/Sl3s0Jl7uLvxDYD+YEg8x
	G2fWsUn0qo5O1xs7j8XG255n4JcbjrbALNzSI5qqdl04cKh04jZVd7VBzLeulN3TeqvZm1kzZEM
	56U2LyYQ8zCTksPgw+aLUOeO4jAaACX5ucA0HJdgiNqEd0+c7cY/y1m28qwuVacqNXZbk4xB0n1
	4PNkUEq2VLIu5VyRVFXlymBysAd2xczhyQpLafnORxjw2aysz6QvP18cpp1aCk+lmt9FUY2siI8
	F2B83GoJbmYQz0YO/pfuNdOz0UjmcffIQnSwg9bTvv0LtoD08gAZC9RTy7KY=
X-Received: by 2002:a05:620a:711b:b0:93f:2e81:2217 with SMTP id af79cd13be357-944133d6c9bmr2247288285a.36.1793660088363;
        Mon, 02 Nov 2026 14:54:48 -0800 (PST)
X-Received: by 2002:a05:620a:711b:b0:93f:2e81:2217 with SMTP id af79cd13be357-944133d6c9bmr2247286085a.36.1793660087877;
        Mon, 02 Nov 2026 14:54:47 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:46 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:12 -0500
Subject: [PATCH 7/8] mm: remove read_cache_page_gfp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=2961;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=iXAYsdJV62i38j1emwbwdbC78bf2OkaieSqqfLylJrA=;
 b=aqMzWy5ivbfIJq4ptqsBqYqbQ9FaALulqGhIwOJg0pfOaZx8bycf0yHvDarD2bQnGKi6NfBo/
 XuHlZoR6BZNBqRi3CZOGQTS0xEDszTh9YrJyBvZyxG5CK1s/55Hp4pg
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX8QISGXal6nFY
 +uI2CkpHi9ZQms0/ytur7KNRm8v9T930vJIDdK10oL71x9tes1DMza+ukr0QhLwh4mLBfza+9o1
 nedKV9OgYRPcQHQjUxK3e13wlwX+YA2awt48mL+5nSe9qDJQeNOj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX5UkaZ3zCf2Qv
 W5mYxF0I3urovO+uglXi1vwy47vU5pfm+A95HoYFpdjcNwIpwqyGR5TiYO1mHQL9uCBc/ZRYxQu
 8HtTjgXsW/j51QnlylWPIc1Yk/TP6UzyHztWvMGqtDfuNusIQ6yEpKOn+XzW1rKFdhZFUGOemsU
 6qjXdGfh6czpSH9GUs5aPZrTNE/FCsGo7UYHnZOA10ZBuT1ZWBSGu3zGz5KFZvoqI1SzeejrgGA
 8LUS2gfYsp91m3RL3Nq/uHSeeDEYlgmpYfOUO/yuvE9h1plV1K+vbY0fBuJm0ETK3vtKr7pkz9A
 wPGomdNJKuz5wTGInPdyqXY/h/9VNg+7Sker765Juil/T8eCM28IDpbDvF0e+kfQbUpXCshAJ54
 fQ6lz4LoiIb9DCC4OSM3MdbxFwzGQ4cN4LfRNzyVJqfadT+SxH5Mn1Rs2QUhDGd7yI2JVpKttW0
 KP6B69ljwiTS5x8GVng==
X-Authority-Analysis: v=2.4 cv=dNszC+Zb c=1 sm=1 tr=0 ts=6ae914b8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=NLUVrwrjVKh-CqleozEA:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: JhUx3JQbfligZnoH27JniXn2KUfUH800
X-Proofpoint-ORIG-GUID: JhUx3JQbfligZnoH27JniXn2KUfUH800
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 phishscore=0 spamscore=0 bulkscore=10 lowpriorityscore=10
 malwarescore=0 clxscore=1015 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Stat-Signature: c4us5bgts5g48b4zxh6emyxd3g4gikds
X-Rspamd-Queue-Id: CE96540007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660089-718606
X-HE-Meta: U2FsdGVkX1+YjIqYd6iESIqZmEjC5jfbjCsIeKKf4u7Ii4/aW2FpQS+eBSnYjr/KPBp7PW054aOB6tfHiOyoUBX80nvrf2qFk2KWjSCuXWIzk3NO+C4uVLJzqIS6VnfpKjlmOpZ7ekq0VD0fK55HkEq/d9hAhclxOiLNrjvvop4v6mhMGJ5WodMGhv9ZLb8UdlH6/iehdKTNDtWpe29vbyM6rOnIdYj8ncklq15vucS4OtrlrFVx7uDeAWdLGp9Tbh3rUycUD8wD+LdVrIw9A711bzaqSqq4VvZFlPg09cb4vPDbFOjirX6KieDykKQHE0QE1E42S9I0dH/0X0pjoScJiRqpVVC5NqXEAPzeOpW646DKy2r9rz3AcudX7tvkj27m3cvuYg2S0Tr7FusFTBbycc2w9AC/IcegMQt5TFmDYpEgUmdSIMaHpzhbxP5yxVB++jZrBBjV+c1wCMV9vIaStCxen9eaimKAtNGaHKAH/oB5yHoCDiOp/iqqWHLfJkqPV6iFIfQt+0iSOpciw0of3UiOyf6ngKV+pQOD5zjEAgXKpyXAHlhDtQMaAOP2FHHhqCokMarvqGYacIl32bMcr8yGevYHmF2XsJ1jC1OsuKdhRw+d0lXsD1e8L4lYlI2ovKNkRrYO6VjXEFI87X71eAiZdjm1pZPehbtu4PiwKczNtChseVECJASflsVHoQ6G5N1WXUSaw/yuhChzZ4wbSssluypfaDWPMWdh/wG2xY4/R+IPJti1ONfwkVJeijJzqf39LKjF7N8N0ts+Oz34JJ0ahNb1O+RkEZK5sfsqxzoYMU5u2FCWowun8qeM4Ljnq0a0d+nJnVRnXHjwQ5KVDrMpGNyiyocuWaGiBZumEqAowIw1nuHmo+sGmQUvfqm/r7KWyzMYvpJcI1Q1tXb5A4/rNcYg+i6pofwNtz5o5CvZYUCLGrSVmY2kDr4KGNQMpFRYuU/UtuDYKOi
 A73JRidt
 u5D6zr/T7vbwtjnIW0kLzXPNBuz4J+cfLdbXjNtrp/uNtqLSHQXucBU9z7kQ179yRzps4vF0/Be6K1wF+P9xfS560W7rg8OUghp6yyJjrIha3wUisVf2TVRmKoUwsmJkOseRFHfhM6Vme5596gibYVhcFV2TL876INpdOIked2U5VDUFivPNLpNnr1ZLDYMSmDgIY+SxO6AVzDgUhLFSBON4IboOmxEdeZrT2c4aaHxBJlwVijn1BXHT4/0Uf/KUuUQbm5Pxvcffgbd0qu3SWwv+NBUOeZqPXEJv7C3gjpBKX+qOmo1VX59R5gRVlwbRFPbWD5dRs8iGHsNYmaSTB8h/Kwht4wrgPN8RQ6zEYWL3aj3vvuL8J8zS71DlPTHNSHVTrSySCaAl1ehxVn1UWPAaeNw+DIam6xoVu8bdr55ExZmU/+Su6DeDzqIZLwoMO/JdSurqQuAcLSg92XboDZ5NDgSXi3xgPzxsngJ2xlvWlyWZzZHHBvnWSFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left. Point the comment on shmem_read_folio_gfp()
at mapping_read_folio_gfp() instead.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h |  2 --
 mm/filemap.c            | 23 -----------------------
 mm/shmem.c              |  4 ++--
 3 files changed, 2 insertions(+), 27 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index a92329805acd..305c99bad689 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -962,8 +962,6 @@ struct folio *mapping_read_folio_gfp(struct address_space *, pgoff_t index,
 		gfp_t flags);
 struct page *read_cache_page(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
-extern struct page * read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index, gfp_t gfp_mask);
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
 				pgoff_t index, struct file *file)
diff --git a/mm/filemap.c b/mm/filemap.c
index 1df776907140..2b724d9be94b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4258,29 +4258,6 @@ struct page *read_cache_page(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page);
 
-/**
- * read_cache_page_gfp - read into page cache, using specified page allocation flags.
- * @mapping:	the page's address_space
- * @index:	the page index
- * @gfp:	the page allocator flags to use if allocating
- *
- * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags.
- *
- * If the page does not get brought uptodate, return -EIO.
- *
- * The function expects mapping->invalidate_lock to be already held.
- *
- * Return: up to date page on success, ERR_PTR() on failure.
- */
-struct page *read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index,
-				gfp_t gfp)
-{
-	return do_read_cache_page(mapping, index, NULL, NULL, gfp);
-}
-EXPORT_SYMBOL(read_cache_page_gfp);
-
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
diff --git a/mm/shmem.c b/mm/shmem.c
index de838dbb4df8..16b1cc3d8ac5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -6190,9 +6190,9 @@ int shmem_zero_setup_desc(struct vm_area_desc *desc)
  * @index:	the folio index
  * @gfp:	the page allocator flags to use if allocating
  *
- * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
+ * This behaves as a tmpfs "mapping_read_folio_gfp(mapping, index, gfp)",
  * with any new page allocations done using the specified allocation flags.
- * But read_cache_page_gfp() uses the ->read_folio() method: which does not
+ * But mapping_read_folio_gfp() uses the ->read_folio() method: which does not
  * suit tmpfs, since it may have pages in swapcache, and needs to find those
  * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
  *

-- 
2.39.5


