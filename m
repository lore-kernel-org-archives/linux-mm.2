Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610A2C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230D16B00A9; Wed,  1 Jul 2026 08:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1F66B00AB; Wed,  1 Jul 2026 08:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8446B00AC; Wed,  1 Jul 2026 08:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6A746B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:15:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61DEF140300
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:15:40 +0000 (UTC)
X-FDA: 84940103640.16.D1BACB2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 788041C000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:15:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osDeNUtR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782908138;
	b=Cd0bLHM3XJJPRjdfPRine3OhD9cFMLbGzzEjwy6TYEjlm3dzNqWax9+D4CH061+xkHfUYk
	oDm8S1mIeDtiZZ+EuVw5vFGBcjVj3RzgfSWwciFA4MfQJruxlM5GZSqo2NhVu+WwLSAIbc
	pwXyANrxQo6v6qSECEIzy4QJT7ttSZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782908138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u9vIgqlb5PzQumgrF7Npwpto2QFwHQxQQBOLn0q9I5Q=;
	b=cjFZsqLUA693TyuweBRXF/6386ehA0Gv959biWf1+f+Uy89p2ZRZ99Mn+8AdDMgmnqcAtw
	kMRJZ7uS0x83WosrRy2l0ZdYefNUqP1jZGUx5uRTx6xJTaOtxkR6ONvCaKuzuMsuZZ80oz
	2PJHiMgU8JueaDagVnnaRRDZL8joRlM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=osDeNUtR;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FF16423BE;
	Wed,  1 Jul 2026 12:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BC21F000E9;
	Wed,  1 Jul 2026 12:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782908137;
	bh=u9vIgqlb5PzQumgrF7Npwpto2QFwHQxQQBOLn0q9I5Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=osDeNUtRA6PQBEPedTeWhJRfP/tCCXhUr/ZNMGCnyo+9SavtNZmLKrTe8+CU+dO7A
	 F9kMlvB8YKik/gZLC9IIa8adwsJYzBJC0q/lSL3cVKEr7qSkwPL3TWaSRyIi3NzP2V
	 fuzp+nC4O/o+xBUqfEICXBFStZpayvVK60JYi36RgD0xf3zjBfPdWxr5O3002pqbzF
	 GGd9CS4JQnCHv1oJ/YgD6zJTEswVMLsLojleLBtmsjwqOe9G0TxuPk+HfEXhTwBVc6
	 E4+de2OsNisZ1L5LtiS0REhRgR1PgRcOVr2+RX9UQiCCi2Xigd3Es3VXkZ4XHlc7be
	 XVVAjwgsMgXww==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Chenghao Duan <duanchenghao@kylinos.cn>,  Pratyush Yadav
 <pratyush@kernel.org>,  viro@zeniv.linux.org.uk,  brauner@kernel.org,
  jack@suse.cz,  linux-fsdevel@vger.kernel.org,  pasha.tatashin@soleen.com,
  linux-kernel@vger.kernel.org,  rppt@kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  jianghaoran@kylinos.cn
