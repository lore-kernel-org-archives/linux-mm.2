Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A14C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5296B00EC; Tue, 30 Jun 2026 04:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375966B00ED; Tue, 30 Jun 2026 04:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 265816B00EE; Tue, 30 Jun 2026 04:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBF8B6B00EC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:10:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 720C9A0413
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:10:12 +0000 (UTC)
X-FDA: 84935856264.22.4D9CBE9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id AE77A40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:10:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="M3UVh/O0";
	spf=pass (imf07.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782807010;
	b=XRPClAkIjvssIBEZPdWMbWP2ZNhmjN0+9zyrSlJEMSe7HvaczXuSAbYiI7ifNWPTyCS6j2
	eEXtssO5xsLTU+xkz40p11O3toXGodigkpL6vBEwPP87J8tURxhLx1WqKYVFPddc7t1PPv
	EM3m1pWGT09JFBbWrjkIZglKr8pWQEs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782807010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yMFvOab7JfjhFzPXVN7GoFjgSZR2kyk1cDhk7lmS3lE=;
	b=L1tA7+rzb/UlpTYmsz/IHKsLA77OJC1g46pvxRgdPPi1Bt2UE6aVW2snS/aPARwzO6bURK
	R9ftze/1kLbVKz3pVxAknT/YtutfTeoXSWUtZ+IT2oMWgOp/6K3QyBvjygK31mwZ2p4GyV
	+f7GDPGEK+DJFZSWL42AO9zLoiIpXBU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="M3UVh/O0";
	spf=pass (imf07.hostedemail.com: domain of jackzxcui1989@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yM
	FvOab7JfjhFzPXVN7GoFjgSZR2kyk1cDhk7lmS3lE=; b=M3UVh/O0Jvp01mB0fW
	/lfDkszRjzteGlggE8Qi2E0kvUA1xbwb6dQaxNRDuykytA+uI37uu+wjD6maB1dB
	CVkY+mE/6fA0vJ1svCH7D2bcdKOziVea3Aa6eNm3gTk6T0OWGMpo9xAEWoCHluhk
	8ohzJ9Jl3kwWqWXb7caUIGZqY=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wDX3su8eUNqwWWIGg--.46550S2;
	Tue, 30 Jun 2026 16:09:33 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: brauner@kernel.org
Cc: alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	chuck.lever@oracle.com,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	keescook@chromium.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mjguzik@gmail.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for pre-exit before dumping
Date: Tue, 30 Jun 2026 16:09:32 +0800
Message-Id: <20260630080932.60881-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
References: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3su8eUNqwWWIGg--.46550S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF4DWF4DKF1xAry7uw4rZrb_yoW8XFyfpF
	W5Ka93Ar4kGr17J3Z2ya1rXF1Fk3y5JF47XrW5W3y7u3Wkur1Svr48Kryag3ykCr1Ig3Wj
	qrnFv34Uu3sIqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR489tUUUUU=
X-Originating-IP: [124.77.128.91]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbCvx34A2pDeb2JZQAA3Y
X-Rspam-User: 
X-Stat-Signature: 8wyfx1uke1y3cn5xdn8biezzjuunmfhj
X-Rspamd-Queue-Id: AE77A40002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782807008-55713
X-HE-Meta: U2FsdGVkX1+zb8xf/bSGKM7WrMgXaum+RnyjXHC52tdPDdUQStx1K5pzamv1e/GrBDtyO1wmKfYPSy5Zegau43S8mDmyZKeCuqX76eIJQtw72VUQAD3WUDGMR0q4YBvELp8v9r/gymfF55DeXfKV0q4RDpXis3QYRnI0YPna36xYEuTa62J9FcbTUXtZnYerq8aFyWiZAsfYBaW+W7HSCJoagi4Np9KXh6qGAkNODv4maRo/OgQf640+gRnxSzbie3+LOgjSWbZu3nWBLo3t8ah87VsOaCHjxJxdhj7TeEJ+wOjd0jvpzyUg4Sekek5HMA40kVUgv4ywi7Uu1nWZKGg4LQ6SQG/mdhoiWq/qEP9m5en1N98scRK9xrKne3faWKyI/efVnRQPNdGEd2ESNaXUKKYuQznhD5XGK9AD+l00lfIcLjYK22SmpG4AXlhed48ecRQVQuZV4cmD+wTTGPGgnWqwdNN9beP8oqtP6D8Ilf77qmTKpMRERqoi2PAzdvNUMafjFSADCD67f+SaichTzBj7UYEy5F8fWIZp7GPya8DYjS9YBZxqbzo0ecQ874ef94IWFICsi8OFe0nao3tltrDHjoctSMPSv6/5nydGehZTC6bZnrWiPXNOaAkV7F5aS1IZggrNxl2N5/zK4oqe+xZ4m5kfpDLeugnTgwcVBgEibuMd8wHABNMGDWWC3sIxZQ1ExF63CPNFMvDWTcAdKD7zl9+/Edz+O8uXHP5WBggLrXrCcAS9pO9TBukvgg1grguob2k9U9sws4NyR7hAnTXdZF9LvfdTTIM0Qw9WUXoyoNS8UpPnA7g0AzdPgCO8ZeX8FYvkc1U4UlbhWjAdLY9coRqKe26Diig7BDB7OmFcu4cGZ/Ci7mi2EOPEca2R+TWZQp99R1BN0SJGZWQQTfqGlrNmlZnqyBYrdeQCUP71Y1t434EWOG0KByU2KEt26D3t1DIjlCZ6zLN
 uTZyAQqP
 drXu9vlEm48IG23Vt2kbfL9KuiobWb5W8iDdY2SwEFTgvmptPKiNZ7/tO9MCa9MmEwyQvmb0zR0Aj6UfG5tOvFOIkBnASPjGU9l4SkXfFATmzLORIQJdGyfDoF/iYq4YLJStBIic8lpu9xSQCY23uTVxR3UTDl3zh5Q/S6whPHtNy8y8VwGpIld4MmPGwRHTgpFT1VAZDIvOxLaaQUQLPwdyXVXznP9nuPt3QVQsNE6Fq+vTE57t0GOWXM0cetdGI8c6Z0GV6y58PsF56wce7lKOOOcpCq1IxKXVPEr7gb8wRCks6f0URbhTr0y9YACf9a6m6nEwIeFiLnjMdoUzqeO5RifbJjvis8e+cQ8vUVZbASrj1cKALB0+5Ci/kzYIoQYPpCjAJmguzV94iTuE7NR8izew3wCpGsooz0gWfa2jceasmtP7QFeLL1gDtFnL3odzjtFCE+zxqTHu/iJ/HwxTQ7DQKWzl53enXKgE+mGEh5j4Xo4Xbse59mVFJgnYdMvQP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Christian,

On Thu, 25 Jun 2026 09:28:08 +0200 Christian Brauner <brauner@kernel.org> wrote:

> Nah, we're not doing a separate file for this. That makes no sense
> whatsoever. I've already explained this in the first mail. There are
> effectively three modes:
> 
> (1) dump to a file
> (2) spawn super-privileged usermode helper process connect coredumping
>     process and said helper via pipe
> (3) coredumping process connects to AF_UNIX socket
> 
> Parameterize (1) and (2) via a command line arguments. I strongly
> suspect you're using some AI tooling so it should be able to figure out
> how this was done in the past.
> 
> (3) can be extended by just introducing a new flag value for struct
>     coredump_req. That is also illustrated by previous work.
> 
> We're not spreading procfs files. It's terrible api design especially
> for security sensitive changes.


I am unsure whether the addition of a bit 9 for coredump_filter in version
v5 will be acceptable to everyone, as there are still many projects using
the coredump file and coredump pipe mechanisms. I found that coredump
files are used in elf_coredump_extra_notes_write, which makes it difficult
to distinguish between these two types and determine whether early release
of the files is possible without setting parameters. I am reluctant to add
another bit for this purpose, but it seems necessary. I am not sure if my
understanding is correct or if you have better suggestions, as I really do
not want to address only the coredump socket situation.

Thanks
Xin Zhao


