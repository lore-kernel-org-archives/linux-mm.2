Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DF8606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KaItu4cW
Received: by kanga.kvack.org (Postfix)
	id 7CFE16B05B2; Mon, 23 Nov 2026 13:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780F56B05B3; Mon, 23 Nov 2026 13:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F9C6B05BA; Mon, 23 Nov 2026 13:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 40B256B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:26:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5355C09EA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:26:48 +0000 (UTC)
X-FDA: 85467214896.08.D6515A0
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id D25D314000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:26:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KaItu4cW;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795458406;
	b=DdfLd51My+QZ/4RwbZCXomRGyQ1QMg92KQjbOz1BjD7iJ0qAA1osw6iObYMSRPD/yi1ca4
	h4L1jg1pkym0a0rSc+SRCJxzwIwnESetd3dSBQoSgF/j+N4DmxbY5dNFJqHfeFNmcMDlVN
	SDscmKbNPk3E89fI0e2Qgt9MWVGIZzI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795458406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thHuqHmooBy0uGsMcFJyj79jvgcNxfQof3z9Kg8ZrOQ=;
	b=pO9Ls0kahFMJLt5ZZAd9nBaWnemzxgwf57BXRRcUNgJ0t09oPj22jgwolwJJ1luxqhgpMj
	ezzLkbIKion2jxfgp50cGp6+bCkq44/N6vWE6Zjd9ipf2X+36TIL+3F8Iegeu9LXMSzilH
	zRNrZa5731JZVTIndAHMha8tfgF86i0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KaItu4cW;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2f03920c4a0so22946425ad.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795458405; x=1796063205; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=thHuqHmooBy0uGsMcFJyj79jvgcNxfQof3z9Kg8ZrOQ=;
        b=KaItu4cWsOKCPQ2tOuUpZkw/V90OU5WmBZgxabUv2mQcI3Q3M3EwsTsy89d4ulm5mx
         F7MkooBD75b0Qw7P4J7fcuetNn2JXuRy6aEIVI/LeQ6B9Emnx/0m7w5UZETxMnqDTfyI
         rYloQZq2c4+MBk5TaOKb62g+YnjkyWX8X1/m71kQJAtOoG8elA21bmv8hFfPRHXJ27Do
         QTVqRX08FYnqKqyPYzoKHCSY9A9NcEgX09V66Iimdn6WAaQL5iOFkoxXtNCdeF/do3Sh
         tcxPMj+2lmE95rPoQEAMUFTkVI3FMwBls7A4RpMgAxDfNsVQGLoXGOAFNwCK2MY7h9Gk
         SvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795458405; x=1796063205;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thHuqHmooBy0uGsMcFJyj79jvgcNxfQof3z9Kg8ZrOQ=;
        b=G6niRb/8qtJ5I7Yk++tPS7MrT1F8fTlljwUL1XvCA7orSP+gNwXErnkWte6ysJgIo5
         ESN2BgMNN0ou5LRlroIj+Nkqfw62EEzYif9WCh7S/SKErQ9KX/WJmRq5kVR+X03ht/gT
         cfRLoXgQlAMzaf4YzneEAwrWtHIe4/JWLIjgxG3goCV3C+K+h5f0mshpwv1tByRJY0OJ
         4715C9WHnCZvNCyD9qhgUG+RUjn6JWlXhumC6MUIpqtI1SIJIKCMW7z/B/Rx9XQKwDsQ
         nJzFrXly7DDqR8ZXpYdQ2xyK4Rgxcjn4pLFd2x4SJoatrtFCDNT0+DROWjfaZMOqcJYA
         Cobg==
X-Forwarded-Encrypted: i=1; AL+hErGxudJjKAt3n1L4QVA06tBJXOSLA0nC0EOtAivr2z6egpzXj09nAtuxY+p3KV1QoW4Iw+22AAcWuw==@kvack.org
X-Gm-Message-State: APuU4Z/ChSH7QYB+2nAxb1wqP46wdwrilQqWvx6wm1FmPIzPc9ye1I9q
	HE3GBQZ6mRD0Ab4kbnU5R93UnDW0YWW+h5dkozUEJt+HFpk5VTn2Z9BSRzVnyf72sg==
