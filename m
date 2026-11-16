Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCDE606A882
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dHwYQhfm
Received: by kanga.kvack.org (Postfix)
	id 8486F6B05B6; Mon, 16 Nov 2026 10:28:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8202E6B05B7; Mon, 16 Nov 2026 10:28:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F426B05B8; Mon, 16 Nov 2026 10:28:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4912E6B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:28:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBE5B120156
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:28:34 +0000 (UTC)
X-FDA: 85441364148.15.DB0D9ED
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8B6081C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:28:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dHwYQhfm;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xptZYPDAQTj3l9jWzdgLCCl+UiBE0vVZqBjyqpYLXog=;
	b=L1Y0/sIQYvF7NL71tcxTEC4AHMsfp9SAhufjc/+hG7u3mYWzYnzTtul6130H/lxZA0eArO
	dO4dYezRqjMU77nC3tNoSt5n/w2uph/uFKc5ZvvD4LRih7/ub2JEEaoi8Mv6AAu/3T2495
	kReW2cyaxa/20rdTcabXyDffVe6mj20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dHwYQhfm;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842912;
	b=R+CDHDM/ai/IZF+Eo1UgfyzCNC7SCD3aaMm2Hf08MdXHA3fsShFUiAX24plL2b0+ICB6oq
	0gaSIwdjlALLzpnRAISHuuztDIe1IQTg6J5AHLv/VwNpwTUqxFhFEX6HgrIBcWbiqKnMIJ
	nWGYBNvQpYPjVVeZVG11itqFGjb7aiU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGDu11r3407802;
	Mon, 16 Nov 2026 15:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xptZYPDAQTj3l9jWzdgLCCl+UiBE0v
	VZqBjyqpYLXog=; b=dHwYQhfmVTFZiPnd5U6ir8G8LdliLacIJ59Py+is/DiwTp
	40VOAS63MpSKWrqctTH/+pvid1a9+E7mGtn7LPND8m5H4QClqsZXJiDp/tJ6W0Wf
	egzdDkNYBVUJ6bOqD5fqG0Y2Fd+k4PLySueg31kMghhO9cXJWX2Ds4j2NTaHJk5+
	fksEx20urRC/OomV8ncwtROERrdfxAKyd2EYBpyxrBNahOAnESFgFv8uMYKcJxTa
	TcjZCOR5B/aATS3islMuHB/TIcA3ublN65nFuGSR0Ka4wwmipLMdnkh8jhVUKeJ3
	kvOKak6Bj+c4K9GV/ERxfqdK7w3Ivfj075raEIcg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxd2kx02v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:28:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGFC49F2972402;
	Mon, 16 Nov 2026 15:28:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4j00ns9a30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 15:28:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGFSDWr30933298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 15:28:13 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCA6F20049;
	Mon, 16 Nov 2026 15:28:13 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 605E820040;
	Mon, 16 Nov 2026 15:28:13 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 15:28:13 +0000 (GMT)
Date: Mon, 16 Nov 2026 16:28:11 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/14] s390/sclp: replace page allocator calls with
 k[mz]alloc()
Message-ID: <20261116152811.165348C35-hca@linux.ibm.com>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=B6UsQ+tM c=1 sm=1 tr=0 ts=6afb211d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=RFWjAfAvn5XsmgsbDIkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: j8eG1yej94bfWv88N2-2XTDuffFF76CY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfX+x6vtnQgWfwA
 jwKnlBTp9JiMPvZnGVchhpLgnBHf0JgsnQFzoYRr8P35rCshGAOeJfm7gLde5GMxyEt/l8eh2U5
 V0cxdApBLJIHZK0csJF1Nf99HwqBPWk=
