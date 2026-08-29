Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFC7BC61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 19:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B5B6B009E; Sat, 29 Aug 2026 15:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A562D6B009F; Sat, 29 Aug 2026 15:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945496B00A0; Sat, 29 Aug 2026 15:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 675496B009E
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7A6E401AC
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:38 +0000 (UTC)
X-FDA: 85155246036.10.540FA71
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 765F3140009
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:09:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="MbNwJo/o";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xVNVLH3l;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788030576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQnTj8WyNgh95RWq+FBqUqVmKUSQV9sehx4eFG/qu5Q=;
	b=SuRwFIf/XJTHYufIlYo/EwDWy7ucJGLVEpqyaq6hEjXd6Nj2XpihzX7wEtqL92i46yQ/6G
	0j9K4tuBnKFfRuS7A3y7bALcKSilEQm22r6S5sK+tMIvYrePEREfQJBm/Bj4jPrZKQyEA7
	t/H2Cy6itPV+a7kaRM5ao7BwSaZkLhc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="MbNwJo/o";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=xVNVLH3l;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788030576;
	b=XUDph+HQfAenDIgSp+msA643I05D9SEzB9n+E29mdvlk1dS70vt66bHqH8O/k3FujgawyM
	c4Ux8IcMDEIilHo8JrRkN1LgArf/JyBsUTYwjTmwJj2y5ak4VhkYhTU/+8roc1WgdclQuU
	qUgU9v36AYaNwvIVbi2fCb0o+lag0Hw=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67TIZd5k1454970
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=nQnT
	j8WyNgh95RWq+FBqUqVmKUSQV9sehx4eFG/qu5Q=; b=MbNwJo/oOFvXzgGaKqxu
	dArcfBoaWYaY/Rh5AYkReelp8z5kl0rUUPGnU84J/adob7VIpR6/daVtf7oVFzCE
	O8zt9OlsTYzv3xwYqJj0xKHRyEHc51l5D1LeZdswdhDSPdX5Qby7FZXSWQhbd0Iy
	byQyjRmg6uLAvYkf9hYUbXuma6lXnmNXJNBk81NVXTSrZw4W82dV83S2m25pweqB
	VXBbbcUBaSv936NO5brWM4bbLNUh958dCVCszwNEMw9sJSd0aZe92bWr8g9txi++
	oAoe0yKJ1xmhXcZBy+rfFCdGIjCE3cJQ2D45pfRmx4IeXCntEFYtAIC9JliQQS63
	hg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gbs0ptxdg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 15:09:35 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52faa0dd18bso59803601cf.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788030575; x=1788635375; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nQnTj8WyNgh95RWq+FBqUqVmKUSQV9sehx4eFG/qu5Q=;
        b=xVNVLH3lnctCwikUBfEXG5glGY2BXfYNQleAu+FLNxUXl/EKqi04n8yvZ2z0Le25ah
         bUls1tXbHx3nrcgXxZq8MZOaEJerxPmS4J0INQ42opb3xzWJfzOg+wwT07ch0akmDhDF
         uIXXfNED46LkkuIXJZJdpLGDa/bWpkMEZpS2iNhQzEzgMVw94DrtDZOY9jDPVWl8TF7d
         zRiuJRi1PVde9LtQRL2Qui3jsrHrJ7yjxx+02BDkZuKHtYrPueSTjifqOSQ/OtqmVLfZ
         lYLOjZE270i0cnudOJMsttOcjXau+yheCN3842SfPIV5JowV2O6j+s5UgSJxExvRJ7lS
         QQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788030575; x=1788635375;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nQnTj8WyNgh95RWq+FBqUqVmKUSQV9sehx4eFG/qu5Q=;
        b=LCXPfHVCWRkYk3k9WcHNiYo+WFikCkZgEsmuRMIMBFn7WXzxjt3I5YR6FhxlkxQmLK
         JyTAFyJ0KV0faiqhOr1paot174QuZlmnKV3F5KBUU+ojVFBKBh/sEfIxeIUJCBCHR0jF
         7NvGpBmbinL2mM3yBgTWDlh8MAZBUrlLk76FJfRTolNgLlIvoKG53j+yXkTwT0v3xDcA
         JwFJuHSlZ7nJnj9jmMXnmNl+gbLTBIo0jZ3cBXiHWmZcdcqQGhFcoTOfJcaOINzbcADU
         kAOMBW+L0Gze+992BCk85CWQd2t/WGcY0vas8nFEntn2hvb2u1nJhb3/YYxJ1QSKpmo2
         aQOA==
X-Gm-Message-State: AFuF++mfloq2SjQoLehVEKyCPcRdDrPDaIOekiOcXE7d9GmRYN0r5n3o
	0OpZPHdlN/VLiWqWrbwa2ELaToF2FtD1N+1uS20cXppn6YwVtveJjetgVXfDiRll6EQz6rhYx9n
	mZl2PYzNIMHuSYxqY7Qqnaeo+2flkuEdu86hIbcSAdbuhUJx8
