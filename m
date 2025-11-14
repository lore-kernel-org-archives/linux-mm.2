Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F2ACEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27438E0007; Fri, 14 Nov 2025 16:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7DB8E0005; Fri, 14 Nov 2025 16:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDC78E0007; Fri, 14 Nov 2025 16:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 898068E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:44:38 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 225BE8919A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:44:38 +0000 (UTC)
X-FDA: 84110542236.24.02AF7F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BB1B1C0003
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:44:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xlFobeIA;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763156676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBXXOlQKwmeJSlViwyJErz12T8X429cOy/TdEoXEVPQ=;
	b=YQPKI8/v/S84qWYG2JvuR1qgi0d/RxETXilnl9VL0kKPVhkjo10EH19eG5KJ4vf6Aiftio
	ETcTYW4nNPo5Yp/32Ck5ZzxCklHHE1+cOjKJfm6dMEwVQakCpqzxujT91Jgwpoa0HWjX0V
	yKXZaCxfoQkUFzn4d64PURn0bjyOjPI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xlFobeIA;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763156676; a=rsa-sha256;
	cv=none;
	b=2zfqHJuqm1c2Qt+rdBpMgL4oSlpdDa3q+5AUaLuq261CHTinvE+gVzcoPIpUCtXQ/CYDWq
	+9oKLBG+t4+IequiP40XiveyxZ5WGX6CKyyLirIj2/qAo1xM2vhPhtAlayQh8kAKXUK7YM
	cZxjRoIhPfQRiaNwt4c5BekoiwZvMXE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CAE46018A;
	Fri, 14 Nov 2025 21:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E502FC4CEF8;
	Fri, 14 Nov 2025 21:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763156675;
	bh=hK73J41Dd+DBh3tuhlQDYlfJ7L5o8Oi4Zj+jZvMUiPY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xlFobeIACPcN+LYAKFBWmjBsPZuJHPUSqfwySMP4x989WaZElUpU11aQN0JnKlsOd
	 kkWIhb7p5PfFI8XYwV3R/g2EpgHdTilNmDxbgzztOPtfAL/t1dhXLXsgBaG5wMuj65
	 EHb5+SRwO0tGNbhROhr8ibNEvhYXF2x8iPg0oCeM=
Date: Fri, 14 Nov 2025 13:44:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: bhe@redhat.com, rppt@kernel.org, jasonmiu@google.com, arnd@arndb.de,
 coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, graf@amazon.com,
 kees@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] kho: simplify state machine and enable dynamic
 updates
Message-Id: <20251114134434.5375d085a6bdc1671351f243@linux-foundation.org>
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BB1B1C0003
X-Stat-Signature: q9riqaorxcdyt9fhmywo1648th8btc5g
X-Rspam-User: 
X-HE-Tag: 1763156676-911605
X-HE-Meta: U2FsdGVkX1+Mdt9fQ+Vw2Urv/c+gMXXiQjgq3ZtHfvddn6QxLs9PXRAWjpSsTBA4yWbTjARJe1w2GC7R56RM39vqq/vU/gTmMZtFk5vPljcjyfEk6EG5hnMltrldeTqJP9qhrtEUFhcumNMl1p+onGa6BL9BZA7hc17QWJw6dbcQslMvRLy/RznTysV+iP8C45JYs0K0EyNqwCeptJbefO9h3+nRpSMJ+IPJ4rEdXdYxAkqFg0MFBl5a/Umn0IbvgI5bWLBDsUI0jk+mjhWYKKoPt9jwUytGHHanijonlYKkx+Zaihey2w2qWZ/OxgHMY8bkfHZKjH5povtIWkXl6ttFTZ/thmTQONSkOqKFJITnin4lUzWV+1KgFH6TgCwCN+PTy4y7yhZMQ2y8DUsos8a4hwDWLPAVv99eAY2XR71LJ0cROyFTrPpfveNFqyY38cemcp51xIN3nhw2X4y7ytXyo8sRl4QWfUyvPhe5dr/81oFgxx6+VMRZJ7+mjJresB51UkihhoTJzxTS7waMTEQh0rFT0lM3ef6EETnN7rIQxy9cJeua0XVC3Wl7FveiZ61xfdoV4306rnKGqhCfC0ksGcoNwVcLVc8ov3tLwupb7xaaiWY9db2sIMoDmuqdq4ieeduGBL7u/3Wz7qH33T3Iytglzd0yWkZYX11KtiQM4K7XT/Rq4j4H4vRtds7zz214nVYovI2t30xJTn9kzA1UzSlIREZtvOkrzfR5YS4z+qBSqIYo8z7rdXEMqYe34wkLoR0WdBpPb6BMX8foycvVUXtU/zyr/s7NWZm6Sn4SzVabO+Kwdm1BA8mYYU0wjuxiGJybFmLiXaBlAfrkW+wXL1+MDahkx9/GA700ssfkufNpreu9JuuRBBiqHftep6cZfkN0J/zpQE3eAjs+iD0a+rFdUa6G9QQgzyadg1EDBx0NawPhzDaNg8/Dx0BOesrGPpx7WZPteF4Se/Z
 /QMWPlKH
 5xw1mTKwDD8ztJLgTKaWh3iUPtfXvLZ5JsM4J7205CDyu6gKKQzdJMWOljRzQ2TXUNXjdeDE+mDUwHOJ/AJK8P2MPD2/6I1geKH+O2usGiOfCmZypkk2N2kN4HWQCQ+cmdB0m8O8EIHnnrFnbtEsM0WSRv6c8pOW4SzCpFzY3PoPQST0Rt2auXt88GyQHqpXH7fKSDlXHaoHUb1Ne1plq35UGDTR/KYtcLBh67DpX1nvyaMESsn76fNAl70AmgzaiNugDaFoR/rx+XfhSXyLT4hobnrzwaBuWtjOYz4YdrQrVLzF2RNVLMxh4B0+z6vD610O1ZHykz5Ae15Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 13:59:49 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Andrew: This series applies against mm-nonmm-unstable, but should
> go right before LUOv5, i.e. on top of:
> "liveupdate: kho: use %pe format specifier for error pointer printing"
> 
> Changelog v2:
> - Addressed comments from Mike and Pratyush
> - Added Review-bys.
> 
> It also replaces the following patches, that once applied should be
> dropped from mm-nonmm-unstable:
> "liveupdate: kho: when live update add KHO image during kexec load"
> "liveupdate: Kconfig: make debugfs optional"
> "kho: enable KHO by default"
> 
> This patch series refactors the Kexec Handover subsystem to transition
> from a rigid, state-locked model to a dynamic, re-entrant architecture.
> It also introduces usability improvements.

OK.

Where are we with the series "Live Update Orchestrator, v5"?

I'm seeing a couple of review comments which I plan to circle back on:

https://lkml.kernel.org/r/aROZi043lxtegqWE@kernel.org
https://lkml.kernel.org/r/mafs0ms4tajcs.fsf@kernel.org

and a comment from yourself against
liveupdate-luo_core-integrate-with-kho.patch which indicates that you
plan to update that patch?

