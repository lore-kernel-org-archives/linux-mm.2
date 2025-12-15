Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A98D5B857
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 17:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75916B0006; Mon, 15 Dec 2025 12:09:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D6C6B0007; Mon, 15 Dec 2025 12:09:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9400A6B0008; Mon, 15 Dec 2025 12:09:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 847886B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:09:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21A941A02F9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:09:22 +0000 (UTC)
X-FDA: 84222341364.17.D30DEE3
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf12.hostedemail.com (Postfix) with ESMTP id F16AA4000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 17:09:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm3 header.b=DBmsQD4o;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Z 9u8MS0";
	spf=pass (imf12.hostedemail.com: domain of bernd@bsbernd.com designates 103.168.172.153 as permitted sender) smtp.mailfrom=bernd@bsbernd.com;
	dmarc=pass (policy=none) header.from=bsbernd.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765818560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVWwiXFD+0T8MSjifsQoEy4fskO/HVJ0qZSwyVu4ZIM=;
	b=dTSqGqTE/fIfdrlEvu81YB+B4SgsQfNe52qrr0rlBReLCNtATPF01c4pfXC+f1bzGIi725
	0XfeJhgFL3klTU45ARtndItYkzOkTYhB9hmw9Ky8qh2UPyy/ilJKjgHHyNZg+9j9YnawWr
	UzjrVVtvfC5z3tkQ3oM/GLc+KP2gfBo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bsbernd.com header.s=fm3 header.b=DBmsQD4o;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Z 9u8MS0";
	spf=pass (imf12.hostedemail.com: domain of bernd@bsbernd.com designates 103.168.172.153 as permitted sender) smtp.mailfrom=bernd@bsbernd.com;
	dmarc=pass (policy=none) header.from=bsbernd.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765818560; a=rsa-sha256;
	cv=none;
	b=C9hzZ0+CMl4X3Ij/oExM2ghT4E7W0Nbkwi8mkoYsap69KISQvQgpTDI8hJI1vYyLYoa2iz
	Qw9RelztRX2CyuMuBB6DEuKjwlWng+KmGDW2V+I22JuJRAKr1viCEN2RERdFiUHffVivJG
	ox6AJ+WHDY2/Ws5TxbxVlls7bvmstCo=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3EE6614001F1;
	Mon, 15 Dec 2025 12:09:19 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Mon, 15 Dec 2025 12:09:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1765818559;
	 x=1765904959; bh=xVWwiXFD+0T8MSjifsQoEy4fskO/HVJ0qZSwyVu4ZIM=; b=
	DBmsQD4oMM0qgWntCWtu0WtfgCf/MbXQL0FUzxGBYcCdiKwv6Ob824yeOfiSuBdV
	P1B90i6yCqsvXITHwrN+TSar2UAJcowbupdnIalHEtW8LBAmrSWKUhvHvbIaLJ4k
	jShsXUCGfXrijIeeaSbeTEJwxU4C/+fWMjhxWYiyvxVvmBUtKRer9/QvmRJQbDQT
	o1sXVzHHZuS+vFq+ZxmBtaSoS7krHEYHF8xglr2nqgbTh25V9wXTBWmzwb/EEc9d
	jvGwGI/vlrCEkHUzawnhwuFrN9HUs1ezWODsu0QFVWuuzv2pE/YTZhP/K1KEvjlV
	Uu2DLXq9S/ln1gdbpSN6FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1765818559; x=
	1765904959; bh=xVWwiXFD+0T8MSjifsQoEy4fskO/HVJ0qZSwyVu4ZIM=; b=Z
	9u8MS08Ik++NoxS3z66EZ0cJMm5KvLl6hGst26/iYdACNhfPrRO94El2ktlKhugD
	J80UG5N4Pw/OL78tsDsmMjLopfPrabQUp8gS4BbA6YRoReroHKpoYsk2wYnP1iHP
	p9zpvahy7mx4UjOLQyB2EvDXX88qBCYGxUPif6HJF+r/OAGzb/lfdjlSMXKOfy6U
	mRbpgHMmpET+yL1BZRMcdDxQZTZzOn0GhNlyI9qszF7/D1VGRTJBX4kqWVrJQJFr
	kkjlVZbgzkwcbArq2jtbKlhmFPmcfAt/Hqkj/VUV1pF9Fk6BrdGVZK3S/0EfrK2g
	HHxlroYaIcnqDyYLh3f5w==
