Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0631FC79FAD
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A4E6B009F; Tue,  8 Sep 2026 06:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAAD6B00A0; Tue,  8 Sep 2026 06:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C7D6B00A1; Tue,  8 Sep 2026 06:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FECC6B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:44:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E34C1604AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:44:01 +0000 (UTC)
X-FDA: 85190259882.17.B04BCF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6972D180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:43:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DhO0ZheH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788864239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0B7wENEpxIvccDLJRxXqbL7rcutNHrgtgVnGBh9mik=;
	b=PclF6at/7ONRh9afLnH5do3DXXt9Ct81gyDQl61XDGFBuN5GGrP0MT8I0RKfsNAP/QcWIM
	7WNqq1lijPeFwwe5ZXzFMGPQ5+SjVvvAOJpMgIKc+jiDMAwt+B0L1kM5g0O7z5p6LR/hgv
	egVd/JfdRcFs1oouhAsuF508nnKyBV4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DhO0ZheH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788864239;
	b=sthEL6dQPPAp218GjiNSa8gwtYbh5AWWmUcIwm3F1pY1SsXXpxUyNXn9uy5RlqV39uSrOQ
	9cBBQuyKIqULfVUSl64YewZf0WfGh8mlF7M/akzaOS/kqHIpg/PMXOq7RQ9y7EXlBAptpS
	MtKuISzeeQbWkez7W62uAUiMkarfluE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9999243CDA;
	Tue,  8 Sep 2026 10:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0541F00A3A;
	Tue,  8 Sep 2026 10:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788864238;
	bh=g0B7wENEpxIvccDLJRxXqbL7rcutNHrgtgVnGBh9mik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DhO0ZheHjan/SRSeXGixJyH8oo7EQVl6pY1Zvv4NBjV9MXFi9nEUNerTWTxa+yxJx
	 Y4lnjFH5Fpq3IUKpFiGfk/gJbwVliEKYOeZJlHUAIVWB+21HjpkjfnVo2pHxsrizmA
	 GX3qsGLRJoBYKPW4jm6zwExJv4tGStgBPZDANikXVzQKjkWI0wIsOS8xxI7u5LWqTy
	 0gW44Qn3nnZtcXnaN46nGvLm2vb+/13Qz5A17VSWKOST/LVFHHGReP2rNwzkuW29VA
	 a1ejYyd7L2hZCGokATZ5s91l4kw7X8hftF/eG8AcQ4i3fuzKLQWwjJo+ms7DzH/6Fs
	 MNOxy84IcmpNQ==
Message-ID: <c2237474-ed50-42ef-bcec-90fb705e1fe9@kernel.org>
Date: Tue, 8 Sep 2026 12:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-6-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xzg8eyyh66j7a5mwn4psymwi4dgxeoa1
X-Rspamd-Queue-Id: 6972D180002
X-HE-Tag: 1788864239-18811
X-HE-Meta: U2FsdGVkX1+JiGvlH6IhGC4PlhZdWb63YNFbXZKQobWQz9deNxZB3lWss/SZR/RTBh/fj3DIGb3OT0q1P9J4XfQShbpi+KvoHXAzI4rOcZmKUytGBmtv6EQH8Ba5wSKhbMf1F6wrYSzDYuP74RjbRrIfuVEqCa3XBwT8cK9U5AQhHY0suW0oaiWeAWYRoPjn2tvNA5JDldmqxEaI5dElA8ke2P+3aMhq7+ioJOVAjo2FlkG3hOk8VZgreAE6iJPPXBmjLgCnlVKaj1C357Bm8i9irUneAZCv2wgQgD9YXlznr5qVVVRK6xDATCA12sGe9Sls6ip07KD8nsGzGNcX07xMUdFAz2r+cKSO63VQIISY/gInuc2z0Uzb2FyD9qM4F2Nv3yLp9sbRH2imUjkB90bdqzOl7wtFhTnHWOJIvHd0n1p7Fb9rtP2cfREhUwWnUAcC6YMRfss8l2Mrjfsh4m/zH5D9DA6RXk0AENn3NEhrBitgDZJmIN8Lf2lFvs26AtxG/f0N+BErAX7aytPG1IPlIW7Z5+2xQmge1HxnydyohT+hiAbdXfVRlL40kHgTD8SIdOcavnPtrNEVzQnhDt7t0Qxoy8HiTXwpECjKBsqNGQ9VMBDRg6xMGNqKoTgvvuxPtUgFxQbfayTrdth+VcJc9PczlP6zQhkG95AixKIncgKg+wQzlfwJDsFBQ1156yUqG5ev0Vp6QBYceKnQWPW1P39sjbqriHLK9sOj4cCKjiGm/64R+4V539Dw4eMehUe84/rsXHc8ckFs8e32YAaDLgmbqWoBSf38xGD3AD1581wLa4YiHRNvUXbzinv9NbYCBcf/eHerOmZB4xRrwSadxEkV9qQKQhP3KTM+z2EmCuKeuka0g1pr1wrCw3AolR1XIO9U8H5/7dsZNDiGHz1J3iyy/x10uv7AAhPw0JhxAAmH1kfBBal60qI6bo3v3Nc393vt5QRu61UWU00
 zD3MSJXv
 B89ce4KovRT8OFzkJq0eZwnS08zNX9H0BJ9n/rZ8vPVvAGE3ziq8v8Fcosr3p3twtql9aKntEe5DMm3a1G8bK6U02QVDgKU6sWoWZ8t1MTkQRX0z6nidEAzjFnMORwBN9bkzlJLwjxBEbE+C84DmTg2pQjKLLXcYZ1qMQ8UgRGdYWrM7eMpmPO1EWNuBM01vDKtGx38Z5tcYm8TXoQE+5QgM6DyWHwGnTMHagMEI4Ok13eLfLGRFYT2+olEfcY1JWBeiDv6Umm9V3Ksu1BTjFUQUcgat0596yJFlhvmlexvaaNamNgm4PUFmtyfSj7Jtmyb7M/xO3aZOfQvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/3/26 11:28, Mike Rapoport (Microsoft) wrote:
> Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
> added set_direct_map_valid_noflush() to allow updating the direct map
> for a physically contiguous range in execmem.
> 
> As Brendan recently pointed out [1], this API is confusing because on
> arm64 it means that is sets VALID bit in ptes, while on other
> architectures it is an analog of set_direct_map_default_noflush().
> 
> The only user of set_direct_map_valid_noflush() was execmem's ROX cache
> freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
> resetting permissions of the direct map alias.
> 
> With the last user gone and with set_direct_map_{invalid,default}_noflush()
> accepting number of pages as a parameter, set_direct_map_valid_noflush()
> become a copy of set_memory_valid() on arm64 and a duplicate of
> set_direct_map_{invalid,default}_noflush() on other architecture, it is
> safe to remove set_direct_map_valid_noflush().
> 
> Also drop a stale comment in arm64::__kernel_map_pages() that Linus
> bothered to add when merging changes containing set_direct_map_valid_noflush()
> to his tree.
> 
> This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.
> 
> [1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev
> 
> Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

