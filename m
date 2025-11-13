Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47EE1CD5BA7
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8948E0010; Thu, 13 Nov 2025 04:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FE58E0007; Thu, 13 Nov 2025 04:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7022D8E0010; Thu, 13 Nov 2025 04:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 56BD28E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:13:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 049E013BE40
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:13:53 +0000 (UTC)
X-FDA: 84105021588.16.FB55C2B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8BEA21A0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:13:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aqh1d7VK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kCKc/EkN";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aqh1d7VK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kCKc/EkN";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763025232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N3au+Y6kKOvEdxG7A5AUpxhW9mu41Ry6d7QeIg8YWhQ=;
	b=pwQGJ5yGVBxgPLi8xsXG5ZHEcvbm4Sz+UTVh1ssvx4RrvnZPg104OQmALIfDP+WbE4kPNw
	K3Vbqp9Ep6oTHxEkK0HtNZ3UjHGkAuIpeP0AzEXDjA73gHoE1V9dHLruA46wgidJoeCJ78
	rBrAbuAFNIM1IABvuu2ggm4Y/GzTmhs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763025232; a=rsa-sha256;
	cv=none;
	b=psIf8zKOfLrgeeFV9Br79y7LvelN48OjJTbUtGqwheW+eH1V1/RUkEOFLWcUF/SI2klEAv
	re8HQ8J5OMrGZ2hJbQrbY222Ci+N1WKakNqaxFbDcATusMT8S89M/1GAX8ClgY5f179K5i
	a2Uj6Alyz8Ihtcx44v1nzj8WucmYWjs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aqh1d7VK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kCKc/EkN";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aqh1d7VK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="kCKc/EkN";
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D4FE1F791;
	Thu, 13 Nov 2025 09:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763025229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N3au+Y6kKOvEdxG7A5AUpxhW9mu41Ry6d7QeIg8YWhQ=;
	b=aqh1d7VK6W704UDOKRQvL+MYJutIlUTYyMQTrjRBIJ+vyAawtRwAbdYOdCVVYpaKrs+tIw
	KEnkA8GL3W9erEQIutJ093On+4pZ23twWTwtl+TqewGX7YKmQrY2Dep+jJjpfD4Knjyq9P
	h4euX8rHJdM5PbHlpDvMWtGCPq6hSGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763025229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N3au+Y6kKOvEdxG7A5AUpxhW9mu41Ry6d7QeIg8YWhQ=;
	b=kCKc/EkNy0tKE0gNUK0PZAyZazBGTUDDVxos/uAtL8AFh7JUhcWmpIGWnlFBnNztALzyZM
	7KusgY/M7VF2w1AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763025229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N3au+Y6kKOvEdxG7A5AUpxhW9mu41Ry6d7QeIg8YWhQ=;
	b=aqh1d7VK6W704UDOKRQvL+MYJutIlUTYyMQTrjRBIJ+vyAawtRwAbdYOdCVVYpaKrs+tIw
	KEnkA8GL3W9erEQIutJ093On+4pZ23twWTwtl+TqewGX7YKmQrY2Dep+jJjpfD4Knjyq9P
	h4euX8rHJdM5PbHlpDvMWtGCPq6hSGE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763025229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=N3au+Y6kKOvEdxG7A5AUpxhW9mu41Ry6d7QeIg8YWhQ=;
	b=kCKc/EkNy0tKE0gNUK0PZAyZazBGTUDDVxos/uAtL8AFh7JUhcWmpIGWnlFBnNztALzyZM
	7KusgY/M7VF2w1AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D2883EA61;
	Thu, 13 Nov 2025 09:13:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C5UdHk2hFWkMZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 09:13:49 +0000
Message-ID: <8633ea79-db53-4157-932b-30a814283c03@suse.cz>
Date: Thu, 13 Nov 2025 10:13:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] slab: use struct freelist_counters as parameters in
 relevant functions