X-Gm-Gg: AR+sD13e4bFJE9T5NcA12g1w5RMH1nMrNqoEFtV8JR1MIvF9qM4AszVQE2hNA1MzUcO
	XqOJktsyUzj2ayTwMJSc9Hoq7qeGQs1s1D6xSEbd7OlhOOmHYubbGiUP2wLqS1ejlAGXplpyvhC
	hzz4wcECtN/kYdD1pWT/An939GRh+tFJzve6Zg83+GRs+5alz7Bfyojfb5FyQCZG+zo2leAsRF3
	aomQlb864MRkLQ75dG+NTMiplIA96woOA3w6kejmj7YeqDOW8L+S9IfbCu/6xCaN8kyL6KTO/Ba
	r1HuGVm5pp8oxrekzEmdVo5XKs3F+hkV2smKEvxzwpOIi4mF0lO37cmqyb2YGRDPckX+eLhe2Kv
	h+NYCCNYtAQiP8m40H2cqod2UCOveB5vVnsopdZv5Qg==
X-Received: by 2002:a05:622a:8414:10b0:52f:f73c:3269 with SMTP id d75a77b69052e-52ff73c39b4mr56517051cf.36.1788030574905;
        Sat, 29 Aug 2026 12:09:34 -0700 (PDT)
X-Received: by 2002:a05:622a:8414:10b0:52f:f73c:3269 with SMTP id d75a77b69052e-52ff73c39b4mr56516771cf.36.1788030574464;
        Sat, 29 Aug 2026 12:09:34 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-179-7-133.red.bezeqint.net. [79.179.7.133])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b963c3c0asm239150095e9.10.2026.08.29.12.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:09:33 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Sat, 29 Aug 2026 15:09:04 -0400
Subject: [PATCH v2 5/6] mm/page_io: refer to folios in swap_writeout()
 comments
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260829-b4-page_io-folios-v2-5-649728091117@columbia.edu>
References: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
In-Reply-To: <20260829-b4-page_io-folios-v2-0-649728091117@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788030553; l=1249;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QedbLtwO1bl04qwn37+9AdqEh2edhW9SRIQ3dAFkoUI=;
 b=U8hj8IA61aQIhcJjWSFwrECbO/7tmhgfcOkLobf5HmVWEn/qq18Q98/VuNH9J3ybPrBIFVkco
 FVCx1y2MZkTDta4hk9UW3dzHIwoLpBRw+5wVCYLfTVlPZ5mOOmUCRqg
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX8kDd+gEbndJR
 aozb6zYXwjb/+3E6VVtPBXbLM3q1YFhAPswKMSj8mcraXDSx8FOMjLBNirk1nUB2zE36fAgthoz
 sCnQK+lo/sa8VIMjYziuv4nEsOomr4TJoSlPCaufSCs93WFH//CvDGeizEYrAf/Am/Qbq8hU5jb
 m+7sVCAKjxcOZiDAZ2/HZMfU1XPfodfLjI6hkES411XGsJvQR/nu5/wFcYdLj+craftUywQW0K5
 0B5+mnsA76S/ZfwmMTeybEvEmO1aItS3NA9NTHdls2JxuTm4boaB45bMRR0BLYA5/hiJqs97BTO
 2vBtSXJKpbOFM5ufKNKm9dtb/43UrOT5K5XIZzdW6KDxPhKCpEfUQ6MFhDZmc1ME8HxKoakIU0n
 RLGxts2MVXEt1UPDo8MKLSObdz38ebD16nVFmBeKVcEIvcVXiNOCr8ZnYIoWwK8uuW9klDQC5jj
 lfKkHaOHx9yT4XKyQUg==
X-Authority-Analysis: v=2.4 cv=EtbiaycA c=1 sm=1 tr=0 ts=6a932e6f cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=LRATYcvZeiQrLRB5MfbBvg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=ufHFDILaAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=o9dMDrf0hGvVio-mgDUA:9
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22 a=ZmIg1sZ3JBWsdXgziEIF:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDE2NSBTYWx0ZWRfX5D5EKUm6TXRQ
 CYQ+NkbXvOEM3WbujC6s4ouF2QK4FuZK5coKAt7IFeVudlhOFDbekkrrLCt5cM+dE3q+hWTpZYH
 vCInFZyLAD+zBHm5Z2GzW5+d1jmlu0S3jJZZAhVvkyGsumvztt1h
X-Proofpoint-ORIG-GUID: ABK6GPovaoxRyiZnyBTQFzmfeHXeaAO-
X-Proofpoint-GUID: ABK6GPovaoxRyiZnyBTQFzmfeHXeaAO-
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11890
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 lowpriorityscore=10
 spamscore=0 clxscore=1015 impostorscore=10 phishscore=0 bulkscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608290165
