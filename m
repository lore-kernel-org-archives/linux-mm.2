Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB5ECD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1D76B0099; Fri, 15 May 2026 05:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972BE6B009B; Fri, 15 May 2026 05:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889136B009D; Fri, 15 May 2026 05:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79C556B0099
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:22:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AAFB1C00A1
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:22:01 +0000 (UTC)
X-FDA: 84769112442.18.94B8697
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B962120009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:21:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vZtU9Dt5;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tz0Pi0QAnbGrUS7Aa7Gsi5WaXZZqiJEDrHz8JaQku/c=;
	b=oHq09D9foc5mTPLw3j7TymEgfkEzDmkgkg9LBQM+OO7Kr2S1piIYdIHwkwjzwdqjhjab4w
	vSSieica9+0bjzdF9StiF51oiOkegp2U8TsOtP7JK6kgjChUvrZguOd0DBYQcicbNx+8vB
	wunVbHZGRwf3CW991VR5T1m+vmk2wpk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=vZtU9Dt5;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836919; a=rsa-sha256;
	cv=none;
	b=JQqtj3J2JmCL3jKrVqSizG4Asm3ePKx9TeR9KaAh5PyYPRH/0oFOA/hdPJicNRJboadxEA
	heA25s/XslzKrRoCFFc1nD7dsILVTSA2mB2/UyKIsueZ8PIavF9a4jfQ230WMaHO4f1qA7
	gzYjCd/PrESHmYH9JKEzqQh0Tpccjvo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D8216091C;
	Fri, 15 May 2026 09:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F51FC2BCB0;
	Fri, 15 May 2026 09:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778836918;
	bh=krDixN9cImzUINNa6Us33zC5coP7rdNz9y3siAFvjPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vZtU9Dt5WIVq0BK/9r6wJhbJ52OVVUzbQN24aCI1+8o4UcoYz09Gg2mVSu8du25RI
	 NdNOI4J7J/JnyAJaYL01s5DEJNQJAEYLuOmkQHmaKMFk80eZ3IxDz3Nkqm6TjYCoXz
	 NEHhXCwNI+hLozBES6iWNJXIJZPYzGyqpYWHNRcU=
Date: Fri, 15 May 2026 11:22:02 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: Andrei Vagin <avagin@gmail.com>, stable@vger.kernel.org,
	lorenzo.stoakes@oracle.com, akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y v3] mm: fix VM_SOFTDIRTY propagation on VMA merge
Message-ID: <2026051531-failing-nectar-83bf@gregkh>
References: <CANaxB-xFcF7U=wJv8EqKy=j=-P3SN+sLQ9ytH8Ej69h03tqL8Q@mail.gmail.com>
 <20260504195447.31794-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504195447.31794-1-elaidya225@gmail.com>
X-Stat-Signature: fyooykdcxkguzjqz197jfkfzatgxuwro
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B962120009
X-Rspam-User: 
X-HE-Tag: 1778836919-167513
X-HE-Meta: U2FsdGVkX1/vplZnPigT52j6tSeszdqL2rpgAnag7lTmMLqNZuIPFc1Gu0ppP1i8zjHylOugiBeBk/KuGlMZNNn/F9jJ8myatPJAf/782s5ms3qtAji1UJVAM5zYUWWhZwv6MSx09UIJ/sRP0JR9zxdEPeN6ctacQGPW/qh2HznS10WyA1jYWWu7FUt28/NjHESrBGCo+exsCvJqk3yhTdx+yaRfDr/Qdn31LLb53vVV19YPWREhrnJuYxK2LQovCJQptLHufmJ+wTZC5c9ICfFoQ5uGtkRDbogi4ue6KcKSuDaU/+Y9fA1EgJSn3ytZgu+/WNC3U0Hii3LSOkSISsYa/Fh78bQbZ5CBsKjv4Y8CmqbMTENWFWaauT8LnhI8uGn/i6EPzHKgzp6gsLKkfg4HFFEzNVZ+CY4f4x82jiVSp/ox0g7JLAg6xRmce/Do9qRebd0KR+9zBaYFI6SRMW8xCC4IfViPs5etRXamUYC1JR9TCuF198ADJhk/DV5K2B7AItBOkgt8YYS68UwuKIVmR8givN7Um0KGB9j6eB/k04edaXSp82JxCHz+k9G+xOPvoidjzOOAEwh6OkT40G835AHYQc6ka+4TOiErxqueibu4gbc05/UrjCRACPxIQ2+rr0IQKiaD/qbu8HS/Q1AHCAUOohzIRnwjilptu+vKVZSaG18oH56rnjoHWSsDI4scjHybmofH0FADEWES2767HUYkf0i3wwGucOktqeypn07zOJPKbKHTKGe0sljXGXZB1QDw4vLS0aq++AaZH1ZrRKuLM5c0f3jmUz3tUprgzswwpkysSWRDVu+IY/i+sMBFui+Us2/pojb6Q6ValBwyCvneTQXCKdRo8n2sJdeHPf/j/iufu/aZ/hC/Y121wvU5lZ9AR0kWCfNRwic0p1r+vVMKZ5G4ut2o/2oj4477MlS1aD1t+8aANSgOhycqP6qakPwnVkN9A5MhYJx
 dfky/8tO
 U4jzC83d+15MaQnE48gvCffMq+XS6bVXe1SMCmRY4S8fPENkHUIWAW3BzkseJIh6hB5y9d7HsmdOFOVt23MoHeH3vmpxSDkLWQwfXio5VtTIx8GU4bAQvkgqrs/fRpYRvzvJPouRIcz0BKjnll3yp7JaHyNcHPA/qu/0gqYAMvQtWp4HjZWDKUuf9rLm0goegw4uKWkZFKp+d73mc9z2il2lpH2moAHrhtP8thSC2XPNzaLg1yIcz1j6iKTOdnFDmYuF7bl6zLqATYw/TmrW1J+2m7NMCFtuW3cGCBhbufyHQDzltwyhpb1M11kaoRCAU933slj59JFgtOck2vJkssOgp+SZVHAucW+pkcx0XDL85+lg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 10:54:47PM +0300, Ahmed Elaidy wrote:
> During VMA merging, such as through mprotect(), VM_SOFTDIRTY flags could be
> lost. This breaks tools relying on soft-dirty tracking, such as CRIU
> incremental dump/restore.
> 
> Upstream resolved this using a broader VM_STICKY infrastructure (commit
> bf14d4a05387 "mm: propagate VM_SOFTDIRTY on merge"). To minimize churn and
> risk in the stable 6.18.y tree, this patch skips backporting the entire
> VM_STICKY series (9 patches). Instead, it introduces a minimal standalone fix.

9 patches is nothing.  Please just backport the whole thing, especially
as we will be maintaining this kernel for a long time.  We want what is
upstream for future issues/fixes, right?

thanks,

greg k-h

