Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6417C606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=nhRbbv7L;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=dqBTENOQ
Received: by kanga.kvack.org (Postfix)
	id 5F27E6B0716; Tue, 27 Oct 2026 14:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB3A6B088F; Tue, 27 Oct 2026 14:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474A06B0716; Tue, 27 Oct 2026 14:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCCB6B0716
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 81FFB1C4487
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:32:54 +0000 (UTC)
X-FDA: 85369252668.11.2DA781C
Received: from flow-a7-smtp.messagingengine.com (flow-a7-smtp.messagingengine.com [103.168.172.142])
	by imf27.hostedemail.com (Postfix) with ESMTP id 41ABE40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:32:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=nhRbbv7L;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d qBTENO";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793125972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pW0YX5uTyvs0iTQboMCcpjVYnLuET6JVZiidtK9lRiU=;
	b=SC2igQ2T9zZSTweCiyuiSMIFuTAye7hpv6uU7qMXBzcn6gyUzYnCqLB2lgcM9B0G9HE9no
	R6OIe0xvJ0f6ShvkiEz073X4I1uRO6Jimiw+ryvlyLQ3lj3jvnOv0yFikRRDjpy7ieWv9x
	Khhyh/MzlZkyY5OhBNbkFqvVPi212Mw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=nhRbbv7L;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="d qBTENO";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.142 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793125972;
	b=fsDVQIuZddAdHRBM3j/Op79ejiKRMvZcAhX3TvoT+KAnzG+EBoqK3MRJCv96XAwz0zEuiY
	kKV0nlGXDPB/uGLk5B7ooIfCjEynvZQ9ssA2drm2JI8iecrVC+/UZpfuoRbXDv8/A6S4HI
	SIwB2gx2NvaWOuHOY7CQvycxnNdj7wQ=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailflow.phl.internal (Postfix) with ESMTP id 5FE8B13801D1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:51 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 27 Oct 2026 14:32:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793125958;
	 x=1793133158; bh=pW0YX5uTyvs0iTQboMCcpjVYnLuET6JVZiidtK9lRiU=; b=
	nhRbbv7LCz1ZQpaeWyensFpQo4X/3syWjrNRhf0TPa3WpxX/X2VdpFqv537v9O9I
	PGhjORRx1kESGQSaPHfa+QRKJpjpqdcACu5FAN3p52dFUSynF/VeBDjNcw+LEo95
	UNVVfCF+1iy7jr1xBQICX7G6IzE+zAW2IpvIGzT+P30DaFT615CXM7aNuU+rahRd
	1GUKsYa+gXVhGk/EI4Ywqj2q+VbAxE5UYf7OFubEdoAAzfhu0f2ST004eaCG4GLQ
	F1D1Q2WkugYqzgcxYwKxVL7pm03H7LMx0dT/XGKTKPQS0mI+iEZcMTRkca0vag3/
	RDWKomvJBzIYN06yZe7uWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793125958; x=
	1793133158; bh=pW0YX5uTyvs0iTQboMCcpjVYnLuET6JVZiidtK9lRiU=; b=d
	qBTENOQ45NO1fMBSlIFoaed4KzgJDaJVEDwxaWy0AU1ee6zNudEy0DlCDndCnLS6
	2Mky/tZzM0tAjCf7N4u7bi/4+2ykMhG2ESY1Sf7giCpL6gbAEOpbD5EIxKBbICPt
	usmzcw6mAAaTgxfbDhYZYxO2tvSv+8uUtfRzlCLEIP3lG32cfLfeY50SbL6O6Io4
	SgQw2YBRCXwq56w+6p7UjBanfKMGDYqL3wt7dbLsVl8wtknfLVIzXXPvDsCBbGKW
	AtxiHzQeIKi/D6MVVDwZTvVos2hYu3DWzHZsBX4JLmmgFKlBmi78/sjOEDPTgAML
	sjhtTrMnUgKadM/vzmJrA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793125958; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:YVDE8oPwHqFgHaYV3j+wJE28FEtv600mVqbqTBpWnTyYazm
	pKu7Z1socw0b+6Tu2iJF/k6uDiHG9aLdvLUA2tD+RtOKgAJrZ4ZQaFPBFwDzo4PD
	AUXtLLP5pHRUkUHeU6OjXmTh+bsM0L1FWIynHFFg+CdVjOLWPMNYtBshBju8F3ch
	tdQN1u9UT4zhnBQrewocrlYKZnzH7uMSTJe/+zqSM2qCn7cfxbF5ak2sraZ+Xkss
	l7qHRflwgk9Dk/jx5yqqsPTrdVMP+H65hejXkSDxrdKgbxtMInEFvB4B1EZfFKvW
	NchmlLR+yC8zh5xOsUjYGtCGMwgNdWOpVlU3ORA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:C7HxDmq442sA516hPg1WVqijzSVzVZyCGy6pQZqDYDY=:4/DSvQfZqcYprX4ziRRYVwk6oH+PWA9EoraJfbgloO0=;
