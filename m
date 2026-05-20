Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E9ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7E66B008A; Wed, 20 May 2026 17:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE846B0095; Wed, 20 May 2026 17:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA816B008A; Wed, 20 May 2026 17:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 904676B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:17:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 318FA140455
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:17:31 +0000 (UTC)
X-FDA: 84789059502.08.0DBC5C3
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84194100006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:17:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qmMFAvIg;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779311848; a=rsa-sha256;
	cv=none;
	b=OthrnP2nHtcM+j7lWXgwiUR5GHw+KtYAal0YdIQTYLyi6unBXgT02ci4NCvvdSqBKxHBcZ
	O/VyBv3ngdqDIzb8lUexRU3NPXrDCUPqbLxS5/fR7OZS88ifk6Efk4cSkblKEs9BnrDgv/
	lCHQ0sEtxuqb8XVUf52IrhqbNM3a3Zg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qmMFAvIg;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779311848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CS7fM6BsOopDINyqT3OZ5FZsRHEk/OFvQe3cQMzT+iE=;
	b=GcU877qSZj45OdlG4j4185Ll1A6fyfSrNu79FTb/Y3/Zvo9aTBU5UCKQ/e5HLMVIhgQJ1m
	cTs7nRL3M9wXbiAe+lxFijJIEnMiF5s5HkyPyO7vZqCrmPh36h8wdWbytXVfqEiO0K82IO
	ne6swMOe9y6eg38cZv0en2KLVEr1K5E=
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOpXw1522434
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=CS7fM6BsOopDINyqT3OZ5FZsRH
	Ek/OFvQe3cQMzT+iE=; b=qmMFAvIgwUAYYbpvJanCtiML8b+Q01CKNCWwlVzyhc
	bp7DnAnwxXFJ25RAPkPhcZ1WeGB0n3/zZ2Z1yjupz53n5VYZtjKqsHL9N2mhC7zO
	soaSwo86waDmRqw572oI5r4d0qUoHtPyvRi7jXSnFj7lAmcAX0D0fqxptu6UKN/f
	VzSs0GG+zoGnydbj306etqXEQAeFPFyTaJ6Wc3oQHkGHgJDVxYyxWQYhP0w+y5hg
	PqG2ROj85EHxMkmHErYTyIoi5dM6y6Bm7G/6e/jPupzv9Aj+sbP469/AV9GGUCVc
	TUhWEKZzQgpq7ZzPP3nZ0JZezSDc8pXO/a0ekM6DyySg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9avn501c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:17:27 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90fbc9782c9so1300021885a.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 14:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779311846; x=1779916646;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CS7fM6BsOopDINyqT3OZ5FZsRHEk/OFvQe3cQMzT+iE=;
        b=ewmD4RKlBOaYOq/IXEXv0VHZcf4MmJbDm9AUt8YJtmqAlbcl+I6icQqBPv30bcOUi9
         YZ5jxyhTbmZbO8EekCvJYhUlGn9BQuOEGw8qeN3DYv8YJVSF/IeAKjrz2F8xSH/25KYf
         MwU8b+2YOS2NWyNeOyTt6QZzCY4+oH+ZGgmIkPUK9evG87/gVfGh4iHQ6fnc8WveVXwm
         4jdNSouGPqEXywzf84KAPaoxGGBZ+7VxayVUkUAM4TrSdF3GCR7JVb5xVMQclblflMQu
         d4mpNUYtBmKwVSTdUK8CkUM0g4DDmZK86kJh/jBxRAIcTPZhdqKrXddrQ7+NnfqRPB32
         RUxw==
X-Forwarded-Encrypted: i=1; AFNElJ/JS/W3BTaLXg+/VIwq7JTbLDfkVIxK/9obWTJAr/s9PFl4t+YAUKXzOBAqAqhy76DVVe1HmHbN6A==@kvack.org
X-Gm-Message-State: AOJu0YyMKOB6oIWkZo/TsETlltg4VLaG5wUWZ09vfsh9Z7Spqj4M0ego
	FqUkx+OaaTdTLmgjGh2FVElR9h1mdiMGOhKShTau3p8J8v1lSLWIRqs1LmXST52QcreesmSTiFL
	UoePgCN8Ybr83XlhDohhdK9Wg+mJlIzgNWatnKxt9KayT4K5KaBcrbpX0
