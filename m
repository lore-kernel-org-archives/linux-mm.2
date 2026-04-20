Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D5DF36C2A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB306B00FA; Mon, 20 Apr 2026 02:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E756B00FE; Mon, 20 Apr 2026 02:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BB56B0100; Mon, 20 Apr 2026 02:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1EDE6B00FA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:47:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 375955B75C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:47:12 +0000 (UTC)
X-FDA: 84678002304.27.AC785CC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00B4E120003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:47:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j4epmrx6;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776667630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fc4cd5bq7sZ2w7++0hS3ePoxG3H95CYNSIueuKwgKCY=;
	b=OSpvF+0zAKeSaVDbWdy0dFn7meH6zMQTXfHh4+RoVmhYeKXOVmv5lY4E7G3rm+r2z3VnMQ
	iGvPya0W32DDnxgNJnDGIV/sahCycoMrRDZMwAPlYB5mMHmfpVsTu9H+hjqpkVeGkR41iV
	dSbZnhkS0EwkYbZtvwAe0mRA3qEkXJI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=j4epmrx6;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776667630; a=rsa-sha256;
	cv=none;
	b=ZZYIJVh+IdRF34YvkG574ab0vT4gXYDgI3PbhOjxmSJ/+s1J44K72U2B8wDGcvE7dDCsfJ
	ix+Da7Jx90vxHlXJCJtU3jp79MyfwtG3Ary2rBsjQFrgrApOGGjDzV8Kmu+QkW/5RPCctq
	P/HyXRZkwxBmJJ/3dsizukn/Rq9zubA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0650E1516;
	Sun, 19 Apr 2026 23:47:03 -0700 (PDT)
