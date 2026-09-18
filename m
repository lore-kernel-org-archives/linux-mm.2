Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE994C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED9316B008C; Fri, 18 Sep 2026 16:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E896D6B009F; Fri, 18 Sep 2026 16:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D788F6B00A6; Fri, 18 Sep 2026 16:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B69086B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:19:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8AA6A5F0B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:19:30 +0000 (UTC)
X-FDA: 85227998100.29.697B12E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 054B118000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:19:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9mBKbI2;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762769;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/IMZi7laPDns0FaC9FTXouqX/JlqimdYvbBnru5FUE=;
	b=14TXNmZXoB/EPE9v8Gn7EOEoQtgjey6mHLlBSDQGW6esgkXQg59mB3ynv+CclllFOasgVw
	kj1GV+35t4I9YQZmnsF6DMHV9WACfEhcwOAzi96PEEqt52oI1bRYLWncIHpZnMZKUmvgen
	HecMUXfVD7ysaGJ7SB76u8Tl2djXj3k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9mBKbI2;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762769;
	b=e8XShgTcXM5Ssb4ln5rs3vypm8K07FLdI9ot/ZdJo3Hi3r1yXpLzjKCcnk1Vz3DPm4Zwqz
	TNA0zW02gYofq8d2kbBMJJygC/fkPalZaFXbiv3fF5kpSle+98sFaNOENsqO4tnXgMBl/v
	vABHdl8PAV8G6H6WotWqL2kudvH4EFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A070602CC;
	Fri, 18 Sep 2026 20:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A171F000FF;
	Fri, 18 Sep 2026 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762768;
	bh=1/IMZi7laPDns0FaC9FTXouqX/JlqimdYvbBnru5FUE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j9mBKbI2ruUGsdiORjKJXRAMUctal6GC2xh6t5MhA9SvK3NDBwBwl8I4JyL/0ye/z
	 9OEAVgB/L/WqfaE8kynPhemr1MuJO7enoO89rgbb3pvIpr55acD7B8fNsTO4j2F8v3
	 aHCYiGbWHT2iP5oDnCcZ8P6zn1n48MyjIoJ/NC9haWSbi7xdkST33Hsu+2UaAET1iy
	 mDp6FW2aVh68L9ahWiFizjOl120e9rfmVU4OHPZYJCCYtV9VEh02AfAZUH/w85mjEU
	 lpEwUrV5JjxGQYjT2ffoYT8c3LlWBKmPyhYilZqdEO7woOLZ66acluO2S8ENI5WpQt
	 xsPrTN8jLQ5LA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 11/13] PCI: liveupdate: Freeze preservation status
 during shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, "David
 Matlack" <dmatlack@google.com>
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, linux-pci@vger.kernel.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Lukas Wunner" <lukas@wunner.de>, "Parav Pandit" <parav@nvidia.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "William
 Tu" <witu@nvidia.com>, "Pranjal Shrivastava" <praan@google.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Alexander Graf" <graf@amazon.com>, kexec@lists.infradead.org, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Alex Williamson" <alex@shazbot.org>, "Josh
 Hilke" <jrhilke@google.com>, "Randy Dunlap" <rdunlap@infradead.org>, "Chris
 Li" <chrisl@kernel.org>, "Leon Romanovsky" <leonro@nvidia.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20260918200640.887030-12-dmatlack@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-12-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 20:19:26 +0000
