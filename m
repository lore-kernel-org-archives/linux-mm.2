Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE74CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35E1E8E0013; Fri,  5 Sep 2025 05:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335A88E0001; Fri,  5 Sep 2025 05:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225168E0013; Fri,  5 Sep 2025 05:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBF68E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:17:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6D5E86460
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:17:15 +0000 (UTC)
X-FDA: 83854642830.19.16460B4
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3BC51C0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:17:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K6Ak49Qo;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8LBGVGRuwOgkKDTm7vZorNt97owokEeF8CXndLMTsI=;
	b=m1nEg5i5reMtE36yHXTnA6JrE+GfV/QhDCAMxt2Qs0K71dcYj02NAwh1/iGqAea0DEjRTt
	WTDA1rAn5KmDgoYbRRhtAT5KRH7p57mNPLZNtCMBKdxuDsnhJykf3lW0TLcqQEb6HSx909
	5NLdrggXu4PIlO/kEpmNT6xFK9vx7Xg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=K6Ak49Qo;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063834; a=rsa-sha256;
	cv=none;
	b=2WsOR2lZTd5KrIUgVPRnopCRER0MHodj69lU0LARXq7LN1+fls++wIEU3CMu9/N5VsCcIL
	6jyAaES3A5CYs9MGqSOmZ5f04Ber7IVFjhFtffCyCdprHXjq9z/RNhRdWS/K86TpndFCHC
	g7I34bfGeb41DJev/MJ5Jh5gVEXnNs4=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3cf991e8bb8so1342750f8f.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063832; x=1757668632; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x8LBGVGRuwOgkKDTm7vZorNt97owokEeF8CXndLMTsI=;
        b=K6Ak49QomRrrKQcU0FWOEswHZmFkK8iI9pUdfSXXykRfRq1dGeGlb+MlZSdkEsxZt+
         D/Ap/h0ZlzzM9VnImCg9xiXFeZ8IDPXAItF+7sRvELj3/vKnYbBe0MCQBMp5WcivGI8a
         ZvVgmgp38oVrnRXE04uDvTLMsSl2vasA2ZHBzjeFJRoby48llXMBzTfdPTN8R4fAC3sO
         EB/EFTTcM/6N73zMxNXipAUlkf2wC1kMhspsUYx1DJ0XgaKKLAWzgUT7vG11AA5K0zx7
         4NyzqKIEON1NBGoFnYi3bqGxB0QE+HbLi88iJTw0nFMUDNz1sk59FC4M2eUFNCT5JQ7+
         +eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063832; x=1757668632;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8LBGVGRuwOgkKDTm7vZorNt97owokEeF8CXndLMTsI=;
        b=ZAUo63kpNbhP3mb4VqHIaTFUWtFCvYaQqP4btNfY/UXzM2zog2f28eOyjBb1V9j+8w
         hK3JN9aOsdKfVeJBGxTIkJEEEz8xvEvemR4Uz43nXz8kCkeOOs7wFdwCfyndcYAoZ6zn
         qWyBtWvUo1LS4BVHCV+OjICQIdJrVVElxv9QCXQNiNXMUncVJa43zCjhAaNPoMqBG2Uu
         CNYuZ8HKqoR6Cd0e3ugXC7u+1ByNQ9Giwi1BK9Fuqlz3Xd03/sHCJeFCS7ClG0u2LXDP
         dvl7TU7XGap00HwvY/KT6HZNM+yhTzXtGohqq5eU9eOrlo4b0DuK3aPFsyCPqDzSoFED
         y/rA==
X-Forwarded-Encrypted: i=1; AJvYcCUj2FMU0yTzHGF+J3TFKlRn7eWLCWdAG3nl5uIZ5uL1QQHRadv2JKGcxG5QVNnpov0fiArpL4JY2A==@kvack.org
X-Gm-Message-State: AOJu0YyK16IkB2x4HR0Lr3v+N2mhQQGb6MGRDPnCSqBIFQOWZcaPSWbS
	WB13qAymfjOUgj2c9T5s7Rbv6sodcU3b3ynw3FcTIfOZ7Ecp245pO0Nf/Rw9nGyWJjc=
X-Gm-Gg: ASbGncvKSDoVNibUIh3myj36kvfEPVNrgNihC19BbXc8nWT83nqH8etc9KTaNxxIPcT
	bAC+ePGkoBVmJUCIVM8GUJPlzdMh14i9y4Rn/dRqNwyu1oRFYS0Kr46+xSTw6VEZiblMPlF8oYX
	t7X8sikty6ERERrbHM805spUE5DtgHPlaudMms3t3jf74tD4F1BJbKfvDpsaAIumlD4JQMbVt4X
	e/H5dMv1naVvyYrQba6fTsdqbtTIdvz0K6sBatq2avIkC1PZNHbJDh2WUuiAlx8ecx+mhkeiB9K
	FZcs/Y3A5gLxHuxiBFhxEGdis6QN0ACB7IOAME3oBCGuJVZRdBXTdHhn8351b0OfDF5R5W6lfz4
	PxZA5FGINrHfLVxw8oJ2vqyRYn/ikETZm6O1NH1mF2JwheO0kKkgUSQ==
