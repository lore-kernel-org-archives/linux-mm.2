Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAA1CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901888E0006; Tue,  2 Sep 2025 08:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1C88E0001; Tue,  2 Sep 2025 08:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7978E0006; Tue,  2 Sep 2025 08:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0008E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16A84866CD
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:06:42 +0000 (UTC)
X-FDA: 83844183444.10.898FDE6
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E0C2C0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:06:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=QoDQ3xte;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lwHlTuko8/bhLBNZDswXiYJz77BS3zzuPZs0VGUvgtI=;
	b=As/UY9JocdtPG8wL7eYap1Toat6Y+vMmZgJa2mdV6hmwjuegni3QapIiNSWUS2Pjg9dHEn
	H+9anFHj+XAm6N2BQW6ckh8stEcMq+uQSPtQeZJyVkLcgJBYXzKs3iLYiWwTNHFLIzrFA9
	BLdbKyVFUGAD031mJLFd29MjB4UgFB8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=QoDQ3xte;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.51 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814800; a=rsa-sha256;
	cv=none;
	b=A53w6ve6Kt3xGEokh9xwa56bl8UQgnNeRxFs9zaHpfBap9vwVWKGd4MyKY2m00jakp3YXW
	9/8bf9PwQ2/wwbxmVo/2CyPPI0cuB95u9Lqujr3TUiZumeHziT2b9dI7wTkph0I7ywJ/fX
	5M64qEv1u3g1h7JaK71/5H0aG+FLe+I=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-70dfcc589a6so50779916d6.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1756814799; x=1757419599; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lwHlTuko8/bhLBNZDswXiYJz77BS3zzuPZs0VGUvgtI=;
        b=QoDQ3xteq18ZrZHDvajqXBPMVIYcfnHwyagbpagK8LKPfY/ycJysSqJLt3qWSESaka
         qm7rHrXeNkzk7NA6Bv6xWzNmqABHE3njdv4Rj/a5dQuOSqAm+EBn+11zuoNyt7Gvsnp+
         jiw+NRcesi/rZtZyUjTqG0FMELXwsb0KJIYjHAvzAuVynkJK84tcIGrmKeg4ub3eveoi
         U9yPIxA5AMc28iY6rAgWLJNhnI+O35l7A+9kcVzdD2hckkW8GBA5Ofs3z9Fb3UmfvuCs
         xiweURuVhYDJO+/oW4/H1hE/L1xqd76nQ1r131m2BhPN5gntgKIdpCRs44DWLu/sCDq0
         vdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814799; x=1757419599;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lwHlTuko8/bhLBNZDswXiYJz77BS3zzuPZs0VGUvgtI=;
        b=wnUR6fYrwi4rqKIXmEdDCJeZeY1XGOvaFBPwvPVKfv5HVTscc7cR9FYf+ohXGA7OtB
         zm1xMXwc1BW/9Phqizr9D7qcWQfOzivt7UaRUQOrFw6HlPE3vCE51ym6fm21sGkT5+BT
         7lJ1Z9CDzzKDUQ5deCh31fZYon3TfAuoi1ii+3luwr8hP9Xa/2DBlJxyeRaIJ59huGxl
         leIKfWsCgPiA9IogMa3a37zCrsAWAZLx/jX57xbVHhZRwp+IjPOSZP1y+wJF68Dh00L/
         m6e4OvzIDOiRAqK13Tz2RSNmCzPdCOtDIpkK1yKWQSSB+kknf1ZJ63i/U86eM63tADSH
         PJfA==
X-Gm-Message-State: AOJu0YxTV+754eMS+2AdJ649JkK3OMaYqlSEmDy16hbAixsEAwNNhm67
	by41+kPGSZ8N4Ec2mqyspEn7MCA6idpjxUjdUeeMzNWQQffi6SKNKg7f07+RsJCgrn8=
X-Gm-Gg: ASbGncvf3YINhGh42A/mOuKfwvWnLrtFx72JKRXuwuX/nvyEcqm8+ItAkW4bqRpXg8z
	moLh6XD34JEDMmhVAo5b7+E0g/JWYzSy6/IF9rwBh/R6ZulORtLSWAIPNLSkOe8nsHcePt7YksG
	KLpwfUPyxPd1CY2CXDbpBDsNsOBIMmdPQhua/IhQx9QZZdZUhAjS34rSAlbEpdpKATQ02sb9Tvg
	DVbm7cm9LWpSrgPG/CYshKYrG3LX1RDD0j4bCZuEvSboQJXigEry4SrHxPd8d7in7Q4gMJco/7V
	2N7JSZVtbxoyl+buZn6jvwyNRU/GyisAOrN+8M3BMFvBdGYx7BWV7qcB3ka/O0X3uVvvtsMv79Y
	dPpCJEoHk5Sj4OrFsEDpGGXoGhyLEaVxmQ2urSbMZg6CHKWKPgVPkN0XQLA95b8ZPrcEj7IJuHv
	bZfmaaqGgRRKmv6w==
