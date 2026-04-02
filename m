Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180EDCC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772086B0088; Thu,  2 Apr 2026 01:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723326B0089; Thu,  2 Apr 2026 01:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639876B008A; Thu,  2 Apr 2026 01:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5579E6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:41:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5EFE1B7F5E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:41:12 +0000 (UTC)
X-FDA: 84612517584.07.158395E
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 02A321C0006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:41:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdK3m4Fd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775108471; a=rsa-sha256;
	cv=none;
	b=slApJBLKDDMo4iQEJDWrMbh8HIV7BBIb74EPuOleIFpOIgM2xuFNq13ty0DzEcDKUYRQeq
	rSIpxoM0/Oqj21NtylXAAH2JJlEOePmRuWHxKj/hJwZF+7kuY1s9cs+DBf1rPl49JJRNVU
	hxrvlZdtK1G8ePoVihDPo/8T+zDg/x4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IdK3m4Fd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775108471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dAMd7Am3UKqsECdn5Mtl/PD52Ug27urnzze2wv5G+e0=;
	b=HLkvezJuSHShFpUMk390SPDMm/6oF6VrBNNKdJOQ7/95ygPR76Chr9bMf/gL7p8XCH1yBE
	rEzS+mXZAYVcfrbI+ZPZXjLTlaw2ZLxQ84cyYil03fwhaexqY84UwyDtwgGNek19jKyXtn
	WQ9x4Ir8JF+SYC7+hNkgZlDrpeNo6Sw=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50b266413fbso4574181cf.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775108470; x=1775713270; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAMd7Am3UKqsECdn5Mtl/PD52Ug27urnzze2wv5G+e0=;
        b=IdK3m4FdJDhVtMaGF/o18P97+PGKp7sRNI5zom9IT1H/97M9dYkO5zgWb0J6a9NSe/
         Kr/aWvmG/0zHfa2UIPj49Ur1nmoX7ftxtKP/8bE81arY/Lh5d8eXYsGRjMgWstCQfxXv
         g/VfZboVj0jdyHg4WjaXkmYRoxo9QPloiiZjAThrEc4iey2akkP6plOO0iS1wEGSapiq
         FySKE57QSjTnLQ/DQBazEiQX0TXt/Q2C3S1zBTDqlRzhUilZE2K+uQFRrmnZ3A598G+c
         guuQOHSo6A+PkcRSu5BVpyAn3jCdBpEs1/jk5g3PpZC8H77J58Nz+yAtdyQ43roGuvbD
         0xsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775108470; x=1775713270;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dAMd7Am3UKqsECdn5Mtl/PD52Ug27urnzze2wv5G+e0=;
        b=jY65CqGbKiHIxgZnd9NGJQ2qYa3BA4VhtmkJC264nAZcAW+kemmIQKc/75NTn3XQhu
         2pAlQn1JzwtZZHL17K5Xw+Eb2dRQQvCSeuZa4/xNjUh4EXoAo+E7OlI4OxWV+tNEYEYH
         V/clFtUc40H5dkK4HeJo13kVi5C1FsV8iK7d08FNSjYjVBwXk0Yot9zi3INID0NIsKge
         66O7oJvGuQZXF+inlD8v76exEx+NLKD9hMBh8KnNHoyahnTbRHF0VT8IedXpiZ8Rndzl
         B4p85vuCFTXdMQlQx/kopZpgySwWIUABqo31GTTF2nEX+LwcbJNQYRLy7DGqq5HJZScS
         8nZg==
X-Forwarded-Encrypted: i=1; AJvYcCXmHMr8dpjryOdggKFDpXfLFpurrEwUD1YxwDMULCwnwGkjgn5rrj18HPZTon9ralfPIY31VDVtKw==@kvack.org
X-Gm-Message-State: AOJu0YxP9gU3d0lSAcQsnLFViMzPCYxoH5pOCYcGeYl4KmQImt1lA8CR
	qCp2I9vHOuL4yd1IQeY9m1siW1mxoPd+fyFQk/dbdE7uDOvfnGyqy9KOSjPl1g==
X-Gm-Gg: ATEYQzyqCtn8uZCzzahFsir9msT9h5D71OfR/RuzSSZPMYJywOpvY1A1IFg0Pk6Wgxk
	tsAY7voNk4+Z1AnBtzSms/ggbXBD0XBtDvSZ1XqWBq6Gf1RPaOif/NBlXJU+D5vE354Hichig4w
	s8BJYGemq7W1ESW+hAgb81hTQG9bUzJNn78YzGIKhmf6Nc0LSdG3UDDOWknDXCQZQHb8oo2m8u2
	zoA+EY7r0cf/9jgP6euHs1BySRlaWRXu4ScEv6xaZmnXtE7ToiU2C8Wt5T8mpylEAtysaDl3G+f
	4iOUUmE1qg86NYJKTfi1TqCqJRS0Mj6mApePkuyjzoBSoaeNFUxh3TjTw0dEmkRd3kxRUJn61Dd
	C8FqeVI8R+Clj/IENwjqTF6510vv6mewRru6ACqPYN/KVD2vWHZZJl/F8CYT+qMICEkvX3++Ggl
	Gb4YnuHry1xXf+HvdZ0VVJ6HVbotX2/GuNrwRY/5du2zg60Zi2cdA=
X-Received: by 2002:a17:903:1250:b0:2b0:60f1:de58 with SMTP id d9443c01a7336-2b275dc23b8mr19612315ad.45.1775108098179;
        Wed, 01 Apr 2026 22:34:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477a13dsm15917055ad.26.2026.04.01.22.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 22:34:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Thu,  2 Apr 2026 13:34:58 +0800
