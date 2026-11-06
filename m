Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709D4606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 05:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=r6qbavq7
Received: by kanga.kvack.org (Postfix)
	id 5DA8F6B05B1; Fri,  6 Nov 2026 00:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BA76B05B2; Fri,  6 Nov 2026 00:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A13B6B05B3; Fri,  6 Nov 2026 00:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 243F56B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:50:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8E2C1A0838
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:50:01 +0000 (UTC)
X-FDA: 85403618202.21.0C30DC9
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0ACFA40006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 05:49:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=r6qbavq7;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793944200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4x8jyjVTceVaevPhTybBNOQ2fqMlLZ3JJbNWyZ1lHVs=;
	b=QW+2df5109wpXEVI+5DPFWQSslLUkkPBU/6NFKJm16Tlg23CI6bD9DIbo6aFm9zsdmLU7Q
	AEnhnjIO+MaZOOfX0QZwUAdgCPfl674YqF81XB3Ebfw0VYvkEHggqTOteh3wC4k87R0UvN
	+q7wGHqaXSKL8Mv1L6rKGbkCK8zW/lc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793944200;
	b=Scmw+rk4OqNT7M4VgkkqnumHdkIHUw9g4D//IcPLpcnUKMdkRPSUt4pyoasOmrHQcZEheE
	zPm49BaO/KWGOU4fFYdgk4pdMspJpe4uD1vvH+iTmB+jWfnW68U3kQeYrKIJsdhJKyyNjK
	nCJmYul4e0UF0R0ea5/nJ/bLDIbIKII=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=r6qbavq7;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4x8jyjVTceVaevPhTybBNOQ2fqMlLZ3JJbNWyZ1lHVs=; 
	b=r6qbavq7bbjaRfZ1zcjNUKa7kKJAsjgQKDVs+7mPQ9rpcEeoS+iElNldE1WZZxi66uDJtrvc36C
	g0e3mI85wZt74LDRBOTTuOkvDvdRX69A3qThoEoL6ihS8jtA6ftYKK/VDCxcK2glMgsjOqCAbU5n+
	H61TkvPZ7tmELi1hGsg3Ogg7X3hC9Y1Y79Q2pd360JSSvsSLr1uiSsbSWcoQ9fbRRdb+vkI9uf8h1
	CzSP2fXQMSzY51nS/8hSzZRPDbAcR6A5tKYVzJZpYHMmTemDG/etwVeQmC5seesi8gqsEJeXUfnWm
	9y0A0JCbHKNAq+c+iQUoVIggs4LQCxJKF5EQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPCpb-0000000BjvR-3kvB;
	Fri, 06 Nov 2026 13:49:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 13:49:43 +0800
Date: Fri, 6 Nov 2026 13:49:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <au1qd5i4UiyNyS8S@gondor.apana.org.au>
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <auzOjphJ8DWpXwUy@milan>
 <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Stat-Signature: 9ozhwa8yufqwj4zcitomgc7gziy8hibt
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0ACFA40006
X-HE-Tag: 1793944198-411664
X-HE-Meta: U2FsdGVkX18OOIENaf/jgnew9oXID6HLEyLzsTSFj4MuvAaOKJRxSw7yGB1e9uh20Z/xcVCHqWEyZ8Y1OOe8DNXB9/62DyDBF0DC2JXz5DXgV1UgIngeu06x6FhkCjfVzx2CMpV6JykyzVSdpvDrchenLpWWVxogiJiCHuoPlZFzxGOUGq6rO0qbQusnLUdDVxdiDRcCYHFmhzBly73tNfjrU2Pse3F5MGMzxyX1AC0894j0P1qhFQKzuL7cOOAZwi88JMIfjeM0qqKznC8wTrzJlWbY1Bb9VhK2IgzuTslmg6qiEcjwWHZpWjAE5j+fPfNAweLKHqYsvU2aH4NWeX15lAcb4bs4X8vFTs0YD+2WD2MJfXLLWWwErGQUpvsmnWX9QNVnuH4iQ6IxPBt0ECDzD9eBD2yaP0HpoFz6Ztmgec1GcVCg+fglL+WKUrfo6FovrzGI5FbWnuMHZFZVI+/QX9711v9YnHn3AtJQdgQQmvT9epkVlGwxIoY/WTPV6yphNhwhZq8yR6S7TF+wjpok1sLY0dPvoXDE+BiwJhAVcjeh518lWh0eiUqvwK54gQR7Ha6ophs+lS6K2HXyrOPQ2HA3f78yC93KTSJfV0r060hS/hWUC87681oPBsYDyA7c8f/GPR43s8r+JM1FZt76yCnN8aM1XRaNoS0aJgahLQrmfdWcijvbLY9otoCaIpKNgSs+ui8qSp5PRQF4Og3mueXWTFoaqOlXwQimemEmy3SZ1uoogAthcVETF3tCcLhW5DbFrvHjA2mpbzIX6vU/4ciMCXKUCFtMsjCV9hF7AEicYTOqPDn38oS+n1VmRkh5ph7mfexqcqeBWMW32D0PLRGk1xnFSKdM6nQRsXb2p44FuC6OBq0mA/Kj5Oo8vetOlQTC0KVcFe/UZgpIhYiTCFubALLiFVlXSpED7s/hSgchxzFpovXqBkmWItnQkZmOEsWX4RANkx1fxCd
 n8IN7cxK
 wfk1JbAvGTsWesHUEhhxxZmZwcNuBB9CdByH9jh9+vp85qf3o4SzhD3G+gtpHexv6nYQzbGJ2sFnzpQkxdetj8dYvR0yEuGDKN3fObku0RupyMr9hwHcj9y7mLzJrZUApGYQP/v5ijJ6kyvMbKW52XvdVNGTFbhWAbZw+pvbmzqmHHk5vzd0JAjv2MCmaCKEcTcpU6CYjT8+UFL0u2QpT7NdduyHCm74d+NlYMjV3jNPYTiv+gEswG8paS2o+fNJwe1klL/kgXUfiwBzi9ni1LK70JHptEZwuHDoCLKREKG3ReN9EoaRqbNYx0kCXV6DsyC1NGeBUB7HIjwndBwDbiHVNFWAbH73WrG2AbHRnQIlhe8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:02:35PM -0800, Linus Torvalds wrote:
> 
> I don't think that in_serving_softirq() makes any sense.
> 
> If I read this code correctly - and it's possible I didn't - this is
> always called under local_bh_disable().
> 
> And local_bh_disable() will have increased the preempt-count exactly
> so that it looks like it's in_serving_softirq().
> 
> Maybe I got lost somewhere, but it basically looks like that test will
> always be true and is pointless (and misleading).

You're absolutely right.

Even if there was a way to tell whether you're in a real softirq
context, it's crazy to change how locking is done in br_fdb when
the real issue is caused by a kvmalloc call that is made through
rhashtables.

Now if we did the same test within kvmalloc and simply fell back to
kmalloc it might work.  But then again, why are we trying to support
GFP_ATOMIC vmalloc when there appears to be zero users of it, a
whole year after it was introduced?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

