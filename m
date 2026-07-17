Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41056C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E1466B00BC; Fri, 17 Jul 2026 13:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291BA6B00BD; Fri, 17 Jul 2026 13:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF7D6B00BE; Fri, 17 Jul 2026 13:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D726A6B00BC
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:24:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66195160183
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:24:23 +0000 (UTC)
X-FDA: 84998942406.02.6DA161E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1652C0007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:24:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jy/R/zzn";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLOFj+Zttxi4TR5N6+TKpaEIv9ZQFkLwJS4ViOE4a7A=;
	b=Roi6h9itk7kobItgwFxXa9cHw/SIv0YWucXXDE9p+Zy23UM2WHVV7CAKg3b5PECfEYX1CG
	JppZTA0DrNKWbQ3Fh4iUnuM81MzQTEDdrPjeGOTGg5uurxGN7u0YYbUwJYJ5n4F7fDTM02
	x4AxiV6Gnw/4J+lS3qXk6UcXvS87W34=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jy/R/zzn";
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309061;
	b=LMSpAksdKk3AmqhRig/ZE+SBlXmZsbNaX8uCsBfx7wmdx1zBeMsqQFn/U+sWUbggjF67Ho
	mliGSG1J6KWL9gwQ+4mFlVzxFwxZkU5fyhL2qtNGjlogP0FGd0RzUv95iKhUkv2B6g9798
	MVcFIrBb8fieie+gHLr6KpBxsTqI8G8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDA164017B;
	Fri, 17 Jul 2026 17:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228351F000E9;
	Fri, 17 Jul 2026 17:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309060;
	bh=VLOFj+Zttxi4TR5N6+TKpaEIv9ZQFkLwJS4ViOE4a7A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jy/R/zznQ/fX0xD6WV6rybNCIhaBTX6iSm5Jg7JITRWv2ghzcR7ye18rRHhHHQGZD
	 FFmElur4917rnuIAU2D6iaYmvyX6cE5urdaNNeEV49FXP9NEmV3HVWn+Uv/zu+xtBZ
	 N+L0Gv9L/NGFgOYd8lr9bhRtD6YOq+E9G1T/FkJjrsJU10TmF96mfK4B/oGKfREAPe
	 2ASq4UwxFzS1lSVsorMOdqcuvRzhnk5p6Y+tBclABITdqXQR/H9NigfoKwwTpG0Cs4
	 4oBQLaDNwbtSyFBPuM9PdvCepSZ6GwzhdlAx2xWcKEupFWqwU1bxYepwGdSlWCj7kx
	 f+W+62zvI9bNQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Alexander
 Graf <graf@amazon.com>,  David Matlack <dmatlack@google.com>,
  tarunsahu@google.com,  open list <linux-kernel@vger.kernel.org>,  "open
 list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,  "open list:KEXEC
 HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
In-Reply-To: <akvT1yBvIbvft1H_@google.com> (Samiullah Khawaja's message of
	"Mon, 6 Jul 2026 19:59:57 +0000")
References: <20260613012521.835490-1-skhawaja@google.com>
	<20260613012521.835490-2-skhawaja@google.com>
	<2vxzwlvljyzs.fsf@kernel.org> <akIask9nPTEAhd76@plex>
	<2vxzse65k938.fsf@kernel.org> <2vxz7bnhjnpa.fsf@kernel.org>
	<akvT1yBvIbvft1H_@google.com>
