Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C036606A329
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 05:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=YzLPmqXY
Received: by kanga.kvack.org (Postfix)
	id 441AB6B05B3; Wed,  4 Nov 2026 00:21:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417CE6B05B4; Wed,  4 Nov 2026 00:21:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CB46B05B5; Wed,  4 Nov 2026 00:21:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 169396B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 00:21:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFA34A0657
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:21:27 +0000 (UTC)
X-FDA: 85396288614.17.CD1F030
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E4C840006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:21:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=YzLPmqXY;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793769686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3sZXHpAcPchFFTmYmyd75A+OImYl038QKcmLNpDQcM=;
	b=7j7DhZm2eva8dM4f4Kifg2S77PwBR/viyHD92CCXPJTFdLOy9vt21H8tk18+jrnzpC1NlX
	4LKZ5rMbDvvxQyE9d1+f7YQfT3QP82DrvfExN9ipyiks0JGNixwSm0WrOD8yhKHY4XoZBQ
	mY73KH0+o1KHIzbwuPYb/Z55r2bjdpM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793769686;
	b=JZia54sGc8hMypjcL1jqf9ent1VoMG+eivVk7aOp2A+nuwM0gli77GZsdf+hl6TNB3KzVP
	ED8JZXpk9suWNQaDYO+wAqrWV4THJPuCpUJ/tpyJywp0LFx2uMFA0kfuikDoLIemB2brPo
	j1LTFXy7k4hCigv602jW12RPMtcdQ1E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=YzLPmqXY;
	spf=pass (imf11.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=S3sZXHpAcPchFFTmYmyd75A+OImYl038QKcmLNpDQcM=; 
	b=YzLPmqXY0MxXcC9TMOXwtUj7onQ5u6uagUGMGvdjIpVkTP0Dv23rLhmSumxfZZn9cA6gKZRTLLB
	zUUP6RRaHjDRbnuMAMqEcuo7nQHB9PsSZBPM0FnxE9Q98mO389RY3/dWKz1C958KgOmh16HLIOKtc
	x8cUnVMgGtq+BggapJkv2Bn36/SFC076gxdVbV5Jq6XjHbUfxzsEdgrOXRaPt+v+zCSF5MuA7lv1C
	rmHeiyTOMCaynQwEazXm1jotf54Q72+cISoQelnRNRnE5jqXHmklBVLsl7GiCJ8J9VmVwxH5IB5KO
	iBPhK7SfwtoU/iY7fhPYXRvyuSnkjDLm697A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xOTQr-0000000Ajf4-0KeO;
	Wed, 04 Nov 2026 13:21:10 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Nov 2026 13:21:09 +0800
Date: Wed, 4 Nov 2026 13:21:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
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
Message-ID: <aurAxRpCwzeyXeVj@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
 <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
 <urkgmijyytg3rrislm5fdzmfggqavzpiry23f6lpkqonvy2tqx@d56stj3eixfa>
 <auaFhOa5EBz4gJwK@gondor.apana.org.au>
 <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: ryds64w3jw71fie4j35zcb7wxrfpw8nc
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3E4C840006
X-Rspam-User: 
X-HE-Tag: 1793769685-131001
X-HE-Meta: U2FsdGVkX18OHxUKvzsg3KvbSLkBEYM7H/1WU1z1zOpthCYKk6BU/FCGW+EzM89QiR4k4WPXJ5rXk9VtckwN5nlP8GfLoj7i5eezkBjveqjuZpe9cMJ0tmU9U5uIsrRJkHE/YG/zqVru76UIvdiY90/MMN/xc5srPHR5+QzSXIGjyJ1/s4Ov/DuityY82qfPJ/YP6I4MF/yRpnDTyLjwxuvy1xQiOFkvKHc3AqJUS+AIU1tljpZDdpBGxHSUa96gNXkmEuDpBsRR6r7ICSmH6BjDgVjJ0LEbdvG2Ku4Wbx8qaD3qs21e6Z3ZVwOMatAUmDAd269TSGMsuu7/uhScvdHRzQFCuqjFU2VgyQcaZvUL2IgQ9ADoRmZ4bqOGy7Gzy1iK6IvFm/S1lwEjHt563kroS+qeJZ105AG8aREaaa7KJTc3W6TX8k1t+hoK3hOlz7p2fstkgqyUKhq1I6ST2pkPs+mL4qgCAZmrAteCiRaMA95RaAjbqqYEFnJ93ll12HDUr5B/hC3zGs4qi4s/YGkNqXLM1wcdLJ9+xbcXGf6zUEl+8r1ngf0OJk2MRsm1GKPwfhSl2AmVWabgILbmnxzQ659D/DUpyPH5mbTIrATSZCqmFTr/G3z92Y2E2VLTLXgLn2arP0LZWwICIloIWOL2H7dmb4Kuvlp8wA75n2IBRs6v/qtqxyh6MsqUCa2qXGi8zKsom4DUtBcaunxhc5UCYnOGCk40TO+vCkJQg+UfOM0QEovV3V7L/PyibPJPoML65aKE/CTS6eEye2VAFAnwZwO/iWEkX8Q9CJA4fjigLX7eCxEuNPg4mXCxtzS9dAJnd9vBqvV3QlcDgEMlOk7LfikRN647fOf1Uo1JaG8tQdkzhCc3DfQNpeQWTTMfDSD8Bpl+QB5cAocQ9xun7XsXCkTEB+RxPecEowEIGF1WhbIhAx30LfPWBjRtPXKyyGNxUN7pPbSMNRAkDt6
 aPrnm0Tg
 m1q+lgDpSt6el4oI8+S9bLfzjWU3W9z6z9mOLWBRlalqyc786Kh2T7uO49b+vOZepu2sh5PwhKkUOoXiDvhYeAxfcIza/sh/E8qxx59ZUpNLDd75NWEepglSfn8GyTL/eHuBg1SpibG8v/+wFm3ok3kE487qtdMGFKadnbIMxKEhNZc4EPERBVWykCcbKkU8EUd/K3C9GyRSqnvh3cSeDm/IdfJT4W17+SXy4sV+Z65BF75CklxA0s+Qv6GXqFM3QiLqi4nlBrHQiwnBpcWMOqTcsu26So7Y50br3GiEMfohbwtLeR8ynlliSTpPI1gXiVdpCUtzVBIGSi0kQxM0PbF2VK/vgKVho90aBamTFqw4G41cJNEukAHoZYrl+374kP1G4koyhg8zCDHc/ug9Rnp51oHg14Y8EcMNL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:28:36PM -0800, Linus Torvalds wrote:
>
> Sadly, the commit you point to doesn't talk about *why* that
> braindamage was done. Looking at the original thread it seems like it
> was for kmsan.

Here is the link to the whole series that was applied (v4):

https://lore.kernel.org/all/20251007122035.56347-11-urezki@gmail.com/T/#m50cf87c3f12015a56abe5a6359525019851f1b97

This is the original RFC:

https://lore.kernel.org/all/20250704152537.55724-1-urezki@gmail.com/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

