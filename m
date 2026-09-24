Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C81BC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800226B0093; Thu, 24 Sep 2026 04:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8356B0095; Thu, 24 Sep 2026 04:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715586B0098; Thu, 24 Sep 2026 04:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 540F46B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:36:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF686140240
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:36:00 +0000 (UTC)
X-FDA: 85247998080.12.7C8F9AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3AE4980003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:35:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X31XwyZE;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790238959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7EM2scO1Xc78BwoAUHajjylw+akcDb4zR59+Q7scyY=;
	b=41MtW58gJnpoaEpKVJPijDVc+mAmu2Uy+11DgOe+KtgPTjk4yaId+5wd9dz5nIiULOfPRy
	dA8CW2OMG9FX3krxDtSrVCEVptw3OONbND25lhLcSVbvp8HiXluuFRlMWUpljJF0uxhSDY
	B20C3ekEyV8+cRvJX1Wegm/iV2e5m90=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X31XwyZE;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790238959;
	b=RRUdXXxLUYw11MZVuRpo+EI3E6vVN8iiGQMS3JGQV9cNPcMqTuakk0Ay24E50QZ+7E205f
	FXfE2JUTRcW+lH3VctyQfwWM8KrP7BpOQjmuZAJImnuR7UPF6Q7e19mPmDZOzTk5npYdIb
	MYHgC5xks+H9NmqVE22+wxOOG7u4Pyc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6582040C32;
	Thu, 24 Sep 2026 08:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F21F00893;
	Thu, 24 Sep 2026 08:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790238958;
	bh=e7EM2scO1Xc78BwoAUHajjylw+akcDb4zR59+Q7scyY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X31XwyZEWdHBJJBkwh+YGKGtWaKuIhss1ceDmg2QfxyV2X31Pppi40vmjCTILvnnb
	 HrfOnU7BMetUV7eps82Hyhcz7Z0liQ4ND+29yycijKUs4CZQB4q7y069slEnJOnd8/
	 CNZxGl7NAAmR5lcDhHKyx+vtzOdaYixVosaL6aolLXTam1ZOC7Wi9CPWo3p13yFB36
	 QDY3Og6jLZBEgLDp3bl8akP6miMDKR6EeR6ukVYgP8FK6UN+EQDsJUalySXr1qxVB+
	 FO0idQCoegSt9g7eEZu4yfAViCkCg77UcAr0T9ZdcsDk5GkU62SNwQ42iqhj/PxDvR
	 aGQcdycbSPiQw==
From: Mike Rapoport <rppt@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260922041321.233986-1-pratyush@kernel.org>
References: <20260922041321.233986-1-pratyush@kernel.org>
Subject: Re: [PATCH v3 0/4] kho: rename "scratch" to "bootmem"
Message-Id: <179023894799.508379.10846192044961348704.b4-ty@b4>
Date: Thu, 24 Sep 2026 11:35:47 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: ztxq18hnedpxod9nai636cnq79g93urj
X-Rspamd-Queue-Id: 3AE4980003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790238959-369287
X-HE-Meta: U2FsdGVkX1+BoCD5kNXeqWmhJ2mBJYp9PstEbL4FCA6oN4BJ+JYBwLN+TEH4/3byEsLo4tKXzyd1RwlI6YXoZMNlttYKp5GpRfnuY9EzUmRHFJakD4K+fHkrvOAzxTKaeSDuOJ1PLl/NcnlQ4Jw8aQGkRpAgThIpsw5R4KrvydUXqtplcHnwnRkVBb1gLf2JNx75Zhy2IaK7WxW9cjy+Xkv5e7vHIGX/0r1XQk5HFna0JFfl6juZCml65AviIaiqqajinkpblZ3mUxH1/PVIUE93+gIQ7SfBh6kWzJn3JlZ8e8Z/eKHoU908qsWK+NRFq01Ru9d6J5qd6me/CDyDMhlfXF7hni4PL+JQheqcBg3zNl9ZnH5EHVMtzIH7TZA5E02Uu07qBO7ZYDuZSq0Z03fGvhTzj6iNPlIrUn/KOuRgQdkYOySH22/vkp9YQlU579OEbmMFxF+FtOg+cGLzXLHw0fvr3CUyjbuSOYHitKmeqEazymt8E8nZRnh+BrNmrvjRKMP7utlHf0Dd6gq1fxLQzjhBSgtJ8sUJlrL+R6UNUjMG458W8VIHG9c8AAqQA5I9C8behmhzL1LYNj2U+ZCGAKYNSTkqBCh13qmUojtCDFrWtVyR1x9io7sZuGpgU7+EP+40XKjOzSISWDOXA+/TNFPQmVwwF5lwyK0NDtTjP0fmmn2yUP/5qt9z6JpflZH3ptbZ7dA0rpkabtBwTEXCvXf7T8yDwW786xG09/ayCzXCN5QPNAOe0HPikDYQFM9+Uvv0ovr6tM6jjVN9eQAg15QLZc2PuUs8+HZTpLZri2OIawUFbMIqgD+qF6mVFDahRmtNBA0A8i1CuULyHSrWAFsJWBB0+g0kZC9YIQUaGx2OpP4NF5uoM67nPfMJo3H+q0E4C0bjLQZ91JwB+oBglC0i57CAvBtC+JsIxesMlXrcBhYREC2xg1dM9PbM8z8kCvVvAIZZ01Liib7
 7/WYCYw4
 XQezajCP/BFDf7aFMnDX1WDAnDIofJ1+6oBxqX/5O2h5+0DldK1W8pg4t2DFzFJe+ilcXazPfHEHjV3TA8cdWmDUdIkylobD7cnNbRbVuE1gOvPwVlXjvTmt/mDebgiCvdYQr8VmAOZzPOy3YjBnKhaTqRPoLk+n6acZQHdFRw3X8bt2HvUvsb3gxIcH4qJCkHlDeCXuZ46GH5q1VMNSrAeB/nNHIIPFIQ22fBQgFchHTGMIlCri9aUhpmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 06:13:12 +0200, Pratyush Yadav wrote:
> kho: rename "scratch" to "bootmem"
> 
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The term "KHO scratch" is vague and overloaded. It does not accurately
> describe what the memory is for. This was discussed previously at [0].
> The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> is memory passed by the previous kernel for early boot allocations.
> 
> [...]

Applied to kho-bootmem branch of liveupdate/linux.git tree, thanks!

[1/4] memblock: get rid of CONFIG_MEMBLOCK_KHO_SCRATCH
      commit: 5e309f53050f33faf74f55332f359099d7346464
[2/4] memblock: rename KHO_SCRATCH to KHO_NOPRSRV
      commit: 05a84ceadf7024be320e2ba82fe709db4a4180bd
[3/4] kho: rename KHO scratch to KHO bootmem
      commit: 85d3615cea17968788aa6581fd242e34d8953e58
[4/4] kho: rename kho_scratch= commandline parameter to kho_bootmem=
      commit: 8fe64603a47506c3b357002460c3a9c0d8d4d321

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: kho-bootmem

--
Sincerely yours,
Mike.



