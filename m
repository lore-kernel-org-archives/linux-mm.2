Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1630CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF35E6B0088; Thu, 11 Jun 2026 14:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56666B008C; Thu, 11 Jun 2026 14:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E3B6B0092; Thu, 11 Jun 2026 14:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF706B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:27:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DEDB407F4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:27:37 +0000 (UTC)
X-FDA: 84868464954.25.7DCECC4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id E45D220010
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:27:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X9OkH/nS";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781202455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZLGFvqTlK6qAFIh/FbnUVu/Syu6iCO4Z21pxDpvgqg0=;
	b=C/ynrpL+LJI7J/7a7dcI8wgUz8DucAQedmk3l/0XidkeWSoJEBBEALXTwSixiFm8+eXzD5
	Y4DPfhKWq9EJ4fogz+R/gtAOE99+kmCLmcgiBEFnXw0eFx4x48DwdaJvFjjAqhj2Rc2LdM
	ToMNQ2f42q40Orhwn2PlVqdAfvRVnvE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X9OkH/nS";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781202455;
	b=P1Qlz/BGUIIkCJksxmJELUbh+Ihak/LE3+vWme+d0F0agX6Bn7soHVaOkTLHAXVHaDA8/n
	WFUmEVzAP74ovZIDtJ0CCL792oF9+VP4k5xiwvR7uDs0RLwvVugrM8o1KgRRxXCB91ZOvk
	nAQDKG1aPErgzGxIB20eyd1aeTP5U6s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781202454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLGFvqTlK6qAFIh/FbnUVu/Syu6iCO4Z21pxDpvgqg0=;
	b=X9OkH/nS22ymx9En8IQI7bdOqGLEJZm3lMJBiC7K2nmXtgfGsLx9CDq84+vCy1D3Se7rTp
	pIwlFhOeA1G7kMGpdnSOqyh5RP/FNbzCv6lwFG6SVY0BUAzhwmuOHPqPhAuXCoicIH0L1B
	p6Ip8YFO6r59mikWdY1ku7m1bfqIOhE=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-Vy8qAWIrOHukauaXjIXEGQ-1; Thu, 11 Jun 2026 14:27:31 -0400
X-MC-Unique: Vy8qAWIrOHukauaXjIXEGQ-1
X-Mimecast-MFC-AGG-ID: Vy8qAWIrOHukauaXjIXEGQ_1781202450
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-517ac42d958so1462301cf.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:27:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781202450; x=1781807250;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLGFvqTlK6qAFIh/FbnUVu/Syu6iCO4Z21pxDpvgqg0=;
        b=HqshFzorS946OUI4DjbeHqGT7VQ347mohsnCV9hPTGb4Wal90MeW6gVw9t+6tt8Gm+
         Lewd0op1/I54sIkf13d/6I2jvgZdGnXlEih9fpwQnynsD56QBflBwb7BtbrpYmBK78sF
         EBoH871XwUqfxg6/3zx3fW0veuvYdzYUjj8p66KCu0RH0N91L8Sk63PNHfZTA5+uWaSn
         Df9Pj2JT7vZuodBue6vci4CIZXRifzLDY8XYWbbRDD+W8ITpILGjroHTBePrwMRK7ipY
         BK04p4wxdnRtYHedtGX2MlZumq9bOmJ3RSUQRQgeictlnjqoL6hLL2d0ajtRWmtGBYgw
         RlxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9L4D5hYZRYpXz/IUvdQdBYEZYQiTKTb8jPw8REM9erVNAG75muhLEA7X8UHGCAyb/dCpRNq4dxBw==@kvack.org
X-Gm-Message-State: AOJu0YzohjFAJqOWp+YHIY86UYUzkkoayncDMxYpuQmX3iRxmjOf4B12
	Q/bZhWig2Kv/YnzHTw/OddX5auim72AUNJegIlqwF73hud346WzBfWsuAkDi7S8C0d8K3cZ9F0G
	JRmydDQF5tD3NReEzs47+fuhtPxSBdTsUhUXAcJObnG3QeMscb2+u
X-Gm-Gg: Acq92OEyy9XucqxFSpkko0OscccehTYHU8L3vDdPKUaqSnESIqzcHyRkOVSTdtW8TTM
	5WjfdX7OqZwb9WSfApLHA9rgJZ8dJLauNJFlCQ9zrGXhPHpdPp5sHzZ0r4uApcjxdd3O5oXRWpP
	1WCyyU/fDr6aGnc9M9zDCJ3QPX05bhP3wOcbp7DC5G/Daj/iSa7tAJAcng3CjDWRjK7MrcWKq1k
	9hYm0yrXhb74RIhyvnvO0KoFZzKeRQ9PjWjKzICl6v5zK+PvjLEjFuUBYVhaQDuXD+uV9Y7xDSM
	pVQZ4lbv+DNkGmBKUJypTHxa4aJLSowroRlf2UisYvfq2AtrrYYGXiMxj9y9/MLqf/LfGSUzOS8
	Tvw/AWRMsz2Nz9nSAESVo5qWRZXM2gEp/0upVIFf7raPPyuC2sMXlb5QSqEpGpcI97QbQX+sQiG
	m4tHNYQjt0TZUQ
X-Received: by 2002:a05:622a:4112:b0:517:859b:b584 with SMTP id d75a77b69052e-517ede3c543mr64499841cf.1.1781202450556;
        Thu, 11 Jun 2026 11:27:30 -0700 (PDT)
