Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56378606D806
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=dkn7kv9i;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=PiTUwLEA
Received: by kanga.kvack.org (Postfix)
	id 7C0866B05C2; Mon,  2 Nov 2026 17:54:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A206B05C3; Mon,  2 Nov 2026 17:54:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660706B05C4; Mon,  2 Nov 2026 17:54:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 404986B05C2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7D8C1C2B74
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:36 +0000 (UTC)
X-FDA: 85391684952.26.79B9357
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 394DA120005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=dkn7kv9i;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=PiTUwLEA;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yGLnfP8ZKDdE9WWfyrLXQUXzQI6BTmOLGN0Hnn6wDw=;
	b=V+bXRHLFqqghEsDSd02WSspWFsEvHsE04TfxBVYvA6OcgaGSsbWhrWbi2Qa9oGACnd43BM
	4sO6qJoIHi9f8palVwRwjdOOFOb6Cs3E+3Ls0atW6ph7wcR7rNVFxJp3zFUBq8U5jdsz3x
	L6kv1vDQVQ4xPIw5Duv+OPMjMu2lQKc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=dkn7kv9i;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=PiTUwLEA;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660074;
	b=YQfb7gIQJ9WN0Eam1+m5YHtaG5cpaWJqeAC/qaAV0hZSQX4hfAbzOry5oS+0vqhYSmzokp
	aAegby/uoBHPo4KE0UMpTodAx3rro/FK/ECSROhDxnjLnDhNweVS3ObeygLUgPH/RCjuvy
	zsHWIABdQEeoa3C/dw3KHcRSAWEjXDQ=
