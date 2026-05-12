Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E345BCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6C76B008A; Tue, 12 May 2026 04:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096EB6B008C; Tue, 12 May 2026 04:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6D26B0092; Tue, 12 May 2026 04:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D814E6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:21:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BC4EC1B1E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:21:59 +0000 (UTC)
X-FDA: 84758074758.22.2B66A73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AF07B140006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:21:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJW8cS46;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778574117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPvMRYiKnVbcTD7QdHLyPFIbDYkP9XxCBNGrnifEwNE=;
	b=vyu81GToadayH+f3/huVs6anQyc7r5RewxghdyFG8BcP57R4z92V/h79+19Y8ZLq867+EH
	R2730XB70gjVK/TQX8ntCDvs9a1DonwE0Wvl7GVIE7Q49lySygf9lNq7Mf2N+GH9/n+msC
	zbb1qsIlSjpLPOjpyIky5B8KsTg9AXU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lJW8cS46;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778574117; a=rsa-sha256;
	cv=none;
	b=ZuvS3rYCSeV/+5iHmuIBzyhtKuPs/N9DcGxeZkwmurWoFpPmzlSFctQBNe0H5fqGsi46Pd
	o4lfL5MdSEoambLKnkHySCaIc6VobdEWUFiVmI6SzD15nyObzWKNkW0PLbpSkkN/kPnBTt
	cyF4Pz1v/Z54f0MLRxxmfPDT1eoDvlY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B4E644299;
	Tue, 12 May 2026 08:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA4FC2BCC7;
	Tue, 12 May 2026 08:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778574116;
	bh=BzI0CNnEF8r/iKD+i7CDMy8nExtp1dGZkjUBOYcnEII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lJW8cS462uJfoi5YdmPbP12+4tM9IsCasai5JPPyLfuYqiCLhVll/0w6zgYw6sgHR
	 9nAYS5DznpErgbSPrSJzE43gODvI55qZ+imQihp0obE5S9tPmbaDyo7zl0949OhBU+
	 3vYfRq8najZ6SJaKeTUUe5qjh59ZBQTFjWjeKHk8EAyjqLf8hckxYqfTMoZ77iqZWx
	 btALWqWXNtfQXGZQkY8V0k8h4ZTKQP51shr/bvcZwXX5di0dNazFk8AspcgTo1dk4l
	 6CidnQP12YJy0pav4LXk170PB4PAG/uRMEnIbGqM9lArTDJvg64pKvAi4PdxFm8tjA
	 RRUYr5rTo+vHA==
Message-ID: <28b01c14-3d87-4cab-b695-5b9015578785@kernel.org>
Date: Tue, 12 May 2026 10:21:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] mm/memory-failure: classify get_any_page()
 failures by reason
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com,
 Lance Yang <lance.yang@linux.dev>
References: <20260511-ecc_panic-v6-0-183012ba7d4b@debian.org>
 <20260511-ecc_panic-v6-2-183012ba7d4b@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511-ecc_panic-v6-2-183012ba7d4b@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AF07B140006
X-Rspamd-Server: rspam06
X-Stat-Signature: khks7uajps3oxi7fm3uj89fncexztzeq
X-HE-Tag: 1778574117-459134
X-HE-Meta: U2FsdGVkX1+lwwXlGl/vJsbkMIkkMS6PB8lxi+AL1quBhkUHjH+1BydDRm91QEMV313Y/Brqa6Rl+LzoyVR61tKYSHvpDhidOAN1wvE5EFIjWKkUHctCpLDeKtsVgiqFfDmG3bDnokZJSr8z2fXgMS0p7kVTy9uAootxqZLYBS5kNL9gO2hZgLH/y4CcS7UQiAxYLixmGH0+vItTC9Hm+p2vOPLtV0BGGTcsDgFcWg2HBiRSbTbziczoC7xSjEbPwAifeQvBGpVrGZMBFUZQqiPsRK5DX0qdProkrts2vs7CC75g4hRrbAltt6FGqzaCvUz3tPKepjjkDJLK4M312I5y6BhtKGlOa0L8rzZ+ebEJxgSC5a9Fndaz3oVa8n6jaAnIlSH0oPxT8XJlk2J0QJprq5Yp8pNIxiqLDQm/RhZUJSmpoOiP56UNK0Dnv5oGcQzerlfraSuSbzzsQeYvWZJiWjto0pERaovcX67JLoi2UmrdPmNIAMjvvuZWEzC5l8VTUwLwcbsYPfk2oGxG0IF+jUrcte+BUplydw8LXw9+Ys0ZeFybWM8IfpL9utpmxhSqPlDl1ZdZMO9ARHtxyHXi8qqZBIP7NZAjLaha1V+5WTVGGYJGwMzVrlRZOL82FyR/K2EtA+4dO05ZqixLDuAzQlwPhLQHoq6iiZn3sSLHLHnl0WLDSsD3Z5Ui3SnsDo5k6nxScr24foVGrDZhVwY7t+ayUxV9BzWzSUEjv3Itx3N2XL7FAKG5idWQJPQqew2jOH9RaieNIzC79Fs1B+l5l6MBwdP4RF4QynZJLniyGT2NL/3Y2ntvZTZC1dHbgBqvkHuLTr+Vr/+VHjBMcxpI9cefJUOjAzJEJr/Lll8DBOcc3MNsgpBtzJfB3cl9VECpaQMOuqfcLrcFZLBZ6FCNVwb/hU3MBU6SnmqckuIDqgSrJPxTaLbQJKxd9l2jCF6HW30zqSxJEnHFaKs
 8YovDZBY
 Uck7zxfG8+IcrrGv6F2Midf0ZguumlhAKoycjvr7ulILpprDHcQHtYyGz/lJz6cM5s+SGqAwQuk25Qw0ofUbI8pJbLgODNxcJZq5MUNdFi9D7GITxKvP0At7z/2tWQR8QvCb8sFKW9ZVDBVrvLaJBJPw8FVi5INOA6MBeJQ1w4uCfxWBAnMqV7er5U50R+Ntsn6hV6M9TeU8UNQclznbknTdMTNY9/GenSQBKy9Lg2A9wgXP3sJF9sQzMVW7StckJR/bmWnQotgPL5RsWWhuAZXDUuiusgirSe8+XJIhSejDcSdA6dgFaMgIide3ZW3dd5V1UsqPsMThNCS1OfEPKvSV/IoyS+yzelN0KEma3g+vvpbUB7Yp1m6So3kvyqad4bvlRZ0NFdqGkcCyiolsaIs5TRKJDYJyRVW1w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  		}
>  		goto unlock_mutex;
>  	} else if (res < 0) {
> -		if (is_reserved)
> +		/*
> +		 * Promote a stable unhandlable kernel page diagnosed by
> +		 * get_hwpoison_page() to MF_MSG_KERNEL alongside reserved
> +		 * pages; transient lifecycle races stay as MF_MSG_GET_HWPOISON.
> +		 */
> +		if (is_reserved || gp_status == MF_GET_PAGE_UNHANDLABLE)
>  			res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);


It's all a bit of a mess. get_hwpoison_page() should just indicate that a page
is unhandable if it is PG_reserved?

Why can't we just return a special error code from  get_hwpoison_page()? We ahve
plenty of errno values to chose from.

-- 
Cheers,

David

