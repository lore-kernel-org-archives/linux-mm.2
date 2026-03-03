Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2B8EDA686
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3346B00C3; Tue,  3 Mar 2026 10:30:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9E136B00D8; Tue,  3 Mar 2026 10:30:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B686E6B00D9; Tue,  3 Mar 2026 10:30:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1506B00C3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:30:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D64D13A074
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:30:38 +0000 (UTC)
X-FDA: 84505138956.27.CDBD3F5
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39EB9100011
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:30:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=sNP1bgiN;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="f 7Zq6Le";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R550cmHtYFRQ08EMEWoEE+1PDxvJJAZqz1yBfyc1PVY=;
	b=6PlEeUBnJn8IEfQEMwu4AJUpvc6Xmvl1gBv3hcTYFwJHKv1S0fP9a/QV3nMagwo0aksZrI
	RtrX5l9jhVUAAHBnV4yUrkEvS3Mr+Iu25Kih4vh4jsNuoCu52BNZ6Wpm74f8Dtg9ExFJDO
	CU16ri5eTLOcRLJMzzbfqbN+TX47TIk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=sNP1bgiN;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="f 7Zq6Le";
	spf=pass (imf14.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772551836; a=rsa-sha256;
	cv=none;
	b=zg1p2/Asyi3vIv7bOVM4cskv7AtOSFb5DtdVIelNYgQY5/hTxsmvulaWu7jH6jKIq7Hhl9
	yb/jdpUJvjq3IawGwAgS1ZPlszxPN+WWYOuKMFwyUIndNZEfzNjUvJXamk7ji5Z9f6qclX
	Fy1HcTKUfUjWERTr3r7trURMes55rvU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 82D4FEC05CB;
	Tue,  3 Mar 2026 10:30:35 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Tue, 03 Mar 2026 10:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1772551835;
	 x=1772638235; bh=R550cmHtYFRQ08EMEWoEE+1PDxvJJAZqz1yBfyc1PVY=; b=
	sNP1bgiNQmps65bWuYOWiF32loNaTH4x5QUlVKd7hKBc9EHt7/ShYuWh9TIh4mrh
	bPrijlR08SPhShASfREXhuAcJ5u8CvmUebDyES6All5a9iSLWvfCs6jUJKx7eNTJ
	PZhiXrQeqeJ3IVmrEbTkQX9h1dP9OEWYakIzDTBeKqFd8QQTM0hH2FlKSb8+2t2V
	ZSznP3DLQb+jba4be/l2dc+sMGrOaWSXVa2yC08Gx7tslbhRCwCzj9RgF2KAK/9P
	xhZUq7TIXlvuvx+hES455BDnlkk5SrnFZpXJ2F/84mGIg+gxw/kEve+0FeVT/kTP
	hGme+IJ1O2ytheyi7b6yIw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1772551835; x=
	1772638235; bh=R550cmHtYFRQ08EMEWoEE+1PDxvJJAZqz1yBfyc1PVY=; b=f
	7Zq6LefmWx51xzLScfVH+TFIkejorq3SLuDNqmnZEmU7xXyTOKKF1y3/Kfn1rMkg
	OXBreYNTG7nq80U6VJvhUVt7tvjtHlE3IdU0WJEkYFhgDZhUbvnunojELXbu5o+b
	eXre3pebqrHvF00uZeVLYiOhtxuHhQg081R+GL+gFXoAit5J2rGBzTa/pfnKwjsq
	MWdFX8GKfXI1AQ+LxvfXj53tAsp+IaWsxED3Kng0liH/kNU6CY3435+9Nb2y3Dze
	5CgYRXvRgsJgFoFn6Twn5hmbICB1aRMI8TTok3cEQxf7pgfAJ2s7Q0Z9TIe/h5Zl
	dmfjgsXjL7GjF85ukeMHA==
X-ME-Sender: <xms:mv6maYsmMCGoIgR1nZZzeJql9wR_9S0X2Uih1Bn_Ro4tdYxLwL1LkA>
    <xme:mv6maQQf1FFpTsFLGLjfrt44oMymKjt-sd-T572XkA9a_6NEW-8_LDA7O4Ugw_QP8
    KkjRGbEg9HMwW2UFzC_Ich8aSDHrJf_ie-OLuJZBHFSI9uxEw7egOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddviedtleegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepjedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheplhhkphesihhnthgvlhdrtghomhdprhgtphhtthhopehlihhnuhigqd
    hmmheskhhvrggtkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhn
    uggrthhiohhnrdhorhhgpdhrtghpthhtohepfhhthhgrihhnsehlihhnuhigqdhmieekkh
    drohhrghdprhgtphhtthhopehovgdqkhgsuhhilhguqdgrlhhlsehlihhsthhsrdhlihhn
    uhigrdguvghvpdhrtghpthhtohepnhhjrghvrghlihesmhgrrhhvvghllhdrtghomhdprh
    gtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:mv6maSUjV3Ns2HpFPqArxP7M0ig2UtnYMyoXY9PK1fX5ogQvJQgulw>
    <xmx:mv6maYqUFjSHEG0Grsq4pVgW79mEQej3xeuMCF3l0pI1H6B8ndJcUQ>
    <xmx:mv6maWSWI4a7rfktwhrVdHNrCOPjQbLWxoX5dv-hhC5yjDrcjBqosw>
    <xmx:mv6maa3b3QAeO34GRqp91ELC7KoqSgXl_V9RiXQmNhBlyHimuF_Izw>
    <xmx:m_6maSd3oTbjMNFKbeh7Oedi7xc-h0QseScNE1khKgKrlSMbUDpNPdlK>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 60825700065; Tue,  3 Mar 2026 10:30:34 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: A8s3cHsN8Xz7
Date: Tue, 03 Mar 2026 16:29:45 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Finn Thain" <fthain@linux-m68k.org>,
 "Nilesh Javali" <njavali@marvell.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev,
 "kernel test robot" <lkp@intel.com>
Message-Id: <81916ff0-9296-4de2-bbf9-40ef0eb4c60f@app.fastmail.com>
In-Reply-To: <6bc11e2f-393d-16a2-9664-a20e2f1d3767@linux-m68k.org>
References: <202603030747.VX0v4otS-lkp@intel.com>
 <6bc11e2f-393d-16a2-9664-a20e2f1d3767@linux-m68k.org>
Subject: Re: include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 39EB9100011
X-Stat-Signature: ra9be718ckimogrn5naoq8n9tjutmxzz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772551836-64342
X-HE-Meta: U2FsdGVkX18ewNjssxmPFLrAEHQ8KdyAmp9MKGlCjLkMnU8RGJcruRlScIbOnQP5b7vApag9HmMx6SeOBxBPMOWjJcGp+xoO6hK5wQdbCW9Sh2vQ4EUYGLpz92FYwXeUn45njH365nb38VMVrKNslPUWdY3ddofe1ucISQF/nFKns6bH94pwJ1U3GUCCuTFh6iDk5GDgZYyzVG/lhT826xvoesesfWOJ/WoIls+A/wSeCsxFcp/HIgHNjTWZlOnqc0jxxDrPP3QMp6Kqa3iPHMU7usJiG531wJvn0NE0mcjdIBuCurK58vhKOIPsEPrcVqM/ee9bErvRIn2T7dnxf1WmPPj8B3gjWu3kRWA9vGGiYOpjMzxltMhRiCSJiYKNsocRYBVK8aqGzXC926nGzgJK2OQ5wWK7Sq4Q3+MP8XeoBkgrSsahz3zGabnpnBw7ZMvRj37M/rAKdOm81SO2nyb/8t7VTJWihbxia2S1RIAKCC3kXvr8phwLaIF8j+2md+V99mXsZCZJ9Oq7sDrhZIPVDCJk8MTdp0lEYvwDXKzixrwXUtROcwsArcsFQ0y0aPTISWYWg/x1ZH1Tn40AfcCXOSxgX4ajWjWMMt/a37ROtOcSKA9yDJhT9b214Jqx2DCiHp5sBNmSs8YHyQTOIPer/HYEfvIxhg8jveKNhAtQ5ChfvMXv5tUHAI7Jjgb1l52uFAQT3wA7bi7xSKv7l77NJhFFsd5tIGPp77XAj3v1AOq+nRLIFHgeSQ3FJR0IxSOW9CxuVual3US3h0lK7Z/KHrb98196TU/rCZ2z6DfEataZG27C9EKt4UbqBJZUwKnNsIqm5KUIADSoKKLVLG5M43QPlaGx11QDVzgb7LkMfEAnDFNwsl7JeMs0lUBaJIyuD0Y2WEH7R2GUGO6ySs3kLSNLw/0BYrQ8EN2wbn8iUW2aAmhJzZ3OV4h6tl63kELxu05d9LWqNGyhumm
 iEe8U1J7
 kKihqtIY1DqMEE1gQkELKiDE8zNeE3lVYmGk/Dm6bMuum+iASEP9rtXXLmo/ZDH6S+KDQAyjk7khgVnRGt1c3LQLMcj/OKFgw3XwCGpX54QvgNO+t3a2NUQst2soGoSpQrk3Cim5dN9B1ZdLmr6ovnb3wG5AmaJAR0lphwYNEd0Pmy/qCxVFyVXb3vC5JILbJBuIZh8+tOuGaynw9Peb1fipvMNwyKm3n6/uKtXHbrnpkMpdTxQHe8BFjyohf9qvST/x0AlqKtQtYLTF21zakkLphG38D6P6i+ES2AMwwlSS7CI0rCPxVfch/0hiFLcbvFQJdSzey2SRaIfdVCUdEqtg/aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026, at 07:48, Finn Thain wrote:
>
> --- a/pahole.out
> +++ b/pahole.out
> @@ -1,16 +1,18 @@
>  struct qla_tgt_sess_op {
>          struct scsi_qla_host *     vha;                  /*     0     
> 4 */
>          uint32_t                   chip_reset;           /*     4     
> 4 */
> -        struct work_struct         work;                 /*     8    
> 16 */
> +        struct work_struct         work 
> __attribute__((__aligned__(4))); /*     8    16 */
>          struct list_head           cmd_list;             /*    24     
> 8 */
>          bool                       aborted;              /*    32     
> 1 */
> 
>          /* XXX 1 byte hole, try to pack */
> 
>          struct rsp_que *           rsp;                  /*    34     4 */
>          struct atio_from_isp       atio;                 /*    38    64 */
> 
> -        /* size: 102, cachelines: 2, members: 7 */
> +        /* size: 104, cachelines: 2, members: 7 */
>          /* sum members: 101, holes: 1, sum holes: 1 */
> -        /* last cacheline: 38 bytes */
> -};
> +        /* padding: 2 */
> +        /* forced alignments: 1 */
> +        /* last cacheline: 40 bytes */
> +} __attribute__((__aligned__(4)));
>
>
> The BUILD_BUG_ON assertion checks the size of the struct, which doesn't 
> seem right, because any padding at the end of the struct does not 
> interfere with the subsequent kzalloc() and memcpy() in 
> qlt_queue_unknown_atio().

