Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F60606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=DMZj6f9q
Received: by kanga.kvack.org (Postfix)
	id 35D216B0711; Wed, 21 Oct 2026 10:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E9F6B0712; Wed, 21 Oct 2026 10:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224C76B0713; Wed, 21 Oct 2026 10:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE0F46B0711
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:02:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 811651C3D1E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:02:44 +0000 (UTC)
X-FDA: 85346799048.04.48FF98F
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3E5F1C0018
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:02:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DMZj6f9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792591362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+sA7ukfPfjD0qmbK6dckJqDn7Cek/Mg6lo2porw7DA=;
	b=kV72piUtAtxnsrPPn2oDK/ADN+Sr8BSTBhXDTQXPtAU5upeT2QRSKwJlPK23dnpHo4B0xA
	RM9sQXT5onsLPgFUZsMzB1XCQLddXqe35vP1xmZAOfb8OHD0bicKOWmLWL36hR3WpHDhkc
	B82VyRVaUHFrPW0LvXZ/bKhE/J/jME4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DMZj6f9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792591362;
	b=p2dUaQAgt6HxFYIvlTYysDmytqgZOkd4AlLa4nR0GXzHim1urxMR+6JJUwYtmWP1q02Xop
	e3l5S2U8ASBag+Tnc/ZLvCnsT1Y12E0AuYrGoWLwa8T/1NZqRp8sJSLnv0YyMHTp+PPvVt
	xNbmrDICkcQOF9oA8M5LyrgRN7SZLDs=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a018dc1f98so6514615e9.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792591361; x=1793196161; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i+sA7ukfPfjD0qmbK6dckJqDn7Cek/Mg6lo2porw7DA=;
        b=DMZj6f9qHTGI5huZ6JmCU2mR+xxIA4iTaQRQsI5XKc4sS+lIGWIqzk9u+OqOZIfaXr
         hKhEZn6RmY9uEYV0Tiagl43oenh1tPk0rdwHBIeFqmgSDSCFxWAV60vT3OVk02wd2rM+
         WnXl4YmjLnFafRQ9FY7mSbK2sssJP+rKm5iW/fCeclhMsJRo3XE6vf1FTp/dDyAaiNJZ
         n/r+JEJqbjYH22sUMNkkIFrNtb1pBtAIey1tXDV5Wlr51prMB41P9qfoLwvxlOTUPR62
         8uv0viH9fxPgVcOpqs2x9Q3h5YqQ3lUNk5yZGNLkrf734oN3uTv0fHh4dTzahnWdClQl
         4b4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792591361; x=1793196161;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i+sA7ukfPfjD0qmbK6dckJqDn7Cek/Mg6lo2porw7DA=;
        b=v1Khl9wc1MZyTvtA+VLul5nsnSPWqD5HF87OsNxIga9GlAML5YuASwuAHIboCWk2/X
         Qwr0sUL19lxz13NVBTo9PUHTK3izATD6sFNB/F6Ftpi8Oyg15FvjfloxK0g62XFrk9gk
         XOs4BjKQOtI5nnCJt1BmE0o3BARi1DWtCxoOdEYKOWYYwkI5vlaqkf+SQwGDE3pbm0mH
         6Y5Vy2AhrFR9l2gGiednH5JVjtu66hkEIwmZHLgmoeAd56VLZzihfMdglc0/Ry2ZREFl
         31pQsUt0HFRp5PUJXUxVdeuLzy1Lo/4FJ2mlG8Qkd7pNGJk6J4fBOPqD/e46IRwiVGBo
         oMzg==
X-Gm-Message-State: AFq9FYIKbg4Hc40imxv9ZSVhLT7GHpNqX0mPuTexwyTV0cd5CA3KY8o+
	3xywCKf+DscROckQDwjU0VegYtDuocy5jLefa6DFVla4mjnGYeYETl3X
X-Gm-Gg: AYBFou01lrzCGsFnvIX55eO4uqEFELaQZV+udUDrjrgNc6z5BEsAHpO859QTICB0WyK
	zZB5HZOPKKqcvK7Qy9mkmXnc35Gqf0wfCPCEoDv/RgW/3NqR1ifMp/6GrGVazyamMPfaoKbPTyB
	cWdjj9XkKjvViL/flrdDP8DEhkVdVoqHjacLeJTQ+16bPgkWeZWlfc7hOjIDsjQVeHhh+RkRtwZ
	/PMhbVbionqDEXyBvCJNK6trIrYINFNv0X/baD8IFdY+zej9Ii/Hpk5PRuVgR3DrEMCb9xP3O6B
	6F3IC5Vsc6D4iMzmtCCMQtYMzo+z77upnlnfL9cDoT67lx51Nq7ITGVwwL5cbETrDOCCUBenju7
	1vk9YTE0UhvfRn+cH1DvHizXl/WcONk6k21utflusyrtm6awi8izsRD/x4LLzm3V5N2EJECF//w
	7sqTSvHQ8LhwI18pTTLGevVZHn18UZ824IjOfqexZXoHUH3fLo6cKkpjXrxPQWzC23zrKaum0dx
	GN1WC9octyoNlrvGtR7rWTgmTmAzL86AeH9UXVTOR9iuDBhUcn+L2mftSJzAXmLk20/pD8sjvOW
	Q+SlKalqQCDI5wdGLb7wW/eGSF9xbpCV1h8kioM5+hENk0zvJYyjWUtX1YXN
