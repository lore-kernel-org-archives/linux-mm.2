Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9FCFD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34D16B0089; Wed, 25 Feb 2026 18:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2666B0099; Wed, 25 Feb 2026 18:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99B66B009B; Wed, 25 Feb 2026 18:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4FB76B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:46:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C094C2702
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:46:41 +0000 (UTC)
X-FDA: 84484616202.25.17DAFCC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1199A1A0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:46:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IqQmO8iy;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772063199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alpDw3ItzbUTKzx46DBJhWkupeO49VjqF0Ov6EtA2u8=;
	b=vXluS0lwIJWDS49SSQA/HcZO42ZPcwHT+jpg22tpmLVmHI0EhBl76tzivBvLy1kuhbrMb1
	qQxBNWrMZ7e6bs9KNJSBVX8gLztnCoy/JtXni3oxIN6FFgmBqqr4tjA3tMTv1niO8ahCZJ
	862dKzEFjE0edLoPtNeoJA8UYUMZUxg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IqQmO8iy;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772063199; a=rsa-sha256;
	cv=pass;
	b=v+n4PAxaIwxB6kDJXBiqxUd7FNF12wEcILl521mcYmK2Ky9udfRWPd1S7avliRB6Di7wzt
	zUtIkyyYoYBVtVOnceewqZoX/s7Rl6NdURekZRBgeL092oZfi6RjD6cYojP3l3O2GJiOZp
	WykFQxrO8AGc6jqb2IXlmKpqTWW0Hyg=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PNNEm7030564
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:46:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=alpD
	w3ItzbUTKzx46DBJhWkupeO49VjqF0Ov6EtA2u8=; b=IqQmO8iyq4x1wZil7iSE
	Yb5VlrEZoCcHhGcsRlLoFrYHNcJWSFZXP8Lkch4N9gYsiVWmO8YAMgNCZ+jSPuGh
	hbzp9auArHHb5yygWb5QfvydQTFv+DYtmGbLjW8Nwh0rL1RrfdpC0iT59uqajbTP
	pU7EnC4qWLZrOpedU07ruJkUXMkIs22OpRsb3adN3lN+kWmX4Sku7pQRCDKjiGjP
	JUl39ZSWtethLLBGCbiLW0+lMXwGHzzCI+8mSIkLlYsRX9eNXjchFAOFbKrlu50e
	7CYd1xHbmUbYhJax6TCWKrVbXoPJlMGSuuNsvHzEHqnIaoyug93cm8/Lmf+gekgA
	Dg==
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4cj35vctk3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:46:37 -0500 (EST)
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7965223b026so4232737b3.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:46:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772063197; cv=none;
        d=google.com; s=arc-20240605;
        b=FR3rhjmiFn9rAEyCGaDYaHVxQx0bFQasEIcVLh+ya7RXFTM13QQZXSUNu34CLUE9aE
         8LD+jCpeQuyjGk1sJpZAiQDSalN3Lx48K1oZZR1ALtUR9u0u5FPR5+VGR5+wB0bRpkrs
         kpE14xhtFJyETpwROjIFBYE0Y8i/y0y++xbvxlDLTtPCjlU1PTkp/BZMyx3Na/6zMel+
         AIGcXkMhkdYGOvopiBZrWt9SqiTE50QyawgSG1dw3byMbhusp7kwVxIFrZTFGfc1bVjx
         M73UsCHR6NMtF07v9V/eB/DTa/odn5T9wraU/gW5my4DgC3kUbe6YCnNSw5FQNKUQbl9
         P2Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=alpDw3ItzbUTKzx46DBJhWkupeO49VjqF0Ov6EtA2u8=;
        fh=q7AzZm4p1xHQXwDVC6Ra3SKuziEc7T/Vdyb5cizjprM=;
        b=kBSk8FLDCaGI73mjkvDWo5sNAg8zvzAD8/7/+ySdrN99i/Xk6vdzmTkaOPbR4FBV7Y
         IVRgd3AZ624tbNrdxDFIN1RK7LKDg5umjVsj+xvPll7APAu0Jvh0iyI6uQ3GxrT612T6
         u8iwkroWuCqt94G3d6URjNHzuZrlZVU2asbz/5cKFSQTll1Q+MNWlNHrj3Rn3GQKKY6Y
         mpJ/lcnsr+bEWCkAWH1ioIpHJAN58P0hD6+3tSpOGe7kqCJNwzgjUhb6JLh0FgQ5jarX
         +7l6gaeg2owd4aRlCys7aEHqM245ztbFsnKtNWiuj1xI8uhUkVtRQmo100U4JmcnV7Hz
         FoIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772063197; x=1772667997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=alpDw3ItzbUTKzx46DBJhWkupeO49VjqF0Ov6EtA2u8=;
        b=fhb4N0kzFBugQG0D5+1OPCO0QYmCKCnA0n3rWEYdXp5oBBAMJIlJNaBH7Gpv6igVSt
         e3/zUb6CWSOpF7OtH+/sS5pNBOC7YsiMsRn0JhjbgNKHCprqEUv+QKoOhM8Mx1SKgBgO
         j+eECrhTNe5YaGgSK5fHSMMfJWiz9wUFX1YxgT2anAUbLA7fIIpJSRLcJsN8HOoWuifr
         qDkyBDBmpXaUtn00JgDVMb8WU7WslO4svG0gy5npgsyEZMHgrHZvFjG2gMJ1T/hsKB8m
         o5/HqDvgoVRuVXc6ysaE35zQ1mFR5zYNpycbsQ2Zcn1MI/A10E7NzLBSet9OOLqxkuM1
         AV8w==
