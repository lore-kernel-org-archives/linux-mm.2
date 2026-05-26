Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDE7CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF866B008C; Tue, 26 May 2026 14:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160E66B0092; Tue, 26 May 2026 14:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FEA6B0093; Tue, 26 May 2026 14:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E548B6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:53:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93822A0477
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:53:50 +0000 (UTC)
X-FDA: 84810470220.26.1BD6769
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8856E1C0010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:53:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnayWnYV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779821628; a=rsa-sha256;
	cv=pass;
	b=34s4RGMKWDkFlbCqIm0y4L0R60eq8h7zrboLGkQFH+MHnEzNcJUhgLF7s8I/JpN3Wx3kkl
	+YN0qj+EEsxhM7Jh9UfWbN1HByBXjbXkWx+NusRf+/Vvc2V22oxYVkneZ8f/snDyFs0q5f
	fVqodWZJM/zVGnaJiWSQ3SHIf6YXr58=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lnayWnYV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779821628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9od+UEVQVZlO/XwHDI7UZ3wm6Q6HteW9V6Ue0btO0nw=;
	b=d2vU+agNN8/finCJw5IHwFSf2R9sl/Ln8z3/ub/58wxnuT3KKoZgZhP4UfScJigX0HexnN
	I6FO1kpGirumYOPIjNi58/9nhYE+VDDXsngKuRdVkZd9Z5Ga7pQOv+6JaVahgK93dPsS76
	Fq51fNy1ypMZSwOOb2cWPYHoe6emO5g=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-135e88b8e55so3261773c88.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 11:53:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779821627; cv=none;
        d=google.com; s=arc-20240605;
        b=VkTOvoKJplMrcuHB3eqOqz/LjLxkcp+iENmtxoDuXPRouFtInsMI0kF3iFlOvvg5lv
         6oVn9Az1L63CziCd9ZmfKYaeEtvuMH9rD8/MwB18icT/kJzqpaT2gKpLay954zBJxzlm
         t80vem+FkyGMEO4IH6CDOzHUGf4Kus/JHjAf3HyURNOrUUDomkMKLujL6wd2uwEiivyj
         KRlOU9i+2S88gDC2ADIi3UmPasb1OWauU0VDi9r8OmZSmeeUBzMBBP4zfKzKbXpmW6CI
         aFaZnOMi58XVgUiaxJmlIGqCl36gtXj7vGRxZ2+VzFnsGgcpMDasPLIyDwfjNl/WlONq
         EqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9od+UEVQVZlO/XwHDI7UZ3wm6Q6HteW9V6Ue0btO0nw=;
        fh=QOnSGrQGqsyGNrjyRexnqSbyN1zJb2WgA0eCDs4MmV0=;
        b=PAR761k1ZLiWsW7194J2TjQKuqSRiIzg4yhT3Tew9BCCr6HyUSV8tFM+oG4KaqvLVz
         Tbpg6QjlcPe5aIQ3gIvqyEkWce1AMbRMyjXUr7GTDZUlNkLW5dmD0sShD9wuqZlMF190
         wLgil5gJQZaH41x4HUbOUH1RKdBB+3WjzwdksySfFJfRA+Xe2/oXKw1HVF/4P4HOCQAl
         54yxiQypKTsp1ft35FBCg5cJzetC1cFpUSLgLMaJzHpGh+sSrLYf+KlB4YDIEDARxWxk
         5h8oNJ/HtD4tkAsqzjroIS5PzkMdhIpbseL7FMY1r+0gQRd2bYx0XKbUljtgMZKfcEDv
         efqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779821627; x=1780426427; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9od+UEVQVZlO/XwHDI7UZ3wm6Q6HteW9V6Ue0btO0nw=;
        b=lnayWnYVGgyMfjkXm0FiOdYy6ppTZa1UQMoOc/qKPzBxMopxZB4Mf4MqiwICllrBe4
         DtkipFH0QWB9LWw0uR4x4bc4ber9DqtfiIZdSJ70lHzfIJEh83Ij+CHvoNTfj65QJKbX
         biUv0wqEcGyZAFAMolyFLo6d8kbQapz6xAE5r56IfhAOnLVnmD8X+ZB7oYYgQJQp60Mp
         ci+yfKaE3jnnYVeeQaopcVU+xUhmqq5OH3Zq3omBag0lU9pDniGMLLU9uX+WejrNeLns
         FuHZ0c+41q9KdTsJBi9Xn1tuapJ1dviYClqn5i5aJUU5e6aI1kZ+Q4NrBJA9aYtb+P4e
         Lgwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779821627; x=1780426427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9od+UEVQVZlO/XwHDI7UZ3wm6Q6HteW9V6Ue0btO0nw=;
        b=A8qLIVBrIASeUfoh7YX/UIwG+e8EQBgwLaNO5NjDz0hvbUiNMydx5BWHh2Plwkdc++
         hIekfWzgXOZHaycwDeONKXKNgHVXV/lL7f9ESbsNKLEk53AL7DS0BALC4TN0Q55rxYP0
         0tbXTEWdy6JQNBamPaw9cw34prYgJ3Vz6SJEWk4DmTozI0aasSp765LubIoFrsUzh+76
         3VOZXo5AU+ZBTExFtznGfiJJkXqxDNavHM/2wbJo57DCeKT34eEp/ol/AOiQaFwJAP16
         sU6/p2Hni03YqQ9JWhI28qPRX6y62hcUONpe7iN4oT3dmIlZ4mmbyaEaLuigWcShdoPA
         FT6A==
