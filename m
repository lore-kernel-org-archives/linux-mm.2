Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04EDEC4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6C586B00B8; Wed, 22 Jul 2026 12:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44236B00B9; Wed, 22 Jul 2026 12:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83026B00BB; Wed, 22 Jul 2026 12:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38306B00B8
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:56:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C160DA0AB9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:56:50 +0000 (UTC)
X-FDA: 85017016980.20.0C788B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9D0240006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:56:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6h2iD9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3Ja6MqDnVgEe0FBii+nafJwDNldpk18pWW7PwQQnbU=;
	b=sueuyU1zd3P/h5nNlFAsTKRiry3wzbcW3F79nScTnp7dYtwsPS/1VzVBX5U2Rg0QDR2lfJ
	p/SHiCdPRLv0A7+XN1v3oprti28Rn4aOw1rPrcSs2PcWIKWlv2EsW0RlNjNssREH+sDW8m
	xdlZLB3nqH/lYDL84O/oOsNcqmtMrro=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k6h2iD9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739408;
	b=NemnWVUKVIfI75TH/IntSn59w+9zXp5i/kkMnErPNnQVBCGAA6R+algiDkq79y5dAUNfN8
	IAMhJIaPlCvLnJl16UJ/Wfr/BhzoeOcY+G+R8bEyBGfYhQi/WOjAXOp4L40uGr8cJv/2Vc
	i4gLO8z/5Xug76Plwoj1f9uAYsmX7EQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29ECB601E0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49321F000E9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784739407;
	bh=D3Ja6MqDnVgEe0FBii+nafJwDNldpk18pWW7PwQQnbU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k6h2iD9euTL6JnwyeC++UQIZa5A6VrtKbfzOXIjjGxcr6UPSqMIZ7I/87+lMJuML6
	 JTCcCuCc0v/Gf25DkvjJhFj3ME5tOVxJ1ojLux/SkG7ibz1RvqUqHlRaYIvOUgLcjX
	 hMMLCQg1UjYvPcExcMHGB/WIsZ6AVpMY9fr1fOJ0VnJhQELIwtPFqWezK3a005pQER
	 vWvS58/5RhuCqNiqCvACsFEZCt6EfH+5ZslaJu4fCfKwN12p8zkYID6gMNyvHHYG9c
	 06zD7/befzJs4OO8oxH+l9eT7r3w8+xW9Cpn7U6+0wMt+KvQkStxE+H4gUQqGWkNgf
	 UvtkBK7+7zhAQ==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-81ecf499af9so94744247b3.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:56:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqiEiuLHAKv/A0vSyP7ac1Vl7P2Q8GISuspA9Q4vzD69sH9jVcE+041p3dNA7p+bGFIPrJgwAs/ig==@kvack.org
X-Gm-Message-State: AOJu0Yx1XORxHvg9owhUgP+EaJ94LrL8Ypr3jZE/DNb+I3mapWRR6JcU
	VARDuCRcAiTGBwS3NbfypNlZfs8DJUbpEvpbEZrqV1Na46lRYv1UiNgOfYw3MHQCrVakyI507Zo
	VpJYI25YRwEfF4gbonTFVfITj02pYQI9yjOxy91PdYg==
X-Received: by 2002:a05:690c:b03:b0:813:1001:cf85 with SMTP id
 00721157ae682-81ef2671d1amr80137307b3.37.1784739407191; Wed, 22 Jul 2026
 09:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260722130615.3163560-1-hch@lst.de> <20260722130615.3163560-3-hch@lst.de>
