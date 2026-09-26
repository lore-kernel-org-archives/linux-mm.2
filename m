Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991A4C98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 07:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A125A6B0088; Sat, 26 Sep 2026 03:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9896B008A; Sat, 26 Sep 2026 03:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9001B6B008C; Sat, 26 Sep 2026 03:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DAA66B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:21:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC72F1C3676
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:21:35 +0000 (UTC)
X-FDA: 85255068150.17.E3BBD33
Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25B3D140003
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:21:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l3ayqn8d;
	spf=pass (imf23.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790407294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/ldK4ouh20PCbYhMUe4lvWnC4R67j5o9JpGKQtocEA=;
	b=fIkV/YALQRwEMLo3qZXiiIHlh1IOAWaH+VQmTGkWE0tF5o5Ap2fV/g5FoQrjYZJdmbfnjU
	+rZFk8CSR8ukKlaTP8Zn8u4BAW22Qnh5/stF3hwPLNusjvuoz6k+FkL16U0UlEMOjV0ZTv
	mHqQ7bt9L8xJPFcK8TmmQgkv3U6KoXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790407294;
	b=EpNp6vmMPhWQvaXl82IpXf2WuD7d+XLdLLDPDAoctTm7R9O2k1CMxQwbAWLbVjJCKhYkDh
	Wq29eSg0kA4SNQ1eM6aMxC09ikZPqzSkM0r2urI1sn8ZBlmTE1wK0j812SAxGsbPv19PNh
	Ax85ab2hqw6+YN2bS3kZNTOVX7Huub0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l3ayqn8d;
	spf=pass (imf23.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.228.40 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f40.google.com with SMTP id d2e1a72fcca58-8804b59404aso620269b3a.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790407293; x=1791012093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z/ldK4ouh20PCbYhMUe4lvWnC4R67j5o9JpGKQtocEA=;
        b=l3ayqn8dGDgp5UZxp3H3Jbt/4VqVxk/b3ZAx0niTAqoMPmxjGBhJVOhVmOZMnxWlJh
         jGodU3xHIuC7HgPfwRhFhxWaR23rgItzBm0YvyvyqBrYpkuGDzht6Mj5QVw0gLdU/o9b
         8C60dDBumtTTvVkezjiNS1T64u56TzpfQXMQkzogk6MgfHPkjspglIaf0c3vChurM9Gi
         lO3famNduzQFu+J4gouV5nMHKxBXhA2Q61+od/BXXGwM5cafiARzLuxsGcIwRmZ6f5YJ
         zpUje+fzaIoLYN2ai+AccmsWpwVaLZNxH7d/RtEniP79EdSNbLk4XuOAlkOCwNhCn/Jj
         CzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790407293; x=1791012093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z/ldK4ouh20PCbYhMUe4lvWnC4R67j5o9JpGKQtocEA=;
        b=2lrJZ2WhtQ9yJYqHpEbhW0xV4v7gc1wbpDi4O4F81G8pPRiKlUhyd6UMiDi+NYs9m/
         oTWuBH4XYgvNpf/iizN1BnJMudcPAW9lltRJjSurrAtj9SOdlpz1u9c0gTEktUDNEPgf
         tEIs0WXNhFvABfgopOiN5Eb/e4hx5H0HZIAZR/r7aGuLD4z8vuV7+/3BZUaqLPQrg0aU
         zCMlCuKj4+qSupFQf5Ldm7gEpccvzT8jfGZIA7EEv4qFr8OBtvDadCXDkxMx88DsfegH
         WOw8L/TmhNw/eBhcpbtIo7QSRqxDo+QtVPmTSwvhnCRxpBbPFenuoLV9CYd28wHI4AUl
         TJbg==
X-Forwarded-Encrypted: i=1; AKwUvBy1f1Bjm3D6jOOnqbci5uhoFCdJpuuVF0t+xTntbzztYAgv1u4rFmPu6MlOv8tK3ft+MDhVFfmq9w==@kvack.org
X-Gm-Message-State: AFuF++l4ehmfIrj2H2O4HWMCM0SJ5UZZjMuFKAKeWTK4syHEmuT0Qff0
	D3svd0qyq3eUHeHpF0iYdqUTnQaOqQ++eYydMp0QyL4T2Qcfnzazapw=
X-Gm-Gg: AYBFou3GXGJNdP9vrsXKJZxehq77ANLST3a4etDD0eKllIebrCS2ZlwOfsedzBIsPML
	YzN0DqOUcWt/Y3VnuImX7kOQpZdzJUx/Kg+Tz+vMOlbkRYDflxc11Rwahp2XuC6mb+CCbZmUY7l
	F754y7DgPo9QRp/+tKftYgS4i9fGvFpnCwBZUrPDVfs7XXUIbyq3sZgXvvmTgoiQrQmQyY1mcu8
	Jr8elBEQ4lOND+u2DzLvJ8mxM53wJzbadjRZJdFhj/M3XVY62ym0+Sq1xbjgZ8L1NtNIOAIJPxn
	agkbXITHzrmHQ1bxnci1mMvpYKd0I7LCZKAB9BZhrccsNOutxNM0upHjGpu4NUHFQ+bPO3z1MF1
	r+zfnuY/MmgYZh2ecfcdkG6rFLhRIDz/7A7Jq4kH7pvc83ZZd/1d7H0nr5/9B9TFUXIBnClLZu8
	eI5BHTWY23Pzq5MLEw1eBvGvl0kJbuxIfm4IpfeYu41OSpbNf5qOUJUwKfiEL6fo1ePl69pETDy
	nZUdTGQHlGWivJjxyZ/7firqQ==
X-Received: by 2002:a05:6a00:7585:b0:87f:dcc3:62f with SMTP id d2e1a72fcca58-87fdcc35542mr3183334b3a.60.1790407292877;
        Sat, 26 Sep 2026 00:21:32 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87fea8894d7sm2002115b3a.26.2026.09.26.00.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 00:21:32 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap entry
Date: Sat, 26 Sep 2026 16:21:26 +0900
Message-ID: <20260926072126.2870142-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <226ec797-ff8c-4465-a682-21c684a25021@kernel.org>
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com> <20260925042907.2330519-3-donggeunyoo.kernel@gmail.com> <226ec797-ff8c-4465-a682-21c684a25021@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25B3D140003
X-Stat-Signature: 763cptpk55sxz16pyqb1pm3gea6csb8k
X-Rspam-User: 
X-HE-Tag: 1790407294-42563
X-HE-Meta: U2FsdGVkX18aRd+FtugMOZE8k/vyudWfqr/2A8KE0NxoCnzJFFKQGevuFNqXb+3xZpHliUdG6SsCAChuC9iLjPoJCQqeGDTxBVUKCfdK+y1JOPgCZSXcb6Y1RuRJMsl3orgEPWEgmF4AVcDgD1Sz5U6zMzPkVQVJ576itgRhN7k7ZGYVFyAB33abyDDOdkyVBAsKBBSfDvvXUbNuA8M+Zxzgrdgd0vQ0nIhf8PYkJEWI/ugjRyU3LajuO/wVnYgcDfnav97rQY71t5+OivvNZqFifKk29Ry9laiyiUowwyYGGaUU6WBu06chSWQj3wfPBETjOoNJ4Syiw9v4so1pC1vm9U0Xaa2A4XJKHU3e86Vhg9GJHCeHN6fbZ1BgCn6oHO/hQdsDLoNeF/DL9KducGVjOIBYKtVmni6pKrajYM/Bh+Fz1EHCnRcSoaijWQqZ4J7dzsaSyKUPOybGNpTihv2EjoZZ/qfU/yUWW1uIn6yXh/HU6M+P1ODfbWdFXPYPQ1Zr5+1Q3rsaBS7qOmZDflUiOph1AN9lKbTL0K3c6ZXAZUFN5oUheyjL+N/3Jjls7w4XT8wajX4+PFwJM6ZZslp1HXXQj/ZHiLu0NOiUEPTGH3aM15rQkaUzqFSAV9vF/eyNMvq/HVQlpSlsKjjwRpTZaLXNuT50iwx8F+ce7RBcueCOsnV9D5z9IDJdfw60aISOdtpNkPsTehiXbkHFRTxaVNAvUqaH5QD9+75YIrTyGuxQ2kNrtpoKuq+C1mAuYTbshswBj7RojXdaMzt2aKPtkl6jl6XonnL1vk7Ypuuz6uNRDE3OUIQu3c/rUrxf5v0aS4GgowV6j7W44a9ZOis6WZzA+mtL60w8VMG5C5sxScgNwuhGjnxGF1P8DlnuG9Iejty3EuJYUFRzuWsCcLt/lVn8tAGz/O2R9e6kqjcfY+YC50/Pb7eEy16iNYvnFHYvY9Yh51goBRwUp3O
 wKuPHZWT
 ZS9gMC0vqaF4KLqsL1VYnWp4DcWjblhkYLWHVtwLDYqDtdYap1LegU0HoeqxAzdIqvC37LjzEFBzhevs53HdN6nCeviPir/pMEP8dAGcWEj3VW3OMHcAkRzEAMkIWE5jRbLJTm8O1iPRsiuSLwD4DwqhtRO1SWMBIkQJMhTUuaMUByZq9DHBvbAyRSo00ZNVP5Dg/MVYX9vy4jIUseXlq3p208O5DaXGDthiE8ec0YfohOUjCLwis9XjLC8tqEB7aaYp7VnIm1t26QtH0rxyoOF+q5M20JQvjYcbHDxmUZ3+MG09lfxEqR553cbW3VoXa4KKIjMeRYpKc4y75oYTgPtBLffecSAqK1G9QAZqyT0zDviWQKS2BGoMAmM+lO0GjtNvnjfBmSxuyIH2F4enaXyds0Rxi2Iy/kWp+1ELdjkgH1RSfvi8fGkTl9zfgSScfeV3dMf/xEB74DXuOjH5qda8BBc7wBXhKgpa6mvWD7NW3kulpLEldewzbwz/O5eBy9/v0iimRtKhy13ig7LRqbyaZ1dSpTR47IHaZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 25 Sep 2026 09:41:24 +0200, David Hildenbrand (Arm) wrote:
> Is this loop really required? I thought the page should just be unmapped from
> the page table. It might still be in the swapcache and under writeback, but
> that's irrelevant.

No, one call was enough in every run I did.  v3 calls it once and skips if
the page isn't swapped out.

> Do we also want to check wrp? I'd assume it suffers from the same problem (did
> not check carefully though)

Yes, it does.  v3 adds a move-swap-rwp case, which fails without patch 1
and passes with it.

Thanks,
Donggeun