X-Forwarded-Encrypted: i=1; AFNElJ+VeRNN1x9Y8V90khgHMgBIQBtvkmU70xlUOts5ZzMqxf8we8vO/02+oNdD21+JLTr/0qEuDXJwBg==@kvack.org
X-Gm-Message-State: AOJu0YwFwsdl4mtlbHLVGLXp+LJ0rGypcJszUYpI+lu+53JeW0WE5HDn
	a0wo5SpBUl0qZrtjHgCDf/5ExSUFTawXLSTb3mL0E7YE2P7uCftZ3adbNYlyEOz7HZ39GBgDPY1
	ey9eGOH8l2Ql4Z3bbvyFawQZmUHZTHCaSA8mjMyAE
X-Gm-Gg: Acq92OGikHMatYRDD0QBLdh2swadZ2/rAgTE1mPbTyKUhMoetpqeMWQL3G0oraKcW5u
	/pUjAjZzYex9BT4e0NSomOzXf1NFtALWGcEZhxqd+TmFV5UYM3Sic3xeJesrYg0qwN2G1N1KM5Z
	hyNwDVrSrOGwkmcN0QrmB6j5Ko0yi304UvIm/CfC3JjmBBsBY28gHTKws0rZLqOEPflnTCRxTJq
	qk0J4YX79yY5wBoP5RhWU0FiAd24GLNginZwYrcrIS9ponFU+266JKfWNByaYSCIKQ/4YSeHKi8
	EIBedhZsy3cduyQcUg==
X-Received: by 2002:a05:7022:22b:b0:12d:fda1:e640 with SMTP id
 a92af1059eb24-1365fc7761amr8178711c88.41.1779821626769; Tue, 26 May 2026
 11:53:46 -0700 (PDT)
MIME-Version: 1.0
References: <ahXiYGo-IWI94IVP@google.com>
In-Reply-To: <ahXiYGo-IWI94IVP@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 26 May 2026 11:53:20 -0700
X-Gm-Features: AVHnY4L77MAmu1Xjz_rxrbFy9L1T1tFPPVFOlZ6iqPzPQMXKQnayC6moEjvx8Nw
Message-ID: <CALzav=dkVWYmbWCO6wDuQrxetAcqYkitJiRF_BhDDGqn2_-RKA@mail.gmail.com>
Subject: Re: [Hypervisor Live Update] Notes from May 18, 2026
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>, "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, "Heyne, Maximillian" <mheyne@amazon.de>, James Gowans <jgowans@amazon.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, 
	Luca Boccassi <luca.boccassi@gmail.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Jork Loeser <jloeser@linux.microsoft.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8856E1C0010