Date: Fri, 17 Jul 2026 19:24:17 +0200
Message-ID: <2vxz4ihxil6m.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B1652C0007
X-Stat-Signature: dz31tmozwa7by3rubub5s8w8ofdtjqpi
X-HE-Tag: 1784309061-98404
X-HE-Meta: U2FsdGVkX19ab4CQUK2/oWlw4AVVpdkcoC8lpTxSkovEYyvv/BRTxS76VLxdbM4wjTzUG53CIxK172PfzLhUzkpXOj+EkS0DeULWPNg2ckAiADHExjF82/n6rA/iS1DHSa6kHkPevsPJ9sEaeQpm0cy0FqQvcD9nVyGmdjzpkJ4mg9jS4Qf9TnYo5TZs7Khka1gV2xAbyLhvlIELu+DnKouRqQXA34K92e60Xsjm726qr4ILSziGkO8+lka3kVIk+qQz2PL4Zv7LBO4y6M/0sMZX8Hf8T7nbJbFWzwlQMyLKvQQjlypqJef8d7VP5XyqvwfLxfNYyu5ea9jKQtq5ATfSiEF2zNQGOjmaxIqEazh3ZMVJK1X65haf/nxYuLTz392Jf8EFAMijTqXh1QMLj0qnOLXhmvtlY4Tu8b0H8B7ZR9Uoj970a9cYCvnhZLlA5klp8dpJuGhfQkukiwSbtlRs3FOAetFPGzmSOMpeMJBhjoVMeHMgNs3kzdQwh/f05T7ywcGoT+YjElMESP0Pgu38vMVVzrkiPoMEMP9KfaOaXTUmWaCOi5qiJerjSNrkLIXGFgxZTwKBQMLZQ3+sYKPiSK9EXBoogmQX79qMQIaoj/kFf+60TviCbMB7OYb94axEV6QSzihmtRv0uSKvwbEkn8ROyMPCSh6dE+19GGO3D/SNprMSC1SdapXHYausBQl1IK60vXMPVEVqIeR74v8XZGHWGMONUgL3Gnsn5KA4WKtGsmFaFQfk5a3UZ3iBRbR+pVhOoNAW5s9/TELe/lWSwA+iE282RcEzLK1VrpuGR5gQzcMMGglCo+As3a1ewXwv7KbrayIfnRrdkbcvGKXmnPqVRTNTCoh1cQYbQ3f4JQ6n3iYh9iyH6sl2cvqI8i0eE4bET0YRIW3YBKF+mkpek1yaYE5ivXw3evU4yFIiF5ryCBHb0in8nzC/xopLHW4KNo93cYN9GQ1RLGB
 0GXwr6vv
 kYyUNEh7tNBNFwEmmoB/yrvoa5GX01RdfejM1KAjBdelrWBqbVqsO4rL/6oV4B6VUugDe8lkbHmknYdDSV+Pp/SES5aFTmTU9+UVuHTjQrjqyHc7+tt1MB15IrTY7BZfnh0L+1ZDsMloHR43g53FY/2kckldDncyHnUPokm1/ZpV9+ZNk66po1xOMAZm5SfVN9tmFxs+eSNCBL6FjLoTOhDHpLUdS4/wV9e44aa00kWxcKayvzFsO/hI+UAfymfAtxVbJlH4/82iT4LAmvNEg18NBrM1pq+471UDpIs4H0mY3gWI5NCgXx1Zpl86tbce6I2nKgG/14soQmqvmuvhlun0jRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06 2026, Samiullah Khawaja wrote:

