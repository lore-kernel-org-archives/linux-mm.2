Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74946D4337F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 08:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12996B0005; Fri, 12 Dec 2025 03:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C35F6B0006; Fri, 12 Dec 2025 03:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8FD6B0007; Fri, 12 Dec 2025 03:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78A916B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 03:15:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0EBCD590FC
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:15:35 +0000 (UTC)
X-FDA: 84210109830.14.A1ECA21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 712D340006
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:15:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nFeJPvAg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765527333; a=rsa-sha256;
	cv=none;
	b=IbVsCUX++M+7e7wsRsUUGplndYFSHUrw22pwCz0cygUvqoFPd9tpmvAyE6yFnQaRrbKNET
	f2HmzvpQVS6thmrDHZMnJ8lJJx7FxZVP72pPGSc25mtE7wvzk32qQEemUvTXz0mBgso61L
	IZ9ADRcuAMtlSxtGbORM9+2Bk5dj0qo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nFeJPvAg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pjw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pjw@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765527333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1j6qK1ou9ubXbo/lxNx6h0TYotPQM1WkeQL02X+8Zc=;
	b=w9IudSZoocFRC/v1MUxq7/vv9gSYPbE87Ht+uoTq1JKTS1YRYNHvbNYgyQ9ERm5wqt6/ic
	gUgUu41tAar9TSahsWCqe1vu1nfiVYRAaIghMn2jbY5a5cM4yhBnUPUJEcKsGf8ZAUYRc/
	X1uz47sHW190Cw526tofh4NRslLSepM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CDFC60123;
	Fri, 12 Dec 2025 08:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38DDC4CEF1;
	Fri, 12 Dec 2025 08:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765527331;
	bh=/hrrCjWB7RCTyEWEeMlOdi0WwTl2Sn/DGE23XvsAA1U=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=nFeJPvAgpE2u+HqSBX8PIxPmMSQ17wJNJelCCJFq1uX7BJ4kkZTE58a4A/8W62uDv
	 8dCoi9GTVmIMujcz+AOuXNHyzOpNdkqYb0DKCTnbVN5TLfcAkHHk4X5GkOY53+fRgD
	 H2vRj24tmoDmCl8w/eVYpZl4Jls0dlJuEvEZknT2PTiKXaOtE9hzu2MBmaeM6kr1j/
	 ogHmwcJaqT9Ixl5mvdquTPY2dsBps1wEREysFISYUzN+OM8KsbYw3C3l1ZIxq/kU5p
	 WRGZq7FJYPTT9l34JbOAyhRb6Au3e9WpMLWJE01Ek738rPu9oBt8WFwFmkHSBIxHo9
	 YRpD801VkVqYw==
Date: Fri, 12 Dec 2025 01:15:11 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: linux-riscv@lists.infradead.org, tglx@linutronix.de, mingo@redhat.com, 
    bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    akpm@linux-foundation.org, Liam.Howlett@oracle.com, vbabka@suse.cz, 
    lorenzo.stoakes@oracle.com, paul.walmsley@sifive.com, palmer@dabbelt.com, 
    aou@eecs.berkeley.edu, conor@kernel.org, robh@kernel.org, 
    krzk+dt@kernel.org, arnd@arndb.de, brauner@kernel.org, 
    peterz@infradead.org, oleg@redhat.com, ebiederm@xmission.com, 
    kees@kernel.org, corbet@lwn.net, shuah@kernel.org, jannh@google.com, 
    conor+dt@kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
    boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
    a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu, 
    lossin@kernel.org, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
    linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
    andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
    atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
    alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
    rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
    zong.li@sifive.com, david@redhat.com, andreas.korb@aisec.fraunhofer.de, 
    valentin.haudiquet@canonical.com, cmirabil@redhat.com
