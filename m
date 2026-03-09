Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0487FCA18A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0BE6B0088; Mon,  9 Mar 2026 17:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89EDB6B0089; Mon,  9 Mar 2026 17:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7775D6B008A; Mon,  9 Mar 2026 17:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 658746B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:15:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94AE2B81C0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:15:24 +0000 (UTC)
X-FDA: 84527780568.14.9FC150C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B9666C0009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:15:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZLmbjWG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773090922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXbdfzh+Wu0AtO2gRKssL9ldi0d1LHPTYLVDpJGK54w=;
	b=qI7WxZGVXhxnUmc7+xDqvBM0gC0kSZJZMX0gfdcS4KXdbvRqHr5YjJIZiJqME43/I2bwjc
	eErUeHxQNq8kjt1ttNMejLtusaDntkk8lzkvAPVtz1BXr88ReVkDC5uQFTZJyE6MzWXrzi
	L4ApD3zKIW+3wt9l72ALJoURmfTPH1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773090922; a=rsa-sha256;
	cv=none;
	b=sVPGBtJa1BWdYbaXWNiV5vsIhKqDBs+5yzRhxr37cZoJ+Z5iFAURAkdPBeJsfR3O9WHQiG
	C5FyZ3gcJ5ZaBT2vEtFsKWRJIyGUkD8MlcX+rYRPILLR/vdDobXleFpLZJmfabrJxwy08E
	Bw7dXG5S7GrViYJp6itRdouOm/FxS/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZLmbjWG;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B86C243F67;
	Mon,  9 Mar 2026 21:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027ECC4CEF7;
	Mon,  9 Mar 2026 21:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773090921;
	bh=O8CDgQU9O+peXtjfhjG6PV5j3SbJFGD5yDvOqoqqdsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mZLmbjWGB64TSEztFsrdq0OFDIdi0u/hlzldqvi3QPwzvNgr4fg7+7YnYY18CP/KO
	 TqlQ0DCI7yhA511oXbEMPbIyvSdqW6emMWUpKadjg/sUsKijaqChmNGvby8VAK/tJc
	 XAq/2obg6itIz0zDbhyHRdEBkJ87FDIMCSPfbQrsv0JVRrssDhlgL29dmHp/fnaj2Y
	 AB1y9koIB/02bIsLRYOL9h7BrtPLxHqj3xEOLca3AzkAcni3pcnK8LDG3DfkbFh1VD
	 Wnu3DR3y+GOe+HMtRaxg3OLYSdpWSIYbqfFclekYLBao+Rn/a+stujJFo/fOzPm4bz
	 gqUK96zHS1svA==
Message-ID: <44967e53-d514-4323-b41d-8f672db0f97e@kernel.org>
Date: Mon, 9 Mar 2026 22:15:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org>
 <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org>
 <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org>
 <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org>
 <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
 <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org>
 <CANfXJztyrv3Bc-YtTWX64+tEWNGQE3cOdjs6PkAvR-aGYta-ng@mail.gmail.com>
 <5f4d8780-55f1-4b60-840a-056da7401848@kernel.org>
 <ca6248a2-c442-4fe1-bf4d-9b9f6ba2de85@kernel.org>
 <CANfXJztnmhn8AU66EjQ+G=vx_0VQKu8w8O-wYrTjHxBD_OaaFA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANfXJztnmhn8AU66EjQ+G=vx_0VQKu8w8O-wYrTjHxBD_OaaFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9666C0009
X-Stat-Signature: 69e7fsw1p4wtnf6mhansx6w78jcgaadx
X-Rspam-User: 
X-HE-Tag: 1773090922-95673
X-HE-Meta: U2FsdGVkX18n3ZwlH9W6m/vSN9OKdAA4RwWwSO3DINpUMPd8+1OaIMUNeFEYnUR/fDkOQhhBMk6orHYd7exRB5WlQiZ4aIDmw+Brj2pZ5PjyxejqnzPkjFTE41JWyhqV4ZAHjXVrylSKUb/dyLJhlhH7d2QTzY7m1nY1Sj2dVkduDN2DgV/2BL2E6UyM1lCHC6thV/mTD/6z7G6BQ1Lf7Biu9jaSGs5ZIAckVUPKM6AjT34rh1qnmun/8kTWUlukvt3+Zs8j282+LVm/d2s1Gr1T/JarC4E9wrSpeNj3Mvd+DuEFfmZaWuk5mH+k4I2Z2swvpzRm1rHpGGProI6PucWm4b8wgj4jf1m4v4VqKUk76k5+WiKzY+W7EKg590Sf26CdHnv8rUOK+WB8zWaHTCHDSGwJuN19CPYSGW+v5v9qEWXfkXrQf48Qsn9KbKm+vRjkRTAnP8UOUtX70hLVxkwZylM2UQjJoa5ictG3RxOTVw3QtUo+Xapx1JzEUbXei620PJ0mBYcPvh+qO+12pT12JquxE/9HpdvZGUqpG8PfVoR+t5dfih/PILubcidFOha/1djELnwgrqgsOeoVGqi4ReMM70BqI0ccUwYMGpYZJw0T0gcWyqjtHENiBUslYPY3400y1cx7ByubDfXVSMEgYo3nB+MmjLjhdm/5gCjjluwqoHLxiQh/bB1UgB/ZTuLdqSI9XjHBNhljbYpBqmtB+Brr3K/YDIcF2YhCbTeDgzsNgJJ4HR6/pdoCkWM7Mdf7ptMQ6d/OyciTkq5ovg3NdTfyOHJOpcEeOnORKbOUnyFS5r6vHkbRK9HuZEaY6JJ+UL+Jymk1YpJxlPLea9DFTM/XmzoSS8gdcLlSu+UTUu6Mu7xjJ4o+WgSoEg3xYvX0XH1yLwi3QP+aOsGhLhlt4jarSs1XneQw/gOGslYr9mLjPWBK9D9p1akcXr8acZpsS8psK2WPHkd7buL
 klNNsYXn
 Vjy8xu/HJ1ZzFWemxKl9sfXmXSk75BXPtXgD5IykchvkjxsRFTuMdTgEtN/mbp29lWpRSoAemFzJkszwnQIJgGamoFApwwZhxNsfWqA3irxO0e5zWnUVfOaUOo0KPDKFYfsWJcT7N9pPT5HB8Egc/5IpWh0LBIiEJAfypOmy4eNPzTOa3NyaibQcmrNHzZB77GYtrz5t0gZbvmn7+GPAua/cSGfSwm4lrzJA5MEGxWCk/3QVZxHYc2gF6KJP7blpA7RlwPZrDwWJc5pJ0D3tpDGhVlEXuX/rvkCjCZNA9CUTIC2dnYRHHE66BgGVI9AGcZrNUd7H3cUOXOV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 21:42, Tytus Rogalewski wrote:
> Hi,
> 
> Well it seemed "like mem leak" but honestly it was my bad assumption i
> guess.
> 
> And does it correlate with io_uring somehow ?

Not really :/

> Because i have no such issues when using threads mode in proxmox with
> network drive that is on fuse.
> Could be that triggered perhaps when someone was writing hard to his
> disk and that would cause other fuse drives to hung for few secs and
> that would trigger that BUG ?

I'm rather wondering whether something involving io_uring could make the
kernel reschedule more often, possibly in the race window that the issue
I linked describes.

> And using threads somehow fixes that issue ? Does that make any sense ?

Maybe with io_uring there could be more threads, the question is how
many io-threads QEMU would be using in your setup. Hard to tell.

-- 
Cheers,

David

