Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1886E9A036
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87276B0088; Tue, 17 Feb 2026 13:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B806B0089; Tue, 17 Feb 2026 13:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0CB26B008A; Tue, 17 Feb 2026 13:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C9346B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:40:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 67E7B139BE5
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:40:08 +0000 (UTC)
X-FDA: 84454813296.07.840F5E1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF85E1A0014
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:40:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CkHY1h8Q;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxcPZIGgtQS7YepVQ7fod752PX/TIN8xLiQyzMj3Y0E=;
	b=z42V1c+DQV8nqP5+38FHEjF1adKkDC+UmjoV2FtOYMfKwYdmZ+kEpnM5mIGIqn+yN75jlp
	GT0IXQTEuvLETOjjTwrA2V/kW5yrXuBd8IZPA7F2IcCi+F9FLHdBLLpccBnQVfxHEqpJR/
	jNuXqzOwy5m9JGFWIV2OmN9qrlSkP8g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CkHY1h8Q;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771353606; a=rsa-sha256;
	cv=none;
	b=4jnC2WiYCARoALJPGpfnuREVAkUib3eTWFvLZ66oPQyv91nRc+4yCCTvO+Us2UIpj1jWS6
	I3YVKjptndaAuYaFcp1NSTrlt67njb1bNs7j0CSUB6zlnmY3RN/06Lt615dKad3qyKwUkL
	v8Yyg9z3EBx4K1TikwDJjlFhngaHskU=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61H8B8Sp3203603;
	Tue, 17 Feb 2026 18:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=TxcPZIGgtQS7YepVQ7fod752PX/TIN
	8xLiQyzMj3Y0E=; b=CkHY1h8QAiC3sEcpX59flMQ3EZBEFAjoRoG17x8jHpwJyP
	PA5i38Js2QIXWMhCUFqBPjEAvCnqqi0V5SfmXAD132QHgpBTC1TDF4qyc2a8HAHP
	868OerukpnhyELmdqZxBhC5g+hmoVN4/mojmuvUFpS1gsZxxgPDuE+C3+BKfOCPQ
	H1xyIYDuWIDHJwANyIqoOEndIJxrO4hOW1PCdyEQzdMsrTmrmm54NakXlCSFc2jP
	hgxy6Z/0jr5SCdFeXN8Bu7s02BKcB59apdJ2hZ+AdtiStUA2NQLzTH47MGVuoplw
	4wocVxh78UZHdyLudseznRPGXEvu+bczj0vdp3yg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6unn9q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:39:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61HFrwlK017834;
	Tue, 17 Feb 2026 18:39:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28c6h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:39:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61HIdrgs37355862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 18:39:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6915320043;
	Tue, 17 Feb 2026 18:39:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 061E920040;
	Tue, 17 Feb 2026 18:39:49 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.222.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Feb 2026 18:39:48 +0000 (GMT)
Date: Wed, 18 Feb 2026 00:09:46 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        lsf-pc@lists.linux-foundation.org, Andres Freund <andres@anarazel.de>,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com,
        Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
        Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
        tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZS18m1eIxjDmyBa@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w3vwdaygcz3prsxwv43blo4co666mragpdwaxihbirt5stl4vr@agyz4mnaxghj>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6994b5fd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=iox4zFpeAAAA:8
 a=aslz9TACT5FPTi4A7ZoA:9 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE1MiBTYWx0ZWRfX0d3Ip7SDhdjY
 P4P0GIYGgiIwZqwmsi57ko1pjuhZg1n0FAkYp3xjjEYxnfqUIf/B22MnXqUIAUpRXtmpJVwX38G
 XNZ7XaaVOP2SMzD1qbQJ9hE+s/Lf/x4+xJMSspxy+YxbEppOeacCJImyLUdotaJnQo8tKTfpq1w
 WSnBetbUb4/VpKw5WK+zp1dk+czu5E2na0cQLzeUPyCJvgdrDA3x92nAIxRVK9vfzhI2AJ/KSdY
 DT8ZgamtKvIlVsT5ELGB1s9hwUcaW+z6OpbPJyXM3rUjLmP7sjDqhE3+Cul6KU0s0/EcVWDGE3k
 Q+WIUFtMja+w4TB45N9zcEmQolg8EwrkuL58OjlWCprWqGMi5PQMPX4M3WaRCvC4smHpRQo2Fs6
 iuj2U36fawt/kEnKxlf+vEjXyWL1T8zWPwBd8vYXOrTMFdO5EBSh8RltlYV2sphRkimkU0CYdOb
 hg6sUWjH9c9CB8cIC4g==
