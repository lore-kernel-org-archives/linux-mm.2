Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE38E9A76D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E65E6B0089; Tue, 24 Mar 2026 07:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297A06B008C; Tue, 24 Mar 2026 07:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD456B0092; Tue, 24 Mar 2026 07:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1396B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:17:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6BB81A1A52
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:17:33 +0000 (UTC)
X-FDA: 84580705986.07.BA83A13
Received: from sender-pp-o93.zoho.in (sender-pp-o93.zoho.in [103.117.158.93])
	by imf25.hostedemail.com (Postfix) with ESMTP id F1041A0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:17:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uvp0vRqX;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7tXGynYfsSDKkcbLDDxpKOQD7Ln9t/0BxLua48ck+w=;
	b=u5R+ACi/UxQ3WUupZMMNjIA++N6Dc6htP4ZYZN59cx9HmrnxpqbFTci6ZDg/pjgcXV97MU
	gzBMbnP2NDdkZd65CUxYyo/8feu0ReWh9rs5H/6SVY7q9U4AIpqdTDlXbJR+xDi7v5JM9u
	/T7bTkKfl8P/A4WwPZdRtdwhySHaMV4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uvp0vRqX;
	spf=pass (imf25.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.93 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774351051; a=rsa-sha256;
	cv=pass;
	b=njHso6wGv1u7ohbmMQm9YaO1OzHAsQ6FjNb+42fX+ZtRuGrBgqxWEElNxzOMfRHvkXbKnz
	H/+UrOnQrfNF980gPlwMG8fnXZ8APSF1c4gaY9Rerz9xGkE+/jyq3CVxKQOFEuTLvrpRgN
	fYK8qC61pE0M31LqvkCrcVx4IdM8B8s=
ARC-Seal: i=1; a=rsa-sha256; t=1774351027; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=BsH6a0cK+Y9bImB3qFB8RO7nIrQ5rcTuoGUEYfJJlrE3h/gayI6JSefmFbBXTDVP6oCO94jyTWuGtLORC/PTLxiiQTCc3Jt4CrP4i+KRpFxW+OsC3AjgeaEAh8QaNOG8wP+HRqCFTGw/s1e1w0Drpr7WupFjmcboXya9fwHF6F8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1774351027; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=p7tXGynYfsSDKkcbLDDxpKOQD7Ln9t/0BxLua48ck+w=; 
	b=QN0ShOKWI9mHffzDMxyKC1yyBr/UR6ZFGaB2O/e0ju86DVrmw0t01EdIYAp63NttpgpSafcRqJp88alZKVuvosgeZDwAH3Ugu6R+S//pnYtmSbG3FyCVqvXocW76MMvE5JvXFPyrHyrimGehqmfdf1kuONl5lkXSv89kbKfiP4w=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774351027;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=p7tXGynYfsSDKkcbLDDxpKOQD7Ln9t/0BxLua48ck+w=;
	b=uvp0vRqXrEvxIyZ1cw9UjEPzoN8zsWeGOb6jo80SY5l1m1t2gE+tsgf8swvrzFUj
	v1HjHafM/9bAPcMEE0Jq6ucGTTAANb4RVWNgLzvDveTPcQ0nCmGJUS53zLnm0CK/tUV
	AXDGZr/QX7+x17Jwp5WQqnJJLbWSn+1kCsH4NxUs=
Received: by mx.zoho.in with SMTPS id 1774351024876793.8419221470616;
	Tue, 24 Mar 2026 16:47:04 +0530 (IST)
Message-ID: <9bf5d3f5-af3f-40ce-b7aa-35b105b8b772@zohomail.in>
Date: Tue, 24 Mar 2026 16:47:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/6] mm/vmalloc: fix vrealloc() grow-in-place check
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
 <20260324-vmalloc-shrink-v7-2-c0e62b8e5d83@zohomail.in>
 <acJvIbXjeZdxBlH5@google.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <acJvIbXjeZdxBlH5@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Stat-Signature: dz4jrmsacm7j9x3t15m1nhbpatoupwff
