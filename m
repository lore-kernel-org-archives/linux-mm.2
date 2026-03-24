Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291D9F532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6F76B0088; Tue, 24 Mar 2026 03:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E772B6B0089; Tue, 24 Mar 2026 03:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D662D6B008A; Tue, 24 Mar 2026 03:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0CCC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:42:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AD33BF15C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:42:39 +0000 (UTC)
X-FDA: 84580164438.25.A20A826
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD6E010000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:42:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V6U/ujQ6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774338157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7beK7FzdwwXWlnr4hopZM88SbF1arrRfVmh2zttDKm8=;
	b=FrixNOVHCW04CRmdO1fQBY31WeSW2tzx3SX2BBGbHNHEaEWzHSqFZgA8HUS32ouIydcP+v
	GeFP97FRXnCxbHLDk9X7x+h85m6jiaVKxzmIpPDtSi1yVa2esfvwrvtA+8/ojwk3xMUSBH
	Y5bHIqJHWRDVeXtjrAV4cu72xAA0vpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774338157; a=rsa-sha256;
	cv=none;
	b=vB7X7Hnrsd8a9UEok6zWC7yMJ4DyIQKEMWOc9bALRhCpCytLY1al2NpmjoYU9+/mdurR3w
	di02gFqr/W0FBd73WY0lNx78CIwpLhL5zzRUKIXCZltN0ZoTwrOYz7w/lRbDhYcJHfzT9I
	lSk712A3rSoVbedx7SIHaUm5x3BiSV8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="V6U/ujQ6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D9E2600AC;
	Tue, 24 Mar 2026 07:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC4AC19424;
	Tue, 24 Mar 2026 07:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774338156;
	bh=A+mAC1Eha29cwHPaApvpOPIbrzU4/1ZiyHJFDmYaNXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=V6U/ujQ6IAuBIj91JuhMr1gns1md6zNY/Fk638HFjt8rqqFcQrV8nXxPmXidgozy8
	 abmTL/2qEVWuM+0xN8u18FrvVbvbXB5SlL25YEgcPCQ1KmuopdLmRcwvVzHQAFGPv2
	 mUmJvjVgUFpgmTczowvAH2RsjUDd6mHNxIsSWI24QnSBKzbgat5PS8YcuuyXNrmwqj
	 FszJeNumCOi7XmwRNxYWAn1A7Lphf6NzKk38CLfH9LbwZWTnxc73IC2/a7Cg9G4Kup
	 M2rn6FwChZ3sgbJn6m95cPRJOj67goHZkaJcxkemgPJqWyBmdXTVTpLEvaKcAebDnI
	 +pli83gWJgAnQ==
Message-ID: <546bd03e-eddf-424f-85f2-1d1c45880f56@kernel.org>
Date: Tue, 24 Mar 2026 08:42:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build
 option
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AD6E010000C
X-Stat-Signature: abtkrxa8uc47sq5h6zudqr3snzrztnty
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774338157-43494
X-HE-Meta: U2FsdGVkX19TldD7ANlbRw34rXBnil5XSSAjr9MBtyolNHFWin7/THUiA/yop+5bC47WDtTRVhvonudlfz9331E/sAGg1SeASS7Fhz0jsj1kn1m5YZ18jnllHU2KYwY8t4U589PhUXZ55ciqChSZ4wwR/Q2s31wDKMoN6vWKEkzhdVi3V8+FFPZ5xtFu65FM0YE5/2/uVgdF7nUDHid9wpvtm9MXdLtZMC8i6PMY9Cgl8AnnDxtsd31ql3L7mhBNaPe4qiO820e++D0qDdr7hiWmPauFopbvF+3D1ltQfuRI93vtWk5M0Izi8FBc/YEDfRGq4msqyCC2sTsklsWxUUUt2xHFmew4/YTIPxsLU9KAJ2geq46C6RpsHmhYx44Nf0K8JRLji22Cqd7hMm6F+FWlUQ3uOja/haaGkfs9TxagRl9n5pojADiNs5D6FiNbnXPD5xoLV0rMF+s9uAERHecuVVsDd8N9Gs2NZ+tEO2iemezbtfw/iqj1cAfWbJVSWTapaUyQ1Vf3wJYzgW2IfqU18fkxycjvDCLm0t+KMMp6SwbQwomidNRTN7fjdU+lIqKDKpTES0d0lul0SyprpOtivjpQS+rc9VW25MOuhXYoArbY97MEth0YpUjGohzRFi45wO8SrsATz60NmMOovwS+v+xl/9rr0zGtm+i3FLD47c333Zgfmwi+VWR0znJ8AGJX0nVn/RNtuSCz83QGedSQvSaL6aCPZeeT1F81966eEkq4IM6XsMnYjlsv5/f/d61xz2mzmF5u/DwjTXR72LHG47yza0L0KCaDUO4i0bwJ7exLaLaHAo+mtxCZTu5bjZkx/7MGWsvUR10rsbtAmCm/kpb4x7ZWyzgwP0MxtqHjErfkmPIZXinbHWLn+AjHCP60hxh9+OBb0xMFjXRHkfWK6We6/vMS522Z+WN5tqgC82JO1Kpc0MG0MaB7+SLjWbaBnepBcVDpb46blJS
 Ooxag6i4
 zUw6laJ4I5i7pkY5Af0j63a4+ttiLg+cAmPN/IPUk76o6rk2GU2OzCWV1TkCXggKJJCqL7Rj+9revZelHVHFrUD/M4af3tZX0JD9Yhm32hHnUZZfX0C3RFxbfuyfOAfxoxu+XjfsMLPyFzMWbs9ZH+FCEyyM5bFlWkgqwPgQ3hRlHoPkS3+zPywUwPHwP2YMSnfMlUlXN0otyixpmXjk57tLtxzDv/cvIEfiZ7mIOVpkx/PeQpct1SyB46ESR2XNuNckxvh+UWRFAEjfxPRm3ULqoWDquzHEK0Bx3blTG3R0ULHuhB8Xqf/ovJdnNoy5iSh5XtcV6q1ONmdoEZoTnEWBATk2Tmuk3WuGi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 12:12, Breno Leitao wrote:
> Add a Kconfig option to default kmemleak verbose mode on at build time.
> This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting
> is only meaningful when the automatic scanning thread is running.
> 
> When enabled, kmemleak prints full details (backtrace, hex dump, address)
> of unreferenced objects to dmesg as they are detected during scanning,
> removing the need to manually read /sys/kernel/debug/kmemleak.
> 
> Making this a compile-time option rather than a boot parameter allows
> debug kernel flavors to enable verbose kmemleak reporting by default
> without requiring changes to boot arguments. A machine can simply swap
> to a debug kernel and benefit from kmemleak reporting automatically.
> 
> By surfacing leak reports directly in dmesg, they are automatically
> forwarded through any kernel logging infrastructure and can be easily
> captured by log aggregation tooling, making it practical to monitor
> memory leaks across large fleets.
> 
> The verbose setting can still be toggled at runtime via
> /sys/module/kmemleak/parameters/verbose.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


