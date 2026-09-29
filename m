Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA188C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755C46B008A; Tue, 29 Sep 2026 10:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707116B008C; Tue, 29 Sep 2026 10:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C766B0092; Tue, 29 Sep 2026 10:17:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 410786B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:17:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCFC5A6DE4
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:17:49 +0000 (UTC)
X-FDA: 85267003458.14.BBAFAB3
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id EF8B440004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:17:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ngK0fnmK;
	spf=pass (imf04.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790691467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Yh0Dtvko0nZONYoMl+zPVKAif82Q3nxAXjZ3IYlXSQ=;
	b=Vw4t/Ld7hRdTaBTr29B+oAZ+IEngchWVPw7H9o33fgi8SrDhHL/6Ua5dwPALut9f1EamAd
	Y47F6e/lPfPDkAE5WVzsl/7VkqGpmgUfMrf++tNFnaTx4ZwXu59kOEc8hgl+0KDwtE0HkJ
	q4GJOIOd2ZI9xZvRdm51hyWqszQjNUI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ngK0fnmK;
	spf=pass (imf04.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790691468;
	b=lIFIRTzSH7pvkc2iKvIBp2tHETBFArJLEEwe2zIhs3Ru27vHAL+2XPzt2mfQF/AG8UFiPw
	PPRyt+RSB2eIHiU1kIxR/ivDai0otb/FV1WdpEVJ5N/9BLM5HdB492SEAzlQEWUTH/AKZV
	sz2HxBYUT64wJbvc5lI86Q0OMsBcacY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d3931so32308355e9.3
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790691466; x=1791296266; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4Yh0Dtvko0nZONYoMl+zPVKAif82Q3nxAXjZ3IYlXSQ=;
        b=ngK0fnmK93ipe8sAAZGLp2f/ibEHJaDG6OylV9K4jJiU4ZXdcJqMaj04DloV+TjwEW
         sNf7x+U4YPtkkv+g0AafkuNi2ooBGheNgCAx4BQlSAZ0UQ0bKG+7u6OBH0FN7t0qpAex
         twXqaeK0n4lHDaPKPBvATwTqtMAMVN+1b0brkBKB3/ZU4Esdxc7Gx7dn5ON1leORvxON
         Yboo6AdLgDESexa+sSoMpjQA0sfsLP9cEbdoSsfqs5ngEAD/6RFIWDQhRq866KqohxIl
         6y+ZV5f/s+n+t6BJ0EmYZKtYSjfsS4UWuA6lR/6tKKlfMdAIEuToGMTGkwUus5rK12hi
         ZaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790691466; x=1791296266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4Yh0Dtvko0nZONYoMl+zPVKAif82Q3nxAXjZ3IYlXSQ=;
        b=SP8AoC3FcMZdXnT9ht93psJa+1zfGiKuv13OfgtvEeONin4WNeDUWoDZsd3eXG63P/
         XzTQ9mvUZjI36eETEfQSpQ8vnAj902o3ok8ecAJ+Fqs4mDvZWTmOdLC1X9+BGikAYsxm
         R+pggX76nDcl3+WYZVPz8dYI90YEAVGjZ1yLZnhx122V71ParPEUF9ZoojXFcj4w0vNl
         cY4VKJueHH/oaQIkbkcSH5+BbmCZq2PedVJ9mjy0UlsP4uZ5mBGd/6D6lOkBZBmjTXQx
         Mk6sBNqqt7Gj/5/5yt3bdREmEasawbTy0mqiGC3jYJUstQsUaUI5CVjoPX0mraROsoGs
         yJRg==
X-Gm-Message-State: AFuF++lndfTJndbupNuwTSDMaJtiY5smI/5n+M/GCNic7VjiYMzHvRIF
	F5t7zDdfpZ3bk2QnvDsw06gyySGCLuLHfTCIKV4TGbdYzpe7r9wng+GMJosj4tiP8EM6
X-Gm-Gg: AYBFou3gICDGvtO2GUsFO8iPU2AfSkpNjFN40BK4tGNrOZ/WuMCwydK9fmd9lK4jGcu
	1V75UiigTuB9g6zVRadO49+ctmAZaEt9qsAH12fqD6AZmvQT9u/TT8TXCy0/+MsjHJa1SVF674Z
	6SdBeJCVzuMeX4Z5hkuhN6ntrDuGQgktEbqV6z4XZNnuEgmYLcZq2qlQrcpWiacDzaGY62zi101
	7d83Q5FaKNb7D7ow9SlMM8XRl0uw4V4l1hitTCE6loIDfC7Vxt1VKGHJqqWd5wtLvrt8dP0v+oR
	fG1tbTTxhj13hGi+R9iHSJn3tlpOpth2HeCP1Zc6jumka48S9IGql9o4xGUSSVct2zgY6OZR3Ct
	Y8ZViHst8Gxg9dqfdlPZ7PKbh77l1Robm3kr+38ATh8MxPZyLIVQCRpFPs1OG+iGWUqCC7zPr9v
	ML1Wdor2qFdKuaZqkVecHEr6STINAyJxGJssCveXn2rbVtImT3pomtHtVgw83mqbDrPacJ+CHrD
	bq9VdQhjkhf2rl4YIM74jXBgK9xEmcL4LtnhYG226yUdRG/+cHM7Pudx2D6hcxrKFlXcOpeMMVS
	5XZjGHYhbTu1SQQM0Q==
X-Received: by 2002:a05:600c:3511:b0:49d:17d4:d6ad with SMTP id 5b1f17b1804b1-49fe66fca74mr266280215e9.23.1790691466237;
        Tue, 29 Sep 2026 07:17:46 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a013d05647sm5702365e9.2.2026.09.29.07.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:17:45 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	andrealmeid@igalia.com
Subject: Re: [PATCH 1/1] shmem: fix unicode_map leak on remount with casefold=
Date: Tue, 29 Sep 2026 16:17:45 +0200
Message-ID: <20260929141745.211878-1-med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
References: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xt6mx1e4z6d7rqubget7zwg8kxgn7i8j
X-Rspamd-Queue-Id: EF8B440004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790691467-727601
X-HE-Meta: U2FsdGVkX1/PIca6TNobuG0StbGWfFH70h9ZYiyCz1nZ9irZ0BuymHukQoW3rvI4nCldG7jiSFbjn79fGMvwVI7u917tji20wwPvaEdqfjcVyzncKK9KTV4CHV3CQb3lb++4c3bQoXksqmGLt+YSAbGnwwx1BPnC8GZSN39vrDPyYuGM78q9KeH8VL9DvR+/yW/+YV2DLbBZ5n0MxynAar0yArMUCQG0n4sXoqOzHLJmgskMJbn7JeeYwpUE8Z5Dk8S0v+8X0E3Gn29aXpVSwm4FLD/tIPfkBCh8++6Wk0CLfAWSplEdp3UZxald0ICHLnIFEmbmu0Xvswz2ymy8owenMYsfbON6N6HFaMtQISqjjwGtr7iHtsok8EZcpiKZ+ewvphRxvT/pQSI4hwKZI8FOBjIreQl7VU6S+76FX5OCLZd9sSTiGBIo4h0FqRM5II2ADFgAyTjMt3h2bQylDBfKBEtq7Blbj01PKQztt3yVtxiBIprbNvdwLmYZ+m+UG7L4T0MZTeCLO/str/QmA/ty06+Hbm1CdJa5yqtzFY5BWu0xfB/L/TnczE90bZf3cTJ5PbDRIcRlnrTirQDwRu/3sVpeT9b6NCSQQ7iGX4jMdpG+K5jPYOE72jMhTv4NfKii3yZcb9Fsm5dhGUPCY/+gpoZoAeHd3a+PwGf8DgF9KQezo6Hz31vWb2tKi1uPWdDi+ptHY3rI0pV0nM/y6qfmYQxxmzoUc1gtyPBwRkPC7biNB4Q9puPldcY6Zb9d5toHgm9KbDHQWT6bmaJ7ToU1Bk3srafbS4kNyeNAU9zEU9IwYrrxbCAM0wFCGwvshI72aOBvHKfHWHFbGzoNf+DTJ5ag6fzLw/BngaWpFsLfrv6c2zKAWARr9XC8r3CAo59IDHjpmtu6eNFyz1Q2XuoEiEvHu1KIuqA82TRsbjMD1ef5unDvhqIs83cI44rZwD+ClRgLIlAVUUQqMQf
 hpe0UdYu
 G0uS/UdIJZ/3MdRr4m5kovCTqtcaQ0LljNjerOXTUkjoN8P6/5SPoFzBeet1GcXX9n/0sldbX67SdmCVlwZCBs3jgqz492sFogahSoAqUJAFhiUYyQQET24Oz9hW3O4C2JV5gmcZPyIoNTurWglpgu1L5S2sbHlA2639GxFBdqYbq9+RH4z/3UIvBvzum6TQVBa9sUK0Al41tkb2TGef0XYM65G1eh88eJOJwdHu5pR3NiGdvn6ZzjTwxheSl0iMaQ1bDyNZ/MwUDe9vbnI2U8SHjLpsZJSDDa400e4iytcCALP9AemG6804b4XJefctFh1AUeyw2bDMCgmjwWW+4Y3cmXsHVtod16Z2jdeo9H1GhYCTHxOgbagsCaFte8zdH6ALgdP7da04lJfEzHrNlDYYCXwZFqnipADYB2oSleZZ8tj+23+gYQfjOtJRLD19By/4zsnYYMH96MtWd75AenpPluev3mTTh0bQze4qdfC0ohpe4d+AANql6Qxiaj8AtKwDD5cgnLdkLNp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Missing tag:

Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")

