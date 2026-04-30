Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45793FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54FE06B0088; Thu, 30 Apr 2026 12:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 500AF6B008A; Thu, 30 Apr 2026 12:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416396B008C; Thu, 30 Apr 2026 12:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7A46B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:00:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0ED81C6E97
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:43:09 +0000 (UTC)
X-FDA: 84715489698.12.0A1926C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 18F2C10001A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:43:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pwKOMqKa;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777560188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmHYHEbhkU4It7XzLrsp+DmA/gqAvUCAo3jf+JJq+bg=;
	b=OcXyjp11lYwDDovaoJiA9MYS0JbybcEqS2tEhXW/sGdR2gAL1AoprXSo/9RyE0AXsT9wlz
	UMLj9nIDcyDfoKLv++xZwwFbTgTjqgbjRjwTQoNnFwG1LqaTJcO+jNKxu0v7Ns+FwZxrOd
	B9yVhb552U6Nd0LZBi0w19HueR21yGg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777560188; a=rsa-sha256;
	cv=none;
	b=POZz5hTotzRzQIp7gqAtVBfAx6IswPWC7R7T2A4LP4z/WIaUOoa2zrz+7Y2vxw2xoGR2r/
	or/tBeNDKNBeJn7uzf/dE9LHi5zJ1Q6t/q5j1ayuwU40jjREidxVMrLGo7vQnPnzIaFelQ
	L7Sj1z/sdHpXUGNncc6pU2ZxIeTRIkw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pwKOMqKa;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D91E4417EC;
	Thu, 30 Apr 2026 14:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E45C2BCB3;
	Thu, 30 Apr 2026 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777560186;
	bh=h/WKKcemp057cG40uVl4sE71I2i0SBZGaW8QyuvigKQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pwKOMqKaMs5ZN59XzN2Tl5DiIMejocs/W0luvr63InSxlknAt0xys1j3BHAaRr9Vw
	 l1C8Qr9SSEy0e+K4oqj7P5GYjfCr5FRzqr0rzHuz98tXX4aKyHWWmD4uhoaBwBK4Qb
	 A6hoXEDnzDeixmzjk85z8T/5ypzpnetrJXG57ciw=
Date: Thu, 30 Apr 2026 07:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
 mhocko@suse.com, brauner@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-Id: <20260430074305.9d3389ed71af040acfe222de@linux-foundation.org>
In-Reply-To: <20260429211359.3829683-1-minchan@kernel.org>
References: <20260429211359.3829683-1-minchan@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 18F2C10001A
X-Stat-Signature: 3uj3redt5q4jj76bd1k9h64utqos8yu7
X-Rspam-User: 
X-HE-Tag: 1777560187-864191
X-HE-Meta: U2FsdGVkX18aYGLCEgqVKnApsBiHjcSn3rA9FL55BnqB0nToLr8vRVggJUmbyWWdwCnF3r51mkLKH0aoLpWBHY3PaFZ/lzAPmFZwFoBOcIe1UDguVRX6uEhGhbkJ80KkSf5l1OoGDfIIh0JIGc2GePW+7gmZdFxRdVkvG3gjS/j2bnDW/TWuVOsVG4d9s7k7G/nRohd1qtdYxcRdWFbflgwQdVbJ3N/JLfuLaHWd8ayzICdiWiXmix/wcHsK2ekq0c0tsojkAyx3OdbXguQhbGdsGFNCApU9quFwfBdhKBJh75/olWclOUGzj9zpDNfUhsCch7gRpHwNrsZ2piU/mZp61I7XNFFBH4JaeEINl3EWJWKNISOoBMiNHITd4LM/FwV2bxFgZL6oJqvXK0Z9btylpZUwLrzb7VDe/AZMYCX8cNRamqjr5vpi2KRL/+4dyzHwjlQi4koKSfQs4e6N0LAqYiVZ9tG/nmliRYWCXDFBs3JlUb4PQjyf3jvdMeq2tmsNCAddW3LZ+2AFpVHUZ9muL6y18IDRClGRsTqbgKKrUtzeY5gHU/OXueG+LDqVdbSZJu83TUO2GxqBgo8v/dmwwmp5sNJiS3guLg5WE19zYLLrD+Pk5+yNb9dWP4lDUemSOcKFfzbNDd70gShrGYYfwWtQhg0Hw5gHSlkMz6D5LToIPM3R8C/4ZZko9RQnzJhSJYf8aHnSSxtrFPK5WzX7qon9jxpr6iOiW2XUEdBpdu0wTKfJNm+uOWCi4G94kwemkSrcNaM7cGQohc0n+Dpugc30i6tS1qejxUWZwL7buPcr3WoBDo1sjBCy7WnlU4Hezc3vAMzl2I8Tv9akxmqJTQrldSzgzbpRxVAuYxE1HILp1c9RXn7+JAViu703Izf7wwUCk9RhcjcoARjWw6s8SfFnit3wlJFMov3mMoq7jjLWCRP3ib/V+vBXZZBNQcSFX7p5UzCO8k5bc3g
 VLox6ylR
 pecCXIGwGPEph/PEbcDlwGRpRQmPSePKULRrJZcSa3seYThxHlKiMyPqB/o/OOOIiAucGGmDBpr74SZwKuxxh1+B2IkSu7aSGORtEIn/Mki1ZNLWgKKwmLTOh3nPYdY3sOKSsp1j/lkaoD2l7OdjpFgL8ftGIy4kjkEyL6dsboZ72MnBe+PZ1ZxhhCxmWPWTubUiW0v81L1FF8vvvHnQowrrlzgqcfqHyCFKy4Yb2l34gApygiOFpFpFPcR6AXBr0fCB6zhHFEuEZLaOwOssu6Hu60RuboeKccwKQqps4eKAtdkoQkoDgz3JbxJc3lp6q/5wH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 14:13:59 -0700 Minchan Kim <minchan@kernel.org> wrote:

> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to invocation. This separation introduces a scheduling race window
> where the victim task may receive the signal and enter the exit path
> before the reaper can invoke process_mrelease().

Does process_mrelease() have a manpage?  My googling was a fail.



