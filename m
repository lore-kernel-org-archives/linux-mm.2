Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33E4C982DF
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960F66B00A9; Fri, 18 Sep 2026 16:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938EA6B00AA; Fri, 18 Sep 2026 16:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E176B00AB; Fri, 18 Sep 2026 16:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DCEF6B00A9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:23:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E837D1C3068
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:23:15 +0000 (UTC)
X-FDA: 85228007550.14.EA02A7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5D20C80005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:23:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8EevRzh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8EevRzh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762994;
	b=tL9QB/UVbE84TcRlB7kWWf8AVMFuMetLLkJ0sMhWoPiKDoUBE18Z4vgBjUORf6KQzOJQD7
	PDcNz4oEOJTFq0jtHT3fNBZ0+eQh79TqtEWfxSHMW4DrI4S0MACsgZKkY+aZei0Tar7Fp0
	wHKqMEatXbqt1NOwnBFigl7C9bShoCM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762994;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFG6NMPPSuorbIlqU27dxScbJKZhV+vI/vVxbxtvQPs=;
	b=3vfapHCpD1Ru17c68854qKk0y9XDYPQMEO+ON6/8atMde67X+dS8vY2On8OQw3aLJZRtUV
	RmqGW2rCeY5Q3mGl28PLEaU7dHVu2YnWQ2DxvDBYvSyFQhkTOLRhwGcow9ia8z8jZzCMfx
	CLEe7ptPSrwiddftUEThtGyKkD0Kx08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFBBE602CC;
	Fri, 18 Sep 2026 20:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1483A1F00898;
	Fri, 18 Sep 2026 20:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762993;
	bh=aFG6NMPPSuorbIlqU27dxScbJKZhV+vI/vVxbxtvQPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J8EevRzhuZz4nJEgD7WdIubGd5xCkXjojQLV1YgZ45BionFAmz9HLZIbms7CHK15M
	 qGVgkpcsiBOXYX5pbbHphFQYd4YZHAYMdRBoWtpud2Ej7+nwVjI9o3h0YlB5hyhjQ1
	 lxdR3U7SIH3gvr8sECbSpAAwQnXc0JHgxljXo5u9i6vonpDVyEWs5Q5tgfIlqvzDBU
	 +vFA8B2g28agSSRUW9EKOQQsY34hXUyiFvh6fgdJOToPZIj++uRa/MFKgEZzCJJ7oa
	 KgqJTzLXtH+VzfrilkfgyCInD9Y6a71qJLA0scREO7NAMaageYRCdHCAdw3QbKVOSd
	 kEO2Gr9EfF6Zg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/13] PCI: liveupdate: Track outgoing preserved PCI
 devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org
Cc: "Saeed Mahameed" <saeedm@nvidia.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Leon Romanovsky" <leonro@nvidia.com>, "William
 Tu" <witu@nvidia.com>, "Shuah Khan" <skhan@linuxfoundation.org>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Alexander Graf" <graf@amazon.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Vipin
 Sharma" <vipinsh@google.com>, kexec@lists.infradead.org, "Parav Pandit" <parav@nvidia.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Lukas Wunner" <lukas@wunner.de>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Pranjal Shrivastava" <praan@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Josh
 Hilke" <jrhilke@google.com>, "Yi Liu" <yi.l.liu@intel.com>, "Alex
 Williamson" <alex@shazbot.org>, linux-pci@vger.kernel.org
