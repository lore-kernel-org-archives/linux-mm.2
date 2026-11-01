Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5522606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 13:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=bRzx2sb3;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=mX7RFcp2
Received: by kanga.kvack.org (Postfix)
	id B80EF6B00EF; Sun,  1 Nov 2026 08:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31606B05B1; Sun,  1 Nov 2026 08:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2926B05B2; Sun,  1 Nov 2026 08:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63F306B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:55:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14C5AA0A36
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:54:59 +0000 (UTC)
X-FDA: 85386696318.13.4D1B4DF
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEF6940002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:54:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bRzx2sb3;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=mX7RFcp2;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793541296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w86GXJKk57CWbsK1o2/pIiyaV2WJY8p2m7MJiTZdj8g=;
	b=dMO1+n0R8wZMvMGRXLVIlt3GNzuIC7X1CjoLAcQJlT68mAQYhnY0CL9rDDN6mc2eDe4dPQ
	hvP4wS5PGkSyBTSuXNei1P1p9DwHR9r3LNhCmz+pqkl4M82LCe/elGvnp6UiJplPC9sboN
	pM0v7S73RVF7o3sSfKXRi+ihDdtSlqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793541296;
	b=KAnR2NV/fxl/8apJtqVZVl0v1lKoS+v2ULTgf5MiuITiqk5/g/9uC8PkTbRS1yquwzrBDb
	HkXDWUe/5EWS4ZZ6gqFdcT9qCoEMgsCbEwpks78r4SmFdTzx6wPO8rPSxQDEl+o1OOYPl6
	etKgk1MNwYa+ebGDZ5Tl+sOEzzGoMdo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=bRzx2sb3;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=mX7RFcp2;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A1DVaf0751478
	for <linux-mm@kvack.org>; Sun, 1 Nov 2026 08:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=w86G
	XJKk57CWbsK1o2/pIiyaV2WJY8p2m7MJiTZdj8g=; b=bRzx2sb3xvz2LXbC8aay
	FqwNt2HJCwFUZvpm68hsS7dNZ4ezMyXOTmz4Vr0bm0/LEa5qcQe+pekBSl+atzvv
	3IzjboNn25thdp6Tpt7fgV3Y/XmXQl+QuKsUtcJHTnjMasH9hqmDvYmI8br6C88e
	R9cYaBdxPWhb7+Unjy7Gr719pSW4Q/MHdCZQQCoDNtvjcJXMWrI+pHk2uSj5WHvt
	rSvOx9dUmvru27x2tvHAKFtFzlQbz5Myh3LSycHW2Xzvpytn1VeXJr6ZHFczUFEg
	cemnB2towM9yWivuq5OYRXXmWI1UPDtXo8+2m1dPZc2+lBuX6j03oFdkLIpU0okr
	bw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4hnw6nsr8u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sun, 01 Nov 2026 08:54:54 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93909014c85so460083285a.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 05:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1793541293; x=1794146093; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=w86GXJKk57CWbsK1o2/pIiyaV2WJY8p2m7MJiTZdj8g=;
        b=mX7RFcp2Xmqj+upI8DdCVdlraKm88Qo+RRMbRhLJsbPvs4/SSmI/FiN52J8Xook2W8
         grESTFXp7Hff1qj+xbQdzJhv9vCJuyvdExI4fg0Yrwh4wZPZMo0QsbV4943dvp9jB+UB
         8pdGEQjNk8HO1B4YFR0WyejGCRJ+aob+mLwVm5wbhFHUcq5DzaojzEyGjCikOFoCnmmK
         wqIXUeiKF/MJKwWB8kZk+ulotsHT2fK3rH1qDCmGSgqHC1r1mpQ8ykWCegjd5rp83hRT
         I7rxEjx9Nn9bqkhJGCgXJyg15xtcpdXi9yo+s4OyFC31zW0YBg5aYn3+SsnRl3CsQ2k7
         2BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793541293; x=1794146093;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w86GXJKk57CWbsK1o2/pIiyaV2WJY8p2m7MJiTZdj8g=;
        b=PAQgtdISuXe/ak0NgyrY9sehYP4PZq4ktdltiK/5JTDso1ebUG0KUamBtHLC8eyCS9
         Hu13NKoI0g70tMZJgyCTMQWe1G0psna72Ip+qdJ+etu+vCnk3CHgHv1onvOnUifyJHpu
         h8DDCHrtq0JlDYDTY2g8TbzZB+hkNMoXMHc5Jf4XHYa+pOy3GlnX0M1vforKF2NLJ6j1
         OMcwhAbE4jhZrJ+BIk2vo95KPSiwJVAqWuzWpQ8YvwB4q7omQ0CsvfVRL9hu6j5o/Ta3
         BAjZCFE+K6DJ7YCbuMu0ssZYp41U3Id4mxnleeSVuYcf4ny35NNZX1FPqRFJkBYcDFwo
         xXvA==
