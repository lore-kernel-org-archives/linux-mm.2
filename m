Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB52DD1037B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264306B002B; Wed, 26 Nov 2025 06:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C076B002C; Wed, 26 Nov 2025 06:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178A56B002E; Wed, 26 Nov 2025 06:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0710D6B002B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:08:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D6AC89B51
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:11 +0000 (UTC)
X-FDA: 84152483982.18.083ADD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 749FF4001B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:08:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGRTa2n1;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764155289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCfR0Va41qZ0XULGyzodpXqjESM/wXZEJPNv1cWD+Kk=;
	b=RVYefkLl41aSqSsm+LBLkqkyve3Ab6BfrrLO25sIF/5vfuXDiSgwbWQJId77Tl5ktus45Z
	VZtB94K56Y25Bs+b6ymWbnD51MYqH2uELydVf/M5apk9x7RBeEmX3j+18rlxaxIMA0UzPu
	kSsyLiJ88o92e1xi2q6uPchufSODaWs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGRTa2n1;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764155289; a=rsa-sha256;
	cv=none;
	b=xkYTs+qEZskq5cVOKwCWCMV9plKeyrHHOT+66vx40O4H8aN2fwBGmlRNtqVr03BrVDSh90
	C4aG6d0ciOrVJsRLK3AiVeEw28sHjEu5rZOiG6iXK2kl078IDShUohtVbTGjVdDlz7LhKP
	3HLP+6ThXCH72NfP+gBb1H3bVPXwaJI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C1C243CF2;
	Wed, 26 Nov 2025 11:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC85DC116C6;
	Wed, 26 Nov 2025 11:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764155288;
	bh=z0HVZNX9ipGoX+NtBCrTvCMPi4qEm2pGno5N+3U1Uqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGRTa2n15T67J6SBtu/zIF82k2tIrva5M96eaYBYmX99P1xifS9kYtg6NNAF8uzmG
	 LcUgE3MprhitmOZOpWTXUMdPKhYi1q3agrG5clqvSC8zU4QVW/qto6plJP78WD/Z0I
	 9TEsVhVTic6NC4CcoVr0s156uAzG8PRJb6f7eh5IYm2jSQD8jEnGzdciI/a9xVSuXR
	 pufUiTSULdVPMaKrHWEKRKPbDyR/w7cGozbNdSA5Qq2Ms/VDf1Q7MCwZcLUA80HDiQ
	 B8Xar37YLoLzyPm4IL8zY/apG+rMCQinb4zzQrurjY2aYAaU3Q+b5sZolzLBjtN6cA
	 EEVh3M8O2M3EA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0C4D6F4006A;
	Wed, 26 Nov 2025 06:08:07 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Wed, 26 Nov 2025 06:08:07 -0500
X-ME-Sender: <xms:lt8maXAXrrkTnd5BrfEbde_jz-s_LGbj6x2MXZibPkNMeXdq9zSE2g>
    <xme:lt8mabBKPmMVQn0TQIgw-Irs0KMYEH0R6GKzQhhBxkBfa5NgdvUfSIB0AYiVU5Vd4
    HovznX3G4mZhaMtE5O-UFFPC0aL0vRdypPI-aooZghqrmtxdDIG0g>
X-ME-Received: <xmr:lt8maeoCVb13vICXsQjz6Llq19NWgyj588DtvUYIgqL-koU9OAHqwsJp9-eYMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegudelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehprhhsrghmphgrthesrghmugdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmh
    eskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtohgtoheslhhishhtshdr
    lhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpth
    htohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgohes
    rhgvughhrghtrdgtohhmpdhrtghpthhtohepsghpsegrlhhivghnkedruggv
X-ME-Proxy: <xmx:lt8maXBh-TdVnxahrIRppeVe1AAnlUyrmgTHmGY0Zv8ZjJdUU_IizQ>
    <xmx:lt8maeyd0nHHhIT06tMzmiSMV3ySOBRu4rVfgTsw8kyZI-HV7BzW-A>
    <xmx:lt8maX4Avzs5fFa7ZD6otWJZ-yCyPlNYOLT3uFBRcw02isjxRMh5Rw>
    <xmx:lt8maXv7JJI8EZafBSRks7Crji1eSN83RvMaX7lrk53d9wz4TJYkhw>
    <xmx:l98macthO8VOHM4IrzlSPdWQGPrqHQJ5tz5OHTh46gScmq7m9xmQDSHU>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 06:08:06 -0500 (EST)
