Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A959C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00586B0092; Fri, 25 Jul 2025 12:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7AB6B0093; Fri, 25 Jul 2025 12:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED7C6B0095; Fri, 25 Jul 2025 12:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA3C86B0092
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:33:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 697C6113D1D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:33:43 +0000 (UTC)
X-FDA: 83703333126.18.513AD66
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 993394000D
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:33:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gl79pHPn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CuSVB39VTwFvp064jrtVS3lbNZPZ0LiRX/EnLFvU1t0=;
	b=lq08IiHIZxZGPvkFGVk4pxpOcINvuHm4Jm3KKsWbrdX4NrFw9S5sK6tMLqpLvktCXmJHTZ
	EJslSrwX+wXwYDO0uK/OTG8AIkwdLTuenY57Zh9UPzJWcJRg6CWYtqox5tEGZErvmJKH/v
	6K6iTu3TNB4772KsQAlBrRosL0sBPhE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753461221; a=rsa-sha256;
	cv=none;
	b=qfksKCkKuBDmPLSgYJFwyzfsz+Qn6qcWk4zEJIu9w/oPY52CPDtPr6MSyM5qZ/l4dZkTuB
	oxA2lpg5MxAGbVrnPYfGUcUA4nIXgZJ0GRxYT8+SndRt3WiIzqEvIlW236nM3Pdxpj0YxI
	3/cbV9auQhGJ0j6DJYVMWtSdug7HWaU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gl79pHPn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of bijan311@gmail.com designates 209.85.219.179 as permitted sender) smtp.mailfrom=bijan311@gmail.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e7d9d480e6cso1657300276.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753461220; x=1754066020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CuSVB39VTwFvp064jrtVS3lbNZPZ0LiRX/EnLFvU1t0=;
        b=gl79pHPn+W2w10HDpwjr95/E5wdbsSaf/dhNtkkfJpQigoPlNVBqZyTq0SrpXcBCZz
         y+RPAugQFImdx8ETWbExzlxSYC97ocn0sGK0f6CGGpkTXO1hzGYtBTgtzT1VcOhVb1c9
         4pmXnuKYc8J1ZJIdqfbEYT9HJx/PCgZI2+EUI12Vxfril6lG3vGNVTSg1AVT1TpmcHeG
         TcYi3p4+rfe7IDrNgaU4G9WKtMJm8/HmgC65vxYBO3wEp8WmoZixvH+PxwRH8Bi6Tcsm
         8V0jadCZKkgID/RBZC0ukGdJDShtYEqKm7uhAGCEZvaq0xBMniPdBESLWZ74qpnoneh+
         KEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753461220; x=1754066020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CuSVB39VTwFvp064jrtVS3lbNZPZ0LiRX/EnLFvU1t0=;
        b=cC7rA7TBHNDAESY49jYsnBEg6PHe2E5gpE+fsISCp4G93cRtxuorQJeRAitqRAKnGn
         5DQH2dOeO1dEnTtmACHoFsJHv9YsaVj+RmiUYd+fp/i4FNqHTrni/kizbDhuJRLT58BX
         7HeSPOUmcAYrx2X/Djfifboh0Q1fuX04vpz004O0DBFonoRRo08g7FOdS7UN9lFHReRz
         ONbb0r0mzBqzJ2oOfbDvoIqRy9ohO9DGY2ADrpTndCweS1mGxBbyxrzo1Yy3f0XPyRii
         fnud02ZtwoQVNKlW//ZrPi+UNuqepnEC41KlG52nXArHz/tPQNKJNm0NRh3b17IePwJz
         qgwg==
X-Gm-Message-State: AOJu0YxcSzD6RqzIDvfp2UfKLHtVBUiAgWXs8HA08ZnH0hLchDfzIpoK
	/QS+m5J/UtseelKgGa4uPz9/NEeYiTXvXa9MaiXtcQiSXtcD5fLbXakGSY4pIA==
