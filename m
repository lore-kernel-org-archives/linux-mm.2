Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01399C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 20:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C619E6B009D; Mon,  6 Jul 2026 16:00:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C129D6B009E; Mon,  6 Jul 2026 16:00:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD266B009F; Mon,  6 Jul 2026 16:00:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70C0B6B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 16:00:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A70351201FF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:00:05 +0000 (UTC)
X-FDA: 84959417970.16.2BA3773
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id C7C0DC0011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:00:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTINz9Re;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783368003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LAhwznhf5DkVP4v3gs3lqPrh/lcXm4gQZUhW/MOasno=;
	b=s0JSj2+L8DNv+iekWSuLAEX08p2VwsXZtyshSHIHPQSfq74xJ0ia71738BvPoI3u7460Dc
	Ha587g3skBGGCPZRjeXK97pSpQ22ZzAQdwOROjl2ip/TBJ37MZFEOUNVFwUwAU7LukrZZR
	R3YwXe+ra6GsryjbQKh5YxKnW/Z6MOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783368003;
	b=jW+DMvi8bM3eslgvlGGagjwU248/7c12zLlQXlEpPQOvTINqaXD2jCQbCoM1oQnpAaSA/E
	YMsMyCup+yFTaCAw+nO8LMQ/ISxKzm/Iyha2zAh+6grl8akNU0vmNqJx/rEa2rq29bXA31
	HLhyfzLrim2svNwGSczFfsqn+GDNnoo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTINz9Re;
	spf=pass (imf10.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cacef7d299so13435ad.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 13:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783368003; x=1783972803; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LAhwznhf5DkVP4v3gs3lqPrh/lcXm4gQZUhW/MOasno=;
        b=bTINz9RevvV4DX0BCHo+1Ele4hdNIOn+zl4A4gekiMFdgLqFLbcYm8E5yNWGY3sQtP
         58muQHUJifwZFNZtHrBSqG5PzKfrKpAJO1u9S2NQNfiRHulWgWU00rcGXBe2txrfHdIQ
         PnYv9D9khVx5gcID/gpzhgopH62pj3oE22MHq0i5VR+V/5jORix7L8ZdXVUPbmGCbNJY
         JGP9yyzGFJGZTklSIan3C9xtfIqaC2UqEmyK1YCwNuNkcG7ZOtUZGucZYCsierBOgR7H
         QGtysmkOtEvzmc7Dl9W5yivygSlSuJdJIMGMo/AsX+xxmGkYhFziKRbYyG9ftDrvi/5p
         F8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783368003; x=1783972803;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LAhwznhf5DkVP4v3gs3lqPrh/lcXm4gQZUhW/MOasno=;
        b=M70PjCzA2Ux4JPuTzSJt12By2dBm2hN6j3SPto8Xv+vChHjGXh6DzFJ4r3pKTia56t
         xSaNE5N8aIMnrI1Yvv8Bw5DsVB5pTNmLuD0HBPPIoxn52i3fx3JqHMnp1fd2+/LobHCp
         pEGmi3y4fy9zsrNxy7xOGlQpY8OCjDmI2JXDQm5yCTPXjDHJndSeasVNrJDZn3ip2CSs
         WQ/KoDL9YPk5ziK1JkFHsQ2f3j8xpraDKXExni5E7NEtna+e+85EZYIymB8uNPnq/1Fb
         bOQvfOJ4yfx3/yZnR1q9AjZiYetOB+4Hjch++gCW3PrgHu/qzfSi9Im3OUqGXW8c1bx/
         rhDg==
X-Forwarded-Encrypted: i=1; AHgh+Ro2oVsT1AqnmlN3E+kbPiLKNHBxac/GLgnFpREg76TaC86fdOTVeRWBoe16hCHrBflNG9PEL7Yzmw==@kvack.org
X-Gm-Message-State: AOJu0YyqeoHScd309NcZ8OTkCDBS7Fn4MUrhlndx4vqVV0XUVi5DMPLW
	VcUkU2BY6+sAVsa0onIWqpj1YNkCAe+FmuBDp2kb2AMsRscthS1s4U1b9nqunV3QSQ==
X-Gm-Gg: AfdE7cnOOuqPDdPgFzbbkeD4ky3Bv6se5rXKE+iPQcavWjEV53Qsj49e5fGCkDENZGU
	QEwuiLgG4SUYQ1k4yoK6v69nZ55s2etgQcFwXyJTFI87tH6F3VcK7W+ygBrhUiS+GwdFo4fEtya
	1GXrbceBLtXXtajD3sHMEIqmsbBLea2mU9MxrUK7NJ4VvIItzrjLeQ0aveh1FLcMIBdlJOn96ab
	NYjQjXKAirPTDdvkK+XJElYB134++mJ2bQRHrsMSjOGAz7Fwta/mGCmzimZJqiFw9zy9Tg3YOz5
	axywNRDlqJGah5I++m8hqt3WlH/NbLcITQ1Y67C+QkLTWJgKv9MYuGReI9jk+RdBdNG/y1XOsdP
	m1SCHFytqpdVNRcoH79750m5oP8oNG/lFF6gIFpsSNU5/03xurZlRhQCozJLbyRqJwUm1dyB7ga
	iiRCaxsY4SR2FchGRqO4QS9ITTwmJNv7T1VpfEMRDUh8sNd96VnAAL8DNCC5xiij8Xrlpt6lQXA
	mflVhEJKdc=
X-Received: by 2002:a17:903:41cf:b0:2c9:d89f:fd98 with SMTP id d9443c01a7336-2ccc71c1939mr447305ad.1.1783368002032;
        Mon, 06 Jul 2026 13:00:02 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b609b8sm4361747b3a.5.2026.07.06.13.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 13:00:01 -0700 (PDT)
Date: Mon, 6 Jul 2026 19:59:57 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, tarunsahu@google.com, open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
Message-ID: <akvT1yBvIbvft1H_@google.com>
References: <20260613012521.835490-1-skhawaja@google.com>
 <20260613012521.835490-2-skhawaja@google.com>
 <2vxzwlvljyzs.fsf@kernel.org>
 <akIask9nPTEAhd76@plex>
 <2vxzse65k938.fsf@kernel.org>
 <2vxz7bnhjnpa.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2vxz7bnhjnpa.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7C0DC0011
X-Stat-Signature: 4a7sp4mabkbijwq5xazijdu4xmwh195p
X-HE-Tag: 1783368003-218300
X-HE-Meta: U2FsdGVkX1+HkV+hNdXSoT149+AZNHYYQQAx+TioOdJUpejsTBOiT1RoqJJyd/hx/0TtgS/0Vdbh7diZ40CbWO3Z2Oy35Qfkz4TzWfdRTbMQLfUr7YPII+bm32hrNUM0Wh4ou8vh4ZizTGeHHVIxxafy/RVLasifH78y+oQhs7vtaiQFuBY//NKVIpiQ//Y/OHwJATTNza7BZTQMVUEB5ZElh/iuaCDRZeZX1zHBtTZE+pHHWkk3HRRKuLgUsC0EMarvzFi3fVsAmYFlGzd1nBTncOR05PJJU8DeLcEsPZizd0hJb8lpWNCtiYajdEjMhrRfWtsVlZkpRPijUOhdgE+owxd3Hs2O6ILHZrsT5wWZ7cxlChxFTXvhSmFxP51opcbw5neILTnTzsmyGhKVoezwnTmPB9/dFuk/O6anPUaL9O/9V8BHFOs1GtAjMuq0+l49Lcspl1ONRCCfKEhuNdLshpilHd1TJh8nSu9PLVBdlbDfAWk3THHkEJL/iFTK707VS8IomA4ZsAYAuChAOVGc6Sky5qrj8/SD8QAfILD+EEh4ggRg8OFMt+Amg6oURQrMx7fixvU2vTsecIA8rwSBWiDato2286EQhD8wbULTB1o8kAr34q/9VyJ5glZoUGVpph1oI5GaylL077vKJcPgca+fGB0iQLv7LxlNHFcrpDTVgFiC1jV13mArBud6cQ4nZZaU59cZt9klKLkyNDud/9ych5ummb83DA24oBUiE/6ujPwhW2FUuE/FbbG3p5+xn2WCochIilfobABHqvTItYiMDTEYxORTZVhAJT0BKnmYe28BNEpS9onYySotWVZofaLLv/zb4j09v/Uy2s4jSYZhNVOMSpyqraabmwM6/eafnEWeiHp40/dEgcH16g5NjGSSRbhw9n+vKQ0XOv9OQPGfDCJnZDe4karrQLKVhDcPjH6ZNajtQZuQvtRNyzGGOOoYueceWOfyxrg
 PIKS5kaE
 noCwGXDDUUXS4Nl8N30fuqP9FadN8trPnZ2nx24ydOJcf1/QX76yQgduDIMMIDD3AdYdAUVrWdf8WfxwariVNfhHPHgTxpGl7QP+DvFs5KZ1bcF2ITa2eRK3vfuFBAQIFVnlRT28QbCJFRgXQsOJMFsxqohPCsZbM1FHLCY9ebpOTDk3Sb6v0+WojCm05PQdbgVQdu+EPj7ofQL6PyuukM/77Xae6uPkB1+k6QiIcdYHD43aMIipyGJw3Po1QVikqZt2hD2IJ9ODC4K9I5RxCpKnEVIRa3qT30FgupLNYDdaycPY4K54V6odkAfihLuS5hlyF6ETkiKZmoHwnZqMsBfK5uvOsSqMgiBLoJy9nVq5MMF7mXnR+U5MfL5B5wJFpDPy8/Qz9BhxGIHW6yJcgPLBERfOnB9t/Ny/PvH0fbFnWGU10ukoQeoxvFGPx601uK5ba26JwIOuwMOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Sorry I was out of office, so couldn't contribute to this discussion
early.

On Mon, Jun 29, 2026 at 06:50:09PM +0200, Pratyush Yadav wrote:
>On Mon, Jun 29 2026, Pratyush Yadav wrote:
>
>> On Mon, Jun 29 2026, Pasha Tatashin wrote:
>>
>>> On 06-26 13:57, Pratyush Yadav wrote:
>>>> Hi Sami,
>>>>
>>>> On Sat, Jun 13 2026, Samiullah Khawaja wrote:
>>>>
>>>> > From: Pasha Tatashin <pasha.tatashin@soleen.com>
>>>> >
>>>> > Live update orchestrator file handlers depend on the preservation of
>>>> > other files. To make sure that the dependency is preserved, the file
>>>> > handlers needs to fetch the preservation token of the preserved
>>>> > dependency. Similarly during restore, a file handler wants to fetch the
>>>> > restored file of the dependency.
>>>> >
>>>> > Add APIs that allows fetching token of dependency during preservation,
>>>> > and fetching the restored file dependency during restore.
>>>> >
>>>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>>>> > Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>[...]
>>>
>>> To achieve this, LUO provides the .can_finish() callback. So, LUO does
>>> two-phase verification:
>>>
>>> 1. It iterates through all tracked files and invokes .can_finish().
>>> 2. Only if *all* files return success does it proceed to invoke .finish().
>>>
>>> If a VMM restores a file (such as guest_memfd) but fails to restore its
>>> dependency (such as the VM FD), or attempts to close the session
>>> prematurely, the .can_finish() check for that file will fail (returning
>>> -EBUSY), and the entire finish sequence will abort. This guarantees
>>> kernel-enforced correctness at the session boundary and without forcing
>>> the VMM to execute restores in a strict sequential order, which anway
>>> would not make  any sense from kernel side due to circular dependecies
>>> issue, where topological sort does not exist.
>>>
>>>>
>>>> But on the preservation side, VMMs still do need to follow the
>>>> topological order of dependencies. Because if they don't, the
>>>> liveupdate_get_token_outgoing() call will fail and preservation can't
>>>> proceed.
>>>
>>> Actually, preservation can also be performed in an order-independent manner.
>>> While a handler can call liveupdate_get_token_outgoing() during .preserve(),
>>> it can also defer this query until the .freeze() callback. Because .freeze()
>>> is invoked after all files in the session have completed their .preserve() phase,
>>> all dependency tokens are guaranteed to be available, completely eliminating any
>>> topological ordering requirements during the initial preservation calls. It is
>>> up to individual file handler implementations to decide whether they wish to
>>> enforce ordering at .preserve() time or defer it to .freeze().
>>
>> That is the worst of both worlds. I get your point that LUO doesn't want
>> to enforce dependency ordering. My arguments against that are somewhat
>> subjective so I can live with this.

Pasha replied with some interesting points already, but I want to add
some clarification here.

During preservation, enforcing order gives the following functionality:

- The token of the dependency (can be retrieved during freeze as you
   suggested).
- The dependency is preserved and that means it has bound with the LUO
   session lifecycle. This guarantees that it is not going to go away
   until the session is closed.
- Once preserved, the dependency is in some kind of "immutable" state.
   This might not be required by all dependent FDs, but it is critical
   for some.

These ordering requirements should be clearly documented by the
associated filehandler so the VMM knows how to do the preservation of a
specific FD properly. This is actually similar to the memfd seal rule
that iommufd preservation will enforce.
>>
>> But then you can't let file handlers enforce it as they wish. The
>> dependency ordering is uAPI because it directly affects how VMMs
>> preserve files. If the VMM has to keep track of dependencies for some
>> file types and doesn't have to do so for others, that is a terrible and
>> inconsistent API.

But as you have already pointed out that the VFIO/IOMMUFD circular
dependency is resolved, I am okay with enforcing dependency ordering
during restore as well. However, establishing an ordered
preserve/restore mandate in LUO at this point will force all future file
handlers into complicated and buggy design choices if they have circular
dependency or different lifecycle requirements.
>>
>> Ideally, LUO should handle the dependencies on its own. preserve() can
>> give LUO a list of files the preserved file depends on, and LUO makes
>> sure all the dependencies are present in the session at freeze. We would

This again assumes the lifecycle of various FDs and that dependencies
can be resolved during freeze(). Some file handlers do want order of
preservation, and this scheme only guarantees preservation dependency
without order, introducing hacky dependency state management until
freeze().
>> also need a way of getting the dependent files back from LUO on
>> retrieve(). That would make sure the dependencies are properly enforced
>> both on freeze and finish, and the enforcement isn't left up to the file
>> handlers.
>>
>> Unfortunately all that sounds fairly complicated so I am not sure if we
>> want to do that just yet, although I would like to hear your thoughts on
>> this.
>
>We had discussion about this in the live update bi-weekly today. The
>conclusion we arrived at is to keep the current functionality. That is,
>we don't enforce preservation dependency.
>
>But that also means file handlers can't try to get their dependent file
>in their preserve() callback, since that would implicitly enforce
>ordering. They always _have_ to do it from their freeze() callback.

This has problems at multiple levels:

- This indirectly sets up a precedent in uAPI that the VMM is allowed to
   preserve the FDs in any order and the file handler will be able to
   handle this.
- This will be very tricky and will force filehandler to have
   complicated/hacky state management to handle dependency. Specifically
   I do need iommufd to be preserved before preserving the VFIO cdev that
   has an iommufd dependency. Not sure, but I think this will also be
   tricky when we start preservation of VFs and SRIOV PFs.

I don't think LUO should enforce an arbitrary rule like this unless we
have a strong reasoning behind it.
>
>Similarly, on retrieve side, file handlers enforce their dependent files
>are restored via the can_finish() callback only.

Please elaborate: does this mean the file handler cannot fetch the
restored struct file of its dependency until can_finish()?

This would actually be worse. A filehandler that needs to take a
reference to its dependency during its own init phase would just fail to
restore. For example, it means the vfio cdev cannot auto-bind with the
iommufd until can_finish() is called.

Also can_finish() is called just before LUO finish phase, and that is
already too late. The FDs should be restored and ready to finish at that
point. Forcing the dependent to resolve/enforce dependencies during that
means the dependent FDs are half baked before that?

Again let's be careful about enforcing arbitrary rules like these in
LUO, because these end up defining uAPI and lifecycle rules that we
cannot change later.
>
>So I think the next steps for this series is to clearly document this
>requirement for file handlers in the documentation for
>liveupdate_get_token_outgoing() and liveupdate_get_file_incoming().
>
>Also, I think you need some way of tracking if the file was explicitly
>restored by userspace, which is something file handlers would then need

I think we should add a mechanism like this regardless. This will allow
file handlers like guest_memfd (if they determine it is necessary) to
verify that userspace explicitly restored their dependencies, without
forcing the ordering policy globally on everyone else.
>to call in their can_finish().
>
>[...]
>
>-- 
>Regards,
>Pratyush Yadav

Sami

