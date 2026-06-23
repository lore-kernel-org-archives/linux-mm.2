Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F6FCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530F26B0093; Tue, 23 Jun 2026 06:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1426B0095; Tue, 23 Jun 2026 06:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421196B0096; Tue, 23 Jun 2026 06:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 105936B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:14:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88887A042B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:14:09 +0000 (UTC)
X-FDA: 84910767018.25.37E5EB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE981C0002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:14:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X66kPjuQ;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782209647;
	b=VMGgl2bck4xrqJ1wFZZc/u78RzAJ4Ga9vRW2wGvbA20EiBWQhCWekpILOUCW3s8RdcotTE
	AKB8uphUbwZ3mYU2ChTJvaV5x62FVJx7aiGjO9TYkuL1brjQT2cSmmwNxlkez1rO9JHW2V
	saVpOmf4fM+V9ONtq8NKFOkHyNelZw0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782209647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtWsU0XCFa6NKrktmgpHdHW3vqPrmoOAPGugptWf8XM=;
	b=69fFEE1uK7QW8ljL0zxToo807Cqdd3b/GP1+ramcFHlD/Cw3caTt3+uNaTStjqZ6n4s0hd
	fhkEICIYyc058hb0G2QJ/7TtXP0Y91bcOIfONnkRpqKII3MUkkiS5vOJc/k1PUGGJRjZ+X
	C7MATd8B0piAOIXIhp9IFbQzGFukp6E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X66kPjuQ;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D03601F5;
	Tue, 23 Jun 2026 10:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F6F1F000E9;
	Tue, 23 Jun 2026 10:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782209647;
	bh=vtWsU0XCFa6NKrktmgpHdHW3vqPrmoOAPGugptWf8XM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X66kPjuQL1R1Evqe/K6M8qW4WdJCnvx6fj+yPcVoh7NWgn9cEHItYoI1TPZEkZvz7
	 7WAu7DKUbySEK2bFo4XZd80xIqyNvaUhZygUXXw8YWkqGQRws/T6+zU2lsgZnpyi1u
	 qDCMjRhPjLZc0eeWFlcrZP88M+u0Rjx5UpwG3o3HKgtlRIwIWAk77QLnZ+1T/k9Xid
	 Sr8maVIGguXZEmOpaEGTJStKLscU4Kxrcn0r6kefREApyZY1Lexnz84GVu12t2BM9L
	 QnOhrNxACW+6JEjI3wUys7A+I/YUJgfbqevkqLjnNDwcQX8lyc0lN784NoIW4G++WP
	 Db1AUvK5XH8qg==
From: Christian Brauner <brauner@kernel.org>
To: jack@suse.cz, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
 linux-mm@kvack.org, Usama Arif <usama.arif@linux.dev>
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, 
 kernel-team@meta.com
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-Id: <20260623-drohbrief-messbar-gassen-43977ca126dd@brauner>
Date: Tue, 23 Jun 2026 12:14:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-8bbda
X-Developer-Signature: v=1; a=openpgp-sha256; l=921; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IWTrcRd2o7VKbxsUGEodjdVeBd/La1Mw6CSkzIMgVG0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRZxWTrRl8TS67ItLn9yN8k84/yyWjTsz9eOEyP0bi2S
 YFh0cU1HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5pcjI8P3d5t6/KZeTjVyn
 Zr+KiPjWzvuk+92Blc5z/u1gedL04jUjw6UQh7eJ3K2n/H9bxCpsL52zUCckz9ZgpteqzozJPnY
 FTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: jzf4gwqr8bpb8a5gp3asc9ijjhb5wi4y
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE981C0002
X-HE-Tag: 1782209647-157741
X-HE-Meta: U2FsdGVkX1+PNhF0Fj0E0SR36ia2m8jDVWT600PuB36kuoGvla2cXWt6Ph1dls18Brx14KiP+gFU5GfBF5084lDFZoGlDq+FreWEmciz/2960GfoUMUfBC5QhVZeCUPn/qJYjvRb6h6VDaGMXfS+H5JhqzBLCf/1AaIZ9S+JKuGrAY25FLE9+Y9fqV67ZdBxgzc21WwM0/CEGtuB8SZupxuHf0paOiozMdem75O2P/CBtciKyPtlxVdd5vtS/khJbVRFSVIVA01YtQCSOvDvUm6abZA/xom3lxz1gAuMA5ns0x8hppGx5XoNjug3sHfLJLEghw/qR/b1UTIcK4VN1zyzvDJPtKX/pmbw2Datt1xx+eJN+Ibv0KNycL2XXsY8C1wc6zcw+pz5mRy7wfFX1pBRYXMwXAcoYFF3QJlpHqPFhZ4McPa7CXgzTZMS+lp58pRkTxxEyFMI/n+r511A9k5uBPCRpnS27K7fb19NKg/EqNtUyIw5o1rZtGBoS98kQn7WBd/87w9qsdZOL3iMeacKkOJhFGxPZgeRQTEyDdmzKt/agHHvbQw75sxjUuHFMLeJGSpnQ7k26LUWEf5ppZCiMOQ/idDQWMrySrlhYscRfPwZNsI5Kjf5hio0swMO5rt1YQLyxk8Aeq4bJrdUulRx5TXj2nb+BYbrAK1S0UNN0KK8gkXen56+PdSG06yRvXGPrVPshz+qitMYA5f8cVhLkJnfp8M2TmImB05phSpkcLS6LUqSyHIqN9X2s6ozorrvIRG6U6LnoCjWGd5T9hkUysXlhQ8iOyxKkzNDTeug0SPSPWCHsGZ1xLXKdo4+BT2vXbe5dT6AZgXkEH1NXDrN8QW082/0Bw659qDL/6wRbpyI5HAiYy0DsDjFISQydiJx1UCkSqNB1h03JqXvf4FfD1C5VIRcjpSR95LJUAKOntiNH2GRPEV08gkSyENWv63KW5fFYCu+pxB91Hb
 lcKyPokL
 hc/TnhYld/6EC4+YuNsp0M6oQew8FwiS/fy41LH0y6Ojlv47fOJbfgpURRBrUE2qVtDdiW12/oqJLn4EH9duvipxkRJXH6lJySIz5caKXuOIxlf9GcTbNAJuMM+AZ/V/U5wwkLEQpailELnOSoHH1ylik+KpdOomUY4HcJ5cnvC4KumGZA6KFWDxf6wz9y3ZnflCzSWjf2lUcJrpBjpZODT5Z0B3mcsFIUardJ2ejuz6wMmjA4iJuVz+dY7asi2RjwlLbsQI9O5TxEn6Hv9CYtitRPKRnKYi6LqCtfa+IQl35a/JLjJaKWzrIH+Ctq1aA1ZKJ0ViJARIVAqQ/0zooc1dr/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 09 Jun 2026 05:30:47 -0700, Usama Arif wrote:
> fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/1] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
      https://git.kernel.org/vfs/vfs/c/5eacee52be6b


