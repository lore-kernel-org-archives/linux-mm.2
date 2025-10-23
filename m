Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B55CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 18:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855F78E0007; Thu, 23 Oct 2025 14:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E02A8E0003; Thu, 23 Oct 2025 14:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7C68E0007; Thu, 23 Oct 2025 14:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 535DD8E0003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 14:34:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0799140BFF
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:34:43 +0000 (UTC)
X-FDA: 84030230046.21.D73499D
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 16CEF14000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 18:34:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AkpYyMKI;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761244482;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/VA0enLRKccdP14FA/Vaa8mbbHGSiaGqmOz4vjURDc=;
	b=ZJ0W3R4lgRRlWYEhOWgmkA8qGIlgjD+oXQ/WkERdHEBfjY+GTlRFJDIgzz/glP4+YSKT4M
	QZo2WRH3aaYnoyHBNHOmssfXpEccprG42awhDN+KFmZK19msYOfgwvNGFcx3Z3iaz3I1oI
	TTZuTe5L1OXe25d8MdY4Q/0oX2vBeAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761244482; a=rsa-sha256;
	cv=none;
	b=GFqK9hpReXV1sk8M+NO4GzleRW4Td/6EvnXclpQWCFr5VeLy4ODCz6yTnd0aPLixgxQJjL
	TWrOeOGxodiAY/JEUJ+0aSVBrKlhA9xZ+Ky70ixtIp2/63b02hRGYK26HSz3tKBFiwqLdC
	cucKET7Zu9ssimHh9M+hmP2knRwEyCg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AkpYyMKI;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33f9aec69b6so1645264a91.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244480; x=1761849280; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7/VA0enLRKccdP14FA/Vaa8mbbHGSiaGqmOz4vjURDc=;
        b=AkpYyMKIZa6FOZUpFpH1Ka+QbUTtZcZ6Uw4CnUb31mdIo8pB710sT71hPcW+hmcYaM
         JgRoEirruE3Y1/DX9jrSslZU4S6zuF4TCJO+L8MI7uqdNfjKnbjfY6NqtzT8CYoW/fXH
         FeWpVMb8sRHCK08dyiwersf9UhQoFLSNQ/nAFnIDBGpb9dIFC3AE2a8Iss2g/G/Ak3zp
         OJH3/up2f7MdR+aZzGStfxRYI9At6feF9zTtXs0JJyFt/FUI9WHXQiwOKMMrxynV1Gwb
         4qPII5DKxSO2XHUoU+aCEifXsyI1iHr2dM32h5UfIkJgRaqk+YgvT70lGhce9NoCyLCp
         BhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244480; x=1761849280;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/VA0enLRKccdP14FA/Vaa8mbbHGSiaGqmOz4vjURDc=;
        b=ZuJ+zRo5rswnkMEEqg/Y2b+Z3zd7cf8j4uZ9HvsSs+DDo7HwYT8Md+1mDckOGWMbMW
         Y79bXa2jIwDp001DEQy3J1kM9YVB1oKMIrZ+vW1bZ4OJ/nXhLY7lMt6i9z/ZDbKdBc61
         dafcSub2T9rRxVLflBrSAfbGB7aelaNoqz0OCiAEG5I8El3dINtxoOAvx2RIhTLnJ3Zc
         FPWi77O8/JcQ2BO0/h2bZO+8k0ChM6sIWZ0s25wUdz2jBU7thD6w+OcSiRAhLsQle+zd
         vxv7+sXsvYP+DoiyzKTVfr0TG3wFZ8JROCvCJJb5+zfWCCEB3bYHAY1ZS0dR4k4tYXmg
         Avkg==
X-Gm-Message-State: AOJu0YxPhrTZ+YkmppdQfhY2YfJfbcF7a18zpITdeB4yEbmr7vSX3M17
	KbEZVPG0x+TiM3/f4VJanLvTURghlrdazjFRfX6Ozi+jdDsEJ70BGLVobMdsZ2xIuhI=
X-Gm-Gg: ASbGncv3+RfaYQdxwkpldkcTGNPgh6Wvwr3ZLoeRcspjcAF0hh+8JAJLwt+1U86LIsI
	GDqjkW9hSpl5Q4WMH9jUMorNkdq3ZtfXjCXMuH/adTV+EUAa+LA0kbeldcsW7ZOC6LABBSi/GKB
	LCB+DHSGk0B/xgmBD1RTGj4eWhFK33FuV/xgFPnEyLnum6m3Y8S9bem4K2xqtrwo34OwpYJ1JPq
	NLyqtx73i+TwXfsdl1a4qRghuQSFISkSUwLhXt4kYc8C2ngZXWqxc2++Sf1nqhhDW3hkg+l/dvX
	mwRYzPBnyen69l+P/lfUYG+NRKPaEQYTjaEfgegCLk4Hhg7CdUzAA2Zc/UPe6yC23NwjuroOfXA
	Pm8FzAKtrWah0Sux4EMyClH3ayoixAvZsOZsTv7h41+Wtcto8pmC2/u4XX6h1vxX07YPgddZeEa
	TeZamZzd3/LbRSwBEatCGuy1GFcxMkmN8=
