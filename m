Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32BE9CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 16:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A436B008C; Wed, 10 Jun 2026 12:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB856B0092; Wed, 10 Jun 2026 12:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1166B0093; Wed, 10 Jun 2026 12:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7666B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:38:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0AB7F1C0EAF
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:38:20 +0000 (UTC)
X-FDA: 84864560760.12.92E78DF
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1687F40017
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:38:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9jScehc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781109498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FV9NSm1JZAmrDCg4Yfdgm49WPhKco6hLMTsMw+d7L90=;
	b=ohQdAEsMrAXpPlddskSWYqgBAgy39as18oH3N3rtBF6k5bbBztclRR9qbzqVcHN/gNZ03L
	zc35asRDwOx3DeW/Wh1uO2LiiQ4OCD8I+BWyoHpPc9YYviC9TDZB2+F/qfxgvhpBObuqBP
	sl+zDsPEGXctrkne/KbDjWamH1KeZOU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P9jScehc;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781109498;
	b=z34J/TouoHqrUfAQsw6EGMHcrWuOWhCdNFnuVVPe5esw0djEbtG2DYn3kxfB6Lz9wv39z6
	60eOH2LjRhkzyquarT766g6x1AvTq6BCenPyZvwYv67DNtDjIJla8IrF7FnEZvgmHFuRuE
	c0cwCaUTzsNnW3906B1g+k7dATjBxqE=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef5146b56so41442f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781109496; cv=none;
        d=google.com; s=arc-20240605;
        b=i72imCgNFSjQ5TYG7v9FnBwpgLvm6Q3mIRL917WABIqeL8q+zq4kOeyJ+Qai5e9/Zo
         HS5zhmgvmDaFdiD7hcXCaZSg3oF8p8GPpUJCOSyRkCFfKZaiSRgEifvufHgtnCmNdIH9
         1AlkVNY8GtknbkfZtkZntpVVcXRn/M7YefB3FgouqdYfopaaLeGp+GHRdsSbHfSjUXXD
         2ew0IeUp6r9rVfPePejiW3702GMFa9LPWkVCxVHwLrJvE/f/Skdc11YOWK+L8hBRcVwB
         D9BqRdpLRcVFd63Mfma0UjUWD9MLj9CkApA2HrhgGriqSHEJ+p8wTj7X1sN/d+OHV8bI
         F30Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FV9NSm1JZAmrDCg4Yfdgm49WPhKco6hLMTsMw+d7L90=;
        fh=ttuOrSWfzZHjgM3vruJNtKxktSsw8qqW02SQhXCq8OU=;
        b=DuzauAZ8Uq+jsWCMBBh61JgPFWejbx5JLhiFG+m/Rwrhep+ydELj0llO+da0bCppAg
         MiZqQ8U1MhwdeI+k0z7cnrDeTvTiZsrarlNds2Qp07XJ8Yf0rgzcoJ8KAlTnlkWZb7eJ
         1zZoxNIKVCPjl1GkjqaAdBmfpjmFF3g1XgxGVdKCJkZn+ko99ig8XdnbvnIcUnzvwJhF
         phizjfYS7Kr9+4fSAXl7N7MilPx2X/vpuu29SuAh84DvWLgzs11KYs2NZP4G6d/qyVib
         iUyS3qZ5tMbDEOeSp4GI4WF4D61gFkkcOEh4cARjW5EyW+sJar3/0gZC3fO9vUjuGefP
         Klsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781109496; x=1781714296; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FV9NSm1JZAmrDCg4Yfdgm49WPhKco6hLMTsMw+d7L90=;
        b=P9jScehcm2ANagwntuzGcS2ae25zYEOFncif3EZYyBHan1mmLGQ4LxG5qstH1jhEQf
         w2oSCiqO2tUnplybzm/4aFq1/KAD/MYxqjSVDXKm1mzdHA0TQEyZZt4GNM+/1lRzNE3/
         BqGTAjn5LG8Bbc4r5ktG53vT88/7nfKOeoYBJCxXLfYP6hDMYPr0gjXcG9Cg9rXmex+E
         yMwqEi4vWWRpPeqxLIDSNuHS+E0dK1SDFNs90lduN2u1CGqC9pYO0UeC9k8xvsmXfNOL
         AJw355uBZOoexxvUFoUUWZRBzVTsCk4y8sm5rki0eMdBp5yc6hwCWybxe547ZQak9v01
         1peA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781109496; x=1781714296;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FV9NSm1JZAmrDCg4Yfdgm49WPhKco6hLMTsMw+d7L90=;
        b=KdQwBCVxJayfD9hkNrDYCDkmmTr+7jeacx2M5ZyO6kuATZmC+cQ9j2oYFd57xhK7hG
         qdRDdeg6Hd0QcI+JwQnUn1J4EAa8se8pNaO+XRwXhCdJGsZeCysrz4v6W7lwuVMsoNUu
         kdl5qD4kL1nZhNJn+IfIKdNIA8ST3NsQgvVVQr5LGCHvy4XrxRh+51sqM5VGbdWUqejp
         rwJqClc97Wg0p/5wsoYvKrKIyCE9mEbDInXT3aYAoFJd6ghT8q97vFme2C5YVEqWr3bo
         M/NdkagBs/eSCCOdk4/ul7ZMmPd9KTYl89k7Zgm7l1+zH4wmDi7Sb1vmIJ88A9F7t0Z8
         x6DA==
