Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA0C6CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 03:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A8F8E0045; Mon, 11 Aug 2025 23:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6947C8E00BE; Mon, 11 Aug 2025 23:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584768E00BF; Mon, 11 Aug 2025 23:58:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35D1C8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 23:58:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D50E2C0195
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:58:43 +0000 (UTC)
X-FDA: 83766748926.06.7F00985
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id E08AC1C0005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 03:58:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A5W5Xq9h;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754971122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsF4i7owr2w64jophO+zO+eW0GN81ddWs4iypkKqJ00=;
	b=akPXmhqpw7WYRAxBpKtF8AEpUZNIcYVIWuZ4eLiZ2ZaSbgCeSK9WHxp3bGnf8RxbOfkfgS
	oqEohdJ5OM3jVl+ic3hI6l0WokIfN75D45n+JPDn3rSg5FJuSVyuFjNKucpcPzST7pGLnc
	qdzqpP/WtgzcPHgfSsKIUwdEr4SjcYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754971122; a=rsa-sha256;
	cv=none;
	b=vaeHUWYfnfck6AfyZQFeFs9GtbktZxxHevIu19N9rV+GYK8mWhfOrwhhbXTuHyqUSP2NvJ
	G9wXQ7Fi6PShudpuiCjfuwT73tKTHI1gQDc1j6kvqL48uBskEeHId/5Rv7e89UMB66urbC
	C5stIEgTSYSLdVq/KZoD3Cz4bRaZfw4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=A5W5Xq9h;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.46 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-31f4e49dca0so6106606a91.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 20:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1754971121; x=1755575921; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UsF4i7owr2w64jophO+zO+eW0GN81ddWs4iypkKqJ00=;
        b=A5W5Xq9hXitzL+hpzb6GnPI/yB6fU5xe2y5lf/yNYgQmbW1+JjexPyLfOJ0mBX8woY
         ivJvy6EptI3u4fJnILDlv+QbFSS04Xp38839jFMW0y86U67VnSi2wtBej3xIIVd829qp
         BIqBQPmOxrSw6P2mab2nJF5xf1Vfeeb+r+cEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754971121; x=1755575921;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsF4i7owr2w64jophO+zO+eW0GN81ddWs4iypkKqJ00=;
        b=NIWuOfLtob2VmOPc9944vCSZjwGq7d3WNbnTJAfjGPjE8yd1p63qYJaFXOFYWe03cK
         fk5PkDoSUkJXcmSWxYvJ+paoKZPfSQMsaDKaHAslMxFT/H46ZhR+CciOJ7JiR6Nv9wEZ
         f0DxqBRQoWt9LPQhn0eRU/AZyPRNvq1JGOCW/MeOAUvCMkBLia1zlJkgOIb7CsPV/YEx
         O3HbhKyCjOTkcnc8VAbYAMn5S4XI6xhrwRIICL/KXlbjF/HrADGOfiHbJb4eTHGydDaH
         E9/hdQpN6zdRN6sQHPfp+C/gEA3n33OiRAqtOkOPJB3Qak4GvIv+85SCLRP9iJdaf+lH
         bKPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvRW66g8GWJanPx/UnV2Upscbi0tySxdadjdVGgeddN5HZ/OwOTbmoIgV+Xhy0TXoJ3RNPOgPORg==@kvack.org
X-Gm-Message-State: AOJu0YwOkar1aNqPXFpOfGkHxB9qP5sa7xnpbMMwm6hlnH+U5wLrvLj5
	6YhFUmHAWGTRZFr5KVir6UYjK95GuSRzsPuPc+gz0a3Cmj4rpwmW04hSc68iAu3Qt/+XkVHx/u5
	xwZk=
X-Gm-Gg: ASbGncsNpyTnGTB/EK8y2rNw1e963vaZoTx8NEEbTjBGz+AGBlHo4MpvUsmtzxwk4Zv
	+BHF1tWGRzBWnHlJ/NAg6EKxeX2cXWE3uk+eKaP7GZLqsdb8EpDrxdvXYEt+9Xv6yXgbhxzPoTl
	lPxZievZn6NH+emrlb5gzgbU8EpxwESUJiWgVb00vTVdsVakJqiIsF8qUFHpgmA5DgW/2UVe2pK
	dM/H60xz6Nd21UAJyfskoztTY/Mr+KgxYuP1x6GlmqSCVtBpQbyHxqLnGcg7UdTvaIHs0uhgcAF
	zOLPDq8U4748DfSM3mOQCMAlSJGuCtB7/im3Q1YOwIj7PQLpibkOVWiLksKnsO3UHDVbL+NyMXu
	6alr47lxk7wagRGD6n6+9C+SrFt1hPNONEAmN