X-Google-Smtp-Source: AGHT+IGiqCrNfq39nDPGx1DT9imwuvzaEJqhlEfe6FGy7mEh7Ihbg5SRkM8lVhCfXKJmF5QOtT3auw==
X-Received: by 2002:a17:90b:3f8d:b0:33b:be31:8193 with SMTP id 98e67ed59e1d1-33bcf85d59dmr35534624a91.6.1761244480179;
        Thu, 23 Oct 2025 11:34:40 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33dfb7d6b54sm3876533a91.4.2025.10.23.11.34.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Oct 2025 11:34:39 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	YoungJun Park <youngjun.park@lge.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] mm, swap: do not perform synchronous discard during allocation
Date: Fri, 24 Oct 2025 02:34:11 +0800
Message-ID: <20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-0-c5b0e1092927@tencent.com>
References: <20251024-swap-clean-after-swap-table-p1-v2-0-c5b0e1092927@tencent.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: jnebzd3keozfsus4wjf1jr574dq5pb37
X-Rspam-User: 
X-Rspamd-Queue-Id: 16CEF14000D
X-HE-Tag: 1761244481-42727
X-HE-Meta: U2FsdGVkX19uHHBEKon0rcOSr9LeQgtTxmu79drj4scGqVOb8iNOH1YX3oQRnbhgBbcKtLDtTlipjeak1PGq+0WC9znhuyYyRPw93aRPBkeDaLWeefhuC2AyqS0Rey+cPGwrm1P8lIzv10L/9nQV/Hjs15USweOkANxEa6mTQKp62jlpfLdd5eCk+0H9tn34sO20umgJKKGZd6Flq3I9qmt/sO1x8YJs0sLUYAT56Ctm1bVjdaFJnUhmp4Dde9WeIpyj4KpywOYJlhP9FTmHUYhUlxojIPggOqmnTyrhXEv2zpttt3z6zThCW9sKOF+faPqkOYvKrI38+GVJZhTSOpA4rQ9du8P+sbSn2qF7gZi07FseAiORFFnPB8FH3Lw1hIXqChIeNuqD3oWs7ENbFP0Ts9vvok5B8D11Lq/jDw1JLoVIjTtJrahJCmb2M68pp7TXUH+6HlRi/rrc7lylrSU+tYNUgpoxKc9/kOpRtIwTx4rJalozy0hJYzEsHmdz885FyrZ4KB64MNimayPZC8llBZpvN5w6yQhOkpdmqxapbL/ZJ4/1Sk4Rxw6gpQkTitj6/4XQyS1EHItYaXFgEyx5brHIzKkWx22Gr86X4lkgEfdJWdadq7heNXzIulmnDn4tLYNtjfaWY/0/njPU4j0appsmYX60VOYF8U4O58MDQiLhDLzq2Vx6owdC22bVRrt+xs6jScRTdg3khtIkSZQjQV9m7ujOfHwUAF+dIDrmoHg/CV6oqTYVAiRNvXQlnsUxVLioJHdB5RZyJXZbFeBSeZGADh9IN3gW52dtZ2DtvpbqbccGWCOlavnE1mkjNjbSfxL4dxvS1YtoANYOGd2whrHfan4xz6SRryvEVaUlbO3LXMNPRROAsPBeEZwyvuY5P/vEVNivtK+TEBKhJqZ29TLvFfNuuZ1kO5dHriD8AFVDNMgAUpkGkuVxb0OgGgNNSsLeiVkMzoxa+Oh
 iKJ4BSKu
 0oNeNOILLjmFLBCKkCa+eDk92ZtUMs+p+0v4SoBArQKPneCw6AN5MMNH2epbweeKb3+Ii0MgvGEX2/TeOhDmrD2kFG6JO21r+zX6kwaNPHOZqkYUJXgSukMnPJ82I+OuTTtdmswvi1tN8Ms10vMd0S9+OqfbbNkHa5Dc5Gad5sdfPq/WOQ/wGq1+UT6azUL7HTRN6GIBrx90hK6zuqvHV6bxz/1jgfCDfGKf3Nf01hS46fnGG7rxvopCU9v9fRamfz59v0Xtnff/ux4L/T2OymBcHw216E5F59r6d0lLH3k7jGCr2JtG2DAM2l+NZP9WHEIcOFhdQoc99rZLullkoPO2B68iojHckMuJF7zpDZ3qjo7CPQ+pQJZeCZ/YNp46cgY7vt4YEjk5GLbBfewupl0I2Qsvb92XrdOlw/fFotYHc+6RZz6TJCKE2ARsF58NbXpGlM9912itgVkeKdaNj/BySib1yZ2fjZU/URqdmKvclDDaxUTu+hfcml2diTbV1RoqxsN8cUW/+N5r2QjO9XIYtU6KfQ17ifOlhK+9pzTy7ucJc58ZVb5gjFLweQUk3gHjn4CzE4TVRT1A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>=0D
