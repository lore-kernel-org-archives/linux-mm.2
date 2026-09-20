Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081E2C982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 02:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0AAA6B009B; Sat, 19 Sep 2026 22:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2C66B009D; Sat, 19 Sep 2026 22:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8B46B009E; Sat, 19 Sep 2026 22:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAC596B009B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 22:37:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD76140370
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:37:43 +0000 (UTC)
X-FDA: 85232580006.06.AF0F8EF
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 129AF80005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:37:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dVFZqwJE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789871862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMPCKFMy0q8dOtTAgKNYN+tQZo2X2/BEgITns70uQG8=;
	b=z9rN4bccL1hPLu/UzVuJI2lyCu/21s8e19wBjRb2S3LQcxiqUIoRg0KXFrz7K5Y0gh7B47
	GdpAyEcVRJiORCelr5Wrl6lDbB4Hr8Xa18xYbM/wAGPwo2CQ37imL2c9gm5QdVwQI5lV7Y
	a9AIkoMifw9YzfFqsVVHm7y8Ig119SE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789871862;
	b=lTzYV3Q4i+fJekfR4ELuznJ/oMShmhWZIQ9GVc3bFVi1dxrqsI3G0XMRqaWBsfDaROPJ4K
	43zYwAKc2otGZjNgV08CFSG3oISgTJMbU89H7Nu1Ti/DR4IuM8are7+j9z/9NEC3MN/MxX
	RvsgmZ52QGsAhnYrXgzCslFIKGdA4g0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dVFZqwJE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-39b350c69b4so1711420a91.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789871861; x=1790476661; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UMPCKFMy0q8dOtTAgKNYN+tQZo2X2/BEgITns70uQG8=;
        b=dVFZqwJESxfyABHCV/f/VO1PWq7j5uYZ7Z/cR/5qeqpETobCIM/WhDC/bE0LVVNB1X
         Bcg58F2Sbtd7aKiayFIjMzuLM7BM8+tafdAj9cldGa1+oNjm6kMR26TJ1EWR+ah83Z58
         P1/1O5XnPxoGN61X1xOldIbgx6cWZRoPhlcOKdIplIBZps9B4lYPZ3BUjE5Fh+nBETeC
         osFBz995mQ+yKsnMER8FOIeiBjsTnS0vQNAxPTOlkUx+TcJETntGwu72CZFrIu01d0Pd
         L8Kn5AG1Omee6wT5cM9J4fKyZxt4LuYUE1JR3e0OJheIgoGqm9ZBndBpeLApgI0VOBxL
         QDhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789871861; x=1790476661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UMPCKFMy0q8dOtTAgKNYN+tQZo2X2/BEgITns70uQG8=;
        b=PF1ia34SP0bhkv+k5HIsfIg9Gqc7vXBfuTQozJvzhPz92Mi1W3SueLRdLjLokX9Hmn
         Yhdrf6mKg0t1y37L7M8DU62OYbo45rcwl9uvb3JEmXZZuKalgXdK3ZFknbMljbM+JRMt
         /OSZvrjCVbj0ydIOYtDvfKfuUja1r+qJDU1QZqQS0mud/lOdvHqK3tgcyaPMl0t/x/2F
         nkyR8XMMWu7sfTklnoYD8EM/Uw3COzcmli3BsiO38K0x7e6VUKgVQndfZ4eIPm64eM2A
         vH38zP7bQeiXGUjGFDe0LGPXK0qhSFY4DiMZ3kbGPmZK8mxp/t1GXrJ4UDUh+TsxZOkO
         5GQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTq4S4NdMPXFgCj2ZUdF4Ej90gfdDumFfzBRC2PtvyzRB2Hk3+jBTgecEMtiy07T6Q7Mz8JkRfDA==@kvack.org
X-Gm-Message-State: AFuF++klzfx3OsvxoM4F0OBjlXZ/u6/DxJzke4JbHC1b/xGtsUUPefZC
	xzk6Av0bXzO/4/upFVAJJQX34eF1LTm9/vuoZ+hOeUy7tnZaL+xT0ko=
X-Gm-Gg: AYBFou0F77317ZlddM1WDXCD7RWzcGBrja2kHfz6c/VYvfWpKtF/1cmxUksZMgk8+4r
	vTK3uKuuAjC+3GC9O+Kn3Z2kBwcXRoyPL44A1Lv2JHRlgnIXicxl8k8v40X2vvSh3/U0cIx1E4P
	H1eVUlhHPsZj/zF8J7ujdNiDUt1ESuiMFscHGnXuIDEaX2UBE2mFXiWYK+PooFZAudrFlVcdUNH
	kZye5YpKJWtuub9jqj1BjY+RY5kMKAY8h4u4HBZHg0A5aqdS67lKoVnAjkeM9LzCMSzXV3/79un
	pvG7+/PF+qdZHeSVRoPs89VQbXPM4sYRinav1cwF0yQZ/1KmQcLTODsrJ9V4CmSOkJFxqIZVOSH
	Kxoi2Zut8z1noh5gVFzfLxMPNtljpMR3OKBF7NNtuVcpn9876JSdajr26lpBRyu7MbvwX4okq+T
	63lFeL6eNF5FO53bMcdMV1Ol8kOwWrg9D8DZLM4pZY2pVAUor/lVo/AXNs/1UwEQgClvtaU7UVN
	x0W2in/Gn1/fLJgWhDyzC8037dTjM860GlT
