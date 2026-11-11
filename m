Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FD0606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Dhj0+Yym
Received: by kanga.kvack.org (Postfix)
	id 1CF376B05BC; Wed, 11 Nov 2026 10:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FBD6B05C7; Wed, 11 Nov 2026 10:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071426B05C8; Wed, 11 Nov 2026 10:29:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D74446B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:29:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DABB16030C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:29:15 +0000 (UTC)
X-FDA: 85423221870.20.0860CEB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 552FE40009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:29:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Dhj0+Yym;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794410953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx9iLP78IiBq1ALzjHVMZmBMtAYpZpkd8prlcsOB6hg=;
	b=qMde8byWEgs9lFOEE4WEtnbHpfcac+XshHjO6R9NVY37TnvcutHik5hpjcva/V2S5Bg1qd
	p/ucUg/b99HRFxP4gsaeYnxFK6cFpiFc6ZDhFEEGOrlK1Rw3S6xHZ4w0MD6iH4J4sJKmfX
	aqAE/Zsr2VqkadFuaM6NMpcXFarY2DE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794410953;
	b=CsudsPYkAX170/D95C5IJQYB2pF+zrfyCCPoYASitGnWsAb7C+Jv3Fr63RTtqdpnMctrRr
	449RK1Mj5ioS0djaUhGJ0Pbru2b3ahjAF7DHVR9GCjQpBKEsL71fzEUqN/dTQtQ07LC6fA
	e5PpbBnBSDJ8LzE5E61CKrnbyi64JQY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Dhj0+Yym;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C9A61576;
	Wed, 11 Nov 2026 07:29:09 -0800 (PST)
Received: from [10.43.20.72] (e126510-lin.lund.arm.com [10.43.20.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A40E73F632;
	Wed, 11 Nov 2026 07:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794410952; bh=zx9iLP78IiBq1ALzjHVMZmBMtAYpZpkd8prlcsOB6hg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dhj0+YymHc7rFomknPwPRmnpBiVc9HeX4e1Mrc54aUxPNZzLyPVAjsbvoz7F/WA5c
	 x/6gWKxQMKSaONFtPfoPEoqkOwozaexXi53y72L4XOIUfLKIaabfuCO6VO8rtFgrHt
	 4l+2j1iAJMYNQaTu2anzXCelavKQ28MV+LNM1n5g=
Message-ID: <0b29393f-bb84-4df1-a699-f7afcb50f2e8@arm.com>
Date: Wed, 11 Nov 2026 16:29:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
To: Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
 <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
 <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
 <717cccfe-81d6-4e09-a466-5361ae27776f@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <717cccfe-81d6-4e09-a466-5361ae27776f@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ptwicibpngyuxmu3b8i5ppx4xwg5g6ct
X-Rspamd-Queue-Id: 552FE40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794410953-224293
X-HE-Meta: U2FsdGVkX1+65NpmET9b4eFDxJCQylSo+QcAYKyETs1ZuC5L/mr/18flLWaVK38Wxkwi6n7aa2DbxZqwf89wxw5tmaiuSSzCtP1YzXPkjVcJ2A3rXTENjFDd8enWA+a+Or2ffdvvJA9V/EiOSWZ8vQ/Aej1YoiM/SO/q7mjpoZsDr2nzIABUys4KsA+Sc9L3L7ltcUtC4PTmkguaKmolJwdZLnSsnJxu2uzs9hofTmrsSuwkQTueYkuaK9gBZ/A8jw2eHmyrRuoVPBagsDH7jSwAazSIcEjQ1ppfCpFUYAlEb1/oeDPyKH85bjisTIKLhr5dYGCTiPqb07q7TB2Ml+OEufUQIPzVkP/cP4saaM59WwS1mPAvKOPQp0ehk5JRlVvNKyNAQQU4fcb1ikOE4cf4L24JOcawB7Kt7RHBYGyTlni6crb769GwShihB/hCzsUGw4IKy6SBR5DhMXkegf4LjeaUm7TEerYXoxDy5d+M5bsW5VTr02Hni39mWN+nEt3QHHiHBl6HGKKhieFGjOIFzecpz39kSlwQV5kp+Oho7Sqp5T92enNx/d/UZh4uEKDDqvxDigVPxkT+ht+xwpjuYnS3UoSQHsBI20RmNCruvrURXeV7PSmozx+/dQT+RfFb2sVMztz1feX1epPuvW0rrQH3fUJV3mrN2wfNm/d5x1c672dVTG5rV7aR2K3DWsVyuUP3szYwVBSzTuQdNy8q1eyj6mGjQsC4HgmbKnZ55LPiwgIyfaeeqIi40XwMgdUS8qLl+wIybRuVCsrE1PRUr8qewyd9B0ZksHHGnIcmfNhcDLmthBMrIJgNHnEXdlTFtoxL1bGXvzOBDNtP0aZwgiS3eqPnKAtQgZ1mgC8L1OU+nEaodKqWYpEwzd4CesaLXQh+RbdwUmPDkPRntiJCxHhxkrk/3xEg7YbOIQNwJX5Jn6uWVMUk1GkiynkPLS5F+/b3vqGtD16fOro
 //GBeEgO
 zSW9a8B0LuxV40wwnEiHVOdYespiOaXgyT1UFo3Bbt1oRB1X2+drTtYWW8vCYQakPSuLRag0yXSh5JvmeNrnJl+HeqmdEr9NMeXLT+GG/bmdwqA4mVj78MN0016XS7r84K0eiV+kCce3wwe3PmzOfNSSX6suz7WkK8Hr4VGhEUZIXSRgmzLOFY8hUbxLI47XzslkubDB7aFoSxKLFNIauQtWqEVz/m7NbTH0UqT1vg7vlrKr9KFhXMn+MmN3diieFkuvd52HAxvatcQjQR4SPYim9zXp+aUobaPj4RiJNxJGygF73W9hUN2iwo/XKXl9acft0tNCvCpTTfxcXDhw12wHxv4ZnlBarQ5wcvRlkg8dPv1CcrllQnrM7IKCmcz+E5/TFiaEG/3J5iaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 12:24, Mark Brown wrote:
> On Tue, Nov 10, 2026 at 10:01:36AM +0100, Kevin Brodsky wrote:
>
>> Do you mean adding the dependency KPKEYS_HARDENED_PGTABLES=y to
>> tools/testing/kunit/configs/all_tests.config? Indeed that would only be
>> meaningful on arm64 (for now). That said it wouldn't hurt other
>> architectures, so happy to add it there if you think that's worth it.
> Yes, or something like that - unfortunately KUnit checks to see if the
> config options appear in the configuration so something that vanishes on
> other architectures causes issues.

Alright, I guess there's not much we can do then, short of creating
arch-specific fragments.

> Perhaps the default for the config
> option ought to depend on KUNIT_ALL_TESTS?

Not sure I'm following, the config already has default KUNIT_ALL_TESTS?

- Kevin

