Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB6FCCF2C7
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 02:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363C26B0088; Sat, 17 Oct 2026 22:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B4D6B008C; Sat, 17 Oct 2026 22:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250DC6B0092; Sat, 17 Oct 2026 22:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F296F6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:59:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9AAEA7D24
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:59:12 +0000 (UTC)
X-FDA: 85334240544.10.F56EB72
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 264B4C0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:59:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W2deLgk/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792292351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOT2xhgG4HvHxboNomCCB8zMtEcw47CfY+5UMisvHbk=;
	b=gCY8UM3jGbZCb7No/Tfn7TyJU315tuXbl85YwVgG5cjVTnvHXexf3cSpMVWT7aoNoyw3BU
	s78NgwzkhaBSj4NSdQS6Km4GoZJOelOfnI0hesf3Ls/d8B6Ii0WcxlXWNZa/0eFcA4YMxa
	8zY2MZtvX/srPcMKEIN164ZsCIrpro0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W2deLgk/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of devnexen@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=devnexen@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792292351;
	b=YloaR7qviKG2w/3lSCvJoK+6+aNlHqPwcuOCUw5sbAHSHJYXpaeUnyjAMghijKuU4Dbn/g
	pZncKWEXE8XGofuGR+lvpooexRvM9DkupUPZFhUiC5ebRRfzNRTB+6Nu/afPlOzG5ZpEE6
	Th68E5mzyP9SkVMn28hqlJ5ikVX2gGc=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso839157f8f.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792292350; x=1792897150; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xOT2xhgG4HvHxboNomCCB8zMtEcw47CfY+5UMisvHbk=;
        b=W2deLgk/ZQHZTX1NzwtvG666ZUVaBt0QzGO6W7Leu0qyUPO6+qdGzvgtgEdfePE6RN
         69+orjLaVzr26qTnWP8uw0RmKbtXPSkQpezskqabDqYApLJZ8n9IX+854GaIBv/oxzGS
         dbnA1oJXNNx5moduVeZwU+2yxD8oDXtYrJxhlNPyzo41V3D1Q+5YigfMwUtxk9WNrKMV
         rpR4C04OPALkaNY57DagaKLHdQaPYNoShP+NoXXOnvOegF7LhEE3uKFgI0IhSZuVnRw5
         HsQOv/O1LW42lGvnzMhFZhgKtinJ0bef1aN25/MJPKw2urD6Cpc0jy2BlCKAHIyA8DCl
         N7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792292350; x=1792897150;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xOT2xhgG4HvHxboNomCCB8zMtEcw47CfY+5UMisvHbk=;
        b=x3G+FuhoiOBfz1Y07iz2WHljnbyN/nu6IkSS0yf2LsoxUbzGgbfE7QmEfmMbLhesEq
         eJZAPDFV7zwql+eOl0CcGJHmCbONKpUbcc6pNYJq+pyEAKQIOU1jZjFbLgD4sM4gW6dW
         RUU1ujUHqPvztyA+njmekpAZLsA0XemtbJF8w8vsQm679wlFSYQ5TQ4iXzh7+NJMq35q
         D7ZiWQhKaQLokaKxVPHTyf9TFHztLqhuHF/ogITx/CXJxRTLNX7tYUcrOyIsDyCJRfLf
         fq7ILFGZ06pnGTyODqCjb3F/dzeEad2YPrcGPvsqYwEm2J14G2Ipi1vgvG6R+EzsWptl
         kmmQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9grNlypGPHskQjn3U0ztlWSs6uGkccGExbmmK8yZgdnHrM0K0Hq9w7tNl6ToAdSAR986XxY+LSw==@kvack.org
X-Gm-Message-State: AFq9FYIeL1qJrXsaduacGUuO4RA8OYoSjWVjPKmBnLetxqraT+U8d/SL
	AKSsA7M/DnyShd4nxanBDTYTcvghakoWw9Ln01J8LKnhc+at6IBg7gxPOZO+eg==
X-Gm-Gg: AYBFou3JbaGHcJC5/NFm1DqUJIwtoivWj9fyyfk0NaxSvagbqllRJS5Jy5NFRAFFxm7
	Hh2ONllgN/AgaQxjzKj+q79xutdjyiF9jX+U4Qxdd3qqJ5RkIcy53W/fRKbq2HwlpHwo/8NjwP3
	mxhfHxdqoPjO+jjQ3g+3MHwPPfrPfOnZrFjoAASpgq/lAMn7u3HO7w2SClxKxyGE3gvnFCbURQ+
	Eu6FMW5/V5qNWvh0A9ZXq1qhmqGQIPwel4H+egXWxuxFTJPXOHbkECay6UFYv86dplwLcEZSjpv
	HTeEDDdhsKX90D99Gox+DU8JbMlY3IPNO5Ma1lsU322UGysFbyMNpmX4U3zb3os+/xhZd55YCNl
	BfOeXWe7mg0XpJ9hh6G0o1d1ZOicLfGT0kh1rc3c3c9tWfB7jzKLHZU0slOE6NiXWFAQ40G+Dxl
	mDuGSszR+0SIFicS5wb7w8LSsD1HkhIeYyIqQU7XQNm3oNK0pEWJl959Yrf52yxTfGHqbtp4iln
	VkwRdobe9+6TeDCp02E4ZGv1g36mkDdQVjbfD1hfGdlfxvPzfIUgwKRQlDo7lMzML6W5w==
