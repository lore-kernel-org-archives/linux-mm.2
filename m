Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67236C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272CF6B0005; Mon, 29 Jun 2026 03:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A166B0088; Mon, 29 Jun 2026 03:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160A26B008A; Mon, 29 Jun 2026 03:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E00856B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:32:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A1E1A05F7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:32:19 +0000 (UTC)
X-FDA: 84932131998.06.C487463
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf07.hostedemail.com (Postfix) with ESMTP id 79BA040007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:32:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U4PGCrH1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718337;
	b=uI/9q/4pPzHfUPEtcPv5KY5bKnu7zIC3HWdTSgUUZWdc1ZGvIO3ufWllx9+YrbFFMefAOR
	8Xq5rmLzlXn8xH6M44d6QE3HSZN5Tfv//+yVBIxz3qbsydueAsIYNxX7+WuboRELIQUZRN
	E8mzqWGGN9Nip5Sf8c2LwTet5wV+Edg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v6W6k2MU5dZ6c3Yzz6iw0lMzjubTnc25U0LLuynrUI=;
	b=CNU+3CBVPX0XqpGfCy6XBJ9TOX/grpUqPyiPowemGl1CoVagUu8AvKlSOoWAduHzJOKwca
	9lEhtrPORbfpY12+6LfC8oD1HdLyiDg1zrvZxnP5E62J6XejW4AHub2ysKWzSDcRjSAqLO
	uJLhxz10wghKbHVzdVJXEs+zWZCwGHQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U4PGCrH1;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8eeb4508f29so15982546d6.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 00:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1782718336; x=1783323136; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1v6W6k2MU5dZ6c3Yzz6iw0lMzjubTnc25U0LLuynrUI=;
        b=U4PGCrH1VcotxHPWhra7bEjiOUq/FG7rgilkkJtvtDgJg8UcxU3aDdRq1YSic0T9MW
         nO3IvR3mTJiNE9oLSygzKe1UJk+5fvCyDbeXkOLs8oWMtYF1KbxiXPI1YKZR+IfPahMG
         e8gFboCqpoqmoCEnPEqXbzjR4oUdmnaZJ3CYmeyNko644IUbxtdOz5IFBcamzboC3Z6w
         XiQpBNg4ajT1e3LrolUae0KoRZhUDc1R6qyDUXUF9ODm/sMwSmA/HtiRTG28DbuwbK6A
         S5J4KMPL4ERjoLV0zgEECbYFIenmb/pfGeEY3Rbkf0KCHKMaf7GaS/HlFQOAhouh7MPn
         rHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782718336; x=1783323136;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v6W6k2MU5dZ6c3Yzz6iw0lMzjubTnc25U0LLuynrUI=;
        b=dvwGPPjns9HDZCfVV32SQxa5xBfHSRMu7y1A0f+j60/B6EtQPIxQJ4lr297P3MTPEH
         7/q+STECAKCewDSBo3nnHtbJgasKl/vMlDo/ONbCr5zZJh+6hTSdhLv5m2pvpWxeaf92
         Cu4O2ouGr+U0wHTr2N9Re61yJ/0O+hxV/IANETv/RRymORi06J8/0ceyEvMkqJ5iY0nG
         2xRrBltLUZ+PlEgokUcH2cD0WwrZX/JPWHwa/gd4dhw/OmFbXSpccnqoP5lTJ0KpmRbU
         QFBfm2L+l4JU8GQCv1G88bHQbhjXdz+9GxSUDSzRWOPwuM/SY8JVdH1Le8WNcmrqQQKw
         vWZw==
X-Forwarded-Encrypted: i=1; AHgh+Rqv8adMpyIikVki6xMB5dNSmsuWusdnP3cw/WxNr18TDRqrPGWMTatg0AeHpqNYb05M+dkBjNTTfA==@kvack.org
X-Gm-Message-State: AOJu0YySadvirnA7Sh0fI7TmVoJ7pubQUNr0rmQENc6hlaFuR0zMMJXr
	RKM42iR7hVmOc70Qxog3qzjf5D+7MfFJwK8QQCkjKNun46+kQVkbbPn3rmckkV3xyXM=
