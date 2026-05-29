Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F11BACD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F5A6B0005; Thu, 28 May 2026 23:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D4B6B0088; Thu, 28 May 2026 23:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75616B008A; Thu, 28 May 2026 23:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D60616B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:09:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8863E1C1D35
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:09:41 +0000 (UTC)
X-FDA: 84818977362.28.48700AF
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id B01741C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:09:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rPW2L/Aw";
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TK0Ooz++M6ADTeqrK3RvYBVcHOibgpzwEbnFPIpXtyg=;
	b=Ma+EmSryzyfDyGqTRljAL/ngK3a5JD2CxQVm44Asw0H0q1QnzKm1AW6TakdNfozS0m51Uk
	S7JqHpIqtWSWJ21jbC4qzz2upK2wYhESirwEbspbVfZ1FqYQFdg1DQMWjbAVvSk8ZITxjb
	NT760wk0uCZqKVHxOpHR4BwZEosFDLk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rPW2L/Aw";
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024180; a=rsa-sha256;
	cv=none;
	b=rrTDIO3GQUTkutcfzpAW6ASvbJlIp1baDyC7tDE6xSjG/1sOBG5rCxN2oAz8i0PONTDPd7
	S4iEavT9dL3FdmUZKyVal9F49K3M1TYPm5rNhmt3J36m2FoKH0E6SmLgOeXctzpzZVmYlV
	d54S4Zikm+n5iAJot13Am0ExWDUuCwo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780024177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TK0Ooz++M6ADTeqrK3RvYBVcHOibgpzwEbnFPIpXtyg=;
	b=rPW2L/AwIYHoiWPp2eOwE0adHHwnFnOKbGhcWqGIMYN5aqkat2mrGz4RqBT4mgPHOoKR/b
	ZlE0dx4rkYNhcztLXz5+G/x9mfCdx/BjU9xVDTgp6qacNPe3uEONvKerIPhutbo1UvuEGS
	AoYMONqZpJtbsaFd0uo/gZtTNsBzZwo=
From: Lance Yang <lance.yang@linux.dev>
To: yang@os.amperecomputing.com,
	dave.hansen@intel.com,
	jannh@google.com
