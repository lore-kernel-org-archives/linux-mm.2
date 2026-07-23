Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2785C531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF846B0098; Thu, 23 Jul 2026 11:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA72E6B009D; Thu, 23 Jul 2026 11:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD356B009F; Thu, 23 Jul 2026 11:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDF96B0098
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:49:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20EDCC0564
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:49:29 +0000 (UTC)
X-FDA: 85020476058.23.4F9042C
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2BC63180009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:49:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnzLBB+C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784821767;
	b=z8q+9GNdRYRhu4M1DY4fi2vKZhHEkoTueu/o6UpXtmfzTDhk7vrlU3rV4V9P+x5svbVXHf
	/CAJoxrPy7qix1iHbJ70LAoLxIUQ/PxiGzWpW+2a3Ry0rKgOQhjaQOqvRezixrmhw6IG6p
	XP0CI5Z5VXT5pf9eHwcAJECh2re6TyI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gnzLBB+C;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784821767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOEwoWxhkHAzPl7z/kfmfgEp6lBpU3TPL7nXC62jp0M=;
	b=gjR5kPkUEM2EMiTai03x2HcXlBQbJB4qH4wOxkvw+A3Xoeo4V/V1hDREKAD5K3b15cPQLU
	61dXsC5uGf5W7zwAZAR7HHTE2nL/J1M7UKwFSQtAOS5fhwa779ety394JJyK/06sZP8JPO
	yG6YzIOnGZHpT1WzUs7oz03I5qTQq0w=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4728c12ba97so511696f8f.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:49:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784821766; cv=none;
        d=google.com; s=arc-20260327;
        b=MapcBZCCK6PjR2A7jI9STvpMdMB73qqcyf90a43gjHDbM3Le2FeqcJJZIWC1QXauhX
         rnD/eqrBcCiTgcc4EwYydUfW5VOdm2XmN8B1DcpJWR3v5lxDxvOIeoudxH+SgH6Ib1I5
         qnF+ugBiHFD/xd6eSkOl2aavWd/iyP3Zh3z1daNazh7F1ppDUppBhG3qeNj7dOaTwILW
         ZmXRpev99kuSsaSQg+Z4b0VC0smQkZuuI6Z7jVeLsyLmX94jQALr0IXNgvqnZRcTtTIE
         kKsHMx7ibg6ZTJ6kqhLwzLCVoZ/qI+FNTYolvn27D/byzBMKw0cek3boGe1iyZ0mWkZ7
         6Vtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VOEwoWxhkHAzPl7z/kfmfgEp6lBpU3TPL7nXC62jp0M=;
        fh=N8mZAJ9ConV/sFCWXVmJIHUJNy4XBERB0SVjapxSGeM=;
        b=WGPpOiSAO3DZ+y4FjmmbLxA62TkiOUivlwBD+Q8mockCePt1bAdwxH1el0dsXgmUlc
         N6aUuRIDs3XaNgcF9obxv2UFVCPAmsDSsK3/EVCpi40+LvdIbSl98b/yeZ9NIOUA/NF3
         6PpeaUWeSroAV1Rv2MtKopU9kSu2Brkx7o1YbsK4Q6USG5uisCtBcePfLocLDASJzqTs
         /aNOyItWdta8Y/SfDYRjUb63IXFeRJS0sc81QvRZpjreVI3/Zs5hlLUM8AmFmiUu8dJw
         qGHppBgn+1TF4jqtFy8PDats5uWOfnUzxjBUjT6C5+JParC0L+a2ieMBRJ4tIx9aMRYZ
         DqWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784821766; x=1785426566; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VOEwoWxhkHAzPl7z/kfmfgEp6lBpU3TPL7nXC62jp0M=;
        b=gnzLBB+Ce8z/AQbNoQ5FW2l+MFiuT72LpUCaxa5Z1k6DlH9MweqS8mmcjLHjfoIcyl
         jDdFpz2vr9on/G8P1pPBvZi5fKh8eoX2I7yDt2+ibdWvAPWcfLTbvJNvwhGVHBQxb+UU
         uj3qXlI4kPhYEIjsh2zdM4r1JBh2O9EFi81/pgian8i2DFU9TOq8BtiMr/BiVI6AzoeL
         eIuqCUrhQRrZ2MnwG0v0AaX9cOBFaSIp3S2Brmfq3YdzArnFgP3CjlDeSI2LcjdNgGhg
         3WitJKxfx6oxTA5AzicoYs7Hul9JnHVKJtNtDAaJ1MDIEYA1A7DBeKiKWBEF+/ubOmbW
         zkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784821766; x=1785426566;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VOEwoWxhkHAzPl7z/kfmfgEp6lBpU3TPL7nXC62jp0M=;
        b=mzCFY9SW2aig/fA2I26R3byKMoTDL01Daytz+BSor5iZdgfGwBsepK21u6Ruddlpgd
         VrveR5ZU64bvc+L/i/owzoqT+uUaYTNqaYQXGVrhX2ORkr+Rw8AFtzZB6ZqeTDm+Pljo
         KSroK3j5G5d1X5v0dxamkkOScfr3xag75k+TQWsPmC4Dl8esTvunKOTouxwRxYCRCftG
         izcBX27NRLv+PRWr+biDu45W+ntQylD31SQkn/JQbZiSVOcPxXW1fJfp5E7KvS4qaMt/
         uUBq15lrcjiN+e4i6S3pV/AukowX2C40cGtxVv4HetnG5XPJ+MTPxK4HSjwZX3Vvv/v/
         wQaQ==