Received: from pps.filterd (m0499199.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2MDMov2287548
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=+yGL
	nfP8ZKDdE9WWfyrLXQUXzQI6BTmOLGN0Hnn6wDw=; b=dkn7kv9ifrFDyQg7gzi0
	9n825IO8HEtxOakVAmA4Y3ft4TQZt9UwpNzOl20VePZcy1dTDxcOKVwnIe0BUAno
	XW2e5yDLVpUqfw9m6yFh/GKJUy6JfD4+zzjkV3zOv/BsKR3HAE0GM8XCtvU+3TFf
	1utmVN+swcQQkREYm4Eg0AeXx7/XMw0HAudCJokrUdbmOOhbOF4MLNqLV3q5aPc4
	AoUWaO9h1NKKz5uGuhOmmVD+TUFkjB1yZH1lpg7mK778W6kiFnGxoYK8353X8aNR
	Vl3R2Ra4y4pBAoJnFLc/VwmuXkk/2OhHdwECKL6X/ZJqYuHrSSZuke7rEfhIb1rJ
	jQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hq34br9m3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:32 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so734671985a.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660072; x=1794264872; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+yGLnfP8ZKDdE9WWfyrLXQUXzQI6BTmOLGN0Hnn6wDw=;
        b=PiTUwLEAsfFi5CorOFjDGfB42pxUmjrw/BwPwo7hI7yeZ0pO2pO3Cibyl1hBWfbzJU
         vQ1LfH9UdPuzmPjF1/mN90FN616A2iVpUVkPYXb2NVqjTHn1nKLztf35R4ZAIRsOe4W7
         WshXAUxQANRZbieS7eGc6osZvQpP0hbHRTVjkYv2DeBxqmzPOu80bc9iOtmAvHO5WwXP
         b8TarkUqCNAQAorfp3TG3j2cww5umISXqIef1rlF8blrvOIvRZ4RpnXb19efQRqsxUQN
         FdE2BCsbBxMNOMufogSmQDRA866meUeLVJ4YRBmJCg9jotyMZPDdSXg/cCfMY+rAwYO9
         cnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660072; x=1794264872;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+yGLnfP8ZKDdE9WWfyrLXQUXzQI6BTmOLGN0Hnn6wDw=;
        b=UwnrRzktWon4skV6/YCO3ykgKbLsM3+7jwHbT978VptP3nLPp/uzlALgiDA5wn3RaG
         XQyYRqTL0U5YGKAThDqvJxH1C2pGpFXaUzRMrJU9uDKQCT+m5c5L/pNHf4TkGELnvVTC
         mcI/vJrb+Ppw2S/irItPYd5hC0ZsBeyL295fVoqY+asgAWx3S6chDu3PAi0GW19uMo2b
         7P7wQ0ncBIy4dV4tGQ0UIgwmBYQau2soVXL1jePN7tujce65noUT4LKaj/vNFOFYjtd9
         WiO7LB/rZPYFqP6QnL1vfhVyFJRJTpf3jXPjqIdz0lRqgOXTZTAuwY1jQiuDNp434Opx
         ODjA==
X-Forwarded-Encrypted: i=1; AKwUvBwH3WHEdTgDQ+54fWgeWulhqww8Vi0oihO4XH5KRZYwpdR6sA9160BNLsUb9e/LO/UyPcMjMv2Udg==@kvack.org
X-Gm-Message-State: AFq9FYKlFk1r8yiJlVKOENQgflK8w2bQnnenMN/ibh5CckcGFEC7yBK5
	0UT+7vOok6OrpI8vHvh7YyKBQRptkdE+IxYjR2YWzMi0pkEhaeG9qHKHOThGj46Us5ihxHdYiOH
	wdK0Csn1n/zPQLEtXFEdR5wP9x1GdyiOeZNpW1wwWUsHPVeeP
X-Gm-Gg: AYBFou1wJbKdpka6whgEitMkoyKu1QVr+HKInqfGbYsKoxV4g9Q5/ciSQ06SeiUNnW4
	beUkj8bv8/PK6O/G5Xf6CFOATLN70c7qnRbs639cvWptd0FEOzvz/w4Pt2EtMbVyCDPKrmxVm2Q
	ZR2hkZBbZ48JyNjy1QaANQuMYs6IDHAwqRmgFQG/ne+n9MaFlxA5D1GXk2BNi/udDRzl087cTb3
	exfZ88SKa8fyX6vmCbn5CAa4J99TbK7Ej9tbU+sEDuDwC4Ywn0hgPdSLYQwXAtOHDzgBndfje+Q
	67X5o0BPE60AahkoMg9gBeQt14QG5d+QU9vFyXsFSlHvwhO0tzGT8T82bEjhrD3+CR6ctgBC5ae
	SlY77q/gruRwJg6ieJgRHRY1oRq/7m4AkGCi4HyUoTbGJUocXUZ4Grrtim4I=
X-Received: by 2002:a05:620a:2987:b0:93e:623d:99ec with SMTP id af79cd13be357-94421744cc9mr1890407985a.13.1793660071850;
        Mon, 02 Nov 2026 14:54:31 -0800 (PST)
X-Received: by 2002:a05:620a:2987:b0:93e:623d:99ec with SMTP id af79cd13be357-94421744cc9mr1890405585a.13.1793660071252;
        Mon, 02 Nov 2026 14:54:31 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:29 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:08 -0500
Subject: [PATCH 3/8] mm: remove clear_page_dirty_for_io()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=3173;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7BGChjOxIQhOtitHhW0SVkXy4VnfQVCDC4XS3O7FajE=;
 b=/NiIZEdK4/vHMgmcvSib7+5sqV1U6WoM4/lSQ6/4yiaD9YZKgG+9hO/ypL1c7u1BU+O3PANod
 aXNNjbTDdmlA8KC3CrSFBF/POjFrulEuLLnMes3oZpw5/0KLTpm8dSw
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: L0CFx3gtcHbsLKZ_xxBgPhKpDGQaLTWx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX0A7RIcmhHXt8
 hWegIb+Nl4iKSlQ6OZnrGhtxKpIEn0yqGbqxbBFo/7urZfdtBYBbm0s3KbUVruo7dPp63vJf1k7
 5hegiXcS4AtMU5Z0vZ+wACBbgF3bBsXqs0Xe0qKwYtLf04p13cMrWQqttbWX4YSIyZQDb6VftMM
 oZXFQLQrA/1YdhngHsu19M7rcx7W8iPn/v4I8Fp4bke8tJ/JD3DCGugaPYCyU3NomeN0Hq2/OTr
 hoz9kHiGQZ4lLYur5WSxC9ZLyvAP6rN622yyLFZ4n5WBbT7x7M0qw794Hc2nIpnSzoQnEFl0dMO
 WsfjleySdnerq2LjUBX5dP4a+kFTy/LMTm8rWRRIU5OgnvzJzq0vZULklYqKg9ebvF4L8KSjvjP
 rRZvwicfmn8gaeNrylaSWaesQW8OFqH9cH7dqb7PpgYM5FPJNof+4MqEHYOysi/m3d9w0j5x1mq
 jnvjBo0q5y7aw6Rwr4Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXyxmAi2LUxy+3
 2ptRKHYb7ZxzhEcX3ORHmPQYKVsd9IMxgwrEURN1AG0+d1F6qDAxu/8KWavRN3rbSLF6P0+QQ72
 mjVRYUepQ7652UzLMuEsxsEole2sWR5RT8vLRLrLj4RSo4TGpt7C
X-Proofpoint-GUID: L0CFx3gtcHbsLKZ_xxBgPhKpDGQaLTWx
X-Authority-Analysis: v=2.4 cv=Sadi5fRu c=1 sm=1 tr=0 ts=6ae914a8 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=G--0XuH5328wxK7v7Suf:22
 a=Ut7rPBlKFqStPCCC4O8A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 suspectscore=0 adultscore=0 lowpriorityscore=10 bulkscore=10
 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Stat-Signature: 6rbcrs1khxjtk9boqhyry41rxmaqw98w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 394DA120005
X-HE-Tag: 1793660074-209776
X-HE-Meta: U2FsdGVkX1+gBRA3kFiad3mnGT9EKOhsKuRimOBcA6VCluc3+IIFIG/M2skQjcokXMkTGSmqXVEEIVmZC4KtgD4wXJkEV+l8g0cSFe5DGZwB9/vfUaWToa/cjzn2z4RAqZnkhV9uJNJ+Fb04/u5/LYVSTYU4I+COq2GLdFObf9TE1wcnxP8LrvQ0y1I+8K2kVWbgFCZbqmLGm/wsoM7Agj/PojPFaR2iPozgzPrQP+fAHY+55TMXJwXKGphwAut2t3Aa3nyu1wFKvNAQxNEDvoCt2XcADNpmlDZzYcvlPP+/rraYjEe6AMU/Ewff7/WMFm3WMvkbSSrHTFCwSJGE8JenNlsP1eCyIYF9p1r9nQlc60r1RHHHI4HS9KF5ObF1DOx3H5cpJpCxh1XCfkbxCbP6jKC7kEllOg+Z0uPKZrBE+l1QqmosEY0awVHFjvtXNpTRh3PzvCk8YMjK9dVWJuydfmWqy+jGAB2mAQbqjMM5vIFfFBXrfRoLgfeOzuzLx/PVQbe82I+f49Ei07ADKzrmqr1oSTuSI7rIrkY6E09GXNUSkXRJucwMk9lHvZ0tr0PNc7ON9yIV9G49EsFj/LTxQ3O1dZ9k/idae3MSG+oHoPTSpBMjFGhOkK2amOXEYFPlQi4P4QEHNENy3Npzo1AME5cOfD1iUczliO5CrqpS1iHlszK6WBvuCRRdjWfmWr6CmDH2RJ7BjHCIUpAbCEsJKjmU3JZm49/GxhorZzv1ccEjedCZhTe+6qTrk/ykdRBzkCm8TqjS6jGmLZNtL0kAWXseXV47ha6v01iK0OrPalbKRHPOYw1UdWpQ9+iUuoyZPeiaiFyZSvkMdbJPjSB4S0oE3SkAvqm4hBm6LJxtBi33Q4taBLfDQzMp5998FaPweIlwYmVwmauoEgz2My5NWSgKyCc8bAS9zbCEKZwV+2+E7FUSrgHzBtVG6YMlQo4PGkJK90eKHSwTjYZ
 z1MU8Vva
 frEXDvfY1bNuaMGlNMrS1LMptBxQl5BcA8YpLO/IhSsaG6eWPV0BQnX/JRCQSgPzhm33aGKqUONbxfoiYmDGsbmZrfKUG2FnLFfTeXfdR3fFlsYX8ltPuh0+1jZ6E1TaNcIFeg9m7KrTPkQR85mZGnDhbRGoTpI40/fmvjUX5rS1GhYUwjxcBuISJpuTxOK/WK9GHRKPdSLb6WSXuviPl/GncPRSzMufoo/HzJbo4tkU/FTwpNqCU6VBO1gn8j0gfVHpci25yrUD0wTOQG1tJl2nc041d2Ewe1Xog7gKsDY8lYz1gp8b5HAk8Yj0h2jSAHzgunUpzikUk29MIizjoQreqRgnjp5ARIi9ExUxsKzp7RUKJKJgbzP6pcGy39gI8E6LMABDDRjouoKrWH48JKhN0A8e1FniCWjXWleE+GsgA8B8EcKFk+O3DuKvZrhqVYeIAd4wm8rolLcs4uy3OrdQK/tOvyCRKhYiOGurIFzDgnR/7c2yfsBbIFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are no callers left. Point the comments that named it at
folio_clear_dirty_for_io() instead.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 1 -
 mm/folio-compat.c       | 6 ------
 mm/gup.c                | 6 +++---
 mm/page-writeback.c     | 2 +-
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 692ce3867a1d..9adfeae2153c 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1315,7 +1315,6 @@ static inline void folio_cancel_dirty(struct folio *folio)
 		__folio_cancel_dirty(folio);
 }
 bool folio_clear_dirty_for_io(struct folio *folio);
-bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 9f2cd0ebfbbd..13d4d39e1896 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -42,12 +42,6 @@ int set_page_dirty_lock(struct page *page)
 }
 EXPORT_SYMBOL(set_page_dirty_lock);
 
-bool clear_page_dirty_for_io(struct page *page)
-{
-	return folio_clear_dirty_for_io(page_folio(page));
-}
-EXPORT_SYMBOL(clear_page_dirty_for_io);
-
 bool redirty_page_for_writepage(struct writeback_control *wbc,
 		struct page *page)
 {
diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b24..335dcb3a5c17 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -298,16 +298,16 @@ void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
 		folio = gup_folio_next(pages, npages, i, &nr);
 		/*
 		 * Checking PageDirty at this point may race with
-		 * clear_page_dirty_for_io(), but that's OK. Two key
+		 * folio_clear_dirty_for_io(), but that's OK. Two key
 		 * cases:
 		 *
 		 * 1) This code sees the page as already dirty, so it
 		 * skips the call to set_page_dirty(). That could happen
-		 * because clear_page_dirty_for_io() called
+		 * because folio_clear_dirty_for_io() called
 		 * folio_mkclean(), followed by set_page_dirty().
 		 * However, now the page is going to get written back,
 		 * which meets the original intention of setting it
-		 * dirty, so all is well: clear_page_dirty_for_io() goes
+		 * dirty, so all is well: folio_clear_dirty_for_io() goes
 		 * on to call TestClearPageDirty(), and write the page
 		 * back.
 		 *
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0694ec4098f6..b56f2c91b0f2 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2821,7 +2821,7 @@ EXPORT_SYMBOL(folio_mark_dirty_lock);
  * This cancels just the dirty bit on the kernel page itself, it does NOT
  * actually remove dirty bits on any mmap's that may be around. It also
  * leaves the page tagged dirty, so any sync activity will still find it on
- * the dirty lists, and in particular, clear_page_dirty_for_io() will still
+ * the dirty lists, and in particular, folio_clear_dirty_for_io() will still
  * look at the dirty bits in the VM.
  *
  * Doing this should *normally* only ever be done when a page is truncated,

-- 
2.39.5


