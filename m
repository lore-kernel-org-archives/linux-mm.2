Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5024CFCA187
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0C16B0005; Mon,  9 Mar 2026 16:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC456B0089; Mon,  9 Mar 2026 16:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE806B008A; Mon,  9 Mar 2026 16:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A54B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:27:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 154F4B83AE
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:27:42 +0000 (UTC)
X-FDA: 84527660364.17.3A72FDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37EC2A0007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:27:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e69Uc8Lt;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773088060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ko96DnQ1pbkd7jrn1VyUcO5wife9ITpdPGTRbZgdm94=;
	b=dZ6xeA0olqda2ZSk9N0mPPbVfx97PIjuN5tGS93+RFFgC742EXD4LZM+oxU0jbqITtBPmX
	fUTqNMHfXYVkSumEoGBudAyUkh12Dr/LGM4ewNooV8TSMdYI8MZCp1+X62KI5KCCro1uFe
	BOcMpn6x01G/SvRb+75jNYZ0UfRKQvI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e69Uc8Lt;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773088060; a=rsa-sha256;
	cv=none;
	b=Itn6DZFx2yAkl/Hce7JyWWjRUCSat716TuXM5fCluWFTK0XPNAndDb8cIHa/HehM2NpdWh
	/lXz643jG4l10LgjV28qW2GHob8Cngk1w8vHQirnqEGC4KjlrabbyYUMXJrXTnubHTMvPJ
	HCkl8aCQ3XVdgmAR/JmJkgq36PAd0hY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37D214084C;
	Mon,  9 Mar 2026 20:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AAEC4CEF7;
	Mon,  9 Mar 2026 20:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773088059;
	bh=wZTyk3WEyk+xoMV2pTpUEy6GGip5sP188BxpWK+zdOE=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=e69Uc8LtxjwQYibBSKGbRDqg22pA8VRpPKRdSpllo7DCPCp2NC11L4F9JzCRV/VEp
	 flmB2rsG10Wxr5GQ8MnHfa8KXEJMV3NLq2c7RhRDu/wf6LAVUV5zojkBPgzaTq5+rW
	 JNUfMrQ8rTmBW55yCQc4MPHKOI6GP+1H6/aYMrLiG4i1NUSpdBTQWmOB4RBzBy+UoX
	 V1uaMNsCDwTru5ie0KajSCVg887xrHTo+jFtgpNGhVFQn+NG+q8tj9r9XwL6CtvKyn
	 LI3kGflbKQKKP8c0leL863s9nx1BF+fEdcLMBJIjlV+ECaoRtrWRMlpN5n9jqDRUWy
	 Sf78eeCyzvWxQ==
Message-ID: <ca6248a2-c442-4fe1-bf4d-9b9f6ba2de85@kernel.org>
Date: Mon, 9 Mar 2026 21:27:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: walk_pgd_range BUG: unable to handle page fault
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Tytus Rogalewski <tytanick@gmail.com>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 Jens Axboe <axboe@kernel.dk>
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org>
 <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
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
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <5f4d8780-55f1-4b60-840a-056da7401848@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 37EC2A0007
X-Rspamd-Server: rspam08
X-Stat-Signature: aimindusgy363m1fda8dwcb99kbcbuau
X-HE-Tag: 1773088059-263937
X-HE-Meta: U2FsdGVkX18hw0jPnIqCZVNZ1kZ6IaN7F29XpjiBk3Cwyn8/HD/IvhJYSTmEdcFhQzIKX8rPSkBTl/LVPFAn4ZpK+59T88ADbhEBAE3vka4cI3qD6VukHCxYg+t9BrFAXxZ6RPL1nhWJ2XYIxTlSAjDfUptaVdUTEbKpro5bdmgUWVHBMpANeKM5wY2nhsMM86IO86DrGpUwjZZxkfmOQfZvRA8ew7AD/J1NGPkWlNdx82nL3eLQSRgwyviL5Suai0sd3Ib4tfE7BoeRK4QKHvO7oerYujCmcf9/Dzq7Ow79/bC1f9RA9Gf8OoRbPaVIfqd7Sikyd4gd9uSXnwpLyTix/F2KlZG9r/ztx9sqVdjpku326MYLm/Zhg2jFVKym9wTnfUoEiwIWw+LkpU7KJnV5NjIbq7zXFLIKn9EifdLzUHEt1rZ3rfsyVi05znxf5NrOFEhrXF8Io0jMa0yUTeD7ga/gdZu22PPLmc26lx0QW5aIn6rpbqTmKnG958ZCBbLEV+J8Uvc3uz6B/vJrckxwH2RZ3LBP6SxQFJVGGocNlzOEJWIrZqqR1lsrqGjTPWfwURdtRlKiGX8TYN3xNi3HEIdiNe8oN9wFgXGwSTIWlX8xRdJ2UZvLB3b7eGARXpF2177ly6OQRyj+JfdoMePKG6P5hUlkxIkqfZE+C36UHN25WAqRPEg9Ig0ap1Xw96mFg4GP2rZMJEvaVkMonEe1oieGo1jiIn7GTegOq214P5MTxyPC8DNSuTvlDBki7+Zmd+JkTeXJrcgHKwli5s3zwinBf1vwzyEOvrCaoXE/1JSZE19kJgjzeZ27OO9+g/XjxQpXdYURvek5i0vihfwUcnwWVTu+AIkgmHepqcNy5Q7HiqLvkN9r2iJBkOZLOZ+Lgq2MmJ99miJh45rVEr0LZ3zsRNFomMkO5py5Jb1/5IThizpBIyXu15KLnCErV2FpS6wB8Ht5XgaRqdE
 m74PM9QX
 8iEayx16m04a2eGNftrxoQdZMHEOuNo9Y8t7+jPsgxsz05cnnzstQGP4Kaj7O52Nc++9Ar1cYVW5zkw+B7RkoJs4VOiUTW80WQbIPUfmZ/9eRikU3PdBD8bwz6oG9PVpg/PDS4un9B1BhAJlJYouBZuhPEE2mK0wsh+udaXhmfOVAs2DcT8nGEazoMdCP1slrHZYvwVW0yu4LZWc4cDcV7UsuspDE3+N+h3UKq0CQlFt0t/QeP8IdwGHLhRIgMtiNjZ9t86V2sa+hPYbzxu2fooDOkWXvdtOyUwwq8dJWcBCYrKACvqu17gWkZjx2mM9tA1NlzMPuBf3BGJGV3/p4/NMiHUdhBtwY1GZFuPLj47pobYLxIjdew64kUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 12:40, David Hildenbrand (Arm) wrote:
> On 3/5/26 12:39, Tytus Rogalewski wrote:
>> I had this problem on 6.19-rc4 yes. I saw it. But i cant reproduce it
>> NOW - this is what i ment  :)
> 
> Ah, thanks for clarifying, makes sense!
> 

The following issue might explain the problem:

https://lore.kernel.org/r/20260309174949.2514565-1-mboone@akamai.com

It would be related to what I recently said: "vfio recently gained
support for installing huge mappings into user page tables."

smaps_walk_ops() does not have a pud_entry() callback, so we'd try to
split (unmap). If that happens concurrently with a refault, we might be
able to trigger a BUG.


But it wouldn't explain any memory leak.

-- 
Cheers,

David

