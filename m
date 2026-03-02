Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DB2EB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF046B009B; Mon,  2 Mar 2026 14:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78CBD6B009D; Mon,  2 Mar 2026 14:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664286B009E; Mon,  2 Mar 2026 14:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 539B76B009B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:58:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 105F6C1673
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:58:46 +0000 (UTC)
X-FDA: 84502185852.14.9B53397
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 267DE180005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:58:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YJicS1ja;
	spf=pass (imf24.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEl50ABQhTqEQntCqZp4kuzeiyPggySh3JaJn5xG/vM=;
	b=iXaog9p/ucKB3tOZnKgCcwceYwxlr6Y1tBR93J2Q8EVZDzSjk2nZriUCilJt4tsouy8orp
	UGK9S/5FK+BNuJFoL1SV5+WfbQSv9DLh+ema2uJQKnblYYA6Ie8Dnl6XoSHaXaUZXp4Osp
	eeOsR4rKSibH8G+kNfn/mSFkNA3+S5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YJicS1ja;
	spf=pass (imf24.hostedemail.com: domain of aleks.koyf@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=aleks.koyf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481524; a=rsa-sha256;
	cv=none;
	b=uEbzy+UeleOo3PX8z4/zDI3zqM7VRUND3Qt2kgjp5g0c1c1y0a2xjzWsSutWRvY4fru7kj
	8shCP/+LDWCBEfQFe9VboXYy8QDlkvWHkdyHJ9eynlkvBYO/b2FlKN1bXKgzT3tx9UeGAs
	ib9tAM9LNvsV/YRqWN2FDF/9D45cJlw=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65f73225f45so7752571a12.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772481522; x=1773086322; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gEl50ABQhTqEQntCqZp4kuzeiyPggySh3JaJn5xG/vM=;
        b=YJicS1jaBHoyrizwcQSJ3Ezky5jQUyYxUQoR6/mXAJxP6hFCURVYnTRqnCrpuLYGHr
         68vxuZk0FLkOmUpN1TozCEzj8L4GHfCDrCh0UJz6V662DjI7upMTJXCI4QCn+ol5wo0W
         JjHkiY0RTa1Phbn5xd6+Iz8oTZ3VfCWcnxUOATXIc4ab1LjypyZh+ZbT+PTzTL8LMEee
         YR8pJHZhUxb22K3Xy4JyUJqkXswo3vMq9W3c9kwXAgh/ZHOlZlxgY7FVAnYtwh0WuR5j
         3keII8z3Ydk89KMqtF37OU/x9zefborLPbDfRCC2Z+ywWubEpoZjP0nzUH0nKFNkqzZe
         Iz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481522; x=1773086322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gEl50ABQhTqEQntCqZp4kuzeiyPggySh3JaJn5xG/vM=;
        b=a+FXyTC62R95ZK/xE9+epZLj6ohWyb024jz8d2FnCUqKf+Pxz6dWSIUSW5Ag1wI9ZP
         vrb8W6hc5UBIJvIaB5lUDVEFfNCM422HGH9vTgxargeoHossjiwMeE30TdIwykYJ2g9O
         tmdKs+oClYWFPzfVkR08UufdzvEFRr9A+0lMCYNZPbAe5ZonH0kNgTTQg6G0WN2O7fJH
         5tj0QmlUJ1YDDk9ogEoo132Omf+ZtmZwVvJUOmF6p9BmGgtMoejjMxi29iAvUMbiwZ82
         zXZ5b4Ubdm57M+LTDyoqQbsyetY8a6oxrSwrG/MaQZMxh1RRXFX9TJ8tqrCi/UAjzHbw
         SwOg==
X-Forwarded-Encrypted: i=1; AJvYcCW3EdphYA7YPLb3Iyo7s1nD6V4lk90gpjsbFptHlRSVwNXglihKglxBIJ3zkT/S/qX9F77ZussSCg==@kvack.org
X-Gm-Message-State: AOJu0YwaNeQi4HrDRY+yyLawO/DivSeX6qo5T+e6HfqcX2chiA9kVhap
	EWovzefdRfZkPGvnbP5VaXwzeGCwAMHLbMhWGpEbNK8FR6gbzPk91m15
X-Gm-Gg: ATEYQzzwzGEAUzZkw5dIDVKyrBJ/rgqvUfUCnn4j1dkdNI8mdpQsHnVs1+bUs0/PwQ8
	thJtcSPkZvA5u+K/vKXGZgwQS8tjWqSzzAF0UNH2By94IhQbvHkUJJqaoyr5sM2NdOtRKRliHgD
	LfZYqcGrRVOiWZ1++xT3dVvd45jW3JTxp95XTbRJjFXrSV2K1DFx2w3uOoQNMMnzv8dnqJOSkF6
	Wq4qf7jM8uQFF5MYbODOKg636uynymJNAssfyQnGLDeTStmSDchRJTAZfxScDuQgvkzc0Uj2/dW
	x0ePmUDV7KsN+lelTlMhVh3UJdXKjBmSadZ4B6ULYbHhOB1eN4XzLwSct98KZ4PBWKNephnR1hP
	GVpZ9sJTM8ZP7syeo7ruMZLqdm3ngoioaVU/nCn4LBR7H6er5HIM/Fz9CVp6bVTDEHDlwRpiiO9
	lXv5fzxliTpCOG+QXNQAyK3zml
X-Received: by 2002:a17:907:3e9c:b0:b87:39d:2b9b with SMTP id a640c23a62f3a-b9376510a71mr974999566b.28.1772481522299;
        Mon, 02 Mar 2026 11:58:42 -0800 (PST)
Received: from ArchLinux ([89.105.203.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac75fd9sm501586166b.28.2026.03.02.11.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:58:42 -0800 (PST)
From: Alexey Suchkov <aleks.koyf@gmail.com>
X-Google-Original-From: Alexey Suchkov <dywoq.contact@gmail.com>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	dywoq.contact@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove -Wmaybe-uninitialized warning
Date: Mon,  2 Mar 2026 22:57:49 +0300
Message-ID: <20260302195749.39247-1-dywoq.contact@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aaXog_u1MOGJp3hP@casper.infradead.org>
References: <aaXog_u1MOGJp3hP@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 267DE180005
X-Stat-Signature: 3zj1ui9j4ssg7ricp7ps57cywdh1yd34
X-Rspam-User: 
X-HE-Tag: 1772481523-222201
X-HE-Meta: U2FsdGVkX18l+4IRG4FkI7PCnG99Xlba6bHAxhpEChkP47rS8JXCXi96eAK4B6jYzdc39pEAaGu9FBviy7vYn+kkXUsVwtyHglgP7MmjCufn/nN5D8Xd3wCC7d5UPf5/7UBoGwLtUBTWNOelHNA4sg1hmMY4cwImw3amZHhQa3sU/++tx93yRXMISkrBVkdt7qsDRSkZhQFgXHb8Js+RehBuId5lSdEhjHpUdcKmDB5fDxN38n7Y0s2sM3Jh4hT1pmJFRgXKfhE6jZzQyHjYKTZQEOwdARC3OA3vuaRsfJ8LLWmEqlfDvcH/DJl8mq5ROXdP7jbTwP3qB15sdg+TQ928Gqbi6lUrjfLBHEiFMojuMiLmPLLeq/9RcqMD1iu3HM4BT/80bk+jXgmwNwjZD+1roEuRGbLeWnOGYv6RUkyywQEU2Z0boqE05vxSMiuwHAmpWZvGHCdJ9+6M8e7lSNNf+pDwUHOj49uzO/qLKvZoheieygMEVGKu1lHJurW8UFMmTTFbAPf/WHYH54WcVNo+s+G/13s/FrzSeX40em+bRqLFiqN4TJnh0XAKWWtbeNm8eu1OZ5i1651Ve3YjF/Mx81Rpf6ufvhNkflSrZj86r4solJSy9sAfPsIZgMzhKoJ9BHRGJSGuo1wqL+/dF2tcbtOJ+VxImH1KK3dKfVHWr4KCFuB2mt/PzaeeS27votvh2J/UkDNl6njtQSzSHEP/cT1qmh1yg2C9N1tY7HmCOmVtS8JFHhsw5nZ40zYhlO+2CDQrpVYWHqcI49uHKeWmFo/CufeXJLDcHjdJeq/XQ0XnTG8sEMXFbBbRu1bChZ1wYmJ4v59rO9qJ8joOq/MaKPB955mi14lTokoPHPu0Im+f5fUZ6v2Ufh79XpoTmxoRcpyBdH2annrtrVNm85LEnck/k5WFDN6cIE/KTsPkyiF7Vs1vfjfAI9JjKhyDLQRYrhGP+LoqZ2Tflnm
 ucS/10LN
 lPcyySkC9i1ujEYWfduEukcw7qw0hFfDa/AwwFqGCbtMgw6/051fv/ZcbrODUCTjw/t48FdVu34/6aU3vnFSjjRy9DKMCTUc19AWPyx9NL3J17HWVZm/5Sg71phQP/aPtkF2IYcmDBA734lsdPdgfozyt5dX1g7Pi1QzP8iTCp6JgyQfaMOo8Nqjr4YuP5FEn+6z6bTJhF2EjLyn+QAlpiJ1j82N3OStNyjeFBcU1BmqwXr8gacAnONfyi3iyhinhGzYckTi0/DldU0wdZzLAkv5TBnOHas9zHrbOhGc+gVnWDParT0iBsIlVvEyDThvmmG8mydwcGigHZKODCLCko2FaOfQUhV6pGW9fdlLH39Lz8IUhfLlCUucInt4vysAj9jFcessvSwFqXsWBrACNxY3n3kPw5uN6KAnME3N5K2a1If1hBmDggH5skZLWdPW94iXQ14rOXhkii3oAxmCrsKtVyyWhR92R/+ALjNzcNcMIrI41vHEFbO8XEIlb4RbKf6C7LdKC/hwsVVOO8eo/JGXd1SyfO7ZpX7DJCsvMSJZ7uqvO1DT4Nu4ybl21afNFA3LF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> What compiler?
My compiler is GCC 15.2.1

