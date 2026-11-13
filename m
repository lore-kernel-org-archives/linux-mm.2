Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891FA606A88A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=cSzAUYhn;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=zEtI5Dqc
Received: by kanga.kvack.org (Postfix)
	id 660C86B05B7; Fri, 13 Nov 2026 16:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637D96B05C3; Fri, 13 Nov 2026 16:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500266B05C4; Fri, 13 Nov 2026 16:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21BA86B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:21:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7C4C40157
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:21:07 +0000 (UTC)
X-FDA: 85431366174.19.C9AB88A
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id C64F640005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:21:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cSzAUYhn;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zEtI5Dqc;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794604865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruQ3lHOmeWuryZ2uUe/iR9zV6WBvZ5ex3uR31DU9w70=;
	b=kANg3guy24QsGSIowwVp/n7gxoqmBYvYJeLCuhh6gToWFbFceUmCvTt57THUxlb8TYxfSB
	22k8yB58u1o3Xgx5VTZdl6xB+Gd+6nXX7Sl8pY8vwmOgeUpF7EzbY095tmr9Y2/NcyxkPM
	tZ3RysVvHbkdBVyV/bGTGRQ5EZDHIpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794604865;
	b=Gb+e3Mx625AiOrz4+NA2sigoNkssYrw4HGmF/nAmWeMAeVcTrJmHABHZ2uK30Budb8wV0v
	GojZOlOoy905zZbLKB3M7gk9SSboUKpBPf0ApMLE9I4Y+NKjrrimrHvjPG4Ew/Uivr53hX
	xi3ZJDwvCRhYqBtqWWAkGhdDurh18Gs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cSzAUYhn;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=zEtI5Dqc;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADLD1J2339411
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ruQ3
	lHOmeWuryZ2uUe/iR9zV6WBvZ5ex3uR31DU9w70=; b=cSzAUYhneIKURlzsloWl
	Th9bGaxgkk/kFRRqzp+w4qllkj+vhDxOlOcCOEBg189VBN5iUBP3U8SKjsnGdukh
	+En5RD33jw1ZG9DlETweMUyUOMjhr77/YVmegQ5ZOHdIXiwuwyGOUu8FaARP/gFq
	hj22JC9DPE1RDRPB5tLBei/uKJvS7y+uIMCL2fSZXegk6UkyoV52jgL5RwnSfDur
	7nLy4no1XeB3FL2UsboBghgeX+03Gau6yi8SiR9nnLX1jg6GqV87x+2s9sT1bG2F
	dGkbJkTE8C0G918xasthcTxG48a7iChehb7tqLZlktn6XgFUCdRgTcwBKfyVB+LU
	7w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hx73ma00s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:21:03 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-55bc8181defso15101391cf.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794604863; x=1795209663; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ruQ3lHOmeWuryZ2uUe/iR9zV6WBvZ5ex3uR31DU9w70=;
        b=zEtI5DqcyBmsznwopOk6sHZrFLkn0MTQn2oA9C74rw+YIReTs8uKcY9cozZ/wSrBr4
         2j9DBxSYHklhwbfXEkziEleOd/TPjgsg8SEWseqkQ50cqPcnErHtCdNh3juFyOEFxqNr
         /5sL9Vm8tjzTKepnXtad9QgIecvQw8xyTGpiCprvqJzSG8kNuKbQnf+gPc8Ds9gmQgvT
         MMwHZsQXdV7Kts/OiHmkAZ7/tXOXQ14BIR2e4gGiokhZAGi6vjvpBCsoaZXr7DqJo2hs
         TbZJHYEnJIjpAqyAqJJFFb+ehe+Cq8OaLPPR+nDD+XDlh4l9bU3KPXe7cpu8uUr8WA9B
         Wg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794604863; x=1795209663;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ruQ3lHOmeWuryZ2uUe/iR9zV6WBvZ5ex3uR31DU9w70=;
        b=Xpy4pHRnzA7Dw/LNf0+wMaTVCheNQEuY9xtVVLrQfu9jE84oLmnu72oYVJVzzLlJOM
         c/zCMRBHtGtKlsYjyCvGoas1ykRqqS1gEbDlqd/TOpmHcDAy4OknJx3ZlKWMSEKELGk0
         3OmvmdTs5hABhF/KckDoxlPn7a4Li+t4yunMce37GKdC13C3Vp1v7yA7u/vy3tzQgKq3
         TUtwDrV+S52FNx1HU9VuIMv4fITqPR2mKwimTLxr9nfNVAvkUfJMsjg8CtnXuZihrGvq
         uBLMFPYFXtLHwh2QLGE8P7jd+P8AP83JsB7KO9oDAVw6xpHV+QONJkWXjBYW+Wnq/nSr
         Bm1A==
