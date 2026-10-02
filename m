Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7737CCA5FD6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 538C36B0095; Thu,  1 Oct 2026 21:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2216B0096; Thu,  1 Oct 2026 21:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CEC6B0098; Thu,  1 Oct 2026 21:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F10996B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:27:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EC38A74A8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:27:46 +0000 (UTC)
X-FDA: 85275949332.20.64762E0
Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 859501C0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:27:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llEa3UTY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790904464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1LgAfbPm7WCVCr/kTVFseOyGOKs9AYLzlq2Y3Kfm6E=;
	b=qEg97bwK3n6KdPIHjz+NQlMOfbrjVQ90nojHhe+z0lG/SVxknL743Z4ylaEheesGaVFwgz
	3JY++9zj6KZfTfzh4wGndfP0GDMqyayPgtxKNuBq6bGAcEqHun0VNcdpVEFLElDFPtSH8H
	0pb2zbls90vgF1NysBZGUx+xZbVYbIE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=llEa3UTY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.229.43 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790904464;
	b=TwBTkeeQuQprZNt6d9CY/LgqCZ2mTlTCoSn+lpIhkZuPwLRvTFQEksSgCTCxD4wKMJEnP0
	iVxRyC+zkXMfGYCSppvZRVk6bGeUODoMLp6gmODFvXJ1v/RLYuTiNyWoimtPyUh1WfQTaw
	5Xr/t3tURYGm1I2ulTJhpLQ5Etk2T4c=
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34b223602d7so2787153eec.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 18:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790904463; x=1791509263; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y1LgAfbPm7WCVCr/kTVFseOyGOKs9AYLzlq2Y3Kfm6E=;
        b=llEa3UTYxAX3jqpuX3a4loE+nhN6/vfP6dqvXXULSyNH3mI+WvmAFg2qf7bEYf2SZE
         CrATlttHoFjsR78b/6eAHC/vZ6t375oicWNGqpaDBub3TTAW5+5U6/xXGeERiLV9WVuG
         jhkaBvtmcZmJfzJTq6f/vnoggJOl2Sh1DltWtwBKmS/vS4wIEl2fnUlxkzPII5/WA13Z
         DTVxUXe3do9PnAYKJs3moQ4mEzrC8v3owc7xvYou6A96RLz6MFg6wL5sI6yRONmEaKxw
         tnPLoIJzuMVbEpx+j2DDJLYq4fyAs4iCnou7AAQB8cqsMTvYo81lOLtbT1MhaeJjvyog
         fP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790904463; x=1791509263;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y1LgAfbPm7WCVCr/kTVFseOyGOKs9AYLzlq2Y3Kfm6E=;
        b=WWYSjuJIGV8ew3eW2bxudNv2OnlcqGk6rzo6hRskj2mjc6NmeioB7sNtDqmJzRagg2
         C9DUig8FsTq3xSXg4+0OIzhjW8BC/2Gd2HVzoJ3tUYNWbGoxA8+dJseC2MjEQjUlv45B
         f+TnPiiARJR+9HC3rA5dpQTHyKcr8JS/XX96YvGVp9yS9PPfZ37aXhLjsmSHNUl7XPbG
         9pji+4gKLkB8WS3kgILoqC5E1p+d0Qy8j9kdOV6xWMz2Al7fEHcUbFETL8oNji1AIIYh
         O2mXvg1F0f2PBUuyHTebF9v75yuUa7HpWXGQTJy43EdsYvZNqsDXWIaDDX/rq9YxTUQm
         pikA==
X-Forwarded-Encrypted: i=1; AKwUvBwRR+KLzZb/bpOnI4LMexiXEqgBsFcp0YGwrOBDURq4S/8g+DZo+6K0J/H+VRSuaBjTQn+z/vr2tw==@kvack.org
X-Gm-Message-State: AFq9FYL6OEOsCcETju/lWbW0+uvJ1G2tX4iKnsCGHvK2ZKwiG8pS9B23
	3/XXsUK3W2ygyFHerJR3k6fSQ6yG28bJU8fGFB322YXa2xIdw+Tt2qJ/
X-Gm-Gg: AYBFou1SfI03jxbewFLTOP4K4vL2wghxjMJB+R4gtUS5sYuhkjjDwBL0alp/k3ftjK0
	yi/qnbX4QgwXEAeAHKaR3kCXzEdazTQMln2O0Cx4G8caYEyi3zvg8SNvv1BsVjBGZ69yIrX5tiI
	VwtiBlbBFe3Avz3/1y+sE69G12jrJ/DsnPXwHRrnGK6un2RhpQb7d6S6Liq2M1Pgf8UME8Z4Rxi
	4UQaXwEZNA17UExfbDYEfPQW9X8t054sGvXMczbiVHcgSaUbB/1BH/abG7Ba1N1UmJsTls1ThJy
	f9r3i791GjkhBOp3672/yyLtosVJwKGjV2j1o6kiCwupzFzbUg5yweLmvhqqxzhex17rjn+LvF7
	umwfci7MlrqkLtXsEv2/JcPBkXwj5zU6MEZl/57EmH+48wpWdzKM5f7y2K/E0Q7BXFksdofnPoi
	qjRV+CvgzwvQAKsPIxxC9whuIa8pS1jbZ4vbGqvsoe+zR9fWZMfe85mn2+vJROig==
X-Received: by 2002:a05:7300:3a97:b0:34d:755b:d60b with SMTP id 5a478bee46e88-34f2199dfaamr1174327eec.34.1790904463269;
        Thu, 01 Oct 2026 18:27:43 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f2dfbbsm1942238eec.10.2026.10.01.18.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 18:27:42 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: look up consecutive pages together in do_pages_stat_array()
