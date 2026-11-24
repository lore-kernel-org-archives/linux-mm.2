Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC439606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 21:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=kSOSSptg;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=cFhloFwM
Received: by kanga.kvack.org (Postfix)
	id F36976B0866; Tue, 24 Nov 2026 16:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7586B0867; Tue, 24 Nov 2026 16:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5BE6B0868; Tue, 24 Nov 2026 16:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3EBB6B0866
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:33:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3596B40D30
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:33:52 +0000 (UTC)
X-FDA: 85471315104.11.B686493
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41765140009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 21:33:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kSOSSptg;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cFhloFwM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795556029;
	b=axBb/dOR46B1kzKIAJbwL+FideiBYbFcNYNthq5CvBgZV3KiE4zhZeHFJlBGBd3LPoPWuR
	LyUCZmV/OnswjOGkQEohjWWNa/VE/194sz2NllsJzx3huGLKJc+7lSUHRDEuITY9j5N6cJ
	ZrtJOKelhzSzQo6KcnL3ko0gtCNOD70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795556029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzs3vXtV1f6glRfCbRyWQ0qJwRwJG7R79LUnSb70XXY=;
	b=Y/acXAOkMkwhW8QHSwz4FO7bsAfXCHnMmVpEedPSbOMLy2kNvld6ozxwoN1qShbt1WbTeh
	D3H9ZPFPIQYrvTZkkyceo80rIKTXLpE8J++wyltFznlcqldnTGjfocWsKJ+C295RmKWOpQ
	C+hnoe5KBhr8Q9X7eeqaDBhn+ZiW9Rg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=kSOSSptg;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=cFhloFwM;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf23.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOLXPbD2445250
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rzs3
	vXtV1f6glRfCbRyWQ0qJwRwJG7R79LUnSb70XXY=; b=kSOSSptg03PNAGft46fI
	0u8m3JFtsUQBmcPW8Y2leohVFkOf7foSZk95k8rFf/kFtHUSanpwx0t/ugSl9SFN
	c3NNzsoNngeXMT4KbGM7h/y1CMr1BLNUsVadlTTnbuOhmKJVAByccPWBiccHzYAy
	UBiWEXUXVzizUoT7E/zrXakX7q9pkGSLZvkqJW5lf6WKPWEWacErCcZASbtOzPGG
	3sW9wy3xWsbOtSDzEIKjUFed5DLQACMV1FRPeQrbWfaq/zMqO1sKf5F+zJqOUanJ
	NrIcQp/xzTCKhsNEK/0cB521vEVFeeNbqNYBoP1BGFWbwqpN+sk0j9ZqLi5SNEIz
	gg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j5famsygh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:33:47 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-947a607ec40so486128485a.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1795556027; x=1796160827; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rzs3vXtV1f6glRfCbRyWQ0qJwRwJG7R79LUnSb70XXY=;
        b=cFhloFwMVz85OhL1OSs3YN+WfMZyPxOUfUcXHuXS6wYo+eQCjrm+l+idES3qx2gxgu
         Ji5Rkz7TWw9LfIpamfn1r+Wovb2japuYk82fKdfucV2PJ6QnFTl+G0RcowTUmmmxRloc
         Et8VEjsW5wXna/7sZOBFmGSnxcU0YMEWf5x6pQfey8DHIl7T4VDtwm8QAMlZksbmf0NX
         eWhnfW8nd5ZdZTs1GCulLZTefRHZxKrtXs29ELAzsZRzjvT10FXUU81y7iWAqj2Uf09c
         4LOPm6ljskZilIUg6bpF1hVF945PvOtM6bEFLhKVBn85vwr4SNF/U4xrqgdQNU8BkroQ
         g6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795556027; x=1796160827;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rzs3vXtV1f6glRfCbRyWQ0qJwRwJG7R79LUnSb70XXY=;
        b=GMmD45D/758P/4IdEG+GbZXHhfncHNRKiGqFI/bwqEyQRyjwPLCacz983V2m+6YIxC
         hNeXh4OByenlqw+uWidDNBW+jYGfEMzCQgGhFZI13HqZipCs47sZpEz8IRyjoDRmHyOo
         FiJBXg6/O3DJUPon1Kvtu/VuG2MAXtOAFD8h6jT0NQqFlE9DiopkJFx8AcI17w4mhecT
         oKubXDc+HXw6vLPsKcazDY32ZHVZc50aqZ+s+WSufkGZ6F1Wv+u62SEuVigaXMFZ7rDq
         BuZlmeyzVpCzV7xjikuuZRrBb/ZeDFpp/uZd84j3vNKk3KWFTrQGyhdaE1RH8YR4CpC7
         jBdw==
X-Forwarded-Encrypted: i=1; AL+hErGAFLZFweRrd5vt9+9HNcGSEKeijsegFU2HMCDWpVg4LB1PEHckL/0cYbOT7uTAYjGIxnIiEx+Fhg==@kvack.org
X-Gm-Message-State: APuU4Z9xXxyJ9TOWRuGHRwyACljAwSjbFeNm8CUft7hr5YA9Ptj5LE0d
	pJ38endKwWyQAzupee/TfV/XFaJlvowLp1rg+7csEDMG6R9up+HirsmdDU140bzVrTAKj02pWE1
	Mi7PZ6bcMLV1NGV+QuQ7p0q3PnV0zHg/34LlgCnocpzi5jYd7
