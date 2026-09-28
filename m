Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1B6CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A366B009F; Mon, 28 Sep 2026 13:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFA686B00A0; Mon, 28 Sep 2026 13:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2766B00A1; Mon, 28 Sep 2026 13:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 898936B009F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:19:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E9048021B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:54 +0000 (UTC)
X-FDA: 85263833508.12.1AA453B
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4D7364000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:19:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=injF3HfC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790615992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWEY4l/bIKaUQ0LkmUfe65oGxH2cGGoTK+zPHQ0IPQM=;
	b=ALm651xZyjCFw37K2lIGitjFkCtR+RFxzagJBCqfbPJr12aKo6lx1+tPFKYJx4eFWZWHKG
	4Ms5LgOn3wTVErZWQMqXG4fcTxN85dSbZGKFZMiFByX7mGP9E8DIbeUg1tlPa/ya+D4n9i
	MZRH3YpwLof3PUDirNMBF4jwaSIhVW4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=injF3HfC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of praan@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790615992;
	b=Qzl3fwaptd6DOoOj4WGgqUwos8W7VjyuDGz9tm4K5Jz3EQalmjJuPZyBIHMX7JzLwzMyHU
	5Qh+chg2yjfuUSYFgCEvZeMrJEu9l0plvCl/YRLJ7MslgYugrt2e1Xqgqv6RFaBYCs+68d
	PaIxejIrQ2iBxWZg9tHL00gBCMiz0XI=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d3b445a84fso3175ad.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790615991; x=1791220791; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DWEY4l/bIKaUQ0LkmUfe65oGxH2cGGoTK+zPHQ0IPQM=;
        b=injF3HfCYHVQMHWvqLzGNOdltCiRTUPHt/RfdQRqS1pkIAHo3PxIQ5b5pxcdHxL4q8
         c1O5ZJ/qO+FnHMouhm3LRFW4a6GcR4AFK1WlqqhbWLgxYhHA2TSj3Kglg8ozaQ+5Wc9U
         /LdrHolK7wQdPcWmnoI1xDCdXp7eNETZ8wqqhU+LQBB4th9oHzR9mTw/Izc+CwKyM5Bz
         QZvZrfsJOev0TGGh6hCCPXy1bGclWXni6U9ERzdyph3tzmPnYwXW8P013NkFEaRHhRyr
         jDcSwlURW88yJNEIqcQG1+7mUACN+y1rJSjE5APeLk9K4z+RvR1sfLOhkxZpg0e0E9Kj
         L2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790615991; x=1791220791;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DWEY4l/bIKaUQ0LkmUfe65oGxH2cGGoTK+zPHQ0IPQM=;
        b=XPxs6vFrBSnBJ0zsXxUp2eKiEiGb220lkHmFTwPUqcMSRYG0xWyUn3B+pWsyDnpOI5
         l7WT9/EgXRlh+xC5zQ0twIPp8Y4nsE6l54Hf/0s0pBJVOHKQ2PasQRnCF85dpm+ArMRH
         wvXBXNEepgWiwFKSP4lJm6DE4R69B2C5FtOg2e1WeDWYNvUV+/eM7OrEa6tyhSIbbUSu
         FqX69i8ZesSdkVMdoRHnal3CT1IfPgQzc73KwQOPK21Ikn3Ipk+lV2hBhQUGr0A0gKZZ
         suUgpv6pJSZTjaBrxRmqBLf0ep366IY2tBlVmhpnVpth0bCuvIYNviYG9aDe7CmZ1pc1
         E9aA==
X-Forwarded-Encrypted: i=1; AKwUvBwkUVjk4X6YklH5Cg76B1Qwqo40uIHAC+w4mdglFcqf0j5Lqlqu9qoWIrxBoEKKaJmFDZ9VDudj4Q==@kvack.org
X-Gm-Message-State: AFq9FYL7g/bRNqSq2bxfrAsKFAkymmZ8DARgEbDOob7ngPq213m1EdIa
	R474gMVAw3V6xd3D/i5AR7dKE+HauEO/DYKy4yU4Xl2vsIiy2laGSuGJ6f+Nnl+PBw==
X-Gm-Gg: AYBFou28jaOa72Pr5pJqR71025RGoaUP7UvY5ANi5c78D/iW2b+8sGjR1uUmyESw85S
	w7XYQv+wk6TuJI8HH6SEpDPZ1LcW7JT+2BowPl5KdBjnhnVMEflggwemXAc0Yuv+FFTbNH0NJ/S
	psj2VOVUohYsNjgdF5rJ6w/Oye7lBQkK8zNxtJSYBJLKqn1GKOIUsXcxBryNX+XdP5KlnkEJNTh
	zKc+7W3AE0eq0rTvxY4fHArDNx6nyXJJg6LLbjBmOyV8B9YPeQyggqv3jVgyb0p+FKfnOyDoHSl
	nFjBgINjgAVcMQDuJxed2pbHubTnbUIeImntmlii3nDXwH123ofZaEd4/0w5BcxOQ+uE2F3JjYG
	SfRU3/svqZfIQ0PEp1SvSWIVfRQEG7zG0H5qmw3HbF6VqvkLO4F6YBiU9JAmnnVyqg1j7YmtZlM
	RIxkbUlJ8DMwpIIGYAgITN/VidXAbrSGFKqEGCShEXLgTbcNgE50dLUcnSrmCvBCNJCCubFuBmz
	XuY6RsE+tZwhU4foPlDKhPSaozCcK+pmN2S
