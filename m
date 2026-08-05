Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DA22C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FDC86B0088; Wed,  5 Aug 2026 10:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D69D6B008A; Wed,  5 Aug 2026 10:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE02D6B0092; Wed,  5 Aug 2026 10:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B824C6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:11:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 201D0404CD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:11:59 +0000 (UTC)
X-FDA: 85067404758.03.4CE0F2A
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 47E8112000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:11:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bybCYlH3;
	spf=pass (imf29.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYzPnD7BiNKqZ5IgmbP05MNUjhzCdP6nAUYQEGSSwl4=;
	b=A1cr6CpOHboK8kK44cEdTYFWQC/9aZzS+HB2rGot812lAJVF/HR8x4V6aM2TQpxgb0TZX8
	dxfZnZ8uh7Kbc/m+WhmX0cAW5DtVgPMShbEQCgmEgjLxjWi6R3RmW/d550igokSGIhGTJG
	qul5mmWMQOHoV8geYqgS2h4jSSuPipI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939117;
	b=FpVBc4b9SihjA40euV008oYu2D7wTkO2CjsT2ma+gtmgY5ut22X7f7f3HIuCh4TIVisd4O
	ET9KNMnzBhbvI8dGCVoQ1yKtyPje8xDhDfqtKqcukwq15IRDKHizbBVWecNCfE1x5Bz7mY
	/yWygJ81Xq8PIoO2f0sW0hJGVFJTtbw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bybCYlH3;
	spf=pass (imf29.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso484783b3a.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785939116; x=1786543916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BYzPnD7BiNKqZ5IgmbP05MNUjhzCdP6nAUYQEGSSwl4=;
        b=bybCYlH305hHmLMJ/5BASwOM9OVV1fls7OrojLPbbXd2iijWFPpVRXZXNnB270kXCb
         6S+B+budCidfkXXDOkpgvSUEaloIcK/SP03rKJDcR0belS7t5BSArGh+tyFrsTdzpcAN
         LxkLd7coI1aZ6fjEYkIpXSmEzTyIg4hAh5e1SLFAM6I8EplrUm2Yz4IcOcPIxxqE+CUW
         vkMnq5QUsn6iL6BHgZF+gd87wPduce3TVJWiYX8fMZiieUpFE+4APoDQV8x19+Z1EfVN
         rewgwhAj5vJUo9WCtDFInjmHayGLvWNcGMc1ghknfloH4gj31cX7h4ggjrF05Yn0vf7s
         xz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939116; x=1786543916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BYzPnD7BiNKqZ5IgmbP05MNUjhzCdP6nAUYQEGSSwl4=;
        b=NLnOnVj94/0T3GVfVypygzV2yeF2R2mOe/FRJFgsdDNVbBmt7FCTYnRPrpn8Mmgmsl
         ppbIbIygOrrMQ2eEB0j+G4RKwYA4KatElLiDzGx1y0v591fVQE9g9a6/AusfWmwI7GaS
         EUKq6yWqA37bWBByTnwqCAeYBMOl4kfpzQMeDV+FFdxuhVFuq6XiGzrM/ZN5BEMCi2dx
         gbpYg7Ta9mLhliP7/pg19AsdaU4FOuoifwkQgzrjA1BbEWh98Pf5UdA6IKuP+VH4HR70
         gWltpTRiALlIvAixqB/A68a8kn0p6F6uVjTyeg1A/35NiD7xWXiV6eLN/y+MmSq0D25a
         px7Q==
X-Forwarded-Encrypted: i=1; AHgh+RroUqfQJ0tXxs9rIvDyhGzxISXsMDEcnSZIXBUrWoEnygOaf4li5u7D+c5XX5kjnBhsbuF4TUqErQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+6itrIGSP5K1Zn7joUaZsPYfHW5Wbq2UVgfBav5wuRTgtE/0F
	HVKDduYY1ngTEnOJOxbu+ZoDAaAuAlLA0hOOOeQ0C505dldjzhHxCG9x
X-Gm-Gg: AR+sD11W1+ZbYktxkdlfthKiQoMgJgcUUYQLyQYFNipYL3VxqKPh6/u3kWDKC5fjkZl
	P4gaFJfam8in3g2mynXfT7DPzmqzTEyn4rcksAbHpSpexVI/JCW6sC7bvheZ4uum6fakA05RnBg
	Za8ZGAX1CfZzqBihayomsiAqguNxabhWHu3PaAFkLzMUI8q2/5g0dc/WwkFavd6CE3I/w0gvXIQ
	p2Dc6JCg+ayFbas4dLxuXH333N/K4LpNXl7tniUY9CUDQ1u5LKqMjLaRJlf+cdYTXOcZHxku8u6
	H822jTEyJb5UujcJRgP/GCQXy0DdBMoEPwDFpa0xqtIICkTyGaj/H3YOh5FNgHAmT07GjOjtrw4
	pMzTONe3N7kghA5j21Rg1a5+bzEQxNJLBUeoOHRvmbJsYEInmO6nTWefGKkALMAnszJlFjOLBwv
	sr4OiF4lXFUq1T9QrslvG+apJ5z6/D3XoZp92fvgI3zW7PCTDgtgJM4GjfpKHyt8E9zjznhRzHq
	PZoYdx6v0163lRvvQfIgmNU/or0egumXr4wRQngCkkjX39ugQ==
X-Received: by 2002:a05:6a00:c86:b0:845:e440:d0ca with SMTP id d2e1a72fcca58-84f2dfc8b86mr6689864b3a.8.1785939116040;
        Wed, 05 Aug 2026 07:11:56 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f2e50846esm913940b3a.46.2026.08.05.07.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:11:55 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/swap: fix stale comment on swap_info_struct::cluster_info
Date: Wed,  5 Aug 2026 23:11:45 +0900
Message-ID: <20260805141146.127776-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260805141146.127776-1-youngjun.park@lge.com>
References: <20260805141146.127776-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47E8112000D
X-Rspam-User: 
X-Stat-Signature: 3ohngnzb11a8qo64tb3crkpi84xowyks
X-HE-Tag: 1785939117-59577
X-HE-Meta: U2FsdGVkX1+X8R+fWsd3m7BcID8iqpk50SZaQaztracOub4h6/HgkOfMp06k3H1Cn16bMjLHJeBAEeoj6nLYyNE7C3EAzKsz3mdyiUQArVj+uWGgGluS3sIyrbAcqkOxg7wxfF+nYFwHZKUdai7i8oEBh9YOIaSdcpxhWngoa9kOcJURjzwyUffqbi/+JMEsVv8IQelfsaamQwwOEFKvYGVfMETDyxkB951jP9871OBeLBJ1NAiSgi+T9RzoQAY+AgjD0Nur3fKnintsEClFF9WGYRtZP1RNDVjEEmvayC480RejWl49HGLWiuar+tpdSfOT3Y95zE/YExO/nVrg6Dnn4JHtLi2TYHTKmzuen+bESL3eC89abiw1xD7f7bxKNzTeD6KRCSkxYpqGu+kktenEWCab6OmbTBD1RByOubnmjA4ySTN8Bg3Pz3Y1FC70HTtrMxWsb4KEeJ4hOInHfAPV5aNq1NJKDlvDQBAkzUydVuqV+9FDLwKNOxrELpIFv43jjgpa+vLGSr6BcfIJJmQLtQ/tleuZxT6rJa+gITIZ2JOzh4YDv4jczJWCPyP5QlIqJOiduovb82bnazQ0tB9DTItdl22eqs097M+qtL0PKH7+9P0RQQ2OXW7vzveVhq1KrowM8dncgsq2bmTQp3DDwSJLPoS3mnCvX3276qaOec3gqx6YyiNDBax56UfxvKfDR07TES6Uf93e55fCOdSseg/nurlheUX5x517AJtpug2n+hfwpDnkhf0nsHI3IH4Kv7zv8LpAY4Puno7Q7i7qpPVQjr7CC7m2XPZ3h/6RD/1NBrJiGUmePmN4f65P8JzvJsU4GiQhQeuvxrcFeLWL1CkoKAeN1UCLOq7RKy1l+3hW174WNMMwC1aKl5zEdX/1RSs9Og3vgQQ1j9Zcr6bAFOFKL044FEojVQl2Nih1fZfsxX8I35FC1lA2lyE44oXPTCcP0TDFarVh+4D
 RUkwn4g2
 zw5HSk9JRrV4oDSbK4DtgCQETRVRPuVYd5nTmyag3ISWCMrHl/CgKRSNsTDWPP8i9GQP7BSA2mtu/K5MA4EEUE8GJ1gTbaLnigRiqtceDTpIMK/BUbHkmEPswqMHWmzzxaItVFlem+UQkNip/b8XjzI+ydFZnG+00BCYBr3j2JcuN/aXF1UROquHIgnGiCvFFCbP+GoQYMTPLz3ruKOUTQLmVFDDz15vr66cXRIu2Fevr0Vw4RZhxu9ylnbz+JKixEJDn45zk+eLmRMWo0Ws9uNuT0F/RHP+dQ7PSDKcHeDRdlnTiJhH7hGJi2JfwiJMkQgZqny28wAo1CFSQp6GJhVFHvb/bTt4ULCAqg3t2FE3Whh9dJ2rxNWUHHSBOmB54it2I7ArOH4AJmjrMs76yUwmnQG37vr+B+7/SehdOkidB/iPgpZjnDZs0merKBFG1TG8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_swap_clusters_info() allocates cluster_info for every swap area,
not only for SSDs.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
Acked-by: Kairui Song <kasong@tencent.com>
---
 include/linux/swap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 2cb1d29307c5..2b14e2e9673b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,7 +246,7 @@ struct swap_info_struct {
 	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
-	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
+	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
 	struct list_head nonfull_clusters[SWAP_NR_ORDERS];

base-commit: 0b53bff4fa05ff0d3ffbd3d3bb10fae69dfab498
-- 
2.48.1


