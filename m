Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D258AC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71996B0096; Fri, 18 Sep 2026 16:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D21C66B00A0; Fri, 18 Sep 2026 16:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F2D6B00A1; Fri, 18 Sep 2026 16:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A71EE6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:15:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE1E3C06B4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:31 +0000 (UTC)
X-FDA: 85227988062.20.B430E53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3E16210000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGWq4Z8J;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762530;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InHfte711M8GWjBqV1si8bv5IIZHkN2SnYlxIl1Cx7o=;
	b=mGt2m4i/RTTXwPhnuD5aIpx+7WIAm8s6M8VghqmQNd0VIsqVbI5afjL7cz1PunDSlWAnpw
	5qw7MeY1/FFWYVfge7ioEqk0JEYj6QwBCgyX1cARXLM18b+82/Ore2LjUvMw4ZSOkqLrZa
	2s9sysnLFkRga3p/KatKu6mfDcLqrDI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762530;
	b=yIINsv0KdVS9/fnavMxY9z9xyb3b80kcK5AWdwQHWE5HL2hfnzNNhH6g6K5uGVkoAjF9XD
	RBc0Fb17b/RsXsy7OJE3cv/9x+GPtyO8aSmeqAaOMzB8UXqZkaw3YIKNU5lqk5udgoR4cn
	liJouDNLClgO2JAEcX3nCoYv5UNVFlo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGWq4Z8J;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1C4D602CC;
	Fri, 18 Sep 2026 20:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AEA1F000FF;
	Fri, 18 Sep 2026 20:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762529;
	bh=InHfte711M8GWjBqV1si8bv5IIZHkN2SnYlxIl1Cx7o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DGWq4Z8JIom2PSUBkh/EdMZIVDCCXYBM5UAkjo5ZctKxb/oTXclDf7lE4G5qGvanR
	 /seeSAzwKF+/GbobcB7qjEPxRcBPDNZUtdo7qo2Ujl5LYFG5HLUE32ss3ITpM5L9a1
	 1jons1f2KLhHlieiUlBapS9kly4rU3gDNWzYLRyAfZ2LAeKxxqjET+fV8mY/4bx4Tm
	 6q/3KM6sJlbE3qec2mMfH68MXMY4rVEmA/OWGmc5QOynTmO0FKYYzUyb8KjkRjgCYc
	 wTI2W4XlokzHkgzzhpQb6m4+BN2cSIRaQI6Czxh694MwqEBCUB+okYa9sdkCFDxnzk
	 l7eE5QrTxx1bw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 01/13] PCI: liveupdate: Set up FLB handler for the
 PCI core
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, "David
 Matlack" <dmatlack@google.com>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>, "Mike Rapoport" <rppt@kernel.org>, "Pranjal
 Shrivastava" <praan@google.com>, "Josh Hilke" <jrhilke@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Parav
 Pandit" <parav@nvidia.com>, "Vipin Sharma" <vipinsh@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Chris Li" <chrisl@kernel.org>, "Alexander
 Graf" <graf@amazon.com>, "William Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>, kexec@lists.infradead.org, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Alex
 Williamson" <alex@shazbot.org>, "Lukas Wunner" <lukas@wunner.de>, linux-pci@vger.kernel.org, "David
 Rientjes" <rientjes@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Saeed
 Mahameed" <saeedm@nvidia.com>
