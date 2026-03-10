Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F123FD2D71
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3305D6B00E7; Tue, 10 Mar 2026 08:54:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311D46B00E8; Tue, 10 Mar 2026 08:54:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DED6B00E9; Tue, 10 Mar 2026 08:54:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 133BC6B00E7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:54:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBFE01BCF5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:54:10 +0000 (UTC)
X-FDA: 84530146260.22.61202EB
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 059AA40005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:54:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p5hvZwqG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773147249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
	b=2tnrmL6cjU6uerT3ZoAvqhu5LqglPMjpzrTDWd29IX3TdYy8Zb+M3NpFffWHKGGDJvOp1b
	MiN0x7W4p9wrJDuKzmQhqNjHO4ZalieOaYtrNEOhOJYYj0VCUNBPRDCoM4OKlw6LgYyvnH
	JE5//ELrcDbRebtaxEpjMPTyWans2tE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p5hvZwqG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773147249; a=rsa-sha256;
	cv=none;
	b=KCDlZ3POkZjmudqtGoyBEFAmmGsB7ccXoLiZ4wofvSdnMFb+bUwjrKPLNIjqf1AbUH5U8Z
	gfHaxDjIPrme/pTVUN3DAQiyhGdAKN3pU5oXa/k7C7tdcdNR5y/rAAbryGcFF/MddbsJcx
	KE3VZC8rMV+heQi6rwZ3B62tsMukCUk=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aeab6ff148so1375ad.1
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773147248; x=1773752048; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
        b=p5hvZwqGoeVjycydNW3dP1A5W3ayJn/P13PtpEyRjCNw18D1wylwVY5DIfjJUB2t7y
         Rpr/mPl4ZY+o5o9b/q3IOqXJN5sfobIWEsYmu/0R2XkW2Z1Ld5Hie87fVEp8xN/LxTuc
         uSO0Y/7EOPjigR2X0aad8/PM6N3MOLfCiYWVQ4y69iNonm4cM5UWgR7au2JQgpwsF8LV
         6jcM487YH7TFAivT64Zm1GcfdLtCwCOXmbRrbO8feaXOK0RIO7HhGdgpEYrZamfEBXuz
         mNziIRDtL/KBCTYIkr1gXO36QULbQzwIhzH8rrnLFQZcJGLuV5E6TAm8NBaUOlm7HeDG
         xUjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773147248; x=1773752048;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mm6hm+LHoMGo5Ew01sq1dP9YSITnoqIDxYFDqmtgvh0=;
        b=xKSthSuyJWxQe9nyErYEYBfxlUJXhW7yt3pd27VVTnDXg/Vp9julJwW9SjptE8oxFJ
         dv0wemJ4avK5T5sZYMStdtWi3H4xAXTqztiu1a+XRuV8Mm5BrOfhdoPutqknMRVTbWDa
         HdvBawxe70GCgmBojlvoclfDr+uag+3w27W07IE2ZrDNEIiGuYC13yxmtakM3bMRk6hl
         XMQW3Sn77uCVkEDY6fIjS9wyhcfNyNS/aNwZk+SVl+G3GpeGLRWnhepmIVQ5uqq4ztbj
         BpsasMMREdfafoX9X+ApoznNcQzm9Y3SzO6LdaTvkj6z8cJk2FU0p9r3sXgG7wPQtkbs
         CIvg==
X-Forwarded-Encrypted: i=1; AJvYcCUfvyK5Eb2IO0sQJ/sYHwB+lL+rOGObM/cASzKiWgHTDQwm9qLE1tas6Si+bmpgUoKUOI2h+VndPA==@kvack.org
X-Gm-Message-State: AOJu0YyrhH3ZvUWVoH5BLGMPWGv4tHE0LT++9V7890eKHdLMd5D73a+h
	JLiNxKV2otFTCigVAF//NFQ1jvqkLLpSfnsyKe8u9cSfD0EoeVybYKEiEaWmXEUYkw==
X-Gm-Gg: ATEYQzywewbhRGK/arHH0RL3sasA2y++Dm/77GWfdk2BAJToJzucBqO5igMfeIItpqs
	wdf30aCmcvfu7Jk0WHDBsRMF3H/36HKrMX1nSywB42xjtyXujU5WVxRvLKcvimVPmNJHPbt32rp
	Ilh5HXAF0YsqPtEZ7OxPEjKxYQc956+QJ+O7rJtKnVHX9DG7vXkEbEgZJwOXvUIrJciktpNxKnx
	ykReTt3+eM/iigfB5T0SyJbJTtxN1OHMbcYlVYuUS6qWXe04S1mgMY99WbJP4VDBYYDB1w1R7oX
	Vj70VdaKN61h6w3fGMuEte5ui76F0RNQHO6Co5qjtBq+dqFeqYbfihpaHceveKHiwsRodv3ULqu
	7yPdPwe9qLh4dqFWhsXyUoIrVuKdYdOrSpMe2HsSALA8bHCfns6fOlLPVAuud+jaP/QgMntCqx0
	/gbcAilNCuNFmpprj74VXuCdCo5wm387GgtwU7pOsv45Ow6feqqQf3w8toOA==