Subject: Re: [PATCH v1 1/2] eventfd: luo: luo support for preserving eventfd
In-Reply-To: <CALzav=c+RzWpJTrpsdwnHUT=EZCGv=FGtmDq9ipDE7jNuWNX0g@mail.gmail.com>
	(David Matlack's message of "Tue, 30 Jun 2026 15:55:11 -0700")
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
	<20260625054946.73445-2-duanchenghao@kylinos.cn>
	<2vxzfr2bkn0j.fsf@kernel.org> <20260629100621.GA215869@chenghao-pc>
	<CALzav=c+RzWpJTrpsdwnHUT=EZCGv=FGtmDq9ipDE7jNuWNX0g@mail.gmail.com>
Date: Wed, 01 Jul 2026 14:15:33 +0200
Message-ID: <2vxztsqihpne.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 788041C000E
X-Stat-Signature: 35g1ee7b4mo1rd6krop1h48erser38ty
X-HE-Tag: 1782908138-610183
X-HE-Meta: U2FsdGVkX18307zQcdQCUtLPt5GH0dc4QD3G6FBcoLHGMPePiKCC8Rgae8TrlJQ7IHU3vi++iNfTWKqghPmQxFbvvIE5RAJSQPJyL57SmGx4EXiGro6Lw262+4NP0P9AsHaIbWY85g5dVYobsxkXrNTF6XkDbOh04g9lq8T1Ca5ONPAn15oLUTzQxVjUkhu6hObRZ6xB8jnqQO052crIehZ3glJRhwS/BBr7T86I3amdwkN59XQZ5dZ/ZPss/Ab9kSWGDPu4kqpqHOVqOFXUneXNV0vD4JvsA7g2rMQMdncCVrBpAR5JtotqLGJoQzagPCeH1Rc0krpZpUmZcOTWxkHCi6l8VjnNC1Y7wtmETEskAMlEA+jsE2S6CAbc9K0kwiRRBvG5J8Bvc8D6BIhE5+bXlSRL+NvmYkV9VtFrFCdhZWRFEVBgNgisfXJ3MtSx4xI/ZdwgLrXuEGARjV5bek/iXSj3HZZ4Sha5gH55HZe98/ewdzgHSHGxZJXT4hGHt5Pwh0oSjWhn1EhcLx971cpCq1k6+Uuu82Wv15jTpl5yIwINnPpRBvVPS3zFQON+k00/M47kx7MXGTeP4EF58PYQt11nSAbz79YltmmKItU0XGdWCUVipHXxJPIESFAO0S52w97f/8kchoGbJbeX2wUrZ4YH5a6zrcQsXgofJrpyPNJ1lzH39K1Fdk2hxLatFHxgT7/Szjh5BSuEoqW70VFD5awYZYFkPG/MIrD+BPO4l+HWdMkqz0u4vxuENw53X98EufpDkl6h8U2XlIOGC3TJPs+t94qQ9D9fuKOKWYhjnxLIZ2LrTZCGwPIXaCF6o+shzrJepgOmgZOHj/oq+M8DABwt4DiAiBK7JDw6fw9OABHWQvNmwBXqgcTUeIazpcuHkt16u/C6JAo6HuCn+ezOaFvO32lec5tjFaRkFanmnAAf75zGAgeUrLQBEK538uk0b8Jwa8mXHex40FM
 qIFWxQ+2
 N4wz3mi3kxt/8ydmXolE7yKNS/vdXHoM91GSDYeTxcEoseKZaRUnf+VgUv/h4huv9vaaxIAlFFm5s6skzknAEM9ctKyCGxBJNg5AyBeK6ZB05FJmug4QCaF4e+rI0nZe5C2DEV/+eiZhna3Qoo4L67I1V62ub9orNn5chWzJB3oeISIWeWmmOZnRLebPgHpPMc/b5UPFG41XR4Gzj51HdHLaFA0BKwRE1/4+7QhznXZGn0V6qfSBY6AKdOwWDDHPrYRTSbLbPydb5F7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30 2026, David Matlack wrote:

> On Mon, Jun 29, 2026 at 3:06=E2=80=AFAM Chenghao Duan <duanchenghao@kylin=
os.cn> wrote:
>>
>> On Thu, Jun 25, 2026 at 11:06:04AM +0200, Pratyush Yadav wrote:
>> > On Thu, Jun 25 2026, Chenghao Duan wrote:
>> >
>> > > This patch adds support for preserving eventfd file descriptors acro=
ss
>> > > kexec live updates using the Live Update Orchestrator (LUO) framewor=
k.
>> > > Userspace applications using eventfd for event notification can now
>> > > maintain their state across kernel updates.
>> > >
>> > > Preserved State:
>> > > The following properties of the eventfd are preserved across kexec:
>> > > - Counter Value: The current 64-bit counter value, including any pen=
ding
>> > >   events that have been signaled but not yet consumed by readers.
>> > > - File Flags: The creation flags (EFD_SEMAPHORE, EFD_CLOEXEC, EFD_NO=
NBLOCK)
>> > >   are preserved.
>> > >
>> > > Non-Preserved State:
>> > > - File Descriptor Number: The eventfd will be assigned a new fd numb=
er
>> > >   in the target process after restore.
>> > > - Wait Queue State: Any processes blocked on read() operations will =
be
>> > >   woken up and need to re-establish their blocking state.
>> > > - All other internal state is reset to default.
>> > >
>> > > Changes:
>> > > - fs/eventfd.c: Add eventfd_luo_get_state() to safely read eventfd s=
tate
>> > >   (count and flags), and eventfd_create() helper function.
>> > > - fs/eventfd_luo.c: New file implementing LUO file operations:
>> > >   preserve, freeze, unpreserve, retrieve, and finish callbacks.
>> > > - include/linux/eventfd.h: Export new functions.
>> > > - include/linux/kho/abi/eventfd.h: Define the ABI contract with
>> > >   eventfd_luo_ser structure for serialization.
>> >
>> > Why do you need to preserve this? Why don't you create a fresh one aft=
er
>> > kexec? You just preserve the counter, which looks pretty much useless.
>> > You can just as well open a new eventfd after kexec and set the counter
>> > value if you care about it.
>>
>> Thank you very much for your review and suggestions.
>>
>> My original plan was to integrate KVM with eventfd. Eventfd serves as a
>> critical notification mechanism between guest and host, and it is widely
>> adopted in various scenarios such as networking, file systems, and
>> interrupt handling.
>>
>> At present, however, I have only implemented the preserve and retrieve
>> logic for eventfd, and the integration with KVM has not yet been
>> completed.
>>
>> I have a question and would greatly appreciate your help with it.
>> I have been closely following upstream developments for the liveupdate
>> feature. As I understand it, liveupdate is primarily targeted at cloud
>> virtual machine scenarios. The upstream community has completed the
>> core framework for liveupdate and memfd, and ongoing discussions are
>> focused on state preservation and restoration for VFIO and IOMMU.
>
> Yes that's correct, but that work is to solve some very specific
> problems for virtual machine scenarios:
>
>  1. memfd preservation allows preserving guest memory and userspace
> (e.g. VMM) state in-place across Live Update.
>  2. VFIO/IOMMU preservation allows PCIe devices assigned to virtual
> machines to keep running uninterrupted across Live Update.
>
> I think this series is missing a description of the problem solved by
> preserving eventfds. We don't want to preserve all types of fds just
> for the sake of it. That will bloat the ABI (which will make
> maintaining version compaitibility harder) without any gain.

Yep. I'm not an expert on eventfd/KVM, but from my reading it looks like
it is only a signaling mechanism, and you can set it up fresh after a
live update, before you resume your VMs. There is no state here that
needs to be preserved.

Without a good reason on _why_ the eventfd state needs to be preserved,
I don't think this series should go forward.

>
>>
>> I would like to clarify the following points regarding upstream=E2=80=99s
>> overall roadmap for the liveupdate feature:
>> 1. What is the complete upstream plan for liveupdate?

I don't think there is a single "upstream plan" anywhere. But I reckon
the next few things I have seen people work on are adding support for
VFIO, PCI, IOMMU, guest_memfd, HugeTLB. Maybe TDX or other confidential
compute at some point, though I haven't seen anything concrete about
them.

>> 2. What will the final deliverables look like once fully implemented?
>> 3. Will any new kernel internal interfaces or dedicated userspace tools
>> be introduced?

Who knows, we add kernel interfaces when we see a need for it.

Systemd has recently gained support for live update.

>> 4.  Does the upstream community maintain an official TODO list tracking
>> outstanding work items for liveupdate?
>
> I don't think we have anything comprehensive but there is a ton of
> work to be done if you are looking to help.
>
> A good first step would be to attend the bi-weekly Hypervisor Live
> Update meeting. See
> https://lore.kernel.org/kexec/aiWW6ZwwalqQmVcB@google.com/. The next
> one is on July 13th.

+1

--=20
Regards,
Pratyush Yadav

