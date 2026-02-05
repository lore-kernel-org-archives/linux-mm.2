Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F45EEC1EA9
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986566B0089; Thu,  5 Feb 2026 07:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9304A6B0093; Thu,  5 Feb 2026 07:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85DB96B0096; Thu,  5 Feb 2026 07:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78F1C6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:07:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49C1F1B282D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:04 +0000 (UTC)
X-FDA: 84410277168.26.9E4CF31
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 72545C000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:07:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2YRhmKq;
	spf=pass (imf10.hostedemail.com: domain of 35IeEaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35IeEaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u+peTVHK2V5GDnlUQ9nOUzZqoANTtWMS/ko4tHyGhtY=;
	b=E665BJzBGsvowK94IoNwr5KZ6Ly3R3V5aljV61iohDqZi7F2Ozku/fb76bLICcXCY0IpXW
	Ko8GxBeQ0m7Qdp6wj+lVzHCl+eJTGkOlIs2ktxFARQNpuCA7y9tDfe6QGgngckKqpeuT+X
	6+HQCrsGlxZtKVSczcLqzhv1OwN5zpA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G2YRhmKq;
	spf=pass (imf10.hostedemail.com: domain of 35IeEaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=35IeEaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293222; a=rsa-sha256;
	cv=none;
	b=JC9/kiD+e23YCHMyrzE5zWY1RUo9GK2Ii2qjt5Sj+Pi2QrU/y0N/MbSDSeEi8V7sYcV9EU
	u9cm1eqfeTxMeCGdRPB0i3mIxyYiYKvO9t1RhFKdGRWCd4jRfJc0GS45FhSPiKtN4oZ28P
	BllQatBwyVXTi+VK23+Ff1K1KdVccq4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483129eb5ccso11466315e9.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770293221; x=1770898021; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u+peTVHK2V5GDnlUQ9nOUzZqoANTtWMS/ko4tHyGhtY=;
        b=G2YRhmKquxm7j+R2lRoSplWdpz1JIBVIbTJXgM32E5UG9nJNAZJREPAnMus1P3v1QC
         se+SRLccIcN2GqyS0ordnLQgdZw9sD9ubd6WyLxhGjp/WkIafRVFIxngSLrWOcJACLLE
         lJJ/tYTUIHuPNBYD3n1Lx6vNib/GhwcTw/eq4lSs0z8fK0/1z/SttXqlGk0jpH35nX8h
         bKOtoOqb4I8qLw8gYt8MMyw5jFQOlceX7ChfwA8RJQwCrd8RuoF6ZGQI4dUazR17Z04Z
         My1nMBmdy11k8nwyNUGRDf6r97+xH0zsURyOVJmAnzN6bJMa91ZCMuhfrDqP729e3i7L
         66RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770293221; x=1770898021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u+peTVHK2V5GDnlUQ9nOUzZqoANTtWMS/ko4tHyGhtY=;
        b=kLaDk1qpkIaA/yha6MMAgYufAit9lmBG+WXTgJVc4eXr6KyI0KwUHxwLNjrY9MhJu6
         rSBxDzAhwVLaYQQ5TBZi/JijQeilS8k1LKSBz6vLFwsmi4TBDuSvs3VlLEmMtTUc+Z21
         vtsQx05PwmINnkPN3jMkEeKNmqKDKlcWb62bD2QQXLGo6gfJVIgGDck3EhPFN3nm3mwv
         H64Y1TVRzRmGw52ec2BQNakGOKB9zzgUCNuK1O7fCdRnuQZdZvvXnwbN0kcFQD09/DUa
         R1oTuLDjdKjBtzUrYcNc4i8Ng7SNqRrZmkxPKgrC4ni3mIeXtOcBw6vwZh6DSUtldAjU
         Iy3A==
X-Forwarded-Encrypted: i=1; AJvYcCWvAwz9UZzgYiSRRgxVSfojrpix7AlCFLgXragFV4USNz8ASOLFcuBB0E66SmVyadx7yPAfApO4ZA==@kvack.org
X-Gm-Message-State: AOJu0YxrJX4QdDL48N2szhtSvYmkhVxHrvnbLnpxE4W/7VUPwSCKornC
	IQdBaqyUtfjX6Ckk7KLZ9l0T34wXo/E+W/isgYYuY9bD1FvDME3idEu9fx72yUciFrtDOBwxYAS
	jITZT0aLYFsMyhdCtWg==
X-Received: from wmmi24.prod.google.com ([2002:a05:600c:4018:b0:46f:b32b:55f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c04b:10b0:483:a21:774a with SMTP id 5b1f17b1804b1-4830e9926cbmr64195215e9.26.1770293220868;
 Thu, 05 Feb 2026 04:07:00 -0800 (PST)
Date: Thu, 5 Feb 2026 12:07:00 +0000
In-Reply-To: <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
Message-ID: <aYSH5KG36fVQFePL@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72545C000E
X-Stat-Signature: 55t5sis16ab65ewr4kuq9rsp8n4ioqt5
X-Rspam-User: 
X-HE-Tag: 1770293222-899937
X-HE-Meta: U2FsdGVkX18r5auy+dyfWCGge32KqNrotq0EdOisyeoJirmdETSbP2vjxiE//VqD+cdQBLwZANKYxc/3SotMhaSAANk2kINF/4/fw5e2BrT2t1ZaQDJbI7tKRBc1T0vNzwDSDqOCosYRBQdKYLQs1Nxv89/QopJRAn93avfGcovjpqoBfCfatv0stq8DPLdO44bUHAJepTaZXF1DYrwekbCi8/54w8KNoJr3HtOvDV8M7xn+CvHdJaIIAIcpUNqv3p8SkYNCehgVSBk+yak518rgLbmBS62nrbo6YrCjqVI8rO7vK6DytMLEGiXXdffsCSVACiZnjrIndelpYHonvCeu9UT/xx+iYc9oKo5ILAnkOg+Hql4mkSeC6NIa175U2rfshcldaCrGBblaxaHS4Ml1vabjanA6RWYM0dcXrLSjB6TZ00QxLEcmwgVLsmVxsEyCVN87DrGe3g1y8Yj+C8Hah/Rke3N6bmpH7mm5WXESBaKzGLhDrlHwDuxHBlfoHkPoPXU5dxj3qLZbbxOzuVc6OR4AnVg3ouW53qaxnKMqdpf0h1pwNkeqixHzDdQAOgE06Vuti1ydGg1QmyYg6NUFtNtaP1Yg4leDZq09+JQmSwCyuw8DVTrgb4yHcki2CWpHZ4PUQnrmVMcLK55DNIOB6FR2mq6MZ56CtoLQ3bMdhXcaOIR4bfUM5OKbmeyKmB41oBhUz484wLplTPL0Q/8Bejx38uRmo/2/eLtprfAphJGeflhqgRNMA4ZmpVFMYVQUjDrNypEWawZvbqtVU7hvhsfFF/XbhpBjI+FEWhTBiG3GjKqkmAVQjyzpj0pbfc7BaF9gXoaA0BZ41400mZwGfqfsle6GXIRmS69fp1WF1YiO1iXjy0RvMamGF0KPLQAMoaE95wg6inoePmtV4nF5cB7rqkmF260zHKYu47OzGsvLdHKPSgQYUWE6DahDg6x8RqCCJ3CHwAHioXq
 q9pazENX
 TK1KeRwUXnenUAMRIynu1WvnoWlwfRCystVFri9XjT3/z9fowkCwDD3Kb4PQtboUtcDYhf0tg5ZQZBwIaKZI9w2GtWqS0hj7Z0s3bE3daiZkO0LOQB1f9uPUafLwJZ5QKwL3P0WcHiyuBJslD+2OWzFvYe2BO37Va0CZMTZ0RKHwLq1gIUxeNTzQXAz4tvYDLOhisnYXU95GGsyTFuYlzA09FQnxal29N6dC5M3F+0J1kpXjjUCVxEZCXMgbI+LGVdrmyLQS0GnyCRVM7vZAbW5SVDgj028EJ+pjsILzTRI9ftUOnd5/0ojrYPeQzbV8Hum21dCuC+/MOMA7Ael00a/UrdrUpYc7SlOiF/3i6P+mCRE9gAbg5vhvWwk9vYwXl1T+j4ptqYWv85ji2agW0NKU84f+qpFxZ+jFCc6KxMx71Q5hVnQ0pU4Ssr2jhbTI93UwNJcCl9O7mGPjcqIZq4MWDvtu2oJxomnMunQgTSraw9MCAAk3cUivE6RalTmhMio3IaXGK8/b6DWwUuA1vE8CDgMY4VXOP54RcyAeWqLjnBpOmK2rrCK5qcQ3ZeZ/ZoOsAzKOXVk4OGTIRJPmndiexMzu9sqFRcBsfBhr0hTjsZQAPtzUV7VKIkJGOHmgcvnKD8MATEy8+Oq8l6HeYTCmX4MTZQLsCIBWKLnfO6zbenahsLUj4WXN1d9GWlvnCO+3Y36Tycjzu4mrcMOrh7JxzpG6OWBNpli2KQ53Pfd6WutxZB0eT03OsvW3phg9NgTOaQ2aBTLkk292JCr1U/FGFSYpzSpXx9Y5WHNGqLP76A+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 11:29:04AM +0000, Lorenzo Stoakes wrote:
> We either need a wrapper that eliminates this parameter (but then we're adding a
> wrapper to this behaviour that is literally for one driver that is _temporarily_
> being modularised which is weak justifiction), or use of a function that invokes
> it that is currently exported.

I have not talked with distros about it, but quite a few of them enable
Binder because one or two applications want to use Binder to emulate
Android. I imagine that even if Android itself goes back to built-in,
distros would want it as a module so that you don't have to load it for
every user, rather than for the few users that want to use waydroid or
similar.

A few examples:
https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/blob/5711a17344ec7cfd90443374a30d5cd3e9a9439e/config#L10993
https://salsa.debian.org/kernel-team/linux/-/blob/debian/latest/debian/config/arm64/config?ref_type=heads#L106
https://gitlab.com/cki-project/kernel-ark/-/blob/os-build/redhat/configs/fedora/generic/x86/CONFIG_ANDROID_BINDER_IPC?ref_type=heads

Alice