> Hi,
>
> Sorry I was out of office, so couldn't contribute to this discussion
> early.
>
> On Mon, Jun 29, 2026 at 06:50:09PM +0200, Pratyush Yadav wrote:
>>On Mon, Jun 29 2026, Pratyush Yadav wrote:
>>
>>> On Mon, Jun 29 2026, Pasha Tatashin wrote:
>>>
>>>> On 06-26 13:57, Pratyush Yadav wrote:
>>>>> Hi Sami,
>>>>>
>>>>> On Sat, Jun 13 2026, Samiullah Khawaja wrote:
>>>>>
>>>>> > From: Pasha Tatashin <pasha.tatashin@soleen.com>
>>>>> >
>>>>> > Live update orchestrator file handlers depend on the preservation of
>>>>> > other files. To make sure that the dependency is preserved, the file
>>>>> > handlers needs to fetch the preservation token of the preserved
>>>>> > dependency. Similarly during restore, a file handler wants to fetch the
>>>>> > restored file of the dependency.
>>>>> >
>>>>> > Add APIs that allows fetching token of dependency during preservation,
>>>>> > and fetching the restored file dependency during restore.
>>>>> >
>>>>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>>>>> > Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>>[...]
>>>>
>>>> To achieve this, LUO provides the .can_finish() callback. So, LUO does
>>>> two-phase verification:
>>>>
>>>> 1. It iterates through all tracked files and invokes .can_finish().
>>>> 2. Only if *all* files return success does it proceed to invoke .finish().
>>>>
>>>> If a VMM restores a file (such as guest_memfd) but fails to restore its
>>>> dependency (such as the VM FD), or attempts to close the session
>>>> prematurely, the .can_finish() check for that file will fail (returning
>>>> -EBUSY), and the entire finish sequence will abort. This guarantees
>>>> kernel-enforced correctness at the session boundary and without forcing
>>>> the VMM to execute restores in a strict sequential order, which anway
>>>> would not make  any sense from kernel side due to circular dependecies
>>>> issue, where topological sort does not exist.
>>>>
>>>>>
>>>>> But on the preservation side, VMMs still do need to follow the
>>>>> topological order of dependencies. Because if they don't, the
>>>>> liveupdate_get_token_outgoing() call will fail and preservation can't
>>>>> proceed.
>>>>
>>>> Actually, preservation can also be performed in an order-independent manner.
>>>> While a handler can call liveupdate_get_token_outgoing() during .preserve(),
>>>> it can also defer this query until the .freeze() callback. Because .freeze()
>>>> is invoked after all files in the session have completed their .preserve() phase,
>>>> all dependency tokens are guaranteed to be available, completely eliminating any
>>>> topological ordering requirements during the initial preservation calls. It is
>>>> up to individual file handler implementations to decide whether they wish to
>>>> enforce ordering at .preserve() time or defer it to .freeze().
>>>
>>> That is the worst of both worlds. I get your point that LUO doesn't want
>>> to enforce dependency ordering. My arguments against that are somewhat
>>> subjective so I can live with this.
>
> Pasha replied with some interesting points already, but I want to add
> some clarification here.
>
> During preservation, enforcing order gives the following functionality:
>
> - The token of the dependency (can be retrieved during freeze as you
>   suggested).
> - The dependency is preserved and that means it has bound with the LUO
>   session lifecycle. This guarantees that it is not going to go away
>   until the session is closed.
> - Once preserved, the dependency is in some kind of "immutable" state.
>   This might not be required by all dependent FDs, but it is critical
>   for some.
>
> These ordering requirements should be clearly documented by the
> associated filehandler so the VMM knows how to do the preservation of a
> specific FD properly. This is actually similar to the memfd seal rule
> that iommufd preservation will enforce.
>>>
>>> But then you can't let file handlers enforce it as they wish. The
>>> dependency ordering is uAPI because it directly affects how VMMs
>>> preserve files. If the VMM has to keep track of dependencies for some
>>> file types and doesn't have to do so for others, that is a terrible and
>>> inconsistent API.
>
> But as you have already pointed out that the VFIO/IOMMUFD circular
> dependency is resolved, I am okay with enforcing dependency ordering
> during restore as well. However, establishing an ordered
> preserve/restore mandate in LUO at this point will force all future file
> handlers into complicated and buggy design choices if they have circular
> dependency or different lifecycle requirements.

Not really. You can always _relax_ the ordering requirements if a need
does come up. Because all the programs following the ordering will still
continue to work. The other way round won't work though.