X-Gm-Gg: AZFdTZdObh9/m1680EtVPWEZtcVKxORLIHKrL9tTzU81QyTHGGvId6AgBuXq5jjFQjL
	z3ItQHjR3aR0i4s47WUDj/B33fxS+6pNWv9zoSeQFN1/ZgQ8Qg56yP0o1N3NxXLahuTlP3v3hil
	bkcYMfgJqvNiPyFme3yW/2zbeRF/KvSxjZ07Bg2BTIg5OeEM9eNXuSqQyItc0QTTGqkqF4LoQZa
	OWayh5+iLebiJ4WYuYslKPEh4qjgnp+Bd46YWpHqZ8YJ9890cHYFMW8YJGfyXcP8ErUHzdfxn3H
	AL6gRDEYpyObnR3YYAHRXY28KzXzXWUcLf/V9O/R7wkTGViecGWBCIS8bnnimHHutVpFnFcUoPt
	CYydWqDd19XOgngoOv06YPKb8QziJVT2T9Ku7vSNO7xiO/C1Zhs6sCig+6l4WSosdYg==
X-Received: by 2002:a05:620a:46a4:b0:949:70f1:de35 with SMTP id af79cd13be357-949ba825d86mr2914938185a.7.1795556026858;
        Tue, 24 Nov 2026 13:33:46 -0800 (PST)
X-Received: by 2002:a05:620a:46a4:b0:949:70f1:de35 with SMTP id af79cd13be357-949ba825d86mr2914934585a.7.1795556026424;
        Tue, 24 Nov 2026 13:33:46 -0800 (PST)
Received: from [10.206.101.158] ([129.236.231.128])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb40efc4sm1138097285a.36.2026.11.24.13.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 13:33:45 -0800 (PST)
Message-ID: <da1f8a21-9250-42cc-bf87-072eb28ce475@columbia.edu>
Date: Tue, 24 Nov 2026 16:33:45 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/filemap: only drop dropbehind folios on uncached reads
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Tianyi Chen <hi@tychen.cc>
References: <20261120-filemap-dropbehind-read-v1-1-a373ac3fd993@columbia.edu>
 <awDGsqkIaasAjaNB@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <awDGsqkIaasAjaNB@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: -862fcL6LkRMd8Vy0HQLrMDvE3qZ1Rhq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA4NCBTYWx0ZWRfX1YiJJoqJivwn
 ZFWQYyUcz3cTuzuQhgSIlQk2wyYKHlwwoIym0mV0T64O46BOwkgOaj361XW0Y8wRXnIzztQKQty
 qJLjpG1mcT3NtbhsZesAe+LRdj5LqEeF/0au029MbJr/IKhIFQY+0UuH11MHqWPNTx9wxMAv9Tb
 /sR1lHzTfGfZVWK55bXHssZHt391vGkEeu1hz7+YCajKjZrhOednNjbcQi6xeY1u3UtdstkT+OB
 2U3jx6CF45Ox6hpnGfn6MPRxkp72CfRqX8Y7Baey/NKp9V5UzO4AIkpH6uwciQ3XozTq9kk403+
 3aQfQOUMhGGrtss8iFCjxFQ8z6/sCghcXvEwiRBO8Vt3alCP4Au4JbGPamf/6QkAqCiT6DDQtfl
 tT0y4DSkv6v4JcRgY45e+flhfv0M0VNZ6x+aL19EQb7/Xg4SF4VLJdPdBwTsc8dojdMI5MEb/iu
 zRX6C6l0eooEcAS1/3w==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA4NCBTYWx0ZWRfX8Y05sfmDrGrK
 RohgdaIUbwQWJ1WN9rPwAinIn7YZQxeD0WDvuSB60MY50mTw4JvW1PaNxAKewf4uoiTiTNhENNr
 Ly80mukAIv24iNTYG0YthXxqBFzlCR1n85GSenzxawHqCoBPvcEv
X-Proofpoint-GUID: -862fcL6LkRMd8Vy0HQLrMDvE3qZ1Rhq
X-Authority-Analysis: v=2.4 cv=OoHaWC/t c=1 sm=1 tr=0 ts=6b0602bb cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=LNQXEAmb7IHcZyFqmLK0PA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=jlrA_JLHis1J6U7XA0UA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11976
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 adultscore=0 clxscore=1015 priorityscore=1501 spamscore=0
 impostorscore=10 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240084
