Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E23D5606A338
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nhdmM365
Received: by kanga.kvack.org (Postfix)
	id 0B0466B05D8; Mon, 23 Nov 2026 09:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088A96B05D9; Mon, 23 Nov 2026 09:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFFC6B05DA; Mon, 23 Nov 2026 09:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D11146B05D8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:20:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CE9A1A08B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:20:30 +0000 (UTC)
X-FDA: 85466594220.10.6B32247
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9E0C0C000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:20:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nhdmM365;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443628;
	b=ajh5ExOcru6XI5gezUkJSKL6pjL1xEhG3cb5FFn73rS9P1oQUJbg29PzbSVKs6q7gPydBs
	2i+hXIlVk2/sv/hHkIffnPuN9u5V9Dq8AO4jW+8/LfPt8BvEw80F7vtiu5HmEWAZu18ndN
	rykCzgrHIf7jWTM2rgI63V+oc183plM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAzQq1DJpSBO+XxRF6Vp7LxmR7KfxskrkHM0HAoL/tk=;
	b=X94ZD7kGl4LR0U2L2ps1P4xsI11j/ko+vabDp9eWdBpuWv1eu1PiAvNH63z7PTUuy7Xyuk
	PCxeg0pPuqIJCWt3HLcJiS/kj+ybizpt1X57lNYiRsMiJafxqWUJmO/xupqDO8gaMc9L2Q
	TcvbtBzYWh3Mr98rmfjfGGTj23S+Nwo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nhdmM365;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-385d8a00598so4609108eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443627; x=1796048427; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IAzQq1DJpSBO+XxRF6Vp7LxmR7KfxskrkHM0HAoL/tk=;
        b=nhdmM365yKgedQl/9MbPFhM4BtdZTIXMu7Zj2pbxmYAGBNYhPIZxYjlYK+V9JuALyO
         cnSdOHVHlQ2kLGljuy+PkVO6gySICGfPssnuLkzf4sAcMJS2hOdI7wx9s5utl237wrxn
         CxB2fuiRx7A0t6RJgOmP8yVPHlpvL/bjnu2/l/pVMtGIEOfOWcyPDETWUg/n2yK1BkYM
         bd58hcKubtUoBGsvy0kkuGZh1TmBr7Iwovb97jWj2fitqomFyb9hb1uFEK0N86oJyyqT
         J2dboeFZV0Ub0eVms6bpoIGs6revAll558hslaEjpvzVWSFRSLwlXqGwtkChoy3wATRb
         YFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443627; x=1796048427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IAzQq1DJpSBO+XxRF6Vp7LxmR7KfxskrkHM0HAoL/tk=;
        b=JrIpatm9a2PWafO9BC5bxkB3/xJrbDxro/yNeZTg/8bvM90hH71OJISr0YE8A/YZw2
         lplL/wK/Oyv6P2VqYVw3snYxtukG1kk4fqpKM8ptIm2NZFx/hwWADy/VZo6e0CtiR+vt
         q6FVAv2Dsw5mkCPdlOJIyPyPvrSTT/8T5Ef2eXkLkYCW3DyKZcbrlc34Yfy0vfzETqKH
         fOWV/KXL49pIBL1C+kgutWRzYV3uGn5gEaE45yG8EZ+4cSBy56wEdKzNjrYUtb0UQHjH
         F9W2cf9O3RvDf8w3MBKein1f2TCuMo1sYOseK8eNVFwveMmqm9QDZfqlCO67bW2Xsy0X
         2VqQ==
X-Gm-Message-State: APuU4Z/EPYcgh8+3DfqbmNh9IORwLgTCm+brW8gqNUgxSrBY5HkfcBVY
	5tNwRkAFetUtNTQB/tPs05GyFjDeLTHXuKKHIhwCIGCJ2IRByTzERA3iF0z7D7DP
