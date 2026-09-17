Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486D6C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D506B008C; Thu, 17 Sep 2026 14:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE006B0092; Thu, 17 Sep 2026 14:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203036B0093; Thu, 17 Sep 2026 14:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04A046B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:11:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F278540461
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:11:51 +0000 (UTC)
X-FDA: 85224047622.17.44004A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id F0CFA4000E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:11:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iCgIs5dz;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668710;
	b=hANtp08b2IL5Q9U2pFHQHFyp6UcF0mHIP0RLM++YkE2V/kptNzGdhA2+aMW+EQ4kWotXVV
	BGsuaBKCPsc81/VFTx/YB2FgFN0rpdLYlxxggNRZp9WESEXclqBrLQIn9I7z08434QGABV
	qvDdA5sXaonD0CVuw9Jcui/xllOPrzk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iCgIs5dz;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H66u+La3BKMWWXlFlTrVsuKaNwpwzDBaFVCwWt2d404=;
	b=vMpIZKIhKpIrgAHuS0U214k+wktITgnMJENnu+rA6j0R9H/XPklj1wGgm5ekxTkskzJqrA
	MEfMBmJupMVq4beczC7tlRyk27Y4+GzrRLKmtgwfyzVXStQsjXLE3z7lbQ+7w9ebxUnYz7
	lbH6ZcIXu1ilE/drvVjKlQqrz1tHPP4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63D881F37;
	Thu, 17 Sep 2026 11:11:45 -0700 (PDT)
Received: from [10.57.7.135] (unknown [10.57.7.135])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F8A43F86F;
	Thu, 17 Sep 2026 11:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789668709; bh=H66u+La3BKMWWXlFlTrVsuKaNwpwzDBaFVCwWt2d404=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iCgIs5dzYG7snhIRdFqpGaSsJVsl0ixJWXw9PoPyfIlhokN/8nNvOsj2UbtDvKCha
	 Tp3HrxbmHWFO2gKUtSM+qK7ECcnPdfRqQfxj3IWzJmi4UrHCG0lAtw2aUeVU8zBH/z
	 czy4xKGN1iHjasunQcaQVI2fOrM8IYWtnSzeyYgY=
Message-ID: <a45bb08d-cfe3-4d65-bda5-421f14347d23@arm.com>
Date: Thu, 17 Sep 2026 20:11:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F0CFA4000E
X-Rspam-User: 
X-Stat-Signature: mqtwie7pxntkj7qi4xe45aj3xy8x47t8
X-HE-Tag: 1789668709-812804
X-HE-Meta: U2FsdGVkX19rrI1xVytb1SP7At0z7V5BRbeLLfRpKTZk2zN9A/oaz7ayyyNmPYKK20qD7RiliPsMrwP8AxLkwCAOgIUBAiieJvqPgNIbZIb5E1i8e6vV9b/A4ZflVhO/1WcRhO8NDRZc01Sro7Rz0II9UWMYGrDo8QwE5E40Uy/VLpIakkhrzRw4gNLsHsCpkEcstcgSDWN7/rx4DXRxAhQn90uNJjdJzNNtPjyHVil2QJRUdoejfuykAUIMT2k7TgUGv3BnR89A+unj/k4ajVempz4Ob84n+0GHXM2gcXq4HTGqHMpLzgSCngkNYKnpFFAy4V4VWr35YIRisSgty9EecLw6kQ6U/2Y9fJMJRewZ3yFV97CB9fa8tko7cTLkXjQuYcFaCUbHkSaVlsCLxeyOqXWHtCYNC8sKQMB8OaYJ1M2wAJKD/DDYo8HDGS4vacy284BEmZ7hIfI3bHCcRopBc5BucS+U00LjY72A9Byuq0xr40u21SkSzVaOEG4fekJIht/AeUI40eyA5Xxa4VM+slwcxpvyPPwn+F9/cuVV0SSi8DHWvIKvdniM6/ywouIl8vVnYuPlMMf7ATqHjA0H57BDpZ+zS3m/WCTX4+eKbBEgMegPJWfIxWV/yz+Qgmx4LVgxTV7EPEO/+7lSM044Ha8zCgz8ZEmyWI+kdaftpItr3E8/rUHOPuMDh+6GUmO4ef+1mhM5Uzyi8/WIzvfnP9xTIEusj/aSZgKoNthjmYtuBPm4SKNQWEJB8EX9j2K1xPgM6fBpy0Dd5s1Kv53WJnxOvy8sVHb+HFnlfp64PB44rUH8PFLcAnDzNQKqfQY2XYBzKj97k2lRVeoUTf9QfgH2N/DbIN+XTAOTC128RHkz3auyzFv29Bsl1XhVk/mjOt7jgPhx8fQoRl+PrVRsxsk4eYFuva938buJbqEJXn2gWALJQmXheI+GVQUedjIeaxKyjG5DQFkbyUZ
 pUr+dSu3
 /OoWCBHWzBbRALcyODfGdEKluBZnoC4HQHt74Lgem7+4Mi+19J/W+eRDB5kbKxHhIZ45JJbpADusA6IlpG2QXqv+Sx8teeVrGtafgpOzhPUIeHy5e9CdXN6q8s3i88z6wIUhi6o4GKWJENZYKuhx866nHsL8ZZ2IByNOn2Ysxm8FnTb3LF6cVJDcKw3WTLoz02nKG6EG4qWcot0Jf3wEL08hRGNs8KbMxzW3NvDfDURBlhfdlVUeoXX2YUTQ+m1igMnuOEDa97ixAEOCK9mPMMjE/eRRlWYg7WYK9HHkcw/ITkQxFICBeMNJWGKtFY/+WzUodTwxk7wPPGXg+ehBd2Lzts0bJRvLQmZg2xvUQl4jp+uU04fl2OMtfy5xfThlRXkmuGNlImN6w9G0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 11:28, Mike Rapoport (Microsoft) wrote:
> get_vm_area_page_order() and vm_area_page_order() do not need to modify
> struct vm_struct passed to them.
>
> Constify the parameter.
>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

