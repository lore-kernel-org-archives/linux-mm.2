Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 525C1606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=W0M1fBkG;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xH+fzwXE
Received: by kanga.kvack.org (Postfix)
	id 0B7DE6B05BD; Tue, 17 Nov 2026 23:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090456B05BE; Tue, 17 Nov 2026 23:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC04B6B05BF; Tue, 17 Nov 2026 23:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAA3E6B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F822C018C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:24 +0000 (UTC)
X-FDA: 85446960648.19.7F4FC2A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id D04B640003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=W0M1fBkG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xH+fzwXE;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNP9a6jLUlKCdTaahR8z6VO1PL6EFsLdkPdFbzFnzHQ=;
	b=kKP7ercyx34O5mg6jWsKFRn0W7ZpvnVN4kRT0aog9OxuTswEaLOWtMbx5dRYqMBihpRGH0
	9BOpxZzyAImFgAHeUFhnKY1i0WzS8qhWUrnGbiF1IyMJywnXmxviThXA+MRwKsbZ5q63rv
	KHSAIRS9W7FmwI5RmVMPm58T05N7LTQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=W0M1fBkG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xH+fzwXE;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976162;
	b=M2Wxc0G3wuO+AkpNBEByCMH0pmk8cJct++fN14JG9EkN9coqbV7V1Zp+qLfOBqJUiYrcEC
	aVly6Lw5Iu+X/+2Gv24Y3/mp/lFjigCMInmsuyuc4jA5VPMD5JkqdBIwj89EJguEF5RjLW
	mH3Wy+/TOVK88pgxsTgSWWFX7kEED1g=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XNBw3917806
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=oNP9
	a6jLUlKCdTaahR8z6VO1PL6EFsLdkPdFbzFnzHQ=; b=W0M1fBkGR74M9DrJBxNr
	Sy35Rs/B5YmTpzC+TrBM7+r6DY5gyJ7+eaqRnl+tm7543UEpFfUWSpIg4M8KQoXs
	WHOvGW/GBRG6FqJbriLuUUbINLHSwlNj+D/i2tfYh8ZXxHlLFIYloWEk1f1bLd0a
	3sbrZWmN3lwWupdLp6+FOl4iGD90mujCP23YEsk71gxz828lxX3044MrZ14bhkzr
	HpcKOyeUxEkP95yVz4+/TikS4sprev/fsSKvY9f5cZ1eI1U9GPWhay2176YStBXA
	NLf61FGInRcqnbvaesSIvLfD8l+R9I5QC4AZOrRFIq7MzmIQWrXXf8vwNBtbUrN2
	Cw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu99f2e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:20 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93f3969a2a7so87560185a.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976160; x=1795580960; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oNP9a6jLUlKCdTaahR8z6VO1PL6EFsLdkPdFbzFnzHQ=;
        b=xH+fzwXEWoSgsRrMEcuLNkGDCCo2xCugNNz8xQjPwupEBFo4nh1rtVIcjFJ6I43z6g
         G9AgISw/cx3VHmszeoyRkKFkq2nDPkru+bFPTdQsQBQ2CS5+eu2mQozywR7fD80G1o+O
         FtSe8pby+ArDsPQIKw8HZWXGyC0DlS47k6mTBaN7DRHwejApJ8iY6kqSZe7WoPWfMcrh
         MYxMpiOjMqFLEUL3WHg7+cAaceYHYrgNPTfj9VNwcOG44f/WaGSybOB6auLpWH6aeRmv
         e5Iyw5Q00ry4kmK9Rf/IHMxpHKve1l5LMAUnbzBuw3Bv6PImelFbEihaEMS5QpO9neQK
         c3SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976160; x=1795580960;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oNP9a6jLUlKCdTaahR8z6VO1PL6EFsLdkPdFbzFnzHQ=;
        b=S8MOUfRIfkt/50xXGV9MCLkr8jGVDV/p/t4+oByTfJmqXRTdz+pYd4WrxNnjhPhjo8
         KTJ04X7R5LSCJ5YBjFX6fLf2gMOyxkH2kYCA5RbpUJb6IZtkmFUil828um3GSgHFyAha
         mDHWJ+3VuRP4e3YpTgtiLsE+sK5IO1RLVp0Fz70tNiY8w4eyNCcM2r32PInu550wPJzS
         UYmrujxyVAJ2V3A8D7ZDGZ41+Fgx02G8JgOAVh76znhJtUxt/38mhAwq5snFMEj6Oig8
         aMxLtwwkoZ5hP4naW50BW9F/0kJ0NUGXsqQQtz0tHUZC8uBA/dXFqPe8V5ZVXMFd4hJP
         Qumw==