Subject: Re: [PATCH v26 00/28] riscv control-flow integrity for usermode
In-Reply-To: <176551861579.2032148.13920544388182691102.git-patchwork-notify@kernel.org>
Message-ID: <b9991702-44d9-1f0d-e5c8-677c404e2522@kernel.org>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com> <176551861579.2032148.13920544388182691102.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 712D340006
X-Stat-Signature: aoti94gikdin5fcazewa8tp7xsnxxwhz
X-Rspam-User: 
X-HE-Tag: 1765527333-29976
X-HE-Meta: U2FsdGVkX18+58VOdyV3S0fkMxUg/1qrwgFVrrwUfzSxRfPhg9pbV9nsMkRaBut/Jbc5xHl4bvtT/o3h9tmki3F3BmVbTqzKL2QxHF2EGtXWyUUJvYzL6hcmCRBOtNEfvh4ZAmEQMf8y2s4Vun+F0vvJVvSj0HA2md3MbWxZvZy2gr4FhZQUZKHVfCGb60kPhMkQ9asLoGjKjx2neAE8TnoKxwPMwe09Si1iLTHnyPLYN9yLRh2vK8mAOscknt+lJuocNdheLpffqvlHHBVbSKsXd8Hm0VpMCtZgIRN8OlDzHoL0Tb2Bo13iijSziE5OPu9MoopC3U/M8h4vObOCRLJX1FDthBH/EmjFGVpA/kRKwEF/0UatAAJrcYWCwyqzDRGGPrzERBZYxZIs6j2IOPpWIM8Lit8otT0vqUu+vq9JYON7JyOlNBjpD3wORGYKamDZ/85B8rGxsi4+16V0kmpkZF3pZ6338Fzk2s3KPfDDpsL5i5/RSzr3iZ3zPRJKho3WM6aK7Gqj3gyhVqgwqQM3KV5Br/OAV+JXf+AkMyHIS9OezpH+jPEO5pZyKyV0pKDS9+9VgCPrZ5q8EAFoRBT0rtMe47e7+kfH29PtspblniOfnOGx3M3rKUla1bxQVTVckcy4QzvR7MWC/diYTZNG7bAH3CtHNPCTp41EPjPphtCf7IUO7UZAlApYlTe6PnsFeXoDsKWRzogIo6p2AEvsN3CVKBFssYNNCmma7CMv3iuxFEn0l3eY28HAiu9G00nmX4Neg2VYB8zrgYDndaOVBxoGmRBu/+F+s72pfxzqUrW4vFZBPCZ4QlOWBv3Lm3CdoWR6Sdey75BYUEQl6aT7jdzCT5oNf/C0h5f32DI+SKolGitTmBQ+DmZbC6wfPP8iDCUNtyfTgYOCcbWImyC1uAGi73K9cMlAv1y7s4ouOb/DmdUi5spS0LKa+FnLJ/YVL54eV66kGpWnBhd
 kkjX3dYr
 qFgW/JOKSPAcGNoiLC4nn1W5Dyrg1e7y4uQ+V/gW+ql/pHOqogEo1q9WkKAwfNGsi64meXZRLGKnhtz05wV9ylF5B/Bq+yJeLZaslGeMEJsOGNNvI1XRfaBuqJDOPGst5bgcmvn2N4Yp6JMjniut4NZiUfQzzalXuv+JpqCptTaFMMfPyqLTgMNCeZRqSi15ANxAlJdD4SRW4PA6Sx57jt21KIeeO3KtvZ+oGj79NPnzw+ibM+rJ9vToOGr9w5RxpiwK9UFvnkX0Yg2LLp/6JrSiPiNcSJftTYiycx9ItTyUd6hLT9gWKv7NQGFsTYfRyis1qmRs/XYnAVUihMprXbukbjDVlOlBj2EzT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025, patchwork-bot+linux-riscv@kernel.org wrote:

> This series was applied to riscv/linux.git (for-next)
> by Paul Walmsley <pjw@kernel.org>:
> 
> On Thu, 11 Dec 2025 09:20:33 -0800 you wrote:
> > v26: CONFIG_RISCV_USER_CFI depends on CONFIG_MMU (dependency of shadow stack
> > on MMU). Used b4 to pick tags, apparantly it messed up some tag picks. Fixing it

This is the Patchwork bot getting things wrong, again.  

What got repushed was a slightly modified version of the v23 series -- 
with the non-code changes described here:

   https://lore.kernel.org/linux-riscv/176551861579.2032148.13920544388182691102.git-patchwork-notify@kernel.org/T/#t

Deepak: as others have pointed out, you shouldn't be sending patch series 
during merge windows.


- Paul