X-Received: by 2002:a05:600c:3507:b0:4a1:96cd:2f73 with SMTP id 5b1f17b1804b1-4a1fd8cd9e8mr46111525e9.1.1792591360723;
        Wed, 21 Oct 2026 07:02:40 -0700 (PDT)
Received: from C422HJQPQG-Fractile ([150.251.170.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fc10de99sm50954045e9.1.2026.10.21.07.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 07:02:40 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:02:37 +0100
From: "Vishal Moola (Fractile)" <vishal.moola@gmail.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, dave@stgolabs.net,
	roman.gushchin@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atjF_eRnuzH1IZ2_@C422HJQPQG-Fractile>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Queue-Id: A3E5F1C0018
X-Stat-Signature: xzkyfjuuftrmffn1bbigdjn58gw4rdr4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792591362-530284
X-HE-Meta: U2FsdGVkX19nNWpURfTQyZiYenHpqsZ4hxkfDUcP7UxHPNNo44qyOzXt5WT8Sb/qDUc1Flb+Z5AH4BpQkrLw2bZRTwosFtR8lgRjUHQLk1uYFZ3ublZAWL8efS6JILDjWKlxkP0y9VlH3ngT0AJ+Hxt7gzDD9OEXt40hQ/OuB5b7io14E3gMgPnm+xY959grWq8jE+TTyCBIpRD2W8V2X12dIPUFkXVznl56k/VUdlr8xqLVciyVfdL2PjAR+LjhqG6RgSiVT4Y/Q/ymUF1I9PRBDcXY1IU4bEKAGYz6kqEYWb6fJH6G9RYpvx3Mcm8upCbMYwKYRk1jyM+Uq0fP3jFlUVnHR8lKRGIwrZJJlTDsaE+Ilc3RQQwbPDBDvh7CC+iBY107srqVyL0ev9NBpr6oPsxzTWsYOAvYiUP2wYcZbgOxWsli0HsVEnV/9oZNjOsgNNkPA9y4rsXmPbhGuiw07fqCD6NKV1z0L6X0mvrBzzzafN6jx/SZ+zA2iSgyrC6Edarh1uZGjMYqZrczmi5gAvkT5FZrePb3MFPnP1RFacUYHeWOp6/AISW/fLt4TQVjkVU5DbtNMlKGnmSrO7MGHBTTCoVemu+vTVRX+E7h7qO/YagW5BIu2J7twThl9Y2u8yHekvJV1RXjKYGBosPuUEvvclvKRjOR+exq2S1llvGriiQEk+uf6iTrOyDJd98KmvxAsBajoHH1IRZmbbiKFVO79ng1NlCb6p0X+Kqn9GGYRWpPg6Gp+zBAPhUO/k8l3rx1XOM7b1N0/dIGtAZjOA0c40rYRDv8GeAoQakbF4lq/MuUJ5Amfkih7vY55fqPEwrL4wAbV1Dq19zopEBSUUtHEeQOQmGJlK0hxHg/frPqg4IcvJHIpHXsKgVqn+KW4iAMVuv9xjwbaenbdUhHp08LqWoRquGYRuRNKG0qDzwmy6xI6ZbucO+e2I1zPuSztZ/UM5jgmtSour8
 n9CejySz
 985KfaboR8F0dKJ6McIWxHd2kx5MajxhGwXSpSQWGORk/db49tmCWVDQxv5pL52n7w1kFwwVo+K9Om6JGUYsFeAmyJWxNIm5C3HlFtONpp1scl6B8ErQ+YSZtcTV0y10PdlX3zGg9OLtY4j2hxEbxKKH19Mfbw5pqWo/+g3HxojfVQrVW+/VYs8RHUoT4IutNBIqkheo4WfbkPhCD93abAcCHrKKdR7m9t+PLVBymlr8ez3aMsljMo33ZNG3LQhfG6Dd43ywrZ9Y1y3A3IYXO9II9lAm/BLzYg8BPaB6hy+j1NEPnM3vTbUcw/gYkqDaXCcxKONVLCDwhtnloIYpSVL738T8MyfrKai6TiCoCoXN+FZHQ0/eBqzXgn3E6ENRkWDAiTanqlj9vMMTQSVF5Rf4ZMK+ln9KQ62FY8xO4IlgymG0l926s4ZUIAo4HeaqbZnk7nCd4AOukkZFkrBaS0+izpt5QXBL/r3zwylJWJdyOvH/VlV2l5Ccq4OInYK9E5th8bcbAD1HOTur1YRngUJDtB7UZs38cGKoWCanIPJbb5wRj7ZJDs1X/9hYhR/NTD3Rtljno8O/dalggqry18uoU1l/Y3HYkphLPV2NxBQCd9Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
> 
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
> 
> Scan every zone, as memory.reclaim does.
> 
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Makes sense.

Acked-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>

