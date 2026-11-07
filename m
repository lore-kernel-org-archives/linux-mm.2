Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1574A606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0Myefhpn
Received: by kanga.kvack.org (Postfix)
	id 1B1B86B05B0; Sat,  7 Nov 2026 05:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189A36B05B1; Sat,  7 Nov 2026 05:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F9D6B05B2; Sat,  7 Nov 2026 05:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7F826B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:09:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26AAAC02C6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:09:59 +0000 (UTC)
X-FDA: 85407902118.04.E0BA5AA
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5DE111A0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:09:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Myefhpn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794046197;
	b=swo6FWvlp3eXT/pSlPgd/B2XSc9pXfXChGU10DhSkH6/2yh8la9PMO/ygWnzKRoVvRr3Ow
	hADvWxzKCkeZVAYv5f3IDnHv8LbyLPJJzk3mVkVbledkqz4cMYwkWPAFK+JRmGuD8qDCQq
	HwJ7iaQTJyM7MTL5eWDs71/ZfiWa7G8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794046197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nf4toMamz5HmACg2rAr+6wL9RYerDTJYC9sj2VukDXA=;
	b=H3tvGiiulJVAFcef5z47h+mCOC+wbC/iL0RHBRxvZou572JXjMZFdmqgV3kWUds1bWbZtg
	9HhSb3A/0PFnRlBuTsKEK7jUQYqydWGqF/5RhuiXpwmSSAoDev5UzGXrXCv4Bq+cyBTXTo
	vj3DCq/y19sTWjpPU+ZFLcQDdWpBTvA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0Myefhpn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3ae1d0caaedso670475a91.2
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 02:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794046196; x=1794650996; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nf4toMamz5HmACg2rAr+6wL9RYerDTJYC9sj2VukDXA=;
        b=0MyefhpntfxOaeAdIMNY8S5Qyzfr+5bSs4ijoBUafHSKMrgsSJJ+4Vyl3E+GkIZEOr
         Naj4WO4vq7PrpOdX7UzI2YjqMzIV7VaTbU2YWUnXvgVN/KYufCnJFbmSES4br9w7Q0F1
         7Sk0kAgKQl8vPwLGgZSVem7bo8KH0DP+U7zuwuLPK3EncPHGpGRYqbmX/Bjx5APJ572d
         dDMcjHnLvytlyZlUyJAsKnwa+Mto+2LSUNVu70UNSFK3NiktPFcrOgNc39Mt9M45nJj2
         NTow2kk6kvuxfFeCzRDVqL79tM9ztUO3A/+yj/mYUaeIb6lRiZXbDkiRmrfzIqhZXE5t
         Ey7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794046196; x=1794650996;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nf4toMamz5HmACg2rAr+6wL9RYerDTJYC9sj2VukDXA=;
        b=vyL3wKrvR4Iftixyx2G21NCNn+iGP7/PTXFUcZ+2LwO6eCm6Ki2FJLwUcRnLGTsAyp
         UIOgoe8RbQzx+8AxyopaE7GW8VwWSmVzFsqf3zpyvZGSDpFs3uHZ2aGyil7msh0/lI82
         suYrwE8I9U5C9T8IswogMB0S1cyJI+hmLH0pgoLh55oGE8MHNv+XrMxLSLDsl8R55sJy
         uA2MFUEb7xmyFaiCyBVgqLRRA7j7HIOW2JlmOXhWFWx7t+O7gvlxK8lSq/S0Pay2ganZ
         aYPhVgpr6Ib2pOX9x18A9HJn59wuF4f+LUj+kgqZaW/aMgSlb8rCIjqD7SBEksY0/uSc
         2MCw==
X-Gm-Message-State: APuU4Z/IRKp51sQU2IPjZQKYnrZGMPmEcN8wvMbm0NR5yTWDftiUp91B
	j8xXVT8zxpl4khg+j+mmzqZZ/GqYNf5GCHUdQG4sDqDSVUDYMn9/iqJ2Jn4iyQ==