X-Gm-Message-State: AOJu0Yx5vqiG0iHoixRbhchjATr1SdEsIxKibsIHG5KFf6nixpMfeDNH
	hSkPHrEQiQqn0ZrGkAgKHv4EOkwXrwRFKeamidcVyWUSvMsCKV2q3W43T8S9VwTJOWBRDdFiHEC
	Az0KiVM4KDpsvID6UktWEY6/qcEqiYok=
X-Gm-Gg: Acq92OFy0SZGdMeHe0EgjnNQlCYprPIJOB0V7ufvpLx/cqfaP9JfU8v4iUlreICqbtG
	3dUk9tvDET6CwwiH2GbIfZaoT8JkQQyV24Yfe89GUxk2PJ4VkukcOXDyaaZSI0WW7bzX5W+OrQt
	aNKs52op8NOTxTZXvdWKxPLtSxrvw/tUZqZX2OUOjURJ2ixGT1bio83S2jweRf92P7u5d3kA5Mu
	8maqnRM6bE5O4O2KI9KB5oxltDyx7v+ZddT6igt1rckMCODMTls6DVMfMG9XhToBWtH/bPLoK8z
	WZyDL/TZWyafoaWSw4D23NOpCT4lPJW+urQWvDAzNXy/MsUXdrIBUWXzPnwVBfK+eA==
X-Received: by 2002:a05:6000:478a:b0:460:2e53:a6f6 with SMTP id
 ffacd0b85a97d-46032da275cmr20646236f8f.12.1781109496070; Wed, 10 Jun 2026
 09:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
