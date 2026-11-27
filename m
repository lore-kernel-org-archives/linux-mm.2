Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBD9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=aXR/vobn
Received: by kanga.kvack.org (Postfix)
	id 905506B05B2; Fri, 27 Nov 2026 08:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5E66B05B3; Fri, 27 Nov 2026 08:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D896B05B4; Fri, 27 Nov 2026 08:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3868F6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:00:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFD8E1C3661
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:00:37 +0000 (UTC)
X-FDA: 85480908114.21.1C2237D
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A5DD4001C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:00:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="aXR/vobn";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1795784435;
	b=OCo4t6oD1E7iDVxVejGZnCiG2C79oDFoUyLhLpifdz+zYuXeTYlYS091ffhwrQea+Ii37Q
	3606O0vMX8JKnlcFG60cQpP9+ytj9BZ26URosalJsfx/XsfOFvVou3mWHrIUfWSsgpQSW7
	vPG7B8QrIGaStDxBTdmp5bvRYx+9I00=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795784435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7teMupy8MF4YjMpK/hwe3YNA82UcxCnXtUs1S5alNwo=;
	b=OjH8EpkxQqptIjFHNPr3nzsLMBG37GDtID1IKLExV2hahR5CzLN0oaB4K1OtuvBCm96jZT
	vD9Cf0Era6ANM7/JwMschusn59AgY/ueplGxOcB/Evi67k4v1groONbmU9h6UAVDOe2bpw
	7ZUkVur7xvLX24xQPRG2n65NXDnzheU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b="aXR/vobn";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARCh0a54170487
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:00:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=7teMupy8MF4YjMpK/hwe3YNA82UcxCnXtUs1S
	5alNwo=; b=aXR/vobn8u2liUuC4mC3z46nuYvERdAVdlwRS3iXR7MxMxnZaaeQZ
	OGATlvmouiioIpYkJh9/z4lN3mdrmb7e1Siao+wlkFpxLtC9iwm/uH5+T9D3JASN
	MhOZ98t4b/75WfMpM/Pi846qnf9EkMtRAxBNv8VQtqOTQQor9FjnKbZg4pTPuvvp
	WUlw7bKtAfa+UEZ3zeTeO8bGeRSiXlQH2Pd8PmKPpesz/258zUrWttMNy9Jx17fw
	EWEwTHMh6ucq0dhvTeLWqN2iC482nOE59FbCgw/zimqJKFkZLeW/SLAKEg0goMAD
	8ehAFoXuaAvUEvpBM2zwzvovurO2fvaYA==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j74n899cf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:00:33 -0800 (PST)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6bb639459e8so1692622a12.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 05:00:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795784432; cv=none;
        d=google.com; s=arc-20260327;
        b=V9hmV5vLtWRNufRfIQ1J1TULN9TWdsUgrcbfykT7Qw4BPsWZEt2+NCTUrfpBHAz/Pr
         Xz2ZVb2Mtj83OOhkDVXt0JlHvjqxkJe4Nx9oYazSq+B88G1iUmLED/lwf65UG+EAF/Jj
         M8UG58MEDsh6bup0IaffFPejrWyx/hPml+cJ8aCiOi16bMhLtRi8nWDt99YI9RFLOp+A
         w2MJD3ZSxtQEbqek47BN5H4epDJMUU8SvjlvyVboy8XK+W3yZprX5X4lI+GhPIhZ1lFX
         0OW2qaFOHKKfYWzhGLhL2cJFa4xPz86VhKsFp7FN6R0tEvL7Ddy+VVcIXC2WD3HVa1hU
         wOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=U58PdAKYgWEy9xrKD7vJr8dnYymoYkrZQQMc9UOq6KE=;
        fh=AJzh6KtG/ssNyj9lxPl65tbdKsfIfLSFo13u3gfAsA8=;
        b=EyGRYN0oK9NJRsOIxOXqozXZ4LRUCox4IX3/TYomyAEoy7S1CuMqPp+uk6w1Bs99TC
         ev03dPkrabnt71rReSfbBDQ8X/YtXwI5BUZzxraTDG7g8uuAUmrCbL8b7vCrLdWyBKzu
         GA5/Kr3gk+J73uaHXTEqjoCqdlS0qbkUlA+78OpvcJ+nzjZbQBB7SM5vo7+LZef7mkn2
         QeyRbfKILhHiCINxXzV2GlnSm7YKxL/YqVpuZpRzVGt+E+vWz/i5e4qpWli6heKuUtCk
         QVdg/ZLRHJ2LcoFS/nndl4SzAEMoLucrDWIC9NXt8YhMgPAy2Jd5eWW9cayQD6PfDe1h
         3QsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795784432; x=1796389232;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U58PdAKYgWEy9xrKD7vJr8dnYymoYkrZQQMc9UOq6KE=;
        b=O2y2GYr6VqE4urK1vfYbNGVRzlA/c8F0Afu1LkiTjS2EEmHiGgjgPWt5m4PHWztKUN
         H6V/Any86YK5ucgAh3QY3OpkvbJtpcy9dQGYuesUUJ1Qe6i4xWcgMXtdkMMCT0bjdVZ/
         q27jYiWoqZR2owNF960b+F2HaP0lb1dcTBm4EvTMOlwIKcHLOLKnAoRZ5KbBL/Tk+xpZ
         GV1S5u20cSymwhbpqAlgAXoZIUrruvyhyvqdHA8tGqjxUptDTL/aDboc72c+r1JLCvub
         kMDAuwNFSkzc3q+83NkwNqvWCbBPjlSoDbzXUKc2aZxYOe8Z/5aRAkHZxTsQ1OJ2DB89
         ZKDw==
