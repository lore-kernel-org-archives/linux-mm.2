Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F1ECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90A36B008C; Wed,  3 Jun 2026 02:52:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67E76B0092; Wed,  3 Jun 2026 02:52:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DF66B0095; Wed,  3 Jun 2026 02:52:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98E8B6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:52:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A0D41619C1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:52:15 +0000 (UTC)
X-FDA: 84837682230.20.343DF42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A8089180003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:52:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiRBMgVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmR72pv0JwZwlXfpmXou2svlXcH18CS10GD95f37blg=;
	b=Aw2V+6kQi/K//wS1Z/tFER86qLgDxZhxBckCbJZ20FO0zyJwkXs1FlvfygZ+hJNitt0oiU
	SaovEzAG+oBOq3e2blztHwQZCHTQgfa0RVec9bw4HOgjk7qOOIneZjMnkjnZ3hzJpt5bv6
	1uqLICt84cP6LnDmbJAGYJk2pzR3Kqo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GiRBMgVX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469533;
	b=zTT6thPUzCN13b0lh4/CM6R30MqH7gWjRe9jasbQ5oTZF0Wa00+n4TdE73I/uQ3RId5aU2
	NEJfOxlTBSnupOJjcrhmIMNYhKc9EZn7Q/v1yrdoSmMEFVBeQI4l8Vx6EQ2hKU7Z6tyn1n
	hHDuxVLrvwRL/cdjSUCzvS+cUrsZr+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD22943E4D;
	Wed,  3 Jun 2026 06:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1921F00898;
	Wed,  3 Jun 2026 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469532;
	bh=QmR72pv0JwZwlXfpmXou2svlXcH18CS10GD95f37blg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GiRBMgVXBSYgeTevLYva+/l8q+IIkbd8tlCWMESYx3M+lpYhlTsV/YFhmgyIeJmBv
	 aSjS2E2FrVsyR7LerMnXedSvoQUQYDpRMuwqXSWxYXeaf1uwfvCkybxOZ3Fgmhi3sR
	 FmtcC9rbPfxKV/XQOad3sLgErg6alckvnSGr4fX8AAnrQBt0dfFYuKCas8Nfq+MKWI
	 2pP3whGsj78x4ObF026jDMh3ewLDz4dDUR9POyKPjSiJrZFW7QpaHianGLth+gpj8P
	 rP+6NRi2pQpwr0trxX0Mzk20NatXXQ3xr6yZ7lGOdcJ3lnhARBb0X2wy2qG8pD0Jwo
	 zqCBoEsbhOKOQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 03/13] liveupdate: centralize state management into
 struct luo_ser
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260603032905.344462-4-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-4-pasha.tatashin@soleen.com>
Date: Wed, 03 Jun 2026 09:52:02 +0300
Message-Id: <178046952228.468621.17532660334285388424.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hox7t4fntw5qfz9f4dicc5uh6dnxygyd
X-Rspamd-Queue-Id: A8089180003
X-HE-Tag: 1780469533-244188
X-HE-Meta: U2FsdGVkX1/Wf4oL/w/22F9NRvkrDNQGNYdHToCWTetww8zO1dz1x6K9ApgHkctG6F6hha2fqvxx98orPjUdQMnR3kxxIM/Kjnq/jXZFrjEE8iQcfcS+zhxvxDdxTJpIOy0VnK+ujVve7WZ+tlNX5XcjPJ6h0/aowR9Ggw2J2Eaob+ck/l/28wwFWGdxpz1HKuLFOF/Au8V7Kqw/JUAYNQayWaYptmP99AOBnkyfd6xF+bPfncTMItUg6Psvyqru5syPvp1Uojtv0Ksy3Io5fD/br/j2E0gJPUj7ag8a9U94S/yUlmylVBa50Wf/fXXCL4xE8r1YtisNEI2o/8uQNi8Le6OGxnqQy1Jy36EdcdnSJsK/2s6ilxZUQGQf0IIH195zK5snDgkvS0qukNZbfgrBBeH+aKlWJfAsME2SkW+b1xCOF8JDV1/4m4i1hpqSI3HMH2xGkmFSMfDZjfmlfsNsvnsXHnqX2x9JD7TtFE1V4J9bWqbTOi0ZK0opeP3bkuTE10xWVLIZm1nal15dF+wklDdvCwIbBDE6adIX9zft7Mux7wMBw7QmX5gbTxfyb66npt/WKISW0GmvykWlsGilEfZKlCZqfD+ZGOhg8UzUHoIEe5rryS3McGxY5B+TE2gOche+pkeFdNAxp0r1PxHePVu9Rmwd/IU4BGG0ZCNfrdX+lhbTp2HbYBs8klw+GSQvYVZrO72i7rHR4KY4KRCALHwbRwdd+yoLQfpjfmVm8wg2zEVX2kEGSpHlSRhQU6mB5wP7rxtZcgVFvjQRtrblrYtSDCCm9/08VtexNfOS7cweCTZD0Y9/V/KbfCtRNBYviMcpadfKw37ajznrobSFFiTm1MK5EfgmALGR90eAa7syIozDHBq5nA6OhQZxargzNQcpX7XlynSohbgjPokucwmcXVKn4ytEODxeQgtHh7rmouqDeBafCZ94760tjFaHDBaFI0m71ySSiwU
 WVAOdzzY
 1vYOCYSjCRELlFrFIKbkGTI+VoQ76DpqfqKyueMLPdYkvIJHuWTJjHcMc7WFVjVraAKj4SVgMp9jP5FQsLPfqv4N8OULrwCgNyBAtGQOprgJk62xn49m+zyWz7skEkO08vBJaBChMXnX87J2CTVYXOi9+3gyJIMAO+VIZubd6oSV2lrHMb+YmjPhumAudDFABuMn3pbZehnhHgZykgUlRQkerkYS2dhmIqP7SPHcJBAQfKwFeqN29fZBNm7wYAbvZiGrpEINRahmZE6BDZD3AdVwLYa4me2NBOTdPUtuMxeaUQzBwn8Ol3PobKZi/XBb1ZMudotfv/TGsfld/EO48+TV41KuWYaUJJJRN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 03:28:54 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> Transition the LUO to ABI v2, which centralizes state management into a
> single struct luo_ser header.
> 
> Previously, LUO state was spread across multiple FDT properties and
> subnodes. ABI v2 simplifies this by placing all core state, including
> the liveupdate number and physical addresses for sessions and FLB
> headers into a centralized struct luo_ser.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


