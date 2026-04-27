Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310EDFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928596B00B4; Mon, 27 Apr 2026 14:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2896B00B5; Mon, 27 Apr 2026 14:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80FA26B00B6; Mon, 27 Apr 2026 14:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7010D6B00B4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:08:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 358F0A024B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:08:58 +0000 (UTC)
X-FDA: 84705121956.04.5035C14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6FFDB180016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:08:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P8hM/Sjp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313336; a=rsa-sha256;
	cv=none;
	b=6QYsH4caOF3+RkFHDYlkGvmIInlbGlGhmKsXC3q/8tDDvOlhusdLrUHM3cZQVioCth5Zb8
	Imci/GfPrllMYUvcjf6v5wMjGpdh3AturGHiINgEaHAtcjLKLUZunc4a7KsFyydYSCJNvV
	Z2ttsdH0C65aLGjq1kGQgjm307+iMiU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P8hM/Sjp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JV9msU68Kqn9Kac+/qrG3VH+3nVtTVNE70p9bH49Xj0=;
	b=nnv9VTyHRKd99Bvxj1PHicrvdnsE2pWe+USGMxWq5qT7k8CWvCjIehhM4TNvuH8tpRr41P
	7Cc4xAJfU/iXozyVWorflvvXjVkspThpzqlCu1g4xJBZpLXPI24HtDaaDGrLpsTIlSz4WA
	vM/V0iBwMivoT1I2rBk+NOjEwxXfbpQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A1DC4472B;
	Mon, 27 Apr 2026 18:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCE1C2BCB5;
	Mon, 27 Apr 2026 18:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313329;
	bh=kMOnCgiX7WpVxs78xhcWlnKUzjZBk7mOuOAbAYfMhT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P8hM/SjpmKKZKJmglT7pAVfcHAU86kTR4se4kSUPHgn4/oZsyXSrw+osYDOr2t293
	 EIX1T9Zmwf8dZMAtX6WuHQgFG5aCkfIcJhY0NChlGYniVvZ0+cqEtVROdncgq5F2Cv
	 YhxOVohQ8Hysn9YyL5kbDU9Cwi6v5y2lKTlWwnH28nUMIP2HeFfUa5pcYHAiUCSqJ1
	 d3/MFY7RjFycpYB41K++kqc+aCsborMtRhb+Q6eo16w9IGyy5er+46OiuDDg7rXrfM
	 x+NsyF81dcltR1PleYs7YA+Hjw/qjvw/8ulDX+/09+j58tA9GPpKTXBJCXR+5lgQQX
	 03eTQsbitHNTw==
