Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FDD6D0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92ECE6B002C; Tue, 25 Nov 2025 12:32:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFA66B0096; Tue, 25 Nov 2025 12:32:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A72A6B0098; Tue, 25 Nov 2025 12:32:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 637426B002C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:32:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 019FC1305BF
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:32:08 +0000 (UTC)
X-FDA: 84149822778.20.2930935
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FC79C0014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:32:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWQdZwpv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764091927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kn3jPA/ciMnYR3bmUtnq7yBB6O7ppU3j7RGZEkUzueg=;
	b=cn28cy8NbpKflm4panVnt4wXpt3WzZlOBw2lqPM6ClFbRhWfoQOtLX7MppzX6GaQd5qFV0
	hhu9cDGajgtex3YFXp5yMVPJZRCYafiqmY6f2Ths+Vx9Vb9w9EzBU0zjHHTcq6eouN1Oi5
	/iHZQhwXmNe/cLSp9XMDz3GZ9HxK52s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWQdZwpv;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764091927; a=rsa-sha256;
	cv=none;
	b=7KGhOCMH3OXz45PZU4EKT+4KaxPLivVd/wrM9PN0YjyRpIvXWtCaXiSVlgeifnxn7+4grb
	EL5L6XytdVADYpp+8UDBGMm632cA5gWqsoN4OD6iIjfQ28Mi7B5ppz99YcAc31fCk0YwEZ
	q4g4wxD5sKArvAKXInrtAVFNcZG79m8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98B8860148;
	Tue, 25 Nov 2025 17:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C63C4CEF1;
	Tue, 25 Nov 2025 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764091926;
	bh=kP5/fJWMNMSXZ8ed7AiowQq4T3kL7YPPysXPzM8izAc=;
	h=From:To:Cc:Subject:Date:From;
	b=tWQdZwpv2T9LybEYr137pGMQYAxNBeR7X6/GaTeoduZ+wp3MjEui2c0YRn/v/cw1s
	 WCE7etHIqF7xzVkrxDO186udB2bYNOHf+DOI8BwSwYlm1+5D8PfuNMS2bp4PH/akVm
	 vWNQ8wzIZMxky1DlLTwiwlmLcCfhHOPcmt71RV9ILaMGy3mjKHfwwlV3MAlmyvnoo3
	 BpALf/X37sv/3hWrBAtSMtKQbkkF9ofLOG1yVQl7oAx639f91/I10u5qlK8L/TUfrR
	 +6ErejF14+svTg/LugLE6izbpxRjkrzSrKqw8kdXoLUAz1wluQZ++wk9Jf8v44LCzw
	 fpAogXg2hNrig==