X-ME-Sender: <xms:PO7garY621kKyqojOqTb7yy-_Jxdn-Kzm4gl1mIkpb01V8TjHgldxg>
    <xme:PO7galNXbgg3oxvhvN_4CaBu9hMm0jyCxqhA6a-T7eDOTCaJJJZAFol5ERGDjsLqK
    2259_D1ZXy5t5UtRcS7lekN3e5e2Iz3wvWTc8ZMKjdCe5rWsux30H3E>
X-ME-Proxy-Cause: dmFkZTFBrGBMzD/7DKUk8DMjlpJSCDxpPKrzK68BEfeXOQ/MXmVsz3qalb7yQm7DbWy68D
    mdR7SERoL7p1SipE/Hgrz7O8Jk/YUwS5P3bCp2T9rw+yUUT025kCXndTxgJzUfF2A/LmwU
    OoshLwBoL+gLtWMZ1eOjSZC00MjyyUjQsfwaX27BJBN1pGwR2iGIXqOSxLJd8LAZ7Ies03
    pHbxu2/tinn1z/on12HNzhMOuElx6kqVt1d934g47Fvev3+j+hQdPBK+wKrHQuA/MqaMQm
    +YwFlvGVG7S2iiDu84WQfMEEhxn2uOBT5zg/mL0ozhSd1uzGOGScjRvF7ClHEfMSlJfxcq
    YnPF1zz+aUEeQFHBKYIkKYLrgp1kUHAokLo109tnO0NExqhQz8UwJIbWoTRGGabU2W726Z
    Dhb2CJzkcYCahSEgI2QZnhI9rp+Sax2lb2xVGCjVpBRvKLDXz5qYKxyqd2QqtR2ElCh9YH
    sk3iHLFKWwH3F6St/x0/gv09bz+pznkee8K/sd27QfN9Gwd3fo2BUAJ25G4dopbDOQnb4A
    P/8JBDeUxH7I8cBQFkugJH97mQ3vUVptVMshXk/wrMwfeGdw1Y1ScOXkp/5PrPH7+diEiQ
    JTFMCYOkqnX2m+s2VfejdOjHHP+4aWKR319KAAcE5zQTI+rTtC/ZyD4VTbUg
X-ME-Proxy: <xmx:Qe7gaoJUmon3FH4sGaBdEIKD5fHQ0oH3bMQFHqz81k9r0kK1FDN-iw>
    <xmx:Qe7gahWdNxTBRCJjJwTwB9P5rA_fL9OS-9G-iMSBpvVqcHmxmO9j9w>
    <xmx:Qe7gas_yFzXCxWyV59ZvbLz29NvVSPTASADzMdDMlPDM-V9XYgRHIA>
    <xmx:Qe7garJelIc0ZjXXdljbcuMtjXIos4JgOEY9ZOwRs4BJzuv-Dex5fA>
    <xmx:Ru7gaoAQZNTTFpuQBw_xTScK29TJcstSl3feioQOcb1p07_GUyAqFEK0>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 94CBA32A0097; Tue, 27 Oct 2026 14:32:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: AUJ1OXWu3nCJ
