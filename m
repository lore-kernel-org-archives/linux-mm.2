Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE92C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0515C6B008A; Sun, 30 Aug 2026 03:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029096B008C; Sun, 30 Aug 2026 03:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E81276B0092; Sun, 30 Aug 2026 03:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB9A46B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:27:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57F4316024C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:27:12 +0000 (UTC)
X-FDA: 85157104704.01.FDB53EA
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 914E2140009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:27:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Io4z6jul;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788074830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H0NSc8dCdzQEaixfxG0SBDT4pCc/TJMvf+PTu1jP0Oc=;
	b=RKyCb/w6Z2FjTev07X5/Fjr7VeNs3HBuh1ai5Ugkbt18uEPXejrC1NTBHuXPO9YNwbg0VB
	8MOsnEgljw4NXfKvMnD+Kk2TfWVv03dZjtIjxWUls7YhTKgX1+JYDaknlDeJ/ZwzsmX0np
	N0Vt8GMTNlWwzvnjlzlrnHDJHhSAs7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Io4z6jul;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788074830;
	b=mGuqntQMexlJ2N6StEyWQJJtNFa6UGkjz5mbbtE3G8TyexLAJE8rqIdcpo5Z1Do2aHDCh7
	GXG/AAS3dEdJN7z0bFwM6VZvAQoSOFp2LnLqA4CoIGxqqq4ShrmY1/KChtS65fVLMT6Fsb
	F25/DGs1cDa5M+Wx8j9v4nROTVJ7O5M=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so2142734a12.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788074829; x=1788679629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H0NSc8dCdzQEaixfxG0SBDT4pCc/TJMvf+PTu1jP0Oc=;
        b=Io4z6julu5Iarkcpp9iWtQlfDvQRmkn3SO+Q4Jzz2u3c/vkV0sQwinnJEHzoKqtR74
         dTJPM3FHjM/YYyTz/Re9fC/iyAMPZ8z6y4UVCCiqbcLRXxF+w4dlCqEiwgGuaqkKn62W
         lWdbvRXnM7hRgmqx/63ipBZGXIJrVqfNaYiwcWdLrgRak4I3MCQItjqxm1wP2ZdQahHX
         8BrElaQCkEqXrbh3iwkgz3EBPhaoopFnCvzr68WAlnEI050i0thxv1cUfC3PD0WmLr1u
         I3fX0Xb1VAKanNQo3FI6bt5eMh1bc7jPWIXoTJo1Va8kTnR4tEODw8eWBe0bUb4a+9Go
         NLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788074829; x=1788679629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H0NSc8dCdzQEaixfxG0SBDT4pCc/TJMvf+PTu1jP0Oc=;
        b=O7qDuwpTW9WyudfpG70LgoZxNdxYtJAz8dws2j6jfRxmG6a327itZ+ttX44xAqROQy
         GKn3ITrJfzJO5rx+DxFUDu8YrG4+O+T7kLvqTm8Ll5+SqepJTuenfyNHShzIuo2g+c+O
         4mA6bca5/2odF15iR/58BwTFjpjGfyqe3844/v5LkxIpkjxbN2PuClHTLq6jL33yvjFK
         h3i3HXpxe+5nQ6GxdHYwDQKxB5i3PuJ8hYemN4g2P9b24S7xTeKzznFViJslshyoLopm
         OvIF/G3WXxx4wjzfXHzYxxgQCcIC03pJ6kJrCmdbv8SSpywFADSHtEXpKXHG/qBS+96p
         j7+w==
X-Forwarded-Encrypted: i=1; AKwUvBwKJbJ9KMQY3Rz1IPNJSKGIpAK/rwDwkMZk6a6ZJ+y+HWgSI6S1H+ww+lewLplYIhqYr4BR+WHT7A==@kvack.org
X-Gm-Message-State: AFuF++lF+a/5z0ai8EGp0Xh4KQFRU8ptYJKxj6QBiQNrtoxdyr1flM6M
	KQ1syu1FqARS46QT+B7uds8nkMD5GsmTyOPbA63FPSNJNMc9VtXU5Kcf
X-Gm-Gg: AYBFou2fPkDjkeakRnc5BUtwkeX9tQa//Z7y/efbQn5omX6UD7vtPldAW9L4gbXab2r
	5jP3ENQpvE8xmWUk1mdVJ0r4JZ374vGyVTc70mqKJ2rpOeGxNVlmM9Fc+IS0vLlnVJrblyXqJMY
	W1/0N/k74eXaijLGsTG+8PTUe7oT2JFUOo6xk35+XXqFUcmraMv2kl+QHPEAFqMZ4Y2vjLjkgDa
	Wi/XcLBYrUWku6yD0qNIhJLmGvKeSHRKd3saJ1TCQ2Ih/avdiNp9s8Em/V8/GNpn3xiz38zr+G7
	NDLawovJ8jrQsEVCXLXpMpIFEmNuvJ44WDFih7zDAH7d7s+z6siB+YaIn7QK+WNudo9ihTFOpQ6
	g92QEBh05eVPCxm4p7a7wRc7vu/JCKX6R/2k3J24+Xm6upZzDCr6VxxH85S5WmDMd7b5van6A3R
	ZAoslXlZJvytWi4vUW5Cw7oqXS/qiebpS8HtmAXF9NIGZqO2hS05yyiCIP20JV53Of76AlQT8x2
	1BJHSlIB83sFn4AqJYcWv6a+fj4
