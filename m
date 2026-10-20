Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484D9606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=d+BzsMcM
Received: by kanga.kvack.org (Postfix)
	id 53BB56B051A; Tue, 20 Oct 2026 12:11:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514576B051C; Tue, 20 Oct 2026 12:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450126B051D; Tue, 20 Oct 2026 12:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 207C36B051A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:11:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9E154029F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:11:25 +0000 (UTC)
X-FDA: 85343494530.12.DB6ED31
Received: from mail-pj2-f6.google.com (mail-pj2-f6.google.com [74.125.227.134])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7E69A0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:11:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+BzsMcM;
	spf=pass (imf15.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdKpeXgyqOVEtVxGXAfcleh4j7jtKB2IC4Gxgl29KOA=;
	b=gpr/+SwaIEWK9KF7tyvCs04NaazSfY9kcgR68OkFru1KgDjcKSdInXNWGAl6VD55fYl+A6
	pWx0IGZNN19qKAiDv/gXkDSXY5RY0ISWL3yXUUXtAHBb01kcuuqbsTt/ZGOxoKrersyLqh
	uNLKzrxFxrOn4qoz6xDU9rUdRodu/QM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+BzsMcM;
	spf=pass (imf15.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.134 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792512683;
	b=mANqb48NUGTYpBk21gV2UOJswg7OolJeUChoYYLTOFol4Tr+VHahwGGfMVkYLbmq4WOcYK
	tzd/bxLotuT+AjO6ZpzEx8IQHwEexq/h3BjbfjJT6uEzWibIjxeR7C2pZCxOlbSz4ulFQ1
	gfL+Evz7gMlbdIaeQm/qxZH/lHeEsCo=
Received: by mail-pj2-f6.google.com with SMTP id 98e67ed59e1d1-3ad41b6b2ebso268253a91.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512683; x=1793117483; darn=kvack.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FdKpeXgyqOVEtVxGXAfcleh4j7jtKB2IC4Gxgl29KOA=;
        b=d+BzsMcMNNyjHa8eWMiVfLCVUGtmH/GqnH3FV2A4vKGWuRF/uLlgZWOBJzNy/BadHb
         p13tZUJJsGeCPlxk/8ct47WqwswUVkOzqxti34BFoBmVp3KE3io+d9TCMCUG6d1gwtrI
         07d67qK0+Rw1pgBfjeA8OZHCcHd+U+WVlj/gyfXq9RolWV3UNhz+csYlgGycMmKbY32X
         9VZmuy7Gr3UwkSKmQ8xEUlll7dCaoQzcQsOlpwo9ISo5/+V7IL6qYO7IQv5KinFVCV0z
         wDyLe8pM4jl+dmgNE1lPpSSotYl8PhTVKt9nRvDqAwOVngW/d+3PuP9VUKUFXH16+kuj
         dQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512683; x=1793117483;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FdKpeXgyqOVEtVxGXAfcleh4j7jtKB2IC4Gxgl29KOA=;
        b=Fp8/69FvySYoV4BRdLL1IbDsyrQbXyaLhB3XodV3qWDLhKw+sK1IoCeSbf8sczPf7A
         zbWNA5Rp+6bXgwrfMGdcuixhRyLc0W2/WnbmStJ93xvC9g3ox/ckjVQ6UC/uXNqc4Wu8
         VXR03n6llKok5OmPK2WRQkxuryHCv4n8+qt3lKdHd0VlMuTk0SXYT/wbNVDW2rVx3NTk
         b1DBn7e2UAiIsGLKWTQI8xpfzfg7WL6pq88pqJOe4sk4Q+2CpRV68n/yN8Da1OQn6HgU
         D8vaDoY3wyg5YUvumoMG8ORmnTkLQydMI32aOlu9RYIjSJSX80bGzKtfk87UaCe1lpK/
         vR1g==
X-Forwarded-Encrypted: i=1; AKwUvBzbPDB09HxE8Roex1oNnNoNiV7jCddCHv3tDNMain5Ho51Td3rBCQ54ti1BchLYw46qQN5HHGFTgg==@kvack.org
X-Gm-Message-State: AFq9FYIs4vIl7UrzUCh15bgmOFWaz3mkCwV4xlByhwMbkYJ/hCSj3bUj
	Y+xp0Q0cvQ+JhZoEvMiDLEv2qjdWDCKyzrXZLZFeFX3IVIIkn1NxmtZo
X-Gm-Gg: AYBFou0jL62Xvmy+Ds+FJNUYrgBJce8+4S9tx78otqoExKHIcpDOMYv7nKTS6nY8Zga
	PDxJ7AYIgHa29gvJNUGm3WH0p0ZkAZMO27N0wh90ovP5mqeGZmfc1nX9pmR34VVAWZnRemsrqNL
	36DboXIe1qHkPfUoflRUUpcYukokzlc9YK4REU7PyXvNmxKMkj+W992yc/yU/uZjZ+CWeKy4Egp
	NzFY5fLq124PwP7v1XoPcrtj6Spv73hWysbcBoeSGRwzk/fc+fYwL4oiGPdAvckBAPdY7vyUVPz
	FYPg6rCYTG4FamHWuc0lU3+Bb3BbQm8q2EF6AZX5PwjMp5ZDoJPWECYXrS7Aue+XHnplFuVX49T
	eVFqlkGmDKuV+9rqYDiRkiB1qU0/fnIYx8z867TMGkfqXFXMyY40DRE2KoYWH5QydXLNdDonZP+
	cF/MsgO9xrBVn1/tSAjgFdGvfq5vAhWP9mlni0YJsfngJw3rqF3qUd0tgwL8b6rIEullvAV/zt3
	uvzlJ5skBUicXdUgvKEbSi0rqjw54epQUJXzzLcW1f3Z55v7Aq4usknIpS4ik82O2527uxU
X-Received: by 2002:a17:90b:5345:b0:3ab:be66:ddd3 with SMTP id 98e67ed59e1d1-3ad64bd668amr1739707a91.32.1792512682581;
        Tue, 20 Oct 2026 09:11:22 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc9942956sm8903911a91.1.2026.10.20.09.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:11:22 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <179251032453.2.9019098760697634552.damon-quota@gmail.com>
Subject:
 Re: [PATCH] mm/damon/core: remove unreachable damos charge_{target,addr}_from
In-Reply-To: <20261020023958.108276-1-sj@kernel.org>
References: <20261020023958.108276-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 00:07:00 +0800
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D7E69A0002
X-Stat-Signature: 7p54je3xkbat5tiwnhhf43hf5y3xwfek
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792512683-299636
X-HE-Meta: U2FsdGVkX1+n/gJu9HreLyk+6FUEHjyeYCDLqSzp67VQUXcElqf2wzoEohysAZBWQYMFMIBb9/Len7hDHsXfeYQ7DeFruptmjpcA2CdWYH4OmZV12clfiUfxNCJgFxZLG/gqucaAqF2pdAv1bMxWb6CzDm/MYHskfJki2EEeZMwggf3XTiN1+h3GGSUz0EXCFQFjBJWq7tTUgd5Z2qD1dG8HvVCyIXCmceE88atLoBENb5m9QBDp+C45hDKv9uPEpb73qyWIXbAEmW//dbVLXUZBP4RxaUwhn/CdJmr/bIqXsQyMILTFuFKQLVLNRZP0mnIzSYouQYW3z6yjvM/zyIuhbJpdQ/ZSNOpALTBarjiTG5jAxOGFuev1T7R7MVFQWiUCr66ZBrjK15/+ifbvqzNn99gfztpOrm22uCAf3CsKlhToiJDq6B3wICKa3UuUk62QnTKWCm/BSJvqCVKjqWIjyNM/Zg+17+WUXwsbwZ7KLQQ0E1fNObR40O8HX4MyTG6i1f9AZ02F1brEXkBfcZeTWy1v9nGBEf50f1HWyKO+sXxGS7X9/4eYwynhMFxWm5kyh6sjz6PHKL9ApVECD6yvaKlFcfrAVlVirv10n1VGbAstdfSfmvkQrrfisj7UPByiJ61hFe9i+GW9H+gTbr9oSoZ21l05xOXM9yILps/bLpwEcyH2LTahTk3H2+B9vXYFoWhX/OjcCESMbQnSTgeJJ5MnWWcUWtsIVq8Izoz3r2ELms5/NaarAW6a2tiHH/t8SgIgKv4muFqSQxzCOVXD3U/Tx1SZyWQEZRcfyvip5fO1mYW85pzY0+YBsERm25PWLpGjeP/LtYEmzS1ICVSaAsRiXTw6oq6TXMFLyxt9p1v2dG+Hc5YWebC25bXRvWfkweRETR7KPWMl+305BteZX/ZH6xm2+jzKC1rWhYy8tQu45hBt5Tg7Vdgm9YXsrIikXsD5sAee5aIJe4V
 xvu/A3Z5
 /XnLcJ5DJCYavo9tQGvj0N1gqZicbo1jrqO1uSYiA5pyXtuwcQLzPnWX+c+tqdR0XprDNqnTGgaiDVtWYiGha1BelZjrhziJXDDY//7mX9uRRv7Wrfhh8+7+CBaWxV66OvDTMnuexuFHgame8oq1TUAbAmVaWX9e4MBlYK8BFMubZaIHa+4isS4hULRfETsTG+uvwbcQNZcn10nWfJRgzYLFWmJwywKoQ4zRgAH6CUzq5ShOwvVGy4YQTJ/TSVWAINROWWzK0sGdXqimDlRmu/yzoOi3I3Wwx32YpXTXcko6EzYip7uOeYk8xVqUacbbbP9LhJ/ClRkDa/bxdzcDUIAOh84BdPRdUaoGwCfv6O0CKf6whbddl28XFEiXffd30fnA1BrTGXQBJirydTrfyLCMgN9zLtZjGvNa8XBd6BSfSS9RCGtcI4i2WGl590vCcE45vr4F8zKJIEAnHRT0HjjOizPBHYc3X6VeGijf/7VxGc56uFcyVDgrCaBcw7XHH4T1FhBpJL+xCwD5HK6YCJOFYuo2YA7oZW53d2vUoF3gPdmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

> Catch the corner cases in damos_adjust_quota() and reset the pointers.


The patch looks good to me. I tested DAMON_RECLAIM stop/start after
filling the quota on x86-64 KVM and everything goes well :)

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