X-Rspamd-Queue-Id: 41765140009
X-Stat-Signature: o16rm7tcmxg4io5wgbbb8ws56bx5d5h8
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795556029-165190
X-HE-Meta: U2FsdGVkX18m9eWd9M/sL0SwP8KDL6sf8KZxZAp6E7BQfJhbu0TQj4kcewh5biTP5IzVi0I1L/9lj/Y4elKI5TjgsVwqN34BHuiLt6ddVOgGRb+9UWd0tam95A3sF1XRuQxTdpCL2E8eJUFGmTImIqS/XuWAxica2xdfOwQ7m3mQT4RWV3nCFF4MGMZERh5Q2d+jORAvbTMVT/7x2p50IYRakRuXrDJfMTnnsdkyB69S9r1Oao8Dj0mtdIlqoZu/HYi0dgtR2BOWyG3kZ2J7rH6AqUP9HgOpiv5KBdO4y1Q3atmykGQDNBcRaR4x40pV1WSzo561cXGTD4JErZAMbjFkOY1JjH007yrVfxMEhZ2lEF49Qu36wwEWHAt3SMZWl/Pchs7UM1DxExMM5lmErP2U9d0wK3wTizjGxH25s/zsHRHcj2gf0z22LqQ2F3umESyDvvEpkgUQ9K8w70N8mgqjGqfDgEjF1c6JAEH5onX+uyaR5aL//vRrpiXvigwIx+PBdhKsP017biK8ymJATryN3bMd+9a6B8yj8w6i4rWNDda8g10LFqizW0St76hzGWjdSKB86YbHdjaEVJkHW0r8FTivOE9tRdhVKW+aITMBnmG/5vI77mJNv3UlRrtHXxm8ld2zH70KZ9yX7FGOrFTK1QToxl1VdymRIFHhrMj28mUWXjP7yC0Jyk7aISAdAcNsLwgZzvF5gyMY461KRpyrCEnV30hfueRR1dEMERSuoKldFV6A7ubii6gBN6Qb7LsXLCdBNb473n/yC0DbdH9xiZ692iT7kTVvdp7/joQc6T6VAVXQESKHDDIEMW02bYA0a/jMYQDDXa5hIyCHRt29UQSj1thXD/kEPoG0WdPYrphXAJy6ArTDxc+b/YzDYmJ522Jsm8+YJ90VxsiFaLPUKGb2iqaYFWIh9sWqhQinahaznLz5pzegJ2Jc/jpOFio5uWF8oUJwdQtjxZZ
 b2RjkEpo
 ga4nvj3emGdAUS25i/QeliPbaeaD/wSjQGYfpTYst2qC270xB53IqBQ+x6QLcEZP45lTD4SEtxb+Wd34lpVCtECJ0bj+sz9I9N2lP0xneR+bHpW8DXc3DeZkx5OFItEUUWFRVLmpwI/teUqxhk7OLZxa6H8l4UFucO3pYXZ4ehYEQyG7qzH/0yXS99MyEaZ4NBjHsSJTXbyWxCCp9Bk4CzXdTtbOyydxs4tbWypzRCFkJZ2LHc/RVjz2UpB8AHYKN5iIXGXDPWOzftuJXADHiuvB+2yvkA1rtOISrzjokr9BbBV7nEGTe33D9/5+e8cCfJKY9Z/kjW2Zp+4X7qk2SbUTPyixRwDfH0Euagu+FiEOcVapm9I4zmxBY/Yk1kYjWCBZG0+F59FExkLe0826YmU4kZ4eH0e2UwIbP6N4aYUit9IXisSJVQ//Ia4dxRafKKk5e77+FxMvnLm1vgc8uI3yXWHycAf7UyG8peWceVsaxw3AyzYJpqvXfKa4qcQEQmkTrlpH4cqj3pRid8rXczeI/XbSzisR2w7uuZJb6PC+bKRH8MMF9UBa5TzTQKcd/ZoZOkJCeHq8qb4Eg5O3EfTv9R5PKtzVJ/qB/785AhYULrj+uFp+4Oa2KEyIVV3F7j3Y9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 5:16 PM, Matthew Wilcox wrote:
> On Fri, Nov 20, 2026 at 02:51:17PM -0500, Tal Zussman wrote:
>> An RWF_DONTCACHE read marks the folios it brings into the page cache as
>> dropbehind, and filemap_read() drops them from the page cache once it
>> has copied from them. Readahead can bring in folios past the end of the
>> read, and those stay in the page cache with the flag set.
> 
> I like your patch, but now I'm wondering whether RWF_DONTCACHE should
> trigger readahead.  Yes, I'm sure we want to use the ->readahead entry
> point for filesystems, but I think that an uncached read should not
> bring in pages that weren't specifically requested.
> 
> Something like this, maybe?
> 
> +++ b/mm/readahead.c
> @@ -590,7 +590,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
>           * readahead will do the right thing and limit the read to just the
>           * requested range, which we'll set to 1 page for this case.
>           */
> -       if (!ra->ra_pages || blk_cgroup_congested()) {
> +       if (!ra->ra_pages || blk_cgroup_congested() || ractl->dropbehind) {
>                  if (!ractl->file)
>                          return;
>                  req_count = 1;
> 

Hmm, wouldn't this badly degrade streaming reads with DONTCACHE? Readahead
wouldn't bring anything in, and reads larger than a page would be read in
a page at a time since req_count is set to 1.

If the goal is to avoid having uncached reads bring in extra pages, then
the forced read should at least cover the whole request. But I'm still not
convinced that we want to completely disable readahead in this case.

