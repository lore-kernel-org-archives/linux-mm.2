Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E495D778AC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 19:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5E06B0543; Fri, 23 Jan 2026 14:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2A66B0544; Fri, 23 Jan 2026 14:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CBA46B0545; Fri, 23 Jan 2026 14:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76E836B0543
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:09:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A75F1AED06
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:09:13 +0000 (UTC)
X-FDA: 84364166586.15.1357AE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7E10A40010
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 19:09:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oxbkg5JS;
	spf=pass (imf17.hostedemail.com: domain of tycho@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tycho@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769195351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S2S0WlaV4vxb0aJ8f8js9z0LgDKD8OgU/6Ktc0cMHIg=;
	b=4Z9VCzH/bgC7DCC/clu8F6KjNa7V6LmoNj6+OK4DU5WYYWKg0FZibQ/JHvTaf7zY6t/Rd2
	MZ7IX0WfwMpcuTUA+c1PXTtBWZhz0ZF+3qZlcpxUUJsMxBMGyRfRuaPAT6MSfnxyPR48rO
	GQdCixVFpD2FWAYvHY7EhrJPbZiB13E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oxbkg5JS;
	spf=pass (imf17.hostedemail.com: domain of tycho@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tycho@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769195351; a=rsa-sha256;
	cv=none;
	b=XWJL4kQv9FRwkmVpjVrGkNG3RGC4HFEIyM3BMWRcr36bwv7h+u6tdgGjYPnCO3kl9KQE3U
	4+vvseSCuHZqX30gutQm+wg7grzGowAdm9Fs3XJWOjiMErH8VVGsXQi1fmRmcKQX98DLkJ
	gGiiIU0sWKd2Qe7TZvDFC94rRjx8riQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A01C43590;
	Fri, 23 Jan 2026 19:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E6AC116D0;
	Fri, 23 Jan 2026 19:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195350;
	bh=F+gMVw54pCVD3wiRysjyfpr+kXBpSogewadJH4cJlxw=;
	h=From:To:Cc:Subject:Date:From;
	b=Oxbkg5JSR7Js7ZkUqp86Towi+FnFS1jbUSlVzv1ReOaerdtWzEENi+05FvVEOJP6q
	 LfZHb/XgiXcGeJ0ImbiPd5pt59Rwb78AgxikDCPoaenR+ceh/hNNP/vdF0DU+d6++D
	 HxSgZWB5JSCZnJpYqYVlBVeiYuno9GxYQ54+rs/llNtJmTpKqSAgxQ3UvN2sP88FF/
	 QYC3XU6W68sGmNqLzt4Uf0g6tWRvxbhUjBXP1lfK7eooteNthGafncTFUo9/xRkhzF
	 Lj3Iu1hEMijTWoJi1A4iezrU54Pe/NZyg+VvxemPEV9t8/XAoM+GzdPjx5lEejIWHm
	 UQ0zGcMA2rsYA==
From: Tycho Andersen <tycho@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kho: fix doc for kho_restore_pages()
Date: Fri, 23 Jan 2026 12:05:06 -0700
Message-ID: <20260123190506.1058669-1-tycho@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E10A40010
X-Stat-Signature: 87b4ww8quis5ybpaywp6o1h5q6wy1tpe
X-Rspam-User: 
X-HE-Tag: 1769195351-13640
X-HE-Meta: U2FsdGVkX1+I3bjwpwfi3GRigbXqxQtXo5g+ODcp8Nsxp3XhaD7fsw7FUSgP4VXpY4/6mwPYnvJ2JIzgmkakKBs7m6IaJFwncBscUofKq/lB8GPCs5E4J0k60h41Hy5/MAKM1RXB1LBV7KHz56QdM2HTktOY5JE8NTw5P2CjS1xcaDULQ+AwCL5lKxv0u06dIZN4vYNJMMLWT0DxRMiFsMmVHeYD6MiEbAyT1XO4WejAoqft7wKxIuqDFZt+A7QUCkas29fXDdIb/ubbBF82zUNwkBqcc210U9lz+T8Rr8Bh6eQ75Gu+ohBAH+YaNmUaAEh2dZhI6guHo0ucsQoTem6cY/NWxN+7DHCra1uPlyipdZS2cIuWbT/8HJy4hezs1nyoN6+SQ5tbezwhwcBZ0sMPQBTPA2jLo5nHzud/5znMrrAzy7vQiUUvTlDiSNbI1Rkxf7ucufacMRlzvi1Op1h1Hooo37WzInNxIKalh7Cb1DDauYz27PX6kNNI/Z6FZMsmk/XoMQrle58LAM7z9iXdju/xSB8EeYKQj1FqYtk+GKtBOS5RuxRKRJTRX//6TI9OScT6OraRif7Qnij7A4e0l1a+7bWetgF8bxLheSs0CNKj0gY72mBV8pws8CsciFw4uwe7Dyh0pbn+G8w/nia8WLQy7VbRvKdJTa1l+xUi5qbA4QaMH2ow93om3kok+agqLAOlP/CR5rG5jm9gUZtt5yOGSYDdpLMsHGu5+OIluPg3HZApUrLE3wfABD/C8LEQDopd9yF3xWyR2ThiVAN/0K0woLluIPrkJZCoDJj8O714j4PD7Fh474qqekSyIxZ298b1MKGvF3mApw4tvYkij+fKjp67vnhLTuxqxZbaxSkRiH3U3NpJmuLRHibxKUkMGsSkpEBzy3DaU+YKrWRdj9aM9qEKe8h93yPAqpCysvVmerKYDA4Aw7sjaOOhBp6vO4jVVFj0rKdlu/J
 +EG0iAef
 AM56X+2h2ueCT7F8tstVoaMqgjJIvYh4nBwis72sy4xw/Dus1p/8zfCeiuAV5IMRJzu8jEnr6sVVZNGCRrPlg8hyg2NiTXhzB2bVoLh48pbPRGAtP+TqiQ0n4yqDuL63/HLgCThzC0vKAFtPygXuf98qbZKL7fHN9jev0Nl1JV9S4r5gTexgJ4E+9mlR+AnsYZJd8uE5XBrqSP18Bbwd/5p7Bjn6A678A8zXREidBoVO0y3FxBuSmOU+Pu19CwVMxyHctUqVSal7Vr3dfAkNdVzTDtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

This function returns NULL if kho_restore_page() returns NULL, which
happens in a couple of corner cases. It never returns an error code.

Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d4482b6e3cae..4c38ea7987c8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -281,7 +281,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
  * Restore a contiguous list of order 0 pages that was preserved with
  * kho_preserve_pages().
  *
- * Return: 0 on success, error code on failure
+ * Return: the first page on success, NULL on failure.
  */
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
 {

base-commit: c072629f05d7bca1148ab17690d7922a31423984
-- 
2.52.0


