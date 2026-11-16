Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BBE606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=axU6l20v
Received: by kanga.kvack.org (Postfix)
	id 2E2CF6B061A; Mon, 16 Nov 2026 06:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BADB6B061B; Mon, 16 Nov 2026 06:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA566B061C; Mon, 16 Nov 2026 06:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E815E6B061A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88A75A0888
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:53 +0000 (UTC)
X-FDA: 85440717306.08.61126A5
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB27B40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=axU6l20v;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X92jc3HOiTUE60p5qYpnfogS3YHWVykNZQDGs9aRJi4=;
	b=M4YLhNYHT8VxHnYleVlRwFalDbRt3C57f54hJfZoGpcsh8hNdz9+bob7Et6vqZF02JweQR
	dsSBnpcpYBnKb40fJW4O7LV3Al7z64foHXlxwxHI4fNfoKVH882AwDT/HQxDyzkdPclOq4
	4Wh8AQl9anWgUIZIYWPeFNISWDGiwU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827511;
	b=YEQlFKKpH7KvBx1yG5S8u7bWZhUQvKMZb07hhe5dWpl9yIbzSzPbrezJJXZVe7NK0GCKQl
	FlKLmXGS2/KBteZYnX1Fym4TPAUfxOATcMACIEbEKTPj9rrZe4XqSydzQoxvkxNRP119XW
	knBeLV4fcoYWRmai1xixwUceympcJg4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=axU6l20v;
	spf=pass (imf12.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso1386690a12.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827510; x=1795432310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X92jc3HOiTUE60p5qYpnfogS3YHWVykNZQDGs9aRJi4=;
        b=axU6l20v8hmqoE5HRoIzrPRIgxk6OZOrvnCRZIJb5myTR9Ek4g+o17Q8/JE+2e9vwJ
         QeJYRPk3ZtFZ+prPZZyuJTXiR5KDHh4qRv0iiq0jzlyvAX2LwM3ZLyQF7C3pJljpWa6q
         QV55y5sJkZu8CmQ/If9Mg4YYsSwKnBakXJkPOpfbx1dX8pJp8BiqEVhNdE7WCo0+NRJ6
         0u6fKsomLxHbEIpr6tJXz8jMQXYKalsrWcpGYuhuUPQBgkkW2bWZzsK0hxnwkMnL6koy
         3YOsL6JDoH2wr/bdXTDPDHYx3fJFwWuY7qEH5bdSeLdv2c0DijdsSyyn6L+A4+oSiOxV
         j5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827510; x=1795432310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X92jc3HOiTUE60p5qYpnfogS3YHWVykNZQDGs9aRJi4=;
        b=INmKzku3QT8d0B5ZfzsQ+koA1MgHtcV/y0O08R8UkqMJ72sFmSxT/+b0FRlXpx8Hlv
         7jYaOz3dzq+Fk0rAse2zVXu3k+NsIPdb6/vKY6kPnC+JKxzye9vK/S5uIxKQO/XmyZ9A
         Z0gHKsdCG54OUq6aq/m3oVitxYfTrKlNUIAzKDZ9GGo6DWLXQIx8w9Qm6WgljGO7Zfou
         15c8AydoTEDplWIvLRN8bGC6kgPj2nj3dXSMYnaF8JaCdPBRSaY2c/6Vyu2hYT0HPsbU
         nDPNnbCpgJh015vOJcyS/zcbhpcwZU8i5GLeGdMdqLCQRBub2JRc011/ImtE0i9QWpoc
         UKdQ==
X-Gm-Message-State: APuU4Z+7sKF8eVwQ75OZAjmLF30JQF+4AxNW3M7mKEYUxn/FhChAppHg
	qOSdlO0Eak84PV/SCKY5wusPXKYDsodEuLgY1I4IbBIrpN6D+YcrmqG1
X-Gm-Gg: AZFdTZchnM1Yu3qVWXXw3m9SqB1OHlEbBw4khmyAGt91D43Ao/zF4iJurTTK/GJvTzt
	rOFM9jUbK3SyGvzI/UsdagV+bPDav1OYvodvinimWsFaDANGzvW2HJikObSDKsboyK6Zhayd2PK
	FxlGRjc5Fh0gvPfchg2akYCVXqo/scTSkizTWbKx9222udaDdjAdjs5NUw0v740r5KROFK+ZOuc
	thGh4NStvpLbLLO5w63gNFsTiy6b0//VmZyDbS8yk7F5+d6Zd3UcUIrQHhKyDbBmqGiRpcoZXcq
	Yb4sKggvMarxAWq5KJimRt4OodQSf+v5LzbTojMFZPj/roP8a2ciphLYLLRE+UbDWkp7j+F8khK
	NNbWFRtI9CYFbhy40IhXQTqpTo8QBgL043WryOqdRvW4DjXfkYJTl8DJ9rWbSrHXfn4u1I+8FCQ
	+EfEm7o4fY3H3gJlcO+S7cw3FN7zPPad71gJFBzPUK3/rt/uWiF7ZzFbXeeaD6I+opr6xh/6D9G
	/oydNZIwMj/snlHzpSlMT2aYZJxcnm8Wu4PV4yfe1iPPLF16GW7YHub0lUdzGWuWxkdx4e0yKuK
	WjqthGMzggn33fy4asXyv4ydZw8Rvukbo5hKqJObryWufksa3mZ/fS58UGUShPuEf8Ez
X-Received: by 2002:a17:90b:4cc6:b0:3ab:2737:3392 with SMTP id 98e67ed59e1d1-3b1b0ba9108mr10216941a91.53.1794827510403;
        Mon, 16 Nov 2026 03:11:50 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efcfd7e302sm1080965ad.13.2026.11.16.03.11.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 16 Nov 2026 03:11:49 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: Re: [RFC PATCH v4 10/18] mm/swap: add priority queue for swap device allocation
Date: Mon, 16 Nov 2026 19:11:23 +0800
Message-ID: <20261116111136.28790-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAMgjq7BnyM76DR8cdaz4o5PEg0=4rBAcGvWwoHqFDfPpoqu4BQ@mail.gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com> <62dce3641b589e9cd42edccf0d4e9b31e7d91e36.1794666741.git.lianux.mm@gmail.com> <CAMgjq7BnyM76DR8cdaz4o5PEg0=4rBAcGvWwoHqFDfPpoqu4BQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB27B40004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: j3x5qw8yot588enrpym69foffk1b3k5c
X-Rspam-User: 
X-HE-Tag: 1794827511-730679
X-HE-Meta: U2FsdGVkX1/C32MKK+IoyOmxUsijwObqOH2kU+NpwmjzGKGBPSf1XOGLTAdVKCJsYR/Nh5GlRCQMVZC4mTiguSLpC8RQW+BMVJI1elNJSJbSWcaqGoD9FoT2mqs0Crt1T0rwJ4yniepS5BgD9EriWcq/YUnRx8TdIygLKM+FYld5/Czvrqz2SL1bkdOY4BL7zoVGG/oVoZnR+KYid9uk7efnCrEZeOnBw05sFIyaMk/gAtEYjhYfGw1KXehuaKXZcsjHl7AjyVu8phVUWrfmu1P3baIZXzsrpHGshR93FmTlJEJ2qaEslLe6Iys46ndrl9DPCqdPuPdv+IK13eOcfbm2Trf0I2o6Qdbmzu2Fk2wDhi3hLAMTiJAqABIXxNtXhkd8u7pG3f0bRsUitRe92dvM3trHr3MqUumkwDsUb+xVTaFsCixphSdbxx/7s6pvxUFS1xFuMvnxYYk6SP95cs6aOiNt/3UygZCo/mCzo/46LIYKmSj12QIBoOOibvsWPZhOmPay6Oz/dqdRuVY148IAd6FdZcgYWoTd98bl8Dafiauv+D677yvevrjXZDG5PHXSq4iuvRpRAn4j66955HIhtILUOeu5rC+ZkwF21d36pOoHfmGcS1tt65+pSOSosPMKlCox9Iz25OdYVtLDnHyrWp8rRiaCUmSHGqUE/w3WZlbQ+8TVq+f4tuCawuwxPzZ0WpGMY1zf9Wgn7Zlw2hfcfjuc4+m7zvw4G8HelkkOdAXi9VIK/2rkBxta8R6DXcPjmTO6B1NVq0H7irHH/8Ywcz3ZDbbBeJ4VZTC2J2MfdjVuanYaAe7ed09fK/i4tG5foUp/cr5+enhr18R1tcFrZmJHUSUonhzMTPKjVZOJoHji7xkeWZX4Rte9gJbx7+dkXgZ9w4gIKmBJ/xAuAnrIyprdX6mMwscs7SuBLuWatZ4TgpJ7F8zkiSiDZdTDCZ/qHCa3Ao6Rx/SWc2/
 V7m5Y2y1
 Sm3Ug+2iTRxRb7eLUjXkyfHNtC5GWf9xWKhfcaK3QCUAjtTRJkI5VbNSFdTQDnxMAvW+oJ8JzDwazSKgcoHw3jN+THlcJMVd+CH2vszL3weNNCiFpuIF7VXHfnYnyAADSkWwU2rZREANy6mVgTqbbdF4Qsn1lQ6c8+EMRqlfcTWJPAqmI0qaLkwL3rwf4D0IfzXwIafBXiPoCSSuARGXcvbYb+TYnPAQCGHl3aFNID2GEIDJ1dT9SHuG0VIRP3X04ID7C86cHsrkIhCi8JhRG/WYSvR0e1UExZHtbcRm70PF0qoCCUFpoAJ5i6nnLp0AktrhPic9HV3of3EgOI5ktpXlvuWnHGYRgfDNhFxHRSSO9DMd2k1MXKIOBh8ps2F5ny16RKmsEGzZGGDYEw6HB+zJGenIsCQVpBkiWj/t8d9nbpf8dffKiBrwRRweM8h/k8opK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kairui,

On Mon, 16 Nov 2026 11:51:22 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> Hmm, this patch is now quite different from what I posted in the link
> above, e.g. there wasn't a "struct swap_queue_cursor", and some of the
> naming in it is quite confusing:
> e.g. "ring_only", I think what you actually want is "fallback_allowed"
> or "no_fallback".
> 
> And since there are three iterator-like structs, we better reorganize
> the naming; 'iterator' vs 'cursor' is confusing. e.g. maybe reame
> swap_ring_iterator to swap_queue_reader_head.
> 
> And why do we need a "cursor->valid"? I see a following commit dropped
> that, so perhaps accetable to keep it as intermediate step though.

Thanks for the review. You're right, this patch has changed quite a bit
from the original. I'll give the naming more thought.

I haven't explained the reasoning behind all the changes clearly enough,
especially with the adjustments following Sashiko's feedback on v3.
I'll go back over the changes and make the naming and intent clearer.

Thanks again for taking the time to go through this.

Best regards,
Lian Wang