>>>
>>> Ideally, LUO should handle the dependencies on its own. preserve() can
>>> give LUO a list of files the preserved file depends on, and LUO makes
>>> sure all the dependencies are present in the session at freeze. We would
>
> This again assumes the lifecycle of various FDs and that dependencies
> can be resolved during freeze(). Some file handlers do want order of
> preservation, and this scheme only guarantees preservation dependency
> without order, introducing hacky dependency state management until
> freeze().
>>> also need a way of getting the dependent files back from LUO on
>>> retrieve(). That would make sure the dependencies are properly enforced
>>> both on freeze and finish, and the enforcement isn't left up to the file
>>> handlers.
>>>
>>> Unfortunately all that sounds fairly complicated so I am not sure if we
>>> want to do that just yet, although I would like to hear your thoughts on
>>> this.
>>
>>We had discussion about this in the live update bi-weekly today. The
>>conclusion we arrived at is to keep the current functionality. That is,
>>we don't enforce preservation dependency.
>>
>>But that also means file handlers can't try to get their dependent file
>>in their preserve() callback, since that would implicitly enforce
>>ordering. They always _have_ to do it from their freeze() callback.
>
> This has problems at multiple levels:
>
> - This indirectly sets up a precedent in uAPI that the VMM is allowed to
>   preserve the FDs in any order and the file handler will be able to
>   handle this.
> - This will be very tricky and will force filehandler to have
>   complicated/hacky state management to handle dependency. Specifically
>   I do need iommufd to be preserved before preserving the VFIO cdev that
>   has an iommufd dependency. Not sure, but I think this will also be
>   tricky when we start preservation of VFs and SRIOV PFs.
>
> I don't think LUO should enforce an arbitrary rule like this unless we
> have a strong reasoning behind it.

It looks like you, me, and Pasha are saying slightly different things.
We all first need to take a step back and lay out our proposals clearly.
I'll write my points down, and I'll try to reproduce what I understood
from discussions with you and Pasha.

I think we should focus discussions around the below 3 high level topics,
and we can figure out the implementation details later.

1. Do dependent files need to be preserved before their main files?
2. Do we apply the same rules to preserve() and retrieve()?
3. Do the rules apply to all file handler or can file handlers choose
   their rules?

Here's my take for 1: Say A depends on B. I think it would be a good
idea for LUO to enforce that B gets preserved before A. You already
mentioned a few reasons for why. Similarly, LUO should also enforce that
B gets restored before A. We can figure out where the actual enforcement
happens, but that would be the principle of the LUO API.

Pasha suggests the opposite. In my discussions, and this email thread,
he doesn't want to enforce _any_ ordering. So you can preserve A and B
at any time and you check at freeze() that everything is present. Now I
see the value in this idea. It removes the need of tracking ordering
from VMMs. But I think it is also somewhat dangerous, because what
happens when freeze() fails? VMMs need to recover and restart the VMs or
retry live update. I don't know if they would be able to do so. This
path will likely be less tested.

But still, I can live with that. At least for memfd, guest_memfd, etc.
this shouldn't be very problematic. I am not sure about iommufd.

So in conclusion, I would prefer to have ordering, but I can live with
no ordering as well.

For 2, I think we should apply the same rules on both sides. Mainly for
consistency. The VMMs should follow the right order for preservation and
restoration. Now again, I am fine with both enforcing the ordering or
not enforcing it, but I really think the rules should be consistent
across both sides.

From my reading, I think Pasha does as well, but from talking with you,
IIUC you think retrieve is a fundamentally different operation and it
should not enforce any ordering.

I do see your point but I still think there is value in keeping things
symmetric. Unfortunately this is fairly subjective, so I don't have much
better arguments.

For 3, I _strongly_ think it should be a LUO wide policy. Leaving this
up to file handlers will become messy over time because each would come
up with its own rules and for VMMs there would be no consistency in how
they should use LUO.

I hope this helps focus our discussion to the major points. And again,
we can figure out the implementation details as we go along, so I didn't
reply to some of the points you raised in this email, to not distract
too much.

[...]

-- 
Regards,
Pratyush Yadav