From: Pratyush Yadav <pratyush@kernel.org>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	linux-mtd@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mailmap: update Pratyush Yadav's email address
Date: Tue, 25 Nov 2025 18:31:49 +0100
Message-ID: <20251125173151.29430-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6FC79C0014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q7xz319ukkpcbj4jx19e5htbkssfnxqx
X-HE-Tag: 1764091927-281185
X-HE-Meta: U2FsdGVkX18yvxyqhvN8FYHgwkolLNs7jJLY2nP3bZiKyNAeWqk3vbyC1f2bijAlB+sO1a828KvZMhnN86EoiF3kZNMsDv2+jxyMBMVpQOp7ZpCZlykXf31uEdO1Ew8V8mYEE7WBwUgMveO0OIfanzQn2skznaAo7Z7+YGQRpISj4VVDe7roSbSmYgJBMqG4/qRCw0zwPId0Mj5WN/WpPm5ANSyxAkr+9l2vAkzPOgFoNi1fFY8zg+RPu/nrK5NXw3BPFYNvwfXCEFdEdDhB6Owq+csGCpVEAGTouKkdbL4llz4h00Bku9bAFtLkVmH3o6D2GFKPYO5wDrtQIW6BQ1B5mZmfx8Zo0ZzuXluHGi0/HzcH9fHHF0OeF3YTop7W/mnBwhy2T87cw+kwyUpBH1pchScMI5BHgbUuw94DvdxHCA+oekvAtL0Yl7Km6uU4Cuir5vsQ48iAyU08psJQ6lkcrtBGvNdM/wn0iv4K9va2KowSPLyxMiwYCBBgMPaMboC9x3p+oKdOWzFUHlatWDmdt1ia19RwfV91tJEuRra4o9eGqzIHZK+a9Air3F98bVQSffogQuxYOI2w80RMqckCSaJEfCqyv/BoVKSjhgP4HEoa0OK5edgSI14uOVXYSAyN+3oymHRO1oWZ0DHxqOQ90teUR8xIhX6SSL4uxWDkbVxBdkG0XsQDaUubrvUR8uoZR/MKqP3Be6taVttxecdQdTXLTB5Z+XlaT2dB1V2HiWm9RSSNwNJDyduFwiHIKtPCWr6GvMbq7+E5z/Qt6PgoCWWg4Q4IfCQ08/ct78pVZ8MXd5RIevFqI5fe2CgaC/x9MXvdUv6HsZYWJosztpcFFq1ee/ZVpCFmkpkus49sDAq+3/owpaX47fMCC2A8Jf0xz3DmiBZ7EYdG8cIKG4PC5dtcovlTQrrvbPe+5FgAnZmGDv52Nt8NTbCOADmjQqMw9LJtu3JJjzAUvdk
 vu9Z6wHI
 YDkGOWiZ1jQ+e0rD1S3ndP56N9ozrT9XtrT7XCdDO6x47XVlNZ1uZQmczG6FBhh6qTEdnFz90jtfziJLHTQNuxU4qp/5Rr+jPKkoophfXS7BN5U/eowVLgKDWvvWHnxR0m7FbugdV4Ueb30u7sXjZLfAwRuvkhvo86sN/9T66Wcruh8s60ynsDEekwo1JJ89n2TdftgHwxYC5kvosgd7cmIPBN9w2h13yjEzGXEezae3QVIktt9l7iEZgeKvjytCgDPGy8AfFcsbsLh8mxtRYQWKGDQYebPS1D1ispt4Lg43EN01mg+3QkIHPUtWX6iHA3Pe+Huh7ARMXnKgujOouL21KBnpmZ8EwtM0os/wkUTeuPFoDFAIgODr+xlt2IwuMnW5CD5sHnkA9rdSzoOr6kGHGV3qoWWeTjG2c3fZ5HIh2gx+EM80saIuG3oEghwpf/YJ2Dt9C27HXa/9ZcT3cMe6LMV6G9XDQ6ei/MuyvU7Q89qHa/EEySmdBWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I will stop having access to my Amazon email soon. Map it to my kernel
email.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---

Notes:
    Sending this patch to linux-mtd@ and linux-mm@ since those two are the
    lists I am most active on.
    
    I plan to take this patch through my SPI NOR tree [0]. Miquel, let me
    know if you have any concerns with that.
    
    [0] https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git/log/?h=spi-nor/next

 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index d2edd256b19d6..cf42344098ffe 100644
--- a/.mailmap
+++ b/.mailmap
@@ -632,6 +632,7 @@ Peter Oruba <peter.oruba@amd.com>
 Peter Oruba <peter@oruba.de>
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev> <pierre-louis.bossart@linux.intel.com>
 Pratyush Anand <pratyush.anand@gmail.com> <pratyush.anand@st.com>
+Pratyush Yadav <pratyush@kernel.org> <ptyadav@amazon.de>
 Praveen BP <praveenbp@ti.com>
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com> <pradeepc@codeaurora.org>
 Prasad Sodagudi <quic_psodagud@quicinc.com> <psodagud@codeaurora.org>
-- 
2.47.3