X-Gm-Gg: AZFdTZeBl9EG59o9Y/4gW79mDk2s4LFVOBi24B/wYLz3z+NIfzal4txtvO0BLXkwD7s
	6sjp0MRHI6ibLN0nTvihg+xExzTxGREb/RajWCbWzrbDeAo0bAOKHB9Xl037kvgtWAobIMZ15Yw
	Fwn4dWpC9os4AlYZMN0zalOiMyAJbDqE3zv13F9pcwYaNuYaZLm+eCJh3B78aIl52Omrn0TfgoE
	aBgLILwKvOSy9VgnlANvLoKL/EaYK8Pc1FiXYozXDRDa/E7GThtRIslapXMb0xexf/zEpp65lVn
	6lOZshLWHWG1sQRotZICQYwET3VfCxWMUCwyTnr0tB3crfXPuf1iIj5YCNwydGNJ5DMdHMwA5AA
	f83936VzqBCI9DZjhbp5l5PMUj5+ubt1Ef8T7LnpdX3RRxH9f4CSfRwtBxl2y7CeqGnJyHJmVDU
	3WyRQDygPiOr6N8XWP1eBTndwRDMQ3F9gLURIO8Ik8dwAFZr0OLDOQsdKaw121l/cJdlQdZBijG
	2JBFvais618xM2cf0SrI4aDCuWXZWO6IcrrS1Xbp3q39gyLk3OeBtAeCqrpXgmIFDUWsEisXnGP
	JeJTjmFuSrMu29JCuCvFDe8XdeSKjoXZGqFCvS818gEZ00/vlvGkCFk+ILD4lZD43Tqa
X-Received: by 2002:a05:7300:6881:b0:386:9ffb:33b4 with SMTP id 5a478bee46e88-3869ffb51abmr7378341eec.33.1795443627312;
        Mon, 23 Nov 2026 06:20:27 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-386b9bdafb5sm3091208eec.9.2026.11.23.06.20.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:20:27 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 19/19] mm/swap: redistribute queue readers after membership changes
