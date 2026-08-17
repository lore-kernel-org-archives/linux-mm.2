Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E935C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 19:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC3066B010A; Mon, 17 Aug 2026 15:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AF06B0855; Mon, 17 Aug 2026 15:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE106B0856; Mon, 17 Aug 2026 15:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6056B010A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECB1C120507
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:30 +0000 (UTC)
X-FDA: 85111715220.16.67E70EF
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5DADC40008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:15:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=N12JWwrf;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zW30woLO;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786994128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fr/QNEus+gmPbGxGS6P4kCT2ytKtU2/npzD38c26G7M=;
	b=jnyM03yWGr/MqcQdrIFcVNsEkfkKyTV+TCFZrvZ139Gg+wmGCTfzMwIWMPsglszGXd6jDL
	QjpMJ6D/dh72xDZeAGxBRJ56z1gRE5svlXnvYkyh7EuDGbhGYZg4ZItMlu+DrNou5xt54Q
	AGpGQ/cTcapxgtBB4yLLDxSPcq9bfdU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786994128;
	b=wiGd99DEDu8CDn6sUP6PWsFkJUO5sYYXXj3pHA/HSX/s4F2ZJkjtEazlIQOnmmkfXO7Iyg
	sOxtNxOUrl53AfZGMbAmXIOw69JV3r78Pbe6/kzF66XTOGQVrYtY8F0gHUKIkaHNtyoFZu
	0hXkLlWW/JdtcdFoskefyJuNMM+BHiY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=N12JWwrf;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zW30woLO;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HIYjtY3664092
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Fr/Q
	NEus+gmPbGxGS6P4kCT2ytKtU2/npzD38c26G7M=; b=N12JWwrfNxhrI6dS50j8
	yaF/X8kkPkIb3jI/CTI8yAsr8/Do3b8Kl2+S1Iug9aK11uLpGQFWgW482DZfvdOJ
	eCQJnMuDFbXCyXrl34NCRbGdk3y/t8qB7DoHYFJcaIJwx/n6IAyizBe4vHqEHAwv
	JyYRlJ1pX05m4RhBZm4nRqNuKJNnq3opWqAA23rL5srK2nLHVPZyn80At19GbEy5
	y88n+HlVzbB5Ai7kUwjyuNCrg+GIuVwCprksf6xRjsALEPqR7d0+pQ8t7YT3lic7
	2xkozZgnRP8GSuinJNgmtgSIBhJNaarNa6n92UuU2OHb70TCdKdVo6Mra3WvMlJk
	kQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4g3mkfnqg6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:15:27 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-9349c5af52bso635115585a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1786994127; x=1787598927; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Fr/QNEus+gmPbGxGS6P4kCT2ytKtU2/npzD38c26G7M=;
        b=zW30woLOJlBXJPlDJKnRUg+qNDn8wab0k4bm4niuCBqJsn2fyet+kN++rauw6s3Qay
         GatgUjuvFDDIc0ZxsjHnk5+1ZdK+y9DYRyDMZvlG3kqODOCZd3eWycdJ9YJdBUS09iSm
         KGjvR4ti9t2ywApOviraTih+ckhLPnoklnqnLfOA0GxQpG36yJX1Bmo0OzKPgjsWQKFy
         iVYFeZ2bQw5fcAiotQTXUtkZzylJkkhsv4Q06FGrdz4DbWzjGUXd0c+wvpBHt4uJJare
         4glTQFNx4KtzXfTonYGEffgQ2w5m3kuoiegpchk3wV4yM7RXbU86ih4khzCam0EVI4a6
         56dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994127; x=1787598927;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fr/QNEus+gmPbGxGS6P4kCT2ytKtU2/npzD38c26G7M=;
        b=CogvPiRdyZHfXsHPkrRFbiu6vaW1KIJ85Z0mHAO6dHSy3yfWm39CuoPJoZZg/ZZLr4
         iu4410swZfnmmDiKAe2P4iYPZB11bar1H5ii/9ZEQB2dtuDaNadJno39JzdwRvXIWUuC
         lnKEuQXRK9qXGxAkiPhS/gk+rMVKEfejTMEq+FzW3+arZQWqNrOUGtvsvwy470kNm12U
         QrpaXsDF+fl2v19wwE1jDwODXtYcmLs8oc0RNrb+UbDf9OBrh6ZOW5fGM6haQf0FK0Gj
         FKxndm9BqulUlxQS9u0VZTkpuXrYwUPC+ZDINWPnyKE/dui3m+1Pq/QtCUdQKWpI1nfN
         bIHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpgChRERqNL++rF1zy+KLfdCvYh9dqe8oUUh8f3LQadLjCrdbwdqcjMBlNqUs13fchIdFUie+Vm7g==@kvack.org
X-Gm-Message-State: AOJu0YzrXk0iN/Vd708mW3PAgf7aPupoNwXKDXZN4w/m7qQcnJsmPYHM
	jbcGJEtRKPPedA2rqOhCj0We+DKKreYWsuQCdp6hL0yn+EM3ES27KVRwflgl1YGepehr9xPna6j
	JLxGr/J+kFP2ui3A6PQ/qbST0CjIUmzeu1PwaxZFpPR2cxJ6b