Received: from [10.57.63.177] (unknown [10.57.63.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84A3F3F641;
	Sun, 19 Apr 2026 23:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776667628; bh=FOT+rxetMCCm/Vt/n/onmxMCYGq9cNElSNypd+yNhnw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j4epmrx6ayUafCVEQ7h5jQnxg6ml5eCR2lSQ+K/AG8/lUgNRBeMqJIC9TwDXgnhFL
	 m4RmLBmEqyihwgMV+Er/qJM7r3qMVW+zoaiWAHClxUtZ0fNTb8Y2Qj6fEA/l8Wldud
	 UmkwT8YdneFQ678p88xVouNXYqX+mgCG6ljkWgoQ=
Message-ID: <c78a9048-52a0-4a22-ad69-4bb5e84895b8@arm.com>
Date: Mon, 20 Apr 2026 08:46:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <00b24db8-0063-48d6-8bc4-e8b670d8f0d5@kernel.org>
 <913002a5-e002-4001-ad19-037102d1f97d@arm.com>
 <cd2bcc09-2507-4ed4-bb92-2d53baedaf04@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <cd2bcc09-2507-4ed4-bb92-2d53baedaf04@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7sg7sw1rnmkp57udby4t8cufsmdid7ps
X-Rspamd-Queue-Id: 00B4E120003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776667629-340536
X-HE-Meta: U2FsdGVkX182CccKvt6FKRpidhGErPoSqrehzfPTcirB6kPSBTx+Jonr0FUPHKjHMKD3W3EusIJ2nWS3BBur2Xm0voXeloLJbFploMfR06o2m1cc43lK/mnqXSRd8OqSdmiCpZo+fTrgKfPW/4pIM0arMSvEycK7/49GNHVracMBZgfRFuAYnGeq6fu8vq7ew1jWSXj2TrB8f/2CtUOTHs9xp8X+MVDP4+2vJ9+g8l0lM20BvZMDhflvaFgJdJQ2SFDJgZ3bPIHii2eEyUXYWkycLM729OvBTnEgUHRGtAUD6UrARWOR0qr8v5D9tiDVpyAUrMqjQk+OO/2If1AFDaRoEi/fbqJ2RIhzcDoPDLPB3//mbfGcu7hXyjzPlELJkA9dih9hKaq+zpGIFo7oWr5BD94NOE661VDYLHxoolB26M54BC6dRZThMP4v2xm2AJ500t2X7Cqc2ToCraqwoc5l/old6viAXFgeFC8Pn0qHbQUBhMGcUC1oF30cL3sFYXiI15fa1dWf1BgHj82hmU0Ohp8OYCPIrEoqiUsn3eSX1w+b3Y7ly+F4SuEKNAMP+5INCj56ayfazr0POQTKz+ZCX7WKRIhKlopb8h+mWFXLsSC9iSpe2T3SRqkKjpbdlhFJjMZpk9HCUVu6TlMqX7BwY2DT1apBRIOaU3YnhiT/OQXT/htWtl4qWrSoz+aYoK6Qw+yjMp8TM1XEoR7lsB5ZOEHeTWBRZEER06jqGla4SmNSNYy1lHLq8E832fWHC2KOJF0bWQSEn0H/FBhrGlUlIEpgl345JrNC8KZHxABmB2NP9H+8WITscrJ2pxL8h8dLXTUOeVp7tbsaZqt2KbTzOl6PO0akeBu/wGze4uvMJz/G7WMy2ff4g3xw9W7iLIVQVKjrnWXqzjcjdlJSv8M2fSqoULuGAy+ckJ8+i72I0/uArGQs+WHOO7JwUK72WTn4kHPe4efAooZ/WUQ
 9z1mMBeG
 U/LEYZXlMBBS9JT1WdY4Y9aCrKgeWha/CzvupkbHeI/FjnxYDCSTqsnO+dOb1+9VqHmXerslPGjwbA3T0ResGu9jsl4wPdBDPQE0zX9iQrsx/x5f2Nxa0EYGB9A2S1lH7xFRRTzJrwgrejRaHH4heH373TpbgAjc7msp6dyi/FVOFQUJ3azPkgARiHmNQfnBrOexcDPx2j1RVAa0ejePzKDeALksdJuS8Yricm3ENOtmWWhyHTjjp8kKSLPVFichF+P9F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/2026 19:38, David Hildenbrand (Arm) wrote:
> On 4/17/26 17:59, Kevin Brodsky wrote:
>> On 17/04/2026 16:37, David Hildenbrand (Arm) wrote:
>>> On 2/27/26 18:54, Kevin Brodsky wrote:
>>>> kpkeys is a simple framework to enable the use of protection keys
>>>> (pkeys) to harden the kernel itself. This patch introduces the basic
>>>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>>>> the pkey register and macros to define guard objects.
>>>>
>>>> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
>>>> Each level is associated to a set of permissions for the pkeys
>>>> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
>>>> permissions according to lvl, and returns the original pkey
>>>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>>>> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
>>>> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
>>>> this is the only available pkey for now).
>>>>
>>>> Because each architecture implementing pkeys uses a different
>>>> representation for the pkey register, and may reserve certain pkeys
>>>> for specific uses, support for kpkeys must be explicitly indicated
>>>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>>>> <asm/kpkeys.h>, in addition to the macros provided in
>>>> <asm-generic/kpkeys.h>:
>>>>
>>>> - arch_kpkeys_set_level()
>>>> - arch_kpkeys_restore_pkey_reg()
>>>> - arch_kpkeys_enabled()
>>> Another thing: why not simply drop the "arch_" stuff from these helpers?
>> The first two are not meant to be directly called, they're the
>> arch-specific implementation of kpkeys_set_level() and
>> kpkeys_restore_pkey_reg(), and those generic functions handle some
>> generic logic.
>>
>> arch_kpkeys_enabled() is directly used in generic code, so I suppose it
>> could be renamed to kpkeys_enabled()? It's actually implemented in an
>> arch header so I wasn't too sure about it.
> I was skimming over patch #13 and spotted:
>
> +void·__init·kpkeys_hardened_pgtables_init(void)
> +{
> +›	if·(!arch_kpkeys_enabled())
> +›	›	return;
> +
> +›	static_branch_enable(&kpkeys_hardened_pgtables_key);
> +}
>
> The arch_* there can just go IMHO.
>
> I'd also do it for the two ones used by the GUARD macros. If we don't
> expect common code wrappers (arch_kpkeys_enabled() vs. kpkeys_enabled),
> then the arch_ is unnecessary information -- IMHO

Makes sense. I could just rename arch_kpkeys_enabled() to
kpkeys_enabled(), but I'm thinking having an arch abstraction could be
clearer, after looking into protecting sparse-vmemmap page tables. The
new version would look like this:

* <asm/kpkeys.h>:
    - arch_supports_kpkeys()
    - arch_supports_kpkeys_early() [can be called before features have
been detected]

* <linux/kpkeys.h> defines:
    - kpkeys_enabled() -> arch_supports_kpkeys()
    - kpkeys_hardened_pgtables_enabled() -> static key
    - kpkeys_hardened_pgtables_early_enabled() ->
arch_supports_kpkeys_early() [called when setting up sparse-vmemmap,
linear map, etc.]

There is extra #ifdef'ing going on in <linux/kpkeys.h>, but
<asm/kpkeys.h> doesn't need to worry about it. I think this might be
easier to follow, I don't like too much having an interface function
like kpkeys_enabled() defined in an arch header (not great for
kernel-doc comments either). Any thoughts?

- Kevin

