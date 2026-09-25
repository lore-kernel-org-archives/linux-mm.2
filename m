Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89087C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6766B0098; Fri, 25 Sep 2026 03:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DBF6B0099; Fri, 25 Sep 2026 03:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8948E6B009B; Fri, 25 Sep 2026 03:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658A76B0098
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:29:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED0AA1405A4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:38 +0000 (UTC)
X-FDA: 85251459636.13.A741F5D
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D97B100003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:29:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUuUzf1A;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29x6ry6DooqP4iiczSQvTQsuf3lHHuZl/pxLTMWhZ2c=;
	b=4BkCmZdtB6ReLB2PfxJzusmo3k0NmYuFZg4+RavE9tfyMY/mA2362y3c/j6hEJNI4LPpfS
	pdm+Bl1dO3EuU7LNMhcYM4NLUpL80zdZ5QjEQmXS9JXV4TE9MdDm32u8RSwJGgzZXehhb5
	UoRltq+sMNsLsd1/bE0SJ60gs91PIqA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUuUzf1A;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321377;
	b=TWxXxkJFpZVtKUqCjFEn9+zhJ+HrFHt7UQM79R3VgiZg0MhAUCF4cn3L/bkuKK+uLQTyIl
	m5PI9BX3oLd++a2P8BYcyGtuzniiAAfgDaV3N4TvSqNyw8nCXyvHkNe1Vkk5fOprxyI1OV
	lF0uYoni01DqPfPFKcGxEbmF8u81GDA=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fbef5018so3450735ad.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790321376; x=1790926176; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=29x6ry6DooqP4iiczSQvTQsuf3lHHuZl/pxLTMWhZ2c=;
        b=GUuUzf1AbhapsBP3PqU06EfWL6bwsA29H09Fi1HwnVrQWdhCtRnsgwUVyfxS+T+QFE
         hNrbHXdFkTnIJorJsY0ePcKBXNYJHqNruXrZVMZidi2YS4Wxr6fG8bq+2Cn6fy/2CWZd
         oVCTBJtak9O464mVc4ts4/zog03iZohqp2vMhKpdPF7EkokSUU/fPWWeRflpq3IDL+EL
         BMPy65se8i4kGmG+ch0t7zM55vy3R9Cei8zL/wbSBWJfFCYr1R2LOCoErMRf+jetnIlE
         mt/3IQcOsJfjXcn4sEfXyyD4yeVuOo1C67iMsk3myDfd+m8n+SkKhPSzwQKtwxF9rkm7
         liTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790321376; x=1790926176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=29x6ry6DooqP4iiczSQvTQsuf3lHHuZl/pxLTMWhZ2c=;
        b=kRr04tD5VhQXqtMwIte77xmCH3XzEp1T+8NHazHU8eHmZ5jWT88wulaGOP/YeGfdrG
         zFs/RmZQ1qEhnkmfEgRYcd1uCdUZ3BkJaCE1Hjk6EFNZeSTfywVlKhOoJqicZx8IoBGL
         epQa6FSihFEn4rg1HqotiUpM4hfEBRgLQ59bKl4rTisjNxM9zzlC/12mqiWFi5iUND9c
         iN2I8VIXPUq82o+ZGbOJbLuz2jH6WP7PsztZv10xs4U6mZ/AXflZUq4YQPV7sm84eg5o
         8Pkwk+2JVoiPkiT1UEj9BslhJtArj/3906kZFFGYOj97GGPDOee7/utGajdcIZpxF3lS
         DxdA==
X-Forwarded-Encrypted: i=1; AKwUvBxeyXlqs7uehnSp9fDWhffPunzhH4vQukDLnObBDavzR973o9AwQC6jD6O7ZcR6666mfIR0ZthEDQ==@kvack.org
X-Gm-Message-State: AFuF++nHGFSWYx+I1+Lq13q4VuT7QgyErojLtGzv+WG1XDuUNKvHUTwo
	vwXlbzgiC/VbQHvOqFMYDnpLO69/Y2DVuzBip0BnFpUQb6T9VoelX/e+
X-Gm-Gg: AYBFou0PQBITAX8KCgMMxbMRWDQRY/huaUoeqXJjrmMBH9X2g8zV/glojjc/X8unBsz
	Af5W41GKV6ox2YBc1B0Gb7e0j6fHhHw2CmyHyrLGj3eKPVwRiayWJpp5SknGtLtSbqVgsaDwUF9
	D9ywNvTnMM1WYq48nGGKccT7oeclDuelUJP2YKbRerMYMC8qLcWN9DatG9Kcwnm5OEdyYi+l3Th
	WGouqC2c8TnotgUUZ/g7iMAKjbjR+y1GayjO9sdhfE4/jTztudu+HprUAt2XGrV6B7WZkTaCIcf
	pF47JKKud9OuDZhXmWZ4FcdVGGzAlufxf9vdbvgKLZw8b3c7QpiCs5y+a3cGCWDxSxsM3ZiGW+M
	tLIiJtTmiiNBKUyBbl9n9deXB6cohDwGrxkZN0BA/zHKa9IXV6QQSH20D0GTr/6M+s4ZC6L+v/g
	3TYVFVTLG3eTzohZ6qlw9QygL5sOr+Ud1SF7IB4li5d8G5tRcfKipDwgkP2d5tZkUxpkRu2NTmz
	a0yhz3ViwGYvFoaSfAGgUONojlWlS4ZBOrUAa6LB8ztiQ4v3Gzp
