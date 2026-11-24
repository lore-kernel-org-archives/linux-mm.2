Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB947606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qzcn8lON
Received: by kanga.kvack.org (Postfix)
	id AEC506B0842; Tue, 24 Nov 2026 13:55:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CAC6B0843; Tue, 24 Nov 2026 13:55:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B086B0844; Tue, 24 Nov 2026 13:55:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 677B76B0842
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:55:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D80931C47C2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:55:27 +0000 (UTC)
X-FDA: 85470915894.09.4CB612B
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB46B180003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:55:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Qzcn8lON;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795546526;
	b=qrCyN0KIviXVyZMqizUhoCDkJthneN4OSqttW4abSqIhiYNYSChe2QgzgRGEXTCFJ2mSUw
	N2XhUMp8lUnN/91XJfztiZSU145ui84IPzwvkHuoeSlKJKfQHDRjq+WM5LED5aDpQ/thsG
	1TjrZ0RcL8kfH7Q3PS14CfuppTmrwOQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795546526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1u8Dtdr50GkWxwr/o6Art46QnZZWoGSZDLZvedZdu3g=;
	b=yhwOgWCCa1Trj4mQaYgWgrhQ/fYQYQhjw4cIvPtMbAQKOPNyW6zVkco1pFsYTUHJQ4mLYi
	3ODEfEgLpFaouCdWVm6qDlByZ7GhXyVDYrZ2Q8h5QZYJnq5NAJaEzTGuZBJHP+P3nzdkKQ
	8W1KQ7HoguvkWx19pfyLlyP5OI2kTbE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Qzcn8lON;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a018493d57so194685e9.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:55:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795546524; cv=none;
        d=google.com; s=arc-20260327;
        b=E5K0a3vXS6ScjvLXCYeTG/QEB9QmRECzJZ2MhC7nchdXFP2Zfrt/211HEOnIOoxVhk
         5obFq2YZVjC7ZLdKm1oG2GFiJc4NHu1vFqzNWTGU3sYuvuOxjAwC+x8rr/K3e3RSL2aY
         bkOR9gZiZ2YUFKA0UCC/ssH38k1HESaAYkVo3XRKm173f645fGF9ETw4eoLpwtKA3MjL
         WeTlgaY+XYuwk3pKpyvmgWh5Z0qyt1tyJlrLH4j/AvAdjBC8Jv4qoP+cHKRrpUqvhnw9
         NK/uxSWRDIwDTl4aYAIWDncX4sPPXBZ8FW9NEsDHiLdGQVDWXUhZ+1H3AHzF7VrQxiPL
         XwOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1u8Dtdr50GkWxwr/o6Art46QnZZWoGSZDLZvedZdu3g=;
        fh=LwoClKgqbhX8cotYYkq0LoQtzSbVfMVux8bYgiT+xR4=;
        b=N5jQWMTH7JHvip7vFof0KHa8/qJ9mFbzDjU+uMdLMKAkqsdXdNr7d2wbJGoEx35h9M
         kl2ads9v1Q/wpGIVAFgAUM6U43ukdH9GKI2PoK6OaI/4EP1ihM+U9UH/W3CslofpqCgy
         +xM9TuR/wgCXjzZYDuoPNA0ESbrCpP7dphI4Yjy6yFn5FxgloSDfU3vYAQIsS4G9eTS1
         ye3+9NXi7RQaP2jUGZRkCW2zzYUm/dMvegoJsixz1YNYRDJLwtubNXGifpBzPzeOSXLn
         IuH6i+uZZVEdSw/cuVcI4x2uYRbo6hTDN6YIM5r6o3eLr2hkjdVTF/iIPOXsSSn6doZM
         WB7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795546524; x=1796151324; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1u8Dtdr50GkWxwr/o6Art46QnZZWoGSZDLZvedZdu3g=;
        b=Qzcn8lONYGfhVFqlw3XOpvFQxZReXA4Vm2VNC1Q3AuwnvP4d2dAwY8N86HIYeI5jai
         krh4+OwGMUl5T39YGRYd8VDfTVgSG6k89Rn3ITirYb48jbDfonL1nv5bUrQNqgJQwGcf
         gSTqZbjn2rW3FLaPtVX6FdAvOkBM8Te0UYrQprwPlnUa56VYFa20XYmCg7LJrXGELFHb
         KuhBhGgKbl65SWsw9kE0GbLiG+zt/W+ZaIjU8X4R35A7Gk1iezoKbepgYknhm9Dcgbyv
         M/trCeaxlBhHuR/gHC6lM27xZOF2OANdgoxqEhLQGtyqyNd2x5oQNcEPOLF6nLMVpfuX
         393g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795546524; x=1796151324;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1u8Dtdr50GkWxwr/o6Art46QnZZWoGSZDLZvedZdu3g=;
        b=HVrqc3PZTYqtkCkmQBhfOc2Viyugj+KvCqG+ERd1DW02o+lSZmjYQ7K+A0wrSYlQxh
         mT59cD7YB8w2AS6Sl+dsehv66mPl4LQyAatG8rd0V0bOHpN/MPCwc9kDQZR9++URn/OW
         lDyK2SUD52ASEhyVrhgV8S11COsodAfTrsdXAIMbgYG7qeOecxG0oLnvlMMcFLogFgiw
         WRWdurH+zkoeUisStW+E81ScRD2DqKNBcmj0BWa9TDRtic8Joto8KS8MJMh2+gWOhOCq
         t9A7tryOYgSaJZDDuj8DQzdIfYsuGAO/SpELBeAtPjEv290jwNJph88SFXIlc3pCUQWh
         UAbw==
