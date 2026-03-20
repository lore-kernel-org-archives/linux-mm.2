Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06D91098796
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2AE6B0096; Fri, 20 Mar 2026 10:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93766B0099; Fri, 20 Mar 2026 10:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0976B00A0; Fri, 20 Mar 2026 10:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B97A86B0096
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:51:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 538531B7078
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:51:23 +0000 (UTC)
X-FDA: 84566729646.22.B96A33B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB49E40012
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:51:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NH0QAtEL;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774018281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilccG99mKFgHDBWIZkzQR4ja+B9nSe0o2icGi0WT6FA=;
	b=wYOkaLguyDL/vgKvnkuvt2OXIUpBPIFrLptTNzPKa3mduBZ1fka0qTbDvrDZSftM+Ifadb
	kECBXXxRQt3gzDUTOAHzFFBGegQb80WJAYN4+iy+X6f7LnWUPV3HN8X3Z3f1/7r3BHWmAm
	weTI14lsg9aete+bIwYcfYl9Tk+rMqc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NH0QAtEL;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774018281; a=rsa-sha256;
	cv=none;
	b=oB/oph3fPd5feaY0WLYh7WwGy0Cp4Mfz3qXx7Rmfzd5IJP/5mWy5cclJU5m/v97+lXKwx/
	t0HdQ2/V+VFJXd0CGR/hb8kJBMFoSwUd7Qg+6qK9r7RE1WmOHWwBsOGbYqgojGFkIKyIAo
	hfcr4VclFXXv9pTT8/oyMut0+K5DWko=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1583A61854;
	Fri, 20 Mar 2026 14:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1636C2BCAF;
	Fri, 20 Mar 2026 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774018280;
	bh=BRLCjsYp/OSdtKDfU9Ghzw6aJ4iOYpw1n+juPU6+/Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NH0QAtELB4v6jLFw8JsoLyBxlKe6/9q6TmleL3TvXy5G6jXfJnZuzfWgPulPWA1rL
	 2W0NUx28emQVlz1REcT5GV1KBSMe7SIU7loEHRb6vSMJ6E7PBuiKxdGqvPzEYDI+2H
	 SHpdXQV0HQTgtUrH/OBY9ZXuLZLkZcnyjPkGB0UfBaVv3aHT4cNxs015FqtdAELF4w
	 rZkIohTiAJMyeHXkvdVZbCNmOyk8NHrjBwd829Ula+EhMvb70oeY0R2z90yAnkj8xA
	 m6W0QKPEdaM8x5q2qIfs8LQN5wfDUufkOygjjXmdxdFXaNZoNHKTMLJCP9nWRTPZiq
	 UA8o7yywDc/+w==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 07:51:18 -0700
Message-ID: <20260320145119.91960-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320054145.213945-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB49E40012
X-Stat-Signature: q9oam54kq9dr5a7y983o4g9yr4apbybh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774018281-79403
X-HE-Meta: U2FsdGVkX18eKyuPlidQqGV+TTamuq26jPmpspmBy0dwIu5OZz9W9tH2WrornyAynP/uFVDJPIGg/OOfziJPBL59pzlLL0b4VfcFNQk1++WJgWUcDVZVX4r3v3CuQbEBSLqKtqAsmAW2qpEXU7y+zGTkTfD5D+7WEqDl98MnHbW4mh6Wb/X5DtWhM5zIZc9RysQYJAuvQJ8Lal3KPOLUCOJo++Wf7Nz9Q2U4AUmR0LHkZcjQd30QvuF0l2Ts8eP3rRn3oo0iKCAB6isUuzQE/yHVIjlcfSFS7M/2+ZhWskx/OFfPG/rnCxLZy4Q/bWRrqvrZ9db6YB6JsH0F1pF7C3BzMM/tvfP59+az+VFKq3es4WwFGaaJZB3w0WWG85fBgybKhdqzNU5ZiFAzXj06HyK1JiLtYxh+gD97TCKrHJhM/BV32wCZAjfBszeFFcLvuoyWzg9NjSdG494T26MTmYcJorVwhxfSHAn5W5i4eXeR6zgGeDqoXpZtR79X/EFb1H1FKZj53+0BKhP3cE2MQPfRYx4qMK1BAiOTNG7eirImdlw1+iNf19wIydzCqIC2W2PHi3c8xuV6RUCiY/C1oIOyCljw+CAdVIklEdjH3ffLlA77pWrYoIL1OnqsPeLpS50aZ8r5YR+FQgsm2hvpcSLJEBIga2hyVGb4u2aKejlaqW7JYdCg2xCWuIPkmCvK4oIRtR0nc9N2XYIzo+4al1gdpkSuivGoXMe8WC8KiLcz9foK0m36AFEJlDUZNL0YcZa0kK7RbX4fZm4hOXoj9kPiBcZWwyT1Na/eJ5v6Mw0sINMBN3xmUWpgyHVW3U2JHL9zlvYyjwq4Ovvn4xqZTQeqWQ2/alWVxJkvKzvknH8vxcVOzkokK1r40Vuy36aKRMAgMjW0g4KiMe2GuUhxEJVzUDveikccylfGNcRp2FroW4fT6bfFdYKbZ11QyOqopE065Sq2oop3t3D2o0x
 KvvhsFs0
 +1Gms9N1L2yGnubFLQ5yG4DwuHtLiKZm2tRt+HILuuf5Rzha+p71c2E8H2S8AEFY26H0fLxeKpwtZwnXHKfdO0E8A/rCUkqd33MS+Kg0daA6lzSdbNia1vB3CZLRj+wvdW/MvBX10fBx3ushVpvypc0QhPu+1EqHlWNXLQSTn2pBiQuSfcrTOmOw1M8v0t7IUFRXQaM/gkA7sbgVzItfPviENB8NQ2wl9d1AobaK9ZIVFHb/Mvi6FKEvlkkrVvmGCo89hE+n/orIwyqbkv3fwnj7mr56dq4wNMoPFK4PsGOrY6wo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 13:41:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> I'm sorry for the noise; please ignore my previous reply. I accidentally
> sent the commit message instead of my intended message.

No problem!

> 
> What I wanted to ask is regarding tasks 3 and 4 from our earlier plan
> [1]: should I wait to start both of them later? Or is it only task 3
> that needs to wait until your fix is merged or abandoned?

I want only task 3 to wait :)

> 
> Also, I'm preparing to post an RFC patch for 'damon_hot_score'
> optimization soon. It aims to provide a significant performance
> improvement.

Thank you, I'll check!

> 
> [1] https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t

FYI, you don't really need to add the 'damon/' and '/T/#t' part on the link.


Thanks,
SJ

[...]

