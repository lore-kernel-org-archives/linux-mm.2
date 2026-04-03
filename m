Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337E0E7E378
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 11:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F836B0005; Fri,  3 Apr 2026 07:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6092D6B0089; Fri,  3 Apr 2026 07:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7B66B008A; Fri,  3 Apr 2026 07:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6576B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 07:33:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B95E114059D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:33:31 +0000 (UTC)
X-FDA: 84617034222.18.7975076
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3304C20011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 11:33:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pmfS6Fen;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775216010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/arDm3ImxeL0GvbAOnjBuF0Adz5BzOJKD+OUyROEO8=;
	b=ax03DbwXjLZd3OC8U4aJiC+LZxyVX7czOX7gneDc8XafbvV4ECOXr03E6tfjIt0DPJNqQY
	5gL7yQXkTlaIhhT1NQbQCID+g3OYEAe4aEPVDTx7TJVV65MvN6X/7CC2CE8NGFr/EERmDH
	qNmJkqLDpwA+61X2JmzeggmY1a+hnHg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pmfS6Fen;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775216010; a=rsa-sha256;
	cv=none;
	b=uySuE1bDYGD1L0n3EVko3p8fZ9YXHX6ODQRtpNEcGfEGqSiRJElLBFQSxblK23HKXbv17I
	aXIC1ALRKW0QVyri/kV7qb2Qurm7568qypwlx0kqZIrSKQSTnhV7gDp7FLhdYHcmC64SBg
	/psynW+M8wFaG8xEc85usIrRLwT4enU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB4D060008;
	Fri,  3 Apr 2026 11:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072BCC4CEF7;
	Fri,  3 Apr 2026 11:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775216009;
	bh=MOa8QwYDPq/SXAl8Xjaj96vm9q5sOGqWl/i71Rc47Ws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=pmfS6FenCMhHu+Si513jQqk03iN3KcvNvCYMo67y5M0mrFTLalxKgbME/ljU6ovlb
	 4cNutnZddi1UerKpbU+o45vr24FFbHHvBZ1A//YyJmsmNqBA6rK3Ek9enZotqQf0RR
	 mXUl18KPqbVW8SVLA2xHexUsP0P0hai+Ba7TgxuzSdBfyAPNVLcJTNEGaxwa7pM8av
	 14DnyjU42GpelIzK4Rzm/7jmlRHR+p1MLWixJaKdrzPeRPfaTmYB1ECRJl06Pm+t04
	 WXmRtYUTJx2XWtqW8nlPS2Tw9B3FXPLaekVl3E1nkrxuASZBdyYCebpTKIycNV/Ebz
	 1S4CVPs2TTXDw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usama.arif@linux.dev,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com, Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH v9 0/6] kho: history: track previous kernel version and
 kexec boot count
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org> (Breno Leitao's
	message of "Mon, 16 Mar 2026 04:54:30 -0700")
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
Date: Fri, 03 Apr 2026 11:33:25 +0000
Message-ID: <2vxzeckwcm7u.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3304C20011
X-Stat-Signature: xpm41a9ericwymn36f3h3q5rtrsup33e
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775216010-715319
X-HE-Meta: U2FsdGVkX1+sI5Q9QeumBNkBVn2H2OdoYJsHHHUzM39VsIL6TvV+3AYI0ZLlDy7Q6876UxCT3v5jdG++ky29Q7vnw+37nhJmPwW4IqTf9b3e2AMBeB5SbHVyPWakexBq8dRGJmZ74DRuLYNJllSAA9dpnp+MYqosU3fLkSOylzrTt1kLBp0bWhm1zF5l+/Zv74hOPaeAf0QUo7L39v5Iqp4MtM2qbSN++GorkN+3DKrqs3iXE/JHVdbC4LtKQosFyDiMYoxkP5zuyogJUoCaZYdt41x3X0uEPvEkBfaBGQD7KG3FPkXowUK+bZbTne4vqFe1xQmPM2b1zXTU539FFrSDf4uRYC78rb9PZg5GQ038YtzVdMSjGOEFxcDNdPqgyIBJj8JZlaOVkC6zjXhiMwuGK5r6qMdCBgsmzuVCi40hBnfIGWDU/kY60X8d+F1/PUIj6UZFSPdeHfv39Ut3yOKbMX8kaIoTjeZGOpJ2Q0LxXHjEt5T0sP1ZMNraseB46blClEDFnvoPImKAqx3ANjODzHZFOYtwF0sE7utn+4VeglhONXq7J3LwyqByHpASyfEhbjX+nxXzWFotsXlc88467Bg+jzarE4r7/ssHWBunAc6EetEHNsOlyuxjimm0RIfJWR+9a7kjKMo8bhpW0S9m2mBd0bq7CnLLtyX4to6vKYkXpb4jshZY4GS+/vwgRG830fzPtM7814uksCNDAPFYfPD3/L2orUnxNwbt2CsgTcNLyFDA4dRrQawQaHlfu68yKqi62vLP8bRFlUCroBYckpFeBEk+rI7wE5CE9yABfH/DrMKWvKXR3IoMU1dCJPvlFU5IiFjkcRgjH1HarfnihkwGOIXEMH6fmiQ+1pxdpqNWYmpD6RJ3AGuX+TR/Bca1A9P2AG7AGlT5CL7hk2wy3C6mL+zIpbRjfobUcCig5wmk2kByMNHbVBWP9XRavq9Fyj5yIVPuUFH08xe
 /k19F6wG
 etif2/Q7qK9eyJazrOQ1X+kCqw9yKErVQZ6obZud2negfLDrw6hXsqPXOyF3RZ+ZswZp+F0XzXBnQyPmwqplMhi3LpS3Wd8OPoaX/pFPz3nMASr+gh0nX5odzv/uf8Heoq7ZeqHjVLSkt9syKl1qFJ1WMckLCl0WMtezM5J13nKjI/w8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Mon, Mar 16 2026, Breno Leitao wrote:

> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.

This series is good to go I think. Please include it in the content for
the next merge window.

[...]

-- 
Regards,
Pratyush Yadav