X-ME-Sender: <xms:vkBAaTnfn8IXfsPJTqp0bgHes1h0G7rlhD_tYVLPcp3bB8rXjB16rg>
    <xme:vkBAaZ5CoOdVNPSImGLGiehDvXAYi3sCtH6QlXkti1K3n__KvgiDuCt9M-2TVYVhK
    bOoRcfNrs-6NO8MEDNtVoisYmnehpyWjnGQ4ZRqCL1okpioG9w>
X-ME-Received: <xmr:vkBAaUQp3GQuZa4G6m_Fqs7NASk9Ry4LYiXEKLRDXK2UmQA-9ZTjki3orkKJaWzcnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefjeefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefkffggfgfuvfevfhfhjggtgfesthekredttddvjeenucfhrhhomhepuegvrhhnugcu
    ufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnugdrtghomheqnecuggftrfgrth
    htvghrnhepfeeggeefffekudduleefheelleehgfffhedujedvgfetvedvtdefieehfeel
    gfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsg
    gvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghpthhtohepuddtpdhmohguvgep
    shhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkhhoohhnghesghhmrghilhdrtg
    homhdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepmhhikh
    hlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggt
    khdrohhrghdprhgtphhtthhopegrthhhuhhlrdhkrhhishhhnhgrrdhkrhesphhrohhtoh
    hnmhgrihhlrdgtohhmpdhrtghpthhtohepjhdrnhgvuhhstghhrggvfhgvrhesghhmgidr
    nhgvthdprhgtphhtthhopegtrghrnhhilhesuggvsghirghnrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:vkBAaXwhg5qPoMSFxr2fjFWyNP3WxxYhQ73419jrK3qKUZ2yeX7Ssg>
    <xmx:vkBAacoS-5NRhIxVYWmGPTFL3D8ol9w16UKMZ8fl7XiWv23-lX1Ccw>
    <xmx:vkBAaa2MctWN15wgAlH3c4uX1-gQ9Gfl1BgMgTktPpzzX6UX9TGxLw>
    <xmx:vkBAacwVIAsywd5d6YrAgETJowG17h3I0KHd7Nw_L4SQyMrJOkmY-w>
    <xmx:v0BAaYs0WBymy6XKlOGtl7jdV99-_OSENo7ShJW2OJY5BD0iRI2jHBFg>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Dec 2025 12:09:17 -0500 (EST)
