Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D52CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8A36B0096; Mon,  8 Jun 2026 07:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFDA6B0099; Mon,  8 Jun 2026 07:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDB96B009D; Mon,  8 Jun 2026 07:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 221EA6B0096
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:48:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEECA120A87
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:48:01 +0000 (UTC)
X-FDA: 84856571562.26.27051C6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3B56100010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:47:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lM1L+JOE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780919279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50OC+dN1N2saKp65EvIeh5RVBrO21QC8rtRPxTXYSBs=;
	b=x46OFuAmoNZlfYfLALe6UZM8lgOa6ydsMZ0CImCDw0R67nwyVchjCBv7LWeXFi2kT4IWeN
	YxLWUfKoIDTpmJ41M0AluekXqnQ5kp5WCrv/80VDB/m13XIgCB6sIjKOyYdBO72q5lwjFs
	xsYBqQIS2WRkfuxNpPj3N6Mf835edi4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lM1L+JOE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780919279;
	b=il71lDb2bj1UeJumnQXX9yooT0MQzwHryql8zxbyxV75F7GEhtTMRhtJrFozP1KZEFLrgi
	z2S0+a5poaGz2t1mjiUzTcE2lNX3z17Iin/8oHy6IWalv/6of+nTedp+DkM/vFYa34CsAe
	inwpt4zbVRCAVD3V4SxodZ5Rm64s5bo=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2bf2d865383so301365ad.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 04:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780919279; x=1781524079; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=50OC+dN1N2saKp65EvIeh5RVBrO21QC8rtRPxTXYSBs=;
        b=lM1L+JOE5vccRW8sKHU9jGgNT/p4Lterr3tmlMIpD6ALHc29Cys66Lw6jANvWWSasc
         IqtJLf6D/44t5GYZ+eCQGoYABqnzu3zKSFQKihyABIrR/EVzQPcFBsHoL9GXg95l8NVn
         On8imOX/oX0gof7inQ2YlWIq2jtuyK2Xf6LuYPf++VK9BwdOvqBmlvdiFkgtCjHCgv73
         +cPezZbLywhq6faAiAubOu6o9pk5hwtVwD/wZ9NS4gu7G2fQxCRGeS19blzaDt0zYeyt
         odqgPGOrSljzhhmUQsc0fICq151o+ZRnnqHfPEC2qtNxykXRp8eF28deKeDWGLUTRgHR
         Yp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780919279; x=1781524079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50OC+dN1N2saKp65EvIeh5RVBrO21QC8rtRPxTXYSBs=;
        b=SVI1Li0syftHoHs0dY1ZZKbnFGRphLUbG65rkwHwQhhMkkXfyuJFif0VO12ncBcQAB
         2kVqd23g/ACvZwkT4NwyACnSzQGwqocGj/BOJPm2ypSyEdThCVuEjH3nEudYfP/8l6Nf
         kJ6yhLpg5mK0G36Ez306krEzn/5YN4VRbk4320nzAmeYrj24VA3GJhLN9q0zRwSRIc+5
         dmaOCgvHCafSXAR6wP/bW3Vqj3hJ4vznXwDsZhxDTbvPkEa/chasoGLIscVqvNH1klIG
         NYQnB4Nv2gMjk4IrPJaZ7479J83qF/g667a54uLTaPijU5yhpMlcQrmOaOVsU5EXu6uM
         BaMg==
X-Forwarded-Encrypted: i=1; AFNElJ8GS8YL+C5N7znoaojaSCpihTE6VkVVSYpUzGv7XVwIJUzhQqlGqrV3Q7ZvQShn2/61K/QW+DBxNA==@kvack.org
X-Gm-Message-State: AOJu0YywOyY/Hn5HEqA4h+NxGWvET2Kc5fvPRwbEW5k5Bm590EXnoeVa
	BdVnXKbvbGP0Kbkr4RF9Q9mo+/PqB/swAboEcSoGeIalb743uYd7GCmVrkde1sw72w==
X-Gm-Gg: Acq92OEWPjXSUf6YueftwObNSMj1fAnIp1NUMRlUP5HiD6mVDHSbR61OT6h6cNAbl1j
	n2rh+6SPsopEbDiKm23fxhfGo4KUXwQBzFSqgbQD7g8jIIDe3iuPeK9O+55pXrsUSMpxtGPD0OX
	+/ZbRFnA6/lpZDAQUC3aWggnyi5TbPWJ/yTh/u7EctIrBlKqOhWri+mlLhwjXjwG+y0y/aoSNog
	DydtkRoXDKLbwKPeVWHn3BDCL2DHo8VvscK7HKGK6xlnRudL7VhszviyIdFPonZ5CivEHR3qbt4
	gXvk3NwLsW91njXLF0ee0gQfQsbnBstYT1uR2yNDZyQ+19kS6/HAuzBY+140lKG57U2ziElntLe
	ggQ7lwzxar8yXDhSI9rhSxGxT7w3OFOwGY1NF44Uaw5ETpTU/5e28RShoTrWuy2K6wsD1m+vdYZ
	16KstiJAN7mE5UjfGe0FaX80cqT1n5RO8Be45qAvhfd/FubABRUMDmGZT8VhE4HAJD2+9mg24=