To: Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-kernel@vger.kernel.org
References: <20251107-slab-fms-cleanup-v1-0-650b1491ac9e@suse.cz>
 <20251107-slab-fms-cleanup-v1-4-650b1491ac9e@suse.cz>
 <aRWXsVuiSCv062su@hyeyoo>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aRWXsVuiSCv062su@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: to755eqqbgedm63o4zaz8e7togsx19hr
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BEA21A0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763025231-961063
X-HE-Meta: U2FsdGVkX1+FfRno+Fh7dZMuK2OJn66y25fsmgIuh0ipAXpHOGbq+w5PDLAtGiw4xGf1bdjvl29DS1LlF9mbpoGa59M0drjVDC5k4WqV14ao9dqdqunoovvsia8ae5G5AS2i+tahKtRBwkjwhfDsltD0c4UQd6ckEbIZASnNRMg3OXdLnTXwOGqiSUUb+UBIRbn0gljjeCSjcRWdovKLdWSW6bJYTbTSDIn+OaQ7MlklugjnFT7LLTodZ5YaQncgLKCtuPS2TSVady7ZGFfBHO/TFOrGcTL2Tkj5WkBh5IFewrAjPdwzNSPiFPWtUi0+6VUp2zmaAWdZxzo0HA8btB76Bk9tNxTcmaQW5uYjNMevGQVdGTmuI18+69DC36oEgEU/hdPYhLxehugy7yqpLXoz7ZYzWay1hmixQEw9owjVWVN9eecM1FyWDDyzj5/KAO62SbKIEq5DUOcoq5ISeLdAa11r/wlnQpsAHchfHx7fMShMvwXBuCMyqvv25tea4fJe+dTCUF/LYjps8XDwYEd/ljIwGqQRpmD6viEPaoxJ8rIKJXOCLk71/mEESbYY8eowaeLtMmOptNZ+lu7dFwi+QfpEWeLfKN/rsqvGNslo6jzus1vnWg4dWCxxgnJiJBOQDcCQbLZ0IoEoOtg4atmJzXaPXY2Ewyn7P/LS9tlcqfkp725YSs7snRVaAh4tqg6KOjob1wfYcp6QQRhC6nwuEAolehRsie24zcGzwdo92Z/xyd9IzaZuY5r231eyspfdfAKw7Agd2KjiKqQ87M8lP/WsW7kdp0epjabHmFANe7zH5gNLk+2R5rDZikn3eWzUDJAJ/qhGeskgP/ehTrso0Y2kg+Q3qqtWTbxaDO79w6v2IzLIeeG5dY2EyLq9A8/oSTZVYd7Pw8UL7QjPxysTq1rMZz/Esa/l55duP8KSf/9AvketM61zjtTRxszfAhz5N9cvEsylrwL2t3B
 G8Tv5xnF
 8fKi174ivM/+P8puAvJ7siRl01gNw+EFGNycGNK0AQligB1i1rmPAMgRU7DsGQbUWYW4gIwtiXmL/UmSv63cjDT9iGbFyQPJ7KhS9ZXGrh18QEWVu/PMmuZcdNiA8LLvck2sQRBV4/PEnRnQ69t5VJVzttTyrnGWv0L5a4OvHbH1xo6Y3AwGnJZ9EASTOsNWnpL/rpIHqqAtm5Gx8vrYbybZOmjOMpHObtIj7yyEtn9cKxnJUAsQUXzM9f/8EFyyw1xSqu1P2rAFF5EJW0qJUGxH2ymcFH9VkjQuzmMb3UWcVoCHWRHNkbLM6Pf3vQ3zPRx/3dQ968x1di8VuGgMpuiglLWAhlikG/Esj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 09:32, Harry Yoo wrote:
> On Fri, Nov 07, 2025 at 02:51:26PM +0100, Vlastimil Babka wrote:
>> In functions such as [__]slab_update_freelist() and
>> __slab_update_freelist_fast/slow() we pass old and new freelist and
>> counters as 4 separate parameters. The underlying
>> __update_freelist_fast() then constructs struct freelist_counters
>> variables for passing the full freelist+counter combinations to cmpxchg
>> double.
>> 
>> In most cases we actually start with struct freelist_counters variables,
>> but then pass the individual fields, only to construct new struct
>> freelist_counters variables. While it's all inlined and thus should be
>> efficient, we can simplify this code.
>> 
>> Thus replace the 4 parameters for individual fields with two
>> freelist_aba_t pointers wherever applicable. __update_freelist_fast()
> 
> nit: I guess you meant struct freelist_counters pointers, because
> freelist_aba_t is gone.

Yeah, stale text from before removing freelist_aba_t, will update, thanks.

>> can then pass them directly to try_cmpxchg_freelist().
>> 
>> The code is also more obvious as the pattern becomes unified such that
>> we set up "old" and "new" struct freelist_counters variables upfront as
>> we fully need them to be, and simply call [__]slab_update_freelist() on
>> them.  Previously some of the "new" values would be hidden as one of the
>> many parameters and thus make it harder to figure out what the code
>> does.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> Nice!
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks a lot for all your reviews!