X-Received: by 2002:a17:903:1ac5:b0:2dd:c100:313c with SMTP id d9443c01a7336-2df7e24f8f6mr44115705ad.56.1790321375940;
        Fri, 25 Sep 2026 00:29:35 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df91444814sm5797475ad.59.2026.09.25.00.29.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 25 Sep 2026 00:29:33 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	sj@kernel.org,
	mst@redhat.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Kairui Song <ryncsn@gmail.com>,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Fri, 25 Sep 2026 15:28:52 +0800
Message-ID: <20260925072912.39496-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
References: <20260925054408.10431-1-lance.yang@linux.dev> <9f63d60c-913e-4e79-9d28-890dd48ef713@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ngqtkhruuj5j3skxisruer6gcd5f79zx
X-Rspamd-Queue-Id: 2D97B100003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790321377-259883
X-HE-Meta: U2FsdGVkX1+A7rdfYewDNDVV/Jf6MF3h2HIpPh884i5ig1HFP5MVTGmb5ElKy6rJfcOFvaxEioDkK7kITKNRAYCsl+v96m/Vu0nNofaokzxjQLNKjfUZMN5ghkI9hzFdhtNv7xzi+gMo7JtjoJ24nw4im7HN+tI+nBDDYeYMfukN5HsXZ6L1Fr+cVS+RIcpVsLOn6V/inXwJTi/tmnVqxO027x7I7OFKOsy+5cx5FjS3LcnCwB7ynmc3bt2HlyIO4oSvGHDzmHZYbNSBZOlZrjW91L7KF9W6CTVLl7fltBsnpzHqFsmSkozHY6hnUn81lLvdiWUynlSB2T/aiGWFBT6+2eD7Vw66/ttrYhuqLc0L0kSHWT6TouXDmR57SbG7RaC7IG72MPOyQKVJslC6DPSh1kZfy1O0wXLokjWjStvk81Z7hSQSt25VXU2dwbT4zwR0nthd2v5KYjHOIJdKkVACdpwF04hUpQlwuaEhRtf4GeVqKiQLxs/oKTO/fTl8KeUfNqSeu5AMnQoOJ4h0ntyUL0YvrvURnfpCdiFUdTavje4HIwMPCaOq9waAs7pfvNeT6pMZSPjKrZfWqBtvqnp5/7l0itE/sFzEhHACc3fM9XXMhZT7cDqcAe6/qLupbIHhSdMfEYh/Px9T/M8p/jIex0nX18bF90iuCCkGfPS8y1UoQJkturhWwWVRDiex31x2Fvg69d9DPan4dx+eVVgCr/GBd83fZmQa3XK+GmOfd8xxryI1+beIPTjITmhSWHzFqgTgjU8h+OvE9dbhBpCJ/fG0/rmyB6l+U3ZHbu+wntC8hWsmx0DcytJHIsiqWGlITOMrKcz8ipPVKhe8mPUMQT8vcY6HG8n/MUJyp7y7JN4ixnxTkfUPogM9g0GRR/kANMpbFJ4tBCc4AuC0BuDSeqUgGTXhSpLqDqb3Ph56RONv1K5sQkZcWKCzt09UKpSKLxo8sxE8dOM0hM0
 VvB4Vv2Y
 cy2iY+Ca9yDHFpQSp0XD+H3u6/wkrbjtSlgAf7cG3fMHIk7ytXfLpkifGH11sLSBQqvv4goCYKf3pSrXPHeHmQmZ+0Cyg6IyyjRPTcVEi+mWWVHp4Xa79KUKwdAbr7Pa1jwRVVKWdyLw/sPJpmNs48qofqadDIKHOhZHSYQMQQnuDB5mUPd8eUIfraLt37He2ezM4cfjhO545Iw9cgNWAJvQVvV52fYCRdojQXl1zluV7wLYNvVBl+1Tf5ug4r2Q6a47wAbGm+ghx+gMcylZaIhpVHIqd64PCTO6STU/vjAl5K8Nt5GuNTcEaX6okJjKsvU72Kh2HJZ2uQZ9JZT7z7bPhRp7XnbNLP7zOZELwVBzVcS1BlF6bEbVpMAUwC5K0/FdMvDt1mVxRlYEzTQ2nKhx2/toVNUgKvgukKcsGR5tXKoCkfRdW1eKCInbNcJEx9zhH1JyOSZNSfhfYQKcE2SmG15lQqE3MR8ei10By7O0NUPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Indeed, both directions are very exciting. virtio-pmem avoids duplicated
page-cache residency, while DAMON with free-page reporting provides a
practical path to reclaim cold guest memory and return it to the host.

This connects closely with the work we are already doing. We are continuing
to improve our DAMON-based experiments, and we would also like to explore how
DAMON-based memory reclamation can be coordinated with broader CPU and
resource monitoring.

At LPC, I plan to bring detailed data and discuss the follow-up design with
everyone. I hope we can turn this into an executable milestone, bring the
related ideas together, and try more scenarios as a community. Everything
looks very encouraging and gives us much to look forward to. With SJ helping
coordinate the broader roadmap and everyone contributing, I am confident that
we will achieve many more exciting results. Kernel work like this can continue
making the world better.

Thanks,
Lian

On Fri, 25 Sep 2026 09:04:41 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Free-page reporting makes much more sense.
>
> When I was at RH we were looking at this issue as well. virtio-pmem was one
> way of avoiding the page cache in VM entirely. But it has its own limitations.