X-Forwarded-Encrypted: i=1; AL+hErE4vj77IkKPgrKfVHGc52mTWEtM6Lq3YlNy9eDl+Gxeu1F8P7GNVjIRj3o2fOY9nuo1IFzhQxQiPw==@kvack.org
X-Gm-Message-State: APuU4Z9EtuwuQaSFWtoa1Rz+BsZM1TP6/zD2f9ro/poe/Nny22BZKUSH
	Wax+rjN+7bo/ruEXXPqvGjNsGWJIvc7KBuTCj3Pog/5HxXe4N5yPXLgVKPb2VDbhQH7lG7ft5Sv
	+90hZxSYDDVuTXSHXmX15PxdXdZSMqXWnbQLxgjlMdpkVTFH1xtD7ZkBD30SmwuOr5XDaQUQFbJ
	0dJLvwW9lwO67Zj/CzW+nx1bCWMQ==
X-Gm-Gg: AZFdTZfQycq19ZN8i4wEmpZbqJ1RaiiXOwuPQ8Klms55zhXic4uLqQlSpA40MxDJ500
	oCm6dQTdx0EvoJ5Uy73IEyjcKfQj2HnuHKLfiKxZR50eyN4e8Nt/SFVHe7RNTPG9SHvWmMYoif4
	jlq2D8tLrKCv837737fqdyskFw1c5M/EjtfU/WbgHqsTg+86JZnPt+vx4n23xnF+iB4v0OVxIu2
	Mvlu3Hfxl6rDeJZ
X-Received: by 2002:a05:6402:24a3:b0:6bb:3e3f:52ec with SMTP id 4fb4d7f45d1cf-6bb3e3f5e7dmr5705803a12.22.1795784432008;
        Fri, 27 Nov 2026 05:00:32 -0800 (PST)
X-Received: by 2002:a05:6402:24a3:b0:6bb:3e3f:52ec with SMTP id
 4fb4d7f45d1cf-6bb3e3f5e7dmr5705763a12.22.1795784431451; Fri, 27 Nov 2026
 05:00:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr> <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
 <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com> <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
