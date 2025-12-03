Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDF9D12D7A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 15:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4C46B0005; Wed,  3 Dec 2025 10:59:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65F46B0007; Wed,  3 Dec 2025 10:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7BCD6B0027; Wed,  3 Dec 2025 10:59:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C6D6D6B0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 10:59:32 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77B9B8A44E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:59:32 +0000 (UTC)
X-FDA: 84178619784.17.DA34044
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A660160003
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:59:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=crSCjQ2S;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764777571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5A837UYz/VXEyuk8nnXqBwp73570xZNtO/JfT35421A=;
	b=k5MYMnkaC1J5tzeqC4uJGY5G9haUMqAjBlMccHiggs8IYzFn9HIID6+gZfVQAUtGDXKboS
	Zp6NftTRH1yXk9528IJ6vZPmVe0qo2zbL0iY6BJ+wy0HOKYKGCNuxAAX1S6amBE6jdA5Uf
	j5p8AvzxbwWoV3gHVcJLt9HTF0h2/Ok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764777571; a=rsa-sha256;
	cv=none;
	b=Qpg5uHlgSGh/maadsPeezpZ+oiEsxAW+tMrmmZyJ28KWOYDzOngcwSQOk0Pis/E2a6xsq8
	rlZ4OmYA0DeDAdskzZ4TF6eKd5auQYFsqPaCFKPYjvHhpnuDuDTvkEzAGbvYGJvX5ACRcS
	9IFR8zbjT3lpYBFLW+2Kfh8Rv9o3Fjc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=crSCjQ2S;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 22B0D40E01C5;
	Wed,  3 Dec 2025 15:59:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Jm55s75WWJiM; Wed,  3 Dec 2025 15:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1764777560; bh=5A837UYz/VXEyuk8nnXqBwp73570xZNtO/JfT35421A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=crSCjQ2S+J5/iynhJFk9UKihxfc38IfS+Fw+h6iRq/8LXSIwi0PZJv90R4g8/MXGW
	 r1ElmDKHkg1pX+OL1QKumUlyGktBGz40dSSxRhkFBLj1hpWXkgd0tPY3EeSvi2Ffe9
	 R3JRQPSIIRI0DANEw+Up2ZSazhClnbnkhEvRkFjwYJbUlH2gJfbG9kvBfPXjzaUoLK
	 RhDCGgQilS7jERyuWw9D4yM7BMjgs23Ye5kGOeTnUa1EGDCxkXBvUXZtrfkAoBNubc
	 N505u3BhpJqlSR0GY0AL4khjQaOyO5Ea4hjoOOOG7j8GH1+w8PUeQtbmg2Vr/IVVyp
	 1/BXb8LWqonyqZuD7Esuq8mevHplKYNoKJT06Zx/p9Hb658j7QxfrHqYYLjeQ6SrMN
	 6Z60gQPxB274MQBcIMxuX3BBMX0lhZo0oMKeFDOD1fyoWeGAnB7ROl7b3YQAdjF8sv
	 +D10Y9nVLzwhtMg/imH01R63OYEUQ4ZsprkebseeDMOADdpNbVFA1J7zwSlE+Xgd98
	 +eWs+zJITIYNjpKW7NPZJdc0PhBJ/sT4mzgw8BzGPs8d+b7yBPGvj9iMK7CW9eqcZy
	 Zw66QQpJ0prNo05BiJ95trN9iDyyqRDq/ZSmJlY02J9oZ4zgA3tYkV14xYeUuZKFZv
	 DPfpr37J1otrYUf6UajKmiXo=
