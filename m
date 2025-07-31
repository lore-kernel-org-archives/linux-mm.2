Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04DC1C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF726B008A; Thu, 31 Jul 2025 13:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9804B6B008C; Thu, 31 Jul 2025 13:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8967E6B0092; Thu, 31 Jul 2025 13:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 758706B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:31:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5EF0C098E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:31:24 +0000 (UTC)
X-FDA: 83725251288.28.B559B23
Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5CF8D4000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:31:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=Qo+ksQV8;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf04.hostedemail.com: domain of dave@stgolabs.net designates 23.83.223.141 as permitted sender) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753983082; a=rsa-sha256;
	cv=pass;
	b=ecWPDoY5S1yeQe0nAQmMLqXNfCTKNrA2XqyEdIa70cFYu0p+0fUixJd1s9AlnFoEZ2WFaj
	xNdj7CmJHCaYQSwz4Z3OboE7m8Fz5kqkrpAJ7PzXFUJdWGp/eSAqsvUeS8Mlol+GT0+zId
	Zp0pSPX63NEboMl55BUYQWXRDkjv1Sw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=Qo+ksQV8;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf04.hostedemail.com: domain of dave@stgolabs.net designates 23.83.223.141 as permitted sender) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753983082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWclPkMjxUD+/NTEaRJVfuw6R1asDfrzpU0eqwsClcc=;
	b=NvNVgo/xHLVxnN/s4eGLPpRNADM7p1KXh3P/MANT02ieBzvN5b/+rZtrmeiFIIF1k2XQYt
	9Cg435QiRNxSgEGBjcGQ3pWYiHEdhu4iPzZawCCngJTNBxUCGlMnfVwMEYxK9uBjIY6zNH
	pczrvH8vPLxv+itf9S2P886WH4l86jE=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A30102C322C;
	Thu, 31 Jul 2025 17:31:20 +0000 (UTC)
Received: from pdx1-sub0-mail-a245.dreamhost.com (100-123-72-202.trex-nlb.outbound.svc.cluster.local [100.123.72.202])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9B0242C2FD1;
	Thu, 31 Jul 2025 17:31:19 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1753983079; a=rsa-sha256;
	cv=none;
	b=uyrzBjTtDWoV7Pl97ZqfJ5oCtbRqjabgvwspHeq7IX4Xs1TQLzNobaveG4B89TAMXo92ZQ
	lIz6ri8HK9bdRfhSvD3CTf3OngBF35b6EyycwIyy+uwOPivJ9gR0tnyD4wYHljhoyhWamT
	MVA3opk+Cj7mxyxA64L9WzzNuVjRfbP9IZkic0dAaWyZyr3UHTUEIdYgf9cgCzbYQKeZtC
	NGwa4w2ulNq1QTZHIuv9MG2XvtpNrlcCc6EUqi6MCipoqy9nX+4g50NmTRtEfC0sI9r2es
	C0ZDlc6IhFyFfbuxGOH5SQqQE0N3TGe9KJoOhN4tJ5bau2EcaryGIn4cSin7pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1753983079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWclPkMjxUD+/NTEaRJVfuw6R1asDfrzpU0eqwsClcc=;
	b=jbbEq8XIgwQvgjaCYy3YBVJGhp1VNRtI1dD7OVZWLqW2GVkdVwrO5Tq0tBuze5pANOFArF
	TSSrt/lnTspvC0EGlpcJdQ3jEq7Du5MhM9q9ccwt2VpG3vuvH1tGI/Oz2BEcPmBKpbIMKV
	yWrmXwqGtOYGQr93BTbquXiIqxKESu//KX/4dw9dlUUr2GbJ+uUccOmYQBpi+jLRU6LyMM
	s3EmJSkpqU4qV1cNw/g5UkVJQhVUz5jOgdruTrJdSwn5lsNKBBTEt6R5qeapzZelfkUWj1
	N5NUi3lOsCQS2CM9ws3vz9FD4TROXXOdDAxfTxa/rsuoQRaMK9dO/aGepWIDSQ==
ARC-Authentication-Results: i=1;
	rspamd-674584974d-lqgt6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Eyes-Gusty: 6b12fe6574b28742_1753983079956_3957697839
X-MC-Loop-Signature: 1753983079956:215934665
X-MC-Ingress-Time: 1753983079955
Received: from pdx1-sub0-mail-a245.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.72.202 (trex/7.1.3);
	Thu, 31 Jul 2025 17:31:19 +0000