X-Gm-Gg: ASbGncsc1no5J5urMEhZNz5GBv6FcHnhiJuVpDvg1znqXz5Pm2FuzBmP3kyjXf9isy5
	fu/eEjeUOI1Lab4ovfPTIn/ksMg84kHh3wwVk4UovGXwE+l06/tLrLQFO4S9Y3FI+0LQwyxBnbg
	lAWHbHKH+PsQCYq7I3eTzG2DLyJcG039c7dN42HnJREeqOg923rosBxq2BGGN7Q6r//v5roK6nD
	tVeBQob40KxAbyyW0y/tlkRezcEnSKk4aQ31juF4GPVKLUuK0tEv3SzrNR+8NgHYeP6EhnozK4N
	Stl9iAoq3g1i1qgcwhb11ge1yua2JYecTBnkUnnaVhKqBIvRYg2OcC4EJJSYjFFVZDz+XlSYf1X
	TXpiyKbqK2wC8p9TfNTkJ1qaBjVpd1GCoGcBzYory
X-Google-Smtp-Source: AGHT+IFw23rb4EOn1f5E1CRR6PboLxC0Lq7jWPQhC13bhKmS3MQg6viTQTk7iAO7B221UWGTNUczSg==
X-Received: by 2002:a05:6902:2013:b0:e8b:4455:787d with SMTP id 3f1490d57ef6-e8df1228357mr2550580276.42.1753461220113;
        Fri, 25 Jul 2025 09:33:40 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:79b4:320c:b28d:62])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8df86ea200sm106376276.35.2025.07.25.09.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:33:39 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: [PATCH] mm/damon/vaddr: Skip isolating folios already in destination nid
Date: Fri, 25 Jul 2025 11:33:00 -0500
Message-ID: <20250725163300.4602-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uubxonoww57x9mwfa5w6m4hh7kcxtq7s
X-Rspamd-Queue-Id: 993394000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753461221-966772
X-HE-Meta: U2FsdGVkX1+ay9Qqdg4rmRtWLGYUCgaxZhez247eNSX3Ha6gX823Y4SIQLHqPlzQx1Px7/WPpMU8pasHrPHd0eXO2Xz5ZP1PegFHLYmgkm7eKCA7BnnIt5Y6cJXe8nguHQ+AVrFt58iCCKjCMCZIE7eILjFlxspwGzWdMVYASEas9vYAyDOM5AgyzNmxLwYd7krziTG0Is5GM6QYUXOq7ixXprTTpVeWrEZtICViBnGOc8Jrv5AwlzSqwQTswfJTIEd5lA3Sd5a3LScimXle4ra5Z1YPohGsIecPpCo91Xkpw4pM4I8AH4DgpL5LuDU4jkh7D3HkUebvDN1WvVMbGk2SjjhRFHZ1bE9KyygapLhHHTrjENxuWZxag5BCK6767ezBOPIOs5dCP96Z75vrLA9IdT1cjKF5dHSrzcb5+zkVC3fpFpr+5J5E9e4zrdBtlgIT606i5//uhhIwRXroovzoB8GVtVTrFuk1+XL0Gyhbb5615SQFtYUW0DUZKQwH4/q6IQjjfYehuO/fWmRTwcd+8u3ijLmWqbry45rHfOej1+5u6ysgwOG8y/z9x9qvG9rOJPkarM7r7R/5MOUjVFHRn5MMQbUbjqr0ECv87mqzGaBsWSVpZEqw89ghb2Upr6NEw119tX2r7+nXe7BJoDma/kNP4VMfh+ckCEUGlWrQJRs44lokHK9ESuuZK6nlf49+UAGs9un4Bp081OqTlV8qy6ep+sURZGEXqxUZiIm3PZSKsoikmJxg79eLNjzgV/zftItFSu+c3DnLeAC4gTs6fK0dX1+0ciR+Qis3cE1Rbc0X1QJR5RvJXMQz25Q0J3SbgowlSXKCTJqcgSznhEbms6K5pksnnEGIauGyRM71Axxu1bWq6B1iTH5NTDR88PocGYJHDXtquupzgTA9zhNa7GuEm0mNV9TVIo+MnsE5vSwbTYy2IumNq4Ud00PwtBTDMLU0w38BUZtwsBQ
 y5g6jcyW
 PdSpKxrZZZxJ+Zs0ALdA24suWxVzC7eYQoicYHwxiJ2uT66wOgVGrwJWJMsqomWM7TpgsADF7bk5+ArY8Ui4vmYmsx5MAA1Yqqr1M860umMDArUE2wzNzgHg8pBi5vrC879e23g5uob2STnhzpOjAtSfBAs4sYmDZE1wQmSs3hIqEPz6dzHLSSHbOUANwkQqM7uBuX0EWZuqbeqZ07nGLc71VOJl4N6yL+IGZbZ4VwVRi6mzhcNwcSXpkuxKfLklj0hidBnjoCHXx4EE2HnpyYV3txYKyMQAq/SqdIQpkYOHdoR8LyRZNvNZqiqiVwDqpFf/2q1LaIR+jmrtYizk3o4YVCrrDLdOdgFlz75IXtYyVIHUZocPBloAOxwTZVOzifZkWJuI5R/6LUwEe7Qr6EQzYOuMlS4Mh4UV3k/YJ5hy9lFViD++dl2grughUogg4BiA92/+Gw3+u/5kUKNZ0OgvJIACG5/vBns1R2ebNxyxUccRlFPN1GuZ4iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bijan Tabatabai <bijantabatab@micron.com>