X-Received: by 2002:a17:902:f54b:b0:2c6:99be:9dd with SMTP id d9443c01a7336-2dfa6248695mr7310435ad.12.1790615990264;
        Mon, 28 Sep 2026 10:19:50 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49858c123sm538411a91.3.2026.09.28.10.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:19:49 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:19:41 +0000
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
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 09/13] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <arqhrVi0YfFNwKuS@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-10-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918200640.887030-10-dmatlack@google.com>
X-Stat-Signature: a3qrw9333iwbbewsyuyn1ubcsw8kodcz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D7364000C
X-HE-Tag: 1790615992-301340
X-HE-Meta: U2FsdGVkX19DIHCLF1XX/ukcFczDPRFd4WeXNgLubS1lr6jwvEucm7ZOXxJvHCZTA0dGa9V1oS7EfgTDmjp5uJtfzija6KRo56UchY/9tGAnRcC0y7j/iM5VvCNAeFGvJwU4jXUNSIMoKa1PU5wqRuEmmPpryMMObnBdyJ8o//NKnh9dMew5EAJR0+0czOZkGJxiyLcfAgc43qDFOhrUHy/QGnjHoskBrSSyhXUExwCmvVhFjiTZ2Pjjong9kQnGpqQyzg7wiAIXTi8lvkUi2Ncco3Pv0Xi2WCWHj44aUf6Uth2m2ASS7nlax24697CztA6H6dvKEcMBX9f4XCsvGhvvEfyH3fqgpqJgkptn2EDFco9njlpHPlTOZElcc26UgQoFqiDh+XSspQOd9p2ZnKiF4IfjEtH3oF3IttuBFc5/oZ9rnu3M3L/eumb6xQUF5K02xHpqb89rS3udBkcKOYp6H343TlaRgoLoz7/M/leO2MaDwGvyXWNKzMDfKscMs2MCzpMNzvxa7WG4KN+6oV/5qJReq16feNMxAy0kCKQ4ZnXLzodP6MaRnT53GYV9NlRwo2dt5csrK9nCPeWpnw8q34hcFtn0khh3W8xLzxx2PJY3C90dFyidWUk3oE5JSoQPZXtCuPLqzsSfAMgMS9Sn1hFBl6niWr9SqsDhizbrCP6dao01SXeNSn41u8xa6TRdBSugQCgTJzRuVVLiyckVtnZHSdW8QBOzTz/BBrRL3tgxets3b9hB2xdDIq/Q0ZKPRUsClP6eK7YEybx1+TxgJLKkwBEyn8lC6xtePjJYXrCPLVA1ruWQeaYg3Q/mVjnW00mjnH/8Sx3ljQEWvTzTOmPbpE9GBL066/dupCfkcbkyvNc6JWEDs0C5t0QPPYhB1V7FiR5nLBVFyWuGb+qcjphQY+oqJBnAhnMu+bbmBaSKxWExwgEp6EGmbDAyEs0wCa2q6BzbTLEsb7y
 aGdKA3fS
 P2u+kybdOYHi3NKds8rqPnQmdD6h6dGeh8lCUuObVIapeqz8Lr85epJsc6qXsGckElCfwBkJLAZxlWsodDcitZ0hpk7EWk/MIson6esPqEK/RPY0QqEMRSKEUcKlIh5HOoj0mqN7vXzBU1a3BEyB6fJEzD5ALaIQppiknmIrAwdb1xWPtuF0ab5X8sCBzPedcsLoBg9LvHFYOYWn568Ukoq8VM7iGY7Sc6SOh1Y47OvB5BGeF/u+WlOcMgZlaO1498SrOBDGwVyrcb76pG9xPlPO9/kGzR2MWCHCF1d47jeXb5J6Jp3tqJNzEKnq7VKyt+GcO/Ya0vGqq3Orle1AopZdjFwVIsUC0AdTi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 08:06:35PM +0000, David Matlack wrote:
> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Inheriting ACS flags avoids changing routing rules while memory
> transactions are in flight from preserved devices. This is also strictly
> necessary to ensure that IOMMU group assignments do not change during or
> after Live Update.
> 
> The adopted controls are recorded by the pci_save_state() call in
> pci_bus_add_device(), which runs before drivers bind, so they are
> automatically reapplied by pci_restore_state() if the device is reset.
> If that save buffer could not be allocated there is nowhere to record
> the adopted controls, and they would be silently lost by the first
> reset. Program ACS from scratch in that case, which is a better outcome
> than leaving ACS disabled.
> 
> To simplify ACS inheritance, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

