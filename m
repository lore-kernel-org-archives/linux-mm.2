Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C0D1C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280F36B0142; Thu,  2 Jul 2026 20:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232876B0143; Thu,  2 Jul 2026 20:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1701B6B0145; Thu,  2 Jul 2026 20:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEB7B6B0142
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:51:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B2E51A02AC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:05:10 +0000 (UTC)
X-FDA: 84944915580.09.B451730
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id E427580004
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:05:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCRj2YwN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783022708;
	b=IROvBf37kByIAcnZVHKF1aVHqtWZ3hSBFBrln92NIHSkT5xG7bFgHYvqzMw3bN3V+mDUV/
	W0ieDquxuBJWKYGTe9EzXE/Wq6/e7WHPmtBmMAl9P0CMK6aj8L7KXtqdNA3TRux8r8Dbz/
	KGxts9ZGFFC4nTKOWwp91/8Gq+pJtMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783022708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vObZxhY41K/aMiSBJ+1LTUqYlYO+tprBv3piLMyT97c=;
	b=cAS3hYSjl380szzyJ42JuLHiQguTQuYYkvAT7TPX3mRNELPxO6bDTC1J6kvWWWLbh0kGsV
	zmUIV0rSKmoujPBWEY1EwRhfrqd7xG001I1GGC6pAj2HBBKRqG/xnXBBPXEN0CWGavPMod
	3eweB2e6KfZ6PeV7ktnTL1vdV608m/M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eCRj2YwN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29A1A601CA;
	Thu,  2 Jul 2026 20:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334471F000E9;
	Thu,  2 Jul 2026 20:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022706;
	bh=vObZxhY41K/aMiSBJ+1LTUqYlYO+tprBv3piLMyT97c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=eCRj2YwNj9K/5Dxsk/0XDDLdTFn3HKYKGTqouG8VJY1g2bC5bBv0EMjJAVoqP+8EG
	 Um5WFhANUNd9gSZWLrt135jWQ7MYG6q/Qb4SDNj9aXI/E4JAEu6k4a38cOauO3Ed5m
	 MndWBEUzoSTZxEoDUtyECKExJblFQl1aPN661e1LqerHn9fTzFYcr6G+tSRjxvyPU8
	 KbLa2q5SAL01XEBaWoWiCFGcaLJA1OP0T3JksknCT8TgcCM7QYjLfeuiQBAjRVEbJ3
	 L11sacjOLf00FMdIivyNQD4OirB3NpPugrlt1UdASNL05HjpTPvwp+11xQ9+usfUTq
	 4jRJpQocpXssA==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>, Dmitry Voytik <voytikd@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-toolchains@vger.kernel.org,
 Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankur Arora <ankur.a.arora@oracle.com>, "H .
 Peter Anvin" <hpa@zytor.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Marco Elver
 <elver@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
In-Reply-To: <87se61npie.ffs@fw13>
References: <20260701125151.352632-1-voytikd@gmail.com>
 <20260702025342.GJakXStrsCmIRnEwFD@fat_crate.local>
 <CAAX90H0V-=Gy1FyBT9qop2=RvhBxbOPLu6+DYpPH2pTehT=nRw@mail.gmail.com>
 <20260702111550.GH751831@noisy.programming.kicks-ass.net>
 <87se61npie.ffs@fw13>
