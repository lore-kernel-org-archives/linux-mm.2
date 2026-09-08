Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20798C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379C46B0093; Tue,  8 Sep 2026 13:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32A556B0095; Tue,  8 Sep 2026 13:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2196B6B0096; Tue,  8 Sep 2026 13:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAC886B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:01:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8478840759
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:01:44 +0000 (UTC)
X-FDA: 85191211728.08.573624F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A09218000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:01:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AVasrZJM;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788886902;
	b=gPhu6IMCvCIDk7T6Ntx2tGrtqSLyvjYxeq7apcZcQP/KQR8bi5NF3A/uzf0kSmeKMvChhx
	BOzf0/MlLMlJCzEPyXnFoyf3M/AcOPNFxcct/n7kTO1cvb5RXZUZYfXMlKk13FbefAQ4em
	Idpavy0bTuZbXracUDVDmfQqn85MVRM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AVasrZJM;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788886902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpOLqlPcDO47qMEObdSzJgSUyyr14SBoK5kf+Jx3cQE=;
	b=gaIXuh44RMnhSs3+sYTFWMtaoGe6d8Ifn4lMrm3vS+4DyN2Zt0jFbmM0LPgxO+UJ9JCEBs
	B3Ts+XHo1llqPeZHZIn0FRUCrMNYVlQRePioR3VqVM8eqJjWIsItvjiKAyx07EbFjn9Pwn
	EQig6tXZ+EXZHeP8DHEzjKczMU1xjjY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D51C54170F;
	Tue,  8 Sep 2026 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02861F00A3A;
	Tue,  8 Sep 2026 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886901;
	bh=fpOLqlPcDO47qMEObdSzJgSUyyr14SBoK5kf+Jx3cQE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AVasrZJMODvysNCxLvWh47u70+aXuUook7hkAT/PHKUCxr5NKeZwLBsJoJoAz/Jms
	 OyNp1fk8GNfdhlDyCVl9mtcKdPW7xzgU0ekTs5Ve/qwyuuwZC8YHVdl2/lHxQ1yhuC
	 UD6CakEPWQEC1g1MMZ4EVlYOZ1w9LrTMUiBN+81p0S2jVN2cveWTE4gk8U/07qeIFL
	 mfdk7V/+Gl5msCexZh2t4qLL7wRnz6yljZ3dSmumccqs+Z9hVpR/UQYGFoTJSLAX+u
	 TruBM2ioj6A2MAXUasdpZx2pYK8DcX2YJpmvS458JVk9sj7G7v2Hx5KIAMitPoB1f/
	 6QEz4gvVhZt0w==
Message-ID: <e5aa6ce8-9691-44ca-b655-670c192292a2@kernel.org>
Date: Tue, 8 Sep 2026 19:01:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/14] treewide: remove folio_set/clear_private()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Jan Kara <jack@suse.cz>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, linux-nfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-11-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-11-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A09218000F
X-Stat-Signature: jnqkcw7tjuzgb76ga53cxnisgt4x1bpc
X-Rspam-User: 
X-HE-Tag: 1788886902-958578
X-HE-Meta: U2FsdGVkX1+GpTWSmBZRsVewpCLu+q884PqrFxNzAz8KfwDXwFP809XEanIsaI7KE9tXEh7AA/clTsFEw1MUHtM73htEkBHImjFvSOx+5jcTEU0QmCb2C7Rb7Hp98Th75ulsOIb+OsII2iWjO5NFXn/bM4dPSEHdISO11BtntQXnxB8DX//qbNRjZQ5fzvbhwXzWmEcsegFlBengi1E0Ad6o8hOoZPs+U7Bynig4ZvPve4OSdOQNqDJKdIAtyb2sOHywcMrht0yjDbKBiY6Txru4SkJNLlNUpnHLrCRBWqBJ938yD/lUQun1V5Gd6w5XsGZQGge22T8wBpdsA1w2se3W/rwvNwJqiJoYTvaGGfzqaDnIoTDotoVUI7E9FHcCDHrnUy/ko4tUEOiJotiX+zbRSB+fNPVdARUBkafebd0J+oKy0ZbnB9Wxr887kZqIQH0ZihpJrIBtkl/ejEmQsCflMlczU1CR0qy6TEcs36lqMaszFlW/fJlkjhuQaAwfd2InPIaDfToWjAxdn/IGe5gkSdB1jDsG+QY8jfNo1oaEN9CBdSwpckYtoQa55yD0kNzDlDhgfTA3A0EyEiiLVq85QkQUbMXywh6sYB2HNP7qsSCljf9zqvlj710dP1ioTelVhxaCT18juGyGsbwj946JfxqvGW43CqZZUEztRJWN6Ks48CIH7EOMElBtJRK/LyPQ1aLVbqEw5Vj+aBtpMslPC1t1GIyB1FApfCGJdVqww63LyUzNoZIVOFQXuqZGPIsP5B/q0ydqwCauyNOFYk0CvCcYBtbWd0XFjlZNGVYIHECgw0NdtVx71s9RfgARyxXbEvUaGIMFrG4AZBUEWcPwoK/sIZgffC10832lbe2sLWaKBF5SmBcRxrmoy0KNj9mGgLf9YLfRujc273xmrhxB1FODi5vbaDajjnxFPFB0QCAOH8+bj2crZKH/fMdWieft9fXM+A3igE7Dtui
 Oo95pBMk
 UZplrzr90kO/ngDB++ONAGBlrig40iVcdDUrpBRYI2+WmAy7jT2R9CPt9L+XXnE5nX82sDGBR87Hf6b8cSc0c/U5oOb+H/gJ9SCiV/rKwmbuu/mqSpxXO8qMVPZMl8UtO1dF8tPTJEStFMyjLNZBr7lhrILq302jgW7l9M6bFhiDVF0O9448zjM05wOlPgRcUVliJ9zXF5hPScgu5DF8uSzCszl4a5DPjSJV1TWjkFhLBf6uCVCGqlMSNnuYY2l4aZT39BVDxBiB/NcUw+jftFwxltmKPzqEPV2rtniEfgZI6DDI+/imK4N8xnl5/sR9esHbgrcZi7lZrwlGKVnveTxroJOq/5vqS0Y1ufp4L48CS4Hirdj2XJyJfNvTp3b0S28rYqCfdpvIr1ictehmAZzyDiHetuyZCmtxN23ni6Ps5RxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> They are no-ops now. Remove them.

Subject should likel y say that you remove folio_set/clear_private() *usage*.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

