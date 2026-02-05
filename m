Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57DC9ECD980
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 16:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D7026B0089; Thu,  5 Feb 2026 11:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3840B6B008A; Thu,  5 Feb 2026 11:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283146B0092; Thu,  5 Feb 2026 11:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14EC56B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:08:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D7EDC1FBD
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:08:23 +0000 (UTC)
X-FDA: 84410885286.24.354B277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 576A4A001B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:08:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H9ZwUTyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770307701; a=rsa-sha256;
	cv=none;
	b=2vZQ4eSJ1hagbEZyR4tbflbUwgNYlIiMfbh6WA3tRm50eguYw9fNq2AzatyO8fOXiQdVOa
	4uCLr3ZznbKPOdHLewcCdhLXNTsT/2gKyrHuiZNZ3kmeNef/OhVRwtZQPz0R+Hxf65/A+O
	0gE953BcJ4EsiIPniLwJmccYYow73JY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H9ZwUTyV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770307701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYqjJTrXTirbhzZeBZOT6fYy6i8qQRs+xif+PJ6/TFk=;
	b=Shd6FONxWmihCXRmwOUpbLbAbuhUL5BVV60CS6CtPdgRTwnhM7frRMHsb5Ia54+MNPb9Jp
	wMBzJ7eO1mNUyZ1yGHo+nVqB4sV3dAGYV+arZP66tZcSfMx9DwncRmL7nXJAjA2lJaAbXw
	xWzy/4Tk9iox43rU7dHOrdlkQMh+YoA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E004144427;
	Thu,  5 Feb 2026 16:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D065C4AF09;
	Thu,  5 Feb 2026 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770307699;
	bh=k2UXN2RrYY0M0lsve0wmEhAd/SPspaOnsUkAsfKm9fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H9ZwUTyVTCDY0G0TF6Wt+T8gJD7LImn6yuQ845l73PyCsGn7VzV+4kihkuvHDRVuw
	 Sy9Xzu0hm/hSbDYn/2pyF12BpzoxQ9YK9BRoWINfY2LUfO0pdLSDeTV7pGrDxgUveL
	 8omb2zSVCf3D0+JaSbMhggRjKDEJIJds6zfjzvyWcj2ijt8Nw68vtVC4xZoiGZwwcO
	 LLnNl+9cJf3qjP+JI3c1sk5kuS07GfXwwRcMNT/wLKHW3lIRFgwZ3zRsORbEfUHK7i
	 xGhQ5YOOJbSCiIsNHZ3lezTX9DIdDtOWVvjEvQM7QoWM1sxbDU24D/lsbfqa0jPoax
	 TP1vJSYxNNJIA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id E571CF4006A;
	Thu,  5 Feb 2026 11:08:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 05 Feb 2026 11:08:18 -0500
X-ME-Sender: <xms:ccCEabF_qd9ukejDFLfNozPclDMKLpA7sFv9wzadFwQipqQMbE8fDA>
    <xme:ccCEaZFtg_qprAhdJxHHZDu0IoaXaJoUo8PBb0LugnNpzaG1HArwxujTHAzpC0FKY
    fGQZcyav180y_ilRjd2gHRTem8SwMLoNkrAbSkxz9lpx9HQvehMB8Jo>
X-ME-Received: <xmr:ccCEaWAc16sfzu2lsCIMsy71YmvzaE7oziiNDf6LYY19A4czyMLf0m3-JMKQAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddukeehjeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehprhhsrghmphgrth
    esrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdrlhhinhhugidruggvvhdprh
    gtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhk
    vghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslh
    hinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopegsphesrghlihgvnhekrdguvg
X-ME-Proxy: <xmx:ccCEaQ_rMxxNl2QFdvUiqulUPnCA2QIQ2R9xO8rkFiNGdY-Gc6Wj0A>
    <xmx:ccCEaQfS8DW8Dz8sqv4GlNq8k8FYByKlVDO_RkJ9axW45-t3MeYDiw>
    <xmx:ccCEabAmw1v1JbyZB6OdUoAM8SrmFQ8yoRNaFPiOX5aLFZG5ymMGpg>
    <xmx:ccCEaYdT7rK8cTriOGLumYg8cm90Bcb9Xkdk2HCYWO0dx_ocGSmKaA>
    <xmx:ccCEafgPbCu2F_1n3aMOzVKaCDDe9ybq3HSvUahnwzh2RMWOk2v6z47z>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Feb 2026 11:08:15 -0500 (EST)
Date: Thu, 5 Feb 2026 16:08:09 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
Message-ID: <aYS8O0phOE41IuEF@thinkstation>
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com>
 <d07cbb96-ba30-4dcf-ad14-0479d6a989f2@kernel.org>
 <70be936e-e49d-4485-8d1e-416fdf8f40a4@amd.com>
 <aYR0vqwyFPo3EKAi@thinkstation>
 <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce4334f8-5e54-4dbf-9be0-059279ef1962@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 576A4A001B
X-Stat-Signature: 9ek7j5ehcg7oqikg645tsdwruwbamo3s
X-HE-Tag: 1770307701-583111
X-HE-Meta: U2FsdGVkX1/HrXjTCUBTVDTWB6sa6kGtN3dmcaF+D1zQeO01h2xI00wSeVVvTdeGc5qNI4nC71U1Wj2bh2qVkNeRZU7BuCKu7K8EBcY7NfVar+8cdpLiKDoQxf6kI23EDrqYSlQ7JC2410OUlN0F2wVKYzg30oFKNs1qSaypFc9zf583aj3ME4vls+Bp2ifQ8dhSBjKqJAEeC9dOT6p2zjb7vhBNXxnzK954iO8w3kVVXSQ7jnbY3FKcCtewU0COS8bcaVG5e1FX9J4OmfSsdk0Sd1r/jZ+QS6a6iwabjt96M6P3r+l5acdawA/ySOG5MjkslsW3tQrScLMkChFEBTclIj7CQcMLJ41VDwWkiLmK0oLlzjjkGBhUcz9qh+1b8VKokAowWu3ujKGtGFWiezsbDXLojCQytCEV50PmwD0nUZhACTj2EJ6gsF/G8wAF+iAkFxDwibacZRBpE87tKVOlQhKxrK22UJkBwIm4jdzdw05VmGZvuJXdLpf0eLvKU+ZPR3Yc5RMw4oEv8B2zzUVnl+VJgIA2P1SjLlftLxzVL4N/c/mkVFOwfqpCkGOGq9dbbwWo9NWaSZkQEu5Er0yWWH6+6Rgb87OXVHQ+v0kTZjkrzx+il+fLz88ScqT19hz/D9HHQnvmQ5IO//AaXHSmPkb3duW2BPpYtRRuk4ta7uanD+AVXapxZ8GFYwrwgnHwBB3uonxYb9CmTqPMNnFd4F2pmK2iylppCt/JFxtF0zJwSeItDVXk+oo/Z4AxR+DYn6wH9k7Md4RWI+OA3jCUK14FJg1oSuE5GIir06072kZe3c6HuGb3DKvApWDReSf3B4pC0Ac+7ZtVvm6ENgLmcH800iPeymtKnqZubUMCvnQDdQyFwEO+ybFeHDnN+9J3M1BFAazzgDsWRua0nw/cTXw/1CH5lKfq8hSid0uoyqiFj0Dabwh6DjtrYj4VCowmLNU/xOQOo3Ek7SB
 i5c0MtHh
 KbrT45Ehl8EVMlr6KLlPw+lDThupQTioPjDMDaA0vrclc+bHkoCQwvybRWM75wWB1QUVQ1OYD/5CraPe00imvsr9mFMWL57i70H9vUoxI44tOsFBIvMaX6d+kOhHPLkdfysbb3de46dWsS+4bJFMnajkKqClEyk90w7clE+1gk6paiXSjDIuX/SBBMe7VavIYhPE32VMTXRCvv2as75bcGO2L3QZ5VAWHpghnlI+XXx7BWeD0P2wtJzWU0NBJoNBzhC21vPL2Ydoblx/P89plPaB7+I9ztE+A8mgUatLjbcemIZeRBs8KLS8I7GKydhWbHQYTQu6Dl7YiVbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 04:48:13PM +0100, David Hildenbrand (Arm) wrote:
> On 2/5/26 11:48, Kiryl Shutsemau wrote:
> > On Wed, Feb 04, 2026 at 09:50:09PM -0600, Pratik R. Sampat wrote:
> > > 
> > > 
> > > On 2/4/26 2:00 PM, David Hildenbrand (arm) wrote:
> > > > 
> > > > I really hate that accepting (and un-accepting) hotplugged memory is different to accepting ordinary boot memory.
> > > > 
> > > > Is there really no way we can get a reasonable implementation where we just call a generic accept_memory() and it will know what to do?
> > > > 
> > > 
> > > Sure, that shouldn't be impossible.
> > > 
> > > The only reason I initially kept them separate is because we accept and update
> > > the bitmap unconditionally. This mainly applies to cold-plugged memory since
> > > their bitmap state after remove shouldn't matter. However, as we are now
> > > correctly setting the bits in the hot-remove path we should be fine accepting
> > > from the for_each_set_bitrange_from() logic within accept_memory(), I think.
> > > 
> > > Something like so?
> > > 
> > > diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
> > > index d11e7836200a..e56adfd382f8 100644
> > > --- a/drivers/firmware/efi/unaccepted_memory.c
> > > +++ b/drivers/firmware/efi/unaccepted_memory.c
> > > @@ -36,6 +36,7 @@ void accept_memory(phys_addr_t start, unsigned long size)
> > >          unsigned long range_start, range_end;
> > >          struct accept_range range, *entry;
> > >          phys_addr_t end = start + size;
> > > +       phys_addr_t bitmap_end;
> > >          unsigned long flags;
> > >          u64 unit_size;
> > > 
> > > @@ -44,6 +45,21 @@ void accept_memory(phys_addr_t start, unsigned long size)
> > >                  return;
> > > 
> > >          unit_size = unaccepted->unit_size;
> > > +       bitmap_end = unaccepted->phys_base + unaccepted->size * unit_size * BITS_PER_BYTE;
> > > +
> > > +       /* Memory completely beyond bitmap: hotplug memory, accept unconditionally */
> > > +       if (start >= bitmap_end) {
> > > +               arch_accept_memory(start, end);
> > > +               return;
> > > +       }
> > > +
> > > +       /* Memory partially beyond bitmap */
> > > +       if (end > bitmap_end) {
> > > +               arch_accept_memory(bitmap_end, end);
> > > +               end = bitmap_end;
> > > +       }
> > 
> > You are calling arch_accept_memory() on every memory allocation if the
> > memory is not represented in the bitmap. Hard NAK.
> 
> In which scenarios would we not have memory represented in the bitmap?
> Guests with <4 GiB? (how does kexec work?) Anything else?

We create the bitmap that covers all unaccepted memory.

What memory is unaccepted is up to BIOS. Current implementation of edk2
accepts the memory in the first 4G range of physical address space. It
means we won't have bitmap for this range (unaccepted->phys_base >= 4G).

If the whole VM is smaller than 4G we won't have the bitmap at all.

We can allocate bitmap for all possible memory. Maybe upto max_possible_pfn?
But we might not know the value in EFI stub. It costs 4k per 64GiB of
physical address space.

Ideally, we want to know on boot:

 - what memory ranges are unaccepted - we have it;
 - what memory range can be removed or added after boot - we don't have it

Then we can allocate bitmap that covers all this memory.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

