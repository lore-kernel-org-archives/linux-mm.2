Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F4C606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 06:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cBlF4fqb
Received: by kanga.kvack.org (Postfix)
	id 7E62E6B05B0; Wed, 28 Oct 2026 02:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797246B05B1; Wed, 28 Oct 2026 02:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F926B05B2; Wed, 28 Oct 2026 02:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4095F6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:16:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2BE11A0BBF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:16:39 +0000 (UTC)
X-FDA: 85371026118.29.A75435A
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 01CDC1C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:16:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cBlF4fqb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3RJPhagYKCE80vwwEBx55x2v.t532z4BE-331Crt1.58x@flex--jeffxu.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3RJPhagYKCE80vwwEBx55x2v.t532z4BE-331Crt1.58x@flex--jeffxu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793168198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4wg8Pbjg2SQve6wgEy6XvKbvCoQemBjrt/2F9Kq2TY=;
	b=LeKLlvWFyCfTMyNjrun9mrPwAWH8xPixNx9Ny8Ga4mNi026A2qOsU3JCyDiNTN0MA/NYfz
	fGNrD1J9FdXpfNO/7AwKzM30KurFLpqqUsmSjyZh7dDr7LAuIl+UhsLuKzOiCAxm5Q3Pbl
	B0zXuCnwC4pk3us01dMLnfoPc8rWFu8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cBlF4fqb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3RJPhagYKCE80vwwEBx55x2v.t532z4BE-331Crt1.58x@flex--jeffxu.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3RJPhagYKCE80vwwEBx55x2v.t532z4BE-331Crt1.58x@flex--jeffxu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793168198;
	b=Q8LwZHciBHEN8haSgpxSUtZq+8q291LyhgiXDaUOQM+X15ZL451WkFWU5IlrgI7k56SGx0
	rnmOyLG6Z85WTSMh2VKTqhUKSNLVA+m8IdZnf2Qm8J06v5mSy0qW71w4llVtqaxcZ3ADeS
	XATuUolIL6cotExDzT0mkOrUgKFDCQs=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-35cbea41088so944967eec.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793168196; x=1793772996; darn=kvack.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=X4wg8Pbjg2SQve6wgEy6XvKbvCoQemBjrt/2F9Kq2TY=;
        b=cBlF4fqbQKwb03dlONAsqu1/MEKBcJfOALgI2fZa7UsAy/YLuYZwNZ6ij+SF//+hL5
         u54oQYu7hatIdF2cWZWG5/++qK46PHDod5OpxDnI6xrL9gz84yi4L661MDCIQaFI5iVi
         LVc7/cU2LrXaH8XsImfDWYBgF4v+UlfftwKIYmpUoLlIVvjeOL1xlTyPbCZYLkSEYTm+
         mFUG/pOT+zdCUfuSqYY7hMU7zE4z5+NdbvI2y1XL0A8n+voQl2Vy9Bx9R378U2vMsbcm
         dzRCcqGzAA8/5Bc5kZjx6VWWryIDL3ZK8CRj/ubieshzVAmQaxls3Lrw+f4qdiheTqiq
         t4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168196; x=1793772996;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X4wg8Pbjg2SQve6wgEy6XvKbvCoQemBjrt/2F9Kq2TY=;
        b=y+Cey37z/yK+skPSKUf/+J1ON2sXprUsd92MBnSt+nM0YlAwS8EA1Xc5U+brooh/5e
         f49hhWoAedePH3Q7veXyqry30MyIs/vHbLqM4zArkvWhmjDBD5W3GBv7jNwOg9XHQZ3s
         HLwAfxeBjzDRjSmrv8beyHTBZ6sWjTTslVLg/T40l7JGj+cci0Be+0INSXQIJ4yfOLKA
         G49a3Fvzc5JPmBAmaz+f0IVCkHxfs7VKrEapLA9wD3ALLyegn46Ccg7bL1O0+uvOsHtr
         sXQfOgvEUZLdBSyePe+LOHi9stOYvsy3IWhTibVgcNWoAcnCpjtE9235jGKUkdmnWjBF
         2rVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxDR7OT17R5gKadJW1dhgdkefQ5eh8Kg7ZzVynq6OgfJrLqrLSSMc25/+jw0dEtBCngEF3nIvdrJw==@kvack.org
