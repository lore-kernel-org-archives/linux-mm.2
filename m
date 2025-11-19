Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B06DCF58C4
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77CD6B0011; Wed, 19 Nov 2025 13:34:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4F346B00C8; Wed, 19 Nov 2025 13:34:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64C96B00CE; Wed, 19 Nov 2025 13:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C5D126B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:34:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CC3A12FA24
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:34:01 +0000 (UTC)
X-FDA: 84128205882.20.46EC144
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D05CC000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:33:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oj6dh3QF;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763577239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIyLAB0m94L7IhoKbo7mDzv/544NvmA6xZIxPaVJ+q8=;
	b=HM+AeThZnsnmTPHZjbl/ubC0ESsM/o8jyIqfpjrv6Qlef5pzOrgvo5B1tN8cXDRDJs+40K
	8cZHW/wROJXEGp24yLemVtEjPxKb5WJB7HBBkFcyjqIlKuKZG5f9jdS1IV5Dy5TwGUgkOp
	94yK+LLp171hK8n8uyunsumVfBt3Fc0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oj6dh3QF;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763577239; a=rsa-sha256;
	cv=none;
	b=CQqIcrJGLZ5AEfLkG+TCn1mRPjaIlsIK+6mMIMARgXnNvZEChoxoLqCILfdTCzWX2yUqLk
	n8XhS8O5TInBEX+mi+TLD0yCWPA8B8C/wl7JRKL3g7Ps89+vs9/l/2dOJU4HRj59SaD+HJ
	Q/ZrasRNe+DRE0vmbogFIYo6q39cQ1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75165601A2;
	Wed, 19 Nov 2025 18:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACE8C113D0;
	Wed, 19 Nov 2025 18:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763577238;
	bh=isuSe0vHAL4pBqh4kPYeDqNJgvukP3SkbC0ClCMHi/U=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Oj6dh3QF2+yqHgZl00hjnXzhiNz+Kd5gYv4Mj4vHnoLuipqptSvCQU/ENuPdlJrkM
	 QCZqRhvmmZXjGd/NFfGhOlECLddt5EAF6gsnDbdre02U3ZehF2T2bdHQYrvGRRjZRI
	 KIUnyGtdsfnJYxILq0DcK0YYT7H1xJuQ214CUgOUoDfVAz3tSQPe6BZ8jeuzAcBm1p
	 wXft2yGvOtlxxVS/f2uFljuXnVnBuAEiQdQEuRS49EJQ/cQJ3m8lwZTWNnHhaozgGs
	 apJhTg7BHqj7YbEppl1GoT03u3M/p2wK2rr8z7Rl1f58PwIPr+i0ClaOfchr52lQVa
	 yxyq/528F3qvw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8AE21F40084;
	Wed, 19 Nov 2025 13:33:55 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 19 Nov 2025 13:33:55 -0500
X-ME-Sender: <xms:kw0eaXtHW_hPzTjGGcVhcydgSpeOMQsuqt-CDQ2ce8lXwh_2XkBDew>
    <xme:kw0eaTTFCCwjUA8kF8nkRRywEr7igPyQ-OlA6aLIu76kha6OTU-uEILXGlFKbpWmH
    l1XsdpwdhUBo5Q6bK0a2g_fD9owfX20pc_Ddgru3Du8XugMOTSVRBE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvdegledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepjeejvddvtdehffdtgfejjeefgefgjeeggfeuteeiuedvtefgfffhvdej
    iefguedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudekheei
    fedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrd
    hluhhtohdruhhspdhnsggprhgtphhtthhopeegledpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepjhgsrghrohhnsegrkhgrmhgrihdrtghomhdprhgtphhtthhopegsphesrg
    hlihgvnhekrdguvgdprhgtphhtthhopegrrhhnugesrghrnhgusgdruggvpdhrtghpthht
    ohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehmrghthhhivg
    hurdguvghsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopegsohhq
    uhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopehurhgviihkihesghhmrg
    hilhdrtghomhdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhr
    tghpthhtohepjhgrnhhnhhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:kw0eaUKcvBX6ZqDb2Zfz2lS6ZTPn-nXSDUpeDQirQ9WsFITs37m1FA>
    <xmx:kw0eadq2-jmwILaPpoRuPfN2N1yM3Y8zfKpCUT6xaUllbcz1l4r_ww>
    <xmx:kw0eaY_jsr-_Ab2g_NL1wFjttUgbqyW25dTE8Gwsk4BL2Ms0a7Nw1g>
    <xmx:kw0eaY-o7o-_VANLMjD5K5xLI3aUCtOQ36zJ9mu52nOwG5c_vbE8HA>
    <xmx:kw0eaT6PvxdLshew8G6EsocVLck8YE1dY0HQ7jptKjjUdBShZ13KNOpC>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4771A700054; Wed, 19 Nov 2025 13:33:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A1wO5D87xXUg
Date: Wed, 19 Nov 2025 10:33:35 -0800
From: "Andy Lutomirski" <luto@kernel.org>
To: "Dave Hansen" <dave.hansen@intel.com>,
 "Valentin Schneider" <vschneid@redhat.com>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, rcu@vger.kernel.org,
 "the arch/x86 maintainers" <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Frederic Weisbecker" <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Jason Baron" <jbaron@akamai.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>,
 "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Uladzislau Rezki" <urezki@gmail.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Mel Gorman" <mgorman@suse.de>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Han Shen" <shenhan@google.com>, "Rik van Riel" <riel@surriel.com>,
 "Jann Horn" <jannh@google.com>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Oleg Nesterov" <oleg@redhat.com>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Clark Williams" <williams@redhat.com>,
 "Yair Podemsky" <ypodemsk@redhat.com>,
 "Marcelo Tosatti" <mtosatti@redhat.com>,
 "Daniel Wagner" <dwagner@suse.de>, "Petr Tesarik" <ptesarik@suse.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>
