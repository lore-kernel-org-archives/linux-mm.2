Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C8760B9092
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bXZjnm1G
Received: by kanga.kvack.org (Postfix)
	id 2334A6B05B0; Wed,  4 Nov 2026 15:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B686B05B1; Wed,  4 Nov 2026 15:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148706B05B5; Wed,  4 Nov 2026 15:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E50666B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:14:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DDD4A07E7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:14:59 +0000 (UTC)
X-FDA: 85398540318.03.CFCD1A9
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0D6A140007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:14:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bXZjnm1G;
	spf=pass (imf26.hostedemail.com: domain of 3P5LragYKCHAXSTTliUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jeffxu.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3P5LragYKCHAXSTTliUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jeffxu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793823297;
	b=2mb1oo7RBatj0wv2ZGVblZzuVqgEBc6jKp19yxbJ1u7B+TDItQXtK63DScHdL6HrTFqbHE
	nkWiJwDPFl/Ox2JFmVQW3PIHUD5tzxW9l138HCBCW8mGgdvzKrT1bylojM2s7zrMhuvecy
	Ud5ZxzmDtNDBxSFu5HVT2cG0mSYB0ko=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bXZjnm1G;
	spf=pass (imf26.hostedemail.com: domain of 3P5LragYKCHAXSTTliUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jeffxu.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3P5LragYKCHAXSTTliUccUZS.QcaZWbil-aaYjOQY.cfU@flex--jeffxu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793823297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AS/luxCxZZ4IKfwOyJu4Ue765u+vBG+6P6QAZr4AiP8=;
	b=osUZr5E9U1qd7rtRgdTqlPMpTK2vsPesdYXrJiD612cNdSZezUXe2RpKpOk2ajOlcJx1uN
	YZqXMdl2pmrofJMOEQfI3N0vBPMzOtScvjuuBdW3bxDVx8H2Zs1Dxaebg5GZBOHNEqdOVC
	KpGH+ZVve3eHBMXW/B98Lqm94cmBQeE=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so1961048eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 12:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793823296; x=1794428096; darn=kvack.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AS/luxCxZZ4IKfwOyJu4Ue765u+vBG+6P6QAZr4AiP8=;
        b=bXZjnm1G821a5aCuncLuOHf/3rmf1CldXaPHOX26Ym1DDVwauVlDg5eMXLsKPIRDR6
         7etMxgqx+gQieSiX9kWrN9/yeVNTgU9txZ38Od1IY1Hv6RXPGB45mA8wSrBS5bB46pIZ
         J8OXHNIqno0Yb4ss+3/qCIj4wnDd5pox6fnrsPRHoKRM+VZjSG49UbU4LxkvL4MwvvZU
         lpJyeBux0qpccwjtm7dgZd/PY0b2+AawFQZVCuHTJ2KZ35i4d3frEErjgU08tZze9Hjy
         WZXJowP/mFCFbQ64arBxgHM0rDneCuBSM3dn+uYwq+vQTKnxsATQgVTn6I1iT3Re84vY
         qNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823296; x=1794428096;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AS/luxCxZZ4IKfwOyJu4Ue765u+vBG+6P6QAZr4AiP8=;
        b=Mc1nX4zRG3vaNLYh2bqyUitIwou0f3BwoqCkOM7PIWo/QKRs5uwNC5jfGmZ7xq6X+R
         yqxUSsMPZ6WX98LK0cqBtepDb1/aKyonEJDbIXGTs9KPj7OPmJ8TuQFFrP+U+oOKOT3T
         zeMEKJTaJrch1CRbYBw6zoVS3b2cOnp7PAOqqKr9jakMlI7WJfjcIG6rFhTF6q7q9mCK
         frd6z+1aJ4Bp5HTX+juRt+J4g+lkR5bu/JWjSCAFc1do4MGpiKMO+qSiQ4oZmCIRbShg
         DUoQWsoDGzHRrlo7FTlQjARN/f5R1gjSIb6BGPIjT8iIvV12dDrPK9iwhUqmTKLOaQJ7
         O/jg==
X-Forwarded-Encrypted: i=1; AKwUvBzGq83KZtdW0K72aW9QnzWWCrqgn2GDR6tECdY7CdoPHqJILqsDEise7W1rT1nt0aqvb7q3OUm+Tw==@kvack.org
X-Gm-Message-State: APuU4Z/jP7M7Xwm3CLb4s96oIyhnLwRBbTORukbaEptKq+dhLVCV4B0y
	zFWu3LFNjBgrJFc6VwbBVcmOCAVmVipL9q26BLIzqVhDXwb4Ttmp2gWtZUighFlzhzVZtSWisEH
	elw6xbA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: from dybkf8.prod.google.com ([2002:a05:7301:3a88:b0:36a:e67:fbc2])
 (user=jeffxu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:1608:b0:185:4ad4:3d15
 with SMTP id a92af1059eb24-1ac56302329mr19203878c88.1.1793823295901; Wed, 04
 Nov 2026 12:14:55 -0800 (PST)
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
Message-ID: <18e4f0c895c8d2ed.3137322e32382e342e3434.27cc5b.0000sendgmr@google.com>
Date: Wed, 04 Nov 2026 20:14:55 +0000
Subject: Re: [PATCH v2 0/8] mseal sysmap: Choose system mapping sealing at boot
From: Jeff Xu <jeffxu@google.com>
To: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kees Cook <kees@kernel.org>, Andrey Vagin <avagin@gmail.com>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Shuah Khan <shuah@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	x86@kernel.org, linux-arm-kernel@lists.infradead.org, 
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Stat-Signature: 34wrwjdyyqmamquzua5ckwp86ft46i69
X-Rspamd-Queue-Id: A0D6A140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793823297-569922
X-HE-Meta: U2FsdGVkX18KXFvzX8e4V8eI0PpELRgsZSIz2ww1qdegdSxX3sX//6A1CbAXhsXCAAAO9B2a5CR9Ex+4WL3qu3nDJER/K/Io5c9J71E+dYfVlAbQwIHE3uC3nYnH+9aPSoFUMgrOgJNlM6VNnktE1x1P9oFQOYRzSib7Enoy5FUvDH1tO/bAfds2/TuRSv65g6mcUqfyhBf1Vd6y+Eyq5sf17U7sZZzbpfVfiBzgRcER0Xpd6ADoCMjw+0UPD+ChdA/MsjCsU7VGmZ2vbIV+TpE6lPQY45IUmJ4efsMgjlZXobbFyMQ9AVFkA/+mmQ8HyySjncQMAJxwt+d8/1Exh2oLyl5duRNZV5Txth6+h82aBKHTTTf6G4jS+wxnjrvbdt/JrTs1FfdCjYOm8viUqeVlWmPtlB/LuEBwwCgK1dXPYWQZcNg9XHRoxk2vJKIXg2/Dic3tvfuWGQidDcsJRSFAPTyyIOmD0jI3qSIc6NZQHcKQRmaJUrdgu+ZyFm5SxX6c8lsSNddeo/5oX1ZgI40DhDc9/3Y3jTCdu+33xhK1Bek95Cz3mg+Ey21KbCiVfLDpUTF25awOrW3coFUvR+YG41pbyYfaq9+luMX/lT9ezg06Hva8h8ETD5akMWGgPZKzpp3zz78DFrWRwhJa64uwvny/9JgYawVOG3I3Q+ud+TirclVMtzkwjSdhjzDpjjLc5t+t0YYpWFsxOeBrOxDU8dFLLh52AQTdtQqRfwrs06gGZV/mqfurG9YwXfTlwyXuWOHOTwVSKM5Mx4Q/wzBrFOFNGju4m3masweFfamK8MRokuvr3ja73+55efa1pzmsJCx7Y34/HEpv5aKXjIVyveMfRtr2hBFIcr4/Tv2Ihkn0dGLiZIOEzlSkt4ktZW21wXX14Ohmh46IffLrEQ3iOTuj+W8b6J7Wbnm4CC1V/U/YxVu+MQNbO+8ts71QSpq5kVcB32SWuqwv11m
 aO3xeMRa
 zbnVPfbVWrPKi0Q5INhje5RUkZ7JbihpRjsFTaBJ+ZULT4nbbCc3eapVzbupu3Inu3RHR0TWRqMjIE9De+Xx3WEVu8oulXA5+fERpenzVKVmDsEEo/oYeOk1anHH4OzO1fDHUsKl9BV5MBfbbUAqvzREVrdVm1ov67ccs+jVq0448NWlC6uU0Ow9ueASgCu7XEOHJuVxZwPj2OAwJNOgX3FCaSo+f/I3YINE3Ky1OzGn1aWIRmza7qem3MfhQrtqkZ8AwFXiLUqj6dpVCRS/q/y8+SgpqmTKdK+o9HuaXvkQBdc3iG0kUzqxFyUofb7pGRH763tNBCmTAOahesbZHn6n6HVhYHJObGyrm6SQ8DgvvgbvnDprlo7CBskvtEqGVHDv9Wld2bfKEqNBCjpVp4Qy9y2OV/h/kXqGtUzPnHXq5uKtFRovmHsPfHGKIXR9IpScYUm133U/K/lbqd1c/Er6P/WdBdhI7Do+tzUpISwqhsCHcslzkpKjfVp9ST7l5Q19vIVr9bw3tlWbfs5z5klAKgwO0Rg+tbLRWPJ6Zhs1N6eA1/QLRTgPxZAgp14Ftar42Dn9oKRFVdYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 11:17:43PM +0800, Chris Down wrote:
> System mapping sealing is currently a build time choice. Hosts which
> want it and hosts which need to move or unmap these mappings therefore
> need separate kernels, which is not ideal. Let's allow the administrator
> to choose at boot time.

Thanks Chris for the updates and for adding the unsealed boot parameter
test coverage! The v2 series looks good to me.

Reviewed-by: Jeff Xu <jeffxu@google.com>

