Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914C9FC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C666B0089; Thu, 26 Feb 2026 02:01:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD056B008A; Thu, 26 Feb 2026 02:01:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00516B008C; Thu, 26 Feb 2026 02:01:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CCACF6B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F212160A13
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:32 +0000 (UTC)
X-FDA: 84485712024.13.BBB3F04
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 153D9140004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ya4sAlE6;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kLxjgKuj;
	spf=pass (imf23.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bd9GytnbLfNGAuFQVvbct7LRRRfzUwf7RxY82DlywCg=;
	b=yDDXSXL1KHisSe4v3/0bUUdFbQmSZW8AHsuOW2C3FVF/u/ncsGdC5lTABvQ+WKuKQg+Xxh
	JiujE0O7p4hjltQYA4ByExYvYtoPRscgV0NqCxWNX60N1atlp7oPZTY6pC1F0vdj+UmX1K
	OuaauxU4Z+PqT9MmQfPgjf5UJ+Ru4wc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Ya4sAlE6;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=kLxjgKuj;
	spf=pass (imf23.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089290; a=rsa-sha256;
	cv=none;
	b=IoGI+HzmoQH8Vmbq2i+daX4WKDrfbq4yEP5xpV3lwzBYcb7by6rSAWD4h82HUSgFbgfdMy
	7tO/N7EY3kmErYrjycDcsknbNCF9xLpSSp84WWf0dyU5/r1WgMipQe9Ox8ZNR4yJbScqgR
	L/m9hj86cGvWIcPz3yC861WMzp1BTn4=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4V8aW2996716
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=Bd9GytnbLfNGAuFQVvbct7LRRRfzUwf7RxY
	82DlywCg=; b=Ya4sAlE6cZED1TsJp0N/e8giADq3gJ+NF1qRP09P9719UhGwGO9
	L/FZZLty7P/3tvJsO6JPhbvUjfSPhrK49H5H3hSi5PzuTOOv20cNo3deZs1ynat1
	Bb4kvV3nAXlM3MGc61VVkSVnkHEwsKpj8M+tXGcL+nHght3c0R0XrMEwuP8qzSd0
	P1ujIQ7dmFdZS3s8ZiCVACXG4yE5bFs+NePLz8hvM3FEpa5va46xsFc60xKMVxHk
	zgW79jaDFMMA63voIpANTd1grL77YxS9Vv0qNsQUE89CPbN8skk1i2ku6ls13w/1
	FzxR5AlP66uTH9ZYAq9O0QzniBwQeh/X9sg==
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chyv9k7pj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:01:29 +0000 (GMT)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-679dda090fbso12832802eaf.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772089288; x=1772694088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bd9GytnbLfNGAuFQVvbct7LRRRfzUwf7RxY82DlywCg=;
        b=kLxjgKujmX/yU54C3Gwvx32HaJIal1uBEdypcqX+/J5d4e+VKVldD47EllAKsh6jmI
         iEYckHi5dFu1R8AvKl9ptvrr1hFKTP46/FIjIUUdvil7GCriUH7FJVyxEbltW3AnRE3n
         MsM240jsrCNP/s+XNRbp0a5VTGJXdBH/KNi7srB1MwJDPKeBS1XWzIB4nMmEM7OluqIx
         F4lChUpn7t8fRBLnkyoS9lU3U/NAKrw7IoGZiOERZve/TzU/G2LQShe9VJUAS9dN+j9l
         CDASpm+2a3VTH68pmWP4O2SFNHRNZLPjM35unoo7g1o9Guj7vJL140583VI+dWD26McL
         QevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089288; x=1772694088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bd9GytnbLfNGAuFQVvbct7LRRRfzUwf7RxY82DlywCg=;
        b=icQKHgUKQDc30ZHBgwcrdaOMKdoorT6LZ+GParXSC85DRZb8lwhJpYzPlqtQnQ6eok
         K9K5UgxMMm4ku/b8XhHe5kxZX2xjklNOQlQnF4eG+sljyUlO97UO4zYe+jTL+9yCojk/
         a+xLzGmv5wGQeSZiSFpXTqZ+75Gt0sTfDWDqav8zz6bfE/KKdHWM0ToFgr3WNxdcXvDk
         yq+KavFmRlfNXsxQfPxZAclYEg5WKWBaGN0BETENdXURbX7hfY8BR4OVw99/DLoi6GTx
         jRY+wDVTzNQykXdfNoK6kn/r+5GH9i3OikD8xrSa2IX773kCnc5XXgZfxnPiFpEgaLks
         BW5A==
X-Forwarded-Encrypted: i=1; AJvYcCU5fNBzi3lCBAtUlYhQzAl+J8n5S0v0ys+L161hIy5QTPeJ2xS5LltBSBJIKZ89fxmG48k30kVnqQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4YXepapWmSQhgb1ovj0hvFTKAsVEE2AFHADwDV3Av01oTRW7A
	RrfUIWrrL4/EimFWVSvZg7+NcedBYHKQHmzzURkCOmGjtpIGd6j806F5CdWSXUIvAwvkLjB8e07
	aJWHXymDoeU/HZSd0JMdxmQm3MlXqFUSCqWzR7OxoBfww3iegJFn4Fw==
X-Gm-Gg: ATEYQzwmtGWzMYwU/9BbatkvJOCQBDh/jXdJZ0nFphxl0mMYBrwfZS0zoCCW58ziXCx
	GwsZ2dICQ4+w1ebtqbwArvxuv6kprHqa4kM7lBCLRF7t2W1gh4WJ+9tI0L/m0qboXJMyiItnGNT
	/8NYOlC5zUcNKOR69OICiNpr13gLMKtYZ7MCk2SzHq0/m7b23dDlb+aV3gvJwrKcDBtrJvljOM6
	CXGmSx8wZSFqsZRalAFfPRC3NpuhTY+fnG+uU7tcSWQMtkgba9d4okuB2H/n+hHfTsws25CwDT4
	nMG6XTtRH5koRfDT61Qu5JZbClEI3wTKivTsicsDpArmNt7cwR1b/xBqPhfxDNGqYe9cK5ZtAbx
	lu++cgcZQIZUPICxU2Y84dDPgkw9ELjAJcdEh3a8/t0OXDqI/watmxYg14pkmJhKOPzGYLL13Fb
	RAP6UO
X-Received: by 2002:a05:6820:1f05:b0:679:88ee:e3db with SMTP id 006d021491bc7-679ef9aa12amr1654170eaf.70.1772089288453;
        Wed, 25 Feb 2026 23:01:28 -0800 (PST)
X-Received: by 2002:a05:6820:1f05:b0:679:88ee:e3db with SMTP id 006d021491bc7-679ef9aa12amr1654157eaf.70.1772089288041;
        Wed, 25 Feb 2026 23:01:28 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-679f2bfee3csm1013246eaf.7.2026.02.25.23.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:01:27 -0800 (PST)
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: akpm@linux-foundation.org, mst@redhat.com, david@kernel.org
Cc: vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
        hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        longli@microsoft.com, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Allow order zero pages in page reporting
Date: Wed, 25 Feb 2026 23:01:22 -0800
Message-Id: <20260226070125.3732265-1-yuvraj.sakshith@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9ncrRu9lL-ow31NjMEw-e9LzsHZ0Gkut
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MSBTYWx0ZWRfXw2LCC80rzcWC
 LtUOiThjavo8h0fnWAkuv3xrwW+hXKYfTAsUJHuqF3VdREYPVny+P/pjp4dZjVj+GmAxCXIdKZD
 ARTWec0YIW9W70LZRUQpp40TRAalT7lR/eh2DKWBee2o0zKPukBYK7pcgX9C44pz6HfciYhIBs2
 tUHPUI8vhirOr6+Xe8+oN5XvtxlK8ZEoGdNMnhT0LLRFuuAM1mBH+1ppxGXajpooqki3LKPKSni
 YGrJ5yKaA1/tzKYPBSzpPZZPhEB3fcarQj46dbdP+0i5/Bb6M1RcmSRTSw9X5m8WZDfke8hFWPA
 nr2xUkXGqAHXdrcrnjbQ9TcGHxkHv1jKRuehOzDCJkhTnichFmeeSywKiT3EaX3v9v3gJN5yafD
 zqFRcme+HgnZ86eQGUmJDD1uMcS5LPHcv8s9kd9mChwUzZX2skNp4a4BgGuNbTQFAw8wxGIiVrI
 vLYEkfOSaXDBG4qpV6g==
X-Authority-Analysis: v=2.4 cv=GZwaXAXL c=1 sm=1 tr=0 ts=699fefc9 cx=c_pps
 a=lVi5GcDxkcJcfCmEjVJoaw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=9ecvtSpfVrh-a2M179QA:9
 a=rBiNkAWo9uy_4UTK5NWh:22
X-Proofpoint-GUID: 9ncrRu9lL-ow31NjMEw-e9LzsHZ0Gkut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260061
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 153D9140004
X-Stat-Signature: 8a3tdn9pbtdumibbdqyogizpgsuchaze
X-HE-Tag: 1772089289-151438
X-HE-Meta: U2FsdGVkX1/8srFIHxRa3Po/EfgEItjvUubE/G4xMCXTi6KUyI6jh1oI6rzZkfufjWaU7Q7eu6h+uDpIZZFdDL5krePh0XwYSuJBLrc39WKLBNSs9kOyWYrWPGwkV/K3h1UvuNjAq70ZHRIYSnu6gBs7xA3qHntNn5+30AKwFlI8+JH3X9WuHYR+2XUdxaMD3ZTR6TVWwD46fzv2guytdOZBzcBsYzwdD9tCYhdI26IAsUBE9VoxqDxXlTODhmbZzAXB81jXsSVyXFfpgIdfiyN4mcqtAkc8o2R/GU5uUhaYJHDbimKMjfWj/kdOQnV3SIHBgJsIRyDDqvlXc161nV5MSLfYehSMc2QfEUnu223vayU4ufGa2Ag0YC+EXFBSvd9G92r+NaSePLWPS04eFlPzdxGEYwCuBUccHYdIGMnPCIymL5uGfO3KqNOiZXGJ3h6nyHPTilcZQqUvpLs+kNWeD+aMOdT1rmMc6sEB54De8yrG8g1wZkvocRg/fb8U6Qi+gBCFbasCOJ00MTvdq/ZMYSjtA5tHjxx1EVpPvkBZotWzhfnhYNUfLW1D0Xp9T+B9Z+W2PgZf0P05d1Ss6Ge0gjQMnIQpy8gShNJhBgWryoQ1RY4Ao1DUdXsAZdRYwjcMqe6bsQVsLu0PZn1LRngG2LsAnmgSZujJVyBCAydIm5H9VOx01zfvRx3xg1nI4+Hz9wI2XQhM/aOag3YMsExDrX0DPFN2fArrIRwHlDU2I9mRxds7X8jMicuPjIj+WhVMuGApQXMRPAJN1J2rUUF87VLxqxkzGXzjx4L9n9Zy+8wM9frCQPoPgSvRwrdSZFapH1XRHNvEVUyuOw02iwJyg5erCyKJQD4mgf4w0pBt3PWU9iuMjqeCzWBr9+Hpf63jwKAWsaP55VKzhf1jqoWi0gnVn5VBUshCLu+It/hOmEsi5HZohBeB45Vo2BtqPu44ffgPqVAzUhwwziN
 tGh9rv1R
 Ngyfs5IG7/Uo2RNcgnmoMhSZtrbc2at8dUO6+tZ7HR297w6PvYV1Aw+w1wZHpftMJVBaQ+jnxuxRVDSbSit2dK4/aWQg++q/NS7HqK5KhJ4zEWftTXlyvM+S8aHWcm0+ndVQ3YhXe7nGAGEeDD//SS2xPs9NAj6lZ5NT4rtTnF5l1upihJIxJeWsVCABLGQja+R8WEUs/YuISYWK5M/A+pr9D/jRzWK6dzbJ7KORZii2q/VGu7KE+RANqCSGPR2p8rapGai+AZahbtGtF5ca6D/4hSg/vAazuP1ff9RaSaGTvs8fiVKU/o3EFvt/KD8lnHCdaLoseYeAhLQJbI+KVKewby94UmX+UXkGFapHl6X4MIGK80t8eq80ruDjrI5LT+N2V5096QeGgcMRKcW00R/oSi9MTBO28QGMx5h5gXHDfTyHkprWAPTGm8W2uW5S8DA68tdVt9GeHJLx9ijTlu+S2o45UVEzG4AEa0MYN6rxAveLp18f5nxVXDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Today, page reporting sets page_reporting_order in two ways:

(1) page_reporting.page_reporting_order cmdline parameter
(2) Driver can pass order while registering itself.

In both cases, order zero is ignored by free page reporting
because it is used to set page_reporting_order to a default
value, like MAX_PAGE_ORDER.

In some cases we might want page_reporting_order to be zero.

For instance, when virtio-balloon runs inside a guest with
tiny memory (say, 16MB), it might not be able to find a order 1 page
(or in the worst case order MAX_PAGE_ORDER page) after some uptime.
Page reporting should be able to return order zero pages back for
optimal memory relinquishment.

This patch changes the default fallback value from '0' to '-1' in
all possible clients of free page reporting (hv_balloon and
virtio-balloon) together with allowing '0' as a valid order in
page_reporting_register().

Yuvraj Sakshith (3):
  mm/page_reporting: Allow zero page_reporting_order
  hv_balloon: Change default page reporting order
  virtio_balloon: Set pr_dev.order to new default

 drivers/hv/hv_balloon.c         |  2 +-
 drivers/virtio/virtio_balloon.c | 14 ++++++++++++++
 mm/page_reporting.c             |  2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.34.1


