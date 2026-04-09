Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B6F1F364B1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC2C6B008A; Thu,  9 Apr 2026 14:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D3D6B008C; Thu,  9 Apr 2026 14:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4BE86B0092; Thu,  9 Apr 2026 14:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9595B6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:59:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E26988611
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:59:22 +0000 (UTC)
X-FDA: 84639930564.26.7CB4D98
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id B298810000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:59:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EHz3tC4l;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775761159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83mNKZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=;
	b=18OMmkPjpRPPctzikGjMBgm1bODSAk7dRyECsOwkP5o2x23ILWeI9JTjXuz5C6TL10F/gW
	I7qG5jhqwbjGtv+w2TKNd5Eu/Y+r9IgT1eouhQrx4jTeog27vfSR5zBINUlDMtTqhCQGRa
	mTKgk1rlLp19h7oDuqWz1AsBvoHMGWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775761159; a=rsa-sha256;
	cv=none;
	b=mYdUSPs76Stwg/4nu+P4eGgpmp/2CMjxAe+NITVVCFi8reYjm2OIa/DUUS7Lbh/Mdekuap
	HaowsBl6FKyRJ9t7xNIFDN49jpN4VKUC6R4jVtpWPngIzMv0gUik7bTvcEdUHP0yJKx8hO
	dbvA3UNjvwHL1IjIPezFOeQaEWEiigg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EHz3tC4l;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639Iu4WM2862184
	for <linux-mm@kvack.org>; Thu, 9 Apr 2026 14:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=83mN
	KZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=; b=EHz3tC4lRgXai8PvPEZq
	pkKUs3OvD5nVT1jqwDXFpk6Rhe9R5SxV6b/feB3LGa6Ml2hWQWH9nTOnbI0jQzLo
	QLYJRGLVXQOHbFB1Vy36nqjvpb9IUyFleXcX5OznP1OtLhuMvp6uayzuz2W+yvxa
	bs5GuKsexDDUjrZp0lEwLGsyCESY+7+nHbIsv21ltQxArYbn0i1Bt/Bmp3jLurPn
	iki6jHLGtAFYO7D52XkMbj6PiglwXmCOboDjwVU3VjlwlhD1YByF+WvnaBhABguH
	kkai+Ec2gVbgexur9XaYmeywsRhFC5Ikw68louduoTGyWGonKSBQ7TCwkUGf3TYB
	lQ==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4deea525hh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 09 Apr 2026 14:59:18 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-89cd4f56e89so28482716d6.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:59:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775761157; x=1776365957;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83mNKZIsBND3Lg8+THcthV/SuzYcLTq1w+CNeg0fbZc=;
        b=U9ZWw4h/quX91R78iGRJeMZ6nC/KbpUcDa4Cvpj01Cyh6tDtO7YBEjXeGjDIS/+xFK
         +MwoEdBholxZspaAwMLDI9IaGXQ2o2OPhnUOnNpn3Tezxpg/RlcqOvXTHTpkxpKA5ReU
         PlxiDQHKvjiMbm790WbX9EDZHyIShJPSvbuxDbMNu5ueE3z/4fAbQ4uedWRwMT95+Kil
         TX9QLOyG+oJkrhd8iHTAQySkZrh9eizNgZfYhem/V1f0xDpRmNM9E1lJ3LJFBY3Pr9Mu
         CN5vYV9k4y7nLBfCVMgn1udZb0fnVXFsBIykO15iNBX1aaBOlYeomgz+/aba7Z8alnxZ
         nuqg==
X-Forwarded-Encrypted: i=1; AJvYcCVDP/7AZiuYb4ypQ7mzBy0kbJRo9kBPyrjlk7msS778B8Q0IEn34DJab8V7/X5ILLV2SO22mmYtHA==@kvack.org
X-Gm-Message-State: AOJu0Yw7oLMSOrAYG3ZRBKDicn9k2KebqqCYp+/k15JvE2AIjQxnKEtk
	izPpjcEedYsFLFu7DkIcijqQiZsW9rE9/1ztDIhYLIqI+5d1QCwlMFCoShu/08s5UgWV0IOi0wc
	0ah3Wf5ungU0fgMil3lU4WDnlIG6l3UhLrwrBjGP/D4jl4m1d
