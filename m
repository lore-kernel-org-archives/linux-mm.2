Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8C3606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 07:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kV7nKoWv
Received: by kanga.kvack.org (Postfix)
	id AE3C56B00EF; Thu, 29 Oct 2026 03:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94EB6B05B1; Thu, 29 Oct 2026 03:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9837E6B05B4; Thu, 29 Oct 2026 03:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 740356B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:12:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04A05C02FD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:12:19 +0000 (UTC)
X-FDA: 85374795240.03.81255BA
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 350EE140004
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:12:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kV7nKoWv;
	spf=pass (imf26.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793257938;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
	b=YW4W6ng28pRPEQzt1MUe0IqsfJyyuSKWX8+HA1aaW35XVJWYtTvu/mhKeTSg2INUMgEUTf
	LKpjSnFsxYCS+Q7FY13T9yYBu7NrJNvqtvQk1uHGtd5Fn2bIjJDY15chf9Ep2GVVEcWr3J
	bh2NpU8FCVebyxw0b9DSfDlFe1K4fzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793257938;
	b=Q7uFpgb7O/OW8sl/mBBCCSndOi5lHCRPalU0qn3SKZd7tkSKcroHMXZ2U7IRXC3T+CaizE
	NZefq99MuTcIIgiY+OX2mG6HRSUDNcdu7CWOBhVCmF5Em+WLq0XE/EYPe2Hj3F7DC/1Zgq
	d1QJPiffiyIjxhjH31TPpn2Vga5ZVJ0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=kV7nKoWv;
	spf=pass (imf26.hostedemail.com: domain of trilith.zheng@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=trilith.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8246b13cbso15266625ad.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793257937; x=1793862737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
        b=kV7nKoWvmQ2Nk1qFZGgF3lABGJOwEbPE1tcOh0x00TUVg7MscMc1TUphfHjAeMElAx
         USerf8QHUrQiVia4FjN4fP9BOvPml4T0x9kNSw6mYcKlAH9UPUEtJrOGRen8DvwKhZp4
         eI2RDsk5BwNBJVN4F8zw3RvADq9ipkUcOFw+2PfGfG0I2pksTqdTT4ALlu5/9p9vuixu
         WTDHsGx17nL28OMFQ23lCYP0SlE685ZKruagR09APYy39SfJdoAmU6Qo3zdF92a+rcMz
         XLBTbluEX4sJYovDVnkp0lOvFRrtKKWnV4uxZruU3b/FgHev9zy3DKdfiF1qgyAXBkZl
         NQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257937; x=1793862737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q3Nd7r/hqjSFpCyfHdGuJldUGtTV8w8XJqRuLAQWCn8=;
        b=MMmvF+pBGfUaZR5mBDrZhOJABG2kad1mV77ZxlV3bCue8xNaYWDsRH7+ax1xxhymxu
         ZSqlevLs4cW07PV7ngItr/JidVoHj5WOeTNognSC6e5VvomELA76TH48lUmXiw83yBeM
         Kie/St8+WQUJCUtiyK13+IgJAzXGxohWkr80K1fhuXgcJzqkuZtAFUFpiUW5QLOJj0Tz
         gwDHBrMRUKcZbRdS8Sebo4vRNZ4f9DE/z5EiHVW8cGSJfNZoar0sE2WsrO6/lJkXAADm
         v/rJ4sgiJ/2C9S2LletUiia9zSGpJpS2spIKVZOe7PbD/FGr8OWh9S97NVUGVIzjxGlB
         NKfA==
X-Forwarded-Encrypted: i=1; AKwUvBy1mmrizLrJL7hIcHgMPgvYcD7E2d8vNJPgeUeeZ6KH+zfMJDoYRyNMBhRZwoNgCe/KJ0F1Xd43uQ==@kvack.org
X-Gm-Message-State: AFq9FYLYbHe2xoxu6X9v8Ld7BgemegPN3+ac7Cd8W74syaQZUo1wbfEU
	uGqZSenIpBWqPsGsAd2EKdCb6lvmntDZD3XGH9ZC37yXVFg2JuG9F64c
X-Gm-Gg: AYBFou1nLmJVb27cfLg62+yhGYOdjsYOlPhU9PJbrSjLNYcXWBthz7BGmCbkdmv48s2
	8XDhRwRXtOusUAbbAsPQxkpfsX3AYlIV73kv+JBy4b9CEVQDB1/AAK1D1SLGe/FbLpx+eWk8JKI
	Z7vkk2nk6idluVk2uF2KTWq/SI2OCyYSNeOTIemdjYwtNwA5XknLCkzotD8SNvSCKk6VjR+G+Sd
	rmwrfXT+sQ5yrWbVmejRBtrehd2n+UROZfy2i5CBm7Xu1O+Us95XM01ixZvjD97YwuKNrT9mw/i
	dAH0tWxTHd92poT048L7/5iw22QNFXr9fEDEhQHd4h7kG3I8/U68geiPv+WYVR+s8Yzk+nATAyY
	WedkOzRhoKZ0HHOqstwtv4SGIzyufS4T0Zoh8gYPvy49FTbDlvACVoA8pKCZNEJwe8JJDlT+aXU
	Y8gRKVvZ2WahOQOe4Q5oKbAkSjUIidQuMQCelWV7jElQMnQ6fMbUIqRe5DQW79VcvfLxewGc2e+
	SJ3ntBQQ723jCPUJ/ZkLr47apfbEQDiE27HyzgzU5K+OF+Pery9y6Yf2pUv1fo1Txf9cVO9RU/8
	vgWv5cxsf5PxKpLkGM/L8wApM0M6TORYmpG+kfNbqRCEaVlN8FKW6w==
X-Received: by 2002:a17:90b:3c8c:b0:3a4:ca46:8d44 with SMTP id 98e67ed59e1d1-3ae5819e58emr3799149a91.18.1793257936864;
        Thu, 29 Oct 2026 00:12:16 -0700 (PDT)
Received: from localhost.localdomain ([101.44.96.6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6f01e8a5sm1180018a91.0.2026.10.29.00.12.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 29 Oct 2026 00:12:16 -0700 (PDT)
From: Yilei Zheng <trilith.zheng@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH 3/4] mm: add shared read-only vmemmap support for FS-DAX
Date: Thu, 29 Oct 2026 15:12:06 +0800
Message-Id: <20261029071206.19059-1-trilith.zheng@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
References: <20260903122128.12264-1-songmuchun@bytedance.com> <20260903122128.12264-4-songmuchun@bytedance.com> <20261027065723.66564-1-trilith.zheng@gmail.com> <4c9741cf-ac62-41d4-9c7a-7d5ceea4a8e1@linux.dev> <20261029030511.12004-1-trilith.zheng@gmail.com> <2E5C10CF-F3E0-4694-965C-B0E432A1A962@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 350EE140004
X-Stat-Signature: j9h5rnw9r7ibwigezk6kag4wajxs1455
X-Rspam-User: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793257938-169919
X-HE-Meta: U2FsdGVkX1+xrL2Y2MRumuw+XhyjI8EEvX01ZinilqNeHN/ddDJCX/DHlHXDwiS6ADeke5BcW3r0CQb5FGNVmc2j5SfaY4XTII4dIlpU8QUkZl8xjXYL744aZXo6wHhyfooU5uUiqduIF+QjRrvFegtY0v46WeKgQtAbY/jh4xp0gFrFOf+2GKwQY6Wl89O3opgdmupTwL4s5vVhYkyPD/HEaGOOX7RoIsf2Cmlq3GhhYqqWII711Pl05mnhEsZHYyIOn3RJoMpPLoFjAksvfe/RDEkzTMTS8EGhLoAQJ0SEx9+DHnYDDaIVzQi/dsd6MNWi14QdcMb94cDc7lnEE4LVp5lt1R+jFGUf6umy2sLy/PhaJDfiGCRvZm0O6RRhUBgJWshN8ukyEHniyWe/Fl6rKfni+FU+71SIqRus+8GJwx7EM28kRa7ZjHARCNnSmquO8xvDi5G0lLXgE3bzUjBImTCZaLzd44Orj9k2CVB8FFbMIL8xyWwgNMKx3PQYTBbQTnx43dtLnLY1FUUwFzkUWJCY8nQvbG8ZoE6NtUxCubb2OcaR3v4dN6bBTB3we0o+lHlUSh2dhmwaCOQOfZFgutwmzExp10MOlXV8rTRunX+GkyMR+shOBV8NaNxuu5PiaU81cDs6NgpLPemSVzVjBARBmBocp9Zab+y+csez89VOHuSrJDOiSA8fHLvAvOH/I+wjoG251fXHTxZu5EAc+WXfJUtHB/auyOXqFKDA7orpt5F+jvSdXtM5nJnLqqynt9D+04KsBiVCK/9FlrcYEGlkDnA0M98RLcetb7eaPY8ymeDIS/4WU2T9+GQbnzNDnmhDLB9PcOY4HGJqYwGfVzabXWiema3iW4DHSCLHZl/MIm1F0Udg7+B6RApynPa7CTCVI9SKzhvBMUiPAniKcoH3bSOmC8Pb3/xd4wps1dsvgPoD36DfMGVE251VrLYMQzHP+vOB3Hpc6hb
 uZukw7ep
 qpg2mt6KwlY2Pvs/pnaclaSk/joQEW7QbMfCAiQfbG4GqLtr/t1pDjin+5zawDf3EFjI8243safgUvauG2W/1B2YFDTD5otj6xkQDmlikApsgNraxl/BJnWtlMvUwk9tcLRAPtWiFRzh0JvJGi9ndbYOFB2YtrPQPPVuIypQ/kxcH2LNWj1iIMoNhg4IbJUgb2XFM+Ylf4TwWXE5oJpggJ/pFProdAltH9UGp6VHiaqNiZxQHcWgNJyScaYIC83m9bLzRTDxFJ/qjYWwk2mjfOyf/PBU1vj3ZrbpR2uuPOBU2RYzqf2hwjLV48E4xNFNEgjMv364GhyBmgVUre8xcxa+a4p8VDh4fAoPZXvc/mx7LWoHD/c6zmFn/udw2uMI9J+hU28pUrtlUlriClkugrZ2A9YYBA2MOFQC6+NJUK6m+R/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I forgot to mention the tool execution case in my last mail. Those
microVMs start, run a small task, and exit. DAX is there to save
memory, but the vmemmap is allocated for the whole image. A 2 GiB
image pays 32 MiB of vmemmap even if a microVM only reads a few MB, so
for those microVMs the DAX setup can use more memory than the same
image on virtio-blk. That is also a case this series fixes for us.

