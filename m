Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B9EC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655036B00A0; Tue,  8 Sep 2026 05:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605CB6B00A3; Tue,  8 Sep 2026 05:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51BD36B00A4; Tue,  8 Sep 2026 05:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 27B546B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:32:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B6CCA04E9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:32:24 +0000 (UTC)
X-FDA: 85190079408.24.B577891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8747B80006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:32:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is6KQl01;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idOnIsbF4aqGbbwgFi07xd+2BwFsQcBoIJ7fhbX7sIA=;
	b=G02Gx9BaXcuRfJLjf55uUbM3Su6bqAGFSDRcAYUmsV4Fx8bnR9Q+F6sm6xLvaZ1jF0lr0e
	LMI2fCxDMQPaoNCN8O+ydKsmsoNgwxCnCeydKqT2YGiBHVhSMcR7LOnEVzammqoN/72lD1
	nHTNwIhZ5Q87i2iVqrKuwtrqYSZqI1Y=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=is6KQl01;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859942;
	b=vyx9OTfK46pAbNLOngft+qw64S7j0M9rYjrp0v3ZXiGCZzsQOXB4P6B1ZiR6YmKOrfbb00
	plpDeMSfubDQlIKdGt79CPgdZN4zqa3tSz53km7r7ruo2FXRB4W8scus5niorzjXQHNmfr
	EDm+HIoO5RMWMrFIK1g5SVz0tzIYqOw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24499601DB;
	Tue,  8 Sep 2026 09:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C3E1F00A3A;
	Tue,  8 Sep 2026 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788859941;
	bh=idOnIsbF4aqGbbwgFi07xd+2BwFsQcBoIJ7fhbX7sIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=is6KQl01jgWMql6FMQr1xk4ZLTp10tUIpdaw1BuP5Rf1d3EdS7dMLKaiPRZThwuqD
	 Zz3wcM39/XWli/MFxs5l2NuNPSjlU8qMWXqNptPFuT4CFfVUNdkDthAFS1YK6zQLS1
	 nmtpMdpWmBqCCe2wIfrgXYPvi8EvGSNXfa7xlVQe2pGyMROlgXFPsY+GF1r/q/OwTB
	 p+s5pjSRGKJFXbW5tWnRNXxcQRntY9B3rZ83+pI7dTryfPaOjIWD6J8mfxP/35Wwg4
	 NCNXkDMfDYhL3azEtB6DmMI4zns9IM5YqZaboMTZZIo95XbBv3wHc3xcP0mVoCNIyl
	 60gxvEX45F9Tw==
Message-ID: <90cd8ace-b135-45d6-815b-bf7329cbfa4d@kernel.org>
Date: Tue, 8 Sep 2026 11:32:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in vma_add_pgoff
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 syzbot <syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, jannh@google.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com
References: <20260907192517.564ea15aa8c9d47669b3a81f@linux-foundation.org>
 <6a9f8bc6.f614420e.2bf292.0005.GAE@google.com> <ap_Uke89Q9LWoaoK@gremlin>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ap_Uke89Q9LWoaoK@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fe356qq6f5te86cw18hhjqrg7zfmbqpu