X-Gm-Gg: Acq92OGm1UN9PtmtbOveu8huxFv0YDKRA32ITmT5tiiok7pKSS1P9xtqZkxReAXDxYV
	S6hW+3xnRXNpEPmaOZDSckMJDCSf5da+0MDYI7O3mTySlyGSRVk+GE3R6/EurGZVemxJeDesEff
	JHo0399ofHIOnDLQbS8TUaqWM+FrtFtFl+8YFyJKRJg7xGVCckvnATH2Plt2e5kqrhC421iGCNI
	omXPozlxa+du0wEkTo0fVf643COeoonhxMAgaDHl92/6bErbnvG4kK7eLvsrVU/dDRCIFMX523B
	RB6oJn4FE7xqx4Rd6XGPKf66L1NYChAat2vKD8igYG9a5JI8N0lOx02yEgHSbJA/SM9zxwAeOcA
	Tki6bvO0Ld7yfLw9/xcFppLXFU5tGdrzmVUmN+xN2XQepDQ7QBVlDc5smBm5v/sr/t/vNZ1XYLd
	yJBQ==
X-Received: by 2002:a05:620a:c4d:b0:90c:c513:2b12 with SMTP id af79cd13be357-911ce046f54mr3721481085a.18.1779311846017;
        Wed, 20 May 2026 14:17:26 -0700 (PDT)
X-Received: by 2002:a05:620a:c4d:b0:90c:c513:2b12 with SMTP id af79cd13be357-911ce046f54mr3721475185a.18.1779311845570;
        Wed, 20 May 2026 14:17:25 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3619c703sm133165916d6.33.2026.05.20.14.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 14:17:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 17:17:12 -0400
Subject: [PATCH] MAINTAINERS: Add more files to PAGE CACHE section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-page-cache-maintainers-v1-1-f93438d2186d@columbia.edu>
X-B4-Tracking: v=1; b=H4sIANckDmoC/x2MQQqAIBRErxJ/naBCgl0lWohN+ReZaEQQ3b1Pi
 7d4D2YeaqiMRmP3UMXFjY8sYvqOYgp5g+JFnKy2Tg9WqxKkxRAT1B44nwJqUwYmwnl4aEsyLhU
 r3//xNL/vB/pmWPVoAAAA
X-Change-ID: 20260520-page-cache-maintainers-1e1ce69e9e02
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779311842; l=905;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=Ef/ox1MkrmElyb0ePApsHswo4ob6Yz2fS7lco/9GCj8=;
 b=01utyJA+a/1N+AsvU3SA32mhxWRYC+s8KZFxjq0nijNw6Pl0Etcfwn12/pQLLx5TW1HweczKB
 uRnjHtnHT3GChQoKqsflogvyQ07uIrzwEogNkqhIBX/B83oQcUUH/4Y
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S6TpBosP c=1 sm=1 tr=0 ts=6a0e24e7 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=JfrnYn6hAAAA:8 a=eHGkg-NUNoCaPWi8_isA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: SmHbjK8SgNeY84_JtXH_HjmlMGRskY37
X-Proofpoint-GUID: SmHbjK8SgNeY84_JtXH_HjmlMGRskY37
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwOCBTYWx0ZWRfXzzPXUyBvUVUc
 215bYLXUiAEI+9NkALFZd/aaLiybsTovaehVGFIgfupoqc66SBqD2QTXB+hJkr9B2r7LDWt6PeG
 KuphL2bG2UecMhmhdJRLhN1gmxxr+oH2KgpCwiEs8B9MWOM9DYhgI+l3WXBwh9yzUmw7ai8dSY2
 nLFV4gyJ96GN7WecIyh5mssVp0oQvhaL3be6t5rHVoq6TSkTGiZYkn2gSFfhItw4Go3ULmyNy7G
 WNZvjR6hXbpXfq9h7uDI011Ml/TJFjRMEdVPo5ziy7ifbbAECPF6N5ZbFI8C5/y+05iPVdnwYlT
 sbUOZmumRB4D9eo2qH189HzuUV+g3mbniz/ExChOCnzh6hU4EAUa1GHJTtJNZ9F2ismNWOpvoOc
 2HWS1FgShqNi1JN426u6xrw8uiV8aHY+upHW5VcDml2TBidaNESGjZLAVaitZOm79gr9yffhhxC
 osu+KAB+sunieZlAudQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=10 malwarescore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200208
