Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53202D2A521
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 19:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0AF56B00C2; Thu,  4 Dec 2025 14:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2216B00CB; Thu,  4 Dec 2025 14:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E866B00CC; Thu,  4 Dec 2025 14:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 90D4A6B00C2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:46:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4525E1A036E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:46:07 +0000 (UTC)
X-FDA: 84182819574.14.DBF269E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4DFDE10000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 19:46:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0YcaQMn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764877565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1HqoHWxwVO9eyKjwsIdGGnTbmDZl0cXx/QMfsWGvwo=;
	b=BFvcwOD9C++SKKx1Hrsi710MhUeE7S2Ucg4f7UEN+Hxx5sKoEuLTaPTH4McJC+ZR0G59lu
	sayACMXB1Xz6c52lPpN1eaH+bT8P209g2Z2E36HOceJ8gIbsjMqymRyp+PcwqyYKe3GNXb
	3HBddbHbsiLMMuM/bQ4ESB2fTCF1W64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764877565; a=rsa-sha256;
	cv=none;
	b=awqB4smMVC8ihzQksv/EmIpk/2se+0lYlUNzhjYvtWJPTflclbdDzHvwSwZFFSEBGZjqvc
	aGRvST0qQM7aiHRMJzEro5Ckq0cvRbwQrzAaM3UPs+dLizs9JSI0X8DabMmQfQ6LBNZ5Hq
	6ajfpXI7hHxXVtj2ONtESfoQY1iIWP8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0YcaQMn;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3431740C59;
	Thu,  4 Dec 2025 19:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420FC4CEFB;
	Thu,  4 Dec 2025 19:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764877564;
	bh=aAQKSi8xzvUmhLEEthsE7YsJaouU3OspVMzy9V0zWPI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V0YcaQMnxiALXGBfC3zNhbc2oxyhQb3smPyeGa+JMOeyLDKFI6y9TIgsdJebP6Qbz
	 wx3MLprCjRwfVB+0C/WWZ7ygO0l6Dc9MNaCJTlWDGQY1qIXXzPjofAF7DdLDEzGelg
	 pbnbIiG7Wp1PAW/tPldpQgQB+FTxkkNF7T01gQeIdn63Ukr4Np1dWDrhnKQBEX/c4z
	 8ySXQTTmymw4v0S5kC2PPhgX2s8irgYgcWEEdWmXNxNCJFw+pygoyBwjNo3vAK0Hiy
	 ORwS3dnZzXUuIKpOuHC2uMIAUUmbzR1DQH9CzKQ/GlLxcVy0krp+BUlpwgFJmEtP7w
	 RDaXycol3+bdQ==
Message-ID: <3b6d6e50-91ac-435e-adad-a67d4198a5b5@kernel.org>
Date: Thu, 4 Dec 2025 20:45:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Linux 6.18 amdgpu build error
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Shuah Khan <skhan@linuxfoundation.org>
Cc: akpm@linux-foundation.org, Alexander Deucher <Alexander.Deucher@amd.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 amd-gfx@lists.freedesktop.org, dri-devel <dri-devel@lists.freedesktop.org>,
 Guenter Roeck <linux@roeck-us.net>,
 Linux Memory Management List <linux-mm@kvack.org>
References: <74032153-813a-4a40-8363-cce264f4d5ea@linuxfoundation.org>
 <1eb24816-530b-4470-8e58-ce7d8297996c@roeck-us.net>
 <0425d7b4-76e4-4057-83a5-a7b17a051c54@linuxfoundation.org>
 <ec77d11a-7613-4b75-8c9e-f2bba1595f0f@roeck-us.net>
 <9d520a1d-0b8d-4d30-b29f-230fc0f92b8a@linuxfoundation.org>
 <1f31b86d-283c-4878-92d0-ab90aed0c58d@roeck-us.net>
 <5af4522e-30ab-4eec-a861-c2760cdabd4f@linuxfoundation.org>
 <2bc690ca-fa57-46fa-949b-28b5441cd364@kernel.org>
 <b24fc85c-0e6d-42f9-a6b9-05136409098f@linuxfoundation.org>
 <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAHk-=whd-k3GhNGvVmP7W2p1d0d4ctqJ8iCuG8DbyKzgNqCL+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4DFDE10000D
