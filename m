Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44554CD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48FB36B0096; Wed, 20 May 2026 16:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F996B0098; Wed, 20 May 2026 16:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 307B76B0099; Wed, 20 May 2026 16:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16E006B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2047120300
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:42 +0000 (UTC)
X-FDA: 84788991924.29.C99163C
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 337F64000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qsUbckLp;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QM60WXSBSIQYQWVtbfbyKvBF8T4H0CKsBjV6qw2v1YM=;
	b=NMoQ2HP5qyZTuVMZaVbJ/efeZHi4B7J4C6SFZP7PN7MBAJpHCuoC2GmY0bkTDAsyBkNB2w
	Payws+94oi8MxptehTej/fhINeWPYV1UKmoWkM/kOUfL3j3R6vPsZf/J0owUJS8ZUw1uE3
	hyPVb8tngegATr8GuRym3VQ0P2Jr/H4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310240; a=rsa-sha256;
	cv=none;
	b=ZinlH7iaBCOlqxUvGu139/OJXbIBm/TC6p8aKRRPOaCzKHch6RGquxAHSM3TasmMiliGXw
	Zhv+bcUAcfD81g5WH1exKqWW4MUPawrCmyrOzwBEcKvubXrPUyXt4/pPhBmx2kf41io6Oa
	+x2CxPKWYpL+uofbpdX7pzPCEPgO4wU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=qsUbckLp;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf12.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO75a1521173
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=QM60
	WXSBSIQYQWVtbfbyKvBF8T4H0CKsBjV6qw2v1YM=; b=qsUbckLpGyB+A7AmVhc9
	P/EmpJQBFEfgFQ6Udn4ZjA6omKFZKlDMSjeq+f1ohfc78WtsZMLDzvRM9bgXvo2S
	MBCu5l/GGRXt2PE4FwGczaZWrztMv9TpwKXvnjuzF2MwdCpiVEWZN2c298ivtzBY
	QGeU+gxRvkX2o9DO0ASI46sJppe6M7llf5MTsfrdKQi0QBe1i7SrgiWLC9uBdx8A
	Otr7Czvz4SEuwUdiNhvICi3uaD1ReLSTI35+Pzo+fB/osgj0Tkc39UFscfFF/RbB
	gOXVynu+j3mGFznKdiOcXCL3AYt9RyTRfgkMl31LbUIKv7ZIFGqgCOcdTZBhY7UM
	vw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9avn4t67-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:38 -0400 (EDT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90fb1490e2cso1276333985a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310238; x=1779915038;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QM60WXSBSIQYQWVtbfbyKvBF8T4H0CKsBjV6qw2v1YM=;
        b=dk20rHvQqwmthHHbWfmK/STF+rnR+Y2SKJI8uE/StOvGuAM4tglyo5xsjJPG6mujEY
         nadkFNwRplMk+Jn3jd9j+4w3HQKOH21o1spEYHkTWW8dfG2Ti7Zb01K3Pmt1B07WXS93
         qpbet8Iq8Ij+VqIERVe04btQupabvpFR1+loe4Ybmtzg3qvK+rUNBxfPnmA5E19kWdaa
         eqMVxoNRdI2HZJzp6nhtKDyt77+WMcpjcdHufjn7624WioRc6jNX9+a4X9q6BUeX7U/q
         5bN/ucIGgZjEm28kZYpNvKxoENgx8StQjrJPlVLjGlJRKDUfUhvtRQc/NkS59kAO3ftM
         bgig==
X-Forwarded-Encrypted: i=1; AFNElJ8PPPnwdG7qoaKRzkBc+fKtX416lLTb2MnTa3J2LU2Ky3wuN4gOJhoMX9FNyetbp5ZDYE4MlLYw0w==@kvack.org
X-Gm-Message-State: AOJu0YxLQkJ3u4Dj/uml8wav1DLYXVLGLZAhRUBgMfyXQdT6uSZtqD/q
	tNQMeflNqNaS4giUlTIJiLcTCEZeSngfTKkK38ahOtqH20+uxjLCjcIBEFllAW9Zt3GH15fDYsF
	dDvJ78VG75jfJ3lg88y4uJoCUAHHteAeEB0TliVPNC3B1BHCc
X-Gm-Gg: Acq92OEkLpSpPc+STc5SkxewCziWMO6ZjIAcAH0VPethU09LE59lYxRJM9zafiBGIQ1
	BCAsrh23mCSK580lOCtsBo16FhHeZl41RLdzC5llrDSBZwq/wxycrbuyi4TDAPcHREYsVf+pvqj
	xx6hnmrT/U6iYUXUAlzz9GkTSfwnN7JuJK/YLVS1OtH5pSjC/wdcseRFo1az5wX82SPVRv2gg5w
	RbBTtQP8gYdmmbOPZiqmDXfh4wZbnyfXHupDMhUBBDh1MmkJZaMdPZdlYITvRH24HjSuKMZoDqf
	bs8hY2+zbOkOv7KK2YeILYV9hlTCV8fdcRYby2HCqn9lMEUnZUMudWC5duYajJWMCB+r45Oz2Op
	rnILxbEvIDjU+AYY/4gjn0iXFWdnhZYv8A8EUY4niG+H9QxKvaTjU2e9iNvjRwVOKc2k=
X-Received: by 2002:a05:620a:cfb:b0:911:fc2c:c078 with SMTP id af79cd13be357-911fc2cd1c1mr3069129885a.1.1779310237096;
        Wed, 20 May 2026 13:50:37 -0700 (PDT)
X-Received: by 2002:a05:620a:cfb:b0:911:fc2c:c078 with SMTP id af79cd13be357-911fc2cd1c1mr3069124685a.1.1779310236449;
        Wed, 20 May 2026 13:50:36 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:35 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:56 -0400
Subject: [PATCH RFC 05/11] folio_wait: reformat comments and fix alignment
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-5-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=21905;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=69FMnFpCCkSEBZ7/2YJYSjRd1MbsazhKzcMtt9GaMPw=;
 b=/LS05GFRr0I0dRdpIdwuCT27Qutf2Js6Cv+yKW0yfgbbJSYuTkFWu6MOkmEqTdIvlw3VRr5oV
 smS0ff/auk2DI+45+Yy/pAXtlKe+W4MsmUEGzwoOkLRM2bxQ/nX4MKZ
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S6TpBosP c=1 sm=1 tr=0 ts=6a0e1e9e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=ItFntl4SG6S2Zc4VtyUA:9 a=QEXdDO2ut3YA:10 a=O8hF6Hzn-FEA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: ddVa6r4t8ds48i90-YaTc82kYswTMgsM
X-Proofpoint-GUID: ddVa6r4t8ds48i90-YaTc82kYswTMgsM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfX1qD6MPF+HKWy
 sdbcvo/P3YarcQAyjGZq7rwiFxNRybQ6+smXOzL6guP4t3I+h41sxtB3ZUiPJG3bXOoqtM/dw/7
 2EdzdGF+qGlZO8LGzjiWEDOkctIY62oXxO9GAmZAWgzHE3Sgk8nqVfefqk2bF6seS2OoyIdmiEi
 5SeQpaGMwbCYk5AQLbiz/EqKMPVoYZRj0GaYfMWlyPxpw0ueVhHZWYQ1/Xd5pRpJypp0T24TRaG
 Nw3cao47IU1G0z8wXARWB91CHghHTvTx6wfl8lRq+S/gr2u6XHrpwMPXUjYVLlVSkW+SyO7CFgL
 PAoP2LR9oLgaCU8CQF9Ih79TO2ty8Jc3PD5M+yXrAoKoeVUXLGT7ocJQF1+oU0leFnNRcwb4kH5
 00Sshi+nuEFNALjf/Sh3xbEP6cB+WwaxwX7zBJw+cvltCe3M85kYSYtyCqtdzkxha4CC8Hbj4Bj
 DL1e4KuDVPGntympQ9Q==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 spamscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 impostorscore=10 malwarescore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Rspam-User: 
X-Rspamd-Queue-Id: 337F64000A
X-Rspamd-Server: rspam04
X-Stat-Signature: zwz8j1sq9stjtodscai6sueo59xazt3o
X-HE-Tag: 1779310239-597726
X-HE-Meta: U2FsdGVkX19+f7z95lFjI9y4a5gp54Z8SetS6KAPsVviqD9hgm3+fLCuSFHmC4FH9zB13bC3ggBjbr0AI5Wt8N9neUPnTzPLr9sGe4TI0n2BleppZpjw3dCB0DKQTaFLTJ+yVaNZj7CuiVVCcfVwgLS6qYxR1lCVkP9QbtDPC/n99Rv4KFxssiwCJGSIq0XW7LRXfo55WeoSFZ8aXPvgSDD/04HPnxz3oVcObdklxgAEdIkXsuVUjx0RSIQHai4HR1f00ytHp0ClW3oHfOBLRVtMBEWFiL7jCNR+0zVLmuQ8vK7Q1fLnSdvvL/dOl8cse8yqQOxEBQod5kEOMYtVZprkmhjz9XksV+hV/o7lHwaaEcJx1H564ZczGiKRfK/d11MKNoiOMA6iqLjvcaIqP2Y60YlNxFWJHV0qlpVAsfzUnFhO9h7QgvMF8c6cEIT8l8RydtC1lvp90PQthuGq1zhI8rN0udGQ06iDJEv1W/ePFuhlX3zbLJxV+PXvST6SrhVN2X1C4opVRPiVUwmZy8e7GQWSUI/qOeMp8DmgY7UCGrnZxa7zZofAuNOVEbxCyrkM9YsiZveMsn1zO9K6H52ICrxbvKg6H3MQKDuMnPfEWIrSMbaDBTvQHlgxDq7LBVOSlkxFf5+BhC/Ai4WHwQKvM3ON1OKL1LI3hT0G5gr6UrHI6RCP5JSgO3YbObxp0wz0MiLAIDbIBIQiS47Tw+KX/WH575XegCmlb+CzCM6V5+BUUKAn320xOU7VBPOitMpnZfv4BltaTSVPFQJrkppGvCRYdQr/Btg51wEHST3QCUYJcYM0HKsNcqTgRUbq6VXqd98jznOpqPzZvSsQ4ouQnpw30G/GhpoyTUDasKaSmNlZzARmKuI7vcFQ2O8Lg7D4UHf2fyxr9rU6lt+BKmlzoSe1oeQJks9y80DCU096q9IBFGOQNf5KDnumtgK+RGL1sVVMt8Zjr5N+xtC
 6MdqgxXE
 EtFInYZ64CdxpsinyRFuqewsthNZFz77BAEXSqrdNTBZIDgbDv9DH1CfDuEnms8FFlUFVJPum+aZS94f3Hr4AuSqQV+vATdUd01LipfGRcvUgRzLMIhLXoQ3GDe10vSYPxm7E92Z8qK5e+xFr2O0H7MyhMBSxbdAJOZZIl831HGhp3VJtAXzXM5+s6uxA2oa9VuX2+/HOuJ12vit5cS2AZJB8mzANWTXEQc/GUJeTRsNtoDW8oAGVKscjGDukKOo8G5MA8SWaEwCJnNGVbMI7o2OeH62A8oeCJ090XVP1BKIHOexjpr1NcgZu+5JlwB2rxr09NP3qfGC7nNJZ1FrgdVG9yp2FGwVyrRvbulX2uXSzugT1OgKmZp+5HTR40r70AHvBOi90JYQWEvj9t5aonIqtuggczSV9w0dGiNd5Brh9lch2hUADz4CyJgYizVdYh/CelVvUi6ZUAm3Yn73YLBe9cgVmvrp54X9gItExF+VvGcYaBX9z5kVC1VYS/VbI45xj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reflow comments to fill 80 columns and fix indentation issues carried
over from the original locations in pagemap.h and filemap.c.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/folio_wait.h |  62 ++++++++-------
 mm/folio_wait.c            | 185 ++++++++++++++++++++-------------------------
 2 files changed, 113 insertions(+), 134 deletions(-)

diff --git a/include/linux/folio_wait.h b/include/linux/folio_wait.h
index 4a5cb2fcf046..57ccf9ffd243 100644
--- a/include/linux/folio_wait.h
+++ b/include/linux/folio_wait.h
@@ -19,10 +19,10 @@ struct wait_page_queue {
 };
 
 static inline bool wake_page_match(struct wait_page_queue *wait_page,
-				  struct wait_page_key *key)
+		struct wait_page_key *key)
 {
 	if (wait_page->folio != key->folio)
-	       return false;
+		return false;
 	key->page_match = 1;
 
 	if (wait_page->bit_nr != key->bit_nr)
@@ -41,10 +41,10 @@ void folio_unlock(struct folio *folio);
  * folio_trylock() - Attempt to lock a folio.
  * @folio: The folio to attempt to lock.
  *
- * Sometimes it is undesirable to wait for a folio to be unlocked (eg
- * when the locks are being taken in the wrong order, or if making
- * progress through a batch of folios is more important than processing
- * them in order).  Usually folio_lock() is the correct function to call.
+ * Sometimes it is undesirable to wait for a folio to be unlocked (e.g. when
+ * the locks are being taken in the wrong order, or if making progress through
+ * a batch of folios is more important than processing them in order). Usually
+ * folio_lock() is the correct function to call.
  *
  * Context: Any context.
  * Return: Whether the lock was successfully acquired.
@@ -66,23 +66,22 @@ static inline bool trylock_page(struct page *page)
  * folio_lock() - Lock this folio.
  * @folio: The folio to lock.
  *
- * The folio lock protects against many things, probably more than it
- * should.  It is primarily held while a folio is being brought uptodate,
- * either from its backing file or from swap.  It is also held while a
- * folio is being truncated from its address_space, so holding the lock
- * is sufficient to keep folio->mapping stable.
+ * The folio lock protects against many things, probably more than it should.
+ * It is primarily held while a folio is being brought uptodate, either from
+ * its backing file or from swap. It is also held while a folio is being
+ * truncated from its address_space, so holding the lock is sufficient to keep
+ * folio->mapping stable.
  *
- * The folio lock is also held while write() is modifying the page to
- * provide POSIX atomicity guarantees (as long as the write does not
- * cross a page boundary).  Other modifications to the data in the folio
- * do not hold the folio lock and can race with writes, eg DMA and stores
- * to mapped pages.
+ * The folio lock is also held while write() is modifying the folio to provide
+ * POSIX atomicity guarantees (as long as the write does not cross a page
+ * boundary). Other modifications to the data in the folio do not hold the
+ * folio lock and can race with writes, e.g. DMA and stores to mapped pages.
  *
- * Context: May sleep.  If you need to acquire the locks of two or
- * more folios, they must be in order of ascending index, if they are
- * in the same address_space.  If they are in different address_spaces,
- * acquire the lock of the folio which belongs to the address_space which
- * has the lowest address in memory first.
+ * Context: May sleep. If you need to acquire the locks of two or more folios,
+ * they must be in order of ascending index, if they are in the same
+ * address_space. If they are in different address_spaces, acquire the lock of
+ * the folio which belongs to the address_space which has the lowest address in
+ * memory first.
  */
 static inline void folio_lock(struct folio *folio)
 {
@@ -99,8 +98,8 @@ static inline void folio_lock(struct folio *folio)
  * This is a legacy function and new code should probably use folio_lock()
  * instead.
  *
- * Context: May sleep.  Pages in the same folio share a lock, so do not
- * attempt to lock two pages which share a folio.
+ * Context: May sleep. Pages in the same folio share a lock, so do not attempt
+ * to lock two pages which share a folio.
  */
 static inline void lock_page(struct page *page)
 {
@@ -116,8 +115,8 @@ static inline void lock_page(struct page *page)
  * folio_lock_killable() - Lock this folio, interruptible by a fatal signal.
  * @folio: The folio to lock.
  *
- * Attempts to lock the folio, like folio_lock(), except that the sleep
- * to acquire the lock is interruptible by a fatal signal.
+ * Attempts to lock the folio, like folio_lock(), except that the sleep to
+ * acquire the lock is interruptible by a fatal signal.
  *
  * Context: May sleep; see folio_lock().
  * Return: 0 if the lock was acquired; -EINTR if a fatal signal was received.
@@ -131,8 +130,8 @@ static inline int folio_lock_killable(struct folio *folio)
 }
 
 /*
- * folio_lock_or_retry - Lock the folio, unless this would block and the
- * caller indicated that it can handle a retry.
+ * folio_lock_or_retry - Lock the folio, unless this would block and the caller
+ * indicated that it can handle a retry.
  *
  * Return value and mmap_lock implications depend on flags; see
  * __folio_lock_or_retry().
@@ -147,8 +146,8 @@ static inline vm_fault_t folio_lock_or_retry(struct folio *folio,
 }
 
 /*
- * This is exported only for folio_wait_locked/folio_wait_writeback, etc.,
- * and should not be used directly.
+ * This is exported only for folio_wait_locked/folio_wait_writeback, etc., and
+ * should not be used directly.
  */
 void folio_wait_bit(struct folio *folio, int bit_nr);
 int folio_wait_bit_killable(struct folio *folio, int bit_nr);
@@ -156,9 +155,8 @@ int folio_wait_bit_killable(struct folio *folio, int bit_nr);
 /*
  * Wait for a folio to be unlocked.
  *
- * This must be called with the caller "holding" the folio,
- * ie with increased folio reference count so that the folio won't
- * go away during the wait.
+ * This must be called with the caller "holding" the folio, i.e. with increased
+ * folio reference count so that the folio won't go away during the wait.
  */
 static inline void folio_wait_locked(struct folio *folio)
 {
diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 9d3328717bb3..8d8237cdd73b 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -20,14 +20,12 @@
 #include "internal.h"
 
 /*
- * In order to wait for pages to become available there must be
- * waitqueues associated with pages. By using a hash table of
- * waitqueues where the bucket discipline is to maintain all
- * waiters on the same queue and wake all when any of the pages
- * become available, and for the woken contexts to check to be
- * sure the appropriate page became available, this saves space
- * at a cost of "thundering herd" phenomena during rare hash
- * collisions.
+ * In order to wait for pages to become available there must be waitqueues
+ * associated with pages. By using a hash table of waitqueues where the bucket
+ * discipline is to maintain all waiters on the same queue and wake all when any
+ * of the pages become available, and for the woken contexts to check to be
+ * sure the appropriate page became available, this saves space at a cost of
+ * "thundering herd" phenomena during rare hash collisions.
  */
 #define PAGE_WAIT_TABLE_BITS 8
 #define PAGE_WAIT_TABLE_SIZE (1 << PAGE_WAIT_TABLE_BITS)
@@ -70,44 +68,42 @@ void __init folio_wait_init(void)
  *
  *  (a) no special bits set:
  *
- *	We're just waiting for the bit to be released, and when a waker
- *	calls the wakeup function, we set WQ_FLAG_WOKEN and wake it up,
- *	and remove it from the wait queue.
+ *	We're just waiting for the bit to be released, and when a waker calls
+ *	the wakeup function, we set WQ_FLAG_WOKEN and wake it up, and remove
+ *	it from the wait queue.
  *
  *	Simple and straightforward.
  *
  *  (b) WQ_FLAG_EXCLUSIVE:
  *
- *	The waiter is waiting to get the lock, and only one waiter should
- *	be woken up to avoid any thundering herd behavior. We'll set the
+ *	The waiter is waiting to get the lock, and only one waiter should be
+ *	woken up to avoid any thundering herd behavior. We'll set the
  *	WQ_FLAG_WOKEN bit, wake it up, and remove it from the wait queue.
  *
  *	This is the traditional exclusive wait.
  *
  *  (c) WQ_FLAG_EXCLUSIVE | WQ_FLAG_CUSTOM:
  *
- *	The waiter is waiting to get the bit, and additionally wants the
- *	lock to be transferred to it for fair lock behavior. If the lock
- *	cannot be taken, we stop walking the wait queue without waking
- *	the waiter.
+ *	The waiter is waiting to get the bit, and additionally wants the lock
+ *	to be transferred to it for fair lock behavior. If the lock cannot be
+ *	taken, we stop walking the wait queue without waking the waiter.
  *
  *	This is the "fair lock handoff" case, and in addition to setting
- *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see
- *	that it now has the lock.
+ *	WQ_FLAG_WOKEN, we set WQ_FLAG_DONE to let the waiter easily see that
+ *	it now has the lock.
  */
-static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync, void *arg)
+static int wake_page_function(wait_queue_entry_t *wait, unsigned int mode, int sync, void *arg)
 {
 	unsigned int flags;
 	struct wait_page_key *key = arg;
-	struct wait_page_queue *wait_page
-		= container_of(wait, struct wait_page_queue, wait);
+	struct wait_page_queue *wait_page = container_of(wait, struct wait_page_queue, wait);
 
 	if (!wake_page_match(wait_page, key))
 		return 0;
 
 	/*
-	 * If it's a lock handoff wait, we get the bit for it, and
-	 * stop walking (and do not wake it up) if we can't.
+	 * If it's a lock handoff wait, we get the bit for it, and stop walking
+	 * (and do not wake it up) if we can't.
 	 */
 	flags = wait->flags;
 	if (flags & WQ_FLAG_EXCLUSIVE) {
@@ -121,26 +117,24 @@ static int wake_page_function(wait_queue_entry_t *wait, unsigned mode, int sync,
 	}
 
 	/*
-	 * We are holding the wait-queue lock, but the waiter that
-	 * is waiting for this will be checking the flags without
-	 * any locking.
+	 * We are holding the wait-queue lock, but the waiter that is waiting
+	 * for this will be checking the flags without any locking.
 	 *
-	 * So update the flags atomically, and wake up the waiter
-	 * afterwards to avoid any races. This store-release pairs
-	 * with the load-acquire in folio_wait_bit_common().
+	 * So update the flags atomically, and wake up the waiter afterwards to
+	 * avoid any races. This store-release pairs with the load-acquire in
+	 * folio_wait_bit_common().
 	 */
 	smp_store_release(&wait->flags, flags | WQ_FLAG_WOKEN);
 	wake_up_state(wait->private, mode);
 
 	/*
-	 * Ok, we have successfully done what we're waiting for,
-	 * and we can unconditionally remove the wait entry.
+	 * Ok, we have successfully done what we're waiting for, and we can
+	 * unconditionally remove the wait entry.
 	 *
-	 * Note that this pairs with the "finish_wait()" in the
-	 * waiter, and has to be the absolute last thing we do.
-	 * After this list_del_init(&wait->entry) the wait entry
-	 * might be de-allocated and the process might even have
-	 * exited.
+	 * Note that this pairs with the "finish_wait()" in the waiter, and has
+	 * to be the absolute last thing we do. After this
+	 * list_del_init(&wait->entry) the wait entry might be de-allocated and
+	 * the process might even have exited.
 	 */
 	list_del_init_careful(&wait->entry);
 	return (flags & WQ_FLAG_EXCLUSIVE) != 0;
@@ -198,11 +192,10 @@ enum behavior {
 };
 
 /*
- * Attempt to check (or get) the folio flag, and mark us done
- * if successful.
+ * Attempt to check (or get) the folio flag, and mark as done if successful.
  */
 static inline bool folio_trylock_flag(struct folio *folio, int bit_nr,
-					struct wait_queue_entry *wait)
+		struct wait_queue_entry *wait)
 {
 	if (wait->flags & WQ_FLAG_EXCLUSIVE) {
 		if (test_and_set_bit(bit_nr, &folio->flags.f))
@@ -246,18 +239,14 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	}
 
 	/*
-	 * Do one last check whether we can get the
-	 * page bit synchronously.
+	 * Do one last check whether we can get the page bit synchronously.
 	 *
-	 * Do the folio_set_waiters() marking before that
-	 * to let any waker we _just_ missed know they
-	 * need to wake us up (otherwise they'll never
-	 * even go to the slow case that looks at the
-	 * page queue), and add ourselves to the wait
-	 * queue if we need to sleep.
+	 * Do the folio_set_waiters() marking before that to let any waker we
+	 * _just_ missed know they need to wake us up (otherwise they'll never
+	 * even go to the slow case that looks at the wait queue), and add
+	 * ourselves to the wait queue if we need to sleep.
 	 *
-	 * This part needs to be done under the queue
-	 * lock to avoid races.
+	 * This part needs to be done under the queue lock to avoid races.
 	 */
 	spin_lock_irq(&q->lock);
 	folio_set_waiters(folio);
@@ -266,9 +255,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 	spin_unlock_irq(&q->lock);
 
 	/*
-	 * From now on, all the logic will be based on
-	 * the WQ_FLAG_WOKEN and WQ_FLAG_DONE flag, to
-	 * see whether the page bit testing has already
+	 * From now on, all the logic will be based on the WQ_FLAG_WOKEN and
+	 * WQ_FLAG_DONE flag, to see whether the page bit testing has already
 	 * been done by the wake function.
 	 *
 	 * We can drop our reference to the folio.
@@ -277,10 +265,9 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 		folio_put(folio);
 
 	/*
-	 * Note that until the "finish_wait()", or until
-	 * we see the WQ_FLAG_WOKEN flag, we need to
-	 * be very careful with the 'wait->flags', because
-	 * we may race with a waker that sets them.
+	 * Note that until the "finish_wait()", or until we see the
+	 * WQ_FLAG_WOKEN flag, we need to be very careful with the
+	 * 'wait->flags', because we may race with a waker that sets them.
 	 */
 	for (;;) {
 		unsigned int flags;
@@ -306,8 +293,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 			break;
 
 		/*
-		 * Otherwise, if we're getting the lock, we need to
-		 * try to get it ourselves.
+		 * Otherwise, if we're getting the lock, we need to try to get
+		 * it ourselves.
 		 *
 		 * And if that fails, we'll have to retry this all.
 		 */
@@ -333,13 +320,13 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
 	/*
 	 * NOTE! The wait->flags weren't stable until we've done the
-	 * 'finish_wait()', and we could have exited the loop above due
-	 * to a signal, and had a wakeup event happen after the signal
-	 * test but before the 'finish_wait()'.
+	 * 'finish_wait()', and we could have exited the loop above due to a
+	 * signal, and had a wakeup event happen after the signal test but
+	 * before the 'finish_wait()'.
 	 *
-	 * So only after the finish_wait() can we reliably determine
-	 * if we got woken up or not, so we can now figure out the final
-	 * return value based on that state without races.
+	 * So only after the finish_wait() can we reliably determine if we got
+	 * woken up or not, so we can now figure out the final return value
+	 * based on that state without races.
 	 *
 	 * Also note that WQ_FLAG_WOKEN is sufficient for a non-exclusive
 	 * waiter, but an exclusive one requires WQ_FLAG_DONE.
@@ -452,11 +439,10 @@ EXPORT_SYMBOL(folio_wait_bit_killable);
  * @folio: The folio to wait for.
  * @state: The sleep state (TASK_KILLABLE, TASK_UNINTERRUPTIBLE, etc).
  *
- * The caller should hold a reference on @folio.  They expect the page to
- * become unlocked relatively soon, but do not wish to hold up migration
- * (for example) by holding the reference while waiting for the folio to
- * come unlocked.  After this function returns, the caller should not
- * dereference @folio.
+ * The caller should hold a reference on @folio. They expect the page to become
+ * unlocked relatively soon, but do not wish to hold up migration (for example)
+ * by holding the reference while waiting for the folio to come unlocked. After
+ * this function returns, the caller should not dereference @folio.
  *
  * Return: 0 if the folio was unlocked or -EINTR if interrupted by a signal.
  */
@@ -471,8 +457,8 @@ int folio_put_wait_locked(struct folio *folio, int state)
  *
  * Unlocks the folio and wakes up any thread sleeping on the page lock.
  *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
+ * Context: May be called from interrupt or process context. May not be called
+ * from NMI context.
  */
 void folio_unlock(struct folio *folio)
 {
@@ -490,14 +476,13 @@ EXPORT_SYMBOL(folio_unlock);
  * @folio: The folio.
  * @success: True if all reads completed successfully.
  *
- * When all reads against a folio have completed, filesystems should
- * call this function to let the pagecache know that no more reads
- * are outstanding.  This will unlock the folio and wake up any thread
- * sleeping on the lock.  The folio will also be marked uptodate if all
- * reads succeeded.
+ * When all reads against a folio have completed, filesystems should call this
+ * function to let the pagecache know that no more reads are outstanding. This
+ * will unlock the folio and wake up any thread sleeping on the lock. The folio
+ * will also be marked uptodate if all reads succeeded.
  *
- * Context: May be called from interrupt or process context.  May not be
- * called from NMI context.
+ * Context: May be called from interrupt or process context. May not be called
+ * from NMI context.
  */
 void folio_end_read(struct folio *folio, bool success)
 {
@@ -577,13 +562,12 @@ EXPORT_SYMBOL(folio_wait_private_2_killable);
  * folio_wait_writeback - Wait for a folio to finish writeback.
  * @folio: The folio to wait for.
  *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete.
+ * If the folio is currently being written back to storage, wait for the I/O to
+ * complete.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  */
 void folio_wait_writeback(struct folio *folio)
 {
@@ -598,13 +582,12 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback);
  * folio_wait_writeback_killable - Wait for a folio to finish writeback.
  * @folio: The folio to wait for.
  *
- * If the folio is currently being written back to storage, wait for the
- * I/O to complete or a fatal signal to arrive.
+ * If the folio is currently being written back to storage, wait for the I/O to
+ * complete or a fatal signal to arrive.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  * Return: 0 on success, -EINTR if we get a fatal signal while waiting.
  */
 int folio_wait_writeback_killable(struct folio *folio)
@@ -623,14 +606,13 @@ EXPORT_SYMBOL_GPL(folio_wait_writeback_killable);
  * folio_wait_stable() - wait for writeback to finish, if necessary.
  * @folio: The folio to wait on.
  *
- * This function determines if the given folio is related to a backing
- * device that requires folio contents to be held stable during writeback.
- * If so, then it will wait for any pending writeback to complete.
+ * This function determines if the given folio is related to a backing device
+ * that requires folio contents to be held stable during writeback. If so, then
+ * it will wait for any pending writeback to complete.
  *
- * Context: Sleeps.  Must be called in process context and with
- * no spinlocks held.  Caller should hold a reference on the folio.
- * If the folio is not locked, writeback may start again after writeback
- * has finished.
+ * Context: Sleeps. Must be called in process context and with no spinlocks
+ * held. Caller should hold a reference on the folio. If the folio is not
+ * locked, writeback may start again after writeback has finished.
  */
 void folio_wait_stable(struct folio *folio)
 {
@@ -670,10 +652,9 @@ int __folio_lock_async(struct folio *folio, struct wait_page_queue *wait)
 	folio_set_waiters(folio);
 	ret = !folio_trylock(folio);
 	/*
-	 * If we were successful now, we know we're still on the
-	 * waitqueue as we're still under the lock. This means it's
-	 * safe to remove and return success, we know the callback
-	 * isn't going to trigger.
+	 * If we were successful now, we know we're still on the waitqueue as
+	 * we're still under the lock. This means it's safe to remove and
+	 * return success, we know the callback isn't going to trigger.
 	 */
 	if (!ret)
 		__remove_wait_queue(q, &wait->wait);

-- 
2.39.5


