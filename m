Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 647BACD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF5A6B009B; Wed,  3 Jun 2026 11:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9F976B00A2; Wed,  3 Jun 2026 11:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F336B00A3; Wed,  3 Jun 2026 11:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5D9D6B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:03:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D6AC1C18CF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:03:41 +0000 (UTC)
X-FDA: 84838920642.09.693F4F1
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23475180011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:03:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NggKI2kn;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780499019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GE3cxqAXSaCHVcc+WKXlgfot3UvMd9FsWD9Iu0pbg2Q=;
	b=EfHvrwL61sdfIlkF9YBJtrdDnIli8+74b7j6cJKUN8TrGPgxfS3MWJW0UvL+mMT4heNutO
	nvXTi5lJwhkLOENAhaazulksARLfPyjh6tBjBiHL61+qIXXY2Z7xLQm19K0LeuCPPaTWvM
	JGKzlDILc5nLz0fYCTyXkd7EvWEwFWQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NggKI2kn;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780499019;
	b=xxvj2OEMIMX4vhqk15YS59U9kiHmFbRrYKraQ9eY5xp9ohoR4iAcrBJRbdi5myUTJTh4Nl
	NIdknLOI5NypE/6CaMKU4TxAkx7DDBsdUHOX1pUhcELW5r+OnADAGPtAlZv9YJ/TO1L8nr
	b9XxbPD7NiSfcFsPsGimyHxMqwRiLHs=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5176ca6bab1so8414951cf.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780499018; x=1781103818; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GE3cxqAXSaCHVcc+WKXlgfot3UvMd9FsWD9Iu0pbg2Q=;
        b=NggKI2knY3tC2srood4AL+IzbE7qO0ZmoRoZ/gJjQ+YyWEGAcJBwFL5gczUKJtkFxM
         /HdQicOMB/kbdpCx6RPCyEJ8BnbxnDcyYf4K0hIWnTw/6UUbQ7d48O75q7Z7ljkwNRQj
         A1Mk4XxbUoDlzNF9GuXdOJQHcd4VUvcmCsk4tH8T5A0VuE6MXgaeIGOxXPvEhDeqgqxI
         GLmLOK1SqEVA0kasftWEtkxSsVW/dIzC/djOhFMamlGA0zsicTcZXeS2kNbW/rTv2I/K
         ngSiEiadDxASgpNwBeqIQw2edhm6+pU4qhpzJWG+O3duWlvPGrRYRqG41k6PxaMMHSYk
         yTyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780499018; x=1781103818;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GE3cxqAXSaCHVcc+WKXlgfot3UvMd9FsWD9Iu0pbg2Q=;
        b=QxKRPm6HiTINrdAGdHxkUB1oZ3aWP8bszmg6bn6KHS26qR2kznvYlizib23ox4ZKTt
         x4AupYLxGczW6psZx8rUAIK4xEMi01Rh0IwWZYDOdpFmb+X4Kqi+6h1cleHBLO1EcVXe
         UBbuor/CZiWX2vNppFYfvi6uH/yWHQBb1vNB094U+LHwaaYUD+ggbBkSNWnKO2n4kESQ
         UdrzFf9AeN8HLK3RutMkIwKOuZ3S4x0W1qcVbHbOP6kGB3upnszrqPI6sJuUSyb+QbIF
         9PiHvxgqeCvDZGg5zUdfYFiBNqYA9LyKdyw3q7XV41Kh+iYGHsPEmboAVOHM1QdS67HZ
         6jGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9aJw9GmxkTkZGVI7cPGPNEwFQ7Wdjsi/S4nzq5SEb6pMA3csCmzCaqg8N+jPCAZq9IrP/AE9M9EA==@kvack.org
X-Gm-Message-State: AOJu0YxtLNbj+gfLoqI3gDxS04sP1KmlwFPXrOjTa3ts3BxTn0Fc3sLt
	OzUXNzV+stHP3cwVY4gDejgZoRY3eslhVaKWJRlJmCHyvZliYq+wYPnOdW5eCz8YHRA=
