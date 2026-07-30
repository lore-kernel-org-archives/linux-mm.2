Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E96D7C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F111B6B00A1; Thu, 30 Jul 2026 03:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8266B00A2; Thu, 30 Jul 2026 03:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFF46B00A3; Thu, 30 Jul 2026 03:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B11BA6B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:00:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45F7E4091C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:00:38 +0000 (UTC)
X-FDA: 85044544956.02.C86B7F8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id B1B3BC000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:00:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=uU43ShrF;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785394835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Nh80I+Q86ue/QvLYmdk7AAI26tQVa9m2Msk1A1FG0Nk=;
	b=BB8l4KkZqk94zDrg5vZlqCcISuWM681/EbadXGMprVEbmCSFnacwF7P9HxSPgSJ94ahOvP
	2YB3VFslRLpiqt4OxJ6uC2AIdoOOLHd42uOxBtDBvcaQ5alIZVIMCO4yhAKmnJjL1Rw6Hh
	mzPGAaGsqHbvahk7OVhdp6OwZyGBa68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785394835;
	b=uqxeGyKGh8ipG8SjKOVfetK8G/XKKzY1BSZ8Bc2q7eBtgayvQKXKov9XAo9+9DfRMbMRMO
	aAEJuBOLlpU6dbD4udcEHl+J8lotMLnfipyF6RypJ4XUJSn6/DQ23ugdgswabqoBVi8T5m
	nXfFhowRl54XJDYOVX0mmKFoYzN7QF8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=uU43ShrF;
	spf=pass (imf22.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6XJLe1885483
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=Nh80I+Q86ue/QvLYmdk7AAI26t
	QVa9m2Msk1A1FG0Nk=; b=uU43ShrFazA4tvr8sWy125pCBFiKOZ35wt17opAAE0
	5SUrElN5h7WWWLjaV4SQZkx24E1fUMmGTHchhcxUxi4i0bnkNUsFtEyHp5foc8Vq
	3+VnDFkCOg9ZWqf6DYg6xofJQSoqwHxnSyL9gx9SH29q+1fUY2Ivro+YGZw72ysx
	aoIrqk0Yg1tj85VK7ZDmme9UoZ4WAPoJbugj3l4KZaMVZjqdKvwiwe93N3Ih7leb
	GFP/7LsDyPgdgyg/f8ktUSx6QX1xKOFvz1UcRz5y/RY4Cw9ohquoaYEl22Gau2eD
	RJU1lP7zJUUr++Aaq2xRf1eI6/rA0XmyLQatnu06z2dg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fqud416ph-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:00:34 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e52306621so158465285a.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:00:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785394738; x=1785999538;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Nh80I+Q86ue/QvLYmdk7AAI26tQVa9m2Msk1A1FG0Nk=;
        b=H4VbK8aeOjYupTF3/d1+2LVNKmRdbknSRHCkrjnz8VEqNDtBUUbyJn7lr3tVawJHdG
         6EBNe2a6C8RJOaiQQ6R9N5GIPUBZiO4/iPb8plY4sQNk9YYL4IOP/ntqzj3hXUwQ57B/
         QUYBRLw1hpdP3F1TN3q9UtXUx70XvMXDn0b6Wu3gPQ4ltOaF03jxjshKAzr731Wwau1s
         6deJdY2hY1hGMuDvYkMPs7hvi9++UbTb1mUgBImQwiRQWPQAtQOt95U0v8G0YfRg7AbW
         xyZd4gPdGDSY1H2NyfTEIIJPv0qTXW6Ge57GPRETw42zqvP1wN4aDyLIzX3ayXUKMPmy
         dfUA==
X-Forwarded-Encrypted: i=1; AHgh+RrIqQB3IPVt5Zoro0rRGpV9HAYu0sKGiAd6Q2iTU31u8hofGW3G+rvg2RkhRf7OfVSXBShSyu3j0Q==@kvack.org
X-Gm-Message-State: AOJu0YwsqfnmX0JE3kBgkBGbir/5Rsf2VDbNoeGpi8a9cfOI6b6QUjZ3
	CXAQtbwIAs9eS5irJD5KVmXe9BWXiNArnfc0vbhHetLp/cGmAtPsEZn5Ov/R8cPMoFB9b3XsnNN
	hTBTHYJg4inEbAQMbw2gim2NcKGHpZwacGbaEdMF0yUG9ryOf
X-Gm-Gg: AR+sD128iwbG7/YJ++aeek5aUZipLfVi0Q9iH6LS9lWDbaRNWRk6TQDjmg8he81HyGs
	t2TzCCBNn61PVf9tCpJs9KVTnE5MgwjClxB6ExswSTb0uvCiF5lahEUgtJYshspj20tT2+gcqNO
	8Zfk/UiwluLZVo38+91WV0FpW0Hr0ge4Ob+0sKUe0DfHkBAaJIe27X3e9xSDUEo+zzThUz8tbcB
	R2qOPnmE5qwzOgttAFtnAE7/ZfdFCh3SXWXPZT23fg1Z1Ki8zK8C+KRbmAIvXh5rFvSy00/OOEW
	M8h80bx8f/J+m1nkbn0rbIPTLRFsJduei7EdNUHrm2RJry0Sgf8WEzPS4T96hj55vQPca6zPIv1
	iuDnlNW3e2IunlUavRtJCaEc1S8EA1wjXLWquMVOL8lxKig==
X-Received: by 2002:a05:620a:470f:b0:92e:6c8a:2a1a with SMTP id af79cd13be357-93485f8799dmr141188085a.7.1785394737607;
        Wed, 29 Jul 2026 23:58:57 -0700 (PDT)
X-Received: by 2002:a05:620a:470f:b0:92e:6c8a:2a1a with SMTP id af79cd13be357-93485f8799dmr141184485a.7.1785394736887;
        Wed, 29 Jul 2026 23:58:56 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3221bc7sm349752485a.7.2026.07.29.23.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 23:58:56 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v7 0/5] block: enable RWF_DONTCACHE for block devices