X-Received: by 2002:a17:90b:554b:b0:39e:6c6a:6572 with SMTP id 98e67ed59e1d1-39e6c6a673fmr5097657a91.53.1789871860837;
        Sat, 19 Sep 2026 19:37:40 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([2001:2d8:7f00:8c85:36d8:54a:e0bc:3e5e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c8e7sm6799764a91.9.2026.09.19.19.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 19:37:39 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/damon/tests/core-kunit: test the temporal tuner's size quota conversion
Date: Sun, 20 Sep 2026 11:37:29 +0900
Message-ID: <20260920023730.2468388-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260919170154.86842-1-sj@kernel.org>
References: <20260919071324.1583280-3-donggeunyoo.kernel@gmail.com> <20260919170154.86842-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 129AF80005
X-Stat-Signature: bj5ou6dcti87ca7gjhmytzdqy9ccftdf
X-HE-Tag: 1789871861-933007
X-HE-Meta: U2FsdGVkX18J0OoCYgmW5siX4F2gvHqzhPftoDL3Pm/M9HnijKKTaE0fYlnq/ymiM2DbWcLX2aYfJNiistoSOXjfgcdq5PTwXJ9+Q2ncS9oXbKL50d6WSK06JbAgL4qWnM5pzyuntThxWx2RutZzmX11OP33xCr4Z/+6ioSkPxd3my84461XZI6HKwAnW4Vv6qLhkn/uIQ32aB9ywxdkId3u+/yiaxqIhjX0G/X44MAcej3ggZ0BrRHL3BxfxvW5qTyVO1QdIxrPup9ac4ENEPoQAh0cLXvyCbRoA+NQXX8hH8WSMqWXi0gmSDkzcog+D+rdDHpniDMrXg6/x7xCXdw6kpou5MX+6HrejVhgWfPv5j2iwwe+2NuvTuh9JhfLfyqxR999laPgXNgBkQM+9bKHo6qb/MZyRB/OnDD6Ear27HNl+3AwV+CIWfrGyP8sEI3ecevX7Dub4hMJcZY6hrOAd3SmlfUrkN3Gn1mxfqj8o2nyWykbU5a6/V9mWKXpUdO5RiAinxjE0xKE2Gt0dYaI3E98YJ+jYV88dgoYDLBF7Ez+c2P7tJEwBAmAbdmKaVX32z8z/vBNSG7Hp/vpGvqAinVVASszAFqXJbzNzGZEcyHrrKPlAzMJOiAJSWQa1BjU0D/7gWIWi6Yt1VkXgjyLYp+TZ1Yyr4Od57RbWXfiEdME17Xb9EiDf8bB6jwKV0V8A71eEy+KWcDuGE8Q+PR7Yb2rjaXRi9msKWIvqFeF8L+Ffg5Fkj6ROC/h33/358zO8EhXqIGEUr5EPwrCYTLoHQjSQeedIPa3Vzl4yGmb3uApsy3AGk43oJcBSuiZxXrZXKbK+XAf6FZXJdvAGONCsYfvolg9hSXP4rYY7aj2vrmXbdK+YC84KcUWedjM4Kuxe/Y/hkHgpD6lk3FbVcmqYfa5sdZe7mtjdDgJmQttkU5uITBn51nfNw6ITLHdl7xwIrg+0w75qgIKr7U
 /LWU8uLK
 fsfkWxuiwJL+aIhFOuSKtV9Vj/j3q36dx1S+lmuj1MMDcvHq2oux4m+6iqRspiJ4MGO+vzMbqBSa1/DK5Ww+GhGuxtNfxdrNoMg9EiepIJDPQoFKI1sgLgW7XJwU3RMxSeblLiQF59JaHbicXJQBVyR+7vOQcCLS3MVpXDFUSrmq3G6hGR6T7P2OS8DNwzL7nUnaKpla+TWAsy8RrS1SPvsjDTQs6YVTT+lT8sUg8gNW3ZqsHrjUse5BDZQE6bYYssH8+5/FwLCxltewmVHkXt4Yjtg46t1xY1RQfilgv8ttJEX0uykg3/agRtlXn5J8zUljC8gJB6JKjtd0dQKgsBxqRQy+nre2NzCYtuC+7/08dSF4VGZbDBpFE++B6S621QM4Xva+HmwghqAJ8+hftHySERhbAu+iBpVB7pY+j7O3696FW0VxAq0RoTyMXwRTBgBLlO7kvKgPI2uivIqGlLjWKETzT5ATi26ymDenLshRmOne1gUJzJhMhP/KPWVlPCQGreUhmx25777Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you.  All three applied in v2: damon_new_scheme() for the scheme,
damos_new_quota_goal() with damos_add_quota_goal() for the goal, and
ULONG_MAX / 10000 written out in place of max_sz -- the name really was
confusing.

  https://lore.kernel.org/damon/20260920023111.2466265-3-donggeunyoo.kernel@gmail.com/

Thanks,
Donggeun

