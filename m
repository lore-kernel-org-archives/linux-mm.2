Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D71D77882
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 481536B0515; Fri, 23 Jan 2026 11:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFC6B0516; Fri, 23 Jan 2026 11:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F9726B0517; Fri, 23 Jan 2026 11:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A66A6B0515
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:46:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2613C1DFE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:46:51 +0000 (UTC)
X-FDA: 84363807822.30.0A52609
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E68D61C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:46:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Dyiw4n6o;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769186810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7RDSeFPc9RAEmgUI/q4GyqNftjtecnDQ1tYQGKeuS8=;
	b=Qb1oQ1VRqKUQTf7//RaXEL5Cp32q6YLN1oTbDZ7xwvo9h55aWe+m7lXgMbQ9WxTLDjRS+E
	PYp0/gyRU0hywu2aBNw81kF71ew1v/we5q7sM40bGwSMiTcwksYOa0f6oJs6OuyHEsPw7m
	joGYshi0XvOF7cdX6PB0ANWRyrGCyVs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Dyiw4n6o;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769186810; a=rsa-sha256;
	cv=none;
	b=fuvvorLN3QN8yJ4/dJ0ZfCUKzPllnXbYrPObm1rCxh5pwBKbw76Vy/NpmC0D5/K6l5l1t1
	k8zRyJcwtAMeqWSyjoudkr8G0CFa23I6kO7/lSKoIPx1iRxuQ1kvryqOWlG4mj1gkYwbN9
	7xm2q0DCSD0Zh3zRQwRAeuX5yWB3t6o=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c69ffb226eso369122585a.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769186809; x=1769791609; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U7RDSeFPc9RAEmgUI/q4GyqNftjtecnDQ1tYQGKeuS8=;
        b=Dyiw4n6obCc1jB4/7GcrccoTf0Qx7j1eDprAgh5futy0sEN8y9CewvTB96JxEGJp4r
         ATJTK2wAzsPGo0LNmyEZ1bCP1T+IxxULFa/Txf1+TSkIYukW4WKD3v+a/sYNYkDfzqLQ
         2ti8FgHHKMD1KxrzlTkgLqaRG4vaVdzlLJ4zWy+q95IudFSAO6KsJaJF1Pu2+FcoXmlQ
         mxM3kL3US3qz4aw9+eBTXbaEpUh+XLC9eCgeLGPZHmSxwIROzJMj7HyL+se0cqSM2wMa
         i8LCBn7gVuOfgQLyWeJSuW9TW5PUPCMWn7tgq3CntWucDV+STHsDjs6ohR3I1yXUJOz2
         KlKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769186809; x=1769791609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U7RDSeFPc9RAEmgUI/q4GyqNftjtecnDQ1tYQGKeuS8=;
        b=bbSuEd9GmW6tmsFVMszJzHEfK7oosvVkma5nokYv4ioUZqcg/kygdyf4N0Qy9MFUZ4
         LDTfF1bOeGTsHFsxdX5JnOHRjS5ZGURzNIrmWnEAXg19ZprB954fzdOWTA0x3uiVJsDY
         fdxiIW/V/33/NGCAQ6XBz06M4w1WXug+5PnDYZBk+qRYZL0mar0BYPi3r04eKVuwsMp8
         n22Uxj9lIBtTC5WQMa7GXVysiCl8U/y3+++hQpvKuZwLfy4ecffZg5VHMs59yVYN/YVV
         5OqyoGBatAZL+I0GFpzmjy8OT2CaM5+s498jb0ir7sNSUm3YFxSFs4Yc4z1im0hUICrH
         YGVw==
X-Forwarded-Encrypted: i=1; AJvYcCUprqFYsFAi83KgbqhPO6JTVcP+IOD8SiW0VkbtlHQ4zmHiNFnAF12kK0aUOi65MFwe0tqK405HLQ==@kvack.org
X-Gm-Message-State: AOJu0Ywijckf65yHJn+ilimNiphZ0qggZj5zGKQtQuej21E8E6uzDxin
	RS6L1GRFDPIQi7RZOJBfXSC2CcUFgfbq8nP35ZUy8FqRtvCZt6CyBTQ6Y91RNxvC4aI=
X-Gm-Gg: AZuq6aJFhUnCYAd+kTLewsU2IwD5BSlDJ/3P84crj/vvEIkdazvFpX36BzhhXCu9vh5
	eymUIS4ygW6OcFzhFhbdHJh7tsSzNPu/almydX7r8D2Krkq9baH398V3kr/x3O/PsqKZGYFh0Bz
	aCRppYb5nUgS/Io/NZv3uU78GVjmCkVtnFMvbFNM1qe7eM7O7t7hCldyk48L3p8ItJNnfnHMzoJ
	51gRS4/U+5MWOSDomNsuaZuRUXEvzWy7aVPnRvLSpbIbpco0W5Otz81F/eDjIg2Xfnionq6VGZI
	CYVjOYBiQFbyGsRLurkfoOnlTWW7/qmghupXuwn8a0+pBdJfATZ4eIjzuvYT9aFS9N8aeFYvbQu
	WYC9AvafGwWZ7+JEKeqbbcUm1nOgrCft+sH5EfRjrjk17UmgcbyjRo7iypIg8uKXfuVRf1VKJAU
	xNoTXOfUmpNI7nHcXED4I1pOAOv5dpIFBpEqXk9iZq7FU0i7OF8p4xYzpmFFHx/LlRE92ZeA==
