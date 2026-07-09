Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D185C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B4A6B0088; Thu,  9 Jul 2026 02:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA5E6B008A; Thu,  9 Jul 2026 02:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA906B008C; Thu,  9 Jul 2026 02:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 080B16B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:12:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74DE2C240B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:12:50 +0000 (UTC)
X-FDA: 84968219700.01.B5BC074
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 117FE140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:12:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YNHk247Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783577568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tk6LKJL7qCZ7SEmELzR08KLdTBIjMeoLvyk9OYPCIzc=;
	b=VhQ7m80oawuWailagSHzSohuE4NCQFhXoQhGkMEnww2f4jjm5V5Wfx3dbSRcOk0aqqelsr
	988js83u8+Hfw5OeDeX3NZh9ACq9JowJrDYVf9cdAXGf9P1KRwdf7qUSqtt1Lkn5YToXSN
	ol3mtWAldK3JlHZS3cdPu5yEpqUnBsc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YNHk247Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783577568;
	b=Ii5tMmTsvNhlc+gpztt/UA4G5u4Mybwy+8cW2Dj1CCvdClsDosB/roFyKAu0/tti7iFTup
	cgDNg/HY4WJgGco05OjJqAIbcBxNvrMqY7Gzszm+bxylZ2+gBEzqO9KNqKFda43zml43CQ
	mIDIjSnhhKlCzd2XL/IWTJ6K9HGIPEs=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 668NIU8C280248;
	Thu, 9 Jul 2026 06:12:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Tk6LKJL7qCZ7SEmELzR08KLdTBIjMe
	oLvyk9OYPCIzc=; b=YNHk247QIXIHF2oSKb9Ta8F2Hgv8Nnhv5dROkudmt4HsUI
	FQ7G7mR7+ZeQDtE2D/EQ5kJ8xAhH2XUrkknnI1r8y1tDNp1J5/gjhlvoXRAFFDt0
	w0P+6maoJRcLbyHy5xkuBrWfaMnvfnbuc/prA79XAD8UAjvXurqejSlVzrO4DDYh
	FlGzb/Yp9c5rsW6FHMWCUX8wBjaLl2Q/uBosUhbERAjVcrzxDWqJS+tyQXBE6FkB
	iR1hLOXYDUUiWlzJDt9e0jM5UOXVYREcc6bqbPpHXdJRUiFNEosDxR1MQhaX92Se
	/H47itQayGnYDXtXV2BTyROTFnciVmNjRdhiAF+Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6sw50a15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jul 2026 06:12:25 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66964vj9008086;
	Thu, 9 Jul 2026 06:12:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f7cvwc0q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jul 2026 06:12:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6696CHx614942698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jul 2026 06:12:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FF622004E;
	Thu,  9 Jul 2026 06:12:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83C9B20043;
	Thu,  9 Jul 2026 06:12:16 +0000 (GMT)
Received: from osiris (unknown [9.111.65.145])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  9 Jul 2026 06:12:16 +0000 (GMT)
Date: Thu, 9 Jul 2026 08:12:15 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 03/10] s390/mm: use free_reserved_pages() in
 vmem_free_pages()
Message-ID: <20260709061215.25563Cf3-hca@linux.ibm.com>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708-bootmem_info_part2-v1-3-156ce4986598@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 2uSPGzCMg0D35_ykOn7N0VZASkr8U5Df
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDA1MiBTYWx0ZWRfXzp0Ocx4wtO1P
 cFkbGtZ1lMTCACG9URkflesTJNPhoXEOderQ+8NrapTOr2U6WDQwK56+dYSAYoova3JdHQeK/2Y
 Ywy7fe1MQGZ76BhHMQLz4nFw1EWxDDuaLcoKKISkoigA3gIg4T4Wn1PkHrTTf/bZSEq6fqW4Lua
 zvs9TlJv9QuyeHt2MgRiRe7WQ2MaaYmI+4De52EKWAZukD8GcbYWqN2YBNSh/nwHGT/8nvi5wWb
 LTPTD2p503Hmt4Ii2rMeQytNtpoTMKBIxhokLPVbH8NILyu3SiTklfWZV0hmobbVnBlzPBr5Rwk
 V7Pw1i8anO7/uDPTvra04vrc4oof2BudXs7S0Y5c+5HiDfC7Nur+18DhEI13j3dv8YoFLHI9xcv
 940acB/ck4MBPw/ZjjXxY9ZWQepXpbDHylWGP18+kZzLkvv04DgqpBagOglkP1kswWdCYFtHILP
 OcEdWecPThujLA14m3Q==