X-Gm-Gg: AR+sD13gLAcVMSROBVCrupCDffzvCAogcO4hawsuzfO1Iad3ru7Zl/cY3g9N85nNcOi
	CHaB/C1CR82jFCLT2RiuVSHDVExskMCB2iVMwqQrT4bbvIgexzPz0wwqmuO1bnSlqkFix2G4iP6
	0gwSpJzQkcKtQn9lz4GMsDURPKRWEyyLbqfDzR40UZ6SqJ/TVy1HHRQlflBi7Jag2ilxOkVHERQ
	dYeNzEVkAEz6ugXjwiFu9spGgF4my5Np9vd1OsKbJOa1oRgoH3tpMyrI1W+9p7IUT5UINGyTra5
	dEfs0XrKlifwCVphPykEmVevWGyQyvY9wwaOcX9WQY5bKvi9Z1f9CCELBVcBkXp0mjjjGGtgFDE
	f9oPEodWX
X-Received: by 2002:a05:620a:7103:b0:92e:6122:130c with SMTP id af79cd13be357-936d236d3admr2634575385a.34.1786994126486;
        Mon, 17 Aug 2026 12:15:26 -0700 (PDT)
X-Received: by 2002:a05:620a:7103:b0:92e:6122:130c with SMTP id af79cd13be357-936d236d3admr2634567785a.34.1786994125824;
        Mon, 17 Aug 2026 12:15:25 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.67.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499961098cdsm194692085e9.6.2026.08.17.12.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 12:15:24 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 17 Aug 2026 14:55:19 -0400
Subject: [PATCH v4 03/10] ceph: add ceph_folio_snap_context()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-remove-wait-on-page-writeback-v4-3-0e5e53d47eb0@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786992937; l=2021;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=r7cObkaVqRRIL+wdtu2/yPB7QQoopFCx7t+aV7SgOc8=;
 b=qvfXwcd+71pgd5Ui7KZL0V6VYseBVVLGWlAU21ogyGiBVWB5xn3TcbFuBch3EiRGKffdXoJqp
 qihhI5u3EaDCzyrd6mNyEW6fAIUjT6G9CShNL571mtRopekHEAuEa5z
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX4F3p7HaFo5E5
 3JSIGk+jBzksuNb2hUgQ4d9HRJRRMgbC81d98TyrxoiyOlqPq93veft4spBFIqiqj0M64QJ6T03
 Vsokte7Kof1iM7zOXbgcOI1K9bV27GHH07oFKVfLMMo72T/8I6WQ
X-Proofpoint-ORIG-GUID: MUQor0AgYqT6e6PDXri46zkGMTn5kvy9
X-Proofpoint-GUID: MUQor0AgYqT6e6PDXri46zkGMTn5kvy9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDE0NyBTYWx0ZWRfX/HtBDhh6QJsq
 ybSitTLVXnXVB40OowXuJ/70EOx//tBThkM4z95dEZ9DKXtR3+lu1g+9dLpNRzw+I32F/GrXO/G
 xI47wruG5N++m1PI7H1CbEy29LPsbaCfyp+ulGcgCrzlA21lHCjUqxd2xRg3tyiFy1Yyc1Gp69h
 Si7/FJmXGtro2fjQgysVY7rKhWMs4XNt9Rkrjp1rn48OL6p6EbScKm4LLO5ecik4ebvNgMoT9HV
 i/Cws69R8MAMfagEjnVqiQhkC+Kk9UP3A3hz1ss7goXXbIWGImuGo16DYR6SQq0Um7iSXvxsGFf
 z2cszTdy0Sy/lPBsuHjMR9xUnhduSQRrvFgpjQ5WTJ7fkDLWGm7XxgBvx8Tw3SSzYM383jlUc7D
 xaOloB3DOeLc06UCITW6lr/giNDkmT03hqLetF4l2kiatPi5OFqTXxOyR5yqMWSdFpavDgyUS7+
 mrgJm95lNVCT2hnIXhg==
X-Authority-Analysis: v=2.4 cv=C+vZDwP+ c=1 sm=1 tr=0 ts=6a835dcf cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=+gpNN1aRt999K7yrv1sWlQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=JfrnYn6hAAAA:8 a=Ikd4Dj_1AAAA:8 a=bg0B0yAPDd754FioS-UA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11878
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=10 impostorscore=10
 priorityscore=1501 phishscore=0 bulkscore=10 clxscore=1015 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170147