X-Forwarded-Encrypted: i=1; AHgh+RoYyl/4HTVgypcFLa70XLthwepB5rCnt5nWHy7xL+ILp6gDJYVVFVYswlR0Cey/Z5JPQcx441lYIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz891pzkZrYh/6QKApmUKN1uuL+fIgwyYXZoe6YWa/ExhxA2CUH
	XqAQH0WjVU36hA/FdQm8aZBR31NSYx6M+e5+A0mRdhUvCWGrOsCxPDiPgZNPemOmhsaHHxpH4h8
	qvgyYgzJWKdfEcSAcXITDY2mQxo8WSyM=
X-Gm-Gg: AR+sD10g4fl6mjPUl0oHopn2uCKz++RyhIJWV+txBQAiq48bT5oTXQ5RFazCW88CY2L
	lgbI3P866LFagP83G4si9/es03MReK8lz2ewqCURQFaieWXkcR00Sl6MsNPkRdapAJpMPShXfk8
	PLbF7aFGV0i4g6nK/rn395IOCQ98f9vlMnQpKOB3c06eONHJn97YyHbv/olmAAF8BkJ3eK0xb2u
	AdA1I1p+b0CvYiKsW0IR7ll//uCuLgGaBMx5zGqN+kkd7/W5Wq0qjZhfWcvn+orTLlHDsKoMiHX
	la+49La41+6WrVv2HJcGmjTK/UDR
X-Received: by 2002:a05:6000:2501:b0:47f:93b4:2df3 with SMTP id
 ffacd0b85a97d-47f93b42e91mr1757333f8f.60.1784821765658; Thu, 23 Jul 2026
 08:49:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-2-alex@ghiti.fr>
 <amIZp7Ual_6Gu86T@cmpxchg.org> <CAKEwX=MxufM5aNw2xW0f1UcyfcCJbtXR_u3cK+coRaC+_bLspg@mail.gmail.com>
