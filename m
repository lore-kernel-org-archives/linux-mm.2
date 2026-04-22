Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54761F9EDC6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7D46B0088; Wed, 22 Apr 2026 09:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6588A6B008A; Wed, 22 Apr 2026 09:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DCE6B008C; Wed, 22 Apr 2026 09:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43EE46B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:01:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0C841389E1
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:01:54 +0000 (UTC)
X-FDA: 84686204148.29.2CBD8A3
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0B1591A0018
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:01:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NFdTkj1H;
	spf=pass (imf19.hostedemail.com: domain of 3v8boaQYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3v8boaQYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776862913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+12Isrg19MaOCC4LV9S11q3fZdSarqpUEBnPPaS2+4=;
	b=rnN4ZXZ/LMCnksaL9kS5bjQ7dZPspe/njtnQDFl0w9sTe8WS8IcZ9vRwI2rJEM9x2PQU+d
	0mGf9+2uYvVYVxcSww2pxmadc+/eExyWQkq14Qq7yIZyxXY0jShMb7o61JMJW2wfz/c2KG
	IV+6bHb+j6eCuMEJRmaJDfXI/svjNLA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NFdTkj1H;
	spf=pass (imf19.hostedemail.com: domain of 3v8boaQYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3v8boaQYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776862913; a=rsa-sha256;
	cv=none;
	b=HEnXjw+o50DVnesDoaIlA8tBwRydwyslIq70qVvm5mfB7o2x5QFhmrzGJ0d7QQ+G+UfkaZ
	nrE5Zuxdqj53aAXO3YkLf+ewav+8ss6jxbUKmaSoyqSrKsPX1WM0+v9XeEY+i98qljZacN
	WnmFuN3RPhtbtJNCzg2crf/zmEG4hRI=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b4654f9bb6so57092725ad.2
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776862912; x=1777467712; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5+12Isrg19MaOCC4LV9S11q3fZdSarqpUEBnPPaS2+4=;
        b=NFdTkj1HQSXJ3jofLG8YqSujQWTuEXDRtKR+yVNf4HmmWeNwDV5FtBB0SjqmKu9LgX
         PKdwrx9bmS6qB+7qfgPHcfogx9OPKcEDBlvjJlXmTDEPO7gIteu63H5e9u2WsUWVJ1mL
         +0mZd6kbmrYPXTPpjGJD2jjYiaxKDX4+tNMm9i9aa1Cjsjw/U6d0GWNQMLq/oeA+MPB3
         KzCpWs76QVdAUUMMLxKHwLrJ6FH6ObZQ9QqHdNtXuQQsHjTdkZUuaG1tx+KIM6SrnCpK
         dD+l3GdFUgl1GCtmlxukBRoaEpx3mWc3YE3P2XsQqy73FXsJtMfppP9pkzkKhljxrus5
         Csew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776862912; x=1777467712;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5+12Isrg19MaOCC4LV9S11q3fZdSarqpUEBnPPaS2+4=;
        b=J5QLj01b1aLH6+rzTXzkO6lkWcxDB/3gUTXXa+gBs0ta3+kl4WJPI1+xJQCeSQnW9i
         nAOtHD3Bw4RIG7rVd5/equAzWyVswBXPcrxklOG/5oWa8cHDmBp6zyzX4d0MwwxyQ3c/
         9kegFb8mK90Jv1GbTK7/EgKWTC8cyMgZefMpXEFNeMH18md6lvOZvdwS4e36PJUhG1no
         9TJEkfZNKWgM/h9ghVHY6X9FjFJC5gadNZS62YvThpefVtqfiYgz1nIC1dzk6XSkXVtD
         2rp8JQg5cMY9R5khnmWv4bRKgrDbDMAu602HPPIHWE8KlyxbTk+BFzfqKP2bjO5uvDbH
         /Hiw==
X-Forwarded-Encrypted: i=1; AFNElJ9QvX91dUezn6vU8xu2qsQVfRqoSQuMDLNXZ3ewWmnGSzBsWedBQGD8jnYmnpfZAXLrbnUTsFsakQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy8y61ivFAB/NdQyy0fQ1DRfnaNNgNz2lOm6oFtDZ42IvQfTWT
	X+C70G+hh4NK9gRlxlFykp6PqZKAa8rAj42pMbk2lrgPLEReNKmHmi7gOxWZqbGTA/sDWbqzS+T
	Xl9AjFQ==
X-Received: from plsp12.prod.google.com ([2002:a17:902:bd0c:b0:2b2:4270:9f7c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3dad:b0:2b4:5dff:310f
 with SMTP id d9443c01a7336-2b5f9fcf868mr138652695ad.34.1776862911351; Wed, 22
 Apr 2026 06:01:51 -0700 (PDT)
Date: Wed, 22 Apr 2026 06:01:44 -0700
In-Reply-To: <177d0a41-5267-41f3-bc77-415b756ea4bb@kernel.org>
Mime-Version: 1.0
References: <CAPHJ_VJGTsRDc7_Kv0oDObuDX2pJ0evcAvH-mnD_RYMX536+mw@mail.gmail.com>
 <e48748ff-0fcd-4561-9958-124dd853e70a@kernel.org> <PS1PPF7E1D7501FEA2B54606827E0DE1805AB2D2@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <CAPHJ_VKsVzyYzZ5ZnBkNbYLEMXDYL5x+7jfyUxhcwT1j4zPXOw@mail.gmail.com>
 <CAPHJ_V+L92DxzEB=4+Tj+C8MNBW7LM35xWYXAoLhHqU5p2nxfg@mail.gmail.com> <177d0a41-5267-41f3-bc77-415b756ea4bb@kernel.org>
Message-ID: <aejGuMRQjeEEH-V3@google.com>
Subject: Re: [BUG] WARNING in workingset_activation triggered by KVM page
 fault path on Linux 7.0.0-08391-g1d51b370a0f8
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zw Tang <shicenci@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: n9bm5agngnrmuxjuxee1wjbwzmxxgs97
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0B1591A0018
X-HE-Tag: 1776862912-586716
X-HE-Meta: U2FsdGVkX1/auPffHkzjEApOqv/7pxiT4odEu/tppfHaF0OsBFynUTqT+tuIoVQc+rvL26XXrxk19R3yW3wBP4RVN0DwPip103RH1epkVILnW3Ec0FV2xu+ujXxktkwBAQPfvf67FJONDc13fOd17BmaF1BYNCVEdp227ReiYK5f8ogMq4CDvMsfPJ3NJFfEe94oyCnaBgzG1E0IOOZ0y6T4FvgLZwyDULRL6SzBb3WvIVAnPW9WrGabDxO7yJM4fVbKll5qxv1stUmH65uW3+qkB5cJkWcScbYsXZqX7m61DlGeIDi75/WfgdKnPj0xkmw4B8XKtNMMtPnMqWg1MRxe1vpiBZNYaEbJP/qgaOPPW+m/CLqEG8ef5uNAqwo/cxrGZ+/kgrtaqnY6oo8g3sXF/elM0lsjwjDpwjt2n6P+49xRkt6UN4gzZ4PwtFpGq7kRVGfHSjlmEMa1qAqtFy6QxYF+5KEEMGqo4OnV+Jxpinx3hCr2pyUht2kZZd3uAe9/buibeZzXQLfDFm+7UsDNApyZbFYC7qbL9SDoEhHuGVahY28aMfbT32jO+uCu3jbsQLNbihoh1g8tLHNEH9Kc4Nux622seyb0jzYjGJ1DMw/UGDQWKwEj3ewGwJx0dVtRdYaX/qFGk/hxrgvqnVrT5X68paKjdF08ruAnkYONAqgxwSHbREKqQO5cuD0XkSJtLko2EK8sU+2R+TbO/pB8ffybacKoYzF7YTQsvldlMw8LChE6WtABP8//P9UH2QvUJdfcbxkCEPYQMkN4hHMvrDb9hxjoYiaFhPONt2iBtCn4CjmKw/5R7F8xZWa2Fp+kiN/ptJDLUcIs8LPcn+GJu8Zfy204yaRFfuX+xgN4J8aZ9LYvyYijcs5zJM4X1Rm9wZ2mB/urXlHucCzZ1bJPJ79Sr7fAVI29LJ6of9oG70M57rvVxebsT/PBqnwatLqoivOcREDLHAbJ3F6
 RB9DX6Ko
 Q6qOKatzHWZclum7iZV9NYSNg9MCDhwpjSjoG/HIBWn6FBPZt/au3k0nEmn2IChZvyXqLqexauwI0j385AZS2vE0716YNHelAOIL/Jegk59CM4ElCjgtKiCmbMoHt8fUA1fg54sB7s2IdNLR73xLhWxl2+5z5JsWHHjyseD2N2e8BbEykoOMpqqdu/8+FHwJBy5RUXQu0AIlGQ9NPYlcGrYawT6jYI2JN/DweezWjB7SnEgcxtRfINWMD/DzIUpDARc3EK+s3W+y7D5TnGgzkZmqU0eqjdTlBy6OlizKD10zT7FrzztJmvnGVIpjAA3y0PzEWXUOSOXzrxaoaLMShadm8YE1fco+mSeyI6G7U8bDvIDOxQotzVwGNUrceYtZKHgf+Qi1kO+2TUhUs3IzdmVCNN5GuR3keWeynE2+QB74VNfhQSQp9l9HpY8i/kC6Tlboef+4Whe95MfJHPqIvoq3UX9UwVOxkuuKRIbEsgBU1gW9PtC1yaON5iurk8q8XsVMqtQgK9eL9Hc1AOOdvJKfOdyEZ0VwjBR4qiU8E101g6xPYt+t2RV4Ywy9DSc1VFt7RL7WSuK36TUYvMVoL6R7R5HbsOYFqTa8nyAweY/zkeBQ9lNpILopsF7P3dsI8Y6mNqCsLsSeGvTrGpUGIkgLnXhJVZH9CB1vKCNwmPPFBLpGbQbJQ7eZMdbkuXxRY7Z1dK/ghruMp4x5ckOXlEIjqXML0tVenAROdGJS5gZq/47gkjg481bnfuU7+QONpOmdUJjbOGxHYItU0SwA3SGue6ESQOJosUKY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026, David Hildenbrand (Arm) wrote:
> On 4/22/26 04:06, Zw Tang wrote:
> > Hi David,
> > 
> > Thanks for pointing this out.
> > 
> > You are right. The commit id I sent was incorrect. I mistakenly used the
> > git describe-style suffix g1d51b370a0f8, but the actual git commit is:
> > 
> > 1d51b370a0f8f642f4fc84c795fbedac0fcdbbd2
> > 
> > The short commit id is:
> > 
> > 1d51b370a0f8
> > 
> > Sorry for the confusion.
> > 
> > I am also re-checking whether the kernel image was built from a clean tree
> > and whether there were any local modifications when the crash was reproduced,
> > so that the reported source line numbers match the exact build.
> 
> Okay, on that tree include/linux/memcontrol.h:381 points at
> 
> 	lockdep_assert_once(rcu_read_lock_held() ||
> 	lockdep_is_held(&cgroup_mutex));
> 
> lockdep_is_held() would not trigger a warning like that IIRC, but
> 
> lockdep_assert_once() does
> 
> 	do { WARN_ON_ONCE(debug_locks && !(cond)); } while (0)
> 
> 
> So likely we are calling obj_cgroup_memcg() without the RCU read lock held?
> 
> 
> kvm_release_page_clean()->kvm_set_page_accessed()->mark_page_accessed()->folio_mark_accessed()->workingset_activation()
> 
> ... grabs the RCU lock, though, before calling
> 
> 	rcu_read_lock();
> 	workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
> 	rcu_read_unlock();

No?  Since commit 906c38ff52e9 ("memcg: workingset: remove folio_memcg_rcu usage"),
I see:

void workingset_activation(struct folio *folio)
{
	/*
	 * Filter non-memcg pages here, e.g. unmap can call
	 * mark_page_accessed() on VDSO pages.
	 */
	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
}

But for the life of me, I can't figure out how obj_cgroup_memcg() is being reached,
and I haven't been able to reproduce the splat to add instrumentation (though I
haven't tried very hard).

> The folio_memcg_charged() only checks folio->memcg_data.
> 
> So something does not quite add up here?
> 
> -- 
> Cheers,
> 
> David

