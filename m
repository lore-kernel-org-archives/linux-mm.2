Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ED66606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 00:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=lkyQI4BJ
Received: by kanga.kvack.org (Postfix)
	id 113AE6B00EF; Sat, 31 Oct 2026 20:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C40D6B05B1; Sat, 31 Oct 2026 20:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1ACB6B05B2; Sat, 31 Oct 2026 20:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D08526B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:19:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D8FD16086F
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:19:38 +0000 (UTC)
X-FDA: 85384641636.12.E8C75F8
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf28.hostedemail.com (Postfix) with ESMTP id C498FC0003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:19:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=lkyQI4BJ;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793492376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1C0upMKH+zbLi4SJoiKyMvaAF5IBekHbTFPSl9D526s=;
	b=sCHEbhcng7rMZDm3eqSoEk0EZQ/YpyR9Sj305BDT6eeyZRGl9S1IUFBaQMQrAJELcF3V3H
	uJoaZcfgKzEwFAT9qR3Hjk6Up1qb92eEVgEyPpt77THc9p4AFwgpsUZVrHlGb+LGKTXWfW
	YyArZj1BPZ6o7SaOohNCknWGKCMm3i4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=lkyQI4BJ;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf28.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793492376;
	b=YBNprWCIQPsGN26b05HWMcZRwMVtKkZp9X2dFUAm4J6t36cSj1h05T06aM9muEESg2TL9b
	ZUMF4neBVdOty+F8as55NVIhziAVBVTepR7xKQDMMv45uZ+83JS0gM7o8WVNR36WcT4CyL
	FYnje823rN5Zq0tH/oHAxycpS1u51Ls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1C0upMKH+zbLi4SJoiKyMvaAF5IBekHbTFPSl9D526s=; 
	b=lkyQI4BJQJM4QlpFUo5SzXFSGLC4h9MwwD8oRQBAnobiz6XM2fsoCt2xrkyfzuBcm0pmLwYFv91
	aDWf3RC5jq2sqrGwTNNz3RQHUAZKwhT21H9Py0aeaKI2FXP9EMMEdSJ5f5oiESJb9Dr5VUUHxunMR
	Y0GYxx/whefT7APpF8NowSHqbdTueONn/SjoSwxrc6CRtjCSWHN6Hl1ht6e4YiVuw7y8HKzfVPbvC
	mmp+V+pEu6a3Uf6KruAQgje0h/LYiBPYosOzXSAXfLodwgMVgzn65/IMpLQYwztCZDTA0QFwi51Zi
	uYj4nGY51xJ1qmURuY5itLz0WmitqsUrkB9Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xNJI4-00000009U6S-0XzL;
	Sun, 01 Nov 2026 08:19:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 01 Nov 2026 08:19:16 +0800
Date: Sun, 1 Nov 2026 08:19:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>
Cc: Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
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
Message-ID: <auaFhOa5EBz4gJwK@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
X-Rspamd-Queue-Id: C498FC0003
X-Stat-Signature: 6n5yg7d6nkuhnockonki785zswx9tnto
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793492375-683244
X-HE-Meta: U2FsdGVkX19Hon2v40tx8UUXfesumiElIQXqydQpM9gg/fbw13U7k48+kDjweyHT5VaUkaDwluf+KsUJfEbTD9l4AK72VgsDSVVQBA/01KUWUl7Pxd15OZrTErAoeh9MI5fFuH6qLwTRqafEWtmP+vYcPEMXiiKPx+ecz5w4i1ToeRCTs5ynzL8CBVvGrOlGhQqeyro+N+hmued/CBxCGELKL6NTylewedLjcNFu3/Nf3baOuaWYqRzEyeIZf3W4PqWNhBEJOXw2YK2bF+UzrvWfQqzrTql/zlrUHb0VGq9BpgzO5Zehj60s+GCYfwmhORyUtF21IEgsfXpZyIlhCGh1hhfU5pWpY13WPmFTU/GWiuqMOyv671fNYwNeGzmTdyv4GjVYKM0N5ZKLjjTjM+A6mPtVc/5t5MeYTPyzVvX/h7OiRkxQNHyTPdtbDr/ElK4bgCfdAX+tApmdSjTOyb78JmdpKUjaHXQ5igMBSPNACh9SyCwKG/qOZmpda1XT04ZF2pIEXKhYJ0NpdmV8BqTyIt34zzvMGRgvl9eY4Sa4SWgjA+bwD21/wVgs9vkb/Jtx2tBLt5o9zTmkvqF6LAw3TL1+vFcpzsd9vwsdbdcHJKcXel40TojHCVrjy1jckTCTI4NTUqOpGH5V8Tn2zhsNmbZ7qq+HcVYHDz8VU4RpDiqT+KmjYseWdSSPlV2ikXKbE8u6ElmVspsvlYVXFqZqW6ZT5+jShdMKaZLx1qvowmwYRMJCjf7qHvgultLwKaElTjBXIINXiCdPIoYE1N1uIJP1OvZ1Z6207ePvwcspalRYFmIebV+IL0O6GelH2ICxUXbKHoL4/NJMg7dSe9UdA6ZTTjSMjlzVV3AqNTFqU5q4OeRHXjsX9gDmhnF5LUVUYkm+0TRFD93Fizo6d+NWd7n6irdXDUA8aKRd82ns9WGqTSVltCEAHGwRcjPf55f+LHCYcJ8FIrJfmFC
 54CiHKDm
 VEZFeeKFnHxD4S/31pWCBUCOG8y1DAK6Y4Bnfhl5HxmCM4l8eeOHbvsf+q4UcGdKLWqhA9EFJImyK4ZXkCOPisDwgUnvGSzGU9fhUnLnol/oJs6j1H/nuoAA+O4OP/Cstm+MCqeAgnWtiHDRENY4Ww2+xWWxmdI/0KxhPyTUG4R5nJzNwIx+aecHMZdvzpklE85qwmkV01nyGNm3njbZTO2AzsFb62/thR+5KEV1qvC+fsddc5Ol9+kZXmj2hH7uMWm7FqD7AawAEit0SZVP61K/AXL94HCAL8ARCfkoCzU9Sd28ZMN35k0EJJ+Y3tppIwQKlPyV++8dLoRvboogVBgAFDOBqwiSCdsq9dxsxDePwAJ4pV5Fu2+0zGpC4d+RnHdyliPHLkcyoVR9wgoXp1ck/on0l9Xvdk2/nhs4ZoQqVn5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 08:56:03PM -0400, Liam R. Howlett (Google) wrote:
>
> Hubert, I have another version of this patch set to send out, but this
> particular patch remains the same.
> 
> Are you okay with keeping it the way it is for this release?
> 
> I don't want to force your hand but I also don't want to keep a valid
> deadlock scenario in-tree.

Instead of your patch, please revert the original change that
added kvmalloc to rhashtable:

commit 93f976b5190df32793908d49165f78e67fcb66cf
Author: Davidlohr Bueso <dave@stgolabs.net>
Date:   Tue Aug 21 22:01:45 2018 -0700

    lib/rhashtable: simplify bucket_table_alloc()

The newly added alloc_hooks_tag call should go after the if statement.

This patch should also be split out of your series and posted to
linux-crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

