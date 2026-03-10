Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23F3FFD2D92
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 13:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E786B0005; Tue, 10 Mar 2026 09:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C486B00D1; Tue, 10 Mar 2026 09:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688CD6B00D4; Tue, 10 Mar 2026 09:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 559336B0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:47:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E755E14014B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:47:17 +0000 (UTC)
X-FDA: 84530280114.09.DE96A72
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
	by imf29.hostedemail.com (Postfix) with ESMTP id 60FBD120018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:47:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=dTpIUmFy;
	spf=pass (imf29.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773150436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVv/PSZT5NGeZjfHxwg8OpWgNHlsgZDJ/5CMzeiUbdo=;
	b=V8/EoSZR3/zHRQuTanm0QTCusPF8tV3Y1HbZ2WZ5l9h6Q/NQBbhpof+58SROldPDSX828E
	DYFff5qnM7a6sdHlEV5sVu3WRVy2qc4tlDR2NolcJJqkuhNNGDGAD46bPY5R2GR4JvRDVR
	zcpyogYQAoxle2vIJDxBDRvSB9de13M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773150436; a=rsa-sha256;
	cv=none;
	b=h6QzvX1chBGsO2bb8ER4IKrkxDJhMA31XBi8A6gf6GZTDs7HSF1j0+//oPlqUdvMLIrqUn
	GLpc7qo1K0NqLWNZWlAWc0ZOfxSY+WxECLYnjm5j+blVFrouZnwnfcpdxkQK58kozOMw72
	dLJKSnK3sCf73DMx6SqsMaI/6AXQs34=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=crudebyte.com header.s=kylie header.b=dTpIUmFy;
	spf=pass (imf29.hostedemail.com: domain of linux_oss@crudebyte.com designates 5.189.157.229 as permitted sender) smtp.mailfrom=linux_oss@crudebyte.com;
	dmarc=pass (policy=quarantine) header.from=crudebyte.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=aVv/PSZT5NGeZjfHxwg8OpWgNHlsgZDJ/5CMzeiUbdo=; b=dTpIUmFyfV+bP6Hy0ueZpN32tu
	piiOrm2xYxIB724JO1nPYEvLrwNppM7ldi2VsLNiB9a22ZPzaNJQ0YaGHJwVuraOF2yk5SpAHZold
	s8t7GSMCpZMXoj2MN+HCYF9oJcPgVF+TLl3oulmGF4t7YrhkwJ3IfsTmzXldUh96w/myd3pDSVX1g
	/e8bzPXWMBYBNoEloTPI5IYSewDyrYj60Js0etFfclp4hEgkn7HaHPBIdN5mmqp8OC3Z4JyMZY1In
	us3k02cy2EDC8Yr2DD9TZj2Bfv2JCzi8o1CBU/q/X+4deOd5/tymAnt0Bem3HGOfb0TZNQXc+sRV/
	1upKIM10UX7QbQ98BeJxn1cHAUt80a13aLlrns2kgX3r4ZD43IvQ3qOgYizweNeHFZvB+bpwBSNFD
	hlDW1qIdKmIN+wC7qSL6cU7m+YgH+eIF1AeR8pLLvTFBNqmI6qti9D+O96RBcbYAwE/olpfjlTGn5
	mdLSL9FFfI7mx4Sepl5WAdeD1XVerb2KTcAMA8AXYimzng7DssEnPDbX6u+t3yAcQjc1BrWIujZyx
	Gao2D20IgKGUx784nxNUpYJ2ZiCkXzoDKyugnEIdTC+VrOwC2OEJanP1Uq3/BrGj0qOrmxYFeI51c
	48zjYWWU3v40e6itkF189TkI8Acs6/RLaheNlL7MM=;
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
 Dominique Martinet <asmadeus@codewreck.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>
Subject:
 Re: [PATCH 24/61] net/9p: Prefer IS_ERR_OR_NULL over manual NULL check
Date: Tue, 10 Mar 2026 14:47:03 +0100
Message-ID: <1948861.tdWV9SEqCh@weasel>
In-Reply-To: <20260310-b4-is_err_or_null-v1-24-bd63b656022d@avm.de>
References:
 <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-24-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 60FBD120018
X-Stat-Signature: t5d8gt9rcghphob545m3735ya93s8xj9
X-HE-Tag: 1773150436-186505
X-HE-Meta: U2FsdGVkX1+CY1uCHZhjVn6vqHe5fmWtIJQHUzi53JKrUqZDwUR2pcPsYCZuhU/G4RGq0U35R0nPS6OZUzzsIUbCVq9m1zqFvwsPGqmU7PIW1XHg96ntGq051qcMCrdIFDQifKyTymOViBUkyah8h41bN15aPYT15xyQlzTQccaSA0u+skWtwD+S/cyGWoAyhOO19ljCvvGY67gbvfxbFItLeMfWtpizREo5mUMoiBbQKLmZ4iHY7YrOIwobl7n2l34MfqZrsrrmaGnbOqpHWVDeCo0Q9iARBI/g31ggqN2FroHeR9/7tAN6hjJBwi4X3u/mXx/GopDdCzFky1H7CnAGqr61/VRM1jLE9v2eQwLJoRUCmW1FdCS4lcAPp8WtTQipY1dOe//ny4s+uLzH8WFS5dTWeaVptXgLR456gdgRDyKPF3sOE8sf737dfVhQc+4ARCk2jphccN/KUe7/wtqqiD8CFSmPQMDiboq1tkw/5reY4rUjYN3lJ+vKPCNfj1CD70Sh6zulQRsSjhVsWmnKl/xSA0hKHGn+iyHmWUV2sRJgg+rtSP3/A4h3/GSlhxz2/rl5/uAkLOyJlXy92hNsTSEh4QHrSeBjoLastZ/G3+MgXVjTU805NloLYm6aIaiOfqphqMv1UQN2ITXLfEnS5/jTM3SCiZPz6sHsV+0dHZU4IvMr8Q6msxgHJs1J79W1Hhd5sJskeGu1RmKnvh5mKRdc+pXLbq4gO7wYpgGk9pWYWXwX1M8gDPhydboxWDOAbbASCRqNhduT/iHPoKcXcvx+p4Ybg+Z3pCKegLB5gfBQWoIi+6bqMAMCRpgqHSQ6VS3OKTJEIVsgP8fHKbHV+5605XprN5JfxJh2NEImv1CpKcA9gAgMOi/jzvpayo+PEe9mgUMVLyqCIla3bPoVW7QSQAISTO5m061GKyvew/ETnuvpJnYoR9IjFz7wrn65aXbEcYqNbCVNWqw
 r76hGRV7
 K63D+y3dEfJc47aJKsMFFW+dUpX86JoreU2lzRNidkCniWtm5GVbJYutA0r9eDu950R7/9aPsNReHu85r5L0Eh0oz+FYO1j4AfsLoB3Eoq4limD+fB/NrOsdrBWEMklbJC9T5P1WYkwiYkF5CDc8y9KjGEBSXgt263umrd4qhUcGR01ao4ZekoxbuNqxiHYc0l7AkSbJbEDQiNwD5v2AIBO5sEn3gXyBvAsLcvKlWavezUPfmcuD2q9yGIngZAZRZe4CiYDfzlYTE0MQPpjxWa8dwWhfG9tKGHUjUAuiiBSHIPYX/cqQNuvpQMsewC4XrZU0ETvByjoL2nSFJIZuevdSFiRAiMHohwGwlYYN9LRIqioMm3cc2pzwTO/O5iC7Q6JJArnjNuBuXCtZ58qOCLIkBOWsIx/wZXk+C2H0eDvSrqodRl04MDqacJpQEbRgSGQVVz5JvU13PUgvWEMEhaklrcin7rWTV5mvsjJ9cDQZ6yi6WsMEn1niRRDnR5Q3Ib+dKKd9PsFE9y2/eq0nzkLMyh+BYXkD17hLIkRPBJHgDhB7DZQ3zk0/xXydbU4S8wuv1/cvbT85jeRkdJxGDndNYl90jJwEDoo1rlqOIGwZai5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tuesday, 10 March 2026 12:48:50 CET Philipp Hahn wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
> 
> Change generated with coccinelle.
> 
> To: Eric Van Hensbergen <ericvh@kernel.org>
> To: Latchesar Ionkov <lucho@ionkov.net>
> To: Dominique Martinet <asmadeus@codewreck.org>
> To: Christian Schoenebeck <linux_oss@crudebyte.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Eric Dumazet <edumazet@google.com>
> To: Jakub Kicinski <kuba@kernel.org>
> To: Paolo Abeni <pabeni@redhat.com>
> To: Simon Horman <horms@kernel.org>
> Cc: v9fs@lists.linux.dev
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  include/net/9p/client.h | 2 +-
>  net/9p/trans_rdma.c     | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
 
> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
> index
> 838a94218b593f3fb19e6827c472753380193461..4bde6bd716f323c819745e64c7aac0dea
> 7beb72f 100644 --- a/include/net/9p/client.h
> +++ b/include/net/9p/client.h
> @@ -364,7 +364,7 @@ static inline struct p9_fid *p9_fid_get(struct p9_fid
> *fid)
> 
>  static inline int p9_fid_put(struct p9_fid *fid)
>  {
> -	if (!fid || IS_ERR(fid))
> +	if (IS_ERR_OR_NULL(fid))
>  		return 0;
> 
>  	if (tracepoint_enabled(9p_fid_ref))
> diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
> index
> aa5bd74d333f3b5e6fd1e4344d26bc0201ff7f7f..60461344b536bcb6e94112aace75a88b6
> a99ad86 100644 --- a/net/9p/trans_rdma.c
> +++ b/net/9p/trans_rdma.c
> @@ -252,16 +252,16 @@ static void rdma_destroy_trans(struct p9_trans_rdma
> *rdma) if (!rdma)
>  		return;
> 
> -	if (rdma->qp && !IS_ERR(rdma->qp))
> +	if (!IS_ERR_OR_NULL(rdma->qp))
>  		ib_destroy_qp(rdma->qp);
> 
> -	if (rdma->pd && !IS_ERR(rdma->pd))
> +	if (!IS_ERR_OR_NULL(rdma->pd))
>  		ib_dealloc_pd(rdma->pd);
> 
> -	if (rdma->cq && !IS_ERR(rdma->cq))
> +	if (!IS_ERR_OR_NULL(rdma->cq))
>  		ib_free_cq(rdma->cq);
> 
> -	if (rdma->cm_id && !IS_ERR(rdma->cm_id))
> +	if (!IS_ERR_OR_NULL(rdma->cm_id))
>  		rdma_destroy_id(rdma->cm_id);
> 
>  	kfree(rdma);