X-Forwarded-Encrypted: i=1; AL+hErGeEM4UwTGgC7YLa0/qezQYVJ6xOPf3ZpC/LpM2ZLwTbSlW00QRRn8Q20XbMIEBZfeIZ6Ve/l0ZBw==@kvack.org
X-Gm-Message-State: APuU4Z8SXOsBxzvbsb0V3ACzbhuwqR5rJy4vIVMd5jhQluYQsYk+2rdw
	J3gxCDoDMPGQkb6ZoodEnYZ5Nj4pJZ76BWddg7rL6nU1waYG/BA2EEyza2PZFnH8RbB3KGOq6Nq
	FtGZ3LoSg4B3QTtSHj0B6zN+FzXTrPam4YPw5LZimFcoCOClf
X-Gm-Gg: AYBFou25gkNmkh0xHjGKNlkgPqxwsoaeEWt6r7CJa+VvX7JEJjnRPiyiAQUOWIm9glv
	jpUn/HqyJr7BDXu9b2mwDEltjx4tKrIb0i9u6DVYfI+N/GCEXPbz59EF8GNPz5+ZRyVrdtex9YV
	zFejV10tmscpJDBGuvikQBXkvlLjzMPZkz+wSoFtO2rMSRrm5TWMhVm8Odt1P6tWeRdXOqvlgLw
	cZ2/zKCaJd/FqGxUq4Vwc7kxQDlWdnUsF8gOBq1t7c8c50C3wjkUE8BJDd4YDnPWVH02NlJE8h0
	KPY2sVKRChD3wAd2EWvNZeMIefxyUCfJrYEQXW2VPIU9SZOEu96lRd4t1veOna6ouviCJa78mUs
	ct7NL2KE342nQeQpVSY3E+2dpsCkrk8bZwB9B2sM9lsIbjEvbXfrHHzg2ZLO4n/qK8xMxsjPYdr
	GnYYPWUcsPxDxDsrQqhZ0QpR+LNpQ=
X-Received: by 2002:a05:622a:4c0c:b0:550:fe12:22b2 with SMTP id d75a77b69052e-55ac8e8a89dmr58388621cf.67.1794604863033;
        Fri, 13 Nov 2026 13:21:03 -0800 (PST)
X-Received: by 2002:a05:622a:4c0c:b0:550:fe12:22b2 with SMTP id d75a77b69052e-55ac8e8a89dmr58388061cf.67.1794604862426;
        Fri, 13 Nov 2026 13:21:02 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad0533d7dsm27217721cf.8.2026.11.13.13.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 13:21:01 -0800 (PST)
Message-ID: <1a77055d-c628-4832-becd-e2ca647b97c9@columbia.edu>
Date: Fri, 13 Nov 2026 16:21:01 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: disallow guard region installation in
 uffd-armed VMAs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        stable@vger.kernel.org