Date: Thu, 30 Jul 2026 02:57:50 -0400
Message-Id: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO71amoC/3XQy27CMBAF0F9BXtdobI8fdNX/qLrwY9xYpUmVQ
 FSE8u84bIJCWN6R7tHoXtlAfaGBve+urKexDKVra7BvOxYb334TL6lmJkEakMLxcPzhqWtP0ce
 GuFJOKJUSoCZWO3895fJ/9z6/am7KcOr6y50fxXx9JY2CC559MsZqylbkj9gdz7+h+D2lM5uxU
 T4AUq8ByYFbIOsj1j64DUA9AnYNqArEpOAQY9LObAG4AOr5A5wBDNqkgCob3AD0AiA8baArABk
 cRAn+YLY2MAugBa4BM2/gJMnsLVobVsA0TTdQ43q58gEAAA==
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Cc: Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        Hillf Danton <hdanton@sina.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
        Tal Zussman <tz2294@columbia.edu>, Christoph Hellwig <hch@lst.de>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785394735; l=8495;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=aWu7BOn5GohnRYxURL3oAHwZ5cHf4aE4kBCU34sAm1s=;
 b=i7kTq/xKpl6wc2j1Nlg01vDlZMOfxoqdmbN5qS3mBj8WIj2cibNqh2r2fUl9u49JQrAsz/EcW
 GCakIuY/GaWBl034kywR3hYqCwil8RdUzFGTe0/O1kZ1rWNv7dkSFK1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: EzKazFmOReXeu47P3Sm22CZKuKLxEy5R
X-Proofpoint-ORIG-GUID: EzKazFmOReXeu47P3Sm22CZKuKLxEy5R
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfX/OOhXjDao20C
 uELsKGc+x7WQazka8LwDlzMh8wLE3PeIjaUWt6tIrnOuvJ+ebAHykLQ91oW6ZCZtc1nPNpc/YAl
 3zdd16CXSwDsqq9vQvhUD82T1M1oEbmuSEoTl88nI3m3qnG3y4F9
