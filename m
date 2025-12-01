Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3600ED116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E44B6B0010; Mon,  1 Dec 2025 04:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB726B0012; Mon,  1 Dec 2025 04:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8546B002E; Mon,  1 Dec 2025 04:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 415EF6B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:18:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D56FD4FFD0
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:18:47 +0000 (UTC)
X-FDA: 84170352294.13.2B36273
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2EC9816000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:18:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LCLEM5LO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764580726; a=rsa-sha256;
	cv=none;
	b=IvZDunc2QLIr3m9Z4QJqzr8yfNvjqnsWzxGbpKK21/OGNTi+8JL3oqVr4Gtqb3GE5aYez0
	lOf4QXLMk9YSPmW+6y33bhNmK9nSX+FzgCmVbxVwiPo5VscKz6gon91JI7WKxx8+iyItkV
	avVN1hz0d2+e35/E3KXLjIOecdcuOus=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LCLEM5LO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764580726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKj/WhTZPmcl4/pqKtOMA2XfPmv2m8YgR3jiiMXyB68=;
	b=h1F8ncydSZ7IxYS1Y5JY8cZhZ3C2udRcuyE41JYFGUjP6t9WKlLlMK8lDKWWhYTRQHkglO
	AdkPESNJ6wYm1n/FtVUgMA3ANE/01pAf4dkoQP3mM1rmtXgvAi+IAIHywFkH9MKQTQe6Y8
	Fgwfxao/i0sKPVErfE+MHLkK/VBLOqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 869EF6014C;
	Mon,  1 Dec 2025 09:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91652C4CEF1;
	Mon,  1 Dec 2025 09:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764580725;
	bh=qWp6QKEfPfpxLUmqgtn55SeILlnnhx0o/0HpFCZjylY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LCLEM5LOdK4VTSpDstiX63Jcdt88wt0TLg17IBcCaa43907suA29aPg/LYKHG0q9y
	 70BPoZAyi/0h0BWg9phe/Wx4nxITfIF+JH8jTzpmijHYnh7kZRMkXc5QmS+XrTY1Fp
	 SERtNsiEKqfUMDjpm90ZWmnJaja9csucNVSgviYi4L5UEipYBzxCU9GL1oeOmIRmbb
	 eK9j+iC7NmO3a8Ru205q3gCmqa1prsC9bd31ydK9UBwGwxr9tt+BnIYE6tnhRHi4Ik
	 97YkhkH06XH62JmMxo2htRq3qaWecptFQrE+Fdxi630V3F0kSCokiDvVYJlNhutqEM
	 EyuylCUql/yDA==
Message-ID: <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
Date: Mon, 1 Dec 2025 10:18:37 +0100
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
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <20251126223127.GIaSd_v7juUkaW4RTA@fat_crate.local>
 <m3l6gcjmbabudtnqwv6w67t7iz2mpmbjyrpnmiq5k2iyargn5d@nyf2zzxx7yme>
 <20251127181233.GBaSiUkaLzwANS_6WT@fat_crate.local>
 <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2EC9816000E
X-Stat-Signature: 95eiuh9t6j91bxfd3crofujkojk6ox89
X-Rspam-User: 
X-HE-Tag: 1764580725-245062
X-HE-Meta: U2FsdGVkX1/D5Z0wspFpavX0CgXzzyYOb/niVo1ulcc1lTDyfJ/79NC21pUkJaXn/W+tC46NRd1X/avrb4QQthp/EkQqLoMB/wvc8wRqtj9gW5+0eI/qp8+DoRd8hQwQwqSCuP0OCgd3hDyJhtehfRhgsHUBmQUAInML0fh3HcRAOlP1hOhsKUaDKd+6YIIsw7w2pC2naj0bKT5M7ssySWY8gwZDOtUy7OCfMiYiPMI1oCOEPZv2I2n+t0UZXcaVTsIL+VMuBgc0Wy2gYQuuKEoOLXnrTRbuUP9TPOPpOqkwhtP6+WL7ZdskxUl1NF7UIi25cmisuPVZWUep/RRaBWZRPdWMDkLsqKLuCRY1InayCNmIcg+l7rP9QaEohYSv1wnF4PI8tfLK+5Ze3EtfYF9WZHrUXH2Mgeco83wCUqABqlYCnvb+Op2lXljlrVn/JU1hR8BYwiSYGRAOGn/Gx0X/A5XypDqn7v4SBnFiVR3Pj4XW1uRVFSTatsEii2n24zETVgzNH9obYpDm7buug/QMSTe9kmg+s2AtmdjIWmyf97S50CZhoeSpWCZbFffLy0PsrxqYg7G7qq26XnmuRu0zrcpHjZRBdyfq2E1TzaBim01qSfEM97WCMG2lo4wRO8OVH9BYllE8Io6n/iCtvbS8ejNsom2rXuuUH5m2fdMoOD9jxnYDL4WIYzVigY8IuquhihADgVVuu3Lgzu8HgXWpqBy8LI4wwl3AJvnsHgrrtr4Mq96VVY4pO1YvCBRxvhbhI8d820YcpsCUc2yXNg8/jsWt8aqICMYbsEVjYw1QkKIefxdSojkPK9lc11XlLOU+6wAfAdYYW4kOq9QInta2H2YMI3gmNZ48AXdM8/G00wgWGNOVeEKsZRCLA5aPsiRmlsnYOHXVP3P8KtfPTk1rQQ/QIF0prcEEzF4a9E1+j/wLhXnHRfxFs8f0wO0HD7H+VWwGHp06huT1gfU
 fmU15j5b
 Ouz1JZyzjYjwTUJr1CBgQYG7roFq9XzeDub/9yD+o0HKwfDQOybm0kyLeU6V1HTEyM+TzSTu5YNwK9qkhbg5erKMGI08i+3Nnjft3mZUg6/CkwAS7Tpdr2A0VgDIQCZPL++ephQFT0p6u3afm1BBq5+9ahJXZO90V72D/QP0AVCozp51KUOhtygCSNkWiot8HK02AZ35PJ8iKkbH98Wcuxdc9mxIkoNNfFeMDHHVnlgK1xmpb+mN5y2PuzQA1rRcBixp9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 12:34, Borislav Petkov wrote:
> On Fri, Nov 28, 2025 at 10:30:15AM +0100, David Hildenbrand (Red Hat) wrote:
>> kexecing the same kernel is typically used for kdump purposes.
>>
>> kexecing different kernels is used for all sorts of things (live-upgrade,
>> grub-emu come to mind). It's quite common to kexec different kernels, or
>> maybe I misunderstood the question here?
> 
> And my question is: since when do we enforce no-ABI-changes between kernels so
> that we can kexec any kernel into any kernel?
> 
> By that logic I should be able to kexec 5.x into 6.x. I'll bet some money that
> it won't work.

I *think* ordinary kexec would likely work, as I recall that it doesn't 
need a lot of that special kexec ABI sauce like unaccepted memory uses.

Within confidential VMs (kexec ...) I am pretty sure that it's a 
different discussion.

> 
> So unless it is written down somewhere, I think we should probably talk first
> what we want to support and why...
> 
> Makes sense?

Makes sense to me, especially for confidential VMs where we pass such 
kernel-managed data from the old to the new kernel.

-- 
Cheers

David

