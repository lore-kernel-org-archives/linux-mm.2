Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB21C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E446B0280; Tue, 18 Aug 2026 06:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36316B0288; Tue, 18 Aug 2026 06:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D725C6B028C; Tue, 18 Aug 2026 06:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B05476B0280
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:59:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44CF0160B42
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:59:05 +0000 (UTC)
X-FDA: 85114093050.10.419B1F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD92540002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:59:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihoilFAp;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787050743;
	b=bGdvnGCCwMwYD2gI4+TXAAyDrRTyCYxkUwGV7cx08letfma0QXhDLDwHWxeifK6gdvJsrx
	IbmzyaN2f8ayE75zc5zbXQ1MZmtmR3htTE5LWyvg+ItWHULR+Ct6jx9XXIWIhfv+7/Ipja
	dsH237LdlOHXAs6J9Y6lTU+Lo93JMEI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ihoilFAp;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787050743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Koz3r/AfThNLRrBgrtFERGCjlw/bQbRflD0M4YMQKNo=;
	b=iEnv35EUrY3zcIkZq14srNA8G5XWChOt1cBk1FBoS0zaZIx2ua2QlOS85UT98gEYRko09p
	NzuTSOqzLWVjyY2JUXs7zGxkXJh+M7+OVWY84qlV85xdzmy/db0hU/k0I04UdyNR42effW
	YiZZasTPiMS8G7NATK1Eqdmq3dVB3HA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34D09601E0;
	Tue, 18 Aug 2026 10:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3811F000E9;
	Tue, 18 Aug 2026 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787050742;
	bh=Koz3r/AfThNLRrBgrtFERGCjlw/bQbRflD0M4YMQKNo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ihoilFApSOAE34vYAawnEXEPs2f7u8XzfhkPsgG2g14u5Q5sWxPAMOf71YALTPv8v
	 fZyOdM6N19EY1DCuJzEcAgnNo9BvWctVjcxlxlZit/W1UkRoq7AnILj/k5I3fXHckj
	 grBgpSIdu0Uxj74rIVP2vJjPjRmaX/GeuFFr/SaBlUOHJG0teMz5FRbtdoS1mfTTJB
	 rv0RjYc0NXjBPQIsE0OKcZEy6Z5T+gJWmnkPZfyepE74gvHw2bKL7FMJuDxlOVEaTm
	 mjg1MlR4odsf+vaZlanjE2Ww8L2FXJYF7SZMeEpBWtRQBMi5LcfJ29f2343Zn26qLX
	 CFZBDHwCrHJwA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,  Pratyush Yadav
 <pratyush@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Mike Rapoport <rppt@kernel.org>,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  Thomas
 Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>,  Borislav
 Petkov <bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>,  "H.
 Peter Anvin" <hpa@zytor.com>,  Ard Biesheuvel <ardb@kernel.org>,  Ilias
 Apalodimas <ilias.apalodimas@linaro.org>,  Saravana Kannan
 <saravanak@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Baoquan He
 <baoquan.he@linux.dev>,  x86@kernel.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-efi@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
In-Reply-To: <20260817145231.GA579285-robh@kernel.org> (Rob Herring's message
	of "Mon, 17 Aug 2026 09:52:31 -0500")
References: <20260811162642.3504565-1-pratyush@kernel.org>
	<aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
	<20260817145231.GA579285-robh@kernel.org>
