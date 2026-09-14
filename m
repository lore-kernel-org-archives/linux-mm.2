Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AADC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015496B008C; Mon, 14 Sep 2026 09:37:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F09436B0093; Mon, 14 Sep 2026 09:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7326B008C; Mon, 14 Sep 2026 09:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5E9A6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:37:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 558CB40163
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:37:50 +0000 (UTC)
X-FDA: 85212470700.19.F297C6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A017D80002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:37:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzWThbVG;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teIDwwfXFah8NBFRWQRZ+eTRmrLAr0rfuoGSkmAAKdA=;
	b=4tJiwNa2Ieo0cvDa7woRUWhboatw9UD+nbkZOa5A4590RGZmSEEIkfteV/Kn0w26nKurOv
	hMo1bB+sOadzI+G5MqKGs0VNJGgh/YcCZgqFBTU6qICHNLgTaQbXE53ltMl5tqKLBOyyL8
	XnYE1biaVzEND6J07NvDVnvFwJtOaUg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393068;
	b=k4zzffdIShKzA0ED3IGYBxN7kTBV/jTEX22gLf/cQjB0toOGtRc1LOhpTnFcekyiOmfKGd
	j/E9JtZVf7wMCED3k0mgYLl0j3yupXFFsm9WbitqjhXT5TFR6+I2dKP4Nvx3wf3R7YVd+3
	RqmWtdd4r8XsVGx3ubbvjxWbD/nlipA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dzWThbVG;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7ACEB601DE;
	Mon, 14 Sep 2026 13:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7921F000FF;
	Mon, 14 Sep 2026 13:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393067;
	bh=teIDwwfXFah8NBFRWQRZ+eTRmrLAr0rfuoGSkmAAKdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dzWThbVGDiP+7Kh8Mlz1jnGM9uDygrrjPE0PznQPTZeVLeOHQQlSlJWZOsJOs45GF
	 0M3ZJK/UHFqpgFIn641k4+JS6FomgiWbSlwEFgmxqW/sLcDbLuBDYrd48YgMxV3hnT
	 fW+WwewWkWuc2f2sdLu2PHIMXhJpCUJcwYUqSmDF6X5/LpE4P1c2tiVnBGZPtJeFLo
	 QOHoDP0xqfahJpUiBNiYyltu61DX+V61cCJKBC9t9vQPXCsNCUWimBhiHPG4u7vq4E
	 A3a1S/3q5lxM9EP8DPj5nGEAVcSD+fgtwFCeLDku8ld4Bn1g4GLsxWZVJMPFL3CO0Z
	 doE/NDERw9ycQ==
Message-ID: <76d8c9ee-b994-47a9-b5f3-87d257194eea@kernel.org>
Date: Mon, 14 Sep 2026 15:37:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/16] mm/page-flags: remove PG_private
To: sashiko-reviews@lists.linux.dev, Qi Zheng <qi.zheng@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>,
 Alistair Popple <apopple@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Gregory Price <gourry@gourry.net>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Dev Jain
 <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>,
 Lance Yang <lance.yang@linux.dev>, Ying Huang
 <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Barry Song <baohua@kernel.org>, Nico Pache <nico.pache@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>,
 Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>, linux-fsdevel@vger.kernel.org,
 Pratyush Yadav <pratyush@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dave Young <ruirui.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-16-848550f7574e@nvidia.com>
 <20260914024800.087EF1F000FF@smtp.kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914024800.087EF1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 68nnut866hqjcu537y8idsngooegr6s1