X-Stat-Signature: swtu3ggbtug4cj4a5mx49j9yhbd3umpx
X-HE-Tag: 1764877565-373917
X-HE-Meta: U2FsdGVkX18RkYvO3L38RNCd4KBnajjaR0SsW3c0XCdrdELciXm0mFfUyEY+nIn6PC5OwbsD0azZ7GAkU9xD7KySV/UfAMyRK5ZxeVDG7r142RtBPI5NMWqftZD9nw3eylspiWTVfENKlBtRbjJY6QLCZtwS299ogOqMlcRS6/b5FcK+crW5qXm81AONZdSi7wuX06D9pp1nPZ3hnTr0XS+yS7h+iz7cefU5XwcSRdEyKC7IUYU76SZLawRY68ciQvSdCOLdgOeW6iRzB4NfUDgLuoxEE8FHkR1ZIh0gdesXo8JBG00eT/UDSlEyFeTC/eabT4+QvcF268hIvVWxCCBX7Zr/Q8/YvFOFgTG9N7BnD8iX5oHMJzd3NjSi4yoGULf6sLt+K1VefONfvYmcU16GDxBa9A5bHJFUGUBwDEmE8rZ0vxMzmHkRJxl4R3hrLaB1mnV4IEagCZwq++w/bwvW4yRWhXL4kiauvWC+/555KnxfNYcOE6VWYgsJsLI81+CZBGgedC/6QlUZ/WOFeUGi87WpuDk59kbmIKaJ5sGh1cd8RGo29F5SgTkHGgfW8vlxL6ePAfLTY3I0DQkY+VMU20dViRjHK29TIlHXuPhn7mC0li1UUfx+FV1p5nuNtb6Z45RYVj0iAP8c2fIP7NFulIBQeNHpN0N4UXmnfD02Y3oC35U+lrVBpHK1QsdBbPL0/1zjRm3y1APcYUFTRJh/AkTqWKPl9eNz9OEas52obhQt09aXjXtfBFxzT5QK8MXg1O9j8XuuRUVnHoyrOQlUiHWJcgX9eYqN8la/+KIbx/x1PltNmk/loabK2wDyhaFUDxGYQXY+obVRdaBLSIER0Z20Bnzjl0AT6KoUHYO07ybLT6cdwVcNUiFAAdNelx8zuQcueIzBhVPLE6Ki8hb5s//7/RO3qzNd2UqOioFfnqhF8HFfxiFwgHGNvZKMwKzcOJYAadqraa1lJip
 oGqtoJP0
 qNqxH85qJvbLbjg7xvIsygPu/0JeAg0WSh4eg3KUhqQCzBns3adv1D8mNLGICn0RyHnzAEHwoLQU8xtwTlKwM4ueK6L/NamgW6HCmU0weBYvnOWQpAq1lI4wcfvAcQuJnB5zDRxzZTXEuo7VNdsW3nHPIEXtYhiXSMF5pzfwvJq3oBg7exp1dvAta//lI2QTMiVfqoNAmVcg6sudomectqneYpmRXVV0SF8Krp/i8TOKog0VSdleNvPDguZS/04lvKq5FVN6PoXB7oP7FtshPY91unEZV54U3JUBzzb+SChRNBS0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 20:36, Linus Torvalds wrote:
> On Thu, 4 Dec 2025 at 09:40, Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> This commit has impact on all architectures, not a narrow scoped
>> powerpc only thing -  it enables HAVE_GIGANTIC_FOLIOS on x86_64
>> and changes the common code that determines MAX_FOLIO_ORDER in
>> include/linux/mm.h
> 
> So I suspect your bisection might not have worked out, and there might
> be two different things going on.
> 
> In particular, hugepages were broken in 6.18-rc6 due to commit
> adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero
> folio").
> 
> That was then fixed for rc7 (and obviously final 6.18) by commit
> 5bebe8de19264 ("mm/huge_memory: Fix initialization of huge zero
> folio"), but the breakage up until that time was a bit random.
> 
> End result: if you ever ended up bisecting into that broken range
> between those two commits, you would get failures on some loads (but
> not reliably), and your bisection would end up pointing to some random
> thing.
> 
> But as mentioned, that particular problem would have been fixed in rc7
> and in final 6.18, so any issues you saw with the final build would
> have been due to something else.
> 
> Can I ask you to try to re-do the bisection, but with that commit
> 5bebe8de19264 applied by hand - if it wasn't already there - every
> time you build a kernel that has adfb6609c680?

Right, that's what I also proposed in [1].

I cannot make sense of how 39231e8d6ba could possibly trigger it given 
that it only affects the value of MAX_FOLIO_ORDER --- which is primarily 
used for safety checks and snapshot_page(), nothing that could explain 
changed application behavior, really.

But while Shuah is retesting, I'll go have a yet another look.

[1] 
https://lore.kernel.org/all/78af7da4-d213-42c6-8ca6-c2bdca81f233@linuxfoundation.org/

-- 
Cheers

David

