Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E191073C93
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270D46B0088; Wed,  8 Apr 2026 08:49:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 248866B0089; Wed,  8 Apr 2026 08:49:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185456B008A; Wed,  8 Apr 2026 08:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDA46B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:49:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A86AB1B9049
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:49:34 +0000 (UTC)
X-FDA: 84635369868.16.E2C1F3A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id B68FD40009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:49:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BboDmiBu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775652572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DCiGh/TAopmTia/e16V2uyYbOgyzJf5l79QanUCh3kg=;
	b=SVTSb5eWfKZfBv3AvuHoEhFcV0dTJUe3PR4ylrZzTVp3rKuPxfag3KRi65rADyg25YyaWq
	WElWx6oHuAaSmFhsNrYivSYcuwV+KzWwzB+8fnI251EtimPu/Dlnwp0PR6ofro7QJMH3q/
	JAQ5mlDPG3D8ZjXs95FSA46vBJD/EII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775652572; a=rsa-sha256;
	cv=none;
	b=PK2sU5NG6AeZptLVKT7Z6Ulm++EhTtSk+Mj9VERk5e701t3OqXxyjHUunKqfPzdgQJPQuN
	/EfaXtEO0kAqFd6LbxrkxQoU0WBd+AUYDrwUlNusDLerd0sB7flWSEOSWy0zXyi9pKSUGq
	UIhbgPXgnfokZ05A09fiXZHTly+XCbI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BboDmiBu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4888375f735so58708305e9.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 05:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775652571; x=1776257371; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCiGh/TAopmTia/e16V2uyYbOgyzJf5l79QanUCh3kg=;
        b=BboDmiBuSzfDSeAU6GVpTiOSd/+5GHslNlVVZg/AaR23bZ+XV5HTK6flkkHUdVbFRL
         D0807WW4mezJeJFaMh6D0DRp151SY0f+8ZRH6y5iIy4zXFWhkTmF08SeU64rkpMCGDDB
         jonvGq01tng/EdQJIJ3YsYsMnH0l1k3zC78sO4qqxSB6315rUsUUhabwVjG5wWLA7x3J
         rHxorZg3LOa07BuhykU+2Gh3ExY+35wpE3v30H/wOM7saEZ527VNqSMasDlvUp79ylzY
         22AF0xgJg97CyP4c+2tEv+UG0y5nLmm9ZOHrt2JZV0PlDnl7mDlLjvIT2GQwAsOX/16t
         Z/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775652571; x=1776257371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DCiGh/TAopmTia/e16V2uyYbOgyzJf5l79QanUCh3kg=;
        b=DcTMA1CNPNZRE4voNAeN9WjGpczp7hXT7e38v/1TMsKyDCv6kaumzi5VUcLqlZRlAQ
         He6hblp2CJ9JtfiKPdQB8cZXUj0Jxfj+xgNaauuWBQNKfor173pVxae7Yu9Rkom9rA8d
         /bGs4sXVCeAOpdpC3CqN+GnNhomMw3cXIvG8+csD7DKS0EieeZ8NcfdjZmhbhVCFFEMy
         /+azy9jR+DdtbQHh5EBGN2suGeUouOC3W+gA2V/f8pbt8ocg3sS/GW2PufFCC8D0Kzhc
         nCmn0kW+LkyIw8y4TWGXfi4kCQnnyeXi7wzAwT7M+0IGh5x7k8LDPK3A/f2oTn3GeRT6
         EcRA==
X-Gm-Message-State: AOJu0Yyd3piuWz1nmff5xJInHaosGJhRHt+2VvU+hecEAdPvZ9Nanvi7
	Td5mThVv3E3FjDesP/Y5AVT0r+5t4W8+VTEvT0jAoS+P5703zf/UQD1N
X-Gm-Gg: AeBDiesgji1xtAJnhXFiQEQBp2uo1BjF8UT14iZjZ9MQJ9TLBzx5f5ciYGQ6RRkbTvx
	JP8/8TSuXhRM53Q6bc5XSiw42qQUoozelW6Rz59H6BrBZoipv36XEWQJ/RVGsWjVuV0arw4+PBN
	bRlgWXXE7TwgCzHepafuCsX5tZE8qLEJPP5/o7Pd3FCZEVXTiXr8SjJCasRzzc3qBubzEK97dG1
	e2/swAn/mjrBDFrlXDMBGzbEeg44XV2FPAkTOMAeYMNRn3H+JXX04qArJ2q9e6y4yEeHZKTWwl8
	lZsZpn+B+x/YaaqbdD0eYyt1JjYIY4G26WKOfo5J7rxrdS/juQPOESZMAbty6x6bN5pU2NP4W2H
	tPiu1V8VGojMX1qfLvwvxC/UK1ZZ3Q8pNqqdo3++dRDuDyNLovsYWwnftqENNSeKx805EbErRIV
	HQAi4/X+8/6VPmbnQLCL+IRBzlQhzmmqFC3yTN1u6CPusvULhbEOMFSwHAPp4FF9bHoGn+P1Oo2
	9k=