X-Proofpoint-ORIG-GUID: 35KzYj-3PAXmu3soR2t7zMxZVD36drfh
X-Authority-Analysis: v=2.4 cv=FqQ1OWrq c=1 sm=1 tr=0 ts=6a4f3bc9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=i43O5vPmq2WhTFV2NaIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDA1MiBTYWx0ZWRfX57IuUu+CXCbL
 n3tFx4IRYzrdwjemMM/i0RrP2OT0Ee4QHHpziA34TggQ1Rhc5RZDtVEKq9wFz114F33aduDyCZ2
 SMQv+qXmaQtFHEGOIWFos+USyHwH9OY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-08_05,2026-07-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607090052
X-Rspamd-Queue-Id: 117FE140009
X-Stat-Signature: arahmzjxedstshyrz8zwzggmecaxs93k
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783577567-666941
X-HE-Meta: U2FsdGVkX19EsrL52eYaZtOAYVzERRnI+orYDv9Q8mpBVNcXkVLAWjy3V36qeL6PfieK+dCZ8hVH+A7j58bpF++Nu2ysR+Q1Cl8EpAnhW1zOexg7jzYSKI1C//iwxZu3er17wdbl/l6PiamBNRS4G4ZXM5/EygYEEkw2fu4myuXpm7NewOT+QGpR8ywilRX6ejgbJwE5CkiEypfn9N0tPWoXzFe1MHt7VJbcvr9IyFTHy6bs5LUSQaTr7vaCbls3WxpweME0C0rRiMqT98du8Fuo437gVPyggmlWPp03bqHn1mitJ5aNR0dgOLc0+afZ1bAVi3CmP8PHXmZswobOoUtumgjtkgNT5I0keOvmX2dmTp0P+7gPbiB78u5/6XM+1E6pMJACXsG7Vr2pmb/YxPB4Lg5/hVLFm1g+XqvwXBUddvvnGg5OI8BHsJ6umQIPi/3F5Y7bQ9VWfOioxfs64n2Rh+abNvVeQ1dskpH1Uqe7uYz96iw/En8OwDHuLRZ8BOSvzxSghkmYF37cEYkJMINpxGJWosU336jcB3Iwg6ebJ5G87pk5zQm4KZwmG4C3HO5QI0ouYOq5l63VPOLy9HyQdufC5FoO0BasDKR50MMDGgUKDyTNjmUPsOcIkdYHbz6+K08W7IsniOA4Kd/j976tLisLLZO7nnLwW5qbMXgV1v2d8SQD9jJ1EAM/ofArCWo3gEQIDksufNDy+Uyw7qu5sOkZgeqJG+K1M0rYRZz/7QMRuen7V4vrtqsTOPbkDwf9LgXlpkZJ1mBhlqqWkzb18VCnujlBYTqynokgoDoOHLlJHx7L6YpL3oJ5zL0ebjMbQSZNcipQFdz5TaRPzQib7pSw1JNcIvjoOxvVuoKZS3ah2t/yn/mxpjW9rra3z7txWH4l+MpsTaRZyq0fAVoZHIRffYRaAL8AOhbWzggRiGmDGa8CvYwHNP5DwWy2IjfsqUzucUKbRa+ZXu2
 eUGMPksT
 Dtt+22duOYYBDP05eUiVUSInQD15hEb6Zd1LaGHTfVjm6l94LqCjO4sViTp0rSBeOXglfpJEvyG1tRwpXGQz7hV9NiCACqHjo5SAw+tX44NR4PNvhyJ9NDkn5AdROF3xoBvaTh+ZbDT/FGIoA8I+iFEYCIHd8awZsXq/YIJVgcnOAFqsov89MCDfb4oyW5AaHXpgMIFVQ7BYnuVgDvVFf7oSv1eHJwSSYZXiVAREKrqAk/ndJm1OuVaXloQuDqHAGqVoGjgQGWQ8+hK3w2pNpOoLinIyLjJzOyuMh0zUSEx86MVDCH+l72t1IbNKEiuhPyira
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 04:10:58PM +0200, David Hildenbrand (Arm) wrote:
> Let's use our new generic helper.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/s390/mm/vmem.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Acked-by: Heiko Carstens <hca@linux.ibm.com>