X-Gm-Gg: AeBDieuV7OTXmZDE8RUykH+yiqWaIFZAnfRzHaHuhGSjE7f20OzAHSoTVktrMN5dkkW
	Xul15k36KsugBLuchUtIu4NOsxk7O+WsftK29Vj4aLo/rrpfnL0UVL230jSDZZ+j2nU1z6iFjJW
	K1X6IKdEIWjylqjNCRsJ0V7hYoR9/5UTQqMIHg0E9GMcAnFebliOtQvcA1QaYxOEzDqJzCeaOs6
	g3upRmDhoS9P7fsFSLS6smRfnsHTeMxvpy2ibd7qvk2YEhDz0iZuoBnQIaYlj6Y5QJDJ89fIlh4
	/rbsRVTUo5JybtI87eB48TGaRoAqaOYzqyuUXqXqAvlCx/sQIYh1w4bM3W5AxxjsCUUzHQHdP50
	UgMAJqVWJ+508upvFkkvFArwVjLH+dJYfz3ZKcCP5
X-Received: by 2002:a05:6214:44a1:b0:89c:bf90:e4ea with SMTP id 6a1803df08f44-8a7042f7e4amr439710536d6.34.1775761157335;
        Thu, 09 Apr 2026 11:59:17 -0700 (PDT)
X-Received: by 2002:a05:6214:44a1:b0:89c:bf90:e4ea with SMTP id 6a1803df08f44-8a7042f7e4amr439710016d6.34.1775761156904;
        Thu, 09 Apr 2026 11:59:16 -0700 (PDT)
Received: from [10.206.71.59] ([129.236.231.31])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac849db735sm4286926d6.2.2026.04.09.11.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:59:16 -0700 (PDT)
Message-ID: <fdbb90a3-846f-4b55-b22a-5a8027bee288@columbia.edu>
Date: Thu, 9 Apr 2026 14:59:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5 3/3] block: enable RWF_DONTCACHE for block devices
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong"
 <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
 <20260408-blk-dontcache-v5-3-0f080c20a96f@columbia.edu>
 <adfPA0_U312XhCYF@infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <adfPA0_U312XhCYF@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 0nuVq7-UoH6yzrfSbQRlYTcDrNgFaGCP
X-Authority-Analysis: v=2.4 cv=Io4utr/g c=1 sm=1 tr=0 ts=69d7f706 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=RFpAoTwO7tzpE9r8PTiuXw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VtaHy3UVxHd-gCO4CH0A:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: 0nuVq7-UoH6yzrfSbQRlYTcDrNgFaGCP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE3MyBTYWx0ZWRfX7aJT7na8ub8M
 kVO2y6bsd2cQ/HvxoLVxc0tdu302g9hKvDfXOq/cgxsg164iu2hi++z7gzZeiWPJ2kPO3c0OXEo
 0rSTy/A/UdZISl6N+19FDrePr9K39pdIxfjNJd6PKC5dFliwWJwwwAazh/hRfmLxD6v/z5YsiBd
 7v410+0OqMdj5rJ2PIZG83esfqhp338t3M0zCnDFqSp02d4qN1jHjtNNGtzezLf7vVo48sPu9QN
 4sy4XncaIPLEwRao+rwkCltZFOxCKUi1fClxqgZBnrSmnC8Ek/NMFv4E+NWHAPIU6cGOujyjMXs
 wR3lutFJcmZ8SjIZccNnEMEx4iNel0bZdzOW2VM+8HyBFQs+ECdw3U2kuIU3E1GvL5/EOI/LOuj
 Mx1tJD3MA+6jBZdGgby3uwqTVceD5eS05+jYRLOmMjvTqu43CPmnB5rknqXMHnnmC5FMZnH6y7l
 bG3Fv56H4Z3ehlTR9mQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11754
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=10 suspectscore=0
 malwarescore=0 impostorscore=10 adultscore=0 priorityscore=1501 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090173