X-Received: by 2002:a17:902:ebd2:b0:2ae:45bb:bc4e with SMTP id d9443c01a7336-2aea30ebe48mr3008685ad.24.1773147247400;
        Tue, 10 Mar 2026 05:54:07 -0700 (PDT)
Received: from google.com (10.129.124.34.bc.googleusercontent.com. [34.124.129.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0cb73dsm12445679a12.11.2026.03.10.05.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 05:54:06 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:53:54 +0000
From: Pranjal Shrivastava <praan@google.com>
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
	linux-sound@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	ntfs3@lists.linux.dev, samba-technical@lists.samba.org,
	sched-ext@lists.linux.dev, target-devel@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>
Subject: Re: [PATCH 46/61] vfio: Prefer IS_ERR_OR_NULL over manual NULL check
Message-ID: <abAUYvx6VEdSmInm@google.com>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310-b4-is_err_or_null-v1-46-bd63b656022d@avm.de>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 059AA40005
X-Stat-Signature: fse7ydbx1miupf1yrz1iegphxxah8u79
X-Rspam-User: 
X-HE-Tag: 1773147248-53545
X-HE-Meta: U2FsdGVkX19AXzWQ2p+yVJrEDtukPSU3jcQCaofUEgWYUrIaw2Zi7e11XqpCjvSzMAKDP9AQ5JTUBUSxn5cgRT7aYDvbOEqyDb08KE1r3CUXhvX2a6AaV1mV8vaWouyKdYlXZHY4fUnbwx2OhASk3qIgqJ3qgaEHgdk2CY/hdyS5UZMvKTYMgc8VepIlnzEh5H66twNz0zcJ+RUUmkslbKbPo6oDuYWA4+wJ7TP/O5+0SzIWKFtq3K+B1u+xsLiMs/lzrmX4fk/zYiEAJ84P8gKgXlgPJRmARofuwoP14qaJYLKNQ02PE0e/wAG8t66Q4DzWhbm0q4+acQ3hLtVSONEj6/szmpc1taiAxDM7Yzo3bDXgdwSXsVl5eEv3ElYCUKKQi59HYzTajfysxHt7oVFGTw0MWkMX9CRG/CuncohnYQ1/oJEHLYKp6LT71YpXMkkgKH+g79PoRGfqAOFi0VGetgmYckAZXpw9nABKRvBqPjSBGR9AMChGSciqMn0kMM13jKN2+IkRqpk8GXDLLeoDcc6Y2TCOCGCyHC0qJF4qwItki0cQO36txjuJCIAvf70xbNpkmS/Qy1BR8ubAVxSJ6P68RK4CiMQivd6XsLcNDOvZWWPQThXohGC/lOd+Ybiq/kn0xQWrtgEYp/1aufgRMXOiDXxq6/hzwxE+lm4m9pLieJNO/n6B2+z0zo32XuOWiaID0tCi9MvTV9DMcsq+KIs2Pku7n7rhx5fvyjoV6gdGoilpS3kJfrdFlggGhCjEuukWvkw+n/wjAH0GmWnu1/7y/kKdq1IwMFuuRis6GQZbdk0uyDYKo9PK7tzGhxGNaDHunpciue5gd6gt5CypGT7uT8N6bjAbQv6UTDYmCNYZSJdX5lqjT+nWCXVIBlsMqsRzuEHoKeGsiXfx9a2MiJbXyauMdFbXN+eRK0gAI9LzI29tHT1mEq8p+zADTIDnuurnhZ+K9qAJPU2
 x91Q73wB
 hfXCwzw2wS+b7PVbNG+wiLV00FQPDGMG4rIiRDfxDGovgquZJfyu0xohQB3kVxtjQqUcY+14kmyMEerferVch+/sUvS9fEKszsNKSEf4RT91vw2TcNa9JbkWZrsH3TMvWOiozQRL6lEApwp+0zSnOZuve/YpZag5G4lKE8zm3XLd69BB5atE6CobLbqGXeEvs8klwzt+hf7HVUvUAsDQuZnEk3AbdMHx5iXZlU5GVvYHAf+EkfDDwIsncx53pEtPM9eHXaQxPGuK4Xqt3F/vKQwjEOsMMRvyJR/NL23onMJFfZDmjW7C2E+vVZ/FqFVVvZEJM62KznoCxhKnV8kFTMp8b9PgV3nQBYTvST1xn7HjK0cDhs1aPrH5AFTCV69UfsIflW8Zo/yFfnlLGbL6hsrrx10mEHtgxxf5VPryAHt2FyHYSbqFLgSwSWQgSQgVtqPkySdoKH39dFWBiLUfR2lb13U0f3pXb7407XGZtZ+xY9XxjgLhEaTLxdfsk0DgDq96DZkzgPOaBC24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 12:49:12PM +0100, Philipp Hahn wrote:
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>

The cleanup alone looks fine, but I'm not sure if the maintainers would
be happy about the tree-wide spam, since each patch might go through a
different tree. I'd wait for Alex's preference/ack on that.

Thanks,
Praan