X-Rspam-User: 
X-Rspamd-Queue-Id: 84194100006
X-Rspamd-Server: rspam03
X-Stat-Signature: siacwrek9cjo95td66jpk39hxyeajdoj
X-HE-Tag: 1779311848-379954
X-HE-Meta: U2FsdGVkX19pqPQikJAsG1gLuPDGa1QXF2cDD7eJ8WTUbfgtFC3sT5s35cM9KH+E92g2nRu3uNG/VCiZmJam78DeWP77E2Y09bA1FhA4XlsiNn1KIOyTGT34W8BwRORO96VoB4tYYia8mP/KK7i0E83tBSXbEYCYHyDW9sUbteukib7yGpqFn0zax0K35sgIZ6rlJivDsROLjrQq6BQ87y0job1c3SNBAwphttrL9Fa7bKGF969ovOpf3IM4gbZuRopf+MF4aymTXlcgTs93nJdwqWTXQa8gii6O/nCVHJCXbQf2ZC3Hcl/f/oynN9ifdoiIZvk5zR12dK0qwii0r5h95CH+x/M34JYXsyyD7qUBcx6X6Y2Fq7arVToonVNgkpXwQFJ49isqCvhH73QB/HVqFnZvGLTijvyBs6KgiMKiJ+2W+1jtvXLystVo8cJCMzrME4Ma/MhHid68QUR6arZX8DgJBNRra5m0YWyFLKckuAfj2cEzhPIj1X9SHdwgu/md3hgwdeXMv/z35BoWQ2EiyeiEVttndfE7X6DgNiR3+9o6o6sjd8vUF8tTv+0+3ueFgMIBpExIqlZTpYo9kzupwqc2z7jxdXV8DypZlAi6Glq/2UT/YwaXpCPsUy0FKmB/OOXw8wp1ReohkVgeN/Y+KFZhp4lH70ulUAG8Bx5n37DCOoORqPDT7BQGpArlX1tSm9cPzvcNwJPJ007K1n7sFPP2/J45Yoe/BfBYJXj8w79HP/7MJxVIYfBQURALvhVYg0d53vMwhvlJIPX/nVhKqh4OYJHLCYFnCWh64JMA6xg109Rd1s57QLr450TZ642xqHqQW4JZuqCzpQ1lR3g4RM2CycNSeAAk9wuIUVuopbixbjL9nTX7D3qLmZXjGgi9Xn/So7yFbPi1Dsl16tyKoHW02P8eGgNXKtb4HIg/654SBulnCmX+SrQykEbLZTDuB7eDiyOfs6HQKZN
 GVFVUsru
 R/XrZyYLvEXmFZ7GG1+YIm3Gzv6Zwzx2iou5esm7Xv9GFTV5q8IOiIBS2gNxwKvVl/TgivMitf9cj94x9pUqTcDMog2+QGYUuz8Cs5wVBEIgh2bjY+FqxsQnrYDItQjT1tpUM6Io/hqVNLweTh2lVE+yklEzDwnRKt/cpp/2qWqfiJ6BjEqMufyz+hpLg5z0RpA6K89gAOiCXpY1KUMPsSBeD8TxG0sY2QwnaNagJr2UiDlrxx0Y+1lAZ3Uc902D4DtJJvID22bUCbUhtmW5OGEmwn6Q+UDAP5gyKJSe/9rUoEkYGyDRjc95qMm8rqj/xdYNmVFxjwfrhQDxi9C0DBTebGpVUz7dGucjeKwKnh1USdBHnA7dcqpqe2g+3He8hmtVX3E7aeYqwkOiCuMErcDc0Q1FiEYr6ooC0sJzg7yt1O/fA+l9OU5f5Sq49y93ULiBUqhQkiavIz/bUaWlkPrUkYxfURfKF/fMirolV2XnFbB/+cz4TfssFQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add include/linux/writeback.h and
include/trace/events/{filemap.h,readahead.h,writeback.h}.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8cf9ba51d981..b7942e036775 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20172,6 +20172,10 @@ T:	git git://git.infradead.org/users/willy/pagecache.git
 F:	Documentation/filesystems/locking.rst
 F:	Documentation/filesystems/vfs.rst
 F:	include/linux/pagemap.h
+F:	include/linux/writeback.h
+F:	include/trace/events/filemap.h
+F:	include/trace/events/readahead.h
+F:	include/trace/events/writeback.h
 F:	mm/filemap.c
 F:	mm/page-writeback.c
 F:	mm/readahead.c

---
base-commit: e9add7501ad3297dad9b90ce201266830a68ab47
change-id: 20260520-page-cache-maintainers-1e1ce69e9e02

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


