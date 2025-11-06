Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F076ACCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3EC8E000C; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064AF8E0002; Thu,  6 Nov 2025 03:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC2E8E000C; Thu,  6 Nov 2025 03:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5DF98E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:24:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 875861A065A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:24:42 +0000 (UTC)
X-FDA: 84079496004.22.FC42AA0
Received: from mail.eskimo.com (mail.eskimo.com [66.114.134.197])
	by imf02.hostedemail.com (Postfix) with ESMTP id 11C6A8000E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:24:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf02.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762417481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9HPxNvMUKXtBCbAwN1IF8ciB8pgGU0QgOGk6rA/B5EQ=;
	b=AD+zKG9/2WLDyzoVUtSYq0RzIXTqZBVoGVdLEkucZQ5pEq0EFxugRF3KZnwwTgQZDQj532
	EiyR9TaQM+1+TBHRmXPR+SOs5fpSUKqoG0134/qOKfCTo13qs2AjvzbSjmqd+oa4O1yzaO
	wr3Hp4goKRPYJDqH7NUuLlLNXkZzR4w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=reject) header.from=eskimo.com;
	spf=pass (imf02.hostedemail.com: domain of nanook@eskimo.com designates 66.114.134.197 as permitted sender) smtp.mailfrom=nanook@eskimo.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762417481; a=rsa-sha256;
	cv=none;
	b=srph6lQkWD8YL/S5xd9QQI1OnOshbX/HWa+FLn0fcgF2fQVwDcKoS9h2KXSnpKc/T7EAJn
	20NtgDvzF/WXQgkTafCPG6lCPAUAVFL4IzguKqZHKQSTWErIX8UA6rVShgAnQpX9gUONm5
	WyihT5e1w9c+A39HAkEpN4cu0pgTZ7I=
Received: from ubuntu.eskimo.com (ubuntu.eskimo.com [IPv6:2001:560:4407:1::106])
	by mail.eskimo.com (Postfix) with ESMTPS id 10A2E3C1BE1;
	Thu,  6 Nov 2025 00:24:37 -0800 (PST)
