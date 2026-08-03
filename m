Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E027EC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1026B00B8; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1491E6B00BC; Mon,  3 Aug 2026 09:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A6E6B00B9; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBD6A6B00B7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67ED3406AE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:03:45 +0000 (UTC)
X-FDA: 85059672810.17.B829F7E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id A12704000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:03:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FsuiiLhk;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1LdikCzHnIi62dfq8/K9AYncVOh5mbXj++hGhsLbls4=;
	b=eN3/xHIDvQtUpAbqUHbwx2wnWZO69/5oNwIpTtN6xWe8Os9Y+KprfC2tfm7/2X7SxwK8Gj
	qLISlesSHnEeYsRM6fpopluzfMXu+o9JZyQTg+P+Hy5Z57J6oyPyqo9D4cS3cqVyy8GRSD
	RmfhYO+9bYi2T5avlWkvDFeZ7+74zpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755023;
	b=N1HcttktjjJSj2ekD4rFV3yLUy7c2wDXJ9SjrVdFBgZRYW+xN3uK05FQ+AE9zD4Pty12gJ
	VEWoi+q6IZkBanDFFH1M2cXRtlC1bW7yMBdPM9iSJru4ZU6Yxa/rGSC6I6TPhm68ztqLn5
	K1x3Fns2oD4OM99y/sa+tyiUBj8U8uk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=FsuiiLhk;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673AT25I2066249
	for <linux-mm@kvack.org>; Mon, 3 Aug 2026 07:03:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1Ldi
	kCzHnIi62dfq8/K9AYncVOh5mbXj++hGhsLbls4=; b=FsuiiLhkIM09zlFAK1ZR
	JVBQqODgbbTmdK7mFuJSxhXTopBvkbrNFB/WpquLaWIsitYZYWCYXiXaXCfDtTT5
	GdrzCPLsWv6MkkNF+diFTM7EQ6q3jHrYEA0waXyQA+2pz0m76GgQ25G09ifvp2YJ
	TK7Z3mOqNsAxOL4Gm4JGj7cTkndGZrsaU+Rr6SST3K3fa/ONGFVF75rtAhEsCE3w
	5Gd1vyctR+V1kpokQCyeQE9iNs/46Ok3e0MT7tHdxbGNunrFuWPXSPeDLPf+sLUp
	q3Cg85erO9ZtUBIb+jMtk4enoDZODaZH7tGUGX1CRUaZACL2E6BH1fyvMKzP5cnr
	mw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4ft9k32w73-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:03:41 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c26012cd0so27468881cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 04:03:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785755021; x=1786359821;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1LdikCzHnIi62dfq8/K9AYncVOh5mbXj++hGhsLbls4=;
        b=ZfR/mpNHc/wSEMHE7r36NWsIV1UesaNHuZNGtzsJem9XJk79m0sFn4ESi3ekiPlvn+
         UDSw/lmvfTir2YhGMzCKYI8AXWaKgx3Jh/gVALjmpWTET8J+EW4IDIJHs9+AF7QUVAmm
         RqVYOALkwZtIWNM/thBp55pdsigOAAXrtyxbdl/lb6+jFArRS4C+whhoi+JdEDGJFqaB
         /iIc4kBbzJkosalmemZda6wt6INsIuoQMLJ0uzhV2DUUGA7zDG8Ul5E+oSsKLleeeXGG
         pMrthHuOtgbUfoKQOpa2IaKVD3igBwVuZK1NyObwG3zD8bAyI3vYZU9iwkZGvn+uYFPg
         mUVw==
X-Forwarded-Encrypted: i=1; AHgh+RrBY/lHUqGXF44Yu+lmkJC/wY+MQ893R/k1NtRwu69n/dm5DXDnDTXE+t5iVi22omy179krLr/3rQ==@kvack.org
X-Gm-Message-State: AOJu0YzciFrzIX/W1RKq1JIOiYUVitpH+eyIfDpQaN4VdaURm5eCq/3Z
	5382b00anh+pNPTHefFjEROx9RX7dRSjFRN0uhOTcPfrETTVkLOEUGjEH4T1ukTbyeba1wzeMQg
	jHQHg6wtp/HUOvP9slvk20Fu1DcAG4ENqZQBNz7Y+/ZjuWcCE
