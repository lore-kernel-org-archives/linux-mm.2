Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4F4CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6376B0005; Wed,  3 Jun 2026 18:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76D86B0088; Wed,  3 Jun 2026 18:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8CD96B008A; Wed,  3 Jun 2026 18:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAD646B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:43:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 324F01C12B0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:43:24 +0000 (UTC)
X-FDA: 84840079128.02.8D5CB12
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 50FF314000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:43:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aNyr/HhV";
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780526602;
	b=AGfGpN3gD2kbCqzIeidXBxs3Cld8rGO8pEiJR7gKnzP87QKu1V6Zv367Pc8jqhXT9lqb3K
	3i4cpnedro8sokR+JaIME1cqkJidvCOTakFEuDfdGnVjNKq+Cp8CpbtYIOyyy/U1iMWX25
	O9nk5ymaCegS/x0mH6JLKLgic+hYYC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aNyr/HhV";
	spf=pass (imf09.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780526602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTE44OxcHCqYjYX+doIy+3NqUmI4SQrZkrHVFocDs+M=;
	b=U9/bUcryxKwx4zZ5gBVIB2NARtQHJBzY/FP3pVHcRRk8oSgR35QsZfSyILkYeIwNW4BpMX
	sse+VyPe8r0UYpx0cpMEhSkd3xae5Sfe0w/e78yxjpVo8HyHEHdqXPGNrS9aDbiWl6FqbU
	3oa1bRBch4ciDMKWA/BF8KHXQ59q70Y=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490bb83a3f6so666665e9.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780526601; x=1781131401; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTE44OxcHCqYjYX+doIy+3NqUmI4SQrZkrHVFocDs+M=;
        b=aNyr/HhVQqTLxfEFkmB7PuY71S6czomXGt/8coN2WAyRB/kaNKmqgGtYoskIvIjdas
         qsVa9enGPUCeWelbVmf2fnrSnNqbAuCmvpkrt/pSBm5XQCjgEqcI3GwPmAhFTd/AMR78
         rTHPpWfB9KXxu1xoCoTpBFaC0GxH2tFjS9axQn431vgibRn916Y8spDokUz2QzJqNq/6
         isbUaTItJWKMQzzi2+K1N1G74N0I7T+Vn21L1XNxJ8MOteFyXc5cpu86vwXgFs4fx3tW
         v1vBklmxL8/8trzePDsT3KWJvsDpoYGT22so3Td6r+WToa+Ej0KYuPZ4vgDePDtdgXkC
         ovRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780526601; x=1781131401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iTE44OxcHCqYjYX+doIy+3NqUmI4SQrZkrHVFocDs+M=;
        b=UOldNGRtw9z4hgoao8dAU9I9c+dF/4Tx+1Ym+aWhQ8EcgzlZ7XnkZtXvAvs04ZVzde
         Mh9LnSbHB2ZaBBj8mRES6eO2ngJ1uQvK7emMBRAH85ucVEHLR3wYcClDAwmek9SDnW4T
         ZImH0j/lN7N0eu3KRNXaGrC0ieXutVuedQyF3ddm+e5OpwoOH9A1rsioFZ+uoEak4Vqa
         XIKiCt4h8lua27/FwqcA/IZDyBKaSg/kuW/lVmgxXKm0+mCkudD8zuRZRnkCq3/esk5Q
         derjgwI9sm0KiNLAt+Wkt+FUf/eoY1hiLqB0A3QHt+D7FcCCe8dUCey57YhjNEWMhVVw
         v5IQ==
X-Forwarded-Encrypted: i=1; AFNElJ/hnrRXyTiuv3txOOPK7UyhwkchrIT4I5q1OLK0LELJe7ynLtg3qQ970jTglHqpBWxYzcn+WC+Cng==@kvack.org
X-Gm-Message-State: AOJu0YwOSmtDaagBE7vuHRVTxUuy5goSILWerqX4AnuHBENDzpXr5kpx
	ZKQuagR55pB5xs/EuMJFx7a882d6Om93Yx5g8DFC/yx7X4rO2l/YsdNQ
X-Gm-Gg: Acq92OGS+boaI351qgOVweuOGbsBJzNGiA18gjk04dZZgYsOV4olwUxmF/RW8O9hUix
	2Xh0gSNurWuQAIsjh6VikBazyFdmkuTMjrqHl4BdYRpr8HdCQhtvMqef5XJr89jf78Cjlrgygye
	3fHRP1Uil2fZFsFyRMdjZ/Ud365GmYrZ1g1G7OyiEeeRnc+VCW9yDlXd4V8m+3C8JkCm8jj/wsJ
	0PROxW1Hd7oNPC8wtygqmBx2oySYjh+JIfasv46GC+IKyX0OSksXc9w5h0MF2M+L0ByMaP7xJil
	kDXbSSS0lEoXG7i6RI5JMQt0ME3yeE618Uxc+x5XGH0/+NG8xzAeCttqDSessYcHNlf/PDc7g6u
	G16hPNBDdMvw5qzX7JejnCbtz0Y6IhLDnRWPxZstYMn/fzxjNllABzt4AU668Ox7bagI3CCGWrc
	iu4Ya9I6lnzcZ3YwRY7DxoE4QJ3XbBoA==
X-Received: by 2002:a05:600c:a09:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-490b5fe6672mr83368675e9.27.1780526600498;
        Wed, 03 Jun 2026 15:43:20 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490bc391aaasm29855955e9.1.2026.06.03.15.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 15:43:19 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: luto@amacapital.net
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 01:43:11 +0300
Message-ID: <20260603224311.834796-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
References: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50FF314000A
X-Rspam-User: 
X-Stat-Signature: rr8jocxwpjhc6fxgrjfgd64waypd6zgf
X-HE-Tag: 1780526602-782392
X-HE-Meta: U2FsdGVkX18fChzVXwMAzkojIzGwKezeVi1Qzwinrl630EOAIzh+XqSjAN2u8rqBHfKxgo99cE4qMAOmH7OBVWSuygfClHfxE8aHhFtqZyKZ68s1p1ugE/CyMIs8ZkjJjK3yj1/GIwEAcPiYXzlpiaQEKIJ50m1bhMgNYXOPXsAZl7BtMK/LFo3DuU2P4ZjDC2kEoS4TlU1x5URfywdgRe4Jn18cRefS2K4unbJBdZlPkz011iz27qZ/Wl1C4QH0lWg3HZ+61kv65uk9uikGALzcG8AFCN2YckNTE7U4BRW3VRyxB3R9ybg4Aeqq8ONTo20KXno7bOlwumqWgWkKtG0T7UGYnkwGgLiBdVSsCQgoM0nsbZvFC0YhyZ0JkI+5rzWQ0LoojY8kpJxOlFINUMw6wuLWKl6Mi818TQTALyHzZdTJuxlXr71eAIe6+DXyMuiz3G6j4meHgBk6LmOcVXSqIhA208ssCMbBQJXKo9IKq4TT5rU9F5iSBiPuB8ikd4uoBJdcmmyD7Q9EoIysh59SAIeSuwseRwmvWxVkrm+xWHLoN0JS/IbHcvt9cg2fVpQ5XqNSnM9ac/dt7ezPrryqPX3WSNY27WMn2Jnjkcxw7eq3OPRLMnG2Zf1tU0rtwWKxqIaRQ0Ybi8PYRK76aGlcMtMpFi+QvogqQPl1+iENAmYaFbqHAOU7ue03064YsJOkCeXRQ6so3tFBx/COJqIgly+auJPde84gWigkgJAnXuwcw0ztFGB+edvZpglKSFnFfenoTQDZwLZan4B6UBnwcmDty/rX5J2UV/g5wxkB5esUMfgQRNEsrZhPplV1IG7JdKmXdDQovT+Sb000k9qEHIPRniafLwgwa2xz3YJdc9NmE2zQbjm8nVLGClZzSDFaiXlEqN7xP0DXt9lAhFmN+YbUxZq9ACUnSPpOY80JeklhCrf3jX6o9VR5TlB3b+S+ZcJeb0op+xHApKl
 qqw6kFzh
 lADKMn94M8xXMBhAz7TouWsi628Xp5USLSAV2cdNmF/KiSVHK6BDJxNZxs9sL6F/j6NhgZ4jjPItOw0Bsj2xqyA2pjE2PKvNCrN0pIIxcOKhafv8SeyM1+rOHGOPMBGDjyEQPXAzn7D0Cun4vRMrx+EzBO81kx8fVTYqvz6gZFtMS32t2EsMXHQxzrJlcpqprVkT5iutoojTBiFJQuQYtr9XyZ50Ir27bw9nZiuSGq7/IX4AK/nSCtTW8eAUEkA37iOhTVayr9Sqce+dLHwtv6++jLtmHNoK8YqPMfCmQf/06noipdVTCTfzk2eMWqbZ2C2xVIXahyuk3EhWZFi+GjaPwxh5gPs1uPZYCuhxoe+CtWx5PnnsYw9UMfF28g2VKpozWTLu041zIqNMpecnlOgw05vzQjnzGnmTtwWZlnbeNjlOGTTWmyIWbLfml8R8NDYcAvegKB4JXbY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andy Lutomirski <luto@amacapital.net>:
> Maybe we should keep an API that does an optimized copy, from one fd
> to another, that can send from a file to the network with at most ONE
> cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> for one.

Yes, this is what my hypothetical future patch will do.

One copy from pagecache to pipe, and then network uses that buffer
directly.

> But splice_to_socket involves
> MSG_SPLACE_PAGES, which I think is a part of the mess that you
> dislike.  And the path where one does copy_splice_read and then
> splice_to_socket has to be a bit complex because of tee and (I think)
> because splice_to_socket cannot assume that the incoming data is just
> ordinary unshared buffers.

My future patch will provide new guarantee: pipe buffers are always
stable, i. e. they will not be externally-modified.

So hopefully network code will be adjusted to use this guarantee.

But pipe buffers will not be "ordinary unshared buffers".

They still may be shared with other things because of tee(2).
(But they are still stable! They will not be randomly modified!)

But network code can do "pipe_buf_try_steal" and thus ensure that
these buffers are not shared with anything else.

So, network code can be modified to use "pipe_buf_try_steal", and you
will get "ordinary unshared buffers" exactly as you want. This will
give you in total exactly one copy.

Also: as well as I understand, previously, pipe_buf_try_steal was
kind of lie. It may return true for buffers created via vmsplice with
GIFT. (I did not check this, but I think so.) I. e. pipe_buf_try_steal will
return "true" in this case, but pages are still shared! But, thanks to my
vmsplice patchset (which is already applied), this is no longer true!
So now pipe_buf_try_steal is absolutely safe to use!

Finally, we can degrade tee(2) to copy, and hopefully this will
allow us to always be sure that pipe buffers are not shared with anything.
This is possible future direction.

-- 
Askar Safin