Date: Tue, 27 Oct 2026 19:32:08 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "James Houghton" <jthoughton@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Thomas Gleixner" <tglx@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>,
 "Kees Cook" <kees@kernel.org>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Sean Christopherson" <seanjc@google.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Jim Mattson" <jmattson@google.com>,
 "Jens Axboe" <axboe@kernel.dk>, "Pavel Begunkov" <asml.silence@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, "David Sterba" <dsterba@suse.com>,
 "Chris Mason" <mason@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>,
 "John Fastabend" <john.fastabend@gmail.com>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
In-Reply-To: 
 <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <14f5f919-55bd-47c6-a1c8-6f1445cce733@app.fastmail.com>
 <CADrL8HXQdzcroeGN-ACjyy-jSAdBNHiT1_BCVVe0P+Y8ZueiyA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 41ABE40007
X-Stat-Signature: gg77mw863sbi97d5jpqszwsg76w46ggb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793125972-953929
X-HE-Meta: U2FsdGVkX18M++7RrCnbx97RiVuHReYIiaEliR7EsheqEzbO8rYrYQqYXjUWoerFw0IfiVahiOlBsP57Zdj1U+YbtgZmgoJhVOh17Akc6btI6BZcZQBzxC6ye6Uy+2Kc8sApaMAiPiJVTwdnJrbhEUEvmaCBIoEE6VL0n441WvLRV36xQV3lMwz/usLLs+E1L/iohXgvWl/GaSxrm1PFSIvRP9UFfLgnTRYSDg8iwkBx59T0bHrmuOmxPMpPb22wsywT0HvLn6h6caMn3fh8DTyO/RWoewKJBMKEQThhJZfwlehrztofQhZ6Vud1ZGaHp+eL5VRCATAi+WuV8LxsRIhUHuAYW3E6qT1iZJQpc6c6lEazl55NXh1iXo+O06xMIyXzAgcNdDn55G9IvgvW+j6kXpLsYjjpkEJA19REFGeDwAqBo8r5AAYwAKOMuN+cYAOnXNGp3FgQ+8m+aultMqKS3XhyX4ap3ZE+IhOpsAo3vJam0DWvRQ6//QQHh8ExIa5JPw3ycH1MU+ffROpSvOHEQSOcvT2M7LukAD2NAf/PrMUtTIwv7mp8I1fE8+1Fs0Rv5nvnXuszKvgNeHm2PeS+1ZUPcfGzS3cDEyckplnSdzfmROt/ExeKFSRyn+sBiV6TjiFOAerAbbwJhpGNys4jjZPdNdyX6jTccANtpbOlzbWJkqMPySv1Z7iZTAKu7bE0FW2JofgReiqpuywj/RVmvD89ac2JeRntrkVNI86wQvQNo+CK90z9RAiFb8ovESX75glNadfmWSyqCVTeLmPiATPIhX2DT76EBqFJ0vryaLKYbSt5UgO5PsYxIkqnJ0mYXTS8VVijAQpUlh0odeoMj1L0IkERcr3GbDR0cfzpW1j9GTFOSnejnlqU6g1cZVNLv/wM8ijPi3CkervpzecmzuWjSo9QY+IHFnWfUyW9Lfbf//DPvEwzAugvqIzpaV9hqyrtLQ4riw4xCo6
 2dZvC0hy
 kwbUxDpzBi3fC/G9Ce4X/VjqvgWD0xWPKFvyTmPSm4e7h2TcRlqxpMUoHVMTPYBhYoMmtoVBpkGlf74fd62LKdfBnYtCiH5F7/lqowEyNA5j2H1JJj3Fk9DBFCeJNQlYTCMOdcT5OQCsEETouBRpPfJtfkXikMi+E04mjynvKL07759UkEjzJBD6+yScHko+PSYi0Sy9UF8MbNrp0oXKnfN3A/09OkR2owM4q57kCjejcqTjHWhJHyfR6X9e14DEwkCCngWwPou85zuIFRM/0MB0JByOyi+l5c69fKkQe4MhkTHRBJxWnRvbEGJE+sinnCdbl71ixK91UO84S298aLLJGAgub+P/m9dZfOe2zVu8Hq8WtkJHzuj1IZhLLE34Vht3m5GTc2iIar4SFoVn3fg2ziiT6p79oSEyNceVvVtBc5jVT7Z4M766M7yGnrNg7FKiwDfzCPZoHW6c52l6bzdtllUfVc4FFKXob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> On Mon, Oct 26, 2026 at 5:13=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> =
