Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F69606A338
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=iHs1UZYU
Received: by kanga.kvack.org (Postfix)
	id 4B3CE6B06C3; Tue, 27 Oct 2026 07:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48AD96B06C5; Tue, 27 Oct 2026 07:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A356B06C6; Tue, 27 Oct 2026 07:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 142936B06C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:39:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7994F1409B4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:39:01 +0000 (UTC)
X-FDA: 85368209682.30.9DEBA17
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94EAA14000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:38:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iHs1UZYU;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+Atfl0mBNQeM06asehTHilVxLKDUF0di9X4yTUCxIk=;
	b=dpCaCjHPJVxjRJspBUNYMsb2j69K+1b+t3EDXnvTC4JJOXCDnR2cWysQiA7Jk1m3zS9OPt
	rD71ie3sN6xo/bb6NbuggZEpKFEiEYYz4PbYz2KAWImSCv26FLLkPV664o6H0Q7C2b/lTG
	nWpoYJO7Ct5kgfRGlFSjW3UlYN/bMvQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iHs1UZYU;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101139;
	b=7uJNCQnk7E4S8c6zqbQz+kiIWNPxqHjSUE5RbWcBp2RLXzsng4ypMnd/hF71pwh4j0mgPb
	Chm9jHlnxjy6jyEuvJ2dwtPq0jsQlPMIJnpC0kO2Cu4f/cIlgkYK7LVZCYmz0KN1VkpiSC
	77LSlbEnu/MhE0+zDF7V6BJyEAxvs7I=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93f3c616c84so330736585a.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793101139; x=1793705939; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=H+Atfl0mBNQeM06asehTHilVxLKDUF0di9X4yTUCxIk=;
        b=iHs1UZYUxFnG4csQ+f1gDYlw4DYKrjRTwzmvR7E0DPh8AvlxNN0aE/pjadX3Djdgqv
         PwDbXRFtPdasi2kqirthtWakJor0JHfNqL9gG8zv1dMsj7QY3alok4go7i3xqHJpFxOq
         E4Jnu/9RiAIr7rKuYt3Qyaed6TbYe7V7eVKikhqz635/0JiPEKbIGZEmCNPUDn11VyOT
         YHI0B4dKl0geYVcP7GnetchJnq82Ai2CKqU9+p+tBJ8UzzVtmAaQNJWkGPKw6vdwqcHg
         /vQjGGBXRmvzWL53QrUD2hqHTcA7MLAYWirJr/dzxU7pfyhipag7ajL1+z8jabPwqrpn
         RbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101139; x=1793705939;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H+Atfl0mBNQeM06asehTHilVxLKDUF0di9X4yTUCxIk=;
        b=EumQXm4qJ93/gaPuxe07QcTLXEtFk+YOHtTJhMwX2MC2RPgGPn30iAELBYMqGZKC3S
         RDBm1aPoM89s6gbKeqUCfjjojALVHNCjbdgtJOmYnjBCvMSWBB8DXKspK4Xdey01rZM8
         HpT/mopUyjedr4/FtXoK2gbR/l3/f2TwNQY07Q8O45LBhCd6J/6lykCHN7JpUrR+UvoK
         RTnKGIDyetcNUe3j2Ar8ToTdpNw3H2ewWb9ynC92mWPwgE8mP/K0yh1IbU7WG87byvxd
         NlXKOC72c0EYBsL6Laf0Dnm217bDnV1L6f1XEW3zCixBW9mXEsAGycebixFNlOC8jCb3
         +xxg==
X-Forwarded-Encrypted: i=1; AKwUvByy6Fym0G884GyGNYdOyw9RwgdDK+wPquCTP/unXim9cTBsQUBJXR/mjnlBG/BbIgYE++wKTGsIBw==@kvack.org
X-Gm-Message-State: AFq9FYIPsKmr2d0UlsSxx92ihgJUTx2lBm0EAwBJ7jYmQJ4ajxMScxvG
	ObDQUqD3chydp6WjwLgZ4D6DObRW7/Ivhn9g3jVbDVKGaOiuXPH3lRZDxgPVPahOCCA=
X-Gm-Gg: AYBFou3TzQjNNaWxr7jKSB9MU0ZxvRY4IorcNx5SjwXeOq+1HmXWTTO/I0MmtA7D2rn
	H1sIQfoiQxj99lp7yZ+qe/2iRfJ78pjEYUxvqUOGXy9bIe7DiC14+Bk0iABh6mAm9XZpVpDsOR9
	THbg7koA2OOXiSXU6i2QyoWET/PseTlzad6T0vq4GR7eeK5ctyDgt7SH6TxJbdeeir5WHnmgP6W
	3lSApl+gJEAb0YxsItGurTa4Gttm5c8CdV1rMhRu+zV+0dPwFMTQij1Jtt239yvMVkswD61r47K
	FTmCLTkdFUtTyIKhrBXIbggkgkRxCzrSBXec7olMoBtceXpY5DZE2hvL35R84ijNS5dLRAqmMKu
	w4JWjnUy6lZbOsFE7Ob1MP0KY3upEG/9H//uq59UxMBDZprByQpGtXCZx/i0E9aljoG0lufoipT
	wMLrpolvDeQ/kVeFaNVnyaZTTtVQ3Xlm2GqnLerLRk2AqNxjgg36ymXCMyTPEQ43uGB2/BX3CcW
	K2WcjuVssX7aODp+JWKSV7pshH0YWiGUXQ94r/bLVRJC1MJOpve7ShoWFuzW4qxWoNXF7Vkdjnd
	twW1uQ2wE/9qpCpgvu+2YqqdYdFgyZi/QGlrIpy64RTK8xpI
