Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D8FCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 07:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BB66B0088; Wed,  7 Oct 2026 03:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CC56B008C; Wed,  7 Oct 2026 03:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C596B0092; Wed,  7 Oct 2026 03:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD486B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 03:09:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 634BAC03E2
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:09:28 +0000 (UTC)
X-FDA: 85294954416.25.2B81415
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id A58F5C0009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:09:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXIRdkp1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of okerixx@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=okerixx@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791356966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5eSRBzmU2MRMq0BGowMkKhA8W3CkRs/G1NFefVR0TUQ=;
	b=644QC868laPojv5mUvhDeRB8cOQTSdEsGZlnf1p/RtmQQ9ZhMW3qwzDEQmY1KcOZz389BE
	MLxwiMGf7eu729xwLVdHd214jWbl/CIuWQ/mdLJBd5/9Lmn+4KY8fRoy0AurPQQw+TWdE6
	rAzYQogoCBxkpB5C4GBRKlKcx6xA+yA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXIRdkp1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of okerixx@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=okerixx@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791356966;
	b=m05HpBvgmyvxsqj0cJQt+loI04x9jRiVVEnB2ppJh+Dx+2/XFithii5LPwCscrWjAJv0ph
	tAPYqPQZEPIx4y9Ld7FC4ALcvz90cHfW8Xp99iEe7Ks3FMlzcc+Ixo8E7H0E98uaybAPGf
	BEkKKBbRbSpHT6C0Ao4hLqGWW7CQJ7Q=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a0286c981dso33328155e9.2
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791356965; x=1791961765; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5eSRBzmU2MRMq0BGowMkKhA8W3CkRs/G1NFefVR0TUQ=;
        b=sXIRdkp1U2H5pEmAzvK7Y8Tl2dBB+jTfe3LyDcdQcpRe+rZbg/6odxSCCJBJzThKf7
         N7IPC3Y+HjKXzIu28WQdlqNgjaLYNV9MnpoOYY3ZObMuLDnpJSSX780KpLHq/85oLxGk
         heeSCF4nrHq1y6r7hxIz88qJiSMshWUGhSpxGh9nMX7JQPbgJik283FYX+zPdlN53L6v
         Sd8K1taS59sQnA6IkM9Wr5r0qpchmTMAWeWkiISKescCII1GiV2nUgmcYcQMPSRl4Ewj
         ONYKpUIodKhjwco5oMFchkjxPpf7xYWpDmpzXnrBZQXwLLhIvXNF5z0MLtyQsVyxRJmu
         iwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791356965; x=1791961765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5eSRBzmU2MRMq0BGowMkKhA8W3CkRs/G1NFefVR0TUQ=;
        b=sN1z5tB7Um/Oi6x4TT1+nE1ATuv+eZDlTLgebrZ7ffSl8GMsEAu5SmbJk3InrSJPc6
         ZF2zJtk2rVpKdPovxbq5tQg0j9fCyi8a+Qu2kJN0cAWe6N5Iu0AvTN6Erq8DNbjVJqgh
         LZF/WQzv0IhUFtOjxek++6aVBw1JLKI6IdC1DNfCd4FmSy7IKZZV/v0NhT6SmhS00G6u
         yWbY8D0OUI+1HEdf+1sI5J+sNKIklTjrLfumiqlcRDN0/kKk02YIokOzhUd24kyLHcU/
         D59A8xD8YQLMZY14RAKWBHjY3xEHf/eC8rChBXRIjd+jF9+j7c1ff+H/Gu3Lwn2c0//u
         tNgQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKapfsL3PPGPFGTIlhH/or4HHjlSeRx6Q8ZL1igEgolPoRMB7XTkOsTEORhs7SbLupZ8EbV3r3Yg==@kvack.org
X-Gm-Message-State: AFuF++kmBFaPOPN5ggfJQyNSxWlCTq214onOTdoLvSOy9TPiC5eJUiNe
	mvIOT92cckAG6XnP2PfPTnqFaGTKGix5v0Yjq3VrwlY5og0NAcuD0XmaZnh5uQ==
X-Gm-Gg: AYBFou05sbb0UFWe+vvhY3aeq1aEbhldh5BFJVzPxcZIGIImFVniL8ChamDz3f3VXgb
	TptQROIRUcIYAvhm/FW/ZwYJcjrndTUtqoUgdHsojPHp50Aa0qk+u4TCxjgTkYiI0k0t/eT3VID
	mNTLN8WOQJCoP6g0Oy73XKIrbbEMabKdoE1VFmYlFINQmTfEzCDW44ZqC6N1fw/s6RIq8Z5H80S
	qUHV8ZyexMEaz+ShPBBGyZ+h4iNVoaD1edFD6DfJwomtyhFXtm41U69twwOLz6RasNxshZrh7nt
	u/8n13qjAVTbjWXU0Ssfm5fcpn2N2T8veqXNmYGwR6NwXJoI1pCI417Xtix4K65R9EujZ0HKw4f
	nJ7bMKoriOCXZqGBlcvtqp9XamFUADcxqkp5tlAm/kpvTroHe4w/dtlKkOjA6K/k+6ALvogPO+W
	qC4LxR6K9fqaMkXQW9ZmFK5Y4dCssok78LHE87bEGS9Kbcms9gsH6ZNZ7EpLxRCEDuXSAldLok+
	YzMfeV4Dg==