X-Received: by 2002:a17:90b:3f50:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-396d0df72e2mr29568789a91.7.1788074829523;
        Sun, 30 Aug 2026 00:27:09 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398bda33e17sm4492394a91.14.2026.08.30.00.26.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:27:08 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 1/7] mm/mglru: separate folio generation update from LRU accounting
Date: Sun, 30 Aug 2026 15:26:41 +0800
Message-ID: <20260830072651.78997-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-2-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i8rc5zrmwudg1ti97ynxhjusamtj4r3y
X-Rspamd-Queue-Id: 914E2140009
X-HE-Tag: 1788074830-537759
X-HE-Meta: U2FsdGVkX1+cqUg9HcICB6saCYvXBJsoNK/w5IBhX8sH24USyq0f3QdwRNFgkWuLRrpiRDnqNWO9C06hkrfD2slVW3Tns4+tWEmzhkYihFv+UBDc7K/RuhUFBcfM6gLz90usKUg8DntShRgO4HetGYQH41wmEblNb1pTfSGq6V0qK+4Zp+MOwHpaQ3ynz5OA/4JpSHYmVuPYm/l++ovPbTfJjlodoxfFD12KQ2PYmuHLTCXO1/i4SAsgyteF24R5jz8uD90MA3RwPJAgPRQxTzELSu9R5ytdPh18/alvTS9IPBR4hsZdncCba5s6aGJZ9dkKgwIfXfzOTF9Byt+DxFSBGA4jUhJXJpchSDNNVTPED8DNwwnYnmw/guPUTYfrMi8nxDTmzUw6tG/1uUR+KbePLPct6r8E/XMCu2w5QP8kETTN0Q+DSe8+Id+DY9x3yycukQ/7kuh8pLMXK2sGWibKI5DTMBrh1pHCOi/+m4Nnq9bJDMfmIlzckbdRsjYM4VDpZOG5CXnk63jEmcuu79pKzfWjHpR+yJIQreeVl+C6f4+XHbgsE/zWbUDSYe551kmyEN7kEmC4YlPBWnaOF3SytuYevrHpCjTwyD5DZ75Wrfxbm0HwVPB8VFT+k7XMqn9GgW+aSPgqFfLSpa53Suyog1/rvX7KxG5HlQ5/r35UkIFziI1RukmjXMgDK3UoTbYYQdf56qTt7cmc6l0fqjdcORwV2L1fcDuVarJREa6wA6GKuuY2mY0I79qwWWLFLWtSfmznkk4hST4TUxM9tcwrr64MfUQIQR8R88yf2lFWO/2HIZVQC8pbMcfAG1kF5dpaIeYr7siHgniFgIGh10dTcR1ONc4VoJ7Pv86r6XgH6HolVtuGQPB8cNQnDLfZ6powoJUITPbMDFMQ3cXKTqMEbSktB9Wygs57u6n4I+yEi4R8yTXDe0wWoj7ke0aSm/sXTabB9Zm2bkG92Xk
 Se7aBJV3
 n3eV/5yURunGEKuIt+JtUO1oVRhHjTMQhbuWErWXBjrdD0W1dp27v2cd0p4pYZ3+ZrLvaEPlQmpBFNWXCjNh1eLlTqnbsYxpUQyZQ2UQMQQPiC+SGQYHUMXPBPoHgnycC+OQ/nVIp01zzUKfKrooPHJrtliEGtWdZZv7o5+l0aKFeoYA6JADJoKCYmrU25uTdDWQJGChqfKSCcs7bX1N0HRNNjJoxdbapi8H25pM1KuRkjJuOiGyQheaVKfCmt4Ssllx6IuctV4SrSh7o4gy49jR83evkwekCJtFXaXAbxtnP7l4sTIF7m6rHmmzftAO0e56pk8zqETkWYLJUCCPosvSPuHa3s6w4Pge8V5UaMiMThB9fYt7bTyZkVUz+Ro7LRZIuuzQrhrh958PFtAfjbOzb0OXskB3uLuUvAl3Kz05LenAG/TgWGaUTKfasG9dTnjA2JluhR87ATtUxAoZFtnl8ueQFU1addVCWRBw9y6DQ/yM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Extract the generation update into __folio_inc_gen(), which only updates
> the folio's generation and reports whether the generation was actually
> increased. Keep folio_inc_gen() as the wrapper that performs the LRU size
> accounting when needed.

This is a nice split. Separating the per-folio generation update from the
LRU accounting makes the batching path straightforward. Looks good to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

