Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468DFCD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 00:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34AC06B0005; Thu, 28 May 2026 20:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBE46B0088; Thu, 28 May 2026 20:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210F86B008A; Thu, 28 May 2026 20:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1079F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 20:25:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 990E9C37A2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:25:35 +0000 (UTC)
X-FDA: 84818563830.02.E56C2F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2EFF1A0003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 00:25:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MUm/5P+P";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780014334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnopgqY2bbWXtxWqNirNFrJ9L7lhAVtnRuP5BLUuwAM=;
	b=naQTpv5YHtoyXj7Snu0WqDHjaMFkeYbaFPLWSl6kX+4nQjMt3Aa7FNTNfq7JIwl22ICWps
	ZNX8AemxLVmYlTfQSCUvwmjy3HCHSvqqK3+gCe2mL8BVWRN/ayxgmu+uCBJfVMGIZI0VkR
	h0v4UbK+C2ypkL4yVbUHIcrrbIYRfuk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MUm/5P+P";
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780014334; a=rsa-sha256;
	cv=none;
	b=1lC315XS1XJHfnoypUz2RtdtI/NBUOX+EHuBf7/Mojr8M9x3prYe3OJ002rjc3KkZMPB3i
	KNsPAQC7Qi0D6h8yHxSdshOQNkz01KmsH06VykNDJhLLJOzTF6ZGa+pFW1D2JKVyaQ42JE
	qNCAXykpcKhfI5tDOd8UyyNpSxLAKzg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB757442A2;
	Fri, 29 May 2026 00:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5351F000E9;
	Fri, 29 May 2026 00:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780014332;
	bh=UnopgqY2bbWXtxWqNirNFrJ9L7lhAVtnRuP5BLUuwAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUm/5P+P1FGVS8gjdS/EZG4XyKjy/K/ptSQLrbbN+n3p9iTeoH8Si+nFU7MfOzsqH
	 pM5S7eKMDf4NLW3EUWdaiUA4yubAL73VHIyLgZGEZ35JB2gfHhiiNwbii8pfFNBkE0
	 BjSa2QAFk8nZzBGqYOFtEzFVhaBKUl5z3OjF5M4Kl0cGRixXqzyb/f5D6W/tg8bbL1
	 AVlHCNklDzafA9QqEPWNzZbi/FxnCxpaV0XGm+tztwpiqrRwkoeeZ/yyH28WGygqAZ
	 lXF05evKPOcW7wZOGpNLkPwFQDJ5QtV1+obDK+n6qFv5rHECTO5Jb4Bt4PzhVGs30b
	 hwtkt2TUPwJUQ==
From: SeongJae Park <sj@kernel.org>
To: Brian Masney <bmasney@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
Date: Thu, 28 May 2026 17:25:24 -0700
Message-ID: <20260529002525.7939-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bj3a1hcwo4cnom7f3isfjkufx7mgchaf
X-Rspamd-Queue-Id: F2EFF1A0003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780014333-484220
X-HE-Meta: U2FsdGVkX1/TMKDyZ2XLcpJMVUeWRVVp5hHMFqc9AgnjsiPZtJCl5v1JUyxWD3WtKOcW+3EaKFjERjMK6gOu8p+Bb0YL7lcooiRgDV5rXqcoYAyaMemN0NSDlrCPBuBzPYwbGL80ta8lbSv3FjoWeTaqoQ+oMn2VcJw5KQ6flTWjsXhzAUoPRrAPVLkTON9dOEFrRMIfYjSFQ22P6Zm3Jvv6eGXTLVcmaOhG4KbBKINpzBZqvTnH+5mMG9Aa0l/Ve8TYW7t2qUVrs8JmiBFf9XZ7MjE69BD1yBDofkkS19X7aOayO/cxKvG8fvGK5tEQnYSyaiMQ6b1hDhcqDlttXOLwNjaLG2xoLcsMPWp8zkpO/deV4tVKeZSHxdVb4krIJ3Rn+M/UguEVV6bqUzIHv/zGC3tAbWv/aEFAbmFU75oT7+nbra0VMuK6wG3D6/N/vp++J1gJZshcD5clMLBV5+yP+DwWVZXLftakavfS2Q9THf6XkjNtuxw61ny5i5GGKOjzhn8ca/GtnNEQvux0tf1uwZtV/X8r5GlIy7RpYFgiOxdfI0k9MxEYQJpIdGVFh9n3s/P02KUnUn9REuuEtp2JkxiTfEukSy6UWKzbcUOZIv5UYXScgySrB/1yIrLI11jz6/RTn9b1Kc5d8J1EjvO+Fh9IdPMDVdSOCyTVdiPhB4jxEqOqUJeOd0qQb1LmZmq09XFZ3SQs/d5Ot+WYV+km5Uf7kg7nfd/HptYjXvBPH8y/zfhEloj2DmNNnr83vVB7mkJv3OdMgT4FrLY3SatBJ6wTIpRMuADYJDfCUITef+pqLSAZ9lf5Ztjv9qWeK86Hf132+BTBBOG6wgP2coTh0O8kp4Ve9YtiUsoEdyHI+6IMa0b96784vzq1JUv/1GiiXTsKkdAWqMlCGm0OFQducu9RRB7FKRLCUOPh7Z6gTdf+S80pH6FTkb19xhyS5r2xcbMZvUtVxYJVPv+
 91gI2VBm
 Vc7kdgOcwu2hN//p8yW+ByjxRZ3kYsJZVn7dtg9x415XRmJQUmm2fElTtzZn+lyspUDpOwHp55ZY7Aj77d4jazV1jbdQTn6csyZDyH8j6uvguODx7Tk62w1JwAW9fsaltvGSSrcjPEoJuDW1OY9qPPXq9PiXxmTMcbCmA8pROrIofezffWPgFUfOcfQQUkHooEGwi3HpErtjKrYGPMY7fFkDjtaHItmCejl/Jfub9VETVdC7nS5UyRKJC0XhZ0JdsQRqv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 09:56:14 -0400 Brian Masney <bmasney@redhat.com> wrote:

> The vm.rst file is currently not listed in the MAINTAINERS file, so
> let's go ahead and add to the MM core subsystem so that the maintainers
> are CCed when changes to the documentation are proposed.

Makes sense to me.

Probably out of the scope of this patch, but would it make sense to also rename
it to mm.rst, like we replaced many 'vm' parts of file names to 'mm', e.g.,
commit ee65728e103b ("docs: rename Documentation/vm to Documentation/mm") in
future?

> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

