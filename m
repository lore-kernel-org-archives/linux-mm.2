Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCD8C9EC6D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:58:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22986B0089; Mon, 12 Jan 2026 05:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6146B008A; Mon, 12 Jan 2026 05:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AAE6B008C; Mon, 12 Jan 2026 05:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A408C6B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:58:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F5421A09A4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:58:11 +0000 (UTC)
X-FDA: 84323012382.13.4CCCFB3
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3B12C100006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:58:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LBY/Azmf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768215489; a=rsa-sha256;
	cv=none;
	b=VAPxInm1K7RAO17FAc2y3czQSj5xNI6eL5lGV8PK6cR4NaUerh9LD8VMLPwvwvGZ+8LfyM
	f/e2Ja5bCNqcRlibKSfbdadjjDSS7R5DzrCZMp2UIkfbBm3RiIUsxBBdSqRUDPyyJO8BPV
	m+myejIcaCG/HOBxxOpboE28FPeUWB0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LBY/Azmf";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768215489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adA1pfWwovY2UoWJPPih0D9Rj9g7yR5zYcd7adc9tVo=;
	b=2lxUqp4S3+RQMO5ThkuN8FWkPc1EsNndMp9k8lLfWw4MbmNhWIfvqUW8BV4xUOrfgiAN5b
	eepGpskzMI1rdPnniCZHZLr1Z1PYQW0R4LGDhw982iZH65TWig8Sn1+tmqaM8W44++1SJd
	/f/apSMgkLVQfLa/GKjxGZnzp39u2Z8=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b872cf905d3so47654766b.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768215487; x=1768820287; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=adA1pfWwovY2UoWJPPih0D9Rj9g7yR5zYcd7adc9tVo=;
        b=LBY/Azmf4GSzPnab9F4Q3xxRCWV91HFw2rAfex+KIOdGC4NjBZx37fEU5850KZxMks
         N8uCiZg/drx3IrjCJDnAhRhHC0bLSo7TOqtnMj+h93tW/uUR+P3hiuArcX++reeSRIOC
         f3gDXFY/Lv9wGZaUBn4eG/guhQoeQwNg9bJTmyjduBeAqIBs5+S7EqncSnsmUtwW/gwF
         mX4cVkxc/+B2uU4Ofay7SLa75sP6z5NFZma3S3/bCG+bKDyLyofpHDhY9yuDL6Z1BJnI
         jna8mgMQLh4+THkvrr5lhwndY5+y6i4DCVzotFk1gEzHUXxwuk1oer2QkcCJQnrIFsJ6
         G9tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768215487; x=1768820287;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adA1pfWwovY2UoWJPPih0D9Rj9g7yR5zYcd7adc9tVo=;
        b=j6facO8VroiOoWLc4QvH3sIWWynB3QBd+P2b8Fd6gEUVknve/yeZAWSeXk3vnRx+IB
         lMjPAl4omnuCJEbphNqQbslSDNzj9+j+tWyVgEr2fpA/+BUUAZr1YnC+h9asrm3vU8rj
         LG7UgNSe2+mn9mJm8HkTOgcOkyu+KHR/aOfefpuhCiEmCSRM1KntS3sYL3dVHVlz3wg8
         CEs77LR6NyU+nLzHGG0OKnu6Ftb+0T2jVdmfQwS+2zmoxYhcnNiEsltI2N8QmCXsov1N
         o8WekLaXr6VWyMz1eH8B7/h10wqcdHXEYbLSp5DxfImYM3hxDX43XqZ6eh5/Gc5cogwA
         E2yA==
X-Forwarded-Encrypted: i=1; AJvYcCWDzZa17WNHUkXkEhY/Tqju7vcnYup42tq8yphCWbCIdWgc0GiocMeZmBr32RcSIORk/QWTgCZmRA==@kvack.org
X-Gm-Message-State: AOJu0YzRIjynZMvydd02UFxyM+scOV7tS4w+9c+EhJChVF8JD4TYDlqZ
	igcw5QiZQAthUaist7fuk6u0LgPkBHLFOEsREUYpUjwgYU+xKCrSJLdSkKugOQ==