X-Forwarded-Encrypted: i=1; AJvYcCWzhg3lYrKuiJvEk6XI63XFUTiXakBGHzsSF/osdgNGQqnuPv4yjjTYXNv5zUxNTYApQ609YsoirQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6eTHZEM8JTXowd+SuiALDmLhn60LmEogSiS19YHgjIokWzcWK
	VrGkBb5B/RJExS2i/z4lmFvvMTNC/Krf8J/Z0CSwiva+6NLFPMjvUW/4tHkVn8ht5hKHXYAE2Fn
	BZ8mHRv76G9dLuKokG46LUBbGCIZOpmmjxS2o0WaNslBy25sMqgwwoRYkisEQHUGOvGqZ39XJOY
	XPDOVcbgq/VwJtzEGaBN4845c=
X-Gm-Gg: ATEYQzwD5VU0LVTTJSehBi5fN2Gcj+FJCbnppWI/olx4pOhbNMDLH7r/dc58jCvCBF8
	fOL8ww26Tf/UO6N9egnkMzw3XD87nUOXf2VDde1btIbZC7ee/piXuv1pItHlebxAEo0zsosOK75
	N9iYmegaMPhnlKqKeyfc3owxgITn5zRNHyI0hgIvMV4wPog0yT/sfo+esNy7VHoh0+vIHde3bs8
	yi2HYw/
X-Received: by 2002:a05:690c:46c3:b0:798:6f20:1c87 with SMTP id 00721157ae682-7986ffc3c55mr19756637b3.58.1772063196831;
        Wed, 25 Feb 2026 15:46:36 -0800 (PST)
X-Received: by 2002:a05:690c:46c3:b0:798:6f20:1c87 with SMTP id
 00721157ae682-7986ffc3c55mr19756517b3.58.1772063196458; Wed, 25 Feb 2026
 15:46:36 -0800 (PST)
MIME-Version: 1.0
References: <20260225-pagevec_cleanup-v1-1-38e2246363d2@columbia.edu> <aZ9f5_pgnr_62gCL@casper.infradead.org>
In-Reply-To: <aZ9f5_pgnr_62gCL@casper.infradead.org>
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Feb 2026 18:46:25 -0500
X-Gm-Features: AaiRm52dQnciImWHmEJDWZpvU8pRpkz10CR6JsDtukkF0Y3eoXH3DgTrzZnl7YE
Message-ID: <CAKha_sr7W3dRSnfqmruFxvoAr8aQGrAgStxjLdchfn-d8cHt2Q@mail.gmail.com>
Subject: Re: [PATCH] mm: Remove stray references to struct pagevec
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: V_blchpvz_nJ5_FgNT2QZoTaF-QgxKp4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDIyOCBTYWx0ZWRfXxdynK4P9XKq9
 DIojfvoPeUxSlWge1D6pbFl+CVk3NR8uol22Os2IIa6BPf1o6DyL74WIq/vjARXgwbWE5UHuj7w
 Na9Gcpk9vG1lrPxMT2E+Jl40Y+TmwcfkPAAnrTxr9+3LCJfX98tL+wguXVPc6wMAZlvCQuJrvDY
 4BBqrMImBdX2iKJoCS+PMALHnDE/WFn8GBrZAlsbBKdrhwF0SRVDCNpHdD6sfG2oMHkJ369F4fA
 mjc/SK03zB9g8n4tkbB5itn3gDue+GuLqOwg2AqdKtSOR16eEEJhjMHaflufT+GIuSpTcowQLo0
 3/YDL6KQASnjo+gKa737Wi3dy463tiBEE0xSXH1FfrxqgfHV9yWmzqr2+fRSgO+KO9dVRlhcoOo
 1bm8T9rzbVsG6nVt+nxWirohTWGeA6EKuCafwBwgiSONt1XxNHQPgrg8gyeXApFsTT+ip0qX61f
 NBGPMBOjymu4QXsOz/w==