X-Rspamd-Queue-Id: F1041A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774351050-627966
X-HE-Meta: U2FsdGVkX18uZ77vbdcHNcyD7GTYOv19ezpbHN78U5UvLBKBmkmPdinBaKsETOhIx+2rv+sn6j062UMMiLrGVWgwvlmSHO8d2mX/Rj1bxMtqkQrpIz19HRdIwmQKpmo1am+LoNwLHNXDVc+k1/qd35fupHc6rFy/kRVB26rG8uh10m80DpfX4u7ju46v04ThGNkiTKmRywkt1LDFhFGdw2fAWa/SnWlg1fLmBKETUF17wQ1pT0L/8uFykgnVLRgZqHBgQejuRhsbcFE9KMyyyboH3ukvUd4A1awchPeHVY0HbGUtC+087c9Sp9Q3tMdbnWmddZIWbT+Erw6lVTRmJpNKdyh0/kdJB+Dap0E+ycVVEKxojuf1wZ3D0/N07jsgnEshmVEZlLriDtXdvgi3dMyB3SAuIesc+opvJUJZ5drUVeGtXTZhc8dZGejtmwL4xfjIKK6PqsLlPNM/Dq39UvBGrbPqecLXFeeXcCjj+ZOgsxSqybnyFHKgBU5HuLnjm57VR1i1BodZjXPBbTFqo8ybATNUEWKtpuM/leMozgcEgPyXRrsIBk03kKLPlGoOcjNHofHrPQ4s9AZDIXbMXTWhcxOkEmbUeQO8ME7dGBN5O/RkNpUoxBHb1501e+9ieGpDYGacH2l0+ZmqiMi9s34r1OHdO/cKvCw73n6Pj49Ou3OROoSx09BQSfwC76d2ARUau4KNyWum3O/AVndetA7aKumxqO2MQiNBOgnk1ykIYRCTUb2/vPY0gIfGoVVZtLcBXExmUvGwSP3x4nLlhMp/c47e7g9kAZC9W2aM8Rsyb/fsohXbqTuzpxavPXnaQ1HMoH3yZAWhxjRSQnPelq+xylqEXW5HhhTRP77pBB7cZdGIpzmLrUD6LMBbOPfMBsAgTf5MjgoKc5Qzruik5VxRVXHjc7FUC/V5gWNVGhuG/Xb2MUveQRA/H9Y1ayT9648aa6bn+vTVYmrjEII
 2eIK7ryI
 f4IlFRa1fhLIUU7T1pFFrBGmR021ltmK58mvB52akdaZLGSOeo3rxJzY7OKKjnGqBVvtcEsIeTnhrqmtLQxQvbybNsiXRAJRKDXjOsfkBz6Ou9ePIIXNgMTAqLG8PIY0bjlhsLoA9iAhnxWKz6Ln27Pvf7JNKLiUNBJKP05trj+LXQwp3oL5EyI9Ii/QE4GIZw8FppO3WrC2Qfa2tYgYM5QSHRGvSPknhQ70tT8KM7t63XXykkZcMq+oJEpE6MMxrvDyXZb+e2E5zRa5E6yF5n76GBFWvmwRv0Jf5VlACAmjf1+zMaICTno6QXNnXUC+jqeYS9G7EvTD5E5OX5lfY5WN5gwyB4JNfMG28azFZ35dXQdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/26 16:31, Alice Ryhl wrote:
> On Tue, Mar 24, 2026 at 03:30:27PM +0530, Shivam Kalra via B4 Relay wrote:
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> Fix the grow-in-place check in vrealloc() to compare the requested size
>> against the actual physical page count (vm->nr_pages) rather than the
>> virtual area size (alloced_size, derived from get_vm_area_size()).
>>
>> The virtual reservation size (get_vm_area_size()) does not decrease when
>> pages are freed during a shrink operation. Consequently, without this fix,
>> a subsequent grow-in-place operation after a shrink would incorrectly
>> succeed and attempt to access freed pages. Correcting this check is a
>> prerequisite for the upcoming vrealloc() shrink functionality.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
> 
> This commit is titled 'fix', but is it actually a fix for a bug that
> exists today? Or is it just a refactor to support the follow-up
> shrinking logic?
> 
> Alice
You're right, this is not a fix for a bug that exists today. Currently
get_vm_area_size() and vm->nr_pages << PAGE_SHIFT always return the same
value because no code frees tail pages from a live vmalloc allocation.

The two expressions only diverge once the shrink patch (patch 5/6) is
applied, which reduces nr_pages while keeping vm->size unchanged.

I'll retitle this to something like:

mm/vmalloc: base vrealloc() grow-in-place check on nr_pages

and rephrase the commit message to describe it as a preparatory change
rather than a fix.

Thanks for catching this.