X-Gm-Gg: AY/fxX4WDjyDfPHWQdRZMzY/tcP4jf7hGcajEA/jD2866Kf4Sn1BFxp5W0OL/DXVeyO
	mi6TTyygdzE4SmcraLK14CTNUfc61//GAmPAYz2+adD2I6H5l9psbVtPs1dQNRQeEd31N8NKNT8
	mvyMcIzudfR6nARUusCVEo9ehOB44Vj3A7mCdsXzZDG3V74x1mIm2cgvYD1UL96D0GCx7MtchyA
	UYg487j+M0svgoLIcCE4m1dvMixLT3pN/WTDdFuBr/FmzjHYzNbbcK/4HohP6KkSz6y3kNfEzjS
	iUYiHIFiiQDg9P1JasXuhSvmXk9T/FNHTq+NNpqKxYt4r729r3Ami6EH6yRMUY5aOpewi40g3fC
	+RWbgUGIREk/qekbS5lNAsKKssT79go/C56x4+aDP5K5x9whlvo5VeRsoOTnb9y4iGtM2tpYYpx
	93DQiwotznzvhqiK3jDl3ZHdS8ov0Pjrb+s/DX6A==
X-Google-Smtp-Source: AGHT+IFIVt+/tdqSUiLxiFU/IaiqCnvUOdwWT9NHpHXxTczIiC5LUsjaXO1625aooqF/NTCZiKX43w==
X-Received: by 2002:a05:6512:23a5:b0:595:76d6:26f4 with SMTP id 2adb3069b0e04-59b6ef0945amr6101844e87.5.1768214993308;
        Mon, 12 Jan 2026 02:49:53 -0800 (PST)
Received: from pc636 (host-95-203-18-139.mobileonline.telia.com. [95.203.18.139])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b7a0ca367sm3018309e87.38.2026.01.12.02.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 02:49:52 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 12 Jan 2026 11:49:50 +0100
To: Dev Jain <dev.jain@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, urezki@gmail.com,
	akpm@linux-foundation.org, tytso@mit.edu, adilger.kernel@dilger.ca,
	cem@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
	shijie@os.amperecomputing.com, yang@os.amperecomputing.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, npiggin@gmail.com, willy@infradead.org,
	david@kernel.org, ziy@nvidia.com
Subject: Re: [RESEND RFC PATCH 0/2] Enable vmalloc huge mappings by default
 on arm64
Message-ID: <aWTRzpqU5yWhlV3u@pc636>
References: <20251212042701.71993-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212042701.71993-1-dev.jain@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B12C100006
X-Stat-Signature: 1wrra8i98byxuxtzxw1bwciikzr19oc7
X-Rspam-User: 
X-HE-Tag: 1768215488-513129
X-HE-Meta: U2FsdGVkX1+RSOh1SsVRXJah5fV12kDek4tCimTXMQ+wbl7tnC8NvAiHXgYm6KvTxm+bG/uanFO48YWRizj0uTp0foaEJvE6rWOpitLB071qNCN8zq2NEjbPmb9z/FegcABJBLuG2AzDTBZaqAaaWPZn1eI+3odST+/giGGq4noGu7pqKd57085xbxSOvvAB2q3c7Xyg9Zmm7jeZKyN/HVbX7iG10qFEW96iSI0ipXjHfwVsoIcq4rMUO+uvJntfdy73S8PvGvbkKKZNJiD/MFqMjzRdAzthlmmKBFKPo9m9RGpKGphI6e/JVa/j+QANv+ub7D5aNrLtsDIMQcTAtqwzo9uSGIr1fzrZYW2umZ9IXJROx+Y8f/FpMlGAhfGD4oo5FDifs1Ede5o086q4zMCHQ8BjdFQULrxBDl1wmt1FU587ibEUWk1lWXfi0xMBBA6Dz2XIjmxO9DWTahTL4VHqsuL9Eilglkm3Ak4d0B9F+wfCxR2SunM0U3rsDnHXkmOahoatELam8QKtO6Eo/SsTs8wQ9D1ofoC31VaR0PmorMMdP0yutwfMlx8Lh3QBEBSpEducsO6Qes+1Lqemer24pHYhEEdd4ZzF0Ee0veI3iZ7YYe9E3gLr8v9GPsdjug369YPPv/GxnKBOO3pbFL7lMH6PvPZu3pSMt8puBoaeMCb6ClgAHWh2OkNJ9Sqm1jHUMyYQqbqfdP7eStRMcW34WaZ4JsMH8lE0pa1vT3dE4+GK+F/GKapkgZBWf7aemM+PMKeslx3zacOZFzzGXjzVGAtOjD1EikUsJ+oEaYadkdt0t0pEjAMs3+Xz3ITodXvtacof3P95IztxgbsKHAubkOpyWIiwXjNQB+GgL2KUMugfeKYtubeCnoYfp6BrmSFUZ656HpRlhOWxZD8QuYUz3GDQEKfD4ksQlPNHPZQhrw6Y+1jKuvYMYXzQeOKQeU8R02iw7kW3bLr1wmm
 IVy8Eg3I
 DuHo1RNKsCDl31sfAs83FymksTIOiLRU7tm7+pOv23boXdc5NAtDYOHSHG4w65IfbdNOK8FlbABXqtFsk7nfHxoPPwLZPy4ExeuVBeasPhE74qdMNnm5MmL+v3kbf8IQuBzXkhMr5dZ7rJqPUxclMTDyfjVVv7UWfz1LzQ19h3BOwgRtN/J/0pe+4rULbJFe9j7YCuU3cjUyqUhTna/Hd22RtsHLpdMOBWsaGHWUjRP2T2QrbXgUt6HPwfEzYi5+x8GcK8Xj/uP+eCsNXOMSbkj3WpehOdIyttDepTA0zZ01Mlv97hIC/EdxkX3mlEs1GGPr2A1lJAxHgSs+ttIr4mrskKCIqZungq+7G8h+NpvHzeHDyjeFjB+fAZzEuVwfmLB7jdZsOOI7OAzfv+SQCd0Uj2qJZKNx5+6DoPWhDDkGkXqDXuWLGkEnotioisPDveTNtUbTTkp+D42xbC4b/rVOKoW9TL2KaW21e/ZXeQXvPh4LkM8NTU2t23rqbQNxDP+LVmAQaTrNDNU4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 09:56:59AM +0530, Dev Jain wrote:
