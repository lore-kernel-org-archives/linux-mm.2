Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF66C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5096B009F; Tue,  8 Sep 2026 11:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B1A6B00A0; Tue,  8 Sep 2026 11:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50556B00A1; Tue,  8 Sep 2026 11:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B70126B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53DE8A50EC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:51 +0000 (UTC)
X-FDA: 85190947422.04.D632E3B
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2BF3C0015
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EhIGSTan;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xtrlArjw;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0W1Lz/54tGMWp2hamaCENav3d3oGjbDnHiZEdOsJjcE=;
	b=fkzLonzVQYuNFGjKgq1rP4FlgHor+9tf+lXVEiy25eEAoCw3t5ENcRSxATxlsYSZJntmj+
	ZaA6euMT3RuI6PVCOaFYtP3OdF6Jbu0Ew5yU5p+s8c2rUbdI1JTucMIB+j0TtJuU9t3Ytj
	R4NejIj95R8g2dCy2PgLQ5pY1jxBB4I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880608;
	b=n9RQN2BAHuGPaeolyu318HOXNT4p3kUurZ4SiFZqohQ8UbQWmjaoz3F4fB1sJcJd2P+KUA
	M1KUOfFje7jYsFJ712cycLiSEPafxiYlRiR+XZzblhOIB9rEaVKLi2+tE62UmWmmkpoyaU
	DN4Hi/k9+7Fi1BtEeJpJyDmfd1t8Yy0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EhIGSTan;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xtrlArjw;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688EYoo2900166
	for <linux-mm@kvack.org>; Tue, 8 Sep 2026 11:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=0W1L
	z/54tGMWp2hamaCENav3d3oGjbDnHiZEdOsJjcE=; b=EhIGSTan304r/fde464/
	/uPwl9N/ujQitXaTUybYajUJSVwBUeh7Dvfl3s/Lxxsyz79+AqWxNHzOtJEJozOZ
	DzcidU8D3aVkVnIEDxjSOIlv/W2MLB5yAvskFAbvqNaBQq7ytqx+vcBpIMQH1kRs
	i9UpcJfeqTwWEeUHaceEw5SG2C8v8c4JpdpKY+xg6v9lEHoQpZvJnz3y+JZw+Y04
	do1YsxzqLKRoGEUy4Tqtm1JkiuzlAZNIjSuVANTpTqy9+4yJc9jSyAU0u1cbj4SC
	tG0VxCY7W8CsO7SvuekZNMj+DA/qjm7X+gIT8i5/ajNDVe3GMzVecaso317KvYMo
	7Q==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4ykw1hu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 08 Sep 2026 11:16:47 -0400 (EDT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9104215fbdbso113144926d6.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 08:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788880606; x=1789485406; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0W1Lz/54tGMWp2hamaCENav3d3oGjbDnHiZEdOsJjcE=;
        b=xtrlArjwKMUxI2656JkDnHkW+Y4b3lCGI4JdQxC45tuFO6EaJYwoRx3lFqmF+Icmzv
         bIgLw7rlovErEVQQ4YG4BdL5dBi0rQSz8Uq81Z4/ZBliu/5R6Xhv1133fzR9Eb4QF6M3
         YdbO2jYHqLeImDcMWC5sZxGC+K2r0dZpGLB0qySwmwclMaKBFQ6Ud31ERXM5TZotxU6x
         ae3adPF99QL014BEmUA4iy4sH3GJdLkFygVz9T4VLXaRZq3NVMTXfXHhPPu86KpnhN15
         TZFuj+HVy7EQw44ezLcodmWNgXoXnz2Vkq/bp6J0JLIsdCosQ20M14pqpunaLCUOLq2y
         d8sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788880606; x=1789485406;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0W1Lz/54tGMWp2hamaCENav3d3oGjbDnHiZEdOsJjcE=;
        b=hyT3TtXVnlly1V+Eypm52GSdfPKCGRSk+uwF1FitkqEepzXx2Xh5WsZaMD6rGaY866
         iPJBZQQ8Kt3Fuc0U5tLYiQIkvPzo89W2fX8amzpn4j56VnyTTJV0/GUiyEggArpNHDep
         jhb8WQA0W7CObKFXTEw33/8wv8bXAcVTIlMF+mo9oOWtbEhaeKtEduHbaUXwijm4Z6Na
         azy5lqOGtpZQ+zPpSasYiF3FrvPIoPs+gXrIWMm7eJCrre4Krk2PZWgDFXpXO8Zkh6ed
         Vn5jVYg5qEdVXgWp+5TAaQGjCI0QF5wzmDp6KKY6gM/SzU4dFKCQtNYGktGjqF/3KHnI
         hQIw==
X-Gm-Message-State: AFuF++nudRL+3wjAkcveVJRANSPJx8rraOJw10DOz1jHRzg1L4tFpW0A
	yt8M8ZxVg7jO9OY5Cn+XMArfCOieiCrC749wmgGJw4r3M1tundJUDXyT+HuW4RwogeD/bHge4hm
	JTvosWxzD6TVGICsXgGWcuOX7aJxI66jm9jId513aZ7/9Ugw6
X-Gm-Gg: AYBFou1qEw3bLRB6mL11Z+fSaK8zOqFSDdI0vQHZ29kOe5Hwj47UiW/YvVEAxozX7iX
	V2wWUe65CKJx+RPfpmHphwf/dYPby9K6fQhrQZN27WJZJnYV0LpcC2IrZhurBVvgymTla5uanAN
	LMDqSDeQ7FtYCKIQ1wl/tXa5Xiu/IXD8Clrn+Vg5PkRUKoiDAbSI0CMzTOsX6UwvX+XJcpg7+tv
	IQHjRPrgHQYX10Z8l1gy7l8E3d0O6NsYw6UonxKvRlZER+rQ58cRn5xWLbF1jpZzV10JpYDhxeG
	LUV60CQjSD5JUcr26qICA2y/J6q3D+7SAutVF3tVYXu3wCHsaWdrqO43vqSi1qxMxVC6aaJei45
	tLyJdKipuctiDwD3KtaySZFBdEVu14FgQiKWTD35Pvq9+tuiB8rKd6A==
X-Received: by 2002:a05:6214:398c:b0:910:3453:5060 with SMTP id 6a1803df08f44-9103f06ffb0mr368498586d6.34.1788880606280;
        Tue, 08 Sep 2026 08:16:46 -0700 (PDT)
X-Received: by 2002:a05:6214:398c:b0:910:3453:5060 with SMTP id 6a1803df08f44-9103f06ffb0mr368498146d6.34.1788880605812;
        Tue, 08 Sep 2026 08:16:45 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-177-174.net.columbia.edu. [128.59.177.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040673ce0sm122105496d6.25.2026.09.08.08.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:16:45 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 08 Sep 2026 11:16:33 -0400
Subject: [PATCH v2 3/8] mm/rmap: use folio_page_swap_entry() in
 ttu_anon_swapbacked_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-folio_swap_entry-v2-3-ee6d01dfa5e1@columbia.edu>
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
        Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
        Jann Horn <jannh@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788880600; l=796;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yvkP2mDf2z80hosg9Pmvfjl+tEpO2wMDimHyUBJdJvM=;
 b=9NTCtRV8ef8tsMDWIW6LGrns0RiqDw6081+w5XUEOPyzRj7uB4Tjy2rWtBHQT/fE7wnw8kXJf
 Ba8d8kUblc6D13/0BuFkZZ/M0zXTyH+jrCL1a8+dKG8i3uQOKN4EQVo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=bJQm5v+Z c=1 sm=1 tr=0 ts=6aa026df cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=HBUb3goEnnz3w2smY6d+Hw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=gAJobatAmFEwf0K8sXEA:9 a=QEXdDO2ut3YA:10 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX9rdeLvgtJDqA
 FXPDVjxfA0myUGuOpVcnLe6bCajR7ifi4nDpSjba4+djbB/J9RJey/4soZJt4/GFEUbjZtruZ8J
 WmAXVKeWZOlmD7XYjvd68RRe+Uy/FXppfYp9TNR9Hx6ggg5vFst4
X-Proofpoint-ORIG-GUID: zWFtbNxqKOIN6ZI0RSdhfK8QnppjTrWQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDE2NSBTYWx0ZWRfX4A6y4lFjS5xH
 wPTjqJi2Ehi958RnkM6bXKQQBchzAnvo1NpyaIfP+jY/edr5ZtourKdsxMackQdUA+FTf8SVn/k
 4oq0mBPqApOeoj7Jz7f26uzGinwG+WlgyHhOgOXR1ZrJepfsPIw3HCe0F9/L/ca5Ici1rY4ByFk
 UQrwdKRxRfExo8/SxTk9XzOKcB9wUaInTrRgaFPEBs6HxAPBw6tAPoXy3e/7H7va1PKp5K83gPt
 bXyviVRVVioffqofD+xwXj0W+3KIXFNzkjzt3Wl/Jfzv2hlKF30qTi7jKxwhSxOPsKXtuwvxwjr
 K7LDJqsLl5t++gc+l7CxAhc7P/2DNn2cnSRP4aT/tvRghN/r63hdbQRgUBCXHSEH+agwtTJzGzC
 Cd2DaHnIt49zNi7fNk0Vipdfv7uUeoMI2LzlDtWxUqipgoZnKSsG7lb1OXG7p13lIfdX93OAHCu
 otAP5xdlb6dX7uRGGoA==
X-Proofpoint-GUID: zWFtbNxqKOIN6ZI0RSdhfK8QnppjTrWQ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 impostorscore=10 bulkscore=10 priorityscore=1501
 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080165
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bhfdszddkaguu7s8zxmxyg7wyt87cdzn
X-Rspamd-Queue-Id: B2BF3C0015
X-HE-Tag: 1788880608-422151
X-HE-Meta: U2FsdGVkX1+FGlI4fev3BoZn7VkBeslX2xzvwy8adsbu0u8gcr9IraAtbbXpDc98bqJb+HCWtxVHisqAT3IetZWHJ3mUtoPI86DqYxqLkM5aVthL0TJSwSyqCEK+rBr/PUEx68t17xdHvvQVYcNR7gz542hvnUVUWWhANzZ8hx+f6xQ3+NLp7hmrZKFvldWly4CZPwWU7jZpywkMWk/uyd1/GY0PtnD0hy/rWNljK0cAkEePxO4AnRjoTzDJjCs7XQUUSYnZ7LJcXOrmhqwXxzYsDREWqTZVo9GdGoDJ46VCr1NTRCWZkockW5KqyB3S8GI5p8xVmdW39ockJoExjpPgYAultD0wk6hh+xbD14OG1uv1gT1hoSF1E5WJSky2UW+3n30NhiQ6K9Lhmk7vVT+oadLX7DZCMOkIr96zWwyfKRUv4rzqjWwS2+qMd4374MbJgnvr91FLZIpy6Aj3AezaJFGz/tJ2nC0QyOfLzp/YIJy6l60VTsskKywetu1vaFvE5sJ/TVhW8SADmUbqCgd2B2z3QYHuyGeJJpE3SmhaNNKzfaTNnsVQXcF0QgRGb9/cCg4AaYu5/1DSOAISLKzMQCdOv+xqeEaIDJA9kBod5SZOLCSILfGQiNd+bm9SAWOwvRE/2FJWmDuI68R2TT2boVB09WigSR2+8brwKY3lj36ig7C92IK0foMkYh0ZzUQFJ98WeFwWXCO8wpRy8rdy3wTu8IaP6BFjNDSSnJ2O7UZ6THwrKEdT/GnAIKNE3JxZ74uKNAq5sH3w1DE9oebfxTNSjYt70RxASa8zZcWMn4e1I6e2iAnqIm7sHlqu7HL+hTVhoAhKR/800RaadZ5euFohVcMvavFW4lK9QXJXkCX2Drz+DQadsYVREpfNv9V2Cbf68Rg5jscB3n9VnR08JL8gI7nNRoEhMuSS6jaosrIIZMLBjtxnH9cRDQmQOjWCibuNrJXOnamoCPK
 dvtkytk9
 3ZvnxzJ/XC/mcN7hjT61TRZ0VpxLefjDiATfIFgcd4sgkZx6otPLvMgQsW5aFv+WxVaHVEzW6YRwhB6i3WwSs4CHNd2xmyS/h6KhgjYtDi70wzNhFiX/31zhdlX5ot6pyLmibBn8rraZTi6wMEpEsktrh44KcSuyGZAN+F6VPHZkuiSDQ22yreqHHCunpaRVZSM359fvw6oN0S0Hj8iq+qg9rwWsjaMxjUnKTCbVRbMfUUbrHqHdg9XuTlf6uKWbtXCKf1OXNhWTi+rxSdCfbGzV86XBjTi8r4tkpcyXC2HTSvgji4rDYpAare3VN0gEKYBda1L7ER+kuajH+E+/fQ+1+lG1zMs0AAOPY83JK4EOCveAPH1m4kkV2O85BXM7k7WnZJtjp4Lwo9gbcK5Ks2pTcMfvMn29Sd7u3kUpPuc+rZT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We already have the folio here, so use folio_page_swap_entry() instead
of going through page_swap_entry(). This saves a call to
compound_head().

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 5fefe5b060b1..193e1264b631 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2147,7 +2147,7 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 {
 	const bool anon_exclusive = folio_test_anon(folio) &&
 				    PageAnonExclusive(page);
-	swp_entry_t entry = page_swap_entry(page);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct mm_struct *mm = vma->vm_mm;
 
 	if (folio_dup_swap(folio, page) < 0)

-- 
2.39.5