X-Rspam-User: 
X-Rspamd-Queue-Id: A017D80002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789393068-424797
X-HE-Meta: U2FsdGVkX1/vfP+TtZKhbEHiiQOlDBm5venl+hhYY4JzcHRTwuBgJ7nx6bESODQvPhaz7646KwgqKbNMLP8lxn7Npnn0pwBrvOeT/8Ny746aZETIL7edzZ5LAHEx5NhIR3i6IngSiBUSPlydcLuHAEwd0K4fadryfst5hM92jK5WHcerg98FP6283/tZK3OgKZD/KtEpKZ1aldNf5UBNo8YLvHo7oWftg2iFfFvUIxNeDfg+NuksbxmtoC1mQxsIMk4FTB9ta/kdh5ZW86yOD+v/zhGKhrTVNS0L5yZaI8gdPTaZgW/Qwqlk+QEPq0q2qJ0zZYlhqpWECrdljul5kPx6ZYZ9g6b4mf/OTISX6xI2nMNSnKBpLosL7Ae2fFV/m4ISr5BlgXH3u71A9ADiJfj0chaIJa/EMZaeCcQgOUEeLRE6NYi+vPFFyvRyb9XxiHax011iqZLrK3spNs9AF/u8eUer4pWjRRkQvs9bfAbIU5lugMeEpHZrOI5y4jPTpV2y9U7/vAeu8fMPOvQDxrodwWcJUaW3Br8NKHl7AAQNKJ6ExGZNfW+mAhIG3bVLRGvGf/ZaSIDmCsUHxlcNhkz6p8lWh6ou+Fvm6AQIyjzBcvq+SIP6fgCUiI2ZIIdUxbPjfGNW2OUSHhOPWbbOBmUhTpd0xzeH/G8uWUAEF966J+9ohTOu+oD+xp9r2hpx2PIl/JWkoOpUxjvmIVYYhaq/W6nvRRL/nYltGObMZ+LjCjl0lmSBEb1ML7njT0YV3q3eMuomRRsJrFu6mLv2LVPGym21PEKKWUx0plBG8Z0/PYVBzERXH1uP4r6VnaxLI0Na+5xM2s5E6jyq9lqsbMausEXyzdOlE/ArvBWCIt9WmBRhJzPb+IA6F2x2cMg+5fms9+lQqXRG9kZyjFLHSbInD3fUPh8QQSR08LshlYvbrE5j3lEEKAstnbDkZcxiM3AAOsegADcellBMdct
 zSTohnTf
 p+LhNsFvfYzyRiTcN8/enJz+OV4e2bwJaT2GetTDxiczxPbI6QQDlFk/En5YYW3VOE6+lW+v17Y1g0dtjlNg8wqAYdfmaciPJAqme5c0n/BvGjLPKeypsD9cSlqBYZLm1FBHR/2T0zeWJ1nCEBAHb4wUxI8G2WCECYzPXIgf5gbJsgaFRGSHIFtLL948QvdlWbdoEUuXkwGQbeKGmGuzCHqxT+b2ASW101LPHZBOu0IjPdUoIL0QnArK18A5ckZuRNKElqiEpkwdxHm9lYkQGs8VJedwJmBWmPGTADA+BWt3iDsRlIBDwuFX+UPO5OMQjCkFakueOV6JlzomhlILwQs5MRt7KBqfC5HJ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:47, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Silent memory leak of folio private data due to missing check for leaked `folio->private` data when a head page is freed.
> --
> 
> commit ebe4dd474a496c46897e3f790e03a43cc0508eaf
> Author: Zi Yan <ziy@nvidia.com>
> 
> mm/page-flags: remove PG_private
> 
> folio->private != NULL indicates a folio carries private data, replacing
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as PG_folio for future use. Unused PG_private functions
> are removed too.
> 
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index 08988877331ba..10f4ad075ea48 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
> 
> [ ... ]
> 
>> @@ -105,7 +101,7 @@ enum pageflags {
>>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>>  	PG_arch_1,
>>  	PG_reserved,
>> -	PG_private,		/* If pagecache, has fs-private data */
>> +	PG_folio,		/* Do not use: reserved for folio identification */
> 
> [Severity: High]

"High" lol

-- 
Cheers,

David