In-Reply-To: <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 27 Nov 2026 14:00:18 +0100
X-Gm-Features: Aa3M54rvqZUJkH2JRhumkYIwpkF7HMuEByZ3mHW2QZ8e9F4sQ-Co7N_mhVDAmHc
Message-ID: <CAEmasaV0DX+7=GhH2k_AzqSs=0gHsEdTEr9GFPg=e5Qr0r-MRg@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Baoquan He <baoquan.he@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Youngjun Park <youngjun.park@lge.com>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: YFXAkI5ER3jcWHR3uM0BmRWG5fLBAsPm
X-Proofpoint-GUID: YFXAkI5ER3jcWHR3uM0BmRWG5fLBAsPm
X-Authority-Analysis: v=2.4 cv=A4n5rKWG c=1 sm=1 tr=0 ts=6b097ef1 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=_1IyUuN4QrATX339ibzo:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=Zl66_HLDLhFR8LBIjjkA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1MSBTYWx0ZWRfXzCyHxaNWJlII
 X9GElgNH7+wCkced6G8/y1z0eXS1FWfhVqhQogW3NyPlIAFFJI4f+7mpKRoEuq9Av354NDXAJDi
 e/K+jpSpVVgIijc4WERTSl56gZtzbS0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1MSBTYWx0ZWRfX/IkAS25IpavR
 yzqWcF0TlWrXEZNDcs2YejnNYE8Qz1TigG4DcV5eSblmR2bw7sjHV6H4AZU894vn2NsnKfoVI1k
 vcSelHKrE0BCMJcKfSHe5zjraHpPBgOhD9nlW1OY1Nip0nEMY8pYlr9JjQs6TgzF7e/cl14j9gN
 nxpHZ+KQ5r8elpotFwxbVJ4+Z7at6cRHnkJxC7/itrPHkbOQQg5xIQVAWQJ7/cL3TrugH/RqUqF
 jvxkRTieztbjoqmBKEp/qc4aOtcE3vSunAakazDJGrekEKRLFsYqeO0WFm4xQwN5EkNcBCGSjnR
 D5476FhFSC91osGJy0hnCRFzbDlfTd9+knSAXhHATEiC8O4jyIZui/q3X8T8E6++YFLAQ1VmPmZ
 spU5mM/CS2zI/XUKbF6UxGWA1zGP7xYXo673+o+ilnO8qNLRsMmcrSnylQ9x/ttixUIn+3WmbRv
 p9t/DnqsBmLxAcRhVMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_01,2025-10-01_01
