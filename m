Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD4FCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75906B0088; Thu, 25 Jun 2026 04:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26BF6B008A; Thu, 25 Jun 2026 04:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17096B0092; Thu, 25 Jun 2026 04:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9686D6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:46:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06033C2A0F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:46:29 +0000 (UTC)
X-FDA: 84917803698.24.9C7DE9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 37EF1100002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:46:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok97cIh0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377187;
	b=Bh0VehYP4r9g8QNc2TQUWdP1BgaNwH3KRjBWLg8Ghumh24DBs36VRFvjj1iOzFkPV46V49
	+o2qe/fuXSjaBk6JapGXHEVDFth//virda1nwZM+SaP10GYs+G2I0c10GaYoWJLx8MZIec
	lpJQxDmZyxpBTlKSVcLj35CZurXhobc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZukz89MzZ5p8EThN6cn+rwjGOOhpfxIVjRUP7vyd/k=;
	b=tnAfH51JjSEz98Sz24Oafdzx0yhG3sOoOuSe1J9HWPOy9/WN4unegH1FyDBYXMvxA9L+OX
	zhvexEQ6N1gEacscuWGqJ24xQjnGjz4R0IG+u6etoG+k4gNyzoENlFzRg85zPrLBhLpsA9
	qDpM4x5CaSGTWGsA+Kftw3fQ0zWrFoc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ok97cIh0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD11E60218;
	Thu, 25 Jun 2026 08:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05471F00A3A;
	Thu, 25 Jun 2026 08:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782377186;
	bh=aZukz89MzZ5p8EThN6cn+rwjGOOhpfxIVjRUP7vyd/k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ok97cIh0kTmIRlWG/kcrHMNiRrpJeUFbRk/N5DSmZrNyM86zUW4nNGSiaXdu+a4f3
	 MticWIIlZTOwmwqKfiYmeyktRyztwc/3eJnOGTKFXJoly4qaZs9gAk427430sI5pWw
	 aYX0t95Pgc9d62ZC+Pf3QrL1cB4Zvpzbez5UU5nquJa/2Ye+YJGBwiU+Z/BpjSFrdp
	 Dqj6dKseqUpPNQhqEVO4PTHA8uaS0FcEpVD2hhZowOJbDh1NSBgw5D150wXNU1ziia
	 1ttOgsOMfZwsbvLDj8kxNBi9La7+1kOASqMu1tdtS8CRhVjQNJrVby+Mpg6Sj+6xIO
	 91GT0k20txAhw==
Message-ID: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
Date: Thu, 25 Jun 2026 10:46:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-api@vger.kernel.org, netdev@vger.kernel.org,
 fuse-devel@lists.linux.dev, Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>,
 Miklos Szeredi <miklos@szeredi.hu>, Andy Lutomirski <luto@amacapital.net>,
 Collin Funk <collin.funk1@gmail.com>,
 David Laight <david.laight.linux@gmail.com>,
 Stefan Metzmacher <metze@samba.org>, The 8472 <kernel@infinite-source.de>,
 Willy Tarreau <w@1wt.eu>, Joanne Koong <joannelkoong@gmail.com>,
 Val Packett <val@packett.cool>, Andrei Vagin <avagin@gmail.com>,
 patches@lists.linux.dev
References: <20260625083409.3769242-1-safinaskar@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625083409.3769242-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b8nkzzoztmggmhc3713gyxu17ehqhrui
X-Rspam-User: 
X-Rspamd-Queue-Id: 37EF1100002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782377187-167151
X-HE-Meta: U2FsdGVkX19Ge1rcevjgCHxGvDJrVqGhLjN/o9pWhAfvuNdyVVlqAfEnJbBMh0SaDvA37hyNkVNVMinQGdltn/Ye9cWDuy1tStcFZ3c6WNZA4yyYJzZ/beeq8IOI1ttiAnPzDAFefpNXLsvj0L09/jPEUCtkknHOEB03cQtfCWtRqXD/l51Q3Sahg1HuiB/QPc5/gRX3u7lJtPrJN2uXUTiN7T91tzbYpG8N+N+1KYsvj6nCbUA4zzIjGo1bHbN72JdnTgYeOCeRRA6c1707jPe03Rg+ixHHT6bDRHD0QsbAU6deaE6ZK0Nzz5A2urPupjVlU5utShtpqQSiUegiTcJpkwNBHns6EJVA4uRCqqhAll/7XghUX/qcCqQ1V/cj9oYwdexiYJZf+MDm+yg+jbuJ4ivl9QEo/yRaZcpc0bVodgBiaE+1+9CWMnNgFlqIKw7JvUR5vdb5YRyzITzpfI84QBU2WCKNe46kO2tz/xETw1rEFnCW8smhzlSyZtzpNaQYq+0eSQKQZyaXxk+Ks1nAqS/aJO23i7P6XGyci3F/mBcjrDV4mu67K1QNwTFQVxJFplq0/khXXvF98QVsl3ayR4U86AiFZ9mKEqUN8SrkZA62FKbbY7O5B9sgV/qOhenkR/+tSNaOn+ZXHho/glEmC72HcVzca9F/C+WU9XCv0Esa7iU0J9RXpweUH6n3OXxI68wTz/Qm8pHl6l0YYtXL8aymOWuNZ1bRHqSCIp2O9DXfEw6zo22A0CHvqnE7//LdYtJNzv/DlsMopc49S5Jko71pMme2QAGuEIbD98ijJriUPS2UGUlqirc0gVoZkD6fFGUXKoXDp3DKuPfqFrAug0H02yyF2+dpPWqghRfbjHUXN1TVhhqhQ0JOywmNtsSwNPB1q7/H3LAibpd+DRaeZMT82oFV6VBDXHepIfqMYGcuLM46HVJnUnDo+oANrmEXi1vAW7DAuGWsKKM
 Hic9xaH6
 i0y4CzmYQqxLBzh05Edvbg65UXA+f/kguNJgwqGctkYUxajWsESQnZdCP0qZBDALRyH4OsqRomz+m3M2kXUp2ZxXtby4h66rTiOP2ujKoaa0kFXg4X6Ctm75TGNJBzjgNl5Rtyssyh+ntlwbDOWlK+qYQ9s55RVGZfxbL/vY9C7Eh+j7uphQY7VxPJf15Ya/Qh/EcFh15jeSrE80wbRQfQPq7guV3rNmYkNzcZwYdqonocuOcohSDwxsuXTNLcAXzBq7WaDXgA9ZLSi1H7POHGD+JD1B/DCgNiGbZmOYjkJW+cX2Ak5kMXqDWCNmN263pSKn7NUpCf/LSTfadgG4e3conVLNjoVNN0AGKGDtwjeZAvB4Y81/qwjzByivJtTePYjg1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 10:34, Askar Safin wrote:
> This patchset is for VFS. Of course, it depends on my previous vmsplice
> patchset ( https://lore.kernel.org/all/20260531010107.1953702-1-safinaskar@gmail.com/ ).
> 
> I fix some problems in my previous patchset.

I think we concluded that we cannot rip out vmsplice that way at this point, and
I suspect that Christian will drop that topic branch from -next after -rc1.

-- 
Cheers,

David