X-Rspam-User: 
X-Stat-Signature: qairgbr6cpzc7utq91yuds4grp5w577p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5DADC40008
X-HE-Tag: 1786994128-269932
X-HE-Meta: U2FsdGVkX1/iVq3cY3idZYqft+9lsIoZlmFYd+gQyXJrDMHJoJShA7PttTk4rdPDNE8w2+PVvSz7LB3MZ4wY7zknKqBdEYpwfaRFPI9faikiSdO5YjeS5GnLyYE8EzkUc2jfILF2+FfYWnLGcMl2HnQBqGdgJ19CJIQyrkB9Zi+j8cUDiKasIMWO5dFEue40pB2cXzMmMOLbaAm49E1ZgL4HCOvMGc2YVO2H9yS2zCnLcgk8PHgB3Eyn0taWHGHuFMjo1AXtT3KojacCFU/IOXtlt21ks4bE/muINztDe3raO8MoylOriNFcuJ7K3yxHQN99Y40oBnX7KGfkAGImelWNUKQJ4N3llwvNt7jWHPaqdTFjJO0H2jNgbXsKWGU7rnBcYE1z5hLxDoaGTAORdFCIOyzzn6aIVcWIzXyzY28vtxqt32lZNtOqquscnm/s6JOI0Vaxnzpeub8/hQrMY0iJ7+KCWy6cIjPaqeVOlkN2ZERjHy5Otp4FLCEw67fXIlIX0na4XQ9vwvkFP4HJzQ8j5F8wiKFrzlCj2P9ipwd5z0wHGJxmUI5EDgEx5AYHfaPzHGk0pnFv1x3+aXKbuwxUboTQ+X7/yLYc0arSFNp9yFCoS/mITm6AvwL315CBUYL/o4JjvDb/G8c1TDpMegNALNsXzJ+pv6Q88SL4lz3mMbeubX15kzEw17qyg0lCOgnhRMWBDO8CeqU+2Ym/oerxnQx3gBfEWEvL3hHE8QT+BM4RasVNDXs6gnsbTRBij1hhpNRqAl2S/2m+y8DagUzlWKo7mP1I511cbYiEXPrrmCNRjPRnNSQbL8TH77dhJqHQNL/o1OkKiOaMQrLXICaSU0doHNO4l16vbh48/vkwm1htBdGV6sTiocaFLEA7kHwPTRVKIIy5GqM5/VMFan23o3VZSW0qM9ENK2p2B8/LW3YkFmxbfn/9aoM4SdrdNQLyx4G2pvJ+qWd5364
 3UZpKN31
 3GmWvMn7C7YLNOfseaRAjLf95UiqAKvR1rJuAWWDKuyhbwP5tNAMlLZRmk422GlwQfpsxD+Loq8mrtB/+o1rgnCECJlDHsaUJP0yjlhmW1430HQOSteLTswaosWWGUmWV82PNobnZYsUsCdyWOZ7Y8gOEKOUeY1SvPrNv7YXxLODBXiUlJt9Cnbw2VaV0OLTe4Ln1HC/zdl89ZQEIN6WtpgFBxrXF6Wgx7qsvBxbP5okDQENPjBmP0k3mvHcf0MDYkBF3keM7KERy2qLGhG1ZCoItxfkXfT6ANJ82RHKZOhyfBfiQWMQiMEfxy5qelnvE6Lx0NPZtu5uOYmowHEW9iNHldAxDKI9ahisLl63uRaLIzmDsZSwi4Didw7JwcdtET7I2YRUyOUfkPTR5+SFJ1K7k2lQ2NBMaLrcuup6udtOvh3QPse5hHZ85zvC9kg3aF+ESWBRARvyTS/jWuimPBLaJ61rvoCjQcrAs+V3uUVIYEgQvjHCcWvsdoorgjsyhZGe6c2aR2xcyHwAWMz7R0x92GuspWAEbt2y8NguneNZ8+iPtqdkD4Co+ZQhzIqr9rTtpUdfdHjyAJFlPfo8ky5uXaAwkVuHa0dQ2udWCNSI9y/tIHgmU2oa3oHU+3R/fmDwhKOk/q0pNru9V0fSBvT1mZOBnd9TPDhj2V5IPucLpBIUqcuXZis0IsRoXaglgH9fp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a folio-based counterpart to page_snap_context() that reads the
snap context from folio->private directly.

Convert the three writeback paths that passed &folio->page to
page_snap_context() to ceph_folio_snap_context(), removing three
open-coded folio-to-page conversions. No functional change.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f1f4caa8f9df..60955060dd1b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -75,6 +75,12 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
 	return NULL;
 }
 
+static inline
+struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
+{
+	return folio->private;
+}
+
 /*
  * Dirty a page.  Optimistically adjust accounting, on the assumption
  * that we won't race with invalidate.  If we do, readjust.
@@ -758,7 +764,7 @@ static int write_folio_nounlock(struct folio *folio,
 		return -EIO;
 
 	/* verify this is a writeable snap context */
-	snapc = page_snap_context(&folio->page);
+	snapc = ceph_folio_snap_context(folio);
 	if (!snapc) {
 		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
@@ -1183,7 +1189,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	/* only if matching snap context */
-	pgsnapc = page_snap_context(&folio->page);
+	pgsnapc = ceph_folio_snap_context(folio);
 	if (pgsnapc != ceph_wbc->snapc) {
 		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
@@ -1851,7 +1857,7 @@ ceph_find_incompatible(struct folio *folio)
 
 		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(&folio->page);
+		snapc = ceph_folio_snap_context(folio);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 

-- 
2.39.5