X-Forwarded-Encrypted: i=1; AKwUvBwz9kBCoGyr7qd8igyNIGjdPG+Lpy23H36Lb0hZ45zPpS76rwI3u4iWybafmoToYbZXDsKHxqamtw==@kvack.org
X-Gm-Message-State: AFq9FYIRMxtBi730SGuH9Lsn8/S1eAjYtI3KP8+FGjCq3ncZr5mNtVng
	ZRytsoq+wcWvgErGg1k32lL0aGg5yvqowWH2zzx0SFoRHrHPkVTP+4MO3Ckw72cyUPwF55sOkaH
	eIMKCgq1xF9OMeiMG1b4jZa+kqLHkEZuZrSVQRTmAvtOyvm8H
X-Gm-Gg: AYBFou37+lvDgGazxEduC7vR91XEKz+jdkU32k5p9rR6ttgGdrWLPmZmltcDhvMk/7P
	nAIfguAbSt9jv4QOnqCA/oZ6rQGA7IUKac5/LzvSReza4TyFqvEItjZ4PuzVDsv+mf+JdOr5Au5
	Et0VvulAJ2racepbpCwfpGEF70BxuaaXXDACQdohtvBCOON5ihokAFu/zKLSxPgb4wh3ewAeQxk
	prY4HUyt6YT3FYAjLIbxCQaDJcMRfACVdXJUsc6khRGkDaEwLpq80D/aXcPeNZQO59iAHbpQmbR
	s4udA39ex7j2+2D7VOeTxBSDg3dtiecd2eTU8M+wnNa6tttTpLzW1FCdj762rR3zPsneAx+ijog
	y1jSWYtW9LBQHleGeJz0Xxif6cdVecISUnpjmb+aRMgJMXstRH6caQ7GzJj0=
X-Received: by 2002:a05:620a:2710:b0:93f:3cb0:4639 with SMTP id af79cd13be357-9442184df35mr1241527585a.72.1793541293556;
        Sun, 01 Nov 2026 05:54:53 -0800 (PST)
X-Received: by 2002:a05:620a:2710:b0:93f:3cb0:4639 with SMTP id af79cd13be357-9442184df35mr1241524785a.72.1793541293056;
        Sun, 01 Nov 2026 05:54:53 -0800 (PST)