X-Gm-Gg: AYBFou0ZgB/f+NJNEim2PIFOzEeXFgKQUqqlrigKcs+nA5ALlJZqCpMEi4ElDlD0BB5
	XmDw5QUmDlM7j/vEh75WJTGCgMdcrM19DqHk5fqOsDcGfUkjT2aKRr5werutVX1iJ7/cb4OZJt+
	0r31EzlNK7AE4DNV4V8xmwyVVV1vcHCIaq0ZzzDJRLgZBglMQR/UTvKUX5paS36jXDVOOXSSm+K
	wg1j2s/rhWJ3EdYlBFTBwZjUGdM85tjojCecB1ReSmK1xuURViyiNst6IYWaYl/ytrVWlnqc9B1
	1Uv5gPm4of3ThZQlQAfponogNXaSlGfw6bsLrnJ9qfgu5pQzEgWU6GmzvW8zFefXQq51yhrXjRN
	KpIyZ+Xts1Rk9GHJ6PcHcDlCGa5WyyUHz8Pti5z0PLEc/wKjs1geWfi6YFU6DCWwWXuQztF9vkO
	R61kqTwzJ+Vp2r+S862Xsez1WcLsDxjKm3QMh4bIkXX/ErZdtwi3A1EO2rqxh7AeTYOmxbgnaXT
	+VyVq1Je7Uo50waK+ivNPcpQwfbZpJmXw2KzLFdaLHSnxtvdWOKaENgQCZvquTPIBUXB7ntdDMa
	GCDLY3TOYkcYLCRnIQC+W+v9R2d7IuWkUiyYGSkVaU6crBPK5rqWg8sHJ/D8ixvJCeDu
X-Received: by 2002:a17:90b:28c4:b0:3ac:8897:7baa with SMTP id 98e67ed59e1d1-3b0db7114f1mr4659716a91.40.1794046196073;
        Sat, 07 Nov 2026 02:09:56 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10585df83sm2937536a91.16.2026.11.07.02.09.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 07 Nov 2026 02:09:55 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huawei.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org
Subject: Re: [RFC PATCH v3 12/18] mm/swap: bound synchronous discard during allocation
Date: Sat,  7 Nov 2026 18:08:52 +0800
Message-ID: <20261107100934.39149-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <sashiko-outbox-188141@kernel.org>
References: <cover.1793106426.git.lianux.mm@gmail.com>	<1de96c68db9d3ac83ae485a1eddabcea1a2524a1.1793106426.git.lianux.mm@gmail.com>	<sashiko-outbox-188141@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5DE111A0007
X-Rspamd-Server: rspam12
X-Stat-Signature: 7kk4fcppdp1uywxfzoh7ummbp18tr7xm
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794046197-495092
X-HE-Meta: U2FsdGVkX19ZxlNJIn72BIxEcVFDfrSiLAcR6ZEiREmuerv9fXIpP5No+1J7sp14xXx2qkSTl7iq9OriYjSJJYJ71G5iADMrRTC0g9Ap2uEc7CZ+f4pvv9BU4V+u9X/amSIxMb38xjq3ErOQXo/bb496SeKHv7n6G8NRVJAAB4HOd9QdM5e1FPWq7W0S5v9jHq0k/Y4MGTe7V00ltHV7FOWq8UMtC4Oh7MkB+uYm+Fu5mMmBPYowRwNRItg/zoYYJRHDVo7U7D5vRGvty1IykD4JpZ14/BRwjH3pzWJYJ+I5fVOQnJePpLw7bH05s25O5Edb/J5QkRQjme9XZG8LN3LQO+73R6bLTxydVS6MCL9o+lWV5A32f3jhb64423UDCHPPCCyfUHuuh5+8w+skjgb2sV6LJxKuhj9y+Wjny6iLNPToXFh4+PZpzMEW+/WIvaVCEcoxeK72Mn3li4RGNeYr3OqXOH1COrYqKZojkfXeibFoS5XI7EWLPsXD2Tvej04UwMdO/RHJph5lPZRTzDrZMtYPe7keMd8ivflEZHS7t+ZW/1fQ0eW8sKdDeF4rp0pOLH0XFXarlbCfvcEtoNli3xSSArgNxQy/eCIVzwF4AL7q880GYcDKVIiAQaN/jQhJYRg8TjeC8/XLLmtIKiJDuipL44fEuiQAocwOKmm/27RI01ktpuJVo7TWUqEah+cyT5E57zwTKQdQqiHT6+rHGiXe8Sbe1GhcFw4yCMFxlQCVVPa5OKFRj0zlIdRvAOUIyzm2uYTotOqGq4p9fRWDkrWpNeiSaYKlEux8Px2YhuVzAV2US9z4MN2WPECadCLGrcva2QA0fNMK6EvumsHqiSVFbh0OZmPC5cPoenB3N47dwKupmQRMcj5twRYuD9ynJJi7cvfztIeixnFYoF3E4AOQYhhy5C9kw3h5ZgbLZPMXhYkD4tw2AiGGhvsjpWcETJvN07j+MPZUpw6
 XYodZVjU
 Q39VjVRxnEflUTVZNBxkxpcr0vV3T2lWTEWk3cvSjA7ITHgpCMzgPCvetsMMkroxIWKPbSUspWeClBmK+1tLuPn1YymE4rbaPiad2ZWLxasY50OWzBfUExYI5IbrP4tVoMswcE1PUROmbngmvmDGis+gmB9KLQYePBNDqIBz+vScnhhRKNNIvpTAgZ+rDem1J/THGP922XrLOcG29eLOYGeiGbeCPuR2yRl8Gdl4TPw4B4gNMJ8wBrFS/bodQHxXrNeEeuXy3TajwMbggu5jc/lWqO9GZUhVA0hKIRKnWYLPLs/6/ZILisgeMFHUVUnqUU0OTLtE9EsZfC3s85t4/8+ShGrErXx3TXr7xUf8lhgBGZpnnx9OumWnUppwH2w7GDGbOFgSNmOEMnyJDuM5jLNQIcfnSoPyF0Trz8szRyfir+1Km5GEEkBbfP+W0bE9z18RR8m9KBxU7aq/V5kk/Xit32nq044h9SN4Wu4+6MmGdIbDvVELbFYC//WxQhn7H3JQ1ZJAhJsyRpsb5Txs5Uxps0tDgPVU9k4EkFx0TYB8sz5bxGB2IiwIkSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 16:14:58 +0000 sashiko-bot@kernel.org wrote:

> Is it safe to call swap_discard_one_cluster() here while holding
> swapon_rwsem for reading?

The reader should not span synchronous discard I/O. A writer that closes
reader admission can turn one device's slow completion into a wait for
new allocators on other devices as well.

I have moved the order-0 discard fallback outside the allocation reader.
The fallback pins a live device under a short reader, drops the reader
before issuing one cluster's discard, then releases the device reference.
Each retry starts a fresh task-local allocation walk, without reusing a
ring pointer or cursor saved before releasing the reader for I/O.

The per-request bitmap permits at most one cluster to be processed
synchronously per swap type. Empty discard candidates do not consume that
budget. Large folios retain the pre-patch-12 retry/split policy; they do
not enter this order-0 fallback.

The generic reclaim-to-swap deadlock needs qualification: the loop
worker's PF_MEMALLOC_NOIO prevents its ordinary direct reclaim from
allocating anonymous swap backing. There is a separate conditional
inode/topology lock-order concern when loop discard and a concurrent
swapon use the same backing inode. I am not claiming a runtime
reproduction of that lock cycle.

> [Severity: Medium]
> fail prematurely when si->discard_clusters is populated during cluster
> reclaim?

Yes. With an invalid cached hint, a nonfull-cluster scan can reclaim its
last cache-only folio after the early discard check. The newly empty
cluster then enters DISCARD and cannot satisfy that allocation. The
reader-external fallback catches this case and retries allocation after
discard, while retaining the bounded work per request.

A peer can still take the freed cluster before the retry under a
one-cluster budget. The bound does not guarantee that the caller consumes
the freed cluster, and we should not turn it into an unbounded drain to
guarantee allocation success. This is distinct from missing a newly queued
cluster without using any budget.

For the paired KUnit comparison, I used identical fixture sources on v3
and the revised tree in isolated x86-64 guests, with configurations
differing only in LOCALVERSION and the expected-outcome selector. The
tests use the production allocator, swap table, accounting, locks and
discard BIO path on a private test SI; no production return value is
overridden.

For late nonfull reclaim, v3 returns -ENOMEM without caching the new folio
and leaves one empty cluster pending discard. The revised tree returns 0,
caches the new folio and leaves no pending cluster after one 4096-sector
discard (512 pages at 4 KiB per page).

In the already-queued-discard control, both trees issue one 4096-sector
BIO. At submission, lockdep records all 4096 sectors under the reader on
v3, and none under either the reader or writer on the revised tree. The
three-pending-cluster control processes one cluster and leaves two pending
on both trees. Lockdep remains enabled, with no unknown lock state.

All ten cases pass on the revised tree: four scan cases and six discard
cases. These are helper-level tests, not a swapon/swapoff syscall race,
page-table swapout, or a complete backend deadlock reproduction. They do
not provide large-folio performance results or prove the budget against
an indefinitely replenishing producer.

Separately, syscall/data smoke tests on the revised tree passed with a
single device, equal-priority devices, different-priority devices and
MADV_HUGEPAGE advice. Each phase verified 900 MiB of anonymous data twice,
with nonzero pswpin/pswpout and no OOM kills. Both equal-priority devices
were used; with different priorities the lower device remained unused.
Swapon and swapoff succeeded. This is additional correctness coverage,
not an old/new performance comparison, a concurrent swapoff-race
reproduction, or proof of specific mTHP swap orders.

Thanks for the reports.

Lian

