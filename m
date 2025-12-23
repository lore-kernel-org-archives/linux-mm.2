Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93A2E6F06C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 08:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F9DF6B0005; Tue, 23 Dec 2025 03:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D13E6B0089; Tue, 23 Dec 2025 03:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FE586B008A; Tue, 23 Dec 2025 03:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6426B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 03:24:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BB1A13B2F1
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:24:16 +0000 (UTC)
X-FDA: 84250048512.13.10CA38A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DD663A0009
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:24:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S0htOP/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766478255; a=rsa-sha256;
	cv=none;
	b=vVqOai1AKiXVhFul+WCQWyRkbbjQSSYLlBYjwut30aEAeDPjLbyqUhEoSTsAznoEwVMv0y
	4FlWv1S+FjWKeL3jauzq85KG7WdT3Tbu1+HaU+7X3qSHlUFD53GO4p7IC9ASArPmSQnxUC
	5VL7pBF5KU0VZhFYBkmsXzTqnOMQdTc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S0htOP/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766478255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7A3yHlUbGTsu0rrCu87u4bXajsFAUkyAS+vn/CIl7o=;
	b=TRK3Da56wYI9RufZTjkj4pGFYUMX+odc5434XcTuzLFuhiLq5Cjn1Yh3I5F96Zjb6MkWli
	sNEtsmRk8vLTf+k+ag+1okcDzzlP76CE2Ehu2mkQRjzzsdEDam1qsrWTugwCQsOiaU//gw
	FBISYbeQCRJ6UmNTMaRTieB0/NJBJgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B05F418D9;
	Tue, 23 Dec 2025 08:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C416DC113D0;
	Tue, 23 Dec 2025 08:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766478253;
	bh=Cu3hVNe+vn/1Nl8EO/Jpn+yDlDMHQ7A+fr4A4oihm3A=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=S0htOP/1hh+2+c0XDJCBoL+dghPzhL1R9kZzGVyZU6rVMqjG5dwiHsMwoEgTNMzFg
	 N4dQlHUmbzlfVEdWMhNV177ArYMuuqtx4qSRvc9sVCsrz/RJ9y5G02k5atCmKJ3KFm
	 u9ieYeGjqSK7ar4CAb5mOihvdbVxpSnHWUKEB7K8LsDPuW3hmzRfO6Y++y+KlzEa71
	 sa/JVa+IccYVlwR6ZY7T1nZiQZq9JnsnO5AtzqvsrFmMYbRu3OSyGCmHYfunSjoK6m
	 xW1lJZX8VpTAhwpsX69APtL+OEmkVhhghu25+2oHMiRZYVcDxKd8yWNFtN5JZ155f2
	 ItZyQnBnhuOgQ==
Message-ID: <fa4d76aa-e5cc-41c7-81d5-d1c0024ffcbb@kernel.org>
Date: Tue, 23 Dec 2025 09:24:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
To: syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, harry.yoo@oracle.com,
 jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, riel@surriel.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz
References: <694a2745.050a0220.19928e.0017.GAE@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Cc: Jann Horn <jannh@google.com>
In-Reply-To: <694a2745.050a0220.19928e.0017.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD663A0009
X-Stat-Signature: owjph839qnieqtxqjrzufk84gd7jiymo
X-Rspam-User: 
X-HE-Tag: 1766478254-360862
X-HE-Meta: U2FsdGVkX1+vMrrKphYc+zqxwUX05KnVQO/Bs0MZqC+qIHYjo6X0bomEm9hYOOzJCyaftflUszb00QClXv8IfYDx7W5gL9eoltLeR1P1fcYMGLktsWFXh5fj9VtW216oMghsa+pqXsTNrmrXbJnsMI5n6XuP+sARfvGQM08zErKLpitPGakVBlOdwBurzv9eCoQr7oX7gtA9T1JUsZ7NQ0f1hOOVCrTLkhIv6ggbxXoGpM8Dn7LVrFl6Z7vVwKSgMZLRxmR8KU14S9+XZ624O2/uh7TqVo0gYfpA6AuewEWENwMMnbAr8sR9x2G+ytBIkh3NaC9kNqAxy7kJ+7qmADRmfMBN/RhuNizziWIdZkK3rcO67kX9NsCRmqNBu17KgmcQXbiXUBZMi52QgRq+IRsXqsAvL5fWigaugaHbGuGQAAjurJVelquVDQjxcghLtJKMlVPBnQC6XzC8LWV23hwuDynUgvV3PFcmcx/2SWNB6ordY2QEt7cKwcOy0KiE3jPVpgmRDfhocHofq98xjXERlisWVLygUIvy957oXOHDrB7eVh7dfxwbcWjJ7SDz6qQFWwAz9sTDpryvoni8XNoe+AHWDoyYIFGQtBtnhP57hDIyHJTXFFcgAMAeO+0J0Y3IWRJ+tUco8bekqK40x9bgQW68MJ7IdjEeMq8Ldheo8xf9lrMqM1Hp1CO1tRCNI5T4PzbOUyAb6Z+nTY5xucd840BTRv/Q4PY8mvG2YS6PDPvglZKSUbGCdn9bCkW+IddqB1FdrKdD8iNPTCpfUgBrrX2UJbq0DOpKeRqKepS8tqO+xbCM4+4k71BeTKd8gbtbLjYbZfUch3k0PkpFWlCslit5cwS+uup7ZUY3d5Q822GYFk9ZOpr4IWWQuHeO9sgH9QUQxPupys4Ophe5D8LCpZarBKtFJ+utzUa7eecUiYjArKA/84TR1UOdUfUDwsd7GVmHUI1LKrUkMWE
 IuFYGNdI
 MPJormGSFO2JHhH3mjGINLuwirZegzRyZUPUxNNCWuh9SOrdvmLBYFOT8MhbWkTYN7pMCbqYKUBEioij9c84Su5gzfd5+bUfDg/il+IsebtqVwFdQnENCh95BdPRSDTCYnb74QK2hjQRoO81r0eHaplN2GY7+9OWDnjkFRBkQ+HIBDZM+VX5CZw/eLYgerlu0adeO0P8fiWx+Lh62Kcc6loMvIUf28kHn5JDfk3y/CvDkQE4kVQTWblJ5DLnfyWDBxjZcHf4TJ4C2f4awu2hkHKbyZgV2mmZWc/MPkuLCm66uNhg62iXu8mYlD9WmnIQ6xQtMhEhqXqaIPcbfCtHRt+0N3uTosMR6oSsMQ/6QtZC7yKG34JfiSmmMCTBqmdwHWSEhggfD4BKFHqkp6M9NDHqEYU1MTlVtMy3IuKfSoADzU5HjlLnL676iFY9lXgg+nEOFiKeL8k8qbL1ES0FD2WUvivWipDgEOlU2Ty8OfqnzTfUSq00Zod7p/kQMjGg7CGm1oG1Vq3wi2sUvB9MGTzU90T6yhNGYGuIBsKpf8YHCHem08L8H6js10PBt7bKPsCRfZ5iaZKybjjvcNEQk8LTPbXJ5Vl1YyH0oAIHVGIeJ6OTvk85vRrohKiS7sfP7Ru5hNABcBwQeZo/ZO0V9xYTIZWRQGgq6UrFK9CJuF22iC0qwgNDO9dy6aHcLLW3IFV6hT5uXpejsvp3zRKUxCSP0NsT0/jZxsHK5lW4ALqcHpe+2JD4eHyZlEC4sLItvIFDHSwB2exVmXbunxMTWnUCBPZDMlqHJL99ZAl1AFwFoGx3GWgeXWTUcClGj9FPekqrp2QP8+c7/8jt3+0h5iuoDvVWvSaXBppdYAfFOHMv4OCy71XA8+Nh84yE4lV/608FumGSxgf9ExDU25XzBulDynYK9w4mSLP1E685Lf29MAZrti90G9HFNgobmIDTJ5o+V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 06:23, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1411f77c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
> dashboard link: https://syzkaller.appspot.com/bug?extid=b165fc2e11771c66d8ba
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11998b1a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=128cdb1a580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> 
>   handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
>   do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
>   handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>   exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
>   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> ------------[ cut here ]------------
> WARNING: ./include/linux/rmap.h:462 at __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline], CPU#1: syz.0.18/6090

IIUC, that's the

if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
	...
	VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) == 0, folio);
}

Seems to indicate that the anon_vma is no longer alive :/

Fortunately we have a reproducer.

CCing Jann who addded that check "recently".

-- 
Cheers

David

