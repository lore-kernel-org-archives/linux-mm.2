Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37086CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1966B008C; Wed,  3 Jun 2026 02:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7926F6B0092; Wed,  3 Jun 2026 02:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A82B6B0093; Wed,  3 Jun 2026 02:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 593DC6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:48:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A33A1A026B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:48:54 +0000 (UTC)
X-FDA: 84837673788.13.83D284D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E02B20002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:48:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnpXFy7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhhjVRzGCjFY/Egn1KMYz0zdmpIRkyGKHL7Dp3fm2yY=;
	b=YXQiBIVDml+UPifYFU2/aZi3I5a3iVDP3gmjf4ik5zx8WHxCRjCElY9UaIhl/p/3wU0p2y
	RvPNpfoPsgGH/HaZSrW967MZ5TQ+1NggeKXKMR0UosP7/itfHroj7fY27vS7pLVAi6D2xk
	SF5xSJjWiL0RLddJFKOPaMHNw2y6b3c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QnpXFy7a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469333;
	b=kqDlmruLV4heTdrQlNzLLeqk1Lc0bGC+o2DjYovfY1tVsWfEn/k5AUYEhxBAU0ZiwAA+2X
	3dIxMLrsklEfA6O5b5dLyyViCrI4YYOd/jUVv7lSrVh0/zePzOcbRECYXvBd/POTjWrwfk
	zzKSCBDO5qdMTDyqf+dzMdfhRMfARlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A53D6008A;
	Wed,  3 Jun 2026 06:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F991F00893;
	Wed,  3 Jun 2026 06:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469332;
	bh=FhhjVRzGCjFY/Egn1KMYz0zdmpIRkyGKHL7Dp3fm2yY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QnpXFy7aOSx4c0XwXqxUl1o0P5o3SE9r8bxWY1wRf8Zs+p/gque9RJoVdI26q9nja
	 cuTDokjyXVrrunlcqqUNZ52+x/JuTP2/njAvYd8pXhbqxZ9jetcB9dYXxxsKoOkxUE
	 iEkY37Rb4ALMhUvCXYJAPrWaWuwGZy2IlEsXp100tdNvMlEQgVYwQJSAWfrryznti2
	 CHcz0XyHtDXufFQYxEcpoiLz4/700CFweiPXcTolNTc9z+qbCJmoNBlZ3WC0mW0DIJ
	 IcoUzM9AFvCJBp1JGeGQBZyQcDkQgsKl1ZRJ673FULXczC0vHuIweUcz6BqPH0V4LU
	 zWNVF13v0UKrQ==
Date: Wed, 3 Jun 2026 07:48:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Nico Pache <npache@redhat.com>, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liam@infradead.org, mhocko@suse.com, 
	vbabka@suse.cz, willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ah_ML-Wm3B92ZniC@lucifer>
References: <ahVX1iq_-95vd0PN@lucifer>
 <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
 <ah8Tflgn50DTMvwl@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah8Tflgn50DTMvwl@kernel.org>
X-Rspamd-Queue-Id: 1E02B20002
X-Rspam-User: 
X-Stat-Signature: bwyu1bpg5y454gy9xuhb8xt3keus5esm
X-Rspamd-Server: rspam09
X-HE-Tag: 1780469332-694356
X-HE-Meta: U2FsdGVkX18y3r19HY1y7bLKr8n9YuqXwNNLuOJNdtwRN3gaRgz6o1LZifFPuxLg5Da+slg9ic67N3xjFaJp1QNrWv6dTcH1i7xmZWsnW/826Lfc0hTk8t6GZqIGXWsVOHmRuzr/PfK/Qj/4ihvWiItDFZU9huyVKTdakXRRdxqBp4AaqM7BO/ns8Zr7/FiMOT7TQm8dqTTVz4IYf7zISScErVZKTaSqK/L1mWcZ8YPl9AQmWEaifr5SzYFf4C6kDTQr6gmNGHWVtDU7Dh8W7NXyaTO7MSQEnXv3bw0SCNiaTgLCutSCggJ0oMxrX32JFdRbf6SYoKxqQfYlgK2veXpXNfDAxk2zMea0wha76uZ0AT5xdg6esMcqX7QK7YvLJevpGpjEQVIc5wwgzsMqB/8qOWU7gzTMR91rxIjYoU7xh6VNx92RT2R1phyB3/c2a6pFEWLfqT/pv+3gnzxF7ieZitr3DGKipJ+ODiSIxxn1rC3dwLTzl5FQjRWMnhVCIWjFZAn1p5iab3ZBA4hQpjma7r0wei+UZmAEmtCwrIxww20I2qHD/bq4CruEcSVjIXZU1DXFwNGtx8SzugoefG7Xr6GnpZc8AKG0D5eVfkX0Hj5bpyINyL8aEZy0TAUpqynbx1cADZpUb3BrHhIw9uD4EfRym527wBkWZbycuqunXjDQw9BeaplFT4ET/7cbgcIf5JSFmk/1SMpxQC96SBjkgLG2UIqP44ANqLSo5oPKYxhyX5H2yVRAyb6pUID31pgponYyEJMOXiaMIg4X31dlZ59/MFtwnC1Kpku+BpDL8lTyo2cymU13igGOCsT5wqqkoXqn9FF98/8GHXuBDZ562tJLoKEFJRprwhu6gg31aY/Ut5wiYRUGzEDRQ88OzReFCGg/W42E61qNlyIcqnjZBU+2gJ0PJjM6SFt8fAOtoow6zEimCosd1mwHUuOFk8CnBUbd0MuL10Y2MPk
 OB3guXI2
 Q9YsV72Cl+Ws6qhVqLH3PG3zQC0QgyelwQ5AvRG0PbH9BuHpk3BgmYniEMJW0fFJcPOZj+zUf3vtgSlYbVPeQX3w2PVYvcQRsEy1kBa9riD7d0TDhgG/uYU+Yjz5n2keAY9pekp1ZqPELBqw/Hwi/DycbyyxZwV+sZ6/9q+Vf7R57qDjpspSm/hdK6QnmrBb9eERdViJIfYsnxCSI1CvZL+bA1w4P0SjcIdrarz0/dib6UBQAfJRJqZ40wEdArNSkN/Fx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 08:31:42PM +0300, Mike Rapoport wrote:
> * Supposing we keep the model of early merging for testing [Lorenzo, don't
> yell at me ;-)] I think it's reasonable enough to drop everything that's
> not going upstream at, say, rc6 and ask contributors to rinse and repeat
> after rc1.

I won't yell :) but I really don't want us to do this, and to improve our
testing locally. Because:

- We've become a bit notorious for breaking linux-next

- It makes it more difficult for us to yank things

- It blurs the line between the stable branch (which in the new model we will be
  updating constantly rather than right at the end) and some 'unknown state' of
  'whatever we just sent to linux-next'.

Cheers, Lorenzo

