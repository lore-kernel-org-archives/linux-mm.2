Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F1FEB7EDF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 850946B0088; Wed,  4 Mar 2026 07:38:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE406B008C; Wed,  4 Mar 2026 07:38:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A016B0092; Wed,  4 Mar 2026 07:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3336B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:38:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 060C81605BA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:38:34 +0000 (UTC)
X-FDA: 84508334148.12.5D847CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 326E3180009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:38:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TCSI/Duv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772627912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GRxvhhcCtdggHpyOoDAHruVHFMYXRt1QecRyKM8RNk=;
	b=aJE1rIJz58aMSQMMov1qEsR7Oqi4NjtOURFSsBiFmhTvziDcrlHb7OugItw3oV4eOuRFkQ
	a6i5VKZJeslW7Di9wDKODw77u4QCOiO/7XoCFEoL1bJj+HLUSWwi3Y/L5YckAosm9BJoL4
	lo/oesQEIgowNv9/eFxQR8FA/ODDH6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772627912; a=rsa-sha256;
	cv=none;
	b=t6lZy+5VvtXe0yFDvlaPLwOgRGw96EW1EnWgzGoRfB0WFxcCwChudi17EblMrLLWCFQeuK
	wt6xvVgiBvEdm7T1tTXxrz5sizAsJmK5k2zOTaDKJw9F5Bf53MpLIFTtDkFLe3Ly5RufDY
	Ap0gWTnDTzl85f71RPJfoNm1ccKsYcw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TCSI/Duv";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 327D842D8E;
	Wed,  4 Mar 2026 12:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3D6C19423;
	Wed,  4 Mar 2026 12:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772627911;
	bh=j4dICI8IopsxSKAMiVL12nDcoFM4FwiGToHiOpfGt9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TCSI/DuvnUfvGpbtoRBBP8x/4H+2EL6WoZrurZ9E8NApYlUSfmW3x7TH7z6qsevfG
	 h13K7NreUgrTW69D8fMHsj5lOoWfyMB6OQ/azSAbRRQNtxasO2FiotnNop8hR4k0yL
	 6wak+WWaKF5kHoxj+npl83Fcbjq3qOl1jnOFT6pdfRZoAZZMR/mJRdfdyUwg3iPIhE
	 qn+odKsKpWNyKMwdOCLnmteJj2NkoEfQ5Y2dSsIso36GBwY5H62+bgIxhBZsLXhTQN
	 jGimJub/qF1WRtavwhhmtGsHadsL7JkCcncw2RugmtVWze9lKxqij8p/J3DuvFtHso
	 Je3BUg4C8EiVA==
Message-ID: <cdc6afcb-3948-4d83-82d0-297e8c04cec2@kernel.org>
Date: Wed, 4 Mar 2026 13:38:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: reject zero vm.stat_interval to prevent
 busy-loop
To: Michal Hocko <mhocko@suse.com>, maximilianpezzullo@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Terry M <terrym3201@bugzilla.kernel.org>
References: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
 <aaf65GSNmBs-01uf@tiehlicka>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <aaf65GSNmBs-01uf@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 326E3180009