In-Reply-To: <c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 10 Jun 2026 09:38:03 -0700
X-Gm-Features: AVVi8CfK9URPwvMjciTagjeEKiIIxbscGeVuRxxpnyptz7RO3o56q24Y616RXQM
Message-ID: <CAKEwX=Me_WHU-oVF=rab7-5e=QTaYQJj0adi7xjejm-MyoDxyA@mail.gmail.com>
Subject: Re: [zswap?] BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 3iw9btmj6crxuo9cuybr1wzsie38nwzs
X-Rspamd-Queue-Id: 1687F40017
X-HE-Tag: 1781109497-350718
X-HE-Meta: U2FsdGVkX1/YgUaospbK4kZ+OY6FbkNMSzh+o9kfAgLUQ3sMVEVJp49Pkr03LTPE2whevHODcl/K+TF382UePE8o26NoY1mavbBV/TEyTy5OMzMdD+XAYBGT8kLsxpgc9szNFj5rO0miKd411V4jnCDhR4ameQqOyM8ZxNAi5Ih+Mt0NMZoLGfPPHzedqey6oMDmX9/rFVdw+/8F0JeZQVUepwJ/ekRo6cqjcCmMWePkNrORUaeVM1oMWoHJ1EHmhaLFhaTwLqrcXmZdAHLuLkfIIagocoLvHMCUSG2NxzDRK7OabL+luMSsG99aWZNcg7S5i3XUTfu4GhjRkzoWCk5FxFbHMtzcPvV2SsZDMPNd6Au73ShPN69XiwOmel8rvgowpOOCGGCBpUlGg029z676ujb9AUG30VmNrLHyV3KxdjhbBcCNwEUjNCwtGytfJuQyS5vKANi+qSuVBQHUi3YGmg+6sMyG4lJzoDeEEMZ8KjETsVO5qF0GS+t5bn28YsgJUW0JprM+KFmDT9p19R1uC+axzd42f836PXpkcoeGKEUzNIE5+dzXVyDYZjMO/9aOancr4Gm2+FqGwgmuR48NF1ybj5P2TZH9hDP7SRQO47cbomnPP5LaRPCcV6qtKOdeGP8YjHpZINyTW4arY3MmlEQFnjEzVjoofmtssv+9ElVPDWefmicZzwNg0xmJyty7b4dVaQ5X3wi+QqlTVMCuF77ckJdPQVL38Q2ZlNPFhsGRZTzV/WMHUkhRvAKf/0PKeLYkMW+rQ/D6zcI6Fxkbt/n1M1CC0W9VX5Yba7DssqTlGn3pVLtC9rEXzKlzqTkBFWTb4dM4J2ZkuoX0SifnKooCmInKpCMXLJZn1SmnAYzvYaFOP03VAZiKXrWNZ9MnCipXcNHFv6fYT5SuL/mZAV+JlQtZOv//QZWBHxzhzC8895KEIvYlMDoGHEbca3/GhVtY8IKzwdEcLYO
 ndyR5bOc
 o+YQQX62nNAYDN6dJ/T80VeN4pJVaoJnAColftBll0WD9vp0tkkDV8KAeQBWbJc9FSgCINsX+jUDjr7d8CS7LzG0cUsZEMZa9qr+6qkRWvG4bg37VeFUwUhNJUFqrsvf+z1UKJgZ44HqBKbx64uqEVj4jmcwB+7hDZ9ZDPLn0OfnDntUrxa9+n4SbuNqtlU908BZdATaY9yT3enwzD1jivYonISTTi35+Ph//iVvQNQf6J0lLnZZSgWBY512zjxWZgAuWlK3+VmnpgLISo1iRP6+qn6oUzbj1SvmV7Ieb1GcFV5bdKcJKrgGX/dGZEYGs5yiRM1Y/l0xjb2cg5xyFQtBEchdfqy4e1VYGV3kx+ZBnASeZqE/alnm01Lc0inP8XcXQROi1hT3pp3lBW2scH7JOfqkL32fdcAGkvUV85rc+uxZ13fhONsZNhDOVrhQ6vH6bLPEWhh8tntm7Xy8c0w+rJ/XuTxy7C4qkrJy0JRZD+ll6r3jydrVqDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 9:05=E2=80=AFAM Zenghui Yu <zenghui.yu@linux.dev> w=
rote:

Thanks for reporting, Zenghui.


>
> Hi all,
>
> The following splat was triggered on the mainline kernel:
>
>  BUG: sleeping function called from invalid context at kernel/cgroup/rsta=
t.c:421
>  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1126, name: cat
>  preempt_count: 0, expected: 0
>  RCU nest depth: 1, expected: 0
>  CPU: 7 UID: 0 PID: 1126 Comm: cat Kdump: loaded Not tainted 7.1.0-rc7-00=
056-gacb7500801e9-dirty #304 PREEMPT
>  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuil=
t.qemu.org 08/13/2024
>  Call trace:
>   show_stack+0x18/0x24 (C)
>   dump_stack_lvl+0x78/0x90
>   dump_stack+0x18/0x24
>   __might_resched+0x114/0x170
>   __might_sleep+0x48/0x98
>   css_rstat_flush+0x54/0x564
>   mem_cgroup_flush_stats+0x9c/0xb0
>   zswap_shrinker_count+0xe4/0x1e4
>   shrinker_debugfs_count_show+0xd8/0x268

Ah, this seems a bit tricky.

Seems like shrinker_debugfs_count_show() is invoking
zswap_shrinker_count() in rcu_read_section(). zswap_shrinker_count()
triggers a stats flushing, which might sleep. Not ideal.

Is the rcu_read_section() here to protect memcg or shrinker? For
memcg, i dont think it's necessary, no? mem_cgroup_iter() pins the
memcg before returning.

(memcg maintainers please fact check me).

If this is for the shrinker think this needs to follow shrink_slab()'s patt=
ern.:

rcu_read_lock();
list_for_each_entry_rcu(shrinker, &shrinker_list, list)
{
    if (!shrinker_try_get(shrinker))
        continue;
    rcu_read_unlock();
}

But OTOH, doesn't seem like rcu_read_section() is what keeping it safe:

rcu_read_lock();
memcg_aware =3D shrinker->flags & SHRINKER_MEMCG_AWARE;

We get the shrinker reference outside of the rcu_read_section(), and
just dereference it without any checking inside of the section.

I think we can just remove the rcu_read_(un)lock() here?

Long term, I still think we'd be better off getting rid of this stats
flushing. Seems expensive either way.