In-Reply-To: <CAKEwX=MxufM5aNw2xW0f1UcyfcCJbtXR_u3cK+coRaC+_bLspg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 23 Jul 2026 08:49:13 -0700
X-Gm-Features: AUfX_mzB18adyCkRw-msPjHBQg9MLv97pbCpvES0UbLhVV73Fu4FFLlFb-JLgCU
Message-ID: <CAKEwX=NmAuo+-sXzQj51-sRGdfcjTb3_KaW2x_4DnjQM6n0piA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: free synchronous-IO writeback folios directly
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: egysnnkyfzo7wcby4eijqb74yyhtgdzy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BC63180009
X-Rspam-User: 
X-HE-Tag: 1784821767-410057
X-HE-Meta: U2FsdGVkX18kbNg8aVCpJUT87AkAcDExudwT51Rch+xdzqEBX9JcamFH3Lc4TO//2MHQXT1V+qhNS21T2VMTusaxL1Q9CbdNDmgUPbVD7P1r0liPpyDppyYSCx3pirPsCPjlnCl2afQDySeemcuviyJohezEqifSgKklL9ohq5NAbKEt5fvO6TBaCtVFwodGvro6GXL7+Kjrn3c+1gq0bMHHbfBrzyjHKNcJP/5E3mm5v08zCIXOC+MJpwi6hKlGroqeRGanZ6ICSj85aEZ2+Aitz8MXgSuVNp5vI3Aobh5FinpzpEa8h161aHeRLXfDKPBCjVZ4ja5ihX9pHVDV6VFVwWLudkVR0CjkNRe7LYcVsTvT7DQ1PCAlXpE31ZTOCly27sprFqpK/80x+kcBTLYc6yO75aa4yjp65+1KqOFlpa3FXwINhAgJwXGwLTFw2VueHza7ZwComT9dpghh6Dm4/80fwMzCZPEQUmNwHyfhAXt3YzT14gsbU1+lWfUhqt9eLOFwwKgylLkFNo3ynJG5U5VNhltE550BXValS5JwX48IobAKoXO1bb5jndXn3q4vlhIYv5682pSN0xW0yovcWtunKpZX863lYhrDmWYOe2ehDeB+9J2cjdkxTDrnq/d+ld3wuR5PE0NtkiY87VfxiReb3HJuYTjhlOY958ia31JfizAsqPsDXrsPo1PEnkQi0M0atHrlFBCALYTAKgla6xau+O2PmKy9Rs4W9AnLiqt8kXigj74xSgrquMmOV6FGsXabuxPdIF9OgmEZ/6Qp6YA+LV29WlVtmckeoT3SF309GFsMVDGtqVRwNu908SAiz9f/DZomYBTpxV0XOnLTRZPbJykJ/f3RfLYnJQ3+C72okhqQv9HVbe+D/t+2HAsbTJIyNvUc4suddPTSgRV6kWde8v5D88dH3zpvPzL8Lqwz80saxWhpwe8T1qHF3m89FaWLn0f1StYj5VG
 RToG0+UI
 Ad7SNfroCYWrxQcSYSGB2brSuqG881bg9YGoJ6Db4qZm/aszQBhC0Hk+qlyO2aqjphLZmtYS53ZjXIOIpISH9MdpMDzBUMRX7lrR1Soi+2TezDA/6XIu2044pulubb6ukY9SZ2naZN4HnzFWrAV0MVZwJJPRxo4B31bXqfOk9/APpDNWA3Qm7ABB/B2WTvXgIVX405WgsidXznsQWUjCyvt6SCe8SAlj8VfaQoJ4O/utFPtuI9qr1ArMEcpdb0EEZPL8/dNlCJqBGsfk2JK7jZCC3YEhw8n90ymNvhe1U0YBh9ssk0YVKQnS4HZSu5pKIUhxS+7VtMnhN+JuQwiDoN/xHtAZboyoXa4oWrggd2EmL9G7jTpaMu//+9pVd6CIdnwqi1H3eqZgPWXlkNjwOuDr4ynu01drSRN2+ktboNdGcuY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 8:38=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> >
> > I just chatted with Alexandre off-list, but this path does not store
> > an eviction shadow like the reclaim path does. That means no refaults
> > are detected from dropbehind pages, which can fundamentally alter
> > reclaim decisions, zswap shrinker force, and pressure detection.
>
> I think it's a zswap shrinker bug even before this patch. When we
> allocate a new buffer for the writeback request and add to swap cache,
> we erase the old shadow :(

... and count it as a refault :| Which is even worse than just silent
erasure. It throws off all our workingset tracking heuristics,
inaccurately reporting refault on a really cold page (writeback
candidate).

