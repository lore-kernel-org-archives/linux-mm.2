Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2DAC43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9954D6B0134; Mon, 29 Jun 2026 12:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C046B0136; Mon, 29 Jun 2026 12:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883236B0137; Mon, 29 Jun 2026 12:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 521E16B0134
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:50:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D60681C0EAF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:50:14 +0000 (UTC)
X-FDA: 84933537948.20.D54F650
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C7B04000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:50:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fAQ/FQZP";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782751813;
	b=5z49qmhfw3KJ9kdESUmsrOezeFwAjkMDL+ihHTHyzW6zu30nYCnBK4cSChmwPhzkhkAE1x
	gq5rZLCKqM4aTmoqw97kzwBnIWOxnUWqBsLMePdVbAJ2ngIULnwZx5iTkiyASQJupbSJeD
	5RYIaESJMfuenwULZZv2abiqha6LcjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRYwLKFW5okacBeAUFEZkzLVQVNz/VPICpHOIwpSzVw=;
	b=L+xZgV6H4e57bJt8oo7sZHLOyywWfMQ9X4Wu4tQjplzP7jNqQ5omMclE1c3jFEukAF22AY
	DGmmrJqPRHU9berGjpkF6ujagVQ3RNnbzI4kDQqFbh7L/KyYuA3F8q7aad0oe9RfdzADyk
	1qVu2Hu/aNoWrmWZoVmRV6jwqjJ1hA4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fAQ/FQZP";
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83F1742AFA;
	Mon, 29 Jun 2026 16:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99A81F000E9;
	Mon, 29 Jun 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782751812;
	bh=fRYwLKFW5okacBeAUFEZkzLVQVNz/VPICpHOIwpSzVw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fAQ/FQZPFJdL1E+lwZz7Y2DQxvXCBRugYvrLlkLg0WufX4gAXhlk36fd2fb4nwF+p
	 bqhpD7BOox/hhIfOUYc1fQTXKz6HAbwZgZPdnHskBbL7EZ3c4c4zjrAPR4cqF6N/h8
	 aAJMsEfERBSeXOMSQ2NJDZQXa52o4o6SnlAlpYgzCTaC23UYkzHByh0MxkNcC+IdMq
	 5cveQdr4SVTQE9pEqDy1HxBJeuztseBtisogTicde16xe8uVcO/2oEBGyoY5sl0NGM
	 4lnKcHyD4IKATGQOBGfrTnqbNniyI3jx0QI+cwMhApGCzJbgR1r02pgEjoJb/CFM/V
	 d/vVxThFRTwFA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  Mike Rapoport <rppt@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  David Matlack <dmatlack@google.com>,
  tarunsahu@google.com,  open list <linux-kernel@vger.kernel.org>,  "open
 list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,  "open list:KEXEC
 HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
In-Reply-To: <2vxzse65k938.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	29 Jun 2026 11:08:11 +0200")
References: <20260613012521.835490-1-skhawaja@google.com>
	<20260613012521.835490-2-skhawaja@google.com>
	<2vxzwlvljyzs.fsf@kernel.org> <akIask9nPTEAhd76@plex>
	<2vxzse65k938.fsf@kernel.org>
Date: Mon, 29 Jun 2026 18:50:09 +0200
Message-ID: <2vxz7bnhjnpa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: ase98pfpnfrf5o71f46f1hrc95pq9onc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C7B04000D
X-HE-Tag: 1782751813-854376
X-HE-Meta: U2FsdGVkX1+FdPJ6QWMS5kJuoxuvSKRVLk94AvAx4qBdoanIrruP0Jp0j3RgKnrhhUZbR0es5Or7kKGL2BkFpbtS280RHdyTsZGyL34k1g1/CO6rlK5qjdwX04i329XBf5R+mBRHxi458h8TiLzgFU8tjpmxRHy1s4WIymEfvgCv89a6I9M7XJ1Sad7SZF8WwBsuTK1Zy0duDNaY6/4ZglLnvMbMyduXtd8s+2+9w68+/0dDUQLHK/VyTrRWaBaipj0bBw9dxW8mFZS/2Bq+qnWFwLPcWKEiiQnMLfXVovvedDmCmx+rxMx1ZqR0Rk1DGwUnISjEgm5VXFnMnXldRN6KCD1hoksnTziiwQrwqmPIbmb0Yy4IHYkEzvrEyWU4orKYj4EQSXPSig9peK8iT7TCury3dJvl8zcb1Uc7+3Q2cB/q2y727JquvS9gopQU8TbbbhNmuTZ4QVeoXH1tzBTvK1avhE9lgsfv645wPNi/n/tGbbHfyo4VqAPCRkQ4XRVZzFiPEaJAeRlRcifAwrnT/Bn5XpfJRYj72I+OybZUSj5g/sshHni+MKDxBf/yAo5nMrfSTI6duzVJczvHyN8yM0xKUtRjvUYzpJDecvo+0rWLW1QlnI1n58x58b6fivk2ZNCr9O/pwGwKZTr//c6l9qAA3BXVP7bhIlPAPo2a2I6rvhnocdKjBJMRb+RB8Uj/XIvQQroE/NKV+XGOQoB4JByu4CcLg4ZlIJeh5ttazgxxit1sjjeP48YBAC51+WMNNlgD8bVsspaxX6hWEd5xAlDJTaQl0hS3fxxa8Dp+LgYGgNMyGwYc7OnJCVTZ+f3PZ1iLl39O63Dv0aivfCarnF1zJHcRhEAbSpgUIIO1mG1xnZroPIQypyjXo3o8wQDsiuGe4zPHYy2sfBP8h7zLPRi6hB8DpcDBNKBbY13k0CU9Lhl2sFb2lAM23/qbMKb0yOfHdl/QH8+P94n
 4dhvAbWZ
 ZTYUslhZA2S3Caku5VNM8dFPHdilH8LoKTkELxlnOqzt33ZV9kQzI9QhLW1XusU9Ub9cKs9q/rqJ/JC/FtVhDVNeIr+uYj2m3/xkq91PpKga1ttZ+apYTw4CgkOvNKlWS6LBfJuWsCdAUF4l+KPjuvguA/m3hqHb+KGBEfHn0XgFFfoQbBT/kRISatqrD3SeTbaejH9tYjW/mel0OcdqlnobOP3KIRTcvAJsNuBVNaxSfplQx8KqfprKjxM4ih82UKL6WkEFaSipREKLNfia8DX7p9G2hh2XJ9MpLABoLa5yTFbwGcHVoTLlvjEAxxf+BwgmyEy5G3svVpBMDb2NW/3gFFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29 2026, Pratyush Yadav wrote:

> On Mon, Jun 29 2026, Pasha Tatashin wrote:
>
>> On 06-26 13:57, Pratyush Yadav wrote:
>>> Hi Sami,
>>> 
>>> On Sat, Jun 13 2026, Samiullah Khawaja wrote:
>>> 
>>> > From: Pasha Tatashin <pasha.tatashin@soleen.com>
>>> >
>>> > Live update orchestrator file handlers depend on the preservation of
>>> > other files. To make sure that the dependency is preserved, the file
>>> > handlers needs to fetch the preservation token of the preserved
>>> > dependency. Similarly during restore, a file handler wants to fetch the
>>> > restored file of the dependency.
>>> >
>>> > Add APIs that allows fetching token of dependency during preservation,
>>> > and fetching the restored file dependency during restore.
>>> >
>>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>>> > Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
[...]
>>
>> To achieve this, LUO provides the .can_finish() callback. So, LUO does
>> two-phase verification:
>>
>> 1. It iterates through all tracked files and invokes .can_finish().
>> 2. Only if *all* files return success does it proceed to invoke .finish().
>>
>> If a VMM restores a file (such as guest_memfd) but fails to restore its
>> dependency (such as the VM FD), or attempts to close the session 
>> prematurely, the .can_finish() check for that file will fail (returning 
>> -EBUSY), and the entire finish sequence will abort. This guarantees 
>> kernel-enforced correctness at the session boundary and without forcing 
>> the VMM to execute restores in a strict sequential order, which anway 
>> would not make  any sense from kernel side due to circular dependecies 
>> issue, where topological sort does not exist.
>>
>>> 
>>> But on the preservation side, VMMs still do need to follow the
>>> topological order of dependencies. Because if they don't, the
>>> liveupdate_get_token_outgoing() call will fail and preservation can't
>>> proceed.
>>
>> Actually, preservation can also be performed in an order-independent manner.
>> While a handler can call liveupdate_get_token_outgoing() during .preserve(),
>> it can also defer this query until the .freeze() callback. Because .freeze()
>> is invoked after all files in the session have completed their .preserve() phase,
>> all dependency tokens are guaranteed to be available, completely eliminating any
>> topological ordering requirements during the initial preservation calls. It is
>> up to individual file handler implementations to decide whether they wish to
>> enforce ordering at .preserve() time or defer it to .freeze().
>
> That is the worst of both worlds. I get your point that LUO doesn't want
> to enforce dependency ordering. My arguments against that are somewhat
> subjective so I can live with this.
>
> But then you can't let file handlers enforce it as they wish. The
> dependency ordering is uAPI because it directly affects how VMMs
> preserve files. If the VMM has to keep track of dependencies for some
> file types and doesn't have to do so for others, that is a terrible and
> inconsistent API.
>
> Ideally, LUO should handle the dependencies on its own. preserve() can
> give LUO a list of files the preserved file depends on, and LUO makes
> sure all the dependencies are present in the session at freeze. We would
> also need a way of getting the dependent files back from LUO on
> retrieve(). That would make sure the dependencies are properly enforced
> both on freeze and finish, and the enforcement isn't left up to the file
> handlers.
>
> Unfortunately all that sounds fairly complicated so I am not sure if we
> want to do that just yet, although I would like to hear your thoughts on
> this.

We had discussion about this in the live update bi-weekly today. The
conclusion we arrived at is to keep the current functionality. That is,
we don't enforce preservation dependency.

But that also means file handlers can't try to get their dependent file
in their preserve() callback, since that would implicitly enforce
ordering. They always _have_ to do it from their freeze() callback.

Similarly, on retrieve side, file handlers enforce their dependent files
are restored via the can_finish() callback only.

So I think the next steps for this series is to clearly document this
requirement for file handlers in the documentation for
liveupdate_get_token_outgoing() and liveupdate_get_file_incoming().

Also, I think you need some way of tracking if the file was explicitly
restored by userspace, which is something file handlers would then need
to call in their can_finish().

[...]

-- 
Regards,
Pratyush Yadav