X-Proofpoint-GUID: V_blchpvz_nJ5_FgNT2QZoTaF-QgxKp4
X-Authority-Analysis: v=2.4 cv=Q9DfIo2a c=1 sm=1 tr=0 ts=699f89dd cx=c_pps
 a=NMvoxGxYzVyQPkMeJjVPKg==:117 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=svvvyxlR1OQQkelhaPoB:22 a=JfrnYn6hAAAA:8 a=vsynCidFeb6Hwkx_kP0A:9
 a=QEXdDO2ut3YA:10 a=kLokIza1BN8a-hAJ3hfR:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11712
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 clxscore=1015 impostorscore=10 adultscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250228
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 1199A1A0004
X-Stat-Signature: ked1i6bt711eshis9zwjywj94erax5g1
X-HE-Tag: 1772063198-492213
X-HE-Meta: U2FsdGVkX1/1+3Q8Hz2QBJ3ZXQkRf6Z2VQGYWjflquUEWRp0fBAf1A/3vtHzFp/aSyeJ1sGvB+45FKaAOoa1ShodLFLcmk0ShihCQ3o9/xCqv1HprKzNlVFCanlLQz4c4TMNelJsCVW18aWaP4KybH9fQDguOSWNaQn0hk2+XnqncfeLMOjiPTcp6+pP3JIx+NyzetB0y/weqJv8RWwrhpU8nb316SksP7TtGEBDEDIGkG+Wt2DsBWxxd31XWP675UxWMBDFktbACwEa+zm2kDgBi4hJTiaJYqbL/niHhdWWdBK6IBx512YrL9hIvsUQMB+GeCDuvfrQhoFUeGkvlnX2t0Tvrdc/S5Wr3SeNgXcSKUl6VCtcrHyv1Blt8I1eOmRjAlT3mAHJG7bWfj8WXuCdlwgmqSxQGDXLQpiwjkpRgaq850UoYkQuSzwKPPL2QDiFKdMxP01Gax4SzgFREJPfC3MoI6Ij54fuewSHKeHx1ZHdtNU+gwL7Trup3wmcjRzcB7H7O0kRNouj1FUO294QyuLbPffbvzSg7bh5pWv4jCf5titJoQI7HDpNyVPpzXD7FoheBPH01HGwyytZwk0t1+rBQ/PfozxDplDuGuJOuyClzKn0gbU0EUqVllFmR8T5d0MKJM5cuXZbSH4xU24ITn/FrC91xhtczfwrfKEGZoFSkFdJQhTbbUOB5M9f0ZKgDc6X9K57ccnREepzel9/03QsEfhFkXSZqmicNL9qNfdhG2g+QXs85ZO6o+UUxU3Hgye2Y/Rrpynq4EBGu7SADRUktZ/uNh1N9lDB8NZ7Hj/rZ9lW/XfqJxxORF3w8p8zWNn4/HEoJLbx6PEgabdrhLOoDs5NG6POViQ3mPBmRUgB+MZBCLPk3Ef58M8wIVno8QJ7mB6tntg5AAN73D2MSm5/Y0i3vhWDYP/LvJQ3ShU2rG8Ldeabxu/Bk4C+6vehQGjb3l1LTW7WMJW
 HGiE5kyz
 qaf4V9DrDAS9YVPyis0zhOYlhEt9VnUI0E8SULxT/ERZAo/xND882ZFI6Mnopvtw3zfuTtOHhwL7zQG+RHGJjyBOcjTxpgpupjTG9npfEmaFvslKni7S3T/kdHMQ43zsYaSp2NB1HqQpF/SsaS6QBy2YGMAhISxpQAldFyU6OQJ0JKRSZ3ISQZAB/nEAdkEbOuE15YPzsmAFTTjr4tVrkXHphmEMWOLjdL/ulrOjE5C97HgmZvt78+l+giv7zUfigxmBQVgiHmzueYAYX3onvaoH1Kk1Kf6ugI2Cu5HL/F44sCA7kzi3jeefGdeFOojo6nF6i3N3Y3QRb7G7RRiAHyj6kdZKaw3BjaZQgd8Mri1ZFDMp7yK+jhry4Vt11NOGzwt8zDQe5LOwXK6VyFpXDrDTsgakreasktfSic7AGboQmbg2q2GoHNZbbFLFlTEjoOLHtn+kCC6W9wtyk4y19n3L4XJkxaXxDxVuDdW1et4/MkK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 3:47=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
> On Wed, Feb 25, 2026 at 12:57:16PM -0500, Tal Zussman wrote:
> > struct pagevec was removed in commit 1e0877d58b1e ("mm: remove struct
> > pagevec"). Remove remaining forward declarations and change
> > __folio_batch_release()'s declaration to match its definition.
> >
> > Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>
> > ---
> > Happy to rename PAGEVEC_SIZE and pagevec.h if desired too, but that'd b=
e
> > ~65 more lines of churn... Although it looks like there are plenty of .=
c
> > files that include it for no reason, so could be a good opportunity to
> > remove those.
>
> Yes, there's lots of cleanup work here that I didn't get around to!
> Thanks for taking on this much, and any more work you want to do in this
> area will be lovely.

Thanks! Just sent a v2 with 3 more cleanup patches.

