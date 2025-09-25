Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A40CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354828E0010; Thu, 25 Sep 2025 04:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6CA8E0001; Thu, 25 Sep 2025 04:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1308D8E0010; Thu, 25 Sep 2025 04:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 004868E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:23:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A992D1DF316
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:54 +0000 (UTC)
X-FDA: 83927084388.06.BE5E23F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87B8FC000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:23:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gGZGVgrT;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqVvZUfdgTpL3nfasC58wu42gflIPAUI1k0hSCR4jG8=;
	b=qyg/MD4j0vpaVz6IuQ3v4sw2ootSEAvct5jYsH2BAIbZ0EZdolAow8DRagqo4Eq8ZI/o/F
	BGuhn2K8VcjJiRVdJqzmldw3xCXi55awXPjiPxTRqlkxG5HRq/uFqe0pzWEf/XUOmlcV+h
	OluNxz7tgKS/YtWvbYPtzvbJrs5+Qs4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gGZGVgrT;
	spf=pass (imf22.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788632; a=rsa-sha256;
	cv=none;
	b=E9nOgxDTLZ0TCrnXgoHE3IwEzbkSMsAIKsFwrzjZ+yhmbUEMukTxnYMebg/jMmub+3dMkE
	apL7y9UDVgY/c1loce4qpToGg9CP9n5zPa0XsBtleh8DJjKFji7omJJVBbu+rizWY/G/JW
	BBtkRCjhlDycV5aJDk2VGi+15gsNMyg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758788632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PqVvZUfdgTpL3nfasC58wu42gflIPAUI1k0hSCR4jG8=;
	b=gGZGVgrTa+VChrLTbUnfoWGnP80NnKFh2+7AKwpI4GCfbTSTjSy/tCqzIbGJWoxSbX2h5Q
	zMKK4IHAyXg/JhBOVWjavgRJlZMGsgvFtUnQNifL7ydJoy0R2YlV/FRKXUa0qh1g7FAlML
	cDT+ylwBR653BEojp/J25I2sAuc6Vx0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-UscmGpRpMeGexq-oo151cw-1; Thu, 25 Sep 2025 04:23:50 -0400
X-MC-Unique: UscmGpRpMeGexq-oo151cw-1
X-Mimecast-MFC-AGG-ID: UscmGpRpMeGexq-oo151cw_1758788629
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e1e147cc0so4647225e9.2
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758788629; x=1759393429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PqVvZUfdgTpL3nfasC58wu42gflIPAUI1k0hSCR4jG8=;
        b=TICJ1+pMzRMRQfulhlgst8tLlW51sPQx0FIbV3hCGjtFOypZkDB6Gn4lRJhfBPcmUj
         5KNCr6r97z/vxikNSji9P5qQTDnXLuRGwt0EzgzSrjA0ZwG3bbMkqq1p/IhgXqCUpcGc
         wBNHt7cH2G4/x/DkjfFywCTQPnuV1owoZ7ljLF4SGBLN9Kx7Z/KZdfHufu9mg9K6GjIB
         umakpJqpdJO+YWW7/11iXrO8km/eXnnNRHsIFrna1lXy7UgE7dtup5sf7/jGdVywbfJP
         a5qCbFQTL6hbfX38aU/aHxAJcPm0oLVc0HolX5IHs+ugpIe04WfIIZyDKO4uesHpSxcK
         H7IA==
X-Gm-Message-State: AOJu0YwouzxPK4JRhSGDeC7umnMuMW38lKKSzUJ4wT/hUaJzVBMrnUnM
	ZVgWe1tk99dG2NfE0+uFOAGAkNNkZxU7qYSXzAJzk41ptPNZKADsGEMok3ZVTTH5x6mG0g84P45
	GSCmLpcvxlRQcc2X15ONL56aOQSXtyo3Q/E9Tm2fXjHuyg8YA0Kvs
X-Gm-Gg: ASbGncvGuNk0ZmA12K3e8vjFkx12+ZYuvG5QZk/DMJS76GCC2TESwkiiYGSluvjF4Wv
	U13HSMT+yosAWM6F5ZicHqU9AMkXBdapZpODexqCxVHJB/hdH8RNjgxYpGJ1CxJyeEfSMkk4vS1
	9VJJXbsc601yp6gCUgGaoaov/fS9ThGC5iS9Zn4L4MTGMY62TCfv0tK1YEyMhMpOzwmGtb/3A3Z
	S6YNsHY1MLaFEAOLSMUOacnOefmFO5pzP5pEA8tcgJHkGsqWI5wUgtOpVzCSPRR2OfPAFxUt9Uz
	f7MuayPdHGUzCpf9yAJndwo+SqmwIZazLmPCNNWp3OEJwmHCiIQFXib1tJVvAToPQALBzQnd7dF
	HpVtlHqWzMd3PGo6idBvKvxFnTA==
X-Received: by 2002:a05:600c:608c:b0:46e:2f74:2b9a with SMTP id 5b1f17b1804b1-46e32a1a097mr31960135e9.30.1758788629076;
        Thu, 25 Sep 2025 01:23:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJ12tKaFcH2IPN93xdvFrnUinK0BFJgywoLTw/akd+C2/PdLGf6WCWrFNWTUyyuEy29M7LgA==
X-Received: by 2002:a05:600c:608c:b0:46e:2f74:2b9a with SMTP id 5b1f17b1804b1-46e32a1a097mr31959745e9.30.1758788628607;
        Thu, 25 Sep 2025 01:23:48 -0700 (PDT)
Received: from localhost (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46e2a9ac5basm78621715e9.7.2025.09.25.01.23.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 01:23:48 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.1.y 2/2] mm/migrate_device: don't add folio to be freed to LRU in migrate_device_finalize()
Date: Thu, 25 Sep 2025 10:23:43 +0200
Message-ID: <20250925082343.3771875-3-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925082343.3771875-1-david@redhat.com>
References: <2025022402-footprint-usher-aa6e@gregkh>
 <20250925082343.3771875-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IQIUWPvqHwRXEB4sxogZtsCpGovHyH5wMAVvDD3Z8X8_1758788629
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 87B8FC000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ruqqww63xr7useomugnbsfusdp6wx3x6
X-HE-Tag: 1758788632-638517
X-HE-Meta: U2FsdGVkX1/inynWpDXKqNMzJd0huC6MAZC0SAwa0WUqvJ0KgFu3X2Yln/cFJN8pZebsC4zqthsMQVCvIenuIv2TWQkIGrRVqAurvhT1O+FZEOhwfTmWYvohd01LKVIOTrtwNis/mVBPrP+Qtr3ibT5JUAP6IWgaOaEl5/qe0AHcCcmAqixqtS2ftk76EBk8V9TiHypMeud8NjDHxYnvraxzysuM9CBM6kEEzIfkaGvKQfhixdGSPjC0WDaWaqJWsUSxwESxQj/7xY6O3f5OGrT0Jln90Nxmaz6/a4e7BfiqIsf0yqP3pHQiaYb0r/16IUGG1iKjqesrzk0mzlqXP1MmaqI+rQ+XZSzRYYgCYsDtDfRFo9QWpOvSOl8oDTHMBHdtTenfJEo565vD3hhwEkjE5k6Vxw+JKkS3rGKnBrIalCaxQkMnF3Od3MhuyatdKKwn2dzPY6HGmvAf7UI3bur7LEgq+7g1Bci1ux7CIQDw0091bMsZ0/yoCopUQ2qho5bP80EqFTcdMqJqQS09x9eJglJF/K8Kq2fqQBIpFsUP0WO+06WnmaM+RG8/sj9c/6lRp0abjxpJKHsogUZov1JoOeImvGVYlvxlX5q74gHZ58BbRX0HeqpcXos/k4U+oRnoW94n7syZcsNz3PMiN5qrdqg8K6fepc+VjCj/wQjVTtOy9HmlrTZnluAO90nKqg05zDlivkW8GXL0X785IhScr/1jB8y6BBnlzQG7SkXKCD9E3UvHgJ+T+dmr3mM97lF3K8mdvYiQiAJF/hAocZIDXWtIpuidvUPEKT0OhkL+XWoZT1CJspj2NyDmpddNOZEqsX4IPAkpHpjYyYVC/j4uo9wO6jgzmOrMsjoOZrYFXZp0m/KZVxdKc9sGeofP1MNzNW1993XAXcMlabQaR9QgIGzRqdpwGjF4w0WES31PXhRjK+COG3YKv+QfDV4qNc6fMvu+3hh01hVoONC
 2mtKdDr1
 iHzTpKbdSqlmHd8rLhXgQ/bCtSRbzfqHkh/JxZoGzY12c5t/36oRYr1TblaAV/UEPMcplnfbyjKpOvpabyL5ZJM5gK6YQASrIZmK9gl9RsmrlYuHRoo0Zz5QDYIA5KtyRrC5ttbGjhNjGlWJRnw6HzutOpQuTGvpg6DcfLIzB+xXwJMZVESRTjqkB1ig9Eo8yAZvwmgZeiDsdRllVWO7rXgRkYvQpjm5YU8M6tc0Y44qA8SO4DEr7VNvbSfMrxX69N3cmzkIAzOlN1FF4tm8wHIKd0RI340uOagZ8kkBf2QiNLwvUsAAxFxyFGqAC+mFUmeXTShNttb5RtC7QDSz2A+cTbYslIjOTIoFdEwMx1w1bSs/FugJyeIdw6YiYP8YjD67SNw9L5riIWi4gDf6nw+t1o0iFJjZQMH6WUoMF++GNldgD9Mm0xy7cPiJfKPc6u2X9uW4Lf1PgE5sdH7GVM2DOS59BNzQTJYbJHTKOr9P3eSlsLhQQTCaxqn8OVhcuR41DclE7EN5cTUAG5SHkO3yqYBdZWafOwpSHs5bDJjGQHinGXbipQGktX7smWbCLnK1LQjah1V3LpndZDHbL8q2pB8Cr22FS5Yqzj9I9jnh+UbcgBH1MlY32tLt6hlle7P34prZvL5uEkzzB7Ycn49Oz9Bmy2JfF76ZYQgd3v/tPGfUkUfFIZom0ZXNOEpMIDqBLH8mG+8h6skr+vQvWrLg+Fn/CrEMFVtoCp8oidwJomgMO7ZSogJ5onMLL0KwHSDNHvbkEg7EDhBDG+GRfoTTesJH/dLOaeYfXITxIqR8jD4qjAsQfc5xw+/fTPbs1RJlgkgWCtYU6zwd0uJ72xR4w0fbm5JdrIk+dpMJnWICLqSRtikICBKUcBnfK9gmITcx7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If migration succeeded, we called
folio_migrate_flags()->mem_cgroup_migrate() to migrate the memcg from the
old to the new folio.  This will set memcg_data of the old folio to 0.

Similarly, if migration failed, memcg_data of the dst folio is left unset.

If we call folio_putback_lru() on such folios (memcg_data == 0), we will
add the folio to be freed to the LRU, making memcg code unhappy.  Running
the hmm selftests:

  # ./hmm-tests
  ...
  #  RUN           hmm.hmm_device_private.migrate ...
  [  102.078007][T14893] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x7ff27d200 pfn:0x13cc00
  [  102.079974][T14893] anon flags: 0x17ff00000020018(uptodate|dirty|swapbacked|node=0|zone=2|lastcpupid=0x7ff)
  [  102.082037][T14893] raw: 017ff00000020018 dead000000000100 dead000000000122 ffff8881353896c9
  [  102.083687][T14893] raw: 00000007ff27d200 0000000000000000 00000001ffffffff 0000000000000000
  [  102.085331][T14893] page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
  [  102.087230][T14893] ------------[ cut here ]------------
  [  102.088279][T14893] WARNING: CPU: 0 PID: 14893 at ./include/linux/memcontrol.h:726 folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.090478][T14893] Modules linked in:
  [  102.091244][T14893] CPU: 0 UID: 0 PID: 14893 Comm: hmm-tests Not tainted 6.13.0-09623-g6c216bc522fd #151
  [  102.093089][T14893] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
  [  102.094848][T14893] RIP: 0010:folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.096104][T14893] Code: ...
  [  102.099908][T14893] RSP: 0018:ffffc900236c37b0 EFLAGS: 00010293
  [  102.101152][T14893] RAX: 0000000000000000 RBX: ffffea0004f30000 RCX: ffffffff8183f426
  [  102.102684][T14893] RDX: ffff8881063cb880 RSI: ffffffff81b8117f RDI: ffff8881063cb880
  [  102.104227][T14893] RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
  [  102.105757][T14893] R10: 0000000000000001 R11: 0000000000000002 R12: ffffc900236c37d8
  [  102.107296][T14893] R13: ffff888277a2bcb0 R14: 000000000000001f R15: 0000000000000000
  [  102.108830][T14893] FS:  00007ff27dbdd740(0000) GS:ffff888277a00000(0000) knlGS:0000000000000000
  [  102.110643][T14893] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  102.111924][T14893] CR2: 00007ff27d400000 CR3: 000000010866e000 CR4: 0000000000750ef0
  [  102.113478][T14893] PKRU: 55555554
  [  102.114172][T14893] Call Trace:
  [  102.114805][T14893]  <TASK>
  [  102.115397][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.116547][T14893]  ? __warn.cold+0x110/0x210
  [  102.117461][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.118667][T14893]  ? report_bug+0x1b9/0x320
  [  102.119571][T14893]  ? handle_bug+0x54/0x90
  [  102.120494][T14893]  ? exc_invalid_op+0x17/0x50
  [  102.121433][T14893]  ? asm_exc_invalid_op+0x1a/0x20
  [  102.122435][T14893]  ? __wake_up_klogd.part.0+0x76/0xd0
  [  102.123506][T14893]  ? dump_page+0x4f/0x60
  [  102.124352][T14893]  ? folio_lruvec_lock_irqsave+0x10e/0x170
  [  102.125500][T14893]  folio_batch_move_lru+0xd4/0x200
  [  102.126577][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.127505][T14893]  __folio_batch_add_and_move+0x391/0x720
  [  102.128633][T14893]  ? __pfx_lru_add+0x10/0x10
  [  102.129550][T14893]  folio_putback_lru+0x16/0x80
  [  102.130564][T14893]  migrate_device_finalize+0x9b/0x530
  [  102.131640][T14893]  dmirror_migrate_to_device.constprop.0+0x7c5/0xad0
  [  102.133047][T14893]  dmirror_fops_unlocked_ioctl+0x89b/0xc80

