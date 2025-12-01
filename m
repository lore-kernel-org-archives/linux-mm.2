Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E6D4D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 20:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768A66B00A4; Mon,  1 Dec 2025 15:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740496B00A5; Mon,  1 Dec 2025 15:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D936B00A8; Mon,  1 Dec 2025 15:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57EF46B00A4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:37:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1AE318970C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:37:08 +0000 (UTC)
X-FDA: 84172061736.11.CBF1160
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6C0D9C000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 20:37:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qi22TA//";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764621426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZqWD0i8J8JyGLTANDJsj+iyiks26xZCkBM89+LEetY=;
	b=D1SBi7DY0bq8R0Y+fO8Z2rCVk6eoMySvMFbzJlB+lLtHRx3l9wV+7kEeGVK8X0EGXM8TBD
	VajDpOfEDk0Tb+iUIxzHDhELCU91GFCmmz+LXyJEsgiq6dRBq5h437Ja6DlMWigSj73dSm
	UEyJhs2W2KZgYOj1Lo2AZ9StXbpYBXY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764621426; a=rsa-sha256;
	cv=none;
	b=Yf0YaihrZrCU1VJ7Rb9qWjdbmZplbXwOsOC2H1ZSPvyQHEIz31HvU3SDYgpY19Su2/UZSK
	lr9dH5rE1I4XrI/dT7Bwg5rE1ddAPdr0A5almZAjIOWLHw1hVKdmNEo7GpPhS9WC7oB5ty
	jjvd9D/y+8ZUmgY0h8ulsmu9errhG8I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Qi22TA//";
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6DD5360157;
	Mon,  1 Dec 2025 20:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78BAC4CEF1;
	Mon,  1 Dec 2025 20:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764621425;
	bh=PmhAts491XzuroHVSlK8NY9S+n+kVfTtaW7AXN6Kq3o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qi22TA//4UhyZnUo34ywTeiqH2Ar85pgmIalWuJljf3u48IW9oDXRE2Q08wJa6Y3a
	 hr5QsG3gO6KOGsUvXYO/Gpfv6whabj2O6vVdCEz2Xjx6pFPNKiG4BWIU27yJ7F6E/x
	 T5blgTqII3AsketDw1OXlnbit7qd4vhllSlE710rFR3uJqkpYrTFkVMyEfl8y81n4R
	 yG6Cyw98/yGe1Goo9VdcKeD2H1iKOIJKKLtsftzbCjn1p3RF1NXZVmFIhY6A1Y9N2c
	 FJVCQHiTYzWtqDZUdoxNk1/vw6S2ed72f3bOOIeYFerIlM/o/nCaoYu/DghBbByxD7
	 w06MmMmaqwXjg==
Message-ID: <420865fb-34cc-43a8-820c-b15b5f24a27c@kernel.org>
Date: Mon, 1 Dec 2025 21:36:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Borislav Petkov <bp@alien8.de>
Cc: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>,
 linux-mm@kvack.org, linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
 x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
 <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
 <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
 <20251201202507.GFaS35o7WtLJOM0_jh@fat_crate.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201202507.GFaS35o7WtLJOM0_jh@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6C0D9C000E
X-Stat-Signature: 9x6wxdq3abkmjitqsgnjqy3qqyykibss
X-HE-Tag: 1764621426-195529
X-HE-Meta: U2FsdGVkX19R7K0uw6Tdheo3kv6MZnDjELNLK8evh0rk3uaFdoY30qzliRTIl26Ums2XEvIU4C/DSHhqPGgb4QCELLcHOmDiZnPOAcB+KBoWLAX3onZfw8i3N8Xolyrhq4rvp7yx7aAXNCC/m3JKKId7SNj+2knNJjrM3/8m/zHKiPrs1OWddZRoC5hCtQD/OV4f0IztKjKg7/s7nNygQqytPdBf4RKUxCeO2XlDL2pveyCh2p7uwBZVXGWIE0HIZ9N3P8+6DezcNdvK9JJDGPesetbZYbnTYUHZRjgCo8F5iS6sDgLgVUHzP2/hJRQ6Xx7kCfvSRi0/otowNlyjPCCx/3GQ+CueU6VG04JIYLO/8GvnDYhvHdvUwni4lwCqfDMi0gZdYvRc1t2DJgfRgYJFAKnmWtGNHpEq5hZ+b2FW5+E93u5AvZYGQuueg4pn7iJrLDbc1oO5hC8EaaABPjEbI9NlMK/XiVItYiW9+TuJptMo9J/37VMy8CnsF6Zw2oRcnfmvdroFLZ1WZ1Az/a+bvwxT1B7ymnNaBDIEgRlieIzfmE4y6PrP3gsNoBcpHR/2SVd+pqa/oayr0p7RMedFWBGACVa0xnto2P8Gck2FIBjX29V6os5vKEVazDiR6v7aGl5q8+AlOqZmD/MJ5gX2FtrjXiR4OkUxEVsc9A6o+MmVbTrWc/WPDtjBu1+tAG3QXlyPDX2NeUV+LvIHHYYk182APyXndPTgSZronIGBS+XilO1xqG4FFjUqpfNe+9J8tO44sh6lEZznCtNNc0FnW2dJQWJjq0POgTmFaC4xNqSDjGhAUsZQ/6bUQtdQCTx9nTfDuCOdUE7+IQ9rIhqL5GEa6wHP80v/Zh13LZg2MS0mYMWtMaG1nCuyR/U1+itrmi09mdiKV/aqrMhBnqaBSf5bC18wlfOVr3qFBV5f7RAs6Nj2VEg97IDYCF8xAedKs6JiXakeZkmTt0c
 v42qvtIK
 U8brrbWEfQ3jPiHCLaAmAf8CzZvgeGiBm+eIPrDfIoJix5bM24/dLIrpEJ6aBZkuAsWt4ih0rIzjT9xLI3AojrRKNIVz4n6p7s+7AVwQY2FdQb/bVO2EqBP2Tg+KQ8thr/FuNKN2UNgBJwylU7SaB5EE0i+5db1riFcV7yLJ3MhCxtVjiiI4KF9S+JAzGahW4S7EhT1pNJqgBkNIM8lNes0PoHHuBgfJDp+h7ZIFB0wqxDYWseKj4U4TV+yo7qlpBdwyu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 21:25, Borislav Petkov wrote:
> On Mon, Dec 01, 2025 at 09:10:26PM +0100, David Hildenbrand (Red Hat) wrote:
>> Just to be clear, I don't think it exist and also I don't think that it
>> should exist.
> 
> By that logic if it doesn't exist and someone sends a patch, I should simply
> ignore a review comment about that patch breaking some non-existent ABI and
> simply take it.

Well, we can always discuss and see if there is a way to not break a 
specific use case, independent of any ABI stability guarantees.

> 
> Well, it certainly works for me.
> 
> Unless you folks come-a-runnin' later screaming it broke some use case of
> yours. 

Heh, not me, but likely some of the CoCo folks regarding this specific 
use case (kexec in a confidential VM).

> And then we're back to what I've been preaching on this thread from the
> very beginning: having a common agreement on what ABI Linux enforces.

Right. Maybe Kiryl knows more about this specific case as he brought up that
these structures are versioned.

-- 
Cheers

David