X-Received: by 2002:a17:903:2349:b0:2bd:3c1b:3073 with SMTP id d9443c01a7336-2c1ebea9c71mr4332535ad.16.1780919278196;
        Mon, 08 Jun 2026 04:47:58 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf827e6sm19158424a91.1.2026.06.08.04.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 04:47:57 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:47:48 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 10/12] PCI: liveupdate: Freeze preservation status
 during shutdown
Message-ID: <aiar5MyWymrLjQjA@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-11-dmatlack@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 8up411mtjgz9gw3era9bi3wzwp4tgep8
X-Rspamd-Queue-Id: E3B56100010
X-HE-Tag: 1780919279-488002
X-HE-Meta: U2FsdGVkX19kunMGOVtRYZ2ipB6O/KN5sSM2GnlgCsenu8m5fw5EXqiVFw72BUOvPFJubXnSZxlrJfTaw7qNVZHuK4vsKMmGw+94AhEBQn2KaTQx/iKxPLkAaF0baBG3+++5Ujgi+XPehOxhM/KsfLQXS9+X0BDRpRd9DmwtjrJX1oIIZuYW8u13Nqb0HqKUhirUVMZJvFki2T7miJMFNujx+Ty+BbnG0AzjmpFWxJvkOLnF94bK9pwlfTJdwYX8CFFSgk21Xn3eOrZ5bztqO25EagwmVIh3vN/gddsTk2gIGSvu2T6IT524LHb1UDsPVBVMfDPRmjOMP35a8dgu2UU9YSqUSGkHAxd6ikMPcStH7cNcklY2/kDTw8bFjMv0HNgwNQaFCj40UMOEs/FXZX7uYA9iQSMsU+EC184dvE9r3qgBiYOIE2mjahOU2+1JmLe6ft/A3argUqV3ioiAkM1sSt/fkK6VkkWTseVR8pX8WGHA2fGvQkYy1JoOfDz2AjFyvRcyKAEJzjc7ypXBBstu90A4Mpk5fDm/BgtWL6Mqy4C4EYtGFnGFIRNn5CErSAyvKgIHbPLeIh0v/pNS7QtrcPFrNsOjJurpphnqnK1uIKLpU71rsTNFhNe30xfwpCONNQfkXnOC82cYm2s6+Syz4jOIzzaHyNSWsIzGCJZJ2x3q1mypqqL6LJUe2nbBkPsvRVmzdA0s0GT9y0NNzZ+MYfwZtOeD0k+nn6k7Ujfw9SFqiIcBZR0Rbb8OP6Kp1T94WVIVDcdwApbkY45DQbE7vYucTzVLCKnlX2GxfU+S3eBuON5XMFVphG3+GhK5XhSs7HQlvE320RXtVPwyeXNgq+blJvUGyfZMRCXfLKUQnh22n1KVaHu+Yo0ExNwtEdYvmIUty6ojghxDN6RV7omRVs0FtsSevXoN0faUoIwRgdEkQwKTshOo3Aoe5rB4ZB4GCu1acOzC42nYyqz
 8H52t99O
 eMh/qdNPCWHR2zsISfAWnnlVy5b9rj7EgSle/buRisnQ451UAOZp5Jdbhofbzjn317Tuhpwbr7VCe4L/cZjKySeyVb1Pbk3yYQf+i22zTHA3urzyqxsvWtAZbn3wCYLZU1oUQ9bcXLajuJps2i51rslr/JeuJk2x2dWAvHNrm3WaNA8/7kEAdt27EMsL8Dj5Z8IWilk3iRDInAsaYAwUEedoiE1Pf9wLZWcs5PjGPn/8OtlbaqdkROMFn3kUncYYEiA1oXdDpVJ6ASvOogBA/qH7nm1g504l8gNKYenRNcVeSK3Ea3lY9n6Zk9wuTRx69QS7GDES2UG6R5k54lUc9F4USaeGTlzimrsE0oHk4792hDXnlnAOgqHkaZX1ltJUJ5pneLOiAjXnX1ytSePYXtUZEx99+auIlPI0B5G30peNuQU/ACSobMGULFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:08PM +0000, David Matlack wrote:
> Freeze a device's outgoing preservation status (preserved or not
> preserved) during shutdown. This enables the PCI core and drivers to
> safely make decisions based on the device's preservation status during
> shutdown.
> 
> Note that pci_liveupdate_freeze() is triggered by the PCI core rather
> than from drivers participating in Live Update so that all devices can
> have their status frozen (i.e. prevent non-preserved devices from
> getting preserved late).
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

