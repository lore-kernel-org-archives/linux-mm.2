Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1181BCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67EF08E0005; Wed, 10 Sep 2025 07:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655EB8E0002; Wed, 10 Sep 2025 07:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BC48E0005; Wed, 10 Sep 2025 07:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43D968E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:35:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1494F11AF83
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:35:04 +0000 (UTC)
X-FDA: 83873134128.01.264306E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 44C7A40010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:35:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6EAhwVv;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757504102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9mpz3dJbi97XY1CypNN3jQsgYg7mq2IQ+J4IlijJkQ=;
	b=q0qD2zaFKNbHSB46KziT669ViycDXBb91dDkS//e8g/Fev6A56m/cEvFq3kKKrcHF9zYEj
	c36R6mMB/Gq0MOaNTP+Hmjs4nW6jeeTH2ZsVJWnxWgDJil/Iqp9wDx1aaZtXiurLjiaCzX
	7DBoX7qOw+TJ4VtkLxD64Fq4SNkSrn8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6EAhwVv;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757504102; a=rsa-sha256;
	cv=none;
	b=8YOf9kcB2RRNuU34e1h/T40ZWRp6Ek9yVTA/1SQnJdrYeMHRUq15ihu4Pqqn+lEcNbhz15
	7K8cp+jQDmXyktUAhglHgLhpjV2Az6W/Lo2oYFLWLvwFe4h0K7SA+PvH19GJIDqnn0+95b
	HT1QJ7kj+1BVuFnUyzf50pkfenyIidU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C8B2601A8;
	Wed, 10 Sep 2025 11:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BC9C4CEF0;
	Wed, 10 Sep 2025 11:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757504101;
	bh=kU9kFtvBjsff4usmmQcCzQXCY9QyVt8jE4w3Fq1s4sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q6EAhwVv4/GUyd1hLtQcyOBX4yrK3MOWP5yViR/h+8yIgrM+JWbKaDFvKX3L7x7vZ
	 w7gk9hqkIDXf8LmUBE1tPu1/kWb8/p48pk7q1jDHZbowg28RN5Vpv+286v2TH1k7lB
	 SABMU1QFshIHmPQivGdND/qrwKgUIvG7/eg/HvPfn7cickVNd5j3X9FS+BDhorIK4s
	 ueE4HXjG5ZFirVgbG+ThrmlAdoHjgkJxuvc9Eox1F+lJseQ4QFpc4s+FYybdNC/cd7
	 dDSutunjO49Ri5TWxnKUEyhfA7QdnItyGUmUe2DRRzNxt5m+QhB8G/EGZ7s59tSjqq
	 RAaIr/lhBDxMw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E0496F40066;
	Wed, 10 Sep 2025 07:34:59 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 10 Sep 2025 07:34:59 -0400
X-ME-Sender: <xms:Y2LBaOYv7N3HrUyjdepbfcNY_PrPr8KlJx6szQCXuunSqKHVGbZgrw>
    <xme:Y2LBaH8SR2Ih5lSHJ5v1Sdq3fl7Q9L6q_XeOogEXelhlyb5AVPlvS-ZsR6PS5UYJ7
    uPAyq1hyZSPtML4wHY>
X-ME-Received: <xmr:Y2LBaKpX2PbJsDSEIuRSk7dwjO8GeXrHkCNLqG8nRZW2IJ8wB3VWa3S3tj7ufw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfedukecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhheevkedujeevgfelfedtvdetvdevgfeuhfevieehleduleefuedthffhkeehgfen
    ucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouh
    hnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhm
    pdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpd
    hrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphht
    thhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgtphht
    thhopehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtoheplhhinhhugidqmhhmse
    hkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:Y2LBaKFhh2dBGM_Z4kk08QRuX4tMTUHU-uvNNChqRryGMsaejSmYRQ>
    <xmx:Y2LBaKlvfXkLFPE2uScyXTwiyixiQAtGaJo-Zx9o1xPH6vTMsTwecQ>
    <xmx:Y2LBaG9V5QQpRF7SJLHzMGFcK7LY0jvKrYpB50V7IGx0akFFXYDcmw>
    <xmx:Y2LBaLnxjKGxXiKzWCA1uVNqoCo6buvT6-pDV_lgl9KgmGE0T_2kYw>
    <xmx:Y2LBaElqB-KNOS0YrvWs7jLQtNH__65Z08zytovCnEYvAH8EzYEZbKtf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Sep 2025 07:34:59 -0400 (EDT)
Date: Wed, 10 Sep 2025 12:34:57 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Cc: Usama Arif <usamaarif642@gmail.com>
Subject: [ANNOUNCE] mm-tools: Random tools MM-related tools
Message-ID: <3btncmnggzmtedj5cpzcqb4zzmef4hvyfuvajtcjykmgqiv5mp@x5jfs76gxidc>
References: <20250904175729.1029735-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
X-Rspamd-Queue-Id: 44C7A40010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: txzdme9ddu9zy6yunrb95865654bowsc
X-HE-Tag: 1757504102-446990
X-HE-Meta: U2FsdGVkX1+ZHL2w2S3p6uTNsiwakURw8/xBw5vO1aENSz4KBE9xGuM877oO1WkbNSBRpfA73fMOVp3gsteQne80sCrto/q5rN3IjObxDlwMdJKSKeDzNWzmL/nzMRZKU2fLLlnp532J1fnYDXQfKr0Mf6twIEo3tgPeX+e52ryRqXWxl7IZ53ssY1GQeWyJe5xDtvHiqWB/dgmDvDoSYab3frPs+xXMDoMh2rbxQ/uP75SmrjENMDXbcJ7TCbCjFeIKdSOVAU9rYHhWvlj0tsU1LeP72nwZXkSktetI/mJ6Foxk3sWFPvP9lNIwmdcUVqrCgIaxRyQjbi9x3IXS4KszTah21nk9yXCu+HFdpYIHcnU1iVg6K91/QwSt/r2gAXIeExGpYAsxfwUoUcduLxKSufMFMMfGvrw1nT/fQ82gb6BJWA7pQyxQG0pRTMopp6kX3GJyfNqIY3lGceCGqhRv39mlhNxVsGkO5q8DAxGI0Svr9f0rWxZb/BMZ2vrnzDdAw9U1KZbQaxA8kX1bBOFjnNLy+GnPA+LgQ2Ym86eX0Y1QxUtlrx3LoBqt+4/nraY6PCH7nh5bkynUq5UR60P2/kFnkzm6Dueq7Aa2LeTtVSkyVt1mDx2ZpCSq2mz96pvOa2ySW+Fd1iR1Ec/sK8d5KSQPDN4FIUqA2q1YXLzva/3g3MntdRnS9x5p0Duow+8/2RNKsD6VbatZcePPDXxAyvgA2vN2iIpFT/4dKRaAveNyaIUcYnQYP8QBYoFXi/wPOfQsq1HvsbmqjnDmSGyNvSdG2q87hJUPobI2+Ga4OSuqE4azaL0gkF4q/TbWnvyFfwb2MfptVAAcT99aN18Etxc9ru8PlNnL53newkqwtFYEm2+d873uv2Eq8DiB9k0CWqYin5xMONRsHwHjf2Eiwy6x4ufBLZq9IPPXGjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 06:57:29PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a simple tool that allows to issue an advice on a process or a file.

JFYI, I split it into two tools: one for PID and one for FILE.

Pushed here:

https://github.com/kiryl/mm-tools

If you want to put anything else there, let me know.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

