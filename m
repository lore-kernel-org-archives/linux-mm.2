Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA45B606D80B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=sbg+U1tM;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=V0sCG19o
Received: by kanga.kvack.org (Postfix)
	id C54276B05BD; Mon,  2 Nov 2026 17:54:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04BF6B05BF; Mon,  2 Nov 2026 17:54:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4C66B05C0; Mon,  2 Nov 2026 17:54:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1B66B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:54:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D16E16028A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:27 +0000 (UTC)
X-FDA: 85391684574.10.ADA0B2F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5EA4EA000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:54:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sbg+U1tM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=V0sCG19o;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793660064;
	b=0oV5GQA61IaWnfH2g3KUgvOK1ei83e6i81Dc3bQlSsgpotbara/fvhdSeIIENUZmjpUYHK
	LQi7Uv89sg2gl3QNRdRSV2DXirCM11/0jHfzLaKzJQdBCCLEWZMFrv/FWxZUZ9ZV3ReFTC
	VlQzYP5hfNinfPwAqJL/kv1eQi/hbqw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=sbg+U1tM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=V0sCG19o;
	spf=pass (imf15.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793660064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bU2XFm23aghLbqwHqLXCouxIYI+ao2+a5o4nlmtbCMg=;
	b=crV+IF8nO3CT/O0n9lBgFBzTLeY6pibfbl/yXNljTiArkYUzYlPVhCPAzEQWFDzwM983ZY
	/iRmTxRvVY+PoFF5u7Nn95rc3m78j2HD82/SSf3VHQzIWkhXg9L3qG5AEaweydNnOWunE1
	MRhPN6ZAU4VmJ3ZSCTXRdufbn0PELsQ=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A2LY9iD3681474
	for <linux-mm@kvack.org>; Mon, 2 Nov 2026 17:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=bU2X
	Fm23aghLbqwHqLXCouxIYI+ao2+a5o4nlmtbCMg=; b=sbg+U1tMRGIzFD+PPuuM
	OGezq8RDKoBsN4FIxGeLbiBAeILuemr+cgQO9sbcuBgcOn/tx+xohj9X/ZEgODIW
	FF9Bkk6GjpnxmETgYMzmh38jU3YbA1tm62tuzxfaqRKaXHxjycSVdk45YdtEd47t
	Rt8MUkaxsFVn8YD68O+4HKyXy709qz4tWDmrNqgrwzYDwlu3NPE4DDW+NhLYtzCj
	RyGs40whGaNIM4k+4yttVVFgwa3K7qjPARlwvQfVrZ4MWR5wPeVe0PaJyJhefG+1
	0Eoe6EUvhIVe1PP9x4HUr3VRwKOCwJ/Ipzw9IyB3uvTZyJUEQ0XnNJJ1/XZAsrcs
	3A==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hq2bnrqe1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:54:23 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-944101e6367so24131585a.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793660063; x=1794264863; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bU2XFm23aghLbqwHqLXCouxIYI+ao2+a5o4nlmtbCMg=;
        b=V0sCG19oszdl/Mjmk8/Wm2OLoM5ImiRkmVmcVlhX5FdHVacx2zfQLwo929I7LOzXJM
         HG7V+LACWJcK1ptOUbn31PGsFs4mK1G8TRMDiSfNEwrniofsZC8c2D/DzpMh73Qyvzt1
         G63X+wpWvFW0IFrC4KRxgQx9jCXpp51mFr6j0mxvRBJdFeN6EPA4DTQiR8mW93z7cKv1
         zegX1ego3meXloItB494iXcvOU69rAVwejUYMWMSq6qqHh0nLVzvfkovooKn5mM9uRTw
         eCK6RHPz2ZzOw9T5/uuppD67D1RUui1lMAtyIvdClFy1u2taH1ATLQwyfoGKbSr3weyp
         EKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793660063; x=1794264863;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bU2XFm23aghLbqwHqLXCouxIYI+ao2+a5o4nlmtbCMg=;
        b=ZXpn7GUTbULuwZ1fPFSRYzieDPL/Zm1Fm99dvFxi+cD0TL53LJ4MSVmQkBJ1tF1CVO
         s8VNYFtiGGRPhHJrmpbFawZCZLnt8COfu7Mwg+tOSrHPHZvfEtFrqtmXha+6CoqmAb8w
         k4KnSY7zzlS1TG3IoB8mXYC+r6chqymvhWJqNtLBczAVa4A4ZWAlYm/pHDBDucj0SJyt
         mx/w/Jdjgd5/yvT6lbTNCGJXDilcn4msMNhFSmg0/+qh8vMHZxDFRXaU7x45hratk4MR
         l7WQOxrjlbEFsuIYr/TQ3+IjGuzQd0xq/OhYL7f/sSI6Gqj6MhmbDZPaylvH25I5lEO4
         m1qQ==
X-Forwarded-Encrypted: i=1; AKwUvByEsM4ecJAuAcVitSMpGl2gNXJYEmjGT4bX/VtsuQJzhMjGqDJ6KK3CFBY3qi7KHC7IO3pjvIRTPw==@kvack.org
X-Gm-Message-State: AFq9FYLalwxQiFzFdhBMftz0gFJ8tWK0xCZAAGn8WPYHKIZZH+/l5MMZ
	EJHFer1UxS+fs2SxlsUoH/DenOVOd3iM1/QOH8YznZcZ5Akr7jBP9y9epl2KyY1kGqDp+Ky60hP
	9JG6+pHRJwpxLDbLeOuI4TfAWwcBYimRbprPlGoQRhRWaR2CX
X-Gm-Gg: AYBFou2Izz8kjE33QCwbhR3wXMeZujf+xGYNLDVWbqT6C3U+V9hhIAi6bChDuFnyNwm
	meqMh2AQeHmNHUHfRXYxuL2vOVrswKI+GBkjv8/O6dny9YaopdmBioXdBZeXSkUTEwC1kfN9rC6
	MvBURzwvgP6ytwdrTkxPIgNtg72/JSYn0+PXjWP3Z3zAnRvPp7ZN1J+A6F9Re59OTyB5AuwYpKX
	t1FZNsmMd+9SwqZLkVudc2LGK5IR3jCeV/AcL8KsSmgbrFdkSOWINjpi/d+ELaCmGwazv0LCxj5
	NreC1EwnKj+MjPmXKsBBnxC5RR0zjGznCK0SWutnrRWx3WV2WzzG62O6QmofsRYEz61fks/p/bg
	aqqqvwrShgnRgq7CCiIlJVPvzCU4QZL73saUAYExY6XJlE9SsLV7TC/6/2BU=
X-Received: by 2002:a05:620a:1999:b0:93c:891b:90f1 with SMTP id af79cd13be357-944133ab8aemr2271861385a.26.1793660062904;
        Mon, 02 Nov 2026 14:54:22 -0800 (PST)
X-Received: by 2002:a05:620a:1999:b0:93c:891b:90f1 with SMTP id af79cd13be357-944133ab8aemr2271857885a.26.1793660062282;
        Mon, 02 Nov 2026 14:54:22 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm24710529f8f.31.2026.11.02.14.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:54:20 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 02 Nov 2026 17:54:06 -0500
Subject: [PATCH 1/8] mm: remove wait_on_page_writeback()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-page-wrappers-v1-1-e7280bdb31f6@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793660051; l=1451;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gOLWNH447008iOY03NZfVDOyDl5wENU6OW/hcTn46/0=;
 b=ubR53IdS4LeN2JRHf1bqY+gdeUIINZD96UWzXfpEu/YVk0R3s0D/8/roJ94WX5WGhqQg6/wf7
 mgpO8imxEYFDsxHSpicb09cc+tN1HuSSr2enwKNVHbZQSEIEpgUcfAv
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=BLcmP1QG c=1 sm=1 tr=0 ts=6ae9149f cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=qBqFc3eaEPVjc8k8qNUA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfX8hTSEYBjrqOf
 Td2n+a5HZNu+xJMPsMp0yHBEZT4+QXuP/16kVh+mC4mFxmY8BemVec3Hok+kBIORg4Kt0Eo0LlY
 sOl7wqcvLbZFXv21KGpqK0KUHeP8JGQ9xc0F41VRbRsNY0McueCJ
X-Proofpoint-ORIG-GUID: hH3E7FnxYv43F7Zw5duCnW6WupaquwW6
X-Proofpoint-GUID: hH3E7FnxYv43F7Zw5duCnW6WupaquwW6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAyMDA5MCBTYWx0ZWRfXx8o1ZDdVLbXm
 //8nL28s4fxlxOp9o7dm9MH+S0T9CLAXmxbnvjor/xKagSoFzWfyip9v1qPgE2UIXwTueZj7fOY
 VfvMXwR5HzGMrtMANQawSBx7l6B6uFLxyqdduQvjfp6Dki3I1B2i1U/i+wfqc0HzuhMDcCHGTgK
 n0vpXSbcnwvxnIFPV3p3C/wDW4bXQzIZaBB1Lny0qAB6OpHtcJ/ijJ1gjz0W/xRjyskCKbvc6Cp
 t5G0Qqn5M5pc7AU0iPTspEBFp7kj83k5UT9gxUOGIS2RlSINBRTEAwLwS9sgZpopcl5tAvqhCIx
 zfIy8FSsNVDJgUhKtfTm9zUITPD80vJPcCuZ30Fy8c/1Y3xObt6vXP4JWV+KOglBQzZ3suEQqdK
 G8bUb8kZSNmK3nPS86ulMA3EBgEQ2a+XYolKLT4EJikD+bVL5fjhfnmPyiQPCXvIP8xb23oi5LI
 DLZv6u/GV7Blv3dlTHQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11954
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 lowpriorityscore=10 bulkscore=10
 suspectscore=0 priorityscore=1501 impostorscore=10 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611020090
X-Stat-Signature: 4ntwx14hcwz7gz8kbacog537ktcijeqk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EA4EA000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793660064-747043
X-HE-Meta: U2FsdGVkX19W1YHN5kRmS0vuWYOoxJapmJ2D2fSStBYR74xRtF4AL+S/gvrnHOnK3w28Nb20thnkdF9VB5zt7q74YZ1lMI7hTI8gpYDAjeHTc3v7NWV/PDkP63iis3kaQ6P+Np0vqU/ZxNBd8ZccIyhHuwDOxwyzTF2I2WTT2NQlNYMZcV2e7yGJUWfgbuOBj60a6aaC2wWlwdEkj26Sx7PcV9dHmA9DBrUFJ5dlpeSwkY7bVYIHSb+nABK6vsgBLT3sNB7pBC7toAiB6sxYR2UQ4k9gCfPZ9TTKiIRtJVfb+fNxFqSOqH+gfQ5DwCLXumlEuQFzNs7Gd3W77oKlIARcjozb1b2kzLwm7zr7sw551DjFl3KtCMEnAQR8VOdaHx8uO2eeluZN4AEiJyk1f44wYrGIrSL0T/6vtVRWKxwqL/cO8bR+JFUzEoRkMpmjBkVB6GhqNKdywWgNGxA+j9DDL55f+EjZQ4tWezFU06m3pxEcR3+IcjxNjXGXZUuIZtI8x/8+SrAgAml7RYqN7Nr7d5agtbDOo/06M32RDJzSHjxv2dFNWh2glhfAtzOqeq4NJQk28p56OVqrC1383g0pPCUtfP3Vr6faiR9VVj0cJxYXgOh0dR0zvxDObSj3BzKPpe44k5UfX5nmxMd9iDpZMubDd/YZgOgwtiR313qoH6OCbHWtdRS3/2ZCN96r0RDU45GMvJNkNB4cjVkREELv6Ufh4HBu8fZNiGK84xHE+4C3NmRy6wZMojOusItv7C/Ls1UcwIeHysb94zkiO71aUsCIA718Tbl4cNxsR9ISMtjSW5+C0tzxhUVrMpxuIS0nutg/PQ8GUFofwY9HDaG2J7qLkdP5oGUjCW7QOnmRylVnm9hN+PT18CyLDHu7XhS3XgaRagIB1/3Ce7hEngpcY9m71b04PTPV84hF5mAD50ZO3KZ/jwr1L+NTnLQSgeSCpK3mI0nKmT0drLZ
 8BopwzMQ
 RPTJ6GY3xHwDHqdr5QEjFHK5EaD81Nabn7kX9xIUI7UN9AwiBzPT2gcyMfNqiQjw6BxzjZfPIhoo2tN3mhK5mWI8rteBNQzJO/429icqb4VyzgLmypSBJ8ffWAiOV+eVKoMDEXNdGGcpg8yo1/BCCk524Jnnn/ArLolgTKuYTsa9MGoRgJHMeYfrraBtYPsrzgQUnUM4F2GFAl4gtFef1XI5AiLAZaBNVNarFLn/Ux8Tk+q4I/dwxKNtk1fmuGJ9oGlCzM2TkjsWw2SWrAw1a64xiKA913w0OG+EBINgcuhd4ewtaLVRmrLUN3bfKRiUy65vs8x45EETOYoWQQmvPZawFyPXdw9QkOaABCK59Uqe86nYmCsavlzj8xMyWygaVUuQoVZtFjvMqZXct1CkyssoXrNmci3RNPQImQhxE5V5kw9m9a1R0xmzDfvJZ8ynXzA5qaRX5JJ10YEbTRa15qpusl8x6uxWH535xKUYpyhZA96Pet0pPGIMVXoj866FVt7jBrrfBcJVEHU5KQeu3fL+4YC0+X6XEGzaAQouvS/JFna7wbSsN0r0+LV3QV8aFZoVVpu23bbNFzgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The last caller was converted to folio_wait_writeback(), so drop the
wait_on_page_writeback() compatibility wrapper and its declaration.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h | 1 -
 mm/folio-compat.c       | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 73af18a37367..c0f7c06dc6fd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1299,7 +1299,6 @@ static inline int folio_wait_locked_killable(struct folio *folio)
 }
 
 void folio_end_read(struct folio *folio, bool success);
-void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 6212fdd6761a..f880110ac980 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -23,12 +23,6 @@ void end_page_writeback(struct page *page)
 }
 EXPORT_SYMBOL(end_page_writeback);
 
-void wait_on_page_writeback(struct page *page)
-{
-	return folio_wait_writeback(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));

-- 
2.39.5


