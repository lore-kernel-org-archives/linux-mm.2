Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82322CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83946B00A6; Fri, 12 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34636B00A8; Fri, 12 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A456B00A9; Fri, 12 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B347B6B00A6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:10:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49AE31C280A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:10:00 +0000 (UTC)
X-FDA: 84870083760.22.A0FB603
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0B5A1C000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ef+nsQ/X";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781240998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJ9mGuDBF51iJQl66AOPfs77n4Wa4tXYXGQQduefnAg=;
	b=nuHeKjAyOXpoCY8MDgHIhFOsH1YUjynicYTDnlzaPTb1kN6tf0kCqF9ugYG3nhmrYbtyud
	CEDoGd+PozIH0OyE0qsSmk15eK0lsiffq1S96D5pBMJBrJTvLMc/VhGB5Sc3m9GmRDH/JO
	kSsWCxe5zirm3JHyLY65GVtQ76UbzQs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ef+nsQ/X";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781240998;
	b=XrKbt1aVv1DwyC1jOpmy8EpyEwuQz6jLhGJqaCKfZ8zCFdeY/8iWQxYfWFLE8UGVKNo/9o
	G3ys9YD8zcKc2GP75aQVM9CEG7+zonBbzOzOZp/2fqAxkXBY3lsqAbzB9NWjM5sFyQLIIs
	Ew5g2bXhpC/wTIb0gJ0BjM3GYQJK8JY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sJ9mGuDBF51iJQl66AOPfs77n4Wa4tXYXGQQduefnAg=;
	b=ef+nsQ/XrcfexLUEHiICyPLwQk+xnqc9nwUMTJjMozeIHx0AM6piZSgmen1h+o6J93E9ZYv7D
	8oUU5WfLkIYm8BtLqpT/1Tf9/KH9I6r/FbixiKbkZ2Za1rSy2ue++uIoYKPXNsLfXvfu382hBqP
	BCJrtnM7SnhC2Z0nIJvouUA=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gc6nK66PXzLlSD;
	Fri, 12 Jun 2026 13:01:57 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id CAE3840538;
	Fri, 12 Jun 2026 13:09:52 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Jun 2026 13:09:51 +0800
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
To: Gregory Price <gourry@gourry.net>
CC: <lsf-pc@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-trace-kernel@vger.kernel.org>, <damon@lists.linux.dev>,
	<kernel-team@meta.com>, <guanhao.wang@huawei.com>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat> <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat> <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat> <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <8b998e9f-1d91-6dfd-8065-cfa7a3b19028@huawei.com>
Date: Fri, 12 Jun 2026 13:09:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: wc9niu3ut3phxq3ignwksd5xqhpwdatg
X-Rspamd-Queue-Id: D0B5A1C000A
X-HE-Tag: 1781240996-851618
X-HE-Meta: U2FsdGVkX191QAKJKmNbCU9B73l/lZ2sHkfgodjjW47TOeBA5mdEMFvKGYrwgLrw4IIxyah+PuA+qe7Py/07doGTQRK235GIrumpXhZrq80JSRl4t0tGRm3UhA3pL1vlQLmTB7/2G73fr7Y73d8Z2am8ygN24bBblCmuNcDb3eJoAG8qW/01VieyqtRNdRr/At59L7Vmev35BUarUSM+Qr5Q2xvJRLtzSIaeWoL65v2gSA0D4YSH53vGQPABsVLMLhWf7lIOpVzCPo+q5Vh/SSlCa47CWUtgm3v9vqKDmemEYbcUERa9QokNvd6I18uZfM3cMYplpUXDQ84Nenp6mQyMC0grPWPEBGlaGCHV0c74ryYLeLe4/Z0sicQKDC1ee6RZqNkPL6LCmqmREqcsW56mSjGcxMqhpya4thDNoKWcJcz19TKTKMBUekDZFcRFlD92qkKV2hI79FpXXekfFK8H4BeOv/RXDTxumhflvOr+Q9NtywPRRKQMbOXbYEnNlqW3I1M3fLQLCw0aCTTBtKRMVJtYjfgKRV7HpcBC8+OtiG2R3Lkh47VzY7O1kip+RdWaYDrEkKpCXvDjdTn3NreRtUWMmXOpknhggulEpD+nJDRA0p1a2ihlQfDkRNiSJf/qzR2FROtB28W2fmuJ85IoMpVDcCxt2uMT93kLUwS7SaojrV3x/QuZZrul0jo6jntaNpBuvOiLa0QAvOMsTzjpodXeZCfLlv3r1fi+rC63gDa9fdGzJyAn2kKdiM0Ojleab6d9Ovb0RnKZE2ld8EwhE1ZvBnn4vmDRm5cdD1qHDYVYBXFT0xBJeC4oFnt0G4M4HLBKUSvxyiCQxKhqjyXP6J55Dx7aquWjcWpPFRHHgJajKTc29y6gU15J+eDpLlqtoLaCvTFHr6Nlx7xQf07fPHfGKZy5pZAkX5v/ED7GgO6SFJC7rzThQ7qCLJwxklnYyHkel6GdBDHYbKN
 VQsBOXe2
 keSvaM1HO7cpysbUGB/gGFnzRz02eBAuQ5kQljUNAmGA5iadkZlHyNIIr4I4/MF20YEu/ar8eFYJVtqfrS8W3pegDQx3X1jKiNcsU2n0n1elTvfqbnxeobJlJ/gntQWBxu4o/SSV7kPctWQjYwr+wkkgiV4GQW7h1wmZqXI7pHE67QiUeQ+mXrqbrNls/KmvvW9qc6hDYyEScYUfbCEnsXHGgI4MotNTD3yJNOl7SJanomrzDXQs4bJ5IT9tRHFGijT9st0bjeBIGaECqj5izd+7s+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ trim the Cc list ]

Hi Gregory,

On 2026/6/11 4:12, Gregory Price wrote:

> I will still probably send the next RFC version tomorrow or friday,
> as I want to get some eyes on the __GFP_PRIVATE-less pattern.

Could you please Cc me in the next version? I appreciate that and would be
happy to follow this work.

Thanks,
Zenghui