X-Gm-Message-State: AFq9FYKJz0MldTTSu+SeuctMSfoid4eokpOje46NhxLK9ocoMb2Wsjr2
	gNV3UOD4w69N9jkVOZSyzZ1tbPaavjQYj6rM3E9Ey6NZZ3VThH9k3kw+GXP8uV0F6wiPpe689jS
	PKLkwHw==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: from dyx13.prod.google.com ([2002:a05:693c:820d:b0:36a:1d37:273b])
 (user=jeffxu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:6195:10b0:35d:95e4:267d
 with SMTP id 5a478bee46e88-36a200c3b89mr2179969eec.27.1793168196147; Tue, 27
 Oct 2026 23:16:36 -0700 (PDT)
In-Reply-To: <auGOXLB1XZFWcTfX@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name> <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin> <auDTMb6WMFUpxeZy@chrisdown.name>
 <auDTptDQsB4xBcz7@gremlin> <18e2972cb8520c2e.3137322e32382e342e3434.279dd1.0000sendgmr@google.com>
 <auGNkhSHpBRd2U_5@chrisdown.name> <auGOXLB1XZFWcTfX@chrisdown.name>
Message-ID: <18e29cf9499c7ec0.3137322e32382e342e3434.2a28ab.0000sendgmr@google.com>
Date: Wed, 28 Oct 2026 06:16:36 +0000
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot parameter
From: Jeff Xu <jeffxu@google.com>
To: Chris Down <chris@chrisdown.name>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jeff Xu <jeffxu@chromium.org>, Jeff Xu <jeffxu@google.com>, Andrey Vagin <avagin@gmail.com>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Rspamd-Queue-Id: 01CDC1C0006
X-Rspam-User: 
X-Stat-Signature: s1hqx7gwqisu9c5om4u9rf3refkfgjhx
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793168197-319272
X-HE-Meta: U2FsdGVkX18y4zMagDydbWIYeBBb87N/e9HiE+DNxjuSRwV2fB+TwhsPsfotDl7xrCPO9XcSfj9pCu8VgDRCrcKIv/lcMiSIvKNlN/BvEQj+PzKKOflBojhSh/2XZw1gaiGYrR9L0BxCEndakjKkutsbQRNi5bvt4dLkkXQq8YJRWTfUdc8p7gBjqz/zuQBRAT5K8Xara3IUzMLhLqratmdYmyHUP38qQPziJaLGbb5/Jn4YAIjt1/19+eOSzN44cOXCT+iGbufZIjvnqlT1FjtOP3cl2iEbEoE22DMquqSZJKbWQZL3zHlbQczyn1xALP7qiAKkNuchScuYhd8mbfD5yQhuK9t0wFoAoq+ctx4kNBdsBXIgMieRzbiYZafm2QkAgP5KTZl8A9LJR0B7h6ivEwx1rRjpEY0bAgeTq0euMWIt5NztCrmR3nQpPLj0oP0wXxtbxDBPluNMyM4hdhsd1e2GNFTMwFzzvMqKz6meUTAPS5x5GA8B8ceppjbhy4b32abxQPVqBlmLV6rFQD8S8q81S1bJ2YLiJLjZkex6i/yADEV2+TSNWvAX3qXDTKmgruUx0ijtEHQIW3PxMgMIHUf81STq9FwXFilakHScfxRYvZrWfewUFSBr2bS/Ezl0oauOSm+gl9VWBxN5G+VqIEEPYaxprgY5lzG+rZvGJbHCgAO7IdJglsKvBOyaMQpqfIPFGaC9rwNbt2rhksrtl3W9/DRZiQowYs0hHRxSFUJFer1Hu0x3JouoXYmgq2iAiWqpdlQWZxZ9bmWtvKkFNEXLyQzblL7ZOMxJ2lLEiEgO5F4z0CJI2+C/0A0J5xs4CHS8E6Po6ObuJlK9iIC2XPk3ww9w2235HPeOboEw4W8/Ek7Rt2Fktzqhxbz4KgwOh/xKq+f/pw9cNNAamgUZBPxcx8nNnEj5kfcE0Tw2WR4trDbmZjb/G7H/qTtA+jnDXScQ6jXe0VkZEzK
 G8Qg62PR
 1vzMSg4GNechbd15Ual8YTHHqxAYPjZChXRkXoWvk6L/w7WQuYiQLjSV3nWZHD2sFq/nU/kBGYksymvTTv5cnvFHSSl7aGzSP858pBLj2sBTKtYZCcMoaJk/Adnp7KPJlXTQBdg9xD0f4O3iUCP6VVOjvkz8twkXQYxvExqm/jC9RzrNPLlFJG8eekQVnA5b1QRHYsQwJP72+IjeF1X0sfU/tGj58IbxpHx6Qua8471iHAi8s5DxEZgr0O1U9ntGTYHOTHecVYZ9iLoeBeC+5QA3IIifs2FuyMuV1mpNNy1heVxJbqJSLgtuJzaQUiL9+PT4R8wlLhg5HhdnLN7qMFFaUpLTqKlEF0iPoyXtyphiUFsuYmzkh4bA+V6CK8Tkrx0ARikhEddznOW+wcaW8w8F+UYNZAvsy9b20gO/S/2NVfWe2MR05K8OzRFxzfR1wcXRsJA4H6KRGpm97msiF8SEVgXTDAHotI3JVIhwXGW1CGuxn9JgCYQBlz9okthPwSgh6UO+KNZkRhDh/mrcnvnuxokSz4YgxygffBqWQspAIzpRHKGkbEhmWEhYidSKRe6oxA0l3JJuDk7lmrVGd0wDyUucFnC0TVbKLc/R1c8mljvaQ+1WKLxQweH10j7CWM8dqFbB+Q2SfrNN/YIJCBi4yatFiXRCEq8EX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

On Wed, Oct 28, 2026 at 01:55:40PM +0800, Chris Down wrote:
> Chris Down writes:
> > - Have check_sealed skip as usual when [vdso] isn't sealed and param
> >   is not set
> > - A new test, say expect_sealed, fails in the same case
> > - run_vmtests runs with -T expect_sealed when
> >   CONFIG_MSEAL_SYSTEM_MAPPINGS=y

> Er, the other way around. I meant vm_runtests passes -T expect_sealed
> _unless_ CONFIG_MSEAL_SYSTEM_MAPPINGS=y.

Using kselftest_harness's `-T expect_sealed` together with checking
`/proc/cmdline` for `no_mseal_sys_mappings` in `check_sealed` sounds
great to me -- very clean and covers both regression cases without extra
argument parsing.

Thanks!
Jeff