X-Received: by 2002:a05:6000:2c0b:b0:48a:f3c6:7bfa with SMTP id ffacd0b85a97d-48e07fbd825mr6459320f8f.52.1792292349489;
        Sat, 17 Oct 2026 19:59:09 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4f8bd9sm14785161f8f.35.2026.10.17.19.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:59:09 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Kazuki Hanai <hnkz.64@gmail.com>,
	linux-mm@kvack.org,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: Re: [PATCH v6 16/39] mm/vma: only allow mmap to clear VMA_MAYWRITE_BIT if not mm-managed
Date: Sun, 18 Oct 2026 03:59:05 +0100
Message-ID: <20261018025905.201296-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
References: <20261013-b4-mmap-prepare-vma-flag-sanify-v6-16-1aa3c9b139f9@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 264B4C0003
X-Stat-Signature: mbjwk5n1yis6dh3ggu1edpt6366nmo94
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792292351-340660
X-HE-Meta: U2FsdGVkX18hZuuUz7pLDEQ0+Zk817pGowC/RLkKw5pCp6LVrdmSS/dimCQRa71hNeFlQGoBHgLFJqE4qnJiLgfFn/3s+Uwnc3ipsxnCWe4K+uMXXwKHUALxycIZ/olvWKM5+HbXxWlUFWNBKYha8umbu+KgIaoNq/UY0z8Nhvgh2vPC0cg75gJah1Ti85g2NSzpOM6wDkDRiDKcj+Y/mtzF15pQlUlXanjUbrZefPOyqcy0PkcMKp9IbxRp1haFY7B4g4JYVKN0zZeETU6oiwZxCPUMw/gzVuPzgV/RfQKVfUnzfYVVgMLvW7Wlg1VUXj/JeQ6E/pUio2BYQhwfKZ5G6S3uI2b6OtWYKn7HVqGIlaLJ7e0IB0mOlLehR6hw8j6n5BIGFecng0iNMOCttO7gQHyKDJli9D4MrlEy9ksZbaPGxg6O30lXzB0S7VkojQ3ztf6Qi2zgi43e3v24L6QF1u9pcUmawoWtq4m00CAeMAJ8miBwIUYuXgz4BiZODwJ+NBzadsJMVUmKQVr54EHbaZxp5zqPZKSfPtfTU8A0zRwmLkQdrIxozd+c0wBmlI/8M3Rc/2SDXzEpC6kcLr4DTsnEy15NjhQDQTohLC1sMa+5Ry2WQ0ophOgWmcLmMqmk1VZT1yHHas+phCBNfWvp82NJdBiNUqyjakhxLWFudz6sDwb+/6eLQGpsEZJNIGu1TUy6TEJO9WjdlL1zcbx/zbVPM8jedHijXfJr8GQX7akrkHzX1CVeMVPS0dozQ5fXR5sUJJBPcUhL+GaUglaWyFNF7HaU9wbUhlEvHVJ9jYKvIg7T6LKcKSif9MM16hu4w5Wf1Y4gaGA+XcVt+nuxDS1uZ5LqqWJcymkrQSAbCGv12sKVPsQWJ9HzDvVZsc9dTunNK4xuyU11ozVB97m5RUGz3ffhAcqVjZQKWZcQAiBr29Uas+8J2y2Nj3APCTVf52pxwOqfKiSq2E/
 3k13MLML
 +oCKXW+8X12Uj8SWLFITf24r0HTJ68DFO/jvEj/Of2DAXbBbmY+zR8QM2seIrPOWlam3n+pQkaBTAQpZYDn3iwF6oJm2csio70EBMd4HYagh8ErIUk1CiUW7q4dqfkbap9vT4Kz54sG3OYfL6DT+MhV9wIOFxgBa3RSBvVe0QdND4oSMsgh3c+HN7RdFouA9T/nG+gwxLJ7Td0ZPlCDqi8iPL7ADtcAZaKFe5D8c2M855xkGB3rTi4NfjC4cQm1WXmpEuDCgDxZnbOE0tzsUQRzZxbiqmjcidweePMV8MMfHbeU5PjKA/09p2PoHToTMno4LWwkLW2CecM8n7WIIU5GcFeZuOrCRRi4i5BCxYwIkSHrCrrJC8WbpYwnvzACe9hXqRTYckXpTCk/eHNyzm2cmHYIMWWTBNC2ikfLt04cY14ktrX80kROK1+qBkwOCMp5fwhGhZTdTedQ83zK/57qzDRVmi/vnRLUwf83R8/7UuspiCiZMA1PTd56RBVxGjXEigswlJiKulnsawaSLXCmv+Ku129xl/A9cI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

I think one site was missed: usb_stream_hwdep_mmap() in
sound/usb/usx2y/us122l.c clears VM_MAYWRITE on the read buffer since
71c610aeb177 ("ALSA: us122l: Prevent write upgrades for read mappings"),
but sets neither VM_PFNMAP nor VM_MIXEDMAP (pages come from .fault via
vmf->page, like the PCM status page in 13/39).

So a MAP_PRIVATE mapping of the read buffer, or MAP_SHARED on an O_RDWR
fd, now hits the WARN_ON_ONCE in mmap_validate() and fails with -EINVAL.

The VM_MAYWRITE clear is a security fix, and the VMA must stay
expandable for mremap(), so converting it like 13/39 or setting
VM_MIXEDMAP seems the way to go.

Found by code reading, not tested on hardware.

Cheers