X-Google-Smtp-Source: AGHT+IE0YyrVY5Vt8OKrl33IrgQwBQBekiXEdcW95C5mTt17WuM8Sondsrrkn0NdMV5pujBh12Fm4w==
X-Received: by 2002:a17:90b:2251:b0:31f:1a3e:fe31 with SMTP id 98e67ed59e1d1-321c0a11aa9mr3103600a91.11.1754971120678;
        Mon, 11 Aug 2025 20:58:40 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:e529:c59e:30f9:11d3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-321611d846esm16436888a91.8.2025.08.11.20.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 20:58:40 -0700 (PDT)
Date: Tue, 12 Aug 2025 12:58:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, virtualization@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Dave Kleikamp <shaggy@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v1 2/2] treewide: remove MIGRATEPAGE_SUCCESS
Message-ID: <lky6lmpq5hsflc4rcs2hev5i3gctvbrppysttnzo22r6oiryw4@edfre7sprwk5>
References: <20250811143949.1117439-1-david@redhat.com>
 <20250811143949.1117439-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811143949.1117439-3-david@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E08AC1C0005
X-Stat-Signature: 4qm9mq7mjkyo1yrdkdtkdujigjz8b6a6
X-HE-Tag: 1754971121-377061
X-HE-Meta: U2FsdGVkX1+cotanrNbR8KGOm0VqsBpPtFdX0p8D5NDLufjncDNXJvebAVdNT89Z7+k3JgyUU4CCwmkibMPzyQzhT3ERVjEkBqQ3IYEJYuiJAkgIdqcBhdLEbddf/iKuKJjLME/b8Xf6KRreMcGRKLr8uQA4d0PtkqNzscKyaVxO5cIRgRJQ28K8e+8J821Q9Mw80ov5IxKPRkoOmcxtmNavmOgjSWIqPkw0JSlgQoBzv6ZrZqw+sO5x9wGfeOLkyszMEjiPYW0gfLCqP7xqsqQuCimDODGCvHJuenkx+N3ODoE1Rz7ANk/jZJ639tal5nmubZaIVRuKPhe9bMmP4L+9XpWur6w+UW4dOekjDdFeTAcsC3ep+GYfySVchCIKBnz0a3athsNssDz2K4lFHNvfY0R707mB/mVN/TE5AGyhP4t+0mOBXuLlJyLnDCJOoDOLp//kYnCC83FgGhP4xNZmjt/7Bi2dw9CI6vvq5J4Shq0hpVh+p+My3vhdI88Eqf1BKKWujXc91lrRo2fyUgPFpUDYBkukj710zv50FfDhPUglIIreAO80fKea6x6Lk1svvJ1Rk1O2v32qIfbjUSSlkgo2JV7ddsmsnG9j7CCRRbOv1JsYXNxNtRp9OSlEeArCH8LyRifnvHbnsqZL46bL4vC8aQ3H1nlHNtYM9M4olLNkwqR65/q4TXuNds4ruZKPoMFSO3wGqLcs4pwONUtRxrPQshnDcM7QQ0G4C4N1QLI7ROMFUoSywZ7BskG1JDP12/N2fKLbiV+aWnsmbEB/LvUwqSjMN0ZoEPpmwJ+o94N6YgNqbuKdMj2zojHPUD1+fwIOjMQZgEXNnZMjXxnEIlApyDaB/wV8kyUDTQWayYvvnbm3hcMZu2+yxHlYM2i8jkAF//g57iYBGfMCktM9/bs4f+KzdqTglfIwxnCNodnJTxoEuqVuAXMuG5XWNV5aCsafhwz4+PYXWdt
 MmVsm3Nn
 qXkRJXCP4cjULZQ31jpUVG5C1BYeZsiFfYV25Y57x7wuXhFwKNjQY9+6A4grmkWdknGh+zHok14KMUo/oo+U3gXfuc4C2iyo6/NPQDKgCdZb8fChPW9pb5kMtE4pLkyTobfUcR0c4FGgkU/VC7zENKj8iI6l3M+EvFYnLnzCaJa4CAH+1VMUHn/dZAyJwn/y3YP9gx5cVatr1NmG0A2WRtBgX1hmSb5qL65BCfIqi00Z2mi4RJST3yn/eUyi2grmSZ0aNGAx9Q7DNyrBQ/pK4dEkMUEOIfrcy8oup7NYZNgruNipbX9meRuGMT/fSKz5LTmaeN2a3uQ0ha5oIAZ1nqitUGjcOcVoGRTbnNzc+DU6p5r7EBk+G6V5k6BFCGms2UZeYMeYWRA9IYveX9M3Q/v40PkvdICKYVlpKbKgf9uORe97V1BHASY9jCk+l7rCc8edyAnQrHYFi+W4c/MHiPJmZ0togFO76352EnOYyf+A7VEQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/08/11 16:39), David Hildenbrand wrote:
> At this point MIGRATEPAGE_SUCCESS is misnamed for all folio users,
> and now that we remove MIGRATEPAGE_UNMAP, it's really the only "success"
> return value that the code uses and expects.
> 
> Let's just get rid of MIGRATEPAGE_SUCCESS completely and just use "0"
> for success.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

FWIW,
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org> [zsmalloc]

