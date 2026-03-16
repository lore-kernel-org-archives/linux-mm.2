Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F73F53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 22:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA126B03AF; Mon, 16 Mar 2026 18:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B2A6B03B0; Mon, 16 Mar 2026 18:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F466B03B1; Mon, 16 Mar 2026 18:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7A46B03AF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:11:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 839671C18C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:10:59 +0000 (UTC)
X-FDA: 84553322238.06.C5F073A
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71881140017
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:10:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=eyO5nsRG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g uCypQj";
	spf=pass (imf09.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773699057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZj8f0JboyjKt94J8KB7OLIiCOoml43GOZ4w8rDpLPA=;
	b=ynufRWpqXEefvYkMSYEQT/dRB3YEpTRRO8brol8Rd25P31sLtOBaHKnE8GonLqFtEjAD0e
	uWxUOUofyh4uqTeakdlsCN2r2do+SH4XP5nsIMR1LNemIUuFRqaTVUtZx1pAJ2oi80TOqw
	E5vI6H3Y2vIRlUztiUnJpXtucj3quWA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=eyO5nsRG;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g uCypQj";
	spf=pass (imf09.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.138 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773699057; a=rsa-sha256;
	cv=none;
	b=fZHZmh5DwLj9IbAjzrx+7z/DEMBsB5DzXyXEXF689C0BwAghOaGBYYZ+gBOJILa2EO3z8w
	8LC4I/oDKfy4Uu2tXLhw8m65Y51G3Qr1eXKhaevwUCiPqe9tyTdRKwoRFcdmmND9BkM6+E
	In+FXtXRgNeP6Lqrtzd7SXybU6p1D1o=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 96E81138028E;
	Mon, 16 Mar 2026 18:10:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 16 Mar 2026 18:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773699056;
	 x=1773706256; bh=pZj8f0JboyjKt94J8KB7OLIiCOoml43GOZ4w8rDpLPA=; b=
	eyO5nsRGgscBaSPTlSrjx8D8qsmxFZTD+YBT90C8JLtkSU+JG9otBsGP68/aDjfq
	Ip8/CY7pDqj8uLfl6tk9PaoCLmHFx9BmC+OLDsgQIKz5wruWwvglBIFTzX8Bgo1G
	D7tyDhfcq/yYvbxAZYbPlVlov+W1BUQwVVZx34myYfSzzczy+o0TvO2AJR+dEy1d
	h9Fy4zA0IHy3AyAu2lJw7cTPeRVsoH7Q9DZJUhPGVmEq8IZ5byXvr46eUf3RwYLV
	Pd21rN+O2sxo21UD0KoApMpHYwnhY5vI1CKlHqs6nb1Q0ON5mjBcz18/WvPyI4M2
	g7ed/wORmv3aHNEvlM9NEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773699056; x=
	1773706256; bh=pZj8f0JboyjKt94J8KB7OLIiCOoml43GOZ4w8rDpLPA=; b=g
	uCypQjfxr+Zi7JxdTC/p3wGQ4VV0q/Wv3rf4QuOSSvRwPZ4hwWoKXSQwRlJppx/A
	eTD/kX8ytMBkqeeAHXi8QojGoDJPwhemKEl1A5BQyy+VTfQ0kjCklEhRU0D9TNU6
	QzoouUhJdY7Fi24kVLMS4vkfF5Xif+sxcGuZ+ZH9bmNOAZhg/6jHFnuxjrIUYo4Y
	sJAjmQ/c58h+MsTVokuL8c2t4xBbVGwnTgXIvKplEwnaY81NNzKXbPGa+zPU58N/
	vwQ/zZfUYT5zYdyXfBWrfC5sZSkqzhpuD1WACxXIM/TD7Jh2N1ZXy8qS+O1DtSBY
	h24uS6YuZ9c79L+rKNYRA==
X-ME-Sender: <xms:73-4aYdtUUIQC679P0YPl8k6UZ10Tz8-qTD319yDZEtXusdBhZuXRA>
    <xme:73-4aTUav9FvduIIOmc0jldmINr5W_MhUsWQFGzP1fBm1dpf8ggOxSMvCMHniLmCu
    LbRPk360ujIo39hLA6fsP95YlnCLki5WcrUsiuRyEwh6NcxWlxF>
X-ME-Received: <xmr:73-4aSY56rJyFtQwMFw-H9dfM29zbbMWxWkWrpi3kYaZ1kbqDyXdf5bHU5U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvleelheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhfogggtgfesthejre
    dtredtvdenucfhrhhomheptehlvgigucghihhllhhirghmshhonhcuoegrlhgvgiesshhh
    rgiisghothdrohhrgheqnecuggftrfgrthhtvghrnhepvdekfeejkedvudfhudfhteekud
    fgudeiteetvdeukedvheetvdekgfdugeevueeunecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsg
    gprhgtphhtthhopeehhedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepphhhrghh
    nhdqohhsshesrghvmhdruggvpdhrtghpthhtoheprghmugdqghhfgieslhhishhtshdrfh
    hrvggvuggvshhkthhophdrohhrghdprhgtphhtthhopegrphhprghrmhhorheslhhishht
    shdruhgsuhhnthhurdgtohhmpdhrtghpthhtohepsghpfhesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopegtohgttghisehinhhrihgrrdhfrhdprhgtphhtthhopegumh
    dquggvvhgvlheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopegurhhiqdgu
    vghvvghlsehlihhsthhsrdhfrhgvvgguvghskhhtohhprdhorhhgpdhrtghpthhtohepgh
    hfshdvsehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:73-4aQltNdDVIdEqvCmz7Mlt0qW50NA4CHgJQUMNlacMN4MGiVKHfA>
    <xmx:73-4acHdFw15OLpR73_B1AdIXJMG-pYssiD_C0T2dj2N-8ux7fVHFg>
    <xmx:73-4aU6P6J2BtdvPwSPzfrUNjz9-qYacHOOWBucSAMlha23fXDTcIg>
    <xmx:73-4aaO5YEqAXlnOLRO88GZx1RbxPW8QtXAeqZQNaqmxlgOL7PgFkQ>
    <xmx:8H-4abIvs_QYur641c9BpnDuFQ6ssCC-7-o-rPLEHWyRxStBDxJEr6SL>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Mar 2026 18:10:52 -0400 (EDT)
Date: Mon, 16 Mar 2026 16:10:50 -0600
From: Alex Williamson <alex@shazbot.org>
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org,
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
 alex@shazbot.org
Subject: Re: [PATCH 46/61] vfio: Prefer IS_ERR_OR_NULL over manual NULL
 check
Message-ID: <20260316161050.01c82973@shazbot.org>
In-Reply-To: <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	<20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 71881140017
X-Stat-Signature: gna1ed8faguo9sc3s49zcus56tkhdxda
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773699057-748176
X-HE-Meta: U2FsdGVkX1+aM0RImT2ymGTwRJ/ql5ckIMs8l9L3D32KNV+PHI6JmePCJ0d9ArMJNaT62c856hfN9pVeW3ElBh44ycZF6hMpHq8AjlbAwdaF+HcyXt0iaFw0jtcUTlzsPUCkutLwqzLGw3nZOL2KUNmH5goypaRgT8CFkCsCjxgNgQOOU5W0BffRuQ7KGMwAHMYf4IZf1s8sHyDjnNcS49pXXb8Po7nnvPElqV5+ViqvPL4mScO+jFHCW1EWWuX6DsasBqkpDKcLCDZ+YZb9ZbdGjOdoX7bj2OzcnwyRRW3OTvIRvzKgkQLL1zXjuCFq8VoMjMplck5FeP000w1etgpTbNI/V116lQ2NN9y7FQGc34V4eC+D66q2GmwWB34/OtkLTEZ0Ei8KseZVUhDJy8D0yDRvUY5OSgQ0x+YnXLXeZ0ko1fdQOAlCJqJ3oJl9w5B89q6EKYggScy2OmsA2Z11xC7zTJh4uT3YaGPMfWeym2bMFQduQ9zYXVCuqaRUF2wTZA0fsgRGPFmRvXEVwH7ThjUQrHpEEHCgK9Ta653TWf8PfXsEK6zGwTOjj2Sx8AOwEEkKnlmrjG+reVbjg1nY2xGTwgSILaNI/t1BVcvlvPTtzLYrpzIIC8ZzpKCuw2GfjNmwkkfcvlrgJUEYlJfiI4sChATmHomu3lneSXOuITiT6Ak9uSoITrJQvViaRRSlEdUYU50/DYiyWb71x83MqKxyF9A7UeTd0y10UwoklyyCSjqce0Hxlp9CdpJ4Q+CP3SBBiX6Zvt6cfAoRChQV2hXyDegqm3Z/95kcpojVoy0EoaVuwMGH4/AOucomlu0Zp3VYmlyx14vvk8bMpLTxBU7bkV+m3zCNnKMLLyhI3ZoRpAM/746BHsNPuES6L02TEF3CAxvHdpRRR+YYdWlQ3cERmpU4hK7+yo/mbdB3tDYLCybrCHyg2y/ufgO8XbT6xNx11im0rFO+LkS
 yt6vid+7
 Rmp7mX/kMq354J4XSkfehE83fVA0LlEBQuGeoj0d+hR8epiNv7yf9nt/3UPuSZieIWDplR4pxeWosWcsOe0u/UVTHrZ73cipcY+tRwdCUUFd7JP6ZLBLhJMTrSQrzrOWGpAGQpo/1VoQ0Q/TBtY3wmHJ3V2d7AIYrbs38x7eoTiFiThGmDVHY+zuR6kYAmDRQwn94je2W1DdtUKTWWbiy6uHpRlO/oI31VYqw7i7SUIlz8pn9Yy4lbM4TCpmMdTpmRI+V/JJaZjZagVJraRG8qgHD9RcYiW/q7SAgLON/NEkZOqStGKJStPnUgxZWsL+B6YB0ZTkvhnsBMMeJcVDY+mhBQaEJPMmqxqLWvzJgs5CNHSXvLVS3+xGWITKDdILDTFNuK5273jyfx2eBi3+1Bn24e+jPtp1qbvjGXvnfT+/28giZLvs9UPJcdXpT0eCfH8iiC9icpz06/72suQwfOo+6iT4+uajkcpD52kiqTx41bUG9P0Hx5JOo+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 12:49:12 +0100
Philipp Hahn <phahn-oss@avm.de> wrote:

> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Alex Williamson <alex@shazbot.org>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/vfio/vfio_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 742477546b15d4dbaf9ebcfb2e67627db71521e0..d71922dfde5885967398deddec3e9e04b05adfec 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -923,7 +923,7 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
>  
>  	/* Handle the VFIO_DEVICE_FEATURE_SET */
>  	filp = device->mig_ops->migration_set_state(device, mig.device_state);
> -	if (IS_ERR(filp) || !filp)
> +	if (IS_ERR_OR_NULL(filp))
>  		goto out_copy;
>  
>  	return vfio_ioct_mig_return_fd(filp, arg, &mig);
> 

As others have expressed in general, this doesn't seem to be cleaner
and tends to mask that we consider IS_ERR() and NULL as separate cases
in the goto.  This code looks like it could use some refactoring, and
likely that refactoring should handle the IS_ERR() and NULL cases
separately, but conflating them here is not an improvement.  Thanks,

Alex