Message-Id: <292ebf6a-4a7a-43b2-a670-ea53728f2c06@app.fastmail.com>
In-Reply-To: <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <20251114151428.1064524-10-vschneid@redhat.com>
 <bad9eaaa-561a-498a-90d1-fe3a3ab8ba37@intel.com>
Subject: Re: [RFC PATCH v7 30/31] x86/mm, mm/vmalloc: Defer kernel TLB flush IPIs under
 CONFIG_COALESCE_TLBI=y
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7D05CC000B
X-Stat-Signature: ohrs9kgazqcmtg8p3ipa4kgk7u8pz7ms
X-Rspam-User: 
X-HE-Tag: 1763577239-386405
X-HE-Meta: U2FsdGVkX18AU8TVLO8LgVkzvx2n4+aEnDhIFd3P+Tc21GCYNgnqctSdZjPeynmwnyeXkMlqwONeFrbOYocm0IcV6nEnXM7KJGxcNcrwSTBp/rF+gjY8q8wHM4NVMVEO/8KoAX8ER4EJrn+d9VqtmIon2nV7o9eal/4dIrPtAXTbXUKR89GKseYsvXrCcmmLsW/6+8Bm+GyL39VNNmER3nUA0fTanBojDJ/U7TwXs07pVQ/0BVXNMTBnbaSHKU2bnH7iDl0BDpsmW14nm9jXirwqOD+z4HZ5YP8syKxoiBkD0RyYySxHTI0AOhJTcn5gGrW0Xb43Tj2f7wQfIAfkkB596QHhfb0DZqyN4u2LV994sE+rUsspACxd30XYUa5cn/FWvsvUoRz0Rjtpumz4WX9CALvOwXxyyL8Lc5mS6d26ml5E8f/OBYArMOM0y7K4+e+f4eIwGRTOh4mgug8Y7P8X+VtGnkbQJGudLTwfcb6sICScxLkcuKtU1MS1VjFcfTw8wP6cKpaAadIDqZBaCezF8GpkR/xKltKmFOKHdQ0E/RrKMY822z8TG2PeqyKBQsVshnzZqHjP8Ar9o2I+BNa8YQsB6FAh6Ax5fwflJgK0jGayAH3PMD/wV64MdkeCCnBTakq3faagD/DRSk5XGul92TtF9k3wgbPtXaYF+zNWyZv2nyyfVzJsrvqbqOEEYP7zfBpD59INfpVkYH90AbHR/lfhqIdZXZ0H8VDueniCRuxm5uqFZ4WNMgVoJ6Q3b7MOa5fdie/h9TBVQ8otXm4PsJViBnV0VZ20+ug0nx9/pO+WrjYH3k2HbH0yJxuL2MbAW4om1LfHixIGinBLD6SIEIo/MovMhFQv23sL5uvUHW9QDIQUPfVy2ZeC4uhtrOeSTyCYt9B0dyos2Us2Aq2xBoEE5J6I195Hyt5gYwhREqLWCszESZtHsHG8lRPH7JvvQaF/Dty5jw7Aw+P
 tlPQTq+E
 ik1K0cu//8obcWzznmvdwQ1TqjRn/WqxW/uwh/7sdB3n+7dkQFmhtb+089kx2KbwTKC52bb8Dw1vW4/B4a89C+oybtsIe/ncuGT0gEXnARVAIrOyO/ZVHlbBmgHX70fBS+Diq5ZpwzU8RWy84XRgYm6ZHEUsII6DqY95lNFlXULTkMH+HkS9rg6EA0wr0h2XbcUc+/TTCrtJxqNjBXf/gnYM0yTtnCF2E3s6it4Y95W2EmO1hH/vebqtdQA9fWst8NuI1acI5tuGItO/fS3v8dhLlg4jvIh0zRDo/AbnKKv/tiTScLo/oOOognoElCPng8Jr0NCwPy+Tn1FBvVD1qal2G2Ir+Ocq25W/VR1r95x7cajM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, Nov 19, 2025, at 10:31 AM, Dave Hansen wrote:
> On 11/14/25 07:14, Valentin Schneider wrote:
>> +static bool flush_tlb_kernel_cond(int cpu, void *info)
>> +{
>> +	return housekeeping_cpu(cpu, HK_TYPE_KERNEL_NOISE) ||
>> +	       per_cpu(kernel_cr3_loaded, cpu);
>> +}
>
> Is it OK that 'kernel_cr3_loaded' can be be stale? Since it's not part
> of the instruction that actually sets CR3, there's a window between wh=
en
> 'kernel_cr3_loaded' is set (or cleared) and CR3 is actually written.
>
> Is that OK?
>
> It seems like it could lead to both unnecessary IPIs being sent and for
> IPIs to be missed.

I read the code earlier today and I *think* it=E2=80=99s maybe okay. It=E2=
=80=99s quite confusing that this thing is split among multiple patches,=
 and the memory ordering issues need comments.

The fact that the big flush is basically unconditional at this point hel=
ps. The fact that it=E2=80=99s tangled up with CR3 even though the curre=
nt implementation has nothing to do with CR3 does not help.

I=E2=80=99m kind of with dhansen though =E2=80=94 the fact that the impl=
ementation is so nasty coupled with the fact that modern CPUs can do thi=
s in hardware makes the whole thing kind of unpalatable.

>
> I still _really_ wish folks would be willing to get newer CPUs to get
> this behavior rather than going through all this complexity. RAR in
> particular was *specifically* designed to keep TLB flushing IPIs from
> blipping userspace for too long.