X-Gm-Message-State: APuU4Z/sv0Zzq0tzHdvo+ucqKpuUtNUCvnUqtJQFm6AG/FmyjVLGqi24
	6/wkIIc54sZ/3/TO681YmxNzc4PMgIZj8lkyq8EsaJZ1E7PcyApuHx/yCxZrHR357ds9KMf6eCI
	oRmA9DCLYJb7xMhDagu8QZUjkh+krByagpnqGYWBOidC3IwX8
X-Gm-Gg: AYBFou3JLNqvviYPuY8TeGQinskXDXXmjhAzR2ctD+Tuelr6wR2sdVw8dBXryvVM8VB
	bwGxNuK2BP9y942owz3mUa2Wv4PvtOI+qQRr+z38gaaEXx8pXPkyY6FHmkAQIXo4o1hcRlTEmWi
	iIF2njpWHBSOPyved1kIZMgZ9c27X24kp+vj/Wh+2Gx6eDK0iLcE7u88RZVGoKRDXEBjSWQvHce
	5ayylHL518A5/dB0P25piULmuJKTy4iCgLTEIgjLsaX/yb+p6Lr8UTn1DwJ/BKPLd8+3L8oi9QI
	dsaELOCeCiYxUD2EWAKXfqrxFsgXyqDgSxQpL+t41i+J9yvVO0GYJAcs9jHzxUn+NxRdZ7sLICv
	/Zho1hg8L/6HuDJszVQWUyW9fpL5Vz/UBl4zpwZuXERx7WX6ygX59k+QTily9yueLFnw6S5T1ET
	5GlPpnJzKJFeX/cARu0Q==
X-Received: by 2002:a05:620a:6c8a:b0:93f:1f22:96a4 with SMTP id af79cd13be357-94999574eacmr293095885a.29.1794976160373;
        Tue, 17 Nov 2026 20:29:20 -0800 (PST)
X-Received: by 2002:a05:620a:6c8a:b0:93f:1f22:96a4 with SMTP id af79cd13be357-94999574eacmr293089285a.29.1794976159730;
        Tue, 17 Nov 2026 20:29:19 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:19 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:48 -0500
Subject: [PATCH v3 8/9] mm/migrate_device: do not migrate a uffd-protected
 zero page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261117-uffd-state-fixes-v3-8-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
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
        linux-fsdevel@vger.kernel.org,
        =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=5760;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yLBeSaScpfcnWP3GTIZB32bGuoptmvLUEbtIcAlGdHM=;
 b=My0spsbuiHMwD39tEUzhalSGpyI1KepnMNGVOGi0pW44BxpyK1b2D+HcpBD6q4XsiHcZ7YUx1
 8Nb13C9ol+0DOkyotphEWf/Xp7KcNWOmkctH3ozT4GAn41fre1wcM22
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S6FMU4sP c=1 sm=1 tr=0 ts=6afd29a0 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8
 a=9jRdOu3wAAAA:8 a=e5mUnYsNAAAA:8 a=Ikd4Dj_1AAAA:8 a=cMyuK6MtPHKtACrh3PYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
 a=ZE6KLimJVUuLrTuGpvhn:22 a=Vxmtnl_E_bksehYqCbjh:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX0ChridIFhCK2
 9aZEufl9ae425tCLL/+L/MtqOzNHwHmrW1ssbjTdnuvqpA4LZmEJOJxT+q6KxKZDEj4XhF73Dqm
 MPzOtMP4Pj+iNMmJyXKFvJcyUkOL0pRyJF7Fm9SXOgB3xZv5NEFs8yOEkixbOXu4rINre/NAQ23
 ImU7sG+CBxEy/Ir/z6bt15FxebHcOmKnaC+9oQ24ZhYbOI7qvUnyT11Vave4dNSQbFkurYaVP/p
 APpXZsON3dUw2m39nCQlC4zCWiWa+rSP7pccBKjrVS+aHyjfi6Z26dksov+hrzdsTj/MFgng5Vv
 RvpN8kHDPYGeh781TWRElNAyzT3pI22IkQyxq5byYVvyBzQe6Iu1HVdrl1x+rnzHnij1bkIxdoy
 CAq/soWgoLKLPRdGs8uy//Oy9GGwbkODJlUiCQIUYIrqTv5w4hFg+Qj9Pauv/d4m4/TBUXUKHI2
 YEVk7DB6oONYIfPCJOw==