Received: from zn.tnic (pd953063a.dip0.t-ipconnect.de [217.83.6.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id C409040E0191;
	Wed,  3 Dec 2025 15:59:02 +0000 (UTC)
Date: Wed, 3 Dec 2025 16:58:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, ardb@kernel.org,
	"Pratik R. Sampat" <prsampat@amd.com>, linux-mm@kvack.org,
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, dave.hansen@linux.intel.com,
	akpm@linux-foundation.org, osalvador@suse.de,
	thomas.lendacky@amd.com, michael.roth@amd.com,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
Message-ID: <20251203155855.GCaTBeP8fQDLx3T0X8@fat_crate.local>
References: <beec5651-5c23-4f5e-a0a3-d1cc01a8490a@kernel.org>
 <20251128113411.GAaSmIs0kSWGhCYkaA@fat_crate.local>
 <47927c25-a317-488a-823f-ac0588f4eee4@kernel.org>
 <20251201111201.GAaS14AX18qeHN20xf@fat_crate.local>
 <052d7f47-edb6-4978-bc9a-c7eae469720f@kernel.org>
 <20251201191036.GEaS3oLBY8PEuE91Ap@fat_crate.local>
 <dcccdc4b-b7d7-47c4-b1b1-a6c70edb20fa@kernel.org>
 <20251201202507.GFaS35o7WtLJOM0_jh@fat_crate.local>
 <420865fb-34cc-43a8-820c-b15b5f24a27c@kernel.org>
 <etd7r45wmnuoftpckrzkzithr443ru6akgwqjgzw2vgmzqi7cs@camfecdmef74>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <etd7r45wmnuoftpckrzkzithr443ru6akgwqjgzw2vgmzqi7cs@camfecdmef74>
X-Rspamd-Queue-Id: 1A660160003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 71frimxnf5hikde8jrxepzi6edhbnqkm
X-HE-Tag: 1764777569-906136
X-HE-Meta: U2FsdGVkX189SlO5mgZiHz39T2QEkxFljjOOvx0XFjeAVbE/iXDyh8fAEBzCZeZZR/rkIDOLmgqebUJ/IEsoIt4XofX2r4V51105GzDJU9yff1PiQ1H3igYF4wJrU7hqCRCaNwND7sWz9QKKA2JWCq7JYL7unbbA6bZ63UpG9f+z7jRywq9N2xnDd/kG5g1SbGftz4pMfEQLTli1Vielh5zSVfZIcAguA+dth4eENGnrFsZYmF4OkFlOl/XP9XTuhr/tD2FNvVAsm4+kRpQO/qha2BVx4lmJ27MJ00YA9fQO1A4YsGLnXHN5l+CDlb0g1px5VzfkGwI7WJYqfAcAotbl47y0GyRfw26z8na5mNbrxrqZNRjnxxR3cghx1+0/AS4p12lAVfP3gwSHzLQVwBEe6PX8HGsbs9NE+grmqsXuPt1yBX2jZovMsLU5+/Y/cWzAoj3wwo4ozdXdlGLW4yZtz+vRfeDoeAc/o0MEW2+nKSGCeErRCwRPuvT6Qc4N6heomMlFSQQu1uz+Q5TyPx9etCpiLJNBGP1SiL7LESjsvE8W+800Vzq0T1Qyr3A5ugCblJxUPpyure2w6nr7Ik7S21G2/RAF48WM7e+NUS/qaOqJCJHdk0LP8UPzu9zd+TSyjLoHFxCev1NV/Ej/HVDyQQfq8t09+hVabyYyiRCmqv3J547myH/BqjA5eNYsurOGwZ4e5Df1tvEg6hdP9IHhp+0PXnyxN7XeSMFGVg3A25b6uFa3/gFSqkMcunwcXUpDbufaEhniTx2pe2Qo0ukLe1PMcGYcnEsHwcW4qQj0GkPu1r05k6Eadln5qjsHUzZ0HMyDSzfJEw2NtMtJuswoxlxC8IKY6TR1O9PdM88030mhM1+BEMLoBp8YoUZk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 02:46:23PM +0000, Kiryl Shutsemau wrote:
> There is also the #1 Kernel Rule: "we do not break users."

Do I need to point you to that too:

Documentation/process/stable-api-nonsense.rst

?

> Booting a different version of the kernel is a core functionality of
> kexec. It is widely used to deploy new kernels or revert to older ones.
> Breaking this functionality is a show-stopper for most, if not all,
> hyperscalers.
> 
> This specific change may not be a show-stopper as CoCo deployment is not
> widespread enough to be noticed yet.
> 
> The notion that nobody promised that you can kexec into a different kernel
> is absurd. It is used everywhere.

Dude, can you please stop handwaving and say what you really wanna say: you
want different kernels to kexec. And it has worked so far but nothing
guarantees that. And we should all agree on some strategy going forward and
enforce it.

I don't care if different kernels can kexec or not. If I need to kexec, then
I simply build the same kernel.

So I'd take a patch which breaks that and when the submitter gets stopped by
you or someone else, I'll go tell him: "well, actually, I can't take your
patch because Kiryl said so but that's his opinion."

Do you see how absurd this is?!

Geez, I'm tired of typing the same shit over and over again on this thread.

Feel free to propose to make kexec'ing different kernels a rule and let's all
discuss it but let's stop this nonsense of what worked and so on. The kernel
gets complicated constantly, grows things here and there and without such
a rule, are you going to sit around and guard that kexec works?

Pfff.

> I am not involved in the deployment of CoCo VMs, but I don't believe it
> is specifically about CoCo or the kexec ABI. I think it is more about
> the boot protocol. Kexec is one way to boot the kernel.
> 
> Should we consider the EFI configuration tables format as part of the
> boot protocol?

You're basically proving my point: this needs to be discussed and agreed upon.
It doesn't matter if it used to work implicitly in the past.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