X-Proofpoint-ORIG-GUID: j8eG1yej94bfWv88N2-2XTDuffFF76CY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2MSBTYWx0ZWRfX026B3Y2k4d3D
 a7KazmPylNWpybs2zmfMsiRjsNQGbGlD3AaiB6SBqYKQvh7hY/wgFDjbmZM6xCdUlqECZi8EqwL
 BoMm69EuI8fwmZwYr1tDewxxl59VOBg/3btkwhB3nPCJlC8vOZXDkcRJHrutdp4YG+XIi181G6J
 AhfEKsTG8Z0S2Ddjzumy/Y6fmF6Wfna4K0nIGXN1bxltOprLrqc7LaMZS6RkBuBIQW05pagaL/H
 XwiLQ0UFWf1fjljurWteADLysrYpavK7Q55luBHGzGIDKBoBmjyOxKN+5HtqlQOrGD7RZJr2ToZ
 UV8sekVudsKIrDM1ydZVgO3zulmRC6UHHG+rqZpBvc5Dayn913baZgTFMKZd8MN6uVyMY0icjs+
 90e/j2mSNKIWVQJXZyXzbFCTJ/LnfnveBTaBPkm/fxzuqEGCP02kEpYDK2xijarc+H98DsgucRr
 a/ky1Rfxxd3NlxZuwJw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160061
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: oyk99zhkenne61uj1gqg3wcew93re91a
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B6081C000B
X-Rspam-User: 
X-HE-Tag: 1794842912-155398
X-HE-Meta: U2FsdGVkX1+dfBYW7z43lCsQYtyQQIpn4eE7Wxf3WfN6/bCu5ySlTknmdIVLj0MVeLKlpWZ+NGEJJm0If59d/owHQ/idb2BPGoVpYeVBgf+jx+FUGVBZdbpLEeuStSwT7R17Izy0bng54VnyhNKF75L900bj1/sh3qDHDLRUjbSVuVzRzNq7G3rp4xQQxvq8OW58isYHPrA1Pprdh0NKPCDABkU6ytNm6mwxp2VAXq1fr+O4epq0r4H+xDAXvvuF5hB8M8yNNfqKKCA4lXE1Kp8wQJwxIbuAnnG8ZTelq4ZhInCeiHEW7tZy6zMBLNPbYA/U+xP9bz8wuUrTtLhDT81HJzWUIeIgAjZ61vyBI3UyP83mlxN/kMcCwHEm238nAgkYXGu+tJR9lJJ46vkaE9Gr+yRK8qLVzZypdeHsLaifar8frKMYcponXTimTJctusPKO4fnl4jSTZGPwPrN6+VayxIEwhpgOjJu4lYRLe0/qCDPXLwNEfL6r3s3X6hj/iw9Gy1rG0bsULBihFk1jN0wSQKnkPTcQstuNwCudRKWACW6vrFNEa98kn43ZfU0b+9N21+Enrjjj6MnhpiCqCgpgHwFAKjnaaUw2R6fsVZmTSCZDSnmMmPFg48gYCfZfoswjCLtwzLSDNFqPKw8WN1MH3/rTOmvGrREpeXHfSD6uohQvwInWJcEXcqVvjHXSlWxZ6PSuf4oUOC7JHKDBrYH7PY50cTVjv/No7PWQSF6viMV04z9VIg3Nk3cM7oyt2Yd4TGdHXMbE/Gv20BxMHdj0WjWo2ffyqymjl89eQy00Q5Un5yjwub852sUC4NKx+ZSTgVwtT/Qv2LYU5PmhnLpvyA6Cultd0Gm2WthXf6dMspaLALTJ/x6Sb6lc5VahfBj7mvk4v56XdAaiQQlPJ3SzD6KDZfv/TbrGccotn4djh4raO7tcyAEB23AO9C5LDQe5GskKA3mgem6aLf
 ESB5g4fK
 c8h5nNYdJCjYaOT1leXwvDCJQ6/4FE7MDgE0tZYi64wags53cmTtH4M0eA+NPV3kD1u+2/rKsNwVJoDh2nWdzdN46PnnkiJXCPTxBw+MFNOWGbcb4qBR3WkPabM8ZJQ6lRjVDf5NRjdVMZ4jA9hUmpC9vdrOG6I6FV6i7fVBf9Pk8LRA7iBQWMbdrL8XFCUtud5cdA3Oka9G7cH9f7AgrCHAq/Usp69dde3waMsRtcb26hLodsxi9HsR2xC8E9GlINQy02xUGZCbipHUy0Ys2cAiKXTa2lAFtwutx2d5cn2WkkYhvupVMgfoSE/RwE4eT3UVsmonGirDnXmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 08, 2026 at 10:58:31AM +0200, Mike Rapoport (Microsoft) wrote:
> This the next episode of conversion of page allocator calls to kmalloc
> family :)
> 
> This series covers SCLP buffer allocations.
> 
> = tl;dr cover letter copied from the previous posts:
> 
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.

Series looks good to me, except for the two small nits.
Feel free to add

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>

to all patches, except the two where I left comments.

