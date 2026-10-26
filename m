Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE163606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QDYnBlVj
Received: by kanga.kvack.org (Postfix)
	id 8A3C86B05B8; Mon, 26 Oct 2026 08:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DB86B05B7; Mon, 26 Oct 2026 08:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A066B05B8; Mon, 26 Oct 2026 08:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C07C6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:35:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7CE1C070F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:35:57 +0000 (UTC)
X-FDA: 85364724354.30.B7CE282
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7E147180005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:35:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QDYnBlVj;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7EefUh3aqRq+/kXeTZJUHXPcDw8CBwlgMa4LUajmOY=;
	b=614j3C2UZrDmbQ04aYhnxyxHQFM1wIWvUxNJ1HxIN0EDOQanY2u3LYgiBUQiIv/Vk1Hr04
	haD27kiuTGXCAhyY6c9SjNVlXK+JFmxyiwl9db3l9cYOD9eNlSs9R0uG20Iuhesx7J7msa
	RXdoFBsFKZfi4Z1mzYHbk0tq/VT6gAM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QDYnBlVj;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793018155;
	b=i9tw+R8JDBbExlnZKh8lZx1QIMriBOPe9JWuBIQfAR32Q5TaHFaHcg2t3kHaUgceB2Z1IX
	uta6wyGX9xlad2lq/BAp3mXx/pEr3S5izjPBhBxmOBiQxvYSgehanFFiCN7foUHvWkF5UC
	kUyfI80S1+lyL6uFMfGP3fR5Glm5wZ4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=P4HvR1T1qWQJ8zvWY6aCuA2NNhAyIJqSmu7qznxYcdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793018154; v=1; x=1793622954;
 b=QDYnBlVjApUfVb32w5CMpG6fcutS3RlXBpwWR9XiQXVZUC+e7uI7/TcWUVsYf+tY3g0+6vM/
 ypyeq8TSPTvWOkU4fkRnEiyoq9E0lNqt8nlfltcBIHKN61C4wkdWp0sjHeXj5rTvqds0iAJd2ID
 4nUIefE0ECKycUHjLyRD1cyY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7e1874fcba217f36;
	Mon, 26 Oct 2026 12:35:53 +0000
X-Mizu-Trace-ID: 7e1874fcba217f36
X-Migadu-Flow: FLOW_OUT
Message-ID: <67e0c2ce-c763-4705-a965-1ca84898e438@linux.dev>
Date: Mon, 26 Oct 2026 20:35:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org, Pedro Falcato <pfalcato@suse.de>
References: <20261016065920.4153-1-lance.yang@linux.dev>
 <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
 <atICp2NL8j2z7UFM@pedro-suse.tail5790ac.ts.net>
 <atIiR1NWNssDvgt6@pedro-suse.tail5790ac.ts.net>
 <6a005d89-df5b-4524-a4b9-c637cb15f1ee@linux.alibaba.com>
 <cd6637db-7b30-4cbc-b07f-c2a2b32480fa@linux.dev>
 <b1b3d8d7-7201-4b75-a0f0-af383d854279@linux.alibaba.com>
 <3be96a1c-7cfb-4cd0-a4fb-16209494d041@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3be96a1c-7cfb-4cd0-a4fb-16209494d041@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E147180005