X-Stat-Signature: bupnkp1ryb4xgkkze4dsxqmoexkdb4ow
X-HE-Tag: 1779821628-203591
X-HE-Meta: U2FsdGVkX188NcfH1DJ/TYoVdyK9qFoeK2GgODRmA4J9z7kMgu8NrEzIBf+RZlXFY0V0nC12ZS85Ai8B+UCP5h0m5hYQvlhF5piDPT4e87SChDM1V2oVIw33y6CeEZNCO1JlMUdKuT2NhdvPTWT6VWom8GBejFMHOFWMndKWR8rNTEC315QWjbjpoHDS3kfU1BZnMesDDUFih9p/bdrEfWfkY0pxz2dfDZaqeQ9N9Q2FD6Xhm6qBppN655jMkP4xLFJrukmrSmkZCpA1ixCp1kogX6CCa3udQzBMNQUma0t4eKkEBB4bepNNSXeMGgeBTtEFEu3Ql5Gz0vcMCeMlNoqdtkOF4P0T2nAO9J2V2LoRifksKJVAl3/cXpMbzN9eO8Jy0zrxng0KFUoFUvXh9jaOnuS67kjD0x7rFG62hnXM91R8iaMzC/YAkhU1awJrmu4xT2skiSJQYoIePmmljoOA9xZbXF4DIu/R1M0Ju3RTZgSalKq8w36O2jilpMR1VyIjINPQVzXnit70DBCyg0rczCno1b2AGCC66axUK/CKIwA8LZD8XRNXqvYKrK7zu86WXHWg5LaQZF6Kqr5e9XyagUFZXcRSj9Nsad7b2srDq27+Vpe6ierF6XB3VfHISoo2PPw6rbI6Bad29CeSko/2drsyLl7xNZ08JMFQ6JDBYh5dSAUKEpNEDKawvLHGvIGslVQuZfICeYReKJLx6CYfoBfzq6V1lp7d5NjKvrsTz91PJ9/jKmWq0qIFi1uKXVjaJRlSWOe9e5Dedrp2Ed6q3IsThZZwReSuUbo7kyWy05i7ot6rxbAM/2zhlYA5BBPeoCXERA6aMnwL8/h8G9mlDJEtbPvZfc5Md+SeJFeDZYXmRPXvwR+JjozlOn5zX+gyYjE9op+taEBnIwEuTJz6Y594k8lAoiWTpKViV1v6nagyTKealp0pvueLkZyHaVpTfdV8kdjZsPv+2J9
 UpqOESYH
 w8gwsgoVB2esVdV7zyq+gf4CpYBwmKa0BwIfiHTtlMw+LU10Mq3PKPmt32Fcu4qSYEE2vtXYzzY3I863+plyJsgxPHdP2QfandwAh8TmDerra50WgL+clq7rXAfQFV9njY8EKQO+NdMXWvSMVjbvGjwTGgjuItuIvOrKYdgvI4m8UIo570muM0zEbNmvKfM8RJJZZ7UrIhS/IQgrbIMsLxghHLjHvrosecUeKgJ7aUPBrfFBiF70ek99tcVEZgSxFxjwAirN5ONgCODMkJTXkGCqj9apHAkH1Jwca5C0Dh1yIG+w7wPEXMffTxJ91QZAJ/ennQaK+IZpzOSfJsmc8onc4bM9QAO+J2WP5wXMC71a1JevVFETJn8OoyjtaJ6nssLBxNbNQ8jsz4Mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 11:37=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:

> Next meeting will be on Monday, June 1 at 8am PDT (UTC-7), everybody is
> welcome: https://meet.google.com/rjn-dmzu-hgq
>
> Topics for the next meeting:
> - Vipin and David Matlack roadmap for PCI and VFIO changes to solicit
>   upstream feedback

Hey Pasha,

We'll need to push this back by one meeting (June 15th) due to the US
holiday and some out-of-office leave we didn't account for.

> - Status of I/O freezing implementations and HugeTLB fallback allocation
>   patches
> - PCI core changes v6 review and next steps
> - IOMMU persistence v3 and roadmap progress
> - Updates on vm_splice investigations for CRIU memory preservation
> - later: KHO support for Confidential VMs including page table
>   preservation and pinning
> - later: versioning support for luo to negotiate
> - later: KHO enlightenment for ASI
> - later: testing methodology to allow downstream consumers to qualify
>   that live update works from one version to another
> - later: reducing blackout window during live update