X-Rspamd-Queue-Id: B298810000D
X-Stat-Signature: s9gwieqjyscqbtkmqduy6xpjxhj1dr5r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775761159-227577
X-HE-Meta: U2FsdGVkX1/3HaTtObhsJt8Yv0nJqHJwNE+6AcP0NBXtyzO5kMp5/VfY2XQxHUB6yCyRXMaNGOk2aDdw7pBJgA1kHR0y6Pdd/+iraFS+JQ0Gejmi3CpZCa+HCVD0dlyawijXuT/jzhPLeC8KlrfFP/PScy6Qa+oVLELBMPOdmALGgPDrYopBKTb5Oj2QtJ/YxGgXRnmNsf1ZvLly3Kwrh2jUln+L1KWAcIdfkAuPy8sFM9SF1eF+KJky1yb4Hq4PzovS2JIcdWF/jGM4P3TZ8e1AVrsIs3P1NkGHSOBFUq9Gx/ANPwq8PK3KOwwKSK2/8mGwUCzDKNDYcQzy6qXb/Zm5sN56IvcZVJdOh3Np4q8m7kN+cV0tEhjHrnuEUJ9nn4DTdzvJbK34JHuDQp7Ow6KPMmun90hvWVntwOQwknony6cbT7Ggy/s0TSMpYmmx7lStIezOXdJpOwhifVaKoTE3M7BXjctGuohtArfrqw5dg1+MzlFDb5KE6WnQJdO7As4sLCVw04MjZVXqoYS2Wu58nakj1vA6f7HF7TkdfgfHXxMbQATpqm1mstY9FnvlEEH2NFrdksNzIy02kMZfANd+uTeTwEpM+pev7/50ikmXgHXqua0CR4LE+VAL1byBt+PLNFR47/4AG3mcTXZgwqLvIao9JIOB51SI7m1IA0/kgkusIdaA0m6gPdhzjWffyOETIIhsS7ItLSCRtDITOY2lFl273mgFVWpcZosuVpdYqYjzGmXDmu6AZn/I61jjHeAyEby5JVTsWxrGiMiMi4fUzpD7nJ5LBdfpJvv26syI9BFARpspwPOLeBOpwBEGMrU7upzC1enVilkFWcoXUE5/HOeYRyneetNubw2dbz3KjwJiXzsBn4YSoWGAq2uaZWV2g4ZHk70XZVwWU8COggdTYGHh0cd71RAgmJtX6cV06C18YsCQiC+iTdurapb6qhMoc6MhzEdbH48pZA5
 nw+VbxdS
 sYy8JKlY1s8prqyrrlGnymHXmpU88xpiMYe0BhO5fYrpFYnHDx3NH2jTBOyabIyBBkTh21ThjVk//EJQdxqbN7l8tJlhlq3RE95JaGbK0WFltt73uRwOaijUnJMi+dzairvWpr08B7gZxXbnlNhiR0e3YCoQbG4VYSElB4tOzPh4wcbEeUS6jCyQQM6LL/gByATwLQnaoBm1QIHTRp3WbppH+9dsxHXqKy7et4/XC7j7OOw8ZFEp5LROFRIFhAQdEoXK+Bs1HvPJDZihTKlWndXNdU3r1/R6OiiQcyaFySe0iri9bGxfA0exxkQnG1NYYx3GXKxFQXPl1EzjNDxlnd99sDTJ+c4N7s8XkiexZyuRePfQ6EkZtJr8bf/3J7fXG22biwQpCb2t1Y0Vylyt4h+gHSbseintNUJQF4XGr8WuxRUpOey7Mx8LFMe++Ij78UrTy/gmF1oUxvT+EoxZPnPxz50CHdOqUqJZ6ZQs/wfXkSrSqsvRzKu+K31JP2n1PNPBhroSgi2DQtME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 12:08 PM, Christoph Hellwig wrote:
> For the next round please split this into the buffer.c parts for
> the infrastructure and the use in the block device file operations.

Will do.

