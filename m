Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B4C606A625
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD466B05B1; Fri, 30 Oct 2026 06:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4F96B05B3; Fri, 30 Oct 2026 06:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F332E6B05B4; Fri, 30 Oct 2026 06:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3F266B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:37:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7927A82E2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:37:30 +0000 (UTC)
X-FDA: 85378941060.16.98BBAC7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id A455040004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:37:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793356648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3+tGrQUgqt3jvWBD9zjeghzoD0fUBi5yiSERvvU1W4I=;
	b=8fYpmb8h3nnwj5HAJn5ao4d83ea1IebDRA+U6+7ON2pxj+j26AoDS0taZ/6d9GTKU8qvZm
	H96z5kPA5yFMtvcvIj3rNrrSY2ICBanz30t8FR7WmCwzynPSVupQI7glSoYvhCmBrB5SSa
	EkNL0jKNeUE/aYf4n3yXn0dnYdxIr24=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793356648;
	b=MJ0gAmFwELwhFXVZy7Tec5ROao2YdN2UhKYPrkbgRuo2jqHKgU6KcMRfmsPe5jdo0aXZv5
	SRX1PCxAbf0tKD1VLyu4iKNv9Ih8RG0oE5sTObUILMLjtuC+WRyCbes7+5gPVmUKD8HzSb
	gqnXb+JLSfqjicHnu5eW2mZ2A3xKV5Y=
X-UUID: e1d5617cd44d11f19a56ed5b684f684d-20261030
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:0050466b-9e8b-475d-8eca-8bddcd04520c,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:74927232b5489653969c8df4999435f1,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|136|865|898,TC:nil,Content:0|15|52
	|99,EDM:-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e1d5617cd44d11f19a56ed5b684f684d-20261030
X-User: wangxuewen@kylinos.cn
Received: from [172.30.70.102] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1057454557; Fri, 30 Oct 2026 18:37:19 +0800
Message-ID: <1db65746-7af3-444c-92c0-32019bbfd937@kylinos.cn>
Date: Fri, 30 Oct 2026 18:37:16 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: trace swapin results and order fallbacks
To: Steven Rostedt <rostedt@goodmis.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, corbet@lwn.net, skhan@linuxfoundation.org,
 rdunlap@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, wangxuewen_ky@163.com
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
 <20261027094014.2432692-2-wangxuewen@kylinos.cn>
 <20261029103615.31dff835@gandalf.local.home>
From: wangxuewen <wangxuewen@kylinos.cn>
In-Reply-To: <20261029103615.31dff835@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A455040004
X-Stat-Signature: 3x3wdhywf9y4ymt4f68oh8qsh94dnbir
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793356645-360093
X-HE-Meta: U2FsdGVkX18pKMqEeixDMZLWFfbxtRpJIR23nxovrEJiKHAA6q8XQ0c2wxcd45X2TFSLWybNOz4OHYb2Dn3G6FTcqYc5aQYxwJ6WNa3/LEXjBTiTVqUiG8nzD10loXXqlPdnzfdcDeJCPpZK/oNpgE1oeAI5l5ktu431p1UG3n9xDT7TplsMAC7Z4QYc2k7S5fWOwWRfD9/B2ruxT8uetD4E1ohzerlcWfzbJE4eNfoe+veKiFOjXOQLAmD2Oz6rqW8hRkh3f0yHpPa+TusBmkH8LfGUvpd/eqwltGoctVcxYvm2nkEzG+wTaMpri8VRD6oP8mCjZ0AxpxB05U81lU091YqauU8I9Hfo8qg4UIHdUKCcETztzcsGVmGeTdGVklm9p6YCd9S/ejLYvNzZQqnQK5fD93iObyeddY0+G8PY1ar6C1m/uXQ0zRLX2/veggbnvRBbs17ycnqq1tWlRvdsSC2Y2ivU2GKH+82FjgQWUxb2mLIYu6kRShL21JwfejnWdUhOaaaj2GdyiPpb1w8nXQ8S0W+dWw3auvN1ds0a7hHEdgoRRENKj9E+jW+SisBi63MtPlPoMjeA2eT/Tid4O6RJ7eNGu/oDMa/mNepw1K6hlksqs2iycUSfFyVhUsmRZ+cgrSut51WBqkqYfbCqzu59LU0QiFuVChW95j60lFOE0j8zpYU6Vflu7z+VSM7++UiMwot7g1lNInhgIHe6wkVFNSt4vbVQ+LivaqjYhF4kyabbOmsy9Zm3o+QbdguU1IkCG1BPfr179tbQpYP46udFrR15oyZ7cNI9HssFA0ddH+nTgyTCNkZrgXQM9ngWIJ46+vPnPtnDS9JBUd6cxw/FL7WGKfbLBTTjLoQIqJGA/+edwl6wBenOPLels3jQRRQu4/rubeRwJNhmJSZhqabHY+PoncE1p8eZycTWpjbxWUZP8UAhAuilqK4ymEWAGFbL75pEa7YOYY+
 AUni1doN
 gBZagrDGGOlrLURwz4AOMl4Isdqm0euGYqog4QR/aaKX03HTPJH+4neZnB81cY2W1+hEDLYob0v9oRIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Steve,

