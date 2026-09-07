Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDB5C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8D96B0099; Mon,  7 Sep 2026 10:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5807B6B009D; Mon,  7 Sep 2026 10:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EF06B009E; Mon,  7 Sep 2026 10:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D86C6B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:43:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23E72120190
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:43:36 +0000 (UTC)
X-FDA: 85187234832.06.CB1BCF8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E55418000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:43:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JK4etrQW;
	spf=pass (imf06.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788792213;
	b=YInCKxbp+eqOAq8mCh13efim3vqSTtK15OZyxKlb+YnzLsF7RMHl3vyOwJAyPnIZknrsmk
	nR8QZROP9fH2VO+GdKF/D73jpidqFYANE+lKtEQwqIy+L2qYasTBQ071VwV1XNcfcaOzeQ
	1nj95U9SElVgfGnR8uBU7sMMVKo27Pc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JK4etrQW;
	spf=pass (imf06.hostedemail.com: domain of frankja@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=frankja@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788792213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+mKhim80xYAs5hcT3L+PfSKYSzwsv2rlQl+Bvqm5FU=;
	b=or/zP8wfkfPoB6a/av3Np2tktTfci5Z8D5WlXtCB8MXzm5sDjLMwlfGbw+Zp7gp70hHtaA
	ZnpW+JBqXQBRC9z6HGFY7oBgQbyzoaorYzpRWBt4Zbu5TY6pSwEY3PHqLD/uk1EQ5uZZim
	sOaLxQQ6WSYXR9y0lyRLXie5Ev0uIHs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687E1g9L281441;
	Mon, 7 Sep 2026 14:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=v+mKhi
	m80xYAs5hcT3L+PfSKYSzwsv2rlQl+Bvqm5FU=; b=JK4etrQWQ2Gq1pRuZ059wc
	9JjVdJHpJ27H1yOYmKGwGEbpDNjHldth+Cz9gDiBaVdruoaVbpYa98s/gsfGZkWx
	MqDgt0ZnK0hFfr88J2lttu/od8GKxjq11WxYjlaJS9/al6yo5A94wv5NF9NWVrth
	9AYFQ43sf2H87Va9QK5ccc84qBn3gxf38mgq1G1ULbfbA5ePHL/8dZCKWrzFw6gu
	zNj6OdZheqF5GNqJ57Y/wXw43FYjaXL8QC9qWOa4uIKrlumaC440SstuxrRCAaJX
	EHT7jfnubUZtxEQNpjLgRQSOWy42r7FECbNpZQ1hVD0I1rcfD9h7w4mOJUSAp98A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbqjs98q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 14:43:30 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 687EfMJh032284;
	Mon, 7 Sep 2026 14:43:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwgxd8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 14:43:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 687EhPqC45351172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 14:43:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BCB52004B;
	Mon,  7 Sep 2026 14:43:25 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CC3820043;
	Mon,  7 Sep 2026 14:43:25 +0000 (GMT)
Received: from [9.87.132.113] (unknown [9.87.132.113])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 14:43:25 +0000 (GMT)
Message-ID: <42c74898-939c-4253-8e36-3502c5f7b277@linux.ibm.com>
Date: Mon, 7 Sep 2026 16:43:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] KVM: s390: Replace get_zeroed_page() with
 kzalloc() for sie_page2 and CMMA
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
 <20260906-s390-kvm-v2-4-2cf6434e6646@kernel.org>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+wsF3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbazsFNBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABwsFfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
In-Reply-To: <20260906-s390-kvm-v2-4-2cf6434e6646@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6FAzLtnxf5dcnhrlbu8b0FSOghJMyyBl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE2MSBTYWx0ZWRfX2fxe9RBLNDws
 Vy0M7carWfEIBMV1LL5e4QZ40T12JTSP7BZX7CqH61Lo+6QI4ps5Nph3tuC+5KNdpluI63JrhWO
 1dbujENwwu7YzkautGnpe3cRBwuRcaU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE2MSBTYWx0ZWRfX/V3RMnXH4u4t
 oomeILWhRhm6BduunDQHQvU1MTwxKESu+K5B6rYJyPNXetJAn+oaY3jcY5DqKQqxVddWhxdsFBt
 B98o782QBQ2tE2tfjD1wbpYc2kC+TZuF/vv9NnS5xjscB3nWYdchvVJrY1qGOPePrK0HLO1ZdAi
 ZSeymtRT0fapG8fm6Dsj/KE9RCvF+9oBYJ333bYqWOsoJBpE8QSPwzFiUlQptGTUWtQ9zjjhpu7
 K5OJ/kfq2MZpdSkSZX6qfRQzInK1XFXfb0ygBS3h5fxlkFzUwtuzk9xorca91EdpfPmPzvGFmeY
 dh6w4bLAtdFgxQgWSFlDzAF0RS5yiLO/1c9+CYk1v6Xm68j4DrL0H2pQOu6d+IZcinbwHhu0SVJ
 d+iX+sewAhy77Ej2Zjbp3ZeS18L9lQyZpG0moyT6TynrJ1eCEOMXUf+npzqLcJE4dyJf8Hr1MBe
 WjL0PFyo74Xz5DtaP+A==
X-Authority-Analysis: v=2.4 cv=JaKMa0KV c=1 sm=1 tr=0 ts=6a9ecd92 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=Y6TpkvVB5ZIwULgkomUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 6FAzLtnxf5dcnhrlbu8b0FSOghJMyyBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_04,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070161
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E55418000B
X-Stat-Signature: em1kwz6hiexe7x14pfoxent8tpdmghnp
X-HE-Tag: 1788792213-538583
X-HE-Meta: U2FsdGVkX1/SMuBHbWM16ftspMdazms0QvjClRAsObdVJh/c9+5+Icf+900cspChAK66Mc1PQMNB+DfDkm4mXFl7UNGgZipRZQhHBka+mmRjMZMqL/cmkR78195UgguvBewCgsAAnSJDXmfv3tziXseOVrXR0YqDSm6f7y9RO7dN+FhDh7FcgAjPMzlHQDwugb1+OtXrLbteRXRGXRtxiUKuF6MqIVs3p3EJNdV7sv49S8GOo3CUXTcVUT4adwedlUlUMdRkAyApjSVo34GZQFtufEz9TEJctbKWw6kHdTbAYndYlNuZbcV3swup+nOk4xqMSVqg0CjRmZtXDbpJ5D9J1HfdJigwPyDNgefixkfP+G00+WUgfcb4pARwK/oi26e36u7+S+G4dx9WpXUERiyN6r5E7deCNbdnNSWUAi630Ich3zXY7VEY4AJvJ3Pd9OYs6+I5Zo4q/P9sGE3hYuGbCt1ZpqNr0oANrshLEIEM25CTGbHmJ1+zVBZ1FDejni0I9TParnoRW+3RD7ShIDFB/1VJQNUVzFeSJH0tHvmXjvIop3jrJwpmmig8ueBvgZKop3HBEXlNlDzWQBzGVJrJu1dBVqvXjV9baDy9z7pG3oHwFiWjXlfiNNnkXF4DWrXOc1Gok1DyAel7jlHrWkusbnI7SM7JjXlA/EftOIrin6gOJCHoEyHfMMdYPWf8ppHL4hGVX4OUkDlL3aMcZ7ItwtjictotWUhHiG7wufyc/m4svtc4vwvmGo2OVPq7nVr5tYYk4OrvPkhEDcYKjKkByA4oLwtVo2becbYVNcoXmfO7us5Ls8qjOAX5mAtXm5yZbEzr4FKmSNTjUFCaltKKjKt8WER3aj5oSwn8nDK+XJql8PhYHaPKId62ZX98DM1SomPvbaWV8ZHIwEinH6EI6dGLxvVDrNxC/6gPb43BEBz1mzduP4uDL9uqpcWFUmhWPoG/KhGnr43pyH0
 y8J8QRde
 /BdE9Xl+CbL+p4UxLWnHTSJqM0l2ag3VfKrocA2MnI4linnUPBZBX3lfjMljUf4J0YnqhfiTsJgg3iXDiYvxhPwcuthWKzqqiMu8E0t+b8ljYlKidoxx8lQ8sf0ofS+wkiaJcZ9cZf0SODvHRcxK1dZ1Ub9sFD5Xu0xm3tZ8btlXVC69BfJGWE70HwnO2aSzwGA7QPCKzLr0iDA6C/ttgnR0Y5Hr5DIJNuF62SuS7iwACagYERHnYMKVAGRE3WYPMbfQWYNK32YOTZ3BuceAUfqT2HQy3Md8lK57lzeHA8OhEX91+3vhywuoVdBImA2kbJNabAPYuqJdBKVnF8ZUESI1vk1o0XaiFuWZO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/6/26 10:27 AM, Mike Rapoport (Microsoft) wrote:
> kvm_arch_init_vm() allocates struct sie_page2 that holds the facility
> list and the crypto control block of a VM and kvm_s390_vcpu_setup_cmma()
> allocates the CMMA collaborative memory management block referenced by
> the SIE control block. Both are passed to the hardware as physical
> addresses and must be page aligned.
> 
> kmalloc() guarantees that a power of two sized allocation is aligned to
> its size, so a PAGE_SIZE allocation is page aligned as well.
> 
> These buffers can be allocated with kmalloc() as there's nothing special
> about them to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> The sie_page allocated in kvm_arch_vcpu_create() is left alone because it
> is mapped to userspace with virt_to_page() in kvm_arch_vcpu_fault() and
> therefore really needs a struct page.
> 
> The SIE hardware stores the offset of the next CBR entry in the low bits
> of cbrlo, so mask them out before converting cbrlo back to a virtual
> address. free_page() did not care, kfree() needs the address kzalloc()
> returned.
> 
> Replace use of get_zeroed_page() with kzalloc() and free_page() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Assisted-by: copilot:claude-opus
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