X-Proofpoint-ORIG-GUID: ottQj59SHuv9ZQPWbq71Hg4-IEsag1Xu
X-Proofpoint-GUID: ottQj59SHuv9ZQPWbq71Hg4-IEsag1Xu
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXxLEkoO0EKcDb
 stL4hdoEQ71HXhcpLeuaVVuF7XDvLfsFZ0o7zAtilre1fC/4Q+V2WEbblLvDJqzdSFiFfatqdpG
 204yy95XLELY7Afzi1rC9rcjLG6KTjpuUNbckljZYzQe8/Gj6F8x
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 phishscore=0 impostorscore=10
 spamscore=0 lowpriorityscore=10 priorityscore=1501 adultscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180017
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D04B640003
X-Stat-Signature: 3rt3tg3tqxidyt7bmbqeba6czbs73upg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794976161-355008
X-HE-Meta: U2FsdGVkX1/VFwKntwkUS0XeLYu0vAJyB4VVpctTJvZrrEvmqka/qd/E/RReJVFXcvQKdChaLYFD1NFn/l3gi/23KBnzTpKFvWkPBYsexhD56S2T1KRWsnU3tpl/VRG1ukULZBXvCo8ToF50WjwRQ3Ff/g3zD4AdDEMsFoPnrlrsYHOiXEYVDfIFJMLrMoGAprexBxH05uyQGCFjA7hiBcMY/lPOZiqKv4KNtPPM4PHGvxB5PKUc7uSwQRBujpQ5tzwCkFaDRjgfsYWGRx0fI0CN5UXaWIOyWFP16NgOtOxR2XXU+s8nto6X3J/2JT7lz9Ijki0vbAdeJwsmK5ZDLiEfGYCVBzDSe4bokN6ufAEhqpfMF3SbIQQ2NRbf7tX0J9A68lpbkowg2l6BqO6llV/Zq7BH50rRPRUZQhByobQ1tONP+uo/chNCR0nDVF51/NZEX3hMu78V6dew+nbMJFvrk7qm812DzGWlrJyhvzgkMI+zuEjCDwV5NlmCVRMLokpR+0e15MP3c6B5XIQ0QIj/7Sg0IUAWvOWy1SIzwgjGiMibegPzFoeVHBhKyaJ0jm2EwUdHZWEgdmOZWfbRHJSgv9ywNUZIIiJbr6C/Kew0TmjPmeep0wcVgrCZtUwCn0mtRv9fL01S4WusvSEtFkACkjybnwF7y6y76NHtrsfVtCm/NxMLJlKh7poJON1Y4v2jDdyJYlYfIup4boTcTI7MXOTMS0XSmlx2yvNn3hUFpvNi+qkn6XSxnVBHiKu0e+CC6v2xNL16T86sUKTJ2arksGU7Bw9yCMz91TcmVtx3gaRXeakwwNSAh3R6ekYMIVkQmFeXTvkMSKgNEa3sapDsgjUDLg6aHKrdDH2iu0qt6Dd6uQsojX8UY/OMQERrm2OH2EooSNe+DIoPNmp47OP2Oxgt7hrL32QhcY+Kjf26wGh6/cxKez421LizXpsYoAAyY8XSijSjbZCKp45
 xcJ5DdkL
 oztWsNwz9sM0yVVSWaoY01sT0rJE2YU5P7GoX2utJ/exVraGCWOEhYN16uC+3dQP2YKCsKHpUdreQGSskC6lBF6GCR9/7crew8hnydoa9tJkKxWcqfroIRllbyLlj+3xJ7F1cw5Un9zcF95BgFhznZK5Je50mVHZ2ZY42G+Qrd34KMXmW5mzC3Mr2+F0/tr7fdxqJo+sXkWQWYUFvT5t9jRptyOCgzMS9k4DB8vl076GzUhYGthTe6HDheWUjQE6mu35NxYjAbxm9vkLkhFIeV0cFP+NUzz6ir/VWkCy1iN9cKbyvKn5IGRMj1673+0/f4dw/D0hTxR636/eTYMpKhJZDRf5VPET03vML6u2JpYSwy07Qv5vtBoh3+PoPlC9dgOMHVXyS/dq3ZBTbGdfkpnP52OPKMGojOipLmJIVNHnTi07zVS69aT0dPJldjdM7/jPwGFDkK2bEgVv3H9Mn07tmaDYYQHDJLbJtZ7Nt6X1gpDbR7jtonuYvgb6bhPNwcZU0SNVX4r0SP/DmpD2/eAtY3umdZG1nh+aykjAP6iWVa5Fgy/0bLDryeIaKPZ2+4juwha9DjuJwOGZIRgmCbWo2de0HWOdRK+AfU1dd25Rg8mKyQ4Fo6CIiJc9TTscSiAuUh6FCYabYOBMOqBudpJ7oQjKQNiBYomQJdzp3w2IwbnXnw6gKO0ZxKKxUH+WsX80UpRVkkqifj5yCRKq1XqJPxDXQaZKj68mVWz5uTj/UZCDpFHjE9GR6rQcnU7QZf3BD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device migration replaces a PTE that maps the zero page with a new PTE