Date: Thu, 02 Jul 2026 22:05:03 +0200
Message-ID: <87mrw9nonk.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8rumsnxqrzbm8xibnk3jfjhz69gp4c1q
X-Rspamd-Queue-Id: E427580004
X-HE-Tag: 1783022708-645296
X-HE-Meta: U2FsdGVkX1+G5X4yovw8d9PKV9mvYF42gHb3QXYITuBykGLp+5gvGddU/SRQt5r4XNgpDcI7LfiUSSG4Ta00J3E/BdGfUeRwkg2j1BwLCKEjKmJAypKvpZJFQATFjdNdBJKS26hDRG84655BlWMSfYZQ2ACziaSnETJm8KW1LWH3HgstFi69jFY6HeYcGogx7yOgSvtwysOKh1bqXKNT+vj8WzxZZnI3kbRBsq71ReV4cJsPjgY3+do6EP+XxoSHDu2bpBHXXKGRNywpsIWAB6YggQaakGiObaPcpZBTgb6cvVDgCQqSmakgh80/wSjxHgfTuZxQdPiAHOvyqmcEKYdoZ9UxGOS5sU/KjkQgEY0bOI+ddcoi+2Mf7OD156/iJFLu8q1NpKDS/lkpe0sh0BkbH+R+skDB04CZKmM4rJv2yjfuQZEinEO4k1ACVirCAxAEMzQc2CZpDvIkJQ51UsCg0HXp1C4u5pKPIIiyPjL4LdaLCvuAOPhTqkjdGi7u694x8r3XrnYaXI/oSsJWrxoY+awBwlsORLw88PkVZsb2fJrtdtwEDVbYjJgFcUsYqi5e2DyXxqLBvRI26+0/T+ZOW0cmUwt+IDpYBZ9/TDutEljO29os/CN1t1h3F1CHsKIZ/fYq9h9KNBpS+W2l5YdyF7grZuzvg1WOQEgLxs+0euNoFtvtus1HGAdBpsdtTQab39Guqn4rnyDHo4ATjEobZ99JfXpaQtUODL0QmEhurvOy3CMve2NP5VSJjIpzsC9Zk28FjckZCd5fxu7/n8TE2W9o2oYxNkzf5ya6R9zg9Tr3rIaCJKH83vQ7vaLFba02huIB8h6J5zMPvMLQD105ydLL4WEJlO3XicRPlQWx0kk3sOmxKp/tjz4chKTeWzhfPdaGk2vfjzOUx7NyJ3PaKSJHe5H4GH20xm1PO19N/UGiGqacPwVWfFfycV+9tdjRNLbEU4tmSTCsKGp
 TfhYqtB7
 TEKbhOW0wjCnbPguaF5PvfRRbAgaMzBDzU8Ip0brCu9QLckbyTeogdPMn3rV9CHy3Aje7t4PYW4Q6EQOw+FYvgLuU6iiAw545nW9cMSi/284wOnTqTz3svEasShJ6o25fznQOM40TxrAisDzs86+durFYbN0FqBQFMOMhI1mtYEe3cw5FoJ7/zdhHs/4YlziAZwaWQ6zx5bS62c47hqNO0LR/0EsyEZExlAEtgbBs6zJVEM+f3U83Z/iqaWWNcVbALTyxeyfmi6M59CfQD9jv35Da+gOLW8jk4CTJmJliaxq8uPeP+ihTM9oIitDr00r/MfZRPPkemsFKpGImKaIl9dex8cMU7qAYvlrn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02 2026 at 21:46, Thomas Gleixner wrote:
> On Thu, Jul 02 2026 at 13:15, Peter Zijlstra wrote:
>> A quick test with folio_zero_user() seems to suggest the
>> ASM_CALL_CONSTRAINT movement (your patch) generates the same code for
>> defconfg as does the unmodified code. The change from the thread linked
>> above (input constraint on __builtin_frame_address(0)) generates
>> different code.
>>
>> A third option is to force FRAME_POINTER=y for KMSAN builds -- for now,
>> until clang is taught to be less insane.
>
> With FRAME_POINTER=y I get now with clang-22
>
> vmlinux.o: warning: objtool: folio_zero_user+0xa7b: stack state mismatch: reg1[4]=-1+0 reg2[4]=-2-336
> vmlinux.o: warning: objtool: set_ftrace_ops_ro+0x64: relocation to !ENDBR: machine_kexec_prepare+0x8f0
>
> That's with your objtool patch applied. When I remove that then the
> folio_zero_user one goes away. The relocation to !ENDBR stays.
>
> Oh well...

And none of this boots when KMSAN=y ....