In-Reply-To: <20260722130615.3163560-3-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 22 Jul 2026 09:56:36 -0700
X-Gmail-Original-Message-ID: <CACePvbXCoJQD2xoojv1QtZX6FDim8Ar7Mj7KgtLbZ81J9mk8Kg@mail.gmail.com>
X-Gm-Features: AUfX_mzJfORi8douWKYBIFzga5EzScYpBxWUigLUVgj7zCnBS7ShMqtzqsSmog0
Message-ID: <CACePvbXCoJQD2xoojv1QtZX6FDim8Ar7Mj7KgtLbZ81J9mk8Kg@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: add a new swap_ops.h header to allow for
 pluggable swap ops
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9D0240006
X-Rspam-User: 
X-Stat-Signature: 1oei7zuyigkq8wrb9zkwex9pr4ob56pz
X-HE-Tag: 1784739408-305377
X-HE-Meta: U2FsdGVkX193Gx1+gFC+TWkAdGOHMyF+V3Vb49G1n1TS4RcZQdaJpk4rx10cv+/PZ9wKZWvqIQWnJ9S9UXMabK5IPcvPG9fY/3CnH56VjSuHJAtUYlFbFOC9TSDYMbUow7Hqqs1J2BrFi+HNQ86eyLgbqxL9n8KyUBHEiJ5YSAHbT0YixghLoRBIBeSKlAzuvk7H7/vQOJgY3qSiFyhmzVFNpMogqREAjQLw+2Ourj9AhVoz8wXyJ+94pobEE+7wqhjkOM+XCt0YCBGsBk3IGeoKnGmANBEW4HRXs4X3gCkcwsjPD+Qtra/9xEWiUwJc2orRCLlyAzE4G7WvkBIM7LzAPu2QiMNGCiiUMaYZhkj+gcMQhdZrBIQHx0enDHEoaGrhivMB+YY6AigkkpYm4o5hsDu1lcFZOfhwzMLE9yNleGnJC/jNpnBkPMumTVdNyFFQk62QZHYEnIBg8QFzNs24uCc5yHVDBV7PYlDcBUhlbCq/CBDgru1YJABKhb87W99ODsb3P4xiBvAoYi/gCC3lYM7vcRVubj9W2XNc0dnl7UOBZ9nmg6B0hy/7CTwqIWtrPAdBGXA18HK7hrKWHl5Q04tMjeD6LZ+gSX9ePTJGE77QFsn3jSc7YbAGr6uzfk4rt1dGFu6AlSwonf+9joCruN5kdNGDWq3sdWQE4C1TX31M8LIHueAbzswmnZd9ZHXsGmAZIHwrc2/uSzNke5xGGuJ7uR/7eY7FEqlwCqt1CcJPWud2jxhog/YtV3r1plr3FjRPRqPkTVdgTVrcxZhPwj7I1YHa3L6Jbo+1BTBPm6PHfapwPogToVBhgi2XLjEUStL9hGHQogv/0dNUMt3yOJa/aHU6bl5bNvDguRnbEy20IscWxWw3jRAnjDBO32hthBpmzQqYXhtnT/6qrs/roOKXqfF7ITwku5JZ80htLkedDxQUnKbLhLJl5Tl/TOidij6GhtYQiHXQxD6
 anV6P4OV
 E3VEQHKGn4yaP+XzBWp1DpMi4dstqBb2HWAB2jOTljv5AhP/AWxMsubRgVdjS8ZgZr3rq73FnX5QRaqLzplLigSkKaWKWOUb01dfcKvT21zx7Wb97txGkcokwT4hrCOIVKW/f7N+9clh5CZTLGaU1KIrm9uaGnaVdBGCcJsyCJzitWo+CUa1cp0ALfhvOet5YvIBDORU7N7U25i1RxFjBOzCbxyM9Dq6X6LRE2+lYjY+EZ/+8F1V6m5DBWYIN0WCVdtvvhK7rZK/6II3qBpu+jnIZwAK1bmrDjluvUVZeLQ2wpfsM3vKXgZxXSI9I3WUj9v4F3Yj/i+id8Zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 6:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Add a new header to declare the swap_iocb, swap_ops and swap_ctx to
> allow for swap_ops implementations outside of mm/page_io.c.  This
> will be used to remove the double indirection for file system-based
> swap.
>
> Note that there already is a swapops.h header, which is totally
> unrelated to struct swap_ops.  The close naming is a bit unfortunate,
> but I could not think of a better name for this header.

Can you please clarify if this commit introduces any functional or API
level change this commit other than moving the code around?
I don't think so, but I just want some clarification. Maybe there is a
minor API change to remove the double indirection that I don't see.
Anyway, it would be better to spell it out in the commit message.

Chris