Message-ID: <20260402053458.26524-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401154119.67874-1-sj@kernel.org>
References: <20260401154119.67874-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ap9mi45qy1hn1kkfhdb74c17hmttaxtj
X-Rspamd-Queue-Id: 02A321C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775108470-326759
X-HE-Meta: U2FsdGVkX19nc8iRsW/rcKtRiLE4+r7rTlq52Ahr8NJ5xnDN6JNdATDF6m7L7IPcaQDkHkMclThIP8gGyiUQ0/47yZOESFwzRoeJ106X3RSk72r8V5PALpQZ98/03EoLw8kXvjp3uyOKxPbpX2JLprxu3SRPUUVw98yXFAXc+cI4LEGVfrvjd0J7sdZ5SNQ2xdF2Y9hWpqpIZ3MtJgt4MsbpGsDhWO0pC+8oQUAtLl59Yf74qm6mVlEyoHwzBD/Ls856/GD/QPPAAv5VPFFG0PH4VXR6l7GzZrxcwJeKjJLHD9b2ZfOjGtyaNN/1SXcL6bn55rqQf43WcW44eFkTvD63nZdvAFEvBoLcZ8odF2FE6RkaLNAS880A2QdQo8TsSg+UBK9z6S0SDsoeQdoQ4ADjIKEDIiylB+Rb5PR3bitxjwlk4Ge5pqqZIr2CXm5fS5ybSNybe+QVKZdCWdDY/6USkLNRZ1ofFVB5C8apkbs2y9appXqNax0tnC+EJuiJPEESHi1YiSC8dD916TVFG4GYotj3rbzty3iRQXCSY3WynPGH9nY0jNOtxS5D4z5XyyCIh2G/77G0kjU7Wt+s2QAam6Wn83xV00GkayfFMgTV+JdEmzBW5n7eOGbac/Ay9lPHLVSWLeB8bDXRr46JJ/E48OwSBYPY5jU5AFFsq0gsd+IhY3k9m536wUloLEJ5qdX2E8iE1bVlGuNLUmsaQKsfXVxc4gUoEF00uUr+yzEbp6Um7Ef686WKtk9vWQ5xMmi2YztChkThxSbRlddVxjjIo8W+XSzPkM2DcK/y/oS6WJ+xhmkmMADwvSrPrkqHTwco1JRAxL2f/WBdvLo+2kKRsnz7XVLk/+bNiGGQyFmYfOmMbuK7UmpUzz4YALt9R01P0VtjY6nh3fNHdtbpgr+jBETE+UweY2jTbc3ei+p3kuHCV7OVpdcMA5Xa9/I4MtEVZy0Unwx0WEKMQvt
 3nBvIQ3v
 AmozL/gQCDj8xc5IFqYxPUKwbdYvK+ESvx2fb4OOrUskHUj6XgX+CEQZ79KF0kbsguttEksp6affWEG36qnGm16Vy7iJcjMCTo+t468Soov6meGJDeZnRbwSbv8o/h1ju0aCJU/yJI+tShnWedftVx5pVYAf7SzxxVtP96dWizvERHIyK4FVHY4IzUvKmifUnL3pzeIsBUrzb4vBURu1aqHVQhNQ3yZKgmGbjDTWN8NJ/ba2TzLcUMKK+W1N8ge1MKpyNdCL0xe9SaMd44UJx7mqgyIKZAj1nXG/TETK+63DZJPMF2vQQA8Cbx9YjAX8/o5Az/a2zkQqM1+H4lp18uGw0uvmwr0ym9LA1uim0tZnt/sZQFm0hIEUqg8ZC/KEV8dt40pomc3hxgI/iAG3MUGdo9MqLKg3kys04WiSBLAACqMUrSYU4z6JBeSaq5d5zdmGmPhCd3f2NtoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On Wed,  1 Apr 2026 08:41:18 -0700 SeongJae Park <sj@kernel.org> wrote:

> [...]
> What about checking if damon_call() and damon_commit_ctx() failures via therir
> return value?  It seems damon_call() fails only when kdamond goes to the
> termination path.  damon_commit_ctx() failure always causes the kdamond be
> terminated.  So if I didn't miss something that could be a path forward.  What
> do you think?

Thank you for the suggestion. I looked into the code and I think
focusing on damon_commit_ctx() failures makes sense.

Specifically, damon_call() is only used in the damon_{lru_sort, reclaim}
_enabled_store() path, which doesn't trigger unexpected termination. The
main risk comes from 'commit_inputs', which calls damon_{lru_sort,
reclaim}_apply_parameters() . When damon_commit_ctx() fails there, it
reliably indicates that kdamond is terminating.

My plan is to add the error check directly in apply_parameters(), right
after damon_commit_ctx():

    err = damon_commit_ctx(ctx, param_ctx);
    if (err) {
        enabled = false;
        kdamond_pid = -1;
    }

This covers the reproducible case (addr_unit=3 + commit_inputs=Y).

For truly unexpected termination (e.g., memory allocation failure inside
kdamond), I'm considering a fallback mechanism in enabled_store():

- When the user writes 'N' to 'enabled', if damon_stop() fails but
  kdamond is actually terminated, we reset enabled and kdamond_pid.

- When the user writes 'Y' to 'enabled', if enabled is already 'Y' but
  kdamond is terminated, we treat this as a restart request.

This way, even if kdamond terminates unexpectedly, the next user
interaction will recover the state automatically.

Does this approach sound reasonable?

Best regards,
Rui Yan