X-Authority-Analysis: v=2.4 cv=b4KCJNGx c=1 sm=1 tr=0 ts=6a6af692 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=79PYxaXUQd1wl-QFWJnA:22
 a=VwQbUJbxAAAA:8 a=RwdnMBCSlJgOLVuh71sA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA0OCBTYWx0ZWRfXwZNLHW0AxMGl
 7QSQz0M9p6q3WV+/Gvxb4OSThHG7FkRzEbB1wk9KPjBHch6PhEF0wZjfTjsqzKaZGbnDdvNrH61
 YIp5UXb7tkO5c6avJH+pYlI3pX0PtTv3aEi/lRGzqk+LuU0g0QyTLRznFo8gwUESePAF9F1Bsrs
 8ndUTfwYjI3+Q825iQMJIuIsnfRB7+ltIQMEFwoQHbFsE6WuD2L8B2WpmmFdPKO8ZJJaQh46gki
 dItfeN+jk1EheV6H+ZhjcJhwNRdj+9QVpUKu09+pbv3RcVdgMfevzPgv7mds+6b+hfVnIy96RT9
 b57937nPojzplzUi4ST8Villuw+Xr3lBjE0XwlyLWWjbY+Rmvr5KqestGZqZlGAgvqygDqe6RAo
 HqziY1c99gVpWc3P0lTitZkeWDmLG0SNOKrdig2d/128DO5txrM8KsUILMbwffQJDdkJqF8XxIc
 QosokX6eqfjSSRtJD+w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11859
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=10 suspectscore=0 spamscore=0
 lowpriorityscore=10 adultscore=0 bulkscore=10 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300048
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1B3BC000F
X-Stat-Signature: qou41tkkep617ge16qmeacntqgchuxra
X-Rspam-User: 
X-HE-Tag: 1785394835-850622
X-HE-Meta: U2FsdGVkX1897kl3b0U9ShWzquX6sAEbkt+LzdhOak+HtUnSbE2RvauuRPz7CibCHQtRvk+Ju8aHhfNXWrAe+3yze99UdOI5zXg8m3ATWmHeY+NjVTR2D+VhIOB9rvZMjwdLyKB3US+1K9uOdJLidxMMXKDR4x8IPSLDENl2WgfkIYHADb44tdlWzI7QM8FvZAuLona93s/L36gpj2tX4Lk8DONe/H1vrkaE/JzwnYEMNbq3B7ZGWfcihvkanXCkGKTFhrWwEM0rR6WaxrA6dPoT6UJ4+itYpoc1Rbk4S6QSP6DyeywOkqOfFyFscSZkFlCZmnP+g3ogLnQVEU1x3y3HRgnqZWFKICvO29t6nmtrMKAGfUCi6Sb7r9ljsIMjUnzRT+Hcpzd1BmHcW2WyPr937wlVHD9we+2F+Z6MjBHx9nJYnJTq8HbmG1MnnCrb2G4+wQ1hct3YCFTKmHYslpdQaLVJ7N/wmygFXqg7iAznbgVCHM24NFi4YZppibqImNol7uXXkOB2ePFw1EH66qAtumfTxls7NiDVKMh5MWbffNPbjbBiKcGhSD+IsisWUfrYGeJ3LT6CiONNa81vbfFk0h0DbHpNZqSJRmmfSMYmrXHNra11MtfQjKdakJUU1aLR/Zu/6JK04mxFgCEDcxHCP3Xe/GKfc5zC83Zp9cHsQzoRhTrNVoH7sprM+wW8U+p8q3/3k6CnqvhzgV4C2VHHoNxhAaC+0yqAFq0jP4kjvXX+avfVU/o0oM2jcrxoi/bSw8dQU2MYolDFNlUubni0VaKeYrLdhS0U1R0oiw97MGzX2WRWAJSIHF5wqIqHFpumU/A0GK+c6ZWOftxZczlI3ckkdLUmYzVgVt+XY0XOuFgHRA/ssWHppODmXnZkvHBqwA2V8gqvNKbOtVK90pvwhWQ4vNqhjUpLxLkCefh/7Ta2iUFV+cwJ6ngelzbyCYvxFzFQoTeJXFAt+f1
 qTu/ho+2
 gTvNg5DdM2McTHHQaqd+tJozkmEH0Q2lI3czLNFMhymLz/loh4+mIW+r3UUr4B2FNsT05KsGxzheY7rR5ekYIHwk0655OlZiUvwdhK7TaCA4y8DWwhzAJ+Unawfaax8xYY+9hCsOaUldadB4fUoPXrr/FWaSyKam96gJHfPNsfV8NO5zWAC/+DjgiRHcRfAP9pterBXZFdsYz62OipapMwlBA1DKf7N2Po9QMfiYy3FtxcvUZjmYAJ/n9f8jtTEnQdf3JO9LIKz7VcL+2yAEAi1oAJQ7Vc+7IPzS4u8LzhXkEfBkdVqOua/R8QbwM0TJxItXjVPMSgj/lkhHttXDsMt0J/0JOE/P+F+mi3jlUfCxDG4g3TOv+g2/kLVOMPaftQF4s9lN3e/c6XNcRVefwUVhbx0REEdgNd4k0vqNro/Oey5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context. To fix this, we defer
