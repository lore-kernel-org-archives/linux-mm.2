Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 461C9D6AAE9
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 16:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936C66B008A; Thu,  2 Apr 2026 12:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6EB6B008C; Thu,  2 Apr 2026 12:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FCE96B0092; Thu,  2 Apr 2026 12:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6736B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:21:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC1BC13BAAF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:21:23 +0000 (UTC)
X-FDA: 84614130846.10.0061F92
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4B0F6100012
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 16:21:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Il8ShCZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775146881; a=rsa-sha256;
	cv=none;
	b=NsXJ05t8eygDGfsP8v/6Q3Isg64pLXUH7h5OX3Q0hmQTVl+1Rh3TIyT7IN5qTqwmXGrgrj
	dqYKIWwSYp7HUbrdAq/Bu5ODeotOLp7lOIt2kysisylmhLVBaioLR9Kb+aHUZ9SH7V3BMr
	88g1HH4xf0GbbRg8MfXohUNzDENZJJo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Il8ShCZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775146881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ek8aMjJm5dpR+VqUYccdHNpXqo0mlItBFL/r3oMAf2M=;
	b=ZqwSusWvzIxNN0ovnKsvI1FdiVQC96WAPXk81f5Atx8/wacEj53mFux2S9uQtFMa9/ita+
	w10m2xmji1Pc/haCi+LZlXa43wFapUhYoR5Ac9ccx53PCmidn2P1ccux41+LTYrgBhMS8t
	iHhev91f7Jjksl1eb3o0iqjK+L3SABA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 411AB43DE3;
	Thu,  2 Apr 2026 16:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5FCC116C6;
	Thu,  2 Apr 2026 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775146880;
	bh=VPxvQSupAhaLkBsECVCyj57o8OKTQESUiFeywVyxy70=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Il8ShCZX8EniFze/XLUq0ESVGJkvF9U52IZtwOd63sP95QkCFdfBCmd6214CoRXqh
	 9FOUAYd+kcRuhIVok+E2KqtOjkpyTQNpZ4OrOuBUrBsZvuNd73ERy/eSMnYIJySJx9
	 MIfPupm6DEiHYhXc8qwuFkI7jwY5lL+WS11U7N+/jWopkWqmkm9HjGcmWOPhU9nZtH
	 8AuVObOcb2JUeSkVjYaE2uXUu61LCBMCwb3fI2ddw+c/Lmpz1kwXQDKmrF4w1CRXLH
	 0kwy7iFfF8TQWrT53qfNwHKLIYqqk7AF2SjzR8GnAzRVg3PThe+AMI1jkXMn5w10Q6
	 3/QWVMp7YODeA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 05/10] liveupdate: Defer FLB module refcounting to
 active sessions
In-Reply-To: <20260327033335.696621-6-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:29 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-6-pasha.tatashin@soleen.com>
Date: Thu, 02 Apr 2026 16:21:16 +0000
Message-ID: <2vxza4vlfi4j.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4B0F6100012
X-Stat-Signature: r6683bzttgazexfqypm7rizsbok5sntq
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775146881-848423
X-HE-Meta: U2FsdGVkX197+yPYxUQ9mr4TmXyxvPCRkucbcPEhGli6tTPoLjJ2CG9Ptnfu9MJAEHm/QjIiaI5r40TFdDVYpevxP+bontTom9JE0EWrXLWiUVzT+dZRiOmVm+3aoMUKGVn26iry/ZMJYN5iO7EgUqxnHCVEXtO9ZY6RtY4An/LQcCyx2mv6JGgbGuRilo56TObHpJVLBxVkjv071IfklphjHyj7OL4fQaK63m1KG1L6usQcx8CpvQrppHemi7b70O/uZuAt0n987PB2cSEKUPhLn3fQgpQ3AaL1gEjzTfSnQQGa/oL5onF3n1o/JMuerwIrUTxX/uGT4Ll5ANbozqgK5v6TiY85fY88e1tlPyVdgjYqgD/fmVH7ukXSIQCdaQpgUtMPlqkRbRJoFqTKeWjiHR2Oaa7gibhFBFlH+YQBI1fBPtMaxtkGeLEmdRA57sQ8dw/fGZtv/hoxDEknFvjkEMGgJR/+tTVuDkZ7qlolH+gDl1Fsj7OXNXodVo8uG/gPgw5s8uUbdopXUe00yPLNdC8EE+NcftH34m2Cl0iRgRTESPG9B+MVzSSBC/T51phFL/h0k7h9Jm20RKehnaLf8F5F+AuuIO4+Y1cz+f8zaFXYXFOnHyTcOaPQA+mCXjpq6rfT44+xBzXitRv9CgwCMs+PjorU+Vqc44n6tnwLdTOJPwQAtD/HHrABgkdO+/cjcU6hM9MDnYid7yeyka7n7MTX66G/7CEPAgiCwYRNVl5YU8+PT+ikn+dhu6pB6VNsqeIPIUCU/Vy+BX1NjVK5QY58M9maErXLwRCldhoxx9TY+22aW9Ltqke7zeyc5grLW3BEuPi2AXgYfz4Z5f8hN8316RdunsCkX8CEqx8hXv8gULNoQnHFizMGGyn9jRZ2m3k7JFOYIvQV3IxCWv5nNu9y+kTGSUWZMu0j7aExyyYYxw9B9t13XYJi+tLydwB2/IFRwF8VBuM5e/p
 w+4nPSkU
 4f1fjOUPwuT/C7PWBD42v2oAgULRaTK5Nlw9ZNzKdLCfpiZ5RPiFUjNxxenkSJlp4I9yn328tIVy4fdkjDnn39gYdMIXUAWKcjZg/VlL89tzR8vwpr86WwbkIbMW7HAzCOUEA2M3cVpbOs64YjXrJ3eLgieGHjtpJVKdynfVbgBzrXNgYtd0oo7h26Y9uf3BjQZXPiV7BPuE/FNze0B4HXNT66zWXMKmtgjnRfvK4ih3PpjQYHxq2eDfqCanHzIBiQTuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Stop pinning modules indefinitely upon FLB registration.
> Instead, dynamically take a module reference when the FLB is actively
> used in a session (e.g., during preserve and retrieve) and release it
> when the session concludes.
>
> This allows modules providing FLB operations to be cleanly unloaded
> when not in active use by the live update orchestrator.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

This is good for now but I think we should rework the FLB registration
down the line. File handlers should not use the FLB before registering
first, and we should initialize the FLB on registration. At this point,
if there is incoming data for the FLB the module reference should be
taken since now there are files depending on that module.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