References: <20261112-disallow-uffd-guard-install-v1-1-bcf8b1aaa72e@kernel.org>
 <0e3e876e-c3df-4660-ad89-a5f0fd7dedc8@kernel.org> <avcNcL6svEOTg_3r@gremlin>
 <0d6e29f8-54fc-427a-a979-1a8c6f4e3f06@kernel.org> <avdjMNNkOXm2khTW@gremlin>
 <f53458fd-c268-4dfe-aa99-b050f63af728@columbia.edu>
 <avd6XEHndh30hyc-@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avd6XEHndh30hyc-@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 5r2jpun07Ryg8LXAYPwJx-tYILUDNJ3f
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4NSBTYWx0ZWRfXwFbXTnL1w8iX
 wb2bD9KMNetr08Jm/OrF2g/Lj7JJ7opJp0AE4rV0sWPACaG8ncjsJHMn6/m92WfIVuxE1sSsnlf
 ITfuPgKz+SGzJrIO3kpV8reoT6Wg9Ms73dsD7Qx3LHSWJzOB96xG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4NSBTYWx0ZWRfXy8jeSQf32OgO
 0YFuseHirWNDnUd/lcuQpQz5qFyJOhgOrzZettN9mBd5yjtXWFKGj8UmmIOB1cQDSVu7E51ZxFI
 8D1Dprejz+cKgiXZD/yhkcxQIMSueqHXAoJiiSrX+HPzervXLjtFwgViKtXynwxkoEeH42JtIAM
 Z+o7DBSLgMAQTD/nBgl0qZtQYYRICULvwNYSprnEE83KL5NN5VP38YgQe3gVgo3hq8BLATKNF1S
 qa5nLkkaqykAfGAsygSjFy0267tQTiYGGxbsBD0Cin2O7LlrSeyI/WkuwK/hYG+YAIEUxgWPGzQ
 6eyxzQQ36uDrklhvlXDNbtHs7b7CbZVgfTPiHzrjsUiozZYtFacbLkpLviR2zUuU+/R2I/gqU7s
 8h35Kksl8Ugz/9XHVuOSInaNSJb41ang4jucvsTVFfEZc0RgpX/C17Qiz1Tw+xVAcOjccKpHTt5
 MgpGioTjroDPI0vqDTw==
X-Proofpoint-ORIG-GUID: 5r2jpun07Ryg8LXAYPwJx-tYILUDNJ3f
X-Authority-Analysis: v=2.4 cv=e/ST2qp/ c=1 sm=1 tr=0 ts=6af77f3f cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=1OPhSWX3wqg4YRnK4OYA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 clxscore=1015 phishscore=0 adultscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=10 malwarescore=0 suspectscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611130085
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C64F640005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: e55c18uzbeqgzuoip8k1njpktxepdwet
X-Rspam-User: 
X-HE-Tag: 1794604864-308356
X-HE-Meta: U2FsdGVkX19PFwFA31jEM7rjHND2KkJeY1HHLK6B80F65yqNx+bspEwPqQmYDIJPE++6dJQebrNDfHtcSFKUZqcBRyjdXvLgoKe+Et5+XGVKfbxyXfnCVSNQadR+N5s5poJLcXSmmjREsR+Vg1byfgMDx3U0Cnrm6Nh9m5zeOSItwbJUEJgZmS3ajvsmSyOi61pKFg/cVd8BKgjaG82ulrAHgwmcHXCDNagUWVQ3t4L9MpKcsCTpkerD6TTVZ0Nw5Ac+PfvejPnGvpoPWRtJOC1PSOIr3Bwtf1v6lmgalqMgjxUUXvwqKodis2K70jRye36v2hD1VxSKj2rIfR4HURcbQMV2TLrjgr0hxX3lZBLQARma0YBAEH/Fe2Q8+HLIuPBdK7h10wGg4uMCcrErChSYpmdERhfVcT7GwcQ5gUAUBoBJ+SNUw/43RJlDE2arakoHt0OB17bOD9hyVJfBGdRCnZX6AZD6hAdYAWafPhOi3+RM95XvOkM4jJgnhG4H7BScmaVLBHLQVeQZUdqh8Jee0Xsd5cTlfdRZO+0hRq6V25vp1ZNJzVO+4sqgVUr7lMnz5iGsGf73tJlZWw8Sj5nFz2pnUwBCKF6CwHye20J7VomEMq2dUiNHVObv5erA09nepWFGajrqxsLGgpOpyps+wDgcVFX7qJeq0XSBd+1x7gMPKFlsiI2ax8ccSLfkncFJyY/G0RDHIZmWcDldjEZTtChl3sZT/JPQMTgUkEhWe8rUC5YpemjK+y9XCSLnl8eTC/3FHlBB1wqd1hMYqnsJ3IZsZ6bkIpVkcbd+LUi8cq0p9e7Ylt1llzIfp54XCURAl6GgkBJpr4u76mXFZWMNlNPn9k/dfMpxilO+kIW1zNiQ41+id7NnY7ldjeGo4Qj3g00bIF0lvx5gHijf37bFHD3E3id3cnnMeeEk42gEZbQPQtRmWKp6Q0NKfBSYqa6xsLLToCxUn6mTvTV
 ZUnjPzZH
 KVvtWnNsh+pPPtPliopjjK5b5rGLfjwWQbuSIoGM3eSkeZyg6XxfkQj0H3pPKMmjChHDPrtgnqObHKK9h9yah5GujMfc1z3/kqZojJp7v4MfiMw3qlyCFPR8jTH0jlmpMk4qreFJd+f9ybok+/7qKTeueZagO+Q5YB5bjVoOz5bTXYDh+qYLcv2ImaHeI7S4x5HHKjA9sOlNOClbMTALDzN8RqWJrNd7597SpFpVzBH6DFn2/DC7LhJzO6cJJA10l8HMTWz/7COa7xpF8Kn0FL2xryy1jxcNi0sRpN8A2/a2kuQiogZmiRsAEWWlEEu/cyAXNVrOusdnzfXvlnURxSSWQdMj26U1CilFfwwKgYUWx3hjw/yKMznxK0uOK98bO2McMwiFArCgWYSUqvEYmlc6icNpTcWgACGuR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 4:09 PM, Lorenzo Stoakes (ARM) wrote:
> On Fri, Nov 13, 2026 at 03:55:41PM -0500, Tal Zussman wrote:
>> On 11/13/26 2:22 PM, Lorenzo Stoakes (ARM) wrote:
>> > On Fri, Nov 13, 2026 at 08:15:34PM +0100, David Hildenbrand (Arm) wrote:
>> >> On 11/13/26 14:59, Lorenzo Stoakes (ARM) wrote:
>> >> > On Fri, Nov 13, 2026 at 12:59:00AM +0100, David Hildenbrand (Arm) wrote:
>> >> >> On 11/12/26 18:38, Lorenzo Stoakes (ARM) wrote:
>> >> >>> In order to establish guard regions, guard markers are installed in the
>> >> >>> page tables of a mapped VMA.
>> >> >>>
>> >> >>> However, problems arise when one tries to combine this with registering a
>> >> >>> VMA for userfaultfd, as such operations may themselves need to install page
>> >> >>> table markers such as uffd-wp.
>> >> >>
>> >> >> How does this interact with UFFDIO_POISON markers that can outlive even
>> >> >> userfaultfd registration?
>> >> >
>> >> > The zap clears poison markers, as is standard. It's really horrible this logic.
>> >> >
>> >> > So the code path for zap used by the guard install (via zap_vma_range()) is:
>> >> >
>> >> > zap_vma_range()
>> >> >   -> zap_vma_range_batched() with NULL zap_details
>> >> >     -> __zap_vma_range()
>> >> >       -> zap_p4d_range()
>> >> >         ...
>> >> >         -> zap_pte_range()
>> >> >           -> do_zap_pte_range()
>> >> >             -> zap_nonpresent_ptes()
>> >> >
>> >> > And zap_details is NULL.
>> >> > > In zap_non_present_ptes():
>> >> >
>> >> > 	...
>> >> > 	} else if (softleaf_is_uffd_wp_marker(entry)) {
>> >> > 		if (... !zap_drop_markers(details))
>> >> > 			return 1;
>> >> > 	} else if (softleaf_is_guard_marker(entry)) {
>> >> > 		...
>> >> > 		if (!zap_drop_markers(details))
>> >> > 			return 1;
>> >> > 	} else if (softleaf_is_hwpoison(entry) ||
>> >> > 		   softleaf_is_poison_marker(entry)) {
>> >> > 		if (!should_zap_cows(details))
>> >> > 			return 1;
>> >> > 	} ...
>> >> >
>> >> > And zap_drop_markers() checks zap_details && zap_details->flags &
>> >> > ZAP_FLAG_DROP_MARKER.
>> >>
>> >> Right, my intuition tells me to just nuke that thing by setting
>> >> ZAP_FLAG_DROP_MARKER.
>> >>
>> >> MADV_GUARD, is just like munmap() another form of "zap it all and protect it".
>> >> >>> This is especially problematic because guard region installation causes the
>> >> >>> regions to be zapped first, meaning that the removal of userfaultfd-tracked
>> >> >>> ranges will not be logged in this case.
>> >> >>
>> >> >> Again, similar to trying to uffd-wp-protect'ing a hwpoison marker (which will be
>> >> >> ignored), and then zapping that.
>> >> >>
>> >> >> Isn't guard marker installation/removal just another form of zapping?
>> >> >
>> >> > I mean users being weird could decide to use it for that rather than
>> >> > MADV_DONTNEED, but zapping is a side effect really.
>> >> >
>> >> > Really the idea is that you might have users who, for whatever reason,
>> >> > faulted in some range, and now want to make that a guard range, so for
>> >> > convenience we zap it for them :)
>> >>
>> >> I think not just convenience. There was this problem with faultaround / THP
>> >> placement IIRC ...
>> >>
>> >> I'd just zap everything that's there. That's literally what the user asked for.
>> >>
>> >> >
>> >> >>
>> >> >> So to me this all sounds like "if user space does something stupid, it's user
>> >> >> space's fault".
>> >> >
>> >> > Unfortunately, as per Tal's series, there's more to it than that (linked in
>> >> > Closes: tags).
>> >> >
>> >> > You can get an infinite syscall restart (ugh) if you do this on a shmem
>> >> > range (Tal's 9/12) so it's a kernel bug that _has_ to be fixed.
>> >> >
>> >> > The other bits are just about a user losing track of uffd stuff if they
>> >> > guard/unguard, as you say.
>> >> >
>> >> > But every other zap code path does the uffd remove event stuff, so this is
>> >> > still an exception.
>> >> >
>> >> > If you support uffd, you have to add a whole bunch of horrifying, awful,
>> >> > terrible open-coded uffd crap, e.g. the userfaultfd_remove() etc. And you
>> >> > have to drop the bloody lock and reacquire it too and make sure all that
>> >> > works correctly (...!)
>> >> >
>> >> > Anyway there's basically 3 options here:
>> >> >
>> >> > 1. do something like what Tal's series does - add a TON of complexity for a
>> >> >    use case that nobody uses to get behaviour on something nobody sane
>> >> >    should care about (i.e. uffd/guard/unguard/expect uffd correctness).
>> >> >
>> >> > 2. Zap with ZAP_FLAG_DROP_MARKER, and silently lose uffd-wp state but
>> >> >   'support' uffd. It does fix the 9/12 bug but then subtly breaks uffd.
>> >>
>> >> Right, that's what I would do.
>> >>
>> >> MADV_GUARD_INSTALL zaps everything.
>> >>
>> >> It already zaps swap entries, migration entries, hwpoison entries ... so just
>> >> zap everything.
>> >>
>> >> [...]
>> >>
>> >> >
>> >> > If you're really concerned though, we could go with option 2, which will
>> >> > just make UFFD behave differently for guard regions.
>> >> >
>> >>
>> >> Not really concerned, it's just the most consistent one for me. Zap everything.
>> >> The user asks for it, like he would ask with munmap().
>> >>
>> >> > (I regret, obviously, ever allowing this for uffd ranges. And we _all_
>> >> >  regret that uffd was _ever_ allowed to be merged in this state...)
>> >> Yeah ...
>> >
>> > Ack will send a v2 doing that then :)
>> >
>> This sounds better to me. My concern in [1] with completely disabling this
>> was that it could break a uffd manager that doesn't control the task it
>> manages (e.g. CRIU lazy restore registering the memory of a task whose libc
>> uses guard regions), but this should avoid that.
> 
> But they were completely broken already? So we're 'breaking' an already broken
> user? :)
> 
> It's moot, but still!
> 

Only WP and RWP were completely broken! MISSING registration, which is what
CRIU uses, worked correctly apart from the lack of event notification, which
only matters if the manager still has contents for the page (which, again,
is unlikely for these pages). But yes, this is moot now!