X-Received: by 2002:a05:600c:630a:b0:485:2fe9:336f with SMTP id 5b1f17b1804b1-488998e3cbemr296043305e9.30.1775652570938;
        Wed, 08 Apr 2026 05:49:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488c5dc5fefsm24994505e9.7.2026.04.08.05.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 05:49:30 -0700 (PDT)
Date: Wed, 8 Apr 2026 13:49:23 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@redhat.com>, David Hildenbrand <david@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
Message-ID: <20260408134923.3a44a703@pumpkin>
In-Reply-To: <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
	<1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B68FD40009
X-Stat-Signature: pemhhkiohuruato31dma3rpqn4z7t5sk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775652572-645008
X-HE-Meta: U2FsdGVkX1+XyTfpC71Tw/7hpYnYMG8Cu1/woeOuSVTaSC4vzPcOYBBEpTudWtor2r0/vhCur751s3T6HGsvRXsyAOxwJhZodKBOXqO6K67Qii7UY3b+hzSyezfXnXMV2PRpA7CWb3YmQdZAX5f34zGDCYsfF7IYW7hkpulz+HgOMxumumYg6v9ch9y4MdXIwUL4x3wL5BdUrfZjNGrb0jZjYtzJbOovQedICCPf5VYdYyl3yY03PmnL27t5+SrNLJ05vvIwngLkWyOoisqVAjSoAR+jM72S68UdHXkYdBuwlmure4trIPbPxcVwZrglTspP0vJfhHtl+N/hndIdxKJOVYMJUFQTSgfs4Uo5GrDDWc9oKa84BxX0pgqrE1TgJUMISUlOXdlLgfeSUcEwB6rdx/Y4FG8aNctfDV70o0Xu6aAE6uGKtxX0HTlpYFeU+cMeLF60XEDco6ZbcJ8m2zmXhwAcy31co/T3bphCN+egUbGG3KOThM0qqDtP/sksbdraPO71r7uwytOV3hOYzsOMiguJzEHjEbyl4oWZRjA2LI8CeTnBNc7ivzqY9EErv6P44tBijVkDqhBX09gNCdPTWjjCli/H5/KpUYRudHAmzmunUKiUgCYBwbfnrpMYypED/DNCWby5ChVN6rP5Ggdpc17uS4Lvhk1bRxPeq503TX0QtY1geUfp8OghjvKyxXPkboxJqckJ47j2FBZpeSk4ipZhyFLBKsMLGJMRkYXET7wJxoCuE6UmV+rcUovquZ3zld+In/MVY9bscfzsHPRJcjC0fybe86O4Wv4kAYV8H9EW6YVrbAUnthQ2vnuj5p0xOVs1nGUnrKcVMzX64egiYPdCQTR8tpic/vUrSBiEekFTjUsqMn5XZIc/B+VqzLESEu999gsdNQ+H8iJg2O4bwvjgehgxzFtig3CQLJbqkjxzbmh2ETPjh3WSr+M2+oc50sIERgzTYLBcHBP
 ZaY9qljZ
 cniYNayL5WJ81oHUd5PUXqgE848w8VfeR9ZRCy9q557LiTiTqG7JaUthknUfuFi4TONmr92jodGpkbHKK3fp/BGxuNmjxI9/XuTpYZQ8SGQ5SbEJ3q1edPG29LQzj9BOPK3GYCF5dotogOhn6n9jWKj88h2ldBTt+4oz4BjHu8hSqOSXn8bkLCdiiERHJiRaONCRLIVbxjWYOJaZuQ2lTeUwKGsfMxjdP71ZsfjuSmb/W2J5Bz9paotJRi6ry/3lAAuHCKFz1iYcDto/bSUIbMPpCGwTiLq2VmDl5S/QBgodUgDwxfvWY8YlSBXFcyCUCexBNu2p8c3vHXh+BRcq7jkH8s7Gkp5RbZvrUYcVydr0Cmu9tDqOhz8whd+MX/u27guqpuPTYKP+TrOE5k6tBPXFYpLZGwB8pYGYfLCcVM8bcorlpsQCMVsq46Uh4cVhv0+6hWdCmiyI0rUQ6FxU16Gzg360SCtaH64V5ujMtZYU8+z7MdP8AAXaF6yZye557G0moxDVH48y6N4S/qumV8zvyVb5S6IUBa3HuIttLexVDwwrZEq31N1l6F2udlemmJbHeqvXZhdwHFzQD0H5PpGH7uzI56OaGgDKOXcWyvmbJQOhholK+gsAdUZpL4fXUcHFWHxlW4dHifN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 08:58:46 +0530
Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> On 27/02/26 11:57 AM, Anshuman Khandual wrote:
> > Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
> > standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
> > accessors default to READ_ONCE() on platforms that don't override them. So
> > there is no functional change on such platforms.
> > 
> > However arm64 platform is being extended to support 128 bit page tables via
> > a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
> > provide required single copy atomic access for 128 bit page table entries.
> > Although pxdp_get() accessors can later be overridden on arm64 platform to
> > extend required single copy atomicity support on 128 bit entries.
>

Did you consider enhancing READ_ONCE() to support 128bit accesses on arm64?

	David

