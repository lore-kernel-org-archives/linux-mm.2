Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE6E1090257
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99A66B0559; Thu, 19 Mar 2026 13:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A716F6B055E; Thu, 19 Mar 2026 13:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988836B055F; Thu, 19 Mar 2026 13:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8433A6B0559
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:20:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A6461B8604
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:20:40 +0000 (UTC)
X-FDA: 84563477040.30.A2E540A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7587D4000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:20:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ffSI6bz5;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773940838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaebET4GlZqyVpUhTjcsc0nipoEWgjWeux2s80xj4dE=;
	b=znOA1OghwLVdsum32HiBwlVN2WWj3gTljAqRLgg4Zvz7lt9WCdbmLDjvGmImew9RZhEbPQ
	vqEJ+6CttQRXCOppM9aqOnxZxNZjK9s+zhEd//A0ea4vDsgH3E5AG7+nDofyajjTjeEPNJ
	jkTWIiGs4Vdv9GNM4TnR7i5Vn9JsoJ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ffSI6bz5;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773940838; a=rsa-sha256;
	cv=none;
	b=Yo2Jl8q3LJEj4rN0z23DwoDAZm2r79Wwzu5ccftkdjxdObmi8+CJZFD1tzIjuPPt1kQbVf
	NR3N+nlJvnOTF5pZtYC3K3AN5l6jdgrgMQfxHbzf3CQYImY/d5UKOeNr9DI8oJ7+kjeaeA
	3S5Jf4R4f3A9Uomq7ONgj1hWvPtw07A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B1244180A;
	Thu, 19 Mar 2026 17:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73FCC19425;
	Thu, 19 Mar 2026 17:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773940837;
	bh=7WKgNaoLHZy+p07zFzG+uBXisQ4HbwxhhgHjiSoiZqk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ffSI6bz53zQJuafJNtvM0FXrQJK6TSoiAy3TsE/OHG+oBO774YE9Uq3ERY0vLajMq
	 foC9QTSU4NBbGhonH60yk0rap8lV3ZJiY0EdZg4ohtjFxDdP03WSSuv7FxOfb2gNRf
	 4Tk0tb7MTeJ/T9jngjYvWOB7yaJiVrqkxSsZr8VaEiHU45hzdr+GUo5kh19vXtO0bW
	 q9aU3TOVflRNsW/UNdynX4mjKb683rFQGdGwpblrX7NCqBLWvGBpQLTxS9zEs4EM+S
	 6Jfsi2AkaiHj/WZ4zV6R2NgeHtz6Hh0jtHlsQEY+sWmOdz5CYdHv4iR/em4M/Sr5Ei
	 2g4iqlwGBs5oQ==
Message-ID: <50ff8894-3013-48e3-91ae-e96499ac394b@kernel.org>
Date: Thu, 19 Mar 2026 18:20:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/23] mm/vma: add append_vma_flags() helper
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <868641e2dbf62e3e04108a0b8092df25c250e3b9.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <868641e2dbf62e3e04108a0b8092df25c250e3b9.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7587D4000C
X-Stat-Signature: r6h7wa65xiomfrr9dzgtb8ffdeb6pdjh
X-Rspam-User: 
X-HE-Tag: 1773940838-409188
X-HE-Meta: U2FsdGVkX182by+D1nJbq5Z34n5mgNKhb9qJkzW7vmdNYLzddG0kalhiNjd1TV8821z7n2Uu7Z0tx1IV58CPShnE6y5oHIi7ViG7H2fy4zMP8tEL+6vTB98U43HbENQtWufHvEdvNuWTL5urTtc2BB2ONY2mzmecptHaYjnpxkqEOYB4l8CIW3glzItJVKSX4fJADcQ+bO4dUOuGcFZ4cEvgZs9Ut7yaWUUIgSrvMqO/IxBaLcVE3X4AG5CQtOi1FJiHHiNqGVkpoIWJtgGhGf+WXKZAIqGV1RhHD074AAmIZYZsUcs8mVhRsrLBq0eUtsaSVXjLhWOkFVf9/pUHhi4l8s2RxDY8Ox1g+xQjLFmB1d+BUGWTz3vbDES2q6Q0wA36O07BaCuDnuFqpPY262gozRMHuQ+vPX0VXHH+CdfDrHiHA1fQGzDYkYi7EsOOU7+WoRV5Q6CYmwsD5M5tdONgCU8CtGq8bj0UJYVZXvKphUEbqr5W8X8NEvQ+OzeMTyJ9Tr50pTnRFIfjluodD/kgkn3OezMaw26UYE7cYwFdBpkHn2aT2yzyzHmULUg1nd9krKqLjTusTw8JtnDAuhydBJnL7gCQEuJEfUoedYq+pvxsI1M9i8vRjAXxXvEC21+vFuYkRY9ctZPzh7PUVQyjGxJWHTGAtlmQfMhWuWIiW2lb5d5qb7O2RmY0Boj5GcgXDjeKocupWvp74EpN74Iz1A+66lW4JQvcXcw8c8BP753/lQjHpFM8DtQLJlnw6wVZ8QGbvbQJ/Ys/IagZbmBU1HQ5FId7Vvq4HztwjKgQiK9ao3bD+58vveKkzs+2Mhr96YoBuEJvSxY+sa9oJNlR4p19Hj9VZ4aL+FX2+oRodNRG/Kt8LiapEgg4dqoftMohWvBi8LO3jiq4rc8k0bw8DL4NHz+3Yi5i6y3yw5Dsai/gFh1l3RUqp8uIUXC1YwZ32UdmEqbxuUsLk0o
 4OPjSJ1P
 8U8XnKKrtVLIZ30oEu/zN45KtEKLprkDv+H9G/IhcKFrAIRzXTIkblB6mrPSW7BCSxKMP1IqxFUDFDhH7xGZ/IE7VJoQ2dOvlTnpuHWsPmSHMZJDf585k5Q99AoiCKR8rMo2hXXp6aZueNS+5QvjAn2meVkfIzz9PtA/eIUHvGvqUaYAIU/J+Atvcb/L0bU4zv5vRU6G71F1XCp7HUiwOkJmviCmfjSgIHTRboqGerXtWpqqplauwxjxCwiVj9PZFTi/zEqzZnhH7zwG6opf9xzl0pRtxE7Q4DL2m5KhqE8SmOCNZPJT+ml7+0957ikd0VV+PlGOQlP5RdKBSTIq95e9FKiNniCseLQdSWNGFJZgtSNt96qtZSyDCsXm7gzuBRkQC73Bu0fDci9YZuikp0vdQRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> In order to be able to efficiently combine VMA flag masks with additional
> VMA flag bits we need to extend the concept introduced in mk_vma_flags()
> and __mk_vma_flags() by allowing the specification of a VMA flag mask to
> append VMA flag bits to.
> 
> Update __mk_vma_flags() to allow for this and update mk_vma_flags()
> accordingly, and also provide append_vma_flags() to allow for the caller
> to specify which VMA flags mask to append to.
> 
> Finally, update the VMA flags tests to reflect the change.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


