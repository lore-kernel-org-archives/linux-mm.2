Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F57FCD6E64
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A107C6B00A3; Tue,  2 Jun 2026 07:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0486B00B3; Tue,  2 Jun 2026 07:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF606B03D5; Tue,  2 Jun 2026 07:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 776BC6B00A3
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:23:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 55858120911
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:23:18 +0000 (UTC)
X-FDA: 84834736476.16.B6A16F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9F98A40003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:23:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnTACJLh;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780399396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQn39BU6Qu0m8+/RYrN8zfV4EtxW7XqMQJXENODHTPE=;
	b=I5XNqBDOytWxWn5wZ9zfVvBO5D3FXok1fnwLcDdVvZSCtzbHPyrNJdkxDdD26AXZ1n9auO
	zv/u2Uk1+G2Y0FDPpD+aJ0xMTqnjtlvGsElx+Cj7HiMKFlMPRUS0CXzcNTR8d8cM56x6Ms
	hAM/d9H0AJupAMAXJEc1VzDV4d8Id5w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nnTACJLh;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780399396;
	b=PhnfTywR5m2N/WPQhslawKzyoMnbHwV/9jv0UVZCtfUcIyLcb4/cnOnHzxeIUwv4+iXLt7
	jVkqC9QndJV+OTwBm2WqgQpZsJf6oWqRGt3mPMenNSAqx/9KT5dEKaWYgWpPW6htLYXlWd
	8G6+uRBYuNlkFKsaC2G6pmczugThgN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24D5F60123;
	Tue,  2 Jun 2026 11:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D3C1F00893;
	Tue,  2 Jun 2026 11:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780399395;
	bh=PQn39BU6Qu0m8+/RYrN8zfV4EtxW7XqMQJXENODHTPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nnTACJLh1FHuqECwx7lJFq1wpGZiI7gu0aD82PVA+vIkRkUmM5KT/ZHYNeRVDlt5P
	 PF29B069hD0X+g1Q6OG4fhJmD06e1j+JSSX2wvChJHtsJnlYH0IYgmyrk5MCkh8GSj
	 s5a5OjKgoIwrIWR9Gy2H23JKtFw6irZS8O2UAHoSWkarj1H1NzT94sGAy+o+//Xd1h
	 fp5J+HzxIF6RvOm16yUnJPxPDdiR3125JSTnqGi8a1gWdWnadEcBFZ+Zwtjf+FoLQn
	 YB/6X4CialEMGLBhZhUT8uOi5cIT1JZ1ejlCTfiD649MJRMdtpqVPdsAxdZS1Zg6L0
	 XP4XduO+SK3RQ==
Message-ID: <b8891a38-7bcd-4258-816d-d397499842e5@kernel.org>
Date: Tue, 2 Jun 2026 13:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook,
 introduce error_filter
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1779462249.git.ljs@kernel.org>
 <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
 <88aa89e7-aa7e-4abf-babb-a2855bcb3fee@kernel.org> <ah2oasz6oz4TgEiD@lucifer>
 <192ad271-13f0-4e8d-b5c2-feb65392bc6b@kernel.org> <ah6qt-JQaSPwGTfi@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ah6qt-JQaSPwGTfi@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F98A40003
X-Stat-Signature: yyoc6rtbwi9h483s7j3yqp1egj5xofey
X-Rspam-User: 
X-HE-Tag: 1780399396-463528
X-HE-Meta: U2FsdGVkX18mBKs4gikcdyfSQ0rNs3a+IiCNRbuojRr4i+8DZjmXJP5Y0mpWjduarYZAJN0q8qMihaqtY+AMhbtULWB/S2eCPu03bktYz0VJWtUqXE0psyv6+1kLzxgNHlh33YEr8I6CjhzuWfkCxW/9SRH8EV42EaaOID1gAr66XwsFrtiUFXkgDOyWj1lca+1IYSO31wVGg0Z2CAsCXiKXb87z6+4GxYgo2wtH4RyjFbhHe54AE8nCeMh4iIkFE31+XqGpvAxSZPkTEyYIO/IwBAA7d9nollommAq4YCxHgtQ8z86KFYCgW5RyHyZCVpHW4KHk4l/rJWd+Df1GQO2aHVqi3aE0NtGAVCyAoNe5J1O8BVx1kQbDkynl1HogG6Gq7PoPxoXhcxMZSb5igT4fHLkmBgbYqA5jJ3F3TnewML91ku2qOl0s/h4BrUKHtOyjG52JK2NwXG9//IaxiKjPYqkwcXYusAuNnmRVgL29uQuBd+v9AQR8cwLtBJSzwzn6h+6Bu9YIAtE9AMWDLcjvhnq5LxFZL0q3XwT+ch1/mV1WoacNAD8y6m2sYS40a3K1qwlxOu8nh9K6kjyJlouCXhGDUsfJAoCuRXmEaOiQrG2LLdGWgtBn4bciPcV1dy+2CBjnC/DGuzQsihHlY7kUyYyUPyKWYrtdc0HD4TbXdFLCHpED5eYGzKI9DJLhISxJqaxTMVUOkKQ3xsRkjNI3e4+tKnpfcHCMXnefOJTCIb8llpOa14VvNBQNdz3r7O4+wU9w4MOf7q2wINkjlYnFJYDffVMSncsdSkhNm01JVwgpwGJyfht78f310wEv1mOk8DNP0OMtPVKNIc+ruFsYkYis92HoYyxgacaCqPk/uqEwiGFtNLReAgM4AvAxQcLkVTtvs340yCrd+7DF48r13yPVqM1b5ybtskVrkFjZIRsb4YlntnPxP5tymGEXDtgF5QqUFs6tZKsENKr
 Rbj5PaxD
 kYrDy5Z8RWRFG6tQfis4CIYhLz1rrJzQAEm9ztuZypOf+MPETafQZ5rqtaCtqLUCfYuCvLj+zqBCCT9VDO59zermS3ziCQqgLtTzgvZR+W+nUhd64twYjvQ3H4VC7i07JGwfpw0ZP0zB2x03/l8ZfDZ9t6jMeogt4UA81DyxQCAFkYFryOe7NpgQ+FKyUZiWSQmdRduGg+cYmG3vEJWY2CTgrR1aDFbXx6uTR+bqcB7wUAavGeSU0FkWXFkaRjgiZe7f8BrMX0duevRQm4uUBdOjWnuHmGxqf4mqmrQsn3KVjjr418DbCjJS4Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 12:07, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 11:16:03AM +0200, David Hildenbrand (Arm) wrote:
>>
>>>
>>> I thik it's what people tend to call this, it's what I've seen it called anyway!
>>
>> You mean for this monstrosity or for a mechanism that translates one value to
>> another one?
> 
> In general, but a quick search on lore suggests this might not be as common as I
> thought.
> 
>>
>>> I mean your German brain is being logical :) but by convention going with this
>>> terminology.
>>
>> Sorry, but which convention?
> 
> Of calling this error 'filtering'.
> 
> I'll send a quick respin and rename this to error_override then!

Thanks! I was primarily trying to understand what my German brain messes up :)

-- 
Cheers,

David