dropbehind invalidation to task context. Add infrastructure that lets
bi_end_io callbacks run from a worker, in two forms:

  1. BIO_COMPLETE_IN_TASK, a bio flag the submitter sets when it knows
     upfront that the callback needs task context, as in the dropbehind
     writeback paths.

  2. bio_complete_in_task(), a helper that callbacks can invoke from
     bi_end_io() when the decision to defer is dynamic, as in iomap
     fserror reporting.

These queue the bio to a per-CPU list and schedule a per-CPU work item
to run the completions from task context.

Patch 1 moves erofs's atomic context detection into the block layer as
bio_in_atomic() and converts erofs to use it.

Patch 2 adds the block layer task-context completion infrastructure,
with both the flag and the procedural helper. This builds on top of
suggestions by Matthew and Christoph: the procedural helper and
bio_in_atomic() come from Christoph's "bio completion in task
enhancements / experiments" series [1]. The procedural helper is unused
in this series, but has multiple users planned [1][2].

Patch 3 wires BIO_COMPLETE_IN_TASK into iomap writeback for dropbehind
folios, removes IOMAP_IOEND_DONTCACHE, and removes the DONTCACHE
workqueue deferral from XFS.

Patch 4 sets up DONTCACHE support for buffer-head-based I/O by setting
BIO_COMPLETE_IN_TASK in __bh_submit() for the CONFIG_BUFFER_HEAD path.

Patch 5 enables RWF_DONTCACHE for block devices based on the previous
support. This support is useful for databases that operate on raw block
devices, among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap partition (~1GB) in a memcg of
size 244MB to force reclaim pressure.

Results:

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        1098.6          1609.0
   2        1270.3          1506.6
   3        1093.3          1576.5
   4        1141.8          2393.9
   5        1365.3          2793.8
   6        1324.6          2065.9
   7         879.6          1920.7
   8        1434.1          1662.4
   9        1184.9          1857.9
  10        1166.4          1702.8
  11        1161.4          1653.4
  12        1086.9          1555.4
  13        1198.5          1718.9
  14        1111.9          1752.2