X-Gm-Gg: AfdE7cl6aJFDFza8QnvlHkAU6aWL2E7i380LwCsTTaoOo56rBI4dtDsQvLe10YNLL4a
	DieCq8aEWQ1qI0ndqAermNx3TuDciW3xI/0/bXzQa7aCJJKBlmTH1X84RXUFwBSCloQfbDTHWWN
	16Y48VBZBRdaMNY7V1Wl3lzcfFbjcvSQNFmFyUlbXH4R1uJFWgTix6uPK7k+3oUJZsst3KseDXt
	AgJFJMQx6RE+wc+/CaOMMV2A5vivVksXoWHh4UF2GEMvosYbhi9CHmG9IGBaH8vTKZpGwwaKQeY
	Pn4fpUX5dLuu7qC+7DPqpUvAo7YWcG5j/S1bxmrS+eT9KruNmAdcGtyHkIhELHUc+9RR4vwJ6b6
	U6bZ8xPE68AmaIwe/2309KV2fezlyuhIMEYuqkm9O0RxK5+Ibf8WrA9IjbNw4jpZH2DXqWZJY2d
	nC+bpVvUaimzdrSryGwSipvyF6biuEfJDeXR4FnDg5
X-Received: by 2002:a05:6214:6010:b0:8e9:f5de:d5c2 with SMTP id 6a1803df08f44-8e9f5ded9b5mr130841736d6.57.1782718336450;
        Mon, 29 Jun 2026 00:32:16 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ef55c2a4c2sm47392796d6.10.2026.06.29.00.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 00:32:15 -0700 (PDT)
Date: Mon, 29 Jun 2026 07:32:14 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Graf <graf@amazon.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, "open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
Message-ID: <akIask9nPTEAhd76@plex>
References: <20260613012521.835490-1-skhawaja@google.com>
 <20260613012521.835490-2-skhawaja@google.com>
 <2vxzwlvljyzs.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzwlvljyzs.fsf@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79BA040007
X-Rspam-User: 
X-Stat-Signature: 4e46ydwhtn7ycjtbanqqgcdko6jjdtrx
X-HE-Tag: 1782718337-627897
X-HE-Meta: U2FsdGVkX1/yDBGO/l6oZRz8qPWBs0L81wY2pt2yJFntmpIO99KiDX5fOAH+oXdIzrpm7h1DiQN0g5/ahSALORdr2iv0E5TgqswUa6nx+QpS0hZo4VQbQnRFN/jkBAC3euIv6X6dNN2WpmdVS66n7eOpx7F7PJIQAWXFbO06SUjAu4dhGkJ4GqoZM3quBD5BxI3srRrqO5b/q4PLqZUrH9A44vVefL7YzkG76dQnJ7WYGeew3CU6dputfSME5vE03k6GYEKVBJ7ZFVZ/gFhIYinRgmqrPe9dSOadZo0dIkPMPAx2dtCjx7IzXEMoR4kg/rTOtHeBV7y3DN2vEt+TMhVsxtla20n8NLXckNPoAQIrzywAS7g4//LLCaWaZZgOEV+TBwsJ5xUpaYtzOnvuD6hzmjDFcUICT8F/DUe/LwCS968IdtXus7OWY+w4xnXnb2xXzO7ZEEApEiXFmDhxJ8dKqo4ThXMTngiZCLat5SdtNPgsZXA0OcdmhQuWZQ8T9UbMVD2wWd8n0n6dZzAdcrCXjN7lizcfTNsE7opmtBz74jvAmwlM9heiBbw9R4LjI83iUDF0hj92qKTkTQQ/Sj5CvI4ciiirWBpWRptRdQYgXvOhUBcj3C73GKvgBj86Ys4tL88DOgF4kMU3bTdsMd+zVI5K7WQsjt6Qxqwjht/f0d49FcyzVKG7mRoKvEBaF+W/yhxtluYrFHkn7POgX8QSLyOflFeiLyva06g0E/2r2nWGLN7QK7RV4E+8VI5kSF3lYn3FnfwpifnXbDLRizxj24bxb42jNUkkGdPq6RqmWJHZFr1UwjrOeepSviA5OI/AZ9DPoVvdJlYGL+VnLzuK0ka+cWifo5jugb2vEPaTZzwUDwBp8wTyQ+Xinb+ICcuA0lgQ+o7Pes8w4N1M9aCu0gMYC37V1ULU9kJOPOu4W41Bzckrw0tPVXfjriUSjwy4diLw/AUfPWjBg24
 K7/lLMJT
 PlK8mZ2+SU8j1rn1cwheTxu5PsaizzzNLdJjGanZR0fM+rQ4JxRN2ME/e6/GLz/yv9uzij8DjmbqDlnzD4/e0/wVs0EWwz/xtX2plx22LELdAAxGPtQRj4QAggYFF5RGWUsHtDMSF5p5PwXX+FNNH71NMJbgTLs7+Yrfj+khP7WQadLyGVl0tehmNJUtT1dwMwLL+ZG5dFCli8j0DJahGKIHl6QWoNQrBr8P5ZVM7aWdullXz3XiooGoFQvVNc10IWf41P888Gx92GINTX2Y3c+MZUEQOM2R3Z8kbif3q9hevhDsrO2jETkhS4nxg3bVBWjBXVdZqDq1f5swnQKXyySq7mAKft/lQ8oHlIKroCS6Fcbi3ALo4ZRuyIXkEfYe19o+i0uhjQ6s6Odnr0QpID8f7rr+b6XQygtxXHAO19XErhaZ3EjBJ6szaUqaJIMBDF2SW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-26 13:57, Pratyush Yadav wrote:
> Hi Sami,
> 
> On Sat, Jun 13 2026, Samiullah Khawaja wrote:
> 
> > From: Pasha Tatashin <pasha.tatashin@soleen.com>
> >
> > Live update orchestrator file handlers depend on the preservation of
> > other files. To make sure that the dependency is preserved, the file
> > handlers needs to fetch the preservation token of the preserved
> > dependency. Similarly during restore, a file handler wants to fetch the
> > restored file of the dependency.
> >
> > Add APIs that allows fetching token of dependency during preservation,
> > and fetching the restored file dependency during restore.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> 
> We discussed this once already on a call, but I'll write my argument out
> here for everyone else to get a say as well.
> 
> While it isn't obvious, this patch implicitly defines a part of the uAPI
> for live update. This patch says to VMMs (or other live update users)
> that "you can restore dependent files in any order". That is, VMMs
> don't have to restore the files in a topological sort order or
> dependencies, they can do so in any order and the kernel will manage the
> dependencies on its own.

Avoiding a forced dependency ordering is a deliberate design choice in 
LUO, to avoid any kind of circular dependeces: A depends on B, B depends 
on C, and C depends on A.

To achieve this, LUO provides the .can_finish() callback. So, LUO does
two-phase verification:

1. It iterates through all tracked files and invokes .can_finish().
2. Only if *all* files return success does it proceed to invoke .finish().

If a VMM restores a file (such as guest_memfd) but fails to restore its
dependency (such as the VM FD), or attempts to close the session 
prematurely, the .can_finish() check for that file will fail (returning 
-EBUSY), and the entire finish sequence will abort. This guarantees 
kernel-enforced correctness at the session boundary and without forcing 
the VMM to execute restores in a strict sequential order, which anway 
would not make  any sense from kernel side due to circular dependecies 
issue, where topological sort does not exist.

> 
> But on the preservation side, VMMs still do need to follow the
> topological order of dependencies. Because if they don't, the
> liveupdate_get_token_outgoing() call will fail and preservation can't
> proceed.

Actually, preservation can also be performed in an order-independent manner.
While a handler can call liveupdate_get_token_outgoing() during .preserve(),
it can also defer this query until the .freeze() callback. Because .freeze()
is invoked after all files in the session have completed their .preserve() phase,
all dependency tokens are guaranteed to be available, completely eliminating any
topological ordering requirements during the initial preservation calls. It is
up to individual file handler implementations to decide whether they wish to
enforce ordering at .preserve() time or defer it to .freeze().

> In simple words, if file type A depends on file type B, VMMs always need
> to preserve B before A, because A's preservation will try to find B's
> token, and if B is not preserved that will fail. On the _restore_ side
> though, liveupdate_get_file_incoming() implicitly retrieves the file so
> the VMM can restore then in any order.
> 
> I don't like this for a couple reasons. First, this makes the API
> asymmetric. If the VMM needs to manage dependency order during
> preservation anyway, why not do it on retrieve as well?
> 
> Second, the API is easier to misuse. The VMM can restore A but not B,
> and then close the session. It will go on its merry way never knowing it
> did something wrong. For example, guest_memfd depends on its VM FD. With
> this patch, LUO will allow restoring guest_memfd without restoring the
> VM FD. This makes the guest_memfd practically useless. Yes, it is a bug
> in the VMM anyway, but if guest_memfd restore was denied, then it would
> be easier to catch.
> 
> The kernel will keep itself safe in either case, but it will make the
> API harder to misuse. And you can always _relax_ the ordering
> requirement if there is a need in the future, but you can't go the other
> way round.
> 
> So that's my question: do we enforce restore ordering? The code change
> should be relatively simple. You just need to fail if the file is not
> already restored in liveupdate_get_file_incoming().
> 
> In either case, please at least add a piece in the documentation about
> this ordering. We should not leave it implicit.

As explained above, the .can_finish() callback addresses this problem 
and prevents any misuse (such as closing a session with a missing VM FD 
dependency).

That said, I agree that these ordering semantics, deferred verification 
model, and the exact roles of .can_finish() and .freeze() should not 
remain implicit. It makes sense adding details to the documentation to 
clarify this behavior.

Pasha