Message-Id: <20260918201926.E4A171F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 054B118000C
X-Stat-Signature: dy9uscszasqrtjie9g4nz8ouetm8hxaw
X-Rspam-User: 
X-HE-Tag: 1789762768-38609
X-HE-Meta: U2FsdGVkX18QRsNzrApdzXpfe6HmNsD56ZGpPXEpjqnfPCWcKlKXdy/LA8SbVSpbT5NwFuLZrzKILp+GhDvMgNPWXbwZczD8MAyiNstTkrL0Oy4heYjuLcVXOCZk4IVPKBgoHMY/UyovpdU22IDydLoeS5aqA5uicHLfk2jmyX9IDS9S8AqO9oozfNc1KaAMnAzqJ2mTBKIDqHt8l7iY8+P60jqwVff2xzNs4qTKpWb+sNOCGJtNZWWL2zFzZPemJYMnJQ77q+m1QzrOQsNt3edElLFS541i9Siikm4/iI4lFav9jml10KNoNnlyWF1YG59Njp4xTQsVt1L5x7xmUEXQsUjndyY07P6mD3ZgPMxsPRBwsVlCiAW4b6VYixr6u9JlZGcxVaS5I8id8Z0HWiDOpc69SHZIodz5N2TmWk4VTYWztfjlo0fNyAZ+7m8HqRxDcJAn4cIrmbGwqbH8DrLXQZdCYE53XQWrbGD9VTzx0+hN+WSKqqLrZCxDQNhAwCJVu4yl4sOEezWTcOuIgZ0ECTVFstF/qe3QKew+lEHT+WWEHVnqgCyJk8BxFwfgefSCw8ZRzlIx2AM0RrVJD/uavk4D0NhfcXgCgdbyr1SgaUHcKE2poLb0/u3HeM2aqTdKTLH0sfLmol7pMZIXwS3bBwa7XtykISkdwiVBPQKNJ5oWrfjxfzidO7T+pCjeOM0O7xzq18rS+xTpZPqPJRAd/2Ryfw8RvdyOfMkz5KhJEdlPXuhf2caeCOk8YkL6vNs17plh5y49KEo6gFHAUILhQOXvf429ke9DCstVEF1N5iog4M4hPu6GeZoy7XZMY8XHbi1MQfQzE0qZHHdsGFE0ghFRzGTXfjvLk5teAbeELz62X0TkBelUSp2xdHztt5e5TV2oZjkSHwvk+lVzFKAo1TwAD/+qzABmNjtC89GAmLFUXoAq5WYUYPK08N2R4/K/N0F1unn3POVM2RO
 i9l0Js1i
 82vuTOx38UFcshswia5hxmddKwI8DuylLA6DEP7r/ZkG2fFPeYOO1KgQkzl+yCICWmmuDsqz34XPoS0rzwgQ2v9zvxg0SkaqrWwJgI2e9BBzg0sOJGvhnLned7ERX4aUQkZqs3tf18FZ61eFK7+ZsRD8bpoFpiTfUbaYvUb6sqNfLz8YHrfF+3+PCv5StyrkEynNuwc8jtWnPIFyd0OgMW7IyukfeAKLlmnBimsiqcVizI76YgToCCBtZw3hgVnnaiS5TCLyD0++R7gukfY5IBdfdXzjWZ3PzWE8Zny7/rE1TkXXGCJTeUiw/OBgHcHxETgu7HkaVkOudUUEI2xAtZvRBXfTypto7m0Nd8ctGbYLeKVv6+cAXBe1HuoaGifnQhf7ioZheXtDTYjCjiD6ICufnNPj8oAL5fCE2FsjO8lM8o7BM3WpEWdSVOWSEq2UPHmr5NU8vw9BbCHw+1RTls5R5wJnSHaj8h2TAghkSK99Gbgr7K6L+xINscfWFcUOEubJD9KsON4/DgBhhakowNcqToZALM5ynZzTzJ29bhHvkxFV6vlpZ8H3UGTtDDtcK8k7SUkXtSUh/A0gaojUtFesRzWXW15r5ThFhjCxE7dbK7pBwyxvaEeul07lWV3NBxPeDm2R9tKPQ4ptbO+XHSwmrsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Freeze a device's outgoing preservation status (preserved or not
> preserved) during shutdown. This enables the PCI core and drivers to
> safely make decisions based on the device's preservation status during
> shutdown.
>=20
> Note that pci_liveupdate_freeze() is triggered by the PCI core rather
> than from drivers participating in Live Update so that all devices can
> have their status frozen (i.e. prevent non-preserved devices from
> getting preserved late).
>=20
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918200640.8870=
30-1-dmatlack@google.com?part=3D11