Message-ID: <7526f30a-a008-49bc-a064-07f4e4a7920b@kernel.org>
Date: Mon, 27 Apr 2026 20:08:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, "Paul E . McKenney"
 <paulmck@kernel.org>, Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Zqiang <qiang.zhang@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org> <aejeVK0J_jHSfVhD@milan>
 <aelxH--hZkCahPv6@hyeyoo> <ael8R0vOeZ0Xbcoe@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ael8R0vOeZ0Xbcoe@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f3qajgtd93rwfe87b6jggceusn1se3df
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FFDB180016
X-Rspamd-Server: rspam07
X-HE-Tag: 1777313335-636836
X-HE-Meta: U2FsdGVkX1/MI69akCYVF9NDQsCmQJJELx6S6N5pg4x46T77mbWIoUg682+suPglRvPN16mAehikO+ainwVtrcMbVvmxa8/WpQCdXsOFUw4AxwuNT67CftrR8Sn2pOSkeo0opD1rWYaU2jhVw16audFBhlyQzyjzclWHUPn1/5C/Zqjm9GulWcBadLHn5CL4YYaQzsScVNbDt9uSkV7U0uZBxSSFHYObEcJaeM0DAy11eyBZXrLwzOm/mLcP8PWEQu9KkjKQgEaxbgNYjIaCPXYHzpyIGpnaoawGa3D1FwIiWC40AW5J30NwpowNjHlyrzWPeE/3YZvdPjZeHIYfs8up9gpP1knzazJJHI8GQyCcRxWV204dNDGCce8otErsk39YZZ0893/PcQCHyL1Jn1mi6anZpOS620jEZ6SWAuQM/cD+va5CIcbE5jhkw8hkP9+HgmfhJIAFqKiPWFc/s7ixKi1EiC6r81/LX++JtRX7mde+O3G7kRDX5mkHeHRuLLTzr8Xwv/ni1W4PoGCq3DjIYtJAgeteyWdQm2PntLW3MQRUYVuRwaQqXTO/KgMmUdWQTO5BmcjbSXKhpTCwf6CJa+zWwfK10HUIVHQAh9ASKwPYjGgky8IRPG92h87vbGQR4dnWQXO/XTWRAYj9RB9CgM5P0UHZtw6ktFJqV6hvTVKafvB+fHg4AYaaS2X7+RVn7aYSCOpMJooUMYlozQYVczJcf9ARYF8Z4F9yK/HxBKnUPL4AYMaGE/LDbj7vtH/dlYoDcgLxndt9TNDD96brRnw4FrQf4VjV0S36QrSuntFO9LhXO6VwyMFUXeibemAt/m18xLyQnMnqcLPb4R9JGrV3kerP0yK4FQM/jRrzW0pba1L0ilnKxyS5O12UetCU6v5zzM46UfkKsb89gtrZnyg0gmpoxQOhaZU+Seeg/9Dyx/O7ggKC3Y5tZ5ne7roSI8aFdfIhxeuuP7e
 IiuryNIQ
 lnoslTcq7kX9g3Sv2lIb/H7NCZDCRwGmkLQUWbidyxqiTmDsoc1fMoexSdGQxtRnQfzcz6hd8O8Ta4+Q5gNqy+4F/tNimPmz+octwhxzSEaogRFA8sLO16xnEy54aTm27gGMHqF36ucijvE50sgM0jlAMDsnxAAD2CwEw2qMjzHiwMBTfnyUEqS80fLKPLFa2A81kfwwLMuJX/3AAHd99VGDv6KQMADjkBV6PtwTJeAViKO4r7YsdF09khupaVZYjQ/YO044htzzFiDZgs9xfDvzlNaVh7mDc+vk8BcVxI+nT3YxLzMxXo6Bn6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 03:56, Harry Yoo (Oracle) wrote:
> On Thu, Apr 23, 2026 at 10:08:49AM +0900, Harry Yoo (Oracle) wrote:
>> On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
>> > On Thu, Apr 16, 2026 at 06:10:18PM +0900, Harry Yoo (Oracle) wrote:
>> > As discussed or noted earlier, having third argument and check the
>> > entire path with "if (allow_spin)" is not optimal and is not good
>> > approach. I do not think it this would be a good fit for mainline.
>> 
>> I understand that this pattern is pretty uncommon and adds complexity.
>> But there is a reason why we're doing this. As Alexei pointed out
>> earlier, even rare spikes of irq_work hurt performance [1]; that can be
>> avoided in most cases where the lock is not in use. That's why buddy [2]
>> and slab [3] accepted this pattern despite the added complexity?
> 
> Perhaps we can avoid complicating existing kvfree_rcu batching
> (and still avoid hurting performance).
> 
> Given that kfree_rcu_nolock() (at least BPF) doesn't need to free
> vmalloc objects, we can make kfree_rcu_sheaf() handle most of frees
> (slab already knows how to handle allow_spin = false) and fall back to
> a simple irq_work as Ulad suggested.
> 
> But then we need to make kfree_rcu_sheaf() try harder (currently it
> gives up when it fails to get an empty sheaf from the barn).

Yeah, if there's a burst of kfree_rcu_nolock() calls, it might exhaust that.

> And I guess the tricky part is making kfree_rcu_sheaf() work on RT ;)

I hope we're close to that, as discussed on patch 5/8 :)


