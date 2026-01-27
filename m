Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE07D2FEDF
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B3F6B0089; Tue, 27 Jan 2026 16:02:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04D96B008A; Tue, 27 Jan 2026 16:02:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07AC6B008C; Tue, 27 Jan 2026 16:02:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A10316B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:02:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59CC8B86F6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:02:00 +0000 (UTC)
X-FDA: 84378966000.23.37C5EBA
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 714B41A0002
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:01:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mKU2mvz2;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769547718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vs/VTqhwxiApM2k3Iv0n6ahnPBiWdzK/0rcCymF+C0A=;
	b=G0/cZqjbaNChufHiyH8F/sfZi17LWzbRusLnWoeCiYiqHEuxyrfeVSg/Ex+7wQS4flGk0c
	EdhFMlBQpI+Kh2mC72B7N7W/4YB/PmV8fvm82esa0OgKoxoza8tKU0Sr2sN/1qAxLyQv0k
	lBsTXLF0mtSe9clIgyE+TGFpqKEsLRY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mKU2mvz2;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769547718; a=rsa-sha256;
	cv=none;
	b=1FcFi0n6VLiBxUw12XradPcgwjzF303B9pETntEEQecspBfbNp4GfkpPWkRbBMy+vErj2x
	xdmeMxAmONt+WgjqYyEPs6pEtLQvGaXfbfDsPjY8tK8fmYE+nijhwpRcUQUpY5E2AZXQuH
	6zi5A5Ok4FxzwPIJN8Tdf9KQXHWvmxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769547716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vs/VTqhwxiApM2k3Iv0n6ahnPBiWdzK/0rcCymF+C0A=;
	b=mKU2mvz2oA6LgTfovx/gJTIul263fAsC+yNOGHHMBlWg3/zzkH0PPrmIJ/wP8MF74009oT
	fEpfWCgNi6DXEEN/LCOSn6/viAN8tERCR30BvpgYVgxjvSCNY+2G5aqhMf4u/nBb/AzA5A
	JiCOao6zDMfCIvQsviU1KaVGidwtbBk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: bpf@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,  Matt
 Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
In-Reply-To: <aXh_LpTzDhvv20uB@tiehlicka> (Michal Hocko's message of "Tue, 27
	Jan 2026 10:02:38 +0100")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<aXh_LpTzDhvv20uB@tiehlicka>
Date: Tue, 27 Jan 2026 21:01:48 +0000
Message-ID: <7ia44io6kbwj.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: tjbfedbf6arwwum66otpfpcurnp31iww
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 714B41A0002
X-HE-Tag: 1769547718-754153
X-HE-Meta: U2FsdGVkX1+O4vRy5mjRhGI4CBtuxI142Y4dfzVOljDtYhwKOjMPZNsG3qIsfSUW72pPxoIvpoJ14UeBkM6Iahfpf9UMHhsFP+WB7XXvbYtQnBSzbSHtBTGSB/EyvvV/taCKS7dYMYWZIQDNADVvCGuykUVwneqvqOqgCkXjOTrKqPf7jroLOUAwNxfU1zs8HcB3TZqFLDAJpUGKyQzMlkF5/I+ocOFvLcTFnJDTf5LGRAElaCcPGiq20pxmXpUpk7Tn4IPa1xvJN9ILvyHH/63JYkFC402Veia6g6jhfzeFUy2B8PcCj+GvMpfuD63T51bZvmTXBPcSN+T5zJqxietLLAFRFnjfK4MRQOUdYX8Op0q0mMG8o7FYL6RFhX9B6yAEND+RpipjVTy8YzLW4asAy0PXJpOsszHka0yfr/6KmBz899oUMMx4wulp7vjIohoJ4ShMnoSUE4MSOyHVV2GlyY26H0+7BHKxt9Sf9rnaudiGVi3bc7AKpdYl6W3HM5OA6zdD8ISa20N50MgvLyeFH+/H92ZABSPszbMbGqydqpkYlvZUeei0B5y2DRFwfhaDhCl6nlYsa0h8sVrlczCzd+AWZyQZNSnE4FTeNA0sOavtDGg0kjs6EL1/pAZUctrXC7kz8q1DpxMuZL1li2OFnehR7mgwDIvzPeXzuwDI151vjwv8ME9ZmNMwEMYH717fDlZO6eR6ARUTJK8rr/QT1rxq5HiPKNsoyMPwfHpIpYB/pcSOBJeBxCmrTKNEmKaDbQTgg9SX3mmk9qxbjtcFJ8kkjr5DVbDWRStN19gX5jQfTaTNRK7ErHP/3StpMkHQR8ym1eLi8SmfHob8LLppEuOhnXPPECB6vA9R/nDWRFEFLQsiHEUi3AXN9TmxMoHeeuPhKY7OGqH+NgaVVZO+0s256Ga0IPrBz+78VWuFCb+STIGwegLWLtyxx9S+NV1ceTZTMgJRgaY+CDv
 o58sj/8D
 nJDx+TMUecRaRum5Z1dZ+i/Kw2xJEj75G9nX4oVJ6GMV9GbQ3sskrM9INsj038C6ZFpktoDnAChkZvHYTCnPXaf1AhwjfNVGYqoesxBy2YAgxiYBEORGIuq8v9SjO3wgtux9wj3HSq2Fifs5CAsfCtC/zcPsP8EMpI/Zk8t9JQQcGTcKIGuAPeSdKRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 26-01-26 18:44:03, Roman Gushchin wrote:
>> This patchset adds an ability to customize the out of memory
>> handling using bpf.
>> 
>> It focuses on two parts:
>> 1) OOM handling policy,
>> 2) PSI-based OOM invocation.
>> 
>> The idea to use bpf for customizing the OOM handling is not new, but
>> unlike the previous proposal [1], which augmented the existing task
>> ranking policy, this one tries to be as generic as possible and
>> leverage the full power of the modern bpf.
>> 
>> It provides a generic interface which is called before the existing OOM
>> killer code and allows implementing any policy, e.g. picking a victim
>> task or memory cgroup or potentially even releasing memory in other
>> ways, e.g. deleting tmpfs files (the last one might require some
>> additional but relatively simple changes).
>
> Are you planning to write any highlevel documentation on how to use the
> existing infrastructure to implement proper/correct OOM handlers with
> these generic interfaces?

What do you expect from such a document, can you, please, elaborate?
I'm asking because the main promise of bpf is to provide some sort
of a safe playground, so anyone can experiment with writing their
bpf implementations (like sched_ext schedulers or bpf oom policies)
with minimum risk. Yes, it might work sub-optimally and kill too many
tasks, but it won't crash or deadlock the system.
So in way I don't want to prescribe the "right way" of writing
oom handler, but it totally makes sense to provide an example.

As of now the best way to get an example of a bpf handler is to look
into the commit "[PATCH bpf-next v3 12/17] bpf: selftests: BPF OOM
struct ops test".

Another viable idea (also suggested by Andrew Morton) is to develop
a production ready memcg-aware OOM killer in BPF, put the source code
into the kernel tree and make it loadable by default (obviously under a
config option). Myself or one of my colleagues will try to explore it a
bit later: the tricky part is this by-default loading because there are
no existing precedents.

Thanks!