As far as I can tell, the assertion is always true on all architectures
other than m68k because "struct rsp_que *rsp" is word-aligned and
"struct atio_from_isp atio" is either 64 bytes long. The intention
of the assertion is to ensure that nothing got added after atio,
though the way it is written does not take misaligned atio into
account.

> I suppose the assertion could be motivated by some code elsewhere but I 
> haven't yet found it. So perhaps the assertion can simply be removed. An 
> alternative solution could be to increase the 1 byte hole to 3 bytes, and 
> prevent tail padding that way.

The simplest way would be to force atio itself to be aligned
regardless of the architecture, either by removing the __packed
attribute on the struct nack_from_isp definition, or by
adding alignment on the variable:

--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -844,7 +844,7 @@ struct qla_tgt_sess_op {
        bool aborted;
        struct rsp_que *rsp;
 
-       struct atio_from_isp atio;
+       struct atio_from_isp atio __aligned(8);
        /* DO NOT ADD ANYTHING ELSE HERE - atio must be last member */
 };

In general, the use of __packed attributes in this file
seems a bit inconsistent, with outer structures being packed
but containing aligned inner structures like atio_from_isp
and nack_to_isp. It may be best to review all of them and
remove as much as possible, but that's not necessary as a bug
fix here.

      Arnd