> In the quest for reducing TLB pressure via block mappings, enable huge
> vmalloc by default on arm64 for BBML2-noabort systems which support kernel
> live mapping split.
> 
> This series is an RFC, because I cannot get a performance improvement for
> the usual benchmarks which we have. Currently, vmalloc follows an opt-in
> approach for block mappings - the users calling vmalloc_huge() are the ones
> which expect the most advantage from block mappings. Most users of
> vmalloc(), kvmalloc() and kvzalloc() map a single page. After applying this
> series, it is expected that a considerable number of users will produce
> cont mappings, and probably none will produce PMD mappings.
> 
> I am asking for help from the community in testing - I believe that one of
> the testing methods is xfstests: a lot of code uses the APIs mentioned
> above. I am hoping that someone can jump in and run at least xfstests, and
> probably some other tests which can take advantage of the reduced TLB
> pressure from vmalloc cont mappings.
> 
I checked how often vmalloc/vmap is triggered when i run xfstests. I think
it also depends on env. and can be different from one setup to another.

"echo vmalloc:alloc_vmap_area > set_event"

urezki@milan:~/data/optane/xfs-test/xfstests.git$ wc -l ./vmalloc_traces/*.trace
    2875 ./vmalloc_traces/generic_036.trace
   30117 ./vmalloc_traces/generic_038.trace
    8481 ./vmalloc_traces/generic_051.trace
   16986 ./vmalloc_traces/generic_055.trace
    6079 ./vmalloc_traces/generic_068.trace
    2792 ./vmalloc_traces/generic_070.trace
   26945 ./vmalloc_traces/generic_072.trace
    2772 ./vmalloc_traces/generic_076.trace
    2750 ./vmalloc_traces/generic_083.trace
    3319 ./vmalloc_traces/generic_095.trace
    2855 ./vmalloc_traces/generic_232.trace
    3537 ./vmalloc_traces/generic_269.trace
   21265 ./vmalloc_traces/generic_299.trace
    3231 ./vmalloc_traces/generic_300.trace
    3050 ./vmalloc_traces/generic_323.trace
    2831 ./vmalloc_traces/generic_390.trace
    4296 ./vmalloc_traces/generic_461.trace
    4807 ./vmalloc_traces/generic_476.trace
    3198 ./vmalloc_traces/generic_551.trace
    3096 ./vmalloc_traces/generic_616.trace
    6495 ./vmalloc_traces/generic_627.trace
   11232 ./vmalloc_traces/generic_642.trace
   11706 ./vmalloc_traces/generic_650.trace
    3135 ./vmalloc_traces/generic_750.trace
    5926 ./vmalloc_traces/generic_751.trace
   77623 ./vmalloc_traces/xfs_013.trace
    9172 ./vmalloc_traces/xfs_017.trace
    4145 ./vmalloc_traces/xfs_068.trace
    2982 ./vmalloc_traces/xfs_104.trace
    7293 ./vmalloc_traces/xfs_167.trace
   18851 ./vmalloc_traces/xfs_168.trace
    4373 ./vmalloc_traces/xfs_442.trace
    3550 ./vmalloc_traces/xfs_609.trace
  321765 total
urezki@milan:~/data/optane/xfs-test/xfstests.git$

Time execution is different for each test. For example "xfs_013" test
takes around 200 seconds on my system and is in top of number of calls:

77623 / 200 = 388.115 calls/sec
200 / 77623 = 0.002576 = ~each 2.5ms

Please note, i have not checked impact of your patch on time execution
or how TLB pressure is affected.

--
Uladzislau Rezki