Likely, nothing else goes wrong: putting the last folio reference will
remove the folio from the LRU again.  So besides memcg complaining, adding
the folio to be freed to the LRU is just an unnecessary step.

The new flow resembles what we have in migrate_folio_move(): add the dst
to the lru, remove migration ptes, unlock and unref dst.

Link: https://lkml.kernel.org/r/20250210161317.717936-1-david@redhat.com
Fixes: 8763cb45ab96 ("mm/migrate: new memory migration helper for use with device memory")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 41cddf83d8b00f29fd105e7a0777366edc69a5cf)
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/migrate_device.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 180dbb99c320b..afe3b2d2e7b9d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -854,20 +854,15 @@ void migrate_device_finalize(unsigned long *src_pfns,
 			dst = src;
 		}
 
+		if (!folio_is_zone_device(dst))
+			folio_add_lru(dst);
 		remove_migration_ptes(src, dst, false);
 		folio_unlock(src);
-
-		if (folio_is_zone_device(src))
-			folio_put(src);
-		else
-			folio_putback_lru(src);
+		folio_put(src);
 
 		if (dst != src) {
 			folio_unlock(dst);
-			if (folio_is_zone_device(dst))
-				folio_put(dst);
-			else
-				folio_putback_lru(dst);
+			folio_put(dst);
 		}
 	}
 }
-- 
2.51.0