=0D
Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation=0D
fast path"), swap allocation is protected by a local lock, which means=0D
we can't do any sleeping calls during allocation.=0D
=0D
However, the discard routine is not taken well care of. When the swap=0D
allocator failed to find any usable cluster, it would look at the=0D
pending discard cluster and try to issue some blocking discards. It may=0D
not necessarily sleep, but the cond_resched at the bio layer indicates=0D
this is wrong when combined with a local lock. And the bio GFP flag used=0D
for discard bio is also wrong (not atomic).=0D
=0D
It's arguable whether this synchronous discard is helpful at all. In=0D
most cases, the async discard is good enough. And the swap allocator is=0D
doing very differently at organizing the clusters since the recent=0D
change, so it is very rare to see discard clusters piling up.=0D
=0D
So far, no issues have been observed or reported with typical SSD setups=0D
under months of high pressure. This issue was found during my code=0D
review. But by hacking the kernel a bit: adding a mdelay(500) in the=0D
async discard path, this issue will be observable with WARNING triggered=0D
by the wrong GFP and cond_resched in the bio layer for debug builds.=0D
=0D
So now let's apply a hotfix for this issue: remove the synchronous=0D
discard in the swap allocation path. And when order 0 is failing with=0D
all cluster list drained on all swap devices, try to do a discard=0D
following the swap device priority list. If any discards released some=0D
cluster, try the allocation again. This way, we can still avoid OOM due=0D
to swap failure if the hardware is very slow and memory pressure is=0D
extremely high.=0D
=0D
This may cause more fragmentation issues if the discarding hardware is=0D
really slow. Ideally, we want to discard pending clusters before=0D
continuing to iterate the fragment cluster lists. This can be=0D
implemented in a cleaner way if we clean up the device list iteration=0D
part first.=0D
=0D
Cc: stable@vger.kernel.org=0D
Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast path=
")=0D
Acked-by: Nhat Pham <nphamcs@gmail.com>=0D
Signed-off-by: Kairui Song <kasong@tencent.com>=0D
---=0D
 mm/swapfile.c | 40 +++++++++++++++++++++++++++++++++-------=0D
 1 file changed, 33 insertions(+), 7 deletions(-)=0D
=0D
diff --git a/mm/swapfile.c b/mm/swapfile.c=0D
index cb2392ed8e0e..33e0bd905c55 100644=0D
--- a/mm/swapfile.c=0D
+++ b/mm/swapfile.c=0D
@@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entry(struct=
 swap_info_struct *si, int o=0D
 			goto done;=0D
 	}=0D
 =0D
-	/*=0D
-	 * We don't have free cluster but have some clusters in discarding,=0D
-	 * do discard now and reclaim them.=0D
-	 */=0D
-	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))=0D
-		goto new_cluster;=0D
-=0D
 	if (order)=0D
 		goto done;=0D
 =0D
@@ -1394,6 +1387,33 @@ static bool swap_alloc_slow(swp_entry_t *entry,=0D
 	return false;=0D
 }=0D
 =0D
+/*=0D
+ * Discard pending clusters in a synchronized way when under high pressure=
.=0D
+ * Return: true if any cluster is discarded.=0D
+ */=0D
+static bool swap_sync_discard(void)=0D
+{=0D
+	bool ret =3D false;=0D
+	int nid =3D numa_node_id();=0D
+	struct swap_info_struct *si, *next;=0D
+=0D
+	spin_lock(&swap_avail_lock);=0D
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[n=
id]) {=0D
+		spin_unlock(&swap_avail_lock);=0D
+		if (get_swap_device_info(si)) {=0D
+			if (si->flags & SWP_PAGE_DISCARD)=0D
+				ret =3D swap_do_scheduled_discard(si);=0D
+			put_swap_device(si);=0D
+		}=0D
+		if (ret)=0D
+			return true;=0D
+		spin_lock(&swap_avail_lock);=0D
+	}=0D
+	spin_unlock(&swap_avail_lock);=0D
+=0D
+	return false;=0D
+}=0D
+=0D
 /**=0D
  * folio_alloc_swap - allocate swap space for a folio=0D
  * @folio: folio we want to move to swap=0D
@@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp=
)=0D
 		}=0D
 	}=0D
 =0D
+again:=0D
 	local_lock(&percpu_swap_cluster.lock);=0D
 	if (!swap_alloc_fast(&entry, order))=0D
 		swap_alloc_slow(&entry, order);=0D
 	local_unlock(&percpu_swap_cluster.lock);=0D
 =0D
+	if (unlikely(!order && !entry.val)) {=0D
+		if (swap_sync_discard())=0D
+			goto again;=0D
+	}=0D
+=0D
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */=0D
 	if (mem_cgroup_try_charge_swap(folio, entry))=0D
 		goto out_free;=0D
=0D
-- =0D
2.51.0=0D
=0D

