Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C50B1C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 03:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4194B6B0098; Tue, 21 Jul 2026 23:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA1C6B00C6; Tue, 21 Jul 2026 23:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8836B009B; Tue, 21 Jul 2026 23:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05C326B00C6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:38:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79CE180375
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:38:50 +0000 (UTC)
X-FDA: 85015006020.15.7D7646C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D623240007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:38:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1mHLtI7;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784691528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAy98DxP2a6qgmrCD2pTqB0OlrzwMe79Zf/ee8Jin8Q=;
	b=zNXFIzFyLb7nkOyxa96tKN2UQtqNdTOUPr5LG/LDhPXL6bMAHNGOG2WNPmE74dWKhqMiBf
	Bv0xRgp/tPcMuW7vQl6p58UFZpx4hDUeFokshXAdlziRtTSoX5FyktPNRqpUMOdvHmOntl
	L6C/SMPXK0dqvOQaaMNITU3vCVqq7vQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1mHLtI7;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784691528;
	b=EcVzP6ZAqUaPcKnqhA7oMZTgKV/TBeigqjkwXb7/YyWL2HUmZEdtrn6Q9JWVh3Et+KWVFp
	7Yt2aT0n5/C0VoLGL4z62MHVAmKVVavzIzuq7l95IWrscHWseNGhiFT/mqUzh0eCaMk+IF
	IbWEh4bIEl5sF/IAv6SdY5X0OWjPygE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4B004075B;
	Wed, 22 Jul 2026 03:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746F41F000E9;
	Wed, 22 Jul 2026 03:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784691527;
	bh=UAy98DxP2a6qgmrCD2pTqB0OlrzwMe79Zf/ee8Jin8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1mHLtI7CkASP+B1icQb/p3xQpyVMJh/OShuLI3OH7Co0vW0CTpwtf14zEbEDmiVr
	 rllH32jC/kP99DLN4xtgtVBzCcHzomRkkw9ALW3CjbbCltNtkz15fsnzRFosCxiqxD
	 EGKEyBx+Tt8STjZj18FIpuV3+mk0CHn/UvkAfRv3U+sRzSGgJYxBeGQsbIUSyf1HIy
	 3KG2dMLki3+hknDlTGPHkelQS6aDlmYU0HUtpLZmI1zQqTEnDBYNUZ2MN9spVJKzqo
	 +S5FJdCzDShQ3oEVrfeD1eMCzKaQPoLbYECwcXBhbOkORTfA2NzXi7acKx3ukU7YMM
	 nTcHKfJqfwOhQ==
From: SJ Park <sj@kernel.org>
To: Hari Mishal <harimishal1@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/damon/sysfs.py: clean up sh processes used for obsolete_target test
Date: Tue, 21 Jul 2026 20:38:43 -0700
Message-ID: <20260722033844.65932-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722012349.9738-1-harimishal1@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D623240007
X-Stat-Signature: uo1znbhfpfq56u6uwtcrmd4xmqtqpuhm
X-HE-Tag: 1784691528-457931
X-HE-Meta: U2FsdGVkX1+HngtOJuH208qTeErjFQcMDANPoP0McIwxBMKukQ2SRY96FGBR86Ua+PVV5ZBSDLIAVRN2LnxGrTvJxIoubKxADHFPX/o6jsxPs6Q/wgz3qK1iuq13mqwSfcKewGRocy8GzqhTmWYYbIcCStlhSX/rXDZFWPin0mGyx5rXd7KSocuiofPgL7k2Lmx7VqB2drk2NONW/8rzWYSASUsv4gydkYL3Ps2y6+HISrR3+YydvRc6SZqG1XJBbTu750MH8id5NUej8Gbal7JpILMIoLwjdtzgrqGfsYRF4Kw32ZuDC26BBNpnk/NWGUt9MP9C+2kcw2AcOsYjIZJSBXh4k0o37ZMlggULF7g56HwEvHCdAQIsKGpxWmBsx1zGIzF9FITqKAtKqXfe1x4bgha7DPLiEMmEpyp9Ukf5LYLFjSl/xNg2AQf/DKwBUjoiNt9uLqToljCSMYgcvQLClcOIlPi061HinPJADLLNZE1fovWbrKzmVKG4HMbinm/krR/nLfBQn3c86aegjmbwq9mHa5nlqSiYE0KBgBncifG5L5HrxCxU8qs+mxh0ERfK8Xw57T0SekfEH6+smZGM4dltYl7rdgd8sNqY8Q3D7P2Prj/xECKBbtcYfrbS96ZIqEwnsT69F4stAQTERJRw+QkZ9iVdMkk2+ysNmvUZLpNtCU6pirPtxI8hY71yTQVP3um1zqAc4F7Iq8880PbDHbcdWCElBO5O9T6TSF1SICJF2LoimB385KsCsyPRxef3EgMhLUTv17vTY5KtK1BwK2Ni0rA6+AVmxvXnISkKnfzDWSgojsdFpMDeK3tGIHq/y7nHWt92Va1u2nVGXtAqSwZuMasjAUSgdzPOYUIo8I4xAg3BacrV3XGtfy7NFnjQ5BbIbdJI6q2puZtUqFf+yJyy63+/VSPYMM7imdu2LwR6c2TZgPxVJ1g4dOPr7TdMjVJVDhrb5ghueDb
 Pa52pi6y
 3E0b+wUPVKBL2M0RDd+51uL9HDecRigux8pfKEurHHWEc8dimeMTKIib9l45czppIVG/PPNVLYT5icY/sQWuHuI05qEsYb7lU/nqAW8CmGuec5j2q6FHlIx4rx317hqU0zOQNzXboq+/BoIRYRbnYShbkVcubTpsqD3EnNmujxUYdzjAsdNKvyapuSrxcIkyUfLzz3cdtnEcXKVN2o0PhFXB90TaMK98YLRLbgi7sfdrEmxeWYFY/6wXmeqIZG4usS5yuQuuLJRNYSe4wTxTbKdUq3edCV1UPjaVxETUK4M7Mi355IY1/yXSGp/0VTz9d5te7kkYqTooJhv8ylhpqvK0oWARYCH3VWRjV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Hari,


From the next time, please don't post a new version of a patch as a reply to
the previous version.  Post a new version as a new thread, with changelogs [1]
including links to previous revisions.

Also, give others sufficient time, say, one day, to add comments before posting
a new version.  If someone publicly asked questions to your patch, please
answer the questions and keep the discussion in public until the discussion is
clearly completed, before posting a new version.

On Wed, 22 Jul 2026 03:23:49 +0200 Hari Mishal <harimishal1@gmail.com> wrote:

> The obsolete_target test spawns three sh processes and uses their pids
> as DAMON monitoring targets.  These processes are never terminated or
> waited on, so they are left running (or become zombies) as orphaned
> children after the test program exits.
> 
> Terminate each process and communicate() with it after the targets are
> no longer needed, so it exits and gets reaped instead of being leaked.

Makes sense to me.  Thank you for this patch.

> 
> Signed-off-by: Hari Mishal <harimishal1@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> v2: Terminate each sh process directly instead of giving it its own
>     stdin pipe to close, dropping the stdin=PIPE changes and shrinking
>     the diff.

When you add changelog, please add links to the previous revisions.

Finally, please use mm-new [2] as the baseline of DAMON patches from the next
time.

This patch is applied to damon/next [2] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

