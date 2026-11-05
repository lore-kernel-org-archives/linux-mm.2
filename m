Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85926606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=hQiyX4SZ
Received: by kanga.kvack.org (Postfix)
	id AD4776B05B0; Thu,  5 Nov 2026 03:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85756B05C7; Thu,  5 Nov 2026 03:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973AF6B05C8; Thu,  5 Nov 2026 03:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D19C6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:51:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 176058098D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:51:58 +0000 (UTC)
X-FDA: 85400447916.15.9D5ABDB
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85ADC180006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:51:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hQiyX4SZ;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4soA1wbGGkJusNMsltnTjlcCbzxXwWGOb9aK3q0azE=;
	b=PaZNXKxK4waHiRoX7hccPXiPbEs/gFRZRweoSHQiQcJ0ZSh+NuVCkOlnXHVF/t8cqeB2wB
	guGTwH123vcGxXAbTKxGHnjmwUCuktwcky5GNXaNWrcICbmgLP9YKEJad3qpM6xc0ajbIG
	CqD16ONM0K5OQqabtDNrm/zdCryfqyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868716;
	b=5RA6niAJIjCD47L9XCCu05rjeOeH22/+srPpc/+iEFi3t6kZW5XVSJA5ZjskkqwCqNobq4
	kI0szSvTvA4kG030WlvdRPDxq6xM7sQ+ww4g6EgUQx+qL/EPf2xk6tKxMabDfUTYbI1vyY
	tS1RX+3jZ/YIQlGaUlcFejKZ3uIX2Hc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=hQiyX4SZ;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Y4soA1wbGGkJusNMsltnTjlcCbzxXwWGOb9aK3q0azE=; 
	b=hQiyX4SZA2tS4OXtKu5IuvLWAXyaLoxbQnJcqusLNlkaedE6ATQ+A26fMjA+DYRDUg87uGUyiou
	lRoULOF943cIw6tI3K5Gc22hTeG/Ng9v6UlF2mFw11tbJk30wbOJrfqNpzIDiRCPr/CITaVGpo2mu
	poZo3XOSqfuhiG1btoJU0qjEBRk56rx7Asf3gHcsABOhPh1m1gKk3R9k5NGYbHUEvCMMHcL69Q2+B
	W3GWTdl/jvFmVLDSrI0uBXfF6h1TC0alZsj+uGooCwXHrg5dbLH2huVft4OF2ZZd/GOlnzvExmkns
	T6iqHL02WTG56M/nMw7sLkSlzw6ZKMYHcyoQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOtC7-0000000BJbr-3JtE;
	Thu, 05 Nov 2026 16:51:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Nov 2026 16:51:39 +0800
Date: Thu, 5 Nov 2026 16:51:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auxDm_YO4oACA_d2@gondor.apana.org.au>
References: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ausS3LQNkdc6lBy3@milan>
X-Rspamd-Server: rspam06
X-Stat-Signature: zkbrqjbxio758uzedaxiissfi53xws4w
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 85ADC180006
X-Rspam-User: 
X-HE-Tag: 1793868715-311261
X-HE-Meta: U2FsdGVkX1+hyshgLT0lHhfFH6JZshKMhIyDnHXD4VtJ1syFR5xnnR0AJhxKLYh7T9/q92gqolEX6wMHZDXtlKcYNcK0gfeNnpXLYbW7EkUMfY3j7+c8VHInERLPri88dIrNSaPq6yD06wY4ITNJWReknWFyplQx+/noZKRxsrV2f9fJXs3Te66grVtKQXCc3rmNlqpCGhChNoXz5otpbT716m1gEmB5C8v7xQrFRLQmAuSitrfZsDh005FcSM/LYYyIY1N009ZIRuM8jHdKv9Sy4odcST8745Xw9ggqwErnh01o12MkBb/AQz6vEXokSHIstrkvmzdN6JDED99t17dtazGg4f4IBGaiVBiaSBRG6w9PtnYMcVXE8Xq5Wai+uA3h/3Qm0MfeYzhgqj6rJfwHWO/iuY6LhGej4OWsatnA2lBciaQHaaTAcGsiibES4gxi7im3CCZPRvFdpUsKpvMLhOPbKllR0pK/8cU6CIVcxXg6SLl/0pE949f9TicEWytXz5CPN9BRI9Hqlk1/sVJHq2yH2xWMbk3DckJe33ASK7ERhOXdq6LUgm5nBRUeZ0MWqdK2uApXaxgoBoyvOaIEzFPGbRUc5CcVSo1YN01DyxXM8il7vuhXh0quV+4Gi5uY3MIO/O+EM+Chm/vszgf9NWJDQ/k3N4ICJu3kwdKfXzcbdWHQqba0P6NhH2x+738s64OqL0pgnw9ERY+X8P4f70hmowfFGiZ8dWImb2Q5M2Kb100uzhXBoSjneghbVKxpI/5iGDqpJ7fQg0+mLGfWQvuEDWI2CcinO9//7uCwDNMF3eEwHovOgzwra9bUGwP6rbFpP/GF563uLF7fEbW4HClKVPAU4Tgyp65a7i3YY/CXkslF3ZIbVD6378XS/+IRFtnGAG4TyCbMKpJnWb1vdtEEZRVN09YdhmLX7JYYnu/UW5q1Mjz9bfsUq0bZjShY3yDQWlulH3BfAje
 bs6dVFdO
 MI9xWzgPnRCw/aAmTx9MknL1gkCnL55w1aFra/7F4C8L5im791/2ldt4JU8TO2MMyUf1x5kFVo7gb/i0s8trlFhXR7yLf9rt/SFzZCAXeUXB6kIEzHXCdUgc3l6jnU5M8oh8HPYIqj6eAewK5/9ATX9AZ4yBExhKiVV/HzOKzWz2uo7aVosB0/G3eoVBlOKSMAnzdk0WVB5aoju6nSnAK5x0ArBbdQHLFr2pnmCrJtfuW7UpicJkL4LOhATsEa/noNkGWwgqke6wJoCVY69Y7NZ8994zqMxHyw8DaerM9En3XpwxvMp92mwJftiCnNQruQE9SIoyC5SLN/ZzWLVea8Y5aLbynZOaN/kkDxAZKxd2CtXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:11:24PM +0100, Uladzislau Rezki wrote:
>
> There are users in kernel. For example:

Thanks for the list.

> drivers/GPU
>     /* Allocate the file in vmalloc memory, it's likely to be big */
>     iter.start = __vmalloc(file_size, GFP_NOWAIT);
> 
> AMD-GPU:
>     kvzalloc(size, GFP_NOWAIT);
>     kvzalloc_objs(struct amdgpu_coredump_ring, GFP_NOWAIT);
>     kvzalloc(ring->ring_size, GFP_NOWAIT);

These appear to be executing out of process context without spin
locks so they're not really GFP_ATOMIC.

> Virtio ring-testing:
>     (alloc_ring(0)), gfpflags_allow_blocking(0) does not allow blocking.

I didn't really look into this as it's just test code.

> net/ipv4/udp.c:
>     err = bpf_iter_udp_realloc_batch(iter, batch_sks, GFP_NOWAIT);

This looks buggy in exactly the same way as rhashtable.  It's
called under spin_lock_bh, and the same lock can be taken on
the softirq path on another CPU.

So are there any safe users of kvmalloc with GFP_ATOMIC? If not
I suggest that we change kvmalloc to disallow vmalloc when called
with GFP_ATOMIC.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

