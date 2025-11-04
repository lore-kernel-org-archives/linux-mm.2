Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A706CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B508E0121; Tue,  4 Nov 2025 04:33:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22A18E0118; Tue,  4 Nov 2025 04:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F598E0121; Tue,  4 Nov 2025 04:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C56228E0118
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:33:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7500F1A047C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:33:50 +0000 (UTC)
X-FDA: 84072412620.21.CB1F3B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A69A880017
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:33:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kWYajnxB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762248828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlU1DaZLxe6bDMLkY/19iz7w5qgvc4n2wZxAvdNiWyc=;
	b=O1RMgT1b9EXzfDSt0IvRG0ijkW8h+WRwhqz4nA4ByFT3m73jrLAZIyiUY4VJbIg6Ul+ED7
	KlmobMN/Twjhntj/epQRscUCdaGBoHS2dAPckAme2pEBviNxlFl2hvW9BXj08FbFw5VN2u
	V+2y8KiWdoias726uSq+SuvMSqR5UyQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kWYajnxB;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762248828; a=rsa-sha256;
	cv=none;
	b=IWva8aUAcgUoja/nF9wd/ra6dlPqrDPiFESUvb/FJ23yhlLD2a+CltvQeglVILF9IN0GKv
	lnOEC2P60zx2NkhiICbvErk4YH4IB8uOBAiDiYp5NvJOukjRDosXD90vPiWLzglSIACR5H
	1Anu/2dvRqsme8Y81RqFBAU5nf0LGKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A5FF4180F;
	Tue,  4 Nov 2025 09:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5A0C4CEF7;
	Tue,  4 Nov 2025 09:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762248827;
	bh=W8xOsfIs+FLN84wwq7ugJWJ2PpWVMPpw+o5LSPIz4yc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kWYajnxBp06uW/Fbs79kSGCpFkkJissFIjAueVxphZmrNwxcidb952mL7jDfxfeEM
	 XJMcOLucCMvioxcRc3UuMhSygFZ8zEozO1os6GUUCJTgBUum6a2NOM8ycJBo5ZvRTh
	 q4qL41VoYqesUXOIgnoz2xmQhohvfe/NCRDL5wM4+B6SkjG2MOumm3OV53+g5VcYQv
	 Ey0IZONjjtkNzP6gyl/+Tqlhe8/uPT5DclF3GHsppa3KQJ96pMpc05bLsXTfHlyR57
	 BgWJpdf/tcA4ihoVrCkv2IXq5pvCtMkA2PH3WTW6bAMPkRrAoKbNn6oZhbldp6jDjX
	 lisGYz+Rk0wDg==
Message-ID: <1b316667-470b-4e1a-9c18-e42571e4769c@kernel.org>
Date: Tue, 4 Nov 2025 10:33:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, david@redhat.com,
 dave.hansen@intel.com, bp@alien8.de, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, luto@kernel.org, peterz@infradead.org,
 tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20251104072306.100738-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251104072306.100738-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A69A880017
X-Stat-Signature: qd5qhj5picc7ix9fgtbh6ydf9c4oboer
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762248828-67789
X-HE-Meta: U2FsdGVkX18eQYaXK4O1zsjxFFAd/eoOmAOOeTkdHnkUZcDybbrYwvrHNJpZc0548gRtud5stBYXcDJSZxHN4sHUDM+5W6FNLGLIEY+BKvqmTgpel8EcN3Z2sin430kh4YrlDWBa9mTYnny1HGtGwBulpA55CI8Frao8APd+zzmtsGRd3uu50Jf3LcV798E2WP9kOKECD2stScBvRg27OdEc5ESKILZc/RSN/Ctt8Wi+Bb9lTXzfSS07mHSggttC+pJCCzHM5sIj+lLrjKhrBpJoPRZC0m+nd6AParjjUPBvwH0mp0p6nDokWSxBflgGQeiVqx/qN3J9jqSnrXCvZU1JaGedIyCA66L9nidWvCNrSZKIj1btZMMNLKtay/PjDxv5A/I6M/jhYQPbgkvH0COviOOTT2ExGE2Lek2NBoegeDh6El9Yf/FVUNltqykRM97HwVnsY2genvlZP/b7YOjUvs/nhYqUzidqhcg3KmIRIz45kQgSu/1mbCWrOSj3+rRaEPsCOepo1WaIETyDe86oW/PseNznuRBodroUJsyi2h4uNkanKBzFNPBskoMv2+WXxm7Xi8KOe+POYPOyjjwTryY9y7qhkmtRQOT7VR1b8iN04B+uC/M8vmKU3pPjjchriRj8PwhJKsDfzyNVVgJdV9Y1MsufrJ1JUvAqRa4+0SjQ2b/GuF+8h0IFo+e2o7sx75ymJXYmIZYWIGVHf86N5Lq2p0JHdDhzSFut35wNPUao2x8a6F+3prvUlAtghMexDAhahtlE+tAA/JBW8BvBGHSJE/9oI7hRG06qPUwzOKis/5lmnKOHsb4apQJRuhWCPR1E+i1v/zjzK06KkbN8k+ndWjvaYyrBbsqWAtGD6/D/DytLDiBEkqtom8iChTjRiZsLSZuFEJmijwEjWHViQinuFpy9mi6kDq3Ewbc+U31BV8I0Bt1JwMkPSuG9ZBa5hm7ZUVRT3HrtSVd
 FZ6Hff4W
 kBEq8ilhp6Ki8TWcQRGk2MO1dXWn5drNLLBvND/EFZ3pW7A5HRkCrKoZQJhmoIaU5H0meHCrXAkvUO7DjLCwNzpJAoxUU7/35uuW4R/CZxYfJUOiTJqco01BvdCu2C8Im9wsaEN0HQjgNmL+GSh8pgQcbF7TiDHCr4cwzMOVvs1PTPyQvk6CZXkmLTuUdGJsTy0Uafb4irSJdMSubdQZYY5vEW64RX8HCUGXf0HYio6Ot5SSRDQFc8pnJXPm9Ipxreq/+WdJ9lRaJ+ToRHzIgWlLYqLXpe51HXRGCc/5TOd5nfYU90KIYqTFv7jMMaZDCrdAPXBOyoWADYlXLrfXdJ+UI0EguM7BVleHttltjB3ubq6iHnRMwkIOiABA8IJ97Eykb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 08:23, Xie Yuanbin wrote:
> Memory bit flips are among the most common hardware errors in the server
> and embedded fields, many hardware components have memory verification
> mechanisms, for example ECC. When an error is detected, some hardware or
> architectures report the information to software (OS/BIOS), for example,
> the MCE (Machine Check Exception) on x86.
> 
> Common errors include CE (Correctable Errors) and UE (Uncorrectable
> Errors). When the kernel receives memory error information, if it has the
> memory-failure feature, it can better handle memory errors without reboot.
> For example, kernel can attempt to offline the affected memory by
> migrating it or killing the process. Therefore, this feature is widely
> used in servers and embedded fields.

This is a pretty generic description of MCEs.

I think what we are missing is: who runs 32bit OSes on MCE-capable 
hardware (or VMs?) and needs this to work.

What's the use case?

-- 
Cheers

David