X-Stat-Signature: 4mg5jpwzgxm56hjf9ur5rkdknzhf1fk6
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 765F3140009
X-Rspam-User: 
X-HE-Tag: 1788030576-18508
X-HE-Meta: U2FsdGVkX19oayyhyBMBnnsyp6GWfwGUi1mlxK8gHV2udD7GO2+YvMiLu4eRcOt6tTxujjo7eMePQhmAsX6ZOzeDLzFpBl0+S8TOXsiR5hM9ljwQisFU/UXQMM16KtNk36Czf4hI2HudJ5dZx4vRR9XbCcE4iayl2PJIoO0eNzCtMfYtcoApn6xTwdXeVJDtahpTZxHmXAOb+Ota8+rBGvtde38hJiTLsCWtVr1c1oFtYt0osMzuJyZIVKkobcgFCoWvc45O6i8XWdOzDOoYVc5RWnOXKX6aZ1noGF1FgJ0zfA1Ypk6eEHqe4OGA5pxS9LSNwJBptQhqQpKxPjuwQo0Z9hsmj5b6ajdy7lFJQ7xGIxEsAHL02/Jmw+/1hFn6XQUE5AacxBNL+jfxr0yXWkaTjxJN3qAQxIRJc6hSyG7f3WIfKp7EwhalwlpsSzuM/RROe87jyBS/kz52Ce/p5HRtd/NfOXDXD1SCTmlK0Lh6WODE56pAuzvwdZHmsP1bzEnzTVBRm9NSs+eJE95r8IKw4Y20JjpVWuwn66dlbsXbguICBKRGsSWOKqHTFxQh7fUf0tkjLVpTakGqYJVYZQvwQbH6m5tDJ/iAQSmmVeD/mMRMt+UjtQcrLV6bAeWyi4k6iaV2M5kMVfb3i7fMd5PErgpG3DhYKjBbOujT87/xvnbD2eAl3DpY2SjrTQMV3+nNiYEM0n+NWXCauSTcaBfuap63gDhJ7x0Cx2V1WjkPChYcsxOW6XwU/9ejWc8TeCA6jswGw9SiDOvwFRJgZBgP44Vk9J9T9gavwOzmd6edpJ3EcJ7WlA5W3T36LIa2ChFiNRbEy04gU+jKeSy1NU251a3KbR5XTIwFGYDDuvTJGIs5xfT7J0P9jESkdF9UhOcg30juWRPSozbvxIkUTvCIZr+XizhPGJFNaEtPdPrCxMsUz11hvdU+U/8wh28uc/EW6xH3g7iPoA3fTsx
 0tRbzPpT
 0Gg1XrHnN1+dSBqA53iQPJDhX5nwIgurcDeLaxr4W+wCEdplGi48BjJXWktFM2zDxW9I0Hyh7bH6tZMsGW4YNO2XQOiqkHskwWOBEmaZBFUzTX2Qgo25dVfV9+9sTdswZtSKiyva1+g/eZ+4qUEJuMnNdhXE8ec4lFDOVCELuTMRmpZX/786Q5GChRMeEni6fgXoftIGh/D0NiF/smArs1C+gk1WZlVSjuoEMz4owK0oKcxW1K/utKxjvqDeYAb7lAh9mQVwHx1BPdwSt15HjcHe4rMk7jCKx3aOuwlHwlZEGXaPqzAbyytheJetQpAK807G6dQmYgq0kDn4G/N/1p25jHKJUV1ClrjxezuacgK0zgx/9greQf2HM6jOn0DA9/9sBkuU1Pm3cUeSX3ueTHDwFmYGB2vcMefxPaGcEiDjTFnzbJtySXHug9pazEhlJTJ/KsSCvsh2Vbw0/oq0KPqbRACZ1iws2/Cwx3jECTMmC/PUlZzf2ZRKkf85bOhfZLn5XQ0BRoa4bF5613+pbEH6tdsOSr4Ai21lYQXuLnmnK1CItNcK7dqW71yeqnLNxdx1c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_writeout() operates on folios, not pages. Update its comments
accordingly.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 295cc6ac6244..36466159cf19 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -209,7 +209,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 		goto out_unlock;
 
 	/*
-	 * Arch code may have to preserve more data than just the page
+	 * Arch code may have to preserve more data than just the folio
 	 * contents, e.g. memory tags.
 	 */
 	ret = arch_prepare_to_swap(folio);
@@ -220,7 +220,7 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
-	 * pages. The zero mark is protected by the cluster lock, which is
+	 * folios. The zero mark is protected by the cluster lock, which is
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {

-- 
2.39.5