X-Stat-Signature: n11u1g6aqo5k3mmcp5nqz1nkz469yxjb
X-Rspamd-Queue-Id: 1A5DD4001C
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795784434-505041
X-HE-Meta: U2FsdGVkX1+vNi2oT0ACV0qetrIRquSQTcNkOnnzycr+FjuIZ7D3IJJG8uEiTM7ytzd7SopwJtEVnmVfBwZQOrHfT4htmFj0oOXX6YjIKL7a6Tz8A0qFkU9wwZTcRxiFf5oyxnghbJdyrsU5/nTO67QaGZNT0WeQaUJASBB+lUr1eQ0QS1NgEVdxAS+ceB4lTtCB9cpYXdio9Sax17R1iMdSZw0zq4y5iWHeWw53g/NHMccZMtIO4AK/wb8voQPHGPSuGfj67lDGJgj0UFDl+bxnzMVnzxcZjYQaJpxegjcmBcwfc7/cJDvMB4DdXIYU57TuZgAm7zaF+YLJZHHDBRAcUD8BQGKEg4CatcMaiqrk/ApSTfOL3267N74sRTdb1CLjXY4tTZx8ZAi36Dt+8luR6MyY1BfN0H1YP749tgJIMxRAp+Rq7523SPApFs7Us/Xxw8BRGBQ6XE7Mw21XUDZbMcdm+lnuAuRFNqscpesWLHriD6885CMGAEum5//06xAihIVt9UPU7hYDkuhRtujN1cboTIoomd3QdP8GL/NEWl9G66oBdvvbaXpQJJhrcYkNBJl3/XRhSRun6FTRxAhQBTr41ELmB6XR0OLUBWZ4BMNnxS1p0Z1KhvduHVJEGyzSin+J4xqlTcUj571Jw8iB3gtJly9vOwlHGZ44drkYZOK13IZR2WIsPFxzgbU7etPJZYWikR0VuvID/tqcDF9B5u6f4v7ls4Yb1vZ7rowKDZ3DpVvoi23zyxCe9FirVXaixKmSCkk2sdBuuKUdvlzHsbjzDuBUPN0rnglmobfYfAjkXod/CG/RLeLcXjE7gDaXA+Kx2auFYS0QSonz5yCBv+obKYAmfdlAL7DDjd3KpMSPq0xGM7glJGaDP1nMKl8umzvdqcuKI3tmZLva4qIkvfEIBt3llmI/r1LLpDylorF/mZCEtNc1bT9md9uBVTIVYdymSyQ/piPrwj+
 mmfY7/mn
 AA64i+uWDSDo+megoe7fl20SVqxsIz6nI5dBzbVLRxaaZ/NQymFz/9CKCsPFTDdtkT3+K9QZn8xU3jWNRzO1aE/f6L87jBnIFudtYqzih9CLMYV757g8keFwo/2+127EShLHLkeFaUaIUwB1saL03MVzIociAwAal/9vUpF/I9NyP/HRFPukJhGy0rzN8IcNg1qODRXZ6n7kU7JepRl0xs6YAa2XqyNFhsJctKp6BVkNK+3hegj4Zr4Npv6YycbbqtRko9YkAwTxg0OZ86sQ+CDCgnRq2cwW4TrJZdiy2lSf5rJPu5yxGWUIlDnw4fk0lGyuJBS7I1EYdJZEnijyDPTi/0zq/NVTedqW4Dbl/OK0m71LeSX3HkHze8UlZJxkUXF83g9KVOf42PSJb+4RKAOEZbwqkZrvn2pEwe9UZ/a37Q6SSbNKv2RXmdeDA3HD9qMel7+YByTEf7dciHUNJebQ136f9Y4SgFh4qX1ZwjeS+beiCzt6FDN9d0Ot5KGgAivyl3TbSE/nvjPj6YIbR97Lh2JT+lKOUXjy/ufLy/xJb4www44G6l1HFQsmx7nGiHcXFIyJnbJGN3eZvJHicP9GuZwryQuZzIkKzEN8E4Jp5vwdL9opXFbkT57QuvSFh5e474fdXjJEeFX48a6nRmFxgvzghCgMyWSC7jrlSstKjPymHdYeUJyA8Xbe58faV7rDeNs2zTwnk8um4I+lZc8Evc614OAvQdlnEiOAmDAgK8eFwP28xgwIf9Vlw9in3PKzE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 5:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >
> On 11/26/26 16:01, Alexandre Ghiti wrote:
> > Hi David,
> >
> > On Thu, Nov 26, 2026 at 1:54=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >>>
> >> On 11/26/26 10:42, Alexandre Ghiti wrote:
> >>> do_swap_page() frees the swap cache of an exclusive folio on a write
> >>> fault only. A folio loaded from zswap is dirty: zswap drops its copy =
on
> >>> load, so the slot no longer holds the data and only reserves swap spa=
ce
> >>> until the folio is reclaimed again or its owner exits.
> >>>
> >>> Such folios add up, and they are expensive to free at exit: on a large
> >>> production workload, the exit time doubled when zswap was enabled. A
> >>> third of the increase comes from the folios left in the swap cache,
> >>> each costing about 3x a resident page to tear down; the rest comes fr=
om
> >>> freeing the zswap entries.
> >>>
> >>> So free the swap cache of an exclusive dirty folio as well, so that t=
he
> >>> slot is released at swapin, as is already done on an exclusive write
> >>> fault. The folio is dirty, so it would get written out again anyway:
> >>> the only cost is a new slot allocation on its next reclaim, which wri=
te
> >>> faults already pay.
> >>>
> >>> On the production workload, this patch removed that third: the exit t=
ime
> >>> decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
> >>> memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
> >>> guest (mean +- stddev of 9 runs):
> >>>
> >>>                      base            patched
> >>>   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
> >>>
> >>> The cost is paid by folios that keep cycling between zswap and memory:
> >>> each reclaim allocates a new slot and adds the folio to the swap cache
> >>> again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
> >>> not measurable (mean +- stddev of 5 runs on bare metal):
> >>>
> >>>                        base            patched
> >>>   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
> >>>   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
> >>>
> >>> In the worst case, random reads over 4 GiB of anonymous memory in a
> >>> 3 GiB memcg, so that half the reads are zswap read faults and the task
> >>> spends all its time in the kernel, throughput drops by 1.1-1.4%
> >>> (mean +- stddev of 5 runs on bare metal):
> >>>
> >>>                        base            patched
> >>>   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
> >>>   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)
> >>>
> >>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> >>> ---
> >>>
> >>> Notes:
> >>>     Previous discussion:
> >>>     https://lore.kernel.org/all/CAGsJ_4xBtKGqXFP4zvp+Qn+tb4X7aCvXn+wq=
Dqot_cXR92DjhQ@mail.gmail.com/
> >>>
> >>>  mm/memory.c | 9 ++++++---
> >>>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index d477a4f986bc..dac0f0a24bc7 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -4711,10 +4711,13 @@ static inline bool should_try_to_free_swap(st=
ruct swap_info_struct *si,
> >>>               return true;
> >>>
> >>>       /*
> >>> -      * Free the swapcache only if we are the exclusive user and
> >>> -      * this is a write fault.
> >>> +      * Free the swapcache only if we are the exclusive user and thi=
s is a
> >>> +      * write fault, or the folio is dirty: its copy in the swap slo=
t is
> >>> +      * stale then (zswap loads are exclusive and dirty the folio), =
so the
> >>> +      * slot only holds swap space.
> >>>        */
> >>> -     return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
> >>> +     return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
> >>> +                          folio_test_dirty(folio));
> >>
> >> Why not more readable as
> >>
> >> if (!exclusive)
> >>         return false;
> >> return (fault_flags & FAULT_FLAG_WRITE) || folio_test_dirty(folio);
> >
> > Agree, I'll change that for v2.
> >
> >>
> >> But ... isn't this zswap specific? Why do we have zswap specific stuff=
 in this
> >> common code?
> >>
> >> The comment already gives away that something is not quite right here.
> >
> > I am mostly interested in the zswap benefits, but nothing is zswap
> > specific here: do_swap_page() can also find a dirty folio in the swap
> > cache when reclaim bailed out before writeout, or when the swap write
> > failed. In all those cases, the copy in the slot is stale, so the slot
> > only reserves swap space. zswap is simply the common case, since
> > zswap_load() dirties the folio.
> >
> > What do you think?
>
> If it's generic, then the comment shouldn't mention zswap in the comment =
:)
>
> And the patch description should be all about zswap.
>
> And we should measure the effect without zswap.
>
> So, folio dirty -> We'd need another writeback because the content on dis=
k is stale.
>
> If we reclaim swap, the next reclaim run will have to re-allocate one.
>
>
> But why is this "is dirty" linked to exclusive?
>
> What if we did
>
> /*
>  * Free the swapcache if the folio is already dirty, or if we will dirty =
it
>  * immediately afterwards by writing to it.
>  */
> if (folio_test_dirty(folio))
>         return true;
> return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
>

Just microbenchmarked without the exclusive check. That handles the
case where a process zswapped out a bunch of pages, forked a child,
the parent zswaps in a page which is then non-exclusive and the child
reads the
  same page: the page is non-exclusive but the swap count drops to
zero and then the swap slot gets freed.

                                        exclusive check     without
    swap cache after reads     2048 MiB           0 MiB
    exit time                            388 +- 39 ms     229 +- 6 ms   (-4=
1%)

  And no change for the exclusive case (504 +- 20 vs 499 +- 11 ms)

I'll send the v2 soon.

Thanks again,

Alex

> --
> Cheers,
>
> David

