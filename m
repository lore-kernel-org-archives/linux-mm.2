Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCDA606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kJDoBRsr;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=z4R6M2Jq
Received: by kanga.kvack.org (Postfix)
	id 76EB36B05B8; Tue, 17 Nov 2026 23:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745866B05BB; Tue, 17 Nov 2026 23:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6706B05BA; Tue, 17 Nov 2026 23:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257E06B05B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F26274065E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:19 +0000 (UTC)
X-FDA: 85446960438.24.10BD9B3
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81B8B140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJDoBRsr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=z4R6M2Jq;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976157;
	b=FuqLudYlGpZ7VHu66mNVK1n3OmmwAN5xgrn4Vc4z7SuHNHMPv+cq7xsgArdxgWnszUPRTL
	4UjtMGkEt6HHPym/XntrRpP2xiYrIZV3Ld3lZxqSnxOwmPprE75jZDO8UQ/dNGqc00+y8h
	cofLyDuk5YSuc0+vxtu7rQaQMY+tJUA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kJDoBRsr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=z4R6M2Jq;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNCJHjpXg7H4M22PhQ2BeTDOHza1Veqicyx+ercmKMo=;
	b=CbAb0vtfG+Ttip+97hmXzuM+t77vYbrSCAc5lcYWU0t+R+XGlcBGhVezkd6nBb6fcqGgcg
	OWxQ2H89aoKBGEBgjC/Z1H0tiBNmWsUc8+sD41xWKyA11r8+Ec/do1VahJDyu6ZFsmPUA7
	q2fRx8Hfo8mnjDagrd9Ki7cycYGfjcc=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XSav3627247
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=XNCJ
	HjpXg7H4M22PhQ2BeTDOHza1Veqicyx+ercmKMo=; b=kJDoBRsrB/NsQEyhmLQQ
	PFL9HGbSbHNl5vTvWdwadua3igPUVS/Ewb8z8UJ4bDc38Xz69efN5F2+Me9D2ZDs
	+zfAJcvLAfU7xizj2s2M7KoI0avhpmTsjPLUKgpv+3HZcPaJADJrnhzHQ/PZ4Wu+
	VnI0qFH20vL0qCXDe4pqDsAVfHQQUphZXepiyexiIXaW54cUX3AHU04/x+9JKhuQ
	1FppTPTe6CKRWMK56/+SH0b3RlIJ+gbetTSCAkp7wkEv2cDxSw3J1jcGemVV0eZ9
	ghEqPF7bMwMaSc+rG12SRkOnbVS3qG7a+t+nNWXp1oglg27yy0mrNqawvVxVMo/e
	AQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu79gdj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:16 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f26dd2165so167860085a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976156; x=1795580956; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XNCJHjpXg7H4M22PhQ2BeTDOHza1Veqicyx+ercmKMo=;
        b=z4R6M2JqE2ijCWglT5guWiIXL+Ta7JTf9hFgSewBaEWHieXBC/D5jmI5ezxr3sYaxQ
         SVngXb+7DRirkTC7x2zZsByoPlEmkvyjagHzPr+SCqWYbFmiNQTX3leRn42xGBK3fxdJ
         xNm3MXnA/uSbQ9xB/QJ2e2WEuHpc8BK7l9uIbzPX+oTc9Lt5HH9buIfx3BZCWOtbbgaV
         pDcEfywYyf2nZ+ksW9EGeFzWKMU9oDZqViPrnTFFHJvkcT7bOSIgOH/oZtOoRI+pkjBH
         ZPEg0/AU4mDeyDhfJrN9J6sJvw0E31/DwM3rfrKsQtCwEpgyudzloFCRvUFCEscm9xaO
         GiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976156; x=1795580956;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XNCJHjpXg7H4M22PhQ2BeTDOHza1Veqicyx+ercmKMo=;
        b=TT5g4IAKMRJ7g5ukASOJ8MRdxcDFN8vSRKeNcMG85w/fnr3ZGRpmzAG/9SF3qrGjh1
         IaDrRz0zYvt95U0lXXGevxMG7HQarqnW4ahsCmHulPH2HMaeT5xKuxxxpQhgA2L0DpzJ
         vmjz/lie7reJW7l08svQR6ud405xhL4dYn1QDOYDVnsc9R6VHiTkJIfap09KupxIf9a4
         saZCllkNS6XUK4Kexk33Vi+plpU9aNqvz+v4rEWz/UE2YE29VtF+XfKjOWoTlkBprFpx
         arzeeVUwSVWx289k1/siAvb43rtYv7/Xm6MunIwvUxEy22FgAzZbojIYAkpY4dpZLvSR
         0tuA==