X-Gm-Gg: Acq92OEvgv/wf/03p0xTfwCdo7FiTnQTkaAC/gjLD5qNjH42LwAGmf8XqnlocTGKhqD
	Yha/P5Vvkt7Q0BRVsawjtVmb3EAMZ+KHddejPhRevWkXEuOeUiSlt77LWcfERHVFjyd2+Pn2wI8
	Z0vJ7I+UCK/QAndYi4q6M7HycW7IWK5Ar7ZWBpywyG6vKDk+IbuTWR7zvhIspPUT724q7tuh35A
	l3iv1YJpD0J/fM0ucrCdACP8ETp1t7o7z+TwTqyKJSyvNwvZKjrurbsqB+s2jo4LuN2zZiZujLr
	Gw4g6jJ9RA0wEQKmO4drtVGy913tcCKw979YuqefXGgzkmP6ZJqkM7xRGzEy79Bvx4a9QyS4Ru9
	I5CyJEcNHvpIb7s1kKTxIKZg4qwO4GlWPwCBT1EKT3ghrw+oQvBRJlYaldB8WgCa78kCFdZ2M5d
	4kOwMX/jTSALwfBHQ57TTLp4vNOqVf2fk89n6O8k3/pdWyQqQ9r3307feXrJlvPA==
X-Received: by 2002:ac8:7e86:0:b0:516:82e2:7788 with SMTP id d75a77b69052e-51779701719mr41203361cf.1.1780499017835;
        Wed, 03 Jun 2026 08:03:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775dd2e53sm25188571cf.24.2026.06.03.08.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:03:37 -0700 (PDT)
Date: Wed, 3 Jun 2026 15:03:36 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block serialization
Message-ID: <aiA_j7udFaO9TRBP@plex>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
 <178046937151.468621.13398573538792303093.b4-review@b4>
 <aiANtYRRDr5iO5QR@plex>
 <aiAzT9TvGYjITiB8@kernel.org>
 <aiA1slnqPnC4_8XY@plex>
 <178049725439.475072.11560134126837430744.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178049725439.475072.11560134126837430744.b4-reply@b4>
X-Rspamd-Queue-Id: 23475180011
X-Stat-Signature: ekam6of8zyiuhrgbzx99t7npr8gafchn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780499018-619950
X-HE-Meta: U2FsdGVkX1/7w3fdQPETjfWM8Tk+k07uPRA3kT+Y210f7PyjFPK4qLW75S7g6J740m3KLBZrRaIJg4+LEmmwkPC30MMFzSW6W1BsrySOaf8A0S8Qp1LnYYdMbOcZYX6NGeGVlTgkxXmn5a/iCK8UZeNfhPjzNJlQvp59DWPGW3Q/MryZF7Pu5mXPkjF8H0fK4tWr+5RErVup5tn99kKpH/uvK6XrBgrGpIwtFW7k4HV8PN6rYz3tr2aiNfKOn8Zt2pYIDyc8dwSJI7HanEyNLB0UREO/jNJyjhpaZMjlfGfgg2qqp+INjMYW2tiOOGbUhIHYmody7GsVuBeVnfE0Nnrtooq1oMsb3T9af/ott/1f4toQjB9L7eqketDASGJZ6gZLhAmBaohKjI0i0Er3BXNnvqONVPalQKm1JHGsufr3UDbIr4IVVpBr+QvHwoN1ZcMfEOqxLm5dIig3Nkxb2vuJ9dOQAHlgskyvG5LQUPbDDHyzVRVtAB7qbcs+IIn/Z5Iyr4P+VOALjcRlzLt9jJOa+42cVUqX/AcYnpmPB9Ks1ScygOR4Qwuz5/qqlUbSm4GY0+xg8fiTJ6H7z3e/VuO+51Dm/AiQkHi55vAYhCMBBIm0FR4rYZwlHJHpyZAvRyGCqq76aaFPnWcVNvrRJOMf8fqWWpdR6OWfMekHaME1E4yOfxxU1Zlna+DzJKMe5X+Wh8TKOUR9caa9MlhTE0F//6aMKLiu0nDKiXB40rZWPOcN9w5wKWmqk6ya5ukJ18pqoTRPquuA5IzqoKWRZ6TQTGPirGPAXJmKSKnPRpU/LIfedb7LN+FNFGW1tOQ6jm2eZYuy6yq+Dj5HquQ5g61to3KhWzfPX3JkT/sUc3J23KUa1tA4aDBCSw6zukbiEAZwg6bnO2MOeShZZ7bnZ5424/WjMNa64aS/JGs0JyeHjWOltZavk9ACjBgqMm00Q2SOL0r1AU+m6uhgzL8
 d3kWvTKZ
 RoKbmBHRyMsTn68FEXYsKBqN4kdqvPNpsZN9XTfUENMthta+KyIprfw663/os5R5jU4jQPaulPZpE3oHkioqGUPq8unVASULrN8+aS6cUkOkLe1DXO4iNdbfBbZBo4C1qe5bX5OGrdCpZdvjB8wxmlmM8HVB04piNlG9n01dhlfpggxs2vtljpbv+8yc493fpfjVJMtYflcRgaJR+RlPMIQYr0NsxluwCzKzM7cCdGazy6Z36V7boCxothCOUbrQLNtoCP6tbYf2rxup3ewxwYZkO5piH8AqF0vptrWDkrNrh+hhqHJZaT0Ru76frAFPcs6hnGz9gbKCBxv11QX4Nv6eNL0DbIiTHG/unnxMXeUplr/xr6y4/jscdXfCTQERc/0SkbfK0pKPUpps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-03 17:34, Mike Rapoport wrote:
