Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E2FC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BCF6B085A; Mon, 17 Aug 2026 15:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF2A6B085C; Mon, 17 Aug 2026 15:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E478D6B085E; Mon, 17 Aug 2026 15:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B608A6B085A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3ED01A33E1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:47 +0000 (UTC)
X-FDA: 85111715934.13.75A2D33
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id ABA3718000D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mReR1FnQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EKoRL8ep;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994144;
	b=SFK6g3BmOk33ISfJrxYV7rIdb91r1oz6eGWsbpG9mHXV3D34uqCdGZLVq3RDuyOzW77A8r
	8bMQ0mWo46BhM4rV1KcXsTm++0cgViaTdnom0+AukcnDP4p0QgasqX9oEU7YeNrXBIGnIN
	RcoH6p+0wf/D8a9gp6lxwcNCB5yjUoA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=mReR1FnQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=EKoRL8ep;
	spf=pass (imf16.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7Us8fWg5hhgUppSV1QIr9mJ0JyWe8U/fZpzI/jv608=;
	b=b/l0w0BLVw0YSjsza2Zong149v9ML5eBTlskJ+1GisErg3ZsmveGEKUoskzsj9UJEmkZnS
	/XpCAJZ8WuOkPVAWx8oCDTD+5maKtmn8trKVsBQugRqHH3eBDwP/kx5q3/mYbqUq+zerU8
	Ldb8Ndj4qmKe0tzhUR3dQp7AygKb1BE=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIvqNc3692415
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=m7Us
	8fWg5hhgUppSV1QIr9mJ0JyWe8U/fZpzI/jv608=; b=mReR1FnQTlF6SCUrq+I+
	w9Dr5AfsKfP537a6YnpqVF3IM5BdSZxosqPmm1LPD4RDlo1F0vhiznlaSuseTS6V
	8C6IaY7irEu6js9XAEepKTfr1/XhgYJ82F/SSDc3gWHQoiv15C/ba8yJg3e0o1/E
	OWhSiOShuavAEq1LkP5dYyjm+SRkWUWMgtqfWXASa5hE1+erxZNjjzAnNfuZyJ50
	5SWoOPLflO+ly4COXffaAjIDUQ+WKoTsSr3rxGB3CWiXqEdbG5F7PAzVBf3E60R1
	yMSCKyHHNQCEUJez17zlmFtK+N8ROHAT0BErtwz9Y3VkdRZyDDCpKIrqVAxG1vbK
	tw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g481r85u1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:43 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e8004d60eso670954785a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994143; x=1787598943; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m7Us8fWg5hhgUppSV1QIr9mJ0JyWe8U/fZpzI/jv608=;
        b=EKoRL8epWjo7xAKwWZwC1nIA2hmJW278S53D5TXCjUb0gOlQgdPx9G1152x80zVL7g
         wGB8nvvOm/tCPpsTmEVURErkYsHHMI+qE4h3dGms3ObL06RXp7FiAg+ciN8IXd1+V5Af
         ddaMVot42m0E9pW2TjZYQJuIbLU6+4Ql3/oDnEbmgB+8W46jaN9LRktGV2FJQZ+XG53M
         0ysMha7IuVLNAdg73Z4Lk9+x18/I0PtyfohZIK7uebRg4IsvEc0uY1mVwRJExBuVfec7
         y2htioimkmVAxhyabpeSAQ5rmEu3Tf5u7n0GXf/Z4rvV7uYLxHqcs13tQM1XPcpyLbET
         B82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994143; x=1787598943;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m7Us8fWg5hhgUppSV1QIr9mJ0JyWe8U/fZpzI/jv608=;
        b=hZTGLFI36VafXHAtCulr6m05wWGcgilPqm/OLAp58ZhADDDeeW1d+AT2YHKKEtjPMa
         XAPDynqq9+3wBjptByIpp9zkkdyiMHansnniGcsqkzwmtpJ7brtPzcG+ez69QiviF3N/
         mr6DyKbLbMxwICdrB+BLjxjW6UgyM+s6KkmTjfNE9IvIU5h7JDFmCYhEqMlE+hjgS/L2
         U74nLb5oMMg7/bLwhkzDXX4rtyDWearNIRWu3dwAOXzqx4/VZCZCDZN1ov95dZj7RdIM
         rISHKNEeHuoGgBkpoIXs4L4o90Wuo35ujlDNi579t9da6ukiamoRnawqYUza2wRUQ8qN
         VYig==
X-Forwarded-Encrypted: i=1; AHgh+Rov30HJZ8rPfqF2m3FrczCnGkNdyZV4e0UFH3H7yT1x/F2tw3rFHmFJRqFOFBGfTJDPfxIBat4wTQ==@kvack.org
X-Gm-Message-State: AOJu0YwX3jgQpS6Hoqe6jBlgzirlgegCyKeFSXjEQDK7uMHRBt2vp56l
	JkO1din85rdP6at0mTwpj4igZgv0wSxkVABJWlvW0wkuIarUQz7Rl6KfnQSiW+dOj8s7doPX7V4
	KQn3fhUx33gAOaOj8DkDGt2AnqlWU7LVCXPCFEVYRZafJcEJp
X-Gm-Gg: AR+sD13vCUvSux5AXAYGqRFq6O81BUtXesOyUqGGGY3v9jtx4yLYqi8MmKrQLha2E0B
	wNjJEoAr7HKN9C1/EzGsKQHpeR752F2KtZsufG0jH7KlVr0kLmoTZyDwby9ZCzAcBVTaQzC3git
	XT6caapcvHjP11p1DtbnsX1svGAcoSXO0nu370shMNbRwxKUwCzZEniFsyd+ocgKBdGlzc6MzIC
	eQoVQMl6LzZ/YMVf7Pp6H8YSrItPipmqx7+jB7lISf84IKkLHL6Nw4vKVw5RUVtgTRQ5XqatwN/
	fyx5J9kjCJNw6Yq1jDfjx9kzb3ZUqZ5cE7TDgy9Yd6vl8u99/i5LFMl10FfM3W/pcuXs6txg7mE
	7UbYS/cu+
X-Received: by 2002:a05:620a:2814:b0:934:a12b:1d41 with SMTP id af79cd13be357-936d22ff13dmr2810091785a.33.1786994142825;
        Mon, 17 Aug 2026 12:15:42 -0700 (PDT)
X-Received: by 2002:a05:620a:2814:b0:934:a12b:1d41 with SMTP id af79cd13be357-936d22ff13dmr2810085685a.33.1786994142313;
        Mon, 17 Aug 2026 12:15:42 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:41 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:24 -0400
Subject: [PATCH v4 08/10] ceph: convert page cleanup loop in
 writepages_finish() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-8-0e5e53d47eb0@columbia.edu>
References: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
In-Reply-To: <20260817-remove-wait-on-page-writeback-v4-0-0e5e53d47eb0@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=2393;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=T5FG3fhAKz0kMpG0eGKGX/d3+iEP0nP9oBKuJs6wttk=;
 b=zjQ8ZG3NiJuKlvbWeB6va+eBvsFwnY5+DnPdg2m7mJ2GbnShZ7+f51yH0VqcAoCHzAULhHKt/
 rYqDp3ZLwv0AtKip2NM+8iOyszkU3i2/9/PfK5kFRTkM205RbtNKtbx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX3X1Jr3HeGXpn
 3FLg0K1L6AqhjaCdrXvhArQqGkJPu9XFx9MLFJ/g3ryuKQDGL3lnUcnQQtu3/+cxeEJ+u/gaNth
 CiMv1KEEM3f2E4c7a7F9w7Ut2oMyekzW+52+vJSMAFZ53xGKvcce
X-Authority-Analysis: v=2.4 cv=MOpQXsZl c=1 sm=1 tr=0 ts=6a835ddf cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=PHYVD-oPFUEr7kX-Mb8A:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: wywMkYdsdNXbBudP1mkl13qxis1jcVuf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfXz7RQ4CVPd2Kh
 wHSmoUk12NgeM6nTP00EE+XeDd2Y3Kxqgx5y7GQQQdSpEETftNzw6AVQx3Am2ZBTuCNDTyZWArJ
 2SXjDz8ZYxRrNneem2fOr/O50rNDrtJdrHCp9b809Rh1Qw0SRKhMJfpkroskSwDUrAU7jZ5wSW2
 zC+Y2w8l1BQCAqkr91isclaGEZRNSvxIehoxFgLINGbj5UB7BA+87giDA7H6aeQMyz2uDZtGJUG
 NIZ5rGjq4aKTFtz9ucHvBZJzpJ/JUQ4VqU1NMF56msEXZi5YKqvFEa3KzuE8L+L7ax++lIJ2aZA
 Z6RFii0Jr6VuO7SzkuTeP/B7Hac7Po+5dU3Nz6S+3+SwT42tUYwbSDa3JfpmxWO3Dw5Wo/MJlck
 4jMlp+xxFr0pkJscWchsd7SJMZSw2+pXVRB7dch1Cf8CH2Mr5LqPkY9QYrSguuVMvCqVa6CyRQy
 I7vhGs8Emmt+z1EzMSg==
X-Proofpoint-GUID: wywMkYdsdNXbBudP1mkl13qxis1jcVuf
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=10 adultscore=0 phishscore=0 lowpriorityscore=10
 impostorscore=10 suspectscore=0 malwarescore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABA3718000D
X-Stat-Signature: cy4uby3azpccytw818j1gzbwgym8i5km
X-HE-Tag: 1786994144-786964
X-HE-Meta: U2FsdGVkX19CqSIHAiWxViE/fhT2zIpSkHGiCM/tBx7RLAaV25dRXC1fcZ9TPWLxxxGnihZcnQoizQ7tUctY6s8X59D5YH4p4GrmzLOZ0ikPiz1N9p47K5Shatn/MqE3s3zrSkXIQIlZHubemuFXC9lQJFP3ArFSWlb4lNTZyBd/igb84yMxFqimMSC19Jl/w9F18R0uJq3HXVd+rgbRYcTJh+GQxfCBXWbfNCMa/kih8w7m4gbWEXe7MwZ9YvJx1kZaT30RxJiX+ohPn0EWUftVKzoPysyUMZXwtBr2BEQ3WPuXA+JRSeqnmVv5G8nb275oxG+OMeI6RoknEczZD6FR4L+0fYRyTwOMAYKIhPTieMJA1JannGDgwvVGFBWzsNe4tq6+YLqr7uqfR/pJDIgBOoyW1NoZDm3ewq5DrSWN4qccyEydXlMYtZH4jXCHDHfOguo5DHZsFrzjGCcpV7LsPwWaqM8jfbIeVFWx6YFdAeVVR8lyUpOk2Hdu+QECd15rNVHMso0Eb9aw4Iw+A0bcgirdyZNXvihNGC2H53tcvEUdTYNnPwA+PH9EGM7EdVoIW0dxdupD3UC5FM+MG0vJTsYpdm9MPWJRhjA/kqwfB8p8EwcJ6rP+gMA3xQ8v2Ex7GrG+Gb54L9HfUv2OfsLJFI2CD/Zpk57wXQn3p75fgkpaxVv3yfNdA3c8IeEpjiv7tbpYgIUXvOiVUbgqAzwGCMs/QqTrgptV9lThDtOYd6ZtiQmrWkQtqab/OSEjuq2MAH5/o+XyCtbew/bd4e/dW/QtFuYlqOl/3k97JEsYR/UhrsZQmadKELjK8BqYaXTIgQ30tHTpTtkwhHxmwPJwgcLTPMi0m6ZFfmVydghTn6veRpHkVwMXpymvRnrndrpxO7+eniQ7rBHMsZ2dWx9gfsE+Krgxm8V6Vx1JITwgDyK8PYu/R/Q2WUQMRPh/X3xDjmgNb3TUlBdu58e
 sXCx2N9v
 Frs54LQ/R3NSbitIwD12N7xH1Ke3NsazoEYKUIt6nVWtjYVISc7Ne0/9R1DpYDGiyHfusGiWlFYzgjIDsRMAY1x7MVmnbOUlMk8Nm2C79kke5rzzq8D1h0mBxoxjrO3+GUnb4yVd8AsoFNt9QRIcxvH1y2Ggb1GCgQVaLOkuqr8li/p9OPbslYQlc0WxZF2sGBHG95QsAxl1AjdvwTeU4s3N5C5+v8tNImVLfkz5ZrwlrPcO3J7TrLjsRtUukI3YY6N9Gi9I3iUMGFJ4CkoBBNsJbJRjq8neUluYI1yQoZW/7u+HM8PAxA2IE5Gi6YMq4XiLCGVxHgGneTeehcA2QaGhtHK2FgTDjTNT8eE8ViJsr0I6YqJS2TWgWIDJvobUbFPhug1IEeT9zx/JtFJW1owToE3uNKmPrUfsBAGF6SLulehzfAztzuinclJtWl81LSEkTPA8xv2Viu7hEs8SyAgF5PapG1evKeD2v9/C9BmEhmFNEBIM97w7aqptd2VMGcAbTfpmHc9eUppRbcemOaWYJGmWO8AQy1qtk9oDFEPIYUdxGzz+y8/BMjjdihVxA3uPWfSi3W3usdReLO8X92x5xijfIWCIbFzPf5njyWcZxWXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the page cleanup loop in writepages_finish() to work on folios,
resolving the folio directly after fscrypt_finalize_bounce_page() has
replaced any bounce page with its pagecache page.

This removes a use of detach_page_private() and five calls to
compound_head() per page, while adding one back via page_folio().

While at it, remove the BUG_ON() in the num_pages loop, as it cannot be
triggered.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 756d44eae838..e1ff5d9fd121 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -908,7 +908,6 @@ static void writepages_finish(struct ceph_osd_request *req)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_client *cl = ceph_inode_to_client(inode);
 	struct ceph_osd_data *osd_data;
-	struct page *page;
 	int num_pages, total_pages = 0;
 	int i, j;
 	int rc = req->r_result;
@@ -955,31 +954,32 @@ static void writepages_finish(struct ceph_osd_request *req)
 					   (u64)osd_data->length);
 		total_pages += num_pages;
 		for (j = 0; j < num_pages; j++) {
+			struct folio *folio;
+
 			fscrypt_finalize_bounce_page(&osd_data->pages[j]);
-			page = osd_data->pages[j];
-			BUG_ON(!page);
-			WARN_ON(!PageUptodate(page));
+			folio = page_folio(osd_data->pages[j]);
+			WARN_ON(!folio_test_uptodate(folio));
 
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			     CONGESTION_OFF_THRESH(
 					fsc->mount_options->congestion_kb))
 				fsc->write_congested = false;
 
-			ceph_put_snap_context(detach_page_private(page));
-			end_page_writeback(page);
+			ceph_put_snap_context(folio_detach_private(folio));
+			folio_end_writeback(folio);
 
 			if (atomic64_dec_return(&mdsc->dirty_folios) <= 0) {
 				wake_up_all(&mdsc->flush_end_wq);
 				WARN_ON(atomic64_read(&mdsc->dirty_folios) < 0);
 			}
 
-			doutc(cl, "unlocking %p\n", page);
+			doutc(cl, "unlocking %p\n", folio);
 
 			if (remove_page)
 				generic_error_remove_folio(inode->i_mapping,
-							  page_folio(page));
+							  folio);
 
-			unlock_page(page);
+			folio_unlock(folio);
 		}
 		doutc(cl, "%llx.%llx wrote %llu bytes cleaned %d pages\n",
 		      ceph_vinop(inode), osd_data->length,

-- 
2.39.5