Date: Mon, 23 Nov 2026 22:20:14 +0800
Message-ID: <fc69968abaa133c855fe71ee4394251e67b5d905.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdobwxqjuthrngrttkxnj1xbz1qstnpc
X-Rspam-User:
X-Rspamd-Queue-Id: 9E0C0C000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795443628-646978
X-HE-Meta: U2FsdGVkX1/jF3eElpzNgz1pcyoPtoh1cK7tpipI4M9UCASyrq/V0UMwnjkrByHvV/BMoOSGVku+MaMUVQVo3bMzTvHHv27Pn3tdBxEi3W6mF/y4exTeMkoGgPhMgLZBkpWbzJKSWsd8WXcKtgQCgGXOyJ/B6giKbdkXG7zkhhMtw2KZMIdSlQCRh8VxFEleMXTXutr6MknMoWqgG1Cz2XF1lU+i/vCD/OiotFBVazo3CnVkksXHWE0xf4XLLsXdLjQhCkPIT8rwXXkPTN6+un9qG4iFGp3/6PJwCJpPpZNYDLneNARMR2eHljJQB+EhvcU/8TaFCKCYdfWbS3ih5UUDcA1p+YAt7pDjt4l8JFcqM8ZOAv6joemZ95A3nbRl/Vsp6QQW3ABNTXkYPiNllhVGOYYw9OrfUKw3o0RaV4VlbT+oPynAtNy6UWlC9+J391nRxdj4Ncf4fi5hJpoO/4ohnUaT5dawpWG+Z/oMzt+o63YrLqBkKBagMpkv2rsI40mKflW5EXGgtpcTjTZNwjEYRBXSE4e0E+FoV4JvxEvGN+tBCSL6MgOXRlgwuwC7uQuvWAawk5RQmXVfHdhIv4r+tsQrZmw2yhVvjtTToGqsIutsUfOXrUh8y1e++58rpKPKAn9uT6z4v3+tGOtiNuXuOWd/rAyV243k04JznxToO9LGIDHy+fxjLRWyGYaJr/A2KAYuG0pngAwoF6Miz3TSJLX1PQbn8FuQcLgLpABNBEuZzDNiOz4mDSJ+Ot4CiYFKIrdt4+xAjpEF9BKwQmDFt9OqwkAnstFHzasyFQeYwSzEZgH0Px0Ux77WDHNSVRKLeBiZ/nCPmZbWEBEk92EfOq0rpNUfVCyU/x3ZScfv+bk44OpyakRRdnymh8bnwDCOChZgAaj4/+6Vj+ID0qR5/ipCIDM8NgSceKxtSBG0+sy3o3wc9/L2qvji5F6VbE3z3bJhhHG4aXIYZ4z
 rkfnp2Lz
 1cI0CKJpavnQRLHiZxPYToOG/MaF60OtpvQo3bGxp/rWko00o4RWYo8nglhjWpMlsFqpAuoIIfDfj1pGoFq3ihlxg4aRJgT6z305fM3CX+kX3i0v+zFiEaO1eiVLcjld+oXZqljtD/GeZGPzj6+56hx6i2VUzqFHbQoii06Yz91FgxtcXB28zzfHNZGBti9YUHwbieVVZV4QY0GP9FZHQu0gJ8wJv0B4JCsCcBsHDJQDJ9GndYFJF+9iNG3n3BmmO0Qd38o2gqDMa1iVh3kWNj+mDUuv8L4Tu4kUxqghbib7AG3GN+TT4+iRzBe8gLBlZzRetjsdqyn8Eh7R5dkMdqhr2wwuaFTkce2IWh3DBnoCEuHyIBMQzyXbVVIc0f03QJSCORU8KWurz8qBZtjR+9fFkuL6XELIgUOTtyp6vEgCQnd67wLoo2sukcqAyvEETo9qO/K5U/GnBQq1d8Fsc3sAdu3whuIW47wQSVIarp3wdcC5GpcCAMeGmCiXAA9ZOB2P8JHxuL6wbJ3ZixPwLsd5gkFgFAKBIGFNu11vZjlWecl75T+UZJJEC7EXK2X0PVwW/v2Ra1HWnbrb5s7Z/XE7Lyn1e69oTfNZfmUkajMBJzx0SPKPWRBJugG60LzhABj13NgEP3hjWFxZpAt746JSzaDwrbaHG6L5+TJP4uhy4BLfCF6vsNUqSx65WW6lyNlF9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding a device to an existing priority ring reuses the per-CPU reader
storage. A ring that previously contained one device can therefore keep
every CPU at the old common starting offset after peers are added.
Deleting devices or rings can likewise leave offsets and quotas that
describe the previous membership.

Reset the valid per-CPU ring offsets and quotas after peer insertion and
every nonempty deletion. Run the initialization helper under the topology
writer, which excludes allocation walks, without allocating new reader
storage or adding selector hot-path work.

Use cpu-id modulo placement for a fresh best-effort rotation across all
valid rings. This does not move existing slots or guarantee strict balance
for every active CPU subset. Mask and availability transitions do not
trigger the topology reset.

Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 91de93043500..f6a6df8c2595 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -495,6 +495,7 @@ static int swap_queue_add(struct swap_info_struct *si,
 	spin_unlock(&swap_queue_update_lock);
 	memalloc_noreclaim_restore(noreclaim_flag);
 	kfree(old_ring);
+	swap_queue_reset_readers();
 	return 0;
 
 failed:
@@ -567,6 +568,8 @@ static void swap_queue_del(struct swap_info_struct *si)
 			swap_queue_install_readers(NULL, 0);
 	}
 	spin_unlock(&swap_queue_update_lock);
+	if (swap_queue_len)
+		swap_queue_reset_readers();
 
 	kfree(old_ring);
 	kfree(old_queue);