X-Gm-Gg: AR+sD12yQiJYB+00TFrgJJPSuogo2lMuNoHI9Kw1vv6rdR54bxxtdDYCvi0Sm4uyJy5
	NT1u1btifxJ76uSitzlLgZptfv4ckeHq5L9OlJuq1J3/2Cejv5dpkPZb/EZZ64DFsbzkJSi0Zzu
	cQYxOGl8vMPbswP7E58PwT33ig+lNyIWlTKZXwNovMyyciCFcwiZpDUeJ5w4d3Tk3P1f9ZVY4H8
	zsdsNvMJhAJJaK35XKxiXfmscM3P5/fcrgIov+lOW1eFGEzC74ZecKTP6LgmVKX/46IgSa71jan
	LU9+eYxoCA0yiDuQlh4FNB9DdhgFDa7HKjIKRt1fHzuXZBKb33fwNZfqLuJRV9BkAEtEowLinq6
	gzsdTcU6LUuXYLNdUu2JZ6Gkti5NXIaztIxVlhzBzNp03gJF97/U56/Qc
X-Received: by 2002:ac8:5fc8:0:b0:51c:1532:ae84 with SMTP id d75a77b69052e-52b5669dca5mr178425461cf.6.1785755021064;
        Mon, 03 Aug 2026 04:03:41 -0700 (PDT)
X-Received: by 2002:ac8:5fc8:0:b0:51c:1532:ae84 with SMTP id d75a77b69052e-52b5669dca5mr178424591cf.6.1785755020521;
        Mon, 03 Aug 2026 04:03:40 -0700 (PDT)