Cc: xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: make persistent huge zero folio read-only
Date: Fri, 29 May 2026 11:09:15 +0800
Message-Id: <20260529030915.37767-1-lance.yang@linux.dev>
In-Reply-To: <c0f9a811-0286-4e1c-8790-8e31d95e5819@os.amperecomputing.com>
References: <c0f9a811-0286-4e1c-8790-8e31d95e5819@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j785ekdtg1umw6ach69cfcu49iqb1d9c
X-Rspamd-Queue-Id: B01741C0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780024179-270979
X-HE-Meta: U2FsdGVkX18oyBpqRWKnb7arFA3tx8eJLMUDM+zKefiI4xmQ79yXWWdH7/5svosY+lImLKlFecxOKbK/MV7T86Y/oHrvLBAqrTHOoxtk5hMENPaAq+MqwXqXvzzh1Kws27BX1jCFZ3Qz4wemMxapxS6dClJPpH5DQc/Je8/dSKekd5iRDKw1ekRCnmYS/dlLtJY7G/gtqOzIWnoh2tOMcCA9ta+aVbG8IbQwfmTHfugESw7Z9DAukfTN6M+PMJROxOljlGclr+rZDv3H8Iar2/+ziZn0IAAc7B8FkQp+V6XQFpJ5sSSzP8H2LAg19Vs7CQZNdh/+8HGyA4tqnVmam9ryGbUFlbj6A/FG+9NR5EDf/yQikS/jqA1qpz4Mc81PsDm98cYFhz0Kc5qg9A3uVhesUjWgN0tJH9zodOrWCyBzQ17c2+y1768vomYJ7cq6Dc7MWeg07zW99XAkHSDgqGQy5Nf67c/+xUVWmJ9aNvaNao2nfEBwiHY9lBWQF5yyz6ic6oP9947U5zNPGDWQU3gqfmzDHMEWve7gXB6taFzW9nYzu6D36bXPBRjw50ltYWiNhVpxmn4CnK/oKucH654lOdwhKmq+6lJ1WvtxxfFhTP7oghFLsHrybPlWhuVmEdUHwqtUk3geFLG0ruXKBqGCCYPt/9h85z+LwFJylVw3YnE1zUACL9tOZsdhLFldSfuOJX8e2WLxSPScrumt3+Mx54/L9KOH1BGgukKPomaIk/tdVvSD36040OPmAfDgs3sZDijeUAoe6g9t+S5Ak4zqvFkB2A1b0HjoKA6fsZYtRPUsVpD/Sqcvz8vyQ2AtRNZDHKDIZN1VM2uu6qMsaLbioSCCZSrARItB+tuk4gYSSrkfNVa2w2cSUOGphPFUmtGULO2VDx4yHHdTY0AI9fjJebdcR/Tv50BA3FORVQtnRufj+W+kp7GJsV2jXKPDH/Zbv15UYPB9TCUdEhh
 oEehUaP/
 2QNT6IpfqvuZCxeIW6Fjw/pJozR2hNItkFpgn+eLDLzF9esFwnS/1Nv/E+UEbdE5zVCaB6pwYvdLN+9h0xSpk7vO6mY00G7Dxv1fOf7ZUEj4TmfEJuneC3YTyILzJQNnSMx313Wpcu7SiAxzKujM8ubbgmG09SWh6xUps7Rjb7307PpRHYhpnEhz1SP3TlRfcAAxv/oVrlKe+0nckWGURo9CyVJJPPZaCj2BDqJpWsm4UX+81JPVApKoigr8MEKCrfPFHflZz/bYECl7+DpowOwY0kGNGTKWB6yJDpoUQtjNs1TnzlLDtKNOgOxUTVBbUZXe9fNnFyngZKzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, May 28, 2026 at 11:43:40AM -0700, Yang Shi wrote:
>
>
>On 5/27/26 9:20 AM, Jann Horn wrote:
>> On Wed, May 27, 2026 at 5:55 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>> On 5/26/26 20:56, Xueyuan chen wrote:
>>>> +config READONLY_HUGE_ZERO_FOLIO
>>>> +     bool "Map the huge zero folio read-only in the direct map"
>>>> +     depends on PERSISTENT_HUGE_ZERO_FOLIO
>>>> +     depends on ARCH_HAS_READONLY_HUGE_ZERO_FOLIO
>>>> +     help
>>>> +       The persistent huge zero folio is shared globally, and nothing
>>>> +       should ever change its contents after initialization.
>>>> +
>>>> +       When supported, mark the folio read-only in the direct map so such
>>>> +       writes trigger a fault instead of silently corrupting the zero contents.
>>>> +
>>>> +       If the permission change is not supported, the kernel keeps using
>>>> +       the writable persistent huge zero folio.
>>> I vote for no Kconfig options here. Why? This adds "security" with
>>> _basically_ no extra runtime cost. The runtime cost is, what, usually
>>> one kernel TLB invalidation during boot?
>> Plus potentially a bit more TLB pressure from losing a huge PUD in the
>> linear map, IDK how much we care about that.
>
>This shouldn't be a big issue on ARM64. The most ARM64 machines have 
>linear mapping mapped with PTE if rodata is on. Some machines with 
>BBML2_NOABORT support have linear mapping mapped with PUD/PMD, but those 
>machines typically have large memory, having 512 PMDs instead of 1 PUD 
>shouldn't be a noticeable issue IMHO.

Cool! Thanks Dave, Jann, Yang!

Yeah, that sounds reasonable. No need for another Kconfig option here;
one less knob for people to care about :D

For arm64, I think Yang has it:

1) Without BBML2_NOABORT, rodata=on already forces the linear map down
to PTEs, so nothing really changes there for most machines.

2) With BBML2_NOABORT, this may cost us 512 PMDs instead of one PUD for
that. I don't expect that to be noticeable either ;)

So let's drop the option in the next version.

Cheers, Lance

