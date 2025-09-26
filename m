Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74C43CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27E28E0015; Fri, 26 Sep 2025 05:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFA58E0001; Fri, 26 Sep 2025 05:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C498E0015; Fri, 26 Sep 2025 05:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1D598E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:50:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B59687730
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:50:28 +0000 (UTC)
X-FDA: 83930931336.28.FF08F63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D66C51C0002
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:50:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cC6TftOz;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758880226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ml/K68tt8EimGRBokXX7FG0p8xqXVIN4C2XFPLCk+k4=;
	b=KKYkrA3gPkWz76bErTjjqi+S1lI6sIkvv4CN4GSjxKLH5urHAnUmu/vIBrTGO0Hf2Ge9AO
	7uXpkAnlelNIxe4vPc3LB9Zr+DhtfjCOl6419aTlPcq/10YyBMp9G4kFkUsh1Lk8eAHUw9
	CkVYCwQI8mHwWEYA8Tp8U/eHXq9oTEs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cC6TftOz;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758880226; a=rsa-sha256;
	cv=none;
	b=beMq1AyVgk8LkbotQJ8mAhSEHNx6lnrcbIP13v1sxZiXAztbtXoy5Nzx93mdJxQu0cngKJ
	fezWwu5pMUrtlq9OkQl5NYPKkdPSJ55wZUlZAnWG0tvMy1ijDJ4fKAheACd51b3R1BKkvm
	iGr7Vgf9AZYb9A3FEpxeU3a5tkl7/Q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3834261CE3;
	Fri, 26 Sep 2025 09:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6347BC4CEF4;
	Fri, 26 Sep 2025 09:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758880225;
	bh=K1LIWmxcJgPXbCty1TvudCcCG/Db51jwCowiiS1WLyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cC6TftOzZulw88Zy/RIdnz49WQvsFfuCTGHjLnGltVCATuNNwJv7JONJztiYMWfYa
	 62whYl/7yz6SRU/zVD91MX5TkSjEv2rdXF6C3UwtczFjrduOaycKKiG3DOKfln+gAq
	 vG1tQjTt8tNeqXiQXkrf1W4piu+vS2z+MnU9t6PAyd0jWzSuY6J9VD4Zl7HZq6eK8K
	 0yjAsjGGNOw4wbF9Lw/I8soG16mFDSgu5Ii1p2iDLwAcIm86pBCEuyiYcjqTDuGNm6
	 o+5MxBesF5tOS590obpAv/TgxXJDuIyyoYUvc2Ev77DN4qQ+4qrZVJbcCcAJBDMC0b
	 moOtbuI0S1uuA==
Date: Fri, 26 Sep 2025 12:50:22 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
	linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <aNZh3uDdORZ5mfSD@kernel.org>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <78127855-104f-46e2-e5d2-52c622243b08@gentwo.org>
 <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpU2QucTR7+6TwE9yKb+QZg5u_=r9O_tMfsn7Ss7kJbd9A@mail.gmail.com>