X-Received: by 2002:a05:620a:271d:b0:939:31b5:4e08 with SMTP id af79cd13be357-940ef6833d1mr1340746685a.0.1793101138749;
        Tue, 27 Oct 2026 04:38:58 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f05b1adbsm951301585a.4.2026.10.27.04.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:38:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/4] mm: avoid losing atomic VMA flags
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <auBh08P6GPQEHPCh@gremlin>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
 <179306587687.1925990.13855179558376532702.b4-reply@b4>
 <auBh08P6GPQEHPCh@gremlin>
Date: Tue, 27 Oct 2026 07:38:57 -0400
Message-Id: <179310113752.664110.17071676524925981820.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94EAA14000B
X-Stat-Signature: srzki94qucqytgduanqpiojkqi7qzx4p
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793101139-241824
X-HE-Meta: U2FsdGVkX19vTtnZmzANx3ahnomomjFqRdySVktXxFlCzHmNKtsQMHPMqM5S82tk9X9O42dQBlUitL6YFl95+tnuFiUITyDWnXXqvBC0XcjGN7qXOXZQntM2W/vy51PXPqy/8OSxvv17P+5WpMtpbeJ8q7EFi4uWG7CpoK2WHZ35HHxyBwO2KECzA0X0YiNVn7CJVx/iqdr/dtGhRfvdKasXUNGlallhTDmQCVkxuZpBqpxCgdwZyMon30NtlC6CbNoNr9Hfnmif0ZUfE4vrtZhQk/SLouijSU3Cmuyw+sdCQQjvgfcKsXijqNURBHyWCpOa2f592izMwwb3hzRqRFtblFtn6zjAn/i7e4WRElo7pcM+G6mPYmzPXaMzRJqyIi57G2dyk95FkjWJiCnc1mofGrqsO8b4fCQnCNADtwHnkAURYkmfT2rheoiEyTZQybiASJIEDNtpTLrFXtsyl/srH7g9cy9Vlxq/DBFvoBF1lVj9MegNTheFd7PgrM8N0N1OzT0RzVCmsRwuOGg4bEA+fEOfQ7LLYCrzqdsluXZ9WgfZxUwZSbD8eoeGujmTWghaNo8v9wMeifVpbAYJiBf6/gLdjFmC4GzUKgJTj5lSavLj4G7+Lhzab6iq9GMys3NU5NcgYR+2qOdV2qYodRxuji2ROfzH1u8GOGeKpi5jKL/xL/Atye3hmwFHEdGkyw+uKzlZXgJrXQcybvB0pEO0TioIdUm1x/sVzxYCS2kpAcnVGW4Dr6sOtCae2iz+bMTD19hTQ+LepCvUqnFeyDplmDYYlQmYlmqh60ylbBht5MLGhiYlxfK23Xekk0oSwqYFN5M4oCnz568BbZKijSfseNxtUUUWT4U4ekB7jynkS+Jai49it5poRC4/tlDoecMeRsVG83yvkcjj3A67T9qYuiWVu5XgT3m8hXm7QuX7+GeGosg5TerqKE6DH/Y3PiainmhOek5FCujh6Cz
 cEXy7zca
 ldA8hVIavroHF2AzzJ9G2th8CS0LiAxATm1ak/Wb1/JBa5xkj6QZ8WXAEhT5wDzE30uJYb4iF0YzBIHkG2qrEobyN0IvKGtgzzC3hZDj8QcF38VdgIiVPwIqnQx5uLwKpYv9LODfcYgsDyOVvHUFL4Qw16k4mAu+hDJ35sCX7PLIwM/Mn2jJDAE5NZsxaPLwfTPFgeWcn0rKyw9b+TrLMutFe8cewduGFO+aaZaV949n9uG/VA0hkZ6FfBhog7xRzjekPxmwauClRNnc1ursSyo13bUZiyqYXEtsgbRUfLRiFRyZVgYWy4CO5VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 08:34 +0000, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 26, 2026 at 09:51:16PM -0400, Gregory Price (Meta) wrote:
> > You too get to be the unwilling participant in my schlopptesting
> > experiment - but the good news is there's no issues and you win
> > tags and free self/unit tests.
> 
> Uh oh...
> 
> >
> > Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> Thanks :)
> 
> >
> > Might be worth taking the VMA unit test below.
> > Selftests... maybe the non-race uffd one.
> 
> Lazy-lorenzo, but could you submit your test schloppen as a 2 patch series? I am
> behind on test-writing given the surge of fixes...

I'm collecting them for after the merge window, but it was worth getting
a visual browse :P

-- 
~Gregory