that is built only from the VMA flags, so its userfaultfd WP or RWP
protection is lost. The same applies to the huge zero PMD. Writes and
accesses to the page are then no longer reported to userfaultfd.

To fix it, do not migrate a uffd-protected zero page. Skip it during
collection, and check again under the page table lock before inserting,
as another thread can protect the page after it was collected.

The alternative would be to carry the uffd state over to the new entry,
but a uffd-protected zero page in a range that a driver migrates should
be rare.

While at it, read the PMD once with pmdp_get() in
migrate_vma_collect_huge_pmd().

Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org
Cc: intel-xe@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: amd-gfx@lists.freedesktop.org
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/userfaultfd_k.h | 24 ++++++++++++++++++++++++
 mm/migrate_device.c           | 34 ++++++++++++++++++++++++++--------
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 5768a3902c7c..54850cdabf5e 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -246,6 +246,18 @@ static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
 	return userfaultfd_rwp(vma) && pmd_uffd(pmd);
 }
 
+static inline bool userfaultfd_pte_protected(struct vm_area_struct *vma,
+					     pte_t pte)
+{
+	return userfaultfd_protected(vma) && pte_uffd(pte);
+}
+
+static inline bool userfaultfd_huge_pmd_protected(struct vm_area_struct *vma,
+						  pmd_t pmd)
+{
+	return userfaultfd_protected(vma) && pmd_uffd(pmd);
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
@@ -390,6 +402,18 @@ static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline bool userfaultfd_pte_protected(struct vm_area_struct *vma,
+					     pte_t pte)
+{
+	return false;
+}
+
+static inline bool userfaultfd_huge_pmd_protected(struct vm_area_struct *vma,
+						  pmd_t pmd)
+{
+	return false;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c..60985e9bec8b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -142,30 +142,38 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 	struct folio *folio;
 	struct migrate_vma *migrate = walk->private;
 	spinlock_t *ptl;
+	pmd_t pmd;
 	int ret;
 	unsigned long write = 0;
 
 	ptl = pmd_lock(mm, pmdp);
-	if (pmd_none(*pmdp)) {
+	pmd = pmdp_get(pmdp);
+	if (pmd_none(pmd)) {
 		spin_unlock(ptl);
 		return migrate_vma_collect_hole(start, end, -1, walk);
 	}
 
-	if (pmd_trans_huge(*pmdp)) {
+	if (pmd_trans_huge(pmd)) {
 		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 			spin_unlock(ptl);
 			return migrate_vma_collect_skip(start, end, walk);
 		}
 
-		folio = pmd_folio(*pmdp);
+		folio = pmd_folio(pmd);
 		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
+			/*
+			 * Nothing carries the uffd state of the zero page
+			 * over, so skip it if its uffd bit is set.
+			 */
+			if (userfaultfd_huge_pmd_protected(walk->vma, pmd))
+				return migrate_vma_collect_skip(start, end, walk);
 			return migrate_vma_collect_hole(start, end, -1, walk);
 		}
-		if (pmd_write(*pmdp))
+		if (pmd_write(pmd))
 			write = MIGRATE_PFN_WRITE;
-	} else if (!pmd_present(*pmdp)) {
-		const softleaf_t entry = softleaf_from_pmd(*pmdp);
+	} else if (!pmd_present(pmd)) {
+		const softleaf_t entry = softleaf_from_pmd(pmd);
 
 		if (!softleaf_is_device_private(entry) ||
 		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
@@ -337,6 +345,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			pfn = pte_pfn(pte);
 			if (is_zero_pfn(pfn) &&
 			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
+				/* See migrate_vma_collect_huge_pmd(). */
+				if (userfaultfd_pte_protected(vma, pte))
+					goto next;
 				mpfn = MIGRATE_PFN_MIGRATE;
 				migrate->cpages++;
 				goto next;
@@ -871,10 +882,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (is_huge_zero_pmd(*pmdp))
+	if (is_huge_zero_pmd(*pmdp)) {
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_huge_pmd_protected(vma, *pmdp))
+			goto unlock_abort;
 		flush = true;
-	else if (!pmd_none(*pmdp))
+	} else if (!pmd_none(*pmdp)) {
 		goto unlock_abort;
+	}
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
@@ -1074,6 +1089,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 
 		if (!is_zero_pfn(pfn))
 			goto unlock_abort;
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_pte_protected(vma, orig_pte))
+			goto unlock_abort;
 		flush = true;
 	} else if (!pte_none(orig_pte))
 		goto unlock_abort;

-- 
2.39.5


