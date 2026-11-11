Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E09606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=HgFHX5p1
Received: by kanga.kvack.org (Postfix)
	id E96F36B00EF; Wed, 11 Nov 2026 10:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47B86B05B0; Wed, 11 Nov 2026 10:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D373E6B05B1; Wed, 11 Nov 2026 10:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7BC66B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:03:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4175F120306
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:03:44 +0000 (UTC)
X-FDA: 85423157568.24.48E65F8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6E7644001B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:03:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="HgFHX5 p";
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794409422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQnYAB/C+eI6pAG5l/jjeI/RO+deMqGieJdX8Y7TK6A=;
	b=wktGqbmUNaUb0fElzyWbyGWXdxZNJ74yBXT6jyr9o0vkC/mFGMg7k58iMbttzKR1DyEvbZ
	TDr5hdjaucSum/HMapyPUVD2G3Dw5+A9iNNY2K2aaF/QQMQ8dPagA2RCEa+e6H6vSd2uyX
	li+y03GZOgwA/wxdpmyaWFHUIlQveZM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="HgFHX5 p";
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794409422;
	b=YiKytra0T7ZrZjPSHPGTUWLYKfE37/8khdDKGE8AXPMSK3hgfGBhXVOAL3WfqfUz9ia3aS
	miX8nxBT78aWjUaysBqBa/Onh900gs5pN7TH/ys2YDsZA7W/BjtlJAUc1ZlJfwtBrMJPZs
	oun6H9TFCWVLyW8rjXMgeyu1JkVHr8Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=jQnYAB/C+eI6pAG5l/jjeI/RO+deMqGieJdX8Y7TK6A=; b=HgFHX5
	p1xD+9V4hYBFwoBJgAOChZw+EZPBAOyznwTsK/glQXufjeIEIGrJxCOwxlfv5dD1o0S8DY0q81upd
	Q/7sXAKQNY/jL8Amq6tpsw2lCIISxj1908XlikRepR2CBw7dpbinbb2qLvc/E7Q1ZC5fLQzeY89Ys
	IusdWe8CyD5h0X+V3Z+Pkh5aJ4XhA1BhsxSJATTTQEa9PofXayAB17swIQnTns+YQFatGBJwAD2Td
	EUdUY0JwQ9/KapZy1611x5prmDlIcQrj3hCiZHjVQLrokKZQbebJY0E5yZOkeg4f1D9aHLCv+aeFy
	J3u4VccK6HPK98V0RD1xhfO9aMJQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xR9rI-00000003uO1-0I6q;
	Wed, 11 Nov 2026 15:03:32 +0000
Message-ID: <9e91f87f0ede919746557da8de0de19a27b410ff.camel@surriel.com>
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Yeoreum Yun
	 <yeoreum.yun@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,  Michal
 Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Yuan-Hao Hsu	 <aa9736195201@gmail.com>
Date: Wed, 11 Nov 2026 10:03:31 -0500
In-Reply-To: <e66b6c19-95d2-459a-926c-8429df693acb@kernel.org>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
	 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
	 <e66b6c19-95d2-459a-926c-8429df693acb@kernel.org>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: gt3mpo1extryobw38nozpunn3itgtb61
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6E7644001B
X-HE-Tag: 1794409422-540251
X-HE-Meta: U2FsdGVkX1+HmDraVCqvW+vlx5971ja9Xy5hBSVJYko/0HFstgZSAmyAWvNB2OwPp2d3GhJUKk/DE7+sQAgn8G/Jqe9mRl1/Nelo/xin3r27aAJaTDtvIV5GkYJlyKPKvBJM/+7ZKZ/KZcKdSlS3l2hBshHI1LHusOYszmaeM4Hz4mqGAi9lE62DcD/53jyCTvNMUt6ZgHJ3mXbB13v/dJl2GzFD3OUKxkbNRKQLx0GcufT1JsLSJisOH7+LprAyA4ZEAtfJ+Inh54Qq9bOj97DU+f8fURYZz9gzIyHfFjMzHJJRUfi0GHpnFn7xZoRpuRk7NUgBZ+xlNympxpN1LdWAnc/wokiubXoUQdeGj8vuqW4dGrhWa2w2REhpllxA9pd5A4nLRl9WuoOwPxKrHD5xX+RcEZUIZblEUX+Jzl0G52vdhA4zzCW3U8oCpICtuJkWdVeMhg1H/0PPtKaXCraHGbeqCSUCim81HwUEJ4Uud+svnWXKlMTF7cQgCxe9WPtBSPPzJ3TUqlV6nR2hugRYJ9LDYE6hx9i0FRUSSCpVCdcTG2s1YqhnIYKKQCgcqG2QybJxjTNDvTUNT3tYmJ0b+B1aAeEtAqXVy1inDitz8AIlD2htYp+1qrNShd9QRWn8i8HJxgp5pKjSfsEA9pPvJnOTM7D0tPYBHREto4rtGXsljqlzRLgeY00nBAZYu9NtndNaPKIe8T7URPGCzalKx2Z81hDQG3+tr5IFUmfJ6VfAX4vxiCX84TaGtSfgiGraxdMSCYjCn/FMsDsKrP1t5uESm6+gPXsj6wAeRN1k/hIsp8+9AvjzEW4vpGyv3gjswU0QoTnPh9JdTtKTa/1UVZGZ5tsEUhY8Cps1tLfmFjIoPyvWbVy/LC5UKhR6Nafp896lkN7kCGAIgyQV786OkS1d0ejEpw7C9lLbkbg2o/jOZGsgJ/W2ZABiD7iKG9MZb/wJ1QD+KFS74VE
 FjvVeTXH
 ZYLVt+ncousMLhn8gg22RP6Fa06DgJP6De2KjQuEokZgiqA6TDmA1PB+uJRthyEinaD9QIWd/h8VHn1tndCpC5LCXVe8+pUKE8a7KCdap+bbLXrj+MBIcuiyjwYXgowc21WzM1lqyUGSkuU0XKYAbRl1Yb1CtexdkLqI+mdgYL93gbvNCu9363CtCjWNGflY75UE1x/fHTVNWUHTpjrZXJYT5FXQs3XV14EFCUYtuUoGOpsUJwEvH277FvGhs9hRo8rDdg8NhmgppBsy5tkCy0XMTpffpmqwESwxV4XnvK0h+RalX9SAe695p7+sBJteHhIekwrUiuhcli9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 14:06 +0100, David Hildenbrand (Arm) wrote:
> On 11/9/26 13:32, Yeoreum Yun wrote:
> >=20
> > -static inline bool gup_must_unshare(struct vm_area_struct *vma,
> > -				=C2=A0=C2=A0=C2=A0 unsigned int flags, struct
> > page *page)
> > +static unsigned long gup_unshared_pages(struct vm_area_struct
> > *vma,
>=20
> Besides the function name, LGTM.
>=20
> gup_pages_requiring_unsharing() ? Don't quite like it, but something
> along those
> lines.

FWIW, I'd ack the gup_skip_unshare_pages you proposed
last night ;)

--=20
All Rights Reversed.