In-Reply-To: <20260918200640.887030-2-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-2-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:15:27 +0000
Message-Id: <20260918201528.29AEA1F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gikyunh3thwi8y7snzi1j4ffk7ejnttm
X-Rspamd-Queue-Id: 3E16210000C
X-HE-Tag: 1789762530-408132
X-HE-Meta: U2FsdGVkX1+ERfHrLIYpiq5I/2i+rLUtVDTubBGn9Jk+ZtG8CpIh6sTLaBt3+HcVnfTxbabGjfWIgWTe/Xs80d88uwYidQ/B4DSyxHJZDdp6bFl8z03qChYiAjk4Hc/hHw/n/GzR0SaBz1kQ5KHrrX2SZxJ3w9+/mt8ctjYRM6UCyhk9+itSAugsRHcIAV38DqawVAPtFpLKhSYO+uw0uxNX+r4agdhKATNk6a/8jEqlVgsmE5Vay32qIVXTofil9V4HPvpOFvvRzF7sZN8ZrU9dNGeZXyEIWieHjOVtWF2P92kM5dy/bWo6qMUZbVFyoGqb6KYQZrnqDJszV2bNOvymaITPe/282iNvqvcB84ehS29HEIwIcIOYBCx0rWByLzSMwdln8JFn3UKpSJOLDafEPgPJbA6+j34ZGZT1FlN1LaRXo3Z1jItN3kL4uUeFXXOc2A96NLoZ3dmuMulahCWvWQgL8xZ7llRaQzEJDWdGBUMU5fWaN3CTG8YAx/v/q4i40js1c9lDub1wf9pbCxQAn+7UZ+TK6BVxNdfVPL9hjEcgJJ5MbO5oW9APFdZBG1B4d/VLEKU005flmWTpLnTniAgpAXVaanWoIczllNVPJKDMO1UfOWuRhkRQv57oQTywZLEJUSw5vAWGZriovJCt4Ms+BzWYEpc0urQDH7eQzVGojIplLKzEzuOWs2oNHMkqn6QWPpe37ovGTo26hcQNiDdnDw4w624w9Jg1JzPN8fBnqCNt5jp3Dw5y9WSUYFaocu3rOi6wWvn4Tw/9LG+sc3KpUm+5djYj0Lyuf+BFxgXPz4zM4q7WwntaNmYsvmHA2eoiKKo2bUy7ACd65B14QAR0ez9eHxzJ5H/UgcfFByvDszqqGDmzKUVoUopff22jsNmX4gMRUdHHRO0nCNcj8/7Vxithqe8yVQRC00JQHSMUctHGYMH02vvgEPxnbcB8L4df0oUeb6mePpj
 le808PM6
 H3ifrrOy+cFEFo9Zr5ZzR60KaKvZBkYpjV8fSP8SxCHxyZEYZKK4zDtBRHJRpoj/VWEI6JsUfN4UaZJvskopzFXXZlFk7ZbwhBEBnVVYyh54+za0o+SafBNrMU1g40qhDoDsXMlivH4hXlhFtr/NPQIsw/yff1gLY7geAYmLRybzjOzvC2oNfNzbT45VbyaN3sOAqQpXcH6gHPrHZ56qgPQexkIska9RdIv0tYSEVmg0fVcmzJi6sLv72VOWl1yoDly+zYk6sryrPXmT55z9PnBSJCLBKbiJJ4nElafmb5i2VjOauzJ+804zVk0ETFI7/BrlRGlwuOHpGucDTknwDGjMQtB9iE28RPQGM/6DPKRwm90HliBsOZRG+QmVhSlEGKhcUwVw2mWbZ/z/sTtC0ilsTBuW0KtVrPYCJFci9doIDd2x2pyk8BRl70yy6a/NU5xE+oWUACqfs+wAPMkMJ/cfQ/DDZDrPMI0lwZztAmIk9Z0eXvDZ5LPAqIBmzSGHixWCa39jea2GNLVxiuT9sHgJNTIpONYNldv9CIWWUILbxvdphQpvKGe0VqkocFQGFRcMqjX1BBoGRyZ6oftKkjRKZNv+NzgeFP+oB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Set up a File-Lifecycle-Bound (FLB) handler so that the PCI core can
> preserve its own state across a Live Update kexec.
>=20
> Preserving a PCI device across kexec requires preserving two independent
> sets of state:
>=20
>  - Driver state, e.g. everything vfio-pci needs so that userspace can
>    keep using the device in the new kernel. The driver preserves this
>    itself and the PCI core is not involved.
>=20
>  - PCI core state, e.g. which devices are preserved, so that the new
>    kernel knows not to disturb them while they are still running and
>    doing DMA. That is what this commit adds, serialized into struct
>    pci_ser.
>=20
> [ ... ]
> not be enabled and these routines would never run.
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D1