damos_va_migrate_dests_add() determines the node a folio should be in
based on the struct damos_migrate_dests associated with the migration
scheme and adds the folio to the linked list corresponding to that node
so it can be migrated later. Currently, folios are isolated and added to
the list even if they are already in the node they should be in.

In using damon weighted interleave more, I've found that the overhead of
needlessly adding these folios to the migration lists can be quite
high. The overhead comes from isolating folios and placing them in the
migration lists inside of damos_va_migrate_dests_add(), as well as the
cost of handling those folios in damon_migrate_pages(). This patch
eliminates that overhead by simply avoiding the addition of folios that
are already in their intended location to the migration list.

To show the benefit of this patch, we start the test workload and start
a DAMON instance attached to that workload with a migrate_hot scheme
that has one dest field sending data to the local node. This way, we are
only measuring the overheads of the scheme, and not the cost of migrating
pages, since data will be allocated to the local node by default.
I tested with two workloads: the embedding reduction workload used in [1]
and a microbenchmark that allocates 20GB of data then sleeps, which is
similar to the memory usage of the embedding reduction workload.

The time taken in damos_va_migrate_dests_add() and damon_migrate_pages()
each aggregation interval is shown below.

Before this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                   ~2ms                      ~3ms
embedding reduction              ~1s                       ~3s

After this patch:
                       damos_va_migrate_dests_add damon_migrate_pages
microbenchmark                    0us                      ~40us
embedding reduction               0us                      ~100us

I did not do an in depth analysis for why things are much slower in the
embedding reduction workload than the microbenchmark. However, I assume
it's because the embedding reduction workload oversaturates the
bandwidth of the local memory node, increasing the memory access
latency, and in turn making the pointer chasing involved in iterating
through a linked list much slower.
Regardless of that, this patch results in a significant speedup.

[1] https://lore.kernel.org/damon/20250709005952.17776-1-bijan311@gmail.com/

Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
---
Sorry I missed this in the original patchset!

 mm/damon/vaddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 7f5dc9c221a0..4404c2ab0583 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -711,6 +711,10 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 		target -= dests->weight_arr[i];
 	}
 
+	/* If the folio is already in the right node, don't do anything */
+	if (folio_nid(folio) == dests->node_id_arr[i])
+		return;
+
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
-- 
2.43.5


