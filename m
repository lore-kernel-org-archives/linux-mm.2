Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFA34606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ncrdZuej
Received: by kanga.kvack.org (Postfix)
	id 268A76B05B1; Sun, 22 Nov 2026 14:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2486B05B4; Sun, 22 Nov 2026 14:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E11B6B05B8; Sun, 22 Nov 2026 14:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D62676B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:02:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 646AB120716
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:02:15 +0000 (UTC)
X-FDA: 85463675430.25.CA5A722
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 98F962000E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:02:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ncrdZuej;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795374133;
	b=volh1itaETVmUichHXLyAGxcaYRSyOCUMpKq11DHQIxvAzkNIoVVaOZaCSPpoBIP4rFkTj
	SHJvL9ds+h33WK7IZkYJ//dV/s2SmYT9G8ftukPfY9lRbH6Yl6c0YdR8cRlWCytGAc7lv1
	NdTaSWSRbrwVP3Zom21W26DhQAmpNFo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795374133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ImuqM4hh2EY1+d9bvgkuqa7XuiqLC0obTG9QEkhIqg=;
	b=3+zvydP5W++0NwhBUJAbl7t3kC/QVuikKCDd9+O77Gh7j4ieBBL1fuGFxauapAZ5NozF+M
	Yt7XFV2WDKflypCsDeiorL4/s1Kb+nbj3KYXebwobxk/yi8CnEyNm7B5kaQJvl62Y97HlZ
	mHQdbpqeTbPmYbl1bAumeb5s1EAqrCU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ncrdZuej;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1929B60E15;
	Sun, 22 Nov 2026 19:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4003B1F000D1;
	Sun, 22 Nov 2026 19:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795374132;
	bh=5ImuqM4hh2EY1+d9bvgkuqa7XuiqLC0obTG9QEkhIqg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ncrdZuejHtg4X4kIHE9XamnHb/F9dg1FnvcNpLGpxT4OXyDbYPVGYqxH+AzMOoMSF
	 t4fgSU/fMqIRiZmzAJMU7IyzQx/NfehM+bVGPUcZb0mRxOH4Is2fs+W43blTXtPUVN
	 1fp+bkcHtQ+aHz6nKls6VApLiBCF/ltHvHIChdgA=
Date: Sun, 22 Nov 2026 11:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Tianyi Chen
 <hi@tychen.cc>, stable@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: honor VM_SELFTEST_ITEMS from the
 environment
Message-Id: <20261122110211.81cf2fbbfc9048264aba50c5@linux-foundation.org>
In-Reply-To: <20261122-vm_selftests_items_fix-v1-1-9edef5e7975d@linux.dev>
References: <20261122-vm_selftests_items_fix-v1-1-9edef5e7975d@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 98F962000E
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8mjyn4kyf7jy91bq8bpchwi8b76at5q9
X-Rspam-User:
X-HE-Tag: 1795374133-465476
X-HE-Meta: U2FsdGVkX19O28WehPVpSlVut2ftskAJ/BRqpUdnqTQ7CDhki+/5JVkl73oDnQpuosY7+7oygNOaqFp9WQTGhQE6IMLOgcGfEX6i180QO/stGpqEJStGsaSd4Ma1L75MMggn3tNbrMGDsAuvZxCmIKK43rZowUqo8Pl2btadNpKL+xTFPsZ4cNB0OSTiXjUgXqbB50q4Qhvq1XIhmZSM0wrVBPBdjmkm8ZGb0eEkTEVEQIuDS6+ZV68lwHAS0DDcfjEiEW9wkZXCNmoF3uJAPdIdcDBuhq95uAw9Z9xPaee2XkvdgOd+1oWJeCXyzhgB89W9nK5JdSQPBnFmTlvR2RAg73YeEydvRSszTtSK9dkH4oK5Yq9Po4VR3USVIfeRwQxZboepLbJOKPptZbJSnzIGv4fUyWMm2blOhebNVqImayXdSDm3EJWnNOoKboblvUfVc0wkILnOT4sISkP/3IDKM9f1T2KYgyiyabh/wumjPjiG7fdJlgX5DgstqdS6OlDds6Tqih9tYHvKzyzp69CNqYpyXVNMc/3glTg8hg5hGnBXJ1g7Uwtoj5sZOYrvVaJamicdwf1HuPo5v61MGgqFmYsKEHP77L8FxQyEmPOjgYBJnQaklguLYEOaOwQp76irZIRxO/Wvdr64SFyr9qz0xmKWZibhAS45rb5wgO6ZEeHCQ67DDHZi8UEDgDGQxkU1UHB/CMCCouAGUuwTSw8a6dV/oQbOXF4l6eJuVqPvuoda5Y612qlM07nmsPtFKyap88+K8Z5c+8UQNYRrOkh6lOcBtM+UNPpuZ3UqK9R+h9Zmep2q30QEKvcfRP5qCCl2KpagItcNz5mvXjB9dJBCzEJJ/GvT72d3zXo3oel8oJ26QudWUk2gLCnFnmBPhpkUc5lSNMf3RZn44xVdph62lkXVbmQtKnrqk7fnufkZ53mNvY/+AfpXZ+wfeENyvIhuT2+ztOP3175EQA3
 SBlIiK6B
 WHQJ0Uy8obDEKHVtI6CPozTZNasxR68HrvnQPstV2YFQiGwrdVlXp1qE6/nBbPTmJ4Jm2qISuso+l7gO5ula6pFzN4tJWEz1P9Bh51yiOYPIvmEDo157DA/bp42OIK5FMt6d4GkiD1HQ/CDME+9/tMzwxkBdkOJARyvMXBUumtS+L0JeDABnfimVpAHf6s6B7JeSLkYHB6Qam94HAuNeVdfb/hpAzExRyynES7hhebkhyBfKcraQ1OMKXmlu4LCaZT/moDJDb6CQv99uXZIjfGCPQe+IHyNCfcYcpeKJsncN1gqpJHAnpNpPWJgaKxcEAe4fUyU1WST/nkixZec0X8G+MXuWlfDmMztsjZQJARx/fYWJb8snVgwqRyK+uwCXwsybXAWjUBAMHcIzwi6k5xs47iY5pLOFYwH4hl7bQrPEnDYwZq/fkFudSKOb8CQlXmnJtIacFD+XGnWJFAdWT0kwkNd5Hc06+KQBH/zdC7/LwjtJgm6pIE2U5ONC/g8MLqHwB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 11:50:36 -0700 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:

> The unconditional default assignment overwrites VM_SELFTEST_ITEMS from
> the environment. This regresses environments that use the variable to
> select test groups: without -t, all default test categories run instead
> of the requested groups. The -t option continues to override it.

Oh.  Is "setenv VM_SELFTEST_ITEMS" really a thing?

afaict the official way of doing this is to use -t.  Continuing to
support "setenv VM_SELFTEST_ITEMS" is perpetuating bad behavior.  How
about teaching "environments" to use the official selection method?

