Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30A3EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240BC6B00B4; Fri,  3 Jul 2026 05:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218AD6B00B5; Fri,  3 Jul 2026 05:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FAC6B00B6; Fri,  3 Jul 2026 05:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB4236B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:30:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63D11404A9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:30:46 +0000 (UTC)
X-FDA: 84946945692.25.DF939CF
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 947441C000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:30:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2YS9x+o;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783071044;
	b=abxIrvog/5spf9kXsxbIAEm6lV+JMJYouhlpcmrdpfgA6m11yIl9GyfCLjTZa6SUJefsS9
	sTUAV12KTg5eUaLmOG6SjMRDMpQlkbIV1Ud3Gdhax220I0qde4nfX47yPUeevCoT97dJRq
	cYC4mwKt6Ma+fKCBboxFUYB+cSIoOzU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783071044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuj4UnMGsBwq1kBf1xI+PfS24Rf5Ofr+yXc48b8F1fE=;
	b=MOFBwmi1WJXVg2cdNY6vXqHZwnOnutCwp4tsd577F7SNSrQxIv1HSM0e6U/6MCMGSaoEN7
	RYFKq4ORsU9BP0z54226aSr70iymvHkksJ/oRXQWxaw5xzRirh15+w8aQDsAvtq+L+4Mnt
	LaKY8f5s4WdXoB8dcJZqUf6s5dZ0028=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2YS9x+o;
	spf=pass (imf18.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783071042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xuj4UnMGsBwq1kBf1xI+PfS24Rf5Ofr+yXc48b8F1fE=;
	b=i2YS9x+oI5i8+MyTYtWwOYkr6wUeX4fu1pD0OLDQjFM8j8c1uzq6HpnDniVQGTpplZC07A
	Ga9w6Xvf9t8tN7PxQoaSkIkLf1VeSqB27A7LBxT7+Yz7KjMYNTToXx87Xu35l19yF+qAXi
	PrEr8oKBtNF8V6/Xlzz8crHEoXjywr8=
From: Lance Yang <lance.yang@linux.dev>
To: leon.hwang@linux.dev
Cc: linux-mm@kvack.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	nathan@kernel.org,
	peterz@infradead.org,
	ojeda@kernel.org,
	nsc@kernel.org,
	tglx@kernel.org,
	thomas.weissschuh@linutronix.de,
	aliceryhl@google.com,
	dianders@chromium.org,
	gary@garyguo.net,
	linux.amoon@gmail.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
Date: Fri,  3 Jul 2026 17:30:32 +0800
Message-Id: <20260703093032.51640-1-lance.yang@linux.dev>
In-Reply-To: <20260703022507.187457-1-leon.hwang@linux.dev>
References: <20260703022507.187457-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 779khja1fyxxj3njo9rhbfmatr4e7sf5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 947441C000D
X-HE-Tag: 1783071044-346883
X-HE-Meta: U2FsdGVkX18h398A3ainu5r09xtoTRxLiOSCX0OITalj7SK+Ro0S2s102nDt1ospxMjJlECNHO6JZhFqyWnEw0uP9HFLVqMMwdGua0EgYPLLWoAsCErsxcSgPKXfua3fhZckAaIZ8PDLqVIYQWA1wH8yIysHkOW7JdMMTIRlI4dbtgGu5c/lt5EbuDOwkMCHdPWi1iJQGxYgN50YEKJSyUlTsjFl5ERBXAxETPmskKr0jXQijDyFRnbbBkzrA2/pERWsDlmtMxonl8OxFR7lk4f7GONCLlgk3Uy1UIsmzljtNxelP56K4zK7SfQcA2ECcIwOcoB6tOW0lLaXLKODSzPeffPZGp5OI+XLdEt8whtkFFKCKZJjw8LGqTdmtylBDM3n93Ugt8MtX90vgQZcM/xxos6wXIayNTARYrGYheAkcfPAOJhG3O5BtIhtH2CYmbw7+qUmFFVew1hR6Rz9XFAvtSDLYxqZPqI6Ugj1LDOVLYoJljfx+FXKtvdijHnVnfBohlnmxclgnJ8YuL9XADJ+kugMfDtpYi7gcOnCGxfH3KKsKA2WnLdlLvxklZ3nDuKnxCcPSPDdtWSU/mv4uBtZ2/EWuqxvNSpEIxQ0T65z+GDIBJwFaD6e5GNT1PKRrHJR5CxmEPsS6ZAz2KDjZlIUNqCRpeTglGZncRTnWU5lZWicYDCK6b1SVwdwYPZv7f18Ggrtu1unohhkSBnkxkILhMPk8GmyezF37YXlwYFRa8qMeSL3pOU1bLTO+PNpGbq/G4Dajvj+F6TTJUxy9/h1ytHwSbpMrR8tT6nTAMJu/yDlKCZ/77JXqt4dobDEC/484/Tk+7URbh3nVqXSR/noN6EwsbjYX6t6P2OvQeQsMIyvP4RhUkEN0gjeoJBw8ZlqURAVTOYW37pfTbSazVF6X0EFynD0dsGZECVM8Fh3UXkKqBJ6nLYXB2glmkbV2CqMBcEuSDGwd2a1kEU
 4ifmn2u6
 3DV6YnrNzxXBfNGYTpW0J6ula/ZZgMcQUnvKDubyeqe0ROty4F4woLlnR9m53tk0GBOkuAnIzbyaT6Ps8TW9oiXZxZrcqE6BBevIzTFNkcF1SAcsoxzji95KZs5jMe3l/3F7+TBqqUHIcWpR+WeztnGpLRi0Xa/veLA1Of0+3lfdXDd4Y4H+Oru3hovF8w4ompk6tJXyYWauqjBrf+ZaySmBQDlUP2ZS0jP2mtI0TGcJHJtxUQwwypRXdmD1RxHM2WIOB0R7fbiKAP5SCnZ64vxgKY4s+AERsBTgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jul 03, 2026 at 10:25:07AM +0800, Leon Hwang wrote:
>mseal.o is built only for 64-bit kernels, so 32-bit kernels fall back
>to sys_ni_syscall() and return -ENOSYS rather than -EPERM.
>
>Document the -EINTR return from mmap_write_lock_killable(), fix the
>CONFIG_MSEAL_SYSTEM_MAPPINGS typo, and describe system mappings in
>terms of VM_SEALED_SYSMAP.
>
>Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>---

Thanks, free free to add:

Acked-by: Lance Yang <lance.yang@linux.dev>