X-Forwarded-Encrypted: i=1; AL+hErHBMuIxsnvcIRh1oKoPQQNXn9syxP6rZ0RXZUMU20bdjzCehMY7WhpnEp3SJh2O/g/fipwRSfP6bw==@kvack.org
X-Gm-Message-State: APuU4Z8791av+Mdbkn4t14MpKflf/GsSr1DvGEO8EE2hQLtI9cAhOAxt
	myu/H5ScP2kz0+mrxyR0e0YQYqkmNQGur9K8Mb/rpnaXJ+TLq9oaziTqp0rw8PxZccQ8TPN1bgn
	jf4FsudWLd7LDkew7exc0TgctVC0McHqBoias07Ae
X-Gm-Gg: AZFdTZd3hyyYkQrIhGeTNTxc2CHbiUNFQfZA9/A0WUAtL18VXQVwSTRXrZmB7eCqbrF
	a6BURTC+8LRaufbVKTFxCkU7b++zwV0icSF0BVaYDPyn3neCDqtctYWws/0aSSFZzB/wayL1dB7
	mqCzUx2p+KO8csaVAxlrPN185cDHoEwnngqSPLcqNOnMxGnIw2k3lzK8cghMNmAOSnZyyJeY62w
	v6vfaKtZk8+/y3+nAqr7CuIHngYO8qwI8ZG1dVNkUvaBHPssyXhYd+o4Hkna8KBro6vzNKkDWyy
	kNBflk8tqdfapQcsLrs2FrqZU7NW431rV6bTD2QF25a+03PfiYK1JDwB2ojdzDM4hO9VQzPGbCX
	f7YsQid+NtTymGiK7NsTz+i8+rAJ6we0omwL9XQs3rSuJNHZiX4v0Rxic0AE9med3dZgpS+JR8c
	RcMnlZQ+YyCHAjphKIWM5G+o4B
X-Received: by 2002:a05:600c:608e:b0:4a1:e7fc:fed3 with SMTP id
 5b1f17b1804b1-4bb916aef09mr3131205e9.13.1795546523926; Tue, 24 Nov 2026
 10:55:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org> <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-3-276007e73bcb@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 24 Nov 2026 10:55:11 -0800