Message-ID: <2410c88d-380a-4aef-898e-857307a57959@bsbernd.com>
Date: Mon, 15 Dec 2025 18:09:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org
Cc: david@redhat.com, miklos@szeredi.hu, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US
In-Reply-To: <20251215030043.1431306-2-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7ph6zidzru6k8ytj419z8wdh3rbrprzg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F16AA4000B
X-HE-Tag: 1765818559-464626
X-HE-Meta: U2FsdGVkX1+w7v6wzsoCJcHa1UvngqUJRF3j5KhqCj+H2oeA7Bbgq1nZeCxHUMF2nANV5hjGWfwSGaDN/VP/k1Dve0Pz8GvUxWj3PD6v7BJ50dHqvQ6p30WLDlUiHpu5Wf9nbOhswhbX74/VPvBW7FAwgGaVwVTpIQJ3veULXxN1axYcoQC4GUysjCP7nRfR2nEXEDAp+yZHYjpzMAnUQsNtNh9PbUehTyR4upcd8ULaviu9gxqmieShLCItD5PcRV00th/HDt5udFNKEdPQsTREj7XC2r2NAwafKOWB/XUpVH2dWO/ZM2+UpX5o8shYw98pSS88Ep3VLEF4hFitXombf2I1oAeVxoXurgF7GXUdnewoiQgVSOFVwQfO4Cb9A9G0wwBTT87Dq6joWugRXpZMTTq6V2dHlqiyhKRyelXlHZzO1n6BF8ye7YmKdNfDvdh7rXiPLY81tEmvumlrXqZgO7yQK0tBS9HcHK3/3dQ95uzRroXvC058MIx2cNOpDBhWh6P9K8VLc1X6jEaoejDXwYz1ayES8CrO2ortKnJf2Nl5u9mjzTgzHG19OfpR98iVFlRJyw+oIlU16PHTlhj4AUcWvwQ/U7xWPU+zphnKcc/M9evi35vOQBDX7VdkegoGinxFkhtO6HRzl3beXoEiT5DBwniqsTLms4KSyNxwpBATi4AJqXnv+I1IKTVSAf1b5g5gB0HXUDLF6fpHH4adD/qwpzfX1eOOaSqbJtKcZJGWV1uB9P+EPSJKUNdGS6Pa9P24oj6rQCKeoDtmG3y61HC8vbPeUQhvgNH/EebEWxtDstvBS8H6qvBgFbzv039r+oZe1VRUJiTJNAHJ0jUIsN+CsIvFDEdWIcJdSHj46S7UHJVwUi/SNcnz3heZS6VoLY2PiYn1fsyZ9UD2P7Pl4DmCW5JPU5DRBL+C6i4m1Nd3vWl1t9yAmKIkQgdJWX1iFBstpiygAx9MAVo
 aMBc62bs
 oBOI4KsMYYZfD9Obcq8isMq5eaIT4gOSMjdLTJDBanTUaOEbN6YoMY0OoY4cCpKvizmYQvj+kmQHyyLv2rJAFAlRqvWthgXsDWWhX2pIQQ+nZyD43k2nA24kpAK5gwDcaW+bRek7lRhF7QLIAdU07F6+bs1SQRcYfZsf5F8xJ3wLaAbrQKbKZm9Uh37dFin1tL7byxizzVT9jIK2QxqZ32fF6Wo46XzPNUZ/ly8ZA7n1kJuf+mUUa/q+3VrvJzGGxe6lQVCvBMGEjTU+LTY2oWwrfBE4srVJsK6yI6LLzB2Lr+K7Da5aQFcDqqC5awpBWnsJBeqE6ffIyJ+iX8afoV3zbk930rv7pZvCWCIa2p36gn5ac4rBUhtn3WW/MIQaw6qLhLYxUMbHmFjC+TnZvWk+ENeOVtMjEEOiK1A7Jza67YQBXY8/Ru5/nnZWg3H60yMwOZqJzmEat6vBghpnUbbce5WNFE3QVPHHuuTVK7uy5M0AirrI0/RyPaqDPs8hgNX84uSempVVX+GAzasfRxqnAm2U339S643QQKZq1l93vV/PtxiQFLaI2lTErtvP5DAC35aSIhPzkvqBvEJPHLKoaoyx+t+8qWhsoO4sAwxef0c+XhJTBzE22hLel2mWVrl+k1WMlWYGYJWhBzX75zz1p06lBHhqqm3nI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/15/25 04:00, Joanne Koong wrote:
> Skip waiting on writeback for inodes that belong to mappings that do not
> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> mapping flag).
> 
> This restores fuse back to prior behavior where syncs are no-ops. This
> is needed because otherwise, if a system is running a faulty fuse
> server that does not reply to issued write requests, this will cause
> wait_sb_inodes() to wait forever.
> 
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>   fs/fs-writeback.c       |  3 ++-
>   fs/fuse/file.c          |  4 +++-
>   include/linux/pagemap.h | 11 +++++++++++
>   3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 6800886c4d10..ab2e279ed3c2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
>   		 * do not have the mapping lock. Skip it here, wb completion
>   		 * will remove it.
>   		 */
> -		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +		    mapping_no_data_integrity(mapping))
>   			continue;
>   
>   		spin_unlock_irq(&sb->s_inode_wblist_lock);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..3b2a171e652f 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, unsigned int flags)
>   
>   	inode->i_fop = &fuse_file_operations;
>   	inode->i_data.a_ops = &fuse_file_aops;
> -	if (fc->writeback_cache)
> +	if (fc->writeback_cache) {
>   		mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_data);
> +		mapping_set_no_data_integrity(&inode->i_data);
> +	}

For a future commit, maybe we could add a FUSE_INIT flag that allows privileged
fuse server to not set this? Maybe even in combination with an enforced request
timeout?

>   
>   	INIT_LIST_HEAD(&fi->write_files);
>   	INIT_LIST_HEAD(&fi->queued_writes);
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 31a848485ad9..ec442af3f886 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>   	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
>   	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
>   				   account usage to user cgroups */
> +	AS_NO_DATA_INTEGRITY = 11, /* no data integrity guarantees */
>   	/* Bits 16-25 are used for FOLIO_ORDER */
>   	AS_FOLIO_ORDER_BITS = 5,
>   	AS_FOLIO_ORDER_MIN = 16,
> @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on_reclaim(const struct addres
>   	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
>   }
>   
> +static inline void mapping_set_no_data_integrity(struct address_space *mapping)
> +{
> +	set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_data_integrity(const struct address_space *mapping)
> +{
> +	return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
>   static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)
>   {
>   	return mapping->gfp_mask;


Reviewed-by: Bernd Schubert <bschubert@ddn.com>