X-Received: by 2002:a05:620a:7106:b0:8b6:164e:e0c with SMTP id af79cd13be357-8c6e2d91b4amr471653885a.25.1769186807459;
        Fri, 23 Jan 2026 08:46:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89491841c81sm20690466d6.20.2026.01.23.08.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 08:46:46 -0800 (PST)
Date: Fri, 23 Jan 2026 11:46:44 -0500
From: Gregory Price <gourry@gourry.net>
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: dan.j.williams@intel.com, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID
 of CFMW
Message-ID: <aXOl9CN_66HywIjZ@gourry-fedora-PF4VCD3F>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E68D61C0004
X-Stat-Signature: fbfrkc71jrw8bwa88qab6x5cmbxbk9yz
X-Rspam-User: 
X-HE-Tag: 1769186809-305463
X-HE-Meta: U2FsdGVkX19frApCK0FTECXH5bDYYfnptwJNaAzP7Oiaca1JO58WFwsWfraXG87fKASzyMxRTyvH/TAEN3s54jBxMRj8A6r3iptfSQeirCijAZqkkEV3Pt10ls2Ym8RrlCC7DpfuvoF4aXKeC0WjX7mJYEsOU6I3kBOwhUv0amSmQe4tqZlKL67idoRo5xHVRiqxaIa8eQTQAnyAwdP/FjQVmcEA5at6e0c8f7fr25ZclZDoWjMMCts27nHr23g/fXpxT8fPHqcOTrs8ehWmTiEKNo7r1GfDcxr2A5ZRTW/e4ucA0osYiPQtZ/0H3gkf6SW4Z56bBLsHN4yIal4phR0qJDXyxOx7quIqvFwAroglj9aH3gpb+iy8tDCDkxfDpxrNkvCejexZo2HoZdNM7cIxdX9itmqEj1jOKhDt8pKpt5zwGLiZ38J+rwa1c52B1Vmk0fwVhsPMziIU5ChhrDAqEX56CB3baMSYIJDuDnA9KwRWoDl9ySYNrijkBoficR3UVDxFa/OR/n4wQ+DGCg3/Gt+9Amc7DHZ498d+aRi3IGwazdbxgjRHVAXI3DBWavZgI6F5fifzNtPlKc3RH4Wdwq3WaxCusZQerMTTafJh0FeYG4LTp1U1zA7X8WsWd5ZhNKgfoVkwYK2iqzR2tAhpCxBJ8LKffFxjfvdh5t2o4dPcjLaWTAxqlvbxgb/2zyAkKPxnpfNQeY8kAEHbGzas09/75yNosReNf72EDJ9m/aIBkELMN/2FmWHWDCITniodSR7iM07tlOtHhQ1Ja6YNyhCsSvRALAYSb9s8YBR2w3Hv2dRXweTNrwr6X5VsTUnBuqzLi6gtzx10VC6QqJ4aJwJ0r7p93PBEC0nExd2NSZIeCu6BtAQPztXaTvV8GabUvRuIHtrsf3IgCysCdV35UfnI6DrOiEYZ5cKPhWx7tB8KROaiPXkuWokJpmaPo6lX8Fk6sBYukMhXcBU
 pxFmFZvU
 3rjtDjRkxpIkrd57zH4nmUOzw4vOgvjy749elLOtEL3h9aLoi3ILmRnXdyGIFtzPDin4NVYJ8llJdGY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:03:49PM +0800, Cui Chao wrote:
> 2.Why a Kernel Update is Recommended Over a Firmware Update:
> 
> In the scenario of dynamic CXL region creation, the association between the
> memory's HPA range and its corresponding NUMA node is established when the
> kernel driver performs the commit operation. This is a runtime, OS-managed
> operation where the platform firmware cannot intervene to provide a fix.
>

This is not accurate

The memory-to-node association for CXL memory is built by acpi logic:

   linux/drivers/acpi/numa/srat.c

Specifically:

   acpi_parse_memory_affinity()  /* if SRAT entry exists */
      -> numa_add_memblk(node, start, end)

   acpi_parse_cfmws()  /* if no SRAT entry exists */
      -> numa_add_reserved_memblk(node, start, end)


This patch implies the latter is occurring - as it queries the reserved
block associations - meaning your platform is not shipping SRAT tables
for CXL memory regions.

We have only seen this in QEMU - and this is correctable in firmware.

But if this is shipped hardware, letting us know the platform lets us
know whether we should backport it.

---

All that said, this does look harmless, and seems reasonable - but the
changelog should reflect what the hardware is doing above.

~Gregory