In-Reply-To: <20260918200640.887030-3-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-3-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:23:11 +0000
Message-Id: <20260918202312.1483A1F00898@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D20C80005
X-Stat-Signature: s97b1sn4kajhgq7qhjhtmwtr399mbcaf
X-Rspamd-Server: rspam01
X-HE-Tag: 1789762994-134102
X-HE-Meta: U2FsdGVkX1/OB1I3EWG/5DFdMxBeExGUhyfR1HtIVN1bnVqZ+dTQeNT9VaMpTSLfeGq+EpOmSS7cZsuy+N+P8uZJFv0rCzYrPqQI1pXaEWIk9xXMsRNrkkRZR0HIZAVIhyYtPY5lUuLZEsHh2ctd4nzsFdw2zP4d/WssrHRCHLzewcmpcXa2Fo12kNQfNAVG6Qke8heoHlBXQZxtbPQCO2kCMadm0+nGwfpTpueKwxwmKAgdtOmm40wgSIiXk13gHbu6Vklm3oJ11mK9l0i5co+RrbuUr6yaNO9WmKNDTlSFwJZ8usXE1wuvFRfGmI7eDqQh+DDMS/GAducIgUyiQiDQooux/1JycOOG9YpWiWz78QShKMjyVUClAehEjsfxwq6w6SLOoivEuWn5PC5aIQVPPdQNjCmCX3my7tn6lsX9vGwa2k6NmzXpoo53TqnBAPQ3f8s8pMMAp6mKuQIrxJ2aALIOr3HxFSpC6k/5Pp42AKY6uUz+2ou8Fh0HmfaCcTYS1w7osuLcD9PWm+4EAUZdPW8Px6LSEhABQ3IS5gnoj5R3lZxYtPWY1UeZMb0FAZi8ipx0MhjWdStccs8Hg41kZjhgXt8w+woDDkHA6oNJ8V8Leb90riZpcu/W15K3LRpLAv4tOnieJHQLLQZIgehSqO138XR1mA0sRC+gEl/Z7fajKvooYC8geex0DS1zsk/EjZoIbhKCCeV+fNpIGoRGP4o/oLnY+Ge1ytemliXfd/cEuBdK7t/XeYRQVUgNJcRLKB16CTCH3xZI8X0ir8wrW+M0mwpbt+aTlL9Hl0JKWKLwxA6N4Z9cz56NHKxEwst6LL9ii/c0FwvGDyfe6Rq7BcI0WbEHzEMk8sy4Peft66L6Y6fKWe40bn9nOpDq1BanfcGg7OD3nWQar2HBJt+/n1mCD5P2kEC8CX9XTTWyu7kD7vr2SvoHbYP/5hUVs7ul5LcQhq379ZAvQJW
 ExxqlYal
 gBXvFAsVge2ovcpiHOAfIjhA39KIzvlKofMvjQ5wq2/1PhhOcLyGWUjpGWSLHwRQQnXOXhsOgUBFxmq1maDk2BfDVscTHJjNbwYK6iidM92PGSEbrxOm5qeccbJYgMrBBIJqNZmah80vaRNiP30X4lh0jwzpA43zfsK0w9pk+4nbKIZxMw6h+c5SJPBdMtYanGFnqc7uPGXal3ABPpKaOmgdHOKiM6OPCIuXXqB3BVzzEM5PiGccaHmXQR0XQxc+1z/KlSx1bg3tmlb5dNVZuSEjGrT7GyeNuERBv9WUPgYZZq+5JoWutwGVa6o/G8+kktrSkIxQ6tq9zhsQvPslvfUWNnF6S+HbtLfB4A4S1n5OXDnrMwOtXehkEzfBwFmQK6lz3YFR9ypFpfaZZh0aCWMcL46BM3eMygIJmga8ktDUMXcSMqueWQPh7sgop3ZKkghjDrgslP4N3PGzjzCaDoQ7K5a/8R1ZS1l7cGfh8tA6MjkvCOjMXL4AedwmGQt5EvEJZKs7iqQi3yutCFgTOCDLYTeoPGVYY3bjH4/ZTySX3STwcE+cgK19rct7ca1l2wAEBdvsI+xg09rKNE5mkvNN9Tf4GoSPyQvBN8aG+w6Tq/RxV1oj+0QsGUaSatWd8OeAfcz3hmjieYsneLx57+2H+Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add APIs to allow drivers to notify the PCI core of which devices are
> being preserved across a Live Update for the next kernel, i.e.
> "outgoing" devices.
>=20
> Drivers must notify the PCI core when devices are preserved so that the
> PCI core can update its FLB data (struct pci_ser) and track the list of
> outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
> device must be preserved across Live Update. pci_liveupdate_unpreserve()
> reverses this (cancels the preservation of the device).
>=20
> This tracking ensures the PCI core is fully aware of which devices may
> need special handling during shutdown and kexec, and so the list of
> preserved devices can be handed off to the next kernel.
>=20
> For now, the API only supports preserving non-VF devices on a root bus
> (not behind an PCI-to-PCI bridges).
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D2