X-Rspamd-Queue-Id: 8747B80006
X-HE-Tag: 1788859942-889661
X-HE-Meta: U2FsdGVkX194ty2u1gaqk5/jakPUD6cNCFjtV+f+UTE16UKI0wz2pN3oNy86Rsilu52ei+gtfZ4oC0QUJ1L0EtNmlnTKmxAnM/Q45T89lpHFPKdLRn5tC0EEsTwF8L7jPLHAPDzXPoLoHS3LmTFR3Q3yeDdCCcBZLaw+htYMrsUMMliaH0yO/4pNeYxUm3m/7qS1X+QhOsmB3Jf4IL8y2niOrYQTxkE01W+5mXgYFtHLXtMRP8OkRY9YCI+TKIiRah9rspcrCFYtfgsMs68jBNU/F9zp856cLvXw2dMaHu76vm9SbDDkjuiVlvEX3G9bWp7qXOV3JzTgZ9DVMwCXqqKHVh2Qpi/b8dOfrBR/wkMZuW9p5uBbn8xGQtmH+2nVZAthzweFhN4QOmuZZ3CHN9ogDc4dJ4jRZqWOBomC+DB7PxrO2xxnlNvSS/IimkF2OF7UKFceh4hCbFkEUFxpDYolgpHmiCrDMpJlr7xKRXE8IHF/8gZ2HF94CA8h2dQNJs7i3oi/vyHF8dDc4VDETMKZ2bPCj6utwJwY1N02kRkx/cAtBpQlJyWZQOW9wd9SUuR0x+f7ylE256v0SNb1rrVRwC+8CZnxAm9nDQosFwToBhPw7/y7LQV/IkSxjbxuRg7Mv7OEE4RQ0rdEG6RQzYONmJ7cu/DjJA7tigy+R2R1hi/k4NjnvPmhEQKwUb6OOC0PAgr1IFqaZ+y2o73Yb2nodzkbtMYwsFLfrlLb0jMhGwJ+S3tWEve3JWKC+WP0zSc4XokM3jPd+YxTvFwfKBBUvs6krkJHRMfme5nUybZUitZi+iEirJXXcb+u3+lDQcYo1E3HS7zwpIZKg2hWw+uVn8id74dfQZnhAl8u6m1YjXxf/QxAMZ7hRPQHdAj8fh5FPknjyREhrPDZNptYNQeroV/eZ4vBgoum66iugZ8Aji1BDNM1WKHmOon0rC42SPkzcBLy0S/7jZENtV9
 o8vEURWz
 PWJe9tTh89OWmFvCJtXLxv4SoWfsYQRFdnWkp3tn+MXEtb6U9zeMqOok/+txYPdQbzn8dXzy0qHXMSiMYdXMH1wHQY/kWMeh6xtBYC0Z8qD7hnO1gGliOjtZRewK3hnLUNJ1c+Px24vyCWcpV7p2xQtG27hpSqKKhsWShOmrmshitehU6rjVk73xKTK8BTRiqvv7Bj6dKid7UCoI9Z1QKUvkDG9PymkDhigFEkSK8qugfpfaBfMroHRLeTa1cvMxtZ8S933F9J3x+qAmhWt3XRS30R59tiCo9g7b0TnPFGUVlvBTOesX3dCz+V7a2G1bSEGiApS865f3BrUqy6vs1FlAEkq4V9SNfQSTJFORy8Ngf+2KB12o3aVIVp4d1b3ZBaMe1DNktZVxH+80eUCGmvhqLUPydy5vHhiRckthbVtIteF/xiS2Q4OskaEDablWHFv2Ns60Qflmu2l3zfsn8Ksl9TtrvWyqiOqq6VxK0RhzbSaOOPkxOq1DE29qlTE+W97iHH0Wpy2rBPgp9zOO/w/ln7wRVq2aQlSbiQr+sPz3WV+eqHu5pFrhl2+5Gw9slnhs28Xdk6VNPNbCJ4E95sKetdruYHXbNGT1Y/nEsSkZnke/9ifsdqQmDq5zh2Se51NmFpWDi/EsmY17FY8ZrMv8aNCtzZfacEEYk4PhkqorxKaCRoA2lDlr3ibDKH4LU60iTAdVaE6o3V/ZKUXTqLG4Ed7jY4ZqIVEUI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:25, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 07, 2026 at 09:15:02PM -0700, syzbot wrote:
>> Hello,
>>
>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>>
>> Reported-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
>> Tested-by: syzbot+c6879dc677a017f0a21b@syzkaller.appspotmail.com
> 
> Yup there we are :)
> 
> Why is this constantly duplicating I wonder...

Going back to the first mail:

syzbot found the following issue on:

HEAD commit:    5445d6419962 arm64: Don't read GMID_EL1 when MTE is disabled
git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci

We can see it's based from 7.3-rc1:

https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-kernelci

And since the problem was introduced there, all kinds of development trees
for 7.4 (or even pending hotfixes for 7.3) based on 7.3-rc1 will now have it.

I guess syzbot has to learn to recognize it's a known problem and ignore it,
or have some repo of known important fixes merged after rc1 it applies on
top of such development trees, as they generaly won't be rebased to later rcs.

> 
>>
>> Tested on:
>>
>> commit:         35b0fb39 mm/mremap: reset unfaulted VMA page offset fo..
>> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15e13af9580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
>> dashboard link: https://syzkaller.appspot.com/bug?extid=c6879dc677a017f0a21b
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>> userspace arch: arm64
>>
>> Note: no patches were applied.
>> Note: testing is done by a robot and is best-effort only.
> 
> --
> Cheers, Lorenzo