----  ------------  --------------
 avg        1173.7          1828.8  (+56%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         692.4          9297.7
   2        4810.8          9342.8
   3        5221.7          2955.2
   4         396.7          8488.3
   5        7249.2          9249.3
   6        6695.4          1376.2
   7         122.9          9125.8
   8        5486.5          9414.7
   9        6921.5          8743.5
  10          27.9          8997.8
----  ------------  --------------
 avg        3762.5          7699.1  (+105%)

[1]: https://lore.kernel.org/all/20260409160243.1008358-1-hch@lst.de/
[2]: https://lore.kernel.org/linux-block/20260723145000.116419-1-hch@lst.de/

---
Changes in v7:
- Rebase on v7.2-rc5.
- 1/5: New patch. Move the atomic context detection into the block
  layer as bio_in_atomic() and convert erofs to use it, per Christoph.
- 2/5: Drop the 1-jiffie completion delay and schedule the completion
  work immediately. Use a plain work item instead of delayed_work
  accordingly, per Jan and Christoph.
- 2/5: Drop the local_lock and use local IRQ disabling instead to
  resolve PREEMPT_RT concerns raised by Sashiko.
- 2/5: Drop the need_resched() requeue from the work function loop, per
  Christoph and Hillf.
- 2/5: Use BIO_COMPLETE_IN_TASK as a sentinel in bio_complete_in_task()
  so a callback running from the worker does not re-defer, per Sashiko.
- 2/5: Requeue pending completions when a CPU comes back online, per
  Sashiko.
- 4/5: Check for op_is_write() before deferring to avoid deferring read
  completions, per Sashiko.
- 4/5: Set BIO_COMPLETE_IN_TASK in __bh_submit() for dropbehind write
  bios instead of introducing block_write_begin_iocb() and threading the
  kiocb through buffer_head writeback. This was dead code.
- 5/5: Drop the blkdev_write_begin() conversion accordingly.
- Link to v6: https://lore.kernel.org/r/20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu

Changes in v6:
- Remove RFC tag
- Rebase on v7.1-rc3.
- 1/4: Revert to using a bio_list, per Jens.
- 1/4: Restructure and simplify work function loop.
- 1/4: Expose both the flag and procedural version, in order to allow
  static and dynamic deferral decisions, per conversation with Matthew
  and Christoph at LSFMM.
- 1/4: Use bio_in_atomic() predicate, per Christoph.
- 1/4: Use the CPU hot-unplug protocol from mm/vmstat.c, to take into
  account use of delayed_work.
- 1/4: Mark the workqueue WQ_PERCPU.
- 1/4: Add comments.
- 3/4 and 4/4: Split into two patches, per Christoph.
- 3/4: Drop the cont_write_begin() change. Block devices don't go
  through cont_write_begin(), so it was out of scope and was left over
  from v1.
- Link to v5: https://lore.kernel.org/r/20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu

Changes in v5:
- 1/3: Replace local_lock + bio_list with struct llist, per Dave.
- 1/3: Use delayed_work with 1-jiffie delay, per Dave.
- 1/3: Add dedicated workqueue to avoid deadlocks, per Christoph.
- 1/3: Restructure work function as do/while loop and only schedule work
  originally when the list was previously empty, per Jens.
- 2/3: Delete IOMAP_IOEND_DONTCACHE and its NOMERGE entry, per Matthew
  and Christoph.
- Link to v4: https://lore.kernel.org/r/20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu

Changes in v4:
- 1/3: Move dropbehind deferral from folio-level to bio-level using
  BIO_COMPLETE_IN_TASK, per Matthew and Jan.
- 1/3: Work function yields on need_resched() to avoid hogging the CPU,
  per Jan.
- 2/3: New patch. Set BIO_COMPLETE_IN_TASK on iomap writeback bios for
  DONTCACHE folios, removing the need for XFS-specific workqueue
  deferral.
- 3/3: Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() for buffer_head
  path.
- 3/3: Update commit message to mention CONFIG_BUFFER_HEAD=n path.
- Link to v3: https://lore.kernel.org/r/20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu

Changes in v3:
- 1/2: Convert dropbehind deferral to per-CPU folio_batches protected by
  local_lock using per-CPU work items, to reduce contention, per Jens.
- 1/2: Call folio_end_dropbehind_irq() directly from
  folio_end_writeback(), per Jens.
- 1/2: Add CPU hotplug dead callback to drain the departing CPU's folio
  batch.
- 2/2: Introduce block_write_begin_iocb(), per Christoph.
- 2/2: Dropped R-b due to changes.
- Link to v2: https://lore.kernel.org/r/20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu

Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (5):
      block: introduce bio_in_atomic()
      block: add task-context bio completion infrastructure
      iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      buffer: set BIO_COMPLETE_IN_TASK for dropbehind writeback
      block: enable RWF_DONTCACHE for block devices

 block/bio.c               | 132 +++++++++++++++++++++++++++++++++++++++++++++-
 block/fops.c              |   2 +-
 fs/buffer.c               |   3 ++
 fs/erofs/zdata.c          |  11 +---
 fs/iomap/ioend.c          |   5 +-
 fs/xfs/xfs_aops.c         |   4 --
 include/linux/bio.h       |  39 ++++++++++++++
 include/linux/blk_types.h |   1 +
 include/linux/iomap.h     |   5 +-
 9 files changed, 180 insertions(+), 22 deletions(-)
---
base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


