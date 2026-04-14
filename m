Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4C0F45A1C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FD86B008A; Tue, 14 Apr 2026 01:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100BE6B0092; Tue, 14 Apr 2026 01:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32336B0093; Tue, 14 Apr 2026 01:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF5186B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:50:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 759B758B17
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:50:50 +0000 (UTC)
X-FDA: 84656087460.22.E67C118
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94B64100003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:50:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M334A8ut;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776145848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RsXRCxDWNuKNcN/qQJzlr/9TFqUsZZ7ZspThUwaXJE=;
	b=DAvSda1+qFhBSu8kghGRZ4Vl5ETCFrc52REIQoA96wfDIpJqvZ84WfPjMmfNRzt+Gg5DRP
	AGUPvgxNDvghqQssioT13SX2vKwYr9GdtLHP802/b+9puLiwqg0kIRfOL74QAUAtILB5jh
	IxiBwfohFiv/cTI/xcSjz5KEbp9FRHA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M334A8ut;
	spf=pass (imf05.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776145848; a=rsa-sha256;
	cv=none;
	b=7Mn8srP6skxNo/VLZ+sAOJKYBLgWtyqxIwohN7zBKV1/NdM5V/uvXCh8Q9aFOBLQYySWdg
	Nlz0ZlHN7YDNKW5YgHouUSQw1fBVF9AwhMFnyI25PjS3n3Q+a2dS99SbULUV4mL0ul1aHx
	q6iyssRLtlTDz+WGH16/HvlEWwOmXCQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad2b375e58so3481455ad.3
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776145847; x=1776750647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3RsXRCxDWNuKNcN/qQJzlr/9TFqUsZZ7ZspThUwaXJE=;
        b=M334A8utwaaOpLi3tm3Tuw2PQ665TKjponF/YJC1nPuv/9qnYv4xntDsujPisPJV1S
         OraChnR6xLt2gaZq47jiI7FhNUS54d+YNXwJ9AMrpKR46/CjV1TtyhI6PxOm5owevowJ
         PcnwfLSAcefaoGWRdkqBJu8z6nyt9EPk6qAWDx8CLW8Vc0x5THO2b7CMhYh5P+l7jcYe
         2BmisNfJOi1XddoN2r07M6Bz0gHT5zvTWu2qf079uQqEkuJ1yH3gn7m5F3ci7CIEaE3K
         juLyJiBVeBGydJs/cdDiKHQLJUT8MNzwiNg2hJrYZO9nRHe3lKUoO1CDlm1IB0xxcg6v
         AiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776145847; x=1776750647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3RsXRCxDWNuKNcN/qQJzlr/9TFqUsZZ7ZspThUwaXJE=;
        b=BU92yynbRsTNQak6XARF+Pswc3K0wmSoZWCNC8+bnirDWwQCZDwBYOpFKAU4KP3mu/
         B98Vwa74BnAeH5tDHmLn9U66XQe3f3l3omzN7kLda7/cTozVnzqeTk1ybualKQrQLlJR
         5c4XkzZC0/7kT/tKCrRhDTru+vk8cKGZ7AjOdl0dTVL0hahF7AgH59naGz9gC/S11QZJ
         bg50SVh2OEs4vdZncxAC1RL18QLYkazgzfPLObQGTCH4kSCYj6y/OJeIb+OugXiap/yf
         tijXuM8mBAZiDhxVdWTGNADDNnlCX4r31kSM3oVD1NDHBnT6U/+4AD3JvxgYn88DWYy9
         jQMg==
X-Forwarded-Encrypted: i=1; AFNElJ/AZ3XpLlIduuyZG3WH63AAmOhXLZaNaOQg0B9rlDThTJN/bDYdq7/IYgL4Pa7qIhtFo+XSYbaITw==@kvack.org
X-Gm-Message-State: AOJu0YysqEk9Znf+/JjMChKcqU3mufCguh4x9gmYANX0wHmsIwRy6LkX
	zSzfAK6dthreOMZGEyWVfYvRDXt02kYGJuSc9XRLF2yqB+WJFd+oQs63
X-Gm-Gg: AeBDievb1I3Es3ePf2i/kUtqDOn/hm7VXOFHWtqG9G4aRC4rQ6s+bOdXxb9foZueGY6
	/VttM9p3SSUq700HQSECgIT2L9jSqu4s870L9lc1CB8gdbzEVe0oIQ/14GAAvFYh3F1jpWTpqgC
	HxjbtFsRx35hdGJ5psvbQPbmUcNr233jNMB8gNA45FmWtIsEw+PQvpVP3NPq+FZtBk4wJqd2Fqg
	EpFj5mjO6SrAddgJBXOru/ptudrcJYwhkO6PA6+qzU4d4Sr32KzaitHzhTG3eT4V+lRRO1PrX9g
	CJaMaW8gXFeKoULYDJpnUEOKX0j+wsJylBMcTOhhv5f58byhw4//6cXs6+7YyvWYZqm48t9bGdH
	5IEdw8I34X54kITy2L1VcQK8lYgeA0oLt+DDNeau8SV5hOeGC5XDD35bCovrtjH26J21Y9kLhzH
	aK5aA/gsaTgV+pjWQLEzyVV9WE7sJ6fovDQmNC1Yki1d3XrPdpRj83peEeBfT+aShgsaLC3ZrTP
	22EbjS3IA4qOHYkDMUCSxk=
X-Received: by 2002:a17:90b:164b:b0:35f:b2ee:6c6 with SMTP id 98e67ed59e1d1-35fb2ee10f8mr4978583a91.3.1776145846633;
        Mon, 13 Apr 2026 22:50:46 -0700 (PDT)
Received: from fedora ([38.244.149.186])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fc6e61455sm789761a91.8.2026.04.13.22.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 22:50:45 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: ryncsn@gmail.com
Cc: baohua@kernel.org,
	minchan@kernel.org,
	senozhatsky@chromium.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	chrisl@kernel.org,
	justinjiang@vivo.com,
	liulei.rjpt@vivo.com,
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH] zram: support asynchronous GC for lazy slot freeing
Date: Tue, 14 Apr 2026 13:49:30 +0800
Message-ID: <20260414054930.225853-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <adt3Q_SRToF6fb3W@KASONG-MC4>
References: <adt3Q_SRToF6fb3W@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g4u7ogz63tfyx7zmnb4a4o31thmoxbfx
X-Rspamd-Queue-Id: 94B64100003
X-Rspamd-Server: rspam09
X-HE-Tag: 1776145848-332395
X-HE-Meta: U2FsdGVkX1/Lx7jYRzOjo5qGzaNf6mQp19AmGu8lhh0s4WniZ22iiAQYD0dYkktlHOLBJI9Tp5KFS1suT98wwbjOXt5ITXgMVZd3/lseyQ/+KDP9ZFIYpT/LczyFEW+zqEBU+krTEVfNqmz9RmQ3835L13aKCAl8YZK7135tV6pb30Sjlb7syZuyBC5monroxQ1H16TD1VN5NrOW4GO8jsxZkbFTvA+k/lSf8490CqL0fG88yAF+6VnjlgBr/aM57njU6OkuZ7Ih3rvXg3rEoNnq9Nu2OZlpIKkJ6/j1M6v7lMTJ19DoItcWA1GdB/t55lF1jPzWJ+tt4fS6F/ndBOH+D54KeMXCF//bNiNobFyHMoN3Rlrg/DInwpnU+SCgK7xESJpvGY4Vn9IsAZbw7a7DigsdbHL2fd3z0I4FgJPeqCFAMzpZ0tjDXbd9+4tvUjN86jwYrEZqNGC8HOFSfPRlMa41OMgARAhGkQWyjWzjAQp17kX9OGc01RGVWasseyXwam9Mn1YBIraaeMyI97ttFkpLIDjj5zl9YPxQQjs53Jrl2vQKQPltXVJDkWY3wtFH6xs38I+E/Gdl8ZnlzjVjk28jUkAvADNZtMl3s3dlGjdgGdizLpfE1jSiLxNOr/HoEKSXl5968TADyrkZWG/RgESiRXRz239GzhxSf492IxXscmxmvez1I+lbsuGL6tSNxXlaOjuv5LXsofgIkJsXWPOoHMz86KqwwrKkbkDdac898NrR5au79UgEJi3nUhuVUdkbuzVldcWJkbiCrmdUj+R9zwbxkLKdJEPN2JrGnt2cECxUvABD/HnGBJMRp/qD50sj2AbB2Bp9ZI+rr14dEFqe8gTuQmZd9weBGZbcmV8RsLyuYPkvnWfPh/Ht/k4g+gRt4JC3oy3HEcAr3gJy5GaNEvYOV45/huvYjPznKRP2VIax26sN6P1fJPE+7lsxugnZt9z3RRSFpvu
 SX3zRJFK
 K/vXwrjoyYusDmprat4apH89ykVRVg43skbD0D+gxW4wHn2ajkl0F95JlwqviDyUKXiVvxa04cpSSd0/sD6beiHC6VGfApmojEyfOB+HYqwCWDzdMziei2alP66bo7XJyHstuII0Lc1LKgAfSiUbG4msjaRWd+tDolxvSlox01ZYcwxEFMtoB4ZqX0OuoPX39RIyz3qOye0iucQSz6lgmzkCueMJ0FOXV6AUvF5SxSkRz5S9wWnnQki5CVABq8TBO+KYobG3dWx3HHyedyaTRoQOvj04zupBDQNnZeNqih//QiIvrHc5knIaGinq59g2ChWFumPUfTwPR1a7o0I4yha5wC6Xm8KEFywAGW9xaPfYq+brqXr08HpQGPZ7lcI1YeISGGmYXBBdsa1ohKZMCzOamYTcYnoYs3LzVqiY0HqCzESjORyzlMV4ug7Wh1cjgihUdoeQdeyBzIDGhUhQ1GELARoZwz3WFvAnh7SXaqK01dzd03p7N4pgt7E9x+G/2Ogjn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Apr 12, 2026 at 07:48:48PM +0800, Kairui Song wrote:
[...]
>What is making this slot_free so costly? zs_free?

Yes, I've captured some perf data on RK3588 cpu2: 

  -    3.79%     0.42%  zram  [zram]  [k] slot_free
     - 89.04% slot_free
        - 65.40% zs_free
           + 77.29% free_zspage
           + 21.75% kmem_cache_free
             0.68% __kern_my_cpu_offset
        + 13.19% _raw_spin_unlock
        + 4.86% _raw_read_unlock
          4.75% obj_free
        + 4.72% _raw_read_lock
          3.64% fix_fullness_group
        + 2.02% _raw_spin_lock
        + 1.31% kmem_cache_free

It's clear that zs_free is the primary hotspot, accounting for ~65.40%
of the total slot_free cycles. Beyond that, have some read and spin lock
in slot_free.

--
Thanks,
Xueyuan