X-Received: by 2002:a05:622a:4112:b0:517:859b:b584 with SMTP id d75a77b69052e-517ede3c543mr64499201cf.1.1781202450026;
        Thu, 11 Jun 2026 11:27:30 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb79df4dsm153201cf.15.2026.06.11.11.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 11:27:29 -0700 (PDT)
Message-ID: <2793c81c-12f2-4c9c-bbc5-c9d88262c209@redhat.com>
Date: Thu, 11 Jun 2026 14:27:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/14] mm: thp: always enable mTHP support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, yintirui@huawei.com, ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <47f9202b-71b1-41e7-8185-426beb9d4a2c@redhat.com>
 <20260611112111.18be7ad24bb9ad3c7b3f83a6@linux-foundation.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260611112111.18be7ad24bb9ad3c7b3f83a6@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q0EN5S4-Uk5N2-kzsLLSVi16D9PXM1Gwq7bRj7fOpFs_1781202450
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E45D220010
X-Stat-Signature: tfq9fmg35rib94gt7he8mx64rzgei6mf
X-Rspam-User: 
X-HE-Tag: 1781202454-214952
X-HE-Meta: U2FsdGVkX1/TV8aAeCqVEU1tQPlBJOw1N9Yn16Ql9tU4iSNPunv1caJbKqqwQLvQjXpa65uyqIS8uC3fuBo7o7QOzXIRXzRFYBPntW0t+1E9ciFYJewJDNHggYGYQngmAwZae38ncGmja57FDGP5Vfg4JtQYqwvGKvsvwtK3jXV6NSDgwsyMZatdjIW1NuaaPoTEXCmmjUo8zS/umXGe072HcOpbtFLEvPsPInJZE/EbUQtIKvQkWgO0suA6yqbV9U8zclKpgj8lkEl2tVQaDZcHBeo0o4QnUlgoG4D7qU6npdxdxTf6FjKSSC7HTlkSyLg6ZEiLVdKgP/WpNNtTHukVQXyXJEUBw+FFFahe/8FBYksZxLWIsOG/6dyItyAS22oxhPSUr+g8e88Rq3Z/QZaAazGTdFvzgPEvR0pUb0wiTFWnGcJeAYtse/zOs92kGqHqEP04LZ4pnf2x3cloJi8lyzt/KScRMP16i7V/5mksLHY16JuwZqr0rk620KR9nmJL/Ns0faLk1BLfEhI7ciyGghOCIxBj4DkNYiWpIfEu0RqsGTJfZR+FpPjkrk+fAdoTOBngOvEoSsnEisk/5eOWG4t6nFAZjNoC+gE4+b6z3lvW9P6xDvH6rSfCug8XDeBWMHISWjE4aQ7jRLK0p4ivRMHXzg76VinoO6pb5ngGBI19IfPqoFY1bapDVuwAAbB4VUHsUzm5ZUwq/WRzZU8FReaQMzwodIIFDiC7T7RymWkMB+OE5mr1FQoIdecKFgSMl1eARYije2meKOmwVdBYOJEPM1cdhPPLbjmBg5KdxJQqpN3f24jn8B9K8MQLFYyenEynlMTEXr9hUhWJjizfr+2vEebWF4fbe0WYkSbZvv10GKsC9JNupmsb8dJMUEbAkv8BXq+JK9oL745LpILeVCBM4HSCPF6vZhDQiZZEEQH+QzwdHbZk/P4tHpMIxoKk7GEaBtecccg+joV
 Wg6/pbSy
 Ol5oxIQ4twROSlgvSLvYAXdzwdp1LDw1ULbqQFdpdjXz5oCha/QpgDSxWCRMkHgViqYmeDe0d1sjL2yhQQ1h/x1o6pqL3O7y23kAsqYHH4bSLl3kkzdWmGqzmXlb+xKx8dVKETA2RlvKBDDK9PvnzwebJ6gu4H4K/CkNvIN5/hvuAmGFaGv7iK9hsk6U9DqSUHWI+QcaCo6YswUD4/aspiYWAqVK38B1wX6dA7vfUyLzra01HTS8VNNHjHc+BlcyOJHmd4vL0P+tMdn4Om+9u3ezj0Fj3q1S1iejr0vaAOS5m0Psuxg3e+My3D3mpt/uYLo5/sW6W33mRrXKEVDExZTexKkP8+4YTSfgjrm/Yot+DA83m9ocQDlVMRHTxqrtdOR4mXYHd+7TKkOk2YLued9IksYa8umHJes6Pe2KyzhtkStPZDhbltpwWZ6D78mPnNFMiB8uMJZqV5Ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-11 14:21, Andrew Morton wrote:
> On Thu, 11 Jun 2026 14:00:11 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> 
>> I wonder if it's time to add this series to mm-unstable so that it gets
>> more testing?
> 
> We're at -rc7, so it is precisely not the time to add new material to
> mm-unstable!
> 
> Recall that mm-unstable is included in linux-next, and that for good
> reasons, linux-next rules say "only material for the upcoming merge
> window".
> 
> I *could* add this to mm-new, because that branch isn't included in
> linux-next.  But mm-new is just a few-day staging branch for entry to
> mm-unstable, so the same concept applies - mm.git just doesn't take
> stuff which looks beyond the upcoming Linus merge window.
> 
> IOW, please refresh, retest and resend after -rc1!

OK, will do.


