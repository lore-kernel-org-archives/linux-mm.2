Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE11CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A756B00B3; Tue, 16 Jun 2026 17:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51BAF6B00DD; Tue, 16 Jun 2026 17:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40ADD6B00B6; Tue, 16 Jun 2026 17:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 065A76B00DD
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:17:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18934164CCB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:38:42 +0000 (UTC)
X-FDA: 84886485684.13.577FDD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 448BB1A0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:38:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrAsnxec;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781631520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QK0WcBjuiKh3VFQfCN5accJY6l2Z8scVMqhkVQzP9qE=;
	b=TnAqFlYICET96yfP/NeKxPlQZZozoUxYI6/w/tD3GfliVTDQfoT6Kb2t++YphO2kkCSSZO
	n47gCrssLjEXzi/eLghg/CXvEm0nRAYTQHsL0fqrdw12PuE6vAiNpInRfRm2XTc8h7knS/
	11RRVQBtEYcecUXbb/8cNCvysnbnUcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781631520;
	b=j6YR6RvJIs/FvYojCc4x++DSDH9v+LgEoEVt6yKJPS9pTEBqAAa4XzTQz5xN0lVrrDo84t
	dcv9+FIpIxWyMI+sEzxHkEXSOe+7p6EXDHbeHZak0alQkNHsTO+xyGPeKJIburI7NDQLYK
	Wkg+IckNk3MRrDegugoKoEoVQZ1Lbug=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrAsnxec;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62FB2434B2;
	Tue, 16 Jun 2026 17:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9B71F00A3A;
	Tue, 16 Jun 2026 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781631517;
	bh=QK0WcBjuiKh3VFQfCN5accJY6l2Z8scVMqhkVQzP9qE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RrAsnxec8P54n6b6R6QwwiJZCip8IXfDNZr8JRBoLwAn20sgtgBr/zz+2WrtTT8aG
	 xpDj2IDsCQT6Ww2fGNeBd4+olS+MBwLhv8QkoRnKoIEL9cygOB2mlvdEbxhykCF+QO
	 q1t2UYpMDRL2pjjtDAAPY9MjM1yiTP26D+xOIPXypu0LfpsAipafDWlh4WRxhEE/xI
	 NIBC3Vr/Lk4et/QcuoWY3TyJxETAnn8WpTqhXDkknWPmEBgEZ/gZ9IQ6nId06TPoJA
	 yJLx5oQcs+Txw23vZ2pnzd95hrR9A9Vi1yuhlj+RzSKyyZ6DAPZQDCZ1ptpN50/6ht
	 WaZHZUJq4l2CQ==
Message-ID: <518ef286-9c33-4a9e-9d4f-3ed962b977ae@kernel.org>
Date: Tue, 16 Jun 2026 19:38:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 9/9] slub_kunit: extend the test for
 kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-9-70a54f3775bb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260615-kfree_rcu_nolock-v3-9-70a54f3775bb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 448BB1A0005
X-Stat-Signature: 3xhjw3wwj3xa5egct9qat6o8psc89bcp
X-HE-Tag: 1781631520-622642
X-HE-Meta: U2FsdGVkX1/j3ItrknPWA7l6u1IO1YJOUbfxt4Ti68LOPuAyDm7TdNRMXH7vJTA5nkPXGscS26ocQ9p4O3cWZS75GoY1qEDfGVp6FuRSPJsP3rEIEU3qxyw0ewDN4SbFvL7+YaNHd6tEpl39J1l+Wac+z30x6gqCYb9ec76wRnkx3ZJrspmFJAfHxlDAF4KiBYFv0uwUcDSVjDxnREN/SN96At11ETeKUES9WFPERoMTwrK0zs1WmwboyDMWFXySWaMFz054Bu9Bk7B1M8Hq6cCe/lnWrvXUSPn3ZBsyyQVCcL50QOLtYSY7FHfubiXcj3zE4s7a+bDIJxwBB574lpvvMRS58U4kP4vRpMkaN+1Dc9EDvAkJVo460ARPdv46JZ9hxSDeoiM9WTCGkNOb9c8dOHTxJqQgAFk2JKf5hA8QoWk9Th19sypzsowUgvGecnSKCHtvyL4e2ODnDwkouB+V5FTL1DnB5ENj3S85zpBrzGCrapZsK3cnUpkGT+Q4vTr6bxLyOCAFezu8hdVXaosyYOcuiGIW8O2LleycXBSvnt96vLwftV7BQTv2/0mxAjKVm0ptGpXs8vKnuf2melcxSa0OQfYUtLUyXUrhLI7+yC2eKC5to4BtmFydsWk9BZznF7vuKAcn2BSlJrwNMRS0AhIzaap7IQkLmYJcX6cvzXXwYUt/CJmrCglQ5uehqrzxL0rrQfGioq/rnWIzMLOIXPlFseEyL/LUFkFpU6jFVS7Z10JXNddA2oXdqB6eS9FBNXZOqvhY83Cu+LXegPBM/8O/uYxfjyJEHXHrKHD+TKS/+t9INVPWOhVIBdGWc8sbblp1JN/uJhKqVkGyFNTGe11UHunlatTWkC+4P4fCyZD9/3wQtYJFWUza31rqSyNq7TUIQv/3fbl8RsAWG1GoaFPh9HB4VcdotZ88PUvQY29AJlsCiMvMThpvLEzt8fxLMTKoMU+hgGDZt4X
 YshHAH9d
 YCW9MZxbrhxnDDg/Mr7Pt0dCx+8SC3ztPLES0Eao8Mm1YB8Z9Sq3nViRxfPpbr/Znf84bWg8njHT8/RLwl9rnl36pnXAXRTVrTmBAjWqpMRK0752ZKWJCCdIjfkR6ksR0oa4+pxe5QZ+O7hCj77jfez8oJFNKxZB/OgQ34QB7JLlJNVnrsg/+6e0VWTv3HQWAw2nnR3+MpChHoDgDanpXYkcpAS8d0soI9SMuP0QnazeGBcl9mKuDsEJKGRuEcimwpnjf3oL/e6MA6CIYSffQZGO1fKadTaF/gL6ZWICMgALSJPWMucq0mC1bxwiTK0NETzxMTZGroHijw2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
> When slub_kunit is not built-in, call kfree_rcu() and kfree_rcu_nolock()
> to test kfree_rcu_nolock() in slub_kunit.
> 
> Rename the test case as the test covers more _nolock() APIs.
> 
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


