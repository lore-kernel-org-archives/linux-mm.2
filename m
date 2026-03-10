Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DEAFD2D81
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843E46B00D2; Tue, 10 Mar 2026 09:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FAF86B00D3; Tue, 10 Mar 2026 09:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727556B00D4; Tue, 10 Mar 2026 09:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 630186B00D2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:45:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED914160197
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:45:24 +0000 (UTC)
X-FDA: 84530275368.02.3AC34B3
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by imf18.hostedemail.com (Postfix) with ESMTP id 492F71C0004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:45:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=BSv+5VTS;
	spf=pass (imf18.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773150323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqNoaL94Dj4pObM+6pGSr4RMsIJmELh6Cj7p3cxJGxE=;
	b=ClsrcMUT8mTp2fC8KY2LGfOtFGKZ0ywh4y6YdSlenHOd7DVJJJM4Uwn5SVMMCxRPicjLpG
	3m4NXold+GX/UtpVuvmMh575D4YzGf6fMOtju0/tBLNYwMzIyiW/X13zG3mu/GdsR+kxmE
	/R74r80uY2gxykelF0XeI2BfbiGmiZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773150323; a=rsa-sha256;
	cv=none;
	b=L3VoRQeEUq8JL1Yz9UgfN+63gJjMjXlqn7zhRXM5uA1PGfxRCb6+eOpY0NHWbloU7hXnt4
	ThfaWDjRyiNPmTvkJEALBDAKl0UJUAIjkkZCbAOxJPwtt1Sa2iZk+WEvwXrhFvolkwZq2y
	iwXmjwW3jQ/D5JgdQHUwVgJjPRP9MKE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=BSv+5VTS;
	spf=pass (imf18.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=tqNoaL94Dj4pObM+6pGSr4RMsIJmELh6Cj7p3cxJGxE=; b=BSv+5VTSyPyrhpKWnMZVCjZEvG
	yrk6LWxlGwnUUZjquKMol+ljVUIUp9jBraubgLqBi4cKz4hniKCf9rIQTsThme1FexxEN+zxKvsgC
	uvMYbDhkYi+shFX+PLCD/IMwmjSpYMDJbZGsateoQvss1ByMiB7n5CokueqpdePTp7697ajozqLcL
	QNNNvSzTIj5kMR2wUJSupi5THJtiu7VhPmFy8ePRrdnRpYFSOebiyO3IlTbeTGO/MmRM5PEIBBHLD
	zejwvm6ItsldfqTIXTc6O0Z/soDk0el6lSZ+MrXBoszSWB5pdQE71J71rNLjrXAAIRkB6hWfEOV6d
	5s2EICAGfy5rFvZnPzPqZQFNMJmMF1OtxV9pY8V9U1rZXYRb0+cWjl6X1xLcFCZOiZcoHLob301cc
	kRokX7oWqU/2ExVyAy+qxf6eKje0uvqaOqv9hMGZ5ryaSKPC2aKAIJfnAVSBvJS/v1i4KIjPZc3rm
	OWRlN9QVYisM4o3VWUWhQE9QLOSHJzH7XsIe7kcAxjAHPZYtil03PpuGESYai0z/ycOzdMPXNnK8s
	RUYQ5R4xdnnK/uIBRJ5tLN+fwlf+9zGkqtXzZ7Db2ibQTV2JC6OBFoQ9ds8aqQ/KGsNN9Qx1u7AAn
	wqTFHtO0j/nTwkXDvMBIt3or3MQXIgQCujiNGxQ00=;
From: Christian Schoenebeck <linux_oss@crudebyte.com>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com,
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr,
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org,
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org,
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
 Philipp Hahn <phahn-oss@avm.de>, Philipp Hahn <phahn-oss@avm.de>
Cc: Eric Van Hensbergen <ericvh@kernel.org>,
 Latchesar Ionkov <lucho@ionkov.net>,
 Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 06/61] 9p: Prefer IS_ERR_OR_NULL over manual NULL check
Date: Tue, 10 Mar 2026 14:45:07 +0100
Message-ID: <2401874.ElGaqSPkdT@weasel>
In-Reply-To: <20260310-b4-is_err_or_null-v1-6-bd63b656022d@avm.de>
References:
 <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-6-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 492F71C0004
X-Stat-Signature: yetajadrgfjhaao5ekcrznminhuzbdkr
X-Rspam-User: 
X-HE-Tag: 1773150323-824807
X-HE-Meta: U2FsdGVkX189UOBsfGncc2Wovz+crkov4sOCCJvq4JpAwiTyoJftwgxMtTQrq1JIA1gdgOPKrI55KBim9GLT7jfXUNR0kyXGzYMCxlAZqD82zNzFXobLQu/QP27Pxx7HmsPusG5BeV1wCb5W6SX/Jq5FYuEGXo+QVG8uTbxqrKqClDcb3XE6whyDJvB6ir+8+b4ErWqBiJRmKbMHG+dg6zdFt+JsR4CX5YlM2Um4gn+nh21481f5yW8z6BrnQq6Ug79sslZ2aCC7jsBI5+5gNPkwiSY2dXlpfLKauC9Cy9CJFqIHpYfD5nlM/NQEU+FShe+2cDgB0M3+YZTJoL8H+l6+YwsB+0I4wgTuY3Lq7YHT5ScppyZOsjjgEgr5pxqiddHR2eaecWfr0MOasI+lqhmFWKTdezqXa4PFMJdkPcU2q41th3SoI1SezY6vZ4g5QC5x2nrAOh7m/6yeGx98veazd/PNYSUnJnA9Cmq/jYhllqe6e9AofFnGd8t4JdsUcIxXOC+ZgIyntEZ/kV16QKH8fD5LhXABYGqaZc3Ekfu/U1KpCAbi+ad8K0Dj76/Ut0UBYNSd/Xb+VAJRncTRBiNa3bqZPZ4Y+0bnmC3Vlc+ZbeWzoSRpSupsB52FK8aMYDrVCgrLfCoF90a9EJnl7kx+HEHDzWdcHMqC2ou8Ajis4HNlHCPafhZN42Xo1A8q9NjtNNvgndHEr8RbB6Msf2RV7HkVXey9RPvoBoTTEZvl4QUBLibzYaghF6FFroOBrNMsbczIC4EY5rzXy+4mROdZruGjKXiB6EnKyoHu9HemR+04fyMorVAjnOp7XvGEnUr+qo94hSLh/6Bya2PrvttGPe0zpqFU4SYXT0P1LLbj2BxqcqiVCPDuiLeb8dJqvOQiafZcfqLv0EuluMN3mcCI+NDJrngVQqMHMLEmm0G/+Q+RH8nzNNrVPUYzFTVwdKQri0wefuIPGHSHk90
 NL2G81vs
 ff6aVesCmYYba9gDgrvzz249CS5QNcrYWTRn23+fPSmcEjYx9RObMY2lwJ/uByrp3/oh7cCzUGW9CNqobKJOfiX4UIL4N4SKZ3u6GiYbuxBtd3oVd7prcPMpsPnpiN1dISiv1NtgPre725ASsbU1KWWQKzqoxV9orwjJSGhrfP9F59fKSkLLVdX6XIlAgM3WqMaidnxyJ6iQl7orglAzxIwGnxfojXhNK+hL5nkqG36RagA20hWZMYPvsKvTFdHGpbVdYqZaxpPm+H6vja12NCxZmeayq/4a49vgmdCzYIkW0rZNV+/X8EPnG77QJe5Lq6Fddv0C4VHQlcHS6er3K8qqQ0bUpOyNgRxtLp2neR/fdLTjIVIyeHVHuj3Er0Wgd2PGQOHfVwCaqcxdIULH+ZEBrPWjn6Wioffo2OAByXM9QrvZURTCs3b/LW8m50R6OQ61ElIRiU3AKvONVhQui45irpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tuesday, 10 March 2026 12:48:32 CET Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Eric Van Hensbergen <ericvh@kernel.org>
> To: Latchesar Ionkov <lucho@ionkov.net>
> To: Dominique Martinet <asmadeus@codewreck.org>
> To: Christian Schoenebeck <linux_oss@crudebyte.com>
> Cc: v9fs@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  fs/9p/fid.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

"fs/9p" in the subject on this one, please, not just "9p".

Except of that:

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

> diff --git a/fs/9p/fid.h b/fs/9p/fid.h
> index
> 0d6138bee2a3d1ab565ab2d210c0a3f3bf97e4e3..3bb7ef4380e972a2d9ab67eb4aab6cc5b
> fe2eea7 100644 --- a/fs/9p/fid.h
> +++ b/fs/9p/fid.h
> @@ -27,7 +27,7 @@ static inline struct p9_fid *v9fs_fid_clone(struct dentry
> *dentry) struct p9_fid *fid, *nfid;
> 
>  	fid = v9fs_fid_lookup(dentry);
> -	if (!fid || IS_ERR(fid))
> +	if (IS_ERR_OR_NULL(fid))
>  		return fid;
> 
>  	nfid = clone_fid(fid);