Date: Wed, 26 Nov 2025 11:08:05 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org, 
	akpm@linux-foundation.org, david@redhat.com, osalvador@suse.de, thomas.lendacky@amd.com, 
	michael.roth@amd.com
Subject: Re: [RFC PATCH 1/4] efi/libstub: Decouple memory bitmap from the
 unaccepted table
Message-ID: <phywn74ghpsqncoqsgdqjoxeqdxskibzt3yltn6bmtc25sm46g@emad5n6wp5l2>
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-2-prsampat@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125175753.1428857-2-prsampat@amd.com>
X-Rspamd-Queue-Id: 749FF4001B
X-Rspamd-Server: rspam02
X-Stat-Signature: mmk9kxuwg8pashgcdp4c1xciyxg5capi
X-Rspam-User: 
X-HE-Tag: 1764155289-865996
X-HE-Meta: U2FsdGVkX19GXJBt3kTK70lQYcbzLGs9rEQ+vC8BwTLGuhTKgu9sAzEaULTgS/RIEhGz7kCMyS4lrKX7HR9pexGyqSFj7dLDjkta4Z0lhojrCSsgbkewzVSYZc5U24RCndXs0F0v08T8a2axINqBO6rBttEOIXPmZcetrfPkj0ZqyJIRrHPkktxwmHlMcQ2kg5DiyjcTVO6Vq69l9jEEu0GklvqOKrXH62oZ1+RY4eHYPwrJAt8qlQyQv80X7wiU9dGMdj9ANTMkp9SAAFv6MDqOLfK1og2iDtJeqJ/m1LDKxDMetjUPHnP8m1iGrIkezYg9KPy3TU51Dwun2R1r50fkf76s4AQPvCob3oM4mZcjG56QU/bC8GNkDSjjkWmwLf32xS5d463xvd8XseoU0n9XuQ/4DjU/ICR6QTneyWzwpG07X0Rgit7zJpEZvuPI8rNn0MWGtl9vFkq/hB0wGDj5m1iCrQVT0nJOowI0DTW/4D/2lkQKdDIoaWlEJsY0JxsUK/4R31vlSuDgceAjc00XGvYWIv7/EZ5i6+Yh/0M6npOh6/IsQwBCI2wEB52F/Cu90C6mz4+eE6eHHUlCYrT4cYZ53GY86rjKOkpV13Ex1xMNj6K+ZM2Et9PfuVSLtqWz0p5y4nc0FEyG3UWC7MjKk7U5BMKQKqFWO9ipd8gXqxhVcrwmZJyjepuC7gztQLaC+s6kNWOfCxCXnrTkBS99YEdQy+fNRDEJxMlXpo6x5e8ERSAIVXX+gU5989NircHePwjhnMPEpNalCZoAse+zLIC9PHqzLsHik1VJ8K4bH1lRiJ/vQIBk7I7XsW1IMK5tQDwKJZ8FaLXNce9QyHkWwR6sE9KvPyoQw421lHWlm56c1m9uscUgShO8Oa/ZoJNvVEB4cGEIjG3tVvTkp9+wr/I7nXW0AZ9Y6k31rKYwiILDDb8dUP4IFB7XkTA/VqEukakbtLDDaNlgw1v
 15682nrA
 AB3RKnGOPAK4u2byhLBhuWHGlHpcd+jSV4X9vpMvJqN4uEKXVbJC2tPQdw3ey5zYB2GBOSOb6DG5NYtpHSQXrPCimnk97qujiw9urPcerLdsN3xJKkcSCTAu4C6y8AcvIdl6A10IHgb5DB7CuPU56K7OhOkngxhFh9eXRQe1dOT5woHiE2uD+Jzc0sCYIsPYWasW6f3EYrwgiRLCwn4u6up6pLm3Mbk3BHIcI3hV4Utx5n1+VJZujsJKP2TSB7b2h38pBJx3l8+uITWXJlxaNlNQ0bA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25, 2025 at 11:57:50AM -0600, Pratik R. Sampat wrote:
> Memory hotplug in secure environments requires the unaccepted memory
> bitmap to grow as new memory is added. Currently, the bitmap is
> implemented as a flexible array member at the end of struct
> efi_unaccepted_memory, which is reserved by memblock at boot and cannot
> be resized without reallocating the entire structure.
> 
> Replace the flexible array member with a pointer.

Well, it break interoperability between kernel before and after the
patch. Consider kexec from kernel without the patch to the kernel with
the patch and then back to older kernel. It is ABI break.

Is re-allocating the entire structure such a big pain?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