X-Stat-Signature: 8na9cyh743nhf1bwoc1te8xji5jm93se
X-Rspam-User: 
X-HE-Tag: 1772627912-383763
X-HE-Meta: U2FsdGVkX19FQXt/oqWO8WK2NFOFrsry4w3ODXtHOf4Soilmdg8OU6UhKDKgSf5CwGrL4QFBIDDe044Q1sqxzo57+J/6CcfClb2LbOigRspi2ZZqZwY9Rn6RqWsBFfn1OPRlGWzq1kiwyYarVUyNbfd/Sm2pGWnYFXXGfdrG9+spKjxmgS/1msBL2JyQ6/BC+CQ4TEQJUmlZD8dpTmd5CEnL3HikbG/8VQQRhGyNwW+FpVGZ+kUjMw31Pa5WnIXKyp/ulP67xIR3aQAs8slD1XvOGL4Yf+mVY/3r8+ImwO9yQCL3PR4Tv7uQS9muDiLR9ZIb/KMfDqZT16VyTeCYiV2LIbL0C1tlsKLmVIbQ/Vq2ilIphcGwORMHctyb99YxXmRpU4Geizq9U1vcMqPSruXBXcVlqi2Vnho/KqZWUksu3yauqtFcCXriz6tIvx9v9klypIWFmgxjOIdWbRNOXq1VFrnvK6lklvFSbCPX0BA74pphTmmEP/kZLkXoUdufzPwOT7gJZrXAFPkKgrT0Yn2lEgJDgc7ejj5+c/oP1owYKLLjADQYUXFfTiA5jl7Bpvn0OL7S7kSo00PEZ/lzXZ1J0IvcN9ldTSEltat2stGHXOq9Z3HeW+ChIPOHgmqKG4odMyaJLD9DO1r90qAMq4fEzsnghwKI/3r6z/AF34ZnJS8Dd4yeKsgvdB9aE7wZyOPBJeUsDOgZRlLh1AYI8fEmR1GBeQpKbLT5Pnf+Sq1xtuY288joWpomRrEuxui7Jk1MbRuvBxFFNK0BbDXKsEk9VXVKyxVQf83FsgDVwLbPvRd0NunPaFwGYE+n/6nzGLzcp5CWHFgBm5WtLlrXEKSVvydt8yFhkNmLF6jdZr9vN/MFXGe2dFDDaWwRw/NPb4lujYP0PqEBn7ziIV9JuNmfBU66GncpKdhyZqYv0PlazZPOnnNHU6VGgxEtm0l8No0gt/DjzRNeUtjM93V
 hxGvXcoU
 5E5nZ+akl58rlnc8EPKUGTbe6U3dg2sv5dh1w3eD5JwfrmtPwd2AjCgot27VJq3TM7QJORJonyki5af56R4orRkz2Zjtz3znl1vh14YLalXLNRy8/WLEH0SC4c5e6vD1dHa93Ni1JrI1l/DhMqpQYFHe1qu6ytzXvoBwVjup6QINjFZdsxQPM2QAuhO3UizZRtQhjzeG3j2zLMqvMCc6oAGq53TkDN8ECeQGZ/phNrrFvDd0hSKQzKTgpynlz7Eyp/+91ql2I4kO3K3hkYYHoXiXNv+TQaCXfcxOZh/aUYat8W2jXmFjKaCErzPuNu7tgv+1BI0D6ktODAztUdoHOK7FJhDVnAUezoll3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/4/26 10:27 AM, Michal Hocko wrote:
> On Wed 04-03-26 08:27:38, Maximilian Pezzullo via B4 Relay wrote:
>> From: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
>>
>> Setting vm.stat_interval to 0 causes excessive kworker CPU usage
>> because vmstat_shepherd() and vmstat_update() reschedule themselves
>> with round_jiffies_relative(0), which resolves to an immediate
>> reschedule and creates a busy-loop.
>>
>> Add a custom sysctl handler that rejects 0 and restores the previous
>> value, similar to how dirtytime_interval_handler() handles
>> vm.dirtytime_expire_seconds.
>>
>> Reported-by: Terry M <terrym3201@bugzilla.kernel.org>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220226
>> Signed-off-by: Maximilian Pezzullo <maximilianpezzullo@gmail.com>
>> ---
>>  mm/vmstat.c | 14 +++++++++++++-
>>  1 file changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 86b14b0f77b5..6eeb4341b215 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -2114,6 +2114,18 @@ void vmstat_flush_workqueue(void)
>>  	flush_workqueue(mm_percpu_wq);
>>  }
>>  
>> +static int vmstat_interval_handler(const struct ctl_table *table, int write,
>> +				    void *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	int ret = proc_dointvec_jiffies(table, write, buffer, lenp, ppos);
>> +
>> +	if (ret == 0 && write && sysctl_stat_interval == 0) {
>> +		sysctl_stat_interval = HZ;
>> +		return -EINVAL;
> 
> So you update the value and report the failure. Nope, this is not
> correct way to handle that. Either tou check the value and fail before
> any side effects or you correct the value, report that to the log and
> return success.
> 
> I would preffer to not do that at all. Setting any arbitrary small value
> will have some side effects. This is admin only interface and we expect
> those do know what they are doing.

I think it would make some sense to reject a value that leads to
unrecoverable situation due to something in the kernel looping endlessly
with no preemption, causing e.g. softlockups, and making it impossible
to set a new sane value again. I don't know if that's the case here for
value 0. If it only leads to 20-30% cpu utilization (per the bugzilla)
and the admin can recover by setting a sane value again, we can indeed
leave it that way.

> NAK to the patch