X-Google-Smtp-Source: AGHT+IGETV7pN3qRa7e+2EQkT+Vdj1pM0k4cAvnn4WIgtg1gqQcYYyMCwj5IJY1tnzZrjW2//6hIAg==
X-Received: by 2002:adf:a1d5:0:b0:3d5:319d:a95c with SMTP id ffacd0b85a97d-3d5319db7c1mr9949372f8f.39.1757063832196;
        Fri, 05 Sep 2025 02:17:12 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d6cf485eb7sm20721268f8f.3.2025.09.05.02.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:17:11 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:17:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	Usama Arif <usamaarif642@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <aLqqlkTpEM1SkvaE@tiehlicka>
References: <20250904175729.1029735-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C3BC51C0006
X-Stat-Signature: eqyxo9no6zdqoxzix6oh9u7fabh99ty9
X-Rspam-User: 
X-HE-Tag: 1757063833-365977
X-HE-Meta: U2FsdGVkX18ByQ/l+fRd8kfanGOmQIvXfPTnOpVq7/Qdb6xdSm3dPx9gs6vY8iBs40FhnrSol6Vx9l6yWgq8Y4VEBXUulF7/OeJPDLA5wilEcHIGqPx1GBOdzvl8vFIu4jTCJAiXyiVenliz0iwbcx3iIgrf1d6AbbW5PrkIr5Ztch4w+cha6niUEVEoBqmhYdYGY2om3glmkLTZCuFU0Lj9ROAZt/m2kKJGgjj6XxpKkK6ZkJ2/ZqtA/zPtQIKrHyJnE3qmMQfDLaDLGURHCnZt7oybDmZJoEtf8+TJ1nUcO6eKMJcqiORBVgtLAfctzZDpPCi+XEa+6tY0Ug8LMyKp899Qh+T8vkuTMDYGvoJIWFOKGNfvc/nqz2yZkbe0YJoHG65GA1fGTiATQ1Xt7xjQhzX6F1rrGEcNzETG3RZL62w18rK3Dy6eOmBBcnGauUuwK2cBCt4f58SubtzgZpT3C61jZ3DxNBWOPe9OfpTZ1wfuJFGt4NIi74vI7/WNetO/WXe6eZwm+GSbBBNhhcpuXqnEvVqqH6Z+XXkFbMycZbDn/6YfBKic/Cj9uG83C250OEu9gV63kCSxo7p56yntdJDQoF/DqnYACd7TgSwROm4OW8+ar60pV7OxnItFe3a/Zv6luAoO3MY0fCJ55LM4cafB+mXyXMkQ7ljm4ikr1N5t31BMyC7zfefreJhtH0MKuoFx9v6lt07Q+xmF5wy2FMKeWJoj+5rHb8mBNvA0EloeCdxsMLp+FvDwBabsW5RoZ3MyN4sC2gvQUIJR5fcOjfV5e4rriOVm9SNPwSCJUz7DZfMq+FvcrDnaUgiaM7hLlsAcpvAm9pHuSBC7S89tZTFSq7eOsEXi/ZGWbJ0nl/Czj3VMGV8es/ezYx7lzYUW9QTSCuSjHAASDsyVE1SlSurEkCluxtwX0uxVuIKFmqblMuiYcO3hwM3qYqik5B/olp0uVTf06w+0TAa
 uYqUZaSm
 Ti0hs0/rnlzNkR6AUXdrR7iTNUiYVm3Gf9yV1E0sTDaYt4b3JKHxy9o6+xLyY0XfetZE8FT6spnWH8qWUpikBUkUd8MI0lvYL7a9TgETMibEElMHbEaiNa5S38xG7iON1mTdw3LfmRhR6RRo30xYCXQe0Kvv9YVyAQaXWsb0NqhzA7gHQiah5eqb3QueLl6iq+xU1kxepLgVMHEj458tZJsP6njdSSDnX6VCineNrO5AIkJQFKkWQZRpTFDDK1kqbzZwUJ/3X5FoAxpydxGArrFLz3hWJmDJaU4czzloebJGq4Do6hGU8XIjEoworDEAouZ0og5mMcSD+eVL80TMoTOA0nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 04-09-25 18:57:29, Kirill A. Shutemov wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a simple tool that allows to issue an advice on a process or a file.
> 
> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.

Is there any reason to have this in the tree? This seems like a very
trivial tools that doesn't really need to be in a lockstep with the
kernel source.

Also would it make more sense to send the pidfd fd to the tool directly
so that it can benefit from a racefree pid->fd translation?

-- 
Michal Hocko
SUSE Labs