Received: from [10.100.102.30] (CBL217-132-158-98.bb.netvision.net.il. [217.132.158.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41d0064sm30745913f8f.5.2026.08.03.04.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 04:03:39 -0700 (PDT)
Message-ID: <08c19cc8-c28e-4098-b137-fc9721deebbb@columbia.edu>
Date: Mon, 3 Aug 2026 14:03:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] ceph: remove page_snap_context()
To: Matthew Wilcox <willy@infradead.org>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu>
 <20260802-remove-wait-on-page-writeback-v1-4-6c35d6b3ad36@columbia.edu>
 <am_3oyOJAoFeBFTC@casper.infradead.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <am_3oyOJAoFeBFTC@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=PNI/P/qC c=1 sm=1 tr=0 ts=6a70758d cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=C4zMR0+CEq2lM/mtmjScOA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=tvZamFcuqidHLa0JVA0A:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDA5OCBTYWx0ZWRfX+DzMqarFqjIZ
 wse7imjzjUex+kQyyohgLtmO+41YhY1l2N8+ykT/Sw1Zy98u8GZJo6lt6Nf2hiEJwsTjBbdICy2
 uxApmhvetHxL2/KS5HVyuqUjQOyPzcFGkBfp+P3uVKvrB6IZb6+n
X-Proofpoint-GUID: eL_nS04BDV_VfQH3GlBh0DAlkgHJkyr9
X-Proofpoint-ORIG-GUID: eL_nS04BDV_VfQH3GlBh0DAlkgHJkyr9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDA5OCBTYWx0ZWRfX2dHEK6eahc8S
 UgvQIRSjv/lvJ5l5+MPvkLRTwoNVcqkWVCHoyawcaXLRWkzGQMqiczw66fGoxFu/ta05fBipWJ/
 L2v8A9KobzJFjengmd9rhrFd5SnsqzvIAawtV0cMYcC7uMbs8ZAw2KCEGPQlFfFa/9mG/3U1lr7
 9HNPk8rrD8m8A030Xe2bd7sjC4UzXgAiMKG1WWh9ZgTJgNJpiI0T2vdKyuXHW32QoKITPnGjQ1E
 xSicUGreJf9i7nw+2sG9BW0NBlXqQ/ugx6Q657Z9kapr/OW1ghCWvkEYVk7mh/KVnZ5oeaciuTN
 sdg4S9LgvTQRIarfH2ZU4IxhZRR03tYZgG0nMV1WiOUPXNFUGCd5IyVimTA86DBXwA4G6C515ql
 KKKFvEMus6FCXDl6V+0sM0gi0LVZMi6Dtfk2SbzcwNXwGdO7acfplQCvrxa9L4d61ajiZZ2EtwR
 gMJa7Pfoiy9GgXw8Ibw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11863
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=10 adultscore=0 malwarescore=0 spamscore=0
 bulkscore=10 priorityscore=1501 impostorscore=10 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030098
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A12704000B
X-Stat-Signature: 8xe5q5ujk45qg5gp7dzmsb7oue4ykjod
X-Rspam-User: 
X-HE-Tag: 1785755022-32177
X-HE-Meta: U2FsdGVkX18qjjyyOk+DxwYzWllH76+QIoc0TMWUBQF9uUaBnYv4x9+XlBOzQuN6jFIkBiENqBiwDiuG23A3cGVgXJqMttNqz8qps1sB7gEzlyzy0TbuMzdRD8gUo0cskl0Pw7PMIEFrsCW7IcqwBvIkxge7dcqzDxDXWXz5/FVveJudJc9y0v0yoVZOWzZ7QXSlHEJ1FG9RrYmZnH5HQjAndJUNPiVfucm/TZMLPxgoB77CE262U0h6s1EVtPvO7zC5N82sZxywDbSU/4qql7YDeLX+P0zxLhxI6HbgR3VZsqbL2Tm/Ppkc/XF6+e3kV2OhicrwTEmxCnTDUa6wZJH81mwrtrGCeQ/reGImEeAMPMdxORNVOTbbeIN2WM10hIQ7gyPptUphvqpvqhG0WR1JHJEtwc48fdhH7AqUY2HfjLPWNk0xoHpwbDhdxY5u1W12q2hq+pnKsy3LwPA6DCUJdapuchqD8Bf0gs2hFC9McvvmdXI3o+4RtkQ7DnPlVDOwZ4mPSxAlfgwup/JhO4G6Z7bi/VZDdqaWJoF7DD5HNSVvyfuyhH5JB5wSquQR+2JZ/ijcAthcbM7BRxDq3Vfonogoy4/Uj3hXbN0meu+N5WbqiA/CJUx1CftAxnD3LBlRh5JzOD4yzJOwvP3ANK4t9NdC3BgchcAWzQ+LqdYIP/mjBe0VewLPRioUn8na8J7z6U6aUmRNFaAT61P1KzYCTrox89UGsug5FMPdFngYzc/HM4I5495874j4JR21bbU6lhLrOQGo2U86R3SyK6ZO037hbdueBS1sHnrcTHJFIRTAbxkmWeELPdhs3naVVxuubDQBDRXO9VHFjNYVeaHElBQCDAzRUahYGWhvZdeuzByn9KpmS48+AdQcp0HLEIem9mHaHD3k3u7/d5UaiLpuwxlj71hZX53eL/z5g/ScYtu5vzB9q8xIYMmps/FvWJRnYHzyx/0WVZFxGAK
 4v8vPpJH
 n9szUSyOdVvF460jC8rN7dDJgdcv2WeePwfpWi8LRg9Ax8njMeu7dHr2q8q0rS6O/33InkLSYQ2SszcxfFKe3/zkqIgJXYKqydF+Kkb1+ei5MUHrSzP6T5xVCBZfgQ06zaqNCUfUUAXrrZdGsLnyokjki38D0z2IPYQzeYToZXdHDh23ZM0uOYkeUJ+JRLmjyc5bslQQqCLVqqiK2CG55DShFOluCZ8H9wDYR3io/xoOeAKmso9Xd+GrqTUyffU8WoPQeKgLIkOKZoWtkhUe+L98X4QNfsh+aiHD6KnoHTA/2f12PVMe6QpAk8xT35+imEMq/OHVA65rHDM1e8uaTnicvMGVxDyGDsyj1ettxT9lbYRC7UFSpKTW4/M3Ih5YdrdJiYjmWL41d9N2qzlWq1LYZS2gzUE9qEiDrRWL12rn+hH62Ou/Cw2jV7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 10:06 PM, Matthew Wilcox wrote: 
> On Sun, Aug 02, 2026 at 12:50:05PM -0400, Tal Zussman wrote:
>> Convert the final caller in get_writepages_data_length() to use a folio
>> and ceph_folio_snap_context(), then remove page_snap_context().
>> 
>> This drops the last open-coded use of page->private in ceph's writeback
>> path.
> 
> This one I'm deeply conflicted about.  It's adding an extra call to
> compound_head() ... and we're not getting much for it.
> 
> I'd feel better about it if it started with::
> 
>   static u64 get_writepages_data_length(struct inode *inode,
>                                         struct page *page, u64 start)
>   {
> +	struct folio *folio = page_folio(page);
> 
> and then we had a ceph_fscrypt_pagecache_folio() function and
> ceph_fscrypt_folio_offset() (we already have a fscrypt_is_bounce_page())

If we're adding these, I might as well do a few more conversions...

> That way we'd have this function entirely converted except for its
> argument, and a future patch can do the conversion with little fuss.
> And we'd get rid of one of the four remaining calls to
> fscrypt_is_bounce_page()

I'm tempted to convert the argument as well, offload the page_folio
to the single caller (ceph_submit_write), and be done with this function
in one go. Although now that I look at it again, ceph_submit_write can
also be converted with the fscrypt helpers (albeit with a healthy dose
of page_folio() due to ceph's pages arrays...).