X-Gm-Gg: AZFdTZeofmFZP4TM50xqehGKs3flkWrh9TOAILNCnyJZygvVDbzRW6Gl2wCdfnXh7DD
	TG9N/8h8XrxgwQ6IBJDIyazg7Sizn+edgbTs9Ixbcdni5vJBvUycD7FHon4K9UT9iKoxPIWc2/U
	hMqo+dLZCbJ1J8z+80tTqbcMl7c54McOSwKPAfN8X3cmM1mXndsx6vE9GUEux0EIc/EIp7a8R73
	tmCcucwADCubHdAbA0ivw8xYsy2hCZLYT2gytJdglQx5rKIvjjaDXaWlj49dQUvvtZE5UZOX36T
	cWrvnbNK3L27goEolKWVoqfV1+XnF7532H0bGN6JcFTcKlP0TaJG+hmaqSj5c1/kwkcxKQ0D4m0
	iyJ3HG13EPTcapT/22lqCJsycIZyDLjaWTwm74f9VCYWOydYPr9yyD+zXVWYcFQaNZ+NEGjcgH3
	T1P8bw8C7EIrPAvNYTixVqaf2OCTurM7KFqFUvAjNytZxrE9Ai60zN8aQnFf6AulRaP6jV93RKQ
	Eu/NqgSvqgcjpYw60SL1zjUb6emc9681gUtIU+i1zrHKUawrTiH55go5vaxeU7sNlaqPDUNifKd
	88WpmD7pr/QRIglwKnDFh8/jv2qiyiyvDtwj58RZ10dENs4+U9x6WkEQ59Ux2028nA==
X-Received: by 2002:a17:902:d542:b0:2e9:6790:212c with SMTP id d9443c01a7336-2f03f190776mr120496345ad.30.1795458405057;
        Mon, 23 Nov 2026 10:26:45 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f120282sm56755105ad.59.2026.11.23.10.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 10:26:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 10:26:43 -0800
Message-Id: <DN2SVVWX66U1.37JRVKARDRNYN@google.com>
Cc: <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-mm@kvack.org>, "Alexander Graf" <graf@amazon.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Christian Brauner" <brauner@kernel.org>, "David Hildenbrand"
 <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v4 14/19] selftests/liveupdate: Test which tmpfs files
 can be preserved
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
X-Mailer: aerc 0.21.0
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-15-dmatlack@google.com>
 <2vxzh5hb1sqo.fsf@kernel.org>