Date: Tue, 18 Aug 2026 12:58:55 +0200
Message-ID: <2vxz4igr1yq8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: AD92540002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ndnwco8r1epr6dy4dbngpmxbj788x9ia
X-HE-Tag: 1787050743-936849
X-HE-Meta: U2FsdGVkX199tZcexhpb4nHGRfmTHAjb31YTG4wV8XKDMOTkaEax10pbAymomklxyafA/euxO/uVotO8uJ7Mnh49/tpgudZC/8PotIkj0B+V7mODy8rwqXhsyAyPYRRn+EFM24nMedgBz8l+LS4KjD/3i4RqG0lQ1mREJUCzdYei4CNA8cj1O9/3OtUceSxyb/R3iguJ4GT/jJUiS2aevksjSfeexDlGemdnlTL572wQukopYau35pcSPbMaDEUTeov4KxNQ878B2pG0RtypmqcK2vEH7VgqJPriP4+xeeqxrxTBV9T2LWo6Am1mhrE68vh6oKA98oqvTEDq+dSw5cITwj/JuFviLf6FH6MrgMKLJ5NEGF651bV9NTQ+l4AhpllZpPCQWkFsNLetDTCP5gOW3dcdoY3W3pONYmKJ+cBxkfuzh3Na6iEouCpyj/qIu4S3DZL5IsUEHoaKawW6k8Baibl2MLXv5Rtxr+lCH1q+ubpjz1ZFvviEHZ1YFLFL9EfVSxCCX8m4ewFC1W5Jajmmoj3EvlHt6gq8N4hoGjUcfc5sZ59zqgNret5zlnzFIRXpo45liBgvTUNf/YBgevhkW86YPYki4S0WIKYb/07/LAFLD52HlO5jBHaI3qIkJhxkKXZc8xN3raEqmcaGo9xMBlJfmE4YN6feNkcBUdUSAoj17LTqLMWXjTUR1H5P3w8pJoz7lDlaHzxXmrmD1xnJobrduzDo6sO8KYha6V1M8FQJkaaoY1BpCsq0LsrW1NSOGPND2HipweMMAI4Rp0bs48qC+Q0/9nYzVKVLQ4F57Fromx0FS7XKpI82qMrwT25UFj8IMkF9u48qZL58ghSoEtlobth3NnZhUfhk1kyhzThjcPi6g02KgZX7V0UtB3clkvcaMnJzR0YkmZhi5z0gtz4mTFT8PzBUgaz4ZmTEDN+XPPjQd7X2OuEu3MxDunmmTm3gwSWGXsBtl72
 38Tn9V5c
 U8s2btbH80SkgJVxwJ1+W/wKUo1VTfRB1UoIbYnTAOPRfOg71ToLxqcN5g99ahvvSaE+BAUUEiddrFAJZDNtcykfxBT2wjYKn5gwp6yCE8GqlxU/RGQOaeYCmg+GS7c0S/R5MFYHwcV3ovBmLbMNbSkNE17P8c70Y3cNB627L/4TlX9bJMjqsQnZPIW9W6BhRLNiaGZqKxgZXPtkEqts3eeBn34+jhRpewqg77aKSVtFD6Yc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17 2026, Rob Herring wrote:

> On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
>> On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
>> > From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> > 
>> > The term "KHO scratch" is vague and overloaded. It does not accurately
>> > describe what the memory is for. This was discussed previously at [0].
>> > The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
>> > is memory passed by the previous kernel for early boot allocations.
>> > 
>> 
>> This seems like a lot of churn to just rename some stuff, especially for
>> a term "scratch" which is very much understood to mean "temporary
>> working memory region" in common computing parlance.

Gregory,

Maybe. The people who work with the code on a daily basis (me, Mike,
Pasha) think the rename is worthwhile because it helps us grok the code
better.

I think patch 1 and 2 should go in for sure. They make a noticeable
improvement to memblock's code. Without that, memblock might have some
memory marked as MEMBLOCK_KHO_SCRATCH that is part of "scratch" we got
from KHO, and then some other memory also marked as MEMBLOCK_KHO_SCRATCH
that we discovered at boot. Then later, the "scratch from KHO" needs to
be initialized in a different way from "scratch discovered at boot". The
rename to NOPRSRV makes it way more clear what the properties of the
memory are and how memblock should use it.

For patch 3, I am honestly surprised at how large it ended up being. But
I am in principle opposed to the idea that we should not do any
housekeeping because it might cause "churn". So I think if the end
result is better then churn shouldn't stop us.

Of course patch 3 has a lot of potential for bikeshedding so we can
argue all day on what is better.

>> 
>> The boot param name change would also cause breakage for existing
>> systems that update and depend on the scratch parameter.
>> 
>> Is there a non-verbiage reason to justify these changes?  Living with
>> "scratch" seems better than potentially breaking folks.

I renamed the commandline option because similar things have been done
in the past for other options too.

See commit c5bfece2d612 ("nohz: Switch from "extended nohz" to "full
nohz" based naming") for example. It renamed "nohz_extended" to
"nohz_full" because it is "a bit opaque and vague".

Or commit 9406415f46f6 ("sched/debug: Rename the sched_debug parameter
to sched_verbose"). Or a94e88cdd805 ("ACPICA: Tables: Avoid SSDT
installation with acpi_gbl_disable_ssdt_table_load."). Or 632ff6170647
("x86/microcode: Add microcode= cmdline parsing"). There are a handful
more.

So I think there is a bit of history of command line options being
renamed to names the developers think are better.

Also, I would imagine very few people are using kho_scratch= blindly.
Since kho=on already does a pretty good job of automatically selecting
the sizes, most people should not be using this option at all. Manual
sizing of scratch areas is tricky and should only be done very carefully
by observing each system's characteristics. And the numbers should be
re-calibrated on each kernel upgrade since a new kernel might use more
(or less) memory at boot. So really, I think the change is a lot less
disruptive than you think.

That said, I am not opposed to keeping backwards compatibility if
someone _does_ complain.

> I don't think these are the first breaking changes. And if the changes 

Rob,

What do you mean? None of the KHO's commandline options have changed
before. And KHO has no uAPI to break in the first place.

> are fine, then that means more breaking changes are fine, too. So why is 
> this upstream at all until the design is settled?
>
> Rob

-- 
Regards,
Pratyush Yadav