X-Received: by 2002:a05:600c:5254:b0:49f:c1a1:5222 with SMTP id 5b1f17b1804b1-4a180679d9dmr15726175e9.33.1791356963527;
        Wed, 07 Oct 2026 00:09:23 -0700 (PDT)
Received: from localhost.localdomain ([94.252.75.178])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4a178c5d8dfsm135912145e9.14.2026.10.07.00.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 00:09:22 -0700 (PDT)
From: Oleg Keri <okerixx@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Oleg Keri <okerixx@gmail.com>
Subject: [PATCH] mm/vma: clear vm_file before unmap on mmap hook failure
Date: Wed,  7 Oct 2026 09:09:13 +0200
Message-ID: <20261007070913.3923-1-okerixx@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-3-a1f052500fd7@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c876jgqdj694qqo3c9yew9kmkt4tc1hd
X-Rspam-User: 
X-Rspamd-Queue-Id: A58F5C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791356966-553124
X-HE-Meta: U2FsdGVkX19V4BnMReBq7SXKb/k2ZkSU2jpd2M1s/wDM04+/j5Z2MGse465NnurmeVGhC9kzfmE5AqLCM61EKNxfiw7NqZaOJSYXUWQKtnJR5hxoVX6SxL7jtezE2MAXL6raxD+Ibf4DgwGSwijgEJ4ruVstrVP8RLXNM+YbIMVUJizEHOxfud935v/ftUqnhDAtjnbkaBnjFcckPgcY9aeqGf+4xW+W5PynosZ2pRIwpIww6HbXXtciN/o5Bw2Z1Ni8Hr0k8XMU6bhiwbSdIvJkp5ohmnMjgM2CeWhj6ITrKQFylxFvcf2xVNCDYMmbROmqrKXNwyEkVOB1CaQqh6X0VJsNuoPHRLXUbvrpDFYLWgcRRMyfZMpezJKczR5eDpEdhdGle1nifWWT+biAK+/xcsTM3Tm/x3nUV4Fv5GvyyBfQN/eYBdQVfEBeMIo/p+u2opFP1nPTiVeODPZsDerjPTB6jYM9hZMM+1pxnNKIcE3pB6sThqvez4LzVtqDvRkjJRzKhVbY+rQ7aScwnvqohkR3zbHE2qEjsMwale5phfs5LUbOW8BocKAspGUsFGLV4F6dAJl5kuk2V3NqPgrioVdNushq1yafDgytKfrv8eUwsPbrgrt16PiVyAKtaxKijh+ybD6Ok4NG7zydjpDh1pY3Au0rABVQhrPhQmC4cuwWQJ7vByTpPgY95E0Cq1TjvnaBSWokrNMRlXstWGBscqYecxwqxgoXqYZ+RnwVQrwsH/4SV9gimpbj/OvKTezLuO2IkPiMoktJ92/89UrHI3BFXaNPUKYPFlwnAMDOZtypgeLslXavaVoBrP01bQCzyukUw89ZhaIxyESRmMXNaik9HmJiWsEI/niZGQWucAfdl+LgrppPhuOUSn4H0Pg8TX30f0OY3Nfe3tMO+jMrAnEj5fozXwUsexPNg936TtoM7M/OHGXMCy8cKW0vSGd1f6+k7L1sW9BcWEc
 EHOyUDZD
 JjaI52sYRnWzwkBgBbsRdAl6IlIUAu3D0GyzI31ZakztxmwYZMgZvuJ616qC0Ihe0OxEUKc/dR1c09G5cl/buZCbn4v0oVQojuVfy108df4fhrn6rjmlpQX39Ed6ViUHf6KwRS9H6TtsNX6eZYod12y2yT1Y/bx8IBu+yFYU3VpKADGvna2VW8kd3gopLQ80kFIFM0ROytiNgXUffSjNRppasxuMIxeotW3vRkhp5eHdDASgvlrlEH7gFAd6QAHtaJThSENnDPWANA3KCL4bL3n0h10xISKRu+ioeyGFBzHpyIrkd+liwKGf+wrfgj/qws0oqxoZB/oblOL7+ykpacMDS/bXibkYJkHti7ZfgQ5XmnT6DNze0DfQ9OoV6OnzzcG5a3kZTrFNM+gxiQaISqUFG9SKU6DT6GfP9hU9qEko08m0R5xhyMkTxIO76D7lvfMVHisiEG1HiKM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
after unmap_region(), so free_pgtables() unlinks the never-linked VMA
and drops i_mmap_writable. Once it goes negative, every later shared
writable mmap of that file fails with -EPERM until reboot.

Clear vm_file before unmap_region(), so that free_pgtables() does not
unlink a VMA that was never linked to the file.

Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
Signed-off-by: Oleg Keri <okerixx@gmail.com>
---
Seen on next-20261006: one refused PCM mmap probe from alsa-lib left the
device unmappable, so PipeWire could not play anything.

 mm/vma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index dfa45c64222c..8d62da16e076 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2619,6 +2619,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
 			    map->prev, map->next);
 
+		vma->vm_file = NULL;
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
 		unmap_region(&unmap);
@@ -2627,7 +2628,6 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 		if (map_same_file(map))
 			fput(map->vm_file);
-		vma->vm_file = NULL;
 		return error;
 	}
 
-- 
2.55.0