X-Rspamd-Queue-Id: D66C51C0002
X-Stat-Signature: 86cnmjsnwypj9f4aisgx693973kpo6uh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758880226-956626
X-HE-Meta: U2FsdGVkX1/uxuXnb/fC4J1t/bhia484a8cAKuDY5UeNyZU5wL/WYZC3fTmUCOqqahQRSai+ljcYwQ5XNC3Yyb24FQ2yWvRtWDLp0rBuoQa+O50Ll1C6o3o6MxKqVeoZh6tfuxySak6W02hQEAdCeBRG9ZTALBcHbXeo0/E4kZ8bDEUeQ91iV+Wn8U8348LU64bwAIGGdy3eIlIDT0PzK1OFzOA+S3LM2HQ3n2rGqvKuji6qrpulP0Lp8R4sIpX1VFsEBej5cTB2xPkW0+6ALY241oxMSLpelvirPgiSKAnGNPfevhc7SSz1rsHE+TE6HH0K2JDwHdxSHZ3g/dqAd3AN24rJK8ush4DqOrj1mS4cYy66I2dwzhMQM2WqKSg+ggiNRP1laFH7xv0ETt5+nPvxbES2sZs2meOD83hsXlBA0lxC0vNjoMLShskyFu9UJ2edljB0sNOOyioGmtVOPlCZSOKDfyj+6NjKpXlTRxEr+F8S8oQ0mwyRRoFHsa5z8gLXXPAFwMlvG4IG7vBnftyzoXmNm5qc94PIbhPsPP7CCZLqVPEgyOOsc2dzaDvMpEaCSPIYLHyiTqkwRaIA/RMatwFrepBax81pISmXm2BS0xUNp9rmPAfcyLJpths019oHgKTB6tSeJTktqGjGbn7fwb9BLmVGs4RuEV/LtGDrFblwvjXk89SOZYMqjhrmdFFvT4MZ0FbAGsEg3upqBQ20lctEffshuuktdV9NzVydogdO4nfuIQWfhYhyKLpqYhu8NQYGH6QrtaXwciRBktoPnQllqspidFHMyFVBckZFauYaq+4qTc0f57HQtlepGTxJExzGYBcK8aU/I54ByrlZ46VMelOeZ41lhe7dctDsBzhLbDpry1A5AClwVAo+AGGaoim26e54kuN1HPtrpljGGkNHsXaN1yehQsyIyOH3M/ZfwZXgtdM7iTgJm173xwKhZif+frI9iDquWJl
 7hsmuQ01
 CSdo1Dwkh2p+ohhTDgptsi4yGOaonr+wrB2gCUV1BpiR69fi6KFoQizSjuziG5gR3zXQE8hiYmywuCySzP61o9S4csRK1RPP9OFSwfBbQNyE1YDTuSnH3JU1D1FvfPegxWARoccYiXWb7hYFaV1J7/2dCut0fLmnBCiF+QCafTK6osjisO1GvyBqFCRMhtDEcbdBM5mVmaBML94/ALRPiW/Ysl4EdUtLe67bGDaccfW9XZOgJ8xiwoASaL1KEDHZDjv5FTx450h6ylza8rZ6oeyHZzdnujVKVHyWtWXLn0G7oBgIQ5fXch+xqhrHGvNsY+puWcq+ogWVOEwikXywo45a4Vm3c1C/VvE4xWwhyGDHX2UIuPeYfAVcKbLm+Wm7pnLSyavWydoOLnB4YhAfn82rswr6+zVEc6bQa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 11:39:44AM -0700, Cong Wang wrote:
> On Wed, Sep 24, 2025 at 10:51 AM Christoph Lameter (Ampere)
> <cl@gentwo.org> wrote:
> > AFAICT various contemporary Android deployments do the multiple kernel
> > approach in one way or another already for security purposes and for
> > specialized controllers. However, the multi kernel approaches are often
> > depending on specialized and dedicated hardware. It may be difficult to
> > support with a generic approach developed here.
> 
> You are right, the multikernel concept is indeed pretty old, the BarrelFish
> OS was invented in around 2009. Jailhouse was released 12 years ago.
> There are tons of papers in this area too.

Jailhouse is quite nice actually. Perhaps you should pick that up
instead, and start refining and improving it? I'd be interested to test
refined jailhouse patches. It's also easy build test images having the
feature both with BuildRoot and Yocto.

It would take me like half'ish day to create build target for it.

> Dual-kernel systems, whether using virtualization or firmware, are indeed
> common at least for automotives today. This is a solid justification of its
> usefulness and real-world practice.

OK so neither virtualization nor firmware are well defined here.
Firmware e.g. can mean anything fro pre-bootloader to full operating
system depending on context or who you ask.

It's also pretty hard to project why VMs are bad for cars, and
despite lacking experience with building operating systems for
cars, I'd like to believe that the hardware enforcement that VT-x
and VT-d type of technologies bring is actually great for cars.

It's like every other infosec con where someone is hacking a car,
and I seen even people who've participated to hackatons by car
manufacturers. That industry is improving gradually and the
challenge would be to create hard evidence that this brings
better isolation than VM based solutions..


> 
> As you stated, it should not depend on any firmware or specialized
> hardware, hence I am making this effort here. Let's join the effort, instead
> of inventing things in isolation. This is why I not only open the source code
> but also open the roadmap and invite the whole communication for
> collaboration.

I'm not sure if specialized hardware means but hardware features
used by e.g., kvm are not in the category of "specialized", unless
you referring specifically to SNP and TDX?

> 
> Regards,
> Cong Wang

BR, Jarkko

