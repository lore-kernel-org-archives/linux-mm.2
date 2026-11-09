Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56762606D818
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6uwQaBR
Received: by kanga.kvack.org (Postfix)
	id 66B986B00EF; Mon,  9 Nov 2026 07:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6435D6B05B1; Mon,  9 Nov 2026 07:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559876B05B2; Mon,  9 Nov 2026 07:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A22A6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:53:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC54BA8293
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:53:00 +0000 (UTC)
X-FDA: 85415570520.09.B1333E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D1AA61C0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:52:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6uwQaBR;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794228779;
	b=QPXYPUg9XX+5XF95BlmLSXjOcJmKTZhgsFg0/F+pMnBk8d9Bj2QP2mznC/zlIQ/nVfmjI7
	GJTNVu/lFLf32xjeuZxo677ErdGVdTl0FDjj8EXyBaihuiNfEA5/9uIQP8Os6ZrGGqksNy
	71FJ0A/Sl/O6h52aplGPnmtlytm0TNY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6uwQaBR;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794228779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zP3LC9yrc7+EYQ3KUOm3F8j+rIcfao/8A+I3RWg+zQ=;
	b=5E0+qvXpAwo287Zm/Ow6N+Zz4oCKiHWpH8+rbJzFyL7NX6cakkywZk7UwaU/3ps4xbhs6N
	6FPvvXKv7nyqudhQb0wgcOXLJ6sWvfg8aM9kTbe5wxmML16tZwRxbXvgcXRJTebhbW+bQl
	5K3yXr/+UK7Dk8JS198RyMB5uBQFUBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A35A4048B;
	Mon,  9 Nov 2026 12:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629051F0089F;
	Mon,  9 Nov 2026 12:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228777;
	bh=+zP3LC9yrc7+EYQ3KUOm3F8j+rIcfao/8A+I3RWg+zQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i6uwQaBRn11qN81pOGhlUjq5/NtJOq4Nb005f3oNnH9WV/Ig+wYWZFnfQT+ZYvg/p
	 bc+mqfJ2iaFfp5xwYeAGncmzButWDlHd29l/c1EzhOfDrcrzpvFoY/i8gaiq9/+pi2
	 1qPNLODRB/Y4lf5qkpR9rm9NXOGrT9TGxfPtN3YfOl8CMpwDb53P5dV5GqGjlHxgUb
	 oXXfjkrnaggg2yQyJmVNu1/Ion1+P1XQAlwsLFqjpOPawhUDXc//J0iTQfQs8vsFeb
	 S8/Sh5vJGZy1Z56actG0iJNFFnhLEzX0jh7ofUpVnfe/s3SYjPZxsdEBsUkSGahNNI
	 qTYtDJ95YGZiw==
Message-ID: <54c78795-b510-4252-846b-cb8fe3e242fe@kernel.org>
Date: Mon, 9 Nov 2026 13:52:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: clear pmd in pmdp_invalidate()
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
References: <bf5c4e81-2c9c-4f4a-ae7c-9edf6a524d1a@kernel.org>
 <20261108102246.178548-1-trintaeoitogc@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261108102246.178548-1-trintaeoitogc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: th54unaj8hz33dg1eeopjk5oe6jjuxp7
X-Rspamd-Queue-Id: D1AA61C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794228778-518184
X-HE-Meta: U2FsdGVkX18ovWwIUDhi3QLr2UoK0DWxjLUPaJK/kwDWyPLLMQU59d8IzqicDCpVG/QHHVd0Xt6VwlPjv7u9Wkw28ZWO4uEiy9Fg6FYPpC8+44FLfBjLStDzluF5bBiZBgSvQHjL/UkUOeBI4Pst0lFskptkYEUgibDBv8+5lsYGuTDG0zfnHCenxsrg49Xe84Nyv4cvo84f4CKWeCgfwK+c/9NFiKV9hWZpERu0grz3aT25XsnVsy8aHBQRWzrs4TaG8cz9ELxaRwln4MBmDFgcb/whrkRP63xk49M1wohLl7J9+jJ5zHhwC/Amm70z6ZJN8yA64yDpbODibC7GgEV+d/Ngo7Ax+1UIw890h9lOC02nOsloew0h+4eGrJZt36PnThIvHbI6ErBbOIFbx/z6m8X8KPLu0u2NQrVVTTGaOdwvLxSjWqKJ5p/NZPDhnMA6lgjINJ6k+clh4G3AzMvaFprf4Re+kJC9C756mpCkKW3Nv7D0DjiKq+CCFNxzJoR3RAQxYf9w2XVZUPP4QFEUQ317bShfWnI/zv1nFvP2xsK+XXLoAbRtlJ1Nkv11Gxv07K7u3DVPEPJi3RP4Aj8ugHleCjx6XvSKUcYPIhxbt8g4idq88jfzvxcuPeBu9R88OmdLLgTy3/3JtCdivyJLQchth3MmNslhlkonzIyicZrvp2lCbjFZYTx8uVFsb7YjtdGFIcC5h/F6zdvSGG4SDGYEr0qC0/jc429oCDbH8zhna3tM5EBJcKqQxrS1LT4hLldssfabXAhjXNfGzYJu7Six0C7cg6yYWkKSXM+yAwR1m99MHxQqBgFuAGea1lTBVajXfxU4IMyXGEhQUVavrPFvajkNMXmLpIxrC6Qu9OatiKuEZr2xvPpEoJN2WsNuD0BXTOvw2ZuZO7YTCViG2QdCn0s9KpCvDHr4Hbzccl8af0HBrWhPD+sQow82DKSo3v7H5MIEb1thZ+t
 IggVStdZ
 Ggm4faur8Dk8vveRjD7cj7kTPO2fO4zyCFLYE6VtgN8vylmYYXyzRTPct2t/a6wzK8ayQqjNgmuJ3o/eceoe+Ke0+g7Q5bMC3Ujtnqw3xwj3ebgH3za3KYOL9mQpdNrFpWupvgAptixeUoOlviLBPZCoGHsuzxvZzpFwzk/qzO9YyN/gxAfaG7IlY0Y1Jyib2CxJw5E5Uu63nbbIfNTn3liOHYA1UM14mA+YxUs+yQXhklaXslmj1T6YV/RC2JiMqEgkm7eZm3v5/vTalOU7/Kakf4we8dC5wYyW05ZqDaa/UH6hZaBUOW5yGcJNyW3/fOg4caGcoqZnzFfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/8/26 11:22, Guilherme Giacomo Simoes wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> wrote:
>> I remember that Zi is currently also fixing some pmd_mkinvalid() implementations.
>>
>> Is there anything to fix from your side, or does the above fix already resolve
>> your problem?
> 
> Yes I updated my kernel repository, tested, and this work and resolve my
> problem.

Cool, thanks!

-- 
Cheers,

David