X-Gm-Message-State: APuU4Z/FpQO16wjvZBGgeNyvzOHapY+lJGpn/CtFmSzaR9jdXKjXjseK
	1dBm02D5PlJurZlg20vpw1sfPnc8Ral+DX5nmuOBBh9RBjt5n/ol/gDFvROkiWKwHtHT11n5GUZ
	jcku5dxqPM6f4JRX5mgPnVVfw55mdpOUXpYoj3gkO7jOfzatA
X-Gm-Gg: AYBFou3IY4Iekky9B/+El/K2VTi3bszcFZDvEHcqiTLgNDGlVXTY8TFBUMgkJfyaJHN
	j+5S/ao4DApeb3GgHJPxE4MLcrvceVB9WUep4pdi7V+dYcv4TINRKjVjIAzxU4Y2qLoLpBHzCVy
	q1TJpC9EL8Uub4nbwbeMr/SxJULEdkVWaFew5ohFP3embGmamI0A/WlB/jDzhu7OW/q3AVj9xqM
	Qfwo1mZIK4rlf9sXoqWYa9px23KutV+KcHi8uMeGACU22HBETX78uLDjxwavZvzTK8FhTkA10Bo
	24e8oh1YvXHDhVSM15L0oGrqEV5O18wR+Fy8gtWkbRHc/u+skYCWW3DXHc8Wi+kyHbk9CKNLJnq
	PjtqnsVKAwzjXCSw8HoykycTB4SWE3yB3OAPDsKImfSFl97FyVXrEdySyNybdQJ6RUfYj+vaHJq
	7rW1L9K9nTF+5wCptxBA==
X-Received: by 2002:a05:620a:45a8:b0:93c:a468:2db1 with SMTP id af79cd13be357-949995ede97mr298861385a.58.1794976156029;
        Tue, 17 Nov 2026 20:29:16 -0800 (PST)
X-Received: by 2002:a05:620a:45a8:b0:93c:a468:2db1 with SMTP id af79cd13be357-949995ede97mr298858585a.58.1794976155607;
        Tue, 17 Nov 2026 20:29:15 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:15 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:45 -0500
Subject: [PATCH v3 5/9] fs/proc/task_mmu: write-protect device-private THPs
 in PAGEMAP_SCAN
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-5-b617009d1a4a@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=1768;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=EbKRPYoieoskQJpDqKg81gaW0G+NGTy5Bx6z8CnRsZs=;
 b=JSvYpX+oNnE9o4AKjWB2SyEOkImkawA7l35QLPhKkNybQH+XWVtVGXLK1uHIiS1KH05UxY9AL
 YTzUS6cnrjrCH+UqKgDA/2iXJ6Q8CFL1GAG8f2ZUA2gqL8yCRvg3lo6
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=LvgHWXdc c=1 sm=1 tr=0 ts=6afd299c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=tHa68p0SAAAA:8 a=VwQbUJbxAAAA:8 a=RyLRxA_qM0uo8G8YelwA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: H7Fv48mB4Cu22rMwfEMW7qX8ZdNTR-6h
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX8yZVlGaqznn4
 BJfq2qgRlXfILYeiIknT9apnfsdbvjLGGu064966nM8wMLDm8VqxJG2SvWIuIgU+xVXLXWATU7K
 ITuWm+pg0PGVychfQ2fxM4r1b2aKqRPwSAyewh5c3lf0Q/I1okto
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX2Gc0GEX6PDDi
 IVWKcvWYBId22GT8pxTs7ILSuj1b+XVY33qr5+UY4EkFQB5Bgf2AePQ1DAlpzeQoUohMBqxaCev
 9EuyIEMXaNWY1kFotEFGPqF0RU9QKA/rmJcT8+E1jX5O3ZbjCmFsYG6de/7rfS9ombatZSJ5of2
 h0uuUsbm56v4zuN2tf923GJHlD1yd4hpcOi4fsVNqGr0TgP6UYMZrBzxQgW63H+3NS2Lt5PPci8
 h43tcaoFaPOMFk9mSp5SAWO+adnVAQdhPvW68bV0ascIw03qEqquo4sJcQcOCeMsHw9ArKGQaN1
 Pny5f2CrQN7ZODCy3xTjud9osdMANWl1LE5vkm76lkB9uWHv+6tQbviltipr7T/JuM1F5jqkQ9y
 Ml2KR6dm4kPiphMyZVusZ756PwAOAjaC7vHxL0iWfRwhbjKygXfhuYp1W5y0w8fAQY3gouLqPRj
 8BSSUhK++BO4BVx6c+w==