X-Google-Smtp-Source: AGHT+IGQLTdGvLivSrgS3C3MjhD9R4PvmhmRB9ObwWSZqFcL5LLR25foDK+15fQJoFTFNVOh7BgXng==
X-Received: by 2002:ad4:4eeb:0:b0:70d:961c:bb0e with SMTP id 6a1803df08f44-70fac9202d8mr131625216d6.58.1756814799288;
        Tue, 02 Sep 2025 05:06:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720add66632sm10527126d6.32.2025.09.02.05.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 05:06:38 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1utPmY-00000000sb1-0r1P;
	Tue, 02 Sep 2025 09:06:38 -0300
Date: Tue, 2 Sep 2025 09:06:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@redhat.com,
	osalvador@suse.de, jhubbard@nvidia.com, peterx@redhat.com,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH 2/2] mm/memremap: Remove unused get_dev_pagemap()
 parameter
Message-ID: <20250902120638.GB184112@ziepe.ca>
References: <20250902051421.162498-1-apopple@nvidia.com>
 <20250902051421.162498-2-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902051421.162498-2-apopple@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E0C2C0007
X-Stat-Signature: j7u54ayru3ch7rg5wsz4odbpcu5f1g56
X-Rspam-User: 
X-HE-Tag: 1756814800-317422
X-HE-Meta: U2FsdGVkX1/2cznktQ9vf5aBCjLZ/zdyR1gbvYjBH23gby+pil9xB5y3+Vm841WfHr7/Zo9B7a07Ft0ldNpnXAiVNIWbuMQzbXm0/VaSk3W+EJ6HJuz8PBI9xYUvU7CLVDXZGjD4P5cHlNcBiMf4SCZcC39xH6vp7NmIjhwXkEI69SV03Lf7PNCWo9iBx01+Tre9aELWvhf7M9mbdOAGnvPhJUYl88N2JhgyRh2vr+OnNj7X86G1ROt0wrnjoL9hIBSK5bA+49LEXEPc69Qbg0yvboe+KU0RVfvktbdIiQ3adbw+wLilaxDPxPqm0/gzoYa0hsqno1dLlLsCIPHQBL7DCAmmI873l7Btf4d5iwD8wBtw6uc9ac6np+v4jtiVpmE8dGhvxOjA+pvcOZligxuVsUJNfn6m9jaLE897pyMC9dLZ0wQzEQffHAc1iQhdsnUKmlkjNf/FQH/jTxDdLHtzBGqPVfjT+ZyXcKw3/IsOTSL0A5X6ipj3Par5RUSF5a0xVofbeTK6VkiXWlEOue9r0PHFWHZvcgGzDv6SorFGKXAb6jU9GV5NwflqbweDYMU8br4dKnhK/Sg0a8Ic9bsX+0K7Rpqf8FZ2sgwIdbfRgcDpNACFpcwbH5cP34/ARW4RuFPl5TNa63+gpRzZpIX5ZXVxHrR8rCLar+UeJT6kO5vpv3dHeD4MKuWEiHo+wL1FmhfJqBhn9Ar3qg3V6ditt4FGiVZXg6Q+Ugya6K352Z5g9+jfrPxbfCVOikpw3joPSnDQtEO9RdzSEG7RNGmQ88M/ExSVL/wDFTjNPCPnrEounup6/M5VjR7lq60yJ95+1wpkXDYvVyAT/mlc45luVL5WH1BPubfbfKCkf9j9Gj58j81quJPT+F+bEIypW72LxaLZIHB9tEHCCRCOmyfqbIUx4LwTX1CpDYM3lqO+eFjmQ8SH13p387bpwIzHlpyRCKRVgUYojGOiWfg
 1z4VQvke
 RiDO8RxcwvVOlczFVjA5HpfKKOB9GD16aCdktkIfHow7ToRidjdtFmv4wT880A5jEyv3rQeGGo4nOl88Qfa0hurGF9V577d60UqPTOkTlvBHTybZW17hv8m3g7lz8I2VkI9wOxq9SeM15ps/2DjOt47UGScymcH3nqpT217bipbtFfpU/mxczDn3NmsLqbKwVOepDuKBTOompJ+ZPwPgylEHtavjsSuJEWpn3A8o+f4pVPvIRm8TGU/bQbxWtJbTdpNTMEUuJkFuQvgzDAyVZNgHJNUUyMOKwtwPPa2SuExCDSIR58sRy6knBSnUHvIKFgQ53SoMyLLfHGDx8UCh2VduNxdS3mdzgxbqk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 03:14:21PM +1000, Alistair Popple wrote:
> GUP no longer uses get_dev_pagemap(). As it was the only user of the
> get_dev_pagemap() pgmap caching feature it can be removed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  include/linux/memremap.h |  6 ++----
>  mm/memory_hotplug.c      |  2 +-
>  mm/memremap.c            | 22 ++++------------------
>  3 files changed, 7 insertions(+), 23 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

