Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A436CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401FA6B0098; Mon,  5 Oct 2026 08:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6906B0099; Mon,  5 Oct 2026 08:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A26D6B009B; Mon,  5 Oct 2026 08:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07FB06B0098
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:21:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C91140241
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:08 +0000 (UTC)
X-FDA: 85288482216.13.67D878D
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf18.hostedemail.com (Postfix) with ESMTP id C757A1C0007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:21:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Mc/DJKPW";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.40 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791202866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CIJjn31Exx0UajaxWOy2nTiUgkoHCFckWpJVBld8pBw=;
	b=FNXzVjKbVM2qVK/37ETnInFLvXH97C+plhzT8+4LzVT2MLv9ytciOZxXUEIpFM0v0y1BSW
	nVwP5ESDspLdqqPn3rbBlXWKaoIEgIHr4FLGUGQd9f98Vnzd9NO1QPGqC54RvbLK3AREd0
	D+hNFWQ8SBwTUKvi0yVn8qCsoyQ/Y30=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Mc/DJKPW";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.228.40 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791202866;
	b=Rvwg7ertiueedL+6Xj+PQRRkI1NbdepfC9LeGxeJ9aAIeks1FRmTPfWRotHoceG3uw8ihX
	4/cwqlX21KleUIjTn3ublrrrpzwbFNbDtrnVLzRunHUJv6oV7hYTp8kxzVN0VTLAZi4EWf
	iXRltKb+3L3tfNlFSBCAUutPbdA/fGU=
Received: by mail-pz2-f40.google.com with SMTP id 41be03b00d2f7-cc74520b20bso346462a12.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 05:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1791202865; x=1791807665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CIJjn31Exx0UajaxWOy2nTiUgkoHCFckWpJVBld8pBw=;
        b=Mc/DJKPWCnVvHek84wBwcsK88TqOs8g+Z94KOiez/+zFlewhoayxabEGVfc/1SRQ9T
         YA10xsgtIYQkww0cldC3Gwber8MMk8Pa6KdxbQC94n+4bRMx5Qt2wqnQpT19b6bHqD0j
         PTenKQct+qOcVRkTC0gBtOfcEQ3wBx1LNGAGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791202865; x=1791807665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CIJjn31Exx0UajaxWOy2nTiUgkoHCFckWpJVBld8pBw=;
        b=QZPjnVaCUdW+vBrQkt5Yi4oIbCzOs/n5p4hmV+wR791Oooyw1XY+3guXXfrJkOtSkS
         /x4G6F2oa4qcU5FRgjGT6GgnXBxuIeiaOQ8zBYrlQLrSlfXpr1Y/LO5dJwwSfrJheFVt
         8CxgUokkhCaRtHXgsSvLjLaCXe9DslZPvCoReQ/lztfVZF5YNHtttbq9aydn1MqHyxdN
         1HrVWBrVYZ9Y0SzbRMqlQejbyRm2QB6zPXSkzKofzqmHODR9s8MXDEEe2vhS6DeoNPon
         M6TEJY3Dk6kG3469BK7ZhGsjoBfCvJt+sztEOwL5DAkYXasKG++0I+kznAOMfOUsTWeT
         yuiw==
X-Forwarded-Encrypted: i=1; AKwUvByWNLTRV44cXLuUsqr+IESYv+P/ehsTOMdeHHSZ9Igq0gL8Vds6au7Ei98rDkKs2/BI0N/HEejqbQ==@kvack.org
X-Gm-Message-State: AFq9FYLOSLTI0Hy5KtNwdz14zehdftwsK/D2rzK1D/NhFSIjCftTvYcq
	M2JGSv74iqoTLGbliXNrJCCpHl6+ja3lMmU9aW1jv0qMPpGCjNJyT2qFbnfrRvIVHA==
X-Gm-Gg: AYBFou0QnHSl0p3SDOIJkwEWj8KO9Izf/J0l+LGPkAq2HGnsJa0kzSy/u+dMR+yVjQ9
	3CMTeFWs/okKLRlpfqam3zmpZ0IrBpoLateaE9j6N1OKgjc11M2rv4kS7mr4dReqa2cI6x0wn20
	4gKRbPskHAY751rejkj5BeHdUpcpXeh/1VPyPmXBQPwJvTUupKcorYwcQSAATbjsCgBmkJJag6Q
	ybyNFtj1YMMXhJuPmz3LQ91vPMgVEepTH4uzA8/TcNgUwaocOUb0/mJ0kfq9BGWgyH1/c2UQ7cL
	LmKJyTvRl2VvUCcXp035wt0XprBD6ykpbVGZlx5HggpSHeBZTZ4vjXf4orhxfkl4V1se3Nd50jb
	SBjbbr/XeC5lymB4STvsz+qdZfmRtKlAt7a1Z59Ou4+0JsRCGlQozuYvjihlgF9XrHPhRd563si
	ZxR84DXd0k+jUAVS27pcGH/5EdBTIKa2nKYXwGuvG4gdd4ayGHzTSI7IdJmWgiQ/JQDqqxg8I6M
	zr/CkCD07ZGB4I5uYKq1FHNTf7HvVzyrHOPjiCheLsFr/Z5AFz0OO1aTmn3N9w=