Thank you for your review. I agree with you. The current field layout 
introduces padding holes on 64-bit systems. I'll rearrange the structure 
in v2, grouping long fields at the front and smaller integer fields 
after, to reduce ring buffer memory overhead.

Best regards,
Xuewen

在 2026/10/29 22:36, Steven Rostedt 写道:
> On Tue, 27 Oct 2026 17:40:13 +0800
> Xuewen Wang <wangxuewen@kylinos.cn> wrote:
> 
>> +TRACE_EVENT(shmem_swapin_folio,
>> +
>> +	TP_PROTO(struct inode *inode, pgoff_t index,
>> +		 unsigned int entry_type, pgoff_t entry_offset,
>> +		 int requested_order, int actual_order, unsigned int path,
>> +		 unsigned int fallback, int fallback_error, int error),
>> +
>> +	TP_ARGS(inode, index, entry_type, entry_offset, requested_order,
>> +		actual_order, path, fallback, fallback_error, error),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(dev_t, dev)
>> +		__field(unsigned long, ino)
>> +		__field(unsigned long, index)
>> +		__field(unsigned int, entry_type)
>> +		__field(unsigned long, entry_offset)
>> +		__field(int, requested_order)
>> +		__field(int, actual_order)
>> +		__field(unsigned int, path)
>> +		__field(unsigned int, fallback)
>> +		__field(int, fallback_error)
>> +		__field(int, error)
> 
> There's a lot of holes in the above structure.
> 
> dev_t is 4 bytes in size, which means you have a 4 byte hole between that
> and the ino (on 64 bit machines).
> 
> And another 4 byte hole between entry_type and entry_offset.
> 
> Move the longs to the beginning and the ints after that. The order of the
> structure isn't important for the output, but is important for saving ring
> buffer space.
> 
> -- Steve
> 
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->dev = inode->i_sb->s_dev;
>> +		__entry->ino = inode->i_ino;
>> +		__entry->index = index;
>> +		__entry->entry_type = entry_type;
>> +		__entry->entry_offset = entry_offset;
>> +		__entry->requested_order = requested_order;
>> +		__entry->actual_order = actual_order;
>> +		__entry->path = path;
>> +		__entry->fallback = fallback;
>> +		__entry->fallback_error = fallback_error;
>> +		__entry->error = error;
>> +	),
>> +
>> +	TP_printk("dev=%d:%d ino=%lu index=%lu entry=%u:%lu requested_order=%d actual_order=%d path=%s fallback=%s fallback_error=%d error=%d",
>> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
>> +		  __entry->ino, __entry->index,
>> +		  __entry->entry_type, __entry->entry_offset,
>> +		  __entry->requested_order, __entry->actual_order,
>> +		  __print_symbolic(__entry->path,
>> +				   { SHMEM_SWAPIN_LOOKUP, "lookup" },
>> +				   { SHMEM_SWAPIN_CACHE, "cache" },
>> +				   { SHMEM_SWAPIN_SYNC, "sync" },
>> +				   { SHMEM_SWAPIN_READAHEAD, "readahead" },
>> +				   { SHMEM_SWAPIN_POISON, "poison" }),
>> +		  show_shmem_swapin_fallback(__entry->fallback),
>> +		  __entry->fallback_error, __entry->error)
>> +);
>> +
>> +#endif /* _TRACE_SHMEM_H */
>> +
>> +/* This part must be outside protection */
>> +#include <trace/define_trace.h>


