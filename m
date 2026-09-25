Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09757C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220C66B008C; Fri, 25 Sep 2026 10:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F79E6B0092; Fri, 25 Sep 2026 10:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F636B0093; Fri, 25 Sep 2026 10:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E679B6B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:21:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 187D41406DA
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:21:05 +0000 (UTC)
X-FDA: 85252496490.29.85E9555
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4BA48140005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:21:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhfTnzgC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790346063;
	b=uUPxazjMbMnO4S0kQ7U9RDvSqS1OdYqp5pSKgE3uN3F6SJ22Sc0un9K6t8lLkkxvxu6QRC
	2n66NflRqhsBu2qQnEIM5ySKI06YcqmQOWyahliodzwfOtiWy+mu/FRInhvcVQE5LqOG7V
	kJopZ7sHwlX/HC2tJKyXywdwIJwR+do=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZhfTnzgC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790346063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8bbhgovMLJiV2/8MU9E7yMpXiD1DeJOffuWDMO7waQ=;
	b=bbiGECAXI4oyXU3zbeYwzCRO65zqJALGQ1s/XCny3JIEsEkaAc3c2qDezo17IyKEy5ayGi
	sBGeZVEc94ECQKuOoE62Yyx9hWr+Yr2bx0BsSyusmLGpVPioU6L4PCst6YYnpptdG3UJrE
	cHZyD2HDpsNg+neIlcQj2iu0m2tKyuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C331660136;
	Fri, 25 Sep 2026 14:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093321F000FF;
	Fri, 25 Sep 2026 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790346062;
	bh=Y8bbhgovMLJiV2/8MU9E7yMpXiD1DeJOffuWDMO7waQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZhfTnzgCuikPATdpnPcvJA7soMR0WYKkzTl0ydiV3QCy4RjCJIXMnlFYPl1xSnLpt
	 fN+/mBRdZI0neUlyQ6PD6eTRjNRgqH3xGz+9MvzcqejpS7zHUQ6VXOK95XjzZwaDU2
	 qwz6vip15hKyRFBj1BBz5laA7BojNd/IhjPBBHzhHdv8IenXO6A7W6PuDrGHcINDiJ
	 9kOaHB4fnQtULK5K+FboODTSrHuhVdvFxRK+CnVZjA9VwMLQA0/8NW2TNAmHJUZ8+a
	 dUf2YRRogQh95q4eqPn+dKUF38/d4xlgrvFv5Jbw2y5996Nu4423RX2Wb1Wi0XcJjA
	 pOIBwR39jNACA==
From: Christian Brauner <brauner@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 Karl Mehltretter <kmehltretter@gmail.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260912073250.51074-1-kmehltretter@gmail.com>
References: <20260912073250.51074-1-kmehltretter@gmail.com>
Subject: Re: [PATCH] docs/vfs: Fix the struct file_system_type copy
Message-Id: <20260925-sachlage-reinigen-auffressen-5bdd926d423f@brauner>
Date: Fri, 25 Sep 2026 16:20:56 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=881; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ipYU8e78ByEhWH/1W0gJkLC172mJp5qZEgqiCFKsZYs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRta/ZsXHOgtqwiafmuG4dq4uOblJfNvfK24cgpncW8N
 5OMzsg96ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIxSGG/6GCrQcmrpxXLJMv
 ItXJ8MeNXTSGU0lhgo7JUd5X77eEdTAyvLBbW/Dm+sZDnVo93x6s2u98fZLMvItN6zU3BeyViOi
 IZAQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: nr7dxwgn3tx36z68kopjxbog8ntahb6t
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BA48140005
X-HE-Tag: 1790346063-635320
X-HE-Meta: U2FsdGVkX1/fz5QzRr533ByhYpgVi/A9iTy5fALv3TNfrHn6wViCSRt6nM7kjgmkTWFTNouyKE6chQCLR1yZxcZUapgnfe+d3HnfQQv8sOPJION90sDTNLxPNcWcpMFgQDqZ4qu5zhhEhtJK3/2geLgBtvKk26206109q0bq5vyLxKkyCvWG/49u/sGxwbgj44OWUwJsPqlBwi/vM+pZHiUO1rnJQZTM8VAyFNeXeLyXVMo9Z2wKJf9cSRcJ9tCNedgKhibUptvwehVNMAGUyP6HE5upa2leRSdx+sZpEsKDWbSDNMbclwnfrtDAPV4uEuroKpJhGkj/wJmXMwAuwlbhzNDbVQgLEsWfE08rIypIPIMaoI9DKX0g0DJB+ifRWLYjnNSjx4z5ASPm1SHtw70ht5LI1S970PWi0J3KKuoC09QWjjMLNfYcFcRfhC22f9c/kv+ZgPUSB25iGfYzzOjcl7Nt+rJxIa+EZ2T70YdGEqeH3oCjLZZYQaEh9iUsER+uVJ6pi4aYzVtPfAYp7JmYjGKa70f5kbpfXSej7/7q64GhdvG7APs3r3vuNoh4ICoxqMgfJUfg1v8ZkfKXdZ9xwVc66EDEjgOrcjGp+n6WyjvV3xpAH8RI6I4rkePyOt0oi1vEVIvs9uHVjIvHd4kHfH/WTlx+U1BZmiiv749q8ajS7tVZ8HPVK37MzDkBuIA4rbFb10MiaiHuns6DSbZ4vrMfAfNJG4y/CrDVH/nO7+ydWR4JCPpzdaXD53unTB3MwXrLMT7FFPR7/8lyS6RUzx/lJGAWWXlLSn1mP5D0TZcEpupTkjLq0bZDCGbsNEeZ0TiuBRIC6+xsNp5p6KuJlgReHbkJH1VMB1W/ZR9ZTHZ2EmN7kgSXAY46BlnVg6R/1w3U7xFe9DzKo2DTD8npKAvA5siYRZTqCwbU4CoqODRTAfguMzCeOh67TJxJIeb3ooPACTA1Q4vnb05
 2/d4PrK4
 zAseDhsyXnRVTrBxnrJTw+hnPO16KKYboRfWlHRUyP5+M5l5jZTPH0hMNhNdMecgqXFCg5NO2y09c8N8meYLDSb0S3TzQ0ncUzjKAQRl4+iAxYuviDXw56SjdBEYKgQ+F+XFug/Rm7qe3jgS/BJ7qAMLeqPpNZalpKgRftY8yhtfdwwVtfe2k8S7UoCFzGivON+1gw4mfrFHqYDw8x4Sk0bkHQTLGOgVObGKR48ZzeBSUJxTMaTfa2cFFFtIZp44EwYXy5dPNYhFONO2yCZ7yLgAROahyPt5u6vKdcqKOx7ygk7s3ehEYTiHRRXKJmRoohUdhSKl0DlHosSzLhrnwrGK01w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 09:32:50 +0200, Karl Mehltretter wrote:
> docs/vfs: Fix the struct file_system_type copy

Applied to the vfs-7.4.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.misc

[1/1] docs/vfs: Fix the struct file_system_type copy
      https://git.kernel.org/vfs/vfs/c/392f5390d5d8