wrote:
>>
>> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
>> the current process is only set in user_access_begin() and would
>> not point to any task here. Without ttbr0_pan, it should be
>> covered by cpu_set_reserved_ttbr0() turning off all user space access
>> for kernel threads.
>>
>> Should this perhaps be addressed in architecture specific code
>> instead of in a common place?
>
> You're right that whether corruption can actually occur depends on the
> architecture and config. I'll write a note about this in the v2 cover
> letter.
>
> That being said, I still think the right thing to do is to have the
> new check(s) in common code. Instances of improper uaccesses are still
> bugs, even if no corruption occurs.

I agree we have to do something to prevent the problem for most
configurations and find any newly introduced bugs.  The questions
that need to be properly decided are

 - does there need to be any compile-time configuration to skip
   the extra checks and/or the warnings?

 - are there any cheaper ways to make it safe than to add a
   condition on each user access?
   E.g. the original lazy mm switch was intended to avoid
   expensive TLB flushes when switching to a kernel thread and
   back to the original task on 32-bit x86. On modern CPUs,
   the MMU can deal with multiple ASIDs cheaply, so turning
   off user access in a kernel thread may be cheaper than
   adding code to uaccess depending on the architecture.

>> I would think that user_access_begin() is a more natural place
>> for the added checks, as this should be called exactly once for
>> any function that accesses user space and also stays out of the
>> way of the copy_from_kernel_nofault() etc.
>
> user_access_begin() isn't used in a lot of places that I want to
> catch, including the KVM case. Roughly:
>
>   kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()
>
> There's no user_access_begin() in there. :/

Good point, yes. After the changes described in
https://lwn.net/Articles/1102061/, I had assumed that all
__copy_{from,to}_user() are going from common code, but it looks
like the series so far only touches __{get,put}_user().

There are of course few enough of these left that I think
we can consider doing the same thing here and turn them all
into the checking version:

$ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
drivers/gpu/drm/i915/i915_gem.c
drivers/gpu/drm/i915/i915_query.c
drivers/usb/gadget/udc/atmel_usba_udc.c
drivers/vhost/scsi.c
drivers/vhost/vhost.c
mm/kasan/kasan_test_c.c
virt/kvm/kvm_main.c

> I do think user_access_begin() should have the new check though, so
> I've added it in the v2.

I had the details confused here. Seing that user_access_begin()
and the other accessors always call access_ok() at some
point, maybe that would be enough?:

--- a/include/asm-generic/access_ok.h
+++ b/include/asm-generic/access_ok.h
@@ -33,6 +33,9 @@ static inline int __access_ok(const void __user *ptr, =
unsigned long size)
        unsigned long limit =3D TASK_SIZE_MAX;
        unsigned long addr =3D (unsigned long)ptr;
=20
+       if (WARN_ONCE(!current->mm))
+               return false;
+
        if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
            !IS_ENABLED(CONFIG_MMU))
                return true;

(plus the few extra copies of access_ok()/__access_ok())

As a quick fix I would probably start with just the 'if (!mm) return fal=
se'
bit here to get something merged while we still discuss the other
details.

      Arnd