X-Stat-Signature: nn3jtmyxtf51acpwfh5g1uw4doowghwk
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793018155-226224
X-HE-Meta: U2FsdGVkX19yO/OSY4yKUH46K4Og+0dH5OAfPz0bGGsZuR8mgJ6GnstJWEYCbiVZY6Kyw3nmtbZPo64DQ//pc5W42Nvv9ecE323JU9YLK6Fnszp45yiwc9H8Yoo8CgyBhckYQE3nIi58byop05aKDVIenJfROJw5WUrlQOSkNfGa0DQYlP8+UEhSPy24XKt+6ntUBcxxSS5nKiekhBPTTp/cHQR0ZvPlthqFXpYdr3/TBmNb2s/eRaOR6n7qF8OjuYrI/QrMGBRTg5HbMXhCo/PoXY4+6ZWOW047UZVOAb8P/fue6fJWgYFlMtmWZOE32EVWB6eUxFfuOZhiF+OluiOEUNSwlSocernRMzCMoOWS4X+gy7H23m/tdWoK0ZOEv1IfuoMOAx93lnjEiLMkdGjBELJCHbSFV4Ioou8rN9VFXrpxXu+QA5bsaFlxuQ1qjJstHLQEYgOZ/LVbp0zrVolj8RQrHv9b+nY1WU5PSBPxfSeIYWOi9TPPrkcX72eqoEgVqGntZ3nYAGTe4dmnWOgGgEU5g3XpPufkMxKikpYL+IKp1nN+t2TPBqloDbbWHMAGAl0glfVotc3IZn+O8uvwtcvmVBgqIAgZSnoxrw+myWOj/Kdyy09JR04k4cr37YIUqItiKQ0/uHTxaU1l8a2J9Zh+m7fZQ51KrOHzOyqiZxYKQI/6Xg9jGOMsVbeGrloZU5axii+KFo0vLGUTKOLdMGWUZIfMz/EBv1RryKr2NpPR2JhQ9yB7xG9MhT9/mvkONyAnVjbBED+geDcO+WhesAKB+RPau9vaC/GtAUWfWTNM9EaEdrJAi4sRbvyRirKldUJEMP3/uyI57/i09kA3zTZvbijiQ3KVelsY7/i18bKiVRdb9yDYQLGLX9WTxZ7iMGySwzDAyibiL6oKdGX93R8FMwRNwgkyUdR1G86pDoOjkXJNH3qtnGzDtHChOrQ53nfoFT6WR7PBxGQ
 wDvYq9Pf
 CnlP9azhxJdSsylpwJhTlGh91+kuN5gHauJwNdJQPvFNnKLjuu0oL/E4Rh5vbohyerC5Sq4amQ8Sa3aF1OLPq54emBwweFbkoiXmxYf3iQ1r2Je5w9/+J7jSk1ErIam98qaWOmauzySPYWn2vj1SzPvHYt43xrk9GLK3K/ChIACOQ24gjzLmGtDOdIpoAcR2DHl2kvQCmz69nySo0gG0HHFqVdvgbWkLBzl1tBEhw/Mr7WZaLUjIfCFxkVFJI0EGNP4841JMgkYvIoEDkTxZZk8xFDVB4HdcBcNMw5n75HZFOOpc3I16WmNzrr4l+3SzbEUir9qIKn5R2SH+YIvOsnendvMlLQ5thY7wGtCFg64qd3wnMCCl/RKYfrvQo92RBVqa9P9MR6ID+5KfvKls1eCyZ9fpoQkcEcaqlYDp44HjJxlqWPoidHJzv25CeQCZ6thOFf3z13lRKlMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/26 19:26, David Hildenbrand (Arm) wrote:
> On 10/18/26 04:47, Baolin Wang wrote:
>>
>>
>> On 10/17/26 3:41 PM, Lance Yang wrote:
>>>
>>>
>>> On 2026/10/17 13:43, Baolin Wang wrote:
>>>>
>>>>
>>>>
>>>> OK.
>>>>
>>>>
>>>> Sounds good.
>>>>
>>>>
>>>> But why not add RA logic in collapse_pmd(), as we do for
>>>> SCAN_PAGE_DIRTY_OR_WRITEBACK? There's already retry logic there, and this
>>>> would also simplify the long collapse_file().
>>>
>>> That would be cleaner, yeah. Some older stable trees don't have that
>>> outer retry loop, though ... I'd prefer to get the fix backported first,
>>> then move the RA/retry logic out in a follow-up, wdyt?
>>
>> IIRC, the approach to bug fixes is to fix bugs properly and cleanly for
>> upstream, without being constrained by backporting requirements.
>>
>> Anyway, I don't have a strong opinion on this. Let's also see what David prefers.
> 
> Let's get this fixed in a acceptable way in a reasonable timeframe; it's been
> broken for too long. ... and follow up with bigger cleanups later.
> 
> @Lance is this version good to review for that purpose or are you planning a resend?

Right, as for the bigger cleanup, that can come later. Will resend the 
current version as-is :)


