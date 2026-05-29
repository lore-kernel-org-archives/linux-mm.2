Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BBECD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 22:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86AD86B0005; Fri, 29 May 2026 18:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BCC6B0088; Fri, 29 May 2026 18:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B736B008A; Fri, 29 May 2026 18:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3AA6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:26:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79E0EA02BA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:26:42 +0000 (UTC)
X-FDA: 84821893044.03.368F795
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id A9A53100010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:26:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eSTg8+oJ;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780093600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZ/CvHIaEtxesqHd176lUmCe2CW9FRR63TiqxgWScco=;
	b=xfpNsl+Sjb6aw66Vm6aTC5sQKQj22mxmOHVd/qTaqBZgSa1cpDd6MRL+ITMREG/FTiatQb
	H13h7CCXT++vgdVVlTjzN4d+GehfdM7V+mC9f8dFT3iExK7FMxHYqxci1X3fTNb51INnPo
	fJJAc2ieampMBZei+jrLI/f9RiRrgQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780093600; a=rsa-sha256;
	cv=none;
	b=GnxYnqOk8QUym6ZZA5YbWj5blkNmiYP5f6B1L72x2rnjlVfFO42FxFlPQ5ZouJiuJDQWth
	+dI00LwP+mx7ds+N/5RxWjDcSgGBoGSVy+KIv0+QEXU2O7f0+AryVndKxVYhzFwI6cnus5
	jfEn06wnkBdW7PKpoXp48YM6TFuwjk0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=eSTg8+oJ;
	spf=pass (imf14.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64TMDDIr809125
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=iZ/C
	vHIaEtxesqHd176lUmCe2CW9FRR63TiqxgWScco=; b=eSTg8+oJ5fRfpIsx6Tcq
	92PnYHoBuV3eXLxsANRD4phElJOVL5OrwGQgCP77zxwra/FJ30+BKPxbno6PYIIp
	5faeDnrGsEhAaigVZ7MBPyHYqiB3nkH6XrhhfogAi7EAEk2vaZ9IeSxT8CondLr7
	jqJMA5R/00D8iXke54BONNZvImIY+LumJP6u79cKGBhJJ2R+IZI7De0/CNGwfz1N
	ns790QCfOjIVyGPyf7xXcJ8wj3/tGdHl3rB3XwyKzLsbqUIFVrXiB4Rsm6AREvGP
	syQ4v6JgLIluuEfGsF9GMof5QRRNI5Qch2IOEwBqpN5zOehwtmi/QVYxaIhKdF2f
	2Q==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4efdycjqd0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:26:38 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8cce42a4e75so28675796d6.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 15:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780093597; x=1780698397;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZ/CvHIaEtxesqHd176lUmCe2CW9FRR63TiqxgWScco=;
        b=UubtKIk2N77xNw0eSf4kFj5Pp+AhR5olnLoDGsreDewxx2uo8xO3TipuUPLZYNtc7D
         6Z5kiWmsXU+WHOuogFZEaGvro0oNQNdGUKoHj/KJgXQ4L7DRylc1sxGzr5yQR9dCmZhW
         hgB0UmJqznCMj5zcmlE3qSNhRPJC28NYMoF3XqmGAjS/RtcZVUSL8MTvpy0MOcP5wxih
         DMiHyAADVcd/d+lwwHsKudxnucDb2aleYa2yfQEMG14bVZWcGh+Vd4i5e4xVmvBbgF+z
         GUCisqZ9T4MtNjtuwqtzpft6RsctR8DO2/r1OudkZXgpF4yu89chwjqRZ2BVKcpcAAqv
         dYwg==
X-Forwarded-Encrypted: i=1; AFNElJ+27RgwEX97e4bpUFVzQ4wQy2e3cjb3VLkG1aJAa7QcSVdtc9Eak/DM1YYlWGKreyYPVuoyblNsJg==@kvack.org
X-Gm-Message-State: AOJu0YzALDmllPEUiYCUe+2r/v0ElWbnBwPkYWwzYdsYY4UA5ruz4se1
	AOqjjGwZe4RBfnPmtQn5FbrJjCIfgxwiN9/bakkUjOgo/SxKuvTDJp7NW/iW25nPJG8S0A1MnJg
	+J8YaN7oubN/Vuug8lyz2hNFDe4A6ICnF7d6K4W33j1M5CkXI
X-Gm-Gg: Acq92OHVLJnJS+CK8i6JTcay+SxWllleEmuTR/plgTYOCJWZNXya9ps4kL4hEIE5bjg
	nxP9yIqbNIeftB4yB9tC1otK5E+nI+TeOIr2gpAuyJUbS50Gn5mNreiCuwjPKVYzhzbe5Y9+P+8
	fFnlYXwc5dFaSxEeX7Z2r+2adb23ipqO9YM9lbGYROEFyai+tpIFaRcjPE2BZH4XRYNgCoRudy6
	tBxjg61/Gj5iyQP5i2blX5PoKQAOJtlSJgjyzLw9h3/ScZ0aUTlk4OMPaEs/b/NZjRlVz4xNV0j
	zr/BzpHF5xm3djVT3K1qgxgWGVww+2yGUdp4QIKslkRG2c/z2NLs0dN9CiHpzN+gmnE221gyNbG
	dF7pyNpSS1/U2EXiFWEecaRjwAO1dlmyvc2QXuxWwrMvA44708XFBAXL59oUKOX0rWDDmjQp5BN
	TrFwZtH7UNRTbTBxvS6+1F5Im8MQ==
X-Received: by 2002:a05:620a:2a0e:b0:915:2b21:c74e with SMTP id af79cd13be357-9153d9776camr269383385a.24.1780093597063;
        Fri, 29 May 2026 15:26:37 -0700 (PDT)
X-Received: by 2002:a05:620a:2a0e:b0:915:2b21:c74e with SMTP id af79cd13be357-9153d9776camr269379685a.24.1780093596656;
        Fri, 29 May 2026 15:26:36 -0700 (PDT)
Received: from ?IPV6:2600:4040:974e:fe00:c8bb:325f:9d37:a5f? ([2600:4040:974e:fe00:c8bb:325f:9d37:a5f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915325fae79sm323170185a.26.2026.05.29.15.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 15:26:36 -0700 (PDT)
Message-ID: <205bb690-2874-47c3-b352-33ee96026196@columbia.edu>
Date: Fri, 29 May 2026 18:26:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/11] mm/filemap: split out folio wait and VFS code
To: Jan Kara <jack@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
 <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <3dxzu3ck5y3wxw4pp2qhzwwb6y3f7mwhvgxfpl56sokw4ymop7@xaaoxsa5yu5q>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: d6M8lVx7cIsotVCvOo7kcRLITn7wNaLV
X-Proofpoint-GUID: d6M8lVx7cIsotVCvOo7kcRLITn7wNaLV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDIyMyBTYWx0ZWRfX0UldEP1tm+lG
 86mP8lcBMDG9VFbgOBgTg2kPebX1fmrcJy4O9tvclGsFdzmo60WfUXrj4q5VSAF8Ar2H/mTE5Lz
 dUZDpN9rlXUAo7zFEgbalyN0MC2HnYWEAZuR5wrU9u78h5gm9W/0FKgdJ4I5gPvwC7ZZFtDErUU
 R8nBtyXJKil+TRVHDh6TKLN0dpAWIhVHUFDcMOVzKOO2W7Tr+ArdRX9Pu4uInnkbp7w1v7U8YeD
 nMRBMthk72+5h8PFNltADlM6bNLwFsAJI6f9gcaIhxSd/NnOgt3MI/TlAICjZXN+CegHXSrD+TS
 DsV22NGd8fw9LrcemjybjOyA1TQqL8pKqzqLzM/8SdK77+Dg7bc3x2n4NJOL+tay3vKlbLjdNM4
 zurYqdTwyk9kwBNHg4P3suUvgcLScTIbueQAhPbkOl/PBQuHVThUsAlUzIW7AdRhYfD7kQEPcMB
 23bi19ejayDTYDiB4sQ==
X-Authority-Analysis: v=2.4 cv=Fqc1OWrq c=1 sm=1 tr=0 ts=6a1a129e cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22 a=aRezoWbpNT72RPsyBYsA:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11801
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 impostorscore=10 bulkscore=10 malwarescore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=10 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290223
X-Rspam-User: 
X-Rspamd-Queue-Id: A9A53100010
X-Stat-Signature: miij9rdt8htefkyqw7nm6piiq5u6x1i4
X-Rspamd-Server: rspam06
X-HE-Tag: 1780093599-330562
X-HE-Meta: U2FsdGVkX1/TSKwppBrrTz+PFld04BHcpqPC62lED4iTdUAygtDJAi+HDCsJVBW1LXCe1AUGaY6eX3xEgMI3ABm1zNu+54ZhBxNYRx2PhHw7n3h+BcUZbGf1EQxLZeikrhYNMmuenRqL8LSKmrzJAzeKjMBEoNM2aqkQCGTg4pYQUXgjTYuETIDcWi+A1dgK12sULSkmQ8ci2ZY29ZIYcvkA5LjCOHwngedvFk1KS8hUBt4HnotFTdJ6BEwZVqlpS2D5F0CMat4DK4QpA+unKX5yE/+jSLp/btxzH/VryRnE0VIezj2dvILjtAtMUcpf+BUveyJUEERvEt25BJ63zPhcO+U+ic/JbfgWcKth8Usb0W2kbhk2WZkw0VDRE9hepOB75MRHp/AFj244M9aWIkZcTMzHR4e9T/8XFILX65FXKfdnGgVeGtzTEMtXf5HAT5m/fc0Wo+VDV2KBprd6YmC4QAK3kj5ROHHHJxJ5usdPLCckAxIG1OxiNYwz2e2hIHYIXOwDFG8CTGNGNw+wxVGPXadbOmxtQDxgED6UteawC73TUr7AVXEG7mSBb/aj989w1gZbLxIXLILn8qVHAqCCh8F1f3jI62WtnDP9QZx/+JpWkerqdLCPJFWritju800Gr9f28RQMQjUPey7alPU0U4qYTIwOJpULDrBvzA/EencpOVJLoC863j+eXiK/7e1Kifm3AvG+/CpAUm6/FBMkVpwF6pcUEbz1R5mauN2r3fefh3VIcSZn/hkswg4/WwOGY0IbUaGC3JsQT/9Qd1VNBlKDg5aqiusJxnW+KLWB6YFS65DIV5Q9zcL4iCJBKsdN52Qs7t3rhlpEHMmLI/Iu5KLARZsGjEngEMf3Jr7DWceHjjAKw+0EhVYWArGBwQKdmr7YnJgbxoOiSyR8g4dnFDXtUSXlY4lfavEbKif1f6J/0tztmw8rn26U696viIr+WSzzbBVoD4W7H5u
 SnlVeSI4
 kjnhGCoCMCbvuwVrAyAdaLUk0r1GeLwwh9KmoRROxU/9jIFwWuDpRRe8EkumHRURZMwO3Qsqp6IEGniPkImBfR/xG8Y1edcDWuwADj+eD43sJSX/N2FFJCF5k3XPdnlIJm/4gfviJAViAw5jyoqWvpuvX0iGW77iYLNU2w9dKX9m3MlkjU/9qg1f2+RiI0PZDOFfGsqEPUokSAFvXzYshj4nkRRanCI/qbpt4KKUZSQqJeSfbvNmzQip+JkN6WNmzSaSazprkdAJKruXN+U/np5qE0uSC046pOC00acxOmqX7IobYXK3lrB2T8qU6vxqus+vZ8PJTtAnl99LZGazlXrQBCDuS5DhqSpyqhSMBiIvlSSRF1/uPIZ81qs/f6YnrdMZash4/WffaElDO0CUmf+3505i41PmzXjk+2lchQdCFsjJHF3lfbvRCq3RkpXT3+rJowJ1IksYiwu7upn38U5pNxZV9CYy6eG/G1W+35bTyLD2XSDNDFiBNw2aE67YJQEQh3aqLMiYocKKTLP7sHXhab6XvFDkCw6wfSZPamfKjsG/CWhNyciMwqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 5:22 AM, Jan Kara wrote:
> On Wed 20-05-26 16:48:51, Tal Zussman wrote:
>> mm/filemap.c has accumulated additional infrastructure over the years
>> that is not directly related to the page cache. It is currently nearly
>> 5000 lines long. This series splits out the folio bit-lock and wait
>> queue code into separate files, and moves the VFS-level
>> generic_file_{read,write}_iter() family of files to fs/read_write.c, in
>> order to provide better separation of concerns. This also slims down
>> mm/filemap.c by ~1000 lines.
>> 
>> The folio wait infrastructure is centralized in mm/folio_wait.c and
>> include/linux/folio_wait.h, with functions moved from mm/filemap.c,
>> mm/page-writeback.c, and include/linux/pagemap.h. Afterwards, the code
>> is cleaned up a little, with functions and data types renamed to refer
>> to folios rather than pages.
>> 
>> generic_file_{read,write}_iter() implement the VFS-level read/write path
>> for filesystems, including support for direct I/O. These functions and
>> their helpers are moved to fs/read_write.c, along with other VFS-level
>> read/write functions. dir_pages() is also moved to include/linux/fs.h.
>> i_blocks_per_folio() is not moved from include/linux/pagemap.h, as it
>> requires folio_size(), which is not currently available in
>> include/linux/fs.h.
>> 
>> No functional change is intended.
>> 
>> Note: I have additional cleanups to mm/filemap.c ready to go, foremost
>> among them centralizing on the filemap_*() naming convention and making
>> the exposed page cache API clearer and more consistent, but I've split
>> these patches off from that in order to avoid sending these logically
>> separate patches to ~60 maintainers.
> 
> Overall this makes sense to me. In particular I agree it makes sense to
> move the file read/write helpers into fs. Regarding the page waiting bits
> it makes some sense to me as well although there it's more of "I don't
> really care" opinion so let's see what Matthew and others think...

Sounds good, thanks. For the folio wait/lock code, my reasoning was that
it's used well beyond the page cache and independent of it, so there's no
reason to clog up filemap.c with 700 lines of infrastructure for a more
generic interface (and splitting up pagemap.h a little is a nice bonus).
But yes, let's see what Matthew thinks.

Thanks,
Tal