X-Proofpoint-GUID: H7Fv48mB4Cu22rMwfEMW7qX8ZdNTR-6h
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 phishscore=0 lowpriorityscore=10
 priorityscore=1501 adultscore=0 bulkscore=10 suspectscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 81B8B140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3j9f8aygh3yreg4ukegxnbz8m4763cnf
X-Rspam-User: 
X-HE-Tag: 1794976157-629001
X-HE-Meta: U2FsdGVkX1+b+aqzEOKrZDEDgBWleI2FBKNNAK/EstBkzzV+TNsKBbnUdfBnJsiCrbVXSJJyFUhyPTBiCAbQ0GVqtveoa0YeIuLYWTMvdX68vhRnw278VpJCDqGTWcadReoLsQ8DYd0YwaYy/ZyY7Jpnf+/PpxR9VCb1Z3CtwIyMst2jOLvroQzSRvWGeLeWvCe3I/VjhpSXUlNDVMdDP69Z+8onjIVyGIro20wm5FWjAy9Y9AiMELi+IxTRz2BLtO1n/PMS9DJJYDFgq7weBPZ8HhOZpbnIqpZWdaIHs0LMvY9w6ecb5eSLC6hTeKqdUxPkarxNmpk8Yiyywi1PotnhZLzmWulIRbqOVJHGaiLdq0dXcknCNCJhRL8TkceXtMjTCgDpX4KkWI2Fs7ri5ErWt0JP82Xg+gtHKtnG8Q4h01V6aNd0l5b8P+gcp3RJuRGDKX3cpn5Gf7QumEXnN9w6LxGR5EgV2806WbIZZaeNGOyvQXeO2+IkzUL0STCCDqF8ZpWB8oD96lCIs5dO7vO8z85Anc6zejhPLW7MIieIpKBJjf653aJcDYkWCLRs+ggvFlEwk5/CVZ9N3kc0elUiEtECBSuxYbKkapV/jkUCWPYlgPjLPWaiFehz0s8DTYieqhJc5aq0OLtsFvvZSuggI+hKkByzsyxRp41RLDHOY0dMbU3/2XDuMnKDRHYGi7BawvJl3ut0aK7MxDgQnQusMYlQmcD1ap+tf/s/Xx6b/RCQoW23LzDcYJv1NVbjsXLm9kv1lnaEJOjAH+rdPIev9fqFeLDPHfOEgA/MusPVGO3eY/fQq3JOwnMrU0yzV+8Qidi2QCuEVhbCSA/0Vdm+jekbzDMmtjNXxE//tFV4vXQQu804I5xoYsZziauApqqmgfYEZeXzUoyaeZJB3J4CbCmhDNDp37180TE5Ui3EDije+/kXq4SF8TVClXFKi83vpUOWaRCsyGWej79
 hO0vT8wC
 802QMnzamMkyZCycJyS+ECkk+QD2wHXb+Rb3U1cHmeSAUVlxbpzWRqPQZ2v+YUw6OZ0b0qgMDGeZ4GFx+ewHjKydbGkDKBwjfWFi3S+uQojiu6thkke14ecJP15oaqwxDD+T2sAQ+pfSzSNXBmBf8Y3trzxNAC+GslyFGGO+r2pZ594+cSYssQF7doo48VS8a9/9q4B0lY5eScPVIOKwc/nr93gzwRbDm2umWVmZJrYNmnpYv0RdhOLf+gJzdwNxMkKNgHfvnD3ipRkO/J6QMcZxg5Vc25FO2PifR3ECelzR8JN3OmcAUY+0wXGb7cRVTDym5j2Ammt3cfwlsSpSqihOJDsmy4wPZYVYDUS9M5zWyDv6HoNCThJ8Zzft/bi5lRMO4wSc5UIawvHuij/bgKsBK2dowqyQoG1QfXxNnT0eclQCHcSm3alQEFe3NTyxa0wBElyeUx0CQHJcRK63t15EPB9hkBXygAU5S/WnYCp/+cI5Aqub/ClbUs8Xkoy6VU3QLmSO855YE08nZI2MNaaz94mZQ7JkeiFeR5UHalYfT0/Hze1nIo7Gb2Vt/VpzTv0mqfzXRlxqXQu8=
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
fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
not only a migration entry. It downgrades a writable entry and sets the
uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
the uffd bit over to the migration entry, so the write protection is
kept.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 0127bf9c3f77..15cb65c3ab94 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2510,7 +2510,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_valid_softleaf(pmd)) {
 		pmd = set_uffd_wp_softleaf_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}

-- 
2.39.5