Date: Thu, 6 Nov 2025 00:24:36 -0800 (PST)
From: Robert Dinse <nanook@eskimo.com>
To: Michal Hocko <mhocko@suse.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
In-Reply-To: <aQxX1HdOnVZJAERp@tiehlicka>
Message-ID: <41d1cb48-7711-690e-c9a2-978e0f96f5d6@eskimo.com>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com> <aQxX1HdOnVZJAERp@tiehlicka>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1916979846-979605391-1762417477=:3951505"
X-Virus-Scanned: clamav-milter 1.4.3 at mail.eskimo.com
X-Virus-Status: Clean
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 11C6A8000E
X-Stat-Signature: zkuj1zq7p6sntihf4ppjq43w6fzfiwxk
X-Rspam-User: 
X-HE-Tag: 1762417478-850535
X-HE-Meta: U2FsdGVkX187injeU22q8Yu8qm/WQMLfYprVdEQMqujR9HIIgZ8qLrLZmpbzjBwJXe4Be75YkBDxxMrumaLuoFE/bQrD9RSHfNZwBO7TkbDqewv0kRw2IWV+06g5j6Fm4ORpd6YYmEAqWtlSHUAYs4rSTU7MijmHBBsH7DvtGqq/+kPB8gsARz1onhczAV2u4228ldKE9uNroEXyUSfoBfP256NEXsQRsw1GqR8yalt8Q0o8S36mg+R3bt6gjOCpcBhEV4SjqiCfTS8TDvGEdJ65Sy1A4hQPnmebWUK88duMtyiV5+A2IHck/WEh+q0pSuwXfPQi+1/so1jk8LojwF90g76J/KtxgSYmygHpxCtzrCxJoGgzmBEIunB/fR3LMcr+stPyS49UOpNRwWvYBn4AqfDfcC5PvomvZiQmncoOnJj8A+vA75ceAlyM610990b1G0wuOoE5c+7nQth/gjfv90FvdAlXKLWFz/dvICKKym5+gSq838IcW4Mq583DDk0YpHXtSV/JAXWNYDFZ3ILqbMWLSa+6puKco1Zy5Wsj/JasAq+EW/WdC1SnZMZ3G+UBKBYO1ENwF4fhql0FdHM4kdAf6OprQylzyuKaUz7z9cFrFbdNnXYi2lgmHo/H600RhnfKhKcXbMIyjT1uVw9CzR3a86zHxFjvLBQcNMFYCLTte8jMVou6AkUYGequClhHA2TndrFEYn4yKFJhOBFUXGqiz296dEV5461Jv6hv/xOu9RIzN/srhwKPTBs/EgDoksYoAMYk3QChF6Lx+M74CnTtajDcIaeuHVoXxYSnsbySFlH27Ih+Aho6uQLSI3GXhs1/8ei/0JxtNhz4UA5ntAefDR7IJIc1HCX3DOzUXxNFaPWQ1/JVRgnPoIwQ96eIGCt3GMH0VIxiZI482d8ltzc6lXtDawhCfy4jLMO+tpLJhucZX9c/xh5t1nG7dov0BFNccWL6mw0IPVs
 NgDEEMfE
 uF3hoFZcfzbhN+pvkeP66EHgebWQBmN1CXL/o9EiJP5KvF94O2WixfXEdXTaIgsaNzRqN6ZVfxguv2dnLP+UWnmU+SF0FCw/dCmGWNYBNiT/ZsP8j/IOSsM98+i0jS94aUprnQZHCsehp3PgxhjCdesE8r1KcTEdIAjzu2ixzJfvVEwHGKZQk2uBSKKJI1FfOA1LaJoR5sjrw0krEEmfcCht9LzygR72Z5WIGdbDL981CqpxTvDyQLvjo7drcVO4zOt+MB8vE6TKjaWXvVvnzKEzMtAtUIqNLCJdPeFU6xdN5oznohS1FAIPqPndXIXmPPNz8iNdUpGAxjruQ4RR7oR76YtUzDYm0ZV2AfY0ddOf8cihL0ErMeF6TM4CrSDuamQVyg8A89ub7hrpU6orAQHpRGaIvh4HppoDkeGrD4m80O8Wspe3zzBxf50+Rw6IjQPxYvi4XtvF/n7PreADLO1O3gnsgqLKJve9AVbFojetgHmL+WJ7dHXUluGmHdJ17NojTOmMBc4Kif6Tow8Zjkfsu2Lw8nGA1qVlJzErEPSxd37XtXQH1UCXgVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.003023, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1916979846-979605391-1762417477=:3951505
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


      I am installing 6.17.7 presently, I was a little resident to install the 
current tree on a critical machine.  If need be I will.  Also, I do have a 
crash dump on the last failure if that would be of any help.

-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
  Eskimo North Linux Friendly Internet Access, Shell Accounts, and Hosting.
    Knowledgeable human assistance, not telephone trees or script readers.
  See our web site: http://www.eskimo.com/ (206) 812-0051 or (800) 246-6874.

On Thu, 6 Nov 2025, Michal Hocko wrote:

> Date: Thu, 6 Nov 2025 09:09:56 +0100
> From: Michal Hocko <mhocko@suse.com>
> To: Robert Dinse <nanook@eskimo.com>
> Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
> Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
> 
> On Wed 05-11-25 19:19:17, Robert Dinse wrote:
>>       Since 6.17.5 I have twice had one of my servers lock up in a state
>> where it still routed network traffic and responded to pings but no user
>> programs are running.
>
> Can you reproduce with the current Linus tree?
> -- 
> Michal Hocko
> SUSE Labs
>
--1916979846-979605391-1762417477=:3951505--

