Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E71CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 08:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F0E6B011B; Fri,  8 May 2026 04:33:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FC16B011C; Fri,  8 May 2026 04:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30E816B011D; Fri,  8 May 2026 04:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2050D6B011B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 04:33:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DC684077B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:33:28 +0000 (UTC)
X-FDA: 84743588496.20.0FC4B0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91122100006
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:33:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcYw6hOb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778229206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sorwwWWo+9MSikucD45VXyWOG41ehrmHm+rXIMQPNk=;
	b=eV+2dD54mwpvstNVRE+wZsNmDpKjBaUIZogYlsbymNVqAw4S8ItkIj1aR49pGed+HCG8RL
	eXfCnH+WTz3l2DQEMeR2HGqeDO/7jOWnjXIC7N4dmnspvfEkxTcIRUGoT0vyptcAt+wdLx
	7UHpqwVYoQXe/1MVugJTXGnQzgTXdmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778229206; a=rsa-sha256;
	cv=none;
	b=f78AYiKoQVnh6lC85Sjwr7lmyEnS/9vFPeeMSJQ4nV53uSFe5T9X3i3VHtLN9enE3IIz0d
	h6SoAD5pWiEQr8fzAnK61Y/ZYLNs/k9zG9bP3jXbjX92G8cSVj3gxsfAUeV+TQ8b0vy+1R
	auW/NYoiYS5HKFJnMcu5dnPNXTWY/Uc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OcYw6hOb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A94584151A;
	Fri,  8 May 2026 08:33:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8315EC2BCB0;
	Fri,  8 May 2026 08:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778229205;
	bh=pZp2z0GIEWKSUFmP4M+hDqonwa8x3ouGP7KpZ9sTJho=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OcYw6hObQxKA3TC0xTe+cfov8Fb5qD1VqNqoyvXtXyuGteOL3lP5k9K9Zuj2K5C0M
	 48+UAEskYdvStIktEeYnvuDIzPLPUa5On3vpfhtU8/ibJGpyNdq5y0DnS6kdW6147S
	 8Hk57m2fE0LdPEv9TQrZVSSVPOwKmV1Emy2WWQPBExv4DegLsmQa150kFciAt26IKy
	 3C7Lg30rrwoRW0tBJxVNrrS/5HeFh5x297HKUiaZ/MQ+XMqPXYamqYLQENzZRHQSIb
	 N7Kr1KUv6OK818F5zuYvuiD46TEfSbGq/maHZTHp+z/gqXZrsf+riMEIledtNrCV/H
	 2vpdFEsTbkyQg==
Message-ID: <b1ec6c2a-b198-420c-9ab3-5ffad7f8b92b@kernel.org>
Date: Fri, 8 May 2026 10:33:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: tolerate NULL unlocked in fixup_user_fault()
To: Stepan Ionichev <sozdayvek@gmail.com>, akpm@linux-foundation.org
Cc: jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260507083050.416-1-sozdayvek@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260507083050.416-1-sozdayvek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91122100006
X-Stat-Signature: a1gkpeqiprxfnfwsqngija9kf3um5s34
X-Rspam-User: 
X-HE-Tag: 1778229206-487623
X-HE-Meta: U2FsdGVkX180tY6skp0Pgla19qzYvlDeIogagk2AjGrTwsV41hxy2OrKVVMVKFE+IzO82+h/BSjDOe+iowrBceC8rjDMmX0LIZdxkoVd1Luq2HNFbEtg85Z/c2bwZFyBd0xip/QGbSojQ6+bUHHCFEnv+bQErTXmAdvSD5HvQ3BFZcyke1oVZCQ/B3cY5WpeR01c7lSoPBWPGuWEMAO3S8AEsgEt38wIyDUpB07/S8sHwlU0C+IfbPzT8ynodtYyReA/13iS4GZ2v6wdIITMd6GWg07fVtke0a5bM85rlq13/0ZXMfacqNi5h9WHIk202sATLg28k8/PuYlubQoeiNR/CfVPGi4r+X3o+/hhlFSqdazHtObX0VO8uAFAqJegGOdKUyuVTGAH8Xxt+X517vFpIhg9HflGsvfrohN5O8YatJPFwVc1tI+jq1ouaG4cvZEhbWbW+LnhJAc2DXiTioiZMD8QLDIVXHmQJM4CwDO44U1m25y1ILtINQP0G+c75Ft3TIWWxluSf/bhMy3484lJ7QqBvhHt/A1u/E1wNs2QwUFOZjUS5Idbmnz6pda7yqtkUgL+gL64hekJGAkuOi+/759PgQnsu0ux7tTRnCgvGzFutM/8qmtKsRiTiX3zbDXG4n7ddCnueTx4W0TyKM6ED6xY725VK4xA2WXq3dYcUD4+N/5B/8uFVaQk2Qjr0ZB2dh+jSOQTWR+BDcMZ0mlzE474TtX3Rgk3izJAFCDPZfCQjXFjHUODgb8OOGd9KdbTHwQBkqWw6fC63B+A1H07VMiG860plJG5UwXtH6EU3U75qktwWj+JkN1ztksNaQymMKIF15gYEeTzAxsYqcf90iV3UNmPc4bO2yO6HiAIv6dUJ2JuLPTpkcBiCEkR7GyMT9fcmmscclyqeZPQufbJa97W2B8h4MAGd3N0omDVv5eQvcL3Lk2U1QoTG9x5iMXHV0+23pbgS4wPfdL
 Wir3Ye/p
 uc9LrcDZKhDgP+IgSPwW7L5t7tqYHaHR85G4Svmvh2sjByEgXfeZnxjRUopISS/EkQC08heYerQGNPNDBu2UxsW0rmdVTpc45nhwBn+zVSrpcz5g9X+eS03NcAybOtYPh6lY137ZrwUREtYa2k4GZR6EToudRM/r5TjMXSBLyHIcjW2Wf+PIny7TK10xdyiPYRhgrYCou8u03ou6d43srCtGSBfFXjnpVopbNtvv26Klm8WYcmeaDKg4tSpnNPS89wB6HeRE65AJSMlGtB7lSIwP/Pc02lR0mUTdl2b+mF8CU7ge3Mr8ds9qGlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/7/26 10:30, Stepan Ionichev wrote:
> fixup_user_fault() takes a "bool *unlocked" output parameter that
> callers may set to NULL when they do not want the retry/unlock
> machinery. The function honours that contract on the way in:
> 
> 	if (unlocked)
> 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
> 
> so callers passing NULL never set FAULT_FLAG_ALLOW_RETRY. In return,
> handle_mm_fault() is not expected to produce VM_FAULT_RETRY or
> VM_FAULT_COMPLETED for them, which is why the dereferences of
> unlocked further down used to be considered unreachable.
> 
> That invariant is implicit, not enforced. At least one caller in
> arch/s390/pci/pci_mmio.c does pass NULL:
> 
> 	fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
> 
> If a future change in handle_mm_fault() ever returned
> VM_FAULT_COMPLETED or VM_FAULT_RETRY without ALLOW_RETRY having been
> requested, the unconditional "*unlocked = true" stores would
> NULL-deref and crash the kernel for this path.

That would be completely broken. We must not drop the mmap lock unless
FAULT_FLAG_ALLOW_RETRY was set. Returning VM_FAULT_COMPLETED/VM_FAULT_RETRY
would mean that we did that. Broken.

And the function documents "If NULL, the caller must guarantee that fault_flags
does not contain FAULT_FLAG_ALLOW_RETRY."

-- 
Cheers,

David