> On 2026-06-03 14:11 +0000, Pasha Tatashin wrote:
> > On 06-03 16:59, Mike Rapoport wrote:
> > > On Wed, Jun 03, 2026 at 12:05:04PM +0000, Pasha Tatashin wrote:
> > > > On 06-03 09:49, Mike Rapoport wrote:
> > > > > On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > > > > diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> > > > > > new file mode 100644
> > > > > > index 000000000000..8641c20b379b
> > > > > > --- /dev/null
> > > > > > +++ b/include/linux/kho/abi/block.h
> > > > > > @@ -0,0 +1,56 @@
> > > > > > [ ... skip 25 lines ... ]
> > > > > > +#define _LINUX_KHO_ABI_BLOCK_H
> > > > > > +
> > > > > > +#include <asm/page.h>
> > > > > > +#include <linux/types.h>
> > > > > > +
> > > > > > +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"
> > > > > 
> > > > > It's never used by block set and after looking at the following patches I
> > > > > found that it's appended to LUO compatible string.
> > > > > 
> > > > > While this works for LUO, I think it should be kho_block_set_restore()
> > > > > responsibility to verify the compatibility.
> > > > 
> > > > It should work for any component that relies on  kho_block. My proposal 
> > > > is to use this method for other common KHO data structures (e.g.,  kho 
> > > > vmalloc,  kho radix, future kho xarray). There is no need for them to 
> > > > carry the compatibility string in their metadata, as whoever uses them 
> > > > will include their compatibility string.
> > > 
> > > So if, say, memfd_luo uses kho vmalloc, xarray and blocks it'll have five
> > > compatibility strings glued together?
> > 
> > That is correct, but it will be in only one place: the header of the 
> > client's KHO subtree. Since it is dynamically sized and 8-byte aligned, 
> > it should be safe to include in any struct.
> 
> This is safe, you are right.
> But I have more usability concerns from one side and the duplication it
> causes from the other.
> 
> I can see the downside of putting the version information in the data
> structure itself as it either requires a different header for the first
> element or needlessly increases all the headers.
> 
> But 
> 
> #define LUO_ABI_COMPATIBLE     LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE "-" KHO_VMALLOC_ABI_COMPATIBLE "-" KHO_RADIX_COMPATIBLE
> 
> is not really digestible too. And it forces KHO users to potentially
> track KHO internal changes.

These are compatibilities; I think they are quite digestible, both to 
write and also when the  LUO_ABI_COMPATIBLE  string is printed out for 
debugging/info purposes.

> We still don't promise any compatibility between different kernel
> versions so to avoid blocking this series on the decision what is the
> best way to convey KHO data structures compatibility I suggest to bump
> kho ABI version in v6.2* of the patch that adds KHO blocks and postpone
> this discussion to after rc1 when we'll have plenty of time.

Let's keep this patch as is for now. We will have a broader discussion 
when we convert other participants to this new scheme. If we decide not 
to pursue this approach, we will change this code to use an independent 
compatibility string. However, having this in place as a template will 
help us convert other components correctly, ensuring proper alignment 
and that correct string helpers like  strncmp / strscpy are used—which I 
have already ensured is the case in LUO.

> * sending a new version of a single file does same email traffic, but it
> confuses b4 and quite possibly other tools, so I think v7 is better.

Agreed, I also prefer re-sending the whole series...

Pasha

> > Pasha
> > 
> > >  
> > > > For now, reviewers will have to make sure that if the ABI header content 
> > > > is changed, the compatibility string is updated.
> > > 
> > -- 
> > > Sincerely yours,
> > > Mike.
> > 
> 
> 