Received: from offworld (syn-076-167-199-067.res.spectrum.com [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a245.dreamhost.com (Postfix) with ESMTPSA id 4btGMp5Pz6zB4;
	Thu, 31 Jul 2025 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1753983079;
	bh=qWclPkMjxUD+/NTEaRJVfuw6R1asDfrzpU0eqwsClcc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Qo+ksQV8CHsEepnpUdcRI8W+C8SryZEte9fR7uMeynAaxpPwIhC9Z8tFnGQzi5gR0
	 P0QwJ4a78Nv4dAGl8ifLr+3KtN8q/auF6YBjAnJXSL9PxK55QHzpLjMBCDg1YoKr8N
	 s5aQ7zzYBURLnSNd9xCYalALwzN7qhiMuSEkjWyyevPuAJhJ20mNgO1qETPhE8UKOu
	 i63k3pI/MLzOav8DRSW/pwGptfVO/+IbWC/lQjg/4Ag/ZoNH+jaTn/GUjv0YH1d7Yp
	 /anUi523lxthZUHVattYUjjFA/50jId5zhlbJEVTkLVO2DtNhm8dFeFltwZXhqZIb4
	 cBNIEFbYRw+KQ==
Date: Thu, 31 Jul 2025 10:31:16 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: David Rientjes <rientjes@google.com>
Cc: Fan Ni <nifan.cxl@gmail.com>, Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Subject: Re: [Linux Memory Hotness and Promotion] Notes from July 17, 2025
Message-ID: <20250731173116.jf7bex7evice7zhl@offworld>
Mail-Followup-To: David Rientjes <rientjes@google.com>,
	Fan Ni <nifan.cxl@gmail.com>, Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <c2f5a8d7-061b-7649-2b9d-03e6314d1102@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c2f5a8d7-061b-7649-2b9d-03e6314d1102@google.com>
User-Agent: NeoMutt/20220429
X-Rspamd-Queue-Id: 5CF8D4000B
X-Stat-Signature: 87kd1gdqt6kodx9rwqdoy7o3f7eoe1wz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753983082-773898
X-HE-Meta: U2FsdGVkX1/SIy6kePwfFWrCXPz0ha37FlENRM0PCkbEvgiG/n3XDY6Sr+jjdZOSmfrJZ0mnpMaLwrtjxBw++cvmqTZ4Xzi6vPh49NpL8hM6vmw/a5oSPd0U3E8qF8lV8uVBLKNR8sib+sPNwBZng9KrfTYYzkpeAnalphzkwAzIR9gRx630deFhdh1N6oLCF5/yZFGDyPVixmOUl1gMuIFD+Muoj5IRJZs69hRQE7UvY3YDO36zxt49pxj4Pq/CQ36k50DianywfheaiuXB9t3M/fAyGlzEoJTz2Tknv8KTPl9r16eOYNXWDRWT8XzfChUP6gl6bX/vhjHCitLCZB8bvPNzF2pNAogXstGDpkOR8Wm8VBD84y6oe+qlpufNKK7l3w+Q8IN1aQc47b6VXQM6VQ7dIweT5nERwlTaIUfjoXSVxRKWuZBd5d6ZztLp7k6Ii7LGocT2uaRDyR4u6Qd5BZzMZbEBRxGeAT4dpnsbGI7d+GWtXuxp8haZEKV+qNf5tPJxcKo2yqza/3FRNtBFp3DuX743wE/qhC1W67LedDCPCA/QaA3fN1Xi0dG755HfiTDMk3DeFt4/JuSecnSdPHWz5DetBVH7XHZEuxk4ouUHHpHpkoRm00bO5xOy36Dwcohs8nOVbK0GV+V16fDcbugK34EjQmcKnQkWQeK3DDXSueWDzyJwOAZFBuqlXLRxSOjwaZCzdBw/E/0w4GaUS8plfZ13c82Fp4FrO/KtHPQpZL2T7s1oCDjuQGzDedTgsgUPwY2l0ef+SSpJgSKo9lMnLUszxubYmruTzvIFgLgOvpeA5xv5yqY6HfBADnqUJvwfSMXPA343ciBz7m3Lhpa7ndh5kWa9IK+yF7xMMzTK9XWeLVqcKmWHkbMNsBNQ3rDo+MMMVhfnAB7PzNFxG3RKQiDd/e0Fi7JV3FLSRYOWNC52PYcgqbxCHEHUK1OosIzSElZxy7bLfsP
 QTw7Pb9+
 vauG6/NF/FmJ0qmk9QwqdCyTIWExZlhwmhWBccvVvmRUl8qsGP7YseM/+i5bFpjcs8ZyYEpmzpf6vl9jL42Gd25JxbYeM/yl3xaj58KpYjvJjaXQhq6m+kDytLPT+1SZnFzDZdM59D+QaK2dTGUE4HwgaHIMgN7wkcepwlv/42zxhQ2iHxhpR2CniadP2XaV/dgjGoihyLxcGWExMV3MLnWO5cqWWmZnJ1isVd3RuwWH2YgDXdOFiUVxDigtyuBwppD3krdpoEZg88rYlRJy0CWxRbCKWQO1ive3LmAvPJBdd8H1gnye/Ya1wHWF8WhCld0yt8TFO3xyCFLGpetqJBzS+9LLYVrL0bqC8wOzjMP1WjAAARg0ou8tEpc7cy6FDMo75oyfrnnmgLgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Jul 2025, David Rientjes wrote:

>Topics for the next meeting:
>
> - update on status of kpromoted (collector) and kmigrated (promoter)
>   approaches and testing
> - update on sharing Google approach for both to overlap the shared goals
>   and converge where possible
> - discuss proactive demotion interface as an extension to memory.reclaim
>   + possibly leveraging working set extensions on top of MGLRU

fyi the per-node interface to proactive reclaim has also recently been
added.

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=b980077899ea49cc747afe003e01ca303b00d463

Thanks,
Davidlohr