Received: from [127.0.1.1] ([37.142.157.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71ba2415sm14680787f8f.50.2026.11.01.05.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 05:54:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/vma: undo userfaultfd unmap preparation when
 unmapping fails
From: Tal Zussman <tz2294@columbia.edu>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>,
        Jann Horn <jannh@google.com>,
        Noah Weinberger <NoahWeinberger2003@proton.me>,
        Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
In-Reply-To: <20261101-uffd-unmap-abort-v1-1-1588d7a7c61a@kernel.org>
References: <20261101-uffd-unmap-abort-v1-1-1588d7a7c61a@kernel.org>
Date: Sun, 01 Nov 2026 08:54:12 -0500
Message-Id: <179354125206.1160833.15685446781372913857.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793541289; l=699;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=KVDlIBGZ8sUNXJ5Zqe2o9W5vfay33kUNx6yzDVUOXWA=;
 b=A2fDt8WEiG/978sXfzb8nnpP99XqNHXnaLMw8FlmnzNdVAZqbqVW+oTIku2Zvx1VhqejjXGFx
 FAFeojSy/6jCPd2awvm8clmxE3ND/NxTsXdMTEICuQHLp2+OOZNnpHW
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAxMDA1NSBTYWx0ZWRfX6FFNhIYAOzUA
 0EL9aoZIbA3hmTvE7z24UqTKRigQoKiQwA/Y5yos5P51svy5IhvpbDlZiQ70+NoupSBHINHQCHU
 phfxgrwfwt6iFxB1dnB1PMjBnfuIG4ScODZ2rEKy6ka725Xw1yR1
X-Proofpoint-GUID: 3YUnBumbP0ehtPoS-7r6n0JK1SO3e1hl
X-Authority-Analysis: v=2.4 cv=P8SvFSAu c=1 sm=1 tr=0 ts=6ae744ae cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=Qz3frfIdACK70Hl/8c7MJg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=d_C_vffKwV36uL0hTwoA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: 3YUnBumbP0ehtPoS-7r6n0JK1SO3e1hl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAxMDA1NSBTYWx0ZWRfX4+OwcQg5oWrg
 IJSFw1vUZnD351Os1+m7x7fCwTzwJh8XCntjfyc/p184++a9+1CAB9qnmTeaWD5GKxf2UAIPhKx
 d+TIIS4YyZO89+fszlRSRB1lcAxAOousJLgv8ryaFCc/5DjWY6JAmNLX/LEzVhbAuJcM2uscrIy
 XvWVCFJVeDKEMpOz7Yv39fLQSrBHCEWpeJ6xuUoUMFXPGtOT680wyo3+H+Rb5An/oD8WBUHK7W7
 bcdJMEMxaJCVi52kM9Uq51Kat5QSuBytb0flD/ZEZtr83JGN+n32U/wUrAyv9WjMeaThxvN5RBU
 FQ12Te1sv/ld1JgRhOR/yluycOdJgizozR4YiEekHGpgfZLIiurMDWZE8xLw/lEoUjNO/Tg387x
 3yLv0ZJuN1coBo4OBWScw5l3geLdD7fvbpLKGbyQAHf+ytsNLDrDHmYMpFEYiyHNHUs68Pd6V4p
 IDY2+j9nSrc4cEa9X7w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11953
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=10 lowpriorityscore=10 bulkscore=10
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611010055
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EEF6940002
X-Stat-Signature: 4jwjqwaeagjq6qfhtgwii8dq67jiof86
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793541295-193670
X-HE-Meta: U2FsdGVkX19YONwPY6avCFslY1i0Wz/jYQwBuKWnz5J51H8QPNSl1ECqtrplWmqh3WrzEayhxd1Uc7xsj4UtRV3uoQQGdN3syZhWcBqUVmLvJut5U7fc1AdClh9Kw0TDZhH4zQCRkfqPvSNoys/tIukREEY/g/tPNF0FrpVwu9bE+ccTZgO7e6Hvo0U3j3qdcDId24SmfM5q4FigIPhX48El0RKWfv7icNo+L+pa+uLmxUZodrBiEVbp+Hz44flTAlxDloxraykVWgVMscWDgm6HT5/mc/+92n1/AthOgx/xpc7HNxdNxb6c+N0dArmhdtXWfQBpDe6FZ1cRI/9W4sWv31VMENESClqyfUHXExQ+Q0s0YuDhJCtH4ys4+bA917xY7QfCkHTl9vTexLBjiqg6zSb958As31Sj5oMlXxZqkQqcnwHQyMD9zDl6tZKEIo1EjqhPceW9YRAfpQ1MTmdpheqIUFInW0JXOPEyNJ11ffIcLFd8JtlJ2OP+eoFBGJ1knXHwhSQp1gNCmUuj5tMlmGXmuf0UGKoq1O7pykSLJrwhjHzRsp2c0u/8ETCwrjM7z4FN5+MbyIzHaxjBgMBuU5SAvEpTbDuVCFQtoEyBIQ1hAASWQMtG/vV3xZuktvFVWuqWCYcMWrdLZ3T9GuKJztbNkPAtGL6k4RcOYWFkjR69dBHenCiWnxlVJB2H3iB8c4EMtroyB104xslo0kT+Dv4kzCr0zpR6yCdg1gg0NhH+eLvpgcpCUTPVMwZFy+dfaCY6Mp6KBZSBxIWWLbrsAxhNOSKOhzFgL5aDbHC643I/QrIpP78S5O3kDtGhpTSI3VomEz5tAucKaHlhpNGXr6EXLIUICCwrETDG66RX20/hnhkfKUe78ncnzTnbh3f2DFEzzhjz4lCfroFa8BL+KGOXILXk3CQlwRi3GPobG2LMqcIRYz2ElPxZ2BwdFQ2P4kXX8ojaI91vcC4
 uat08do3
 e9tzDSgSY9zE56czIgCE5N0qK/RE7Bw0TI7LtlanVand0GeJQhBCcPlN+jNRbBID36AYn73gqn20xA6fABDd9O6vX9bOaHZ14SDsMx3cEu1yC8ahTKvdaNW5t04r6cSRcrCSFrtgq9g0HyHqu2EMm4b0vb3Z0w27wBq63/DzFZJ0wk/CKT9Jqkuh1PobY+XLSX9uczAhFatE+JXJO2fbb65sj6dIBl8t6M9nzRoeP24baifTs6xynzqINEC++Ty4vXUYGvUQDczspnNGGez94ICr/GKJYkqRa8RNgP1mu+grZjh4waDgbZZdy1ReqbRtvt4b8o/6Nk/r/0kcofvw5RgJ5XzICMPpIUJ6Oxi4hQ9q9PSnx5fQidkpU6NzRDP8pLu/n+dp7QzE0wq6LNo34HfItvPcuC6i0b2YK5Xyc/LchaVPKRvK7dRVIMTirun/+J5aS7UKee7sZrTOGHaAMUl20MK9rmPEZx03VSXiDA6zF/b1rRdADbcVEEEUHQCBTc+tM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 01 Nov 2026 10:24:02 +0200, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> vms_gather_munmap_vmas() collects VMAs to unmap and calls
> userfaultfd_unmap_prep() for each of these VMAs. This takes a reference
> to the userfaultfd context, raises ctx->mmap_changing and queues an
> UFFD_EVENT_UNMAP on the caller's list.
> 
> If gathering fails half way, e.g. because one of the VMAs is sealed, or
> the operation fails after the VMAs were gathered, the original mappings
> stay intact but the queued events remain on the list.
> 
> [...]

Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>

-- 
Tal Zussman <tz2294@columbia.edu>

