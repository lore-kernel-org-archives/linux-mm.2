Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B599C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567656B0088; Mon, 20 Jul 2026 04:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E9D6B0092; Mon, 20 Jul 2026 04:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454356B0093; Mon, 20 Jul 2026 04:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9666B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:02:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DC9B807B2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:02:29 +0000 (UTC)
X-FDA: 85008412818.01.E2284A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A3AF9100008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:02:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R71isxJP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784534547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQ77o9wiEXBxH/ExlbH5P0bZkq1tD1nMMK/F8/u/Cg4=;
	b=frAPZygmW0IQqV5z2PGTopEStbESA+KbPtAL1t6pdxQ11P/pepBp62Ctv4AypiCE5EkYrD
	2U0WJCcvCgjCdyO9g9Vi16RGr0OaCslbRVdzGO68LBceOtr5M0ifR+VJQv4DMJVpN147rr
	UkDRQysfqeR8+96nABTXIkHyi1A4uhQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R71isxJP;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784534547;
	b=rV/YNrn4Ient7Xdf7cYrMKfJYiRhdT7Qv0owYCuexYp5HQx68TbbsRGVYf6lbuoRjEFJqH
	y/VzahREjt0TqU4XmIbdT/JyBF62j78TbvBnU26//TUnENLEwGbWF9hb1xNynRnekgwt+b
	ImrkQXDlv2gK3Ut2CCbfukVhqe5f8Mk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBFE740A9B;
	Mon, 20 Jul 2026 08:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E8A1F000E9;
	Mon, 20 Jul 2026 08:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784534546;
	bh=RQ77o9wiEXBxH/ExlbH5P0bZkq1tD1nMMK/F8/u/Cg4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R71isxJPQ/OTjpr4geErllAEM0L7sdpYyMmdyywpKcCPXSBYsLayO3DMyJab+V92Q
	 m/QKP36IvakrXNcXR33fB+aJvLUxqUTd1FV+sL3iJLncbeLAk5XyCaYXO7qdW/KrDA
	 CJuia/ETfMsoVDBIddpB/PtknpGoWt+oKeuH++6HIpC2d+pGqkzNWfRpoBXgggaxus
	 HUYAI2DS3V8gbmA9juQsxCgXcieHUhyW2AZ1V9zqkarHhFt7l/MQJ6CX8Secn+Ad8k
	 4aWDHGqeSbzvJpAp1ARTaGSN7Wj/2e4ph9wlK/IWq8fUggR0avVYiwPq7KmiiB/vrI
	 5GbtuTLKuBzNA==
Message-ID: <4d4fbb2b-dfef-4228-9e9f-f967aec4dfd7@kernel.org>
Date: Mon, 20 Jul 2026 09:02:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
To: Nadia Chambers <nadia.yvette.chambers@ik.me>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org> <al0xogLqubAZh6SD@ik.me>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <al0xogLqubAZh6SD@ik.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3AF9100008
X-Stat-Signature: 3omn3uf13tadun3up456hcxus3gpw9hx
X-HE-Tag: 1784534547-235930
X-HE-Meta: U2FsdGVkX19gU3e7hCFWDy3yaBiXb6coyZ6xAAUT1Diirxd+p++d5fxSZgBdH1EIuRuDsd0d0glU8N6ireMpFk+Qq3RCJq9/bJgvPB4LJlWLlJu6Fz2XBMTyTQlTdXWWJTkGj7fHzexC9zzkYzvAObnIc7kA2ltGiakR7hYV1dpSVkwjfJxrtWid2yd2P8BN/ymx34+rlBKVGqPG4jHPQTf1SpmUnAS2KD2hJnZJENKkJqKJPd2tJSl+LHergNtaEiBUdRQW+YB0ShbOjsRpvejI+LEh4pITW+5/30A2Ro/ibK2RXhiqK8YbEP2165YH3+pb3a+zL5L7r8I6NWAuR81biAIl3GoNBdzI3zagNYRI+XXDJpqIQrjtsFUPpHUHv28IyHOdgJbzII0vi7WHJ2YFT06JNn/OV+gGQJ3c3HtdaINz6iVznm/ZdjDO01VHNlimjxHyJ933dFs+ztK/a+ETpVrKirv/KA+FkTarhE/0zVu8ex5Ilci9fo3/IlT9camTQxlZGm6VlTxoxvbm3O4ZSGo117qC36S2w80r6JRMpmm76Zf5q0sD47vqe9QHeytA+AlgkLkhgpmmY1fNrS+NcctXwL3fnHPohzXoJ+TQjnGOS3VguZRM18qj+gF7XrJlGByOzcKvXUD4m9IzeXgNpPgU9qLm/IjzYq6ahZj/zZ6DCgIdHMpExeROyEPDgmGa6opvyhyYBM4bon+pSEjABEf+Gbw3AD645DSSD7tRduSFqLZGGb1Vebv/ikOsv3XysGS2kZoT6x5cVzqnZoRwTWZnp+m2Ezoq7+7x/KgT51glkR15y5Kkpv4JE7SkRytHhiOxbaeSrVhtVs9eKBjjDOSQAzYaRKu2c002r4Jw+bpviwWx//w7OI/JuiGGUWhVO34keZS+OPINGCHwaN//oGqZABAJc0mN6SHh6tQ8iMaEf0JBT4TMrFvgJIN4YD0Hxiuh5ziTghbdMbm
 bLSgo/o0
 DFDua9zJTSHHnOpwscOoZ9Nkb+9GM0YYZ+PExcKsXFoCy5O5WWGrf1muqAcdMyVzqjqz1qBo7XLsonrbYbys6yB+dU8DOyP3DzioSVTMQfq6QMt85auXo5b8p/HjJiW74J62ETuz6aKlufESFXJ+8+n4RVjrO3Tts25knx1B0f23Hyo8Z46u/xd95ptIqG8DVqDwlJXtpzojptxfPDyjSYyFk8pO6M5VsgZ/bs+/bVf7eJrxV8tzr5jmy9ToT3Q2129jAgH4Nje7SfPoipPrvDLOdPBpZsYX0CL1P30zTmwlHkU0pG3exYTrbacwsyreqiy1hNbr+sEbaaBD6sYL4cibmmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/19/26 23:24, Nadia Chambers wrote:
> Am Fr, Feb 20, 2026 um 11:24:37 +0100, David Hildenbrand (Arm) schrieb:
>> Right, see the proposal from Dev on the list.
>> From user-space POV, the pagesize would be 64K for these emulated processes.
>> That is, VMAs must be suitable aligned etc.
>> One key thing I think is that you could run such emulated-64k process (that
>> actually support it!) with 4k processes on the same machine, like Arm is
>> considering.
>> You would have no weird "vma crosses base pages" handling, which is just
>> rather nasty and makes my head hurt.
> 
> While it had to be written, it was a straightforward extension of
> converting ->vm_pgoff to being in MMUPAGE_SIZE (Kiryl's PTE_SIZE) units,
> recovering offsets into pages usw. Nothing seemed terribly hard to
> understand about it. Really, the code as it stands rarely approaches
> what it's doing in such a way that it broadly surveys the layout of vmas
> and pages and be conscious of whether pages spanned vmas or multiple
> vmas were representing maps of of fragments of pages, so I'm not
> convinced there's anything particularly unique to be afraid of here.

Just to be clear: I don't want this.

-- 
Cheers,

David