X-Gm-Features: Aa3M54rcD7lAjqTBZlWobdm479k0AAUvm_iZ5SlmrfOCMEFaBN5uZR2IYPu5xbA
Message-ID: <CABdmKX3Cfv9wO3SuzYOg-+UXC=BOSAAPRfMQUAep6JStd0DjUw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/memory: do not report OOM if insert_pfn() races
 a huge fault
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
	Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: DB46B180003
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gjoqgtfsfamq6eknk1wy838bb1e83eb1
X-HE-Tag: 1795546525-741238
X-HE-Meta: U2FsdGVkX19vcoP5GjDD5gZ5MAV3U98tnpv7O+kioGTqi80XMXuyswfiWmrl5PVHi9iWvGuGZ7DBhUnmL910gITxiuN7uIKjub2J5r7CysqXC+uF879Qrb04KpNBzcbdSPoFjqru3PibCcmZ57lbibQ4wQxwPP8IFlPjtsKfpCHlGPXO8D89X8VGlA+Ukq5yOq5hMS3/wnY9JEeViKVGkADVUn7MlUOH5YrZszUnL0e/taTgIcdYPTzuCq2lN7JFu2mZShja7NNu4K+nzxID0HTO7z0HnRtuIq6rVkj4CwyvBDs2et6003CQ1bhkb4WIXjhYKbKvNwBTh6USO90hSvIx9YzpsiKQuz8e1fwZcbBEff2lVuu+Y1srxrvRjUEUZMxM9pW0gWrwL7ZmQ+A3Tnvc0CmTouieexWnTGEZ16WEXRp1VK8jNBrOlS0teQ1nfjN+qzqCiEiznoCzHRNTQDzXVwrBOctui2OIuFYW4EkCZRl3Y6sMPTaqEIaDeuSIpNURuu5cACYcY9zWeBtFHQM6UG/iUjtObX+OzETQgcbIA3gYM7Eos0p3wdcnGaCdhul6XH33/XfmozyfIWCogphKFMewSTZ6B80F7XDqwRWyffWc/LnW/VvWPeza2TRegLfLQGFF32xaX43fK1NHR2vV7ICBPhU9XtFzdztLADWMvcY5ugeYot8/AVasDBuUIPjQ5dpqR+TevOheFmq6Jeg2LqRkWBIAI0T+GZa4Alm90NM/OIpDeGvbxrBo1NhVBE164KHzu9+4ASgXP6R/cDrXFIf6+bF//ytrrOfBcBtzgcKJEvkUhHBaXCkP2pNJFipEBdv4SwteapvoHJoCm78l9dbY4uCspEXrwcYdCU9r0cCZJNwdTAMLUtSdC0VeTWAsa+iJBN5sgiAR3xjtMsbZnzAAgAJQU+BaQaeiVRnNO00zO76vbP9u/+oUbVW/877R6zc/KTKhgQyv08J
 ETwXwJgx
 WYhly4GFl5nvrUEF3h8fDn9udpyE1uRjFYEe9vj6y8lO8u5q8BdMLqj7Mz6VANkoak5CCjJm/z4K7rUwyWvcTaZLx/wlHEJDhtG0R1W+i0hPh6yFlkaHTvj3MCnA9SgJiD86URYh602pzrNYm17tecEIZ+R3jreMgDP8I/BnX8x4fLnV65UY/bb45vep+8iGgiqWSsFjIXeC5ddHZzF+2nO1FoSD6KA6Y0BpfcNPqI4ceq4Vz83XCZdfRXSihVTWH5nzuM22tiQsBs2B37qYfVOBMDzo6PjCXlRyCbpbAnjN8hrxqJteNupKCpPpCU0PdOcnJwqjmu1jaXD8r47iOsXZec9VJg8+udq4T6R/Y+P7m7DZRQiXCvA8wErBUT6uuC/OpLITQwXC7wCGx9p4jHorKbZqIbZzmM1cPtQSJ7vN8W5fNH/8x8+rb6Q3x1wRnALWghPV3xz2o5dtmerHblWkxqfP01g6FD2/92j6Y8AnTe+2skqmNDNMiJJxrAsSR6DvoIddF11dui/Xysqwz4ASZelfP0gW06uJ3WYVlfeyuMY4L0WCnufPpjXn9jOpGmi9g/BQSM6KlPQU/2Va76yMETMMaRzvD6rkE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:32=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.=
org> wrote:
>
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
>
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
>
> This is not currently safely handled by insert_pfn(), however, which
> obtains its PTE entry via get_locked_pte(), and treats a NULL return valu=
e
> as an allocation failure, returning VM_FAULT_OOM.
>
> The issue is that get_locked_pte() also returns NULL if the PMD entry is
> not a page table which can happen if a concurrent huge fault installs a
> huge PMD entry between __handle_mm_fault() observing the PMD entry to be
> empty and insert_pfn() being invoked.
>
> This can result in VM_FAULT_OOM being reported incorrectly.
>
> Fix this by introducing and using __get_locked_pte() which returns -ENOME=
M
> if a page table allocation fails or -EFAULT if raced.
>
> This allows insert_pfn() to return VM_FAULT_OOM only when an allocation
> fails and VM_FAULT_NOPAGE otherwise so the fault is retried.
>
> The same change is applied to insert_page(), which only impacts DAX (whic=
h
> has its own locking).
>
> This means that insert_page() now propagates the returned error, so -EFAU=
LT
> in the case of a race. It's not possible currently, but guards against th=
at
> changing in future.
>
> Similarly, update walk_to_pmd() to return -EFAULT if it encounters a huge
> PUD leaf.
>
> Target the commit introducing the first driver able to do this.
>
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon=
.com/
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: T.J. Mercier <tjmercier@google.com>