X-Received: by 2002:a17:90a:e7c2:b0:3a4:7730:755e with SMTP id 98e67ed59e1d1-3a6ceb05570mr6709940a91.26.1791202865649;
        Mon, 05 Oct 2026 05:21:05 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9211:ddf0:3c6a:bf9e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7e4b00de6sm3342997a91.1.2026.10.05.05.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 05:21:01 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 02/10] zram: remove debugfs entry on init failure
Date: Mon,  5 Oct 2026 21:20:17 +0900
Message-ID: <20261005122036.718976-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <20261005122036.718976-1-senozhatsky@chromium.org>
References: <20261005122036.718976-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C757A1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 5dyhcs5aomfh8n4jjeory6zpa7wayy87
X-HE-Tag: 1791202866-359995
X-HE-Meta: U2FsdGVkX19dxxA/TUeetQlOev4lOAQpq315bhZZjjE2JhL4OPTHxIT2h0qiKfpMSGpdgcOkdko1uW+8g08O9xPO+WdswYB99qaqSKJ7I6lCbaquO8j2rP2tgUP2BBb29MWPvuAXXzjqKzRFZ/PC/aULsKv2g9Mguqg2DoYE974yncoRXc+nI78fJ0+JfvvqbakwmtZ4bee4QDKNYcqn3ngdPui08D1H5aqNZ/iZZ+fvm48HUXiXdFsAlCU0y8/2ukDxyoPwVJcXQiYqiu6nIckiG4C0MDHRvfbs2nyA+A/0VRW/9PtwgfPbkVKZOQFkXBrmxSTCEt6o/PJ0IULmqOc3DlN+Kdl2eHiq5LmoAKdZWY1wJjukRM4WGY5XYtMqPtf4kiCyOKakfkv2DxQnLfJ3q6yueqmSKjnq2uMcisLOxgGYU0Y65+hIy8iuuhokvskwBh4hk9iVu50Co10y8q6LLgdMqnKhcxscOEMTgkTyRqwwkDuPAjyDiYL9WW0DR9RlDOr1LXhYhcH3e+B0x9mVHpg3kE1EknqqPMdwCgvDh7kaPq+O3YJ1c1ZIlrmfJqRE+/SjdvGiOWu+h18S6/kNAF7reNncMW6T5GwzECs7h4Vjc5Avo6IxoLU/rWP2dnAMPrFz0JVCl168dAgy3TdZJGnqvm01RiyGfdDXTP7Q6bW8emkoWejFdgttuJlNHkMDXU/vx+9YCJ0N4lxiumT4tAmu/0+8k2xobb8+KIrgnl6V00+twzKL1poYcHmSh4GbO+ngyYUB+SGytxUUyUua8JrE4334giMG5MA6qn/fGUxFxWEG16nI+6E9YqYUx4gANj7iH+qtNH89pted5wwMxWdZuUc1VTlWpbEP7YLSVslK17A2dCLyxiSl/VCmPDC+gPApzx72Wl5SgCtN79xScyz/Cxo5mVqyOd6wQBlzRbzlloQTgUOVCsNm69MKFxSLH59XvAyTSXXQCS3
 uWH1JEuj
 5UAmxFrUQgCCT41t4JiaHz9XVyndh3MC/Q2ajmz2KrRdyqsNrdX+FKPXSYX3JVk1yYbctr/KYq/NU4yIWa1NTPlGJqXtt/ohliNB9jQV1rhFbLyKjZN2FKOBAPaDbSdfszkk2sG7JeUjl5vY69+r4YS8rnVQI2Bs2DGicRAOuTKI5ja/Y+1l6/PKaD2uAFtFGgkEPvKR8lU9d10a7GxifAlcrgoZQs9UJ0ALqUwtGjZ+KJxzj7xEE/ti10iHIdeKUCmlNlI/447DLf3b38obWTvVSrRR15H4D97+XRGp7mmO14mY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not leak the debugfs entry when zram_init() fails to register
the block device.

Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab064c84b092..593fa4ae47c4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3297,6 +3297,7 @@ static int __init zram_init(void)
 	if (zram_major <= 0) {
 		pr_err("Unable to get major number\n");
 		class_unregister(&zram_control_class);
+		zram_debugfs_destroy();
 		cpuhp_remove_multi_state(CPUHP_ZCOMP_PREPARE);
 		return -EBUSY;
 	}
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