In-Reply-To: <2vxzh5hb1sqo.fsf@kernel.org>
X-Stat-Signature: brz9w43drdqeb7awmrouxxx6h5qj41zm
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D25D314000D
X-HE-Tag: 1795458406-49498
X-HE-Meta: U2FsdGVkX18t2TOryPaOz8QBpr/ultBtJ003cBsSaa473bJ+U18jcn3d7T0pQO251Xy4Xf6oE8OCpDRXabbYJ2N+ub4U6akCYBOEFgw/E6QiZwbWzNl3eDver8H4okeCO6MTN36hOZGqdMfxQaB99N8yKT3q+oDUD4QAPP+OPMjn21/1TIg3t14Abm0+JVDylcxPEOEDl+X2bNBdxyd+o/ImDQ+inw9sF/zVMDiia2bp10kHvlaOH2IuGY6NreChYfdV1MtFxFu+IAtJkfwZVk7eQ8b/uGfAuSvXM4aerBk7+BrmG76H2r5fxtxV1wHL8fYVIMk17HmR1qcNhmW8KWampjolK8XwrUiRNU8tYjEkHSB9mekqQo4VJAlCsHukUhomNMw3C5xycXS5BJgvCoxevaA3cx5WAre3v+459T2L9u6syn2iEzKxWKrX+5yT/H4aQHW3MY4wQp5SKXICNG25OxqpUqnbcSiX2XQbm/ANI220gIcJof2Z3AqjpSoxcB7eyqvrI7r0Na2E3ql33m/GNbRuXcUS196UCqT5mCIx4TPafwbUFjEcYWcvmAjvkspPmihuqk0tFX1Iop4K3khwfGEpNcqP6ZDxAvJMlpQunuZZ4ggMP4F//yAU0jdL2eaN2mXhTyd+JbVggDfg0kCZp9oxl2wn5ZDkPRqYftLY6CImSAgVes4hdiE4DjS85bH/aKUI1ChC2UnWEmSAqcB4uMWhB2SosrsCpalJfwXs+a1vhZYuy0n+6ujhU0wmaGc0iUPC6IOpKQCqDQJznmPJlL/6pQtiLbTkwG3v6hfu0f8rPICbYgLrlMMUlASaRwPB41UFCXRRXWJ3Jfc/zZNqiIWRUhwn0jWa+69CwsjLYYL8Xpqoy9Wuda2pgkEBbjbL2DNwxT8/S405+cGyh7FjBqa24Svvb1BeRvYSHOAAyhL6Mk50iuILHGuG3up1KJIHRco7rlOjQfwXRkh
 t+1Ns+UU
 ByChU745Z8AUsha33qqQ1lCIQKdUvjcdhyDnV1YLPPymjZzlfI9X74dQRpRT6Cv9pcdfa0b0RYzivruWNklOAkCOsPGyfssNXcEYtgTPsaMd6IfIKyEFgmoNT65Af2In0lWjD/Se+3+tU+645jYHS1eMnQfdcJ95In3GTfDtHMcB9+0jK53fqwPOBiLK+SJTb/iDVaowa5nnPk/g5F9fUIBHi6pBW+oQj8nWQ1UoITV9t7ZqBCtOvFE7RKx4DVpGHTQdBo7k7pqF82X0iQrkBZBRu27NsUvAmfXVod4st2eAzT8O7pVQ3z2s2BzyMj7lNTzMB/5H3IC9xWy6HDxm7i4V5ESO50Y+MJ11qkzbOnop1T3M7VSFR1xUXGjsGzhneZ/XNKK80HqR/7kFiWmzn3bhJojAvl2JzeiiBP90UFa9w/8BQIAk12NQS+CXlt5AXspmgVGVvM4j5aIl0k7HGCFbqyGWUsvDzSkgy2iMXtGbE29qg1HXnvOrtxhShHqBNTwQI0KQ21CGz8Pi99hCxr9ZBkxma240gtkCjKNk2Ono5npHbUZCrRJ3XhhwTDMwe1lCUYoEKyUtT4oDjWHiTY6q6ClBDsi3eysCBcSKfwfGZqhUDdBR9XWN0EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 6:29 AM PST, Pratyush Yadav wrote:
> On Wed, Nov 11 2026, David Matlack wrote:
[...]
>> +TEST_F(preserve_tmpfs, frozen_size)
>
> Nit: This test isn't really for "frozen size", it makes sure a preserved
> file behaves as we expect it to. So perhaps call it "preserved_ops" and
> update the comment?

Will do.

>> +	EXPECT_EQ(ftruncate(fd, page_size), -1);
>> +	EXPECT_EQ(errno, EPERM);
>> +	EXPECT_EQ(ftruncate(fd, 4 * page_size), -1);
>> +	EXPECT_EQ(errno, EPERM);
>> +	EXPECT_EQ(fallocate(fd, 0, 0, 4 * page_size), -1);
>> +	EXPECT_EQ(errno, EPERM);
>> +	EXPECT_EQ(fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
>> +			    page_size), -1);
>> +	EXPECT_EQ(errno, EPERM);
>> +	EXPECT_EQ(pwrite(fd, "x", 1, 2 * page_size), -1);
>> +	EXPECT_EQ(errno, EPERM);
>
> Nit: Is there any point in matching the exact error code? Wouldn't
> checking for a failed syscall be enough?

The documentation that patch 11 adds to shmem_luo.c says these fail
with -EPERM, so I'd like the test to check that. But you have a point
for the other tests in this patch: the documentation only states the
permission rules for preserving a file, not the error codes, so in v5
those tests will just check that preserving fails.

