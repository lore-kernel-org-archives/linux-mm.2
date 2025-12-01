Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08353D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 19:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60AC36B0030; Mon,  1 Dec 2025 14:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA356B00A4; Mon,  1 Dec 2025 14:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A92B6B00A5; Mon,  1 Dec 2025 14:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3452D6B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 14:11:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE344B5E4D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:11:03 +0000 (UTC)
X-FDA: 84171844806.02.DAB64DE
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5485BC0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 19:11:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hFHgP5aT;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764616262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDLSW0ULC7fV+/6nJr9bGCnAS0M4/BaP2qnQFeyHNgw=;
	b=B4JhFK+qfCQlacPPbz3jygjm4LlK9aeICnswKHNdX7Ogncv//fF4bkHOxdt1yQC0H5H1WT
	Wba1+Kx2PW5nFgggaIddck/NodW+FIFvKY2JbdddEj5Vrb2zIrj55UWoJ4r+7BngC/2799
	9dlICN1Aq5ithtzzF/EXLM5byJRyqdc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=hFHgP5aT;
	spf=pass (imf10.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764616262; a=rsa-sha256;
	cv=none;
	b=0WKYpcdkJmrnWylka+L0LZOzdeh98AK5L9I9aK8/p8j5rKKlxjk5su03TBPf5tSuIapXqY
	fhITWHoEjQ67A6sBxB1L0PjH5hJWKKQ5Hr8CtXHlG0qIR6kDm4pv/0GP6IdHMn+r8Hf2fP
	Uruux2RGMx5HUavNLTqrKtXmqz/uB08=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4085540E0250;
	Mon,  1 Dec 2025 19:10:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rJExDO_Sw0EC; Mon,  1 Dec 2025 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764616253; bh=CDLSW0ULC7fV+/6nJr9bGCnAS0M4/BaP2qnQFeyHNgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hFHgP5aTyr+63EucuqjMPTsgEkr476XAmWkB7ouwdOpeO6lD+EHfTGjKk1oju7Xax
	 /nSihwUqydhbEZ2lilnJI90sx5ngOfaOMwYtUUsPdyPRnWcU0LCqHmZzAYPUjf48+p
	 ISt/5Uw1MNnAZ5+79krRIN8jzhPSTHD96Pn3lHUm1BvlH1vusAA6Ao6T2fJbKN5c7m
	 LnPp7beJ4qz9Ac/KY0R9BL9Up61PocDHWM/DBbEopy09bEb9I4Jo0Vy4hWpQU2moYk
	 ZgqFx2/XJ5VSDbYzI8a8UbX6IglDw6bhvPe7Neaas78ulrI/3z2BjG/q3eXfR7mZl4
	 i7hoXwSmJ8BV6n0v52C43eqFB0wFn/zIl/ZkNTxjkUVZ7BfPFflD6XvWMfTVM6Tfpi
	 5pn1whpqQoa1KOaUSzkWPNyeh2t3ACZBsAcKfUXjk8FsWhDO+lfJ5SJtLUYkXRCZZ7
	 czxDndKDjPgDzpRUMnVtiU9dW5lTa45WY95WmvQinLUEIpK/Rh4qN3H3H75CpP+EXN
	 T7Zr6VD7Xb6xpwFXWSuHo2Gxpxt7iPfgCxYS9eVKfzhUWw5SmSFhxcpZ/ojwUAQceG
	 H8W0Hyc63Zs/fj/leMn5TSP3RW9xbSZa4US5ond2t7MKRAaQOiqrjlzU3evr3FqF7K
	 9lBL64wAn/0+3O6jcZFfvD/k=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7350840E01A5;
	Mon,  1 Dec 2025 19:10:37 +0000 (UTC)
Date: Mon, 1 Dec 2025 20:10:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
	linux-mm@kvack.org, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
References: <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
X-Rspamd-Queue-Id: 5485BC0010
X-Rspamd-Server: rspam02
X-Stat-Signature: sdmo71ha9jt3tht8ckoidaxe1ifbp6t7
X-Rspam-User: 
X-HE-Tag: 1764616261-49802
X-HE-Meta: U2FsdGVkX1+XDEwMgZAcRU6e/M19ufVHCURSEdtrpWX6D3+YfRvQz5X8OT1RC3jaOK/VFDgJhjrhssWZYY37B2+jbFz70CEv0gBe0r3dtgcpCyu6XKiP7nvBtdnDwUn0vZVLiiyi4M0MAvz/rty65BvObuc1XywJipqzKHimiNQayBtcNu4RMhoLjW9XJHByQMRtdY1IDBJmkhLLpkLB3hlzjC/1eOIgD/rRL09I7YJ5ZFNFJ5pC63KOkXSUVNSpfKqboG3JTzC2nRauBDaASe+2ZVDPFqGIHgIXDB0M3k/VpBIsZlIaAi071RKl1uMB3fiZzZ/souAXdINeX59mH8pBm6kzCT2juyTsVFW16JHkaNk2pvUlLRjoI/tNHDzOwXcb6UxUpeJfUOYZTbApftIB/NxXS9d6rRcKs5oXLRvjGFJ+buISbgS/sbb1QVdRORPjY4LSCSgMlAzym0GPlzaHfmaKqG+touqOoJLFWUIN7r7Vvrj5qwK9KjMLcLK2sJzQ8VI9Cv5E1UPWqZgvGjZSF5JS99XK8sCSZH+phmxbKmjUVKLYj9YO5CtxEXKnDxVyRIyMg1yAWY8HbeQK0y8+HOwrE3k7edU+PHkbDHsTUXeSreGJhzCUPR7X7QadKLj2bxZa5kgIzlCYATz3WaGAf5V9r7oy0nJemJGBHzXX8AJcIAlKr43vOeDt8Fk733ank1nmNUL+wGD8LA+Fnb0S61r8wHsaQS1o/NmVVQ6LAXvAmiKg9yhqBYFazOsT2yqUgFGe24qyMGh7nLFpHEwJzu4RtZAK5DL2wrOYzFJrs4UU6LD6NPhER9DwFPVwrhofrz/4jcdjofEiodg7hgaCHzLw85ZIFKYRdY4KfCQiG34qEaP1voQWpcsyy2XllVjimyqK1r/aWvJisRk6daNjhLFgGdYWJG2MJxhQskBrgdLPrN2+NFoclycEPkj894Mwzt7sDoNpUgRJw8x
 NnhIX6wT
 BtzQuoyyuXQ6osqnki7k+TUnlZDnhwjOXRvJ+ZAg/Oc2muq20YGBBrVxU/hl1gTg60r8okoMug41PkqHOUwV5lmjlHwWDHUzMs2ovvLHzcMW3NXKPUKka9N/HqTDs5Ult63MbRj8kqmgvkElKZjSw1GqNllGrNA6X7QYGknmJ8zOEOLOVAcv99ro8V4XXFMHoPRV4H61hgEYUDwKhiy9PmPeBKxFwVeECeaqzsyFcL6q8Z2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 07:32:38PM +0100, David Hildenbrand (Red Hat) wrote:
> I think we are in agreement: from what I recall, this software contract used to be
> rather simple and stable.

Ok, please point me to the *explicit* document in our tree which says: "we
won't break the kernel and support kexec with any kernel version"?

Something ala Documentation/process/stable-api-nonsense.rst

Which says things like:

"Assuming that we had a stable kernel source interface for the kernel,
a binary interface would naturally happen too, right?  Wrong."

Which I read as a "no" to the kexec question too.

IOW, it is not about whether it works or not - it is about enforcing that.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