X-Proofpoint-ORIG-GUID: l1F3a8vSNpswM__jTjETDxGwpBHcWToV
X-Proofpoint-GUID: dRTLfNMeKCgs-tbblFl1C_wpdeX_aTeh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_03,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170152
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF85E1A0014
X-Stat-Signature: oghuc3qtw8gqikq4wchinh8h1q9o8aqu
X-Rspam-User: 
X-HE-Tag: 1771353605-791628
X-HE-Meta: U2FsdGVkX1+Gp2zEQh6Nn5s7b/8IOeU2i+hyx+uR39cZWpjilsR3brOJzfSDp+J2WSVTmlnkSL2IsQC+bQhmBaoEt3vINETIeWCkd+HX/v1ct2P/Lm/fq6Vk9CVs5LDC9KWwlJeKbarfbALp/WKRl4XozsAvl52igJRNNAqxjdeRetPauC7dSlK2TFBD29OUvu2tTitI2MDddgcQwkXNEyg9JTbHbVPD0JOdNdg7eXoHwtyrVrQr4ga0Dta5jSNpflr9LVTUAahlx4ongftutTjzy6hBtmJqVoD3D3UpTxUvcf8hF6g7nXB92uZz/NqJMwxXa8/mvIYFOTI44MA7/CyF+eYjEjUO7RtoMjw7Ve4ohg9+AOVB4nXZNtmnEUJoZJU6shV6lcG4ujoFSWoVacf8qgLHw6TPP+S7wazaph7GDIMt9k7OGU5/9dohZrFghC42GAfL7t/zM2zNCMct8HlvyATK81+i7GFr5Cdnn9SV+TPlSwtMy2a69deAJXPGqSL6OUXrtSbIJkth0MTXrEWrHGjD3UddB2ABrauuwtwTVQdCexx92uk1heNRzR34bW3MrfckL1lgbe+Ac6swSEYj7udb3yi+phSCqzZwF2NKe+LqPWqcGvqLYfhiirdyFeYxlJWtlVTQ9hLdgLUKP5Qh1A8LK1EO/f0PBxN5Cg21A0Yw0hbmdms3qtNe42t37I25R8x3r4XXk8m+Twar6C5hPtEtB42oDXwxx5+v/7QQDHvAsDtXjZKdFc55mN2ZFRomtiadWQprEkmEshcz/pvDLUtEqRiCqh0NY7cQ83gx8GlVMlI/SV8lZwq3qeSYRfFhfF9dFdLU/hve75YIpKKNVAxoh7B6fP1hVa7o1OqAhx2Jpo3c6e8kW8dsI+POW58UjVrvya46/KNNTbuZUr891C7jYWhfPqZxCyvXNJDJjXrLpb0JlG6gk6UG5LXyUGR6OHotn5nFiW+BHr4
 Q7qMS0TX
 /krciSUDZKku+iMJR/teLDVIa9zImX5iUHMqbWXTC/RqDRONdWK+DYXf5T1qIMfryYCX20zTN5v3fl5oeaNkOmrojfzU6O/GNChZLkRrWOSA4mBlB3/rDxx3cdppkkTvPvvVay397EajyiByN3CtO0HlmQj2y6oSP/A2Lw5ZZJZ06c1E9t9aFoqBjuh07mDeWBHe6O5E419b0P8+7qZ8k1ZXujnVzglau7DnS2hAXhJTJ+xh603A0auaZxCj4TDbCI8aM47BJqCmhpOA/UAF7fq36F0eBdYRovzvSzEZptXon7mVHvMzHT0Z20013W78oprfGQgPq7kbsoX4wevJJi2x7DkxGbYGgSHThi9jJXBcr44k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:38:59PM +0100, Jan Kara wrote:
> Hi!
> 
> On Fri 13-02-26 19:02:39, Ojaswin Mujoo wrote:
> > Another thing that came up is to consider using write through semantics 
> > for buffered atomic writes, where we are able to transition page to
> > writeback state immediately after the write and avoid any other users to
> > modify the data till writeback completes. This might affect performance
> > since we won't be able to batch similar atomic IOs but maybe
> > applications like postgres would not mind this too much. If we go with
> > this approach, we will be able to avoid worrying too much about other
> > users changing atomic data underneath us. 
> > 
> > An argument against this however is that it is user's responsibility to
> > not do non atomic IO over an atomic range and this shall be considered a
> > userspace usage error. This is similar to how there are ways users can
> > tear a dio if they perform overlapping writes. [1]. 
> 
> Yes, I was wondering whether the write-through semantics would make sense
> as well. Intuitively it should make things simpler because you could
> practially reuse the atomic DIO write path. Only that you'd first copy
> data into the page cache and issue dio write from those folios. No need for
> special tracking of which folios actually belong together in atomic write,
> no need for cluttering standard folio writeback path, in case atomic write
> cannot happen (e.g. because you cannot allocate appropriately aligned
> blocks) you get the error back rightaway, ...

This is an interesting idea Jan and also saves a lot of tracking of
atomic extents etc.

I'm unsure how much of a performance impact it'd have though but I'll
look into this

Regards,
ojaswin

> 
> Of course this all depends on whether such semantics would be actually
> useful for users such as PostgreSQL.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