Date: Fri,  2 Oct 2026 09:27:37 +0800
Message-ID: <20261002012737.149491-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <4CCA725B-9CFE-4ADF-AE8A-59D6ECA4321F@nvidia.com>
References: <20261001-bug-mm-move-pages-stat-batch-v1-1-255b7e915744@gmail.com> <4CCA725B-9CFE-4ADF-AE8A-59D6ECA4321F@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: feicx8udmqayekmnzsca7cd97s5nq5kq
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 859501C0004
X-HE-Tag: 1790904464-917213
X-HE-Meta: U2FsdGVkX1+J/bnIqUu6ISuvWUoCK2tI8pWz74cxmIBHpVKdlrJ54vjPOGqCiDRBDGDwInKhduTgqPxo0TtVchtO/oBKPJ4LBgJHv4M6FrL0kOnKD3nSIk+G44M0C9XenGrwnJ85QDYKv+xvxb+f7lIcM2PScVqOpnr+kHPeLfic3ayFuIuMszNnaHIlqGBb+IlxoNcb7vFuS16a7wMbq+UIdyHDOQtDDXEyrGE+hzXcBp35vHK7iEsad5ExVqDIorLTW9Jb1l2MFeXFKyJaptkGtg6gMoy9/4OhYp5PIUV6EWszsT+oFvklEQLRp6EJVyAZy5SiHnAxEPLv3Sg+Iq5l0yYiUrhFjb0VD5WE/5jlB8cZP5DDTsD4NV4XKUPM19W6oYYeeM/OPVBIvPwwbZf0/Sg+D5Mh3y8IWYhAm3w8Sj/3YEF+OUW84I901RrQ1acgOkhmJWxCg+/Bel1RxjUuboFzYAUzmaKgnTtI8e3U0fmzlB6EbclWpyZjIC66w+1Ual40s76fOe6tyHNf6o4rhev4QUIUpOk8WFA3qzTqKX8lFhKf/hs/pX5Tfpw5Fow9qpPBhEppV01Ft+ciKhhe34zJtH5zH8V9fukSxlDZI1am2v6ORV3/eufuqJoW247UCmh1gXPfGE84Ycgunr8abz6VBPcpMdFlojHA3fxiBJq5TTv+HnOWFzkVlupFtdTjcq62czxXf70p3bSH2cmpCs5dFcez6xic/9gYgKIUNWIyt3c7Bn/thw6Lrb5wP7F2O9Mw5CnWomPN1LbO7JdvTLXH26O+fZm0+Iq5isrPe/WoyPZ6gRvQFau5+uJep1aAVJFjW99+W7SQidIQcCasdns+9JP9BXaMILw98ReOu2rnpArtOODDnfSQ/z7CMENQs6ZJVIyu/LP0GDJJg2eeRR2Nz4QRgwAroYqbre/g0dwDIOaB7lgEZZUwCWDQGs4EkoDFrmficZ6RqzD
 LaVR9EGE
 S8g8EPM7IpuAsKw4WZAoAhl4iItBZ4KLF68Uzmaf4bhK7cpRu1dZ0obCcdsMz6vH2c8WIWoRxQeEVdGvgfLzbSK8ZFIvch2h418pRZj7h7ygEyTLfthsVItF3R1WyHFbQLTfJ6GoZ0nTFvqcMKIGUWYddFhn3WtmSyJPoJ/7rJ2QEUuHhPXS2TaHmC7p4WslZoJf3MIepYSFvGROZWL3vz0830C0GU71btALEndGoFThtSg4RwK/AcbEO3IouMZD/7EoA534EWAdHTT5sYmgbqlIqIx7scRjh/RByQHCWtM56kYSUyvvDyUtMZNQ5Q6XzneHQqBmN7AoWdXkosI43alXVrew1TjrqwoGauIbO0UPmimx6J5XTRlVqDFtxabxEatkQu+8DMdsjyDs5pWClt4bBw+mf7+pEELL3SVcQwEUga/47PKGBNypwBZzmRJge73VNf6xFxEDzL1Vo+MQOR7ISIw/3BuHw2D4pLMgOxFbMLSDab8jJybDvmYnLiyc94FtAXU8a6uiAAgPYWG282bZHoBu0t+w5/TF5OWpn/LDxqdLMOszR0jqXhDEt75kXpkvRyUi5BcJywzJnYQHmfyE+fH5nKYJHmoI0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2026, at 11:37, Zi Yan wrote:
> Instead of adding customized batched walk code, it might be better to use
> walk_page_range() + pmd_entry callback. See mincore_pte_range() for
> reference.

Thanks, v2 does that, with pud_entry and hugetlb_entry callbacks so the
walk doesn't split PUD or hugetlb leaves.

> BTW, DO_PAGES_STAT_CHUNK_NR is limited at 16, so the batching benefit
> comes from 16 pages instead of 512 pages in one PMD? I wonder if that
> limit could be raised and how much more benefit we will see.

Yes. With runs walked in one go, the walk setup paid every 16 pages
dominates. Per page, querying a populated 4 GiB buffer:

                16        64        256       512       1024
  4K pages      31.9 ns   15.0 ns   11.8 ns   11.2 ns   10.9 ns
  THP           23.1 ns   6.6 ns    2.5 ns    1.8 ns    1.6 ns

v2 raises the chunk to 512 in a separate patch, which also allocates
the arrays instead of keeping 6 KiB on the stack:

https://lore.kernel.org/r/20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com

Qiliang

